#apply = [#申请elite team，异业联盟
#
#]
#
#order = [#预约，购买
#
#]
r = (file)->
    require "./data/#{file}"

module.exports =
    community:
        code: code
        name: '优寇坊'
        title: '优寇坊'
        resPath: if app.env then '/res' else 'http://s.postenglishtime.com'
        url: if app.env then 't.yukof.com' else 'yukof.postenglishtime.com'
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

#    data:
#        'i18n:key': require('./zh')
#        'content:title':r 'content'
#        'partner:title':r 'partner'
#        'cat:code':r 'cat'
#        'video:title':r 'video'
#        'head:type':r 'head'
#        'role:title': r 'role'
#        'user:username': r 'user'
#        'post:title': r 'post'
#        'course:title':r 'course'
#        'qa:question': r 'qa'
#        'service:title': r 'service'
#        'cat:code': r 'cat'
#        'course:title': r 'course'
#        'pubAccount:code': r 'pubAccount'

#    member: [
#        "#{code},admin"
#    ]
