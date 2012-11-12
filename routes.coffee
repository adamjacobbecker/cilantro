exports.init = (app) ->
  app.get('/', require('./controllers/home').index)
  app.get('/account/:id', require('./controllers/home').index) # backbone

  app.get('/setkey', require('./controllers/home').setKey)
  app.post('/setkey', require('./controllers/home').setKeyPost)

  app.get('/sync', require('./controllers/home').sync)
  app.get('/transactions', require('./controllers/transactions').index)

  app.resource('accounts', require('./controllers/accounts'), {load: loadAccount})
  app.resource('scrapers', require('./controllers/scrapers'))

loadAccount = (id, fn) ->
  Account = require('./models').account

  Account.findById id, (err, account) ->
    return fn(null, account)