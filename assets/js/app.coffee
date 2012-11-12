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
    url: "/sync?encryption_key=asdf"
    type: "GET"
    data:
      if Cilantro.dev then dev: true
    success: (data) ->
      Cilantro.Transactions.reset(data.transactions)
      Cilantro.Accounts.reset(data.accounts)

$(document).on "click", "[data-toggle=flipper]", ->
  $(this).closest(".flip-container").toggleClass("flipped")

$(document).on "submit", "#new-scraper-form", (e) ->
  e.preventDefault()

  Cilantro.Scrapers.create
    file: $(this).find("select[name=file]").val()
    username: $(this).find("input[name=username]").val()
    password: $(this).find("input[name=password]").val()
    answer1: $(this).find("input[name=answer1]").val()
    answer2: $(this).find("input[name=answer2]").val()
    answer3: $(this).find("input[name=answer3]").val()
    encryption_key: $(this).find("input[name=encryption_key]").val()
