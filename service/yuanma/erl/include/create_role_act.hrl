%%%------------------------------------
%%% @Module  : 回归登录活动
%%% @Author  :  cxd
%%% @Created :  2020-11-13
%%% @Description: 回归登录活动头文件
%%%------------------------------------

%% db写入模式
-define(ONE_INSERT, 1).
-define(BAT_INSERT, 2).

%% -------------------------- sql --------------------------
%% 查找角色对应数据
-define(sql_role_info, <<"select a.id, a.reg_time, b.data_list from player_login a inner join custom_act_data b on a.id = b.player_id where b.type = ~p and b.subtype = ~p and a.reg_time >= ~p and a.reg_time <= ~p">>).