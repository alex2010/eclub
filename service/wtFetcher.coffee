getApi = require './wechat'
fs = require 'fs'
module.exports = (req, item)->
    return unless item.refFile
    code = req.c.code
    entity = req.params.entity
    mark = false
    for k, v of item.refFile
        if _.isArray v
            for it,i in v
                if it.startsWith '_wt'
                    [m,type,mid,pubCode] = it.split('::')
                    fn = if type is 'img'
                        util.randomChar(8) + '.jpg'
                    else if type is 'audio'
                        util.randomChar(8) + '.amr'
                    getApi code, pubCode, (api)->
                        api.getMedia mid, (err, result, res)->
                            path = "#{_path}/public/res/upload/#{code}/#{fn}"
                            fs.open path, 'w+', (err, fd)->
                                fs.write fd, result, 0, result.length, null, ->
                                    fs.close fd, ->
                    v[i] = fn
                    mark = true
    if mark
        so =
            $set:
                refFile: item.refFile
        dao.findAndUpdate code, entity, _id: item._id, so, ->




