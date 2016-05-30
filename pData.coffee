#node pData run
#node pData run -p
#node pData run i18n

async = require('async')
_psd = 'bk9ULZCWUd81eZ0vOIjLuqDvozllFEWBKM7QTiy85NI='
args = null
process.argv.forEach (val, index, array)->
    args = array
`
    cf = {};
    app = {env: true};
    _ = require('underscore');
    $ = {
        extend: require('node.extend')
    };
    _mdb = 'main';
    log = console.log;
    oid = require('mongodb').ObjectID;
    code = args[2];
    i18n = require('./service/lang')(require("./public/module/console/i18n/zh"));
    ii = i18n.ii;
    meta = require('./public/lib/meta/common');
    _ep = meta.exp;
`
require('./public/ext/string')
dao = new require('./service/dao')()

addMember = (username, title)->
    dao.findAndUpdate code, 'user', {username: username}, {username: username, password: _psd}, (u)->
        if u
            dao.get code, 'role', {title: title}, (r)->
                if r
                    mOpt =
                        uid: u._id
                        rid: r._id
                        username: username
                        role: title
                    dao.save code, "membership:uid,rid", mOpt, ->

log 'db started'

if args.length > 3
    if args[3] is '-p'
        app.env = false
        entity = null
    else
        entity = args[3]
        return

data = require("./public/module/#{code}/script/data")
dao.newDb _mdb, ->
    dao.newDb code, ->
        if data.data
            for k, v of data.data
                if k is 'user:username'
                    for u in v
                        u.password = _psd
                if k is 'role:title'
                    ad = v.findBy('title', 'admin')
                    ad.menu = [
                        key: 'site'
                        icon: 'globe'
                        row: 20
                    ,
                        key: 'data'
                        icon: 'hdd'
                        row: 30
                    ,
                        key: 'wechat'
                        icon: 'comment'
                        row: 40
                    ,
                        key: 'file'
                        icon: 'list-alt'
                        row: 50
                    ,
                        key: 'userRole'
                        icon: 'sunglasses'
                        row: 60
                    ]
                    ad.entities = ad.entities.concat [
                        key: '_base'
                        row: 1
                    ,
                        key: 'content'
                        row: 10
                    ,
                        key: 'post'
                        row: 20
                    ,
                        key: 'cat'
                        row: 30
                    ,
                        key: 'head'
                        row: 40
                    ,
                        key: 'link'
                        row: 50
                    ,
                        key: 'guestBook'
                        row: 60
                    ]
                    ad.entities.sortBy 'row', true
                    ad.permission = ['console']

                dao.save code, k, v, ->
                    log 'saved ' + k

        if data.member
            for it in data.member
                [u,r] = it.split(',')
                addMember(u, r)

_.delay ->
    dao.close(code)
    dao.close(_mdb)
, 5000

