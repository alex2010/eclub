_i = {}
module.exports =  (langs = {})->
    @_i = _i = langs
    _.extend @, require '../ext/i18n'
    @


#    @cat = (k)->
#        @_i['cat.' + k]
#
#    @p = (k, m...) ->
#        res = @_i[k]
#        if _.isString(res) and m.length
#            if res and res.indexOf('{') > -1
#                for it in m
#                    res = res.substring(0, res.indexOf('{')) + it + res.substring(res.indexOf('}') + 1)
#                if _.isString(res)
#                    res = res.replace(new RegExp("{", "gm"), '').replace(new RegExp("}", "gm"), '')
#        res
#    @m = (k, m...) ->
#        if m.length
#            arguments[0] = 'm.' + k
#            @p.apply @, arguments
#        else
#            @_i['m.' + k]
#
#    @e = (k, p) ->
#        @_i[k + '.' + p] || @_i(p)
#
#    @c = (p) ->
#        @_i['c.' + p] || p
#
#    @n = (p) ->
#        @_i['nav.' + p] || @_i('c.' + p) || @_i(p) || p
#
#    @load = (code)->
#
#    @
