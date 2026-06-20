.PHONY: build check lint test

PYTHON ?= python3
override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

check:
	@"$(ROOT)/scripts/check-baseline.sh"

lint: check

test:
	@cd "$(ROOT)" && $(PYTHON) -m unittest discover -s tests -p "test*.py"

build: check
