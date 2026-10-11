%% ---------------------------------------------------------------------------
%% @doc partner_battle.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-04-20
%% @deprecated 伙伴战斗
%% ---------------------------------------------------------------------------

%% battle_type=0=?PARTNER_BATTLE_TYPE_NO
%%  没有伙伴
%% battle_type=1=?PARTNER_BATTLE_TYPE_GROUP
%%  位置1和2是第一组 位置3和4是第二组
%% battle_type=2=?PARTNER_BATTLE_TYPE_DIE_SHIFT
%%  1.布阵伙伴全部显示在侧边栏
%%  2.伙伴未出战时，伙伴icon置亮
%%  3.伙伴出战时，伙伴icon置亮
%%  4.伙伴死亡时，伙伴icon置灰

%% 组分类
-define(PARTNER_GROUP_BAN, 0).   % 禁止切换伙伴
-define(PARTNER_GROUP_1, 1).     % 组别1
-define(PARTNER_GROUP_2, 2).     % 组别2

%% ----------------------- 伙伴组 -----------------------
-define(PARTNER_GROUP_1_POS_LIST,   [1, 2]).    % 一组位置列表
-define(PARTNER_GROUP_2_POS_LIST,   [3, 4]).    % 二组位置列表

%% 玩家的伙伴战斗数据
-record(status_partner_battle, {
        battle_type = 0                 % 伙伴战斗类型 见 scene.hrl的定义 如:?PARTNER_BATTLE_TYPE_NO
        , group = 0                     % 伙伴组(1:一组 2:二组)
        , choice_time = 0               % 上次选择的时间
        , map = #{}                     % 伙伴列表 Key:#partner_battle.id Value:#partner_battle{}
    }).

%% 伙伴战斗记录数据
-record(partner_battle, {
        auto_id = 0                     % 生成怪物的唯一id.死亡和切换伙伴组会重置
        , id = 0                        % 伙伴唯一id
        , partner_id = 0                % 伙伴id
        , pos = 0                       % 上阵位置              
        , hp = 0                        % 血量(只有死亡和下伙伴的时候赋值)
        , hp_lim = 0                    % 血量上限
        , partner = undefined           % #partner{}
    }).
