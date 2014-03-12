util = require('util')
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
    msg = util.format.apply(util, arguments)

    raw = @_format.replace(/\:level/g, @_level)
            .replace(/\:date/g, new Date().toISOString())
            .replace(/\:msg/g, msg)

    # Add color print
    if matches = raw.match(/color\((.*?)\)/g)
      if process.stdout.isTTY
        raw = raw.replace(/color\((.*?)\)/g, '$1'[@_color])
      else
        raw = raw.replace(/color\((.*?)\)/g, '$1')

    @_stream.write(raw + '\n')

  _log: -> @_formatMethod.apply(this, arguments)

  info: =>
    @_level = 'info'
    @_color = 'green'
    @_stream = process.stdout
    @_log.apply(this, arguments)

  warn: =>
    @_level = 'warn'
    @_color = 'yellow'
    @_stream = process.stderr
    @_log.apply(this, arguments)

  err: =>
    @_level = 'err!'
    @_color = 'red'
    @_stream = process.stderr
    @_log.apply(this, arguments)

  debug: =>
    return false unless @_debug or process.env.DEBUG
    @_level = 'debug'
    @_color = 'cyan'
    @_stream = process.stdout
    @_log.apply(this, arguments)

  exit: (message, code = 1) =>
    @_level = 'err!'
    @_color = 'red'
    @_stream = process.stderr
    @_log.call(this, message)
    process.exit(code)

  mute: ->
    @_formatMethod = @_nullFormat
    return this

  # Alias
  error: @::err

module.exports = Logger
