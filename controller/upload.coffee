multer = require('multer')
fs = require('fs')
gm = require('gm')

`
    _fileStack = {};
`

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

walk = (path, max, offset) ->
    list = _fileStack[path]
    unless list
        list = _fileStack[path] = fs.readdirSync(path)
        for item in list
            if item
                if item.startsWith('.') or fs.statSync("#{path}/#{item}").isDirectory()
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

app.use multer
    dest: './public/res/img'
    rename: (fieldname, filename)->
        fieldname

    onFileUploadComplete: (file, req, rsp)->
        rp = sPath("#{req.query.code}/#{file.fieldname}.#{file.extension}")
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
        if req.query.func is 'portrait'
            p = "#{req.query.code}/portrait"
        else if req.query.func in ['logo','banner']
            p = "#{req.query.code}/images"
        else
            p = req.query.code
        sPath(p)

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
        path = sPath(req.params.code) + '/' + bo.id
        log sPath(req.params.code)
        fs.unlink path, ->
            _fileStack[sPath(req.params.code)] = null

        if bo.thumb
            fs.unlink thumbPath(path, bo.thumb.split(':')[0]), ->
        rsp.send
            success: true

    upload: (req, rsp)->
        file = _.values(req.files)[0]
        qu = req.query
        if qu.thumb
            file.path = thumbPath file.path, qu.thumb.split(':')[0]

        if req.query.func isnt 'portrait'
            _fileStack[sPath(req.c.code)] = null

        rsp.send
            success: true
            entity: file
            msg: 'm_upload_ok'

    fileList: (req, rsp)->
        qu = req.query
        code = req.c.code
        path = qu.path
        log sPath(code, path)
        rsp.send walk sPath(code, path), qu.max, qu.offset
