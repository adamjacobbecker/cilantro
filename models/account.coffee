mongoose = require 'mongoose'

transactionSchema = new mongoose.Schema
  bank_id: String
  name: String
  amount: Number
  date: Date

accountSchema = new mongoose.Schema
  name: String
  updated_at: Date
  balance: Number
  transactions: [transactionSchema]

module.exports = DB.model('Account', bizSchema)