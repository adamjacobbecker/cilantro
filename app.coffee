express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'
mongoose = require 'mongoose'
moment = require 'moment'

require 'express-mongoose'

global.DB = mongoose.createConnection('localhost', 'cilantro')

app = express()
app.set("trust proxy", true)

app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.cookieParser('your secret here'))
  app.use(express.session())
  app.use(app.router)
  app.use require('connect-assets')()
  app.use(express.static(path.join(__dirname, 'public')))

app.configure 'development', ->
  app.use(express.errorHandler())

routes.init(app)

app.locals.timeAgo = (t) ->
  moment(t).fromNow()

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))