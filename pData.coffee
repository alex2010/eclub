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
require('./ext/string')
dao = new require('./service/dao')()
#dao.pick('main', 'cache')
#dao.pick(code, 'post')

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

dao.newDb code, ->
    if args.length > 3
        if args[3] is '-p'
            app.env = false
        else
            entity = args[3]
    if entity
        filter = if entity in ['user', 'role']
            x: 'x'
        else
            {}

        dao.remove code, entity, filter, {}, ->
            list = []
            for it in require("./public/module/#{code}/data/#{entity}")
                ob = {}
                for k, v of it
                    if v isnt null and !(k in ['cid', 'version'])
                        if _.isString(v) and v.isEmpty()
                            continue
                        if k.indexOf('_') > -1
                            [a,b] = k.split('_')
                            b = b.capitalize()
                            k = [a, b].join('')
                        else if k is 'category'
                            k = 'cat'

                        if _.isString(v) and v.indexOf('{') is 0
                            v = JSON.parse v
                        else if v.length is 19 and v.indexOf('20') is 0
                            v = Date.parseLocal(v)

                        k = 'refFile' if k is 'ref_file'
                        ob[k] = v

                    if entity is 'user'
                        if it.woid
                            ob.w_PostEnglishTime = it.woid
#                            ob.wt =
#                                oid: it.woid
#                            delete it.woid
#                            if it.wid
#                                ob.wt.id = it.wid
#                                delete it.wid
#                            if it.wunid
#                                ob.wt.unid = it.wunid
#                                delete it.wunid
                    else if entity is 'cat'
                        if ob.label
                            ob.title = ob.label
                            delete ob.label
                            delete ob.ref_class
                list.push ob


            if entity is 'role'
                entity += ':title'
            else if entity is 'user'
                entity += ':username'

            for it in list
                dao.save code, entity, it, (res)->
                    if entity is 'activity'
                        act = res.ops[0]
                        if _.isString act.startedDate
                            act.startedDate = Date.parseLocal(act.startedDate)
                        if _.isString act.endDate
                            act.endDate = Date.parseLocal(act.endDate)
                        estr = entity + ':_id'
                        if act.master and !act.master.isEmpty()
                            filter =
                                username:
                                    $in: act.master.split(',')
                            act.master = {}
                            dao.find code, 'user', filter, {}, (ru)->
                                for u in ru
                                    act.master[u._id] = _.pick(u, 'username', 'title', 'industry', 'introduction')
                                dao.save code, estr, act, ->
                                    if act.cat
#                                        dao.get code, 'cat', {code: act.cat}, (res)->
#                                            if res
#                                                act.cat =
#                                                    title: res.title
#                                                    code: res.code
                                        dao.save code, estr, act, ->
                                            if act.vid
                                                dao.get code, 'venue', {id: act.vid}, (res)->
                                                    if res
                                                        act.venue = res
                                                        dao.save code, estr, act

                    else if entity is 'post'
                        act = res.ops[0]
                        estr = entity + ':_id'
                        return if _.isString(act.uid) and act.uid.isEmpty()
                        dao.get code, 'user', {id: act.uid}, (doc)->
                            if doc
                                act.author = _.pick(doc, '_id', 'username', 'title', 'industry', 'introduction')
                            dao.save code, estr, act, ->
#                                if act.cat
#                                    dao.get code, 'cat', {code: act.cat}, (res)->
#                                        if res
#                                            act.cat =
#                                                title: res.title
#                                                code: res.code
                                dao.save code, estr, act
                if entity is 'participant'
                    it.ref = it.ref.replace ':', 'x'
                    it.ref = it.ref.replace 'x-', 'x'
                    [aid,uid] = it.ref.split('x')
                    do(aid, uid, it)->
                        if uid isnt 'undefined'
                            dao.get code, 'user', id: +uid, (u)->
                                return unless u
                                dao.findAndUpdate code, 'activity', id: +aid,
                                    $push:
                                        participant:
                                            _id: u._id
                                            username: it.username
                                            phone: it.phone
                                            woid: it.woid
                                            info: it.info

                            dao.get code, 'activity', id: +aid, (act)->
                                if act
                                    dao.findAndUpdate code, 'user', id: +uid,
                                        $push:
                                            track:
                                                type: 'participate_activity'
                                                _id: act._id
                                                _e: 'activity'
                                                title: it.title
                                                createdDate: it.started_date
                                    , ->

                            if it.feedback
                                dao.get code, 'activity', id: +aid, (act)->
                                    return unless act
                                    opt =
                                        $set: {}
                                    dao.get code, 'user', id: +uid, (uu)->
                                        return unless uu
                                        for kk,vv of it.feedback
                                            opt.$set["feedback.#{act._id}.#{uu._id}"] = vv
                                            opt.$set["feedback.#{act._id}._info"] =
                                                title: act.title || it.title
                                                startedDate: act.startedDate || it.started_date
                                            dao.findAndUpdate code, 'user', id: +kk, opt

    else
        data = require("./public/module/#{code}/script/data")
        if data.community
            dao.newDb _mdb, ->
                dao.get _mdb, 'community', {}, ->
                    dao.save _mdb, 'community:name', data.community, ->
            _.delay ->
                dao.close _mdb
            , 1000
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
                dao.save code, k, v

        if data.member
            for it in data.member
                [u,r] = it.split(',')
                addMember(u, r)

_.delay ->
    dao.close(code)
, 4000

