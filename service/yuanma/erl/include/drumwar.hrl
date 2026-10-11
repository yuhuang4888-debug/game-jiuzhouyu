%% 历史榜单数据
-define(SQL_DRUMRANK_GET, <<"SELECT `drumid`,`zone`,`rid`,`name`,`gname`,`server_id`,`platform`,`server_num`,`rank`,`vip`,`power`,`career` FROM `drumwar_rank`">>).
-define(SQL_DRUMRANK_DEL,  <<"DELETE FROM drumwar_rank where `drumid`=~p">>).
-define(SQL_DRUMWAR_RANK_BATCH, <<"REPLACE INTO drumwar_rank (drumid,zone,rid,name,gname,server_id,platform,server_num,rank,vip,power,career) VALUES ~ts">>).

%% 报名数据
-define(SQL_DRUMWAR_SIGN_BATCH, <<"REPLACE INTO drumwar_sign (rid,server_id,platform,server_num,drumid,zid,name,picture,picturev,lv,career,power) VALUES (~p,~p,'~s',~p,~p,~p,'~s','~s',~p,~p,~p,~p)">>).
-define(SQL_DRUMSIGN_GET,  <<"SELECT `rid`,`server_id`,`platform`,`server_num`,`drumid`,`zid`,`name`,`picture`,`picturev`,`lv`,`career`,`power` FROM `drumwar_sign`">>).

%% 玩家数据
-define(SQL_DRUM_GET, <<"SELECT `drumid`,`one`,`zone`,`action` FROM `role_drum` where rid=~p">>).
-define(SQL_DRUM_INSERT,<<"REPLACE INTO role_drum (`rid`,`drumid`,`one`,`zone`,`action`,`deal`,`choice`,`pay_time`) VALUES (~p,~p,~p,~p,~p,~p,'~ts',~p)">>).
-define(SQL_DRUM_UPDATE, <<"UPDATE role_drum SET one=~p,action=13 where rid=~p">>).

%% 玩家竞猜数据
-define(SQL_DRUM_GUESS_GET, <<
	"SELECT `zone`,`action`,`suprid`,`type`, `reward_st`, `winner`,
	`arid`, `asid`, `asnum`, `aname`, `alv`, `asex`, `acareer`, `apic`, `apicver`, `apower`,
	`brid`, `bsid`, `bsnum`, `bname`, `blv`, `bsex`, `bcareer`, `bpic`, `bpicver`, `bpower`
	FROM `role_drum_guess` where rid=~p"
	>>).
% -define(SQL_DRUM_GUESS_INSERT,<<"REPLACE INTO role_drum_guess (`rid`,`zone`,`action`,`suprid`,`reward_st`) VALUES (~p,~p,~p,~p,~p)">>).
%-define(SQL_DRUM_GUESS_UPDATE, <<"UPDATE `role_drum_guess` SET `reward_st`=~p where zone = ~p and rid=~p and action=~p and suprid=~p">>).

%% 战报数据
-define(SQL_DRUMRANK_RESULT_GET, <<"SELECT `zone`,`act`,`group`,`server_id`,`platform`,`server_num`,`rid`,`name`,`picture`,`picturev`,`lv`,`career`,`pow` FROM `drumwar_result`">>).
-define(SQL_DRUMWAR_RESULT_INTERT, <<"INSERT INTO `drumwar_result` (`zone`,`act`,`group`,`server_id`,`platform`,`server_num`,`rid`,`name`,`picture`,`picturev`,`lv`,`career`,`pow`) VALUES (~p,~p,~p,~p,'~s',~p,~p,'~s','~s',~p,~p,~p,~p)">>).


%% 键值
-define(DRUMKV_1, 1). %%比赛等级
-define(DRUMKV_2, 2). %%竞猜等级
-define(DRUMKV_3, 3). %%最少参加人数
-define(DRUMKV_4, 4). %%命数购买上限
-define(DRUMKV_5, 5). %%购买单价
-define(DRUMKV_6, 6). %%门票id
-define(DRUMKV_7, 7). %%准备场景
-define(DRUMKV_8, 8). %%比赛场景
-define(DRUMKV_9, 9). %%准备场景 出生点
-define(DRUMKV_10, 10). %%比赛场景 出生点
-define(DRUMKV_11, 11). %%复活 出生点
-define(DRUMKV_12, 12). %%技能列表
-define(DRUMKV_13, 13). %%假人属性系数
-define(DRUMKV_14, 14). %%技能消耗
-define(DRUMKV_15, 15). %%开服天数限制

-define(DRUMLV, data_drumwar:get_kv(?DRUMKV_1)). %%比赛等级 
-define(CHOOSELV, data_drumwar:get_kv(?DRUMKV_2)). %%竞猜等级
-define(WAR_LIMIT,data_drumwar:get_kv(?DRUMKV_3)). %%最少参加人数
-define(BUYMAX,data_drumwar:get_kv(?DRUMKV_4)). %%购买上限
-define(BUYPRICE,data_drumwar:get_kv(?DRUMKV_5)). %%购买单价
-define(DRUMITEM, data_drumwar:get_kv(?DRUMKV_6)). %%门票id
-define(READY_SCENE,data_drumwar:get_kv(?DRUMKV_7)). %% 准备场景
-define(WAR_SCENE,data_drumwar:get_kv(?DRUMKV_8)). %% 比赛场景
-define(READY_LOCATION,data_drumwar:get_kv(?DRUMKV_9)). %% 准备场景 出生点
-define(WAR_LOCATION,data_drumwar:get_kv(?DRUMKV_10)). %%战斗 出生点
-define(DRUM_REVIVE_LOCATION,data_drumwar:get_kv(?DRUMKV_11)). %%复活 出生点
-define(DRUM_SKILLS, data_drumwar:get_kv(?DRUMKV_12)). %% 技能
-define(DRUM_MON_ATTR, data_drumwar:get_kv(?DRUMKV_13)). %% 假人属性
-define(DRUM_SKILL_GOLD, data_drumwar:get_kv(?DRUMKV_14)). %% 
-define(DRUM_OPEN_DAY, data_drumwar:get_kv(?DRUMKV_15)). %% 

