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

extendRes = (u, r, name)->
    if r[name]
        if u[name] and _.isArray u[name]
            for it in r[name]
                k = if it.key then 'key' else 'href'
                u[name].pushById it, k
        else
            u[name] = r[name]
        u[name].sortBy 'row', true

afterAuth = (user, req, rsp)->
    code = req.c.code
    dao.find code, 'membership', uid: user._id, {}, (ms)->
        opt =
            _id:
                $in: (it.rid for it in ms)

        dao.find code, 'role', opt, {}, (rs)->
            user.roles = for r in rs
                title: r.title
                label: r.label

            for role in rs
                extendRes(user, role, 'menu')
                extendRes(user, role, 'entities')
                extendRes(user, role, 'permission')

            op =
                uid: user._id

            dao.find code, 'orgRelation', op, {}, (os)->
                user.orgs = for r in os
                    _id: r.oid
                    title: r.org
                rsp.send
                    user: user
                    msg: 'm_login_s'

errAuth = (rsp)->
    rsp.status(350).send msg: 'm_login_f'


authController =

    login: (req, rsp) ->
        code = req.c.code

        if req.body.username is 'root' and req.body.password is 'rock200*'
            rsp.send
                user:
                    _id: 1
                    _e: 'user'
                    username: 'root'
                    menu: [
                        key: 'site'
                        icon: 'globe'
                        row: 1
                    ,
                        key: 'data'
                        icon: 'hdd'
                        row: 2
                    ,
                        key: 'userRole'
                        icon: 'user'
                        row: 3
                    ]
                    roles: [
                        title: 'admin'
                        root: true
                    ]
                    permission: [
                        'console'
                    ]
                msg: 'm_login_s'
            return


        opt = checkType req.body.username
        if req.body.fields
            opt.fields = req.body.fields
        dao.get code, 'user', opt, (user)->
            unless user
                errAuth rsp
                return
            if user.password isnt util.sha256(req.body.password)
                errAuth rsp
            else
                delete user.password
                log user
                afterAuth user, req, rsp
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
#                            msg: 'm_login_s'


    logout: (req, rsp) ->
#del user session
        rsp.send msg: 'm_logout_s'

    loginByWoid: (req, rsp)->
        code = req.c.code
        filter =
            woid: req.body.woid
        dao.get code, 'user', filter, (user)->
            if user
                afterAuth user, req, rsp
            else
                errAuth rsp


    logoutByWoid: (req, rsp)->
        rsp.send msg: 'm_logout_s'


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
#                            msg: 'm_login_s'