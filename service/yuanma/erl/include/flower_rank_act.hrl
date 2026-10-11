%%%------------------------------------
%%% @Module  : flower_rank_act.hrl
%%% @Author  : fwx
%%% @Created : 2018-1-5
%%% @Description: 魅力结婚榜活动
%%%------------------------------------
-define(RANK_TYPE_FLOWER_BOY,  351).                %% 本服鲜花榜男生
-define(RANK_TYPE_FLOWER_GIRL, 352).                %% 本服鲜花榜女生
-define(RANK_TYPE_FLOWER, [?RANK_TYPE_FLOWER_BOY, ?RANK_TYPE_FLOWER_GIRL]).             %% 本服鲜花榜

-define(RANK_TYPE_WEDDING,     360).                %% 婚礼榜

-define(RANK_TYPE_FLOWER_BOY_KF,  371).             %% 跨服鲜花榜男生
-define(RANK_TYPE_FLOWER_GIRL_KF, 372).             %% 跨服鲜花榜女生
-define(RANK_TYPE_FLOWER_KF, [?RANK_TYPE_FLOWER_BOY_KF, ?RANK_TYPE_FLOWER_GIRL_KF]).    %% 跨服鲜花榜

-define(CLOSE , 0).
-define(OPEN  , 1).

-define(TOP_N  , 3).

%% 榜单的角色信息
%% 注意:需要排序的话,使用value、second_value、third_value,不要用其他字段
-record(rank_role, {
        role_key        = undefined,              % 玩家唯一键 {RankType, Roleid}
        rank_type       = 0,                      % 榜单类型
        sub_type        = 0,                      % 活动子类型
        role_id         = 0,                      % 角色id
        value           = 0,                      % 值 (排序值)
        time            = 0,                      % 时间
        rank            = 0                       % 排名
    }).

-record(rank_wed, {
        wed_key         = undefined,              % {RankType, RoleId, Time} 同一对能重复上榜
        rank_type       = 0,                      % 榜单类型
        sub_type        = 0,                      % 活动子类型
        role_id         = 0,                      % 男角色id 
        sec_id          = 0,                      % 女角色id
        value           = 0,                      % 值 (婚礼时间)
        second_value    = 0,                      % 保留值 (婚礼类型 1下 2中 3上)    
        time            = 0,                      % 时间
        rank            = 0                       % 排名
    }).

%% 跨服鲜花榜
-record(rank_role_kf, {
        role_key        = undefined,              % 玩家唯一键 {RankType, SubType, Roleid}
        rank_type       = 0,                      % 榜单类型
        sub_type        = 0,                      % 活动子类型
        role_id         = 0,                      % 角色id
        value           = 0,                      % 值 (排序值)
        server_id       = 0,                      % 服务器id
        zone_id         = 0,                      % 区域id
        platform        = "",                     % 平台名字
        server_num       = 0,                     % 所在的服标示
        name            = "",                     % 名字
        sex             = 0,                      % 性别
        career          = 0,                      % 职业
        turn            = 0,                      % 转生数
        wlv             = 0,
        power           = 0,                      % 战力
        time            = 0,                      % 时间
        rank            = 0                       % 排名
    }).

