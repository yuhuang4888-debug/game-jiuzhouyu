%%% ----------------------------------------------------
%%% @Module:        lib_3v3_center
%%% @Author:        zhl
%%% @Description:   跨服3v3中心
%%% @Created:       2017/07/05
%%% ----------------------------------------------------

-module(lib_3v3_center).

%% API
-compile(export_all).

-export([
        load_act_time/0,                             %% 读取活动时间

        create_team/1,                               %% 创建队伍
        to_join_team/1,                              %% 申请入队伍 | 受邀入队伍
        leave_team/1,                                %% 离开队伍
        kick_out_team/1,                             %% 踢出队伍
        start_matching_team/1,                       %% 开始匹配 - 战斗
        stop_matching_team/1,                        %% 取消匹配 - 战斗
        all_stop_matching_team/1,
        start_matching_role/1,                       %% 开始匹配 - 组队
        % stop_matching_role/1,                        %% 取消匹配 - 组队
        reset_ready/1,                               %% 准备 | 取消准备
        reset_auto/1,                                %% 自动开始 | 取消自动开始
        refresh_team_member/2,                       %% 刷新队友队伍信息
        refresh_team_member/1,                       %% 刷新队友队伍信息

        send_leave_pk_room_notice/2,                 %% 推送退出战斗房间提醒
        send_enter_pk_room_notice/2,                 %% 推送重登战斗战场提醒
        send_start_matching_notice/2,                %% 推送开始匹配提醒
        send_stop_matching_notice/2,                 %% 推送取消匹配提醒

        msg_to_team/2,                               %% 发送队伍消息

        matching_team/1,                             %% 匹配队伍
        matching_role/3,                             %% 匹配组队
        create_pk_room/1,                            %% 创建战斗房间

        calc_map_power/1,                            %% 求算映射战力
        calc_map_power/2,                            %% 求算映射战力
        to_kf_3v3_role_data/1,                       %% 转换#kf_3v3_role_data{}
        to_kf_3v3_role_data/2,                       %% 转换#kf_3v3_role_data{}
        to_invite_info/2,                            %% 转换成邀请信息
        get_unite_role_data/1,                       %% 找到玩家的参与数据
        get_unite_team_data/1,                       %% 找到玩家的队伍数据
        get_captain_team_data/1,                     %% 找到队长的队伍数据
        get_unite_pk_data/1,                         %% 找到进行中战斗数据
        update_unite_team_data/1,                    %% 更新队伍信息

        is_in_team/1,                                %% 是否在队伍中
        is_in_pk_data/2,                             %% 是否在战斗队伍中
        revive/1,                                    %% 获取复活信息
        get_tower_info/0,
        get_tower_xy/1,
        get_tower_id/2,
        get_guardian_info/0,
        create_team_when_role_match_over/3,
        go_to_match_team/1,
        test/0,
        disband_team/1                               %%战斗结束后，解散队伍，删除个人信息
        ,enter_or_quit_tower/3                       %%进出塔
        ,get_role_list_msg/2                         %%获取pk中的玩家信息
    ]).

% -export([
%         collect_complete/1                           %% 采集完毕
%     ]).

-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("3v3.hrl").
-include("predefine.hrl").
-include("mount.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("reincarnation.hrl").
-include("common.hrl").

%% 读取活动时间
load_act_time() ->
    ActList = data_3v3:get_act_list(),
    DayOfWeek = utime:day_of_week(),
    NowSec = utime:get_seconds_from_midnight(),
    F = fun(ActID, List) ->
        case data_3v3:get_act_info(ActID) of
            #act_info{week = WeekList, time = [StarTime, EndTime]} ->
                IsToday = lists:member(DayOfWeek, WeekList),
                StTime = calendar:time_to_seconds(StarTime),
                EdTime = calendar:time_to_seconds(EndTime),
                IsNotEnd = EdTime > NowSec,
                if
                    IsToday andalso IsNotEnd ->
                        [{StTime, EdTime} | List];
                    true ->
                        List
                end;
            _ ->
                List
        end
    end,
    case sort_time(lists:foldl(F, [], ActList)) of
        [] -> [];
        [ActTime | _] -> ActTime
    end.

sort_time(TimeList) ->
    F = fun({StTime1, _}, {StTime2, _}) ->
        StTime1 < StTime2
    end,
    lists:sort(F, TimeList).

%% 创建队伍
%% @RoleData : #role_data{}
%% @UniteRoleData : #kf_3v3_role_data{}
create_team([RoleData, AutoID, UniteRoleData]) ->
    #role_data{
        node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        role_id = RoleID, sid = RoleSid,
        figure = Figure = #figure{name = Nickname}, power = Power,
        power_limit = PowerLimit, lv_limit = LvLimit, password = Password,
        is_auto = IsAuto, tier = Tier, star = Star, continued_win = ContinuedWin, old_scene_info = OldSceneInfo
    } = RoleData,
    NUniteRoleData = UniteRoleData#kf_3v3_role_data{
        team_id = AutoID, node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        role_id = RoleID, sid = RoleSid,
        figure = Figure, power = Power,
        is_ready = ?KF_3V3_IS_READY, tier = Tier, star = Star,
        continued_win = ContinuedWin, old_scene_info = OldSceneInfo
    },
    MemberNum = 1,
    MapPower = calc_map_power(MemberNum, [NUniteRoleData]),
    TeamData = #kf_3v3_team_data{
        team_id = AutoID, captain_name = Nickname, captain_id = RoleID, captain_sid = RoleSid,
        server_name = ServerName, server_num = ServerNum, server_id = ServerId, password = Password, lv_limit = LvLimit,
        power_limit = PowerLimit, is_auto = IsAuto, member_num = MemberNum, map_power = MapPower,
        member_data = [NUniteRoleData], team_type = 1
    },
    {ok, NUniteRoleData, TeamData}.

%% 求算映射战力
%% @desc : MemberData = [#kf_3v3_role_data{}, ...]
%% @return : integer()
calc_map_power(_, []) ->
    0;
calc_map_power(MemberNum, MemberData) ->
    PowerList = [Power || #kf_3v3_role_data{power = Power} <- MemberData],
    if
        MemberNum == 1 ->
            calc_map_power([0, 0 | PowerList]);
        MemberNum == 2 ->
            calc_map_power([0 | PowerList]);
        true ->
            calc_map_power(PowerList)
    end.

%% ======================= 队伍战力公式（用来反馈队伍的战力）=======================
%%  三个人的战力分别是A B C
%%  我们战力数值比较大，计算过程需要平方，所以建议是先除以10000向下取整再计算
%%  a=int(A/10000)
%%  b=int(B/10000)
%%  c=int(C/10000)
%%
%%  队伍匹配分=(a+b+c)^2+K*（绝对值(a^2-b^2)+绝对值(b^2-c^2)+绝对值(a^2-c^2)）
%%  K是参数，用于调节
%%
%%  1个玩家时，b&c=0
%%  2个玩家时，c=0
%% =====================================================================================
calc_map_power([0, 0, C1]) ->
    C1;
%%    A = util:floor(A1 / 10000),
%%    B = util:floor(B1 / 10000),
%%    C = util:floor(C1 / 10000),
%%    K = 0.7,
%%    (A + B + C) * (A + B + C) + K * (erlang:abs(A * A - B * B) + erlang:abs(A * A - C * C) + erlang:abs(C * C - B * B)).

calc_map_power([0, B1, C1]) ->
   round((B1 + C1) / 2);

calc_map_power([A1, B1, C1]) ->
    round((A1 + B1 + C1) / 3).


%% 转换#kf_3v3_role_data{}
%% @RoleData : #role_data{}
to_kf_3v3_role_data(RoleData) ->
    #role_data{
        node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        role_id = RoleID, sid = RoleSid, figure = Figure, power = Power,
        tier = Tier, star = Star, continued_win = ContinuedWin, match_count = MatchCount,
        old_scene_info = OldSceneInfo, is_single = IsSingle
    } = RoleData,
    #kf_3v3_role_data{
        node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        role_id = RoleID, sid = RoleSid, figure = Figure, power = Power,
        tier = Tier, star = Star, continued_win = ContinuedWin, match_count = MatchCount,
        old_scene_info = OldSceneInfo, is_single = IsSingle
    }.
