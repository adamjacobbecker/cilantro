Cilantro.TransactionView = Backbone.View.extend
  tagName: "tr"

  template: _.template """
    <td><%= _account.name %></td>
    <td class="name"><%= name %></td>
    <td class="amount <%= amount > 0 ? 'positive' : 'negative' %>"><%= amount_pretty %></td>
    <td><%= date_pretty %></td>
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
