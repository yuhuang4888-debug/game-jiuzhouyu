%%%-----------------------------------
%%% @Module  : pp_kf_1vN
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN 协议处理
%%%-----------------------------------
-module(pp_kf_1vN).

-export([handle/3]).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("kf_1vN.hrl").
-include("attr.hrl").

%% 活动信息
handle(62100, #player_status{id=RoleId, sid = Sid}, _) ->
    mod_kf_1vN_local:get_act_info(RoleId, Sid),
    ok;


%% 阶段信息
handle(62101, #player_status{id=Id, sid = Sid}, _) ->
    OpenDayLimit = data_kf_1vN_m:get_config(open_day),
    case util:get_open_day() >= OpenDayLimit of
        false ->
            {ok, BinData} = pt_621:write(62101, [?KF_1VN_FREE, 0, 0, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_1vN, get_stage_info, [Node, Id]),
            ok
    end;

%% 报名
handle(62102, #player_status{id=Id, server_id=ServerId, platform=Platform, server_num=ServerNum, figure=#figure{name=Name, lv=Lv}, hightest_combat_power=CP, sid=Sid, server_name = SerName} = Status, _) ->
    case check_sign(Status) of
        {false, ErrCode} -> 
            {ok, BinData} = pt_621:write(62102, [ErrCode]),
            lib_server_send:send_to_sid(Sid, BinData);
        true -> 
            mod_kf_1vN_local:sign(ServerId, Id, Lv, Name, CP, Platform, ServerNum, SerName)
    end,
    ok;

%% 进入
handle(62103, Status, _) ->
    case check_enter(Status) of
        {false, ErrCode} -> 
            {ok, BinData} = pt_621:write(62103, [ErrCode]),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData);
        true -> 
            KfRole = lib_kf_1vN:trans_enter_info(Status),
            mod_kf_1vN_local:enter(KfRole)
    end,
    ok;

%% 请求等待场景信息
handle(62104, #player_status{id = Id}, _) -> 
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN, get_banner, [Node, Id]),
    ok;

%% 资格赛战场信息
handle(62105, #player_status{id = Id, scene = SceneId, copy_id = CopyId}, []) ->
    case SceneId == data_kf_1vN_m:get_config(race_1_scene) andalso is_pid(CopyId) of
        true  ->
            Node = mod_disperse:get_clusters_node(),
            CopyId ! {get_race_1_info, Node, Id};
        false -> skip
    end;
    

%% 退出场景
handle(62107, Status, _) -> 
    mod_kf_1vN_local:quit(Status#player_status.id, Status#player_status.copy_id, 1, Status#player_status.battle_attr#battle_attr.hp, Status#player_status.battle_attr#battle_attr.hp_lim),
    ok;

%% 获取资格赛排行榜
handle(62110,  #player_status{figure = #figure{lv = Lv}} = Status, [Area]) -> 
    mod_kf_1vN_local:get_score_rank(Status#player_status.id, Status#player_status.sid, Lv, Area),
    ok;


%% 挑战赛等待场景信息
handle(62111, Status, _) -> 
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN, get_banner, [Node, Status#player_status.id]),
    ok;
%% 挑战赛战场信息
handle(62112, #player_status{id = Id, scene = SceneId, copy_id = CopyId}, []) ->
    case SceneId == data_kf_1vN_m:get_config(race_2_scene) andalso is_pid(CopyId) of
        true  ->
            Node = mod_disperse:get_clusters_node(),
            CopyId ! {get_race_2_info, Node, Id};
        false -> skip
    end;

%% 挑战赛 擂主排行榜
handle(62114, Status, _) -> 
    mod_kf_1vN_local:get_def_rank(Status#player_status.id, Status#player_status.sid),
    ok;


%% 挑战赛 积分排行榜
handle(62115, Status, _) -> 
    mod_kf_1vN_local:get_challenge_rank(Status#player_status.id, Status#player_status.sid),
    ok;


%% 结束后的擂主排行榜
handle(62116, #player_status{figure = #figure{lv = Lv}} = Status, [Area]) ->
    mod_kf_1vN_local:get_rank(Status#player_status.id, Status#player_status.sid, Lv, Area),
    ok;

%% 挑战赛 对战列表
handle(62117, Status, _) -> 
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN, get_bet_list, [Node, Status#player_status.id]),
    ok;

%% 挑战赛 押注
handle(62118, Status, [Turn, BattleId, OptNo, CostType]) ->
    %?MYLOG("lzh_1vn", "62118 receive ~p ~n ", [[Turn, BattleId, OptNo, CostType]]),
    % Cost = data_kf_1vN_m:get_bet_cost(BetType), 
    CostKvList = data_kf_1vN:get_cost_list(Turn),
    case lists:keyfind(CostType, 1, CostKvList) of
        false -> ErrCode = ?MISSING_CONFIG;
        {_CostType, Cost, _WinReward, _LoseReward} -> 
            case lib_goods_api:check_object_list(Status, Cost) of
                {false, ErrCode} -> ok;
                true ->
                    ErrCode = ?SUCCESS,
                    Node = mod_disperse:get_clusters_node(),
                    #player_status{id = Id, figure = #figure{name = RoleName}} = Status,
                    mod_clusters_node:apply_cast(mod_kf_1vN, bet_battle, [Node, Status#player_status.server_id, Id, RoleName, Turn, BattleId, OptNo, CostType])
            end
    end,
    case ErrCode == ?SUCCESS of
        true -> skip;
        false ->
            %?MYLOG("lzh_1vn", "62118 send errcode ~p ~n ", [ErrCode]),
            {ok, BinData} = pt_621:write(62118, [ErrCode, Turn, BattleId]),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData)
    end,
    ok;

%% 挑战赛 排名和积分王
handle(62119, Status, _) -> 
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN, get_race_2_rank_top, [Node, Status#player_status.id]),
    ok;

%% 观战
handle(62121, Status, [BattleId]) -> 
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN, watch, [Node, Status#player_status.server_id, Status#player_status.id, BattleId]),
    ok;

%% 擂主领取每日奖励
handle(62122, Status, _) ->
    mod_kf_1vN_local:get_def_daily_award(Status#player_status.id),
    ok;


%% 1vN 拍卖信息
handle(62124, Status, _) ->
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN_auction, get_info, [Node, Status#player_status.id]),
    ok;


%% 1vN 拍卖排行榜
handle(62125, Status, [AuctionId]) ->
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN_auction, get_rank, [Node, Status#player_status.id, AuctionId]),
    ok;

%% 1vN拍卖-追加竞拍价格
handle(62126, Status, [AuctionId, UseGold, VoucherNum]) when UseGold > 0 orelse VoucherNum > 0 ->
%%    ?PRINT("62126 ~w~n", [{UseGold,VoucherNum}]),
    case UseGold + VoucherNum >= data_kf_1vN_m:get_config(min_auction_price) of
        true ->
            #player_status{server_id=SerId, server_num=SerNum, id=Id, figure=#figure{name=Name}, sid=Sid} = Status,
            VoucherId = data_kf_1vN_m:get_config(voucher_id),
            CostList
                = lists:filter(fun
                                   ({_, _, X}) ->
                                       X > 0
                               end,
                [{?TYPE_GOODS, VoucherId, VoucherNum}, {?TYPE_GOLD, 0, UseGold}]),
            case lib_goods_api:check_object_list(Status, CostList) of
                true ->
                    case catch mod_clusters_node:apply_call(mod_kf_1vN_auction, is_can_auction, []) of
                        true ->
                            case lib_consume_data:advance_cost_objects(Status, CostList, kf_1vn_auction, integer_to_list(AuctionId), false) of
                                {true, NewPS, Ref} ->
                                    Node = mod_disperse:get_clusters_node(),
                                    case catch mod_clusters_node:apply_call(mod_kf_1vN_auction, price_add, [[Node, SerId, SerNum, Id, Name, AuctionId, UseGold+VoucherNum, VoucherNum, Ref]]) of
                                        true ->
                                            {ok, NewPS};
                                        _ ->
                                            lib_consume_data:advance_payment_fail(Id, Ref, []),
                                            ReturnPS = lib_goods_api:send_reward(NewPS, CostList, kf_1vn_auction_fail, 0, 0),
                                            {ok, BinData} = pt_621:write(62126, [?ERRCODE(system_busy)]),
                                            lib_server_send:send_to_sid(Sid, BinData),
                                            {ok, ReturnPS}
                                    end;
                                _ ->
                                    {ok, BinData} = pt_621:write(62126, [?ERRCODE(err621_goods_not_enough)]),
                                    lib_server_send:send_to_sid(Sid, BinData)
                            end;
                        _ ->
                            {ok, BinData} = pt_621:write(62126, [?ERRCODE(system_busy)]),
                            lib_server_send:send_to_sid(Sid, BinData)
                    end;
                _ ->
                    {ok, BinData} = pt_621:write(62126, [?ERRCODE(err621_goods_not_enough)]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        _ ->
            ok
    end;

%% 1vN拍卖-关注拍卖窗口
handle(62127, Status, [Follow]) ->
    #player_status{server_id=SerId, id=Id} = Status,
    mod_clusters_node:apply_cast(mod_kf_1vN_auction, follow, [SerId, Id, Follow]),
    ok;

handle(62128, Status, _) -> 
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN_auction, get_past_list, [Node, Status#player_status.id]),
    ok;

handle(62129, Status, _) -> 
    mod_kf_1vN_local:get_auction_stage(Status#player_status.id),
    ok;

handle(62130, Status, _) ->
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_1vN, get_sign_list, [Node, Status#player_status.id, Status#player_status.hightest_combat_power]);

handle(62131, #player_status{kf_1vn = #status_kf1vn{def_type = DefType, turn = Turn}, sid = Sid}, []) ->
    {ok, BinData} = pt_621:write(62131, [DefType, Turn]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 查看竞猜记录
handle(62133, #player_status{id = RoleId}, []) ->
    mod_kf_1vN_local:send_bet_list(RoleId);

%% 领取竞猜奖励
handle(62134, #player_status{id = RoleId}, [Key]) ->
    mod_kf_1vN_local:receive_bet_reward(RoleId, Key);

%% 请求最强王者
handle(62136, #player_status{id = RoleId, figure = #figure{lv = Lv}}, [Area]) ->
    % ?PRINT("Lv:~p Area:~p ~n", [Lv, Area]),
    mod_kf_1vN_local:send_top_info(RoleId, Lv, Area);

handle(_Cmd, _Status, _Data) ->
%%    ?PRINT("pp_kf_1vN no match ~w~n", [{_Cmd, _Data}]),
    {error, "pp_kf_1vN no match"}.

check_sign(PS) -> 
    #player_status{figure=#figure{lv=Lv}} = PS,
    LvLim = data_kf_1vN:get_value(?KF_1VN_CFG_ENTER_LV),
    if
        %Status /= ?P_STATUS_NORMAL -> {false, Status};
        Lv < LvLim -> {false, ?ERRCODE(lv_limit)};
        true -> true
    end.

check_enter(PS) ->
    lib_player_check:check_all(PS).
%%    #player_status{status=Status} = PS,
%%    if
%%        Status /= ?P_STATUS_NORMAL -> {false, Status};
%%        true -> true
%%    end.
