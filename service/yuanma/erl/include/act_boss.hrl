%%-----------------------------------------------------------------------------
%% @Module  :       act_boss
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-05
%% @Description:    活动Boss
%%-----------------------------------------------------------------------------

-define(ACT_STATUS_CLOSE,       0).         %% 活动关闭阶段
-define(ACT_STATUS_BOSS_BORN,   1).         %% Boss已创建
-define(ACT_STATUS_WAIT_NEXT,   2).         %% 等待下次活动Boss开启
-define(ACT_STATUS_ALL_KILL,    3).         %% 活动Boss被全部击杀

-define(MIN_BOSS_NUM,           15).
% -define(MAX_BOSS_NUM,           50).

-record(act_state, {
    status = 0,
    stage_etime = 0,
    ref = [],
    avg_online_num = 0,
    boss_list = []
    }).

-record(boss_status, {
    scene_id = 0,
    remain_num = 0,
    total_num = 0
    }).