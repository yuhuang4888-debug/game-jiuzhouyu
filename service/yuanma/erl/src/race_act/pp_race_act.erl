%%%------------------------------------
%%% @Module  : pp_race_act
%%% @Author  : zengzy
%%% @Created : 2017-12-20
%%% @Description: 竞榜的活动
%%%------------------------------------

-module(pp_race_act).

-compile(export_all).

-include("server.hrl").
-include("common.hrl").
-include("race_act.hrl").
-include("errcode.hrl").

%%请求活动状态
handle(33800, Player, []) ->
    % ?PRINT("33800~n",[]),
    {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
    SendList = lib_race_act_util:combine_opening_act_list(OpenList,ShowList,[]),
    ?PRINT("~p~n",[SendList]),
    {ok, Bin} = pt_338:write(33800, [SendList]),
    lib_server_send:send_to_uid(Player#player_status.id, Bin);

%%界面信息
handle(33801, #player_status{id = RoleId, server_id = ServerId}, [Type,SubType]) ->
    % ?PRINT("33801 Type:~p,SubType:~p~n",[Type,SubType]),
    case data_race_act:get_act_info(Type,SubType) of
        [] -> skip;
        _-> mod_race_act:cast_center([{send_info,ServerId,RoleId,Type,SubType}])
    end;

%%榜单信息
handle(33802, Player, [Type,SubType]) ->
    % ?PRINT("33802~n",[]),
    case data_race_act:get_act_info(Type,SubType) of
        [] -> skip;
        _->
            #race_act_data{score=Score} = lib_race_act:get_role_race_info(Type,SubType,Player),
            RankRole = lib_race_act:make_rank_role(Player,Score),
            mod_race_act:cast_center([{get_type_rank,Type,SubType,RankRole}])
    end;

%%抽奖
handle(33803, #player_status{id = RoleId, server_id = ServerId}, [Type,SubType,Times]) ->
    case data_race_act:get_act_info(Type,SubType) of
        [] -> skip;
        _-> mod_race_act:cast_center([{treasure_draw,ServerId,RoleId,Type,SubType,Times}])
    end;

%%领取阶段奖励
handle(33804, #player_status{id = RoleId, server_id = ServerId}, [Type,SubType,RewardId]) ->
    case data_race_act:get_act_info(Type,SubType) of
        [] -> skip;
        _-> mod_race_act:cast_center([{get_stage_reward,ServerId,RoleId,Type,SubType,RewardId}])
    end;

% %%许愿界面
% handle(33805, Player, [Type,SubType,CostType]) ->
% 	% ?PRINT("33805~n",[]),
% 	case data_race_act:get_act_info(Type,SubType) of
% 		[] -> skip;
% 		_ActInfo->
% 			IsOpen = lib_race_act_util:is_open(Type,SubType),	
% 			Data = lib_race_act:get_role_race_info(Type,SubType,Player),
% 			#race_act_data{score=Score} = Data,
% 			{Times,_} = lib_race_act:draw_get_info(Data,Type,CostType),
% 			RewardList = data_race_act:get_act_reward_info_ids(Type,SubType,CostType),
% 			% ?PRINT("~p:~p:~p:~p~n",[IsOpen, Score, Times, RewardList]),
%     		{ok, Bin} = pt_338:write(33805, [Type, SubType, IsOpen, Score, Times, RewardList]),
%     		lib_server_send:send_to_uid(Player#player_status.id, Bin)
% 	end;

% %%许愿
% handle(33806, Player, [Type,SubType,CostType]) ->
% 	% ?PRINT("33806~n",[]),	
%     {ProData, LastPlayer} = case lib_race_act:wish_draw(Player, Type, SubType, CostType) of
%         {false, Reason} -> ?PRINT("~p~n",[Reason]),
%             {[Type, SubType, CostType, Reason, []], Player};
%         {ok, NewPlayer, RewardIdList} ->
%             F = fun(RewardId) ->
%                 case data_race_act:get_act_reward_info(Type, SubType, CostType, RewardId) of
%                     #base_race_act_reward{reward = Reward} -> {RewardId, Reward};
%                     _ -> {RewardId, []}
%                 end
%             end,
%             RewardInfoList = lists:map(F, RewardIdList),
%             {[Type, SubType, CostType, ?SUCCESS, RewardInfoList], NewPlayer}
%     end,
%     {ok, BinData} = pt_338:write(33806, ProData),
%     lib_server_send:send_to_sid(Player#player_status.sid, BinData),
%     {ok, LastPlayer};

% %%许愿秘钥数量和需重置量
% handle(33807, Player, [Type,SubType]) ->
% 	% ?PRINT("33807~n",[]),
% 	case data_race_act:get_act_info(Type,SubType) of
% 		[] -> skip;
% 		_ActInfo->
% 			{KeyNum,NeedRecharge,NewPS} = lib_race_act:get_wish_num(Type,SubType,Player),
% 			?PRINT("~p:~p~n",[KeyNum,NeedRecharge]),
%     		{ok, Bin} = pt_338:write(33807, [Type, SubType, KeyNum, NeedRecharge]),
%     		lib_server_send:send_to_uid(Player#player_status.id, Bin),
%     		{ok, NewPS}
% 	end;

handle(_Cmd, _Player, _Data) ->
    {error, "pp_race_act no match~n"}.