walk = require 'walk'
extname = require('path').extname
Feature = require './feature'

class FeatureFinder
  constructor: (@path, @model = Feature) ->

  all: (callback) ->
    walkPath @path, (files) =>
      callback files.map (file) => new @model(file)

  walkPath = (path, callback) ->
    files = []
    walker = walk.walk(path, followLinks: false)

    walker.on 'file', (root, stat, next) ->
      files.push "#{root}/#{stat.name}" if isAFeatureFile stat.name
      next()

    walker.on 'end', -> callback files

  isAFeatureFile = (filename) -> extname(filename) is '.feature'

module.exports = FeatureFinder
