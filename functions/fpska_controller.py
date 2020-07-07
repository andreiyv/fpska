from fpska_tools import FpskaTools


class FpskaController:

    def __init__(self, fpska):
        self.fpska = fpska
        pass

    def run(self):
        pass

    def info(self):
        pass

    def tools(self):
        fpska_tools = FpskaTools()
        if not fpska_tools.check():
            fpska_tools.setup()

    def extract(self):
        pass

    def merge(self):
        pass

    def start(self):
        self.tools()

        if self.fpska.mode == "run":
            self.run()
        elif self.fpska.mode == "info":
            self.info()
        elif self.fpska.mode == "extract":
            self.extract()
        elif self.fpska.mode == "merge":
            self.merge()




