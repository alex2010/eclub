#PROTO_PATH = __dirname + '/helloworld.proto'
PROTO_PATH = '/Users/alex/Pictures/grpc/center/center.proto'
grpc = require('grpc')
center = grpc.load(PROTO_PATH).center

###*
# Implements the SayHello RPC method.
###

action = (call, cc, callback) ->
    callback null, message: 'Hello ' + call.request.name
    return

notify = (call, bb, callback) ->
    callback null, message: 'Hello ' + call.request.name
    return

###*
# Starts an RPC server that receives requests for the Greeter service at the
# sample server port
###

main = ->
    server = new (grpc.Server)
    server.addProtoService center.Center.service,
        action: action
        notify: notify
    server.bind '0.0.0.0:50051', grpc.ServerCredentials.createInsecure()
    server.start()
    return

main()