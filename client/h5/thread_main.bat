@REM 清理和设置标志位
del /f /s /q thread_1.txt thread_2.txt thread_1_log.txt thread_2_log.txt
echo 0 > thread_1.txt
echo 0 > thread_2.txt

@REM 并发
echo 执行并行thread_1(zipCmd.bat CreateResourceVersion.bat laya2cdn.bat ExportRes2Cdn.bat)...
start thread_1.bat 
echo 执行并行thread_2(CreateSubPackage.bat Publish.bat svn revert)...
start thread_2.bat

:thread_loop
    timeout /t 30 /nobreak
    set /P t1=< thread_1.txt
    set /P t2=< thread_2.txt 
    @REM 等待所有结束
    if %t1% == 0 goto thread_loop 
    if %t2% == 0 goto thread_loop

echo show thread_1_log.txt ...
type thread_1_log.txt 
echo show thread_2_log.txt ...
type thread_2_log.txt

echo 清理并发多余的文件
del /f /s /q thread_1.txt thread_2.txt thread_1_log.txt thread_2_log.txt