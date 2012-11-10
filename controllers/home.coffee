Account = require('../models').account
Transaction = require('../models').transaction
moment = require 'moment'

exports.index = (req, res) ->
  res.render("home/index")


exports.sync = (req, res) ->
  accounts = require '../accounts'

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

  saveResults = (results) ->
    if results.length is 0 then return res.send("Done!")

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


  useDevMode = if req.param('dev') then true else false

  for account in accounts
    do ->
      scraper = require "../scrapers/#{account.file}"
      scraper(account, useDevMode, saveResults)

