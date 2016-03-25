

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
    genSite: (req, rsp)->
        code = req.body.code
        pp = "#{ _path}/public/module/"
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
                            log data.replaceAll('#code', code)
                            fs.writeFile str, data.replaceAll('#code', code), (err)->
                                throw err if err
            rsp.send
                success: true
                msg: '生产成功'

