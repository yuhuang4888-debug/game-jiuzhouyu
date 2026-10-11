%%-----------------------------------------------------------------------------
%% @Module  :       lib_red_envelopes
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-20
%% @Description:    红包逻辑模块(通用框架)
%%-----------------------------------------------------------------------------
-module(lib_red_envelopes).

-include("figure.hrl").
-include("server.hrl").
-include("red_envelopes.hrl").
-include("def_module.hrl").
-include("def_id_create.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("guild.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").

-export([
    handle_event/2
    , trigger_red_envelopes/2
    , check_red_envelopes_times/4
    , count_obtain_money/1
    , count_money_type/2
    , notify_client/2
    , is_vaild_red_envelopes/1
    , is_vaild_red_envelopes/2
    , pack_red_envelopes_list/2
    , pack_obtain_record/1
    , pack_recipients_record/1
    , send_error_code/2
    , send_error_code_by_uid/2
    , give_gfeast_red_envelopes/8
    , get_red_envelopes_classify/1
    , is_act_red_envelopes/1
    , get_red_envelopes_others_data/5
    , check_open_red_envelopes_others/2
    , use_goods_send_red_envelopes/3
    ]).

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE}) when is_record(Player, player_status) ->
    trigger_red_envelopes(Player, ?RED_ENVELOPES_TYPE_RECHARGE),
    trigger_red_envelopes(Player, ?RED_ENVELOPES_TYPE_FIR_RECHARGE),
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_VIP}) when is_record(Player, player_status) ->
    trigger_red_envelopes(Player, ?RED_ENVELOPES_TYPE_VIP),
    {ok, Player};
handle_event(Player, _) -> {ok, Player}.

%% 自动触发系统红包(推荐)
trigger_red_envelopes(Player, Type) ->
    Ids = data_red_envelopes:get_ids_by_type(Type),
    do_trigger_red_envelopes(Player, Ids).

do_trigger_red_envelopes(Player, CfgIds) ->
    ?PRINT("do_trigger_red_envelopes ~p~n", [CfgIds]),
    F = fun(CfgId) ->
        #red_envelopes_cfg{
            type = Type, ownership_type = OwnershipType, trigger_interval = TriggerInterval,
            condition = Condition, money = Money} = data_red_envelopes:get(CfgId),
        #player_status{id = RoleId, guild = GuildStatus} = Player,
        #status_guild{id = GuildId} = GuildStatus,
        IsSatisfyCondition = lib_red_envelopes_check:check_list(Condition, Player),
        if
            %OwnershipType == ?GUILD_RED_ENVELOPES andalso GuildId == 0 -> skip;      %% 公会红包只有加入公会了才会触发
            IsSatisfyCondition == false -> skip;
            true ->
                case TriggerInterval of
                    ?LIFELONG ->
                        Times = mod_counter:get_count(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_TRIGGER, CfgId),
                        TotalTriggerTimes = lib_red_envelopes_data:get_times_limit(?MOD_RED_ENVELOPES_TRIGGER, CfgId);
                    ?WEEK ->
                        Times = mod_week:get_count(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_TRIGGER, CfgId),
                        TotalTriggerTimes = lib_red_envelopes_data:get_times_limit(?MOD_RED_ENVELOPES_TRIGGER, CfgId);
                    ?DAILY ->
                        Times = mod_daily:get_count(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_TRIGGER, CfgId),
                        TotalTriggerTimes = lib_red_envelopes_data:get_times_limit(?MOD_RED_ENVELOPES_TRIGGER, CfgId);
                    _ -> Times = 99, TotalTriggerTimes = 0
                end,
                case TriggerInterval == ?NO_TIMES_LIMIT orelse TotalTriggerTimes > Times of
                    true ->
                        OwnershipId = ?IF(OwnershipType == ?GUILD_RED_ENVELOPES, GuildId, 0),
                        Args = [Type, OwnershipType, OwnershipId, RoleId, ?NO_SEND, Money, 0, CfgId, <<>>, #{}],
                        mod_red_envelopes:add_red_envelopes(Args),
                        case TriggerInterval of
                            ?LIFELONG ->
                                mod_counter:increment(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_TRIGGER, CfgId);
                            ?WEEK ->
                                mod_week:increment(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_TRIGGER, CfgId);
                            ?DAILY ->
                                mod_daily:increment(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_TRIGGER, CfgId);
                            _ -> skip
                        end;
                    _ -> skip
                end
        end
    end,
    lists:foreach(F, CfgIds).

give_gfeast_red_envelopes(RedEnvelopesCfgId, _BossId, _BossName, GuildId, _GuildName, RoleId, Money, PlayerList) ->
    case data_red_envelopes:get(RedEnvelopesCfgId) of
        #red_envelopes_cfg{
            type = Type, ownership_type = OwnershipType
        } ->
            lib_chat:send_TV({guild, GuildId}, ?MOD_RED_ENVELOPES, 3, []),
            ExtraArgs = #{player_list => PlayerList},
            SplitNum = length(PlayerList),
            Args = [Type, OwnershipType, GuildId, RoleId, ?HAS_SEND, Money, SplitNum, RedEnvelopesCfgId, <<>>, ExtraArgs],
            mod_red_envelopes:add_red_envelopes(Args);
        _ -> skip
    end.

