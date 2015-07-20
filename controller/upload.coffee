multer = require('multer')
fs = require('fs')
gm = require('gm')

`
    _fileStack = {};
    _fileStackTotal = 0;
`

sPath = (code, exPath)->
    path = "/public/res/upload/#{code}"
    if exPath
        path += "/#{exPath}"
    if app.env
        '.' + path
    else
        _path + path

walk = (path, max, offset) ->
    list = _fileStack[path]
    unless list
        list = _fileStack[path] = fs.readdirSync(path)
        for item in list
            if item
                if item.startsWith('.') or fs.statSync("#{path}/#{item}").isDirectory()
                    list.remove item
    _fileStackTotal = list.length
    start = +offset
    end = start + +max
    if start > _fileStackTotal
        entities: []
        count: 0
    else
        entities: list.slice(start, (if _fileStackTotal > end then end else _fileStackTotal))
        count: _fileStackTotal

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
        sPath(req.query.code)

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
        fs.unlink path, ->
        if bo.thumb
            fs.unlink thumbPath(path, bo.thumb.split(':')[0]), ->
        rsp.send
            success: true

    upload: (req, rsp)->
        file = _.values(req.files)[0]
        qu = req.query
        if qu.thumb
            file.path = thumbPath file.path, qu.thumb.split(':')[0]
        rsp.send
            success: true
            entity: file
            msg: 'm.upload'

    fileList: (req, rsp)->
        qu = req.query
        code = req.c.code
        path = qu.path
        rsp.send walk sPath(code, path), qu.max, qu.offset






