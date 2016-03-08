#PROTO_PATH = __dirname + '/center.proto'
PROTO_PATH = '/Users/alex/Pictures/grpc/center/center.proto'
grpc = require('grpc')
center = grpc.load(PROTO_PATH).center
client = new (center.Center)('10.60.82.117:12201', grpc.credentials.createInsecure())

#log client.action 'LineOn', {uid:1,cid:2}, ->
#    log 'zzzzz'
###*
# Run the getFeature demo. Calls getFeature with a point known to have a
# feature and a point known not to have a feature.
# @param {function} callback Called when this demo is complete
###
module.exports =
    action: (name, opt, cb)->
        opt =
            command: name
            params: JSON.stringify opt
        client.action opt, cb

#        name, opt, ->
#            log 'call back from grpc'

    notify: ()->
        client.notify ent, p, opt, ->
            log 'call back from grpc'

#runGetFeature = (callback) ->
#    next = _.after(2, callback)
#    point1 =
#        latitude: 409146138
#        longitude: -746188906
#    point2 =
#        latitude: 0
#        longitude: 0
#
#    featureCallback = (error, feature) ->
#        if error
#            callback error
#        if feature.name == ''
#            console.log 'Found no feature at ' + feature.location.latitude / COORD_FACTOR + ', ' + feature.location.longitude / COORD_FACTOR
#        else
#            console.log 'Found feature called "' + feature.name + '" at ' + feature.location.latitude / COORD_FACTOR + ', ' + feature.location.longitude / COORD_FACTOR
#        next()
#        return
#
#    client.getFeature point1, featureCallback
#    client.getFeature point2, featureCallback
#    return
#
####*
## Run the listFeatures demo. Calls listFeatures with a rectangle containing all
## of the features in the pre-generated database. Prints each response as it
## comes in.
## @param {function} callback Called when this demo is complete
####
#
#runListFeatures = (callback) ->
#    rectangle =
#        lo:
#            latitude: 400000000
#            longitude: -750000000
#        hi:
#            latitude: 420000000
#            longitude: -730000000
#    console.log 'Looking for features between 40, -75 and 42, -73'
#    call = client.listFeatures(rectangle)
#    call.on 'data', (feature) ->
#        console.log 'Found feature called "' + feature.name + '" at ' + feature.location.latitude / COORD_FACTOR + ', ' + feature.location.longitude / COORD_FACTOR
#        return
#    call.on 'end', callback
#    return
#
####*
## Run the recordRoute demo. Sends several randomly chosen points from the
## pre-generated feature database with a variable delay in between. Prints the
## statistics when they are sent from the server.
## @param {function} callback Called when this demo is complete
####
#
#runRecordRoute = (callback) ->
#    argv = parseArgs(process.argv, string: 'db_path')
#    fs.readFile path.resolve(argv.db_path), (err, data) ->
#
#        ###*
#        # Constructs a function that asynchronously sends the given point and then
#        # delays sending its callback
#        # @param {number} lat The latitude to send
#        # @param {number} lng The longitude to send
#        # @return {function(function)} The function that sends the point
#        ###
#        pointSender = (lat, lng) ->
#
#            ###*
#            # Sends the point, then calls the callback after a delay
#            # @param {function} callback Called when complete
#            ###
#            (callback) ->
#                console.log 'Visiting point ' + lat / COORD_FACTOR + ', ' + lng / COORD_FACTOR
#                call.write
#                    latitude: lat
#                    longitude: lng
#                _.delay callback, _.random(500, 1500)
#                return
#
#        if err
#            callback err
#        feature_list = JSON.parse(data)
#        num_points = 10
#        call = client.recordRoute((error, stats) ->
#            if error
#                callback error
#            console.log 'Finished trip with', stats.point_count, 'points'
#            console.log 'Passed', stats.feature_count, 'features'
#            console.log 'Travelled', stats.distance, 'meters'
#            console.log 'It took', stats.elapsed_time, 'seconds'
#            callback()
#            return
#        )
#        point_senders = []
#        i = 0
#        while i < num_points
#            rand_point = feature_list[_.random(0, feature_list.length - 1)]
#            point_senders[i] = pointSender(rand_point.location.latitude, rand_point.location.longitude)
#            i++
#        async.series point_senders, ->
#            call.end()
#            return
#        return
#    return
#
####*
## Run the routeChat demo. Send some chat messages, and print any chat messages
## that are sent from the server.
## @param {function} callback Called when the demo is complete
####
#
#runRouteChat = (callback) ->
#    call = client.routeChat()
#    call.on 'data', (note) ->
#        console.log 'Got message "' + note.message + '" at ' + note.location.latitude + ', ' + note.location.longitude
#        return
#    call.on 'end', callback
#    notes = [
#        {
#            location:
#                latitude: 0
#                longitude: 0
#            message: 'First message'
#        }
#        {
#            location:
#                latitude: 0
#                longitude: 1
#            message: 'Second message'
#        }
#        {
#            location:
#                latitude: 1
#                longitude: 0
#            message: 'Third message'
#        }
#        {
#            location:
#                latitude: 0
#                longitude: 0
#            message: 'Fourth message'
#        }
#    ]
#    i = 0
#    while i < notes.length
#        note = notes[i]
#        console.log 'Sending message "' + note.message + '" at ' + note.location.latitude + ', ' + note.location.longitude
#        call.write note
#        i++
#    call.end()
#    return

###*
# Run all of the demos in order
###
#
#main = ->
#    async.series [
#        runGetFeature
#        runListFeatures
#        runRecordRoute
#        runRouteChat
#    ]
#    return
#
#if require.main == module
#    main()
#
#exports.runGetFeature = runGetFeature
#exports.runListFeatures = runListFeatures
#exports.runRecordRoute = runRecordRoute
#exports.runRouteChat = runRouteChat

# ---
# generated by js2coffee 2.1.0