colors = require('colors')

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
      info: 'info:'
      warn: 'WARN:'
      err: 'ERR!:'

  info: ->
    args = @format.apply(this, arguments)
    prefix = if process.stdout.isTTY then @prefix.info.green else @prefix.info
    args.unshift(prefix)
    console.log.apply(this, args)

  warn: ->
    args = @format.apply(this, arguments)
    prefix = if process.stdout.isTTY then @prefix.warn.yellow else @prefix.warn
    args.unshift(prefix)
    console.warn.apply(this, args)

  err: ->
    args = @format.apply(this, arguments)
    prefix = if process.stdout.isTTY then @prefix.err.red else @prefix.err
    args.unshift(prefix)
    console.error.apply(this, args)

module.exports = Logger