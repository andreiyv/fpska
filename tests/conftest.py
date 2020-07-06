import pytest

# this is for command line arguments testing
def pytest_addoption(parser):
    parser.addoption("--name", action="store", default="default name")