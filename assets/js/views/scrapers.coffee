Cilantro.ScraperView = Backbone.View.extend
  tagName: "div"
  className: "scraper"

  template: _.template """
    <h5><%= file %></h5>
    <div class="accounts-list"></div>
    <div class="no-accounts-text">Not yet synced</div>
    <div class="action-links">
      <a class="edit-link"><i class="icon-edit"></i></a>
      <a class="remove-link"><i class="icon-trash"></i></a>
    </div>
  """

  events:
    "click .remove-link": "clear"

  initialize: ->
    @model.bind "change", @render, @
    @model.bind "destroy", @remove, @

  populateAccounts: ->
    accounts = Cilantro.Accounts.where({_scraper: @model.attributes._id})

    _.each accounts, (account) =>
      view = new Cilantro.ScraperAccountView({model: account})
      @$el.find(".accounts-list").append view.render().el

    if accounts.length is 0 then @$el.addClass('no-accounts')

  render: ->
    @$el.html @template(@model.toJSON())
    @populateAccounts()
    return @

  clear: ->
    if confirm "Are you sure?"
      @model.clear()
