%%% -------------------------------------------------------------------
%%% @doc        lib_draw_simulation_sql                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-04-01 15:02               
%%% @deprecated 抽奖模拟持久层
%%% -------------------------------------------------------------------

-module(lib_draw_simulation_sql).

-include("common.hrl").

%% API
-export([db_get_max_simulation_num/2, db_batch_replace_draw_simulation_info/1]).

%% -----------------------------------------------------------------
%% @desc 获取最大序号
%% @param Type
%% @param SubType
%% @return
%% -----------------------------------------------------------------
db_get_max_simulation_num(Type, SubType) ->
    Sql = io_lib:format(
        <<"SELECT
            max(simulation_id)
        FROM
            log_draw_simulation
        WHERE
            type = ~p
        AND
            subtype = ~p">>, [Type, SubType]),
    db:get_row(Sql).

%% -----------------------------------------------------------------
%% @desc 批量插入日志
%% @param ResultList 日志列表
%% @return
%% -----------------------------------------------------------------
db_batch_replace_draw_simulation_info(ResultList) ->
    Sql = usql:replace(log_draw_simulation,
        [
            simulation_id,
            draw_num,
            type,
            subtype,
            reward_id,
            rewards,
            time
        ], ResultList),
    db:execute(Sql).