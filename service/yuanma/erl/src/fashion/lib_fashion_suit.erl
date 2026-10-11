%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%             时装套装
%%% @end
%%% Created : 29. 8月 2022 17:28
%%%-------------------------------------------------------------------
-module(lib_fashion_suit).

-include("fashion.hrl").
-include("server.hrl").
-include("rec_offline.hrl").
-include("mount.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("attr.hrl").


%% API
-export([
    login_fashion_suit/1
    , active_suit/3
    , update_conform_num/4
    , upgrade_suit/2
    , get_fashion_suit_attr/1
    , init_conform_num_and_attr/1
    , send_suit_info/1
    , event_update_attr/1
]).

%% 登陆时时装套装初始化
login_fashion_suit(RoleId) ->
    ReSql = io_lib:format(?SelectFashionSuitSql, [RoleId]),
    Ids = data_fashion:get_all_suit_id(),
    case db:get_all(ReSql) of
        [] ->
            SuitDataList = [#fashion_suit_data{id = Id} || Id <- Ids];
        DataSqlList ->
            DataSqlList1 = [list_to_tuple(Info)||Info <- DataSqlList],
            F = fun(Id, Acc) ->
                case lists:keyfind(Id, 1, DataSqlList1) of
                    {Id, Lv, ActiveNum} ->
                        [#fashion_suit_data{id = Id, lv = Lv, active_num = ActiveNum} | Acc];
                    _ ->
                        [#fashion_suit_data{id = Id} | Acc]
                end end,
            SuitDataList = lists:foldl(F, [], Ids)
    end,
    FashionSuit = #fashion_suit{suit_data = SuitDataList},
    FashionSuit.

%% 时装套装位置可激活数量初始化
init_conform_num_and_attr(Ps = #player_status{pid = Pid}) when is_pid(Pid)->
    GS = lib_goods_do:get_goods_status(),
    NewGS = get_init_GS(Ps, GS),
    lib_goods_do:set_goods_status(NewGS);
init_conform_num_and_attr(Ps = #player_status{pid = undefined, off = OFF})->
    #status_off{goods_status = GoodsStaqtus} = OFF,
    NewGS = get_init_GS(Ps, GoodsStaqtus),
    NewPs = Ps#player_status{off = OFF#status_off{goods_status = NewGS}},
    NewPs.

get_init_GS(Ps, GS) ->
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList, suit_list = SuitList} = Fashion,
    #fashion_suit{suit_data = SuitDataList} = SuitList,
    F = fun(Data, Acc) ->
        #fashion_suit_data{id = Id} = Data,
        ConformNum = count_conform_num(Ps, GS, Id),
        [Data#fashion_suit_data{conform_num = ConformNum} | Acc]
        end,
    NewSuitDataList = lists:foldl(F, [], SuitDataList),
    NewSuitList = SuitList#fashion_suit{suit_data = NewSuitDataList},
    FinalFashionSuit = count_attr_skill(Ps, PositionList, NewSuitList),
    NewFashion = Fashion#fashion{suit_list = FinalFashionSuit},
    NewGS = GS#goods_status{fashion = NewFashion},
    NewGS.

%% 发送时装套装信息
send_suit_info(Ps) ->
    #player_status{sid = Sid, original_attr = OriginAttr, status_mount = StatusMount} = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList, suit_list = SuitList} = Fashion,
    #fashion_suit{suit_data = SuitDataList} = SuitList,
    F = fun(#fashion_suit_data{id = Id, active_num = ActiveNum, conform_num = ConformNum, lv = Lv} = Data, Acc) ->
        {Attr, Skill} = count_attr_skill_2(Data, PositionList, StatusMount),
        Power = get_power(Ps, OriginAttr, Attr, Skill, partial),
        NextPower = get_next_lv_power(Ps, OriginAttr, Data, PositionList, StatusMount),
        [{Id, Lv, ActiveNum, ConformNum, Power, NextPower} | Acc]
        end,
    SendList = lists:foldl(F, [], SuitDataList),
    {ok, Bin} = pt_413:write(41313, [SendList]),
    lib_server_send:send_to_sid(Sid, Bin),
    ok.

%% 获取下一等级战力
get_next_lv_power(Ps, OriginAttr, Data, PositionList, StatusMount) ->
    #fashion_suit_data{id = Id, active_num = ActiveNum, lv = Lv} = Data,
    #base_fashion_suit{attr = Attr, condition = Condition} = data_fashion:get_fashion_suit(Id),
    case data_fashion:get_suit_star(Id, Lv + 1) of
        Cfg when is_record(Cfg, base_fashion_suit_star) ->
            MaxActiveNum = length(Condition),
            NewData =
                case ActiveNum =/= MaxActiveNum of
                    true ->
                        Data#fashion_suit_data{active_num = MaxActiveNum};
                    _ ->
                        Data#fashion_suit_data{lv = Lv + 1}
                end,
            {Attr2, Skill} = count_attr_skill_2(NewData, PositionList, StatusMount),
            NextPower = get_power(Ps, OriginAttr, Attr2, Skill, expact),
            NextPower;
        _ ->
            0
    end.

get_power(Ps, OriginAttr, Attr, Skill, Type) ->
    SkillPow = lib_skill_api:get_skill_power(Skill),
        case Type == expact of
        true -> lib_player:calc_expact_power(Ps, OriginAttr, SkillPow, Attr);
        _ -> lib_player:calc_partial_power(Ps, OriginAttr, SkillPow, Attr)
        end.

%% 获取属性
get_fashion_suit_attr(#player_status{pid = Pid}) when is_pid(Pid)->
    case lib_goods_do:get_goods_status() of
        #goods_status{fashion = Fashion} ->
            #fashion{suit_list = #fashion_suit{attr = Attr}} = Fashion;
        _ -> Attr = []
    end,
    Attr;
get_fashion_suit_attr(#player_status{pid = undefined, off = #status_off{goods_status = GoodsStaqtus}})->
    #goods_status{fashion = #fashion{suit_list = #fashion_suit{attr = Attr}}} = GoodsStaqtus,
    Attr;
get_fashion_suit_attr(_) ->
    [].


%% 激活套装
active_suit(Ps, SuitId, ActiveNum) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList, suit_list = SuitList} = Fashion,
    #fashion_suit{suit_data = SuitDataList} = SuitList,
    case lists:keyfind(SuitId,  #fashion_suit_data.id, SuitDataList) of
        SuitData = #fashion_suit_data{conform_num = ConformNum} when ConformNum >= ActiveNum ->
            #base_fashion_suit{attr = AttrList, condition = Condition, skill = Skill} = data_fashion:get_fashion_suit(SuitId),
            case lists:keyfind(ActiveNum, 1, AttrList) of
                {ActiveNum, _Attr} ->
                    {Lv, NewSkill} = ?IF(ActiveNum =:= length(Condition), {1, Skill}, {0, []}),
                    NewSuitData = SuitData#fashion_suit_data{active_num = ActiveNum, lv = Lv},
                    save_fashion_suit(Ps#player_status.id, NewSuitData),
                    NewSuitDataList = lists:keystore(SuitId, #fashion_suit_data.id, SuitDataList, NewSuitData),
                    NewSuitList = SuitList#fashion_suit{suit_data = NewSuitDataList},
                    NewSuitList2 = count_attr_skill(Ps, PositionList, NewSuitList),
                    NewFashion = Fashion#fashion{suit_list = NewSuitList2},
                    NewGS = GS#goods_status{fashion = NewFashion},
                    lib_goods_do:set_goods_status(NewGS),
                    NewPs = update_player_attr(Ps, NewFashion, NewSkill),
                    #player_status{status_mount = StatusMount, original_attr = OriginAttr} = NewPs,
                    {Attr, Skill2} = count_attr_skill_2(NewSuitData, PositionList, StatusMount),
                    Power = get_power(Ps, OriginAttr, Attr, Skill2, partial),
                    NextPower = get_next_lv_power(Ps, OriginAttr, NewSuitData, PositionList, StatusMount),
                    {ok, Bin} = pt_413:write(41314, [SuitId, ActiveNum, ?SUCCESS, Power, NextPower]),
                    lib_server_send:send_to_uid(Ps#player_status.id, Bin),
                    {ok, NewPs};
                _ ->  {false, ?FAIL}
            end;
        _ ->  {false, ?ERRCODE(err413_suit_not_conform)}
    end.

%% 更新可激活数量
update_conform_num(Ps, Type, SubType, Id) ->
    Ids = data_fashion:get_all_suit_id(),
    case is_conform_active(Ids, {Type, SubType, Id}) of
        #base_fashion_suit{id = SuitId} ->
            GS = lib_goods_do:get_goods_status(),
            #goods_status{fashion = Fashion} = GS,
            #fashion{suit_list = SuitList} = Fashion,
            #fashion_suit{suit_data = SuitDataList} = SuitList,
            Data= ulists:keyfind(SuitId,  #fashion_suit_data.id, SuitDataList, #fashion_suit_data{id = SuitId}),
            ConformNum = count_conform_num(Ps, GS, SuitId),
            NewData = Data#fashion_suit_data{conform_num = ConformNum},
            NewSuitDataList = lists:keystore(SuitId,  #fashion_suit_data.id, SuitDataList, NewData),
            NewSuitList = SuitList #fashion_suit{suit_data = NewSuitDataList},
            NewFashion = Fashion#fashion{suit_list = NewSuitList},
            NewGS2 = GS#goods_status{fashion = NewFashion},
            lib_goods_do:set_goods_status(NewGS2),
            send_suit_info(Ps),
            ok;
        _ -> skip
    end.

%% 计算可激活位置数量
count_conform_num(Ps, GS, SuitId) ->
    #base_fashion_suit{condition = Condition} = data_fashion:get_fashion_suit(SuitId),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,

    #player_status{status_mount = StatusMount} = Ps,
    F = fun({_, {Type, SubType, Id}}, Acc) ->
            case Type of
                ?SUIT_POST_FASHION ->
                    case lists:keyfind(SubType, #fashion_info.pos_id, PositionList) of
                        #fashion_pos{fashion_list = FashionList} ->
                            F2 = fun(#fashion_info{pos_id = PosId, fashion_id = FashionId}) ->
                                PosId == SubType andalso Id == FashionId
                                 end,
                            case lists:filter(F2, FashionList) of
                                [] -> Acc;
                                _ -> Acc + 1
                            end;
                        _ -> Acc
                    end;
                ?SUIT_POST_MOUNT ->
                    case lists:keyfind(SubType, #status_mount.type_id, StatusMount) of
                        #status_mount{figure_list = FigureList} ->
                            case lists:keyfind(Id, #mount_figure.id, FigureList) of
                                #mount_figure{id = Id} -> Acc + 1;
                                _ -> Acc
                            end;
                        _ -> Acc
                    end;
                _ -> Acc
            end
        end,
    lists:foldl(F, 0, Condition).

%% 是否是套装里面的可激活物品
is_conform_active([], _CheckValue) -> false;
is_conform_active([Id | N], CheckValue) ->
    Cfg = #base_fashion_suit{condition = Condition} = data_fashion:get_fashion_suit(Id),
    ConformCondition = [{K, V} || {K, V} <- Condition, V =:= CheckValue],
    case ConformCondition of
        [{_Pos, CheckValue}] -> Cfg;
        _ -> is_conform_active(N, CheckValue)
    end.

%% 升阶
upgrade_suit(Ps, SuitId) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList, suit_list = SuitList} = Fashion,
    #fashion_suit{suit_data = SuitDataList} = SuitList,
    case lists:keyfind(SuitId, #fashion_suit_data.id, SuitDataList) of
        Data = #fashion_suit_data{lv = Lv} when Lv > 0 ->
            case data_fashion:get_suit_star(SuitId, Lv + 1) of
                #base_fashion_suit_star{condition = Condition, cost = Cost, skill = Skill} ->
                    case is_conform_upgrade(Ps, SuitId, Condition) of
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Ps, Cost, fashion_suit_upgrade, "") of
                                {true, NewPs} ->
                                    NewData = Data#fashion_suit_data{lv = Lv + 1},
                                    save_fashion_suit(Ps#player_status.id, NewData),
                                    NewSuitDataList = lists:keystore(SuitId,  #fashion_suit_data.id, SuitDataList, NewData),
                                    NewSuitList = SuitList #fashion_suit{suit_data = NewSuitDataList},
                                    NewSuitList2 = count_attr_skill(NewPs, PositionList, NewSuitList),
                                    NewFashion = Fashion#fashion{suit_list = NewSuitList2},
                                    NewGS2 = GS#goods_status{fashion = NewFashion},
                                    lib_goods_do:set_goods_status(NewGS2),
                                    NewPs2 = update_player_attr(Ps, NewFashion, Skill),
                                    #player_status{status_mount = StatusMount, original_attr = OriginAttr} = NewPs2,
                                    {Attr, Skill2} = count_attr_skill_2(NewData, PositionList, StatusMount),
                                    Power = get_power(Ps, OriginAttr, Attr, Skill2, partial),
                                    NextPower = get_next_lv_power(Ps, OriginAttr, NewData, PositionList, StatusMount),
                                    {ok, Bin} = pt_413:write(41315, [SuitId, Lv + 1, ?SUCCESS, Power, NextPower]),
                                    lib_server_send:send_to_uid(Ps#player_status.id, Bin),
                                    {ok, NewPs2};
                                {false, Error, _} ->
                                    {false, Error}
                            end;
                        _ ->  {false, ?ERRCODE(err413_upgrade_not_conform)}   % 不满足进阶条件
                    end;
                _ ->  {false, ?FAIL}   %缺配置或满级
            end;
        _ ->  {false, ?ERRCODE(err413_upgrade_not_conform)}   % 不满足进阶条件
    end.

%% 检查是否符合升阶条件
is_conform_upgrade(Ps, SuitId, Condition) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    #base_fashion_suit{condition = SuitCondition} = data_fashion:get_fashion_suit(SuitId),
    #player_status{status_mount = StatusMount} = Ps,
    check_upgrade(Condition, SuitCondition, PositionList, StatusMount).

check_upgrade([], _SuitCondition, _PositionList, _StatusMount) -> true;
check_upgrade([{PosId, CheckLv} | N], SuitCondition, PositionList, StatusMount) ->
    {PosId, {Type, SubType, Id}} = lists:keyfind(PosId, 1, SuitCondition),
    case Type of
        ?SUIT_POST_FASHION ->
            case lists:keyfind(SubType, #fashion_info.pos_id, PositionList) of
                #fashion_pos{fashion_list = FashionList} ->
                    case lists:keyfind(Id, #fashion_info.fashion_id, FashionList) of
                        #fashion_info{fashion_star_lv = Lv} -> ok;
                        _ -> Lv = 0
                    end;
                _ -> Lv = 0
            end;
        ?SUIT_POST_MOUNT ->
            case lists:keyfind(SubType, #status_mount.type_id, StatusMount) of
                #status_mount{figure_list = FigureList} ->
                    case lists:keyfind(Id, #mount_figure.id, FigureList) of
                        #mount_figure{stage = StageLv, star = StarLv} ->
                            case lists:member(SubType, ?STAGE_CONFIG) of
                                true -> %  坐骑伙伴特殊处理
                                    Lv = StarLv;
                                _ -> Lv = StageLv
                            end;
                        _ -> Lv = 0
                    end;
                _ -> Lv = 0
            end
    end,
    case CheckLv =< Lv of
        true ->
            check_upgrade(N, SuitCondition, PositionList, StatusMount);
        _ -> false
    end.

%% 坐骑,时装发生变化时更新套装属性
event_update_attr(Ps) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList, suit_list = SuitList} = Fashion,
    NewSuitList2 = count_attr_skill(Ps, PositionList, SuitList),
    NewFashion = Fashion#fashion{suit_list = NewSuitList2},
    NewGS2 = GS#goods_status{fashion = NewFashion},
    lib_goods_do:set_goods_status(NewGS2),
    ok.

%% 计算技能和属性
count_attr_skill(Ps, PositionList, SuitList) ->
    #fashion_suit{suit_data = SuitDataList} = SuitList,
    #player_status{status_mount = StatusMount} = Ps,
    F = fun(SuitData, {Attrs, Skills}) ->
        {Attr, Skill} = count_attr_skill_2(SuitData, PositionList, StatusMount),
        {Attr ++ Attrs, Skill ++ Skills}
        end,
    {AttrSum, SkillSum} = lists:foldl(F, {[], []}, SuitDataList),
    SuitList#fashion_suit{attr = AttrSum, skill = SkillSum}.

count_attr_skill_2(SuitData, PositionList, StatusMount) ->
    #fashion_suit_data{id = Id, lv = Lv, active_num = ActiveNum} = SuitData,
    #base_fashion_suit{condition = Condition, attr = AttrCfg, skill = SKill} = data_fashion:get_fashion_suit(Id),
    MaxActiveNum = length(Condition),
    {_, BaseAttr} = ulists:keyfind(ActiveNum, 1, AttrCfg, {ActiveNum, []}),
    case MaxActiveNum == ActiveNum of
        true -> Skills = SKill;
        _ -> Skills = []
    end,

    case data_fashion:get_suit_star(Id, Lv) of
        #base_fashion_suit_star{attr = StarAttr, skill = StarSkill} -> ok;
        _ -> StarAttr = [], StarSkill = []
    end,

    {SuitAttr, FinalSkill} = ?IF(Lv > 1, {StarAttr, StarSkill}, {BaseAttr, Skills}),
    SpecialSkillAttr = get_special_skill_attr(FinalSkill, Condition, PositionList, StatusMount),
    SumAttr = ulists:kv_list_plus_extra([SpecialSkillAttr, SuitAttr]),
    {SumAttr, FinalSkill}.

%% 对332属性进行特殊处理
get_special_skill_attr(Skill, Condition, PositionList, StatusMount) ->
    SkillAttr = lib_skill:get_passive_skill_attr(Skill),
    case lists:keyfind(?FASHION_SUIT_POSITION_RATIO, 1, SkillAttr) of
        {_, Ratio} ->
            F = fun({_, {Type, SubType, Id}}, Acc) ->
                case Type of
                    ?SUIT_POST_FASHION ->
                        #fashion_pos{fashion_list = FashionList} =  ulists:keyfind(SubType, #fashion_info.pos_id, PositionList, #fashion_pos{}),
                        #fashion_info{fashion_star_lv = Lv} =  ulists:keyfind(Id, #fashion_info.fashion_id, FashionList, #fashion_info{}),
                        TFashionColorCon = data_fashion:get_fashion_con(SubType, Id, Lv),
                        FashionColorCon = ?IF(TFashionColorCon == [], #fashion_con{}, TFashionColorCon),
                        AttrList = FashionColorCon#fashion_con.attr_list;
                    _ ->
                        #status_mount{figure_list = FigureList} =  ulists:keyfind(SubType, #status_mount.type_id, StatusMount, #status_mount{}),
                        #mount_figure{attr = AttrList} = ulists:keyfind(Id, #mount_figure.id, FigureList, #mount_figure{})
                end,
                AttrList ++ Acc
                end,
            Attrs = lists:foldl(F, [], Condition),
            Attrs2 = [{K, erlang:round(V*Ratio/10000)}||{K, V} <- Attrs, lists:member(K, ?BASE_ATTR_LIST)],
            DelAttr = lists:keydelete(?FASHION_SUIT_POSITION_RATIO, 1, SkillAttr),
            DelAttr ++ Attrs2;
        _ ->
            SkillAttr
    end.


%% 更新玩家属性
update_player_attr(PS, _Fashion, Skill) ->
    NewPS = lib_player:count_player_attribute(PS),
    lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),
    %% 更新场景玩家属性
    mod_scene_agent:update(NewPS, [{battle_attr, NewPS#player_status.battle_attr}]),
    Skill =/= [] andalso  mod_scene_agent:update(NewPS, [{passive_skill, Skill}, {battle_attr, NewPS#player_status.battle_attr}]),
    NewPS.

save_fashion_suit(RoleId, SuitData) ->
    #fashion_suit_data{id = Id, lv = Lv, active_num = ActiveNum} = SuitData,
    ReSql = io_lib:format(?ReplaceFashionSuitSql, [RoleId, Id, Lv, ActiveNum]),
    db:execute(ReSql).

