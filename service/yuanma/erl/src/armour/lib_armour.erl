%%% ---------------------------------------------------------------------------
%%% @doc            lib_armour.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @since          2021-03-08
%%% @description    战甲库函数
%%% ---------------------------------------------------------------------------
-module(lib_armour).

-include("armour.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("server.hrl").

-export([
    login/1                     % 登录
    ,get_attr/1                 % 获取属性
]).

-export([
    get_armour_info/3           % 获取玩家战甲信息
    ,make_armour/4              % 打造战甲
]).

-export([
    get_pos_list_by_type/1      % 根据战甲类型获取部位列表
    ,get_real_consume_goods/1   % 获取真正的物品消耗列表 
]).

%%% ================================ 外部加载/获取相关 ================================

%% 登录加载战甲数据
login(PS) ->
    #player_status{id = PlayerId} = PS,
    case db_armour_select(PlayerId) of
        [] -> Armour = #armour{};
        InfoList ->
            BasicArmour = init_armour_data(InfoList, #armour{}),
            ArmourAttr = get_attr(BasicArmour),
            Armour = BasicArmour#armour{attr = ArmourAttr}
    end,
    NewPS = PS#player_status{armour = Armour},
    NewPS.

%% 获取属性
get_attr(PS) when is_record(PS, player_status) ->
    #player_status{armour = Armour} = PS,
    #armour{attr = ArmourAttr} = Armour,
    ArmourAttr;
get_attr(Armour) when is_record(Armour, armour) ->
    #armour{armour_map = AMap} = Armour,
    get_attr(AMap);
get_attr(AMap) when is_map(AMap) ->
    F = fun({Stage, Type}, ActPosL, Acc) ->
        % 获取各个装备部位的属性列表
        EquipAttr = get_equip_attr(Stage, Type, ActPosL, []),
        % 获取套装属性列表
        SuitAttr = get_suit_attr(Stage, Type, ActPosL),
        % 汇总
        EquipAttr ++ SuitAttr ++ Acc
    end,
    ArmourAttr = maps:fold(F, [], AMap),
    ArmourAttr;

get_attr(_) -> [].

%%% ================================ 协议相关 ================================

%% 获取玩家战甲信息
%% @return [{Stage, [{Type, TypeStatus, [{Pos, PosStatus}...]}...]}...]
get_armour_info(PS, 0, 0) ->    % 全部获取
    AllStage = data_armour:get_all_stage(),
    F1 = fun(Stage, Acc1) ->    % Acc1 :: [{Stage, TypeList}...]
        AllType = data_armour:get_all_type(Stage),
        F2 = fun(Type, Acc2) -> % Acc2 :: [{Type, TypeStatus, PosList}...]
            [{Stage, TypeList}] = get_armour_info(PS, Stage, Type),
            TypeList ++ Acc2
        end,
        TypeAcc = lists:foldl(F2, [], AllType),
        [{Stage, TypeAcc} | Acc1]
    end,
    lists:foldl(F1, [], AllStage);
get_armour_info(PS, Stage, Type) -> % 获取单个部分
    #player_status{armour = #armour{armour_map = AMap}} = PS,
    AllPos = get_pos_list_by_type(Type),
    ActPos = maps:get({Stage, Type}, AMap, []), % 已打造部位
    F = fun(Pos, Acc) ->
        #base_armour_equipment{
            id = GTypeId
        } = data_armour:get_armour_equipment(Stage, Type, Pos),
        case lists:member(Pos, ActPos) of
            true ->
                [{GTypeId, Pos, ?ACTIVATED} | Acc];
            false ->
                [{GTypeId, Pos, ?UN_ACTIVATED} | Acc]
        end
    end,
    PosList = lists:foldl(F, [], AllPos),   % PosList :: [{Pos, PosStatus}...]
    TypeStatus = ?IF(is_suit_activated(Type, ActPos), ?ACTIVATED, ?UN_ACTIVATED),
    [{Stage, [{Type, TypeStatus, PosList}]}].

%% 打造战甲
%% @return {NewPS, ArmourInfo} | {false, ErrCode}
make_armour(PS, Stage, Type, Pos) ->
    case lib_armour_check:make_armour(PS, Stage, Type, Pos) of
        ObjectList when is_list(ObjectList) ->
            do_make_armour(PS, Stage, Type, Pos, ObjectList);
        {false, ErrCode} ->
            {false, ErrCode};
        _ ->
            {false, ?FAIL}
    end.

do_make_armour(PS, Stage, Type, Pos, ObjectList) ->
    case lib_goods_api:cost_object_list(PS, ObjectList, make_armour, "") of
        {true, CostPS} ->
            #player_status{id = PlayerId, armour = Armour} = CostPS,
            % 更新Armour状态数据
            #armour{armour_map = AMap} = Armour,
            OPosList = maps:get({Stage, Type}, AMap, []),
            NPosList = [Pos|OPosList],
            NewAMap = maps:put({Stage, Type}, NPosList, AMap),
            NewAttr = get_attr(NewAMap),
            NewArmour = Armour#armour{armour_map = NewAMap, attr = NewAttr},
            StatusPS = CostPS#player_status{armour = NewArmour},
            % 日志
            log_make_armour(StatusPS, Stage, Type, Pos),
            % 入库
            db_armour_replace(PlayerId, Stage, Type, NPosList),
            % 属性计算
            AttrPS = lib_player:count_player_attribute(StatusPS),
            lib_player:send_attribute_change_notify(AttrPS, ?NOTIFY_ATTR),
            % 战甲信息反馈
            ArmourInfo = get_armour_info(AttrPS, Stage, Type),
            {AttrPS, ArmourInfo};
        {false, ErrCode, _} ->
            {false, ErrCode}
    end.

%%% ================================ 其它数据相关 ================================

%% 战甲数据初始化
%% @return Armour :: #armour{}
init_armour_data([], Armour) -> Armour;
init_armour_data([[Stage, Type, PosList]|T], Armour) ->
    #armour{armour_map = AMap} = Armour,
    NewAMap = maps:put({Stage, Type}, PosList, AMap),
    NewArmour = Armour#armour{armour_map = NewAMap},
    init_armour_data(T, NewArmour).

% 获取各个装备部位的属性列表
get_equip_attr(_Stage, _Type, [], AccAttr) -> AccAttr;
get_equip_attr(Stage, Type, [Pos|T], AccAttr) ->
    EquipmentCfg = data_armour:get_armour_equipment(Stage, Type, Pos),
    case EquipmentCfg of
        #base_armour_equipment{attr = Attr} -> skip;
        _ ->
            ?ERR("config error ~p~n", [{Stage, Type, Pos}]),
            Attr = []
    end,
    get_equip_attr(Stage, Type, T, Attr ++ AccAttr).

% 获取套装属性列表
get_suit_attr(Stage, Type, ActPosL) ->
    SuitCfg = data_armour:get_armour_suit(Stage, Type),
    IsActivated = is_suit_activated(Type, ActPosL),
    if
        is_record(SuitCfg, base_armour_suit) =:= false ->
            ?ERR("config error ~p~n", [{Stage, Type}]),
            Attr = [];
        IsActivated =:= false ->
            Attr = [];
        true ->
            #base_armour_suit{attr = Attr} = SuitCfg
    end,
    Attr.

%% 根据战甲类型获取部位列表
get_pos_list_by_type(?ARMOUR_INSPIRE) ->
    [PosList] = ?ARMOUR_INSPIRE_POS,
    PosList;
get_pos_list_by_type(?ARMOUR_SAINT) ->
    [PosList] = ?ARMOUR_SAINT_POS,
    PosList;
get_pos_list_by_type(_) ->
    [].

%% 判断是否能激活套装
%% @return boolean()
is_suit_activated(Type, ActPos) ->
    AllPos = get_pos_list_by_type(Type),
    (AllPos--ActPos) == [].
% is_suit_activated(AMap, Stage, Type) ->
%     ActPos = maps:get({Stage, Type}, AMap, []),
%     is_suit_activated(Type, ActPos).

%% 获取真正的物品消耗列表
%% @param ConsumeList :: [{Type, GTypeId, Num}...]
get_real_consume_goods(ConsumeList) ->
    F = fun({_, GTypeId, _} = Goods, Acc) ->
        #ets_goods_type{type = Type, subtype = SubType} = data_goods_type:get(GTypeId),
        case Type =:= ?GOODS_TYPE_ARMOUR andalso lists:member(SubType, ?GOODS_SUBTYPE_ARMOUR_EQUIP_LIST) of
            true -> Acc;    % 过滤掉战甲装备物品(并没有真实存在,仅相当于一个状态,但因客户端需要显示所以有相关配置)
            false -> [Goods|Acc]
        end
    end,
    lists:foldl(F, [], ConsumeList).

%% 打造日志
log_make_armour(PS, Stage, Type, Pos) ->
    #player_status{id = RoleId, armour = Armour, figure = Figure} = PS,
    #figure{name = RoleName} = Figure,
    #armour{armour_map = AMap} = Armour,
    #base_armour_equipment{id = EquipId, consume = ConsumeList} = data_armour:get_armour_equipment(Stage, Type, Pos),
    PosList = maps:get({Stage, Type}, AMap, []),
    F = fun(PosId, Acc) ->
        #base_armour_equipment{id = SuitEquipId} = data_armour:get_armour_equipment(Stage, Type, PosId),
        [SuitEquipId|Acc]
    end,
    EquipList = lists:foldl(F, [], PosList),
    lib_log_api:log_armour(RoleId, RoleName, Stage, Type, Pos, EquipId, ConsumeList, EquipList).

%%% ================================ sql相关 ================================

%% @return [[Stage, Type, PosList]...]
db_armour_select(PlayerId) ->
    Sql = io_lib:format(?SQL_ARMOUR_SELECT, [PlayerId]),
    Infos = db:get_all(Sql),
    F = fun([Stage, Type, PosListBin]) ->
        PosList = util:bitstring_to_term(PosListBin),
        [Stage, Type, PosList]
    end,
    lists:map(F, Infos).

db_armour_replace(PlayerId, Stage, Type, PosList) ->
    PosListBin = util:term_to_bitstring(PosList),
    Sql = io_lib:format(?SQL_ARMOUR_REPLACE, [PlayerId, Stage, Type, PosListBin]),
    db:execute(Sql).