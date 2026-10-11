%% ---------------------------------------------------------------------------
%% @doc data_cluster_sanctuary_m

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(data_cluster_sanctuary_m).

%% API
-export([
      get_san_value/1
    , get_begin_scene/1
    , get_mon_type/2
    , get_score_by_id/1
]).

-include("common.hrl").
-include("server.hrl").
-include("cluster_sanctuary.hrl").

get_san_value(Key) ->
    F = fun() ->
        case Key of
            open_lv -> 200;
            open_time -> [{open,{9,0}},{continue, {17,0}}];
            clear_role_anger_time -> [{16,0}];
            reborn_time -> [{1,00},{9,00},{12,30},{16,00},{19,30},{22,30}];
            tip_notify_user_act_end -> 5;
            kill_log_num -> 20;
            min_score_get_hurt_limit -> 2;
            clear_role_after_scene_bl -> 30;
            unlock_score -> 0;
            anger_limit -> 100;
            die_wait_time -> [{min_times, 4},{special,[{5,30}]},{extra, 30}];
            player_die_times -> 300;
            revive_point_gost -> 15;
            revive_cost -> [{2,0,20}];
            random_time -> 14;
            auction_kill_player_add -> 4;
            kill_player_reward_and_anger -> {[{2,0,100}], 10};
            _ -> []
        end
    end,
    case data_cluster_sanctuary:get_san_value(Key) of
        [] -> F();
        Val -> Val
    end.


%% -----------------------------------------------------------------
%% 不同圣域模式的起点配置
%% -----------------------------------------------------------------
get_begin_scene(SanType) ->
    if
        SanType == ?SANTYPE_1 ->
            data_cluster_sanctuary:get_san_value(san_type1_begin_point);
        SanType == ?SANTYPE_2 ->
            data_cluster_sanctuary:get_san_value(san_type2_begin_point);
        SanType == ?SANTYPE_3 ->
            data_cluster_sanctuary:get_san_value(san_type3_begin_point);
        SanType == ?SANTYPE_4 ->
            data_cluster_sanctuary:get_san_value(san_type4_begin_point);
        SanType == ?SANTYPE_5 ->
            data_cluster_sanctuary:get_san_value(san_type4_begin_point);
        true ->
            []
    end.

get_mon_type(MonType, BuildingType) ->
    case data_cluster_sanctuary:get_mon_type(MonType, BuildingType) of
        Result when is_record(Result, base_san_mon_type) ->
            Result;
        _ ->
            #base_san_mon_type{}
    end.

get_score_by_id(ScoreId) ->
    case data_cluster_sanctuary:get_score_by_id(ScoreId) of
        [Score] -> Score;
        _ -> 0
    end.