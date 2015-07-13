module.exports = (req, user)->
    db = req.c.code
    code = req.body.roleCode
    dao.get db, 'roleMap', code: code, (rc)->
        for it in rc.role.split(',')
            dao.get db, 'role', title: it, (role)->
                mb =
                    username: user.username
                    role: role.title
                    uid: user._id
                    rid: role._id
                dao.save db, 'membership:uid,rid', mb, ->
                    log 'save membership ok'

