%%%--------------------------------------
%%% @Module  : lib_marriage_wedding
%%% @Author  : huyihao
%%% @Created : 2017.12.6
%%% @Description:  婚姻婚礼
%%%--------------------------------------

-module (lib_marriage_wedding).

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("marriage.hrl").
-include("figure.hrl").
-include("relationship.hrl").
-include("language.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("custom_act.hrl").
-include("chat.hrl").
-include("role.hrl").

-export ([
    check_wedding_order/4,
    return_wedding_order_cost/3,
    get_next_wedding_start_time_id/2,
    sql_wedding_order/1,
    set_wedding_pid_and_state/8,
    delete_wedding_order/2,
    invited_list/3,
    send_invited_list/1,
    %open_invite_guest/2,
    %open_ask_invite/3,
    reconnect/2,
    creat_mon/2,
    kill_trouble_maker_solve/1,
    wedding_end_quit/1,
    get_anime_info/6,
    get_mon_id_num/1,
    wedding_aura_send_reward/7,
    wedding_aura_send_reward_1/5,
    get_guest_send_list/3,
    wedding_order_success/4,
    %wedding_fail/4,
    wedding_danmu/3,
    add_aura/7,
    add_exp/4,
    logout_quit_wedding/1,
    get_wedding_card_cost_list/1,
    collect_mon/4,
    collect_mon_player/2,
    check_collect_mon_candies/3,
    update_wedding_collect_checker/2,
    send_wedding_info/1,
    send_wedding_info/2,
    wedding_break_off/3,
    sql_update_wedding_order/2,
    check_wedding_order_times/2,
    delete_wedding_order_by_ids/2,
    push_wedding_info_aura/1,
    quit_wedding/1
]).

check_wedding_order(RoleId, DayId, TimeId, WeddingOrderList) ->
    TodayDateTime = utime:unixdate(),
    UseDateTime = TodayDateTime+(DayId-1)*24*60*60,
    WeddingOrderInfoM = lists:keyfind(RoleId, #wedding_order_info.role_id_m, WeddingOrderList),
    WeddingOrderInfoW = lists:keyfind(RoleId, #wedding_order_info.role_id_w, WeddingOrderList),
    WeddingOrderInfo = case WeddingOrderInfoM of
        false ->
            case WeddingOrderInfoW of
                false ->
                    false;
                _ ->
                    WeddingOrderInfoW
            end;
        _ ->
            WeddingOrderInfoM
    end,
    case WeddingOrderInfo of
        false ->
            Code1 = 1;
        _ ->
            Code1 = 3
            % #wedding_order_info{
            %     order_unix_date = OrderUnixDate,
            %     time_id = OrderTimeId,
            %     propose_role_id = ProposeRoleId
            % } = WeddingOrderInfo,
            % case OrderUnixDate =:= UseDateTime andalso OrderTimeId =:= TimeId of
            %     true ->
            %         Code1 = 2;
            %     false ->
            %         case RoleId of
            %             ProposeRoleId ->
            %                 Code1 = 1;
            %             _ ->
            %                 Code1 = 3
            %         end
            % end
    end,
    case Code1 of
        3 ->
            {false, ?ERRCODE(err172_wedding_can_not_open_order)};
        2 ->
            {false, ?ERRCODE(err172_wedding_can_not_order_same)};
        _ ->
            F1 = fun(WeddingOrderInfo1, UseDateList1) ->
                #wedding_order_info{
                    order_unix_date = OrderUnixDate1,
                    time_id = OrderTimeId1
                } = WeddingOrderInfo1,
                case OrderUnixDate1 =:= UseDateTime andalso OrderTimeId1 =:= TimeId of
                    true ->
                        [WeddingOrderInfo1|UseDateList1];
                    false ->
                        UseDateList1
                end
            end,
            UseDateList = lists:foldl(F1, [], WeddingOrderList),
            case UseDateList of
                [] ->
                    true;
                _ ->
                    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_WED_RANK) of
                        true ->
                            true;
                        false ->
                            {false, ?ERRCODE(err172_wedding_time_have_order)}
                    end
            end
    end.

return_wedding_order_cost(RoleId, GoodsTypeId, NowWeddingState) ->
    case NowWeddingState of
        1 ->
            CostList = get_wedding_card_cost_list(GoodsTypeId),
            Title   = ?LAN_MSG(?LAN_TITLE_WEDDING_ORDER_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_WEDDING_ORDER_RETURN),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, CostList);
        _ ->
            skip
    end.

get_wedding_card_cost_list(GoodsTypeId) ->
    WeddingCardCon = data_wedding:get_wedding_card_con(GoodsTypeId),
    #wedding_card_con{
        goods_num = GoodsNum,
        cost_list = MoneyConList
    } = WeddingCardCon,
    case GoodsNum of
        0 ->
            GoodsList = [];
        _ ->
            GoodsList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}]
    end,
    case MoneyConList of
        [] ->
            MoneyList = [];
        [{MoneyType, MoneyId, MoneyNum}|_] ->
            Discount = lib_flower_act_api:get_wedding_discount(),
            NewCost = round(MoneyNum*Discount/100),
            MoneyList = [{MoneyType, MoneyId, NewCost}]
    end,
    CostList = GoodsList ++ MoneyList,
    CostList.

