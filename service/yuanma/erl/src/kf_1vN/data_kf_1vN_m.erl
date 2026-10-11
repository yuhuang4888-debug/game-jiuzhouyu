%%%-----------------------------------
%%% @Module  : data_kf_1vN_m
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN 手动配置
%%%-----------------------------------
-module(data_kf_1vN_m).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("kf_1vN.hrl").
-compile(export_all).


get_config(Type) ->
    case Type of
        race_1_pre_scene -> 24103; %% 资格赛准备场景
        race_1_scene -> 24102;
        race_2_pre_scene -> 0;   %% [目前没用]挑战赛准备场景
        race_2_scene -> 24104;
        scenes -> [24103, 24102, 24104];
        pk_scenes -> [24102, 24104];
        race_1_max_times -> data_kf_1vN:get_value(?KF_1VN_CFG_RACE_1_MAX_COUNT);
        loading_time -> 4;
        area_min_num -> 20;     %% [目前没用]单个比赛区域最少人数
        voucher_id -> 38040041;
        open_day -> data_kf_1vN:get_value(?KF_1VN_CFG_OPEN_DAY);
        min_auction_price -> 100;
        bet_len -> 50;          %% 竞猜会保留所有未领取的，但是未领取的不足五十条，则最多保留五十条数据(未领取+已经领取的),会清空部分未领取的
        lose_streak_protect -> 2; % 连败达到次数后进行匹配保护
        match_protect_cp_factor -> 0.9; % 匹配保护的战力因子(匹配战力90%以下的玩家)
        _ -> false
    end.

get_bet_cost(BetType) ->
    case BetType of
        1 -> 50;
        2 -> 100;
        _ -> 150
    end.

get_race_1_match_args(MatchTurn) ->
    case MatchTurn of
        0 -> 0.1;
        1 -> 0.3;
        2 -> 0.5;
        _ -> 9999
    end.
