call zipCmd.bat >> thread_1_log.txt 2>>&1 
call CreateResourceVersion.bat >> thread_1_log.txt 2>>&1 
call laya2cdn.bat >> thread_1_log.txt 2>>&1 
call ExportRes2Cdn.bat >> thread_1_log.txt 2>>&1 

echo 1 > thread_1.txt

exit