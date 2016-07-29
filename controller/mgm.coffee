async = require('async')
request = require('request')
copyRecursiveSync = (src, dest, cb) ->
    exists = fs.existsSync(src)
    stats = exists and fs.statSync(src)
    isDirectory = exists and stats.isDirectory()
    if exists and isDirectory
        fs.mkdirSync dest
        fs.readdirSync(src).forEach (childItemName) ->
            copyRecursiveSync path.join(src, childItemName), path.join(dest, childItemName), cb
    else
        fs.link src, dest,->
            cb?(dest)

module.exports =
    setTop:　(req,rsp)->
        val = if req.params.top is 'true'
            true
        else
            false
        bo　=　req.body
        dao.update code, bo.ent, _id:oid(bo.id), $set:{top: val}, ->
            rsp.send msg: 'm_update_ok'

    pubLock:　(req,rsp)->
        if req.params.status is 'enable'
            old = 3
            now = 2
        else
            old = 2
            now = 3
        bo　=　req.body
        dao.update code, bo.ent, _id:oid(bo.id), $set:{status: now}, ->
            if　bo.ents and bo.ent is 'user'
                for it in bo.ents.split(',')
                    dao.update code, it, {status:old,'user_id':oid(bo.uid)}, $set:{status:now}
                rsp.send msg: 'm_update_ok'

    bdPush: (req, rsp)->
        c = req.c
        unless c.bdPushUrl
            rsp.status = 320
            rsp.send msg: '您还没有配置百度SEO参数'
            return
        code = c.code
        op =
            skip: 0
            limit: (if req.body.type is '1' then 10 else 500)
        filter =
            status: 2
        rt = []
        opt={}
        for et in req.body.entities.split(',')
            do(et)->
                opt[et] = (cb)->
                    dao.find code, et, filter, op, (res)->
                        for it in res
                            rt.push "http://#{c.url}/#{et}/#{it._id}"
                        cb()

        async.parallel opt, ->
#            log rt.join('\n')
            rt.push "http://#{c.url}"
            request
                url: c.bdPushUrl
                method: 'POST'
                body: rt.join('\n')
            , (w,m,res)->
                    rm = JSON.parse res
                    if rm.success
                        rsp.send
                            success: true
                            msg: "已成功推送#{rm.success}条,还可以推送#{rm.remain}"
                    else
                        rsp.status 320
                        rsp.send
                            msg: '推送失败'

#            request.post "http://data.zz.baidu.com/urls?site=www.postenglishtime.com&token=j7skUqSQuqPZKEF8", rt.join('\n')
#            log

    genSite: (req, rsp)->
        code = req.body.code
        pp = "#{_path}/public/module/"
        dest = pp + code
        if fs.existsSync(dest)
            rsp.send
                error: true
                msg: '目录已经存在'
        else
            copyRecursiveSync "#{pp}_tmpl", dest, (str)->
                if fs.statSync(str).isFile()
                    fs.readFile str, 'utf-8', (err, data)->
                        throw err if err
                        if data.indexOf("#code") > -1
                            fs.writeFile str, data.replaceAll('#code', code), (err)->
                                throw err if err
            rPath = "#{_path}/public/res/upload/#{code}"
            fs.mkdirSync rPath
            fs.mkdirSync rPath + '/images'
            rsp.send
                success: true
                msg: '生产成功'

#    transData: (req, rsp)->
