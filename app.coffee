express = require('express')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
cache = require("node-smple-cache/Cache")

_cc = new require('./service/cc')

EventEmitter = require('events').EventEmitter

`
    _ = require('underscore');
    async = require('async');
    fs = require('fs');
    path = require('path');
    app = express();
    app.env = app.get('env') == 'development';
    //app.setting = require('./setting');
    oid = require('mongodb').ObjectID;
    log = console.log;
    _path = __dirname;
    _mdb = 'main';
    dao = new require('./service/dao')();
    util = _.extend(require('./ext/common'), require('./ext/util'));
    tu = require('./ext/tmpl');
    gs = function (fn) {
        return require(_path + '/service/' + fn)
    };
    ee = new EventEmitter();
    _cache = cache.createCache('LRU', 100 * 100)
    wtCtn = {};
    ctCtn = {};
    _wtcCtn = {};
    _wtFunc = {};
    _ePool = {};
    cc = new _cc();
`
require('./ext/string')
# view engine setup
app.set 'view engine', 'jade'
#app.set 'views', path.join(_path, "views")
app.set 'views', path.join(_path, "public/module")
# uncomment after placing your favicon in /public
app.use(favicon(__dirname + '/public/favicon.ico'));

#app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()


app.use express.static(path.join(__dirname, 'public'))
#app.use express.static(path.join(__dirname, 'public/res'))
if app.env
    app.use '/res/*', (req, res, next)->
        res.header 'Access-Control-Allow-Origin', '*'
        next()

app._community = {}
log 'init app'
dao.newDb _mdb, ->
    dao.find _mdb, 'community', {}, {}, (res)->
        log 'init data...'
        for it in res
            if it.code
                app._community[it.url] = it
                if it.exDomain
                    app._community[tt] = it for tt in it.exDomain
                dao.pick(it.code, 'user')
                ee.emit '_loaded'
#dao.pick(_mdb, 'cache').createIndex 'page cache', time: 1, expireAfterSeconds: 2

require('./routes/wechat')

app.use '/', require('./routes/prod')


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



#app.use (req, res, next) ->
#    err = new Error('Not Found')
#    err.status = 404
#    next err
#    return
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


#app.use session
#    secret: 'secretkey'
#    store: new mongoStore
#        db: 'session'
#        host: setting.host
#        port: setting.port