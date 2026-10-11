%%% -------------------------------------------------------
%%% @author huangyongxing@yeah.net
%%% @doc
%%% TA分析系统的相关数据校验接口
%%% ta_agent模块的内部模块，外部功能系统不要直接调用
%%% -------------------------------------------------------
%%% 关于事件属性
%%%
%%% 虽然字符串可以用binary、list和atom表示，但是在这里要求所有事件名都采用atom，
%%% 这样做，对于属性名合法性的检查，可以避免不同表示方法带来的麻烦，
%%% 同时，也减少了验证计算，提升效率。
%%%
%%% 这里对事件属性名atom的字面字符串值不做检查【由后台配置】，
%%% 命名必须要符合TA系统的要求，即只能使用数字、字母和下划线，长度小于50。
%%% @end
%%% @since 2021-05-18
%%% -------------------------------------------------------
-module(ta_agent_properties).
-export([
        verify_pre_data/1
        ,pack_to_agent/5
        ,raw_to_agent/7

        ,ta_spcl_data/2
        ,valid_ta_base_key/1
    ]).

% for test
-export([
        trans_properties/2
        ,base_data/4
        ,common_data/2
    ]).

-include("server.hrl").
-include("figure.hrl").
-include("rec_recharge.hrl").
-include("weekly_card.hrl").
-include("common.hrl").

%% -------------------------------------------------------------------
%% 属性数据校验、转换管理
%% -------------------------------------------------------------------

%% 基础数据
%% 即TA上报数据中，与properties同一层的基础数据
%% 前端在未登录时，使用访客id（#distinct_id）进行事件上报
%% 服务端缺失访客id（#distinct_id），但是为了辅助TA系统做数据分析，
%%   由客户端在登录时上报给服务端缓存，便于在事件中添加该属性
%% base_data(PS, TAType, TAEventName, Time) -> BaseMap :: #{}.
%% TA上报数据中基础数据只包含以下项：
%%   表示触发用户的账号 ID #account_id 与访客 ID #distinct_id
%%   表示触发时间#time ，可精确到秒或毫秒
%%   表示数据类型（事件还是用户属性设置）的#type
%%   表示事件名称的#event_name （仅事件数据带有）
%%   表示用户 IP 的#ip
%%   表示数据唯一性的#uuid
%% 【根据TA提供的资料，访客id(#distinct_id)是在安装软件时触发生成的特征值】
%%
%% N.B: 特别注意，TA外层数据，只能包含以上字段和properties，如上报其他字段将被TA系统忽略
base_data(#player_status{id = Id, ip = Ip, ta_spcl_base = TaSpclBase}, TAType, TAEventName, Time) ->
    %% TaSpclBase中，包含了其他基础参数，例如#distinct_id等
    case valid_type(TAType) andalso verify_event_name(TAType, TAEventName) of
        true  ->
            %% "#time"在这里不设置，在上传前，才由'$time'参数转换得到对应字符串
            %% 管理进程需要使用'$time'进行一系列管理
            %% Time暂时仅支持秒级时间戳【暂无必要支持毫秒级Time，有必要再考虑】
            %% 表示数据唯一性的"#uuid"非必须，后续看情况决定是否添加
            BaseMap = #{
                '#account_id' => integer_to_binary(Id)
                ,'#ip' => unicode:characters_to_binary(Ip)
                ,'#type' => TAType
                ,'$time' => get_trigger_time(Time)
            },
            NewBaseMap = data_set_spcl_base(BaseMap, TaSpclBase),
            %% 仅事件数据才有#event_name
            case TAType of
                track -> NewBaseMap#{'#event_name' => TAEventName};
                _     -> NewBaseMap
            end;
        false ->
            error
    end.

%% TA的一部分非必须基础参数及全局公共参数
%% 注意：基础参数指TA上报数据结构的外层，公共参数指properties内层
%% -> {TaSpclBase, TaSpclCommon}
ta_spcl_data(TaGuestId, TaDeviceId) ->
    {
        #{'#distinct_id' => TaGuestId},
        #{'#device_id'   => TaDeviceId}
    }.

%% TA BaseData设置一些非必须的基础参数 或 TA Properties设置特殊公共属性
%% DataMap :: BaseData | Properties
data_set_spcl(BaseData, {TaSpclBase, _TaSpclCommon}, base) ->
    data_set_spcl_base(BaseData, TaSpclBase);
data_set_spcl(Properties, {_TaSpclBase, TaSpclCommon}, common) ->
    data_set_spcl_common(Properties, TaSpclCommon);
data_set_spcl(DataMap, _TaSpclData, _SetType) ->
    DataMap.

data_set_spcl_base(BaseData, TaSpclBase) ->
    KeyList = ['#distinct_id'],
    data_set(BaseData, KeyList, TaSpclBase).

data_set_spcl_common(Properties, TaSpclCommon) ->
    KeyList = ['#device_id'],
    data_set(Properties, KeyList, TaSpclCommon).

data_set(DataMapAcc, [Key | KeyList], SpclData) ->
    NewDataMapAcc =
    case maps:get(Key, SpclData, undefined) of
        undefined -> DataMapAcc;
        Value     -> DataMapAcc#{Key => Value}
    end,
    data_set(NewDataMapAcc, KeyList, SpclData);
data_set(DataMapAcc, [], _SpclData) ->
    DataMapAcc.

%% 公共属性
%% 每条事件都需要上报，属于TA上报数据中properties的公共部分。
%% （common_data数据通常不需要经过键的有效性校验，调用track_raw接口除外）
%% 完整properties需要合并事件其他参数，使用maps:merge(CommonProperties, Data)进行合并
common_data(#player_status{
        accname = Accname
        ,figure = #figure{lv = RoleLevel, vip = VipLevel}
        ,combat_power = Power
        ,recharge_statistic = #role_recharge_statistic{
            total_money = TotalMoney
        }
        ,weekly_card_status = #weekly_card_status{lv = WeeklyCardLv, is_activity = IsActivityWeekly}
        ,ta_spcl_common = TaSpclCommon
    } = PS, TAType) ->
    %% 不在这里设置的common_data：
    %% 开服时间（open_day），在外层通过base_data中的'$time'参数计算对应开服天数
    IsMonthCard = lib_investment:is_month_card(PS),
    CommonProperties = #{
        accname => unicode:characters_to_binary(Accname)
        ,vip_level => VipLevel
        ,role_level => RoleLevel
        ,current_power => Power
        ,total_pay_amount => TotalMoney
        ,is_month_card => IsMonthCard
        ,weekly_card_lv => WeeklyCardLv
        ,is_weekly_card => (IsActivityWeekly == ?ACTIVATION_OPEN)
    },
    %% 事件类的额外公共属性设置
    case TAType of
        track -> data_set_spcl_common(CommonProperties, TaSpclCommon);
        _     -> CommonProperties
    end.

