module.exports = (req, user)->
    if _cache.get(req.body._vcode) is +req.body.vcode
        delete req.body._vcode
        delete req.body.vcode
        return true

    msg: 'vcode is wrong'
    error: true