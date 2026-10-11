%% ---------------------------------------------------------------------------
%% @doc lib_dragon_equip.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-12-18
%% @deprecated 龍紋裝備
%% ---------------------------------------------------------------------------
-module(lib_dragon_equip).

-export([
        calc_equip_attr/2
        , get_equip_skill_list/2
        , calc_goods_power/1
    ]).

-export([
        %% 龍紋升級
        up_lv/2
        %% 穿戴龍紋裝備
        , equip/3
        %% 獲得龍紋等級
        , get_dragon_lv/2
        %% 卸下龍紋裝備
        , unequip/2
        %% 龍紋分解
        , decompose/2
    ]).

-compile(export_all).

-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("dragon.hrl").
-include("figure.hrl").
-include("attr.hrl").

%% --------------------------------------------------------
%% 計算/介面
%% --------------------------------------------------------

calc_one_equip_attr(GoodsTypeId, Level, Career) ->
    case data_dragon:get_star_and_lv(Level) of
        {_, _Star} ->
            case data_dragon:get_star_up_cfg(GoodsTypeId, _Star) of
                #base_dragon_star_up{skill = SkillCfg} -> 
                    case lists:keyfind(Career, 1, SkillCfg) of
                        {_, OneSkillList} ->
                            OneSkillList;
                        _ -> OneSkillList = []
                    end;
                _ -> OneSkillList = []
            end;
        _ ->
            OneSkillList = []
    end,
    EquipAttrList = each_equip_attr(GoodsTypeId, Level),
    EquipAttrSpecialList = calc_special_attr(EquipAttrList),
    TotalAttr = lib_player_attr:add_attr(record, [[], EquipAttrList]),
    {TotalAttr, EquipAttrSpecialList, OneSkillList}.

%% 計算裝備屬性
calc_equip_attr(Player, GoodsStatus) ->
    #player_status{id = PlayerId, figure = #figure{lv = _PlayerLev}} = Player,
    #goods_status{dict = Dict} = GoodsStatus,
    {EquipAttrList, EquipAttrSpecialList} = calc_equip_special_attr(PlayerId, Dict),
    TotalAttr = lib_player_attr:add_attr(record, [EquipAttrList]),
    % ?PRINT("======== EquipAttrList:~w~n, TotalAttr:~p~n",[EquipAttrList,TotalAttr]),
    {TotalAttr, EquipAttrSpecialList}.

calc_equip_special_attr(PlayerId, GoodsDict) ->
    EquipList = lib_goods_util:get_equip_list(
        PlayerId, ?GOODS_TYPE_DRAGON_EQUIP, ?GOODS_LOC_DRAGON_EQUIP, GoodsDict),
    %% 每件裝備屬性累加
    EquipAttrList = all_equip_attr(EquipList, []),
    EquipAttrSpecialList = calc_special_attr(EquipAttrList),
    {EquipAttrList, EquipAttrSpecialList}.

%% 所有裝備的屬性
all_equip_attr([], AttrList) ->
    AttrList;
all_equip_attr([EquipInfo | T], AttrList) ->
    EquipAttr = each_equip_attr(EquipInfo),
    NewAttr = lib_player_attr:add_attr(list, [AttrList, EquipAttr]),
    all_equip_attr(T, NewAttr).

each_equip_attr(EquipInfo) ->
    #goods{goods_id = GoodsTypeId, level = Level} = EquipInfo,
    % case data_dragon:get_dragon_lv(GoodsTypeId, Lv) of
    %     [] -> AttrList = [];
    %     #base_dragon_lv{attr_list = AttrList} -> ok
    % end,
    case data_dragon:get_star_and_lv(Level) of
        {Lv, Star} ->
            case data_dragon:get_star_up_cfg(GoodsTypeId, Star) of
                #base_dragon_star_up{attr = Attr} ->skip;
                _ -> Attr = []
            end,
            case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                [] -> AttrList = Attr;
                #base_dragon_lv_up{lv_min = MinLv, base_attr = BaseAttr, add_attr = AddAttr} -> 
                    AttrL = calc_real_list(MinLv, Lv, BaseAttr, AddAttr),
                    AttrList = AttrL++Attr
            end;
        _ ->
            AttrList = []
    end,
    AttrList.

each_equip_attr(GoodsTypeId, Level) ->
    case data_dragon:get_star_and_lv(Level) of
        {Lv, Star} ->
            case data_dragon:get_star_up_cfg(GoodsTypeId, Star) of
                #base_dragon_star_up{attr = Attr} ->skip;
                _ -> Attr = []
            end,
            case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                [] -> AttrList = Attr;
                #base_dragon_lv_up{lv_min = MinLv, base_attr = BaseAttr, add_attr = AddAttr} -> 
                    AttrL = calc_real_list(MinLv, Lv, BaseAttr, AddAttr),
                    AttrList = AttrL++Attr
            end;
        _ ->
            AttrList = []
    end,
    AttrList.

