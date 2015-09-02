opt =
    limit: 5
    sort:
        row: -1
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
        _serShop_time: (cb) ->
            res =
                titles: ['10年以上', '5-10年', '1-5年'],
                radio: false,
                name: ''
            cb(null, res)
        _serShop_area: (cb) ->
            res =
                titles: ['200㎡以上', '100-200㎡', '60-100㎡', '60㎡以下'],
                radio: false,
                name: ''
            cb(null, res)
        _serShop_server: (cb) ->
            res =
                titles: ['可停车', '可上门服务'],
                radio: false,
                name: ''
            cb(null, res)
        _serShop_brand: (cb) ->
            res =
                titles: ['丹麦奥迪康', '丹麦瑞芬达', '丹麦唯听', '瑞士峰力', '瑞士博瑞峰', '加拿大优利康', '德国西门子', '新加坡欧仕达', '美国斯达克', '美国斯丽声'],
                radio: false,
                name: ''
            cb(null, res)

        _serConsultant_time: (cb) ->
            res =
                titles: ['10年以上', '5-10年', '1-5年'],
                radio: false,
                name: ''
            cb(null, res)
        _serConsultant_position: (cb) ->
            res =
                titles: ['二级验配师（最高）', '三级验配师', '四级验配师'],
                radio: false,
                name: ''
            cb(null, res)
        _serConsultant_goodAt: (cb) ->
            res =
                titles: ['成人助听器验配', '儿童助听器验配', '听力咨询', '康复指导', '声场评估', '真耳分析'],
                radio: false,
                name: ''
            cb(null, res)


    index: (ctx, req, rsp)->
        posts: (cb)->
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                res || res = []
                cb(null, res)
        shop: (cb)->
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
            opt =
                limit: 5
                sort:
                    row: -1
            dao.find ctx.c.code, 'consultant', {}, opt, (res)->
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
                cb null, res

    post: (ctx, req, res) ->
        postList: (cb)->
            opt =
                skip: 0
                limit: 10
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                cb(null, res)

    itemList: (ctx, req, res) ->
        et = req.query.entity.toString()
        filter =
            type: "post"
            code:
                $regex: "#{et}_.*"
        matchArr = []
        opt =
            limit: 5
            sort:
                row: -1
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

    shop: (ctx, req, res) ->
#        match: (cb) ->
#            obj = {}
#            imgs = []
#            dao.find ctx.c.code, 'shop', {}, {}, (res)->
#                for it in res
#                    if it._id.toString() == _id
#                        obj=it
#
#                if obj.refFile && obj.refFile.slide
#                    j=Math.min obj.refFile.slide.length, 4
#                    x = 0
#                    while x < j
#                        imgItem=obj.refFile.slide[x]
#                        imgs.push imgItem
#                        x++
#                obj.imgs=imgs
#                cb(null,obj)

#        detail: (cb) ->
#            obj = {}
#            dao.find ctx.c.code, 'shop', {}, {}, (res)->
#                for it in res
#                    if it._id.toString() == _id
#                        obj=it
#                cb(null,obj)
        shopList: (cb)->
            dao.find ctx.c.code, 'shop', {}, opt, (res)->
                cb(null, res)

    consultant: (ctx, req, res) ->
        _id = req.query.id.toString()
        detail: (cb) ->
            obj = {}
            dao.find ctx.c.code, 'consultant', {}, {}, (res) ->
                for it in res
                    if it._id.toString() == _id
                        obj = it
                cb(null, obj)

    wechat: (ctx)->
        wt: (cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null, res)


