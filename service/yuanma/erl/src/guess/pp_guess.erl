%%-----------------------------------------------------------------------------
%% @Module  :       pp_guess
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-06
%% @Description:    竞猜
%%-----------------------------------------------------------------------------

-module(pp_guess).

-export([handle/3]).

-include("server.hrl").
-include("guess.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("figure.hrl").

%% 开启中的竞猜活动
handle(Cmd = 34201, Player, []) ->
    List = lib_guess:get_open_act_list(),
    {ok, BinData} = pt_342:write(Cmd, [List]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok;

%% 竞猜信息列表
handle(Cmd = 34202, Player, [GameType]) ->
    #player_status{id = _RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            List = lib_guess:get_open_act_subtype_list(GameType),
            {ok, BinData} = pt_342:write(Cmd, [List]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        _ ->
            skip
    end,
    ok;

%% 竞猜单场列表
handle(_Cmd = 34203, Player, [GameType, SubType]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            mod_guess:send_single_guess_info_list(RoleId, GameType, SubType);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end,
    ok;

%% 竞猜单场购买信息
handle(_Cmd = 34204, Player, [GameType, SubType, CfgId, SelResult])
    when SelResult == ?RESULT_WIN orelse SelResult == ?RESULT_LOSE orelse SelResult == ?RESULT_DRAW ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            mod_guess:send_single_guess_bet_info(RoleId, GameType, SubType, CfgId, SelResult);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end,
    ok;

%% 竞猜单场的押注
handle(_Cmd = 34205, Player, [GameType, SubType, CfgId, NeedBetTimes, SelResult, AutoBuy])
    when SelResult == ?RESULT_WIN orelse SelResult == ?RESULT_LOSE orelse SelResult == ?RESULT_DRAW ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            case catch mod_guess:check_single_guess_bet(RoleId, GameType, SubType, CfgId, NeedBetTimes) of
                {ok, Cfg} ->
                    CostList = lib_guess:count_cost(GameType, NeedBetTimes),
                    Res = case AutoBuy == 1 of
                              true ->
                                  lib_goods_api:cost_objects_with_auto_buy(Player, CostList, guess, integer_to_list(GameType));
                              false ->
                                  case lib_goods_api:cost_object_list_with_check(Player, CostList, guess, integer_to_list(GameType)) of
                                      {true, TmpNewPlayer} -> {true, TmpNewPlayer, CostList};
                                      Other -> Other
                                  end
                          end,
                    case Res of
                        {true, NewPlayer, RealCostList} ->
                            mod_guess:single_guess_bet(RoleId, Cfg, NeedBetTimes, SelResult, RealCostList);
                        {false, ErrCode, NewPlayer} ->
                            lib_guess:send_error_code(RoleId, ErrCode)
                    end;
                {false, ErrCode} ->
                    NewPlayer = Player,
                    lib_guess:send_error_code(RoleId, ErrCode);
                _Err ->
                    ?ERR("_Err>>>>>>:~p", [_Err]),
                    NewPlayer = Player,
                    lib_guess:send_error_code(RoleId, ?ERRCODE(system_busy))
            end,
            {ok, NewPlayer};
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end;

%% 竞猜冠军列表
handle(_Cmd = 34206, Player, [GameType]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            mod_guess:send_group_guess_info_list(RoleId, GameType);
        _ ->
            skip
    end,
    ok;

%% 竞猜冠军购买信息
handle(_Cmd = 34207, Player, [GameType, CfgId]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            mod_guess:send_group_guess_bet_info(RoleId, GameType, CfgId);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end,
    ok;

%% 竞猜冠军的押注
handle(_Cmd = 34208, Player, [GameType, CfgId, NeedBetTimes, AutoBuy]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            case catch mod_guess:check_group_guess_bet(RoleId, GameType, CfgId, NeedBetTimes) of
                {ok, Cfg} ->
                    CostList = lib_guess:count_cost(GameType, NeedBetTimes),
                    Res = case AutoBuy == 1 of
                              true ->
                                  lib_goods_api:cost_objects_with_auto_buy(Player, CostList, guess, integer_to_list(GameType));
                              false ->
                                  case lib_goods_api:cost_object_list_with_check(Player, CostList, guess, integer_to_list(GameType)) of
                                      {true, TmpNewPlayer} -> {true, TmpNewPlayer, CostList};
                                      Other -> Other
                                  end
                          end,
                    case Res of
                        {true, NewPlayer, RealCostList} ->
                            mod_guess:group_guess_bet(RoleId, Cfg, NeedBetTimes, RealCostList);
                        {false, ErrCode, NewPlayer} ->
                            lib_guess:send_error_code(RoleId, ErrCode)
                    end;
                {false, ErrCode} ->
                    NewPlayer = Player,
                    lib_guess:send_error_code(RoleId, ErrCode);
                _Err ->
                    ?ERR("_Err>>>>>>:~p", [_Err]),
                    NewPlayer = Player,
                    lib_guess:send_error_code(RoleId, ?ERRCODE(system_busy))
            end,
            {ok, NewPlayer};
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end;

%% 竞猜单场的领取
handle(_Cmd = 34209, Player, [GameType, SubType, CfgId]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            mod_guess:receive_single_guess_reward(RoleId, GameType, SubType, CfgId);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end,
    ok;

%% 竞猜冠军的领取
handle(_Cmd = 34210, Player, [GameType, CfgId]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            mod_guess:receive_group_guess_reward(RoleId, GameType, CfgId);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end,
    ok;

%% 竞猜记录
handle(_Cmd = 34212, Player, [GameType]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_guess:get_open_lv(GameType),
    case RoleLv >= OpenLv of
        true ->
            mod_guess:send_guess_bet_record(RoleId, GameType);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_lv_lim))
    end,
    ok;

handle(_Cmd, _Player, _Data) -> skip.
