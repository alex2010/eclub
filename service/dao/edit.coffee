queryUtil = require './queryUtil'

module.exports = (code, entity, d, fn)->
    bo = d.body

    after = util.del 'afterSave', bo
    before = util.del 'beforeSave', bo

    if before
        rt = []
        for it in before.split(',')
            res = gs(code, it)(d, bo)
            if res and res.error
                rt.push res.msg
        if rt.length
            fn
                err: true
                errors: rt
            return

    _rsMsg = bo._rsMsg

    if bo._attrs
        _attrs = bo._attrs.split(',')

    if bo._unset
        unset = bo._unset

    queryUtil.cleanItem(bo)

    bo =
        $set: bo

    if unset
        bo.$unset = unset

    filter = if d.q
        d.q
    else
        _id: d.id

    dao.findAndUpdate code, entity, filter, bo, (item)->
        queryUtil.afterPersist(item, entity)

        gs(code, it)(d, item) for it in after.split(',') if after

        ri = if _attrs
            _attrs.push('_id')
            _.pick(item, _attrs)
        else
            item

        fn ri, _rsMsg || 'm_update_ok'