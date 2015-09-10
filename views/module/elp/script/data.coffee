role = [
    title: 'admin'
    label: '管理员'
    type: 0
    res:
        menu:
            site: 2
            data: 3
            wechat: 4
            userRole: 7

        entity:
            activity: 1
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
,
    title: 'manager'
    label: 'p班级管理员'
    type: 0
    res:
        menu:[
            icon: 'education'
            label: '班级信息'
            href: '#!/pClass'
            row: 65
        ]
        permission:
            page: 'wechat'

,
    title: 'member'
    label: 'p成员'
    type: 0
    res:
        menu: [
            icon: 'blackboard'
            label: '活动'
            href: '#!/list/activity'
            row: 20
        ,
            icon: 'tree-deciduous'
            label: '项目'
            href: '#!/list/project'
            row: 30
        ,
            icon: 'gift'
            label: '供需'
            href: '#!/list/ds'
            row: 40
        ,
            icon: 'search'
            label: '家人'
            href: '/search'
            row: 50
        ,
            icon: 'file'
            label: '文章'
            href: '#!/list/post'
            row: 60
        ,
            icon: 'user'
            label: '个人信息'
            href: '#!/profile'
            row: 70
        ]
        permission:
            page: 'wechat'
]

user = [
    username: code
    password: 'psd'
,
    username: '王磊'
    password: 'psd'
    phone: '15810263968'
    email: 'alexwl2008@gmail.com'
    gender: true
    pClass: 'elp8'
    vow: '我是一个负责任，包容，担当的男人，我承诺创造一个积极，喜悦，充满爱的世界'
    emo: '黄凯波'
    praiseMusic: 'I believe I can fly'
    exp: [
        pClass: 'elp14'
        role: '教练'
        praiseMusic: '一首简单的歌'
    ]
    ds: [
        cat: '找活干'
        give: '提供网站，微信，app完美结合的信息化管理平台的开发与服务'
        get: '可定制的网站/微信系统的项目开发机会'
        result: '建立长期的合作关系'
        case: '项目1，项目2'
    ]
,
    username: '王珮'
    password: 'psd'
    phone: '123'
    gender: false
    pClass: 'elp8'
]
org = [
    title: 'elp8'
    teamMusic: '奔跑'
    manifesto: '我为世界创精彩,世界因我而改变'
    timeline: [
        title: '初级课'
        count: '150'
        startDate: ''
        endDate: ''
    ,
        title: '深进课'
        count: '62'
        startDate: ''
        endDate: ''
    ,
        title: 'ELP'
        count: '50'
        startDate: ''
        endDate: ''
    ]
    coachTeam: [
        username: '王丽华'
        pClass: 'elp2'
        role: '总教练'
    ,
        username: '许永进'
        pClass: 'ts'
        role: '团长'
    ,
        username: '周飞乐'
        pClass: 'elp4'
        role: '教练'
    ]
]

roleMap = [
    role: 'manager,member'
    code: 'mmp'
    description: 'p班级管理员'
,
    role: 'member'
    code: 'elp88'
    description: 'p成员'
]

pubAccount = [
    'appId': 'wx2867dd2c8647a5c5'
    'code': 'ELPfamily'
    'secret': '082e424ee09418e49d2042618ba2d657'
    'sid': 'gh_3f4991b2e4e3'
    'status': 1
    'title': 'p家族'
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
                'url': 'http://elp.postenglishtime.com/wechat#!/user'
                'name': '我的信息'
            ,
                'url': 'http://elp.postenglishtime.com/wechat#!/search'
                'type': 'view'
                'name': '查询P成员'
            ]
        ,
            'type': 'view'
            'name': '供需交流'
            'url': 'http://elp.postenglishtime.com/wechat#!/sd'
        ]
]

module.exports =
    community:
        code: code
        name: 'P家族'
        resPath: if _env then '/res' else 'http://s.postenglishtime.com'
        url: if _env then 't.elp.com' else 'elp.postenglishtime.com'

    data:
        'role:title': role
        'user:username': user
        'roleMap:role': roleMap
        'org:title': org
        'pubAccount:appId': pubAccount
        'i18n:key': require('./zh')

    member:[
        "#{code},admin"
        "王磊,member"
        "王磊,manager"
    ]