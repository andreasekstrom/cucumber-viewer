###
 Module dependencies.
###

read_file = (path) ->
  fs = require('fs')
  if (fs.existsSync(path))
    fs.readFileSync(path, 'utf8')

viewer = require('./routes/viewer')
express = require('express')
http = require('http')
path = require('path')

global.product_config = JSON.parse(read_file("./products.json"))
if (product_config == null)
  console.log("You need to add a 'products.json' file. Please copy 'products.json.example' and change for your needs.")
  process.exit(1)

global.basePath = process.env.BASE_PATH || ''

app = express()
app.get('/', viewer.home)

# display the list of features
app.get('/:product/features', viewer.features)

# show individual feature
app.get('/:product/feature/:id', viewer.feature)

# all environments
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(express.cookieParser('your secret here'))
app.use(express.session())

app.use(require('stylus').middleware(__dirname + '/public'))
app.use(express.static(path.join(__dirname, 'public')))

app.use(app.router)

app.locals.sanitize_feature_name = (string) ->
  string = string.charAt(0).toUpperCase() + string.slice(1)
  string = string.replace(/_/g," ")
  string

# development only
if ('development' == app.get('env'))
  app.use(express.errorHandler())

http.createServer(app).listen app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port'))
