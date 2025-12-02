# File: conftest.py
import pytest

def pytest_addoption(parser):
    parser.addoption("--tests", action="store", default=None, help="List of tests to run")