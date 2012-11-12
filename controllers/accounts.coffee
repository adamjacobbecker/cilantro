Account = require('../models').account

exports.index = (req, res) ->
  res.send Account.json()

exports.update = (req, res) ->
  req.account.nickname = req.param('nickname')
  req.account.save (err) ->
    res.send req.account.toObject({getters: true})