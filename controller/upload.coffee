multer = require('multer')
fs = require('fs')
gm = require('gm')
getApi = require './wechat'
`
    _fileStack = {};
`

mPath = (code, exPath)->
    path = "/public/module/#{code}"
    if exPath
        path += "/#{exPath}"
    pa = if app.env
        '.' + path
    else
        _path + path
    if !fs.existsSync pa
        fs.mkdirSync pa
    pa

sPath = (code, exPath)->
    path = "/public/res/upload/#{code}"
    if exPath
        path += "/#{exPath}"

    pa = if app.env
        '.' + path
    else
        _path + path
    if !fs.existsSync pa
        fs.mkdirSync pa
    pa

walk = (path, max, offset, ext) ->
    list = _fileStack[path]
    unless list
        list = _fileStack[path] = fs.readdirSync(path)
        for item in list
            if item
                if item.startsWith('.') or fs.statSync("#{path}/#{item}").isDirectory() or (ext and !item.endsWith(ext))
                    list.remove item
        list.sort (a, b)->
            fs.statSync(path + '/' + b).mtime.getTime() - fs.statSync(path + '/' + a).mtime.getTime()

    total = list.length
    start = +offset
    end = start + +max
    if start > total
        entities: []
        count: 0
    else
        entities: list.slice(start, (if total > end then end else total))
        count: total

subFolder = (req)->
    if req.query.func is 'portrait'
        "/portrait"
    else if req.query.func in ['logo', 'banner']
        "/images"
    else if req.query.subFolder
        '/' + req.query.subFolder
    else
        ''


app.use multer
    dest: './public/res/img'
    rename: (fieldname, filename)->
        fieldname

    onFileUploadComplete: (file, req, rsp)->
        rp = sPath("#{req.query.code}#{subFolder(req)}/#{file.fieldname}.#{file.extension}")
        if rp.endsWith '.jpeg'
            srp = rp
            rp = rp.replace('.jpeg', '.jpg')
            fs.rename srp, rp, (err)->
                log err if err
        qu = req.query
        if qu.maxWidth
            thumb(rp, ':' + qu.maxWidth)
        if qu.thumb
            thumb(rp, qu.thumb)
        if qu.crop
            crop(file.path, crop)

    onFileSizeLimit: ->
        log 'oversize'

    changeDest: (dest, req)->
        sPath(req.query.code + subFolder(req))

thumbPath = (path, folder)->
    return path unless folder
    p = path.split('/')
    e = p.pop()
    p.push folder
    p.push e
    p.join('/')

crop = (path, crop)->
    [w,h,x,y] = crop.split(',')
    gm(path)
    .crop(w, h, x, y)
    .write(path)

thumb = (path, thumb)->
    [folder,w] = thumb.split(':')
    tp = thumbPath path, folder.trim()
    gm(path).resize(w, null).write(tp, ->)
#    gm(path).thumb(w, null, 'test.jpg', 50, ->)

module.exports =
    remove: (req, rsp)->
        bo = req.body
        path = sPath(req.c.code) + '/' + bo.id
        fs.unlink path, ->
            _fileStack[sPath(req.c.code)] = null

        if bo.thumb
            fs.unlink thumbPath(path, bo.thumb.split(':')[0]), ->
        rsp.send
            success: true

    upload: (req, rsp)->
        qu = req.query
        fn = util.randomChar(8) + '.jpg'
        if qu._wt
            getApi code, qu.wcode, (api)->
                api.getMedia qu.mid, (err, result, res)->
                    path = "#{_path}/public/res/upload/#{code}/#{qu.uid}/#{fn}"
                    fs.open path, 'w+', (err, fd)->
                        fs.write fd, result, 0, result.length, null, ->
                            fs.close fd, ->
                                rsp.send
                                    success: true
                                    path: "#{qu.uid}/#{fn}"
                                    msg: 'm_upload_ok'
        else
            file = _.values(req.files)[0]
            qu = req.query
            if qu.thumb
                file.path = thumbPath file.path, qu.thumb.split(':')[0]

            if req.query.func isnt 'portrait'
                _fileStack[sPath(req.c.code)] = null

            if file.extension is 'jpeg'
                file.path = file.path.replace '.jpeg', '.jpg'
                file.name = file.name.replace '.jpeg', '.jpg'
                file.extension = 'jpg'
            rsp.send
                success: true
                entity: file
                msg: 'm_upload_ok'

    fileList: (req, rsp)->
        qu = req.query
        path = if qu.mod
            mPath(req.c.code, qu.path)
        else
            sPath(req.c.code, qu.path)
        rsp.send walk path, qu.max, qu.offset, qu.ext
