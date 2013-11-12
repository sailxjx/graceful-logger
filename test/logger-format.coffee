logger = require('../lib')

$logger = new logger.Logger({
  format: '%t - %s'
})

$logger.info('this is a message', 'hello')
$logger.warn({a: 'a', b: 'b'})
$logger.err(require('path'))
