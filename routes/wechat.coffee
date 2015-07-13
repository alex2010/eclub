wechat = require 'wechat'

`
    _wtHandler = {};
`

func =
    doMatch: (k, rsp)->
        filter = if k.indexOf '@' > -1
            email: k
        else if +k
            phone: k
        else
            username: true

        dao.get code, 'user', filter, (res)->
            log res
            if res
                rsp.reply '绑定成功'
            else
                rsp.reply '用户为找到'


handleOp = (item, req, rsp)->
    log req.baseUrl
    log req.hostname
    switch item.type
        when 'text'
            rsp.reply item.content
        when 'page'
#            unless item.imgUrl
#                item.imgUrl = req.c.resPath + 'images/wechat_reply.png'
            log item.imgUrl
            rsp.reply [
                title: item.title
                description: item.help
                picurl: item.imgUrl
                url: item.content
            ]
        when 'func'
            [key,params] = item.Content.split(' ')
            if func[key]
                func[key](params, rsp)
        when 'script'
            log item.content
        else
            rsp.reply 'no match'


agentOp = (code, req, rsp)->
    log req.params.code
    cd = req.params.code
    dao.get cd, 'agentOp', code: code, (res)->
        if res
            handleOp res, req, rsp
        else
            dao.get cd, 'agentOp', code: 'subscribe',(res)->
                if res
                    handleOp res, req, rsp
                else
                    rsp.reply 'no found'

event = (msg, req, rsp) ->
    evtKey = msg.EventKey
    log evtKey
    if msg.Event is 'subscribe'
        if evtKey
            dao.save req.params.code, 'subscriber:uid,woid',
                uid: evtKey.split('_')[1]
                woid: msg.FromUserName
                status: 1
        agentOp msg.Event, req, rsp

    else if msg.Event is 'unsubscribe'
        filter =
            woid: msg.FromUserName
        dao.findAndUpdate req.params.code, 'subscriber', filter, status: 0, (res)->

    else if msg.Event is 'CLICK'
        agentOp evtKey, req, rsp


text = (msg, req, rsp) ->
    agentOp msg.Content, req, rsp

handler = (code, ctn)->
    dao.get code, 'pubAccount', {}, (item)->
        opt =
            token: "#{code}z2013h"
            appid: item.appId
            encodingAESKey: item.aes
        ctn[code] = wechat(opt).text(text).event(event)

#---------------------------------------------------------------------#

app.get '/wechat/:code', (req, rsp)->
    log 'wechat check'
    rsp.send req.query.echostr

app.post '/wechat/:code', (req, rsp)->
    code = req.params.code
    if _wtHandler[code]
        _wtHandler[code].middlewarify()(req, rsp)
    else
        handler code, _wtHandler
        rsp.send 'System init, please send again.'





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
