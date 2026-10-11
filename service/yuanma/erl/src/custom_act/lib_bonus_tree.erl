%%-----------------------------------------------------------------------------
%% @Module  :       lib_bonus_tree
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2018-12-08
%% @Description:    摇钱树
%%-----------------------------------------------------------------------------
-module(lib_bonus_tree).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("bonus_tree.hrl").
-include("race_act.hrl").

-export([
    get_bonus/5,
    init_data/1,
    check_role_lv/3,
    send_list/5,
    get_stage_reward/4,
    % reset_status/2,
    reset_status/3,
    init_online_player/1,
    send_reward_act_end/3,
    send_reward_day_clear/4
    ,shop_exchange/4
    ,refresh_player_data/2
    ,refresh_player/2
    ,construct_reward_list_for_client/4
    ,get_real_goodstypeid/2
    ,delete_informations/2
    ,get_conditions/2
    ,get_pool/2
    ,do_draw_core/5
    ,can_give_grade/4
    ,get_conditions_1/2
    ]).

db_replace_score(Type, SubType, RoleId, Score) ->
    db:execute(io_lib:format(<<"replace into `custom_act_tree_score` 
        (role_id, `type`, subtype, score, stime) values (~p,~p,~p,~p,~p)">>, [RoleId,Type,SubType,Score,utime:unixtime()])).

db_replace_shop(Type, SubType, RoleId, GradeId, Num, Time) ->
    db:execute(io_lib:format(<<"replace into `custom_act_tree_shop` 
        (role_id, `type`, subtype, grade, num, stime) values (~p,~p,~p,~p,~p,~p)">>, [RoleId,Type,SubType,GradeId,Num,Time])).

db_select(RoleId, Type, SubType) ->
    db:get_row(io_lib:format(<<"select times, stime from custom_act_bonus_times where role_id = ~p and type = ~p and subtype = ~p">>, [RoleId, Type, SubType])).

db_replace(RoleId,Type,SubType,DoomedTimes) ->
    db:execute(io_lib:format(<<"replace into `custom_act_bonus_times` (role_id, `type`, subtype, times, Stime) values (~p,~p,~p,~p,~p)">>, [RoleId,Type,SubType,DoomedTimes,utime:unixtime()])).

db_delete_shop(Type, SubType, Grade) ->
    db:execute(io_lib:format(<<"delete from `custom_act_tree_shop` where type = ~p and subtype = ~p and grade = ~p">>, [Type, SubType, Grade])).

get_recieve_times(RoleId, Type, SubType, GradeId, InitType) ->
    Res = db:get_row(io_lib:format(<<"select recieve_times,utime from `custom_act_bonus_tree` where role_id = ~p
        and `type` = ~p and subtype = ~p and grade_id = ~p">>, [RoleId,Type,SubType,GradeId])),
    case Res of
        [RecieveTimes, Utime] ->
            if
                InitType == before ->
                    {RecieveTimes, Utime};
                true ->
                    handle_act_data(Type, SubType, RecieveTimes, Utime)
            end;
            % {RecieveTimes,Utime};
        _ ->
            {0,0}
    end.

set_recieve_times(RoleId, Type, SubType, GradeId, RecieveTimes) ->
    Nowtime = utime:unixtime(),
    db:execute(io_lib:format(<<"replace into `custom_act_bonus_tree` (role_id, `type`, subtype, grade_id, recieve_times,utime)
        values (~p,~p,~p,~p,~p,~p)">>, [RoleId,Type,SubType,GradeId,RecieveTimes,Nowtime])).

delete_informations(Type, SubType) ->
    db:execute(io_lib:format(<<"delete from `custom_act_bonus_times` where type = ~p and subtype = ~p">>, [Type, SubType])),
    db:execute(io_lib:format(<<"delete from `custom_act_tree_score` where type = ~p and subtype = ~p">>, [Type, SubType])),
    db:execute(io_lib:format(<<"delete from `custom_act_bonus_tree` where type = ~p and subtype = ~p">>, [Type, SubType])).

delete_informations_day(Type, SubType, ClearTime) ->
    if
        ClearTime > 0 ->
            db:execute(io_lib:format(<<"delete from `custom_act_bonus_tree` where type = ~p and subtype = ~p and utime < ~p">>, [Type, SubType,ClearTime]));
        true ->
            skip
    end.
    

init_data(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    TypeList = [?CUSTOM_ACT_TYPE_BONUS_TREE, ?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE, ?CUSTOM_ACT_TYPE_RUSH_TREASURE],
    Fun = fun(Type) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        Fun2 = fun(SubType) ->
            case lib_custom_act_api:is_open_act(Type, SubType) of
                true ->
                    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                    LimitLv = get_conditions(role_lv, Conditions),
                    if
                        RoleLv >= LimitLv andalso RoleLv > 0->
                            {NewAllTimes, NewGradeState, DoomedTimes} = init_data_helper(Type, SubType, RoleId),
                            {Score, ShopItemes} = init_shop(RoleId, Type, SubType),
                            {Pool, RarePool, MaxDoomedTimes} = get_pool(Type,SubType),
                            NewBonusTreeStatus = #bonus_tree_status{times = NewAllTimes, pool = Pool, rare_pool = RarePool, 
                                    grade_state = NewGradeState, doomed_times = DoomedTimes, max_doomed = MaxDoomedTimes, 
                                    score = Score, shop_list = ShopItemes},
                            erlang:put({bonus_tree, Type, SubType}, NewBonusTreeStatus);
                        true -> 
                            skip
                    end;
                false -> skip
            end
        end,
        lists:foreach(Fun2, SubTypes)
    end,
    lists:foreach(Fun, TypeList).

%% 抽奖
get_bonus(Player, Type, SubType, Times, AutoBuy) when 
        Type =:= ?CUSTOM_ACT_TYPE_BONUS_TREE;
        Type =:= ?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE;
        Type =:= ?CUSTOM_ACT_TYPE_RUSH_TREASURE ->
    #player_status{sid = Sid} = Player,
    if
        Times == 1 orelse Times == 10 orelse Times == 50 ->
            case lib_custom_act_api:is_open_act(Type, SubType) of
                true ->
                    BonusTreeStatus = erlang:get({bonus_tree, Type, SubType}),
                    #bonus_tree_status{times = AllTimeO} = BonusTreeStatus,
                    case get_cost(Type, SubType, Times, AllTimeO) of
                        {true, CostList} -> 
                            About = [Type, SubType, Times],
                            ConsumeType = get_consume_type(Type),
                            Res = if
                                AutoBuy == 1 ->
                                    lib_goods_api:cost_objects_with_auto_buy(Player, CostList, ConsumeType, About);
                                true ->
                                    case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, About) of
                                        {true, TmpNewPlayer} ->
                                            {true, TmpNewPlayer, CostList};
                                        Other ->
                                            Other
                                    end
                            end,
                            case Res of
                                {true, NewPlayer, Cost} ->
                                    {ok, NewPS, GradeIds, AllTimes, NewScore} = do_get_bonus(NewPlayer, Type, SubType, Cost, Times, AutoBuy),
                                    SendList = construct_reward_list_for_client(Player, Type, SubType, GradeIds),
                                    lib_server_send:send_to_sid(Sid, pt_331, 33191, [?SUCCESS, Type, SubType, AllTimes, 0, SendList, NewScore]),
                                    {ok, NewPS};        
                                {false, Error, _NewPlayer} ->
                                    lib_server_send:send_to_sid(Sid, pt_331, 33191, [Error, Type, SubType, 0, 0, [], 0])
                            end;
                        {false, ErrorCode} ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33191, [ErrorCode, Type, SubType, 0, 0, [], 0])
                    end;
                false -> 
                    lib_server_send:send_to_sid(Sid, pt_331, 33191, [?ERRCODE(err331_act_closed), Type, SubType, 0, 0, [], 0])
            end;
        true ->
            lib_server_send:send_to_sid(Sid, pt_331, 33191, [?ERRCODE(err331_error_data), Type, SubType, 0, 0, [], 0])
    end.

do_get_bonus(Player, Type, SubType, CostList, Times, AutoBuy) ->
    #player_status{id = RoleId, figure = #figure{name = _RoleName}} = Player,
    WrapRoleName = lib_player:get_wrap_role_name(Player),
    BonusTreeStatus = erlang:get({bonus_tree, Type, SubType}),
    #bonus_tree_status{times = AllTimes, pool = Pool, rare_pool = RarePool, grade_state = GradeState, 
        doomed_times = DoomedTimes, max_doomed = MaxDoomedTimes, score = Score} = BonusTreeStatus,
    {NewAllTimes,NewDoomedTimes,NewGradeState,GradeIds} = do_get_bonus_help(RoleId, AllTimes, DoomedTimes, MaxDoomedTimes, Pool, RarePool, GradeState, Type, SubType, Times, []),
    if
        MaxDoomedTimes > 0 andalso RarePool =/= [] ->
            RealDoomedTimes = NewDoomedTimes,
            db_replace(RoleId,Type,SubType,NewDoomedTimes);
        true ->
            RealDoomedTimes = 0
    end,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NewScore = case lists:keyfind(score, 1, Conditions) of
        {_, AddScore} -> 
            Sum = Score + AddScore * Times,
            db_replace_score(Type, SubType, RoleId, Sum),
            Sum;
        _ -> 0
    end,
    {_, ExtraRewardCfg} = ulists:keyfind(add_reward, 1, Conditions, {add_reward, []}),
    {_, OType, OSubtype} = ulists:keyfind(act, 1, Conditions, {act, 0, 0}),
    Fun = fun({T, Gt, Num}, Acc) ->
        [{T, Gt, Num*Times}|Acc]
    end,
    ExtraReward = lists:foldl(Fun, [], ExtraRewardCfg),
    Rewards = handle_reward(Player, GradeIds, Type, SubType, [], WrapRoleName, RoleId), %%传闻处理
    NewBonusTreeStatus = BonusTreeStatus#bonus_tree_status{
        times        = NewAllTimes,
        grade_state  = NewGradeState,
        doomed_times = RealDoomedTimes,
        score        = NewScore,
        grade_list   = GradeIds
    },
    erlang:put({bonus_tree, Type, SubType}, NewBonusTreeStatus),  %%刷新内存
    ProduceType = get_produce_type(Type),
    Produce = #produce{type = ProduceType, subtype = Type, reward = Rewards++ExtraReward, show_tips = ?SHOW_TIPS_0},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    OType =/= 0 andalso OSubtype =/= 0 andalso ExtraReward =/= [] andalso pp_custom_act_list:handle(33231, NewPlayer, [OType, OSubtype]),
    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, Rewards++ExtraReward),
    lib_log_api:log_bonus_tree(RoleId, Type, SubType, Times, AutoBuy, CostList, GradeIds, Rewards++ExtraReward),
    ta_agent_fire:log_bonus_tree(NewPlayer, [Type, SubType, Times, AutoBuy, GradeIds]),
    {ok, NewPlayer, GradeIds, NewAllTimes, NewScore}.


do_get_bonus_help(_RoleId, AllTimes, DoomedTimes, _MaxDoomedTimes, _Pool, _RarePool, GradeState, _Type, _SubType, 0, GradeIds) -> {AllTimes,DoomedTimes,GradeState,GradeIds};
do_get_bonus_help(RoleId, AllTimes, DoomedTimes, MaxDoomedTimes, Pool, RarePool, GradeState, Type, SubType, Times, GradeIds) ->
    {RealPool, NewDoomedTimes} = do_draw_core(Pool, RarePool, AllTimes, DoomedTimes+1, MaxDoomedTimes),
    % ?PRINT(AllTimes >= 550,"RealPool:~p~n", [RealPool]),
    GradeId = urand:rand_with_weight(RealPool),  %%奖池里面的大奖id一定是有配置的
    #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    RareDoomed = get_conditions(rare_award, Conditions),
    case can_give_grade(Conditions, GradeId, GradeState, AllTimes) of
        true -> 
            {DrawTimes,_Utime} = get_conditions_1(GradeId,GradeState),
            NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, DrawTimes+1, utime:unixtime()}),
            set_recieve_times(RoleId, Type, SubType, GradeId, DrawTimes+1),  %%写入数据库
            if
                RareDoomed > 0 ->
                    ?PRINT("RareDoomed:~p~n",[RareDoomed]),
                    RealDoomedTimes = 0;
                true ->
                    RealDoomedTimes = NewDoomedTimes
            end,
            do_get_bonus_help(RoleId, AllTimes + 1, RealDoomedTimes, MaxDoomedTimes, Pool, RarePool, NewGradeState, Type, SubType, Times-1, [GradeId|GradeIds]);
        false -> do_get_bonus_help(RoleId, AllTimes, DoomedTimes, MaxDoomedTimes, Pool, RarePool, GradeState, Type, SubType, Times, GradeIds)
    end.
%% 奖池，{StartTimes, EndTimes, Weight, SpecialWeight} 在StartTimes 与 EndTimes 之间权重增加（Weight+SpecialWeight）
%% 若抽奖次数没达到StartTimes,该大奖不会入奖池， 抽奖次数大于EndTimes使用Weight来抽奖
do_draw_core(Pool, RarePool, AllTimes, DoomedTimes, MaxDoomedTimes) ->
    if
        DoomedTimes > MaxDoomedTimes andalso RarePool =/= [] andalso MaxDoomedTimes > 0 ->
            {RarePool, 0};
        true ->
            Fun = fun({{StartTimes, EndTimes, Weight, SpecialWeight}, GradeId}, RealPool) ->
                if
                    StartTimes =:= EndTimes ->
                        [{Weight, GradeId}|RealPool];
                    AllTimes < StartTimes ->
                        RealPool;
                    AllTimes > StartTimes andalso AllTimes =< EndTimes ->
                        [{Weight+SpecialWeight, GradeId}|RealPool];
                    true ->
                        [{Weight, GradeId}|RealPool]
                end
            end,
            RealPool = lists:foldl(Fun, [], Pool),
            {RealPool, DoomedTimes}
    end.
    

%% 处理需要发传闻的奖励
handle_reward(_Player, [], _, _, Rewards,_,_) -> Rewards;
handle_reward(Player, [GradeId|GradeIds], Type, SubType, Rewards, RoleName, RoleId) ->  
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
    case Reward of
        [{Gtype, GoodsTypeId, _GNum}|_] ->
            Type =/= ?CUSTOM_ACT_TYPE_RUSH_TREASURE andalso send_tv(Conditions, RoleId, Type, SubType, RoleName, Reward, GoodsTypeId, Gtype),
            handle_reward(Player, GradeIds, Type, SubType, Reward++Rewards, RoleName, RoleId);
        _ ->
            handle_reward(Player, GradeIds, Type, SubType, Rewards, RoleName, RoleId)
    end.
    % mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),

