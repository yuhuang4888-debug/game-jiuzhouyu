%%%------------------------------------
%%% @Module  : mod_word
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.02.08
%%% @Description: 关键字检查
%%%------------------------------------
-module(mod_word).

-include("def_fun.hrl").
-include("common.hrl").
-include("record.hrl").

-export([
    init/0,
    update_all/0,
    update_local_filter_word/0,
    php_update_all/0,
    php_update_one/1,
    php_notify_update_words/1,
    import_words_by_id/1,
    word_is_sensitive/1,
    word_is_sensitive_name/1,
    replace_sensitive_words/2,
    replace_sensitive_name/1,
    add_remote_filter_words/1,
    del_remote_filter_words/1
]).

-export([
    test/0
    , get_w/1
    , get_n/1
    , output_word_len/0
    , test_sensitive_prof/1
    , test_sensitive_prof/2
    ]).

-define(ETS_SENSITIVE_WORDS, game_sensitive_words).
-define(ETS_SENSITIVE_NAME, game_sensitive_words_name).

-define(GOODS_TMP_MSG, "#gs#").

%% TODO:后续全部改成utf编码

%% 屏蔽词规则：名称和文本分开处理
%% 名称：按以前的逻辑
%%      例如："过滤词", 以"过"为主键保存过滤词列表, "过"=>["过滤词", ...]; "lie", 以"l"为主键保存过滤词列表, "l"=>["lie", ...]
%% 其他文本：以逻辑单词为主键
%%      例如："过滤词", 以"过"为主键保存过滤词列表, "过"=>["过滤词", ...]; "lie", 以"lie"为主键保存过滤词列表, "lie"=>["lie", ...]
%%
%% API Functions
%%
%% php通知更新
php_update_all() ->
    mod_word:update_all(),
    ok.

php_update_one(Id) ->
    mod_word:import_words_by_id(Id),
    ok.

%% 通知添加新的屏蔽词
php_notify_update_words(OpType) ->
    case lib_word:check_use_where_filter_word() of
        0 -> %% local
            words_init();
        FilterWordChannel ->
            lib_word:request_remote_filter_words(FilterWordChannel, OpType)
    end,
    ok.

%% 更新所有词库
update_all() ->
    DbTerms = get_word_for_db(),
    case lib_word:check_use_where_filter_word() of
        0 -> %% local
            words_init(DbTerms);
        FilterWordChannel -> %% 远端屏蔽词
            lib_word:request_remote_filter_words(FilterWordChannel, 1)
    end,
    name_init(DbTerms),
    ok.

%% 更新本地屏蔽词
update_local_filter_word()->
    words_init(),
    ok.

%% 节点启动初始化屏蔽词
init() ->
    ets:new(?ETS_SENSITIVE_WORDS, [named_table, public, set]),
    ets:new(?ETS_SENSITIVE_NAME, [named_table, public, set]),
    update_all(),
    ok.

words_init() ->
    ets:delete_all_objects(?ETS_SENSITIVE_WORDS),
    import_words(?ETS_SENSITIVE_WORDS, 0),
    ok.

words_init(DbTerms) ->
    ets:delete_all_objects(?ETS_SENSITIVE_WORDS),
    import_words_with_extra(?ETS_SENSITIVE_WORDS, DbTerms),
    ok.

name_init(DbTerms) ->
    ets:delete_all_objects(?ETS_SENSITIVE_NAME),
    import_words_name(?ETS_SENSITIVE_NAME, DbTerms),
    ok.

import_words_by_id(Id) ->
    Data = db:get_one(io_lib:format(<<"select `word` from `config_word` where id = ~p limit 1">> , [Id])),
    X = io_lib:format("~ts", [Data]),
    add_word_to_ets_words(X, ?ETS_SENSITIVE_WORDS),
    add_word_to_ets_name(X, ?ETS_SENSITIVE_NAME),
    ok.

get_word_for_db() ->
    Data = db:get_all(<<"select `word` from `config_word`">>),
    case lib_vsn:is_hw() of
        true ->
            {_, RePattern} = re:compile(" "),
            Convert = fun([X]) -> io_lib:format("~ts", [list_to_binary(re:replace(X, RePattern, "", [global, {return, list}]))]) end;
        _ ->
            Convert = fun([X]) -> io_lib:format("~ts", [X]) end
    end,
    lists:map(Convert, Data).

