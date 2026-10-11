%%-----------------------------------------------------------------------------
%% @Module  :       pp_red_envelopes
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-20
%% @Description:    公会红包
%%-----------------------------------------------------------------------------
-module(pp_red_envelopes).

-include("server.hrl").
-include("errcode.hrl").
-include("red_envelopes.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").

-compile([export_all]).

%% 公会红包列表
handle(33901, Player, []) ->
    #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Player,
    #status_guild{id = GuildId} = GuildStatus,
    case GuildId =/= 0 of
        true ->
            mod_red_envelopes:send_red_envelopes_list(?GUILD_RED_ENVELOPES, GuildId, RoleId);
        _ ->
            lib_red_envelopes:send_error_code(Sid, ?ERRCODE(err400_not_join_guild))
    end;

%% 打开红包
handle(33902, Player, [RedEnvelopesId]) ->
    #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Player,
    #status_guild{id = GuildId} = GuildStatus,
    case GuildId =/= 0 of
        true ->
            mod_red_envelopes:open_red_envelopes(?GUILD_RED_ENVELOPES, GuildId, RoleId, RedEnvelopesId);
        _ ->
            lib_red_envelopes:send_error_code(Sid, ?ERRCODE(err400_not_join_guild))
    end;

%% 设置红包拆分数量界面
handle(33903, Player, [Type, Extra]) ->
    #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Player,
    #status_guild{id = GuildId, lv = GuildLv} = GuildStatus,
    case GuildId =/= 0 of
        true ->
            Classify = lib_red_envelopes:get_red_envelopes_classify(Type),
            mod_red_envelopes:send_split_num_info(?GUILD_RED_ENVELOPES, GuildId, GuildLv, RoleId, Classify, Extra);
        _ ->
            lib_red_envelopes:send_error_code(Sid, ?ERRCODE(err339_not_join_guild))
    end;

%% 发送红包
handle(33904, Player, [RedEnvelopesId, SplitNum]) ->
    #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Player,
    #status_guild{id = GuildId, lv = GuildLv} = GuildStatus,
    case GuildId =/= 0 of
        true ->
            mod_red_envelopes:send_red_envelopes(?GUILD_RED_ENVELOPES, GuildId, GuildLv, RoleId, RedEnvelopesId, SplitNum);
        _ ->
            lib_red_envelopes:send_error_code(Sid, ?ERRCODE(err339_not_join_guild))
    end;

