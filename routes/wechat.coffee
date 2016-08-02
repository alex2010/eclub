wechat = require 'wechat'
`
    _wtHandler = {};
`

_wtFunc.doMatch =  (k, rsp)->
        filter = if k.indexOf '@' > -1
            email: k
        else if +k
            phone: k
        else
            username: true

        dao.get code, 'user', filter, (res)->
            if res
                rsp.reply '绑定成功'
            else
                rsp.reply '用户为找到'


handleOp = (item, req, rsp, msg = {})->
    code = req.params.code
    switch item.type
        when 'text'
            rsp.reply item.content
        when 'page'
#            unless item.imgUrl
#                item.imgUrl = req.c.resPath + 'images/wechat_reply.png'
            sp = if item.content.indexOf('?') > -1
                '&'
            else
                '?'
            rsp.reply [
                title: item.title
                description: item.help
                picurl: item.imgUrl
                url: item.content+"#{sp}wuCode=#{msg.FromUserName}"
            ]
        when 'func'
            [key,params] = item.content.split(' ')
            if _wtFunc[code] and _wtFunc[code][key]
                _wtFunc[code][key](params, rsp, msg)
        when 'script'
            log item.content
        else
            rsp.reply 'no match'


agentOp = (code, req, rsp, msg)->
    cd = req.params.code
    dao.get cd, 'agentOp', code: code, (res)->
        if res
            handleOp res, req, rsp, msg
        else
            dao.get cd, 'agentOp', code: 'subscribe',(res)->
                if res
                    handleOp res, req, rsp, msg
                else
                    rsp.reply 'no found'

event = (msg, req, rsp) ->
    evtKey = msg.EventKey
    if msg.Event is 'subscribe'
        if evtKey
            dao.save req.params.code, 'subscriber:uid,woid',
                uid: evtKey.split('_')[1]
                woid: msg.FromUserName
                status: 1
        agentOp msg.Event, req, rsp, msg

    else if msg.Event is 'unsubscribe'
        filter =
            woid: msg.FromUserName
        dao.findAndUpdate req.params.code, 'subscriber', filter, status: 0, (res)->

    else if msg.Event is 'CLICK'
        agentOp evtKey, req, rsp, msg


text = (msg, req, rsp) ->
    agentOp msg.Content, req, rsp, msg

handler = (code, ctn)->
    dao.get code, 'pubAccount', {}, (item)->
        opt =
            token: "#{code}z2013h"
            appid: item.appId
            encodingAESKey: item.aes

        ctn[code] = wechat(opt).text(text).event(event)

#---------------------------------------------------------------------#

app.get '/wechat/:code', (req, rsp)->
    rsp.send req.query.echostr

app.post '/wechat/:code', (req, rsp)->
    code = req.params.code
    if _wtHandler[code]
        _wtHandler[code].middlewarify()(req, rsp)
    else
        handler code, _wtHandler

#        rsp.send 'System init, please send again.'
#wtreg[code] = require("../views/module/#{code}/script/wt")(code)
#opt = wechat cfg
#    .text (msg, req, res, next) ->
#        rsp.reply('Hello world!')
#    .image (msg, req, res, next) ->
#        return
#    .voice (msg, req, res, next) ->
#        return
#    .video (msg, req, res, next) ->
#        return
#    .location (msg, req, res, next) ->
#        return
#    .link (msg, req, res, next) ->
#        return
#    .event (msg, req, res, next) ->
#        return
#
#    .middlewarify()


#
#
#app.use '/wechat/:code', wechat(cfg).text((message, req, res, next) ->
#    res.reply('Hello world!')
#    return
#).image((message, req, res, next) ->
## TODO
#    return
#).voice((message, req, res, next) ->
## TODO
#    return
#).video((message, req, res, next) ->
## TODO
#    return
#).location((message, req, res, next) ->
## TODO
#    return
#).link((message, req, res, next) ->
## TODO
#    return
#).event((message, req, res, next) ->
## TODO
#    return
#).middlewarify()
