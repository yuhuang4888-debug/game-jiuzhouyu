%%-----------------------------------------------------------------------------
%% @Module  :       lib_kf_guild_war
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战
%%-----------------------------------------------------------------------------
-module(lib_kf_guild_war).

-include("kf_guild_war.hrl").

-export([
    check_stage/2
    , get_rest_time/0
    , get_game_type/0
    , get_open_lv/0
    , count_scene_pool_id/1
    , get_building_texture/2
    , is_kf_guild_war_server/0
    , format_time/1
    , get_code_building_id/0
    , get_island_name/1
    , get_props_name/1
    ]).

-export([
    send_to_uid/4
    , send_error_code/2
    , send_error_code/3
    ]).

check_stage(State, NowTime) ->
    #kf_guild_war_state{
        guild_map = GuildMap
    } = State,
    NowWeek = utime:day_of_week(NowTime),
    Unixdate = utime:unixdate(NowTime),
    OpenWeek = data_kf_guild_war:get_cfg(?CFG_ID_ACT_OPEN_WEEK),
    AppointTime = data_kf_guild_war:get_cfg(?CFG_ID_APPOINT_TIME),
    ConfirmTime = data_kf_guild_war:get_cfg(?CFG_ID_CONFIRM_TIME),
    case OpenWeek of
        [_, _] ->
            case lists:member(NowWeek, OpenWeek) of
                true ->
                    GameType = lib_kf_guild_war:get_game_type(),
                    case GameType of
                        ?GAME_TYPE_INSEA ->
                            case maps:size(GuildMap) > 0 of
                                true ->
                                    {Status, NextStatus, CountDownTime}
                                        = do_check_stage(format_time(AppointTime), format_time(ConfirmTime), NowTime - Unixdate, Unixdate),
                                    {Status, NextStatus, CountDownTime, NowTime + CountDownTime};
                                _ ->
                                    {?ACT_STATUS_CLOSE, ?ACT_STATUS_CLOSE, Unixdate + 86400 - NowTime, Unixdate + 86400}
                            end;
                        _ ->
                            {Status, NextStatus, CountDownTime}
                                = do_check_stage(format_time(AppointTime), format_time(ConfirmTime), NowTime - Unixdate, Unixdate),
                            {Status, NextStatus, CountDownTime, NowTime + CountDownTime}
                    end;
                false ->
                    {?ACT_STATUS_CLOSE, ?ACT_STATUS_CLOSE, Unixdate + 86400 - NowTime, Unixdate + 86400}
            end;
        _ ->
            {?ACT_STATUS_CLOSE, ?ACT_STATUS_CLOSE, Unixdate + 86400 - NowTime, Unixdate + 86400}
    end.

do_check_stage([AppointStime, AppointEtime], [ConfirmStime, ConfirmEtime], NowTime, Unixdate) ->
    if
        NowTime < AppointStime ->
            {?ACT_STATUS_CLOSE, ?ACT_STATUS_APPOINT, AppointStime - NowTime};
        NowTime >= AppointStime andalso NowTime < AppointEtime ->
            {?ACT_STATUS_APPOINT, ?ACT_STATUS_CONFIRM, AppointEtime - NowTime};
        NowTime >= ConfirmStime andalso NowTime < ConfirmEtime ->
            {?ACT_STATUS_CONFIRM, ?ACT_STATUS_BATTLE, ConfirmEtime - NowTime};
        true ->
            {?ACT_STATUS_CLOSE, ?ACT_STATUS_CLOSE, Unixdate + 86400 - NowTime}
    end;
do_check_stage(_, _, NowTime, Unixdate) ->
    {?ACT_STATUS_CLOSE, ?ACT_STATUS_CLOSE, Unixdate + 86400 - NowTime}.

format_time(TimeL) when is_list(TimeL) ->
    [H * 3600 + M * 60 + S||{H, M, S} <- TimeL];
format_time({H, M, S}) ->
    H * 3600 + M * 60 + S;
