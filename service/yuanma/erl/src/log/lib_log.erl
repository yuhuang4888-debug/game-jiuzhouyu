%% ---------------------------------------------------------------------------
%% @doc lib_log
%% @author ming_up@foxmail.com
%% @since  2016-07-28
%% @deprecated 日志系统库函数
%% ---------------------------------------------------------------------------
-module(lib_log).
-include("common.hrl").
-export([to_db/2]).

%% Note: ArgsList与插入顺序是反的
to_db(Type, ArgsList) ->
    case catch execute_db(Type, ArgsList) of
        {'EXIT', Reason} -> 
            ?PRINT("log format error Type:~p, ArgsList:~p, Reason:~p~n, ", [Type, ArgsList, Reason]),
            ?ERR("log format error Type:~p, ArgsList:~p, Reason:~p~n, ", [Type, ArgsList, Reason]);
        _ -> ok
    end.

execute_db(Type, ArgsList) -> 
    {TableName, Columns} = data_log:get_log(Type),
    Pos = to_sql_string(ArgsList, []),
    Sql = lists:concat(["insert into ", TableName, " (", Columns, ") values ", Pos]),
    SqlB = ulists:list_to_bin(Sql),
    db:execute(SqlB).

to_sql_string([V], Result) -> 
    One = to_sql_string_helper(V, []),
    lists:concat(["(", One, ")"| Result]);
to_sql_string([V|T], Result) -> 
    One = to_sql_string_helper(V, []),
    to_sql_string(T, [", (", One, ")"|Result]).

to_sql_string_helper([H], Result) -> 
    lists:concat(lists:reverse(["'", uio:thing_to_string(H), "'"| Result]));
to_sql_string_helper([H|T], Result) -> 
    to_sql_string_helper(T, ["', ", uio:thing_to_string(H), "'"| Result]).
