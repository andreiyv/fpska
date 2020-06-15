import wx
import sys
import os
import threading
import subprocess
import re
from time import time

sys.path.append("{}\\scripts".format(os.getcwd()))
from find_and_replace import *
from setfps import *

fpska_version = '0.9.1'

def arrjoin(arr):
    out = ""
    for item in arr:
        out += '"' + str(item) + '"' + ' '
    return out

def etfromseconds(s):
    hours = s // 3600
    s -= hours * 3600
    mins = s // 60
    s -= mins * 60
    hours = int(hours)
    mins = int(mins)
    s = int(s)
    return "{:02d}:{:02d}:{:02d}".format(hours, mins, s)


def OnStartButtonPress_thr(self, event):
    self.modesbox.Disable()
    self.flist.Unbind(wx.EVT_KEY_UP)
    self.startbutton.Unbind(wx.EVT_BUTTON)
    self.startbutton.Disable()
    starttime = time()
    print(
        f"Start!\nSource files = {self.srcfiles}\nMode = {self.modesbox.GetValue()}")
    for srcfile in self.srcfiles:
        self.gauge.Pulse()
        self.flist.SetString(self.flist.GetStrings().index(
            srcfile), " ".join(["(RUNNING | ЗАПУЩЕНО)", srcfile]))
        st = "DONE | ЗАВЕРШЕНО" if fpskaStart(
            self, srcfile, self.modesbox.GetValue()) else "ERROR | ОШИБКА"
        self.flist.SetString(self.flist.GetStrings().index(
            " ".join(["(RUNNING | ЗАПУЩЕНО)", srcfile])), " ".join([f"({st})", srcfile]))
        self.gauge.SetValue(0)
    endtime = time()
    print(f"\nЗатрачено времени: {etfromseconds(endtime - starttime)}\n")
    self.srcfiles = []
    self.flist.Bind(wx.EVT_KEY_UP, self.OnKeyPress)
    self.startbutton.Bind(wx.EVT_BUTTON, self.OnStartButtonPress)
    self.modesbox.Enable()

