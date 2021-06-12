@echo off

if "%1"=="install" goto install
if "%1"=="pull" goto pull
echo Usage: manage.bat [install/pull]
goto end

:install

setlocal enableextensions
md %appdata%\..Local\nvim\colors
endlocal
copy init.vim %appdata%\..\Local\nvim\init.vim
copy ginit.vim %appdata%\..\Local\nvim\ginit.vim
copy colors\*.* %appdata%\..\Local\nvim\colors\

goto end
:pull

copy %appdata%\..\Local\nvim\init.vim init.vim
copy %appdata%\..\Local\nvim\ginit.vim ginit.vim

:end
