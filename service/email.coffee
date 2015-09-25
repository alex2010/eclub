nodemailer = require('nodemailer')
smtpTransport = require('nodemailer-smtp-transport')

transPool = (email,host,psd)->
    log arguments
    _ePool[email] ?= nodemailer.createTransport smtpTransport
        host: host
        secureConnection: true
        auth:
            user: email
            pass: psd
    _ePool[email]

module.exports = (req, mo)->
    c = req.c
    mo.from ?= "#{c.name} <#{c.email}>"
    mo = _.pick mo, 'from', 'to', 'subject', 'html'
    transPool(c.email,c.mailHost, c.mailPsd).sendMail mo, (err, info)->
        log 'email...'
        if err
            log err
        else
            log info

#    mo =
#        from: 'bsspirit '
#        to: 'xxxxx@163.com'
#        subject: 'Hello ✔'
#        html: '<b>Hello world ✔</b>'