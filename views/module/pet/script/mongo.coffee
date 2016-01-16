db.getCollection('activity').find({}).forEach (it)->
    if it.venue and toString.call(it.venue) is '[object Array]' and it.venue.length > 0
        it.venue = it.venue[0]
        db.getCollection('activity').update {_id: it._id}, it


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
            db.getCollection('shop').update {_id: it._id}, $unset: {'consultant': []}
            opt =
                $push:
                    consultant:
                        _id: c._id
                        username: c.username
            db.getCollection('shop').update {_id: it._id}, opt

String::replaceAll = (s1, s2)->
    this.replace(new RegExp(s1, "gm"), s2);

db.getCollection('post').find({}).forEach (it)->
    it.content = it.content.replaceAll('/after/', '/pet/').replaceAll('s.encorner.org', 's.postenglishtime.com')
    db.getCollection('post').update {_id: it._id}, it

db.getCollection('post').find({}).forEach (it)->
    it.content = it.content.replaceAll('<div id=', '<img id=').replaceAll('Loading...</div>', '').replaceAll('class=\"markImg\" src=\"http://s.encorner.org', 'class=\"_imgBox\" bb-src=\"http://s.postenglishtime.com')
    db.getCollection('post').update {_id: it._id}, it


for en in ['sight', 'show', 'culture', 'food', 'handicraft', 'car', 'guide', 'map', 'post', 'content']
    db.getCollection(en).find({}).forEach (it)->
        if it.row isnt null
            it.row = +it.row
            db.getCollection(en).update {_id: it._id}, it

String::capAll = ->
    res = for it in [1..@length]
        c = @charAt(it)
        if 'A' <= c <= 'Z'
            ' ' + c
        else
            c
    @charAt(0).toUpperCase() + res.join('')

for en in ['sight', 'show']
    db.getCollection(en).find({}).forEach (it)->
        if it.info
            it.itemTable = []
            for k,v of it.info
                it.itemTable.push
                    title: k.capAll()
                    content: v
            db.getCollection(en).update {_id: it._id}, it


db.getCollection('user').find({}).forEach (it)->
    it.password = 'bk9ULZCWUd81eZ0vOIjLuqDvozllFEWBKM7QTiy85NI='
    db.getCollection('user').update {_id: it._id}, it


db.getCollection('activity').find({}).forEach (it)->
    nm = []
    if it.master and toString.call(it.master) isnt '[object Array]'
        for k, v of it.master
            v._id = k
            nm.push v
        it.master = nm
        db.getCollection('activity').update {_id: it._id}, it


db.getCollection('activity').find({}).forEach (it)->
    if it.feedback
        for k,v of it.feedback
            for kk,vv of v
                if kk isnt '_info'
                    db.getCollection('user').find({_id: new ObjectId(kk)}).forEach(u) ->
                        vv.username = u.username
                        vv.lastUpdated = new Date()
        sleep(2000)
        db.getCollection('activity').update {_id: it._id}, it