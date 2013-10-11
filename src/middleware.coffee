domain = require('domain')
Logger = require('./logger')
logger = new Logger({
  format: '%t - %s'
})

middleware = (options) ->

  _middle = (req, res, callback = ->) ->
    dm = domain.create()
    dm.add(req)
    dm.add(res)

    res.on 'close', ->
      dm.dispose()

    res.on 'finish', ->
      dm.dispose()

    dm.on 'error', (err) ->
      dm.dispose()
      logger.err(err.stack)
      process.exit(1)

    process.on 'uncaughtException', dm.intercept()

    dm.run(callback)

  return _middle

module.exports = middleware