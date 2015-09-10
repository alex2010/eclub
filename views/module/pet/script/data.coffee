role = [
    title: 'admin'
    label: '管理员'
    type: 0
    res:
        menu:
            site: 2
            data: 3
            wechat: 4
            tmpl: 5
            file: 6
            userRole: 7

        entities:
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
    title: 'user'
    label: '登录用户'
    type: 0
    res:
        menu: [
            label: '个人信息'
            icon: 'user'
            href: '#!/club/profile'
            row: 30
        ,
            label: '检索用户'
            icon: 'search'
            href: '#!/search'
            row: 20
        ,
            label: '供需信息'
            icon: 'gift'
            href: '#!/ds'
            row: 40
        ,
            label: '我的文章'
            icon: 'file'
            href: '#!/data/list/post'
            row: 50
        ,
            label: '我的活动'
            icon: 'th-large'
            href: '#!/data/list/activity'
            row: 60
        ]
]

user = [
    username: code
    password: 'psd'
,
    username: 'u' + code
    password: 'psd'
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
            children: [
                label: '英语角'
            ,
                label: '工作坊'
            ,
                label: '旅行分享'
            ,
                label: '周末趴'
            ,
                label: '户外'
            ]
        ,
            label: '文章'
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
                label: '格调'
                href: '/postList?cat=life'
            ,
                label: '成长'
                href: '/postList?cat=growing'
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

    data:
        'role:title': role
        'user:username': user
        'i18n:key': require('./zh')

    member: [
        "#{code},admin"
        "u#{code},user"
    ]




