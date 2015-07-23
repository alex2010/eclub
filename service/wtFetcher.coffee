log 'fetcher xx.sdfsdfasfsadf'

dao = require './dao'
getApi = require './wechat'
fs = require 'fs'

module.exports = (req, item)->
    return unless item.refFile
    code = req.c.code
    for k, v of item.refFile
        if _.isArray v
            for it,i in v
                if v.startsWith 'wt'
                    [m,type,mid,pubCode] = v.split('::')
                    fn = '' + '.jpg'
                    getApi code, pubCode, (api)->
                        api.getMedia mid, (err, result, res)->
                            path = "#{_path}/public/res/upload/#{code}/#{fn}"
                            fs.open path, 'w+', (err, fd)->
                                fs.write fd, result, ->
                                    fs.close fd, ->
                    v[i] = fn
    so =
        $set:
            refFile: item.refFile
    dao.findAndUpdate code, entity, _id: item._id, so,->