%% 通用榜单的进程状态
-record(rank_state, {
        rank_maps  = maps:new(),                  % {RankType, SubType} => [#rank_role{}|...]
        role_maps  = maps:new(),                  % {RoleId, RankType, SubType} => Value
        wed_maps   = maps:new(),                  % {RankType, SubType} => [#rank_wed{}|...]
        rank_limit = maps:new(),                   % {RankType, SubType} => Limit
        top_n = #{}                               % {RankType, SubType} => [RoleId]
    }).

-record(kf_rank_state, {
        rank_list  = [],                            % [{RankType, SubType},[#rank_role{}|...]]
        rank_limit = maps:new(),                  % {RankType, SubType} => Limit
        act_status = maps:new(),                   % subtype => ?CLOSE
        show_figure = #{}                         % {RankType, SubType} => [{RoleId, RoleFigure}]
    }).


%%-----------------select--------------------%%
-define(sql_flower_act_charm_select, <<"select sub_type, value 
    from `flower_rank_act_local` where player_id = ~p ">>).

-define(sql_rank_role_select, <<"
    SELECT
        rank_type, sub_type, player_id, value, time
    FROM flower_rank_act_local">>).

-define(sql_rank_wed_select, <<"
    SELECT
        rank_type, sub_type, player_id, sec_id, value, second_value, time
    FROM wed_rank_act">>).

%--------------replace-----------%
-define(sql_rank_role_save, <<"
    replace into flower_rank_act_local(
        rank_type, sub_type, player_id, value, time
    ) values(~p, ~p, ~p, ~p, ~p)">>).

-define(sql_rank_wed_save, <<"
    replace into wed_rank_act(
        rank_type, sub_type, player_id, sec_id, value, second_value, time
    ) values(~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

%--------------delete--------------%
-define(sql_rank_role_delete_by_role_id, <<"delete from flower_rank_act_local
                    where rank_type = ~p and sub_type = ~p and player_id = ~p">>).

-define(sql_rank_wed_delete_by_role_id, <<"delete from wed_rank_act
                    where rank_type = ~p and sub_type = ~p and player_id = ~p">>).

-define(sql_rank_role_delete_by_value, <<"delete from flower_rank_act_local
                    where rank_type = ~p and sub_type = ~p and value < ~p ">>).

-define(sql_rank_wed_delete_by_value, <<"delete from wed_rank_act
                    where rank_type = ~p and sub_type = ~p and value > ~p ">>).

%--------------------kf------------------
-define(sql_flower_act_charm_kf_select, <<"select sub_type, value 
    from `flower_kf_rank_act` where player_id = ~p ">>).

-define(sql_rank_role_kf_select, <<"
    SELECT
        rank_type, sub_type, player_id, value, server_id, platform, server_num, name, sex, career, turn, wlv, time
    FROM flower_kf_rank_act">>).

-define(sql_rank_role_kf_save, <<"
    replace into flower_kf_rank_act(rank_type, sub_type, player_id, value, server_id, platform, server_num, name, sex, career, turn, wlv, time) 
    values(~p, ~p, ~p, ~p, ~p, '~s', ~p, '~s', ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_rank_role_kf_local_delete_by_role_id, <<"delete from flower_kf_rank_act_local
                    where rank_type = ~p and sub_type = ~p and player_id = ~p">>).
-define(sql_rank_role_kf_delete_by_role_id, <<"delete from flower_kf_rank_act
                    where rank_type = ~p and sub_type = ~p and player_id = ~p">>).
-define(sql_rank_role_kf_delete_by_value, <<"delete from flower_kf_rank_act
                    where rank_type = ~p and sub_type = ~p and value < ~p ">>).

%-------------------kf-local----------------------------%
-define(sql_kf_rank_role_local_select, <<"
    SELECT
        rank_type, sub_type, player_id, value, server_id, platform, server_num, name, sex, career, turn, time
    FROM flower_kf_rank_act_local">>).

-define(sql_kf_rank_role_local_save, <<"
    replace into flower_kf_rank_act_local(rank_type, sub_type, player_id, value, server_id, platform, server_num, name, sex, career, turn, time) 
    values(~p, ~p, ~p, ~p, ~p, '~s', ~p, '~s', ~p, ~p, ~p, ~p)">>).

%---------删除活动子类对应数据-----------%
-define(sql_rank_role_clear,
       <<"delete from `flower_rank_act_local` where rank_type in(~p, ~p) and sub_type = ~p">>).

-define(sql_rank_wed_clear,
       <<"delete from `wed_rank_act` where rank_type = ~p and sub_type = ~p">>).

-define(sql_kf_rank_role_local_clear,
       <<"delete from `flower_kf_rank_act_local` where rank_type in(~p, ~p) and sub_type = ~p">>).

-define(sql_kf_rank_role_clear,
       <<"delete from `flower_kf_rank_act` where rank_type in(~p, ~p) and sub_type = ~p">>).