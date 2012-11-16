Cilantro.ScraperView = Backbone.View.extend
  tagName: "div"
  className: "scraper"

  template: _.template """
    <%= file %> <button class="btn btn-danger btn-mini">x</button>
  """

  events:
    "click .btn-danger": "clear"

  initialize: ->
    @model.bind "change", @render, @
    @model.bind "destroy", @remove, @

  render: ->
    @$el.html @template(@model.toJSON())
    return @

  clear: ->
    @model.clear()
