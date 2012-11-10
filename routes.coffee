exports.init = (app) ->
  app.get('/', require('./controllers/home').index)