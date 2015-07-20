module.exports =

    _init: (ctx)->
        ctx.css = ctx.cssPath('main')
        ctx.headMenu = 'sns'
        ctx.btm_cg = [
            title: 'Private Car'
            href: '/carList'
        ,
            title: 'Private Guide'
            href: '/guideList'
        ]
        ctx.siteMap = [
            title: 'Cars & Guides'
            items: ctx.btm_cg
            row: 6
        ]
        btm_opt =
            limit: 20
            sort:
                row: -1

        city: (cb)->
            dao.get ctx.c.code, 'city', title: 'Beijing', (res)->
                cb(null, res)

        menu: (cb)->
            dao.get ctx.c.code, 'role', title: 'guest', (res)->
                menu = res.nav
                ctx.foot = res.foot
                for it in menu
                    it.cls = 'chevron-right'
                cb(null, menu)

        btm_top: (cb)->
            dao.find ctx.c.code, 'top', {}, btm_opt, (res)->
                for it in res
                    it._e = it.refClass
                    it._id = it.ref
                ctx.siteMap.push
                    top: true
                    title: 'Top Choices'
                    items: res
                    row: 10
                cb(null, res)

        btm_food: (cb)->
            dao.find ctx.c.code, 'food', {}, btm_opt, (res)->
                ctx.siteMap.push
                    title: 'Famous Food'
                    items: res
                    row: 9
                cb(null, res)

        btm_show: (cb)->
            dao.find ctx.c.code, 'show', {}, btm_opt, (res)->
                ctx.siteMap.push
                    title: 'Beijing Shows'
                    items: res
                    row: 8
                cb(null, res)

        btm_handicraft: (cb)->
            dao.find ctx.c.code, 'handicraft', {}, btm_opt, (res)->
                ctx.siteMap.push
                    title: 'Handicrafts'
                    items: res
                    row: 7
                cb(null, res)

#        btm_cg: (cb)->
#            dao.find ctx.c.code, 'cat', {type: 'cg'}, btm_opt, (res)->
#                ctx.siteMap.push
#                    title: 'Cars & Guides'
#                    items: res
#                    row: 6
#                cb(null, res)

        btm_tour: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'tour'}, btm_opt, (res)->
                for it in res
                    it.href = "/tour?cat=#{it.code}"
                ctx.siteMap.push
                    title: 'Tours'
                    items: res
                    row: 5
                cb(null, res)

        btm_map: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'map'}, btm_opt, (res)->
                for it in res
                    it.href = "/itemList?entity=map&cat=#{it.code}"
                cb(null, res)


    index: (ctx)->
        top: (cb)->
            filter =
                type: 'top'
            dao.get ctx.c.code, 'head', filter, (res)->
                cb(null, res)

        head: (cb)->
            filter =
                type: 'index'
            dao.get ctx.c.code, 'head', filter, (res)->
                cb(null, res)

    top: (ctx)->
        ctx.title = 'Top Choices In Beijing'
        item: (cb)->
            filter =
                type: 'top_intro'
            dao.get ctx.c.code, 'cat', filter, (res)->
                cb(null, res)

        topList: (cb)->
            dao.find ctx.c.code, 'top', {}, {}, (res)->
                for it in res
                    it.href = "#{it.refClass}/#{it.ref}"
                    it.small = it.subTitle
                    if it.refFile && it.refFile.list
                        it.imgPath = ctx.f.resPath ctx.c, it.refFile.list[0]
                cb(null, res)
        head: (cb)->
            dao.get ctx.c.code, 'head', {type: 'topPage'}, (res)->
                cb(null, res)

