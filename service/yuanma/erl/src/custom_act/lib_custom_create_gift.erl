%%---------------------------------------------------------------------------
%% @doc:        lib_custom_create_gift
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-6月-06. 16:15
%% @deprecated: 首发活动-创角有礼
%%---------------------------------------------------------------------------
-module(lib_custom_create_gift).

-include("rec_event.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("custom_act.hrl").

%% API
-export([
    handle_event/2,
    send_reward_email/1,
    act_end/2
]).


%% 升级或战力变化时触发
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    Type = ?CUSTOM_ACT_TYPE_CREATE_GIFT,
    AllSubIds = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType, TemPlayer) ->
        DataList = get_custom_act_data(TemPlayer, Type, SubType),
        case lists:keyfind(has_got, 1, DataList) of
            {has_got, _} ->
                TemPlayer;
            _ ->
                send_reward_email_in_memory(TemPlayer, Type, SubType)
        end
    end,
    LastPlayer = lists:foldl(Fun, Player, AllSubIds),
    {ok, LastPlayer};
handle_event(Player, _) ->
    {ok, Player}.

get_custom_act_data(Player, ActType, SubType) ->
    case lib_custom_act:act_data(Player, ActType, SubType) of
        #custom_act_data{ data = Data } -> Data;
        _ -> []
    end.

send_reward_email(PlayerId) ->
    Type = ?CUSTOM_ACT_TYPE_CREATE_GIFT,
    case db_get_player_lv_and_source(PlayerId) of
        {PlayerLevel, PlayerSource} ->
            AllSubIds = lib_custom_act_api:get_open_subtype_ids(Type),
            Fun = fun(SubType) ->
                do_send_reward_email(PlayerId, Type, SubType, PlayerLevel, PlayerSource)
            end,
            lists:foreach(Fun, AllSubIds);
        _ ->
            skip
    end.

send_reward_email_in_memory(Player, Type, SubType) ->
    #player_status{ id = PlayerId, figure = #figure{lv = PlayerLevel}, source = PlayerSource } = Player,
    #custom_act_cfg{ condition = ConditionL } = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {role_lv, CfgLevel} = ulists:keyfind(role_lv, 1, ConditionL, {role_lv, 0}),
    {source_list, SourceList} = ulists:keyfind(source_list, 1, ConditionL, {source_list, []}),
    case PlayerLevel >= CfgLevel andalso lists:member(util:bitstring_to_term(PlayerSource), SourceList) of
        true ->
            [GradeId|_] = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{ reward = RewardList } ->
                    %% 记录日志
                    lib_log_api:log_custom_act_reward(PlayerId, Type, SubType, GradeId, RewardList),
                    DataList = [{has_got, [GradeId]}],
                    Sql = io_lib:format(?SQL_SAVE_CUSTOM_ACT_DATA, [PlayerId, Type, SubType, util:term_to_string(DataList)]),
                    db:execute(Sql),
                    lib_mail_api:send_sys_mail([PlayerId], utext:get(3310117, []), utext:get(3310118, []), RewardList),
                    ActData = #custom_act_data{ id = {Type, SubType}, type = Type, subtype = SubType, data =  [{has_got, [GradeId]}]},
                    lib_custom_act:save_act_data_to_player(Player, ActData);
                _ ->
                    Player
            end;
        false ->
            Player
    end.


do_send_reward_email(PlayerId, Type, SubType, PlayerLevel, PlayerSource) ->
    ?MYLOG("lhh_create", "lhh_create:~p", [[PlayerId, Type, SubType, PlayerLevel, PlayerSource]]),
    #custom_act_cfg{ condition = ConditionL } = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {role_lv, CfgLevel} = ulists:keyfind(role_lv, 1, ConditionL, {role_lv, 0}),
    {source_list, SourceList} = ulists:keyfind(source_list, 1, ConditionL, {source_list, []}),
    case PlayerLevel >= CfgLevel andalso lists:member(PlayerSource, SourceList) of
        true ->
            [GradeId|_] = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{ reward = RewardList } ->
                    %% 记录日志
                    lib_log_api:log_custom_act_reward(PlayerId, Type, SubType, GradeId, RewardList),
                    DataList = [{has_got, [GradeId]}],
                    Sql = io_lib:format(?SQL_SAVE_CUSTOM_ACT_DATA, [PlayerId, Type, SubType, util:term_to_string(DataList)]),
                    db:execute(Sql),
                    lib_mail_api:send_sys_mail([PlayerId], utext:get(3310117, []), utext:get(3310118, []), RewardList);
                _ ->
                    skip
            end;
        false ->
            skip
    end.


%% 获取玩家的等级和渠道信息
-define(sql_get_player_lv_and_source, <<"select low.lv, login.source from player_low as low, player_login as login where low.id = ~p and login.id = ~p">>).
db_get_player_lv_and_source(PlayerId) ->
    Sql = io_lib:format(?sql_get_player_lv_and_source, [PlayerId, PlayerId]),
    case db:get_row(Sql) of
        [PlayerLevel, PlayerSource] ->
            {PlayerLevel, util:bitstring_to_term(PlayerSource)};
        Err ->
            ?ERR("role_id:~p db err: ~p", [PlayerId, Err]),
            []
    end.

%% 活动结束
act_end(Type, SubType) ->
    lib_custom_act:db_delete_custom_act_data(Type, SubType).