%%%-----------------------------------
%%% @Module      : mod_first_kill
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 14. 十月 2019 14:37
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_first_kill).

-author("chenyiming").
-include("first_kill.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("custom_act.hrl").
-define(MOD_STATE, first_kill_state).     %%首杀状态

-define(scene_type_list, [?SCENE_TYPE_ABYSS_BOSS, ?SCENE_TYPE_FORBIDDEB_BOSS]).

%% API
-export([]).






start_link() ->
	gen_server:start_link({local, mod_first_kill}, mod_first_kill, [], []).


init([]) ->
	State = lib_first_kill_mod:init(),
	{ok, State}.

boss_be_kill(Mon, SceneId, AtterId, Klist) ->
%%	?MYLOG("cym", "SceneId ~p~n", [SceneId]),
	case data_scene:get(SceneId) of
		#ets_scene{type = SceneType} ->
			case lists:member(SceneType, ?scene_type_list) of
				true ->
					SubTypeList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FIRST_KILL),
					case SubTypeList of
						[_ | _] ->
							case lib_custom_act_api:is_yy_sh921_lj_57_PM001257_source() of
								true ->
									[gen_server:cast(?MODULE, {'boss_be_killed', SubType, Mon, SceneId, AtterId, Klist})
										|| SubType <- SubTypeList];
								_ ->
									skip
							end;
						_ ->
							skip
					end;
				_ ->
					skip
			end;
		_ ->
			sikp
	end.

get_info(RoleId, ?CUSTOM_ACT_TYPE_FIRST_KILL, SubType) ->
	Ids = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FIRST_KILL),
%%	?MYLOG("cym", "Ids ~p~n", [Ids]),
	case lists:member(SubType, Ids) of
		true ->
			gen_server:cast(?MODULE, {'get_info', SubType, RoleId});
		_ ->  %% 未开启
			skip
	end;

get_info(_RoleId, _, _SubType) ->
	ok.

clear_act(SubType) ->
	gen_server:cast(?MODULE, {'clear_act', SubType}).







handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
			{noreply, State}
	end.


handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
			{noreply, State}
	end.

do_handle_cast({'clear_act', SubType}, State) ->
	NewState = lib_first_kill_mod:clear_act(SubType, State),
	{ok, NewState};


do_handle_cast({'get_info', SubType, RoleId}, State) ->
	lib_first_kill_mod:get_info(SubType, RoleId, State),
	{ok, State};

do_handle_cast({'boss_be_killed', SubType, Mon, SceneId, AtterId, Klist}, State) ->
%%	?MYLOG("cym", "SceneId ~p~n", [SceneId]),
	NewState = lib_first_kill_mod:boss_be_killed(SubType, Mon, SceneId, AtterId, Klist, State),
	{noreply, NewState};


do_handle_cast(_Request, State) ->
	{noreply, State}.



do_handle_info(_Request, State) ->
	{noreply, State}.


