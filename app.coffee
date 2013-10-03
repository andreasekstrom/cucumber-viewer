###
 Module dependencies.
###

express = require('express')
http    = require('http')
path    = require('path')

router = require('./routes/router')

port = process.env.PORT || 3000

global.productConfig = require('./lib/product_config').load()
global.basePath = process.env.BASE_PATH || ''

app = express()

# routes
router.apply(app)

app.set 'port', port
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'

app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser('your secret here')
app.use express.session()

app.use require('stylus').middleware(__dirname + '/public')
app.use express.static(path.join(__dirname, 'public'))

app.use app.router

# Development only
if app.get('env') is 'development'
  app.use(express.errorHandler())

# TODO: Move this away to helpers
app.locals.sanitizeFeatureName = (string) ->
  string = string.charAt(0).toUpperCase() + string.slice(1)
  string = string.replace(/_/g," ")
  string


# Start server
http.createServer(app).listen port, ->
  console.log 'Express server listening on port ' + port
