%%-----------------------------------------------------------------------------
%% @Module  :       lib_select_pool_draw
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2018-12-08
%% @Description:    自选奖池抽奖活动
%%-----------------------------------------------------------------------------
-module(lib_select_pool_draw).

-include("common.hrl").
-include("server.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_goods.hrl").

-export([
        login/1
        ,init_data_lv_up/1
        ,act_start/2
        ,act_end/3
        ,send_info/3
        ,role_choose_pool/4
        ,reset_act/3
        ,draw/4
        ,calc_rand_pool/3
        ,recieve_stage_reward/4
        ,calc_real_pool/2
        ,calc_rare/4
        ,calc_data_after_draw/4
        ,calc_draw_pool/5
]).

-export([
        act_start/3
        ,act_end/4
    ]).

-record(select_pool,  {
        key = {0,0}         %% 键{AcType, ActSbutype}
        ,draw_times = 0     %% 抽奖次数
        ,reset_times = 0    %% 重置次数
        ,pool = []          %% 玩家奖池
        ,can_reset_pool = 0 %% 是否可以重置奖池
        ,stage_state = []   %% 阶段奖励状态
        ,utime = 0          %% 时间
    }).

-define(SQL_SELECT,  "SELECT `draw_times`, `reset`, `can_reset_pool`, `pool`, `stage_state`, `utime` FROM `role_choose_pool_draw` 
                WHERE `role_id` = ~p and `type` = ~p and subtype = ~p").

-define(SQL_SELECT_TYPE,  "SELECT `role_id`, `draw_times`, `reset`, `can_reset_pool`, `pool`, `stage_state`, `utime` FROM `role_choose_pool_draw` 
                WHERE `type` = ~p and subtype = ~p").

-define(SQL_REPLACE, "REPLACE INTO `role_choose_pool_draw`(`role_id`, `type`, `subtype`, `draw_times`, `reset`, `can_reset_pool`, `pool`, `stage_state`, `utime`)
                        VALUES(~p,~p,~p,~p,~p,~p,'~s','~s', ~p)").

-define(SQL_DELETE,  "DELETE FROM `role_choose_pool_draw` WHERE `type` = ~p and `subtype` = ~p and `role_id` = ~p").

-define(SQL_DELETE_1, "DELETE FROM `role_choose_pool_draw` WHERE `type` = ~p and `subtype` = ~p").

-define(SQL_TRUNCATE, "TRUNCATE TABLE `role_choose_pool_draw`").

-define(NOT_ACHIEVE, 0).        %% 未达成
-define(HAS_ACHIEVE, 1).        %% 已达成未领取
-define(HAS_RECIEVE, 2).        %% 已领取

-define(HAS_DRAW,    1).        %% 被抽中
-define(NOT_DRAW,    0).        %% 未被抽中

-define(RARE_NORMAL,  0).       %% 稀有
-define(RARE_SPECIAL, 1).       %% 史诗
-define(RARE_RARE,    2).       %% 传说

db_select(RoleId, Type, SubType) ->
    Sql = io_lib:format(?SQL_SELECT, [RoleId, Type, SubType]),
    case db:get_row(Sql) of
        [Drawtimes, Reset, CanRest, Pool, Stage, Utime] ->
            [Drawtimes, Reset, CanRest, util:bitstring_to_term(Pool), util:bitstring_to_term(Stage), Utime];
        _ -> 
            []
    end.

db_replace(RoleId, Type, SubType, Drawtimes, Reset, CanRest, Pool, Stage) ->
    Sql = io_lib:format(?SQL_REPLACE, [RoleId, Type, SubType, Drawtimes, Reset, CanRest, util:term_to_string(Pool), util:term_to_string(Stage), utime:unixtime()]),
    db:execute(Sql).

db_replace(RoleId, DrawData) when is_record(DrawData, select_pool) ->
    #select_pool{key = {Type, SubType}, draw_times = Drawtimes, pool = Pool, reset_times = Reset, can_reset_pool = CanRest, utime = Utime, stage_state = Stage} = DrawData,
    Sql = io_lib:format(?SQL_REPLACE, [RoleId, Type, SubType, Drawtimes, Reset, CanRest, util:term_to_string(Pool), util:term_to_string(Stage), Utime]),
    db:execute(Sql);
db_replace(_, _) -> skip.

db_delete(Type, SubType, RoleId) ->
    Sql = io_lib:format(?SQL_DELETE, [Type, SubType, RoleId]),
    db:execute(Sql).

% db_delete_type(Type, SubType) ->
%     Sql = io_lib:format(?SQL_DELETE_1, [Type, SubType]),
%     db:execute(Sql).

% db_truncate() ->
%     Sql = io_lib:format(?SQL_TRUNCATE, []),
%     db:execute(Sql).

%% 登陆
login(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    TypeList = [?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW],
    Fun = fun(Type, TemMap) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        Fun2 = fun(SubType, TemMap1) ->
            case init_data(Type, SubType, RoleLv, RoleId, Sex, Career) of
                DrawData when is_record(DrawData, select_pool) ->
                    maps:put({Type, SubType}, DrawData, TemMap1);
                _ ->
                    TemMap1
            end
        end,
        lists:foldl(Fun2, TemMap, SubTypes)
    end,
    ActData = lists:foldl(Fun, #{}, TypeList),
    Player#player_status{select_pool = ActData}.

%% 升级
init_data_lv_up(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, select_pool = ActData} = Player,
    TypeList = [?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW],
    Fun = fun(Type, TemMap) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        Fun2 = fun(SubType, TemMap1) ->
            case maps:get({Type, SubType}, TemMap1, []) of
                #select_pool{} -> TemMap1;
                _ ->
                    case init_data_lv_up_helper(RoleId, Type, SubType, RoleLv) of
                        DrawData when is_record(DrawData, select_pool) ->
                            maps:put({Type, SubType}, DrawData, TemMap1);
                        _ ->
                            TemMap1
                    end
            end
        end,
        lists:foldl(Fun2, TemMap, SubTypes)
    end,
    NewActData = lists:foldl(Fun, ActData, TypeList),
    NewPlayer = Player#player_status{select_pool = NewActData},
    % send_info(NewPlayer, Type, SubType),
    NewPlayer.

init_data_lv_up_helper(RoleId, Type, SubType, RoleLv) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    LimitLv = get_conditions(role_lv, Conditions),
    if
        RoleLv == LimitLv ->
            % ?PRINT("@@@@ Pool:~p~n",[calc_default_pool(Type, SubType, Conditions, RealWave)]),
            {Stage, _} = calc_default_stage_state(Type, SubType),
            DrawData = #select_pool{
                        key = {Type, SubType}
                        ,draw_times = 0
                        ,reset_times = 0
                        ,can_reset_pool = 1    
                        ,pool = []
                        ,stage_state = Stage
                        ,utime = utime:unixtime()},
            db_replace(RoleId, Type, SubType, 0, 0, 1, [], Stage);
        true -> DrawData = []
    end,
    DrawData.

%% 活动开启
act_start(Type, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        Fun = fun(E) ->
            timer:sleep(20),
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_select_pool_draw, act_start, [Type, SubType])
        end,
        lists:foreach(Fun, OnlineRoles)
        end).

act_start(Player, Type, SubType) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, sex = Sex, career = Career}, select_pool = ActData} = Player,
    #custom_act_cfg{condition = Conditions, clear_type = ClearType} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    LimitLv = get_conditions(role_lv, Conditions),
    if
        RoleLv >= LimitLv andalso RoleLv > 0->
            case maps:get({Type, SubType}, ActData, []) of
                #select_pool{draw_times = Drawtimes, reset_times = Reset, utime = Utime,
                can_reset_pool = CanRest, pool = Pool, stage_state = Stage} = OldDrawData ->
                    {NewDrawtimes, NewReset, NewCanRest, NewPool, NewStage, NewUtime} = 
                        init_data_helper(Type, SubType, RoleId, RoleLv, Sex, Career, ClearType, 
                            Drawtimes, Reset, CanRest, Pool, Stage, Utime
                        ),
                        DrawData = OldDrawData#select_pool{
                            key = {Type, SubType}
                            ,draw_times = NewDrawtimes
                            ,reset_times = NewReset
                            ,can_reset_pool = NewCanRest    
                            ,pool = NewPool
                            ,stage_state = NewStage
                            ,utime = NewUtime},
                        NewActData = maps:put({Type, SubType}, DrawData, ActData);
                _ ->
                    case init_data(Type, SubType, RoleLv, RoleId, Sex, Career) of
                        DrawData when is_record(DrawData, select_pool) ->
                            NewActData = maps:put({Type, SubType}, DrawData, ActData);
                        _ ->
                            NewActData = ActData
                    end
            end;
        true ->
            NewActData = ActData
    end,
    {ok, Player#player_status{select_pool = NewActData}}.

%% 活动结束
act_end(Type, SubType, WLv) ->
    spawn(fun() ->
        Sql = io_lib:format(?SQL_SELECT_TYPE, [Type, SubType]),
        List = db:get_all(Sql),
        Fun = fun([RoleId, _, _, _, _, Stage, _]) ->
            case lib_player:is_online_global(RoleId) of
                true -> lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_select_pool_draw, act_end, [Type, SubType, WLv]);
                _ ->
                    [_, Sex, Lv, Career, _, _, _, _, _, _, _|_]
                            = lib_player:get_player_low_data(RoleId),
                    send_reward_data_clear(Type, SubType, WLv, RoleId, Lv, Sex, Career, util:bitstring_to_term(Stage))
            end
        end,
        lists:foreach(Fun, List)
        end).

