call CreateSubPackage.bat >> thread_2_log.txt 2>>&1 
call Publish.bat >> thread_2_log.txt 2>>&1 
rem svn revert --recursive ./src

echo 1 > thread_2.txt

exit