get_next_wedding_start_time_id([T|G], NowTime) ->
    WeddingTimeCon = data_wedding:get_wedding_time_con(T),
    #wedding_time_con{
        begin_time = {BeginHour, BeginMinute}
    } = WeddingTimeCon,
    StartPreTime = ?WeddingStartPreTime,
    _BeginTime = utime:unixdate() + BeginHour*60*60+BeginMinute*60,
    %% 夏冬令时的转换
    UseDateTime = utime:unixdate(_BeginTime),
    BeginTime = UseDateTime + BeginHour*60*60 + BeginMinute*60,
    BeginTimePre = BeginTime - StartPreTime,
    case NowTime =< BeginTime of
        false ->
            get_next_wedding_start_time_id(G, NowTime);
        true ->
            ?IF(NowTime > BeginTimePre, NowTime, BeginTimePre)
    end;
get_next_wedding_start_time_id([], _NowTime) ->
    % WeddingTimeIdList = data_wedding:get_wedding_time_id_list(),
    % TimeId = lists:min(WeddingTimeIdList),
    % WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
    % #wedding_time_con{
    %     begin_time = {BeginHour, BeginMinute}
    % } = WeddingTimeCon,
    % BeginTime = utime:unixdate()+24*60*60+BeginHour*60*60+BeginMinute*60,
    utime:unixdate()+24*60*60.

%% 储存预约信息（不包括宾客
sql_wedding_order(NewWeddingOrderInfo) ->
    #wedding_order_info{
        id = Id,
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        wedding_type = WeddingType,
        order_unix_date = UseDateTime,
        time_id = TimeId,
        guest_num_max = GuestnumMax,
        propose_role_id = ProposeRoleId,
        invited_num = InvitedNum,
        others = Others
    } = NewWeddingOrderInfo,
    ReSql = io_lib:format(?ReplaceMWeddingOrderInfoSql, [
        Id, RoleIdM, RoleIdW, WeddingType, UseDateTime, TimeId, GuestnumMax, ProposeRoleId, InvitedNum, util:term_to_bitstring(Others)
    ]),
    db:execute(ReSql).

sql_update_wedding_order(Columns, Condition) ->
    Sql = usql:update(marriage_wedding_order_info, Columns, Condition),
    db:execute(Sql).

set_wedding_pid_and_state(Ps, LoverRoleId, WeddingPid, NowWeddingState, MarriageTime, LoveNum, LoveGiftS, LoveGiftO) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        combat_power = CombatPower,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        type = MarriageType
    } = MarriageStatus,
    NewMarriageStatus = MarriageStatus#marriage_status{
        wedding_pid = WeddingPid,
        now_wedding_state = NowWeddingState,
        love_gift_time_s = LoveGiftS,
        love_gift_time_o = LoveGiftO
    },
    NewPs = Ps#player_status{
        marriage = NewMarriageStatus
    },
    {ok, Bin} = pt_172:write(17232, [?SUCCESS, RoleId, CombatPower, Figure, MarriageType, NowWeddingState, MarriageTime, LoveNum, 1]),
    lib_server_send:send_to_uid(LoverRoleId, Bin),
    NewPs.

