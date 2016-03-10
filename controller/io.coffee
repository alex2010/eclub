io = require('socket.io')(server)
rg = require '../bin/grpc/rg_client'


io.on 'connection', (st) ->
    log 'start'

    st.on 'r:create', (d)->

    st.on 'r:update', (d)->

    st.on 'r:read', (d, c)->
        op =
            uid: 1
            cid: '2'
        rg.action 'LineOn', op, (e, res)->
            c null, entities: [
                _e: 'post'
                title: 'zzz'
                username: 'zz'
            ,
                _e: 'post'
                title: 'zbbbb'
                username: 'zz'
            ,
                _e: 'post'
                title: 'zzzb'
                username: 'zz'
            ]
    #            rg.find d._e, d.p, d.q, (rt, cb)->
    #                log cb
    #                st.emit 'r:read:rt',
    #                    entities: [
    #                        title: 'zzz'
    #                    ,
    #                        title: 'zbbbb'
    #                    ]
    #                    max: 20

    st.on 'r:delete', (d)->
        st.emit 'news', hell: 'o'


    st.on 'event', (data) ->


    st.on 'disconnect', ->
        log 'end'