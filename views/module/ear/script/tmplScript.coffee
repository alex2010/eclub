#
#btm_opt =
#    limit: 20
#    fields: '_e,title'.split(',')
#    sort:
#        row: -1
async = require('async')

module.exports =
    _init: (ctx)->
        ctx._cd =
            post:
                func: 'head'
                text: 'brief'
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
        filter =
            status: 2
        #                $ne: 1
        shopList: (cb)->
            dao.find ctx.c.code, 'shop', filter, opt, (res)->
                cb(null, res)
        consultantList: (cb)->
            dao.find ctx.c.code, 'consultant', filter, opt, (res)->
                cb(null, res)
        productList: (cb)->
            dao.find ctx.c.code, 'product', filter, opt, (res)->
                cb null, res

    itemList: (ctx, req, res) ->
        opt =
            limit: 5
            sort:
                row: -1
        et = req.query.entity
        filter =
            type: "post"
            code:
                $regex: "#{et}_.*"

        _item: (cb) ->
            data = {}
            dao.find ctx.c.code, 'cat', filter, {}, (res)->
                cbs = (for it in res
                    code = it.code
                    data[code] =
                        title: it.title
                        code: code
                    do(code)->
                        (ccb) ->
                            dao.find ctx.c.code, 'post', {cat: code}, opt, (r) ->
                                data[code].items = r
                                ccb(null,r)
                )
                async.parallel cbs, (err, rr)->
                    cb(null, _.values data)

    seckillingList: (ctx, req, rsp) ->
        opt =
            limit: 5
            sort:
                row: -1
        filter = {}
        list: (cb) ->
            dao.find ctx.c.code, 'seckilling', filter, opt, (res)->
                cb(null, res)

    consultant: (ctx, req, rsp)->
        answer: (cb)->
            filter =
                'user._id': ctx.uid
                status: 2
            dao.find ctx.c.code, 'answer', filter, {}, (res)->
                cb(null, res)

    shop: (ctx, req, rsp)->
        answer: (cb)->
            filter =
                'shop._id': ctx._id
                status: 2
            dao.find ctx.c.code, 'answer', filter, {}, (res)->
                cb(null, res)

        consultant: (cb)->
            dao.find ctx.c.code, 'consultant', {'shop._id': ctx._id}, {}, (res)->
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