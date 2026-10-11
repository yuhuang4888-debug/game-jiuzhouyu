%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 跨服大妖boss 关于数据库的操作API
%%% @end
%%% Created : 21. 11月 2022 11:45
%%%-------------------------------------------------------------------
-module(lib_great_demon_sql).

-include("kf_great_demon.hrl").
-include("common.hrl").
-include("def_fun.hrl").

%% API
-compile(export_all).


%% 保存boss的刷新时间
update_boss_reborn_time(BossId, RebornTime) ->
    SQL = <<"replace into `boss` set `boss_id` = ~p, `reborn_time` = ~p">>,
    db:execute(io_lib:format(SQL, [BossId, RebornTime])).


%% 加载秘境boss击杀
load_great_demon_kill() ->
    List = db_role_kf_domain_boss_kill_select(),
    F = fun([RoleId, KillNum, GetListBin]) ->
        GetList = util:bitstring_to_term(GetListBin),
        #kf_domain_boss_kill{role_id = RoleId, kill_num = KillNum, get_list = GetList}
    end,
    lists:map(F, List).

%% 获取秘境boss击杀
db_role_kf_domain_boss_kill_select() ->
    Sql = io_lib:format(<<"SELECT role_id, kill_num, get_list FROM role_great_demon_boss_kf_kill">>, []),
    db:get_all(Sql).

%% 插入秘境boss数据
db_role_kf_domain_boss_kill_replace(BossKill) ->
    #kf_domain_boss_kill{role_id = RoleId, kill_num = KillNum, get_list = GetList} = BossKill,
    GetListBin = util:term_to_bitstring(GetList),
    Sql = io_lib:format(<<"REPLACE INTO role_great_demon_boss_kf_kill(role_id, kill_num, get_list) VALUES(~p, ~p, '~s')">>, [RoleId, KillNum, GetListBin]),
    db:execute(Sql).

%% 清理数据
db_role_demon_boss_kill_truncate() ->
    Sql = io_lib:format(<<"TRUNCATE TABLE role_great_demon_boss_kf_kill">>, []),
    db:execute(Sql).

log_great_demon_boss_kf(ZoneId, BossId, AttrRoleId, AttrRoleName, BeRoleIdL, RoleInfoMap) ->
    NowSec = utime:unixtime(),
    case maps:get({ZoneId, AttrRoleId}, RoleInfoMap, none) of
        none -> KPForm = "none", KSName = "none";
        #kf_role_info{ plat_form = KPForm, server_name = KSName } -> ok
    end,
    Fun = fun({BlRoleId, _ServerId}, TemLogBlList) ->
        if
            AttrRoleId == BlRoleId ->
                [uio:format("{1}_{2}_{3}_{4}", [AttrRoleId, AttrRoleName, KPForm, KSName])|TemLogBlList];
            true ->
                case maps:get({ZoneId, BlRoleId}, RoleInfoMap, none) of
                    none ->
                        [uio:format("{1}_{2}_{3}_{4}", [BlRoleId, none, none, none])|TemLogBlList];
                    #kf_role_info{name = BlName, plat_form = BlPForm, server_name = BlSName} ->
                        [uio:format("{1}_{2}_{3}_{4}", [BlRoleId, BlName, BlPForm, BlSName])|TemLogBlList]
                end
        end
    end,
    case lists:foldl(Fun, [], BeRoleIdL) of
        [Bl1, Bl2, Bl3] -> skip;
        [Bl1, Bl2] -> Bl3 = "none";
        [Bl1] -> Bl2 = "none", Bl3 = "none";
        _ -> Bl1 = "none", Bl2 = "none", Bl3 = "none"
    end,
    lib_log_api:log_great_demon_boss_kf(ZoneId, BossId, AttrRoleId, AttrRoleName, KPForm, KSName, Bl1, Bl2, Bl3, NowSec).