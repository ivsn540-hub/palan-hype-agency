@echo off
title ������� �������� - ������ �������� �����
color 0A

:: === [��������� - ����������� �������] ===
set FTP_HOST=https://www.reg.ru/user/account/#/
set FTP_USER=ivan.vlas5@yandex.ru
set FTP_PASS=Vlas1979!


:: === [�������� curl � WinRAR] ===
where curl >nul 2>nul
if errorlevel 1 (
    echo ? curl �� ������. Windows 10+ ������ ��� ���������.
    echo ���������� ������.
    pause
    exit /b
)

if not exist "C:\Program Files\WinRAR\WinRAR.exe" (
    echo ? WinRAR �� ������ �� ���� C:\Program Files\WinRAR\WinRAR.exe
    echo ����������, ���������� WinRAR.
    pause
    exit /b
)

:: === [���������� �����] ===
echo ?? ������ ��������� �����...
rd /s /q site >nul 2>nul
mkdir site\assets\images
mkdir site\assets\music

:: === [����������� ��������] ===
copy index.html site\ >nul
copy favicon.ico site\ >nul
xcopy images site\assets\images /E /I /Y >nul
xcopy music site\assets\music /E /I /Y >nul

:: === [���������] ===
echo ?? ����������� � site.zip...
del site.zip >nul 2>nul
"C:\Program Files\WinRAR\WinRAR.exe" a -r -ep1 site.zip site\

if not exist site.zip (
    echo ? ������ ��� �������� ������.
    pause
    exit /b
)

:: === [FTP �������] ===
echo ?? ���������� FTP-��������...
(
echo open %FTP_HOST%
echo %FTP_USER%
echo %FTP_PASS%
echo binary
echo put site.zip
echo bye
) > ftp_commands.txt

:: === [�������� �� FTP] ===
echo ?? ��������� �� ������...
ftp -n -s:ftp_commands.txt > ftp_log.txt 2>&1

findstr /C:"Login failed" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? �������� ����� ��� ������ FTP. ��������� ����������!
    pause
    exit /b
)

findstr /C:"cannot open" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? �� ������� ������������ � �������.
    echo ?? ��������� ������� ����� 10 ������...
    timeout /t 10
    ftp -n -s:ftp_commands.txt > ftp_log_retry.txt
)

:: === [������] ===
del ftp_commands.txt
echo ? �������� ���������. ���� site.zip ���������.
pause
