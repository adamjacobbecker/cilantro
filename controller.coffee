Account = require('./models').account
Transaction = require('./models').transaction
moment = require 'moment'
fs = require 'fs'
_ = require 'underscore'

exports.index = (req, res) ->
  Account.find {}, (err, accounts) ->

    total = 0
    lastUpdated = 0
    # accountsJson = []
    _.each accounts, (account) ->
      total = total + account.balance
      if account.updated_at > lastUpdated then lastUpdated = account.updated_at
      # accountsJson.push account.toObject()

    Transaction.find().populate('_account').exec (err, transactions) ->
      # transactionsJson = []
      # _.each transactions, (transaction) ->
      #   transactionsJson.push transaction.toObject()

      res.render "home/index",
        total: "$#{total}"
        lastUpdated: lastUpdated

exports.sync = (req, res) ->
  accounts = require './accounts'

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


  useDevMode = if req.param('dev') then true else false

  for account in accounts
    saveResults = (results) ->
      if results.length is 0
        return res.send
          accounts: Account.find()
          transactions: Transaction.find().populate('_account')


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

exports.transactions = (req, res) ->
  res.send Transaction.find(if req.param('account_id') then {_account: req.param('account_id')}).populate('_account')

exports.accounts = (req, res) ->
  res.send Account.find()