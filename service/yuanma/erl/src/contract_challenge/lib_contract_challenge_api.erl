%% ---------------------------------------------------------------------------
%% @doc lib_contract_challenge_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/26
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_contract_challenge_api).

%% API
-compile([export_all]).

-include("rec_event.hrl").
-include("def_event.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("server.hrl").
-include("common.hrl").
-include("contract_challenge.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("boss.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("goods.hrl").


%% 红装合成(失败)
red_equip_combine(Player) ->
    event(Player, ?MOD_EQUIP, ?Default_subtype, 1).
%% 红装合成（成功）
red_equip_combine(Player, GoodsInfoList) ->
    %% 排除粉装合成
    F = fun(GoodsInfo, Bool) ->
        #goods{color = Color} = GoodsInfo,
        ?IF(Color == 6, false andalso Bool, true andalso Bool)
        end,
    ?IF(lists:foldl(F, true, GoodsInfoList),
        event(Player, ?MOD_EQUIP, ?Default_subtype, 1),
        skip).

%% 击杀Boss
kill_boss(BLWhos, BossType) ->
    BossTypeList = [?BOSS_TYPE_NEW_OUTSIDE],
    ?IF(lists:member(BossType, BossTypeList),
        begin
            [event(RoleId, ?MOD_BOSS, BossType, 1)||#mon_atter{id = RoleId} <- BLWhos]
        end, skip).

%% 进入蛮荒圣地
enter_mh_scene(RoleId, BossType) ->
    event(RoleId, ?MOD_BOSS, BossType, 1).

%% 进入午间派对
enter_midday_party(RoleId, Num) ->
    event(RoleId, ?MOD_BEACH, ?Default_subtype, Num).

%% 圣兽领boss击杀
kill_eudemons_boss(RoleId) when is_integer(RoleId) ->
    event(RoleId, ?MOD_EUDEMONS_BOSS, ?Default_subtype, 1);
kill_eudemons_boss(BLWhos) ->
    [event(RoleId, ?MOD_EUDEMONS_BOSS, ?Default_subtype, 1)||#mon_atter{id = RoleId} <-BLWhos].

%% 跨服圣域boss击杀
kill_c_sanctuary_boss(RoleId) ->
    event(RoleId, ?MOD_C_SANCTUARY, ?Default_subtype, 1).

%% 充值
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product, gold = Gold}}) when is_record(Player, player_status) ->
    case Product of
        #base_recharge_product{product_type = ?PRODUCT_TYPE_GIFT, product_id = ProductId} ->
            case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE) of
                [] -> skip;
                [#act_info{key = {_, SubType}}|_] ->
                    #player_status{id = RoleId, figure = #figure{name = Name}} = Player,
                    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType),
                    case lib_custom_act_check:check_act_condtion([active_cost], Condition) of
                        [ProductId] -> mod_contract_challenge:active_legend(RoleId, Name, SubType);
                        _ -> skip
                 end
            end;
        _ ->
            IsTrigger = lib_recharge_api:is_trigger_recharge_act(Product),
            RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
            if
                IsTrigger, RealGold > 0 -> event(Player, ?MOD_RECHARGE, ?Default_subtype, Gold);
                true -> skip
            end
    end,
    {ok, Player};

%% 进入副本
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_ENTER, data = #callback_dungeon_enter{dun_type = SubType, count = Count}}) when is_record(Player, player_status) ->
    DungeonList = [?DUNGEON_TYPE_EXP_SINGLE, ?DUNGEON_TYPE_EQUIP, ?DUNGEON_TYPE_RUNE],
    ?IF(lists:member(SubType, DungeonList),
        event(Player, ?MOD_DUNGEON, SubType, Count),
        skip),
    {ok, Player};

%% 消费活动实时更新
handle_event(Player, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data})  ->
    #callback_money_cost{consume_type = ConsumeType, money_type = MoneyType, cost = Cost} = Data,
    case lib_consume_data:is_consume_for_act(ConsumeType) of
        true ->
            case MoneyType =:= ?GOLD of
                true ->
                    event(Player, ?COST_MODULE, ?Default_subtype, Cost);
                false -> skip
            end;
        _ -> skip
    end,
    {ok, Player};

handle_event(Player, EventCallback) ->
    ?ERR("ContratChallenge Event Error ,EventCallback ~p ~n", [EventCallback]),
    {ok, Player}.

event(Player, Module, SubType, Num) when is_record(Player, player_status) ->
    #player_status{id = RoleId} = Player,
    % ?PRINT("@@@ContractChallenge Task Process , Module:~p, SubType:~p, Num: ~p ~n ~n", [Module, SubType, Num]),
    mod_contract_challenge:task_process(RoleId, Module, SubType, Num);

event(RoleId, Module, SubType, Num) when is_integer(RoleId) ->
    % ?PRINT("@@@ContractChallenge Task Process , Module:~p, SubType:~p, Num: ~p ~n ~n", [Module, SubType, Num]),
    mod_contract_challenge:task_process(RoleId, Module, SubType, Num);

event(_, Module, SubType, Num) ->
    ?ERR("@@@ERR Process , Module:~p, SubType:~p, Num: ~p ~n ~n", [Module, SubType, Num]),
    skip.


