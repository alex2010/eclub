module.exports =
    _init: (ctx)->

    index: (ctx, req, rsp)->
        posts: (cb)->
            log 'posts'
            dao.find ctx.c.code, 'post', {}, (res)->
                log res
                cb(null,res)

    wechat:(ctx)->

        wt:(cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null,res)
