Cilantro.Scraper = Backbone.Model.extend
  # validate: (attrs) ->

  idAttribute: "_id"

  clear: ->
    @destroy()
