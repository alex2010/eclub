module.exports =
    _init: (ctx)->

    index: (ctx, req, rsp)->
        posts: (cb)->
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                res || res = []
#                log 'test'
#                log res
                cb(null,res)
        place: (cb)->
            filter =
                cat: 'place'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc=ctx.f.resPath ctx.c, it.refFile.head
                cb(null,res)
        master: (cb)->
            filter =
                cat:'master'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc=ctx.f.resPath ctx.c, it.refFile.head
                cb(null,res)
        brand: (cb)->
            filter =
                cat: 'brand'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc=ctx.f.resPath ctx.c, it.refFile.head
                cb null,res

    list:(ctx,req,res) ->
        place: (cb)->
            filter =
                cat: 'place'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc=ctx.f.resPath ctx.c, it.refFile.head
                cb(null,res)
        master: (cb)->
            filter =
                cat:'master'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc=ctx.f.resPath ctx.c, it.refFile.head
                cb(null,res)
        brand: (cb)->
            filter =
                cat: 'brand'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc=ctx.f.resPath ctx.c, it.refFile.head
                cb null,res

    wechat:(ctx)->
        wt:(cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null,res)
