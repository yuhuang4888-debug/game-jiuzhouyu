%% ---------------------------------------------------------------------------
%% @doc 伤害统计
%% @author hek
%% @since  2016-11-14
%% @deprecated 本模块提供伤害统计服务
%% ---------------------------------------------------------------------------
-module (lib_hurt_statis_mod).
-include ("common.hrl").
-include ("partner.hrl").
-include ("def_fun.hrl").
-include ("rec_hurt_statis.hrl").
-export ([
	hurt/2
]).

hurt(Args, State) ->
	#hurt_statis_state{
		type = StatisType
	} = State,
	hurt(StatisType, Args, State).

hurt(?TYPE_1V1_WITH_PARTNER, {Id, Sign, Hurt}, State) ->
	#hurt_statis_state{data = Data} = State,
	AddValue 	= Hurt,
	InitData 	= ?IF(Data == undefined, #{}, Data),
	RecObject 	= maps:get(Id, InitData, #statis_1v1_object{id = Id, sign = Sign}),
	OldHurt     = RecObject#statis_1v1_object.hurt,
	NewRecObject= RecObject#statis_1v1_object{hurt = OldHurt + AddValue},
	NewData 	= maps:put(Id, NewRecObject, InitData),
	{ok, State#hurt_statis_state{data = NewData}};

hurt(_Type, Args, State) ->
	?ERR("unkown statis_type:~p,~p~n", [_Type, Args]),
	{ok, State}.