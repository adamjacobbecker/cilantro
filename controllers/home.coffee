Account = require('../models').account
Transaction = require('../models').transaction
Preference = require('../models').preference
fs = require 'fs'
_ = require 'underscore'
hash = require 'node_hash'
crypto = require 'crypto'
async = require 'async'

exports.index = (req, res) ->

  scrapers = JSON.parse(fs.readFileSync('./scrapers/scrapers.json'))

  for scraper in scrapers
    console.log scraper

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
