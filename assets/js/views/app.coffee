Cilantro.AppView = Backbone.View.extend

  initialize: ->
    Cilantro.Accounts.bind 'add', @addOneAccount, @
    Cilantro.Accounts.bind 'reset', @reset, @
    Cilantro.Accounts.bind 'all', @render, @
    Cilantro.Transactions.bind 'add', @addOneTransaction, @
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
          Cilantro.Accounts.reset(data.accounts)

    Cilantro.Accounts.fetch()


  reset: ->
    $("#transactions-tbody").html('')
    $("#accounts-list").html('')
    @addAll()

  render: ->
    if $("#accounts-list li.active").length is 0 then Cilantro.setActiveNav()

  addOneTransaction: (transaction) ->
    view = new Cilantro.TransactionView({model: transaction})
    html = view.render().el
    $("#transactions-tbody").append(html);

  addOneAccount: (account) ->
    view = new Cilantro.AccountView({model: account})
    html = view.render().el
    $("#accounts-list").append(html)

  addAccountTotal: ->
    balance = 0
    Cilantro.Accounts.map (a) ->
      balance += a.attributes.balance
    html = """
      <li>
        <a href="/">
          All Accounts
          <span>#{balance}</span>
          <i class="icon-chevron-right"></i>
        </a>
      </li>
    """
    $("#accounts-list").append(html)

  addAll: ->
    Cilantro.Transactions.each @addOneTransaction
    Cilantro.Accounts.each @addOneAccount
    @addAccountTotal()