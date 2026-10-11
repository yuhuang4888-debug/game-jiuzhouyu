%% ---------------------------------------------------------------------------
%% @doc lib_dragon.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-12-18
%% @deprecated 龍紋系統
%% ---------------------------------------------------------------------------
-module(lib_dragon).

-export([
        login/2
        , calc_dragon_and_notify/1
        , pos_unlock/1
    ]).

-export([
        up_pos_lv/2
        , down_pos_lv/2
        , reset_pos/2
    ]).

-compile(export_all).

-include("server.hrl").
-include("dragon.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("skill.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("attr.hrl").

make_record(dragon_pos, [Pos, Lv]) ->
    #dragon_pos{pos = Pos, lv = Lv}.

%% 登入
login(Player, GoodsStatus) ->
    DbList = db_role_dragon_pos_select(Player#player_status.id),
    F = fun(T) -> make_record(dragon_pos, T) end,
    PosList = [F(T)||T<-DbList],
    StatusDragon = #status_dragon{pos_list = PosList},
    NewPlayer = Player#player_status{dragon = StatusDragon},
    NewPlayer2 = pos_unlock(NewPlayer, GoodsStatus),
    calc_dragon_old(NewPlayer2, GoodsStatus).
    

%% 計算龍紋系統並且廣播屬性
calc_dragon_and_notify(Player) ->
    NewPlayer = calc_dragon(Player),
    %%注意：装备加成属性在物品加载的时候会计算一次，龙纹模块不再对装备加成属性再做处理
    %% 玩家战力计算也不会处理装备加成属性，所以每次改变需要重新计算装备加成属性
    
    %% 计算装备加成属性
    {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPlayer),
    %% 计算玩家总属性及战力
    NewPlayer2 = lib_player:count_player_attribute(LastPS),
    lib_player:send_attribute_change_notify(NewPlayer2, ?NOTIFY_ATTR),
    % SkillL = lib_skill:get_sum_skill(NewPlayer2),
    % mod_scene_agent:update(NewPlayer2, [{skill_list, SkillL}]), 
    SkillList = NewPlayer2#player_status.dragon#status_dragon.skill_list,
    mod_scene_agent:update(Player, [{passive_skill, SkillList}]),
    % NewPlayer2.
    calc_dragon_real_power(NewPlayer2, [], lib_goods_do:get_goods_status()).

%% 計算龍紋系統(所有):裝備操作使用
calc_dragon(Player) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    calc_dragon(Player, GoodsStatus).

calc_dragon_old(#player_status{dragon = StatusDragon} = Player, GoodsStatus) ->
    % 裝備屬性
    {EquipAttr, EquipSpecialAttrList} = lib_dragon_equip:calc_equip_attr(Player, GoodsStatus),
    OldEquipSpecialAttrList = StatusDragon#status_dragon.attr_special_list,
    % 技能列表
    SkillList = lib_dragon_equip:get_equip_skill_list(Player, GoodsStatus),
    NewStatusDragon = StatusDragon#status_dragon{attr_special_list = EquipSpecialAttrList, equip_attr = EquipAttr, skill_list = SkillList},
    NewPlayer = Player#player_status{dragon = NewStatusDragon},
    NewPlayer1 = calc_mod_dragon(NewPlayer),
    calc_dragon_real_power(NewPlayer1, OldEquipSpecialAttrList, GoodsStatus).

calc_dragon(#player_status{dragon = StatusDragon} = Player, GoodsStatus) ->
    % 裝備屬性
    {EquipAttr, EquipSpecialAttrList} = lib_dragon_equip:calc_equip_attr(Player, GoodsStatus),
    % OldEquipSpecialAttrList = StatusDragon#status_dragon.attr_special_list,
    % 技能列表
    SkillList = lib_dragon_equip:get_equip_skill_list(Player, GoodsStatus),
    NewStatusDragon = StatusDragon#status_dragon{attr_special_list = EquipSpecialAttrList, equip_attr = EquipAttr, skill_list = SkillList},
    NewPlayer = Player#player_status{dragon = NewStatusDragon},
    NewPlayer1 = calc_mod_dragon(NewPlayer),
    NewPlayer1.
    % NewPlayer2 = lib_player:count_player_attribute(NewPlayer1),
    % calc_dragon_real_power(NewPlayer2, OldEquipSpecialAttrList, GoodsStatus).

%% 計算龍紋系統並且廣播屬性(不重新計算裝備的)
calc_mod_dragon_and_notify(Player) ->
    NewPlayer = calc_mod_dragon(Player),
    NewPlayer2 = lib_player:count_player_attribute(NewPlayer),
    lib_player:send_attribute_change_notify(NewPlayer2, ?NOTIFY_ATTR),
    NewPlayer2.

%% 計算龍紋系統屬性(不重新計算裝備的)
calc_mod_dragon(Player) -> 
    #player_status{dragon = StatusDragon, original_attr = _SumOAttr} = Player,
    % 裝備屬性
    #status_dragon{equip_attr = EquipAttr, skill_list = SkillList} = StatusDragon,
    % 技能屬性
    SkillAttr = lib_skill:get_passive_skill_attr(SkillList),
    SkPower = calc_sk_power(SkillList, 0),
    % 共鳴屬性
    {EchoAttr, AddList} = calc_echo_attr(Player),
    EchoCombatPower = lib_player:calc_all_power(EchoAttr),
    % 基礎面板的屬性和戰力
    BaseAttr = lib_player_attr:add_attr(record, [EquipAttr, SkillAttr]),

    NewBaseAttr = calc_on_add_list(AddList, BaseAttr),
    BaseCombatPower = lib_player:calc_all_power(NewBaseAttr),
    % 計算總屬性
    TotalAttr = lib_player_attr:add_attr(record, [NewBaseAttr, EchoAttr]),
    CombatPower = lib_player:calc_all_power(TotalAttr),
    NewStatusDragon = StatusDragon#status_dragon{
        sk_power = SkPower, base_attr = NewBaseAttr, base_combat_power = BaseCombatPower,
        echo_attr = EchoAttr, echo_combat_power = EchoCombatPower,
        attr = TotalAttr, combat_power = CombatPower},
    Player#player_status{dragon = NewStatusDragon}.

calc_one_equip_add_power(GoodsTypeId, Level, Player, GoodsStatus) ->
    #player_status{dragon = StatusDragon, original_attr = SumOAttr, figure = #figure{career = Career}} = Player,
    {EquipAttr, EquipSpecialAttrListOne, SkillList} = lib_dragon_equip:calc_one_equip_attr(GoodsTypeId, Level, Career),
    #status_dragon{attr = TotalAttr, attr_special_list = EquipSpecialAttrList} = StatusDragon,
    % 技能屬性+
    SkillAttr = lib_skill:get_passive_skill_attr(SkillList),
    SkPowerOne = calc_sk_power(SkillList, 0),
    TotalAttrOne = lib_player_attr:add_attr(record, [EquipAttr, SkillAttr]),
    TotalAttrListOne = lib_player_attr:to_kv_list(TotalAttrOne),
    if
        EquipSpecialAttrListOne == [] ->
            {TotalAddAttrL, _TotalAddPower} = calc_expact_equip_attribute(Player, [], EquipSpecialAttrList, GoodsStatus),
            BeginSumOattr = lib_player_attr:minus_attr(record, [SumOAttr, lib_player_attr:to_kv_list(TotalAttr)++TotalAddAttrL]),
            Power = lib_player:calc_expact_power(BeginSumOattr, SkPowerOne, TotalAttrListOne);
        true ->
            AddEquipSpecialAttrList = ulists:kv_list_minus_extra([EquipSpecialAttrList, EquipSpecialAttrListOne]),
            {AddAttrL, AddPower} = calc_expact_equip_attribute(Player, AddEquipSpecialAttrList, EquipSpecialAttrList, GoodsStatus),
            Power = lib_player:calc_partial_power(SumOAttr, SkPowerOne+AddPower, TotalAttrListOne ++ AddAttrL)
    end,
    Power.

calc_dragon_real_power(Player, OldEquipSpecialAttrList, GoodsStatus) ->
    #player_status{dragon = StatusDragon, original_attr = SumOAttr} = Player,
    if
        SumOAttr == undefined ->
            Player;
        true ->
            #status_dragon{attr = TotalAttr, attr_special_list = EquipSpecialAttrList, sk_power = SkPower} = StatusDragon,
            TotalAttrList = lib_player_attr:to_kv_list(TotalAttr),
            {AddAttrL, AddPower} = calc_expact_equip_attribute(Player, OldEquipSpecialAttrList, EquipSpecialAttrList, GoodsStatus),
            Power = lib_player:calc_partial_power(SumOAttr, SkPower+AddPower, AddAttrL++TotalAttrList),
            % ?MYLOG("xlh_dragon","Power:~p~n,SumOAttr:~p~n, ParitalAttr:~p, SkPower+AddPower:~p~n",[Power,lib_player:calc_all_power(lib_player:calc_attr_ratio(SumOAttr)), lib_player:calc_all_power(lib_player:calc_attr_ratio(lib_player_attr:minus_attr(record, [SumOAttr, AddAttrL++TotalAttrList]))), {SkPower,AddPower}]),
            %?PRINT("Power:~p,CombatPower:~p~n",[Power,CombatPower]),
            Player#player_status{dragon = StatusDragon#status_dragon{real_combat_power = Power}}
    end.

loo_over_calc_dragon_real_power(Player, OldEquipSpecialAttrList, GoodsStatus) ->
    #player_status{dragon = StatusDragon, original_attr = SumOAttr} = Player,
    if
        SumOAttr == undefined ->
            Player;
        true ->
            #status_dragon{attr = TotalAttr, attr_special_list = EquipSpecialAttrList, sk_power = SkPower} = StatusDragon,
            TotalAttrList = lib_player_attr:to_kv_list(TotalAttr),
            {AddAttrL, AddPower} = calc_expact_equip_attribute(Player, OldEquipSpecialAttrList, EquipSpecialAttrList, GoodsStatus),
            lib_player:calc_partial_power(SumOAttr, SkPower+AddPower, AddAttrL++TotalAttrList)
    end.

calc_expact_equip_attribute(_, [], [], _) -> {[], 0};
calc_expact_equip_attribute(Player, EquipSpecialAttrList, EquipSpecialAttrList, GoodsStatus) ->
    calc_expact_equip_attribute(Player, [], EquipSpecialAttrList, GoodsStatus);
calc_expact_equip_attribute(Player, EquipSpecialAttrList, NewEquipSpecialAttrList, GoodsStatus) ->
    #player_status{id = RoleId, figure = Figure, goods = StatusGoods, skill = SkillStatus} = Player,
    #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
    {_, GoodsStatus1} = lib_goods_util:update_ex_equip_attr(StatusGoods, GoodsStatus),
    {TotalAttr, EquipSkillPower, _} = lib_goods_util:count_equip_attribute(RoleId, Figure#figure.lv, SkillTalentList, EquipSpecialAttrList, GoodsStatus1),
    {NewTotalAttr, NewEquipSkillPower, _} = lib_goods_util:count_equip_attribute(RoleId, Figure#figure.lv, SkillTalentList, NewEquipSpecialAttrList, GoodsStatus1),
    AddAttrL = lib_player_attr:minus_attr(list, [NewTotalAttr, TotalAttr]),
    {AddAttrL, NewEquipSkillPower - EquipSkillPower}.

get_total_attr(Player) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{attr = TotalAttr} = StatusDragon,
    TotalAttr.

%% 計算共鳴屬性
calc_echo_attr(Player) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    F = fun(#dragon_pos{pos = Pos, lv = Lv}, List) ->
        case data_dragon:get_dragon_pos(Pos) of
            [] -> List;
            #base_dragon_pos{subtype = Subtype} ->
                Key = {Subtype, Lv},
                case lists:keyfind(Key, 1, List) of
                    false -> [{Key, 1}|List];
                    {_, Num} -> lists:keystore(Key, 1, List, {Key, Num+1})
                end
        end
    end,
    List = lists:foldl(F, [], PosRdList),
    F2 = fun({{Subtype, Lv}, Num}, {SumAttrList, SumAddList}) ->
        NumList = data_dragon:get_dragon_echo_num(Subtype, Lv),
        F3 = fun(TmpNum, {SumAttrList2, SumAddList2}) ->
            #base_dragon_echo{attr_list = AttrList, add_list = AddList} = data_dragon:get_dragon_echo(Subtype, Lv, TmpNum),
            {[AttrList|SumAttrList2], AddList++SumAddList2}
        end,
        FilterNumList = [TmpNum||TmpNum<-NumList, TmpNum=<Num],
        lists:foldl(F3, {SumAttrList, SumAddList}, FilterNumList)
    end,
    {SumAttrList, SumAddList} = lists:foldl(F2, {[], []}, List),
    EchoAttr = lib_player_attr:add_attr(record, SumAttrList),
    F4 = fun({Type, Num}, TmpSumAddList) -> util:additive_tuplelist_elem(TmpSumAddList, 1, 2, Type, Num) end,
    NewSumAddList = lists:foldl(F4, [], SumAddList),
    {EchoAttr, NewSumAddList}.

calc_sk_power([], SumPower) -> SumPower;
calc_sk_power([{Id, Lv}|T], SumPower) ->
    case data_skill:get(Id, Lv) of
        #skill{type = _Type, lv_data = #skill_lv{power = Power}} ->
            calc_sk_power(T, SumPower+Power);
        _ ->
            calc_sk_power(T, SumPower)
    end.

calc_on_add_list(AddList, Attr) -> 
    MaxIndex = size(#attr{}),
    F = fun({Index, Ratio}, TmpAttr) -> 
        case Index < MaxIndex of
            true -> 
                Value = element(Index+1, TmpAttr),
                setelement(Index+1, TmpAttr, round(Value+Value*Ratio/100));
            false -> 
                TmpAttr 
        end
    end,
    lists:foldl(F, Attr, AddList).

% calc_on_add_list([{1, Num}|T], #attr{hp=Hp}=Attr) -> calc_on_add_list(T, Attr#attr{hp=round(Hp*Num/100)});
% calc_on_add_list([{2, Num}|T], #attr{att=Att}=Attr) -> calc_on_add_list(T, Attr#attr{att=round(Att*Num/100)});
% calc_on_add_list([{3, Num}|T], #attr{def=Def}=Attr) -> calc_on_add_list(T, Attr#attr{def=round(Def*Num/100)});
% calc_on_add_list([_|T], Attr) -> calc_on_add_list(T, Attr).

%% 槽位解鎖處理##登入,鑲嵌進行判斷,寫入資料庫.觸發一次解鎖之後都會解鎖
pos_unlock(Player) -> 
    GoodsStatus = lib_goods_do:get_goods_status(),
    pos_unlock(Player, GoodsStatus).

pos_unlock(Player, GoodsStatus) ->
    DragonLv = lib_dragon_equip:get_dragon_lv(Player, GoodsStatus),
    PosList = data_dragon:get_dragon_pos_list(),
    F = fun(Pos, TmpPlayer) -> pos_unlock(TmpPlayer, DragonLv, Pos) end,
    lists:foldl(F, Player, PosList).

pos_unlock(Player, DragonLv, Pos) ->
    #player_status{id = RoleId, dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    case lists:keymember(Pos, #dragon_pos.pos, PosRdList) of
        true -> Player;
        false ->
            case data_dragon:get_dragon_pos(Pos) of
                #base_dragon_pos{need_lv = NeedLv} when DragonLv >= NeedLv ->
                    InitLv = 1,
                    PosRd = make_record(dragon_pos, [Pos, InitLv]),
                    db_role_dragon_pos_replace(RoleId, PosRd),
                    {ok, SuperVipPlayer} = lib_supreme_vip_api:dragon_pos_unlock(Player),
                    lib_log_api:log_dragon_pos_lv(RoleId, Pos, InitLv, InitLv, 1),
                    NewPosRdList = lists:keystore(Pos, #dragon_pos.pos, PosRdList, PosRd),
                    NewStatusDragon = StatusDragon#status_dragon{pos_list = NewPosRdList},
                    SuperVipPlayer#player_status{dragon = NewStatusDragon};
                _ ->
                    Player
            end
    end.

%% 龍紋槽位升級
up_pos_lv(Player, Pos) -> 
    case check_up_pos_lv(Player, Pos) of
        {false, ErrorCode} -> {false, ErrorCode, Player};
        {true, PosRd, Cost} ->
            #dragon_pos{lv = PosLv} = PosRd,
            About = lists:concat(["Pos:", Pos, "PosLv:", PosLv]),
            case lib_goods_api:cost_object_list(Player, Cost, dragon_up_pos_lv, About) of
                {false, ErrorCode, NewPlayer} -> {false, ErrorCode, NewPlayer};
                {true, NewPlayer} -> do_up_pos_lv(NewPlayer, PosRd)
            end
    end.

%% 檢查龍紋槽位升級
check_up_pos_lv(Player, Pos) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    PosRd = lists:keyfind(Pos, #dragon_pos.pos, PosRdList),
    Subtype = get_subtype_by_pos(Pos),
    CheckList = [
        % 槽位是否激活
        {fun() -> is_record(PosRd, dragon_pos) end, ?ERRCODE(err181_pos_not_active)},
        {fun() -> is_integer(Subtype) end, ?ERRCODE(err181_not_dragon_pos_cfg)},
        % 是否有升級的配置
        {
            fun() -> 
                Cfg = data_dragon:get_dragon_pos_lv(Pos, PosRd#dragon_pos.lv+1), 
                is_record(Cfg, base_dragon_pos_lv)
            end, ?ERRCODE(err181_max_dragon_pos_lv)},
        % 是否滿足升級消耗
        fun() ->
            case data_dragon:get_dragon_pos_lv(Pos, PosRd#dragon_pos.lv) of
                [] -> {false, ?ERRCODE(err181_not_dragon_pos_lv_cfg)};
                #base_dragon_pos_lv{cost = []} -> {false, ?ERRCODE(err181_not_dragon_pos_lv_cfg)};
                #base_dragon_pos_lv{cost = Cost} -> lib_goods_api:check_object_list(Player, Cost)
            end
        end
    ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true -> 
            #base_dragon_pos_lv{cost = Cost} = data_dragon:get_dragon_pos_lv(Pos, PosRd#dragon_pos.lv),
            {true, PosRd, Cost}
    end.

do_up_pos_lv(Player, PosRd) ->
    #player_status{id = RoleId, dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    #dragon_pos{pos = Pos, lv = Lv} = PosRd,
    NewLv = Lv+1,
    NewPosRd = PosRd#dragon_pos{lv = NewLv},
    db_role_dragon_pos_replace(RoleId, NewPosRd),
    lib_log_api:log_dragon_pos_lv(RoleId, Pos, Lv, NewLv, 2),
    NewPosRdList = lists:keystore(Pos, #dragon_pos.pos, PosRdList, NewPosRd),
    NewStatusDragon = StatusDragon#status_dragon{pos_list = NewPosRdList},
    NewPlayer = Player#player_status{dragon = NewStatusDragon},
    NewPlayer2 = calc_mod_dragon_and_notify(NewPlayer),
    {true, NewPlayer2, NewLv}.

%% 根據位置獲得龍紋系列
get_subtype_by_pos(Pos) ->
    case data_dragon:get_dragon_pos(Pos) of
        [] -> false;
        #base_dragon_pos{subtype = Subtype} -> Subtype
    end.

%% 龍紋槽位降級
down_pos_lv(Player, Pos) -> 
    case check_down_pos_lv(Player, Pos) of
        {false, ErrorCode} -> {false, ErrorCode, Player};
        {true, PosRd, Reward} -> do_down_pos_lv(Player, PosRd, Reward)
    end.

%% 檢查龍紋槽位降級
check_down_pos_lv(Player, Pos) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    PosRd = lists:keyfind(Pos, #dragon_pos.pos, PosRdList),
    Subtype = get_subtype_by_pos(Pos),
    CheckList = [
        % 槽位是否激活
        {fun() -> is_record(PosRd, dragon_pos) end, ?ERRCODE(err181_pos_not_active)},
        {fun() -> is_integer(Subtype) end, ?ERRCODE(err181_not_dragon_pos_cfg)},
        % 是否有降級的配置
        {
            fun() -> 
                Cfg = data_dragon:get_dragon_pos_lv(Pos, PosRd#dragon_pos.lv-1), 
                is_record(Cfg, base_dragon_pos_lv)
            end, ?ERRCODE(err181_min_dragon_pos_lv)},
        % 是否有降級的獎勵
        fun() ->
            case data_dragon:get_dragon_pos_lv(Pos, PosRd#dragon_pos.lv-1) of
                #base_dragon_pos_lv{cost = Reward} when Reward =/= [] -> true;
                _ -> {false, ?ERRCODE(err181_not_dragon_pos_lv_cfg)}
            end
        end
    ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true -> 
            #base_dragon_pos_lv{cost = Reward} = data_dragon:get_dragon_pos_lv(Pos, PosRd#dragon_pos.lv-1),
            {true, PosRd, Reward}
    end.
    
do_down_pos_lv(Player, PosRd, Reward) ->
    #player_status{id = RoleId, dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    #dragon_pos{pos = Pos, lv = Lv} = PosRd,
    NewLv = Lv-1,
    NewPosRd = PosRd#dragon_pos{lv = NewLv},
    db_role_dragon_pos_replace(RoleId, NewPosRd),
    lib_log_api:log_dragon_pos_lv(RoleId, Pos, Lv, NewLv, 3),
    NewPosRdList = lists:keystore(Pos, #dragon_pos.pos, PosRdList, NewPosRd),
    NewStatusDragon = StatusDragon#status_dragon{pos_list = NewPosRdList},
    NewPlayer = Player#player_status{dragon = NewStatusDragon},
    Remark = lists:concat(["Pos:", Pos, ",PosLv:", Lv, ",NewPosLv", NewLv]),
    Produce = #produce{type = dragon_down_pos_lv, reward = Reward, show_tips = ?SHOW_TIPS_3, remark = Remark},
    NewPlayer2 = lib_goods_api:send_reward(NewPlayer, Produce),
    NewPlayer3 = calc_mod_dragon_and_notify(NewPlayer2),
    {true, NewPlayer3, NewLv}.

%% 龍紋槽位重置
reset_pos(Player, Pos) ->
    case check_reset_pos(Player, Pos) of
        {false, ErrorCode} -> {false, ErrorCode, Player};
        {true, PosRd, Reward} -> do_reset_pos(Player, PosRd, Reward)
    end.

%% 檢查龍紋槽位重置
check_reset_pos(Player, Pos) ->
    #player_status{dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    PosRd = lists:keyfind(Pos, #dragon_pos.pos, PosRdList),
    Subtype = get_subtype_by_pos(Pos),
    CheckList = [
        % 槽位是否激活
        {fun() -> is_record(PosRd, dragon_pos) end, ?ERRCODE(err181_pos_not_active)},
        {fun() -> is_integer(Subtype) end, ?ERRCODE(err181_not_dragon_pos_cfg)},
        % 是否已經是最低等級
        {fun() -> PosRd#dragon_pos.lv > 1 end, ?ERRCODE(err181_min_dragon_pos_lv)},
        % 是否有降級的配置
        {
            fun() -> 
                Cfg = data_dragon:get_dragon_pos_lv(Pos, 1), 
                is_record(Cfg, base_dragon_pos_lv)
            end, ?ERRCODE(err181_not_dragon_pos_lv_cfg)}
    ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true -> 
            Reward = get_reset_pos_reward(PosRd, Pos),
            {true, PosRd, Reward}
    end.

%% 獲得重置的獎勵
get_reset_pos_reward(PosRd, Pos) ->
    #dragon_pos{lv = Lv} = PosRd,
    F = fun(TmpLv, List) ->
        case data_dragon:get_dragon_pos_lv(Pos, TmpLv) of
            [] -> List;
            #base_dragon_pos_lv{cost = Reward} -> Reward ++ List
        end
    end,
    Reward = lists:foldl(F, [], lists:seq(1, Lv-1)),
    lib_goods_api:make_reward_unique(Reward).
    
do_reset_pos(Player, PosRd, Reward) ->
    #player_status{id = RoleId, dragon = StatusDragon} = Player,
    #status_dragon{pos_list = PosRdList} = StatusDragon,
    #dragon_pos{pos = Pos, lv = Lv} = PosRd,
    NewLv = 1,
    NewPosRd = PosRd#dragon_pos{lv = NewLv},
    db_role_dragon_pos_replace(RoleId, NewPosRd),
    lib_log_api:log_dragon_pos_lv(RoleId, Pos, Lv, NewLv, 3),
    NewPosRdList = lists:keystore(Pos, #dragon_pos.pos, PosRdList, NewPosRd),
    NewStatusDragon = StatusDragon#status_dragon{pos_list = NewPosRdList},
    NewPlayer = Player#player_status{dragon = NewStatusDragon},
    Remark = lists:concat(["Pos:", Pos, ",PosLv:", Lv, ",NewPosLv", NewLv]),
    Produce = #produce{type = dragon_down_pos_lv, reward = Reward, show_tips = ?SHOW_TIPS_3, remark = Remark},
    NewPlayer2 = lib_goods_api:send_reward(NewPlayer, Produce),
    NewPlayer3 = calc_mod_dragon_and_notify(NewPlayer2),
    {true, NewPlayer3, NewLv}.

%% 龍紋槽位選擇
db_role_dragon_pos_select(RoleId) ->
    Sql = io_lib:format(?sql_role_dragon_pos_select, [RoleId]),
    db:get_all(Sql).

%% 龍紋槽位插入
db_role_dragon_pos_replace(RoleId, DragonPos) ->
    #dragon_pos{pos = Pos, lv = Lv} = DragonPos,
    Sql = io_lib:format(?sql_role_dragon_pos_replace, [RoleId, Pos, Lv]),
    db:execute(Sql).

%% 秘籍清除龙纹背包物品
clear_dragon_bag_equip(RoleId, GoodsTypeId, Num, SameGoodsId) ->
    case lib_player:get_alive_pid(RoleId) of
        false ->
            % ?PRINT("============ ~n",[]),
            if
                SameGoodsId == 1 -> %% 龙纹碎片
                    case db:get_all(io_lib:format(<<"select gid, num from `goods_high` where pid = ~p and 
                            goods_id = ~p and location = ~p">>, [RoleId, GoodsTypeId, 35])) of
                        [[GoodsId, GoodsNum]|_] ->
                            if
                                GoodsNum > Num ->
                                    db:execute(io_lib:format("update `goods_high` set num = ~p where gid = ~p ", [GoodsNum - Num, GoodsId]));
                                true ->
                                    lib_goods_util:delete_goods(GoodsId)
                            end;
                        _ ->
                            skip
                    end;
                true ->
                    List1 = db:get_all(io_lib:format(<<"select gid from `goods_high` where pid = ~p and
                            goods_id = ~p and location = ~p">>, [RoleId, GoodsTypeId, 35])),
                    List = lists:sublist(List1, Num),
                    Fun = fun([GoodsId]) ->
                        lib_goods_util:delete_goods(GoodsId)
                    end,
                    lists:foreach(Fun, List)
            end;
        _ ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_dragon, clear_dragon_bag_equip_helper, [GoodsTypeId, Num, SameGoodsId])
            % clear_dragon_bag_equip_helper(GoodsTypeId)
    end.

clear_dragon_bag_equip_helper(Player, GoodsTypeId, Num, SameGoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    Dict = GoodsStatus#goods_status.dict,
    case Dict =/= [] of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) ->
                Value#goods.goods_id == GoodsTypeId andalso Value#goods.location =:= 35
            end, Dict),
            DictList = dict:to_list(Dict1),
            List1 = lib_goods_dict:get_list(DictList, []),
            if
                SameGoodsId == 1 ->
                    [H|_] = List1,
                    lib_goods_do:delete_one(H#goods.id, Num);
                true -> %% 龙纹
                    List = lists:sublist(List1, Num),
                    [lib_goods_do:delete_one(GoodsInfo#goods.id, GoodsInfo#goods.num)||GoodsInfo<-List]
            end,
            ok;
        false ->
            % ?PRINT("============= Dict:~p~n",[Dict]),
            skip
    end,
    {ok, Player}.

