@echo off

title Laya一键发布微信小游戏工具
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
rd /S /Q "release/wxgame"
echo 发布中（版本 %VERSION%）中...
call CreateSubPackage.bat
call PublishWX.bat
@echo off
echo.
echo 复制文件到cdn中...
set FCARGS=/auto_close /no_ui /cmd=diff /force_start=2 /log=FALSE

set /p keys=<../client/wx/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\wx\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/wx/base_code" /to="../client/wx/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/wxgame/js/bundle.js" /to="../client/wx/%%a/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/wxgame/js/subPackage.js" /to="../client/wx/%%a/js"
	set remain=%%b
)
if defined remain goto :loop

echo.
echo 复制文件完毕，提交svn中

svn add --force -q ../client/wx
svn ci ../client/wx -m "【版本%VERSION%】提交发布版本"
echo.
svn revert --recursive ./src
echo 发布版本【完成】（ver.%VERSION%）
echo end:%time% >> execute_time.txt
if %1==robot goto end
pause
:end