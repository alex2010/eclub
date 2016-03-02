module.exports = (req, user)->
    db = req.c.code
    code = req.body.roleCode
    return unless code
    dao.get db, 'roleMap', code: code, (rc)->
        return unless rc
        for it in rc.role.split(',')
            filter=
                title:
                    $regex: "^#{it}$"
                    $options: 'i'
            dao.get db, 'role', filter, (role)->
                mb =
                    username: user.username
                    role: role.title
                    uid: user._id
                    rid: role._id
                dao.save db, 'membership:uid,rid', mb, ->
                    log 'save membership ok'

