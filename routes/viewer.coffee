listFeatures = (path, callback) ->
  execFile = require('child_process').execFile
  walk = require('walk')
  files = []

  walker = walk.walk(path, followLinks: false)

  walker.on 'file', (root, stat, next) ->
    filename = stat.name
    matches =  filename.match(/(.*)\.(.*)$/)
    if matches[2] is 'feature'
      files.push matches[1]
    next()

  walker.on 'end', ->
    callback files

readFile = (path) ->
  fs = require('fs')
  if (fs.existsSync(path))
    fs.readFileSync(path, 'utf8')

productInfo = (productId, products) ->
  product = null
  products.forEach (object) ->
    if object.id is productId
      product = object
  product

exports.home = (req, res) ->
  res.render 'home', title: 'Cucumber viewer', all: global.productConfig.products

exports.features = (req, res) ->
  productId = req.params.product
  info = productInfo productId, global.productConfig.products
  products = global.productConfig.products

  listFeatures info.path, (files) ->
    res.render 'features', title: 'Documentation - features', product: info, features: files, all: products

# handler for displaying individual features
exports.feature = (req, res) ->
  product = req.params.product
  name = req.params.id
  products = global.productConfig.products
  info = productInfo product, global.productConfig.products

  listFeatures info.path, (files, feature) ->
    filename = info.path + "/" + name + ".feature"
    feature = readFile filename
    if feature?
      feature = feature.replace(/'/g,"´");  # Fix for syntax highlight to work
      res.render 'feature', title: 'Feature - ' + name, product: info, feature: feature, features: files, all: products
    else
      res.render '404', url: filename
