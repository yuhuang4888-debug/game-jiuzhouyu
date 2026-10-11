%% ---------------------------------------------------------------------------
%% @doc ulists
%% @author ming_up@foxmail.com
%% @since  2015-11-26
%% @deprecated  lists模块拓展
%% ---------------------------------------------------------------------------
-module(ulists).
-include("common.hrl").
-include("def_goods.hrl").
-export([
        concat/1                    %% 列表元素连接
        , explode/3                 %% 分割字符串
        , implode/2                 %% 组装字符串
        , list_plus/1               %% 列表元素对应相加
        , kv_list_plus/1            %% key-value列表对应相加
        , kv_list_plus_extra/1      %% key-value列表元素相加，不要求列表元素对应
        , kv_list_minus_extra/2     %% key-value列表元素相加，不要求列表元素对应
        , kv_list_minus_extra/1     %% key-value列表元素相减，不要求列表元素对应
        , object_list_plus/1        %% object_list列表对应相加
        , object_list_plus_extra/1  %% object_list列表对应相加 支持 ?TYPE_BIND_GOODS, ?TYPE_ATTR_GOODS
        , object_list_merge/1
        , list_shuffle/1            %% 列表随机
        , thing_to_list/1           %% 变为列表
        , list_to_bin/1             %% 列表(元素可以>255)转换为二进制
        , list_to_string/2          %% 列表转化
        , is_same_string/2          %% 判断两个字符串是否相同
        , find/2                    %% 根据条件查找符合的第一个元素
        , find_index/2              %% 根据条件查找符合的第一个元素的序号
        , sorted_insert/3           %% 按照排序规则往有序列表插入一个元素
        , sublist/2
        , is_in_range/2
        % , disorganize/1             %% 打乱一个列表 已有list_shuffle
        , elem_multiply/2           %% 列表里每个元素裂变多次
        , average/1
        , tuple_list_avg/2
        , removal_duplicate/1       %% 去重
        , keyfind/4                 %% 查找元组
        , group/2                   %% 根据下表进行分组
        , kv_list_subtract/2        %% key-value 相减
        , split_stable_num_list/2
        , split/2                   %% 分割列表，与lists:split/2有所区别
        , to_sql_list/1             %% 把列表转换成sql语句范围用于 ... where... in (...)
        ]).

%% 在List中的每两个元素之间插入一个分隔符
implode(_S, [])->
    [<<>>];
implode(S, L) when is_list(L) ->
    implode(S, L, []).
implode(_S, [H], NList) ->
    lists:reverse([thing_to_list(H) | NList]);
implode(S, [H | T], NList) ->
    L = [thing_to_list(H) | NList],
    implode(S, T, [S | L]).

%% 字符->列
explode(S, B)->
    re:split(B, S, [{return, list}]).
explode(S, B, int) ->
    [list_to_integer(Str) || Str <- explode(S, B), length(Str) > 0].


%% 列表元素连接
concat(List) ->
    lists:flatmap(fun thing_to_list/1, List).

thing_to_list(X) when is_integer(X) -> integer_to_list(X);
thing_to_list(X) when is_float(X)   -> float_to_list(X);
thing_to_list(X) when is_atom(X)    -> atom_to_list(X);
thing_to_list(X) when is_binary(X)  -> binary_to_list(X);
thing_to_list(X) when is_list(X)    -> X.
    % XBin = ulists:list_to_bin(X),
    % binary_to_list(XBin).
    % X.


%% 随机打乱list元素顺序
list_shuffle(L) ->
    Len = length(L)+10000,
    List1 = [{urand:rand(1, Len), X} || X <- L],
    List2 = lists:sort(List1),
    [E || {_, E} <- List2].

%% 列表元素对应相加
list_plus([List]) -> List;
list_plus([List1, List2|T]) ->
    SumList = list_plus(List1, List2, []),
    list_plus([SumList|T]).

list_plus([], _, Result) -> lists:reverse(Result);
list_plus(_, [], Result) -> lists:reverse(Result);
list_plus([H1|T1], [H2|T2], Result) ->
    list_plus(T1, T2, [H1+H2|Result]).

%% key-value列表元素对应相加
kv_list_plus([List]) -> List;
kv_list_plus([List1, List2|T]) ->
    SumList = kv_list_plus(lists:keysort(1,List1), lists:keysort(1,List2), []),
    kv_list_plus([SumList|T]).

