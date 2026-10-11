%%% -------------------------------------------------------------------
%%% @doc        lib_rush_treasure_api                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-25 16:30               
%%% @deprecated 
%%% -------------------------------------------------------------------

-module(lib_rush_treasure_api).

-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("common.hrl").

%% API
-export([act_open/0, act_end/2]).

%% 冲榜夺宝活动开始初始化摇钱树(定制活动进程)
act_open() ->
    OnlineRoles = lib_online:get_online_ids(),
    spawn(fun() ->
        Fun = fun(RoleId) ->
            timer:sleep(20),
            % ?MYLOG("lwcrank_start","RoleId:~p~n",[{RoleId}]),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_bonus_tree, init_online_player, [])
              end,
        lists:foreach(Fun, OnlineRoles)
          end).

%% 冲榜活动结束
act_end(Type, SubType) ->
    % ?MYLOG("lwcrank_end","Type, SubType:~p~n",[{Type, SubType}]),
    OnlineRoles = lib_online:get_online_ids(),
    case lib_rush_treasure_sql:db_select_rush_treasure_role_by_type(Type, SubType) of
        [] -> skip;
        DBRaceRoleList ->
            % ?MYLOG("lwcrank_end","DBRaceRoleList:~p~n",[DBRaceRoleList]),
            spawn(fun() ->
                Fun = fun(DBRaceRole) ->
                    [RoleId, Type, SubType, _Score, _TodayScore, _Times, _RList, _SList, _Time] = DBRaceRole,
                    timer:sleep(20),
                    ?IF(lists:member(RoleId, OnlineRoles),
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_rush_treasure_player, send_stage_reward, [DBRaceRole]),
                        lib_rush_treasure_player:send_stage_reward(DBRaceRole))
                      end,
                lists:foreach(Fun, DBRaceRoleList),
                ServerId = config:get_server_id(),
                % ?MYLOG("lwcrank_end","ServerId:~p~n",[ServerId]),
                %% 发送榜单奖励
                mod_rush_treasure_kf:cast_center([{act_end, Type, SubType, ServerId}]),
                %% 删除记录
                mod_custom_act_record:cast({remove_log, Type, SubType}),
                F = fun() ->
                    %% 删除玩家数据
                    lib_rush_treasure_sql:db_rush_treasure_delete(Type, SubType),
                    %% 删除摇钱树数据
                    lib_bonus_tree:delete_informations(Type, SubType)
                    end,
                case catch db:transaction(F) of
                    ok -> ok;
                    Error -> ?ERR("cost_money_offline:~p~n", [Error]), error
                end
                  end)
    end.

