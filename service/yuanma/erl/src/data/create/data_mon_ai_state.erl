%%%---------------------------------------
%%% @Module  : data_mon_ai_state
%%% @Description:  怪物AI
%%%---------------------------------------
-module(data_mon_ai_state).
-compile(export_all).


get(6)->
    [{nochange,0,1000},{nochange,0,{cycle,1}}];

get(7)->
    [{nochange,0,{cycle,1}}];

get(9)->
    [{frenzy,[1,10,1],0},{skill,[{501,1}],0}];

get(3601002)->
    [{nochange,0,10000},{nochange,0,{cycle,1}}];

get(3601003)->
    [{skill,[{900101,1},{3601021,1}],0}];

get(3601005)->
    [{skill,[{900106,1},{3601040,1}],0},{nochange,0,10000},{nochange,0,{cycle,1}}];

get(3602101)->
    [{nochange,0,{cycle,1}}];

get(3602102)->
    [{skill,[{3601050,1},{900101,1},{3601012,1}],0},{pub_skill_cd_cfg,[{3601050,1,1000},{3601021,1,1000}],0},{nochange,0,{cycle,1}}];

get(3602103)->
    [{nochange,0,{cycle,1}}];

get(3602104)->
    [{nochange,0,{cycle,1}}];

get(3602201)->
    [{nochange,0,{cycle,1}}];

get(3602202)->
    [{skill,[{3601050,1},{900101,1},{3601012,1}],0},{pub_skill_cd_cfg,[{3601050,1,1000},{3601021,1,1000}],0},{nochange,0,{cycle,1}}];

get(3602203)->
    [{nochange,0,{cycle,1}}];

get(3602204)->
    [{nochange,0,{cycle,1}}];

get(3602205)->
    [{nochange,0,{cycle,1}}];
get(_)->
    [].


