#node pSt pet mvPic
async = require('async')

args = null
process.argv.forEach (val, index, array)->
    args = array

sName = args[3]

`app = {};
_ = require('underscore');
_mdb = 'main';
log = console.log;
oid = require('mongodb').ObjectID;
code = args[2];
_env = true;
dao = new require('./service/dao')();
_ph = __dirname;
fs = require('fs');
`
require('./ext/string')

log _ph
dao.pick(code, 'post')

_.delay ->
    log 'running script: ' + sName
    require("./views/module/#{code}/script/mt/#{sName}")
    log 'script: ' + sName + 'opened'
, 1000