%% 发送传闻
send_tv(Conditions, RoleId, Type, SubType, RoleName, Reward, GoodsTypeId, Gtype) ->
    case get_conditions(is_tv, Conditions) of
        1 ->
            mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),
            RealGtypeId = get_real_goodstypeid(GoodsTypeId, Gtype),
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 25, [RoleName, RoleId, RealGtypeId, Type, SubType]);
        _ ->
            case get_conditions(tv, Conditions) of
                {ModuleId, Id} ->
                    mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),
                    RealGtypeId = get_real_goodstypeid(GoodsTypeId, Gtype),
                    lib_chat:send_TV({all}, ModuleId, Id, [RoleName, RoleId, RealGtypeId, Type, SubType]);
                _ ->
                    skip
            end
    end.

get_real_goodstypeid(GoodsTypeId, Gtype) ->
    if
        GoodsTypeId =/= 0 ->
            GoodsTypeId;
        true ->
            if
                Gtype == 1 ->
                    ?GOODS_ID_GOLD;
                Gtype == 2 ->
                    ?GOODS_ID_BGOLD;
                Gtype == 3 ->
                    ?GOODS_ID_COIN;
                true ->
                    0
            end
    end.    

%%领取累计抽奖次数奖励
get_stage_reward(Type, SubType, GradeId, Player) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
                #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                    NeedTimes = get_conditions(total, Conditions),
                    BonusTreeStatus = erlang:get({bonus_tree, Type, SubType}),
                    #bonus_tree_status{times = AllTimes, pool = _Pool, grade_state = GradeState} = BonusTreeStatus,
           %        Fun = fun({_, TempId}, Acc) ->
                    %   [TempId|Acc]
                    % end,
                    % Grades = lists:foldl(Fun, [], Pool),
                    % GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
                    % TotalList = lists:subtract(GradeIdList, Grades),
                    TotalList = [GradeId],
                    case lists:keyfind(GradeId, 1, GradeState) of
                        {GradeId,Times,_} when is_integer(Times) andalso Times =:= 0 ->
                            if
                                NeedTimes =< AllTimes ->
                                    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                                    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                                    %% 更新内存
                                    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, 1, utime:unixtime()}),
                                    NewBonusTreeStatus = BonusTreeStatus#bonus_tree_status{grade_state = NewGradeState},
                                    erlang:put({bonus_tree, Type, SubType}, NewBonusTreeStatus),
                                    %% 数据库更新
                                    set_recieve_times(RoleId, Type, SubType, GradeId, 1),
                                    %% 发放奖励
                                    ProduceType = get_produce_type(Type),
                                    Produce = #produce{type = ProduceType, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
                                    NewPlayer = lib_goods_api:send_reward(Player, Produce),
                                    %% 日志
                                    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
                                    lib_log_api:log_bonus_tree(RoleId, Type, SubType, 0, 0, [], [GradeId], Reward),
                                    ta_agent_fire:log_bonus_tree(NewPlayer, [Type, SubType, 0, 0, [GradeId]]),
                                    %% 组装数据
                                    TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, AllTimes, NewGradeState),
                                    lib_server_send:send_to_sid(Sid, pt_331, 33192, [?SUCCESS, Type, SubType, TotalShowList]),
                                    {ok, NewPlayer};
                                true ->
                                    TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, AllTimes, GradeState),
                                    lib_server_send:send_to_sid(Sid, pt_331, 33192, [?ERRCODE(err331_draw_times_limit), Type, SubType, TotalShowList])
                            end;
                            
                        _ ->
                            TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, AllTimes, GradeState),
                            lib_server_send:send_to_sid(Sid, pt_331, 33192, [?ERRCODE(err331_has_recieve), Type, SubType, TotalShowList])
                    end;
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33192, [?MISSING_CONFIG, Type, SubType, []])
            end;
        false -> 
            lib_server_send:send_to_sid(Sid, pt_331, 33192, [?ERRCODE(err331_act_closed), Type, SubType, []])
    end.

