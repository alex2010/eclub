sender = require '../service/sms'
module.exports =
    checkPhone: (req, rsp)->

    getCode: (req, rsp)->
        code = req.c.code
        vcode = req.cookies._vCode

        if _cache.get('vcode')
            rsp.send msg: '验证码已经发送，请过3分钟后再申请'
        else
            dao.get code, 'user', phone: req.query.phone, (res)->
                if res
                    rsp.status 300
                    rsp.send
                        msg: '本手机已注册,请更换手机号'
                else
                    cCode = util.randomChar(16)
                    vCode = _.random(100000, 1000000)

                    s = 1000 * 60 * 3
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