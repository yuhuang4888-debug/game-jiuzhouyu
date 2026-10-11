%%% -------------------------------------------------------------------
%%% @doc        lib_weekly_card_sql                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-21 11:02               
%%% @deprecated 周卡持久层
%%% -------------------------------------------------------------------

-module(lib_weekly_card_sql).

-include("weekly_card.hrl").

%% API
-export([
    db_get_weekly_card_info/1
    , db_replace_weekly_card_info/2
    , db_select_reissue_role/5
    , db_select_unexpired_weekly_card/0
    , db_batch_replace_weekly_card_info/1
    , db_select_player_mount/2
    , db_select_player_low/1
    , db_batch_replace_player_mount/1]).

%% -----------------------------------------------------------------
%% @desc 获得周卡信息
%% @param RoleId
%% @return
%% -----------------------------------------------------------------
db_get_weekly_card_info(RoleId) ->
    Sql = io_lib:format(
        <<"SELECT
            `lv`,
            `exp`,
            `is_activity`,
            `gift_bag_num`,
            `can_receive_gift`,
            `expired_time`,
            `reward_list`
        FROM
            player_weekly_card
        WHERE
            role_id = ~p">>, [RoleId]),
    db:get_all(Sql).

%% -----------------------------------------------------------------
%% @desc 更新周卡信息
%% @param RoleId
%% @param WeeklyCardStatus
%% @return
%% -----------------------------------------------------------------
db_replace_weekly_card_info(RoleId, WeeklyCardStatus) ->
    #weekly_card_status{
        lv               = Lv,
        exp              = Exp,
        is_activity      = IsActivity,
        gift_bag_num     = GiftBagNum,
        can_receive_gift = CanReceiveGift,
        expired_time     = ExpiredTime,
        reward_list      = BaseRewardList
    } = WeeklyCardStatus,
    RewardList = [{Type, lib_goods_api:make_reward_unique(List)} || {Type, List} <- BaseRewardList],
    Args = [RoleId, Lv, Exp, IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime, util:term_to_string(RewardList)],
    sql(execute,
        "REPLACE
        INTO
            player_weekly_card
                (role_id,
                lv,
                exp,
                is_activity,
                gift_bag_num,
                can_receive_gift,
                expired_time,
                reward_list)
        VALUES
            (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)",
        Args).

%% -----------------------------------------------------------------
%% @desc 获得未过期的周卡玩家信息
%% @param
%% @return
%% -----------------------------------------------------------------
db_select_unexpired_weekly_card() ->
    Sql = io_lib:format(
        <<"SELECT
            `role_id`,
            `lv`,
            `exp`,
            `is_activity`,
            `gift_bag_num`,
            `can_receive_gift`,
            `expired_time`,
            `reward_list`
        FROM
            player_weekly_card
        WHERE
            `is_activity` = ~p
        AND
            `expired_time` > ~p ">>, [?ACTIVATION_OPEN, 0]),
    db:get_all(Sql).

%% -----------------------------------------------------------------
%% @desc 批量更新周卡玩家信息
%% @param
%% @return
%% -----------------------------------------------------------------
db_batch_replace_weekly_card_info(ResultList) ->
    Sql = usql:replace(player_weekly_card,
        [
            role_id,
            lv,
            exp,
            is_activity,
            gift_bag_num,
            can_receive_gift,
            expired_time,
            reward_list
        ], ResultList),
    db:execute(Sql).

%% -----------------------------------------------------------------
%% @desc 根据类型获得计数器信息
%% @param
%% @return
%% -----------------------------------------------------------------
db_select_reissue_role(Module, SubModule, Type, StartTime, EndTime) ->
    Sql = io_lib:format(
        <<"SELECT
            `role_id`,
            `module`,
            `sub_module`,
            `type`,
            `count`,
            `other`,
            `refresh_time`
        FROM
            counter_daily_four
        WHERE
            module = ~p
        AND
            sub_module = ~p
        AND
            type = ~p
        AND
            refresh_time >= ~p
        AND
            refresh_time < ~p">>, [Module, SubModule, Type, StartTime, EndTime]),
    db:get_all(Sql).

%% -----------------------------------------------------------------
%% @desc
%% @param
%% @return
%% -----------------------------------------------------------------
db_select_player_mount(RoleId, TypeId) ->
    Sql = io_lib:format(
        <<"SELECT
            `role_id`,
            `type_id`,
            `stage`,
            `star`,
            `blessing`,
            `base_attr`,
            `illusion_type`,
            `illusion_id`,
            `illusion_color`,
            `is_ride`,
            `figure_id`,
            `auto_buy`,
            `etime`
        FROM
            player_mount
        WHERE
            role_id = ~p
        AND
            type_id = ~p">>, [RoleId, TypeId]),
    db:get_row(Sql).

%% -----------------------------------------------------------------
%% @desc
%% @param
%% @return
%% -----------------------------------------------------------------
db_select_player_low(RoleId) ->
    Sql = io_lib:format(
        <<"SELECT
            `id`,
            `nickname`,
            `sex`,
            `lv`,
            `career`
        FROM
            player_low
        WHERE
            id = ~p">>, [RoleId]),
    db:get_row(Sql).

db_batch_replace_player_mount(ResultList) ->
    Sql = usql:replace(player_mount,
        [
            role_id,
            type_id,
            stage,
            star,
            blessing,
            base_attr,
            illusion_type,
            illusion_id,
            illusion_color,
            is_ride,
            figure_id,
            auto_buy,
            etime
        ], ResultList),
    length(ResultList) =/= 0 andalso db:execute(Sql).

sql(Func, Expr, Args) ->
    Sql = io_lib:format(Expr, Args),
    db:Func(Sql).