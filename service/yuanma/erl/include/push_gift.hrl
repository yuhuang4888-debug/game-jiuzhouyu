%%% 礼包推送

%% ------------------------------------------------- SQL ---------------------------
-define(sql_or, " or ").
-define(sql_values_gift_key, "(gift_id=~p and sub_id=~p)").
-define(sql_values_gift_info, "(~p, ~p, ~p, ~p, ~p, ~p, ~p)").
%%-define(sql_values_gift_info, "(~p, ~p, ~p, ~p, ~p, ~p)").
%%-define(sql_select_push_gift_record, <<"select gift_id,sub_id,active_time,end_time,expire_time from role_push_gift where role_id=~p">>).
-define(sql_select_push_gift_record, <<"select gift_id,sub_id,active_time,end_time,expire_time, grade_id from role_push_gift where role_id=~p">>).
-define(sql_batch_replace_push_gift_record, 
  <<"replace into role_push_gift (role_id, gift_id, sub_id, active_time, end_time, expire_time, grade_id) values ~s">>).

-define(sql_select_push_gift_reward,
  <<"select gift_id, sub_id, grade_id, buy_cnt, buy_time from role_push_gift_reward where role_id=~p and (~s)">>).
-define(sql_replace_push_gift_reward, 
  <<"replace into role_push_gift_reward set role_id=~p, gift_id=~p, sub_id=~p, grade_id=~p, buy_cnt=~p, buy_time=~p">>).


-define(sql_select_push_gift_trigger, 
  <<"select tri_type, static_value from role_push_gift_trigger where role_id=~p">>).
-define(sql_replace_push_gift_trigger, 
  <<"replace into role_push_gift_trigger set role_id=~p, tri_type=~p, static_value='~s' ">>).

-define(sql_del_push_gift_record, <<"DELETE  from  role_push_gift where  role_id = ~p and gift_id = ~p and  sub_id = ~p ">>).
-define(sql_del_push_gift_reward, <<"DELETE  from  role_push_gift_reward where  role_id = ~p and gift_id = ~p and  sub_id = ~p">>).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(in_day_range(Num, NumList), [1 ||{Num1, Num2} <- NumList, Num1 =< Num andalso Num =< Num2] =/= []).
-define(get_trigger_values(Condition), 
  case lists:keyfind(trigger, 1, Condition) of 
    {trigger, _Atom, _} = V -> V;
    {trigger, _Atom, _MinV1, _MaxV2} = V -> V;    %% 范围触发
      _ -> false
  end).


-define(single,   1).
-define(multiple, 2).


%% 
-record(push_gift_status, {
          static_info = []     %% 统计信息 #p_g_trigger{}
          , active_list = []   %% [#p_g_info{}]
          , expired_list = []  %% 离线过期礼包列表
         }).


-record(p_g_info, {
          key = 0
          , gift_id = 0
          , sub_id = 0
          , active_time = 0
          , end_time = 0
          , expire_time = 0
          , grade_list = []   %% [#p_g_reward{}]
          , grade_id = 0     %% 没有领取的，但是已经确定的奖励id
          , is_dirty = 0
         }).

-record(p_g_reward, {
          grade_id = 0
          , buy_cnt = 0
          , buy_time = 0
         }).

-record(p_g_trigger, {
          trigger_type = 0
          , values = false
         }).

%% 礼包配置
-record(base_push_gift, {
          gift_id = 0         %% 礼包id
          , sub_id = 0        %% 子id
          , title_name = <<>> %% 标签名
          , name = <<>>       %% 名称
          , duration = 0
          , start_time = 0    %% 开始时间
          , end_time = 0      %% 结束时间
          , open_days = []    %% 开服天数
          , merge_days = []   %% 合服天数
          , condition = []    %% 礼包控制信息
          , grade_type = ?multiple %%  奖励类型触发，默认多个
          , clear_type = 0    %% 清理类型0不清理
         }).
%% 礼包奖励配置
-record(base_push_gift_reward, {
          gift_id = 0
          , sub_id = 0
          , grade_id = 0
          , name = <<>>
          , condition = []   %% 礼包购买条件
          , rewards = []     %% 奖励
         }).