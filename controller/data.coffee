#_ = require('underscore')
#u = require '../util'
async = require('async')

attrs = (attr)->
    op = {}
    for it in attr.split(',')
        continue if it.charAt(0) is '_'
        op[it] = 1
    op

buildQuery = (q)->
    for k, v of q
        if k in ['rid', 'uid', '_id', 'oid']
            q[k] = new oid(v)
    q

cleanItem = (q, isNew)->
    if isNew
        q.dateCreated = new Date()

    q.lastUpdated = new Date()

    for k,v of q
        if k in ['rid', 'uid', 'oid']
            q[k] = new oid(v)

        if k.toString().charAt(0) is '_'
            delete q[k]
    q

dataController =

    comp: (req, rsp) ->
        opt = {}
        code = req.c.code
        for k,v of req.query
            if k.indexOf('_')
                [entity,limit] = k.split('_')
                opt[entity] = do(entity,v)->
                    (cb)->
                        op =
                            skip: 0
                            limit: limit
                            sort:
                                lastUpdated: -1
                            fields:
                                title: 1
                                brief:1
                                lastUpdated:1
                                refFile:1
                                list:1
                        if v.status
                            v.status = +v.status
                        dao.find code, entity, v, op, (res)->
                            cb(null, res)

        async.parallel opt, (err, res)->
            rsp.send res

    list: (req, rsp) ->
        code = req.c.code
        qu = req.query
        if qu
            op =
                skip: util.d(qu, 'offset') || 0
                limit: util.d(qu, 'max') || 10
                sort:
                    lastUpdated: -1
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

    edit: (req, rsp) ->
        code = req.c.code
        entity = req.params.entity
        bo = req.body

        after = util.del 'afterSave', req.body
        before = util.del 'beforeSave', req.body

        _attrs = if bo._attrs
            bo._attrs.split(',')
        else
            _.keys(bo)
        cleanItem(bo)

        gs(it)(req, bo) for it in before.split(',') if before

        bo =
            $set: bo
        dao.findAndUpdate code, entity, _id: req.params.id, bo, (item)->
            gs(it)(req, item.value) for it in after.split(',') if after
            rsp.send util.r(_.pick(item.value, _attrs), 'm_update_ok', entity)

    save: (req, rsp) ->
        code = req.c.code
        entity = req.params.entity
        bo = req.body

        after = util.del 'afterSave', req.body
        _attrs = bo._attrs || ''
        _attrs = _attrs.split(',')
        _attrs.push '_id'
        cleanItem(bo, true)

        dao.save code, entity, bo, (item)->
            gs(it)(req, item) for it in after.split(',') if after
            rsp.send util.r(_.pick(item.value, _attrs), 'm_create_ok', entity)

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


module.exports = dataController