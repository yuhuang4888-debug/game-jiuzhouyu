%% ---------------------------------------------------------------------------
%% @doc territory_treasure.hrl
%% @author  xlh
%% @email   
%% @since   2019.3.6
%% @deprecated 领地夺宝
%% ---------------------------------------------------------------------------

-record(base_cfg,{
		id = 0,                	    %% id
		scene = 0,          		%% 场景id
		mon_num = 0,                %% 波数
		end_time = 0, 				%% 持续时间（S）
		condition = []              %% 条件
	}).

-record(base_wave, {
		id = 0,                     %% id
		wave = 0,					%% 波数
		mon_info = [],				%% 怪物信息[{monid,X,Y}...]
		etime = 0					%% 刷新间隔（本波）
	}).

-record(base_territory_auction, {
		min = 0,					%% 工会排名下限
		max = 0, 					%% 工会排名上限
		gold_base = 0,				%% 钻石基数
		gold_add = 0,				%% 人均钻石价值
		gold = [],					%% 钻石产出
		bgold_base = 0,             %% 绑钻基数
		bgold_add = 0,				%% 人均绑钻价值
		bgold = [],					%% 绑钻产出
		produce = []				%% 固定产出
	}).

-record(territory_state,{
		rank_map = #{}        			% 保存玩家的伤害信息 Key:{Scene, PoolId, CopyId} => RankList:[{Name, RoleId, Hurt}]
		,reward_map = #{} 		        % 玩家拾取到的所有奖励  Key:{dun_id, RoleId, monid}  =>  reward_list
		,other_map = #{}                % 玩家信息 role_id => #role_info
		,dun_state = #{}                % 副本信息 dunid => #dun
		,guild_info = #{}				% 公会id排名 Copyid => [{Guild, [RoleID]}]
	}).

-record(dun, {
		mon_map = #{}     				% 当前波怪物信息monid => is_alive
		,nextopen_time = 0				% 下次开启时间
		,create_ref = undefined			% 活动开启定时器
		,end_time = 0                   % 活动结束时间
		,end_ref = undefined			% 活动结束定时器
		,refresh_time = 0				% 下波刷怪时间
		,wave = 0						% 当前波数
		,num = 0                        % 剩余怪物数量
		,is_end = 0                     % 0:本次怪物没有杀完；1清完所有怪物
	}).

-record(role_info, {
		role_id = 0,
		role_name = "",
		guild_id = 0,
		guild_name = "",
		dunid = 0
	}).

-define(AUCTION_NORMAL, 0). %% 普通
-define(AUCTION_RARE,   1). %% 稀有

-define(KEY_DUN_DUNID_1,  1).            	%% 领地积分与副本id关系
-define(KEY_DUN_DUNID_2,  2).				%% 没有领地积分的玩家，进入的副本id

-define(MAIL_TITLE_RANK,  6100004).    %% 领地夺宝伤害排名奖励，标题
-define(MAIL_CONTENT_RANK, 6100005).   %% 领地夺宝伤害排名奖励，邮件内容