Cilantro.AppView = Backbone.View.extend

  initialize: ->
    Cilantro.Accounts.bind 'all', @render, @
    Cilantro.Transactions.bind 'all', @render, @
    Cilantro.Scrapers.bind 'destroy', @fetchAccountsAndTransactions

    Cilantro.Accounts.fetch
      success: ->
        Cilantro.Scrapers.fetch()
    # Transactions are rendered by router.

    Cilantro.dev = @options.dev

  fetchAccountsAndTransactions: ->
    Cilantro.Accounts.fetch()
    Cilantro.Transactions.fetchFiltered()

  reset: ->
    #

  render: ->
    #
