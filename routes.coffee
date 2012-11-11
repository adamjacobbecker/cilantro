exports.init = (app) ->
  app.get('/', require('./controllers/home').index)
  app.get('/sync', require('./controllers/home').sync)
