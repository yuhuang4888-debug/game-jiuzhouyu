-define(ERRCODE(Type), data_error_code:get(Type)).

%%%---------------------------------------------------------------------
%%% 通用错误码定义
%%%---------------------------------------------------------------------

-define(FAIL, ?ERRCODE(fail)).  							%% 操作失败
-define(SUCCESS, ?ERRCODE(success)). 						%% 操作成功
-define(GOLD_NOT_ENOUGH, ?ERRCODE(gold_not_enough)).		%% 钻石不足
-define(BGOLD_NOT_ENOUGH,?ERRCODE(bgold_not_enough)). 		%% 绑钻不足
-define(COIN_NOT_ENOUGH, ?ERRCODE(coin_not_enough)).        %% 卢币不足
-define(MONEY_NOT_ENOUGH, ?ERRCODE(money_not_enough)). 		%% 金额不足
-define(GOODS_NOT_ENOUGH, ?ERRCODE(goods_not_enough)).      %% 物品不足
-define(HONOUR_NOT_ENOUGH, ?ERRCODE(honour_not_enough)).    %% 荣誉值不足
-define(MISSING_CONFIG,   ?ERRCODE(missing_config)). 		%% 缺失配置
-define(FIGURE_ACTIVED,   ?ERRCODE(figure_actived)). 		%% 外观形象已激活
-define(LEVEL_LIMIT, ?ERRCODE(lv_limit)).                   %% 等级不足，功能暂未开放
-define(VIP_LIMIT, ?ERRCODE(vip_limit)).                    %% 专属等级不够
-define(PLAYER_LV_LESS_TO_OPEN(Lv), {?ERRCODE(player_lv_less_to_open), [Lv]}).                %% 您的等级小于{1}，未开启
-define(PLAYER_LV_LARGE_TO_END(Lv), {?ERRCODE(player_lv_large_to_end), [Lv]}).                %% 您的等级大于{1}，已关闭
-define(OPEN_BEGIN_LESS_TO_OPEN(OpenDay), {?ERRCODE(open_begin_less_to_open), [OpenDay]}).    %% 开服天数小于{1}，未开启
-define(OPEN_END_LARGE_TO_END(OpenDay), {?ERRCODE(open_end_large_to_end), [OpenDay]}).        %% 开服天数大于{1}，已关闭
-define(MERGE_BEGIN_LESS_TO_OPEN(MergeDay), {?ERRCODE(merge_begin_less_to_open), [MergeDay]}).%% 合服天数小于{1}，未开启
-define(MERGE_END_LARGE_TO_END(MergeDay), {?ERRCODE(merge_end_large_to_end), [MergeDay]}).    %% 合服天数大于{1}，已关闭
-define(CURRENCY_NOT_ENOUGH, ?ERRCODE(currency_not_enough)).    %% 货币不足
-define(ERR_GM_STOP, ?ERRCODE(err_gm_stop)).    %% 活动异常修复中，请等待后续通知