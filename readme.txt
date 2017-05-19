AviSynth(32-bit) -> x264.exe(32-bit) (works fine for Win32 and Win64).

При кодировании 4K video требуется много памяти. Вся система у нас 32-битная, поэтому много памяти она адресовать не может.
Поэтому для x264 нужно подбирать настройки, чтобы не требовали много памяти (например от пресета veryslow пришлось отказаться).

1) устанавливаем Avisynth из архива (AviSynth_260.exe);
2) в файлике 50_60fps.avs в строчке:
ffmpegsource2(«видео.avi»)
меняем видео.avi на то что вы собираетесь перекодировать в 60fps (не обязательно avi может быть и mp4 и вообще любой видеоформат);
3) запускаем перекодирование пуском go.bat, перекодированный мувик будет в 50_60fps.avi.

git fetch origin
git checkout -b some_branch origin/some_branch

https://www.svp-team.com/wiki/Download/ru
https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow