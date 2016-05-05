router = require('express').Router()
path = require('path')

auth = require '../controller/auth'
data = require '../controller/data'
page = require '../controller/page'
up = require '../controller/upload'
mgm = require '../controller/mgm'
captcha = require '../controller/captcha'
sms = require '../controller/sms'
batch = require '../controller/batch'
qrImg = require '../controller/qrImg'

wxpay = require('weixin-pay')

#checkPagePattern = (req, rsp, next, page)->
#    log 'checkPagePattern...'
#    if /^\w+$/.test(page)
#        next()
#    else if /^\w+\.html$/.test(page)
#        req._html = page
#        next()
#    else
#        rsp.end('name error')

#router.param 'entity', checkPagePattern
#router.param 'page', checkPagePattern

ee.on 'user_track', (req)->
    opt =
        url: req.headers.origin  + req.url
        pathname: req._parsedUrl.pathname
        method: req.method
        dateCreated: new Date()

    if !_.isEmpty(req.query)
        opt.query = req.query

    if u = req.cookies.__ux
        [opt.uid,opt.username] = u.split(':')

    if req.method != 'GET' and !_.isEmpty req.body
        opt.body = req.body

    dao.pick(req.c.code, 'userTrack').insert opt, {}, (err, docs)->

ck = (req)->
    req.hostname + req.url

prepare = (req)->
    unless app.env
        req.hostname = req.get('Host')
    req.c = pickSite req


actPre = (req, rsp, next)->
    prepare req
    true && ee.emit 'user_track', req
    next()

resPre = (req, rsp, next)->
    prepare req
#    req.c.userTrack && ee.emit 'user_track', req
    true && ee.emit 'user_track', req
    if req.method is 'GET'
        dao.get req.c.code, 'cache', k: ck(req), (res)->
            if res and !app.env
                rsp.end res.str
            else
                next()
    else
        next()

pre = (req, rsp, next)->
    prepare req
    k = ck req

    opt = {}
    if /mobile/i.test(req.headers['user-agent'])
        req.mob = true
        opt.mob = true
    else
        opt.mob = false

    cc = req.query._c
    if cc
        if cc is '0' and req.query._e
            opt.$regex =
                k: "#{req.query._e}"
            kill = true
        else if cc is '1'
            k = if k.indexOf('&') > -1
                k.replace('_c=1&', '').replace('&_c=1', '')
            else
                k.replace('?_c=1', '')
            opt.k = k
            kill = true

        if kill
            dao.delItem _mdb, 'cache', opt, (res)->
                log 'del...'

        if req.query._r
            rsp.end 'cleaned'

    if req._html
        rStr = req.hostname.replace('www.', '')
        req.c = app._community[rStr]
        path = "#{_path}/public/res/upload/#{req.c.code}/html/#{req._html}"
        rsp.sendfile(path)
        return

    opt.k = k
    dao.get _mdb, 'cache', opt, (res)->
        if res and !app.env
            rsp.end res.str
        else
            req.k = k
            next()

pickSite = (req)->
#    if qc = req.cookies._code
#        for k,v of app._community
#            if v.code is qc
#                return v
    if qc = req.query._code
        for k,v of app._community
            if v.code is qc
                return v
    else
        app._community[req.hostname.replace('www.', '')]

checkPage = (req, rsp, next)->
    log 'check page'
    if req.params.page is 'socket.io'
        log 'next'
        next()
        return
    pm = req.params
    page = pm.page || pm.entity || 'index'
    if /^\w+$/.test(page)
    else if /^\w+\.html$/.test(page)
        req._html = page
    else
        rsp.end('name error')

    req.fp = path.join(_path, "public/module/#{req.c.code}")

    if page in ['res', 'images']
        rsp.end 'no page'
        return
    if fs.existsSync("#{req.fp}/#{page}.jade")
        next()
    else
        req.fp = path.join(_path, "public/module")
        log "default find the: #{req.fp}/#{page}.jade"
        if fs.existsSync("#{req.fp}/#{page}.jade")
            next()
        else
            rsp.end 'no page'

router.all '/a/*', actPre
router.all '/r/*', resPre

router.post '/a/upload', up.upload
router.post '/a/upload/remove', up.remove
router.post '/a/cleanCache', data.cleanCache
router.get '/a/captcha', captcha.cap
router.get '/a/smsVerify', sms.getCode
router.get '/a/smsFindPsd', sms.findPsd
#router.get '/a/checkPhone', sms.checkPhone

router.post '/a/auth/login', auth.login
router.post '/a/auth/loginByWoid', auth.loginByWoid
router.post '/a/auth/logout', auth.logout
router.post '/a/auth/logoutByWoid', auth.logoutByWoid

wt = require '../controller/wechat'
router.get '/a/wt/userInfoByCode', wt.userInfoByCode
router.post '/a/wt/uploadNews', wt.uploadNews
router.post '/a/wt/sendMessNews', wt.sendMessNews
router.post '/a/wt/removeRes', wt.removeRes
router.post '/a/wt/sendTest', wt.sendTest
router.post '/a/wt/createMenu', wt.createMenu
router.post '/a/wt/createLimitQRCode', wt.createLimitQRCode
router.post '/a/wt/showQRCodeURL', wt.showQRCodeURL
router.post '/a/wt/jsSign', wt.jsSign
router.post '/a/wt/wxPay', wt.wxPay

router.post '/a/batch/add/:entity', batch.add
router.post '/a/batch/del/:entity', batch.del

router.post '/a/site/gen/:id', mgm.genSite
router.post '/a/site/bdPush', mgm.bdPush
router.get '/a/qrImg', qrImg.linkImg

router.get '/r/wt/login', wt.login
router.get '/r/c/mg/file/list', up.fileList

router.get '/r/comp', data.comp
router.get '/r/:entity', data.list
router.get '/r/:entity/:id', data.get
router.get '/r/:entity/:q/:qv/:prop', data.getSub
router.get '/r/:entity/:key/:val', data.getByKey

router.put '/r/:entity/:id', data.edit
router.patch '/r/:entity/:id', data.edit
router.post '/r/:entity', data.save
router.delete '/r/:entity/:id', data.del
router.post '/r/:type/:entity/:q/:qv/:prop', data.saveSub
router.post '/a/:type/:entity/:q/:qv/:prop', data.saveSub
router.post '/a/inc/:entity/:id/:prop', data.inc
router.delete '/a/:type/:entity/:q/:qv/:key', data.delSub

router.use '/a/paypal/notify', require '../controller/paypal'

router.use '/a/wt/notify/:code', wxpay::useWXCallback (msg, req, res)->
# do biz here
    res.success()

router.post '/userTrack', (req, rsp)->
    opt = req.body
    code = util.del 'code', opt
    _.extend opt,
        dateCreated: new Date()
    if u = req.cookies.__ux
        [opt.uid,opt.username] = u.split(':')
    dao.pick(code, 'userTrack').insert opt, {}, (err, docs)->
    rsp.end 'done'


router.get '/', pre
router.get '/', checkPage
router.get '/', page.page

router.get '/:page', pre
router.get '/:page', checkPage
router.get '/:page', page.page

router.get '/:entity/:id', pre
router.get '/:entity/:id', checkPage
router.get '/:entity/:id', page.entity

router.get '/:entity/:attr/:id', pre
router.get '/:entity/:attr/:id', checkPage
router.get '/:entity/:attr/:id', page.entity

module.exports = router