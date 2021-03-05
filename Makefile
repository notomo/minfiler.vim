THEMIS_BIN ?= themis

test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" $(MAKE) _test
	THEMIS_VIM=vim THEMIS_ARGS="-e -s" $(MAKE) _test
.PHONY: test

_test:
	${THEMIS_BIN}
.PHONY: _test

doc:
	gevdoc --externals ./doc/examples.vim ./doc/introduction
.PHONY: doc
