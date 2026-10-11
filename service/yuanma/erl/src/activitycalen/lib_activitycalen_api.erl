%%--------------------------------------
%%% @Module  : lib_activitycalen_api
%%% @Author  : xiaoxiang
%%% @Created : 2017-03-01
%%% @Description:  lib_activitycalen_api
%%%--------------------------------------
-module(lib_activitycalen_api).
-export([
        success_end_activity/2          %% 活动结束,用于记录活动当前状态，和活动首次开启记录
        , success_end_activity/1        %% 活动结束,用于记录活动当前状态，和活动首次开启记录
        , success_start_activity/2      %% 活动开启,用于记录活动当前状态，和活动首次开启记录
        , success_start_activity/1      %% 活动开启,用于记录活动当前状态，和活动首次开启记录
        % , ps_success_end_activity/3     %% 玩家完成活动用于记录玩家活跃度   ps
        % , ps_success_end_activity/2     %% 玩家完成活动用于记录玩家活跃度   ps
        , get_time/2                    %% 查询活动的当日的活动时间
        , get_time/1                    %% 查询活动的当日的活动时间
        , check_ac_start/1              %% 检查活动是否符合开启条件
        , check_ac_start/2              %% 检查活动是否符合开启条件
        , check_ac_start/3              %% 检测某天活动是否开启
        , check_ac_start/4              %% 检测某天玩家是否能参加该活动
        , role_success_end_activity/3   %% 玩家完成活动用于记录玩家活跃度   
        , role_success_end_activity/4   %% 玩家完成活动用于记录玩家活跃度  

    ]).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("activitycalen.hrl").
-include("predefine.hrl").
-include("common.hrl").


%%%-------------------------
% 活动开启和活动结束用于记录活动当前状态，和活动首次开启记录
%%%---------------------------
%% return ok
%% 活动结束 定时活动调用
success_end_activity(Module) ->
    success_end_activity(Module, 0).
success_end_activity(Module, ModuleSub) ->
	%% 推送协议
	lib_act_sign_up:act_end(Module, ModuleSub),
    %% 活动托管
    mod_activity_onhook:act_end(Module, ModuleSub),
    mod_activitycalen:success_end_activity(Module, ModuleSub).

%% return ok
%% 活动开启 定时活动调用
success_start_activity(Module) ->
    success_start_activity(Module, 0).
success_start_activity(Module, ModuleSub) ->
	%% 推送协议
	lib_act_sign_up:update_status(),
    %% 活动托管
    mod_activity_onhook:act_start(Module, ModuleSub),
    mod_activitycalen:success_start_activity(Module, ModuleSub).


%% -------------------------------------
% 玩家完成活动用于记录玩家活跃度
%% -------------------------------------
%% 玩家完成活动


%% -------------------------------------
% 玩家完成活动用于记录玩家活跃度
%% -------------------------------------
%% role_id return ok 
%% ps return #player_status{}
%% 玩家完成活动
role_success_end_activity(RoleId, Module, ModuleSub) when is_integer(RoleId )->
    role_success_end_activity(RoleId, Module, ModuleSub, 1);

role_success_end_activity(Player, Module, ModuleSub) when is_record(Player, player_status)->
    role_success_end_activity(Player, Module, ModuleSub, 1).



%% Count 完成次数
role_success_end_activity(RoleId, Module, ModuleSub, Count) when is_integer(RoleId) ->
    case misc:is_process_alive(misc:get_player_process(RoleId)) of
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_activitycalen, role_success_end_activity, [Module, ModuleSub, Count]);
        _ ->    
            lib_activitycalen:role_success_end_activity_offline(RoleId, Module, ModuleSub, Count)
    end,
    ok;
role_success_end_activity(Player, Module, ModuleSub, Count) when is_record(Player, player_status) ->
    lib_activitycalen:role_success_end_activity(Player, Module, ModuleSub, Count).
%% ----------------------------------------------
%% 查询活动的当日的活动时间
%%----------------------------------------------
% return [{start_hour,start_min}|...] || []
get_time(Module) ->
    get_time(Module, 0).
get_time(Module, ModuleSub) ->
    lib_activitycalen:get_time(Module, ModuleSub).

