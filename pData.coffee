#node pData run
#node pData run -p

#node pData run i18n


async = require('async')

args = null
process.argv.forEach (val, index, array)->
    args = array

`app = {};
_ = require('underscore');
_mdb = 'main';
log = console.log;
oid = require('mongodb').ObjectID;
code = args[2];
_env = true;
`

require('./ext/string')
dao = new require('./service/dao')()
dao.pick('main','cache')
dao.pick(code,'post')
_.delay ->
    if args.length > 3
        if args[3] is '-p'
            `
            _env = false;
            `
        else
            entity = args[3]

    if entity
        filter = if entity in ['user','role']
             x:'x'
        else
            {}

        dao.remove code, entity, filter, {}, ->
            list = []
            for it in require("./views/module/#{code}/data/#{entity}")
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
                            ob.wt =
                                oid: it.woid
                            delete it.woid
                            if it.wid
                                ob.wt.id = it.wid
                                delete it.wid
                            if it.wunid
                                ob.wt.unid = it.wunid
                                delete it.wunid
                    else if entity is 'cat'
                        if ob.label
                            ob.title = ob.label
                            delete ob.label
                list.push ob


            if entity is 'role'
                entity += ':title'
            else if entity is 'user'
                entity += ':username'

            for it in list
                dao.save code, entity, it, (res)->
                    if entity is 'activity'
                        act = res.ops[0]
                        estr = entity + ':_id'
                        if act.master and !act.master.isEmpty()
                            filter =
                                username:
                                    $in: act.master.split(',')
                            act.master = {}
                            dao.find code, 'user', filter, {}, (ru)->
                                for u in ru
                                    act.master[u._id] = _.pick(u, 'id', 'username', 'title', 'industry', 'introduction')
                                dao.save code, estr, act, ->
                                    if act.cat
                                        dao.get code, 'cat', {code: act.cat}, (res)->
                                            if res
                                                act.cat =
                                                    title: res.title
                                                    code: res.code
                                                dao.save code, estr, act, ->
                                                    if act.vid
                                                        dao.get code, 'venue', {id:act.vid}, (res)->
                                                            if res
                                                                act.venue =
                                                                    title: res.title
                                                                    fee: res.fee
                                                                    phone: res.phone
                                                                    lng: res.lng
                                                                    lat: res.lat
                                                                dao.save code, estr, act
                    else if entity is 'post'
                        act = res.ops[0]
                        estr = entity + ':_id'
                        return if _.isString(act.uid) and act.uid.isEmpty()
                        log act.uid
                        dao.get code, 'user', {id: act.uid}, (doc)->
                            log doc
                            if doc
                                act.author =
                                    username: doc.username
                                    id: doc._id
                            dao.save code, estr, act, ->
                                if act.cat
                                    dao.get code, 'cat', {code: act.cat}, (res)->
                                        if res
                                            act.cat =
                                                title: res.title
                                                code: res.code
                                            dao.save code, estr, act
    else
        data = require("./views/module/#{code}/script/data")
        dao.save _mdb, 'community:code', data.community

        for k, v of data.data
            dao.save code, k, v
, 1000
#        dao.save code, 'role:title', [data.r], ->

_.delay ->
    dao.close()
, 4000

