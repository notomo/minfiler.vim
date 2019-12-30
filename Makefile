test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" themis
	THEMIS_VIM=vim THEMIS_ARGS="-e -s" themis

doc:
	gevdoc --externals ./example/examples.vim

.PHONY: test
.PHONY: doc
