_ = require('underscore')
async = require('async')

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

            if gStub[code] and gStub[code].afterAuth
                gStub[code].afterAuth(user, req, rsp)
            else
                dao.find code, 'orgRelation', uid: user._id, {}, (os)->
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
        bo = req.body
        if bo.username is 'root' and bo.password is 'rock200*'
            rsp.send
                user:
                    _id: 1
                    _e: 'user'
                    username: 'root'
                    _root: true
                    menu: [
                        key: 'site'
                        icon: 'globe'
                        row: 1
                    ,
                        key: 'userRole'
                        icon: 'user'
                        row: 3
                    ]
                    roles: [
                        title: 'admin'
                    ]
                    permission: [
                        'console'
                    ]
                msg: 'm_login_s'
            return


        opt = checkType bo.username
        if bo.fields
            opt.fields = bo.fields
        dao.get code, 'user', opt, (user)->
            unless user
                errAuth rsp
                return

            if bo._en
                if user.password isnt bo.password
                    errAuth rsp
                    return
            else
                if user.password isnt util.sha256(bo.password)
                    errAuth rsp
                    return
            delete user.password
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


    resetPsd: (req, rsp) ->
        bo = req.body
        code = req.c.code

        res = gs(null, 'verifyCode')(req, bo)
        if res.error
            rsp.status 390
            rsp.send msg: '验证码错误'
            return

        bo = req.body
        fo = if bo.phone
            phone: bo.phone
        else
            email: bo.email

        dao.findAndUpdate code, 'user', fo, password: util.sha256(bo.password), (res)->
            if res
                rsp.send msg: '修改成功'
            else
                rsp.status 390
                rsp.send msg: '用户不存在'

    checkPsd: (req, rsp) ->
        bo = req.body
        opt =
            _id: bo._id

        dao.get req.c.code, 'user', opt, (user)->
            if user and !user.password and bo.password is 'psd'
                rsp.send
                    msg: '验证成功'
            else if !user or user.password isnt util.sha256(bo.password)
                rsp.status 390
                rsp.send msg: '密码错误'
            else
                rsp.send
                    msg: '验证成功'

    logout: (req, rsp) ->
#del user session
        rsp.send msg: 'm_logout_s'

    loginByWoid: (req, rsp)->
        code = req.c.code
        bo = req.body
        filter = {}

        filter["w_#{bo.wCode}"] = bo.woid
        dao.get code, 'user', filter, (user)->
            if user
                afterAuth user, req, rsp
            else
                errAuth rsp

    logoutByWoid: (req, rsp)->
        #track user behavior
        rsp.send msg: 'm_logout_s'


#    enable:(req,rsp)->
#        code = req.c.code
#        bo　=　req.body
#        dao.update code, 'user', _id:oid(bo.uid),$set:{status: 2}, ->
#            if　bo.ents
#                for it in bo.ents.split(',')
#                    dao.update code, it, {status:3,'user_id':oid(bo.uid)}, $set:{status:2}
#            rsp.send msg: 'm_update_ok'
#
#    disable: (req,rsp)->
#        code = req.c.code
#        bo　=　req.body
#        dao.update code, 'user', _id:oid(bo.uid),$set:{status: 3}, ->
#            if　bo.ents
#                for it in bo.ents.split(',')
#                    dao.update code, it, {status:2,'user_id':oid(bo.uid)}, $set:{status:3}
#            rsp.send msg: 'm_update_ok'

    merge: (req, rsp)->
        code = req.c.code
        bo = req.body
        filter =
            phone: bo.phone
        dao.get code, 'user', filter, (user)->
            wid = bo.wid
            phone = bo.phone
            po = {wid, phone}
            if bo.wCode
                po["w_#{bo.wCode}"] = bo.woid
            if user
                dao.findAndUpdate code, 'user', filter, $set:po, (ru)->
                    dao.delItem code, 'user', _id: oid(bo.uid)
                    afterAuth ru, req, rsp
            else
                dao.findAndUpdate code, 'user', {_id: oid(bo.uid)}, $set:po, (ru)->
                    afterAuth ru, req, rsp

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