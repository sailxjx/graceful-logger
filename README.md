Graceful-Logger
======
A simple, slim, graceful logger for Nodejs

[![build status](https://api.travis-ci.org/sailxjx/graceful-logger.png)](https://travis-ci.org/sailxjx/graceful-logger)

# Capture

![capture](https://raw.github.com/sailxjx/graceful-logger/master/capture/capture.png)

# Example
```coffeescript
logger = require('../lib')

logger.info('Hello', 'World!')
logger.warn({a: 'a', b: 'b'})
logger.err(-> "This is a function")

logger.format('medium')

logger.info('Hello', 'World!')
logger.warn({a: 'a', b: 'b'})
logger.err(-> "This is a function")

# Other features
## Output multi lines
logger.info '''
This is a multi line message:
Hello everyone.
Have a nice day!
'''

## Output required package
logger.info require('path')

## Output empty message
logger.info()

## Define any colors
logger.format ':level.blue :msg.grey'
logger.info('hello world')

## Use the numeric placeholder
logger.format ':level :0.grey :1.blue'
logger.info('hello', 'world')
```

# Benchmark
```
Console x 5,367 ops/sec ±2.96% (89 runs sampled)  # console.log
Log x 5,556 ops/sec ±1.76% (93 runs sampled)      # The tiny log module written by tj
Logger x 5,612 ops/sec ±0.95% (96 runs sampled)   # This module
Fastest is Logger,Log,Console
```

# ChangeLog
## 0.4.0
1. Remove multi-line prefix (v0.3.1) for the sake of efficiency
2. User can define any color of the message by `.(color)` format, but it only works after the `:(label)` expression, e.g. `:level.green :msg.grey`
3. The `:msg` flag now support numbers for express the message of the correct index, e.g. `:1.green :2.grey`, and you will get an  green 'hello' and a grey 'world' by using `logger.info('hello', 'world')`. Remember, the index start from 0.

## 0.3.2
1. User can redefine `color` and `level` prefix by set the `color` and `level` property of each method.

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
