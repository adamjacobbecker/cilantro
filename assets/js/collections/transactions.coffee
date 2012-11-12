TransactionList = Backbone.Collection.extend
  model: Cilantro.Transaction
  url: "/transactions"

  fetchFiltered: ->
    @fetch
      data:
        if Cilantro.activeAccount then account_id: Cilantro.activeAccount

Cilantro.Transactions = new TransactionList()