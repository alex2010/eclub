#_i = {}
module.exports =  (langs)->
    @_i = langs
    _.extend @, require '../public/lib/i18n'
    @
