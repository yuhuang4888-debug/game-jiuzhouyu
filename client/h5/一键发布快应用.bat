 @echo off

title Laya一键发布快应用工具
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
svn up -q ../client/oppo
rd /S /Q "release/web"
echo 发布中（版本 %VERSION%）中...
call CreateSubPackage.bat
call PublishOPPO.bat
@echo off
echo.
echo 复制文件到cdn中...
set FCARGS=/auto_close /no_ui /cmd=diff /force_start=2 /log=FALSE

set /p keys=<../client/oppo/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\oppo\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/oppo/base_code" /to="../client/oppo/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/oppo/%%a/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/oppo/%%a/js"
	set remain=%%b
)
if defined remain goto :loop

set /p keys=<../client/vivo/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\vivo\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/vivo/base_code" /to="../client/vivo/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/vivo/%%a/src/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/vivo/%%a/src/js"
	set remain=%%b
)
if defined remain goto :loop

set /p keys=<../client/uc/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\uc\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/uc/base_code" /to="../client/uc/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/uc/%%a/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/uc/%%a/js"
	set remain=%%b
)
if defined remain goto :loop


set /p keys=<../client/xm/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\xm\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/xm/base_code" /to="../client/xm/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/xm/%%a/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/xm/%%a/js"
	set remain=%%b
)
if defined remain goto :loop

set /p keys=<../client/meizu/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\meizu\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/meizu/base_code" /to="../client/meizu/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/meizu/%%a/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/meizu/%%a/js"
	set remain=%%b
)
if defined remain goto :loop

set /p keys=<../client/bilibili/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\bilibili\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/bilibili/base_code" /to="../client/bilibili/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/bilibili/%%a/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/bilibili/%%a/js"
	set remain=%%b
)
if defined remain goto :loop

set /p keys=<../client/ks/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\ks\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/ks/base_code" /to="../client/ks/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/ks/%%a/mainPackage"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/ks/%%a/subPackage"
	set remain=%%b
)
if defined remain goto :loop

set /p keys=<../client/mt/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\mt\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/mt/base_code" /to="../client/mt/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/mt/%%a/game/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/mt/%%a/game/js"
	set remain=%%b
)
if defined remain goto :loop

set /p keys=<../client/tt/project_name.txt
set remain=%keys%
:loop
for /f "tokens=1* delims=," %%a in ("%remain%") do (
  if not exist "..\client\tt\%%a" ( start "" /wait FastCopy.exe %FCARGS% "../client/tt/base_code" /to="../client/tt/%%a")
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/bundle.js" /to="../client/tt/%%a/js"
  start "" /wait FastCopy.exe %FCARGS% "./release/web/js/subPackage.js" /to="../client/tt/%%a/js"
	set remain=%%b
)
if defined remain goto :loop


echo.
echo 复制文件完毕，提交svn中

svn add --force -q ../client/oppo
svn add --force -q ../client/vivo
svn add --force -q ../client/uc
svn add --force -q ../client/xm
svn add --force -q ../client/meizu
svn add --force -q ../client/bilibili
svn add --force -q ../client/ks
svn add --force -q ../client/mt
svn add --force -q ../client/tt
svn ci ../client/oppo -m "【OPPO版本%VERSION%】提交发布版本"
svn ci ../client/vivo -m "【VIVO版本%VERSION%】提交发布版本"
svn ci ../client/uc -m "【UC版本%VERSION%】提交发布版本"
svn ci ../client/xm -m "【小米版本%VERSION%】提交发布版本"
svn ci ../client/meizu -m "【魅族版本%VERSION%】提交发布版本"
svn ci ../client/bilibili -m "【billbill版本%VERSION%】提交发布版本"
svn ci ../client/ks -m "【快手版本%VERSION%】提交发布版本"
svn ci ../client/mt -m "【美团版本%VERSION%】提交发布版本"
svn ci ../client/tt -m "【字节跳动版本%VERSION%】提交发布版本"

echo.
svn revert --recursive ./src
echo 发布版本【完成】（ver.%VERSION%）
echo end:%time% >> execute_time.txt
if %1==robot goto end
pause
:end