#async = require('async')
queryUtil = require './queryUtil'


batchSave = (req, rsp)->
    code = req.c.code
    et = req.params.entity
    if items = req.body.data
        for it in items
            queryUtil.cleanItem(it, true)
        dao.save code, et, items, (d)->
            rsp.send
                msg: '批量添加成功'
                data: d

module.exports =
    del: (req, rsp)->
        code = req.c.code
        entity = req.params.entity
        dao.delItem code, entity, req.body.q, null, (res)->
            unless (c = res.result.n)
                rsp.status 309
            rsp.send msg: "共删除了#{c}条数据"

    add: (req, rsp)->
        code = req.c.code
        if false
            dao.find code, 'user', username: req.header.username, (r)->
                if r.password is req.header.password
                    batchSave(req, rsp)
                    return
            rsp.send
                msg: '>_<'
        else
            batchSave(req, rsp)





