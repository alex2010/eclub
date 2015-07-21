module.exports =
    _init: (ctx)->

    index: (ctx, req, rsp)->
        posts: (cb)->
            dao.find ctx.c.code, 'post', {},{}, (res)->
                res || res = []
                log res
                cb(null,res)

    wechat:(ctx)->
        wt:(cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null,res)
