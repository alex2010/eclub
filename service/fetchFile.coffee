fs = require('fs')
request = require('request')

module.exports = (url, name, callback)->
    request.head url, (err, res, body)->
        request(url).pipe(fs.createWriteStream(name)).on('close', callback)