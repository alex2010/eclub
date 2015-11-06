role = [
    title: 'admin'
    label: '管理员'
    type: 0
    entities: [
        key: '_biz'
        row: 101
    ,
        key: 'service'
        row: 110
    ,
        key: 'course'
        row: 120
    ,
        key: 'partner'
        row: 130
    ,
        key: 'qa'
        row: 140
    ]
]

r = (file)->
    require "./data/#{file}"

module.exports =
    community:
        code: code
        name: '恋爱能量'
        title: '恋爱能量'
        resPath: if _env then '/res' else 'http://s.postenglishtime.com'
        url: if _env then 't.moka.com' else 'moka.postenglishtime.com'
        nav: [
            label: '首页'
            href: '/'
            children: []
        ,
            label: '恋爱课程'
            href: '/courseChannel'
            children: [
                label: '恋爱基础'
                href: 'courseChannel?cat=foundation'
            ,
                label: 'VIP系统课'
                href: 'courseChannel?cat=vip'
            ,
                label: '线下特训'
                href: 'courseChannel?cat=offline'
            ]
        ,
            label: '特色服务'
            href: '/serverChannel'
            children: []
        ,
            label: '官方论坛'
            href: '/forum'
            children: []
        ,
            label: '关于我们'
            href: '/about'
            children: []
        ]
    data:
        'i18n:key': require('./zh')
        'user:username': r 'user'
        'role:title': role

        'content:title': r 'content'
        'post:title': r 'post'


    member: [
        "#{code},admin"
        "u#{code},user"
    ]