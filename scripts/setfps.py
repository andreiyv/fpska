import os
import re
import sys


def find_fps(filename):
#    print("find_fps: ", filename)
    with open(filename, 'r') as datafile:

        fps_in_log_file = None

        for fline in datafile:
            if "fps" in fline:
                try:
                    for s in fline.split(", "):
                        if "fps" in s:
                            fps_in_log_file = s.replace(' fps', '')

                except AttributeError:
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print("Error getting fps from ", filename)
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                break

    return fps_in_log_file


fps = find_fps(sys.argv[1])
#fps = find_fps("C:\\Users\\Andrey\\fpska\\tmp\\ffprobe.log")

#print (fps)

if abs(float(fps)-15.0) < 0.1:
    num = 8
    den= 2
if abs(float(fps)-24.0) < 0.1:
    num = 5
    den= 2
elif abs(float(fps)-25.0) < 0.1:
    num = 12
    den = 5
elif abs(float(fps)-30.0) < 0.1:
    num = 2
    den = 1
elif abs(float(fps)-50.0) < 0.1:
    num = 6
    den = 5

else:
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print ("fpska ne rabotaet s takim fps")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

# print("num: ", num, " den: ", den)

with open(sys.argv[2]) as fd1, open(sys.argv[3], 'w') as fd2:
    for line in fd1:
        line = line.replace("vnm", str(num))
        line = line.replace("vdn", str(den))
        fd2.write(line)
try:
    os.rename(sys.argv[3], sys.argv[2])
except WindowsError:
    os.remove(sys.argv[2])
    os.rename(sys.argv[3], sys.argv[2])