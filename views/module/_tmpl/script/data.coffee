r = (file)->
    require "./data/#{file}"

module.exports =
    community:
        code: code
        name: '心路明'
        resPath: if _env then '/res' else 'http://s.postenglishtime.com'
        url: if _env then 't.xlm.com' else 'yukof.postenglishtime.com'
        nav: [
            label: "首页"
            href: "/"
            cur: 'index'
            labelCls: "label-info"
        ]
    data:
        'course:title': r 'course'
        'project:title': r 'project'
        'startup:title': r 'title'
        'team:title': r 'title'

        'market:title': r 'title'
        'house:title': r 'title'
        'furniture:title': r 'title'
        'device:title': r 'title'
        'staff:title': r 'title'

        'campaign:title': r 'title'