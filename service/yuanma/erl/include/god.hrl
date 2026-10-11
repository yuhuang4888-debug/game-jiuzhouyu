%%%------------------------------------
%%% @Module  : god
%%% @Author  : zengzy
%%% @Created : 2018-02-27
%%% @Description: 变身系统
%%%------------------------------------

%% ---------------------------------------------------------------------------
%% 其他定义
%% ---------------------------------------------------------------------------
%%-define(GOD_OPEN_LV,    0).
-define(COLOR_LIST, [1,2,3,4,5,6]).

-define(EVERY_DOT_TIME, 1). %%每增加一点需要的时间(s)
% -define(MAX_DOT,   300). 	%%最大点数
% -define(SWITCH_CD, 15). 	%%变身切换cd(s)
-define(MAX_DOT,   10). 	%%最大点数
-define(SWITCH_CD, 15). 	%%变身切换cd(s)

-define(is_battle, 1).      %%出战状态
-define(not_battle, 0).     %%非出战状态

-define(equip_num, 4).   %%装备个数

-define(scene_god_id, 6).   %%场景角色属性更改 降神对应的Id

-record(status_god,{
		battle = [],		%%元神位{pos,元神id}
		god_list = [],		%%元神列表 #god{}
		trans_skill = [],	%%转生公共技能 [{SkillId,Lv}],
		skill_list = #{},	%%元神场景技能 格式元神id=>[{SkillId,Lv}]
		summon = [], 		%%元神召唤 #god_summon{}
		sk_power = 0,
		trans = 0,          %%暂时不用
		god_stren = none,
		attr = []           %%
	}).

%% 元神表
-record(god, {
		id = 0,
		lv = 0,				%%等级
		exp = 0,			%%经验
		grade = 0,			%%阶数
		star  = 0           %%星数
		,skill = [],        %%技能, #god_skill{}
		equip_list = [],    %% 装备列表 {Pos, AutoId， GoodsId}
		equip_attr = [],    %% 装备属性
		pos = 0  			%%出战位
		,power     = 0      %%战力
		
    }).

-record(god_skill, {
		talent_skill = [], %%天赋技能{SkillId,Lv,Exp}
		self_skill = []    %%元神技能{SkillId,Lv,Exp} %%后续要特殊处理，区分开
    }).

%% 元神召唤
-record(god_summon, {
		seq 		= 0, 	%%当前变身的是第几只元神
		god_id 		= 0, 	%%变身元神id
		start_time 	= 0, 	%%cd 结束时间
		ref 		= [] 	%%变身切换定时器引用
		,end_time   = 0     %%结束时间戳
		,initiative_skill  = []    %%变身后获得的主动技能[{id, lv}]
		,passive_skill = [] %%被动技能
		,assist_skill = []  %%辅助技能
	}).

%% 神格强化
-record(god_stren, {
		stren_list = []
		,attr = []
		
    }).

-record(god_stren_item, {
		god_type = 0
		,level = 0
		,exp = 0
    }).

%% ---------------------------------------------------------------------------
%% 配置定义
%% ---------------------------------------------------------------------------
%%元神配置
-record(base_god,{
		id = 0,
		name = undefined,
		skill = [],			%%技能id
		color  = 0,         %%品质
		base_attr = [],		%%基础属性
		talent    = [],     %%天赋技能
		trans_form_time = 0,%%变身时间
		cd        = 0,      %%变身cd
		condition = [],  	%%激活道具
		condition_lv = []		%%激活道具
		,condition_all_lv = []  %% 降神总等级条件
		,icon_id  = 0       %%变身技能id
		,model       = 0    %%模型
		,transform_skill = [] %%变身后的技能
		,hurt_hp_ratio = 0  %% [无效]最大伤害比例上限##万分比。最大伤害值=血量上限*最大伤害比例
	}).

%%元神配置
-record(base_god_equip,{
	id = 0,
	limit = 0,          %%装备限制
	pos = 0,			%%位置
	color  = 0,         %%品质
	next_equip = 0,     %%合成这个装备的合成规则
	attr = [],		%%基础属性
	decompose_exp = 0   %% 分解经验
}).

%%元神进阶配置
-record(base_grade,{
		id = 0,
		grade = 0,			%%阶数
		quality = 0,		%%品质id(暂时客户端用)
		num = 0,			%%数字(暂时客户端用)
		talent = [],		%%激活天赋技能id
		add_attr = [],		%%增加属性
		cost = []			%%进阶消耗
	}).

%%转生配置
-record(base_trans,{
		trans = 0,			%%几转
		add_attr = [],		%%增加属性
		condition = [],		%%转生条件
		trans_open = [],	%%转生开启
		skill = []			%%公共技能
	}).

%%神格强化
-record(base_god_stren,{
		god_type = 0,			%%降神类型
		stren_lv = 0,		%%
		lv_up_need_exp = 0,
		attr_add = []			%%
	}).

%% ---------------------------------------------------------------------------
%% sql定义
%% ---------------------------------------------------------------------------
%%元神表
-define(sql_god_select, " SELECT god_id, lv, exp, grade, star, pos FROM `god` where role_id=~p ").
-define(sql_god_replace, "REPLACE INTO god
	(role_id, god_id, lv, exp, grade, star, pos)
	VALUES 
	(~p,~p,~p,~p,~p,~p,~p)").
-define(sql_god_lv_update,    "UPDATE god SET lv=~p,exp=~p WHERE role_id =~p and god_id=~p").
-define(sql_god_grade_update, "UPDATE god SET grade=~p WHERE role_id =~p and god_id=~p").
-define(sql_god_star_update, "UPDATE god SET star = ~p WHERE role_id =~p and god_id=~p").
-define(sql_god_pos_update,   "UPDATE god SET pos=~p WHERE role_id =~p and god_id=~p").
-define(sql_god_train_update, "UPDATE god SET bless_val=~p,train_list='~s',tmp_list='~s' WHERE role_id =~p and god_id=~p").

%%技能表
-define(sql_skill_select,"SELECT skill_id,type,skill_lv,exp From `god_skill` WHERE role_id=~p and god_id=~p").
-define(sql_skill_replace, "replace into `god_skill` (role_id,god_id,skill_id,type,skill_lv,exp) values (~p,~p,~p,~p,~p,~p) ").

-define(sql_god_role_select,"SELECT battle,trans From `god_role` WHERE role_id=~p").
-define(sql_god_role_replace, "replace into `god_role` (role_id,battle,trans) values (~p,'~s',~p) ").

%% 神格强化表
-define(sql_god_stren_select,"SELECT god_type,level,exp From `god_stren` WHERE role_id=~p").
-define(sql_god_stren_replace, "replace into `god_stren` (role_id,god_type,level,exp) values (~p,~p,~p,~p) ").
