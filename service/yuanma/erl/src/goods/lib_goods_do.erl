-module(lib_goods_do).
-include("goods.hrl").
-include("gift.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("sql_goods.hrl").
-include("server.hrl").
-include("drop.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("language.hrl").
-include("guild.hrl").
-include("team.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("eudemons.hrl").
-include("rune.hrl").
-include("soul.hrl").
-include("def_id_create.hrl").
-include("boss.hrl").
-include("equip_suit.hrl").

-export([
         get_goods_status/0,
         set_goods_status/1
        ]).

-export([
         init_data/2,
         handle_event/2,
         %% ------------------ 增加物品 ------------------
         %give_goods/2,                  %% 赠送物品
         give_more/1,                   %% 赠送物品 (列表中GoodsTypeId不能重复)
         can_give_goods/1,              %% 检查物品是否可以加入到背包，能不能加入完全取决于背包格子数
         can_give_goods/2,
         spilt_send_able_goods/1,       %% 分离物品：{可发送，不可发送}
         goods_merge/2,                 %% 物品合并
         give_more_to_specify_loc/2,    %% 发物品到指定背包
         %% ------------------ 删除物品 ------------------
         delete_one/2,                  %% 删除背包物品 根据物品唯一Id删除物品
         delete_list/1,                 %% 删除背包物品列表  根据物品唯一Id列表删除物品
         delete_one_norefresh/2,        %% 删除背包物品 根据物品类型Id删除物品 不通知前端更新
         %delete_more/2,                 %% 删除多个同类型物品 根据物品类型Id删除物品
         delete_type_list/1,            %% 删除多类物品 根据物品类型Id列表删除物品
         %delete_list_as_much_as_possible/1, %%删除多类物品
         delete_type/1,                 %% 删除多类物品
         check_num/1,                   %% 检查物品数量
         goods_num/1,                   %% goods_num
         goods_num/2,                   %% goods_num

         %% ------------------ 物品操作 ------------------
         drag_goods/4,                  %% 背包拖动物品
         use_goods/3,                   %% 使用物品
         throw/2,                       %% 销毁物品
         order/2,                       %% 整理背包
         %% drop_choose/2 ,                %% 拣取地上掉落包的物品
         split/2,                       %% 拆分物品
         goods_compose/4,               %% 合成物品
         goods_compose_simple/5,        %% 合成物品简单版
         goods_decompose/2,             %% 分解物品
         sell_goods/3,                  %% 出售物品
         %goods_renew/2,                 %% 物品续费
         change_pos/4,                  %% 修改物品背包位置
         move_a2b/4,                    %% 移动物品从A背包到B背包
         move_more_a2b/3,               %% 移动物品从A背包到B背包，直到B背包没有空格子
         move_goods_to_original/3,      %% 移动物品到物品配置的背包里
         %% goods_exchange/4,              %% 物品兑换

         %% ------------------ 背包相关 ------------------
         cell_num/1,                    %% 空格子数
         expand_bag/3,                  %% 扩展背包|仓库

         %%
         info/1,                        %% 获取物品详细信息
         info/2,                        %% 获取物品详细信息
         get_info_stren/2,              %% 获取物品强化信息
         get_info_stone/2,              %% 获取物品宝石信息
         get_info_wash/2,               %% 获取物品洗炼信息
         get_info_awake_lv_list/1,      %% 获取物品觉醒等级信息
         change_goods_sub_location/2,   %% 更改子位置
         goods_fusion/2,                %% 背包熔炼炼金
         goods_fusion_no_cost/2,        %% 熔炼炼金
         goods_fusion_slient/2,         %% 静默背包熔炼炼金
         %info_other/1,                  %% 获取别人物品详细信息

         %% ------------------ 帮派物品 ------------------
         %movein_guild/4,                %% 存帮派物品
         %moveout_guild/3,               %% 取帮派物品
         %delete_guild/2 ,               %% 删除帮派物品
         %cancel_guild/1 ,               %% 帮派解散
         %extend_guild/2 ,               %% 扩展帮派仓库

         %% ------------------ 礼包宝箱 ------------------
         fetch_gift/2,                  %% 领取礼包，可将礼包放到背包，或直接获取礼包中的物品
         fetch_gift/3,                   %% 领取礼包，可将礼包放到背包，或直接获取礼包中的物品
         %% npc_gift/3                     %% NPC礼包领取
         reclaim_timeout_goods/1,           %% 回收过期物品
         send_goods_expect_power/2,
         get_goods_attr/1
        ]).

get_goods_status() ->
    get({?MODULE, player_goods_status}).

set_goods_status(GoodsStatus) ->
    put({?MODULE, player_goods_status}, GoodsStatus),
    ok.

%% 初始化物品状态数据
init_data(GoodsStatus, _Career) ->
    set_goods_status(GoodsStatus),
    ok.

%% 处理获得物品回调事件 -- 1获得立即使用物品
handle_event(PS, #event_callback{
                    type_id = ?EVENT_GIVE_GOODS,
                    data    = #callback_give_goods_data{
                                 type  = 1,
                                 goods = Goods
                                }}) ->
    case pp_goods:handle(15050, PS, [Goods#goods.id, Goods#goods.num]) of
        {ok, NewPS} -> {ok, NewPS};
        {ok, Value, NewPS} ->
            mod_server:do_return_value(Value, NewPS),
            {ok, NewPS};
        _ -> {ok, PS}
    end;
%% 处理获得物品回调事件 -- 2获得自动吞噬装备
handle_event(PS, #event_callback{
        type_id = ?EVENT_GIVE_GOODS_LIST,
        data    = #callback_give_goods_list{
            type  = 2
        }}) ->
    case lib_game:setting_is_open(PS, 4, 1) of
        true ->
            #goods_status{player_id = PlayerId, dict = Dict} = GS = lib_goods_do:get_goods_status(),
            NullCellNum = lib_goods_util:get_null_cell_num(GS, ?GOODS_LOC_BAG),
            case NullCellNum < 30 of
                true ->
                    GoodsList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, [?GOODS_LOC_BAG], [?WHITE, ?GREEN, ?BLUE, ?PURPLE, ?ORANGE], Dict),
                    BodyEquipList = lib_goods_util:get_equip_list(PlayerId, Dict),
                    Fun = fun(Goods, AccL) ->
                        #goods{id = Id, goods_id = GoodsTypeId, subtype = SubType, num = Num, equip_type = EquipType, other = #goods_other{ rating = Rating }} = Goods,
                        case lists:keyfind(EquipType, #goods.equip_type, BodyEquipList) of
                            #goods{ other = #goods_other{ rating = BodyRating } } when BodyRating > Rating ->
                                Flag = lib_equip:get_equip_star(GoodsTypeId) =< 1 andalso lists:member(SubType, [?EQUIP_BRACELET, ?EQUIP_RING]) == false,
                                ?IF(Flag, [{Id, Num}] ++ AccL, AccL);
                            _ ->
                                AccL
                        end
                    end,
                    FusionList = lists:foldl(Fun, [], GoodsList),
                    case length(FusionList) > 100 of
                        true ->
                            NewFusionList = lists:sublist(FusionList, 100);
                        _ ->
                            NewFusionList = FusionList
                    end,
                    case pp_goods:handle(15025, PS, [NewFusionList]) of
                        {ok, NewPS} ->
                            {ok, NewPS};
                        ok ->
                            {ok, PS}
                    end;
                _ ->
                    {ok, PS}
            end;
        _ -> {ok, PS}
    end;
%% 处理获得物品回调事件 -- 3获得自动分解符文
handle_event(PS, #event_callback{
        type_id = ?EVENT_GIVE_GOODS_LIST,
        data    = #callback_give_goods_list{
            type  = 3
        }}) ->
    #goods_status{player_id = RoleId, dict = Dict} = lib_goods_do:get_goods_status(),
    %% 获取单属性的物品
    OneAttrRuneGoodsList = lib_rune:get_can_decompose_rune_goods(RoleId, Dict),
    GoodsNum = length(OneAttrRuneGoodsList),
    % ?INFO("GoodsNum:~p", [GoodsNum]),
    case GoodsNum >= ?RUNE_LIMIT_1 of
        true ->
            #errorcode_msg{about = Name} = data_errorcode_msg:get(1043),
            #errorcode_msg{about = Material} = data_errorcode_msg:get(1044),
            ColorList = case GoodsNum > ?RUNE_LIMIT_2 of
                            true ->
                                Content = utext:get(1500011, [Name, ?RUNE_LIMIT_2, Material, Name, Name]),
                                LastColor = ?PURPLE,
                                [?WHITE, ?GREEN, ?BLUE, ?PURPLE];
                            false ->
                                Content = utext:get(1500010, [Name, ?RUNE_LIMIT_1, Material, Name, Name]),
                                LastColor = ?BLUE,
                                [?WHITE, ?GREEN, ?BLUE]
                        end,
            %% 分开符文精华和符文装备
            DecomposeGoodsList = lib_rune:get_rune_decompose_list(OneAttrRuneGoodsList, ColorList, lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, Dict)),
            case DecomposeGoodsList =/= [] of
                true ->
                    case lib_goods_do:goods_decompose(PS, DecomposeGoodsList) of
                        [Res, NewPlayerStatus, RewardList] ->
                            %% 发送邮件提醒
                            Title = utext:get(1500009, [Name]),
                            lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
                            {ok, BinData} = pt_150:write(15090, [Res, RewardList, ?GOODS_LOC_RUNE_BAG, LastColor]),
                            lib_server_send:send_to_uid(NewPlayerStatus#player_status.id, BinData),
                            {ok, NewPlayerStatus};
                        Err ->
                            ?ERR("auto_goods_decompose error:~p~n", [Err]),
                            {ok, PS}
                    end;
                false ->
                    {ok, PS}
            end;
        false ->
            {ok, PS}
    end;
%% 处理获得物品回调事件 -- 4获得自动分解源力
handle_event(PS, #event_callback{
        type_id = ?EVENT_GIVE_GOODS_LIST,
        data    = #callback_give_goods_list{
            type  = 4
        }}) ->
    #goods_status{player_id = RoleId, dict = Dict} = lib_goods_do:get_goods_status(),
    %% 过滤掉双属性源力物品
    OneAttrSoulGoodsList = lib_soul:get_can_decompose_soul_goods(RoleId, Dict),
    GoodsNum = length(OneAttrSoulGoodsList),
    % ?INFO("GoodsNum:~p", [GoodsNum]),

    case GoodsNum >= ?SOUL_LIMIT_1 of
        true ->
            #errorcode_msg{about = Name} = data_errorcode_msg:get(1043),
            #errorcode_msg{about = Material} = data_errorcode_msg:get(1046),
            ColorList = case GoodsNum > ?SOUL_LIMIT_2 of
                            true ->
                                Content = utext:get(1500011, [Name, ?SOUL_LIMIT_2, Material, Name, Name]),
                                LastColor = ?PURPLE,
                                [?WHITE, ?GREEN, ?BLUE, ?PURPLE];
                            false ->
                                Content = utext:get(1500010, [Name, ?SOUL_LIMIT_1, Material, Name, Name]),
                                LastColor = ?BLUE,
                                [?WHITE, ?GREEN, ?BLUE]
                        end,
            %% 分开源力结晶和源力装备
            DecomposeGoodsList = lib_soul:get_soul_decompose_list(OneAttrSoulGoodsList, ColorList, lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, Dict)),
            case DecomposeGoodsList =/= [] of
                true ->
                    case lib_goods_do:goods_decompose(PS, DecomposeGoodsList) of
                        [Res, NewPlayerStatus, RewardList] ->
                            %% 发送邮件提醒
                            Title = utext:get(1500009, [Name]),
                            lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
                            {ok, BinData} = pt_150:write(15090, [Res, RewardList, ?GOODS_LOC_SOUL_BAG, LastColor]),
                            lib_server_send:send_to_uid(NewPlayerStatus#player_status.id, BinData),
                            {ok, NewPlayerStatus};
                        Err ->
                            ?ERR("auto_goods_decompose error:~p~n", [Err]),
                            {ok, PS}
                    end;
                false ->
                    {ok, PS}
            end;
        false ->
            {ok, PS}
    end;
%% vip等级
handle_event(PS, #event_callback{type_id = ?EVENT_VIP, data = #callback_vip_change{old_vip_lv = OldVipLv, new_vip_lv = VipLv}}) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{num_cells = NumCells} = GoodsStatus,
    OldDefaultNum = lib_vip_api:get_vip_privilege(?MOD_GOODS, 5, 0, OldVipLv),
    NewDefaultNum = lib_vip_api:get_vip_privilege(?MOD_GOODS, 5, 0, VipLv),
    AddNum = max(NewDefaultNum - OldDefaultNum, 0),
    case maps:get(?GOODS_LOC_BAG, NumCells, false) of
        {_UseNum, MaxNum} when AddNum > 0 ->
            NewMaxNum = MaxNum + AddNum,
            NewGoodsStatus = lib_goods:expand_bag(GoodsStatus, ?GOODS_LOC_BAG, NewMaxNum),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            lib_server_send:send_to_sid(PS#player_status.sid, pt_150, 15002, [1, ?GOODS_LOC_BAG, NewMaxNum]),
            NewPS = PS#player_status{cell_num = NewMaxNum},
            {ok, NewPS};
        _ ->
            {ok, PS}
    end;

%% 玩家等级
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{figure = #figure{lv = PlayerLv}} = PS,
    GS = lib_goods_do:get_goods_status(),
    NewGS = GS#goods_status{player_lv = PlayerLv},
    lib_goods_do:set_goods_status(NewGS),
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.

%% 赠送物品
% give_goods(GoodsTypeId, GoodsNum) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     F = fun() ->
%                 ok = lib_goods_dict:start_dict(),
%                 {ok, {NewStatus, RewardResult}} = lib_goods:give_goods({GoodsTypeId, GoodsNum}, {GoodsStatus, #{}}),
%                 {Dict, GoodsList} =
%                     lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%                 NewStatus2 = NewStatus#goods_status{dict = Dict},
%                 {ok, NewStatus2, GoodsList, RewardResult}
%         end,
%     case lib_goods_util:transaction(F) of
%         {ok, NewStatus, UpdateGoodsList, RewardResult} ->
%             lib_goods_do:set_goods_status(NewStatus),
%             lib_goods_api:notify_client(NewStatus#goods_status.player_id, UpdateGoodsList),
%             1;
%         %% 物品类型不存在
%         {db_error, {error,{_Type, not_found}}} ->
%             2;
%         %% 背包格子不足
%         {db_error, {error,{cell_num, not_enough}}} ->
%             3;
%         %% 动态属性设置权限不足
%         {db_error, {error,{_Type, cannot_overlap}}} ->
%             4;
%         Error ->
%             ?ERR("give_goods error:~p", [Error]),
%             Error
%     end.

%% 赠送物品 (列表中GoodsTypeId不能重复)
%% !! 请确保列表里面只有物品，不能有其它格式的  !!
%% GoodsList = [{GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{?TYPE_GOODS, GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{?TYPE_BIND_GOODS, GoodsNum }, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum }, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum, Bind}, ...]
%% GoodsList = [{goods, GoodsTypeId, GoodsNum, Bind, ExpireTime, LockTime}, ...]
%% GoodsList = [{goods_attr, GoodsTypeId, GoodsNum, AttrList}, ...]
%% GoodsList = [{info, GoodsInfo }, ...]
give_more(GoodsList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_give_list(GoodsList) of
        {ok, GoodsTypeIds} ->
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{gid_in, GoodsTypeIds}]),
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                ok = mod_id_create:start_transaction(?GOODS_ID_CREATE),
                {ok, {NewStatus, RewardResult}} = lib_goods_check:list_handle(fun lib_goods:give_goods/2, {GoodsStatusBfTrans, #{}}, GoodsList),
                {Dict, GoodsL} =
                    lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                NewStatus2 = NewStatus#goods_status{dict = Dict},
                mod_id_create:commit(?GOODS_ID_CREATE),
                {ok, NewStatus2, GoodsL, RewardResult}
            end,
            case lib_goods_util:transaction(F, {mod_id_create, abnormal_commit, [?GOODS_ID_CREATE]}) of
                {ok, NewStatus, UpdateGoodsList, RewardResult} ->
                    LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
                    lib_goods_do:set_goods_status(LastStatus),
                    lib_goods_api:notify_client(LastStatus#goods_status.player_id, UpdateGoodsList),
                    {1, UpdateGoodsList, RewardResult};
                %% 物品类型不存在
                {db_error, {error,{_, not_found}}} ->
                    2;
                %% 背包格子不足
                {db_error, {error,{cell_num, not_enough}}} ->
                    3;
                %% 动态属性设置权限不足
                {db_error, {error,{_Type, cannot_overlap}}} ->
                    4;
                %% 背包类型配置错误
                {db_error, {error,{GTypeId, bag_location_fail}}} ->
                    ?ERR("bag_location_fail error GTypeId:~p", [GTypeId]),
                    ?ERRCODE(err150_bag_location_fail);
                Error ->
                    ?ERR("give_more error:~p", [Error]),
                    Error
            end;
        {false, duplicate} -> %% 列表中GoodsTypeId重复
            5
    end.

%% 发物品到指定背包
%% 某些特定活动才能调用这个接口！！！！！！！！
%% GoodsList = [{location, Location, GoodsTypeId, GoodsNum }, ...]
give_more_to_specify_loc(Location, GoodsList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_give_to_specify_loc(Location, GoodsList) of
        ok ->
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{location, [Location]}]),
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                ok = mod_id_create:start_transaction(?GOODS_ID_CREATE),
                {ok, {NewStatus, RewardResult}} = lib_goods_check:list_handle(fun lib_goods:give_goods/2, {GoodsStatusBfTrans, #{}}, GoodsList),
                {Dict, GoodsL} =
                    lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                NewStatus2 = NewStatus#goods_status{dict = Dict},
                mod_id_create:commit(?GOODS_ID_CREATE),
                {ok, NewStatus2, GoodsL, RewardResult}
            end,
            case lib_goods_util:transaction(F, {mod_id_create, abnormal_commit, [?GOODS_ID_CREATE]}) of
                {ok, NewStatus, UpdateGoodsList, RewardResult} ->
                    LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
                    lib_goods_do:set_goods_status(LastStatus),
                    lib_goods_api:notify_client(LastStatus#goods_status.player_id, UpdateGoodsList),
                    {1, UpdateGoodsList, RewardResult};
                %% 物品类型不存在
                {db_error, {error,{_, not_found}}} ->
                    2;
                %% 背包格子不足
                {db_error, {error,{cell_num, not_enough}}} ->
                    3;
                %% 动态属性设置权限不足
                {db_error, {error,{_Type, cannot_overlap}}} ->
                    4;
                %% 背包类型配置错误
                {db_error, {error,{GTypeId, bag_location_fail}}} ->
                    ?ERR("bag_location_fail error GTypeId:~p", [GTypeId]),
                    ?ERRCODE(err150_bag_location_fail);
                Error ->
                    ?ERR("give_more error:~p", [Error]),
                    Error
            end;
        {false, duplicate} -> %% 列表中GoodsTypeId重复
            5;
        {false, ErrorCode} ->
            ErrorCode
    end.


%% 检查物品是否可以加入到背包，能不能加入完全取决于背包格子数
%% return => {false, ErrorCode} | true
can_give_goods(GoodsTypeList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    lib_goods:can_give_goods(GoodsStatus, GoodsTypeList).

can_give_goods(GoodsTypeList, LocLimitL) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    lib_goods:can_give_goods(GoodsStatus, GoodsTypeList, LocLimitL).

%% 拆分可发送和不可发送的道具
spilt_send_able_goods(GoodsTypeList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    lib_goods:spilt_send_able_goods(GoodsStatus, GoodsTypeList).

%% 物品合并
goods_merge(PlayerStatus, [Type, GoodsId1, GoodsId2]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case Type of
        1 ->
            case lib_goods_relation:merge_goods_default(GoodsStatus, PlayerStatus) of
                {ok, NewGoodsStatus} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    1;
                _E ->
                    10
            end;
        2 ->
            case lib_goods_relation:check_goods_merge(GoodsId1, GoodsId2, PlayerStatus, GoodsStatus) of
                {fail, Res} ->
                    Res;
                {ok, GoodsInfo1, GoodsInfo2} ->
                    case lib_goods_relation:goods_merge_move(GoodsInfo1, GoodsInfo2, GoodsStatus) of
                        {ok, _NewGoodsInfo, NewGoodsStatus} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            1;
                        _Error ->
                            10
                    end
            end;
        _ ->
            4
    end.


%% 删除背包物品 根据物品唯一Id删除物品
delete_one(GoodsId, GoodsNum) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    delete_one_2(GoodsStatus, GoodsId, GoodsNum).

delete_one_2(GoodsStatus, GoodsId, GoodsNum) ->
    case lib_goods_check:check_delete(GoodsStatus, GoodsId, GoodsNum) of
        {fail, Res} -> {Res, {}};
        {ok, GoodsInfo} ->
            case lib_goods:delete_one(GoodsInfo, [GoodsStatus, GoodsNum]) of
                [NewStatus, _] ->
                    lib_goods_do:set_goods_status(NewStatus),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    NewGoodsInfo = GoodsInfo#goods{num = NewNum},
                    PlayerId = NewStatus#goods_status.player_id,
                    lib_goods_api:notify_client_num(PlayerId, [NewGoodsInfo]),
                    {1, GoodsInfo};
                Error ->
                    ?ERR("mod_goods delete_one:~p", [Error]),
                    {0, {}}
            end
    end.

%% 删除背包物品列表  根据物品唯一Id列表删除物品
delete_list(GoodsListArg) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    delete_list_2(GoodsStatus, GoodsListArg).

delete_list_2(GoodsStatus, GoodsListArg) ->
    GoodsList = lib_goods_check:combine_goods_num_list(GoodsListArg),
    case lib_goods_check:check_delete_list(GoodsStatus, GoodsList) of
        {fail, Res} -> {Res, []};
        {ok, NewGoodsList} ->
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{id_in, [Id||{#goods{id=Id}, _} <- NewGoodsList]}]),
            %?PRINT("delete_list dict size :~p~n", [dict:size(GoodsStatusBfTrans#goods_status.dict)]),
            F = fun() ->
                        ok = lib_goods_dict:start_dict(),
                        {ok, NewStatus} = lib_goods:delete_goods_list(GoodsStatusBfTrans, NewGoodsList),
                        {Dict, GoodsL} =
                            lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                        NewStatus2 = NewStatus#goods_status{dict = Dict},
                        {ok, NewStatus2, GoodsL}
                end,
            case lib_goods_util:transaction(F) of
                {ok, NewStatus, UpdateGoodsList} ->
                    LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
                    lib_goods_do:set_goods_status(LastStatus),
                    lib_goods_api:notify_client_num(LastStatus#goods_status.player_id, UpdateGoodsList),
                    {1, NewGoodsList};
                Error ->
                    ?ERR("mod_goods delete_list:~p", [Error]),
                    {0, []}
            end
    end.

%% 删除背包物品 根据物品类型Id删除物品 不通知前端更新
delete_one_norefresh(GoodsTypeId, GoodsNum) ->
    GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
    if
        is_record(GoodsTypeInfo, ets_goods_type) == false -> ?ERRCODE(err150_type_err);
        true ->
            #ets_goods_type{bag_location = BagLocation} = GoodsTypeInfo,
            GoodsStatus = lib_goods_do:get_goods_status(),
            GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId,
                                                           BagLocation, GoodsStatus#goods_status.dict),
            TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
            if
                %% 物品不存在
                length(GoodsList) =:= 0 -> 2;
                %% 物品数量不足
                TotalNum < GoodsNum orelse GoodsNum =< 0 -> 3;
                true ->
                    Fun = fun() ->
                                  ok = lib_goods_dict:start_dict(),
                                  {ok, NewStatus} = lib_goods:delete_more(GoodsStatus, GoodsList, GoodsNum),
                                  Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
                                  NewStatus2 = NewStatus#goods_status{dict = Dict},
                                  {ok, NewStatus2}
                          end,
                    case lib_goods_util:transaction(Fun) of
                        {ok, NewStatus} ->
                            lib_goods_do:set_goods_status(NewStatus),
                            1;
                        Error ->
                            ?ERR("mod_goods delete_more:~p", [Error]),
                            0
                    end
            end
    end.

%%删除多类物品 根据物品类型Id列表删除物品
%% GoodsTypeListArg = [{GoodsTypeId1,GoodsNum}, {GoodsTypeId2,GoodsNum}, ...]
delete_type_list(GoodsTypeListArg) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsTypeList = lib_goods_check:combine_goods_num_list(GoodsTypeListArg),
    case lib_goods_check:check_delete_type_list(GoodsStatus, GoodsTypeList) of
        {fail} -> 0;
        {ok} ->
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{gid_key_in, 1, GoodsTypeListArg}]),
            %?PRINT("delete_type dict size :~p~n", [dict:size(GoodsStatusBfTrans#goods_status.dict)]),
            Fun = fun() ->
                          ok = lib_goods_dict:start_dict(),
                          F = fun lib_goods:delete_type_list_goods/2,
                          case lib_goods_check:list_handle(F, GoodsStatusBfTrans, GoodsTypeList) of
                              {ok, NewStatus} ->
                                  {Dict, GoodsL} =
                                      lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                                  NewStatus2 = NewStatus#goods_status{dict = Dict},
                                  {ok, NewStatus2, GoodsL};
                              _ ->
                                  throw({error, {not_enough}})
                          end
                  end,
            case lib_goods_util:transaction(Fun) of
                {ok, NewStatus, UpdateGoodsList} ->
                    LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
                    lib_goods_do:set_goods_status(LastStatus),
                    lib_goods_api:notify_client_num(LastStatus#goods_status.player_id, UpdateGoodsList),
                    1;
                _ ->
                    0
            end
    end.

%%删除多类物品
%% GoodsTypeList = [GoodsTypeId1, GoodsTypeId2, ...]
delete_type(GoodsTypeList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    Fun = fun() ->
                  ok = lib_goods_dict:start_dict(),
                  F = fun lib_goods:delete_type_goods/2,
                  case lib_goods_check:list_handle(F, GoodsStatus, GoodsTypeList) of
                      {ok, NewStatus} ->
                          {Dict, GoodsL} =
                              lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                          NewStatus2 = NewStatus#goods_status{dict = Dict},
                          {ok, NewStatus2, GoodsL};
                      _ ->
                          throw({error, {error}})
                  end
          end,
    case lib_goods_util:transaction(Fun) of
        {ok, NewStatus, UpdateGoodsList} ->
            lib_goods_do:set_goods_status(NewStatus),
            lib_goods_api:notify_client_num(NewStatus#goods_status.player_id, UpdateGoodsList),
            ok;
        Error ->
            Error
    end.

%% 检查物品数量
check_num(GoodsTypeList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods:check_goods_num(GoodsTypeList, GoodsStatus) of
        {ok, 1} -> 1;
        _ -> 0
    end.

%% 查询道具数量
goods_num(GoodsTypeList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsNum = [begin
                    case data_goods_type:get(GoodsTypeId) of
                        #ets_goods_type{bag_location = BagLocation} ->
                            GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId, BagLocation, GoodsStatus#goods_status.dict),
                            TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
                            {GoodsTypeId, TotalNum};
                        _ ->
                            ?ERR("goods_num err: goods_type_id = ~p err_config", [GoodsTypeId]),
                            {GoodsTypeId, 0}
                    end
                end || GoodsTypeId <- GoodsTypeList],
    GoodsNum.

%% 查询道具数量
goods_num(GoodsTypeList, Bind) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsNum = [begin
                    case data_goods_type:get(GoodsTypeId) of
                        #ets_goods_type{bag_location = BagLocation} ->
                            GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId, Bind, BagLocation, GoodsStatus#goods_status.dict),
                            TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
                            {GoodsTypeId, TotalNum};
                        _ ->
                            ?ERR("goods_num err: goods_type_id = ~p err_config", [GoodsTypeId]),
                            {GoodsTypeId, 0}
                    end
                end || GoodsTypeId <- GoodsTypeList],
    GoodsNum.

%%--------------------------------------------------------
%% @doc 背包拖动物品
%% param: GoodsId       :: integer() 物品Id
%%        OldCell       :: integer() 所在格子
%%        NewCell       :: integer() 要移到的格子
%% return:GoodsInfo1    :: #goods{}  移动后OldCell格子物品
%%        GoodsInfo2    :: #goods{}  移动后NewCell格子物品
%%--------------------------------------------------------
drag_goods(PlayerStatus, GoodsId, OldCell, NewCell) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
                                                %检查
    case lib_goods_check:check_drag_goods(GoodsStatus, GoodsId, OldCell, NewCell, PlayerStatus#player_status.cell_num) of
        {fail, Res} ->
            [Res, #goods{}, #goods{}];
        {ok, GoodsInfo} ->
                                                %拖动
            case lib_goods:drag_goods(GoodsStatus, GoodsInfo, OldCell, NewCell) of
                {ok, NewStatus, [NewGoodsInfo1, NewGoodsInfo2]} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    [?SUCCESS, NewGoodsInfo1, NewGoodsInfo2];
                Error ->
                    ?ERR("handle_call 15040 lib_goods:drag_goods error:~p", [Error]),
                    [?FAIL, #goods{}, #goods{}]
            end
    end.

%%---------------------------------------------------
%% 使用物品
%% param: GoodsId   :: integer() 物品Id
%%        Num       :: integer() 物品数量
%% return:GoodsInfo :: #goods{}  物品信息
%%        NewNum    :: integer() 新的数量 失败返回0
%%---------------------------------------------------
use_goods(PlayerStatus, GoodsId, GoodsNum) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_use_goods(PlayerStatus, GoodsId, GoodsNum, GoodsStatus) of
        {fail, Res} ->
            [PlayerStatus, Res, #goods{}, 0, []];
        {ok, _GoodsInfo, _OptionalGift} -> %% 自选礼包，不走15050
            [PlayerStatus, ?ERRCODE(err150_type_err), #goods{}, 0, []];
        {ok, GoodsInfo, GiftInfo, Cost, GiftReward, RewardList} -> %% 礼包使用
            case lib_gift_new:use_gift(PlayerStatus, GoodsStatus, GoodsInfo, GiftInfo, GoodsNum, Cost, GiftReward, RewardList) of
                {ok, NewPlayerStatus, NewStatus, NewNum, GiveList} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    % if
                    %     GoodsInfo#goods.subtype == ?GOODS_GIFT_STYPE_EUDEMONS -> %% 触发成就
                    %         {ok, NewPs} = lib_achievement_api:eudemons_land_equipbox_event(NewPlayerStatus, GoodsInfo#goods.goods_id);
                    %     true ->
                    %         NewPs = NewPlayerStatus
                    % end,
                    [NewPlayerStatus, ?SUCCESS, GoodsInfo, NewNum, GiveList];
                {fail, Res} ->
                    [PlayerStatus, Res, #goods{}, 0, []];
                Error ->
                    ?ERR("mod_goods use_gift error:~p", [Error]),
                    [PlayerStatus, ?FAIL, #goods{}, 0, []]
            end;
        {ok, GoodsInfo} -> %% 物品
            GoodsList = [],
            case lib_goods_use:use_goods(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum) of
                {ok, NewPlayerStatus, NewStatus, NewNum} ->
                    Code = ?IF(GoodsInfo#goods.goods_id =:= ?USE_STAMINA_ELIXIR, ?ERRCODE(err460_use_success), ?SUCCESS),
                    lib_goods_do:set_goods_status(NewStatus),
                    %% 日志
                    lib_log_api:log_throw(goods_use, PlayerStatus#player_status.id, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, GoodsNum, 0, 0),
                    lib_goods_api:notify_client_num(NewPlayerStatus#player_status.id, [GoodsInfo#goods{num = NewNum}]),
                    [NewPlayerStatus, Code, GoodsInfo, NewNum, GoodsList];

                {use_designtion_good, NewPlayerStatus, NewStatus, NewNum, Coin} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    lib_log_api:log_throw(goods_use, PlayerStatus#player_status.id, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, GoodsNum, 0, 0),
                    lib_goods_api:notify_client_num(NewPlayerStatus#player_status.id, [GoodsInfo#goods{num = NewNum}]),
                    [use_designtion_goods, NewPlayerStatus, Coin, GoodsInfo, NewNum, GoodsList];

                % {fireworks, NewPlayerStatus, NewStatus, NewNum, GiveList, Produce} ->
                %     lib_goods_do:set_goods_status(NewStatus),
                %     lib_log_api:log_throw(goods_use, PlayerStatus#player_status.id, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, GoodsNum, 0, 0),
                %     lib_goods_api:notify_client_num(NewPlayerStatus#player_status.id, [GoodsInfo#goods{num = NewNum}]),
                %     lib_goods_api:send_reward_with_mail(NewPlayerStatus#player_status.id, Produce),
                %     [NewPlayerStatus, ?SUCCESS, GoodsInfo, NewNum, GiveList];

                {nothing, NewPlayerStatus, NewStatus, NewNum} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    [NewPlayerStatus, ?ERRCODE(err150_nothing), GoodsInfo, NewNum, GoodsList];

                {fail, Res2} ->
                    % ?ERR("mod_goods RoleId:~p, use_goods:~p, GoodsInfo:~p~n", [PlayerStatus#player_status.id, Res2, GoodsInfo#goods.goods_id]),
                    ?DEBUG("mod_goods RoleId:~p, use_goods:~p, GoodsInfo:~p~n", [PlayerStatus#player_status.id, Res2, GoodsInfo#goods.goods_id]),
                    [PlayerStatus, Res2, GoodsInfo, 0, GoodsList];

                Error ->
                    ?ERR("mod_goods RoleId:~p, use_goods:~p, GoodsInfo:~p~n", [PlayerStatus#player_status.id, Error, GoodsInfo#goods.goods_id]),
                    [PlayerStatus, ?FAIL, #goods{}, 0, GoodsList]
            end
    end.

%%----------------------------------------------------------
%% 销毁物品
%%----------------------------------------------------------
throw(GoodsId, GoodsNum) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_throw(GoodsStatus, GoodsId, GoodsNum) of
        {fail, Res} -> Res;
        {ok, GoodsInfo} ->
            case lib_goods:delete_one(GoodsStatus, GoodsInfo, GoodsNum) of
                {ok, NewStatus, NewNum} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    lib_log_api:log_throw(throw, NewStatus#goods_status.player_id, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, GoodsNum, 0, 0),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    NewGoodsInfo = GoodsInfo#goods{num = NewNum},
                    PlayerId = NewStatus#goods_status.player_id,
                    lib_goods_api:notify_client_num(PlayerId, [NewGoodsInfo]),
                    ?SUCCESS;
                Error ->
                    ?ERR("mod_goods throw goods:~p", [Error]),
                    ?FAIL
            end
    end.

%% 整理背包
order(PlayerStatus, Pos)->
    #player_status{cell_num = _CellNum} = PlayerStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{player_id = RoleId, dict = ODict} = GoodsStatus,
    %% 查询背包物品列表
    GoodsList = lib_goods_util:get_goods_list(RoleId, Pos, ODict),
    %% 按物品类型ID排序
    GoodsList1 = lib_goods_util:sort(GoodsList, bind_id),
    F = fun() ->
                ok = lib_goods_dict:start_dict(),
                [_Num, _, NewStatus, _] = lists:foldl(fun lib_goods:clean_bag/2, [1, {}, GoodsStatus, Pos], GoodsList1),
                if
                    Pos == ?GOODS_LOC_STORAGE ->
                        Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
                        NewGoodsStatus = GoodsStatus#goods_status{dict = Dict},

                        {ok, NewGoodsStatus};
                    Pos == ?GOODS_LOC_BAG ->
                        Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
                        NewGoodsStatus2 = NewStatus#goods_status{dict = Dict},
                        {ok, NewGoodsStatus2};
                    true ->
                        Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
                        NewGoodsStatus2 = NewStatus#goods_status{dict = Dict},
                        {ok, NewGoodsStatus2}
                end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGS} ->
            lib_goods_do:set_goods_status(NewGS),
            [1];
        Error ->
            ?ERR("mod_goods order error:~p", [Error]),
            [0]
    end.

%% ----------------------------------------------------
%% 拣取地上掉落包的物品
%%-----------------------------------------------------
%% drop_choose(Ps, DropId) ->
%%     GoodsStatus = lib_goods_do:get_goods_status(),
%%     case lib_goods_check:check_drop_choose(Ps, GoodsStatus, DropId, GoodsStatus) of
%%         {fail, Res} -> [Ps, Res];
%%         {ok, DropThingTypeInfo, DropInfo, NowCell, NeedCell} ->
%%             case catch lib_goods:drop_choose(Ps, GoodsStatus, DropThingTypeInfo, DropId, NowCell, NeedCell) of
%%                 {ok, NewPs, NewStatus, NewGoodsInfo, UpGoodsList} -> %% 掉物品处理
%%                     lib_goods_do:set_goods_status(NewStatus),
%%                     #ets_drop{notice = Notice, mon_id = MonId, mon_name = MonName,
%%                               scene = SceneId, goods_id = GoodsId} = DropInfo,
%%                     #mon{kind = Kind} = data_mon:get(MonId),
%%                     GoodsList = ?IF(NewGoodsInfo == coin, [{?TYPE_COIN, 0, UpGoodsList}],
%%                                     lib_goods_drop:drop_to_goodslist(DropInfo)),
%%                     ?IF(Kind == ?MON_KIND_COLLECT orelse Kind == ?MON_KIND_TASK_COLLECT,
%%                         lib_goods_api:send_tv_tip(NewPs#player_status.id, 1, GoodsList),
%%                         lib_goods_drop:send_drop_choose_notice(NewPs, DropInfo)),
%%                     if
%%                         Notice == [] orelse NewGoodsInfo == coin -> %% 没有传闻或者掉落的是金币
%%                             NewPS = NewPs;
%%                         true ->
%%                             GoodsArgs = util:pack_tv_goods(GoodsList),
%%                             Args = [Ps#player_status.figure#figure.name, MonName, GoodsArgs],
%%                             send_drop_tv(Notice, NewPs, Args),
%%                             if
%%                                 UpGoodsList == [] -> Rating = 0, ExtraAttr = [];
%%                                 true ->
%%                                     [GoodsInfo|_] = UpGoodsList,
%%                                     #goods{other = #goods_other{rating = Rating, extra_attr = _ExtraAttr}} = GoodsInfo,
%%                                     ExtraAttr = data_attr:unified_format_extra_attr(_ExtraAttr, [])
%%                             end,
%%                             mod_boss:boss_add_drop_log(NewPs#player_status.id, Ps#player_status.figure#figure.name,
%%                                                        SceneId, MonId, Notice, [GoodsId, Rating, ExtraAttr]),
%%                             {ok, NewPS} = lib_player_event:dispatch(NewPs, ?EVENT_DROP_CHOOSE, #{goods => GoodsList, id => DropId})
%%                     end,
%%                     %% case NewPS#player_status.online == ?ONLINE_OFF_ONHOOK of
%%                     %%     false -> [NewPS, ?SUCCESS];
%%                     %%     true ->
%%                     %%         NewPS1 = lib_onhook:calc_onhook_pickup_goods(Ps, GoodsId),
%%                     %%         ?IF(NowCell =< 5,
%%                     %%             begin
%%                     %%                 lib_player:apply_cast(Ps#player_status.id, ?APPLY_CAST_SAVE, lib_onhook, onhook_auto_devour_equips, []),
%%                     %%                 lib_player:apply_cast(Ps#player_status.id, ?APPLY_CAST_SAVE, lib_onhook, onhook_auto_sell_equips, [])
%%                     %%             end, skip),
%%                     %%         [NewPS1, ?SUCCESS]
%%                     %% end;
%%                             [NewPS, ?SUCCESS];
%%                 {fail, Res1} ->
%%                     [Ps, Res1];
%%                 Error ->
%%                     ?ERR("lib_goods_do drop_choose:~p", [Error]),
%%                     [Ps, ?FAIL]
%%             end
%%     end.


%%---------------------------------------------------------
%% 拆分物品
%%---------------------------------------------------------
split(GoodsId, GoodsNum) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_split(GoodsStatus, GoodsId, GoodsNum) of
        {fail, Res} ->
            Res;
        {ok, GoodsInfo} ->
            case lib_goods:split(GoodsStatus, GoodsInfo, GoodsNum) of
                {ok, NewStatus, UpGoods} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    lib_goods_api:notify_client(NewStatus#goods_status.player_id, UpGoods),

                    ?SUCCESS;
                Error ->
                    ?ERR("mod_goods split error:~p", [Error]),
                    ?FAIL
            end
    end.

%%--------------------------------------------------
%% 物品分解
%% @param  PlayerStatus 玩家PS
%% @param  GoodsList    [{GoodsId, Num}]
%% @return              description
%%--------------------------------------------------
goods_decompose(PlayerStatus, GoodsList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_goods_decompose(PlayerStatus, GoodsStatus, GoodsList) of
        {fail, ErrorCode} ->
            [ErrorCode, PlayerStatus, []];
        {ok, RewardList} ->
            case lib_goods_api:delete_more_by_list(PlayerStatus, GoodsList, goods_decompose) of
                1 ->
                    NRewardList = ulists:object_list_plus_extra(RewardList),
                    %?PRINT("15019 NRewardList ~p~n", [NRewardList]),
                    {_, _, NewPlayerStatus, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(PlayerStatus, #produce{type = goods_decompose, reward = NRewardList, show_tips = 3}),
                    F = fun(Item, L) ->
                        case Item of
                            {?TYPE_GOODS, GoodsTypeId, Num} -> ok;
                            {?TYPE_GOODS, GoodsTypeId, Num, _Bind} -> ok;
                            {?TYPE_BIND_GOODS, GoodsTypeId, Num} -> ok;
                            {?TYPE_ATTR_GOODS, GoodsTypeId, Num, _Attr} -> ok;
                            _ -> GoodsTypeId = 0, Num = 0
                        end,
                        case GoodsTypeId > 0 of
                            true ->
                                case lists:keyfind(GoodsTypeId, #goods.goods_id, UpGoodsList) of
                                    #goods{id = GoodsId} -> [{GoodsId, Num}|L];
                                    _ -> L
                                end;
                            _ -> L
                        end
                    end,
                    RewardReturn = lists:foldl(F, [], NRewardList),
                    [?SUCCESS, NewPlayerStatus, RewardReturn];
                ErrorCode -> [ErrorCode, PlayerStatus, []]
            end
    end.

%% 静悄悄吞噬,不要给提示
goods_fusion_slient(PlayerStatus, GoodsList) ->
    case lib_goods_do:goods_fusion(PlayerStatus, GoodsList) of
        {true, NewPlayerStatus, _ExpList, NewRecFusion} ->
            #rec_fusion{lv = Lv, exp = Exp} = NewRecFusion,
            {ok, Bin} = pt_150:write(15024, [Lv, Exp]),
            lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, Bin),
            lib_task_api:fusion_equip(NewPlayerStatus, Lv),
            lib_activitycalen_api:role_success_end_activity(PlayerStatus#player_status.id, ?MOD_GOODS, 0),
            {true, NewPlayerStatus};
        {fail, _Res} ->
            {false, PlayerStatus}
    end.

%%--------------------------------------------------
%% 熔炼炼金
%% @param  PlayerStatus 玩家PS
%% @param  GoodsList    [{GoodsId, Num}]
%% @return              description
%%--------------------------------------------------
goods_fusion(PlayerStatus, GoodsList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_goods_fusion(PlayerStatus, GoodsStatus, GoodsList) of
        {fail, ErrorCode} ->
            {fail, ErrorCode};
        {ok, TotalAddExp, ExpList, DelGoodsInfoList} ->
            #goods_status{rec_fusion = #rec_fusion{lv = OLv, exp = OExp}} = GoodsStatus,
            FusionMaxLv = data_goods_decompose:get_fusion_max_lv(),
            {NLv, NExp} = update_fusion_do(OLv, OExp, TotalAddExp, FusionMaxLv),
            NewRecFusion = #rec_fusion{lv = NLv, exp = NExp},
            FilterConditions = [{id_in, [DelId||{#goods{id=DelId}, _} <- DelGoodsInfoList]}],
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, FilterConditions),
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                {ok, GoodsStatus1} = lib_goods:delete_goods_list(GoodsStatusBfTrans, DelGoodsInfoList),
                lib_goods_util:db_replace_equip_fusion(PlayerStatus#player_status.id, NewRecFusion),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(GoodsStatus1#goods_status.dict),
                NewGoodsStatus = GoodsStatus1#goods_status{dict = Dict, rec_fusion = NewRecFusion},
                {ok, NewGoodsStatus, GoodsL}
            end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, UpGoodsList} ->
                    LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
                    lib_goods_do:set_goods_status(LastStatus),
                    lib_goods_api:notify_client_num(PlayerStatus#player_status.id, UpGoodsList),
                    %% 日志
                    Fun = fun({#goods{id = Id, goods_id = GoodsTypeId}, Num}) ->
                        lib_log_api:log_throw(goods_fusion, PlayerStatus#player_status.id, Id, GoodsTypeId, Num, 0, 0)
                    end,
                    [Fun(OneDel) || OneDel <- DelGoodsInfoList],
                    DelGoodsList = [{GoodsTypeId, Num} || {#goods{goods_id = GoodsTypeId, type = Type, color = Color}, Num} <- DelGoodsInfoList, Type =/= ?GOODS_TYPE_EQUIP orelse (Type == ?GOODS_TYPE_EQUIP andalso Color >= ?PURPLE)],
                    lib_log_api:log_goods_fusion(PlayerStatus#player_status.id, OLv, OExp, NLv, NExp, DelGoodsList),
                    NewPlayerStatus = case OLv /= NLv of
                        true ->
                            case data_goods_decompose:get_fusion_cfg(NLv) of
                                #base_equip_fusion_attr{attr_list = AttrList} ->
                                    NStatusGoods = PlayerStatus#player_status.goods#status_goods{bag_fusion_attr = AttrList},
                                    PlayerStatus1 = PlayerStatus#player_status{goods = NStatusGoods},
                                    CountPS = lib_player:count_player_attribute(PlayerStatus1),
                                    lib_player:send_attribute_change_notify(CountPS, ?NOTIFY_ATTR),
                                    CountPS;
                                _ -> PlayerStatus
                            end;
                        _ -> PlayerStatus
                    end,
                    {true, NewPlayerStatus, ExpList, NewRecFusion};
                _Err ->
                    ?ERR("goods_fusion _Err : ~p~n", [_Err]),
                    {fail, ?FAIL}
            end
    end.

update_fusion_do(Lv, Exp, AddExp, _FusionMaxLv) when AddExp=<0 -> {Lv, Exp};
update_fusion_do(Lv, Exp, AddExp, FusionMaxLv) when Lv>=FusionMaxLv -> {Lv, Exp+AddExp};
update_fusion_do(Lv, Exp, AddExp, FusionMaxLv) ->
    case data_goods_decompose:get_fusion_cfg(Lv) of
        #base_equip_fusion_attr{exp_need = ExpNeed} when (Exp + AddExp)>=ExpNeed ->
            update_fusion_do(Lv+1, 0, Exp + AddExp - ExpNeed, FusionMaxLv);
        _ -> {Lv, Exp+AddExp}
    end.

%%--------------------------------------------------
%% 熔炼炼金不消耗物品，根据GoodsList获取等额经验||用于自动熔炼
%% @param  PlayerStatus 玩家PS
%% @param  GoodsList    [{GoodsId, Num}]
%% @return              {#player_status{}, AddExp}
%%--------------------------------------------------
goods_fusion_no_cost(PlayerStatus, []) -> PlayerStatus;
goods_fusion_no_cost(PlayerStatus, GoodsList) ->
    {TotalAddExp, ExpList} = lib_goods_check:count_fusion_exp_reward_by_ids(PlayerStatus, GoodsList),
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{rec_fusion = #rec_fusion{lv = OLv, exp = OExp}} = GoodsStatus,
    FusionMaxLv = data_goods_decompose:get_fusion_max_lv(),
    {NLv, NExp} = update_fusion_do(OLv, OExp, TotalAddExp, FusionMaxLv),
    NewRecFusion = #rec_fusion{lv = NLv, exp = NExp},
    lib_goods_util:db_replace_equip_fusion(PlayerStatus#player_status.id, NewRecFusion),
    NewGoodsStatus = GoodsStatus#goods_status{rec_fusion = NewRecFusion},
    lib_goods_do:set_goods_status(NewGoodsStatus),
    NewPlayerStatus = case OLv /= NLv of
        true ->
            case data_goods_decompose:get_fusion_cfg(NLv) of
                #base_equip_fusion_attr{attr_list = AttrList} ->
                    NStatusGoods = PlayerStatus#player_status.goods#status_goods{bag_fusion_attr = AttrList},
                    PlayerStatus1 = PlayerStatus#player_status{goods = NStatusGoods},
                    CountPS = lib_player:count_player_attribute(PlayerStatus1),
                    lib_player:send_attribute_change_notify(CountPS, ?NOTIFY_ATTR),
                    CountPS;
                _ -> PlayerStatus
            end;
        _ -> PlayerStatus
    end,
    {ok, BinData} = pt_132:write(13218, [ExpList]),
    {ok, Bin} = pt_150:write(15024, [NLv, NExp]),
    lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, BinData),
    lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, Bin),
    lib_task_api:fusion_equip(NewPlayerStatus, NLv),
    lib_activitycalen_api:role_success_end_activity(PlayerStatus#player_status.id, ?MOD_GOODS, 0),
    NewPlayerStatus.

%%--------------------------------------------------
%% 合成物品
%% @param  PlayerStatus   玩家PS
%% @param  RuleId         合成规则Id
%% @param  SpecifyGIdList [消耗合成道具唯一物品id..]
%%--------------------------------------------------
goods_compose(PlayerStatus, RuleId, RegularGIdList, SpecifyGIdList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_goods_compose(PlayerStatus, GoodsStatus, RuleId, RegularGIdList, SpecifyGIdList) of
        {fail, ErrorCode} ->
            [ErrorCode, 0, PlayerStatus, 0];
        {ok, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, ComposeGBind, IsFirst, SuccessRatio, IsSpecial} ->
            case IsSpecial of
                false ->
                    goods_compose_normal(PlayerStatus, GoodsStatus, RuleId, SpecifyGIdList, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, ComposeGBind, IsFirst, SuccessRatio);
                {true, SpecialType} ->
                    goods_compose_special(SpecialType, PlayerStatus, GoodsStatus, RuleId, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, ComposeGBind, IsFirst, SuccessRatio)
            end
    end.

goods_compose_normal(PlayerStatus, GoodsStatus, _RuleId, SpecifyGIdList, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, ComposeGBind, IsFirst, SuccessRatio) ->
    #player_status{id = RoleId, figure = Figure} = PlayerStatus,
    case lib_goods:goods_compose(PlayerStatus, GoodsStatus, SpecifyGIdList, ComposeCfg, ComposeGBind, SuccessRatio, CostRegularGInfoList, CostSpecifyGInfoList) of
        {ok, _ErrorCode, NewPlayerStatus, IsSucc, ComposeGoodsList} ->
            case IsSucc of
                true ->  %% 成功
                    LastPlayer = NewPlayerStatus,
                    Res = lib_goods_api:give_goods_by_list(LastPlayer, ComposeGoodsList, goods_compose, 0),
                    case Res of
                        {1, GiveGoodsInfoList, _} ->
                            LastCode = ?ERRCODE(err150_compose_success),
                            %% 获取合成物品的物品id
                            case GiveGoodsInfoList of
                                [#goods{id = Id}|_] -> ComposeGoodsId = Id;
                                _ -> ComposeGoodsId = 0
                            end,
                            handle_common_compose_succ(?GOODS_COMPOSE_SPECIAL_NORMAL, LastPlayer, IsFirst, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, GiveGoodsInfoList);
                        _Error ->
                            ?ERR("compose_goods err:~p", [_Error]),
                            LastCode = ?ERRCODE(err150_compose_fail),
                            ComposeGoodsId = 0
                    end;
                false -> %% 失败
                    send_compose_fail_tv(ComposeCfg, RoleId, Figure#figure.name, CostRegularGInfoList, CostSpecifyGInfoList),
                    if
                        ComposeCfg#goods_compose_cfg.type == ?COMPOSE_EQUIP andalso ComposeCfg#goods_compose_cfg.fail_goods =/= [] ->
                            {ok, _, LastPlayer, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(NewPlayerStatus, #produce{type = goods_compose, reward = ComposeCfg#goods_compose_cfg.fail_goods}),
                            case UpGoodsList of
                                [#goods{id = Id}|_] -> ComposeGoodsId = Id;
                                _ -> ComposeGoodsId = 0
                            end;
                        true ->
                            LastPlayer = NewPlayerStatus, ComposeGoodsId = 0
                    end,
                    lib_contract_challenge_api:red_equip_combine(PlayerStatus),
                    LastCode = ?ERRCODE(err150_compose_fail)
            end,
            [LastCode, 0, LastPlayer, ComposeGoodsId];
        {false, ErrorCode, NewPlayerStatus}->
            [ErrorCode, 0, NewPlayerStatus, 0];
        Error ->
            ?ERR("goods_compose error:~p", [Error]),
            [0, 0, PlayerStatus, 0]
    end.

goods_compose_special(SpecialType, PlayerStatus, GoodsStatus, _RuleId, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, ComposeGBind, IsFirst, _SuccessRatio) ->
    TarLocation = case SpecialType of
        ?GOODS_COMPOSE_SPECIAL_1 -> ?GOODS_LOC_EQUIP;
        ?GOODS_COMPOSE_SPECIAL_2 -> ?GOODS_LOC_GOD2_EQUIP;
        ?GOODS_COMPOSE_SPECIAL_3 -> ?GOODS_LOC_REVELATION;
        ?GOODS_COMPOSE_SPECIAL_4 -> ?GOODS_LOC_SEAL_EQUIP;
        ?GOODS_COMPOSE_SPECIAL_5 -> ?GOODS_LOC_DRACONIC_EQUIP;
        ?GOODS_COMPOSE_SPECIAL_6 -> ?GOODS_LOC_GOD_COURT_EQUIP
    end,
    %% 需要一件在身上的装备作为替换目标
    F = fun({GoodsInfo, Num}, {NormalMat, TargetGoodsInfo}) ->
        case GoodsInfo#goods.location == TarLocation of
            true ->
                case lists:keyfind(GoodsInfo#goods.goods_id, 2, ComposeCfg#goods_compose_cfg.goods) of
                    false -> {NormalMat, GoodsInfo};
                    _ -> {NormalMat, false}
                end;
            _ -> {[{GoodsInfo, Num}|NormalMat], TargetGoodsInfo}
        end
    end,
    {CostNormalMat, TargetGoodsInfo} = lists:foldl(F, {[], false}, CostRegularGInfoList++CostSpecifyGInfoList),
    case is_record(TargetGoodsInfo, goods) of
        true ->
            %% 避免合成失败后玩家身上没有装备, 戒指手镯合成概率固定为100%成功
            case lib_goods:goods_compose_special(SpecialType, PlayerStatus, GoodsStatus, ComposeCfg, ComposeGBind, CostRegularGInfoList, CostSpecifyGInfoList, CostNormalMat, TargetGoodsInfo) of
                {ok, _ErrorCode, NewGoodsStatus, NewPlayerStatus, NewTargetGoodsInfo, ReturnArgs} ->
                    handle_special_compose_return(SpecialType, NewPlayerStatus, NewTargetGoodsInfo, ReturnArgs),
                    handle_common_compose_succ(SpecialType, NewPlayerStatus, IsFirst, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, [NewTargetGoodsInfo]),
                    NewPlayerStatus1 = handle_special_compose_succ(SpecialType, NewPlayerStatus, GoodsStatus, NewGoodsStatus, TargetGoodsInfo, NewTargetGoodsInfo),
                    {ok, LastPlayerStatus} = lib_goods_util:count_role_equip_attribute(NewPlayerStatus1),
                    [?ERRCODE(err150_compose_success), 1, LastPlayerStatus, NewTargetGoodsInfo#goods.id];
                {false, ErrorCode, NewPlayerStatus}->
                    [ErrorCode, 1, NewPlayerStatus, 0];
                Error ->
                    ?ERR("goods_compose error:~p", [Error]),
                    [?FAIL, 1, PlayerStatus, 0]
            end;
        _ ->
            [?FAIL, 1, PlayerStatus, 0]
    end.

handle_common_compose_succ(_SpecialType, PlayerStatus, IsFirst, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, GiveGoodsInfoList) ->
    #player_status{id = RoleId, figure = Figure} = PlayerStatus,
    %% 任务
    case ComposeCfg#goods_compose_cfg.goods of
        [{?TYPE_GOODS, GGId, GGNum}|_] ->
            lib_task_api:finish_goods_compose(PlayerStatus, GGId, GGNum);
        _ -> skip
    end,
    if
        ComposeCfg#goods_compose_cfg.type == ?COMPOSE_EQUIP ->
            lib_task_api:red_equip_combine(PlayerStatus, 1);
        true -> skip
    end,
    %% 成就
    if
        ComposeCfg#goods_compose_cfg.type == ?COMPOSE_EQUIP ->
            IsFirst == true andalso mod_counter:increment(RoleId, ?MOD_GOODS, ?MOD_GOODS_COMPOSE, ComposeCfg#goods_compose_cfg.type),
            CallbackData = #callback_equip_compose{goods_list = GiveGoodsInfoList},
            lib_player_event:async_dispatch(RoleId, ?EVENT_EQUIP_COMPOSE, CallbackData),
            lib_achievement_api:compose_red_equip(PlayerStatus, GiveGoodsInfoList),
            lib_eternal_valley_api:async_trigger(RoleId, [{compose, 1}]),
            lib_temple_awaken_api:trigger_compose_equip(RoleId, GiveGoodsInfoList),
            lib_supreme_vip_api:compose_equip(RoleId, GiveGoodsInfoList),
            lib_contract_challenge_api:red_equip_combine(PlayerStatus, GiveGoodsInfoList);
        ComposeCfg#goods_compose_cfg.type == ?COMPOSE_RUNE ->
            lib_achievement_api:compose_rune_event(PlayerStatus, GiveGoodsInfoList);
        ComposeCfg#goods_compose_cfg.type == ?COMPOSE_AWAKEN ->
            lib_achievement_api:compose_soul_event(PlayerStatus, GiveGoodsInfoList);
        ComposeCfg#goods_compose_cfg.type == 6 ->
            Fun = fun(#goods{goods_id = TemGoodsTypeId, color = Color}, TemAcc) ->
                case data_eudemons:get_equip_attr(TemGoodsTypeId) of
                    #base_eudemons_equip_attr{star = Star} ->
                        case lists:keyfind({Star, Color}, 1, TemAcc) of
                            {_, SNum} ->
                                lists:keystore({Star, Color}, 1, TemAcc, {{Star, Color}, SNum + 1});
                            _ ->
                                lists:keystore({Star, Color}, 1, TemAcc, {{Star, Color}, 1})
                        end;
                    _ ->
                        TemAcc
                end
            end,
            AchivList = lists:foldl(Fun, [], GiveGoodsInfoList),
            lib_achievement_api:async_event(RoleId, lib_achievement_api, eudemons_compose_event, AchivList);
        true ->
            skip
    end,
    %% 合成传闻
    send_compose_tv(GiveGoodsInfoList, ComposeCfg, RoleId, Figure#figure.name, CostRegularGInfoList, CostSpecifyGInfoList),
    ok.

handle_special_compose_succ(?GOODS_COMPOSE_SPECIAL_1, PlayerStatus, _OldGoodsStatus, GoodsStatus, _OldTargetGoodsInfo, _NewTargetGoodsInfo) ->
    %% 更新神炼属性
    NewPlayerStatus = lib_equip_refinement:count_equip_refinement_attr(PlayerStatus, GoodsStatus),
    NewPlayerStatus;
handle_special_compose_succ(?GOODS_COMPOSE_SPECIAL_3, PlayerStatus, OldGoodsStatus, _GoodsStatus, _OldTargetGoodsInfo, _NewTargetGoodsInfo) ->
    OldRevelationEquipList = lib_goods_util:get_revelation_equip_list(PlayerStatus#player_status.id, OldGoodsStatus#goods_status.dict),
    NewPlayerStatus = lib_revelation_equip:up_equip_list_af_compose(PlayerStatus, OldRevelationEquipList),
    NewPlayerStatus;
handle_special_compose_succ(?GOODS_COMPOSE_SPECIAL_4, PlayerStatus, _OldGoodsStatus, GoodsStatus, _OldTargetGoodsInfo, _NewTargetGoodsInfo) ->
    NewPlayerStatus = lib_seal:up_equip_list_af_compose(PlayerStatus, GoodsStatus),
    NewPlayerStatus;
handle_special_compose_succ(?GOODS_COMPOSE_SPECIAL_5, PlayerStatus, _OldGoodsStatus, GoodsStatus, _OldTargetGoodsInfo, _NewTargetGoodsInfo) ->
    NewPlayerStatus = lib_draconic:up_equip_list_af_compose(PlayerStatus, GoodsStatus),
    NewPlayerStatus;
handle_special_compose_succ(?GOODS_COMPOSE_SPECIAL_6, PlayerStatus, _OldGoodsStatus, _GoodsStatus, OldTargetGoodsInfo, NewTargetGoodsInfo) ->
    NewPlayerStatus = lib_god_court:compose_equip_core(PlayerStatus, OldTargetGoodsInfo, NewTargetGoodsInfo#goods.id),
    NewPlayerStatus;
handle_special_compose_succ(_, PlayerStatus, _OldGoodsStatus, _GoodsStatus, _OldTargetGoodsInfo, _NewTargetGoodsInfo) ->
    PlayerStatus.

handle_special_compose_return(?GOODS_COMPOSE_SPECIAL_1, PlayerStatus, TargetGoodsInfo, ReturnArgs) ->
    #player_status{id = RoleId} = PlayerStatus,
    #{remove_stone := RemoveStoneL, return_goods := ReturnGoodsL} = ReturnArgs,
    %% 返还物品给玩家
    lib_equip:return_goods_to_player(RoleId, ReturnGoodsL),
    %% 宝石移除日志
    EquipPos = data_goods:get_equip_cell(TargetGoodsInfo#goods.equip_type),
    lib_equip:log_auto_unload_stone(RoleId, ?UNLOAD_STONE_TYPE_REPLACE_EQUIP, EquipPos, RemoveStoneL);
handle_special_compose_return(_, _PlayerStatus, _TargetGoodsInfo, _ReturnArgs) ->
    ok.

%%--------------------------------------------------
%% 合成物品(简单版)：不是指定固定物品的
%% @param  PlayerStatus   玩家PS
%% @param  RuleId         合成规则Id
%%--------------------------------------------------
goods_compose_simple(PlayerStatus, RuleId, CombineNum, RegularList, IrRegularList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_goods_compose_simple(PlayerStatus, GoodsStatus, RuleId, CombineNum, RegularList, IrRegularList) of
        {fail, ErrorCode} ->
            %?PRINT("goods_compose_simple ==== ~p~n ", [ErrorCode]),
            [ErrorCode, PlayerStatus, []];
        {ok, ComposeCfg, _RealCombineNum, RealCostList, RealReward} ->
            case lib_goods_api:can_give_goods(PlayerStatus, RealReward) of
                true ->
                    case lib_goods_api:cost_object_list_with_check(PlayerStatus, RealCostList, goods_compose, "") of
                        {true, PS1} ->
                            %% 合成日志
                            lib_log_api:log_goods_compose(PlayerStatus#player_status.id, RuleId, [], [], RealCostList, 1, RealReward),
                            NewPS = lib_goods_api:send_reward(PS1, #produce{type = goods_compose, reward = RealReward, show_tips = 3}),
                            send_compose_simple_tv([], ComposeCfg, RuleId, PlayerStatus#player_status.figure#figure.name, RealCostList, []),
                            [?ERRCODE(err150_compose_success), NewPS, RealReward];
                        {false, Res, _} ->
                            [Res, PlayerStatus, []]
                    end;
                _ ->
                    [?ERRCODE(err150_no_cell), PlayerStatus, []]
            end
    end.

%%---------------------------------------------------------
%% 合成传闻
%%---------------------------------------------------------
send_compose_tv(GiveGoodsInfoList, ComposeCfg, RoleId, RoleName, CostRegularGInfoList, CostSpecifyGInfoList) ->
    #goods_compose_cfg{type = _ComposeType, goods = ComposeGoods, tv_type = TvType} = ComposeCfg,
    case TvType of
        7 -> %% 传闻id=7
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            lib_chat:send_TV({all}, ?MOD_GOODS, 7, [RoleName, RoleId, GoodsTypeId, 0, []]);
        8 -> %% 传闻id=8
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{color = _Color, other = #goods_other{rating = Rating, extra_attr = ExtraAttr}}|_] -> ok;
                _ -> Rating = 0, ExtraAttr = []
            end,
            EquipStar = case data_equip:get_equip_attr_cfg(GoodsTypeId) of
                #equip_attr_cfg{star = TmpStar} -> TmpStar;
                _ -> 0
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 8, [RoleName, RoleId, EquipStar, GoodsTypeId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))]);
        14 -> %% 传闻id=14
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{color = _Color, other = #goods_other{rating = Rating, extra_attr = ExtraAttr}}|_] -> ok;
                _ -> Rating = 0, ExtraAttr = []
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 14, [RoleName, RoleId, GoodsTypeId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))]);
        15 -> %% 传闻id=15
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{color = _Color, other = #goods_other{rating = Rating, extra_attr = ExtraAttr}}|_] -> ok;
                _ -> Rating = 0, ExtraAttr = []
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 15, [RoleName, RoleId, GoodsTypeId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))]);
        16 ->
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{color = _Color, other = #goods_other{rating = Rating, extra_attr = ExtraAttr}}|_] -> ok;
                _ -> Rating = 0, ExtraAttr = []
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 16, [RoleName, RoleId, GoodsTypeId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))]);
        22 ->
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{other = #goods_other{rating = Rating, skill_id = SkillId}}|_] -> ok;
                _ -> Rating = 0, SkillId = 0
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 22, [RoleName, RoleId, GoodsTypeId, Rating, SkillId]);
        23 ->
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{other = #goods_other{rating = Rating}}|_] -> ok;
                _ -> Rating = 0
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 23, [RoleName, RoleId, GoodsTypeId, Rating]);
        24 -> %% 守护传闻
            ?MYLOG("compose", "TvType ~p~n", [TvType]),
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{other = #goods_other{rating = Rating}}|_] -> ok;
                _ -> Rating = 0
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 24, [RoleName, RoleId, GoodsTypeId, Rating, 0]);
        26 -> %% 暗金装备传闻
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{color = _Color, other = #goods_other{rating = Rating, extra_attr = ExtraAttr}}|_] -> ok;
                _ -> Rating = 0, ExtraAttr = []
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, 26, [RoleName, RoleId, GoodsTypeId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))]);
        233 ->  %% 神庭核心合成传闻
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{subtype = SubType}|_] ->
                    CourtName = data_god_court:get_name_by_core(SubType),
                    lib_chat:send_TV({all}, ?MOD_GOODS, 25, [RoleName, RoleId, CourtName, GoodsTypeId]),
                    ok;
                _ ->
                    ok
            end;
        1509999 ->
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            case GiveGoodsInfoList of
                [#goods{color = _Color, other = #goods_other{rating = Rating, extra_attr = ExtraAttr}}|_] -> ok;
                _ -> Rating = 0, ExtraAttr = []
            end,
            CostNum = statistics_compose_cost_num(ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList),
            LanId = get_equip_compose_lan_id(ComposeCfg, CostNum, true),
            EquipStar = case data_equip:get_equip_attr_cfg(GoodsTypeId) of
                #equip_attr_cfg{star = TmpStar} -> TmpStar;
                _ -> 0
            end,
            lib_chat:send_TV({all}, ?MOD_GOODS, LanId, [RoleName, RoleId, EquipStar, GoodsTypeId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))]);
        _ -> skip
    end.


send_compose_simple_tv(_GiveGoodsInfoList, ComposeCfg, RoleId, RoleName, _CostRegularGInfoList, _CostSpecifyGInfoList) ->
    #goods_compose_cfg{type = _ComposeType, goods = ComposeGoods, tv_type = TvType} = ComposeCfg,
%%    ?MYLOG("compose", "TvType ~p~n", [TvType]),
    case TvType of
        24 -> %% 守护传闻
%%            ?MYLOG("compose", "TvType ~p~n", [TvType]),
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            lib_chat:send_TV({all}, ?MOD_GOODS, 24, [RoleName, RoleId, GoodsTypeId, 0, 0]);
        _ ->
            skip
    end.

send_compose_fail_tv(ComposeCfg, RoleId, RoleName, CostRegularGInfoList, CostSpecifyGInfoList) ->
    #goods_compose_cfg{goods = ComposeGoods, tv_type = TvType} = ComposeCfg,
    case TvType of
        1509999 -> %%
            [{_, GoodsTypeId, _}|_] = ComposeGoods,
            CostNum = statistics_compose_cost_num(ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList),
            LanId = get_equip_compose_lan_id(ComposeCfg, CostNum, false),
            lib_chat:send_TV({all}, ?MOD_GOODS, LanId, [RoleName, RoleId, GoodsTypeId]);
        _ -> skip
    end.

%% 出售物品
sell_goods(PlayerStatus, ShopType, GoodsList) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case check_sell(PlayerStatus, ShopType, GoodsList, GoodsStatus, [], []) of
        {fail, Res} ->
            [Res, PlayerStatus, []];
        {ok, MoneyList, SellList} ->
            %% 出售
            case lib_goods:sell_goods(PlayerStatus, GoodsStatus, MoneyList, SellList) of
                {ok, NewStatus, UpdateGoodsList, GoodsTypeList, RealMoneyL} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    NewPlayerStatus = lib_goods_api:send_reward(PlayerStatus, RealMoneyL, sell_goods, 0),
                    lib_goods_api:notify_client_num(NewPlayerStatus#player_status.id, UpdateGoodsList),
                    %% 出售触发任务状态改变
                    lib_task_api:handle_task_goods_reduce(NewPlayerStatus, GoodsTypeList),
                    [?SUCCESS, NewPlayerStatus, GoodsTypeList];
                Error ->
                    ?ERR("sell_goods sell:~p", [Error]),
                    [?FAIL, PlayerStatus, []]
            end
    end.

check_sell(_PlayerStatus, _ShopType, [], _GoodsStatus, SellList, MoneyList) ->
    {ok, MoneyList, SellList};
check_sell(PlayerStatus, ShopType, GoodsList, GoodsStatus, SellList, MoneyList) ->
    %% 分批出售,一次限制最多出售30件物品
    {SellL, RemainL} = ulists:sublist(GoodsList, 30),
    case lib_goods_check:check_sell(PlayerStatus, ShopType, SellL, GoodsStatus) of
        {fail, Res} -> {fail, Res};
        {ok, TmpMoneyL, TmpSellL} ->
            check_sell(PlayerStatus, ShopType, RemainL, GoodsStatus, [TmpSellL|SellList], [TmpMoneyL|MoneyList])
    end.

change_goods_sub_location(PlayerStatus, GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_good_change_sub_pos(PlayerStatus, GoodsStatus, GoodsId) of
        {fail, Res} -> {false, Res};
        {ok, GoodsInfo, NewSubLocation} ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                [NewGoodsInfo, NewStatus] = lib_goods:change_goods_sub_location(GoodsInfo, GoodsInfo#goods.location, NewSubLocation, 0, GoodsStatus),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                NewStatus2 = NewStatus#goods_status{dict = Dict},
                {ok, NewStatus2, GoodsL, NewGoodsInfo}
            end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, _UpdateGoodsList, NewGoodsInfo} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    %lib_goods_api:notify_client(PlayerStatus#player_status.id, UpdateGoodsList),
                    {true, PlayerStatus, NewGoodsInfo};
                _Err ->
                    ?ERR("change_goods_sub_location _Err:~p", [_Err]),
                    {false, ?FAIL}
            end
    end.

%% 物品续费
% goods_renew(Ps, GoodsId) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     case lib_goods_check:check_goods_renew(Ps, GoodsStatus, GoodsId) of
%         {ok, GoodsInfo, PriceType, Cost, RenewTime} ->
%             %% 玩家货币以及扣钱信息
%             PsMoney = lib_player_record:trans_to_ps_money(Ps, PriceType, Cost, goods_renew),
%             case lib_goods:goods_renew(GoodsStatus, GoodsInfo, PsMoney, RenewTime) of
%                 %% {ok, NewPlayerStatus, NewStatus, EndTime, NewGoodsInfo} ->
%                 {ok, NewPsMoney, NewStatus, EndTime, NewGoodsInfo} ->
%                     lib_goods_do:set_goods_status(NewStatus),
%                     %% 更新玩家的进程数据(消费数据,货币刷新)
%                     NewPs = lib_player_record:update_ps_money_op(Ps, PsMoney, NewPsMoney),
%                     {ok, NewPs1} = lib_goods_util:count_role_equip_attribute(NewPs, NewStatus),
%                     {ok, NewPs2} = lib_player_event:dispatch(NewPs1, ?EVENT_EQUIP, NewGoodsInfo),
%                     if
%                         NewGoodsInfo#goods.goods_id == ?GOODS_ID_DEVIL orelse
%                         NewGoodsInfo#goods.goods_id == ?GOODS_ID_ANGER ->
%                             TvId = ?IF(NewGoodsInfo#goods.goods_id == ?GOODS_ID_DEVIL, 1, 2),
%                             lib_chat:send_TV({all}, ?MOD_SHOP, TvId, [NewPs2#player_status.figure#figure.name]);
%                         true ->
%                             skip
%                     end,
%                     [?SUCCESS, NewPs2, EndTime];
%                 Error ->
%                     ?ERR("renew_goods :~p", [Error]),
%                     [?FAIL, Ps, 0]
%             end;
%         {fail, ErrorCode} ->
%             [ErrorCode, Ps, 0]
%     end.
%% 空格子数
cell_num(Location) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    lib_goods_util:get_null_cell_num(GoodsStatus, Location).

%%----------------------------------------------------------
%% 扩展背包
%%----------------------------------------------------------
expand_bag(PS, Pos, CellNum) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_expand_bag(PS, GoodsStatus, Pos, CellNum) of
        {fail, Res} ->
          {false, Res};
        {ok, CostList, NewCellMaxNum} ->
            case lib_goods_api:cost_objects_with_auto_buy(PS, CostList, extend_bag, "") of
                {true, NewPS, _} ->
                    GoodsStatus1 = lib_goods_do:get_goods_status(),
                    NewGoodsStatus = lib_goods:expand_bag(GoodsStatus1, Pos, NewCellMaxNum),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    case Pos of
                        ?GOODS_LOC_BAG ->
                            LastPS = NewPS#player_status{cell_num = NewCellMaxNum};
                        ?GOODS_LOC_STORAGE ->
                            LastPS = NewPS#player_status{storage_num = NewCellMaxNum};
                        _ ->
                            LastPS = NewPS
                    end,
                    {ok, NewCellMaxNum, LastPS};
                {false, Res, _} -> {false, Res}
            end
    end.

%%----------------------------------------------------------
%% 更改背包位置
%%----------------------------------------------------------
change_pos(Ps, GoodId, FromPos, ToPos)->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_check:check_good_change_pos(Ps, GoodsStatus, GoodId, FromPos, ToPos) of
        {false, Res} -> {Res, Ps};
        {ok, #goods{goods_id = GTypeId, type = Type, subtype = SubType} = GoodsInfo} ->
            case Type == ?GOODS_TYPE_OBJECT andalso lists:member(SubType, ?OBJECT_TO_MONEY_LIST) of
                true ->
                    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{id_in, [GoodId]}]),
                    case catch lib_storage_util:change_money_goods_to_money(GoodsStatusBfTrans, GoodsInfo) of
                        {ok, NewGoodsStatus, MoneyList} ->
                            LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
                            lib_goods_do:set_goods_status(LastStatus),
                            change_pos_handle_task_process(Ps#player_status.id, FromPos, ToPos, GoodsInfo),
                            %% 通知客户端旧背包的物品删除
                            lib_goods_api:notify_client_num(Ps#player_status.id, [GoodsInfo#goods{num = 0}]),
                            NewPs = lib_goods_api:send_reward(Ps, #produce{type = change_pos, reward = MoneyList}),
                            {1, NewPs};
                        _Error ->
                            ?ERR("_Error:~p~n", [_Error]),
                            {0, Ps}
                    end;
                _ ->
                    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{gid_in, [GTypeId]}]),
                    case catch lib_storage_util:movein_pos(GoodsStatusBfTrans, GoodsInfo, ToPos) of
                        {ok, NewGoodsStatus, UpGoods} ->
                            LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
                            lib_goods_do:set_goods_status(LastStatus),
                            change_pos_handle_task_process(Ps#player_status.id, FromPos, ToPos, GoodsInfo),
                            %% 通知客户端旧背包的物品删除
                            lib_goods_api:notify_client_num(Ps#player_status.id, [GoodsInfo#goods{num = 0}]),
                            lib_goods_api:notify_client(Ps#player_status.id, UpGoods),
                            {1, Ps};
                        _Error ->
                            ?ERR("_Error:~p~n", [_Error]),
                            {0, Ps}
                    end
            end
    end.

%%--------------------------------------------------
%% 把物品从A背包移动到B背包
%% @param  GoodsStatus #goods_status{}
%% @param  GoodsInfo   #goods{}
%% @param  ToLoc       B背包位置
%% @param  MoveNum     需要移动的数量
%% @return             {ok, #goods_status{}, UpdateGoodsList}
%%--------------------------------------------------
move_a2b(GoodsStatus, GoodsInfo, ToLoc, MoveNum) when is_integer(MoveNum) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods:move_a2b({GoodsInfo, ToLoc, MoveNum}, GoodsStatus) of
            {ok, NewGoodsStatus, _} ->
                {Dict, UpGoods} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
                LastGoodsStatus = NewGoodsStatus#goods_status{dict = Dict},
                {ok, LastGoodsStatus, UpGoods};
            _ ->
                {ok, GoodsStatus, []}
        end
    end,
    lib_goods_util:transaction(F).

move_more_a2b(GoodsStatus, GoodsInfoList, ToLoc) ->
    %NewGoodsInfoList = [{T, ToLoc} || T <- GoodsInfoList],
    F = fun() ->
            ok = lib_goods_dict:start_dict(),
            %% 直接更改背包位置，不进行物品叠加操作
            FI = fun(GoodsInfo, GoodsStatusTmp) ->
                [_NewGoodsInfo, NewGoodsStatusTmp] = lib_goods:change_goods_cell(GoodsInfo, ToLoc, 0, GoodsStatusTmp),
                NewGoodsStatusTmp
            end,
            NewGoodsStatus = lists:foldl(FI, GoodsStatus, GoodsInfoList),
            {Dict, UpGoods} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
            LastGoodsStatus = NewGoodsStatus#goods_status{dict = Dict},
            {ok, LastGoodsStatus, UpGoods}
        end,
    lib_goods_util:transaction(F).

%% 移动物品到配置背包里
move_goods_to_original(Player, GoodsStatus, GoodsInfoList) ->
    DelGoodsInfoList = [{T, T#goods.num} || T <- GoodsInfoList],
    RewardList = lib_goods:conver_goods_to_reward(GoodsInfoList),
    case lib_goods_api:can_give_goods(Player, RewardList) of
        true ->
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{id_in, [T#goods.id || T <- GoodsInfoList]}]),
            F = fun() ->
                    ok = lib_goods_dict:start_dict(),
                    {ok, NewGoodsStatus} = lib_goods:delete_goods_list(GoodsStatusBfTrans, DelGoodsInfoList),
                    {Dict, UpGoods} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
                    LastGoodsStatus = NewGoodsStatus#goods_status{dict = Dict},
                    Fun = fun({#goods{id = Id, goods_id = GoodsTypeId}, Num}) ->
                        lib_log_api:log_throw(move_goods, GoodsStatus#goods_status.player_id, Id, GoodsTypeId, Num, 0, 0)
                    end,
                    [Fun(OneDel) || OneDel <- DelGoodsInfoList],
                    {ok, LastGoodsStatus, UpGoods}
                end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, UpGoodsList} ->
                    LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
                    lib_goods_do:set_goods_status(LastStatus),
                    lib_goods_api:notify_client(Player#player_status.id, UpGoodsList),
                    {ok, LastStatus, UpGoodsList, RewardList};
                _Err ->
                    ?ERR("move_goods_to_original err:~p~n", [_Err]),
                    {false, ?FAIL}
            end;
        _ ->
            {false, ?ERRCODE(err150_no_cell)}
    end.


%%--------------------------------------------------------------
%% 获取物品详细信息
%% GoodsId :: integer() 物品Id
%% return
%%      GoodsInfo :: #goods{}   物品信息
%%      Stren     :: integer()  强化等级
%%      Addition  :: list()     附加属性[{属性类型,属性值,属性颜色}]
%%      StoneInfo :: list()     宝石列表[{宝石Id,物品类型Id,宝石位置,颜色}]
%%--------------------------------------------------------------
info(GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    info(GoodsStatus, GoodsId).

info(GoodsStatus, GoodsInfo) when is_record(GoodsInfo, goods) ->
    pack_goods_info(GoodsStatus, GoodsInfo);
info(GoodsStatus, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods_info(GoodsId, GoodsStatus#goods_status.dict),
    case is_record(GoodsInfo, goods) of
        true when GoodsInfo#goods.player_id == GoodsStatus#goods_status.player_id ->
            pack_goods_info(GoodsStatus, GoodsInfo);
        _Error ->
            [GoodsStatus, #goods{}, 0, 0, 0, 0, 0, [], [], [], [], [], [], 0, 0, 0, 0, 0, 0, 0, 0, 0, [], 0]
    end.

pack_goods_info(GoodsStatus, GoodsInfo) ->
    case lib_goods_util:load_goods_other(GoodsInfo) of
        true ->
            GoodsOther = GoodsInfo#goods.other,
            Rating = GoodsOther#goods_other.rating,
            OverallRating = lib_equip:cal_equip_overall_rating(GoodsInfo#goods.location, GoodsStatus, GoodsInfo),
            SuitInfoList = get_suit_info(GoodsStatus, GoodsInfo),
            Addition   = GoodsOther#goods_other.addition,
            ExtraAttr = data_attr:unified_format_extra_attr(GoodsOther#goods_other.extra_attr, []),
            Stren = get_info_stren(GoodsStatus, GoodsInfo),
            StoneList           = get_info_stone(GoodsStatus, GoodsInfo),
            MagicList           = [],
            {Division, WashRating, WashAttr} = get_info_wash(GoodsStatus, GoodsInfo),
            {CSpiritStage, CSpiritLv} = get_info_spirit(GoodsStatus, GoodsInfo),
            AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, GoodsInfo),
            case GoodsInfo#goods.location of
                ?GOODS_LOC_EQUIP ->
                    case lists:keyfind(GoodsInfo#goods.cell, #equip_skill.pos, GoodsStatus#goods_status.equip_skill_list) of
                        #equip_skill{skill_id = EquipSkillId, skill_lv = EquipSkillLv} ->
                            EquipSkillRealLv = min(EquipSkillLv, AwakeningLv);
                        _ -> EquipSkillId = 0, EquipSkillRealLv = 0
                    end;
                _ -> EquipSkillId = 0, EquipSkillRealLv = 0
            end,
            MountEquipSkill = GoodsInfo#goods.other#goods_other.skill_id , MountEquipSkillLv = 1,
            {PetEquipStage, PetEquipStar} = lib_mount_equip:get_pet_equip_stage_star(GoodsInfo),
            AwakeLvList = get_info_awake_lv_list(GoodsInfo),
            RefinementLv = lib_equip_refinement:get_refinement_lv(GoodsStatus, GoodsInfo),
            [
                GoodsStatus, GoodsInfo, Stren, Rating, OverallRating,
                Division, WashRating, Addition, StoneList, MagicList, ExtraAttr, WashAttr,
                SuitInfoList, CSpiritStage, CSpiritLv, AwakeningLv, EquipSkillId, EquipSkillRealLv, MountEquipSkill, MountEquipSkillLv,
                PetEquipStage, PetEquipStar, AwakeLvList, RefinementLv
            ];
        false ->
            [GoodsStatus, GoodsInfo, 0, 0, 0, 0, 0, [], [], [], [], [], [], 0, 0, 0, 0, 0, 0, 0, 0, 0, [], 0]
    end.

get_suit_info(GoodsStatus, GoodsInfo) ->
    case GoodsInfo of
        #goods{type = ?GOODS_TYPE_EQUIP, subtype = EquipPos, location = ?GOODS_LOC_EQUIP} ->
            #goods_status{equip_suit_list = SuitList, equip_suit_state = SuitState} = GoodsStatus,
            case lib_equip:get_suit_type(EquipPos) of
                ?EQUIPMENT ->
                    SuitInfoList = lib_equip:get_equipment_suit_info(SuitState),
                    Fun = fun(MakeType, AccL) ->
                        case lists:keyfind({EquipPos, MakeType}, #suit_item.key, SuitList) of
                            #suit_item{ slv = MakeLevel } ->
                                SelectL = [{Mt, Mlv, Count} || {Mt, Mlv, Count} <- SuitInfoList, Mt == MakeType, Mlv == MakeLevel],
                                SelectL ++ AccL;
                            _ ->
                                AccL
                        end
                    end,
                    lists:foldl(Fun, [], [1, 2, 3]);
                ?ACCESSORY ->
                    lib_equip:get_accessory_suit_info(SuitState);
                _ -> []
            end;
        _ ->
            []
    end.

get_info_stone(GoodsStatus, GoodsInfo) ->
    case current_equip_goods(GoodsStatus, GoodsInfo) of
        true -> get_info_stone_helper(GoodsStatus, GoodsInfo);
        false -> []
    end.

get_info_stone_helper(GoodsStatus, GoodsInfo) ->
    EquipPos = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
    EquipStoneList = GoodsStatus#goods_status.equip_stone_list,
    case lists:keyfind(EquipPos, 1, EquipStoneList) of
        {EquipPos, PosStoneInfoR} ->
            #equip_stone{stone_list = PosStoneList} = PosStoneInfoR,
            F = fun(#stone_info{pos = StonePos, gtype_id = StoneId}) ->
                    {StonePos, StoneId}
                end,
            lists:map(F, PosStoneList);
        _ -> []
    end.

get_info_stren(_GoodsStatus, #goods{type = Type, other = #goods_other{stren = Stren}})
when Type =:= ?GOODS_TYPE_EUDEMONS ->
  Stren;

get_info_stren(GoodsStatus, GoodsInfo) ->
    case current_equip_goods(GoodsStatus, GoodsInfo) of
        true -> GoodsInfo#goods.other#goods_other.stren;
        false -> 0
    end.

% get_info_stren_helper(GoodsStatus, GoodsInfo) ->
%     EquipPos = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
%     case lib_equip_check:stren_info(GoodsStatus, EquipPos) of
%         {true, Stren} -> Stren;
%         {false, _Res} -> 0
%     end.

get_info_wash(GoodsStatus, GoodsInfo) ->
    case current_equip_goods(GoodsStatus, GoodsInfo) of
        true -> get_info_wash_helper(GoodsStatus, GoodsInfo);
        false -> {0, 0, []}
    end.

get_info_wash_helper(GoodsStatus, GoodsInfo) ->
    EquipPos = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
    EquipWashMap = GoodsStatus#goods_status.equip_wash_map,
    #equip_wash{
        duan = Division,
        wash_rating = WashRating,
        attr = Attr
    } = maps:get(EquipPos, EquipWashMap, #equip_wash{}),
    {Division, WashRating, Attr}.

get_info_spirit(GoodsStatus, GoodsInfo) ->
    case current_equip_goods(GoodsStatus, GoodsInfo) of
        true ->
            EquipPos = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
            EquipStage = lib_equip:get_equip_stage(GoodsInfo#goods.goods_id),
            CastingSpiritL = GoodsStatus#goods_status.equip_casting_spirit,
            case EquipStage >= ?CASTING_SPIRIT_MIN_STAGE of
                true ->
                    case lists:keyfind(EquipPos, #equip_casting_spirit.pos, CastingSpiritL) of
                        #equip_casting_spirit{stage = Stage, lv = Lv} ->
                            {Stage, Lv};
                        _ -> {0, 0}
                    end;
                false -> {0, 0}
            end;
        false -> {0, 0}
    end.

current_equip_goods(GoodsStatus, GoodsInfo) ->
    GoodsId       = GoodsInfo#goods.id,
    EquipPos      = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
    EquipLocation = GoodsStatus#goods_status.equip_location,
    case lists:keyfind(EquipPos, 1, EquipLocation) of
        {EquipPos, GoodsId} -> true;
        _ -> false
    end.

%% 获得物品觉醒等级
get_info_awake_lv_list(GoodsInfo) ->
    List =
        case GoodsInfo of
            #goods{type = ?GOODS_TYPE_SOUL} ->
                lib_soul:get_awake_lv_list(GoodsInfo);
            #goods{type = ?GOODS_TYPE_RUNE} ->
                lib_rune:get_awake_lv_list(GoodsInfo);
            _ ->
                []
        end,
    F = fun(Value, AccList) ->  %%转换统一格式
            case Value of
                {Attr, Lv, Exp} ->
                    [{Attr, Lv, Exp} | AccList];
                {Attr, Lv} ->
                    [{Attr, Lv, 0} | AccList];
                R ->
                    [R | AccList]
            end
        end,
    lists:reverse(lists:foldl(F, [], List)).

%% 领取礼包，可将礼包放到背包，或直接获取礼包中的物品
fetch_gift(PlayerStatus, GiftId) ->
    fetch_gift(PlayerStatus, GiftId, 1).

fetch_gift(PlayerStatus, GiftId, GiftNum) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_gift_new:fetch_gift_in_good(PlayerStatus, GoodsStatus, GiftId, GiftNum) of
        {ok, NewPlayerStatus, NewGoodsStatus, GoodsL, GiveList} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            {ok, NewPlayerStatus, GoodsL, GiveList};
        {fail, ErrorCode} ->
            {fail, ErrorCode}
    end.

statistics_compose_cost_num(ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList) ->
    #goods_compose_cfg{type = ComposeType, goods = _ComposeGoods} = ComposeCfg,
    case ComposeType of
        ?COMPOSE_EQUIP ->
            NumList = [Num1 ||{#goods{type=GoodsType}, Num1} <- CostRegularGInfoList++CostSpecifyGInfoList, GoodsType == ?GOODS_TYPE_EQUIP],
            lists:sum(NumList);
        _ ->
            NumList = [Num1 ||{#goods{}, Num1} <- CostRegularGInfoList++CostSpecifyGInfoList],
            lists:sum(NumList)
    end.

get_equip_compose_lan_id(ComposeCfg, CostNum, IsSucc) ->
    #goods_compose_cfg{type = ComposeType} = ComposeCfg,
    case ComposeType of
        ?COMPOSE_EQUIP ->
            case CostNum of
                3 -> ?IF(IsSucc == true, 17, 18);
                4 -> ?IF(IsSucc == true, 19, 20);
                5 -> 21;
                _ -> 8
            end;
        _ ->
            8
    end.

%% 回收过期物品
reclaim_timeout_goods(PS) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    GS = lib_goods_do:get_goods_status(),
    NowTime = utime:unixtime(),
    TimeoutGoods = GS#goods_status.timeout_goods,
    Dict = GS#goods_status.dict,
    case TimeoutGoods == [] of
        true -> ok;
        _ ->
            Filter = fun({Id, _GoodsTypeId, _}, DelList) ->
                GoodsInfo = lib_goods_util:get_goods(Id, Dict),
                if
                    is_record(GoodsInfo, goods) =:= false -> DelList;
                    GoodsInfo#goods.player_id =/= RoleId -> DelList;
                    GoodsInfo#goods.location =/= ?GOODS_LOC_BAG andalso GoodsInfo#goods.location =/= ?GOODS_LOC_STORAGE -> DelList;
                    GoodsInfo#goods.expire_time == 0 orelse GoodsInfo#goods.expire_time > NowTime -> DelList;
                    true ->
                        [{GoodsInfo, GoodsInfo#goods.num}|DelList]
                end
            end,
            DelGoodsList = lists:foldl(Filter, [], TimeoutGoods),
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                {ok, NewGS1} = lib_goods:delete_goods_list(GS, DelGoodsList),
                [
                    lib_log_api:log_throw(goods_timeout, RoleId, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, GoodsNum, 0, 0)
                    ||{GoodsInfo, GoodsNum} <- DelGoodsList
                ],
                {NewDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS1#goods_status.dict),
                NewGS = NewGS1#goods_status{dict = NewDict},
                {ok, NewGS, GoodsL}
            end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, UpGoodsList} ->
                    LastGoodsStatus = NewGoodsStatus#goods_status{timeout_goods = []},
                    lib_goods_do:set_goods_status(LastGoodsStatus),
                    lib_goods_api:notify_client(PS, UpGoodsList),
                    lib_server_send:send_to_sid(Sid, pt_150, 15027, [2, TimeoutGoods]),
                    ?PRINT("reclaim_timeout_goods###### ok ~n", []),
                    ok;
                _Err ->
                    ?ERR("reclaim_timeout_goods err:~p~n", [_Err]),
                    ok
            end
    end.

send_goods_expect_power(PlayerStatus, GoodsTypeId) ->
    #player_status{sid = Sid, original_attr = OriginalAttr, id = RoleId, figure = #figure{lv = Lv}} = PlayerStatus,
    {PartialOPower, PartialOAttr} = get_goods_attr(GoodsTypeId),
    case PartialOAttr =/= [] orelse PartialOPower =/= 0 of
        true ->
            ExpectPower = lib_player:calc_expect_power_detail(RoleId, Lv, OriginalAttr, PartialOPower, PartialOAttr),
            lib_server_send:send_to_sid(Sid, pt_150, 15089, [GoodsTypeId, ExpectPower]);
        _ ->
            ok
    end.

get_goods_attr(GoodsTypeId) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{type = ?GOODS_TYPE_RUNE, color = Color, subtype = SubType, level = Level} ->
            Attr = lib_rune:count_one_rune_attr(SubType, Color, Level),
            {0, Attr};
        #ets_goods_type{type = _Type, base_attrlist = BaseAttr} ->
            if
                true ->
                    {0, BaseAttr}
            end;
        _ ->
            {0, []}
    end.

%% 改变物品位置影响任务进度
change_pos_handle_task_process(RoleId, ?GOODS_LOC_BAG, ?GOODS_LOC_STORAGE, #goods{num = Num, goods_id = GoodsTypeId}) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, handle_task_goods_reduce, [[{GoodsTypeId, Num}]]),
    ok;
change_pos_handle_task_process(RoleId, ?GOODS_LOC_STORAGE, ?GOODS_LOC_BAG, #goods{num = Num, goods_id = GoodsTypeId}) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, collect_goods, [[{GoodsTypeId, Num}]]),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, add_stuff, [[{GoodsTypeId, Num}]]),
    ok;
change_pos_handle_task_process(_RoleId, _FromPos, _ToPos, _GoodsInfo) -> ok.

%%------------------------------------------ 暂时没有调用的函数
%%删除多类物品
%% GoodsTypeListArg = [{GoodsTypeId1,GoodsNum}, {GoodsTypeId2,GoodsNum}, ...]
% delete_list_as_much_as_possible(GoodsTypeListArg) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     GoodsTypeList = lib_goods_check:combine_goods_num_list(GoodsTypeListArg),
%     Fun = fun() ->
%                   ok = lib_goods_dict:start_dict(),
%                   F = fun lib_goods:delete_type_list_as_much_as_possible/2,
%                   case lib_goods_check:list_handle(F, {GoodsStatus, []}, GoodsTypeList) of
%                       {ok, NewStatus, RealDelGoodsList} ->
%                           {Dict, GoodsL} =
%                               lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%                           NewStatus2 = NewStatus#goods_status{dict = Dict},
%                           {ok, NewStatus2, RealDelGoodsList, GoodsL};
%                       _ ->
%                           throw({error, {error}})
%                   end
%           end,
%     case lib_goods_util:transaction(Fun) of
%         {ok, NewStatus, RealDelGoodsList, UpdateGoodsList} ->
%             lib_goods_do:set_goods_status(NewStatus),
%             lib_goods_api:notify_client_num(NewStatus#goods_status.player_id, UpdateGoodsList),
%             RealDelGoodsList;
%         _ ->
%             false
%     end.

%%删除多个同类型物品 根据物品类型Id删除物品
% delete_more(GoodsTypeId, GoodsNum) ->
%     GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
%     if
%         is_record(GoodsTypeInfo, ets_goods_type) == false -> ?ERRCODE(err150_type_err);
%         true ->
%             #ets_goods_type{bag_location = BagLocation} = GoodsTypeInfo,
%             GoodsStatus = lib_goods_do:get_goods_status(),
%             GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId,
%                                                            BagLocation, GoodsStatus#goods_status.dict),
%             TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
%             if
%                 %% 物品不存在
%                 length(GoodsList) =:= 0 -> 2;
%                 %% 物品数量不足
%                 TotalNum < GoodsNum orelse GoodsNum =< 0 -> 6;
%                 true ->
%                     Fun = fun() ->
%                                   ok = lib_goods_dict:start_dict(),
%                                   {ok, NewStatus} = lib_goods:delete_more(GoodsStatus, GoodsList, GoodsNum),
%                                   {Dict, GoodsL} =
%                                       lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%                                   NewStatus2 = NewStatus#goods_status{dict = Dict},
%                                   {ok, NewStatus2, GoodsL}
%                           end,
%                     case lib_goods_util:transaction(Fun) of
%                         {ok, NewStatus, UpdateGoodsList} ->
%                             lib_goods_do:set_goods_status(NewStatus),
%                             lib_goods_api:notify_client_num(NewStatus#goods_status.player_id, UpdateGoodsList),
%                             1;
%                         Error ->
%                             ?ERR("mod_goods delete_more:~p", [Error]),
%                             0
%                     end
%             end
%     end.


%% 取帮派物品
% moveout_guild(GuildId, GoodsId, GoodsNum) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     case lib_goods_check:check_moveout_guild(GoodsStatus, GuildId, GoodsId, GoodsNum) of
%         {fail, Res} ->
%             {fail, Res};
%         {ok, GoodsInfo, GoodsTypeInfo, GoodsTypeList} ->
%             case lib_storage_util:moveout_storage(GoodsStatus, GoodsInfo, GoodsNum, ?GOODS_LOC_BAG, GoodsTypeInfo, GoodsTypeList) of
%                 {ok, NewStatus} ->
%                     lib_goods_do:set_goods_status(NewStatus),
%                     log:log_guild_goods(2, GoodsStatus#goods_status.player_id, GuildId, GoodsInfo, GoodsNum),
%                     {ok, GoodsTypeInfo};
%                 _Error ->
%                     {fail, 0}
%             end
%     end.

%% 存帮派物品
% movein_guild(GuildId, GuildMaxNum, GoodsId, GoodsNum) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     case lib_goods_check:check_movein_guild(GoodsStatus, GuildId, GuildMaxNum, GoodsId, GoodsNum) of
%         {fail, Res} ->
%             {fail, Res};
%         {ok, GoodsInfo, GoodsTypeInfo} ->
%             case lib_storage_util:movein_storage(GoodsStatus, GoodsInfo, GoodsNum, ?GOODS_LOC_GUILD, GoodsTypeInfo) of
%                 {ok, NewStatus} ->
%                     lib_goods_do:set_goods_status(NewStatus),
%                     log:log_guild_goods(1, GoodsStatus#goods_status.player_id, GuildId, GoodsInfo, GoodsNum),
%                     ok;
%                 _Error ->
%                     {fail, 0}
%             end
%     end.

%% 删除帮派物品
% delete_guild(GuildId, GoodsId) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     case lib_goods_check:check_delete_guild(GuildId, GoodsId) of
%         {fail, Res} ->
%             {fail, Res};
%         {ok, GoodsInfo, GoodsNum} ->
%             F = fun() ->
%                     ok = lib_goods_dict:start_dict(),
%                     [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [GoodsStatus, GoodsNum]),
%                     log:log_guild_goods(3, GoodsStatus#goods_status.player_id, GuildId, GoodsInfo, GoodsNum),
%                     Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
%                     NewStatus2 = NewStatus#goods_status{dict = Dict},
%                     {ok, NewStatus2}
%                 end,
%             case lib_goods_util:transaction(F) of
%                 {ok, NewStatus} ->
%                     lib_goods_do:set_goods_status(NewStatus),
%                     ok;
%                 _Error ->
%                     {fail, 0}
%             end
%     end.

%% 帮派解散
% cancel_guild(GuildId) ->
%     case (catch lib_goods_util:delete_goods_by_guild(GuildId)) of
%         ok ->
%             ok;
%         _Error ->
%             {fail, 0}
%     end.

%% 扩展帮派仓库
% extend_guild(PlayerStatus, GuildLevel) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     case lib_goods_check:check_extend_guild(PlayerStatus, GuildLevel) of
%         {fail, Res} ->
%             {fail, Res};
%         {ok, GoldNum, GoodsNum, GoodsTypeList} ->
%             case lib_goods:extend_guild(PlayerStatus, GoodsStatus, GoldNum, GoodsNum, GoodsTypeList) of
%                 {ok, NewPlayerStatus, NewStatus} ->
%                     lib_goods_do:set_goods_status(NewStatus),
%                     {ok, NewPlayerStatus};
%                 _Error ->
%                     {fail, 0}
%             end
%     end.

%% NPC礼包领取
%% npc_gift(PlayerStatus, GiftId, Card) ->
%%     GoodsStatus = lib_goods_do:get_goods_status(),
%%     case lib_gift_check:check_npc_gift(PlayerStatus, GoodsStatus, GiftId, Card) of
%%         {fail, Res} ->
%%             [PlayerStatus, Res];
%%         {ok, GiftInfo} ->
%%             case lib_gift:receive_npc_gift(PlayerStatus, GoodsStatus, GiftInfo, Card) of
%%                 {ok, NewPlayerStatus, NewGoodsStatus, _GiveList, GoodsL} ->
%%                     lib_goods_do:set_goods_status(NewGoodsStatus),
%%                     lib_goods_api:notify_client(PlayerStatus, GoodsL),
%%                     [NewPlayerStatus, ?SUCCESS];
%%                 %% 背包格子不足
%%                 {db_error, {error, card_invalid}} ->
%%                     [PlayerStatus, ?ERRCODE(err150_require_err)];
%%                 Error ->
%%                     ?ERR("mod_goods npc_gift:~p", [Error]),
%%                     [PlayerStatus, ?FAIL]
%%             end
%%     end.

%% NPC物品兑换
%% goods_exchange(PlayerStatus, NpcTypeId, ExchangeId, ExchangeTims) ->
%%     GoodsStatus = lib_goods_do:get_goods_status(),
%%     case lib_goods_check:check_npc_exchange(PlayerStatus, GoodsStatus, NpcTypeId, ExchangeId, ExchangeTims) of
%%         {fail, Res} ->
%%             %% io:format("~p  ~p mod_goods npc_exchange1:~p~n", [NpcTypeId, ExchangeId, Res]),
%%             [PlayerStatus, Res, 0];
%%         {ok, ExchangeInfo} ->
%%             case lib_npc_exchange:exchange_goods(PlayerStatus, GoodsStatus, ExchangeInfo, ExchangeTims) of
%%                 {ok, NewPs, NewGs, _GiveList, RemainNum, GoodsL, _GoodsDict} ->
%%                     lib_goods_do:set_goods_status(NewGs),
%%                                                 % lib_gift_new:send_gift_item_notice(NewPs, 0, 0, GiveList),
%%                     lib_goods_api:notify_client(PlayerStatus, GoodsL),
%%                     [NewPs, ?SUCCESS, RemainNum];
%%                 Error ->
%%                     %% io:format("~p  ~p mod_goods npc_exchange2:~p~n", [NpcTypeId, ExchangeId, Error]),
%%                     ?ERR("mod_goods npc_exchange:~p~n", [Error]),
%%                     [PlayerStatus, ?FAIL, 0]
%%             end
%%     end.

%%--------------------------------------------------------------
%% 获取别人物品详细信息
%% GoodsId :: integer() 物品Id
%% return
%%      GoodsInfo :: #goods{} 物品信息
%%      SuitNum   :: integer() 套装数
%%      AttributeList :: list() 属性列表
%%--------------------------------------------------------------
% info_other(GoodsId) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     GoodsInfo = lib_goods_util:get_goods_info(GoodsId, GoodsStatus#goods_status.dict),
%     case is_record(GoodsInfo, goods) of
%         true ->
%             GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
%             AttributeList = data_goods:get_goods_attribute(GoodsInfo, GoodsTypeInfo#ets_goods_type.career),
%             SuitNum = 0,
%             [GoodsInfo, SuitNum, AttributeList];
%         false ->
%             [#goods{}, 0, []]
%     end.

%%----------------------------------------------------------
%% 扩展背包
%%----------------------------------------------------------
% expand_bag(Ps, Pos, CellNum) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     case lib_goods_check:check_expand_bag(Ps, GoodsStatus, Pos, CellNum) of
%         {fail, Res} ->
%             [Res, Ps];
%         {ok, {GoodsList, DelNum, DelGold}} -> %% 已经检查了元宝和数量
%             #player_status{id = RoleId, cell_num = BagCellNum, storage_num = StorageCellNum} = Ps,
%             PsMoney = lib_player_record:trans_to_ps_money(Ps, ?GOLD, DelGold, extend_bag),
%             NowCellNum = ?IF(Pos == ?GOODS_LOC_BAG, BagCellNum, StorageCellNum),
%             RoleArgs = {PsMoney, NowCellNum},
%             case catch lib_goods:expand_bag(GoodsStatus, Pos, CellNum, GoodsList, DelNum, RoleArgs) of
%                 {ok, NewPsMoney, AllCellNum, NewGS, UpGoods} ->
%                     %% 更新物品数据
%                     lib_goods_do:set_goods_status(NewGS),
%                     lib_goods_api:notify_client(RoleId, UpGoods),
%                     %% 更新玩家进程数据
%                     NewPs = ?IF(Pos == ?GOODS_LOC_BAG,
%                                 Ps#player_status{cell_num = AllCellNum},
%                                 Ps#player_status{storage_num = AllCellNum}),
%                     if
%                         DelGold =< 0 ->
%                             [1, NewPs];
%                         true ->
%                             [1, lib_player_record:update_ps_money_op(NewPs, PsMoney, NewPsMoney)]
%                     end;
%                 _Error ->
%                     ?ERR("_Error:~p~n", [_Error]),
%                     [0, Ps]
%             end
%     end.

%% GoodId:唯一id
% change_pos(Ps, GoodId, FromPos, ToPos)->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     case lib_goods_check:check_good_change_pos(Ps, GoodsStatus, GoodId, FromPos, ToPos) of
%         {fail, Res} -> Res;
%         {ok, #goods{goods_id = GoodsTypeId, num = Num} = GoodsInfo} ->
%             case catch lib_storage_util:movein_pos(GoodsStatus, GoodsInfo, ToPos) of
%                 {ok, NewGoodsStatus, UpGoods} ->
%                     lib_goods_do:set_goods_status(NewGoodsStatus),
%                     lib_goods_api:notify_client(Ps#player_status.id, UpGoods),
%                     if
%                         ToPos == ?GOODS_LOC_STORAGE ->
%                             lib_task_api:handle_task_goods_reduce(Ps, [{GoodsTypeId, Num}]);
%                         ToPos == ?GOODS_LOC_BAG ->
%                             lib_task_api:collect_goods(Ps, [{GoodsTypeId, Num}]);
%                         true ->
%                             skip
%                     end,
%                     1;
%                 _Error ->
%                     ?ERR("_Error:~p~n", [_Error]),
%                     0
%             end
%     end.