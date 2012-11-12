Cilantro.ScraperView = Backbone.View.extend
  tagName: "tr"

  template: _.template """
    <%= file %>
  """

  # events:

  initialize: ->
    @model.bind "change", @render, @
    @model.bind "destroy", @remove, @

  render: ->
    @$el.html @template(@model.toJSON())
    return @

  clear: ->
    @model.clear()
