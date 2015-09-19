nodemailer = require('nodemailer')
`
    _ePool = {};
`
#gmail =
#    service: 'Gmail'
#    auth:
#        user: email
#        pass: 'xxxxx'


transPool(email) ->
    _ePool[email] ?= nodemailer.createTransport 'SMTP',
        host: 'smtp.exmail.qq.com'
        secureConnection: true
#        port: 465
        auth:
            user: email
            pass: 'rock200*'
    _ePool[email]

module.exports = (req, mo)->
    c = req.c
    mo.from ?= "#{c.name} #{c.email}"
    transPool(c.email).sendMail mo, (err, info)->
        if err
            log err
        else
            log info


#    mo =
#        from: 'bsspirit '
#        to: 'xxxxx@163.com'
#        subject: 'Hello ✔'
#        text: 'Hello world ✔'
#        html: '<b>Hello world ✔</b>'