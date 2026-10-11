%%-----------------------------------------------------------------------------
%% @Module  :       lib_dynamic_compile
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-06
%% @Description:    动态生成文件编译
%%-----------------------------------------------------------------------------
-module(lib_dynamic_compile).

-include("extra.hrl").
-include("common.hrl").

-export([
    dynamic_compile_cfg/1,
    init_cfg/1
    ]).

-define(DEBUG,      false).

%% lib_dynamic_compile:dynamic_compile_cfg(2)

dynamic_compile_cfg(CfgType) ->
    {FileName, Cfg} = init_cfg(CfgType),
    case ?DEBUG of
        true ->
            {ok, FilePath} = create_file(FileName, Cfg),
            c:c(FilePath);
        _ ->
            {Mod, Code} = dynamic_compile:from_string(Cfg),
            code:load_binary(Mod, FileName, Code)
    end.

init_cfg(CfgType) ->
    #{
        module := ModuleName,
        % hrl := HrlList,
        function := FunctionList
    } = data_extra_cfg:get_extra_cfg(CfgType),
    FileName = lists:concat([ModuleName, ".erl"]),
    Module = lists:concat(["-module(", ModuleName, ").\n\n"]),
    % IncludeHrl = init_hrl(HrlList, []),
    Export = "\n-compile(export_all).\n\n",
    Function = init_func(FunctionList, CfgType, []),
    {FileName, lists:concat([Module, Export, Function])}.

% init_hrl([], Acc) -> Acc;
% init_hrl([Hrl|HrlList], Acc) ->
%     One = lists:concat(["-include(\"", Hrl, "\").\n"]),
%     init_hrl(HrlList, Acc ++ One).

