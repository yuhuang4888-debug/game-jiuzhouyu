%%% -------------------------------------------------------------------
%%% @doc        lib_rush_treasure_player
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-14 9:40               
%%% @deprecated 冲榜夺宝玩家进程逻辑层
%%% -------------------------------------------------------------------

-module(lib_rush_treasure_player).

-include("custom_act.hrl").
-include("bonus_tree.hrl").
-include("rush_treasure.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("common.hrl").

%% API
-export([send_info/4, rush_treasure_draw/6, do_send_tv/3, get_stage_reward/5, send_stage_reward/2, send_stage_reward/1, login/1]).

%% -----------------------------------------------------------------
%% @desc 登录初始化
%% @param PS
%% @return NewPS
%% -----------------------------------------------------------------
login(PS) ->
    #player_status{id = RoleId} = PS,
    DBRushTreasureRoleList = lib_rush_treasure_sql:db_select_rush_treasure_role_by_role_id(RoleId),
    F = fun(DBRushTreasureRole, PSA) ->
        [RoleId, Type, SubType, Score, TodayScore, Times, RList, SList, Time] = DBRushTreasureRole,
        case lib_custom_act_api:is_open_act(Type, SubType) of
            true ->
                RewardList = util:bitstring_to_term(RList),
                ScoreReward = util:bitstring_to_term(SList),
                RaceData = #rush_treasure_data{
                    id           = {Type,SubType},
                    type         = Type,
                    subtype      = SubType,
                    score        = Score,
                    times        = Times,
                    reward_list  = RewardList,
                    score_reward = ScoreReward,
                    today_score  = TodayScore,
                    last_time    = Time
                },
                lib_rush_treasure_helper:update_role_race_info(Type, SubType, PSA, RaceData);
            false -> lib_rush_treasure_sql:db_rush_treasure_delete_by_role_id(Type, SubType, RoleId)
        end
        end,
    lists:foldl(F, PS, DBRushTreasureRoleList).

