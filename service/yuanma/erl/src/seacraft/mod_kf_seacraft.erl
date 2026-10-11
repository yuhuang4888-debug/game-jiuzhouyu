%%%-----------------------------------
%%% @Module      : mod_kf_seacraft 怒海争霸
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2020
%%% @Description : 怒海争霸进程
%%%-----------------------------------
-module(mod_kf_seacraft).

-behaviour(gen_server).


-include("common.hrl").
-include("seacraft.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
    init_after/3
    ,local_init/1
    ,zone_change/3
    ,center_connected/5
    ,enter_scene/13
    ,mon_be_hurt/11
    ,mon_be_kill/9
    ,mon_be_revive/6
    ,four_clock/0
    ,reconnect/6
    ,set_join_limit/7
    ,apply_to_join/9
    ,agree_join_apply/6
    ,handle_job/6
    ,divide_win_reward/9
    ,join_camp/13
    ,join_camp/1
    ,exit_camp/4
    ,kill_player/10
    ,gm_start_act/3
    ,gm_end_act/0
    ,update_role_info/2
    ,change_guild_info/3
    ,exit_guild/4
    ,auto_join_camp/1
    ,auto_join_add_member/5
    ,after_exit_camp/3
    ,gm_sync_member_list/0
    ,option_privilege/5
    ,gm_repair_data/0
    ,gm_flush_member_info/1
    ,gm_flush_sync_members/5
    ,gm_reset_act/0
    ,gm_refresh_data/0
    ,gm_remove_act_dsgt/1
]).



-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).

%%=========================================================================
%% 接口函数
%%=========================================================================
%%本地->跨服中心
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

% join_a_camp(ServerId, Camp) ->

