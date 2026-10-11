%%%------------------------------------
%%% @Module  : mod_flower_rank_act
%%% @Author  :  fwx
%%% @Created :  2018-1-5
%%% @Description: 跨服鲜花榜
%%%------------------------------------

-module(mod_kf_flower_act).

% -include("common.hrl").
-include("flower_rank_act.hrl").
-include("common.hrl").

%% API
-export([start_link/0]).
-compile(export_all).
%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

%% 根据类型刷新榜单
refresh_common_rank(RankType, SubType, RankRole, Figure) ->
    gen_server:cast({global, ?MODULE}, {'refresh_common_rank', RankType, SubType, RankRole, Figure}).

%% 刷新战力
refresh_power(RefreshList) ->
    gen_server:cast({global, ?MODULE}, {'refresh_power', RefreshList}).

%% 发送榜单的数据
send_rank_list(Node, RankType, SubType, RoleId, ServerId, SelValue) ->
    gen_server:cast({global, ?MODULE}, {'send_rank_list', Node, RankType, SubType, RoleId, ServerId, SelValue}).

%receive_flower_gift(Node, RankType, SubType, RoleId, SName, SerId, ReceiverId, GiftCfg, IsAnonymous) ->
%    gen_server:cast({global, ?MODULE}, {'receive_flower_gift', Node, RankType, SubType, RoleId, SName, SerId, ReceiverId, GiftCfg, IsAnonymous}).

send_top_n_figure_to_act(RankType, SubType, RoleId, Figure) ->
    gen_server:cast({global, ?MODULE}, {'send_top_n_figure_to_act', RankType, SubType, RoleId, Figure}).

act_open(SubType) -> 
    gen_server:cast({global, ?MODULE}, {'act_open', SubType}).
    
%% 结算奖励
send_reward(SubType) -> 
    gen_server:cast({global, ?MODULE}, {'send_reward', SubType}).

change_rank_by_type(SubType, RoleId, OldType, NewType, Sex) ->
    gen_server:cast({global, ?MODULE}, {'change_rank_by_type', SubType, RoleId, OldType, NewType, Sex}).

change_role_name_by_type(SubType, RoleId, ChangeRankType, PlayerName) ->
    gen_server:cast({global, ?MODULE}, {'change_role_name_by_type', SubType, RoleId, ChangeRankType, PlayerName}).

update_role_figure(RankType, SubType, RoleId, KeyList) ->
    gen_server:cast({global, ?MODULE}, {'update_role_figure', RankType, SubType, RoleId, KeyList}).

wlv_change(ServerId, SubType, Wlv) ->
    gen_server:cast({global, ?MODULE}, {'wlv_change', ServerId, SubType, Wlv}).

zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast({global, ?MODULE}, {'zone_change', ServerId, OldZone, NewZone}).
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
    State = lib_kf_flower_act_mod:init(),
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

do_handle_cast({'refresh_common_rank', RankType, SubType, CommonRankRole, Figure}, State) ->
    lib_kf_flower_act_mod:refresh_common_rank(State, RankType, SubType, CommonRankRole, Figure);
do_handle_cast({'refresh_power', RefreshList}, State) ->
    lib_kf_flower_act_mod:refresh_power(State, RefreshList); 
do_handle_cast({'send_rank_list', Node, RankType, SubType, RoleId, ServerId, SelValue}, State) ->
    lib_kf_flower_act_mod:send_rank_list(State, Node, RankType, SubType, RoleId, ServerId, SelValue),
    {ok, State};
do_handle_cast({'send_top_n_figure_to_act', RankType, SubType, RoleId, Figure}, State) ->
    lib_kf_flower_act_mod:send_top_n_figure_to_act(State, RankType, SubType, RoleId, Figure);
% do_handle_cast({'receive_flower_gift', Node, RankType, SubType, RoleId, SName, SerId, ReceiverId, GiftCfg, IsAnonymous}, State) ->
%     lib_kf_flower_act_mod:receive_flower_gift(State, Node, RankType, SubType, RoleId, SName, SerId, ReceiverId, GiftCfg, IsAnonymous),
%     {ok, State};
do_handle_cast({'send_reward', SubType}, State) ->
    lib_kf_flower_act_mod:send_reward(State, SubType);
do_handle_cast({'act_open', SubType}, State) ->
    lib_kf_flower_act_mod:act_open(State, SubType);
do_handle_cast({'change_rank_by_type', SubType, RoleId, OldType, NewType, Sex}, State) ->
    lib_kf_flower_act_mod:change_rank_by_type(State, SubType, RoleId, OldType, NewType, Sex);
do_handle_cast({'change_role_name_by_type', SubType, RoleId, ChangeRankType, PlayerName}, State) ->
    lib_kf_flower_act_mod:change_role_name_by_type(State, SubType, RoleId, ChangeRankType, PlayerName);
do_handle_cast({'update_role_figure', RankType, SubType, RoleId, KeyList}, State) ->
    lib_kf_flower_act_mod:update_role_figure(State, RankType, SubType, RoleId, KeyList);
do_handle_cast({'wlv_change', ServerId, SubType, Wlv}, State) ->
    lib_kf_flower_act_mod:wlv_change(State, ServerId, SubType, Wlv);
do_handle_cast({'zone_change', ServerId, OldZone, NewZone}, State) ->
    lib_kf_flower_act_mod:zone_change(State, ServerId, OldZone, NewZone);

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