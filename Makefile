all: test

test:
	@./node_modules/.bin/mocha --reporter spec --compilers coffee:coffee-script test/test.coffee

.PHONY: all test
