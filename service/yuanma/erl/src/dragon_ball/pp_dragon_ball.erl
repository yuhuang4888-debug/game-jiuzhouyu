%% ---------------------------------------------------------------------------
%% @doc pp_dragon_ball

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/8/13
%% @deprecated
%% ---------------------------------------------------------------------------
-module(pp_dragon_ball).

%% API
-compile([export_all]).

-include("errcode.hrl").
-include("server.hrl").
-include("common.hrl").
-include("dragon_ball.hrl").

%% 获取龙珠列表
handle(14300, Player, _) ->
    lib_dragon_ball:get_dragon_ball_list(Player),
    ok;

%% 激活龙珠
handle(14301, Player, [DraBallId]) ->
    case lib_dragon_ball:active_dragon_ball(Player, DraBallId) of
        {ok, SinglePower, NextPower, NewPlayer} ->
            Errcode = ?SUCCESS;
        {false, Errcode} ->
            NewPlayer = Player,
            SinglePower = 0,
            NextPower = 0
    end,
    ?PRINT("Errcode, DraBallId,SinglePower, NextPower ~p ~n", [[Errcode, DraBallId,SinglePower, NextPower]]),
    lib_server_send:send_to_sid(Player#player_status.sid, pt_143, 14301, [Errcode, DraBallId, SinglePower, NextPower]),
    {ok, NewPlayer};

%% 升级龙珠
handle(14302, Player, [DraBallId]) ->
    case lib_dragon_ball:upgrade_dragon_ball(Player, DraBallId) of
        {ok, DraBallLv, SinglePower, NextPower, NewPlayer} ->
            Errcode = ?SUCCESS;
        {false, Errcode} ->
            DraBallLv = 0,
            NewPlayer = Player,
            SinglePower = 0,
            NextPower = 0
    end,
    ?PRINT("Errcode, DraBallId, DraBallLv, SinglePower, NextPower ~p ~n", [[Errcode, DraBallId, DraBallLv, SinglePower, NextPower]]),
    lib_server_send:send_to_sid(Player#player_status.sid, pt_143, 14302, [Errcode, DraBallId, DraBallLv, SinglePower, NextPower]),
    {ok, NewPlayer};

%% 龙珠套装列表
handle(14303, Player, []) ->
    lib_dragon_ball:send_dragon_figure_list(Player);

%% 穿戴、脱下龙珠套装
handle(14304, Player, [Type, Op]) ->
    #player_status{sid = SId} = Player,
    case lib_dragon_ball:take_dragon_figure(Player, Type, Op) of
        {ok, NewPlayer} -> Code = ?SUCCESS;
        {false, Code} -> NewPlayer = Player
    end,
    lib_server_send:send_to_sid(SId, pt_143, 14304, [Code, Type, Op]),
    {ok, NewPlayer};

%% 激活龙珠套装
handle(14305, Player, [Type, Lv]) ->
    #player_status{sid = SId} = Player,
    case lib_dragon_ball:active_dragon_figure(Player, Type, Lv) of
        {ok, NewPlayer} -> Code = ?SUCCESS;
        {false, Code} -> NewPlayer = Player
    end,
    lib_server_send:send_to_sid(SId, pt_143, 14305, [Code, Type, Lv]),
    {ok, NewPlayer};

%% 龙珠系统总战力
handle(14306, Player, []) ->
    #player_status{sid = SId} = Player,
    TotalPower = lib_dragon_ball:calc_sum_sum_power(Player),
    lib_server_send:send_to_sid(SId, pt_143, 14306, [TotalPower]);

%% 龙珠雕像总览
handle(14310, Player, []) ->
    #player_status{dragon_ball = StatusDragonBall, sid = SId, original_attr = OriginalAttr} = Player,
    #status_dragon_ball{statue = Statue} = StatusDragonBall,
    case Statue of
        ?ACTIVE -> lib_server_send:send_to_sid(SId, pt_143, 14310, [Statue, 0]);
        ?UNACTIVE ->
            StatueAttr = ?DRAGON_STATUE_ATTR,
            StatueSkill = ?DRAGON_STATUE_SKILLS,
            SkillAttr = lib_skill:get_passive_skill_attr(StatueSkill),
            AttrList = StatueAttr++SkillAttr,
            SkillPower = lib_dragon_ball:get_skill_power(StatueSkill),
            ExpectPower = lib_player:calc_expact_power(OriginalAttr, SkillPower, AttrList),
            lib_server_send:send_to_sid(SId, pt_143, 14310, [Statue, ExpectPower])
    end;

handle(14311, Player, []) ->
    lib_dragon_ball:send_star_nuclear(Player),
    {ok, Player};

handle(Cmd, _Player, _Data) ->
    ?ERR("Route Error, Cmd : ~p & Data ~p", [Cmd, _Data]),skip.