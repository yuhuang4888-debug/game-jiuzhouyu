%% ---------------------------------------------------------------------------
%% @doc 个性装扮
%% @author yxf
%% @since  2017-10-31
%% @Description 个性装扮主要业务
%% ---------------------------------------------------------------------------
-module(pp_dress_up).
-export([handle/3]).
-include("server.hrl").
-include("common.hrl").
-include("rec_dress_up.hrl").

%%获取装扮列表
handle(11200, PS, [TargetDressType]) ->
    #player_status{dress_up = StatusDressUp, sid = Sid, original_attr = OriginalAttr} = PS,
    #status_dress_up{dress_list = DressList} = StatusDressUp,
    case lists:keyfind(TargetDressType, #dress.type, DressList) of 
        #dress{active_list = _ActiveList, use_id = UseId} -> 
            Fun = fun({DressId, Level, _Time}) ->
                DressAttrL = lib_dress_up:count_one_dress_up_attr(TargetDressType, DressId, Level),
                CurPower = lib_player:calc_partial_power(OriginalAttr, 0, DressAttrL),
                NextDressAttrL = lib_dress_up:count_one_dress_up_attr(TargetDressType, DressId, Level + 1),
                case NextDressAttrL of
                    [] -> NextPower = 0;
                     _ -> NextPower = lib_player:calc_expact_power(OriginalAttr, 0, NextDressAttrL)
                end,
                 {DressId, Level, CurPower, NextPower}
            end,    
            ActiveList = lists:map(Fun, _ActiveList);
        _ ->
            ActiveList = [], UseId = 0
    end,
    %?PRINT("UseId ~p~n", [UseId]),
    lib_server_send:send_to_sid(Sid, pt_112, 11200, [TargetDressType, UseId, ActiveList]);

%%激活
handle(11201, PS, [DressType, DressId]) ->
    #player_status{sid = Sid} = PS,
    case lib_dress_up:active_dress_up(PS, DressType, DressId) of 
        {true, NPS, NLv, CurPower, NextPower} ->
            lib_server_send:send_to_sid(Sid, pt_112, 11201, [1, DressType, DressId, NLv, CurPower, NextPower]),
            {ok, NPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_112, 11201, [Res, DressType, DressId, 0, 0, 0])
    end;

%% 使用
handle(11202, PS, [DressType, DressId]) ->
    #player_status{sid = Sid} = PS,
    case lib_dress_up:use_dress(PS, DressType, DressId) of 
        {true, NPS} ->
            lib_server_send:send_to_sid(Sid, pt_112, 11202, [1, DressType, DressId]),
            {ok, NPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_112, 11202, [Res, DressType, DressId])
    end;

%% 卸下
handle(11203, PS, [DressType, DressId]) ->
    #player_status{sid = Sid} = PS,
    case lib_dress_up:unuse_dress(PS, DressType, DressId) of 
        {true, NPS} ->
            lib_server_send:send_to_sid(Sid, pt_112, 11203, [1, DressType, DressId]),
            case DressType of
                ?DRESS_UP_PICTURE ->
                    NewUseId = binary_to_integer(lib_career:get_picture(0)),
                    handle(11202, NPS, [DressType, NewUseId]);
                _ ->
                    skip
            end,
            {ok, NPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_112, 11203, [Res, DressType, DressId])
    end;

%% 查看某个装扮的期待战力
handle(11205, Player, [DressType, DressId]) ->
    #player_status{sid = Sid, original_attr = OriginalAttr} = Player,
    ActiveAttrL = lib_dress_up:count_one_dress_up_attr(DressType, DressId, 1),
    NextPower = lib_player:calc_expact_power(OriginalAttr, 0, ActiveAttrL),
    ?PRINT("~n11205:~p~n", [{DressType, DressId, NextPower}]),
    lib_server_send:send_to_sid(Sid, pt_112, 11205, [DressType, DressId, NextPower]);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
