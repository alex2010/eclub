adminRoleId = new oid()
adminUserId = new oid()

ownerRoleId = new oid() # 店长
ownerUserId = new oid()

consultantRoleId = new oid() # 眼配师
consultantUserId = new oid()


role = [
#    _id: adminRoleId
    title: 'admin'
    label: '管理员'
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
                brand: 1
                product: 20
                shop: 30
                post: 40
                content: 50
                cat: 70
                link: 80

                community: 'x'
                role: 'x'
                wechat: 'x'
                codeMap: 'x'

        permission:
            page: 'console'
,
#    _id: ownerRoleId
    title: 'manager'
    label: '店长'
    type: 0
    res:
        menu:
            home:
                icon: 'user'
                act: 'profile'
                row: 1
        permission:
            page: 'wechat'

,
#    _id: consultantRoleId
    title: 'member'
    label: '眼配师'
    type: 0
    res:
        menu:
            shop:
                icon: 'gift'
                act: 'shop'
                row: 10
        permission:
            page: 'wechat'
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

pubAccount = [
    'appId': 'wx41872ec02d39aaf9'
    'code': 'EAR_Helper'
    'secret': '311865aa02a783a1d10034d423a4c371'
    'sid': 'gh_c212471406a7'
    'status': 1
    'title': '掌上听力专家'
    'menu':
        'button': [
            'type': 'view'
            'name': '年会报名'
            'url': 'http://url.com/wechat.html#!/sd'
        ,
            'type': 'click'
            'name': '资料'
            'sub_button': [
                'type': 'view'
                'url': 'http://elp.newenglishtime.com/wechat#!/profile'
                'name': '我的信息'
            ,
                'url': 'http://elp.newenglishtime.com/search'
                'type': 'view'
                'name': '查询P成员'

            ]
        ,
            'type': 'view'
            'name': '供需交流'
            'url': 'http://url.com/wechat.html#!/sd'
        ]
]

module.exports =
    community:
        code: code
        name: '掌上听力专家'
        resPath: if _env then '/res' else 'http://s.wikibeijing.com'
        url: if _env then 't.ear.com' else 'ear.eclubnet.com'

    data:
        'role:title': role
#        'user:username': user
#        'membership:uid,rid': membership
#        'pubAccount:appId': pubAccount
#        'i18n:key': require('./zh')
