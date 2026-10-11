%%%------------------------------------
%%% @Module  : lib_flower_rank_act
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------

-module(lib_flower_act).

-export([
    refresh_common_rank/2
]).

-include("server.hrl").
-include("def_fun.hrl").
-include("flower_rank_act.hrl").
-include("figure.hrl").
-include("title.hrl").
-include("flower.hrl").
-include("partner.hrl").
-include("common.hrl").
-include("marriage.hrl").
-include("custom_act.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("common_rank.hrl").
-include("relationship.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("errcode.hrl").
-include("clusters.hrl").
-compile(export_all).

%% record基础数据
make_record([{RankType, SubType}, Wedding]) when RankType == ?RANK_TYPE_WEDDING andalso is_record(Wedding, wedding_order_info) ->
    %% 婚礼数据
    #wedding_order_info{
        role_id_m    = RoleId,      %% 男方id
        role_id_w    = SecId,       %% 女方id
        wedding_type = WedType   %% 1下 2中 3高
    } = Wedding,
    Time = utime:unixtime(),    %% 时间
    #rank_wed{
        wed_key      = {RankType, RoleId, Time},    %% 键
        rank_type    = RankType,                    %% 榜单类型
        sub_type     = SubType,                     %% 活动子类型
        role_id      = RoleId,                      %% 男方id
        sec_id       = SecId,                       %% 女方id
        value        = Time,                        %% 预约婚礼时间
        second_value = WedType,                     %% 婚礼类型
        time         = Time                         %% 时间
    };
%% 本跨魅力榜
make_record([{RankType, SubType}, {RoleId, CharmPlus}]) when is_integer(RoleId) ->
    Value = CharmPlus,
    #rank_role{
        role_key  = {RankType, RoleId},           %% 键
        rank_type = RankType,                     %% 榜单类型
        sub_type  = SubType,                      %% 活动子类型
        role_id   = RoleId,                       %% 玩家id
        value     = Value,                        %% 魅力值
        time      = utime:unixtime()              %% 时间
    };
make_record(_) -> #rank_role{}.

%% 榜单
refresh_common_rank({RankType, SubType}, Info) ->
    if
        RankType == ?RANK_TYPE_FLOWER_BOY orelse RankType == ?RANK_TYPE_FLOWER_GIRL ->    %% 本服魅力榜
            RankRole = make_record([{RankType, SubType}, Info]),
            mod_flower_act_local:refresh_common_rank(RankType, SubType, RankRole);
        RankType == ?RANK_TYPE_FLOWER_BOY_KF orelse RankType == ?RANK_TYPE_FLOWER_GIRL_KF -> %% 跨服魅力榜
            mod_kf_flower_act_local:refresh_common_rank(RankType, SubType, Info);
        RankType == ?RANK_TYPE_WEDDING ->           %% 婚礼榜
            WedRole = make_record([{RankType, SubType}, Info]),
            mod_flower_act_local:refresh_common_rank(RankType, SubType, WedRole);
        RankType == ?RANK_TYPE_CHARM_BOY orelse RankType == ?RANK_TYPE_CHARM_GIRL ->
            % mod_common_rank:refresh_common_rank(RankType, Info);
            ok;
        true -> skip
    end,
    ok.

is_exist(_I, []) -> false;
is_exist(I, [H | T]) ->
    case I == H of
        true ->
            true;
        false ->
            is_exist(I, T)
    end.

%% 转换定制活动类型
change_act_type(RankType) ->
    case RankType of
        ?RANK_TYPE_FLOWER_GIRL -> ?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL;
        ?RANK_TYPE_FLOWER_BOY -> ?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL;
        ?RANK_TYPE_WEDDING -> ?CUSTOM_ACT_TYPE_WED_RANK;
        ?RANK_TYPE_FLOWER_GIRL_KF -> ?CUSTOM_ACT_TYPE_FLOWER_RANK;
        ?RANK_TYPE_FLOWER_BOY_KF -> ?CUSTOM_ACT_TYPE_FLOWER_RANK;
        _ -> 0
    end.

