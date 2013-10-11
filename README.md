Graceful-Logger
======
A simple, slim, graceful logger for Nodejs

```coffeescript
logger = require('../lib')

logger.info('this is a message', 'hello')
logger.warn({a: 'a', b: 'b'})
logger.err(require('path'))

# logger with options
logger1 = new logger.Logger({
  format: '%t - %s'
})

logger1.info('this is a message')
logger1.warn({a: 'a', b: 'b'})
logger1.err('this is an error')
```