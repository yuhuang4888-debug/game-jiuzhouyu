%%---------------------------------------------------------------------------
%% @doc:        lib_equip_suit
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-5月-17. 11:03
%% @deprecated: 新版共鸣规则（部分接口处于lib_equip.erl文件中）
%%---------------------------------------------------------------------------
-module(lib_equip_suit).

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("equip_suit.hrl").
-include("sql_player.hrl").
-include_lib("stdlib/include/ms_transform.hrl").


%% API
-export([
    return_data_offline/1,
    return_data_online/1,
    return_old_equip_suit_data/1,
    get_all_player_id/0
]).
%% lib_player:apply_cast(4294968375, ?APPLY_CAST_SAVE, lib_equip, get_data, []);

return_old_equip_suit_data(PlayerId) ->
    case PlayerId of
        0 ->
            Sql = io_lib:format(<<"select DISTINCT role_id from equip_suit">>, []),
            AllPlayerIds = [DbPlayerId || [DbPlayerId] <- db:get_all(Sql)],
            Fun = fun(FixPlayerId) ->
                timer:sleep(1000),
                return_data_offline(FixPlayerId)
            end,
            spawn(fun() -> lists:foreach(Fun, AllPlayerIds) end),
            length(AllPlayerIds);
        _ ->
            Pid = misc:get_player_process(PlayerId),
            case is_pid(Pid) andalso misc:is_process_alive(Pid) of
                true ->  
                    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, ?MODULE, return_data_online, []);
                false ->
                    return_data_offline(PlayerId)
            end
    end.

