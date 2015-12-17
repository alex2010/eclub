module.exports =
    slice: Array::slice

    ro: (ob)->
        str = ''
        if _.isArray ob
            ob.join(',')
        else if _.isObject ob
            for k,v of ob
                if @hasOwnProperty(k)
                    str += "#{k}:#{v} \n"
            str
        else
            ob

    isChinese: (text)->
        txt = text.replaceAll('’', "").replaceAll('–', '')
        if escape(txt).indexOf('%u') < 0
            false
        else
            true
    del: (x, ctx = window)->
        it = ctx[x]
        #        return unless it is undefined
        try
            delete ctx[x]
        catch e
            ctx[x] = undefined
        it

    pureText: (text) ->
        text.replace(/<[^>].*?>/g, "")

    cutText: (text, length = 30) ->
        if text.length < length
            return text
        else
            text.substr(0, length - 3) + '...'

    adjustText: (text, length = 30) ->
        return '' unless text
        text = text.replace(/<[^>].*?>/g, "")
        i = 0
        j = 0
        res = ''
        len = text.length
        while length > i and len > j
            c = text.substr(j++, 1)
            if /^[\u4e00-\u9fa5]+$/.test(c) then i += 2 else i++
            res += c
        if len > j
            res += '...'
        res

    fileExt: (name) ->
        it = name.split(".")
        it[it.length - 1]

    parseLocalDate: (time) ->
        time = time.substring(0, 19) if time.length > 19
        new Date((time or "").replace(/-/g, "/").replace(/[TZ]/g, " "))

    prettyDate: (time, type = 'yyyy-MM-dd HH:mm', d) ->
        return unless time
        time = time.substring(0, 19)  if time.length > 19
        date = new Date((time or "").replace(/-/g, "/").replace(/[TZ]/g, " "))
        diff = (((new Date()).getTime() - date.getTime()) / 1000)
        day_diff = (if diff > 0 then Math.floor(diff / 86400) else Math.ceil(diff / 86400))
        if !d or isNaN(day_diff) or day_diff < -31 or day_diff >= 31
            return date.pattern(type)
        #            if type is "n"
        #                return date.getMonth() + 1 + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes()
        #            else if type is "s"
        #                return date.getMonth() + 1 + "-" + date.getDate()
        #            else if type is "ys"
        #                return date.pattern('yyyy年MM月dd日')   #date.getFullYear() + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日"
        #            else if type is "ysh"
        #                return date.pattern('yyyy-MM-dd HH:mm')
        #            else
        #                return time.toLocaleString()
        if day_diff <= 0
            day_diff *= -1
            diff *= -1
            day_diff is 0 and (diff < 60 and ii("t.j_n") or diff < 120 and ii("t.o_m_l") or diff < 3600 and Math.floor(diff / 60) + ii("t.m_l") or diff < 7200 and ii("t.o_h_l") or diff < 86400 and Math.floor(diff / 3600) + ii("t.h_l")) or day_diff is 1 and ii("t.t") or day_diff < 7 and day_diff + ii("t.d_l") or day_diff < 31 and Math.ceil(day_diff / 7) + ii("t.w_l")
        else
            day_diff is 0 and (diff < 60 and ii("t.j_n") or diff < 120 and ii("t.o_m_a") or diff < 3600 and Math.floor(diff / 60) + ii("t.m_a") or diff < 7200 and ii("t.o_h_a") or diff < 86400 and Math.floor(diff / 3600) + ii("t.h_a")) or day_diff is 1 and ii("t.y") or day_diff < 7 and day_diff + ii("t.d_a") or day_diff < 31 and Math.ceil(day_diff / 7) + ii("t.w_a")

    parseUrl: (url = location.search)->
        res = {}
        unless url.indexOf("?") is -1
            str = url.substr(1).split("&")
            for it in str
                p = it.split("=")
                res[p[0]] = decodeURIComponent(p[1])
        res

    seqProp: (obj, pStr, dV) ->
        v = obj
        for chain in pStr.trim().split(".")
            v = v[chain]
            break unless v?
        if v?
            v
        else
            dV

    setSeqProp: (obj, pStr, v) ->
        for chain in pStr.trim().split(".")
            if chain.indexOf('[') > -1
                k = chain
                chain = k.split('[')[0]
                index = parseInt k.split('[')[1].split(']')[0]
                if _i is (_len - 1)
                    d = if chain then obj[chain] else obj
                    if v
                        d[index] = v
                    else
                        return d[index]
                else
                    obj = if chain then obj[chain][index] else obj[index]
            else if _.isObject(obj[chain])
                obj = obj[chain]
            else
                if v
                    obj[chain] = v
                else
                    return obj[chain]

    delSeqProp: (obj, pStr) ->
        it = pStr.trim().split(".")
        lk = it.pop()
        if it.length > 0
            for chain in it
                obj = obj[chain]
        if lk.indexOf('[') > 0
            chain = lk.split('[')[0]
            index = parseInt lk.split('[')[1].split(']')[0]
            obj[chain].splice(index, 1)
        else
            delete obj[lk]
    randomInt: (low, high)->
        Math.floor(Math.random() * (high - low + 1) + low)

    randomChar: (len, x = '0123456789qwertyuioplkjhgfdsazxcvbnm') ->
        ret = x.charAt(Math.ceil(Math.random() * 10000000) % x.length)
        for n in [1..len]
            ret += x.charAt(Math.ceil(Math.random() * 10000000) % x.length)
        ret

    delProp: (x, ctx = window)->
        it = ctx[x]
        return unless it
        try
            delete ctx[x]
        catch e
            ctx[x] = undefined
        it

    getUrlParams: (url, params) ->
        url + '?' + ("#{k}=#{v}" for k,v of params).join('&')

    setSubItem: (data, prop = 'id') ->
        for it in data
            if it.pid
                p = data.findBy(prop, it.pid)
                if p
                    p.children = [] if not p.children
                    p.children.push(it)
                    data.splice _i--, 1
                    _len--

    findByType: (items, type)->
        it for it in items when it instanceof type

    resPath: (c, path) ->
        c.resPath + '/upload/' + c.code + '/' + path

    rPath: ->
        str = [cf.rPath]
        str.push it for it in arguments when _.isString it
        str.join('/')

    rootsPath: ()->
        s = ''
        for it in arguments
            s += '/' + it
        cf.resPrefix + s.substring(1)


    serializeObj: (form)->
        o = {}
        for it in $(form).serializeArray()
            if o[it.name]
                unless o[it.name].push
                    o[it.name] = [o[it.name]]
                o[it.name].push it.value
            else o[it.name] = it.value if it.value.length > 0
        o

    tStr: (o)->
        if _.isObject o
            JSON.stringify o
        else
            o

    pStr: (it, p)->
        if it and it[p] is null
            it[p] = {}
        else if it and _.isString(it[p]) and it[p].length > 1
            try
                it[p] = JSON.parse(it[p])
            catch e
                log e
        it[p]

    now: ->
        new Date().getTime()
