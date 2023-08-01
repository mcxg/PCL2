@echo off

setlocal enabledelayedexpansion

REM �����������ļ��İ汾��
set BAT_VERSION=1.0.0

set DOWNLOAD_URL=https://codeload.github.com/mcxg/PCL2/zip/refs/heads/main
set DOWNLOAD_FILE=PCL2.zip
set UNZIP_FOLDER=PCL2-main
set README_FILE=README.md
set AUTO_UPDATE_FILE=%UNZIP_FOLDER%\�Զ�����.bat
set DELAY=166

REM ��鵱ǰ�汾
for /f "skip=2 tokens=*" %%V in (README.md) do (
    set CURRENT_VERSION=%%V
    goto :next
)
:next
set CURRENT_VERSION=%CURRENT_VERSION:�汾��: =%

REM �����ļ�����ʾ����
echo ���������ļ�...
powershell -Command "$webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('%DOWNLOAD_URL%', '%DOWNLOAD_FILE%')"

REM ��ѹ�ļ�
echo ���ڽ�ѹ�ļ�...
powershell -Command "Expand-Archive -Path '%DOWNLOAD_FILE%' -DestinationPath '.'"

REM �ƶ����µ�Custom.xaml�ļ���README.md�ļ�����ǰĿ¼��
echo �����ƶ����µ��ļ�...
move /Y "%UNZIP_FOLDER%\Custom.xaml" "Custom.xaml"
move /Y "%UNZIP_FOLDER%\%README_FILE%" "%README_FILE%"

REM ����°汾�ż��������ļ��汾��
for /f "skip=2 tokens=*" %%V in ("%README_FILE%") do (
    set NEW_VERSION=%%V
    goto :check_bat_version
)
:check_bat_version
set NEW_VERSION=%NEW_VERSION:�汾��: =%
for /f "usebackq tokens=2 delims== " %%B in ("%AUTO_UPDATE_FILE%") do (
    set DOWNLOADED_BAT_VERSION=%%B
    goto :compare
)
:compare

REM �Ա��������ļ��汾�ż�PCL����汾�ţ���ִ����Ӧ����
if "%CURRENT_VERSION%"=="%NEW_VERSION%" (
    if "%BAT_VERSION%"=="%DOWNLOADED_BAT_VERSION%" (
        echo.
        echo ��ǰ�������°汾��%CURRENT_VERSION%
        echo ����Ҫִ�к���������
    ) else (
        echo.
        echo �������ļ��汾�Ų�һ�£��������ص��������ļ��滻ԭ�ļ���
        move /Y "%AUTO_UPDATE_FILE%" "%~dp0%~nx0"
        echo.
        echo ��������ɣ�ԭ�������ļ��Ѹ������汾�ţ�%DOWNLOADED_BAT_VERSION%
    )
) else (
 REM ������ʾ README.md ������
    echo.
    echo �������ǵ�˵�����ĵ���
    for /F "usebackq delims=" %%i in ("%README_FILE%") do (
        echo %%i
        REM �������õĲ���ϵͳѡ����ʵ��ӳ�����
        REM Windows XP �汾��
        ping -n 1 127.0.0.1 > nul
        REM Windows 7��Windows 8��Windows 10 �汾��
        timeout /t 1 > nul        )
)

REM �����ʱ�ļ�
echo.
echo ����������Ż�...
del "%DOWNLOAD_FILE%"
rd /S /Q "%UNZIP_FOLDER%"

REM ��ɲ���
echo.
echo ��������ɣ���bat�ļ���PCL������ߣ�mcxg����л����ʹ�ã�
pause
