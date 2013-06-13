
/**
 * Module dependencies.
 */

var viewer = require('./routes/viewer');

var express = require('express')
  , http = require('http')
  , path = require('path');

var app = express();
app.get('/', viewer.home);
// display the list of item
app.get('/features', viewer.features);
// show individual feature
app.get('/feature/:id', viewer.feature);

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser('your secret here'));
app.use(express.session());
app.use(app.router);
app.use(require('stylus').middleware(__dirname + '/public'));
app.use(express.static(path.join(__dirname, 'public')));

app.locals.sanitize_feature_name = function(string){
  string = string.charAt(0).toUpperCase() + string.slice(1);
  string = string.replace(/_/g," ")
  return string;
}

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
