%% ---------------------------------------------------------------------------
%% @doc    充值系统逻辑检查
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_recharge_check).
-include ("common.hrl").
-include ("rec_recharge.hrl").
-include ("def_recharge.hrl").
-include ("errcode.hrl").
-include ("def_fun.hrl").
-include ("activitycalen.hrl").
-compile (export_all).

%% 检查商品是否开放，是否符合商品条件
check_product(ProductId) when is_integer(ProductId) ->
	Product = data_recharge:get_product(ProductId),
    check_product(Product);

check_product(Product) when is_record(Product, base_recharge_product) ->
	case check({product, Product}) of
		true -> {true, Product};
		{false, Res} -> {false, Res}
	end;
check_product(_) ->
    {false, ?ERRCODE(err158_product_error)}.

check({product, Product}) ->
	#base_recharge_product{
		product_id 		= ProductId
    } = Product,    
    ProductCtrl = data_recharge:get_product_ctrl(ProductId),
    CkList = [
        {product_exist, Product}, {product_ctrl_exist, ProductCtrl}, 
        {time, ProductCtrl}, {extra_condition, ProductCtrl}, {serv_lv, ProductCtrl}],
    checklist(CkList);

%% 该充值商品缺失基础配置
check({product_exist, Product}) ->
	case Product of
		[] -> {false, ?ERRCODE(err158_product_error)};
		_ -> true
	end;

%% 该充值商品缺失控制信息配置
check({product_ctrl_exist, ProductCtrl}) ->
	case ProductCtrl of
		[] -> {false, ?ERRCODE(err158_product_ctrl_error)};
		_ -> true
	end;

%% 该充值商品暂未开启
check({time, ProductCtrl}) ->
    case check_time(ProductCtrl) of
        true -> true;
        false -> {false, ?ERRCODE(err158_time_error)}
    end;

check({serv_lv, Product}) ->
    #base_recharge_product_ctrl{serv_lv_begin = Lv0, serv_lv_end = Lv1} = Product,
    if
        Lv1 == Lv0 andalso Lv0 == 0 ->
            true;
        true ->
            WorldLv = util:get_world_lv(),
            if
                Lv0 =< WorldLv andalso WorldLv=< Lv1 ->
                    true;
                true ->
                    {false, ?ERRCODE(err158_not_enough_world_lv)}
            end
    end;

%% 您不符合该充值商品使用条件
check({extra_condition, ProductCtrl}) ->
    check_extra_condition(ProductCtrl#base_recharge_product_ctrl.condition);

check(_) ->
    {false, ?FAIL}.

checklist([]) -> true;
checklist([H|T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.

check_time(ProductCtrl) ->
    #base_recharge_product_ctrl{
        start_time      = StartTime,              %% 开始时间
        end_time        = EndTime,                %% 结束时间
        week_time_list  = WeekTimeList,           %% 周几开启
        month_time_list = MonthTimeList,          %% 每月第几天开启
        open_begin      = OpenBegin,              %% 开服开始天数
        open_end        = OpenEnd,                %% 开服结束天数
        merge_begin     = MergeBegin,             %% 合服开始天数
        merge_end       = MergeEnd                %% 合服结束天数
    } = ProductCtrl,

    BaseAc = #base_ac{
        week            = WeekTimeList,          
        month           = MonthTimeList,         
        open_day        = ?IF(OpenBegin==0 andalso OpenEnd==0, [], [{OpenBegin, OpenEnd}]),
        merge_day       = ?IF(MergeBegin==0 andalso MergeEnd==0, [], [{MergeBegin, MergeEnd}]),
        timestamp       = ?IF(StartTime==0 andalso EndTime==0, [], [{StartTime, EndTime}]),
        type            = 1
    },
    CheckList = [timestamp, week, month, open_day, merge_day],
    lib_activitycalen_util:do_check_ac_sub(BaseAc, CheckList).

%% @return true | {false, errorcode}
check_extra_condition([]) -> true;
check_extra_condition([_H|T]) ->
    %% TODO : 待添加其它条件
    check_extra_condition(T).

get_product(ProductId) ->
	case data_recharge:get_product(ProductId) of
		[] -> #base_recharge_product{};
		Product -> Product
	end.
