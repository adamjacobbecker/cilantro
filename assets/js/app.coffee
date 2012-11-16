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
    success: ->
      Cilantro.Transactions.fetch()
      Cilantro.Accounts.fetch()

$(document).on "click", "[data-toggle=flipper]", ->
  $(this).closest(".flip-container").toggleClass("flipped")

$(document).on "change", "#new-scraper-form select", ->
  if $(this).val() is "Select a scraper" then return $("#scraper-fields").html('')

  fields = $(this).find("option:selected").data('fields').split(',')

  htmlStr = ""
  for field in fields
    htmlStr += """<input type="#{if field is 'password' then 'password' else 'text'}" name="#{field}" placeholder="#{field}" />"""

  $("#scraper-fields").html(htmlStr)

$(document).on "submit", "#new-scraper-form", (e) ->
  e.preventDefault()

  creds = {}
  $("#scraper-fields input").each ->
    creds[$(this).attr('name')] = $(this).val()

  Cilantro.Scrapers.create
    file: $(this).find("select[name=file]").val()
    encryption_key: $(this).find("input[name=encryption_key]").val()
    creds: creds

  $("#new-scraper-form input").val("")
  $("#new-scraper-form select").val("Select a scraper").trigger("change")
