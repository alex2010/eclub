https = require('https')
querystring = require('querystring')


send = (phone, msg, key)->
    postData =
        mobile: phone
        message: msg


    content = querystring.stringify(postData)

    options =
        host: 'sms-api.luosimao.com'
        path: '/v1/send.json'
        method: 'POST'
        auth: "api:key-#{key}"
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
    k = "#{req.c.code}_lsm"
    run = (key)->
        send req.body.msg, req.body.phone, key

    loader = (run, ctx)->
        dao.get code, 'codeMap', code: 'luosimao', (item)->
            log item
            ctx[k] = item.value.key
            run(key)

    cc.pick k, run, loader


