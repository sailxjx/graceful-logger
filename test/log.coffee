Logger = require('../lib/logger')

Logger.info('this is a message', 'hello')
Logger.warn({a: 'a', b: 'b'})
Logger.err(require('path'))

logger = new Logger({
  format: '%t - %s'
  })

logger.info('this is a message')
logger.warn('this is a warning')
logger.err('this is an error')

