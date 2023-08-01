@echo off

setlocal enabledelayedexpansion

REM 设置批处理文件的版本号
set BAT_VERSION=1.0.0

set DOWNLOAD_URL=https://codeload.github.com/mcxg/PCL2/zip/refs/heads/main
set DOWNLOAD_FILE=PCL2.zip
set UNZIP_FOLDER=PCL2-main
set README_FILE=README.md
set AUTO_UPDATE_FILE=%UNZIP_FOLDER%\自动更新.bat
set DELAY=166

REM 检查当前版本
for /f "skip=2 tokens=*" %%V in (README.md) do (
    set CURRENT_VERSION=%%V
    goto :next
)
:next
set CURRENT_VERSION=%CURRENT_VERSION:版本号: =%

REM 下载文件并显示进度
echo 正在下载文件...
powershell -Command "$webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('%DOWNLOAD_URL%', '%DOWNLOAD_FILE%')"

REM 解压文件
echo 正在解压文件...
powershell -Command "Expand-Archive -Path '%DOWNLOAD_FILE%' -DestinationPath '.'"

REM 移动更新的Custom.xaml文件和README.md文件到当前目录下
echo 正在移动更新的文件...
move /Y "%UNZIP_FOLDER%\Custom.xaml" "Custom.xaml"
move /Y "%UNZIP_FOLDER%\%README_FILE%" "%README_FILE%"

REM 检查新版本号及批处理文件版本号
for /f "skip=2 tokens=*" %%V in ("%README_FILE%") do (
    set NEW_VERSION=%%V
    goto :check_bat_version
)
:check_bat_version
set NEW_VERSION=%NEW_VERSION:版本号: =%
for /f "usebackq tokens=2 delims== " %%B in ("%AUTO_UPDATE_FILE%") do (
    set DOWNLOADED_BAT_VERSION=%%B
    goto :compare
)
:compare

REM 对比批处理文件版本号及PCL插件版本号，并执行相应操作
if "%CURRENT_VERSION%"=="%NEW_VERSION%" (
    if "%BAT_VERSION%"=="%DOWNLOADED_BAT_VERSION%" (
        echo.
        echo 当前已是最新版本：%CURRENT_VERSION%
        echo 不需要执行后续操作。
    ) else (
        echo.
        echo 批处理文件版本号不一致，将用下载的批处理文件替换原文件。
        move /Y "%AUTO_UPDATE_FILE%" "%~dp0%~nx0"
        echo.
        echo 操作已完成，原批处理文件已更新至版本号：%DOWNLOADED_BAT_VERSION%
    )
) else (
 REM 逐行显示 README.md 的内容
    echo.
    echo 这是我们的说明性文档：
    for /F "usebackq delims=" %%i in ("%README_FILE%") do (
        echo %%i
        REM 根据适用的操作系统选择合适的延迟命令
        REM Windows XP 版本：
        ping -n 1 127.0.0.1 > nul
        REM Windows 7、Windows 8、Windows 10 版本：
        timeout /t 1 > nul        )
)

REM 清除临时文件
echo.
echo 正在做最后优化...
del "%DOWNLOAD_FILE%"
rd /S /Q "%UNZIP_FOLDER%"

REM 完成操作
echo.
echo 操作已完成，本bat文件及PCL插件作者：mcxg，感谢您的使用！
pause
