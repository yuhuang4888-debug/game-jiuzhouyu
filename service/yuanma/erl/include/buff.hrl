%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2012-2-4
%% Description: buff, 温泉, 采矿 ets
%% --------------------------------------------------------

-define(ETS_BUFF, ets_buff).      %% 玩家buff

%% BUFF状态表
-record(ets_buff, {
          id          = 0,        %% 编号
          pid         = 0,        %% 角色ID
          type        = 0,        %% BUFF类型
          goods_id    = 0,        %% 物品类型ID
          effect_list = [],       %% 效果[{coin,铜钱},{gold,元宝},...]
          end_time    = 0,        %% 结束时间戳
          scene       = []        %% 场景限制
         }).

%% ---------------------- #ets_buff.type ---------------------
-define(BUFF_EXP_KILL_MON,   1). %% 杀怪经验加成buff
-define(BUFF_DROP_KILL_MON,  2). %% 杀怪掉落加成buff
-define(BUFF_GWAR_DOMINATOR, 3). %% 主宰公会会长buff
-define(BUFF_GWAR_INSPIRE,   4). %% 公会争霸士气鼓舞buff
-define(BUFF_TEAM_SHOW,      5). %% 队伍显示被动buff(荆棘之心)
-define(BUFF_INTIMACY,       6). %% 好友度buff
% -define(BUFF_TEAM_EXP,       7). %% 组队经验加成buff
-define(BUFF_ZEN_SOUL,       7). %% 世界boss战魂加成buff
-define(BUFF_FIESTA,         8). %% 祭典buff
-define(BUFF_SKILL,        255). %% 技能产生的buff
%% 以下不会发给客户端
-define (BUFF_EXP_DUN_ACT, 256). %% 副本经验活动加成
-define(BUFF_SAINT_TURN,   257). %% 圣者殿转盘buff
-define(BUFF_SKILL_NO,     258). %% 技能产生的buff(不显示)
-define(BUFF_SAINT_1,      60701). %% 圣者殿战斗buff
-define(BUFF_SAINT_2,      60702). %% 圣者殿战斗buff

%% ------------------ #ets_buff.effect_list ------------------
-define(BUFF_EFFECT_EXP_KILL_MON,   exp_mon).   %% 杀怪经验加成
-define(BUFF_EFFECT_DROP_KILL_MON,  exp_drop).  %% 杀怪掉落加成
-define(BUFF_EFFECT_ZEN_SOUL_WORLD_BOSS, zen_soul). %% 击杀世界boss战魂加成
-define(BUFF_EFFECT_ATTR,           attr).      %% 属性加成
-define(BUFF_EFFECT_EXP_STOP,       remain).    %% 暂停的经验加成
% -define(BUFF_EFFECT_INTIMACY,       intimacy).  %% 好友度

%% 插入buff
-define(sql_insert_buff,        <<"insert into `buff` set pid = ~p, type = ~p, goods_id = ~p, effect_list = '~s', end_time = ~p, scene='~s' ">>).
%% 更新buff
-define(sql_update_buff,        <<"update `buff` set goods_id = ~p, effect_list = '~s', end_time = ~p, scene='~s' where id = ~p ">>).

%% 查询buff
-define(sql_select_buff_all,    <<"select id,pid,type,goods_id,effect_list,end_time,scene from `buff` where pid = ~p ">>).
%% 查询同类buff
-define(sql_select_buff_type,   <<"select id from `buff` where pid = ~p and type =~p">>).
%% 查询buff表最新id
-define(sql_select_buff_last_id,<<"select `id` from `buff` where `pid` = ~p and type = ~p">>).

%% 删除buff
-define(sql_delete_buff,        <<"delete from `buff` where id = ~p ">>).
%% 删除玩家buff
-define(sql_delete_player_buff, <<"delete from `buff` where pid = ~p ">>).
%% 删除玩家过期的buff
-define(sql_delete_player_expired_buff, <<"delete from `buff` where pid = ~p and end_time > 0 and end_time <= ~p">>).
%% 删除玩家某个类型buff
-define(sql_delete_player_buff_by_type, <<"delete from `buff` where pid = ~p and type = ~p">>).
%% 删除某个类型buff
-define(sql_delete_buff_by_type, <<"delete from `buff` where type = ~p">>).
