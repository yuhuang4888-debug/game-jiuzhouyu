
%%-----------------------------------------------------------------------------
%% @Module  :       lib_push_gift
%% @Author  :       Lxl
%% @Email   :       
%% @Created :       
%% @Description:    礼包推送
%%-----------------------------------------------------------------------------
-module(lib_push_gift).

-include("push_gift.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("mount.hrl").
-include("timer.hrl").
-include("eudemons_land.hrl").
-include("eudemons.hrl").
-compile(export_all).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 新增礼包推送：新增类型
%% 1：增加新的类型宏变量，例如 -define(PUSH_GIFT_TRI_PARTNER_CNT, 10).
%% 2：在get_data_transfer_map函数加上对应映射
%% 3：如果新增的是可以根据模块获取历史数据的，在get_data函数加上历史数据的获取，need_db_trigger_value修改
%% 4: 如果新增的触发类型需要增加新的分类类型，需要新增 ?if_tri_class_xxx, 并且在
%%    (default_trigger_values, is_satisfy, to_trigger_class_type)增加相应代码
%% 5: trigger_value_add 只有需要自己记录统计数据到数据库中，才需要改这个函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 礼包触发类型(定好之后不能改动,写数据库的)
-define(PUSH_GIFT_TRI_PARTNER_CNT, 10).  %% 伙伴激活次数
-define(PUSH_GIFT_TRI_PARTNER_ID, 11).  %% 具体伙伴激活
-define(PUSH_GIFT_TRI_HOLYORGAN_CNT, 12).  %% 神兵次数
-define(PUSH_GIFT_TRI_HOLYORGAN_ID, 13).  %% 具体神兵
-define(PUSH_GIFT_TRI_MATE_CNT, 14).  %% 精灵次数
-define(PUSH_GIFT_TRI_MATE_ID, 15).  %% 具体精灵
-define(PUSH_GIFT_TRI_MOUNT_CNT, 16).  %% 坐骑激活次数
-define(PUSH_GIFT_TRI_PARTNER_ID_STAGE, 17).  %% 指定伙伴升阶
-define(PUSH_GIFT_TRI_LEVEL, 40).  %% 等级
-define(PUSH_GIFT_TRI_TURN, 41).  %% 转生
-define(PUSH_GIFT_TRI_MODULE_OPEN, 50).  %% 功能开放
-define(PUSH_GIFT_TRI_COST_CURRENCY, 60).  %% 特殊货币消耗
-define(PUSH_GIFT_TRI_REGISTER_DAYS, 70).  %% 玩家注册天数
-define(PUSH_GIFT_TRI_DUNGEON_ID_SUCC, 80).  %% 具体副本id完成
-define(PUSH_GIFT_TRI_MON_PIC_COLOR_CNT, 90).  %% 某个品质图鉴数量
-define(PUSH_GIFT_TRI_WASH_CNT, 100).  %% 装备总洗练阶数
-define(PUSH_GIFT_TRI_ONE_WASH_CNT, 101).  %% 任意单件装备洗练阶数
-define(PUSH_GIFT_TRI_SUIT_CNT, 102).         %% 套装阶数
-define(PUSH_GIFT_TRI_MOUNT_STAGE_CNT, 103).  %% 坐骑阶数星数   阶数 * 100 + 星数
-define(PUSH_GIFT_TRI_MATE_STAGE_CNT,  104).  %% 精灵阶数星数   阶数 * 100 + 星数
-define(PUSH_GIFT_TRI_HOLYORGAN_UP_CNT,  105).  %% 神兵等级
-define(PUSH_GIFT_TRI_FLY_UP_CNT,  106).  %% 翅膀等级等级
-define(PUSH_GIFT_TRI_ARTIFACT_UP_CNT,  107).  %% 圣器等级
-define(PUSH_GIFT_TRI_GOLD_NUM_CNT,  108).  %% 充值金额触发
-define(PUSH_GIFT_TRI_DECORATION_LEVEL,    109).  %% 幻饰强化等级触发
-define(PUSH_GIFT_TRI_MEDAL_LEVEL, 110).     %% 勋章等级触发
-define(PUSH_GIFT_TRI_EUDEMONS_LEVEL, 111).  %% 圣兽岭狩猎等级触发


%% 礼包触发元素分类类型
-define(PUSH_GIFT_TRI_CLASS_CNT, 1).  %% 次数累积
-define(PUSH_GIFT_TRI_CLASS_ITEM_IN, 2).  %% item in list
-define(PUSH_GIFT_TRI_CLASS_FIX_VALUE, 3).  %% 固定数值(整形)
-define(PUSH_GIFT_TRI_CLASS_KEY_VAL_CNT, 4).  %% key对应的val次数累积
-define(PUSH_GIFT_TRI_CLASS_INTERVAL_VAL_CNT, 5).  %% Interval 区间
%% 一些内联函数
-define(gift_is_expire(NowTime, EndTime, ExpireTime), 
  case NowTime < EndTime orelse (ExpireTime > 0 andalso NowTime < ExpireTime) of 
      true -> false; _ -> true
  end).
-define(grade_buy_cnt(GradeId, GradeList), 
  case lists:keyfind(GradeId, #p_g_reward.grade_id, GradeList) of 
      false -> 0; DFindItem -> DFindItem#p_g_reward.buy_cnt
  end).

%% 是否是某个分类类型
-define(if_tri_class_cnt(TriggerType), 
	TriggerType == ?PUSH_GIFT_TRI_PARTNER_CNT orelse
	TriggerType == ?PUSH_GIFT_TRI_HOLYORGAN_CNT orelse
	TriggerType == ?PUSH_GIFT_TRI_MATE_CNT orelse 
	TriggerType == ?PUSH_GIFT_TRI_MOUNT_CNT orelse 
	TriggerType == ?PUSH_GIFT_TRI_WASH_CNT orelse 
	TriggerType == ?PUSH_GIFT_TRI_ONE_WASH_CNT).
-define(if_tri_class_item_in(TriggerType), 
	TriggerType == ?PUSH_GIFT_TRI_PARTNER_ID orelse
	TriggerType == ?PUSH_GIFT_TRI_HOLYORGAN_ID orelse
	TriggerType == ?PUSH_GIFT_TRI_MATE_ID orelse
	TriggerType == ?PUSH_GIFT_TRI_MODULE_OPEN orelse
	TriggerType == ?PUSH_GIFT_TRI_DUNGEON_ID_SUCC).
-define(if_tri_class_fix_value(TriggerType), 
	TriggerType == ?PUSH_GIFT_TRI_LEVEL orelse
	TriggerType == ?PUSH_GIFT_TRI_TURN orelse
	TriggerType == ?PUSH_GIFT_TRI_MOUNT_STAGE_CNT orelse
	TriggerType == ?PUSH_GIFT_TRI_MATE_STAGE_CNT orelse
	TriggerType == ?PUSH_GIFT_TRI_HOLYORGAN_UP_CNT orelse
	TriggerType == ?PUSH_GIFT_TRI_FLY_UP_CNT orelse
	TriggerType == ?PUSH_GIFT_TRI_ARTIFACT_UP_CNT orelse
	TriggerType == ?PUSH_GIFT_TRI_REGISTER_DAYS orelse
	TriggerType == ?PUSH_GIFT_TRI_DECORATION_LEVEL orelse
	TriggerType == ?PUSH_GIFT_TRI_MEDAL_LEVEL orelse
	TriggerType == ?PUSH_GIFT_TRI_EUDEMONS_LEVEL).
-define(if_tri_class_key_val_cnt(TriggerType), 
	TriggerType == ?PUSH_GIFT_TRI_COST_CURRENCY orelse
	TriggerType == ?PUSH_GIFT_TRI_MON_PIC_COLOR_CNT orelse 
	TriggerType == ?PUSH_GIFT_TRI_PARTNER_ID_STAGE orelse 
	TriggerType == ?PUSH_GIFT_TRI_SUIT_CNT).
-define(if_tri_class_interval_val_cnt(TriggerType),  %% 区间数据
	TriggerType == ?PUSH_GIFT_TRI_GOLD_NUM_CNT
	).
%% 分类类型的默认触发数据
-define(default_trigger_values(TriggerClass), 
	case TriggerClass of
		?PUSH_GIFT_TRI_CLASS_CNT -> 0;
		?PUSH_GIFT_TRI_CLASS_ITEM_IN -> [];
		?PUSH_GIFT_TRI_CLASS_FIX_VALUE -> 0;
		?PUSH_GIFT_TRI_CLASS_KEY_VAL_CNT -> []
	end).

%% 可以通过其他模块获取数据的，可以不写触发数据到数据库
-define(need_db_trigger_value(TriggerType), 
	TriggerType == none).

%% todo  都要添加
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 触发类型相关的数据，新增加触发类型，一下函数进行相应添加 %
%% 伙伴激活数量
get_data(PS, ?PUSH_GIFT_TRI_PARTNER_CNT, _) ->
	case lib_companion:get_companion_active_cnt(PS) of
		0 -> 0; Cnt -> Cnt
	end;
%% 已激活伙伴id列表
get_data(PS, ?PUSH_GIFT_TRI_PARTNER_ID, _) ->
	case lib_companion:get_companion_active_list(PS) of
		[] -> []; IdList -> IdList
	end;
%% 神兵激活数量
get_data(PS, ?PUSH_GIFT_TRI_HOLYORGAN_CNT, _) ->
	case lib_mount_api:get_mount_active_cnt(PS, ?HOLYORGAN_ID) of 
		0 -> 0; Cnt -> Cnt
	end;
%% 已激活神兵id列表
get_data(PS, ?PUSH_GIFT_TRI_HOLYORGAN_ID, _) ->
	case lib_mount_api:get_mount_active_id_list(PS, ?HOLYORGAN_ID) of 
		[] -> []; IdList -> IdList
	end;
%% 精灵激活数量
get_data(PS, ?PUSH_GIFT_TRI_MATE_CNT, _) ->
	case lib_mount_api:get_mount_active_cnt(PS, ?MATE_ID) of 
		0 -> 0; Cnt -> Cnt
	end;
%% 已激活精灵id列表
get_data(PS, ?PUSH_GIFT_TRI_MATE_ID, _) ->
	case lib_mount_api:get_mount_active_id_list(PS, ?MATE_ID) of 
		[] -> []; IdList -> IdList
	end;
get_data(PS, ?PUSH_GIFT_TRI_MOUNT_CNT, _) ->
	case lib_mount_api:get_mount_active_cnt(PS, ?MOUNT_ID) of 
		0 -> 0; Cnt -> Cnt
	end;
get_data(PS, ?PUSH_GIFT_TRI_PARTNER_ID_STAGE, {GiftId, SubId, _ActST, _ActEndT}) ->
	#base_push_gift{condition = Condition} = data_push_gift:get_push_gift(GiftId, SubId),
	case ?get_trigger_values(Condition) of 
		{_, partner_id_stage, {PartnerId, _}} ->
			Stage = lib_companion:get_companion_stage_by_id(PS, PartnerId),
			[{PartnerId, Stage}];
		_ -> []
	end;
%% 已激活module_list
get_data(PS, ?PUSH_GIFT_TRI_MODULE_OPEN, _) ->
	case lib_module_open:get_module_open_id_list(PS) of 
		[] -> []; IdList -> IdList
	end;
%% 玩家等级
get_data(PS, ?PUSH_GIFT_TRI_LEVEL, _) ->
	PS#player_status.figure#figure.lv;
%% 转生等级
get_data(PS, ?PUSH_GIFT_TRI_TURN, _) ->
	PS#player_status.figure#figure.turn;
%% 特殊货币消耗数量
get_data(PS, ?PUSH_GIFT_TRI_COST_CURRENCY, {GiftId, SubId, ActST, ActEndT}) ->
	#base_push_gift{condition = Condition} = data_push_gift:get_push_gift(GiftId, SubId),
	case ?get_trigger_values(Condition) of 
		{_, currency, {CurrencyId, _}} ->
			CurrencyCost = lib_consume_currency_data:get_consume_between(PS#player_status.id, CurrencyId, ActST, ActEndT),
			[{CurrencyId, CurrencyCost}];
		_ -> []
	end;
%% 注册天数
get_data(PS, ?PUSH_GIFT_TRI_REGISTER_DAYS, _) ->
	RegisterTime = PS#player_status.reg_time,
	utime:diff_days(RegisterTime) + 1;
%% 完成副本id
get_data(PS, ?PUSH_GIFT_TRI_DUNGEON_ID_SUCC, {GiftId, SubId, _ActST, _ActEndT}) ->
	#base_push_gift{condition = Condition} = data_push_gift:get_push_gift(GiftId, SubId),
	case ?get_trigger_values(Condition) of 
		{_, dungeon_id, DungeonId} ->
			case lib_dungeon_api:is_dungeon_success(PS, DungeonId) of 
				true ->
					[DungeonId];
				_ -> []
			end;
		_ -> []
	end;
%% 某品质图鉴数量
get_data(PS, ?PUSH_GIFT_TRI_MON_PIC_COLOR_CNT, {GiftId, SubId, _ActST, _ActEndT}) ->
	#base_push_gift{condition = Condition} = data_push_gift:get_push_gift(GiftId, SubId),
	case ?get_trigger_values(Condition) of 
		{_, mon_color_pic, {Color, _Count}} ->
			PicIdList = lib_mon_pic:get_mon_pic_list_by_color(PS, Color),
			[{Color, length(PicIdList)}];
		_ -> []
	end;
%% 装备总洗练段数
get_data(PS, ?PUSH_GIFT_TRI_WASH_CNT, _) ->
	lib_equip_api:get_equip_wash_total_duan(PS);
%% 任意单件装备洗练段数(取最高)
get_data(PS, ?PUSH_GIFT_TRI_ONE_WASH_CNT, _) ->
	lib_equip_api:get_one_equip_wash_duan_high(PS);
%% 套装阶数
get_data(PS, ?PUSH_GIFT_TRI_SUIT_CNT, {GiftId, SubId, _ActST, _ActEndT}) ->
	#base_push_gift{condition = Condition} = data_push_gift:get_push_gift(GiftId, SubId),
	case ?get_trigger_values(Condition) of
		{_, suit_cnt, {{Lv, SLv}, _}} ->
			Cnt = lib_equip_api:get_suit_cnt_between(PS, Lv, SLv),
			[{{Lv, SLv}, Cnt}];
		_ -> []
	end;
%% 坐骑阶数 *100 + 星数
get_data(PS, ?PUSH_GIFT_TRI_MOUNT_STAGE_CNT, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	#player_status{status_mount = MountList} = PS,
%%	?PRINT("MountList ~p~n", [MountList]),
	case lists:keyfind(?MOUNT_ID, #status_mount.type_id, MountList) of
		#status_mount{stage = Stage, star = Star} ->
			Stage * 100 + Star;
		_ ->
			0
	end;
%% 精灵阶数 *100 + 星数
get_data(PS, ?PUSH_GIFT_TRI_MATE_STAGE_CNT, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	#player_status{status_mount = MountList} = PS,
	case lists:keyfind(?MATE_ID,  #status_mount.type_id, MountList) of
		#status_mount{stage = Stage, star = Star} ->
			Stage * 100 + Star;
		_ ->
			0
	end;
%% 神兵星数
get_data(PS, ?PUSH_GIFT_TRI_HOLYORGAN_UP_CNT, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	#player_status{status_mount = MountList} = PS,
	case lists:keyfind(?HOLYORGAN_ID,  #status_mount.type_id, MountList) of
		#status_mount{star = Star} ->
			Star;
		_ ->
			0
	end;
%% 翅膀星数
get_data(PS, ?PUSH_GIFT_TRI_FLY_UP_CNT, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	#player_status{status_mount = MountList} = PS,
	case lists:keyfind(?FLY_ID,  #status_mount.type_id, MountList) of
		#status_mount{star = Star} ->
			Star;
		_ ->
			0
	end;
%% 圣器星数
get_data(PS, ?PUSH_GIFT_TRI_ARTIFACT_UP_CNT, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	#player_status{status_mount = MountList} = PS,
	case lists:keyfind(?ARTIFACT_ID,  #status_mount.type_id, MountList) of
		#status_mount{star = Star} ->
			Star;
		_ ->
			0
	end;
%% 充值金额数量
get_data(PS, ?PUSH_GIFT_TRI_GOLD_NUM_CNT, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	lib_recharge_data:get_total(PS#player_status.id);

%% 幻饰强化等级
get_data(PS, ?PUSH_GIFT_TRI_DECORATION_LEVEL, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	lib_decoration_api:get_total_decoration_level(PS);

%% 勋章等级
get_data(PS, ?PUSH_GIFT_TRI_MEDAL_LEVEL, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	#player_status{figure = #figure{medal_id = MedelId}} = PS,
	MedelId;

%% 圣兽岭狩猎等级
get_data(PS, ?PUSH_GIFT_TRI_EUDEMONS_LEVEL, {_GiftId, _SubId, _ActST, _ActEndT}) ->
	#player_status{eudemons_boss = #eudemons_boss{lv = Lv}} = PS,
	Lv;

	
get_data(_PS, _, _) ->
	none.

%% 触发数据的处理
%% 叠加
trigger_value_add(TriggerType, TriggerValues, AddValue) when 
				?if_tri_class_cnt(TriggerType)
				andalso is_integer(TriggerValues) andalso is_integer(AddValue) ->
	TriggerValues+AddValue;
%% 具体id记录
trigger_value_add(TriggerType, TriggerValues, AddValue) when 
				?if_tri_class_item_in(TriggerType)
				andalso is_list(TriggerValues) ->
	[AddValue|lists:delete(AddValue, TriggerValues)];
%% 固定数值(整形)
trigger_value_add(TriggerType, _TriggerValues, AddValue) when 
				?if_tri_class_fix_value(TriggerType)
				andalso is_integer(AddValue) ->
	AddValue;
%% key_val_list
trigger_value_add(TriggerType, TriggerValues, AddValue) when 
				?if_tri_class_key_val_cnt(TriggerType)
				andalso is_list(TriggerValues) andalso is_tuple(AddValue) ->
	{Key, Val} = AddValue,
	case lists:keyfind(Key, 1, TriggerValues) of 
		{_, OldVal} when is_integer(OldVal) andalso is_integer(Val) ->
			lists:keyreplace(Key, 1, TriggerValues, {Key, Val+OldVal});
		false -> [{Key, Val}|TriggerValues];
		_ -> TriggerValues
	end;
trigger_value_add(_TriggerType, _TriggerValues, _TriggerVal) ->
	?ERR("unknow trigger value : ~p~n", [{_TriggerType, _TriggerValues, _TriggerVal}]),
	_TriggerVal.


is_statisfy(TriggerType, NeedValues, StaticVal) when 
				?if_tri_class_cnt(TriggerType)
				andalso is_integer(NeedValues) andalso is_integer(StaticVal) ->
	StaticVal >= NeedValues;
is_statisfy(TriggerType, NeedValues, StaticVal) when 
				?if_tri_class_item_in(TriggerType)
				andalso is_list(StaticVal) -> 
	lists:member(NeedValues, StaticVal);
is_statisfy(TriggerType, NeedValues, StaticVal) when 
				?if_tri_class_fix_value(TriggerType)
				andalso is_integer(NeedValues) andalso is_integer(StaticVal) ->
	StaticVal >= NeedValues;
is_statisfy(TriggerType, NeedValues, StaticVal) when 
				?if_tri_class_key_val_cnt(TriggerType)
				andalso is_list(StaticVal) ->
	{Key, ValCon} = NeedValues,
	case lists:keyfind(Key, 1, StaticVal) of 
		{_, Val} when is_integer(ValCon) andalso Val >= ValCon -> true;
		_ -> false
	end;
is_statisfy(TriggerType, NeedValues, StaticVal) when  %% 范围数据
	?if_tri_class_interval_val_cnt(TriggerType)
		andalso is_integer(StaticVal) ->
	{MinV, MaxV} = NeedValues,
	StaticVal >= MinV andalso StaticVal =< MaxV;
is_statisfy(_TriggerType, _NeedValues, _StaticVal) ->
	false.

%% 检查统计数据格式
check_static_value_format(TriggerType, StaticValue) when 
				?if_tri_class_cnt(TriggerType)
				andalso is_integer(StaticValue) ->
	true;
check_static_value_format(TriggerType, StaticValue) when 
				?if_tri_class_item_in(TriggerType)
				andalso is_list(StaticValue) ->
	true;
check_static_value_format(TriggerType, StaticValue) when 
				?if_tri_class_fix_value(TriggerType)
				andalso is_integer(StaticValue) ->
	true;
check_static_value_format(TriggerType, StaticValue) when 
				?if_tri_class_key_val_cnt(TriggerType)
				andalso is_list(StaticValue) ->
	true;
check_static_value_format(TriggerType, StaticValue) when
	?if_tri_class_interval_val_cnt(TriggerType)
		andalso is_integer(StaticValue) ->
	true;
check_static_value_format(_TriggerType, _StaticValue) ->
	?ERR("check_static_value_format : ~p~n", [{_TriggerType, _StaticValue}]),
	false.

%% 分类类型
to_trigger_class_type(TriggerType) ->
	if
		?if_tri_class_cnt(TriggerType) -> ?PUSH_GIFT_TRI_CLASS_CNT;
		?if_tri_class_item_in(TriggerType) -> ?PUSH_GIFT_TRI_CLASS_ITEM_IN;
		?if_tri_class_fix_value(TriggerType) -> ?PUSH_GIFT_TRI_CLASS_FIX_VALUE;
		?if_tri_class_key_val_cnt(TriggerType) -> ?PUSH_GIFT_TRI_CLASS_KEY_VAL_CNT;
		?if_tri_class_interval_val_cnt(TriggerType) -> ?PUSH_GIFT_TRI_CLASS_INTERVAL_VAL_CNT;
		true ->
			error
	end.

%% 添加新类型要添加
get_data_transfer_map() ->
	#{
		partner_cnt => ?PUSH_GIFT_TRI_PARTNER_CNT
		, ?PUSH_GIFT_TRI_PARTNER_CNT => partner_cnt
		, partner_id => ?PUSH_GIFT_TRI_PARTNER_ID
		, ?PUSH_GIFT_TRI_PARTNER_ID => partner_id
		, holyoran_cnt => ?PUSH_GIFT_TRI_HOLYORGAN_CNT
		, ?PUSH_GIFT_TRI_HOLYORGAN_CNT => holyoran_cnt
		, holyoran_id => ?PUSH_GIFT_TRI_HOLYORGAN_ID
		, ?PUSH_GIFT_TRI_HOLYORGAN_ID => holyoran_id
		, mate_cnt => ?PUSH_GIFT_TRI_MATE_CNT
		, ?PUSH_GIFT_TRI_MATE_CNT => mate_cnt
		, mate_id => ?PUSH_GIFT_TRI_MATE_ID
		, ?PUSH_GIFT_TRI_MATE_ID => mate_id
		, mount_cnt => ?PUSH_GIFT_TRI_MOUNT_CNT
		, ?PUSH_GIFT_TRI_MOUNT_CNT => mount_cnt
		, partner_id_stage => ?PUSH_GIFT_TRI_PARTNER_ID_STAGE
		, ?PUSH_GIFT_TRI_PARTNER_ID_STAGE => partner_id_stage
		, level => ?PUSH_GIFT_TRI_LEVEL
		, ?PUSH_GIFT_TRI_LEVEL => level 
		, module_open => ?PUSH_GIFT_TRI_MODULE_OPEN
		, ?PUSH_GIFT_TRI_MODULE_OPEN => module_open
		, currency => ?PUSH_GIFT_TRI_COST_CURRENCY
		, ?PUSH_GIFT_TRI_COST_CURRENCY => currency
		, register_days => ?PUSH_GIFT_TRI_REGISTER_DAYS
		, ?PUSH_GIFT_TRI_REGISTER_DAYS => register_days
		, turn => ?PUSH_GIFT_TRI_TURN
		, ?PUSH_GIFT_TRI_TURN => turn
		, dungeon_id => ?PUSH_GIFT_TRI_DUNGEON_ID_SUCC
		, ?PUSH_GIFT_TRI_DUNGEON_ID_SUCC => dungeon_id
		, mon_color_pic => ?PUSH_GIFT_TRI_MON_PIC_COLOR_CNT
		, ?PUSH_GIFT_TRI_MON_PIC_COLOR_CNT => mon_color_pic
		, wash_cnt => ?PUSH_GIFT_TRI_WASH_CNT
		, ?PUSH_GIFT_TRI_WASH_CNT => wash_cnt
		, one_wash_cnt => ?PUSH_GIFT_TRI_ONE_WASH_CNT
		, ?PUSH_GIFT_TRI_ONE_WASH_CNT => one_wash_cnt
		, suit_cnt => ?PUSH_GIFT_TRI_SUIT_CNT
		, ?PUSH_GIFT_TRI_SUIT_CNT => suit_cnt
		, mount_up_cnt => ?PUSH_GIFT_TRI_MOUNT_STAGE_CNT
		, ?PUSH_GIFT_TRI_MOUNT_STAGE_CNT => mount_up_cnt
		, meta_up_cnt => ?PUSH_GIFT_TRI_MATE_STAGE_CNT
		, ?PUSH_GIFT_TRI_MATE_STAGE_CNT => meta_up_cnt
		, holyorgan_up_cnt => ?PUSH_GIFT_TRI_HOLYORGAN_UP_CNT
		, ?PUSH_GIFT_TRI_HOLYORGAN_UP_CNT => holyorgan_up_cnt
		, fly_up_cnt => ?PUSH_GIFT_TRI_FLY_UP_CNT
		, ?PUSH_GIFT_TRI_FLY_UP_CNT => fly_up_cnt
		, artifact_up_cnt => ?PUSH_GIFT_TRI_ARTIFACT_UP_CNT
		, ?PUSH_GIFT_TRI_ARTIFACT_UP_CNT => artifact_up_cnt
		, die_count_gold_cnt => ?PUSH_GIFT_TRI_GOLD_NUM_CNT
		, ?PUSH_GIFT_TRI_GOLD_NUM_CNT => die_count_gold_cnt
		, decoration_level => ?PUSH_GIFT_TRI_DECORATION_LEVEL
		, ?PUSH_GIFT_TRI_DECORATION_LEVEL => decoration_level
		, medal_level => ?PUSH_GIFT_TRI_MEDAL_LEVEL
		, ?PUSH_GIFT_TRI_MEDAL_LEVEL => medal_level
		, eudemons_level => ?PUSH_GIFT_TRI_EUDEMONS_LEVEL
		, ?PUSH_GIFT_TRI_EUDEMONS_LEVEL => eudemons_level
	}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


login(PS) ->
	#player_status{id = RoleId} = PS,
	NowTime = utime:unixtime(),
	case db_select_gift_info(RoleId) of 
		[] -> ActiveList = [], ExpireList = [];
		DbList1 -> 
			{ActiveList, ExpireList} = 
				lists:foldl(fun([GiftId, SubId, ActiveTime, EndTime, ExpireTime, GradeId], {L1, L2}) ->
					case data_push_gift:get_push_gift(GiftId, SubId) of
						#base_push_gift{clear_type = 0} ->  %% 不清理
							NewExpireTime = extension_life(NowTime, EndTime, ExpireTime),
							IsDirty = ?IF(ExpireTime == NewExpireTime, 0, 1),
							Item = #p_g_info{
								key = {GiftId,SubId}, gift_id=GiftId, sub_id=SubId, active_time = ActiveTime, end_time = EndTime,
								expire_time = NewExpireTime, is_dirty = IsDirty, grade_id = GradeId
							},
							NewL2 = ?IF(ExpireTime =/= NewExpireTime, [Item|L2], L2),
							{[Item|L1], NewL2};
						_ ->
							NewExpireTime = extension_life(NowTime, EndTime, ExpireTime),
							IsDirty = ?IF(ExpireTime == NewExpireTime, 0, 1),
							IsSameDay = utime:is_today(ActiveTime),
							Item = #p_g_info{
								key = {GiftId,SubId}, gift_id=GiftId, sub_id=SubId, active_time = ActiveTime, end_time = EndTime,
								expire_time = NewExpireTime, is_dirty = IsDirty, grade_id = GradeId
							},
%%							NewL2 = ?IF(IsSameDay =/= true, [Item|L2], L2),  %% 这种也不是过期，直接就不推送
							NewL1 = ?IF(IsSameDay =/= true, L1, [Item|L1]), %% 如果是不同一天就不用拿出来，直接删除数据库
							%% 删除数据库
							if
								IsSameDay =/= true ->
									Del1 = io_lib:format(?sql_del_push_gift_record, [RoleId, GiftId, SubId]),
									Del2 = io_lib:format(?sql_del_push_gift_reward, [RoleId, GiftId, SubId]),
%%									?MYLOG("cym", "ActiveTime ~p~n", [ActiveTime]),
%%									?MYLOG("cym", "Del1 ~p~n", [Del1]),
									db:execute(Del1),
									db:execute(Del2);
								true ->
									skip
							end,
							{NewL1, L2}
					end
				end, {[], []}, DbList1)
	end,
	case db_select_gift_static_info(RoleId) of 
		[] -> StaticInfo = [];
		DbList2 ->
			StaticInfo = [ 
				#p_g_trigger{trigger_type = TriggerType, values = util:bitstring_to_term(TriggerVal)}
			 ||[TriggerType, TriggerVal] <- DbList2]
	end,
	{_, OpenList} = lists:partition(
		fun(#p_g_info{end_time=EndT, expire_time=ET}) -> 
			?gift_is_expire(NowTime, EndT, ET)
		end, ActiveList),
	%% 取出还未结束的礼包的奖励数据
	OpenKeyList = [{GiftId, SubId} ||#p_g_info{gift_id=GiftId, sub_id=SubId} <- OpenList],
	case db_select_gift_reward_with_keys(RoleId, OpenKeyList) of 
		[] -> NewActiveList = ActiveList;
		DbList3 ->
			NewActiveList = init_gift_rewards(ActiveList, DbList3)
	end,
	
	SendExpireList = [begin
		NewItem = lists:keyfind(Key, #p_g_info.key, NewActiveList),
		?IF(NewItem == false, OldItem, NewItem)
	end||#p_g_info{key = Key}=OldItem <- ExpireList],
	PushGiftStatus = #push_gift_status{static_info=StaticInfo, active_list = NewActiveList, expired_list = SendExpireList},
	lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, check_push_gift_active, []),
	NewPS = PS#player_status{push_gift_status = PushGiftStatus},
	% send_gift_list(NewPS, SendExpireList, 3),
	NewPS.

relogin(PS) ->
	%% 修正过期时间
	NowTime = utime:unixtime(),
	#player_status{push_gift_status = PushGiftStatus} = PS,
	#push_gift_status{active_list = ActiveList} = PushGiftStatus,
	{NewActiveList, ExpireList} = 
		lists:foldl(fun(PushGiftInfo, {L1, L2}) ->
			#p_g_info{end_time = EndTime, expire_time = ExpireTime} = PushGiftInfo,
			NewExpireTime = extension_life(NowTime, EndTime, ExpireTime),
			IsDirty = ?IF(ExpireTime == NewExpireTime, 0, 1),
			Item = PushGiftInfo#p_g_info{expire_time = NewExpireTime, is_dirty = IsDirty},
			NewL2 = ?IF(ExpireTime =/= NewExpireTime, [Item|L2], L2),
			{[Item|L1], NewL2}
		end, {[], []}, ActiveList),
	lib_player:apply_cast(PS#player_status.id, ?APPLY_CAST_STATUS, ?MODULE, check_push_gift_active, []),
	NewPS = PS#player_status{push_gift_status = PushGiftStatus#push_gift_status{active_list = NewActiveList}},
	send_gift_list(NewPS, ExpireList, 3),
	NewPS.


logout(PS) ->
	NowTime = utime:unixtime(),
	#player_status{id = RoleId, push_gift_status = PushGiftStatus} = PS,
	#push_gift_status{active_list = ActiveList} = PushGiftStatus,
	F = fun(PushGiftInfo, {Acc, Acc1}) ->
		#p_g_info{end_time = EndTime, expire_time = ExpireTime, is_dirty = IsDirty} = PushGiftInfo,
		if
			NowTime > EndTime andalso ExpireTime == 0 -> 
				NewPushGiftInfo = PushGiftInfo#p_g_info{expire_time = EndTime, is_dirty = 0},
				{[NewPushGiftInfo|Acc], [NewPushGiftInfo|Acc1]};
			IsDirty == 1 ->
				NewPushGiftInfo = PushGiftInfo#p_g_info{is_dirty = 0},
				{[NewPushGiftInfo|Acc], [NewPushGiftInfo|Acc1]};
			true ->
				{[PushGiftInfo|Acc], Acc1}
		end
	end,
	{NewActiveList, UpList} = lists:foldl(F, {[], []}, ActiveList),
	db_replace_gift_info_batch(RoleId, UpList),
	PS#player_status{push_gift_status = PushGiftStatus#push_gift_status{active_list = NewActiveList}}.

init_gift_rewards(ActiveList, []) -> ActiveList;
init_gift_rewards(ActiveList, [[GiftId, SubId, GradeId, BuyCnt, BuyTime]|DbList]) ->
	case lists:keyfind({GiftId, SubId}, #p_g_info.key, ActiveList) of 
		false -> init_gift_rewards(ActiveList, DbList);
		PushGiftInfo ->
			NewPushGiftInfo = PushGiftInfo#p_g_info{
				grade_list = [#p_g_reward{grade_id=GradeId, buy_cnt = BuyCnt, buy_time=BuyTime}|PushGiftInfo#p_g_info.grade_list]
			},
			NewActiveList = lists:keyreplace({GiftId, SubId}, #p_g_info.key, ActiveList, NewPushGiftInfo),
			init_gift_rewards(NewActiveList, DbList)
	end.

extension_life(NowTime, EndTime, ExpireTime) ->
	?IF(ExpireTime == 0 andalso NowTime >= EndTime, NowTime+300, ExpireTime).

%% 登陆/热更配置时检查
check_push_gift_active(PS) ->
	%% 获取 可获得的历史状态的一些触发类型数据
	#player_status{id = RoleId} = PS,
	NowTime = utime:unixtime(),
	%% 获取可以激活的活动列表
	%%  获取已激活的列表
	TriggeredGiftList = get_already_triggered(PS),
	GiftList = get_can_trigger_gift_list(PS, NowTime, TriggeredGiftList),
	GiftList2 = format_by_trigger_type(PS, GiftList),
	%?MYLOG("lxl", "check_push_gift_active: GiftList2 : ~p~n", [GiftList2]),
	{ok, NewPS, AddGiftList, AddStaticInfoList} = trigger_push_gift2(GiftList2, PS, NowTime),
	case (AddGiftList == [] andalso AddStaticInfoList == []) of 
		true -> ReturnArgs = ok;
		_ ->
			Fun = fun() ->
				db_replace_gift_info_batch(RoleId, AddGiftList),
				[db_replace_gift_static_info(RoleId, UpTriggerType, UpStaticVal) || {UpTriggerType, UpStaticVal} <- AddStaticInfoList],
				ok
			end,
			ReturnArgs = lib_goods_util:transaction(Fun)
	end,
	case ReturnArgs of 
		ok ->
			%% 日志
			LogList = [[RoleId,GiftId,SubId,ActiveTime,EndTime] ||#p_g_info{gift_id=GiftId, sub_id=SubId, active_time=ActiveTime, end_time=EndTime} <- AddGiftList],
			lib_log_api:log_active_push_gift(LogList),
			%% 推送新礼包给客户端
			send_gift_list(NewPS, AddGiftList, 2),
			{ok, NewPS};
		ERR ->
			?ERR("check_push_gift_active err:~p~n", [ERR]),
			{ok, PS}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 协议
% send_gift_list(_, [], _Type) -> ok;
send_gift_list(PS, GiftList, Type) ->
	NowTime = utime:unixtime(),
	#player_status{sid = Sid} = PS,
	SendList = pack_gift_list(NowTime, GiftList),
	%?MYLOG("lwcpushgift","Type, SendList:~p~n",[{Type, SendList}]),
	length(SendList) =/= 0 andalso lib_server_send:send_to_sid(Sid, pt_191, 19101, [Type, SendList]).

pack_gift_list(NowTime, GiftList) ->
	F = fun(#p_g_info{gift_id=GiftId, sub_id=SubId, end_time=EndT, expire_time=ET, grade_list = GradeList, grade_id = MyGradeId}=GiftInfo, Acc) ->
		case ?gift_is_expire(NowTime, EndT, ET) of 
			false ->
				case data_push_gift:get_push_gift(GiftId, SubId) of
					#base_push_gift{title_name = TitleName, name = Name, condition = Condition, grade_type = GradeType} ->
						AllGrade =
							if
								GradeType == ?single ->  %% 单个触发
									[MyGradeId];
								true ->
									data_push_gift:get_grade_list(GiftId, SubId)
							end,
						IsAllBuy = length(AllGrade) == length([GradeId ||GradeId <- AllGrade,
							check_buy_cnt_max(ulists:keyfind(GradeId, #p_g_reward.grade_id, GradeList, #p_g_reward{grade_id=GradeId}), GiftInfo)]),
						case IsAllBuy of
							false ->
								[{GiftId, SubId, TitleName, Name, max(EndT, ET), util:term_to_string(Condition)}|Acc];
							_ -> Acc
						end;
					_ ->
						Acc
				end;
			_ -> Acc
		end
	end,
	lists:foldl(F, [], GiftList).

send_gift_detail(PS, GiftId, SubId) ->
	#player_status{sid = Sid, push_gift_status = #push_gift_status{active_list = ActiveList}} = PS,
	case lists:keyfind({GiftId, SubId}, #p_g_info.key, ActiveList) of 
		false -> ok;
		PushGiftInfo ->
			NowTime = utime:unixtime(),
			#p_g_info{active_time = ActiveTime, end_time=EndT, expire_time=ET, grade_list = GradeList, grade_id = MyGradeId} = PushGiftInfo,
			case ?gift_is_expire(NowTime, EndT, ET) of 
				false ->
					#base_push_gift{name = Name, condition = Condition, grade_type = GradeType} = data_push_gift:get_push_gift(GiftId, SubId),
					AllGrade =
						if
							GradeType == ?single ->
								[MyGradeId];
							true ->
								data_push_gift:get_grade_list(GiftId, SubId)
						end,
					F = fun(GradeId, Acc) ->
						#base_push_gift_reward{name=Rname, condition=RCondition, rewards=Rewards} = 
							data_push_gift:get_push_gift_reward(GiftId, SubId, GradeId),
						case lists:keyfind(GradeId, #p_g_reward.grade_id, GradeList) of 
					        false -> BuyTime = 0, BuyCnt = 0; 
					        DFindItem -> 
					        	BuyTime = DFindItem#p_g_reward.buy_time,
					        	BuyCnt = DFindItem#p_g_reward.buy_cnt
					    end,
						BuyTime1 = ?IF(BuyTime < ActiveTime, 0, BuyTime),
						CurStaticVal = get_buy_limit_val(PS, GiftId, SubId, GradeId),
						[{GradeId, Rname, BuyCnt, BuyTime1, util:term_to_string(CurStaticVal++RCondition), util:term_to_string(Rewards)}|Acc]
					end,
					GradeRewardList = lists:foldl(F, [], AllGrade),
%%					?MYLOG("cym", "send_gift_detail # GradeRewardList: ~p~n", [{GiftId, SubId}, GradeRewardList]),
					lib_server_send:send_to_sid(Sid, pt_191, 19102, [GiftId, SubId, Name, max(EndT, ET), util:term_to_string(Condition), GradeRewardList]);
				_ -> ok
			end
	end.

get_buy_limit_val(PS, GiftId, SubId, GradeId) ->
	#base_push_gift_reward{condition = RCondition} = data_push_gift:get_push_gift_reward(GiftId, SubId, GradeId),
	case lists:keyfind(buy_lim, 1, RCondition) of 
		{_, TriggerAtom, _NeedValues} ->
			TriggerType = to_trigger_type(TriggerAtom),
			TriggerClass = to_trigger_class_type(TriggerType),
			{ActST, ActEndT} = get_gift_open_time_range(data_push_gift:get_push_gift(GiftId, SubId)),
			StaticVal = get_current_trigger_values(PS, GiftId, SubId, ActST, ActEndT, TriggerClass, TriggerType),
			[{static_val, StaticVal}];
		_ -> []
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 触发推送礼包
trigger_push_gift(PS, TriggerAtom, AddValue) ->
	#player_status{id = RoleId} = PS,
	NowTime = utime:unixtime(),
	%% 触发类型
	TriggerType = to_trigger_type(TriggerAtom),
	TriggerClass = to_trigger_class_type(TriggerType),
	%% 获取可以激活的活动列表
	%%  获取已激活的列表
	TriggeredGiftList = get_already_triggered(PS),
	GiftList = get_can_trigger_gift_list(PS, NowTime, TriggeredGiftList),
%%	?PRINT("GiftList ~p~n", [GiftList]),
	%?PRINT("trigger_push_gift # TriggerAtom: ~p~n", [{TriggerAtom, AddValue}]),
	GiftList2 = format_by_trigger_type(PS, TriggerAtom, TriggerClass, TriggerType, AddValue, GiftList),
	%?PRINT("trigger_push_gift # GiftList2: ~p~n", [GiftList2]),
	{ok, NewPS, AddGiftList, AddStaticInfoList} = trigger_push_gift2(GiftList2, PS, NowTime),
%%	?PRINT("trigger_push_gift # AddGiftList: ~p~n", [AddGiftList]),
	case (AddGiftList == [] andalso AddStaticInfoList == []) of 
		true -> ReturnArgs = ok;
		_ ->
			Fun = fun() ->
				db_replace_gift_info_batch(RoleId, AddGiftList),
				[db_replace_gift_static_info(RoleId, UpTriggerType, UpStaticVal) || {UpTriggerType, UpStaticVal} <- AddStaticInfoList],
				ok
			end,
			ReturnArgs = lib_goods_util:transaction(Fun)
	end,
	case ReturnArgs of 
		ok ->
			%% 日志
			LogList = [[RoleId,GiftId,SubId,ActiveTime,EndTime] ||#p_g_info{gift_id=GiftId, sub_id=SubId, active_time=ActiveTime, end_time=EndTime} <- AddGiftList],
			lib_log_api:log_active_push_gift(LogList),
			%% 推送新礼包给客户端
			send_gift_list(NewPS, AddGiftList, 2),
			{ok, NewPS};
		ERR ->
			?ERR("trigger_push_gift err:~p~n", [ERR]),
			{ok, PS}
	end.

trigger_push_gift2(GiftList, PS, NowTime) ->
	#player_status{push_gift_status = PushGiftStatus} = PS,
	#push_gift_status{static_info=StaticInfo, active_list = ActiveList} = PushGiftStatus,
	{AddGiftList, AddStaticInfoList} = trigger_push_gift_do(GiftList, PS, NowTime, {[], []}),
	
	NewStaticInfo = lists:foldl(fun({TriggerType, NewStaticVal}, List) -> 
		lists:keystore(TriggerType, #p_g_trigger.trigger_type, List, #p_g_trigger{trigger_type = TriggerType, values = NewStaticVal})
	end, StaticInfo, AddStaticInfoList),
	NewActiveList = lists:foldl(fun(PushGiftInfo, List) ->
		case lists:keyfind(PushGiftInfo#p_g_info.key, #p_g_info.key, ActiveList) of 
			false -> NewPushGiftInfo = PushGiftInfo;
			#p_g_info{grade_list = GradeList} -> NewPushGiftInfo = PushGiftInfo#p_g_info{grade_list = GradeList}
		end,
		lists:keystore(PushGiftInfo#p_g_info.key, #p_g_info.key, List, NewPushGiftInfo)
	end, ActiveList, AddGiftList),
%%	?MYLOG("cym", "GiftList ~p~n", [GiftList]),
%%	?MYLOG("cym", "AddGiftList ~p~n", [AddGiftList]),
%%	?MYLOG("cym", "ActiveList ~p~n", [ActiveList]),
%%	?MYLOG("cym", "NewActiveList ~p~n", [NewActiveList]),
	NewPushGiftStatus = PushGiftStatus#push_gift_status{static_info=NewStaticInfo, active_list = NewActiveList},
	NewPS = PS#player_status{push_gift_status = NewPushGiftStatus},
	{ok, NewPS, AddGiftList, AddStaticInfoList}.
	
trigger_push_gift_do([], _PS, _NowTime, ReturnArgs) -> ReturnArgs;
trigger_push_gift_do([{GiftId, SubId, _ActST, _ActEndT, TriggerType, NewStaticVal}|GiftList], PS, NowTime, {AddGiftList, AddStaticInfoList}) ->
	case data_push_gift:get_push_gift(GiftId, SubId) of 
		#base_push_gift{duration = Duration, condition = Condition, grade_type = GradeType} ->
			case ?get_trigger_values(Condition) of
				{_, _TriggerAtom, NeedValues} ->  
					NewAddStaticInfoList = ?IF(?need_db_trigger_value(TriggerType), 
						lists:keystore(TriggerType, 1, AddStaticInfoList, {TriggerType, NewStaticVal}),
						AddStaticInfoList),
%%					?IF(GiftId == 12, ?MYLOG("cym", "==================~n, ~p~n",
%%						[{SubId, TriggerType, NeedValues, NewStaticVal}]), skip),
					case is_statisfy(TriggerType, NeedValues, NewStaticVal) of 
						true ->
							PushGiftInfo = new_push_gift(GiftId, SubId, Duration, NowTime, GradeType),
							trigger_push_gift_do(GiftList, PS, NowTime, {[PushGiftInfo|AddGiftList], NewAddStaticInfoList});
						_ ->	
							trigger_push_gift_do(GiftList, PS, NowTime, {AddGiftList, NewAddStaticInfoList})
					end;
				{_, _TriggerAtom, MinNeedValues, MaxNeedValues} ->
					NewAddStaticInfoList = ?IF(?need_db_trigger_value(TriggerType),
						lists:keystore(TriggerType, 1, AddStaticInfoList, {TriggerType, NewStaticVal}),
						AddStaticInfoList),
					case is_statisfy(TriggerType, {MinNeedValues, MaxNeedValues}, NewStaticVal) of
						true ->
							PushGiftInfo = new_push_gift(GiftId, SubId, Duration, NowTime, GradeType),
							trigger_push_gift_do(GiftList, PS, NowTime, {[PushGiftInfo|AddGiftList], NewAddStaticInfoList});
						_ ->
							trigger_push_gift_do(GiftList, PS, NowTime, {AddGiftList, NewAddStaticInfoList})
					end;
				_ -> trigger_push_gift_do(GiftList, PS, NowTime, {AddGiftList, AddStaticInfoList})
			end;
		_ -> trigger_push_gift_do(GiftList, PS, NowTime, {AddGiftList, AddStaticInfoList})
	end.

new_push_gift(GiftId, SubId, Duration, NowTime, ?single) ->
	case data_push_gift:get_grade_list(GiftId, SubId) of
		GradeList when GradeList =/= [] ->
			GradeList1 = ulists:list_shuffle(GradeList),
			[GradeId | _T ] = GradeList1,
			#p_g_info{
				key = {GiftId, SubId}
				, gift_id = GiftId
				, sub_id = SubId
				, active_time = NowTime
				, end_time = NowTime + Duration
				,grade_id = GradeId
			};
		_ ->
			#p_g_info{
				key = {GiftId, SubId}
				, gift_id = GiftId
				, sub_id = SubId
				, active_time = NowTime
				, end_time = NowTime + Duration
				}
	end;
new_push_gift(GiftId, SubId, Duration, NowTime, _) ->
	#p_g_info{
		key = {GiftId, SubId}
		, gift_id = GiftId
		, sub_id = SubId
		, active_time = NowTime
		, end_time = NowTime + Duration
	}.


%% 获取已经触发的
get_already_triggered(#player_status{push_gift_status = #push_gift_status{active_list = ActiveList}}) ->
	[{{GiftId, SubId}, ActiveTime, max(EndT, ET)} ||#p_g_info{gift_id = GiftId, sub_id = SubId, active_time = ActiveTime, end_time = EndT, expire_time = ET} <- ActiveList].

%% 获取时间上可以触发的礼包列表
get_can_trigger_gift_list(PS, NowTime, TriggeredGiftList) ->
	AllGiftList = data_push_gift:get_gift_list_all(),
	Fun = fun({GiftId, SubId}, Acc) ->
		case data_push_gift:get_push_gift(GiftId, SubId) of 
			#base_push_gift{condition = Condition} = PushGiftCfg ->
				{StarTime, EndTime} = get_gift_open_time_range(PushGiftCfg),
				{_, _LastActiveTime, LastEndTime} = ulists:keyfind({GiftId, SubId}, 1, TriggeredGiftList, {{GiftId, SubId}, 0, 0}),
				IsSatisfy = (NowTime >= StarTime andalso NowTime < EndTime) andalso (LastEndTime == 0 orelse (StarTime > LastEndTime
					andalso NowTime < LastEndTime)),
				% case (NowTime >= StarTime andalso NowTime < EndTime) andalso (StarTime > LastEndTime) of
				case IsSatisfy of
					true ->
						case check_other_condition(PS, Condition) of 
							true ->
								[{GiftId, SubId, StarTime, EndTime}|Acc];
							_ ->
								Acc
						end;
					_ -> Acc
				end;
			_ -> Acc
		end
	end,
	lists:foldl(Fun, [], AllGiftList).


format_by_trigger_type(PS, GiftList) ->
	Fun = fun({GiftId, SubId, ActST, ActEndT}, Acc) ->
		case data_push_gift:get_push_gift(GiftId, SubId) of 
			#base_push_gift{condition = Condition} ->
				case ?get_trigger_values(Condition) of
					{_, TriggerAtom, _} -> 
						TriggerType = to_trigger_type(TriggerAtom),
						NewStaticVal = get_data(PS, TriggerType, {GiftId, SubId, ActST, ActEndT}),
						case check_static_value_format(TriggerType, NewStaticVal) of 
							true ->
								[{GiftId, SubId, ActST, ActEndT, TriggerType, NewStaticVal}|Acc];
							_ -> Acc
						end;
					_ -> Acc
				end;
			_ -> Acc
		end
	end,
	lists:foldl(Fun, [], GiftList).

format_by_trigger_type(PS, TriggerAtom, TriggerClass, TriggerType, AddValue, GiftList) ->
	Fun = fun({GiftId, SubId, ActST, ActEndT}, Acc) ->
		case data_push_gift:get_push_gift(GiftId, SubId) of
			#base_push_gift{condition = Condition} ->
				case ?get_trigger_values(Condition) of
					{_, TriggerAtom, _} ->
						NewStaticVal = accumulate_trigger_values(PS, GiftId, SubId, ActST, ActEndT, TriggerClass, TriggerType, AddValue),
						case check_static_value_format(TriggerType, NewStaticVal) of 
							true ->
								[{GiftId, SubId, ActST, ActEndT, TriggerType, NewStaticVal}|Acc];
							_ -> Acc
						end;
					{_, TriggerAtom, _,  _} ->
						NewStaticVal = accumulate_trigger_values(PS, GiftId, SubId, ActST, ActEndT, TriggerClass, TriggerType, AddValue),
						case check_static_value_format(TriggerType, NewStaticVal) of
							true ->
								[{GiftId, SubId, ActST, ActEndT, TriggerType, NewStaticVal}|Acc];
							_ -> Acc
						end;
					_ -> Acc
				end;
			_ -> Acc
		end
	end,
	lists:foldl(Fun, [], GiftList).

get_gift_open_time_range(PushGiftCfg) ->
	#base_push_gift{start_time = StarTime, end_time = EndTime, open_days = OpdayLim, merge_days = MerdayLim} = PushGiftCfg,
	case OpdayLim =/= [] of
        true ->
            case ulists:is_in_range(OpdayLim, util:get_open_day()) of 
            	false -> OpdayTimeLim = false;
            	{MinOpdayLim, MaxOpdayLim} ->
		            OpTime = util:get_open_time(),
		            OpUnixDate = utime:unixdate(OpTime),
		            OpdayTimeLim = [{OpUnixDate + (MinOpdayLim - 1) * 86400, OpUnixDate + MaxOpdayLim * 86400 - 1}]
		    end;
        false -> OpdayTimeLim = []
    end,
    case MerdayLim =/= [] of
        true ->
            case ulists:is_in_range(MerdayLim, util:get_merge_day()) of 
            	false -> MerdayTimeLim = false;
            	{MinMerdayLim, MaxMerdayLim} ->
		            MergeTime = util:get_merge_time(),
		            MergeUnixDate = utime:unixdate(MergeTime),
		            MerdayTimeLim = [{MergeUnixDate + (MinMerdayLim - 1) * 86400, MergeUnixDate + MaxMerdayLim * 86400 - 1}]
		    end;
        false -> MerdayTimeLim = []
    end,
    case OpdayTimeLim == false orelse MerdayTimeLim == false of 
    	true -> {0, 0};
    	_ ->
		    TimeLimL = OpdayTimeLim ++ MerdayTimeLim ++ [{StarTime, EndTime}],
		    StL = [St || {St, _} <- TimeLimL, St > 0],
		    EtL = [Et || {_, Et} <- TimeLimL, Et > 0],
		    case StL =/= [] andalso EtL =/= [] of
		        true ->
		            {lists:max(StL), lists:min(EtL)};
		        false -> {0, 0}
		    end
    end.

check_other_condition(PS, Condition) ->
	case lists:keyfind(trigger_limit, 1, Condition) of 
		{_, LimitList} ->
			check_other_condition_do(LimitList, PS);
		_ -> true
	end.
	
check_other_condition_do([], _) -> true;
check_other_condition_do([Item|LimitList], PS) ->
	case Item of 
		{vip, NeedVipLv} ->
			case PS#player_status.figure#figure.vip >= NeedVipLv of 
				true -> check_other_condition_do(LimitList, PS);
				_ -> false
			end;
		{role_lv, NeedLv} ->
			case PS#player_status.figure#figure.lv >= NeedLv of
				true -> check_other_condition_do(LimitList, PS);
				_ -> false
			end;
		{die_count, Count} ->
			case mod_daily:get_count(PS#player_status.id, ?MOD_BASE, 1) == Count of
				true -> check_other_condition_do(LimitList, PS);
				_ -> false
			end;
		{bag_have, ObjectId, Min, Max} ->
			[{ObjectId, Num}] = lib_goods_api:get_goods_num(PS, [ObjectId]),
			if 
				Num > Max orelse Num < Min -> false;
				true -> true
			end;
		{equip_have, Type, NeedColor, NeedStar, MinNum, MaxNum} ->
			GoodsStatus = lib_goods_do:get_goods_status(),
            #goods_status{dict = Dict} = GoodsStatus,
            GoodsList = lib_goods_util:get_list_by_type(Type, Dict),
            GetEquipStar = fun(EquipId) -> 
                try
                case Type of
                    % 幻灵装备单独处理 
                    39 -> 
                        #base_eudemons_equip_attr{star = Star} = data_eudemons:get_equip_attr(EquipId),
                        Star;
                    _ ->     
                        #equip_attr_cfg{star = Star} = data_equip:get_equip_attr_cfg(EquipId),
                        Star
                end
                catch 
					Normal -> Normal;
                    _:Reason ->
                        ?ERR("config miss : Id: ~p, Reason: ~p~n", [EquipId, Reason]), -1
                end
            end,
            
            F = fun(#goods{goods_id = Id, color = Color}) ->
                Star = GetEquipStar(Id),
                Color =:= NeedColor andalso Star =:= NeedStar
            end,
            Match = length([Goods || Goods <- GoodsList, F(Goods)]),
            Match >= MinNum andalso Match =< MaxNum;
		_ -> 
			check_other_condition_do(LimitList, PS)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 购买礼包
buy_gift(PS, GiftId, SubId, GradeId) ->
	#player_status{id = RoleId, sid = Sid, push_gift_status = PushGiftStatus} = PS,
	#push_gift_status{active_list = ActiveList} = PushGiftStatus,
	NowTime = utime:unixtime(),
	case lists:keyfind({GiftId, SubId}, #p_g_info.key, ActiveList) of 
		false -> CheckReturn = {fail, ?ERRCODE(err191_gift_not_active)};
		Item ->
			case ?gift_is_expire(NowTime, Item#p_g_info.end_time, Item#p_g_info.expire_time) of 
				false ->
					case lists:keyfind(GradeId, #p_g_reward.grade_id, Item#p_g_info.grade_list) of 
				        false -> ItemPushGiftReward = #p_g_reward{grade_id = GradeId}; ItemPushGiftReward -> ok
				    end,
					case data_push_gift:get_push_gift(GiftId, SubId) of
						#base_push_gift{grade_type = ?single} when GradeId == Item#p_g_info.grade_id->  %% 单个触发就只是校验其中一个
							GradeIdValid = true;
						#base_push_gift{grade_type = ?multiple} ->
							AllGrade = data_push_gift:get_grade_list(GiftId, SubId),
							GradeIdValid = lists:member(GradeId, AllGrade);
						_ ->
							GradeIdValid = false
					end,
%%					GradeIdValid = lists:member(GradeId, AllGrade),
					CheckBuyLimit = check_buy_limit(PS, GiftId, SubId, GradeId),
					CheckBuyCnt = check_buy_cnt_max(ItemPushGiftReward, Item),
					if
						CheckBuyCnt -> CheckReturn = {fail, ?ERRCODE(err191_gift_is_buy)};
						GradeIdValid == false -> CheckReturn = {fail, ?MISSING_CONFIG};
						CheckBuyLimit == false -> CheckReturn = {fail, ?ERRCODE(err191_gift_buy_limit)};
						true -> 
							CheckReturn = {ok, Item, ItemPushGiftReward}
					end;
				_ -> CheckReturn = {fail, ?ERRCODE(err191_gift_is_expired)}
			end
	end,
	%?PRINT("buy_gift CheckReturn: ~p~n", [CheckReturn]),
	case CheckReturn of 
		{ok, PushGiftInfo, PushGiftReward} ->
			#p_g_info{grade_list = GradeList} = PushGiftInfo,
			#base_push_gift_reward{condition = RCondition, rewards = RewardsList} = data_push_gift:get_push_gift_reward(GiftId, SubId, GradeId),
			case lists:keyfind(cost_now, 1, RCondition) of 
				{_, CostList} ->
					About = lists:concat([GiftId, ",", SubId, ",", GradeId]),
					case lib_goods_api:cost_object_list_with_check(PS, CostList, buy_push_gift, About) of 
						{true, PSAfCost} ->
							%% 日志
							NewBuyCnt = PushGiftReward#p_g_reward.buy_cnt + 1,
							lib_log_api:log_buy_push_gift(RoleId, GiftId, SubId, GradeId, CostList, RewardsList, NowTime),
							Produce = #produce{type = buy_push_gift, reward = RewardsList, remark = About, show_tips = ?SHOW_TIPS_1},
							PSAfReward = lib_goods_api:send_reward(PSAfCost, Produce),
							db_replace_gift_reward(RoleId, GiftId, SubId, GradeId, NewBuyCnt, NowTime),
							NewGradeList = lists:keystore(GradeId, #p_g_reward.grade_id, GradeList, #p_g_reward{grade_id=GradeId, buy_cnt = NewBuyCnt, buy_time=NowTime}),
							NewActiveList = lists:keyreplace({GiftId, SubId}, #p_g_info.key, ActiveList, PushGiftInfo#p_g_info{grade_list = NewGradeList}),
							NewPS = PSAfReward#player_status{push_gift_status = PushGiftStatus#push_gift_status{active_list = NewActiveList}},
							lib_server_send:send_to_sid(Sid, pt_191, 19103, [?SUCCESS, GiftId, SubId, GradeId, NewBuyCnt]),
							%?PRINT("buy_gift NewActiveList: ~p~n", [NewActiveList]),
							{ok, NewPS};
						{false, Errcode, _} ->
							lib_server_send:send_to_sid(Sid, pt_191, 19103, [Errcode, GiftId, SubId, GradeId, 0])
					end;
				_ ->
					lib_server_send:send_to_sid(Sid, pt_191, 19103, [?MISSING_CONFIG, GiftId, SubId, GradeId, 0])
			end;
		{fail, Errcode} ->
			lib_server_send:send_to_sid(Sid, pt_191, 19103, [Errcode, GiftId, SubId, GradeId, 0])
	end.

check_buy_limit(PS, GiftId, SubId, GradeId) ->
	#base_push_gift_reward{condition = RCondition} = data_push_gift:get_push_gift_reward(GiftId, SubId, GradeId),
	case lists:keyfind(buy_lim, 1, RCondition) of 
		{_, TriggerAtom, NeedValues} ->
			TriggerType = to_trigger_type(TriggerAtom),
			TriggerClass = to_trigger_class_type(TriggerType),
			{ActST, ActEndT} = get_gift_open_time_range(data_push_gift:get_push_gift(GiftId, SubId)),
			StaticVal = get_current_trigger_values(PS, GiftId, SubId, ActST, ActEndT, TriggerClass, TriggerType),
			%?PRINT("check_buy_limit StaticVal: ~p~n", [{TriggerType, NeedValues, StaticVal}]),
			is_statisfy(TriggerType, NeedValues, StaticVal);
		_ -> true
	end.

check_buy_cnt_max(PushGiftReward, GiftInfo) ->
	#p_g_info{gift_id=GiftId, sub_id=SubId, active_time = ActiveTime}=GiftInfo,
	#p_g_reward{grade_id = GradeId, buy_cnt = BuyCnt, buy_time = BuyTime} = PushGiftReward,
	InBuyTime = BuyTime >= ActiveTime,
	#base_push_gift_reward{condition = RCondition} = data_push_gift:get_push_gift_reward(GiftId, SubId, GradeId),
	case lists:keyfind(buy_cnt, 1, RCondition) of 
		{_, BuyCntMax} -> ok;
		_ -> BuyCntMax = 1
	end,
	InBuyTime andalso BuyCnt >= BuyCntMax.

%% 获取当前触发数据
get_current_trigger_values(PS, GiftId, SubId, ActST, ActEndT, TriggerClass, TriggerType) ->
	case ?need_db_trigger_value(TriggerType) of 
		true ->
			#player_status{push_gift_status = #push_gift_status{static_info=StaticInfo}} = PS,
			case lists:keyfind(TriggerType, #p_g_trigger.trigger_type, StaticInfo) of 
				#p_g_trigger{values = TriggerValues} -> TriggerValues;
				_ -> 
					DefalutTriggerValues = ?default_trigger_values(TriggerClass),
					DefalutTriggerValues
			end;
		_ ->
			get_data(PS, TriggerType, {GiftId, SubId, ActST, ActEndT})
	end.
%% 累积触发数据
accumulate_trigger_values(PS, GiftId, SubId, ActST, ActEndT, TriggerClass, TriggerType, Value) ->
	case ?need_db_trigger_value(TriggerType) of 
		true ->
			#player_status{push_gift_status = #push_gift_status{static_info=StaticInfo}} = PS,
			case lists:keyfind(TriggerType, #p_g_trigger.trigger_type, StaticInfo) of 
				#p_g_trigger{values = TriggerValues} -> trigger_value_add(TriggerType, TriggerValues, Value);
				_ -> 
					DefalutTriggerValues = ?default_trigger_values(TriggerClass),
					trigger_value_add(TriggerType, DefalutTriggerValues, Value)
			end;
		_ ->
			get_data(PS, TriggerType, {GiftId, SubId, ActST, ActEndT})
	end.

%%%%%%%%%%%%%%% 数据类型转换
%% 获取礼包触发类型
to_trigger_type(Atom) ->
	Map = get_data_transfer_map(),
	maps:get(Atom, Map, error).

to_trigger_atom(TriggerType) ->
	Map = get_data_transfer_map(),
	maps:get(TriggerType, Map, error).


%% -------------------------- 数据处理 --------------------------
%% 零点处理
midnight_do(#timer{delay_sec = DelaySec}) ->
%%	?MYLOG("cym", "DelaySec ~p~n", [DelaySec]),
	spawn(fun() ->
		timer:sleep(DelaySec),
		OnlineList = ets:tab2list(?ETS_ONLINE),
		IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
		[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_push_gift, midnight_do_in_ps, []) || RoleId <- IdList]
	    end).


midnight_do_in_ps(Ps) ->
	#player_status{push_gift_status = PushGift, id = RoleId} = Ps,
	#push_gift_status{active_list = GiftList} = PushGift,
	F = fun(#p_g_info{gift_id = GiftId, sub_id = SubId} = Item, {LeftGiftList, SendDelList}) ->
			case data_push_gift:get_push_gift(GiftId, SubId) of
				#base_push_gift{clear_type = 0} -> %% 不清理
					{[Item | LeftGiftList], SendDelList};
				_ ->%% 清理
					%% 删除数据库
					Del1 = io_lib:format(?sql_del_push_gift_record, [RoleId, GiftId, SubId]),
					Del2 = io_lib:format(?sql_del_push_gift_reward, [RoleId, GiftId, SubId]),
%%					?MYLOG("cym", "Del1 ~p~n", [Del1]),
					db:execute(Del1),
					db:execute(Del2),
					{LeftGiftList, [Item | SendDelList]}
			end
		end,
	{NewGiftList, SendList} = lists:foldl(F, {[], []}, GiftList),
	NewPushGift = PushGift#push_gift_status{active_list = NewGiftList},
	send_gift_list(Ps, SendList, 4),  %% 立刻删除
	{ok, Ps#player_status{push_gift_status = NewPushGift}}.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% db
db_select_gift_info(RoleId) ->
	db:get_all(io_lib:format(?sql_select_push_gift_record, [RoleId])).

db_replace_gift_info_batch(_RoleId, []) -> ok;
db_replace_gift_info_batch(RoleId, GiftInfoList) ->
	F = fun(GiftInfo, Acc) ->
		#p_g_info{gift_id=GiftId, sub_id=SubId, active_time = ActiveTime, end_time = EndTime, expire_time = ExpireTime, grade_id = GradeId} = GiftInfo,
		Values = io_lib:format(?sql_values_gift_info, [RoleId, GiftId, SubId, ActiveTime, EndTime, ExpireTime, GradeId]),
		case Acc == [] of
			true -> Values;
			_ -> Values ++ "," ++ Acc
		end
	end,
	ValuesStr = lists:foldl(F, "", GiftInfoList),
	db:execute(io_lib:format(?sql_batch_replace_push_gift_record, [ValuesStr])).

db_select_gift_reward_with_keys(_RoleId, []) -> [];
db_select_gift_reward_with_keys(RoleId, OpenKeyList) ->
	F = fun({GiftId, SubId}, Acc) ->
		Values = io_lib:format(?sql_values_gift_key, [GiftId, SubId]),
		case Acc == [] of 
			true -> Values;
			_ -> Values ++ ?sql_or ++ Acc
		end
	end,
	ValuesStr = lists:foldl(F, "", OpenKeyList),
	db:get_all(io_lib:format(?sql_select_push_gift_reward, [RoleId, ValuesStr])).

db_replace_gift_reward(RoleId, GiftId, SubId, GradeId, BuyCnt, BuyTime) ->
	db:execute(io_lib:format(?sql_replace_push_gift_reward, [RoleId, GiftId, SubId, GradeId, BuyCnt, BuyTime])).

db_select_gift_static_info(RoleId) ->
	db:get_all(io_lib:format(?sql_select_push_gift_trigger, [RoleId])).

db_replace_gift_static_info(RoleId, TriggerType, TriggerVal) ->
	db:execute(io_lib:format(?sql_replace_push_gift_trigger, [RoleId, TriggerType, util:term_to_bitstring(TriggerVal)])).