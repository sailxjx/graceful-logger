should = require('should')
{fork} = require('child_process')
# logger = require('../lib/index.js')
# {Logger} = logger
# fs = require('fs')

# process.stdout.pipe(process.stdin)
# process.stdin.on 'data', ->
#   console.log 'fadfasdfas'

# describe 'logger#default', ->

#   it 'should output with the default format', (done) ->

#     logger.info('hello world')

describe 'logger#default', ->
  it 'should output without date', (done) ->
    child = fork("#{__dirname}/logger-default.coffee", [], {silent: true})
    output = ''
    needOutput = """
    info: this is a message hello
    warn: { a: 'a', b: 'b' }
    err!: [Function]\n
    """
    child.stdout.on 'data', (data) ->
      output += data.toString()
    child.stderr.on 'data', (data) ->
      output += data.toString()
    child.on 'exit', (err) ->
      return done(err) if err
      output.should.eql(needOutput)
      done()

describe 'logger#format', ->
  it 'should output with date', (done) ->
    child = fork("#{__dirname}/logger-format.coffee", [], {silent: true})
    lines = []
    child.stdout.on 'data', (data) ->
      lines.push data.toString()
    child.stderr.on 'data', (data) ->
      lines.push data.toString()
    child.on 'exit', (err) ->
      return done(err) if err
      for str in lines
        duration = new Date() - new Date(str.split(' ')[1][0...-1])
        duration.should.within(0, 1000)
      done()

  it 'should output nothing when use mute', (done) ->
    child = fork("#{__dirname}/logger-mute.coffee", [], {silent: true})
    data = ''
    child.stdout.on 'data', (_data) ->
      data += _data
    child.stderr.on 'data', (_data) ->
      data += _data
    child.on 'exit', (err) ->
      return done(err) if err
      data.should.eql('')
      done()

describe 'logger#error', ->
  it 'should output error info', (done) ->
    child = fork("#{__dirname}/logger-error.coffee", [], {silent: true})
    output = ''
    child.stderr.on 'data', (data) -> output += data
    child.on 'exit', (err) ->
      output.should.eql('err!: error info\n')
      done()

describe 'logger#exit', ->
  it 'should exit with error status 1', (done) ->
    child = fork("#{__dirname}/logger-exit.coffee", [], {silent: true})
    child.on 'exit', (err) ->
      err.should.eql(1)
      done()

describe 'logger#debug', ->
  it 'should not output anything without debug flag', (done) ->
    child = fork("#{__dirname}/logger-debug-null.coffee", [], {silent: true})
    output = ''
    child.stdout.on 'data', (data) -> output += data
    child.on 'exit', (err) ->
      output.should.be.eql('')
      done()

  it 'should output debug message by debug flag', (done) ->
    child = fork("#{__dirname}/logger-debug.coffee", [], {silent: true})
    output = ''
    child.stdout.on 'data', (data) -> output += data
    child.on 'exit', (err) ->
      output.should.be.eql('debug: debug message\n')
      done()
