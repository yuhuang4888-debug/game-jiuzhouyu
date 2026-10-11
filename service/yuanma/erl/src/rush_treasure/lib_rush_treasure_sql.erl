%%% -------------------------------------------------------------------
%%% @doc        lib_rush_treasure_sql                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-25 10:23               
%%% @deprecated 
%%% -------------------------------------------------------------------

-module(lib_rush_treasure_sql).

-include("rush_treasure.hrl").
-include("figure.hrl").

%% API
-export([
    db_select_rush_treasure_rank/0
    , db_rush_treasure_role_replace/2
    , db_replace_rush_treasure_rank/3
    , db_rush_treasure_delete/2
    , db_select_rush_treasure_role_by_type/2
    , db_delete_rush_treasure_rank/3
    , db_select_rush_treasure_role_by_role_id/1
    , db_rush_treasure_delete_by_role_id/3
    , db_batch_replace_rush_treasure_rank/1
]).

%% 获得冲榜夺宝排行榜
db_select_rush_treasure_rank() ->
    Sql = io_lib:format(
        <<"SELECT
            `role_id`,
            `type`,
            `subtype`,
            `server_id`,
            `platform`,
            `server_num`,
            `name`,
            `mask_id`,
            `score`,
            `time`,
            `server_name`
        FROM
            rush_treasure_rank
        ORDER BY
            score
        DESC">>,[]),
    db:get_all(Sql).

%% 榜单玩家表更新
db_replace_rush_treasure_rank(Type,SubType,RankRole)->
    #rank_role{
        id          = RoleId
        ,server_id  = ServerId
        ,platform   = Platform
        ,server_num = SerNum
        ,score      = Score
        ,last_time  = Time
        ,figure = #figure{name = Name, mask_id = MaskId}
        ,server_name = ServerName
    } = RankRole,
    NameF = util:fix_sql_str(Name),
    StrServerName = util:fix_sql_str(ServerName),
    Sql = io_lib:format(
        <<"REPLACE INTO
        `rush_treasure_rank`
            (`role_id`,
            `type`,
            `subtype`,
            `server_id`,
            `platform`,
            `server_num`,
            `name`,
            `mask_id`,
            `score`,
            `time`,
            `server_name`)
        VALUES
            (~p, ~p, ~p, ~p, '~s',~p, '~s',  ~p, ~p, ~p, '~s')">>,
        [RoleId, Type, SubType, ServerId, Platform, SerNum, NameF, MaskId, Score, Time, StrServerName]),
    db:execute(Sql).

%% 批量更新榜单玩家
db_batch_replace_rush_treasure_rank(UpdateList) ->
    F = fun({Type, SubType, RankRole}, ValueList) ->
        #rank_role{
            id            = RoleId
            ,server_id    = ServerId
            ,platform     = Platform
            ,server_num   = SerNum
            ,score        = Score
            ,last_time    = Time
            ,figure = #figure{name = Name, mask_id = MaskId}
            ,server_name = ServerName
        } = RankRole,
        NameF = util:fix_sql_str(Name),
        StrServerName = util:fix_sql_str(ServerName),
        Value =
            [
                RoleId,
                Type,
                SubType,
                ServerId,
                Platform,
                SerNum,
                NameF,
                MaskId,
                Score,
                Time,
                StrServerName
            ],
        [Value | ValueList]
        end,
    NewValueList = lists:foldl(F, [], UpdateList),
    Sql = usql:replace(rush_treasure_rank,
        [
            role_id,
            type,
            subtype,
            server_id,
            platform,
            server_num,
            name,
            mask_id,
            score,
            time,
            server_name
        ], NewValueList),
    length(UpdateList) =/= 0 andalso db:execute(Sql).

%% 删除榜单信息
db_delete_rush_treasure_rank(Type, SubType, ServerId) ->
    Sql = io_lib:format(<<"DELETE FROM `rush_treasure_rank` WHERE type= ~p AND subtype= ~p AND server_id = ~p">>,[Type, SubType, ServerId]),
    db:execute(Sql).

%% 更新冲榜夺宝玩家信息
db_rush_treasure_role_replace(RoleId, Data) ->
    #rush_treasure_data{
        type         = Type,
        subtype      = SubType,
        score        = Score,
        times        = Times,
        today_score  = TodayScore,
        reward_list  = RList,
        score_reward = SList,
        last_time    = Time
    } = Data,
    ReList = util:term_to_bitstring(RList),
    ScList = util:term_to_bitstring(SList),
    Sql = io_lib:format(
        <<"REPLACE INTO
        rush_treasure_role
            (`role_id`,
            `type`,
            `subtype`,
            `score`,
            `today_score`,
            `times`,
            `reward_list`,
            `score_reward`,
            `last_time`)
         VALUES
            (~p,~p,~p,~p,~p,~p,'~s','~s',~p)">>,
        [RoleId, Type, SubType, Score, TodayScore, Times, ReList, ScList, Time]),
    db:execute(Sql).

%% 通过主类型和子类型获得冲榜夺宝玩家信息
db_select_rush_treasure_role_by_type(Type, SubType) ->
    Sql = io_lib:format(
        <<"SELECT
            `role_id`,
            `type`,
            `subtype`,
            `score`,
            `today_score`,
            `times`,
            `reward_list`,
            `score_reward`,
            `last_time`
        FROM
            rush_treasure_role
        WHERE
            type= ~p AND subtype = ~p">>, [Type, SubType]),
    db:get_all(Sql).

%% 通过玩家Id获得冲榜夺宝玩家信息
db_select_rush_treasure_role_by_role_id(RoleId) ->
    Sql = io_lib:format(
        <<"SELECT
            `role_id`,
            `type`,
            `subtype`,
            `score`,
            `today_score`,
            `times`,
            `reward_list`,
            `score_reward`,
            `last_time`
        FROM
            rush_treasure_role
        WHERE
            role_id= ~p">>, [RoleId]),
    db:get_all(Sql).

%% 删除玩家表类型记录
db_rush_treasure_delete(Type, SubType)->
    Sql = io_lib:format(
        <<"DELETE FROM
            rush_treasure_role
        WHERE
            type = ~p
        AND
            subtype = ~p">>,
        [Type, SubType]),
    db:execute(Sql).

%% 删除玩家表类型记录
db_rush_treasure_delete_by_role_id(Type, SubType, RoleId)->
    Sql = io_lib:format(
        <<"DELETE FROM
            rush_treasure_role
        WHERE
            type = ~p
        AND
            subtype = ~p
        AND
            role_id = ~p">>,
        [Type, SubType, RoleId]),
    db:execute(Sql).