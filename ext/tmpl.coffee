module.exports =
    randomInt: util.randomInt

    viewItem: (entity, k, v)->
        opt = cf.meta[entity][k] || cf.meta.common[k]
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
#        else if
        else
            v


    dStr: (str, len = 19)->
        if str
            str.replace(/-/g, "/").replace(/[TZ]/g, " ").substr(0, len)
        else
            ''
    icon: (icon, tag = 'i', str = '', cls = '')->
        "<#{tag} class='glyphicon glyphicon-#{icon} #{cls}'>#{str}</#{tag}>"

    copyRight: (c, name, id)->
        path = "http://#{c.url}/#{name}/#{id}"
        """
        <div class="copyright"><strong>C</strong><div>
            <p>除非特别声明，本站文章均为#{c.title}原创文章，转载请注明原文链接</p>
            <p>原文地址：<a href="#{path}">#{path}</a></p>
        </div></div>
        """
    navPage: (page, it)->
        "/#{page}/#{it._id}"

    crumbItem: (items)->
        [
            label: '首页'
            href: '/'
        ].concat items

#    img: (path, c, cls = 'markImg', pop = false)->
#        id = String.randomChar(4)
#        """<div id="#{id}" class="#{cls}" src="#{path}" pop="#{pop}"
#        style="background:url(#{c.resPath}/img/loading-bk.gif) no-repeat 50% 50%;height:100%;text-indent: -1000px;">loading...</div>"""

    img: (path, c, cls = 'avatar', pop = false, width = 'auto')->
        "<img id='#{String.randomChar(4)}' class='#{cls}' bb-src='#{path}' pop='#{pop}' width='#{width}'/>"


    imgItem: (it, c, name = 'head', index = 0, cls)->
        return '' unless it
        if it.refFile and it.refFile[name]
            path = it.refFile[name][index]
        else
            path = ''
        @img @resPath(c, path), c, cls

    resPath: (c, path)->
        c.resPath + '/upload/' + c.code + '/' + path

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

        "<a href='#{href}' title='#{text}' class='#{cls || ''}'>#{text}</a>"

    catLink: (cat, list)->
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


#    navUrl: util.navUrl
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

    tmpl: (name, opt)->
        cf.rtp name, opt
