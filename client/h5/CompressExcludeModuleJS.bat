@echo off
:: 设置压缩JS文件的根目录，脚本会自动按树层次查找和压缩所有的JS
if not exist exculde_module.txt ( 
  echo "版本文件(exculde_module.txt)不存在"     
  goto err 
)
set /p exculde=<exculde_module.txt
SET JSFOLDER=E:\yyhx_kf_new\code\h5\bin-debug\map
echo 正在查找JS文件
chdir /d %JSFOLDER%
set b=uglifyjs 
SETLOCAL ENABLEDELAYEDEXPANSION
for /r . %%a in (*.js) do (
    @echo 正在压缩 %%~a ...
    set b=!b! %%a
) 
set b=%b% -m -o test.min.js
call %b%
echo 合并压缩模块js完毕