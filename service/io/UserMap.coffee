module.exports = class UserMap
    u2s: {}
    s2u: {}

    addUser: (uid, st)->
        st.uid = uid
        @u2s[uid] = st.id

    rmUser: (st)->
        delete @u2s[st.uid]

    sid: (uid)->
        @u2s[uid]