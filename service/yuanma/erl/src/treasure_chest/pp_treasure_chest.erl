%%-----------------------------------------------------------------------------
%% @Module  :       pp_treasure_chest
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-25
%% @Description:    青云夺宝
%%-----------------------------------------------------------------------------
-module(pp_treasure_chest).

-include("treasure_chest.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").

-export([handle/3]).

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = data_treasure_chest:get_cfg(6),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.

%% 夺宝界面
do_handle(Cmd = 41401, PlayerStatus, _) ->
    #player_status{sid = Sid, treasure_chest = PlayerTreasureChest} = PlayerStatus,
    #player_treasure_chest{times = Times, receive_list = ReceiveList, etime = Etime} = PlayerTreasureChest,
    NowTime = utime:unixtime(),
    case NowTime =< Etime of
        true ->
            RealTimes = Times,
            RealReceiveList = ReceiveList;
        false ->
            RealTimes = 0,
            RealReceiveList = []
    end,
    {ok, BinData} = pt_414:write(Cmd, [RealTimes, RealReceiveList]),
    lib_server_send:send_to_sid(Sid, BinData);

% %% 领取阶段奖励
% do_handle(Cmd = 41403, PlayerStatus, [RewardTimes]) ->
%     #player_status{sid = Sid, id = RoleId, treasure_chest = PlayerTreasureChest} = PlayerStatus,
%     #player_treasure_chest{times = Times, receive_list = ReceiveList, etime = Etime} = PlayerTreasureChest,
%     NowTime = utime:unixtime(),
%     case NowTime =< Etime of
%         true ->
%             case Times >= RewardTimes of
%                 true ->
%                     case lists:member(RewardTimes, ReceiveList) of
%                         false ->
%                             case data_treasure_chest:get_reward(RewardTimes) of
%                                 Reward when Reward =/= [] ->
%                                     case lib_goods_api:can_give_goods(PlayerStatus, Reward) of
%                                         true ->
%                                             NewReceiveList = [RewardTimes|ReceiveList],
%                                             db:execute(io_lib:format(?sql_update_player_treasure_chest,
%                                                 [RoleId, Times, util:term_to_string(NewReceiveList), Etime])),

%                                             NewPlayerStatus = lib_goods_api:send_reward(PlayerStatus, Reward, treasure_chest, 0, 1),

%                                             {ok, BinData} = pt_414:write(Cmd, [?SUCCESS]),
%                                             lib_server_send:send_to_sid(Sid, BinData),

%                                             NewPlayerTreasureChest = PlayerTreasureChest#player_treasure_chest{receive_list = NewReceiveList},
%                                             {ok, NewPlayerStatus#player_status{treasure_chest = NewPlayerTreasureChest}};
%                                         _ ->
%                                             send_error_code(Sid, ?ERRCODE(err150_no_cell))
%                                     end;
%                                 _ ->
%                                     send_error_code(Sid, ?ERRCODE(missing_config))
%                             end;
%                         true ->
%                             send_error_code(Sid, ?ERRCODE(err414_has_receive))
%                     end;
%                 false -> skip
%             end;
%         false -> skip
%     end;

%% 活动状态
do_handle(_Cmd = 41404, PlayerStatus, _) ->
    #player_status{id = RoleId} = PlayerStatus,
    mod_treasure_chest:send_act_info(RoleId);

do_handle(_Cmd, _PlayerStatus, _Data) ->
    {error, "pp_treasure_chest no match~n"}.

% %% 发送错误码
% send_error_code(Sid, ErrorCode) ->
%     {ok, BinData} = pt_414:write(41400, [ErrorCode]),
%     lib_server_send:send_to_sid(Sid, BinData).