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