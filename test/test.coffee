should = require('should')
{fork} = require('child_process')

describe 'logger#default', ->
  it 'should output without date', (done) ->
    child = fork("#{__dirname}/logger-default.coffee", [], {silent: true})
    output = ''
    needOutput = """
    info: this is a message hello
    WARN: { a: 'a', b: 'b' }
    ERR!: { resolve: [Function],
      normalize: [Function],
      join: [Function],
      relative: [Function],
      sep: '/',
      delimiter: ':',
      dirname: [Function],
      basename: [Function],
      extname: [Function],
      exists: [Function: deprecated],
      existsSync: [Function: deprecated],
      _makeLong: [Function] }\n
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
        duration = new Date() - new Date(str[str.indexOf(':')+2..str.indexOf('-')-2])
        duration.should.within(0, 1000)
      done()

describe 'logger#custom', ->
  it 'should output with custom prefix', (done) ->
    child = fork("#{__dirname}/logger-custom.coffee", [], {silent: true})
    output = ''
    needOutput = """
    info: This is a custom log:  this is a message hello
    WARN: This is a custom log:  { a: 'a', b: 'b' }
    ERR!: This is a custom log:  { resolve: [Function],
      normalize: [Function],
      join: [Function],
      relative: [Function],
      sep: '/',
      delimiter: ':',
      dirname: [Function],
      basename: [Function],
      extname: [Function],
      exists: [Function: deprecated],
      existsSync: [Function: deprecated],
      _makeLong: [Function] }\n
    """
    child.stdout.on 'data', (data) ->
      output += data.toString()
    child.stderr.on 'data', (data) ->
      output += data.toString()
    child.on 'exit', (err) ->
      return done(err) if err
      output.should.eql(needOutput)
      done()

describe 'logger#error', ->
  it 'should exit with error status 1', (done) ->
    child = fork("#{__dirname}/logger-error.coffee", [], {silent: true})
    child.on 'exit', (err) ->
      err.should.eql(1)
      done()