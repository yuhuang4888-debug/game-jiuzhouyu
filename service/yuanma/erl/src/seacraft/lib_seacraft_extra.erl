%%%-------------------------------------------------------------------
%%% @author luzhiheng
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Feb 2020 7:16 PM
%%%-------------------------------------------------------------------
-module(lib_seacraft_extra).
-author("luzhiheng").

%% API
-export([
    init_local_change_info/0
    ,login_exploit/1
    ,get_exploit_attr/1
    ,sort_camp_map_member/1
    ,center_to_game_member_list/4
    ,join_camp/2
    ,auto_join_add_member/7
    ,after_exit_camp/5
    ,exit_camp/3
%%    ,sync_sort_members/1
    ,get_seacraft_info/3
    ,get_privilege_list/3
    ,send_member_info/5
    ,option_privilege/6
    ,get_base_exploit/1
    ,sync_local_members/3
    ,members_job_change/4
    ,update_member_job/4
    ,change_sea_master/5
    ,local_change_sea_master/4
    ,update_sea_master/6
    ,update_member_list/3
    ,update_member_list/4
    ,send_member_to_center/3
    ,update_member_join_quit/3
    ,update_member_join_quit/5
    ,center_member_join_quit/3
    ,close_privilege/3
    ,load_privilege_status/2
    ,init_privilege_status/2
    ,flush_privilege_status/1
    ,send_msg_camp/2
%%    ,gm_sync_member_list/1
    ,sort_member/2
    ,make_record/2
]).


-include("seacraft.hrl").
-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("def_module.hrl").

make_record(camp_member_info, Args) ->
    {ServerId,GuildId,GuildName,Vip,RoleId,RoleName,Lv,JobId, Exploit,CombatPower} = Args,
    #camp_member_info{
        server_id = ServerId, guild_id = GuildId,
        guild_name = GuildName, vip = Vip,
        role_id = RoleId, role_name = RoleName,
        lv = Lv, job_id = JobId, exploit = Exploit,
        fright = CombatPower
    };
make_record(privilege_item, Args) ->
    {PrivilegeId, DayTimes, Status, EndTime, Ref} = Args,
    #privilege_item{
        privilege_id = PrivilegeId,
        times = DayTimes,
        status = Status,
        end_time = EndTime,
        ref = Ref}.

