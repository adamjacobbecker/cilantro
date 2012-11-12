ScraperList = Backbone.Collection.extend
  model: Cilantro.Scraper
  url: "/scrapers"

  initialize: ->
    @bind 'reset', @addAll

  addAll: ->
    $("#scrapers-list").html('')
    @each @addOne

  addOne: (scraper) ->
    view = new Cilantro.ScraperView({model: scraper})
    html = view.render().el
    $("#scrapers-list").append(html)

Cilantro.Scrapers = new ScraperList()