%% ---------------------------------------------------------------------------
%% @doc 配置文件语法检查
%% @author WJQ
%% @since  2020-9-7
%% @deprecated 使用erl_lint模块检查配置编译期错误，返回错误详细信息
%% ---------------------------------------------------------------------------
-module(data_file_parse).
-include("common.hrl").

-export([parse_test/0, bracket_pair_test/0]).
-export([parsed_data_file/1, validate_parsed_source_file/2]).

% 注意：路径目录请使用正斜杠‘ / ’, Linux环境下双反斜杠‘ \\ ’不会识别为目录
-define(ROOT_PATH, "../src/data/create/").                                  %% data文件根目录
-define(INCLUDE_PATH, ["../include/"]).                                     %% 头文件目录列表
-define(FILE_BASE_NAME(FILE), list_to_binary(filename:basename(File))).     %% 文件名

%% ---------------------------------------------------------------------------
%% 返回json格式
%%{
%%    "parse_result":true | false,
%%    "file":"文件名称",
%%    "errors":{
%%        "{行号,列号}":{
%%            "normal_msg":"原生错误信息",
%%            "game_msg":"游戏错误信息"
%%        }
%%    },
%%    "warnings":{
%%        "{行号,列号}":{
%%%           "normal_msg":"原生警告信息",
%%            "game_msg":"游戏警告信息"
%%        }
%%    },
%%}
%% ---------------------------------------------------------------------------
%% FileBaseName :: 文件名称，如data_ai.erl
parsed_data_file(FileBaseName) ->
    File = filename:join(?ROOT_PATH, FileBaseName),
    validate_parsed_source_file(File, ?INCLUDE_PATH).

validate_parsed_source_file(File, IncludePath) ->
    Data = case epp_parse_file(File, IncludePath) of
        {ok, FileSyntaxTree} ->
            lint(FileSyntaxTree, File);
        _E ->
            [
                {<<"file">>, ?FILE_BASE_NAME(File)},
                {<<"parse_result">>, list_to_binary(util:term_to_string(_E))}
            ]
    end,
    iolist_to_binary(mochijson2:encode(Data)).

%% 生成语法树
epp_parse_file(File, IncludePath) ->
    epp_parse_file(File, IncludePath, []).

epp_parse_file(File, IncludePath, Defines) ->
    case file:open(File, [read]) of
        {ok, FIO} ->
            Ret = do_epp_parse_file(File, FIO, IncludePath, Defines),
            file:close(FIO),
            Ret;
        _Err ->
            {error, file_could_not_opened}
    end.

do_epp_parse_file(File, FIO, IncludePath, Defines) ->
    case epp:open(as_string(File), FIO, {1,1}, IncludePath, Defines) of
        {ok, Epp} -> {ok, epp:parse_file(Epp)};
        {error, _Err} -> {error, _Err}
    end.

as_string(Text) when is_binary(Text) ->
    binary_to_list(Text);
as_string(Text) ->
    Text.

%% 分析语法树
lint(FileSyntaxTree, File) ->
    LintResult = erl_lint:module(FileSyntaxTree, File,[ {strong_validation} ]),
    case LintResult of
        % nothing wrong
        {ok, []} ->
            [
                {<<"file">>, ?FILE_BASE_NAME(File)},
                {<<"parse_result">>, true}
            ];
        % just warnings
        {ok, [Warnings]} ->
            [
                {<<"file">>, ?FILE_BASE_NAME(File)},
                {<<"parse_result">>, true},
                {<<"warnings">>, extract_errors_or_warnings(Warnings)}
            ];
        % errors, no warnings
        {error, [Errors], []} ->
            [
                {<<"file">>, ?FILE_BASE_NAME(File)},
                {<<"parse_result">>, true},
                {<<"errors">>, extract_errors_or_warnings(Errors)}
            ];
        % errors and warnings
        {error, [Errors], [Warnings]} ->
            [
                {<<"file">>, ?FILE_BASE_NAME(File)},
                {<<"parse_result">>, true},
                {<<"errors">>, extract_errors_or_warnings(Errors)},
                {<<"warnings">>, extract_errors_or_warnings(Warnings)}
            ];
        {error, [], [Warnings]} ->
            [
                {<<"file">>, ?FILE_BASE_NAME(File)},
                {<<"parse_result">>, true},
                {<<"warnings">>, extract_errors_or_warnings(Warnings)}
            ];
        _Any ->
            [
                {<<"file">>, ?FILE_BASE_NAME(File)},
                {<<"parse_result">>, false}
            ]
    end.