delete_wedding_order(WeddingOrderList, RoleIdMList) ->
    F = fun(RoleIdM, NewWeddingOrderList1) ->
        lists:keydelete(RoleIdM, #wedding_order_info.role_id_m, NewWeddingOrderList1)
    end,
    NewWeddingOrderList = lists:foldl(F, WeddingOrderList, RoleIdMList),
    DeleteListStr = ulists:list_to_string(RoleIdMList, ","),
    ReSql = io_lib:format(?DelectMWeddingOrderInfoAllSql, [DeleteListStr]),
    db:execute(ReSql),
    ReSql1 = io_lib:format(?DelectMWeddingGuestInfoAllSql, [DeleteListStr]),
    db:execute(ReSql1),
    NewWeddingOrderList.

delete_wedding_order_by_ids(WeddingOrderList, IdList) ->
    F = fun(Id, NewWeddingOrderList1) ->
        lists:keydelete(Id, #wedding_order_info.id, NewWeddingOrderList1)
    end,
    NewWeddingOrderList = lists:foldl(F, WeddingOrderList, IdList),
    DeleteListStr = ulists:list_to_string(IdList, ","),
    ReSql = io_lib:format(?DelectMWeddingOrderInfoAllSql2, [DeleteListStr]),
    db:execute(ReSql),
    ReSql1 = io_lib:format(?DelectMWeddingGuestInfoAllSql2, [DeleteListStr]),
    db:execute(ReSql1),
    NewWeddingOrderList.

invited_list([T|G], RoleId, InvitedList) ->
    #wedding_order_info{
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        wedding_type = WeddingType,
        order_unix_date = OrderUnixDate,
        time_id = TimeId,
        guest_list = GuestList
    } = T,
    case lists:keyfind(RoleId, #wedding_guest_info.role_id, GuestList) of
        false ->
            invited_list(G, RoleId, InvitedList);
        #wedding_guest_info{answer_type = AnswerType} ->
            OrderSendInfo = {RoleIdM, RoleIdW, WeddingType, OrderUnixDate, TimeId, AnswerType},
            invited_list(G, RoleId, [OrderSendInfo|InvitedList])
    end;
invited_list([], _RoleId, InvitedList) ->
    InvitedList.

send_invited_list(InvitedInfoList) ->
    F = fun({RoleId, InvitedList}) ->
        F1 = fun(OrderSendInfo, SendList1) ->
            {RoleIdM, RoleIdW, WeddingType, OrderUnixDate, TimeId, AnswerType} = OrderSendInfo,
            RoleShowM = lib_role:get_role_show(RoleIdM),
            RoleShowW = lib_role:get_role_show(RoleIdW),
            #ets_role_show{
                combat_power = CombatPowerM,
                figure = FigureM
            } = RoleShowM,
            #figure{
                name = NameM,
                lv = LvM,
                sex = SexM,
                vip = VipM,
                career = CareerM,
                turn = TurnM
            } = FigureM,
            #ets_role_show{
                combat_power = CombatPowerW,
                figure = FigureW
            } = RoleShowW,
            #figure{
                name = NameW,
                lv = LvW,
                sex = SexW,
                vip = VipW,
                career = CareerW,
                turn = TurnW
            } = FigureW,
            WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
            #wedding_time_con{
                begin_time = {BeginHour, BeginMinute}
            } = WeddingTimeCon,
            BeginTime = OrderUnixDate+BeginHour*60*60+BeginMinute*60,
            ManSendInfoList = [{RoleIdM, NameM, LvM, CombatPowerM, SexM, VipM, CareerM, TurnM}],
            WomanSendInfoList = [{RoleIdW, NameW, LvW, CombatPowerW, SexW, VipW, CareerW, TurnW}],
            SendInfo = {WeddingType, BeginTime, AnswerType, ManSendInfoList, WomanSendInfoList},
            [SendInfo|SendList1]
        end,
        SendList = lists:foldl(F1, [], InvitedList),
        {ok, Bin} = pt_172:write(17254, [SendList]),
        lib_server_send:send_to_uid(RoleId, Bin)
    end,
    lists:map(F, InvitedInfoList).

% open_invite_guest(RoleId, Args) ->
%     [Code, LoverRoleId, WeddingType, WeddingTime, IfOrderAgain, GuestNumMax, GuestSendList1] = Args,
%     GuestSendList = [begin
%         GuestPs = lib_offline_api:get_player_info(GuestRoleId, all),
%         #player_status{
%             figure = Figure
%         } = GuestPs,
%         #figure{
%             name = GuestName
%         } = Figure,
%         {GuestRoleId, AnswerType, GuestName}
%     end||{GuestRoleId, AnswerType} <- GuestSendList1],
%     {ok, Bin} = pt_172:write(17252, [Code, LoverRoleId, WeddingType, WeddingTime, IfOrderAgain, GuestNumMax, GuestSendList]),
%     lib_server_send:send_to_uid(RoleId, Bin).

% open_ask_invite(RoleId, LessGuestNum, AskInviteList) ->
%     AskInviteSendList = [begin
%         AskPs = lib_offline_api:get_player_info(AskRoleId, all),
%         #player_status{
%             combat_power = CombatPower,
%             figure = Figure
%         } = AskPs,
%         #figure{
%             name = Name,
%             lv = Lv,
%             sex = Sex,
%             vip = Vip,
%             career = Career,
%             turn = Turn
%         } = Figure,
%         {AskRoleId, Name, Lv, CombatPower, Sex, Vip, Career, Turn}
%     end||AskRoleId <- AskInviteList],
%     {ok, Bin} = pt_172:write(17260, [?SUCCESS, LessGuestNum, AskInviteSendList]),
%     lib_server_send:send_to_uid(RoleId, Bin).

reconnect(Ps, _LoginType) ->
    #player_status{
        id = RoleId,
        sid = Sid,
        scene = SceneId,
        copy_id = RoleIdM,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        wedding_pid = _WeddingPid
    } = MarriageStatus,
    case SceneId =:= ?WeddingScene of
        true ->
            mod_marriage_wedding_mgr:enter_wedding_login([RoleIdM, RoleId, Sid]),
            {ok, Ps};
            % case misc:is_process_alive(WeddingPid) of
            %     false ->

            %         {ok, Ps};
            %     true ->
                    
            %         {ok, Ps}
            % end;
        false ->
            {next, Ps}
    end.

