express = require('express')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
cache = require("node-smple-cache/Cache")

_cc = new require('./service/cc')

EventEmitter = require('events').EventEmitter


`
    cf = {
        style: {
            iconStr: 'glyphicon'
        }
    };
    _ = require('underscore');
    async = require('async');
    fs = require('fs');
    path = require('path');
    app = express();
    app.env = app.get('env') == 'development';
    //app.setting = require('./setting');
    oid = function(v){return !v?new require('mongodb').ObjectID():(v instanceof require('mongodb').ObjectID) ? v : (_.isString(v) && v.length == 24)? new require('mongodb').ObjectID(v):v};
    log = console.log;
    _path = __dirname;
    _mdb = 'main';
    dao = new require('./service/dao')();
    util = _.extend(require('./public/ext/common'), require('./public/ext/util'));
    tu = require('./public/ext/tmpl');
    jade = require('jade');
    gStub = {};
    gs = function (code, fn) {
        if (gStub[code] && gStub[code][fn])
            return gStub[code][fn];
        else
            return require(_path + '/service/' + fn);
    };
    ee = new EventEmitter();
    _cache = cache.createCache('LRU', 100 * 100)
    wtCtn = {};
    ctCtn = {};
    _wtcCtn = {};
    _wtFunc = {};
    _ePool = {};
    cc = new _cc();
    _wtPay = {};
    _st = require('./public/ext/style/bs');

`
cf.st =
    add: (et, opt)->
        map = {}
        for k,v of opt
            map[k] = v.v
        map

        

require('./public/ext/string')
require './public/ext/toMd'

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

app.addCross = (res, url = '*', method = 'GET,PUT,POST,DELETE,PATCH', head = 'Origin, X-Requested-With, Content-Type, Accept', cred = true)->
    
    res.header 'Access-Control-Allow-Origin', url
    res.header 'Access-Control-Allow-Methods', method
    res.header 'Access-Control-Allow-Headers', head
    res.header 'Access-Control-Allow-Credentials', cred

app.use express.static(path.join(__dirname, 'public'))
#app.use express.static(path.join(__dirname, 'public/res'))
if app.env
    app.use '/*', (req, res, next)->
        app.addCross(res)
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