fs = require('fs')
configPath = "./products.json"

exports.load = ->
  unless fs.existsSync(configPath)
    console.log "You need to add a 'products.json' file. Please copy 'products.json.example' and change for your needs."
    process.exit 1

  JSON.parse(fs.readFileSync(configPath, 'utf8'))