%% 摘录错误/警告信息
extract_errors_or_warnings({_File, Errors}) ->
    do_extract_errors_or_warnings(Errors, []);
extract_errors_or_warnings(Errors) ->
    list_to_binary(util:term_to_string(Errors)).

do_extract_errors_or_warnings([], Result) -> Result;
do_extract_errors_or_warnings([{{_Line, _Column}, erl_lint, export_all}|T], Result) ->
    % 忽略函数全导出警告
    do_extract_errors_or_warnings(T, Result);
do_extract_errors_or_warnings([{{Line, Column}, Module, Descriptor}|T], Result) ->
    NormalMsg = Module:format_error(Descriptor),
    GameMsg = format_error(Descriptor),
    Pos = util:term_to_string({Line, Column}),
    NewResult = [{list_to_binary(Pos), [{<<"normal_msg">>, list_to_binary(NormalMsg)}, {<<"game_msg">>, GameMsg}]}|Result],
    do_extract_errors_or_warnings(T, NewResult);
do_extract_errors_or_warnings([_H|T], Result) ->
    ?ERR("unknow error:~p~n", [_H]),
    do_extract_errors_or_warnings(T, Result).

%% 格式化错误/警告信息
format_error(["syntax error before: ", _Char]) ->
    <<"配置填写格式有问题"/utf8>>;
format_error({undefined_field, _RecordName, _Field}) ->
    <<"头文件没同步，请通知服务端技术进行处理"/utf8>>;
format_error({illegal, integer}) ->
    <<"数字解析错误"/utf8>>;
format_error({illegal, character}) ->
    <<"字符解析错误"/utf8>>;
format_error({undefined_record, _RecordName}) ->
    <<"头文件没同步，请通知服务端技术进行处理"/utf8>>;
format_error({include, file, _IncludeFile}) ->
    <<"头文件没提交，请通知服务端技术进行处理"/utf8>>;
format_error({unbound_var, _VarName}) ->
    <<"生成格式有问题，请通知服务端技术进行处理"/utf8>>;
format_error(_ErrorDescriptor) ->
    ?INFO("~p~n", [_ErrorDescriptor]),
    <<"未知类型，请联系服务端技术获取帮助"/utf8>>.

%% =============================================== bracket pair function ==============================================
-define(YELLOW, yellow).
-define(PURPLE, purple).
-define(BLUE,   blue).
-define(RED,    red).
-define(FIRST_COLOR, ?YELLOW).

%% 创建新栈
new_stack() -> [].

%% 压栈
push_stack(Term, Stack) -> [Term|Stack].

%% 弹栈
pop_stack([]) -> {null, []};
pop_stack([Top|Tail]) -> {Top, Tail}.

%% 是否为空栈
is_empty_stack([]) -> true;
is_empty_stack(_)  -> false.

%% 括号匹配
%% @return {匹配结果, 染色结果}
%% 匹配结果 :: true | false
%% 染色结果 :: [{Count :: integer(), Color :: ?YELLOW | ?PURPLE | ?BLUE, integer()},...]
bracket_pair([]) -> {true, []};
bracket_pair(Str) -> bracket_pair(Str, new_stack(), _Result=[], _Count=1, _NextColor=?YELLOW).

bracket_pair([], Stack, Result, _Count, _NextColor) ->
    LastResult = lists:reverse(Result),
    AllPair = all_pair(Stack, LastResult),
    {AllPair, LastResult};