kv_list_plus([], T, Result) -> T++Result;
kv_list_plus(T, [], Result) -> T++Result;
kv_list_plus([{K,V1}|T1], [{K,V2}|T2], Result) ->
    kv_list_plus(T1, T2, [{K,V1+V2}|Result]);
kv_list_plus([{_,_}|_]=L1, [{K2,V2}|T2], Result) ->
    kv_list_plus(L1, T2, [{K2,V2}|Result]).

%% key-value列表元素相加，不要求列表元素对应
kv_list_plus_extra([List]) -> List;
kv_list_plus_extra([List1, List2|T]) ->
    SumList = kv_list_plus_extra(List1, List2),
    kv_list_plus_extra([SumList|T]);
kv_list_plus_extra([]) -> [].

kv_list_plus_extra(List, []) -> List;
kv_list_plus_extra(List1, [{K, V2}|T]) ->
    case lists:keyfind(K, 1, List1) of
        {K, V1} -> V = V1 + V2;
        false -> V = V2
    end,
    kv_list_plus_extra(lists:keystore(K, 1, List1, {K, V}), T).

%% key-value列表元素相减，不要求列表元素对应
kv_list_minus_extra([List]) -> List;
kv_list_minus_extra([List1, List2|T]) ->
    SumList = kv_list_minus_extra(List1, List2),
    kv_list_minus_extra([SumList|T]);
kv_list_minus_extra([]) -> [].

kv_list_minus_extra(List, []) -> List;
kv_list_minus_extra(List1, [{K, V2}|T]) ->
    case lists:keyfind(K, 1, List1) of
        {K, V1} -> kv_list_minus_extra(lists:keystore(K, 1, List1, {K, max(0, V1-V2)}), T);
        false -> kv_list_minus_extra(List1, T)
    end.

%% object_list列表元素相加，不要求列表元素对应 只支持格式为 [{TYPE, Id, Num}]
object_list_plus([List]) ->
    F = fun
    ({ {ObjectType, GoodsId}, Num}, AccList) ->
        [{ObjectType, GoodsId, Num}| AccList];
    ({ObjectType, GoodsId, Num}, AccList) ->
        [{ObjectType, GoodsId, Num}| AccList]
    end,
    lists:foldl(F, [], List);
object_list_plus([List1, List2|T]) ->
    NewList1 = object_list_plus([], List2),
    SumList = object_list_plus(NewList1, List1),
    object_list_plus([SumList|T]).

object_list_plus(List, []) -> List;
object_list_plus(List1, [{ObjectType, GoodsId2, Num2}|T]) ->
    NewObjectList = case lists:keyfind({ObjectType, GoodsId2}, 1, List1) of
        {_, GoodsNum} -> [{ {ObjectType, GoodsId2}, Num2+GoodsNum}| lists:keydelete({ObjectType, GoodsId2}, 1, List1)];
        false    -> [{ {ObjectType, GoodsId2}, Num2} | List1]
    end,
    object_list_plus(NewObjectList, T);
object_list_plus(List1, [{{ObjectType, GoodsId2}, Num2}|T]) ->
    NewObjectList = case lists:keyfind({ObjectType, GoodsId2}, 1, List1) of
        {_, GoodsNum} -> [{ {ObjectType, GoodsId2}, Num2+GoodsNum}| lists:keydelete({ObjectType, GoodsId2}, 1, List1)];
        false    -> [{ {ObjectType, GoodsId2}, Num2} | List1]
    end,
    object_list_plus(NewObjectList, T).

%% object_list列表元素相加
%% List: [{type, id, num}|{?TYPE_GOODS, id, num, bind}|{?TYPE_ATTR_GOODS, id, num, attrlist}]
object_list_plus_extra(List) ->
    F = fun(Item, {ComObjectList, OtherObjectList}) ->
        case Item of
            {Type, Id, Num} -> {[{Type, Id, Num}|ComObjectList], OtherObjectList};
            {?TYPE_GOODS, Id, Num, Bind} ->
                case lists:keyfind({?TYPE_GOODS, Id, Bind}, 1, OtherObjectList) of
                    {_, ONum} ->
                        NOtherObjectList = [{{?TYPE_GOODS, Id, Bind}, ONum+Num}|lists:keydelete({?TYPE_GOODS, Id, Bind}, 1, OtherObjectList)];
                    _ -> NOtherObjectList = [{{?TYPE_GOODS, Id, Bind}, Num}|OtherObjectList]
                end,
                {ComObjectList, NOtherObjectList};
            {?TYPE_ATTR_GOODS, Id, Num, AttrList} ->
                {ComObjectList, [{?TYPE_ATTR_GOODS, Id, Num, AttrList}|OtherObjectList]};
            _ -> {ComObjectList, OtherObjectList}
        end
    end,
    {NewComObjectList, NewOtherObjectList} = lists:foldl(F, {[], []}, List),
    LastOtherObjectList = lists:foldl(
        fun
            ({{ObjectType, GoodsId, Bind}, Num}, AccList) ->
                [{ObjectType, GoodsId, Num, Bind}| AccList];
            ({ObjectType, GoodsId, Num, AttrList}, AccList) ->
                [{ObjectType, GoodsId, Num, AttrList}| AccList]
        end,
        [], NewOtherObjectList),
    LastComObjectList = object_list_plus([[], NewComObjectList]),
    LastComObjectList ++ LastOtherObjectList.

