PROTO_PATH = __dirname + '/../protos/helloworld.proto'
grpc = require('grpc')
hello_proto = grpc.load(PROTO_PATH).helloworld

main = ->
    client = new (hello_proto.Greeter)('localhost:50051', grpc.credentials.createInsecure())
    user = undefined
    if process.argv.length >= 3
        user = process.argv[2]
    else
        user = 'world'
    client.sayHello {name: user}, (err, response) ->
        console.log 'Greeting:', response.message
        return
    return

main()