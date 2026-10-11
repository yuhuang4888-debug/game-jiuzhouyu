%%-----------------------------------------------------------------------------
%% @Module  :       mod_red_envelopes
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-20
%% @Description:    红包进程(通用框架)
%%-----------------------------------------------------------------------------
-module(mod_red_envelopes).

-include("red_envelopes.hrl").
-include("common.hrl").
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile([export_all]).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    lib_red_envelopes_mod:init(),
    {ok, []}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState}->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState}->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%% 发送红包列表
send_red_envelopes_list(OwnershipType, OwnershipId, RoleId) ->
    gen_server:cast(?PID, {'send_red_envelopes_list', OwnershipType, OwnershipId, RoleId}).

%% 发送红包拆分界面信息
send_split_num_info(OwnershipType, OwnershipId, OwnershipLv, RoleId, Classify, Extra) ->
    gen_server:cast(?PID, {'send_split_num_info', OwnershipType, OwnershipId, OwnershipLv, RoleId, Classify, Extra}).

%% 发送红包
send_red_envelopes(OwnershipType, OwnershipId, OwnershipLv, RoleId, RedEnvelopesId, SplitNum) ->
    gen_server:cast(?PID, {'send_red_envelopes', OwnershipType, OwnershipId, OwnershipLv, RoleId, RedEnvelopesId, SplitNum}).

%% 使用红包道具发红包
send_red_envelopes_by_gid(RoleId, GoodsId, SplitNum) ->
    gen_server:cast(?PID, {'send_red_envelopes_by_gid', RoleId, GoodsId, SplitNum}).

%% 使用红包物品发红包
send_red_envelopes_by_goods(RedEnvelopes, Args) ->
    gen_server:cast(?PID, {'send_red_envelopes_by_goods', RedEnvelopes, Args}).

%% 增加一个新红包
add_red_envelopes(Args) ->
    gen_server:cast(?PID, {'add_red_envelopes', Args}).

%% 打开红包
open_red_envelopes(OwnershipType, OwnershipId, RoleId, RedEnvelopesId) ->
    gen_server:cast(?PID, {'open_red_envelopes', OwnershipType, OwnershipId, RoleId, RedEnvelopesId}).

%% 发送红包相关红点信息(是否有可领取的红包)
send_red_point_info(OwnershipType, OwnershipId, RoleId) ->
    gen_server:cast(?PID, {'send_red_point_info', OwnershipType, OwnershipId, RoleId}).

%% 加入帮派
join_guild(RoleId, GuildId) ->
    gen_server:cast(?PID, {'join_guild', RoleId, GuildId}).

%% 退出帮派
quit_guild(RoleId, GuildId) ->
    gen_server:cast(?PID, {'quit_guild', RoleId, GuildId}).

%% 解散帮派
disband_guild(GuildId) ->
    gen_server:cast(?PID, {'disband_guild', GuildId}).

%% 清理活动红包
clear_act_red_envelopes() ->
    gen_server:cast(?PID, {'clear_red_envelopes', ?ACT_RED_ENVELOPES}).

%% 日常事务
daily_timer(Delay) ->
    gen_server:cast(?PID, {'daily_timer', Delay}).

