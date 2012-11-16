Preference = require('../models').preference
hash = require 'node_hash'
crypto = require 'crypto'

exports.index = (req, res) ->
  Preference.findOrCreate (preference) ->
    res.send preference.scrapers

exports.create = (req, res) ->
  Preference.findOrCreate (preference) ->
    if hash.md5(req.param('encryption_key'), req.param('encryption_key')) isnt preference.encrypted_encryption_key
      return res.send(400, "Wrong!")

    scraper =
      file: req.param('file')
      creds: {}

    for key, val of req.body
      if key is "file" or key is "encryption_key" then continue

      cipher = crypto.createCipher('aes256', req.param('encryption_key'))
      scraper.creds[key] = cipher.update(val, 'utf8', 'hex') + cipher.final('hex')

    console.log scraper
    preference.scrapers.push scraper

    preference.save ->
      res.send scraper