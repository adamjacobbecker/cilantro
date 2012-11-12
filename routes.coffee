exports.init = (app) ->
  app.get('/', require('./controllers/home').index)
  app.get('/account/:id', require('./controllers/home').index) # backbone


  app.get('/sync', require('./controllers/home').sync)
  app.get('/transactions', require('./controllers/transactions').index)

  accounts = app.resource('accounts', require('./controllers/accounts'), {load: loadAccount})

loadAccount = (id, fn) ->
  Account = require('./models').account

  Account.findById id, (err, account) ->
    return fn(null, account)