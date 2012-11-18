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

  lastUpdatedText: ->
    if @lastUpdated() isnt 0
      "Updated #{moment(@lastUpdated()).fromNow()}"
    else
      "Not yet synced."

  addOne: (account) ->
    view = new Cilantro.AccountView({model: account})
    $("#accounts-list").append view.render().el

  addAll: ->
    $("#accounts-list").html('')
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
      <form id="update-accounts-form">
        <span class="last-updated">#{@lastUpdatedText()} &nbsp;</span>
        <span class="updating-text">Updating...</span>
        <input type="password" class="update-accounts-passphrase" placeholder="Passphrase" />
        <button class="btn btn-primary">
          <i class="icon-refresh icon-white"></i>
        </button>
        <div class="error-text"></div>
      </form>
    """

    $("#update-accounts-wrapper").html(html)


Cilantro.Accounts = new AccountList()