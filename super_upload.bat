@echo off
chcp 1251 >nul
color 0A
echo ?? �������������� ��������� �����...

:: === ���� FTP-������ ===
set FTP_HOST=ftp.imperiya-torzhestv.ru
set FTP_USER=ivan.vlas5@yandex.ru	
set FTP_PASS=Vlas1979!

:: === �������� ��������� ===
echo ?? �������� ������...

if not exist index.html (
    echo ? �� ������ index.html. ������ ������...
    echo ^<html^>������ �����^</html^> > index.html
)

if not exist images (
    echo ? �� ������� ����� images. ������...
    mkdir images
    echo ������ > images\readme.txt
)

if not exist music (
    echo ? �� ������� ����� music. ������...
    mkdir music
    echo ������ > music\readme.txt
)

if exist site.zip (
    del /q site.zip
)

echo ?? ���������� ����...
"C:\Program Files\WinRAR\rar.exe" a -ep1 site.zip index.html images music >nul 2>&1

if not exist site.zip (
    echo ? �� ������� ������� �����. ������� ������� WinRAR.
    pause
    exit /b
)

:: === ������ ftp-������� ===
echo ?? ����������� � FTP...
(
    echo open %FTP_HOST%
    echo %FTP_USER%
    echo %FTP_PASS%
    echo binary
    echo put site.zip
    echo bye
) > ftp_commands.txt

:: === ��������� �� FTP ===
ftp -n -s:ftp_commands.txt > ftp_log.txt 2>&1

findstr /i /c:"Login failed" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? ������ ����� �� FTP! ������� �����/������!
    pause
    exit /b
)

findstr /i /c:"Transfer complete" ftp_log.txt >nul
if %errorlevel%==0 (
    echo ? ������� ��������� site.zip �� ������.
) else (
    echo ?? �� ������� ��������� �����. ������� FTP-����������.
)

:: === ���������� ===
del ftp_commands.txt
echo ? ������ ��������.
pause
