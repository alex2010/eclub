sender = require '../service/sms'

sendCode = (req, rsp, scope = 10000, len = 3)->
    code = req.c.code
    cCode = util.randomChar(16)
    vCode = _.random(scope, scope * 10)

    s = 1000 * 60 * len
    _cache.set cCode, vCode, s

    dao.get code, 'codeMap', code: req.query.sTmpl, (res)->
        if res
            msg = res.value.replace '###', vCode
            msg = msg.replace '&&&', req.c.name
            sender code, req.query.phone, msg

    rsp.cookie '_vCode', cCode,
        expires: new Date(Date.now() + s)
        path: req.query.p

    rsp.send
        _vcode: cCode
        msg: '验证码返回成功'
        sec: s

module.exports =

    findPsd: (req, rsp)->
        n = req.body._period || 3
        if _cache.get(req.cookies._vCode)
            rsp.send
                _exsit: true
                msg: "验证码已经发送，请过#{n}分钟后再申请"
        else
            dao.get req.c.code, 'user', phone: req.query.phone, (res)->
                if res
                    sendCode(req, rsp)
                else
                    rsp.status 300
                    rsp.send
                        msg: '手机号码输入有误,请检查!'

    getCode: (req, rsp)->
        n = req.body._period || 3
        if _cache.get(req.cookies._vCode)
            rsp.send
                _exsit: true
                msg: "验证码已经发送，请过#{n}分钟后再申请"
        else
            dao.get req.c.code, 'user', phone: req.query.phone, (res)->
                if res
                    rsp.status 300
                    rsp.send
                        msg: '本手机已注册,请更换手机号'
                else
                    sendCode(req, rsp)
