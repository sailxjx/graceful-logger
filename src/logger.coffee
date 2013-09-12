colors = require('colors')

class Logger

  @prefix:
    info: 'info:'
    warn: 'WARN:'
    err: 'ERR!:'

  format: (msg) ->
    return @options.format.replace(/\%s/g, msg)
               .replace(/\%t/g, "#{new Date}") if @options.format?
    return msg

  constructor: (@options = {}) ->

  _log: (str, prefix = '') =>
    return @background(str) if @options['background']
    console.log("#{prefix}#{str}") unless @options['quiet']
    return this

  @info: ->
    return console.log.apply(this, arguments) unless process.stdout.isTTY
    args = (v for i, v of arguments)
    args.unshift(Logger.prefix.info.green)
    console.log.apply(this, args)

  @warn: ->
    return console.warn.apply(this, arguments) unless process.stderr.isTTY
    args = (v for i, v of arguments)
    args.unshift(Logger.prefix.warn.yellow)
    console.warn.apply(this, args)

  @err: ->
    return console.error.apply(this, arguments) unless process.stderr.isTTY
    args = (v for i, v of arguments)
    args.unshift(Logger.prefix.err.red)
    console.error.apply(this, args)

  info: ->
    msg = (str for i, str of arguments).join('')
    msg = @format(msg) if @options.format?
    Logger.info.apply(this, [msg])

  warn: ->
    msg = (str for i, str of arguments).join('')
    msg = @format(msg) if @options.format?
    Logger.warn.apply(this, [msg])

  err: ->
    msg = (str for i, str of arguments).join('')
    msg = @format(msg) if @options.format?
    Logger.err.apply(this, [msg])

  @logger: (options = {}) ->
    new Logger(options)

module.exports = Logger