def fpskaStart(self, src, mode):
    print(f"~{src}~")
    method = self.modes.index(mode)
    ncpu = os.cpu_count()
    container = ""
    audio_codec = ""
    audio_pcm = False
    os.system('rmdir /S/Q ".\\tmp"')
    os.mkdir(".\\tmp")
    print("[Шаг 1/5] Извлекаем информацию о видео и аудио кодеках из видеофайла")
    el = os.system(
        '.\\ffmpeg\\bin\\ffprobe.exe -i "{}"  2> ".\\tmp\\ffprobe.log"'.format(src))
    if el == 0:
        print("Информация извлечена успешно")
    else:
        print("Ошибка извлечения информации")
        return False
    el = os.system(
        'findstr /m /c:"Audio: aac" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        audio_codec = "aac"
    el = os.system(
        'findstr /m /c:"Audio: ac3" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        audio_codec = "ac3"
    el = os.system(
        'findstr /m /c:"Audio: mp3" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        audio_codec = "mp3"
    el = os.system(
        'findstr /m /c:"Audio: wmav" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        audio_codec = "wma"
    el = os.system(
        'findstr /m /c:"Audio: pcm_" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        print("Внимание! В видеофайле содержится звуковая дорожка в формате PCM.\n"
              "В настоящее время fpsk'а не может обрабатывать такой тип audio.\n"
              "Поэтому будет сделано преобразование в 60fps для видеодорожки,\n"
              "но финальная склейка 60fps video и audio производится не будет.\n"
              "Все файлы будут находиться в папке tmp.")
        audio_pcm = True
    el = os.system(
        'findstr /m "matroska" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        container = "mkv"
    el = os.system(
        'findstr /m /c:"mov,mp4,m4a,3gp,3g2,mj2" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        container = "mp4"
    el = os.system(
        'findstr /m /c:"mpegts" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        container = "mpegts"
    el = os.system(
        'findstr /m /c:"avi," ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        container = "avi"
    el = os.system(
        'findstr /m /c:"Video: mpeg2video" ".\\tmp\\ffprobe.log" >NUL')
    if el == 0:
        container = "mpeg2"
    print("[Шаг 2/5] Извлекаем звуковую дорожку из исходного видеофайла")
    if len(audio_codec) != 0:
        el = os.system(
            '.\\ffmpeg\\bin\\ffmpeg.exe -y -i "{}" -vn -acodec copy ".\\tmp\\60fps_audio.{}" -v quiet'.format(src, audio_codec))
    else:
        if container in ["mkv", "mpegts"]:
            os.system('copy "{}" ".\\tmp" >NUL'.format(src))
            os.chdir(".\\tmp")
            el = os.system(
                '..\\eac3to\\eac3to.exe "{}" -demux >NUL'.format(os.path.split(src)[1]))
            os.remove(os.path.split(src)[1])
            os.system('del *.txt >NUL 2>NUL')
            os.system('del *.h264 >NUL 2>NUL')
            os.system('del *.vc1 >NUL 2>NUL')
            os.chdir(".\..")
    if el == 0:
        print("Звуковая дорожка извлечена успешно")
    else:
        print("Ошибка извлечения звуковой дорожки")
        return False
    print("[Шаг 3/5] Создаем скрипт для Vapoursynth из шаблона")
    try:
        os.remove(".\\scripts\\work.pvy")
    except:
        pass
    if method == 0:
        os.system(
            'copy ".\\scripts\\fpska_fast.pvy" ".\\scripts\\work.pvy" >NUL')
    elif method == 1:
        os.system(
            'copy ".\\scripts\\fpska_medium.pvy" ".\\scripts\\work.pvy" >NUL')
    elif method == 2:
        os.system(
            'copy ".\\scripts\\fpska_slow.pvy" ".\\scripts\\work.pvy" >NUL')
    elif method == 3:
        os.system(
            'copy ".\\scripts\\fpska_slow.pvy" ".\\scripts\\work.pvy" >NUL')
    txt = ".\\scripts\\work.pvy"
    find_and_replace("fullhd.mkv", src, txt, ".\\scripts\\s.txt")
    find_and_replace("nthreads", str(ncpu), txt, ".\\scripts\\s.txt")
    grange = setfps(".\\tmp\\ffprobe.log", txt, ".\\scripts\\s.txt", ".\\Mediainfo_CLI\\MediaInfo.exe", src)
    if grange == 0:
        return False
    self.gauge.SetRange(grange)
    if os.path.exists(".\\scripts\\work.pvy"):
        print("Скрипт для Vapoursynth создан успешно")
    else:
        print("Ошибка создания Vapoursynth скрипта")
        return False
    print("[Шаг 4/5] Создаем видео с частотой 60 fps")
    ffmpeg_presets = ['libx264 -crf 24 -preset fast .\\tmp\\60fps_video.mp4',
                      'libx264 -crf 24 -preset medium .\\tmp\\60fps_video.mp4',
                      'libx264 -crf 20 -preset slow .\\tmp\\60fps_video.mp4',
                      'huffyuv .\\tmp\\60fps_video.avi']
    cmd_vspipe = ['.\\python\\VSPipe.exe', '--y4m', '.\\scripts\\work.pvy', '-']
    cmd_ffmpeg = ['.\\ffmpeg\\bin\\ffmpeg.exe', '-y', '-i', 'pipe:', '-c:a', 'copy',
                  '-c:v'] + ffmpeg_presets[method].split(' ') + ['-v', 'quiet', '-stats']
    vspipe = subprocess.Popen(cmd_vspipe, stdout=subprocess.PIPE)
    ffmpeg = subprocess.Popen(cmd_ffmpeg, stdin=vspipe.stdout, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
    self.startbutton.SetLabel("ETA: ~")
    self.startbutton.Enable()
    for line in iter(ffmpeg.stdout.readline, ''):
        prog = re.findall(r"(?:\d+(?:\.\d*)?|\.\d+)", line)
        if prog != None:
            frame = int(prog[0])
            fps = float(prog[1])
            if fps == 0.0:
                self.gauge.SetValue(frame)
                self.startbutton.SetLabel(f"ETA: ~ ({frame}/~{grange}) fps={fps}")
            else:
                eframes = abs(grange - frame)
                eunix = eframes / fps
                etime = etfromseconds(eunix)
                self.gauge.SetValue(frame)
                self.startbutton.SetLabel(f"ETA: {etime} ({frame}/~{grange}) fps={fps}")
    el = ffmpeg.wait()
    self.startbutton.Disable()
    self.startbutton.SetLabel("Запуск | Start")
    if el == 0:
        print("Видео с частотой 60 fps cоздано успешно")
    else:
        print("Ошибка создания видео с частотой 60 fps")
        return False
    print("[Шаг 5/5] Склеиваем видео и звуковую дорожку")
    try:
        os.remove(".\\tmp\\ffprobe.log")
    except:
        pass
    if method == 3:
        if os.path.exists(f"{src}_fpska_60fps"):
            os.system(f'rmdir /S/Q "{src}_fpska_60fps"')
        else:
            os.mkdir(f"{src}_fpska_60fps")
        os.system("copy .\\tmp {}_fpska_60fps".format(src))
        print("Конвертирование в 60 fps завершено\n"
              "Видео и звуковые дорожки скопированы в {}_fpska_60fps".format(src))
    else:
        if os.path.exists(".\\tmp\\60fps_audio.wma"):
            print(
                "mkvmerge не работает с wma, поэтому сконвертируем звуковую дорожку в mp3")
            os.system(
                ".\\ffmpeg\\bin\\ffmpeg.exe -i .\\tmp\\60fps_audio.wma -b:a 320k .\\tmp\\60fps_audio.mp3 -v quiet")
            os.remove(".\\tmp\\60fps_audio.wma")
        if audio_pcm == False:
            os.chdir(".\\tmp")
            el = os.system(
                '..\\mkvtoolnix\\mkvmerge.exe {}-o "{}_fpska_60fps.mkv" >NUL'.format(arrjoin(os.listdir(".")), src))
            os.chdir(".\..")
            if el == 0:
                print("Видео и звуковая дорожка объединены успешно")
            else:
                print("Ошибка при объединении видео и звуковой дорожки")
                return False
    try:
        os.remove(f"{src}.ffindex")
    except:
        pass
    print("Done!")
    return True

app = wx.App()

mainfontstyle = wx.Font(11, wx.FONTFAMILY_DEFAULT,
                    wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL, False, "Calibri")
consolefontstyle = wx.Font(10, wx.FONTFAMILY_DEFAULT,
                    wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL, False, "Consolas")

class FileDnD(wx.FileDropTarget):
    def __init__(self, win):
        wx.FileDropTarget.__init__(self)
        self.window = win
    def OnDropFiles(self, x, y, filenames):
        for fp in filenames:
            if os.path.splitext(fp)[1] in [".mp4", ".avi", ".mkv", ".m2ts", ".mov", ".3gp", ".3g2"]:
                if self.window.srcfiles.count(fp) == 0:
                    self.window.srcfiles.append(fp)
                    self.window.flist.Insert(fp, 0)
                    self.window.startbutton.Enable()
        return True

class gstdout():
    def __init__(self, tctrl):
        self.tctrlout = tctrl
    def write(self, text):
        wx.CallAfter(self.tctrlout.WriteText, text)


class MainWindow(wx.Frame):
    def __init__(self):
        wx.Frame.__init__(self, None, title=f"fpska-{fpska_version}-gui", style=wx.MINIMIZE_BOX |
                          wx.SYSTEM_MENU | wx.CAPTION | wx.CLOSE_BOX | wx.CLIP_CHILDREN)
        self.panel = wx.Panel(self)
        self.srcfiles = []
        self.fdt = FileDnD(self)
        self.panel.SetDropTarget(self.fdt)
        self.SetBackgroundColour(wx.Colour(255, 255, 255))
        self.vsizer = wx.BoxSizer(wx.VERTICAL)
        self.modesizer = wx.BoxSizer(wx.HORIZONTAL)
        self.flist = wx.ListBox(self.panel, style=wx.LB_EXTENDED | wx.LB_HSCROLL, size=(335, 100))
        self.modelabel = wx.StaticText(self.panel, label="Режим | Mode: ")
        self.startbutton = wx.Button(self.panel, label="Запуск | Start")
        self.console = wx.TextCtrl(self.panel, style=wx.TE_MULTILINE | wx.TE_READONLY, size=(335, 200))
        self.gauge = wx.Gauge(self.panel)
        self.modelabel.SetFont(mainfontstyle)
        self.startbutton.SetFont(mainfontstyle)
        self.startbutton.Disable()
        self.console.SetFont(consolefontstyle)
        self.startbutton.Bind(wx.EVT_BUTTON, self.OnStartButtonPress)
        self.modes = ["быстрый | fast", "средний | medium", "медленный | slow", "без потерь | lossless"]
        self.modesbox = wx.ComboBox(self.panel, choices=self.modes,
                                    style=wx.CB_READONLY | wx.CB_DROPDOWN, value=self.modes[0])
        self.modesbox.SetFont(mainfontstyle)
        self.modesizer.Add(self.modelabel, 1, wx.ALIGN_CENTER_VERTICAL | wx.LEFT, 5)
        self.modesizer.Add(self.modesbox, 1, wx.EXPAND)
        self.vsizer.Add(self.flist, 0, wx.EXPAND)
        self.vsizer.Add(self.modesizer, 0, wx.EXPAND)
        self.vsizer.Add(self.console, 0, wx.EXPAND)
        self.vsizer.Add(self.gauge, 0, wx.EXPAND)
        self.vsizer.Add(self.startbutton, 0, wx.EXPAND)
        self.panel.SetSizer(self.vsizer)
        self.vsizer.Fit(self)
        self.flist.Bind(wx.EVT_KEY_UP, self.OnKeyPress)
        self.Show(True)
        self.stdout = gstdout(self.console)
        sys.stdout = self.stdout
        print(
            f"~fpska-{fpska_version}-gui~\n"
            f"Вы можете перетаскивать сюда файлы\n"
            f"You can use drag&drop here!\n"
            f"Чтобы удалить файлы из очереди, выделите их и нажмите DELETE\n"
            f"Select files and press DELETE to remove them from the queue")
    def OnKeyPress(self, event):
        if event.GetKeyCode() == wx.WXK_DELETE:
            todel = self.flist.GetSelections()
            todelstr = []
            for itemidx in todel:
                todelstr.append(self.flist.GetString(itemidx)) 
            for itemstr in todelstr:
                self.flist.Delete(self.flist.GetStrings().index(itemstr))
                try:
                    self.srcfiles.remove(itemstr)
                except ValueError:
                    pass
            if len(self.srcfiles) == 0:
                self.startbutton.Disable()
        event.Skip()
    def OnStartButtonPress(self, event):
        thr = threading.Thread(target=OnStartButtonPress_thr, args=(self, event))
        thr.start()

if __name__ == "__main__":
    wnd = MainWindow()
    app.MainLoop()
