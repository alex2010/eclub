log 'fetcher'
getApi = require './wechat'
fs = require 'fs'
module.exports = (req, item)->
    return unless item.refFile
    code = req.c.code
    entity = req.params.entity
    mark = false
    log item.refFile
    for k, v of item.refFile
        if _.isArray v
            for it,i in v
                if it.startsWith '_wt'
                    [m,type,mid,pubCode] = it.split('::')
                    fn = util.randomChar(8) + '.jpg'
                    getApi code, pubCode, (api)->
                        api.getMedia mid, (err, result, res)->
                            path = "#{_path}/public/res/upload/#{code}/#{fn}"
                            fs.open path, 'w+', (err, fd)->
                                fs.write fd, result, 0, result.length, null, ->
                                    fs.close fd, ->
                    log fn
                    v[i] = fn
                    mark = true
    if mark
        so =
            $set:
                refFile: item.refFile

        log item.refFile

        dao.findAndUpdate code, entity, _id: item._id, so, ->



