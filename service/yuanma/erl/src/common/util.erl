%%%-----------------------------------
%%% @Module  : util
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.14
%%% @Description: 公共函数
%%%-----------------------------------
-module(util).
-include("server.hrl").
-include("record.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-export([
         bitstring_to_term/1
        ,boolean_to_integer/1
        ,send_after/4                   %% 设定定时器
        ,cancel_timer/1                 %% 取消定时器（自带判断）
        ,cast_event_to_players/1        %% 通知所有线路的玩家信息
        ,cast_event_to_players_helper/1 %% 通知所有线路的玩家信息（辅助函数）
        ,cast_event_to_players_delay/2
        ,cast_event_to_players_helper_delay/2
        ,check_char_encrypt/3
        ,check_length/2
        ,check_length/3
        ,combine_list/1                 %% 合并KeyValueList(Key相同的项 Value值相加)
        ,minus_list/2                   %% 减去KeyValueList(Key相同的项 Value值相减)
        ,debug/4                        %% 写入log/debug_...后台日志中
        ,errlog/4                       %% 写入log/errlog_...后台日志中
        ,info/4                         %% 写入log/errlog_...后台日志中
        ,weblog/5                       %% 写入log/errlog_...后台日志和Web日志
        ,filter_string/2
        ,find_ratio/2
        ,float_sub/2                    %% 按精度保留浮点数
        ,for/3                          %% 循环
        ,for/4                          %% 带状态循环
        ,get_list_elem_index/2
        ,is_merge_game/0                %% 是否合服过 true | false
        ,get_merge_time/0               %% 获取合服时间
        ,get_merge_day/0                %% 获取现在是合服第几天
        ,get_merge_day/1                %% 获取现在是合服第几天
        ,get_merge_day_start_time/0     %% 获取合服当天的开始时间
        ,get_merge_count/0              %% 获取合服次数
        ,get_merge_wlv/0                %% 获取合服世界等级
        ,get_cur_open_time/0
        ,get_open_day/0
        ,get_open_day/1
        ,get_open_time/0
        ,check_open_day/1
        ,check_open_day/2
        ,check_open_day_2/2
        ,get_tuplelist_elem_index/3
        ,get_validate_code/0            %% 获得验证码,只有十位(验证码有可能相同)
        ,integer_to_boolean/1
        ,is_cls/0                       %% 是否跨服中心
        ,is_dev/0                       %% 是否开发服
        ,list_to_record/2
        ,make_sure_binary/1
        ,make_sure_list/1
        ,md5/1
        ,multiserver_delay/4            %% 叠服延时运行
        ,multiserver_delay/1            %% 叠服延时
        ,rand_time_to_delay/4           %% 延迟1s内，起进程处理
        ,protocol/3
        ,record_return_form/2           %% 记录返回格式化，自定返回记录中的字段组成
        ,record_to_list/1
        ,replace/2                      %% 替换字符串内容
        ,replace_list_elem/3
        ,string_to_term/1
        ,string_width/1
        ,string_width/2
        ,term_to_bitstring/1
        ,term_to_string/1
        ,to_term/1
        ,ulist/1                        %% 保证列表的元素是唯一的unique_list
        ,fmt_bin/1                      %% format为字符串的binary形式
        ,fmt_bin/2
        ,join_bitstring/2
        ,term_area_value/4              %% 条件区域取值(返回元组中指定一元素)
        ,term_area_elem/3               %% 条件区域取值(返回元组)
        ,additive_tuplelist_elem/5      %% 累加tuplelist某一项的值
        ,minus_tuplelist_elem/5         %% 累减tuplelist某一项的值
        ,check_list/1                   %% 检查列表
        ,check_list/2                   %% 检查列表
        ,link_list/1                    %% 连接列表，
        ,link_list_client/1             %% 连接列表[客户端用]
        ,link_list/2                    %% 连接列表
        ,link_list_extra/1              %% 多个字符拼接成一个字符串
        ,parse_error_code/1
        ,make_error_code_msg/1
        ,make_goods_str/1
        ,pack_tv_goods/1
        ,ceil/1
        ,floor/1
        ,get_world_lv/0
        ,get_filter_word_channel/0
        ,get_filter_load_word/0
        ,get_filter_word/0
        ,log_file/5
        ,index_of_record/2
        ,pack_format_str/4
        ,pack_format_str/5
        ,get_server_name/0
        ,get_reg_server_id/0
        ,get_c_server_msg/0             %% 服信息
        ,get_server_type/0              %% 服类型
		,fix_sql_str/1             	    %% 修正sql的字符串
        ,calc_page_cache/3              %% 计算分页
        ,check_length_without_code/2    %% 字符串长度检查(中文，英文都当作长度为1)
        ,calc_recover_count/4           %% 计算恢复次数
        ,get_open_day_in_center/1       %% 可以用于跨服中心的计算开服天数
        ,get_merge_day_new/0            %%
        ,test_merge_day_diff/0          %%
        ,utf8_to_url/1                  %% utf8转url
        ,utf8_to_url/2
        ,ip2bin/1
        ]).

%% 下面两个个函数不建议使用，请使用include/common.hrl 的 ERR/2 和 DEBUG/2 宏
errlog(F, A, M, L) -> log_file("error", F, A, M, L).
info(F, A, M, L) -> log_file("info", F, A, M, L).
debug(F, A, M, L) -> log_file("debug", F, A, M, L).
weblog(F, A, M, L, RoleId) ->
    log_file("error", F, A, M, L),
    mod_game_error:sys_error(RoleId, F, A, M, L),
    ok.