calc_special_attr(AttrList) ->
    Fun = fun({AttrId, Value}, Acc) ->
        case lists:member(AttrId, ?EQUIP_ADD_RATIO_TYPE) of
            true -> 
                case lists:keyfind(AttrId, 1, Acc) of
                    {AttrId, OldValue} ->
                        lists:keystore(AttrId, 1, Acc, {AttrId, Value+OldValue});
                    _ ->
                        lists:keystore(AttrId, 1, Acc, {AttrId, Value})
                end;
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], AttrList).

get_equip_attr(GoodsTypeId) ->
    #ets_goods_type{type = Type, level = Level} = data_goods_type:get(GoodsTypeId),
    if
        Type == ?GOODS_TYPE_DRAGON_EQUIP ->
            case data_dragon:get_star_and_lv(Level) of
                {Lv, Star} ->
                    case data_dragon:get_star_up_cfg(GoodsTypeId, Star) of
                        #base_dragon_star_up{attr = Attr} ->skip;
                        _ -> Attr = []
                    end,
                    case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                        [] -> AttrList = Attr;
                        #base_dragon_lv_up{lv_min = MinLv, base_attr = BaseAttr, add_attr = AddAttr} -> 
                            AttrL = calc_real_list(MinLv, Lv, BaseAttr, AddAttr),
                            AttrList = AttrL++Attr
                    end;
                _ ->
                    AttrList = []
            end;
        true ->
            AttrList = []
    end,
    AttrList.

calc_real_list(MinLv, Lv, [{_,_,_}|_] = BaseList, [{_,_,_}|_] = AddList) when is_integer(MinLv) andalso is_integer(Lv) ->
    Fun = fun({_Type,Key,Tem}, Acc) ->
        case lists:keyfind(Key,2,Acc) of
            {T, Key, Num} -> lists:keystore(Key, 2, Acc, {T, Key, Num+Tem*(Lv - MinLv)});
            _->lists:keystore(Key, 2, Acc, {_Type, Key, Tem*(Lv - MinLv)})
        end
    end,
    lists:foldl(Fun, BaseList, AddList);
calc_real_list(MinLv, Lv, [{_,_}|_] = BaseList, [{_,_}|_] = AddList) when is_integer(MinLv) andalso is_integer(Lv) ->
    Fun = fun({Key,Tem}, Acc) ->
        case lists:keyfind(Key,1,Acc) of
            {Key, Num} -> lists:keystore(Key, 1, Acc, {Key, Num+Tem*(Lv-MinLv)});
            _->lists:keystore(Key, 1, Acc, {Key, Tem*(Lv -MinLv)})
        end
    end,
    lists:foldl(Fun, BaseList, AddList);
calc_real_list(MinLv, Lv, [{_,_}|_] = BaseList, []) when is_integer(MinLv) andalso is_integer(Lv) ->
    BaseList;
calc_real_list(MinLv, Lv, [{_,_,_}|_] = BaseList, []) when is_integer(MinLv) andalso is_integer(Lv) ->
    BaseList;
calc_real_list(_,_,_,_) -> [].


%% 獲得裝備技能列表
%% @return [{SkillId, lv}]
get_equip_skill_list(Player, GoodsStatus) ->
    #player_status{id = PlayerId, figure = #figure{career = Career, lv = _PlayerLev}} = Player,
    #goods_status{dict = Dict} = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(
        PlayerId, ?GOODS_TYPE_DRAGON_EQUIP, ?GOODS_LOC_DRAGON_EQUIP, Dict),
    F = fun(EquipInfo, SkillList) ->
        #goods{goods_id = GoodsTypeId, level = Level} = EquipInfo,
        % case data_dragon:get_dragon_lv(GoodsTypeId, Lv) of
        %     [] -> SkillList;
        %     #base_dragon_lv{skill_list = OneSkillList} -> OneSkillList++SkillList
        % end
        case data_dragon:get_star_and_lv(Level) of
            {_, _Star} ->
                case data_dragon:get_star_up_cfg(GoodsTypeId, _Star) of
                    #base_dragon_star_up{skill = SkillCfg} -> 
                        case lists:keyfind(Career, 1, SkillCfg) of
                            {_, OneSkillList} ->
                                OneSkillList++SkillList;
                            _ -> SkillList
                        end;
                    _ -> SkillList
                end;
            _ ->
                SkillList
        end
    end,
    lists:foldl(F, [], EquipList).

