adminRoleId = new oid()
adminUserId = new oid()

role = [
    _id: adminRoleId
    title: 'admin'
    type: 0
    res:
        mgm:
            menu:
                site: 2
                data: 3
                wechat: 4
                tmpl: 5
                file: 6
                userRole: 7

            entity:
                activity: 1
                topic: 2
                post: 3
                content: 4
                head: 5
                thread: 6
                cat: 7
                link: 8
                venue: 9

                participant: 'x'
                community: 'x'
                role: 'x'
                wechat: 'x'
                codeMap: 'x'
        permission:
            page: 'console'
,
    title: 'guest'
    type: 0
    nav: [
        label: '首页'
        href: '/'
    ,
        label: '活动'
        href: '/activityList'
    ,
        label: '话题'
        href: '/topicList'
    ,
        label: '阅读'
        href: '/postList'
        children: [
            label: '英文'
            href: '/postList?cat=en'
        ,
            label: '旅行'
            href: '/postList?cat=travel'
        ,
            label: '职场'
            href: '/postList?cat=work'
        ,
            label: '情感'
            href: '/postList?cat=love'
        ,
            label: '健身'
            href: '/postList?cat=fitness'
        ,
            label: '生活品味'
            href: '/postList?cat=life'

        ]
    ]
    foot: [
        label: '关于我们'
        href: '/content/about'
    ,
        label: '联系我们'
        href: '/content/contact'
    ,
        label: '发展历史'
        href: '/content/pp'
    ,
        label: '建议与留言'
        href: '/content/ys'
    ]
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

#cfg = [
#    require('../../data/style')
#,
#    title: 'wechat'
#    value:
#        code: 'PostEnglishTime'
#        appId: 'wx23ea6078636b8115'
#        secret: 'a85b2c0dd110e7d8c873de1fc178fdf9'
#        sid: 'gh_bf38044dd952'
#,
#    title: 'wt_menu'
#    value:
#        button: [
#
#            'name': '阅读'
#            'sub_button': [
#                'type': 'view'
#                'name': '首页'
#                'url': 'http://postenglishtime.com'
#            ,
#                'type': 'view'
#                'name': '活动'
#                'url': 'http://postenglishtime.com/eventList.html'
#            ,
#                'type': 'view'
#                'name': '文章'
#                'url': 'http://postenglishtime.com/postList.html'
#            ,
#                'type': 'view'
#                'name': '话题'
#                'url': 'http://postenglishtime.com/topicList.html'
#            ]
#        ,
#            'name': '活动'
#            'sub_button': [
#                'type': 'view'
#                'name': '主持人申请'
#                'url': 'http://postenglishtime.com/wechat.html#!/host'
#            ,
#                'type': 'view'
#                'name': '主持人反馈'
#                'url': 'http://postenglishtime.com/wechat.html#!/feedback'
#            ,
#                'type': 'view'
#                'name': '志愿者申请'
#                'url': 'http://postenglishtime.com/wechat.html#!/volunteer'
#            ,
#                'url': 'http://postenglishtime.com/wechat.html#!/myEvents'
#                'type': 'view'
#                'name': '我的活动'
#            ]
#        ,
#            'name': '圈子'
#            'sub_button': [
#                'type': 'view'
#                'name': 'CLUB'
#                'url': 'http://postenglishtime.com/wechat.html#!/club'
#            ,
#                'type': 'view'
#                'name': '个人信息'
#                'url': 'http://postenglishtime.com/wechat.html#!/profile/simple'
#            ,
#                'type': 'view'
#                'name': 'P.E.T.UP'
#                'url': 'http://postenglishtime.com/wechat.html#!/petupNow'
#            ]
#        ]
#]

module.exports =
    community:
        code: code
        name: 'PET后英语时代'
        resPath: if _env then '/res' else 'http://s.postenglishtime.com'
        url: if _env then 't.postenglishtime.com' else 'post.postenglishtime.com'

    data:
        'role:title': role
        'user:username': user
        'membership:uid,rid': membership
        'i18n:key': require('./zh')



