%% ---------------------------------------------------------------------------
%% @doc lib_advance_fun

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/9/23
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_advance_fun).

%% API
-compile([export_all]).
-include("common.hrl").
-include("activitycalen.hrl").
-include("advance_fun.hrl").

%%玩法邮件通知
inform_by_mail() ->
    % 获取需要邮件预告的活动
    AcList = data_advance_fun:get_advance_list(),
    {Date, _} = Today = utime:get_logic_time(),
    Tomorrow = utime:get_before_day(Date, 1, 1),
    ToDayList = get_today_ac(AcList, Today, []),
    TomorrowList = get_tomorrow_ac(AcList, {Tomorrow, {0, 0, 0}}, []),
    send_mail(TomorrowList ++ ToDayList).


%========================== private func ======================================
%% 获取需要今天提示且，今天天开放的活动
%% @return [{Module,ModuleSub,SureMail,SubAc} | ...] | []
get_today_ac([], _DataTime, TodayAcList) -> TodayAcList;
get_today_ac([{Module,ModuleSub, ?TODAY_MAIL}|OtherAc], DataTime, TodayAcList) ->
    case lib_activitycalen_api:check_ac_start(Module, ModuleSub, DataTime) of
        [] -> get_today_ac(OtherAc, DataTime, TodayAcList);
        SubList ->
            NewAc = [{Module,ModuleSub,?TODAY_MAIL,SubAc} || SubAc <- SubList],
            get_today_ac(OtherAc, DataTime, NewAc ++ TodayAcList)
    end;
get_today_ac([{_,_,_}|OtherAc], DataTime, TodayAcList) ->  get_today_ac(OtherAc, DataTime, TodayAcList).

%% 获取需要提醒的明天活动且明天开放的活动
%% @return [{Module,ModuleSub,SureMail,SubAc} | ...] | []
get_tomorrow_ac([], _DataTime, TomorrowAcList) -> TomorrowAcList;
get_tomorrow_ac([{Module,ModuleSub, ?TOMORROW_MAIL}|OtherAc], DataTime, TomorrowAcList) ->
    case lib_activitycalen_api:check_ac_start(Module, ModuleSub, DataTime) of
        [] -> get_tomorrow_ac(OtherAc, DataTime, TomorrowAcList);
        SubList ->
            NewAc = [{Module,ModuleSub,?TOMORROW_MAIL,SubAc} || SubAc <- SubList],
            get_tomorrow_ac(OtherAc, DataTime, NewAc ++ TomorrowAcList)
    end;
get_tomorrow_ac([{_,_,_}|OtherAc], DataTime, TomorrowAcList) -> get_tomorrow_ac(OtherAc, DataTime, TomorrowAcList).

%% 发送邮件
%% @params Type ?TODAY_MAIL今日邮件  ?TOMORROW_MAIL明天邮件
send_mail([]) -> ok;
send_mail([This|Other]) ->
    {Module,ModuleSub,SureMail,SubAc} = This,
    case data_activitycalen:get_ac(Module,ModuleSub, SubAc) of
        [] -> ok;
        #base_ac{start_lv = StartLv, open_day = OpenDay} ->
            Flag = is_in_open_day(OpenDay),
            if
                Flag =/= true -> skip;
                true ->
                    AdvanceFun = data_advance_fun:get_advance_ac(Module,ModuleSub,SureMail),
                    #base_advance_fun{mail_title = Title, mail_content = Content, sure_mail = SureMail} = AdvanceFun,
                    ?PRINT("~n~n~n send_mail sure_mail:~p  ~n~n~n ", [SureMail]),
                    lib_mail_api:send_sys_mail_to_all_on_game(Title, Content, [], [], StartLv)
            end

    end,
    send_mail(Other).

is_in_open_day(OpenDay) ->
    case OpenDay of
        [] -> true;
        _ -> calcu_openday(OpenDay)
    end.

calcu_openday([]) -> false;
calcu_openday([{Start, End}| OtherCon]) ->
    CurrentDay = util:get_open_day(),
    if
        CurrentDay >= Start andalso End >= CurrentDay ->
            true;
        true -> calcu_openday(OtherCon)
    end.