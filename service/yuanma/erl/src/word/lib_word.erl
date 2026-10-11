%% ---------------------------------------------------------------------------
%% @doc lib_word

%% @author ming_up@foxmail.com
%% @since  2016-07-26
%% @deprecated  过滤词库函数
%% ---------------------------------------------------------------------------
-module(lib_word).
-export([
    filter_text_gm/1        %% GM过滤
    , filter_text/2         %% 玩家过滤
    , filter_replace_text/2 %% 过滤
    , filter_name/1         %% 名字过滤
    , filter_string/2       %% 过滤字符串中的指定字符
    , check_keyword/1       %% 普通聊天和普通文字存库检查：是否存在敏感字
    , check_keyword/2       %% 普通聊天和普通文字存库检查：是否存在敏感字
    , check_keyword_ex/2    %% 普通聊天和普通文字存库检查：是否存在敏感字
    , check_keyword_name/1  %% 名字检查(玩家，帮派等改名)：是否存在敏感字
    , check_sql_keyword/1   %% 数据库敏感字符：是否存在敏感字
    , test1/0
]).

-export([
    check_use_where_filter_word/0,
    request_remote_filter_words/2,
    do_remote_words_list_result/2,
    do_remote_words_get_result/2,
    ts/1
]).

-include("common.hrl").
-include("predefine.hrl").
-include("record.hrl").

%% Gm不处理
filter_text_gm(Text) when is_bitstring(Text) -> Text;
filter_text_gm(Text) when is_list(Text) -> list_to_bitstring(Text).
    
%% 聊天检查：先替换检查，在处理:毛|**泽|东
filter_replace_text(<<>>, _Lv) -> <<>>;
filter_replace_text([], _Lv) -> <<>>;
filter_replace_text(Msg, Lv) ->
    Utf8Msg = filter_string(Msg),
    case mod_word:word_is_sensitive(Utf8Msg) of
        true ->
            lib_word:filter_text(Utf8Msg, Lv);
        false ->
            lib_word:filter_text(Msg, Lv)
    end.

%% 敏感词过滤:匹配敏感词库
%% @param Text list() | bitstring()
%% @return bitstring() 过滤后的文本
filter_text([], _Lv) -> <<>>;
filter_text(<<>>, _Lv) -> <<>>;
filter_text(Text, Lv) when is_bitstring(Text) ->
    filter_text(bitstring_to_list(Text), Lv);
filter_text(Text, Lv) when is_binary(Text) ->
    filter_text(util:make_sure_list(Text), Lv);
filter_text(Text, Lv) when is_list(Text) ->
    [Term] = io_lib:format("~ts", [Text]),
    mod_word:replace_sensitive_words(Term, Lv).

%% 名字过滤:匹配敏感词库
%% @param Text list() | bitstring()
%% @return bitstring() 过滤后的文本
filter_name([]) -> <<>>;
filter_name(<<>>) -> <<>>;
filter_name(Text) when is_bitstring(Text) ->
    filter_name(bitstring_to_list(Text));
filter_name(Text) when is_binary(Text) ->
    filter_name(util:make_sure_list(Text));
filter_name(Text) when is_list(Text) ->
    [Term] = io_lib:format("~ts", [Text]),
    mod_word:replace_sensitive_name(Term).

%% TODO:hjh 后续跟 check_keyword_name 配合, check_keyword
%% 敏感词检测(包含数据库敏感词检测)
%% @return true 存在关键词
%%         false 不存在关键词
%% @var Text：utf字符串
check_keyword(<<>>) -> false;
check_keyword([]) -> false;
check_keyword(Text) when is_binary(Text) ->
    Utf8Text = util:make_sure_list(Text),
    check_keyword(Utf8Text);
check_keyword(Text) when is_list(Text) ->
    % 敏感词检测:不包含数据库敏感词字符检测(用于聊天)
    % Utf8Msg = filter_string(Text),
    % mod_word:word_is_sensitive(Utf8Msg);
    mod_word:word_is_sensitive_name(Text);
check_keyword(_Text) -> false.

