https = require('https')
querystring = require('querystring')


send = (phone, msg)->
    postData =
        mobile: phone
        message: msg

    content = querystring.stringify(postData)
    options =
        host: 'sms-api.luosimao.com'
        path: '/v1/send.json'
        method: 'POST'
        auth: 'api:key-12312389d10fe16c98896ced5a09945188'
        agent: false
        rejectUnauthorized: false
        headers:
            'Content-Type': 'application/x-www-form-urlencoded'
            'Content-Length': content.length

    req = https.request(options, (res) ->
        res.setEncoding 'utf8'
        res.on 'data', (chunk) ->
            console.log JSON.parse(chunk)
            return
        res.on 'end', ->
            console.log 'over'
            return
        return
    )
    req.write content
    req.end()


module.exports = (req)->
    dao.get code, 'codeMap'