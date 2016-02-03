crypto = require('crypto')

module.exports =
    sPath: (code)->
        path = "/public/res/upload/#{code}"
        if app.env
            '.' + path
        else
            _path + path


    sha256:(str)->
        crypto.createHash('sha256').update(str).digest('base64')


    d: (it, p)->
        rs = it[p]
        delete it[p]
        rs

    r: (it, extra, e)->
        if _.isArray it
            if e is 'user'
                for u in it
                    delete u.password
            entities: it
            count: extra || it.length
        else if it
            if e is 'user'
                delete it.password
            entity: it
            msg: extra
            _e: e
        else
            _e:e
            msg: 'm_find_no'