creat_mon(Type, RoleIdM) ->
    {_MonId, MonNum} = get_mon_id_num(Type),
    creat_mon_1(Type, RoleIdM, MonNum, []).

creat_mon_1(_Type, _RoleIdM, 0, _UseList) ->
    skip;
creat_mon_1(Type, RoleIdM, MonNum, UseList) ->
    {MonId, _MonNum} = get_mon_id_num(Type),
    PosIdList = data_wedding:get_type_pos_id_list(Type),
    PosIdList1 = PosIdList -- UseList,
    PosId = urand:list_rand(PosIdList1),
    PosCon = data_wedding:get_wedding_position(PosId),
    case PosCon of
        [] ->
            MonX = 1000,
            MonY = 1000;
        _ ->
            #wedding_position_con{
                x = MonX,
                y = MonY
            } = PosCon
    end,
    lib_mon:async_create_mon(MonId, ?WeddingScene, 0, MonX, MonY, 0, RoleIdM, 1, []),
    case lists:member(Type, [1, 4, 5, 6]) of
        true ->
            creat_mon_1(Type, RoleIdM, MonNum-1, [PosId|UseList]);
        false ->
            creat_mon_1(Type, RoleIdM, MonNum-1, UseList)
    end.

get_mon_id_num(Type) ->
    case Type of
        1 -> %% 捣蛋鬼
            MonIdList = data_wedding:get_trouble_maker_list(),
            MonId = urand:list_rand(MonIdList),
            MonNum = ?WeddingTroubleMakerNum;
        2 -> %% 普通糖果
            MonId = ?WeddingNormalCandies,
            WeddingCandiesCon = data_wedding:get_wedding_candies_con(MonId),
            #wedding_candies_con{
                candies_num = MonNum
            } = WeddingCandiesCon;
        3 -> %% 高级糖果
            MonId = ?WeddingSpecialCandies,
            WeddingCandiesCon = data_wedding:get_wedding_candies_con(MonId),
            #wedding_candies_con{
                candies_num = MonNum
            } = WeddingCandiesCon;
        4 -> %% 中级餐桌
            MonId = ?WeddingTable1,
            WeddingTableCon = data_wedding:get_wedding_table_con(MonId),
            #wedding_table_con{
                table_num = MonNum
            } = WeddingTableCon;
        5 -> %% 高级餐桌
            MonId = ?WeddingTable2,
            WeddingTableCon = data_wedding:get_wedding_table_con(MonId),
            #wedding_table_con{
                table_num = MonNum
            } = WeddingTableCon;
        _ -> %% 低级餐桌
            MonId = ?WeddingTable3,
            WeddingTableCon = data_wedding:get_wedding_table_con(MonId),
            #wedding_table_con{
                table_num = MonNum
            } = WeddingTableCon
    end,
    {MonId, MonNum}.

kill_trouble_maker_solve(Args) ->
    [RoleIdM, BroadCast, MonOnlyId, WeddingPid, SolveId, RoleId] = Args,
    case lib_scene_object_agent:get_object(MonOnlyId) of
        [] ->
            {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_mon_not_exist), ""]),
            lib_server_send:send_to_uid(RoleId, Bin);
        MonObject ->
            #scene_object{
                aid = AId,
                scene = SceneId,
                copy_id = CopyId,
                mon = Mon
            } = MonObject,
            WeddingScene = ?WeddingScene,
            if
                is_record(Mon, scene_mon) =:= false ->
                    {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_scene_mon), ""]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                SceneId =/= WeddingScene ->
                    {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_mon_not_in_scene), ""]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                CopyId =/= RoleIdM ->
                    {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_mon_not_in_scene), ""]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    ConId = Mon#scene_mon.mid,
                    case data_wedding:get_wedding_trouble_maker_con(ConId) of
                        [] ->
                            {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_scene_mon), ""]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        TroubleMakerCon ->
                            #wedding_trouble_maker_con{
                                trouble_maker_name = TMName,
                                solve_name = SolveName
                            } = TroubleMakerCon,
                            case ConId of
                                SolveId ->
                                    case data_wedding:get_wedding_trouble_maker_con(ConId) of
                                        [] ->
                                            {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_scene_mon), ""]),
                                            lib_server_send:send_to_uid(RoleId, Bin);
                                        _ ->
                                            AId ! {'stop', BroadCast},
                                            gen_server:cast(WeddingPid, {kill_trouble_maker_solve_success, RoleId, ConId})
                                    end;
                                _ ->
                                    {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_not_have_solve), [SolveName, TMName]}),
                                    {ok, Bin} = pt_172:write(17269, [CodeInt, CodeArgs]),
                                    lib_server_send:send_to_uid(RoleId, Bin)
                            end
                    end
            end
    end.

