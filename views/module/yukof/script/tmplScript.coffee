module.exports =
    _init: (ctx,req,rsp)->
        partnerNav:(cb)->
            opt =
                limit:8
                sort:
                    row:-1
            filter =
                type:'partner'

            dao.find ctx.c.code, 'cat', filter, opt, (res)->
                cb(null,res)
        news: (cb)->
            opt=
                limit:5
            filter =
                cat:'news'
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                cb(null,res)
        knowledge: (cb)->
            opt=
                limit:5
            filter=
                cat:'knowledge'
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                cb(null,res)
        jobs: (cb)->
            opt=
                limit:5
            filter=
                cat:'jobs'
            dao.find ctx.c.code, 'post', filter, opt, (res)->
                cb(null,res)


    index:(ctx,req,rsp)->
        qa:(cb)->
            opt =
                limit:5
                sort:
                    row:-1
            dao.find ctx.c.code, 'qa', {}, opt, (res)->
                cb(null,res)

        contentLabel:(cb)->
            filter=
                code:
                    $regex: 'workShow_.*'
            opt =
                limit:6
                sort:
                    row:-1
            dao.find ctx.c.code, 'cat', filter, opt,(res)->
                cb(null,res)

    serviceChannel:(ctx,req,rsp) ->
        privateImageMgm_pp:(cb) ->
            opt =
                limit:10
                sort:
                    row:-1
            filter=
                code:'privateImageMgm_pp'

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