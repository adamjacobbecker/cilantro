Workspace = Backbone.Router.extend
  routes:
    'filter/:id': 'setFilter'

  setFilter: (id) ->
    console.log id

Cilantro.Router = new Workspace()
Backbone.history.start
  pushState: true