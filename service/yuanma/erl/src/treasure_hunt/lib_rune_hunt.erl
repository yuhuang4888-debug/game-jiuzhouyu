%%%-----------------------------------
%%% @Module      : lib_rune_hunt
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 15. 十月 2018 14:37
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_rune_hunt).
-author("chenyiming").

-include("common.hrl").
-include("treasure_hunt.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("language.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% API
-compile(export_all).


%%初始化
login(#player_status{id = RoleId} = Ps) ->
    RuneHunt = get_rune_hunt_msg_from_db(RoleId),
    Ps#player_status{rune_hunt = RuneHunt}.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取夺宝界面信息
%% @param    参数     Player::#player_status{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_info(Player) ->
    #player_status{rune_hunt = RuneHunt, id = RoleId, sid = Sid} = Player,
    #rune_hunt{turn = Turn, next_turn_flush_time = Flush_time, next_turn = NextTurn,
        free_flush_time = FreeFlushTime, free_times = FreeTimes, get_reward_list = OldBoxList} = RuneHunt,
    Now = utime:unixtime(),
    if
    %% 要更新轮次了,这里也做吧，预防在登录状态到时候超过了这个刷新时间
        Now >= Flush_time andalso NextTurn > Turn ->
            %% 宝箱状态也要重新重置
            BoxList = init_box_list(),
            LastFlushTime = get_flush_time(NextTurn),
            %% 累积次数
            DrawTime = get_draw_time(NextTurn, RoleId),
            %% 有没有下个轮次
            FlagList = data_treasure_hunt:get_flag_by_turn(Turn),
            %% 0不能进来下一轮，还在本轮循环,1可以进入下一轮
            Flag = ?IF(lists:member(1, FlagList), 0, 1),
            NewNextTurn = NextTurn + Flag,
            NewRuneHunt = RuneHunt#rune_hunt{turn = NextTurn, get_reward_list = BoxList,
                next_turn_flush_time = LastFlushTime, next_turn = NewNextTurn};
    %% 不用更新轮次，是同一个轮次，但是要同一个轮次里重置
        Now >= Flush_time andalso NextTurn == Turn ->
            %% 重新重置宝箱状态
            BoxList = init_box_list(),
            LastFlushTime = get_flush_time(Turn),
            %% 累积次数
            DrawTime = get_draw_time(Turn, RoleId),
            %% 有没有下个轮次
            FlagList = data_treasure_hunt:get_flag_by_turn(Turn),
            %% 0不能进来下一轮，还在本轮循环,1可以进入下一轮
            Flag = ?IF(lists:member(1, FlagList), 1, 0),
            NewNextTurn = NextTurn + Flag,
            NewRuneHunt = RuneHunt#rune_hunt{turn = NextTurn, get_reward_list = BoxList,
                next_turn_flush_time = LastFlushTime, next_turn = NewNextTurn};
    %% 不用更新轮次，直接获取信息就行
        true ->
            LastFlushTime = Flush_time,
            BoxList = OldBoxList,
            %% 累积次数
            DrawTime = get_draw_time(Turn, RoleId),
            NewRuneHunt = RuneHunt
    end,
    %%免费次数
    {NewFreeTimes, NewFreeFlushTime} = get_free_time_by_free_time(FreeTimes, FreeFlushTime),
    #rune_hunt{turn = _Turn} = NewRuneHunt,
    LastRunHunt = NewRuneHunt#rune_hunt{free_flush_time = NewFreeFlushTime, free_times = NewFreeTimes},
    {ok, BinOne} = pt_416:write(41601, [DrawTime, _Turn, BoxList, LastFlushTime, NewFreeFlushTime]),
    lib_server_send:send_to_sid(Sid, BinOne),
    save_to_db(LastRunHunt, RoleId),
    Player#player_status{rune_hunt = LastRunHunt}.

