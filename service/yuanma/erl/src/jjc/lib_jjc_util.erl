%%%------------------------------------
%%% @Module  : lib_jjc_util
%%% @Author  :  fwx
%%% @Created :  2017-03-23
%%% @Description: jjc
%%%------------------------------------
-module(lib_jjc_util).
-export([]).

-compile(export_all).

-include("common.hrl").
-include("jjc.hrl").
-include("def_fun.hrl").

%% ---------------------------------
do_init() ->
    RoleListDB = db_get_real_role(),
    F = fun(RealRole) -> make_record(real_role, RealRole) end,
    RoleList = lists:map(F, RoleListDB),   
    RealMaps = maps:from_list(RoleList), 

    F1 = fun(RealRole) -> make_record(rank_role, RealRole) end,
    RankList = lists:map(F1, RoleListDB),
    RankMaps = maps:from_list(RankList),

    #jjc_state{real_maps = RealMaps, rank_maps = RankMaps}.



%% ----------------------make_record------------------------------
make_record(rank_role, [RoleId, Rank, _HisRank, _IsReward, _RRank]) ->
    RankRole = #rank_role{   
        rank = Rank,
        role_id = RoleId
    },
    {Rank, RankRole};

make_record(real_role, [RoleId, Rank, HisRank, IsReward, RewardRank]) ->
    Sql = io_lib:format(?sql_select_db_challenge_record, [RoleId]),
    TmpRecordL =
        [begin
             [Time, RivalId, RivalName, RivalCareer, RivalSex, RivalTurn, RivalVipType, RivalVipLv, RivalLv, RivalCombat, Result, RankRange] = SqlItem,
             #challenge_record{
                 role_id = RoleId, time = Time,
                 rival_id = RivalId, rival_name  = RivalName,
                 rival_career = RivalCareer, rival_sex   = RivalSex,
                 rival_turn  = RivalTurn, rival_vip_type = RivalVipType,
                 rival_vip_lv = RivalVipLv, rival_lv    = RivalLv,
                 rival_combat = RivalCombat, result = Result,
                 rank_change = RankRange
             }
         end||SqlItem <- db:get_all(Sql)],
    % 根据时间戳排序
    F1 = fun(A, B) -> A#challenge_record.time > B#challenge_record.time end,
    RecordL = lists:sort(F1, TmpRecordL),
    RealRole = #real_role{
        role_id = RoleId,
        rank = Rank,                    %% 排名
        history_rank = HisRank,         %% 历史排名
        record = RecordL,
        is_reward = IsReward,
        reward_rank = RewardRank
    },
    {RoleId, RealRole};  
make_record(_,_) ->
    ?PRINT(">>>>>>>>>>>>>>>>>>>>make_record error!!>>>>>>>>>>>>>>>>>>>>>>>>>>>~n", []).


%% ---------------------------sql-------------------------------------
db_get_real_role() -> 
    Sql = io_lib:format(?sql_select_db_real_role, []),
    db:get_all(Sql).



