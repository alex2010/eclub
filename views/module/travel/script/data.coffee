adminRoleId = new oid()
adminUserId = new oid()

#menu->,page,entity

role = [
#    _id: adminRoleId
    title: 'admin'
    res:
        mgm:
            menu:
                site: 2
                data: 3
                userRole: 4
                file: 6
            entity:
                sight: 1
                show: 2
                food: 3
                handicraft: 4
                culture: 5
                map: 6
                car: 7
                guide: 8
                top: 9
                city: 10
                tour: 11
                content: 15
                post: 16
                head: 17
                cat: 18
                link: 19
        permission:
            page: 'console'
,
    title: 'guest'
    nav: [
        label: 'Top Choices'
        code: 'top'
        href: '/top'
    ,
        label: 'Attractions'
        href: '/itemList?entity=sight'
    ,
        label: 'Famous Food'
        href: '/itemList?entity=food'
    ,
        label: 'Beijing Shows'
        href: '/itemList?entity=show'
    ,
        label: 'Handicrafts'
        href: '/itemList?entity=handicraft'
    ,
        label: 'Chinese Culture'
        href: '/itemList?entity=culture'
    ,
        label: 'Cars & Guides'
        href: '/carList'
    ,
        label: 'Beijing Maps'
        href: '/itemList?entity=map'
    ,
        label: 'Tours'
        href: '/tour'
    ]
    foot: [
        label: 'About Us'
        href: '/content/about'
    ,
        label: 'Contact Us'
        href: '/content/contact'
    ,
        label: 'Privacy Policy'
        href: '/content/pp'
    ,
        label: 'Your Suggestion'
        href: '/content/ys'
    ]
]
user = [
    _id: adminUserId
    username: code
    password: 'psd'
]

membership = [
    uid: adminUserId
    rid: adminRoleId
]

sight = [
    title: 'Summer Palace'
    subTitle: 'at the very heart of Beijing'
    phone: '12233322'
    cat: 'unesco'
    address: 'sadfsd sdfsdfsadf'
    fee: 200
    route: 'sadfsd dsfdsfsdaf'
    lat: '100'
    lng: '200'
    row: 1009
    brief: 'Ringed by a 52m-wide moat at the very heart of Beijing, the Forb'
    content: "Ringed by a 52m-wide moat at the very heart of Beijing, the Forbidden City is China’s largest and best-preserved collectionm of ancient buildings, and the largest
palace complex in the world."
    opening: [

    ]
    refFile:
        slide: ['p1.jpg', 'p2.jpg']
        p1:
            title: 'Spring'
            description: 'amazing spring'
        p2:
            title: 'Summer'
            description: 'amazing Fall'
    info:
        openingHours: "17:00-18:00 19:00-21:00 (Monday)<br/> 17:00-18:00 19:00-21:00 (Tuesday)"
        address: "jhgjg"
        distance: "hjg"
        price: "sdfsdf"
        gettingThere: "hjgjh"
        englishMap: "sadfsadfasdf"
        travelTips: "jhghj"
        officialWebsite: 'www.sdfsdf.com'
        watchVideo: "sdfsdfa"
        lastUpdated: "jghg"
    extra: [
        title: 'Empress Dowsdf CiXi'
        content: 'Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably'
    ,
        title: 'Tai hou'
        content: 'Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably'
    ]
    sub: [
        title: 'RenShoudian'
        content: "asdfsdf sadfsdf'sdfsdfsadf"
    ,
        title: 'cixi'
        content: 'asdasdsads asd asdasdasdasd'
    ]
,
    title: 'great wall'
    subTitle: 'at the very heart of Beijing'
    phone: '1231231231'
    address: 'sdvxcvzcvcvxczv'
    row: 1008
    cat: 'museum'
    content: "de moat at the very heart of Beijing, the For"
    refFile:
        slide: ['p1.jpg', 'p2.jpg']
        p1:
            title: 'Spring'
            description: 'amazing spring'
        p2:
            title: 'Fall'
            description: 'amazing Fall'

    sub: [
        title: 'RenShoudian'
        content: "asdfsdf sadfsdf'sdfsdfsadf"
    ,
        title: 'cixi'
        content: 'asdasdsads asd asdasdasdasd'
    ]
]
city = [
    title: 'Beijing'
    description: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
]
post = [
    title: 'Travel rule'
    content: 'sdfsdfsdfdsfsdfsfdsf'
,
    title: 'Travel tip'
    content: 'sdfsdfsdzxcvcxv xzcvxzcv'
]

