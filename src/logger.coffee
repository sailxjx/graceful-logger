colors = require('colors')
middleware = require('./middleware')

class Logger

  format: (msg) ->
    return @options.format
                   .replace(/\%s/g, msg)
                   .replace(/\%t/g, "#{new Date}") if @options.format?
    return msg

  constructor: (@options = {}) ->
    @prefix =
      info: 'info:'
      warn: 'WARN:'
      err: 'ERR!:'

  info: ->
    return console.log.apply(this, arguments) unless process.stdout.isTTY
    msg = (str for i, str of arguments).join('')
    msg = @format(msg) if @options.format?
    console.log "#{@prefix.info.green} #{msg}"

  warn: ->
    return console.warn.apply(this, arguments) unless process.stderr.isTTY
    msg = (str for i, str of arguments).join('')
    msg = @format(msg) if @options.format?
    console.warn "#{@prefix.warn.yellow} #{msg}"

  err: ->
    return console.error.apply(this, arguments) unless process.stderr.isTTY
    msg = (str for i, str of arguments).join('')
    msg = @format(msg) if @options.format?
    console.error "#{@prefix.err.red} #{msg}"

module.exports = Logger