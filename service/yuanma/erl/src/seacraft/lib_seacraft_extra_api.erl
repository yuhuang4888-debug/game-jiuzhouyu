%%%-------------------------------------------------------------------
%%% @author luzhiheng
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% 海域基础2.0  对外接口
%%% @end
%%% Created : 11. Feb 2020 9:12 AM
%%%-------------------------------------------------------------------
-module(lib_seacraft_extra_api).
-author("luzhiheng").

%% API
-export([
     get_sea_muted/1
    ,get_sea_retreat/1
    ,add_exploit/3
    ,handle_event/2
    ,get_camp_id/1
    ,get_member_job/3
    ,gm_fix_exploit/1
]).

-include("common.hrl").
-include("server.hrl").
-include("seacraft.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

%% 获取禁言状态
%% 海域进程内调用
%% @param CampInfo 阵营信息
%% @return true：已禁言  false：未禁言
get_sea_muted(CampInfo) when is_record(CampInfo, camp_info) ->
    get_privilege_open(?PRI_SEA_MUTED, CampInfo);
get_sea_muted(_) ->
    true.

%% 获取封边状态
%% 海域进程内调用
%% @param CampInfo 阵营信息
%% @return true：已封边  false：未封边
get_sea_retreat(CampInfo) when is_record(CampInfo, camp_info) ->
    get_privilege_open(?PRI_SEA_RETREAT, CampInfo);
get_sea_retreat(_) ->
    true.

get_privilege_open(PrivilegeId, #camp_info{privilege_status = PrivilegeStatus}) ->
    case lists:keyfind(PrivilegeId, #privilege_item.privilege_id, PrivilegeStatus) of
        #privilege_item{status = Status} -> Status == ?PRIVILEGE_OPEN;
        _ ->
            false
    end.

%% 获取角色的职位
%% @param MemberList [{server_id, guild_id, guild_name, vip, role_id, role_name, lv, job_id, exploit, fright}]
%% @param RoleId
%% @param Camp 阵营id，用于错误日志保存
%% @return job_id
get_member_job(MemberList, RoleId, _Camp) ->
    case lists:keyfind(RoleId, #camp_member_info.role_id, MemberList) of
        false ->?SEA_MEMBER;
        #camp_member_info{job_id = JobId} -> JobId
    end .


%% 获得功勋
%% @param Ps
%% @param Exploit 获得的功勋
%% @param Extra 产出
%% @return NewPs
add_exploit(Ps, Exploit, Extra) ->
    #player_status{figure = Figure, id = RoleId} = Ps,
    #figure{exploit = OldExp, name = RoleName} = Figure,
    TureExploit = cal_true_get_exploit(Ps, Exploit),
    if
        TureExploit == 0 -> Ps;
        true ->
            NewExploit = OldExp + TureExploit,
            NewPs = Ps#player_status{figure = Figure#figure{exploit = NewExploit}},
            db:execute(io_lib:format(?REPLACE_ROLE_EXPLOIT, [RoleId, NewExploit])),
            event(NewPs),
            lib_log_api:log_seacraft_exploit(RoleId, RoleName, Exploit, NewExploit, Extra),
            LastPlayer = lib_player:count_player_attribute(NewPs),
            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
            mod_scene_agent:update(LastPlayer, [{battle_attr, LastPlayer#player_status.battle_attr}]),
            pp_seacraft_extra:do_handle(18653, LastPlayer, []),
            LastPlayer
    end.

handle_event(PS, #event_callback{type_id = TypeId}) when is_record(PS, player_status) ->
    TypeList = [?EVENT_LV_UP, ?EVENT_RENAME, ?EVENT_VIP],
    ?IF(lists:member(TypeId, TypeList), event(PS), skip),
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.

event(Ps) ->
    #player_status{id = RoleId, figure = Figure, guild = StatusGuild, combat_power = CombatPower} = Ps,
    #figure{vip = Vip, name = RName, lv = Lv, exploit = Exploit} = Figure,
    #status_guild{realm = Camp} = StatusGuild,
    Info = {Vip, RoleId, RName, Lv, Exploit, CombatPower},
    mod_seacraft_local:update_member_item(Camp, Info).

get_camp_id(PS) ->
    case PS of
        #player_status{guild = #status_guild{realm = Camp}} ->
            Camp;
        _ -> 0
    end.

%% 计算真实获取的功勋值
%% 每天最多获取1500功勋值
cal_true_get_exploit(#player_status{id = RoleId}, Exploit) ->
    HadGetExploit = mod_daily:get_count(RoleId, ?MOD_SEACRAFT_DAILY, 2),
    LimitExploit = data_sea_craft_daily:get_kv(daily_exploit_limit),
    if
        HadGetExploit + Exploit >= LimitExploit ->
            mod_daily:set_count(RoleId, ?MOD_SEACRAFT_DAILY, 2, LimitExploit),
            LimitExploit - HadGetExploit;
        true ->
            mod_daily:set_count(RoleId, ?MOD_SEACRAFT_DAILY, 2, HadGetExploit + Exploit),
            Exploit
    end.

gm_fix_exploit(Ps) ->
    #player_status{id = RoleId, figure = Figure} = Ps,
    Sql = io_lib:format("select `exploit` from `log_seacraft_exploit` where `role_id` = ~p order by `id`", [RoleId]),
    List = db:get_all(Sql),
    case List of
        [] -> Ps;
        _ ->
            Exploits = lists:flatten(List),
            NewExploit = fix_done(Exploits, []),
            db:execute(io_lib:format(?REPLACE_ROLE_EXPLOIT, [RoleId, NewExploit])),
            Ps#player_status{figure = Figure#figure{exploit = NewExploit}}
    end.


fix_done([E|_]=H, SpeList) when length(H) == 1 ->
    lists:sum(SpeList) + E;
fix_done([H|T], SpeList) ->
    [T1|_] = T,
    if
        T1 > H -> fix_done(T, SpeList);
        true ->
            fix_done(T, [H|SpeList])
    end.

