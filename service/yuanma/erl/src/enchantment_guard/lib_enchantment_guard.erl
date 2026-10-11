%%%-----------------------------------
%%% @Module      : lib_enchantment_guard
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 13. 八月 2018 19:19
%%% @Description : 结界守护库文件
%%%-----------------------------------
-module(lib_enchantment_guard).
-include("server.hrl").
-include("errcode.hrl").
-include("onhook.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("vip.hrl").
-include("dungeon.hrl").
-include("enchantment_guard.hrl").
-include("drop.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("rec_assist.hrl").
-include("faker.hrl").
-author("chenyiming").

%% API
-compile(export_all).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取进入结界守护所需波数信息，和当前波数
%% @param    参数      Ps::#player_status
%% @return   返回值    {false,errorcode,Ps}|{true,当前波数,所需波数,Ps}
%% @history  修改历史
%% -----------------------------------------------------------------
get_enter_data(#player_status{enchantment_guard = Guard} = Ps) ->
    #enchantment_guard{gate = Gate, wave = KillNum} = Guard,
    case data_enchantment_guard:get_wave_by_id(Gate + 1) of
        [] ->            %%已经达到最大关数
            {false, ?ERRCODE(err133_max_gate), Ps};
        [NeedKillNum] ->
            #status_assist{assist_id = AssistId, assister_info = AssisterInfo} = get_assist_info(Ps, Gate + 1),
            {true, KillNum, NeedKillNum, AssistId, AssisterInfo, Ps}
    end.

get_assist_info(PS, Gate) ->
    #player_status{lunch_assist = StatusAssistMap, id = RoleId} = PS,
    AssistL = [Assist||#status_assist{ask_id = AskId, type = Type, target_cfg_id = TargetCfgId, assist_process = 1} = Assist
        <-maps:values(StatusAssistMap), Type == ?ASSIST_TYPE_4, AskId == RoleId, TargetCfgId == Gate],
    case AssistL of
        [#status_assist{} = StatusAssist|_] -> StatusAssist;
        _ -> #status_assist{}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取排行榜信息
%% @param    参数      Ps::#player_status ，Type::integer  玩家数量
%% @return   返回值    {false,errorcode,Ps}|{true,个人排名,当前关数,排行版列表{rank,name,gate},Ps}
%% @history  修改历史
%% -----------------------------------------------------------------
get_rank_data(#player_status{id = Id, enchantment_guard = Guard} = Ps, Type) ->
    if
        Type =:= 0 orelse Type =:= 1 ->
            case Type of
                0 ->
                    Num = 3;
                1 ->
                    Num = 20
            end,
            #enchantment_guard{gate = Gate} = Guard,
            case mod_enchantment_guard:get_rank_list(Id, Num) of
                {true, RoleRank, RankList} ->
                    {true, RoleRank, Gate, RankList, Ps};
                {false, Res} ->
                    {false, Res, Ps}
            end;
        true ->
            {false, ?ERRCODE(err133_err_rank_type), Ps}
    end.

%% 获取排行榜信息
send_rank_list(PS) ->
    #player_status{id = Id, enchantment_guard = Guard} = PS,
    #enchantment_guard{gate = Gate} = Guard,
    mod_enchantment_guard_rank_local:send_rank_list(Id, Gate),
    ok.


%% -----------------------------------------------------------------
%% @desc     功能描述 获取封印之力封面信息
%% @param    参数
%% @return   返回值   {false,errorcode,Ps}|{true, MaxTimes, CurrentTimes, Cost, RewardList, NewPs}
%%                                             %%最大领取次数，当前领取次数，精魄消耗，奖励列表
%% @history  修改历史
%% -----------------------------------------------------------------
get_seal_data(#player_status{id = Id, enchantment_guard = Guard, figure = Figure} = Ps) ->
    #enchantment_guard{gate = Gate} = Guard,
    %%获取当前封印次数
    CurrentTimes = mod_daily:get_count(Id, ?ENCHANTMENT_GUAND, ?SEAL_COUNT_ID),
    %%最大领取次数。
    case data_enchantment_guard:get_seal_times(Gate) of
        [] ->  %%未通关一个关卡
            {false, ?ERRCODE(err133_err_gate), Ps};
        MaxTimes ->
            #figure{lv = L} = Figure,
%%          ?DEBUG("CurrentTimes:~p,L:~p~n", [CurrentTimes, L]),
            case data_enchantment_guard:get_seal_reward(L, CurrentTimes + 1) of
                [] ->
                    Cost = 0,
                    RewardList = [];
                [[{_, _, Cost}], RewardList] ->
                    ok
            end,
            if
                Cost == 0 andalso RewardList == [] ->     %%配置问题
                    {false, ?ERRCODE(err133_err_config), Ps};
                true ->
%%                  ?DEBUG("~p~n", [{MaxTimes, CurrentTimes, Cost, RewardList}]),
                    {true, MaxTimes, CurrentTimes, Cost, RewardList, Ps}
            end
    end.

%%%% -----------------------------------------------------------------
%%%% @desc     功能描述 获取扫荡界面信息  废除
%%%% @param    参数     Ps::#player_status{}
%%%% @return   返回值   {false,errorcode,Ps}|{true, MaxTimes, CurrentTimes, Cost, Coin, Exp, EquipNum, RewardNum, NextVip, NextVipTimes, NewPs}
%%%%                                              %%最大扫荡次数，当前扫荡次数，钻石消耗，所得金币，所得经验，所得装备数量，道具奖励数量，下一个vip等级，下一个vip等级可扫荡次数
%%%% @history  修改历史
%%%% -----------------------------------------------------------------
%%get_sweep_data(#player_status{id = Id, enchantment_guard = Guard, figure = Figure} = Ps) ->
%%  #enchantment_guard{gate = Gate, sweep = _Sweep} = Guard,
%%  case lib_enchantment_guard_check:check_get_sweep(Gate) of
%%      true ->
%%          #figure{vip = Vip} = Figure,
%%          MaxTimes =
%%              case data_vip:get_privilege_cfg(Vip, ?ENCHANTMENT_GUAND, ?SWEEP_VIP_ID) of
%%                  [] ->
%%                      0;
%%                  #vip_privilege{value = V} ->
%%                      V
%%              end,
%%          %%下一个vip等级的最大扫荡次数，如果没有，则是最大vip
%%          {NextVip, NextVipTimes} =
%%              case data_vip:get_privilege_cfg(Vip + 1, ?ENCHANTMENT_GUAND, ?SWEEP_VIP_ID) of
%%                  [] ->
%%                      {Vip, MaxTimes};
%%                  #vip_privilege{value = V2} ->
%%                      {Vip + 1, V2}
%%              end,
%%          %%获取当前扫荡次数
%%          CurrentTimes = mod_daily:get_count(Id, ?ENCHANTMENT_GUAND, ?SWEEP_COUNT_ID),
%%          [Cost] = data_enchantment_guard:get_sweep_cost(CurrentTimes + 1),
%%          %%获取扫荡信息
%%          {Coin, Exp, EquipNum, RewardNum, RewardList} = get_sweep_onhook_data(Ps),
%%          %%修改ps中的扫荡信息
%%          NewSweep = #sweep{reward_list = RewardList, cost = Cost, coin = Coin, exp = Exp, equip_num = EquipNum,
%%              reward_num = RewardNum, gate = Gate},
%%          NewGuard = Guard#enchantment_guard{sweep = NewSweep},
%%          NewPs = Ps#player_status{enchantment_guard = NewGuard},
%%          ?DEBUG("vip:~p,", [Vip]),
%%          {true, MaxTimes, CurrentTimes, Cost, Coin, Exp, EquipNum, RewardNum, NextVip, NextVipTimes, NewPs};
%%      {false, errorcode} ->
%%          {false, errorcode, Ps}
%%  end.


%% -----------------------------------------------------------------
%% @desc     功能描述 获取扫荡界面信息
%% @param    参数     Ps::#player_status{}
%% @return   返回值   {false,errorcode,Ps}|{true, MaxTimes, CurrentTimes, Cost, Coin, Exp, EquipNum, RewardNum, NextVip, NextVipTimes, NewPs}
%%                                              %%最大扫荡次数，当前扫荡次数，钻石消耗，所得金币，所得经验，所得装备数量，道具奖励数量，下一个vip等级，下一个vip等级可扫荡次数
%% @history  修改历史
%% -----------------------------------------------------------------
get_sweep_data(#player_status{id = Id, enchantment_guard = Guard, vip = Vip} = Ps) ->
    #enchantment_guard{gate = Gate, sweep = _Sweep} = Guard,
    case lib_enchantment_guard_check:check_get_sweep(Gate) of
        true ->
            #role_vip{vip_type = VipType, vip_lv = VipLv} = Vip,
            MaxTimes = lib_vip_api:get_vip_privilege(?ENCHANTMENT_GUAND, ?SWEEP_VIP_ID, VipType, VipLv),
            %%获取当前扫荡次数
            CurrentTimes = mod_daily:get_count(Id, ?ENCHANTMENT_GUAND, ?SWEEP_COUNT_ID),
            [Cost] = data_enchantment_guard:get_sweep_cost(CurrentTimes + 1),
            %%获取扫荡信息
%%          {Coin, Exp, EquipNum, RewardNum, RewardList} = get_sweep_onhook_data(Ps),
            case lib_onhook:calc_gold_drop_items(Ps, ?ENCHANTMENT_GUAND_SWEEP_HOURS) of   %%扫荡8个小时
                false ->
                    {false, ?FAIL, Ps};
                [[{?TYPE_EXP, 0, Exp}, {?TYPE_COIN, 0, Coin}], StaticDropList, EquipDropList] ->
                    %%修改ps中的扫荡信息
                    %%计算数量
                    F = fun(H, TempNum) ->
                        {_, _, TempN} = H,
                        TempNum + TempN
                    end,
                    %%0是返回的格式， F一个参数是个List的元素，一个是叠加的值。最后返回的是叠加的值
                    RewardNum = lists:foldl(F, 0, StaticDropList),
                    EquipNum = lists:foldl(F, 0, EquipDropList),
                    NewSweep = #sweep{reward_list = StaticDropList ++ EquipDropList, cost = Cost,
                        coin = Coin, exp = Exp, equip_num = EquipNum,
                        reward_num = RewardNum, gate = Gate},
                    NewGuard = Guard#enchantment_guard{sweep = NewSweep},
                    NewPs = Ps#player_status{enchantment_guard = NewGuard},
                    {true, MaxTimes, CurrentTimes, Cost, Coin, Exp, EquipNum, RewardNum, NewPs};
                _ ->
                    {false, ?FAIL, Ps}
            end;
        {false, Res} ->
            {false, Res, Ps}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述 根据玩家数量获取排行榜 3个或者20个
%% @param    参数     Type::3|20,  Randlist::[#rank{}]
%% @return   返回值    []|[{rank,name,gate}]  ，  rank:排名  ，name::玩家名字 ，gate:关卡
%% @history  修改历史
%% -----------------------------------------------------------------
get_rank_list_by_type(_Type, []) ->
    [];
get_rank_list_by_type(Type, Randlist) ->
    get_ranklist(Type, Randlist, []).


get_ranklist(_Type, [], ResList) ->
    lists:reverse(ResList);

get_ranklist(0, _RankList, ResList) ->
    lists:reverse(ResList);

get_ranklist(Type, [H | Ranklist], ResList) ->
    #rank{rank = Rank, name = Name, gate = Gate} = H,
    get_ranklist(Type - 1, Ranklist, [{Rank, Name, Gate} | ResList]).

%% -----------------------------------------------------------------
%% @desc     功能描述  获取扫荡信息，从ps中获取，如果ps没有则重新生成。
%% @param    参数
%% @return   返回值   {Coin, Exp, EquipNum, RewardNum,[{Type, GoodId, RewardNum}]}
%%                    金币，经验，装备数量，固定道具数量,奖励列表
%% @history  修改历史
%% -----------------------------------------------------------------
get_sweep_onhook_data(#player_status{enchantment_guard = Guard} = _Ps) ->
    #enchantment_guard{sweep = Sweep, gate = Gate} = Guard,
    if
        Sweep == {} orelse Sweep#sweep.gate =/= Gate ->  %%扫荡之后打开 ，或者扫荡关卡和实际不一样了
            case data_onhook_main:get_onhook_drop(Gate) of
                false ->  %%关卡有错。
                    {0, 0, 0, 0, []};
                #onhook_drop{coin = Coin, exp = Exp, sdrop_num = SdropNum,
                    static_award = StaticReward, edrop_num = EdropNum, equip_award_rule = Rule, equip_award = EquipList} ->
                    [{Type, GoodId, TempNum}] = StaticReward,
                    RewardNum = TempNum * SdropNum * 48,  %%固定道具掉落数量
                    TempEdropNum = EdropNum * 48,
                    %%抽奖。  抽装备颜色 数量
                    Reslist = find_ratio_list(Rule, 3, TempEdropNum),
                    %%统计白色，绿色，蓝色数量
                    {White, Green, Blue} = get_color_num(Reslist, {0, 0, 0}),
                    EquipNum = White + Green + Blue,
                    Reslist1 = [{Type, GoodId, RewardNum}],
                    %%抽白色装备  白色 1
                    case lists:keyfind(1, 1, EquipList) of
                        false ->
                            Reslist2 = Reslist1;
                        L1 ->
                            {_, TempL1} = L1,
                            T1 = [{?TYPE_GOODS, GoodId1, 1} || {GoodId1, _} <- find_ratio_list(TempL1, 2, White)],
                            Reslist2 = T1 ++ Reslist1
                    end,
                    %%抽绿色装备  绿色 2
                    case lists:keyfind(2, 1, EquipList) of
                        false ->
                            Reslist3 = Reslist2;
                        L2 ->
                            {_, TempL2} = L2,
                            T2 = [{?TYPE_GOODS, GoodId2, 1} || {GoodId2, _} <- find_ratio_list(TempL2, 2, Green)],
                            Reslist3 = T2 ++ Reslist2
                    end,
                    %%抽蓝色装备  蓝色 3
                    case lists:keyfind(3, 1, EquipList) of
                        false ->
                            Reslist4 = Reslist3;
                        L3 ->
                            {_, TempL3} = L3,
                            T3 = [{?TYPE_GOODS, GoodId3, 1} || {GoodId3, _} <- find_ratio_list(TempL3, 2, Blue)],
                            Reslist4 = T3 ++ Reslist3
                    end,
%%                  ?DEBUG("~p~n",[Reslist4]),
                    Reslist5 = ulists:object_list_plus([Reslist4, []]),
                    {Coin, Exp, EquipNum, RewardNum, Reslist5}
            end;
        true ->  %%没有变化，沿用之前的扫荡数据
            #sweep{reward_list = RewardList, coin = Coin, exp = Exp, equip_num = EquipNum,
                reward_num = RewardNum} = Sweep,
            {Coin, Exp, EquipNum, RewardNum, RewardList}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数   List::lists ,N::integer 权重坐标,   Times::抽奖次数
%% @return   返回值  [element].
%% @history  修改历史
%% -----------------------------------------------------------------
find_ratio_list(List, N, Times) ->
    %%?PRINT("--- ~p~n",[Times]),
    find_ratio_list(List, N, Times, []).

find_ratio_list(_List, _N, 0, Res) ->
    %%?PRINT("-- ~p~n",[0]),
    Res;
find_ratio_list(List, N, Times, Res) ->
    R = util:find_ratio(List, N),
    %%?PRINT("-- ~p~n",[Times]),
    find_ratio_list(List, N, Times - 1, [R | Res]).

%% -----------------------------------------------------------------
%% @desc     功能描述 %%统计白色，绿色，蓝色数量
%% @param    参数    {Color,Num,权重}
%% @return   返回值  {白色，绿色，蓝色数量}
%% @history  修改历史
%% -----------------------------------------------------------------
get_color_num([], Res) ->
    Res;
get_color_num([{Color, Num, _} | List], {White, Green, Blue}) ->
    case Color of
        1 ->
            get_color_num(List, {White + Num, Green, Blue});
        2 ->
            get_color_num(List, {White, Green + Num, Blue});
        3 ->
            get_color_num(List, {White, Green, Blue + Num});
        _ ->
            get_color_num(List, {White, Green, Blue})
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  执行扫荡
%% @param    参数
%% @return   返回值     {false,res,Ps}|{true, Coin, Exp,EquipNum, RewardList, NewPs}  ,金币，经验，装备数量，固定奖励列表，
%% @history  修改历史
%% -----------------------------------------------------------------
do_sweep(#player_status{enchantment_guard = _Guard, id = Id} = Ps) ->
    case lib_enchantment_guard_check:check_do_sweep(Ps) of
        true ->
            %%生成奖励-》消耗-》修改扫荡次数-》发放物品-》重置Ps中的sweep -》返回
            case lib_onhook:calc_gold_drop_items(Ps, ?ENCHANTMENT_GUAND_SWEEP_HOURS) of   %%扫荡4个小时
                false ->
                    {false, ?FAIL, Ps};
                [[{?TYPE_EXP, 0, Exp}, {?TYPE_COIN, 0, Coin}], StaticDropList, EquipDropList] -> %%扫荡掉落
                    CurrentTimes = mod_daily:get_count(Id, ?ENCHANTMENT_GUAND, ?SWEEP_COUNT_ID),
                    [Cost] = data_enchantment_guard:get_sweep_cost(CurrentTimes + 1),
                    case lib_goods_api:cost_object_list(Ps, Cost, guard_sweep_cost, "guard_sweep_cost") of  %%检查消耗
                        {false, Res, NewPs} ->
                            {false, Res, NewPs};
                        {true, NewPs} ->
                            %%扫荡加一操作。
                            mod_daily:increment(Id, ?ENCHANTMENT_GUAND, ?SWEEP_COUNT_ID),
                            %%发放物品
                            RewardList = StaticDropList ++ EquipDropList,
                            TaskRewardList = lib_task_drop_api:get_task_func_reward(NewPs, ?TASK_FUNC_TYPE_ENCHANTMENT_GUARD_SWEEP),
                            ProduceList = lib_goods_api:make_reward_unique([{?TYPE_COIN, 0, Coin}] ++ [{?TYPE_EXP, 0, Exp}] ++ RewardList ++ TaskRewardList),
                            %%日志
                            lib_log_api:log_enchantment_guard(?ENCHANTMENT_GUAND_LOG_SWEEP,
                                ProduceList,
                                NewPs,
                                mod_daily:get_count(Id, ?ENCHANTMENT_GUAND, ?SWEEP_COUNT_ID)),
                            Produce = #produce{type = guard_sweep_rewards, reward = ProduceList},
                            {ok, NewPs2} = lib_goods_api:send_reward_with_mail(NewPs, Produce),
                            #player_status{enchantment_guard = NewGuard} = NewPs2,
                            %置空就好
                            LastGuard = NewGuard#enchantment_guard{sweep = {}},
                            LastPs = NewPs2#player_status{enchantment_guard = LastGuard},
                            F = fun(H, TempNum) ->
                                {_, _, TempN} = H,
                                TempNum + TempN
                            end,
                            %%0是返回的格式， F一个参数是个List的元素，一个是叠加的值。最后返回的是叠加的值
                            EquipNum = lists:foldl(F, 0, EquipDropList),
                            {true, Coin, Exp, EquipNum, StaticDropList, LastPs}
                    end
            end;
        {false, Res} ->
            {false, Res, Ps}
    end.


enter_or_leave(Ps, Type) ->
    case Type of
        0 ->
            enter(Ps);
        1 ->
            leave(Ps)
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  进入副本  检查 ，扣除波数(同步数据)，进入副本
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
enter(Ps) ->
    case lib_enchantment_guard_check:before_enter(Ps) of
        true ->
            %%波数置0
            #player_status{enchantment_guard = Guard} = Ps,
            %%告诉客户端，波数为0。
            Ps1 = Ps#player_status{enchantment_guard = Guard},
            %% 根据野外场景找到对应的主线副本
            DunId = case data_enchantment_guard:get_dun_id(Ps1#player_status.scene) of
                TmpDunId when is_integer(TmpDunId) -> TmpDunId;
                _ -> ?ENCHANTMENT_GUAND_DUN_ID
            end,
            case lib_dungeon:enter_dungeon(Ps1, DunId) of
                {ok, NewPs} ->
                    %%参与活动  挪移过lib_dungeon  那边
                    {true, NewPs};
                _ ->
                    {true, Ps}
            end;
        {false, Res} ->
            {false, Res, Ps}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  离开副本
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
leave(_Ps) ->
    ok.


%% -----------------------------------------------------------------
%% @desc     功能描述  应该挑战的怪物属所以关卡应该是下一关才对的
%% @param    参数      Gate::integer    当前最大通关数
%% @return   返回值    []|#enchantment_guard_boss  %%下一关boss属性
%% @history  修改历史
%% -----------------------------------------------------------------
get_mon_data(Gate) ->
    case lib_enchantment_guard_check:get_mon(Gate) of
        true ->
            Res = data_enchantment_guard:get_boss(Gate + 1),
            Res;
        {false, _Res} ->
            []
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  登录初始化
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
login(#player_status{id = Id} = Ps) ->
    OpenLevel =            %%开启登录充满波数
    case data_enchantment_guard:get_value_by_key(?ENCHANTMENT_GUAND_WAVE_KEY) of
        [V1] ->
            V1;
        _ ->
            0
    end,
    Sql = io_lib:format(<<"select  gate, stage_reward_gate, node_id from  player_enchantment_guard where  player_id = ~p">>, [Id]),
    case db:get_row(Sql) of
        [] ->
            NodeId = 0,
            StageGate = 0,
            Gate = 0;
        [Gate, StageGate, NodeId] ->
            ok
    end,
    Wave = case data_enchantment_guard:get_wave_by_id(Gate + 1) of
        [] ->
            0;
        [V] ->
            V
    end,
    NewWave = if
        Gate >= OpenLevel ->   %%开启登录就充满波数
            Wave;
        true ->
            0
    end,
    SoapStatus = load_soap_status(Id),
    Guard = #enchantment_guard{gate = Gate, wave = NewWave, stage_reward_gate = StageGate, node_id = NodeId, soap_status = SoapStatus},
    LastPs = Ps#player_status{enchantment_guard = Guard},
%%  send_client_wave(LastPs),
    LastPs.

load_soap_status(RoleId) ->
    Sql = io_lib:format(?sql_select_enchantment_soap, [RoleId]),
    List = db:get_all(Sql),
    F1 = fun([SoapId, DebrisId], AccMap) ->
        SoapItem = maps:get(SoapId, AccMap, #enchantment_soap_item{soap_id = SoapId}),
        #enchantment_soap_item{active_debris = DebrisIds} = SoapItem,
        NewSoapItem = SoapItem#enchantment_soap_item{active_debris = [DebrisId|DebrisIds]},
        AccMap#{SoapId => NewSoapItem}
    end,
    InitSoapMap = lists:foldl(F1, #{}, List),
    calc_soap_attr(InitSoapMap).

calc_soap_attr(InitSoapMap) ->
    F2 = fun(SoapId, SoapItem, {AccMap, AccAttrL}) ->
        #enchantment_soap_item{active_debris = DebrisIdL} = SoapItem,
        AttrL = [begin
                     case data_enchantment_guard:get_soap_debris(SoapId, DebrisId) of
                         #base_enchantment_guard_soap_debris{attr = Attr} -> Attr;
                         _ -> []
                     end
                 end||DebrisId <- DebrisIdL],
        ItemAttr = lib_player_attr:add_attr(list, AttrL),
        NewSoapItem = SoapItem#enchantment_soap_item{attr = ItemAttr},
        NewAccMap = AccMap#{SoapId => NewSoapItem},
        NewAccAttrL = lib_player_attr:add_attr(list, [ItemAttr, AccAttrL]),
        {NewAccMap, NewAccAttrL}
    end,
    {SoapMap, SumAtr} = maps:fold(F2, {#{}, []}, InitSoapMap),
    #enchantment_soap_status{soap_map = SoapMap, attr = SumAtr}.

%% 离线登录获取属性|查看离线玩家信息时调用
offline_login(RoleId) ->
    SoapStatus = load_soap_status(RoleId),
    #enchantment_guard{soap_status = SoapStatus}.


%% -----------------------------------------------------------------
%% @desc     功能描述  增加波数,用于玩家进程调用
%% @param    参数      Ps::#player_status{},  WaveNum:integer 增加波数数量
%% @return   返回值    {Reply, NewStatus}
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_wave(#player_status{enchantment_guard = Guard} = Ps, WaveNum) ->
    #enchantment_guard{wave = Wave, gate = Gate, auto = Auto} = Guard,
    case data_enchantment_guard:get_wave_by_id(Gate + 1) of
        [] ->
            NewWave = Wave + WaveNum;
        [V] -> %%挑战关卡所需波数
            if
                Wave + WaveNum >= V ->   %%满足挑战条件
                    NewWave = V,
%%                  ?DEBUG("~p,~p~n", [NewWave, Auto]),
                    case Auto of         %%检查是否自动挑战
                        ?ENCHANTMENT_GUAND_AUTO ->
                            %%一秒后主线副本
                            util:send_after(self(), 1000, self(), {'mod', lib_enchantment_guard, do_info_enter, []}),
                            ok;
                        _ ->
                            ok
                    end;
                true ->
                    NewWave = Wave + WaveNum
            end
    end,
    NewGuard = Guard#enchantment_guard{wave = NewWave},
    LastPs = Ps#player_status{enchantment_guard = NewGuard},
    {LastPs, LastPs}.

%% -----------------------------------------------------------------
%% @desc     功能描述  用于玩家进程info的调用，实际是主线副本自动挑战的处理
%% @param    参数      Ps:: #player_status{}
%% @return   返回值    {ok, NewPs}
%% @history  修改历史
%% -----------------------------------------------------------------
do_info_enter(#player_status{sid = Sid, scene = _SceneId} = Ps) ->
    IsEnchantmentScene  = lib_dungeon:is_on_dungeon(Ps),
    if
        IsEnchantmentScene == true ->  %% 在副本内了
            {ok, Ps};
        true ->
            EnchantmentEnterCd = get(enchantment_enter_cd),
            Now = utime:unixtime(),
            if
                EnchantmentEnterCd == undefined orelse Now > EnchantmentEnterCd->
                    case enter(Ps) of
                        {true, NewPs} ->
                            put(enchantment_enter_cd, Now + 1),
                            {ok, NewPs};
                        {false, Res, NewPs} ->
                            lib_server_send:send_to_sid(Sid, pt_133, 13305, [Res]),
                            {ok, NewPs}
                    end;
                true ->
                    {ok, Ps}
            end
    end.




%% -----------------------------------------------------------------
%% @desc     功能描述  增加波数,用于玩家进程调用
%% @param    参数      Ps:#player_status{},  WaveNum:integer 增加击杀怪物数量 ，不在是boss
%% @return   返回值    #player_status{}
%% @history  修改历史
%% -----------------------------------------------------------------
add_wave(#player_status{enchantment_guard = Guard, sid = Sid, figure = #figure{lv = RoleLv}} = Ps, KillNum) ->
%%  ?MYLOG("cym", "add ++++~n", []),
    #enchantment_guard{wave = OldKillNum, gate = Gate, auto = Auto} = Guard,
    case data_enchantment_guard:get_wave_by_id(Gate + 1) of
        [] ->
            NewKillMonNum = OldKillNum + KillNum;
        [V] -> %%挑战关卡所需波数
            LvLimit = data_enchantment_guard:get_lv_by_id(Gate + 1),
            if
                OldKillNum + KillNum >= V andalso  RoleLv >= LvLimit ->   %%满足挑战条件
                    NewKillMonNum = V,
                    case Auto of         %%检查是否自动挑战
                        ?ENCHANTMENT_GUAND_AUTO ->
                            %%一秒后主线副本
                            util:send_after(self(), 1000, self(), {'mod', lib_enchantment_guard, do_info_enter, []}),
                            ok;
                        _ ->
                            ok
                    end;
	            OldKillNum + KillNum >= V ->  %% 满足了波数，不满足等级
		            NewKillMonNum = V;
                true ->
                    NewKillMonNum = OldKillNum + KillNum
            end
    end,
    NewGuard = Guard#enchantment_guard{wave = NewKillMonNum},
    PS1 = Ps#player_status{enchantment_guard = NewGuard},
    %%告诉客户端，增加波数。
    case lib_enchantment_guard:get_enter_data(PS1) of
        {true, CurrentKillNum, NeedNum, SendAssistId, AssisterInfo, LastPs} ->  %%当前击杀怪物数量，所需数量
            case AssisterInfo of
                #faker_info{role_id = AssisterId} -> ok;
                _ -> AssisterId = 0
            end,
            lib_server_send:send_to_sid(Sid, pt_133, 13300, [?SUCCESS, CurrentKillNum, NeedNum, SendAssistId, AssisterId]),
            LastPs;
        {false, Res, LastPs} ->
            lib_server_send:send_to_sid(Sid, pt_133, 13300, [Res, 0, 0, 0, 0]),
            LastPs
    end.

%%告诉客户端波数。不改变ps
send_client_wave(#player_status{sid = Sid} = Ps) ->
    case lib_enchantment_guard:get_enter_data(Ps) of
        {true, CurrentWave, NeedWave, SendAssistId, AssisterInfo, LastPs} ->  %%当前波数，所需波数
%%          ?DEBUG("~p,~p~n", [CurrentWave, NeedWave]),
            case AssisterInfo of
                #faker_info{role_id = AssisterId} -> ok;
                _ -> AssisterId = 0
            end,
            lib_server_send:send_to_sid(Sid, pt_133, 13300, [?SUCCESS, CurrentWave, NeedWave, SendAssistId, AssisterId]),
            LastPs;
        {false, Res, LastPs} ->
%%          ?DEBUG("~p~n", [Res]),
            lib_server_send:send_to_sid(Sid, pt_133, 13300, [Res, 0, 0, 0, 0]),
            LastPs
    end.


%%get_mon_attr(#player_status{copy_id = Copy} = Ps) ->
%%  _Res = lib_mon:get_scene_mon(20001, 0, Copy, all),
%%  Ps.

dunex_handle_enter_dungeon(PS, #dungeon{}) ->
    #player_status{enchantment_guard = Guard, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = RoleX, y = RoleY} = PS,
    #enchantment_guard{gate = Gate} = Guard,
    StatusAssist = get_assist_info(PS, Gate + 1),
    case StatusAssist of
        #status_assist{assister_info = #faker_info{} = FakerInfo, assist_process = 1} ->
            Args = [{faker_info, FakerInfo}, {group, ?DUN_DEF_GROUP}, {find_target, 1500}, {check_block, true}, {warning_range, 1000}],
            lib_scene_object:async_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, RoleX, RoleY, 1, CopyId, 1, Args);
        _ -> skip
    end,
    PS.


%%用于挑战成功，发送奖励, 但是这里实际上奖励不生成， 在结算哪里生成
%%cast更新玩家闯关关数
dunex_get_send_reward(_, _) ->
    [].


%%设置当前玩家的关卡到副本信息中去
init_dungeon_role(#player_status{enchantment_guard = Guard} = _Ps, _Dun, Role) ->
    case Guard of
        #enchantment_guard{gate = Gate} ->
            Role#dungeon_role{typical_data = #{?DUN_ROLE_SPECIAL_KEY_ENCHANTMENT_GUARD_GATE => Gate}};
        _Guard ->
            Role#dungeon_role{typical_data = #{?DUN_ROLE_SPECIAL_KEY_ENCHANTMENT_GUARD_GATE => 0}}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  用于挑战成功后增加关卡 ,发送奖励, 并且更新排行榜
%% @param    参数      Gate::integer                  当前关卡
%%                     PS  ::#player_status           玩家状态
%%                     Num ::integer                  增加的关卡数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_cast_battle_success(#player_status{sid = Sid, id = PlayerId, figure = #figure{career = Career}} = Ps, Gate, Num) when Gate >= 0 ->
    case lib_enchantment_guard_check:add_gate(Gate, Num) of
        true ->
            Res = data_enchantment_guard:get_boss(Gate + Num),
            %%抽奖，获取奖励
            #enchantment_guard_boss{goods_num = NumList, goods_pool = Pool,
                coin = Coin, start_gate = _StartGate,
                other_goods_pool = CfgOtherGoodsPool, other_reward_list = CareerReward} = Res,
            RewardNum = case NumList of
                [] ->
                    0;
                _ ->
                    [{_RewardNum, _}] = find_ratio_list(NumList, 2, 1),
                    _RewardNum
            end,
            % 兼容按职业区分奖池和统一奖池
            case Pool of
                [{_, _}|_] -> {_, Pool1} = ulists:keyfind(Career, 1, Pool, {Career, []});
                _ -> Pool1 = Pool
            end,
            TempList = find_ratio_list(Pool1, 4, RewardNum),  %%抽奖，获取奖励列表
            RewardList1 = [{Type, GoodId, GoodNum} || {Type, GoodId, GoodNum, _} <- TempList], %%转换格式  通关奖励
            %%固定奖励 + 道具库抽奖
            {_, CfgOtherRewardList} = ulists:keyfind(Career, 1, CareerReward, {Career, []}),
            OtherReward = get_other_reward(CfgOtherRewardList, CfgOtherGoodsPool),
            %%金币随关数增加,经验同样
            RewardList     = [{?TYPE_COIN, 0, Coin}] ++ OtherReward ++ RewardList1,
            LastRewardList = [{GoodsType2, GoodsId2, Num2} ||{GoodsType2, GoodsId2, Num2} <-RewardList, Num2 =/= 0],
            Produce = #produce{type = guard_boss_rewards, reward = LastRewardList},
            %%更新玩家状态 通关关数
            #player_status{enchantment_guard = Guard, id = Id, figure = Figure, combat_power = Combat} = Ps,
            NewGuard = Guard#enchantment_guard{gate = Gate + Num, wave = 0}, %%关卡 + Num ,波数为0
            NewPs = Ps#player_status{enchantment_guard = NewGuard},
            %%日志
            lib_log_api:log_enchantment_guard(?ENCHANTMENT_GUAND_LOG_BATTLE, LastRewardList, NewPs, 0),
            %%同步更新数据库
            Sql = io_lib:format(<<"replace into player_enchantment_guard(player_id, gate,last_time, stage_reward_gate,
             node_id) values(~p, ~p,~p, ~p, ~p)">>,
                [PlayerId, Gate + Num, utime:unixtime(), NewGuard#enchantment_guard.stage_reward_gate, NewGuard#enchantment_guard.node_id]),
            db:execute(Sql),
            #figure{name = Name} = Figure,
            Rank = #enchantment_role_rank{role_id = Id, role_name = Name, gate = Gate + Num, combat = Combat},
            mod_enchantment_guard_rank_local:update_rank_list(Rank),                                    %%更新排行榜
            {_, _, LastPs, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(NewPs, Produce),              %%发送奖励
            SeeRewardList               = lib_goods_api:make_see_reward_list(Produce#produce.reward, UpGoodsList),
            SeeRewardList1              = [{TempGoodsType, TempGoodsId, _Num, GoodsAutoId}||{TempGoodsType, TempGoodsId, _Num, GoodsAutoId} <- SeeRewardList,
                                                TempGoodsType =/=?TYPE_COIN, TempGoodsType =/= ?TYPE_EXP],  %%过滤金钱和经验
            %%通知更新收益
            lib_task_api:fin_main_dun(Ps, Gate + Num),
%%          %%发送信息给客户端.
%%          {OnHookOldExp, OnHookOldGold} = lib_onhook:get_onhook_reward(LastPs, Gate),
%%          {OnHookExp, OnHookGold} = lib_onhook:get_onhook_reward(LastPs, Gate + Num),
            RewardArray = [{0, SeeRewardList1}],   %%//0:通关奖励
            lib_server_send:send_to_sid(Sid, pt_133, 13306, [?SUCCESS, 0, Coin, 0, RewardArray]),
            send_client_wave(LastPs),  %%波数信息
            lib_achievement_api:pass_enchantment_dun_event(LastPs, []),
            lib_player:update_enchantment_dun_count(LastPs),
            LastPS2 = lib_enchantment_guard_event:player_gate_change(LastPs, Gate, Gate + Num),
            lib_afk:send_exp_effect_info(LastPS2),
            fin_guild_assist(LastPS2, 1, Gate + Num),
            LastPS2;
        {false, _Res} ->
            %%失败信息
%%          ?DEBUG("battle fail", []),
            %%将波数重置
            #player_status{enchantment_guard = TmepGuard} = Ps,
            #enchantment_guard{gate = TmepGate} = TmepGuard,
            TempWave = case data_enchantment_guard:get_wave_by_id(TmepGate + 1) of
                [] ->
                    0;
                [V] ->
                    V
            end,
            Guard = TmepGuard#enchantment_guard{wave = TempWave, auto = 1}, %%失败就关闭自动闯关
            LastPs = Ps#player_status{enchantment_guard = Guard},
            RewardArray = [{0, []}, {1, []}],
            lib_server_send:send_to_sid(Sid, pt_133, 13306, [?SUCCESS, 1, 0, 0, RewardArray]),
            send_client_wave(LastPs),  %%波数信息
            fin_guild_assist(LastPs, 2, Gate),
            LastPs
    end;
do_cast_battle_success(#player_status{sid = _Sid, id = PlayerId} = Ps, -1, _Num) ->  %%-1 是主动退出
    %%将波数重置
    #player_status{enchantment_guard = TmepGuard} = Ps,
    #enchantment_guard{gate = TmepGate} = TmepGuard,
    TempWave = case data_enchantment_guard:get_wave_by_id(TmepGate + 1) of
        [] ->
            0;
        [V] ->
            V
    end,
    Guard = TmepGuard#enchantment_guard{wave = TempWave, auto = 1},  %%失败就将自动闯关关闭
    LastPs = Ps#player_status{enchantment_guard = Guard},
    send_client_wave(LastPs),  %%波数信息
    close_auto_battle(PlayerId),
    fin_guild_assist(LastPs, 2, TmepGate),
    LastPs;
do_cast_battle_success(#player_status{sid = Sid, id = _PlayerId} = Ps, _Gate, _Num) ->
    %%失败信息
    %%将波数重置
    #player_status{enchantment_guard = TmepGuard} = Ps,
    #enchantment_guard{gate = TmepGate} = TmepGuard,
    TempWave = case data_enchantment_guard:get_wave_by_id(TmepGate + 1) of
        [] ->
            0;
        [V] ->
            V
    end,
    Guard = TmepGuard#enchantment_guard{wave = TempWave, auto = 1},  %%失败就将自动闯关关闭
    close_auto_battle(_PlayerId),
    LastPs = Ps#player_status{enchantment_guard = Guard},
%%  ?DEBUG("battle fail ~p~n ", [Guard]),
    RewardArray = [{0, []}, {1, []}],
    lib_server_send:send_to_sid(Sid, pt_133, 13306, [?SUCCESS, 1, 0, 0, RewardArray]),
    send_client_wave(LastPs),  %%波数信息
    fin_guild_assist(LastPs, 2, TmepGate),
    LastPs.

fin_guild_assist(PS, EndType, Gate) ->
    StatusAssist = get_assist_info(PS, Gate),
    #status_assist{assist_id = AssistId, assist_process = AssistProcess, target_cfg_id = TargetCfgId} = StatusAssist,
    case AssistId > 0 andalso AssistProcess == 1 of
        true ->
            case TargetCfgId == Gate of
                true ->
                    mod_guild_assist:dungeon_end_special(AssistId, EndType);
                _ ->
                    mod_guild_assist:dungeon_end_special(AssistId, 2)
            end;
        _ -> skip
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  用于通关结算
%% @param    参数      State::#dungeon_state{}
%%                     Role ::#dungeon_role{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_push_settlement(#dungeon_state{result_type = _ResultType, result_subtype = ResultSubType} = _State, #dungeon_role{pid = PlayerId} = _Role)
    when ResultSubType == ?DUN_RESULT_SUBTYPE_ACTIVE_QUIT ->
    %%玩家主动退出
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_enchantment_guard, do_cast_battle_success, [-1, 1]);
dunex_push_settlement(#dungeon_state{result_type = ResultType} = _State, #dungeon_role{pid = PlayerId} = _Role)
    when ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
    %%发送失败信息
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_enchantment_guard, do_cast_battle_success, [-10, 1]);
dunex_push_settlement(_State, DunRole) ->
    %%#{?DUN_ROLE_SPECIAL_KEY_ENCHANTMENT_GUARD_GATE := Gate}
    #dungeon_role{id = PlayerId, typical_data = #{?DUN_ROLE_SPECIAL_KEY_ENCHANTMENT_GUARD_GATE := Gate}} = DunRole,
    %%cast到玩家进程中 在玩家进程中结算
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_enchantment_guard, do_cast_battle_success, [Gate, 1]).


%% -----------------------------------------------------------------
%% @desc     功能描述  开启自动战斗
%% @param    参数       type:integer     //0:开启     1：关闭
%% @return   返回值
%% @history  修改历史
%% ----------------------------------------------------------------
auto_battle(#player_status{enchantment_guard = Guard} = Ps, Type) ->
    NewGuard = Guard#enchantment_guard{auto = Type},
    NewPs = Ps#player_status{enchantment_guard = NewGuard},
    #enchantment_guard{gate = Gate, wave = NewWave} = NewGuard,
    case data_enchantment_guard:get_wave_by_id(Gate + 1) of
        [] ->
            ok;
        [V] -> %%挑战关卡所需波数
            if
                NewWave >= V ->   %%满足挑战条件
                    case Type of         %%检查是否自动挑战
                        ?ENCHANTMENT_GUAND_AUTO ->
                            %%一秒后主线副本
                            util:send_after(self(), 1000, self(), {'mod', lib_enchantment_guard, do_info_enter, []});
                        _ ->
                            ok
                    end;
                true ->
                    ok
            end
    end,
    {true, NewPs}.


%% -----------------------------------------------------------------
%% @desc     功能描述   封印  检查是否达到最大值,扣除-》获取奖励-》发送奖励-》封印次数加一 -》修正ps -》返回。
%% @param    参数         Ps::#player_status
%%                        Times::integer 第N次封印
%% @return   返回值        {false,ErrCode,Ps}| {true,LastPs,RewardList}
%% @history  修改历史
%% -----------------------------------------------------------------
seal(#player_status{id = Id} = TempPs, _Times) ->
    case get_seal_data(TempPs) of
        {true, _MaxTimes, _CurrentTimes, 0, [], Ps} ->
            {false, ?ERRCODE(err133_err_config), Ps};
        {true, MaxTimes, CurrentTimes, CostNum, RewardList, Ps} ->
            %%  检查是否满足消耗,是否达到最大值
            NewCost = [{?TYPE_CURRENCY, ?GOODS_ID_MON_SOUL, CostNum}],
            case lib_enchantment_guard_check:seal(MaxTimes, CurrentTimes, NewCost, Ps) of
                {false, ErrCode} ->
%%                  ?DEBUG("~p~n", [ErrCode]),
                    {false, ErrCode, Ps};
                true ->
                    %%扣除
                    case lib_goods_api:cost_object_list(Ps, NewCost, guard_seal_cost, "guard_seal_cost") of
                        {false, Res, NewPs} ->
                            {false, Res, NewPs};
                        {true, NewPs} ->
                            Produce = #produce{type = guard_seal_reward, reward = RewardList},
                            %%日志
                            lib_log_api:log_enchantment_guard(?ENCHANTMENT_GUAND_LOG_SEAL, RewardList, NewPs, CurrentTimes + 1),
                            {ok, LastPs} = lib_goods_api:send_reward_with_mail(NewPs, Produce),  %%发送奖励
                            mod_daily:increment(Id, ?ENCHANTMENT_GUAND, ?SEAL_COUNT_ID),         %%封印次数+1
                            {true, LastPs, RewardList}
                    end
            end;
        {false, ErrCode, Ps} ->
%%          ?DEBUG("~p~n", [ErrCode]),
            {false, ErrCode, Ps}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取玩家主线副本最大章节
%% @param    参数     _Ps::#player_status{}
%% @return   返回值    Chater::integer    最大章节数
%% @history  修改历史
%% -----------------------------------------------------------------
get_max_chapter(#player_status{enchantment_guard = Guard} = _Ps) ->
    #enchantment_guard{gate = Chater} = Guard,
    Chater.


%% -----------------------------------------------------------------
%% @desc     功能描述   获取属性增幅
%% @param    参数      eg:List: [{[0,10],0.1},{[11,50],0.5},{[51,999],1}]|[],
%%                        Gate::integer   关卡
%% @return   返回值    Add::float
%% @history  修改历史
%% -----------------------------------------------------------------
get_add_attr([], _) ->
    [];
get_add_attr([H | TList], Gate) ->
    {[MinGate, MaxGate], Add} = H,
    if
        Gate >= MinGate andalso Gate =< MaxGate ->
            Add;
        true ->
            get_add_attr(TList, Gate)
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  %%获得boss的属性
%% @param    参数      GuardBoss::#enchantment_guard_boss{},
%%                    MonId2::integer  怪物id
%%                    State::#dungeon_state{}
%% @return   返回值    [] | #attr{}
%% @history  修改历史
%% -----------------------------------------------------------------
get_guard_boss_attr([], _MonId2, _State, _, _, OX, OY) ->
    {[], OX, OY};
get_guard_boss_attr(GuardBoss, MonId2, State, NowSceneId, CopyId, OX, OY) ->
    case data_mon:get(MonId2) of
        [] ->
            GuardAtt = [],
            {GuardAtt, OX, OY};
        #mon{ special_attr = SpecailAttr, speed = Speed } ->
            #enchantment_guard_boss{start_gate = StartGate, attr = BaseAttr, attr_add = AttrAdd} = GuardBoss,
            %%主线副本属性增幅
            OpenDay = util:get_open_day(),
            #dungeon_state{role_list = TempRoleList} = State,
            [TempRole | _] = TempRoleList,
            #dungeon_role{x=RoleX, y=RoleY, typical_data = #{?DUN_ROLE_SPECIAL_KEY_ENCHANTMENT_GUARD_GATE := TempGate}} = TempRole, %%当前关卡
%%          %%关数增幅  万分比
            NewAttrAdd = (TempGate + 1 - StartGate) * AttrAdd / 10000 + 1,
            %%属性 = 基本属性 * 关卡增幅百分比
            NewBaseAttr = [{AttId,  erlang:round(NewAttrAdd * AttVal)}||{AttId, AttVal}<-BaseAttr],
            % 属性增益
            case data_enchantment_guard:get_guard_attr_ratio(OpenDay, TempGate + 1) of
                Ratio when is_integer(Ratio) ->
                    LastBaseAttr = [{AttId,  round(max(((10000 + Ratio) / 10000 ) * AttVal, 1))}||{AttId, AttVal}<-NewBaseAttr];
                _ ->
                    %%属性 = 基本属性 * 关卡增幅百分比
                    LastBaseAttr = NewBaseAttr         %% hp
            end,
            Attr = lib_player_attr:to_attr_record(LastBaseAttr),
            Attr1 = Attr#attr{speed = Speed},
            {LastBossX, LastBossY} = get_boss_xy(RoleX, RoleY, NowSceneId, CopyId, TempGate + 1),
            if
                SpecailAttr == [] ->
                    GuardAtt = Attr1,
                    {GuardAtt, LastBossX, LastBossY};
                true ->
                    AttrList = lib_player_attr:to_kv_list(Attr),
                    NewAttrList = ulists:kv_list_plus_extra([AttrList, SpecailAttr]),
                    GuardAtt = lib_player_attr:to_attr_record(NewAttrList),
                    {GuardAtt, LastBossX, LastBossY}
            end
    end.

get_boss_xy(RoleX, RoleY, NowSceneId, CopyId, Gate) ->
    case data_enchantment_guard:get_boss_xy(Gate) of
        [{X, Y}] -> {X, Y};
        _ ->
            XyListTemp = [
                {RoleX+400, max(0, RoleY+320)}, {RoleX-400, max(0, RoleY-320)},  %% 右上
                {RoleX-400, max(0, RoleY+320)}, {RoleX+400, max(0, RoleY-320)},  %% 左下
                {RoleX+200, max(0, RoleY+160)}, {RoleX-200, max(0, RoleY-160)},  %% 左上
                {RoleX-200, max(0, RoleY+160)}, {RoleX+200, max(0, RoleY-160)}  %% 右下
            ],
            #ets_scene{height = MapH, width = MapW} = data_scene:get(NowSceneId),
            XyList = [{TempX, TempY} ||{TempX, TempY} <- XyListTemp,
                TempX > 0 andalso  TempX =< MapW, TempY > 0 andalso  TempY =< MapH],
            lib_scene:get_unblocked_xy(XyList, NowSceneId, CopyId, {RoleX, RoleY})
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  获得boss信息和战力碾压
%% @param    参数     State::#dungeon_state{}
%%                    IsUsePowerCrush::integer  是否进行战力碾压
%%                    RoleList::[#dungeon_role{}]
%%                    RecommendPower::integer  原来的战力
%% @return   返回值   {GuardBoss, CrushRAttr}
%%                    GuardBoss::#enchantment_guard_boss{},
%%                    CrushRAttr:: []|[{dun_crush_r, 战力碾压系数}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_boss(State, PowerCrushType, RoleList, _RecommendPower) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, wave_num = WaveNum} = State,
    if
        DunType == ?DUNGEON_TYPE_ENCHANTMENT_GUARD ->
            #dungeon_state{role_list = GuardRoleList} = State,
            [GuardRole | _T] = GuardRoleList,
            #dungeon_role{typical_data = #{?DUN_ROLE_SPECIAL_KEY_ENCHANTMENT_GUARD_GATE := GuardGate}} = GuardRole,
            %%获得对应主线副本的怪物属性
%%          GuardBoss = lib_player:apply_call(PlayerId, 3, lib_enchantment_guard, get_mon_data, []),
            GuardBoss = lib_enchantment_guard:get_mon_data(GuardGate),
            case GuardBoss of
                [] ->
                    CrushRAttr = lib_dungeon_mon_event:get_power_crush_attr(DunId, WaveNum, RoleList),  %原来的战力碾压
                    {GuardBoss, CrushRAttr};
                _ -> %%针对性调整战力碾压属性
                    #enchantment_guard_boss{power = TempPower, power_add = PowerAdd, start_gate = Sgate, boss_lv = BossLv} = GuardBoss,
%%                  NewPower = erlang:round(TempPower * ((GuardGate + 1 - Sgate) * PowerAdd / 100 + 1)),  不用百分比，直接用固定增加值
                    NewPower = erlang:round(TempPower * ((GuardGate + 1 - Sgate) * PowerAdd / 10000 + 1)),  %%改用万分比
%%                    ?DEBUG("oldPower:~p, newPower:~p~n",[TempPower, NewPower]),
                    case PowerCrushType =/= ?DUN_POWER_CRUSH_TYPE_NO of
                        true -> CrushRAttr = lib_dungeon_mon_event:get_power_crush_attr(RoleList, NewPower);
                        false -> CrushRAttr = []
                    end,
                    {GuardBoss, [{lv, BossLv}|CrushRAttr]}
            end;
        true ->
            GuardBoss = [],
            CrushRAttr = lib_dungeon_mon_event:get_power_crush_attr(DunId, WaveNum, RoleList),  %%战力碾压
            {GuardBoss, CrushRAttr}
    end.


%%获取额外奖励
get_other_reward(CfgOtherRewardList, []) ->
    CfgOtherRewardList;

%%获取额外奖励 GoodsPool::[{type, Id, num,wight}]
get_other_reward(CfgOtherRewardList, GoodsPool) ->
    [{Type, Id, Num, _} | _] = find_ratio_list(GoodsPool, 4, 1),  %%抽奖，获取奖励列表
    CfgOtherRewardList ++ [{Type, Id, Num}].


%%更新阶段奖励关卡
save_stage_reward_gate_to_db(RoleId, Guard) ->
    #enchantment_guard{gate = Gate, stage_reward_gate = StageGate, node_id = NodeId} = Guard,
    save_stage_reward_gate_to_db(RoleId, Gate, utime:unixtime(), StageGate, NodeId).
save_stage_reward_gate_to_db(RoleId, NowGate, Time, StageGate, NodeId) ->
    Sql = io_lib:format(<<"replace into player_enchantment_guard(player_id,  gate, last_time, stage_reward_gate, node_id) values(~p,  ~p, ~p, ~p, ~p)">>,
        [RoleId, NowGate, Time, StageGate, NodeId]),
    db:execute(Sql).


%%获取下一个阶段奖励关卡
get_next_stage_reward_gate(#player_status{enchantment_guard = Guard, id = RoleId}) ->
    #enchantment_guard{stage_reward_gate = StageRewardGate} = Guard,
%%  ?MYLOG("cym", "StageRewardGate Gate  ~p~n ", [StageRewardGate]),
    NextGate = data_enchantment_guard:get_next_stage_gate(StageRewardGate),
%%  ?MYLOG("cym", "next Stage Gate  ~p~n ", [NextGate]),
    {ok, Bin} = pt_133:write(13309, [?SUCCESS, NextGate]),
    lib_server_send:send_to_uid(RoleId, Bin).

%% -----------------------------------------------------------------
%% @desc     功能描述   领取阶段奖励
%% @param    参数       Gate::integer()   阶段奖励关卡
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_stage_reward(#player_status{enchantment_guard = Guard, id = RoleId} = Ps, Gate) ->
    #enchantment_guard{stage_reward_gate = StageRewardGate, gate = NowGate, node_id = NodeId} = Guard,
    NextGate = data_enchantment_guard:get_next_stage_gate(StageRewardGate),
    if
        (Gate =/= NextGate) orelse NowGate < NextGate ->  %%客户端发送的关卡错误
            {ok, Bin} = pt_133:write(13310, [?ERRCODE(err133_err_stage_gate), []]),
            lib_server_send:send_to_uid(RoleId, Bin),
            Ps;
        true ->  %%领取阶段奖励
            Reward = get_stage_reward_list(Gate),
            %%通知客户端
            {ok, Bin} = pt_133:write(13310, [?SUCCESS, Reward]),
            lib_server_send:send_to_uid(RoleId, Bin),
%%          ?MYLOG("cym", "stage  reward  ~p ~n", [Reward]),
            lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = enchantment_guard_stage_reward}),
            save_stage_reward_gate_to_db(RoleId, NowGate, utime:unixtime(), Gate, NodeId), %%同步数据库
            NewGuard = Guard#enchantment_guard{stage_reward_gate = Gate},
            Ps#player_status{enchantment_guard = NewGuard}
    end.

%%获取阶段奖励列表
get_stage_reward_list(Gate) ->
    case data_enchantment_guard:get_stage_reward(Gate) of
        #enchantment_guard_stage_reward{reward = Reward, goods_pool = Pool} ->
            case Pool of
                [] ->
                    Reward;
                _ ->
                    [{Type, GoodId, Num, _}] = find_ratio_list(Pool, 4, 1),
                    Reward ++ [{Type, GoodId, Num}]
            end;
        _ ->
            []
    end.


%%获取下一关的收益
send_next_gate_earnings(#player_status{enchantment_guard = Guard, id = RoleId} = PS) ->
    #enchantment_guard{gate = Gate} = Guard,
    {Exp, Gold} = lib_onhook:get_onhook_reward(PS, Gate + 1),
    {ok, Bin} = pt_133:write(13311, [?SUCCESS, Gold, Exp]),
    lib_server_send:send_to_uid(RoleId, Bin).



close_auto_battle(PlayerId) ->
    {ok, Bin} = pt_133:write(13307, [?SUCCESS, 1]),
    lib_server_send:send_to_uid(PlayerId, Bin).


%% -----------------------------------------------------------------
%% @desc     功能描述   发送古宝信息
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_soap_info(PS) ->
    #player_status{enchantment_guard = GuardStatus, original_attr = SumOAttr, sid = Sid} = PS,
    #enchantment_guard{soap_status = SoapStatus} = GuardStatus,
    #enchantment_soap_status{soap_map = SoapMap, attr = Attr} = SoapStatus,
    F = fun(SoapId, SoapItem, AccList) ->
        #enchantment_soap_item{active_debris = DebrisIdL} = SoapItem,
        [{SoapId, DebrisIdL}|AccList]
    end,
    SendPower = lib_player:calc_partial_power(SumOAttr, 0, Attr),
    SendList = maps:fold(F, [], SoapMap),
    {ok, BinData} = pt_133:write(13320, [SendPower, SendList]),
    ?PRINT("SendList ~p ~n", [SendList]),
    lib_server_send:send_to_sid(Sid, BinData).

%% -----------------------------------------------------------------
%% @desc     功能描述   激活古宝碎片
%% @param    参数      SoapId::integer()      古宝ID
%% @param    参数      DebrisId::integer()    碎片ID
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
active_soap_debris(PS, SoapId, DebrisId) ->
    case lib_enchantment_guard_check:check_active_debris(PS, SoapId, DebrisId) of
        {true, Cost} ->
            case do_active_soap_debris(PS, SoapId, DebrisId, Cost) of
                {true, LastPS, LastSoapStatus} ->
                    #player_status{id = RoleId, original_attr = SumOAttr} = PS,
                    #enchantment_soap_status{soap_map = SoapMap, attr = Attr} = LastSoapStatus,
                    #enchantment_soap_item{active_debris = DebrisIdL} =
                        maps:get(SoapId, SoapMap, #enchantment_soap_item{soap_id = SoapId}),
                    Power = lib_player:calc_partial_power(SumOAttr, 0, Attr),
                    lib_server_send:send_to_uid(RoleId, pt_133, 13321, [?SUCCESS, SoapId, DebrisIdL, Power]),
                    {ok, battle_attr, LastPS};
                {false, Errcode} ->
                    lib_server_send:send_to_uid(PS#player_status.id, pt_133, 13321, [Errcode, 0, [], 0])
            end;
        {false, Errcode} ->
            ?PRINT("Errcode ~p ~n", [Errcode]),
            lib_server_send:send_to_uid(PS#player_status.id, pt_133, 13321, [Errcode, 0, [], 0])
    end.

do_active_soap_debris(PS, SoapId, DebrisId, Cost) ->
    case lib_goods_api:cost_object_list(PS, Cost, active_enchantment_soap, "") of
        {true, NewPS} ->
            #enchantment_guard{soap_status = SoapStatus} = GuardStatus = NewPS#player_status.enchantment_guard,
            #enchantment_soap_status{soap_map = SoapMap} = SoapStatus,
            SoapItem =#enchantment_soap_item{active_debris = ODebrisL}  =
                maps:get(SoapId, SoapMap, #enchantment_soap_item{soap_id = SoapId}),
            NewSoapItem = SoapItem#enchantment_soap_item{active_debris = [DebrisId|ODebrisL]},
            NewSoapMap = SoapMap#{SoapId => NewSoapItem},
            NewSoapStatus = calc_soap_attr(NewSoapMap),
            NewGuardStatus = GuardStatus#enchantment_guard{soap_status = NewSoapStatus},
            LastPSTmp = NewPS#player_status{enchantment_guard = NewGuardStatus},
            LastPS = lib_player:count_player_attribute(LastPSTmp),
            lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
            db:execute(io_lib:format(?sql_replace_enchantment_soap, [PS#player_status.id, SoapId, DebrisId])),
            lib_log_api:log_enchantment_guard_soap_debris(PS#player_status.id, SoapId, DebrisId),
            %% 传闻相关
            IsWhole = lib_enchantment_guard_check:is_active_whole_soap(NewSoapItem),
            case data_enchantment_guard:get_soap(SoapId) of
                _ when not IsWhole -> skip;
                #base_enchantment_guard_soap{tv_ids = TvIds} ->
                    lib_task_api:active_soap(LastPS, SoapId),
                    TvId = urand:list_rand(TvIds),
                    is_integer(TvId) andalso lib_chat:send_TV({all}, 133, TvId, [PS#player_status.figure#figure.name]);
                _ -> skip
            end,
            {true, LastPS, NewSoapStatus};
        ErrInfo ->
            ErrInfo
    end.

set_new_process_node(PS, NodeId) ->
    #player_status{enchantment_guard = GuardStatus, id = RoleId} = PS,
    NewGuardStatus = GuardStatus#enchantment_guard{node_id = NodeId},
    NewPS = PS#player_status{enchantment_guard = NewGuardStatus},
    save_stage_reward_gate_to_db(RoleId, NewGuardStatus),
    lib_server_send:send_to_uid(RoleId, pt_133, 13322, [NodeId]),
    {ok, NewPS}.

get_new_process_node(PS) ->
    #player_status{enchantment_guard = GuardStatus, id = RoleId} = PS,
    #enchantment_guard{node_id = NodeId} = GuardStatus,
    lib_server_send:send_to_uid(RoleId, pt_133, 13323, [NodeId]).

get_assist_times_info(PS) ->
    #player_status{enchantment_guard = GuardStatus, id = RoleId} = PS,
    #enchantment_guard{next_assist_time = NextTime} = GuardStatus,
    DailyCount = mod_daily:get_count(RoleId, ?MOD_ENCHANTMENT_GUARD, 3),
    {ok, BinData} = pt_133:write(13324, [DailyCount, NextTime]),
    lib_server_send:send_to_uid(RoleId, BinData).


%%秘籍设置通关关卡
gm_set_gate(Status, Gate) ->
    #player_status{enchantment_guard = Guard} = Status,
    NewGuard = Guard#enchantment_guard{gate = Gate},
    %%db
    %%同步更新数据库
    Sql = io_lib:format(<<"replace into player_enchantment_guard(player_id, gate,last_time, stage_reward_gate, node_id) values(~p, ~p,~p, ~p, ~p)">>,
        [Status#player_status.id, Gate, utime:unixtime(), Guard#enchantment_guard.stage_reward_gate, Guard#enchantment_guard.node_id]),
    db:execute(Sql),
    Status#player_status{enchantment_guard = NewGuard}.


get_dungeon_level(#player_status{enchantment_guard = Guard}) ->
    case Guard of
        #enchantment_guard{gate = Gate} ->
            Gate;
        _ ->
            0
    end.


add_kill_mon_num_hooking(_SceneId, _AtterId, []) ->
    skip;
add_kill_mon_num_hooking(SceneId, _AtterId, [#mon_atter{id = RoleId} |List]) ->
    add_kill_mon_num_hooking(SceneId, RoleId),
    add_kill_mon_num_hooking(SceneId, _AtterId, List).
add_kill_mon_num_hooking(SceneId, RoleId) ->
    IsInOutSide = lib_scene:is_outside_scene(SceneId),
    if
        IsInOutSide == true->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_enchantment_guard, add_wave, [1]);
        true ->
            ok
    end.


get_attr(PS) ->
    #player_status{enchantment_guard = #enchantment_guard{soap_status = #enchantment_soap_status{attr = Attr}}} = PS,
    Attr.


get_exp_attr_ratio(_, _) ->
    0.

is_enchantment_scene(SceneId) ->
    case data_enchantment_guard:get_value_by_key(0) of
        [SceneIdCfg] ->
            SceneId == SceneIdCfg;
        _ ->
            ok
    end.

%% 获取挂机系数
%% {经验系数, 金币系数}
get_afk_coe(PS) ->
    #player_status{enchantment_guard = #enchantment_guard{gate = Gate}} = PS,
    case data_enchantment_guard:get_boss(Gate) of
        #enchantment_guard_boss{exp_add = ExpCoe, coin_add = CoinCoe} ->
            {ExpCoe, CoinCoe};
        _ -> {0, 0}
    end.

sort_rank(RankL) ->
    F_sort = fun(A, B) ->
        #enchantment_role_rank{gate = GateA, last_time = TimeA} = A,
        #enchantment_role_rank{gate = GateB, last_time = TimeB} = B,
        if
            GateA > GateB -> true;
            GateA == GateB, TimeA < TimeB -> true;
            true -> false
        end
             end,
    SortRankL = lists:sublist(lists:sort(F_sort, RankL), ?RANK_LIMIT_NUM),
    set_list_rank(SortRankL).

set_list_rank(RankL) ->
    set_list_rank(RankL, 1, []).
set_list_rank([], _Index, Result) -> lists:reverse(Result);
set_list_rank([Item|H], Index, Result) ->
    NewItem = Item#enchantment_role_rank{rank = Index},
    set_list_rank(H, Index + 1, [NewItem|Result]).

%% 更新时间
gm_send_bgold(UpdateTime) ->
    Title = <<"【斩妖】奖励升级-绑玉补发"/utf8>>,
    Content = <<"尊敬的阴阳师您好，我们升级了斩妖关卡奖励，新增绑玉奖励，特为您补发之前通关关卡的累计的绑玉，请您查收，快来踏上奖励丰厚的斩妖之旅吧~"/utf8>>,
    %AfterTime = utime:unixdate() - 7 * ?ONE_DAY_SECONDS,
    Sql = io_lib:format(<<"select e.player_id, s.career, e.gate from player_low as s inner join player_enchantment_guard
     as e on (e.player_id = s.id) where e.gate != 0 and e.player_id in (select distinct l.player_id from log_login as l
     where l.time > ~p)">>, [UpdateTime - 7 * ?ONE_DAY_SECONDS]),
    List = db:get_all(Sql),
    F_reward = fun(Gate, {Career, AccReward}) ->
        case data_enchantment_guard:get_boss(Gate) of
            #enchantment_guard_boss{goods_num = NumList, goods_pool = Pool,
                coin = Coin, start_gate = _StartGate,
                other_goods_pool = CfgOtherGoodsPool, other_reward_list = CareerReward} ->
                RewardNum = case NumList of
                                [] ->
                                    0;
                                _ ->
                                    [{_RewardNum, _}] = find_ratio_list(NumList, 2, 1),
                                    _RewardNum
                            end,
                % 兼容按职业区分奖池和统一奖池
                case Pool of
                    [{_, _}|_] -> {_, Pool1} = ulists:keyfind(Career, 1, Pool, {Career, []});
                    _ -> Pool1 = Pool
                end,
                TempList = find_ratio_list(Pool1, 4, RewardNum),  %%抽奖，获取奖励列表
                RewardList1 = [{Type, GoodId, GoodNum} || {Type, GoodId, GoodNum, _} <- TempList], %%转换格式  通关奖励
                %%固定奖励 + 道具库抽奖
                {_, CfgOtherRewardList} = ulists:keyfind(Career, 1, CareerReward, {Career, []}),
                OtherReward = get_other_reward(CfgOtherRewardList, CfgOtherGoodsPool),
                %%金币随关数增加,经验同样
                RewardList     = [{?TYPE_COIN, 0, Coin}] ++ OtherReward ++ RewardList1,
                LastRewardList = [{GoodsType2, GoodsId2, Num2} ||{GoodsType2, GoodsId2, Num2} <-RewardList, Num2 =/= 0],
                {Career, [Item||{_, GoodsTypeId, _} = Item <-LastRewardList, GoodsTypeId == 36020001 orelse GoodsTypeId == 35] ++ AccReward};
            _ ->
                {Career, AccReward}
        end
    end,
    F_gate = fun(RoleId, Gate) ->
        case db:get_row(io_lib:format(<<"select gate from log_enchantment_guard_battle where role_id = ~p and time < ~p order by time desc limit 1">>, [RoleId, UpdateTime])) of
            [RealGate] -> min(Gate, RealGate);
            _ -> Gate
        end
    end,
    F_main = fun() -> [begin
         RealGate = F_gate(RoleId, Gate),
         case RealGate >= 1 of
             true ->
                 {_, Reward} = lists:foldl(F_reward, {Career, []}, lists:seq(1, RealGate)),
                 SendReward = lib_goods_api:make_reward_unique(Reward),
                 SendReward =/= [] andalso mod_mail_queue:add(133, [RoleId], Title, Content, SendReward, 1000),
                 timer:sleep(200);
             _ ->
                 skip
         end
     end||[RoleId, Career, Gate]<-List]
    end,
    spawn(F_main).
