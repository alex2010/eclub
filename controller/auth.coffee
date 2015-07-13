_ = require('underscore')
async = require('async')


deepExtend = require('deep-extend')

checkType = (k)->
    if /\S+@\S+\.\S+/.test k
        email: k
    else if /^(13[0-9]|15[0|1|2|3|6|7|8|9]|18[5|6|8|9])\d{8}$/.test k
        phone: k
    else
        username: k

afterAuth = (code,user,rsp)->
    dao.find code, 'membership', uid: user._id, {}, (ms)->
        opt =
            _id:
                $in: (it.rid for it in ms)
        dao.find code, 'role', opt, {}, (rs)->
            user.roles = for r in rs
                title: r.title
                label: r.label
            for role in rs
                deepExtend user, role.res
            rsp.send
                user: user
                msg: 'm.login_s'

errAuth = (rsp)->
    rsp.status(350).send msg: 'm.login_f'

authController =

    login: (req, rsp) ->
        code = req.c.code
        opt = checkType req.body.username
        dao.get code, 'user', opt, (user)->
            unless user
                errAuth rsp
                return
            if user.psd isnt req.body.psd
                errAuth rsp
            else
                delete user.password
                afterAuth code, user, rsp
#                dao.find code, 'membership', uid: user._id, {}, (ms)->
#                    opt =
#                        _id:
#                            $in: (it.rid for it in ms)
#                    dao.find code, 'role', opt, {}, (rs)->
#                        user.roles = for r in rs
#                            title: r.title
#                            label: r.label
#                        _.extend user, role.res for role in rs
#                        rsp.send
#                            user: user
#                            msg: 'm.login_s'


    logout: (req, rsp) ->
        #del user session
        rsp.send msg: 'm.logout_s'

    loginByWoid: (req,rsp)->
        code = req.c.code
        filter =
            woid: req.body.woid
        dao.get code, 'user', filter, (user)->
            if user
                afterAuth code, user, rsp
            else
                errAuth rsp


    logoutByWoid: (req,rsp)->
        rsp.send msg: 'm.logout_s'


module.exports = authController




#                    cl = for it in ms
#                        (cb)->
#                            dao.get 'role', _id: it.rid, (role)->
#                                user.roles.push role
#                                cb null, role
#                    async.parallel cl, (err, res)->
#                        _.extend user, role.res for role in res
#                        rsp.send
#                            user: user
#                            msg: 'm.login_s'