%%领取累计抽奖次数奖
shop_exchange(Type, SubType, GradeId, Player) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
                #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                    NeedScore = get_conditions(need_score, Conditions),
                    case lists:keyfind(exchange_num, 1, Conditions) of
                        {_, MaxNum, _} -> 
                            BonusTreeStatus = erlang:get({bonus_tree, Type, SubType}),
                            #bonus_tree_status{score = Score, shop_list = Shop} = BonusTreeStatus,
                            ?PRINT("Score:~p, NeedScore:~p, MaxNum:~p, Shop:~p~n",[Score, NeedScore, MaxNum, Shop]),
                            if
                                NeedScore > 0 andalso MaxNum >= 0 ->
                                    case lists:keyfind(GradeId, 1, Shop) of
                                        {_, Num, _} -> skip;
                                        _ -> Num = 0
                                    end,
                                    if
                                        MaxNum =/= 0 andalso Num >= MaxNum ->
                                            lib_server_send:send_to_sid(Sid, pt_331, 33168, [Type, SubType, GradeId, ?ERRCODE(err331_exchange_limit), [], 0, 0]);
                                        NeedScore > Score ->
                                            lib_server_send:send_to_sid(Sid, pt_331, 33168, [Type, SubType, GradeId, ?ERRCODE(err331_score_not_enougth), [], 0, 0]);
                                        true ->
                                            ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                                            Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),

                                            Nowtime = utime:unixtime(),
                                            NewShop = lists:keystore(GradeId, 1, Shop, {GradeId, Num + 1, Nowtime}),
                                            NewBonusTreeStatus = BonusTreeStatus#bonus_tree_status{shop_list = NewShop, score = Score - NeedScore},
                                            erlang:put({bonus_tree, Type, SubType}, NewBonusTreeStatus),
                                            %% 数据库更新
                                            db_replace_score(Type, SubType, RoleId, Score - NeedScore),
                                            db_replace_shop(Type, SubType, RoleId, GradeId, Num + 1, Nowtime),
                                            %% 发放奖励
                                            ProduceType = get_produce_type(Type),
                                            Produce = #produce{type = ProduceType, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
                                            NewPlayer = lib_goods_api:send_reward(Player, Produce),
                                            %% 日志
                                            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
                                            lib_log_api:log_bonus_tree(RoleId, Type, SubType, 0, 0, [], [GradeId], Reward),
                                            ta_agent_fire:log_bonus_tree(NewPlayer, [Type, SubType, 0, 0, [GradeId]]),
                                            %% 组装数据
                                            lib_server_send:send_to_sid(Sid, pt_331, 33168, [Type, SubType, GradeId, ?SUCCESS, Reward, Num+1, Score - NeedScore]),
                                            {ok, NewPlayer}
                                    end;
                                true ->
                                    lib_server_send:send_to_sid(Sid, pt_331, 33168, [Type, SubType, GradeId, ?MISSING_CONFIG, [], 0, 0])
                            end;
                        _ ->
                           lib_server_send:send_to_sid(Sid, pt_331, 33168, [Type, SubType, GradeId, ?MISSING_CONFIG, [], 0, 0])
                    end; 
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33168, [Type, SubType, GradeId, ?MISSING_CONFIG, [], 0, 0])
            end;
        false -> 
            lib_server_send:send_to_sid(Sid, pt_331, 33168, [Type, SubType, GradeId, ?ERRCODE(err331_act_closed), [], 0, 0])
    end.

