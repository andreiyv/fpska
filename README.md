## fpska v0.9.3
С помощью этого скрипта можно перевести видео с частотой 15/24/25/30/50 кадров в секунду в видео с частотой 60 кадров в секунду, посредством создания и добавления промежуточных кадров.

Скрипт работает со следующими контейнерами:
mp4, mkv, m2ts, avi, wma, mpg
    
Не нужно устанавливать никаких кодеков (все идет в комплекте).
    
Для расчета промежуточных кадров используется библиотека svpflow от команды www.svp-team.com. В зависимости от разрешения исходного видео перекодирование в 60 fps может занимать очень много времени и требовать много машинной памяти, так, например, перекодирование видео в формате 4K идет со скоростью 0.1fps, что очень медленно. Это обусловлено тем, что в программе расчета промежуточных кадров используются настройки для достижения наилучшего качества вставляемых кадров. Следует сказать, что данный скрипт планировался для перекодирования коротких по времени видеороликов (5-15 минут), поэтому все настройки были "взвинчены" на максимальный уровень.

## Установка
Просто запускаем setup.bat

## Запуск
Перетаскиваем мышкой видеофайл в окно fpsk'и.

## Режим конвертации в 60fps
* быстрый - если хотите быстро оценить, можно ли сконвертировать ваше видео в 60fps;
* сбалансированный - баланс между скоростью конвертирования и качеством результирующего видео;
* точный - все настройки выкручены по максимуму, кодирует долго, но результирующее видео просто отличное;
* точный lossless - тоже самое, что и "точный", только видео не сжимается (для последующего редактирования). 

После того как процесс кодирования закончится в папке с исходным видео появится файл с префиксом _fpska_60fps.mkv.

