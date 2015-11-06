module.exports =
    _init: (ctx, req, rsp)->

    index: (ctx, req, rsp)->
        post: (cb)->
            opt =
                limit: 3
            filter =
                cat: 'hot'
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                cb(null, res)

#        ft_content: (cb)->