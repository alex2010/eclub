save = require '../../service/dao/save'
find = require '../../service/dao/find'
edit = require '../../service/dao/edit'
del = require '../../service/dao/del'

module.exports = (code, d, fn)->
    if d._method
        switch d._method
            when 'create'
                save code, d.ent, d, (ri, msg)->
                    if ri.error
                        fn ri
                    else
                        fn util.r(ri, msg, ri._e)

            when 'update', 'patch'
                edit code, d.ent, d, (ri, msg)->
                    if ri.error
                        fn ri
                    else
                        fn util.r(ri, msg, ri._e)

            when 'read'
                find code, d.ent, d, fn

            when 'delete'
                del code, d.ent, d, fn

            else
                fn(err: true)
#
#
#
#
#if d._method
#        switch d._method
#            when 'create'
#                save code, d, (ri, msg)->
#                    fn util.r(ri, msg, ri._e)
#
#            when 'update', 'patch'
#                edit code, d, (ri, msg)->
#                    fn util.r(ri, msg, ri._e)
#
#            when 'read'
#                find code, d, fn
#
#            when 'delete'
#                del code, d, fn
#
#            else
#                fn(err: true)
#

#                entity = d.ent
#                bo = d.body
#
#                after = util.del 'afterSave', bo
#                before = util.del 'beforeSave', bo
#
#                if before
#                    rt = []
#                    for it in before.split(',')
#                        res = gs(it)(d, bo)
#                        if res.error
#                            rt.push res.msg
#                    if rt.length
#                        fn
#                            err: true
#                            errors: rt
#                        return
#
#                _rsMsg = bo._rsMsg
#                _attrs = if bo._attrs
#                    bo._attrs.split(',')
#                else
#                    _.keys(bo)
#
#                queryUtil.cleanItem(bo)
#
#                bo =
#                    $set: bo
#                dao.findAndUpdate code, entity, d.q, bo, (item)->
#                    queryUtil.afterPersist(item, entity)
#
#                    gs(it)(d, item) for it in after.split(',') if after
#
#                    _attrs.push('_id')
#
#                    fn util.r(_.pick(item, _attrs), _rsMsg || 'm_update_ok', entity)

#
#        entity = d.ent
#                dao.delItem code, entity, _id: new oid(d.id), null, ->
#                    if entity is 'user'
#                        dao.delItem code, 'membership', uid: new oid(d.id)
#                    fn msg: 'del.ok'
