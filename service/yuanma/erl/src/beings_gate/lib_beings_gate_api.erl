%%% -------------------------------------------------------------------
%%% @doc        lib_beings_gate_api
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-28 16:06
%%% @deprecated 众生之门外部调用API
%%% -------------------------------------------------------------------

-module(lib_beings_gate_api).

-include("errcode.hrl").
-include("server.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("dungeon.hrl").
-include("team.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("beings_gate.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("figure.hrl").

%% API
-export([
    act_start/2
    , add_activity_value/1
    , refresh_activity_value/0
    , match_teams/3
    , init_dungeon_role/3
    , send_reward_help_type_yes/2
    , destroy_portal/2
    , dunex_calc_auto_lv/2]).

%% -----------------------------------------------------------------
%% @desc 活动开始
%% @param ModuleSub 主类型
%% @param AcSub     子类型
%% @return
%% -----------------------------------------------------------------
act_start(ModuleSub, AcSub) -> mod_beings_gate_local:act_start(ModuleSub, AcSub).

%% -----------------------------------------------------------------
%% @desc 增加活跃度
%% @param AddValue 需增加的活跃度
%% @return
%% -----------------------------------------------------------------
add_activity_value(AddValue) ->
    ServerId = config:get_server_id(),
    mod_beings_gate_local:add_activity_value(AddValue, ServerId).

%% -----------------------------------------------------------------
%% @desc 刷新活跃度
%% @param
%% @return
%% -----------------------------------------------------------------
refresh_activity_value() ->
    mod_beings_gate_local:refresh_activity_value().

%% -----------------------------------------------------------------
%% @desc 匹配队伍
%% @param PS         玩家记录
%% @param ActivityId 主类型
%% @param SubTypeId  子类型
%% @return  {ok, NewPS}
%% -----------------------------------------------------------------
match_teams(PS, ActivityId, SubTypeId) ->
    #player_status{sid = Sid} = PS,
    Mb = lib_team_api:thing_to_mb(PS),
    ActivityList = [{ActivityId, SubTypeId}],
    mod_beings_gate_local:match_teams(Mb, ActivityList),
    LockPS = lib_player:setup_action_lock(PS, ?ERRCODE(err240_change_when_matching)),
    {ok, BinData} = pt_240:write(24023, [?SUCCESS, ActivityId, SubTypeId]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, LockPS}.

%% -----------------------------------------------------------------
%% @desc 销毁传送门
%% @param State 队伍记录 #team{}
%% @param DungeonRoleList 副本角色记录列表 [#dungeon_role{},...]
%% @return
%% -----------------------------------------------------------------
destroy_portal(State, DungeonRoleList) ->
    #team{id = TeamId} = State,
    #dungeon_role{server_id = ServerId, scene = SceneId, portal_id = PortalId, scene_pool_id = PoolId, team_position = Position} = ulists:keyfind(?TEAM_LEADER, #dungeon_role.team_position, DungeonRoleList, #dungeon_role{}),
    TeamId > 0 andalso Position =:= ?TEAM_LEADER andalso
        ?IF(util:is_cls(), mod_clusters_center:apply_cast(ServerId, mod_beings_gate_local, destroy_portal_by_id, [SceneId, PortalId, PoolId]), mod_beings_gate_local:destroy_portal_by_id(SceneId, PortalId, PoolId)).

%% -----------------------------------------------------------------
%% @desc  动态生成怪物等级
%% @param State    副本进程State
%% @param EnterLv  进入副本时玩家等级
%% @return WorldLv
%% -----------------------------------------------------------------
dunex_calc_auto_lv(_EnterLv, State) ->
    #dungeon_state{role_list = RoleList} = State,
    AutoLv = lists:max([RoleLv || #dungeon_role{figure = #figure{lv = RoleLv}, team_position = Position} <- RoleList, Position /= ?TEAM_FAKER]),
    AutoLv.

%% -----------------------------------------------------------------
%% @desc 初始化副本角色记录
%% @param Player 玩家记录
%% @param Dun 副本记录 #dungeon{}
%% @param Role 副本角色记录 #dungeon_role{}
%% @return #dungeon_role{}
%% -----------------------------------------------------------------
init_dungeon_role(Player, Dun, Role) ->
    #player_status{
        id            = RoleId,
        scene         = SceneId,
        scene_pool_id = ScenePoolId,
        copy_id       = CopyId,
        x             = X,
        y             = Y,
        portal_id     = PortalId
    } = Player,
    #dungeon{id = DunId, type = DunType} = Dun,
    CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
    HelpNum = mod_daily:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP_AWARD, CountType),
    AutoLv = ?IF(SceneId == ?SCENE_LOCAL, util:get_world_lv(), lib_clusters_node_api:get_avg_world_lv(?MOD_BEINGS_GATE)),
    ?IF(SceneId =:= ?SCENE_LOCAL orelse SceneId =:= ?SCENE_CENTER,
        Role#dungeon_role{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, portal_id = PortalId, typical_data = #{help_num => HelpNum}, auto_lv = AutoLv},
        Role#dungeon_role{typical_data = #{help_num => HelpNum}, auto_lv = AutoLv}).

%% -----------------------------------------------------------------
%% @desc 给协助玩家发送奖励
%% @param State 副本状态记录 #dungeon_state{}
%% @param DunRole 副本角色记录 #dungeon_role{}
%% @return RewardList
%% -----------------------------------------------------------------
send_reward_help_type_yes(State, DunRole) ->
    #dungeon_role{id = RoleId, node = Node, typical_data = TypicalData} = DunRole,
    #dungeon_state{dun_id = DunId, dun_type = DunType} = State,
    %?MYLOG("lwcbeings","{DunId, DunType}:~p~n",[{DunId, DunType}]),
    case data_dungeon_special:get(DunId, help_rewards) of
        {NumLimit, Rewards} ->
            HelpNum = maps:get(help_num, TypicalData, NumLimit),
            LeftNum = NumLimit - HelpNum,
            if
                LeftNum > 0 ->
                    CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
                    unode:apply(Node, mod_daily, increment_offline, [RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP_AWARD, CountType]),
                    %?MYLOG("lwcbeings","reward:~p~n",[{?REWARD_SOURCE_DUNGEON, Rewards}]),
                    [{?REWARD_SOURCE_DUNGEON, Rewards}];
                true -> []
            end;
        _ -> []
    end.
