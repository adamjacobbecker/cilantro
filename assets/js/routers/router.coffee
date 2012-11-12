Cilantro.setActiveNav = ->
  if Cilantro.activeAccount
    el = $("#accounts-list a[href*=#{Cilantro.activeAccount}]")
  else
    el = $("#accounts-list a[href=\\/]")

  el.parent()
    .addClass("active")
    .siblings()
    .removeClass("active")

Workspace = Backbone.Router.extend
  routes:
    '': 'index'
    'account/:id': 'setAccount'

  setAccount: (id) ->
    Cilantro.activeAccount = id
    Cilantro.setActiveNav()
    Cilantro.Transactions.fetchFiltered()

  index: ->
    Cilantro.activeAccount = false
    Cilantro.setActiveNav()
    Cilantro.Transactions.fetchFiltered()

Cilantro.Router = new Workspace()
Backbone.history.start
  pushState: true
