<<<<<<< Updated upstream
#apply = [#申请elite team，异业联盟
#
#]
#
#order = [#预约，购买
#
#]
r = (file)->
    require "./data/#{file}"
=======
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
#储存分类 分类管理
    code: 'workShow'
    label: '作品展示'
    refClass: 'content'
    #type
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

content=[
    title:''
    cat:'workShow'
    row:1
    content:''
    refFile:
        head:[]
#6 ge
#dao xun
]


feedback = [
    cat: 'femaleClass'
    title: '1年的蜕变'
    content: '学堂太有货了'
]

service = [
    title: '色彩定位&测试诊断'
    cat: 'privateImageMgm'
    code: 'privateImageMgm_pp'
    content:'色彩学（color science）研究色彩产生、接受及其应用规律的科学。因形、色为物象与美术形象的两大要素，故色彩学为美术理论的首要的、基本的课题。它以光学为基础，并涉及心理物理学、生理学、心理学、美学与艺术理论等学科。色彩应用史上，装饰功能先于再现功能而出现。色彩学的研究在19世纪才开始，它以光学的发展为基础，牛顿的日光—棱镜折射实验和开普勒奠定的近代实验光学为色彩学提供了科学依据，而心理物理学解决了视觉机制对光的反映问题。'
    pubTime: new Date()
    refFile:
        head:['personal_pp_03.jpg']
    package: [
        title: '套餐一'
        description: '汉堡包＋鸡腿＋薯条'
        price: '100'
    ,
        title: '套餐二'
        description: '汉堡包＋鸡腿＋薯条'
        price: '110'
    ,
        title: '套餐三'
        description: '汉堡包＋鸡腿＋薯条'
        price: '120'
    ,
        title: '套餐四'
        description: '汉堡包＋鸡腿＋薯条'
        price: '130'
    ,
        title: '套餐五'
        description: '汉堡包＋鸡腿＋薯条'
        price: '140'
    ]
,
    title: '职场规划形象'
    cat: 'privateImageMgm'
    code:'privateImageMgm_sp'
    content:'要想打造出本身的个人风格，起首要在形象顾问的协助下对皮肤、边幅、体形、内涵气质进行对比、丈量和分析，领会到本身的优错误谬误，然后再针对这些细节去寻觅最合适的设计：服装用色、格式、质地、图案、鞋帽格式、饰品风格与质地、眼镜外形与材质、发型等。'
    pubTime: new Date()
    refFile:
        head:[]
    package: [
        title: '套餐一'
        description: '礼仪'
        price: '100'
    ,
        title: '套餐二'
        description: '汉堡包＋鸡腿＋薯条'
        price: '110'
    ,
        title: '套餐三'
        description: '汉堡包＋鸡腿＋薯条'
        price: '120'
    ,
        title: '套餐四'
        description: '汉堡包＋鸡腿＋薯条'
        price: '130'
    ,
        title: '套餐五'
        description: '汉堡包＋鸡腿＋薯条'
        price: '140'
    ]
,
    title:'企业形象定位一'
    cat:'entrepreneurImagePositioning'
    code:'entrepreneurImagePositioning_pp'
    content:''
    pubTime: new Date()
    refFile:
        head:[]
    package: [
        title: '套餐一'
        description: '汉堡包＋鸡腿＋薯条'
        price: '100'
    ,
        title: '套餐二'
        description: '汉堡包＋鸡腿＋薯条'
        price: '110'
    ,
        title: '套餐三'
        description: '汉堡包＋鸡腿＋薯条'
        price: '120'
    ,
        title: '套餐四'
        description: '汉堡包＋鸡腿＋薯条'
        price: '130'
    ,
        title: '套餐五'
        description: '汉堡包＋鸡腿＋薯条'
        price: '140'
    ]
,
    title:'明星立体包装一'
    cat:'actorSolidPackaging'
    code:'actorSolidPackaging_pp'
    content:''
    pubTime: new Date()
    refFile:
        head:[]
    package: [
        title: '套餐一'
        description: '造型＋化妆'
        price: '100'
    ,
        title: '套餐二'
        description: '造型＋化妆'
        price: '110'
    ,
        title: '套餐三'
        description: '造型＋化妆'
        price: '120'
    ,
        title: '套餐四'
        description: '造型＋化妆＋薯条'
        price: '130'
    ,
        title: '套餐五'
        description: '造型＋化妆'
        price: '140'
    ]
,
    title:'新娘形象定制一'
    cat:'designOfTheBrideImage'
    code:'designOfTheBrideImage_pp'
    content:''
    pubTime: new Date()
    refFile:
        head:[]
    package: [
        title: '套餐一'
        description: '婚礼＋庆典＋喜宴'
        price: '100'
    ,
        title: '套餐二'
        description: '婚礼＋庆典＋喜宴'
        price: '110'
    ,
        title: '套餐三'
        description: '婚礼＋庆典＋喜宴'
        price: '120'
    ,
        title: '套餐四'
        description: '婚礼＋庆典＋喜宴'
        price: '130'
    ,
        title: '套餐五'
        description: '婚礼＋庆典＋喜宴'
        price: '140'
    ]
,
    title:'体验式服务'
    cat:'intro'
    code:''
    refFile:
        head:['head_server_intro_03.jpg']
    description:[
        title:'坊间形象托管服务特点'
        description:'国际专业水准个人形象设计机构，从准确定位开始，突出个性特质—个人专属STYLE，服务特质—量身定制&尊贵体验，综合特质—360°打造您的魅力颜值。'
    ,
        title:'坊间形象托管服务宗旨'
        description:'一站式形象托管，以目的为导向，高效—专业—细节的管家式服务，以及“线上线下课程 & 活动 & VIP服务 ”的模式，帮你解决由于外表形象等方面所带来的困惑。'
    ]
    content:
        privateImageMgm:
            title:'私人形象托管'
            titleEn:'Private Image Management'
            subtitle:[
                ' 一个人的形象，就是自我的一张名片'
            ,
                '没人有义务透过你都不在意的邋遢外表，去发现你优秀的内在'
            ]
            refFile:
                head:['']
                poster:['']
        entrepreneurImagePositioning:
            title:'明星立体包装'
            titleEn:'Actor Solid Packaging'
            subtitle:[
                '明星包装策略&精准形象定位'
            ,
                '漂亮外形＋得体服饰 ＋举止优雅＋ 言谈得体＝公众心目中的关注率'
            ]
            refFile:
                head:['adv-service_13.jpg']
                poster:[]
        actorSolidPackaging:
            title:'企业形象定位'
            titleEn:'Entrepreneur image positioning'
            subtitle:[
                '企业家成功个人品牌的影响力+企业品牌形象=企业的核心竞争力'
            ,
                '企业家的个人品牌打造标志着企业品牌打造的战略高度'
            ]
            refFile:
                head:['adv-service_10.jpg']
                poster:['']
        designOfTheBrideImage:
            title:'新娘形象定制'
            titleEn:'Design Of The Bride\'s Image'
            subtitle:[
                '优蔻坊体验店旗下的女子学堂'
            ,
                '遇见美丽，掌控幸福，让生命从此绽放'
            ]
            refFile:
                head:['adv-service_20.jpg']
                poster:['']
]


