async = require('async')

tmplUtil = require '../ext/tmpl'
jade = require('jade')

OAuth = require('wechat-oauth')

getApi = require '../service/wechat'

module.exports =
    jsSign:(req,rsp)->
        bo = req.body
        getApi req.c.code, bo.pubCode, (api)->
            api.getJsConfig
                jsApiList: bo.res.split(',')
                url: bo.url
            , (err, res) ->
                rsp.send res

#    apiCall:(name, opt)->
#        getApi

    createMenu: (req, rsp)->
        getApi req.body.code, req.body.pubCode, (api)->
            api.createMenu req.body.menu, (err, res) ->
                rsp.send res

    createLimitQRCode:(req,rsp)->
        code = req.body.code
        getApi code, req.body.pubCode, (api)->
            api.createLimitQRCode req.body.sceneId, (err, res) ->
                filter =
                    pubCode: req.body.pubCode
                    $query:{}
                    $orderby:
                        row: -1
                opt =
                    limit:1
                dao.find code, 'ticketTable', filter,opt,(rTicket)->
                    row = 1
                    if rTicket.length > 0
                        row = rTicket[0].row + 1
                    opt =
                        pubCode: req.body.pubCode
                        ticket: res.ticket
                        uid: new oid(req.body.uid)
                        row: row
                    dao.save code, 'ticketTable', opt, ->
                        rsp.send url: api.showQRCodeURL(res.ticket)

    showQRCodeURL:(req,rsp)->
        filter =
            uid: new oid(req.body.uid)
            pubCode: req.body.pubCode
        code = req.body.code
        dao.get code, 'ticketTable', filter, (res)->
            if res
                getApi code, req.body.pubCode, (api)->
                    rsp.send url: api.showQRCodeURL(res.ticket)
            else
                rsp.send msg: '二维码未生产'

    uploadNews:(req,rsp)->
        log 'upload news'
        wCode = req.body.account
        code = req.c.code
        opt = req.body.sendOpt
        isPre = req.body.isPre
        dao.get code, 'codeMap', type: 'wtStyle', (resStyle)->
            styles = resStyle.value if resStyle
            getApi code, wCode,(api)->
                async.each opt, (n,cb)->
                    log util.sPath(code+'/'+n.thumb_media_id)
                    unless n.thumb_media_id.startsWith 'http'
                        n.thumb_media_id = util.sPath(code+'/'+n.thumb_media_id)
                    log 'start to upload pic'
                    api.uploadMaterial n.thumb_media_id, 'image', (err,res)->
                        n.thumb_media_id = res.media_id
                        entity = util.del 'entity', n
                        _id = util.del '_id', n # entity's _id
                        tmpl = util.del 'tmpl', n # tmpl to render
                        if entity and _id
                            dao.get code, entity, _id: _id, (et)->
                                ctx =
                                    code: code
                                    f: tmplUtil
                                    c: req.c
                                ctx[entity] = et
                                path = "#{_path}/public/module/#{code}/tmpl/wechat/#{tmpl}.jade"
                                log path
                                content = jade.renderFile path,ctx
                                if styles
                                    for k,v of styles
                                        content.replaceAll("<#{k}>","<#{k} style='#{v}'>")
                                if entity is 'post'
                                    content.replaceAll "<div id=", "<img id="
                                    content.replaceAll 'Loading...</div>', ''
                                n.content = content
                                n.digest = et.brief
                                n.author = _.pluck(et.author, 'username').join(',')
                                cb()
                        else
                            n.content || n.content = 'no content'
                            n.digest || n.brief = 'no digest'
                            cb()
                ,->
                    api.uploadNews articles:opt,(err, res) ->
                        if isPre
                            for it in req.body.testUser
                                if it.wt and it.wt.oid
                                    api.previewNews it.wt.oid, res.media_id,(err, res) ->
                                        log err
                                        log res
                                        rsp.send
                                            success: true
                                            msg: '测试通过'
#                        else
#                            api.massSendNews res.media_id,
#                                is_to_all: true
#                            ,->
#                                rsp.send
#                                    success: true
#                                    msg: '发送成功'
    massSend:(req,rsp)->
        getApi req.body.code, (api)->
            api.massSend req.body.qrNum,(err, res) ->
                api.showQRCodeURL res.ticket, (res)->
                    log 'qrcode'
                    rsp.send res

    userInfoByCode:(req,rsp)->
        log 'userInfoByCode'
        qy = req.query
        [wCode,page,func] = qy.state.split('::')
        code = req.c.code
        if ctCtn[wCode]
            ctCtn[wCode].getAccessToken qy.code, (err,result)->
                accessToken = result.data.access_token
                openid = result.data.openid
                ru = "#{req.c.url}/#{page}?woid=#{openid}&aToken=#{accessToken}"
                ru = 'http://'+ru if ru.indexOf('http') is -1
                ru += "#!/#{func.replace('azbzc','/')}" if func
                if result.data.scope is 'snsapi_userinfo'
                    ctCtn[wCode].getUser openid, (err,res)->
                        return unless res
                        dao.get code, 'user', woid: openid, (user)->
                            if user
                                user.wunid = res.unionid
                            else
                                _id = new oid()
                                user =
                                    _id: _id
                                    username: res.nickname
                                    gender: if res.sex is 1 then true else false
                                    country: res.country
                                    woid: res.openid
                                    wunid: res.unionid
                                    info:
                                        address: "#{res.province} #{res.city}"
                            if res.headimgurl and (!user.refFile or !user.refFile.portrait)
                                fn = user._id.toString() + '.jpg'
#                                log res.headimgurl
#                                log "#{util.sPath(code)}/#{fn}"
                                gs('fetchFile') res.headimgurl, "#{util.sPath(code)}/#{fn}",->
                                user.refFile =
                                    portrait:[fn]
                            dao.save code, 'user', user

                            rsp.redirect ru
                else
                    rsp.redirect ru
        else
            dao.get code, 'pubAccount', code: wCode, (res)->
                ctCtn[wCode] = new OAuth(res.appId,res.secret)
                log "http://#{req.c.url}/#{page}"
                rsp.redirect "http://#{req.c.url}/#{page}"
        return

#    previewNews:(req,rsp)->
#        getApi req.body.code, (api)->
#            api.previewNews req.body.opended, mid, ->
#
#                api.showQRCodeURL res.ticket, (res)->
#                    log 'qrcode'
#                    log res
#                    rsp.send res

#    sendSth(req,rsp)->
#        api.send