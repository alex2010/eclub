isOid = (v)->
    _.isString(v) and v.length is 24 and /^(\d|[a-z]){24}$/.test(v)

_type = (type,v)->
    switch type
        when 'i'
            +v
        when 'b'
            if v is 'true'
                true
            else
                false
        when 'd'
            new Date(v)
        else
            v

_wkt = (obj, fu)->
    for k, v of obj
        if _.isArray(v) and k is '$or'
            for it in v
                if _.isObject(it)
                    for kk,vv of it
                        if vv['$exists'] and vv['$exists'] is 'false'
                            vv['$exists'] = false
        else if k.indexOf('__') > -1
            [rk,type] = k.split('__')
            obj[rk] = _type(type,v)
            util.del k, obj
        else if v and v.$in
            v.$in =
                for it in v.$in
                    if isOid(v) then oid(it) else it
        else if _.isObject(v) and !_.isArray(v) and !_.isFunction(v)
            arguments.callee(v, fu)
        else
            fu(v, k, obj)

_cv = (v, k, obj)->
    if k.charAt(0) is '_' and !(k in ['_e','_id'])
        delete obj[k]
    else
        obj[k] = if isOid(v)
            oid(v)
        else if k in ['status', 'row']
            +v
        else if v is 'true'
            true
        else if v is 'false' and k isnt 'gender'
            false
        else if k is 'password' and v.length < 40
            util.sha256(v)
        else if /^\d{4}-\d{1,2}-\d{1,2}/.test(v) and v.length < 25
            new Date(v)
        else
            v

module.exports =

    attrs: (attr)->
        op = {}
        for it in attr.split(',')
            continue if it.charAt(0) is '_'
            op[it] = 1
        op

    afterPersist: (item, entity)->
        if entity is 'community'
            app._community[item.url] = item
        
    buildQuery: (q)->
        _wkt q, _cv
        q

    queryClean:(q)->
        _wkt q, _cv
        q

    cleanItem: (q, isNew)->
        for k,v of q
            if k.charAt(0) is '_' and (k isnt '_e')
                delete q[k]
        _wkt q, _cv
        if isNew
            q.dateCreated = new Date()
        q.lastUpdated = new Date()
        q

#        else if k is 'price' and _.isObject v
#            for kk, vv of v
#                v[kk] = +vv