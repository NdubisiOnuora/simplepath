.PHONY: clean-pyc clean-build docs clean

NOSE_FLAGS=-sv --with-doctest --rednose
COVER_CONFIG_FLAGS=--with-coverage --cover-package=simplepath,tests --cover-tests
COVER_REPORT_FLAGS=--cover-html --cover-html-dir=htmlcov
COVER_FLAGS=${COVER_CONFIG_FLAGS} ${COVER_REPORT_FLAGS}

help:
	@echo "install - install all requirements including for testing"
	@echo "clean - remove all artifacts"
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "clean-test - remove test and coverage artifacts"
	@echo "clean-test-all - remove all test-related artifacts including tox"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "test-coverage - run tests with coverage report"
	@echo "test-all - run tests on every Python version with tox"
	@echo "check - run all necessary steps to check validity of project"
	@echo "release - package and upload a release"
	@echo "dist - package"
	@echo "docs - generate Sphinx HTML documentation, including API docs"

install:
	pip install -r requirements-dev.txt

clean: clean-build clean-pyc clean-test-all

clean-build:
	@rm -rf build/
	@rm -rf dist/
	@rm -rf *.egg-info

clean-pyc:
	-@find . -name '*.pyc' -follow -print0 | xargs -0 rm -f
	-@find . -name '*.pyo' -follow -print0 | xargs -0 rm -f
	-@find . -name '__pycache__' -type d -follow -print0 | xargs -0 rm -rf

clean-test:
	rm -rf .coverage coverage*
	rm -rf htmlcov/

clean-test-all: clean-test
	rm -rf .tox/

lint:
	flake8 simplepath tests

test:
	nosetests ${NOSE_FLAGS} tests/

test-coverage:
	nosetests ${NOSE_FLAGS} ${COVER_FLAGS} tests/

test-all:
	tox

check: clean-build clean-pyc clean-test lint test-coverage

release: clean
	python setup.py sdist upload

dist: clean
	python setup.py sdist
	ls -l dist

docs:
	rm -f docs/simplepath.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ simplepath
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	open docs/_build/html/index.html
