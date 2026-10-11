%%%--------------------------------------
%%% @Module  : pp_fashion
%%% @Author  : huyihao
%%% @Created : 2017.10.26
%%% @Description:  时装
%%%--------------------------------------

-module(pp_fashion).

-export([handle/3]).
-include("server.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("fashion.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common_rank.hrl").
-include("mount.hrl").
-include("def_fun.hrl").


% 打开时装界面
handle(41300, PS, []) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case lib_fashion_check:check_show_fashion(Lv) of 
        {false, Code} -> 
            SendList = [];
        true ->
            Code = ?ERRCODE(success),
            case PositionList of
                [] ->
                    FashionPosIdList = data_fashion:get_pos_id_list(),
                    NewPositionList = [#fashion_pos{pos_id = PosId} || PosId <- FashionPosIdList],
                    NewFashion = #fashion{position_list = NewPositionList},
                    NewGS = GS#goods_status{fashion = NewFashion},
                    lib_goods_do:set_goods_status(NewGS);
                _ ->
                    NewPositionList = PositionList
            end,
            F = fun(FashionPos, SendList1) ->
                #fashion_pos{pos_id = PosId, pos_lv = PosLv, wear_fashion_id = WearFashionId,
                    pos_upgrade_num = PosUpgradeNum, fashion_list = FashionList} = FashionPos,
                FashionSendList = [begin
                    #fashion_info{
                        fashion_id = FashionId,
                        color_id = ActiveNowColorId,
                        color_list = ActiveColorList,
                        fashion_star_lv = FashionStarlv
                    } = FashionInfo,
                    {FashionId, FashionStarlv, ActiveNowColorId, ActiveColorList} end || FashionInfo <- FashionList],
                SendInfo = {PosId, WearFashionId, PosLv, PosUpgradeNum, FashionSendList},
                [SendInfo|SendList1]
            end,
            SendList = lists:foldl(F, [], NewPositionList)
    end,
    {ok, Bin} = pt_413:write(41300, [Code, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 染色（未用）
handle(41301, PS, [PosId, FashionId, ColorId, Type]) when Type =:= 1 ->
    #player_status{id = RoleId} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{pos_id = PosId}),
    #fashion_pos{wear_fashion_id = WearFashionId, fashion_list = FashionList} = FashionPos,
    % [FashionInfo] = lists:filter(fun(Info) -> Info#fashion_info.fashion_id == FashionId andalso Info#fashion_info.color_id == 0 end, FashionList),
    FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
    case lib_fashion_check:check_dye_unlock_color(PS, PosId, FashionId, ColorId, Type) of
        {false, ErrCode} -> 
            Code = ErrCode,
            NewPS = PS;
        true ->
            Code = ?SUCCESS,
            NewFashionInfo = FashionInfo#fashion_info{color_id = ColorId},
            NewFashionList = lists:keyreplace(FashionId, #fashion_info.fashion_id, FashionList, NewFashionInfo),
            % NewFashionInfo = #fashion_info{pos_id = PosId, fashion_id = FashionId, color_id = ColorId, fashion_star_lv = 1}, % 构造一个新的时装信息
            % NewFashionList = [FashionList|NewFashionInfo],
            case FashionId of
                % 正在穿，更新当前时装颜色和时装列表
                WearFashionId ->
                    IsWear = ?USED,
                    NewFashionPos = FashionPos#fashion_pos{wear_color_id = ColorId, fashion_list = NewFashionList};
                % 未穿，只更新玩家时装列表信息
                _ ->
                    IsWear = ?UN_USED,
                    NewFashionPos = FashionPos#fashion_pos{wear_fashion_id = FashionId, wear_color_id = ColorId, fashion_list = NewFashionList}
            end,
            lib_fashion:sql_fashion(NewFashionPos, RoleId),
            NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
            NewFashion = Fashion#fashion{position_list = NewPositionList},
            NewGS = GS#goods_status{fashion = NewFashion},
            lib_goods_do:set_goods_status(NewGS),
            case IsWear of
                ?USED ->
                    {ok, NewPS} = lib_fashion_event:event(activate, [PS, PosId]);  % 更新场景玩家时装
                ?UN_USED ->
                    NewPS = PS
            end,
            lib_log_api:log_fashion_color(RoleId, PosId, FashionId, ColorId, Type, [])
    end,
    {ok, Bin} = pt_413:write(41301, [Code, PosId, FashionId, ColorId, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPS};

%% 解锁颜色
handle(41301, PS, [PosId, FashionId, ColorId, Type]) when Type =:= 2 ->
    #player_status{id = RoleId, goods = StatusGoods} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{pos_id = PosId}),
    #fashion_pos{fashion_list = FashionList} = FashionPos,
    % FashionInfo = lib_fashion:get_fashion_info(FashionId, 0, FashionList),
    FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{pos_id = PosId, fashion_id = FashionId, fashion_star_lv = 1}),
    #fashion_info{color_list = ColorList} = FashionInfo,
    case lib_fashion_check:check_dye_unlock_color(PS, PosId, FashionId, ColorId, Type) of
        {false, ErrCode} -> 
            Code = ErrCode,
            NewPS = PS;
        true ->
            FashionColorCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, 1),
            #fashion_color_con{active_cost = CostList} = FashionColorCon,
            F = fun() ->
                lib_goods_dict:start_dict(),
                case lib_goods_util:cost_object_list(PS, CostList, fashion_color, "", GS) of
                    {true, NewGS1, NewPS1} ->
                        NewColorList = lists:append(ColorList, [{ColorId, 1}]),
                        NewFashionInfo = FashionInfo#fashion_info{color_id = ColorId, color_list = NewColorList},
                        NewFashionList = lists:keystore(FashionId, #fashion_info.fashion_id, FashionList, NewFashionInfo),
                        NewFashionPos = FashionPos#fashion_pos{wear_fashion_id = FashionId, wear_color_id = ColorId, fashion_list = NewFashionList},
                        lib_fashion:sql_fashion(NewFashionPos, RoleId),
                        NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
                        NewFashion = Fashion#fashion{position_list = NewPositionList},
                        NewGS2 = NewGS1#goods_status{fashion = NewFashion},
                        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS2#goods_status.dict),
                        lib_goods_api:notify_client_num(RoleId, GoodsL),
                        NewGS3 = NewGS2#goods_status{dict = Dict},
                        lib_log_api:log_fashion_color(RoleId, PosId, FashionId, ColorId, Type, CostList),
                        {?SUCCESS, NewGS3, NewPS1, NewFashion};
                    {false, Code1, NewGS1, NewPS1} ->
                        {Code1, NewGS1, NewPS1, Fashion}
                end
            end,
            {Code, NewGS, LastPS, NewFashion} = lib_goods_util:transaction(F),
            case Code =:= ?SUCCESS of
                true ->
                    lib_goods_do:set_goods_status(NewGS);
                _ ->
                    skip
            end,
            PowerPS = lib_fashion:count_fashion_power(NewFashion, StatusGoods, LastPS),         % 战力计算
            {ok, NewPS} = lib_fashion_event:event(activate, [PowerPS, PosId])                   % 更新场景玩家时装
    end,
    {ok, Bin} = pt_413:write(41301, [Code, PosId, FashionId, ColorId, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPS};

%% 穿戴
handle(41302, PS, [PosId, FashionId, ColorId]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case lib_fashion_check:check_put_on(Lv, PosId, FashionId, ColorId, PositionList) of 
        {false, ErrCode} ->
            NewPS = PS,
            {ok, Bin} = pt_413:write(41302, [ErrCode, PosId, FashionId, ColorId]),
            lib_server_send:send_to_uid(RoleId, Bin);
        {FashionInfo, FashionPos} ->
            ErrCode = ?SUCCESS,
            #fashion_pos{fashion_list = FashionList} = FashionPos,
            NewFashionInfo = FashionInfo#fashion_info{color_id = ColorId},
            NewFashionList = lists:keyreplace(FashionId, #fashion_info.fashion_id, FashionList, NewFashionInfo),
            NewFashionPos = FashionPos#fashion_pos{wear_fashion_id = FashionId, wear_color_id = ColorId, fashion_list = NewFashionList},
            F = fun() ->
                lib_fashion:sql_fashion_base(NewFashionPos, RoleId),         % 主要保存玩家正在穿的时装和颜色
                lib_fashion:sql_fashion_info(NewFashionInfo, RoleId, PosId)  % 主要保存玩家套装信息
            end,
            db:transaction(F),
            NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
            NewFashion = Fashion#fashion{position_list = NewPositionList},
            NewGS = GS#goods_status{fashion = NewFashion},
            lib_goods_do:set_goods_status(NewGS),
            % NewFashionModelList = lib_fashion:get_equip_fashion_list_ps(PS),
            % NewFigure = Figure#figure{fashion_model = NewFashionModelList},
            % NewPS1 = PS#player_status{figure = NewFigure},
            {ok, Bin} = pt_413:write(41302, [ErrCode, PosId, FashionId, ColorId]),
            lib_server_send:send_to_uid(RoleId, Bin),
            {ok, NewPS} = lib_fashion_event:event(put_on, [PS, PosId])
    end,
    {ok, NewPS};

%% 卸下
handle(41303, PS, [PosId, FashionId]) ->
    #player_status{id = RoleId, figure = Figure = #figure{lv = Lv}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case lib_fashion_check:check_put_off(Lv, PosId, FashionId, PositionList) of 
        {false, Code} -> 
            NewPS = PS;
        {FashionPos} ->
            Code = ?ERRCODE(success),
            NewFashionPos = FashionPos#fashion_pos{wear_fashion_id = 0, wear_color_id = 0},
            lib_fashion:sql_fashion_base(NewFashionPos, RoleId),
            NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
            NewFashion = Fashion#fashion{position_list = NewPositionList},
            NewGS = GS#goods_status{fashion = NewFashion},
            lib_goods_do:set_goods_status(NewGS),
            NewFashionModelList = lib_fashion:get_equip_fashion_list_ps(PS),
            NewFigure = Figure#figure{fashion_model = NewFashionModelList},
            NewPS1 = PS#player_status{figure = NewFigure},
            {ok, NewPS} = lib_fashion_event:event(put_off, [NewPS1, NewFashionModelList, PosId])
    end,
    {ok, Bin} = pt_413:write(41303, [Code, PosId, FashionId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPS};

%% 激活时装
handle(41304, PS, [PosId, FashionId]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv, career = Career, sex = Sex}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = #fashion{position_list = PositionList}} = GS,
    case lib_fashion_check:check_active_fashion(Lv, PosId, PositionList, FashionId, Career, Sex) of 
        {false, Code} ->
            NewPS = PS;
        {FashionCon, FashionPos} ->
            {Code, NewPS} = lib_fashion:active_fashion(FashionCon, PS, PosId, FashionId, FashionPos)
    end,
    {ok, Bin} = pt_413:write(41304, [Code, PosId, FashionId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    handle(41312, NewPS, [PosId, FashionId]),
    {ok, NewPS};

%% 部位升级
handle(41305, PS, [PosId, GoodsNumList]) ->
    #player_status{
        id = RoleId,
        goods = StatusGoods,
        figure = #figure{lv = Lv}
    } = PS,
    GS = lib_goods_do:get_goods_status(),
    case Lv >= ?OpenLv of
        false ->
            Code = ?ERRCODE(lv_limit),
            NewPosUpgradeNum = 0,
            NewPS = PS,
            NewPosLv = 0;
        true ->
            case lib_fashion:upgrade_fashion_pos(PS, GS, PosId, GoodsNumList) of
                {ok, NewGS, NewFashionPos, IsUpgrade} ->
                    Code = ?SUCCESS, 
                    NewPosLv = NewFashionPos#fashion_pos.pos_lv, 
                    NewPosUpgradeNum = NewFashionPos#fashion_pos.pos_upgrade_num,
                    case IsUpgrade of 
                        true ->
                            #goods_status{fashion = NewFashion} = NewGS,
                            NewPS = lib_fashion:count_fashion_power(NewFashion, StatusGoods, PS);
                        _ ->
                            NewPS = PS
                    end;
                {fail, Code} ->
                    NewPosUpgradeNum = 0,
                    NewPS = PS,
                    NewPosLv = 0
            end
    end,
    {ok, Bin} = pt_413:write(41305, [Code, PosId, NewPosLv, NewPosUpgradeNum]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPS};

%% 时装进阶
handle(41306, PS, [PosId, FashionId, ColorId]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case lib_fashion_check:check_star_up(Lv, PosId, FashionId, ColorId, PositionList) of 
        {false, Code} -> 
            NewFashionStarlv = 0,
            NewPS = PS;
        {FashionStarLv, FashionPos} ->
            NewFashionStarlv = FashionStarLv + 1,
            {Code, NewPS} = lib_fashion:star_up_fashion(PosId, FashionId, ColorId, NewFashionStarlv, PS, FashionPos)
    end,
    {ok, Bin} = pt_413:write(41306, [Code, PosId, FashionId, ColorId, NewFashionStarlv]),
    lib_server_send:send_to_uid(RoleId, Bin),
    handle(41312, NewPS, [PosId, FashionId]),
    {ok, NewPS};

%% 单个时装信息
handle(41310, PS, [PosId, FashionId]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case lib_fashion_check:check_show_single_fashion(Lv, PosId, FashionId, PositionList) of
        {false, Code} -> 
            FashionStarlv = 0,
            ColorId = 0,
            ActiveColorList = [];
        {FashionInfo} ->
            Code = ?ERRCODE(success),   %% 成功
            #fashion_info{
                fashion_star_lv = FashionStarlv,
                color_id = ColorId,
                color_list = ActiveColorList
            } = FashionInfo
    end,
    {ok, Bin} = pt_413:write(41310, [Code, PosId, FashionId, FashionStarlv, ColorId, ActiveColorList]),
    lib_server_send:send_to_uid(RoleId, Bin);

handle(41312, PS, [PosId, FashionId]) ->
    lib_fashion:get_real_power(PS, PosId, FashionId);

%% 发送时装套装信息
handle(41313, PS, []) ->
    lib_fashion_suit:send_suit_info(PS);

%% 激活套装
handle(41314, PS, [SuitId, ActiveNum]) ->
    #player_status{id = RoleId} = PS,
    case lib_fashion_suit:active_suit(PS, SuitId, ActiveNum) of
        {ok, NewPs} -> ok;
        {false, Err} ->
            {ok, Bin} = pt_413:write(41314, [SuitId, ActiveNum, Err, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPs = PS
    end,
    {ok, NewPs};

%% 升阶套装
handle(41315, PS, [SuitId]) ->
    #player_status{id = RoleId} = PS,
    case lib_fashion_suit:upgrade_suit(PS, SuitId) of
        {ok, NewPs} -> ok;
        {false, Err} ->
            {ok, Bin} = pt_413:write(41315, [SuitId, 0, Err, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPs = PS
    end,
    {ok, NewPs};

%% 颜色升阶
handle(41316, PS, [PosId, FashionId, ColorId]) ->
    #player_status{id = RoleId, goods = StatusGoods} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    #fashion_pos{fashion_list = FashionList} = FashionPos,
    % FashionInfo = lib_fashion:get_fashion_info(FashionId, 0, FashionList),
    FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
    #fashion_info{color_list = ColorList} = FashionInfo,
    case lists:keyfind(ColorId, 1, ColorList) of
        {ColorId, ColorLv} ->
            case data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, ColorLv + 1) of
                #fashion_color_con{star_cost = CostList} ->
                    F = fun() ->
                        lib_goods_dict:start_dict(),
                        case lib_goods_util:cost_object_list(PS, CostList, fashion_color, "", GS) of
                            {true, NewGS1, NewPS1} ->
                                NewColorList = lists:keystore(ColorId, 1, ColorList, {ColorId, ColorLv + 1}),
                                NewFashionInfo = FashionInfo#fashion_info{color_id = ColorId, color_list = NewColorList},
                                NewFashionList = lists:keyreplace(FashionId, #fashion_info.fashion_id, FashionList, NewFashionInfo),
                                NewFashionPos = FashionPos#fashion_pos{wear_fashion_id = FashionId, wear_color_id = ColorId, fashion_list = NewFashionList},
                                lib_fashion:sql_fashion(NewFashionPos, RoleId),
                                NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
                                NewFashion = Fashion#fashion{position_list = NewPositionList},
                                NewGS2 = NewGS1#goods_status{fashion = NewFashion},
                                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS2#goods_status.dict),
                                lib_goods_api:notify_client_num(RoleId, GoodsL),
                                NewGS3 = NewGS2#goods_status{dict = Dict},
%%                        lib_log_api:log_fashion_color(RoleId, PosId, FashionId, ColorId, Type, CostList),
                                {?SUCCESS, NewGS3, NewPS1, NewFashion};
                            {false, Code1, NewGS1, NewPS1} ->
                                {Code1, NewGS1, NewPS1, Fashion}
                        end
                        end,
                    {Code, NewGS, LastPS, NewFashion} = lib_goods_util:transaction(F),
                    case Code =:= ?SUCCESS of
                        true ->
                            lib_goods_do:set_goods_status(NewGS);
                        _ ->
                            skip
                    end,
                    NewPS = lib_fashion:count_fashion_power(NewFashion, StatusGoods, LastPS);         % 战力计算
%%            {ok, NewPS} = lib_fashion_event:event(activate, [PowerPS, PosId]);              % 更新场景玩家时装
                _ ->
                    Code = ?ERRCODE(err413_upgrade_max),
                    NewPS = PS
            end;
        _ ->
            ColorLv = 0,
            Code = ?ERRCODE(err413_upgrade_not_conform),
            NewPS = PS
    end,
    {ok, Bin} = pt_413:write(41316, [PosId, FashionId, ColorId, ColorLv + 1, Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPS};

handle(_CMD, PlayerStatus, Arg) ->
    ?PRINT("_CMD = ~w  , Arg = ~w~n", [_CMD, Arg]),
    {ok, PlayerStatus}.