do_handle_cast({'send_red_envelopes_list', ?GUILD_RED_ENVELOPES = OwnershipType, OwnershipId, RoleId}, State) ->
    ?PRINT("send_red_envelopes_list ~p~n", [start]),
    RedEnveLopesL = lib_red_envelopes_data:get_red_envelopes_list(OwnershipType, OwnershipId),
    ObtainRecordList = lib_red_envelopes_data:get_obtain_record_list(OwnershipType, OwnershipId),
    PackList = lib_red_envelopes:pack_red_envelopes_list(RoleId, RedEnveLopesL),
    ?PRINT("PackList ~p~n", [PackList]),
    PackRDList = lib_red_envelopes:pack_obtain_record(ObtainRecordList),
    {ok, BinData} = pt_339:write(33901, [PackList, PackRDList]),
    ?PRINT("send_red_envelopes_list ~p~n", [okok]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

% do_handle_cast({'send_red_envelopes_list', ?ACT_RED_ENVELOPES = OwnershipType, OwnershipId, RoleId}, State) ->
%     RedEnveLopesL = lib_red_envelopes_data:get_red_envelopes_list(OwnershipType, OwnershipId),
%     PackList = lib_red_envelopes:pack_red_envelopes_list(RoleId, RedEnveLopesL),
%     {ok, BinData} = pt_331:write(33156, [PackList]),
%     lib_server_send:send_to_uid(RoleId, BinData),
%     {ok, State};

do_handle_cast({'send_split_num_info', OwnershipType, OwnershipId, OwnershipLv, RoleId, Classify, Extra}, State) ->
    lib_red_envelopes_mod:send_split_num_info(OwnershipType, OwnershipId, OwnershipLv, RoleId, Classify, Extra),
    {ok, State};

do_handle_cast({'send_red_envelopes', OwnershipType, OwnershipId, OwnershipLv, RoleId, RedEnvelopesId, SplitNum}, State) ->
    lib_red_envelopes_mod:send_red_envelopes(OwnershipType, OwnershipId, OwnershipLv, RoleId, RedEnvelopesId, SplitNum),
    {ok, State};

do_handle_cast({'send_red_envelopes_by_gid', RoleId, GoodsId, Num}, State) ->
    lib_red_envelopes_mod:send_red_envelopes_by_gid(RoleId, GoodsId, Num),
    {ok, State};

do_handle_cast({'send_red_envelopes_by_goods', RedEnvelopes, Args}, State) ->
    lib_red_envelopes_data:add_obtain_record(RedEnvelopes),
    lib_red_envelopes_mod:add_red_envelopes(Args),
    {ok, State};

do_handle_cast({'add_red_envelopes', Args}, State) ->
    lib_red_envelopes_mod:add_red_envelopes(Args),
    {ok, State};

do_handle_cast({'open_red_envelopes', OwnershipType, OwnershipId, RoleId, RedEnvelopesId}, State) ->
    lib_red_envelopes_mod:open_red_envelopes(OwnershipType, OwnershipId, RoleId, RedEnvelopesId),
    {ok, State};

do_handle_cast({'send_red_point_info', ?ACT_RED_ENVELOPES = OwnershipType, OwnershipId, RoleId}, State) ->
    RedEnveLopesL = lib_red_envelopes_data:get_red_envelopes_list(OwnershipType, OwnershipId),
    NowTime = utime:unixtime(),
    F = fun(RedEnvelopes) ->
        case lib_red_envelopes:is_vaild_red_envelopes(RedEnvelopes, NowTime) of
            true ->
                #red_envelopes{status = Status, recipients_lists = RecipientsList} = RedEnvelopes,
                case Status == ?HAS_SEND of
                    true ->
                        case lists:keyfind(RoleId, #recipients_record.role_id, RecipientsList) of
                            false -> true;
                            _ -> false
                        end;
                    false -> false
                end;
            false -> false
        end
    end,
    Result = case lists:any(F, RedEnveLopesL) of
        true -> 1;
        _ -> 0
    end,
    {ok, BinData} = pt_331:write(33155, [Result]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'join_guild', RoleId, GuildId}, State) ->
    lib_red_envelopes_mod:join_guild(RoleId, GuildId),
    {ok, State};

do_handle_cast({'quit_guild', RoleId, GuildId}, State) ->
    lib_red_envelopes_mod:quit_guild(RoleId, GuildId),
    {ok, State};

do_handle_cast({'disband_guild', GuildId}, State) ->
    lib_red_envelopes_mod:disband_guild(GuildId),
    {ok, State};

do_handle_cast({'clear_red_envelopes', OwnershipType}, State) ->
    db:execute(io_lib:format(?sql_del_red_envelopes_by_ownership_type_and_id, [OwnershipType, 0])),
    RedEnvelopesMap = lib_red_envelopes_data:get_red_envelopes_map(),
    NewRedEnvelopesMap = maps:remove(OwnershipType, RedEnvelopesMap),
    lib_red_envelopes_data:save_red_envelopes_map(NewRedEnvelopesMap),
    {ok, State};

do_handle_cast({'daily_timer', _DelaySec}, State) ->
    lib_red_envelopes_mod:daily_clear_red_envelopes(),
    {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.


