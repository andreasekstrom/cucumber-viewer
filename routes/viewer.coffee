Product = require '../models/product'
Feature = require '../models/feature'

exports.home = (req, res) ->
  res.render 'home',
    title: 'Cucumber viewer'
    products: Product.all()

exports.features = (req, res) ->
  productId = req.params.product
  product = Product.find productId

  product.findFeatures (features) ->
    res.render 'features',
      title: 'Documentation - features'
      product: product
      features: features
      products: Product.all()

# handler for displaying individual features
exports.feature = (req, res) ->
  id = req.params.id
  product = Product.find req.params.product

  product.findFeatures (features) ->
    feature = null
    for potentialFeature in features
      if potentialFeature.id is id
        feature = potentialFeature
        break

    if feature?
      feature.readContents (contents) ->
        res.render 'feature',
          title: 'Feature - ' + feature.name
          product: product
          feature: feature
          contents: contents
          features: features
          products: Product.all()
    else
      # TODO: Make error page work better
      # TODO: Actually respond with 404
      # res.render '404', url: filename
      res.render '404'
