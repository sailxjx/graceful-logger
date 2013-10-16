logger = require('../lib')

logger.info('this is a message', 'hello')
logger.warn({a: 'a', b: 'b'})
logger.err(require('path'))

logger1 = new logger.Logger({
  format: '%t - %s'
})

logger1.info('this is a message', 'hello')
logger1.warn({a: 'a', b: 'b'})
logger1.err(require('path'))

logger2 = new logger.Logger({
  custom: ->
    @prefix = if process.stdout.isTTY then @prefixs[@level][@levels[@level].color] else @prefixs[@level]
    msgs = (v for i, v of arguments)
    msgs.unshift('This is a custom log: ')
    msgs.unshift(@prefix)
    @levels[@level].method.apply(this, msgs)
})

logger2.info('this is a message', 'hello')
logger2.warn({a: 'a', b: 'b'})
logger2.err(require('path'))