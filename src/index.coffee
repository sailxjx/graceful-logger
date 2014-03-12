Logger = require './logger'

logger = new Logger()
logger.Logger = Logger
logger.middleware = require('./middleware')

module.exports = logger
