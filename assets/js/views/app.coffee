Cilantro.AppView = Backbone.View.extend

  initialize: ->
    Cilantro.Accounts.bind 'all', @render, @
    Cilantro.Transactions.bind 'all', @render, @

    Cilantro.Accounts.fetch()
    Cilantro.Scrapers.fetch()
    # Transactions are rendered by router.

    Cilantro.dev = @options.dev

  reset: ->
    #

  render: ->
    #
