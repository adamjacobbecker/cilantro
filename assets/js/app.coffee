$ ->
  new Cilantro.AppView({dev: false})

$(document).on "click", "a[href^='/']", (e) ->

  href = $(e.currentTarget).attr('href')

  # chain 'or's for other black list routes
  # passThrough = href.indexOf('sign_out') >= 0
  passThrough = false

  # Allow shift+click for new tabs, etc.
  if !passThrough && !e.altKey && !e.ctrlKey && !e.metaKey && !e.shiftKey
    e.preventDefault()

    # Remove leading slashes and hash bangs (backward compatablility)
    url = href.replace(/^\//,'').replace('\#\!\/','')

    # Instruct Backbone to trigger routing events
    Cilantro.Router.navigate url, { trigger: true }

    return false


$(document).on "click", "#update-accounts-button", ->
  el = $(this)
  el.addClass 'updating'

  $.ajax
    url: "/sync"
    type: "GET"
    data:
      if Cilantro.dev then dev: true
    success: (data) ->
      Cilantro.Transactions.reset(data.transactions)
      Cilantro.Accounts.reset(data.accounts)

$(document).on "click", "[data-toggle=flipper]", ->
  $(this).closest(".flip-container").toggleClass("flipped")