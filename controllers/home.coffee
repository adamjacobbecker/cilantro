Account = require('../models').account
Transaction = require('../models').transaction
Preference = require('../models').preference
fs = require 'fs'
_ = require 'underscore'
hash = require 'node_hash'
crypto = require 'crypto'

exports.index = (req, res) ->
  scrapers = _.reject fs.readdirSync('scrapers'), (fileName) ->
    fileName.indexOf(".coffee") is -1

  Preference.findOrCreate (preference) ->

    if !preference.encrypted_encryption_key then res.redirect("/setkey")

    res.render "home/index"
      preference: preference
      scrapers: scrapers

exports.setKey = (req, res) ->
  res.render "home/setkey"

exports.setKeyPost = (req, res) ->
  if !req.param('key') or req.param('key') isnt req.param('key_confirm') then return res.redirect("setkey")

  Preference.findOrCreate (preference) ->
    preference.encrypted_encryption_key = hash.md5(req.param('key'), req.param('key'))
    preference.save (err) ->
      res.redirect "/"

exports.sync = (req, res) ->

  useDevMode = if req.param('dev') then true else false

  Preference.findOrCreate (preference) ->

    parseTransactions = (account, transactions, results) ->
      if transactions.length is 0 then return saveResults(results)

      resultTransaction = transactions.shift()

      Transaction.findOneAndUpdate
        _account: account._id
        bank_id: resultTransaction.bank_id || (resultTransaction.date + resultTransaction.name)
      ,
        date: resultTransaction.date
        name: resultTransaction.name
        amount: parseFloat(resultTransaction.amount.replace(",", ""))
      ,
        upsert: true

      , (err, transaction) ->
        parseTransactions(account, transactions, results)


    if preference.encrypted_encryption_key isnt hash.md5(req.param('encryption_key'), req.param('encryption_key'))
      return res.send(400, "Wrong passphrase.")

    scrapers = []

    for scraper in preference.scrapers

      _.each scraper, (val, key) ->
        if key is "file" then return val

        decipher = crypto.createDecipher('aes256', req.param('encryption_key'))
        scraper[key] = decipher.update(val, 'hex', 'utf8') + decipher.final('utf8')

      scrapers.push scraper

    if scrapers.length is 0 then res.send(400, "No scrapers defined.")

    for account in scrapers
      saveResults = (results) ->
        if results.length is 0
          return res.send
            accounts: Account.find()
            transactions: Transaction.json(if req.param('account_id') then {_account: req.param('account_id')})


        result = results.shift()

        Account.findOneAndUpdate
          name: result.name
        ,
          balance: parseFloat(result.balance.replace(",", ""))
          updated_at: Date.now()
        ,
          upsert: true

        , (err, account) ->
          parseTransactions(account, result.transactions, results)

      do ->
        if useDevMode
          saveResults(JSON.parse(fs.readFileSync("scrapers/example_output/#{account.file}.json", 'utf-8')))
        else
          scraper = require "../scrapers/#{account.file}"
          scraper(account, saveResults)