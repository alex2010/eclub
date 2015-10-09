module.exports =
    _init: (ctx,req,rsp)->
#        partnerCat:(cb)->
#            opt=
#                limit:8
#                sort:
#                    row:-1
#            filter=
#                cat:'partner'
#            dao.find ctx.c.code, 'cat' , filter, opt, (res)->
#                data=[]
#                opt=
#                    limit:16
#                    sort:
#                        row:-1
#                filter={}
#                i = 0
#                while i < res.length
#                    obj={}
#                    obj.label=res[i].label
#                    dao.find ctx.c.code, '', {car:res[i].label},opt,(res)->
#                        obj.content=res
#                        data.push obj
#                    res[i].code
#                    i++

    serviceChannel:(ctx,req,rsp) ->
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
                cb(null, res[0])

    partnerChannel:(ctx,req,rsp)->
        post:(cb)->
            filter={
                cat:'partner'
            }
            dao.find ctx.c.code , 'post', filter, {}, (res)->
                cb(null,res[0])

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