%% 删除ETS屏蔽词
delete_word_to_ets(Word, EtsName) ->
    case unicode:characters_to_list(Word, unicode) of
        [] -> ignor;
        UniString ->
            [HeadChar | _Left] = UniString,
            case ets:lookup(EtsName, HeadChar) of
                [] -> ignor;
                [{_H, OldList}] ->
                    case lists:member(UniString, OldList) of
                        false -> ignor;
                        true ->
                            case lists:delete(UniString, OldList) of
                                [] ->
                                    ets:delete(EtsName, HeadChar);
                                NewList ->
                                    ets:insert(EtsName, {HeadChar, NewList})
                            end
                    end
            end
    end.

%% =======================================================
%%  名称相关逻辑
%% =======================================================

%% 加载过滤
%% @param EtsName  Ets名
%% @param TalkPass 0 敏感字库,需要加载数据库屏蔽字段
%%                 1 放行字库等级段1, 不要加载数据库屏蔽字段
%% @param Terms2  数据库屏蔽字段
%% 加载名称相关过滤
import_words_name(EtsName, Terms2)->
    Terms = data_filter:name(),
    lists:foreach(fun(X)-> add_word_to_ets_name(X, EtsName) end, Terms),
    lists:foreach(fun(X)-> add_word_to_ets_name(X, EtsName) end, Terms2),
    ok.

add_word_to_ets_name(Word,EtsName) ->
    case unicode:characters_to_list(Word,unicode) of
        [] -> ignor;
        UniString0 ->
            UniString = string:to_lower(UniString0),
            [HeadChar|_Left] = UniString,
            case ets:lookup(EtsName, HeadChar) of
                []-> ets:insert(EtsName, {HeadChar,[UniString]});
                [{_H,OldList}]->
                    case lists:member(UniString,OldList) of
                        false-> ets:insert(EtsName,{HeadChar,[UniString|OldList]});
                        true -> ignor
                    end
            end
    end.

%% 添加远端屏蔽词
add_remote_filter_words(Words) ->
    Terms = re:split(Words, "\r\n"),
    F = fun(X, AddCount) ->
            case add_word_to_ets_words(X, ?ETS_SENSITIVE_WORDS) of
                ignor -> AddCount;
                _ -> AddCount + 1
            end
        end,
    RealAddCount = lists:foldl(F, 0, Terms),
    NewLoadWordNum = util:get_filter_load_word() + RealAddCount,
    lib_server_kv:update_server_kv_to_ets(?SKV_FILTER_LOAD_WORD_NUM, NewLoadWordNum, utime:unixtime()),
    ok.

%% 删除屏蔽词
del_remote_filter_words(Words) ->
    Terms = re:split(Words, "\r\n"),
    F = fun(X, AddCount) ->
        case delete_word_to_ets(X, ?ETS_SENSITIVE_WORDS) of
            ignor -> AddCount;
            _ -> AddCount + 1
        end
        end,
    RealDelCount = lists:foldl(F, 0, Terms),
    NewLoadWordNum = max(0, util:get_filter_load_word()-RealDelCount),
    lib_server_kv:update_server_kv_to_ets(?SKV_FILTER_LOAD_WORD_NUM, NewLoadWordNum, utime:unixtime()),
    ok.

%% 名字敏感字检查
word_is_sensitive_name([])->
    false;
word_is_sensitive_name(Utf8String) when is_list(Utf8String)->
    Utf8Binary = ulists:list_to_bin(Utf8String),
    word_is_sensitive_name(Utf8Binary);
word_is_sensitive_name(Utf8Binary) when is_binary(Utf8Binary)->
    case unicode:characters_to_list(Utf8Binary,unicode) of
        {incomplete, Encoded, BinData} -> UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        {error, Encoded, BinData} -> UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        UniString -> ok
    end,
    LowerUniString = string:to_lower(UniString),
    % 策划需求:名字敏感词要包括文本敏感词
    case word_is_sensitive_kernel_name(LowerUniString, ?ETS_SENSITIVE_NAME) of
        true -> true;
        false -> word_is_sensitive_help(LowerUniString)
    end.

%% 敏感词
word_is_sensitive_kernel_name([], _EtsName)-> false;
word_is_sensitive_kernel_name(UniString, EtsName)->
    [HeadChar|TailString] = UniString,
    UniStrLen = length(UniString),
    WordList = get_key_char_wordlist(HeadChar,EtsName),
    Match = fun(Word)->
            WordLen = length(Word),
            if WordLen> UniStrLen-> false; %%小于敏感词长度直接false
                WordLen =:= UniStrLen-> UniString =:= Word; %%等于直接比较
                true-> %%大于取词比较
                    HeadStr = lists:sublist(UniString,WordLen),
                    HeadStr =:= Word
            end
    end,
    case lists:any(Match, WordList) of
        true -> true;
        false-> word_is_sensitive_kernel_name(TailString,EtsName)
    end.

