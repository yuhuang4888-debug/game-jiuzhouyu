%%-----------------------------------------------------------------------------
%% @Module  :       pp_arbitrament.erl
%% @Author  :       
%% @Email   :       j-som@foxmail.com
%% @Created :       2019-01-03
%% @Description:    圣裁
%%-----------------------------------------------------------------------------

-module (pp_arbitrament).
-include ("common.hrl").
-include ("server.hrl").
-include ("errcode.hrl").
-include ("arbitrament.hrl").
-include ("predefine.hrl").

-export ([handle/3]).

handle(13901, PS, []) ->
    lib_arbitrament:get_arbitrament_list(PS);

handle(13902, #player_status{sid = Sid} = PS, [WeaponId]) ->
    case lib_arbitrament:active_arbitrament(PS, WeaponId) of 
        {true, NPS, Arbitrament} ->
            #arbitrament{lv = Lv, state = State} = Arbitrament,
            lib_server_send:send_to_sid(Sid, pt_139, 13902, [1, WeaponId, Lv, State]),
            {ok, NPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_139, 13902, [Res, WeaponId, 0, 0])
    end;

handle(13903, #player_status{sid = Sid} = PS, [WeaponId]) ->
    case lib_arbitrament:loop_arbitrament_score(PS, WeaponId) of 
        {true, NPS, No, ScoreAdd} ->
            lib_server_send:send_to_sid(Sid, pt_139, 13903, [1, No, ScoreAdd, WeaponId]),
            {ok, NPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_139, 13903, [Res, 0, 0, WeaponId])
    end;

handle(13904, #player_status{sid = Sid} = PS, [WeaponId]) ->
    case lib_arbitrament:loop_arbitrament(PS, WeaponId) of 
        {true, NPS, Arbitrament, ArbitramentLoop, No, ScoreAdd} ->
            #arbitrament{lv = Lv, score = Score, state = State} = Arbitrament,
            #arbitrament_loop{loop_times = LoopTimes, utime = UTime} = ArbitramentLoop,
            lib_server_send:send_to_sid(Sid, pt_139, 13904, [1, No, ScoreAdd, WeaponId, Lv, Score, State, LoopTimes, UTime]),
            {ok, NPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_139, 13904, [Res, 0, 0, WeaponId, 0, 0, 0, 0, 0])
    end;

% handle(13905, #player_status{sid = Sid} = PS, [WeaponId]) ->
%     case lib_arbitrament:equip_arbitrament(PS, WeaponId) of 
%         {true, NPS} ->
%             lib_server_send:send_to_sid(Sid, pt_139, 13905, [1, WeaponId, 1]),
%             {ok, NPS};
%         {false, Res} ->
%             lib_server_send:send_to_sid(Sid, pt_139, 13905, [Res, WeaponId, 0])
%     end;

handle(CMD, _PS, Args) ->
    ?ERR("protocol ~p, ~p nomatch ~n", [CMD, Args]).