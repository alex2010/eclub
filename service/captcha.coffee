module.exports = (req, user)->
    if _cache.get(req.body._cap) is req.body.captcha
        delete req.body._cap
        delete req.body.captcha
        return true

    fmMsg: '验证码错误!'
    error: true