%% 替换敏感名字
replace_sensitive_name(Utf8String) when is_binary(Utf8String)->
    UniString = case unicode:characters_to_list(Utf8String,unicode) of
        {error, _, _RestData} -> [];
        {incomplete, _, _} -> [];
        Data -> Data
    end,
    ReplacedString = replace_sensitive_kernel_name(UniString,0,1,[],?ETS_SENSITIVE_NAME),
    unicode:characters_to_binary(ReplacedString, utf8);
replace_sensitive_name(InputString)when is_list(InputString)->
    Utf8Binary = ulists:list_to_bin(InputString),
    replace_sensitive_name(Utf8Binary);
replace_sensitive_name(InputString)->
    InputString.

%% @param TalkOrName 0表示聊天,聊天需要按等级放行屏蔽词; 1表示名字
replace_sensitive_kernel_name([], _Lv, _TalkOrName, LastRepaced, _EtsName) -> LastRepaced;
replace_sensitive_kernel_name(InputString, Lv, TalkOrName, LastReplaced, EtsName) ->
    % 不检查放行
    % [HeadChar|_TailString] = InputString,
    % %%WordList = get_key_char_wordlist(HeadChar,EtsName),
    % InputStrLen = length(InputString),
    % if
    %     TalkOrName=:=0 ->
    %         %% 检测是否可放行
    %         WordPassList = get_key_char_wordlist(HeadChar, EtsName),
    %         MatchPass = fun(WordPass,Last)->
    %             match_of_replace_sensitive_kernel(WordPass,Last,InputString,InputStrLen)
    %         end,
    %         case lists:foldl(MatchPass, 0 ,WordPassList) of
    %             0 -> %% 不可放行直接走检测屏蔽字
    %                 private_replace_sensitive_kernel(InputString,Lv,TalkOrName,LastReplaced,EtsName);
    %             %% 可放行
    %             SensWordPassLen ->
    %                 SubString   = lists:sublist(InputString, 1, SensWordPassLen),
    %                 LeftString  = lists:sublist(InputString, SensWordPassLen + 1, InputStrLen - SensWordPassLen),
    %                 NewReplaced = LastReplaced ++ SubString,
    %                 replace_sensitive_kernel_name(LeftString,Lv,TalkOrName,NewReplaced,EtsName)
    %         end;
    %     true ->
    %         private_replace_sensitive_kernel(InputString,Lv,TalkOrName,LastReplaced,EtsName)
    % end.
    private_replace_sensitive_kernel_name(InputString,Lv,TalkOrName,LastReplaced,EtsName).

match_of_replace_sensitive_kernel_name(Word,Last,InputString,InputStrLen)->
    case Last of
        0 ->
            WordLen = length(Word),
            if
                WordLen > InputStrLen -> 0;
                WordLen =:= InputStrLen andalso InputString =:= Word -> WordLen;
                WordLen =:= InputStrLen -> 0;
                true->
                    HeadStr = lists:sublist(InputString,length(Word)),
                    if
                        (HeadStr =:= Word)-> WordLen;
                        true-> 0
                    end
            end;
        _ -> Last
    end.

%% 检测屏蔽字，并替换
private_replace_sensitive_kernel_name(InputString,Lv,TalkOrName,LastReplaced,EtsName)->
    [HeadChar|TailString] = InputString,
    WordList = get_key_char_wordlist(HeadChar,EtsName),
    InputStrLen = length(InputString),
    Match = fun(Word,Last)->
        match_of_replace_sensitive_kernel_name(Word,Last,InputString,InputStrLen)
    end,
    case lists:foldl(Match,0 ,WordList) of
        0->
            NewReplaced = LastReplaced ++ [HeadChar],
            replace_sensitive_kernel_name(TailString,Lv,TalkOrName,NewReplaced,EtsName);
        SensWordLen->
            LeftString = lists:sublist(InputString, SensWordLen + 1, InputStrLen - SensWordLen ),
            NewReplaced = LastReplaced ++ make_sensitive_show_string(SensWordLen),
            replace_sensitive_kernel_name(LeftString,Lv,TalkOrName,NewReplaced,EtsName)
    end.

%% =======================================================
%%  通用文本相关逻辑
%% =======================================================

%% 加载过滤
%% @param EtsName  Ets名
%% @param TalkPass 0 敏感字库,需要使用数据库屏蔽字段
%%                 1 放行字库等级段1, 无需使用数据库屏蔽字段
%% @param Terms2  数据库屏蔽字段
import_words(EtsName, TalkPass) ->
    case TalkPass of
        0 ->
            lists:foreach(fun(X)-> add_word_to_ets_words(X, EtsName) end, get_word_for_db()),
            Terms = data_filter:get();
        1 ->
            Terms = data_filter:get()
    end,
    lists:foreach(fun(X)-> add_word_to_ets_words(X, EtsName) end, Terms),
    ok.

