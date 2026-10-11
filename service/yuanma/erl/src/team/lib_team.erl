%% ---------------------------------------------------------------------------
%% @doc lib_team
%% @author ming_up@foxmail.com
%% @since  2016-11-01
%% @deprecated 组队库函数
%% ---------------------------------------------------------------------------
-module(lib_team).

%% 公共函数：外部模块调用.
-export([
         create_cast/5                     %% 创建队伍
        , send_to_member/2                 %% 广播给队员
        , send_to_member/5                 %% 广播给队员
        , join_player_team/2               %% 响应加入指定玩家队伍
        , send_scene_users_without_team/4  %% 场景进程调用 发送附近的人
        , get_onhook_target_type/1
        , get_max_team_member_num/2
        , calc_location/2
        , is_cls_target/2
        , get_team_cls_type/1
        , get_target_name/2
        , target_cost_something/1   %% 该目标是否消耗东西
        , my_code_to_other_code/2   %% 将错误信息转化成给队友看的
        , silent_cancel_team_match/1
        , ask_for_join_team/4       %% 请求加入队伍
        , check_for_sth/5       %% 请求加入队伍
        , invite_player/4
        , send_from_local/3
        ]).

%% 内部函数：组队服务本身调用.
-export([
         send_team_info/1              %% 向队伍所有成员发送队伍信息
        , send_team/2                  %% 向所有队员发送信息
        , send_team/3                  %% 向除了指定的队员之外的人发送信息
        , send_team/5                  %% 向符合条件队员发送信息
        , send_error/4                 %% 发送错误信息
        , pack_member/4                %% 组装队员列表
        , send_to_uid/3                %% 发送信息给玩家
        , team_add_exp/3               %% 组队分成经验
        , update_ets_team/1            %% 更新组队进程pid缓存表
        , delete_ets_team/1            %% 移除组队进程pid缓存表
        , get_info_and_join_team/3     %% 获取信息并且回复队伍进程
        , update_mb_info/3             %% 调用member的lib_player:update_player_info/2函数
         %% , handle_barbecue_buff/2
         %% , handle_barbecue_buff/3   %% 处理篝火buff
        , handle_match_complete/1      %% 处理自动匹配完成
        , cancel_follow/2              %% 取消跟随
        , cancel_follows/2             %% 跟随目标取消跟随者的跟随
        , get_mb_scene/3               %% 获取队员信息
        , notify_team_change/6         %% 队伍成员变更提示
        , common_check/3               %% 通用检查
        , check_for_create_team/3      %% 创建检查
        , transfer_create_team_errcode/1   %% 转换错误码
        , send_ac_left_time/2          %% 发送活动剩余次数
        , lock_login/3                 %%
        , members_apply_cast/6         %% 队员远程调用
        , take_over_team/2              %% 接管队伍
        , handle_message/2              %% 处理在队伍挂起的时候积累的消息
        , make_fake_mb/2                %% 伪造一个假的队员
        , is_fake_mb/1                  %% 是否一个假的队员
        , is_zone_mod/2                 %% 是否需要248分组类型
        , get_module/2                  %% 获取模块ID
        , get_position/2                %% 获得位置
        , get_team_info_bin/1           %% 序列化队伍信息
        , respond_team_disappear/1      %% 队伍已经不存在的处理
    ]).

