%%% ----------------------------------------------------
%%% @Module:        god_equip
%%% @Author:        xlh
%%% @Description:   神装
%%% @Created:       2018/5/30
%%% ----------------------------------------------------

-record(base_god_equip_level, {
        pos = 0,            %% 部位
        level = 0,          %% 神阶
        cost = [],          %% 消耗
        base_attr_add = [], %% 属性加成
        extra_attr = []     %% 专有属性
    }).

-define(BASE_ATTR,    1).
-define(EXTRA_ATTR,   2).

%% 神装升阶
-define(SQL_SELECT_GOD_EQUIP,  <<"select pos, level from role_god_equip where role_id = ~p">>).
-define(SQL_UPDATE_GOD_EQUIP,  <<"replace into role_god_equip(role_id, pos, level) values(~p, ~p, ~p)">>).