module.exports = (code, entity, d, fn)->
    dao.delItem code, entity, _id: oid(d.id), null, ->
        if entity is 'user'
            dao.delItem code, 'membership', uid: oid(d.id)
        fn msg: 'm_del_ok'