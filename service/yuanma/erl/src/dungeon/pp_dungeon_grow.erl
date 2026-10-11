%% ---------------------------------------------------------------------------
%% @doc pp_dungeon_grow.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-03-08
%% @deprecated 成长试炼协议处理
%% ---------------------------------------------------------------------------
-module(pp_dungeon_grow).
-export([handle/3]).

-include("server.hrl").
-include("figure.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("common.hrl").

%% 成长试炼列表
handle(61101, Player, []) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, sid = Sid} = Player,
    DunIdList = data_dungeon_grow:get_dungeon_grow_dun_id_list(),
    CountList = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunIdList),
    F = fun(DunId, List) ->
        case data_dungeon:get(DunId) of
            [] -> List;
            #dungeon{condition = Condition} ->
                % 是否挑战过
                case lists:keyfind(DunId, 1, CountList) of
                    {DunId, Count} when Count > 0 -> [{DunId, 1}|List];
                    _ ->
                        % 等级满不满足
                        case lists:keyfind(lv, 1, Condition) of
                            {lv, NeedLv} when Lv < NeedLv -> Bool = false;
                            _ -> Bool = true
                        end,
                        % 是否完成前置副本
                        case lists:keyfind(finish_dun_id, 1, Condition) of
                            {finish_dun_id, FinishDunId} ->
                                case lists:keyfind(FinishDunId, 1, CountList) of
                                    {FinishDunId, 0} -> Bool2 = false;
                                    _ -> Bool2 = true
                                end;
                            _ -> 
                                Bool2 = true
                        end,
                        if
                            Bool == false -> [{DunId, 3}|List];
                            Bool2 == false -> [{DunId, 4}|List];
                            true -> [{DunId, 2}|List]
                        end
                end
        end
    end,
    List = lists:foldl(F, [], DunIdList),
    {ok, BinData} = pt_611:write(61101, [List]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.