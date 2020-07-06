from fpska import Fpska
from fpska_controller import FpskaController


class TestFpskaController:
    def test_start(self):
        fpska = Fpska()
        fpska_controller = FpskaController(fpska)
        fpska_controller.start()
