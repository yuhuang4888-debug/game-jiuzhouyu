%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_war_call
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-06
%% @Description:
%%-----------------------------------------------------------------------------
-module(mod_guild_war_call).

-include("guild_war.hrl").
-include("common.hrl").

-export([handle_event/4]).

handle_event({call, From}, 'act_status', _StateName, State) ->
    #status_guild_war{status = ActStatus} = State,
    {keep_state, State, [{reply, From, ActStatus}]};

handle_event({call, From}, 'get_all_guild_ids', _StateName, State) ->
    #status_guild_war{index_map = IndexMap} = State,
    GuildIds = maps:keys(IndexMap),
    % ?ERR("All GuildIds In Division:~p", [GuildIds]),
    {keep_state, State, [{reply, From, GuildIds}]};

handle_event({call, From}, {'is_dominator_guild', GuildId}, _StateName, State) ->
    #status_guild_war{status_dominator = StatusDominator} = State,
    Bool = StatusDominator#status_dominator.guild_id == GuildId,
    {keep_state, State, [{reply, From, Bool}]};

handle_event({call, From}, {'get_dominator_info'}, _StateName, State) ->
    #status_guild_war{status_dominator = StatusDominator} = State,
    #status_dominator{guild_id = GuildId, chief_id = ChiefId, guild_name = GuildName} = StatusDominator,
    {keep_state, State, [{reply, From, {GuildId, GuildName, ChiefId}}]};

%% 清理公会争霸确认期的信息,只有在关闭期才有效
handle_event({call, From}, {'clear_gwar_confirm_info'}, close, State) ->
    F = fun() ->
        %% 删除D赛区的信息
        db:execute(io_lib:format(<<"delete from guild_war_division where division = ~p">>, [?DIVISION_TYPE_D])),
        %% 赛区确认信息状态重置
        KeyId = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_COMFIRM_STATUS),
        db:execute(io_lib:format(?sql_update_global_key_val, [KeyId, "0"])),
        ok
    end,
    case catch db:transaction(F) of
        ok ->
            #status_guild_war{division_map = DivisionMap} = State,
            NewDivisionMap = maps:put(?DIVISION_TYPE_D, [], DivisionMap),
            %% 更新索引Map
            F2 = fun(T, Acc) ->
                case T of
                    {TDivision, TGuildL} ->
                        TL = [{TGuildId, TDivision} || #status_gwar_guild{guild_id = TGuildId} <- TGuildL],
                        TL ++ Acc;
                    _ -> Acc
                end
            end,
            NewIndexList = lists:foldl(F2, [], maps:to_list(NewDivisionMap)),
            NewIndexMap = maps:from_list(NewIndexList),

            %% 同步赛区信息到公会进程
            mod_guild:update_guild_division(NewIndexMap),

            NewState = State#status_guild_war{
                index_map = NewIndexMap,
                division_map = NewDivisionMap
            },

            {keep_state, NewState, [{reply, From, ok}]};
        _Err ->
            ?ERR("err:~p", [_Err]),
            {keep_state, State, [{reply, From, sql_err}]}
    end;

handle_event(_Type, _Msg, _StateName, State) ->
    ?ERR("no match :~p~n", [[ _Msg, _StateName]]),
    {keep_state, State}.