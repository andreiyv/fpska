class Fpska:
    mode = "run"
    verbose = "true"
    log = "false"
    inputfile = ""

    def __init__(self, **kwargs):
        self.mode = kwargs.get('mode', "info")
        self.inputfile = kwargs.get('inputfile', "")
        self.verbose = kwargs.get('verbose', "false")
        self.log = kwargs.get('log', "/current/dir")

    def print(self):
        print("Fpska mode: ", self.mode)
        print("Fpska input: ", self.inputfile)
        print("Fpska verbose: ", self.verbose)
        print("Fpska log: ", self.log)
