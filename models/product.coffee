productConfig = require('../lib/product_config').load()

allProducts = null

class Product
  @all = ->
    allProducts ||= productConfig.products.map(
      (attributes) => new @(attributes)
    )

  constructor: (attributes) ->
    {@name, @id, @path, @description} = attributes

module.exports = Product
