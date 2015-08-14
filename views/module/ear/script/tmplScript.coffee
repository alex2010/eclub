module.exports =
    _init: (ctx)->
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
    index: (ctx, req, rsp)->
        posts: (cb)->
            opt =
                limit: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                res || res = []
                cb(null, res)
        shop: (cb)->
            #filter =
            #   cat: 'shop'
            opt =
                limit: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'shop', {}, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
        consultant: (cb)->
            log 'zxvxzcvzxvzxvxcvzxvz'
            opt =
                limit: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'consultant', {}, opt, (res)->
                log res
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
        product: (cb)->
            opt =
                limit: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'product', {}, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb null, res

    itemList: (ctx,req,res) ->
        et = req.query.entity.toString()
        filter=
            type:"post"
            code:
                $regex:"#{et}_.*"
        matchArr=[]
        opt=
            limit:5
            sort:
                row:-1
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

    shop:(ctx, req, res) ->
        _id=req.query.id.toString()
        obj = {}
        imgs = []

        match: (cb) ->
            dao.find ctx.c.code, 'shop', {}, {}, (res)->
                for it in res
                    if it._id.toString() == _id
                        obj=it

                if obj.refFile && obj.refFile.slide
                    j=Math.min obj.refFile.slide.length, 4
                    x = 0
                    while x < j
                        #imgs.push ctx.f.resPath ctx.c, it.refFile.head
                        #imgItem=ctx.f.resPath ctx.c, obj.refFile.slide[x]
                        imgItem=obj.refFile.slide[x]
                        imgs.push imgItem
                        x++
                obj.imgs=imgs
                cb(null,obj)
    wechat: (ctx)->
        wt: (cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null, res)


