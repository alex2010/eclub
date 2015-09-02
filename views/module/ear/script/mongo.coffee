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