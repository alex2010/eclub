module.exports =
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
            _e:e
            msg: 'm_find_no'

