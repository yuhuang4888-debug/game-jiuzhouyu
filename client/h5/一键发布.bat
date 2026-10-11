@echo off

title Laya一键发布工具
echo start:%time% >> execute_time.txt
if not exist Eversion.txt ( 
  echo "版本文件(Eversion.txt)不存在"     
  goto err 
)
set /p VERSION=<Eversion.txt
echo 更新cdn和代码目录、移除旧js中...
echo.
svn up -q ../cdn
svn up -q ./
rd /S /Q "release/web"
echo 发布中（版本 %VERSION%）中...

rem thread_1.bat 文件
rem call zipCmd.bat
rem call CreateResourceVersion.bat
rem call laya2cdn.bat
rem call ExportRes2Cdn.bat
rem thread_2.bat 文件
rem call CreateSubPackage.bat
rem call Publish.bat
rem svn revert --recursive ./src

rem thread1和thread2并行执行
echo 并行开始执行(thread_main start)...
call thread_main.bat
rem 执行并行的svn提交
echo 并行执行成功(thread_main end)...


@echo off
echo.
echo 复制文件到cdn中...
set FCARGS=/auto_close /no_ui /cmd=diff /force_start=2 /log=FALSE
start "" /wait FastCopy.exe %FCARGS% ".\release\web" /to="..\cdn"
echo.
echo 复制文件完毕，提交svn中

svn ci ./laya/assets/resource/game_manul_version.json -m "【版本%VERSION%】提交game_manul_version"
svn add --force -q ../cdn
svn ci ../cdn -m "【版本%VERSION%】提交发布版本"
svn revert --recursive ./src
echo.
echo 发布版本【完成】（ver.%VERSION%）
echo end:%time% >> execute_time.txt
if %1==robot goto end
pause
:end