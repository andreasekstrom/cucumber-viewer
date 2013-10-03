productConfig = require('../lib/product_config').load()
FeatureFinder = require './feature_finder'

allProducts = null

class Product
  @all = ->
    allProducts ||= productConfig.products.map(
      (attributes) => new @(attributes)
    )

  @find = (id) ->
    for product in @all()
      return product if product.id is id
    # TODO: Throw an exception instead
    null

  constructor: (attributes) ->
    {@name, @id, @path, @description} = attributes
    @featureFinder = new FeatureFinder(@path)

  findFeatures: (callback) ->
    # We do not cache this result since we want "live reloading" of features
    @featureFinder.all (features) =>
      @features = features
      callback features

module.exports = Product
