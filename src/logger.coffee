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
    if arguments[0]?[0] is '%'  # The first argument is a placeholder
      msgs = [util.format.apply(util, arguments)]
    else
      msgs = (msg for msg in arguments).map (msg) -> util.format.call util, msg
    msg = msgs.join(' ')

    # Replace keywords and colors
    raw = @_format.replace /(\:[a-z0-9]+)(\.[a-z]+)?/ig, (meet, code, color) =>
      # Replace keywords
      code = code[1..]
      if /[0-9]+/.test code  # Numeric placeholder should be replaced with msg of the correct index
        code = msgs[code] or ''
      else
        switch code
          when 'level' then code = @_level
          when 'date' then code = new Date().toISOString()
          when 'msg' then code = msg

      # Replace color
      if color? and @_stream.isTTY
        color = color[1..]
        color = @_color if color is 'color'  # Replace with pre defined colors
        code = code[color]

      return code

    @_stream.write(raw + '\n')

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