%% 初始化成员变更信息
%% @return #{Camp => {ChangeList, JoinList, QuitIdList}}
%% ChangeList [{Vip, RoleId, RName, Lv, Exploit, CombatPower}]
%% JoinList  [{ServerId, GuildId, GuildName, Vip, RoleId, RoleName, Lv, JobId, Exploit, CombatPower}]
%% QuitIdList   [RoleId]
init_local_change_info() ->
    ChangeInfoList = db:get_all(?SELECT_LOCAL_CHANGEINFO),
    JoinList = db:get_all(?SELECT_LOCAL_JOIN),
    QuitList = db:get_all(?SELECT_LOCAL_QUIT),
    F1 = fun([Camp, Vip, RoleId, RName, Lv, Exploit, CombatPower], Acc1) ->
            List1 = maps:get(Camp, Acc1, []),
            maps:put(Camp, [{Vip, RoleId, RName, Lv, Exploit, CombatPower}|List1], Acc1)
        end,
    ChangInfoMap = lists:foldl(F1, #{}, ChangeInfoList),
    F2 = fun([Camp,ServerId,GuildId,GuildName,Vip,RoleId,RoleName,Lv,JobId, Exploit,CombatPower], Acc2) ->
            List2 = maps:get(Camp, Acc2, []),
            R = make_record(camp_member_info, {ServerId,GuildId,GuildName,Vip,RoleId,RoleName,Lv,JobId, Exploit,CombatPower}),
            maps:put(Camp, [R|List2], Acc2)
         end,
    JoinListMap = lists:foldl(F2, #{}, JoinList),
    F3 = fun([Camp, RoleId], Acc3) ->
            List3 = maps:get(Camp, Acc3, []),
            maps:put(Camp, [RoleId|List3], Acc3)
        end,
    QuitListMap = lists:foldl(F3, #{}, QuitList),

    CampList = data_seacraft:get_all_camp(),
    F4 = fun(Camp, ChangeInfoAcc) ->
            CList = maps:get(Camp, ChangInfoMap, []),
            JList = maps:get(Camp, JoinListMap, []),
            QList = maps:get(Camp, QuitListMap, []),
            maps:put(Camp, {CList, JList, QList}, ChangeInfoAcc)
        end,
    lists:foldl(F4, #{}, CampList).

%% 用户登录加载功勋
login_exploit(Ps) ->
    #player_status{id = RoleId, figure = Figure} = Ps,
    Exploit =
        case db:get_row(io_lib:format(?SELECT_ROLE_EXPLOIT, [RoleId])) of
            [] -> 0;
            [Value] -> Value
        end,
    Ps#player_status{figure = Figure#figure{exploit = Exploit}}.

%% 获取功勋提供的属性
get_exploit_attr(Ps) ->
    #player_status{figure = #figure{exploit = Exploit}} = Ps,
    #base_sea_exploit{attr = Attr, passive_skill = PassiveSkill} = get_base_exploit(Exploit),
    lib_player_attr:add_attr(list, [Attr, PassiveSkill]).

%% 加载特权状态
%% center 调用
%% @param Zone, Camp
%% @param ServerIds 加入当前阵营工会所属的ServerId
load_privilege_status(Zone, Camp) ->
    case db:get_all(io_lib:format(?SELECT_PRIVILEGE_STATUS, [Zone, Camp])) of
        [] -> %% 首次加载
            init_privilege_status(Zone, Camp);
        PriList ->
            Now = utime:unixtime(),
            [begin
                 if
                     EndTime == 0 -> make_record(privilege_item, {PrivilegeId, Times, Status, EndTime, undefined});
                     EndTime > Now -> %% 设置定时器
                         NextPrItem = make_record(privilege_item, {PrivilegeId, Times, ?PRIVILEGE_CLOSE, 0, undefined}),
                         Msg = {'close_privilege', {Zone, Camp}, NextPrItem},
                         Ref = util:send_after(undefined, (EndTime - Now)*1000, self(), Msg),
                         make_record(privilege_item, {PrivilegeId, Times, Status, EndTime, Ref});
                     true -> %% 过期了，关闭特权状态
                         NewItem = make_record(privilege_item, {PrivilegeId, Times, ?PRIVILEGE_CLOSE, 0, undefined}),
                         db_save_privilege_item(Zone, Camp, NewItem),
                         NewItem
                 end
             end||[PrivilegeId, Times, Status, EndTime] <-PriList]
    end.

%% 本服阵营信息发送到各个游戏服的阵营信息
send_msg_camp(BinData, GuildMap) ->
    F = fun(SerId, Val) ->
        [begin
             mod_clusters_node:apply_cast(mod_clusters_center, apply_cast, [SerId, lib_server_send, send_to_guild, [GuildId, BinData]])
         end||#sea_guild{guild_id = GuildId} <- Val]
        end,
    maps:map(F, GuildMap).

%% 每天凌晨4点刷新特权状态
flush_privilege_status(CampMap) ->
    maps:map(
        fun({Zone, Camp}, CampInfo) ->
            #camp_info{privilege_status = OldStatus} = CampInfo,
            F = fun(OldItem, {GrandStatus, GrandParams}) ->
                #privilege_item{privilege_id = PrivilegeId, status = Status, end_time = EndTime, ref = Ref} = OldItem,
                #base_sea_privilege{day_times = DayTimes} = data_seacraft:get_sea_privilege(PrivilegeId),
                Args = {PrivilegeId, DayTimes, Status, EndTime, Ref},
                NewItem = make_record(privilege_item, Args),
                {[NewItem|GrandStatus], [[Zone, Camp,PrivilegeId, DayTimes, Status, EndTime]|GrandParams]}
                end,
            {NewStatus, ReplaceParams} = lists:foldl(F, {[], []}, OldStatus),
            Sql = usql:replace(seacraft_camp_privilege, [zone,camp,privilege_id,times,status,end_time], ReplaceParams),
            ?IF(Sql =/= [], db:execute(Sql), skip),
            mod_zone_mgr:apply_cast_to_zone2(1, Zone, mod_seacraft_local, center_flush_privilege, [Camp, NewStatus]),
            CampInfo#camp_info{privilege_status = NewStatus}
        end
    , CampMap).

init_privilege_status(Zone, Camp) ->
    PList = data_seacraft:lists_sea_privilege(),
    F = fun(PrivilegeId, {GrandStatus, GrandParams}) ->
        #base_sea_privilege{day_times = DayTimes} = data_seacraft:get_sea_privilege(PrivilegeId),
        NewItem = #privilege_item{privilege_id = PrivilegeId, times = DayTimes},
        {[NewItem|GrandStatus], [[Zone, Camp,PrivilegeId, DayTimes, 0, 0]|GrandParams]}
        end,
    {NewStatus, ReplaceParams} = lists:foldl(F, {[], []}, PList),
    Sql = usql:replace(seacraft_camp_privilege, [zone,camp,privilege_id,times,status,end_time], ReplaceParams),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    NewStatus.

%% 排序camp_info里member_list顺序
%% center初始化数据之后调用
sort_camp_map_member(CampMap) ->
    maps:map(
      fun(_,CampInfo) ->
          #camp_info{member_list = MemberList} = CampInfo,
          NewMemberList = lists:sort(fun sort_member/2, MemberList),
          CampInfo#camp_info{member_list = NewMemberList}
      end
    , CampMap).

%% 游戏服与跨服中心建立连接后执行
%% 跨服重心发送成员数据至指定游戏服
%% @param ServerId 需发送的服务器id
%% @param CampList 阵营id列表
%% @param CampMap 阵营信息map
center_to_game_member_list(Zone, ServerId, CampList, CampMap) ->
    %?MYLOG("zh_sea_init", "CampList ~p ~n", [CampList]),
    lists:foreach(
        fun(Camp) ->
            case maps:get({Zone,Camp}, CampMap, false) of
                #camp_info{member_list = MemberList} ->
                    sync_local_members([ServerId], Camp, MemberList, 1);
                _ -> skip
            end
        end
    , CampList).

%% 加入阵营
%% @param State kf_seacraft_state
join_camp(State, Args) ->
    [ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer, _GuildMemberInfos] = Args,
    NewState = lib_seacraft_mod:join_camp(State, ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer),
    NewState.
    % if
    %     NewState == State -> State;
    %     true ->
    %         %% 将工会成员数据记录
    %         #kf_seacraft_state{camp_map = CampMap} = NewState,
    %         Zone = lib_clusters_center_api:get_zone(ServerId),
    %         #camp_info{member_list = MemberList} = CampInfo = maps:get({Zone, Camp}, CampMap, #camp_info{}),
    %         F = fun(InfoItem, {ML, AccParam}) ->
    %                 {RId, Vip, Lv, RName, Exploit, CombatPower} = InfoItem,
    %                 NewAccParam = [[Zone, Camp, ServerId, GuildId, Vip, RId,RName,Lv,?SEA_MEMBER,Exploit,CombatPower]|AccParam],
    %                 G = make_record(camp_member_info, {ServerId, GuildId, GuildName, Vip, RId, RName, Lv, ?SEA_MEMBER, Exploit, CombatPower}),
    %                 {lists:keystore(G#camp_member_info.role_id, #camp_member_info.role_id, ML, G), NewAccParam}
    %             end,
    %         {NewMemberListTmp, ReplaceParams} = lists:foldl(F, {MemberList, []}, GuildMemberInfos),
    %         Sql = usql:replace(seacraft_member_info, [zone,camp,server_id,guild_id,vip,role_id,role_name, lv, job_id,exploit,combat_power], ReplaceParams),
    %         Sql =/= [] andalso db:execute(Sql),
    %         NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp),
    %         NewCampInfo = CampInfo#camp_info{member_list = NewMemberList},
    %         NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
    %         NewState#kf_seacraft_state{camp_map = NewCampMap}
    % end.

%% 工会选择阵营回调，自动加入也会触发
%% 成员信息同步
auto_join_add_member(CampInfo, Zone, ServerId, Camp, GuildId, GuildName, GuildMemberInfos) ->
    #camp_info{member_list = MemberList} = CampInfo,
    F = fun(Info, {GrandInfo, GrandParams}) ->
        {RId, Vip, Lv, RName, Exploit, CombatPower} = Info,
        Record = make_record(camp_member_info, {ServerId, GuildId, GuildName, Vip, RId, RName, Lv, ?SEA_MEMBER, Exploit, CombatPower}),
        {[Record|GrandInfo], [[Zone, Camp, ServerId, GuildId, Vip, RId,RName,Lv,?SEA_MEMBER,Exploit,CombatPower]|GrandParams]}
        end,
    {GMInfos, ReplaceParam} = lists:foldl(F, {[], []}, GuildMemberInfos),
    Sql = usql:replace(seacraft_member_info, [zone,camp,server_id,guild_id,vip,role_id,
        role_name, lv, job_id, exploit, combat_power], ReplaceParam),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    mod_zone_mgr:apply_cast_to_zone(1, Zone, mod_seacraft_local, sync_after_join_member,[Camp, GMInfos]),
    NewMemberListTmp = GMInfos ++ [M||M = #camp_member_info{guild_id = MGId}<-MemberList, MGId =/= GuildId],
    ?PRINT("GuildMemberInfos ~p ~n", [GuildMemberInfos]),
    NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp),
    CampInfo#camp_info{member_list = NewMemberList}.


after_exit_camp(CampInfo, Zone, Camp, ServerId, GuildId) ->
    #camp_info{member_list = MemberList} = CampInfo,
    db:execute(io_lib:format(?DELETE_SEA_MEMBER_INFO, [Zone, ServerId, GuildId])),
    NewMemberList = exit_camp(MemberList, ServerId, GuildId),
    mod_zone_mgr:apply_cast_to_zone(1, Zone, mod_seacraft_local, exit_camp,[Camp, ServerId, GuildId]),
    CampInfo#camp_info{member_list = NewMemberList}.


%% 退出阵营
%% @param State kf_seacraft_state
exit_camp(MemberList, ServerId, GuildId)->
    [Item||#camp_member_info{guild_id = GId, server_id = SId} = Item <- MemberList,
        GuildId =/= GId andalso ServerId =/= SId].

%%%% 成员排序且同步至游戏服(4点执行)
%%%% @param State kf_seacraft_state
%%sync_sort_members(State) ->
%%    #kf_seacraft_state{start_time = StartTime, camp_map = CampMap} = State,
%%    IsSameDay = utime:is_same_day(StartTime, utime:unixtime()),
%%    if
%%        IsSameDay == false -> State;
%%        true ->
%%            NewCampMap =
%%                maps:map(fun({_Zone, Camp}, CampInfo) ->
%%                    #camp_info{member_list = OldList, guild_map = GuildMap} = CampInfo,
%%                    NewList = lists:sort(fun sort_member/2, OldList),
%%%%                    ?MYLOG("zh_sea", " sync_sort_member ~n", []),
%%                    sync_local_members(maps:keys(GuildMap), Camp, NewList, 1),
%%                    CampInfo#camp_info{member_list = NewList}
%%                end, CampMap),
%%            State#kf_seacraft_state{camp_map = NewCampMap}
%%    end.

%%gm_sync_member_list(State) ->
%%    #kf_seacraft_state{start_time = _StartTime, camp_map = CampMap} = State,
%%    NewCampMap =
%%        maps:map(fun({_Zone, Camp}, CampInfo) ->
%%            #camp_info{member_list = OldList, guild_map = GuildMap} = CampInfo,
%%            NewList = lists:sort(fun sort_member/2, OldList),
%%            ServerIds = maps:keys(GuildMap),
%%%%            ?MYLOG("zh_sea", "gm_sync_member_list ServerIds ~p Camp ~p ~n", [ServerIds, Camp]),
%%            sync_local_members(ServerIds, Camp, NewList, 1),
%%            CampInfo#camp_info{member_list = NewList}
%%                 end, CampMap),
%%    State#kf_seacraft_state{camp_map = NewCampMap}.

%% 本地调用执行，该函数由跨服中心统一通知执行(本地定时器也会执行)
%% 更新MemberItem
%% @param CampInfo 阵营信息
%% @param ChangeList 成员信息 / {ChangeList, JoinList, QuitIdList}
%% @return CampInfo
update_member_list(Camp, CampInfo, Tuple) when is_tuple(Tuple) ->
    {ChangeList, JoinList, QuitIdList} = Tuple,
    case util:is_cls() of
        true -> CampInfo;
        _ ->
            #camp_info{member_list = MemberList, job_list = JobList} = CampInfo,
            NewMemberListTmp = update_member_list_do(Camp, MemberList, ChangeList, []),
            F = fun(DeleId, Acc) -> lists:keydelete(DeleId, #camp_member_info.role_id, Acc) end,
            NewMemberListTmp1 = lists:foldl(F, NewMemberListTmp, QuitIdList),
            NewJoinList = joinlist_get_job(JobList, JoinList, JoinList),
            F2 = fun(Item, Acc) ->
                lists:keystore(Item#camp_member_info.role_id, #camp_member_info.role_id, Acc, Item)
                end,
            NewMemberListTmp2 = lists:foldl(F2, NewMemberListTmp1, NewJoinList),
            NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp2),
            CampInfo#camp_info{member_list = NewMemberList}
    end;
update_member_list(Camp, CampInfo, ChangeList) ->
    case util:is_cls() of
        true -> CampInfo;
        _ ->
            #camp_info{member_list = MemberList} = CampInfo,
            NewMemberListTmp = update_member_list_do(Camp, MemberList, ChangeList, []),
            NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp),
            CampInfo#camp_info{member_list = NewMemberList}
    end.

%% 判断新加入的成员是否用升职成官员
joinlist_get_job(_JobList, JoinList, []) -> JoinList;
joinlist_get_job(JobList, JoinList, [T|H]) ->
%%    {SerId, GuildId, GuildName, Vip, RoleId, RoleName, Lv, _, Exploit, CombatPower} = T,
    RoleId = T#camp_member_info.role_id,
    case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
        false -> joinlist_get_job(JobList, JoinList, H);
        #sea_job{role_id = RoleId, job_id = JobId} ->
            NewT = T#camp_member_info{job_id = JobId},
            NewJoinList = lists:keystore(RoleId, #camp_member_info.role_id, JoinList, NewT),
            joinlist_get_job(JobList, NewJoinList, H)
    end .

%% 跨服中心调用执行，该函数由游戏服 定时 发送消息通知执行
%% 更新MemberItem
%% @param ServerId 游戏服Id
%% @param Camp 阵营id
%% @param CampInfo 阵营信息
%% @param ChangeList 成员信息
%% @return CampInfo
update_member_list(ServerId, Camp, CampInfo, ChangeList) ->
    case util:is_cls() of
        false -> CampInfo;
        _ ->
            #camp_info{guild_map = GuildMap, member_list = MemberList} = CampInfo,
            ServerIds = maps:keys(GuildMap),
            %% 对应正上方函数
            %?MYLOG("lzh_sea", "center recive change lists: ~p ~n", [ChangeList]),
            [mod_clusters_center:apply_cast(SId, mod_seacraft_local, update_member_list, [Camp, ChangeList])
                ||SId<-ServerIds, ServerId =/= SId],
            NewMemberListTmp = update_member_list_do(Camp, MemberList, ChangeList, []),
            NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp),
            CampInfo#camp_info{member_list = NewMemberList}
    end.

%% 本地发送更改信息至跨服中心
send_member_to_center(Camp, StartPos, ChangeList) ->
    %?MYLOG("lzh_sea", "game_to_center sync member lists: ~p ~n", [ChangeList]),
    case StartPos > length(ChangeList) of
        true -> skip;
        false ->
            case lists:sublist(ChangeList, StartPos, ?SYNC_SIZE) of
                [] -> skip;
                SubList ->
                    %% 对应正上方函数
                    SerId = config:get_server_id(),
                    mod_kf_seacraft:cast_center([{'update_member_list', SerId, Camp, SubList}]),
                    send_member_to_center(Camp, StartPos + ?SYNC_SIZE, ChangeList)
            end
    end.

%% 游戏服收到同步工会成员变动信
%% @param CampInfo #camp_info{}
%% @param JoinList 新加入工会成员信息
%% @param QuitIdList 退出工会成id
%% @return #camp_info{}
update_member_join_quit(CampInfo, JoinList, QuitIdList) ->
    case util:is_cls() of
        true -> CampInfo;
        _ ->
            #camp_info{member_list = MemberList, job_list = JobList} = CampInfo,
            F = fun(DeleId, Acc) -> lists:keydelete(DeleId, #camp_member_info.role_id, Acc) end,
            NewMemberListTmp1 = lists:foldl(F, MemberList, QuitIdList),
            NewJoinList = joinlist_get_job(JobList, JoinList, JoinList),
            F2 = fun(Item, Acc) ->
                lists:keystore(Item#camp_member_info.role_id, #camp_member_info.role_id, Acc, Item)
                 end,
            NewMemberListTmp2 = lists:foldl(F2, NewMemberListTmp1, NewJoinList),
            NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp2),
            CampInfo#camp_info{member_list = NewMemberList}
    end.

%% 跨服中心收到同步工会成员变动信息
%% center服调用
%% @param ServerId ServerId
%% @param Camp 阵营Id
%% @param CampInfo #camp_info{}
%% @param JoinList 新加入工会成员信息
%% @param QuitIdList 退出工会成id
%% @return #camp_info{}
update_member_join_quit(ServerId, Camp, CampInfo, JoinList, QuitIdList) ->
    case util:is_cls() of
        false -> CampInfo;
        _ ->
            #camp_info{guild_map = GuildMap, member_list = MemberList, job_list = JobList} = CampInfo,
            ServerIds = maps:keys(GuildMap),
            %% 对应正上方函数
            [begin
                 mod_clusters_center:apply_cast(Sid, mod_seacraft_local, update_member_join_quit, [Camp, JoinList, QuitIdList])
             end
                ||Sid<-ServerIds, ServerId =/= Sid],
            F = fun(DeleId, Acc) -> lists:keydelete(DeleId, #camp_member_info.role_id, Acc) end,
            NewMemberListTmp1 = lists:foldl(F, MemberList, QuitIdList),
            NewJoinList = joinlist_get_job(JobList, JoinList, JoinList),
            ReplaceParams = [create_save_member_info_sql(MemberItem, Camp)||MemberItem<-NewJoinList],
            Sql = usql:replace(seacraft_member_info, [zone,camp,server_id,guild_id,vip,role_id,role_name, lv, job_id,exploit,combat_power], ReplaceParams),
            Sql =/= [] andalso db:execute(Sql),
            case QuitIdList of
                [] -> skip;
                _ -> db:execute(usql:delete(seacraft_member_info, {role_id, in, QuitIdList}))
            end,
            F2 = fun(Item, Acc) -> lists:keystore(Item#camp_member_info.role_id, #camp_member_info.role_id, Acc, Item) end,
            NewMemberListTmp2 = lists:foldl(F2, NewMemberListTmp1, NewJoinList),
            NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp2),
            CampInfo#camp_info{member_list = NewMemberList}
    end.

%% 游戏服同步工会成员变动信息
%% 游戏服调用
%% @param Camp 阵营Id
%% @param JoinList 新加入工会成员信息
%% @param QuitIdList 退出工会成id
center_member_join_quit(Camp, JoinList, QuitIdList) ->
    SerId = config:get_server_id(),
    %% 对应正上方函数
    mod_kf_seacraft:cast_center([{'center_member_join_quit', SerId, Camp, JoinList, QuitIdList}]).

%% 同意禁卫军申请
%% 跨服中心调用
%% @param MemberList [{ServerId, GuildId, GuildName, Vip, RId, RName, Lv, ?SEA_MEMBER, Exploit, CombatPower}]
%% @param ApplyList [{SerId, SerNum, Picture, RoleLv, RId, RName, Power}]
%% @param Camp 阵营id
%% @param ServerIds
members_job_change(MemberList, ApplyList, Camp, ServerIds) ->
    RoleIdList = [RId||#sea_apply{role_id = RId}<-ApplyList],
    case util:is_cls() of
        false -> skip;
        _ ->
            [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, update_member_job, [Camp, ?SEA_SOLDIER, RoleIdList])
                ||ServerId<-ServerIds]
    end,
    NewMemberListTmp = update_member_job_do(Camp ,MemberList, ?SEA_SOLDIER, RoleIdList, []),
    lists:sort(fun sort_member/2, NewMemberListTmp).

%% 更新成员job
%% @param Camp 阵营id
%% @param CampInfo 阵营信息
%% @param JobId 职位id
%% @param RoleIdList 用户id 当RoleIdList == []时表示降职位
update_member_job(Camp, CampInfo, JobId, []) ->
    #camp_info{member_list = MemberList} = CampInfo,
    case lists:keyfind(JobId, #camp_member_info.job_id, MemberList) of
        false -> CampInfo;
        #camp_member_info{role_id = RoleId} ->
            update_member_job(Camp, CampInfo, ?SEA_SOLDIER, [RoleId])
    end ;
update_member_job(Camp, CampInfo, JobId, RoleIdList) ->
    #camp_info{member_list = MemberList, guild_map = GuildMap} = CampInfo,
    NewMemberListTmp = update_member_job_do(Camp, MemberList, JobId, RoleIdList, []),
    NewMemberList = lists:sort(fun sort_member/2, NewMemberListTmp),
    case util:is_cls() of
        false -> skip;
        _ ->
            [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, update_member_job, [Camp, JobId, RoleIdList])
                ||ServerId<-maps:keys(GuildMap)]
    end,
    CampInfo#camp_info{member_list = NewMemberList}.

%% 海王转让
%% @param Camp 阵营id
%% @param MemberList
%% @param OldMasterId 旧海王
%% @param MasterId 新海王
%% @return #camp_info{}
change_sea_master(Zone, Camp, MemberList, OldMasterId, MasterId) ->
    NewMemberListTmp1 = update_member_job_do(Camp, MemberList, ?SEA_MEMBER, [OldMasterId], []),
    NewMemberListTmp2 = update_member_job_do(Camp, NewMemberListTmp1, ?SEA_MASTER, [MasterId], []),
    case util:is_cls() of
        false -> skip;
        _ ->
            mod_zone_mgr:apply_cast_to_zone2(1, Zone, mod_seacraft_local, change_sea_master, [Camp, OldMasterId, MasterId])
    end,
    lists:sort(fun sort_member/2, NewMemberListTmp2).

local_change_sea_master(Camp, MemberList, OldMasterId, MasterId) ->
    NewMemberListTmp1 = update_member_job_do(Camp, MemberList, ?SEA_MEMBER, [OldMasterId], []),
    NewMemberListTmp2 = update_member_job_do(Camp, NewMemberListTmp1, ?SEA_MASTER, [MasterId], []),
    lists:sort(fun sort_member/2, NewMemberListTmp2).

%% 选出海王   顺便同步privilegestatus
%% @return MemberList
update_sea_master(Zone, Camp, MemberList, RoleId, OldMasterSerId, PrivilegeStatus) ->
    NewMemberList = case OldMasterSerId == RoleId of
        true -> MemberList;
        _ ->
            %% 更新海王会全部清空职位
            Sql_clear = io_lib:format("update seacraft_member_info set job_id = ~p where zone = ~p and camp = ~p ", [?SEA_MEMBER, Zone, Camp]),
            NewMemberListTmp1 = [MemberItem#camp_member_info{job_id = ?SEA_MEMBER}||MemberItem<-MemberList],
            db:execute(Sql_clear),
            % NewMemberListTmp1 = update_member_job_do(Camp, MemberList, ?SEA_MEMBER, [OldMasterSerId], []),
            NewMemberListTmp2 = update_member_job_do(Camp, NewMemberListTmp1, ?SEA_MASTER, [RoleId], []),
            lists:sort(fun sort_member/2, NewMemberListTmp2)
    end,
    util:is_cls() andalso mod_zone_mgr:apply_cast_to_zone2(1, Zone, mod_seacraft_local, update_sea_master_privilege, [Camp, RoleId, OldMasterSerId, PrivilegeStatus]),
    NewMemberList.

%% 海域信息2.0
%% @param RoleId 角色id
%% @param State local_seacraft_state
get_seacraft_info(RoleId, Camp, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> skip;
        #camp_info{guild_map = GuildMap, job_list = JobList} ->
            {GuildNum, MemberNum, SeaPower} =
                maps:fold(
                    fun(_ServerId, Value, {Acc1, Acc2, Acc3}) ->
                        %% ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, Num, RoleLv, Power, Picture
                        F = fun(#sea_guild{guild_power = GPower, member_num = MNum}, {A1,A2}) -> {A1+GPower,A2+MNum} end,
                        {SGPower, SMNum} = lists:foldl(F, {0,0}, Value),
                        {Acc1 + length(Value), Acc2 + SGPower, Acc3 +SMNum}
                    end
                , {0, 0, 0}, GuildMap),
            #sea_job{role_id = MasterId} = ulists:keyfind(?SEA_MASTER, #sea_job.job_id, JobList, #sea_job{}),
            {ok, BinData} = pt_186:write(18650, [Camp, GuildNum, MemberNum, SeaPower, MasterId]),
            %?PRINT("sea_info :~p ~n", [[Camp, GuildNum, MemberNum, SeaPower, MasterId]]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

%% 特权列表
%% @param RoleId 角色id
%% @param State local_seacraft_state
get_privilege_list(RoleId, Camp, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    ?PRINT("RoleId ~p, Camp ~p ~n", [RoleId, Camp]),
    case maps:get(Camp, CampMap, false) of
        false -> skip;
        #camp_info{privilege_status = PrivilegeStatus} ->
            PriviList = data_seacraft:lists_sea_privilege(),
            SendList =
                [begin
                     #base_sea_privilege{privilege_id = PrId, need_job = NeedJob} = data_seacraft:get_sea_privilege(PriId),
                     PriItem = ulists:keyfind(PrId, #privilege_item.privilege_id, PrivilegeStatus,#privilege_item{privilege_id = PrId}),
                     #privilege_item{times = Times, status = Status, end_time = EndTime} = PriItem,
                     {PrId, Times, Status, EndTime, NeedJob}
                 end||PriId<-PriviList],
            {ok, BinData} = pt_186:write(18651, [SendList]),
            ?PRINT("privilege_info :~p ~n", [SendList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

%% 操作特权
%% @param RoleId 角色id
%% @param Camp 阵营Id
%% @param CampInfo 阵营信息
%% @param PriviId 特权id
%% @param Option 1开启0关闭
option_privilege(State, ServerId, RoleId, Camp, PriviId, Option) ->
    #kf_seacraft_state{camp_map = CampMap} = State,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    case maps:get({Zone, Camp}, CampMap, false) of
        false ->
            State;
        CampInfo ->
            case do_option_privilege(RoleId, {Zone, Camp}, CampInfo, PriviId, Option) of
                {false, Errcode} ->
                    {ok, BinData} = pt_186:write(18652, [Errcode, PriviId, Option, 0]),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send,send_to_uid, [RoleId, BinData]),
                    State;
                {true, NewCampInfo, EndTime} ->
                    ?IF(PriviId == ?PRI_SEA_RETREAT,
                        begin
                            ChatMod = ?IF(Option == ?PRIVILEGE_OPEN, 7, 8),
                            CampName = data_seacraft:get_camp_name(Camp),
                            mod_zone_mgr:apply_cast_to_zone2(1, Zone, lib_chat, send_TV, [{all}, ?MOD_SEACRAFT, ChatMod, [CampName]])
                        end,skip),
                    NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
                    {ok, BinData} = pt_186:write(18652, [?SUCCESS, PriviId, Option, EndTime]),
                    ?PRINT("send ~p ~n", [[?SUCCESS, PriviId, Option, EndTime]]),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send,send_to_uid, [RoleId, BinData]),
                    %%spawn(fun() -> get_privilege_list(RoleId, Camp,State#kf_seacraft_state{camp_map = NewCampMap}) end),
                    State#kf_seacraft_state{camp_map = NewCampMap}
            end
    end.

%% 根据当前功勋值，获取对应的base_sea_exploit
%% @param Exploit 功勋值
get_base_exploit(Exploit) ->
    MilitaryIds = data_seacraft:list_sea_exploits(),
    recursive_exploit(MilitaryIds, Exploit).

recursive_exploit([MilitaryId|H], Exploit) ->
    #base_sea_exploit{need_exploit = NeedExploit} = Res = data_seacraft:get_sea_exploit(MilitaryId),
    [Min, Max] = NeedExploit,
    case Exploit >= Min andalso Exploit =< Max of
        true -> Res;
        false ->
            ?IF(H == [], Res, recursive_exploit(H, Exploit))
    end .

%% 内政界面
%% 游戏服调用
%% @param State local_seacraft_state
%% @param RoleId 角色id
%% @param Camp 阵营
%% @param PageSize 页大小
%% @param PageNum 页码
send_member_info(State, RoleId, Camp, PageSize, PageNum) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> skip;
        #camp_info{member_list = MemberList} ->
            %?PRINT("MemberList ~p ~n", [MemberList]),
            MemberListLen = length(MemberList),
            {PageTotal, StartPos, ThisPageSize} = util:calc_page_cache(MemberListLen, PageSize, PageNum),
            MemberListSub = lists:sublist(MemberList, StartPos, ThisPageSize),
            SendList = [{Vip, RId, RName, Lv, JobId, Exploit, CombatPower, GuildId, GuildName}||
                {_,_ServerId, GuildId, GuildName, Vip, RId, RName, Lv, JobId, Exploit, CombatPower}<-MemberListSub],
            %?PRINT("send_info ~p ~n", [[PageTotal, PageSize, PageNum, SendList]]),
            lib_server_send:send_to_uid(RoleId, pt_186, 18654, [PageTotal, PageSize, PageNum, SendList])
    end.

%% 游戏服同步成员数据
%% @param State local_seacraft_state
%% @param Camp 阵营Id
%% @param MemberList 成员列表
sync_local_members(State, Camp, MemberList) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> State;
        CampInfo ->
            #camp_info{member_list = List} = CampInfo,
            F2 = fun(Item, Acc) ->
                lists:keystore(Item#camp_member_info.role_id, #camp_member_info.role_id, Acc, Item)
                 end,
            AllList = lists:foldl(F2, List, MemberList),
            NewCampInfo = CampInfo#camp_info{member_list = AllList},
            %NewCampInfo = CampInfo#camp_info{member_list = List ++ MemberList},
            NewCampMap = maps:put(Camp, NewCampInfo, CampMap),
            State#local_seacraft_state{local_camp = NewCampMap}
    end.

%% 定时器调用，关闭制定特权
%% 数据实例化，数据同步到游戏服
%% @param State kf_seacraft_state
%% @param ServerIds 需要更新的服务id
%% @param {Zone, Camp} CampInfo的key
%% @param PriviItem 特权项 #privilege_item{}
close_privilege(State, {Zone, Camp}, PriviItem) ->
    #kf_seacraft_state{camp_map = CampMap} = State,
    case maps:get({Zone, Camp}, CampMap, false) of
        false -> State;
        CampInfo ->
            #camp_info{privilege_status = OldPrStatus} = CampInfo,
            PriviId = PriviItem#privilege_item.privilege_id,
            NewPrStatus = change_privilege_status({Zone, Camp}, PriviItem, OldPrStatus),
            NewCampInfo = CampInfo#camp_info{privilege_status = NewPrStatus},
            NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
            ?IF(PriviId == ?PRI_SEA_RETREAT,
                begin
                    CampName = data_seacraft:get_camp_name(Camp),
                    mod_zone_mgr:apply_cast_to_zone2(1, Zone, lib_chat, send_TV, [{all}, ?MOD_SEACRAFT, 8, [CampName]])
                end,skip),
            State#kf_seacraft_state{camp_map = NewCampMap}
    end.

%%======================== 内部函数 ========================
%% 操作特权核心
do_option_privilege(RoleId, {Zone, Camp}, CampInfo, PriviId, Option) ->
    #camp_info{privilege_status = PrivilegeStatusTmp, job_list = JobList} = CampInfo,
    PrivilegeStatus = ?IF(PrivilegeStatusTmp == [], init_privilege_status(Zone, Camp), PrivilegeStatusTmp),
    case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
        false -> {false, ?ERRCODE(err186_no_privilege)};
        #sea_job{server_id = ServerId, role_id = RoleId, role_name = RoleName, job_id = JobId} ->
            case data_seacraft:get_sea_privilege(PriviId) of
                #base_sea_privilege{need_job = NeedJob, duration = Duration} ->
                    InJob = lists:member(JobId, NeedJob),
                    #privilege_item{
                        times = Times,
                        status = Status,
                        ref = Ref} = ulists:keyfind(PriviId, #privilege_item.privilege_id, PrivilegeStatus, #privilege_item{privilege_id = PriviId}),
                    if
                        InJob == false -> {false, ?ERRCODE(err186_no_privilege)};
                        Status == Option -> {false, ?ERRCODE(err186_had_option)};
                        Times =< 0 andalso Option == ?PRIVILEGE_OPEN -> {false, ?ERRCODE(err186_no_times)};
                        true ->
                            Now = utime:unixtime(),
                            {NewRef, NewTimes, EndTime} =
                                case Option == ?PRIVILEGE_CLOSE of
                                    true -> {undefined, Times, 0};
                                    false ->
                                        NextPrItem = make_record(privilege_item, {PriviId, Times - 1, ?PRIVILEGE_CLOSE, 0, undefined}),
                                        Msg = {'close_privilege', {Zone, Camp}, NextPrItem},
                                        NRef = util:send_after(Ref, Duration*1000, self(), Msg),
                                        {NRef, Times - 1, Now+Duration}
                                end,
                            NewPviItem = make_record(privilege_item, {PriviId, NewTimes, Option, EndTime, NewRef}),
                            NewPrivilegeStatus = change_privilege_status({Zone, Camp}, NewPviItem, PrivilegeStatus),
                            lib_log_api:log_seacraft_privilege_option(Zone, Camp, ServerId, RoleId, RoleName,PriviId, Option, NewTimes,EndTime),
                            {true, CampInfo#camp_info{privilege_status = NewPrivilegeStatus}, EndTime}
                    end;
                _ -> {false, ?FAIL}
            end
    end.

%% 修改特权状态
%% 修改且同步PrivilegeStatus，数据实例化
%% @param ServerIds 需要更新的服id
%% @param Camp 阵营id
%% @param PriviItem {privilege_id, times, status, end_time, ref}
%% @param PrivilegeStatus 旧状态
%% @return NewPrivilegeStatus
change_privilege_status({Zone, Camp}, PriviItem, PrivilegeStatus) ->
    #privilege_item{privilege_id = CPriviId, times = Times, status = Status, end_time = EndTime} = PriviItem,
    Sql = io_lib:format(?REPLACE_PRIVILEGE_ITEM, [Zone, Camp, CPriviId, Times, Status, EndTime]),
    db:execute(Sql),
    %% 发送到游戏服无需定时器
    ToGameItem = PriviItem#privilege_item{ref = undefined},
    mod_zone_mgr:apply_cast_to_zone2(1, Zone, mod_seacraft_local, center_option_privilege, [Camp, ToGameItem]),
    % [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, center_option_privilege, [Camp, ToGameItem])||ServerId<-ServerIds],
    lists:keystore(CPriviId, #privilege_item.privilege_id, PrivilegeStatus, PriviItem).

update_member_list_do(_Camp, MemberList, [], GrandParams) ->
    Sql = usql:replace(seacraft_member_info, [zone,camp,server_id,guild_id,vip,role_id,role_name, lv, job_id,exploit,combat_power], GrandParams),
    Sql =/= [] andalso util:is_cls() andalso db:execute(Sql),
    MemberList;
update_member_list_do(Camp, MemberList, [{Vip, RoleId, RName, Lv, Exploit, CombatPower}|T], GrandParams) ->
    case lists:keyfind(RoleId, #camp_member_info.role_id, MemberList) of
        false -> update_member_list_do(Camp, MemberList, T, GrandParams);
        CampMemberInfo->
            NewItem = CampMemberInfo#camp_member_info{vip = Vip, role_name = RName, lv = Lv, exploit = Exploit, fright = CombatPower},
            NewGrandParams = ?IF(util:is_cls(), [create_save_member_info_sql(NewItem, Camp)|GrandParams], GrandParams),
            NextMemberList = lists:keystore(RoleId, #camp_member_info.role_id, MemberList, NewItem),
            update_member_list_do(Camp, NextMemberList, T, NewGrandParams)
    end;
update_member_list_do(Camp, MemberList, [H|T], GrandParams) when is_record(H, camp_member_info) ->
    NextMemberList = lists:keystore(H#camp_member_info.role_id, #camp_member_info.role_id, MemberList, H),
    update_member_list_do(Camp, NextMemberList, T, GrandParams);
update_member_list_do(Camp, MemberList, [_|T], GrandParams) -> update_member_list_do(Camp, MemberList, T, GrandParams).

%% MemberList [#camp_member_info{}|_]
update_member_job_do(_Camp, MemberList, _JobId, [], GrandParams) ->
    Sql = usql:replace(seacraft_member_info, [zone,camp,server_id,guild_id,vip,role_id,role_name, lv, job_id,exploit,combat_power], GrandParams),
    Sql =/= [] andalso util:is_cls() andalso db:execute(Sql),
    MemberList;
update_member_job_do(Camp, MemberList, JobId, [H|T], GrandParams) ->
    case lists:keyfind(H, #camp_member_info.role_id, MemberList) of
        false -> update_member_job_do(Camp, MemberList, JobId, T, GrandParams);
        MemberItem ->
            NewMemberItem = MemberItem#camp_member_info{job_id = JobId},
            NewGrandParams = ?IF(util:is_cls(), [create_save_member_info_sql(NewMemberItem, Camp)|GrandParams], GrandParams),
            update_member_job_do(Camp, lists:keystore(H, #camp_member_info.role_id, MemberList, NewMemberItem), JobId, T, NewGrandParams)
    end.

%% 保存特权状态
db_save_privilege_item(Zone, Camp, PrivilegeItem) ->
    #privilege_item{
        privilege_id = PrivilegeId,
        times = Times,
        status = Status,
        end_time = EndTime
    } = PrivilegeItem,
    %?MYLOG("zh_sea_init", "db save prvi ~p ~n", [[Zone, Camp,PrivilegeId, Times, Status, EndTime]]),
    db:execute(io_lib:format(?REPLACE_PRIVILEGE_ITEM, [Zone, Camp,PrivilegeId, Times, Status, EndTime])).

%% 同步阵营member_list信息
%% 跨服中心调用
sync_local_members(ServerIds, Camp, MemberList, StartPos) ->
    case length(MemberList) < StartPos of
        true -> skip;
        false ->
            case lists:sublist(MemberList, StartPos, ?SYNC_SIZE) of
                [] -> skip;
                SendList ->
                    [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, sync_local_members, [Camp, SendList])
                        ||ServerId <- ServerIds],
                    sync_local_members(ServerIds, Camp, MemberList, StartPos + ?SYNC_SIZE)
            end
    end .

%% 排序海域成员信息
sort_member(Member1, Member2) ->
    #camp_member_info{
        vip = Vip1, lv = Lv1, job_id = JobId1,
        exploit = Exploit1, fright = CombatPower1
    } = Member1,
    #camp_member_info{
        vip = Vip2, lv = Lv2, job_id = JobId2,
        exploit = Exploit2, fright = CombatPower2
    } = Member2,
    if
        JobId1 < JobId2 -> true;
        JobId1 == JobId2 andalso CombatPower1 > CombatPower2 -> true;
        JobId1 == JobId2 andalso CombatPower1 == CombatPower2 andalso Exploit1 > Exploit2 -> true;
        JobId1 == JobId2 andalso CombatPower1 == CombatPower2 andalso Exploit1 == Exploit2 andalso Vip1 > Vip2 -> true;
        JobId1 == JobId2 andalso CombatPower1 == CombatPower2 andalso Exploit1 == Exploit2 andalso Vip1 == Vip2 andalso Lv1 > Lv2 -> true;
        true -> false
    end.

create_save_member_info_sql(CampMemberInfo, Camp) when is_record(CampMemberInfo, camp_member_info) ->
    case util:is_cls() of
        false -> [];
        true ->
            #camp_member_info{
                server_id = ServerId, guild_id = GuildId, vip = Vip, role_id = RoleId,
                role_name = RName, lv = Lv, job_id = JobId, exploit = Exploit, fright = CombatPower
            } = CampMemberInfo,
            Zone = lib_clusters_center_api:get_zone(ServerId),
            [Zone, Camp, ServerId, GuildId, Vip, RoleId,RName,Lv,JobId, Exploit,CombatPower]
    end .