%% -----------------------------------------------------------------
%% @desc 稀有物品获取提升概率
%% @param LuckyValue 幸运值
%% @return Pers
%% -----------------------------------------------------------------
get_rune_show_percent(LuckyValue) ->
    List = data_treasure_hunt:get_cfg(rune_hunt_luckey_value_display),
    Fun1 = fun({Min, Max, _Percent}) ->
        LuckyValue >= Min andalso LuckyValue =< Max
           end,
    case ulists:find(Fun1, List) of
        {ok, {_Min, _Max, Pers}} -> Pers;
        _ -> 0
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  获取根据轮次获取当前次数
%% @param    参数      NextTurn::integer() 轮次
%% @return   返回值    DrawTimes  抽奖累积次数
%% @history  修改历史
%% -----------------------------------------------------------------
get_draw_time(Turn, RoleId) ->
    FlushType = data_treasure_hunt:get_flush_type_by_turn(Turn),   %%重置方式
    DrawTimes =
        case FlushType of
            [0] -> %% 终生次数。
                mod_counter:get_count(RoleId, ?MOD_TREASURE_HUNT, Turn);
            [1] -> %% 日次数。
                mod_daily:get_count(RoleId, ?MOD_TREASURE_HUNT, Turn);
            [2] -> %% 周次数。
                mod_week:get_count(RoleId, ?MOD_TREASURE_HUNT, Turn);
            _ ->
                mod_counter:get_count(RoleId, ?MOD_TREASURE_HUNT, Turn)
        end,
    DrawTimes.

%% -----------------------------------------------------------------
%% @desc     功能描述   获取当前抽奖次数
%% @param    参数      #player_status{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_draw_time(#player_status{id = RoleId, rune_hunt = RuneHunt}) ->
    #rune_hunt{turn = Turn} = RuneHunt,
    get_draw_time(Turn, RoleId).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取根据轮次获取当前轮次刷新时间
%% @param    参数      NextTurn::integer() 轮次
%% @return   返回值    FlushTime  时间戳
%% @history  修改历史
%% -----------------------------------------------------------------
get_flush_time(Turn) ->
    FlushType = data_treasure_hunt:get_flush_type_by_turn(Turn),   %%重置方式
    FlushTime =
        case FlushType of
            [0] -> %%
                utime:unixtime() + 86400 * 365 * 10;  %%10年后了
            [1] -> %% 日次数。 %%当日的0点
                T = utime:unixdate() + 86400,
%%				?DEBUG("T :~p~n", [T]),
                T;
            [2] -> %%周一0点
                (7 - utime:day_of_week() + 1) * 86400 + utime:unixdate();
            _ ->
                utime:unixtime() + 86400 * 365 * 10  %%10年后了
        end,
    FlushTime.


%% -----------------------------------------------------------------
%% @desc     功能描述  宝箱初始化
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
init_box_list() ->
    BoxNum = data_treasure_hunt:get_cfg(box_num),
    init_box_list([], BoxNum).
init_box_list(List, 0) ->
    List;
init_box_list(List, Num) ->
    init_box_list([{Num, 0} | List], Num - 1).

