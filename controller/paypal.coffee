ipn = require('paypal-ipn')
jade = require('jade')

module.exports = (req, rsp)->
    ipn.verify req.body, (err, msg)->
        if err
            log err
        else
            if params.payment_status is 'Completed'
#                send email, update deal status
                dao.findAndUpdate code, 'deal', {num: params.num}, (status: 10), (it)->
                    if it
                        email req,
                            to: it.email
                            subject: 'The Service You Booked From Wikibeijing'
                            html: jade.renderFile("#{_path}/views/module/#{code}/email/tour.jade", it)
    rsp.send(200)
    