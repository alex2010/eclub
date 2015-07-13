adminRoleId = new oid()
adminUserId = new oid()

ownerRoleId = new oid() # 店长
ownerUserId = new oid()

consultantRoleId = new oid() # 眼配师
consultantUserId = new oid()


role = [
    _id: adminRoleId
    title: 'admin'
    type: 0
    res:
        mgm:
            menu:
                home: 1
                site: 2
                data: 3
                wechat: 4
                userRole: 7
            entity:
                brand:1
                shop:2
                post: 3
                content: 4
                cat: 7
                link: 8

                community: 'x'
                role: 'x'
                wechat: 'x'
                codeMap: 'x'
        permission:
            page: 'console'
]

user = [
    _id: adminUserId
    username: code
    password: 'psd'
]

membership = [
    uid: adminUserId
    rid: adminRoleId
]

module.exports =
    community:
        code: code
        name: '助听器'
        resPath: if _env then '/res' else 'http://s.wikibeijing.com'
        url: if _env then 't.ear.com' else 'ear.eclubnet.com'

    data:
        'role:title': role
        'user:username': user
        'membership:uid,rid': membership
        'i18n:key': require('./zh')
