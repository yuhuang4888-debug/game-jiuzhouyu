%%%------------------------------------
%%% @Module  : mod_flower_rank_act
%%% @Author  :  fwx
%%% @Created :  2018-1-5
%%% @Description: 鲜花结婚榜活动
%%%------------------------------------

-module(mod_flower_act_local).

% -include("common.hrl").
-include("flower_rank_act.hrl").
-include("common.hrl").

-export([
        refresh_common_rank_by_list/1
        , refresh_common_rank/3
        , send_rank_list/3
    ]).

%% API
-export([start_link/0]).
-compile(export_all).
%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

%% @param [{RankType, CommonRankRole}]
refresh_common_rank_by_list(List) ->
    gen_server:cast({global, ?MODULE}, {'refresh_common_rank_by_list', List}).

%% 根据类型刷新榜单
refresh_common_rank(RankType, SubType, RankRole) ->
    gen_server:cast({global, ?MODULE}, {'refresh_common_rank', RankType, SubType, RankRole}).

%% 发送榜单的数据
send_rank_list(RankType, SubType, RoleId) ->
    gen_server:cast({global, ?MODULE}, {'send_rank_list', RankType, SubType, RoleId}).

%% 结算魅力榜奖励
send_charm_local_reward(SubType) -> 
    gen_server:cast({global, ?MODULE}, {'send_charm_local_reward', SubType}).

%% 清算婚礼榜
clear_wed_rank(SubType) ->
     gen_server:cast({global, ?MODULE}, {'clear_wed_rank', SubType}).

%% 转职相关
change_rank_by_type(SubType, RoleId, OldType, NewType) ->
    gen_server:cast({global, ?MODULE}, {'change_rank_by_type', SubType, RoleId, OldType, NewType}).
%% ---------------------------------------------------------------------------
%% @doc Starts the server
-spec start_link() -> {ok, Pid} | ignore | {error, Error} when
    Pid :: pid(),
    Error :: term().
%% ---------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
%% @doc Initializes the server
-spec init(Args) ->
    {ok, State}
    | {ok, State, Timeout}
    | ignore
    | {stop, Reason} when
    Args    :: term() ,
    State   :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason  :: term().
%% ---------------------------------------------------------------------------
init([]) ->
    State = lib_flower_act_mod_local:init(),
    {ok, State}.


%% ---------------------------------------------------------------------------
%% @doc Handling call messages
-spec handle_call(Request, From, State) ->
    {reply, Reply, State}
    | {reply, Reply, State, Timeout}
    | {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, Reply, State}
    | {stop, Reason, State} when
    Request :: term(),
    From :: pid(),
    State :: term(),
    Reply :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity.
%% ---------------------------------------------------------------------------
% handle_call({'reload'}, _From, _State) ->
%     State = lib_common_rank_mod:init(),
%     {reply, ok, State};
% handle_call({'state'}, _From, State) ->
%     % ?ERR1("~p state:~p~n", [?MODULE, State]),
%     {reply, State, State};
handle_call(_Request, _From, State) ->
    % ?ERR1("Handle unkown request[~w]~n", [_Request]),
    Reply = ok,
    {reply, Reply, State}.


%% ---------------------------------------------------------------------------
%% @doc Handling cast messages
-spec handle_cast(Msg, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Msg :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            % util:errlog("~p ~p Msg:~p Cast_Error:~p ~n", [?MODULE, ?LINE, Msg, Err]),
            ?ERR("Msg:~p Cast_Error:~p~n", [Msg, Err]),
            {noreply, State}
    end.
    % {ok, NewState} = do_handle_cast(Msg, State),
    % {noreply, NewState}.

do_handle_cast({'refresh_common_rank_by_list', List}, State) ->
    lib_flower_act_mod_local:refresh_common_rank_by_list(State, List);
do_handle_cast({'refresh_common_rank', RankType, SubType, CommonRankRole}, State) ->
    lib_flower_act_mod_local:refresh_common_rank(State, RankType, SubType, CommonRankRole);
do_handle_cast({'send_rank_list', RankType, SubType, RoleId}, State) ->
    lib_flower_act_mod_local:send_rank_list(State, RankType, SubType, RoleId),
    {ok, State};
do_handle_cast({'send_charm_local_reward', SubType}, State) ->
    lib_flower_act_mod_local:send_charm_local_reward(State, SubType);
do_handle_cast({'clear_wed_rank', SubType}, State) ->
    lib_flower_act_mod_local:clear_wed_rank(State, SubType);
do_handle_cast({'change_rank_by_type', SubType, RoleId, OldType, NewType}, State) ->
    lib_flower_act_mod_local:change_rank_by_type(State, SubType, RoleId, OldType, NewType);
do_handle_cast(_Msg, State) ->
     ?ERR("Handle unkown msg[~w]~n", [_Msg]),
    {ok, State}.

%% ---------------------------------------------------------------------------
%% @doc Handling all non call/cast messages
-spec handle_info(Info, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Info :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------
handle_info(_Info, State) ->
    % ?ERR1("Handle unkown info[~w]~n", [_Info]),
    {noreply, State}.


%% ---------------------------------------------------------------------------
%% @doc called by a gen_server when it is about to terminate
-spec terminate(Reason, State) -> ok when
    Reason :: term(),
    State :: term().
%% ---------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.


%% ---------------------------------------------------------------------------
%% @doc Convert process state when code is changed
-spec code_change(OldVsn, State, Extra) -> {ok, NewState} when
    OldVsn :: term(),
    State :: term(),
    Extra :: term(),
    NewState :: term().
%% ---------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.