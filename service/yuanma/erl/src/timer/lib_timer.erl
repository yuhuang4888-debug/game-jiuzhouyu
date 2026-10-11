%% ---------------------------------------------------------------------------
%% @doc lib_timer
%% @author hjh
%% @since  2020年9月30日
%% @deprecated  定时器函数
%% ---------------------------------------------------------------------------
-module(lib_timer).
-compile(export_all).
-include("common.hrl").
-include("timer.hrl").

%% 获取服默认延迟
get_ser_delay_time() ->
    SerId = config:get_server_id(),
    SerId rem 20 * 3000.

%% 执行延迟函数列表:每次增加1.0~1.3秒,随机保证错开峰值
%% 执行函数{M, F, A} 实际执行 {M, F, [#timer{}]++A},增加多一个参数
apply_delay_mfa_list([]) -> ok;
apply_delay_mfa_list([{MilliSec, MfaList}|T]) ->
    apply_delay_mfa_list_help(MfaList, MilliSec, 0),
    apply_delay_mfa_list(T);
apply_delay_mfa_list([_H|T]) ->
    ?ERR("apply_delay_mfa_list_help _H:~p ~n", [_H]),
    apply_delay_mfa_list(T).

apply_delay_mfa_list_help([], _Sec, _No) -> ok;
apply_delay_mfa_list_help([{M, F, Args}|T], MilliSec, No) ->
    DelaySec = MilliSec + 1000*No + urand:rand(1, 300),
    Timer = #timer{delay_sec = DelaySec},
    try 
        erlang:apply(M, F, [Timer]++Args)
    catch A : B -> 
        ?ERR("{M, F, Args}:~p : ~p : ~p : ~p\n", [{M, F, [Timer]++Args}, A, B, erlang:get_stacktrace()])
    end,
    apply_delay_mfa_list_help(T, MilliSec, No+1);
apply_delay_mfa_list_help([_H|T], MilliSec, No) ->
    ?ERR("apply_delay_mfa_list_help _NoMatch:~p MilliSec, No:~p ~n", [_H, MilliSec, No]),
    apply_delay_mfa_list_help(T, MilliSec, No).

%% 获得模块延迟的毫秒数，以零点为锚，每个模块根据序号操作数据库，能避免同一时间操作数据库。（前提是本模块操作是能延迟的，不能延迟就不要加睡眠）
%% 注意：
%%  1、在 lib_timer:create_mod_no 函数添加对应的函数
%%  2、执行 lib_timer:create_mod_no 函数，并且把生成的文件直接覆盖到 get_mod_no/4 函数上面。
%% @param MilliSec 默认延迟毫秒数：以零点计算的,需要延迟的毫秒数。尽量不要在零点同时执行
get_mod_delay_time(MilliSec, M, F) -> get_mod_delay_time(MilliSec, M, F, 0).

%% 延迟毫秒数 = MilliSec+服时间+1000*序号+300毫秒的随机
%% @param 毫秒数 默认延迟
%% @param 模块 如:lib_timer
%% @param 函数 如:test_timer
%% @param 标识 重复函数名标识,能区分就行,一般填0
get_mod_delay_time(MilliSec, M, F, Flag) ->
    get_ser_delay_time() + 1000*get_mod_no(MilliSec, M, F, Flag) + urand:rand(1, 300).

%% 获取模块序号
%% @param 模块 如:lib_timer
%% @param 函数 如:test_timer
%% @param 标识(数字) 重复函数名标识,能区分就行,一般填0
% get_mod_no(0, lib_timer, test_timer, 0) -> 1;
% get_mod_no(30, lib_timer, test_timer, 0) -> 1;
get_mod_no(_MilliSec, _M, _F, _Flag) -> 0.

%% 自动生成序号,然后复制到 get_mod_no/4 函数上面
%% @return
%%  get_mod_no(0, lib_timer, test_timer, 0) -> 1;
%%  get_mod_no(30, lib_timer, test_timer, 0) -> 1;
create_mod_no() ->
    List = [
        % 以零点计算的,需要延迟的毫秒数
        {0, [
                % 第三个参数:重复函数名标识,能区分就行,一般填0
                % {lib_timer, test_timer, 0}
            ]},
        % 30秒
        {30000, [
                % {lib_timer, test_timer, 0}
            ]},
        % 60秒
        {60000, [
                % {lib_timer, test_timer, 0}
            ]}
    ],
    Str = create_mod_no_to_file(List),
    Str.

create_mod_no_to_file(List) ->
    F = fun({Sec, MfL}, Str) ->
        F2 = fun({M, F, Flag}, {TmpNum, TwoStr}) ->
            case TwoStr == [] of
                true -> {TmpNum+1, lists:concat([get_mod_no, "(", Sec, ", ", M, ", ", F, ", ", Flag, ") -> ", TmpNum, ";"])};
                false -> {TmpNum+1, lists:concat([TwoStr, "\n", get_mod_no, "(", Sec, ", ", M, ", ", F, ", ", Flag, ") -> ", TmpNum, ";"])}
            end
        end,
        {_, NStr} = lists:foldl(F2, {1, Str}, MfL),
        NStr
    end,
    Str = lists:foldl(F, [], List),
    % ?MYLOG("createmodno", "~p~n", [Str]),
    {ok, FileF} = file:open("../logs/create_mod_no_" ++ util:term_to_string(calendar:now_to_datetime(os:timestamp())), [write]),
    io:format(FileF, unicode:characters_to_list(Str), []),
    file:close(FileF),
    Str.

%% 测试
test_timer(#timer{delay_sec = DelaySec}) ->
    spawn( fun() -> timer:sleep(DelaySec), ?INFO("test_timer DelaySec:~p Time:~p ~n", [DelaySec, utime:longunixtime()]) end ),
    ok.

%% 测试带参数
test_timer_with_args(#timer{delay_sec = DelaySec}, Clock) ->
    spawn( fun() -> timer:sleep(DelaySec), ?INFO("test_timer_with_args DelaySec:~p Clock:~p Time:~p ~n", [DelaySec, Clock, utime:longunixtime()]) end ),
    ok.

test_timer2(DelaySec) ->
    spawn( fun() -> timer:sleep(DelaySec), ?INFO("test_timer2 DelaySec:~p Time:~p ~n", [DelaySec, utime:longunixtime()]) end ),
    ok.
