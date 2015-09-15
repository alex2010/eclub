db.getCollection('shop').update {}, {
    $set:
        'org':
            '_id': '55b19140a28e15c646baf53a'
            'title': '神州听力'
}, multi: true


opt =
    $unset:
        roles: ''
        permission: ''
        menu: ''
        orgs: ''
        mgm: ''

db.getCollection('user').update {}, opt, multi: true



db.getCollection('shop').find({}).forEach (it)->
    if it.consultant
        cons = it.consultant
        for c in cons
            c.shop =
                _id: it._id
                title: it.title
            c._id = new ObjectId()
            db.getCollection('consultant').insert c
            db.getCollection('shop').update {_id: it._id}, $unset:{'consultant':[]}
            opt =
                $push:
                    consultant:
                        _id: c._id
                        username: c.username
            db.getCollection('shop').update {_id: it._id}, opt


db.getCollection('product').find({}).forEach (it)->
    if it.brand
        db.getCollection('brand').find({_id: new ObjectId(it.brand)}).forEach (sh)->
            if sh
                it.brand =
                    _id: sh._id
                    title: sh.title
                    origin: sh.origin
                db.getCollection('product').update {_id: it._id}, it

Date.parseLocal = (time) ->
    time = time.substring(0, 19) if time.length > 19
    new Date((time or "").replace(/-/g, "/").replace(/[TZ]/g, " "))

db.getCollection('consultant').find({}).forEach (it)->
    if it.exp
        it.exp = Date.parseLocal it.exp
        db.getCollection('consultant').update {_id: it._id}, it

db.getCollection('shop').find({}).forEach (it)->
    if it.operTime
        it.operTime = Date.parseLocal it.operTime
        db.getCollection('shop').update {_id: it._id}, it


#    "ds" : {
#        "icon" : "gift",
#        "act" : "ds",
#        "row" : 40
#    },
#    "addPost" : {
#        "icon" : "file",
#        "act" : "data/list/post",
#        "row" : 50
#    },
#    "addActivity" : {
#        "icon" : "th-large",
#        "act" : "data/list/activity",
#        "row" : 60
#    }