wedding_order_success(RoleId, OtherRid, WeddingTime, WeddingType) ->
    #ets_role_show{figure = Figure, combat_power = CombatPower} = lib_role:get_role_show(RoleId),
    #ets_role_show{figure = OtherFigure, combat_power = OtherCombatPower} = lib_role:get_role_show(OtherRid),
    #figure{
        name = Name,
        lv = Lv,
        sex = Sex,
        vip = Vip,
        career = Career,
        turn = Turn
    } = Figure,
    #figure{
        name = OtherName,
        lv = OtherLv,
        sex = OtherSex,
        vip = OtherVip,
        career = OtherCareer,
        turn = OtherTurn
    } = OtherFigure,
    case WeddingType == 3 of 
        true -> %% 类型3的婚宴每天只能预约一次
            UseDateTime = utime:unixdate(WeddingTime),
            mod_daily:increment_offline(RoleId, ?MOD_MARRIAGE, 7, UseDateTime),
            mod_daily:increment_offline(OtherRid, ?MOD_MARRIAGE, 7, UseDateTime);
        _ -> ok
    end,
    SelfInfo = [{RoleId, Name, Lv, CombatPower, Sex, Vip, Career, Turn}],
    OtherInfo = [{OtherRid, OtherName, OtherLv, OtherCombatPower, OtherSex, OtherVip, OtherCareer, OtherTurn}],
    {{_Y, Mon, D}, {H, M, _S}} = utime:unixtime_to_localtime(WeddingTime),
    %% 自己的邮件
    Title = utext:get(1720020),
    Content = utext:get(1720021, [Mon, D, H, M]),
    lib_mail_api:send_sys_mail([RoleId, OtherRid], Title, Content, []),
    %% 朋友和公会邮件
    Content1 = utext:get(1720023, [Name, Mon, D, H, M]),
    Content2 = utext:get(1720023, [OtherName, Mon, D, H, M]),
    Content3 = utext:get(1720024, [Name, Mon, D, H, M]),
    Content4 = utext:get(1720024, [OtherName, Mon, D, H, M]),
    %% 预约方的好友邮件/公会
    RelaList = lib_relationship:get_rela_on_db_2(RoleId),
    FriendsList = [FrId || #rela{other_rid = FrId, rela_type = RelaType} <- RelaList, RelaType == ?RELA_TYPE_FRIEND, FrId =/= OtherRid],
    lib_mail_api:send_sys_mail(FriendsList, Title, Content1, []),
    %% 对方的好友邮件/公会
    OtherRelaList = lib_relationship:get_rela_on_db_2(OtherRid),
    OtherFriendsList = [FrId || #rela{other_rid = FrId, rela_type = RelaType} <- OtherRelaList, RelaType == ?RELA_TYPE_FRIEND, FrId =/= RoleId],
    NewOtherFriendsList = [FrId || FrId <- OtherFriendsList, lists:member(FrId, FriendsList) == false],
    lib_mail_api:send_sys_mail(NewOtherFriendsList, Title, Content2, []),
    %% 公会邮件
    ExcluList = [RoleId, OtherRid] ++ FriendsList ++ NewOtherFriendsList,
    mod_guild:send_guild_mail_by_role_id(RoleId, Title, Content3, [], ExcluList),
    mod_guild:send_guild_mail_by_role_id(OtherRid, Title, Content4, [], ExcluList),
    {ok, Bin} = pt_172:write(17251, [?SUCCESS, WeddingTime, WeddingType, SelfInfo, OtherInfo]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, Bin1} = pt_172:write(17251, [?ERRCODE(err172_wedding_order_success), WeddingTime, WeddingType, SelfInfo, OtherInfo]),
    lib_server_send:send_to_uid(OtherRid, Bin1).

get_anime_info(RoleId, RoleIdM, FigureM, RoleIdW, FigureW, GuestSendList) ->
    {ok, Bin} = pt_172:write(17262, [?SUCCESS, [{RoleIdM, FigureM}], [{RoleIdW, FigureW}], GuestSendList]),
    case RoleId of
        0 ->
            lib_server_send:send_to_scene(?WeddingScene, 0, RoleIdM, Bin);
        _ ->
            lib_server_send:send_to_uid(RoleId, Bin)
    end.

wedding_end_quit(Ps) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        old_scene_info = OldSceneInfo,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case SceneId =:= ?WeddingScene of
        true ->
            case OldSceneInfo of
                undefined ->
                    [OldScene, OldX, OldY] = lib_scene:get_outside_scene_by_lv(Lv),
                    OldScenePooldId = 0,
                    OldCopyId = 0;
                {OldScene, OldScenePooldId, OldCopyId, OldX, OldY} ->
                    skip
            end,
            FashionModelList = lib_fashion:get_equip_fashion_list_ps(Ps),
            NewPs = lib_scene:change_scene(Ps, OldScene, OldScenePooldId, OldCopyId, OldX, OldY, false, [{action_free, ?ERRCODE(err172_in_wedding_scene)}, {collect_checker, undefined}, {fashion_replace, FashionModelList}]),
            {ok, Bin} = pt_172:write(17273, [?SUCCESS]),
            lib_server_send:send_to_uid(RoleId, Bin);
        false ->
            NewPs = Ps
    end,
    NewPs.

quit_wedding(Ps) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        old_scene_info = OldSceneInfo,
        copy_id = RoleIdM,
        figure = #figure{lv = Lv}
    } = Ps,
    case SceneId =:= ?WeddingScene of
        true ->
            mod_marriage_wedding_mgr:quit_wedding(RoleId, RoleIdM),
            case OldSceneInfo of
                undefined ->
                    [OldScene, OldX, OldY] = lib_scene:get_outside_scene_by_lv(Lv),
                    OldScenePooldId = 0,
                    OldCopyId = 0;
                {OldScene1, OldScenePooldId1, OldCopyId1, OldX1, OldY1} ->
                    case OldScene1 =:= ?WeddingScene of
                        true ->
                            [OldScene, OldX, OldY] = lib_scene:get_outside_scene_by_lv(Lv),
                            OldScenePooldId = 0,
                            OldCopyId = 0;
                        false ->
                            OldScene = OldScene1,
                            OldScenePooldId = OldScenePooldId1,
                            OldCopyId = OldCopyId1,
                            OldX = OldX1,
                            OldY = OldY1
                    end
            end,
            FashionModelList = lib_fashion:get_equip_fashion_list_ps(Ps),
            lib_scene:change_scene(Ps, OldScene, OldScenePooldId, OldCopyId, OldX, OldY, false, [{action_free, ?ERRCODE(err172_in_wedding_scene)}, {collect_checker, undefined}, {fashion_replace, FashionModelList}]);
        false ->
            Ps
    end.

get_guest_send_list(RoleIdM, RoleIdW, EnterMemberList) ->
    EnterMemberList1 = lists:keysort(#wedding_enter_member_info.pos_id, EnterMemberList),
    F = fun(EnterMemberInfo, {Pos, GuestSendList1}) ->
        #wedding_enter_member_info{
            role_id = GuestRoleId,
            if_enter = IfEnter
        } = EnterMemberInfo,
        case lists:member(GuestRoleId, [RoleIdM, RoleIdW]) of
            true ->
                {Pos, GuestSendList1};
            _ ->
                {Pos+1, [{Pos, GuestRoleId, IfEnter}|GuestSendList1]}
        end
    end,
    {_PosNum, GuestSendList} = lists:foldl(F, {1, []}, EnterMemberList1),
    GuestSendList.

% wedding_fail(ProposeRoleId, RoleIdM, RoleIdW, WeddingType) ->
%     case data_wedding:get_wedding_info_con(WeddingType) of
%         [] ->
%             skip;
%         WeddingInfoCon ->
%             case ProposeRoleId of
%                 RoleIdM ->
%                     LoverRoleId = RoleIdW;
%                 _ ->
%                     LoverRoleId = RoleIdM
%             end,
%             LoverPs = lib_offline_api:get_player_info(LoverRoleId, all),
%             #player_status{
%                 figure = Figure
%             } = LoverPs,
%             #figure{
%                 name = Name
%             } = Figure,
%             #wedding_info_con{
%                 wedding_name = WeddingName,
%                 wedding_fail_return = _WeddingFailReturnList
%             } = WeddingInfoCon,
%             Title   = ?LAN_MSG(?LAN_TITLE_WEDDING_FAIL),
%             Content = utext:get(?LAN_CONTENT_WEDDING_FAIL, [Name, WeddingName]),
%             lib_mail_api:send_sys_mail([ProposeRoleId], Title, Content, WeddingFailReturnList)
%     end.

