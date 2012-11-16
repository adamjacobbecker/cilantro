Cilantro.Scraper = Backbone.Model.extend
  # validate: (attrs) ->

  # defaults: ->
  idAttribute: "_id"

  clear: ->
    @destroy()
