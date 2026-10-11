%%%------------------------------------
%%% @Module  :  lib_flower_rank_api
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 魅力婚礼榜
%%%------------------------------------

-module(lib_flower_act_api).

-export([
         handle_event/2,
         login/1,
         logout/1
        ]).

-compile(export_all).

-include("flower_rank_act.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("record.hrl").
-include("marriage.hrl").
-include("custom_act.hrl").
-include("flower.hrl").
-include("role.hrl").
-include("def_fun.hrl").
-include("common_rank.hrl").

%% 转职
handle_event(Player, #event_callback{type_id = ?EVENT_TRANSFER}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{sex = Sex}} = Player,
    change_rank_by_type(RoleId, Sex),
    {ok, Player};
handle_event(Player, #event_callback{ type_id = ?EVENT_RENAME}) when is_record(Player, player_status) ->
    #player_status{ id = PlayerId, figure = #figure{name = PlayerName, sex = Sex}} = Player,
    change_role_name_by_type(PlayerId, Sex, PlayerName),
    {ok, Player};

handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.

%% %--------------------------------------------------------------------------
%% %--------------------------------------------------------------------------
%% 婚礼预约排行榜
reflash_rank_by_wedding(Wedding) when is_record(Wedding, wedding_order_info) ->
    %?PRINT("~p~n", [Wedding]),
    [refresh_common_rank(Wedding, ?RANK_TYPE_WEDDING, SubType) ||
        SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_WED_RANK)].
      
%% 魅力榜
reflash_rank_by_flower(Player, CharmPlus) when is_record(Player, player_status)->
    #player_status{id = RoleId, figure = #figure{sex = Sex} = Figure, combat_power = Power} = Player,
    case Sex of
        ?MALE ->
            RankType = ?RANK_TYPE_FLOWER_BOY, RankTypeKF = ?RANK_TYPE_FLOWER_BOY_KF, RankTypeCW = ?RANK_TYPE_CHARM_BOY;
        _ ->
            RankType = ?RANK_TYPE_FLOWER_GIRL, RankTypeKF = ?RANK_TYPE_FLOWER_GIRL_KF, RankTypeCW = ?RANK_TYPE_CHARM_GIRL
    end,
    %% 刷新本服魅力榜
    [refresh_common_rank(RoleId, CharmPlus, RankType, SubType) || 
        SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL)],
    %% 刷新跨服魅力榜
    [refresh_common_rank({RoleId, CharmPlus, WLv, Figure, Power}, RankTypeKF, SubType) || 
        #act_info{key = {_Type, SubType}, wlv = WLv} <- lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_FLOWER_RANK)],
    %% 魅力周榜
    refresh_common_rank(RoleId, CharmPlus, RankTypeCW, 0),
    ok;
      
%% 魅力榜
reflash_rank_by_flower(RoleId, CharmPlus) when is_integer(RoleId)->
    case lib_role:get_role_show(RoleId) of
        [] -> skip;
        #ets_role_show{figure = #figure{sex = Sex} = Figure, combat_power = Power} ->
            case Sex of
                ?MALE ->
                    RankType = ?RANK_TYPE_FLOWER_BOY, RankTypeKF = ?RANK_TYPE_FLOWER_BOY_KF, RankTypeCW = ?RANK_TYPE_CHARM_BOY;
                _ ->
                    RankType = ?RANK_TYPE_FLOWER_GIRL, RankTypeKF = ?RANK_TYPE_FLOWER_GIRL_KF, RankTypeCW = ?RANK_TYPE_CHARM_GIRL
            end,
             %% 刷新本服魅力榜
            [refresh_common_rank(RoleId, CharmPlus, RankType, SubType) || 
                SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL)],
            %% 刷新跨服魅力榜
            [refresh_common_rank({RoleId, CharmPlus, WLv, Figure, Power}, RankTypeKF, SubType) || 
                #act_info{key = {_Type, SubType}, wlv = WLv} <- lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_FLOWER_RANK)],
            %% 魅力周榜
            refresh_common_rank(RoleId, CharmPlus, RankTypeCW, 0)
     end,
     ok;
   
reflash_rank_by_flower(_,_) ->skip.         
        
login(_Player) ->
    %refresh_common_rank_by_all(Player),
    ok.

logout(_Player) ->
    %refresh_common_rank_by_all(Player),
    ok.

%% 刷新榜单,最好在里面统一处理,修改方便
refresh_common_rank(Info, RankType, SubType) ->
    lib_flower_act:refresh_common_rank({RankType, SubType}, Info).
%% 刷新榜单,最好在里面统一处理,修改方便
refresh_common_rank(RoleId, ValuePlus, RankType, SubType) ->
    lib_flower_act:refresh_common_rank({RankType, SubType}, {RoleId, ValuePlus}).

%% 刷新所有榜单。
refresh_common_rank_by_all(_Player) ->
    ok.

%% 获取婚礼打折折扣
get_wedding_discount() ->
     ActType = ?CUSTOM_ACT_TYPE_WED_RANK,
     case lib_custom_act_api:get_open_subtype_ids(ActType) of
         [] -> 100;
         SubList when is_list(SubList) -> 
            TmpL = [lib_flower_act:get_wed_discount(ActType, SubType)||SubType <- SubList],
            %% 如果多个活动存在 取之中最低的折扣
            lists:min(TmpL);
         _ -> 100
     end.

change_rank_by_type(RoleId, Sex) ->
    %% 本服魅力榜
    OldType = ?IF(Sex == ?MALE, ?RANK_TYPE_FLOWER_GIRL, ?RANK_TYPE_FLOWER_BOY),
    NewType = ?IF(Sex == ?MALE, ?RANK_TYPE_FLOWER_BOY, ?RANK_TYPE_FLOWER_GIRL),
    [mod_flower_act_local:change_rank_by_type(SubType, RoleId, OldType, NewType)  ||
        SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL) ],
    %% 跨服魅力榜
    OldTypeKF = ?IF(Sex == ?MALE, ?RANK_TYPE_FLOWER_GIRL_KF, ?RANK_TYPE_FLOWER_BOY_KF),
    NewTypeKF = ?IF(Sex == ?MALE, ?RANK_TYPE_FLOWER_BOY_KF, ?RANK_TYPE_FLOWER_GIRL_KF),
    [mod_kf_flower_act_local:change_rank_by_type(SubType, RoleId, OldTypeKF, NewTypeKF, Sex)  ||
        SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK) ].