get_rune_hunt_msg_from_db(RoleId) ->
    RewardMapList = db:get_all(io_lib:format(?sql_select_treasure_hunt_reward, [])),
    TimesMapList = db:get_all(io_lib:format(?sql_select_treasure_hunt_times, [])),
    StatisticsRewardMap = lib_treasure_hunt_mod:init_statistics_reward_map(RewardMapList, #{}),
    StatisticsTimesMap = lib_treasure_hunt_mod:init_statistics_times_map(TimesMapList, #{}),
    Now = utime:unixtime(),
    Sql = io_lib:format(<<"select  turn, free_times, free_flush_time, next_turn, next_turn_flush_time, get_reward_list, lucky_value  from  rune_hunt_msg  where  role_id = ~p">>, [RoleId]),
    case db:get_row(Sql) of
        %% 初始化
        [] ->
            FlagList = data_treasure_hunt:get_flag_by_turn(1),
            %% 0不能进来下一轮，还在本轮循环,1可以进入下一轮
            Flag = ?IF(lists:member(1, FlagList),1, 0),
            NewNextTurn = 1 + Flag,
            NextTurnFlushTime = get_flush_time(1),
            InitBox = init_box_list(),
            RuneHunt = #rune_hunt{turn = 1, free_times = 1, free_flush_time = Now, get_reward_list = InitBox,
                next_turn = NewNextTurn, next_turn_flush_time = NextTurnFlushTime},
            RuneHunt;
        [Turn, FreeTimes, FreeFlushTime, NextTurn, TurnFlushTime, _BoxList, LuckyValue] ->
            BoxList = util:bitstring_to_term(_BoxList),
            DbRuneHunt =
                if
                %% 现在的时间超过了刷新时间，且下个轮次和本轮次不同
                    Now >= TurnFlushTime andalso NextTurn > Turn ->
                        %% 宝箱状态也要重新重置
                        TempBoxList = init_box_list(),
                        LastFlushTime = get_flush_time(NextTurn),
                        %% 有没有下个轮次
                        FlagList = data_treasure_hunt:get_flag_by_turn(Turn),
                        %% 0不能进来下一轮，还在本轮循环,1可以进入下一轮
                        Flag = ?IF(lists:member(1, FlagList),1, 0),
                        NewNextTurn = NextTurn + Flag,
                        #rune_hunt{turn = NextTurn, get_reward_list = TempBoxList,
                            next_turn_flush_time = LastFlushTime, next_turn = NewNextTurn, luck_value = LuckyValue,
                            statistics_times_map = StatisticsTimesMap, statistics_reward_map = StatisticsRewardMap};
                %% 不用更新轮次，是同一个轮次，但是要同一个轮次里重置
                    Now >= TurnFlushTime andalso NextTurn == Turn ->
                        %% 重新重置宝箱状态
                        TempBoxList = init_box_list(),
                        LastFlushTime = get_flush_time(Turn),
                        %% 有没有下个轮次
                        FlagList = data_treasure_hunt:get_flag_by_turn(Turn),
                        %% 0不能进来下一轮，还在本轮循环,1可以进入下一轮
                        Flag = ?IF(lists:member(1, FlagList),1, 0),
                        NewNextTurn = NextTurn + Flag,
                        #rune_hunt{turn = NextTurn, get_reward_list = TempBoxList, next_turn_flush_time = LastFlushTime,
                            next_turn = NewNextTurn, luck_value = LuckyValue, statistics_times_map = StatisticsTimesMap,
                            statistics_reward_map = StatisticsRewardMap};
                %% 不用更新轮次，直接获取信息就行
                    true ->
                        #rune_hunt{turn = Turn, get_reward_list = BoxList, next_turn = NextTurn,
                            next_turn_flush_time = TurnFlushTime, luck_value = LuckyValue,
                            statistics_times_map = StatisticsTimesMap, statistics_reward_map = StatisticsRewardMap}
                end,
            %% 处理免费次数
            {NewFreeTimes, NewFreeFlushTime} = get_free_time_by_free_time(FreeTimes, FreeFlushTime),
            LastRuneHunt = DbRuneHunt#rune_hunt{free_times = NewFreeTimes, free_flush_time = NewFreeFlushTime},
            LastRuneHunt
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  保存到数据库
%% @param    参数      RuneHunt::#rune_hunt{},
%%                     RoleId::integer()
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
save_to_db(RuneHunt, RoleId) ->
    #rune_hunt{turn = Turn, free_times = FreeTime, free_flush_time = FreeFlushTime, luck_value = LuckValue,
        next_turn = NextTurn, next_turn_flush_time = NextTurnFlushTime, get_reward_list = BoxList} = RuneHunt,
    DbBoxList = util:term_to_string(BoxList),
    Sql = io_lib:format(?SQL_UPDATE_RUNE_HUNT_MSG_LUCKEY_VALUE,
        [RoleId, Turn, FreeTime, FreeFlushTime, NextTurn, NextTurnFlushTime, DbBoxList, LuckValue]),
    db:execute(Sql).

