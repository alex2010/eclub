module.exports = (req, user)->
    log 'vocld...'
    if _cache.get(req.body._vcode) is +req.body.vcode
        delete req.body._vcode
        delete req.body.vcode
        log 'vcode is right'
        return true

    msg: 'vcode is wrong'
    error: true