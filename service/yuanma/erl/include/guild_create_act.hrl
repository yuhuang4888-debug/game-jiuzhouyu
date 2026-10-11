%%-----------------------------------------------------------------------------
%% @Module  :       guild_create_act.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-15
%% @Description:    
%%-----------------------------------------------------------------------------

-record (reward_check_param, {
    guild_id,
    role_id,
    president_id,
    vice_president_count,
    guild_lv,
    member_count,
    global_info = []
    }).

