PROTO_PATH = __dirname + '/bin/grpc/center.proto'
fs = require('fs')
parseArgs = require('minimist')
path = require('path')
_ = require('lodash')
grpc = require('grpc')
routeguide = grpc.load(PROTO_PATH).center
center = grpc.load(PROTO_PATH).center

COORD_FACTOR = 1e7

###*
# For simplicity, a point is a record type that looks like
# {latitude: number, longitude: number}, and a feature is a record type that
# looks like {name: string, location: point}. feature objects with name===''
# are points with no feature.
###

###*
# List of feature objects at points that have been requested so far.
###

feature_list = []
route_notes = {}

###*
# Get a feature object at the given point, or creates one if it does not exist.
# @param {point} point The point to check
# @return {feature} The feature object at the point. Note that an empty name
#     indicates no feature
###

checkFeature = (point) ->
    feature = undefined
    # Check if there is already a feature object for the given point
    i = 0
    while i < feature_list.length
        feature = feature_list[i]
        if feature.location.latitude == point.latitude and feature.location.longitude == point.longitude
            return feature
        i++
    name = ''
    feature =
        name: name
        location: point
    feature

###*
# getFeature request handler. Gets a request with a point, and responds with a
# feature object indicating whether there is a feature at that point.
# @param {EventEmitter} call Call object for the handler to process
# @param {function(Error, feature)} callback Response callback
###

getFeature = (call, callback) ->
    callback null, checkFeature(call.request)
    return

###*
# listFeatures request handler. Gets a request with two points, and responds
# with a stream of all features in the bounding box defined by those points.
# @param {Writable} call Writable stream for responses with an additional
#     request property for the request value.
###

listFeatures = (call) ->
    lo = call.request.lo
    hi = call.request.hi
    left = _.min([
        lo.longitude
        hi.longitude
    ])
    right = _.max([
        lo.longitude
        hi.longitude
    ])
    top = _.max([
        lo.latitude
        hi.latitude
    ])
    bottom = _.min([
        lo.latitude
        hi.latitude
    ])
    # For each feature, check if it is in the given bounding box
    _.each feature_list, (feature) ->
        if feature.name == ''
            return
        if feature.location.longitude >= left and feature.location.longitude <= right and feature.location.latitude >= bottom and feature.location.latitude <= top
            call.write feature
        return
    call.end()
    return

###*
# Calculate the distance between two points using the "haversine" formula.
# This code was taken from http://www.movable-type.co.uk/scripts/latlong.html.
# @param start The starting point
# @param end The end point
# @return The distance between the points in meters
###

getDistance = (start, end) ->
    lat1 = start.latitude / COORD_FACTOR
    lat2 = end.latitude / COORD_FACTOR
    lon1 = start.longitude / COORD_FACTOR
    lon2 = end.longitude / COORD_FACTOR
    R = 6371000
    # metres
    φ1 = toRadians(lat1)
    φ2 = toRadians(lat2)
    Δφ = toRadians(lat2 - lat1)
    Δλ = toRadians(lon2 - lon1)
    a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    toRadians = (num) ->
        num * Math.PI / 180

    R * c

###*
# recordRoute handler. Gets a stream of points, and responds with statistics
# about the "trip": number of points, number of known features visited, total
# distance traveled, and total time spent.
# @param {Readable} call The request point stream.
# @param {function(Error, routeSummary)} callback The callback to pass the
#     response to
###

recordRoute = (call, callback) ->
    point_count = 0
    feature_count = 0
    distance = 0
    previous = null
    # Start a timer
    start_time = process.hrtime()
    call.on 'data', (point) ->
        point_count += 1
        if checkFeature(point).name != ''
            feature_count += 1

        ### For each point after the first, add the incremental distance from the
        # previous point to the total distance value
        ###

        if previous != null
            distance += getDistance(previous, point)
        previous = point
        return
    call.on 'end', ->
        callback null,
            point_count: point_count
            feature_count: feature_count
            distance: distance | 0
            elapsed_time: process.hrtime(start_time)[0]
        return
    return

###*
# Turn the point into a dictionary key.
# @param {point} point The point to use
# @return {string} The key for an object
###

pointKey = (point) ->
    point.latitude + ' ' + point.longitude

###*
# routeChat handler. Receives a stream of message/location pairs, and responds
# with a stream of all previous messages at each of those locations.
# @param {Duplex} call The stream for incoming and outgoing messages
###

routeChat = (call) ->
    call.on 'data', (note) ->
        key = pointKey(note.location)

        ### For each note sent, respond with all previous notes that correspond to
        # the same point
        ###

        if route_notes.hasOwnProperty(key)
            _.each route_notes[key], (note) ->
                call.write note
                return
        else
            route_notes[key] = []
        # Then add the new note to the list
        route_notes[key].push JSON.parse(JSON.stringify(note))
        return

    call.on 'end', ->
        call.end()
        return

    return

###*
# Get a new server with the handler functions in this file bound to the methods
# it serves.
# @return {Server} The new server object
###

getServer = ->
    server = new (grpc.Server)
    server.addProtoService routeguide.Center.service,
        action: action
        notify: notify
    server

if require.main == module
# If this is run as a script, start a server on an unused port
    routeServer = getServer()
    routeServer.bind '0.0.0.0:50051', grpc.ServerCredentials.createInsecure()
    argv = parseArgs(process.argv, string: 'db_path')
    fs.readFile path.resolve(argv.db_path), (err, data) ->
        if err
            throw err
        feature_list = JSON.parse(data)
        routeServer.start()
        return
exports.getServer = getServer

# ---
# generated by js2coffee 2.1.0