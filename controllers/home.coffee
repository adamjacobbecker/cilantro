Account = require '../models/account'

exports.index = (req, res) ->
  res.render("home/index")


exports.sync = (req, res) ->
  accounts = require '../accounts'

  useDevMode = if req.param('dev') then true else false

  for account in accounts
    do ->
      scraper = require "../scrapers/#{account.file}"
      scraper(account, useDevMode, saveResults)

parseTransactions = (account, transactions, results) ->
  if transactions.length is 0 then return saveResults(results)

  resultTransaction = transactions.shift()

  account.transactions.findOneAndUpdate
    bank_id: resultTransaction.bank_id || (resultTransaction.date + resultTransaction.name)
  ,
    date: resultTransaction.date
    name: resultTransaction.name
    amount: resultTransaction.amount
  ,
    upsert: true

  , parseTransactions(account, transactions, results)

saveResults = (results) ->
  if results.length is 0 then return res.send("Done!")

  result = results.shift()

  Account.findOneAndUpdate
    name: result.name
  ,
    balance: parseFloat(result.amount)
    updated_at: Date.now
  ,
    upsert: true

  , (err, account) ->
    console.log err
    console.log account
    parseTransactions(account, result.transactions, results)

