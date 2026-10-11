%% ---------------------------------------------------------------------------
%% @doc urand.
%% @author ming_up@foxmail.com
%% @since  2015-11-26
%% @deprecated 随机函数
%% ---------------------------------------------------------------------------
-module(urand).
-compile(export_all).


%% 产生一个介于Min到Max之间的随机整数
rand(Same, Same) -> Same;
rand(Min, Max) when Max < Min -> 0;
rand(Min, Max) ->
    %% 以保证不同进程都可取得不同的种子
    case get("rand_seed") of
        undefined ->
            %% <<A:32, B:32, C:32>> = crypto:rand_bytes(12),
            <<A:32, B:32, C:32>> = crypto:strong_rand_bytes(12),
            %% random:seed({A,B,C}),
            %% 恒定的随机种子2^512次调用
            rand:seed(exs1024, {A,B,C}),
            %% random:seed(erlang:now()),
            put("rand_seed", 1);
        _ -> skip
    end,
    M = Min - 1,
    if
        Max - M =< 0 ->
            0;
        true ->
            %% random:uniform(Max - M) + M
            rand:uniform(Max - M) + M
    end.

%% Value大于等于随机数
ge_rand(_Min, Max, Value) when Value >= Max -> true;
ge_rand(Min, Max, Value) -> Value >= rand(Min, Max).

%% rand_with_weight(WeightList) -> Elem | false
%% 输出带有权值的的随机项
%% WeightList = [{权值(Weight), 项(Elem)}, ...]
%% Weight = integer() > 0
rand_with_weight([]) -> false;
rand_with_weight(WeightList) ->
    Max  = lists:sum([Weight||{Weight, _Elem} <- WeightList]),
    Rand = rand(1, Max),
    rand_with_weight_get_elem(WeightList, Rand, 0).
%% 获取对应的随机项
rand_with_weight_get_elem([], _, _) -> false;
rand_with_weight_get_elem([{Weight, Elem}|T], Rand, WeightSum) ->
    case Rand =< Weight+WeightSum of
        true  -> Elem;
        false -> rand_with_weight_get_elem(T, Rand, Weight+WeightSum)
    end.

%% rand_with_percent(PercentList) -> Elem | false
%% PercentList: 固定概率列表 [{概率分子(Percent), 项(Elem)}, ...]
%% Sum:总概率（概率分母）
rand_with_percent([], _) -> false;
rand_with_percent(PercentList, Sum) ->
    Rand = rand(1, Sum),
    rand_with_percent_get_elem(PercentList, Rand, 0).
%% 获取对应的随机项
rand_with_percent_get_elem([], _, _) -> false;
rand_with_percent_get_elem([{Percent, Elem}|T], Rand, I) ->
    case Rand =< Percent+I of
        true  -> Elem;
        false -> rand_with_percent_get_elem(T, Rand, Percent+I)
    end.

%% 从一个list中随机取出一项
%% null | term()
list_rand([]) -> null;
list_rand([I]) -> I;
list_rand(List) ->
    Len = length(List),
    Index = rand(1, Len),
    get_term_from_list(List, Index).
get_term_from_list(List, 1) ->
    [Term|_R] = List,
    Term;
get_term_from_list(List, Index) ->
    [_H|R] = List,
    get_term_from_list(R, Index - 1).

%% @doc 从列表中不重复选择N个元素，返回选中元素构成的新列表
get_rand_list(N, List) ->
    Len = length(List),
    get_rand_list(N, List, Len, []).

get_rand_list(0, _List, _Len, AccList) -> AccList;
get_rand_list(_N, [], _Len, AccList) -> AccList;
get_rand_list(N, List, Len, AccList) ->
    Idx = rand(1, Len),
    Rand = get_term_from_list(List, Idx),
    get_rand_list(N - 1, lists:delete(Rand, List), Len - 1, [Rand | AccList]).

