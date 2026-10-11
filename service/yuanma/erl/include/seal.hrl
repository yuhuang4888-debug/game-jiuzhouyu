%%-----------------------------------------------------------------------------
%% @Module  :       lib_seal.erl
%% @Author  :       
%% @Email   :       
%% @Created :       2019-03-02
%% @Description:    圣印
%%-----------------------------------------------------------------------------

%%      圣印部位         =>       id
-define(SEAL_WEAPON,              1).          %% 圣印部位：武器
-define(SEAL_CLOTH,               2).          %% 圣印部位：衣服
-define(SEAL_CUFF,                3).          %% 圣印部位：护腕
-define(SEAL_TROUSERS,            4).          %% 圣印部位：裤子
-define(SEAL_PILEUM,              5).          %% 圣印部位：头冠
-define(SEAL_SHOE,                6).          %% 圣印部位：鞋子
-define(SEAL_NECKLACE,            7).          %% 圣印部位：项链
-define(SEAL_RING,                8).          %% 圣印部位：戒指
-define(SEAL_AMULET,              9).          %% 圣印部位：耳环
-define(SEAL_BRACELET,           10).          %% 圣印部位：手镯
-define(SEAL_WING,               11).          %% 圣印部位：翅膀


-record(base_seal_equip, {
		id = 0          	%装备id
		,name = ""			%装备名称
		,pos = 0			%部位id
		,stage = 0          %阶数（eg:12阶）
		,color = 0          %品质
		,strong = 0			%强化上限
		,base_attr = []		%基础属性
		,extra_attr = []	%极品属性（策划说暂时粉色圣印才有）
		,suit = 0           %所属套装
	}).

-record(base_seal_suit, {
		id = 0             	%套装id
		,stage = 0			%阶数
		,color = 0			%品质
		,name = ""			%套装名称
		,suit_type = 0		%套装类型
		,seal = []			%圣印装备id列表
		,attr = []			%套装属性 [{同时穿戴部件数量,[{属性id,数值}]
		,score = 0			%评分
	}).

-record(base_seal_strong, {
		id = 0				%部位id
		,lv	= 0				%强化等级
		,cost = []			%消耗
		,add_attr = []		%强化属性
	}).

-record(seal_status,{
		pos_map = undefined, %% Key:pos_id => #seal_pos
		pill_map = undefined,%% key:goods_type_id => #seal_pill
		% suit_map = undefined,%% key:suit_id => #seal_suit
		equip_list = [],
		stren_attr = [],     %% 强化加成属性
		equip_attr = [],     %% 装备总属性
		pill_attr = [],      %% 圣魂丹加成属性
		suit_attr = [],      %% 套装加成属性
		suit_info = [],      %% {suitid, color,stage,num}
		rating = 0           %% 策划说：装备+套装，二者计算总评分
	}).

-record(seal_pos, {
		pos = 0,            %部位id
		type_id = 0,        %圣印装备类型id
		goods_id = 0,       %物品唯一id
		attr = [],			%当前装备属性
		rating = 0,         %装备评分
		strong = 0          %强化等级
	}).

-record(seal_pill, {
		goods_id = 0,       % 物品类型id
		% today_num = 0,		% 今日使用数量
		total_num = 0		% 总共使用数量
		,attr = []          % 当前增加的属性
	}).

% -record(seal_suit, {
% 		suit_id = 0,        % 套装id
% 		suit_info = [],     % 套装列表
% 		rating = 0,			% 评分
% 		stage = 0,			% 阶数
% 		color = 0,			% 品质
% 		attr = []           % 当前套装增加的属性
% 	}).
-define(seal_select,  "SELECT goods_id,num FROM player_seal_info WHERE role_id = ~p").
-define(seal_replace, "REPLACE INTO player_seal_info (role_id, goods_id,num) VALUE (~p,~p,~p)").

-define(seal_select_other,  "SELECT pos,lv FROM player_seal_other WHERE role_id = ~p").
-define(seal_replace_other, "REPLACE INTO player_seal_other (role_id, pos, lv) VALUE (~p,~p,~p)").