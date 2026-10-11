%%-----------------------------------------------------------------------------
%% @Module  :       daily_turntable.hrl
%% @Author  :       Fwx
%% @Created :       2018-7-2
%% @Description:    每日转盘活动
%%-----------------------------------------------------------------------------


-record(daily_turntable, {
    act_maps = #{}          %% #{SubType => #act_info{} } }
}).


-record(turn_act_info,{
    use_num = 0,            %% 使用次数
    grade_info = [],         %% [#reward_info{}]
    utime   = 0
    }).


-record(turn_reward_info,{
    grade_id = 0,
    num = 0
}).
