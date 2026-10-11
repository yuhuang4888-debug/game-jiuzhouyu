%% ---------------------------------------------------------------------------
%% @doc 龙纹试炼通过榜单
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(mod_dun_dragon_rank_cluster).
-behaviour(gen_server).
-include("common.hrl").
-include("dungeon.hrl").
%% API
-export([start_link/0, finish_one_wave/4, send_record/5, gm/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
    update = []         %% 更新列表[{RankKey, PassTime, PlayerList}|...]
    , ref  = none       %% 定时器引用
}).
-record(ets_dun_dragon_rank, {
    key = {0, 0}        %% {副本id, 波数}
    ,pass_time = 0      %% 通关时间(秒)
    ,player_list = []   %% {RoleId, Figure#figure.name, Power, Figure#figure.picture, Figure#figure.picture_ver, ServerId}
}).
-define(LOOP_CHECK, 30 * 60 * 1000).
-define(ETS_DUN_DRAGON_RANK, ets_dun_dragon_rank).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @doc 有队伍完成一波
finish_one_wave(DunId, Wave, PassTime, PlayerList) ->
    ?MYLOG("dundragon", "~p~n", [{DunId, Wave, PassTime, PlayerList}]),
    case data_dungeon_wave:get_wave_helper(DunId, Wave) of
        #dungeon_wave_helper{stage_reward = StageReward} when StageReward=/=[] ->
            gen_server:cast(?MODULE, {'refresh_record', DunId, Wave, PassTime, PlayerList});
        _ -> ignore
    end.

%% @doc 查看记录
send_record(Node, Sid, DunId, Wave, MyRecord) ->
    gen_server:cast(?MODULE, {'send_record', Node, Sid, DunId, Wave, MyRecord}).

gm(Args) ->
    gen_server:cast(?MODULE, {'gm', Args}).


do_init(_Args) ->
    process_flag(trap_exit, true),
    ets:new(?ETS_DUN_DRAGON_RANK, [set, named_table, 
            {keypos, #ets_dun_dragon_rank.key}, {read_concurrency, true}]),
    self() ! 'init',
    {ok, #state{}}.

do_call(_Request, _From, State) ->
    {reply, ok, State}.

%% @doc 查看波段记录
do_cast({'send_record', Node, Sid, DunId, Wave, MyRecord}, State) ->
    case lookup_ets(DunId, Wave) of
        {PassTime, PlayerList} ->
%%            PlayerList2 = [{PlayerId, mod_id_create:get_serid_by_id(PlayerId)}||PlayerId<-PlayerList],
            ?MYLOG("dundragon", "send_record ~p~n", [{DunId, Wave, MyRecord, PassTime, PlayerList}]),
            {ok, Bin} = pt_610:write(61050, [DunId, Wave, MyRecord, PassTime, PlayerList]),
            lib_server_send:send_to_sid(Node, Sid, Bin);
        _ -> 
            {ok, Bin} = pt_610:write(61050, [DunId, Wave, 0, 0, []]),
            lib_server_send:send_to_sid(Node, Sid, Bin)
    end,
    {noreply, State};

%% @doc 刷新波段记录
do_cast({'refresh_record', DunId, Wave, PassTime, PlayerList}, #state{update = Update} = State) ->
    ?MYLOG("dundragon", "~p~n", [{DunId, Wave, PassTime, PlayerList}]),
    NewUpdate = case lookup_ets(DunId, Wave) of
        {OldPassTime, _} when PassTime < OldPassTime ->
            OneRecord = #ets_dun_dragon_rank{
                key = {DunId, Wave}, pass_time = PassTime, player_list = PlayerList},
            insert_into_ets(OneRecord),
            lists:keystore({DunId, Wave}, #ets_dun_dragon_rank.key, Update, OneRecord);
        {_, _} -> Update;
        _ ->
            OneRecord = #ets_dun_dragon_rank{
                key = {DunId, Wave}, pass_time = PassTime, player_list = PlayerList},
            insert_into_ets(OneRecord),
            lists:keystore({DunId, Wave}, #ets_dun_dragon_rank.key, Update, OneRecord)
    end,
    {noreply, State#state{update = NewUpdate}};

do_cast({'gm', db}, State) ->
    #state{update = Update, ref = _OldRef} = State,
    save_record(Update),
    {noreply, State#state{update = []}};

do_cast({'gm', clear}, _State) ->
    ets:delete(?ETS_DUN_DRAGON_RANK),
%%    self() ! 'init',
    {noreply, #state{}};

do_cast(_Msg, State) ->
    {noreply, State}.

do_info('init', State) ->
    RecordList = db_get_record(),
    lists:map(fun([DunId, Wave, PassTime, PlayerListBin]) ->
            PlayerList = util:bitstring_to_term(PlayerListBin),
            OneRecord = #ets_dun_dragon_rank{
                key = {DunId, Wave}, pass_time = PassTime, player_list = PlayerList},
%%            ?MYLOG("dunDragon", "PlayerList ~p~n", [PlayerList]),
            insert_into_ets(OneRecord)
        end, RecordList),
    Ref = erlang:send_after(60*1000, self(), 'loop_check'),
    {noreply, State#state{ref = Ref}};

do_info('loop_check', State) ->
    #state{update = Update, ref = OldRef} = State,
    util:cancel_timer(OldRef),
    Ref = erlang:send_after(?LOOP_CHECK, self(), 'loop_check'),
    save_record(Update),
    {noreply, State#state{update = [], ref = Ref}};

do_info(_Info, State) ->
    {noreply, State}.   

%% --------------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------------
init(Args) ->
    case catch do_init(Args) of
        {'EXIT', Reason} ->
            ?ERR("init error:~p~n", [Reason]),
            {stop, Reason};
        {ok, State} ->
            {ok, State};
        Other ->
            {stop, Other}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n", [Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_info(Info, State) ->
    case catch do_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------------
terminate(_Reason, _State) ->
    DungeonRecord = ets_to_list(),
    save_record(DungeonRecord),
    ok.

%% --------------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------------
lookup_ets(DunId, Wave) ->
   case ets:lookup(?ETS_DUN_DRAGON_RANK, {DunId, Wave}) of
       [#ets_dun_dragon_rank{
            pass_time = PassTime, player_list = PlayerList}] when is_list(PlayerList)->
            {PassTime, PlayerList};
       _ ->
           false
   end.

ets_to_list() -> 
    ets:tab2list(?ETS_DUN_DRAGON_RANK).

insert_into_ets(OneRecord) -> 
    ets:insert(?ETS_DUN_DRAGON_RANK, OneRecord).

db_get_record() ->
    Sql = io_lib:format(<<"select dun_id, wave, pass_time, player_list from dungeon_dragon_rank">>, []),
    db:get_all(Sql).

save_record(DungeonRecord) ->
    AllRecord = join_data(DungeonRecord, []),
    FormatAllRecord = string:join(AllRecord, ","),
    Sql = io_lib:format("replace into dungeon_dragon_rank(dun_id, wave, pass_time, player_list) values ~ts", [FormatAllRecord]),
%%    ?MYLOG("dundragon", "Sql ~s~n", [Sql]),
    FormatAllRecord =/= [] andalso db:execute(Sql).

join_data([#ets_dun_dragon_rank{key = {Dunid, Wave}, pass_time = PassTime, player_list = PlayerList}|Rest], Sqls) ->
    Sql = io_lib:format("(~p, ~p, ~p, '~s')", [Dunid, Wave, PassTime, util:term_to_bitstring(PlayerList)]),
    join_data(Rest, [Sql|Sqls]);
join_data([], Sqls) -> Sqls.
