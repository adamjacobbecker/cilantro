Preference = require('../models').preference
Account = require('../models').account
Transaction = require('../models').transaction
hash = require 'node_hash'
crypto = require 'crypto'
async = require 'async'

exports.index = (req, res) ->
  Preference.findOrCreate (preference) ->
    res.send preference.scrapers

exports.create = (req, res) ->
  Preference.findOrCreate (preference) ->
    if hash.md5(req.param('encryption_key'), req.param('encryption_key')) isnt preference.encrypted_encryption_key
      return res.send(400, "Wrong!")

    scraper =
      file: req.param('file')
      fields: req.param('fields')
      additionalFields: JSON.stringify(JSON.parse(req.param('additionalFields')))
      creds: {}

    for key, val of req.body.creds
      cipher = crypto.createCipher('aes256', req.param('encryption_key'))
      scraper.creds[key] = cipher.update(val, 'utf8', 'hex') + cipher.final('hex')

    console.log scraper
    preference.scrapers.push scraper

    preference.save ->
      res.send scraper

exports.update = (req, res) ->
  Preference.findOrCreate (preference) ->
    scraper = preference.scrapers.id(req.params.scraper)

    if hash.md5(req.param('encryption_key'), req.param('encryption_key')) isnt preference.encrypted_encryption_key
      return res.send(400, "Wrong passphrase!")

    scraper.creds = {}

    for key, val of req.body.creds
      cipher = crypto.createCipher('aes256', req.param('encryption_key'))
      scraper.creds[key] = cipher.update(val, 'utf8', 'hex') + cipher.final('hex')

    preference.save ->
      res.send scraper

exports.destroy = (req, res) ->
  Preference.findOrCreate (preference) ->
    preference.scrapers.id(req.params.scraper).remove()
    preference.save (err) ->
      Account.find({_scraper: req.params.scraper}).exec (err, accounts) ->
        async.map accounts, removeAccount, (err, results) ->
          res.send("OK")

  removeAccount = (account, callback) ->
    Transaction.find {_account: account.id}, (err, transactions) ->
      async.map transactions, removeTransaction, (err, results) ->
        account.remove ->
          callback()

  removeTransaction = (transaction, callback) ->
    transaction.remove ->
      callback()

# removeTransactions(account) for account in accounts

