module.exports =
    del: (x, ctx = window)->
        it = ctx[x]
        try
            delete ctx[x]
        catch e
            ctx[x] = undefined
        it
    sPath: (code)->
        path = "/public/res/upload/#{code}"
        if app.env
            '.' + path
        else
            _path + path

    d: (it, p)->
        rs = it[p]
        delete it[p]
        rs

    r: (it, extra, e)->
        if _.isArray it
            entities: it
            count: extra || it.length
        else if it
            entity: it
            msg: extra
            _e: e
        else
            entity: {}
            msg: 'm_find_no'

    randomInt: (low, high)->
        Math.floor(Math.random() * (high - low + 1) + low)

    randomChar: (len, x = '0123456789qwertyuioplkjhgfdsazxcvbnm') ->
        ret = x.charAt(Math.ceil(Math.random() * 10000000) % x.length)
        for n in [1..len]
            ret += x.charAt(Math.ceil(Math.random() * 10000000) % x.length)
        ret