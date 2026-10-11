%% ---------------------------------------------------------------------------
%% @doc tool.erl
%% @author ming_up@foxmail.com
%% @since  2016-02-17
%% @deprecated 工具类，辅助分析类函数
%% ---------------------------------------------------------------------------
-module(tool).
-compile(export_all).

-include("common.hrl").

%%获取客户端ip
get_ip(TransMod, Socket) ->
    case TransMod:peername(Socket) of
        {ok, {Ip, _Port}} -> Ip;
        _ -> {0,0,0,0}
    end.

%% IP元组转字符
ip2bin(IpBinary) when is_binary(IpBinary)-> binary_to_list(IpBinary);
ip2bin(IpList) when is_list(IpList)-> IpList;
ip2bin({A, B, C, D}) ->
    [integer_to_list(A), ".", integer_to_list(B), ".", integer_to_list(C), ".", integer_to_list(D)].

%% 字符转IP元组
%% @param Binary <<"1.2.3.4">>
bin2ip(Binary) ->
    Str = binary_to_list(Binary),
    case string:tokens(Str, ".") of
        [A, B, C, D] -> {list_to_integer(A), list_to_integer(B), list_to_integer(C), list_to_integer(D)};
        _ -> Str
    end.

%% node输出ip
node_to_ip(Node) ->
    case split_node(atom_to_list(Node), $@, []) of
        [_, Host] -> inet:getaddr(Host, inet);
        _ -> no_node_name
    end.

split_node([Chr|T], Chr, Ack) -> [lists:reverse(Ack)|split_node(T, Chr, [])];
split_node([H|T], Chr, Ack)   -> split_node(T, Chr, [H|Ack]);
split_node([], _, Ack)        -> [lists:reverse(Ack)].

%% 输出进程为error,error_report,crash_report,warning_report到"../logs/rb.txt"
rb() ->
    %% 路径
    Path = "../logs/rb.txt",
    %% 日期
    {{Y, M, D},{H, I, S}} = erlang:localtime(),
    Format  = list_to_binary("============start data: ~s =============\r\n~n"),
    Date    = list_to_binary(lists:concat([Y,"-",M,"-",D," ",H,":",I,":",S])),
    %% 输入日期
    {ok, F} = file:open(Path, [write, append]),
    io:format(F, unicode:characters_to_list(Format), [Date]),
    file:close(F),
    %% rb模块
    rb:start([{start_log, Path}, {type, [error,error_report,crash_report,warning_report]}]),
    rb:show(error),
    rb:show(error_report),
    rb:show(crash_report),
    rb:show(warning_report),
    ok.

%% 堆栈输出
back_trace() ->
    lists:foldl(
      fun({M, F, ArgNum, [{_File, _FileName}, {_Line, Line}]}, N) ->
              io:format("~s~p:~p/~p [line:~p]~n", [lists:append(lists:duplicate(N, " ")), M, F, ArgNum, Line]),
              N + 2 end, 0, try throw(42) catch 42 -> erlang:get_stacktrace()
                                          end
     ).

%% 堆栈文件输出
back_trace_to_file() ->
    lists:foldl(
      fun({M, F, ArgNum, [{_File, _FileName}, {_Line, Line}]}, N) ->
              ?INFO("~s~p:~p/~p [line:~p]~n", [lists:append(lists:duplicate(N, " ")), M, F, ArgNum, Line]),
              N + 2 end, 0, try throw(42) catch 42 -> erlang:get_stacktrace()
                                          end
     ).

