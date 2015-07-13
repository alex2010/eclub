module.exports =

    iCat: (k)->
        _i['cat.' + k]

    si:(k)->
        _i[k]

    ii: (k, m...) ->
        if _i[k] and res = _i[k] # res # and _.isString res
            if res and res.indexOf('{') > -1
                for it in m
                    res = res.substring(0, res.indexOf('{')) + it + res.substring(res.indexOf('}') + 1)
                if _.isString(res)
                    res = res.replace(new RegExp("{", "gm"), '').replace(new RegExp("}", "gm"), '')
            return res
        else
            if k.indexOf('.') > -1
                k = k.split('.')[1]
            if k.indexOf('::') > -1
                k = k.split('::')[1]
            return k.capAll()
    iim: (k, m...) ->
        ii('m.' + k, iin(it) for it in m)

    iie: (k, p) ->
        _i[p] || _i[k+'.'+p] || _i['c.'+p] || p.capAll()

    iic: (p) ->
        _i[p] || ii('c.' + p)

    iin: (p) ->
        _i[p] || ii('nav.' + p)
