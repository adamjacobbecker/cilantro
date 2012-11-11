window.Cilantro = {}

Transaction = Backbone.Model.extend
  validate: (attrs) ->

  # defaults: ->

  clear: ->
    @destroy()

TransactionList = Backbone.Collection.extend
  model: Transaction
  url: "/transactions"

TransactionView = Backbone.View.extend
  tagName: "tr"

  template: _.template """
    <td><%= _account.name %></td>
    <td><%= name %></td>
    <td class="amount <%= amount > 0 ? 'positive' : 'negative' %>"><%= amount %></td>
    <td><%= date %></td>
  """

  # events:

  initialize: ->
    @model.bind "change", @render, @
    @model.bind "destroy", @remove, @

  render: ->
    @$el.html @template(@model.toJSON())
    return @

  clear: ->
    @model.clear()

AppView = Backbone.View.extend

  initialize: ->
    Transactions.bind 'add', @addOne, @
    Transactions.bind 'reset', @reset, @
    Transactions.bind 'all', @render, @

    $("#update-accounts-button").click ->
      el = $(this)
      el.addClass 'updating'

      $.ajax
        url: "/sync?dev=true"
        type: "GET"
        success: (data) ->
          Transactions.reset(data.transactions)


  reset: ->
    $("#transactions-tbody").html('')
    @addAll()

  render: ->
    #

  addOne: (transaction) ->
    view = new TransactionView({model: transaction})
    html = view.render().el
    $("#transactions-tbody").append(html);

  addAll: ->
    Transactions.each @addOne

App = {}
Transactions = {}

Cilantro.App = (initialModels) ->
  Transactions = new TransactionList
  initialCollection = Transactions
  App = new AppView({collection: initialCollection})
  initialCollection.reset(initialModels)
  return App