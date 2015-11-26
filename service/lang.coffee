#_i = {}
module.exports =  (langs)->
    @_i = langs
    _.extend @, require '../ext/i18n'
    @
