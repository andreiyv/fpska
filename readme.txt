fpska v0.1

1) устанавливаем Avisynth из архива (AviSynth_260.exe);
1.1) vtyztv dll'ку;
2) в файлике 50_60fps.avs в строчке:
ffmpegsource2(«видео.avi»)
меняем видео.avi на то что вы собираетесь перекодировать в 60fps (не обязательно avi может быть и mp4 и вообще любой видеоформат);
3) запускаем перекодирование пуском go.bat, перекодированный мувик будет в 50_60fps.avi.

1) git clone https://github.com/andreiyv/fpska.git
2) git fetch origin
3) git checkout -b fpska_v0.1 origin/fpska_v0.1
4) git push -u origin branch

https://www.svp-team.com/wiki/Download/ru
https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow