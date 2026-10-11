%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%%
%%% @end
%%% Created :  3 Feb 2018 by root <root@localhost.localdomain>

-define(OP_ACTIVE,     1). %% 激活
-define(OP_REMOVE,     2). %% 移除

-define(STATUS_UNUSED, 0). %%  没有佩戴
-define(STATUS_USED,   1). %%  佩戴中

-define(CODE_FAIL,     0). %%  失败
-define(CODE_OK,       1). %%  成功

-define(MARRIAGE_DSGT,    701001).   %% XXX的伴侣

-define(GROWUP_DSGT,   3). %%  成长称号类型，3
-define(ONLYONE_DSGT,  8). %%  类型唯一称号类型

-record(base_designation, {
          id = 0,                           %% 称号id
          name = "",                        %% 称号名称
          main_type = 0,                    %% 1-名人称号，2-成就称号，3-成长称号，4-活动称号 5 - 伴侣称号 6 -圣域称号 7-伴侣动态称号 8-类型唯一称号（该类型只能激活一个称号）
          description = "",                 %% 描述
          type = 1,                         %% 默认1，1图片称号，2文字称号
          expire_time = 0,                  %% 时效，单位秒
          is_overlay = 0,                   %% 默认是0,不叠加，1叠加
          goods_consume = 0,                %% 道具激活的称号对应的物品消耗[{Type, GoodsTypeId, Num}]，默认0
          attr_list = [],                   %% 属性奖励，格式：[{属性1,数值},{属性2，数值}……]
          resource_id = 0,                  %% 称号对应的资源ID，文字称号填0
          is_global = 0,                    %% 全局称号数量,0表示无限制
          color = 0,                        %% 称号名称显示的颜色
          location = 0,                     %% 称号所处的位置
          order_limit = 0                   %% 阶数上限
          ,skill_list = []                  %% 技能列表
         }).

-record(base_dsgt_order,{
          dsgt_id = 0,                      %% 称号id
          consume = [],                     %% 格式：[{物品type,物品ID,Num}] 激活或进阶消耗的物品ID以及数量
          dsgt_order = 1,                        %% 当前阶数
          attr_list = []                    %% 属性奖励，格式：[{属性1,数值},{属性2，数值}……]
  }).   


-record(dsgt_status, {
          player_id = 0,                    %% 玩家id
          %% current_id = 0,                %% 玩家当前佩戴的称号id
          dsgt_map = #{},                   %% 当前玩家激活的称号列表 id => #designation
          attr = []                         %% 当前所有激活称号的属性状态 []
          ,skill_power = 0                  %% 技能总战力
          ,skill_list = []                  %% 当前所有激活称号的被动技能
         }).

-record(designation, {
          id = 0,                           %% 称号id
          status = 0,                       %% 称号当前状态
          active_time = 0,                  %% 激活时间戳
          end_time = 0,                     %% 过期时间
          time = 0,                         %% 操作时间
          dsgt_order = 0                    %% 称号当前的阶数
         }).

-record(active_para, {
          id = 0,                           %% 称号id
          expire_time = 0                   %% 称号过期时间戳
         }).

%% 获取正在佩戴的称号id
-define(SQL_DSGT_SEL_USED_ID,
        <<"select id from `designation` where player_id=~p and status=1 limit 1">>).

%% 获取玩家所有的称号id
-define(SQL_DSGT_SEL_ID,
        <<"select id from `designation` where player_id=~p">>).

%% 获取一个称号的佩戴状态和时效时间
-define(SQL_DSGT_SEL_STATUS,
        <<"select status, endtime from `designation` where player_id=~p and id=~p">>).

%% Rep更新玩家称号
-define(SQL_DSGT_REPLACE,
        <<"replace into `designation` set player_id=~p, id=~p, status=~p, active_time=~p, endtime=~p, time=~p, dsgt_order = ~p">>).

%% Up更新玩家称号
-define(SQL_DSGT_UP,
        <<"update designation set status=~p, active_time=~p, endtime=~p, time = ~p where player_id = ~p and id=~p ">>).

%% 删除
-define(SQL_DSGT_AUTOID_BATCH_DELETE,
        <<"delete from `designation` where player_id=~p and id in (~s) ">>).

%% 删除
-define(SQL_DSGT_BATCH_DELETE,
        <<"delete from `designation` where player_id=~p">>).

%% 删除
-define(SQL_DSGT_DELETE_ID,
        <<"delete from `designation` where id=~p">>).

%% 获取玩家所有的称号
-define(SQL_All_DSGT_SELECT,
        <<"select id, status, active_time, endtime, time, dsgt_order from `designation` where player_id=~p ">>).

%% 获取所有获得同一个称号的玩家
-define(SQL_DSGT_PLAYER_SELECT,
        <<"select player_id, active_time from `designation` where id=~p">>).

%% 删除玩家的称号
-define(SQL_DSGT_DELETE,
        <<"delete from `designation` where player_id=~p and id = ~p">>).

%% 只更新使用状态
-define(SQL_DSGT_STATE_UP,
        << "update designation set status=~p, time = ~p where player_id = ~p and id=~p">>).

%% 更新称号结束时间
-define(SQL_DSGT_UPDATE_ETIME,
        << "update designation set endtime = ~p, time = ~p where id = ~p and player_id in (~s)">>).
