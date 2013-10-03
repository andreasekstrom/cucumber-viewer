walk = require 'walk'
extname = require('path').extname
Feature = require './feature'

listFeatures = (path, callback) ->
  files = []

  walker = walk.walk(path, followLinks: false)

  walker.on 'file', (root, stat, next) ->
    filename = stat.name
    if extname(filename) is '.feature'
      files.push "#{root}/#{filename}"
    next()

  walker.on 'end', ->
    callback files

class FeatureFinder
  constructor: (@path, @model = Feature) ->

  all: (callback) ->
    listFeatures @path, (files) =>
      callback files.map (file) => new @model(file)

module.exports = FeatureFinder
