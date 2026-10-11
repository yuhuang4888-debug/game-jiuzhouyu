%% ---------------------------------------------------------------------------
%% @doc mod_territory_treasure.erl
%% @author  xlh
%% @email   
%% @since   2019.3.6
%% @deprecated 领地夺宝进程
%% ---------------------------------------------------------------------------
-module(mod_territory_treasure).

-behaviour(gen_server).

-include("territory_treasure.hrl").
-include("common.hrl").
-include("def_module.hrl").

-export([start_link/0]).

-export([init/1, handle_cast/2, handle_call/3, handle_info/2, terminate/2, code_change/3]).

-export([
		mon_be_hurt/6,
		start_act/0
		,drop_thing/3
		,enter/7
		,mon_killed/6
		,gm_start/0
		,handle_out/1
        ,calc_guild_auction/2
        ,gm_close_act/0
		,reconnect_territory_treasure/8
        ,get_act_time/3
	]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_act() ->
	gen_server:cast(?MODULE, {'start_act'}).

gm_start() ->
	gen_server:cast(?MODULE, {'gm_start'}).

enter(Scene, RoleId, RoleName, GuildId, GuildName, DunId, Code) ->
	gen_server:cast(?MODULE, {'enter', Scene, RoleId, RoleName, GuildId, GuildName, DunId, Code}).

mon_be_hurt(Scene, PoolId, CopyId, RoleId, Name, Hurt) ->
	gen_server:cast(?MODULE, {'mon_hurt', Scene, PoolId, CopyId, RoleId, Name, Hurt}).

mon_killed(Scene, PoolId, CopyId, Monid, DX, DY) ->
	gen_server:cast(?MODULE, {'mon_killed', Scene, PoolId, CopyId, Monid, DX, DY}).

drop_thing(Monid, RoleId, Reward) ->
	gen_server:cast(?MODULE, {'drop_thing', Monid, RoleId, Reward}).

handle_out(RoleId) ->
	gen_server:cast(?MODULE, {'handle_out', RoleId}).

reconnect_territory_treasure(RoleId, RoleLv, RoleName, GuildId, GuildName, Scene, PoolId, CopyId) ->
	gen_server:cast(?MODULE, {'reconnect_territory_treasure', RoleId, RoleLv, RoleName, GuildId, GuildName, Scene, PoolId, CopyId}).

calc_guild_auction(GuildListSort, CopyId) ->
    gen_server:cast(?MODULE, {'calc_guild_auction', GuildListSort, CopyId}).

gm_close_act() ->
    gen_server:cast(?MODULE, {'gm_close_act'}).

get_act_time(RoleId, GuildId, DunId) ->
    gen_server:cast(?MODULE, {'get_act_time', RoleId, GuildId, DunId}).

init([]) ->
	erlang:send_after(1000, self(), 'init_data'),
	{ok, #territory_state{rank_map = #{},reward_map = #{},other_map = #{},dun_state = #{}}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("mod_territory_treasure call Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_territory_treasure cast Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_territory_treasure Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call(_, State) -> {reply, ok, State}.

do_handle_cast({'gm_start'}, State) ->
	NewState = lib_territory_treasure_mod:gm_start(State),
	{noreply, NewState};

do_handle_cast({'enter', Scene, RoleId, RoleName, GuildId, GuildName, DunId, Code}, State) ->
	NewState = lib_territory_treasure_mod:enter(State, Scene, RoleId, RoleName, GuildId, GuildName, DunId, Code),
	{noreply, NewState};

do_handle_cast({'mon_killed', Scene, PoolId, CopyId, Monid, DX, DY}, State) ->
	NewState = lib_territory_treasure_mod:mon_killed(State, Scene, PoolId, CopyId, Monid, DX, DY),
	{noreply, NewState};

do_handle_cast({'mon_hurt', Scene, PoolId, CopyId, RoleId, Name, Hurt}, State) ->
	NewState = lib_territory_treasure_mod:mon_hurt(State, Scene, PoolId, CopyId, RoleId, Name, Hurt),
	{noreply, NewState};

do_handle_cast({'drop_thing', Monid, RoleId, Reward}, State) ->
	NewState = lib_territory_treasure_mod:drop_thing(State, Monid, RoleId, Reward),
	{noreply, NewState};

do_handle_cast({'handle_out', RoleId}, State) ->
	NewState = lib_territory_treasure_mod:handle_out(State, RoleId),
	{noreply, NewState};

do_handle_cast({'reconnect_territory_treasure', RoleId, RoleLv, RoleName, GuildId, GuildName, Scene, PoolId, CopyId}, State) ->
	NewState = lib_territory_treasure_mod:reconnect(State, RoleId, RoleLv, RoleName, GuildId, GuildName, Scene, PoolId, CopyId),
	{noreply, NewState};

do_handle_cast({'start_act'}, State) ->
	NewState = lib_territory_treasure_mod:start_act(State),
	{noreply, NewState};

do_handle_cast({'calc_guild_auction', GuildListSort, CopyId}, State) ->
    NewState = lib_territory_treasure_mod:calc_guild_auction(State, GuildListSort, CopyId),
    {noreply, NewState};

do_handle_cast({'gm_close_act'}, State) ->
    NewState = lib_territory_treasure_mod:gm_close_act(State),
    {noreply, NewState};

do_handle_cast({'get_act_time', RoleId, GuildId, DunId}, State) ->
    NewState = lib_territory_treasure_mod:get_act_time(State, RoleId, GuildId, DunId),
    {noreply, NewState};

do_handle_cast(_, State) -> {noreply, State}.

do_handle_info({'send_reward_end', Scene, PoolId, CopyId, DunId}, State) ->
	NewState = lib_territory_treasure_mod:send_reward_end(State, Scene, PoolId, CopyId, DunId),
	{noreply, NewState};

do_handle_info({'act_start'}, State) ->
	lib_activitycalen_api:success_start_activity(?MOD_TERRITORY, 31),
	#territory_state{dun_state = OldDunState} = State,
	case data_territory_treasure:get_all_dunid() of
		DunIds when is_list(DunIds) andalso DunIds =/= [] ->
			Fun = fun(DunId, TemMap) ->
				case maps:get(DunId, TemMap, []) of
					#dun{is_end = _IsEnd} = OldDun ->
						Dun = OldDun#dun{is_end = 0};
		    		_ ->
						Dun = #dun{is_end = 0}
				end,
				maps:put(DunId, Dun, TemMap)
			end,
			DunState = lists:foldl(Fun, OldDunState, DunIds),
			DunState;
		_ ->
			DunState = OldDunState
	end,
	{noreply, State#territory_state{dun_state = DunState}};

do_handle_info('init_data', State) ->
	NewState = lib_territory_treasure_mod:init_data(State),
	{noreply, NewState};

do_handle_info({'mon_create', DunId}, State) ->
	NewState = lib_territory_treasure_mod:mon_create(State, DunId),
	{noreply, NewState};

do_handle_info({'act_end', DunId}, State) ->
	NewState = lib_territory_treasure_mod:act_end(State, DunId),
	{noreply, NewState};

do_handle_info({'send_rank', Scene, PoolId, CopyId, NeedSendL}, State) ->
	#territory_state{dun_state = DunState} = State,
	WaveList = data_territory_treasure:get_all_wave(CopyId),
	TotalWave = erlang:length(WaveList),
    case maps:get(CopyId, DunState, []) of
    	#dun{wave = Wave, num = MonNum, is_end = IsEnd, refresh_time = RefreshTime} -> 
    		if
    			IsEnd == 1 -> %% 本次活动所有怪物刷完
    				NewWave = TotalWave, NewTime = 0;
    			true ->	
    				NewWave = Wave, NewTime = RefreshTime
    		end;
    	_ -> ?ERR("DATA ERROR!~p~n",[CopyId]),NewWave = 0, MonNum = 0, NewTime = 0
    end,
    {ok, Bin} = pt_652:write(65204, [NeedSendL, NewWave, MonNum, NewTime]),
    lib_server_send:send_to_scene(Scene, PoolId, CopyId, Bin),
    {noreply, State};

do_handle_info({'send_rank_reward', Scene, PoolId, CopyId}, State) ->
	NewState = lib_territory_treasure_mod:send_rank_reward(State, Scene, PoolId, CopyId),
	{noreply, NewState};

do_handle_info(_, State) -> {noreply, State}.

