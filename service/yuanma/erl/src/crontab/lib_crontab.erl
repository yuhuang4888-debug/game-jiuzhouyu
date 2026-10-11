%%%----------------------------------------------------------------------
%%%
%%% wg @copyright 2009
%%%
%%% @author litao cheng <litaocheng@gmail.com>
%%% @doc the crontab parse module (simlar with *unix crontab, please read
%%%      crontab.
%%%
%%% Modified: 21/10/2016 by hekai <1472524632@qq.com>
%%% Note: 完善对CRONTAB(5)命令格式的支持，详见http://crontab.org/
%%%----------------------------------------------------------------------
-module(lib_crontab).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("crontab.hrl").
-include("common.hrl").

%% --------------------------------------------------------------------
%% Exported Functions
%% --------------------------------------------------------------------
-export([
    parse/0,
    get_cron_files/0,
    check_entrys/1,
    run_task/1
]).

%% --------------------------------------------------------------------
%% API Functions
%% --------------------------------------------------------------------
%% @doc parse the crontab config file
parse() ->
    case config:get_cls_type() of
        1 ->
            parse_file([?CRON_FILE_CLS]);
        _ ->
            parse_file([?CRON_FILE])
    end.

get_cron_files()->
    case config:get_cls_type() of
        1 ->
            [?CRON_FILE_CLS];
        _ ->
            [?CRON_FILE]
    end.

%% @doc parse the crontab config file
parse_file(_Files)  ->
    % Fun = fun(File, Acc) ->
    %     case file:consult(File) of
    %         {error, enoent} = Error ->
    %             ?ERR("crontab file ~p not exist error ~p ~n", [File, Error]),
    %             Acc;
    %         {error, R} = Error ->
    %             ?ERR("crontab file error: ~p error ~p ~n", [file:format_error(R),Error]),
    %             Acc;
    %         {ok, CronTab} ->
    %             Acc ++ CronTab
    %     end
    % end,
    % parse_entrys(lists:foldl(Fun, [], Files)).

    List = case config:get_cls_type() of
        1 ->
            data_crontab_cls:get_config();
        _ ->
            data_crontab:get_config()
    end,
    parse_entrys(List).

%% check the cron entrys
check_entrys(Entrys) ->
    {Now, Week} = get_time(),
    Fun =  fun(Entry) ->
        case can_run(Entry, Now, Week) of
            true ->
                run_task(Entry#cron_entry.mfa);
            false ->
                ok
        end
    end,
    lists:foreach(Fun,Entrys).

get_time() ->
    {utime:localtime(), utime:day_of_week()}.

%% --------------------------------------------------------------------
%% Local Functions
%% --------------------------------------------------------------------
%% parse all the entrys
parse_entrys(CronTab) ->
    Entrys =
        lists:foldl(
            fun(Entry, Acc) ->
                case catch parse_entry(Entry) of
                    {ok, CronEntry} ->
                        [CronEntry | Acc];
                    {error, R} ->
                        ?ERR("the line :~p error:~p", [Entry, R]),
                        Acc
                end
            end, [], CronTab),
    {ok, Entrys}.

%% parse the single entry
parse_entry({{M, H, Dom, Mon, Dow}, {Mod, F, A} = MFA}) when is_atom(Mod), is_atom(F), is_list(A) ->
    Cron =  #cron_entry{
            m = parse_field(M, 0, 59, {error, emin}),
            h = parse_field(H, 0, 23, {error, ehour}),
            dom = parse_field(Dom, 1, 31, {error, edom}),
            mon = parse_field(Mon, 1, 12, {error, emon}),
            dow = parse_field(Dow, 1, 7, {error, edow}),
            mfa = MFA
        },
    {ok, Cron};
parse_entry(_) ->
    {error, eformat}.

%% parset the fileld
parse_field(F, Min, Max, Error) ->
    try parse_field(F, Min, Max) of
        {?CRON_ANY} ->
            #cron_field{type = ?CRON_RANGE, value = {Min, Max, 1}};
        {?CRON_NUM, N} ->
            #cron_field{type = ?CRON_NUM, value = N};
        {?CRON_RANGE, {_First, _Last, _Step} = Range} ->
            #cron_field{type = ?CRON_RANGE, value = Range};
        {?CRON_LIST, List} ->
            #cron_field{type = ?CRON_LIST, value = List};
        _ ->
            throw(Error)
    catch _:_ ->
        throw(Error)
    end.

parse_field("*", _Min, _Max) ->
    {?CRON_ANY};
parse_field(F, Min, Max) when F >= Min, F =< Max ->
    {?CRON_NUM, F};
parse_field(F = [_ | _], Min, Max) when is_list(F) ->
    case string:tokens(F, ",") of
        [Single] -> % is range
            case parse_range(Single) of
                {First, Last, _Step} = Range when First >= Min, Last =< Max ->
                    {?CRON_RANGE, Range};
                {"*", Step} ->
                    {?CRON_RANGE, {Min, Max, Step}}
            end;
        [_ | _] = Multi -> % is list
            {?CRON_LIST, lists:map(
                fun(E) ->
                    parse_field(E, Min, Max)
                end,
                Multi)
            }
    end.

%% parse the range string: "2-5/2"|"2-5"|"*/1"
parse_range(Str) ->
    {RangeStr, Step} =
        case string:tokens(Str, "/") of
            [Range] ->
                {Range, 1};
            [Range, StepStr] ->
                {Range, list_to_integer(StepStr)}
        end,
    case string:tokens(RangeStr, "-") of
        [First, Last] ->
            {list_to_integer(First), list_to_integer(Last), Step};
        _ ->
            {RangeStr, Step}
    end.

can_run(Entry, {{_, CurMon, CurDay}, {CurH, CurM, _}}, Week) ->
    #cron_entry{m = M, h = H, dom = Dom, mon = Mon, dow = Dow} = Entry,
    field_ok(M, CurM) andalso
        field_ok(H, CurH) andalso
        field_ok(Dom, CurDay) andalso
        field_ok(Dow, Week) andalso
        field_ok(Mon, CurMon).

%% check if the field is ok
field_ok(#cron_field{type = ?CRON_NUM, value = Val}, Cur) ->
    Val =:= Cur;
field_ok(#cron_field{type = ?CRON_RANGE, value = {First, Last, Step}}, Cur) ->
    range_ok(Cur, First, Last, Step);
field_ok(#cron_field{type = ?CRON_LIST, value = List}, Cur) ->
    lists:any(
        fun(FInList) ->
            field_ok(FInList, Cur)
        end,
        List).

%% check if the value in the range
range_ok(Val, First, Last, Step) ->
    range_ok1(Val, First, Last, Step).

range_ok1(Val, Val, _Last, _Step) ->
    true;
range_ok1(_Val, Cur, Last, _Step) when Cur >= Last ->
    false;
range_ok1(Val, Cur, Last, Step) ->
    range_ok1(Val, Cur + Step, Last, Step).

%% run the task
run_task({M, F, A} = Task) ->
    proc_lib:spawn(
        fun() ->
            case catch apply(M, F, A) of
                {'EXIT', R} ->
                    ?ERR("cron task ~p error: ~p", [Task, R]),
                    ok;
                _ ->
                    ok
            end
        end
    );
run_task(Task) ->
    ?ERR("unkown task:~p", [Task]),
    ok.

%% --------------------------------------------------------------------
%% Test
%% --------------------------------------------------------------------

% run(Num) ->
%     do_batch(1, Num, fun m/0, {10, 100}).

% m() ->
%     Res = get_modified("crontab.config"),
%     io:format("test:m()~p~n", [Res]).

% get_modified(Files) ->
%     filelib:last_modified(Files).

% do_batch(Max, Max, _F, {_SleepNum, _SleepTime}) -> ok;
% do_batch(Index, Max, F, {SleepNum, SleepTime}) ->
%     case Index rem SleepNum of
%         0 -> timer:sleep(SleepTime);        
%         _ -> skip
%     end,
%     NewIndex = Index + 1,
%     F(),
%     do_batch(NewIndex, Max, F, {SleepNum, SleepTime}).