%% @UniteRoleData : #kf_3v3_role_data{}
to_kf_3v3_role_data(RoleData, UniteRoleData) ->
    #role_data{
        node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        role_id = RoleID, sid = RoleSid, figure = Figure, power = Power,
        tier = Tier, star = Star, continued_win = ContinuedWin, match_count = MatchCount,
        old_scene_info = OldSceneInfo, is_single = IsSingle
    } = RoleData,
    UniteRoleData#kf_3v3_role_data{
        node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        role_id = RoleID, sid = RoleSid, figure = Figure, power = Power,
        tier = Tier, star = Star, continued_win = ContinuedWin, match_count = MatchCount,
        old_scene_info = OldSceneInfo, is_single = IsSingle
    }.

%% 转换成邀请信息
to_invite_info(UniteRoleData, TeamData) ->
    #kf_3v3_role_data{
        team_id = TeamID, figure = #figure{name = Nickname}, role_id = RoleID
    } = UniteRoleData,
    #kf_3v3_team_data{password = Password, member_data = MemberData} = TeamData,
    case lists:keyfind(RoleID, #kf_3v3_role_data.role_id, MemberData) of
        #kf_3v3_role_data{
                figure = #figure{
                    picture = Picture, picture_ver = PictureVer, career = Career, sex = Sex, vip = VipLv, lv = Lv, title = Title, guild_name = GuildName, turn = Turn}
                    } ->
            [TeamID, RoleID, Nickname, Picture, PictureVer, Title, GuildName, Career, Sex, Lv, Turn, VipLv, Password];
        _ ->
            []
    end.

