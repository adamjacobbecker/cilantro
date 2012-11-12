Cilantro.Account = Backbone.Model.extend
  # validate: (attrs) ->

  defaults: ->
    nickname: ""

  clear: ->
    @destroy()
