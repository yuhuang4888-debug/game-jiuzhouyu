%%-----------------------------------------------------------------------------
%% @Module  :       equip_suit.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-01
%% @Description:    装备套装头文件
%%-----------------------------------------------------------------------------
-ifndef (_EQUIP_SUIT_H_).
-define (_EQUIP_SUIT_H_, 1).

-define(SUIT_CLT_MAX_STAGE, 8).                 % 套装收集最高阶段
-define(SUIT_CLT_FIGURE_ATTR, 15).              % 套装收集时装场景角色属性
-define(SUIT_CLT_ALL_POS, [1,2,3,4,5,6,8,10]).  % 套装收集的所有部位id

-define(WEAR, 1).                               % 时装穿着状态
-define(UNWEAR, 0).                             % 时装未穿着状态

-define(EQUIP_SUIT_LV_EQUIP, 1).                % 屠魔套装
-define(EQUIP_SUIT_LV_ORNAMENT, 2).             % 弑神套装
-define(EQUIP_SUIT_LV_PERFECT,  3).             % 至臻套装

-define(EQUIPMENT, 1).                          % 套装类型：武防
-define(ACCESSORY, 2).                          % 套装类型：饰品

-define(EQUIPMENT_ATTR_LIST, [2,4,6]).          % 武防套装可以拥有的n件套属性
-define(ACCESSORY_ATTR_LIST, [2,3,4]).          % 饰品套装可以拥有的n件套属性

-define(SUIT2, 1).                              % 二阶套装的套装id
-define(SUIT3, 2).                              % 三阶套装的套装id

-define(UPDATE, 0).                             % 更新模式
-define(SEND, 1).                               % 发送模式（包含更新）

-record (suit_make_cfg, {
    pos,
    lv,
    slv,
    cost,
    condition
    }).

-record (suit_item, {
    key = 0,            % {pos, lv}
    pos = 0,
    lv = 0,             % 套装级别  1 屠魔 2 弑神
    slv = 0             % 套装阶数
    }).

-record (suit_state, {
    key,                % {type, lv, slv} 武防套装状态的slv值等于装备阶数 type在装备与仙器中取值  lv表示共鸣类型
    count = 0
    }).

-endif.


%%------------------------------------------------------- 套装收集
-record (suit_collect, {
    clt_list       = [],
    attr           = [],
    passive_skills = [],
    skill_power    = 0
    }).

-record (suit_clt_item, {
    suit_id   = 0,
    cur_stage = 0, %% 已激活进度
    pos_list  = []
    }).



-record (base_suit_clt, {
    suit_id = 0,                 % 套装id
    career = 0,                 % 职业
    % sex = 0,                   % 性别
    name = "",
    open_lv = 0,
    open_turn = 0,
    show_equip = [],           % 装备推荐
    stage = 0,                  % 装备阶数
    star = 0,                    % 装备星数
    color = 0,                 % 装备品质
    power_show = 0,
    fashion_id = 0,         % 激活时装
    fashion_color = 0    % 时装颜色
    }).

-record (base_suit_clt_process, {
    suit_id    = 0,
    suit_stage = 0,  % 收集阶段
    attr       = [],
    skill_id   = ""  % 技能Id
    }).

-record(base_suit_clt_task, {
    suit_id = 0,        % 套装id
    pos = 0,            % 部位
    task_id = 0,        % 任务id
    desc = ""           % 描述
    }).





