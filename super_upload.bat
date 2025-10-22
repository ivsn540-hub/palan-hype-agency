@echo off
chcp 1251 >nul
color 0A
echo ?? Автоматическая настройка сайта...

:: === Ввод FTP-данных ===
set FTP_HOST=ftp.imperiya-torzhestv.ru
set FTP_USER=ivan.vlas5@yandex.ru	
set FTP_PASS=Vlas1979!

:: === Проверка структуры ===
echo ?? Проверка файлов...

if not exist index.html (
    echo ? Не найден index.html. Создаю пример...
    echo ^<html^>Пример сайта^</html^> > index.html
)

if not exist images (
    echo ? Не найдена папка images. Создаю...
    mkdir images
    echo Пример > images\readme.txt
)

if not exist music (
    echo ? Не найдена папка music. Создаю...
    mkdir music
    echo Пример > music\readme.txt
)

if exist site.zip (
    del /q site.zip
)

echo ?? Архивируем сайт...
"C:\Program Files\WinRAR\rar.exe" a -ep1 site.zip index.html images music >nul 2>&1

if not exist site.zip (
    echo ? Не удалось создать архив. Проверь наличие WinRAR.
    pause
    exit /b
)

:: === Создаём ftp-команды ===
echo ?? Подключение к FTP...
(
    echo open %FTP_HOST%
    echo %FTP_USER%
    echo %FTP_PASS%
    echo binary
    echo put site.zip
    echo bye
) > ftp_commands.txt

:: === Загружаем по FTP ===
ftp -n -s:ftp_commands.txt > ftp_log.txt 2>&1

findstr /i /c:"Login failed" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? Ошибка входа на FTP! Проверь логин/пароль!
    pause
    exit /b
)

findstr /i /c:"Transfer complete" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? Успешно загружено site.zip на сервер.
) else (
    echo ?? Не удалось загрузить архив. Проверь FTP-соединение.
)

:: === Завершение ===
del ftp_commands.txt
echo ? Скрипт завершён.
pause
