domain = require 'domain'
Logger = require './logger'
logger = new Logger

_callback = (err) ->
  logger.err(err.stack)
  process.domain.dispose() if process.domain?
  process.exit(1)

_uncaughtBounded = false

middleware = (options) ->

  process.on('uncaughtException', _callback) unless _uncaughtBounded
  _uncaughtBounded = true

  _middle = (req, res, callback = ->) ->
    dm = domain.create()

    if arguments.length is 1 and typeof arguments[0] is 'function'
      callback = arguments[0]
    else
      dm.add(req)
      dm.add(res)

      res.on 'close', ->
        dm.dispose()

      res.on 'finish', ->
        dm.dispose()

    dm.on 'error', (err) ->
      dm.dispose()
      _callback(err)

    dm.run(callback)

  return _middle

module.exports = middleware