get_trigger_time(Time) ->
    if
        Time =:= 0 ->   % 未设定时间参数
            utime:unixtime();
        is_integer(Time) andalso Time >= 0 andalso Time =< 16#7FFFFFFF ->
            Time;
        true -> % 设定的时间参数不合法
            utime:unixtime()
    end.

%% 组装需要发送给ta_agent的数据格式
pack_to_agent(PS, TAType, EventName, OtherProperties, TriggerTime) ->
    BaseData = base_data(PS, TAType, EventName, TriggerTime),
    case BaseData of
        #{'$time' := Time} ->
            CommonProperties = common_data(PS, TAType),
            %% 限制字段，过滤多余的数据
            ValidKeys =
            case TAType of
                track -> data_ta_properties:event_keys(EventName);
                _     -> data_ta_properties:get(user_properties)
            end,
            case ValidKeys of
                [_|_] ->
                    %% 对其他数据做校验，确保数据类型正确
                    %% CommonProperties 和 BaseData 为内部接口生成，非外部提供，省去校验CommonProperties
                    NewOtherProperties = trans_properties(OtherProperties, ValidKeys),
                    case is_map(NewOtherProperties) of
                        true  ->
                            Properties = maps:merge(CommonProperties, NewOtherProperties),
                            NewProperties = event_add_open_day(TAType, Properties, Time),
                            BaseData#{properties => NewProperties};
                        false ->
                            error
                    end;
                _ ->
                    error
            
            end;
        _Error ->
            error
    end.

