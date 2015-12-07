
module.exports =
    _init: (ctx)->
        _.extend ctx.langs,
            shop:'验配中心'
            consultant: '验配师'
            product: '助听器'

        ctx._cd =
            shop:
                func: 'slide'
                text: 'address'
            consultant:
                func: 'head'
                text: 'description'
            product:
                func: 'slide'
                text: 'description'

        wt: (cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null, res)


        _guest: (cb) ->
            filter =
                title: 'guest'
            dao.find ctx.c.code, 'role', filter, {}, (res)->
                cb(null, res)

    post: (ctx, req, res) ->
        postList: (cb)->
            opt =
                skip: 0
                limit: 10
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                cb(null, res)
    index: (ctx, req, res) ->
        opt =
            limit: 5
            sort:
                row: -1
        #        _cat: (cb) ->
        #            dao.find ctx.c.code, 'cat', {}, {}, (res)->
        #                opt = {}
        #                for it in res
        #                    opt[it.code] = it.title
        #                cb(null, res)
        shopList: (cb)->
            dao.find ctx.c.code, 'shop', {}, opt, (res)->
                cb(null, res)
        consultantList: (cb)->
            dao.find ctx.c.code, 'consultant', {}, opt, (res)->
                cb(null, res)
        productList: (cb)->
            dao.find ctx.c.code, 'product', {}, opt, (res)->
                cb null, res

#    entityList: (ctx, req, res)->
#        et = req.query.entity.toString()
#
#        if req.query.cat
#            cat = req.query.cat.toString()
#            filter =
#                cat:
#                    $regex: ".*#{cat}.*"
#        items: (cb)->
#            opt = pageOpt(ctx, req, et)
#            dao.find ctx.c.code, et, (filter || {}), opt, (res)->
#                dao.count ctx.c.code, et, filter, (count)->
#                    ctx._max = count
#                    cb(null, res)
#        cats: (cb)->
#            dao.find ctx.c.code, 'cat', {type: et}, {}, (res)->
#                if ctx.cat
#                    cat = _.where(res, {code: ctx.cat.code})
#                    ctx.cat = cat[0] if cat.length
#                cb(null, res)

    itemList: (ctx, req, res) ->
        opt =
            limit: 5
            sort:
                row: -1
        et = req.query.entity.toString()
        filter =
            type: "post"
            code:
                $regex: "#{et}_.*"
        matchArr = []
        data = {}

        _item: (cb) ->
            dao.find ctx.c.code, 'cat', filter, {}, (res)->
                for it in res
                    matchArr.push it
                matchArr.sort (a, b)->
                    if a.row > b.row
                        return -1
                    else if a.row < b.row
                        return 1
                    else
                        return 0

                dao.find ctx.c.code, 'post', {cat: matchArr[0].code}, opt, (res) ->
                    data.objA = res
                    dao.find ctx.c.code, 'post', {cat: matchArr[1].code}, opt, (res) ->
                        data.objB = res
                        dao.find ctx.c.code, 'post', {cat: matchArr[2].code}, opt, (res) ->
                            data.objC = res
                            data.titleA = matchArr[0].title
                            data.titleB = matchArr[1].title
                            data.titleC = matchArr[2].title
                            cb(null, data)

    seckillingList: (ctx, req, rsp) ->
        opt =
            limit: 5
            sort:
                row: -1
        filter = {}
        list: (cb) ->
            dao.find ctx.c.code, 'seckilling', filter, opt, (res)->
                cb(null, res)

    shop: (ctx, req, rsp)->
        consultant: (cb)->
            opt =
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'consultant', {'shop._id': ctx._id}, opt, (res)->
                cb(null, res)

    cardList: (ctx, req, rsp)->
        opt =
            limit: 5
            sort:
                row: -1
        filter = {}
        list: (cb) ->
            dao.find ctx.c.code, 'card', filter, opt, (res)->
                cb(null, res)