%% 是否在队伍中
%% @desc : 注意，这个方法只允许mod_3v3_center进程使用
is_in_team([_Platform, _ServerNum, RoleID]) ->
    % case ets:match_object(?ETS_ROLE_DATA, #kf_3v3_role_data{
    %       platform = Platform, server_num = ServerNum, role_id = RoleID, _ = '_'})
    % of
    %   [#kf_3v3_role_data{team_id = TeamID}] when TeamID > 0 ->
    %       Ret = {false, ?ERRCODE(err650_kf_3v3_in_team)};
    %   [#kf_3v3_role_data{} = UniteRoleData] ->
    %       Ret = {ok, UniteRoleData};
    %   _ -> %% 不曾参与过跨服3v3
    %       Ret = {ok, #kf_3v3_role_data{}}
    % end,
    % Ret;
    is_in_team(RoleID);
is_in_team(RoleID) ->
    case ets:lookup(?ETS_ROLE_DATA, RoleID) of
        [#kf_3v3_role_data{team_id = TeamID}] when TeamID > 0 ->
            Ret = {false, ?ERRCODE(err650_kf_3v3_in_team)};
        [#kf_3v3_role_data{} = UniteRoleData] ->
            Ret = {ok, UniteRoleData};
        _ -> %% 不曾参与过跨服3v3
            Ret = {ok, #kf_3v3_role_data{}}
    end,
    Ret.

%% 是否在战斗队伍中
is_in_pk_data(_, []) ->
    false;
is_in_pk_data(RoleID, [#kf_3v3_team_data{team_id = TeamID, member_data = MemberData} | Rest]) ->
    case lists:keyfind(RoleID, #kf_3v3_role_data.role_id, MemberData) of
        #kf_3v3_role_data{} ->
            {ok, TeamID};
        _ ->
            is_in_pk_data(RoleID, Rest)
    end.

%% 申请入队伍 | 受邀入队伍
%% @return : {false, ResID} | {ok, NUniteRoleData, NTeamData}
to_join_team([TeamID, Password, RoleData, UniteRoleData, MemberLimit]) ->
    UniteRoleData1 = to_kf_3v3_role_data(RoleData, UniteRoleData),
    #role_data{power = Power, figure = #figure{lv = RoleLv}} = RoleData,
    ?PRINT("to_join_team~p~n", [MemberLimit]),
    case ets:lookup(?ETS_TEAM_DATA, TeamID) of
        [#kf_3v3_team_data{member_num = MemberNum} = TeamData]
        when MemberNum < MemberLimit ->
            KeyValueList = [
                {password, Password, TeamData},
                {power_limit, Power, TeamData},
                {lv_limit, RoleLv, TeamData}
            ],
            case check_list(KeyValueList) of
                true ->
                    Ret = join_team(UniteRoleData1, TeamData);
                {false, _} = Ret ->
                    ok;
                _ ->
                    Ret = {false, ?FAIL}
            end;
        [#kf_3v3_team_data{}] -> %% 满员
            Ret = {false, ?ERRCODE(err650_kf_3v3_full_member)};
        _ ->
            Ret = {false, ?ERRCODE(err650_kf_3v3_no_team)}
    end,
    Ret.

%% 离开队伍
leave_team([UniteRoleData, TeamList]) ->
    #kf_3v3_role_data{
        team_id = TeamID, figure = #figure{name = Nickname}, server_name = ServerName,
        server_num = ServerNum, role_id = RoleID
    } = UniteRoleData,
    Data = [ServerName, ServerNum, RoleID, Nickname],
    case lists:keyfind(TeamID, #kf_3v3_team_data.team_id, TeamList) of
        #kf_3v3_team_data{captain_id = OldCaptainID, member_data = MemberData} = TeamData ->
            MemberData1 = lists:keydelete(RoleID, #kf_3v3_role_data.role_id, MemberData),
            if
                RoleID == OldCaptainID -> %% 队长退出队伍转让队长
                    Res = transfer_captain(MemberData1, TeamData);
                true ->
                    Res = {ok, TeamData}
            end,
            case Res of
                {ok, TeamData1} ->
                    [#kf_3v3_role_data{role_id = CaptainID} = Captain | _] = MemberData1,
                    NCaptain = Captain#kf_3v3_role_data{is_ready = ?KF_3V3_IS_READY},
                    NMemberData = lists:keyreplace(
                        CaptainID, #kf_3v3_role_data.role_id, MemberData1, NCaptain),
                    MemberNum = length(NMemberData),
                    MapPower = calc_map_power(MemberNum, NMemberData),
                    NTeamData = TeamData1#kf_3v3_team_data{
                        member_num = MemberNum, map_power = MapPower, member_data = NMemberData},
                    KeyValueList = [
                        {delete, ?ETS_ROLE_DATA, RoleID},
                        {update, ?ETS_TEAM_DATA, NTeamData}
                    ],
                    send_leave_notice(NMemberData, Data);
                _ -> %% 队伍没有成员 - 删除
                    KeyValueList = [
                        {delete, ?ETS_ROLE_DATA, RoleID},
                        {delete, ?ETS_TEAM_DATA, TeamID}
                    ]
            end;
        _ ->
            KeyValueList = [{delete, ?ETS_ROLE_DATA, RoleID}]
    end,
    KeyValueList;
leave_team(#kf_3v3_role_data{
        team_id = TeamID, figure = #figure{name = Nickname}, server_name = ServerName,
        server_num = ServerNum, role_id = RoleID
        }) ->
    Data = [ServerName, ServerNum, RoleID, Nickname],
    case ets:lookup(?ETS_TEAM_DATA, TeamID) of
        [#kf_3v3_team_data{captain_id = OldCaptainID, member_data = MemberData
        } = TeamData] ->
            MemberData1 = lists:keydelete(RoleID, #kf_3v3_role_data.role_id, MemberData),
            if
                RoleID == OldCaptainID -> %% 队长退出队伍转让队长
                    Res = transfer_captain(MemberData1, TeamData);
                true ->
                    Res = {ok, TeamData}
            end,
            case Res of
                {ok, TeamData1} ->
                    [#kf_3v3_role_data{role_id = CaptainID} = Captain | _] = MemberData1,
                    NCaptain = Captain#kf_3v3_role_data{is_ready = ?KF_3V3_IS_READY},
                    NMemberData = lists:keyreplace(
                        CaptainID, #kf_3v3_role_data.role_id, MemberData1, NCaptain),
                    MemberNum = length(NMemberData),
                    MapPower = calc_map_power(MemberNum, NMemberData),
                    NTeamData = TeamData1#kf_3v3_team_data{
                        member_num = MemberNum, map_power = MapPower, member_data = NMemberData},
                    KeyValueList = [
                        {delete, ?ETS_ROLE_DATA, RoleID},
                        {update, ?ETS_TEAM_DATA, NTeamData}
                    ],
                    send_leave_notice(NMemberData, Data);
                _ -> %% 队伍没有成员 - 删除
                    KeyValueList = [
                        {delete, ?ETS_ROLE_DATA, RoleID},
                        {delete, ?ETS_TEAM_DATA, TeamID}
                    ]
            end;
        _ ->
            KeyValueList = [{delete, ?ETS_ROLE_DATA, RoleID}]
    end,
    KeyValueList.

%% 转让队长
transfer_captain([], _) ->
    false;
transfer_captain([UniteRoleData | _], #kf_3v3_team_data{} = TeamData) ->
    #kf_3v3_role_data{
        figure = #figure{name = Nickname}, role_id = RoleID,
        server_name = ServerName, server_num = ServerNum, server_id = ServerId
    } = UniteRoleData,
    NTeamData = TeamData#kf_3v3_team_data{
        captain_name = Nickname, captain_id = RoleID,
        server_name = ServerName, server_num = ServerNum, server_id = ServerId
    },
    {ok, NTeamData}.

%% 踢出队伍
%% @return : {ok, ResID, KeyValueList} | {false, ResID} | {false, ResID, KeyValueList}
%%  --------------------------------------------------------------------- TODO 战斗中不能踢出队伍
kick_out_team([TRID, Captain]) ->
    #kf_3v3_role_data{team_id = TeamID, role_id = RoleID} = Captain,
    case ets:lookup(?ETS_TEAM_DATA, TeamID) of
        [#kf_3v3_team_data{captain_id = CaptainID, member_data = MemberData} = TeamData] ->
            if
                RoleID /= CaptainID -> %% 不是队长不能踢出队友
                    Ret = {false, ?ERRCODE(err650_kf_3v3_not_captain)};
                true ->
                    case find_member(MemberData, [TRID]) of
                        {ok, #kf_3v3_role_data{
                            server_name = ServerName, server_num = ServerNum, server_id = ServerId,
                                sid = RoleSid, figure = #figure{name = TName} }
                                } ->
                            NMemberData = lists:keydelete(
                                    TRID, #kf_3v3_role_data.role_id, MemberData
                                ),
                            MemberNum = length(NMemberData),
                            MapPower = calc_map_power(MemberNum, NMemberData),
                            NTeamData = TeamData#kf_3v3_team_data{
                                member_num = MemberNum, map_power = MapPower, member_data = NMemberData
                            },
                            KeyValueList = [
                                {delete, ?ETS_ROLE_DATA, TRID},
                                {update, ?ETS_TEAM_DATA, NTeamData}
                            ],
                            Ret = {ok, ?SUCCESS, KeyValueList},
                            send_kick_notice([ServerId, RoleSid]), %% 被踢者提示
                            send_leave_notice(NMemberData, [ServerName, ServerNum, TRID, TName]); %% 队员提示
                        Ret -> ok
                    end
            end;
        _ -> %% 找不到队伍
            KeyValueList = [{delete, ?ETS_ROLE_DATA, RoleID}],
            Ret = {false, ?ERRCODE(err650_kf_3v3_no_team), KeyValueList}
    end,
    Ret.

%% 开始匹配
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
%% @return : {ok, NCandinates} | {false, ResID}
start_matching_team([RoleID, Candinates, _MemberLimit]) ->
    case get_unite_role_data(RoleID) of
        {ok, #kf_3v3_role_data{pk_pid = PKPid}} when is_pid(PKPid) ->
            Ret = {false, ?ERRCODE(err650_kf_3v3_fighting)};
        {ok, #kf_3v3_role_data{team_id = TeamID}}  ->
            case get_captain_team_data([TeamID, RoleID]) of
                {ok, #kf_3v3_team_data{member_data = MemberData} = TeamData} ->
                    IsAllReady = is_all_ready(MemberData),
                    if
                        IsAllReady ->
                            case lists:keyfind(TeamID, #kf_3v3_team_data.team_id, Candinates) of
                                #kf_3v3_team_data{} -> %% 匹配中
                                    Ret = {ok, Candinates};
                                _ -> %% 开始匹配
                                    ?MYLOG("3v3", "start_matching_team  ~n", []),
                                    %%设置正在匹配的状态
                                    ets:insert(?ETS_TEAM_DATA, TeamData#kf_3v3_team_data{is_match = 1}),
                                    send_start_matching_notice(MemberData, [?SUCCESS]),  %%
                                    Ret = {ok, [TeamData | Candinates]}
                            end;
                        true ->
                            Ret = {false, ?ERRCODE(err650_kf_3v3_not_ready)}
                    end;
                Ret -> ok
            end;
        Ret -> ok
    end,
    Ret.

is_all_ready([]) ->
    true;
is_all_ready([#kf_3v3_role_data{is_ready = IsReady} | Rest]) ->
    if
        IsReady /= ?KF_3V3_IS_READY ->
            false;
        true ->
            is_all_ready(Rest)
    end.

%% 取消匹配
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
%% @return : {ok, NCandinates} | {false, ResID}
stop_matching_team([ServerName, ServerNum, RoleID, Candinates]) ->
    case get_unite_role_data(RoleID) of
        {ok, #kf_3v3_role_data{pk_pid = PKPid}} when is_pid(PKPid) -> %% 战斗中，不能取消
            Ret = {false, ?ERRCODE(err650_kf_3v3_fighting)};
        {ok, #kf_3v3_role_data{team_id = TeamID}} ->
            case lists:keyfind(TeamID, #kf_3v3_team_data.team_id, Candinates) of
                #kf_3v3_team_data{member_data = _MemberData} -> %% 取消匹配
                    NCandinates = lists:keydelete(TeamID, #kf_3v3_team_data.team_id, Candinates),
                    Ret = {ok, NCandinates},
                    _Data = [?SUCCESS, ServerName, ServerNum, RoleID];
                _ ->
                    Ret = {false, ?SUCCESS}
            end;
        Ret -> ok
    end,
    Ret.


%% 取消队伍的匹配 todo
all_stop_matching_team([]) -> ok;
all_stop_matching_team([#kf_3v3_team_data{
    server_name = ServerName, server_num = ServerNum, captain_id = RoleID,
        member_data = MemberData} | Rest]) ->
    Data = [?SUCCESS, ServerName, ServerNum, RoleID],
    send_stop_matching_notice(MemberData, Data),
    all_stop_matching_team(Rest).

%% 开始匹配 - 组队
start_matching_role([#role_data{role_id = RoleID} = RoleData, MacthRole]) ->
    case ets:lookup(?ETS_ROLE_DATA, RoleID) of
        [#kf_3v3_role_data{team_id = TeamID}] when TeamID > 0 ->
            {false, ?ERRCODE(err650_kf_3v3_in_team)};
        [#kf_3v3_role_data{pk_pid = PKPid}] when is_pid(PKPid) ->
            {false, ?ERRCODE(err650_kf_3v3_fighting)};
        _ ->
            case lists:keyfind(RoleID, #role_data.role_id, MacthRole) of
                #role_data{} ->
                    {false, ?ERRCODE(err650_kf_3v3_matching)};
                _ ->
                    {ok, [RoleData | MacthRole]}
            end
    end.

%% 准备 | 取消准备
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
%% @return : {false, ResID} | {ok, KeyValueList, Candinates}
reset_ready([RoleID, Candinates, IsReady]) ->
    case get_unite_role_data(RoleID) of
        % {ok, #kf_3v3_role_data{is_ready = IsReady}} -> %% 不需要修改
        %   Ret = {false, ?SUCCESS};
        {ok, #kf_3v3_role_data{team_id = TeamID} = UniteRoleData} ->
            NUniteRoleData = UniteRoleData#kf_3v3_role_data{is_ready = IsReady},
            case get_unite_team_data(TeamID) of
                {ok, #kf_3v3_team_data{captain_id = CaptainID}}
                        when RoleID == CaptainID ->
                    Ret = {false, ?ERRCODE(err650_kf_3v3_cannot_reset_ready)};
                {ok, #kf_3v3_team_data{member_data = MemberData} = TeamData} ->
                    NMemberData = lists:keyreplace(
                        RoleID, #kf_3v3_role_data.role_id, MemberData, NUniteRoleData),
                    NTeamData = TeamData#kf_3v3_team_data{member_data = NMemberData},
                    KeyValueList = [
                        {update, ?ETS_ROLE_DATA, NUniteRoleData},
                        {update, ?ETS_TEAM_DATA, NTeamData}
                    ],
                    NCandinates = lists:keydelete(TeamID, #kf_3v3_team_data.team_id, Candinates),
                    refresh_team_member(NMemberData, KeyValueList),
                    Ret = {ok, KeyValueList, NCandinates};
                _ ->
                    KeyValueList = [{update, ?ETS_ROLE_DATA, NUniteRoleData}],
                    Ret = {ok, KeyValueList, Candinates}
            end;
        _ ->
%%            ?MYLOG("3v32", "err650_kf_3v3_not_joined ~n", []),
            Ret = {false, ?ERRCODE(err650_kf_3v3_not_joined)}
    end,
    Ret.

%% 自动开始 | 取消自动开始
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
%% @return : {false, ResID} | {ok, KeyValueList}
reset_auto([RoleID, IsAuto]) ->
    case get_unite_role_data(RoleID) of
        {ok, #kf_3v3_role_data{team_id = TeamID}} ->
            case get_captain_team_data([TeamID, RoleID]) of
                {ok, #kf_3v3_team_data{member_data = MemberData} = TeamData} ->
                    NTeamData = TeamData#kf_3v3_team_data{is_auto = IsAuto},
                    KeyValueList = [
                        {update, ?ETS_TEAM_DATA, NTeamData}
                    ],
                    refresh_team_member(MemberData, KeyValueList),
                    Ret = {ok, KeyValueList};
                _ ->
                    Ret = {false, ?ERRCODE(err650_kf_3v3_not_captain)}
            end;
        _ ->
%%            ?MYLOG("3v32", "err650_kf_3v3_not_joined ~n", []),
            Ret = {false, ?ERRCODE(err650_kf_3v3_not_joined)}
    end,
    Ret.

%% 找到玩家的参与数据
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
get_unite_role_data([_Platform, _ServerNum, RoleID]) ->
    % case ets:match_object(?ETS_ROLE_DATA, #kf_3v3_role_data{
    %     platform = Platform, server_num = ServerNum, role_id = RoleID, _ = '_'})
    % of
    %     [#kf_3v3_role_data{} = UniteRoleData] ->
    %         {ok, UniteRoleData};
    %     _ ->
    %         {false, ?ERRCODE(err650_kf_3v3_not_joined)}
    % end;
    get_unite_role_data(RoleID);
get_unite_role_data(RoleID) ->
    case ets:lookup(?ETS_ROLE_DATA, RoleID) of
        [#kf_3v3_role_data{} = UniteRoleData] ->
            {ok, UniteRoleData};
        _ ->
            {false, ?ERRCODE(err650_kf_3v3_not_joined)}
    end.

%% 找到玩家的队伍数据
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
get_unite_team_data(TeamID) when is_integer(TeamID) andalso TeamID > 0 ->
    case ets:lookup(?ETS_TEAM_DATA, TeamID) of
        [#kf_3v3_team_data{} = TeamData] ->
            {ok, TeamData};
        _ ->
            {false, ?ERRCODE(err650_kf_3v3_not_joined)}
    end;
get_unite_team_data(_) ->
%%    ?MYLOG("3v32", "err650_kf_3v3_not_joined ~n", []),
    {false, ?ERRCODE(err650_kf_3v3_not_joined)}.

%% 找到队长的队伍数据
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
get_captain_team_data([_Platform, _ServerNum, CaptainID]) ->
    case ets:match_object(?ETS_TEAM_DATA, #kf_3v3_team_data{captain_id = CaptainID, _ = '_'}) of
        [#kf_3v3_team_data{} = TeamData] ->
            {ok, TeamData};
        _ ->
            {false, ?ERRCODE(err650_kf_3v3_not_captain)}
    end;
get_captain_team_data([TeamID, FindCaptainID]) ->
    case ets:lookup(?ETS_TEAM_DATA, TeamID) of
        [#kf_3v3_team_data{captain_id = CaptainID} = TeamData] when CaptainID == FindCaptainID ->
            {ok, TeamData};
        _ ->
            {false, ?ERRCODE(err650_kf_3v3_not_captain)}
    end.

%% 找到进行中战斗数据
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
get_unite_pk_data([PKPid]) ->
    case ets:lookup(?ETS_PK_DATA, PKPid) of
        [#kf_3v3_pk_data{} = PKData] ->
            {ok, PKData};
        _ ->
            {false, ?ERRCODE(err650_kf_3v3_war_end)}
    end;
get_unite_pk_data([SceneID, RoomID]) ->
    case ets:match_object(?ETS_PK_DATA, #kf_3v3_pk_data{
        scene_id = SceneID, room_id = RoomID, _ = '_'})
    of
        [#kf_3v3_pk_data{} = PKData] ->
            {ok, PKData};
        _ ->
            {false, ?ERRCODE(err650_kf_3v3_war_end)}
    end.

%% 找到队友
%% @return : {false, ResID} | {ok, UniteRoleData}
find_member([], _) ->
    {false, ?ERRCODE(err650_kf_3v3_no_member)};
find_member([#kf_3v3_role_data{role_id = RoleID1} = UniteRoleData | Rest], [RoleID2] = Info) ->
    case RoleID2 == RoleID1 of
        true ->
            {ok, UniteRoleData};
        false ->
            find_member(Rest, Info)
    end.

%% 加入队伍
join_team(UniteRoleData, TeamData) ->
    #kf_3v3_team_data{team_id = TeamID, member_data = MemberData} = TeamData,
    NUniteRoleData = UniteRoleData#kf_3v3_role_data{team_id = TeamID},
    NMemberData = MemberData ++ [NUniteRoleData],
    MemberNum = length(NMemberData),
    MapPower = calc_map_power(MemberNum, NMemberData),
    NTeamData = TeamData#kf_3v3_team_data{
        map_power = MapPower, member_num = MemberNum, member_data = NMemberData},
    {ok, NUniteRoleData, NTeamData}.

%% ========================= 匹配规则 ===============================
%%
%% 1）第一个5s，只匹配映射战力差10%的队伍, 且要满足段位差距
%% 2）第二个5s，只匹配映射战力差30%的队伍， 且要满足段位差距
%% 3）第三个5s，匹配映射战力差50%以内的玩家， 且要满足段位差距
%% 4）第16~30s，无视战力差。
%% 5）超过30s，继续匹配，暂时屏蔽匹配失败
%% 5）匹配不到，提示玩家：暂无队伍进行3V3玩法，请重新尝试
%%
%% ========================= 匹配规则 ===============================

%% 匹配队伍
matching_team(Candinates) ->
    NCandinates = sort_candinates(Candinates),
    filter_team_list(NCandinates, [], [], []).

%% 匹配队伍，并分出新的候选队列，匹配成功队列与匹配失败队列
filter_team_list([], Candinates, SucceedList, FailList) ->
    {Candinates, SucceedList, FailList};
filter_team_list([TeamData | Rest], Candinates, SucceedList, FailList) ->
    {NCandinates, NSucceedList, NFailList, List} =
        pick_pk_team(TeamData, Rest, Candinates, SucceedList, FailList, []),
    filter_team_list(Rest -- List, NCandinates, NSucceedList, NFailList).

%% 匹配队伍 - 一个一个比较
pick_pk_team(TeamA, [], Candinates, SucceedList, FailList, List) ->
    #kf_3v3_team_data{match_count = MatchCount} = TeamA,
    if
        MatchCount < 23 ->
            NTeamA = TeamA#kf_3v3_team_data{match_count = MatchCount + 1},
            {[NTeamA | Candinates], SucceedList, FailList, List};
        true ->
            {Candinates, SucceedList, [TeamA | FailList], List}
    end;
pick_pk_team(TeamA, [TeamB | Rest], Candinates, SucceedList, FailList, List) ->
    #kf_3v3_team_data{match_count = _MatchCountA, map_power = MapPowerA, point = PointA} = TeamA,
    #kf_3v3_team_data{map_power = MapPowerB, point = PointB} = TeamB,
%%	?MYLOG("3v32", "MapPowerA ~p MapPowerB ~p~n", [MapPowerA, MapPowerB]),
    Rate = erlang:abs((MapPowerA - MapPowerB) / MapPowerA),
    TierDiff = get_diff_big_tier(PointA, PointB),  %% 大段位差距
%%    ?MYLOG("matching", "TierDiff ~p~n", [TierDiff]),
    MatchCountA = util:floor(_MatchCountA / 4), %% 第几次循环
    if
        (MatchCountA == 0 andalso Rate =< 0.1 andalso TierDiff =< MatchCountA) orelse
        (MatchCountA == 1 andalso Rate =< 0.3  andalso TierDiff =< MatchCountA) orelse
        (MatchCountA == 2 andalso Rate =< 0.5  andalso TierDiff =< MatchCountA) orelse
        (MatchCountA == 3 andalso TierDiff =< MatchCountA) orelse
%%        (MatchCountA == 4 andalso Rate =< 0.3) orelse
%%        (MatchCountA == 5 andalso Rate =< 0.4) orelse
%%        (MatchCountA == 6 andalso Rate =< 0.5) orelse
%%        (MatchCountA == 7 andalso Rate =< 0.6) orelse
        % (MatchCountA >= 4 andalso MatchCountA =< 6)  ->  %% 暂时屏蔽匹配失败
        _MatchCountA >= 23 ->  %%超过23次必定成功
            NTeamA = TeamA#kf_3v3_team_data{match_count = 0},
            NTeamB = TeamB#kf_3v3_team_data{match_count = 0},
            {Candinates, [{NTeamA, NTeamB} | SucceedList], FailList, [TeamB | List]};
        true ->
            pick_pk_team(TeamA, Rest, Candinates, SucceedList, FailList, List)
    end.

%% 匹配次数升序 - 匹配次数越少越优先匹配
sort_candinates(Candinates) ->
    F = fun(
            #kf_3v3_team_data{match_count = MatchCountA},
            #kf_3v3_team_data{match_count = MatchCountB}
        ) ->
            MatchCountA < MatchCountB
    end,
    lists:sort(F, Candinates).

%% ====================== 匹配组队==============================
%% 1 优先选择队伍人数=2，匹配分跟玩家相差30%的队伍，其次选择队伍人数=1，匹配分跟玩家相差50%的队伍
%% 2 优先选择队伍人数=2，匹配分跟玩家相差50%的队伍，其次选择队伍人数=1，匹配分跟玩家相差50%的队伍
%% 3 优先选择队伍人数=2，匹配分跟玩家最接近的队伍，其次选择队伍人数=1，匹配分跟玩家最接近的队伍
%% 4 没有已有队伍，帮玩家创建一个房间：没有战力要求，没进入密码，人满自己开始
%% =============================================================
matching_role([], AutoID, _MemberLimit) ->
%%    ?MYLOG("3v3", "EdTime++++++++++ ~n", []),
    {[], AutoID};
matching_role(MacthRole, AutoID, MemberLimit) ->
%%    ?MYLOG("3v3", "EdTime++++++++++ ~n", []),
    TeamList = ets:tab2list(?ETS_TEAM_DATA),
    {Team2List, Team1List} = filter_team(TeamList, MemberLimit, [], []), %%不存在密码了， 满人了就去匹配队伍， 现在是过滤1个人和2个人的队伍
    {NAutoID, UpdateList, FailList} =
        sub_matching_role(MacthRole, Team2List ++ Team1List, AutoID, MemberLimit, [], []),
    refresh_team_member(UpdateList), %% 刷新队友节点
    {FailList, NAutoID}.

%% 玩家一个一个匹配
sub_matching_role([], _, AutoID, _MemberLimit, UpdateList, FailList) ->
    {AutoID, UpdateList, FailList};
sub_matching_role([#role_data{match_count = MatchCount} = RoleData | Rest],
    TeamList, AutoID, MemberLimit, UpdateList, FailList) ->
%%    ?MYLOG("3v3_others", "RoleData  ~p  ~n MatchCount ~p~n", [RoleData, MatchCount]),
    UniteRoleData = to_kf_3v3_role_data(RoleData),
    if
        TeamList == [] -> %% 没有队伍直接创建队伍
            {ok, NUniteRoleData, #kf_3v3_team_data{member_data = MemberData} = TeamData} =
                create_team([RoleData, AutoID, UniteRoleData]),
            ets:insert(?ETS_ROLE_DATA, NUniteRoleData),
            ets:insert(?ETS_TEAM_DATA, TeamData),
            NUpdateList = refresh_updatelist([NUniteRoleData, MemberData, TeamData], UpdateList),  %%更新玩家的数据
            #kf_3v3_team_data{
                member_num = _MemberNum, member_data = MemberData,
                server_id = ServerId, captain_id = CaptainId, captain_sid = CaptainSid} = TeamData,
            NFailList = FailList,
            if
                MemberLimit =< 1 ->
                    mod_3v3_center:start_matching_team([ServerId, CaptainId, CaptainSid]);
                true ->
                    ok
            end,
            NTeamList = TeamList,  %%队伍list
            NAutoID = AutoID + 1;                %%队伍自增加1
        MatchCount >   ?single_max_match_count-> %% 超过一定次数就去匹配了
            {ok, NUniteRoleData, #kf_3v3_team_data{member_data = MemberData} = TeamData} =
                create_team([RoleData, AutoID, UniteRoleData]),
            ets:insert(?ETS_ROLE_DATA, NUniteRoleData),
            ets:insert(?ETS_TEAM_DATA, TeamData),
            NUpdateList = refresh_updatelist([NUniteRoleData, MemberData, TeamData], UpdateList),  %%更新玩家的数据
            #kf_3v3_team_data{
                member_num = _MemberNum, member_data = MemberData,
                server_id = ServerId, captain_id = CaptainId, captain_sid = CaptainSid} = TeamData,
            NFailList = FailList,
            mod_3v3_center:start_matching_team([ServerId, CaptainId, CaptainSid]),
            NTeamList = TeamList,  %%队伍list
            NAutoID = AutoID + 1;                %%队伍自增加1
        true ->
            case pick_team(TeamList, UniteRoleData, []) of
                {ok, #kf_3v3_team_data{} = TeamData} -> Res = {ok, TeamData};
                _ ->                                    Res = false
            end,
            case Res of
                {ok, #kf_3v3_team_data{team_id = TeamID} = _TeamData} -> %% 找到队伍，则组队
                    case join_team(UniteRoleData, _TeamData) of
                        {ok, NUniteRoleData, #kf_3v3_team_data{
                            member_num = MemberNum, member_data = MemberData,
                            server_id = ServerId, captain_id = CaptainId, captain_sid = CaptainSid} = NTeamData
                        } when MemberNum >= MemberLimit -> %% 队伍人满
                            %%%% 队伍人满 去队伍之间匹配啦
                            mod_3v3_center:start_matching_team([ServerId, CaptainId, CaptainSid]),
                            NTeamList = lists:keydelete(TeamID, #kf_3v3_team_data.team_id, TeamList);
                        {ok, NUniteRoleData, #kf_3v3_team_data{member_data = MemberData} = NTeamData
                        } -> %% 队伍不满则放入匹配队列中继续匹配
                            NTeamList = [NTeamData |
                                lists:keydelete(TeamID, #kf_3v3_team_data.team_id, TeamList)]
                    end,
                    ets:insert(?ETS_ROLE_DATA, NUniteRoleData),
                    ets:insert(?ETS_TEAM_DATA, NTeamData),
                    %% 匹配成功之后需要将 更新列表 刷新一遍
                    NUpdateList = refresh_updatelist([NUniteRoleData, MemberData, NTeamData], UpdateList),
                    NFailList = FailList;
                _ -> %% 找不到队伍，则匹配次数加 1
                    NTeamList = TeamList,
                    NUpdateList = UpdateList,
                    NFailList = [RoleData#role_data{match_count = MatchCount + 1} | FailList]
            end,
            NAutoID = AutoID
    end,
    sub_matching_role(Rest, NTeamList, NAutoID, MemberLimit, NUpdateList, NFailList).

%% 刷新 更新列表 - 有些玩家数据刷新不到
refresh_updatelist([UniteRoleData, MemberData,
    #kf_3v3_team_data{team_id = TeamID} = TeamData], UpdateList) ->
    case lists:keyfind(TeamID, 1, UpdateList) of
        {TeamID, _, OldList} ->
            List1 = merge_keyval(OldList, {update, ?ETS_ROLE_DATA, UniteRoleData}, []),
            KeyValueList = merge_keyval(List1, {update, ?ETS_TEAM_DATA, TeamData}, []),
            Info = {TeamID, MemberData, KeyValueList},
            lists:keyreplace(TeamID, 1, UpdateList, Info);
        _ ->
            KeyValueList = [
                {update, ?ETS_ROLE_DATA, UniteRoleData},
                {update, ?ETS_TEAM_DATA, TeamData}],
            Info = {TeamID, MemberData, KeyValueList},
            [Info | UpdateList]
    end.

merge_keyval([], Info, KeyValueList) ->
    [Info | KeyValueList];
merge_keyval([{_, _, Val1} = Info1 | Rest], {_, _, Val2} = Info2, KeyValueList) ->
    case {Val1, Val2} of
        {#kf_3v3_role_data{role_id = U1}, #kf_3v3_role_data{role_id = U2}} when U1 == U2 -> %% 已存在直接结束合并
            Rest ++ [Info2 | KeyValueList];
        {#kf_3v3_team_data{}, #kf_3v3_team_data{}} ->
            Rest ++ [Info2 | KeyValueList];
        _ ->
            merge_keyval(Rest, Info2, [Info1 | KeyValueList])
    end.

%% 找出映射战力最接近的队伍
%% @ClosestTeam : 映射战力最接近的队伍
%% @return : false | {ok, TeamData}
%% ====================== 匹配组队==============================
%% 1 优先选择队伍人数=2，匹配分跟玩家相差30%的队伍，其次选择队伍人数=1，匹配分跟玩家相差30%的队伍
%% 2 优先选择队伍人数=2，匹配分跟玩家相差50%的队伍，其次选择队伍人数=1，匹配分跟玩家相差50%的队伍
%% 3 优先选择队伍人数=2，匹配分跟玩家最接近的队伍，其次选择队伍人数=1，匹配分跟玩家最接近的队伍
%% 4 没有已有队伍，帮玩家创建一个房间：没有战力要求，没进入密码，人满自己开始
%% =============================================================
pick_team([], _, ClosestTeam) when is_record(ClosestTeam, kf_3v3_team_data) ->
    {ok, ClosestTeam};
pick_team([], _, _) ->
    false;
pick_team([#kf_3v3_team_data{map_power = MapPower1, member_num = MemberNum} = TeamData | Rest],
    #kf_3v3_role_data{
        match_count = MatchCount, figure = #figure{lv = RoleLv}, power = Power
    } = UniteRoleData, ClosestTeam) ->
    KeyValueList = [
        {power_limit, Power, TeamData},
        {lv_limit, RoleLv, TeamData}
    ],
    Reason = check_list(KeyValueList),
    MapPower = calc_map_power(1, [UniteRoleData]),
    Rate = erlang:abs(MapPower / MapPower1),
    if
        (Reason andalso MatchCount == 0 andalso MemberNum == 2 andalso Rate =< 0.3) orelse
        (Reason andalso MatchCount == 0 andalso MemberNum == 1 andalso Rate =< 0.5) orelse
        (Reason andalso MatchCount == 1 andalso Rate =< 0.5) ->
            {ok, TeamData};
        Reason andalso (MatchCount == 2 orelse  MatchCount == 3)->
            case ClosestTeam of
                #kf_3v3_team_data{map_power = MapPower2} -> ok;
                _ -> MapPower2 = 0
            end,
            IsCloser = erlang:abs(MapPower1 - MapPower) < erlang:abs(MapPower2 - MapPower),
            if
                IsCloser ->
                    pick_team(Rest, UniteRoleData, TeamData);
                true ->
                    pick_team(Rest, UniteRoleData, ClosestTeam)
            end;
        MatchCount >= 4 ->
            {ok, TeamData};
        true ->
            pick_team(Rest, UniteRoleData, ClosestTeam)
    end.

%% 将队伍人数已满，需要密码的先过滤，匹配超过5次的也过滤， 然后筛选出队伍人数2 及 队伍人数1 的两个队列
%% @Team2List : 队伍人数为 2 的队伍列表
%% @Team1List : 队伍人数为 1 的队伍列表
filter_team([], _MemberLimit, Team2List, Team1List) -> {Team2List, Team1List};
filter_team([#kf_3v3_team_data{password = Pswd, member_num = MemberNum, match_count_in_team = _MatchCount, team_type = TeamType, is_match = IsMatch
    } = TeamData | Rest], MemberLimit, Team2List, Team1List) ->
    if
        TeamType == 0 ->  %%战队不参于散人的匹配
            filter_team(Rest, MemberLimit, Team2List, Team1List);
	    IsMatch == 1 ->
		    filter_team(Rest, MemberLimit, Team2List, Team1List);
        Pswd > 0 orelse MemberNum >= MemberLimit ->
            filter_team(Rest, MemberLimit, Team2List, Team1List);
        true ->
            if
%%                MatchCount >= ?kf_3v3_match_times_limit ->  %%次数过多的就不要匹配了
%%                    filter_team(Rest, MemberLimit, Team2List, Team1List);
                MemberNum == 2 ->
                    filter_team(Rest, MemberLimit, [TeamData | Team2List], Team1List);
                MemberNum == 1 ->
                    filter_team(Rest, MemberLimit, Team2List, [TeamData | Team1List]);
                true ->
                    filter_team(Rest, MemberLimit, Team2List, Team1List)
            end
    end.

%% 创建战斗房间
%% @desc :
%%    1）每个场景暂时只分配33个房间，即限制一个场景人数不能超过200人
%%    2）注意，这个方法只允许mod_3v3_center进程使用
create_pk_room([SceneID, ScenePoolIdList, SucceedList]) ->
    sub_create_room(SceneID, ScenePoolIdList, SucceedList).

sub_create_room(_, _, []) -> ok;
sub_create_room(SceneID, ScenePoolIdList, [{TeamA, TeamB} | Rest]) ->
%%    ?MYLOG("3v3pk", "create_pk_room TeamA ~p ~n TeamB ~p~n", [TeamA, TeamB]),
    #kf_3v3_team_data{team_id = TeamIDA, member_data = MemberDataA} = TeamA,
    #kf_3v3_team_data{team_id = TeamIDB, member_data = MemberDataB} = TeamB,
    ScenePoolId = urand:list_rand(ScenePoolIdList),
    Data = #kf_3v3_pk_data{
        scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = TeamIDA, team_data_a = TeamA, team_data_b = TeamB,
        state = ?KF_3V3_PK_START
    },
    case mod_3v3_pk:start([Data]) of
        {ok, Pid} ->
            if
                TeamIDA > TeamIDB ->
                    GroupA = ?KF_3V3_GROUP_BLUE, GroupB = ?KF_3V3_GROUP_RED;
                true ->
                    GroupA = ?KF_3V3_GROUP_RED, GroupB = ?KF_3V3_GROUP_BLUE
            end,
            NMemberDataA = update_unite_role_data(MemberDataA, [{group, GroupA}, {pk_pid, Pid}]),
            NMemberDataB = update_unite_role_data(MemberDataB, [{group, GroupB}, {pk_pid, Pid}]),
            NTeamA = TeamA#kf_3v3_team_data{member_data = NMemberDataA, is_pk = 1},
            NTeamB = TeamB#kf_3v3_team_data{member_data = NMemberDataB, is_pk = 1},
            NData = Data#kf_3v3_pk_data{team_data_a = NTeamA, team_data_b = NTeamB, pk_pid = Pid},
            ets:insert(?ETS_TEAM_DATA, [NTeamA, NTeamB]),
            ets:insert(?ETS_ROLE_DATA, NMemberDataA ++ NMemberDataB),
            ets:insert(?ETS_PK_DATA, NData),
            refresh_team_member(NMemberDataA, [{update, ?ETS_TEAM_DATA, NTeamA}]),
            refresh_team_member(NMemberDataB, [{update, ?ETS_TEAM_DATA, NTeamB}]);
        _R ->
            ?ERR("lib_3v3_center create_pk_room~p ~n", [_R])
    end,
    sub_create_room(SceneID, ScenePoolIdList, Rest).

%% 发送被踢提醒
send_kick_notice([ServerId, RoleSid]) ->
    mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_kick_notice, [[RoleSid]]).

%% 推送离队提醒
send_leave_notice(MemberData, Data) ->
    F = fun(#kf_3v3_role_data{server_id = ServerId, role_id = RoleId}) ->
        mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_leave_notice, [[RoleId, Data]])
    end,
    lists:foreach(F, MemberData).

%% 推送退出战斗房间提醒
send_leave_pk_room_notice(MemberData, Data) when is_list(MemberData) ->
    F = fun(#kf_3v3_role_data{server_id = ServerId, sid = RoleSid}) ->
        send_leave_pk_room_notice(ServerId, [RoleSid, Data])
    end,
    lists:foreach(F, MemberData);
send_leave_pk_room_notice(ServerId, [RoleSid, Data]) ->
    mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_leave_pk_room_notice, [[RoleSid, Data]]).

%% 推送重登战斗战场提醒
send_enter_pk_room_notice(MemberData, Data) when is_list(MemberData) ->
    F = fun(#kf_3v3_role_data{server_id = ServerId, sid = RoleSid}) ->
        send_enter_pk_room_notice(ServerId, [RoleSid, Data])
    end,
    lists:foreach(F, MemberData);
send_enter_pk_room_notice(ServerId, [RoleSid, Data]) ->
    mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_enter_pk_room_notice, [[RoleSid, Data]]).

%% 推送开始匹配提醒
send_start_matching_notice(MemberData, Data) when is_list(MemberData) ->
    F = fun(#kf_3v3_role_data{server_id = ServerId, sid = RoleSid}) ->
        send_start_matching_notice(ServerId, [RoleSid, Data])
    end,
    lists:foreach(F, MemberData);
send_start_matching_notice(ServerId, [RoleSid, Data]) ->
    mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_start_matching_notice, [[RoleSid, Data]]).

%% 推送取消匹配提醒
send_stop_matching_notice(MemberData, Data) when is_list(MemberData) ->
    F = fun(#kf_3v3_role_data{server_id = ServerId, sid = RoleSid}) ->
        send_stop_matching_notice(ServerId, [RoleSid, Data])
    end,
    lists:foreach(F, MemberData);
send_stop_matching_notice(ServerId, [RoleSid, Data]) ->
    mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_stop_matching_notice, [[RoleSid, Data]]).

%% 发送队伍消息
msg_to_team([], _) ->
    ok;
msg_to_team([#kf_3v3_role_data{server_id = ServerId, role_id = RoleID} | Rest], Bin) ->
    mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_msg_to_team, [[RoleID, Bin]]),
    msg_to_team(Rest, Bin).

%% 检测玩家是否满足该队伍限制
%% 检测玩家战力与队伍情况
%% @return : false | true | {false, Reason}
check_list([]) -> true;
check_list([KeyVal | Rest]) ->
    case check(KeyVal) of
        true ->
            check_list(Rest);
        Reason ->
            Reason
    end.

check({password, Password, #kf_3v3_team_data{password = Pswd}}) ->
    if
        Password =:= Pswd ->
            true;
        true ->
            {false, ?ERRCODE(err650_kf_3v3_wrong_pswd)}
    end;
check({lv_limit, RoleLv, #kf_3v3_team_data{lv_limit = LvLimit}}) ->
    if
        RoleLv >= LvLimit ->
            true;
        true ->
            {false, ?ERRCODE(err650_kf_3v3_low_lv)}
    end;
check({power_limit, Power, #kf_3v3_team_data{power_limit = PowerLimit}}) ->
    if
        Power >= PowerLimit ->
            true;
        true ->
            {false, ?ERRCODE(err650_kf_3v3_low_power)}
    end;
check(_KeyVal) ->
    false.

%% 获取复活信息
revive(?KF_3V3_GROUP_BLUE) ->
	%%蓝组复活信息
	List = data_3v3:get_kv(reborn_coordinate),
	case lists:keyfind(blue, 1, List) of
		{blue, {X , Y}} ->
			ok;
		_ ->
			X = 0, Y = 0
	end,
	[{x, X}, {y, Y}];
revive(?KF_3V3_GROUP_RED) ->
	%%蓝组复活信息
	List = data_3v3:get_kv(reborn_coordinate),
	case lists:keyfind(red, 1, List) of
		{red, {X , Y}} ->
			ok;
		_ ->
			X = 0, Y = 0
	end,
	[{x, X}, {y, Y}];
revive(_) -> [].

%% 这两份是写死的配置
get_tower_info() -> %% 初始
    [{3300007, {915, 2703}}, {3300008, {2309, 1717}}, {3300009, {3477, 781}}].

%% 坐标
get_tower_xy(3300001) -> {915, 2703};
get_tower_xy(3300002) -> {2309, 1717};
get_tower_xy(3300003) -> {3477, 781};
get_tower_xy(3300004) -> {915, 2703};
get_tower_xy(3300005) -> {2309, 1717};
get_tower_xy(3300006) -> {3477, 781};
get_tower_xy(3300007) -> {915, 2703};
get_tower_xy(3300008) -> {2309, 1717};
get_tower_xy(3300009) -> {3477, 781}.

%% 蓝色
get_tower_id(?KF_3V3_GROUP_BLUE, 3300007) -> 3300001;
get_tower_id(?KF_3V3_GROUP_BLUE, 3300008) -> 3300002;
get_tower_id(?KF_3V3_GROUP_BLUE, 3300009) -> 3300003;
get_tower_id(?KF_3V3_GROUP_BLUE, 3300004) -> 3300001;
get_tower_id(?KF_3V3_GROUP_BLUE, 3300005) -> 3300002;
get_tower_id(?KF_3V3_GROUP_BLUE, 3300006) -> 3300003;
%% 红色
get_tower_id(?KF_3V3_GROUP_RED, 3300007) -> 3300004;
get_tower_id(?KF_3V3_GROUP_RED, 3300008) -> 3300005;
get_tower_id(?KF_3V3_GROUP_RED, 3300009) -> 3300006;
get_tower_id(?KF_3V3_GROUP_RED, 3300001) -> 3300004;
get_tower_id(?KF_3V3_GROUP_RED, 3300002) -> 3300005;
get_tower_id(?KF_3V3_GROUP_RED, 3300003) -> 3300006.

%% 守卫列表
%% [{蓝方怪物id, X, Y, Args}, {红方怪物id, X, Y, Args}]
get_guardian_info() ->
    [
        {3300010, 863, 595, [{group, ?KF_3V3_GROUP_BLUE}]},
        {3300011, 3747, 2620, [{group, ?KF_3V3_GROUP_RED}]}
    ].

test() -> ok.

%% 刷新队伍信息
refresh_team_member(MemberData, KeyValueList) when is_list(MemberData) ->
    F = fun(#kf_3v3_role_data{server_id = ServerId}) ->
        mod_clusters_center:apply_cast(ServerId, mod_3v3_local, update_ets_data, [KeyValueList])
    end,
    lists:foreach(F, MemberData);
refresh_team_member(_, _) -> ok.

refresh_team_member([]) -> ok;
refresh_team_member([{_, MemberData, KeyValueList} | Rest]) ->
    refresh_team_member(MemberData, KeyValueList),
    refresh_team_member(Rest).

%% 玩家数据更新
update_unite_role_data(#kf_3v3_role_data{} = UniteRoleData, KeyValueList) ->
    F = fun({Key, Val}, RoleData) ->
        case Key of
            sid -> RoleData#kf_3v3_role_data{sid = Val};
            pk_pid -> RoleData#kf_3v3_role_data{pk_pid = Val};
            group -> RoleData#kf_3v3_role_data{group = Val};
            team_id ->
                RoleData#kf_3v3_role_data{team_id = Val};
            % nickname -> RoleData#kf_3v3_role_data{nickname = Val};
            % sex -> RoleData#kf_3v3_role_data{sex = Val};
            % lv -> RoleData#kf_3v3_role_data{lv = Val};
            % vip -> RoleData#kf_3v3_role_data{vip = Val};
            % power -> RoleData#kf_3v3_role_data{power = Val};
            % fashion_id -> RoleData#kf_3v3_role_data{fashion_id = Val};
            % train_weapon -> RoleData#kf_3v3_role_data{train_weapon = Val};
            % train_fly -> RoleData#kf_3v3_role_data{train_fly = Val};
            tier -> RoleData#kf_3v3_role_data{tier = Val};
            star -> RoleData#kf_3v3_role_data{star = Val};
            continued_win -> RoleData#kf_3v3_role_data{continued_win = Val};
            _ -> RoleData
        end
    end,
    lists:foldl(F, UniteRoleData, KeyValueList);
update_unite_role_data(MemberData, KeyValueList) ->
    [update_unite_role_data(UniteRoleData, KeyValueList) || UniteRoleData <- MemberData].

%% 队伍数据更新
%% @desc : 只允许在mod_3v3_center进程中使用
update_unite_team_data([]) -> ok;
update_unite_team_data([{TeamID, UpdateList} | Rest]) ->
    case ets:lookup(?ETS_TEAM_DATA, TeamID) of
        [#kf_3v3_team_data{member_data = MemberData} = TeamData] ->
            F = fun({RoleID, List}, MemberList) ->
                case lists:keyfind(RoleID, #kf_3v3_role_data.role_id, MemberData) of
                    #kf_3v3_role_data{} = UniteRoleData ->
                        NUniteRoleData = update_unite_role_data(UniteRoleData, List),
                        ets:insert(?ETS_ROLE_DATA, NUniteRoleData),
                        [NUniteRoleData | MemberList];
                    _ ->
                        MemberList
                end
            end,
            NMemberData = lists:foldl(F, [], UpdateList),
            NTeamData = TeamData#kf_3v3_team_data{member_data = NMemberData},
            ets:insert(?ETS_TEAM_DATA, NTeamData);
        _ -> skip
    end,
    update_unite_team_data(Rest).

%% -----------------------------------------------------------------
%% @desc     功能描述  直接去匹配的队伍
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
go_to_match_team(NeedMatchTeam) ->
%%    ?MYLOG("3v3", "NeedMatchTeam ~p~n", [NeedMatchTeam]),
    [mod_3v3_center:start_matching_team([ServerId, CaptainId, CaptainSid]) ||
        #kf_3v3_team_data{server_id = ServerId, captain_sid = CaptainSid, captain_id = CaptainId} <- NeedMatchTeam].

%% -----------------------------------------------------------------
%% @desc     功能描述 匹配次数过多则直接创建队伍去匹配
%% @param    参数
%% @return   返回值   {FailList, NAutoID, TeamList, UpdateList}
%% @history  修改历史
%% -----------------------------------------------------------------
create_team_when_role_match_over(RoleList, NAutoID, UpdateList) ->
    create_team_when_role_match_over(RoleList, NAutoID, [], [], UpdateList).


create_team_when_role_match_over([], AutoID, LastRoleList, TeamList, UpdateList) ->
    {LastRoleList, AutoID, TeamList, UpdateList};
create_team_when_role_match_over([H | RoleList], AutoID, LastRoleList, TeamList, UpdateList) ->
    #role_data{match_count = MatchCount} = H,
    if
        MatchCount >= ?kf_3v3_match_times_limit->
            UniteRoleData = to_kf_3v3_role_data(H),
            {ok, NUniteRoleData, #kf_3v3_team_data{member_data = MemberData} = TeamData} =
                create_team([H, AutoID, UniteRoleData]),
            ets:insert(?ETS_ROLE_DATA, NUniteRoleData),
            ets:insert(?ETS_TEAM_DATA, TeamData),
            NUpdateList = refresh_updatelist([NUniteRoleData, MemberData, TeamData], UpdateList),  %%更新玩家的数据
            NTeamList = TeamList ++ [TeamData],  %%队伍list
            NAutoID = AutoID + 1,                %%队伍自增加1
            create_team_when_role_match_over(RoleList, NAutoID, LastRoleList, NTeamList, NUpdateList);
        true ->
            create_team_when_role_match_over(RoleList, AutoID, [H | LastRoleList], TeamList, UpdateList)
    end.

disband_team([]) ->
    ok;
disband_team([RoleDate | RoleDateList]) ->
    #role_score{server_num = ServerNum, server_id = ServerId, role_id = RoleId, sid = RoleSid} = RoleDate,
    mod_3v3_center:leave_team(["", ServerNum, ServerId, RoleId, RoleSid]),
    disband_team(RoleDateList).


enter_or_quit_tower(RoleId, Type, TowerId) ->
    case ets:lookup(?ETS_ROLE_DATA, RoleId) of
        [#kf_3v3_role_data{pk_pid = Pid}] ->
            case misc:is_process_alive(Pid) of
                true ->
                    Pid ! {enter_or_quit_tower, RoleId, Type, TowerId};
                _ ->
                    skip
            end;
        _ -> skip
    end.

get_role_list_msg(RoleId, Node) ->
    case ets:lookup(?ETS_ROLE_DATA, RoleId) of
        [#kf_3v3_role_data{pk_pid = Pid}] ->
            case misc:is_process_alive(Pid) of
                true ->
                    Pid ! {get_role_list_msg, RoleId, Node};
                _ ->
                    skip
            end;
        _ -> skip
    end.


%%队伍是不是已经在匹配
check_team_matching(TeamId, List) ->
    case lists:keyfind(TeamId, #kf_3v3_team_data.team_id, List) of
        #kf_3v3_team_data{} ->
            {false, ?ERRCODE(err650_team_in_match)};
        _ ->
            true
    end.
%%    case ets:lookup(?ETS_TEAM_DATA, TeamId) of
%%        [#kf_3v3_team_data{}] ->
%%            {false, ?ERRCODE(err650_team_in_match)};
%%        _ -> %% 找不到队伍
%%            true
%%    end.


%%更新队伍的匹配状态
refresh_team_match_status(_ServerId, TeamId, RoleIdList, Status) ->
    mod_3v3_team:refresh_team_match_status(TeamId, RoleIdList, Status).
%%    mod_clusters_center:apply_cast(ServerId, mod_3v3_team, refresh_team_match_status, [TeamId, RoleIdList, Status]).


pull_team_to_match(RoleData, OtherRoleData, TeamId, _TeamName, AllPower) ->
%%    #role_data{
%%        node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
%%        role_id = RoleID, sid = RoleSid,
%%        figure = Figure = #figure{name = Nickname}, power = Power,
%%        power_limit = PowerLimit, lv_limit = LvLimit, password = Password,
%%        is_auto = IsAuto, tier = Tier, star = Star, continued_win = ContinuedWin, old_scene_info = OldSceneInfo
%%    } = RoleData,
    NUniteRoleData = #kf_3v3_role_data{
        team_id = TeamId, node = _Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        role_id = RoleID, sid = RoleSid,
        figure = Figure, power = _Power,
        is_ready = ?KF_3V3_IS_READY,
        continued_win = _ContinuedWin, old_scene_info = _OldSceneInfo
    } = RoleData,
    MemberNum = 1 + length(OtherRoleData),
    TeamData = #kf_3v3_team_data{
        team_id = TeamId, captain_name = Figure#figure.name, captain_id = RoleID, captain_sid = RoleSid,
        server_name = ServerName, server_num = ServerNum, server_id = ServerId,
        member_num = MemberNum, map_power = AllPower,
        member_data = [NUniteRoleData] ++ OtherRoleData
    },
    {ok, NUniteRoleData, TeamData}.


get_diff_big_tier(PointA, PointB) ->
    {TierA, _} = lib_3v3_local:calc_tier_by_star(0, PointA),
    {TierB, _} = lib_3v3_local:calc_tier_by_star(0, PointB),
    BigTierA =
        case data_3v3:get_tier_info(TierA) of
            #tier_info{stage = StageA} ->
                StageA;
            _ ->
                0
        end,
    BigTierB =
        case data_3v3:get_tier_info(TierB) of
            #tier_info{stage = StageB} ->
                StageB;
            _ ->
                0
        end,
    abs(BigTierA - BigTierB).