format_time(_) -> [].

%% 获取当前是外海战还是内海战
get_game_type() ->
    NowTime = utime:unixtime(),
    NowWeek = utime:day_of_week(NowTime),
    OpenWeek = data_kf_guild_war:get_cfg(?CFG_ID_ACT_OPEN_WEEK),
    case lists:member(NowWeek, OpenWeek) of
        true ->
            case OpenWeek of
                [NowWeek, _] -> ?GAME_TYPE_OPEN_SEA;
                _ -> ?GAME_TYPE_INSEA
            end;
        _ -> ?GAME_TYPE_OPEN_SEA
    end.

get_open_lv() ->
    case data_kf_guild_war:get_cfg(?CFG_ID_OPEN_LV) of
        OpenLv when is_integer(OpenLv) -> OpenLv;
        _ -> 0
    end.

%% 获取中场休息的时间
get_rest_time() ->
    FirRoundTime = data_kf_guild_war:get_cfg(?CFG_ID_FIR_ROUND_TIME),
    SecRoundTime = data_kf_guild_war:get_cfg(?CFG_ID_SEC_ROUND_TIME),
    do_get_rest_time(format_time(FirRoundTime), format_time(SecRoundTime)).

%% 获取海神像核心建筑id
get_code_building_id() ->
    AllBuildingIds = data_kf_guild_war:get_all_building_ids(),
    hd(lists:reverse(lists:sort(AllBuildingIds))).

do_get_rest_time([_FirStime, FirEtime], [SecStime, _SecEtime]) ->
    max(1, SecStime - FirEtime);
do_get_rest_time(_, _) -> 1.

%% 每N个房间开一个新进程
count_scene_pool_id(RoomId) ->
    RoomId div 8.

%% 获取船坞建筑的贴图
get_building_texture(OccupierGroup, TextureList) ->
    case lists:keyfind(OccupierGroup, 1, TextureList) of
        {OccupierGroup, Texture} -> Texture;
        _ -> 0
    end.

%% 获取岛屿的名字
get_island_name(IslandId) ->
    case data_kf_guild_war:get_island_cfg(IslandId) of
        #kf_gwar_island_cfg{name = IslandName} -> IslandName;
        _ -> <<>>
    end.

%% 获取道具的名字
get_props_name(PropsId) ->
    case data_kf_guild_war:get_props_cfg(PropsId) of
        #kf_gwar_props_cfg{name = PropsName} -> PropsName;
        _ -> <<>>
    end.

%% 检测本服是否有资格参加本次公会战
is_kf_guild_war_server() ->
    Opday = util:get_open_day(),
    OpdayLim = data_kf_guild_war:get_cfg(?CFG_ID_NEED_OPDAY),
    Opday >= OpdayLim.

send_to_uid(SerId, RoleId, Cmd, Args) when is_integer(SerId) ->
    case lib_clusters_center:get_node(SerId) of
        false -> skip;
        Node -> send_to_uid(Node, RoleId, Cmd, Args)
    end;
send_to_uid(Node, RoleId, Cmd, Args) ->
    {ok, BinData} = pt_437:write(Cmd, Args),
    lib_clusters_center:send_to_uid(Node, RoleId, BinData).

%% 发送错误码
send_error_code(Node, RoleId, ErrorCode) when is_integer(RoleId) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
    {ok, BinData} = pt_437:write(43700, [ErrorCodeInt, ErrorCodeArgs]),
    lib_clusters_center:send_to_uid(Node, RoleId, BinData).

send_error_code(RoleId, ErrorCode) when is_integer(RoleId) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
    {ok, BinData} = pt_437:write(43700, [ErrorCodeInt, ErrorCodeArgs]),
    lib_server_send:send_to_uid(RoleId, BinData);
send_error_code(Sid, ErrorCode) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
    {ok, BinData} = pt_437:write(43700, [ErrorCodeInt, ErrorCodeArgs]),
    lib_server_send:send_to_sid(Sid, BinData).