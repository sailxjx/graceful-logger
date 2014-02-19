colors = require('colors')

class Logger

  _formats = ['default', 'medium']

  constructor: (format) ->
    if format? then @format(format) else @_formatMethod = @_defaultFormat

  format: (format) ->
    if format? and typeof format is 'string'
      if format in _formats
        @_formatMethod = @["_#{format}Format"]
      else
        @_format = format
        @_formatMethod = @_customFormat
    else
      @_formatMethod = @_nullFormat
    return this

  _defaultFormat: ->
    @_format = 'color(:level:) :msg'
    @_customFormat.apply(this, arguments)

  _nullFormat: ->
    return false

  _mediumFormat: ->
    @_format = 'color([:level :date]) :msg'
    @_customFormat.apply(this, arguments)

  _customFormat: ->
    msgArr = []
    for i, val of arguments
      if typeof val in ['object']
        msgArr.push(JSON.stringify(val))
      else
        msgArr.push("#{val}")

    msg = msgArr.join(' ')

    raw = @_format.replace(/\:level/g, @_level)
            .replace(/\:date/g, new Date().toISOString())
            .replace(/\:msg/g, msg)

    # Add color print
    if matches = raw.match(/color\((.*?)\)/g)
      if process.stdout.isTTY
        raw = raw.replace(/color\((.*?)\)/g, '$1'[@_color])
      else
        raw = raw.replace(/color\((.*?)\)/g, '$1')

    @_outputMethod(raw)

  _log: -> @_formatMethod.apply(this, arguments)

  info: =>
    @_level = 'info'
    @_color = 'green'
    @_outputMethod = console.log
    @_log.apply(this, arguments)

  warn: =>
    @_level = 'warn'
    @_color = 'yellow'
    @_outputMethod = console.warn
    @_log.apply(this, arguments)

  debug: =>
    return false unless @_debug or process.env.DEBUG
    @_level = 'debug'
    @_color = 'cyan'
    @_outputMethod = console.log
    @_log.apply(this, arguments)

  err: =>
    @_level = 'err!'
    @_color = 'red'
    @_outputMethod = console.error

    len = arguments.length
    if typeof arguments[len - 1] is 'number'
      args = (v for i, v of arguments)
      code = args[len - 1]
      args.pop()
    else
      args = arguments
    @_log.apply(this, args)

    process.exit(code) if code?

  close: ->
    @_formatMethod = @_nullFormat
    return this

module.exports = Logger
