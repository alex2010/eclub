opt =
    inputClass: 'form-control'
    labelClass: 'control-label'
    inputBox: 'form-group'
    iconStr: 'glyphicon'
    active: 'active'
    tbStyle: 'table table-striped table-bordered table-responsive'
    panel: (type = 'default')->
        "panel panel-#{type}"

    btn: (style = 'default', size, block, etc)->
        b = 'btn'
        s = ''
        s += " #{b}-#{style}"
        s += " #{b}-#{size}" if size
        s += " #{b}-block" if block
        s += " #{etc}" if etc
        b + s

    btn_bp: (size = 'lg', block = true)->
        @btn 'primary', size, block

    icon: (key)->
        "#{@iconStr} #{@iconStr}-#{key}"

    sign:
        success: 'ok'
        warning: 'warning-sign'
        info: 'info-sign'
        danger: 'exclamation-sign'
#
#if cf and cf.mob
#    opt.tbStyle = 'table'

module.exports = opt