import_words_with_extra(EtsName, AddTerms) ->
    lists:foreach(fun(X)-> add_word_to_ets_words(X, EtsName) end, AddTerms),
    Terms = data_filter:get(),
    lists:foreach(fun(X)-> add_word_to_ets_words(X, EtsName) end, Terms),
    ok.

add_word_to_ets_words(Word,EtsName) ->
    case lib_vsn:is_word_prehandle() of
        true -> add_word_to_ets_words_on_prehandle(Word, EtsName);
        false -> add_word_to_ets_words_on_normal(Word,EtsName)
    end.

add_word_to_ets_words_on_normal(Word,EtsName) ->
    case unicode:characters_to_list(Word,unicode) of
        {incomplete, Encoded, BinData} ->
            ?MYLOG("word", "Word:~p Encoded:~p BinData:~p ~n", [Word, Encoded, BinData]),
            UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        {error, Encoded, BinData} ->
            ?MYLOG("word", "Word:~p Encoded:~p BinData:~p ~n", [Word, Encoded, BinData]),
            UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        UniString -> ok
    end,
    case UniString == [] of
        true -> ignor;
        false ->
            [HeadChar|_Left] = UniString,
            case ets:lookup(EtsName, HeadChar) of
                []-> ets:insert(EtsName, {HeadChar,[UniString]});
                [{_H,OldList}]->
                    case lists:member(UniString,OldList) of
                        false-> ets:insert(EtsName,{HeadChar,[UniString|OldList]});
                        true -> ignor
                    end
            end
    end.

add_word_to_ets_words_on_prehandle(Word, EtsName) ->
    case unicode:characters_to_list(Word,unicode) of
        {incomplete, Encoded, BinData} ->
            ?MYLOG("word", "Word:~p Encoded:~p BinData:~p ~n", [Word, Encoded, BinData]),
            UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        {error, Encoded, BinData} ->
            ?MYLOG("word", "Word:~p Encoded:~p BinData:~p ~n", [Word, Encoded, BinData]),
            UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        UniString -> ok
    end,
    case prehandle_filter_words(UniString) of
        [] -> ignor;
        UniStringList ->
            UniStringBin = pack_filter_words(UniStringList),
            [Head|_Left] = UniStringList,
            case ets:lookup(EtsName, Head) of
                []-> ets:insert(EtsName, {Head,[UniStringBin]});
                [{_H,OldList}]->
                    case lists:member(UniStringBin,OldList) of
                        false-> ets:insert(EtsName,{Head,[UniStringBin|OldList]});
                        true -> ignor
                    end
            end
    end.

%% 通用文字敏感字检查
word_is_sensitive([]) -> false;
word_is_sensitive(Utf8String) when is_list(Utf8String)->
    Utf8Binary = ulists:list_to_bin(Utf8String),
    word_is_sensitive(Utf8Binary);
word_is_sensitive(Utf8Binary) when is_binary(Utf8Binary)->
    case unicode:characters_to_list(Utf8Binary,unicode) of
        {incomplete, Encoded, BinData} -> UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        {error, Encoded, BinData} -> UniString = binary_to_list(list_to_binary([Encoded, BinData]));
        UniString -> ok
    end,
    word_is_sensitive_help(UniString).

%% @param UniString unicode列表
word_is_sensitive_help(UniString) ->
    case lib_vsn:is_word_prehandle() of
        true -> word_is_sensitive_kernel_words_on_prehandle(UniString, ?ETS_SENSITIVE_WORDS);
        false -> word_is_sensitive_kernel_words_on_normal(UniString, ?ETS_SENSITIVE_WORDS)
    end.

word_is_sensitive_kernel_words_on_prehandle(UniString, EtsName)->
    UniStringList = prehandle_filter_words(UniString),
    UniStringBin = pack_filter_words(UniStringList),
    word_is_sensitive_kernel_words_on_prehandle_help(UniStringBin, EtsName).

word_is_sensitive_kernel_words_on_prehandle_help(UniStringBin, EtsName)->
    case unpack_filter_words_head(UniStringBin) of
        {[], _} -> false;
        {Head, LeftUniStringBin} ->
            UniStrLen = byte_size(UniStringBin),
            WordList = get_key_char_wordlist(Head,EtsName),
            Match = fun(Word)->
                WordLen = byte_size(Word),
                if
                    WordLen > UniStrLen-> false; %%小于敏感词长度直接false
                    true ->
                        <<W2:WordLen/binary,_/binary>> = UniStringBin,
                        Word == W2
                end
            end,
            case lists:any(Match, WordList) of
                true -> true;
                false-> word_is_sensitive_kernel_words_on_prehandle_help(LeftUniStringBin, EtsName)
            end
    end.

