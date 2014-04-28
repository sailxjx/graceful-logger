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

suite
.add 'Console', ->
  console.error msg, obj
.add 'Log', ->
  log.error msg, obj
.add 'Logger', ->
  logger.err msg, obj
.on 'cycle', (event) ->
  console.log String(event.target)
.on 'complete', ->
  console.log 'Fastest is ' + @filter('fastest').pluck('name')
.run()