content = [
    title: '网站内容'
    content: '对方水电费水电费'
    brief: '121223'
,
    title: 'about us'
    content: '对方水电费水电费'
    brief: '121223'
]

cat = [
    title: 'UNESCO'
    code: 'unesco'
    type: 'sight'
    row: 100
,
    title: 'Great Wall'
    code: 'gw'
    type: 'sight'
    row: 90
,
    title: 'Museum'
    code: 'museum'
    type: 'sight'
    row: 80
,
    title: 'Temple'
    code: 'temple'
    type: 'sight'
    row: 70
,
    title: 'Park/Garden'
    code: 'park'
    type: 'sight'
    row: 60
,
    title: 'Historical'
    code: 'historical'
    type: 'sight'
    row: 50
,
    title: 'Free'
    code: 'free'
    type: 'sight'
    row: 40
,
    title: 'other'
    code: 'other'
    type: 'sight'
    row: 30
,


    title: 'Most Famous Food in Beijing'
    code: 'food'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    type: 'food'
,
    title: 'Private Cars'
    code: 'cg_car'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    type: 'cg'
,
    title: 'Private Guides'
    code: 'cg_guide'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    type: 'cg'
,
    title: 'City Highlight'
    code: 'tour_ch'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    type: 'tour'
,
    title: 'Great Wall'
    code: 'tour_gw'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    type: 'tour'
,
    title: 'depth Tour'
    code: 'tour_dt'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    type: 'tour'
,
    title: 'Jump in Tour'
    code: 'tour_jt'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    type: 'tour'
]


top = [
    title: 'Summer Place'
    subTitle: 'The Biggest indd sdfsdf sdf'
    refClass: 'sight'
    ref: 'vcxvsdfsdfsdf'
    refFile:
        head: ['p1.jpg']
,
    title: 'Beijing Duck'
    subTitle: 'The Biggest indd sdfsdf sdf'
    entity: 'food'
    id: 'vcxvsdfsdfsdf'
    refFile:
        head: ['p1.jpg']
,
    title: 'Zhongguo GongFu'
    subTitle: 'The Biggest indd sdfsdf sdf'
    entity: 'show'
    id: 'vcxvsdfsdfsdf'
    refFile:
        head: ['p1.jpg']
]
head = [
    type: 'top'
    list: [
        title: 'Summer Place'
        subTitle: 'The Biggest indd sdfsdf sdf'
        href: '/sight/xzcvxcvcv'
        refFile:
            head: ['p1.jpg']
            top: ['p1.jpg']
            list: ['p1.jpg']
    ,
        title: 'Summer Place'
        subTitle: 'The Biggest indd sdfsdf sdf'
        href: '/sight/xzcvxcvcv'
        refFile:
            head: ['p2.jpg']
            top: ['p2.jpg']
            list: ['p2.jpg']
    ]
,
    type: 'index'
    list: [
        title: 'Top Choices'
        subTitle: 'A collection of most-see orders in Beijing'
        cls: 'col-md-6'
        href: '/top'
    ,
        title: 'Attraction'
        subTitle: 'Majir scenic sights in Beijing'
        cls: 'col-md-3'
        href: '/itemList?entity=sight'
    ,
        title: 'Famous Food'
        subTitle: 'Popular food with locats'
        cls: 'col-md-3'
        href: '/itemList?entity=food'
    ,
        title: 'Beijing Shows'
        subTitle: 'A collection of most-see orders in Beijing'
        cls: 'col-md-3'
        href: '/itemList?entity=show'
    ,
        title: 'Handicrafts'
        subTitle: 'A collection of most-see orders in Beijing'
        cls: 'col-md-3'
        href: '/itemList?entity=handicraft'
    ]

]

food = [
    title: 'Beijing Roast Duck'
    subTitle: 'The Biggest sdfsdfsdf gorden in China'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    row: 1001
    restaurant: [
        title: 'da dong'
        content: 'agood'
        refFile:
            slide: ['p1.jpg']
            p1:
                title: 'da dong'
    ]

    refFile:
        slide: ['p1.jpg', 'p2.jpg']
        p1:
            title: 'Spring'
            description: 'amazing spring'
        p2:
            title: 'Summer'
            description: 'amazing Fall'
,
    title: 'Beijing Kaorou'
    subTitle: 'The Biggest sdfsdfsdf gorden in China'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    row: 1002
    refFile:
        slide: ['p1.jpg', 'p2.jpg']
        p1:
            title: 'Spring'
            description: 'amazing spring'
        p2:
            title: 'Summer'
            description: 'amazing Fall'
]
show = [
    title: 'Beijing GongFu'
    subTitle: 'The Biggest GongFu'
    content: "Underscore is a utility-belt library for JavaScript that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby), but without extending any of the built-in JavaScript objects. It's the tie to go along with jQuery's tux, and Backbone.js's suspenders. Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on. It delegates to built-in functions, if present, so modern browsers will use the native implementations of forEach, map, reduce, filter, every, some and indexOf."
    row: 1001
    theater: [
        title: 'Gong fu'
        content: 'agoodsdfasdfasdf'
        refFile:
            slide: ['p1.jpg']
            p1:
                title: 'da dong'
    ]
    refFile:
        slide: ['p1.jpg', 'p2.jpg']
        p1:
            title: 'Spring'
            description: 'amazing spring'
        p2:
            title: 'Summer'
            description: 'amazing Fall'
]