%% 获取可被抽取的奖励的配置
get_pool(Type, SubType) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case lists:keyfind(doomed, 1, ActConditions) of
        {_, Max} when is_integer(Max) andalso Max > 0 -> Max;
        _ -> Max = 0
    end,
    Fun = fun(GradeId, {Acc, Acc1}) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} -> 
                NewAcc = case lists:keyfind(weight, 1, Conditions) of 
                    {weight, Weight} -> [{Weight, GradeId}|Acc];
                    _ -> Acc
                end,
                if
                    Max > 0 ->
                        case lists:keyfind(rare_award, 1, Conditions) of 
                            {rare_award, RareWeight} when is_integer(RareWeight) andalso RareWeight > 0 ->{NewAcc, [{RareWeight, GradeId}|Acc1]};
                            _ -> {NewAcc, Acc1}
                        end;
                    true ->
                        {NewAcc, Acc1}
                end;                
            _ ->
                ?ERR("custom_act, condition:weight miss! Type:~p SubType:~p, GradeId:~p~n",[Type,SubType,GradeId]), 
                {Acc, Acc1}
        end
    end,
    {Pool, RarePool} = lists:foldl(Fun, {[], []}, GradeIdList),
    {Pool, RarePool, Max}.

get_shop(Type, SubType) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun = fun(GradeId, {Acc, Acc1}) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} -> 
                case lists:keyfind(exchange_num, 1, Conditions) of 
                    {exchange_num, _, Clear} -> 
                        NewAcc1 = case lists:keyfind(Clear, 1, Acc1) of
                            {_, List} ->
                                lists:keystore(Clear, 1, Acc1, {Clear, [GradeId|List]});
                            _ ->
                                lists:keystore(Clear, 1, Acc1, {Clear, [GradeId]})
                        end,
                        {[GradeId|Acc], NewAcc1};
                    _ -> 
                        {Acc, Acc1}
                end;     
            _ ->
                {Acc, Acc1}
        end
    end,
    {ShopGradeL, ShopClear} = lists:foldl(Fun, {[], []}, GradeIdList),
    {ShopGradeL, ShopClear}.