%% -----------------------------------------------------------------
%% @desc 发送冲榜夺宝界面信息
%% @param Player  玩家状态记录
%% @param Type    主类型
%% @param SubType 子类型
%% @param WorldLv 世界等级
%% @return {ok, Player}
%% -----------------------------------------------------------------
send_info(Player, Type, SubType, WorldLv) ->
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    RaceActData = lib_rush_treasure_helper:get_role_race_info(Type, SubType, Player),
    #rush_treasure_data{score = Score,today_score = TodayScore} = RaceActData,
    case erlang:get({bonus_tree, Type, SubType}) of
        BonusTreeStatus when is_record(BonusTreeStatus, bonus_tree_status) ->
            #bonus_tree_status{pool = Pool} = BonusTreeStatus;
        _ ->
            lib_bonus_tree:init_online_player(Player),
            #bonus_tree_status{pool = Pool} = erlang:get({bonus_tree, Type, SubType})
    end,
    Fun = fun({_, GradeId}, Acc) -> [GradeId | Acc] end,
    Grades = lists:foldl(Fun, [], Pool),
    RewardList = lib_bonus_tree:construct_reward_list_for_client(Player, Type, SubType, Grades),
    ScoreRewardList = get_stage_list_type(Type, SubType, RaceActData),
    {ok, Bin} = pt_332:write(33252, [Type, SubType, Score, TodayScore, util:term_to_string(Condition), RewardList, ScoreRewardList, WorldLv]),
    %?MYLOG("lwcrank","Type, SubType, Score, TodayScore, ScoreReward, WorldLv:~p~n",[{Type, SubType, Score, TodayScore, ScoreRewardList, WorldLv}]),
    lib_server_send:send_to_uid(Player#player_status.id, Bin),
    {ok, Player}.

%% -----------------------------------------------------------------
%% @desc 获取阶段奖励状态
%% @param Type        主类型
%% @param SubType     子类型
%% @param RaceActData 冲榜夺宝玩家信息
%% @return ScoreRewardList 阶段奖励列表
%% -----------------------------------------------------------------
get_stage_list_type(Type, SubType, RaceActData) ->
    #rush_treasure_data{score = Score, score_reward = RewardIds} = RaceActData,
    Ids = data_rush_treasure:get_stage_reward_all_id(Type, SubType),
    F = fun(RewardId, ScoreRewardList) ->
        case lists:member(RewardId, RewardIds) of
            true-> [{RewardId, ?RECEIVED} | ScoreRewardList];
            false->
                #base_rush_treasure_stage_reward{need_val = NeedVal} = data_rush_treasure:get_stage_reward(Type, SubType, RewardId),
                ?IF(Score>= NeedVal, [{RewardId, ?AVAILABLE} | ScoreRewardList], [{RewardId, ?NOT_AVAILABLE} | ScoreRewardList])
        end
        end,
    lists:reverse(lists:foldl(F, [], Ids)).

%% -----------------------------------------------------------------
%% @desc  冲榜夺宝抽奖
%% @param Player  玩家记录
%% @param Type    主类型
%% @param SubType 子类型
%% @param Times   抽奖次数
%% @param WorldLv 世界等级
%% @param AutoBuy 是否自动购买
%% @param State   进程State
%% @return {ok, NewPS}
%% -----------------------------------------------------------------
rush_treasure_draw(Player, Type, SubType, Times, _WorldLv, AutoBuy) ->
    case lib_bonus_tree:get_bonus(Player, Type, SubType, Times, AutoBuy) of
        {ok, PSA} ->
            #player_status{id = RoleId, server_num = ServerNum, server_id = ServerId} = Player,
            RushTreasureData = lib_rush_treasure_helper:get_role_race_info(Type, SubType, PSA),
            BonusTreeStatus = erlang:get({bonus_tree, Type, SubType}),
            #bonus_tree_status{
                score       = Score,
                grade_state = GradeState,
                grade_list  = GradeList
            } = BonusTreeStatus,
            #custom_act_cfg{condition = Conditions, name = ActName} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            {score, AddScore} = ulists:keyfind(score, 1, Conditions, {score, 0}),
            #rush_treasure_data{
                today_score = TodayScore,
                times       = AllTimes
            } = RushTreasureData,
            NewRushTreasureData = RushTreasureData#rush_treasure_data{
                score = Score,
                times = AllTimes + Times,
                today_score = TodayScore + Times * AddScore,
                reward_list = GradeState,
                last_time = utime:unixtime()
            },
            NewPS = lib_rush_treasure_helper:update_role_race_info(Type, SubType, PSA, NewRushTreasureData),
            lib_rush_treasure_sql:db_rush_treasure_role_replace(RoleId, NewRushTreasureData),
            %% 通知榜单
            RankRole = lib_rush_treasure_helper:make_rank_role(NewPS, Score),
            % ?MYLOG("lwcrank","NewRaceActData:~p~n",[NewRushTreasureData]),
            mod_rush_treasure_kf:cast_center([{mod, lib_rush_treasure_mod_kf, enter_rank, [Type, SubType, RankRole]}]),
            RoleName = lib_player:get_wrap_role_name(NewPS),
            Fun = fun(GradeId, Acc) ->
                #custom_act_reward_cfg{condition = Condition} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                [{Gtype, GoodsTypeId, _GNum}] = Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                mod_custom_act_record:cast({save_role_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),
                RealGtypeId = lib_bonus_tree:get_real_goodstypeid(GoodsTypeId, Gtype),
                ulists:keyfind(is_tv, 1, Condition, {is_tv, 0}) =:= {is_tv, 1} andalso
                    mod_rush_treasure_kf:cast_center([{mod, lib_rush_treasure_mod_kf, send_tv, [Type, SubType, ServerNum, RoleName, RoleId, ActName, RealGtypeId, ServerId]}]),
                [{GradeId, Reward} | Acc]
                  end,
            RewardList = lists:foldl(Fun, [], GradeList),
            ProData = [Type, SubType, Times, TodayScore, ?SUCCESS, RewardList],
            {ok, BinData} = pt_338:write(33803, ProData),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            pp_custom_act_list:handle(33252, NewPS, [Type, SubType]),
            {ok, NewPS};
        _ -> {ok, Player}
    end.

%% -----------------------------------------------------------------
%% @desc 发送传闻
%% @param
%% @return
%% -----------------------------------------------------------------
do_send_tv(ModuleId, Id, Msg) ->
    [_ServerNum, _RoleName, _RoleId, _ActName, _RealGtypeId, Type, SubType] = Msg,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {role_lv, LimitLv} = ulists:keyfind(role_lv, 1, Conditions, 9999),
    lib_custom_act_api:is_open_act(Type, SubType) andalso lib_chat:send_TV({all_lv, LimitLv, 99999}, ModuleId, Id, Msg).