%% -----------------------------------------------------------------
%% @desc     功能描述  寻宝
%% @param    参数      HType::integer  寻宝类型
%% @param    参数      Times::integer()  寻宝次数
%% @param    参数      AutoBuy 是否自动购买
%% @param    参数      Player::#player_status{}
%% @return   返回值    Ps
%% @history  修改历史
%% -----------------------------------------------------------------
hunt(HType, Times, AutoBuy, Player) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, rune_hunt = RuneHunt, dun_rune_level_unlock = _DunLv} = Player,
    VaildTimes = ?IF(Times == 1 orelse Times == 10, true, false),
    #rune_hunt{free_times = _FreeTimes, free_flush_time = FreeFlushTime} = RuneHunt,
    Now = utime:unixtime(),
    FreeTimes = ?IF(FreeFlushTime =< Now, 1, _FreeTimes),
    OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
    {CostGTypeId, CostNum} = get_ten_rune_draw_costs(Player, HType, Times),
    if
    %% 错误次数
        VaildTimes == false -> ok;
    %% 等级不行
        Figure#figure.lv < OpenLv -> ok;
    %% 物品不存在
        CostGTypeId == 0 ->
            {ok, BinData} = pt_416:write(41604, [?ERRCODE(err_config), HType, Times, 0, []]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            NowTime = utime:unixtime(),
            %% {消耗列表，免费次数刷新时间， 免费次数}
            {CostList, NewFreeFlushTime, NewFreeTime} =
                if
                %% 消耗免费次数
                    FreeTimes >= 1 andalso Times =:= 1 ->
                        FreeCdTime = data_treasure_hunt:get_cfg(rune_treasure_hunt_free_time),
                        CdDebuffRatio = lib_module_buff:get_treasure_hunt_cd_buff(Player),
                        NewFreeCdTime = round(FreeCdTime * (1 - CdDebuffRatio)),
                        %% 下一次的免费次数更新时间
                        NextFreeTime1 = NowTime + NewFreeCdTime,
                        {[], NextFreeTime1, 0};
                    true ->
                        {[{?TYPE_GOODS, CostGTypeId, CostNum}], FreeFlushTime, FreeTimes}
                end,
            ConsumeType = lib_treasure_hunt_data:get_consume_type(HType),
            %%消耗
            Res = if
                      CostList =:= [] -> {true, Player, []};
                      AutoBuy == 1 -> lib_goods_api:cost_objects_with_auto_buy(Player, CostList, ConsumeType, HType);
                      true ->
                          case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, HType) of
                              {true, TmpNewPlayer} -> {true, TmpNewPlayer, CostList};
                              Other -> Other
                          end
                  end,
            %%检查结果
            case Res of
                {true, _NewPlayer, RealCostList} ->
                    %% 寻宝次数
                    OldTimes = lib_rune_hunt:get_draw_time(Player),
                    %% 副本层数
                    DunLv = lib_dungeon_rune:get_dungeon_level(Player),
                    case data_treasure_hunt:get_all_rune_points() of
                        [Cycle|_] ->
                            Rem = Times rem Cycle,
                            if
                                Rem == 0 ->
                                    %% 防止每周首次十抽时候，刚好随机出的次数在1-2次而导致没有保底
                                    FloorsTimes = ?IF(OldTimes > 2, urand:rand(1, Cycle), urand:rand(3, Cycle));
                                true ->
                                    FloorsTimes = 0
                            end;
                        _ ->
                            FloorsTimes = 0
                    end,
                    case lib_treasure_hunt_data:count_rune_reward_list(RoleId, RuneHunt, DunLv, OldTimes + 1, OldTimes + Times, [], OldTimes + FloorsTimes) of
                        {[], _TempRuneHunt} ->
                            {ok, BinData} = pt_416:write(41604, [?FAIL, HType, Times, 0, []]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        {ResultRewardCfgList, TempRuneHunt} ->
                            %% 寻宝奖励
                            RealGiveList = [{?TYPE_GOODS, GTId, ResNum} || #treasure_hunt_reward_cfg{goods_id = GTId, goods_num = ResNum}
                                <- ResultRewardCfgList],
                            GoodsIdWithTvList = [{GTId1, IsTv, IsRare} || #treasure_hunt_reward_cfg{goods_id = GTId1, is_tv = IsTv, is_rare = IsRare} <- ResultRewardCfgList],
                            %% 抽奖次数
                            NewTimes = Times,
                            handle_act(_NewPlayer, RealCostList),
                            NewRuneHunt = handle_draw_time(RoleId, TempRuneHunt, Times, OldTimes, NewFreeTime, NewFreeFlushTime),
                            ProduceType = lib_treasure_hunt_data:get_produce_type(HType),
                            %% 发送抽奖奖励
                            #player_status{figure = #figure{lv = RoleLv, sex = Sex, career = Career, picture = Pic, picture_ver = PicVer}} = Player,
                            %% 获取玩家名(其他功能可能对玩家名临时修改)
                            RoleName = lib_player:get_wrap_role_name(Player),
                            {ok, NewPlayer} = lib_goods_api:send_reward_with_mail(_NewPlayer, #produce{type = ProduceType, reward = RealGiveList}),
                            send_tv(GoodsIdWithTvList, HType, RoleName, RoleId, Figure),
                            %% 事件触发
                            CallbackData = #callback_join_act{type = ?MOD_TREASURE_HUNT, subtype = HType, times = Times},
                            {ok, NewPlayer0} = lib_player_event:dispatch(NewPlayer, ?EVENT_JOIN_ACT, CallbackData),
                            lib_hi_point_api:hi_point_treasure_hunt(RoleId,Figure#figure.lv, HType, Times),
                            lib_achievement_api:async_event(RoleId, lib_achievement_api, treasure_hunt_event, {HType, Times}),
                            %% 发额外固定奖励(符文碎片)
                            case lib_treasure_hunt_data:count_ex_rune_hunt_goods(RoleLv, Times) of
                                [] ->
                                    ExGoods = [],
                                    NewPlayer1 = NewPlayer0;
                                %% 里面有符文碎片
                                ExGoods ->
                                    Produce = #produce{type = ProduceType, reward = ExGoods},
                                    {ok, NewPlayer1} = lib_goods_api:send_reward_with_mail(NewPlayer0, Produce)
                            end,
                            RewardShowList = [{?TYPE_GOODS, GTId2, GoodsNum2, IsRare, IsTv} || #treasure_hunt_reward_cfg{goods_id = GTId2, goods_num = GoodsNum2, is_rare = IsRare, is_tv = IsTv}
                                <- ResultRewardCfgList],
                            F = fun({_Type, _, _Num} = _Good, AccNum) ->
                                case _Type of
                                    ?TYPE_RUNE_CHIP -> AccNum + _Num;
                                    _ -> AccNum
                                end
                            end,
                            ChipNum = lists:foldl(F, 0, ExGoods),
                            {ok, BinDataR} = pt_416:write(41604, [?SUCCESS, HType, NewTimes, ChipNum, RewardShowList]),
                            lib_server_send:send_to_sid(Sid, BinDataR),
                            %% 日志
                            LogReward = [{?TYPE_GOODS, GTypeId, GoodsNum} || {_, GTypeId, GoodsNum, _, _} <- RewardShowList],
                            LogType = ?IF(Times == 1, 1, 2),
                            lib_guild_daily:treasure_hunt(HType, RoleId),
                            lib_custom_act_task:trigger(treasure_hunt, RoleId, Figure#figure.lv, HType, Times),
                            %% 更新幸运值
                            #rune_hunt{luck_value = NewLuckyValue} = NewRuneHunt,
                            lib_log_api:log_treasure_hunt(RoleId, HType, LogType, AutoBuy, RealCostList, ulists:object_list_merge(LogReward), RuneHunt#rune_hunt.luck_value, NewLuckyValue),
                            save_to_db(NewRuneHunt, RoleId),
                            %% 提醒更新幸运值
                            {ok, BinTwo} = pt_416:write(41610, [?TREASURE_HUNT_TYPE_RUNE, NewLuckyValue, lib_rune_hunt:get_rune_show_percent(NewLuckyValue)]),
                            lib_server_send:send_to_sid(Sid, BinTwo),
                            mod_treasure_hunt:add_treasure_hunt_record(RoleId, RoleName, RoleLv, [Sex, Career, Pic, PicVer], [{HType, GTId, IsTv} || {GTId, IsTv, _} <- GoodsIdWithTvList]),
                            {ok, NewPlayer1#player_status{rune_hunt = NewRuneHunt}}
                    end;
                {false, ErrorCode, _} ->
                    {ok, BinData} = pt_416:write(41600, [ErrorCode]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述     处理RuneRunt记录
%% @param    参数         RoleId::integer() 玩家id,
%%                       RuneHunt::rune_hunt{},
%%                       Times::integer() 寻宝次数，
%%                       OldDrawTimes::integer() 旧寻宝次数
%%                       NewFreeTime::integer()  免费次数
%%                       NewFreeFlushTime::integer()  免费次数刷新时间
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_draw_time(RoleId, RuneHunt, Times, OldDrawTimes, NewFreeTime, NewFreeFlushTime) ->
    #rune_hunt{turn = Turn, get_reward_list = Box} = RuneHunt,
    set_draw_times(Turn, Times, RoleId),
    %%改变宝箱状态
    NewBoxList = get_box_list(Box, Turn, OldDrawTimes + Times),
    NewRuneHunt = RuneHunt#rune_hunt{free_times = NewFreeTime, free_flush_time = NewFreeFlushTime, get_reward_list = NewBoxList},
    %%同步数据库
%%	?DEBUG("Rune_hunt ~p~n", [NewRuneHunt]),
    save_to_db(NewRuneHunt, RoleId),
    NewRuneHunt.


%%发送传闻
send_tv([{GTypeId, 1, IsRare} | T], HType, RoleName, RoleId, Figure) ->
    TreasureHuntName = lib_treasure_hunt_data:get_name_by_htype(HType),
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
        _ -> GoodsName = "", Color = 0
    end,
    SendHType = ?IF(IsRare > 0, 9, HType),
    lib_chat:send_TV({all}, RoleId, Figure, ?MOD_TREASURE_HUNT, SendHType, [RoleName, TreasureHuntName, Color, GoodsName]),
    send_tv(T, HType, RoleName, RoleId, Figure);

send_tv([_ | T], HType, RoleName, RoleId, Figure) ->
    send_tv(T, HType, RoleName, RoleId, Figure);

send_tv([], _, _, _, _) -> ok.


%% -----------------------------------------------------------------
%% @desc     功能描述   设置抽奖次数
%% @param    参数      Turn::integer() 轮次    Times::寻宝次数
%% @return   返回值     无
%% @history  修改历史
%% -----------------------------------------------------------------
set_draw_times(Turn, Times, RoleId) ->
    FlushType = data_treasure_hunt:get_flush_type_by_turn(Turn),   %%重置方式
    FlushTime =
        case FlushType of
            [0] -> %%
                mod_counter:plus_count(RoleId, ?MOD_TREASURE_HUNT, Turn, Times);
            [1] -> %% 日次数。 %%当日的0点
                mod_daily:plus_count(RoleId, ?MOD_TREASURE_HUNT, Turn, Times);
            [2] -> %%周一0点
                mod_week:plus_count(RoleId, ?MOD_TREASURE_HUNT, Turn, Times);
            _ ->
                mod_counter:plus_count(RoleId, ?MOD_TREASURE_HUNT, Turn, Times)
        end,
    FlushTime.


%%获取新的宝箱状态
get_box_list(Boxlist, Turn, Time) ->
    MaxId = get_box_max_id(Turn, Time),
    F = fun(Box, AccList) ->
        {Id, Status} = Box,
        NewBox = case Status of  %%本来状态
                     0 ->    %%
                         if
                             MaxId >= Id ->  %%如果达到了次数
                                 {Id, 1}; %%可以领取
                             true ->
                                 {Id, Status} %%可以领取
                         end;
                     1 -> %%可以领取
                         Box;
                     2 -> %%已经领取了
                         Box
                 end,
        [NewBox | AccList]
        end,
    NewBoxList = lists:reverse(lists:foldl(F, [], Boxlist)),
    NewBoxList.


%% -----------------------------------------------------------------
%% @desc     功能描述     获取阶段奖励    检查 -》 发送奖励—》 改变rune_hunt 的记录，主要是修改下一轮的轮数， 当然也要看看是否是最大轮数
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_box_reward(#player_status{rune_hunt = RuneHunt, sid = Sid, id = RoleId} = Player, BoxId) ->
%%	?DEBUG("boxId ~p~n", [BoxId]),
    #rune_hunt{get_reward_list = BoxList, turn = OldTurn, next_turn = OldNextTurn, free_times = _NewFreeTimes, next_turn_flush_time = _StageFlushTime} = RuneHunt,
    case lists:keyfind(BoxId, 1, BoxList) of
        false ->
            {ok, BinData} = pt_416:write(41600, [?FAIL]),
            lib_server_send:send_to_sid(Sid, BinData);
        {_, BoxStatus} ->
            %%flag  %%0是不变 ， 1 是领取了阶段奖励， 直接改变next_turn
            {NewBox, Flag} =
                case BoxStatus of
                    0 ->  %%不可领取
                        {ok, BinData} = pt_416:write(41600, [?ERRCODE(err416_box_id_err)]),
                        lib_server_send:send_to_sid(Sid, BinData),
                        {{BoxId, 0}, 0};
                    1 ->  %%可领取
                        DrawTime = get_draw_time(OldTurn, RoleId),   %%寻宝累积次数
%%						?DEBUG("OldTurn:~p  boxId ~p DrawTime:~p~n", [OldTurn, BoxId, DrawTime]),
                        {_RewardList, RewardFlag} =  %%{奖励列表， 是否为指定奖励}  0：非指定奖励  1：指定奖励
                        case data_treasure_hunt:get_stage_reward(OldTurn, BoxId, DrawTime) of
                            [_R, _F] ->
                                %%发送奖励   rune_treasure_hunt
%%									?DEBUG("reward ~p~n ", [_R]),
                                lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = _R, type = rune_treasure_hunt}),
                                {ok, BinData} = pt_416:write(41607, [_R]),
                                lib_server_send:send_to_sid(Sid, BinData),
                                {_R, _F};
                            _ ->
                                {ok, BinData} = pt_416:write(41600, [?MISSING_CONFIG]),
                                lib_server_send:send_to_sid(Sid, BinData),
                                {[], 0}
                        end,
                        {{BoxId, 2}, RewardFlag};
                    2 -> %%已经领取
                        {ok, BinData} = pt_416:write(41600, [?ERRCODE(err416_box_already_have)]),
                        lib_server_send:send_to_sid(Sid, BinData),
                        {{BoxId, 2}, 0};
                    _ ->
                        {ok, BinData} = pt_416:write(41600, [?FAIL]),
                        lib_server_send:send_to_sid(Sid, BinData),
                        {{BoxId, BoxStatus}, 0}
                end,
%%			?DEBUG("NewBox:~p ~n", [NewBox]),
            NewBoxList = lists:keystore(BoxId, 1, BoxList, NewBox),
            %%判断下一轮情况
            case Flag of
                0 ->   %%不变
                    NewNextTurn = OldNextTurn;
                1 ->   %%领取了指定奖励  可以进入下一轮， 看看有没有下一轮
                    case have_next_turn(OldTurn) of
                        true ->
                            NewNextTurn = OldTurn + 1;
                        false ->
                            NewNextTurn = OldTurn
                    end
            end,
            NewRuneHunt = RuneHunt#rune_hunt{get_reward_list = NewBoxList, next_turn = NewNextTurn},
%%			?DEBUG("NewRuneH  unt:~p ~n", [NewRuneHunt]),
            save_to_db(NewRuneHunt, RoleId),  %%同步数据库
            {ok, Player#player_status{rune_hunt = NewRuneHunt}}
    end.


%%是否存在下一个轮
have_next_turn(OldTurn) ->
    case data_treasure_hunt:get_box_id_by_turn_and_time(OldTurn + 1, 99999999) of
        0 -> %%不存在下一轮；
            false;
        _ ->
            true
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  获得累积次数达到的最大boxid
%% @param    参数     Turn:轮次   Times:寻宝累积次数
%% @return   返回值   BoxMaxId
%% @history  修改历史
%% -----------------------------------------------------------------
get_box_max_id(Turn, Times) ->
    CfgList = data_treasure_hunt:get_draw_times_by_turn(Turn),  %%[{boxId, 状态}].if
    get_box_max_id_helper(lists:reverse(CfgList), Times).


get_box_max_id_helper([], _Times) ->
    0;

get_box_max_id_helper([{BoxId, MinDrawTimes} | T], Times) ->
    case Times >= MinDrawTimes of
        true ->
            BoxId;
        false ->
            get_box_max_id_helper(T, Times)
    end.

get_right_second_list(List) ->
    Filter = data_treasure_hunt:get_cfg(rune_treasure_hunt_second_filter),
    get_right_second_list(List, Filter).
get_right_second_list(List, []) ->
    List;
get_right_second_list(List, [FilterGoodId | Filter]) ->
    List1 = [{Id, MinLv, MaxLv} ||{Id, MinLv, MaxLv} <-List, Id =/= FilterGoodId],
    get_right_second_list(List1, Filter).


get_free_time_by_free_time(FreeTimes, FreeFlushTime) ->
    case FreeTimes of
        0 ->  %%没有免费次数
            _CfgFlushTime = data_treasure_hunt:get_cfg(rune_treasure_hunt_free_time),  %%刷新时间
            case FreeFlushTime =< utime:unixtime() of
                true -> %%可以刷新免费次数
%%					?DEBUG("reflush freetimes  ~n", []),
                    NewFreeTimes = 1,
                    NewFreeFlushTime = FreeFlushTime;
                false ->
%%					?DEBUG("flushfreetimes not  arrive ~n", []),
                    NewFreeTimes = FreeTimes,
                    NewFreeFlushTime = FreeFlushTime
            end;
        _ ->  %%有免费次数就不管是否达到刷新时间都不管他
%%			?DEBUG("have freetimes ~n ", []),
            NewFreeTimes = FreeTimes,
            NewFreeFlushTime = FreeFlushTime
    end,
    {NewFreeTimes, NewFreeFlushTime}.




handle_act(Player, RealCostList) ->
%%	?MYLOG("rune", "RealCostList ~p~n", [RealCostList]),
    #player_status{id = RoleId} = Player,
    F = fun({Type, _, Num}, AccNum) ->
        if
            Type == ?TYPE_GOLD ->
                AccNum + Num;
            true ->
                AccNum
        end
        end,
    AllNum = lists:foldl(F, 0, RealCostList),
    if
        AllNum > 0 ->
            lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_TREASURE_HUNT, 0, AllNum);
        true ->
            skip
    end.

gm_init_stage_reward(RoleId) ->
    DrawTimes = mod_week:get_count_offline(RoleId, ?MOD_TREASURE_HUNT, 1),
    Sql = io_lib:format(<<"UPDATE    rune_hunt_msg  set  get_reward_list = '~s' where  role_id = ~p">>,
        [util:term_to_string(get_box_list(init_box_list(), 1, DrawTimes)), RoleId]),
    db:execute(Sql),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_rune_hunt, gm_init_stage_reward2, []).

gm_init_stage_reward2(PS) ->
    #player_status{rune_hunt = RunHunt, id = RoleId} = PS,
    DrawTimes = mod_week:get_count_offline(RoleId, ?MOD_TREASURE_HUNT, 1),
    NewRunHunt = RunHunt#rune_hunt{get_reward_list = get_box_list(init_box_list(), 1, DrawTimes)},
    {ok, PS#player_status{rune_hunt = NewRunHunt}}.

%% 重置符文寻宝
gm_reset_rune_hunt(PS) -> PS#player_status{rune_hunt = #rune_hunt{}}.


%% 符文十连抽的消耗选择
get_ten_rune_draw_costs(Player, HType, Times) when Times == 10 ->
    TenGoodsId = data_treasure_hunt:get_cfg(rune_hunt_ten_draw_item_id),
    case TenGoodsId of
        0 ->
            do_get_ten_rune_draw_costs(HType, Times);
        _ ->
            case lib_goods_api:get_goods_num(Player, [TenGoodsId]) of
                [{TenGoodsId, HasNum}|_] when HasNum > 0 ->
                    {TenGoodsId, 1};
                _ ->
                    do_get_ten_rune_draw_costs(HType, Times)
            end
    end;
get_ten_rune_draw_costs(_Player, HType, Times) ->
    do_get_ten_rune_draw_costs(HType, Times).

do_get_ten_rune_draw_costs(HType, Times) ->
    % 消耗物品类型
    CostGTypeId = lib_treasure_hunt_data:get_cost_gtype_id(HType),
    %% 消耗物品数量
    CostNum = lib_treasure_hunt_data:get_cost_num(HType, Times),
    {CostGTypeId, CostNum}.