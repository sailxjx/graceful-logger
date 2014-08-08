Benchmark = require 'benchmark'
suite = new Benchmark.Suite
Log = require('log')
log = new Log('error', process.stderr)
logger = require '../'

msg = 'This is a stringified message'
obj = {
  "mode": "mode",
  "bold": "bold",
  "underline": "underline",
  "strikethrough": "strikethrough",
  "italic": "italic",
  "inverse": "inverse",
  "grey": "grey",
  "black": "black",
  "yellow": "yellow",
  "red": "red",
  "green": "green",
  "blue": "blue",
  "white": "white",
  "cyan": "cyan",
  "magenta": "magenta",
  "greyBG": "greyBG",
  "blackBG": "blackBG",
  "yellowBG": "yellowBG",
  "redBG": "redBG",
  "greenBG": "greenBG",
  "blueBG": "blueBG",
  "whiteBG": "whiteBG",
  "cyanBG": "cyanBG",
  "magentaBG": "magentaBG",
  "themes": "themes",
  "addSequencer": "addSequencer",
  "rainbow": "rainbow",
  "zebra": "zebra",
  "setTheme": "setTheme",
  "stripColors": "stripColors",
  "zalgo": "zalgo"
}

console.log "graceful-logger benchmark start..."

suite
.add 'console', ->
  console.error msg, obj
.add 'log', ->
  log.error msg, obj
.add 'graceful-logger', ->
  logger.err msg, obj
.on 'cycle', (event) ->
  console.log String(event.target)
.on 'complete', ->
  console.log 'fastest is ' + @filter('fastest').pluck('name')
.run()
