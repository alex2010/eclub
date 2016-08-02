qr = require('qr-image')

module.exports =
    linkImg: (req, rsp)->
        link = req.query.link
        try
            img = qr.image link.replaceAll(':::', '&'), size: 10
            rsp.writeHead 200, 'Content-Type': 'image/png'
            img.pipe(rsp)
        catch e
            rsp.writeHead 414, {'Content-Type': 'text/html'}
            rsp.end '<h1>414 Request-URI Too Large</h1>'
