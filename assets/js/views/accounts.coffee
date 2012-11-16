Cilantro.AccountView = Backbone.View.extend
  tagName: "li"

  template: _.template """
    <a href="/account/<%= _id %>">
      <span class="account-name">
        <%= nickname || name %>
      </span>
      <span class="account-balance"><%= balance_pretty %></span>
      <i class="icon-chevron-right"></i>
    </a>
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
