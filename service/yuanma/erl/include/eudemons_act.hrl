%%-----------------------------------------------------------------------------
%% @Module  :       eudemons_act.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-07
%% @Description:    幻兽入侵活动
%%-----------------------------------------------------------------------------

-define (KV_SCENE, 1).
-define (KV_BOSS_ID, 2).
-define (KV_BORN_POS, 3).
-define (KV_BOSS_HPR, 4).
-define (KV_COLLECT_POS, 5).
-define (KV_COLLECT_NUM_MAX, 6).


-record (hurt_rank_item, {
    id,
    name,
    sex,
    career,
    turn,
    pic,
    power,
    hurt
    }).

-record (simple_figure, {
    lv,
    power,
    name,
    sex,
    career,
    turn,
    pic
    }).

%% 采集物配置
-record (eudemons_act_collect, {
    id,
    num_min,
    num_max,
    base_collected_mon,
    rand_collected_mon,
    rand_num,
    pos_list
    }).