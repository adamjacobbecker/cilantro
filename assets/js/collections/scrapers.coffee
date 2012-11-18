ScraperList = Backbone.Collection.extend
  model: Cilantro.Scraper
  url: "/scrapers"

  initialize: ->
    @bind 'add', @addOne
    @bind 'reset', @addAll

  addAll: ->
    $("#scrapers-list").html('')
    @each @addOne

  addOne: (scraper) ->
    view = new Cilantro.ScraperView({model: scraper})
    $("#scrapers-list").append view.render().el

  formForFields: (fields, additionalFields) ->
    htmlStr = ""

    for field in fields
      htmlStr += """<input type="#{if field.toLowerCase() is 'password' then 'password' else 'text'}" name="#{field}" placeholder="#{field}" />"""


    additionalFieldsHtml = ""

    if additionalFields and additionalFields isnt "undefined" then additionalFieldsHtml = """
      <textarea name="additional_fields"></textarea>
    """

    return """
      #{htmlStr}

      #{additionalFieldsHtml}

      <div class="input-append">
        <input class="span8" type="password" name="encryption_key" placeholder="Cilantro passphrase" autocomplete="off" />
        <button class="btn btn-primary">Save</button>
      </div>
    """

Cilantro.Scrapers = new ScraperList()