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
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                res || res = []
                cb(null, res)
        shop: (cb)->
            #filter =
            #   cat: 'shop'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'shop', {}, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
        master: (cb)->
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'master', {}, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
        product: (cb)->
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'product', {}, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb null, res

    list: (ctx, req, res) ->
        product:(cb) ->
            opt=
                limits:5
                sort:
                    row:-1
            dao.find ctx.c.code, 'product', {}, opt, (res)->
                cb(null,res)

        hearing:(cb) ->
            filter=
                cat:'hearing'
            opt=
                limits:5
                sort:
                    row:-1
            dao.find ctx.c.code, 'health', filter, opt, (res)->
                cb(null,res)

        rehabilitate:(cb) ->
            filter=
                cat:'rehabilitate'
            opt=
                limits:5
                sort:
                    row:-1
            dao.find ctx.c.code, 'health', filter, opt, (res)->
                cb(null,res)


        shop: (cb)->
            filter =
                cat: 'shop'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
        master: (cb)->
            filter =
                cat: 'master'
            opt =
                limits: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                for it in res
                    if it.refFile && it.refFile.head
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb(null, res)
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
                        it.imgSrc = ctx.f.resPath ctx.c, it.refFile.head
                cb null, res

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

                #log 'aaaaaaaa'+imgs
                cb(null,obj)
    wechat: (ctx)->
        wt: (cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null, res)
