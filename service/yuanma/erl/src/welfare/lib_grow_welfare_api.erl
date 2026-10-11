%% ---------------------------------------------------------------------------
%% @doc lib_grow_welfare_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/2/16 0016
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_grow_welfare_api).

%% API
-export([
      handle_event/2
    , login_day/1
    , share_game/1
    , release_dating/1
    , level_up_ship/1
    , receive_ship_reward/2
    , equip_wash/2
    , assist_role/1
    , make_equip_suit/2
    , draw_bonus_monday/2
    , trigger_seal_status/2
    , trigger_marriage/1
]).

-export([
    trigger/2
]).

-include("common.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("boss.hrl").
-include("figure.hrl").
-include("guild.hrl").

handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    NewPS = lib_grow_welfare:auto_trigger(PS),
    {ok, NewPS};
%% 完成转生
handle_event(PS, #event_callback{type_id = ?EVENT_TURN_UP}) ->
    #player_status{figure = #figure{turn = Turn}} = PS,
    trigger(PS, {turn, Turn});
%% 加入结社
handle_event(PS, #event_callback{type_id = TypeId}) when TypeId == ?EVENT_JOIN_GUILD orelse TypeId == ?EVENT_CREATE_GUILD ->
    trigger(PS, {join_guild, 1});

% 经验本进入就算
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_ENTER,
    data = #callback_dungeon_enter{dun_type = ?DUNGEON_TYPE_EXP_SINGLE, count = Count}}) ->
    trigger(PS, {dun_type, ?DUNGEON_TYPE_EXP_SINGLE, Count});

handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = CallBackData}) ->
    #callback_dungeon_succ{dun_type = DunType, dun_id = DunId, count = Count} = CallBackData,
    case DunType of
        %% 通关万物有灵(材料本,精灵本)
        ?DUNGEON_TYPE_SPRITE_MATERIAL ->
            trigger(PS, {dun_type, DunType, Count});
        %% 通关仙缘副本
        ?DUNGEON_TYPE_COUPLE ->
            trigger(PS, {dun_type, DunType, Count});
        %% 通关御魂塔
        ?DUNGEON_TYPE_RUNE2 ->
            trigger(PS, {dun_id, DunId, Count});
        %% 通关财源滚滚
        ?DUNGEON_TYPE_COIN ->
            trigger(PS, {dun_type, DunType, Count});
        %% 通关神纹副本
        ?DUNGEON_TYPE_DRAGON ->
            trigger(PS, {dun_type, DunType, Count});
        %% 激活被动技能
        ?DUNGEON_TYPE_DEVIL_INSIDE ->
            trigger(PS, {dun_id, DunId, Count});
        _ ->
            %% 通过资源副本
            case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                true ->
                    trigger(PS, {dun_type, DunType, Count});
                false ->
                    {ok, PS}
            end
    end;
handle_event(PS, #event_callback{type_id = ?EVENT_JOIN_ACT, data = CallBackData}) ->
    #callback_join_act{type = ActModule} = CallBackData,
    case ActModule of
        %% 参加午间派对
        ?MOD_MIDDAY_PARTY ->
            trigger(PS, {enter_midday_party, 1});
        %% 参加结社晚宴
        ?MOD_GUILD_ACT ->
            trigger(PS, {enter_guild_feast, 1});
        %% 参与圣域夺宝(领地夺宝)
        ?MOD_TERRITORY ->
            trigger(PS, {enter_territory, 1});
        %% 参与九魂妖塔
        ?MOD_NINE ->
            trigger(PS, {enter_nine, 1});
        %% 参与尊神战场(圣灵战场)
        ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
            trigger(PS, {enter_holy_spirit, 1});
        %% 参与巅峰竞技
        ?MOD_TOPPK ->
            trigger(PS, {enter_top_pk, 1});
        _ ->
            {ok, PS}
    end;
handle_event(PS, #event_callback{type_id = ?EVENT_BOSS_KILL, data = CallBackData}) ->
    #callback_boss_kill{boss_type = BossType} = CallBackData,
    case BossType of
        %% 击杀蛮荒大妖
        ?BOSS_TYPE_FORBIDDEN ->
            trigger(PS, {boss_type, BossType, 1});
        %% 击杀跨服异域大妖 ->
        ?BOSS_TYPE_KF_SANCTUARY ->
            trigger(PS, {boss_type, BossType, 1});
        _ ->
            {ok, PS}
    end;
handle_event(PS,  #event_callback{type_id = ?EVENT_EQUIP_COMPOSE, data = #callback_equip_compose{goods_list = GiveGoodsInfoList}}) ->
    trigger(PS, {compose_equip, GiveGoodsInfoList});
handle_event(PS, _) ->
    {ok, PS}.

%% 登录天数
login_day(PS) ->
    Day = lib_player_login_day:get_player_login_days(PS),
    trigger(PS, {login_day, Day}).

%% 进行分享
share_game(PS) ->
    trigger(PS, {share_game, 1}).

%% 发布征婚信息
release_dating(PS) ->
    trigger(PS, {release_dating, 1}).

%% 升级船只
level_up_ship(PS) ->
    trigger(PS, {level_up_ship, 1}).

%% 领取巡航奖励
receive_ship_reward(PS, Num) ->
    trigger(PS, {receive_ship_reward, Num}).

%% 进行洗炼
equip_wash(PS, Num) ->
    trigger(PS, {equip_wash, Num}).

%% 协助玩家(boss协助和巡航协助)
assist_role(PS) ->
    trigger(PS, {assist_role, 1}).

%% 激活屠魔套装
make_equip_suit(PS, SuitList) ->
    trigger(PS, {equip_suit, SuitList}).

%% 参与周一大奖
draw_bonus_monday(PS, Num) ->
    trigger(PS, {bonus_monday, Num}).

%% 圣印
trigger_seal_status(PS,  SealList) ->
    trigger(PS, {seal_status, SealList}).

%% 寻找一名伴侣完成结婚
trigger_marriage(Ps) ->
    trigger(Ps, {marriage, 1}).

trigger(PS, Args) ->
    NewPS = lib_grow_welfare:trigger_task(PS, Args),
    {ok, NewPS}.


