module.exports = _.extend require('../ext/tmpl'),
    setOpt:()->
        @tmplOpt = {}
        
    tmpl: (ctx, name, opt)->
        opt.f = ctx.f
        opt.c = ctx.c
        jade.renderFile("#{_path}/public/module/#{ctx.c.code}/app/tmpl/#{name}.jade", opt)

    jsa: (k, ar)->
        args = util.slice.call(arguments)
        res = (for it in ar
            rr = args.slice(2)
            rr.unshift it
            _.pick.apply @, rr
        )
        "#{k} = #{JSON.stringify(res)};"

    jsp: (k)->
        args = util.slice.call(arguments)
        "#{k} = #{JSON.stringify(_.pick.apply(@, args.slice(1)))};"