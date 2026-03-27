PREFIX ?= $(HOME)/.local

.PHONY: install uninstall test setup

install:
	PREFIX=$(PREFIX) script/install

uninstall:
	PREFIX=$(PREFIX) script/uninstall

test:
	script/test

setup:
	PREFIX=$(PREFIX) script/setup
