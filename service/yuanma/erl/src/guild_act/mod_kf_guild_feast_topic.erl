%%%-----------------------------------
%%% @Module      : mod_local_guild_feast_topic
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 五月 2020 16:15
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_kf_guild_feast_topic).
-author("chenyiming").

-include("guild_feast.hrl").
-include("common.hrl").

%% API
-export([]).

-define(MOD_STATE, topic_status).



%% 定时器启动
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

sync_zone_group(InfoList) ->
	gen_server:cast(?MODULE, {'sync_zone_group', InfoList}).

start_topic(ServerId) ->
	gen_server:cast(?MODULE, {'act_start', ServerId}).

end_act(GameType) ->
%%	?MYLOG("feast", "end_act ~n", []),
	gen_server:cast(?MODULE, {'end_act', GameType}).


answer(ServerId, ServerNum, TopicNo, RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName) ->
	gen_server:cast(?MODULE, {'answer',ServerId, ServerNum, TopicNo, RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName}).

refresh_quiz_rank(ServerId, TopicNo, RightAnswer) ->
    gen_server:cast(?MODULE, {'refresh_quiz_rank', ServerId, TopicNo, RightAnswer}).

add_guild_msg(ServerId, PackRoleListLast, GuildMsg) ->
	gen_server:cast(?MODULE, {'add_guild_msg', ServerId, PackRoleListLast, GuildMsg}).

send_quiz_rank(ServerId, RoleId, GuildId, PackRoleListLast) ->
	gen_server:cast(?MODULE, {'send_quiz_rank', ServerId, RoleId, GuildId, PackRoleListLast}).

send_role_score_rank(ServerId, RoleId, GuildId, GameType) ->
    gen_server:cast(?MODULE, {'send_role_score_rank', ServerId, RoleId, GuildId, GameType}).

update_rank_role(RankRole) ->
    gen_server:cast(?MODULE, {'update_rank_role', RankRole}).

send_game_rank_list(ServerId, GameType, RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'send_game_rank_list', ServerId, GameType, RoleId, GuildId}).

init([]) ->
%%	?MYLOG("feast", "init +++++++++++++++~n", []),
	{ok, #topic_status{}}.






handle_cast(Msg, State) ->
%%	?MYLOG("feast", "start_topic +++++++++++++++~n", []),
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


do_handle_cast({'send_quiz_rank', ServerId, RoleId, GuildId, PackRoleListLast}, #topic_status{status = 1} = State) ->
	lib_kf_guild_feast_topic_mod:send_quiz_rank(ServerId, RoleId, GuildId, PackRoleListLast, State),
	{noreply, State};

do_handle_cast({'send_role_score_rank', ServerId, RoleId, GuildId, GameType}, #topic_status{status = 1} = State) ->
    lib_kf_guild_feast_topic_mod:send_role_score_rank(ServerId, RoleId, GuildId, GameType, State),
    {noreply, State};

do_handle_cast({'update_rank_role', RankRole}, #topic_status{status = 1} = State) ->
    NewState = lib_kf_guild_feast_topic_mod:update_rank_role(State, RankRole),
    {noreply, NewState};

do_handle_cast({'send_game_rank_list', ServerId, GameType, RoleId, GuildId}, #topic_status{status = 1} = State) ->
    NewState = lib_kf_guild_feast_topic_mod:send_game_rank_list(State, ServerId, GameType, RoleId, GuildId),
    {noreply, NewState};

do_handle_cast({'add_guild_msg', ServerId, PackRoleListLast, GuildMsg}, #topic_status{status = 1} = State) ->
	NewState = lib_kf_guild_feast_topic_mod:add_guild_msg(ServerId, PackRoleListLast, GuildMsg, State),
	{noreply, NewState};

do_handle_cast({'sync_zone_group', InfoList},  State) ->
	NewState = lib_kf_guild_feast_topic_mod:sync_zone_group(State, InfoList),
	{noreply, NewState};

do_handle_cast({'act_start', ServerId}, State) ->
	NewState = lib_kf_guild_feast_topic_mod:act_start(ServerId, State),
	{noreply, NewState};


do_handle_cast({'end_act', GameType}, #topic_status{status = 1, group_msg = GroupMsg} = State) ->
	spawn(fun() ->
		lib_kf_guild_feast_topic_mod:end_act(State, GameType)
	end),
    ZoneMap = lib_kf_guild_feast_topic_mod:init_zone_map(GroupMsg),
	{noreply, #topic_status{group_msg = GroupMsg, status = 0, zone_map = ZoneMap}};

do_handle_cast({'answer',ServerId,  ServerNum, TopicNo, RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName}, #topic_status{status = 1} = State) ->  %%
	NewState = lib_kf_guild_feast_topic_mod:answer(ServerId,  ServerNum, TopicNo, RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName, State),
	{noreply, NewState};

do_handle_cast({'refresh_quiz_rank', ServerId, TopicNo, RightAnswer}, #topic_status{status = 1} = State) ->
    NewState = lib_kf_guild_feast_topic_mod:refresh_quiz_rank(ServerId, TopicNo, RightAnswer, State),
    {noreply, NewState};

do_handle_cast(_Request, State) ->
	{noreply, State}.





do_handle_info(_Request, State) ->
	{noreply, State}.