act_end(Player, Type, SubType, WLv) ->
    #player_status{id = RoleId, select_pool = ActData, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    NewActData = maps:remove({Type, SubType}, ActData),
    case maps:get({Type, SubType}, ActData, []) of
        #select_pool{stage_state = Stage} -> 
            send_reward_data_clear(Type, SubType, WLv, RoleId, RoleLv, Sex, Career, Stage);
        _ ->
            skip
    end,
    {ok, Player#player_status{select_pool = NewActData}}.

%% 界面协议
send_info(Player, Type, SubType) ->
    #player_status{id = RoleId, select_pool = ActData, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    case maps:get({Type, SubType}, ActData, []) of
        #select_pool{draw_times = Drawtimes, reset_times = Reset, stage_state = Stage, pool = Pool} -> 
            SendSelectPool = make_reward_info(Type, SubType),
            % ?PRINT("============== 33128 Pool:~p~n", [lists:keysort(2, Pool)]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33128, [Type, SubType, Drawtimes, Reset, lists:keysort(2, Pool), Stage, SendSelectPool]);
        _ ->
            case init_data(Type, SubType, RoleLv, RoleId, Sex, Career) of
                #select_pool{draw_times = Drawtimes, reset_times = Reset, stage_state = Stage, pool = Pool} ->
                    SendSelectPool = make_reward_info(Type, SubType),
                    lib_server_send:send_to_uid(RoleId, pt_331, 33128, [Type, SubType, Drawtimes, Reset, lists:keysort(2, Pool), Stage, SendSelectPool]);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33128, [Type, SubType, 0, 0, [], [], []])
            end 
    end.

%% 选奖池
role_choose_pool(Player, Type, SubType, []) ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    Pool = calc_default_pool(Type, SubType, ActConditions),
    role_choose_pool(Player, Type, SubType, Pool);

