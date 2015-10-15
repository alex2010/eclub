role = [
    title: 'admin'
    label: '管理员'
    type: 0
    entities: [
        key: '_biz'
        row: 101
    ,
        key: 'brand'
        row: 110
    ,
        key: 'product'
        row: 120
    ,
        key: 'shop'
        row: 130
    ,
        key: 'consultant'
        row: 140
    ]
,
    title: 'manager'
    label: '店长'
    type: 0
    menu: [
        "label": "店铺信息"
        "icon": "gift"
        "href": "#!/home/shop"
        "row": 10
    ,
        "label": "验配师信息"
        "icon": "leaf"
        "href": "#!/home/consultant"
        "row": 20
    ,
        "label": "预约管理"
        "icon": "calendar"
        "href": "#!/home/order"
        "row": 30
    ]
    permission: ['wechat']
,
    title: 'member'
    label: '眼配师'
    type: 0
    permission: ['wechat']
]

user = [
    username: code
,
    username: 'u' + code
,
    username: 'yps'
,
    username: 'dz'
]
pubAccount = [
    'appId': 'wx41872ec02d39aaf9'
    'code': 'EAR_Helper'
    'secret': '311865aa02a783a1d10034d423a4c371'
    'sid': 'gh_c212471406a7'
    'status': 1
    'title': '掌上听力专家'
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
                'url': 'http://elp.newenglishtime.com/wechat#!/profile'
                'name': '我的信息'
            ,
                'url': 'http://elp.newenglishtime.com/search'
                'type': 'view'
                'name': '查询P成员'
            ]
        ,
            'type': 'view'
            'name': '供需交流'
            'url': 'http://url.com/wechat.html#!/sd'
        ]
]
bid = new oid()
brand = [
    '_id': bid
    'refFile':
        'logo': ['nti34k3he.jpg']
    'title': '优利康 Unitron'
    'origin': '加拿大'
    'description': '优利康听力总部位于加拿大的安大略省，凯基纳市。业务遍及加拿大，美国，德国和全球的经销商网络。公司员工550人，为全世界70多个国家的客户服务。五十多年来，优利康听力一直致力于使听障人士生活的更加美好。这意味着肩负发展听力解决方案的使命，解决每天可能发生的不同问题，始终关注有听力损失和佩戴助听器的人群。 \n    在1999年和2000年，加拿大的优利康工业公司与美国的Argosy听力公司，Lori医学实验室合并；2001年优利康听力作为一个全新的公司品牌诞生。为了支持新机构的容量和把握好未来的方向，优利康听力不断加强研究和活跃开发的领域，进行室内研究，与世界著名的大学和研究室的科学家和工程师合作，共同开发新的领先科技的听力研究方案。我们全面的数字型助听器流水线就从一个重要的方面表明了，我们正在成长为，能够提供给各类听障人士高质、高效的听力解决方案的重要角色。'
    'dateCreated': '2015-07-08T15:57:06.855Z'
    'lastUpdated': new Date()
]

pid = new oid()
product = [
    '_id': pid
    'pubTime': new Date()
    'refFile':
        'slide': ['vy58qfxje.jpg']
        'vy58qfxje':
            'pubTime': '2014-02-08 12:00:00'
            'description': '该产品拥有以下性能：智能降噪，方向性功能，言语提升技术，反馈消除技术，环境自适应功能，多信号处理模式，双耳电话功能，双耳程序音量同步，双耳自适应功能，风噪声管理功能，突发噪声控制，可匹配遥控器，移频技术。产品64通道信号处理，20通道可调，其验配范围是≤120dB。'
            'row': '4'
            'title': '芭蕾·梦90-SP Bolero Q90-SP'
    'title': '芭蕾·梦90-SP Bolero Q90-SP'
    'brand':
        '_id': bid
        'title': '峰力 Phonak'
        'origin': '瑞士'
    'price': '40900'
    'performance': '智能降噪,方向性功能,言语提升技术,反馈消除技术,环境自适应功能,多信号处理模式,双耳电话功能,双耳程序音量同步,双耳自适应功能,风噪声管理功能,突发噪声控制,可匹配遥控器,移频技术'
    'channel': 20
    'warranty': '五年'
    'description': '该产品拥有以下性能：智能降噪，方向性功能，言语提升技术，反馈消除技术，环境自适应功能，多信号处理模式，双耳电话功能，双耳程序音量同步，双耳自适应功能，风噪声管理功能，突发噪声控制，可匹配遥控器，移频技术。产品64通道信号处理，20通道可调，其验配范围是≤120dB。'
    'outline': '耳背式'
    'frequency': ''
    'level': '五星'
]

