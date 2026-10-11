%%%--------------------------------------
%%% @Module  : pp_talisman
%%% @Author  : fwx
%%% @Created : 2017.10.27
%%% @Description:  法宝系统
%%%--------------------------------------
-module(pp_talisman).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("talisman.hrl").
-include("def_module.hrl").
-include("def_event.hrl").

% 翅膀信息
handle(Cmd = 16802, Player, _Data) ->
    #player_status{sid = Sid, status_talisman = StatusTalisman} = Player,
    #status_talisman{
        lv = Lv, exp = Exp,
        illusion_id = IllusionId, attr = Attr, skills = Skills,
        combat = Combat,  display_status = DisplayStatus
    } = StatusTalisman,
    Args = [Lv, Exp, IllusionId,  Attr, Combat, DisplayStatus, Skills],
    {ok, BinData} = pt_168:write(Cmd, Args),
    lib_server_send:send_to_sid(Sid, BinData);

%% 幻化法宝
handle(Cmd = 16803, Player, [IllusionId]) ->
    #player_status{sid = Sid, id = RoleId, status_talisman= StatusTalisman, figure = Figure} = Player,
        case lib_talisman:illusion_figure(RoleId, StatusTalisman, IllusionId) of
            {ok, NewStatusTalisman} ->
                NewFigure = Figure#figure{fairy_figure = NewStatusTalisman#status_talisman.figure_id * NewStatusTalisman#status_talisman.display_status},
                NewPlayer = Player#player_status{status_talisman= NewStatusTalisman, figure = NewFigure},
                lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
                %% 通知场景玩家
                lib_talisman:broadcast_to_scene(NewPlayer),
                {ok, BinData} = pt_168:write(Cmd, [?SUCCESS, IllusionId]),
                lib_server_send:send_to_sid(Sid, BinData);
            {fail, ErrorCode} ->
                {ok, BinData} = pt_168:write(16800, [ErrorCode]),
                lib_server_send:send_to_sid(Sid, BinData),
                NewPlayer = Player
        end,

    {ok, NewPlayer};

%% 显示翅膀
%% Type: 0: 隐藏 1: 显示
handle(16804, Player, [Type]) ->
    lib_talisman:change_display_status(Player, Type);

%% 升级
handle(16805, Player, [GoodId, Type]) ->         %% 1： 一键升级 0：使用一个
    lib_talisman:upgrade_lv(Player, GoodId, Type);

%% 化形升星
handle(16806, Player, [Id]) ->
    lib_talisman:upgrade_star(Player, Id);

%% 化形界面信息
handle(Cmd = 16807, Player, _Data) ->
    #player_status{sid = Sid, status_talisman = StatusTalisman} = Player,
    #status_talisman{
       illusion_id = IllusionId,       %%幻化形象id
       figure_list = FigureList
    } = StatusTalisman,
    List = [{Id, Star} || #talisman_figure{id = Id, star = Star} <- FigureList],
    {ok, BinData} = pt_168:write(Cmd, [?SUCCESS, IllusionId, List]),
    lib_server_send:send_to_sid(Sid, BinData);
%% 化形激活
handle(_Cmd = 16808, Player, [Id]) ->
    lib_talisman:active_figure(Player, Id);

%% 化形详细信息
handle(Cmd = 16809, Player, [Id]) ->
    #player_status{sid = Sid, status_talisman = StatusTalisman} = Player,
    #status_talisman{figure_list = FigureList} = StatusTalisman,
    case lists:keyfind(Id, #talisman_figure.id, FigureList) of
        #talisman_figure{star = Star, attr = Attr, combat = Combat} ->
            {ok, BinData} = pt_168:write(Cmd, [?SUCCESS, Id, Star, Attr, Combat]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip %% 未激活不处理
    end;

%% 使用魂珠
handle(Cmd = 16810, Player, [GTypeId]) ->
    [{_, OwnNum}] = lib_goods_api:get_goods_num(Player, [GTypeId]),
    if
        OwnNum =< 0 -> NewPlayer = Player, ErrorCode = ?ERRCODE(err168_not_enough_cost);
        true ->
            case lib_talisman:use_goods(Player, GTypeId, OwnNum) of
                {ok, ErrorCode, NewPlayer} -> skip;
                {fail, ErrorCode, NewPlayer} -> skip
            end
    end,
    {ok, BinData} = pt_168:write(Cmd, [ErrorCode, GTypeId]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, battle_attr, NewPlayer};

%% 魂珠使用次数
handle(Cmd = 16811, Player, _) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    GTypeIds = data_talisman:get_feather_ids(),
    CounterList = mod_counter:get_count(RoleId, ?MOD_GOODS, GTypeIds),
    F = fun(GTypeId) ->
        case lists:keyfind(GTypeId, 1, CounterList) of
            {GTypeId, Times} -> skip;
            _ -> Times = 0
        end,
        MaxTimes = lib_talisman:get_feather_max_times(GTypeId, RoleLv),
        {GTypeId, Times, MaxTimes}
    end,
    TimesL = lists:map(F, GTypeIds),
    {ok, BinData} = pt_168:write(Cmd, [TimesL]),
    lib_server_send:send_to_sid(Sid, BinData);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
