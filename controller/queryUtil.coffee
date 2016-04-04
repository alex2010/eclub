isOid = (v)->
    _.isString(v) and v.length is 24 and /^(\d|[a-z]){24}$/.test(v)
#    k.indexOf('_id')>-1 or (k.endsWith('id') and k.length is 3 and k isnt 'wid')

_wkt = (obj, fu)->
    for k, v of obj
        if _.isArray(v) and k is '$or'
            for it in v
                if _.isObject(it)
                    for kk,vv of it
                        if vv['$exists'] and vv['$exists'] is 'false'
                            vv['$exists'] = false
        else if v and v.$in
            v.$in =
                for it in v.$in
                    if isOid(v) then new oid(it) else it
        else if k is 'price' and _.isObject v
            for kk, vv of v
                v[kk] = +vv
        else if _.isObject(v) and !_.isArray(v) and !_.isFunction(v)
            arguments.callee(v, fu)
        else
            fu(v, k, obj)

_cv = (v, k, obj)->
    if k.charAt(0) is '_' and k isnt '_id'
        delete obj[k]
    else
        obj[k] = if isOid(v)
            new oid(v)
        else if k in ['status', 'row']
            +v
        else if v is 'true'
            true
        else if v is 'false' and k isnt 'gender'
            false
        else if k is 'password' and v.length < 40
            util.sha256(v)
        else if /^\d{4}-\d{1,2}-\d{1,2}/.test(v) and v.length < 25
            Date.parseLocal(v)
        else
            v

module.exports =

    buildQuery: (q)->
        _wkt q, _cv
        q

    cleanItem: (q, isNew)->
        if isNew
            q.dateCreated = new Date()
        q.lastUpdated = new Date()
        _wkt q, _cv
        q