wedding_danmu(Ps, Msg, TkTime) ->
    case pp_chat:handle(11001, Ps, [?CHAT_CHANNEL_SCENE, "", "", 0, Msg, [], TkTime, "ticket"]) of
        {ok, NewPs} ->
            {ok, Bin} = pt_172:write(17270, [?SUCCESS]),
            lib_server_send:send_to_uid(Ps#player_status.id, Bin),
            NewPs;
        _Err ->
            {ok, Bin} = pt_172:write(17270, [?FAIL]),
            lib_server_send:send_to_uid(Ps#player_status.id, Bin),
            Ps
    end.

add_aura(Aura, 0, _RoleIdM, _FigureM, _RoleIdW, _FigureW, _MemberList) ->
    Aura;
add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, MemberList) ->
    NewAura = Aura + AddAura,
    AuraIdList = data_wedding:get_wedding_aura_id_list(),
    add_aura_send_reward(AuraIdList, Aura, NewAura, RoleIdM, FigureM, RoleIdW, FigureW, MemberList),
    NewAura.

add_aura_send_reward([T|G], Aura, NewAura, RoleIdM, FigureM, RoleIdW, FigureW, MemberList) ->
    AuraCon = data_wedding:get_wedding_aura_con(T),
    #wedding_aura_con{
        aura_num = ConAura,
        reward_list = RewardList
    } = AuraCon,
    case Aura < ConAura andalso NewAura >= ConAura of
        true ->
            MemberIdList = [MemBerRoleId||#wedding_enter_member_info{role_id = MemBerRoleId, if_enter = IfEnter} <- MemberList, IfEnter =/= 0],
            wedding_aura_send_reward(RoleIdM, FigureM, RoleIdW, FigureW, MemberIdList, RewardList, ConAura);
            %lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 15, [ConAura]);
        false ->
            add_aura_send_reward(G, Aura, NewAura, RoleIdM, FigureM, RoleIdW, FigureW, MemberList)
    end;
