﻿# fpska v0.1

* С помощью этого скрипта можно перевести видео с частотой 25/30 кадров в секунду в видео с частотой 50/60 кадров в секунду, 
посредством создания и добавления промежуточных кадров. 
* Скрипт работает с видеороликами любого разрешения и любого формата.
* Для рассчета промежуточных кадров используется библиотека svpflow от команды svp-team.com.
В зависимости от разрешения исходного видео перекодирование в 50/60 fps может занимать очень много времени и требовать много машинной памяти,
так, например, перекодирование видео в формате 4K идет со скоростью 0.1fps, что очень медленно. Это обусловлено тем, 
что в программе рассчета промежуточных кадров используются настройки для достижения наилучшего качества вставляемых кадров.
Следует сказать, что данный скрипт планировался для перекодирования коротких по времени видеороликов (5-15 минут), 
поэтому все настройки были "взвинчены" на максимальный уровень.

## Установка
* устанавливаем Avisynth из архива distr\AviSynth_260.exe (устанавливаем, как обычное приложение, следуем инструкциям инсталлятора)
* копируем dll'ку distr\avisynth.dll в папки c:\Windows\SysWOW64\ и c:\Windows\System32\
Это многопоточная версия Avisynth библиотеки, специально собранная для работы сплагином svpflow;
* скачиваем библиотеку svpflow (http://www.svp-team.com/files/gpl/svpflow-4.0.0.128.zip), распаковываем архив,
файлы svpflow-4.0.0.128\lib-windows\avisynth\x32\svpflow1.dll и svpflow2.dll копируем в папку fpska\svpflow\.
Внимание, берем именно 32-битные файлы.

### Запуск
fpska.bat <файл с видео> <число процессоров>
Со скриптом поставляется тестовый видеоролик fullhd.mkv, запуск перекодирования будет выглядеть так:
```javascript
fpska.bat fullhd.mkv 4 
```

После того, как процесс кодирования закончится в текущей папке появится файл 60fps.mkv - это и будет результирующее видео.

1) git clone https://github.com/andreiyv/fpska.git
2) git fetch origin
3) git checkout -b fpska_v0.1 origin/fpska_v0.1
4) git push -u origin branch

https://www.svp-team.com/wiki/Download/ru
https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow