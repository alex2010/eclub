user = [
    username: code
,
    username: 'u' + code
]

r = (file)->
    require "./data/#{file}"

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
        ,
            label: '小组'
            href: '/groupList'
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
        'role:title': r 'role'
        'group:title': r 'group'

#        'user:username': user
#        'i18n:key': require('./zh')
#
#    member: [
#        "#{code},admin"
#        "u#{code},user"
#    ]




