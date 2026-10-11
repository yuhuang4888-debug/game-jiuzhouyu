title clusters center

set ERL_PATH=%1

cd ../
cd config
%ERL_PATH%erl +P 1024000 +K true -smp true -name db_upgrade_center@127.0.0.1 -setcookie gsrv -boot start_sasl -config cls -pa ../ebin -s db_upgrade execute -extra cls
%ERL_PATH%erl +P 1024000 +K true -name st_ml_center@127.0.0.1 -setcookie st_ml_center -boot start_sasl -config cls -pa ../ebin -s gsrv start -s reloader start -extra 127.0.0.1 9409 0
pause