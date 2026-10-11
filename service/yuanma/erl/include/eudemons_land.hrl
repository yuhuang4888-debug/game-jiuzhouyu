%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%% 幻兽Boss
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>

%% boss类型
-define(BOSS_TYPE_EUDEMONS,  1).       %% 幻兽BOSS



-define(EUDEMONS_REMIND_TIME, 0).     %% 重生提醒时间
-define(EUDEMONS_REMIND,     1).       %% 是否提醒 1:提醒
-define(DEF_SUB_MOD,         0).       %% 日常默认子模块0

%% 怪物种类
-define(MON_CL_NORMAL,       1).       %% 普通采集怪
-define(MON_CL_RARE,         2).       %% 珍惜采集怪
-define(MON_CL_CRYSTAL,      3).       %% 水晶采集怪
-define(MON_CL_TASK,         4).       %% 任务采集怪

-define(SYNC_NO,             0).       %% 未同步
-define(SYNC_YES,            1).       %% 已同步

-define(FORCE_NO,            0).       %% 不强制同步更新
-define(FORCE_UP,            1).       %% 强制同步更新

%% 重置时间
-define(RESET_TIME,          3600).       %% 重置时间

%% 开启天数
-define(EUDEMONS_BOSS_OPEN_DAY,   data_key_value:get(4700001)).       %% 
%% 玩家击杀等级差(不算积分)
-define(LEVEL_GAP_1,   data_key_value:get(4700002)).       %% 
%% 玩家击杀时间差(不算积分)
-define(TIME_GAP_1,   data_key_value:get(4700003)).       %% 
%% 圣兽水晶采集任务怪物id
-define(EUDEMONS_CLT_TASK_MON_ID,   data_key_value:get(4700004)).       %% 
%% 需要记录的物品id
-define(EUDEMONS_RECORD_GOODS_LIST,   data_key_value:get(4700005)).       %% 
%% 圣兽水晶采集任务id
-define(EUDEMONS_CLT_TASK_ID,   data_key_value:get(4700006)).       %% 

%% 小怪掉落道具
-define(EUDEMONS_SAMLL_MON_DROP,   data_key_value:get(4700008)).       %% 

%%%%%% 积分类型
-define(SCORE_TYPE_1,       1).       %% 击杀玩家
-define(SCORE_TYPE_2,       2).       %% 击杀boss
-define(SCORE_TYPE_3,       3).       %% 采集
-define(SCORE_TYPE_4,       4).       %% 任务

%%%%%% 榜单类型
-define(RANK_TYPE_1,       1).       %% 玩家击杀榜
-define(RANK_TYPE_2,       2).       %% boss积分榜
-define(RANK_TYPE_3,       3).       %% 总积分榜

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sql
-define(sql_select_player_score_all, 
     <<"SELECT role_id, role_name, server_id, server_num, score, sort_key1, kill_num, sort_key2, total_score, sort_key3 FROM `eudemons_boss_player_score` ">>).  %% 
-define(sql_replace_player_score, 
     <<"replace into `eudemons_boss_player_score` (`role_id`, `role_name`, `server_id`, `server_num`, `score`, `sort_key1`, `kill_num`, `sort_key2`, `total_score`, `sort_key3`) 
     values (~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).  %% 

%% 玩家幻兽之域信息
-record(eudemons_boss, {
          role_id = 0,                 %% 玩家id
          name = <<>>,
          server_id = 0,
          plat_form = <<>>,
          server_num = 0,
          server_name = <<>>,          %% 玩家服务器名
          node = null,                 %% 玩家的节点 
          cl_boss_info = [],           %% 玩家个人采集信息 [{K, Count}]
          bekill_count = [],
          eudemons_boss_tired = 0,      %% 玩家的幻兽Boss疲劳
          scene = 0,
          lv = 1,
          exp = 0,
          task_list = []      %% 圣兽领任务列表
         }).

%% 幻兽Boss进程状态(跨服中心状态)
-record(kf_eudemons_boss_state, {
          act_status = 1,               %% 活动状态 1 正常 2 洗牌中
          reset_etime = 0,             %% 洗牌结束时间
          role_info = dict:new(),      %% 玩家的幻兽之域数据
          scene_num = #{},
          boss_eudemons_map = #{},     %% 幻兽之域boss列表
          boss_drop_log = [],          %% 掉落日志
          score_map = #{},              %% 积分排行 zone_id => [#player_score{}]
          killer_map = #{},              %% 记录击杀者的一些辅助信息
          ref_clean_killer = none
         }).

%% BOSS的状态
-record(eudemons_boss_status, {
          boss_id = 0,
          num = 0,
          reborn_time = 0,
          kill_log = [],
          remind_list = [],
          pos_list = [],
          remind_ref = undefined,
          reborn_ref = undefined,
          optional_data = []
          , click_reborn = 0       %% 点击复活时间##五秒内其他玩家不能操作
         }).

%% 积分信息
-record(player_score, {
          role_id = 0
          , role_name = ""
          , server_id = 0
          , server_num = 0
          , zone_id = 0
          , score = 0
          , sort_key1 = 0
          , kill_num = 0
          , sort_key2 = 0
          , total_score = 0
          , sort_key3 = 0
         }).

%% 任务信息
-record(player_task, {
          task_id = 0
          , finish_num = 0
          , task_condition = []
          , cur_num = 0
          , task_state = 0
         }).


%% 幻兽Boss进程状态(游戏节点状态)
-record(local_eudemons_boss_state, {
          act_status = 1,             %% 状态 1正常 2重置中
          reset_etime = 0,
          boss_eudemons_map = #{},     %% 幻兽boss列表
          boss_drop_log = [],          %% 掉落日志
          score_list = [],             %% 积分榜
          sync = 0                     %% 是否已经从跨服同步数据:0否;1是;2等待更新中
         }).

%% 幻兽boss配置
-record(eudemons_boss_cfg, {
          boss_id = 0,           %% 怪物类型id
          type = 0,              %% boss类型
          layers = 0,            %% 层数
          scene = 0,             %% boss出生场景id
          num = 0,               %% 生成几只
          fixed_xy = [],         %% 固定坐标
          rand_xy = [],          %% 随机坐标
          is_rare = 0,           %% 是否稀有=0:BOSS; >0采集怪:1普通;2珍惜
          module_id = 0,         %% 
          counter_id = 0,        %% 
          cl_count = 0,          %% 采集次数
          del_hp_time = 0,       %% 采集扣血的时间间隔
          del_hp = 0,            %% 0-100之间的整数
          drop_lv = 0,           %% 掉落等级
          reborn_time = 0,       %% 重生时间s
          goods = [],            %% 固定掉落
          ratio_goods = [],      %% 随机掉落
          condition = []         %% 单个boss进入条件[{lv, Lv玩家等级}]
         }).


%% 幻兽boss类型配置
-record(eudemons_boss_type, {
          boss_type = 0,         %% boss类型
          count = 0,             %% 普通采集次数(对应采集怪物的module_id和counter_id)
          rare_count = 0,        %% 珍惜采集次数(对应采集怪物的module_id和counter_id)
          crystal_count = 0,     %% 水晶采集次数
          tired = 0,             %% 最大疲劳值(对应幻兽boss类型的module_id和counter_id)
          module_id = 0,         %% 
          counter_id = 0,        %% 
          condition = [],        %% 该类型boss的进入条件[{lv, Lv玩家等级}]
          mon_ids = []           %% 小怪id
         }).
