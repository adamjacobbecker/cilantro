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

Cilantro.Scrapers = new ScraperList()