%% 配置榜单最大长度
get_max_len(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(rank_len, 1, Condition) of
                {_, MaxLen} when is_integer(MaxLen) -> MaxLen;
                _ -> 50
            end;
        _ -> 50
    end.

%% 配置榜单显示长度
get_max_show_len(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(show_len, 1, Condition) of
                {_, ShowLen} when is_integer(ShowLen) -> ShowLen;
                _ -> 200
            end;
        _ -> 200
    end.

%% 配置上榜阈值
get_rank_limit(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(rank_limit, 1, Condition) of
                {_, Limit} when is_integer(Limit) -> Limit;
                _ -> 1
            end;
        _ -> 1
    end.

get_score_rank_condition(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(score_rank, 1, Condition) of
                {_, ScoreRank} -> ScoreRank;
                _ -> []
            end;
        _ -> []
    end.

%% 魅力榜奖励
get_flower_rank_reward(RankType, SubType, RankRole) ->
    ActType = change_act_type(RankType),
    GradeList = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    Sex = ?IF(RankType == ?RANK_TYPE_FLOWER_BOY orelse RankType == ?RANK_TYPE_FLOWER_BOY_KF, 1, 2),
    do_get_flower_rank_reward(ActType, SubType, RankRole, Sex, GradeList, []).

do_get_flower_rank_reward(_, _, _, _, [], TmpL) -> TmpL;
do_get_flower_rank_reward(ActType, SubType, RankRole, Sex, [H | T], TmpL) ->
    #rank_role_kf{role_id = _RoleId, rank = Rank, career = Career, wlv = WLv} = RankRole,
    case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, H) of
        #custom_act_reward_cfg{condition = Condition, reward = Reward} = RewardCfg when is_list(Condition) andalso is_list(Reward) ->
            case lists:keyfind(rank, 1, Condition) of
                {_, {Min, Max}} ->
                    case Max >= Rank andalso Rank >= Min of
                        true ->
                            RewardParam = lib_custom_act:make_rwparam(WLv, Sex, WLv, Career),
                            RewardList = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                            ?PRINT("get_flower_rank_reward:~p~n", [RewardList]),
                            case length(RewardList) > 0 of
                                true -> RewardList;
                                _ -> 
                                    ?ERR("get_flower_rank_reward ActType:~p, SubType:~p, Rank:~p, Sex:~p, GradeId:~p ~n", [ActType, SubType, Rank, Sex, H]),
                                    []
                            end;
                        _ -> 
                            do_get_flower_rank_reward(ActType, SubType, RankRole, Sex, T, TmpL)
                    end;
                _ -> 
                    do_get_flower_rank_reward(ActType, SubType, RankRole, Sex, T, TmpL)
            end;
        _ -> 
            do_get_flower_rank_reward(ActType, SubType, RankRole, Sex, T, TmpL)
    end.
    

%% 婚礼榜奖励
get_wed_rank_reward(RankType, SubType, Rank, WedType) ->
    ActType = change_act_type(RankType),
    GradeList = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    do_get_wed_rank_reward(ActType, SubType, Rank, WedType, GradeList, []).

do_get_wed_rank_reward(_, _, _, _, [], TmpL) -> TmpL;
do_get_wed_rank_reward(ActType, SubType, Rank, WedType, [H | T], TmpL) ->
    TmpReward = case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, H) of
                    #custom_act_reward_cfg{condition = Condition, reward = Reward} when is_list(Condition) andalso is_list(Reward) ->
                        case lists:keyfind(rank, 1, Condition) of
                            {_, {Min, Max}} ->
                                case Max >= Rank andalso Rank >= Min of
                                    true ->
                                        %% 根据婚礼类型的奖励倍数
                                        Times = get_wed_reward_times(ActType, SubType, WedType),
                                        LastReward = [{Type, Id, Num * Times} || {Type, Id, Num} <- Reward],
                                        LastReward ++ TmpL;
                                    _ -> TmpL
                                end;
                            _ -> TmpL
                        end;
                    _ -> TmpL
                end,
    do_get_wed_rank_reward(ActType, SubType, Rank, WedType, T, TmpReward).

%% 获取婚礼类型对应倍数
get_wed_reward_times(ActType, SubType, WedType) ->
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(reward_times, 1, Condition) of
                {_, TimesList} when is_list(TimesList) ->
                    case lists:keyfind(WedType, 1, TimesList) of
                        {_, Times} when is_integer(Times) -> Times;
                        _ -> 0
                    end;
                _ -> 0
            end;
        _ -> 0
    end.

%% 获取婚礼折扣
get_wed_discount(ActType, SubType) ->
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(discount, 1, Condition) of
                {_, Discount} when is_integer(Discount) -> Discount;
                _ -> 100
            end;
        _ -> 100
    end.

%% @Description 跨服送花 处理送花玩家的 在玩家进程
%% @Params  Ps, ReceiverId, #flower_gift_cfg{}, IsAnony(是否匿名)
%% @Return  Ps
% do_send_gift(Player, ReceiverId, GiftCfg, _IsAnonymous) ->
%     #player_status{sid = Sid, id = RoleId, flower = RoleFlowerData, figure = Figure} = Player,
%     #figure{name = _RoleName} = Figure,
%     #flower_gift_cfg{
%         goods_id    = GoodsId,
%         effect_type = _EffectType,
%         effect      = _Effect,
%         intimacy    = IntimacyPlus,
%         fame        = FamePlus,
%         is_tv       = _IsTv
%     } = GiftCfg,
%     %% 更新双方亲密度
%     lib_relationship:update_intimacy_each_one(RoleId, ReceiverId, IntimacyPlus, ?INTIMACY_TYPE_PRESENT, [{GoodsId, 1}]),
%     %% 飘字提示
%     case lib_relationship:is_friend_on_dict(RoleId, ReceiverId) of
%         true ->
%             TipsBinData = lib_chat:make_tv(?MOD_FLOWER, 9, [FamePlus, IntimacyPlus]);
%         false ->
%             TipsBinData = lib_chat:make_tv(?MOD_FLOWER, 8, [FamePlus])
%     end,
%     lib_server_send:send_to_sid(Sid, TipsBinData),
%     NewFame = RoleFlowerData#flower.fame + FamePlus,
%     db:execute(io_lib:format(?sql_update_fame, [NewFame, RoleId])),
%     PreFameLv = lib_flower:get_fame_lv(RoleFlowerData#flower.fame),
%     NewFameLv = lib_flower:get_fame_lv(NewFame),
%     case PreFameLv =/= NewFameLv of
%         true ->
%             #fame_lv_cfg{attr = NewFameAttr} = data_flower:get_fame_lv_cfg(NewFameLv),
%             NewPlayerTmp = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame, attr = NewFameAttr}},
%             NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
%             lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
%         false -> NewPlayer = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame}}
%     end,
%     %% 日志
%     lib_log_api:log_fame(RoleId, RoleFlowerData#flower.fame, NewFame, [{goods, GoodsId}]),
%     %% 触发成就
%     {ok, NewPlayerAfAchv} = lib_achievement_api:flower_send_event(NewPlayer, NewFame),
%     {_, LastPlayer} = lib_player_event:dispatch(NewPlayerAfAchv, ?EVENT_SEND_FLOWER, #callback_flower{to_id=ReceiverId, goods_id=GoodsId, intimacy=IntimacyPlus, sender=true}),
%     LastPlayer.


send_top_n_figure_to_act(RoleId, RankType, SubType) ->
    Figure = lib_role:get_role_figure(RoleId),
    mod_clusters_node:apply_cast(mod_kf_flower_act, send_top_n_figure_to_act, [RankType, SubType, RoleId, Figure]),
    ok.

check_send_flower(SenderSerId, ReceiverSerId) ->
    SenderZone = lib_clusters_center_api:get_zone(SenderSerId),
    ReceiverZone = lib_clusters_center_api:get_zone(ReceiverSerId),
    case ReceiverZone =/= 0 andalso SenderZone == ReceiverZone of 
        true -> 
            ReceiveNode = lib_clusters_center:get_node(ReceiverSerId),
            NodeList = mod_clusters_center:get_all_node(),
            case lists:keymember(ReceiveNode, #game_node.node, NodeList) of 
                true ->
                    true;
                _ ->
                    {false, ?ERRCODE(err224_others_stop_server)}
            end;
        _ ->
            {false, ?ERRCODE(err224_not_same_zone)}
    end.