word_is_sensitive_kernel_words_on_normal([], _EtsName)-> false;
word_is_sensitive_kernel_words_on_normal(UniString, EtsName)->
    [HeadChar|TailString] = UniString,
    UniStrLen = length(UniString),
    WordList = get_key_char_wordlist(HeadChar,EtsName),
    Match = fun(Word)->
        WordLen = length(Word),
        if
            WordLen > UniStrLen-> false; %%小于敏感词长度直接false
            WordLen =:= UniStrLen-> UniString =:= Word; %%等于直接比较
            true-> %%大于取词比较
                HeadStr = lists:sublist(UniString,WordLen),
                HeadStr =:= Word
        end
    end,
    case lists:any(Match, WordList) of
        true -> true;
        false-> word_is_sensitive_kernel_words_on_normal(TailString,EtsName)
    end.

%% 替换敏感通用文字
replace_sensitive_words(Utf8String, Lv) when is_binary(Utf8String)->
    case lib_vsn:is_word_prehandle() of
        true -> replace_sensitive_words_on_prehandle(Utf8String, Lv);
        false -> replace_sensitive_words_on_normal(Utf8String, Lv)
    end;
replace_sensitive_words(InputString,Lv)when is_list(InputString)->
    Utf8Binary = ulists:list_to_bin(InputString),
    replace_sensitive_words(Utf8Binary, Lv);
replace_sensitive_words(InputString, _Lv)->
    InputString.

replace_sensitive_words_on_prehandle(Utf8String, Lv) ->
    UniString = case unicode:characters_to_list(Utf8String,unicode) of
        {error, _, _RestData} -> [];
        {incomplete, _, _} -> [];
        Data -> Data
    end,
    {UniStringList, SplitCharList} = pre_handle_filter_words_with_split_char(UniString),
    UniStringBin = pack_filter_words(UniStringList),
    ReplacedStringList = replace_sensitive_kernel_words(UniStringBin,Lv,0,[],?ETS_SENSITIVE_WORDS),
    %% 将分隔符放回原位置
    ReplacedString = post_handle_filter_words_with_split_char(SplitCharList, ReplacedStringList),
    unicode:characters_to_binary(ReplacedString, utf8).

replace_sensitive_words_on_normal(Utf8String, Lv) ->
    case lib_vsn:is_ignore_goods() of
        true ->
            case catch lib_chat:get_ignore_msg(Utf8String) of
                {match, GoodsMsgs, MP} ->
                    IsReplace = true,
                    NewUtf8String = re:replace(Utf8String,MP, ?GOODS_TMP_MSG, [global, {return, binary}]);
                _ ->
                    NewUtf8String = Utf8String, GoodsMsgs = [],
                    IsReplace = false
            end;
        _ ->
            IsReplace = false, GoodsMsgs = [],
            NewUtf8String = Utf8String
    end,
    NewUniString = case unicode:characters_to_list(NewUtf8String,unicode) of
        {error, _, _RestData} -> [];
        {incomplete, _, _} -> [];
        Data -> Data
    end,
    % 使用名字屏蔽词
    ReplacedStringTmp = replace_sensitive_kernel_name(NewUniString,Lv,0,[],?ETS_SENSITIVE_WORDS),
    ReplacedStringUtf8 = unicode:characters_to_binary(ReplacedStringTmp, utf8),
    ?IF(IsReplace, replace_goods_msg(GoodsMsgs, ReplacedStringUtf8), ReplacedStringUtf8).
%%    unicode:characters_to_binary(ReplacedString, utf8).

replace_goods_msg([], String) -> String;
replace_goods_msg([[H|_]|T], String) ->
    NewString = re:replace(String,?GOODS_TMP_MSG, H, [{return,list}]),
    replace_goods_msg(T, NewString).

match_of_replace_sensitive_kernel_words([],_UniStringBin,_InputStrLen)-> 0;
match_of_replace_sensitive_kernel_words([Word|Wordlist],UniStringBin,InputStrLen)->
    WordLen = byte_size(Word),
    if
        WordLen > InputStrLen ->
            match_of_replace_sensitive_kernel_words(Wordlist, UniStringBin, InputStrLen);
        true ->
            <<W2:WordLen/binary,_/binary>> = UniStringBin,
            case Word == W2 of
                true -> WordLen;
                _ ->
                    match_of_replace_sensitive_kernel_words(Wordlist, UniStringBin, InputStrLen)
            end
    end.

