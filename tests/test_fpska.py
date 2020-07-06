from fpska import Fpska
import pytest


class TestFpska:
    def test_print(self):
        fpska = Fpska()
        fpska.print()

    @pytest.mark.parametrize("fpska_arguments", [
        {"mode": "run"},
        {"mode": "info"},
        {"mode": "check"}
    ])
    def test_fpska_arguments(self, fpska_arguments):
        fpska = Fpska(**fpska_arguments)
        fpska.print()
