fs = require('fs')
path = require('path')

readFileSync = (path) ->
  if (fs.existsSync(path))
    fs.readFileSync(path, 'utf8')

readFile = (path, callback) ->
  fs.exists path, (exists) ->
    if exists
      fs.readFile path, 'utf8', (err, contents) -> callback contents
    else
      callback null

class Feature
  constructor: (@path) ->
    @id = resolveId @path
    @name = humanize @id

  readContentsSync: ->
    contents = readFileSync @filename
    fixSyntaxHighlighting contents

  readContents: (callback) ->
    readFile @path, (contents) ->
      callback fixSyntaxHighlighting(contents)

  fixSyntaxHighlighting = (text) ->
    # Fix for syntax highlight to work
    text.replace(/'/g, '´') if text?

  resolveId = (filename) -> path.basename(filename, '.feature')

  humanize = (name) ->
    string = name.charAt(0).toUpperCase() + name.slice(1)
    string = string.replace(/_/g," ")
    string

module.exports = Feature
