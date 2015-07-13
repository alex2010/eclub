module.exports =
    _init: (ctx)->

    index: (ctx, req, rsp)->

    wechat:(ctx)->
        wt:(cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null,res)
