exports.init = (app) ->
  app.get('/', require('./controller').index)
  app.get('/account/:id', require('./controller').index) # backbone


  app.get('/sync', require('./controller').sync)
  app.get('/transactions', require('./controller').transactions)
  app.get('/accounts', require('./controller').accounts)
