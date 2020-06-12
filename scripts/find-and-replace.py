import sys
import os
import tempfile


with open(sys.argv[3]) as fd1, open(sys.argv[4],'w') as fd2:
    for line in fd1:
        line = line.replace(sys.argv[1],sys.argv[2])
        fd2.write(line)
try:
	os.rename(sys.argv[4],sys.argv[3])
except WindowsError:
    os.remove(sys.argv[3])
    os.rename(sys.argv[4],sys.argv[3])