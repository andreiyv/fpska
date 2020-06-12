# fpska v0.9.1

## Что нового

* теперь поддерживаются пути с unicode символами, в том числе и с русскими буквами
* добавлен графический интерфейс с индикатором прогресса и оставшегося времени, а также
в нём есть возможность конвертировать сразу несколько файлов

С помощью этого скрипта можно перевести видео с частотой 15/24/25/30/50 кадров в секунду в видео с частотой 60 кадров в секунду, посредством создания и добавления промежуточных кадров.

Скрипт работает со следующими контейнерами:

* mp4
* mkv
* m2ts
* avi
* wma
* mpg

Не нужно устанавливать никаких кодеков (все идет в комплекте).

Для рассчета промежуточных кадров используется библиотека svpflow от команды [SVP Team](https://www.svp-team.com/). В зависимости от разрешения исходного видео перекодирование в 60 fps может занимать очень много времени и требовать много машинной памяти, так, например, перекодирование видео в формате 4K идет со скоростью 0.1fps, что очень медленно. Это обусловлено тем, что в программе рассчета промежуточных кадров используются настройки для достижения наилучшего качества вставляемых кадров. Следует сказать, что данный скрипт планировался для перекодирования коротких по времени видеороликов (5-15 минут), поэтому все настройки были "взвинчены" на максимальный уровень.

## Установка

Просто запускаем setup.bat

## Запуск

### Графическая версия

* fpska-gui.bat

### Консольная версия

Перетаскиваем мышкой видеофайл на:

* fpska-fast.bat - если хотите по быстрому оценить, можно ли сконвертировать ваше видео в 60fps;
* fpska-medium.bat - баланс между скоростью конвертирования и качеством результирующего видео;
* fpska-slow.bat - все настройки выкручены по максимуму, кодирует долго, но результирующее видео просто отличное;
* fpska-lossless.bat - тоже самое, что и slow, только видео не сжимается.

После того, как процесс кодирования закончится в папке с исходным видео появится файл с префиксом _fpska_60fps.mkv.

## Практика

<https://youtu.be/tNTLC3R14xA>
