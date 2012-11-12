$ ->
  new Cilantro.AppView({dev: true})

$(document).on "click", "a[href^='/']", (event) ->

  href = $(event.currentTarget).attr('href')

  # chain 'or's for other black list routes
  passThrough = href.indexOf('sign_out') >= 0

  # Allow shift+click for new tabs, etc.
  if !passThrough && !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
    event.preventDefault()

    # Remove leading slashes and hash bangs (backward compatablility)
    url = href.replace(/^\//,'').replace('\#\!\/','')

    # Instruct Backbone to trigger routing events
    Cilantro.Router.navigate url, { trigger: true }

    return false