%% 检测屏蔽字，并替换
replace_sensitive_kernel_words(UniStringBin,Lv,TalkOrName,LastReplaced,EtsName)->
    case unpack_filter_words_head(UniStringBin) of
        {[], _} -> LastReplaced;
        {Head, LeftUniStringBin} ->
            WordList = get_key_char_wordlist(Head,EtsName),
            InputStrLen = byte_size(UniStringBin),
            case match_of_replace_sensitive_kernel_words(WordList,UniStringBin,InputStrLen) of
                0->
                    NewReplaced = LastReplaced ++ [Head],
                    replace_sensitive_kernel_words(LeftUniStringBin,Lv,TalkOrName,NewReplaced,EtsName);
                WordLen->
                    <<FilterBin:WordLen/binary, NewLeftUniSringBin/binary>> = UniStringBin,
                    FilterStringList = unpack_filter_words(FilterBin, []),
                    ShowStringList = [make_sensitive_show_string(1) || _W <- FilterStringList],
                    NewReplaced = LastReplaced ++ ShowStringList,
                    replace_sensitive_kernel_words(NewLeftUniSringBin,Lv,TalkOrName,NewReplaced,EtsName)
            end
    end.

%% 文本预处理：分离文本中的单词
prehandle_filter_words(Text) ->
    {WordsList, _} = split_words(Text, 0, [], [], []),
    WordsList.

pre_handle_filter_words_with_split_char(Text) ->
    {WordsList, SplitCharList} = split_words(Text, 0, [], [], []),
%%    {WordsList, SplitCharList} = split_words2(Text, 0, [], [], []),
    {WordsList, SplitCharList}.

%% 合并文本
post_handle_filter_words_with_split_char(SplitCharList, ReplacedStringList) ->
    post_handle_filter_words_with_split_char_do(0, SplitCharList, ReplacedStringList, []).

post_handle_filter_words_with_split_char_do(_Pos, [], ReplacedStringList, Return) ->
    F = fun(Item, Acc) -> [Item|Acc] end,
    NewReturn = lists:foldl(F, Return, ReplacedStringList),
    lists:flatten(lists:reverse(NewReturn));
post_handle_filter_words_with_split_char_do(Pos, [{SplitWPos, [W]}|SplitCharList], ReplacedStringList, Return) ->
    {NewPos, NewReplacedStringList, NewReturn} = post_handle_filter_words_with_split_char_core(Pos, SplitWPos, [W], ReplacedStringList, Return),
    post_handle_filter_words_with_split_char_do(NewPos, SplitCharList, NewReplacedStringList, NewReturn);
post_handle_filter_words_with_split_char_do(Pos, [_|SplitCharList], ReplacedStringList, Return) ->
    post_handle_filter_words_with_split_char_do(Pos, SplitCharList, ReplacedStringList, Return).

post_handle_filter_words_with_split_char_core(Pos, _SplitWPos, InsertItem, [], Return) -> {Pos+1, [], [InsertItem|Return]};
post_handle_filter_words_with_split_char_core(Pos, SplitWPos, InsertItem, [Item|ReplacedStringList], Return) when Pos < SplitWPos ->
    post_handle_filter_words_with_split_char_core(Pos+1, SplitWPos, InsertItem, ReplacedStringList, [Item|Return]);
post_handle_filter_words_with_split_char_core(Pos, _SplitWPos, InsertItem, ReplacedStringList, Return) ->
    {Pos+1, ReplacedStringList, [InsertItem|Return]}.

%%%%% 分离单词和分隔符
split_words([], _SplitWPos, [], Acc, Acc2) ->
    {lists:reverse(Acc), lists:reverse(Acc2)};
split_words([], _SplitWPos, InnerWord, Acc, Acc2) ->
    {lists:reverse([lists:reverse(InnerWord)|Acc]), lists:reverse(Acc2)};
split_words([W|Word], SplitWPos, InnerWord, Acc, Acc2) ->
    case W < 255 of
        true ->
            if
                (W >= 32 andalso W =< 38) orelse
                (W >= 40 andalso W =< 47) orelse
                (W >= 58 andalso W =< 64) orelse
                (W >= 91 andalso W =< 96) orelse
                (W >= 123 andalso W =< 127) -> %% 分割符
                    case InnerWord == [] of
                        true ->
                            split_words(Word, SplitWPos+1, [], Acc, [{SplitWPos, [W]}|Acc2]);
                        _ ->
                            split_words(Word, SplitWPos+2, [], [lists:reverse(InnerWord)|Acc], [{SplitWPos+1, [W]}|Acc2])
                    end;
                true ->
                    split_words(Word, SplitWPos, [W|InnerWord], Acc, Acc2)
            end;
        _ ->
            case InnerWord == [] of
                true ->
                    split_words(Word, SplitWPos+1, [], [[W]|Acc], Acc2);
                _ ->
                    split_words(Word, SplitWPos+2, [], [[W], lists:reverse(InnerWord)|Acc], Acc2)
            end
    end.

