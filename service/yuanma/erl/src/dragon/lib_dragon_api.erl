%% ---------------------------------------------------------------------------
%% @doc lib_dragon_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-12-18
%% @deprecated 龍紋系統介面
%% ---------------------------------------------------------------------------
-module(lib_dragon_api).

-export([
        get_skill_list/1
        , handle_event/2
        , gm_add_dragon_equip/1
        , get_dragon_power/1
        , get_equip_list/3
    ]).

-include("server.hrl").
-include("dragon.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("goods.hrl").

%% 獲得技能列表
get_skill_list(Player) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{skill_list = SkillList} = StatusDragon,
    SkillList.

%% 事件
% handle_event(Player, #event_callback{type_id = ?EVENT_CHANGE_CAREER}) ->
%     NewPlayer = lib_dragon:calc_dragon(Player),
%     % ?INFO("EVENT_CHANGE_CAREER:~p ~n", [1]),
%     {ok, NewPlayer};

handle_event(Player, _EventCallback) ->
    {ok, Player}.

get_dragon_power(Player) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{real_combat_power = CombatPower} = StatusDragon,
    CombatPower.

gm_add_dragon_equip(Status) ->
    case data_dragon:get_all_goods_type_id() of   
        GoodsTypeIds when is_list(GoodsTypeIds) andalso GoodsTypeIds =/= [] ->
            Fun = fun(GoodsTypeId, Acc) ->
                [{?TYPE_GOODS, GoodsTypeId, 1}|Acc]
            end,
            Reward = lists:foldl(Fun, [], GoodsTypeIds),
            lib_goods_api:send_reward_by_id(Reward, gm, Status#player_status.id);
        _->
            skip
    end.

get_equip_list(Player, NeedColor, NeedKind) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{id = PlayerId} = Player,
    #goods_status{dict = Dict} = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(
        PlayerId, ?GOODS_TYPE_DRAGON_EQUIP, ?GOODS_LOC_DRAGON_EQUIP, Dict),
    F = fun(EquipInfo, Acc) ->
        #goods{goods_id = GoodsTypeId, level = Level, color = Color, subtype = Subtype} = EquipInfo,
        if
            Color == NeedColor andalso Subtype == NeedKind ->
                Acc +1;
            true ->
                Acc
        end
        % case data_dragon:get_star_and_lv(Level) of
        %     {Lv, _Star} ->
        %         case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
        %             #base_dragon_lv_up{kind = Kind} -> 
        %                 if
        %                     Color == NeedColor andalso Kind == NeedKind ->
        %                         Acc +1;
        %                     true ->
        %                         Acc
        %                 end;
        %             _ ->
        %                 Acc
        %         end;
        %     _ ->
        %         Acc
        % end
    end,
    lists:foldl(F, 0, EquipList).