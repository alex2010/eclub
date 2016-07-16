module.exports = (req, bo)->
    if _cache.get(bo._cap).substr(0,4) is bo._captcha
        return null

    msg: '验证码错误!'
    error: true