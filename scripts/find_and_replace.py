import sys
import os


def find_and_replace(arg1, arg2, arg3, arg4):
    with open(arg3, encoding='utf-8') as fd1, open(arg4, 'w', encoding='utf-8') as fd2:
        for line in fd1:
            line = line.replace(arg1, arg2)
            fd2.write(line)
    try:
        os.rename(arg4, arg3)
    except WindowsError:
        os.remove(arg3)
        os.rename(arg4, arg3)


if __name__ == "__main__":
    find_and_replace(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
