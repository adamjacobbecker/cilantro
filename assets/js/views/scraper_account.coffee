Cilantro.ScraperAccountView = Backbone.View.extend
  tagName: "div"
  className: "account"

  template: _.template """
    <div class="view-only">
      <span class="nickname-name"><%= nickname || name %></span>
    </div>
    <div class="edit-only">
      <input type="text" name="nickname" value="<%= nickname %>" placeholder="Nickname" />
    </div>
  """

  events:
    "input input[name=nickname]": "updateNickname"

  initialize: ->
    @model.bind "create", @render, @
    @model.bind "change", @updateTemplate, @
    @model.bind "destroy", @remove, @

  render: ->
    @$el.html @template(@model.toJSON())
    return @

  updateTemplate: ->
    @$el.find(".nickname-name").html(@model.attributes.nickname || @model.attributes.name)

  clear: ->
    @model.clear()

  updateNickname: ->
    clearTimeout @nicknameTimeout
    @nicknameTimeout = setTimeout =>
      @model.urlRoot = Cilantro.Accounts.url # Weird hack, backbone wasn't seeing this as null after deleting other scrapers.
      @model.save
        nickname: @$el.find("input[name=nickname]").val()
      ,
        success: ->
          Cilantro.Transactions.fetchFiltered()
    , 200