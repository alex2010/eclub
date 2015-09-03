module.exports =
    _init: (ctx)->
        opt =
            limit: 5
            sort:
                row: -1
        _cat: (cb) ->
            dao.find ctx.c.code, 'cat', {}, {}, (res)->
                opt = {}
                for it in res
                    opt[it.code] = it.title
                cb(null, res)
        _guest: (cb) ->
            filter =
                title: 'guest'
            dao.find ctx.c.code, 'role', filter, {}, (res)->
                cb(null, res)
        shopList: (cb)->
            dao.find ctx.c.code, 'shop', {}, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
        consultantList: (cb)->
            dao.find ctx.c.code, 'consultant', {}, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
        productList: (cb)->
            dao.find ctx.c.code, 'product', {}, opt, (res)->
                cb null, res
#    index: (ctx, req, rsp)->
#        opt =
#            limit: 5
#            sort:
#                row: -1
#        shop: (cb)->
#            dao.find ctx.c.code, 'shop', {}, opt, (res)->
#                for it in res
#                    if it.refFile && it.refFile.head
#                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
#                cb(null, res)
#        consultant: (cb)->
#            dao.find ctx.c.code, 'consultant', {}, opt, (res)->
#                for it in res
#                    if it.refFile && it.refFile.head
#                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
#                cb(null, res)
#        product: (cb)->
#            dao.find ctx.c.code, 'product', {}, opt, (res)->
#                cb null, res
    post: (ctx,req,res) ->
        postList: (cb)->
            opt =
                skip: 0
                limit: 10
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                cb(null, res)

    itemList: (ctx,req,res) ->
        opt =
            limit: 5
            sort:
                row: -1
        et = req.query.entity.toString()
        filter=
            type:"post"
            code:
                $regex:"#{et}_.*"
        matchArr=[]
        data={}

        _item:(cb) ->
            dao.find ctx.c.code, 'cat' , filter, {}, (res)->
                for it in res
                    matchArr.push it
                matchArr.sort (a,b)->
                    if a.row>b.row
                        return -1
                    else if a.row<b.row
                        return 1
                    else
                        return 0

                dao.find ctx.c.code, 'post', {cat:matchArr[0].code}, opt, (res) ->
                    data.objA=res
                    dao.find ctx.c.code, 'post', {cat:matchArr[1].code}, opt, (res) ->
                        data.objB=res
                        dao.find ctx.c.code, 'post', {cat:matchArr[2].code}, opt, (res) ->
                            data.objC=res

                            data.titleA=matchArr[0].title
                            data.titleB=matchArr[1].title
                            data.titleC=matchArr[2].title
                            cb(null,data)
#    shop:(ctx, req, res) ->
#        opt =
#            limit: 5
#            sort:
#                row: -1
#        list:(cb)->
#            dao.find ctx.c.code, 'shop', {}, opt, (res)->
#                cb(null, res)
#    consultant:(ctx, req, res) ->
#        opt =
#            limit: 5
#            sort:
#                row: -1
#        list:(cb)->
#            dao.find ctx.c.code, 'consultant', {}, opt, (res)->
#
#                cb(null, res)
#    product:(ctx, req, res) ->
#        opt =
#            limit: 5
#            sort:
#                row: -1
#        list:(cb)->
#            dao.find ctx.c.code, 'product', {}, opt, (res)->
#                cb(null, res)
    wechat: (ctx)->
        wt: (cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null, res)


