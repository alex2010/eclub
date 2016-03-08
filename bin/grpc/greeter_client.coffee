PROTO_PATH = __dirname + '/helloworld.proto'
grpc = require('grpc')
center = grpc.load(PROTO_PATH).helloworld

main = ->
    client = new (center.Center)('10.60.113.32:50051', grpc.credentials.createInsecure())
    user = undefined
    if process.argv.length >= 3
        user = process.argv[2]
    else
        user = 'world'
    client.action { name: user }, (err, response) ->
        console.log 'Greeting:', response.message
        return
    return

main()