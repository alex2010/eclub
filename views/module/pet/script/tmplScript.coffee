pageOpt = (ctx, req, et)->
    opt =
        skip: +req.query.skip || 0
        limit: +req.query.limit || 10
        sort:
            lastUpdated: -1
    ctx._skip = opt.skip
    ctx._limit = opt.limit
    ctx._e = et
    opt

module.exports =
    _init: (ctx)->
        _cat: (cb)->
            dao.find ctx.c.code, 'cat', {}, {}, (res)->
                opt = {}
                for it in res
                    opt[it.code] = it
                cb(null, opt)

        wt: (cb)->
            dao.get ctx.c.code, 'pubAccount', {code: 'PostEnglishTime'}, (res)->
                cb(null, res)

    index: (ctx, req)->
#        req.session._id = '123123'
        slides: (cb)->
            opt =
                limit: 6
                sort:
                    row: -1
            dao.find ctx.c.code, 'activity', {}, opt, (res)->
                cb(null, res)

        post: (cb)->
            filter =
                status: 2
            opt =
                limit: 6
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                cb(null, res)

    activityList: (ctx, req)->
        et = 'activity'
        ctx.crumb = ctx.f.crumbItem [
            label: '活动'
        ]

        items: (cb)->
            filter = {}
            opt = pageOpt(ctx, req, et)
            dao.find ctx.c.code, et, filter, opt, (res)->
                dao.count ctx.c.code, et, filter, (count)->
                    ctx._max = count
                    cb(null, res)

        cats: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'activity'}, {}, (res)->
                if ctx.cat
                    cat = _.where(res, {code: ctx.cat.code})
                    ctx.cat = cat[0] if cat.length
                cb(null, res)

    groupList: (ctx)->
        ctx.crumb = ctx.f.crumbItem [
            label: 'PET小组'
        ]
        items: (cb)->
            opt =
                skip: 0
                limit: 20
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'group', {}, opt, (res)->
                cb(null, res)

    postList: (ctx, req)->
        et = 'post'
        ctx.crumb = ctx.f.crumbItem [
            label: '文章'
        ]
        if req.query.cat
            cat = req.query.cat.toString()
            filter =
                cat:
                    $regex: ".*#{cat}.*"
        items: (cb)->
            opt = pageOpt(ctx, req, et)
            dao.find ctx.c.code, et, (filter || {}), opt, (res)->
                dao.count ctx.c.code, et, filter, (count)->
                    ctx._max = count
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
        ctx.reg =
#            href: '/enroll/' + ctx._id
            href: tu.navUrl('enroll', ctx._id)
        #        venue: (cb)->
        #            dao.get ctx.c.code, 'venue', {_id: ctx.venue._id}, (res)->
        #                cb(null, res)

        cats: (cb)->
            dao.find ctx.c.code, 'cat', {type: 'activity'}, {}, (res)->
                if ctx.cat
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
        ctx.crumb = ctx.f.crumbItem [
            label: '内容'
            href: '/contentList'
        ,
            label: ctx.title
        ]
        contentList: (cb)->
            opt =
                skip: 0
                limit: 10
                sort:
                    lastUpdated: -1
            dao.find ctx.c.code, 'content', {}, opt, (res)->
                cb(null, res)