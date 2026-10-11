%% ---------------------------------------------------------------------------
%% @doc mod_enchantment_guard_rank_local

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/3/22
%% @desc    推关排行榜，本服进程数据
%% ---------------------------------------------------------------------------
-module(mod_enchantment_guard_rank_local).

-behaviour(gen_server).

%% API
-export([
    start_link/0,
    update_info/1,
    update_rank_list/1,
    send_rank_list/2
]).

%% gen_server callbacks

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-export([
    gm_refresh_data/0,
    gm_refresh_data_local/0
]).

-include("common.hrl").
-include("def_gen_server.hrl").
-include("enchantment_guard.hrl").

-record(state, {
    rank = [],              %% [#enchantment_role_rank{}] 榜单信息
    is_cls = 0              %% 是否跨服榜
}).

%% ===========================
%%  Function Need Export
%% ===========================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 更新信息
update_info(Args) ->
    gen_server:cast(?MODULE, {'update_info', Args}).

%% 更新榜单信息
update_rank_list(Rank) ->
    NewRank = Rank#enchantment_role_rank{server_id = config:get_server_id(), server_num = config:get_server_num(), last_time = utime:unixtime()},
    gen_server:cast(?MODULE, {'update_rank_list', NewRank}).

send_rank_list(RoleId, SelfGate) ->
    gen_server:cast(?MODULE, {'send_rank_list', RoleId, SelfGate}).

gm_refresh_data() ->
    gen_server:cast(?MODULE, {'gm_refresh_data'}).

gm_refresh_data_local() ->
    gen_server:cast(?MODULE, {'gm_refresh_data_local'}).

%% ===========================
%% gen_server callbacks temples
%% ===========================
init(Args) ->
    ?DO_INIT(Args).
handle_call(Request, From, State) ->
    ?DO_HANDLE_CALL(Request, From, State).
handle_cast(Msg, State) ->
    ?DO_HANDLE_CAST(Msg, State).
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).
terminate(Reason, State) ->
    ?DO_TERMINATE(Reason, State).
code_change(OldVsn, State, Extra) ->
    ?DO_CODE_CHANGE(OldVsn, State, Extra).

%% =============================
%% gen_server callbacks
%% =============================

