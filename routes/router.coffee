viewer = require('./viewer')

exports.apply = (app) ->
  app.get '/', viewer.home

  # display the list of features
  app.get '/:product/features', viewer.features

  # show individual feature
  app.get '/:product/feature/:id', viewer.feature
