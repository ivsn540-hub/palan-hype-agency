@echo off
title Империя Торжеств - Мастер загрузки сайта
color 0A

:: === [НАСТРОЙКИ - ОБЯЗАТЕЛЬНО ЗАПОЛНИ] ===
set FTP_HOST=https://www.reg.ru/user/account/#/
set FTP_USER=ivan.vlas5@yandex.ru
set FTP_PASS=Vlas1979!


:: === [ПРОВЕРКА curl и WinRAR] ===
where curl >nul 2>nul
if errorlevel 1 (
    echo ? curl не найден. Windows 10+ должен его содержать.
    echo Завершение работы.
    pause
    exit /b
)

if not exist "C:\Program Files\WinRAR\WinRAR.exe" (
    echo ? WinRAR не найден по пути C:\Program Files\WinRAR\WinRAR.exe
    echo Пожалуйста, установите WinRAR.
    pause
    exit /b
)

:: === [ПОДГОТОВКА ПАПОК] ===
echo ?? Создаём структуру сайта...
rd /s /q site >nul 2>nul
mkdir site\assets\images
mkdir site\assets\music

:: === [КОПИРОВАНИЕ КОНТЕНТА] ===
copy index.html site\ >nul
copy favicon.ico site\ >nul
xcopy images site\assets\images /E /I /Y >nul
xcopy music site\assets\music /E /I /Y >nul

:: === [АРХИВАЦИЯ] ===
echo ?? Упаковываем в site.zip...
del site.zip >nul 2>nul
"C:\Program Files\WinRAR\WinRAR.exe" a -r -ep1 site.zip site\

if not exist site.zip (
    echo ? Ошибка при создании архива.
    pause
    exit /b
)

:: === [FTP КОМАНДЫ] ===
echo ?? Подготовка FTP-загрузки...
(
echo open %FTP_HOST%
echo %FTP_USER%
echo %FTP_PASS%
echo binary
echo put site.zip
echo bye
) > ftp_commands.txt

:: === [ЗАГРУЗКА НА FTP] ===
echo ?? Загружаем на сервер...
ftp -n -s:ftp_commands.txt > ftp_log.txt 2>&1

findstr /C:"Login failed" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? Неверный логин или пароль FTP. Проверьте переменные!
    pause
    exit /b
)

findstr /C:"cannot open" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? Не удалось подключиться к серверу.
    echo ?? Повторная попытка через 10 секунд...
    timeout /t 10
    ftp -n -s:ftp_commands.txt > ftp_log_retry.txt
)

:: === [УБОРКА] ===
del ftp_commands.txt
echo ? Загрузка завершена. Файл site.zip отправлен.
pause
