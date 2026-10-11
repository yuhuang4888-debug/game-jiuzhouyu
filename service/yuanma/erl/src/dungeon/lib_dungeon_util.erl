%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_util.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-06-20
%% @deprecated 公用函数,规则函数,不跟副本进程和玩家进程直接挂钩
%% ---------------------------------------------------------------------------
-module(lib_dungeon_util).
-export([]).

-compile(export_all).
-include("dungeon.hrl").
-include("common.hrl").
-include("team.hrl").

%% 获得首次创建伙伴的属性Map.Pos=1,2
%% @return #{Pos:={X, Y, AttrList}}
get_first_create_partner_pos_map(Dun, SceneId, ScenePoolId, CopyId, X, Y) ->
    #dungeon{condition = Cond} = Dun,
    case lists:keyfind(create_partner, 1, Cond) of
        false -> get_create_partner_pos_map(SceneId, ScenePoolId, CopyId, X, Y);
        {create_partner, List} ->
            % Pos = 1
            case lists:keyfind(?DUN_CREATE_PARTNER_POS_1, 1, List) of
                false -> DataMap1 = get_create_partner_pos_map(?DUN_CREATE_PARTNER_POS_1, #{}, SceneId, ScenePoolId, CopyId, X, Y, []);
                {?DUN_CREATE_PARTNER_POS_1, X1, Y1, AttrList} ->
                    case lib_scene:is_blocked(SceneId, CopyId, X1, Y1) of
                        true -> DataMap1 = get_create_partner_pos_map(?DUN_CREATE_PARTNER_POS_1, #{}, SceneId, ScenePoolId, CopyId, X, Y, AttrList);
                        false -> DataMap1 = maps:put(?DUN_CREATE_PARTNER_POS_1, {X1, Y1, AttrList}, #{})
                    end
            end,
            % Pos = 2
            case lists:keyfind(?DUN_CREATE_PARTNER_POS_2, 1, List) of
                false -> get_create_partner_pos_map(?DUN_CREATE_PARTNER_POS_2, DataMap1, SceneId, ScenePoolId, CopyId, X, Y, []);
                {?DUN_CREATE_PARTNER_POS_2, X2, Y2, AttrList2} ->
                    case lib_scene:is_blocked(SceneId, CopyId, X2, Y2) of
                        true -> get_create_partner_pos_map(?DUN_CREATE_PARTNER_POS_2, DataMap1, SceneId, ScenePoolId, CopyId, X, Y, AttrList2);
                        false -> maps:put(?DUN_CREATE_PARTNER_POS_2, {X2, Y2, AttrList2}, DataMap1)
                    end
            end
    end.

%% 获得创建伙伴的坐标Map.Pos=1,2
%% @return #{Pos:={X, Y, AttrList}}
get_create_partner_pos_map(SceneId, ScenePoolId, CopyId, X, Y) ->
    DataMap1 = get_create_partner_pos_map(?DUN_CREATE_PARTNER_POS_1, #{}, SceneId, ScenePoolId, CopyId, X, Y, []),
    get_create_partner_pos_map(?DUN_CREATE_PARTNER_POS_2, DataMap1, SceneId, ScenePoolId, CopyId, X, Y, []).

get_create_partner_pos_map(Pos, DataMap, SceneId, ScenePoolId, CopyId, X, Y, AttrList) ->
    XyList = data_dungeon_m:get_xy(Pos, X, Y),
    case do_get_create_partner_pos_map(XyList, SceneId, ScenePoolId, CopyId) of
        false -> maps:put(Pos, {X, Y, AttrList}, DataMap);
        {X1, Y1} -> maps:put(Pos, {X1, Y1, AttrList}, DataMap)
    end.

do_get_create_partner_pos_map([], _SceneId, _ScenePoolId, _CopyId) -> false;
do_get_create_partner_pos_map([{X, Y}|T], SceneId, ScenePoolId, CopyId) ->
    case lib_scene:is_blocked(SceneId, CopyId, X, Y) of
        true -> do_get_create_partner_pos_map(T, SceneId, ScenePoolId, CopyId);
        false -> {X, Y}
    end.

quit_team(?DUNGEON_TYPE_BEINGS_GATE, _Node, _TeamId, _RoleId) -> skip;
quit_team(_DunType, Node, TeamId, RoleId) -> mod_team:cast_to_team(Node, TeamId, {'quit_team', RoleId, 1}).

quit_dungeon(?DUNGEON_TYPE_BEINGS_GATE, TeamId, RoleId, ResultType) -> mod_team:cast_to_team(TeamId, {'quit_dungeon_no_team', RoleId, ResultType});
quit_dungeon(_DunType, TeamId, RoleId, ResultType) -> mod_team:cast_to_team(TeamId, {'quit_dungeon', RoleId, ResultType}).

send_mon_num(#dungeon_state{dun_type = ?DUNGEON_TYPE_BEINGS_GATE} = State, CommonEvent) ->
    #dungeon_state{dun_id = DunId, wave_num = WaveNum, wave_mon_map = WaveMonMap} = State,
    DeadMonList = lib_dungeon_mon_event:get_already_dead_mon(DunId, CommonEvent),
    GenerateMonList = lib_dungeon_mon_event:get_generate_mon(DunId, CommonEvent),
    {ok, BinData} = pt_610:write(61066, [WaveNum, length(DeadMonList), length(GenerateMonList)]),
    lib_dungeon_mod:send_msg(State, BinData),
    State#dungeon_state{wave_mon_map = maps:put(WaveNum, {GenerateMonList, DeadMonList}, WaveMonMap)};
send_mon_num(State, _CommonEvent) -> State.

get_merge_reward_list([]) -> [];
get_merge_reward_list(RewardList) ->
    RewardListA = hd(RewardList),
    FA = fun({Type, RewardListB}, NewRewardListA) ->
        FB = fun({TypeA, GoodsId, Num}, NewRewardListB) ->
            [{TypeA, GoodsId, Num * length(RewardList)} | NewRewardListB]
        end,
        NewRewardListC = lists:foldl(FB, [], RewardListB),
        [{Type, NewRewardListC} | NewRewardListA]
    end,
    [lists:reverse(lists:foldl(FA, [], RewardListA))].

%% 众生之门相关副本列表，共享次数
list_special_share_dungeon(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = ?DUNGEON_TYPE_BEINGS_GATE} ->
            data_beings_gate:get_value(beings_gate_dungeon_center) ++ data_beings_gate:get_value(beings_gate_dungeon_local);
        _ -> [DunId]
    end.