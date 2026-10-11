%%-----------------------------------------------------------------------------
%% @Module  :       anima_equip.hrl
%% @Author  :       lxl
%% @Email   :       
%% @Created :       2018-09-07
%% @Description:    灵器头文件
%%-----------------------------------------------------------------------------
-record (anima_status, {
    anima_map = #{}          %% 灵器列表 anima_id => [#anima_equip{}]
    , attr_list = []        %% [{anima_id, Attr}]
    , attr = #{}
    }).

-record (anima_equip, {
    anima_id = 0          %% 灵器库id
    , goods_id = 0
    , equip_pos = 0
    , type_id = 0
    , stage = 0
    , color = 0
    , star = 0
    }).


-record (base_anima_cfg, {
    anima_id = 0          %% 灵气库id
    , anima_name = <<>>          %% 灵气库名称
    , open_lv = 0            %% 开放等级
    , condition = []            %% 存放条件
    }).

-record (base_anima_attr, {
    anima_id = 0          %% 灵气库id
    , stage = 0             %% 阶段
    , condition = []        %% 激活条件
    , attr_list = []        %% 属性
    , desc = <<>>
    }).


