%%%-----------------------------------
%%% @Module  : lib_daily_dict
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.05.08
%%% @Description: 每天记录器(只保存缓存,不会写入数据库, 玩家下线不会清除缓存, 只在每日清除)
%%%-----------------------------------
-module(lib_daily_dict).
-include("daily.hrl").
-include("common.hrl").
-export(
    [
	 	set_special_info/2,
		get_special_info/1,
        get/4,
        get_all/1,
        get_count/4,
        set_count/5,
        plus_count/5,
        cut_count/5,
        new/1,
        save/1,
        daily_clear/0,
		get_refresh_time/4,		
        set_refresh_time/4,
        daily_clear_one/1
    ]
).

%% 设置特殊值(无判断)
set_special_info(Key, Value) ->
	put(Key, Value).

%% 获取特殊值(无判断)
get_special_info(Key) ->
	get(Key).

%% 获取整个记录器
get(RoleId, Module, SubModule, Type) ->
    {Res, ModuleId, TypeId} = get_id(Module, SubModule, Type),
    if
        Res=/=true ->             
            #ets_daily_dict{id={RoleId, ModuleId, SubModule, TypeId}, count = 99999};
        true ->
            Data = get_all(RoleId),
            lists:keyfind({RoleId, ModuleId, SubModule, TypeId}, #ets_daily_dict.id, Data)
    end.
    
%% 取玩家的整个记录
get_all(RoleId) ->
    Data =  get(?DAILY_KEY_DICT(RoleId)),
    case Data =:= undefined of
        true ->
            reload(RoleId);
        false ->
            Data
    end.

%% 获取数量
get_count(RoleId, Module, SubModule, TypeList) when is_list(TypeList) ->
    F = fun(Type, Acc) -> Acc ++ [{Type, get_count(RoleId, Module, SubModule, Type)}] end,
    lists:foldl(F, [], TypeList);

get_count(RoleId, Module, SubModule, Type) ->
    case lib_daily_dict:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_daily_dict.count
    end.

%% 设置数量
set_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_daily_dict:get(RoleId, Module, SubModule, Type) of
        false -> save(new([RoleId, Module, SubModule, Type, Count]));
        RD -> save(RD#ets_daily_dict{count = Count})
    end.

%% 追加数量
plus_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_daily_dict:get(RoleId, Module, SubModule, Type) of
        false -> save(new([RoleId, Module, SubModule, Type, Count, ?DEFAULT_OTHER]));
        RD -> save(RD#ets_daily_dict{count = RD#ets_daily_dict.count + Count})
    end.

%% 扣除数量
cut_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_daily_dict:get(RoleId, Module, SubModule, Type) of
        false -> save(new([RoleId, Module, SubModule, Type, Count, ?DEFAULT_OTHER]));
        RD -> save(RD#ets_daily_dict{count = RD#ets_daily_dict.count - Count})
    end.

%% 获取刷新时间
get_refresh_time(RoleId, Module, SubModule, Type) ->
	case lib_daily_dict:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_daily_dict.refresh_time
    end.

%% 更新刷新时间
set_refresh_time(RoleId, Module, SubModule, Type) ->
    case lib_daily_dict:get(RoleId, Module, SubModule, Type) of
        false -> save(new([RoleId, Module, SubModule, Type, 0]));
        RD -> save(RD)
    end.

new([RoleId, Module, SubModule, Type, Count]) ->  
    new([RoleId, Module, SubModule, Type, Count, ?DEFAULT_OTHER]);
new([RoleId, Module, SubModule, Type, Count, Other]) ->  
    #ets_daily_dict{
        id              = {RoleId, Module, SubModule, Type}
        ,count          = Count 
        ,other          = Other
        ,refresh_time   = 0
    }.

save(RoleDaily) ->
    NowTime = utime:unixtime(),
    NewRoleDaily = RoleDaily#ets_daily_dict{ refresh_time=NowTime },
    {RoleId, _ModuleId, _SubModule, _Type} = NewRoleDaily#ets_daily_dict.id,
    Data = get_all(RoleId),
    Data1 = lists:keydelete(NewRoleDaily#ets_daily_dict.id, #ets_daily_dict.id, Data) ++ [NewRoleDaily],
    put(?DAILY_KEY_DICT(RoleId), Data1).

%% 所有数据重载(等于清除某玩家的所有数据了```)
reload(_RoleId) ->
	[].

%% 每天数据清除
daily_clear() ->
    erase().

%% 清除一个人的号的数据
daily_clear_one(RoleId) ->
    erase(?DAILY_KEY_DICT(RoleId)).

get_id(Module, SubModule, Type) ->
    Config = get_config(Module, SubModule, Type),
    case Config of
        [] -> 
            {error, Module, Type};
        #base_daily{} -> 
            {true, Module, Type}
    end.

get_config(Module, SubModule, Type) ->
    case SubModule ==?DEFAULT_SUB_MODULE of
        true -> Config = data_daily:get_id(Module, Type);
        false -> Config = data_daily_extra:get_id(Module, SubModule)
    end,
    case Config of
        [] -> 
            ?ERR(">>>>> important >>>>> missing config:~p~n", [{Module, SubModule, Type}]);
        _ -> skip
    end,
    Config.