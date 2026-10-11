%%%--------------------------------------
%%% @Module  : pp_artifact
%%% @Author  : fwx
%%% @Created : 2017.11.8
%%% @Description:  神器系统
%%%--------------------------------------
-module(pp_artifact).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("artifact.hrl").
-include("def_goods.hrl").

%% 已激活神器信息
handle(Cmd = 17102, Player, _Data) ->
    #player_status{sid = Sid, id = _RoleId, status_artifact = StatusArti, currency_map = CurrencyMap} = Player,
     BlueVal   = maps:get(?GOODS_ID_BLUE_ARTI, CurrencyMap, 0),
     PurpleVal = maps:get(?GOODS_ID_PURP_ARTI, CurrencyMap, 0),
     OrangeVal = maps:get(?GOODS_ID_ORAN_ARTI, CurrencyMap, 0),
     _PinkVal = maps:get(?GOODS_ID_PINK_ARTI, CurrencyMap, 0),
    #status_artifact{artifact_list = ArtiList} = StatusArti,
    IdList = [Id || #artifact_info{id = Id} <- ArtiList],
    ValList = [{?GOODS_ID_BLUE_ARTI, BlueVal},
        {?GOODS_ID_PURP_ARTI, PurpleVal},
        {?GOODS_ID_ORAN_ARTI, OrangeVal}],
       % {?GOODS_ID_PINK_ARTI, PinkVal}],
    lib_server_send:send_to_sid(Sid, pt_171, Cmd,  [?SUCCESS, IdList, ValList]);