%% 使用红包道具发送红包
handle(33905, Player, [GoodsId, GoodsTypeId, SplitNum]) ->
    #player_status{sid = Sid, id = RoleId, guild = GuildStatus} = Player,
    #status_guild{id = GuildId, lv = _GuildLv} = GuildStatus,
    Cfg = data_red_envelopes:get_goods_cfg(GoodsTypeId),
    if
        GuildId == 0 -> ErrCode = ?ERRCODE(err339_not_join_guild);
        is_record(Cfg, red_envelopes_goods_cfg) == false -> ErrCode = ?ERRCODE(missing_config);
        true ->
            #red_envelopes_goods_cfg{
                ownership_type = OwnershipType, money = Money, min_num = MinSplitNum
            } = Cfg,
            MemberNum = mod_guild:get_guild_member_capacity(GuildId),
            if
                SplitNum > MemberNum orelse SplitNum > Money ->
                    ErrCode = ?ERRCODE(err339_split_max_num_err);
                SplitNum < MinSplitNum ->
                    ErrCode = ?ERRCODE(err339_split_min_num_err);
                OwnershipType =/= ?GUILD_RED_ENVELOPES ->
                    ErrCode = ?ERRCODE(err_config);
                true ->
                    HasTimes = lib_red_envelopes:check_red_envelopes_times(?GOODS_RED_ENVELOPES, ?MOD_RED_ENVELOPES_GOODS, RoleId, GoodsTypeId),
                    if
                        HasTimes == false ->
                            ErrCode = ?ERRCODE(err339_daily_times_no_enough);
                        true ->
                            case catch lib_goods_api:delete_more_by_list(Player, [{GoodsId, 1}], send_goods_red_envelopes) of
                                1 ->
                                    ErrCode = ?SUCCESS,
                                    Args = [?RED_ENVELOPES_TYPE_GOODS, OwnershipType, GuildId, RoleId,
                                        ?HAS_SEND, Money, SplitNum, GoodsTypeId, <<>>, #{}],
                                    mod_red_envelopes:add_red_envelopes(Args),
                                    mod_daily:increment(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_GOODS, GoodsTypeId);
                                _Reason ->
                                    ?ERR("send_goods_red_envelopes error:~p", [_Reason]),
                                    ErrCode = ?FAIL
                            end
                    end
            end
    end,
    case is_integer(ErrCode) of
        true ->
            {ok, BinData1} = pt_339:write(33905, [ErrCode]),
            lib_server_send:send_to_sid(Sid, BinData1);
        _ -> skip
    end;

%% vip发送红包
handle(33906, Player, [Money, SplitNum, Msg]) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, guild = GuildStatus, gold = Gold} = Player,
    #status_guild{id = GuildId, lv = _GuildLv} = GuildStatus,
    #figure{lv = Lv, vip = VipLv} = Figure,
    % 信息处理（敏感词等）
    RePattern = ["|", "\\*", "|", "%", "|", "&", "|", [194,160]],
    MsgRe = re:replace(Msg, RePattern, "", [global, {return, list}]),
    MsgSend =
    case mod_word:word_is_sensitive(MsgRe) of
        true -> lib_word:filter_text(MsgRe, Lv);
        false -> lib_word:filter_text(Msg, Lv)
    end,
    MsgLen = length(Msg),
    MstLenLimit = ?IF(lib_vsn:is_th(), 108, 54),
    if
        GuildId == 0 -> NewPlayer = Player, ErrCode = ?ERRCODE(err339_not_join_guild);
        MsgLen >= MstLenLimit -> NewPlayer = Player, ErrCode = ?ERRCODE(err339_msg_too_long);
        true ->
            MemberNum = mod_guild:get_guild_member_capacity(GuildId),
            VipLvSend = ?VIP_RED_ENVELOPES_SEND_LV,
            SplitNumMin = ?VIP_RED_ENVELOPES_MIN_SPLIT_NUM,
            SendGoldMax = ?VIP_RED_ENVELOPES_GOLD_MAX,
            if
                VipLv < VipLvSend -> NewPlayer = Player, ErrCode = ?ERRCODE(err339_vip_lv_not_enough);
                SplitNum > MemberNum orelse SplitNum > Money ->
                    NewPlayer = Player, ErrCode = ?ERRCODE(err339_split_max_num_err);
                SplitNum < SplitNumMin -> NewPlayer = Player, ErrCode = ?ERRCODE(err339_split_min_num_err);
                Money > Gold ->
                    NewPlayer = Player, ErrCode = ?ERRCODE(gold_not_enough);
                Money > SendGoldMax ->
                    NewPlayer = Player, ErrCode = {?ERRCODE(err339_gold_to_much), [SendGoldMax]};
                true ->
                    %HasTimes = lib_red_envelopes:check_red_envelopes_times(?VIP_RED_ENVELOPES, ?MOD_RED_ENVELOPES_VIP, RoleId, VipLv),
                    Count = mod_daily:get_count(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_VIP, 1),
                    TotalTimes = ?VIP_RED_ENVELOPES_SEND_LIMIT,
                    HasTimes = TotalTimes - Count > 0,
                    if
                        HasTimes == false ->
                            NewPlayer = Player, ErrCode = ?ERRCODE(err339_daily_times_no_enough);
                        true ->
                            case lib_goods_api:cost_money(Player, gold, Money, red_envelopes, "") of
                                {1, NewPlayer} ->
                                    ErrCode = {?ERRCODE(err339_vip_send_succ), [TotalTimes-Count-1]},
                                    Args = [?RED_ENVELOPES_TYPE_VIP_PLAYER_SEND, ?GUILD_RED_ENVELOPES, GuildId, RoleId,
                                        ?HAS_SEND, Money, SplitNum, VipLv, util:fix_sql_str(MsgSend), #{}],
                                    mod_daily:increment(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_VIP, 1),
                                    mod_red_envelopes:add_red_envelopes(Args);
                                {0, NewPlayer} -> ErrCode = ?FAIL
                            end
                    end
            end
    end,
    {CodeInt, CodeArgs} = util:parse_error_code(ErrCode),
    {ok, BinData} = pt_339:write(33906, [CodeInt, CodeArgs]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer};

handle(_Cmd, _Player, _Data) ->
    {error, "pp_red_envelopes no match~n"}.
