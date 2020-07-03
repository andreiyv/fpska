import os
import re
import sys
from subprocess import Popen, PIPE
from decimal import Decimal, ROUND_FLOOR, ROUND_UP
from fractions import Fraction


def find_fps(filename):

    if os.path.exists(filename):

        with open(filename, 'r', encoding='utf-8') as datafile:

            try:
                fps_in_log_file = None

                for fline in datafile:

                    if " fps," in fline:
                        try:
                            for s in fline.split(", "):
                                if "fps" in s:
                                    fps_in_log_file = s.replace(' fps', '')
                        except AttributeError:
                            print("Error getting fps from ", filename)
                        break
            except:
                print("Problem with opening ", filename)
    else:
        return None

    return fps_in_log_file


def setfps(arg1, arg2, arg3, arg4, arg5):
    fps_str = find_fps(arg1)
    if fps_str == None:
        return 0
    fps = Decimal(fps_str)
    if fps >= Decimal("55"):
        print("*******Видео уже в 60 fps!*******\n",
              f"...Ну почти (в {fps} fps)\n" if fps < Decimal("60") else "", sep="")
        return 0

    mult = Decimal("60") / fps.quantize(Decimal("1"), ROUND_UP)
    multq = mult.quantize(Decimal("1.0"), ROUND_UP)
    frac = Fraction(multq)
    num = frac.numerator
    den = frac.denominator
#    print(f"[DEBUG] num={num} den={den} multq={multq}")

    with open(arg2, encoding='utf-8') as fd1, open(arg3, 'w', encoding='utf-8') as fd2:
        for line in fd1:
            line = line.replace("vnm", str(num))
            line = line.replace("vdn", str(den))
            fd2.write(line)
    try:
        os.rename(arg3, arg2)
    except WindowsError:
        os.remove(arg2)
        os.rename(arg3, arg2)

    varg = '''--Inform=Video;%%FrameCount%%'''
    process = Popen([arg4, varg, arg5], stdout=PIPE)
    (output, err) = process.communicate()
    exit_code = process.wait()
    nframes = re.sub('[^0-9]', '', str(output))
#    print("Частота кадров в исходном видео: ", fps, "fps")
#    print("Частота кадров в выходном видео: ", fps*num/den, "fps")
#    print("Количество кадров в исходном видео: ", nframes)
#    print("Количество кадров в выходном видео (примерно): ",
#          int(int(nframes)*num/den))
    return int(int(nframes)*num/den)


if __name__ == "__main__":
    result = setfps(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    exit(0 if result else 1)
