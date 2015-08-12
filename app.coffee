express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')


`_ = require('underscore');
async = require('async');
fs = require('fs');
app = express();
app.env = app.get('env') == 'development';
//app.setting = require('./setting');
oid = require('mongodb').ObjectID;
log = console.log;
_path = __dirname;
_mdb = 'main';
dao = new require('./service/dao')();
dao.pick(_mdb, 'community');
util = require('./ext/util');
tu = require('./ext/tmpl');
gs = function(fn){
    return require(_path + '/service/'+fn)
};

wtCtn = {};
ctCtn = {};
_wtcCtn={};
`

require('./ext/string')
# view engine setup
app.set 'view engine', 'jade'

app.set 'views', path.join(_path, "views")

# uncomment after placing your favicon in /public
app.use(favicon(__dirname + '/public/favicon.ico'));

#app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()


app.use express.static(path.join(__dirname, 'public'))
#app.use express.static(path.join(__dirname, 'public'))
#app.use express.static(path.join(__dirname, 'public/res'))

if app.env
    app.use '/res/*',(req, res,next)->
        res.header 'Access-Control-Allow-Origin', '*'
        next()

app._community = {}
log 'init app'
setTimeout ->
    dao.find _mdb, 'community', {}, {}, (res)->
        log 'init data...'
        for it in res
            app._community[it.url] = it
            dao.pick(it.code, 'user');

, 2000

#dao.pick(_mdb, 'cache').createIndex 'page cache', time: 1, expireAfterSeconds: 2

require('./routes/wechat')

app.use '/', require('./routes/prod')


app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next err
    return
# error handlers
# development error handler
# will print stacktrace
#if app.env
#    app.use (err, req, res, next) ->
#        res.status err.status or 500
#        res.render 'error',
#            message: err.message
#            error: err
#        return

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    log err.message
    res.status err.status or 500
    res.render 'error',
        message: err.message
        error: {}
    return

module.exports = app