#    sightList: (ctx, req)->
#        headMenu: (cb)->
#            dao.find ctx.c.code, 'cat', {type: 'sight'}, {}, (res)->
#                for it in res
#                    it.href = "/#{it.type}List?cat=#{it.code}"
#                cb(null, res)
#        sightList: (cb)->
#            filter =
#                cat: req.query.cat
#            dao.find ctx.c.code, 'sight', filter, {}, (res)->
#                cb(null, res)

    show: (ctx)->
        ctx.info = {} unless ctx.info
        img = ctx.f.resPath(ctx.c, 'images/youtube.png')
        ctx.info.watchVideo = if ctx.info.watchVideo
            "<a target='_blank' href='#{ctx.info.watchVideo}'><img width='100%' src='#{img}'></a>"
        else
            "<p>Coming soon...</p>"

        if ctx.refFile and ctx.refFile.seat
            img = ctx.f.resPath(ctx.c, ctx.refFile.seat[0])
            ctx.info.priceSeats = "<img width='100%' onclick='cf.showPic(this)' data-url='#{img}' src='#{img}'/>"
        {}

    sight: (ctx)->
        ctx.info = {} unless ctx.info
        img = ctx.f.resPath(ctx.c, 'images/youtube.png')
        ctx.info.watchVideo = if ctx.info.watchVideo
                "<a target='_blank' href='#{ctx.info.watchVideo}'><img width='100%' src='#{img}'></a>"
            else
                "<p>Coming soon...</p>"

        headMenu: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'sight'}, {}, (res)->
                for it in res
                    it.href = "/itemList?entity=#{it.type}&cat=#{it.code}"
                cb(null, res.sortBy('row', true))

        allSights: (cb)->
            dao.find ctx.c.code, 'sight', {}, {}, (res)->
                cb(null, res.sortBy('title',false))


        map: (cb)->
            filter =
                ref: ctx._id.toString()
            dao.get ctx.c.code, 'map', filter, (res)->
                if res
                    if res.refFile and res.refFile.slide
                        ctx.info = {} unless ctx.info
    #                    ctx.info.map = ctx.f.imgItem(res, ctx.c.code, 'slide')
                        img = ctx.f.resPath(ctx.c, res.refFile.slide[0])
                        ctx.info.map = "<img width='100%' onclick='cf.showPic(this)' data-url='#{img}' src='#{img}'>"
                cb(null, res)


    carList: (ctx, req)->
        ctx.title = 'Private Car Service in Beijing'

        ctx.headMenu = [
            title: 'Private Car'
            href: '/carList'
            cur: true

        ,
            title: 'Private Guide'
            href: '/guideList'
        ]

        _items: (cb)->
            filter = {}
            et = 'car'
            dao.find ctx.c.code, et, filter, {}, (res)->
                dao.count ctx.c.code, et, filter, (count)->
                    cb null, res


    guideList: (ctx, req)->
        ctx.title = 'Private Guide In Beijing'

        ctx.headMenu = [
            title: 'Private Car'
            href: '/carList'
        ,
            title: 'Private Guide'
            href: '/guideList'
            cur: true
        ]
        _items: (cb)->
            filter = {}
            et = 'guide'
            dao.find ctx.c.code, et, filter, {}, (res)->
                dao.count ctx.c.code, et, filter, (count)->
                    cb null, res

    itemList: (ctx, req)->
        et = req.query.entity

        title = et.capitalize()
        if et in ['show','handicraft']
            title += 's'
        else if et is 'sight'
            title = 'Attractions'


        ctx.title = "Most Famous #{title} In Beijing"
        ctx._entity = et

        head: (cb)->
            if req.query.cat
                cb()
            else
                filter =
#                    row:
#                        $gt: 1000
                    type: et

                dao.get ctx.c.code, 'head', filter, (res)->
                    cb(null, res)

        headMenu: (cb)->
            dao.find ctx.c.code, 'cat', {type: et}, {}, (res)->
                for it in res
                    it.href = "/itemList?entity=#{it.type}&cat=#{it.code}"
                cb(null, res.sortBy('row', true))

        item: (cb)->
            if req.query.cat
                cb()
            else
                filter =
                    type: et + '_intro'
                dao.get ctx.c.code, 'cat', filter, (res)->
                    cb(null, res)

        _items: (cb)->
            filter = {}
            qu = req.query
            if qu.cat
                filter.cat =
                    $regex: ".*#{qu.cat}.*"
            dao.find ctx.c.code, et, filter, {}, (res)->
                dao.count ctx.c.code, et, filter, (count)->
                    for it in res
                        it.href = "/#{it._e}/#{it._id}"
                        if et isnt 'sight'
                            it.small = it.subTitle

                        if it.refFile && it.refFile.list
                            le = it.refFile.list.length
                            idx = 0
                            if le > 1
                                idx = ctx.f.randomInt(0, le - 1)
                            it.imgPath = ctx.f.resPath ctx.c, it.refFile.list[idx]

                        if et is 'map'
                            if it.refFile && it.refFile.slide
                                it.list = it.refFile.slide
                                it.url = ctx.f.resPath ctx.c, it.refFile.slide[idx]


                    if et in ['sight', 'map'] and count > res.length
                        qu.max || qu.max = 10
                        offset = (qu.offset || 0) + qu.max
                        ctx.morePath = "/itemList?entity=#{filter.cat}&offset=#{offset}&max=#{qu.max}"

                    cb(null, res)

    tour:(ctx,req)->
        ctx.cat = req.query.cat
        filter = {}
        if ctx.cat
            filter = code: ctx.cat

        items:(cb)->
            et = 'tour'
            dao.find ctx.c.code, et, filter,{},(res)->
                dao.count ctx.c.code, et, filter, (count)->
                    cb null, res

        headMenu: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'tour'}, {}, (res)->
                ctx.catMap = {}
                for it in res
                    it.href = "/tour?cat=#{it.code}"
                    ctx.catMap[it.code] = it.title
                cb(null, res.sortBy('row', true))


    content: (ctx, req)->
        log 'zzz'


#                dao.find ctx.c.code, 'food', {}, {}, (res)->
#                ctx.slides = []
#                for it in res
#                    ctx.slides.push it if it.row > 1000
#                cb(null, res)
#    attraction: (ctx)->
#        ctx.pageTitle = "The Attractions in Beijing"
#        headMenu: (cb)->
#            dao.find ctx.c.code, 'cat', {type: 'sight'}, {}, (res)->
#                for it in res
#                    it.href = "/#{it.type}List?cat=#{it.code}"
#                cb(null, res)
#
#        sightList: (cb)->
#            dao.find ctx.c.code, 'sight', {}, {}, (res)->
#                cb(null, res)