change_role_name_by_type(RoleId, Sex, PlayerName) ->
    %% 本服魅力榜(时间紧迫，目前活动只有跨服魅力榜)
    %% ChangeRankType = ?IF(Sex == ?MALE, ?RANK_TYPE_FLOWER_GIRL, ?RANK_TYPE_FLOWER_BOY),
    %% [mod_flower_act_local:change_rank_by_type(SubType, RoleId, ChangeRankType, PlayerName)  ||
    %%     SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL) ],
    %% 跨服魅力榜
    ChangeRankTypeKF = ?IF(Sex == ?MALE, ?RANK_TYPE_FLOWER_BOY_KF, ?RANK_TYPE_FLOWER_GIRL_KF),
    [mod_kf_flower_act_local:change_role_name_by_type(SubType, RoleId, ChangeRankTypeKF, PlayerName)  ||
        SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK) ].

% gm_afford() ->
%     DbGoldL = db:get_all(<<"select player_id, cost_gold, cost_bgold, time from log_consume_gold where consume_type = 13 and time >= 1526572800 and time <= 1526730060 ">>),
%     DbGoodL = db:get_all(<<"select pid, goods_id, time from log_throw where type = 13 and time >= 1526572800 and time <= 1526730060">>),
%     CutL = db:get_all(<<"select role_id, time from log_intimacy where time >= 1526572800 and time <= 1526730060">>),
%     F1 = fun([RoleId, _, _, Time] = L, AccL) ->
%             case [ 1 || [RoleId0, Time0] <- CutL, RoleId =:= RoleId0 andalso Time =:= Time0 ] of
%                 [] -> [L | AccL];
%                 _ -> AccL
%             end
%         end,
%     CGoldL = lists:foldl(F1, [], DbGoldL),
%     F2 = fun([RoleId, _, Time] = L, AccL) ->
%         case [ 1 || [RoleId0, Time0] <- CutL, RoleId =:= RoleId0 andalso Time =:= Time0 ] of
%             [] -> [L | AccL];
%             _ -> AccL
%         end
%          end,
%     CGoodL = lists:foldl(F2, [], DbGoodL),
%     TmpGoldL = [{RoleId, [{100, gm_get_by_price(CostGold + CostBGold), 1}]}  || [RoleId, CostGold, CostBGold, _]  <- CGoldL ],
%     TmpGoodL = [{RoleId, [{100, GoodId, 1}]}  || [RoleId, GoodId, _]  <- CGoodL ],
%     F = fun ({RoleId, Reward}, AccL) ->
%             case lists:keyfind(RoleId, 1,  AccL) of
%                 {RoleId, OldReward} -> lists:keystore(RoleId, 1, AccL, {RoleId, ulists:object_list_merge(Reward ++ OldReward)});
%                 _ -> [{RoleId, Reward}| AccL]
%             end
%         end,
%     SendL = lists:foldl(F, [], TmpGoldL ++ TmpGoodL),
%     spawn(fun() -> send_afford(SendL) end),
%     ok.

