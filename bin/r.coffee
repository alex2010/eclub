app = require('../app')
debug = require('debug')('node:server')
http = require('http')


normalizePort = (val) ->
    port = parseInt(val, 10)
    if isNaN(port)
        # named pipe
        return val
    if port >= 0
        # port number
        return port
    false

port = normalizePort(process.env.PORT or '3000')
app.set 'port', port

onError = (error) ->
    if error.syscall != 'listen'
        throw error
    bind = if typeof port == 'string' then 'Pipe ' + port else 'Port ' + port
    switch error.code
        when 'EACCES'
            console.error bind + ' requires elevated privileges'
            process.exit 1
        when 'EADDRINUSE'
            console.error bind + ' is already in use'
            process.exit 1
        else
            throw error
    return

onListening = ->
    addr = server.address()
    bind = if typeof addr == 'string' then 'pipe ' + addr else 'port ' + addr.port
    debug 'Listening on ' + bind
    return
`
server = http.createServer(app);
`
args = null
process.argv.forEach (val, index, array)->
    args = array

#_code:pvp

ee.on '_loaded',->
    pp = _path+'/public/module/'
    fs.readdirSync(pp).forEach (it)->
        if fs.statSync(pp + it).isDirectory() and !it.startsWith('_')
            ppp = "#{pp+it}/script/server.js"
            fs.stat ppp, (err, stat)->
                unless err
                    require ppp
#log 'zzz1'
#for it in args
#    log it
#    if it.startsWith '_code'
#        cc = it.split(':')[1]
#        break
#if cc
#    log cc
#    require "../public/module/#{cc}/server/extend"

server.listen port
server.on 'error', onError
server.on 'listening', onListening