%% 原始数据转换为agent接收的数据
%% 此接口不对数据是否完整做强校验约束，需要调用者保证，否则上报数据会缺失部分属性
%% Properties需要提供的参数包含两部分：
%% 1. 事件公共属性【基本上所有事件都有的属性】
%% 2. 事件特定属性
%% 其中，公共属性中的open_day，在接口调用处可不提供，
%%     将自动由Time计算得到，如果提供了，则使用提供的值
%% raw_to_agent接口，因缺失玩家进程的状态数据，BaseData的必须部分通过参数传入，
%%    非必须的基础部分和公共属性部分，通过TaSpclData传递
raw_to_agent(RoleId, TAType, EventName, Ip, Properties, TaSpclData, TriggerTime) when is_map(Properties) ->
    case valid_type(TAType) andalso verify_event_name(TAType, EventName) of
        true  ->
            Time = get_trigger_time(TriggerTime),
            IpBinStr = unicode:characters_to_binary(Ip),
            BaseDataInit = #{
                '#account_id' => integer_to_binary(RoleId)
                ,'#type' => TAType
                ,'#ip' => IpBinStr
                ,'$time' => Time
            },
            BaseData = data_set_spcl(BaseDataInit, TaSpclData, base),
            NewBaseData =
            case TAType of
                track -> BaseData#{'#event_name' => EventName};
                _     -> BaseData
            end,
            ValidKeys =
            case TAType of
                track ->
                    %% 原始数据接口，Properties含公共属性，所以相关keys要加上，避免被删除
                    data_ta_properties:get(common_properties) ++
                    data_ta_properties:event_keys(EventName);
                _ ->
                    data_ta_properties:get(user_properties)
            end,
            %% 对于事件类的，设置公共事件属性（人物属性类不需要做特殊数据设置）
            PropsSetSpcl =
            case TAType of
                track -> data_set_spcl(Properties, TaSpclData, common);
                _     -> Properties
            end,
            %% 属性校验，确保数据类型正确
            TransProperties = trans_properties(PropsSetSpcl, ValidKeys),
            %% 检查补齐公共属性open_day
            NewProperties =
            case TransProperties of
                #{'open_day' := _} ->
                    NewBaseData#{properties => TransProperties};
                _ when is_map(TransProperties) ->
                    event_add_open_day(TAType, TransProperties, Time);
                _ ->    % not a map
                    TransProperties
            end,
            case is_map(NewProperties) of
                true  ->
                    NewBaseData#{properties => NewProperties};
                false ->
                    %% 出错情形，数据为错误原因
                    NewProperties
            end;
        false ->
            error
    end.

%% 事件添加公共属性open_day
event_add_open_day(track, Properties, Time) ->
    %% 补齐事件公共属性open_day
    OpenDay = util:get_open_day(Time),
    Properties#{open_day => OpenDay};
event_add_open_day(_TAType, Properties, _Time) ->
    %% 非事件（例如人物属性设置），不添加open_day属性
    Properties.

%% 对数据做校验，确保数据类型正确
%% 这个接口会排除掉不在ValidKeys中的数据，
%% 同时如果ValidKeys中的数据，其值的类型不正确，会返回错误
-spec trans_properties(Properties, ValidKeys) -> NewProperties | Error when
    Properties :: #{}, NewProperties :: #{Key => Val},
    Error :: {error_property, Key, RealType :: any()},
    ValidKeys :: [ Key ],
    Key :: atom(), Val :: ta_agent:ta_val().
trans_properties(Properties, ValidKeys) ->
    case properties_with_keys(ValidKeys, Properties, []) of
        {error_property, _Key, _RealType} = Error ->
            Error;
        KVList ->
            maps:from_list(KVList)
    end.

properties_with_keys([Key|Ks], Map, Acc) ->
    case Map of
        #{Key := Val} ->
            NewVal = check_data_type(Key, Val),
            case NewVal of
                {error, _RealType} ->
                    ?MYLOG("ta", "properties_with_keys {Key, Val, NewVal}:~p", [{Key, Val, NewVal}]),
                    % 同步到深海服要去掉
                    % ?INFO("properties_with_keys {Key, Val, NewVal}:~p", [{Key, Val, NewVal}]),
                    {error_property, Key, _RealType};
                _ ->
                    NewAcc = [{Key, NewVal} | Acc],
                    properties_with_keys(Ks, Map, NewAcc)
            end;
        _ ->
            properties_with_keys(Ks, Map, Acc)
    end;
properties_with_keys([], _Map, Acc) ->
    Acc.