% %% 获取消耗列表
% get_cost(?CUSTOM_ACT_TYPE_DRAW_REWARD = Type, SubType, Times, AllTimes) ->
%     case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
%         #custom_act_cfg{condition = Conditions} ->
%             case lists:keyfind(goods, 1, Conditions) of
%                 {goods, Cost} when is_list(Cost)-> % [{1,999,[{0,38220001,1}]}]
%                     case lists:keyfind(cost, 1, Conditions) of
%                         {cost,TimesCfg} when is_list(TimesCfg) ->skip;
%                         _ -> TimesCfg = []
%                     end,
%                     get_cost_helper(TimesCfg, Cost, Times, AllTimes, []);
%                 _E ->{false, ?MISSING_CONFIG}
%             end;
%         _->
%             {false, ?MISSING_CONFIG}
%     end;
get_cost(Type, SubType, Times, _) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Conditions} ->
            if
                Times =:= 1 ->
                    case lists:keyfind(one_cost, 1, Conditions) of
                        {one_cost, Cost} ->{true, Cost};
                        _ -> {false, ?MISSING_CONFIG}
                    end;
                Times =:= 10 ->
                    case lists:keyfind(ten_cost, 1, Conditions) of
                        {ten_cost, Cost} ->{true, Cost};
                        _ -> {false, ?MISSING_CONFIG}
                    end;
                Times =:= 50 ->
                    case lists:keyfind(fifty_cost, 1, Conditions) of
                        {fifty_cost, Cost} ->{true, Cost};
                        _ -> {false, ?MISSING_CONFIG}
                    end;
                true -> {false, ?ERRCODE(err331_error_data)}
            end;
        _ -> 
            {false, ?MISSING_CONFIG}
    end.

