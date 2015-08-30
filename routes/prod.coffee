router = require('express').Router()
path = require('path')

auth = require '../controller/auth'
data = require '../controller/data'
page = require '../controller/page'
up = require '../controller/upload'
captcha = require '../controller/captcha'

wxpay = require('weixin-pay')

checkPagePattern = (req, rsp, next, page)->
    if /^\w+$/.test(page)
        next()
    else
        rsp.end('name error')

router.param 'entity', checkPagePattern
router.param 'page', checkPagePattern


ck = (req)->
    req.hostname + req.url

pre = (req, rsp, next)->

    unless app.env
        req.hostname = req.get('Host')

    cc = req.query._c
    if cc
        if cc is '0' and req.query._e
            opt =
                $regex:
                    k: "#{req.query._e}"
        else if cc is '1'
            req.url = req.url.replace('&_c=1', '')
            req.url = req.url.replace('?_c=1', '')
#            if req.url.endsWith('?')
#                req.url = req.url.substr(0, req.url.length - 1)
            opt =
                k: ck(req)

        if opt
            dao.delItem _mdb, 'cache', opt, (res)->
                log 'del...'

    k = ck req
    dao.get _mdb, 'cache', k: k, (res)->
        if res and !app.env
            rsp.end res.str
        else
            rStr = req.hostname.replace('www.','')
            req.c = app._community[rStr]
            req.k = k
            next()

checkPage = (req, rsp, next)->
    pm = req.params
    page = pm.page || pm.entity || 'index'
#    log req.originalUrl
    if page in ['a','r']
        next()
        return
    req.fp = path.join(_path, "views/module/#{req.c.code}")

    if page in ['res','images']
        rsp.end 'no page'
        return

    if fs.existsSync("#{req.fp}/#{page}.jade")
        next()
    else
        req.fp = path.join(_path, "views")
        log "#{req.fp}/#{page}.jade"
        if fs.existsSync("#{req.fp}/#{page}.jade")

            next()
        else
            rsp.end 'no page'

router.get '/', pre
router.all '/a/*', pre
router.all '/r/*', pre

router.post '/a/upload', up.upload
router.post '/a/upload/remove', up.remove


router.post '/a/cleanCache', data.cleanCache

router.get '/a/captcha', captcha.cap

router.post '/a/auth/login', auth.login
router.post '/a/auth/loginByWoid', auth.loginByWoid
router.post '/a/auth/logout', auth.logout
router.post '/a/auth/logoutByWoid', auth.logoutByWoid
#wechat call

wt = require '../controller/wechat'
router.post '/a/wt/createMenu', wt.createMenu
router.post '/a/wt/createLimitQRCode', wt.createLimitQRCode
router.post '/a/wt/showQRCodeURL', wt.showQRCodeURL
router.post '/a/wt/uploadNews', wt.uploadNews
router.get '/a/wt/userInfoByCode', wt.userInfoByCode
router.post '/a/wt/jsSign', wt.jsSign
router.post '/a/wt/wxPay', wt.wxPay

router.get '/r/c/mg/file/list', up.fileList

router.get '/r/comp', data.comp
router.get '/r/:entity', data.list
router.get '/r/:entity/:id', data.get
router.get '/r/:entity/:q/:qv/:prop', data.getSub
router.get '/r/:entity/:key/:val', data.getByKey



router.put '/r/:entity/:id', data.edit
router.post '/r/:entity', data.save
router.delete '/r/:entity/:id', data.del

router.post '/r/:type/:entity/:q/:qv/:prop', data.saveSub

router.delete '/r/:type/:entity/:q/:qv/:key', data.delSub


#wechat request
#wtr = require('wechat')

#router.use express.query


router.get '/:entity/:attr/:id', pre
router.get '/:entity/:attr/:id', checkPage

router.get '/:entity/:id', pre
router.get '/:entity/:id', checkPage

router.get '/:page', pre
router.get '/:page', checkPage

router.get '/', checkPage

router.get '/', page.page
router.get '/:page', page.page
router.get '/:entity/:id', page.entity
router.get '/:entity/:attr/:id', page.entity

router.use '/a/wt/notify/:code', wxpay::useWXCallback (msg,req,res)->
    log req.c.code
    log msg
    # do biz here
    res.success()

module.exports = router