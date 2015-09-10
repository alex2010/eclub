async = require('async')

tmplUtil = require '../ext/tmpl'
jade = require('jade')

OAuth = require('wechat-oauth')

getApi = require '../service/wechat'

WXPay = require('weixin-pay')
module.exports =
    jsSign: (req, rsp)->
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

    createLimitQRCode: (req, rsp)->
        code = req.body.code
        getApi code, req.body.pubCode, (api)->
            api.createLimitQRCode req.body.sceneId, (err, res) ->
                filter =
                    pubCode: req.body.pubCode
                    $query: {}
                    $orderby:
                        row: -1
                opt =
                    limit: 1
                dao.find code, 'ticketTable', filter, opt, (rTicket)->
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

    showQRCodeURL: (req, rsp)->
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

    uploadNews: (req, rsp)->
        log 'upload news'
        wCode = req.body.account
        code = req.c.code
        opt = req.body.sendOpt
        isPre = req.body.isPre
        dao.get code, 'codeMap', type: 'wtStyle', (resStyle)->
            styles = resStyle.value if resStyle
            getApi code, wCode, (api)->
                async.each opt, (n, cb)->
                    log util.sPath(code + '/' + n.thumb_media_id)
                    unless n.thumb_media_id.startsWith 'http'
                        n.thumb_media_id = util.sPath(code + '/' + n.thumb_media_id)
                    log 'start to upload pic' + n.thumb_media_id
                    api.uploadMaterial n.thumb_media_id, 'image', (err, res)->
                        return unless res
                        n.thumb_media_id = res.media_id
                        log n.thumb_media_id
                        entity = util.del 'entity', n
                        _id = util.del '_id', n # entity's _id
                        tmpl = util.del 'tmpl', n # tmpl to render
                        if entity and _id
                            dao.get code, entity, _id: _id, (et)->
                                dao.get code, 'cat', {code:et.code},(ct)->
                                    dao.find code, "i18n", {lang:req.body.lang || 'zh'}, {},(res)->
                                        langs = {}
                                        for it in res
                                            langs[it.key] = it.val
                                        ctx =
                                            code: code
                                            f: tmplUtil
                                            c: req.c
                                            i18: require('../service/lang')(langs)
                                            catObj:ct
                                        _.extend ctx, et
                                        path = "#{_path}/public/module/#{code}/tmpl/wechat/#{tmpl}.jade"
                                        ccc = jade.renderFile path, ctx
#                                        ccc = content.toString()
                                        if styles
                                            for k,v of styles
                                                ccc = ccc.replaceAll("<#{k}>", "<#{k} style='#{v}'>")
                                        ccc = ccc.replaceAll "bb-src", 'src'
                                        log ccc
                                        n.content = ccc
                                        n.digest = et.brief
                                        n.author = _.pluck(et.author, 'username').join(',')
                                        cb()
                        else
                            n.content || n.content = 'no content'
                            n.digest || n.brief = 'no digest'
                            cb()
                , ->
                    log 'upload news ...'
                    api.uploadNews articles: opt, (err, res) ->
                        if isPre
                            k = "w_#{wCode}"
                            for it in req.body.testUser
                                if it[k]
                                    api.previewNews it[k], res.media_id, (err, res) ->
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
    massSend: (req, rsp)->
        getApi req.body.code, (api)->
            api.massSend req.body.qrNum, (err, res) ->
                api.showQRCodeURL res.ticket, (res)->
                    log 'qrcode'
                    rsp.send res

    userInfoByCode: (req, rsp)->
        log 'userInfoByCode'
        qy = req.query
        [wCode,page,func] = qy.state.split('::')
        code = req.c.code
        if ctCtn[wCode]
            ctCtn[wCode].getAccessToken qy.code, (err, result)->
                accessToken = result.data.access_token
                openid = result.data.openid
                ru = "#{req.c.url}/#{page}?woid=#{openid}&aToken=#{accessToken}"
                ru = 'http://' + ru if ru.indexOf('http') is -1
                ru += "#!/#{func.replace('azbzc', '/')}" if func
                if result.data.scope is 'snsapi_userinfo'
                    ctCtn[wCode].getUser openid, (err, res)->
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
                                user["w_#{wCode}"] = res.openid
                            if res.headimgurl and (!user.refFile or !user.refFile.portrait)
                                fn = user._id.toString() + '.jpg'
                                #                                log res.headimgurl
                                #                                log "#{util.sPath(code)}/#{fn}"
                                gs('fetchFile') res.headimgurl, "#{util.sPath(code)}/#{fn}", ->
                                user.refFile =
                                    portrait: [fn]
                            dao.save code, 'user', user

                            rsp.redirect ru
                else
                    rsp.redirect ru
        else
            dao.get code, 'pubAccount', code: wCode, (res)->
                ctCtn[wCode] = new OAuth(res.appId, res.secret)
                log "http://#{req.c.url}/#{page}"
                rsp.redirect "http://#{req.c.url}/#{page}"
        return


    wxPay: (req, rsp)->
        rp = req.body
        da = new Date()
        dao.get code, 'pubAccount', code: rp.wCode, (pa)->
            wxpay = WXPay
                appid: pa.appId
                mch_id: pa.mid
                partner_key: pa.tradeSecret

            opt =
                openid: rp.woid
                body: rp.body
                detail: '公众号支付测试',
                out_trade_no: rp.tid || da.getFullYear()+da.getMonth()+da.getDay()+Math.random().toString().substr(2, 10)
                total_fee: 1
                spbill_create_ip: req.ip
                notify_url: pa.notify

            wxpay.getBrandWCPayRequestParams opt, (err,res)->
                log res
                rsp.send res







#            m = [
#                appid: pa.appId,
#                mch_id: pa.mid,
#                nonce_str: rp.nstr,
#                body: rp.body,
#                out_trade_no: rp.tid,
#                total_fee: (totalFee(params.iid) * 100).toInteger(),
#                spbill_create_ip: request.getRemoteAddr(),
#                notify_url: "#{c.url}/wechat/notify/#{c.code}",
#                openid: rp.oid,
#                trade_type: 'JSAPI'
#            ]
#            sortKey = (m)->
#                for k,v of m
#
#            wxPay = new WxPay(appInfo)
#
#        wxPay.pushTrade().then (data)->
#            rsp.send 200


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