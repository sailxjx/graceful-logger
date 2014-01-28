logger = require('../lib')

logger.info('Hello', 'World!')
logger.warn({a: 'a', b: 'b'})
logger.err(-> "This is a function")

logger.format('medium')

logger.info('Hello', 'World!')
logger.warn({a: 'a', b: 'b'})
logger.err(-> "This is a function")
