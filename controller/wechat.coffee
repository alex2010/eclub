async = require('async')

tmplUtil = require '../ext/tmpl'
jade = require('jade')

OAuth = require('wechat-oauth')

getApi = require '../service/wechat'

WXPay = require('weixin-pay')

`
_spWtStr = 'azbzc'
`
matchPic = (str)->
    imgs = {}
    for it in str.match /http:\/\/s.postenglishtime.com\/upload\/\S+.(jpg|jpeg|png|JPG|PNG|JPEG)/g
        imgs[it] = null
    imgs

module.exports =
    jsSign: (req, rsp)->
        bo = req.body
        getApi req.c.code, bo.pubCode, (api)->
            api.getJsConfig
                jsApiList: bo.res.split(',')
                url: bo.url
            , (err, res) ->
                log err if err
                rsp.send res

    createMenu: (req, rsp)->
        getApi req.body.code, req.body.pubCode, (api)->
            api.createMenu req.body.menu, (err, res) ->
                log err if err
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


    removeRes:(req,rsp)->
        code = req.c.code
        wCode = req.body.account
        getApi code, wCode, (api)->
            ret = ->
                rsp.send
                    success: true
                    msg: '删除成功'
            proc = (n, cb)->
                api.removeMaterial n, ->
                    cb()
            async.each req.body.res.split('::'), proc, ret

    sendMessNews:(req,rsp)->
        code = req.c.code
        wCode = req.body.account
        getApi code, wCode, (api)->
            api.massSendNews req.body.media_id,
                is_to_all: true
            ,->
                rsp.send
                    success: true
                    msg: '发送成功'

    uploadNews: (req, rsp)->
        wCode = req.body.account
        code = req.c.code
        opt = req.body.sendOpt
        resId = []
        titles = []

        dao.get code, 'codeMap', type: 'wtStyle', (resStyle)->
            styles = resStyle.value if resStyle
            getApi code, wCode, (api)->
                async.each opt, (n, cb)->
                    log 'upload path:' + util.sPath(code + '/' + n.thumb_media_id)
                    unless n.thumb_media_id.startsWith 'http'
                        n.thumb_media_id = util.sPath(code + '/' + n.thumb_media_id)
                    log 'start to upload pic' + n.thumb_media_id
                    api.uploadMaterial n.thumb_media_id, 'thumb', (err, res)->
                        return unless res
                        n.thumb_media_id = res.media_id
                        resId.push res.media_id
                        entity = util.del 'entity', n
                        _id = util.del '_id', n # entity's _id
                        tmpl = util.del 'tmpl', n # tmpl to render
                        if entity and _id
                            dao.get code, entity, _id: _id, (et)->
                                titles.push "【#{entity}】#{et.title || et.username}"
                                dao.get code, 'cat', {code:et.cat},(ct)->
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
                                            redirect: n.content_source_url
                                        _.extend ctx, et
                                        path = "#{_path}/public/module/#{code}/wechat/#{tmpl}.jade"
                                        ccc = jade.renderFile path, ctx

                                        if styles
                                            for k,v of styles
                                                ccc = ccc.replaceAll("<#{k}>", "<#{k} style='#{v}'>")
                                        ccc = ccc.replaceAll "bb-src", 'src'
                                        ccc = ccc.replace(/[\r\n]/g, "")
                                        n.content = ccc

                                        # pick img
                                        imgs = matchPic n.content
                                        async.each _.keys(imgs), (n, icb)->
                                            path = n.replace('http://s.postenglishtime.com/upload/pet', util.sPath(code))
                                            api.uploadLogo path, (err, ires)->
                                                if err
                                                    log err
                                                else
                                                    imgs[n] = ires.url
                                                icb()
                                        ,->
                                            for k, v of imgs
                                                n.content = n.content.replaceAll k, v
                                            cb()
                        else
                            n.content || n.content = 'no content'
                            n.digest || n.brief = 'no digest'
                            cb()
                , ->
                    log 'upload news ...'
                    api.uploadNewsMaterial articles: opt, (err, res) ->
                        if err
                            log err
                        else
                            bo =
                                title: titles
                                resId:resId
                                mediaId: res.media_id
                                account: wCode
                                type: 'news'
                                lastUpdated: new Date()

                            rsp.send
                                success: true
                                entity: bo
                                msg: '同步成功,请登录微信后台编辑或者推送'