% get_cost_helper(_, _, 0, _, RealCost) -> {true,RealCost};
% get_cost_helper(TimesCfg, Cost, Times, AllTimes, RealCost) ->
%     Fun = fun({TMin, TMax, _}) ->
%         TMin =< AllTimes+1 andalso AllTimes+1 =< TMax
%     end,
%     case ulists:find(Fun, TimesCfg) of
%         {_, {_, _, Num}} ->
%             F1 = fun({G,Gt,_}, Acc) ->
%                 case lists:keyfind(Gt,2, Acc) of
%                     {G, Gt, ONum} ->
%                         lists:keystore(Gt, 2, Acc, {G,Gt, ONum+Num});
%                     {_, Gt, _} ->
%                         ?ERR("config error custom_act Type:~p~n",[58]),
%                         Acc;
%                     _ ->
%                         [{G,Gt,Num}|Acc]
%                 end
%             end,
%             CostList = lists:foldl(F1, RealCost, Cost),
%             get_cost_helper(TimesCfg, Cost, Times-1, AllTimes+1, CostList);
%         _-> {false, ?MISSING_CONFIG}    
%     end.
                    

get_conditions(Key,Conditions) ->
    case lists:keyfind(Key, 1, Conditions) of
        {Key, Times} ->skip;
        _ -> Times = 0
    end,
    Times.

get_conditions_1(Key,Conditions) ->
    case lists:keyfind(Key, 1, Conditions) of
        {Key, Times, Utime} ->skip;
        _ -> Times = 0,Utime = 0
    end,
    {Times,Utime}.

%% 判断该档次奖励是否满足发放给玩家的条件
can_give_grade(Conditions, GradeId, GradeState, AllTimes) -> %%用于抽奖时判断能否給与玩家该奖励
    {Times,_Utime} = get_conditions_1(GradeId, GradeState),
    LimitNum = get_conditions(limit_num, Conditions),
    RefreshNum = get_conditions(refresh_num, Conditions),
    if
        RefreshNum =:= 0 ->
            AddTimes = 0;
        true ->
            AddTimes = AllTimes div RefreshNum + 1  %%只有总次数能够整除该值时加一
    end,
    % ?PRINT(GradeId == 6, "Times:~p,AddTimes:~p~n",[Times,AddTimes]),
    if
        Times < LimitNum orelse LimitNum =:= 0 -> %%限制次数在某个值内
            if 
                Times < AddTimes orelse AddTimes =:= 0 -> 
                    true;
                true ->
                    false
            end;
        true ->
            false
    end.

for_client(Player, Type, SubType, ShopList, ShopGradeL) ->
    Fun = fun(GradeId, Acc) ->
        case lists:keyfind(GradeId, 1, ShopList) of
            {_, Num, _} -> skip;
            _ -> Num = 0
        end,
        #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
        Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
        case lists:keyfind(need_score, 1, Conditions) of
            {_, NeedScore} -> skip;
            _ -> NeedScore = 0
        end,
        case lists:keyfind(exchange_num, 1, Conditions) of
            {_, MaxNum, Clear} -> skip;
            _ -> MaxNum = 0, Clear = 0
        end,
        [{GradeId, Reward, NeedScore, Num, MaxNum, Clear}|Acc]
    end,
    lists:foldl(Fun, [], ShopGradeL).

%% 组装抽中奖励数据发送给客户端
construct_reward_list_for_client(Player, Type, SubType, GradeIds) ->
    Fun = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
        Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
        IsRare = get_conditions(is_rare, Conditions),
        [{GradeId, IsRare, Reward}|Acc]
    end,
    lists:foldl(Fun, [], GradeIds).

%% 累计抽奖次数奖励状态数据处理
construct_reward_list_for_client(Player, Type, SubType, GradeIds, TotalTimes, GradeState) ->
    Fun = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
        Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
        NeedTimes = get_conditions(total, Conditions),
        if
            NeedTimes == 0 ->
                Acc;
            true ->
                {Times,_Utime} = get_conditions_1(GradeId,GradeState),
                States = if
                    Times =/= 0 ->
                        ?HAS_RECIEVE;
                    Times =< 0 andalso TotalTimes >= NeedTimes ->
                        ?HAS_ACHIEVE;
                    true ->
                        ?CANT_RECIEVE
                end,
                [{GradeId, NeedTimes, Reward, States}|Acc]
        end
    end,
    lists:foldl(Fun, [], GradeIds).

construct_reward_list_for_client(Type, SubType, GradeIds, TotalTimes, GradeState, Lv, Sex, Career, Wlv) ->
    Fun = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        RewardParam = lib_custom_act:make_rwparam(Lv, Sex, Wlv, Career),
        Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
        NeedTimes = get_conditions(total, Conditions),
        if
            NeedTimes == 0 ->
                Acc;
            true ->
                {Times,_Utime} = get_conditions_1(GradeId,GradeState),
                States = if
                    Times =/= 0 ->
                        ?HAS_RECIEVE;
                    Times =< 0 andalso TotalTimes >= NeedTimes ->
                        ?HAS_ACHIEVE;
                    true ->
                        ?CANT_RECIEVE
                end,
                [{GradeId, NeedTimes, Reward, States}|Acc]
        end
    end,
    lists:foldl(Fun, [], GradeIds).

