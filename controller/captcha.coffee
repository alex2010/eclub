ccap = require('ccap')()

module.exports =
    cap: (req, rsp)->
        [code,buf] = ccap.get()
        cCode = util.randomChar(16)
        s = 1000 * 60 * 3
        _cache.set cCode, code, s
        rsp.cookie '_cap', cCode,
            expires: new Date(Date.now() + s)
            path: req.query.p
        rsp.end(buf)