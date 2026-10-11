%%-----------------------------------------------------------------------------
%% @Module  :       lib_draconic.erl
%% @Author  :       
%% @Email   :       
%% @Created :       2019-03-02
%% @Description:    龙语
%%-----------------------------------------------------------------------------
-record(base_draconic_equip, {
        id = 0              %装备id
        ,name = ""          %装备名称
        ,pos = 0            %部位id
        ,stage = 0          %阶数（eg:12阶）
        ,color = 0          %品质
        ,strong = 0         %强化上限
        ,base_attr = []     %基础属性
        ,extra_attr = []    %极品属性
        ,suit = 0           %所属套装
    }).

-record(base_draconic_suit, {
        id = 0              %套装id
        ,stage = 0          %阶数
        ,color = 0          %品质
        ,name = ""          %套装名称
        ,suit_type = 0      %套装类型
        ,draconic = []      %龙语装备id列表
        ,attr = []          %套装属性 [{同时穿戴部件数量,[{属性id,数值}]
        ,score = 0          %评分
    }).

-record(base_draconic_strong, {
        id = 0              %部位id
        ,lv = 0             %强化等级
        ,cost = []          %消耗
        ,add_attr = []      %强化属性
    }).

-record(base_special_suit, {
        id = 0,             %套装id
        stage = 0,          %阶数
        color = 0,          %颜色
        attr = [],          %属性
        score = []          %评分
    }).

-record(draconic_status,{
        pos_map = #{}, %% Key:pos_id => #draconic_pos
        equip_list = [],
        stren_attr = [],     %% 强化加成属性
        equip_attr = [],     %% 装备总属性
        suit_attr = [],      %% 套装加成属性
        suit_info = [],      %% {suitid, color,stage,num}
        rating = 0           %% 策划说：装备+套装，二者计算总评分
        ,special_attr = []   %% 特殊属性 与战力无关
    }).

-record(draconic_pos, {
        pos = 0,            %部位id
        type_id = 0,        %龙语装备类型id
        goods_id = 0,       %物品唯一id
        attr = [],          %当前装备属性
        rating = 0,         %装备评分
        strong = 0          %强化等级
    }).

-record(draconic_pill, {
        goods_id = 0,       % 物品类型id
        % today_num = 0,    % 今日使用数量
        total_num = 0       % 总共使用数量
        ,attr = []          % 当前增加的属性
    }).

-define(draconic_select_other,  "SELECT pos,lv FROM player_draconic_other WHERE role_id = ~p").
-define(draconic_replace_other, "REPLACE INTO player_draconic_other (role_id, pos, lv) VALUE (~p,~p,~p)").