%% 运营使用的秘籍
%% 由于海域第二版和第一版数据有不同步
%% 需要在第二版更新的版本在跨服中心调用该秘籍
%% @params TimeStamp 版本更新的时间
gm_flush_member_info(TimeStamp) ->
    ZoneBases = mod_zone_mgr:get_all_zone(),
    F = fun(ZoneBase, Acc) ->
            {zone_base, _,ZoneId,OpenTime,_,_,_,_,_} = ZoneBase,
            OpenDay = (TimeStamp - OpenTime) div (3600 * 24),
            case OpenDay >= data_seacraft:get_value(open_day) of
                true -> maps:put(ZoneId, 1, Acc);
                _ -> Acc
            end
        end,
    %% 需要更新成员数据的的ZoneId
    NeedFlushZoneIds = maps:keys(lists:foldl(F, #{}, ZoneBases)),
    [begin
         timer:sleep(50),
         mod_zone_mgr:apply_cast_to_zone2(1, ZoneId, mod_guild, gm_flush_member_info, [])
     end||ZoneId <- NeedFlushZoneIds].

%% 上方函数执行，游戏服工会进程回调于此
gm_flush_sync_members(ServerId, Camp, GuildId, GuildName, MemberInfos) ->
    cast_center([{'gm_flush_sync_members', ServerId, Camp, GuildId, GuildName, MemberInfos}]).

enter_scene(ServerNum, ServerId, GuildId, GuildName, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Scene, NeedOut, Camp) ->
    cast_center([{'enter_scene', ServerNum, ServerId, GuildId, GuildName, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Scene, NeedOut, Camp}]).

mon_be_revive(ServerId, ServerNum, Scene, Monid, RoleId, RoleName) ->
    cast_center([{'mon_be_revive', ServerId, ServerNum, Scene, Monid, RoleId, RoleName}]).

local_init(ServerInfo) ->
    cast_center([{'local_init', ServerInfo}]).

reconnect(ServerId, GuildId, Scene, Camp, RoleId, ReloginKV) ->
    cast_center([{'reconnect', ServerId, GuildId, Scene, Camp, RoleId, ReloginKV}]).

%% 职位审批设置
set_join_limit(ServerId, GuildId, Camp, RoleId, LimitLv, LimitPower, Auto) ->
    cast_center([{'set_join_limit', ServerId, GuildId, Camp, RoleId, LimitLv, LimitPower, Auto}]).

%% 申请加入海军禁卫
apply_to_join(Camp, ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power) ->
    cast_center([{'apply_to_join', Camp, ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power}]).

%% 处理禁卫申请
agree_join_apply(ServerId, GuildId, Camp, RoleId, Agree, RId) ->
    cast_center([{'agree_join_apply', ServerId, GuildId, Camp, RoleId, Agree, RId}]).

%% 职位管理
handle_job(ServerId, GuildId, Camp, RoleId, JobId, RoleIdList) ->
    cast_center([{'handle_job', ServerId, GuildId, Camp, RoleId, JobId, RoleIdList}]).

%% 连胜分配
divide_win_reward(ServerId, GuildId, GuildName, Camp, RoleId, RoleName, SerId, RId, Times) ->
    cast_center([{'divide_win_reward', ServerId, GuildId, GuildName, Camp, RoleId, RoleName, SerId, RId, Times}]).

join_camp(ServerId, ServerNum,GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer) ->
    cast_center([{'join_camp', ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer}]).

join_camp(Args) ->
    cast_center([{'join_camp', Args}]).

exit_camp(ServerId, GuildId, RoleId, Camp) ->
    cast_center([{'exit_camp', ServerId, GuildId, RoleId, Camp}]).

exit_guild(ServerId, RoleIdIdList, Camp, InfoList) ->
    cast_center([{'exit_guild', ServerId, RoleIdIdList, Camp, InfoList}]).
% {delete, GuildId} {name, GuildId, GuildName} {power, GuildId, Power} {cheif, GuildId, RoleId, RoleName, lv, power,picture} {num, GuildId, Num}
change_guild_info(ServerId, Camp, InfoList) ->
    cast_center([{'change_guild_info', ServerId, Camp, InfoList}]).

gm_start_act(ServerId, ActType, Time) ->
    cast_center([{'gm_start_act', ServerId, ActType, Time}]).

update_role_info(ServerId, RoleInfo) ->
    cast_center([{'update_role_info', ServerId, RoleInfo}]).

kill_player(SceneId, CopyId, DieId, DieName, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName, HitIdList) ->
    cast_center([{'kill_player', SceneId, CopyId, DieId, DieName, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName, HitIdList}]).

auto_join_camp(List) ->
    cast_center([{'auto_join_camp', List}]).

%% 上放函数游戏服回调
auto_join_add_member(ServerId, Realm, GuildId, GuildName, AllMemberInfos) ->
    cast_center([{'auto_join_add_member', ServerId, Realm, GuildId, GuildName, AllMemberInfos}]).

after_exit_camp(ServerId, Camp, GuildId) ->
    cast_center([{'after_exit_camp', ServerId, Camp, GuildId}]).

gm_end_act() ->
    cast_center([{'gm_end_act'}]).

option_privilege(ServerId, RoleId, Camp, PriviId, Option) ->
    cast_center([{'option_privilege', ServerId, RoleId, Camp, PriviId, Option}]).

gm_sync_member_list() ->
    mod_clusters_node:apply_cast(?MODULE, gm_flush_member_info, [1582955774]).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

init_after(ServerInfo, ZoneMap, Type) ->
    gen_server:cast(?MODULE, {'init_after', ZoneMap, ServerInfo, Type}).

zone_change(ServerId, OldZone, NewZone) ->
    if
        OldZone =/= NewZone ->
            gen_server:cast(?MODULE, {'zone_change', ServerId, OldZone, NewZone});
        true ->
            skip
    end.

four_clock() ->
    gen_server:cast(?MODULE, {'four_clock'}).

center_connected(ServerId, OpTime, ServerNum, ServerName, MergeSerIds) ->
    gen_server:cast(?MODULE, {'center_connected', ServerId, OpTime, ServerNum, ServerName, MergeSerIds}).

mon_be_hurt(Scene, PoolId, CopyId, AtterServerNum, AtterServerId, AtterGuildId, Monid, AtterRoleId, AtterName, Hurt, Hp) ->
    gen_server:cast(?MODULE, {'mon_be_hurt', Scene, PoolId, CopyId, AtterServerNum, AtterServerId, AtterGuildId,
        Monid, AtterRoleId, AtterName, Hurt, Hp}).

mon_be_kill(Scene, PoolId, CopyId, Monid, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName) ->
    gen_server:cast(?MODULE, {'mon_be_kill', Scene, PoolId, CopyId, Monid, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName}).

gm_repair_data() ->
    gen_server:cast(?MODULE, {'gm_repair_data'}).

gm_reset_act() ->
    gen_server:cast(?MODULE, {'gm_reset_act'}).

gm_refresh_data() ->
    gen_server:cast(?MODULE, {'gm_refresh_data'}).

gm_remove_act_dsgt(ServerId) ->
    cast_center([{'gm_remove_act_dsgt', ServerId}]).
%%=========================================================================
%% 回调函数
%%=========================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_seacraft_mod:init(),
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'gm_flush_sync_members', ServerId, Camp, GuildId, GuildName, MemberInfos}, State) ->
    #kf_seacraft_state{camp_map = CampMap} = State,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    case maps:get({Zone, Camp}, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            #camp_info{member_list = MemberList, job_list = JobList} = CampInfo,
            GMInfos = [
                begin
                    #sea_job{job_id = JobId} = ulists:keyfind(RId, #sea_job.role_id, JobList, #sea_job{job_id = ?SEA_MEMBER}),
                    Sql = io_lib:format(?REPLACE_SEA_MEMBER_INFO, [Zone, Camp, ServerId, GuildId, Vip, RId,RName,Lv,JobId,Exploit,CombatPower]),
                    db:execute(Sql),
                    lib_seacraft_extra:make_record(camp_member_info, {ServerId, GuildId, GuildName, Vip, RId, RName, Lv, JobId, Exploit, CombatPower})
                end||{RId, Vip, Lv, RName, Exploit, CombatPower} <- MemberInfos],
            mod_zone_mgr:apply_cast_to_zone(1, Zone, mod_seacraft_local, sync_after_join_member,[Camp, GMInfos]),
            F = fun(AddItem, Acc) ->
                lists:keystore(AddItem#camp_member_info.role_id, #camp_member_info.role_id, Acc, AddItem)
                end,
            NewMemberListTmp = lists:foldl(F, MemberList, MemberInfos),
            NewMemberList = lists:sort(fun lib_seacraft_extra:sort_member/2, NewMemberListTmp),
            NewCampInfo = CampInfo#camp_info{member_list = NewMemberList},
            NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
            {noreply, State#kf_seacraft_state{camp_map = NewCampMap}}
    end;

do_handle_cast({'init_after', ZoneMap, ServerInfo, Type}, State) ->
    NewState = lib_seacraft_mod:init_after(State, ZoneMap, ServerInfo, Type),
    {noreply, NewState};

do_handle_cast({'zone_change', ServerId, OldZone, NewZone}, State) ->
    NewState = lib_seacraft_mod:zone_change(State, ServerId, OldZone, NewZone),
    {noreply, NewState};

do_handle_cast({'center_connected', ServerId, OpTime, ServerNum, ServerName, MergeSerIds}, State) ->
    NewState = lib_seacraft_mod:center_connected(State, ServerId, OpTime, ServerNum, ServerName, MergeSerIds),
    {noreply, NewState};

do_handle_cast({'local_init', ServerInfo}, State) when is_tuple(ServerInfo) ->
    NewState = lib_seacraft_mod:local_init(State, ServerInfo),
    {noreply, NewState};


do_handle_cast({'enter_scene', ServerNum, ServerId, GuildId, GuildName, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Scene, NeedOut, Camp}, State) ->
    NewState = lib_seacraft_mod:enter_scene(State, ServerNum, ServerId, GuildId, GuildName, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Scene, NeedOut, Camp),
    {noreply, NewState};

do_handle_cast({'mon_be_hurt', Scene, PoolId, CopyId, AtterServerNum, AtterServerId, AtterGuildId,
    Monid, AtterRoleId, AtterName, Hurt, Hp}, State) ->
    NewState = lib_seacraft_mod:mon_be_hurt(State, Scene, PoolId, CopyId, AtterServerNum, AtterServerId, AtterGuildId, Monid,
        AtterRoleId, AtterName, Hurt, Hp),
    {noreply, NewState};

do_handle_cast({'mon_be_kill', Scene, PoolId, CopyId, Monid, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName}, State) ->
    NewState = lib_seacraft_mod:mon_be_kill(State, Scene, PoolId, CopyId, Monid, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName),
    {noreply, NewState};

do_handle_cast({'four_clock'}, State) ->
    NewState = lib_seacraft_mod:four_clock(State),
    %%NewState = lib_seacraft_extra:sync_sort_members(NewStateTmp),
    {noreply, NewState};

do_handle_cast({'mon_be_revive', ServerId, ServerNum, Scene, Monid, RoleId, RoleName}, State) ->
    NewState = lib_seacraft_mod:mon_be_revive(State, ServerId, ServerNum, Scene, Monid, RoleId, RoleName),
    {noreply, NewState};

do_handle_cast({'reconnect', ServerId, GuildId, Scene, Camp, RoleId, ReloginKV}, State) ->
    NewState = lib_seacraft_mod:reconnect(State, ServerId, GuildId, Scene, Camp, RoleId, ReloginKV),
    {noreply, NewState};

do_handle_cast({'set_join_limit', ServerId, GuildId, Camp, RoleId, LimitLv, LimitPower, Auto}, State) ->
    NewState = lib_seacraft_mod:set_join_limit(State, ServerId, GuildId, Camp, RoleId, LimitLv, LimitPower, Auto),
    {noreply, NewState};

do_handle_cast({'apply_to_join', Camp, ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power}, State) ->
    NewState = lib_seacraft_mod:apply_to_join(State, Camp, ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power),
    {noreply, NewState};

do_handle_cast({'agree_join_apply', ServerId, GuildId, Camp, RoleId, Agree, RId}, State) ->
    NewState = lib_seacraft_mod:agree_join_apply(State, ServerId, GuildId, Camp, RoleId, Agree, RId),
    {noreply, NewState};

do_handle_cast({'handle_job', ServerId, GuildId, Camp, RoleId, JobId, RoleIdList}, State) ->
    NewState = lib_seacraft_mod:handle_job(State, ServerId, GuildId, Camp, RoleId, JobId, RoleIdList),
    {noreply, NewState};

do_handle_cast({'kill_player', SceneId, CopyId, DieId, DieName, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName, HitIdList}, State) ->
    NewState = lib_seacraft_mod:kill_player(State, SceneId, CopyId, DieId, DieName, AttrServerId, AttrServerNum, AttGuildId, AttrRoleId, AttrName, HitIdList),
    {noreply, NewState};

do_handle_cast({'divide_win_reward', ServerId, GuildId, GuildName, Camp, RoleId, RoleName, SerId, RId, Times}, State) ->
    NewState = lib_seacraft_mod:divide_win_reward(State, ServerId, GuildId, GuildName, Camp, RoleId, RoleName, SerId, RId, Times),
    {noreply, NewState};

do_handle_cast({'join_camp', ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer}, State) ->
    NewState = lib_seacraft_mod:join_camp(State, ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer),
    {noreply, NewState};

do_handle_cast({'join_camp', Args}, State) ->
    NewState = lib_seacraft_extra:join_camp(State, Args),
    {noreply, NewState};

do_handle_cast({'exit_camp', ServerId, GuildId, RoleId, Camp}, State) ->
    NewState = lib_seacraft_mod:exit_camp(State, ServerId, GuildId, RoleId, Camp),
    {noreply, NewState};

do_handle_cast({'gm_start_act', ServerId, ActType, Time}, State) ->
    NewState = lib_seacraft_mod:gm_start_act(State, ServerId, ActType, Time),
    {noreply, NewState};

do_handle_cast({'exit_guild', ServerId, RoleIdIdList, Camp, InfoList}, State) ->
    NewState = lib_seacraft_mod:exit_guild(State, ServerId, RoleIdIdList, Camp, InfoList),
    {noreply, NewState};

do_handle_cast({'change_guild_info', ServerId, Camp, InfoList}, State) ->
    NewState = lib_seacraft_mod:change_guild_info(State, ServerId, Camp, InfoList),
    {noreply, NewState};

do_handle_cast({'update_role_info', ServerId, RoleInfo}, State) ->
    NewState = lib_seacraft_mod:update_role_info(State, ServerId, RoleInfo),
    {noreply, NewState};

do_handle_cast({'gm_end_act'}, State) ->
    NewState = lib_seacraft_mod:act_end(State),
    {noreply, NewState#kf_seacraft_state{start_time = 0, end_time = 0}};

do_handle_cast({'auto_join_camp', List}, State) ->
    NewState = lib_seacraft_mod:auto_join_camp(State, List),
    {noreply, NewState};

do_handle_cast({'gm_repair_data'}, State) ->
    NewState = lib_seacraft_mod:gm_repair_data(State),
    {noreply, NewState};

do_handle_cast({'auto_join_add_member', ServerId, Camp, GuildId, GuildName, AllMemberInfos}, State) ->
    #kf_seacraft_state{camp_map = CampMap} = State,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    case maps:get({Zone, Camp}, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            NewCampInfo = lib_seacraft_extra:auto_join_add_member(CampInfo, Zone, ServerId,Camp, GuildId, GuildName, AllMemberInfos),
            NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
            {noreply, State#kf_seacraft_state{camp_map = NewCampMap}}
    end;

do_handle_cast({'after_exit_camp', ServerId, Camp, GuildId}, State) ->
    #kf_seacraft_state{camp_map = CampMap} = State,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    case maps:get({Zone, Camp}, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            NewCampInfo = lib_seacraft_extra:after_exit_camp(CampInfo, Zone, ServerId,Camp, GuildId),
            NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
            {noreply, State#kf_seacraft_state{camp_map = NewCampMap}}
    end;

do_handle_cast(gm_sync_member_list, State) ->
    NewState = lib_seacraft_extra:gm_sync_member_list(State),
    {noreply, NewState};

do_handle_cast({'update_member_list', ServerId, Camp, ChangeList}, State) ->
    #kf_seacraft_state{camp_map = CampMap} = State,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    case maps:get({Zone, Camp}, CampMap, false) of
        false ->{noreply, State};
        CampInfo ->
            NewCampInfo = lib_seacraft_extra:update_member_list(ServerId, Camp, CampInfo,ChangeList),
            NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
            {noreply, State#kf_seacraft_state{camp_map = NewCampMap}}
    end;

do_handle_cast({'center_member_join_quit', ServerId, Camp, JoinList, QuitIdList}, State) ->
    #kf_seacraft_state{camp_map = CampMap} = State,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    case maps:get({Zone, Camp}, CampMap, false) of
        false ->{noreply, State};
        CampInfo ->
            NewCampInfo = lib_seacraft_extra:update_member_join_quit(ServerId, Camp, CampInfo, JoinList, QuitIdList),
            NewCampMap = maps:put({Zone, Camp}, NewCampInfo, CampMap),
            {noreply, State#kf_seacraft_state{camp_map = NewCampMap}}
    end;

do_handle_cast({'option_privilege', ServerId, RoleId, Camp, PriviId, Option}, State) ->
    NewState = lib_seacraft_extra:option_privilege(State, ServerId, RoleId, Camp, PriviId, Option),
    {noreply, NewState};

do_handle_cast({'gm_reset_act'}, State) ->
    NewState = lib_seacraft_mod:gm_reset_act(State),
    {noreply, NewState};

do_handle_cast({'gm_refresh_data'}, _State) ->
    NewState = lib_seacraft_mod:gm_init(),
    {noreply, NewState};

do_handle_cast({'gm_remove_act_dsgt', ServerId}, State) ->
    NewState = lib_seacraft_mod:gm_remove_act_dsgt(State, ServerId),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info({'divide_battle'}, State) ->
    NewState = lib_seacraft_mod:divide_battle(State),
    {noreply, NewState};

do_handle_info({'act_start'}, State) ->
    NewState = lib_seacraft_mod:act_start(State),
    {noreply, NewState};

do_handle_info({'act_end'}, State) ->
    NewState = lib_seacraft_mod:act_end(State),
    {noreply, NewState};

do_handle_info({'close_privilege', {Zone, Camp}, PriviItem}, State) ->
    NewState = lib_seacraft_extra:close_privilege(State, {Zone, Camp}, PriviItem),
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    {noreply, State}.