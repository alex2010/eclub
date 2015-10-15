role = [
    title: 'admin'
    label: '管理员'
    type: 0
    entities: [
        key: '_biz'
        row: 101
    ,
        key: 'activity'
        row: 110
    ,
        key: 'thread'
        row: 120
    ,
        key: 'topic'
        row: 130
    ,
        key: 'venue'
        row: 140
    ]
,
    title: 'user'
    label: '登录用户'
    type: 0
    menu: [
        label: '朋友圈'
        icon: 'search'
        href: '#!/club'
        row: 10
    ,
        label: '活动管理'
        icon: 'th-large'
        href: '#!/act'
        row: 20
    ,
        label: '文章管理'
        icon: 'file'
        href: '#!/post'
        row: 30
    ,

        label: 'PET论坛'
        icon: 'gift'
        href: '#!/thread'
        row: 40
    ]
    permission: ['wechat']
]

user = [
    username: code
,
    username: 'u' + code
]
group = [
    title: 'Tyler运动分享社'
    leader:
        _id: 'dd'
        username: 'Tyler'
    manifesto: '不吃饭多运动'
    description: '，Node.js的出现也使持续十年的云端一体梦想终于成真。 在所有App都努力迈向全实时能力的当下，移动App的研发也愈发需要性能和功能更强的新型开发框架作为强大的技术后盾。'
]
module.exports =
    community:
        code: code
        name: 'PET后英语时代'
        resPath: if _env then '/res' else 'http://s.postenglishtime.com'
        url: if _env then 't.postenglishtime.com' else 'postenglishtime.com'
        nav: [
            label: '活动'
            href: '/activityList'
#            children: [
#                label: '英语角'
#                href: '/activityList?cat=salon'
#            ,
#                label: '工作坊'
#                href: '/activityList?cat=workshop'
#
#            ,
#                label: '旅行分享'
#                href: '/activityList?cat=petup'
#
#            ,
#                label: '周末趴'
#                href: '/activityList?cat=party'
#            ,
#                label: '户外'
#                href: '/activityList?cat=outdoor'
#            ]
        ,
            label: '文章'
            href: '/postList'
#            children: [
#                label: '英文'
#                href: '/postList?cat=en'
#            ,
#                label: '情感'
#                href: '/postList?cat=love'
#            ,
#                label: '旅行'
#                href: '/postList?cat=travel'
#            ,
#                label: '健身'
#                href: '/postList?cat=fitness'
#            ,
#                label: '职场'
#                href: '/postList?cat=work'
#            ,
#                label: '格调'
#                href: '/postList?cat=life'
#            ,
#                label: '成长'
#                href: '/postList?cat=growing'
#            ]
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

    data:
        'role:title': role
        'group:title': group

#        'user:username': user
#        'i18n:key': require('./zh')
#
#    member: [
#        "#{code},admin"
#        "u#{code},user"
#    ]




