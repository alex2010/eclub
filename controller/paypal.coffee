ipn = require('paypal-ipn')
jade = require('jade')

module.exports = (req, rsp)->
    ipn.verify req.body, (err, msg)->
        log msg
        log params
        if err
            log err
        else
            if params.payment_status is 'Completed'
#                send email, update deal status
                log 'paypal ipn......'
                log params
                log 'good'
                dao.findAndUpdate code, 'deal', {num: params.num}, (status: 10), (it)->
                    if it
                        log it
                        email req,
                            to: it.email
                            subject: 'The Service You Booked From Wikibeijing'
                            html: jade.renderFile("#{_path}/views/module/#{code}/email/tour.jade", it)
    rsp.send(200)