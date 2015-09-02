_path = "#{_ph}/public/res/upload/pet/"

for it in fs.readdirSync(_path)
    continue if fs.statSync("#{_path}#{it}").isDirectory()
    if it.startsWith('portrait') or it.startsWith('photo')
        if it.indexOf('-')>-1
            [fn,ud] = it.split('-')
        else
            [fn,ud] = it.split('_')

        if ud and (ud.split('.')[0])
            ud = +ud.split('.')[0]

            do (it, fn, ud)->
                dao.get code, 'user', {id: ud},(u)->
                    if u
                        newName = u._id + '.jpg'
                        sf = "#{_path}#{it}"
                        dp = "#{_path+fn}/#{newName}"
                        u.refFile ?= {}
                        u.refFile[fn] = [newName]
                        fs.rename sf, dp, (err)->
                            log err if err
                            fs.unlink(sf)
                        dao.findAndUpdate code,'user', {_id:u._id} , u, ->
                    else
                        log 'trash'
                        sf = "#{_path}#{it}"
                        dp = "#{_path}trash/#{it}"
                        fs.rename sf, dp, (err)->
                            log err if err
    else if it.startsWith('venue')
        [fn,vd] = it.split('-')
        vd = +vd.split('.')[0]
        do (it,fn,vd)->
            dao.get code, 'venue', {id:vd},(v)->
                if v
                    newName = v._id + '.jpg'
                    sf = "#{_path}#{it}"
                    dp = "#{_path}#{newName}"

                    v.refFile ?= {}
                    v.refFile.head = [newName]

                    fs.renameSync sf, dp
                    dao.findAndUpdate code, 'venue', {_id:v._id}, v, ->