%% 使用红包物品发红包
use_goods_send_red_envelopes(GoodsTypeId, GuildId, RoleId) ->
    case data_red_envelopes:get_goods_cfg(GoodsTypeId) of
        #red_envelopes_goods_cfg{money = Money, min_num = SplitNum, ownership_type = OwnershipType} ->
            Args = [?RED_ENVELOPES_TYPE_GOODS, OwnershipType, GuildId, RoleId, ?HAS_SEND, Money, SplitNum, GoodsTypeId, <<>>, #{}],
            RedEnvelopes = #red_envelopes{ownership_type = OwnershipType, owner_id = RoleId, ownership_id = GuildId, extra = GoodsTypeId},
            mod_red_envelopes:send_red_envelopes_by_goods(RedEnvelopes, Args),
            true;
        _ ->
            {false, ?MISSING_CONFIG}
    end.
    

%% 检测红包剩余发送次数
check_red_envelopes_times(Classify, Sub, RoleId, GoodsTypeId) ->
    if
        Classify =:= ?GOODS_RED_ENVELOPES ->
            Count = mod_daily:get_count(RoleId, ?MOD_RED_ENVELOPES, Sub, GoodsTypeId),
            TotalTimes = lib_red_envelopes_data:get_times_limit(?MOD_RED_ENVELOPES_GOODS, GoodsTypeId),
            TotalTimes - Count > 0;
        % Classify =:= ?VIP_RED_ENVELOPES ->
        %     Count = mod_daily:get_count(RoleId, ?MOD_RED_ENVELOPES, Sub, 1),
        %     TotalTimes = ?VIP_RED_ENVELOPES_SEND_LIMIT,
        %     TotalTimes - Count > 0;
        true -> true
    end.

%% 物品红包可能有铜币,钻石,绑钻
count_money_type(?SYSTEM_RED_ENVELOPES, _Extra) -> ?TYPE_BGOLD;
count_money_type(?VIP_RED_ENVELOPES, _Extra) -> ?TYPE_GOLD;
count_money_type(?GOODS_RED_ENVELOPES, GoodsTypeId) ->
    #red_envelopes_goods_cfg{money_type = MoneyType} = data_red_envelopes:get_goods_cfg(GoodsTypeId),
    MoneyType;
count_money_type(_, _) -> -1.

%% 计算领取金额
count_obtain_money(RedEnvelopes) ->
    #red_envelopes{
        money = Money, split_num = SplitNum,
        recipients_num = RecipientsNum, recipients_lists = RecipientsList
    } = RedEnvelopes,
    RemainNum = SplitNum - RecipientsNum,
    F = fun(T, MoneyTmp) ->
        MoneyTmp + T#recipients_record.money
    end,
    HasReceiveMoney = lists:foldl(F, 0, RecipientsList),
    if
        RemainNum > 1 ->
            Max = (Money - HasReceiveMoney)/RemainNum * 2,
            max(1, util:floor(urand:rand(1, 99) / 100 * Max));
        RemainNum == 1 ->
            max(0, Money - HasReceiveMoney);
        true -> 0
    end.