%% 其他常量
-define(WAR_MAX,2048). %%核准参与人数
-define(WAR_POOL_MAX, 7). %% 战斗场景进程数
-define(READY_POOL_MAX, 3). %% 准备场景进程数
-define(SKILL_CD,  20).
-define(DRUM_SIGN_GAP,		20). %%

%% 活动状态阶段
-define(IDLE, 0).
-define(SIGN, 1).
-define(READY, 2).
-define(SEAWAR, 3). 
-define(RANKWAR, 4).
-define(CLOSE, 5).

%% 子阶段的倒计时
-define(TYPE_SEA_START,	  	1). %%海选赛开始倒计时
-define(TYPE_FIGHT_START,	2). %%入战场倒计时
-define(TYPE_FIGHT,		    3). %%打斗开始倒计时
-define(TYPE_SUCCESS,		4). %%成功晋级倒计时
-define(TYPE_RANK_START,	5). %%排位赛开始倒计时
-define(TYPE_FIGHT_END,		6). %%打斗结束倒计时


%%擂台赛管理进程
-record(drumwar_mgr,{
	state  = 0,   %%当前状态
	substate = 0,
	action = 0,   %%当前场次
    ref    = 0,   %%当前状态定时器
    ref_sign = 0, %% 定时广播报名传闻
    signs  = [],  %%所有报名玩家
    server_map = #{},  %% 服务器集合
    sea_candidate = [],  %% 海选战候选人
    zones  = [],  %%战区划分
    mons   = [],  %%假人Ai集合
    history= [],  %%战报集合 十期
    etime  = 0,   %%截止时间
    ctime  = 0,   %%竞猜截止时间
    cstate = 0,   %%是否竞猜时段0否1是
    choose = [],  %%竞猜数据[{战区,[{场次,[UidA,UidB]}]}]
    choice = [],  %%竞猜结果数据 [{Wid, [{Node, RoleList}]}]
    ready_out = []	%%战力退出2048后，[玩家id]，（做提示用）
}).


%%战区信息
-record(zone_base, {
	id = 0,      %%战区号
	seeds = [],  %%该区种子选手
	wins = []    %%胜场玩家
}).

%%擂台玩家
-record(drum_role, {
	rid = 0             %%玩家ID
	,sid = 0            %%Sid 发消息用
	,zid = 0            %%所在战区
	,group = 0          %%所在分组  就是房间号
	,action = 1         %%当前场次
	,server_id = 0 		%
	,platform = []      %%平台
	,server_num = 0     %%
	,server_name = <<>> %% 服务器名字
	,node = none        %%所在节点
	,figure = undefined
	,role_attr = undefined
	,live = 1           %%命数 默认1
	,hp_lim = 1  		%% 血量上限
	,hp = 0  			%% 血量
	,online = 0         %%1表示在线 在准备区
	,power = 0          %%战力
	,win = 0            %%胜场
	,lose = 0           %%负场
	,rank = 0           %%排位赛排次
	,pos = 0            %%标识站位 0左1右
	,ai = 0             %%标识对手是否机器人0不是1是(在排位赛表示轮空)
	,ruid = 0           %%对手Uid
	,one = 0            %%1标识该区No.1
	,scene = 0 			%%进入活动的场景id
	,calc_type = 0      %%当轮是否结算
	%,train_object = undefined
}).


-record(rank_role,{
    drum = 0,
    zone = 0,
    rid  = 0,
    name = "",
    gname = "",
    server_id       = 0,      %%
    platform = "",
    servernum = 0,
    rank = 0,
    vip  = 0,
    career = 0,
    power= 0
}).

-record(role_drum, {
	drumid = 0,
	one  = 0,
	zone = 0,
	action = 0,
	deal   = 0, %%有效截止时间 逾期清除
	choice = [], %%竞猜列表
	pay_time = 0,
	%% 其他临时数据
	live = 0, 
	pos = 0      %% 玩家在擂台的位置
}).

-record(role_choice, {
	key = 0,
	zone  = 0,
	action = 0,
	suprid   = 0, 
	type = 0,
	reward_st = 0,
	winner = 0,
	arid = 0,
	asid = 0,
	asnum = 0,
	aname = <<>>,
	alv = 0,
	asex = 0,
	acareer = 0,
	apic = <<>>,
	apicver = 0,
	apower = 0,
	brid = 0,
	bsid = 0,
	bsnum = 0,
	bname = <<>>,
	blv = 0,
	bsex = 0,
	bcareer = 0,
	bpic = <<>>,
	bpicver = 0,
	bpower = 0
}).