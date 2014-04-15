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