%%记录
%% T = "errlog" | "test" | "debug" | string
log_file(T, F, A, Mod, Line) ->
    {{Y, M, D},{H, I, S}} = calendar:local_time(),
    Key = T++"_file_pid",
    Io = case get(Key) of
             {IoDevice, Y, M, D} ->
                 IoDevice;
             Other ->
                 Pre = case config:get_cls_type() of 1->"cls_"; _->"" end,
                 LogPath = config:get_log_path(),
                 File1 = lists:concat([LogPath, "/", Pre, T, "_", Y, "_", M, "_", D, ".txt"]),
                 {ok, IoDevice} = file:open(File1, [write, append]), %% {encoding, utf8}
                 put(Key, {IoDevice, Y, M, D}),
                 %% 关闭旧文件
                 case Other of
                     {OldIoDevice, _, _, _} -> file:close(OldIoDevice);
                     _ -> skip
                 end,
                 IoDevice
         end,
    Format = lists:concat(["####", Y, "-", M, "-", D, " ", H, ":", I, ":", S, " ", Mod, " [Line:", Line, "]: ~n  ", F,  "~n~n"]),
    io:format(Io, Format, A).

%% log_file(T, F, A, Mod, Line) ->
%%     {{Y, M, D},{H, I, S}} = calendar:local_time(),
%%     Key = T++"_file_pid",
%%     case get(Key) of
%%         {IoDevice, Y, M, D} ->
%%             Format = lists:concat(["####", Y, "-", M, "-", D, " ", H, ":", I, ":", S, " ", Mod, " [Line:", Line, "]: ~n  ", F,  "~n~n"]),
%%             io:format(IoDevice, Format, A);
%%         Other ->
%%             Pre = case config:get_cls_type() of 1->"cls_"; _->"" end,
%%             LogPath = config:get_log_path(),
%%             File1 = lists:concat([LogPath, "/", Pre, T, "_", Y, "_", M, "_", D, ".txt"]),
%%             %% {ok, IoDevice} = file:open(File1, [write, append]), %% {encoding, utf8}
%%             case file:open(File1, [write, append]) of
%%                 {ok, IoDevice} ->
%%                     put(Key, {IoDevice, Y, M, D}),
%%                     %% 关闭旧文件
%%                     case Other of
%%                         {OldIoDevice, _, _, _} -> file:close(OldIoDevice);
%%                         _ -> skip
%%                     end,
%%                     Format = lists:concat(["####", Y, "-", M, "-", D, " ", H, ":", I, ":", S, " ", Mod, " [Line:", Line, "]: ~n  ", F,  "~n~n"]),
%%                     io:format(IoDevice, Format, A);
%%                 _R ->
%%                     erlang:display(_R)
%%             end
%%     end.

%% for循环
for(I, Max, _F) when I>Max -> ok;
for(Max, Max, F) ->
    F(Max);
for(I, Max, F)   ->
    F(I),
    for(I+1, Max, F).

%% 带返回状态的for循环
%% @return {ok, State}
for(I, Max, _F, State) when Max<I -> {ok, State};
for(Max, Max, F, State) -> F(Max, State);
for(I, Max, F, State)   -> {ok, NewState} = F(I, State), for(I+1, Max, F, NewState).

%% 转换成HEX格式的md5
md5(S) ->
    lists:flatten([io_lib:format("~2.16.0b",[N]) || N <- binary_to_list(erlang:md5(S))]).

%% term序列化，term转换为string格式，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
    binary_to_list(list_to_binary(io_lib:format("~w", [Term]))).

