Graceful-Logger
======
A simple, slim, graceful logger for Nodejs

[![build status](https://api.travis-ci.org/sailxjx/graceful-logger.png)](https://travis-ci.org/sailxjx/graceful-logger)

# Capture

![capture](https://raw.github.com/sailxjx/graceful-logger/master/capture/capture.png)

# Example
```coffeescript
logger = require('../lib')

logger.info('this is a message', 'hello')
logger.warn({a: 'a', b: 'b'})
logger.err(require('path'))

# logger with options
# Initial with format
logger1 = new logger.Logger('color([:level :date]) - :msg')
# Or use format method
logger2 = require('graceful-logger').format('color([:level :date]) - :msg')

logger1.info('this is a message')
logger1.warn({a: 'a', b: 'b'})
logger1.err('this is an error')
```

# ChangeLog
## 0.3.1
1. Add prefix to each line when messages have multi lines.

## 0.3.0
1. Write message to process.stdout or process.stderr stream
2. Use `util.format` to format object/function/array etc, as the same of `console.log`
3. Add `setStream` and `getStream` to `get/set` writable stream of each method
4. Add `error` as alias of `err`, `warning` as alias of `warn`

## 0.2.1
1. Move exit feature from logger.err to logger.exit

## 0.2.0
1. Use meanful tags such as :date, :level, etc...
2. Remove custom prefix
3. Use JSON.stringify to output objects

# License

MIT
