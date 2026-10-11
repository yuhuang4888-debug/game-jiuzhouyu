%%-----------------------------------------------------------------------------
%% @Module  :       pp_top_pk.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-05
%% @Description:    巅峰竞技
%%-----------------------------------------------------------------------------

-module (pp_top_pk).    
-include ("common.hrl").
-include("def_goods.hrl").
-include ("daily.hrl").
-include ("server.hrl").
-include("def_fun.hrl").
-include ("def_module.hrl").
-include ("figure.hrl").
-include("predefine.hrl").
-include ("top_pk.hrl").
-include ("errcode.hrl").
-include ("goods.hrl").
-include ("def_vip.hrl").

-export ([handle/3]).


handle(CMD, PS, Args) ->
    #player_status{figure = #figure{lv = Lv}, top_pk = PKStatus, sid = Sid} = PS,
    OpenLv = data_top_pk:get_kv(default, open_lv),
    NoLvLimit = lib_top_pk:is_not_lv_limit_cmd(CMD),
    if
        (NoLvLimit == true) orelse (Lv >= OpenLv) ->
            if
                PKStatus =:= undefined ->
                    NewPS = lib_top_pk:load_data(PS);
                true ->
                    NewPS = PS
            end,
            case do_handle(CMD, NewPS, Args) of
                {ok, NewPS1} ->
                    {ok, NewPS1};
                _ ->
                    {ok, NewPS}
            end;
        true ->
            send_error(Sid, ?ERRCODE(lv_limit))
    end.

%% ############# 基本信息 ##############
%%protocol=28101
%%{
%%    c2s{
%%    }
%%    s2c{
%%        season_num:int16        // 赛季序号
%%        season_end_time:int32   // 赛季结束时间
%%        // grade:int8              // 段位
%%        rank_lv:int8            // 段位等级
%%        point:int8              // 积分
%%        // his_count:int32         // 历史总次数
%%        // his_win_count:int32     // 历史胜利次数
%%        season_count:int32      // 本赛季总次数
%%        season_win_count:int32  // 本赛季胜利次数
%%        daily_honor_value:int32 // 每日可领取荣誉值
%%        honor_is_got:int8       // 每日荣誉值领取状态 0否1是
%%        daily_count:int16       // 每日匹配次数
%%        daily_reward_counts:array{
%%            count:int8  // 次数
%%            state:int8  // 状态 0已领取 1未达成 2可领取
%%        } // 已经领奖的次数列表
%%        daily_buy_count:int16   // 日常购买次数
%%    }
%%    // 日常剩余次数=配置次数+日常购买次数-日常匹配次数
%%    //
%%}
do_handle(28101, PS, []) ->
    #player_status{top_pk = PKStatus, id = RoleId, sid = Sid, figure = Figure} = PS,
    OpenLv = data_top_pk:get_kv(default, open_lv),
    #top_pk_status{
        season_id = SeasonId, 
        rank_lv = RankLv,
        point = Point,
        % history_match_count = HistoryMatchCount,
        % history_win_count = HistoryWinCount,
        % serial_win_count = SerialWinCount,
        season_match_count = SeasonMatchCount,
        season_win_count = SeasonWinCount,
        % season_reward_status = SeasonRewardStatus,
        yesterday_rank_lv = YesterdayRankLv,
        daily_honor_value = DailyHonorValue
    } = PKStatus,
%%    SeasonEndTime = lib_top_pk:get_season_end_time(),
	SeasonEndTime = lib_top_pk:get_show_season_time(),
