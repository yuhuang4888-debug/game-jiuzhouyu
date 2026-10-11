%%%-----------------------------------
%%% @Module      : lib_rune_check
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 03. 九月 2018 10:21
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_rune_check).
-include("errcode.hrl").
-include("goods.hrl").
-include("rune.hrl").
-include("def_goods.hrl").
-author("chenyiming").

%% API
-compile(export_all).

get_compose_lv(RuleId, GoodIdList) ->
	CheckList = [
		{check_rule, RuleId}         %%检查配置
		, {check_goods, GoodIdList}   %%检查
	],
	check_list(CheckList).

get_decompose_exp(GoodIdList) ->
	CheckList = [
		{check_goods, GoodIdList}   %%检查
		,{check_config, GoodIdList} %%检查分解规则
	],
	check_list(CheckList).

%%其他检查，现在主要是9孔10孔的特殊检查
others_check(ConditionList, GoodsInfo, _Ps) ->
	case lists:keyfind(rune_subtype, 1, ConditionList) of
		{rune_subtype, SubTypeLimitList} ->
			case lists:member(GoodsInfo#goods.subtype, SubTypeLimitList) of
				true ->
					true;
				false ->
					{false, ?ERRCODE(err167_err_rune_subtype)}
			end;
		_ ->
			case lists:keyfind(exclude_rune_subtype, 1, ConditionList) of
				{rune_subtype, ExcludeSubTypeLimitList} ->
					case lists:member(GoodsInfo#goods.subtype, ExcludeSubTypeLimitList) of
						true ->
							{false, ?ERRCODE(err167_err_rune_subtype)};
						false ->
							true
					end;
				_ ->
					true
			end
	end.


check_list([]) ->
	true;
check_list([H | CheckList]) ->
	case check(H) of
		true ->
			check_list(CheckList);
		{false, Res} ->
			{false, Res}
	end.

check({check_rule, RuleId}) ->
	ComposeCfg = data_goods_compose:get_cfg(RuleId),
	if
		is_record(ComposeCfg, goods_compose_cfg) =:= false ->
			{false, ?ERRCODE(missing_config)};
		true ->
			true
	end;
check({check_goods, GoodIdList}) ->
	case get_goods_list(GoodIdList) of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err167_goods_fail)}  %%物品不存在,或者不是符文
	end;
check({check_config, GoodIdList}) ->
	case get_decompose_config(GoodIdList) of
		true ->
			true;
		false ->
			{false, ?MISSING_CONFIG}  %%分解缺失配置
	end;

check(_) ->
	true.


get_goods_list([]) ->
	true;
get_goods_list([H | T]) ->
	case lib_goods_api:get_goods_info(H) of
		[] ->
			false;
		GoodsInfo ->
			#goods{type = Type} = GoodsInfo,
			case Type of
				?GOODS_TYPE_RUNE ->
					get_goods_list(T);
				_ ->
					false
			end
	end.


get_decompose_config([]) ->
	true;
get_decompose_config([H | T]) ->
	case  lib_goods_api:get_goods_info(H) of
		[] ->
			false;
		#goods{goods_id =  Id} ->
			case data_goods_decompose:get(Id) of
				[] ->
					false;
				_ ->
					get_decompose_config(T)
			end
	end.
	
	