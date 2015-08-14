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