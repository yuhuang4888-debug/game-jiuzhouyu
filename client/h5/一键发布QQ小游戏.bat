@echo off

title Laya一键发布QQ小游戏工具
echo start:%time% >> execute_time.txt
if not exist Eversion.txt ( 
  echo "版本文件(Eversion.txt)不存在"     
  goto err 
)
set /p VERSION=<Eversion.txt
echo 更新代码中...
echo.
svn up -q ./scripts
svn up -q ./src
rd /S /Q "release/qqgame"
echo 发布中（版本 %VERSION%）中...
call CreateSubPackage.bat
call PublishQQ.bat
@echo off
echo.
echo 复制文件到cdn中...
set FCARGS=/auto_close /no_ui /cmd=diff /force_start=2 /log=FALSE
set /p keys=<../client/qq/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\qq\h5_qqgame_%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/qq/base_code" /to="../client/qq/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/qqgame/js" /to="../client/qq/%%a/js"
	set remain=%%b
)
if defined remain goto :loop
echo.
echo 复制文件完毕，提交svn中

svn add --force -q ../client/qq
svn ci ../client/qq -m "【版本%VERSION%】提交发布版本"

echo.
svn revert --recursive ./src
echo 发布版本【完成】（ver.%VERSION%）
echo end:%time% >> execute_time.txt
if %1==robot goto end
pause
:end