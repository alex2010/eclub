async = require('async')

attrs = (attr)->
    op = {}
    for it in attr.split(',')
        continue if it.charAt(0) is '_'
        op[it] = 1
    op

isOid = (k)->
    k.indexOf('_id') > -1 or k in ['rid', 'uid', 'oid']

_wkt = (obj, fu)->
    for k, v of obj
        if _.isObject(v) and !_.isArray(v) and !_.isFunction(v)
            arguments.callee(v, fu)
        else if v
            fu(v, k, obj)
#    for k,v of q
#        if k in ['status', 'row']
#            q[k] = +v
#        else if _.isObject(v)
#            for kk,vv of v
#                if isOid(kk)
#                    v[kk] = new oid(vv)
#        else if isOid(k)
#            q[k] = new oid(v)
#        else if k in ['startedDate', 'endDate', 'putTime']
##        else if /^\d{4}-\d{1,2}-\d{1,2}/.text(k) and k.length < 22
#            q[k] = Date.parseLocal(v)
#        else if k.toString().charAt(0) is '_'
#            delete q[k]
_cv = (v, k, obj)->
    if k.charAt(0) is '_' and k isnt '_id'
        delete obj[k]
    else
        obj[k] = if isOid(k)
            if v.$in
                new oid(it) for it in v.$in
            else
                new oid(v)
        else if k in ['status', 'row']
            +v
        else if /^\d{4}-\d{1,2}-\d{1,2}/.test(v) and v.length < 22
            Date.parseLocal(v)
        else
            v
_afterEdit = (item, entity)->
    if entity is 'community'
        app._community[item.url] = item

buildQuery = (q)->
    _wkt q, _cv
    q

cleanItem = (q, isNew)->
    if isNew
        q.dateCreated = new Date()
    q.lastUpdated = new Date()
    _wkt q, _cv
    q

dataController =
    comp: (req, rsp) ->
        opt = {}
        code = req.c.code
        for k,v of req.query
            if k.indexOf('_')
                [entity,limit] = k.split('_')
                opt[entity] = do(entity, limit, v)->
                    (cb)->
                        op =
                            skip: 0
                            limit: limit
                            sort:
                                lastUpdated: -1
                            fields:
                                title: 1
                                brief: 1
                                lastUpdated: 1
                                refFile: 1
                                list: 1
                        if v.status
                            v.status = +v.status
                        dao.find code, entity, v, op, (res)->
                            cb(null, res)

        async.parallel opt, (err, res)->
            rsp.send res

    list: (req, rsp) ->
        code = req.c.code
        qu = req.query || {q: {}}
        op =
            skip: util.d(qu, 'offset') || 0
            limit: util.d(qu, 'max') || 10
            sort: [
                ['lastUpdated', 'desc']
            ]
        if qu.p
            _.extend op, qu.p
        if qu._attrs
            op.fields = attrs util.d qu, '_attrs'

        q = buildQuery qu.q

        entity = req.params.entity

        dao.find code, entity, q, op, (entities)->
            dao.count code, entity, q, (count)->
                rsp.send util.r entities, count

    get: (req, rsp) ->
        code = req.c.code
        entity = req.params.entity
        dao.get code, entity, _id: req.params.id, (item)->
            rsp.send util.r item

    getByKey: (req, rsp) ->
        code = req.c.code
        pa = req.params
        filter = {}
        filter[pa.key] = pa.val

        dao.get code, pa.entity, filter, (item)->
            rsp.send util.r item

    subOp: (req, rsp)->
        code = req.c.code
        entity = req.params.entity
        pEntity = req.params.pEntity
        bo = req.body

        filter = {}

        opt =
            $push:
                entity: obj

        dao.findAndUpdate code, pEntity, filter, opt, (item)->


    edit: (req, rsp) ->
        code = req.c.code
        entity = req.params.entity
        bo = req.body

        after = util.del 'afterSave', req.body
        before = util.del 'beforeSave', req.body

        if before
            rt = []
            for it in before.split(',')
                res = gs(it)(req, bo)
                if res.error
                    rt.push res.msg
            if rt.size()
                rsp.status 405
                rsp.send errors: rt
                return

        _rsMsg = bo._rsMsg
        _attrs = if bo._attrs
            bo._attrs.split(',')
        else
            _.keys(bo)
        cleanItem(bo)


        bo =
            $set: bo
        dao.findAndUpdate code, entity, _id: req.params.id, bo, (item)->
            _afterEdit(item, entity)

            gs(it)(req, item) for it in after.split(',') if after
            _attrs.push('_id')
            rsp.send util.r(_.pick(item, _attrs), _rsMsg || 'm_update_ok', entity)

    save: (req, rsp) ->
        code = req.c.code
        entity = req.params.entity
        bo = req.body

        after = util.del 'afterSave', req.body
        before = util.del 'beforeSave', req.body


        #        _attrs = bo._attrs || ''
        #        _attrs = _attrs.split(',')
        #        _attrs.push '_id'
        #
        #        cleanItem(bo, true)

        if before
            rt = []
            for it in before.split(',')
                res = gs(it)(req, bo)
                if res.error
                    rt.push res.msg

            if rt.length
                rsp.status 405
                rsp.send errors: rt
                return

        _rsMsg = bo._rsMsg
        _attrs = if bo._attrs
            bo._attrs.split(',')
        else
            _.keys(bo)

        cleanItem(bo, true)

        dao.save code, entity, bo, (item)->
            for s in item
                _afterEdit(s, entity)
                gs(it)(req, s) for it in after.split(',') if after

            if item.length is 1
                _attrs.push('_id')
                ri = _.pick(item[0], _attrs)
            else
                ri = item
            rsp.send util.r(ri, _rsMsg || 'm_create_ok', entity)

    del: (req, rsp) ->
        code = req.c.code
        entity = req.params.entity
        dao.delItem code, entity, _id: req.params.id, ->
            rsp.send msg: 'del.ok'

    cleanCache: (req, rsp)->
        opt =
            k:
                $regex: req.c.url
        dao.delItem _mdb, 'cache', opt, (res)->
            log 'clean Cache...'
            rsp.send msg: 'del.ok'

    editSub: (req, rsp)->

    getSub: (req, rsp)->
        code = req.c.code
        entity = req.params.entity
        prop = req.params.prop

        qo = {}
        qo[req.params.q] = req.params.qv

        dao.get code, entity, qo, (item)->
            po = util.r item[prop]
            rsp.send po

    delSub: (req, rsp)->

    saveSub: (req, rsp)->
        code = req.c.code
        entity = req.params.entity
        qs = {}
        qs[req.params.q] = req.params.qv
        if qs._id
            qs._id = new oid(qs._id)

        bo = req.body
        _rsMsg = bo._rsMsg
        bo = cleanItem bo

        op = {}
        rt = bo._root
        delete bo._root
        if rt
            op["$set"] = rt
        op["$#{req.params.type}"] = {}
        op["$#{req.params.type}"][req.params.prop] = bo
        dao.findAndUpdate code, entity, qs, op, (doc)->
            rsp.send util.r(doc, _rsMsg || 'm_create_ok')


module.exports = dataController