init_func([], _CfgType, Acc) -> Acc;
init_func([#{func_type := ?EXTRA_CFG_FUNC_TYPE_1} = Map|L], CfgType, Acc) ->
    #{
        table := Table,
        record := RecordName,
        name := FuncName,
        input := InputColL,
        time_form := TimeFormColL
    } = Map,
    %% [[<<"name">>], [<<"name">>]]
    DBName = config:get_mysql(db_name),
    ColNameBinL = db:get_all(io_lib:format(<<"select COLUMN_NAME from information_schema.COLUMNS where table_name = \'~s\' and TABLE_SCHEMA = \'~s\'">>, [Table, DBName])),
    ColNameL = [util:bitstring_to_term(ColNameBin) || [ColNameBin] <- ColNameBinL],
    case ColNameL =/= [] of
        true ->
            Sql = make_sql1(ColNameL, TimeFormColL, Table, "select "),
            AllData = db:get_all(Sql);
        _ -> AllData = []
    end,
    DataStr = do_init_func1(AllData, ColNameL, CfgType, FuncName, InputColL, RecordName, []),
    init_func(L, CfgType, Acc ++ DataStr);
init_func([#{func_type := ?EXTRA_CFG_FUNC_TYPE_2} = Map|L], CfgType, Acc) ->
    #{
        table := Table,
        name := FuncName,
        out_put := OutputL
    } = Map,
    Sql = make_sql2(OutputL, Table, "select "),
    DBName = config:get_mysql(db_name),
    case db:get_all(io_lib:format(<<"select table_name from information_schema.COLUMNS where table_name = \'~s\' and TABLE_SCHEMA = \'~s\'">>, [Table, DBName])) of
        Val when Val =/= [] ->
            AllData = db:get_all(Sql);
        _ -> AllData = []
    end,
    Output = case length(OutputL) > 1 of
        true ->
            [list_to_tuple(OneData) || OneData <- AllData];
        _ ->
            [OneData || [OneData] <- AllData]
    end,
    DataStr = lists:concat([FuncName, "() -> \n\t", util:term_to_string(Output), ".\n\n"]),
    init_func(L, CfgType, Acc ++ DataStr);
init_func([#{func_type := ?EXTRA_CFG_FUNC_TYPE_3} = Map|L], CfgType, Acc) ->
    #{
        table := Table,
        name := FuncName,
        input := InputColL,
        out_put := OutputColL
    } = Map,
    DBName = config:get_mysql(db_name),
    ColNameBinL = db:get_all(io_lib:format(<<"select COLUMN_NAME from information_schema.COLUMNS where table_name = \'~s\' and TABLE_SCHEMA = \'~s\'">>, [Table, DBName])),
    ColNameL = [util:bitstring_to_term(ColNameBin) || [ColNameBin] <- ColNameBinL],
    case ColNameL =/= [] of
        true ->
            Sql = make_sql3(ColNameL, Table, "select "),
            AllData = db:get_all(Sql);
        _ -> AllData = []
    end,
    DataStr = do_init_func3(AllData, ColNameL, CfgType, FuncName, InputColL, OutputColL, length(OutputColL), #{}),
    init_func(L, CfgType, Acc ++ DataStr);
init_func([_|L], CfgType, Acc) ->
    init_func(L, CfgType, Acc).

do_init_func1([], _ColNameL, _CfgType, FuncName, InputColL, _RecordName, Acc) ->
    AnyParamStr = make_any_param_str(length(InputColL)),
    RemainderStr = lists:concat([FuncName, "(", AnyParamStr, ") ->\n\t [].\n\n"]),
    Acc ++ RemainderStr;
do_init_func1([Data|DataL], ColNameL, CfgType, FuncName, InputColL, RecordName, Acc) ->
    RealData = init_data(Data, []),
    % Head = lists:concat(["#", RecordName, "{"]),
    Head = lists:concat(["{", RecordName, ", "]),
    {Input, Output} = do_init_func_core1(RealData, ColNameL, InputColL, [], Head),
    OneFunc = lists:concat([FuncName, "(", Input, ") -> \n\t", Output, ";\n"]),
    do_init_func1(DataL, ColNameL, CfgType, FuncName, InputColL, RecordName, OneFunc ++ Acc).

do_init_func_core1([], _, _InputColL, [], Output) ->
    {[], Output};
do_init_func_core1([], _, _InputColL, Input, Output) ->
    SortInput = lists:keysort(1, Input),
    NewInput = [Val || {_, Val} <- SortInput],
    LastInput = util:link_list(NewInput),
    {LastInput, Output};
do_init_func_core1([OneData|L1], [ColName|L2], InputColL, Input, Output) ->
    NewInput = case is_in_col(InputColL, ColName, 1) of
        {ok, Index} ->
            [{Index, OneData}|Input];
        _ ->
            Input
    end,
    % NewOutput = case L1 =/= [] of
    %     true ->
    %         lists:concat([Output, ColName, " = ", util:term_to_string(OneData), ", "]);
    %     _ ->
    %         lists:concat([Output, ColName, " = ", util:term_to_string(OneData), "}"])
    % end,
    NewOutput = case L1 =/= [] of
        true ->
            lists:concat([Output, util:term_to_string(OneData), ", "]);
        _ ->
            lists:concat([Output, util:term_to_string(OneData), "}"])
    end,
    do_init_func_core1(L1, L2, InputColL, NewInput, NewOutput).

do_init_func3([], _ColNameL, _CfgType, FuncName, InputColL, _OutputColL, _OutputColLen, Map) ->
    AnyParamStr = make_any_param_str(length(InputColL)),
    RemainderStr = lists:concat([FuncName, "(", AnyParamStr, ") ->\n\t [].\n\n"]),
    F = fun({Key, Val}, Acc) ->
        lists:concat([FuncName, "(", util:link_list(Key), ") -> \n\t", util:term_to_string(ulists:removal_duplicate(Val)), ";\n", Acc])
    end,
    NewAcc = lists:foldl(F, [], maps:to_list(Map)),
    NewAcc ++ RemainderStr;
do_init_func3([Data|DataL], ColNameL, CfgType, FuncName, InputColL, OutputColL, OutputColLen, Map) ->
    RealData = init_data(Data, []),
    {Input, Output} = do_init_func_core3(RealData, ColNameL, InputColL, OutputColL, OutputColLen, [], []),
    OldOutput = maps:get(Input, Map, []),
    NewMap = maps:put(Input, Output ++ OldOutput, Map),
    do_init_func3(DataL, ColNameL, CfgType, FuncName, InputColL, OutputColL, OutputColLen, NewMap).

% do_init_func_core3([], _, _InputColL, [], Output) ->
%     {[], Output};
do_init_func_core3([], _, _InputColL, _OutputColL, OutputColLen, Input, Output) ->
    SortInput = lists:keysort(1, Input),
    NewInput = [Val || {_, Val} <- SortInput],
    SortOutput = lists:keysort(1, Output),
    NewOutput = case OutputColLen > 1 of
        true ->
            [list_to_tuple([Val || {_, Val} <- SortOutput])|[]];
        _ ->
            [Val || {_, Val} <- SortOutput]
    end,
    {NewInput, NewOutput};
do_init_func_core3([OneData|L1], [ColName|L2], InputColL, OutputColL, OutputColLen, Input, Output) ->
    NewInput = case is_in_col(InputColL, ColName, 1) of
        {ok, Index1} ->
            [{Index1, OneData}|Input];
        _ ->
            Input
    end,
    NewOutput = case is_in_col(OutputColL, ColName, 1) of
        {ok, Index2} ->
            [{Index2, OneData}|Output];
        _ ->
            Output
    end,
    do_init_func_core3(L1, L2, InputColL, OutputColL, OutputColLen, NewInput, NewOutput).

make_sql1([], _, _, Acc) -> Acc;
make_sql1([ColName|ColNameL], TimeFormColL, TableName, Acc) ->
    NewAcc = case lists:member(ColName, TimeFormColL) of
        true ->
            case ColNameL =/= [] of
                true ->
                    lists:concat([Acc, "ROUND(UNIX_TIMESTAMP(`", ColName, "`)), "]);
                _ ->
                    lists:concat([Acc, "ROUND(UNIX_TIMESTAMP(`", ColName, "`)) from ", TableName])
            end;
        _ ->
            case ColNameL =/= [] of
                true ->
                    lists:concat([Acc, "`", ColName, "`, "]);
                _ ->
                    lists:concat([Acc, "`", ColName, "` from ", TableName])
            end
    end,
    make_sql1(ColNameL, TimeFormColL, TableName, NewAcc).

make_sql2([], _, Acc) -> Acc;
make_sql2([ColName|ColNameL], TableName, Acc) ->
    NewAcc = case ColNameL =/= [] of
        true ->
            lists:concat([Acc, "`", ColName, "`, "]);
        _ ->
            lists:concat([Acc, "`", ColName, "` from ", TableName])
    end,
    make_sql2(ColNameL, TableName, NewAcc).

make_sql3([], _, Acc) -> Acc;
make_sql3([ColName|ColNameL], TableName, Acc) ->
    NewAcc = case ColNameL =/= [] of
        true ->
            lists:concat([Acc, "`", ColName, "`, "]);
        _ ->
            lists:concat([Acc, "`", ColName, "` from ", TableName])
    end,
    make_sql3(ColNameL, TableName, NewAcc).

init_data([], Acc) -> lists:reverse(Acc);
init_data([Data|L], Acc) ->
    NewAcc = case is_binary(Data) of
        true ->
            case util:bitstring_to_term(Data) of
                undefined ->
                    [Data|Acc];
                Val ->
                    [Val|Acc]
            end;
        _ ->
            [Data|Acc]
    end,
    init_data(L, NewAcc).

is_in_col([], _, _) -> false;
is_in_col([T|L], ColName, Index) ->
    case T == ColName of
        true ->
            {ok, Index};
        _ ->
            is_in_col(L, ColName, Index + 1)
    end.

% %% 使列表的参数都变成字符串
% make_string_list(List) when is_list(List) ->
%     F = fun(T) -> util:term_to_string(T) end,
%     lists:map(F, List);
% make_string_list(T) ->
%     [util:term_to_string(T)].

%% 生成任意参数的字符串
make_any_param_str(ParamLen) ->
    F = fun(_) -> "_" end,
    ListStr = lists:map(F, lists:seq(1, ParamLen)),
    string:join(ListStr, ", ").

%% 生成配置文件
create_file(FileName, DataStr) ->
    Path = lists:concat(["../src/data/", FileName]),
    {ok, F} = file:open(Path, [write]),
    io:format(F, unicode:characters_to_list(DataStr), []),
    {ok, Path}.