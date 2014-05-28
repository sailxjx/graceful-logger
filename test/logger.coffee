util = require 'util'
fs = require 'fs'
path = require 'path'
should = require 'should'
colors = require 'colors'
{Logger} = require '../lib/index.js'

output = ''

describe 'logger#default', ->
  logger = new Logger
  logger.setStream 'all'
  , write: (msg) -> output = msg

  promise = (str, prefix) ->
    str = util.format.call(util, str)
    return "#{prefix}#{str}" + '\n'

  it 'should output without date', ->
    msg = 'this is a message'
    logger.info(msg)
    output.should.eql(promise(msg, 'info '))

    msg = { a: 'a', b: 'b' }
    logger.warn(msg)
    output.should.eql(promise(msg, 'warn '))

    msg = require('path')
    logger.err(msg)
    output.should.eql(promise(msg, 'err! '))

describe 'logger#format', ->
  logger = new Logger
  logger.setStream 'all'
  , write: (msg) -> output = msg

  it 'should output with date', ->
    logger.format('medium')
    logger.info('hello')
    date = output.split(' ')[1][0...-1]
    (new Date - new Date(date)).should.within(0, 100)

  it 'should output with custom format', ->
    logger.format(':date')
    logger.info('anything')
    (new Date - new Date(output.trim())).should.within(0, 100)

describe 'logger#mute', ->
  logger = new Logger
  logger.setStream 'all'
  , write: (msg) -> output = msg

  it 'should output nothing when use mute', ->
    output = ''
    logger.mute()
    logger.info('anything')
    output.should.eql('')

describe 'logger#debug', ->

  it 'should not output anything without debug flag', ->
    logger = new Logger
    logger.setStream 'all'
    , write: (msg) -> output = msg
    output = ''
    logger.debug('anything')
    output.should.eql('')

  it 'should output debug message by debug flag', ->
    logger = new Logger(debug: 1)
    logger.setStream 'all'
    , write: (msg) -> output = msg
    logger.debug('debug message')
    output.should.be.eql('debug debug message\n')

describe 'logger#setStream', ->
  file = path.join(__dirname, 'debug.txt')

  it "should pipe message stream to #{file}", (done) ->
    logger = new Logger
    logger.setStream 'info', fs.createWriteStream(file)
    msg = 'debug stream'
    logger.info(msg)
    fs.readFile file
    , encoding: 'utf-8'
    , (err, content) ->
      content.should.eql("info #{msg}\n")
      fs.unlink(file, done)

describe 'logger#importUse', ->
  logger = new Logger
  logger.setStream 'all'
  , write: (msg) -> output = msg

  it 'should output message when use info as a single method', ->
    {info} = logger
    info('hello')
    output.should.eql('info hello\n')

  it 'should also work for alias', ->
    {error} = logger
    error('error')
    output.should.eql('err! error\n')

describe 'logger#mod', ->

  logger = new Logger(':level.color :msg', debug: 1)
  logger.setStream 'all',
    write: (msg) -> output = msg
    isTTY: true

  it 'should output a customized level and color', ->
    ['info', 'warn', 'err', 'debug'].forEach (level) ->
      logger[level].color = 'blue'
      logger[level].level = "user#{level}"
      logger[level] '%s', 'hello'
      output.should.eql("user#{level}".blue + ' hello\n')

describe 'logger#othercolor', ->

  it 'should output the blue message', ->
    logger = new Logger(':msg.blue')
    logger.setStream 'all',
      write: (msg) -> output = msg
      isTTY: true
    logger.info('hello')
    output.should.eql 'hello'.blue + '\n'

describe 'logger#numeric', ->

  it 'should output the grey title and white message', ->
    logger = new Logger(':0.grey :1.white')
    logger.setStream 'all',
      write: (msg) -> output = msg
      isTTY: true
    logger.info 'hello', 'world'
    output.should.eql 'hello'.grey + ' ' + 'world'.white + '\n'
