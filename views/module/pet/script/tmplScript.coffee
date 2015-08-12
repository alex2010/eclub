module.exports =

    _init: (ctx)->
        ctx.css = ctx.cssPath('css')
        menu: (cb)->
            dao.get ctx.c.code, 'role', title: 'guest', (res)->
                log res
                cb(null, res.nav)
        _cat: (cb)->
            dao.find ctx.c.code, 'cat', {},{}, (res)->
                opt = {}
                for it in res
                    opt[it.code] = it.title
                cb(null, opt)

    index: (ctx)->
        slides: (cb)->
            opt =
                limit: 6
                sort:
                    row: -1
            dao.find ctx.c.code, 'activity', {}, opt, (res)->
                cb(null, res)


        post: (cb)->
            filter = {}
            opt =
                limit: 4
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                cb(null, res)

    activityList: (ctx)->
        ctx.crumb = ctx.f.crumbItem [
            label: '活动'
        ]

        items: (cb)->
            opt =
                skip: 0
                limit: 20
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'activity', {}, opt, (res)->
                cb(null, res)

        cats: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'activity'}, {}, (res)->
                if ctx.cat
                    cat = _.where(res, {code: ctx.cat.code})
                    ctx.cat = cat[0] if cat.length
                cb(null, res)

    postList: (ctx)->
        ctx.crumb = ctx.f.crumbItem [
            label: '文章'
        ]
        items: (cb)->
            opt =
                skip: 0
                limit: 20
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                cb(null, res)

        cats: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'post'}, {}, (res)->
                if ctx.cat
                    cat = _.where(res, {code: ctx.cat.code})
                    ctx.cat = cat[0] if cat.length
                cb(null, res)

    post: (ctx)->
        ctx.crumb = ctx.f.crumbItem [
            label: '文章'
            href: '/postList'
        ,
            label: ctx.title
        ]

        user: (cb)->
            dao.get ctx.c.code, 'user', {id: ctx.uid}, (res)->
                cb(null, res)

        postList: (cb)->
            opt =
                skip: 0
                limit: 10
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                cb(null, res)


    activity: (ctx)->
        ctx.crumb = ctx.f.crumbItem [
            label: '活动'
            href: '/activityList'
        ,
            label: ctx.title
        ]

#        venue: (cb)->
#            dao.get ctx.c.code, 'venue', {_id: ctx.venue._id}, (res)->
#                cb(null, res)

        cats: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'activity'}, {}, (res)->
                cat = _.where(res, {code: ctx.cat.code})
                ctx.cat = cat[0] if cat.length
                cb(null, res)

        latest: (cb)->
            opt =
                skip: 0
                limit: 10
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'activity', {}, opt, (res)->
                cb(null, res)

#        participant: (cb)->
#            filter =
#                ref:
#                    $regex: "^#{ctx.id}x"
#            opt = {}
#            dao.find ctx.c.code, 'participant', filter, opt, (res)->
#                cb(null, res)

    content: (ctx)->
        ctx.crumb = u.crumbItem [
            label: '内容'
            href: '/contentList'
        ,
            label: item.title
        ]