%% 属性的数据类型：
%% 数据类型1-string,2-number,3-bool,4-time,5-array
%% check_data_type(Key, Val) -> {error, NeedType} | NewVal
check_data_type(Key, Val) ->
    RealType = data_ta_properties:property_data_type(Key),
    case RealType of
        1 ->    % string
            %% 如果非atom、binary-string，将自动检查转换为binary string
            if
                is_atom(Val) ->
                    Val;
                is_binary(Val) ->
                    case text_enc:is_utf8_bytes(Val) of
                        true  -> Val;
                        false -> {error, RealType}
                    end;
                is_integer(Val) ->
                    integer_to_binary(Val);
                is_list(Val) ->
                    text_enc:get_text(Val, binary);
                true ->
                    {error, RealType}
            end;
        2 ->    % number
            %% 如果不是数字将出错
            case is_number(Val) of
                true  -> Val;
                false -> {error, RealType}
            end;
        3 ->    % bool
            %% 可使用true | false | 1 | 0
            %% 如果是整型数字则0为false，1为true，其他为错误（防止使用错误）
            %% 如果非数字、非boolean则错误
            if
                is_boolean(Val) -> Val;
                is_integer(Val) ->
                    if
                        Val =:= 0 -> false;
                        Val =:= 1 -> true;
                        true -> {error, RealType}
                    end;
                true -> {error, RealType}
            end;
        4 ->    % TA时间字符串 - 注意：游戏服中要求使用秒级时间戳
            %% 需要使用时间戳(数字)，会自动转换为binary字符串，不允许使用其他值
            case is_integer(Val) andalso Val >= 0 of
                true  ->
                    %% 防止数据超2038年， 16#7FFFFFFF 是有符号32位整型上限
                    FixTime = min(16#7FFFFFFF, Val),
                    utime:unixtime_to_timestr(FixTime);
                false ->
                    {error, RealType}
            end;
        5 ->    % array
            %% 为提高效率，这里不再遍历检验，如果设置错误值，上报TA可能是无效数据
            %% 注意：要求必须是list，并且元素不能是list，即要求array中元素，
            %% 可以使用binary-string、atom、bool、number，不能再是其他值。
            %% 【上传到TA后，其中子元素都将转换为字符串】
            case is_list(Val) of
                true  ->
                    %% 2022年3月28日 还是需要遍历强检查，防止上报阻塞
                    case valid_array_elem(Val) of
                        true -> Val;
                        false -> {error, RealType}
                    end;
                false -> {error, RealType}
            end;
        _ ->
            {error, undefined}
    end.

%% array的元素只能是binary-string、atom、bool、number
%% 其中，bool是atom的特定数据，所以不用额外检查
valid_array_elem([Elem | Remain]) ->
    case is_binary(Elem) orelse is_atom(Elem) orelse is_number(Elem) of
        true -> valid_array_elem(Remain);
        false -> false
    end;
valid_array_elem([]) -> true.

%% 向TA系统上报的数据#type的值是否合法
%% 目前只使用到user_set、user_setOnce和track，其他值不提供接口
valid_type(user_set)     -> true;
valid_type(user_setOnce) -> true;
valid_type(track)        -> true;
valid_type(_)            -> false.

%% 角色TaBase数据的Key校验接口
valid_ta_base_key('#distinct_id') -> true;
valid_ta_base_key('#account_id')  -> true;
valid_ta_base_key('#ip')          -> true;
valid_ta_base_key('#type')        -> true;
valid_ta_base_key('#time')        -> true;
valid_ta_base_key('#event_name')  -> true;
valid_ta_base_key('#properties')  -> true;
valid_ta_base_key(_) -> false.

%% 基本的校验，检查数据合法性
verify_pre_data(#{
        '#type' := track
        ,'#event_name' := EventName
        ,'#account_id' := _
        ,'#ip' := _
        ,'$time' := _
        ,properties := _
    }) ->
    %% 当'#type' => track，必须有'#event_name'
    verify_event_name(track, EventName);
verify_pre_data(#{
        '#type' := Type
        ,'#account_id' := _
        ,'#ip' := _
        ,'$time' := _
        ,properties := _
    }) ->
    valid_type(Type);
verify_pre_data(_) ->
    false.

%% 事件名基本检查
verify_event_name(track, undefined) ->
    false;
verify_event_name(track, EventName) ->
    is_atom(EventName);
verify_event_name(_, _) ->
    true.
