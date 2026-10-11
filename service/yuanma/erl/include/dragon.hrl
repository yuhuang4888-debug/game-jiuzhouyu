%% ---------------------------------------------------------------------------
%% @doc dragon.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-12-16
%% @deprecated 龍紋
%% ---------------------------------------------------------------------------

%% --------------------------------------------------------
%% 龍紋基礎
%% --------------------------------------------------------

%% 玩家的龍紋狀態
-record(status_dragon, {
        attr = undefined            % 屬性 #attr{} 屬性=裝備屬性+技能屬性+共鳴屬性
        , attr_special_list = []    % 龙纹特殊属性（武器攻击。。。）
        , equip_attr = undefined    % 屬性 #attr{}
        , skill_list = []           % 技能列表 [{skillId, Lv}]
        , sk_power = 0              % 技能戰力
        , base_attr = undefined     % 屬性=裝備屬性+技能屬性
        , base_combat_power = 0     % 戰力=技能屬性戰力+裝備屬性戰力
        , pos_list = []             % 位置 [#dragon_pos{}]
        , echo_attr = undefined     % 屬性 #attr{}
        , echo_combat_power = 0     % 共鳴戰力
        , combat_power = 0          % 總戰力
        , real_combat_power = 0     % 系统真实战力
    }).

%% 槽位記錄
-record(dragon_pos, {
        pos = 0                 % 槽位
        , lv = 0                % 槽位等級
    }).

%% ------------------
%% base 配置
%% ------------------

%% 龍紋槽位
-record(base_dragon_pos, {
        pos = 0                 % 槽位
        , subtype = 0           % 系列類型##物品子類型
        , icon = 0              % 圖標
        , permiss_list = []     % 許可權列表##可以鑲嵌龍紋的系列,舉例[1,2,4,3]
        , need_lv = 0           % 解鎖等級##解鎖這個槽位所需要的龍紋總等級
    }).

%% 龍紋共鳴
-record(base_dragon_echo, {
        subtype = 0             % 系列類型##物品子類型
        , echo_lv = 0           % 共鳴等級##共鳴等級
        , num = 0               % 槽位數量
        , attr_list = []        % 屬性##[{屬性id,數值}|...]
        , add_list = []         % 加成屬性##[{?ATT,數值(百分比)},....]
    }).

%% 龍紋培養-等級
-record(base_dragon_lv, {
        goods_type_id = 0       % 物品類型id
        , lv = 0                % 龍紋升級
        , desc = ""             % 描述
        , show_lv = 0           % 龍紋等級##客戶端展示
        , kind = 0              % 龍紋種類##每一種種類只能鑲嵌一個
        , icon = 0              % 圖標
        , quality = 0           % 品質
        , lv_type = 0           % 升級類型##1:升級,2:覺醒,3:突破
        , cost = []             % 消耗##[{object_type, goods_id, goods_num}]}]
        , attr_list = []        % 屬性列表##[{屬性id,數值}|...]
        , skill_list = []       % 技能列表##[{SkillId,Lv}]
        , decompose_list = []   % 分解物品##[{object_type, goods_id, goods_num}]}]
    }).

-record(base_dragon_lv_up, {
        gtype_id = 0            % 物品类型id
        , lv_min = 0            % 等级下限
        , lv_max = 0            % 等级上限
        , kind = 0              % 龍紋種類##每一種種類只能鑲嵌一個
        , base_cost = []        % 基础消耗 升级到下一级的消耗=基础消耗+(当前等级-等级区间下限)*增量消耗
        , add_cost = []         % 增量消耗 
        , base_attr = []        % 基础属性 当前等级的属性=基础属性+(当前等级-等级区间下限)*增量属性
        , add_attr = []         % 增量属性
        , base_decompose = []   % 基础分解获得 当前等级的分解可得=基础分解可得+(当前等级-等级区间下限)*分解可得
        , add_decompose = []    % 分解获得增量
    }).

-record(base_dragon_star_up, {
        gtype_id = 0            % 物品类型id
        , star = 0              
        , attr = []             % 当前星级给与的属性
        , lv_limit = 0          % 当前星数的升级等级上限
        , cost = []             % 升星消耗
        , skill = []            % [{职业id,[{skillID,lv}]}]
        , decompose = []        % 分解获得
    }).

%% 龍紋槽位培養
-record(base_dragon_pos_lv, {
        pos = 0                 % 槽位
        , lv = 0                % 等級
        , attr_list = []        % 屬性##[{屬性id,數值}|...]
        , cost = []             % 消耗##[{object_type, goods_id, goods_num}]
    }).

%% ------------------
%% 資料庫
%% ------------------

-define(sql_role_dragon_pos_select, <<"SELECT pos, lv FROM role_dragon_pos WHERE role_id = ~p">>).
-define(sql_role_dragon_pos_replace, <<"REPLACE INTO role_dragon_pos(role_id, pos, lv) VALUES(~p, ~p, ~p)">>).

%% --------------------------------------------------------
%% 龍紋熔爐
%% --------------------------------------------------------

-define(DRAGON_CAN_NOT_GET, 0).     % 未達到條件
-define(DRAGON_CAN_GET, 1).         % 可以領取
-define(DRAGON_CAN_HAVE_GET, 2).    % 已經領取

-record(status_dragon_cb, {
        crucible_id = 0         % 熔爐id
        , count = 0             % 次數
        , free_times = 1        % 免费次数 默认一次
        , next_free_time = 0    % 下次免费次数获得时间
        , count_award = []      % 次數獎勵領取##[Count,...]
        , reward_id_list = []   % 中過的獎勵列表
        , utime = 0             % 更新時間
    }).

%% ------------------
%% base 配置
%% ------------------

%% 龍紋熔爐活動
-record(base_dragon_crucible_act, {
        act_id = 0              % 活動id
        , open_begin = 0        % 開服開始天數
        , open_end = 0          % 開服結束天數
        , crucible_list = []    % 熔爐列表##[{熔爐id, 循環天數}]
        , start_time = 0        % 活动开始时间
        , end_time = 0          % 活动结束时间
    }).

%% 龍紋熔爐
-record(base_dragon_crucible, {
        crucible_id = 0         % 熔爐id
        , career = 0            % 職業
        , cost_list = []        % 消耗列表##[{開啟次數, [{object_type, goods_id, goods_num}]}]
        , show_list = []        % 顯示獎勵##[{object_type, goods_id, goods_num}]
        , tv_list = []          % 傳聞獎勵##[GoodsTypeId,...]
        , count_award = []      % 召喚獎勵##[{次數, [{object_type, goods_id, goods_num}]},...]
    }).

%% 龍紋熔爐獎勵
%% 1> 開始次數和結束次數範圍內,只能中一次,總權重=普通權重+權重加成.
%% 2> 在最後的結束次數內,都沒有種,但是擁有保底,必定種.
%% 3> 不在次數範圍內,沒有種過,但是擁有保底,必定種.
%% 4> 不在次數範圍內,普通權重
-record(base_dragon_crucible_reward, {
        crucible_id = 0         % 熔爐id
        , reward_id = 0         % 獎勵id
        , career = 0            % 職業##0無限制,大於0限制職業抽取
        , count_st = 0          % 開始次數
        , count_et = 0          % 結束次數
        , is_assure = 0         % 是否保底
        , weight = 0            % 權重
        , weight_add = 0        % 權重加成
        , reward = []           % 獎勵列表
    }).

%% ------------------
%% 資料庫
%% ------------------

-define(sql_role_dragon_crucible_select, <<"SELECT crucible_id, count, count_award, reward_id_list, free_times, next_free_time, utime FROM role_dragon_crucible WHERE role_id = ~p">>).
-define(sql_role_dragon_crucible_replace, <<"REPLACE INTO role_dragon_crucible(role_id, crucible_id, count, count_award, reward_id_list, free_times, next_free_time, utime) VALUES(~p, ~p, ~p, '~s', '~s', ~p, ~p, ~p)">>).