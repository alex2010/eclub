
wtApi = require('wechat-api')

module.exports = (code, pubCode, func)->
    if wtCtn[pubCode]
        func(wtCtn[pubCode])
    else
        dao.get code, 'pubAccount', code: pubCode, (res)->
            if res
                api = new wtApi(res.appId, res.secret)
                wtCtn[pubCode] = api
                func(api)