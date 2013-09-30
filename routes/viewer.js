function list_features(path, callback) {
  var execFile = require('child_process').execFile;
  var walk    = require('walk');
  var files = [];

  var walker  = walk.walk(path, { followLinks: false });

  walker.on('file', function(root, stat, next) {
    filename = stat.name;
    matches =  filename.match(/(.*)\.(.*)$/);
    if(matches[2] == 'feature')
      files.push(matches[1]);
    next();
  });

  walker.on('end', function() {
    callback(files);
  });
}

function read_file(path) {
  var fs = require('fs');
  if (!fs.existsSync(path))
    return null;
  return fs.readFileSync(path, 'utf8');
}

function product_info(product_id, product_config) {
  var product = null;
  product_config.products.forEach(function(object) {
    if (object.id == product_id) {
      product = object;
    }
  });
  return product;
}

exports.home = function(req, res){
  res.render('home', { title: 'Cucumber viewer', all: global.product_config.products })
};

exports.features = function(req, res) {
  var product_id = req.params.product;
  var info = product_info(product_id, global.product_config);
  var products = global.product_config.products;

  callback = function(files) {
    res.render('features', { title: 'Documentation - features', product: info, features:files , all: products });
  }

  list_features(info.path, callback);
};

// handler for displaying individual features
exports.feature = function(req, res) {
  var product = req.params.product;
  var name = req.params.id;
  var products = global.product_config.products;
  var info = product_info(product, global.product_config);

  callback = function(files, feature) {
    var filename = info.path + "/" + name + ".feature";
    var feature = read_file(filename);
    if (feature != null) {
      feature = feature.replace(/'/g,"´");  // Fix for syntax highlight to work
      res.render('feature', { title: 'Feature - ' + name, product: info, feature:feature, features:files, all:products});
    } else {
      res.render('404', { url: filename });
    }
  }

  list_features(info.path, callback);
};

