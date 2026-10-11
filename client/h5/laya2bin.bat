@echo off
echo 合并压缩config...
cd scripts && node mergeConfigLocal.js
cd ..
"C:\Program Files\WinRAR\WinRAR.exe" a -k -r -ep1 -o+ -s -ibck laya\assets\resource\local_config.zip laya\assets\resource\local_config.json
echo.
echo 复制文件到bin中...
set FCARGS=/auto_close /no_ui /cmd=diff /speed=full /force_start=2 /log=FALSE
start "" /wait FastCopy.exe %FCARGS% ".\laya\assets" /to=".\bin"
start "" /wait FastCopy.exe %FCARGS% ".\laya\pages" /to=".\bin"
echo 复制文件完成
echo.
