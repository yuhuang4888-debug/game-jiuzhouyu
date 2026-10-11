%%%--------------------------------------
%%% @Module  : pp_demons
%%% @Author  : lxl
%%% @Created : 2019.6.22
%%% @Description:  
%%%--------------------------------------

-module(pp_demons).

-export([handle/3]).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("demons.hrl").
-include("goods.hrl").
-include("def_module.hrl").

%% 使魔列表
handle(18301, PS, []) ->
    lib_demons:send_active_demons(PS);

%% 使魔详细信息
handle(18302, PS, [DemonsId]) ->
    lib_demons:send_demons_detail(PS, DemonsId);

%% 羁绊信息
handle(18303, PS, []) ->
    lib_demons:send_demons_fetters(PS);

%% 激活/升星
handle(18304, PS, [DemonsId]) ->
    case lib_demons:active_demons(PS, DemonsId) of 
        {ok, NewPS} ->
            #player_status{status_demons = StatusDemons} = NewPS,
            #status_demons{demons_list = DemonsList} = StatusDemons,
            #demons{star = Star, skill_list = SkillList, power = Power, slot_num = SlotNum} = lists:keyfind(DemonsId, #demons.demons_id, DemonsList),
            SendSkList = [{SkillId, SkillLv, Process, IsActive} ||#demons_skill{skill_id = SkillId, level = SkillLv, process = Process, is_active = IsActive} <- SkillList],
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18304, [?SUCCESS, DemonsId, Star, SendSkList, Power, SlotNum]),
            Star == 1 andalso lib_demons:send_demons_fetters(NewPS),
            {ok, NewPS};
        {false, Res} ->
            ?PRINT("active demons Res ~p~n", [Res]),
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18304, [Res, DemonsId, 0, [], 0, 0])
    end;

%% 升级
handle(18305, PS, [DemonsId]) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
    DemonsUpgradeGoods = lib_demons_util:get_demons_upgrade_goods(DemonsId),
    GoodsIdNumList = [begin
        case data_goods_type:get(GoodsTypeId) of
            #ets_goods_type{bag_location = BagLocation} ->
                GoodsList = lib_goods_util:get_type_goods_list(RoleId, GoodsTypeId, BagLocation, Dict),
                TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
                {GoodsTypeId, TotalNum};
            _ ->
                ?ERR("goods_num err: goods_type_id = ~p err_config", [GoodsTypeId]),
                {GoodsTypeId, 0}
        end
    end||{GoodsTypeId, _AddExp} <- DemonsUpgradeGoods],
    NewGoodsIdNumList = [{GoodsTypeId, Num}||{GoodsTypeId, Num} <- GoodsIdNumList, Num > 0],
    case NewGoodsIdNumList == [] of 
        false ->
            case lib_demons:upgrade_demons(PS, DemonsId, NewGoodsIdNumList) of 
                {ok, NewPS} ->
                    #player_status{status_demons = StatusDemons} = NewPS,
                    #status_demons{demons_list = DemonsList} = StatusDemons,
                    #demons{level = Level, exp = Exp, power = Power} = lists:keyfind(DemonsId, #demons.demons_id, DemonsList),
                    lib_server_send:send_to_sid(Sid, pt_183, 18305, [?SUCCESS, DemonsId, Level, Exp, Power]),
                    {ok, NewPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_183, 18305, [Res, DemonsId, 0, 0, 0])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_183, 18305, [?GOODS_NOT_ENOUGH, DemonsId, 0, 0, 0])
    end;

%% 使魔跟随
handle(18306, PS, [DemonsId]) ->
    case lib_demons:demons_follow(PS, DemonsId) of 
        {ok, NewPS} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18306, [?SUCCESS, DemonsId]),
            {ok, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18306, [Res, DemonsId])
    end;

%% 上卷领取信息
handle(18307, PS, []) ->
    lib_demons:send_painting_info(PS);

%% 上卷领取
handle(18308, PS, [PaintingId]) ->
    case lib_demons:get_painting_reward(PS, PaintingId) of 
        {ok, NewPS} ->
            #base_demons_painting{reward = Reward} = data_demons:get_painting_cfg(PaintingId),
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18308, [?SUCCESS, PaintingId, Reward]),
            {ok, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18308, [Res, PaintingId, []])
    end;

%% 升级使魔技能
handle(18309, PS, [DemonsId, SkillId]) ->
    case lib_demons:upgrade_demons_skill_level(PS, DemonsId, SkillId) of 
        {ok, NewPS, NewLevel} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18309, [?SUCCESS, DemonsId, SkillId, NewLevel]),
            {ok, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18309, [Res, DemonsId, SkillId, 0])
    end;

%% 使魔天赋技能操作
handle(18310, PS, [DemonsId, Slot, GoodsTypeId]) ->
    case lib_demons:upgrade_demons_slot_skill(PS, DemonsId, GoodsTypeId, Slot) of 
        {ok, NewPS, SkillId, Quality, Sort, NewLevel} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18310, [DemonsId, Slot, SkillId, Quality, Sort, NewLevel, ?SUCCESS]),
            {ok, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18310, [DemonsId, Slot, 0, 0, 0, 0, Res])
    end;

%% 使魔商城信息
handle(18311, PS, []) ->
    lib_demons:send_demons_shop_info(PS);

%% 使魔商城购买
handle(18312, PS, [ShopItemId]) ->
    lib_demons:demons_shop_buy(ShopItemId, PS);

%% 使魔商城刷新
handle(18313, PS, []) ->
    lib_demons:demons_shop_refresh(PS);

%% 查看天赋技能战力
handle(18314, PS, [DemonsId, Sign, Id, SkillLv]) ->
    lib_demons:get_slot_skill_power(PS, DemonsId, Sign, Id, SkillLv);

handle(18315, PS, []) ->
    ?PRINT("============== ~n",[]),
    mod_daily:set_count(PS#player_status.id, ?MOD_DEMONS, 1, 1),
    lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18315, [1]);

handle(18316, PS, [DemonsId]) ->
    case lib_demons:active_life_skill(PS, DemonsId) of 
        {true, NewPS} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18316, [?SUCCESS, DemonsId]),
            {ok, NewPS};
        {false, Code} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18316, [Code, DemonsId])
    end;

handle(_Code, _Ps, _) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.