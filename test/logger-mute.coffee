logger = require('../lib')

$logger = new logger.Logger()
$logger.format(null)

$logger.info('this is a message', 'hello')
$logger.warn({a: 'a', b: 'b'})
$logger.err(require('path'))

$logger2 = new logger.Logger()
$logger2.mute()

$logger2.info('this is a message', 'hello')
$logger2.warn({a: 'a', b: 'b'})
$logger2.err(require('path'))