%% 敏感词+特殊字符检查检测(包含数据库敏感词检测)用于名字检查
%% @return true 存在关键词
%%         false 不存在关键词
%% @var Text：utf字符串
check_keyword_name(<<>>) -> false;
check_keyword_name([]) -> false;
check_keyword_name(Text) when is_binary(Text) ->
    Utf8Text = util:make_sure_list(Text),
    check_keyword_name(Utf8Text);
check_keyword_name(Text) when is_list(Text) ->
    Utf8Msg = filter_string(Text),
    mod_word:word_is_sensitive_name(Utf8Msg);
check_keyword_name(_Text) -> false.

%% 敏感词检测, 增加添加特定的额外关键词(包含数据库敏感词检测)
%% @return true  存在关键词
%%         false 不存在关键词
%% @var Text：字符串
check_keyword_ex(Text, ExtraWords) when is_binary(Text) ->
    check_keyword_ex(binary_to_list(Text), ExtraWords);
check_keyword_ex(Text, ExtraWords) when is_list(Text) ->
    case check_keyword(Text, ExtraWords) of
        true -> true;
        false -> mod_word:word_is_sensitive_name(Text)
    end;
check_keyword_ex(_Text, _ExtraWords) -> false.

check_keyword(_, []) -> false;
check_keyword(Text, [Word | Words]) ->
    case re:run(Text, Word, [{capture, none}]) of
        match -> true;
        nomatch -> check_keyword(Text, Words)
    end.

%% 数据库敏感词检测
%% @return true  存在关键词
%%         false 不存在关键词
%% @var Text：字符串
check_sql_keyword(Text) ->
    check_keyword(Text, ?ESC_ILLEGAL_SQL_CHARS).

%% 过滤常用字符
filter_string(Msg) ->
    case lib_vsn:is_cn() of
        false -> Msg;
        true ->
            RePattern = "[\t\s#|\*\@]+",
            %% RePattern = "[^\x{4e00}-\x{9fff}]+",
            re:replace(Msg, RePattern, "", [global, {return, list}, unicode])
    end.

%% 过滤掉字符串中的特殊字符
filter_string(String, CharList) ->
    case is_list(String) of
        true ->
            filter_string_helper(String, CharList, []);
        false when is_binary(String) ->
            ResultString = filter_string_helper(binary_to_list(String), CharList, []),
            list_to_binary(ResultString);
        false ->
            ?ERR("filter_string: Error string=[~w]", [String]),
            <<>>
    end.

filter_string_helper([], _CharList, ResultString) ->
    ResultString;
filter_string_helper([H | T], CharList, ResultString) ->
    case lists:member(H, CharList) of
        true -> filter_string_helper(T, CharList, ResultString);
        false -> filter_string_helper(T, CharList, ResultString ++ [H])
    end.

%% ================================= test =================================
test1() ->
    R0 = lib_word:check_keyword(<<"微信"/utf8>>),
    R1 = lib_word:check_keyword(<<"qQ">>),
    R2 = lib_word:check_keyword(<<" ">>),
    R3 = lib_word:check_keyword(<<"\"">>),
    R4 = lib_word:check_keyword("qQ"),
    R5 = lib_word:check_keyword("微信"),
    R6 = lib_word:check_keyword(" "),
    R7 = lib_word:check_keyword("\""),
    R8 = lib_word:check_keyword(<<"微信">>),
    [R0, R1, R2, R3, R4, R5, R6, R7, R8].


%% ========================================== 远端屏蔽词获取 ==========================================
%% 检查使用哪里的屏蔽词
check_use_where_filter_word() ->
    case util:get_filter_word_channel() of
        0 -> 0;
        FilterWordChannel ->
            case lib_vsn:is_cn() of
                false -> 0;
                true -> FilterWordChannel
            end
    end.

ts(OpType) ->
    request_remote_filter_words(OpType).

request_remote_filter_words(OpType) ->
    case util:get_filter_word_channel() of
        0 -> 0;
        FilterWordChannel ->
            case lib_vsn:is_cn() of
                false -> 0;
                true ->
                    request_remote_filter_words(FilterWordChannel, OpType)
            end
    end.

