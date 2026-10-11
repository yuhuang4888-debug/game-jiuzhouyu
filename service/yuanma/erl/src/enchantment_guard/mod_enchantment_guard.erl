%%%-----------------------------------
%%% @Module      : mod_enchantment_guard
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 13. 八月 2018 20:40
%%% @Description : 结界守护进程
%%%-----------------------------------
-module(mod_enchantment_guard).
-include("enchantment_guard.hrl").
-include("common.hrl").
-author("chenyiming").

%% API
-compile(export_all).


%%启动
start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% -----------------------------------------------------------------
%% @desc     功能描述  获取排行榜信息
%% @param    参数      PlayId::玩家id    Type   玩家数量
%% @return   返回值    {false,Reason}|{true,玩家自己排名,排行榜:list}
%% @history  修改历史
%% -----------------------------------------------------------------
get_rank_list(PlayId, Type) ->
	case gen_server:call({global, ?MODULE}, {get_rank_list, PlayId, Type}) of
		{true, {RoleRank, RankList}} ->
			{true, RoleRank, RankList};
		{false, Res} ->
			{false, Res}
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  更新排行榜信息
%% @param    参数      Rank::#rank
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
update_rank_list(Rank) ->
%%	?DEBUG("log1", []),
	gen_server:cast({global, ?MODULE}, {update_rank_list, Rank}).



init([]) ->
	%%读取数据库数据
	Sql = <<"select  player_low.id, player_low.nickname, player_enchantment_guard.gate, player_enchantment_guard.last_time  from  player_enchantment_guard  LEFT JOIN  player_low  ON  player_enchantment_guard.player_id = player_low.id  where  player_enchantment_guard.gate   <> 0  ORDER BY   player_enchantment_guard.gate desc , player_enchantment_guard.last_time ASC LIMIT 20">>,
	case db:get_all(Sql) of
		[] ->
			MinGate = 0,
			RankList = [];
		List ->
			{MinGate, RankList} = make_rank_list(List)
%%			?DEBUG("~p~n", [RankList])
	end,
	State = #enchantment_guard_state{rank_list = RankList, min_gate = MinGate},
	{ok, State}.


%%-----------------------handle-------------------------------------

handle_call(Request, From, State) ->
	case catch do_handle_call(Request, From, State) of
		{reply, Reply, NewState} ->
			{reply, {true, Reply}, NewState};
		Reason ->
			?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
			{reply, {false, Reason}, State}
	end.

handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{ok, NewState} ->
			{noreply, NewState};
		Err ->
			?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
			{noreply, State}
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  获取排行榜信息
%% @param    参数      PlayId::玩家id    Type::玩家数量
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_call({get_rank_list, PlayId, Type}, _From, State) ->
	%%获取玩家排名 如果没有榜则排名为
	#enchantment_guard_state{rank_list = RankList} = State,
	case lists:keyfind(PlayId, #rank.play_id, RankList) of
		false -> %未上榜
			RoleRank = 0;
		#rank{rank = Rank} ->
			RoleRank = Rank
	end,
	%%获取排行榜
	NewRankList = lib_enchantment_guard:get_rank_list_by_type(Type, RankList),
	{reply, {RoleRank, NewRankList}, State}.

%% -----------------------------------------------------------------
%% @desc     功能描述  更新排行榜信息
%% @param    参数      Rank::#rank{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_cast({update_rank_list, Rank}, #enchantment_guard_state{min_gate = MinGate, rank_list = RankList} = Status) ->
	#rank{gate = Gate} = Rank,
	Length = erlang:length(RankList),
	if
		Gate > MinGate orelse Length < 20 ->  %%达到了阈值，或者不够20个玩家
			%%重新排前二十名
			NewStatus = sort_rank_list(Rank, Status),
			{ok, NewStatus};
		true ->
%%			?DEBUG("~p~n", [Rank]),
			{ok, Status}
	end.


%%-----------------------handle-------------------------------------


%% -----------------------------------------------------------------
%% @desc     功能描述  将数据库的数据转为内存所用数据  排行榜,
%% @param    参数     [[player_id,name,gate,last_time]]           [玩家id, 玩家名字,当前关卡,更新时间]  并且这里是有序的，sql中已经排序
%% @return   返回值    {MinGate, [#rank{}]}              MinGate :排行榜最小关卡
%% @history  修改历史
%% -----------------------------------------------------------------
make_rank_list([]) ->
	{0, []};
make_rank_list(List) ->
	make_rank_list(List, 0, []).

%%Rank  排名
make_rank_list([], _Rank, ResList) ->
	[#rank{gate = Gate} | _T] = ResList,
	{Gate, lists:reverse(ResList)};
make_rank_list([[Id, Name, Gate, Time] | T], Rank, ResList) ->
	Record = #rank{play_id = Id, name = Name, gate = Gate, rank = Rank + 1, last_time = Time},
	make_rank_list(T, Rank + 1, [Record | ResList]).


%% -----------------------------------------------------------------
%% @desc     功能描述  重新排序
%% @param    参数      Rank::#rank{}
%%                     Status::#enchantment_guard_state{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
sort_rank_list(Rank, Status) ->
	#enchantment_guard_state{rank_list = RankList} = Status,
	SortList = lists:keystore(Rank#rank.play_id, #rank.play_id, RankList, Rank),
	%%比较函数 关卡 > 时间
	F = fun(#rank{gate = Gate1} = X, #rank{gate = Gate2} = P) ->
		if
			Gate1 > Gate2 ->
				true; %%关卡大排名先
			Gate1 < Gate2 ->
				false;
			true ->
				X#rank.last_time < P#rank.last_time
		end
	end,
	SortList1 = lists:sort(F, SortList), %%排序
	%%截取前二十名
	L = erlang:length(SortList1),
	if
		L > 20 ->
			SortList2 = lists:sublist(SortList1, 20);
		true ->
			SortList2 = SortList1
	end,
	%%最后一名的关卡
	[#rank{gate = MinGate}] = lists:sublist(SortList2, erlang:length(SortList2), 1),
	F2 = fun(TempRank, {Num, ResList}) ->     %%第一个参数必须是列表的元素 第二个参数必须foldl的第二个参数保持一样
		TempRank1 = TempRank#rank{rank = Num + 1},
		{Num + 1, [TempRank1 | ResList]}
	end,
	{_, SortList3} = lists:foldl(F2, {0, []}, SortList2),  %%修正排名
	LastList = lists:reverse(SortList3), %%顺序更正，由于foldl方法逆序了
	%%更新进程状态
%%	?DEBUG("~p~n~p~n~p~n~p~n~p~n~p~n",[RankList,SortList,SortList1,SortList2,SortList3,LastList]),
	Status#enchantment_guard_state{min_gate = MinGate, rank_list = LastList}.




