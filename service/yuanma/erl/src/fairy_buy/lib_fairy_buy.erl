%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%             仙灵直购系统
%%% @end
%%% Created : 12. 7月 2022 9:30
%%%-------------------------------------------------------------------
-module(lib_fairy_buy).

-include("mount.hrl").
-include("skill.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("fairy_buy.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("rec_recharge.hrl").
-include("common.hrl").
-include("def_recharge.hrl").

%% API
-export([
    login/1
    , handle_event/2
    , send_fairy_buy_info/2
    , activate_node/3
    , init_fairy_buy/2
    , get_fairy_buy_attr_and_skill/2
    , role_login/1
    , get_passive_skill/1
    , get_skill_power/1
]).

%% 登陆初始化
login(Ps) ->
    RoleId = Ps#player_status.id,
    DBFairyBuyList = db:get_all(io_lib:format(?sql_fairy_buy_select, [RoleId])),
    F = fun([FairyId, NodeList], Acc) ->
        Status = #status_fairy_buy{fairy_id = FairyId, node_list = util:bitstring_to_term(NodeList)},
        Status2 = count_fairy_buy_attribute(Status),
        [Status2 | Acc]
        end,
    FairyBuyList = lists:foldl(F, [], DBFairyBuyList),
    Ps#player_status{fairy_buy_status = FairyBuyList}.

%% 计算属性
count_fairy_buy_attribute(FairyBuyStatus) ->
    #status_fairy_buy{fairy_id = FairyId, node_list = NodeList} = FairyBuyStatus,
    F = fun(NodeId, {AttrL2, SkillL2}) ->
        case data_fairy_buy:get_fairy_buy_node(FairyId, NodeId) of
            #fairy_buy_node_cfg{attr = Attr, skill = Skill} ->
                case Skill of
                    [{SkillId, SkillLv}|_] ->
                        case lists:keyfind(SkillId, 1, SkillL2) of
                            false ->
                                NewSkill = [{SkillId, SkillLv} | SkillL2];
                            {SkillId, OldSkillLv} ->
                                MaxLv = max(OldSkillLv, SkillLv),
                                NewSkill = lists:keystore(SkillId, 1, SkillL2, {SkillId, MaxLv})
                        end;
                    _ -> NewSkill = SkillL2
                end,
                {[Attr|AttrL2], NewSkill};
            _ -> {AttrL2, SkillL2}
        end end,
    {AttrList, SkillList} = lists:foldl(F, {[], []}, NodeList),
    NAttrList = lib_player_attr:add_attr(list, AttrList),
    FairyBuyStatus#status_fairy_buy{attr = NAttrList, skill = SkillList}.

%% 充值后初始化某类仙灵直购系统
init_fairy_buy(Ps, FairyId) ->
    #player_status{fairy_buy_status = FairyBuyList, id = RoleId} = Ps,
    case lists:keyfind(FairyId, #status_fairy_buy.fairy_id, FairyBuyList) of
        false ->
            FairyBuyStatus = #status_fairy_buy{fairy_id = FairyId},
            FairyBuyStatus2 = count_fairy_buy_attribute(FairyBuyStatus),
            FairyBuyList2 = [FairyBuyStatus2 | FairyBuyList],
            db_save_fairy_buy(RoleId, FairyBuyStatus2),
            NewPs = Ps#player_status{fairy_buy_status = FairyBuyList2},
            send_fairy_buy_info(NewPs, FairyId),
            NewPs;
        _ ->
            Ps
    end.

%% 获取属性和技能
get_fairy_buy_attr_and_skill(Ps, MountType) ->
    #player_status{fairy_buy_status = FairyBuyList} = Ps,
    case data_fairy_buy:get_fairy_id_by_mount_type(MountType) of
        FairyId when is_integer(FairyId) ->
            FairyBuyStatus = ulists:keyfind(FairyId, #status_fairy_buy.fairy_id, FairyBuyList, #status_fairy_buy{fairy_id = FairyId}),
            #status_fairy_buy{attr = Attr, skill = Skill} = FairyBuyStatus,
            {Attr, Skill};
        _ -> {[], []}
    end.

%% 获取被动技能
get_passive_skill(Ps) ->
    #player_status{fairy_buy_status = FairyBuyList} = Ps,
    F = fun(#status_fairy_buy{skill = Skill}, S) ->
        Skill ++ S
        end,
    Skills = lists:foldl(F, [], FairyBuyList),
    lib_skill_api:divide_passive_skill(Skills).

%% 获取被动技能战力 分离线在线
get_skill_power(#player_status{pid = undefined, id = RoleId}) ->
    get_skill_power2(RoleId);
get_skill_power(Ps) ->
    #player_status{fairy_buy_status = FairyBuyList} = Ps,
    F = fun(#status_fairy_buy{skill = Skill}, S) ->
        Skill ++ S
        end,
    Skills = lists:foldl(F, [], FairyBuyList),
    PassiveSkill = lib_skill_api:divide_passive_skill(Skills),
    lib_skill_api:get_skill_power(PassiveSkill).
get_skill_power2(RoleId) ->
    DBFairyBuyList = db:get_all(io_lib:format(?sql_fairy_buy_select, [RoleId])),
    F = fun([FairyId, NodeList], Acc) ->
        Status = #status_fairy_buy{fairy_id = FairyId, node_list = util:bitstring_to_term(NodeList)},
        Status2 = count_fairy_buy_attribute(Status),
        [Status2#status_fairy_buy.skill | Acc]
        end,
    Skills = lists:foldl(F, [], DBFairyBuyList),
    PassiveSkill = lib_skill_api:divide_passive_skill(Skills),
    lib_skill_api:get_skill_power(PassiveSkill).


%% 将新数据存入数据库
db_save_fairy_buy(RoleId, FairyBuyStatus) ->
    #status_fairy_buy{fairy_id = FairyId, node_list = NodeIdList} = FairyBuyStatus,
    db:execute(io_lib:format(?sql_fairy_buy_replace, [RoleId, FairyId, util:term_to_bitstring(NodeIdList)])).

%% 充值事件触发
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = CallBackData}) when is_record(Player, player_status) ->
    NewPlayer =
        case CallBackData of
            #callback_recharge_data{recharge_product = #base_recharge_product{product_type = ProductType, product_id = ProductId}}
                when ProductType == ?PRODUCT_TYPE_DIRECT_GIFT ->
                case data_fairy_buy:get_fairy_id_by_recharge_id(ProductId) of
                    FairyId when is_integer(FairyId) ->
                        init_fairy_buy(Player, FairyId);
                    _ -> Player
                end;
            _ -> Player
        end,
    {ok, NewPlayer};
%% 上线給客户端发推送一次数据
handle_event(Player, #event_callback{type_id = ?EVENT_ONLINE_FLAG, data = OnlineFlag}) when is_record(Player, player_status) ->
    if
        OnlineFlag == ?ONLINE_ON ->
            FairyIdList = data_fairy_buy:get_all_fairy_id(),
            SendList =
                lists:foldl(fun(FairyId, Acc) ->
                    send_fairy_buy_info(Player, FairyId),
                    Times = mod_counter:get_count(Player#player_status.id, ?MODULE_FAIRY_BUY, FairyId),
                    [{FairyId, Times} | Acc]
                    end, [], FairyIdList),
            lib_server_send:send_to_sid(Player#player_status.sid, pt_513, 51303, [SendList]);
        true -> ok
    end,
    {ok, Player};
handle_event(PS, #event_callback{}) ->
    {ok, PS}.

%% 断线重连
role_login(Player) ->
    FairyIdList = data_fairy_buy:get_all_fairy_id(),
    lists:foreach(fun(FairyId) ->
        send_fairy_buy_info(Player, FairyId)
                  end, FairyIdList),
    ok.

%% 返回界面数据
send_fairy_buy_info(Ps, FairyId) ->
    #player_status{fairy_buy_status = FairyBuyList, sid = Sid, original_attr = OriginAttr} = Ps,
    #status_fairy_buy{node_list = NodeList, skill = Skills} = ulists:keyfind(FairyId, #status_fairy_buy.fairy_id, FairyBuyList, #status_fairy_buy{fairy_id = FairyId}),
    AllNodeList = data_fairy_buy:get_all_node_by_id(FairyId),
    F = fun(NodeId, Acc) ->
        case lists:member(NodeId, NodeList) of
            true ->
                Power = get_combat(OriginAttr, FairyId, NodeId, Skills, partial),
                [{NodeId, ?activate, Power} | Acc];
            _ ->
                Power = get_combat(OriginAttr, FairyId, NodeId, Skills, expact),
                [{NodeId, ?not_activate, Power} | Acc]
        end end,
    SendNodeList = lists:foldl(F, [], AllNodeList),
    IsBuy =
        case lists:keyfind(FairyId, #status_fairy_buy.fairy_id, FairyBuyList) of
            false -> 0;
            _ -> 1
        end,
    lib_server_send:send_to_sid(Sid, pt_513, 51300, [FairyId, IsBuy, SendNodeList]),
    ok.

%% 激活节点
activate_node(Ps, FairyId, NodeId) ->
    #player_status{id = RoleId, fairy_buy_status = FairyBuyList, figure = #figure{lv = Lv}} = Ps,
    case lists:keyfind(FairyId, #status_fairy_buy.fairy_id, FairyBuyList) of
        #status_fairy_buy{fairy_id = FairyId, node_list = NodeIdList} = FairyBuyStatus ->
            CheckList = [{lv, Lv}, {member, NodeId, NodeIdList}],
            case chek_fairy_condition(FairyId, NodeId, CheckList) of
                true ->
                    NewNodeIdList = [NodeId | NodeIdList],
                    FairyBuyStatus2 = FairyBuyStatus#status_fairy_buy{node_list = NewNodeIdList},
                    FairyBuyStatus3 = count_fairy_buy_attribute(FairyBuyStatus2),
                    NewFairyBuyList = lists:keystore(FairyId, #status_fairy_buy.fairy_id, FairyBuyList, FairyBuyStatus3),
                    NewPs = Ps#player_status{fairy_buy_status = NewFairyBuyList},
                    db_save_fairy_buy(RoleId, FairyBuyStatus3),
                    NewPlayer1 = lib_mount:count_mount_attr(NewPs),
                    NewPlayer2 = lib_player:count_player_attribute(NewPlayer1),
                    lib_player:send_attribute_change_notify(NewPlayer2, ?NOTIFY_ATTR),
                    #fairy_buy_cfg{module = TypeId} = data_fairy_buy:get_fairy_buy_cfg(FairyId),
                    LastPs = lib_mount_api:power_change_event(NewPlayer2, TypeId),
                    #fairy_buy_node_cfg{skill = PassiveSkillsAdd} = data_fairy_buy:get_fairy_buy_node(FairyId, NodeId),
                    case PassiveSkillsAdd of
                        [] -> skip;
                        _ -> mod_scene_agent:update(LastPs, [{passive_skill, PassiveSkillsAdd}])
                    end,
                    pp_mount:handle(16002, LastPs, [TypeId]),
                    {?SUCCESS, LastPs};
                {_, Err} ->
                    {?ERRCODE(Err), Ps}
            end;
        _ ->
            {?ERRCODE(err513_not_buy), Ps}
    end.

%% 获取期望战力
get_combat(OriginAttr, FairyId, NodeId, SaveSkills, Type) ->
    #fairy_buy_node_cfg{attr = Attr, skill = Skills} = data_fairy_buy:get_fairy_buy_node(FairyId, NodeId),
    AttrPower =
        case Type == expact of
            true -> lib_player:calc_expact_power(OriginAttr, 0, Attr);
            _ -> lib_player:calc_partial_power(OriginAttr, 0, Attr)
        end,
    case Skills of
        [{SkilId, SkillLv} | _] ->
            [{SkilId, SkillLv} | _] = Skills,
            case lists:keyfind(SkilId, 1, SaveSkills) of
                false ->
                    SkillPower = lib_skill_api:get_skill_power(Skills);
                {SkilId, OldSkillLv} ->
                    if
                        SkillLv > OldSkillLv ->
                            SkillPower = lib_skill_api:get_skill_power(Skills) - lib_skill_api:get_skill_power([{SkilId, OldSkillLv}]);
                        SkillLv < OldSkillLv ->
                            SkillPower = 0;
                        true ->
                            SkillPower = lib_skill_api:get_skill_power([{SkilId, OldSkillLv}])
                    end
            end,
            SkillPower;
        _ -> SkillPower = 0
    end,
    SkillPower + AttrPower.


%% 仙灵直购节点激活检查
chek_fairy_condition(FairyId, NodeId, CheckList) ->
    case data_fairy_buy:get_fairy_buy_node(FairyId, NodeId) of
        #fairy_buy_node_cfg{condition = Condition} ->
            do_check(CheckList, Condition);
        _ ->
            {false, ?FAIL}
    end.

do_check([], _Condition) -> true;
do_check([{member, Id, List} | N], Condition) ->
    case lists:member(Id, List) of
        true ->
            {false, ?FAIL};    %% 已经激活
        _ ->
            do_check(N, Condition)
    end;
do_check([{Key, Value} | N], Condition) ->
    {_, CheckValue} = ulists:keyfind(Key, 1, Condition, {Key, 9999}),
    case Value >= CheckValue of
        true ->
            do_check(N, Condition);
        _ ->
            {false, err513_low_lv}  %% 等级不足
    end.








