%%%------------------------------------
%%% @Module  :  lib_ranking_api
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 榜单
%%%------------------------------------

-module(lib_common_rank_api).

-export([
         handle_event/2,
         reflash_rank_by_guild/1,
        % reflash_rank_by_career/1,
         reflash_rank_by_equipment/1,
         reflash_rank_by_partner/1,
         login/1,
         logout/1,
         timer_common_rank/0,
         refresh_average_lv_20/1,
         server_combat_power_10/0
        ]).

-compile(export_all).

-include("common_rank.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("record.hrl").
-include("def_module.hrl").
-include("role.hrl").
-include("dungeon.hrl").
-include("mount.hrl").

%% 等级排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    refresh_common_rank(Player, ?RANK_TYPE_LV),
    {ok, Player};

%% 战力排行榜、 职业排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
    refresh_common_rank(Player, ?RANK_TYPE_COMBAT),
    %% reflash_rank_by_career(Player),
    {ok, Player};

%% 转职
handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Player, player_status) ->
    mod_common_rank:update_login_time(Player#player_status.id),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_TRANSFER}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{sex = Sex}} = Player,
    mod_common_rank:change_rank_by_type(RoleId, lib_common_rank:get_old_type_by_sex(Sex), lib_common_rank:get_rank_type_by_sex(Sex)),
    {ok, Player};

%% handle_event(Player, #event_callback{type_id = ?EVENT_PICTURE_CHANGE}) when is_record(Player, player_status) ->
%%     reflash_role_info(Player),
%%     {ok, Player};

%% handle_event(Player, #event_callback{type_id = ?EVENT_TITLE_PROMOTE}) when is_record(Player, player_status) ->
%%     reflash_role_info(Player),
%%     {ok, Player};

%% handle_event(Player, #event_callback{type_id = ?EVENT_RENAME}) when is_record(Player, player_status) ->
%%     reflash_role_info(Player),
%%     {ok, Player};

handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.


%% --------------------------------------------------------------------------

get_ranklist(RankType, Start, Len) ->  % ?RANK_TYPE_COMBAT 战力榜
    mod_common_rank:get_ranklist(RankType, Start, Len).

%% 
reflash_rank_by_guild(Guild) when is_record(Guild, guild) ->
    refresh_common_rank(Guild, ?RANK_TYPE_GUILD).

%% 获取公会排行第一的 称号
get_guild_title_id() -> 
    lib_common_rank:get_title_id(?RANK_TYPE_GUILD).

%% 解散公会
disband_guild(GuildId) -> 
    mod_common_rank:disband_guild(GuildId, [?RANK_TYPE_GUILD]).

%----------------------------------------------------------------------------
%% 家园排行榜
reflash_rank_by_home(_HomeId, _RoleId1, _RoleId2, _AddPopularity) -> ok.
    %?PRINT("~p~n", [[HomeId, RoleId1, RoleId2, AddPopularity]]),
    % refresh_common_rank({HomeId, RoleId1, RoleId2, AddPopularity}, ?RANK_TYPE_HOME).

%% 移除榜上的
remove_rank_home(_HomeId) -> ok.
    %?PRINT("~p~n", [HomeId]),
    %mod_common_rank:remove_rank_home(HomeId).

%% 删除数据
delete_home(_HomeId) -> ok.
    %?PRINT("~p~n", [HomeId]),
    % mod_common_rank:delete_home(_HomeId).

%% 人员变动
home_role_change(_HomeId, _RoleId1, _RoleId2) ->ok.
   % ?PRINT("~p~n", [[HomeId, RoleId1, RoleId2]]),
    % mod_common_rank:home_role_change(HomeId, RoleId1, RoleId2).

%% 被移除的重新上榜
home_rerank(_HomeId) ->ok.
    %?PRINT("~p~n", [HomeId]),
    % mod_common_rank:home_rerank(HomeId).

%% 同步公会榜单
% sync_guild_rank() ->
%     mod_common_rank:sync_guild_rank().

%% 职业排行榜
%%reflash_rank_by_career(Player) ->
%%    CareerId = case Player#player_status.figure#figure.career of
%%                   1 -> ?RANK_TYPE_CAREER1;
%%                   2 -> ?RANK_TYPE_CAREER2;
%%                   3 -> ?RANK_TYPE_CAREER3;
%%
%%               end,
%%    refresh_common_rank(Player, CareerId).

%% 装备排行榜
reflash_rank_by_equipment(Player) -> 
    refresh_common_rank(Player, ?RANK_TYPE_EQUIPMENT).

%% 洗炼
reflash_rank_by_equipment_biptize(_Player) -> ok.
    %refresh_common_rank(Player, ?RANK_TYPE_EQUIPMENT_BAPTIZE).

%% 强化
reflash_rank_by_equipment_strengthen(_Player) -> ok.
    %refresh_common_rank(Player, ?RANK_TYPE_EQUIPMENT_STRENGTHEN).

%% 镶嵌
reflash_rank_by_equipment_inlay(_Player) -> ok.
   %refresh_common_rank(Player, ?RANK_TYPE_EQUIPMENT_INLAY).

%% 伙伴排行榜
reflash_rank_by_partner(_Player) -> ok.
    %% refresh_common_rank(Player, ?RANK_TYPE_PARTNER).
  
%% 成就排行榜
reflash_rank_by_achieve(_RoleId) -> ok.
    %refresh_common_rank(RoleId, ?RANK_TYPE_ACHIEVE). 

refresh_rank_by_baby(_Player) -> ok.
    %refresh_common_rank(Player, ?RANK_TYPE_BABY).

refresh_rank_by_pet_aircraft(_Player) -> ok.
    %refresh_common_rank(Player, ?RANK_TYPE_PET_AIRCRAFT).

refresh_rank_by_holy_ghost(_Player) ->ok.
    %refresh_common_rank(Player, ?RANK_TYPE_HOLY_GHOST).

refresh_rank_by_pet_wing(_Player) ->ok.
    % refresh_common_rank(Player, ?RANK_TYPE_PET_WING).

refresh_rank_by_juewei(Player) ->
    refresh_common_rank(Player, ?RANK_TYPE_JUEWEI).

%%符文排行榜
refresh_rank_by_rune(_Player) -> ok.
    % refresh_common_rank(Player, ?RANK_TYPE_RUNE).

%% 爬塔副本排行榜
refresh_rank_by_dun(Player, DunType) ->
    if
        DunType == ?DUNGEON_TYPE_TOWER ->
            refresh_common_rank(Player, ?RANK_TYPE_TOWER_DUN);
        true ->
            ok
    end.
refresh_rank_by_jjc_rank(RoleId, RivalId) ->
    refresh_common_rank(RoleId,?RANK_TYPE_JJC),
    if
        RivalId =/= 0 ->
            refresh_common_rank(RivalId,?RANK_TYPE_JJC);
        true ->
            skip
    end.

%% 挂机经验收益排行
refresh_rank_by_afk(RoleId, PerMExp) ->
    refresh_common_rank({RoleId, PerMExp}, ?RANK_TYPE_AFK).

%%升阶类排行榜的刷新
refresh_rank_by_upgrade(Player, TypeId) ->
    case TypeId of
        ?MOUNT_ID ->
            refresh_common_rank(Player,?RANK_TYPE_MOUNT);
        ?MATE_ID -> 
            refresh_common_rank(Player,?RANK_TYPE_MATE);
        ?FLY_ID ->
            refresh_common_rank(Player,?RANK_TYPE_WING);
        ?ARTIFACT_ID ->
            refresh_common_rank(Player,?RANK_TYPE_AIRCRAFT);
        ?HOLYORGAN_ID -> 
            refresh_common_rank(Player,?RANK_TYPE_HOLYORGAN);
        ?SPIRIT_ID ->
            refresh_common_rank(Player,?RANK_TYPE_SPIRIT);
        ?PET_ID ->
            refresh_common_rank(Player,?RANK_TYPE_FLYPET);
        _ ->
            ok
    end.

get_rank_type(TypeId) ->
    case TypeId of
        ?MOUNT_ID ->
            ?RANK_TYPE_MOUNT;
        ?MATE_ID -> 
            ?RANK_TYPE_MATE;
        ?FLY_ID ->
            ?RANK_TYPE_WING;
        ?ARTIFACT_ID ->
            ?RANK_TYPE_AIRCRAFT;
        ?HOLYORGAN_ID -> 
            ?RANK_TYPE_HOLYORGAN;
        ?SPIRIT_ID ->
            ?RANK_TYPE_SPIRIT;
        ?PET_ID ->
            ?RANK_TYPE_FLYPET;
        _ ->
            0
    end.

%% 每5分钟排次序
%% 除了工会和个人离线收益，其余都是实时排行榜
timer_common_rank() ->
    mod_common_rank:timer_common_rank(?RANK_TYPE_GUILD),
    mod_common_rank:timer_common_rank(?RANK_TYPE_AFK).
%%    [ mod_common_rank:timer_common_rank(Type) || Type <- ?RANK_TYPE_LIST ].


login(Player) ->
    refresh_common_rank_by_all(Player),
    ok.

logout(_Player) ->
    %refresh_common_rank_by_all(Player),
    ok.

%% 刷新榜单,最好在里面统一处理,修改方便
refresh_common_rank(Info, RankType) when RankType =:= ?RANK_TYPE_GUILD
    orelse RankType =:= ?RANK_TYPE_TOWER_DUN orelse RankType =:= ?RANK_TYPE_AFK ->
    lib_common_rank:refresh_common_rank(RankType, Info);
refresh_common_rank(PlayInfo, RankType) when is_record(PlayInfo, player_status) ->
    #player_status{figure = #figure{lv = Lv}} = PlayInfo,
    case Lv >= lib_module:get_open_lv(?MOD_RANK, 1) of
        true ->
            lib_common_rank:refresh_common_rank(RankType, PlayInfo);
        _ -> skip
    end;
refresh_common_rank(RoleId, RankType) when is_integer(RoleId) ->
    if
        RankType == ?RANK_TYPE_COMBAT orelse RankType == ?RANK_TYPE_LV ->
            % orelse RankType == ?RANK_TYPE_CHARM_BOY orelse RankType == ?RANK_TYPE_CHARM_GIRL ->
            Lv = case lib_role:get_role_show(RoleId) of
                     [] -> 0;
                     #ets_role_show{figure = TmpFigure} -> TmpFigure#figure.lv
                 end,
            case Lv >= lib_module:get_open_lv(?MOD_RANK, 1) of
                true -> lib_common_rank:refresh_common_rank(RankType, RoleId);
                _ -> skip
            end;
        true -> lib_common_rank:refresh_common_rank(RankType, RoleId)
    end.

gm_refresh_rank(Player, TypeId) ->
    RankType = get_rank_type(TypeId),
    RankTypeL = ?RANK_TYPE_LIST,
    case lists:member(RankType, RankTypeL) of
        true ->
            lib_common_rank:gm_refresh_rank(Player, RankType);
        _ -> 
            false
    end.

%% 刷新榜单数据。
refresh_common_rank_by_all(Player) ->
    [ refresh_common_rank(Player, RankType) || RankType <-  ?RANK_TYPE_LIST].

%% 刷新前20名玩家
refresh_average_lv_20(_DelaySec) ->
    util:rand_time_to_delay(1000, mod_common_rank, refresh_average_lv_20, []).
    %% DbCleanSleepTime = urand:rand(1, 1000),
    %% spawn(
    %%   fun() -> timer:sleep(DbCleanSleepTime), mod_common_rank:refresh_average_lv_20() end
    %%  ).

%% 刷新服战力
refresh_server_combat_power_10(DelaySec) ->
    util:rand_time_to_delay(DelaySec, mod_common_rank, refresh_server_combat_power_10, []).

%% 服战力
server_combat_power_10() -> 
    case catch lib_common_rank_api:get_ranklist(?RANK_TYPE_COMBAT, 1, 10) of
        CP when is_integer(CP) -> CP;
        _ -> 1
    end.
    
