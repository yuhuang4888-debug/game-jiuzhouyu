%%-----------------------------------------------------------------------------
%% @Module  :       usql
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-04
%% @Description:    sql语句工具类
%%-----------------------------------------------------------------------------

-module(usql).

-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").
-include("common.hrl").

%% 拼接表格的fileds列表, select @(name, type, level)，只接受原子参数.
k_column(S) when is_atom(S) -> "`"++ atom_to_list(S) ++ "`".

k_column_list(all) -> ["*"];
k_column_list([H]) ->
    H1 = k_column(H), [H1];
k_column_list([H|L]) ->
    H1 = k_column(H),
    [H1, ", "] ++ k_column_list(L).

%% 拼接语句中可能出现的value列表，只接受数字，二进制和列表
v_column(V) when is_integer(V) -> integer_to_list(V);
v_column(<<V/binary>>) -> <<$", V/binary, $">>;
v_column(V) when is_list(V) ->
    B = list_to_binary(V),
    <<$", B/binary, $">>.

v_column_list([H]) ->
    H1 = v_column(H), [H1];
v_column_list([H|L]) ->
    H1 = v_column(H),
    [H1, ", "] ++ v_column_list(L).

%% 拼接kv串，用作where语句查询
kv_column_value_list(_, [{K, V}]) ->
    K1 = k_column(K),
    V1 = v_column(V),
    [K1, " = ", V1];
kv_column_value_list(C, [{K, V}| L]) ->
    K1 = k_column(K),
    V1 = v_column(V),
    [K1, " = ", V1, C] ++ kv_column_value_list(C, L).

limit(V) ->
    [" LIMIT ", integer_to_list(V)].

%% 条件语句
condition({Key, in, ValueList}) ->
    [" WHERE "] ++ k_column(Key) ++ " IN (" ++ v_column_list(ValueList) ++ ")";
condition(all) ->
    [];
condition(Cond) ->
    [" WHERE "] ++ kv_column_value_list(" and ", Cond).

%% only atom
table_name(Table) when is_atom(Table) -> "`" ++ atom_to_list(Table) ++ "`".
from(Table) -> [" FROM ", table_name(Table)].

%%================================各种语句拼接====================================

-spec select(atom(), list(), list()) -> binary().

%% 拼接查询语句
select(Table, Column, Cond) ->
    L = "SELECT " ++ k_column_list(Column)  ++ from(Table) ++ condition(Cond) ++";",
    list_to_binary(L).

%% select_test() ->
%%     <<"SELECT `id`, `name` FROM `users` WHERE `id` = 23;">>
%%         = select(users, [id, name], [{id, 23}]).

-spec select(atom(), list(), list(), integer()) -> binary().

select(Table, Column, Cond, Limit) ->
    L = "SELECT " ++ k_column_list(Column)  ++ from(Table)
        ++ condition(Cond) ++ limit(Limit) ++";",
    list_to_binary(L).

%% select_e_test() ->
%%     <<"SELECT `id`, `name` FROM `users` WHERE `id` = 23 LIMIT 3;">>
%%         = select(users, [id, name], [{id, 23}], 3).


%% 拼接更新语句.
update(Table, Column, Cond) ->
      L = "UPDATE "
        ++ table_name(Table)
        ++ " SET "
        ++ kv_column_value_list(", ", Column)
        ++ condition(Cond)
        ++ ";",
      list_to_binary(L).

%% %% 拼接更新语句
%% update_test() ->
%%     <<"UPDATE `user` SET `name` = \"fe\", `value` = \"fewf\" WHERE `id` = 23;">>
%%         = update(user, [{name, <<"fe">>}, {value,  <<"fewf">>}], [{id, 23}]).

%% 拼接删除语句
delete(Table, Cond) ->
    L = "DELETE"
        ++ from(Table)
        ++ condition(Cond)
        ++ ";",
    list_to_binary(L).

%% delete_test() ->
%%   <<"DELETE FROM `user` WHERE `id` = 23;">>
%%     = delete(user, [{id, 23}]),
%%   <<"DELETE FROM `user` WHERE `id` IN (1, 2, 3);">>
%%     = delete(user, {id, in, [1,2,3]}).

combine_val_list([], Acc) -> Acc;
combine_val_list([T|L], TAcc) ->
    case TAcc =/= "" of
        true ->
            Acc = TAcc ++ " , ";
        false ->
            Acc = TAcc
    end,
    NewAcc = Acc ++ " ( " ++ v_column_list(T) ++ " )",
    combine_val_list(L, NewAcc).

insert(_Table, KeyList, ValList) when KeyList == [] orelse ValList == [] -> "";
insert(Table, KeyList, ValList) ->
    CombineValL = combine_val_list(ValList, ""),
    L = "INSERT INTO "
      ++ table_name(Table)
      ++ "( "
      ++ k_column_list(KeyList)
      ++ " )"
      ++ " VALUES "
      ++ CombineValL,
  list_to_binary(L).

%% insert_test() ->
%%     insert(user, [id, name], [[23, <<"xx">>], [22, <<"xx">>]]).

replace(_Table, KeyList, ValList) when KeyList == [] orelse ValList == [] -> "";
replace(Table, KeyList, ValList) ->
    CombineValL = combine_val_list(ValList, ""),
    L = "REPLACE INTO "
      ++ table_name(Table)
      ++ "( "
      ++ k_column_list(KeyList)
      ++ " )"
      ++ " VALUES "
      ++ CombineValL,
  list_to_binary(L).

max(Table, Field, Cond) ->
    L = "SELECT MAX(" ++ k_column(Field) ++ ") "
      ++ from(Table)
      ++ condition(Cond),
    list_to_binary(L).

%% max_test() ->
%%     <<"select max(`id`)  FROM `buildings` WHERE `name` = \"nice\"">>
%%       = ?MODULE:max(buildings, id, [{name, <<"nice">>}]),
%%     <<"select max(`id`)  FROM `buildings`">>
%%       = ?MODULE:max(buildings, id, all),
%%     ok.

count(Table, Cond) ->
    L = "SELECT COUNT(*) "
      ++ from(Table)
      ++ condition(Cond),
    list_to_binary(L).

count(Table, Col, Cond) ->
    L = "SELECT COUNT(" ++ k_column(Col) ++ ") "
      ++ from(Table)
      ++ condition(Cond),
    list_to_binary(L).

%% count_test() ->
%%   <<"select count(*)  FROM `building` WHERE `name` = \"nice\"">>
%%     = count(building, [{name, <<"nice">>}]),
%%   <<"select count(*)  FROM `building`">>
%%     = count(building, all),
%%   ok.
