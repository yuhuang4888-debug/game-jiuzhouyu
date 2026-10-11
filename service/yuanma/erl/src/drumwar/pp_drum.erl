%%%===================================================================
%%% @author zmh
%%% @doc 擂台赛  元宝擂台(钻石争霸战)
%%% @end
%%% @update by zzy 2017-11-08
%%%===================================================================
-module(pp_drum).
-include("server.hrl").
-include("common.hrl").
-include("drumwar.hrl").

-export([handle/3]).

%%活动状态
handle(13700,Status,[])->
	?PRINT("13700~n",[]),
	#player_status{sid=Sid}=Status,
	lib_role_drum:get_clock(Sid),
	{ok,Status};

%%请求展示面板
handle(13701,Status,[])->
	?PRINT("13701~n",[]),
	#player_status{id=Uid,sid=Sid,role_drum=RoleDrum}=Status,
	lib_role_drum:get_sign(Uid,RoleDrum,Sid),
	{ok,Status};

%%报名
handle(13702,Status,[])->
	?PRINT("13702~n",[]),
	#player_status{sid=Sid}=Status,
	case lib_role_drum:sign_up(Status) of
		{ok,NStatus}->
			{ok,NStatus};
		{false,Err}->?PRINT("error~p~n",[Err]),
			{ok,Bin} = pt_137:write(13702,[Err]),
			lib_server_send:send_to_sid(Sid,Bin),
			{ok,Status}
	end;

%%请求钻石大战阶段的信息
handle(13703,Status,[])->
	lib_role_drum:get_match_sub_state(Status);

%%进入准备场景
handle(13704,Status,[])->
	?PRINT("13704~n",[]),
	#player_status{sid=Sid}=Status,
	case lib_role_drum:enter_ready(Status) of
		ok->
			ignore;
		{false,Err}->
			?PRINT("13704 Err ~p~n",[Err]),
			{ok,Bin}=pt_137:write(13704,[Err]),
			lib_server_send:send_to_sid(Sid,Bin)
	end,
	{ok,Status};

%%命数购买
handle(13706,Status,[Num])->
	?PRINT("13706~n",[]),
	#player_status{sid=Sid}=Status,
	case lib_role_drum:buy_live(Num,Status) of
		{ok,_CurNum,NStatus}->
			{ok,NStatus};
		{false,Err}->?PRINT("error~p~n",[Err]),
			{ok,Bin}=pt_137:write(13706,[Err,0]),
			lib_server_send:send_to_sid(Sid,Bin),
			{ok,Status}
	end;

%%退出
handle(13707,Status,[Type])->
	?PRINT("13707~n",[]),
	#player_status{sid=Sid}=Status,
	case lib_role_drum:leave_drum(Type,Status) of
		{ok,NStatus}->
			{ok,Bin}=pt_137:write(13707,[1]),
            lib_server_send:send_to_sid(Sid,Bin),
			{ok,NStatus};
		{false,Err}->
			{ok,Bin}=pt_137:write(13707,[Err]),
			lib_server_send:send_to_sid(Sid,Bin),
			{ok,Status}
	end;

%% 战斗开始(暂时无用)
handle(13709, Status, []) ->
	lib_role_drum:active_mon(Status),
	{ok,Status};

%%命数请求
handle(13710,Status,[])->
	lib_role_drum:apply_live_info(Status),
	{ok,Status};

%% 战报
handle(13711,Status,[DrumID])->
	?PRINT("13711~n",[]),
	lib_role_drum:war_report(DrumID,Status),
	{ok,Status};

%% 技能
handle(13715, Status, [SKillID]) ->
	?PRINT("13715~n",[]),
	#player_status{sid=Sid}=Status,
	{Res,RemainT,NStatus} = lib_role_drum:use_skill(SKillID,Status),
	{ok,Bin} = pt_137:write(13715,[Res,SKillID,RemainT]),
	lib_server_send:send_to_sid(Sid,Bin),
	{ok,NStatus};

%%竞猜面板
handle(13719,Status,[])->
	?PRINT("13719~n",[]),
	lib_role_drum:fetch_guess(Status),
	{ok,Status};

%%竞猜
handle(13720,Status,[Type,Uid,ActId])->
	?PRINT("13720~p~n",[Uid]),
	#player_status{sid=Sid}=Status,
	case lib_role_drum:choose_drum(Type,Uid,ActId,Status) of
		{ok,NStatus}->
			{ok,NStatus};
		{false,Err}->?PRINT("error~p~n",[Err]),
			{ok, Bin} = pt_137:write(13720,[Err,Uid,0]),
			lib_server_send:send_to_sid(Sid,Bin),
			{ok,Status}
	end;

%%竞猜记录
handle(13721,Status,[])->
	#player_status{sid=Sid, role_drum = RoleDrum}=Status,
	{ok, Bin} = mod_drumwar_mgr:pack_13721(RoleDrum#role_drum.choice),
	lib_server_send:send_to_sid(Sid, Bin);

%%领取竞猜奖励
handle(13723,Status,[Zid, Act, SuprId]) ->
	case lib_role_drum:get_choice_reward(Status, Zid, Act, SuprId) of 
		{ok, GuessType, NRewardSt, NewStatus} ->
			{ok, Bin} = pt_137:write(13723, [1, Zid, Act, SuprId, GuessType, NRewardSt]),
			?PRINT("get_choice_reward Res ~p~n", [1]),
			lib_server_send:send_to_sid(Status#player_status.sid, Bin),
			{ok, NewStatus};
		{false, Res} ->
			{ok, Bin} = pt_137:write(13723, [Res, Zid, Act, SuprId, 0, 0]),
			lib_server_send:send_to_sid(Status#player_status.sid, Bin)
	end;

handle(_Cmd, _Player, _Data) ->
	% util:errlog("M:~p, L:~p _Cmd:~p _Data:~p ~n", [?MODULE, ?LINE, _Cmd, {_Data,_Player#player_status.scene_old,_Player#player_status.copy_id_old}]),
	ok.