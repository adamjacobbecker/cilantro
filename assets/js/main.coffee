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

$(document).on "submit", "#update-accounts-form", (e) ->
  e.preventDefault()

  $input = $(this).find("input")

  handleError = (xhr) =>
    $(this).removeClass("updating")
    $(this).addClass("error entering-passphrase")
    $(this).find(".error-text").html(xhr.responseText || "Sorry, an error occurred.")
    $input.val('').focus()
    setTimeout =>
      $(this).removeClass("error")
    , 1000

  if !$input.is(":visible")
    $(this).addClass("entering-passphrase")
    return $input.focus()

  else
    $(this).removeClass("entering-passphrase")
    if !$input.val() then return

    $(this).addClass("updating")

    $.ajax
      url: "/sync?encryption_key=#{$input.val()}"
      type: "GET"
      data:
        if Cilantro.dev then dev: true
      success: ->
        Cilantro.Transactions.fetch()
        Cilantro.Accounts.fetch()

      error: handleError

$(document).on "click", "[data-toggle=flipper]", ->
  $(this).closest(".flip-container").toggleClass("flipped")

$(document).on "change", "#new-scraper-form select", ->
  if $(this).val() is "Select a scraper" then return $("#scraper-fields").html('')

  option = $(this).find("option:selected")
  fields = option.data('fields').split('|')
  additionalFields = option.data('additional-fields')

  $("#scraper-fields").html Cilantro.Scrapers.formForFields(fields, additionalFields)

$(document).on "submit", "#new-scraper-form", (e) ->
  e.preventDefault()

  hasAdditionalFields = if $(this).find("select[name=file]").find("option:selected").data('additional-fields') then true else false

  creds = {}
  $("#scraper-fields input").each ->
    creds[$(this).attr('name')] = $(this).val()

  if hasAdditionalFields
    creds["additionalFields"] = $(this).find("textarea").val()

  Cilantro.Scrapers.create
    fields: $(this).find("select[name=file]").find("option:selected").data('fields')
    file: $(this).find("select[name=file]").val()
    additionalFields: hasAdditionalFields
    encryption_key: $(this).find("input[name=encryption_key]").val()
    creds: creds
  ,
    wait: true
    success: ->
      $("#new-scraper-form input").val("")
      $("#new-scraper-form select").val("Select a scraper").trigger("change")