%%	?MYLOG("cym", "SeasonEndTime ~p~n", [SeasonEndTime]),
    DailyKeyList = [
        {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_REWARD_STATE},
        {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_ENTER_COUNT},
        {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_BUY_COUNT},
        {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_COUNT_REWARD_MARK}
    ],
    case mod_daily:get_count(RoleId, DailyKeyList) of
        [{_, DailyHonorState}, {_, DailyCount}, {_, BuyCount}, {_, CountRewardState}] ->
            HonorIsGot = if DailyHonorState =:= ?STATE_SETUP -> 1; true -> 0 end;
        _ ->
            DailyHonorState = ?STATE_SETUP,
            HonorIsGot = 0, DailyCount = 0, BuyCount = 0, CountRewardState = 0
    end,
    if
        DailyHonorState =:= ?STATE_NONE ->
            NewPS = lib_top_pk:daily_update(PS),
            case do_handle(28101, NewPS, []) of
                {ok, NewPS1} ->
                    {ok, NewPS1};
                _ ->
                    {ok, NewPS}
            end;
        true ->
            DailyRewardGotCounts = lib_top_pk:get_match_reward_count_list(CountRewardState, DailyCount),
            Data = [SeasonId, SeasonEndTime, RankLv, Point, SeasonMatchCount, SeasonWinCount, DailyHonorValue,
                ?IF(Figure#figure.lv >= OpenLv, HonorIsGot, 2), DailyCount, DailyRewardGotCounts, BuyCount, YesterdayRankLv],
%%            ?MYLOG("cym", "Data ~p~n", [Data]),
            {ok, BinData} = pt_281:write(28101, Data),
            lib_server_send:send_to_sid(Sid, BinData)
    end;


% ############# 领取每日荣誉值 ##############
% protocol=28102
% {
%     c2s{
%     }
%     s2c{
%         daily_honor_value:int32
%     }   // 成功返回原协议 失败则返回28100 下同
% }
do_handle(28102, PS, []) ->
    #player_status{top_pk = #top_pk_status{yesterday_rank_lv = YesterdayRankLv}, id = RoleId, sid = Sid} = PS,
    case mod_daily:get_count(RoleId, ?MOD_TOPPK, ?DAILY_ID_REWARD_STATE) of
        ?STATE_SETUP ->
            mod_daily:set_count(RoleId, ?MOD_TOPPK, ?DAILY_ID_REWARD_STATE, ?STATE_GOT),
            RewardList = lib_top_pk:get_daily_reward(YesterdayRankLv),
            Produce = #produce{type = top_pk_daily_honor, reward = RewardList},
            NewPS = lib_goods_api:send_reward(PS, Produce),
%%            ?MYLOG("cym", "daily reward ~p~n", [RewardList]),
            {ok, BinData} = pt_281:write(28102, [RewardList]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, NewPS};
        ?STATE_GOT ->
            send_error(Sid, ?ERRCODE(err281_award_is_got));
        _ ->
            NewPS = lib_top_pk:daily_update(PS),
            case do_handle(28102, NewPS, []) of
                {ok, NewPS1} ->
                    {ok, NewPS1};
                _ ->
                    {ok, NewPS}
            end
    end;

% ############# 领取每日参与次数奖励 ##############
% protocol=28103
% {
%     c2s{
%         count:int8  // 次数
%     }
%     s2c{
%         count:int8  // 次数
%         reward_obj_list:arr_object_list
%     }
% }
do_handle(28103, PS, [Count]) when Count < 32 ->
    DailyKeyList = [
        {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_ENTER_COUNT},
        {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_COUNT_REWARD_MARK}
    ],
    #player_status{id = RoleId, sid = Sid} = PS,
    case data_top_pk:get_daily_count_rewards(Count) of
        [_|_] = RewardList ->
            case mod_daily:get_count(RoleId, DailyKeyList) of
                [{_, EnterCount}, {_, Mark}] ->
                    if
                        EnterCount < Count ->
                            send_error(Sid, ?ERRCODE(err281_daily_enter_count_error));
                        true ->
                            case lib_top_pk:calc_bit_index_value(Count, Mark) of
                                0 ->
                                    NewMark = lib_top_pk:set_bit_index_1(Count, Mark),
                                    mod_daily:set_count(RoleId, ?MOD_TOPPK, ?DAILY_ID_COUNT_REWARD_MARK, NewMark),
                                    lib_log_api:log_top_pk_enter_reward(RoleId, Count, RewardList),
                                    Produce = #produce{type = top_pk_daily_count_reward, subtype = Count, reward = RewardList, remark = integer_to_list(Count)},
                                    {ok, NewPS} = lib_goods_api:send_reward_with_mail(PS, Produce),
                                    {ok, BinData} = pt_281:write(28103, [Count, RewardList]),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    {ok, NewPS};
                                _ ->
                                    send_error(Sid, ?ERRCODE(err281_award_is_got))
                            end
                    end;
                _ ->
                    skip
            end;
        _ ->
            send_error(Sid, ?FAIL)
    end;


% ############# 购买次数 ##############
% protocol=28104
% {
%     c2s{
%         buy_count:int16      // 购买次数 
%     }
%     s2c{
%         daily_buy_count:int16 // 新的每日购买次数
%     }
% }
do_handle(28104, PS, [Count]) when Count > 0->
    #player_status{id = RoleId, sid = Sid} = PS,
    case lib_top_pk:get_activity_enabled() of
        true ->
            case data_top_pk:get_kv(default, buy_cost) of
                Price when Price > 0 ->
                    CurBuyCount = mod_daily:get_count(RoleId, ?MOD_TOPPK, ?DAILY_ID_BUY_COUNT),
                    CountLimit = lib_top_pk:get_match_buy_count_limit(),
                    NewCount = Count + CurBuyCount,
                    if
                        NewCount =< CountLimit ->
                            Cost = [{?TYPE_BGOLD, 0, Price * Count}],
                            case lib_goods_api:cost_object_list_with_check(PS, Cost, top_pk_buy_cost, integer_to_list(Count)) of
                                {true, NewPS} ->
                                    mod_daily:set_count(RoleId, ?MOD_TOPPK, ?DAILY_ID_BUY_COUNT, NewCount),
                                    ?MYLOG("cym", "NewCount ~p~n", [NewCount]),
                                    {ok, BinData} = pt_281:write(28104, [NewCount]),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    {ok, NewPS};
                                {false, Code, _} ->
                                    send_error(Sid, Code)
                            end;
                        true ->
                            send_error(Sid, ?ERRCODE(err281_buy_count_limit))
                    end;
                _ ->
                    send_error(Sid, ?FAIL)
            end;
        _ ->
            send_error(Sid, ?ERRCODE(err157_act_not_open))
    end;


% ############# 段位奖励列表 ##############
% protocol=28105
% {
%     c2s{
%     }
%     s2c{
%         got_list:array{
%             grade:int8  // 段位
%             state:int8  // 状态 0已领取 1未达成 2可领取
%         }
%     }
% }
do_handle(28105, PS, []) ->
    #player_status{top_pk = #top_pk_status{season_reward_status = SeasonRewardStatus, rank_lv = RankLv}, sid = Sid} = PS,
    List = lib_top_pk:get_season_reward_list_by_season_reward_status(SeasonRewardStatus, RankLv),
%%    ?MYLOG("cym", "List ~p~n", [List]),
    {ok, BinData} = pt_281:write(28105, [List]),
    lib_server_send:send_to_sid(Sid, BinData);


% ############# 领取段位奖励 ##############
% protocol=28106
% {
%     c2s{
%         grade:int8 // 小段位
%     }
%     s2c{
%         grade:int8 // 被领取奖励的段位
%         reward_obj_list:arr_object_list // 奖励内容
%     }
% }
do_handle(28106, PS, [RankLv]) ->
    #player_status{top_pk = PKStatus, sid = Sid, id = RoleId} = PS,
    case data_top_pk:get_rank_reward(RankLv) of
        #base_top_pk_rank_reward{stage_reward = [_|_] = RewardList, local_stage_reward = LocalRewardList} ->
            #top_pk_status{season_reward_status = SeasonRewardStatus, rank_lv = MyRankLv} = PKStatus,
            if
                MyRankLv >= RankLv ->
                    case lib_top_pk:calc_bit_index_value(RankLv, SeasonRewardStatus) of
                        0 ->
                            case lib_top_pk:is_local_match() of
                                true ->
                                    RewardListLast = LocalRewardList;
                                _ ->
                                    RewardListLast = RewardList
                            end,
                            %% 日志
                            lib_log_api:log_top_pk_stage_reward(RoleId, RankLv, RewardListLast),
                            NewSeasonRewardStatus = lib_top_pk:set_bit_index_1(RankLv, SeasonRewardStatus),
                            Produce = #produce{type = top_pk_grade_reward, reward = RewardListLast, remark = integer_to_list(RankLv)},
                            {ok, NewPS} = lib_goods_api:send_reward_with_mail(PS, Produce),
                            {ok, BinData} = pt_281:write(28106, [RankLv, RewardListLast]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            lib_top_pk:update_season_reward(RoleId, NewSeasonRewardStatus),
                            {ok, NewPS#player_status{top_pk = PKStatus#top_pk_status{season_reward_status = NewSeasonRewardStatus}}};
                        _ ->
                            send_error(Sid, ?ERRCODE(err281_award_is_got))
                    end;
                true ->
                    send_error(Sid, ?ERRCODE(err281_grade_limit))
            end;
        _ ->
            send_error(Sid, ?FAIL)
    end;

% ############# 活动状态信息 ##############
% protocol=28107
% {
%     c2s{
%     }
%     s2c{
%         state:int8  // 状态 1开启 0关闭
%         start_time:int32
%         end_time:int32
%     }
% }
do_handle(28107, PS, []) ->
    mod_top_pk_match_room:get_act_info(PS#player_status.sid);



% ############# 匹配 ##############
% protocol=28110
% {
%     c2s{
%     }
%     s2c{
%         res:int8  // 成功必然返回
%     }
% }
do_handle(28110, PS, []) ->
    #player_status{
        top_pk = #top_pk_status{grade_num = GradeNum, point = Point, rank_lv = RankLv},
        id = RoleId, sid = Sid,
        platform = Platform, server_num = ServNum, figure = #figure{name = RoleName}
    } = PS,
    OpenDay = util:get_open_day(),
    case lib_top_pk:get_activity_enabled() of  %%
         true ->
             IsInTopPkScene = lib_top_pk:is_in_top_pk_scene(PS),
             if
                 IsInTopPkScene ->
                    lib_server_send:send_to_sid(Sid, pt_281, 28110, [?ERRCODE(err281_on_battle_state)]);
                 true ->
                     case lib_player_check:check_all(PS) of
                         true ->
                             DailyKeyList = [
                                 {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_ENTER_COUNT},
                                 {?MOD_TOPPK, ?DEFAULT_SUB_MODULE, ?DAILY_ID_BUY_COUNT}
                             ],
                             [{_, EnterCount}, {_, BuyCount}] = mod_daily:get_count(RoleId, DailyKeyList),
                             case data_top_pk:get_kv(default, daily_count) of
                                 DefaultEnterCount when EnterCount - BuyCount < DefaultEnterCount ->
                                     MyNode = mod_disperse:get_clusters_node(),
                                     IsAi   = is_ai_match(PS),
                                     case IsAi of
                                         true ->
                                             do_ai_match(PS);
                                         _ -> %%真实匹配
                                             %%是否本服匹配
                                             ?MYLOG("cym", "local match~n", []),
                                             {MinDay, MaxDay} = data_top_pk:get_kv(local_match_day,default),
                                             if
                                                 OpenDay >= MinDay andalso OpenDay =< MaxDay ->%%本服匹配
                                                     mod_top_pk_match_room:enter_match(MyNode, RoleId,
                                                         [GradeNum, Point, Platform, ServNum, RoleName, PS#player_status.combat_power, RankLv]);
                                                 true ->
                                                     mod_clusters_node:apply_cast(mod_top_pk_match_room, enter_match,
                                                         [MyNode, RoleId, [GradeNum, Point, Platform, ServNum, RoleName, PS#player_status.combat_power, RankLv]])
                                             end
                                     end;
                                 _ ->
                                    lib_server_send:send_to_sid(Sid, pt_281, 28110, [?ERRCODE(err281_daily_enter_count_error)])
                             end;
                         {false, Code} ->
                            lib_server_send:send_to_sid(Sid, pt_281, 28110, [Code])
                     end
             end;
        _ ->
            ?MYLOG("cym", "Err ~p~n ", ["err157_act_not_open"]),
            lib_server_send:send_to_sid(Sid, pt_281, 28110, [?ERRCODE(err157_act_not_open)])
    end;

% ############# 取消匹配 ##############
% protocol=28114
% {
%     c2s{
%     }
%     s2c{
%         res:int8  // 成功必然返回
%     }
% }
do_handle(28114, PS, []) ->
    #player_status{top_pk = PKStatus, id = RoleId, sid = Sid} = PS,
    #top_pk_status{pk_state = PkState} = PKStatus,
    case PkState of
        {match, Node} ->
            {MinDay, MaxDay} = data_top_pk:get_kv(local_match_day,default),
            MyNode = mod_disperse:get_clusters_node(),
            OpenDay = util:get_open_day(),
            if
                OpenDay >= MinDay andalso OpenDay =< MaxDay ->%%本服匹配
                    mod_top_pk_match_room:cancel_match(MyNode, RoleId);
                true ->
                    lib_top_pk:apply_cast(Node, mod_top_pk_match_room, cancel_match, [MyNode, RoleId])
            end,
            util:cancel_timer(PKStatus#top_pk_status.ref), %% 取消定时器，如果有的话
            {ok, lib_player:break_action_lock(PS#player_status{top_pk = PKStatus#top_pk_status{pk_state = [], ref = []}}, ?ERRCODE(err281_on_matching_state))};
        _ ->
            send_error(Sid, ?ERRCODE(err281_not_on_match_state))
    end;

% ############# 排行榜数据 ##############
% protocol = 28115
% {
%     c2s{
%     }
%     s2c{
%         type:int8  //类型 1本服 2 跨服 决定排行榜要显示榜排名还是区服
%         rank_list:array{
%             role_id:int64   // 玩家id
%             role_name:string    // 玩家名
%             career:int8     // 职业
%             power:int32     // 战力
%             guild_name:string   // 帮派名
%             platform:string     // 平台
%             server:int16    // 服务器编号
%             grade:int8      // 段位
%             star:int8       // 星
%         } // 下标就是排名
%     }
% }
do_handle(28115, PS, []) ->
%%    #player_status{sid = Sid} = PS,
    Node = mod_disperse:get_clusters_node(),
    case lib_top_pk:is_local_match() of
        true ->
            mod_top_pk_rank:get_ranks(PS#player_status.id);
        _ ->
            mod_clusters_node:apply_cast(mod_top_pk_rank_kf, get_ranks, [Node, PS#player_status.id, PS#player_status.server_id, util:get_open_day()])
    end;

do_handle(28116, #player_status{top_pk = #top_pk_status{pk_state = PkState}, id = RoleId}, []) ->
    case PkState of
        {battle, BattleNode, BattlePid} ->
            MyNode = mod_disperse:get_clusters_node(),
            unode:apply(BattleNode, mod_battle_field, player_quit, [BattlePid, {MyNode, RoleId}, []]);
        _ ->
            ok
    end;


do_handle(_CMD, _PS, _Args) ->
    ?ERR("pp_top_pk no match ~p, ~p~n", [_CMD, _Args]).

send_error(Sid, Code) ->
    ?MYLOG("cym", "Err ~p~n ", [Code]),
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_281:write(28100, [CodeInt, CodeArgs]),
    % ?PRINT("top pk error = ~p~n", [Code]),
    lib_server_send:send_to_sid(Sid, BinData).


%% 满足以下任意条件均不走真实匹配，直接匹配AI战斗
%%1)连输2盘，则第3盘开始匹配AI战斗，直至胜利后，转入真实匹配
%%2)每个赛季初始前5次匹配，必定是AI
is_ai_match(#player_status{top_pk = TopPk}) ->
    #top_pk_status{grade_num = _GradeNum, season_match_count = SMCount, serial_fail_count = SerialFailCount} = TopPk,
    if
        SMCount < 5 ->
            true;
        SerialFailCount >= 2 ->
            true;
        true ->
            false
    end.

do_ai_match(#player_status{id = RoleId} = PS)  ->
%%    ?MYLOG("cym", "ai match ~n", []),
    %%设置锁，和失败事件
    {ok, NewPs} = lib_top_pk:set_player_match_start(PS, node()),
    #player_status{top_pk = TopPk} = NewPs,
    #top_pk_status{ref = OldRef} = TopPk,
    {ok, BinData} = pt_281:write(28110, [?SUCCESS]),
    lib_server_send:send_to_uid(RoleId, BinData),
    DelayTime = lib_top_pk:get_fake_man_delay_time(),
    if
        DelayTime == 0 ->
            lib_top_pk:handle_match_timeout(NewPs);
        true ->
%%            ?MYLOG("cym", "delay ~p ~n", [DelayTime]),
            Ref = util:send_after(OldRef, DelayTime * 1000, self(), {'mod', lib_top_pk, handle_match_timeout, []}),
%%            spawn(fun() ->
%%                timer:sleep(DelayTime * 1000),
%%                ?MYLOG("cym", "delay ~p ~n", [DelayTime]),
%%                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE,
%%                    lib_top_pk, handle_match_timeout, [])
%%            end),
            NewTopPk = TopPk#top_pk_status{ref = Ref},
            {ok, NewPs#player_status{top_pk = NewTopPk}}
    end.