logger = require('../lib')

$logger = new logger.Logger('color([:level :date]) - :msg')

$logger.info('this is a message', 'hello')
$logger.warn({a: 'a', b: 'b'})
$logger.err(require('path'))

logger.format('color([:level :date]) - :msg')

logger.info('this is a message', 'hello')
logger.warn({a: 'a', b: 'b'})
logger.err(require('path'))
