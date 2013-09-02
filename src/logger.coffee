colors = require('colors')

class Logger

  @prefix:
    info: 'info:'
    warn: 'WARN:'
    err: 'ERR!:'

  constructor: (@options = {}) ->

  _log: (str, prefix = '') =>
    return @background(str) if @options['background']
    console.log("#{prefix}#{str}") unless @options['quiet']
    return this

  @info: ->
    args = (v for i, v of arguments)
    args.unshift(Logger.prefix.info.green)
    console.log.apply(this, args)

  @warn: ->
    args = (v for i, v of arguments)
    args.unshift(Logger.prefix.warn.yellow)
    console.warn.apply(this, args)

  @err: ->
    args = (v for i, v of arguments)
    args.unshift(Logger.prefix.err.red)
    console.error.apply(this, args)

  info: ->
    Logger.info.apply(this, arguments)

  warn: ->
    Logger.warn.apply(this, arguments)

  err: ->
    Logger.err.apply(this, arguments)

module.exports = Logger