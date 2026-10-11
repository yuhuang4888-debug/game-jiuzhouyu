-module(lib_push_gift_api).

-include("push_gift.hrl").
-include("common.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("def_module.hrl").
-compile(export_all).

handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE}) ->
	{_, LastPS} = lib_push_gift:trigger_push_gift(PS, die_count_gold_cnt, 1),  %% 触发充值类型
	{ok, LastPS};
handle_event(#player_status{figure = #figure{lv = Lv}} = PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    {ok, NewPS} = lib_push_gift:trigger_push_gift(PS, level, Lv),
	{_, LastPS} = lib_push_gift:trigger_push_gift(NewPS, die_count_gold_cnt, 1),  %% 触发充值类型
    {ok, LastPS};
handle_event(PS, #event_callback{type_id = ?EVENT_MONEY_CONSUME_CURRENCY, data = Data}) ->
	#callback_currency_cost{consume_type = _Type, currency_id = CostGoodsId, cost = Cost} = Data,
    {ok, NewPS} = lib_push_gift:trigger_push_gift(PS, currency, {CostGoodsId, Cost}),
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data})  ->
    #callback_dungeon_succ{help_type=HelpType, dun_id = DunId} = Data,
    if
        HelpType == ?HELP_TYPE_NO ->
            {ok, NewPS} = lib_push_gift:trigger_push_gift(PS, dungeon_id, DunId);
        true -> 
            NewPS = PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_TURN_UP}) when is_record(PS, player_status) ->
    {_, NewPS} = lib_push_gift:trigger_push_gift(PS, turn, 1),
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_VIP}) when is_record(PS, player_status) ->
    {_, NewPS} = lib_push_gift:trigger_push_gift(PS, register_days, 1),
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_PLAYER_DIE}) when is_record(PS, player_status) ->
	DieCount = mod_daily:get_count(PS#player_status.id, ?MOD_BASE, 1),
	if
		DieCount == 1 ->
%%			Value = lib_recharge_data:get_total(PS#player_status.id),
			{_, NewPS} = lib_push_gift:trigger_push_gift(PS, die_count_gold_cnt, 1),  %% 触发充值类型
			{ok, NewPS};
		true ->
			{ok, PS}
	end;
handle_event(PS, _) ->
    {ok, PS}.

%% 触发伙伴激活
partner_active(PS, PartnerId) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, partner_cnt, 1),
	{_, PS2} = lib_push_gift:trigger_push_gift(PS1, partner_id, PartnerId),
	PS2.

%% 伙伴升阶
partner_stage_up(PS, PartnerId) ->
    {_, PS1} = lib_push_gift:trigger_push_gift(PS, partner_id_stage, PartnerId),
    PS1.

%% 触发神兵激活
holyoran_active(PS, HolyoranId) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, holyoran_cnt, 1),
	{_, PS2} = lib_push_gift:trigger_push_gift(PS1, holyoran_id, HolyoranId),
	PS2.

%% 神兵升级
holyoran_up(PS, Lv) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, holyorgan_up_cnt, Lv),
	PS1.

artifact_up(PS, Lv)  ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, artifact_up_cnt, Lv),
	PS1.

%% 触发精灵激活
mate_active(PS, MateId) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, mate_cnt, 1),
	{_, PS2} = lib_push_gift:trigger_push_gift(PS1, mate_id, MateId),
	PS2.

mate_up(Player, NewStage, NewStar) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(Player, meta_up_cnt, NewStage * 100+ NewStar),
	PS1.

%% 坐骑激活
mount_active(PS, MountId) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, mount_cnt, MountId),
	PS1.

%% 坐骑升阶
mount_up(PS, NewStage, NewStar) ->
%%	?PRINT("mount_up ~p~n", [{ NewStage, NewStar}]),
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, mount_up_cnt, NewStage * 100+ NewStar),
	PS1.

%%  翅膀升级
flv_up(PS, _NewStage, NewStar) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, fly_up_cnt, NewStar),
	PS1.

%% 图鉴激活
mon_pic_active(PS, Color, Id) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, mon_color_pic, {Color, Id}),
	PS1.

%% 激活功能
module_open(PS, Id) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, module_open, Id),
	PS1.

%% 跨点在线
update_login_days(PS) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, register_days, 1),
	PS1.

%% 装备洗练升段
equip_wash_upgrade(PS, EquipPos) ->
    {_, PS1} = lib_push_gift:trigger_push_gift(PS, wash_cnt, EquipPos),
    {_, PS2} = lib_push_gift:trigger_push_gift(PS1, one_wash_cnt, EquipPos),
    PS2.

%% 装备套装更改
equip_suit(PS) ->
    {_, PS1} = lib_push_gift:trigger_push_gift(PS, suit_cnt, 1),
    PS1.

%% 幻饰强化升级
decoration_level_up(PS, Lv) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, decoration_level, Lv),
	PS1.

%% 勋章等级升级
medal_level_up(PS, Lv) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, medal_level, Lv),
	PS1.

%% 圣兽领狩猎等级升级
eudemons_level_up(PS, Lv) ->
	{_, PS1} = lib_push_gift:trigger_push_gift(PS, eudemons_level, Lv),
	PS1.

 
reload_file() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() -> 
        F = fun(E) ->
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_push_gift, check_push_gift_active, []),
            timer:sleep(100)
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok.

%% 清空礼包过期状态
gm_clear_expire(PS) ->
	#player_status{id = RoleID} = PS,
	db:execute(io_lib:format("update `role_push_gift` set expire_time = 0 where role_id = ~p", [RoleID])).


%% 根据类型获取推送礼包
get_push_gift_by_type(PS, Type) ->
	#player_status{push_gift_status = #push_gift_status{active_list = ActiveList}} = PS,
	F = fun(#p_g_info{key = {CType, _}} = Info, ResList) ->
		case CType =:= Type of 
			true -> [Info | ResList];
			_ -> ResList
		end
	end, 
	lists:foldl(F, [], ActiveList).


%% 根据类型和子类型获取推送礼包
get_push_gift(PS, Type, SubType) ->
	#player_status{push_gift_status = #push_gift_status{active_list = ActiveList}} = PS,
	F = fun(#p_g_info{key = {CType, CSubType}} = Info, ResList) ->
		case CType =:= Type andalso CSubType =:= SubType of 
			true -> [Info | ResList];
			_ -> ResList
		end
	end, 
	lists:foldl(F, [], ActiveList).