%% @doc 从列表中有放入的选择N个元素
get_rand_list_repeat(N, List) ->
    Len = length(List),
    get_rand_list_repeat(N, List, Len, []).

get_rand_list_repeat(0, _List, _Len, AccList) -> AccList;
get_rand_list_repeat(_N, [], _Len, AccList) -> AccList;
get_rand_list_repeat(N, List, Len, AccList) ->
    Idx = rand(1, Len),
    Rand = get_term_from_list(List, Idx),
    get_rand_list_repeat(N - 1, List, Len, [Rand|AccList]).


%% ---------------------------------------------------------------------------
%% @doc 从列表中根据权重概率随机出N个元素.取出来不重复
-spec list_rand_by_weight(WeightList :: [{Weight :: integer(), term()}], N :: integer()) -> Elems :: [term()].
%% ---------------------------------------------------------------------------
list_rand_by_weight(WeightList, N) when is_list(WeightList) andalso N >=0 ->
    Length = length(WeightList),
    case N of
        0 -> [];
        Num1 when Num1 >= Length ->
            [Elem || {_Weight, Elem} <- WeightList];
        Num2 when Num2 < Length ->
            TotalWeight = lists:foldl(
                            fun({Weight, _Gain}, Sum) -> Weight + Sum end, 0, WeightList
                           ),
            list_rand_by_weight(WeightList, N, TotalWeight, []);
        _ ->
            []
    end.
list_rand_by_weight(WeightList, N, TotalWeight, Result) when N >= 1 ->
    RandWeight = urand:rand(1, TotalWeight),
    {Weight, Gain} = find_one_gain_by_rate(WeightList, RandWeight, 1, 0),
    NewWeightList = lists:delete({Weight, Gain}, WeightList),
    list_rand_by_weight(NewWeightList, N-1, TotalWeight-Weight, [Gain | Result]);
list_rand_by_weight(_WeightList, _N, _TotalWeight, Result) ->
    Result.

find_one_gain_by_rate(List, RandWeight, ArrayNth, LeftValue) ->
    {Weight, Gain} = lists:nth(ArrayNth, List),
    RightValue = LeftValue + Weight,
    case RandWeight > LeftValue andalso RandWeight =< RightValue of
        true ->
            {Weight, Gain};
        false ->
            find_one_gain_by_rate(List, RandWeight, ArrayNth + 1, RightValue)
    end.

%% 重复抽取
%% @param WeightList [term()]
%% @param No 元组中权重的位置
%% @param Num 数量
%% @return WeightList 带权重的
repeat_list_rand_by_weight(WeightList, No, Num) ->
    F = fun(RatioInfo, {List, Sum}) -> 
        case element(No, RatioInfo) == 0 of
            true -> {List, Sum};
            false -> {[RatioInfo|List], element(No, RatioInfo) + Sum}
        end
    end,
    {NWeightList, TotalRatio} = lists:foldl(F, {[], 0}, WeightList),
    case NWeightList == [] of
        true -> [];
        false ->
            F2 = fun(_Seq, List) -> 
                Rand = urand:rand(1, TotalRatio),
                {ok, [repeat_list_rand_by_weight(NWeightList, 0, Rand, No) | List]} 
            end,
            {ok, NWeightList2} = util:for(1, Num, F2, []),
            NWeightList2
    end.

%% 查找匹配机率的值
repeat_list_rand_by_weight(InfoList, Start, Rand, No) ->
    [Info | List] = InfoList,
    End = Start + element(No, Info),
    case Rand > Start andalso Rand =< End of
        true -> Info;
        false -> repeat_list_rand_by_weight(List, End, Rand, No)
    end.

%% 随机打乱list元素顺序
list_shuffle(L) ->
    Len = length(L)+10000,
    List1 = [{rand(1, Len), X} || X <- L],
    List2 = lists:sort(List1), 
    [E || {_, E} <- List2].
