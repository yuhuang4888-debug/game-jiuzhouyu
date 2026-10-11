%% ---------------------------------------------------------------------------
%% @doc data_skill_m.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-10-23
%% @deprecated 技能手动配置
%% ---------------------------------------------------------------------------
-module(data_skill_m).
-compile(export_all).

-include("predefine.hrl").
-include("server.hrl").

%% 禁止替换的快捷栏位置##只能由指定的两个技能替换
get_fixed_quickbar_pos_list() -> [1,2,3,4].

%% 固定的技能id
get_fixed_quickbar_skill_list(?SOLDIER) -> [101010, 102010, 102020, 102030, 102040];
get_fixed_quickbar_skill_list(?SWORDGIRL) -> [201010, 202010 ,202020 ,202030 ,202040];
get_fixed_quickbar_skill_list(?KNIGHT) -> [301010, 302010 ,302020 ,302030 ,302040];
get_fixed_quickbar_skill_list(?ARCHER) -> [401010, 402010 ,402020 ,402030 ,402040];
get_fixed_quickbar_skill_list(_) -> [].

%% 固定的快捷栏
get_fixed_quickbar(?SOLDIER) -> 
    [
          {1, ?QUICKBAR_TYPE_SKILL, 101010, 1}
        , {2, ?QUICKBAR_TYPE_SKILL, 102010, 1}
        , {3, ?QUICKBAR_TYPE_SKILL, 102020, 1}
        , {4, ?QUICKBAR_TYPE_SKILL, 102030, 1}
        , {5, ?QUICKBAR_TYPE_SKILL, 102040, 1}
    ];
get_fixed_quickbar(?SWORDGIRL) -> 
    [
          {1, ?QUICKBAR_TYPE_SKILL, 201010, 1}
        , {2, ?QUICKBAR_TYPE_SKILL, 202010, 1}
        , {3, ?QUICKBAR_TYPE_SKILL, 202020, 1}
        , {4, ?QUICKBAR_TYPE_SKILL, 202030, 1}
        , {5, ?QUICKBAR_TYPE_SKILL, 202040, 1}
    ];
get_fixed_quickbar(?KNIGHT) -> 
    [
          {1, ?QUICKBAR_TYPE_SKILL, 301010, 1}
        , {2, ?QUICKBAR_TYPE_SKILL, 302010, 1}
        , {3, ?QUICKBAR_TYPE_SKILL, 302020, 1}
        , {4, ?QUICKBAR_TYPE_SKILL, 302030, 1}
        , {5, ?QUICKBAR_TYPE_SKILL, 302040, 1}
    ];
get_fixed_quickbar(?ARCHER) -> 
    [
          {1, ?QUICKBAR_TYPE_SKILL, 401010, 1}
        , {2, ?QUICKBAR_TYPE_SKILL, 402010, 1}
        , {3, ?QUICKBAR_TYPE_SKILL, 402020, 1}
        , {4, ?QUICKBAR_TYPE_SKILL, 402030, 1}
        , {5, ?QUICKBAR_TYPE_SKILL, 402040, 1}
    ];
get_fixed_quickbar(_) -> [].