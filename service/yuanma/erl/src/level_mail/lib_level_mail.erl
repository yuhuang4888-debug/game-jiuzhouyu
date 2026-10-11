%%%--------------------------------------
%%% @Module  : 
%%% @Author  : 
%%% @Created : 
%%% @Description:  等级邮件
%%%--------------------------------------
-module(lib_level_mail).
-export([

    ]).
-compile(export_all).
-include("server.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("level_mail.hrl").
-include("figure.hrl").
%% 
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(PS, player_status) ->
    #player_status{id = RoleId, source = Source, figure = #figure{lv = Lv}} = PS,
    SourceNo = get_source_no(Source),
    case data_level_mail:get_reward(SourceNo, Lv) of 
    	[] -> {ok, PS};
    	RewardList ->
            %?PRINT("EVENT_LV_UP RewardList : ~p~n", [RewardList]),
    		Title = data_level_mail:get_title(SourceNo, Lv),
    		Content = data_level_mail:get_content(SourceNo, Lv),
    		lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
            {ok, PS}
    end;
    
handle_event(PS, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, PS}.

get_source_no(Source) ->
	SourceList = data_level_mail:get_all_source(),
	get_source_no(SourceList, list_to_atom(util:make_sure_list(Source)), ?DEFAULT_SOURCE_NO).

get_source_no([], _Source, DefaultNo) -> DefaultNo;
get_source_no([{SourceNo, List}|SourceList], Source, DefaultNo) ->
	case lists:member(Source, List) of 
		true -> SourceNo;
		_ -> get_source_no(SourceList, Source, DefaultNo)
	end.