seckilling = [
    title: '秒杀天价助听器123'
    startedDate: new Date()
    endDate: new Date().addDays(20)
    description: '跨终端Web技术旨在解决普通Web页面在移动终端上展示时面临的屏幕尺寸、处理能力、软件兼容性等方面的问题。本课程按照“基准—检测—接口—定位—预览”的流程讲解，思路清晰，逻辑明了。讲解过程，采用数据与案例，有章可循，渲染十足，是不可多得的学习宝典。'
    product: [
        _id: pid
        title: '芭蕾·梦90-SP Bolero Q90-SP'
        price: 40900
        description: '商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述商品描述'
        refFile:
            head: ['']
            slide: []
        evaluation: [
            'aaa111'
        ,
            'bbb222'
        ,
            'ccc333'
        ]
        contact: 13870894526
    ]
    price: 12000
    discount: 8
    origin: '中国'
    surplus: 10
]

cid = new oid()
card = [
    _id: cid
    title: 'X中心优惠卡券'
    description: '优利康听力总部位于加拿大的安大略省，凯基纳市。业务遍及加拿大，美国，德国和全球的经销商网络。公司员工550人，为全世界70多个国家的客户服务。五十多年来，优利康听力一直致力于使'
    startedDate: new Date()
    endDate: new Date().addDays(20)
    price: 500
    refFile:
        head: []
        slide: []
    condition: [
        '五环路'
    ,
        '四环路'
    ,
        '三环路'
    ]
    tip: '这是一个提示，Xman要来了'
]

module.exports =
    community:
        code: code
        name: '掌上听力专家'
        resPath: if _env then '/res' else 'http://s.postenglishtime.com'
        url: if _env then 't.ear.com' else 'ear.postenglishtime.com'
        nav: [
            'label': '首页'
            'href': '/'
        ,
            'label': '听力健康'
            'href': '/itemList?entity=health'
            'children': [
                'label': '听力知识'
                'href': '/itemList?entity=health'
            ,
                'label': '康复知识'
                'href': '/itemList?entity=health'
            ,
                'label': '助听器'
                'href': '/itemList?entity=health'
            ]
        ,
            'label': '互动论坛'
            'href': '/itemList?entity=forum'
            'children': [
                'label': '验配师论坛'
                'href': '/itemList?entity=forum'
            ,
                'label': '消费者论坛'
                'href': '/itemList?entity=forum'
            ,
                'label': '二手助听器论坛'
                'href': '/itemList?entity=forum'
            ]
        ,
            'label': '聆听秒杀'
            'href': '/seckillingList'
            'refClass': '0'
            'tip': ''
            'cls': ''
            'icon': ''
        ,
            'label': '聆听卡券'
            'href': '/cardList'
            'refClass': '0'
            'tip': ''
            'cls': ''
            'icon': ''
        ,
            'label': '听障问诊'
            'href': '/inquiry'
            'refClass': '0'
            'tip': ''
            'cls': ''
            'icon': ''
            'children': [
                'href': '#!/apply/inquiry'
                'label': '我要咨询'
                'refClass': '0'
                'tip': ''
                'cls': ''
                'icon': ''
                'id': '1sh3y'
            ,
                'href': '#!/apply/order'
                'label': '我要预约'
                'refClass': '0'
                'tip': ''
                'cls': ''
                'icon': ''
                'id': '9lwjx'
            ]
        ]
        'foot': [
            'label': '广告服务'
            'href': '/content/about'
        ,
            'label': '联系我们'
            'href': '/content/contact'
        ,
            'label': '免责声明'
            'href': '/content/pp'
        ]
    data:
        'role:title': role
#        'user:username': user
#        'pubAccount:appId': pubAccount
#        'brand:title': brand
#        'product:title': product
        'seckilling:title': seckilling
#        'i18n:key': require('./zh')
        'card:title':card

#    member: [
#        "#{code},admin"
#        "u#{code},user"
#        "yps,member"
#        "dz,manager"
#    ]