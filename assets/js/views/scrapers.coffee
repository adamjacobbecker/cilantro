Cilantro.ScraperView = Backbone.View.extend
  tagName: "div"
  className: "scraper"

  template: _.template """
    <h5><%= file %></h5>
    <div class="accounts-list"></div>
    <div class="no-accounts-text">Not yet synced</div>
    <div class="edit-only">
      <strong>Edit Bank Credentials</strong>
      <form class="edit-form"></form>
    </div>
    <div class="action-links">
      <a class="edit-link"><i class="icon-edit"></i></a>
      <a class="remove-link"><i class="icon-trash"></i></a>
    </div>
  """

  events:
    "click .edit-link": "toggleEditing"
    "click .remove-link": "clear"
    "submit .edit-form": "updateBankCredentials"

  initialize: ->
    @model.bind "change", @render, @
    @model.bind "destroy", @remove, @

  populateAccounts: ->
    accounts = Cilantro.Accounts.where({_scraper: @model.attributes._id})

    _.each accounts, (account) =>
      view = new Cilantro.ScraperAccountView({model: account})
      @$el.find(".accounts-list").append view.render().el

    if accounts.length is 0 then @$el.addClass('no-accounts')

  renderEditForm: ->
    fields = @model.attributes.fields.split("|")
    @$el.find(".edit-form").append Cilantro.Scrapers.formForFields(fields, @model.attributes.additionalFields)

  toggleEditing: ->
    @$el.toggleClass("editing")

  updateBankCredentials: (e) ->
    e.preventDefault()

    creds = {}
    @$el.find(".edit-form input").each ->
      creds[$(this).attr('name')] = $(this).val()

    @model.save
      encryption_key: @$el.find(".edit-form input[name=encryption_key]").val()
      creds: creds
    ,
      wait: true
      success: =>
        @$el.find(".edit-form").hide()

  render: ->
    @$el.html @template(@model.toJSON())
    @populateAccounts()
    @renderEditForm()
    return @

  clear: ->
    if confirm "Are you sure?"
      @model.clear()
