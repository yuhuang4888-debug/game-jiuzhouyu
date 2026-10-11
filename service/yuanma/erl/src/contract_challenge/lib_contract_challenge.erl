%% ---------------------------------------------------------------------------
%% @doc lib_contract_challenge

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/26
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_contract_challenge).

%% API
-export([
    login/1,                    %% 登陆加载contract_buff
    get_legend_attr/1,          %% 获取contract_buff增益属性
    send_contract_buff/1,       %% 发送Buff
    add_legend_attr/3,          %% 添加传说属性
    get_legend_exp_ratio/1,     %% 获取经验加成属性
    cancel_legend_attr/2,       %% 取消添加的传说契约
    use_contract_card/5,        %% 使用契约增益卡
    get_extra_player_time/3,    %% 获取增益卡带来的额外玩法次数
    act_end_action/1            %% 活动结束，减少增益（用户进程调用）
]).

-include("custom_act.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("contract_challenge.hrl").
-include("def_recharge.hrl").
-include("attr.hrl").

%% 登陆查询是否激活了传说契约
login(Ps) when is_record(Ps, player_status) ->
    #player_status{id = RoleId} = Ps,
    NewPs = Ps#player_status{contract_buff = login(RoleId)},
    send_contract_buff(NewPs),
    NewPs;

login(RoleId) ->
    case db:get_row(io_lib:format(?SELECT_ROLE_CONTRACT_BUFF, [RoleId])) of
        [EffectTime, BuffAttrStr, BuffOtherStr] ->
            #contract_buff{
                effect_time = EffectTime,
                buff_attr = util:bitstring_to_term(BuffAttrStr),
                buff_other = util:bitstring_to_term(BuffOtherStr)
            };
        _ -> #contract_buff{}
    end.

%% 获取传说契约属性
get_legend_attr(Ps) ->
    #player_status{contract_buff = #contract_buff{effect_time = EffectTime, buff_attr = BuffAttr}} = Ps,
    Now = utime:unixtime(),
    case EffectTime > Now of
        false -> [];
        true ->
            AttrList = [Attr||{_, Attr}<-BuffAttr],
            lib_player_attr:add_attr(list, AttrList)
    end.

get_legend_exp_ratio(Ps) ->
    Attr = get_legend_attr(Ps),
    {_, ExpRatio} = ulists:keyfind(?EXP_ADD, 1, Attr, {?EXP_ADD, 0}),
    ExpRatio.

%% 用户充值后触发
%% 添加时间戳，且添加属性更新战力
add_legend_attr(Ps, SubType, ETime) ->
    #player_status{id = RoleId} = Ps,
    #custom_act_cfg{condition = Condition} =
        lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType),
    ContractBuff =
        case lib_custom_act_check:check_act_condtion([active_attr], Condition) of
            [Attr] ->
                #contract_buff{effect_time = ETime, buff_attr = [{?Default_buff_goods_id, Attr}]};
            _ -> #contract_buff{effect_time = ETime}
        end,
    lib_contract_challenge_util:save_contract_buff(RoleId, ContractBuff),
    NewPs = Ps#player_status{contract_buff = ContractBuff},
    LastPlayer = lib_player:count_player_attribute(NewPs),
    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
    send_contract_buff(LastPlayer),
    LastPlayer.

cancel_legend_attr(Ps, _SubType) ->
    #player_status{id = RoleId} = Ps,
    lib_contract_challenge_util:save_contract_buff(RoleId, #contract_buff{}),
    NewPs = Ps#player_status{contract_buff = #contract_buff{}},
    LastPlayer = lib_player:count_player_attribute(NewPs),
    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
    send_contract_buff(LastPlayer),
    LastPlayer.

%% 用户使用契约挑战增益卡
use_contract_card(Ps, GoodsTypeId, EffectCustom, CAttr, ModTimes) ->
    {Type, SubType} = EffectCustom,
    ?PRINT("EffectCustom, CAttr, ModTimes ~p ~p ~p", [EffectCustom, CAttr, ModTimes]),
    Now = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = EndTime} when Now < EndTime ->
            #player_status{contract_buff = ContractBuff, id = RoleId} = Ps,
            NewContractBuffTmp = ?IF(CAttr == [], ContractBuff,
                begin
                    #contract_buff{buff_attr = BuffAttr} = ContractBuff,
                    ContractBuff#contract_buff{buff_attr = [{GoodsTypeId,CAttr}|BuffAttr]}
                end),
            NewContractBuff = ?IF(ModTimes == {0,0}, NewContractBuffTmp,
                begin
                    #contract_buff{buff_other = BuffOther} = NewContractBuffTmp,
                    NewContractBuffTmp#contract_buff{buff_other = [{ModTimes,{GoodsTypeId,1}}|BuffOther]}
                end),
            ?PRINT("NewContractBuff ~p ~n", [NewContractBuff]),
            lib_contract_challenge_util:save_contract_buff(RoleId, NewContractBuff),
            NewPs = Ps#player_status{contract_buff = NewContractBuff},
            lib_eudemons_land:update_max_tired(NewPs),
            send_contract_buff(NewPs),
            {true, NewPs};
         _Res ->
             ?PRINT("_Res ~p ~n", [_Res]),
             false
    end.

%% 获取玩法额外次数
get_extra_player_time(Ps, Module, SubModule) ->
    #player_status{contract_buff = #contract_buff{buff_other = BuffOther}} = Ps,
    case lists:keyfind({Module, SubModule},1, BuffOther) of
        false -> 0;
        {_, {_,Times}} -> Times
    end.

%% 活动结束后用户进程调用
%% 减少玩法次数
%% 修正属性
act_end_action(Ps) ->
    NewPs = Ps#player_status{contract_buff = #contract_buff{}},
    LastPlayer = lib_player:count_player_attribute(NewPs),
    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
    lib_eudemons_land:update_max_tired(LastPlayer),
    send_contract_buff(LastPlayer),
    LastPlayer.

%% 发送Buff状态
send_contract_buff(Ps) ->
    #player_status{contract_buff = ContractBuff, id = RoleId} = Ps,
    #contract_buff{effect_time = EffectTime, buff_other = BuffOther, buff_attr = BuffAttr} = ContractBuff,
    Now = utime:unixtime(),
    BuffList =
        case Now < EffectTime of
            true ->
                BuffList1 = [{GoodsTypeId, 0, EffectTime- Now}||{_, {GoodsTypeId, _}} <- BuffOther],
                BuffList2 = [{GoodsTypeId, 0,  EffectTime- Now}||{GoodsTypeId, _}<-BuffAttr],
                BuffList1 ++ BuffList2;
            _ -> []
        end,
    lib_server_send:send_to_uid(RoleId, pt_332, 33237, [RoleId, BuffList]).

