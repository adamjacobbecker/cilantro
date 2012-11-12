TransactionList = Backbone.Collection.extend
  model: Cilantro.Transaction
  url: "/transactions"

  initialize: ->
    @bind 'reset', @addAll

  fetchFiltered: ->
    @fetch
      data:
        if Cilantro.activeAccount then account_id: Cilantro.activeAccount

  addAll: ->
    $("#transactions-tbody").html('')
    @each @addOneTransaction

  addOneTransaction: (transaction) ->
    view = new Cilantro.TransactionView({model: transaction})
    html = view.render().el
    $("#transactions-tbody").append(html);

Cilantro.Transactions = new TransactionList()