add_aura_send_reward([], _Aura, _NewAura, _RoleIdM, _FigureM, _RoleIdW, _FigureW, _MemberList) ->
    skip.

wedding_aura_send_reward(_RoleIdM, FigureM, _RoleIdW, FigureW, MemberIdList, RewardList, ConAura) ->
    #figure{
        name = NameM
    } = FigureM,
    #figure{
        name = NameW
    } = FigureW,
    F = fun(MemberRoleId) ->
        lib_player:apply_cast(MemberRoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, wedding_aura_send_reward_1, [NameM, NameW, RewardList, ConAura])
    end,
    lists:map(F, MemberIdList).

wedding_aura_send_reward_1(Ps, NameM, NameW, RewardList, ConAura) ->
    #player_status{
        id = RoleId,
        sid = Sid
    } = Ps,
    lib_server_send:send_to_sid(Sid, pt_172, 17278, [ConAura, RewardList]),
    case lib_goods_api:can_give_goods(Ps, RewardList) of
        true ->
            NewPs = lib_goods_api:send_reward(Ps, RewardList, wedding_aura, 0, 1);
        _ ->
            NewPs = Ps,
            Title   = ?LAN_MSG(?LAN_TITLE_WEDDING_AURA),
            Content = utext:get(?LAN_CONTENT_WEDDING_AURA, [NameM, NameW]),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList)
    end,
    NewPs.

add_exp(Ps, WeddingPid, WeddingType, EnterNum) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    %ExpNum = data_wedding:get_exp_by_lv(Lv),
    case data_wedding:get_wedding_info_con(WeddingType) of 
        #wedding_info_con{exp_coefficient = ExpCoefWedding} -> ok;
        _ -> ExpCoefWedding = 750
    end,
    ExpNum = 500000 * math:pow(1.5, (Lv-60)/120) * (ExpCoefWedding/1000),
    [_, ExpCoef] = data_wedding:get_wedding_aura_and_exp(WeddingType, EnterNum),
    NewExpNum = round(ExpNum * ExpCoef/1000),
    NewPs = lib_player:add_exp(Ps, NewExpNum),
    gen_server:cast(WeddingPid, {wedding_exp_success, RoleId, NewExpNum}),
    NewPs.

logout_quit_wedding(Ps) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = RoleIdM
    } = Ps,
    case SceneId =:= ?WeddingScene of
        true ->
            mod_marriage_wedding_mgr:quit_wedding(RoleId, RoleIdM);
        false ->
            skip
    end.

collect_mon(CollectorId, MonOnlyId, Mid, CopyId) ->
    CandiesList = data_wedding:get_wedding_candies_list(),
    TableList = data_wedding:get_wedding_table_id_list(),
    case lists:member(Mid, TableList) of
        false ->
            case lists:member(Mid, CandiesList) of
                false ->
                    Type = 0,
                    AddAura = 0;
                true ->
                    case Mid =:= ?WeddingNormalCandies of
                        true ->
                            Type = 2,
                            AddAura = 0;
                        false ->
                            Type = 3,
                            AddAura = 0
                    end
            end;
        true ->
            Type = 1,
            TableCon = data_wedding:get_wedding_table_con(Mid),
            #wedding_table_con{
                aura = AddAura
            } = TableCon
    end,
    case Type of
        0 ->
            skip;
        _ ->
            mod_marriage_wedding_mgr:collect_mon(CollectorId, MonOnlyId, Mid, CopyId, AddAura, Type)
    end.

