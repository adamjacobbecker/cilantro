mongoose = require 'mongoose'

accountSchema = new mongoose.Schema
  name: String
  updated_at: Date
  balance:
    type: Number
    set: (n) ->
      return parseFloat(n.replace(",", ""))
  transactions: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Transaction' }]

accountSchema.virtual('balance_pretty').get ->
  return "$#{this.balance.toFixed(2)}"

transactionSchema = new mongoose.Schema
  _account:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Account'
  bank_id: String
  name: String
  amount:
    type: Number
    set: (n) ->
      return parseFloat(n.replace(",", ""))
  date: Date

transactionSchema.virtual('amount_pretty').get ->
  if this.amount > 0
    return "$#{this.amount.toFixed(2)}"
  else
    return "-$#{Math.abs(this.amount).toFixed(2)}"

exports.account = DB.model('Account', accountSchema)
exports.transaction = DB.model('Transaction', transactionSchema)
