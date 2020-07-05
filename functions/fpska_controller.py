class FpskaController:

    def __init__(self, fpska):
        self.fpska = fpska
        pass

    def start(self):
        pass

    def print(self):
        print("FpskaController mode: ", self.fpska.mode)
        print("FpskaController verbose: ", self.fpska.verbose)
        print("FpskaController log: ", self.fpska.log)
