Mongodb = require('mongodb')
_ = require('underscore')

oid = require('mongodb').ObjectID
`
    _db = {};
`
Db = Mongodb.Db
#Connection = Mongodb.Connection
Server = Mongodb.Server
opt =
    socketOptions:
        keepAlive: 1
        connectTimeoutMS: 30000

_opt = {w: 1}

module.exports = ->
    @newDb = (name, callback)->
        if app.env
            s =
                db_host: '127.0.0.1'
                db_port: 27017
        else
            s = (if name == 'main'
                require("../setting")
            else
                require("../public/module/#{name}/script/setting"))
        db = new Db(name, new Server(s.db_host, s.db_port, opt)) #, safe: true
        _db[name] = db
        db.open ->
            callback?()
        db

    @pick = (name, cName)->
        if cName in ['community', 'cache']
            name = _mdb

        if @name is name and @cName is cName
            @collection
        else
            db = _db[name]
            unless db
                db = @newDb name, ->
                    log 'open ' + name
            @collection = db.collection cName
            @name = name
            @cName = cName
            @collection

    @index = (db, entity, index, opt)->
        @pick(db, entity).createIndex index, opt

    @get = (db, entity, filter, callback)->
        opt = {}
        if filter.fields
            opt =
                fields: util.d filter, 'fields'
        filter = @cleanOpt(filter)

        @pick(db, entity).findOne filter, opt, (err, doc)->
            throw err if err
            doc._e = entity if doc
            callback?(doc)

    @find = (db, entity, filter, op = {}, callback)->
        if op.sort
            for k,v of op.sort
                op.sort[k] = +(v)
        else
            op.sort =
                lastUpdated: -1
                row: -1
                
        @pick(db, entity).find(filter, op).toArray (err, docs)->
            log arguments
            for it in docs
                it._e = entity
            callback?(docs)

    @cleanOpt = (opt) ->
        if opt._id
            if _.isArray opt._id
                opt._id = (new oid(it) for it in opt._id)
            else
                opt._id = new oid(opt._id)
        opt

    @count = (db, entity, opt, callback)->
        @pick(db, entity).count opt, (err, count)->
            throw err if err
            callback(count)

    @qc = (db, entity, q, op)->
        @pick(db, entity).findAndModify q, null, op, {upsert: true, new: true}, ->

    @findAndUpdate = (db, entity, filter, opt, callback)->
        filter = @cleanOpt(filter)
        delete opt._id
        @pick(db, entity).findAndModify filter, null, opt, {upsert: true, new: true}, (err, doc)->
            throw err if err
            item = doc.value
            callback?(item)

    @save = (db, entity, items, callback)->
        [entity,keys] = entity.split(':')

        items = [items] unless _.isArray items
        if keys
            keys = keys.split(',')
            for it in items
                filter = _.pick(it, keys)
                @pick(db, entity).update filter, it, {upsert: true}, (err, docs)->
                    throw err if err
                    callback?(docs.ops)
        else
            @pick(db, entity).insert items, {safe: true}, (err, docs)->
                throw err if err
                callback?(docs.ops)

    @del = ()->
        log 'rm'

    @delItem = (db, entity, filter, opt = _opt, callback)->
        if filter._id
            m = 'deleteOne'
        else
            m = 'deleteMany'
        @pick(db, entity)[m] filter, opt, (err, res)->
            throw err if err
            callback?(res)

    @remove = (db, entity, filter, opt = _opt, callback)->
        @pick(db, entity).remove(filter, opt, callback)

    @close = (name)->
        log 'closed ' + name
        _db[name]?.close()
        _db[name] = null
    @