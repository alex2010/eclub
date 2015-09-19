ipn = require('paypal-ipn')
jade = require('jade')

module.exports = (req, rsp)->
    ipn.verify req.body, (err, msg)->
        log msg
        if err
            log err
        else
            if params.payment_status is 'Completed'
#                send email, update deal status
                log 'paypal ipn......'
                log params
                log 'good'
                dao.findAndUpdate code, 'deal', {num: num}, (status: 10), (res)->
                    it = res.value
                    log it
                    email req,
                        to: it.email
                        subject: 'Hello ✔'
                        html: jade.renderFile("#{_path}/views/module/#{code}/wechat/#{tmpl}.jade", it)
    rsp.send(200)