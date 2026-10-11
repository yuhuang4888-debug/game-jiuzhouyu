%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_guild_boss.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-06
%% @Description:    帮会boss副本进程
%%-----------------------------------------------------------------------------
-module (lib_dungeon_guild_boss).
-include ("dungeon.hrl").
-include ("server.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

%% 副本模块调用的接口
-export ([
    % get_start_dun_args/2
    dunex_stop_dungeon_when_no_role/4
    , get_force_quit_time/1
    , dunex_is_calc_result_before_finish/0
    % ,dungeon_destory/2
    % ,handle_quit_dungeon/2
    ,dunex_handle_enter_dungeon/2
    ,dunex_handle_dungeon_direct_end/1
    % ,handle_logout/1
    ]).

%% 自定义接口
-export ([
    start/2
    ,enter/3
    ]).

% get_start_dun_args(_Player, _Dun) ->
%     % TypicalList = [
%     %     {?DUN_STATE_SPCIAL_KEY_REPLACE_MON, {MonId1, MonId2, [{hp, Hp}]}}
%     % ],
%     % MonId1 副本配置里面Boss的id，MonId2 你自己的BossId，Hp 剩余血量
%     % [{typical_data, TypicalList}].
%     [].

% TypicalList = [
%     {?DUN_STATE_SPCIAL_KEY_REPLACE_MON, {MonId1, MonId2, [{hp, Hp}]}}
% ],
% MonId1 副本配置里面Boss的id，MonId2 你自己的BossId，Hp 剩余血量
% StartArgs = [{typical_data, TypicalList}].

start(DunId, StartArgs) ->
    Pid = mod_dungeon:start(0, self(), DunId, [], StartArgs),
    Pid.

% stop_dungeon_when_no_role(_State, _DungeonRole, _ResultType, _ResultSubtype) ->
dunex_stop_dungeon_when_no_role(_, _, _, _) ->
    false.

enter(Player, DunPid, DunId) ->
    case your_check() of
        true ->
            lib_dungeon:enter_dungeon(Player, DunId, DunPid);%% @return {ok, Player}
        Whatever ->
            Whatever
    end.

your_check() -> true.

dunex_is_calc_result_before_finish() -> false.

% dungeon_destory(_State, _Reason) ->
%     ok.

% handle_quit_dungeon(Player, _Dun) ->
%     Player.

dunex_handle_enter_dungeon(Player, _Dun) ->
    lib_task_api:guild_activity(Player#player_status.id, ?MOD_GUILD_ACT_BOSS),
    Player.

% handle_logout(_DungeonRole) ->
%     %% #dungeon_role{id = RoleId} = DungeonRole,
%     ok.

% handle_kill_mon(State, Mid, CreateKey, DieDatas) ->
%     State.


% -define(DUN_RESULT_TYPE_NO, 0).         % 没有结算
% -define(DUN_RESULT_TYPE_SUCCESS, 1).    % 挑战成功
% -define(DUN_RESULT_TYPE_FAIL, 2).       % 挑战失败
%% 副本结束时候，多少毫秒后强制退出副本
get_force_quit_time(ResultType) ->
    QuitTime = data_guild_boss:get_cfg(exit_time),
    RealQuitTime = ?IF(QuitTime =< 0, 10 * 1000, QuitTime * 1000),
    if
        ResultType == ?DUN_RESULT_TYPE_SUCCESS ->
            RealQuitTime;
        true ->
            0
    end.

dunex_handle_dungeon_direct_end(State) ->
    #dungeon_state{result_type = ResultType, result_time = ResultTime, typical_data = TypicalData} = State,
    #{?DUN_STATE_SPCIAL_KEY_GUILD_ID := GuildId} = TypicalData,
    RealResultType = case ResultType of
        ?DUN_RESULT_TYPE_SUCCESS -> 2;
        ?DUN_RESULT_TYPE_FAIL -> 3;
        _ -> ResultType
    end,
    lib_log_api:log_guild_boss(GuildId, RealResultType, ResultTime).