%% -----------------------------------------------------------------
%% @desc  领取阶段奖励
%% @param Player   玩家记录
%% @param Type     主类型
%% @param SubType  子类型
%% @param RewardId 奖励Id
%% @param WorldLv  世界等级
%% @return {ok, NewPS}
%% -----------------------------------------------------------------
get_stage_reward(Player, Type, SubType, RewardId, WorldLv) ->
    case do_get_stage_reward(Player, Type, SubType, RewardId, WorldLv) of
        {false, Reason}->
            ProData = [Type, SubType, RewardId, Reason],
            NewPS = Player;
        {ok, NewPS} ->
            ProData = [Type, SubType, RewardId, ?SUCCESS],
            NewPS
    end,
    {ok, BinData} = pt_332:write(33254, ProData),
    lib_server_send:send_to_uid(Player#player_status.id, BinData),
    {ok, NewPS}.

%% -----------------------------------------------------------------
%% @desc 领取阶段奖励
%% @param Player   玩家记录
%% @param Type     主类型
%% @param SubType  子类型
%% @param RewardId 奖励Id
%% @param WorldLv  世界等级
%% @return {false, Code} |  {ok, NewPS}
%% -------------------- ---------------------------------------------
do_get_stage_reward(PS, Type, SubType, RewardId, WorldLv) ->
    Data = lib_rush_treasure_helper:get_role_race_info(Type, SubType, PS),
    #rush_treasure_data{score = Score,score_reward = ScoreReward} = Data,
    IsGot = lists:member(RewardId, ScoreReward),
    if
        IsGot == true -> {false,?ERRCODE(err338_has_got)};
        true ->
            case data_rush_treasure:get_stage_reward(Type, SubType, RewardId) of
                [] -> {false, ?FAIL};
                BaseReward ->
                    #base_rush_treasure_stage_reward{
                        need_val = NeedVal,
                        reward   = Reward
                    } = BaseReward,
                    case Score>= NeedVal of
                        true->
                            Produce = #produce{type = rush_treasure,reward = Reward, show_tips = ?SHOW_TIPS_3},
                            PSA = lib_goods_api:send_reward(PS, Produce),
                            NewData = Data#rush_treasure_data{score_reward = [RewardId | ScoreReward]},
                            lib_rush_treasure_sql:db_rush_treasure_role_replace(PSA#player_status.id, NewData),
                            LastPS = lib_rush_treasure_helper:update_role_race_info(Type, SubType, PSA, NewData),
                            lib_race_act_util:log_produce(PS#player_status.id, Type, SubType, Reward, 2, WorldLv),
                            %?MYLOG("lwcrank","NewData:~p~n",[NewData]),
                            {ok, LastPS};
                        false-> {false, ?ERRCODE(err338_lack_of_score)}
                    end
            end
    end.

%% -----------------------------------------------------------------
%% @desc 处理在线玩家阶段奖励
%% @param PS
%% @param DBRaceRole
%% @return {ok, NewPs}
%% -----------------------------------------------------------------
send_stage_reward(PS, DBRaceRole) ->
    [_RoleId, Type, SubType, _Score, _TodayScore, _Times, _RList, _SList, _Time] = DBRaceRole,
    %?MYLOG("lwcrank_end", "DBRaceRole:~p~n", [DBRaceRole]),
    %% 发送阶段奖励
    send_stage_reward(DBRaceRole),
    NewPS = lib_rush_treasure_helper:delete_role_race_info(Type, SubType, PS),
    {ok, NewPS}.

%% -----------------------------------------------------------------
%% @desc 发送未领取的阶段奖励
%% @param DBRaceRole
%% @return
%% -----------------------------------------------------------------
send_stage_reward(DBRaceRole) ->
    [RoleId, Type, SubType, Score, _TodayScore, _Times, _RList, SList, _Time] = DBRaceRole,
    AllRewardIdList = data_rush_treasure:get_stage_reward_all_id(Type, SubType),
    F = fun(RewardId, RewardList) ->
        #base_rush_treasure_stage_reward{
            need_val = NeedVal,
            reward   = Reward
        } = data_rush_treasure:get_stage_reward(Type, SubType, RewardId),
        ?IF(NeedVal =< Score andalso not lists:member(RewardId, util:bitstring_to_term(SList)),
            Reward ++ RewardList, RewardList)
        end,
    NewRewardList = lists:foldl(F, [], AllRewardIdList),
    #custom_act_cfg{name = Name} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    WorldLv = util:get_world_lv(),
    lib_race_act_util:log_produce(RoleId, Type, SubType, NewRewardList, 2, WorldLv),
    Title = utext:get(3310109, [Name]),
    Content = utext:get(3310110, [Name]),
    %?MYLOG("lwcrank_end","NewRewardList:~p~n",[NewRewardList]),
    length(NewRewardList) =/= 0 andalso mod_mail_queue:add({Type, SubType}, [RoleId], Title, Content, NewRewardList).





