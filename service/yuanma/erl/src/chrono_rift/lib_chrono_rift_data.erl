%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_chrono_rift_data.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-11-12
%%% @modified
%%% @description    时空裂缝数据处理库函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_chrono_rift_data).

-include("chrono_rift.hrl").

% -export([]).

-compile(export_all).

%%% =========================================== make/load ==========================================

make_record(Type, Args) ->
    throw({'EXIT', {"make record error", {Type, Args}}}).

%%% ========================================= get/set/calc =========================================



%%% ============================================== sql =============================================

sql(Func, Expr, Args) ->
    Sql = io_lib:format(Expr, Args),
    db:Func(Sql).

%% chrono_rift_castle

db_get_castle(CastleId, ZoneId) ->
    sql(get_row, ?select_chrono_rift_castle, [CastleId, ZoneId]).

db_save_castle(Castle) ->
	#chrono_rift_castle{
        id                   = Id
        ,zone_id             = ZoneId
        ,current_server_id   = CurrentServerId
        % ,scramble_value      = _Values
        ,time                = Time
        ,occupy_count        = Count
        ,current_server_num  = CurrentServerNum
        ,current_server_name = CurrentServerName
        ,base_server_id      = BaseServerId
        , have_servers       = ServerIds
	} = Castle,
    ScrbValueBin = util:term_to_bitstring([]),
    ServerIdsBin = util:term_to_bitstring(ServerIds),

    Args = [Id, ZoneId, CurrentServerId, CurrentServerNum, CurrentServerName, ScrbValueBin, Count,
           BaseServerId, Time, ServerIdsBin],
    sql(execute, ?save_castle, Args).

%% chrono_rift_castle_role

db_get_castle_roles(CastleId, ZoneId) ->
    sql(get_all, ?select_chrono_rift_castle_role, [CastleId, ZoneId]).

db_save_castle_roles([]) -> ok;
db_save_castle_roles([Role | RoleList]) ->
	#castle_role_msg{
        role_id         = RoleId
        ,role_name      = RoleName
        ,castle_id      = CastleId
        ,server_id      = ServerId
        ,server_name    = ServerName
        ,server_num     = ServerNum
        ,scramble_value = Value
        ,is_occupy      = IsOcc
        ,zone_id        = ZoneId
	} = Role,
    RoleNameBin = util:fix_sql_str(RoleName),
    ServerNameBin = util:fix_sql_str(ServerName),

    Args = [RoleId, RoleNameBin, CastleId, ServerId, ServerNameBin, ServerNum, Value, IsOcc, ZoneId],
    sql(execute, ?save_castle_role, Args),
	db_save_castle_roles(RoleList).

%% chrono_rift_kf_role

db_get_rank_role() ->
    sql(get_all, ?select_chrono_rift_role_rank, []).

db_save_rank_role(Role) ->
	#rank_role_msg{
        role_id         = RoleId
        ,role_name      = RoleName
        ,server_num     = ServerNum
        ,server_name    = ServerName
        ,scramble_value = V1
        ,server_id      = ServerId
    } = Role,
    RoleNameBin = util:fix_sql_str(RoleName),
    ServerNameBin = util:fix_sql_str(ServerName),

    Args = [RoleId, RoleNameBin, ServerId, ServerNum, ServerNameBin, V1],
    sql(execute, ?save_chrono_rift_role_rank, Args).

db_truncate_rank_role() ->
    sql(execute, ?delete_chrono_rift_role_rank, []).

%% chrono_rift_role

db_get_status_role(RoleId) ->
    sql(get_row, ?select_chrono_rift_role, [RoleId]).

db_save_status_role(RoleId, ChronoInfo) ->
	#chrono_rift_in_ps{
        scramble_value     = V1
        ,today_value       = TodayV
        ,act_list          = ActList
        ,castle_id         = CastleId
        ,today_reward_list = TodayRewardList
        ,season_reward     = SeasonReward
	} = ChronoInfo,
    ActListBin = util:term_to_bitstring(ActList),
    TodayRewardBin = util:term_to_bitstring(TodayRewardList),
    SeasonRewardBin = util:term_to_bitstring(SeasonReward),

    Args = [RoleId, V1, TodayV, ActListBin, CastleId, TodayRewardBin, SeasonRewardBin],
    sql(execute, ?save_chrono_rift_role, Args).

%% chrono_rift_kf_goal

db_get_server_goal() ->
    sql(get_all, ?select_chrono_rift_kf_goal, []).

db_clear_server_goal() ->
    sql(execute, ?set_chrono_rift_kf_goal, []).

db_save_server_goal(ServerGoal) ->
	#server_goal{
		server_id = ServerId,
		server_num = ServerNum,
		server_name = Name,
		goal_list = GoalList,
		last_rank = Rank
	} = ServerGoal,
    GoalListBin = util:term_to_bitstring(GoalList),

    Args = [ServerId, Name, ServerNum, GoalListBin, Rank],
    sql(execute, ?save_chrono_rift_kf_goal, Args).