role_choose_pool(Player, Type, SubType, Pool) ->
    #player_status{id = RoleId, select_pool = ActData, figure = #figure{name = RoleName, lv = RoleLv, sex = Sex, career = Career}} = Player,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case check_role_choose_pool(ActConditions, Pool) of
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33129, [Type, SubType, [], ErrorCode]);
        _ ->
            case maps:get({Type, SubType}, ActData, []) of
                #select_pool{reset_times = Reset, can_reset_pool = CanRest} = DrawData when CanRest == 1 ->
                    RealPool = calc_real_pool(Pool, []),
                    NewDrawData = DrawData#select_pool{pool = RealPool, utime = utime:unixtime(), can_reset_pool = 0},
                    db_replace(RoleId, NewDrawData),
                    NewActData = maps:put({Type, SubType}, NewDrawData, ActData),
                    %% 日志
                    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                    #act_info{wlv = WLv} = ActInfo,
                    RewardList = get_reward_for_log(Type, SubType, WLv, RoleLv, Sex, Career, Pool, []),
                    Cost = get_refresh_cost(ActConditions, Reset),
                    lib_log_api:log_select_pool_rest(RoleId, RoleName, Type, SubType, RewardList, Reset, Cost),
                    NewPS = Player#player_status{select_pool = NewActData},
                    lib_server_send:send_to_uid(RoleId, pt_331, 33129, [Type, SubType, lists:keysort(2, RealPool), ?SUCCESS]),
                    ?PRINT("============== 33129 Pool:~p~n", [lists:keysort(2, RealPool)]),
                    {ok, NewPS};
                #select_pool{} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33129, [Type, SubType, [], ?ERRCODE(err331_reset_before_choose)]);
                _ ->
                    case init_data(Type, SubType, RoleLv, RoleId, Sex, Career) of
                        #select_pool{reset_times = Reset, can_reset_pool = CanRest} = DrawData when CanRest == 1 ->
                            RealPool = calc_real_pool(Pool, []), 
                            NewDrawData = DrawData#select_pool{pool = RealPool, utime = utime:unixtime(), can_reset_pool = 0},
                            db_replace(RoleId, NewDrawData),
                            NewActData = maps:put({Type, SubType}, NewDrawData, ActData),
                            %% 日志
                            ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                            #act_info{wlv = WLv} = ActInfo,
                            RewardList = get_reward_for_log(Type, SubType, WLv, RoleLv, Sex, Career, Pool, []),
                            Cost = get_refresh_cost(ActConditions, Reset),
                            lib_log_api:log_select_pool_rest(RoleId, RoleName, Type, SubType, RewardList, Reset, Cost),
                            NewPS = Player#player_status{select_pool = NewActData},
                            lib_server_send:send_to_uid(RoleId, pt_331, 33129, [Type, SubType, lists:keysort(2, RealPool), ?SUCCESS]),
                            {ok, NewPS};
                        #select_pool{} ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33129, [Type, SubType, [], ?ERRCODE(err331_reset_before_choose)]);
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33129, [Type, SubType, [], ?ERRCODE(err331_lv_not_enougth)])
                    end
            end       
    end.

%% 选奖池
calc_rand_pool(Player, Type, SubType) ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    Pool = calc_default_pool(Type, SubType, ActConditions),
    lib_server_send:send_to_uid(Player#player_status.id, pt_331, 33139, [Type, SubType, lists:keysort(2, Pool)]),
    ?PRINT("============== 33139 Pool:~p~n", [lists:keysort(2, Pool)]),
    {ok, Player}.

%% 重置
reset_act(Player, Type, SubType) ->
    #player_status{id = RoleId, select_pool = ActData, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case maps:get({Type, SubType}, ActData, []) of
        #select_pool{pool = Pool, reset_times = Reset, stage_state = Stage} ->
            reset_act_core(Type, SubType, ActConditions, Reset, Stage, Pool, Player);
        _ ->
            case init_data(Type, SubType, RoleLv, RoleId, Sex, Career) of
                #select_pool{pool = Pool, reset_times = Reset, stage_state = Stage} ->
                    reset_act_core(Type, SubType, ActConditions, Reset, Stage, Pool, Player);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33133, [Type, SubType, ?ERRCODE(err331_lv_not_enougth), 0, 0, [], []])
            end
    end.

