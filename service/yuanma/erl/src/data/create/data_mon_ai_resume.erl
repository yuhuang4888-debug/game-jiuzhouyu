%%%---------------------------------------
%%% @Module  : data_mon_ai_resume
%%% @Description:  怪物AI
%%%---------------------------------------
-module(data_mon_ai_resume).
-compile(export_all).


get(9)->
    [{frenzy,[0,0,1],0},{skill,[{900101,1}],0}];

get(3602103)->
    [{nochange,0,{cycle,1}}];
get(_)->
    [].


