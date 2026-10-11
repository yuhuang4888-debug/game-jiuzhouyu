%%%-----------------------------------
%%% @Module      : mod_seacraft_local
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2020
%%% @Description : 怒海争霸本服数据管理进程
%%%-----------------------------------
-module(mod_seacraft_local).

-behaviour(gen_server).

-include("common.hrl").
-include("def_fun.hrl").
-include("seacraft.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("server.hrl").
-include("attr.hrl").
-include("guild.hrl").
-include("predefine.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        local_init/5
        ,update_local_info/1
        ,update_local_zone_data/1
        ,update_cluster_guild_info/4
        ,update_cluster_role_info/4
        ,judge_is_in_act_time/0
        ,judge_can_disband/1
        ,exit_guild/4
        ,change_guild_info/3
    ]).

-export([
        get_main_show_info/4
        ,get_divide_point/3
        ,get_job_show/4
        ,get_apply_list/4
        ,get_apply_limit/4
        ,get_act_time/3
        ,get_camp_guild_list/2
        ,get_camp_mon_list/2
        ,get_score_info/2
        ,get_sea_master_info/1
        ,get_att_def_list/2
        ,get_camp_info/1
        ,recieve_daily_reward/6
        ,update_role_info/7
        ,change_role_group/6
        ,get_next_act_time/1
        ,day_opration/1
        ,reset_act/0
        ,get_join_camp_end_time/1
        ,day_trigger/0
        ,enter_daily/8
        ,get_sea_daily_rank/5
        ,get_sea_daily_all_rank/5
        ,get_old_job_id/1
        ,gm_send_reward/1
        ,send_msg_to_sea/4      %% 海域频道发送消息
        ,send_member_info/3     %% 海域内政获取成员信息
        ,sync_local_members/2   %% 同步成员信息
        ,update_member_job/3    %% 更新成员职位信息
        ,update_sea_master_privilege/4
        ,change_sea_master/3    %% 海王转让
        ,update_member_list/2   %% 更新成员信息
        ,update_member_join_quit/3
        ,member_join_guild/2    %% 加入工会
        ,member_quit_guild/2    %% 退出工会
        ,get_seacraft_info/1    %% 获取海域信息
        ,get_privilege_list/1   %% 获取海域特权信息
        ,center_option_privilege/2  %% 跨服中心同步特权信息
        ,update_member_item/2   %% 成员事件触发
        ,get_power_distribution/1   %%获取势力分布情况
        ,get_change_info/1
        ,role_die_handle/3      %% 玩家日常场景死亡处理
        ,get_sea_guild_msg/1    %% 获取公会统治信息
        ,sync_after_join_member/2 %% 第一轮争霸后加入工会成员信息同步处理
        ,exit_camp/3            %% 退出工会
        ,center_flush_privilege/2   %% 4点定时器同步特权
        ,async_set_sea_brick_num/2  %% 异步设置砖块数量
        ,update_brick_num/2  %% 同步砖块数量
        ,gm_reload/0
    ]).


get_sea_guild_msg(RoleId) ->
    gen_server:cast(?MODULE, {'get_sea_guild_msg', RoleId}).

exit_guild(ServerId, RoleIdIdList, Camp, InfoList) ->
    if
        Camp == 0 ->
            skip;
        true ->
            gen_server:cast(?MODULE, {'exit_guild', ServerId, RoleIdIdList, Camp, InfoList})
    end.

% {delete, GuildId} {name, GuildId, GuildName} {power, GuildId, Power} {cheif, GuildId, RoleId, RoleName, rolelv, power, picture} {num, GuildId, Num}
change_guild_info(ServerId, Camp, InfoList) ->
    if
        Camp == 0 ->
            skip;
        true ->
            gen_server:cast(?MODULE, {'change_guild_info', ServerId, Camp, InfoList})
    end.

update_role_info(Camp, RoleId, RoleName, RoleLv, Power, Picture, PictureVer) ->
    if
        Camp == 0 ->
            skip;
        true ->
            gen_server:cast(?MODULE, {'update_role_info', Camp, RoleId, RoleName, RoleLv, Power, Picture, PictureVer})
    end.

local_init(LocalCampMap, LocalZoneData, StartTime, EndTime, Act) ->
    gen_server:cast(?MODULE, {'local_init', LocalCampMap, LocalZoneData, StartTime, EndTime, Act}).

update_local_info(List) ->
    gen_server:cast(?MODULE, {'update_local_info', List}).

update_local_zone_data(List) ->
    gen_server:cast(?MODULE, {'update_local_zone_data', List}).

get_main_show_info(ServerId, GuildId, Camp, RoleId) ->
    gen_server:cast(?MODULE, {'get_main_show_info', ServerId, GuildId, Camp, RoleId}).

get_divide_point(Scene, Camp, GuildId) ->
    gen_server:call(?MODULE, {'get_divide_point', Scene, Camp, GuildId}, 1000).

%% 职位信息
get_job_show(ServerId, GuildId, Camp, RoleId) ->
    gen_server:cast(?MODULE, {'get_job_show', ServerId, GuildId, Camp, RoleId}).

%% 查看禁卫申请
get_apply_list(Camp, GuildId, ServerId, RoleId) ->
    gen_server:cast(?MODULE, {'get_apply_list', Camp, GuildId, ServerId, RoleId}).

get_apply_limit(Camp, GuildId, ServerId, RoleId) ->
    gen_server:cast(?MODULE, {'get_apply_limit', Camp, GuildId, ServerId, RoleId}).

%% 获取海域争夺开启时间
get_act_time(RoleId, Camp, GuildId) ->
    gen_server:cast(?MODULE, {'get_act_time', RoleId, Camp, GuildId}).

%% 海域争夺公会列表
get_camp_guild_list(RoleId, Camp) ->
    gen_server:cast(?MODULE, {'get_camp_guild_list', RoleId, Camp}).

%% 怪物数据（海战场景内）
get_camp_mon_list(RoleId, Camp) ->
    gen_server:cast(?MODULE, {'get_camp_mon_list', RoleId, Camp}).

%% 战场统计信息，积分信息
get_score_info(RoleId, Camp) ->
    gen_server:cast(?MODULE, {'get_score_info', RoleId, Camp}).

%% 海域霸主信息
get_sea_master_info(RoleId) ->
    gen_server:cast(?MODULE, {'get_sea_master_info', RoleId}).

get_att_def_list(Camp, RoleId) ->
    gen_server:cast(?MODULE, {'get_att_def_list', Camp, RoleId}).

get_camp_info(RoleId) ->
    gen_server:cast(?MODULE, {'get_camp_info', RoleId}).

recieve_daily_reward(ServerId, GuildId, GuildName, RoleId, RoleName, Camp) ->
    gen_server:cast(?MODULE, {'recieve_daily_reward', ServerId, GuildId, GuildName, RoleId, RoleName, Camp}).

update_cluster_guild_info(ServerId, GuildId, Camp, Info) ->
    gen_server:cast(?MODULE, {'update_cluster_guild_info', ServerId, GuildId, Camp, Info}).

update_cluster_role_info(ServerId, RoleId, Camp, Info) ->
    gen_server:cast(?MODULE, {'update_cluster_role_info', ServerId, RoleId, Camp, Info}).

judge_is_in_act_time() ->
    gen_server:call(?MODULE, {'judge_is_in_act_time'}).

judge_can_disband(GuildId) ->
    gen_server:call(?MODULE, {'judge_can_disband', GuildId}).

%% 战舰切换
change_role_group(RoleId, AttrKeyValueList, Scene, PoolId, Type, Group) ->
    gen_server:cast(?MODULE, {'change_role_group', RoleId, AttrKeyValueList, Scene, PoolId, Type, Group}).

get_next_act_time(RoleId) ->
    gen_server:cast(?MODULE, {'get_next_act_time', RoleId}).

get_join_camp_end_time(RoleId) ->
    gen_server:cast(?MODULE, {'get_join_camp_end_time', RoleId}).

day_trigger()->
    gen_server:cast(?MODULE, {'day_trigger'}).

send_msg_to_sea(Sid, RoleId, Camp, BinData) ->
    gen_server:cast(?MODULE, {'send_msg_to_sea', Sid, RoleId, Camp, BinData}).

get_seacraft_info(Ps) ->
    #player_status{id = RoleId, guild = #status_guild{realm = Camp}} = Ps,
    gen_server:cast(?MODULE, {'get_seacraft_info', RoleId, Camp}).

get_privilege_list(Ps) ->
    #player_status{id = RoleId, guild = #status_guild{realm = Camp}} = Ps,
    gen_server:cast(?MODULE, {'get_privilege_list', RoleId, Camp}).

center_option_privilege(Camp, PrivilegeItem) ->
    gen_server:cast(?MODULE, {'center_option_privilege', Camp, PrivilegeItem}).

update_member_item(Camp, Info) ->
    gen_server:cast(?MODULE, {'update_member_item', Camp, Info}).

send_member_info(Ps, PageSize, PageNum) ->
    #player_status{id = RoleId, guild = #status_guild{realm = Camp}} = Ps,
    gen_server:cast(?MODULE, {'send_member_info', RoleId, Camp, PageSize, PageNum}).

get_power_distribution(Ps) ->
    #player_status{id = RoleId, guild = #status_guild{realm = Camp}} = Ps,
    gen_server:cast(?MODULE, {'get_power_distribution', RoleId, Camp}).

get_change_info(Camp) ->
    gen_server:cast(?MODULE, {'get_change_info', Camp}).

role_die_handle(Arg1, Arg2, Arg3) ->
    gen_server:cast(?MODULE, {'role_die_handle', Arg1, Arg2, Arg3}).

sync_after_join_member(Camp, GMInfos) ->
    gen_server:cast(?MODULE, {'sync_after_join_member', Camp, GMInfos}).

exit_camp(Camp, ServerId, GuildId) ->
    gen_server:cast(?MODULE, {'exit_camp', Camp, ServerId, GuildId}).

center_flush_privilege(Camp, PrivilegeStatus) ->
    gen_server:cast(?MODULE, {'center_flush_privilege', Camp, PrivilegeStatus}).

sync_local_members(Camp, MemberList) ->
    gen_server:cast(?MODULE, {'sync_local_members', Camp, MemberList}).

update_member_job(Camp, JobId, RoleIdList) ->
    gen_server:cast(?MODULE, {'update_member_job', Camp, JobId, RoleIdList}).

update_sea_master_privilege(Camp, MasterId, OldMasterId, PrivilegeStatus) ->
    gen_server:cast(?MODULE, {'update_sea_master_privilege', Camp, MasterId, OldMasterId, PrivilegeStatus}).

change_sea_master(Camp, OldMasterId, MasterId) ->
    gen_server:cast(?MODULE, {'change_sea_master', Camp, OldMasterId, MasterId}).

update_member_list(Camp, ChangeList) ->
    gen_server:cast(?MODULE, {'update_member_list', Camp, ChangeList}).