reset_act_core(Type, SubType, ActConditions, Reset, Stage, Pool, Player) ->        
    case check_stage_before_reset(Stage) of
        true ->
            case get_refresh_cost(ActConditions, Reset+1) of
                Cost when is_list(Cost) ->
                    case check_before_draw(Pool) of
                        {false, _, draw} -> %% 奖池抽完不需要消耗货币重置
                            {NewStage, _} = calc_default_stage_state(Type, SubType),
                            NewDrawData = #select_pool{key = {Type, SubType}, draw_times = 0, reset_times = Reset + 1, pool = [], can_reset_pool = 1, stage_state = NewStage, utime = utime:unixtime()},
                            ?PRINT("NewDrawData:~p~n",[NewDrawData]),
                            db_replace(Player#player_status.id, NewDrawData),
                            NewActData = maps:put({Type, SubType}, NewDrawData, Player#player_status.select_pool),
                            NewPS = Player#player_status{select_pool = NewActData},
                            lib_server_send:send_to_uid(Player#player_status.id, pt_331, 33133, [Type, SubType, ?SUCCESS, 0, Reset+1, [], NewStage]),
                            {ok, NewPS};
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, select_pool_rest, [Reset+1]) of
                                {false, ErrorCode, NewPlayer} -> 
                                    lib_server_send:send_to_uid(Player#player_status.id, pt_331, 33133, [Type, SubType, ErrorCode, 0, 0, [], []]),
                                    {ok, NewPlayer};
                                {true, NewPlayer} ->
                                    {NewStage, _} = calc_default_stage_state(Type, SubType),
                                    NewDrawData = #select_pool{key = {Type, SubType}, draw_times = 0, reset_times = Reset + 1, pool = [], can_reset_pool = 1, stage_state = NewStage, utime = utime:unixtime()},
                                    ?PRINT("NewDrawData:~p~n",[NewDrawData]),
                                    db_replace(Player#player_status.id, NewDrawData),
                                    NewActData = maps:put({Type, SubType}, NewDrawData, Player#player_status.select_pool),
                                    NewPS = NewPlayer#player_status{select_pool = NewActData},
                                    lib_server_send:send_to_uid(Player#player_status.id, pt_331, 33133, [Type, SubType, ?SUCCESS, 0, Reset+1, [], NewStage]),
                                    {ok, NewPS}
                            end;
                        _ ->
                            lib_server_send:send_to_uid(Player#player_status.id, pt_331, 33133, [Type, SubType, ?ERRCODE(err331_pool_is_null), 0, 0, [], []])
                    end;
                _ ->
                    lib_server_send:send_to_uid(Player#player_status.id, pt_331, 33133, [Type, SubType, ?ERRCODE(err331_max_reset_num), 0, 0, [], []])
            end;
                
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(Player#player_status.id, pt_331, 33133, [Type, SubType, ErrorCode, 0, 0, [], []])
    end.

draw(Player, Type, SubType, AutoBuy) ->
    #player_status{id = RoleId, select_pool = ActData} = Player,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case maps:get({Type, SubType}, ActData, []) of
        #select_pool{} = DrawData ->
            % ?PRINT("DrawData:~p~n",[DrawData]),
            do_draw(Player, Type, SubType, ActConditions, ActData, DrawData, AutoBuy);
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33134, [Type, SubType, 0, ?ERRCODE(data_error), 0, 0, []])
    end.

do_draw(#player_status{id = RoleId} = Player, Type, SubType, ActConditions, ActData, DrawData, AutoBuy) ->
    #select_pool{draw_times = Drawtimes, pool = Pool, stage_state = Stage} = DrawData,
    Cost = get_draw_cost(ActConditions, Drawtimes+1),
    case check([{is_act_open, Type, SubType}, {draw_cost, Cost, Player, AutoBuy}]) of
        true ->
            case check_before_draw(Pool) of
                {false, ErrorCode, _} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33134, [Type, SubType, Drawtimes, ErrorCode, 0, 0, []]);
                _ ->
                    About = lists:concat(["Type:", Type, "SubType:", SubType]),
                    Res = if
                        AutoBuy == 1 ->
                            lib_goods_api:cost_objects_with_auto_buy(Player, Cost, select_pool_draw, About);
                        true ->
                            case lib_goods_api:cost_object_list(Player, Cost, select_pool_draw, About) of
                                {true, TmpNewPlayer} ->
                                    {true, TmpNewPlayer, Cost};
                                Other ->
                                    Other
                            end
                    end,
                    case Res of
                        {false, ErrorCode, NewPlayer} ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33134, [Type, SubType, Drawtimes, ErrorCode, 0, 0, []]),
                            {ok, NewPlayer};
                        {true, NewPlayer, _CostList} -> 
                            Rare = calc_rare(ActConditions, Drawtimes+1, Pool, []),
                            RealPool = calc_draw_pool(Type, SubType, Rare, Pool, Drawtimes+1),
                            RewardCfg = urand:rand_with_weight(RealPool),
                            {NewPool, NewStage} = calc_data_after_draw(RewardCfg, Pool, Stage, Drawtimes+1),
                            NewDrawData = DrawData#select_pool{draw_times = Drawtimes+1, pool = NewPool, stage_state = NewStage, utime = utime:unixtime()},
                            NewActData = maps:put({Type, SubType}, NewDrawData, ActData),
                            db_replace(NewPlayer#player_status.id, NewDrawData),
                            ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                            #act_info{wlv = WLv} = ActInfo,
                            {GradeId, Reward} = handle_reward(NewPlayer, RewardCfg, WLv),
                            %% 日志
                            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
                            Remark = lists:concat(["Type:", Type, "SubType:", SubType, "GradeId:", GradeId]),
                            Produce = #produce{type = select_pool_draw, reward = Reward, show_tips = ?SHOW_TIPS_0, remark = Remark},
                            NewPlayer2 = lib_goods_api:send_reward(NewPlayer, Produce),
                            lib_server_send:send_to_uid(RoleId, pt_331, 33134, [Type, SubType, Drawtimes+1, ?SUCCESS, GradeId, Rare, Reward]),
                            {ok, NewPlayer2#player_status{select_pool = NewActData}}
                    end
            end;
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33134, [Type, SubType, Drawtimes, ErrorCode, 0, 0, []])
    end.

calc_rare(ActConditions, Drawtimes, Pool, []) ->
    [RareWeight, SpecialWeight, NormalWeight] = get_conditions(rare_weight, ActConditions),
    AddWeightList = get_conditions(add_weight, ActConditions),
    Fun = fun({Min, Max, _RareAddWeight, _SpecialAddWeight, _NormalAddWeight, _}) ->
        Drawtimes >= Min andalso Drawtimes =< Max
    end,
    case ulists:find(Fun, AddWeightList) of
        {ok, {Mint, Maxt, RareAddWeight, SpecialAddWeight, NormalAddWeight, Rare}} ->
            if
                Drawtimes == Maxt ->
                    case judge_draw_rare(Rare, Pool, Mint, Maxt) of
                        true -> %% 次数范围内抽中过
                            RareWeightList = [{RareWeight+RareAddWeight, ?RARE_RARE}, {SpecialWeight+SpecialAddWeight, ?RARE_SPECIAL}, {NormalWeight+NormalAddWeight, ?RARE_NORMAL}],
                            RealRare = urand:rand_with_weight(RareWeightList);
                        false ->
                            RealRare = Rare
                    end;
                true ->
                    RareWeightList = [{RareWeight+RareAddWeight, ?RARE_RARE}, {SpecialWeight+SpecialAddWeight, ?RARE_SPECIAL}, {NormalWeight+NormalAddWeight, ?RARE_NORMAL}],
                    RealRare = urand:rand_with_weight(RareWeightList)
            end;
        _ ->
            RareWeightList = [{RareWeight, ?RARE_RARE}, {SpecialWeight, ?RARE_SPECIAL}, {NormalWeight, ?RARE_NORMAL}],
            RealRare = urand:rand_with_weight(RareWeightList)
    end,
    case judge_rare_pool(RealRare, Pool) of
        true ->
            RealRare;
        false when SpecialWeight == 0 andalso RareWeight == 0 ->
            calc_real_rare(Pool, lists:keydelete(RealRare, 2, [{50, ?RARE_RARE}, {50, ?RARE_SPECIAL}, {50, ?RARE_NORMAL}]));
        _ ->
            calc_rare(ActConditions, Drawtimes, Pool, [RealRare])
    end;
calc_rare(ActConditions, Drawtimes, Pool, [_] = RemoveRareList) ->
    [RareWeight, SpecialWeight, NormalWeight] = get_conditions(rare_weight, ActConditions),
    AddWeightList = get_conditions(add_weight, ActConditions),
    Fun = fun({Min, Max, _RareAddWeight, _SpecialAddWeight, _NormalAddWeight, _}) ->
        Drawtimes >= Min andalso Drawtimes =< Max
    end,
    case ulists:find(Fun, AddWeightList) of
        {ok, {Mint, Maxt, RareAddWeight, SpecialAddWeight, NormalAddWeight, Rare}} ->
            if
                Drawtimes == Maxt ->
                    case judge_draw_rare(Rare, Pool, Mint, Maxt) of
                        true -> %% 次数范围内抽中过
                            RareWeightList = [{RareWeight+RareAddWeight, ?RARE_RARE}, {SpecialWeight+SpecialAddWeight, ?RARE_SPECIAL}, {NormalWeight+NormalAddWeight, ?RARE_NORMAL}],
                            NewList = calc_real_rare_weight_list(RemoveRareList, RareWeightList),
                            RealRare = urand:rand_with_weight(NewList);
                        false ->
                            RealRare = Rare
                    end;
                true ->
                    RareWeightList = [{RareWeight+RareAddWeight, ?RARE_RARE}, {SpecialWeight+SpecialAddWeight, ?RARE_SPECIAL}, {NormalWeight+NormalAddWeight, ?RARE_NORMAL}],
                    NewList = calc_real_rare_weight_list(RemoveRareList, RareWeightList),
                    RealRare = urand:rand_with_weight(NewList)
            end;
        _ ->
            RareWeightList = [{RareWeight, ?RARE_RARE}, {SpecialWeight, ?RARE_SPECIAL}, {NormalWeight, ?RARE_NORMAL}],
            NewList = calc_real_rare_weight_list(RemoveRareList, RareWeightList),
            RealRare = urand:rand_with_weight(NewList)
    end,
    case judge_rare_pool(RealRare, Pool) of
        true ->
            RealRare;
        false when SpecialWeight == 0 andalso RareWeight == 0 ->
            NewRareWeightList = calc_real_rare_weight_list(RemoveRareList, [{50, ?RARE_RARE}, {50, ?RARE_SPECIAL}, {50, ?RARE_NORMAL}]),
            calc_real_rare(Pool, lists:keydelete(RealRare, 2, NewRareWeightList));
        _ ->
            [{_, NewRare}|_] = calc_real_rare_weight_list([RealRare|RemoveRareList], [{50, ?RARE_RARE}, {50, ?RARE_SPECIAL}, {50, ?RARE_NORMAL}]),
            NewRare
    end;
calc_rare(_, _, _, RemoveRareList) ->
    [{_, NewRare}|_] = calc_real_rare_weight_list(RemoveRareList, [{50, ?RARE_RARE}, {50, ?RARE_SPECIAL}, {50, ?RARE_NORMAL}]),
    NewRare.

calc_real_rare_weight_list([], List) -> List;
calc_real_rare_weight_list([Rare|T], RareWeightList) ->
    List = lists:keydelete(Rare, 2, RareWeightList),
    calc_real_rare_weight_list(T, List).

calc_real_rare(_, [{_, RealRare}]) -> RealRare;
calc_real_rare(Pool, List) ->
    % List = [{50, ?RARE_RARE}, {50, ?RARE_SPECIAL}, {50, ?RARE_NORMAL}],
    RealRare = urand:rand_with_weight(List),
    case judge_rare_pool(RealRare, Pool) of
        true ->
            RealRare;
        _ ->
            calc_real_rare(Pool, lists:keydelete(RealRare, 2, List))
    end.

judge_draw_rare(_, [], _, _) -> false;
judge_draw_rare(Rare, [{Rare, _, State}|T], Min, Max) ->
    if
        State == ?HAS_DRAW ->
            true;
        true ->
            judge_draw_rare(Rare, T, Min, Max)
    end;
judge_draw_rare(Rare, [{_, _, _}|T], Min, Max) ->
    judge_draw_rare(Rare, T, Min, Max).

judge_rare_pool(_, []) -> false;
judge_rare_pool(Rare, [{Rare, _, State}|_]) when State == ?NOT_DRAW ->
    true;
judge_rare_pool(Rare, [{_, _, _}|T]) ->
    judge_rare_pool(Rare, T).

calc_draw_pool(Type, SubType, Rare, Pool, Drawtimes) ->
    Fun = fun
        ({TemRare, GradeId, 0}, Acc) when TemRare == Rare ->
            #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            case lists:keyfind(weight, 1, Conditions) of
                {_, Weight} ->
                    [{Weight, RewardCfg}|Acc];
                {_, Weight, TimesList} ->
                    Fun1 = fun({Times, _AddWeight}) ->
                        Drawtimes >= Times
                    end,
                    case ulists:find(Fun1, lists:reverse(lists:keysort(1, TimesList))) of
                        {ok, {_, AddWeight}} ->
                            [{Weight + AddWeight, RewardCfg}|Acc];
                        _ ->
                            [{Weight, RewardCfg}|Acc]
                    end;
                _ ->
                    Acc
            end;
        (_, Acc) ->
            Acc
    end,
    lists:foldl(Fun, [], Pool).


check_before_draw([]) -> {false, ?ERRCODE(err331_pool_is_null), null};
check_before_draw(Pool) ->
    Fun = fun({_, _, State}) ->
        State == 0
    end,
    case ulists:find(Fun, Pool) of
        {_, _} -> true;
        _ -> {false, ?ERRCODE(err331_pool_has_draw), draw}
    end.

%% 领取阶段奖励
recieve_stage_reward(Player, Type, SubType, GradeId) ->
    #player_status{id = RoleId, select_pool = ActData} = Player,
    case maps:get({Type, SubType}, ActData, []) of
        #select_pool{stage_state = Stage} = DrawData ->
            case lists:keyfind(GradeId, 1, Stage) of
                {GradeId, ?NOT_ACHIEVE} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33135, [Type, SubType, GradeId, ?ERRCODE(err331_stage_not_achieve)]);
                {GradeId, ?HAS_RECIEVE} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33135, [Type, SubType, GradeId, ?ERRCODE(err331_stage_has_recieve)]);
                {GradeId, _} ->
                    NewStage = lists:keystore(GradeId, 1, Stage, {GradeId, ?HAS_RECIEVE}),
                    NewDrawData = DrawData#select_pool{stage_state = NewStage, utime = utime:unixtime()},
                    NewActData = maps:put({Type, SubType}, NewDrawData, ActData),
                    db_replace(RoleId, NewDrawData),
                    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                    #act_info{wlv = WLv} = ActInfo,
                    {_, Reward} = handle_reward(Player, RewardCfg, WLv),
                    %% 日志
                    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
                    Remark = lists:concat(["Type:", Type, "SubType:", SubType, "GradeId:", GradeId]),
                    Produce = #produce{type = select_stage_reward, reward = Reward, show_tips = ?SHOW_TIPS_0, remark = Remark},
                    NewPlayer = lib_goods_api:send_reward(Player, Produce),
                    lib_server_send:send_to_uid(RoleId, pt_331, 33135, [Type, SubType, GradeId, ?SUCCESS]),
                    {ok, NewPlayer#player_status{select_pool = NewActData}};
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33135, [Type, SubType, GradeId, ?ERRCODE(data_error)])
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33135, [Type, SubType, GradeId, ?ERRCODE(data_error)])
    end.

%% 内存数据刷新
init_data(Type, SubType, RoleLv, RoleId, Sex, Career) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            #custom_act_cfg{condition = Conditions, clear_type = ClearType} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            LimitLv = get_conditions(role_lv, Conditions),
            if
                RoleLv >= LimitLv andalso RoleLv > 0->
                    case db_select(RoleId, Type, SubType) of
                        [Drawtimes, Reset, CanRest, Pool, Stage, Utime] ->
                            {NewDrawtimes, NewReset, NewCanRest, NewPool, NewStage, NewUtime} = 
                                    init_data_helper(Type, SubType, RoleId, RoleLv, Sex, Career, ClearType, Drawtimes, Reset, CanRest, Pool, Stage, Utime),

                            DrawData = #select_pool{
                                key = {Type, SubType}
                                ,draw_times = NewDrawtimes
                                ,reset_times = NewReset
                                ,can_reset_pool = NewCanRest    
                                ,pool = NewPool
                                ,stage_state = NewStage
                                ,utime = NewUtime};
                        _ -> 
                            {Stage, _} = calc_default_stage_state(Type, SubType),
                            DrawData = #select_pool{
                                key = {Type, SubType}
                                ,draw_times = 0
                                ,reset_times = 0
                                ,can_reset_pool = 1    
                                ,pool = []
                                ,stage_state = Stage
                                ,utime = utime:unixtime()}
                    end;
                true -> DrawData = []
            end;
        _ ->
            DrawData = []
    end,
    DrawData.

init_data_helper(Type, SubType, RoleId, Lv, Sex, Career, ClearType, Drawtimes, Reset, CanRest, Pool, Stage, Utime) ->
    Now = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = WLv} -> skip;
        _ -> WLv = 10
    end,
    if
        ClearType == ?CUSTOM_ACT_CLEAR_ZERO ->
            case utime:is_same_day(Now, Utime) of
                false ->
                    send_reward_data_clear(Type, SubType, WLv, RoleId, Lv, Sex, Career, Stage),
                    {NewStage, _} = calc_default_stage_state(Type, SubType),
                    % NewPool = reset_default_pool(Pool, []),
                    NewPool = [], NewCanRest = 1,
                    NewDrawtimes = 0, NewReset = 0, NewUtime = Now,
                    db_replace(RoleId, Type, SubType, NewDrawtimes, NewReset, NewCanRest, NewPool, NewStage);
                _ ->
                    NewDrawtimes = Drawtimes, NewReset = Reset, NewPool = Pool, 
                    NewStage = Stage, NewUtime = Utime, NewCanRest = CanRest
            end;
        ClearType == ?CUSTOM_ACT_CLEAR_FOUR ->
            case utime_logic:is_logic_same_day(Now, Utime) of
                false ->
                    send_reward_data_clear(Type, SubType, WLv, RoleId, Lv, Sex, Career, Stage),
                    {NewStage, _} = calc_default_stage_state(Type, SubType),
                    NewPool = [], NewCanRest = 1,
                    % NewPool = reset_default_pool(Pool, []),
                    NewDrawtimes = 0, NewReset = 0, NewUtime = Now,
                    db_replace(RoleId, Type, SubType, NewDrawtimes, NewReset, NewCanRest, NewPool, NewStage);
                _ ->
                    NewDrawtimes = Drawtimes, NewReset = Reset, NewPool = Pool, 
                    NewStage = Stage, NewUtime = Utime, NewCanRest = CanRest
            end;
        true ->
            NewDrawtimes = Drawtimes, NewReset = Reset, NewPool = Pool, 
            NewStage = Stage, NewUtime = Utime, NewCanRest = CanRest
    end,
    {NewDrawtimes, NewReset, NewCanRest, NewPool, NewStage, NewUtime}.

%% 清理数据时发未领取奖励邮件
send_reward_data_clear(Type, SubType, WLv, RoleId, Lv, Sex, Career, StageState) ->
    F1 = fun({GradeId, ?HAS_ACHIEVE}, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{} = RewardCfg ->
                Reward = calc_reward(WLv, Lv, Sex, Career, RewardCfg),
                %% 日志
                lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
                Reward ++ Acc;
            _ -> Acc
        end;
        (_, Acc) -> Acc
    end,
    Rewards = lists:foldl(F1, [], StageState),
    {Title, Content} = get_mail_info(Type),
    db_delete(Type, SubType, RoleId),
    if
        Rewards =/= [] ->
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Rewards);
        true ->
            skip
    end.

get_reward_for_log(_, _, _, _, _, _, [], Acc) -> Acc;
get_reward_for_log(Type, SubType, WLv, Lv, Sex, Career, [{_, GradeId}|ClientPool], Acc) ->
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    Reward = calc_reward(WLv, Lv, Sex, Career, RewardCfg),
    get_reward_for_log(Type, SubType, WLv, Lv, Sex, Career, ClientPool, Reward++Acc).

% %% 将奖池重置到未抽奖状态
% reset_default_pool([], Acc) -> Acc;
% reset_default_pool([{Rare, GradeId, _}|T], Acc) ->
%     reset_default_pool(T, [{Rare, GradeId, ?NOT_DRAW}|Acc]).

%% 计算默认阶段奖励
calc_default_stage_state(Type, SubType) ->
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun = fun(GradeId, {Acc, Acc1}) ->
        #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lists:keyfind(stage, 1, Conditions) of
            {stage, _} ->
                {[{GradeId, ?NOT_ACHIEVE}|Acc], Acc1};
            _ ->
                {Acc, [GradeId|Acc1]}
        end
    end,
    lists:foldl(Fun, {[], []}, AllIds).

%% 将客户端数据转换为服务端奖池数据
calc_real_pool([], Acc) -> Acc;
calc_real_pool([{Rare, GradeId}|T], Acc) -> 
    calc_real_pool(T, [{Rare, GradeId, ?NOT_DRAW}|Acc]).

%% 计算默认奖池（客户端数据）
calc_default_pool(Type, SubType, ActConditions) ->
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lists:keyfind(rare, 1, Conditions) of
            {rare, Rare} ->
                case lists:keyfind(Rare, 1, Acc) of
                    {Rare, GradeIdL} ->
                        lists:keystore(Rare, 1, Acc, {Rare, [{Rare, GradeId}|GradeIdL]});
                    _ ->
                        lists:keystore(Rare, 1, Acc, {Rare, [{Rare, GradeId}]})
                end;
            _ ->
                Acc
        end
    end,
    RareGrade = lists:foldl(Fun, [], AllIds),
    F1 = fun({Rare, GradeIdL}, Acc) ->
        if
            Rare == ?RARE_NORMAL ->
                Num = get_conditions(rare_0, ActConditions);
            Rare == ?RARE_SPECIAL ->
                Num = get_conditions(rare_1, ActConditions);
            true ->
                Num = get_conditions(rare_2, ActConditions)
        end,
        NewGrade = urand:get_rand_list(Num, GradeIdL),
        NewGrade++Acc
    end,
    lists:foldl(F1, [], RareGrade).

%% 获取所有奖励信息
make_reward_info(Type, SubType) ->
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun3 = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{name = Name, desc = Desc, condition = Conditions, format = Format, reward = Reward} = 
                lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        ConditionStr = util:term_to_string(Conditions),
        RewardStr = util:term_to_string(Reward),
        [{GradeId, Format, Name, Desc, ConditionStr, RewardStr}|Acc]
    end,
    lists:foldl(Fun3, [], AllIds).

%% 计算奖励
calc_reward(WLv, Lv, Sex, Career, RewardCfg) ->
    RewardParam = lib_custom_act:make_rwparam(Lv, Sex, WLv, Career),
    lib_custom_act_util:count_act_reward(RewardParam, RewardCfg).

get_conditions(Key,Conditions) ->
    case lists:keyfind(Key, 1, Conditions) of
        {Key, Times} ->skip;
        _ -> Times = 0
    end,
    Times.

check_role_choose_pool(ActConditions, Pool) ->
    Rare0Num = get_conditions(rare_0, ActConditions),
    Rare1Num = get_conditions(rare_1, ActConditions),
    Rare2Num = get_conditions(rare_2, ActConditions),
    LimitL = [{?RARE_NORMAL, Rare0Num},{?RARE_SPECIAL, Rare1Num}, {?RARE_RARE, Rare2Num}],
    Fun = fun({Rare, GradeId}, {Acc, Acc1}) ->
        NewAcc = case lists:keyfind(Rare, 1, Acc) of
            {_, Num} -> lists:keystore(Rare, 1, Acc, {Rare, Num+1});
            _ -> lists:keystore(Rare, 1, Acc, {Rare, 1})
        end,
        {NewAcc, [GradeId|Acc1]}
    end,
    {RareNumL, GradeIdL} = lists:foldl(Fun, {[], []}, Pool),
    ?PRINT(" RareNumL:~p,LimitL:~p,Pool:~p~n",[RareNumL, LimitL, Pool]),
    check([{pool_num, LimitL, RareNumL}, {has_same_grade, GradeIdL}]).

check([{pool_num, [], _}|T]) ->
    check(T);
check([{pool_num, [{?RARE_NORMAL, Rare0Num}|List], RareNumL}|T]) ->
    case lists:keyfind(?RARE_NORMAL, 1, RareNumL) of
        {_, Num} ->
            if
                Num == Rare0Num ->
                    check([{pool_num, List, RareNumL}|T]);
                true ->
                    {false, ?ERRCODE(err331_rare_normal_num_not_enougth)}
            end
    end;
check([{pool_num, [{?RARE_SPECIAL, Rare0Num}|List], RareNumL}|T]) ->
    case lists:keyfind(?RARE_SPECIAL, 1, RareNumL) of
        {_, Num} ->
            if
                Num == Rare0Num ->
                    check([{pool_num, List, RareNumL}|T]);
                true ->
                    {false, ?ERRCODE(err331_rare_special_num_not_enougth)}
            end
    end;
check([{pool_num, [{?RARE_RARE, Rare0Num}|List], RareNumL}|T]) ->
    case lists:keyfind(?RARE_RARE, 1, RareNumL) of
        {_, Num} ->
            if
                Num == Rare0Num ->
                    check([{pool_num, List, RareNumL}|T]);
                true ->
                    {false, ?ERRCODE(err331_rare_rare_num_not_enougth)}
            end
    end;
check([{has_same_grade, []}|T]) -> check(T);
check([{has_same_grade, GradeIdL}|T]) ->
    [H|Tl] = GradeIdL,
    case lists:member(H, T) of
        true ->
            {false, ?ERRCODE(err331_has_same_grade)};
        _ ->
            check([{has_same_grade, Tl}|T])
    end;
check([{is_act_open, Type, SubType}|T]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            check(T);
        _ ->
            {false, ?ERRCODE(err331_act_close)}
    end;
check([{draw_cost, Cost, Player, AutoBuy}|T]) ->
    if
        AutoBuy == 1 ->
            case lib_goods_api:check_object_list_with_auto_buy(Player, Cost) of
                {false, ErrorCode} -> {false, ErrorCode};
                true -> check(T)
            end;
        true ->
            case lib_goods_api:check_object_list(Player, Cost) of
                {false, ErrorCode} -> {false, ErrorCode};
                true -> check(T)
            end
    end;

check(_) -> true.

check_stage_before_reset([]) -> true;
check_stage_before_reset([{_, State}|_]) when State == ?HAS_ACHIEVE ->
    {false, ?ERRCODE(stage_reward_not_recieve)};
check_stage_before_reset([{_, _}|T]) ->
    check_stage_before_reset(T).

get_refresh_cost(ActConditions, Reset) ->
    RefreshCost = case get_conditions(refresh, ActConditions) of
                        List when is_list(List) -> List;
                        _ -> []
                  end,
    Fun = fun({Min, Max, _Cost}) ->
        Reset >= Min andalso Reset =< Max
    end,
    case ulists:find(Fun, RefreshCost) of
        {ok, {_,_, Cost}} -> 
            Cost;
        _ ->
            {false, ?ERRCODE(err331_max_reset_num)}
    end.

get_draw_cost(ActConditions, Drawtimes) ->
    case lists:keyfind(cost, 1, ActConditions) of
        {cost, CostListCfg} ->
            Fun = fun({Min, Max, _Cost}) ->
                Drawtimes >= Min andalso Drawtimes =< Max
            end,
            case ulists:find(Fun, CostListCfg) of
                {_, {_, _, Cost}} ->
                    Cost;
                _ ->
                    Cost = []
            end;
        _ ->
            Cost = []
    end,
    Cost.

calc_data_after_draw(RewardCfg, Pool, Stage, Drawtimes) ->
    #custom_act_reward_cfg{type = Type, subtype = SubType, grade = GradeId} = RewardCfg,
    case lists:keyfind(GradeId, 2, Pool) of
        {Rare, _, _} -> NewPool = lists:keystore(GradeId, 2, Pool, {Rare, GradeId, Drawtimes});
        _ ->
            ?ERR("{Type,SubType}:~p Role Pool is:~p,Reward GradeId is:~p~n",[{Type, SubType}, Pool, GradeId]),
            NewPool = Pool
    end,
    NewStage = calc_stage_after_draw(Type, SubType, Drawtimes, Stage, Stage),
    {NewPool, NewStage}.

calc_stage_after_draw(_, _, _, [], Acc) -> Acc;
calc_stage_after_draw(Type, SubType, Drawtimes, [{GradeId, State}|T], Acc) when State == ?NOT_ACHIEVE ->
    #custom_act_reward_cfg{condition = Conditions} =  lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case lists:keyfind(stage, 1, Conditions) of
        {stage, NeedDrawTimes} when NeedDrawTimes =< Drawtimes ->
            NewAcc = lists:keystore(GradeId, 1, Acc, {GradeId, ?HAS_ACHIEVE});
        _ ->
            NewAcc = Acc
    end,
    calc_stage_after_draw(Type, SubType, Drawtimes, T, NewAcc);
calc_stage_after_draw(Type, SubType, Drawtimes, [{_, _}|T], Acc) ->
    calc_stage_after_draw(Type, SubType, Drawtimes, T, Acc).

handle_reward(Player, RewardCfg, WLv) ->
    #player_status{id = RoleId, figure = #figure{name = _Name, lv = RoleLv, sex = Sex, career = Career}} = Player,
    #custom_act_reward_cfg{type = Type, subtype = SubType, grade = GradeId, condition = Conditions} =  RewardCfg,
    Name = lib_player:get_wrap_role_name(Player),
    Reward = calc_reward(WLv, RoleLv, Sex, Career, RewardCfg),
    spawn(fun() ->
        timer:sleep(2000),  %% 客户端要求延时2s确保动画播放完毕
        case lists:keyfind(tv, 1, Conditions) of
            {tv, TvId} ->
                case Reward of
                    [{Gtype, GoodsTypeId, Num}|_] ->
                        RealGtypeId = lib_custom_act_util:get_real_goodstypeid(GoodsTypeId, Gtype),
                        lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, TvId, [Name, RoleId, RealGtypeId, Num, Type, SubType]);
                    _ -> skip
                end;
            _ ->
                skip
        end
    end),
    {GradeId, Reward}.

% %% 获得邮件
get_mail_info(_Type) ->
    Title = utext:get(3310060), Content = utext:get(3310061),
    {Title, Content}.

