%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_oblivion_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 遗忘之境的处理
%% ---------------------------------------------------------------------------
-module(lib_dungeon_oblivion_mod).
-export([]).

-compile(export_all).

%% 随机获得关卡
rand_scene_id(DunId, Level, OpenSceneList) ->
    WeightList = data_dungeon_oblivion:get_level_weight_list(DunId, Level),
    NewWeightList = [{SceneId, Weight}||{SceneId, Weight}<-WeightList, lists:member(SceneId, OpenSceneList)==false],
    {SceneId, _Weight} = util:find_ratio(NewWeightList, 2),
    SceneId.

%% 计算奖励
%% @param Reward:[{世界等级下限,[{{Type, GoodsTypeId, Num}, Ratio(万分比)},...]},...]
%% @return [{Type, GoodsTypeId, Num}] | []
calc_reward(Reward) ->
    WorldLevel = util:get_world_lv(),
    ResultList = [TmpReward||{TmpServerLv, TmpReward}<-Reward, WorldLevel >= TmpServerLv],
    case length(ResultList) == 0 of
        true -> [];
        false -> calc_reward_help(lists:last(ResultList))
    end.

%% @param Reward:[{{Type, GoodsTypeId, Num}, Ratio(万分比)},...]
%% @return [{Type, GoodsTypeId, Num}] | []
calc_reward_help([]) -> [];
calc_reward_help([{T, Ratio}|Reward]) ->
    Rand = urand:rand(1, 10000),
    case Ratio =< Rand of
        true -> [T];
        false -> calc_reward_help(Reward)
    end.
