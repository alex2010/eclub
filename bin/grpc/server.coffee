PROTO_PATH = __dirname + '/../protos/helloworld.proto'
grpc = require('grpc')
hello_proto = grpc.load(PROTO_PATH).helloworld

###*
# Implements the SayHello RPC method.
###

sayHello = (call, callback) ->
    callback null, message: 'Hello ' + call.request.name

###*
# Starts an RPC server that receives requests for the Greeter service at the
# sample server port
###

main = ->
    server = new (grpc.Server)
    server.addProtoService hello_proto.Greeter.service, sayHello: sayHello
    server.bind '0.0.0.0:50051', grpc.ServerCredentials.createInsecure()
    server.start()

main()
