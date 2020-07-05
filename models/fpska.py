class Fpska:
    def __init__(self, **kwargs):
        self.mode = kwargs.get('mode', "info")
        self.verbose = kwargs.get('verbose', "false")
        self.log = kwargs.get('log', "on")

    def print(self):
        print("Fpska mode: ", self.mode)
        print("Fpska verbose: ", self.verbose)
        print("Fpska log: ", self.log)
