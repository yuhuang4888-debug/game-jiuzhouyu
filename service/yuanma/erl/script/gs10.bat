escript ./check_data.escript

set ERL_PATH=%1

if %errorlevel%==1 (goto execute_start) else (goto execute_halt)

:execute_start

title yyhx3d_game line
cd ../
cd config
%ERL_PATH%erl +P 1024000 +K true -smp true -name db_upgrade_x10@127.0.0.1 -setcookie gsrv -boot start_sasl -config gsrv -pa ../ebin -s db_upgrade execute -extra gsrv
%ERL_PATH%erl +P 1024000 +K true -smp true -name st_ml10@127.0.0.1 -setcookie st_wd -boot start_sasl -config gsrv -pa ../ebin -s gsrv start -s reloader start -extra 127.0.0.1 9400 10

:execute_halt

pause
