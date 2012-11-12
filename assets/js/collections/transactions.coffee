TransactionList = Backbone.Collection.extend
  model: Cilantro.Transaction
  url: "/transactions"

Cilantro.Transactions = new TransactionList()