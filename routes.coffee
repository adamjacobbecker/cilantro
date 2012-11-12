exports.init = (app) ->
  app.get('/', require('./controllers/home').index)
  app.get('/account/:id', require('./controllers/home').index) # backbone


  app.get('/sync', require('./controllers/home').sync)
  app.get('/transactions', require('./controllers/transactions').index)
  app.get('/accounts', require('./controllers/accounts').index)
