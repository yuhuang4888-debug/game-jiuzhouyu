%%%--------------------------------------
%%% @Module  : lib_fashion_check
%%% @Author  : chenxiaodong
%%% @Created : 2020.08.03
%%% @Description:  时装检测
%%%--------------------------------------

-module(lib_fashion_check).

-include("fashion.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("goods.hrl").

-export([
	check_show_fashion/1
	, check_dye_unlock_color/5
	, check_put_on/5
	, check_put_off/4
	, check_active_fashion/6
	, check_star_up/5
	, check_show_single_fashion/4
]).

%% 界面展示检测
check_show_fashion(Lv) ->
	CheckList = [
    	{lv_limit, Lv}
    ],
    case check(CheckList) of 
    	true -> true;
    	{false, ErrCode} -> {false, ErrCode}
    end.

%% 染色/解锁颜色
check_dye_unlock_color(PS, PosId, FashionId, ColorId, Type) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = #fashion{position_list = PositionList}} = GS,
	FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    #fashion_pos{fashion_list = FashionList} = FashionPos,
    FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
	% FashionInfo = lib_fashion:get_fashion_info(FashionId, 0, FashionList),
    #fashion_info{color_id = NowColorId, color_list = ColorList} = FashionInfo,
	case Type of
		% 获取染色需要的额外检查项
		1 ->
			TypeCheckList = [
				{is_diff_color, ColorId, NowColorId}
				, {is_color_unlock, ColorId, ColorList}
			];
		% 获取解锁需要的额外检查项
		2 ->
			TypeCheckList = [
				{is_color_exist, PosId, FashionId, ColorId, 1}
				, {is_color_lock, ColorId, ColorList}
				, {has_enough_cost, PS, PosId, FashionId, ColorId, 1}
			]
	end,
	CheckList = [
		{lv_limit, Lv}
		, {has_pos, FashionPos}
%%		, {has_fashion, FashionInfo}
		|TypeCheckList
	],
	case check(CheckList) of
		true -> true;
		{false, ErrCode} -> {false, ErrCode}
	end.

%% 穿戴检测
check_put_on(Lv, PosId, FashionId, ColorId, PositionList) ->
	FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    #fashion_pos{wear_fashion_id = WearFashionId, wear_color_id = WearFashionColor, fashion_list = FashionList} = FashionPos,
    FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
	% FashionInfo = lib_fashion:get_fashion_info(FashionId, WearColorId, FashionList),
	% 因为只有初始color_id=0的记录保存有激活的颜色列表，所以要单独求值
	% BasicFashion = lib_fashion:get_fashion_info(FashionId, 0, FashionList),
	#fashion_info{color_list = ColorList} = FashionInfo,	
    CheckList = [
    	{lv_limit, Lv}
    	, {has_pos, FashionPos}
    	, {has_fashion, FashionInfo}
		, {is_color_unlock, ColorId, ColorList}
    	, {on_is_wearing_fashion, FashionId, WearFashionId, ColorId, WearFashionColor}
    ],
    case check(CheckList) of 
    	true ->
    		{FashionInfo, FashionPos};
    	{false, ErrCode} -> {false, ErrCode}
    end.

%% 卸下检测
check_put_off(Lv, PosId, FashionId, PositionList) ->
	FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    #fashion_pos{wear_fashion_id = WearFashionId, fashion_list = FashionList} = FashionPos,
    FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
	% FashionInfo = lib_fashion:get_fashion_info(WearFashionId, WearColorId, FashionList),
	CheckList = [
    	{lv_limit, Lv}
    	, {has_pos, FashionPos}
    	, {has_fashion, FashionInfo}
    	, {off_is_wearing_fashion, FashionId, WearFashionId}
    ],
    case check(CheckList) of 
    	true ->
    		{FashionPos};
    	{false, ErrCode} -> {false, ErrCode}
    end.

%% 激活时装检测
check_active_fashion(Lv, PosId, PositionList, FashionId, Career, Sex) ->
	FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
	#fashion_pos{fashion_list = FashionList} = FashionPos,
	% FashionInfo = lib_fashion:get_fashion_info(FashionId, 0, FashionList),
	FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
	FashionCon = data_fashion:get_fashion_con(PosId, FashionId, 1),
	FashionModelCon = data_fashion:get_fashion_model_con(PosId, FashionId, Career, Sex, 0),
	CheckList = [
    	{lv_limit, Lv}
    	, {has_pos, FashionPos}
%%    	, {is_active, FashionInfo}
    	, {is_fashion, FashionCon}
    	, {is_miss_fashion, FashionModelCon}
    ],
    case check(CheckList) of 
    	true ->
    		{FashionCon, FashionPos};
    	{false, ErrCode} -> {false, ErrCode}
    end.

%% 时装升星检测
check_star_up(Lv, PosId, FashionId, ColorId, PositionList) ->
	FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    #fashion_pos{fashion_list = FashionList} = FashionPos,
    % FashionInfo = lib_fashion:get_fashion_info(FashionId, ColorId, FashionList),
	FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
	#fashion_info{color_list = ColorList} = FashionInfo,
    {ColorId, FashionStarLv} = lists:keyfind(ColorId, 1, ColorList),
	CheckList = [
    	{lv_limit, Lv}
    	, {has_pos, FashionPos}
    	, {has_fashion, FashionInfo}
		, {is_not_max_star, PosId, FashionId, ColorId, FashionStarLv}
    ],
    case check(CheckList) of 
    	true ->
    		{FashionStarLv, FashionPos};
    	{false, ErrCode} -> {false, ErrCode}
    end.

%% 单个时装显示检测
check_show_single_fashion(Lv, PosId, FashionId, PositionList) ->
	FashionPos = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    #fashion_pos{fashion_list = FashionList} = FashionPos,
    % FashionInfo = lib_fashion:get_fashion_info(FashionId, 0, FashionList),
	FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
	CheckList = [
    	{lv_limit, Lv}
    	, {has_pos, FashionPos}
    	, {has_fashion, FashionInfo}
    ],
    case check(CheckList) of 
    	true ->
    		{FashionInfo};
    	{false, ErrCode} -> {false, ErrCode}
    end.

%% 等级限制
check([{lv_limit, Lv} | T]) ->
	case Lv >= ?OpenLv of 
		true -> check(T);
		false -> {false, ?ERRCODE(lv_limit)}
	end;

%% 是否有该部位
check([{has_pos, FashionPos} | T]) ->
	case FashionPos =:= #fashion_pos{} of 
		true -> {false, ?ERRCODE(err413_fashion_not_pos)};
		_ -> check(T)
	end;

%% 是否有该时装
check([{has_fashion, FashionInfo} | T]) ->
	case FashionInfo =:= #fashion_info{} of 
		true -> {false, ?ERRCODE(err413_fashion_not_pos)};
		_ -> check(T)
	end;

%% 穿戴时装是否正在穿着
check([{on_is_wearing_fashion, FashionId, WearFashionId, ColorId, WearFashionColor} | T]) ->
	if 
		FashionId =:=WearFashionId andalso ColorId =:= WearFashionColor -> {false, ?ERRCODE(err413_fashion_wear)};
		true -> check(T)
	end;
	% case FashionId =:= WearFashionId of 
	% 	true -> {false, ?ERRCODE(err413_fashion_wear)};
	% 	false -> check(T)
	% end;

%% 卸下时装是否正在穿着
check([{off_is_wearing_fashion, FashionId, WearFashionId} | T]) ->
	case FashionId =:= WearFashionId of 
		false -> {false, ?ERRCODE(err413_fashion_not_wear)};
		true -> check(T)
	end;

%% 是否已激活
check([{is_active, FashionInfo} | T]) ->
	case FashionInfo =:= #fashion_info{} of 
		true -> check(T);
		false -> {false, ?ERRCODE(err413_fashion_active)}
	end;

%% 是否存在时装
check([{is_fashion, FashionCon} | T]) ->
	case FashionCon =/= [] of 
		true -> check(T);
		false -> {false, ?ERRCODE(err413_fashion_active)}
	end;

%% 是否有该时装
check([{is_miss_fashion, FashionModelCon} | T]) ->
	case FashionModelCon =/= [] of 
		true -> check(T);
		false -> {false, ?MISSING_CONFIG}
	end;

%% 颜色是否不同
check([{is_diff_color, ColorId, NowColorId} | T]) ->
	case ColorId =/= NowColorId of
		true ->check(T);
		false -> {false, ?ERRCODE(err413_fashion_not_same_color)}
	end;

%% 颜色是否解锁
check([{is_color_unlock, ColorId, ColorList} | T]) ->
	case lists:keyfind(ColorId, 1, ColorList) of
		false -> {false, ?ERRCODE(err413_fashion_color_not_active)};
		_ -> check(T)
	end;

%% 颜色是否未解锁
check([{is_color_lock, ColorId, ColorList} | T]) ->
	case lists:keyfind(ColorId, 1, ColorList) of
		false -> check(T);
		_ -> {false, ?ERRCODE(err413_fashion_color_active)}
	end;

%% 颜色是否存在
check([{is_color_exist, PosId, FashionId, ColorId, StarLv} | T]) ->
	case data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, StarLv) of
		[] -> {false, ?ERRCODE(err413_fashion_not_color)};
		_ -> check(T)
	end;

%% 消耗物品检查
check([{has_enough_cost, PS, PosId, FashionId, ColorId, StarLv} | T]) ->
	FashionColorCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, StarLv),
	#fashion_color_con{active_cost = CostList} = FashionColorCon,
	case lib_goods_api:check_object_list(PS, CostList) of
		true -> check(T);
		{false, ErrCode} -> {false, ErrCode}
	end;

%% 星阶是否达到最大
check([{is_not_max_star, PosId, FashionId, ColorId, StarLv} | T]) ->
	case ColorId of
        0 ->
            FashionCon = data_fashion:get_fashion_con(PosId, FashionId, StarLv+1);
        _ ->
            FashionCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, StarLv+1)
    end,
	case FashionCon of
		[] -> {false, ?ERRCODE(err413_fashion_max_star)};
		_ -> check(T)
	end;

check([]) ->
	true.