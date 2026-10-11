%%------------------------------------------------------------------------------
%% @Module  : title
%% @Author  : xlh
%% @Created : 2019.9.12
%% @Description: 头衔定义
%%------------------------------------------------------------------------------

-define(TITLE_LIMIT_LV, 13).

%% 头衔配置
-record(base_title_cfg, {
        id = 0,                 %% 头衔id
        name = <<>>,            %% 头衔名字
        star = 0,               %% 星级
        cost = [],              %% 升星消耗
        attr = []               %% 属性
    }).

-record(title, {
      equip_title = 0,        %% 佩戴头衔id
      title_list = [],        %% {title star status}
      total_attr = []         %% 总属性
  }).

-define(UNACTIVE, 0).   %%  0未激活
-define(ACTIVED,  1).   %%  1已激活未佩戴
-define(EQUIPED,  2).   %%  2佩戴中

-define(SQL_SELECT_TITLE_INFO,  <<"SELECT `title_id`, `star`, `status` FROM `player_title_info` WHERE `role_id` = ~p">>).
-define(SQL_REPLACE_TITLE_INFO, <<"REPLACE INTO `player_title_info` (`role_id`, `title_id`, `star`, `status`) VALUES (~p, ~p, ~p, ~p)">>).
-define(SQL_UPDATE_TITLE_INFO,  <<"UPDATE `player_title_info` SET `status` = ~p WHERE `title_id` = ~p and role_id = ~p">>).
-define(SQL_DELETE_TITLE_INFO,  <<"DELETE FROM `player_title_info` WHERE `role_id` = ~p">>).