%% 文本内容打解包：封装成二进制格式(查询速度差不多，内存占用有提升)
pack_filter_words(UniStringList) ->
    Fun = fun(Word) ->
        Len = length(Word),
        case Len == 0 of
            true -> <<0:2, 0:6>>;
            _ ->
                %% 一个单词应该不会超过63个字符，如果不加分隔符输入语句，将截断
                {NewLen, NewWord} = ?IF(Len > 63, {63, lists:sublist(Word, 63)}, {Len, Word}),
                [H|_] = NewWord,
                if
                    H<255 -> WType = 0, BitLen = 8;
                    H<65535 -> WType = 1, BitLen = 16;
                    true -> WType = 2, BitLen = 32
                end,
                L = [<<H1:BitLen>> || H1 <- NewWord],
                <<WType:2, NewLen:6, (list_to_binary(L))/binary>>
        end
    end,
    list_to_binary([Fun(E) ||E <- UniStringList]).

unpack_filter_words(UniStringBin, Acc) ->
    case unpack_filter_words_head(UniStringBin) of
        {[], _} -> lists:reverse(Acc);
        {Head, LeftUniStringBin} ->
            unpack_filter_words(LeftUniStringBin, [Head|Acc])
    end.

unpack_filter_words_head(UniStringBin) ->
    case UniStringBin of
        <<0:2, Len:6, LeftBin/binary>> ->
            Fun = fun(<<RestBin/binary>>) ->
                <<W:8, _Args/binary>> = RestBin,
                {W,_Args}
            end,
            {Result, NewRestBin} = unpack_array(0, Len, Fun, LeftBin, []),
            {Result, NewRestBin};
        <<1:2, Len:6, LeftBin/binary>> ->
            Fun = fun(<<RestBin/binary>>) ->
                <<W:16, _Args/binary>> = RestBin,
                {W,_Args}
            end,
            {Result, NewRestBin} = unpack_array(0, Len, Fun, LeftBin, []),
            {Result, NewRestBin};
        <<2:2, Len:6, LeftBin/binary>> ->
            Fun = fun(<<RestBin/binary>>) ->
                <<W:32, _Args/binary>> = RestBin,
                {W,_Args}
            end,
            {Result, RestBin} = unpack_array(0, Len, Fun, LeftBin, []),
            {Result, RestBin};
        _ ->
            {[], UniStringBin}
    end.

unpack_array(Max, Max, _, RestBin, Result) ->
    {lists:reverse(Result), RestBin};
unpack_array(Min, Max, Fun, Bin, Result) ->
    {One, RestBin} = Fun(Bin),
    unpack_array(Min+1, Max, Fun, RestBin, [One|Result]).

%% 批量获取
get_key_char_wordlist(KeyChar, EtsName) when is_list(EtsName) ->
    F = fun(TabName, WList) ->
        case ets:lookup(TabName, KeyChar) of
            [] -> WList;
            [{_H, WordList}] -> WList ++ WordList
        end
    end,
    lists:foldl(F, [], EtsName);
get_key_char_wordlist(KeyChar,EtsName)->
    case ets:lookup(EtsName,KeyChar) of
        []-> [];
        [{_H,WordList}]-> WordList
    end.

%%make_sensitive_show_string(0) ->
%%    "";
%%make_sensitive_show_string(1) ->
%%    "*";
%%make_sensitive_show_string(2) ->
%%    "*&";
%%make_sensitive_show_string(3) ->
%%    "*&^";
%%make_sensitive_show_string(4) ->
%%    "*&^%";
%%make_sensitive_show_string(5) ->
%%    "*&^%$";
%%make_sensitive_show_string(6) ->
%%    "*&^%$#";
%%make_sensitive_show_string(7) ->
%%    "*&^%$#@";
%%make_sensitive_show_string(8) ->
%%    "*&^%$#@!";
%%make_sensitive_show_string(N) ->
%%    M = N rem 8,
%%    C = N div 8,
%%    L1 = make_sensitive_show_string(M),
%%    L2 = lists:append(lists:duplicate(C, "*&^%$#@!")),
%%    lists:append([L2, L1]).

make_sensitive_show_string(N) -> lists:duplicate(N, "*").