%% 请求远端屏蔽词
request_remote_filter_words(PjDir, OpType) ->
    case lib_vsn:is_cn() of
        false -> skip; %% 外服不走远端屏蔽词
        true ->
            NowTime = utime:longunixtime(),
            HeaderURL = "http://userpic.suyougame.com/config_words/",
            FileName = case OpType of
                           ?WORD_GET_ALL ->
                               ets:delete_all_objects(game_sensitive_words),
                               "/config_words_all.txt?t=";
                           ?WORD_DELETE ->
                               "/config_words_del.txt?t=";
                           _ -> %% 默认更新
                               "/config_words_add.txt?t="
                       end,
            URL = lists:concat([HeaderURL, util:make_sure_list(PjDir), FileName, NowTime]),
            mod_http_server:do_http_request(?HTTP_REQ_WORDS_LIST, URL, get, "", [OpType])
    end.

%% 返还的远程列表数据处理
%% 对列表进行分批处理：确保顺序，也确保不会一次大批量处理屏蔽词添加
do_remote_words_list_result(ReqData, Result) ->
    {_, _, Files} = Result,
    [OpType | _] = ReqData,
    URLs = [util:make_sure_list(FURL) || FURL <- re:split(Files, "\r\n"), FURL =/= <<>>],
    URLsLen = length(URLs),
    NewURLs =
    if
        URLsLen < 2 ->
            ?ERR("URLsLen Error URLs:~p~n", [URLs]),
            ?PRINT("URLsLen Error URLs:~p~n", [URLs]),
            URLs;
        true ->
            [StrWordNum|URLs1] = URLs,
            case catch list_to_integer(StrWordNum) of
                WordNum when is_integer(WordNum) ->
                    NewWordNum = calc_new_word_num(OpType, WordNum),
                    % ets:insert(?SERVER_STATUS, #server_status{name = filter_word_num, value = NewWordNum}),
                    NowTime = utime:unixtime(),
                    lib_server_kv:update_server_kv_to_ets(?SKV_FILTER_WORD_NUM, NewWordNum, NowTime),
                    if
                        OpType =/= ?WORD_GET_ALL -> skip;
                        true -> 
                            % ets:insert(?SERVER_STATUS, #server_status{name = filter_load_word_num, value = 0})
                            lib_server_kv:update_server_kv_to_ets(?SKV_FILTER_LOAD_WORD_NUM, 0, NowTime)
                    end,
                    URLs1;
                Error ->
                    ?ERR("StrWordNum, OpType, Error:~p~n", [[StrWordNum, OpType, Error, URLs]]),
                    ?PRINT("StrWordNum, OpType, Error:~p~n", [[StrWordNum, OpType, Error, URLs]]),
                    URLs
            end
    end,
    mod_http_server:do_http_request_mutiple(?HTTP_REQ_WORDS_GET, NewURLs, get, "", [OpType]),
    ok.

%% 计算屏蔽词个数
calc_new_word_num(?WORD_UPDATE, AddWordNum) -> util:get_filter_word() + AddWordNum;
calc_new_word_num(?WORD_DELETE, DelWordNum) -> max(0, util:get_filter_word() - DelWordNum);
calc_new_word_num(_, WordNum) -> WordNum.

%% 请求单文件的屏蔽返回，添加到缓存，再请求下一个屏蔽词文件内容
do_remote_words_get_result(ReqData, Result) ->
    {_, _, Res} = Result,
    [OpType, NextURLs | _] = ReqData,
    if
        OpType == ?WORD_GET_ALL orelse OpType == ?WORD_UPDATE -> %% 新增|添加
            mod_word:add_remote_filter_words(Res);
        true -> %% 删除
            mod_word:del_remote_filter_words(Res)
    end,
    case NextURLs of
        [] when OpType == ?WORD_GET_ALL ->
            erlang:garbage_collect(), %% 启动请求后需要回收一下
            ok;
        [] ->
            ok;
        _ ->
            mod_http_server:do_http_request_mutiple(?HTTP_REQ_WORDS_GET, NextURLs, get, "", [OpType])
    end,
    ok.