object_list_merge(List) ->
    object_list_merge(List, []).

object_list_merge([], Acc) -> Acc;
object_list_merge([T|L], Acc) ->
    NewAcc = case T of
        {ObjectType, GoodsId, Num} ->
            case lists:keyfind(GoodsId, 2, Acc) of
                {ObjectType, GoodsId, PreNum} ->
                    [{ObjectType, GoodsId, PreNum + Num}|lists:keydelete(GoodsId, 2, Acc)];
                _ ->
                    [{ObjectType, GoodsId, Num}|Acc]
            end;
        _ -> Acc
    end,
    object_list_merge(L, NewAcc).

%% 本身所有元素小于255的list，直接转换为binary，防止重复编码
list_to_bin(String) ->
    case unicode:characters_to_binary(String, latin1, latin1) of
        TempBin when is_binary(TempBin) -> TempBin;
        {error, Bin, Rest} ->
            case unicode:characters_to_binary(Rest, unicode, unicode) of
                RestBin when is_binary(RestBin) -> list_to_binary([Bin, RestBin]);
                _ -> Bin
            end;
        _ -> <<>>
    end.

%% [A,B,C,D..] => "A,B,C,D"
list_to_string([], _Dot) -> "";
list_to_string(List, Dot) ->
    lists:concat(concat_with(List, Dot)).

concat_with([A], _Dot) ->
    [A];
concat_with([H|T], Dot) ->
    [H,Dot|concat_with(T, Dot)].

is_same_string(Str, OtherStr) ->
    case lib_vsn:is_en() orelse lib_vsn:is_id() of  %% 英文不区分大小写
        true ->
            Str1 = util:make_sure_list(Str),
            OtherStr1 = util:make_sure_list(OtherStr),
            string:to_lower(Str1) ==  string:to_lower(OtherStr1);
        _ ->
            StrBin = util:make_sure_binary(Str),
            OtherStrBin = util:make_sure_binary(OtherStr),
            StrBin == OtherStrBin
    end.


find(Pred, [H|T]) ->
    case Pred(H) of
        true ->
            {ok, H};
        false ->
            find(Pred, T)
    end;

find(_Pred, []) -> error.

find_index(Pred, List) ->
    find_index(Pred, List, 1).

find_index(Pred, [H|T], Index) ->
    case Pred(H) of
        true ->
            Index;
        false ->
            find_index(Pred, T, Index + 1)
    end;
find_index(_Pred, [], _Index) -> 0.

%% 往一个有序的列表里面插入一个数据，插在第一个与插入元素对比，返回true的元素的前面
-spec sorted_insert(F, Item, List) -> {Index, SortedList} when
      F :: fun((Elem :: T, Elem :: T) -> boolean()),
      Item :: T,
      List :: [T],
      Index :: integer(),
      SortedList :: [T],
      T :: term().

sorted_insert(F, Item, List) ->
    sorted_insert([], 1, F, Item, List).

sorted_insert(Acc, Index, F, Item, [H|T] = L) ->
    case F(Item, H) of
        true ->
            SortedList = lists:reverse([Item|Acc], L),
            {Index, SortedList};
        false ->
            sorted_insert([H|Acc], Index + 1, F, Item, T)
    end;
sorted_insert(Acc, Index, _F, Item, []) ->
    SortedList = lists:reverse([Item|Acc]),
    {Index, SortedList}.

%%--------------------------------------------------
%% 截取一定长度的列表
%% @param  L   list
%% @param  Len 长度
%% @return     {SubList, RemainList}
%%--------------------------------------------------
sublist(L, Len) ->
    do_sublist(L, Len, 0, []).

