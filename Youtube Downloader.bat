@echo off
color 0A
title YouTube Downloader

:: File to save last download info
set "LASTFILE=last_download.txt"

:: yt-dlp & ffmpeg paths
set "FFMPEG_DIR=G:\Test\ffmpeg\bin"
set "YT_DLP=yt-dlp.exe"
set "FFMPEG_PARAM=--ffmpeg-location %FFMPEG_DIR%"
set "RETRY_PARAM=--retries 5 --continue --no-overwrites"
set "MERGE_PARAM=--merge-output-format mp4"

:: Check dependencies
if not exist "%YT_DLP%" (
    echo [ERROR] yt-dlp.exe not found! Place it in the same folder as this script.
    pause
    exit /b
)
if not exist "%FFMPEG_DIR%\ffmpeg.exe" (
    echo [ERROR] ffmpeg.exe not found in %FFMPEG_DIR%
    pause
    exit /b
)

:START
cls
echo =====================================================================
echo                               YouTube Downloader
echo   Author   : Beluga
echo   version  : 1.3
echo   GitHub   : https://github.com/belugacrx
echo   Mail     : macrocortex@gmail.com
echo =====================================================================
echo.
echo [1] Basic Mode  - Quick Download (Best Quality, No Questions)
echo [2] Advanced Mode - Full Options
echo [3] Exit
echo.
set /p mode=Enter choice: 

if "%mode%"=="1" goto BASIC
if "%mode%"=="2" goto MENU
if "%mode%"=="3" exit /b
echo
echo Invalid choice! Try again
pause
goto START

:BASIC
cls
echo Basic Mode - Quick Download
echo ---------------------------
echo
set /p URL=Paste YouTube URL: 

if "%URL%"=="" (
    echo No URL provided!
    pause
    goto START
)

:: Default download folder
set "DOWNLOAD_DIR=%USERPROFILE%\Downloads"
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

echo Downloading BEST quality to: %DOWNLOAD_DIR%
echo.

%YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %MERGE_PARAM% -f "bestvideo+bestaudio" -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" "%URL%"

echo.
echo Download finished. Files are saved in: %DOWNLOAD_DIR%
exit /b

:MENU
cls
echo ================================
echo       Advanced Mode
echo ================================
echo.
echo [1] Download a single video
echo [2] Download multiple videos from file (links.txt)
if exist "%LASTFILE%" echo [3] Resume Last Download
echo [4] Back
echo.

set /p choice=Enter choice: 

if "%choice%"=="1" goto SINGLE
if "%choice%"=="2" goto MULTI
if "%choice%"=="3" if exist "%LASTFILE%" goto RESUME
if "%choice%"=="4" goto START
echo Invalid choice! Try again
pause
goto MENU

:SINGLE
cls
echo Single Video Download
set /p URL=Enter YouTube URL: 

:: Custom download folder
set /p DOWNLOAD_DIR=Enter folder to save file (leave blank for default Downloads): 
if "%DOWNLOAD_DIR%"=="" set "DOWNLOAD_DIR=%USERPROFILE%\Downloads"
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

:: Video quality choice
echo.
echo Choose video quality:
echo [1] Best available
echo [2] 1080p max
echo [3] 720p max
set /p QUALITY=Enter choice: 

if "%QUALITY%"=="1" (
    set "FMT=bestvideo+bestaudio"
) else if "%QUALITY%"=="2" (
    set "FMT=bestvideo[height<=1080]+bestaudio"
) else if "%QUALITY%"=="3" (
    set "FMT=bestvideo[height<=720]+bestaudio"
) else (
    echo Invalid quality choice!
    pause
    goto SINGLE
)

:: Download type
echo.
echo Choose download type:
echo [1] Video only (no audio)
echo [2] Audio only (MP3)
echo [3] Combined (Video + Audio)
set /p TYPE=Enter choice: 

:: Optional: Partial download
echo.
set /p PART="Do you want to download a specific part? (y/n): "
if /i "%PART%"=="y" (
    set /p START="Enter start time (hh:mm:ss): "
    set /p END="Enter end time (hh:mm:ss): "
    set "SECTION=--download-sections *%START%-%END%"
) else (
    set "SECTION="
)

:: Save last download info
(
echo %URL%
echo %TYPE%
echo %FMT%
echo %DOWNLOAD_DIR%
echo %SECTION%
) > "%LASTFILE%"

echo.
echo Downloading...
echo.

if "%TYPE%"=="1" (
     %YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %SECTION% -f bestvideo -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" %URL%
) else if "%TYPE%"=="2" (
     %YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %SECTION% -x --audio-format mp3 -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" %URL%
) else if "%TYPE%"=="3" (
     %YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %MERGE_PARAM% %SECTION% -f "%FMT%" -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" %URL%
) else (
    echo Invalid download type!
    pause
    goto SINGLE
)

echo.
echo Download finished. Files are saved in: %DOWNLOAD_DIR%
pause
goto MENU

:RESUME
cls
echo Resuming Last Download

setlocal enabledelayedexpansion
set /a count=0
for /f "delims=" %%a in (%LASTFILE%) do (
    set /a count+=1
    if !count! EQU 1 set "URL=%%a"
    if !count! EQU 2 set "TYPE=%%a"
    if !count! EQU 3 set "FMT=%%a"
    if !count! EQU 4 set "DOWNLOAD_DIR=%%a"
    if !count! EQU 5 set "SECTION=%%a"
)
endlocal & set "URL=%URL%" & set "TYPE=%TYPE%" & set "FMT=%FMT%" & set "DOWNLOAD_DIR=%DOWNLOAD_DIR%" & set "SECTION=%SECTION%"

if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

echo.
echo Resuming download from: %URL%
echo.

if "%TYPE%"=="1" (
     %YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %SECTION% -f bestvideo -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" %URL%
) else if "%TYPE%"=="2" (
     %YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %SECTION% -x --audio-format mp3 -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" %URL%
) else if "%TYPE%"=="3" (
     %YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %MERGE_PARAM% %SECTION% -f "%FMT%" -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" %URL%
) else (
    echo Invalid previous download type!
    pause
    goto MENU
)

echo.
echo Download finished. Files are saved in: %DOWNLOAD_DIR%
pause
goto MENU

:MULTI
cls
echo Multi-Video Download (links.txt)
set /p DOWNLOAD_DIR=Enter folder to save files (leave blank for default Downloads): 
if "%DOWNLOAD_DIR%"=="" set "DOWNLOAD_DIR=%USERPROFILE%\Downloads"
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

%YT_DLP% %FFMPEG_PARAM% %RETRY_PARAM% %MERGE_PARAM% -o "%DOWNLOAD_DIR%\%%(upload_date)s - %%(title)s.%%(ext)s" -a links.txt

echo.
echo All downloads finished. Files saved in: %DOWNLOAD_DIR%
pause
goto MENU
