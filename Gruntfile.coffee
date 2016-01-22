#setting = require './setting.js'
#
#log setting


String::replaceAll = (s1, s2)->
    this.replace(new RegExp(s1, "gm"), s2);

module.exports = (grunt)->

#    dm = 'encorner.org'
#    ftp = '113.11.197.232'
#    _remote = '/opt/node/'

#    dm = 'wikibeijing.com'
#    ftp = '45.33.59.69'

#    ftp = '139.162.24.228'
#    upload_path: '/opt/node/public'
    _resPath = "http://s.newenglishtime.com/"

    #    _resPath = setting.res_path
    #    ftp = setting.ftp

    _remote = '/opt/node/'
    _remoteRes = "#{_remote}public/res/"
    _local = __dirname
    _module = "#{__dirname}/public/module/"
    #    m = grunt.task.current.args[0]


    require("load-grunt-config") grunt

    grunt.registerTask 'default', ->
        grunt.initConfig {}

    #------------------------------------------backend-------------------------------------------------
    backFiles = (nstr)->
        res = []
        for it in nstr.split(',')
            res.push
                expand: true
                cwd: it
                src: ['*.js', '*.json', '*.jade', 'inc/*.jade']
                dest: _remote + "#{if it is './' then '' else it}"
        res

    grunt.registerTask 'pack', () ->
        srcPath = '/Users/alex/Projects/eclub/public/module/newLogin/app/'
        dstPath = '/Users/alex/Projects/account/public/dev/273775908/js/'
        files = {}
        files["#{dstPath}login.js"] = [
            "#{srcPath}lib/util.js"
            "#{srcPath}lib/rsa.js"
            "#{srcPath}cmLogin.js"
        ]
        ugfile = {}
        ugfile["#{dstPath}login.js"] = ["#{dstPath}login.js"]
        ugfile["#{dstPath}en.js"] = ["#{srcPath}i18n/en.js"]

        grunt.config.init
            concat:
                cat:
                    files: files
            uglify:
                ug:
                    files: ugfile

        grunt.loadNpmTasks('grunt-contrib-concat');
        grunt.loadNpmTasks('grunt-contrib-uglify');

        grunt.task.run "concat:cat"
        grunt.task.run "uglify:ug"


    #    grunt.registerTask 'ex', (code) ->
    ##       controller,ext,bin,./ .js
    #        #views .jade
    #        #public

    grunt.registerTask 'bk', (code, mode, type = 'ftp') ->
        setting = require "#{__dirname}/views/module/#{code}/script/setting.js"

        bStr = if mode
            "views/module/#{code},views/module/#{code}/script,views/module/#{code}/script/data,views/module/#{code}/data,views/module/#{code}/i18n"
        else
            "./,views,routes,ext,controller,bin,service"
        _remote = setting.upload_path
        _remoteRes = "#{_remote}res/"
        if type is 'ftp'
            grunt.config.init
                ftpscript:
                    server:
                        options:
                            host: setting.ftp
                            port: setting.port || '21'
                            auth:
                                username: 'root'
                                password: 'rock200*'
                        files: backFiles(bStr)

            grunt.task.run "ftpscript:server"
        else if type is 'ex'
#            grunt.config.init
#                ex:
#                    bk: backFiles(bStr)
#                    bk1: backFiles(bStr)
#                    ft1: backFiles(bStr)
#
#            grunt.task.run "ex:bk"
#            grunt.task.run "ex:bk1"
#            grunt.task.run "ex:ft1"
            grunt.log.write backFiles(bStr)

    #------------------------------------------frontend-------------------------------------------------
    grunt.registerTask 'ft', (code) ->
#        _remoteRes = "/opt/s.#{dm}/res/"
        setting = require "#{__dirname}/views/module/#{code}/script/setting.js"

        _local_admin = "public/lib/admin/"
        _local_resSub = "public/res/upload/#{code}/lib"


        _remote = setting.upload_path
        _remoteRes = "#{_remote}public/res/"

        _remoteResSub = "#{_remoteRes}upload/#{code}/lib"

        m = "#{_module + code}/src/"

        #        grunt.log.write(require("#{_module}rfg.js").cfg(code, 'main').out)


        cssProcess = (content, srcPath)->
