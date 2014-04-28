util = require 'util'
colors = require 'colors'
formats = require './formats'

class Logger

  constructor: (format, @options = {}) ->
    if typeof format is 'object'
      @options = format
      format = @options.format

    @format(format)

    # Define writable stream of each method
    @info.stream = process.stdout
    @err.stream = process.stderr
    @warn.stream = process.stderr
    @debug.stream = process.stdout

    # Define levels and colors of each method
    @info.level = 'info'
    @info.color = 'green'

    @warn.level = 'warn'
    @warn.color = 'yellow'

    @err.level = 'err!'
    @err.color = 'red'

    @debug.level = 'debug'
    @debug.color = 'cyan'

    # Alias
    @error = @err
    @warning = @warn

  format: (format) ->
    if typeof format is 'string'
      @_format = formats[format] or format or formats.default
    else
      @_format or= formats.default
    return this

  setStream: (method = 'info', stream) ->
    all = ['info', 'warn', 'err', 'debug']
    method = all if method is 'all'
    if method instanceof Array
      @[_method]?.stream = stream for i, _method of method
    else if typeof method is 'string'
      @[method]?.stream = stream
    return this

  getStream: (method = 'info') ->
    return @[method]?.stream

  _log: ->
    return false unless @_format
    msg = util.format.apply(util, arguments)

    raws = msg.split('\n').map (msg) =>
      raw = @_format.replace(/\:level/g, @_level)
              .replace(/\:date/g, new Date().toISOString())
              .replace(/\:msg/g, msg)
      # Print with color
      if @_stream.isTTY
        raw = raw.replace(/color\((.*?)\)/g, '$1'[@_color])
      else
        raw = raw.replace(/color\((.*?)\)/g, '$1')
      return raw

    @_stream.write(raws.join('\n') + '\n')

  info: =>
    @_level = @info.level
    @_color = @info.color
    @_stream = @info.stream
    @_log.apply(this, arguments)

  warn: =>
    @_level = @warn.level
    @_color = @warn.color
    @_stream = @warn.stream
    @_log.apply(this, arguments)

  err: =>
    @_level = @err.level
    @_color = @err.color
    @_stream = @err.stream
    @_log.apply(this, arguments)

  debug: =>
    return false unless @options.debug or process.env.DEBUG
    @_level = @debug.level
    @_color = @debug.color
    @_stream = @debug.stream
    @_log.apply(this, arguments)

  exit: (message, code = 1) =>
    @err(message)
    process.exit(code)

  mute: ->
    @_format = formats.mute
    return this

module.exports = Logger