%% 計算物品戰力
calc_goods_power(GoodsInfo) ->
    Attr = each_equip_attr(GoodsInfo),
    lib_player:calc_all_power(Attr).

%% --------------------------------------------------------
%% 玩家操作
%% --------------------------------------------------------

%% 龍紋升級
up_lv(Player, GoodsId) ->
    case check_up_lv(Player, GoodsId) of
        {false, ErrorCode} -> {false, ErrorCode, Player};
        {true, GoodsInfo, Cost} ->
            #goods{goods_id = GoodsTypeId, level = Level} = GoodsInfo,
            About = lists:concat(["GoodsTypeId:", GoodsTypeId, "Level:", Level+1]),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, dragon_up_lv, About) of
                {false, ErrorCode, NewPlayer} -> {false, ErrorCode, NewPlayer};
                {true, NewPlayer} -> do_up_lv(NewPlayer, GoodsInfo)
            end
    end.

%% 檢查龍紋升級
check_up_lv(Player, GoodsId) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    CheckList = [
        % 是否record
        {fun() -> is_record(GoodsInfo, goods) end, ?ERRCODE(err181_not_goods_exist)},
        % 是否龍紋裝備
        {fun() -> is_dragon_equip(GoodsInfo) end, ?ERRCODE(err181_not_dragon_equip)},
        % 是否滿級
        % {fun() -> data_dragon:get_dragon_lv(GoodsInfo#goods.goods_id, GoodsInfo#goods.level+1) =/= [] end, ?ERRCODE(err181_max_dragon_lv)},
        fun() -> is_max_level_star(GoodsInfo) end,
        % 消耗是否夠
        fun() -> is_enough_dragon_up_lv_cost(Player, GoodsInfo) end
        ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true -> 
            #goods{goods_id = GoodsTypeId, level = Level} = GoodsInfo,
            {Lv, _Star} = data_dragon:get_star_and_lv(Level),
            {NewLv, _NewStar} = data_dragon:get_star_and_lv(Level+1),
            if
                NewLv == Lv -> %% 升星
                    case data_dragon:get_star_up_cfg(GoodsTypeId, _Star) of
                        #base_dragon_star_up{cost = Cost} ->skip;
                        _ -> ?ERR("MISS CONFIG, STAR:~p,GoodsTypeId:~p~n",[_Star,GoodsTypeId]),Cost = []
                    end;
                true -> %% 升级
                    case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                        [] -> Cost = [];
                        #base_dragon_lv_up{lv_min = MinLv, base_cost = BaseList, add_cost = AddList} -> 
                            Cost = calc_real_list(MinLv, Lv, BaseList, AddList)
                    end
            end,
            % #base_dragon_lv{cost = Cost} = data_dragon:get_dragon_lv(GoodsTypeId, Lv),
            {true, GoodsInfo, Cost}
    end.

do_up_lv(Player, GoodsInfo) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        #goods{level = Level} = GoodsInfo,
        NewGoodsInfo = GoodsInfo#goods{level = Level+1},
        lib_goods_util:change_goods_level(NewGoodsInfo),
        NewDict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
        %% 更新dict,對比舊的dict,通知客戶端材料變化
        {LastDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewDict),
        lib_goods_api:notify_client(GoodsStatus#goods_status.player_id, GoodsL),
        NewGoodsStatus = GoodsStatus#goods_status{dict=LastDict},
        {ok, NewGoodsStatus, NewGoodsInfo}
    end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, NewGoodsInfo} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            case GoodsInfo#goods.location == ?GOODS_LOC_DRAGON_EQUIP of
                true -> 
                    NewPlayer = lib_dragon:pos_unlock(Player),
                    NewPlayer2 = lib_dragon:calc_dragon_and_notify(NewPlayer);
                false -> 
                    NewPlayer2 = Player
            end,
            lib_rush_rank_api:reflash_rank_by_dragon_rush(NewPlayer2),
%%            lib_hi_point_api:hi_point_task_dragon_lv(NewGoodsStatus, NewPlayer2),
            log_dragon_lv(NewPlayer2, NewGoodsInfo, GoodsInfo),
            LastPS = lib_demons_api:dragon_up_lv(NewPlayer2),
            {true, LastPS};
        Error ->
            ?ERR("~p up_lv error:~p", [?MODULE, Error]),
            {false, ?FAIL, Player}
    end.

%% 是否龍紋裝備
is_dragon_equip(GoodsInfo) ->
    GoodsInfo#goods.type == ?GOODS_TYPE_DRAGON_EQUIP andalso 
        lists:member(GoodsInfo#goods.subtype, ?GOODS_SUBTYPE_DRAGON_EQUIP_LIST).

%% 是否夠龍紋升級消耗
%% @return true|{false,錯誤碼}
is_enough_dragon_up_lv_cost(Player, GoodsInfo) ->
    #goods{goods_id = GoodsTypeId, level = Level} = GoodsInfo,
    case data_dragon:get_star_and_lv(Level) of
        {Lv, Star} ->
            case data_dragon:get_star_and_lv(Level + 1) of
                {NewLv, _} when Lv == NewLv ->
                    case data_dragon:get_star_up_cfg(GoodsTypeId, Star) of
                        #base_dragon_star_up{cost = SCost} ->
                            lib_goods_api:check_object_list(Player, SCost);
                        _ -> {false, ?ERRCODE(err181_max_dragon_lv)}
                    end;
                _ ->
                    case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                        [] -> {false, ?ERRCODE(err181_max_dragon_lv)};
                        #base_dragon_lv_up{lv_min = MinLv, base_cost = BaseList, add_cost = AddList} -> 
                            Cost = calc_real_list(MinLv, Lv, BaseList, AddList),
                            lib_goods_api:check_object_list(Player, Cost)
                    end
            end;
        _ ->
            {false, ?ERRCODE(err181_max_dragon_lv)}
    end.
    % case data_dragon:get_dragon_lv(GoodsTypeId, Lv) of
    %     [] -> {false, ?ERRCODE(err181_max_dragon_lv)};
    %     #base_dragon_lv{cost = Cost} ->
    %         lib_goods_api:check_object_list(Player, Cost)
    % end.

%% 是否最大等级/星级
is_max_level_star(GoodsInfo) ->
    #goods{goods_id = GoodsTypeId, level = Level} = GoodsInfo,
    {Lv, _Star} = data_dragon:get_star_and_lv(Level),
    case data_dragon:get_star_and_lv(Level+1) of
        {NewLv, _NewStar} ->
            if
                NewLv == Lv -> %% 升星
                    case data_dragon:get_star_up_cfg(GoodsTypeId, _NewStar) of
                        #base_dragon_star_up{} -> true;
                        _ -> {false, ?ERRCODE(err181_max_dragon_lv)}
                    end;
                true -> %% 升级
                    case data_dragon:get_lv_up_cfg(GoodsTypeId, NewLv) of
                        #base_dragon_lv_up{} -> true;
                        _ -> {false, ?ERRCODE(err181_max_dragon_lv)}
                    end
            end;
        _ ->
            {false, ?ERRCODE(err181_max_dragon_lv)}
    end.

%% 穿戴龍紋裝備
equip(Player, GoodsId, CellPos) ->
    case check_equip(Player, GoodsId, CellPos) of
        {false, ErrorCode} -> {false, ErrorCode, Player};
        {true, GoodsInfo} -> do_equip(Player, GoodsInfo, CellPos)
    end.

check_equip(Player, GoodsId, CellPos) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    GoodsStatus = lib_goods_do:get_goods_status(),
    CheckList = [
        % 是否record
        {fun() -> is_record(GoodsInfo, goods) end, ?ERRCODE(err181_not_goods_exist)},
        % 是否龍紋裝備
        {fun() -> is_dragon_equip(GoodsInfo) end, ?ERRCODE(err181_not_dragon_equip)},
        % 是否正確的裝備職位
        {fun() -> is_right_equip_career(Player, GoodsInfo) end, ?ERRCODE(err181_not_right_equip_career)},
        % 是否滿足槽位許可權
        {fun() -> is_pos_permiss(GoodsInfo, CellPos) end, ?ERRCODE(err181_not_pos_permiss)},
        % 等級是否足夠
        {fun() -> is_enough_dragon_lv(Player, CellPos) end, ?ERRCODE(err181_not_enough_dragon_lv)},
        % 存在相同種類的龍紋
        {fun() -> is_unique_kind(Player, GoodsStatus, GoodsInfo, CellPos) end, ?ERRCODE(err181_not_unique_kind)}
    ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true -> {true, GoodsInfo}
    end.

do_equip(Player, GoodsInfo, Cell) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_equip_core(Player#player_status.id, GoodsStatus, GoodsInfo, Cell)
    end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, NewOldGoodsInfo, OldGoodsInfo, NewGoodsInfo} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            NewPlayer2 = lib_dragon:pos_unlock(Player),
            NewPlayer3 = lib_dragon:calc_dragon_and_notify(NewPlayer2),
            lib_rush_rank_api:reflash_rank_by_dragon_rush(NewPlayer3),
            LastPS = lib_demons_api:dragon_up_lv(NewPlayer3),
            log_dragon_equip(LastPS, NewGoodsInfo, GoodsInfo, 1),
            log_dragon_equip(LastPS, NewOldGoodsInfo, OldGoodsInfo, 2),
            {true, ?SUCCESS, LastPS};
        Error ->
            ?ERR("equip error:~p", [Error]),
            {false, ?FAIL, Player}
    end.

do_equip_core(PlayerId, GoodsStatus, GoodsInfo, Cell) ->
    GoodDict = GoodsStatus#goods_status.dict,
    Location = ?GOODS_LOC_DRAGON_EQUIP,
    %% 舊格子上的裝備數據
    OldGoodsInfo = lib_goods_util:get_goods_by_cell(PlayerId, Location, Cell, GoodDict),
    {NewOldGoodsInfo, NewGoodsInfo, NewGoodsStatus} = case is_record(OldGoodsInfo, goods) of
        %% 存在已裝備的物品，則替換
        true -> 
            % 直接移到背包,背包不區分Cell，默認0
            OriginalLocation = ?GOODS_LOC_DRAGON, OriginalCell = 0,
            [OldGoodsInfo2, GoodsStatus1] = lib_goods:change_goods_cell(OldGoodsInfo, OriginalLocation, OriginalCell, GoodsStatus),
            [GoodsInfo2, GoodsStatus2] = lib_goods:change_goods_cell(GoodsInfo, Location, Cell, GoodsStatus1),  
            {OldGoodsInfo2, GoodsInfo2, GoodsStatus2};
        %% 不存在
        false -> 
            [GoodsInfo2, GoodsStatus1] = lib_goods:change_goods_cell(GoodsInfo, Location, Cell, GoodsStatus),
            {OldGoodsInfo, GoodsInfo2, GoodsStatus1}
    end,
    #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    lib_goods_api:notify_client(PlayerId, GoodsL),
    %% 此處通知客戶端將材料裝備從背包位置中移除
    lib_goods_api:notify_client_num(PlayerId, [GoodsInfo#goods{num=0}]),
    %% 更新物品Status
    LastGoodsStatus = NewGoodsStatus#goods_status{dict = GoodsDict},
    {ok, LastGoodsStatus, NewOldGoodsInfo, OldGoodsInfo, NewGoodsInfo}.

%% 是否正確的裝備職位
is_right_equip_career(Player, GoodsInfo) ->
    #player_status{figure = #figure{career = Career}} = Player,
    #goods{goods_id = GoodsTypeId} = GoodsInfo,
    case data_goods_type:get(GoodsTypeId) of
        [] -> false;
        #ets_goods_type{career = GoodsCareer} ->
            GoodsCareer == 0 orelse GoodsCareer == Career
    end.

%% 是否滿足槽位許可權
is_pos_permiss(#goods{subtype = Subtype} = _GoodsInfo, CellPos) ->
    case data_dragon:get_dragon_pos(CellPos) of
        [] -> false;
        #base_dragon_pos{permiss_list = PermissList} ->
            lists:member(Subtype, PermissList)
    end.

%% 是否滿足等級
is_enough_dragon_lv(Player, CellPos) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    case lists:keymember(CellPos, #dragon_pos.pos, PosRdList) of
        true -> true;
        false ->
            case data_dragon:get_dragon_pos(CellPos) of
                [] -> false;
                #base_dragon_pos{need_lv = NeedLv} ->
                    Lv = get_dragon_lv(Player),
                    Lv >= NeedLv
            end
    end.

%% 是否唯一的Kind
is_unique_kind(Player, GoodsStatus, GoodsInfo, CellPos) -> 
    #player_status{id = PlayerId} = Player,
    #goods_status{dict = Dict} = GoodsStatus,
    #goods{goods_id = GoodsTypeId, level = Level, location = Location} = GoodsInfo,
    case Location == ?GOODS_LOC_DRAGON_EQUIP of
        true -> true;
        false ->
            % case data_dragon:get_dragon_lv(GoodsTypeId, Lv) of
            %     [] -> Kind = false;
            %     #base_dragon_lv{kind = Kind} -> ok
            % end,
            case data_dragon:get_star_and_lv(Level) of
                {Lv, _} ->
                    case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                        [] -> Kind = false;
                        #base_dragon_lv_up{kind = Kind} -> skip
                    end;
                _ ->
                    Kind = false
            end,
            EquipList = lib_goods_util:get_equip_list(
                PlayerId, ?GOODS_TYPE_DRAGON_EQUIP, ?GOODS_LOC_DRAGON_EQUIP, Dict),
            case lists:keyfind(CellPos, #goods.cell, EquipList) of
                #goods{goods_id = RawGoodsTypeId, level = RawLevel} ->
                    % case data_dragon:get_dragon_lv(RawGoodsTypeId, RawLv) of
                    %     [] -> RawKind = false;
                    %     #base_dragon_lv{kind = RawKind} -> ok
                    % end;
                    case data_dragon:get_star_and_lv(RawLevel) of
                        {RawLv, _} ->
                            case data_dragon:get_lv_up_cfg(RawGoodsTypeId, RawLv) of
                                [] -> RawKind = false;
                                #base_dragon_lv_up{kind = RawKind} -> skip
                            end;
                        _ ->
                            RawKind = false
                    end;
                _ ->
                    RawKind = false
            end,
            if
                % 沒有配置
                Kind == false -> false;
                % 鑲嵌的位置就是同一種類
                RawKind == Kind -> true;
                true ->
                    F = fun(#goods{goods_id = TmpGoodsTypeId, level = TmpLevel}) ->
                        % case data_dragon:get_dragon_lv(TmpGoodsTypeId, TmpLv) of
                        %     [] -> true;
                        %     #base_dragon_lv{kind = TmpKind} -> Kind =/= TmpKind
                        % end
                        case data_dragon:get_star_and_lv(TmpLevel) of
                            {TemLv, _} ->
                                case data_dragon:get_lv_up_cfg(TmpGoodsTypeId, TemLv) of
                                    [] -> true;
                                    #base_dragon_lv_up{kind = TmpKind} -> Kind =/= TmpKind
                                end;
                            _ ->
                                true
                        end
                    end,
                    % ?INFO("EquipList:~p R:~p ~n", [EquipList, lists:all(F, EquipList)]),
                    % 類型不一樣
                    lists:all(F, EquipList)
            end
    end. 

%% 獲得龍紋等級[總等級]
get_dragon_lv(Player) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    get_dragon_lv(Player, GoodsStatus).

get_dragon_lv(#player_status{id = PlayerId} = _Player, GoodsStatus) ->
    #goods_status{dict = Dict} = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(
        PlayerId, ?GOODS_TYPE_DRAGON_EQUIP, ?GOODS_LOC_DRAGON_EQUIP, Dict),
    F = fun(#goods{goods_id = _GoodsTypeId, level = Level}) ->
        % case data_dragon:get_dragon_lv(GoodsTypeId, Level) of
        %     [] -> 0;
        %     #base_dragon_lv{show_lv = ShowLv} -> ShowLv
        % end
        case data_dragon:get_star_and_lv(Level) of
            {ShowLv, _} -> ShowLv;
            _ -> 0
        end
    end,
    lists:sum([F(T)||T<-EquipList]).
    
%% 卸下龍紋裝備
unequip(Player, GoodsId) ->
    case check_unequip(Player, GoodsId) of
        {false, ErrorCode} -> {false, ErrorCode, Player};
        {true, GoodsInfo} -> do_unequip(Player, GoodsInfo)
    end.

check_unequip(_Player, GoodsId) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    CheckList = [
        % 是否record
        {fun() -> is_record(GoodsInfo, goods) end, ?ERRCODE(err181_not_goods_exist)},
        % 是否龍紋裝備
        {fun() -> is_dragon_equip(GoodsInfo) end, ?ERRCODE(err181_not_dragon_equip)},
        % 是否在裝備位置上
        {fun() -> GoodsInfo#goods.location == ?GOODS_LOC_DRAGON_EQUIP end, ?ERRCODE(err181_not_on_equip)}
    ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true -> {true, GoodsInfo}
    end.

do_unequip(Player, GoodsInfo) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_unequip_core(Player#player_status.id, GoodsStatus, GoodsInfo)
    end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, NewGoodsInfo, Cell} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            NewPlayer2 = lib_dragon:calc_dragon_and_notify(Player),
            lib_rush_rank_api:reflash_rank_by_dragon_rush(NewPlayer2),
            LastPS = lib_demons_api:dragon_up_lv(NewPlayer2),
            log_dragon_equip(NewPlayer2, NewGoodsInfo, GoodsInfo, 2),
            {true, ?SUCCESS, LastPS, Cell};
        Error ->
            ?ERR("equip error:~p", [Error]),
            {false, ?FAIL, Player}
    end.

do_unequip_core(PlayerId, GoodsStatus, GoodsInfo) ->
    Cell = 0, %% 英靈背包不區分Cell，默認0
    Location = ?GOODS_LOC_DRAGON,
    [NewGoodsInfo, NewStatus] = lib_goods:change_goods_cell(GoodsInfo, Location, Cell, GoodsStatus),
    #goods_status{dict = OldGoodsDict} = NewStatus,
    {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    lib_goods_api:notify_client(PlayerId, GoodsL),
    LastStatus = NewStatus#goods_status{dict = Dict},
    {ok, LastStatus, NewGoodsInfo, Cell}.

%% 龍紋分解
decompose(Player, GoodsIdL) ->
    % 限制每次50個
    UqGoodsIdL = lists:sublist(lists:usort(GoodsIdL), 50),
    F = fun(GoodsId, {DeleteL, RewardL, LogL}) -> 
        case check_decompose(GoodsId) of
            {false, _ErrorCode} -> {DeleteL, RewardL, LogL};
            {true, GoodsInfo, DecomposeList} -> 
                NewRewardL = DecomposeList++RewardL, 
                NewLogL = [{GoodsInfo, DecomposeList}|LogL],
                {[{GoodsId, GoodsInfo#goods.num}|DeleteL], NewRewardL, NewLogL}
        end
    end,
    {DeleteL, RewardL, LogL} = lists:foldl(F, {[], [], []}, UqGoodsIdL),
    case lib_goods_api:delete_more_by_list(Player, DeleteL, dragon_decompose) of
        1 ->
            UqRewardL = lib_goods_api:make_reward_unique(RewardL),
            % ?INFO("UqRewardL:~p RewardL:~p ~n", [UqRewardL, RewardL]),
            Produce = #produce{type = dragon_decompose, reward = UqRewardL, show_tips = ?SHOW_TIPS_3},
            NewPlayer = lib_goods_api:send_reward(Player, Produce),
            [log_dragon_decompose(NewPlayer, GoodsInfo, DecomposeList)||{GoodsInfo, DecomposeList}<-LogL],
            {true, NewPlayer, UqRewardL};
        ErrorCode ->
            {false, ErrorCode, Player}
    end.

check_decompose(GoodsId) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    CheckList = [
        % 是否record
        {fun() -> is_record(GoodsInfo, goods) end, ?ERRCODE(err181_not_goods_exist)},
        % 是否龍紋物品或者装备
        {fun() -> is_dragon_thing(GoodsInfo) end, ?ERRCODE(err181_not_dragon_equip)},
        % 只能在背包才能被分解
        {fun() -> GoodsInfo#goods.location == ?GOODS_LOC_DRAGON end, ?ERRCODE(err181_must_on_bag_to_decompose)},
        % 是否有分解配置
        {fun() -> is_have_decompose_cfg(GoodsInfo) end, ?ERRCODE(err181_not_decompose_cfg)}
    ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true -> 
            #goods{goods_id = GoodsTypeId, level = Level, num = Num} = GoodsInfo,
            case data_dragon:get_star_and_lv(Level) of
                {Lv, Star} ->
                    case data_dragon:get_star_up_cfg(GoodsTypeId, Star) of
                        #base_dragon_star_up{decompose = Decompose} -> skip;
                        _ -> Decompose = []
                    end,
                    case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                        #base_dragon_lv_up{lv_min = MinLv, base_decompose = BaseList, add_decompose = AddList} -> 
                            DecomposeL = calc_real_list(MinLv, Lv, BaseList, AddList),
                            DecomposeList = DecomposeL ++ Decompose;
                        _ -> DecomposeList = Decompose
                    end;
                _ ->
                    DecomposeList = []
            end,
            Fun = fun({Type, Gtypeid, Temnum}, Acc) when Temnum =/= 0 ->
                case lists:keyfind(Gtypeid, 2, Acc) of
                    {_, _, OldNum} ->lists:keystore(Gtypeid, 2, Acc, {Type, Gtypeid, Temnum*Num+OldNum});
                    _->lists:keystore(Gtypeid, 2, Acc, {Type, Gtypeid, Temnum*Num})
                end;
                (_, Acc) ->
                    Acc
            end,
            NewDList = lists:foldl(Fun, [], DecomposeList),
            % #base_dragon_lv{decompose_list = DecomposeList} = data_dragon:get_dragon_lv(GoodsTypeId, Lv),
            {true, GoodsInfo, NewDList}
    end.

is_dragon_thing(GoodsInfo) ->
    GoodsInfo#goods.type == ?GOODS_TYPE_DRAGON_EQUIP orelse GoodsInfo#goods.type == ?GOODS_TYPE_DRAGON_THING.
%% 是否有分解配置
is_have_decompose_cfg(#goods{goods_id = GoodsTypeId, level = Level, type = Gtypeid} = _GoodsInfo) when Gtypeid == ?GOODS_TYPE_DRAGON_EQUIP ->
    % case data_dragon:get_dragon_lv(GoodsTypeId, Lv) of
    %     [] -> false;
    %     #base_dragon_lv{decompose_list = []} -> false;
    %     #base_dragon_lv{} -> true
    % end.
    case data_dragon:get_star_and_lv(Level) of
        {Lv, _Star} ->
            case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                [] -> false;
                #base_dragon_lv_up{base_decompose = []} -> 
                    case data_dragon:get_star_up_cfg(GoodsTypeId, _Star) of
                        #base_dragon_star_up{decompose = Decompose} when Decompose =/= [] -> true;
                        _ -> false
                    end;
                #base_dragon_lv_up{} -> true
            end;
        _ ->
            false
    end;
is_have_decompose_cfg(#goods{goods_id = GoodsTypeId, level = Level} = _GoodsInfo) ->
    % case data_dragon:get_dragon_lv(GoodsTypeId, Lv) of
    %     [] -> false;
    %     #base_dragon_lv{decompose_list = []} -> false;
    %     #base_dragon_lv{} -> true
    % end.
    case data_dragon:get_star_and_lv(Level) of
        {Lv, _Star} ->
            case data_dragon:get_lv_up_cfg(GoodsTypeId, Lv) of
                [] -> 
                    case data_dragon:get_star_up_cfg(GoodsTypeId, _Star) of
                        #base_dragon_star_up{decompose = Decompose} when Decompose =/= [] -> true;
                        _ -> false
                    end;
                #base_dragon_lv_up{} -> true
            end;
        _ ->
            false
    end.

%% 培養日誌
log_dragon_lv(Player, NewGoodsInfo, OldGoodsInfo) ->
    #player_status{id = RoleId} = Player,
    #goods{id = GoodsId, goods_id = GoodsTypeId, level = NewLevel} = NewGoodsInfo,
    #goods{level = OldLevel} = OldGoodsInfo,
    {NewShowLv, NewQuality} = data_dragon:get_star_and_lv(NewLevel),
    {OldShowLv, OldQuality} = data_dragon:get_star_and_lv(OldLevel),
    if
        NewShowLv == OldShowLv ->
            #base_dragon_star_up{cost = Cost} = data_dragon:get_star_up_cfg(GoodsTypeId, NewQuality),
            LvType = 2;
        true ->
            #base_dragon_lv_up{lv_min = MinLv, base_cost = BaseList, add_cost = AddList} = 
                data_dragon:get_lv_up_cfg(GoodsTypeId, OldShowLv),
            Cost = calc_real_list(MinLv, OldShowLv, BaseList, AddList),
            LvType = 1
    end,
    % #base_dragon_lv{show_lv = NewShowLv, quality = NewQuality} = data_dragon:get_dragon_lv(GoodsTypeId, NewLv),
    % #base_dragon_lv{show_lv = OldShowLv, quality = OldQuality, lv_type = LvType, cost = Cost} = data_dragon:get_dragon_lv(GoodsTypeId, NewLv),
    lib_log_api:log_dragon_lv(RoleId, GoodsId, GoodsTypeId, LvType, Cost, OldLevel, NewLevel, OldShowLv, NewShowLv, OldQuality, NewQuality),
    ok.

%% 1:鑲嵌 2:脫下
log_dragon_equip(Player, NewGoodsInfo, OldGoodsInfo, Type) when is_record(NewGoodsInfo, goods) ->
    #player_status{id = RoleId} = Player,
    #goods{id = GoodsId, goods_id = GoodsTypeId, cell = NewPos} = NewGoodsInfo,
    #goods{cell = OldPos} = OldGoodsInfo,
    lib_log_api:log_dragon_equip(RoleId, GoodsId, GoodsTypeId, OldPos, NewPos, Type),
    ok;
log_dragon_equip(_Player, _NewGoodsInfo, _OldGoodsInfo, _Type) ->    
    ok.

%% 熔爐分解日誌
log_dragon_decompose(Player, GoodsInfo, DecomposeList) ->
    #player_status{id = RoleId} = Player,
    #goods{id = GoodsId, goods_id = GoodsTypeId, level = Level} = GoodsInfo,
    {ShowLv, Quality} = data_dragon:get_star_and_lv(Level),
    % #base_dragon_lv{show_lv = ShowLv, quality = Quality} = data_dragon:get_dragon_lv(GoodsTypeId, Lv),
    lib_log_api:log_dragon_decompose(RoleId, GoodsId, GoodsTypeId, Level, ShowLv, Quality, DecomposeList),
    ok.