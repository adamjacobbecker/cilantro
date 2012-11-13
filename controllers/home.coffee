Account = require('../models').account
Transaction = require('../models').transaction
Preference = require('../models').preference
fs = require 'fs'
_ = require 'underscore'
hash = require 'node_hash'
crypto = require 'crypto'
async = require 'async'

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

    if preference.encrypted_encryption_key isnt hash.md5(req.param('encryption_key'), req.param('encryption_key'))
      return res.send(400, "Wrong passphrase.")

    scrapers = decryptScrapers(preference.scrapers, req.param('encryption_key'), req.param('match'))

    if scrapers.length is 0 then res.send(400, "No scrapers defined.")

    parallelScraperFunctions = _.map scrapers, (scraper) ->
      return (callback) ->
        runScraper(scraper, callback)

    async.parallel parallelScraperFunctions, (err, results) ->
      async.map _.flatten(results), saveResults, (err, results) ->
        res.send("DONE!!!!")

  runScraper = (scraperParams, callback) ->
    if useDevMode
      callback(null, JSON.parse(fs.readFileSync("scrapers/example_output/#{scraperParams.file}.json", 'utf-8')))
    else
      scraper = require "../scrapers/#{scraperParams.file}"
      scraper(scraperParams, callback)

  decryptScrapers = (encryptedScrapers, encryptionKey, match) ->
    returnArray = []

    for scraper in encryptedScrapers

      if match and scraper.file.indexOf(match) is -1 then continue

      _.each scraper, (val, key) ->
        if key is "file" then return val

        decipher = crypto.createDecipher('aes256', encryptionKey)
        scraper[key] = decipher.update(val, 'hex', 'utf8') + decipher.final('utf8')

      returnArray.push scraper

    return returnArray

  saveResults = (result, callback) ->

    Account.findOneAndUpdate
      name: result.name
    ,
      balance: parseFloat(result.balance.replace(",", ""))
      updated_at: Date.now()
    ,
      upsert: true

    , (err, account) ->

      saveTransaction = (transaction, callback) ->
        Transaction.findOneAndUpdate
          _account: account._id
          bank_id: transaction.bank_id || (transaction.date + transaction.name)
        ,
          date: transaction.date
          name: transaction.name
          amount: parseFloat(transaction.amount.replace(",", ""))
        ,
          upsert: true

        , (err, transaction) ->
          callback(null, transaction)

      async.map result.transactions, saveTransaction, (err, results) ->
        callback(null, results)