course = [
    title: ''
    description: ''
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
    title:''
    row:1
    content:''
    cat:''
    postcode:'' #地区
    address:''
    phone:111
    owner:''
]

qa = [#首页
    question: '为什么不好看'
    answer: '因为不会打扮'
,
    question: '为什么不好看2'
    answer: '因为不会打扮2'
,
    question:'问题三'
    answer:'回答三'
,
    question:'问题四'
    answer:'回答四'
,
    question:'问题五'
    answer:'回答五'
]
>>>>>>> Stashed changes




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
            cur: 'index'
            labelCls: "label-info"
        ,
            label: "体验式服务"
            href: "/serviceChannel"
            cur: 'serviceChannel'
            labelCls: "label-exper"
        ,
            label: "精英培训学院"
            href: "/courseChannel"
            cur: 'courseChannel'
            labelCls: "label-warning"
        ,
            label: "女子学堂"
            href: "/schoolChannel"
            cur: 'schoolChannel'
            labelCls: "label-success"
        ,
            label: "精英团队"
            href: "/teamChannel"
            cur: 'teamChannel'
            labelCls: "label-team"
        ,
            label: "异业联盟"
            href: "/partnerChannel"
            cur: 'partnerChannel'
            labelCls: "label-danger"
        ]

    data:
        'i18n:key': require('./zh')
        'content:title':r 'content'
        'partner:title':r 'partner'
        'cat:code':r 'cat'
        'video:title':r 'video'
        'head:type':r 'head'
        'role:title': r 'role'
        'user:username': r 'user'
        'post:title': r 'post'
        'course:title':r 'course'
        'qa:question': r 'qa'
        'service:title': r 'service'
        'cat:code': r 'cat'
        'course:title': r 'course'
        'pubAccount:code': r 'pubAccount'

    member: [
        "#{code},admin"
    ]
