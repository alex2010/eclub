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
    icon: (icon, tag = 'i', str = '', cls = '', href)->
        if href
            href = "href='#{href}'"
        "<#{tag} class='glyphicon glyphicon-#{icon} #{cls}' #{href||''}>#{str}</#{tag}>"

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

    img: (path, cls = 'avatar', pop = false,p)->
        p ?=''
        p += if pop then " onclick='cf.showPic(this)'" else ''

        "<img id='#{String.randomChar(4)}' class='#{cls} _imgBox' bb-src='#{path}' #{p}/>"

    imgItem: (it, c, name = 'head', cls, index = 0, pop)->
        return '' unless it
        if it.refFile and it.refFile[name]
            path = it.refFile[name][index]
            if path and path.length
                return @img @resPath(c, path), cls, pop
        ''

    resPath: (c, path)->
        c.resPath + '/upload/' + c.code + '/' + path

    avatarImg: (c, user, cls='img-circle')->
        p = @resPath c, "portrait/#{user._id}.jpg"
        @img p, cls

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

    catLink: (cat, list=[])->
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

    tmpl: (name, opt, lib)->
        cf.rtp name, opt, lib

    actDate:(start,end)->
        "#{start.substr(0,16)}-#{end.substr(11,5)}"