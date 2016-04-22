module.exports =
    randomInt: util.randomInt
    randomChar: util.randomChar

    viewItem: (entity, k, v)->
        opt = meta[entity][k] || meta.common[k]
        if opt.showText
            opt.showText(v)
        else if opt.type is 'text' or !opt.type
            v
        else if opt.type in ['select', 'radio']
            if opt.data and +v
                _.result(opt, 'data')[+v]
            else
                v
        else if opt.type is 'status'
            cf.st.text(entity + '_status', v)
        else
            v

    dStr: (str, len = 19)->
        if str
            str.replace(/-/g, "/").replace(/[TZ]/g, " ").substr(0, len)
        else
            ''

    copyRight: (c, name, id)->
        path = "http://#{c.url}/#{name}/#{id}"
        """
        <div class="copyright"><strong>C</strong><div>
            <p>除非特别声明，本站文章均为原创文章，转载请注明原文链接</p>
        </div></div>
        """
    navPage: (page, it)->
        "/#{page}/#{it._id}"

    crumbItem: (items)->
        [
            label: '首页'
            href: '/'
        ].concat items

    img: (path, cls = 'avatar', pop = false, p, isbb = true)->
        p ?=''
        p += if pop then " onclick='cf.showPic(this)'" else ''
        src = if isbb
            'bb-src'
        else
            'src'
        "<img id='#{String.randomChar(4)}' class='#{cls} _imgBox' #{src}='#{path}' #{p}/>"

    imgItem: (it, c, name = 'head', cls, index = 0, pop, isbb)->
        path = if it and name in ['id', 'portrait']
            "portrait/#{it._id}.jpg"
        else if it and it.refFile and it.refFile[name]
            it.refFile[name][index]
        else
            null
        if path
            @img @resPath(c, path), cls, pop, null, isbb
        else
            ''

    userPic: (c, id, cls = 'img-circle img-fluid')->
        @img(@resPath(c, 'portrait/' + id + '.jpg'), cls)

    resPath: (c, path)->
        c.resPath + '/upload/' + c.code + '/' + path

    avatarImg: (c, user, cls = 'img-circle')->
        p = @resPath c, "portrait/#{user._id}.jpg"
        @img p, cls

    catLink: (cat, list = [])->
        res = []
        for it in cat.split(',')
            item = list.findBy('code', it)
            if item
                res.push @link item
        res.join(' / ')

    avatar: (user, c, name = 'portrait')->
        if user.refFile and user.refFile[name]
            p = @img(@resPath(c, user.refFile[name][0]), c)
        else
            pp = @resPath(c, 'portrait.jpg')
            p = "<img src='#{pp}'/>"
        "<a href='/user/#{user._id}' title='#{user.username}'>#{p}<div>#{user.username}</div></a>"


    adt: util.adjustText

    navUrl: (p)->
        return '#' unless p
        if arguments[0].charAt(0) is '#'
            k = arguments[0]
        else
            k = "#!"
            for it in arguments
                if _.isString(it) or _.isNumber(it)
                    k += '/' + it
        k

    tmpl: (name, opt, lib)->
#        if _jadeRender
#            _jadeRender(name,opt)
#        else
        cf.rtp name, opt, lib
#            jade.renderFile("#{req.fp}/#{ctx.index}.jade", opt)

    actDate: (start, end)->
        "#{start.substr(0, 16)}-#{end.substr(11, 5)}"

    label: (text, type = 'success', cls)->
        "<span class='label label-#{type} #{cls}'>#{text}</span>"

    btn: (text, act, style = 'default', size, block, etc)->
        cls = cf.style.btn(style, size, block, etc)
        "<button type='button' class='#{cls} #{act}'>#{text || ''}</button>"

    aBtn: (text, href, style = 'default', size, block, etc)->
        cls = cf.style.btn(style, size, block, etc)
        "<a href='#{href}' class='#{cls}'>#{text || ''}</a>"

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

    pCenter: (ct, cls = 'mt')->
        "<p class='text-center #{cls || ''}'>#{ct}</p>"

    a: (href, text, cls)->
        str = if href then "href='#{href}' " else ''
        str += if cls then "class='#{cls}' " else ''
        str += "target='_blank' " unless href.startsWith('#')
        "<a #{str} title='#{text}'>#{text}</a>"

    link: (it, prop = 'title', cls)->
        text = if prop is '_str'
            it
        else if it
            it[prop]
        return '' unless text
        href = it.href
        unless href
            href = if it._e is 'cat'
                "/#{it.type.split('_')[0]}List?cat=#{it.code}"
            else
                "/#{it._e}/#{it._id}"
        @a(href, text, cls)


    iBtn: (cls, key, href)->
        key = cls unless key
        cls: cf.style.btn null, 'sm', false, util.iClass(cls) + ' ' + key
        id: true
        title: iic key
        href: href
        onclick: 'cf.showPic(this)'

    tBtn: (label, href, icon, cls, title, id)->
        unless util.isChinese label
            label = ii label
        label: label
        href: href
        icon: icon and util.icon icon
        cls: cls #+' '+label
        title: title and iic title
        id: id

    genBtn: (cfg, it)->
        return unless cfg
        if cfg.btn
            tag = $('<button type="button"/>')
        else
            tag = $("<a/>")
        tag.addClass cfg.key
        if cfg.href
            tag.attr 'href', cfg.href
            if cfg.href.startsWith 'http'
                tag.attr 'target', '_blank'
        cfg.id and tag.attr 'id', util.randomChar(4) + '-' + it?.id
        cfg.label and tag.text cfg.label
        cfg.title and tag.attr 'title', cfg.title
        if cfg.attr
            for k,v of cfg.attr
                tag.attr k, v
        cfg.cls and tag.addClass cfg.cls
        if cfg.icon
            if cfg.icon.startsWith '<'
                icon = cfg.icon
            else
                icon = util.icon(cfg.icon)
            tag[cfg.iconPlace || 'prepend'] icon
        cfg.callback?(tag)
        if cfg.action # event for larger tag
            tag.on(cfg.action.type || 'click', cfg.action.fun)
        tag

    lt: (obj, sc, ets, fun, tag = 'span')->
        id = util.randomChar(4)
        st = "<#{tag} id='#{id}'></#{tag}>"
        obj.listenTo sc, ets, ->
            $("##{id}").html fun.apply(obj, arguments)
        st

    qrImg: (link, cls)->
        "<img src='/a/qrImg?link=#{link}' class='#{cls}'/>"

    iClass: (val, cls)->
        "#{cf.style.iconStr} #{cf.style.iconStr}-#{val} #{cls || ''}"

    iconx: (icon, str)->
        "<i class='icon-#{icon} iconx'>#{str || ''}</i>"

    iconxx: (icon)->
        @iconx(icon) + @iconx(icon + 'Hover hover')

    icon: (icon, tag = 'i', str = '', cls = '', href)->
#        if href
#            href = "href='#{href}'"
        "<#{tag} class='#{@iClass(icon, cls)}' #{href || ''}>#{str}</#{tag}>"
