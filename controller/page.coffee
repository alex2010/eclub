u = util
oid = require('mongodb').ObjectID
async = require('async')
jade = require('jade')

String::splitCap = (i, t)->
    (it.capitalize() for it in @split(i)).join(t)

pageOpt = (req)->
    c = req.c
    code = c.code

    if req.originalUrl.indexOf('/console') > -1
        libPath = "#{c.resPath}/upload/console/lib/"
    else
        libPath = "#{c.resPath}/upload/#{code}/lib/"

    resPath = "#{c.resPath}/upload/#{code}/"
    tRender: jade.renderFile
    mob: req.mob
    lang: req.query.lang || 'zh'
    title: c.title
    mode: app.env
    _ts: new Date().getTime()
    c: c
    main: (if req.mob then 'mob' else 'main')
    f: require('../ext/tmpl')
    cstr: JSON.stringify(_.pick(c, 'code', 'name', 'url', '_id', 'resPath'))
    libPath: libPath
    resPath: resPath
#    cssPath: (name = 'css')->
#        if app.env
#            if name is 'admin'
#                "/lib/admin/style/#{name}.css"
#            else
#                "/module/#{c.code}/src/style/#{name}.css"
#        else
#            "#{libPath}#{name}.css?#{new Date().getTime()}"
#    jsPath: (name = 'main')->
#        "#{libPath}#{name}.js?#{new Date().getTime()}"


pre = (req)->
    ctx = pageOpt(req)

    if req.query.dev
        ctx.dev = true
    ps = req.params
    ctx.index = ps.page || ps.entity || 'index'
    ctx

pickScript = (ctx, req)->
    ts =
        console: (ctx)->
            ctx.app = 'admin'
            null
    sc = require("../views/module/#{ctx.c.code}/script/tmplScript")

    ctx.langs = {}
    initOpt = sc._init(ctx, req) || {}

    opt = if sc[ctx.index]
        sc[ctx.index](ctx, req) || {}
    else if ts[ctx.index]
        ts[ctx.index](ctx, req) || {}
    else
        {}
    opt.i18 = (cb)->
        dao.find ctx.c.code, "i18n", {lang: req.query.lang || 'zh'}, {}, (res)->
            for it in res
                ctx.langs[it.key] = it.val
            cb null, require('../service/lang')(ctx.langs)

    _.extend initOpt, opt

render = (req, rsp, ctx)->
#    if req.fp
    opt = pickScript(ctx, req)
    dao.pick(_mdb, 'cache').ensureIndex time: 1,
        expireAfterSeconds: 7200
        background: true

    async.parallel opt, (err, res)->
        _.extend ctx, res
        str = jade.renderFile("#{req.fp}/#{ctx.index}.jade", ctx)

        unless app.env
            dao.save _mdb, 'cache',
                k: req.k
                str: str
                mob: req.mob
                time: new Date()
        rsp.end str


checkMob = (req,rsp) ->
    url = "#{req.protocol}://#{req.hostname}#{if app.env then ':3000' else ''}#{req.originalUrl}"
    if /mobile/i.test(req.headers['user-agent'])
        req.mob = true
        if !req.query.mob
            pp = url + "#{if _.isEmpty(req.query) then '?' else '&'}mob=1"
            log 'mob redirect '+pp
            rsp.redirect pp
    else
        req.mob = false
        if req.query.mob
            delete req.query.mob
            url = if url.indexOf('&mob=1') > -1
                url.replace('&mob=1','')
            else if url.endsWith('?mob=1') > -1
                url.replace('?mob=1','')
            else if url.indexOf('?mob=1') > -1
                url.replace('mob=1&','')
            rsp.redirect url

module.exports =
    page: (req, rsp) ->
        render req, rsp, pre(req)

    entity: (req, rsp) ->
        et = req.params.entity
        if req.params.id.length is 24
            ctx = pre(req)
            filter = {}
            if req.params.attr
                filter[req.params.attr] = req.params.id
            else
                filter._id = req.params.id
            dao.get ctx.c.code, et, filter, (item)->
                unless item
                    rsp.end('no item')

                filter =
                    skip: 0
                    limit: 10
                    sort:
                        lastUpdated: -1

                ctx = _.extend ctx, item
                opt =
                    status: 2
                dao.find ctx.c.code, et, {}, filter, (res)->
                    if res.length
                        ctx["#{et}List"] = res

                render req, rsp, ctx
        else
            rsp.end 'wrong param'