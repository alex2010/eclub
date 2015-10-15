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
        key: 'ds'
        row: 120
    ,
        key: 'project'
        row: 130
    ]
,
    title: 'manager'
    label: 'p班级管理员'
    type: 0
    menu: [
        key: 'pClass'
        icon: 'education'
        href: '#!/club/edit/pClass'
        row: 65
    ]
    permission:['wechat']

,
    title: 'member'
    label: 'p成员'
    type: 0
    menu: [
        key: 'activity'
        icon: 'blackboard'
        label: '活动'
        href: '#!/act'
        row: 20
    ,
        key: 'search'
        icon: 'search'
        label: '家人'
        href: '#!/club'
        row: 30
    ,
        key: 'ds'
        icon: 'gift'
        label: '供需'
        href: '#!/ds'
        row: 40
    ,
        key: 'project'
        icon: 'tree-deciduous'
        label: '项目'
        href: '#!/project'
        row: 50
    ,
        key: 'post'
        icon: 'file'
        label: '文章'
        href: '#!/post'
        row: 60
    ]
    permission: ['wechat']
]

user = [
    username: code
,
    username: '王磊'
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

group = [
    title: '创富组'
    leader:
        _id: 'dd'
        username: '霄红'
    manifesto: '好好睡觉 天天数钱'
    description: '，Node.js的出现也使持续十年的云端一体梦想终于成真。 在所有App都努力迈向全实时能力的当下，移动App的研发也愈发需要性能和功能更强的新型开发框架作为强大的技术后盾。'
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
        'group:title': group
#        'user:username': user
#        'roleMap:role': roleMap
#        'org:title': org
#        'pubAccount:appId': pubAccount
#        'i18n:key': require('./zh')
#
#    member: [
#        "#{code},admin"
#        "王磊,member"
#        "王磊,manager"
#    ]