%% 神器详细信息
handle(Cmd = 17103, Player, [Id]) ->
    #player_status{sid = Sid, status_artifact = StatusArti} = Player,
    #status_artifact{artifact_list = ArtiList} = StatusArti,
    case lists:keyfind(Id, #artifact_info.id, ArtiList) of
        #artifact_info{up_lv = Lv, lv_attr = _Attr, ench_percent = Percent, combat = Combat} ->
            lib_server_send:send_to_sid(Sid, pt_171, Cmd, [?SUCCESS, Id, Lv, Combat, Percent]);
        _ ->  %% 未激活不请求
            skip
    end;

%% 神器激活
handle(17104, Player, [Id]) ->
    #player_status{sid = Sid, id = RoleId, status_artifact = StatusArti} = Player,
    #status_artifact{artifact_list = ArtiList} = StatusArti,
    case lists:keyfind(Id, #artifact_info.id, ArtiList) of
        false ->
            case data_artifact:get_active_cfg(Id) of
                #artifact_active_cfg{condition = Condition} ->
                    case Condition of
                        [] ->    %% 无激活条件
                            LastPlayer = lib_artifact:active_artifact(Player, Id),
                            %% 日志
                            lib_log_api:log_artifact_active(RoleId, Id, Condition),
                            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                            lib_server_send:send_to_sid(Sid, pt_171, 17104, [?SUCCESS, Id]);
                        [{artifact, PreId, PreLv}] ->  %% 条件 神器等级
                            case lists:keyfind(PreId, #artifact_info.id, ArtiList) of
                                #artifact_info{up_lv = Lv} ->
                                    case Lv >= PreLv of
                                        true ->
                                            LastPlayer = lib_artifact:active_artifact(Player, Id),
                                            %% 日志
                                            lib_log_api:log_artifact_active(RoleId, Id, Condition),
                                            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                                            lib_server_send:send_to_sid(Sid, pt_171, 17104, [?SUCCESS, Id]);
                                        _ ->
                                            LastPlayer = Player,
                                            lib_server_send:send_to_sid(Sid, pt_171, 17100, [?ERRCODE(err171_pre_lv)])
                                    end;
                                _ ->    %% 未达到前置等级
                                    LastPlayer = Player,
                                    lib_server_send:send_to_sid(Sid, pt_171, 17100, [?ERRCODE(err171_not_active)])
                            end;
                        [{?TYPE_GOODS, _, _}] ->   %% 条件 激活物品
                            case lib_goods_api:cost_object_list_with_check(Player, Condition, artifact_active, "") of
                                {true, NewPlayerTmp} ->
                                    LastPlayer = lib_artifact:active_artifact(NewPlayerTmp, Id),
                                    %% 日志
                                    lib_log_api:log_artifact_active(RoleId, Id, Condition),
                                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                                    lib_server_send:send_to_sid(Sid, pt_171, 17104, [?SUCCESS, Id]);
                                {false, ErrorCode, LastPlayer} ->
                                    lib_server_send:send_to_sid(Sid, pt_171, 17100, [ErrorCode])
                            end;
                        _ ->
                            LastPlayer = Player,
                            lib_server_send:send_to_sid(Sid, pt_171, 17100, [?ERRCODE(err_config)])
                    end;
                _ ->
                    LastPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_171, 17100, [?ERRCODE(err_config)])
            end;
        _ ->  %% 已经激活
            LastPlayer = Player,
            lib_server_send:send_to_sid(Sid, pt_171, 17100, [?ERRCODE(err171_already_active)])
    end,
    {ok, LastPlayer};

%% 神器强化
handle(17105, Player, [Id]) ->
    #player_status{sid = Sid, id = RoleId, status_artifact = StatusArti} = Player,
    #status_artifact{artifact_list = ArtiList} = StatusArti,
     case lib_artifact:check_upgrade_lv(StatusArti, Id) of
        {ok, #artifact_upgrate_cfg{cost = Cost}, #artifact_info{up_lv = Lv} = ArtiInfo} ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, artifact_upgrade, "") of
                {true, NewPlayerTmp} ->
                    ErrorCode = ok,
                    NewLv = Lv + 1,
                    StatusArtiTmp = NewPlayerTmp#player_status.status_artifact,
                    %% 等级解锁的天赋属性
                    {GiftAttr, GiftIds} = lib_artifact:get_artifact_gift(Id, NewLv),
                    {ActiveGiftAttr, ActiveGiftId} = lib_artifact:get_active_gift(Id, NewLv),
                    %% 等级属性
                    LvAttr = lib_artifact:get_cfg_lv_attr(Id, NewLv),
                    NewArtiInfo = lib_artifact:refresh_artifact_attr(ArtiInfo#artifact_info{up_lv = NewLv, gift = GiftIds, gift_attr = GiftAttr, lv_attr = LvAttr}),
                    NewArtiList = lists:keystore(Id, #artifact_info.id, ArtiList, NewArtiInfo),
                    NewStatusArti = lib_artifact:sum_artifact_attr(StatusArtiTmp#status_artifact{artifact_list = NewArtiList}),
                    %%--db--
                    db:execute(io_lib:format(?sql_update_artifat_lv, [NewLv, RoleId, Id])),
                    %% 日志
                    lib_log_api:log_artifact_lv(RoleId, Id, NewLv, ActiveGiftId, ActiveGiftAttr, Cost),
                    LastPlayer1 = lib_player:count_player_attribute(NewPlayerTmp#player_status{status_artifact = NewStatusArti}),
                    %% 成就api
                    {ok, LastPlayer} = lib_achievement_api:artifact_lv_up_event(LastPlayer1, lib_artifact:get_arti_sum_lv(NewStatusArti)),
                    %% 通知客户端属性改变
                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                    lib_server_send:send_to_sid(Sid, pt_171, 17105, [?SUCCESS, Id, NewLv, NewArtiInfo#artifact_info.combat]);
                {false, ErrorCode, LastPlayer} -> skip
            end;
        {fail, ErrorCode} -> LastPlayer = Player;
        _ ->
            LastPlayer = Player,
            ErrorCode = ?ERRCODE(err_config)
    end,
    case is_integer(ErrorCode) of
        true ->
            lib_server_send:send_to_sid(Sid, pt_171, 17100, [ErrorCode]);
        false -> skip
    end,
    {ok, LastPlayer};

%% 神器附灵
handle(17106, Player, [Id]) ->
    #player_status{sid = Sid, id = RoleId, status_artifact = StatusArti} = Player,
    ArtiList = StatusArti#status_artifact.artifact_list,
    case lib_artifact:check_enchant(StatusArti, Id) of
        {ok, ArtiInfo} ->
            #artifact_info{ench_percent = EnchPec, ench_time = EnchTime, ench_attr = EnchAttr} = ArtiInfo,
            %% 附灵消耗
            Cost = case data_artifact:get_active_cfg(Id) of
                        #artifact_active_cfg{ench_cost = TmpCost} -> TmpCost;
                        _ -> []
                    end,
            %% 附灵超过配置的次数时取配置最大次数
            MaxTime = lib_artifact:get_chance_max_times(),
            Chance  = case data_artifact:get_chance_cfg(min(MaxTime, EnchTime + 1)) of
                            #enchant_chance_cfg{chance = TmpChance} -> TmpChance;
                            _ -> 0
                      end,
            case lib_goods_api:cost_object_list_with_check(Player, Cost, artifact_enchant, "") of
                {true, NewPlayerTmp} ->
                    ErrorCode = ok,
                    AttrTmp = data_artifact:get_all_ench_attr(Id),
                    AllAttr = lists:flatten(AttrTmp),
                    case EnchPec of
                        [] ->  %% 没有附灵属性 即首次附灵 必定激活
                            {NewEnchPec, NewEnchAttr, NewEnchTime, ActiveAttr} = lib_artifact:active_enchant_attr(Id, EnchPec, EnchAttr, EnchTime, AllAttr);
                        [{_, _}|_] ->
                            %% 过滤到未激活的属性
                            UnAttr = [{AId, Pec} ||{AId, Pec} <- AllAttr, lists:keymember(AId, 1, EnchPec) == false],
                            case UnAttr of
                                 %% 全部属性Id已激活的情况
                                [] ->
                                    %% 在已有附灵属性上增加百分比
                                    ActiveAttr = [],
                                    {NewEnchPec, NewEnchAttr} = lib_artifact:plus_own_attr_pec(Id, EnchPec, EnchAttr),
                                    NewEnchTime = EnchTime + 1;
                                 %% 有新的属性待激活
                                [{_, _}|_] ->
                                    case lists:all(fun({_Id, Val}) -> Val == 100 end, EnchPec) of
                                         %% 当已激活的附灵属性百分比满了 必定激活新属性
                                        true ->
                                            {NewEnchPec, NewEnchAttr, NewEnchTime, ActiveAttr} = lib_artifact:active_enchant_attr(Id, EnchPec, EnchAttr, EnchTime, UnAttr);
                                        _ ->
                                             {TmpEnchPec, TmpEnchAttr} = lib_artifact:plus_own_attr_pec(Id, EnchPec, EnchAttr),
                                             %% 根据概率激活新附灵属性
                                            case urand:rand(0, 100) =< Chance of
                                                true ->
                                                    {NewEnchPec, NewEnchAttr, NewEnchTime, ActiveAttr} = lib_artifact:active_enchant_attr(Id, TmpEnchPec, TmpEnchAttr, EnchTime, UnAttr);
                                                false ->
                                                    NewEnchPec = TmpEnchPec,
                                                    NewEnchAttr = TmpEnchAttr,
                                                    NewEnchTime = EnchTime + 1,
                                                    ActiveAttr = []
                                            end
                                     end
                            end
                    end ,
                    %%----db-----
                     db:execute(io_lib:format(?sql_update_artifact_enchant, [NewEnchTime, util:term_to_string(NewEnchPec), RoleId, Id])),
                    NewArtiInfo = lib_artifact:refresh_artifact_attr(ArtiInfo#artifact_info{ench_time = NewEnchTime, ench_percent = NewEnchPec, ench_attr = NewEnchAttr}),
                    NewArtiList = lists:keystore(Id, #artifact_info.id, ArtiList, NewArtiInfo),
                    NewStatusArti = StatusArti#status_artifact{artifact_list = NewArtiList},
                    LastStatusArti = lib_artifact:sum_artifact_attr(NewStatusArti),
                    %% 日志
                    lib_log_api:log_artifact_enchant(RoleId, Id, NewEnchPec, NewEnchAttr, ActiveAttr, Cost),
                    %% 成就
                    {ok, LastPlayer1} = lib_achievement_api:artifact_enchant_event(NewPlayerTmp, lib_artifact:get_ench_sum_num(LastStatusArti)),
                    LastPlayer = lib_player:count_player_attribute(LastPlayer1#player_status{status_artifact = LastStatusArti}),
                    %% 通知客户端属性改变
                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                    lib_server_send:send_to_sid(Sid, pt_171, 17106, [?SUCCESS, Id, NewEnchPec, NewArtiInfo#artifact_info.combat]);
                {false, ErrorCode, LastPlayer} -> skip
            end;
        {fail, ErrorCode} -> LastPlayer = Player
    end,
    case is_integer(ErrorCode) of
        true ->
            lib_server_send:send_to_sid(Sid, pt_171, 17100, [ErrorCode]);
        false -> skip
    end,
    {ok, LastPlayer};

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.