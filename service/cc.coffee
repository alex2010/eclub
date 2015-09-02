class cc
    ctx: {}

    constructor: ->

    pick: (key, run, load)->
        if @ctx[key]
            run(@ctx[key])
        else if load
            load(run, @ctx)
        else
            log 'no item and run'

    del: (key)->
        delete ctx[key]

module.exports = cc