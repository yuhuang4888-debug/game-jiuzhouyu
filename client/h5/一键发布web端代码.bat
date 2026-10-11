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
svn up -q ./laya/assets/resource/game_manul_version.json
svn up -q ../cdn/resource/game_manul_version.json
svn up -q ./scripts
svn up -q ./src
rd /S /Q "release/web"
echo 发布中（版本 %VERSION%）中...
cd scripts && node createMainVersion.js
cd ..
call CreateSubPackage.bat
call Publish.bat
@echo off
echo.
echo 复制文件到cdn中...
set FCARGS=/auto_close /no_ui /cmd=diff /force_start=2 /log=FALSE
start "" /wait FastCopy.exe %FCARGS% ".\release\web\js" /to="..\cdn\js"
echo.
echo 复制文件完毕，提交svn中

svn ci ./laya/assets/resource/game_manul_version.json -m "【版本%VERSION%】提交h5目录game_manul_version"
svn add --force -q ../cdn/js
svn ci ../cdn/js -m "【版本%VERSION%】提交发布版本"
svn ci ../cdn/resource/game_manul_version.json -m "【版本%VERSION%】提交cdn目录game_manul_version"
echo.
svn revert --recursive ./src
echo 发布版本【完成】（ver.%VERSION%）
echo end:%time% >> execute_time.txt
if %1==robot goto end
pause
:end