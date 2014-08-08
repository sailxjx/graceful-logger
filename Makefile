all: test

test:
	@./node_modules/.bin/mocha --reporter spec test/test.js

bench:
	@coffee benchmark/benchmark.coffee 2>/dev/null

.PHONY: all test