%% 生成错误码数据库txt err999_11111
%% base_error_code:module,type,id,about 
%% test: tool:create_error_code_sql("E:\\ZiSu\\lzhx\\lzhx_kf\\code\\erl\\src", 610)
create_error_code_sql(DirStr, Pt) ->
    FilenameList = get_filename_list(DirStr),
    {ok, MatchPattern} = re:compile(lists:concat(["err", Pt, "_\\w*"])),
    F = fun(Filename, TmpList) ->
        {ok, ContentBin} = file:read_file(Filename),
        Content = binary_to_list(ContentBin),
        case re:run(Content, MatchPattern, [global,{capture,first,list}]) of
            {match, MatchList} -> MatchList ++ TmpList;
            _ -> TmpList
        end
    end,
    List = lists:foldl(F, [], FilenameList),
    F2 = fun
        ([T], L) -> 
            Atom = list_to_atom(T),
            case lists:member(Atom, L) of
                true -> L;
                false -> [Atom|L]
            end;
        (_, L) ->
            L
    end,
    TypeList = lists:foldl(F2, [], List),
    F3 = fun(Type) ->
        case data_error_code:get(Type) of
            0 -> {Type, 0, <<""/utf8>>};
            Id ->
                case data_errorcode_msg:get(Id) of
                    #errorcode_msg{about = About} -> ok;
                    _ -> About = <<""/utf8>>
                end,
                {Type, Id, About}
        end
    end,
    TupleList = lists:map(F3, TypeList),
    SortList = lists:reverse(lists:keysort(2, TupleList)),
    case SortList of
        [] -> Max = 0;
        _ -> {_, Max, _} = hd(SortList)
    end,
    case Max == 0 of
        true -> NewMax = Pt*10000;
        false -> NewMax = Max
    end,
    F4 = fun({Type, Id, About}, {TmpList, TmpMax}) ->
        case Id == 0 of
            true -> { [{Type, TmpMax+1, About}|TmpList], TmpMax+1};
            false -> { [{Type, Id, About}|TmpList], TmpMax}
        end
    end,
    {NewSortList, _} = lists:foldr(F4, {[], NewMax}, SortList),
    NewSortList2 = lists:keysort(2, NewSortList),
    create_error_code_sql_done(NewSortList2, Pt, "").

create_error_code_sql_done([], _Pt, Acc) ->
    FileStr1 = "../logs/errcode_" ++ integer_to_list(_Pt) ++ util:term_to_string(calendar:now_to_datetime(os:timestamp())),
    FileStr2 = "logs/errcode_" ++ integer_to_list(_Pt) ++ util:term_to_string(calendar:now_to_datetime(os:timestamp())),
    case file:open(FileStr1, [write]) of
        {ok, F} -> ok;
        _ -> {ok, F} = file:open(FileStr2, [write])
    end,
    io:format(F, ulists:list_to_bin(Acc), []);
create_error_code_sql_done([{Type, Id, About}|L], Pt, Acc) ->
    Sql = <<"REPLACE INTO base_error_code(module, type, id, about) VALUES({1}, '{2}', {3}, '{4}');\n"/utf8>>, 
    Str = uio:format(Sql, [Pt, Type, Id, About]),
    % Str = lists:concat(["REPLACE INTO base_error_code(module, type, id, about) VALUES(", Pt, ", '", Type, "', ", Id, ", '", About, "');\n"]),
    create_error_code_sql_done(L, Pt, lists:concat([Acc, Str])).

test_create_error_code_sql() ->
    {ok, ContentBin} = file:read_file("D:\\erl_work\\st_project\\st_kf\\code\\erl\\src\\guild\\lib_guild_mod.erl"),
    Content = binary_to_list(ContentBin),
    {ok, MatchPattern} = re:compile(lists:concat(["err", 400, "_\\w*"])),
    re:run(Content, MatchPattern, [global,{capture, first,list}]).

%% 获取所有的文件名字列表
get_filename_list(Dir) when is_list(Dir) ->
    get_filename_list([Dir], []).

get_filename_list([], Acc) ->
    Acc;
get_filename_list([File|Tail], Acc) ->
    case filelib:is_dir(File) of
        true ->
            case file:list_dir(File) of
                {ok, NewFiles} ->
                    FullNewFiles = [filename:join(File, N) || N <- NewFiles],
                    get_filename_list(FullNewFiles ++ Tail, Acc);
                {error, _Reason} ->
                    get_filename_list(Tail, Acc)
            end;
        false ->
            get_filename_list(Tail, [File | Acc])
    end.