update_member_join_quit(Camp, JoinList, QuitIdList) ->
    gen_server:cast(?MODULE, {'update_member_join_quit', Camp, JoinList, QuitIdList}).

member_join_guild(RoleId, Arg) ->
    {Camp, GuildId, GuildName, Vip, RoleId, RName, Lv, Exploit, CombatPower} = Arg,
    case Camp of
        0 -> skip;
        _ ->
            ServerId = config:get_server_id(),
            Args = {ServerId, GuildId, GuildName, Vip, RoleId, RName, Lv, ?SEA_MEMBER, Exploit, CombatPower},
            Member = lib_seacraft_extra:make_record(camp_member_info, Args),
            gen_server:cast(?MODULE, {'member_join_guild', Camp, RoleId, Member}),
            catch whereis(?MODULE) ! {'update_member_list'}
    end.

member_quit_guild(Camp, RoleIdList) ->
    case Camp of
        0 -> skip;
        _ ->
            gen_server:cast(?MODULE, {'member_quit_guild', Camp, RoleIdList}),
            catch whereis(?MODULE) ! {'update_member_list'}
    end.

day_opration(DelaySec) ->
    RandTime = urand:rand(20, 30),
    spawn(fun() -> timer:sleep(RandTime*1000+DelaySec), gen_server:cast(?MODULE, {'day_opration', RandTime}) end).

reset_act() ->
    gen_server:cast(?MODULE, {'reset_act'}).

get_old_job_id(RoleId) ->
    gen_server:cast(?MODULE, {'get_old_job_id', RoleId}).

async_set_sea_brick_num(RoleId, Camp) ->
    gen_server:cast(?MODULE, {'async_set_sea_brick_num', RoleId, Camp}).

