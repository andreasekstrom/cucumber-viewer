function list_features(callback) {
  var execFile = require('child_process').execFile;
  var walk    = require('walk');
  var files = [];

  var walker  = walk.walk(process.env.FEATURES_HOME, { followLinks: false });

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
  return fs.readFileSync(path, 'utf8');
}

exports.home = function(req, res){
  res.render('home', { title: 'Cucumber viewer' })
};

// handler for displaying the features
exports.features = function(req, res) {
  callback = function(files) {
    res.render('features', { title: 'Documentation - features', features:files });
  }

  list_features(callback);
};

// handler for displaying individual features
exports.feature = function(req, res) {

  callback = function(files, feature) {
    var name = req.params.id;

    var filename = process.env.FEATURES_HOME + "/" + name + ".feature";
    var feature = read_file(filename);
    feature = feature.replace("'","´");

    res.render('feature', { title: 'Feature - ' + name, feature:feature, features:files});
  }

  list_features(callback);
};

