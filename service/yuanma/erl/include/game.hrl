%% ---------------------------------------------------------------------------
%% @doc game.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-01-13
%% @deprecated 游戏基础相关
%% ---------------------------------------------------------------------------

%% ----------------------------------------------------
%% 设置
%% ----------------------------------------------------

%% 设置类别
-define(SYS_SETTING, 3).          %% 系统设置

%% 系统设置子类别
-define(PICK_UP_BLUE, 17).          %% 自动拾取蓝色装备
-define(PICK_UP_PURPLE, 18).        %% 自动拾取紫色装备
-define(PICK_UP_ORANGE, 19).        %% 自动拾取橙色以上装备
-define(AUTO_GOD_SETTING, 201).     %% 自动将神变身
-define(AUTO_RIDE_SETTING, 202).    %% 自动上下坐骑设置

% 设置
-record(setting, {
        key = undefined     % {Type, Subtype}
        , type = 0          % 大类
        , subtype = 0       % 小类
        , is_open = 0       % 1开启;0关闭
    }).

-record(status_setting, {
        setting_map = maps:new()    % Key:#setting.key Value:#setting{}
    }).

-define(sql_player_setting_select, <<"SELECT `type`, `subtype`, is_open FROM player_setting WHERE id = ~p">>).
-define(sql_player_setting_replace, <<"REPLACE INTO player_setting(id, `type`, `subtype`, is_open) VALUES(~p, ~p, ~p, ~p)">>).

%% ----------------------------------------------------
%% 头像
%% ----------------------------------------------------

% 头像配置
-record(base_picture, {
        id = 0     			% 头像id
        , resource = ""          % 资源
        , sex = 0       % 性别
        , cost = []       % 消耗
        ,desc = ""        % 描述
    }).