%% ----------------------------------------------
%% 检查活动是否符合开启条件
%%----------------------------------------------
% return true|false
check_ac_start(Module) ->
    check_ac_start(Module, 0).
check_ac_start(Module, ModuleSub) ->
    lib_activitycalen:check_ac_start(Module, ModuleSub).


%% 查询活动当天是否开启是否开启
%%　DataTime:{{Year, Month, Day},{Hour, Min, Sec}}
%% return [ac_sub|...]  | []
check_ac_start(Module, ModuleSub, DataTime) ->
    lib_activitycalen_check:check_ac_start(Module, ModuleSub, DataTime).

check_ac_start(Player, Module, ModuleSub, DataTime) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    AcSubList = lib_activitycalen_check:check_ac_start(Module, ModuleSub, DataTime),
    List = [1||AcSub<-AcSubList, case data_activitycalen:get_ac(Module, ModuleSub, AcSub) of
                            #base_ac{start_lv = StartLv, end_lv = EndLv} when StartLv=<Lv andalso Lv=<EndLv ->
                                true;
                            _ ->
                                false
                        end],

    lists:member(1, List).


%% 获取首个开启中的活动
get_first_enabled_ac_id(Module, ModuleSub) ->
    IdList = data_activitycalen:get_ac_sub(Module, ModuleSub),
    CheckList = [time, time_region, week, month, open_day, merge_day],
    get_first_enabled_ac_id(Module, ModuleSub, IdList, CheckList).

get_first_enabled_ac_id(Module, ModuleSub, [Id|T], CheckList) ->
    case lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, Id), CheckList) of
        true ->
            {ok, Id};
        _ ->
            get_first_enabled_ac_id(Module, ModuleSub, T, CheckList)
    end;
get_first_enabled_ac_id(_, _, [], _) -> error.

is_enabled(Module, ModuleSub, ActId) ->
    CheckList = [time, time_region, week, month, open_day, merge_day],
    lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, ActId), CheckList).


is_today_open(Module, ModuleSub, ActId) ->
	CheckList = [week, month, open_day, merge_day],
	lib_activitycalen_util:do_check_ac_sub(data_activitycalen:get_ac(Module, ModuleSub, ActId), CheckList).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取今天开启的限时活动，
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_today_act() ->
    Act = data_activitycalen:get_ac_list(),
    F = fun({Module, ModuleSub, ActId}, AccList) ->
	    case data_activitycalen:get_ac(Module, ModuleSub, ActId) of
		    #base_ac{ac_type = 2} ->  %% 限时活动
			    case is_today_open(Module, ModuleSub, ActId) of
				    true ->
					    [{Module, ModuleSub, ActId} | AccList];
				    _ ->
					    AccList
			    end;
		    _ ->
			    AccList
	    end
        end,
    lists:foldl(F, [], Act).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取今天开启可以预约的限制限时活动，
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_today_sign_act() ->
	Act = data_activitycalen:get_ac_list(),
	F = fun({Module, ModuleSub, ActId}, AccList) ->
		case data_activitycalen:get_ac(Module, ModuleSub, ActId) of
			#base_ac{ac_type = 2, sign_up_reward = Reward} when Reward =/= [] ->  %% 限时活动
				case is_today_open(Module, ModuleSub, ActId) of
					true ->
						[{Module, ModuleSub, ActId} | AccList];
					_ ->
						AccList
				end;
			_ ->
				AccList
		end
	    end,
	lists:foldl(F, [], Act).


%% -----------------------------------------------------------------
%% @desc     功能描述   获取今天开启的活动
%% @param    参数
%% @return   返回值     false | Id
%% @history  修改历史
%% -----------------------------------------------------------------
get_today_act(Module, ModuleSub) ->
	Ids = data_activitycalen:get_ac_sub(Module, ModuleSub),
	F = fun(ActId, AccActId) ->
		case data_activitycalen:get_ac(Module, ModuleSub, ActId) of
			#base_ac{ac_type = 2} ->  %% 限时活动
				case is_today_open(Module, ModuleSub, ActId) of
					true ->
						ActId;
					_ ->
						AccActId
				end;
			_ ->
				AccActId
		end
	    end,
	lists:foldl(F, false, Ids).


