test() ->
    [DescList] = io_lib:format("~ts", ["蜀门"]),
    io:format("~p ~p  ~p~n", [?MODULE, ?LINE, word_is_sensitive(DescList)]),
    [DescList1] = io_lib:format("~ts", ["玉之魂"]),
    io:format("~p ~p  ~p ~p~n", [?MODULE, ?LINE, "玉之魂", replace_sensitive_words(DescList1, 0)]),
    [DescList2] = io_lib:format("~ts", ["梦-话-西-游"]),
    io:format("~p ~p ~p ~p~n", [?MODULE, ?LINE, "梦-话-西-游", replace_sensitive_words(DescList2, 0)]),
    [DescList3] = io_lib:format("~ts", ["游ke"]),
    io:format("~p ~p ~p~n", [?MODULE, ?LINE, word_is_sensitive(DescList3)]),
    [DescList4] = io_lib:format("~ts", ["纯-白"]),
    io:format("~p ~p ~p~n", [?MODULE, ?LINE, word_is_sensitive(DescList4)]),
    [DescList5] = io_lib:format("~ts", ["á"]),
    io:format("~p ~p ~p~n", [?MODULE, ?LINE, word_is_sensitive(DescList5)]),
    % ulists:list_to_bin("á"),
    % unicode:characters_to_list("á", unicode),
    % mod_word:word_is_sensitive_name([195,161]),
    ok.

get_n(Char) ->
    WL = get_key_char_wordlist(Char, ?ETS_SENSITIVE_NAME),
    io:format("~p ~p WL:~p~n", [?MODULE, ?LINE, WL]).

get_w(Char) ->
    WL = get_key_char_wordlist(Char, ?ETS_SENSITIVE_WORDS),
    io:format("~p ~p WL:~p~n", [?MODULE, ?LINE, WL]).

%%
output_word_len()->
    WL = [{K, length(V)} || {K, V} <-ets:tab2list(?ETS_SENSITIVE_WORDS)],
    ?ERR("WL:~w ~n", [WL]),
    F = fun({K, V}) -> ?ERR("K:~p, Len:~w ~n", [K, V]) end,
    lists:foreach(F, lists:keysort(2, WL)),
    ok.

%% 测试性能
test_sensitive_prof(N) ->
    test_sensitive_prof(N, ["何家华", "蔡12312浩林"]),
    test_sensitive_prof(N, ["何家华[123]", "蔡[]12312浩林[1231]"]),
    test_sensitive_prof(N, ["何家华[123]", "蔡[]12312浩林[1231]"]).

test_sensitive_prof(N, SpecialWords) ->
    List = data_filter:get(),
    NList = [begin [DescList] = io_lib:format("~ts", [Word]), {Word, DescList} end||Word<-SpecialWords ++ List],
    ?PRINT("NList:~p~n", [NList]),
    ?INFO("NList:~p~n", [NList]),
    F1 = fun(_No) ->
        {_OWord, Word} = urand:list_rand(NList),
        % {_OWord, Word} = lists:nth(_No, NList),
        % ?PRINT("~p ~n", [OWord]),
        % ?PRINT("~w ~n", [OWord]),
        % ?PRINT("~p ~n", [Word]),
        % ?PRINT("~w ~n", [Word]),
        ?PRINT("~p ~p ~n", [Word, replace_sensitive_words(Word, 10)])
    end,
    R1 = tool:test_sensitive_prof_timer("replace_sensitive_words", F1, N),
    F2 = fun(_No) ->
        {_OWord, Word} = urand:list_rand(NList),
        % ?PRINT("~p ~n", [OWord]),
        % ?PRINT("~p ~n", [Word]),
        ?PRINT("~p ~p ~n", [Word, word_is_sensitive_name(Word)])
    end,
    R2 = tool:test_sensitive_prof_timer("word_is_sensitive_name", F2, N),
    [R1, R2].

% %% 运行单项测试并计时
% test_sensitive_prof_timer(Label, F, Count) ->
%     T0 = utime:longunixtime(),
%     statistics(runtime),
%     statistics(wall_clock),
%     util:for(1, Count, F),
%     {_, Time1} = statistics(runtime),     %% Time1：CPU在这期间执行的时间
%     {_, Time2} = statistics(wall_clock),  %% Time2：这段代码执行的时间
%     T1 = utime:longunixtime(),
%     U1 = Time1 * 1000 / Count,                %% U1：每一条记录的CPU执行的时间，单位为微秒
%     U2 = Time2 * 1000 / Count,                %% U2：每一条记录的代码执行的时间，单位为微秒
%     ?PRINT("~p [total: ~p(~p)ms avg: ~.3f(~.3f)us]~n", [Label, Time1, Time2, U1, U2]),
%     ?MYLOG("zhword_test", "~p [total: ~p(~p)ms avg: ~.3f(~.3f)us]~n", [Label, Time1, Time2, U1, U2]),
%     [Label, Time1, Time2, T1-T0].