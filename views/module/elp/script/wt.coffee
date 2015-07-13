wechat = require 'wechat'
func =
    doMatch: (k, rsp)->
        filter = if k.indexOf '@' > -1
            email: k
        else if +k
            phone: k
        else
            um: true
        unless filter.um
            dao.get code, 'user', filter, (res)->
                log res
                if res
                    rsp.reply '绑定成功'
                else
                    rsp.reply '用户为找到'
        else
            rsp.reply '录入有误'

agentOp = (code, rsp)->
    dao.get 'elp', 'agentOp', code: code, (res)->
        handleOp res, rsp if res

handleOp = (item, rsp)->
    switch item.type
        when 'text'
            str = item.content
            rsp.reply str
        when 'page'
            str = item.content
            unless item.imgUrl
                item.imgUrl = _resPath + 'images/wechat_reply.png'
            log item.imgUrl
            rsp.reply [
                title: item.title
                description: item.brief
                picurl: item.imgUrl
                url: str
            ]
        when 'func'
            [key,str] = item.Content.split(' ')
            if func and func[key]
                func[key](str,rsp)
        when 'script'
            log item.content
        else
            log 'no match'


text = (msg, req, rsp) ->

    rsp.reply('Hello world!')

event = (msg, req, rsp) ->
    log msg
    evtKey = msg.EventKey
    log evtKey

    if msg.Event is 'subscribe'
        if evtKey
            dao.save 'elp', 'subscriber:uid,woid',
                uid: evtKey.split('_')[1]
                woid: msg.FromUserName
                status: 1
        agentOp msg.Event, rsp

    else if msg.Event is 'unsubscribe'
        filter =
            woid: msg.FromUserName
        dao.findAndUpdate 'elp', 'subscriber', filter, status: 0, (res)->

    else if msg.Event is 'CLICK'
        agentOp evtKey, rsp



module.exports = (code)->
    if _wtcCtn[code]
       return wechat(_wtcCtn[code]).text(text).event(event)
    else
        dao.get code, 'pubAccount', {}, (item)->
            _wtcCtn[code] =
                token: "#{code}z2013h"
                appid: item.appId
                encodingAESKey: item.aes
        null
#app.post '/wechat/elp', opt.middlewarify()