content = [
    code: 'sight'
    title: 'Sight in Beijing'
    content: 'The Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in China'
,
    code: 'show'
    title: 'Show in Beijing'
    content: 'The Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in China'
,
    code: 'food'
    title: 'food in Beijing'
    content: 'The Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in China'
,
    code: 'handicraft'
    title: 'handicraft in Beijing'
    content: 'The Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in China'
]
handicraft = [
    title: 'Jingju'
    subTitle: 'The Biggest sdfsdfsdf gorden in China'
,
    title: 'Jingju'
    subTitle: 'The Biggest sdfsdfsdf gorden in China'
]


car = [
    title: 'For travellers of 1-2 and max 3'
    description: 'gorden in ChinaThe Biggest sdfsdfsdf gorden in China The Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in China The Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggea'
    note: 'gorden in ChinaThe Biggest sdfsdfsdf gorden in China The Biggest sdfsdfsdf gorden in ChinaThe Biggest sdfsdfsdf gorden in ChinaThe Biggest sd'
    refFile:
        outsidePic: ['p1.jpg']
        insidePic: ['p2.jpg']
    guideFee: 40
    airport:[
        price: '50'
        from: 'Hotel'
        to: 'Airport'
        items:[
            title: 'pickup Time'
            startTime: '07:00'
            endTime: '22:00'
        ,
            title: 'loading Time'
            startTime: '07:00'
            endTime: '22:00'
        ]
    ,
        price: '70'
        from: 'Hotel'
        to: 'Airport'
        items:[
            title: 'pickup Time'
            startTime: '07:00'
            endTime: '22:00'
        ,
            title: 'loading Time'
            startTime: '07:00'
            endTime: '22:00'
        ]
    ]

    spot:[
        price: 180
        from: 'Hotel'
        to: 'Mutianyu'
    ,
        price: 300
        from: 'Hotel'
        to: 'Jinshanling'
    ]
#
#    arrangement: [
#        title: 'pickup Time'
#        cat: 'airport'
#        price: 50
#        from: 'Hotel'
#        to: 'Airport'
#        startTime: '07:00'
#        endTime: '22:00'
#    ,
#        title: 'Loading Time'
#        cat: 'airport'
#        price: 50
#        from: 'Hotel'
#        to: 'Airport'
#        startTime: '07:00'
#        endTime: '22:00'
#    ,
#        title: 'Loading Time'
#        cat: 'airport'
#        price: 60
#        from: 'Hotel'
#        to: 'Airport'
#        startTime: '07:00'
#        endTime: '22:00'
#    ,
#        title: 'pickup Time'
#        cat: 'airport'
#        price: 60
#        from: 'Hotel'
#        to: 'Airport'
#        startTime: '07:00'
#        endTime: '22:00'
#    ,
#        cat: 'greatwall'
#        price: 120
#        from: 'Hotel'
#        to: 'Badaling'
#    ,
#        cat: 'greatwall'
#        price: 180
#        from: 'Hotel'
#        to: 'Mutianyu'
#    ,
#        cat: 'greatwall'
#        price: 300
#        from: 'Hotel'
#        to: 'Jinshanling'
#    ]

]
module.exports =
    r: role[0]
    community:
        code: code
        name: 'travel in Beijing'
        resPath: if _env then '/res' else 'http://s.wikibeijing.com'
        url: if _env then 't.travel.com' else 'wikibeijing.com'
    data:
#        'role:title': role
#        'car:title': car
#        'user:username': user
#        'membership:uid,rid': membership
#
#        'post:title': post
#        'sight:title': sight
#        'city:title': city
#        'content:title': content
#
#        'cat:title': cat
#        'food:title': food
#        'show:title': food
#        'head:type': head
#        'top:title': top
        'i18n:key': require('./zh')