collect_mon_player(Ps, Args) ->
    #player_status{
        id = RoleId
    } = Ps,
    [MonOnlyId, Mid, AddAura, Type, WeddingPid] = Args,
    case Type of
        1 ->
            ProduceType = eat_wedding_food,
            TableCon = data_wedding:get_wedding_table_con(Mid),
            #wedding_table_con{
                reward_list = RewardList1
            } = TableCon,
            RewardList = RewardList1;%urand:rand_with_weight(RewardList1);
        _ ->
            ProduceType = eat_wedding_candies,
            CandiesCon = data_wedding:get_wedding_candies_con(Mid),
            #wedding_candies_con{
                reward_list = RewardList
            } = CandiesCon
    end,
    case lib_goods_api:can_give_goods(Ps, RewardList) of
        {false, ErrorCode} ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17271, [ErrorCode, "", Type]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            {ok, Bin} = pt_172:write(17279, [Type, RewardList]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPs = lib_goods_api:send_reward(Ps, RewardList, ProduceType, 0, 3),
            gen_server:cast(WeddingPid, {collect_mon_success, RoleId, AddAura, Type, MonOnlyId, Mid})
    end,
    NewPs.

check_collect_mon_candies(_MonId, MonConId, Args) ->
    CandiesList = data_wedding:get_wedding_candies_list(),
    case lists:member(MonConId, CandiesList) of
        false ->
            true;
        true ->
            {NormalCandisNum, SpecialCandiesNum} = Args,
            case MonConId =:= ?WeddingNormalCandies of
                true ->
                    CandisNum = NormalCandisNum,
                    Code = 16;
                false ->
                    CandisNum = SpecialCandiesNum,
                    Code = 17
            end,
            CandiesCon = data_wedding:get_wedding_candies_con(MonConId),
            #wedding_candies_con{
                limit_num = LimitNum
            } = CandiesCon,
            case CandisNum < LimitNum of
                true ->
                    true;
                false ->
                    {false, Code}
            end
    end.

update_wedding_collect_checker(Ps, CollectChecker) ->
    Ps#player_status{
        collect_checker = CollectChecker
    }.

push_wedding_info_aura(State) ->
    #wedding_state{
        aura = Aura,
        enter_member_list = EnterMemberList
    } = State,
    {ok, Bin} = pt_172:write(17277, [[{1, Aura}]]),
    F = fun(EnterMemberInfo) ->
        #wedding_enter_member_info{
            role_id = _RoleId,
            sid = Sid,
            if_enter = IfEnter
        } = EnterMemberInfo,
        case IfEnter of
            0 ->
                skip;
            _ ->
                lib_server_send:send_to_sid(Sid, Bin)
        end
    end,
    lists:map(F, EnterMemberList).

send_wedding_info(State) ->
    #wedding_state{
        stage_id = StageId,
        stage_end_time = StageEndTime,
        aura = Aura,
        enter_member_list = EnterMemberList
    } = State,
    OnlineGuest = [IfEnter || #wedding_enter_member_info{if_enter = IfEnter} <- EnterMemberList, IfEnter > 0],
    F = fun(EnterMemberInfo) ->
        #wedding_enter_member_info{
            role_id = _RoleId,
            sid = Sid,
            get_normal_candies_num = GetNCNum,
            get_special_candies_num =  GetSCNum,
            if_enter = IfEnter
        } = EnterMemberInfo,
        case IfEnter of
            0 ->
                skip;
            _ ->
                {ok, Bin} = pt_172:write(17265, [?SUCCESS, StageId, StageEndTime, Aura, GetNCNum, GetSCNum, length(OnlineGuest)]),
                lib_server_send:send_to_sid(Sid, Bin)
        end
    end,
    lists:map(F, EnterMemberList).

send_wedding_info(State, RoleId) ->
    #wedding_state{
        stage_id = StageId,
        stage_end_time = StageEndTime,
        aura = Aura,
        enter_member_list = EnterMemberList
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            GetNCNum = 0,
            GetSCNum = 0;
        EnterMemberInfo ->
            #wedding_enter_member_info{
                get_normal_candies_num = GetNCNum,
                get_special_candies_num =  GetSCNum
            } = EnterMemberInfo
    end,
    OnlineGuest = [IfEnter || #wedding_enter_member_info{if_enter = IfEnter} <- EnterMemberList, IfEnter > 0],
    {ok, Bin} = pt_172:write(17265, [?SUCCESS, StageId, StageEndTime, Aura, GetNCNum, GetSCNum, length(OnlineGuest)]),
    lib_server_send:send_to_uid(RoleId, Bin).

wedding_break_off(RoleIdM, RoleIdW, MemberIdList) ->
    PsM = lib_offline_api:get_player_info(RoleIdM, all),
    PsW = lib_offline_api:get_player_info(RoleIdW, all),
    #player_status{
        figure = FigureM
    } = PsM,
    #player_status{
        figure = FigureW
    } = PsW,
    #figure{
        name = NameM
    } = FigureM,
    #figure{
        name = NameW
    } = FigureW,
    Title   = ?LAN_MSG(?LAN_TITLE_WEDDING_BREAK_OFF),
    Content = utext:get(?LAN_CONTENT_WEDDING_BREAK_OFF, [NameM, NameW]),
    lib_mail_api:send_sys_mail(MemberIdList, Title, Content, []).

check_wedding_order_times(Others, WeddingType) ->
    {_, WeddingOrderTimes} = ulists:keyfind(?COUPLE_OTHER_KEY_1, 1, Others, {?COUPLE_OTHER_KEY_1, []}),
    {_, UseTimes, FreeTimes} = ulists:keyfind(WeddingType, 1, WeddingOrderTimes, {WeddingType, 0, 0}),
    UseTimes < FreeTimes.