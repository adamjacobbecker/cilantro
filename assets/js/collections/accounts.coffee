AccountList = Backbone.Collection.extend
  model: Cilantro.Account
  url: "/accounts"

  initialize: ->
    @bind 'add', @addOne
    @bind 'reset', @addAll

  lastUpdated: ->
    max = 0
    @each (a) ->
      d = new Date(a.attributes.updated_at)
      if d.getTime() > max then max = d.getTime()
    return max

  addOne: (account) ->
    view = new Cilantro.AccountView({model: account})
    $("#accounts-list").append view.render().el

    view = new Cilantro.AccountAdminView({model: account})
    $("#accounts-admin-list").append view.render().el

  addAll: ->
    $("#accounts-list").html('')
    $("#accounts-admin-list").html('')
    @each @addOne
    @addAccountTotal()
    @addUpdateAccountsWrapper()

    Cilantro.setActiveNav()

  addAccountTotal: ->
    balance = 0
    @models.map (a) ->
      balance += a.attributes.balance
    html = """
      <li>
        <a href="/">
          <span class="account-name">All Accounts</span>
          <span class="account-balance">$#{balance}</span>
          <i class="icon-chevron-right"></i>
        </a>
      </li>
    """
    $("#accounts-list").append(html)

  addUpdateAccountsWrapper: ->
    html = """
      Last updated #{moment(@lastUpdated()).fromNow()} &nbsp;
      <a class="btn btn-primary" id="update-accounts-button">
        <i class="icon-refresh icon-white"></i>
      </a>
      <a class="btn" data-toggle="flipper">
        <i class="icon-info-sign"></i>
      </a>
    """

    $("#update-accounts-wrapper").html(html)


Cilantro.Accounts = new AccountList()