%%%--------------------------------------
%%% @Module  : pp_wing
%%% @Author  : fwx
%%% @Created : 2017.10.27
%%% @Description:  翅膀
%%%--------------------------------------
-module(pp_wing).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("wing.hrl").
-include("def_module.hrl").

%% 翅膀信息
handle(Cmd = 16102, Player, _Data) ->
    #player_status{sid = Sid, status_wing = StatusWing} = Player,
    #status_wing{
        lv = Lv, exp = Exp,
        illusion_id = IllusionId, attr = Attr, skills = Skills,
        combat = Combat,  display_status = DisplayStatus
    } = StatusWing,
    BinData = [Lv, Exp, IllusionId,  Attr, Combat, DisplayStatus, Skills],
    lib_server_send:send_to_sid(Sid, pt_161, Cmd, BinData);

%% 幻化翅膀
handle(Cmd = 16103, Player, [IllusionId]) ->
    #player_status{sid = Sid, id = RoleId, status_wing = StatusWing, figure = Figure} = Player,    
    case lib_wing:illusion_figure(RoleId, StatusWing, IllusionId) of
        {ok, NewStatusWing} ->
            NewFigure = Figure#figure{wing_figure = NewStatusWing#status_wing.figure_id * NewStatusWing#status_wing.display_status},
            NewPlayer = Player#player_status{status_wing = NewStatusWing, figure = NewFigure},
            %% 更新缓存里的翅膀形象id
            lib_role:update_role_show(RoleId, [{figure, NewFigure}]), 
            %% 通知场景玩家
            lib_wing:broadcast_to_scene(NewPlayer),  
            lib_server_send:send_to_sid(Sid, pt_161, Cmd, [?SUCCESS, IllusionId]);
        {fail, ErrorCode} ->
            lib_server_send:send_to_sid(Sid, pt_161, 16100, [ErrorCode]),
            NewPlayer = Player;
        _ ->  NewPlayer = Player  
    end,
    {ok, NewPlayer};

%% 显示翅膀
%% Type: 0: 隐藏 1: 显示
handle(16104, Player, [Type]) ->
    lib_wing:change_display_status(Player, Type);

%% 升级
%% Type: 1：一键升级 0：使用一个
handle(16105, Player, [GoodId, Type]) ->    
    lib_wing:upgrade_lv(Player, GoodId, Type);

%% 化形升星
%% Id: 化形Id
handle(16106, Player, [Id]) ->
    lib_wing:upgrade_star(Player, Id);

%% 化形界面信息
handle(Cmd = 16107, Player, _Data) ->
    #player_status{sid = Sid, status_wing = StatusWing} = Player,
    #status_wing{
       illusion_id = IllusionId,       %%幻化形象id
       figure_list = FigureList
    } = StatusWing,
    List = [{Id, Star} || #wing_figure{id = Id, star = Star} <- FigureList],
    {ok, BinData} = pt_161:write(Cmd, [?SUCCESS, IllusionId, List]),
    lib_server_send:send_to_sid(Sid, BinData);
%% 化形激活
handle(_Cmd = 16108, Player, [Id]) ->
    lib_wing:active_figure(Player, Id);

%% 化形详细信息
handle(Cmd = 16109, Player, [Id]) ->
    #player_status{sid = Sid, status_wing = StatusWing} = Player,
    #status_wing{figure_list = FigureList} = StatusWing,
    case lists:keyfind(Id, #wing_figure.id, FigureList) of
        #wing_figure{star = Star, attr = Attr, combat = Combat} ->
            {ok, BinData} = pt_161:write(Cmd, [?SUCCESS, Id, Star, Attr, Combat]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip %% 未激活不处理
    end;

%% 使用仙羽
handle(Cmd = 16110, Player, [GTypeId]) ->
    [{_, OwnNum}] = lib_goods_api:get_goods_num(Player, [GTypeId]),
    if
        OwnNum =< 0 -> NewPlayer = Player, ErrorCode = ?ERRCODE(err161_not_enough_cost);
        true ->
            case lib_wing:use_goods(Player, GTypeId, OwnNum) of
                {ok, ErrorCode, NewPlayer} -> skip;
                {fail, ErrorCode, NewPlayer} -> skip
            end
    end,
    {ok, BinData} = pt_161:write(Cmd, [ErrorCode, GTypeId]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

%% 仙羽使用次数
handle(Cmd = 16111, Player, _) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    GTypeIds = data_wing:get_feather_ids(),
    CounterList = mod_counter:get_count(RoleId, ?MOD_GOODS, GTypeIds),
    F = fun(GTypeId) ->
        case lists:keyfind(GTypeId, 1, CounterList) of
            {GTypeId, Times} -> skip;
            _ -> Times = 0
        end,
        MaxTimes = lib_wing:get_feather_max_times(GTypeId, RoleLv),
        {GTypeId, Times, MaxTimes}
    end,
    TimesL = lists:map(F, GTypeIds),
    {ok, BinData} = pt_161:write(Cmd, [TimesL]),
    lib_server_send:send_to_sid(Sid, BinData);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
