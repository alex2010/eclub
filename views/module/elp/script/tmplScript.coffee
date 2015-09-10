module.exports =
    _init: (ctx)->
        opt =
            limit: 10
            sort:
                row: -1
        wt: (cb)->
            dao.get ctx.c.code, 'pubAccount', {}, (res)->
                cb(null, res)
        postList: (cb)->
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                cb(null, res)
        dsList: (cb)->
            dao.find ctx.c.code, 'ds', {}, opt, (res)->
                cb(null, res)
        projectList: (cb)->
            dao.find ctx.c.code, 'project', {}, opt, (res)->
                cb(null, res)
        activityList: (cb)->
            dao.find ctx.c.code, 'activity', {}, opt, (res)->
                cb(null, res)

    index: (ctx)->
        head: (cb)->
            dao.get ctx.c.code, 'head', {type: 'wechat'}, (res)->
                log res
                cb(null, res)

        posts: (cb)->
            opt =
                skip: 0
                limit: 20
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', {}, opt, (res)->
                cb(null, res)

    search: (ctx)->
        elps: (cb)->
            dao.find ctx.c.code, 'org', {}, {}, (res)->
                cb null, res
#    activity:(ctx)->
#        wt:(cb)->
#            dao.get ctx.c.code, 'pubAccount', {}, (res)->
#                cb(null,res)

#    search:(ctx)->
#        elps:(cb)->
#            opt =
#                skip: 0
#                limit: 20
#                sort:
#                    lastUpdated: -1
#            dao.find ctx.c.code, 'org', {}, opt, (res)->
#                for it in res
#                    it.href = "/org/#{it._id}"
#                    it.imgPath = 'next'
#                cb(null, res)
#    org:(ctx)->
#        member:(cb)->
#            dao.find ctx.c.code, 'user', pClass: ctx.title, {}, (res)->
#                cb null, res

#        ctx.css = ctx.cssPath('css')
#        menu: (cb)->
#            dao.get ctx.c.code, 'role', title: 'guest', (res)->
#                log res
#                cb(null, res.nav)

#    index: (ctx)->
#        slides: (cb)->
#            opt =
#                limit: 6
#                sort:
#                    row: -1
#            dao.find ctx.c.code, 'activity', {}, opt, (res)->
#                cb(null, res)
#
#        post: (cb)->
#            filter = {}
#            opt =
#                limit: 4
#                sort:
#                    lastUpdated: -1
#            dao.find ctx.c.code, 'post', filter, opt, (res)->
#                cb(null, res)
#
#    activityList: (ctx)->
#        ctx.crumb = ctx.f.crumbItem [
#            label: '活动'
#        ]
#
#        items: (cb)->
#            opt =
#                skip: 0
#                limit: 20
#                sort:
#                    lastUpdated: -1
#            dao.find ctx.c.code, 'activity', {}, opt, (res)->
#                cb(null, res)
#
#        cats: (cb)->
#            dao.find ctx.c.code, 'cat', {type: 'activity'}, {}, (res)->
#                if ctx.cat
#                    cat = _.where(res, {code: ctx.cat.code})
#                    ctx.cat = cat[0] if cat.length
#                cb(null, res)
#
#    postList: (ctx)->
#        ctx.crumb = ctx.f.crumbItem [
#            label: '文章'
#        ]
#        items: (cb)->
#            opt =
#                skip: 0
#                limit: 20
#                sort:
#                    lastUpdated: -1
#            dao.find ctx.c.code, 'post', {}, opt, (res)->
#                cb(null, res)
#
#        cats: (cb)->
#            dao.find ctx.c.code, 'cat', {type: 'post'}, {}, (res)->
#                if ctx.cat
#                    cat = _.where(res, {code: ctx.cat.code})
#                    ctx.cat = cat[0] if cat.length
#                cb(null, res)
#
#    post: (ctx)->
#        ctx.crumb = ctx.f.crumbItem [
#            label: '文章'
#            href: '/postList'
#        ,
#            label: ctx.title
#        ]
#
#        user: (cb)->
#            dao.get ctx.c.code, 'user', {id: ctx.uid}, (res)->
#                cb(null, res)
#
#        postList: (cb)->
#            opt =
#                skip: 0
#                limit: 10
#                sort:
#                    lastUpdated: -1
#            dao.find ctx.c.code, 'post', {}, opt, (res)->
#                cb(null, res)
#
#
#    activity: (ctx)->
#        ctx.crumb = ctx.f.crumbItem [
#            label: '活动'
#            href: '/activityList'
#        ,
#            label: ctx.title
#        ]
#
#        venue: (cb)->
#            dao.get ctx.c.code, 'venue', {title: ctx.venue.title}, (res)->
#                cb(null, res)
#
#        cats: (cb)->
#            dao.find ctx.c.code, 'cat', {type: 'activity'}, {}, (res)->
#                cat = _.where(res, {code: ctx.cat.code})
#                ctx.cat = cat[0] if cat.length
#                cb(null, res)
#
#        latest: (cb)->
#            opt =
#                skip: 0
#                limit: 10
#                sort:
#                    lastUpdated: -1
#            dao.find ctx.c.code, 'activity', {}, opt, (res)->
#                cb(null, res)
#
#        participant: (cb)->
#            filter =
#                ref:
#                    $regex: "^#{ctx.id}x"
#            opt = {}
#            dao.find ctx.c.code, 'participant', filter, opt, (res)->
#                cb(null, res)
#
#
#
#
#    content: (ctx)->
#        ctx.crumb = u.crumbItem [
#            label: '内容'
#            href: '/contentList'
#        ,
#            label: item.title
#        ]