%% 在线玩家的修复回退方式
return_data_online(Player) ->
    BaseRestoreLv = 1,
    GoodsStatus = lib_goods_do:get_goods_status(),
    SuitList = GoodsStatus#goods_status.equip_suit_list,
    Fun = fun(EquipPos, {BaseReturnRewardL, BaseGoodsStatus}) ->
        Type = lib_equip:get_suit_type(EquipPos), 
        case Type of
            ?ACCESSORY ->
                {BaseReturnRewardL, BaseGoodsStatus};
            _ ->
                BackLvs = [RestoreLv || #suit_item{key = {PosId, RestoreLv}} <- SuitList, PosId =:= EquipPos, RestoreLv >= BaseRestoreLv],  
                RestoreLvs = lists:reverse(lists:sort(BackLvs)),
                case lists:keyfind({EquipPos, BaseRestoreLv}, #suit_item.key, SuitList) of
                    #suit_item{ slv = SLv } when SLv >= 1  ->
                        RestoreFun = fun(CurLv, {LvRewardList, CurGS}) ->
                            RestoreStage = lib_equip:get_cur_min_suit_stage(Type, CurLv, EquipPos),
                            %% 获取需要回退的奖励
                            NewRewardList = get_lv_restore_rewards_online(Player, RestoreStage, SLv, EquipPos, CurLv, LvRewardList),
                            %% 如套装类型是武防，则更新阶数为0
                            %% 如套装类型是饰品，则更新阶数为不能兼容的阶数-1
                            LastSLv = ?IF(Type =:= ?EQUIPMENT, 0, ?IF(RestoreStage =:= 0, SLv, RestoreStage-1)),
                            %% 更新套装信息状态和信息并同步到数据库
                            lib_equip:db_update_suit_info(Player#player_status.id, EquipPos, CurLv, LastSLv),
                            LastGS = lib_equip:setup_equip_suit(CurGS, EquipPos, CurLv, LastSLv),
                            %% 日志记录
                            case lists:keyfind({Type, CurLv, RestoreStage}, #suit_state.key, CurGS#goods_status.equip_suit_state) of
                                #suit_state{count = Count} ->
                                    lib_log_api:log_equip_suit_operation(Player#player_status.id, 0, 0, Type, BaseRestoreLv, RestoreStage, Count, 0);
                                _ ->
                                    skip
                            end,
                            {NewRewardList, LastGS}
                         end,
                        {TotalRewardList, NewGoodsStatus} = lists:foldl(RestoreFun, {[], BaseGoodsStatus}, RestoreLvs),
                        ReturnRewardL = TotalRewardList ++ BaseReturnRewardL,
                        {ReturnRewardL, NewGoodsStatus};
                    _ ->
                        {BaseReturnRewardL, BaseGoodsStatus}
                end
        end
          end,
    EquipPosList = data_equip_suit:get_all_equip_pos(),
    {AllRewardList, NewGS} = lists:foldl(Fun, {[], GoodsStatus}, EquipPosList),
    case AllRewardList of
        [] -> Player;
        _ ->
            %% 更新套装属性和玩家信息
            NewSuitState = NewGS#goods_status.equip_suit_state,
            TotalSuitAttr = lib_equip:calc_suit_attr(NewSuitState),
            #player_status{goods = SG} = Player,
            NewSG = SG#status_goods{equip_suit_attr = TotalSuitAttr},
            NewPS0 = Player#player_status{goods = NewSG},
            NewGoodsStatus = NewGS#goods_status{is_dirty_suit = false},
            %% 计算装备属性，通知客户端更新物品和战力信息
            {ok, NewPS} = lib_goods_util:count_role_equip_attribute(NewPS0, NewGoodsStatus),
            lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),
            %% 为防止出现意外，打印玩家原本的数据与对应反还的奖励
            %% ?INFO("PlayerId:~p//SuitL:~p//ReturnReward:~p", [Player#player_status.id, SuitList, AllRewardList]),
            Title = utext:get(205, []),
            Content = utext:get(1520007, []),
            lib_mail_api:send_sys_mail([Player#player_status.id], Title, Content, AllRewardList),
            pp_equip:handle(15220, NewPS, []),
            NewPS
    end.

%% 离线玩家 操作数据库 返还共鸣石等材料
return_data_offline(PlayerId) ->
    BaseRestoreLv = 1,
    SuitList = lib_equip:get_initual_suit(PlayerId),
    EquipSuitStates = lib_equip:calc_suit_state(SuitList),
    GoodsStatus = #goods_status{ equip_suit_list = SuitList, equip_suit_state = EquipSuitStates },
    EquipPosList = data_equip_suit:get_all_equip_pos(),
    Fun = fun(EquipPos, {BaseReturnRewardL, BaseGoodsStatus}) ->
        Type = lib_equip:get_suit_type(EquipPos),
        case Type of
            ?ACCESSORY ->  %% 饰物共鸣不处理
                {BaseReturnRewardL, BaseGoodsStatus};
            _ ->
                BackLvs = [RestoreLv || #suit_item{key = {PosId, RestoreLv}} <- SuitList, PosId =:= EquipPos, RestoreLv >= BaseRestoreLv],  
                RestoreLvs = lists:reverse(lists:sort(BackLvs)),
                case lists:keyfind({EquipPos, BaseRestoreLv}, #suit_item.key, SuitList) of
                    #suit_item{ slv = SLv } when SLv >= 1  ->
                        RestoreFun = fun(CurLv, {LvRewardList, CurGS}) ->
                            RestoreStage = get_cur_min_suit_stage_offline(CurLv, EquipPos, SuitList),
                            %% 获取回退的材料数量
                            NewRewardList = get_lv_restore_rewards_offline(PlayerId, RestoreStage, SLv, EquipPos, CurLv, LvRewardList),
                            %% 如套装类型是武防，则更新阶数为0
                            %% 如套装类型是饰品，则更新阶数为不能兼容的阶数-1
                            LastSLv = ?IF(Type =:= ?EQUIPMENT, 0, ?IF(RestoreStage =:= 0, SLv, RestoreStage-1)),
                            %% 更新套装信息状态和信息并同步到数据库
                            lib_equip:db_update_suit_info(PlayerId, EquipPos, CurLv, LastSLv),
                            LastGS = lib_equip:setup_equip_suit(CurGS, EquipPos, CurLv, LastSLv),
                            %% 日志记录
                            case lists:keyfind({Type, CurLv, RestoreStage}, #suit_state.key, CurGS#goods_status.equip_suit_state) of
                                #suit_state{count = Count} ->
                                    lib_log_api:log_equip_suit_operation(PlayerId, 0, 0, Type, BaseRestoreLv, RestoreStage, Count, 0);
                                _ ->
                                    skip
                            end,
                            {NewRewardList, LastGS}
                        end,
                        {TotalRewardList, NewGoodsStatus} = lists:foldl(RestoreFun, {[], BaseGoodsStatus}, RestoreLvs),
                        ReturnRewardL = TotalRewardList ++ BaseReturnRewardL,
                        {ReturnRewardL, NewGoodsStatus};
                    _ ->
                        {BaseReturnRewardL, BaseGoodsStatus}
                end
        end
          end,
    {AllRewardList, _NewGS} = lists:foldl(Fun, {[], GoodsStatus}, EquipPosList),
    case AllRewardList of
        [] -> skip;
        _ ->
            %% 为防止出现意外，打印玩家原本的数据与对应反还的奖励
            %% ?INFO("PlayerId:~p//SuitL:~p//ReturnReward:~p", [PlayerId, SuitList, AllRewardList]),
            %% 发送邮件
            Title = utext:get(205, []),
            Content = utext:get(1520007, []),
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, AllRewardList)
    end.

get_cur_min_suit_stage_offline(Lv, EquipPos, SuitList) ->
    case lists:keyfind({EquipPos, Lv}, #suit_item.key, SuitList) of
        #suit_item{ lv = CurLv } -> CurLv;
        _ -> Lv
    end.

get_lv_restore_rewards_offline(_PlayerId, RestoreStage, SLv, _EquipPos, _CurLv, StageRewardList) when RestoreStage > SLv ->
    StageRewardList;
get_lv_restore_rewards_offline(PlayerId, RestoreStage, SLv, EquipPos, CurLv, StageRewardList) ->
    case db:get_one(io_lib:format(?sql_role_name_by_id, [PlayerId])) of
        null ->
            StageRewardList;
        _ ->
            %% 从db读取玩家消耗记录表
            ConsumeRecordMap = lib_goods_consume_record:init_consume_record_map(PlayerId),
            case get_consume_record_with_mod_key_offline(?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, CurLv, RestoreStage}, ConsumeRecordMap) of
                %% 防止配置修改而多发还原奖励
                [#consume_record{consume_list = ConsumeList}|_] ->
                    del_consume_record_with_mod_key_offline(?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, CurLv, RestoreStage}, ConsumeRecordMap),
                    RestoreReward = ConsumeList;
                fail ->
                    RestoreReward = []
            end,
            NewRewardList = lists:append(StageRewardList, RestoreReward),
            get_lv_restore_rewards_offline(PlayerId, RestoreStage + 1, SLv, EquipPos, CurLv, NewRewardList)
    end.

get_consume_record_with_mod_key_offline(Mod, SubMod, ModKey, ConsumeRecordMap) ->
    OldRecordList = maps:get({Mod, SubMod}, ConsumeRecordMap, []),
    F = fun(ConsumeRecord) ->
        ConsumeRecord#consume_record.mod_key == ModKey
        end,
    case lists:filter(F, OldRecordList) of
        [] -> fail;
        List ->
            lists:reverse(lists:keysort(#consume_record.time, List))
    end.

del_consume_record_with_mod_key_offline(Mod, SubMod, ModKey, ConsumeRecordMap) ->
    OldRecordList = maps:get({Mod, SubMod}, ConsumeRecordMap, []),
    F = fun(ConsumeRecord) ->
        ConsumeRecord#consume_record.mod_key == ModKey
        end,
    case lists:filter(F, OldRecordList) of
        [] -> ConsumeRecordMap;
        List ->
            lib_goods_consume_record:db_delete_consume_record([Id||#consume_record{id = Id} <- List]),
            NewRecordList = OldRecordList -- List,
            NewConsumeRecordMap = maps:put({Mod, SubMod}, NewRecordList, ConsumeRecordMap),
            NewConsumeRecordMap
    end.

% 获取在该套装等级上各阶级总共需要退回的物品
get_lv_restore_rewards_online(_PS, RestoreStage, SLv, _EquipPos, _CurLv, StageRewardList) when RestoreStage > SLv ->
    StageRewardList;
get_lv_restore_rewards_online(PS, RestoreStage, SLv, EquipPos, CurLv, StageRewardList) ->
% 计算退回的物品内容
    case lib_goods_consume_record:get_consume_record_with_mod_key(PS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, CurLv, RestoreStage}) of
        % 防止配置修改而多发还原奖励
        [#consume_record{consume_list = ConsumeList}|_] ->
            lib_goods_consume_record:del_consume_record_with_mod_key(PS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, CurLv, RestoreStage}),
            RestoreReward = ConsumeList;
        fail ->
            RestoreReward = []
    end,
    NewRewardList = lists:append(StageRewardList, RestoreReward),
    get_lv_restore_rewards_online(PS, RestoreStage+1, SLv, EquipPos, CurLv, NewRewardList).


%% =============================================
%% 寻找有问题需要补发邮件的玩家
%% =============================================


%% log_mail_get 选出成功该封邮件奖励的玩家
%%-define(SELECT_MAIL_PLAYER_FROM_MAIL_GET, <<"select `rid` from log_mail_get where `title` = '~s' and `time` < 1653557400">>).
%%
%%%% mail_attr 选出发了邮件但因为过界而导致cm_attachment无法正常转换为erlang机构的玩家
%%-define(SELECT_MAIL_ATTR_ERROR, <<"select `rid`, `cm_attachment` from mail_attr where `title` = '~s' and `effect_st` < 1653557400">>).
%%
%%%% 拿到开放入口前的所有玩家的最后打造操作后的套装信息
%%-define(SELECT_SUIT_PLAYER_BEFORE_TIME, <<"select `player_id`, `suit_lv`, `suit_slv`, `suit_num`, `time` from (select `id`, `player_id`, `suit_lv`, `suit_slv`, `suit_num`, `time`
%%       from log_equip_suit_operation where `op` = ~p and `time` < 1653557400 and `suit_type` = ~p and `suit_lv` = ~p ORDER BY  `id` desc LIMIT 99999) as a GROUP BY `player_id`">>).

get_all_player_id() ->
    SuitLvs = [1, 2, 3],
    Fun = fun(SuitLv, AccMap) ->
        %% Args [操作类型 1 - 打造，大类 1 - 正常装备 2 - 饰品, 小类 1 妖魂 2 修罗 3 万物]
        List = db:get_all(io_lib:format(
            <<"select `player_id`, `suit_lv`, `suit_slv`, `suit_num`, `time` from (select `id`, `player_id`, `suit_lv`, `suit_slv`, `suit_num`, `time` from log_equip_suit_operation where `op` = ~p and `time` < 1653557400 and `suit_type` = ~p and `suit_lv` = ~p ORDER BY  `id` desc LIMIT 99999) as a GROUP BY `player_id`">>, [1, 1, SuitLv])),
        Fun2 = fun(I, RoleMap) ->
            [PlayerId, MakeType, State, Num, LastTime|_] = I,
            RoleList = maps:get(PlayerId, RoleMap, []),
            maps:put(PlayerId, [{MakeType, State, Num, LastTime}|RoleList], RoleMap)
        end,
        lists:foldl(Fun2, AccMap, List)
    end,
    AllPlayerSuitInfo = lists:foldl(Fun, #{}, SuitLvs),
    MailGetList = db:get_all(io_lib:format(<<"select `rid` from log_mail_get where `title` = '~s' and `time` < 1653557400">>, [<<"共鸣材料返还"/utf8>>])),
    HasGetMailPlayer = lists:flatten(MailGetList),
    SendMailAttr = db:get_all(io_lib:format(<<"select `rid`, `cm_attachment` from mail_attr where `title` = '~s' and `effect_st` < 1653557400">>, [<<"共鸣材料返还"/utf8>>])),
    %% 过滤出m_attachment字段不能成功转换的玩家和可成功转换的玩家
    MailFun = fun(MailInfo, {ErrorPlayerL, RightPlayerL}) ->
        [PlayerId, CmReward|_] = MailInfo,
        case util:bitstring_to_term(CmReward) of
            undefined ->
                {[PlayerId|ErrorPlayerL], RightPlayerL};
            _ ->
                {ErrorPlayerL, [PlayerId|RightPlayerL]}
        end
    end,
    {_ErrorMailAttrPlayerL, RightMailAttrPlayerL} = lists:foldl(MailFun, {[], []}, SendMailAttr),
    RuleFun = fun(PlayerId, PlayerSuitInfoL, ErrorPlayerMap) ->
        %% 如果在已领取的列表中找到玩家或已发的邮件中附件可成功转换的玩家列表，则表示改玩家的回退一切正常，不需要进行补发
        case lists:member(PlayerId, HasGetMailPlayer) orelse lists:member(PlayerId, RightMailAttrPlayerL) of
            true ->
                ErrorPlayerMap;
            false ->
                maps:put(PlayerId, PlayerSuitInfoL, ErrorPlayerMap)
        end
    end,
    NeedPlayerMaps = maps:fold(RuleFun, #{}, AllPlayerSuitInfo),
    ?INFO("NeedPlayerMaps:~p", [NeedPlayerMaps]),
    NeedPlayerMaps.