#        content = content.replace(/..\/..\/..\/..\/res\//g, _resPath)
#        content = content.replace(/\/res\//g, _resPath)
            grunt.log.write setting.local_path
            grunt.log.write setting.res_path
            content = content.replaceAll(setting.local_path, setting.res_path)
            grunt.log.write content.indexOf setting.local_path
            content


        grunt.config.init
#            clean:
#                all: [m + '/lib/*']
            copy:
#                cleanAdmin:
#                    expand: true
#                    cwd: _res + 'css'
#                    src: ['admin.css']
#                    dest: _res + 'css'
#                    options:
#                        process: cssProcess
                cleanCss:
                    expand: true
                    cwd: _local_resSub
                    src: ['*.css']
                    dest: _local_resSub
                    options:
                        process: cssProcess
            cssmin:
                combine:
                    options:
                        keepSpecialComments: 0
                    files: [
                        expand: true
                        cwd: m + 'style'
                        src: ['*.css']
                        dest: _local_resSub
                        ext: '.css'
                    ,
                        expand: true
                        cwd: _local_admin + 'style'
                        src: ['*.css']
                        dest: _local_resSub
                        ext: '.css'
                    ]

            requirejs: {}
#                main:
#                    options: require("#{_module}rfg.js").cfg(code, 'main')
#                admin:
#                    options: require("#{_module}rfg.js").cfg(code, 'admin')
#                account:
#                    options: require("#{__dirname}/rfg").cfg(m, 'account')
#                wechat:
#                    options: require("#{__dirname}/rfg").cfg(m, 'wechat')

            ftpscript:
                admin:
                    options:
                        host: setting.ftp
                    files: [
#                        expand: true
#                        cwd: _res + 'css'
#                        src: ['admin.css']
#                        dest: _remoteRes + 'css'
#                    ,
                        expand: true
                        cwd: _local_resSub
                        src: ['*.*']
                        dest: _remoteResSub
#                    ,
#                        expand: true
#                        cwd: _tmpl
#                        src: ['**/*.html']
#                        dest: _dest + m + '/tmpl'
#                    ,
#                        expand: true
#                        cwd: ''
#                        src: ['version.json']
#                        dest: _dest
#                    ,
#                        expand: true
#                        cwd: m + '/src/i18n'
#                        src: ['*.coffee']
#                        dest: _dest + m + '/src/i18n'
#                    ,
#                        expand: true
#                        cwd: _lib + 'i18n'
#                        src: ['**/*.coffee']
#                        dest: _remote + 'lib/i18n'
                    ]


        #        #update version
        #        fn = 'version.json'
        #        v = grunt.file.readJSON(fn)
        #        vv = v.version.split('.')
        #        vv[vv.length - 1] = ++vv[vv.length - 1]
        #        v.version = vv.join('.')
        #        grunt.file.write(fn, JSON.stringify(v))

        #        grunt.task.run 'clean'
        #        grunt.task.run "cssmin"
        grunt.task.run "copy:cleanCss"
        #        grunt.task.run "requirejs:main"
        #        grunt.task.run "requirejs:admin"

        #        if grunt.file.exists("#{__dirname}/#{_dir}main.js")
        #            grunt.task.run "requirejs:main"
        #
        #        grunt.task.run "requirejs:admin"

        #        if grunt.file.exists("#{__dirname}/#{_dir}geVote.js")
        #            grunt.task.run "requirejs:geVote"

        #        if grunt.file.exists("#{__dirname}/#{_dir}account.js")
        #            grunt.task.run "requirejs:account"

        #        if grunt.file.exists("#{__dirname}/#{_dir}wechat.js")
        #            grunt.task.run "requirejs:wechat"

        grunt.task.run "ftpscript:admin"
