logger = require('../lib')

$logger = new logger.Logger({
  custom: ->
    @prefix = if process.stdout.isTTY then @prefixs[@level][@levels[@level].color] else @prefixs[@level]
    msgs = (v for i, v of arguments)
    msgs.unshift('This is a custom log: ')
    msgs.unshift(@prefix)
    @levels[@level].method.apply(this, msgs)
})

$logger.info('this is a message', 'hello')
$logger.warn({a: 'a', b: 'b'})
$logger.err(require('path'))
