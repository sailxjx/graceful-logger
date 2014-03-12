all: test

test:
	@./node_modules/.bin/mocha --reporter spec test/test.js

.PHONY: all test