%% 玩家进程调用
-export ([
        login/1
        , join_team_success/2        %% 清理申请的列表
        , set_req_team_id/2         %% 设置玩家身上的申请列表
        , auto_match_team/2         %% 自动匹配队伍
        , change_teammate_in_team/5   %% 经验加成改变
        , change_team_enlist/4      %% 组队目标改变
        , create_team_done/4        %% 创建队伍完成
        , create_team_respond/2     %% 创建队伍返回
        , create_team_respond/4     %% 创建队伍返回
        , start_arbitrate/2         %% 开始投票
        , check_start_team_target/3 %% 检查投票的条件
        , auto_arbitrate/4          %% 匹配完成后自动投票
        , auto_cancel_role_match/1
        , cancel_role_match/1       %% 取消没有组队的玩家的匹配
        , start_arbitrate_silent/2  %% 静默匹配
        , check_for_other_match/4   %% 为特定匹配检查自己
        , update_help_type/4        %% 为特定匹配检查自己
        , update_team_flag/2        %% 更新队伍信息
        , handle_noteam_for_match/3        %% 无队伍匹配
        , create_team/6             %% 创建队伍
        , create_team/7             %% 创建队伍
        , lock_for_start/2          %% 锁住玩家状态
        , receive_invatation/4      %% 收到邀请
        , lose_team/1
        , check_team/1
        , check_team_success/1
        , team_is_took_over/3
        , send_recruit_list/3
        , send_recruit_list/2
        , arbitrate_req/3
        , set_help_type/3
    ]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("team.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("activitycalen.hrl").
-include("dungeon.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("language.hrl").
-include("goods.hrl").
-include("buff.hrl").
-include("relationship.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("role.hrl").
-include("jjc.hrl").
-include("reincarnation.hrl").
-include("mount.hrl").
-include("rec_assist.hrl").
-include("faker.hrl").
-include("clusters.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% --------------------------------- 公共函数 ----------------------------------
%% 模块外请调用lib_team_api:create_cast/6
create_cast(ActivityId, SubTypeId, SceneId, Mbs, Args) ->
    TeamId = mod_team_create:get_new_id(),
    {ok, _} = mod_team:start([TeamId, 0, ActivityId, SubTypeId, SceneId, "", 0, 0, Mbs, Args]),
    TeamId.

%% 广播给队员
send_to_member(TeamId, Bin) ->
    case TeamId > 0 andalso is_binary(Bin) of
        false -> false;
        true -> mod_team:cast_to_team(TeamId, {'send_to_team', Bin})
    end.

send_to_member(TeamId, SceneId, ScenePoolId, CopyId, Bin) ->
    case TeamId > 0 andalso is_binary(Bin) of
        false -> false;
        true -> mod_team:cast_to_team(TeamId, {'send_to_team', SceneId, ScenePoolId, CopyId, Bin})
    end.

%% 队长回应申请后，玩家进入队伍
get_info_and_join_team(PS, _Uid, TeamId) ->
    #player_status{team = #status_team{team_id = SelfTeamId} } = PS,
    IsOnDungeon = lib_dungeon:is_on_dungeon(PS),
    if
        IsOnDungeon -> skip;
        SelfTeamId == 0  ->
            Mb = lib_team_api:thing_to_mb(PS),
            mod_team:cast_to_team(TeamId, {'join_team_af_response_agree', Mb});
        true ->
            skip
    end.

%% 对方玩家进程响应12003,这里只处理本服玩家
join_player_team(PS, Mb) ->
    #status_team{team_id=TeamId} = PS#player_status.team,
    case TeamId of
        0 ->
            {ok, BinData} = pt_240:write(24016, [?ERRCODE(err240_no_team)]),
            send_to_uid(Mb#mb.node, Mb#mb.id, BinData);
        _ ->
%%            mod_team:cast_to_team(TeamId, {'join_team_request', Mb})
            mod_team:cast_to_team(TeamId, {'get_target_for_join', Mb})
    end.

%% -----------------------------------------------------------------
%%  内部函数
%% -----------------------------------------------------------------

%% 向队伍所有成员发送队伍信息
send_team_info(Team) ->
    send_team(Team, get_team_info_bin(Team)).

get_team_info_bin(Team) ->
    #team{
        id = TeamId,
        member = Members,
        enlist=EnList,
        leader_id=LeaderId,
        pre_num_full=PreNullFull,
        is_matching = IsMatching,
        match_st = MatchSt,
        auto_type = AutoType,
        join_type = JoinType,
        lv_limit_min = LvMin,
        lv_limit_max = LvMax,
        join_con_value = JoinConValue
    } = Team,
    ActivityId = EnList#team_enlist.activity_id,
    SubTypeId = EnList#team_enlist.subtype_id,
    Data = [TeamId, ActivityId, SubTypeId, EnList#team_enlist.scene_id, PreNullFull,
        IsMatching, MatchSt, LvMin, LvMax, JoinConValue, AutoType, JoinType, pack_member(ActivityId, SubTypeId, LeaderId, Members)],
    ?PRINT("get_team_info_bin JoinType:~p ~n", [JoinType]),
    {ok, BinData} = pt_240:write(24010, Data),
    BinData.

%% 向所有队员发送信息
send_team(Team, Bin) ->
    F = fun(MemberNode, MemberId) ->
                mod_team:cast_to_game(Team#team.cls_type, MemberNode, lib_server_send, send_to_uid, [MemberId, Bin])
        end,
    [F(M#mb.node, M#mb.id)||M <- Team#team.member, not is_fake_mb(M)].

%% 向所有队员发送信息
send_team(Team, Bin, SkipId) ->
    F = fun(MemberNode, MemberId) ->
                mod_team:cast_to_game(Team#team.cls_type, MemberNode, lib_server_send, send_to_uid, [MemberId, Bin])
        end,
    [F(Node, Id)||#mb{node = Node, id = Id} = M <- Team#team.member, Id =/= SkipId andalso not is_fake_mb(M)].

send_team(Team, SceneId, ScenePoolId, CopyId, Bin) ->
    F = fun(MemberNode, MemberId) ->
                mod_team:cast_to_game(Team#team.cls_type, MemberNode, lib_server_send, send_to_uid, [MemberId, Bin])
        end,
    [F(M#mb.node, M#mb.id)||M <- Team#team.member,
                            M#mb.scene == SceneId andalso M#mb.scene_pool_id == ScenePoolId andalso M#mb.copy_id ==CopyId andalso not is_fake_mb(M)].

send_error(Team, MyId, MyCode, OthersCode) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(OthersCode),
    {ok, OtherBinData} = pt_240:write(24038, [ErrorCodeInt, ErrorCodeArgs]),
    {MyCodeInt, MyCodeArgs} = util:parse_error_code(MyCode),
    {ok, MyBinData} = pt_240:write(24038, [MyCodeInt, MyCodeArgs]),
    F = fun(MemberNode, MemberId) ->
        Bin = if MemberId == MyId -> MyBinData; true -> OtherBinData end,
        mod_team:cast_to_game(Team#team.cls_type, MemberNode, lib_server_send, send_to_uid, [MemberId, Bin])
        end,
    [F(M#mb.node, M#mb.id)||M <- Team#team.member, not is_fake_mb(M)].

%% 组装队员列表
pack_member(ActivityId, SubTypeId, LeaderId, MemberList) when is_list(MemberList) ->
    F = fun(Mb) ->
        Position = get_position(Mb, LeaderId),
        {_, JoinValue} = ulists:keyfind({ActivityId, SubTypeId}, 1, Mb#mb.join_value_list, {{ActivityId, SubTypeId}, 0}),
        {Mb#mb.id, Position, Mb#mb.figure, Mb#mb.help_type, Mb#mb.scene, Mb#mb.join_time, Mb#mb.power, Mb#mb.online, Mb#mb.server_id, Mb#mb.server_num, JoinValue}
    end,
    lists:map(F, MemberList).

%% 更新缓存
update_ets_team(Team) ->
    #team{id=TeamId, pid=Pid} = Team,
    ets:insert(?ETS_TEAM, #ets_team{team_id=TeamId, pid=Pid}).

delete_ets_team(TeamId) ->
    ets:delete(?ETS_TEAM, TeamId).

%% 发送信息给玩家
send_to_uid(undefined, Id, Bin) -> lib_server_send:send_to_uid(Id, Bin);
send_to_uid(Node, Id, Bin) ->
    case node() of
        Node ->
            lib_server_send:send_to_uid(Id, Bin);
        _ ->
            lib_clusters_center:send_to_uid(Node, Id, Bin)
    end.

update_mb_info(ClsType, Mb, Args) ->
    mod_team:cast_to_game(ClsType, Mb#mb.node, lib_player, update_player_info, [Mb#mb.id, Args]).

%% 组队分成经验
team_add_exp({PlayerStatus, ExpX}, MemExp, _Llpt) ->
    gen_server:cast(PlayerStatus#player_status.pid, {'EXP', MemExp * ExpX}).

%% 处理完成匹配
handle_match_complete(State) ->
    #team{
        leader_id = LeaderId,
        enlist = #team_enlist{dun_id = DunId, activity_id = ActivityId, subtype_id = SubTypeId},
        member = MemberList
    } = State,
    case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, handle_match_complete, 1) of
        undefined ->
            Lock = ?ERRCODE(err240_change_when_matching),
            [lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_player, break_action_lock, [Lock]) || #mb{node = Node, id = RoleId} = Mb <- MemberList, not lib_team:is_fake_mb(Mb)],
            if
                DunId > 0 ->
                    {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 2, 0, ActivityId, SubTypeId, LeaderId]),
                    lib_team:send_team(State, BinData);
                true ->
                    ok
            end;
        Mod ->
            Mod:handle_match_complete(State)
    end.

%% 取消跟随
cancel_follow(Team, Id) ->
    #team{member=Mbs} = Team,
    NewMbs = case lists:keyfind(Id, #mb.id, Mbs) of
                 #mb{follow_id=MyFollowId, node = MyNode}=MyMb when MyFollowId > 0 ->
                     FollowMbs = case lists:keyfind(MyFollowId, #mb.id, Mbs) of
                                     false    -> Mbs;
                                     FollowMb ->
                                        Follows = lists:delete(Id, FollowMb#mb.follows),
                                        unode:apply(FollowMb#mb.node, lib_player, update_player_info, [MyFollowId, [{follows, Follows}]]),
                                        % lib_player:update_player_info(MyFollowId, [{follows, Follows}]),
                                        {ok, BinData} = pt_240:write(24024, [1, 0]),
                                        lib_team:send_to_uid(MyNode, Id, BinData),
                                        lists:keyreplace(MyFollowId, #mb.id, Mbs, FollowMb#mb{follows=Follows})
                                 end,
                     lists:keyreplace(Id, #mb.id, FollowMbs, MyMb#mb{follow_id=0});
                 _ -> Mbs
             end,
    Team#team{member=NewMbs}.

%% 取消跟踪我（Id）的人
cancel_follows(Team, Id) ->
    #team{member=Mbs} = Team,
    NewMbs = case lists:keyfind(Id, #mb.id, Mbs) of
                 #mb{follows=MyFollows, node = MyNode}=MyMb when is_list(MyFollows), MyFollows /= [] ->
                     {ok, BinData} = pt_240:write(24025, [0,0,0,0,0,0]),
                     F = fun(FollowId, TmpMbs) ->
                                 case lists:keyfind(FollowId, #mb.id, TmpMbs) of
                                     false    -> TmpMbs;
                                     FollowMb ->
                                         lib_team:send_to_uid(FollowMb#mb.node, FollowId, BinData),
                                         lists:keyreplace(FollowId, #mb.id, TmpMbs, FollowMb#mb{follow_id=0})
                                 end
                         end,
                     CleanFollowMbs = lists:foldl(F, Mbs, MyFollows),
                     unode:apply(MyNode, lib_player, update_player_info, [Id, [{follows, []}]]),
                     % lib_player:update_player_info(Id, [{follows, []}]),
                     lists:keyreplace(Id, #mb.id, CleanFollowMbs, MyMb#mb{follows=[]});
                 _ -> Mbs
             end,
    Team#team{member=NewMbs}.

%% 获取队员信息
get_mb_scene(TPS, Id, IsFollow) ->
    #player_status{id = RoleId, scene = SceneId, x = X, y = Y} = TPS,
    IsValhallaScene = lib_valhalla_api:is_valhalla_scene(SceneId),
    if
        IsValhallaScene ->
            mod_valhalla:get_mb_scene(RoleId, SceneId, X, Y, IsFollow, Id);
        true ->
            {ok, BinData} = pt_240:write(24025, [RoleId, SceneId, X, Y, IsFollow, 0]),
            lib_server_send:send_to_uid(Id, BinData)
    end.

%% 通知队伍变更消息--zzy
notify_team_change(_Node, SelfErrcode, MemberErrcode, TvId, Mb, State) ->
    #team{id=TeamId, member=MemberList} = State,
    RoleName = Mb#mb.figure#figure.name,
    %%自身提示
    case is_fake_mb(Mb) of
        false ->
            {ok, BinData} = pt_240:write(24030, [SelfErrcode]),
            lib_team:send_to_uid(Mb#mb.node, Mb#mb.id, BinData);
        _ ->
            ok
    end,
    %%其他人提示
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code({MemberErrcode, [RoleName]}),
    {ok, BinData1} = pt_240:write(24038, [ErrorCodeInt, ErrorCodeArgs]),
    F = fun(M)->
        case M#mb.id =/= Mb#mb.id andalso not is_fake_mb(M) of
            true ->
                lib_team:send_to_uid(M#mb.node, M#mb.id, BinData1);
            _ ->
                ok
        end
    end,
    lists:map(F,MemberList),
    lib_chat:send_TV({team, TeamId}, ?MOD_TEAM, TvId, [RoleName]).

%% 发送活动剩余次数--zzy
send_ac_left_time(PS,ActivityId) ->
    #player_status{ sid = Sid} = PS,
    List = data_team_ui:get_key_list(),
    case lists:keyfind(ActivityId,1,List) of
        false-> ok;
        {_,SubId} ->
            #team_enlist_cfg{module_id = ModuleId,sub_module = SubModId} = data_team_ui:get(ActivityId,SubId),
            case ModuleId > 0 of
                true->
                    case data_activitycalen:get_ac_sub(ModuleId,SubModId) of
                        [_|_] = SubList ->
                            SubList = data_activitycalen:get_ac_sub(ModuleId,SubModId),
                            AcSub = lists:min(SubList),
                            BaseAc = data_activitycalen:get_ac(ModuleId, SubModId, AcSub),
                            NumList = data_activitycalen_m:get_extra(PS, BaseAc),
                            {_,Max,Num} = lists:keyfind(?ACTIVITY_COUNT_TYPE_NORMAL,1,NumList),
                            %%区分是否为不限
                            case Max == 0 of
                                true->
                                    Type = 2,
                                    LeftTime = 0;
                                false->
                                    Type = 1,
                                    LeftTime = Max - Num
                            end,
                            {ok, BinData} = pt_240:write(24042, [Type,LeftTime]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        _ ->
                            {ok, BinData} = pt_240:write(24042, [2,0]),
                            lib_server_send:send_to_sid(Sid, BinData)
                    end;
                false->
                    {ok, BinData} = pt_240:write(24042, [2,0]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end.

make_fake_mb(Mb, DunId) ->
    #mb{power = Power, server_num = SerNum} = Mb,
    PowerRatio = lib_dungeon_team:get_dummy_power_ratio(DunId),
    #faker_info{figure = Figure} = lib_faker_api:create_faker(?MOD_TEAM, Mb),
    % battle_attr
    % skill
    % Skills = data_skill:get_ids(Career, Sex),
    Mb#mb{
        id = 0, %% 会加上location作为id
        node = undefined,
        figure= lib_dummy_api:change_figure(Figure, [rand_fashion]),%% 形象
        is_fake = 1,                            %% 队员pid
        power = trunc(PowerRatio*Power),                          %% 战力
        picture = <<>>,                     %% 玩家上传的头像
        help_type = ?HELP_TYPE_YES,                      %% 助战类型
        % join_time = undefined,              %% 入伍时间
        target_start_data = []              %% 开始参数
        , server_num = SerNum
    }.

%% 是否假人
is_fake_mb(Mb) -> Mb#mb.is_fake == 1.

is_zone_mod(ActivityId, SubModule) ->
    IsCls = util:is_cls(),
    case data_team_ui:get(ActivityId, SubModule) of
        #team_enlist_cfg{is_zone_mod = 1} when IsCls ->
            true;
        _ ->
            false
    end.

get_module(ActivityId, SubModule) ->
    case data_team_ui:get(ActivityId, SubModule) of
        #team_enlist_cfg{module_id = Module} ->
            Module;
        _ ->
            0
    end.

%% 获得位置
get_position(#mb{id = Id} = Mb, LeaderId) ->
    case Id of
        LeaderId -> ?TEAM_LEADER;
        _ ->
            case is_fake_mb(Mb) of
                true -> ?TEAM_FAKER;
                _ -> ?TEAM_MEMBER
            end
    end.

%% -----------------------------------------------------------------
%% 玩家进程
%% -----------------------------------------------------------------

%% 登录
login(#player_status{id = RoleId}) ->
    case lib_role:get_role_show(RoleId) of
        #ets_role_show{team_id = TeamId} when TeamId > 0 ->
            % ?MYLOG("hjhteam", "TeamId:~p RoleId:~p ~n", [TeamId, RoleId]),
            mod_team:cast_to_team(TeamId, {'quit_team', RoleId, 1});
        _R ->
            % ?MYLOG("hjhteam", "RoleId:~p _R:~p ~n", [RoleId, _R]),
            skip
    end.

set_req_team_id(PS, TeamId) ->
    case PS#player_status.team of
        #status_team{reqlist = ReqList} = TeamStatus ->
            case lists:member(TeamId, ReqList) of
                false ->
                    {ok, PS#player_status{team = TeamStatus#status_team{reqlist = [TeamId|ReqList]}}};
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

join_team_success(#player_status{team = #status_team{team_id = TeamId0}, id= RoleId}, [TeamId|_]) when TeamId0 > 0 andalso TeamId0 =/= TeamId ->
    mod_team:cast_to_team(TeamId, {already_joined_in_another, RoleId});

join_team_success(PS0, [TeamId, TeamPid, EnList, HelpType, IsMatching]) ->
    #player_status{id = RoleId} = PS0,
    case PS0#player_status.team of
        #status_team{reqlist = [_,_|_] = ReqList} ->
            mod_team_enlist:clear_teams_reqlist_by_id(RoleId, lists:delete(TeamId, ReqList));
        _ ->
            ok
    end,
    PS = silent_cancel_team_match(PS0),
    lib_team:send_ac_left_time(PS, EnList#team_enlist.activity_id),
    add_team_event_listener(),
    if
        IsMatching == 1 ->
            PS1 = update_help_type(lib_player:setup_action_lock(PS, ?ERRCODE(err240_change_when_matching)), EnList#team_enlist.dun_id, TeamId, HelpType);
        true ->
            PS1 = update_help_type(PS, EnList#team_enlist.dun_id, TeamId, HelpType)
    end,
    {ok, PS1#player_status{team = PS1#player_status.team#status_team{reqlist = [], team_pid = TeamPid}}}.

auto_match_team(PS, Args) ->
    case PS of
        #player_status{team=#status_team{team_id = TeamId}} when TeamId =:= 0 ->
            Mb = lib_team_api:thing_to_mb(PS),
            mod_team_enlist:match_next(Mb, Args);
        _ ->
            ok
    end.

%% 匹配中创建队伍
%% 情况1:能创建队伍直接创建队伍
%% 情况2:不能创建队伍继续匹配,倒计时结束就取消匹配
handle_noteam_for_match(Player, ActivityId, SubTypeId) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{default_lv_min = LMin, default_lv_max = LMax} ->
            case check_handle_noteam_for_match(Player, ActivityId, SubTypeId) of
                {ok, _} ->
                    UnlockPlayer = silent_cancel_team_match(Player),
                    #player_status{team = TS} = UnlockPlayer,
                    case create_team(UnlockPlayer#player_status{team = TS#status_team{match_after_created = true}}, ActivityId, SubTypeId, Player#player_status.scene, LMin, LMax) of
                        {ok, NewPlayer} ->
                            % mod_team:cast_to_team(TeamId, {'set_matching_state', RoleId, 1}),
                            {ok, NewPlayer};
                        _Err ->
                            ok
                    end;
                _Err ->
                    ok
            end;
        _ ->
            ok
    end.

%% 检查是否在匹配中创建队伍
check_handle_noteam_for_match(Player, ActivityId, SubTypeId) ->
    #player_status{team = StatusTeam} = Player,
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{dun_id = DunId} -> ok;
        _ -> DunId = 0
    end,
    LeaderPS = Player#player_status{help_type_setting = #{DunId => ?HELP_TYPE_NO}}, %% 只是用来检查条件用
    UnlockPS = case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, simulate_cancel_team_match, 3) of
        undefined ->
            % 模拟开锁
            lib_player:break_action_lock(
                LeaderPS#player_status{team = StatusTeam#status_team{match_info = []}},
                ?ERRCODE(err240_change_when_matching)
                );
        Mod ->
            Mod:simulate_cancel_team_match(LeaderPS)
    end,
    check_start_team_target(UnlockPS, ActivityId, SubTypeId).

create_team(Player, ActivityId, SubTypeId, SceneId, LvMin, LvMax) ->
    create_team(Player, ActivityId, SubTypeId, SceneId, LvMin, LvMax, 0).

create_team(Player, ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue) ->
    #player_status{
        figure = #figure{lv = Lv, name = RoleName}, id = RoleId,
        guild_assist = #status_assist{assist_id = AssistId},
        team              = #status_team{
            team_id             = OldTeamId,
            team_pid            = OldTeamPid,
            reqlist             = ReqList,
            cls_create_time     = LastClsCreateTime,
            match_after_created = Match
        } %% , bonfire_ids=BonfireIds
    } = Player,
    ?IF(ReqList == [], ok, mod_team_enlist:clear_teams_reqlist_by_id(RoleId, ReqList)),
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{default_lv_min = LMin, default_lv_max = LMax, dun_id = DunIdA} ->
            if
                LMin > LvMin orelse LvMax < LvMin ->
                    ChooseLvError = true;
                LMax > 0 andalso LvMax > LMax ->
                    ChooseLvError = true;
                true ->
                    ChooseLvError = false
            end,
            DunId = lib_team_match:get_team_dun_id(ActivityId, SubTypeId, DunIdA);
        _ ->
            ChooseLvError = false,
            DunId = 0
    end,
    CreateTime = utime:unixtime(),
    IsOnDungeon = lib_dungeon:is_on_dungeon(Player),
    IsOnAssist = lib_guild_assist:is_in_lock_team_assist(Player),
    IsOnEudemons = lib_eudemons_land:is_in_eudemons_boss(Player#player_status.scene),
    if
        OldTeamId /= 0 ->
            case misc:is_process_alive(OldTeamPid) of
                true ->
                    {false, ?ERRCODE(err240_in_team)};
                _ ->
                    mod_team:cast_to_team(OldTeamId, {'quit_team', RoleId, 1}),
                    do_creat_team(Player, ActivityId, SubTypeId, SceneId, DunId, LvMax, LvMin, JoinConValue, CreateTime, Match)
            end;
        Lv =< ?TEAM_NEED_LV ->
            {false, ?ERRCODE(err240_not_enough_lv_to_create_team)};
        ChooseLvError ->
            {false, ?ERRCODE(err240_choose_lv_error)};
        CreateTime - LastClsCreateTime < 5 ->
            {false, ?ERRCODE(err240_team_create_unfinished)};
        IsOnDungeon ->
            {false, ?ERRCODE(err610_on_dungeon)};
        IsOnAssist ->
            {false, ?ERRCODE(err204_in_guild_assist)};
        IsOnEudemons ->
            {false, {?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon_by_other), [RoleName]}};
        true ->
            if
                IsOnAssist -> % 璀璨之海卡协助特殊处理
                    {_, _, NewPlayer} = lib_guild_assist:cancel_assist_do(Player, AssistId, 1);
                true -> NewPlayer = Player
            end,
            do_creat_team(NewPlayer, ActivityId, SubTypeId, SceneId, DunId, LvMax, LvMin, JoinConValue, CreateTime, Match)
    end.

do_creat_team(Player, ActivityId, SubTypeId, SceneId, DunId, LvMax, LvMin, JoinConValue, CreateTime, Match) ->
    LeaderPS = Player#player_status{help_type_setting = #{DunId => ?HELP_TYPE_NO}}, %% 只是用来检查条件用
    CreateType = 1, TeamName = "", JoinType = ?TEAM_JOIN_TYPE_AUTO, IsInvite = 1,
    case check_create_team_target(LeaderPS, ActivityId, SubTypeId, Match) of
        {ok, _} ->
            Player1 = lib_dungeon_team:init_help_type(Player, DunId),
            #player_status{id = RoleId} = Player1,
            Leader = lib_team_api:thing_to_mb(Player1),
            case lib_team:is_cls_target(ActivityId, SubTypeId) of
                false ->
                    TeamId = mod_team_create:get_new_id(),
                    {ok, NewPidTeam} = mod_team:start([TeamId, CreateType, ActivityId, SubTypeId, SceneId, TeamName, JoinType, IsInvite,
                        [Leader], [{lv, [LvMin, LvMax]}, {join_con_value, JoinConValue}]]),
                    NewPlayer = create_team_done(Player1, TeamId, NewPidTeam, ActivityId);
                true ->
                    Node = mod_disperse:get_clusters_node(),
                    Args = [CreateType, ActivityId, SubTypeId, SceneId, TeamName, JoinType, IsInvite,
                        [Leader], [{lv, [LvMin, LvMax]}, {join_con_value, JoinConValue}]],
                    mod_clusters_node:apply_cast(mod_team_create, create_team, [Node, RoleId, CreateTime, ActivityId, Args]),
                    NewPlayer = Player1#player_status{team = #status_team{cls_create_time = CreateTime, match_after_created = Match}}
            end,
            {ok, NewPlayer};
        {false, _OtherErrorCode, MyErrorCode} ->
%%                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(MyErrorCode),
%%                    TransErrorCodeInt = lib_team:transfer_create_team_errcode(ErrorCodeInt),
            {false, MyErrorCode};
        {false, MyErrorCode} ->
            {false, MyErrorCode}
    end.

%% 检查队伍创建的目标
%% Match true自动匹配 | false不自动匹配
%% return {ok, Data} | {false, Code} | {false, OtherCode, Code}
check_create_team_target(LeaderPS, ActivityId, SubTypeId, true) ->
    check_start_team_target(LeaderPS, ActivityId, SubTypeId);
check_create_team_target(_LeaderPS, _ActivityId, _SubTypeId, _Match) ->
    {ok, []}.

%% 检查
%% @return true | {false, OtherErrorCode, MyErrorCode}
%% OtherErrorCode, MyErrorCode :: is_integer()|{is_integer(), is_list()}
common_check(Player, ActivityId, SubTypeId) ->
    CheckList = [dungeon, lv],
    do_common_check(CheckList, Player, ActivityId, SubTypeId).

check_for_create_team(Player, ActivityId, SubTypeId) ->
    CheckList = [dungeon, lv],
    do_common_check(CheckList, Player, ActivityId, SubTypeId).

%% 重连数据处理
do_common_check([], _Player, _ActivityId, _SubTypeId) -> true;
do_common_check([H|T], Player, ActivityId, SubTypeId) ->
    case common_check_help(H, Player, ActivityId, SubTypeId) of
        true -> do_common_check(T, Player, ActivityId, SubTypeId);
        {false, OtherErrorCode, MyErrorCode} -> {false, OtherErrorCode, MyErrorCode}
    end.

common_check_help(lv, Player, ActivityId, SubTypeId) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        [] ->
            true;
        #team_enlist_cfg{default_lv_min = Min, default_lv_max = Max} ->
            #player_status{ figure = #figure{name = Name, lv = Lv}} = Player,
            if
                Lv < Min ->
                    {false,
                     {?ERRCODE(err240_not_enough_lv_to_enter_target_with_name), [Name]},
                     {?ERRCODE(player_lv_less), [Min]}
                    };
                Max > 0 andalso Lv > Max ->
                    {false,
                     {?ERRCODE(err240_not_enough_lv_to_enter_target_with_name), [Name]},
                     {?ERRCODE(player_lv_large), [Max]}
                    };
                true ->
                    true
            end
    end;
common_check_help(dungeon, Player, ActivityId, SubTypeId) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{dun_id = DunId} when DunId > 0 ->
            case data_dungeon:get(DunId) of
                [] -> true;
                Dun ->
                    lib_dungeon_team:check_dungeon_on_team(Player, Dun)
            end;
        _ -> true
    end.

%% 转换创建队伍的错误码
transfer_create_team_errcode(ErrorCode) ->
    NoCountErr = ?ERRCODE(err610_have_no_count_to_enter_target),
    NotEnoughLvErr = ?ERRCODE(err240_not_enough_lv_to_enter_target),
    case ErrorCode of
        NoCountErr -> ?ERRCODE(err610_have_no_count_to_create_target);
        NotEnoughLvErr -> ?ERRCODE(err240_not_enough_lv_to_create_target);
        _ -> ErrorCode
    end.


lock_login(Player, TeamId, Position) ->
    #player_status{team = StatusTeam} = Player,
    NewTeam = StatusTeam#status_team{team_id = TeamId, positon = Position},
    NewPlayer = Player#player_status{team = NewTeam},
    mod_scene_agent:update(NewPlayer, [{team_flag, NewTeam}]),
    {ok, NewPlayer}.

%% lib_player:apply_cast(InfoId, ?APPLY_CAST_STATUS, lib_team, get_mb_scene, [Id, IsFollow]),
members_apply_cast(_ClsType, Mbs, ApplyCastType, Mod, Fun, Args) ->
    F = fun(MemberNode, MemberId) ->
%%                mod_team:cast_to_game(ClsType, MemberNode, lib_player, apply_cast, [MemberId, ApplyCastType, Mod, Fun, Args])
            lib_player:apply_cast(MemberNode, MemberId, ApplyCastType, ?NOT_HAND_OFFLINE, Mod, Fun, Args)
        end,
    [F(M#mb.node, M#mb.id)||M <- Mbs, not is_fake_mb(M)].

change_teammate_in_team(#player_status{team = #status_team{team_id = TeamId}} = PS, TeamId, ActivityId, SubTypeId, MemberInfos) ->
    ExpPS = update_exp_scale_change(PS, MemberInfos, ActivityId, SubTypeId),
    IntimacyPS = update_intimacy_change(ExpPS, MemberInfos),
    {ok, IntimacyPS};
change_teammate_in_team(_PS, _, _, _, _) -> ok.

update_exp_scale_change(PS, MemberInfos, ActivityId, SubTypeId) ->
    #player_status{team = StatusTeam, scene = SceneId, sid = Sid, dungeon = #status_dungeon{dun_id = DunId}} = PS,
    case lib_dungeon:is_dungeon_single(DunId) of % orelse lib_jail:is_in_jail(SceneId) of
        true ->
            Num = 0;
        _ ->
            case data_team_ui:get(ActivityId, SubTypeId) of
                #team_enlist_cfg{exp_scale_type = 1} ->
                    Num = length([1 || #slim_mb{scene = S} <- MemberInfos, S =:= SceneId]);
                #team_enlist_cfg{exp_scale_type = 2} ->
                    Num = length(MemberInfos);
                _ ->
                    Num = 0
            end
    end,
    ExpScale
    = if
          Num > 0 ->
              data_team_ui:get_exp_scale(Num);
          true ->
              0
      end,
    if
        ExpScale =/= StatusTeam#status_team.exp_scale ->
            {ok, BinData} = pt_240:write(24050, [ExpScale]),
            lib_server_send:send_to_sid(Sid, BinData),
            PS#player_status{team = StatusTeam#status_team{exp_scale = ExpScale}};
            % if
            %     ExpScale > 0 ->
            %         lib_goods_buff:add_goods_temp_buff(TmpPS, ?BUFF_TEAM_EXP, [{attr, [{?EXP_ADD, ExpScale}]}], 0);
            %     true ->
            %         lib_goods_buff:remove_buff(TmpPS, ?BUFF_TEAM_EXP)
            % end;
        true ->
            PS
    end.

update_intimacy_change(#player_status{team = #status_team{intimacy_lv = 0}} = PS, _MemberInfos) ->
    PS.
%%update_intimacy_change(PS, [_JustOne]) ->
%%    #player_status{team = StatusTeam} = PS,
%%    TmpPS = PS#player_status{team = StatusTeam#status_team{intimacy_lv = 0}},
%%    lib_goods_buff:remove_buff(TmpPS, ?BUFF_INTIMACY);
%%update_intimacy_change(PS, MemberInfos) ->
%%    #player_status{team = StatusTeam, id = RoleId} = PS,
%%    Intimacy
%%    = case [X || {_, _, X} <- lib_relationship:get_rela_and_intimacy_online(RoleId, [Id || #slim_mb{id = Id, online = ?ONLINE_ON} <- MemberInfos, Id =/= RoleId])] of
%%        [] ->
%%            0;
%%        List ->
%%            lists:max(List)
%%    end,
%%    #status_team{intimacy_lv = IntimacyLv} = StatusTeam,
%%    % case 10 of
%%    case data_relationship:get_intimacy_lv(Intimacy) of
%%        IntimacyLv ->
%%            PS;
%%        NewIntimacyLv ->
%%            ?PRINT("+++++++++++++++++++++ Intimacy ~p~n", [Intimacy]),
%%            TmpPS = PS#player_status{team = StatusTeam#status_team{intimacy_lv = NewIntimacyLv}},
%%            case data_rela:get_intimacy_lv_cfg(NewIntimacyLv) of
%%                #intimacy_lv_cfg{attr = [_|_] = Attr} ->
%%                    lib_goods_buff:add_buff(TmpPS, ?BUFF_INTIMACY, [{attr, Attr}], 0);
%%                _ ->
%%                    lib_goods_buff:remove_buff(TmpPS, ?BUFF_INTIMACY)
%%            end
%%    end.

change_team_enlist(Player, TeamId, EnList, HelpType) ->
    #player_status{team = #status_team{team_id = TeamId0}} = Player,
    if
        TeamId0 =:= TeamId ->
            send_ac_left_time(Player, EnList#team_enlist.activity_id),
            #team_enlist{dun_id = DunId} = EnList,
            Player1 = update_help_type(Player, DunId, TeamId, HelpType),
            {ok, Player1};
        true ->
            ok
    end.

update_help_type(Player, DunId, TeamId, HelpType) ->
    if
        DunId > 0 ->
            Player1 = lib_dungeon_team:init_help_type(Player, DunId),
            case lib_dungeon_team:get_help_type(Player1, DunId) of
                HelpType ->
                    ok;
                DiffHelpType ->
                    mod_team:cast_to_team(TeamId, {'set_help_type', Player#player_status.id, DunId, DiffHelpType})
            end,
            Player1;
        true ->
            Player
    end.

set_help_type(Player, DunId, HelpType) ->
    #player_status{id = RoleId, help_type_setting = HMap, sid = Sid, team = #status_team{team_id = TeamId}} = Player,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'set_help_type', RoleId, DunId, HelpType});
        true ->
            ok
    end,
    {ok, BinData} = pt_240:write(24033, [?SUCCESS, DunId, HelpType]),
    lib_server_send:send_to_sid(Sid, BinData),
    F = fun(DunId0, AccMap) -> AccMap#{DunId0 => HelpType} end,
    %% 众生之门特殊处理
    NewHMap = lists:foldl(F, HMap, lib_dungeon_util:list_special_share_dungeon(DunId)),
    {ok, Player#player_status{help_type_setting = NewHMap}}.

%% 队伍发送附近的玩家
send_scene_users_without_team(CopyId, Node, RoleId, SceneId) ->
    SceneUserList = lib_scene_agent:get_scene_user(CopyId),
    % Num = length(SceneUserList),
    List = [
        begin
            #ets_scene_user{platform = Platform, figure = Figure, server_num = SerNum, server_id = ServerId} = U,
            {TmpRoleId, Platform, SerNum, ServerId, Figure}
        end || #ets_scene_user{id = TmpRoleId, team = #status_team{team_id = TeamId}, online = Online} = U <- SceneUserList,
        RoleId =/= TmpRoleId andalso TeamId =:= 0 andalso Online == ?ONLINE_ON
    ],
    % ?PRINT("24053 >>> ~p~n", [List]),
    {ok, BinData} = pt_240:write(24053, [SceneId, List]),
    lib_server_send:send_to_uid(Node, RoleId, BinData).


%% 获取离线挂机时候的队伍野外挂机目标
get_onhook_target_type(SceneId)->
    Type = 3,
    SubIds = data_team_ui:get_activity_subtype_ids(Type),
    F = fun(SubId, TL) ->
                case data_team_ui:get(Type, SubId) of
                    #team_enlist_cfg{scene_id = SceneId} = E -> [E|TL];
                    _ -> TL
                end
        end,
    case lists:foldl(F, [], SubIds) of
        [] ->
            case data_team_ui:get(1, 0) of
                #team_enlist_cfg{module_id=Module, sub_module=SubModule, dun_id = DunId,
                                 scene_id = SceneId, default_lv_min = LvMin, default_lv_max = LvMax} ->
                    {#team_enlist{activity_id=1, subtype_id=0, module_id=Module,
                                  sub_module=SubModule, scene_id=SceneId, dun_id = DunId}, LvMin, LvMax};
                _ ->
                    {#team_enlist{},  0, 0}
            end;
        [#team_enlist_cfg{subtype_id = SubId, module_id=Module, sub_module=SubModule, dun_id = DunId,
                          scene_id = SceneId, default_lv_min = LvMin, default_lv_max = LvMax}|_] ->
            {#team_enlist{activity_id=Type, subtype_id=SubId,
                          module_id=Module, sub_module=SubModule, scene_id=SceneId, dun_id = DunId}, LvMin, LvMax}
    end.

get_max_team_member_num(ActivityId, SubTypeId) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{num = MaxNum} ->
            MaxNum;
        _ ->
            ?TEAM_MEMBER_MAX
    end.

calc_location(Members, MaxMemberNum) ->
    F = fun(Mb, {MemberList, Location}) ->
            {MemberList++[Mb#mb{location=Location}], Location+1}
    end,
    {NewMemberList, Acc} = lists:foldl(F, {[], 1}, Members),
    FreeLocations = case Acc > MaxMemberNum of true -> []; false -> lists:seq(Acc, MaxMemberNum) end,
    {NewMemberList, FreeLocations}.

%% 是否跨服目标
is_cls_target(?ACTIVITY_ID_BEINGS_GATE, _SubTypeId) ->
    case util:is_cls() of
        true -> % 已创建跨服队伍
            true;
        false -> % 本服判断
            DunId = lib_beings_gate_util:get_beings_gate_dungeon_id(),
            case data_dungeon:get(DunId) of
                #dungeon{scene_id = SceneId} ->
                    case data_scene:get(SceneId) of
                        #ets_scene{cls_type = ?SCENE_CLS_TYPE_CENTER} -> true;
                        _ -> false
                    end;
                _ -> false
            end
    end;
is_cls_target(?ACTIVITY_ID_NIGHT_GHOST, _) ->
    case util:is_cls() of
        true -> % 已创建跨服队伍
            true;
        false -> % 本服判断
            case lib_clusters_node_api:get_zone_mod(?MOD_NIGHT_GHOST) of
                ?ZONE_MOD_1 -> false;
                _ -> true
            end
    end;
is_cls_target(ActivityId, SubTypeId) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{scene_id = SceneId} ->
            case data_scene:get(SceneId) of
                #ets_scene{cls_type=?SCENE_CLS_TYPE_CENTER} ->
                    true;
                _ ->
                    false
            end;
        _ ->
            false
    end.

get_target_name(ActivityId, SubTypeId) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{subtype_name = Name} ->
            util:make_sure_binary(Name);
        _ ->
            <<"">>
    end.

get_team_cls_type(TeamId) ->
    case TeamId rem 2 of
        0 ->
            ?NODE_CENTER;
        _ ->
            ?NODE_GAME
    end.

create_team_done(PS, TeamId, TeamPid, ActivityId) ->
    #player_status{sid = Sid, team = Team, id = RoleId} = PS,
    lib_team:send_ac_left_time(PS, ActivityId),
    {ok, BinData} = pt_240:write(24000, [?SUCCESS, []]),
    lib_server_send:send_to_sid(Sid, BinData),
    add_team_event_listener(),
    if
        Team#status_team.match_after_created ->
            mod_team:cast_to_team(TeamId, {'set_matching_state', RoleId, 1});
        true ->
            ok
    end,
    PS#player_status{team=Team#status_team{team_id = TeamId, positon = ?TEAM_LEADER, reqlist = [], exp_scale = 0, cls_create_time = 0, arbitrate_info = [], match_info = [], intimacy_lv = 0, match_after_created = false, team_pid = TeamPid}}.

create_team_respond(Node, RoleId, CreateTime, Res) ->
    case lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, create_team_respond, [[Node, CreateTime, Res]]) of
        skip when Res =/= fail ->
            [TeamId|_] = Res,
            unode:apply(Node, mod_team_create, remove_created_team, [TeamId, CreateTime, ?FAIL]);
        _ ->
            ok
    end.

create_team_respond(#player_status{team = #status_team{cls_create_time = CreateTime}} = PS, [Node, CreateTime, Res]) ->
    #status_team{team_id = TeamId0} = TS = PS#player_status.team,
    case Res of
        [TeamId, TeamPid, ActivityId] when TeamId0 =:= TeamId orelse TeamId0 =:= 0 ->
            unode:apply(Node, mod_team_create, remove_created_team, [TeamId, CreateTime, ?SUCCESS]),
            create_team_done(PS, TeamId, TeamPid, ActivityId);
        [TeamId|_] ->
            unode:apply(Node, mod_team_create, remove_created_team, [TeamId, CreateTime, ?FAIL]),
            PS#player_status{team = TS#status_team{match_after_created = false}};
        _ ->
            PS#player_status{team = TS#status_team{match_after_created = false}}
    end;

create_team_respond(PS, [Node, CreateTime, Res]) ->
    #status_team{team_id = TeamId0} = PS#player_status.team,
    case Res of
        [TeamId|_] when TeamId0 =/= TeamId ->
            unode:apply(Node, mod_team_create, remove_created_team, [TeamId, CreateTime, ?FAIL]);
        _ ->
            PS
    end.

target_cost_something(#team_enlist{dun_id = DunId}) when DunId > 0 ->
    case data_dungeon:get(DunId) of
        #dungeon{cost = [_|_] = Cost} ->
            {true, Cost};
        _ ->
            false
    end;

target_cost_something(#team_enlist_cfg{dun_id = DunId}) when DunId > 0 ->
    case data_dungeon:get(DunId) of
        #dungeon{cost = [_|_] = Cost} ->
            {true, Cost};
        _ ->
            false
    end;

target_cost_something(_) -> false.


%% 开始投票
start_arbitrate(Player, [TeamId, ActivityId, SubTypeId, _SceneId, ArbitrateId, _EndTime]) ->
    #player_status{team = StatusTeam, sid = _Sid} = Player,
    case StatusTeam of
        #status_team{team_id = TeamId} ->
            % {ok, BinData} = pt_240:write(24035, [ActivityId, SubTypeId, SceneId, ArbitrateId, EndTime]),
            % lib_server_send:send_to_sid(Sid, BinData),
            NewStatusTeam = StatusTeam#status_team{arbitrate_info = [ActivityId, SubTypeId, ArbitrateId]},
            Player#player_status{team = NewStatusTeam};
        _ ->
            Player
    end.

%% 默认进入
start_arbitrate_silent(Player, [TeamId, ActivityId, SubTypeId, _SceneId, ArbitrateId, _EndTime]) ->
    #player_status{team = StatusTeam, id = RoleId} = Player,
    case StatusTeam of
        #status_team{team_id = TeamId} ->
            case lib_team:check_start_team_target(Player, ActivityId, SubTypeId) of
                {ok, Data} ->
                    mod_team:cast_to_team(TeamId, {'arbitrate_res', RoleId, ArbitrateId, {1, {ok, Data}}});
                {false, Code} ->
                    OtherErrorCode = lib_team:my_code_to_other_code(Player#player_status.figure#figure.name, Code),
                    Error = {false, OtherErrorCode, Code},
                    mod_team:cast_to_team(TeamId, {'arbitrate_res', RoleId, ArbitrateId, {0, Error}});
                {false, _Code, _MyErrorCode} = Error ->
                    mod_team:cast_to_team(TeamId, {'arbitrate_res', RoleId, ArbitrateId, {0, Error}})
            end,
            Player;
        _ ->
            Player
    end.

%% 检查队伍开启目标
%% return {ok, Data} | {false, Code} | {false, OtherCode, Code}
check_start_team_target(Player, ?ACTIVITY_ID_BEINGS_GATE, _SubTypeId) ->
    DungeonId = lib_beings_gate_util:get_beings_gate_dungeon_id(),
    lib_dungeon_team:check_mb_dungeon_condition(Player, DungeonId, []);

check_start_team_target(Player, ActivityId, SubTypeId) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{dun_id = DunId} when DunId > 0 ->
            lib_dungeon_team:check_mb_dungeon_condition(Player, DunId, []);
        _ ->
            {ok, []}
%%            case lib_player_check:check_all(Player) of
%%                true ->
%%                    case target_cost_something(data_team_ui:get(ActivityId, SubTypeId)) of
%%                        {true, Cost} ->
%%                            case lib_goods_api:check_object_list(Player, Cost) of
%%                                true ->
%%                                    {ok, []};
%%                                _ ->
%%                                    #player_status{figure = #figure{name = Name}} = Player,
%%                                    {
%%                                        false,
%%                                        {?ERRCODE(err240_cost_error), [Name]},
%%                                        ?ERRCODE(goods_not_enough)
%%                                    }
%%                            end;
%%                        _ ->
%%                            {ok, []}
%%                    end;
%%                {false, Code} ->
%%                    {false, ?FAIL, Code}
%%            end
    end.

auto_arbitrate(Player, TeamId, ActivityId, SubTypeId) ->
    case Player of
        #player_status{team = #status_team{team_id = TeamId}} ->
            pp_team:handle(24020, Player, [ActivityId, SubTypeId]);
        _ ->
            ok
    end.

check_for_other_match(Player, TeamId, ActivityId, SubTypeId) ->
    case Player of
        #player_status{team = #status_team{team_id = TeamId}, id = RoleId} ->
            case lib_team:check_start_team_target(Player, ActivityId, SubTypeId) of
                {ok, Data} ->
                    mod_team:cast_to_team(TeamId, {'ready_for_match', RoleId, Data});
                {false, Code} ->
                    OtherErrorCode = lib_team:my_code_to_other_code(Player#player_status.figure#figure.name, Code),
                    mod_team:cast_to_team(TeamId, {'fail_for_match', RoleId, OtherErrorCode});
                {false, OtherErrorCode, _Code} ->
                    mod_team:cast_to_team(TeamId, {'fail_for_match', RoleId, OtherErrorCode})
            end;
        _ ->
            ok
    end.

my_code_to_other_code(MyName, Code) ->
    Msg = util:make_error_code_msg(Code),
    {?ERRCODE(err240_me_to_other), [MyName, Msg]}.

%% 自动取消个人匹配
auto_cancel_role_match(Player) ->
    #player_status{team=#status_team{team_id=TeamId}} = Player,
    if
        TeamId =:= 0 -> cancel_role_match(Player);
        true -> skip
    end.

cancel_role_match(Player) ->
    #player_status{team = StatusTeam, id = RoleId, sid = Sid} = Player,
    case StatusTeam#status_team.match_info of
        [] ->
            {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 0, 0, 0, 0, RoleId]),
            lib_server_send:send_to_sid(Sid, BinData);
        [{ActivityId, SubTypeId}] ->
            case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, clear_role_match, 1) of
                undefined ->
                    case lib_team:is_cls_target(ActivityId, SubTypeId) of
                        true ->
                            mod_clusters_node:apply_cast(mod_team_enlist, clear_role_match, [RoleId]);
                        _ ->
                            mod_team_enlist:clear_role_match(RoleId)
                    end,
                    {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 0, 0, ActivityId, SubTypeId, RoleId]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    UnlockPS = lib_player:break_action_lock(
                        Player#player_status{team = StatusTeam#status_team{match_info = []}},
                        ?ERRCODE(err240_change_when_matching)
                    ),
                    {ok, UnlockPS};
                Mod ->
                    Mod:clear_role_match(Player)
            end;
        _ ->
            {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 0, 0, 0, 0, RoleId]),
            lib_server_send:send_to_sid(Sid, BinData),
            mod_team_enlist:clear_role_match(RoleId),
            {ok, Player#player_status{team = StatusTeam#status_team{match_info = []}}}
    end.

silent_cancel_team_match(Player) ->
    #player_status{team = StatusTeam, id = RoleId} = Player,
    case StatusTeam#status_team.match_info of
        [] ->
            Player;
        [{ActivityId, SubTypeId}] ->
            case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, clear_role_match, 1) of
                undefined ->
                    case lib_team:is_cls_target(ActivityId, SubTypeId) of
                        true ->
                            mod_clusters_node:apply_cast(mod_team_enlist, clear_role_match, [RoleId]);
                        _ ->
                            mod_team_enlist:clear_role_match(RoleId)
                    end,
                    UnlockPS = lib_player:break_action_lock(
                        Player#player_status{team = StatusTeam#status_team{match_info = []}},
                        ?ERRCODE(err240_change_when_matching)
                    ),
                    UnlockPS;
%%                    Player#player_status{team = StatusTeam#status_team{match_info = []}};
                Mod ->
                    Mod:clear_role_match(Player)
            end;
        _ ->
            Player#player_status{team = StatusTeam#status_team{match_info = []}}
    end.

take_over_team(State, {change_team_enlist, Args}) ->
    {ok, BinData} = pt_240:write(24017, [?SUCCESS|Args]),
    lib_team:send_team(State, BinData),
    State;

take_over_team(State, {set_matching, PtArgs}) ->
    {Code, NewState} = lib_team_mod:set_team_matching_state(State, 1),
    if
        Code =:= skip ->
            skip;
        true ->
            #team{match_st = MatchSt} = NewState,
            [MatchingState, ActivityId, SubTypeId, RoleId] = PtArgs,
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, MatchingState, MatchSt, ActivityId, SubTypeId, RoleId]),
            lib_team:send_team(NewState, BinData)
    end,
    NewState;


take_over_team(State, {check_matching, _PtArgs}) ->
    NewState = lib_team_mod:check_members_before_dosth(State, set_matching_state, []),
    NewState;

take_over_team(State, {invite_request, Msg}) ->
    gen_server:cast(self(), Msg),
    State.

handle_message(State, [{cast, Msg}|List]) ->
    case mod_team_cast:handle_cast(Msg, State) of
        {noreply, NewState} ->
            handle_message(NewState, List);
        Otherwise ->
            Otherwise
    end;

handle_message(State, [{info, Msg}|List]) ->
    case mod_team_info:handle_info(Msg, State) of
        {noreply, NewState} ->
            handle_message(NewState, List);
        Otherwise ->
            Otherwise
    end;

handle_message(State, []) ->
    {noreply, State}.

update_team_flag(Player, {OrderTeamId, TeamPosition, TeamId}) ->
    case Player#player_status.team of
        #status_team{team_id = TeamId0} when TeamId0 > 0 andalso TeamId0 =/= OrderTeamId ->
            Player;
        Team ->
            TeamPlayer = Player#player_status{team = Team#status_team{team_id=TeamId, positon=TeamPosition}},
            mod_scene_agent:update(TeamPlayer, [{team_flag, TeamPlayer#player_status.team}]),

            {ok, BinData} = pt_240:write(24013, [Player#player_status.id, TeamId, TeamPosition]),
            lib_server_send:send_to_area_scene(Player#player_status.scene, Player#player_status.scene_pool_id, Player#player_status.copy_id,
                                               Player#player_status.x, Player#player_status.y, BinData),
            lib_role:update_role_show(Player#player_status.id, [{team_id, TeamId}]),
            %% {ok, TeamStatus1} = lib_player_event:dispatch(TeamStatus, ?EVENT_JOIN_TEAM),
            if
                Team#status_team.team_id > 0 andalso TeamId == 0 ->
                    handle_quit_team(TeamPlayer, [events, intimacy_buff, exp_scale, onhook, matching, {guild_assist, Team#status_team.team_id}]);
                true ->
                    TeamPlayer
            end
    end.

add_team_event_listener() ->
    lib_player_event:add_listener(?EVENT_COMBAT_POWER, lib_team_api, handle_event),
    lib_player_event:add_listener(?EVENT_RENAME, lib_team_api, handle_event),
    lib_player_event:add_listener(?EVENT_CLS_SHUTDOWN, lib_team_api, handle_event),
%%    lib_player_event:add_listener(?EVENT_ACTION_LOCK, lib_team_api, handle_event),
    lib_player_event:add_listener(?EVENT_LV_UP, lib_team_api, handle_event).

remove_team_event_listener() ->
    lib_player_event:remove_listener(?EVENT_COMBAT_POWER, lib_team_api, handle_event),
    lib_player_event:remove_listener(?EVENT_RENAME, lib_team_api, handle_event),
    lib_player_event:remove_listener(?EVENT_CLS_SHUTDOWN, lib_team_api, handle_event),
%%    lib_player_event:remove_listener(?EVENT_ACTION_LOCK, lib_team_api, handle_event),
    lib_player_event:remove_listener(?EVENT_LV_UP, lib_team_api, handle_event).

handle_quit_team(Player, [events|T]) ->
    remove_team_event_listener(),
    handle_quit_team(Player, T);

handle_quit_team(Player, [intimacy_buff|T]) ->
    case Player#player_status.team of
        #status_team{intimacy_lv = Lv} when Lv > 0 ->
            NewPlayer = lib_goods_buff:remove_buff(Player, ?BUFF_INTIMACY),
            handle_quit_team(NewPlayer, T);
        _ ->
            handle_quit_team(Player, T)
    end;

handle_quit_team(Player, [exp_scale|T]) ->
    case Player#player_status.team of
        #status_team{exp_scale = ExpScale} = StatusTeam when ExpScale > 0 ->
            {ok, BinData} = pt_240:write(24050, [0]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            % NewPlayer = lib_goods_buff:remove_buff(Player#player_status{team = StatusTeam#status_team{exp_scale = 0}}, ?BUFF_TEAM_EXP),
            NewPlayer = Player#player_status{team = StatusTeam#status_team{exp_scale = 0}},
            handle_quit_team(NewPlayer, T);
        _ ->
            handle_quit_team(Player, T)
    end;

handle_quit_team(Player, [onhook|T]) ->
    if
        Player#player_status.online == ?ONLINE_OFF_ONHOOK ->
            {Target, _LvMin, _LvMax} = lib_team:get_onhook_target_type(Player#player_status.scene),
            #team_enlist{activity_id = ActivityId, subtype_id = SubId} = Target,
            Mb = lib_team_api:thing_to_mb(Player),
            case lib_team:is_cls_target(ActivityId, SubId) of
                true ->
                    mod_clusters_node:apply_cast(mod_team_enlist, match_teams, [Mb, [{ActivityId, SubId}]]);
                false ->
                    mod_team_enlist:match_teams(Mb, [{ActivityId, SubId}])
            end;
        true ->
            ok
    end,
    handle_quit_team(Player, T);

handle_quit_team(Player, [matching|T]) ->
    Lock = ?ERRCODE(err240_change_when_matching),
    case Player#player_status.action_lock of
        Lock ->
            handle_quit_team(lib_player:break_action_lock(Player, Lock), T);
        _ ->
            handle_quit_team(Player, T)
    end;

handle_quit_team(Player, [{guild_assist, OldTeamId}|T]) ->
    NewPlayer = lib_guild_assist:quit_team(Player, OldTeamId),
    handle_quit_team(NewPlayer, T);

handle_quit_team(Player, []) -> Player.

respond_team_disappear({'invite_response', _, #mb{id = RoleId}, Args}) ->
    lib_server_send:send_to_uid(RoleId, pt_240, 24008, [?ERRCODE(err240_team_disappear), []]),
    case lists:keyfind(mfa, 1, Args) of
        {mfa, {M, F, A}} ->
            apply(M, F, [?ERRCODE(err240_team_disappear)|A]);
        _ -> skip
    end;

respond_team_disappear({'join_team_request', #mb{id = RoleId}, _, _}) ->
    lib_server_send:send_to_uid(RoleId, pt_240, 24002, [?ERRCODE(err240_team_disappear), []]);

respond_team_disappear({'batch_quit_team', _DelRoleList, _, Args}) ->
    case lists:keyfind(mfa, 1, Args) of
        {mfa, {Mod, Fun, A}} ->
            apply(Mod, Fun, [1|A]);
        _ -> skip
    end;

respond_team_disappear(_) -> ok.

check_for_sth(Player, TeamId, Enlist, _ForWhat, CheckId) ->
    #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId} = Enlist,
    case check_start_team_target(Player, ActivityId, SubTypeId) of
        {ok, _} ->
            Res = true;
        {false, Code} ->
            case ?ERRCODE(err240_change_when_matching) of
                Code ->
                    Res = true;
                _ ->
                    OtherErrorCode = lib_team:my_code_to_other_code(Player#player_status.figure#figure.name, Code),
                    Res = {false, OtherErrorCode, Code}
            end;
        {false, _OtherErrorCode, _Code} = Res ->
            ok;
        Err ->
            ?ERR("check_start_team_target nomatch ~p~n", [Err]),
            Code = ?FAIL,
            Res = {false, Code, Code}
    end,
    mod_team:cast_to_team(TeamId, {check_sth_respond, Player#player_status.id, CheckId, Res}),
    ok.

ask_for_join_team(Player, TeamId, ActivityId, SubTypeId) ->
    #player_status{
        id = RoleId,
        figure = #figure{lv = Lv},
        guild_assist = #status_assist{assist_id = AssistId},
        team = #status_team{team_id=MyTeamId, team_pid = TeamPid},
        change_scene_sign = IsChangeSceneSign} = Player,
    IsOnDungeon = lib_dungeon:is_on_dungeon(Player),
    IsOnAssist = lib_guild_assist:is_in_lock_team_assist(Player),
    IsOnEudemons = lib_eudemons_land:is_in_eudemons_boss(Player#player_status.scene),
    Result = if
        MyTeamId /= 0 ->
            case misc:is_process_alive(TeamPid) of
                true ->
                    {false, ?ERRCODE(err240_in_team)};
                false ->
                    mod_team:cast_to_team(MyTeamId, {'quit_team', RoleId, 1}),
                    ok
            end;
        IsChangeSceneSign /= 0 -> {false, ?ERRCODE(err240_changing_scene)};
        Lv =< ?TEAM_NEED_LV -> {false, ?ERRCODE(err240_not_enough_lv_to_join_team)};
        IsOnDungeon -> {false, ?ERRCODE(err610_on_dungeon)};
        IsOnAssist ->
            {false, ?ERRCODE(err404_cannt_join_team_in_assist)};
        IsOnEudemons -> {false, ?ERRCODE(err470_in_team)};
        true ->
            case lib_team:check_start_team_target(Player, ActivityId, SubTypeId) of
                {ok, _} ->
%%                             Mb = lib_team_api:thing_to_mb(Player),
%%                             case mod_team:cast_to_team(TeamId,  {'join_team_request', Mb, ActivityId, SubTypeId}) of
%%                                 false -> {false, ?ERRCODE(err240_team_disappear)};
%%                                 _ -> ok
%%                             end;
                    ok;
                {false, _OtherErrorCode, MyErrorCode} ->
%%                             {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(MyErrorCode),
%%                             TransErrorCodeInt = lib_team:transfer_create_team_errcode(ErrorCodeInt),
                    {false, MyErrorCode};
                Other ->
                    Other
            end
    end,
    case Result of
        {false, ErrCode} ->
            {CodeInt, CodeArgs} = util:parse_error_code(ErrCode),
            {ok, BinData} = pt_240:write(24002, [CodeInt, CodeArgs]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        ok ->
            if
                IsOnAssist -> % 璀璨之海卡协助特殊处理
                    {_, _, NewPlayer} = lib_guild_assist:cancel_assist_do(Player, AssistId, 1);
                true -> NewPlayer = Player
            end,
            Mb = lib_team_api:thing_to_mb(NewPlayer),
            case mod_team:cast_to_team(TeamId,  {'join_team_request', Mb, ActivityId, SubTypeId}) of
                false -> {false, ?ERRCODE(err240_team_disappear)};
                _ -> ok
            end;
        _ -> skip
    end.

lock_for_start(Player, BeginTime) ->
    {ok, BinData} = pt_240:write(24058, [BeginTime]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    NowTime = utime:unixtime(),
    case BeginTime - NowTime of
        T when T > 5 ->
            ?ERR("lock team for start error ~p~n", [[BeginTime, T]]);
        _ ->
            ok
    end,
    Player.
    % Player1 = lib_player:break_action_lock(Player, ?ERRCODE(err240_change_when_matching)),
    % lib_player:soft_action_lock(Player1, ?ERRCODE(err240_team_starting), BeginTime - utime:unixtime() - 1).

send_from_local(ToNode, ToRoleId, BinData) ->
    case ToNode == undefined orelse node() == ToNode orelse ToNode == none of
        true ->
            lib_server_send:send_to_uid(ToRoleId, BinData);
        _ ->
            mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [ToNode, ToRoleId, BinData])
    end.


invite_player(FromNode, FromId, RoleId, Data) ->
    case lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_team, receive_invatation, [FromNode, FromId, Data]) of
        skip ->
            {ok, BinData} = pt_240:write(24006, [?ERRCODE(err240_other_offline)]),
            send_from_local(FromNode, FromId, BinData);
%%            ok;
        _ ->
            ok
    end.

receive_invatation(Player, FromNode, FromId, Data) ->
    [_TeamId, _MbLen, ActivityId, SubTypeId, _SceneId, _InviterId, _Figure, _InviteScene, Type] = Data,
    #player_status{
        online = OnLine,
        guild_assist = #status_assist{assist_id = AssistId},
        team = #status_team{team_id = TeamId},
        figure = #figure{name = RoleName}} = Player,
    IsOnAssist = lib_guild_assist:is_in_lock_team_assist(Player),
    if
        OnLine =/= ?ONLINE_ON ->
            {ok, BinData} = pt_240:write(24038, [?ERRCODE(err240_teammates_offline), RoleName]),
            send_from_local(FromNode, FromId, BinData);
%%            ok;
        TeamId > 0 ->
            {ok, BinData} = pt_240:write(24038, [?ERRCODE(err240_invite_res_has_team), RoleName]),
            send_from_local(FromNode, FromId, BinData);
%%            ok;
        IsOnAssist ->
            {ok, BinData} = pt_240:write(24038, [?ERRCODE(err240_invite_res_in_assist), RoleName]),
            send_from_local(FromNode, FromId, BinData);
        true ->
            if
                Type =:= 0 ->
                    {ok, InvateData} = pt_240:write(24007, Data),
                    lib_server_send:send_to_sid(Player#player_status.sid, InvateData),
                    {ok, BinData} = pt_240:write(24038, [?ERRCODE(err240_invite_res_ok), RoleName]),
                    send_from_local(FromNode, FromId, BinData);
                true ->
                    if
                        IsOnAssist -> % 璀璨之海卡协助特殊处理
                            {_, _, NewPlayer} = lib_guild_assist:cancel_assist_do(Player, AssistId, 1);
                        true -> NewPlayer = Player
                    end,
                    case check_start_team_target(NewPlayer, ActivityId, SubTypeId) of
                        {ok, _} ->
                            {ok, InvateData} = pt_240:write(24007, Data),
                            lib_server_send:send_to_sid(NewPlayer#player_status.sid, InvateData),
                            {ok, BinData} = pt_240:write(24038, [?ERRCODE(err240_invite_res_ok), RoleName]),
                            send_from_local(FromNode, FromId, BinData);
                        _ ->
%%                            {ok, BinData} = pt_240:write(24038, [?ERRCODE(err240_invite_res_check_fail), RoleName]),
%%                            send_from_local(FromNode, FromId, BinData)
                            ok
                    end
            end,
            ok
    end.

lose_team(Player) ->
    #player_status{team = #status_team{team_id = TeamId}, sid = Sid} = Player,
    {ok, BinData2} = pt_240:write(24005, [1]),
    lib_server_send:send_to_sid(Sid, BinData2),
    %%修改玩家数据 {team_flag, {TeamId, 0, 0}}
    lib_team:update_team_flag(Player, {TeamId, 0, 0}).

check_team(Player) ->
    #player_status{team = #status_team{team_id = TeamId}, id = RoleId} = Player,
    if
        TeamId > 0 ->
            put({check_team, TeamId}, true),
            mod_team:cast_to_team(TeamId, {check, RoleId}),
            erlang:send_after(5000, self(), {check_old_team_id, TeamId});
        true ->
            ok
    end.

check_team_success(TeamId) ->
    erase({check_team, TeamId}),
    ok.

team_is_took_over(Player, TeamId, TeamPid) ->
    case Player of
        #player_status{team = #status_team{team_id = TeamId} = ST} ->
            Player#player_status{team = ST#status_team{team_pid = TeamPid}};
        _ ->
            ok
    end.

%% 招募列表
%% Type 1:推荐;2:公会;3:好友
send_recruit_list(_Ps, _Type, 0) -> skip;

%% 推荐
send_recruit_list(Player, Type = 1, DunId) ->
    #player_status{id = RoleId} = Player,
    DunLv = lib_dungeon_api:get_dungeon_condition_lv(DunId),
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    EquipCountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    MaxCount = lib_dungeon_api:get_dungeon_daily_max_count(DunId),
    OnlineRIds = lib_online:get_online_ids(),
    RandList = ulists:list_shuffle(OnlineRIds),
    SubRandList = lists:sublist(RandList, 20),
    F = fun(#ets_role_show{id = TmpRoleId} = RoleShow, List) ->
        case length(List) =< 25 orelse lists:member(TmpRoleId, SubRandList) of
            true ->
                case RoleShow of
                    #ets_role_show{
                            figure = #figure{lv = Lv} = Figure,
                            online_flag = ?ONLINE_ON,
                            dun_daily_map = #{EquipCountType := Count},
                            team_id = TeamId,
                            combat_power = CombatPower
                            } when Count < MaxCount, TeamId == 0, Lv >= DunLv, TmpRoleId=/=RoleId ->
                        [{CombatPower, {TmpRoleId, Figure, Count, MaxCount, CombatPower}}|List];
                    _ ->
                        List
                end;
            false ->
                List
        end
    end,
    List = ets:foldl(F, [], ?ETS_ROLE_SHOW),
    SortList = lists:reverse(lists:keysort(1, List)),
    RecruitList = [T||{_SortKey, T}<-SortList],
    ?PRINT("RecruitList 1:~p ~n", [RecruitList]),
    {ok, BinData} = pt_240:write(24060, [Type, DunId, RecruitList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok;

%% 公会
send_recruit_list(#player_status{id = RoleId, figure = #figure{guild_id = GuildId}}, _Type = 2, DunId) ->
    DunLv = lib_dungeon_api:get_dungeon_condition_lv(DunId),
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    EquipCountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    MaxCount = lib_dungeon_api:get_dungeon_daily_max_count(DunId),
    case GuildId > 0 of
        true -> mod_guild:send_recruit_list(RoleId, GuildId, DunId, DunLv, EquipCountType, MaxCount);
        false -> skip
    end;

%% 好友
send_recruit_list(#player_status{id = RoleId}, Type = 3, DunId) ->
    DunLv = lib_dungeon_api:get_dungeon_condition_lv(DunId),
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    EquipCountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    MaxCount = lib_dungeon_api:get_dungeon_daily_max_count(DunId),
    RelaL = lib_relationship:get_relas_by_types(RoleId, 1),
    F = fun(#rela{other_rid = OtherRid}, List) ->
        case lib_role:get_role_show(OtherRid) of
            #ets_role_show{
                    figure = #figure{lv = Lv} = Figure,
                    online_flag = ?ONLINE_ON,
                    dun_daily_map = #{EquipCountType := Count},
                    team_id = TeamId,
                    combat_power = CombatPower
                    } when Count < MaxCount, TeamId == 0, Lv >= DunLv ->
                [{{Count, CombatPower}, {OtherRid, Figure, Count, MaxCount, CombatPower}}|List];
            _ ->
                List
        end
    end,
    List = lists:foldl(F, [], RelaL),
    F2 = fun({CountA, CombatPowerA}, {CountB, CombatPowerB}) ->
        if
            CountA == CountB -> CombatPowerA >= CombatPowerB;
            true -> CountA < CountB
        end
    end,
    SortList = lists:sort(F2, List),
    RecruitList = [T||{_SortKey, T}<-SortList],
    ?PRINT("RecruitList 3:~p ~n", [RecruitList]),
    {ok, BinData} = pt_240:write(24060, [Type, DunId, RecruitList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok;

send_recruit_list(_Ps, _Type, _DunId) ->
    ok.

%% 队员招募列表
send_recruit_list(#player_status{id = RoleId, figure = #figure{guild_id = GuildId}}, 2) ->
    case GuildId > 0 of
        true -> mod_guild:send_recruit_list(RoleId, GuildId);
        false -> skip
    end;

send_recruit_list(#player_status{id = RoleId}, Type = 3) ->
    RelaL = lib_relationship:get_relas_by_types(RoleId, 1),
    F = fun(#rela{other_rid = OtherRid}, List) ->
        case lib_role:get_role_show(OtherRid) of
            #ets_role_show{
                    figure = Figure,
                    online_flag = ?ONLINE_ON,
                    team_id = TeamId,
                    combat_power = CombatPower
                    } when TeamId == 0 ->
                [{OtherRid, Figure, CombatPower}|List];
            _ ->
                List
        end
    end,
    List = lists:foldl(F, [], RelaL),
    {ok, BinData} = pt_240:write(24061, [Type, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok;

send_recruit_list(_Ps, _Type) ->
    ok.

%% 仲裁
arbitrate_req(Ps, ActivityId, SubTypeId) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId, positon = Postion}, sid = Sid} = Ps,
    ?PRINT("arbitrate_req 24020 ActivityId:~p, SubTypeId:~p~n", [ActivityId, SubTypeId]),
    if
        TeamId =:= 0 ->
            {ok, BinData} = pt_240:write(24020, [?ERRCODE(err240_not_on_team), "", ActivityId, SubTypeId, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        Postion =/= ?TEAM_LEADER ->
            {ok, BinData} = pt_240:write(24020, [?ERRCODE(err240_not_leader_to_arbitrate_req), "", ActivityId, SubTypeId, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            case lib_team:check_start_team_target(Ps, ActivityId, SubTypeId) of
                {ok, Data} ->
                    mod_team:cast_to_team(TeamId, {'arbitrate_req', RoleId, ActivityId, SubTypeId, Data});
                {false, Code} ->
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(Code),
                    {ok, BinData} = pt_240:write(24020, [ErrorCodeInt, ErrorCodeArgs, ActivityId, SubTypeId, 0, 0]),
                    lib_server_send:send_to_sid(Sid, BinData);
                {false, _, Code} ->
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(Code),
                    {ok, BinData} = pt_240:write(24020, [ErrorCodeInt, ErrorCodeArgs, ActivityId, SubTypeId, 0, 0]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end.
