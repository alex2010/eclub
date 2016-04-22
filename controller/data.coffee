async = require('async')
queryUtil = require './queryUtil'

attrs = (attr)->
    op = {}
    for it in attr.split(',')
        continue if it.charAt(0) is '_'
        op[it] = 1
    op

_afterEdit = (item, entity)->
    if entity is 'community'
        app._community[item.url] = item

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
            skip: +util.d(qu, 'offset') || 0
            limit: +util.d(qu, 'max') || 10

        if qu.p
            _.extend op, qu.p

        if qu._attrs
            op.fields = attrs util.d qu, '_attrs'

        q = queryUtil.buildQuery qu.q

        entity = req.params.entity
        dao.find code, entity, q, op, (entities)->
            dao.count code, entity, q, (count)->
                rsp.send util.r entities, count

    inc: (req, rsp)->
        op =
            _id: new oid(req.params.id)
        d =
            $inc: {}
        d.$inc[req.params.prop] = 1
        dao.qc req.c.code, req.params.entity, op, d
        rsp.send {}

    get: (req, rsp) ->
        code = req.c.code
        entity = req.params.entity
        op = req.query || {}
        if req.params.id
            op._id = req.params.id
        if op._attrs
            op.fields = attrs util.d op, '_attrs'
        op = queryUtil.buildQuery op
        dao.get code, entity, op, (item)->
            rsp.send util.r(item, null, entity)

    getByKey: (req, rsp) ->
        code = req.c.code
        pa = req.params
        filter = {}
        if /^(\d|[a-z]){24}$/.test(pa.val)
            pa.val = oid(pa.val)
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

        queryUtil.cleanItem(bo)

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

        queryUtil.cleanItem(bo, true)

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

        dao.delItem code, entity, _id: new oid(req.params.id), null, ->
            if entity is 'user' #membership:uid:uid
                dao.delItem code, 'membership', uid: new oid(req.params.id)
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

        if bo._q
            $.extend qs, bo._q
            delete bo._q
        _rsMsg = bo._rsMsg
        bo = queryUtil.cleanItem bo

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