#
#                            dao.save code, 'wtUploaded', bo, (item)->
#                                rsp.send
#                                    success: true
#                                    meidaId: res.media_id
#                                    msg: '测试通过'

    sendTest:(req, rsp)->
        code = req.c.code
        wCode = req.body.account
        getApi code, wCode, (api)->
            k = "w_#{wCode}"
            for it in req.body.testUser
                if it[k]
                    api.previewNews it[k],req.body.mediaId, (res)->
                        log res
                        rsp.send
                            success: true
                            msg: '测试已发送'


#    massSend: (req, rsp)->
#        getApi req.body.code, (api)->
#            api.massSend req.body.qrNum, (err, res) ->
#                api.showQRCodeURL res.ticket, (res)->
#                    log 'qrcode'
#                    rsp.send res

    login: (req, rsp)->
        code = req.c.code
        qy = req.query
        page = qy.page || 'wechat'
        func = qy.func
        if req.cookies.woid
            url = "http://#{req.c.url}/#{page}"
            if func
                url += "#!/#{func}"
            log 'with cookie'
            log urlxi
            rsp.redirect url
        else
            appId = qy.appId
            scope = qy.scope || 'snsapi_userinfo'
            wCode = qy.wCode
            unless qy.state
                qyy = [wCode,page]
                if func
                    qyy.push func
                qy.state = qyy.join('::')
            state = encodeURIComponent qy.state
            log "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{appId}&redirect_uri=#{encodeURIComponent("http://#{req.c.url}/a/wt/userInfoByCode")}&response_type=code&scope=#{scope}&state=#{state}#wechat_redirect"
            rsp.redirect "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{appId}&redirect_uri=#{encodeURIComponent("http://#{req.c.url}/a/wt/userInfoByCode")}&response_type=code&scope=#{scope}&state=#{state}#wechat_redirect"

    userInfoByCode: (req, rsp)->
        log 'userInfoByCode'
        qy = req.query
        [wCode,page,func] = decodeURI(qy.state).split('::')

        code = req.c.code
        self = @
        if ctCtn[wCode]
            ctCtn[wCode].getAccessToken qy.code, (err, result)->
                log arguments
                openid = result.data.openid
                rsp.cookie 'woid', openid, maxAge: 1000 * 3600 * 2
                ru = "#{req.c.url}/#{page}"
                ru = 'http://' + ru if ru.indexOf('http') is -1
                ru += "#!/#{func.replace(_spWtStr, '/')}" if func
                log 'fd'
                log ru
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
                                    status: 1
                                    wunid: res.unionid
                                    info:
                                        address: "#{res.province} #{res.city}"
                            user["w_#{wCode}"] = res.openid
                            if res.headimgurl and (!user.refFile or !user.refFile.portrait)
                                fn = user._id.toString() + '.jpg'
                                gs(null,'fetchFile') res.headimgurl, "#{util.sPath(code)}/portrait/#{fn}", ->
                            dao.save code, 'user:_id', user
                            rsp.redirect ru
                else
                    rsp.redirect ru
        else
            log wCode
            dao.get code, 'pubAccount', code: wCode, (res)->
                log 'nfd'
                log res
                if res
                    ctCtn[wCode] = new OAuth(res.appId, res.secret)
                    rsp.redirect "http://#{req.c.url}/a/wt/userInfoByCode?#{req.originalUrl.split('?')[1]}"
                else
                    rsp.redirect "http://#{req.c.url}"

    wxPay: (req, rsp)->
        rp = req.body
        da = new Date()
        code = req.c.code
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