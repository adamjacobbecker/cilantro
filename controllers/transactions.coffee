Transaction = require('../models').transaction

exports.index = (req, res) ->
  res.send Transaction.json(if req.param('account_id') then {_account: req.param('account_id')})
