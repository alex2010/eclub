queryUtil = require './queryUtil'

module.exports = (code, entity, d, fn)->
    if d.id
        op = d.query || {}
        op._id = d.id
        if op._attrs
            op.fields = queryUtil.attrs util.d op, '_attrs'
        op = queryUtil.queryClean op
        dao.get code, entity, op, (item)->
            fn util.r(item, null, entity)
    else
        qu = d.query || {q: {}}
        op =
            skip: +util.d(qu, 'offset') || 0
            limit: +util.d(qu, 'max') || 10

        if qu.p
            _.extend op, qu.p

        if qu._attrs
            op.fields = queryUtil.attrs util.d qu, '_attrs'

        q = queryUtil.queryClean(qu.q)

        log q
        dao.find code, entity, q, op, (entities)->
            dao.count code, entity, q, (count)->
                fn util.r(entities, count)
