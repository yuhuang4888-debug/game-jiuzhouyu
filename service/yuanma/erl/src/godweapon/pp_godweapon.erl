%%%--------------------------------------
%%% @Module  : pp_godweapon
%%% @Author  : fwx
%%% @Created : 2017.10.27
%%% @Description:  神兵系统
%%%--------------------------------------
-module(pp_godweapon).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("godweapon.hrl").
-include("def_module.hrl").

% 神兵信息
handle(Cmd = 16902, Player, _Data) ->
    #player_status{sid = Sid, status_godweapon = StatusGodweapon} = Player,
    #status_godweapon{
        lv = Lv, exp = Exp,
        illusion_id = IllusionId, attr = Attr, skills = Skills,
        combat = Combat,  display_status = DisplayStatus
    } = StatusGodweapon,
    Args = [Lv, Exp, IllusionId,  Attr, Combat, DisplayStatus, Skills],
    {ok, BinData} = pt_169:write(Cmd, Args),
    lib_server_send:send_to_sid(Sid, BinData);

%% 幻化神兵
handle(Cmd = 16903, Player, [IllusionId]) ->
    #player_status{sid = Sid, id = RoleId, status_godweapon = StatusGodweapon, figure = Figure} = Player,
   
    case lib_godweapon:illusion_figure(RoleId, StatusGodweapon, IllusionId) of
        {ok, NewStatusGodweapon} ->
            NewFigure = Figure#figure{god_equip_model = [{?MODEL_PART_WEAPON, NewStatusGodweapon#status_godweapon.figure_id * NewStatusGodweapon#status_godweapon.display_status}]},
            NewPlayer = Player#player_status{status_godweapon = NewStatusGodweapon, figure = NewFigure},
            lib_role:update_role_show(RoleId, [{figure, NewFigure}]), 
            %% 通知场景玩家
            lib_godweapon:broadcast_to_scene(NewPlayer), 
            {ok, BinData} = pt_169:write(Cmd, [?SUCCESS, IllusionId]),
            lib_server_send:send_to_sid(Sid, BinData);
        {fail, ErrorCode} ->
            {ok, BinData} = pt_169:write(16900, [ErrorCode]),
            lib_server_send:send_to_sid(Sid, BinData),
            NewPlayer = Player
    end,
   
    {ok, NewPlayer};

%% 显示神兵
%% Type: 0: 隐藏 1: 显示
handle(16904, Player, [Type]) ->
    lib_godweapon:change_display_status(Player, Type);

%% 升级
handle(16905, Player, [GoodId, GoodNum]) ->
    lib_godweapon:upgrade_lv(Player, GoodId, GoodNum);

%% 化形升星
handle(16906, Player, [Id]) ->
    lib_godweapon:upgrade_star(Player, Id);

%% 化形界面信息
handle(Cmd = 16907, Player, _Data) ->
    #player_status{sid = Sid, status_godweapon = StatusGodweapon} = Player,
    #status_godweapon{
       illusion_id = IllusionId,       %%幻化形象id
       figure_list = FigureList
    } = StatusGodweapon,
    List = [{Id, Star} || #godweapon_figure{id = Id, star = Star} <- FigureList],
    {ok, BinData} = pt_169:write(Cmd, [?SUCCESS, IllusionId, List]),
    lib_server_send:send_to_sid(Sid, BinData);
%% 化形激活
handle(_Cmd = 16908, Player, [Id]) ->
    lib_godweapon:active_figure(Player, Id);

%% 化形详细信息
handle(Cmd = 16909, Player, [Id]) ->
    #player_status{sid = Sid, status_godweapon = StatusGodweapon} = Player,
    #status_godweapon{figure_list = FigureList} = StatusGodweapon,
    case lists:keyfind(Id, #godweapon_figure.id, FigureList) of
        #godweapon_figure{star = Star, attr = Attr, combat = Combat} ->
            {ok, BinData} = pt_169:write(Cmd, [?SUCCESS, Id, Star, Attr, Combat]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip %% 未激活不处理
    end;

%% 使用剑灵
handle(Cmd = 16910, Player, [GTypeId]) ->
    [{_, OwnNum}] = lib_goods_api:get_goods_num(Player, [GTypeId]),
    if
        OwnNum =< 0 -> NewPlayer = Player, ErrorCode = ?ERRCODE(err169_not_enough_cost) ;
        true ->
            case lib_godweapon:use_goods(Player, GTypeId, OwnNum) of
                {ok, ErrorCode, NewPlayer} -> skip;
                {fail, ErrorCode, NewPlayer} -> skip
            end
    end,
    {ok, BinData} = pt_169:write(Cmd, [ErrorCode, GTypeId]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

%% 剑灵使用次数
handle(Cmd = 16911, Player, _) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    GTypeIds = data_godweapon:get_feather_ids(),
    CounterList = mod_counter:get_count(RoleId, ?MOD_GOODS, GTypeIds),
    F = fun(GTypeId) ->
        case lists:keyfind(GTypeId, 1, CounterList) of
            {GTypeId, Times} -> skip;
            _ -> Times = 0
        end,
        MaxTimes = lib_godweapon:get_feather_max_times(GTypeId, RoleLv),
        {GTypeId, Times, MaxTimes}
    end,
    TimesL = lists:map(F, GTypeIds),
    {ok, BinData} = pt_169:write(Cmd, [TimesL]),
    lib_server_send:send_to_sid(Sid, BinData);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
