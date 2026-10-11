%% ---------------------------------------------------------------------------
%% @doc pp_god_court

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/28
%% @deprecated  神庭
%% ---------------------------------------------------------------------------
-module(pp_god_court).

%% API
-compile([export_all]).

-include("server.hrl").
-include("common.hrl").
-include("god_court.hrl").
-include("errcode.hrl").

handle(Cmd, Ps, Data) ->
    case catch do_handle(Cmd, Ps, Data) of
        {'EXIT', Error} ->
            ?ERR("pp_god_court error: ~p~n", [Error]),
            skip;
        Return  ->
            Return
    end.

%% 神庭界面
do_handle(23301, Ps, []) ->
    #player_status{id = RoleId, god_court_status = GodCourtStatus, original_attr = OriginAttr} = Ps,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    ItemList =
        [begin
             #god_court_item{
                 court_id = CourtId,
                 is_active = IsActive,
                 lv = ItemLv,
                 sum_attr = SumAttr,
                 equip_list = EquipList,
                 suit_list = SuitList
             } = CourtItem,
             Power = lib_player:calc_partial_power(OriginAttr, 0, SumAttr),
             %% 没有装备的位置也弄下发给客户端信息
             #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
             Poss = ?GOD_POS_LIST ++ [CorePos],
             AllEquipList = [{Pos, 0, 0}||Pos <- Poss],
             F = fun({Pos, _, EquipId, Stage}, GrandList) -> lists:keystore(Pos, 1, GrandList, {Pos, EquipId, Stage}) end,
             NEquipList = lists:foldl(F, AllEquipList, EquipList),
             {CourtId, ItemLv, Power, SumAttr, IsActive, NEquipList, SuitList}
         end||CourtItem <- CourtList],
    {ok, BinData} = pt_233:write(23301, [ItemList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, Ps};

%% 神庭解锁
do_handle(23302, Ps, [CourtId]) ->
    case lib_god_court:unlock_court(Ps, CourtId) of
        {true, NewPs} ->
            {ok, BinData} = pt_233:write(23302, [?SUCCESS, CourtId, ?IS_ACTIVE]),
            lib_server_send:send_to_uid(Ps#player_status.id, BinData),
            send_23310(NewPs, CourtId),
            {ok,battle_attr, NewPs};
        {false, ErrorCode} ->
            send_error(Ps, ErrorCode),
            {ok, Ps}
    end;

%% 装备神庭
do_handle(23303, Ps, [CourtId, Pos, EquipId]) ->
    GoodStatus = lib_goods_do:get_goods_status(),
    case lib_god_court:equip(Ps, GoodStatus, CourtId, Pos, EquipId) of
        {true, NewPs} ->
            {ok, BinData} = pt_233:write(23303, [?SUCCESS, CourtId, Pos, EquipId]),
            lib_server_send:send_to_uid(Ps#player_status.id, BinData),
            send_23310(NewPs, CourtId),
            {ok,battle_attr, NewPs};
        {false, ErrorCode} ->
            send_error(Ps, ErrorCode),
            {ok, Ps}
    end;

%% 神庭装备升阶
do_handle(23304, Ps, [CourtId, Pos]) ->
    case lib_god_court:stage_up(Ps, CourtId, Pos) of
        {true, NewPs, Stage} ->
            {ok, BinData} = pt_233:write(23304, [?SUCCESS, CourtId, Pos, Stage]),
            lib_server_send:send_to_uid(Ps#player_status.id, BinData),
            send_23310(NewPs, CourtId),
            {ok,battle_attr, NewPs};
        {false, ErrorCode} ->
            send_error(Ps, ErrorCode),
            {ok, Ps}
    end;

%% 神庭强化
do_handle(23305, Ps, [CourtId]) ->
    case lib_god_court:lv_up(Ps, CourtId) of
        {true, NewPs, Lv} ->
            {ok, BinData} = pt_233:write(23305, [?SUCCESS, CourtId, Lv]),
            lib_server_send:send_to_uid(Ps#player_status.id, BinData),
            send_23310(NewPs, CourtId),
            {ok,battle_attr, NewPs};
        {false, ErrorCode} ->
            send_error(Ps, ErrorCode),
            {ok, Ps}
    end;

%% 神之所界面
do_handle(23306, Ps, []) ->
    #player_status{id = RoleId, god_court_status = GodCourtStatus} = Ps,
    #god_house_status{
        lv = Lv,
        exp = Exp,
        sum_num = SumNum,
        daily_num = DailyNum,
        crystal_color = CrystalColor,
        grand_status = GrandStatus
    } = GodCourtStatus#god_court_status.house_status,
%%    ?PRINT("SumNum, CrystalColor, DailyNum, Lv, Exp, GrandStatus ~p ~n", [[SumNum, CrystalColor, DailyNum, Lv, Exp, GrandStatus]]),
    LvList = data_god_court:get_house_reward_lvs(),
    {RewardLv, _} = lib_god_court:get_reward_pool(SumNum, LvList),
    {ok, BinData} = pt_233:write(23306, [RewardLv, SumNum, CrystalColor, DailyNum, Lv, Exp, GrandStatus]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, Ps};

%% 提升水晶品质(生橙)
do_handle(23307, Ps, []) ->
    case lib_god_court:house_up_origin(Ps) of
        {true, NewPs} ->
            #god_court_status{house_status = HouseStatus} = NewPs#player_status.god_court_status,
            #god_house_status{
                sum_num = SumNum,
                crystal_color = Color,
                daily_num = DailyNum,
                grand_status = GrandStatus
            } = HouseStatus,
            LvList = data_god_court:get_house_reward_lvs(),
            {RewardLv, _} = lib_god_court:get_reward_pool(SumNum, LvList),
            {ok, BinData} = pt_233:write(23307, [?SUCCESS, RewardLv, SumNum, Color, DailyNum, GrandStatus]),
            lib_server_send:send_to_uid(Ps#player_status.id, BinData),
            {ok, NewPs};
        {false, ErrorCode} ->
            send_error(Ps, ErrorCode),
            {ok, Ps}
    end;

%% 开水晶（抽奖）
do_handle(23308, Ps, []) ->
    case lib_god_court:open_crystal(Ps) of
        {true, NewPs, NewHouseStatus, RewardList} ->
            #god_house_status{
                crystal_color = Color,
                lv = HouseLv,
                exp = HouseExp
            } = NewHouseStatus,
            {ok, BinData} = pt_233:write(23308, [?SUCCESS, Color, HouseLv, HouseExp, RewardList]),
%%            ?PRINT("@@@@@@@@@@@@@@Color, HouseLv, HouseExp, RewardList ~p ~n", [[Color, HouseLv, HouseExp, RewardList]]),
            lib_server_send:send_to_uid(NewPs#player_status.id, BinData),
            {ok, NewPs};
        {false, ErrorCode} ->
            send_error(Ps, ErrorCode),
            {ok, Ps}
    end;

%% 领取累计奖励（还是抽奖励）
do_handle(23309, Ps, [Times]) ->
    case lib_god_court:get_grand_origin_reward(Ps, Times) of
        {true, NewPs, RewardList} ->
            {ok, BinData} = pt_233:write(23309, [?SUCCESS, RewardList]),
            lib_server_send:send_to_uid(NewPs#player_status.id, BinData),
            do_handle(23306, NewPs, []),
            {ok, NewPs};
        {false, ErrorCode} ->
            send_error(Ps, ErrorCode),
            {ok, Ps}
    end;

do_handle(_Cmd, Ps, _Data) ->
    ?ERR("cmd error, cmd :~p ~n data : ~p ~n", [_Cmd, _Data]),
    {ok, Ps}.

send_error(Ps, ErrorCode) ->
    ?PRINT("ErrorCode ~p ~n", [ErrorCode]),
    {CodeInt, CodeArgs} = util:parse_error_code(ErrorCode),
    {ok, BinData} = pt_233:write(23300, [CodeInt, CodeArgs]),
    lib_server_send:send_to_uid(Ps#player_status.id, BinData).

%% 每次对神庭解锁，升级，装备，或者升阶都要调用该函数
%% 通知客户端当前神庭的变化
send_23310(Ps, CourtId) ->
    #player_status{id = RoleId, god_court_status = GodCourtStatus, original_attr = OriginAttr} = Ps,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    case lists:keyfind(CourtId, #god_court_item.court_id, CourtList) of
        false -> skip;
        CourtItem ->
            #god_court_item{
                court_id = CourtId,
                is_active = IsActive,
                lv = ItemLv,
                sum_attr = SumAttr,
                equip_list = EquipList,
                suit_list = SuitList
            } = CourtItem,
            Power = lib_player:calc_partial_power(OriginAttr, 0, SumAttr),
            #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
            %% 没有装备的位置也弄下发给客户端信息
            Poss = ?GOD_POS_LIST ++ [CorePos],
            AllEquipList = [{Pos, 0, 0}||Pos <- Poss],
            F = fun({Pos, _, EquipId, Stage}, GrandList) -> lists:keystore(Pos, 1, GrandList, {Pos, EquipId, Stage}) end,
            NEquipList = lists:foldl(F, AllEquipList, EquipList),
            {ok, BinData} = pt_233:write(23310, [CourtId, ItemLv, Power, SumAttr, IsActive, NEquipList, SuitList]),
%%            ?PRINT("CourtItem ~p ~n", [{CourtId, ItemLv, Power, SumAttr, IsActive, NEquipList, SuitList}]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.