do_init([]) ->
    Sql = <<"select  player_low.id, player_low.nickname, player_state.last_combat_power, player_enchantment_guard.gate, player_enchantment_guard.last_time
     from  player_enchantment_guard LEFT JOIN  player_low  ON  (player_enchantment_guard.player_id = player_low.id) LEFT JOIN player_state on player_enchantment_guard.player_id = player_state.id
     where  player_enchantment_guard.gate > 0 ORDER BY player_enchantment_guard.gate desc, player_enchantment_guard.last_time asc LIMIT 50">>,
    List = db:get_all(Sql),
    SerId = config:get_server_id(),
    SerNum = config:get_server_num(),
    F = fun([RoleId, RoleName, RoleCombat, Gate, LastTime], {Index, AccRank}) ->
        Item = #enchantment_role_rank{
            server_id = SerId, server_num = SerNum, role_id = RoleId,
            role_name = RoleName, gate = Gate, rank = Index, last_time = LastTime, combat = RoleCombat
        },
        {Index + 1, [Item|AccRank]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, List),
    {ok, #state{rank = RankList}}.

do_handle_call(_Request, _From, _State) ->
    no_match.

do_handle_cast({'update_info', Args}, State) ->
    NewState = update_info(State, Args),
    {noreply, NewState};

do_handle_cast({'update_rank_list', RankInfo}, State) ->
    #state{is_cls = IsCls, rank = RankL} = State,
    case IsCls of
        1 ->
            mod_clusters_node:apply_cast(mod_enchantment_guard_rank, update_rank_list, [RankInfo]),
            {noreply, State};
        _ ->
            #enchantment_role_rank{role_id = RoleId} = RankInfo,
            NewRankL = [RankInfo|lists:keydelete(RoleId, #enchantment_role_rank.role_id, RankL)],
            LastRankList = lib_enchantment_guard:sort_rank(NewRankL),
            NewState = State#state{rank = LastRankList},
            {noreply, NewState}
    end;

do_handle_cast({'send_rank_list', RoleId, SelfGate}, State) ->
    #state{is_cls = IsCls, rank = RankL} = State,
    #enchantment_role_rank{rank = SelfRank} = ulists:keyfind(RoleId, #enchantment_role_rank.role_id, RankL, #enchantment_role_rank{}),
    SendList = [{SerId, SerNum, RId, RName, Rank, Gate, Combat}||#enchantment_role_rank{
        server_id = SerId, server_num = SerNum, role_id = RId,
        role_name = RName, rank = Rank, gate = Gate, combat = Combat
    }<-RankL],
    {ok, BinData} = pt_133:write(13301, [IsCls, SelfRank, SelfGate, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'gm_refresh_data'}, State) ->
    case mod_global_counter:get_count(133, 1) > 0 of
        true ->
            Sql = <<"select  player_low.id, player_low.nickname, player_state.last_combat_power, player_enchantment_guard.gate, player_enchantment_guard.last_time
     from  player_enchantment_guard LEFT JOIN  player_low  ON  (player_enchantment_guard.player_id = player_low.id) LEFT JOIN player_state on player_enchantment_guard.player_id = player_state.id
     where  player_enchantment_guard.gate > 0 ORDER BY player_enchantment_guard.gate desc, player_enchantment_guard.last_time asc LIMIT 50">>,
            List = db:get_all(Sql),
            SerId = config:get_server_id(),
            SerNum = config:get_server_num(),
            F = fun([RoleId, RoleName, RoleCombat, Gate, LastTime], {Index, AccRank}) ->
                Item = #enchantment_role_rank{
                    server_id = SerId, server_num = SerNum, role_id = RoleId, combat = RoleCombat,
                    role_name = RoleName, gate = Gate, rank = Index, last_time = LastTime
                },
                {Index + 1, [Item|AccRank]}
                end,
            {_, RankList} = lists:foldl(F, {1, []}, List),
            SerId = config:get_server_id(),
            mod_clusters_node:apply_cast(mod_enchantment_guard_rank, init_game_node_list, [SerId, RankList]);
        _ ->
            skip
    end,
    {noreply, State};

do_handle_cast({'gm_refresh_data_local'}, State) ->
    #state{ is_cls = IsCls } = State,
    case IsCls > 0 of
        true ->
            {ok, InitState} = do_init([]),
            #state{ rank = RankList } = InitState,
            LastRankList = lib_enchantment_guard:sort_rank(RankList),
            NewState = InitState#state{ rank = LastRankList },
            mod_global_counter:decrement(133, 1);
        _ ->
            NewState = State
    end,
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, _State) ->
    {noreply, _State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

update_info(State, []) -> State;
update_info(State, [{mod, Mod}|T]) ->
    ?PRINT("{mod, Mod} ~p ~n", [{mod, Mod}]),
    case Mod =/= 1 andalso Mod =/= 0 of
        true ->
            #state{rank = RankL} = State,
            % 首次跨服
            IsFirstCls = mod_global_counter:get_count(133, 1) == 0,
            case IsFirstCls of
                true ->
                    SerId = config:get_server_id(),
                    mod_clusters_node:apply_cast(mod_enchantment_guard_rank, init_game_node_list, [SerId, RankL]),
                    mod_global_counter:increment(133, 1);
                _ ->
                    skip
            end,
            NewState = State#state{is_cls = 1};
        _ ->
            NewState = State
    end,
    update_info(NewState, T);
update_info(State, [{rank_list, SortRankL}|T]) when State#state.is_cls == 1 ->
    NewState = State#state{rank = SortRankL},
    update_info(NewState, T);
update_info(State, [{update_rank_list, RankInfo}|T]) when State#state.is_cls == 1 ->
    #state{rank = RankList} = State,
    #enchantment_role_rank{role_id = RoleId} = RankInfo,
    NewRankList = [RankInfo|lists:keydelete(RoleId, #enchantment_role_rank.role_id, RankList)],
    LastRankList = lib_enchantment_guard:sort_rank(NewRankList),
    NewState = State#state{rank = LastRankList},
    update_info(NewState, T);
update_info(State, [_|T]) -> update_info(State, T).
