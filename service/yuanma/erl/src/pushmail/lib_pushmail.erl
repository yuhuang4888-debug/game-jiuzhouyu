%%%--------------------------------------
%%% @Module  : lib_pushmail
%%% @Author  : xiaoxiang
%%% @Created : 2017-02-28
%%% @Description:  push_mail
%%%--------------------------------------
-module(lib_pushmail).
-compile(export_all).
-export([

    ]).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("team.hrl").
-include("scene.hrl").
-include("pushmail.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("dungeon.hrl").

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP})  ->
    % ?PRINT("event lv: ~p~n", [lv]),
    NewPlayer = pushmail(Player),
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data})  ->
    % ?PRINT("event dun: ~p~n", [dun]),
    %#{dun_id:=DunId} = DataMap,
    #callback_dungeon_succ{dun_id = DunId} = Data,
    NewPlayer = pushmail_dun(Player, DunId),
    {ok, NewPlayer};

handle_event(Player, #event_callback{}) ->
    {ok, Player}.

login(Player) ->
    #player_status{id = RoleId} = Player,
    List = db_select_his(RoleId),
    PushList = [Id||[Id]<-List],
    NewPlayer = Player#player_status{status_pushmail = #status_pushmail{push_list = PushList}},
    LastPlayer = pushmail(NewPlayer),
    % ?PRINT("=======================:~p~n",[LastPlayer#player_status.status_pushmail#status_pushmail.push_list]),
    LastPlayer.

%% -----------------------------------------util-------------------------------------------------


send_mail(Player,  MailId) ->
    #player_status{id = RoleId} = Player,
    #base_pushmail{title = Title, msg = Msg, accessory = Access} = data_pushmail:get_pushmail_config(MailId),
    lib_mail_api:send_sys_mail([RoleId], Title, Msg, Access).

pushmail_dun(Player, DunId) ->
    IdList = data_pushmail:get_id_list(),
    F = fun(Id, TempPlayer) ->
        #base_pushmail{dun = Dun} = data_pushmail:get_pushmail_config(Id),
        case Dun == DunId of
            true ->
                #player_status{id = RoleId, status_pushmail = #status_pushmail{push_list = PushList}} = TempPlayer,
                CheckList = [already, time, open_day, marge_day, lv, career, sex, other],
                case check(TempPlayer, Id, CheckList) of
                    true ->
                        %% 发邮件
                        db_replace_his(RoleId, Id),
                        NewPushList = [Id|PushList],
                        NewPlayer = TempPlayer#player_status{status_pushmail = #status_pushmail{push_list = NewPushList}},
                        send_mail(NewPlayer, Id);
                    false ->
                        NewPlayer = TempPlayer
                end,
                NewPlayer;
            _ ->
                TempPlayer
        end
    end,
    NewPlayer = lists:foldl(F, Player, IdList),
    NewPlayer.

pushmail_task(Player, TaskId) ->
    IdList = data_pushmail:get_id_list(),
    F = fun(Id, TempPlayer) ->
        #base_pushmail{other = Other} = data_pushmail:get_pushmail_config(Id),
        case lists:member({task_id, TaskId}, Other) of
            true ->
                #player_status{id = RoleId, status_pushmail = #status_pushmail{push_list = PushList}} = TempPlayer,
                CheckList = [already, time, open_day, marge_day, lv, career, sex, other],
                case check(TempPlayer, Id, CheckList) of
                    true ->
                        %% 发邮件
                        db_replace_his(RoleId, Id),
                        NewPushList = [Id|PushList],
                        NewPlayer = TempPlayer#player_status{status_pushmail = #status_pushmail{push_list = NewPushList}},
                        send_mail(NewPlayer, Id);
                    false ->
                        NewPlayer = TempPlayer
                end,
                NewPlayer;
            _ ->
                TempPlayer
        end
    end,
    NewPlayer = lists:foldl(F, Player, IdList),
    NewPlayer.


pushmail(Player) ->
    IdList = data_pushmail:get_id_list(),
    NewPlayer = do_pushmail(Player, IdList),
    NewPlayer.

do_pushmail(Player, []) -> Player;
do_pushmail(Player, [H|T]) ->
    #player_status{id = RoleId, status_pushmail = #status_pushmail{push_list = PushList}} = Player,
    CheckList = [already, time, open_day, marge_day, lv, career, sex, other],
    case check(Player, H, CheckList) of
        true ->
            %% 发邮件
            db_replace_his(RoleId, H),
            NewPushList = [H|PushList],
            NewPlayer = Player#player_status{status_pushmail = #status_pushmail{push_list = NewPushList}},
            send_mail(NewPlayer, H);
        false ->
            NewPlayer = Player
    end,
    do_pushmail(NewPlayer, T).


check(_Player, _MailId, []) -> true;
check(Player, MailId, [H|T]) ->
    case do_check(Player, MailId, H) of
        true ->
            check(Player, MailId, T);
        false ->
            % ?PRINT("false H:~p ~n", [H]),
            false
    end.

do_check(Player, MailId, already) ->
    #player_status{status_pushmail = #status_pushmail{push_list = PushList}} = Player,
    not lists:member(MailId, PushList);

do_check(_Player, MailId, time) ->
    #base_pushmail{time = Time} = data_pushmail:get_pushmail_config(MailId),
    Now = utime:unixtime(),
    case Time of
        [{Y, M, D}, {H, Min}] ->
            ConfigTime = utime:unixtime({{Y, M, D}, {H, Min, 59}}),
            ConfigTime=<Now;
        [] ->
            true;
        _ ->
            false
    end;

do_check(_Player, MailId, open_day) ->
    #base_pushmail{open_day = OpenDay} = data_pushmail:get_pushmail_config(MailId),
    Now = util:get_open_day(),
    case OpenDay of
        OpenDay when is_integer(OpenDay) ->
            Now>=OpenDay;
        _ ->
            false
    end;

do_check(_Player, MailId, marge_day) ->
    #base_pushmail{merge_day = MergeDay} = data_pushmail:get_pushmail_config(MailId),
    Now = util:get_open_day(),
    case MergeDay of
        MergeDay when is_integer(MergeDay) ->
            Now>=MergeDay;
        _ ->
            false
    end;

do_check(Player, MailId, lv) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    #base_pushmail{lv = ConfigLv} = data_pushmail:get_pushmail_config(MailId),
    case ConfigLv of
        ConfigLv when is_integer(ConfigLv) ->
            Lv>=ConfigLv;
        _ ->
            false
    end;

do_check(Player, MailId, career) ->
    #player_status{figure = #figure{career = Career}} = Player,
    #base_pushmail{career = ConfigCareer} = data_pushmail:get_pushmail_config(MailId),
    case ConfigCareer of
        [] ->
            true;
        ConfigCareer when is_list(ConfigCareer) ->
            lists:member(Career, ConfigCareer);
        _ ->
            false
    end;

do_check(Player, MailId, sex) ->
    #player_status{figure = #figure{sex = Sex}} = Player,
    #base_pushmail{sex = ConfigSex} = data_pushmail:get_pushmail_config(MailId),
    case ConfigSex of
        [] ->
            true;
        ConfigSex when is_list(ConfigSex) ->
            lists:member(Sex, ConfigSex);
        _ ->
            false
    end;

do_check(Player, MailId, other) ->
    #base_pushmail{other = Other} = data_pushmail:get_pushmail_config(MailId),
    do_check_other(Player, MailId, Other);

do_check(_Player, _MailId, _R) ->
    ?PRINT("false _R:~p ~n", [_R]),
    false.

do_check_other(_Player, _MailId, []) -> true;
do_check_other(Player, MailId, [H|T]) ->
    case do_check_other_help(Player, MailId, H) of
        true ->
            do_check_other(Player, MailId, T);
        _ ->
            % ?PRINT("false H:~p ~n", [H]),
            false
    end.

do_check_other_help(_Player, _MailId, {end_open_day, EndOpenDay}) ->
    Now = util:get_open_day(),
    case EndOpenDay of
        EndOpenDay when is_integer(EndOpenDay) ->
            Now=<EndOpenDay;
        _ ->
            false
    end;

do_check_other_help(_Player, _MailId, {end_time, EndTime}) ->
    Now = utime:unixtime(),
    case EndTime of
        [{Y, M, D}, {H, Min}] ->
            ConfigTime = utime:unixtime({{Y, M, D}, {H, Min, 59}}),
            Now=<ConfigTime;
        _ ->
            false
    end;
do_check_other_help(_Player, _MailId, {end_merge_day, EndMergeDay}) ->
    Now = util:get_open_day(),
    case EndMergeDay of
        EndMergeDay when is_integer(EndMergeDay) ->
            Now=<EndMergeDay;
        _ ->
            false
    end;
do_check_other_help(Player, _MailId, {task_id, TaskId}) ->
    #player_status{tid = Tid} = Player,
    case catch mod_task:is_finish_task_id(Tid, TaskId) of
        true -> true;
        _ -> false
    end;
do_check_other_help(_Player, _MailId, _R) ->
    ?PRINT("false _R:~p ~n", [_R]),
    false.
%% --------------------------------------sql----------------------------------------------------------
db_select_his(RoleId) ->
    Sql = io_lib:format(?sql_select_his, [RoleId]),
    db:get_all(Sql).

db_replace_his(RoleId, MailId) ->
    Sql = io_lib:format(?sql_replace_his, [RoleId, MailId]),
    db:execute(Sql).