% send_afford(L) ->
%     Title = "跨服魅力榜补偿",
%     Content = "尊敬的骑士大人，本次跨服魅力榜活动不加亲密度的问题现已修复，赠送异常的礼物将全部返还，请尽快领取补偿，祝您游戏愉快！",
%     F = fun(RoleId, RewardL) ->
%             CutFame = gm_get_fame(RewardL),
%             Pid = misc:get_player_process(RoleId),
%             case misc:is_process_alive(Pid) of
%                 true -> lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, lib_flower_act_api, cut_fame, [CutFame]);
%                 _ ->
%                     case  db:get_row(io_lib:format(?sql_sel_role_flower_data, [RoleId])) of
%                         [_, OldFame, _] -> OldFame;
%                         _ -> OldFame = 0
%                     end,
%                     db:execute(io_lib:format(?sql_update_fame, [max(0, OldFame - CutFame), RoleId]))
%             end,
%             lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardL),
%             timer:sleep(50)
%         end,
%     [ F(RoleId, RewardL)|| {RoleId, RewardL} <- L],
%     ?ERR("afford success!~n", []),
%     ok.

% cut_fame(Player, Fame) ->
%     #player_status{id = RoleId, flower = RoleFlowerData} = Player,
%     NewFame = max(0, RoleFlowerData#flower.fame - Fame),
%     PreFameLv = lib_flower:get_fame_lv(RoleFlowerData#flower.fame),
%     NewFameLv = lib_flower:get_fame_lv(NewFame),
%     case PreFameLv =/= NewFameLv of
%         true ->
%             #fame_lv_cfg{attr = NewFameAttr} = data_flower:get_fame_lv_cfg(NewFameLv),
%             NewPlayerTmp = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame, attr = NewFameAttr}},
%             NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
%             lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
%         false ->
%             NewPlayer = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame}}
%     end,
%     db:execute(io_lib:format(?sql_update_fame, [NewFame, RoleId])),
%     {ok, NewPlayer}.

% gm_get_fame(RewardL) ->
%     F = fun ({_, GoodId, Num}, Acc) ->
%             #flower_gift_cfg{fame = Fame} =  data_flower:get_flower_gift_cfg(GoodId),
%             Acc + Fame * Num
%         end,
%     lists:foldl(F, 0, RewardL).

% gm_get_by_price(2) -> 38100001;
% gm_get_by_price(29) -> 38100002;
% gm_get_by_price(66) -> 38100003;
% gm_get_by_price(99) -> 38100004;
% gm_get_by_price(199) -> 38100005;
% gm_get_by_price(299) -> 38100006;
% gm_get_by_price(399) -> 38100007;
% gm_get_by_price(18) -> 38100009;
% gm_get_by_price(198) -> 38100010.