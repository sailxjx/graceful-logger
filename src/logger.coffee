colors = require('colors')
middleware = require('./middleware')

class Logger

  format: ->
    msgs = (v for i, v of arguments)
    if @options.format? and typeof @options.format is 'string'
      # matches = @options.format.match(/(\%s|\%t|.+?)/g)
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
    @prefix =
      info: 'info:'.green
      warn: 'WARN:'.yellow
      err: 'ERR!:'.red

  info: ->
    return console.log.apply(this, arguments) unless process.stdout.isTTY
    args = @format.apply(this, arguments)
    args.unshift(@prefix.info)
    console.log.apply(this, args)

  warn: ->
    return console.warn.apply(this, arguments) unless process.stderr.isTTY
    args = @format.apply(this, arguments)
    args.unshift(@prefix.warn)
    console.warn.apply(this, args)

  err: ->
    return console.error.apply(this, arguments) unless process.stderr.isTTY
    args = @format.apply(this, arguments)
    args.unshift(@prefix.err)
    console.error.apply(this, args)

module.exports = Logger