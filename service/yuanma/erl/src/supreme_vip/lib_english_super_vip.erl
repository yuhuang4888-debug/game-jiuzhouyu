%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 英文需求 - SVIP需求
%%% @end
%%% Created : 16. 8月 2022 14:46
%%%-------------------------------------------------------------------
-module(lib_english_super_vip).

-include("common.hrl").
-include("server.hrl").
-include("english_super_vip.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% API
-export([
    send_open_act_info/1,
    handle_event/2
]).


handle_event(Player, #event_callback{ type_id = ?EVENT_RECHARGE }) ->
    send_open_act_info(Player),
    {ok, Player};
handle_event(Player, _) ->
    {ok, Player}.

send_open_act_info(Player) ->
    #player_status{
        id = PlayerId, c_source = PlayerSource, figure = #figure{ lv = PlayerLevel }
    } = Player,
    AllActIds = data_english_super_vip:get_all_act_id(),
    NowSec = utime:unixtime(),
    %% 组装player_Data
    %% {玩家渠道、玩家等级、玩家rmb、玩家勾玉数} 该处顺序不要修改，增加直接往后边插
    PlayerChannal = util:make_sure_list(PlayerSource),
    PlayerRMB = lib_recharge_data:get_total_rmb(PlayerId),
    PlayerDamond = lib_recharge_data:get_total(PlayerId),
    PlayerData = {PlayerChannal, PlayerLevel, PlayerRMB, PlayerDamond},
    OpenActId = filter_act_info(AllActIds, PlayerData, NowSec),
    case OpenActId of
        [] ->
            {ok, BinData} = pt_451:write(45120, [0, []]);
        _ ->
            #base_english_super_vip{
                ad_content = AdContent, pic_content = PicContent,
                pri_content = PriContent, con_content = ConContent
            } = data_english_super_vip:get_vip_act_info(OpenActId),
            AdContentIds = get_content_by_role_channel(AdContent, PlayerChannal, []),
            PicContentIds = get_content_by_role_channel(PicContent, PlayerChannal, []),
            ConContentIds = get_content_by_role_channel(ConContent, PlayerChannal, []),
            PriContentIds = get_content_by_role_channel(PriContent, PlayerChannal, []),
            SendList = [
                {?SVIP_ADVERTISING_SLOGAN, AdContentIds}, {?SVIP_PICTURE_CONTENT, PicContentIds},
                {?SVIP_PRIVILEGED_CONTENT, PriContentIds}, {?SVIP_CONTACT_CONTENT, ConContentIds}
            ],
            {ok, BinData} = pt_451:write(45120, [OpenActId, SendList])
    end,
    lib_server_send:send_to_uid(PlayerId, BinData).

filter_act_info([], _PlayerData, _NowSec) ->
    [];
filter_act_info([ActId|Tail], PlayerData, NowSec) ->
    #base_english_super_vip{
        condition = ConditionL, start_time = StartTime, end_time = EndTime
    } = data_english_super_vip:get_vip_act_info(ActId),

    case StartTime == 0 orelse EndTime == 0 orelse (NowSec >= StartTime orelse NowSec < EndTime)of
        true ->
            case check_condition(ConditionL, PlayerData, true) of
                true ->
                    ActId;       %% 与运营确认，最多同时只有一个活动开启
                _ ->
                    filter_act_info(Tail, PlayerData, NowSec)
            end;
        _ ->
            filter_act_info(Tail, PlayerData, NowSec)
    end.


check_condition([], _PlayerData, Result) ->
    Result;
check_condition(_ConditionL, _PlayerData, false) ->
    false;
check_condition([{Key, Value}|Tail], PlayerData, _Result) ->
    case Key of
        open_channel ->
            PlayerChannal = erlang:element(1, PlayerData),
            NewResult = ?IF(Value == [], true, lists:member(PlayerChannal, Value)),
            check_condition(Tail, PlayerData, NewResult);
        open_day ->
            OpenDay = util:get_open_day(),
            check_condition(Tail, PlayerData, OpenDay >= Value);
        open_lv ->
            PlayerLevel = erlang:element(2, PlayerData),
            check_condition(Tail, PlayerData, PlayerLevel >= Value);
        recharge_money ->
            PlayerMoney = erlang:element(3, PlayerData),
            check_condition(Tail, PlayerData, PlayerMoney >= Value);
        recharge_daimaond ->
            PlayerDamaond = erlang:element(4, PlayerData),
            check_condition(Tail, PlayerData, PlayerDamaond >= Value);
        _ ->
            check_condition(Tail, PlayerData, false)
    end.

get_content_by_role_channel([], _RoleChannel, ResultContent) ->
    lists:sort(ResultContent);
get_content_by_role_channel([{ChannelList, OpenContentList}|Tail], RoleChannel, ResultContent) ->
    case lists:member(RoleChannel, ChannelList) of
        true ->
            NewResultContent = OpenContentList ++ ResultContent,
            get_content_by_role_channel(Tail, RoleChannel, NewResultContent);
        _ ->
            get_content_by_role_channel(Tail, RoleChannel, ResultContent)
    end.
