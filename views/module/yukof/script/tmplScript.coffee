module.exports =
    _init: (ctx)->

    serviceContent:(ctx,req,rsp) ->
        privateImageMgm_pp:(cb) ->
            opt =
                limit:10
                sort:
                    row:-1
            filter={
                code:'privateImageMgm_pp'
            }
            dao.find ctx.c.code, 'service' , filter, opt, (res)->
                cb(null, res)


        privateImageMgm_sp:(cb) ->
            opt =
                limit:10
                sort:
                    row:-1
            filter={
                code:'privateImageMgm_sp'
            }
            dao.find ctx.c.code, 'service', filter, opt, (res)->
                cb(null, res)


        entrepreneurImagePositioning:(cb) ->
            opt =
                limit:1
                sort:
                    row:-1
            filter={
                cat:'entrepreneurImagePositioning'
            }
            dao.find ctx.c.code, 'service', filter, {}, (res)->
                cb(null, res)


        intro:(cb) ->
            filter={
                cat:'intro'
            }
            dao.find ctx.c.code, 'service', filter, {}, (res)->
#                for k of res[0].content
#                    item=res[0].content[k]
#                    console.log(item)

                cb(null, res[0])

#        actorSolidPackaging:(cb) ->
#            opt =
#                limit:1
#                sort:
#                    row:-1
#            filter={
#                cat:'actorSolidPackaging'
#            }
#            dao.find ctx.c.code, 'service', filter, opt, (res)->
#                console.log(res.title);
#                cb(null, res)
#
#
#        designOfTheBrideImage:(cb) ->
#            opt =
#                limit:1
#                sort:
#                    row:-1
#            filter={
#                cat:'designOfTheBrideImage'
#            }
#            dao.find ctx.c.code, 'service', filter, opt, (res)->
#                console.log(res.title);
#                cb(null, res)
#
#