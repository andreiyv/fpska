import sys
import os
import tempfile


def find_and_replace(str1, str2, str3, str4):
    with open(str3) as fd1, open(str4, 'w') as fd2:
        for line in fd1:
            line = line.replace(str1, str2)
            fd2.write(line)
    try:
        os.rename(str4, str3)
    except WindowsError:
        os.remove(str3)
        os.rename(str4, str3)