update_brick_num(Camp, Num) ->
    gen_server:cast(?MODULE, {'update_brick_num', Camp, Num}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

gm_send_reward(GuildMember) ->
    gen_server:cast(?MODULE, {'gm_send_reward', GuildMember}).

gm_reload() ->
    gen_server:cast(?MODULE, {'gm_reload'}).

%% ============================================ 日常-============================================
%% 进入海战日常
enter_daily(ServerId, RoleId, RoleName, SeaId, BrickColor, EnterSeaId, Power, GuildId) ->
    gen_server:cast(?MODULE, {'enter_daily', ServerId, RoleId, RoleName, SeaId, BrickColor, EnterSeaId, Power, GuildId}).

get_sea_daily_rank(ServerId, RoleId, RoleName,  Power, SeaId) ->
    gen_server:cast(?MODULE, {'get_sea_daily_rank', ServerId, RoleId, RoleName,  Power, SeaId}).

get_sea_daily_all_rank(ServerId, RoleId, RoleName,  Power, SeaId) ->
    gen_server:cast(?MODULE, {'get_sea_daily_all_rank', ServerId, RoleId, RoleName,  Power, SeaId}).

init([]) ->
    OpenDay = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso OpenDay >= LimitOpenDay -> %% 开服天数限制
            InitRef = util:send_after(undefined, 30*1000, self(), {'init_sync'}),
            IsInit = ?NO_INIT;
        _ ->
            InitRef = undefined,
            IsInit = ?IS_INIT
    end,
    {ok, #local_seacraft_state{init_ref = InitRef, is_init = IsInit, change_info = lib_seacraft_extra:init_local_change_info()}}.

handle_call(Request, _From, State) ->
    OpenDay = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso OpenDay >= LimitOpenDay -> %% 开服天数限制
            case catch do_handle_call(Request, State) of
                {reply, Result, NewState} ->
                    {reply, Result, NewState};
                Res ->
                    ?ERR("Error:~p~n", [[Request, Res]]),
                    {reply, ok, State}
            end;
        _ ->
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    Openday = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso Openday >= LimitOpenDay -> %% 开服天数限制
            case catch do_handle_cast(Msg, State) of
                {noreply, NewState} ->
                    {noreply, NewState};
                Res ->
                    ?ERR("Error:~p~n", [[Msg, Res]]),
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    Openday = util:get_open_day(),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) andalso Openday >= LimitOpenDay -> %% 开服天数限制
            case catch do_handle_info(Info, State) of
                {noreply, NewState} ->
                    {noreply, NewState};
                Res ->
                    ?ERR("Error:~p~n", [[Info, Res]]),
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.



do_handle_cast({'get_sea_guild_msg', RoleId}, State) ->
    #local_seacraft_state{local_camp = Camp} = State,
    AllCamps = data_seacraft:get_all_camp(),
    F = fun(CampId, AccList) ->
            case maps:get(CampId, Camp, []) of
                #camp_info{camp_master = [{ServerId, GuildId}], guild_map = GuildMap} when ServerId =/=  0 andalso GuildId =/= 0 ->
                    GuildList =  maps:get(ServerId, GuildMap, []),
                    case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
                        #sea_guild{guild_name = GuildName} ->
                            [{CampId, GuildId, GuildName} | AccList];
                        _ ->
                            [{CampId, 0, ""} | AccList]
                    end;
                _ ->
                    [{CampId, 0, ""} | AccList]
            end
        end,
    PackList = lists:foldl(F, [], AllCamps),
    {ok, Bin} = pt_187:write(18715, [PackList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};






do_handle_cast({'get_sea_daily_all_rank', ServerId, RoleId, RoleName,  Power, SeaId}, State) ->
    #local_seacraft_state{local_camp = Camp} = State,
    case maps:get(SeaId, Camp, []) of
        #camp_info{job_list = JobList} ->
            case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                #sea_job{job_id = JobId} ->
                    ok;
                _ ->
                    JobId = ?SEA_MEMBER
            end,
            mod_clusters_node:apply_cast(mod_kf_seacraft_daily, get_sea_daily_all_rank, [SeaId, ServerId, RoleId, RoleName, JobId, Power]);
        _ ->
            sikp
    end,
    {noreply, State};


do_handle_cast({'get_sea_daily_rank', ServerId, RoleId, RoleName,  Power, SeaId}, State) ->
    #local_seacraft_state{local_camp = Camp} = State,
    case maps:get(SeaId, Camp, []) of
        #camp_info{job_list = JobList} ->
            case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                #sea_job{job_id = JobId} ->
                    ok;
                _ ->
                    JobId = ?SEA_MEMBER
            end,
            mod_clusters_node:apply_cast(mod_kf_seacraft_daily, get_daily_rank, [SeaId, ServerId, RoleId, RoleName, JobId, Power]);
        _ ->
            sikp
    end,
    {noreply, State};

do_handle_cast({'enter_daily', ServerId, RoleId, RoleName, SeaId, BrickColor, EnterSeaId, Power, GuildId}, State) ->
    #local_seacraft_state{local_camp = Camp, local_zone = LocalZoneData, act_type = {ActType, _}} = State,
    case maps:get(SeaId, Camp, []) of
        #camp_info{job_list = JobList, camp_master = _Master, att_def = AttdefList} = _CampInfo ->
            case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                #sea_job{job_id = JobId} ->
                    ok;
                _ ->
                    JobId = ?SEA_MEMBER
            end,
            IsRetreat = lib_seacraft_extra_api:get_sea_retreat(maps:get(EnterSeaId, Camp, [])),
            List = maps:to_list(Camp),
            HasOpen = calc_has_open(List),
            if
                 ActType == ?ACT_TYPE_SEA_PART ->
                     CanEnter = judge_guild_in_attdef_list(GuildId, AttdefList);
                 true ->
                     case LocalZoneData of
                          #zone_data{att_def = AttdefList1} ->
                             Res1 = judge_camp_in_attdef_list(SeaId, AttdefList1),
                             case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                                 #sea_job{} -> CanEnter = Res1;
                                 _ ->
                                     CanEnter = false
                             end;
                         _ ->
                             CanEnter = false
                     end
            end,
%%            ?PRINT("IsRetreat SeaId EnterSeaId ~p ~n", [[IsRetreat,SeaId,EnterSeaId, CanEnter]]),
            if
                IsRetreat andalso EnterSeaId =/= SeaId ->
                    {ok, Bin} = pt_187:write(18700, [?ERRCODE(err187_sea_retret)]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                HasOpen == 0 andalso CanEnter == false ->
                    {ok, Bin} = pt_187:write(18700, [?ERRCODE(err187_not_have_sea_king)]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    mod_clusters_node:apply_cast(mod_kf_seacraft_daily, enter_daily, [ServerId, config:get_server_num(),
                        RoleId, RoleName, SeaId, JobId, BrickColor, EnterSeaId, Power])
            end;
        _ ->
            sikp
    end,
    {noreply, State};

do_handle_cast({'day_trigger'}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    db:execute(?TRUNCATE_DAILY_JOB),
    List = maps:to_list(LocalCampMap),
    F = fun({_Camp, #camp_info{job_list = JobList}}, Acc) ->
        Fun = fun
            (#sea_job{role_id = RId, job_id = JobId}, Acc1) ->
                lists:keystore(RId, 1, Acc1, {RId, JobId});
            (_, Acc1) -> Acc1
        end,
        lists:foldl(Fun, Acc, JobList)
    end,
    DayJobList = lists:foldl(F, [], List),
    DbList = [[RoleId, Job]||{RoleId, Job} <- DayJobList],
    Sql = usql:replace(seacraft_daliy_reward, [role_id, job_id], DbList),
    DbList =/= [] andalso db:execute(Sql),
    {noreply, State#local_seacraft_state{day_job = DayJobList}};

do_handle_cast({'local_init', LocalCampMap, LocalZoneData, StartTime, EndTime, Act}, State) ->
    DbList = db:get_all(?SELECT_DAILY_JOB),
    OldJobList = [{RoleId, OldJobId} || [RoleId, OldJobId] <- DbList],
    {ActType, _ActNum} = Act,
    NextActTimeList = lib_seacraft:calc_next_act_time(Act, StartTime, EndTime, [{ActType, StartTime, EndTime}]),
    Ref = util:send_after(State#local_seacraft_state.upd_ref, ?UPDATE_TIME_LIMIT * 60 * 1000, self(), {'update_member_list'}),
    util:cancel_timer(State#local_seacraft_state.init_ref),

    %% 修改公会阵营信息（赛季重置之后也通过这重置
    ServerId = config:get_server_id(),
    F = fun(Camp, #camp_info{guild_map = GuildMap}, Acc) ->
        CampGuildList = maps:get(ServerId, GuildMap, []),
        GuildIdList = [GuildId || #sea_guild{guild_id = GuildId} <- CampGuildList],
        [{Camp, GuildIdList}|Acc]
        end,
    GuildCampList = maps:fold(F, [], LocalCampMap),
    mod_guild:update_guild_realm(GuildCampList),

    ?PRINT("==================sync data success====================== ~n", []),
    NewState = State#local_seacraft_state{
        is_init = ?IS_INIT,
        init_ref = undefined,
        local_camp = LocalCampMap, 
        start_time = StartTime, 
        end_time = EndTime, 
        act_type = Act,
        local_zone = LocalZoneData,
        next_act_time = NextActTimeList,
        day_job = OldJobList,
        upd_ref = Ref
    },
    {noreply, NewState};

do_handle_cast({'update_local_info', [{wlv, Wlv}|T]}, State) ->
    NewState = State#local_seacraft_state{wlv = Wlv},
    do_handle_cast({'update_local_info', T}, NewState);

do_handle_cast({'update_local_info', [{act_info, Act}|T]}, State) ->
    NewState = State#local_seacraft_state{
        act_type = Act
    },
    {ok, BinData} = pt_186:write(18623, [2]),
    lib_server_send:send_to_local_all(BinData),
    do_handle_cast({'update_local_info', T}, NewState);
do_handle_cast({'update_local_info', [{act_info, StartTime, EndTime, Act}|T]}, State) ->
    {ActType, _} = Act,
    NextActTimeList = lib_seacraft:calc_next_act_time(Act, StartTime, EndTime, [{ActType, StartTime, EndTime}]),
    #local_seacraft_state{local_camp = LocalCampMap, local_zone = LocalZoneData} = State,
    F = fun
        (_, Value) when is_record(Value, camp_info) ->
            Value#camp_info{score_list = [], role_score_map = #{}};
        (_, Value) -> Value
    end,
    NewLocalCampMap = maps:map(F, LocalCampMap),
    ZoneData = ?IF(is_record(LocalZoneData, zone_data), LocalZoneData, #zone_data{}),
    Nowtime = utime:unixtime(),
    if
        Nowtime >= StartTime andalso Nowtime =< EndTime ->
            lib_activitycalen_api:success_start_activity(186, 1);
        true ->
            skip
    end,
    NewZoneData = ZoneData#zone_data{score_list = [], role_score_map = #{}},
    NewState = State#local_seacraft_state{
        start_time = StartTime, 
        end_time = EndTime, 
        act_type = Act
        ,local_camp = NewLocalCampMap
        ,local_zone = NewZoneData
        ,role_group = []
        ,next_act_time = NextActTimeList
    },
    {ok, BinData} = pt_186:write(18623, [1]),
    lib_server_send:send_to_local_all(BinData),
    do_handle_cast({'update_local_info', T}, NewState);

do_handle_cast({'update_local_info', List}, State) -> 
    #local_seacraft_state{local_camp = LocalCampMap} = State,
    NewCampMap = calc_new_camp_map(List, LocalCampMap),
    NewState = State#local_seacraft_state{local_camp = NewCampMap},
    {noreply, NewState};

do_handle_cast({'update_local_zone_data', [{wlv, Wlv}|T]}, State) ->
    NewState = State#local_seacraft_state{wlv = Wlv},
    do_handle_cast({'update_local_zone_data', T}, NewState);

do_handle_cast({'update_local_zone_data', List}, State) ->
    #local_seacraft_state{local_zone = LocalZoneData} = State,
    ZoneData = ?IF(is_record(LocalZoneData, zone_data), LocalZoneData, #zone_data{}),
    NewZoneData = calc_new_zone_data(List, ZoneData),
    {noreply, State#local_seacraft_state{local_zone = NewZoneData}};

do_handle_cast({'get_old_job_id', RoleId}, State) ->
    #local_seacraft_state{
        day_job = OldJobList
    } = State,
    {_, OldJobId} = ulists:keyfind(RoleId, 1, OldJobList, {RoleId, ?SEA_MEMBER}),
    {ok, BinData} = pt_186:write(18656, [OldJobId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};


do_handle_cast({'get_main_show_info', _ServerId, _GuildId, Camp, RoleId}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    #camp_info{camp_master = [{MasterSerId, MasterGuildId}|_], guild_map = GuildMap, job_list = JobList} = maps:get(Camp, LocalCampMap, #camp_info{}),
    case lists:keyfind(RoleId, #sea_job.role_id, JobList) of %{serverid, server_num, role_id, role_name, role_lv, job_id, power, picture}
        #sea_job{job_id = JobId} -> JobId;
        _ when _GuildId =/= 0 -> JobId = ?SEA_MEMBER;
        _ -> JobId = 0
    end,
    List = maps:to_list(GuildMap),
    Fun = fun({_, TemList}, {Sum, Power, Master}) ->
        F = fun
            (SeaGuildMember, {TemNum, TemPower, TemMaster}) when is_record(SeaGuildMember, sea_guild) ->
                #sea_guild{
                    server_num = _ServerNum, guild_id = _GId, guild_name = _GuildName, 
                    guild_power = _GuildPower, role_id = _RoleId, 
                    role_name = _RoleName, member_num = _Num} = SeaGuildMember,
                {_Num+TemNum, _GuildPower+TemPower, ?IF(_GId == MasterGuildId, {_ServerNum, _GuildName, _RoleId, _RoleName}, TemMaster)};
            (_, Acc) -> Acc
        end,
        lists:foldl(F, {Sum, Power, Master}, TemList)
    end,
    {AllNum, SumPower, MasterInfo} = lists:foldl(Fun, {0,0,{0,"",0,""}}, List),
    {MasterServerNum, MasterGuildName, _MasterRoleId, MasterRoleName} = MasterInfo,
    HasGet = mod_daily:get_count_offline(RoleId, ?MOD_SEACRAFT, 1),
    ?PRINT("Camp ~p ~n", [Camp]),
    {ok, BinData} = pt_186:write(18600, [Camp, MasterSerId, MasterServerNum, MasterGuildId, MasterGuildName, MasterRoleName, SumPower, AllNum, JobId, ?IF(MasterGuildId == 0, 2, HasGet)]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_job_show', _ServerId, _GuildId, Camp, RoleId}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    #camp_info{job_list = JobList} = maps:get(Camp, LocalCampMap, #camp_info{}),
    LimitNum = data_seacraft:get_value(job_limit_num),
    Fun = fun
        (#sea_job{server_id = SerId, server_num = SerNum, role_id = RId, role_name = RName, role_lv = RLv, 
        job_id = JobId, combat_power = Power, picture = Picture, picture_ver = PictureVer}, {Sum, Acc, HasJ}) ->
            {Sum+1, [{JobId, SerId, SerNum, RId, RName, RLv, Picture, PictureVer, Power}|Acc], ?IF(RId == RoleId, 1, HasJ)};
        (_, Acc) -> Acc
    end,
    {Length, SendList, HasJoin} = lists:foldl(Fun, {0,[], 0}, JobList),
    {ok, BinData} = pt_186:write(18601, [LimitNum, Length, HasJoin, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_apply_list', Camp, GuildId, _ServerId, RoleId}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    #camp_info{camp_master = [{_, MasterGuildId}|_], application_list = ApplyList} = maps:get(Camp, LocalCampMap, #camp_info{}),
    if
        GuildId == MasterGuildId ->
            Fun = fun
                (#sea_apply{picture = Picture, picture_ver = PictureVer, role_lv = RoleLv, role_id = RId, role_name = RoleName, combat_power = Power}, Acc) ->
                    [{Picture, PictureVer, RoleLv, RId, RoleName, Power}|Acc];
                (_, Acc) -> Acc
            end,
            SendList = lists:foldl(Fun, [], ApplyList),
            {ok, BinData} = pt_186:write(18604, [SendList]);
        true ->
            {ok, BinData} = pt_186:write(18604, [[]])
    end,
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_apply_limit', Camp, _GuildId, _ServerId, RoleId}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    #camp_info{join_limit = JoinLimit} = maps:get(Camp, LocalCampMap, #camp_info{}),
    {LimitLv, LimitPower, Auto} = JoinLimit,
    {ok, BinData} = pt_186:write(18622, [LimitLv, LimitPower, Auto]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_act_time', RoleId, Camp, GuildId}, State) ->
    #local_seacraft_state{
        act_type = {ActType, _},
        start_time = StartTime, 
        end_time = EndTime, 
        local_camp = LocalCampMap,
        local_zone = LocalZoneData
    } = State,
    #camp_info{att_def = AttdefList, job_list = JobList} = maps:get(Camp, LocalCampMap, #camp_info{}),
    List = maps:to_list(LocalCampMap),
    HasOpen = calc_has_open(List),
    if
        ActType == ?ACT_TYPE_SEA_PART ->
            Res = judge_guild_in_attdef_list(GuildId, AttdefList);
        true ->
            case LocalZoneData of
                 #zone_data{att_def = AttdefList1} -> 
                    Res1 = judge_camp_in_attdef_list(Camp, AttdefList1),
                    case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                        #sea_job{} -> Res = Res1;
                        _ ->
                            Res = false
                    end;
                _ ->
                    Res = false
            end
    end,
    CanEnter = ?IF(Res == true, 1, 0),
    {ok, BinData} = pt_186:write(18607, [ActType, HasOpen, StartTime, EndTime, CanEnter]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_camp_guild_list', RoleId, Camp}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    #camp_info{guild_map = GuildMap} = maps:get(Camp, LocalCampMap, #camp_info{}),
    List = maps:to_list(GuildMap),
    Fun = fun({_, TemList}, Acc) ->
        F = fun
            (SeaGuildMember, TemAcc) when is_record(SeaGuildMember, sea_guild) ->
                #sea_guild{server_id = ServerId, server_num = _ServerNum, 
                    guild_id = _GuildId, guild_name = _GuildName, guild_power = _GuildPower, 
                    role_id = _RoleId, role_name = _RoleName} = SeaGuildMember,

                [{ServerId, _ServerNum, _GuildId, _GuildName, _GuildPower, _RoleId, _RoleName}|TemAcc];
            (_, TemAcc) -> TemAcc
        end,
        lists:foldl(F, Acc, TemList)
    end,
    GuildList = lists:foldl(Fun, [], List),
    SortList = lists:reverse(lists:keysort(5, GuildList)),
    F1 = fun({ServerId, _ServerNum, _GuildId, _GuildName, _GuildPower, _RoleId, _RoleName}, {Acc, Rank}) ->
        {[{Rank, ServerId, _ServerNum, _GuildId, _GuildName, _GuildPower, _RoleName, _RoleId}|Acc], Rank+1}
    end,
    {SendList, _} = lists:foldl(F1, {[], 1}, SortList),
    {ok, BinData} = pt_186:write(18608, [Camp, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_camp_mon_list', RoleId, Camp}, State) ->
    #local_seacraft_state{
        act_type = {ActType, _},
        local_camp = LocalCampMap,
        local_zone = LocalZoneData
    } = State,
    if
        ActType == ?ACT_TYPE_SEA_PART ->
            #camp_info{camp_mon = MonList} = maps:get(Camp, LocalCampMap, #camp_info{});
        true ->
            case LocalZoneData of
                 #zone_data{sea_mon = MonList} -> ok;
                _ -> MonList = []
            end
    end,
    {ok, BinData} = pt_186:write(18609, [MonList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_score_info', RoleId, Camp}, State) ->
    #local_seacraft_state{
        act_type = {ActType, ActNum},
        local_camp = LocalCampMap,
        end_time = EndTime,
        local_zone = LocalZoneData
    } = State,
    Nowtime = utime:unixtime(),
    if
        Nowtime >= EndTime andalso ActNum == 0 ->
            RealActType = ?IF(ActType == ?ACT_TYPE_SEA_PART, ?ACT_TYPE_SEA, ?ACT_TYPE_SEA_PART);
        true ->
            RealActType = ActType
    end,
    if
        RealActType == ?ACT_TYPE_SEA_PART ->
            #camp_info{score_list = ScoreList, att_def = AttdefList, role_score_map = RoleScoreMap, guild_map = GuildMap} = maps:get(Camp, LocalCampMap, #camp_info{}),
            SortList = lib_seacraft:sort_score_rank(ScoreList),
            Fun = fun({ServerId, GuildId, Score, _}, {Acc, Rank}) ->
                Realm = get_guild_camp_realm(GuildId, AttdefList),
                GuildList = maps:get(ServerId, GuildMap, []),
                #sea_guild{guild_name = GuildName} = ulists:keyfind(GuildId, #sea_guild.guild_id, GuildList, #sea_guild{}),
                List = maps:get({ServerId, GuildId}, RoleScoreMap, []),
                Member = calc_send_member(List),
                {[{GuildId, GuildName, Realm, Rank, Score, Member}|Acc], Rank+1}
            end,
            {SendList,_} = lists:foldl(Fun, {[], 1}, SortList);
        true ->
            case LocalZoneData of
                 #zone_data{score_list = ScoreList, att_def = AttdefList, role_score_map = RoleScoreMap} -> 
                    SortList = lib_seacraft:sort_score_rank(ScoreList),
                    Fun = fun({TemCamp, Score, _}, {Acc, Rank}) ->
                        Realm = get_guild_camp_realm(TemCamp, AttdefList),
                        CampName = 
                        case data_seacraft:get_camp_name(TemCamp) of
                            Name when Name =/= [] -> Name;
                            _ -> ""
                        end,
                        List = maps:get(TemCamp, RoleScoreMap, []),
                        Member = calc_send_member(List),
                        {[{TemCamp, CampName, Realm, Rank, Score, Member}|Acc], Rank+1}
                    end,
                    {SendList,_} = lists:foldl(Fun, {[], 1}, SortList);
                _ -> SendList = []
            end
    end,
    {ok, BinData} = pt_186:write(18611, [SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_sea_master_info', RoleId}, State) ->
    #local_seacraft_state{
        start_time = StartTime,
        end_time = EndTime,
        local_camp = LocalCampMap,
        local_zone = LocalZoneData
    } = State,
    case LocalZoneData of
         #zone_data{sea_master = {MasterCamp, Times}} -> 
            #camp_info{camp_master = [{MasterSerId, MasterGuildId}|_], guild_map = GuildMap, win_reward = WinRewardList} = maps:get(MasterCamp, LocalCampMap, #camp_info{}),
            GuildList = maps:get(MasterSerId, GuildMap, []),
            #sea_guild{server_num = ServerNum, guild_name = GuildName} = 
                ulists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList, #sea_guild{}),
             % [{serverid, server_num, guild_id, guild_name, guild_power, roleid, role_name, num}]
            WinStatus = [{Num, ?IF(RId == 0, 1, 2)}|| {Num, {_, RId}} <- WinRewardList],
            {ok, BinData} = pt_186:write(18615, [MasterCamp, MasterSerId, ServerNum, MasterGuildId, GuildName, Times, StartTime, EndTime, WinStatus]);
        _ -> 
            {ok, BinData} = pt_186:write(18615, [0, 0, 0, 0, "", 0, 0, 0, []])
    end,
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_att_def_list', RoleCamp, RoleId}, State) ->
    #local_seacraft_state{
        act_type = {ActType, _},
        local_camp = LocalCampMap,
        local_zone = LocalZoneData
    } = State,
    if
        ActType == ?ACT_TYPE_SEA_PART ->
            #camp_info{att_def = AttdefList, guild_map = GuildMap} = maps:get(RoleCamp, LocalCampMap, #camp_info{}),
            {SendDefList, SendAttList} = lib_seacraft:data_for_client(?ACT_TYPE_SEA_PART, AttdefList, GuildMap),
            {ok, BinData} = pt_186:write(18617, [SendAttList, SendDefList]);
        true ->
            case LocalZoneData of
                 #zone_data{att_def = AttdefList} -> 
                    {SendDefList, SendAttList} = lib_seacraft:data_for_client(2, AttdefList, #{}),
                    {ok, BinData} = pt_186:write(18617, [SendAttList, SendDefList]);
                _ -> 
                    {ok, BinData} = pt_186:write(18617, [[], []])
            end
    end,
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_camp_info', RoleId}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    Fun = fun({Camp, #camp_info{camp_master = [{MasterSerId, MasterGuildId}|_], guild_map = GuildMap}}, Acc) ->
        if
            MasterGuildId =/= 0 andalso MasterSerId =/= 0 ->
                GuildList = maps:get(MasterSerId, GuildMap, []),
                #sea_guild{server_num = SerNum, guild_name = GName, guild_power = GuildPower, role_id = RId, 
                    role_name = RName} = ulists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList, #sea_guild{}),
                [{Camp, MasterSerId, SerNum, MasterGuildId, GName, GuildPower, RId, RName}|Acc];
            true ->
                List = maps:to_list(GuildMap),
                Fun1 = fun({_, TemList}, TemAcc) ->
                    F = fun
                        (#sea_guild{guild_power = _GuildPower1} = V1, #sea_guild{guild_power = _GuildPower2} = V) ->
                            if
                                _GuildPower1 > _GuildPower2 ->
                                    V1;
                                true ->
                                    V
                            end;
                        (#sea_guild{guild_power = _GuildPower1} = V1, 0) ->
                            V1
                    end,
                    lists:foldl(F, TemAcc, TemList)
                end,
                case lists:foldl(Fun1, 0, List) of
                    #sea_guild{server_id = ServerId, server_num = ServerNum, guild_id = GuildId, 
                    guild_name = GName, guild_power = GuildPower, role_id = RId, role_name = RName} -> 
                        [{Camp, ServerId, ServerNum, GuildId, GName, GuildPower, RId, RName}|Acc];
                    _ -> Acc
                end
        end
    end,
    SendList = lists:foldl(Fun, [], maps:to_list(LocalCampMap)),
    {ok, BinData} = pt_186:write(18618, [SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'recieve_daily_reward', _ServerId, _GuildId, GuildName, RoleId, RoleName, Camp}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap,
        local_zone = LocalZoneData,
        day_job = OldJobList
    } = State,
    #camp_info{job_list = _JobList, camp_master = [{_, MasterGuildId}|_]} = maps:get(Camp, LocalCampMap, #camp_info{}),
    HasGet = mod_daily:get_count(RoleId, ?MOD_SEACRAFT, 1),
    if
        MasterGuildId == 0 ->
            {ok, BinData} = pt_186:write(18621, [[], ?ERRCODE(err186_cant_recieve_before_act_start)]);
        HasGet == 1 ->
            {ok, BinData} = pt_186:write(18621, [[], ?ERRCODE(err186_has_recieve)]);
        true ->
            % {_,_,_,_,_,NowJobId,_,_} = ulists:keyfind(RoleId, 3, _JobList, {0,0,0,"",0,?SEA_MEMBER,0,""}),
            {_, OldJobId} = ulists:keyfind(RoleId, 1, OldJobList, {RoleId, ?SEA_MEMBER}),
            JobId = OldJobId,
            case data_seacraft:get_daily_reward(JobId) of
                #base_seacraft_daily_reward{normal = NormalReward, special = SpecialReward} ->
                    NewSpecialReward = ?IF(SpecialReward == [], NormalReward, SpecialReward),
                    case LocalZoneData of
                         #zone_data{sea_master = {MasterCamp, _}} ->
                            if
                                MasterCamp == Camp ->
                                    lib_seacraft:send_reward_normal(RoleId, NewSpecialReward),
                                    lib_log_api:log_seacraft_daily(Camp, _GuildId, GuildName, RoleId, RoleName, JobId, NewSpecialReward),
                                    {ok, BinData} = pt_186:write(18621, [NewSpecialReward, 1]);
                                true ->
                                    lib_seacraft:send_reward_normal(RoleId, NormalReward),
                                    lib_log_api:log_seacraft_daily(Camp, _GuildId, GuildName, RoleId, RoleName, JobId, NormalReward),
                                    {ok, BinData} = pt_186:write(18621, [NormalReward, 1])
                            end;
                        _ ->
                            lib_seacraft:send_reward_normal(RoleId, NormalReward),
                            lib_log_api:log_seacraft_daily(Camp, _GuildId, GuildName, RoleId, RoleName, JobId, NormalReward),
                            {ok, BinData} = pt_186:write(18621, [NormalReward, 1])
                    end,
                    mod_daily:set_count(RoleId, ?MOD_SEACRAFT, 1, 1);
                _ ->
                    {ok, BinData} = pt_186:write(18621, [[], ?ERRCODE(err186_error_data)])
            end
    end,
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'exit_guild', ServerId, RoleIdIdList, Camp, InfoList}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    #camp_info{job_list = JobList, application_list = ApplyList} = maps:get(Camp, LocalCampMap, #camp_info{}),
    Fun = fun(RoleId, Acc) ->
        case lists:keyfind(RoleId, #sea_apply.role_id, ApplyList) of
            #sea_apply{} ->
                [RoleId|Acc];
            _ ->
                case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                    #sea_job{} -> [RoleId|Acc];
                    _ -> Acc
                end
        end
    end,
    NewRoleIdList = lists:foldl(Fun, [], RoleIdIdList),
    {ok, BinData} = pt_186:write(18600, [0, 0, 0, 0, "", "", 0, 0, 0, 2]),
    lib_server_send:send_to_all(all_include, RoleIdIdList, BinData),
    mod_kf_seacraft:exit_guild(ServerId, NewRoleIdList, Camp, InfoList),
    {noreply, State};

do_handle_cast({'change_guild_info', ServerId, Camp, [{power, GuildId, CombatPowerNow}, {num, GuildId, GuildMemNumNow}|_]}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap
    } = State,
    #camp_info{guild_map = GuildMap} = maps:get(Camp, LocalCampMap, #camp_info{}),
    GuildList = maps:get(ServerId, GuildMap, []),
    case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{member_num = OldNum, guild_power = OldGuildPower} 
        when OldNum =/= GuildMemNumNow orelse CombatPowerNow =/= OldGuildPower ->
            if
                OldNum == GuildMemNumNow ->
                    InfoList = [{power, GuildId, CombatPowerNow}];
                CombatPowerNow == OldGuildPower ->
                    InfoList = [{num, GuildId, GuildMemNumNow}];
                true ->
                    InfoList = [{power, GuildId, CombatPowerNow}, {num, GuildId, GuildMemNumNow}]
            end,
            mod_kf_seacraft:change_guild_info(ServerId, Camp, InfoList);
        _ ->
            skip
    end,
    {noreply, State};
do_handle_cast({'change_guild_info', ServerId, Camp, InfoList}, State) ->
    mod_kf_seacraft:change_guild_info(ServerId, Camp, InfoList),
    {noreply, State};

do_handle_cast({'update_role_info', Camp, RoleId, RoleName, RoleLv, Power, Picture, PictureVer}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap,
        update_time = UpdateTime,
        role_info = RoleInfo
    } = State,
    #camp_info{job_list = JobList, application_list = ApplyList} = maps:get(Camp, LocalCampMap, #camp_info{}),
    RoleList = maps:get(Camp, RoleInfo, []),
    ServerId = config:get_server_id(),
    NewRoleList =    
    case lists:keyfind(RoleId, #sea_apply.role_id, ApplyList) of
        #sea_apply{} ->
            lists:keystore(RoleId, 1, RoleList, {RoleId, RoleName, RoleLv, Power, Picture, PictureVer});
        _ ->
            case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                #sea_job{} -> 
                    lists:keystore(RoleId, 1, RoleList, {RoleId, RoleName, RoleLv, Power, Picture, PictureVer});
                _ ->
                    RoleList
            end
    end,
    NewRoleInfo = ?IF(NewRoleList =/= [], maps:put(Camp, NewRoleList, RoleInfo), RoleInfo),
    Nowtime = utime:unixtime(),
    CfgTime = lib_seacraft:get_update_role_info_time(),
    if
        UpdateTime == 0 -> %% 服务器启动时不更新数据
            NewUpdateTime = Nowtime,
            RealRoleInfo = NewRoleInfo;
        NewRoleInfo =/= #{} andalso UpdateTime + CfgTime < Nowtime ->
            mod_kf_seacraft:update_role_info(ServerId, NewRoleInfo),
            RealRoleInfo = #{},
            NewUpdateTime = Nowtime;
        true ->
            NewUpdateTime = UpdateTime,
            RealRoleInfo = NewRoleInfo
    end,
    {noreply, State#local_seacraft_state{update_time = NewUpdateTime, role_info = RealRoleInfo}};

do_handle_cast({'change_role_group', RoleId, AttrKeyValueList, _Scene, _PoolId, Type, Group}, State) ->
    #local_seacraft_state{role_group = RoleGroupList, wlv = Wlv} = State,
    Nowtime = utime:unixtime(),
    CfgTime = lib_seacraft:get_change_ship_time(),
    
    case lists:keyfind(RoleId, 1, RoleGroupList) of
        {RoleId, _, Time} ->
            if
                Type == 0 ->
                    {ok, BinData} = pt_186:write(18610, [Group, 1, Time+CfgTime]),
                    NewRoleGroupList = RoleGroupList;
                Time + CfgTime =< Nowtime ->
                    if
                        Type == ?SHIP_TYPE_CONSTRUCTION ->
                            AttrKeyValueList1 = [{change_scene_hp_lim, 100}, {group, Type}, {change_passive_skill, []}],
                            AttList = data_seacraft:get_ship_att(Wlv),
                            case lists:keyfind(?HP, 1, AttList) of
                                {_, Value} -> ExtraList = AttrKeyValueList1++[{all_hp, Value}, {set_att, AttList}];
                                _ -> 
                                    ExtraList = AttrKeyValueList1 ++ ?IF(AttList == [], [], [{set_att, AttList}])
                            end;
                        true ->
                            AttrKeyValueList1 = [{change_scene_hp_lim, 100}, {group, Type}], 
                            ExtraList = AttrKeyValueList1++[{set_att, []}]
                    end,
                    mod_server_cast:set_data(AttrKeyValueList++ExtraList, RoleId),
                    % mod_scene_agent:update(Scene, PoolId, RoleId, AttrKeyValueList++ExtraList),
                    ?PRINT("CfgTime:~p,Nowtime+CfgTime:~p~n",[CfgTime, Nowtime+CfgTime]),
                    {ok, BinData} = pt_186:write(18610, [Type, 1, Nowtime+CfgTime]),
                    NewRoleGroupList = lists:keystore(RoleId, 1, RoleGroupList, {RoleId, Type, Nowtime});
                true ->
                    {ok, BinData} = pt_186:write(18610, [Type, ?ERRCODE(err186_change_ship_time_limit), 0]),
                    NewRoleGroupList = RoleGroupList
            end;
        _ ->
            if
                Type == 0 ->
                    {ok, BinData} = pt_186:write(18610, [Group, 1, 0]),
                    NewRoleGroupList = RoleGroupList;
                true ->

                    if
                        Type == ?SHIP_TYPE_CONSTRUCTION ->
                            AttrKeyValueList1 = [{change_scene_hp_lim, 100}, {group, Type}, {change_passive_skill, []}],
                            AttList = data_seacraft:get_ship_att(Wlv),
                            case lists:keyfind(?HP, 1, AttList) of
                                {_, Value} -> 
                                    ExtraList = AttrKeyValueList1++[{all_hp, Value}, {set_att, AttList}];
                                _ -> ExtraList = AttrKeyValueList1++?IF(AttList == [], [], [{set_att, AttList}])
                            end;
                        true ->
                            AttrKeyValueList1 = [{change_scene_hp_lim, 100}, {group, Type}], 
                            ExtraList = AttrKeyValueList1++[{set_att, []}]
                    end,
                    mod_server_cast:set_data(AttrKeyValueList++ExtraList, RoleId),
                    % mod_scene_agent:update(Scene, PoolId, RoleId, AttrKeyValueList++ExtraList),
                    {ok, BinData} = pt_186:write(18610, [Type, 1, Nowtime+CfgTime]),
                    NewRoleGroupList = lists:keystore(RoleId, 1, RoleGroupList, {RoleId, Type, Nowtime})
            end
    end,
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State#local_seacraft_state{role_group = NewRoleGroupList}};

do_handle_cast({'get_next_act_time', RoleId}, State) ->
    #local_seacraft_state{act_type = Act, start_time = StartTime, end_time = EndTime, next_act_time = NextActTimeList} = State,
    Nowtime = utime:unixtime(),
    {ActType, Num} = Act,
    if
        Nowtime >= EndTime andalso EndTime =/= 0 ->
            NewNextActTimeList = lib_seacraft:calc_next_act_time(Act, StartTime, EndTime, []);
        Nowtime >= StartTime andalso StartTime =/= 0 ->
            NewNextActTimeList = lib_seacraft:calc_next_act_time({ActType, Num+1}, StartTime, EndTime, []);
        true ->
            NewNextActTimeList = NextActTimeList
    end,
    {ok, BinData} = pt_186:write(18624, [NewNextActTimeList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'day_opration', _RandTime}, State) ->
    #local_seacraft_state{
        start_time = StartTime,
        act_type = {ActType, Num}
    } = State,
    IsSameDay = utime:is_today(StartTime),
    if
        ActType == ?ACT_TYPE_SEA_PART andalso Num == 0 andalso IsSameDay == true ->
            GuildMap = mod_guild:get_top_guild(?AUTO_JOIN_CAMP_LIMIT),
            List = lib_seacraft:handle_data_for_join_camp(GuildMap),
            mod_kf_seacraft:auto_join_camp(List);
        true ->
            skip
    end,
    {noreply, State};

do_handle_cast({'get_join_camp_end_time', RoleId}, State) ->
    #local_seacraft_state{
        start_time = StartTime,
        act_type = {ActType, Num},
        next_act_time = NextActTimeList
    } = State,
    IsSameDay = utime:is_today(StartTime),
    if
        ActType == ?ACT_TYPE_SEA_PART andalso Num == 0 andalso IsSameDay == false ->
            case lists:keyfind(?ACT_TYPE_SEA_PART, 1, NextActTimeList) of
                {_, StartTime1, _} -> Zero = utime:unixdate(StartTime1);
                _ -> Zero = 0
            end;
        ActType == ?ACT_TYPE_SEA_PART andalso Num == 0 andalso IsSameDay == true ->
            Zero = utime:unixdate(StartTime);
        true ->
            Zero = 0
    end,
    {ok, BinData} = pt_186:write(18625, [Zero]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'reset_act'}, State) ->
    Openday = util:get_open_day(),
    ?PRINT(":=============== ~p~n",[reset_act]),
    if
        Openday =< 1 ->
            skip;
        true ->
            ?PRINT(":=============== ~p~n",[reset_act]),
            lib_seacraft:remove_all_dsgt(),
            lib_seacraft:notify_role_act_reset(),
            Rand = urand:rand(1, 200),
            spawn(fun() ->
                timer:sleep(Rand),
                ServerInfo = lib_seacraft:get_server_info(),
                mod_kf_seacraft:local_init(ServerInfo)
            end)
    end,
    {noreply, State};

do_handle_cast({'gm_reload'}, State) ->
    ServerInfo = lib_seacraft:get_server_info(),
    mod_kf_seacraft:local_init(ServerInfo),
    {noreply, State};

%%% 秘籍
do_handle_cast({'gm_send_reward', GuildMember}, State) ->
    Fun = fun({GuildId, Camp, RoleIdList}, Acc) ->
        case lists:keyfind(Camp, 1, Acc) of
            {_, List} -> lists:keystore(Camp, 1, Acc, {Camp, [{GuildId, RoleIdList}|List]});
            _ -> lists:keystore(Camp, 1, Acc, {Camp, [{GuildId, RoleIdList}]})
        end
    end,
    CampMember = lists:foldl(Fun, [], GuildMember),
    #local_seacraft_state{local_camp = CampMap} = State,
    RankReward = [{0,19020001,3},{0,38040076,2}],
    SucessReward = [{0,17030111,5},{0,19020001,3}],
    FailReward = [{0,17030111,3},{0,19020001,2}],
    Fun1 = fun({Camp, CampList}, Acc) ->
        case maps:get(Camp, CampMap, false) of
            false -> Acc;
            #camp_info{camp_master = [{_, MasterGuildId}]} ->
                F1 = fun({GuildId, RoleIdList}, Acc1) ->
                    ActReward = ?IF(GuildId == MasterGuildId, SucessReward, FailReward),
                    lists:keystore(GuildId, 1, Acc1, {GuildId, RoleIdList, RankReward++ActReward})
                end,
                lists:foldl(F1, Acc, CampList)
        end
    end,
    GuildMemberReward = lists:foldl(Fun1, [], CampMember),
    spawn(
        fun() ->
            Rand = urand:rand(10,200),
            timer:sleep(Rand),
            DbList = db:get_all("SELECT `guild_id`, `role_id` FROM `log_seacraft_reward`"),
            Fun2 = fun([GuildId, RoleId], Acc) ->
                case lists:keyfind(GuildId, 1, Acc) of
                    {_, RoleIdList, Reward} ->
                        lists:keystore(GuildId, 1, Acc, {GuildId, lists:delete(RoleId, RoleIdList), Reward});
                    _ ->
                        Acc
                end
            end,
            NeedHandList = lists:foldl(Fun2, GuildMemberReward, DbList),
            ?INFO("DbList:~p, NeedHandList:~p~n",[DbList,NeedHandList]),
            Tittle = utext:get(1860013),
            Content = utext:get(1860014),
            Fun3 = fun({_GuildId, RoleIdList, Reward}) ->
                [begin timer:sleep(20), lib_mail_api:send_sys_mail([RoleID], Tittle, Content, Reward) end || RoleID <- RoleIdList]
            end,
            spawn(fun() -> lists:foreach(Fun3, NeedHandList) end)
            
    end),
    {noreply, State};

do_handle_cast({'send_msg_to_sea', Sid, RoleId, Camp, BinData}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false ->
            lib_chat:send_error_code(Sid, ?ERRCODE(err_110_no_camp));
        #camp_info{guild_map = GuildMap, member_list = MemberList} = CampInfo ->
            IsMuted = lib_seacraft_extra_api:get_sea_muted(CampInfo),
            ?PRINT("IsMuted ~p ~n", [IsMuted]),
            if
                IsMuted ->
                    CanChatJobList = data_seacraft:get_value(muted_can_chat_job),
                    RoleJob = lib_seacraft_extra_api:get_member_job(MemberList, RoleId, Camp),
                    CanChat = lists:member(RoleJob, CanChatJobList),
                    if
                        CanChat -> lib_seacraft_extra:send_msg_camp(BinData, GuildMap);
                        true ->
                            #base_sea_privilege{duration = Duration} = data_seacraft:get_sea_privilege(?PRI_SEA_MUTED),
                            lib_chat:send_error_code(Sid, {?ERRCODE(err_110_sea_muted), [Duration div 60]})
                    end;
                true ->
                    [mod_clusters_node:apply_cast(mod_clusters_center, apply_cast, [SerId, lib_server_send, send_to_camp, [Camp, BinData]])
                        ||{SerId, _}<-maps:to_list(GuildMap), SerId =/= config:get_server_id()],
                    lib_server_send:send_to_camp(Camp, BinData)
%%                    lib_seacraft_extra:send_msg_camp(BinData, GuildMap)
            end
    end ,
    {noreply, State};

do_handle_cast({'send_member_info', RoleId, Camp, PageSize, PageNum}, State) ->
    lib_seacraft_extra:send_member_info(State, RoleId, Camp, PageSize, PageNum),
    {noreply, State};

do_handle_cast({'sync_local_members', Camp, MemberList}, State) ->
    NewState = lib_seacraft_extra:sync_local_members(State, Camp, MemberList),
    {noreply, NewState};

do_handle_cast({'update_member_job', Camp, JobId, RoleIdList}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            NewCampInfo = lib_seacraft_extra:update_member_job(Camp, CampInfo, JobId, RoleIdList),
            {noreply, State#local_seacraft_state{local_camp = maps:put(Camp, NewCampInfo, CampMap)}}
    end;

do_handle_cast({'update_sea_master_privilege', Camp, MasterId, OldMasterId, PrivilegeStatus}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            NewMemberList = lib_seacraft_extra:local_change_sea_master(Camp, CampInfo#camp_info.member_list, OldMasterId, MasterId),
            ?PRINT("[MasterId, OldMasterId] ~p NewMemberList ~p ~n", [[MasterId, OldMasterId],NewMemberList]),
            NewCampInfo = CampInfo#camp_info{member_list = NewMemberList},
            {noreply, State#local_seacraft_state{local_camp = maps:put(Camp, NewCampInfo#camp_info{privilege_status = PrivilegeStatus}, CampMap)}}
    end;

do_handle_cast({'change_sea_master', Camp, OldMasterId, MasterId}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        #camp_info{member_list = MemberList} = CampInfo ->
            NewMemberList = lib_seacraft_extra:local_change_sea_master(Camp, MemberList, OldMasterId, MasterId),
            {noreply, State#local_seacraft_state{local_camp = maps:put(Camp, CampInfo#camp_info{member_list = NewMemberList}, CampMap)}}
    end;

do_handle_cast({'update_member_list', Camp, ChangeList}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            NewCampInfo = lib_seacraft_extra:update_member_list(Camp, CampInfo, ChangeList),
            {noreply, State#local_seacraft_state{local_camp = maps:put(Camp, NewCampInfo, CampMap)}}
    end;

do_handle_cast({'update_member_join_quit', Camp, JoinList, QuitIdList}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            ?PRINT("update_member_join_quit ~n", []),
            NewCampInfo = lib_seacraft_extra:update_member_join_quit(CampInfo, JoinList, QuitIdList),
            {noreply, State#local_seacraft_state{local_camp = maps:put(Camp, NewCampInfo, CampMap)}}
    end;

do_handle_cast({'get_seacraft_info', RoleId, Camp}, State) ->
    lib_seacraft_extra:get_seacraft_info(RoleId, Camp, State),
    {noreply, State};

do_handle_cast({'get_privilege_list', RoleId, Camp}, State) ->
    lib_seacraft_extra:get_privilege_list(RoleId, Camp, State),
    {noreply, State};

do_handle_cast({'center_option_privilege', Camp, PrivilegeItem}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            #camp_info{privilege_status = PrStatus} = CampInfo,
            PrivilegeId = PrivilegeItem#privilege_item.privilege_id,
            NewPrStatus = lists:keystore(PrivilegeId, #privilege_item.privilege_id, PrStatus, PrivilegeItem),
            NewCampInfo = CampInfo#camp_info{privilege_status = NewPrStatus},
            NewCampMap = maps:put(Camp, NewCampInfo, CampMap),
            OnlineUser = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(OId, ?APPLY_CAST_STATUS, mod_seacraft_local, get_privilege_list, [])||#ets_online{id = OId}<-OnlineUser],
            {noreply, State#local_seacraft_state{local_camp = NewCampMap}}
    end;

do_handle_cast({'center_flush_privilege', Camp, PrivilegeStatus}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            NewCampInfo = CampInfo#camp_info{privilege_status = PrivilegeStatus},
            NewCampMap = maps:put(Camp, NewCampInfo, CampMap),
            OnlineUser = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(OId, ?APPLY_CAST_STATUS, mod_seacraft_local, get_privilege_list, [])||#ets_online{id = OId}<-OnlineUser],
            {noreply, State#local_seacraft_state{local_camp = NewCampMap}}
    end;

do_handle_cast({'update_member_item', Camp, Info}, State) ->
    #local_seacraft_state{change_info = ChangeInfo, local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false ->
            {noreply, State};
        _CampInfo ->
            {CampChangeList, _JoinList, _QUitList} = maps:get(Camp, ChangeInfo, {[],[],[]}),
            {Vip, RoleId, RName, Lv, Exploit, CombatPower} = Info,
            db:execute(io_lib:format(?REPLACE_LOCAL_CHANGEINFO, [Camp, Vip, RoleId, RName, Lv, Exploit, CombatPower])),
%%            Sql = io_lib:format(?REPLACE_LOCAL_CHANGEINFO, [Camp, Vip, RoleId, RName, Lv, Exploit, CombatPower]),
%%            ?PRINT("SQl : '~s' ~n", [Sql]),
            NewCampChangeList = lists:keystore(RoleId, 2, CampChangeList, Info),
            NewChangeInfo = maps:put(Camp, {NewCampChangeList, _JoinList, _QUitList}, ChangeInfo),
            {noreply, State#local_seacraft_state{change_info = NewChangeInfo}}
    end;

do_handle_cast({'member_join_guild', Camp, RoleId, Member}, State) ->
    #local_seacraft_state{change_info = ChangeInfo, local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false ->
            {noreply, State};
        _CampInfo ->
            {_CampChangeList, JoinList, QUitList} = maps:get(Camp, ChangeInfo, {[],[],[]}),
            NewQUitList = lists:delete(RoleId, QUitList),
            db:execute(io_lib:format(?DELETE_LOCAL_QUIT, [RoleId])),
            NewJoinList = [Member|JoinList],
            save_local_join_member(Member, Camp),
            NewChangeInfo = maps:put(Camp, {_CampChangeList, NewJoinList, NewQUitList}, ChangeInfo),
            %% 推送消息
            NewState = State#local_seacraft_state{change_info = NewChangeInfo},
            do_handle_cast({'get_main_show_info', config:get_server_id(), Member#camp_member_info.guild_id, Camp, RoleId}, NewState),
            do_handle_info({'update_member_list'}, NewState)
    end;

do_handle_cast({'member_quit_guild', Camp, RoleIdList}, State) ->
    #local_seacraft_state{change_info = ChangeInfo, local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false ->
            {noreply, State};
        _CampInfo ->
            {_CampChangeList, JoinList, QUitList} = maps:get(Camp, ChangeInfo, {[],[],[]}),
            F = fun(RoleId, Acc)-> lists:keydelete(RoleId, #camp_member_info.role_id, Acc) end,
            NewJoinList = lists:foldl(F, JoinList, RoleIdList),
            spawn(fun() -> [begin timer:sleep(20),db:execute(io_lib:format(?DELETE_LOCAL_JOIN, [RId])) end||RId<-RoleIdList]  end),
            NewQUitList = RoleIdList ++ QUitList,
            spawn(fun() -> [begin timer:sleep(20),db:execute(io_lib:format(?REPLACE_LOCAL_QUIT, [Camp, Rid])) end||Rid<-RoleIdList] end),
            NewChangeInfo = maps:put(Camp, {_CampChangeList, NewJoinList, NewQUitList}, ChangeInfo),
            do_handle_info({'update_member_list'}, State#local_seacraft_state{change_info = NewChangeInfo})
    end;

do_handle_cast({'get_power_distribution', RoleId, Camp}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> skip;
        CampInfo ->
            #camp_info{guild_map = GuildMap} = CampInfo,
            SendList =
                maps:fold(
                    fun(_, Val, Acc) ->
                        List = [{ServerNum, GuildId, GuildName, LeaderId, LeaderName, GuildPower, Num}||
                            #sea_guild{server_num = ServerNum, guild_id = GuildId, 
                                guild_name = GuildName, guild_power = GuildPower, 
                                role_id = LeaderId, role_name = LeaderName, member_num = Num} <- Val
                            ],
                        lists:append(Acc, List)
                    end
                    , [], GuildMap),
            ?PRINT("SendList ~p ~n", [SendList]),
            {ok, BinData} = pt_186:write(18655, [SendList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast({'get_change_info', _Camp}, State) ->
    self() ! {'update_member_list'},
    {noreply, State};

do_handle_cast({'role_die_handle', _Arg1, Arg2, _Arg3}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    {_, Camp} = Arg2,
    case maps:get(Camp, CampMap, false) of
        false -> skip;
        CampInfo ->
            IsRetreat = lib_seacraft_extra_api:get_sea_retreat(CampInfo),
            lib_seacraft_daily:die_handle(IsRetreat, _Arg1, Arg2, _Arg3)
    end,
    {noreply, State};

do_handle_cast({'sync_after_join_member', Camp, GMInfos}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            #camp_info{member_list = MemberList} = CampInfo,
            [#camp_member_info{guild_id = GuildId}|_] = GMInfos,
            NewMemberListTmp = GMInfos ++ [M||M = #camp_member_info{guild_id = MGId}<-MemberList, MGId =/= GuildId],
            NewMemberList = lists:sort(fun lib_seacraft_extra:sort_member/2, NewMemberListTmp),
            NewCampInfo = CampInfo#camp_info{member_list = NewMemberList},
            NewCampMap = maps:put(Camp, NewCampInfo, CampMap),
            ?PRINT("NewMemberList ~p ~n", [NewMemberList]),
            {noreply, State#local_seacraft_state{local_camp = NewCampMap}}
    end;

do_handle_cast({'exit_camp', Camp, ServerId, GuildId}, State) ->
    #local_seacraft_state{local_camp = CampMap} = State,
    case maps:get(Camp, CampMap, false) of
        false -> {noreply, State};
        CampInfo ->
            #camp_info{member_list = MemberList} = CampInfo,
            NewMemberList = lib_seacraft_extra:exit_camp(MemberList, ServerId, GuildId),
            NewCampInfo = CampInfo#camp_info{member_list = NewMemberList},
            NewCampMap = maps:put(Camp, NewCampInfo, CampMap),
            {noreply, State#local_seacraft_state{local_camp = NewCampMap}}
    end;

do_handle_cast({'async_set_sea_brick_num', RoleId, Camp}, State) ->
    #local_seacraft_state{brick_num_map = BrickNumMap} = State,
    BrickNum = maps:get(Camp, BrickNumMap, data_sea_craft_daily:get_kv(default_brick)),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, update_sea_brick_num, [Camp, BrickNum]),
    {noreply, State};

do_handle_cast({'update_brick_num', Camp, Num}, State) ->
    #local_seacraft_state{brick_num_map = BrickNumMap} = State,
    NewBrickNumMap = BrickNumMap#{Camp => Num},
    lib_player:apply_cast_all_online(?APPLY_CAST_SAVE, lib_seacraft_daily, update_sea_brick_num, [Camp, Num]),
    NewState = State#local_seacraft_state{brick_num_map = NewBrickNumMap},
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call({'get_divide_point', Scene, Camp, GuildId}, State) ->
    #local_seacraft_state{
        local_camp = LocalCampMap, 
        act_type = {ActType, _Num},
        local_zone = LocalZoneData
    } = State,
    if
        ActType == ?ACT_TYPE_SEA_PART ->
            #camp_info{divide_point = DividPoint} = maps:get(Camp, LocalCampMap, #camp_info{}),
            {_, Point} = ulists:keyfind(GuildId, 1, DividPoint, {GuildId, 1});
        true ->
            case LocalZoneData of
                 #zone_data{divide_point = DividPoint} ->
                    {_, Point} = ulists:keyfind(Camp, 1, DividPoint, {Camp, 1});
                _ ->
                    Point = 1
            end 
    end,
    {X, Y} = lib_seacraft:get_reborn_point(Scene, Point),
    {reply, {X, Y}, State};

do_handle_call({'judge_is_in_act_time'}, State) ->
    #local_seacraft_state{start_time = StartTime, end_time = EndTime} = State,
    Nowtime = utime:unixtime(),
    if
        Nowtime >= StartTime-1800 andalso Nowtime < EndTime ->
            Reply = true;
        true ->
            Reply = false 
    end,
    {reply, Reply, State};

do_handle_call({'judge_can_disband', GuildId}, State) ->
    #local_seacraft_state{start_time = StartTime, end_time = EndTime, local_camp = CampMap} = State,
    Nowtime = utime:unixtime(),
    MapList = maps:to_list(CampMap),
    Res = calc_is_master_guild(MapList, GuildId),
    if
        Res == false ->
            Reply = true;
        Nowtime >= StartTime-1800 andalso Nowtime < EndTime ->
            Reply = true;
        true ->
            Reply = false 
    end,
    {reply, Reply, State};

do_handle_call(_, State) ->
    {reply, ok, State}.

calc_is_master_guild([], _GuildId) -> true;
calc_is_master_guild([{_, CampInfo}|T], GuildId) ->
    #camp_info{camp_master = [{_, MasterGuildId}|_]} = CampInfo,
    if
        GuildId == MasterGuildId ->
            false;
        true ->
            calc_is_master_guild(T, GuildId)
    end.

do_handle_info({'update_member_list'}, State) ->
    #local_seacraft_state{local_camp = CampMap, change_info = ChangeInfo, start_time = StartTime} = State,
    NewCampMap =
        maps:fold(
            fun(C, InfoTuple, CMap) ->
                case maps:get(C, CMap, false) of
                    false -> CMap;
                    #camp_info{member_list = MemberList} = CampInfo ->
                        case MemberList of
                            [] ->
                                Fun_db = fun() ->
                                    db:execute(?TRUNCATE_LOCAL_CHANGEINFO),
                                    db:execute(?TRUNCATE_LOCAL_JOIN),
                                    db:execute(?TRUNCATE_LOCAL_QUIT)
                                    end,
                                lib_goods_util:transaction(Fun_db),
                                CMap;
                            _ ->
                                {ChangeList, JoinList, QuitIdList} = InfoTuple,
                                %% 判断今天是否重置，重置的话则不同步数据了（避免数据库死锁
                                IsResetDay = lib_seacraft:is_reset_day(StartTime),
                                case IsResetDay of
                                    true -> skip;
                                    _ ->
                                        lib_seacraft_extra:send_member_to_center(C, 1, ChangeList),
                                        lib_seacraft_extra:center_member_join_quit(C, JoinList, QuitIdList)
                                end,
                                NewCampInfo = lib_seacraft_extra:update_member_list(C, CampInfo, InfoTuple),
                                Fun_db = fun() ->
                                    db:execute(?TRUNCATE_LOCAL_CHANGEINFO),
                                    db:execute(?TRUNCATE_LOCAL_JOIN),
                                    db:execute(?TRUNCATE_LOCAL_QUIT)
                                         end,
                                lib_goods_util:transaction(Fun_db),
                                maps:put(C, NewCampInfo, CMap)
                        end
                end
            end
            , CampMap, ChangeInfo),
    NewRef = util:send_after(State#local_seacraft_state.upd_ref, ?UPDATE_TIME_LIMIT * 60 * 1000, self(), {'update_member_list'}),
    {noreply, State#local_seacraft_state{local_camp = NewCampMap, change_info = #{}, upd_ref = NewRef}};

do_handle_info({'init_sync'}, State) ->
    #local_seacraft_state{is_init = IsInit, init_ref = OldInitRef} = State,
    case IsInit of
        ?NO_INIT ->
            ServerInfo = lib_seacraft:get_server_info(),
            mod_kf_seacraft:local_init(ServerInfo),
            NewInitRef = util:send_after(OldInitRef, 30*1000, self(), {'init_sync'});
        _ ->
            NewInitRef = undefined, util:cancel_timer(OldInitRef)
    end,
%%    ?PRINT("==================wait sync data====================== ~n", []),
    {noreply, State#local_seacraft_state{init_ref = NewInitRef}};

do_handle_info(_Msg, State) ->
    {noreply, State}.



calc_new_camp_map([{guild_map, List}|T], LocalCampMap) when is_list(List) ->
    Fun = fun({Camp, NewMap}, Acc) ->
        CampInfo = maps:get(Camp, Acc, #camp_info{}),
        maps:put(Camp, CampInfo#camp_info{guild_map = NewMap}, Acc)
    end,
    NewCampMap = lists:foldl(Fun, LocalCampMap, List),
    ServerId = config:get_server_id(),
    MapList = maps:to_list(NewCampMap),
    F = fun({Camp, #camp_info{guild_map = GuildMap}}, Acc) ->
        CampGuildList = maps:get(ServerId, GuildMap, []),
        GuildIdList = [GuildId || #sea_guild{guild_id = GuildId} <- CampGuildList],
        [{Camp, GuildIdList}|Acc]
    end,
    GuildCampList = lists:foldl(F, [], MapList),
    mod_guild:update_guild_realm(GuildCampList),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{guild_map, Camp, GuildList}|T], LocalCampMap) when is_list(GuildList) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    #camp_info{guild_map = OldMap} = CampInfo,
    Fun = fun
        (#sea_guild{server_id = Key, guild_id = GuildId} = Value, AccMap) ->
            List = maps:get(Key, AccMap, []),
            NewList = lists:keystore(GuildId, #sea_guild.guild_id, List, Value),
            maps:put(Key, NewList, AccMap);
        ({Key, #sea_guild{guild_id = GuildId} = Value}, AccMap) ->
            List = maps:get(Key, AccMap, []),
            NewList = lists:keystore(GuildId, #sea_guild.guild_id, List, Value),
            maps:put(Key, NewList, AccMap);
        ({Key, GuildId}, AccMap) -> 
            List = maps:get(Key, AccMap, []),
            NewList = lists:keydelete(GuildId, #sea_guild.guild_id, List),
            maps:put(Key, NewList, AccMap);
        (_E, AccMap) ->
            ?ERR("guild_map Element:~p~n",[_E]),
            AccMap
    end,
    NewMap = lists:foldl(Fun, OldMap, GuildList),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{guild_map = NewMap}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{job_list, Camp, delete}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{job_list = []}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{job_list, Camp, JobList}|T], LocalCampMap) ->
    ServerId = config:get_server_id(),
    LimitNum = data_seacraft:get_value(job_limit_num),
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    #camp_info{job_list = OldJobList1} = CampInfo,
    OldJobList = lists:keydelete(0, #sea_job.role_id, OldJobList1),
    Fun1 = fun
        (#sea_job{role_id = RId} = Value, Acc) ->
            {ok, Bin} = pt_186:write(18626, [1]),
            lib_server_send:send_to_uid(RId, Bin),
            lists:keystore(RId, #sea_job.role_id, Acc, Value);
        (RId, Acc) when is_integer(RId) ->
            {ok, Bin} = pt_186:write(18626, [1]),
            lib_server_send:send_to_uid(RId, Bin),
            lists:keydelete(RId, #sea_job.role_id, Acc);
        (delete, _) -> [];
        (_E, Acc) -> ?ERR("job_list Element:~p~n",[_E]),Acc
    end,
    NewJobList = lists:foldl(Fun1, OldJobList, JobList),
    Fun = fun
        (#sea_job{server_id = SerId, server_num = SerNum, role_id = RId, role_name = RName, 
        role_lv = RLv, job_id = JobId, combat_power = Power, picture = Picture, picture_ver = PictureVer}, {Sum, Acc, Acc1}) ->
            {Sum+1, [{JobId, SerId, SerNum, RId, RName, RLv, Picture, PictureVer, Power}|Acc], ?IF(ServerId == SerId, [RId|Acc1], Acc1)};
        (_, Acc) -> Acc
    end,
    {Length, SendList, RoleIdList} = lists:foldl(Fun, {0,[], []}, NewJobList),
    {ok, BinData} = pt_186:write(18601, [LimitNum, Length, 1, SendList]),
    lib_server_send:send_to_all(all_include, RoleIdList, BinData),

    NewCampMap = maps:put(Camp, CampInfo#camp_info{job_list = NewJobList}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{application_list, Camp, delete}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    #camp_info{camp_master = [{MasterSerId, MasterGuildId}|_], guild_map = GuildMap} = CampInfo,
    GuildList = maps:get(MasterSerId, GuildMap, []),
    ServerId = config:get_server_id(),
    case lists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{role_id = RoleId} when MasterSerId == ServerId ->
            {ok, BinData} = pt_186:write(18604, [[]]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            skip
    end,
    NewCampMap = maps:put(Camp, CampInfo#camp_info{application_list = []}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{application_list, Camp, ApplyList}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    #camp_info{camp_master = [{MasterSerId, MasterGuildId}|_], guild_map = GuildMap, application_list = OldApplyList} = CampInfo,
    Fun1 = fun
        (#sea_apply{role_id = RId} = Value, Acc) ->
            lists:keystore(RId, #sea_apply.role_id, Acc, Value);
        (RId, Acc) when is_integer(RId) ->
            lists:keydelete(RId, #sea_apply.role_id, Acc);
        (_E, Acc) ->
            ?ERR("application_list Element:~p~n",[_E]),Acc
    end,
    NewApplyList = lists:foldl(Fun1, OldApplyList, ApplyList),

    GuildList = maps:get(MasterSerId, GuildMap, []),
    ServerId = config:get_server_id(),
    case lists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{role_id = RoleId} when MasterSerId == ServerId ->
            Fun = fun
                (#sea_apply{picture = Picture, picture_ver = PictureVer, role_lv = RoleLv, role_id = RId, role_name = RoleName, combat_power = Power}, Acc) ->
                    [{Picture, PictureVer, RoleLv, RId, RoleName, Power}|Acc];
                (_, Acc) -> Acc
            end,
            SendList = lists:foldl(Fun, [], NewApplyList),
            {ok, BinData} = pt_186:write(18604, [SendList]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            skip
    end,
    NewCampMap = maps:put(Camp, CampInfo#camp_info{application_list = NewApplyList}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{join_limit, Camp, JoinLimit}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{join_limit = JoinLimit}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{score_list, Camp, ScoreList}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    #camp_info{score_list = OldScoreList} = CampInfo,
    Fun = fun
        ({_, GuildId, _, _} = Value, Acc) ->
            lists:keystore(GuildId, 2, Acc, Value);
        (_E, Acc) ->
            ?ERR("score_list Element:~p~n",[_E]),Acc
    end,
    NewScoreList = lists:foldl(Fun, OldScoreList, ScoreList),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{score_list = NewScoreList}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{role_score_map, Camp, RoleScoreMap}|T], LocalCampMap) when is_map(RoleScoreMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{role_score_map = RoleScoreMap}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{role_score_map, Camp, RoleScoreList}|T], LocalCampMap) when is_list(RoleScoreList) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    #camp_info{role_score_map = OldRoleScoreMap} = CampInfo,
    Fun = fun
        ({Key, #sea_score{role_id = AtterRoleId} = Value}, AccMap) ->
            lib_activitycalen_api:role_success_end_activity(AtterRoleId, 186, 1),
            List = maps:get(Key, AccMap, []),
            NewList = lists:keystore(AtterRoleId, #sea_score.role_id, List, Value),
            maps:put(Key, NewList, AccMap);
        (_E, Acc) ->
            ?ERR("role_score_map Element:~p~n",[_E]),Acc
    end,
    NewRoleScoreMap = lists:foldl(Fun, OldRoleScoreMap, RoleScoreList),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{role_score_map = NewRoleScoreMap}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{camp_master, Camp, Master}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{camp_master = Master, camp_mon = [], att_def = [], hurt_list = [], 
        divide_point = []}, LocalCampMap),
    lib_activitycalen_api:success_end_activity(186, 1),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{camp_mon, Camp, MonList}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    #camp_info{camp_mon = OldMonList} = CampInfo,
    Fun = fun
        ({MonId, _, _, _, _} = Value, Acc) ->
            lists:keystore(MonId, 1, Acc, Value);
        (_E, Acc) ->
            ?ERR("camp_mon Element:~p~n",[_E]),Acc
    end,
    NewMonList = lists:foldl(Fun, OldMonList, MonList),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{camp_mon = NewMonList}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{att_def, Camp, AttdefList}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{att_def = AttdefList}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{divide_point, Camp, DividPoint}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{divide_point = DividPoint}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map([{win_reward, Camp, WinReward}|T], LocalCampMap) ->
    CampInfo = maps:get(Camp, LocalCampMap, #camp_info{}),
    NewCampMap = maps:put(Camp, CampInfo#camp_info{win_reward = WinReward}, LocalCampMap),
    calc_new_camp_map(T, NewCampMap);
calc_new_camp_map(_L, LocalCampMap) ->_L =/= [] andalso ?ERR("calc_new_zone_data _L:~p~n",[_L]), LocalCampMap.

calc_new_zone_data([{sea_master, SeaMaster}|T], LocalZoneData) ->
    lib_activitycalen_api:success_end_activity(186, 1),
    calc_new_zone_data(T, LocalZoneData#zone_data{sea_mon = [], att_def = [], hurt_list = [],
        divide_point = [], sea_master = SeaMaster});
calc_new_zone_data([{sea_mon, MonList}|T], LocalZoneData) ->
    #zone_data{sea_mon = OldMonList} = LocalZoneData,
    Fun = fun
        ({MonId, _, _, _, _} = Value, Acc) ->
            lists:keystore(MonId, 1, Acc, Value);
        (_E, Acc) ->
            ?ERR("sea_mon Element:~p~n",[_E]),Acc
    end,
    NewMonList = lists:foldl(Fun, OldMonList, MonList),
    calc_new_zone_data(T, LocalZoneData#zone_data{sea_mon = NewMonList});
calc_new_zone_data([{att_def, AttdefList}|T], LocalZoneData) ->
    NewZoneData = LocalZoneData#zone_data{att_def = AttdefList},
    calc_new_zone_data(T, NewZoneData);
calc_new_zone_data([{score_list, ScoreList}|T], LocalZoneData) ->
    #zone_data{score_list = OldScoreList} = LocalZoneData,
    Fun = fun
        ({Camp, _, _} = Value, Acc) ->
            lists:keystore(Camp, 1, Acc, Value);
        (_E, Acc) ->
            ?ERR("score_list Element:~p~n",[_E]),Acc
    end,
    NewScoreList = lists:foldl(Fun, OldScoreList, ScoreList),
    NewZoneData = LocalZoneData#zone_data{score_list = NewScoreList},
    calc_new_zone_data(T, NewZoneData);
calc_new_zone_data([{role_score_map, RoleScoreMap}|T], LocalZoneData) when is_map(RoleScoreMap) ->
    NewZoneData = LocalZoneData#zone_data{role_score_map = RoleScoreMap},
    calc_new_zone_data(T, NewZoneData);
calc_new_zone_data([{role_score_map, RoleScoreList}|T], LocalZoneData) when is_list(RoleScoreList) ->
    #zone_data{role_score_map = OldRoleScoreMap} = LocalZoneData,
    Fun = fun
        ({Key, #sea_score{role_id = AtterRoleId} = Value}, AccMap) ->
            lib_activitycalen_api:role_success_end_activity(AtterRoleId, 186, 1),
            List = maps:get(Key, AccMap, []),
            NewList = lists:keystore(AtterRoleId, #sea_score.role_id, List, Value),
            maps:put(Key, NewList, AccMap);
        (_E, Acc) ->
            ?ERR("role_score_map Element:~p~n",[_E]),Acc
    end,
    NewRoleScoreMap = lists:foldl(Fun, OldRoleScoreMap, RoleScoreList),
    NewZoneData = LocalZoneData#zone_data{role_score_map = NewRoleScoreMap},
    calc_new_zone_data(T, NewZoneData);
calc_new_zone_data([{divide_point, DividPoint}|T], LocalZoneData) ->
    NewZoneData = LocalZoneData#zone_data{divide_point = DividPoint},
    calc_new_zone_data(T, NewZoneData);
calc_new_zone_data(_L, LocalZoneData) ->_L =/= [] andalso ?ERR("calc_new_zone_data _L:~p~n",[_L]),LocalZoneData.

calc_send_member(MemeberList) ->
    SortList = lists:reverse(lists:keysort(#sea_score.score, MemeberList)),
    Fun = fun
        (#sea_score{role_id = RoleId, role_name = RoleName, kill_num = KillNum, score = Score}, {Acc, Rank}) ->
            {[{Rank, RoleId, RoleName, KillNum, Score}|Acc], Rank+1};
        (_, Acc) -> Acc
    end,
    {List, _} = lists:foldl(Fun, {[], 1}, SortList),
    List.

judge_guild_in_attdef_list(_, []) -> false;
judge_guild_in_attdef_list(GuildId, [{_, List}|AttdefList]) ->
    case lists:keyfind(GuildId, 2, List) of
        {_, _} -> true;
        _ -> judge_guild_in_attdef_list(GuildId, AttdefList)
    end.

judge_camp_in_attdef_list(_, []) -> false;
judge_camp_in_attdef_list(Camp, [{_, List}|AttdefList]) ->
    case lists:member(Camp, List) of
        true -> true;
        _ -> judge_camp_in_attdef_list(Camp, AttdefList)
    end.

get_guild_camp_realm(_, []) -> 1;
get_guild_camp_realm(Id, [{Realm, [{_, _}|_] = List}|AttdefList]) ->
    case lists:keyfind(Id, 2, List) of
        {_, _} -> Realm;
        _ -> get_guild_camp_realm(Id, AttdefList)
    end;
get_guild_camp_realm(Id, [{Realm, List}|AttdefList]) ->
    case lists:member(Id, List) of
        true -> Realm;
        _ -> get_guild_camp_realm(Id, AttdefList)
    end.

calc_has_open([]) -> 0;
calc_has_open([{_, #camp_info{camp_master = [{_, MasterGuildId}]}}|T]) ->
    if
        MasterGuildId == 0 ->
            calc_has_open(T);
        true ->
            1
    end.

save_local_join_member(Member, Camp) ->
    #camp_member_info{
        server_id = ServerId, guild_id = GuildId,
        guild_name = GuildName, vip = Vip, role_id = RId,
        role_name = RoleName, lv = Lv, job_id = JobId,
        exploit = Exploit, fright = CombatPower
    } = Member,
    db:execute(io_lib:format(?REPLACE_LOCAL_JOIN, [Camp, ServerId, GuildId, GuildName, Vip, RId, RoleName, Lv, JobId, Exploit, CombatPower])).