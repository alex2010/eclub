#_i = {}
module.exports =  (langs)->
    @_i = langs
    _.extend @, require '../public/ext/i18n'
    @
