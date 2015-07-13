app = require('../app')
debug = require('debug')('eclub_n:server')
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

server = http.createServer(app)

server.listen port
server.on 'error', onError
server.on 'listening', onListening