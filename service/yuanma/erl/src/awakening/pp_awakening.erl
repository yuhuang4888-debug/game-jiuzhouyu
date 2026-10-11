%%-----------------------------------------------------------------------------
%% @Module  :       pp_awakening
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-08
%% @Description:    天命觉醒
%%-----------------------------------------------------------------------------
-module(pp_awakening).

-include("server.hrl").
-include("awakening.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("common.hrl").

-export([handle/3]).

handle(Cmd = 16400, Player, []) ->
    #player_status{sid = Sid, awakening = AwakeningStatus} = Player,
    #awakening{
        active_ids = ActiveIds
    } = AwakeningStatus,
    {ok, BinData} = pt_164:write(Cmd, [ActiveIds]),
    lib_server_send:send_to_sid(Sid, BinData);

handle(Cmd = 16401, Player, [CellId]) ->
    #player_status{sid = Sid, tid = Tid, id = RoleId, exp = Exp, figure = Figure, awakening = AwakeningStatus} = Player,
    {ErrorCode, NewPlayer} = case lib_awakening:check_active_cell(AwakeningStatus, Tid, Figure#figure.turn, Figure#figure.lv, CellId) of
        {ok, #awakening_cell_cfg{task_id = _TaskId, priority_consume = PriorityConsume, exp_consume = ExpConsume}} ->
            case lib_goods_api:cost_object_list(Player, PriorityConsume, awakening, "") of
                {true, NewPlayerTmp} ->
                    NewAwakeningStatusTmp = lib_awakening:active_cell(AwakeningStatus, CellId),

                    %% 日志
                    lib_log_api:log_awakening(RoleId, CellId, PriorityConsume),

                    db:execute(io_lib:format(?sql_insert_role_awakening, [RoleId, CellId])),

                    NewPlayerStatus = lib_player:count_player_attribute(NewPlayerTmp#player_status{awakening = NewAwakeningStatusTmp}),
                    lib_player:send_attribute_change_notify(NewPlayerStatus, ?NOTIFY_ATTR),
                    %% 触发任务
                    lib_task_api:awakening(RoleId, Figure#figure.lv),
                    {?SUCCESS, NewPlayerStatus};
                {false, _Code, NewPlayerTmp} ->
                    case Exp >= ExpConsume of
                        true ->
                            NewPlayerTmp1 = lib_player:deduct_exp(NewPlayerTmp, ExpConsume),
                            NewAwakeningStatusTmp = lib_awakening:active_cell(AwakeningStatus, CellId),

                            %% 日志
                            lib_log_api:log_awakening(RoleId, CellId, [{?TYPE_EXP, 0, ExpConsume}]),

                            db:execute(io_lib:format(?sql_insert_role_awakening, [RoleId, CellId])),

                            NewPlayerStatus = lib_player:count_player_attribute(NewPlayerTmp1#player_status{awakening = NewAwakeningStatusTmp}),
                            lib_player:send_attribute_change_notify(NewPlayerStatus, ?NOTIFY_ATTR),
                            %% 触发任务
                            lib_task_api:awakening(RoleId, Figure#figure.lv),
                            {?SUCCESS, NewPlayerStatus};
                        false ->
                            {?ERRCODE(err164_consume_not_enough), NewPlayerTmp}
                    end
            end;
        {false, Code} -> {Code, Player}
    end,
    {ok, BinData} = pt_164:write(Cmd, [ErrorCode, CellId]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, battle_attr, NewPlayer};

handle(_Cmd, _Player, _Data) ->
    {error, "pp_awakening no match~n"}.

