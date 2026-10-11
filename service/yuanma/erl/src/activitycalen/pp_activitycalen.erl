%%%--------------------------------------
%%% @Module  : pp_activitycalen
%%% @Author  : xiaoxiang
%%% @Created : 2017-03-01
%%% @Description:  活动日历
%%%--------------------------------------
-module(pp_activitycalen).
-export([
        handle/3
    ]).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("activitycalen.hrl").

% 查询活动活跃度次数
handle(15701, Player, [Type]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    OnHookTime = 0,
    %?PRINT("15705, ~p ~n", [OnHookTime]),
    mod_activitycalen:ask_activity_num(RoleId, Lv, OnHookTime, Type);

% %% 查询活动状态
% handle(15702, Player, _Data) ->
%     % ?PRINT("15702,  ~n", []),
%     lib_activitycalen:ask_activity_status(Player);

%% 查询活跃度奖励
handle(15703, Player, _Data) ->
    % ?PRINT("15703,  ~n", []),
    lib_activitycalen:ask_live_reward(Player);

% 领取奖励
handle(15705, Player, [Id]) ->
    % ?PRINT("15705, Id:~p  ~n", [Id]),
    lib_activitycalen:get_live_reward(Player, Id);

%% 查询玩家活跃度形象
handle(15709, Player, _Data) ->
    lib_liveness:get_player_liveness(Player);

%% 玩家活跃度升级
handle(15710, Player, _Data) ->
    lib_liveness:liveness_lv_up(Player);

% %% 更换活跃度形象
% handle(15711, Player, [Id]) ->
%     lib_liveness:change_liveness_figure(Player, Id);

% %% 显示或隐藏活跃度形象
% handle(15713, Player, [Type]) ->
%     lib_liveness:display_liveness_figure(Player, Type);

%% 活跃度找回信息
handle(Cmd = 15715 , #player_status{sid = Sid} = Player, []) ->
    case lib_liveness:report_res_act(Player) of
        {ok, NewPs, ResList} ->
%%            ?MYLOG("cym", "Live Back ~p~n", [ResList]),
            lib_server_send:send_to_sid(Sid, pt_157, Cmd, [ResList]),
            {ok, NewPs};
        {false, Res} ->
%%            ?MYLOG("cym", "Res ~p~n", [Res]),
            lib_server_send:send_to_sid(Sid, pt_157, 15700, [Res]),
            {ok, Player}
    end;

%% 活跃度找回
handle(Cmd = 15716 , #player_status{sid = Sid} = Player, [ActId, SubId, Times]) ->
    case lib_liveness:liveness_back(Player, ActId, SubId, Times) of
        {ok, NewPs, {NewActId, NewSubId, LeftTimes}} ->
            ?DEBUG("~p~n", [{ActId, SubId, LeftTimes}]),
            lib_server_send:send_to_sid(Sid, pt_157, Cmd, [NewActId, NewSubId, LeftTimes]),
            {ok, NewPs};
        {false, Res} ->
            ?DEBUG("ErrCod ~p~n", [Res]),
            lib_server_send:send_to_sid(Sid, pt_157, 15700, [Res]),
            {ok, Player}
    end;

%% 活跃度找回
handle(Cmd = 15717 , #player_status{sid = Sid} = Player, [ActId, SubId, Times]) ->
    case lib_liveness:liveness_back(Player, ActId, SubId, Times) of
        {ok, NewPs, {NewActId, NewSubId, LeftTimes}} ->
            ?DEBUG("~p~n", [{ActId, SubId, LeftTimes}]),
            lib_server_send:send_to_sid(Sid, pt_157, Cmd, [NewActId, NewSubId, LeftTimes]),
            {ok, NewPs};
        {false, Res} ->
            ?DEBUG("ErrCod ~p~n", [Res]),
            lib_server_send:send_to_sid(Sid, pt_157, 15700, [Res]),
            {ok, Player}
    end;

%% 报名情况
handle(15718 , Player, []) ->
    lib_act_sign_up:get_sign_up_msg(Player),
    {ok, Player};

%% 报名
handle(15719 , Player, [Mod, SubMod, ActId]) ->
    NewPs = lib_act_sign_up:sign_up(Player, Mod, SubMod, ActId),
    {ok, NewPs};

%%%% 活跃度领取 废弃
%%handle(Cmd = 15717 , #player_status{sid = Sid, figure = _F} = Player, [ActId, SubId]) ->
%%    case lib_liveness:get_live(Player, ActId, SubId) of
%%        {ok, NewPs, {NewActId, NewSubId, AddLive}} ->
%%            ?DEBUG("~p~n", [{ActId, SubId, AddLive}]),
%%            lib_server_send:send_to_sid(Sid, pt_157, Cmd, [NewActId, NewSubId, AddLive]),
%%            {ok, NewPs};
%%        {false, Res} ->
%%            ?DEBUG("ErrCod ~p~n", [Res]),
%%            lib_server_send:send_to_sid(Sid, pt_157, 15700, [Res]),
%%            {ok, Player}
%%    end;

%% 领取报名奖励
handle(15720 , Player, [Mod, SubMod, ActId]) ->
    NewPs = lib_act_sign_up:receive_sign_up_reward(Player, Mod, SubMod, ActId),
    {ok, NewPs};

%% 限时活动开启提醒
handle(15721, Player, []) ->
    #player_status{
        id = RoleId,
        figure = #figure{lv = Lv},
        act_sign_up = #act_sign_up{sign_up_list = SignUpList}
    } = Player,
    mod_activitycalen:send_act_remind(RoleId, Lv, SignUpList),
    {ok, Player};

%% 限时活动提醒开关
handle(15722, Player, [IsRemind]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    mod_activitycalen:set_act_remind(RoleId, Lv, IsRemind),
    {ok, Player};

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.