%% term序列化，term转换为bitstring格式，e.g., [{a},1] => <<"[{a},1]">>
term_to_bitstring(Term) ->
    erlang:list_to_bitstring(io_lib:format("~w", [Term])).

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) ->
    case erl_scan:string(String++".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> Term;
                _Err -> undefined
            end;
        _Error ->
            undefined
    end.

%% term反序列化，bitstring转换为term，e.g., <<"[{a},1]">>  => [{a},1]
bitstring_to_term(undefined) -> undefined;
bitstring_to_term(BitString) ->
    string_to_term(binary_to_list(BitString)).

%% 长度合法性检查
check_length(Item, LenLimit) ->
    check_length(Item, 1, LenLimit).

check_length(Item, MinLen, MaxLen) ->
    case unicode:characters_to_list(list_to_binary(Item)) of
        UnicodeList when is_list(UnicodeList) ->
            Len = string_width(UnicodeList),
            Len =< MaxLen andalso Len >= MinLen;
        _ ->
            false
    end.

%% 长度合法性检查(中文，英文都当作长度为1)
check_length_without_code(Item, LenLimit) ->
    check_length_without_code(Item, 1, LenLimit).

check_length_without_code(Item, MinLen, MaxLen) ->
    case unicode:characters_to_list(list_to_binary(Item)) of
        UnicodeList when is_list(UnicodeList) ->
            Len = length(UnicodeList),
            Len =< MaxLen andalso Len >= MinLen;
        _ ->
            false
    end.

%% 字符宽度，1汉字=2单位长度，1数字字母=1单位长度
string_width(String) ->
    string_width(String, 0).
string_width([], Len) ->
    Len;
string_width([H | T], Len) ->
    case H > 255 of
        true ->
            string_width(T, Len + 2);
        false ->
            string_width(T, Len + 1)
    end.

%%=========================================================================
%% 辅助函数
%%=========================================================================

%%向上取整
ceil(N) ->
    T = trunc(N),
    case N == T of
        true  -> T;
        false -> 1 + T
    end.

%%向下取整
floor(X) ->
    T = trunc(X),
    case (X < T) of
        true -> T - 1;
        _ -> T
    end.

%% 保证列表中每个元素都是唯一的.unique_list()
ulist(List) ->
    F = fun(T, L) ->
        case lists:member(T, L) of
            true -> L;
            false -> [T|L]
        end
    end,
    lists:reverse(lists:foldl(F, [], List)).

%% 返回格式化的二进制字符串
-spec fmt_bin(Format, Args) -> binary() when
    Format :: list() | binary(),
    Args :: list().
fmt_bin(Format, Args) when is_list(Format) ->
    unicode:characters_to_binary(io_lib:format(Format, Args));
fmt_bin(Format, Args) when is_binary(Format) ->
    unicode:characters_to_binary(io_lib:format(unicode:characters_to_list(Format), Args)).

fmt_bin(Format) ->
    fmt_bin(Format, []).

%% 将二进制形式的字符串列表以指定字符串分隔，组成一个二进制字符串(类似string:join/2)
-spec join_bitstring(BitStrings :: [binary()], Separator :: binary() | list()) -> BitString :: binary().
join_bitstring([], _) -> <<>>;
join_bitstring([HeadBitString | Others], Separator) when is_binary(Separator) ->
    list_to_bitstring([HeadBitString | lists:append([ [Separator, BitString] || BitString <- Others])]);
join_bitstring(BitStrings, Separator) when is_list(Separator) ->
    join_bitstring(BitStrings, list_to_bitstring(Separator)).

%% -----------------------------------------------------------------
%% 确保字符串类型为二进制
%% -----------------------------------------------------------------
make_sure_binary(String) ->
    case is_binary(String) of
        true  -> String;
        false when is_list(String) -> ulists:list_to_bin(String);
        false ->
            ?ERR("util:make_sure_binary: Error string=[~p] ~n", [String]),
            <<>>
    end.

%% -----------------------------------------------------------------
%% 确保字符串类型为列表(确保都是小于255的列表)
%% -----------------------------------------------------------------
make_sure_list(String) ->
    case is_list(String) of
        true  -> String;
        false when is_binary(String) -> unicode:characters_to_list(String, latin1);
        false ->
            ?ERR("util:make_sure_list: Error string=[~p]~n", [String]),
            tool:back_trace_to_file(),
            []
    end.

%% -----------------------------------------------------------------
%% 过滤掉字符串中的特殊字符
%% -----------------------------------------------------------------
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
filter_string_helper([H|T], CharList, ResultString) ->
    case lists:member(H, CharList) of
        true -> filter_string_helper(T, CharList, ResultString);
        false-> filter_string_helper(T, CharList, ResultString++[H])
    end.

%% -----------------------------------------------------------------
%% 根据lists的元素值获得下标
%% -----------------------------------------------------------------
get_list_elem_index(Elem, List) ->
    get_lists_elem_index_helper(List, Elem, 0).
get_lists_elem_index_helper([], _Elem, _Index) ->
    0;
get_lists_elem_index_helper([H|T], Elem, Index) ->
    if  H =:= Elem ->
            Index+1;
        true ->
            get_lists_elem_index_helper(T, Elem, Index+1)
    end.

%% -----------------------------------------------------------------
%% 根据tuplelists的key值获得下标
%% -----------------------------------------------------------------
get_tuplelist_elem_index(Key, N, List) ->
    get_tuplelist_elem_index_helper(List, Key, N, 0).
get_tuplelist_elem_index_helper([], _Key, _N, _Index) ->
    0;
get_tuplelist_elem_index_helper([H|T], Key, N, Index) when is_tuple(H) ->
    if  element(N, H) =:= Key ->
            Index+1;
        true ->
            get_tuplelist_elem_index_helper(T, Key, N, Index+1)
    end;
get_tuplelist_elem_index_helper([_|T], Key, N, Index) ->
    get_tuplelist_elem_index_helper(T, Key, N, Index+1).

%% -----------------------------------------------------------------
%% 增加lists相应元素的值并获得新lists
%% -----------------------------------------------------------------
replace_list_elem(Index, NewElem, List) ->
    replace_list_elem_helper(List, Index, NewElem, 1, []).
replace_list_elem_helper([], _Index, _NewElem, _CurIndex, NewList) ->
    NewList;
replace_list_elem_helper([H|T], Index, NewElem, CurIndex, NewList) ->
    if  Index =:= CurIndex ->
            replace_list_elem_helper(T, Index, NewElem, CurIndex+1, NewList++[NewElem]);
        true ->
            replace_list_elem_helper(T, Index, NewElem, CurIndex+1, NewList++[H])
    end.

%% 获取开服准确时间(跨服中心不可用)
get_cur_open_time() ->
    case lib_server_kv:get_cur_open_time() of
        false -> 0;
        V -> V
    end.

%% 获取开服时间(跨服中心不可用)
get_open_time() ->
    case lib_server_kv:get_open_time() of
        false -> 0;
        V -> V
    end.

%% 获取开服天数(跨服中心不可用)
get_open_day() ->
    OpenTime = get_open_time(),
    Now = utime:standard_unixdate(),
    Day = (Now - OpenTime + 12 * ?ONE_HOUR_SECONDS) div ?ONE_DAY_SECONDS,
    max(Day + 1, 1).

%% 获取开服天数(跨服中心不可用)
get_open_day(Time) ->
    OpenTime = get_open_time(),
    Time1 = utime:standard_unixdate(Time),
    Day = (Time1 - OpenTime + 12 * ?ONE_HOUR_SECONDS) div ?ONE_DAY_SECONDS,
    max(Day + 1, 1).

%% 判断开服天数是否在多少天内
check_open_day(Day) ->
    Now_time = utime:unixtime(),
    check_open_day(Day, Now_time).

check_open_day(Day, Unixtime) ->
    Open_time = get_open_time(),
    ((Open_time + 86400 * Day) > Unixtime).

check_open_day_2(Day, OpTime) ->
    Now = utime:unixtime(),
    DayOpen = (Now - OpTime) div 86400,
    ((DayOpen+1) >= Day).

%% 是否合服过 true | false (跨服中心不可用)
is_merge_game() ->
    case get_merge_time() of
        0 -> false;
        Time when is_integer(Time), Time > 0 -> true;
        _ -> false
    end.

%% 获取合服准确时间(当前的合服准确时间,不一定是合服当天的开始时间) (跨服中心不可用)
%% “合服准确时间”与“合服准确时间零点”可能不一致,调用时注意
get_merge_time() ->
    case lib_server_kv:get_merge_time() of
        false -> 0;
        V -> V
    end.

%% 获取现在是合服第几天 (跨服中心不可用)
get_merge_day() ->
    Now = utime:unixtime(),
    get_merge_day(Now).

%% 获取现在是合服第几天 (跨服中心不可用) 新
get_merge_day_new() ->
    Now = utime:unixtime(),
    get_merge_day_new(Now).

get_merge_day(Now) ->
    case get_merge_day_start_time() of
        0 -> 0;
        MergeTime ->
            Day = (Now - MergeTime) div 86400,
            Day + 1
    end.

get_merge_day_new(Now) ->
    case get_merge_day_start_time() of
        0 -> 0;
        MergeTime ->
            Time1 = utime:standard_unixdate(Now),
            Day = (Time1 - MergeTime + 12 * ?ONE_HOUR_SECONDS) div ?ONE_DAY_SECONDS,
            Day + 1
    end.



%% 获取合服当天的开始时间  (跨服中心不可用)
get_merge_day_start_time() ->
    case get_merge_time() of
        0 -> 0;
        Time -> utime:get_logic_day_start_time(Time)
    end.

%% 获得合服的次数
get_merge_count() ->
    case lib_server_kv:get_merge_count() of
        false -> 0;
        V -> V
    end.

%% 获取合服世界等级
get_merge_wlv() ->
    case lib_server_kv:get_merge_wlv() of
        false -> 0;
        V -> V
    end.

%% 是否跨服中心
is_cls() ->
    %% 0:单服 1:跨服中心
    config:get_cls_type() == 1.

%% 是否开发服
-ifdef(DEV_SERVER).
is_dev() -> true.
-else.
is_dev() -> false.
-endif.

%% 世界等级
get_world_lv() ->
    case is_cls() of
        false ->
            case ets:lookup(?ETS_SERVER_KV, ?SKV_WORLD_LV) of
                [] -> 0;
                [KV] -> KV#server_kv.value
            end;
        true -> 0
    end.

%% 获取屏蔽词渠道
get_filter_word_channel() ->
    case lib_server_kv:get_filter_word_channel() of
        false -> 0;
        V -> V
    end.

%% 获取屏蔽词加载次数
get_filter_load_word() ->
    case lib_server_kv:get_filter_load_word() of
        false -> 0;
        V -> V
    end.

%% 获得屏蔽词
get_filter_word() ->
    case lib_server_kv:get_filter_word() of
        false -> 0;
        V -> V
    end.

to_term(BinString) when is_list(BinString) -> BinString;
to_term(BinString) when is_binary(BinString) ->
    case util:bitstring_to_term(BinString) of
        undefined -> [];
        Term -> Term
    end;
to_term(_BinString) -> [].

boolean_to_integer(true) -> 1;
boolean_to_integer(false) -> 0.
integer_to_boolean(1) -> true;
integer_to_boolean(0) -> false.


%% 字符加密
check_char_encrypt(_Id, _Time, _TK) ->
    true.
%%TICKET = "7YnELt8MmA4jVED7",
%%Hex = util:md5(lists:concat([Time, Id,TICKET])),
%%NowTime = utime:unixtime(),
%%Hex =:= TK andalso NowTime - Time >= -10 andalso NowTime - Time < 300.
%%Hex =:= TK.

%% 设定定时器
send_after(OldRef, Time, Pid, Msg) ->
    util:cancel_timer(OldRef),
    erlang:send_after(Time, Pid, Msg).


%% 取消定时器（自带判断）
cancel_timer(Ref) when is_reference(Ref) -> erlang:cancel_timer(Ref);
cancel_timer(_) -> false.

%% --------------------------------------------------------------------------------------
%% @doc 记录返回格式化
-spec record_return_form(Record, ResultForm) -> Result when
      Record      :: tuple(),                      %% 各种记录
      ResultForm  :: list() | integer() | all,     %% 如 [#ets_mon.xx1, #ets_mon.xx2...] | {#ets_mon.xx1, #ets_mon.xx2...} | all | #ets_mon.xx1 属性组装列表或者单项属性
      Result      :: list() | value     | tuple(). %% 对应ResultForm的传入得出不同的参数
%% @end
%% --------------------------------------------------------------------------------------
record_return_form(Record, ResultForm) when is_list(ResultForm)->
    F = fun(Num) ->
                element(Num, Record)
        end,
    [F(Num) || Num <- ResultForm, is_integer(Num)];
%% @param {#ets_mon.xx1, #ets_mon.xx2...}
%% @return {Mon#ets_mon.xx1, Mon#ets_mon.xx2...}
record_return_form(Record, ResultForm) when is_tuple(ResultForm) ->
    F = fun(Num) -> element(Num, Record) end,
    List = [F(Num) || Num <- tuple_to_list(ResultForm), is_integer(Num)],
    list_to_tuple(List);
record_return_form(Record, ResultForm) ->
    case ResultForm of
        all -> Record;
        _   when is_integer(ResultForm) -> element(ResultForm, Record);
        _   -> bad_result_form
    end.

%% list 转 record
%% @param List 必须长度跟rocrod一样
%% @param RecordAtom record的名字,是一个原子
%% @return RecordAtom类型的RECORD
list_to_record(List, RecordAtom) ->
    RecordList = [RecordAtom|List],
    erlang:list_to_tuple(RecordList).

%% record 转 list
%% @return 一个LIST 成员同 Record一样
record_to_list(Record) when erlang:is_tuple(Record)->
    RecordList = erlang:tuple_to_list(Record),
    [_|ListLeft] = RecordList,
    ListLeft;
record_to_list(Record) when is_list(Record) ->
    Record;
record_to_list(_Record)->
    [].

protocol(PlayerName, Cmd, Bin) ->
    %%{ok, PlayerName2} = asn1rt:utf8_binary_to_list(PlayerName),
    PlayerName2 = make_sure_list(PlayerName),
    case lib_player:get_role_id_by_name(PlayerName2) of
        null -> false;
        PlayerId ->
            case misc:get_player_process(PlayerId) of
                Pid when is_pid(Pid) ->
                    gen_server:call(Pid, {'SOCKET_EVENT', Cmd, Bin});
                _ ->
                    false
            end
    end.

%% List为元组列表，N为元组里的某个元素,该元素为概率值
find_ratio(List, N) ->
    F = fun(RatioInfo, Sum) ->
        element(N, RatioInfo) + Sum
    end,
    TotalRatio = lists:foldl(F, 0, List),
    Rand = urand:rand(1, TotalRatio),
    find_ratio(List, 0, Rand, N).
%% 查找匹配机率的值
find_ratio([], _, _, _) -> null;
find_ratio(InfoList, Start, Rand, N) ->
    [Info | List] = InfoList,
    End = Start + element(N, Info),
    case Rand > Start andalso Rand =< End of
        true -> Info;
        false -> find_ratio(List, End, Rand, N)
    end.

%% ---------------------------------------------------------------------------
%% @doc 合并KeyValueList(Key相同的项 Value值相加)
-spec combine_list(List) -> NewList when
      List   :: [{Key, Num}],
      NewList:: [{Key, Num}],
      Key    :: term(),
      Num    :: integer().
%% ---------------------------------------------------------------------------
combine_list(GoodsList) ->
    F = fun({Key, Value}, Result) ->
                case lists:keyfind(Key, 1, Result) of
                    false -> [{Key, Value} | Result];
                    {_, Value1} ->
                        lists:keystore(Key, 1, Result, {Key, Value + Value1})
                end
        end,
    lists:foldl(F, [], GoodsList).

%% KeyValList相减(MinusList中的Key存在于List中 则List对应的Val减去MinusList对应的Val)
minus_list(List, MinusList) ->
    F = fun({Key, Value}, AccList) ->
                case lists:keyfind(Key, 1, AccList) of
                    false -> AccList;
                    {_, Value1} ->
                        lists:keystore(Key, 1, AccList, {Key, Value - Value1})
                end
        end,
    lists:foldl(F, List, MinusList).


%% 通知所有线路的玩家信息
%% @param Event mod_server_cast:handle_cast(Event, State)中的Event
cast_event_to_players(Event) ->
    Server = mod_disperse:node_list(),
    F = fun(S) ->
                rpc:cast(S#node.node, ?MODULE, cast_event_to_players_helper, [Event])
        end,
    [F(S) || S <- Server].

cast_event_to_players_helper(Event) ->
    Data = ets:tab2list(?ETS_ONLINE),
    [gen_server:cast(D#ets_online.pid, Event) || D <- Data],
    ok.

%% 通知所有线路的玩家信息(每个玩家都间隔几秒)
%% @param Event mod_server_cast:handle_cast(Event, State)中的Event
%% @param SleepMs 毫秒
cast_event_to_players_delay(Event, SleepMs) ->
    Server = mod_disperse:node_list(),
    F = fun(S) ->
                rpc:cast(S#node.node, ?MODULE, cast_event_to_players_helper_delay, [Event, SleepMs])
        end,
    [F(S) || S <- Server].

cast_event_to_players_helper_delay(Event, SleepMs) ->
    Data = ets:tab2list(?ETS_ONLINE),
    %% [gen_server:cast(D#ets_online.pid, Event) || D <- Data],
    spawn(fun() -> spawn_cast_event_to_players_helper_delay(Data, Event, SleepMs) end),
    ok.

%% 开进程
spawn_cast_event_to_players_helper_delay([], _Event, _SleepMs) -> ok;
spawn_cast_event_to_players_helper_delay([D|Data], Event, SleepMs) ->
    gen_server:cast(D#ets_online.pid, Event),
    timer:sleep(SleepMs),
    spawn_cast_event_to_players_helper_delay(Data, Event, SleepMs).

%% 获得验证码,只有十位(验证码有可能相同)
get_validate_code() ->
    Timestamp = utime:longunixtime(),
    KeyRand = urand:rand(1, 10000),
    KeyTicket = string:to_upper(util:md5(lists:concat([KeyRand, Timestamp]))),
    %% 截取10位
    lists:sublist(KeyTicket, 10).


%% ---------------------------------------------------------------------------
%% @doc 按精度保留浮点数
-spec float_sub(Float, Sub) ->  Return when
      Float   :: float(),         %%
      Sub     :: integer(),       %% 列表
      Return  :: float().         %% 返回值
%% ---------------------------------------------------------------------------
float_sub(Float, Sub) when is_integer(Float) ->
    F = float_to_binary(float(Float), [{decimals, Sub}]),
    binary_to_float(F);
float_sub(Float, Sub) when is_float(Float) ->
    F = float_to_binary(Float, [{decimals, Sub}]),
    binary_to_float(F).

%% 替换字符串内容
replace(String, []) ->
    String;
replace(String, [{RE,Replacement}|Left]) ->
    NewString = replace(String, RE, Replacement),
    replace(NewString, Left).

replace(String, RE, Replacement) ->
    case re:run(String, RE) of
        nomatch -> String;
        _ ->
            NewString = re:replace(String, RE, Replacement, [{return,list}]),
            replace(NewString, RE, Replacement)
    end.

multiserver_delay(DelaySec, Module, Function, Args) ->
    SerId = config:get_server_id(),
    EveryServerDelayTime = SerId rem 20 * 3000,
    Sleep = max(round(DelaySec*1000+EveryServerDelayTime), 0),
    timer:sleep(Sleep),
    apply(Module, Function, Args).

multiserver_delay(DelaySec) ->
    SerId = config:get_server_id(),
    EveryServerDelayTime = SerId rem 20 * 3000,
    Sleep = max(round(DelaySec*1000+EveryServerDelayTime), 0),
    timer:sleep(Sleep).

%% 延时1s内的创建进程处理
rand_time_to_delay(DelaySec, Module, Function, Args) ->
    RandTime = urand:rand(1, DelaySec),
    spawn(
      fun() -> timer:sleep(RandTime), apply(Module, Function, Args) end
     ).


%% ---------------------------------------------------------------------------
%% @doc 条件区域取值（返回元组中指定一元素）
-spec term_area_value(L, N1, N2, ConValue) -> Res when
      L           :: [tuple()],           %% 条件区域元组列表
      N1          :: integer(),           %% 元组中条件字段的位置
      N2          :: integer(),           %% 目标值在元组中的位置
      ConValue    :: integer(),           %% 过滤条件值
      Res         :: term().              %% 返回目标值
%% ---------------------------------------------------------------------------
%% Usage: 查找当前服务器等级下(40级)，某物品的基准价格
%% term_area_value([{0,10}{30,100},{50,300}], 1, 2, 40)
term_area_value(L, N1, N2, ConValue) ->
    LSort = lists:keysort(N1, L),
    LSortR = lists:reverse(LSort),
    case term_area_value_helper(LSortR, N1, N2, ConValue) of
        [] -> 0;
        V -> V
    end.

term_area_value_helper([], _N1, _N2, _ConValue) -> [];
term_area_value_helper([Tuple|T], N1, N2, ConValue) ->
    Value1 = element(N1, Tuple),
    if
        ConValue>=Value1 orelse T == [] -> element(N2, Tuple);
        true -> term_area_value_helper(T, N1, N2, ConValue)
    end.

%% ---------------------------------------------------------------------------
%% @doc 条件区域取值（返回元组）
-spec term_area_elem(L, N, ConValue) -> Res when
      L           :: [tuple()],           %% 条件区域元组列表
      N           :: integer(),           %% 元组中条件字段的位置
      ConValue    :: integer(),           %% 过滤条件值
      Res         :: term().              %% 返回元组
%% ---------------------------------------------------------------------------

term_area_elem(L, N, ConValue) ->
    LSort = lists:keysort(N, L),
    LSortR = lists:reverse(LSort),
    case term_area_elem_helper(LSortR, N, ConValue) of
        [] -> 0;
        V -> V
    end.

term_area_elem_helper([], _N, _ConValue) -> [];
term_area_elem_helper([Tuple|T], N, ConValue) ->
    Value1 = element(N, Tuple),
    if
        ConValue>=Value1 orelse T == [] -> Tuple;
        true -> term_area_elem_helper(T, N, ConValue)
    end.

%% ---------------------------------------------------------------------------
%% @doc 累加tuplelist某一项的值
-spec additive_tuplelist_elem(TupleList, Key, N1, N2, Num) -> Res when
      TupleList   :: [tuple()],           %% 元组列表
      N1          :: integer(),           %% 元组中主键的位置
      N2          :: integer(),           %% 目标项在元组中的位置
      Key         :: term(),              %% 主键
      Num         :: integer(),           %% 增加的值
      Res         :: term().              %% 返回更新后元组列表
%% ---------------------------------------------------------------------------
%% Usage:
%% 给主键为1002的元组第二项增加20
%% TupleList = [{1001,10},{1002,1}]
%% additive_tuplelist_elem(TupleList, 1, 2, 1002, 20)
additive_tuplelist_elem(TupleList, N1, N2, Key, Num) ->
    NewTuple = case lists:keyfind(Key, N1, TupleList) of
                   false -> {Key, Num};
                   Tuple ->
                       Value = element(N2, Tuple),
                       NewNum = Num + Value,
                       setelement(N2, Tuple, NewNum)
               end,
    lists:keystore(Key, N1, TupleList, NewTuple).

%% @doc 累减tuplelist某一项的值
minus_tuplelist_elem(TupleList, N1, N2, Key, Num) ->
    case lists:keyfind(Key, N1, TupleList) of
        false -> TupleList;
        Tuple ->
            Value = element(N2, Tuple),
            NewNum = max(Value - Num, 0),
            NewTuple = setelement(N2, Tuple, NewNum),
            lists:keystore(Key, N1, TupleList, NewTuple)
    end.

%% 检查函数
check_list([], _M) -> true;
check_list([{F, A}|L], M) ->
    case apply(M, F, A) of
        true -> check_list(L);
        {false, R} -> {false, R}
    end.

check_list([]) -> true;
check_list([F|L]) when is_function(F) ->
    case F() of
        true -> check_list(L);
        Result -> Result
    end;
check_list([{F, ErrCode}|L]) ->
    case F() of
        true -> check_list(L);
        _ -> {false, ErrCode}
    end;
check_list([{M, F, A}|L]) ->
    case apply(M, F, A) of
        true -> check_list(L);
        {false, ErrCode} -> {false, ErrCode}
    end;
check_list([{M, F, A, ErrCode}|L]) ->
    case apply(M, F, A) of
        true -> check_list(L);
        _ -> {false, ErrCode}
    end.

%% 连接字符
link_list(List) ->
    link_list(List, ",").

%% 连接字符[用于客户端的连接字符]
link_list_client(List) ->
    link_list(List, "#&").

%% 连接字符
%% @param SpiltChar string()
link_list(List, SpiltChar) ->
    lists:concat(link_list(List, SpiltChar, [])).

%% 连接字符
link_list([], _SpiltChar, NewList) ->
    NewList;
link_list([L | []], _SpiltChar, NewList) ->
    NewList ++ [ulists:thing_to_list(L)];
link_list([L | T], SpiltChar, NewList) ->
    link_list(T, SpiltChar, NewList ++ [ulists:thing_to_list(L)] ++ [SpiltChar]).

%% link_list_hlep(Data) when is_binary(Data)->
%%     binary_to_list(Data);
%% link_list_hlep(Data) when is_float(Data) ->

%% link_list_hlep(Data) ->
%%     Data.

%% 多个字符拼接成一个字符串
link_list_extra(List) ->
    lists:concat(link_list_extra(List, [])).

%% 连接字符
link_list_extra([], NewList) ->
    NewList;
link_list_extra([L | []], NewList) ->
    NewList ++ [ulists:thing_to_list(L)];
link_list_extra([L | T], NewList) ->  %% 显式声明、为utf8
    link_list_extra(T, NewList ++ [ulists:thing_to_list(L)] ++ [ulists:thing_to_list(<<"、"/utf8>>)]).

%% 转化错误码
%% ErrorCode : is_integer()|{is_integer(), is_list()}
%% @return {integer(), string()}
parse_error_code(ErrorCode) ->
    case ErrorCode of
        ErrorCodeList when is_list(ErrorCodeList) -> ErrorCodeInt = ?FAIL, ErrorCodeArgs = [];
        ErrorCodeInt when is_integer(ErrorCodeInt) -> ErrorCodeArgs = [];
        {ErrorCodeInt, ErrorCodeArgs} -> skip
    end,
    {ErrorCodeInt, link_list_client(ErrorCodeArgs)}.

%% 组装错误码字符串
make_error_code_msg(ErrorCode) ->
    case is_list(ErrorCode) of
        true -> ErrorCode;
        false ->
            {ErrorCodeInt, ErrorCodeArgs} = make_error_code_msg_help(ErrorCode),
            case data_errorcode_msg:get(ErrorCodeInt) of
                [] -> "";
                #errorcode_msg{about = About} -> uio:format(About, ErrorCodeArgs)
            end
    end.

%% 转化错误码
make_error_code_msg_help(ErrorCode) ->
    case ErrorCode of
        ErrorCodeList when is_list(ErrorCodeList) -> ErrorCodeInt = ?FAIL, ErrorCodeArgs = [];
        ErrorCodeInt when is_integer(ErrorCodeInt) -> ErrorCodeArgs = [];
        {ErrorCodeInt, ErrorCodeArgs} -> skip
    end,
    {ErrorCodeInt, ErrorCodeArgs}.

%% 组装物品Str
make_goods_str(GoodsList) -> make_goods_str(GoodsList, "").

make_goods_str([], Str) -> Str;
make_goods_str([{_Type, GoodsTypeId, Num}|L], Str) ->
    case data_goods_type:get(GoodsTypeId) of
        [] -> GoodsName = "";
        #ets_goods_type{goods_name = GoodsName} -> ok
    end,
    case L == [] of
        true -> NewStr = lists:concat([Str, GoodsName, "*", Num]);
        false -> NewStr = lists:concat([Str, GoodsName, "*", Num, "，"])
    end,
    make_goods_str(L, NewStr);
make_goods_str([_|L], Str) ->
    make_goods_str(L, Str).

%% 语言拼接物品   名字*数量、名字*数量
pack_tv_goods(List) ->
    ResList
        = lists:foldl(
            fun({?TYPE_GOODS, GoodsId, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, GoodsId, Num);
               ({?TYPE_BIND_GOODS, GoodsId, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, GoodsId, Num);
               ({?TYPE_COIN, _Id, Num}, ResList) ->  util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_COIN, Num);
               ({?TYPE_GOLD, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_GOLD, Num);
               ({?TYPE_BGOLD, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_BGOLD, Num);
               ({?TYPE_EXP, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_EXP, Num);
               ({?TYPE_GFUNDS, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_GFUNDS, Num);
               ({?TYPE_GDONATE, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_GDONATE, Num);
               ({?TYPE_GUILD_PRESTIGE, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_GUILD_PRESTIGE, Num);
               ({?TYPE_FASHION_NUM, PosId, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_FASHION_NUM(PosId), Num);
               ({?TYPE_RUNE, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_RUNE, Num);
               ({?TYPE_SOUL, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_SOUL, Num);
               ({?TYPE_RUNE_CHIP, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_RUNE_CHIP, Num);
               ({?TYPE_GUILD_DRAGON_MAT, _Id, Num}, ResList) -> util:additive_tuplelist_elem(ResList, 1, 2, ?GOODS_ID_GDRAGON_MAT, Num);
               (_, ResList) ->
                    ResList
            end, [], List),
    pack_tv_goods_helper(ResList, []).

pack_tv_goods_helper([], List) -> List;
pack_tv_goods_helper([{GoodsId, Num}|T], List) ->
    NewList = case List of
                  [] -> ulists:concat(["<a@goods@", GoodsId, ">", "</a>", "*", Num]);
                  _ -> ulists:concat([List, "、", "<a@goods@", GoodsId, ">", "</a>", "*", Num])
              end,
    pack_tv_goods_helper(T, NewList).

%% 获取记录的key的下标
index_of_record(K, RecordInfo)->
    index_of_record(K, RecordInfo, 1).

index_of_record(_K, [], _N) -> 0;
index_of_record(K, [K|_RecordInfo], N) -> N;
index_of_record(K, [_K|RecordInfo], N) ->
    index_of_record(K, RecordInfo, N+1).

%% ChangeLine :: boolean 打印所在行信息与需要打印的信息之间需要换行
pack_format_str(ChangeLine, Format, Module, Line) ->
    pack_format_str(ChangeLine, Format, Module, Line, calendar:local_time()).
pack_format_str(ChangeLine, Format, Module, Line, LocalTime) ->
    {{Year, Mon, Day}, {Hour, Min, Sec}} = LocalTime,
    TimeFormat = ulists:concat([Year, "-", Mon, "-", Day, " ", Hour, ":", Min, ":", Sec, " "]),
    if
        Module == [] -> ulists:concat([TimeFormat, Format, "~n"]);
        %% 换行：FormatType为需要写日志文件的情况时，打印所在行信息与需要打印的信息之间需要换行
        %% 不换行时，打印信息的第二行开始头部会有一长串空字符，造成文件容量偏大
        ChangeLine == true -> ulists:concat([TimeFormat, Module, ":", "[", Line, " line]", ":", "~n", Format, "~n"]);
        %% 不换行：仅当FormatType为format(控制台打印使用)时，，打印所在行信息与需要打印的信息之间不换行
        true -> ulists:concat([TimeFormat, Module, ":", "[", Line, " line]", ": ", Format, "~n"])
    end.

%% 游戏服名字
get_server_name()->
    case lib_server_kv:get_server_name() of
        false -> <<"1服"/utf8>>;
        V -> V
    end.

%% 游戏服注册系统服id
get_reg_server_id() ->
    case lib_server_kv:get_reg_server_id() of
        false -> 1;
        V -> V
    end.

%% 客户端展示的服信息(二进制)##具体看运营填写，如 中文，数字，英文都能支持; base_game.cfg_name=c_server_msg 中取;需要支持服信息更新(lib_php_api:reload_c_server_msg)
%% NOTE:遍历发送给客户端，不能在遍历中调用本函数，放在遍历外面
get_c_server_msg() ->
    case lib_server_kv:get_c_server_msg() of
        false -> <<>>;
        V -> V
    end.

%% 获取服类型##不要直接调用本函数，使用 config:get_server_type() 获取，暂时是放在ets中，影响性能的话会配合运维放到gsrv.config
get_server_type() ->
    case lib_server_kv:get_server_type() of
        false -> 0;
        V -> V
    end.

%% 修正sql的字符串
%% 备注:英文版本需要单引号写入数据库.所以字符串涉及到有单引号要先转换成sql的字符串
fix_sql_str(Str) ->
    % 要转换成binary,否则unicode的字符串编码会报错
    re:replace(util:make_sure_binary(Str), "'", ["\\\\'"], [global, {return, binary}]).

%% 计算分页
%% RecordTotal:总长度 PageSize:页大小 PageNo:第几页
%% @return {总页数, 开始位置, 本页大小}
calc_page_cache(RecordTotal, PageSize, PageNo) when RecordTotal > 0, PageSize > 0, PageNo > 0 ->
    PageTotal = (RecordTotal+PageSize-1) div PageSize,
    StartPos = (PageNo - 1) * PageSize + 1,
    if
        ((PageNo > PageTotal) or (PageNo < 1)) ->
            {PageTotal, 1, 0};
        true ->
            if
                PageNo*PageSize > RecordTotal ->
                    {PageTotal, StartPos, RecordTotal-(PageNo-1) * PageSize};
                true ->
                    {PageTotal, StartPos, PageSize}
            end
    end;
calc_page_cache(_RecordTotal, _PageSize, _PageNo) ->
    {0, 1, 0}.

%% 计算恢复次数
calc_recover_count(Count, LastTime, MaxCount, AddTime) ->
    NowTime = utime:unixtime(),
    AddCount = max(NowTime - LastTime, 0) div AddTime,
    NewLastTime = NowTime - max(NowTime - LastTime, 0) rem AddTime,
    NewCount = min(Count+AddCount, MaxCount),
    case NewCount >= MaxCount of
        true -> {NewCount, 0};
        false -> {NewCount, NewLastTime}
    end.


%% 获取开服天数
get_open_day_in_center(OpenTime) ->
    Now = utime:unixtime(),
    Day = (Now - OpenTime) div 86400,
    Day + 1.


test_merge_day_diff() ->
    DayOld = get_merge_day(),
    DayNew = get_merge_day_new(),
    ?INFO("Dayold ~p  DayNew ~p~n", [DayOld, DayNew]).


%% utf8 -> urlunicode
utf8_to_url(Data) when is_binary(Data)->
    Data2 = [T || <<T:8>> <= Data],
    utf8_to_url(Data2, []);
utf8_to_url(Data) when is_list(Data)->
    utf8_to_url(Data, []).

utf8_to_url([], Url) -> Url;
utf8_to_url([Utf8Code | Tail], Url) ->
    NewUrl = Url ++ "%" ++ integer_to_list(Utf8Code, 16),
    utf8_to_url(Tail, NewUrl).

%% IP元组/字符串转二进制字符串
ip2bin({A, B, C, D}) ->
    list_to_binary([
            integer_to_binary(A), <<".">>, integer_to_binary(B), <<".">>,
            integer_to_binary(C), <<".">>, integer_to_binary(D)
        ]);
ip2bin({A, B, C, D, E, F, G, H}) ->
    list_to_binary([
            integer_to_binary(A, 16), ":", integer_to_binary(B, 16), ":",
            integer_to_binary(C, 16), ":", integer_to_binary(D, 16), ":",
            integer_to_binary(E, 16), ":", integer_to_binary(F, 16), ":",
            integer_to_binary(G, 16), ":", integer_to_binary(H, 16)
        ]);
ip2bin(IpBin) when is_binary(IpBin) ->
    IpBin;
ip2bin(IpStr) when is_list(IpStr) ->
    list_to_binary(IpStr).