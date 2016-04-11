module.exports =

    iCat: (k)->
        _i['cat_' + k]

    si: (k)->
        _i[k]

    ii: (k, m...) ->
        return '' unless k
        if _i[k] and res = _i[k] # res # and _.isString res
            if res and res.indexOf('{') > -1
                for it in m
                    res = res.substring(0, res.indexOf('{')) + it + res.substring(res.indexOf('}') + 1)
                if _.isString(res)
                    res = res.replace(new RegExp("{", "gm"), '').replace(new RegExp("}", "gm"), '')
            return res
        else
#            if k.indexOf('.') > -1
#                k = k.split('.')[1]
            if k.indexOf('::') > -1
                k = k.split('::')[1]
            log k
            return k.capAll()

    iim: (k, m...) ->
        if m
            pm = []
            for it in m
                pm.push if util.isChinese(it)
                    it
                else
                    ii(it)
        ii(k, pm)

    iie: (k, p) ->
        _i[k + '_' + p] || _i[p] || p.capAll()

    iic: (p) ->
        _i[p] || p.capAll()

    iin: (p) ->
        if p
            return _i[p] || p.capAll()
