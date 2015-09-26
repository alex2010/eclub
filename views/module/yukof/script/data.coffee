role = [
    title: 'admin'
    type: 0
    res:
        menu:
            site: 2
            data: 3
            wechat: 4
            userRole: 7

        entities:
            post: 3
            content: 4
            comment: 5
            application: 6
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
    username: code
    password: 'bk9ULZCWUd81eZ0vOIjLuqDvozllFEWBKM7QTiy85NI='
]


module.exports =
    community:
        code: code
        name: '优寇坊'
        title: '优寇坊'
        resPath: if _env then '/res' else 'http://s.postenglishtime.com'
        url: if _env then 't.yukof.com' else 'yukof.postenglishtime.com'
        nav: [
            label: "首页"
            href: "/"
            labelCls: "label-info"
        ,
            label: "体验式服务"
            href: "/"
            labelCls: "label-exper"
        ,
            label: "精英培训学院"
            href: "/"
            labelCls: "label-warning"
        ,
            label: "女子学堂"
            href: "/"
            labelCls: "label-success"
        ,
            label: "精英团队"
            href: "/"
            labelCls: "label-team"
        ,
            label: "异业联盟"
            href: "/"
            labelCls: "label-danger"
        ,
            label: "优寇美联盟",
            href: "/",
            labelCls: "label-primary"
        ]

    data:
        'role:title': role
        'user:username': user
        'i18n:key': require('./zh')

    member: [
        "#{code},admin"
    ]