Cilantro.AppView = Backbone.View.extend

  initialize: ->
    Cilantro.Transactions.bind 'add', @addOne, @
    Cilantro.Transactions.bind 'reset', @reset, @
    Cilantro.Transactions.bind 'all', @render, @

    $("#update-accounts-button").click ->
      el = $(this)
      el.addClass 'updating'

      $.ajax
        url: "/sync?dev=true"
        type: "GET"
        success: (data) ->
          Cilantro.Transactions.reset(data.transactions)

    Cilantro.Transactions.fetch()

  reset: ->
    $("#transactions-tbody").html('')
    @addAll()

  render: ->
    #

  addOne: (transaction) ->
    view = new Cilantro.TransactionView({model: transaction})
    html = view.render().el
    $("#transactions-tbody").append(html);

  addAll: ->
    Cilantro.Transactions.each @addOne