bracket_pair([NowBracket|T], Stack, Result, Count, NextColor) ->
    LeftBracket = is_left_bracket(NowBracket),
    RightBracket = is_right_bracket(NowBracket),
    IsEmptyStack = is_empty_stack(Stack),
    if
        LeftBracket -> % 当前字符为左括号
            NewStack = push_stack({NextColor, NowBracket}, Stack),
            NewResult = [{Count, NextColor, NowBracket}|Result],
            NewCount = Count + 1,
            NewNextColor = next_color(NextColor),
            bracket_pair(T, NewStack, NewResult, NewCount, NewNextColor);
        RightBracket andalso IsEmptyStack -> % 当前字符为右括号，且栈为空
            NewResult = [{Count, ?RED, NowBracket}|Result],
            NewCount = Count + 1,
            bracket_pair(T, Stack, NewResult, NewCount, NextColor);
        RightBracket -> % 当前字符为右括号，且栈非空
            {{Color, TopBracket}, NewStack} = pop_stack(Stack),
            case is_pair(TopBracket, NowBracket) of
                true ->
                    NewResult = [{Count, Color, NowBracket}|Result],
                    NewCount = Count + 1,
                    bracket_pair(T, NewStack, NewResult, NewCount, Color);
                false ->
                    NewResult = [{Count, ?RED, NowBracket}|Result],
                    NewCount = Count + 1,
                    bracket_pair(T, Stack, NewResult, NewCount, Color)
            end;
        true -> % 当前字符非括号
            NewCount = Count + 1,
            NewResult = [{Count, none, NowBracket}|Result],
            bracket_pair(T, Stack, NewResult, NewCount, NextColor)
    end.

is_left_bracket($() -> true;
is_left_bracket(${) -> true;
is_left_bracket($[) -> true;
is_left_bracket(_)  -> false.

is_right_bracket($)) -> true;
is_right_bracket($}) -> true;
is_right_bracket($]) -> true;
is_right_bracket(_)  -> false.

is_pair($(, $)) -> true;
is_pair(${, $}) -> true;
is_pair($[, $]) -> true;
is_pair(_A, _B) -> false.

next_color(?YELLOW) -> ?PURPLE;
next_color(?PURPLE) -> ?BLUE;
next_color(?BLUE)   -> ?YELLOW.

all_pair(Stack, ResultList) ->
    IsEmptyStack = is_empty_stack(Stack),
    CheckFun = fun({_C, Color, _Bracket}) -> Color =:= ?RED end,
    HadRedBracket = lists:any(CheckFun, ResultList),
    IsEmptyStack andalso not HadRedBracket.

%% ================================================== test function ==================================================
-define(TEST_FILE, "data_custom_act.erl").                          %% 测试配置文件
-define(TEST_STR, "[{1,0,1}],{{1,0,[{12,3,},{1,0,1},{1,1,1]}]").    %% 括号匹配测试字符串

%% log目录下生成测试json文件
parse_test() ->
    OutPath = filename:join(config:get_log_path(), "parse_test.json"),
    Json = parsed_data_file(?TEST_FILE),
    file:write_file(OutPath, [binary_to_list(Json)]).

%% 括号匹配测试
bracket_pair_test() ->
    {_AllPair, Result} = bracket_pair(?TEST_STR),
    Str = format(Result),
    ?PRINT(Str, []),
    ok.

format(Result) -> format(Result, "").

format([], AccStr) -> AccStr ++ "\e[m";
format([{_Count, Color, ASCII}|T], AccStr) ->
    ColorStr = case Color of
        ?YELLOW -> "\e[1;33m";
        ?PURPLE -> "\e[1;35m";
        ?BLUE -> "\e[1;34m";
        ?RED -> "\e[41m";
        _ -> "\e[m"
    end,
    NewAccStr = AccStr ++ lists:concat([ColorStr, [ASCII], "\e[m"]),
    format(T, NewAccStr).
