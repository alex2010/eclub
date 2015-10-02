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
,
    title: ''
    label: '精英培训师'
,
    title: ''
    label: '精英团队'
    #单页显示
,
    title: ''
    label: '异业联盟'
,
    title: ''
    label: '学员'
    #学院风采
,
    title: ''
    label: '客户'
,
    title: ''
    label: 'Vip客户'
,
    title: 'user'
    label: '用户'
]

user = [
    username: code
    password: 'bk9ULZCWUd81eZ0vOIjLuqDvozllFEWBKM7QTiy85NI='
]

cat = [
    code: 'workShow'
    label: '作品展示'
    refClass: 'post'
,
    code: 'pp'
    label: '定位流程'
    refClass: 'post'
,
    code: 'femaleClass'
    label: '女子学堂'
    refClass: 'feedback'
,
    code: 'beauty'
    label: '美容'
    refClass: 'partner'
]

feedback = [
    cat: 'femaleClass'
    title: '1年的蜕变'
    content: '学堂太有货了'
]

service = [
    title: ''
    cat: 'privateImageMgm'
    content: ''
    package: [
        title: ''
        description: ''
        price: ''
    ]
]

course = [
    title: ''
    content: ''
    itemsTable:[
        title:'收费标准'
        content: '90天课程，收费8990'
    ]
    price:9000
    discount: 8000
    phases: [

    ]
]

apply = [ #申请elite team，异业联盟

]

order = [ #预约，购买

]


partner = [#异业联盟 cat=>footer下的数据

]

qa = [#首页
    question: '为什么不好看'
    answer: '因为不会打扮'
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
        ]

    data:
        'role:title': role
        'user:username': user
        'i18n:key': require('./zh')

    member: [
        "#{code},admin"
    ]