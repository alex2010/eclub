crypto = require('crypto')

checkEt = (it)->
    it.password && delete it.password
    for k, v of it
        if v instanceof Date
            v.setHours(v.getHours() + 8)
        else if _.isObject(v)
            checkEt(v)
        else
            if v is 'false'
                it[k] = false
            else if v is 'true'
                it[k] = true

module.exports =
    sPath: (code)->
        path = "/public/res/upload/#{code}"
        if app.env
            '.' + path
        else
            _path + path

    sha256: (str)->
        crypto.createHash('sha256').update(str).digest('base64')

    d: (it, p)->
        rs = it[p]
        delete it[p]
        rs

    r: (it, extra, e)->
        if _.isArray it
            checkEt t for t in it
            entities: it
            count: extra || it.length
        else if it
            checkEt it
            entity: it
            msg: extra
            _e: e
        else
            _e: e
            msg: 'm_find_no'