%% 登陆初始化，将该活动所有奖励档次领取记录和总抽奖次数存入字典
init_data_helper(Type, SubType, RoleId) ->
    init_data_helper(Type, SubType, RoleId, 1).
init_data_helper(Type, SubType, RoleId, InitType) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun = fun(GradeId, {TotalTimes, GradeState}) ->
        #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId), 
        {RecieveTimes, Utime} = get_recieve_times(RoleId, Type, SubType, GradeId, InitType),
        case get_conditions(total, Conditions) of
            0 -> NewTotalTimes = TotalTimes+RecieveTimes;
            _ -> NewTotalTimes = TotalTimes
        end,
        NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, RecieveTimes, Utime}),
        {NewTotalTimes, NewGradeState}
    end,
    DoomedTimes = calc_doomed_times(RoleId, Type, SubType, InitType),
    {Total, GradeS} = lists:foldl(Fun, {0,[]}, GradeIdList),
    {Total, GradeS, DoomedTimes}.

handle_act_data(Type, SubType, RecieveTimes, Utime) ->
    case lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), Utime) of
        true -> {RecieveTimes, Utime};
        false -> {0, 0}
    end.

%% 检测玩家等级是否满足要求
check_role_lv(Type, SubType, RoleLv) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Conditions} ->
            LimitLv = get_conditions(role_lv, Conditions),
            if
                LimitLv =< RoleLv andalso RoleLv > 0 ->
                    true;
                true ->
                    {false, ?ERRCODE(err331_lv_not_enougth)}
            end;
        true ->
            {false, ?ERRCODE(err331_lv_not_enougth)}
    end.

%% 界面数据
send_list(Player, Type, SubType, Sid, RoleId) ->  
    BonusTreeStatus = erlang:get({bonus_tree, Type, SubType}),
    case BonusTreeStatus of
        #bonus_tree_status{times = AllTimes, pool = Pool, grade_state = GradeState, score = Score, shop_list = ShopItemes} ->skip;
        _ ->
            {AllTimes, GradeState, DoomedTimes} = init_data_helper(Type, SubType, RoleId),
            {Pool, RarePool, MaxDoomedTimes} = get_pool(Type,SubType),
            {Score, ShopItemes} = init_shop(RoleId, Type, SubType),
            NewBonusTreeStatus = #bonus_tree_status{times = AllTimes, pool = Pool, rare_pool = RarePool, grade_state = GradeState, 
                    doomed_times = DoomedTimes, max_doomed = MaxDoomedTimes, score = Score, shop_list = ShopItemes},
            erlang:put({bonus_tree, Type, SubType}, NewBonusTreeStatus)
    end,
    Fun = fun({_, GradeId}, Acc) ->
        [GradeId|Acc]
    end,
    Grades = lists:foldl(Fun, [], Pool),
    ShowList = construct_reward_list_for_client(Player, Type, SubType, Grades),
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    TotalList = lists:subtract(GradeIdList, Grades),
    TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, AllTimes, GradeState),
    {ShopGradeL, _} = get_shop(Type, SubType),
    ShopShowList = for_client(Player, Type, SubType, ShopItemes, ShopGradeL),
    % ?PRINT("{Type, SubType}:~p~n,Nowtime:~p~n",[{Type, SubType},utime:unixtime_to_localtime(utime:unixtime())]),
    lib_server_send:send_to_sid(Sid, pt_331, 33190, [Type, SubType, ?SUCCESS, AllTimes, 0, ShowList, TotalShowList, Score, ShopShowList]).
    
