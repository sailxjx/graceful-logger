colors = require('colors')

class Logger

  format: ->
    msgs = (v for i, v of arguments)
    if @options.format? and typeof @options.format is 'string'
      matches = @options.format.split(' ')
      replaces =
        '%s': (i) ->
          i = Number(i)
          matches = matches[..i-1].concat(msgs, matches[i+1..])
        '%t': (i) ->
          matches[i] = new Date
      for i, ft of matches
        replaces[ft].call(this, i) if replaces[ft]?
      msgs = matches
    return msgs

  constructor: (@options = {}) ->
    @level = 'info'
    @prefixs =
      info: 'info:'
      warn: 'WARN:'
      err: 'ERR!:'
      debug: 'DEBUG:'
    @levels =
      info:
        color: 'green'
        method: console.log
      warn:
        color: 'yellow'
        method: console.warn
      err:
        color: 'red'
        method: console.error
      debug:
        color: 'cyan'
        method: console.log

  _log: ->
    return @options.custom.apply(this, arguments) if typeof @options.custom is 'function'
    @prefix = if process.stdout.isTTY then @prefixs[@level][@levels[@level].color] else @prefixs[@level]
    msgs = @format.apply(this, arguments)
    msgs.unshift(@prefix)
    @levels[@level].method.apply(this, msgs)

  info: ->
    @level = 'info'
    @_log.apply(this, arguments)

  warn: ->
    @level = 'warn'
    @_log.apply(this, arguments)

  debug: ->
    return false unless @options.debug
    @level = 'debug'
    @_log.apply(this, arguments)

  err: ->
    @level = 'err'
    len = arguments.length
    if typeof arguments[len - 1] is 'number'
      args = (v for i, v of arguments)
      code = args[len - 1]
      args.pop()
    else
      args = arguments
    @_log.apply(this, args)
    process.exit(code) if code?

module.exports = Logger