%% 自动生成logsql到对应文件
%% @param TableName [atom(), ...]
%% @test tool:auto_create_log([log_afk_back, log_afk]).
auto_create_log([]) -> ok;
auto_create_log([TableName|T]) ->
    auto_create_data_log(TableName),
    auto_create_lib_log(TableName),
    auto_create_log(T).

%% 生成 data_log
%% get_log(log_kf_san_medal) ->
%%  {"log_kf_san_medal","server_id,server_num,role_id,rol_name,scene,monid,reward,stime"};
%% select distinct(column_name) from information_schema.columns where table_name='log_kf_san_medal' and column_name<>'id'
auto_create_data_log(TableName) ->
    % 日志记录
    Sql = io_lib:format(<<"select distinct(column_name) from information_schema.columns where table_name='~s' and column_name<>'id'">>, [util:term_to_string(TableName)]),
    DbList = [lists:concat(["`", binary_to_list(ColumnBin), "`"])||ColumnBin<-lists:flatten(db:get_all(Sql))],
    ?PRINT("~p~n", [DbList]),
    CoumnNameL = util:link_list(DbList),
    Method = lists:concat(["get_log(", TableName, ") ->\n\r"]),
    Content = lists:concat(["    {\"",  TableName, "\", \"", CoumnNameL, "\"};\n\r\n\r"]),
    DataLog = lists:concat([Method, Content]), 
    ?PRINT("auto_create_log ~p~n", [DataLog]),
    % ?MYLOG("autolog", ConfigLog, []),
    auto_create_log_to_file("auto_data_log", DataLog),
    ok.

%% 生成 lib_log_api
auto_create_lib_log(TableName) ->
    % 接口日志记录
    Sql = io_lib:format(<<"select distinct(column_name) from information_schema.columns where table_name='~s' and column_name<>'id'">>, [util:term_to_string(TableName)]),
    DbList = [change_camel_case(ColumnBin)||ColumnBin<-lists:flatten(db:get_all(Sql))],
    CoumnNameL = util:link_list(DbList, ", "),
    Method = lists:concat([TableName, "(", CoumnNameL, ") ->\n\r"]),
    Content =  lists:concat(["    mod_log:add_log(",  TableName, ", [", CoumnNameL, "]),\n\r    ok.\n\r\n\r"]),
    LigLog = lists:concat([Method, Content]),
    auto_create_log_to_file("auto_lib_log", LigLog),
    ok.
    
%% 生成文件
auto_create_log_to_file(FileName, Acc) ->
    FileStr1 = "../logs/" ++ FileName, %++ "_" ++ util:term_to_string(calendar:now_to_datetime(os:timestamp())),
    FileStr2 = "logs/" ++ FileName,%% ++ "_" ++ util:term_to_string(calendar:now_to_datetime(os:timestamp())),
    case file:open(FileStr1, [write, append]) of
        {ok, F} -> ok;
        _ -> {ok, F} = file:open(FileStr2, [write, append])
    end,
    io:format(F, ulists:list_to_bin(Acc), []).

%% 变成驼峰命名
change_camel_case(Str) ->
    StrL = [binary_to_list(T)||T<-re:split(Str, "_")],
    F = fun(TmpStr) ->
        [Char|T] = TmpStr,
        [Char-32|T]
    end,
    util:link_list(lists:map(F, StrL), "").

get_process_state(IsKf, _StateName) ->
    StateName = erlang:list_to_atom(_StateName),
    if
        IsKf == 1 ->
            case sys:get_state({global, StateName}) of
                {error, Reason} -> {error, Reason};
                State ->
                    ?INFO("StateName:~p,~p~n",[StateName, State])
            end;
        true ->
            case sys:get_state(StateName) of
                {error, Reason} -> {error, Reason};
                State ->
                    ?INFO("StateName:~p,~p~n",[StateName, State])
            end
    end.

