%% ---------------------------------------------------------------------------
%% @doc star_map.hrl
%% @author yexiaofeng
%% @since  2017-12-26
%% @deprecated 星图
%% ---------------------------------------------------------------------------

-define(STAR_MAP_OPEN_LV, 0).   %%等级没有限制

-define(POINT_TAIL, 1).       %% 最后一个星点
-define(CLASS_TAIL, 1).       %% 最后一个阶级

-record(base_star_map, {
          star_map_id = 0,    %% 唯一id
          cons_id = 0,        %% 星座id
          class_id = 0,       %% 星座阶级
          point_id = 0,       %% 星点id
          cons_name = "",     %% 星座名称
          consume = 0,        %% 激活消耗星力值
          attr = [],          %% 星座属性
          extra_attr = []     %% 星点额外属性
         }).

-record(star_map_status, {
          star_map_id = 0,    %% 星图id
          attr = []           %% 星图属性
         }).


%%-------------------------------- db ----------------------------------------
-define(sql_select_star_map, <<"select star_map_id from star_map where player_id = ~p ">>).
-define(sql_replace_star_map, <<"replace into star_map(player_id, star_map_id) values (~p, ~p)">>).