% reset_status(Player, SubType) ->
%     Type = ?CUSTOM_ACT_TYPE_BONUS_TREE,
%     delete_informations(Type, SubType),
%     init_data(Player),
%     send_list(Type, SubType, Player#player_status.sid, Player#player_status.id).

reset_status(Player, Type, SubType) ->
    delete_informations(Type, SubType),
    init_data(Player),
    send_list(Player, Type, SubType, Player#player_status.sid, Player#player_status.id),
    {ok, Player}.

send_reward_day_clear(Type, SubType, Wlv, ClearType) ->
    Nowtime = utime:unixtime(),
    ClearTime = lib_custom_act_util:calc_clear_time(Type, SubType, Nowtime),
    List = db:get_all(io_lib:format(<<"select role_id from `custom_act_bonus_tree` 
            where type = ~p and subtype = ~p and utime >= ~p">>, [Type, SubType, ClearTime])),
    NewList = ulists:removal_duplicate(List),
    {_, ShopClear} = get_shop(Type, SubType),
    case lists:keyfind(ClearType, 1, ShopClear) of
        {_, GradeList} ->
            [db_delete_shop(Type, SubType, Grade)|| Grade <- GradeList];
        _ ->
            skip
    end,
    spawn(
        fun() -> 
            [begin 
                timer:sleep(urand:rand(200,500)), 
                send_reward_act_end_helper([H], Type, SubType, Wlv)
            end || H <- NewList] 
        end
    ),
    delete_informations_day(Type, SubType, ClearTime).

send_reward_act_end(Type, SubType, Wlv) ->
    Nowtime = utime:unixtime(),
%%    Zero = utime:unixdate(Nowtime+30),
    Zero = utime:standard_unixdate(Nowtime + 30),
    Utime = Zero,
    List = db:get_all(io_lib:format(<<"select role_id from `custom_act_bonus_tree` 
            where type = ~p and subtype = ~p and utime < ~p">>, [Type, SubType, Utime])),
    NewList = ulists:removal_duplicate(List), 
    spawn(
        fun() -> 
            [begin 
                timer:sleep(urand:rand(200,500)), 
                send_reward_act_end_helper([H], Type, SubType, Wlv)
            end || H <- NewList] 
        end
    ),
    delete_informations(Type, SubType).
    
send_reward_act_end_helper([], _, _, _) -> skip;
send_reward_act_end_helper([H|T], Type, SubType, Wlv) ->
    [RoleId] = H,
    {AllTimes, GradeState, _} = init_data_helper(Type, SubType, RoleId, before),
    {Pool, _, _} = get_pool(Type, SubType),
    Fun1 = fun({_, GradeId}, Acc) ->
        [GradeId|Acc]
    end,
    Grades = lists:foldl(Fun1, [], Pool),
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    TotalList = lists:subtract(GradeIdList, Grades),
    [_, Sex, Lv, Career, _, _, _, _, _, _, _|_]
        = lib_player:get_player_low_data(RoleId),
    TotalShowList = construct_reward_list_for_client(Type, SubType, TotalList, AllTimes, GradeState, Lv, Sex, Career, Wlv),
    Func = fun({_GradeId, _NeedTimes, Reward, States}, Acc) ->
        if
            States == ?HAS_ACHIEVE ->
                [R] = Reward,
                [R|Acc];
            true ->
                Acc
        end
    end,
    RewardList = lists:foldl(Func, [], TotalShowList),
    if
        RewardList =/= []->
            lib_log_api:log_bonus_tree(RoleId, Type, SubType, 0, 0, [], TotalList, RewardList),
            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, RewardList),
            {Title, Content} = get_mail_info(Type),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
        true ->
            skip
    end,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_bonus_tree, reset_status, [Type, SubType]),
    send_reward_act_end_helper(T, Type, SubType, Wlv).
    
init_online_player(Player) ->
    init_data(Player),
    {ok, Player}.

calc_doomed_times(RoleId, Type, SubType, InitType) ->
    case db_select(RoleId, Type, SubType) of
        [DoomedTimes, Utime] ->
            if
                InitType == before ->
                    DoomedTimes;
                true ->
                    case lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), Utime) of
                        true -> DoomedTimes;
                        false -> 0
                    end
            end;
        _ ->
            0
    end.

init_shop(RoleId, Type, SubType) ->
    Res = db:get_row(io_lib:format(<<"select score, stime from custom_act_tree_score where role_id = ~p and type = ~p and subtype = ~p">>, [RoleId, Type, SubType])),
    case Res of
        [Score, _] -> skip;
        _ -> Score = 0
    end,
    List = db:get_all(io_lib:format(<<"select grade, num, stime from custom_act_tree_shop where role_id = ~p and type = ~p and subtype = ~p">>, [RoleId, Type, SubType])),
    Fun = fun([Grade, Num, Stime], Acc) ->
        [{Grade, Num, Stime}||Acc]
    end,
    ShopItemes = lists:foldl(Fun, [], List),
    {Score, ShopItemes}.

%% 获得产出类型
get_produce_type(?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE) -> custom_act_mount_turntable;
get_produce_type(?CUSTOM_ACT_TYPE_BONUS_TREE) -> bonus_tree;
get_produce_type(?CUSTOM_ACT_TYPE_RUSH_TREASURE) -> rush_treasure;
% get_produce_type(?CUSTOM_ACT_TYPE_DRAW_REWARD) -> draw_reward_special;
get_produce_type(_) -> unkown.

%% 获得消耗类型
get_consume_type(?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE) -> custom_act_mount_turntable;
get_consume_type(?CUSTOM_ACT_TYPE_BONUS_TREE) -> bonus_tree;
get_consume_type(?CUSTOM_ACT_TYPE_RUSH_TREASURE) -> rush_treasure;
% get_consume_type(?CUSTOM_ACT_TYPE_DRAW_REWARD) -> draw_reward_special;
get_consume_type(_) -> unkown.


%% 获得邮件
get_mail_info(Type) ->
    case Type of
        ?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE -> Title = utext:get(3310048), Content = utext:get(3310049);
        % ?CUSTOM_ACT_TYPE_DRAW_REWARD -> Title = utext:get(3310050),Content = utext:get(3310051);
        _ -> Title = utext:get(3310042), Content = utext:get(3310043)
    end,
    {Title, Content}.

refresh_player_data(RoleId, MoneyType) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_bonus_tree, refresh_player, [MoneyType]).

refresh_player(Player, MoneyType) ->
    #player_status{currency_map = CMap} = Player,
    NewMap = maps:put(MoneyType, 0, CMap),
    {ok, Player#player_status{currency_map = NewMap}}.