@echo off
echo.
echo 复制文件到bin中...
set FCARGS=/auto_close /no_ui /cmd=diff /speed=full /force_start=2 /log=FALSE
start "" /wait FastCopy.exe %FCARGS% ".\laya\assets" /to="..\cdn"
start "" /wait FastCopy.exe %FCARGS% ".\laya\pages" /to="..\cdn"
echo 复制文件完成
echo.