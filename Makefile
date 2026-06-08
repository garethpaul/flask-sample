.PHONY: check test

PYTHON ?= python3

check:
	@scripts/check-baseline.sh

test:
	@$(PYTHON) -m unittest discover -s tests -p "test*.py"
