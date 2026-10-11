%% ---------------------------------------------------------------------------
%% @doc data_team_m.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-04-12
%% @deprecated 队伍配置
%% ---------------------------------------------------------------------------
-module(data_team_m).
-export([
        get_arbitrate_time/2
        , get_fake_join_in_time/3
        , get/2
        , get_config/1
    ]).

-compile(export_all).

-include("server.hrl").
-include("team.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("activitycalen.hrl").

%% 获得仲裁的时间
%% @param #team_enlist.module
%% @param #team_enlist.sub_module
get_arbitrate_time(_Module, _SubModule) -> 15.

%% 获得假人匹配的时间(毫秒)
get_fake_join_in_time(_Module, _SubModule, 0) -> 3000; % 第一个假人匹配快点
get_fake_join_in_time(_Module, _SubModule, _FakeNum) -> 8000.

%% 获得假人匹配的时间的任务影响因子
%% @return [{任务id, 假人加入时间}]
get_fake_join_in_time_list(?ACTIVITY_ID_EQUIP) -> [{101270, 1500}];
get_fake_join_in_time_list(_) -> [].

get_fake_agree_gap(?ACTIVITY_ID_EQUIP) -> [{101270, 0}];
get_fake_agree_gap(_) -> [].

%% 组队玩法进入次数
%% @return {进入上限,剩余进入次数}
get(_ActivityId,_PS)->
    {0, 0}.

%% 配置
get_config(T) ->
    case T of
        %% 假人自动同意间隔
        fake_agree_gap -> 2
    end.

%% 获取触发的任务id列表状态
get_trigger_task_id_list() -> [101270].

