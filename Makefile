.PHONY: build check lint test

PYTHON ?= python3

check:
	@scripts/check-baseline.sh

lint: check

test:
	@$(PYTHON) -m unittest discover -s tests -p "test*.py"

build: check
