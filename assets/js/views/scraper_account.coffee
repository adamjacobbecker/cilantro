Cilantro.ScraperAccountView = Backbone.View.extend
  tagName: "div"
  className: "account"

  template: _.template """
    <%= nickname || name %>
  """

  initialize: ->
    @model.bind "change", @render, @
    @model.bind "destroy", @remove, @

  render: ->
    @$el.html @template(@model.toJSON())
    return @

  clear: ->
    @model.clear()