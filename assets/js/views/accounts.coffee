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

##### ADMIN ######

Cilantro.AccountAdminView = Backbone.View.extend
  tagName: "li"

  template: _.template """
    <%= name %>
    <input type="text" name="name" value="<%= nickname %>" placeholder="nickname" />
  """

  events:
    "blur input": "updateNickname"

  initialize: ->
    @model.bind "change", @render, @
    @model.bind "destroy", @remove, @

  updateNickname: (m) ->
    @model.save
      nickname: @$el.find("input[name=name]").val()
    ,
      success: ->
        Cilantro.Transactions.fetchFiltered()

  render: ->
    @$el.html @template(@model.toJSON())
    return @

  clear: ->
    @model.clear()
