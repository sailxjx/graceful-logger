logger = require('../lib')

logger.info('this is a message', 'hello')
logger.warn({a: 'a', b: 'b'})
logger.err(-> console.log 'hello')
