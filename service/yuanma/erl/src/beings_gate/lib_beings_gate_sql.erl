%%% -------------------------------------------------------------------
%%% @doc        lib_beings_gate_sql
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-28 16:06
%%% @deprecated 众生之门持久层
%%% -------------------------------------------------------------------

-module(lib_beings_gate_sql).

-include("beings_gate.hrl").

%% API
-export([
    db_select_beings_gate_activity/0
    , db_replace_beings_gate_activity/1
    , db_select_beings_gate_activity_cls/0
    , db_replace_beings_gate_activity_cls/1
    , db_truncate_beings_gate_activity/0
]).

%% -----------------------------------------------------------------
%% @desc 获得本服活跃度信息
%% @param
%% @return
%% -----------------------------------------------------------------
db_select_beings_gate_activity() ->
    Sql = io_lib:format(
        <<"SELECT
            `server_id`,
            `yesterday`,
            `today`,
            `time`
        FROM
            beings_gate_activity">>, []),
    db:get_all(Sql).

%% -----------------------------------------------------------------
%% @desc 更新本服活跃度信息
%% @param ActivityDataList
%% @return
%% -----------------------------------------------------------------
db_replace_beings_gate_activity(ActivityDataList) ->
    F = fun(ActivityData, ValueList) ->
        #activity_data{
            server_id = ServerId,
            yesterday = Yesterday,
            today     = Today,
            time      = Time
        } = ActivityData,
        Value =
            [
                ServerId,
                Yesterday,
                Today,
                Time
            ],
        [Value | ValueList]
        end,
    NewValueList = lists:foldl(F, [], ActivityDataList),
    Sql = usql:replace(beings_gate_activity,
        [
            server_id,
            yesterday,
            today,
            time
        ], NewValueList),
    NewValueList /= [] andalso db:execute(Sql).

%% -----------------------------------------------------------------
%% @desc 获得各服活跃度信息
%% @param
%% @return
%% -----------------------------------------------------------------
db_select_beings_gate_activity_cls() ->
    Sql = io_lib:format(
        <<"SELECT
            `server_id`,
            `yesterday`,
            `today`,
            `time`
        FROM
            beings_gate_activity_cls">>, []),
    db:get_all(Sql).

%% -----------------------------------------------------------------
%% @desc 更新各服活跃度信息
%% @param ActivityDataList
%% @return
%% -----------------------------------------------------------------
db_replace_beings_gate_activity_cls(ActivityDataList) ->
    F = fun(ActivityData, ValueList) ->
        #activity_data{
            server_id = ServerId,
            yesterday = Yesterday,
            today     = Today,
            time      = Time
        } = ActivityData,
        Value =
            [
                ServerId,
                Yesterday,
                Today,
                Time
            ],
        [Value | ValueList]
        end,
    NewValueList = lists:foldl(F, [], ActivityDataList),
    Sql = usql:replace(beings_gate_activity_cls,
        [
            server_id,
            yesterday,
            today,
            time
        ], NewValueList),
    db:execute(Sql).

%% -----------------------------------------------------------------
%% @desc 清空活跃度信息
%% @return
%% -----------------------------------------------------------------
db_truncate_beings_gate_activity() ->
    Sql1 = io_lib:format(<<"truncate table beings_gate_activity">>, []),
    Sql2 = io_lib:format(<<"truncate table beings_gate_activity_cls">>, []),
    db:execute(Sql1),
    db:execute(Sql2),
    ok.