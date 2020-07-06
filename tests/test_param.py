import pytest


#pytest -q -s --name test tests\test_param.py
# command line arguments testing
@pytest.fixture()
def name(pytestconfig):
    return pytestconfig.getoption("name")


def test_print_name(name):
        print(f"\ncommand line param (name): {name}")


def test_print_name_2(pytestconfig):
    print(f"test_print_name_2(name): {pytestconfig.getoption('name')}")