%% 通知客户端
notify_client(?NEW_RED_ENVELOPES, RedEnvelopes) ->
    #red_envelopes{
        ownership_id = OwnershipId, owner_id = OwnerId, type = Type, money = Money,
        ownership_type = OwnershipType, status = Status, extra = Extra, others = Others
    } = RedEnvelopes,
    case Status of
        ?HAS_SEND ->
            case OwnershipType of
                ?GUILD_RED_ENVELOPES ->
                    %% 触发成就
                    lib_achievement_api:async_event(OwnerId, lib_achievement_api, guild_red_packet_event, 1),
                    OwnerFigure = lib_role:get_role_figure(OwnerId),
                    %% 发送发红包传闻
                    case get_red_envelopes_classify(Type) of 
                        ?SYSTEM_RED_ENVELOPES -> 
                            case lists:member(Type, [?RED_ENVELOPES_TYPE_GFEAST]) of 
                                true -> skip; %% 晚宴红包自己发传闻
                                _ ->
                                    case data_red_envelopes:get(Extra) of 
                                        #red_envelopes_cfg{desc = Desc} -> 
                                            Content = uio:format(Desc, [OwnerFigure#figure.name]);
                                        _ -> Content = ""
                                    end,
                                    lib_chat:send_TV({guild, OwnershipId}, ?MOD_RED_ENVELOPES, 1, [Content])
                            end;
                        ?VIP_RED_ENVELOPES ->
                            lib_chat:send_TV({guild, OwnershipId}, ?MOD_RED_ENVELOPES, 100, [OwnerFigure#figure.name, Money]);
                        _ -> skip
                    end,
                    {ok, TipsBin} = pt_110:write(11016, [?MOD_RED_ENVELOPES, 1, 1]),
                    case Type of 
                        ?RED_ENVELOPES_TYPE_GFEAST -> %% 晚宴红包，只推给能打开的人
                            {_, PlayerList} = ulists:keyfind(?RED_OTHERS_PLAYERS, 1, Others, {?RED_ENVELOPES_TYPE_GFEAST, []}),
                            [lib_server_send:send_to_uid(PlayerId, TipsBin) || PlayerId <- PlayerList];
                        _ ->
                            lib_server_send:send_to_guild(OwnershipId, TipsBin)
                    end;
                ?ACT_RED_ENVELOPES ->
                    %% 发送发红包传闻
                    OwnerFigure = lib_role:get_role_figure(OwnerId),
                    lib_chat:send_TV({all}, OwnerId, OwnerFigure, ?MOD_RED_ENVELOPES, 2, []),
                    {ok, BinData} = pt_331:write(33155, [1]),
                    lib_server_send:send_to_all(BinData);
                _ -> skip
            end;
        ?NO_SEND ->
            case OwnershipType of
                ?GUILD_RED_ENVELOPES ->
                    {ok, TipsBin} = pt_110:write(11016, [?MOD_RED_ENVELOPES, 1, 1]),
                    lib_server_send:send_to_uid(OwnerId, TipsBin);
                _ -> skip
            end;
        _ -> skip
    end.

is_vaild_red_envelopes(RedEnvelopes) ->
    NowTime = utime:unixtime(),
    is_vaild_red_envelopes(RedEnvelopes, NowTime).

is_vaild_red_envelopes(RedEnvelopes, NowTime) when is_record(RedEnvelopes, red_envelopes) ->
    #red_envelopes{type = Type, status = Status, stime = Stime, extra = Extra, ctime = CTime} = RedEnvelopes,
    case get_red_envelopes_classify(Type) of
        ?GOODS_RED_ENVELOPES ->
            case data_red_envelopes:get_goods_cfg(Extra) of
                #red_envelopes_goods_cfg{} ->
                    Status == ?NO_SEND orelse (Status =/= ?NO_SEND andalso NowTime < Stime + ?DEL_AF_SEND_TIME);
                _ -> false
            end;
        _ ->
            (Status == ?NO_SEND andalso NowTime < CTime + ?AUTO_SEND_AF_TIME) orelse 
            (Status =/= ?NO_SEND andalso NowTime < Stime + ?DEL_AF_SEND_TIME)
    end;
is_vaild_red_envelopes(_, _) -> false.

get_red_envelopes_classify(Type) ->
    case Type of
        ?RED_ENVELOPES_TYPE_GOODS ->
            ?GOODS_RED_ENVELOPES;
        ?RED_ENVELOPES_TYPE_VIP_PLAYER_SEND ->
            ?VIP_RED_ENVELOPES;
        _ -> ?SYSTEM_RED_ENVELOPES
    end.

%% 是否是活动红包
is_act_red_envelopes(_GoodsTypeId) -> {false, 0}.
    % case data_red_envelopes:get_goods_cfg(GoodsTypeId) of
    %     #red_envelopes_goods_cfg{ownership_type = ?ACT_RED_ENVELOPES} ->
    %         case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_RED_ENVELOPES) of
    %             [#act_info{etime = Etime}|_] -> {true, Etime};
    %             _ -> %% 活动红包的时候活动关闭了，自动设置红包为过期
    %                 {false, 946656000}
    %         end;
    %     _ -> {false, 0}
    % end.

%% 打包红包列表
pack_red_envelopes_list(RoleId, RedEnvelopesList) ->
    NowTime = utime:unixtime(),
    F = fun(RedEnvelopes, AccList) ->
        case is_vaild_red_envelopes(RedEnvelopes, NowTime) of
            true ->
                #red_envelopes{
                    id = Id, owner_id = OwnerId,
                    type = Type, extra = Extra, split_num = SplitNum, recipients_num = RecipientsNum,
                    status = Status, recipients_lists = RecipientsList, msg = Msg, stime = Stime
                } = RedEnvelopes,
                #figure{
                    name = OwnerName, career = OwnerCareer, sex = OwnerSex, turn = OwnerTurn,
                    picture = OwnerPic, picture_ver = OwnerPicVer
                } = lib_role:get_role_figure(OwnerId),
                ReceiveStatus = if
                    Status == ?HAS_SEND ->
                        case lists:keyfind(RoleId, #recipients_record.role_id, RecipientsList) of
                            false -> 
                                case check_open_red_envelopes_others(RedEnvelopes, RoleId) of 
                                    true ->
                                        ?CAN_RECEIVE;
                                    _ ->
                                        0
                                end;
                            _ -> ?HAS_RECEIVE
                        end;
                    Status == ?END ->
                        case lists:keyfind(RoleId, #recipients_record.role_id, RecipientsList) of
                            false -> 0;
                            _ -> ?HAS_RECEIVE
                        end;  
                    true -> 0
                end,
                [{Id, OwnerId, OwnerName, OwnerCareer, OwnerSex, OwnerTurn, OwnerPic, OwnerPicVer,
                    Type, Extra, Status, ReceiveStatus, SplitNum, RecipientsNum, Msg, Stime}|AccList];
            false -> AccList
        end
    end,
    lists:foldl(F, [], RedEnvelopesList).

%% 打包红包获得记录
pack_obtain_record(ObtainRecord) ->
    F = fun(Record, AccList) when is_record(Record, obtain_record) ->
            #obtain_record{
                id = Id, role_name = RoleName, cfg_id = CfgId, time = Time
            } = Record,
            [{Id, RoleName, CfgId, Time}|AccList];
        (_Record, AccList) -> AccList
    end,
    lists:foldl(F, [], ObtainRecord).

%% 打包红包领取记录
pack_recipients_record(RecipientsRecord) ->
    F = fun(Record, AccList) when is_record(Record, recipients_record) ->
            #recipients_record{role_id = RoleId, money = Money, time = Time} = Record,
            #figure{
                name = RoleName, career = Career, sex = Sex, turn = Turn,
                picture = Picture, picture_ver = PictureVer
            } = lib_role:get_role_figure(RoleId),
            [{RoleId, RoleName, Career, Sex, Turn, Picture, PictureVer, Money, Time}|AccList];
        (_Record, AccList) -> AccList
    end,
    lists:foldl(F, [], RecipientsRecord).

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    {ok, BinData} = pt_339:write(33900, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).

%% 发送错误码
send_error_code_by_uid(RoleId, ErrorCode) ->
    {ok, BinData} = pt_339:write(33900, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).

get_red_envelopes_others_data(Type, _OwnershipType, _OwnershipId, OwnerId, ExtraArgs) ->
    case Type of 
        ?RED_ENVELOPES_TYPE_GFEAST ->
            PlayerList = maps:get(player_list, ExtraArgs, [OwnerId]),
            [{?RED_OTHERS_PLAYERS, PlayerList}];
        _ ->
            []
    end.

check_open_red_envelopes_others(RedEnvelopes, RoleId) ->
    #red_envelopes{
        type = Type, others = Others
    } = RedEnvelopes,
    case Type of 
        ?RED_ENVELOPES_TYPE_GFEAST ->
            {_, PlayerList} = ulists:keyfind(?RED_OTHERS_PLAYERS, 1, Others, {?RED_ENVELOPES_TYPE_GFEAST, []}),
            case lists:member(RoleId, PlayerList) of 
                true -> true;
                _ -> {false, ?ERRCODE(err339_feast_boss_err)}
            end;
        _ -> true
    end.