%% 保存字符串到数据库
save_str_to_db(StrBin) ->
    db:execute(io_lib:format("insert test_str(`str`) values('~s')", [StrBin])).

%% 物品名字替换
goods_file_rename() ->
    TypeList = data_goods_type:get_type(),
    F = fun(Type) ->
        SubTypeList = data_goods_type:get_subtype(Type),
        F2 = fun(SubType) ->
            GoodsIdList = data_goods_type:get_by_type(Type, SubType),
            F3 = fun(GoodsId) ->
                Name = data_goods_type:get_name(GoodsId),
                case Name == <<>> of
                    true -> ?MYLOG("filerename", "GoodsId:~p name is empty~n", [GoodsId]);
                    false ->
                        Dir = <<"G:/yy3d/yy3d_kf/trunk/code/u3d/Assets/LuaFramework/AssetBundleRes/icon/goodsIcon/"/utf8>>,
                        GoodsIdStr = lists:concat([GoodsId, ".png"]),
                        ?PRINT("GoodsIdStr:~p ~n", [GoodsIdStr]),
                        OldName = list_to_binary([Dir, list_to_binary(GoodsIdStr)]),
                        DestDir = <<"G:/qijie_goodsIcon/"/utf8>>,
                        NewName = list_to_binary([DestDir, Name, list_to_binary(".png")]),
                        case file:rename(OldName, NewName) of
                            ok -> ok;
                            {error, Reason} -> ?MYLOG("filerename", "GoodsId:~p Reason:~p ~n", [GoodsId, Reason])
                        end
                end
            end,
            lists:foreach(F3, GoodsIdList)
        end,
        lists:foreach(F2, SubTypeList)
    end,
    lists:foreach(F, TypeList).

test_goods_file_rename() ->
    Dir = <<"G:/yy3d/picturereplacetest/31.png"/utf8>>,
    filelib:is_file(Dir).

af_compile_code(Beam) ->
    % A = beam_lib:chunks(code:which(lib_timer), [abstract_code]),
    {ok,{_,[{abstract_code,{_,AC}}]}} = beam_lib:chunks(code:which(Beam),[abstract_code]),
    io:fwrite("~s~n", [erl_prettypr:format(erl_syntax:form_list(AC))]),
    ?MYLOG("compile1", "~p~n", [erl_syntax:form_list(AC)]),
    ?MYLOG("compile2", "~s~n", [erl_prettypr:format(erl_syntax:form_list(AC))]),
    ?INFO("~p ~n", [AC]).
    % {ok, FileF} = file:open("../logs/create_mod_no_" ++ util:term_to_string(calendar:now_to_datetime(os:timestamp())), [write]),
    % io:format(FileF, unicode:characters_to_list(Str), []),
    % file:close(FileF),

%% 运行单项测试并计时
test_sensitive_prof_timer(Label, F, Count) ->
    T0 = utime:longunixtime(),
    statistics(runtime),
    statistics(wall_clock),
    util:for(1, Count, F),
    {_, Time1} = statistics(runtime),     %% Time1：CPU在这期间执行的时间
    {_, Time2} = statistics(wall_clock),  %% Time2：这段代码执行的时间
    T1 = utime:longunixtime(),
    U1 = Time1 * 1000 / Count,                %% U1：每一条记录的CPU执行的时间，单位为微秒
    U2 = Time2 * 1000 / Count,                %% U2：每一条记录的代码执行的时间，单位为微秒
    ?PRINT("~p [total: ~p(~p)ms avg: ~.3f(~.3f)us]~n", [Label, Time1, Time2, U1, U2]),
    ?MYLOG("zhword_test", "~p [total: ~p(~p)ms avg: ~.3f(~.3f)us]~n", [Label, Time1, Time2, U1, U2]),
    [Label, Time1, Time2, T1-T0].