do_sublist(L, Len, Len, Acc) -> {lists:reverse(Acc), L};
do_sublist([], _, _, Acc) -> {lists:reverse(Acc), []};
do_sublist([T|L], Len, CurLen, Acc) ->
    do_sublist(L, Len, CurLen + 1, [T|Acc]).

%%--------------------------------------------------
%% 检测Val是否在列表中的某个范围值内
%% @param  List [{Min, Max}]
%% @param  Val  整数值
%% @return      {Min, Max}|false
%%--------------------------------------------------
is_in_range([], _) -> false;
is_in_range([T|L], Val) ->
    case T of
        {Min, Max} when Val >= Min andalso Val =< Max ->
            {Min, Max};
        _ -> is_in_range(L, Val)
    end;
is_in_range(_, _) -> false.


elem_multiply(List, N) when N > 1 ->
    [I || I <- List, _ <- lists:seq(1, N)];

%% 防止N有小数点出现的情况
elem_multiply(List, N) when is_float(N) ->
    [I || I <- List, _ <- lists:seq(1, umath:floor(N))];

elem_multiply(List, 1) ->
    List.

average([]) -> 0;
average(List) ->
    lists:sum(List) / length(List).

tuple_list_avg(_Index, []) -> 0;
tuple_list_avg(Index, List) ->
    F = fun(Tuple, Acc) -> element(Index, Tuple) + Acc end,
    SumLv = lists:foldl(F, 0, List),
    SumLv div length(List).

removal_duplicate(List) ->
    do_removal_duplicate(List, []).

do_removal_duplicate([], Acc) -> lists:reverse(Acc);
do_removal_duplicate([T|L], Acc) ->
    NewAcc = case lists:member(T, Acc) of
        false -> [T|Acc];
        _ -> Acc
    end,
    do_removal_duplicate(L,NewAcc).

keyfind(Key, N, TupleList, Default) ->
    case lists:keyfind(Key, N, TupleList) of
        false -> Default;
        Value -> Value
    end.

group(N, List) ->
    F = fun(Item, AccMap) ->
        Key = element(N, Item),
        Items = maps:get(Key, AccMap, []),
        AccMap#{Key => [Item|Items]}
    end,
    lists:foldl(F, #{}, List).

kv_list_subtract(KeyValueList, SubtractList) ->
    F = fun({K, V}, List) ->
        case lists:keyfind(K, 1, List) of
            {K, OldV} ->
                NewV = max(0, OldV - V),
                lists:keystore(K, 1, List, {K, NewV});
            _ ->
                List
        end
    end,
    NewKeyValueList = lists:foldl(F, KeyValueList, SubtractList),
    NewKeyValueList.

%% 拆出多个指定数量的列表
%% [1,2,3,4,5],2 => [[1,2], [3,4], [5]]
%% [1,2,3,4],2 => [[1,2], [3,4]]
split_stable_num_list(List, Num) when Num > 0 ->
    split_stable_num_list(List, 0, Num, [], []);
split_stable_num_list(List, _Num) ->
    split_stable_num_list(List, 0, 1, [], []).

split_stable_num_list([], _Min, _Max, [], SplitL) -> lists:reverse(SplitL);
split_stable_num_list([], _Min, _Max, StableL, SplitL) -> lists:reverse([StableL|SplitL]);
split_stable_num_list([H|T], Min, Max, StableL, SplitL) ->
    case Min + 1 == Max of
        true ->
            NewStableL = lists:reverse([H|StableL]),
            split_stable_num_list(T, 0, Max, [], [NewStableL|SplitL]);
        false ->
            split_stable_num_list(T, Min+1, Max, [H|StableL], SplitL)
    end.

%% split(N, List) -> {PreList, TailList}.
%% 与lists:split(N, List)行为不同，如果List不够长度N，则PreList = List, TailList = []
split(N, List) ->
    split(N, List, []).
split(0, List, PreList) ->
    {lists:reverse(PreList), List};
split(N, [H | List], PreList) ->
    split(N - 1, List, [H | PreList]);
split(_, [], PreList) ->
    {lists:reverse(PreList), []}.

%% 把整数列表转换成sql语句范围字符串
%% @param L :: [integer(),...]
%% @return "I1,I2..."
to_sql_list(L) -> to_sql_list(L, "").

to_sql_list([], "") -> "";
to_sql_list([], [_ | AccStr]) -> AccStr; % 去除头部多余逗号
to_sql_list([H | T], AccStr) when is_integer(H) ->
    to_sql_list(T, lists:append(AccStr, "," ++ integer_to_list(H)));
to_sql_list([_ | T], AccStr) ->
    to_sql_list(T, AccStr).
