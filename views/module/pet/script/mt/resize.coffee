fs = require('fs')
gm = require('gm')

#_path = "#{_ph}/public/res/upload/pet/"
_path = "#{_ph}/public/res/upload/pet/portrait/"

for it in fs.readdirSync(_path)
    continue if fs.statSync("#{_path}#{it}").isDirectory()
    ext = it.split('.')[1]
    if ext in ['jpg','jpeg','JPG','JPEG','PNG','png','gif','GIF']
        path = "#{_path}#{it}"
        do(path)->
            gm(path).size (err,size)->
                if !err and size and size.width > 200
                    gm(path).resize(200,null).write path,(err)->
                        log err if err