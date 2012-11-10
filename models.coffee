mongoose = require 'mongoose'

accountSchema = new mongoose.Schema
  name: String
  updated_at: Date
  balance: Number
  transactions: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Transaction' }]

transactionSchema = new mongoose.Schema
  _account:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Account'
  bank_id: String
  name: String
  amount: Number
  date: Date

exports.account = DB.model('Account', accountSchema)
exports.transaction = DB.model('Transaction', transactionSchema)
