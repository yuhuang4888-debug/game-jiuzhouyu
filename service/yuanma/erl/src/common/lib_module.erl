%%-----------------------------------------------------------------------------
%% @Module  :       lib_module
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-10-27
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_module).

-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("def_fun.hrl").
-include("boss.hrl").

-compile([export_all]).

get_config(T) ->
    case T of
        {?MOD_EQUIP, 1} -> 4;                           %% 装备强化
        {?MOD_EQUIP, 2} -> 1;                           %% 装备洗炼
        {?MOD_EQUIP, 3} -> 400;                         %% 装备进阶
        {?MOD_EQUIP, 4} -> 1;                         %% 装备宝石镶嵌
        {?MOD_EQUIP, 5} -> 1;                         %% 装备宝石精炼
        {?MOD_EQUIP, 8} -> 420;                         %% 装备铸灵
        {?MOD_EQUIP, 9} -> 480;                         %% 装备觉醒
        {?MOD_EQUIP, 10} -> 480;                        %% 装备唤魔
        {?MOD_MOUNT, 1} -> 10;                          %% 坐骑
        {?MOD_MOUNT_EQUIP, 1} -> 270;                   %% 坐骑装备
        {?MOD_PET, 1} -> 12;                            %% 宠物
        {?MOD_PET, 2} -> 240;                           %% 精灵飞行器
        {?MOD_PET, 3} -> 310;                           %% 精灵翅膀
        {?MOD_PET, 4} -> 270;                           %% 精灵装备
        {?MOD_WING,  1} -> 40;                          %% 翅膀
        {?MOD_TALISMAN,  1} -> 50;                      %% 法宝
        {?MOD_GODWEAPON, 1} -> 110;                     %% 神兵
        {?MOD_RELA,  1} -> 0;                           %% 好友社交
        {?MOD_FLOWER, 1} -> 0;                          %% 鲜花
        {?MOD_NOON_QUIZ, 0} -> 60;                      %% 中午答题
        {?MOD_ACTIVITY, 0} -> 1;                        %% 日常开放
        {?MOD_ACTIVITY, 1} -> 1;                        %% 日常活跃度找回
        {?MOD_RESOURCE_BACK, 1} -> 1;                   %% 资源找回
        {?MOD_ACHIEVEMENT,   1} -> 30;                  %% 成就
        {?MOD_ETERNAL_VALLEY, 1} -> 1;                 %% 永恒碑谷
        {?MOD_RANK,  1} -> 60;                          %% 榜单  
        {?MOD_ADVENTURE_BOOK,  1} -> 1;                 %% 冒险之书
        {?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY} -> 120;    %% 众仙云购/幸运之星
        {?MOD_LIMIT_SHOP, 1} -> 60;                     %% 神秘限购 弃用
        {?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_TREASURE_EVALUATION} -> 60;                       %% 幸运鉴宝
        {?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_PERFECT_LOVER} -> 80;                             %% 完美恋人（三世情缘）
        {?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_COLLECT} -> 75;                                   %% 收集活动
        {?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_RECHARGE_CONSUME} -> 60;                          %% 充值消费活动
        {?MOD_HOUSE, 1} -> 200;                                                             %% 家园
        {?MOD_HOLY_GHOST, 1} -> 230;                                                          %% 圣灵
        {?MOD_SAINT, 1} -> data_saint:get_cfg(open_lv);                                     %% 圣者殿
        {?MOD_BOSS, ?BOSS_TYPE_WORLD} -> 50;             %% 世界boss开启
        {?MOD_TO_BE_STRONG, 1} ->100;                    %% 我要变强
        {?MOD_SOUL, 1} -> 290;                           %% 聚魂
        _ -> 999999999
    end.

get_open_lv(ModId, SubId) ->
    get_config({ModId, SubId}).

is_open(ModId, SubId, RoleLv) ->
    OpenLv = get_open_lv(ModId, SubId),
    RoleLv >= OpenLv.

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    OpenList = get_open_modlues(Player#player_status.figure#figure.lv),
    NewPlayer = handle_module_open(Player, OpenList),
    {ok, NewPlayer};

handle_event(Player, _) ->
    {ok, Player}.



get_open_modlues(Lv) ->
    List
    = [
        {data_top_pk:get_kv(default, open_lv), {?MOD_TOPPK, 0}}
    ],
    [M || {L, M} <- List, L =:= Lv].

handle_module_open(Ps, [{Mod, Sub}|T]) ->
    case {Mod, Sub} of
        {?MOD_TOPPK, 0} ->
            mod_top_pk_match_room:get_act_info(Ps#player_status.sid),
            NewPs = Ps;
        _ ->
            NewPs = Ps
    end,
    mod_activitycalen:send_act_status(Mod, Sub, NewPs#player_status.id, NewPs#player_status.figure#figure.lv), %% 处理日常红点
    handle_module_open(NewPs, T);
handle_module_open(Ps, []) -> Ps.
