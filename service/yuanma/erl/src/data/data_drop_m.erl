%% ---------------------------------------------------------------------------
%% @doc data_drop_m.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-02-28
%% @deprecated 掉落手动配置
%% ---------------------------------------------------------------------------
-module(data_drop_m).

-compile(export_all).

-include("goods.hrl").
-include("predefine.hrl").
-include("scene.hrl").

%% 获得拾取时间
get_pick_time(SceneId, Type, GoodsTypeId) ->
    case is_manual_pick(SceneId) of
        true -> get_pick_time(Type, GoodsTypeId);
        false -> 0
    end.

%% 拾取时间
%% @param Type ?TYPE_GOODS | ?TYPE_COIN
get_pick_time(_Type, GoodsTypeId) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{color = ?ORANGE} -> 100;
        #ets_goods_type{color = ?RED} -> 150;
        #ets_goods_type{color = ?DARK_GOLD} -> 350;
        #ets_goods_type{color = ?PINK} -> 350;
        #ets_goods_type{color = ?DIAMOND} -> 350;
        #ets_goods_type{} -> 0;
        _ -> 0
    end.

%% 是否手动拾取##用于控制拾取时间
is_manual_pick(_SceneId) -> true.
    % lib_boss:is_in_new_outside_boss(SceneId) orelse lib_boss:is_in_special_boss(SceneId).

%% 获得伤害占比
%% @return {是否需要伤害占比, 伤害万分比(玩家的伤害/总伤害)}
get_pick_hurt_ratio(SceneId) -> 
    case data_scene:get(SceneId) of
        % 百分之2的伤害
        #ets_scene{type = ?SCENE_TYPE_SANCTUARY} -> 0.002;
        #ets_scene{type = ?SCENE_TYPE_SANCTUM} -> 
            case data_sanctum:get_value(hurt_percent_pick_reward) of
                Percent when is_integer(Percent) andalso Percent > 0 -> Percent / 100;
                _ -> 0.001
            end;
        _ -> 0
    end.

% %% 获得掉落等级
% %% @param MonLv 怪物等级
% %% @param WorldLv 世界等级
% get_drop_lv(SceneId, MonLv, WorldLv) ->
%     case data_scene:get(SceneId) of
%         #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} -> WorldLv;
%         _ -> MonLv
%     end.

%% 获得掉落等级
%% @param MonLv 怪物等级
%% @param WorldLv 世界等级
%% @param ModLevel 功能内部等级
get_drop_lv(Mid, MonLv, WorldLv, RoleLv, ModLevel) ->
    case data_mon:get(Mid) of
        #mon{drop_lv_type = ?MON_DROP_LV_TYPE_MON_LV} -> MonLv;
        #mon{drop_lv_type = ?MON_DROP_LV_TYPE_WORLD_LV} -> WorldLv;
        #mon{drop_lv_type = ?MON_DROP_LV_TYPE_ROLE_LV} -> RoleLv;
        #mon{drop_lv_type = ?MON_DROP_LV_TYPE_EUDEMONS_LV} -> ModLevel;
        _ -> MonLv
    end.