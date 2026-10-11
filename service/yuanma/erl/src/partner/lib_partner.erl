%%%-----------------------------------------------------------------------------
%%%	@Module  : lib_partner
%%% @Author  : liuxl
%%% @Email   : liuxingli@suyougame.com
%%% @Created : 2016-12-13
%%% @Description : 伙伴
%%%-----------------------------------------------------------------------------
-module(lib_partner).
% -include("server.hrl").
% -include("figure.hrl").
% -include("skill.hrl").
% -include("partner.hrl").
% -include("common.hrl").
% -include ("def_fun.hrl").
% -include ("goods.hrl").
% -include ("attr.hrl").
% -include ("errcode.hrl").
% -include ("predefine.hrl").
% -include ("language.hrl").
% -include ("def_module.hrl").
% -include ("def_id_create.hrl").
% -include ("scene.hrl").
% -include ("rec_event.hrl").
% -include ("def_event.hrl").
% -include ("def_counter.hrl").
% -compile(export_all).
% -export([
%          handle_event/2,            % 升级事件
%          login/1,					% 登陆
%          logout/1,					% 退出
%          give_partner/4,			% 赠予伙伴
%          recruit/3,					% 招募伙伴
%          partner_callback/2,		% 伙伴召回
%          wash_partner/2,			% 伙伴洗髓
%          wash_replace/1,			% 洗髓替换
%          wash_keep/1,				% 洗髓保留
%          partner_add_exp/5,			% 增加经验
%          add_exp/4,					% 增加经验
%          partner_break/2,			% 伙伴突破
%          partner_promote/2,			% 资质提升
%          partner_learn_skill/2,		% 学习技能
%          partner_skill_replace/2,	% 替换技能
%          partner_battle/2,			% 上阵
%          partner_sleep/2,			% 下阵
%          change_battle_pos/3,		% 改变上阵位置
%          change_embattle/2,			% 改变布阵
%          partner_equip_weapon/2,	% 激活专属武器
%          partner_disband/2,         % 伙伴遣散
%          get_discount_goods/2,		% 计算伙伴遣散时资质丹的折算
%          get_partner_apti/2,		% 获取伙伴服用过的资质丹
%          get_diaband_exp_book/2,	% 计算伙伴遣散时折算的经验书
%          calc_partner_upgrade/3,    % 计算伙伴升级的具体等级
%          send_attr_list/2,
%          use_summon_card/3,			% 使用召唤卡
%          use_partner_weapon/3,      % 使用伙伴武器
%          send_tv_recruit/4,         % 伙伴翻牌时发传闻
%          send_goods_notice_msg/2
%         ]).

% %% 登陆
% login({PlayerId, Lv}) ->
%     case Lv >= 10 of
%         true -> skip;
%         false ->
%             lib_player:apply_cast(PlayerId, ?APPLY_CAST, lib_partner, add_listener, [[?EVENT_LV_UP]])
%     end,
%     PartnerMap = lib_partner_do:select_player_partners(PlayerId),
%     PartnerSt = lib_partner_do:select_player_status(PlayerId, PartnerMap),
%     AssistList = lib_partner_util:get_battle_partner_assist(PartnerSt),
%     PlayerAttr = lib_partner_util:get_assist_skill_attr(AssistList),
%     CombatPower = lib_partner_util:get_battle_partner_power(PartnerSt),
%     %% ?PRINT("Embattle ~p~n", [PartnerSt#partner_status.embattle]),
%     {PartnerSt, #status_partner{combat_power = CombatPower, attr = PlayerAttr}}.

% logout(PS) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     PartnerL = maps:values(PartnerSt#partner_status.partners),
%     lib_partner_do:updata_partners_logout(PartnerL),
%     PS.

% add_listener([]) ->
%     ok;
% add_listener([H|T]) ->
%     lib_player_event:add_listener(H, lib_partner, handle_event, []),
%     add_listener(T).

% %% handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
% %%     #player_status{figure = #figure{lv = Lv}} = PS,
% %%     #partner_status{recruit_type2 = {Times, _}} = PartnerSt = lib_partner_do:get_partner_status(),
% %%     if
% %%         Lv < 10 -> {ok, PS};
% %%         true ->
% %%             Now = utime:unixtime(),
% %%             NewPartnerSt = PartnerSt#partner_status{recruit_type2={Times, Now+48*3600}},
% %%             lib_partner_do:update_player_partner(NewPartnerSt),
% %%             lib_partner_do:set_partner_status(NewPartnerSt),
% %%             lib_player_event:remove_listener(?EVENT_LV_UP, lib_partner, handle_event),
% %%             %% ?PRINT("into handle event NewPartnerSt: ~p~n", [NewPartnerSt]),
% %%             {ok, PS}
% %%     end;
% handle_event(PS, #event_callback{}) ->
%     {ok, PS}.

% %% ------------------------------ 赠予伙伴(使用招募卡，副本赠送等) -----------------------
% %% 6元首充的伙伴卡，每个玩家获得的伙伴属性技能一样
% give_partner(PS, PartnerId, GiveType, 211399) ->
%     %% ?PRINT("give_partner special: ~p~n", [PartnerId]),
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case data_partner:get_partner_by_id(PartnerId) of
%         PartnerCfg when is_record(PartnerCfg, base_partner) ->
%             F = fun() ->
%                         CreateId = mod_id_create:get_new_id(?PARTNER_ID_CREATE),
%                         Partner = lib_partner_util:make_base_record(PartnerCfg, PartnerSt#partner_status.pid, CreateId),
%                         %%lib_partner_util:add_partnet(Partner),
%                         %% QualityList = [{?PHYSIQUE, ?ATTR_QUALITY_4}, {?AGILE, ?ATTR_QUALITY_4}, {?FORZA, ?ATTR_QUALITY_4}, {?DEXTEROUS, ?ATTR_QUALITY_4}],
%                         QualityList = [],
%                         %% AGILE = 90 + urand:rand(0,20), FORZA = 90 + urand:rand(0,20), DEXTEROUS = 90 + urand:rand(0,20),
%                         AttrList = [], %% [{?PHYSIQUE, 500-(AGILE+FORZA+DEXTEROUS), 240}, {?AGILE, AGILE, 120}, {?FORZA, FORZA, 120}, {?DEXTEROUS, DEXTEROUS, 120}],
%                         SkList = [{2300021, 1, 1}, {2300047, 1, 2}, {2300034, 1, 3}],
%                         {NewSkList, NewSkCdList} = wash_skill_list(Partner, SkList),
%                         ValueList = [
%                                      {attr_quality, QualityList},
%                                      {total_attr, AttrList},
%                                      {com_skill_list, NewSkList, NewSkCdList},
%                                      {attribute},
%                                      {combat_power}
%                                     ],
%                         NewPartner = lib_partner_util:set_partner_value(Partner, ValueList),
%                         %% 新伙伴加入玩家内存中
%                         RecruitList = PartnerSt#partner_status.recruit_list,
%                         {NewRecruitList, NewPartner2}
%                             = case lists:keyfind(NewPartner#partner.partner_id, 1, RecruitList) of
%                                   {_PartnerId, _} ->
%                                       {RecruitList, NewPartner};
%                                   false ->
%                                       RecruitList1 = [{NewPartner#partner.partner_id, 0}|RecruitList],
%                                       {RecruitList1, NewPartner}
%                               end,
%                         NewPartnerMap = maps:put(NewPartner2#partner.id, NewPartner2, PartnerSt#partner_status.partners),
%                         NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, recruit_list = NewRecruitList},
%                         lib_partner_do:update_partner_list([NewPartner2]),
%                         lib_partner_do:update_player_partner(NewPartnerSt),
%                         {ok, NewPartnerSt, NewPartner2}
%                 end,
%             case lib_goods_util:transaction(F) of
%                 {ok, LastPartnerSt, LastPartner} ->
%                     lib_partner_do:set_partner_status(LastPartnerSt),
%                     %% 发送传闻
%                     send_tv_recruit(PS#player_status.figure#figure.name, [LastPartner], GiveType, 3),
%                     PartnerCollect = length(LastPartnerSt#partner_status.recruit_list),
%                     Data = #callback_partner_recruit{recruit_type=5, recruit_times=1, recruited_num=PartnerCollect},
%                     %% {ok, PS1} = lib_player_event:dispatch(PS, ?EVENT_PARTNER_RECRUIT, Data),
%                     {true, LastPartner, PS};
%                 Err ->
%                     ?ERR("give_partner error ~p", [Err]),
%                     {false, ?FAIL, PS}
%             end;
%         _ -> {false, ?ERRCODE(err412_cfg_not_exist), PS}
%     end;
% give_partner(PS, PartnerId, GiveType, _) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case data_partner:get_partner_by_id(PartnerId) of
%         PartnerCfg when is_record(PartnerCfg, base_partner) ->
%             F = fun() ->
%                         {ok, NewPartnerSt, Partner} = do_add_partner(PartnerSt, PartnerCfg),
%                         lib_partner_do:update_partner_list([Partner]),
%                         lib_partner_do:update_player_partner(NewPartnerSt),
%                         {ok, NewPartnerSt, Partner}
%                 end,
%             case lib_goods_util:transaction(F) of
%                 {ok, NewPartnerSt, NewPartner} ->
%                     lib_partner_do:set_partner_status(NewPartnerSt),
%                                                 % 发送传闻
%                     send_tv_recruit(PS#player_status.figure#figure.name, [NewPartner], GiveType, 3),
%                     PartnerCollect = length(NewPartnerSt#partner_status.recruit_list),
%                     Data = #callback_partner_recruit{recruit_type=5, recruit_times=1, recruited_num=PartnerCollect},
%                     %% {ok, PS1} = lib_player_event:dispatch(PS, ?EVENT_PARTNER_RECRUIT, Data),
%                     {true, NewPartner, PS};
%                 Err ->
%                     ?ERR("give_partner error ~p", [Err]),
%                     {false, ?FAIL, PS}
%             end;
%         _ ->
%             {false, ?ERRCODE(err412_cfg_not_exist), PS}
%     end.

% %% ------------------------------ 伙伴招募 -----------------------
% recruit(PS, TenRecruit, RecruitType) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:recruit(PS, PartnerSt, RecruitType, TenRecruit) of
%         {true, ObjectList, IsFree, RecuitCfg} ->
%             case do_recruit(PS, PartnerSt, RecuitCfg, IsFree, ObjectList, TenRecruit) of
%                 {true, NewPlayerStatus, PartnerList, RewardList} ->
%                     #base_partner_recruit{goods = GoodsL} = RecuitCfg,
%                     LogRecruitType
%                         = if
%                               RecruitType == ?RECRUIT_TYPE1,TenRecruit==0 -> 1;
%                               RecruitType == ?RECRUIT_TYPE1 -> 3;
%                               RecruitType == ?RECRUIT_TYPE2,TenRecruit==0 -> 2;
%                               RecruitType == ?RECRUIT_TYPE2 -> 4;
%                               true -> 1
%                           end,
%                     log_partner_recruit(PS#player_status.id, PartnerList, GoodsL, ObjectList, LogRecruitType),
%                     {true, NewPlayerStatus, PartnerList, RewardList};
%                 Other -> Other
%             end;
%         {false, Res} -> {false, Res, PS}
%     end.

% do_recruit(PS, PartnerSt, RecuitCfg, IsFree, ObjectList, TenRecruit) ->
%     #player_status{figure = #figure{name = PlayerName}} = PS,
%     GS = lib_goods_do:get_goods_status(),
%     #base_partner_recruit{recruit_type = RecruitType, goods = GoodsL, guaran_num = MaxTimes} = RecuitCfg,
%     {CurRecruits, _} = ?IF(RecruitType == ?RECRUIT_TYPE1, PartnerSt#partner_status.recruit_type1, PartnerSt#partner_status.recruit_type2),
%     {Result, RewardList}
%         = if
%               TenRecruit >= 1 ->
%                   GiveGoodsL = [{GoodsTypeId, Num*MaxTimes} || {Type, GoodsTypeId, Num} <- GoodsL, Type == ?TYPE_GOODS],
%                   Ret = ten_recruit(PartnerSt, RecuitCfg),
%                   {Ret, GiveGoodsL};
%               true ->
%                   GiveGoodsL = [{GoodsTypeId, Num} || {Type, GoodsTypeId, Num} <- GoodsL, Type == ?TYPE_GOODS],
%                   Ret = single_recruit(PartnerSt, RecuitCfg, CurRecruits, IsFree),
%                   {Ret, GiveGoodsL}
%           end,
%     Now = utime:longunixtime(),
%     case Result of
%         {true, NewPartnerSt, PartnerList} ->
%             F = fun() ->
%                         ok = lib_goods_dict:start_dict(),
%                         case lib_goods_util:cost_object_list(PS, ObjectList, recruit_partner, "", GS) of
%                             {true, NewGS, NewPS} ->
%                                 lib_partner_do:update_partner_list(PartnerList),
%                                 lib_partner_do:update_player_partner(NewPartnerSt),
%                                 {ok, NewStatus} = lib_goods_check:list_handle(fun lib_goods:give_goods/2, NewGS, RewardList),
%                                 {D, UpGoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%                                 NewGS1 = NewStatus#goods_status{dict = D},
%                                 {true, NewGS1, UpGoodsL, NewPS};
%                             {false, Res, NewGS, NewPS} -> {error, Res, NewGS, NewPS}
%                         end
%                 end,
%             case lib_goods_util:transaction(F) of
%                 {true, NewGoodsStatus, UpdateGoodsL, NewPlayerStatus} ->
%                     lib_goods_do:set_goods_status(NewGoodsStatus),
%                     lib_goods_api:notify_client(NewPlayerStatus, UpdateGoodsL),
%                     lib_partner_do:set_partner_status(NewPartnerSt),
%                     {true, NewPlayerStatus, PartnerList, RewardList};
%                 {error, Res, NewGoodsStatus, NewPlayerStatus} ->
%                     lib_goods_do:set_goods_status(NewGoodsStatus),
%                     {false, Res, NewPlayerStatus};
%                 {_Error, {error, {cell_num, not_enough}}} ->
%                                                 % 发邮件 送物品
%                     send_reward_when_no_cell(recruit, PS, {ObjectList, RewardList, PartnerList, NewPartnerSt});
%                 Err ->
%                     ?ERR("do_recruit Err ~p", [Err]),
%                     {false, ?FAIL, PS}
%             end;
%         {false, Res, _} ->
%             ?ERR_MSG(41209, Res),
%             {false, Res, PS}
%     end.

% single_recruit(PartnerSt, RecuitCfg, CurRecruits, IsFree) ->
%     IsFirstRecruit = mod_counter:get_count(PartnerSt#partner_status.pid, ?MOD_PARTNER, ?COUNTER_RECRUIT_FIRST),
%     NewCurRecruits = (CurRecruits + 1) rem RecuitCfg#base_partner_recruit.guaran_num,
%     Return = if
%                  NewCurRecruits == 0 ->
%                      do_recruit_core(guarantee, PartnerSt, RecuitCfg);
%                                                 % 第一次用钻石招募伙伴
%                  IsFirstRecruit == 0 andalso RecuitCfg#base_partner_recruit.recruit_type == ?RECRUIT_TYPE2 ->
%                      do_recruit_core(first_recruit, PartnerSt, RecuitCfg);
%                  true ->
%                      do_recruit_core(not_guarantee, PartnerSt, RecuitCfg)
%              end,
%     case Return of
%         {true, NewPartnerSt, Partner} when is_record(Partner, partner) ->
%             NewPartnerSt2 = lib_partner_util:update_partner_recruit_tms(NewPartnerSt, RecuitCfg, NewCurRecruits, IsFree),
%             {true, NewPartnerSt2, [Partner]};
%         {true, NewPartnerSt} ->
%             NewPartnerSt2 = lib_partner_util:update_partner_recruit_tms(NewPartnerSt, RecuitCfg, NewCurRecruits, IsFree),
%             {true, NewPartnerSt2, []};
%         {false, Res, _} ->
%             {false, Res, PartnerSt}
%     end.

%                                                 % 十连招募
% ten_recruit(PartnerSt, RecuitCfg) ->
%     MaxRecruit = RecuitCfg#base_partner_recruit.guaran_num,
%     ten_recruit_do(MaxRecruit, PartnerSt, RecuitCfg, []).

% ten_recruit_do(1, PartnerSt, RecuitCfg, List) ->
%     case do_recruit_core(guarantee, PartnerSt, RecuitCfg) of
%         {true, NewPartnerSt, Partner} when is_record(Partner, partner) ->
%             {true, NewPartnerSt, [Partner|List]};
%         {false, Res, _} ->
%             {false, Res, PartnerSt}
%     end;
% ten_recruit_do(MaxRecruit, PartnerSt, RecuitCfg, List) when MaxRecruit>1 ->
%     case do_recruit_core(not_guarantee, PartnerSt, RecuitCfg) of
%         {true, NewPartnerSt, Partner} when is_record(Partner, partner) ->
%             ten_recruit_do(MaxRecruit-1, NewPartnerSt, RecuitCfg, [Partner|List]);
%         {true, NewPartnerSt} ->
%             ten_recruit_do(MaxRecruit-1, NewPartnerSt, RecuitCfg, List);
%         {false, Res, _} ->
%             {false, Res, PartnerSt}
%     end.

% do_recruit_core(guarantee, PartnerSt, RecuitCfg) ->
%     #base_partner_recruit{recruit_type = RecruitType, guaran_quality = GuarantQuality} = RecuitCfg,
%     PartnerList = lib_partner_util:get_partner_by_guaran(?GUARANTEE, RecruitType),
%     case PartnerList == [] of
%         false ->
%             F = fun({_Id, Quality, _Weight}) -> lists:member(Quality, GuarantQuality) end,
%             PartnerList1 = lists:filter(F, PartnerList),
%             {PartnerId, _Q, _W} = util:find_ratio(PartnerList1, 3),
%                                                 %%% ?PRINT("guarantee ~p~n", [PartnerId]),
%             add_partner(PartnerSt, PartnerId);
%         true -> {false, ?ERRCODE(err412_recruit_err2), PartnerSt}
%     end;
% do_recruit_core(not_guarantee, PartnerSt, RecuitCfg) ->
%     #base_partner_recruit{recruit_type = RecruitType, pr = Pr} = RecuitCfg,
%     Num = urand:rand(1, 1000),
%     if
%         Pr >= Num ->
%             PartnerList = lib_partner_util:get_partner_by_guaran(?NOT_GUARANTEE, RecruitType),
%             case PartnerList == [] of
%                 false ->
%                     {PartnerId, _, _} = util:find_ratio(PartnerList, 3),
%                                                 %%% ?PRINT("not_guarantee ~p~n", [PartnerId]),
%                     add_partner(PartnerSt, PartnerId);
%                 true -> {false, ?ERRCODE(err412_recruit_err1), PartnerSt}
%             end;
%         true ->	{true, PartnerSt}
%     end;
% do_recruit_core(first_recruit, PartnerSt, _RecuitCfg) ->
%     PnList = data_partner:get_all_partner(),
%     Fun = fun({_PartnerId, Quality, RecruitList}) ->
%                   RecruitLen = length(RecruitList),
%                   Quality == 3 andalso RecruitLen > 0
%           end,
%     FilterList = lists:filter(Fun, PnList),
%     Nth = urand:rand(1, length(FilterList)),
%     case catch lists:nth(Nth, FilterList) of
%         {PartnerId1, _, _} ->
%             %% ?PRINT("first_recruit ~p~n", [PartnerId1]),
%             mod_counter:increment(PartnerSt#partner_status.pid, ?MOD_PARTNER, ?COUNTER_RECRUIT_FIRST),
%             add_partner(PartnerSt, PartnerId1);
%         Err ->
%             ?ERR("first_recruit err: ~p~n", [Err])
%     end.


% add_partner(PartnerSt, PartnerId) ->
%     case lib_partner_check:add_partner(PartnerId) of
%         {true, PartnerCfg} ->
%             F = fun() -> do_add_partner(PartnerSt, PartnerCfg) end,
%             case lib_goods_util:transaction(F) of
%                 {ok, NewPartnerSt, Partner} ->
%                     {true, NewPartnerSt, Partner};
%                 Err ->
%                     ?ERR("add_partner error ~p", [Err]),
%                     {false, ?FAIL, PartnerSt}
%             end;
%         {false, Res} ->
%             {false, Res, PartnerSt}
%     end.

% do_add_partner(PartnerSt, PartnerCfg) ->
%     CreateId = mod_id_create:get_new_id(?PARTNER_ID_CREATE),
%     Partner = lib_partner_util:make_base_record(PartnerCfg, PartnerSt#partner_status.pid, CreateId),
%                                                 %lib_partner_util:add_partnet(Partner),
%     WashCfg = data_partner:get_wash_cfg(Partner#partner.quality),
%     NewPartner1 = partner_wash_core(Partner, WashCfg),
%                                                 % 新伙伴加入玩家内存中
%     RecruitList = PartnerSt#partner_status.recruit_list,
%     {NewRecruitList, NewPartner2} = case lists:keyfind(NewPartner1#partner.partner_id, 1, RecruitList) of
%                                         {PartnerId, 1} ->
%                                             PartnerTemp = update_partner_weapon(NewPartner1, PartnerId),
%                                             {RecruitList, PartnerTemp};
%                                         {_PartnerId, 0} ->
%                                             {RecruitList, NewPartner1};
%                                         false ->
%                                             RecruitList1 = [{NewPartner1#partner.partner_id, 0}|RecruitList],
%                                             {RecruitList1, NewPartner1}
%                                     end,
%     NewPartnerMap = maps:put(NewPartner2#partner.id, NewPartner2, PartnerSt#partner_status.partners),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, recruit_list = NewRecruitList},
%     {ok, NewPartnerSt, NewPartner2}.

%                                                 % 伙伴招募和召回时，进行专属武器属性计算
% update_partner_weapon(Partner, _PartnerId) ->
%     ValueList = [
%                  {equip_weapon, ?PARTNER_EQUIP_ACTIVE},
%                  {attribute},
%                  {combat_power}
%                 ],
%     lib_partner_util:set_partner_value(Partner, ValueList).

% %% ------------------------------ 伙伴召回 -----------------------

% partner_callback(PS, PartnerId) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:partner_callback(PartnerSt, PartnerId) of
%         {true, PartnerCfg, CallBackCfg} ->
%             partner_callback_do(PS, PartnerSt, PartnerCfg, CallBackCfg);
%         {false, Res} ->
%             {false, Res, PS}
%     end.

% partner_callback_do(PS, PartnerSt, PartnerCfg, CallBackCfg) ->
%     GS = lib_goods_do:get_goods_status(),
%     GoodsCost = CallBackCfg#base_partner_callback.goods,
%     F = fun() ->
%                 ok = lib_goods_dict:start_dict(),
%                 case callback_consume(PS, GS, GoodsCost) of
%                     {ok, NewGS, UpdateGoodsL, NewPS} ->
%                         {ok, NewPartnerSt, Partner} = do_add_partner(PartnerSt, PartnerCfg),
%                         lib_partner_do:update_partner_list([Partner]),
%                         {true, NewGS, UpdateGoodsL, NewPS, NewPartnerSt, Partner};
%                     Err -> Err
%                 end
%         end,
%     case lib_goods_util:transaction(F) of
%         {true, NewGoodsStatus, GoodsL, NewPlayerStatus, NewPartnerSt, NewPartner} ->
%             log_partner_recruit(PS#player_status.id, [NewPartner], [], GoodsCost, 5),
%             lib_goods_do:set_goods_status(NewGoodsStatus),
%             lib_goods_api:notify_client(NewPlayerStatus, GoodsL),
%             lib_partner_do:set_partner_status(NewPartnerSt),
%             #partner{id=Id, partner_id=PartnerId, lv=Lv, state=State, pos=Pos, combat_power=CombatPower, prodigy=Prodigy, equip = #partner_equip{weapon_st = WeaponSt}} = NewPartner,
%             Rsp = [1, Id, PartnerId, Lv, State, Pos, round(CombatPower), Prodigy, WeaponSt],
%             {ok, BinData} = pt_412:write(41226, Rsp),
%             lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, BinData),
%             {true, NewPlayerStatus};
%         {error, Res, NewGoodsStatus, NewPlayerStatus} ->
%             lib_goods_do:set_goods_status(NewGoodsStatus),
%             {false, Res, NewPlayerStatus};
%         Error ->
%             ?ERR("partner_callback_do wash error:~p", [Error]),
%             {false, ?FAIL, PS}
%     end.

% callback_consume(PS, GS, CostGoods) ->
%     case lib_goods_util:cost_object_list(PS, CostGoods, partner_callback, "", GS) of
%         {true, NewGS, NewPS} ->
%             {D, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS#goods_status.dict),
%             NewGoodsStatus = NewGS#goods_status{dict = D},
%             {ok, NewGoodsStatus, GoodsL, NewPS};
%         {false, Res, NewGS, NewPS} -> {error, Res, NewGS, NewPS}
%     end.

% %% ------------------------------ 洗髓 -----------------------
% wash_partner(PS, Id) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:wash_partner(PS, PartnerSt, Id) of
%         {true, Partner, WashCfg} ->
%             case do_wash_partner(PS, Partner, WashCfg) of
%                 {true, NewPS, NewPartner} ->
%                                                 %%% ?PRINT("wash_partner : ~p~n", [NewPartner]),
%                     NewPartnerSt = PartnerSt#partner_status{wash_partner = NewPartner},
%                     lib_partner_do:set_partner_status(NewPartnerSt),
%                     {true, Partner, NewPartner, NewPS};
%                 _Error -> {false, ?FAIL, PS}
%             end;
%         {false, Res} -> {false, Res, PS}
%     end.

% do_wash_partner(PS, Partner, WashCfg) ->
%     case wash_consume(PS, WashCfg#base_partner_wash.goods) of
%         {true, NewPS} ->
%             WashPartner = partner_wash_core(Partner, WashCfg),
%             {true, NewPS, WashPartner};
%         {false, Res, NewPS} ->
%             {false, Res, NewPS};
%         Error ->
%             ?ERR("wash_consume  error:~p", [Error]),
%             {false, ?FAIL, PS}
%     end.

% partner_wash_core(Partner, WashCfg) ->
%                                                 % 设置洗髓获得的属性
%     Partner1 = set_wash_value(Partner, WashCfg),
%     ValueList = [
%                  {attribute},
%                  {combat_power}
%                 ],
%     lib_partner_util:set_partner_value(Partner1, ValueList).


% set_wash_value(Partner, WashCfg) ->
%     PartnerId = Partner#partner.partner_id,
%     ParCareer = Partner#partner.career,
%                                                 % 获取四围属性的潜能品质 [{体质, 品质}]
%     QualityList = get_attr_quality(WashCfg),
%                                                 % 获取四围属性的上限值 [{体质, 上限值}]
%     UpperList = get_attr_upper(PartnerId, Partner#partner.quality, QualityList, []),
%                                                 % 获取四围属性当前值 [{AttrType, CurVal, UpperVal}]
%     AttrList = get_attr_list(UpperList, WashCfg#base_partner_wash.random_attr, []),
%     TotalAttr = lib_partner_util:calc_partner_total_attr(AttrList, Partner, QualityList),
%                                                 % 获取洗髓的普通技能 [{技能id, 技能等级, 技能位置}]
%     SkList = get_skill_list(ParCareer, WashCfg),
%                                                 %%% ?PRINT("get_skill_list SkList: ~p~n", [SkList]),
%     NewPartner = Partner#partner{apti_take = [], skill_learn = []},
%     {NewSkList, NewSkCdList} = wash_skill_list(NewPartner, SkList),
%                                                 %%% ?PRINT("get_skill_list New SkList: ~p~n", [NewSkList]),
%     ValueList = [
%                  {attr_quality, QualityList},
%                  {prodigy, WashCfg, AttrList, NewSkList},
%                  {total_attr, TotalAttr},
%                  {com_skill_list, NewSkList, NewSkCdList}
%                 ],
%     lib_partner_util:set_partner_value(NewPartner, ValueList).

%                                                 % 获取四围属性品质
% get_attr_quality(WashCfg) ->
%     _WashAttr = WashCfg#base_partner_wash.wash_attr,
%     %% {Quality1, _} = util:find_ratio(WashAttr, 2),
%     %% {Quality2, _} = util:find_ratio(WashAttr, 2),
%     %% {Quality3, _} = util:find_ratio(WashAttr, 2),
%     %% {Quality4, _} = util:find_ratio(WashAttr, 2),
%     %% [{?PHYSIQUE, Quality1}, {?AGILE, Quality2}, {?FORZA, Quality3}, {?DEXTEROUS, Quality4}].
%     [].

% %% 获取四围属性上限
% get_attr_upper(_PartnerId, _PartnerQuality, [], UpperList) ->
%     UpperList;
% get_attr_upper(PartnerId, PartnerQuality, [{AttrType, Quality}|T], UpperList) ->
%     QualityCoef = lib_partner_util:get_quality_coef(PartnerQuality),
%     AttrCoef = lib_partner_util:get_attr_coef(Quality),
%     #base_partner{born_attr = _BornAttr, grow_up = GrowUp} = data_partner:get_partner_by_id(PartnerId),
%     TotalGUp = lists:sum(GrowUp),
%     case AttrType of
%         %% ?PHYSIQUE ->
%         %%     PerfectVal = lists:nth(2, BornAttr),
%         %%     Proportion = lists:nth(1, GrowUp);
%         %% ?AGILE ->
%         %%     PerfectVal = lists:nth(3, BornAttr),
%         %%     Proportion = lists:nth(2, GrowUp);
%         %% ?FORZA ->
%         %%     PerfectVal = lists:nth(4, BornAttr),
%         %%     Proportion = lists:nth(3, GrowUp);
%         %% ?DEXTEROUS ->
%         %%     PerfectVal = lists:nth(5, BornAttr),
%         %%     Proportion = lists:nth(4, GrowUp);
%         _ ->
%             PerfectVal = 0, Proportion = 0
%     end,
%     UpperVal = PerfectVal - QualityCoef*AttrCoef*10*Proportion/TotalGUp,
%     get_attr_upper(PartnerId, PartnerQuality, T, [{AttrType, UpperVal}|UpperList]).

%                                                 % 获取四围当前值
% get_attr_list([], _RandomAttr, AttrList) ->
%     AttrList;
% get_attr_list([{AttrType, UpperVal}|T], RandomAttr, AttrList) ->
%     {_Weight, Low, Upper} = util:find_ratio(RandomAttr, 1),
%     Proportion = urand:rand(Low, Upper),
%     CurVal = UpperVal * Proportion / 1000,
%     get_attr_list(T, RandomAttr, [{AttrType, CurVal, UpperVal}|AttrList]).

%                                                 % 获取伙伴技能列表
% get_skill_list(ParCareer, WashCfg) ->
%                                                 % 获取技能数量
%     {Num, _Weight} = util:find_ratio(WashCfg#base_partner_wash.comm_skill, 2),
%                                                 % 获取技能品质
%     SkQualityList = get_sk_quality(Num, WashCfg#base_partner_wash.sk_quality, []),
%                                                 % 获取技能列表 [{技能id, 技能等级, 位置}]
%     get_skill(ParCareer, SkQualityList, []).

% get_sk_quality(0, _SkQuality, SkQualityList) ->
%     F = fun({Quality1, _}, {Quality2, _}) -> Quality1 >= Quality2 end,
%     lists:sort(F, SkQualityList);
% get_sk_quality(Num, SkQuality, SkQualityList) when Num>0 ->
%     {Quality, _Weight} = util:find_ratio(SkQuality, 2),
%     case lists:keyfind(Quality, 1, SkQualityList) of
%         false ->
%             get_sk_quality(Num-1, SkQuality, [{Quality, 1}|SkQualityList]);
%         {Quality, QualityNum} ->
%             NewSkQualityList = lists:keyreplace(Quality, 1, SkQualityList, {Quality, QualityNum+1}),
%             get_sk_quality(Num-1, SkQuality, NewSkQualityList)
%     end.


% get_skill(_ParCareer, [], SkillList) ->
%     F = fun({SkId, Lv}, {List, Pos}) -> {[{SkId, Lv, Pos}|List], Pos+1} end,
%     {SkList, _} = lists:foldl(F, {[], 1}, SkillList),
%     SkList;
% get_skill(ParCareer, [{Quality, Num}|T], SkillList) ->
%                                                 % 获取无五行属性的技能列表 {skillid, power, weight}
%     NoneSkList = data_partner:get_skill_by_quality(Quality, ?NONE_ELEMENT),
%                                                 % 获取伙伴相同五行属性的技能列表
%     CareerSkList = data_partner:get_skill_by_quality(Quality, ParCareer),
%     SkList = NoneSkList ++ CareerSkList,
%     Fun = fun(_I, {FilterList, List}) when length(List)>0 ->
%                   {SkId, _CombatPower, _Weight} = util:find_ratio(List, 3),
%                   NewList = lists:keydelete(SkId, 1, List),
%                   {ok, {[{SkId, 1}|FilterList] ,NewList}};
%              (_I, {FilterList, List}) -> {ok, {FilterList, List}}
%           end,
%     {ok, {ReturnList, _}} = util:for(1, Num, Fun, {[], SkList}),
%     get_skill(ParCareer, T, ReturnList++SkillList).


% wash_consume(PS, WashCost) ->
%     lib_goods_api:cost_object_list(PS, WashCost, partner_wash, "").


% %% ------------------------------ 洗髓 保留 替换-----------------------
%                                                 % 洗髓保留
% wash_keep(PS) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     WashPartner = PartnerSt#partner_status.wash_partner,
%     case WashPartner of
%         #partner{id = Id} ->
%             case maps:get(Id, PartnerSt#partner_status.partners, none) of
%                 #partner{} = OldPartner ->
%                     log_partner_wash(PS#player_status.id, OldPartner, WashPartner, [], 0);
%                 _ -> skip
%             end;
%         _ ->skip
%     end,
%     NewPartnerSt = PartnerSt#partner_status{wash_partner = undefined},
%     lib_partner_do:set_partner_status(NewPartnerSt),
%     PS.

%                                                 % 洗髓替换
% wash_replace(PS) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:wash_replace(PartnerSt) of
%         {true, OldPartner, WashPartner, AwardList} ->
%             do_wash_replace(PS, PartnerSt, OldPartner, WashPartner, AwardList);
%         {false, Res} -> {false, Res, PS}
%     end.

% do_wash_replace(PS, PartnerSt, OldPartner, WashPartner, AwardList) ->
%     #player_status{sid = Sid} = PS,
%     GS = lib_goods_do:get_goods_status(),
%     F = fun() ->
%                 ok = lib_goods_dict:start_dict(),
%                 lib_partner_do:update_partner_list([WashPartner]),
%                 Embattle1 = update_embattle(PS#player_status.id, PartnerSt#partner_status.embattle, WashPartner),
%                 {ok, NewStatus} = lib_goods_check:list_handle(fun lib_goods:give_goods/2, GS, AwardList),
%                 {D, UpGoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%                 send_goods_notice_msg(Sid, AwardList),
%                 NewGS1 = NewStatus#goods_status{dict = D},
%                 {ok, NewGS1, UpGoodsL, Embattle1}
%         end,
%     case lib_goods_util:transaction(F) of
%         {ok, NewGoodsStatus, UpdateGoodsL, NewEmbattle} ->
%                                                 %%% ?PRINT("do_wash_replace NewEmbattle ~p~n", [NewEmbattle]),
%             lib_goods_do:set_goods_status(NewGoodsStatus),
%             lib_goods_api:notify_client(PS, UpdateGoodsL),
%             NewPartnerMap = maps:put(WashPartner#partner.id, WashPartner, PartnerSt#partner_status.partners),
%             NewPartnerSt = PartnerSt#partner_status{embattle = NewEmbattle, partners = NewPartnerMap, wash_partner = undefined},
%             lib_partner_do:set_partner_status(NewPartnerSt),
%             log_partner_wash(PS#player_status.id, OldPartner, WashPartner, AwardList, 1),
%             CountPS = update_ps_attr(PS, NewPartnerSt, WashPartner#partner.state, 1),
%             mod_scene_agent:update(CountPS, [{battle_attr, CountPS#player_status.battle_attr}]),
%             {true, WashPartner, CountPS};
%         {_Error, {error, {cell_num, not_enough}}} ->
%                                                 % 发邮件 送物品
%             send_reward_when_no_cell(wash_replace, PS, {AwardList, WashPartner, PartnerSt});
%         Err ->
%                                                 %%% ?PRINT("do_wash_replace Err: ~p~n", [Err]),
%             ?ERR("wash_replace error ~p", [Err]),
%             {false, ?FAIL, PS}
%     end.

% %% ------------------------------ 升级 -----------------------

% partner_add_exp(PS, Id, Exp, GoodsId, Num) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     #player_status{sid = Sid} = PS,
%     case maps:find(Id, PartnerSt#partner_status.partners) of
%         error -> {false, PS};
%         {ok, Partner} ->
%             case add_exp(PS, PartnerSt, Partner, Exp) of
%                 {true, NewPS, NewPartnerSt, NewPartner} ->
%                     case lib_goods_api:cost_object_list(NewPS, [{?TYPE_GOODS, GoodsId, Num}], add_exp, "") of
%                         {true, NewPS1} ->
%                             case NewPartner#partner.lv > Partner#partner.lv of
%                                 true ->
%                                     log_partner_add_exp(PS#player_status.id, Partner, NewPartner, GoodsId, Num);
%                                 false -> skip
%                             end,
%                             lib_partner_do:set_partner_status(NewPartnerSt),
%                             send_upgrade_msg(Sid, Partner, NewPartner, Exp),
%                             send_attr_list(Sid, Partner),
%                             {true, NewPS1};
%                         {false, _Res, NewPS1} ->
%                             {ok, NewPS1}
%                     end;
%                 {false, Res, PS} ->
%                     {ok, BinData} = pt_412:write(41212, [Res, 0, 0, 0, 0]),
%                     lib_server_send:send_to_sid(Sid, BinData),
%                     {false, PS}
%             end
%     end.

% add_exp(PS, PartnerSt, Partner, Exp) ->
%     case lib_partner_check:add_exp(PS, Partner, Exp) of
%         {_BreakSt, _NeedUp, _NewLv, _SumExp} = Value ->
%                                                 %%% ?PRINT("add_exp Value ~p~n", [Value]),
%             do_add_exp(PS, PartnerSt, Partner, Value);
%         {false, Res} ->
%             {false, Res, PS}
%     end.

% do_add_exp(PS, PartnerSt, Partner, {BreakSt, NeedUp, NewLv, SumExp}) ->
%     Id = Partner#partner.id,
%     Key = "partner_add_exp" ++ "_" ++ integer_to_list(Id),
%     case NeedUp of
%         false ->
%                                                 % 10次写一次数据库
%             case get(Key) of
%                 undefined -> put(Key, 1);
%                 Times when Times < 10 ->
%                     put(Key, Times+1);
%                 _ ->
%                     db:execute(io_lib:format(<<"update `partner` set `exp`=~p where `id`=~p ">>, [SumExp, Id])),
%                     put(Key, 0)
%             end,
%             NewPartner = Partner#partner{exp = SumExp},
%             NewPartnerMap = maps:put(NewPartner#partner.id, NewPartner, PartnerSt#partner_status.partners),
%             NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap},
%             {true, PS, NewPartnerSt, NewPartner};
%         true ->
%             NewPartner = Partner#partner{break_st = BreakSt, lv =NewLv, exp = SumExp},
%             upgrade_partner(PS, PartnerSt, Id, NewPartner)
%     end.

% upgrade_partner(PS, PartnerSt, Id, Partner) ->
%     {ok, OldPartner} = maps:find(Id, PartnerSt#partner_status.partners),
%     OldLv = OldPartner#partner.lv,
%     #partner{break_st = BreakSt, lv = NewLv, exp = LeftExp, grow_up = GrowUp} = Partner,
%                                                 % 四围由于升级所带来的四围属性值
%     AttrAdd = lib_partner_util:get_upgrade_attr(GrowUp, NewLv - OldLv),
%     TotalAttr = lib_partner_util:keyadd(Partner#partner.total_attr, AttrAdd),
%     ValueList = [
%                  {total_attr, TotalAttr},
%                  {attribute}
%                 ],
%     NewPartner = lib_partner_util:set_partner_value(Partner, ValueList),
%                                                 %%% ?PRINT("upgrade_partner TotalAttr ~p~n", [NewPartner#partner.total_attr]),
%     F = fun() ->
%                 db:execute(io_lib:format(<<"update `partner` set `break_st`=~p,`lv`=~p,`exp`=~p where `id`=~p ">>, [BreakSt, NewLv, LeftExp, Id])),
%                 lib_partner_do:update_partner_attr(NewPartner),
%                 Embattle1 = update_embattle(PS#player_status.id, PartnerSt#partner_status.embattle, NewPartner),
%                 {ok, Embattle1}
%         end,
%     case lib_goods_util:transaction(F) of
%         {ok, NewEmbattle} ->
%                                                 %%% ?PRINT("upgrade_partner NewEmbattle ~p~n", [NewEmbattle]),
%             NewPartnerMap = maps:put(NewPartner#partner.id, NewPartner, PartnerSt#partner_status.partners),
%             NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, embattle = NewEmbattle},
%             lib_task_api:partner_lv_up(PS),
%             {true, PS, NewPartnerSt, NewPartner};
%         Err ->
%             ?ERR("upgrade_partner error ~p", [Err]),
%             {false, ?FAIL, PS}
%     end.

% %% ------------------------------ 突破 -----------------------

% partner_break(PS, Id) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:partner_break(PartnerSt, Id) of
%         {true, Partner, BreakCfg, UnBreakL} ->
%             do_partner_break(PS, PartnerSt, Partner, BreakCfg, UnBreakL);
%         {false, Res} -> {false, Res, PS}
%     end.

% do_partner_break(PS, PartnerSt, Partner, BreakCfg, UnBreakL) ->
%     #partner{lv = Lv, grow_up = GrowUp, attr_quality = AttrQuality} = Partner,
%     #base_partner_break{lv = BreakLv, attr_val = AttrAdd, loss_coef = LossCoef} = BreakCfg,
%                                                 % 更新
%     BreakAttr = lib_partner_util:get_break_attr_upper(AttrAdd, GrowUp, AttrQuality, LossCoef),
%                                                 %%% ?PRINT("do_partner_break BreakAttr ~p~n", [BreakAttr]),
%     TotalAttr = lib_partner_util:keyadd(Partner#partner.total_attr, BreakAttr),
%     NewBreakList = Partner#partner.break ++ [BreakLv],
%     NewBreakSt = case (UnBreakL -- [BreakLv]) of
%                      [] -> 0;
%                      NewUnBreakL when is_list(NewUnBreakL) -> ?IF(Lv>=lists:min(NewUnBreakL), 1, 0);
%                      _ -> 0
%                  end,
%     ValueList = [
%                  {break_state, NewBreakList, NewBreakSt},
%                  {total_attr, TotalAttr}
%                 ],
%     NewPartner = lib_partner_util:set_partner_value(Partner, ValueList),
%     lib_partner_do:update_partner_break(NewBreakSt, NewBreakList, NewPartner),
%     NewPartnerMap = maps:put(NewPartner#partner.id, NewPartner, PartnerSt#partner_status.partners),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap},
%     lib_partner_do:set_partner_status(NewPartnerSt),
%     log_partner_break(PS#player_status.id, Partner, NewPartner),
%     {true, NewPartner, PS}.

% %% ------------------------------ 资质提升 -----------------------

% partner_promote(PS, [PartnerId, Type, GoodsList]) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:get_promote_times(PS, PartnerSt, PartnerId, Type, GoodsList) of
%                                                 % {伙伴, 提升配置, 可以提升的次数, 单次提升消耗物品和金钱}
%         {true, Partner, PromoteCfg, Times, SingleCost} ->
%             case partner_promote_do(PS, PartnerSt, Type, Partner, PromoteCfg, Times, SingleCost) of
%                 {true, UpdateAttr, NewPartnerSt, NewPS} ->
%                     lib_partner_do:set_partner_status(NewPartnerSt),
%                     {true, UpdateAttr, NewPS};
%                 {false, Res, NewPS} -> {false, Res, NewPS}
%             end;
%         {false, Res} ->
%             {false, Res, PS}
%     end.

% partner_promote_do(PS, PartnerSt, Type, Partner, PromoteCfg, Times, PromoteCost) ->
%     {PromoteTimes, AddList} = calc_promote_attr_add(Type, Partner, PromoteCfg, Times, 1, []),
%                                                 %%% ?PRINT("partner_promote_do ~p~n", [{PromoteTimes, AddList}]),
%                                                 % 计算物品具体消耗
%     Fun = fun({Type1, GTypeID, Num}, List) -> [{Type1, GTypeID, Num*PromoteTimes}|List] end,
%     ObjectList = lists:foldl(Fun, [], PromoteCost),
%     NewPartner = partner_promote_core(Type, Partner, AddList, ObjectList),
%     case lib_goods_api:cost_object_list(PS, ObjectList, partner_promote, "") of
%         {true, NewPS} ->
%             %% lib_player_event:async_dispatch(PS#player_status.id, ?EVENT_PARTNER_PROMOTE_ATTR, PromoteTimes),
%             lib_partner_do:update_partner_promote(NewPartner),
%             log_partner_promote(PS#player_status.id, Type, Partner, NewPartner, ObjectList),
%             partner_promote_core1(NewPS, PartnerSt, Partner, NewPartner, Type, AddList);
%         {false, Res, NewPS} -> {false, Res, NewPS}
%     end.

% partner_promote_core(Type, Partner, AddList, ObjectList) ->
%     TotalAdd = lists:sum(AddList),
%     TotalAttr = Partner#partner.total_attr,
%     {Type, CurVal, UpperVal} = lists:keyfind(Type, 1, TotalAttr),
%     NewTotalAttr = lists:keyreplace(Type, 1, TotalAttr, {Type, CurVal+TotalAdd, UpperVal}),
%                                                 %%% ?PRINT("partner_promote_core ~p~n", [NewTotalAttr]),
%     ValueList = [
%                  {apti_take, ObjectList},
%                  {total_attr, NewTotalAttr},
%                  {attribute},
%                  {combat_power}
%                 ],
%     lib_partner_util:set_partner_value(Partner, ValueList).

% partner_promote_core1(PS, PartnerSt, Partner, NewPartner, Type, AddList) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     NewPartnerMap = maps:put(NewPartner#partner.id, NewPartner, PartnerMap),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap},
%                                                 % 更新上阵伙伴给玩家带来的属性加成
%     {_, OldLv} = lib_partner_util:get_assist_skill(Partner),
%     {_, NewLv} = lib_partner_util:get_assist_skill(NewPartner),
%                                                 % 将伙伴新的属性, 提升的资质列表, 资质丹剩余数量告诉客户端
%     send_promote_msg(PS, NewPartner, Type, AddList),
%     send_attr_list(PS#player_status.sid, NewPartner),
%     Update = ?IF(OldLv == NewLv, 0, 1),
%     CountPS = update_ps_attr(PS, NewPartnerSt, NewPartner#partner.state, 1),
%     {true, Update, NewPartnerSt, CountPS}.

%                                                 % 计算伙伴能提升的具体次数和增加值列表
% calc_promote_attr_add(Type, Partner, PromoteCfg, Times, CurTimes, AddList) ->
%     Total = lists:sum(AddList),
%     PromoteCond = PromoteCfg#base_partner_promote.promote,
%     {Lower, Upper, _Weight} = util:find_ratio(PromoteCond, 3),
%     AttrAdd = urand:rand(Lower, Upper),
%     TotalAttr = Partner#partner.total_attr,
%     {_, CurVal, UpperVal} = lists:keyfind(Type, 1, TotalAttr),
%     case (CurVal + AttrAdd + Total) < UpperVal of
%         true when CurTimes < Times ->
%             calc_promote_attr_add(Type, Partner, PromoteCfg, Times, CurTimes+1, [AttrAdd|AddList]);
%         true when CurTimes == Times ->
%             {Times,  [AttrAdd|AddList]};
%         false ->
%             {CurTimes,  [AttrAdd|AddList]}
%     end.

% %% ------------------------技能 学习 替换-----------------------------

%                                                 % 学习技能
% partner_learn_skill(PS, [Id, GoodId]) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:partner_learn_skill(PS, PartnerSt, Id, GoodId) of
%         {true, Partner, SkillCfg, GoodsInfo, Pos} ->
%             case learn_skill_do(PS, PartnerSt, Partner, SkillCfg, Pos, GoodsInfo) of
%                 {true, UpdateAttr, NewPartner, NewPS} -> {true, UpdateAttr, Pos, NewPartner, NewPS};
%                 Err -> Err
%             end;
%         {false, Res} -> {false, Res, PS}
%     end.

% learn_skill_do(PS, PartnerSt, Partner, SkillCfg, Pos, GoodsInfo) ->
%     NewPartner = learn_skill_core(Partner, SkillCfg, Pos),
%                                                 %%% ?PRINT("learn_skill_do new  ~p~n", [NewPartner#partner.skill]),
%     case lib_goods_api:cost_object_list(PS, [{?TYPE_GOODS, GoodsInfo#goods.goods_id, 1}], partner_learn_sk, "") of
%         {true, NewPS} ->
%             lib_partner_do:update_partner_learn_sk(NewPartner, Pos),
%             log_partner_learn_sk(PS#player_status.id, NewPartner, GoodsInfo, SkillCfg),
%             learn_skill_core1(NewPS, PartnerSt, Partner, NewPartner);
%         {false, Res, NewPS} -> {false, Res, NewPS}
%     end.

% learn_skill_core(Partner, #base_partner_sk{skill_id = AddSkId}, Pos) ->
%     #partner{skill = PartnerSk} = Partner,
%     LearnSk = {AddSkId, 1, Pos},
%     NewSkList = lists:keystore(Pos, 3, PartnerSk#partner_skill.skill_list, LearnSk),
%     NewCdList = lists:keystore(AddSkId, 1, PartnerSk#partner_skill.skill_cd, {AddSkId, 0}),
%     ValueList = [
%                  {skill_learn, AddSkId},
%                  {com_skill_list, NewSkList, NewCdList},
%                  {attribute},
%                  {combat_power}
%                 ],
%     lib_partner_util:set_partner_value(Partner, ValueList).

% learn_skill_core1(PS, PartnerSt, Partner, NewPartner) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     NewPartnerMap = maps:put(NewPartner#partner.id, NewPartner, PartnerMap),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap},
%     lib_partner_do:set_partner_status(NewPartnerSt),
%                                                 % 更新上阵伙伴给玩家带来的属性加成
%     {_, OldLv} = lib_partner_util:get_assist_skill(Partner),
%     {_, NewLv} = lib_partner_util:get_assist_skill(NewPartner),
%                                                 % 将伙伴新的信息发给客户端
%     Update = ?IF(OldLv == NewLv, 0, 1),
%     NewPS = update_ps_attr(PS, NewPartnerSt, NewPartner#partner.state, 1),
%     {true, Update, NewPartner, NewPS}.

%                                                 % 技能替换
% partner_skill_replace(PS, [Id, GoodId, Pos]) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:partner_skill_replace(PS, PartnerSt, Id, GoodId, Pos) of
%         {true, Partner, SkillCfg, GoodsInfo, RepalceId} ->
%             case replace_skill_do(PS, PartnerSt, Partner, SkillCfg, RepalceId, Pos, GoodsInfo) of
%                 {true, UpdateAttr, NewPartner, NewPS} -> {true, UpdateAttr, Pos, NewPartner, NewPS};
%                 Err -> Err
%             end;
%         {false, Res} -> {false, Res, PS}
%     end.

% replace_skill_do(PS, PartnerSt, Partner, SkillCfg, RepalceId, Pos, GoodsInfo) ->
%     NewPartner = replace_skill_core(Partner, SkillCfg, RepalceId, Pos),
%     case lib_goods_api:cost_object_list(PS, [{?TYPE_GOODS, GoodsInfo#goods.goods_id, 1}], partner_learn_sk, "") of
%         {true, NewPS} ->
%             lib_partner_do:update_partner_learn_sk(NewPartner, Pos),
%             log_partner_learn_sk(PS#player_status.id, NewPartner, GoodsInfo, SkillCfg),
%             learn_skill_core1(NewPS, PartnerSt, Partner, NewPartner);
%         {false, Res, NewPS} -> {false, Res, NewPS}
%     end.

% replace_skill_core(Partner, #base_partner_sk{skill_id = AddSkId}, RepalceId, Pos) ->
%     #partner{skill = PartnerSk} = Partner,
%     ReplaceSk = {AddSkId, 1, Pos},
%     NewSkList = lists:keystore(Pos, 3, PartnerSk#partner_skill.skill_list, ReplaceSk),
%     NewCdList = lists:keystore(AddSkId, 1, PartnerSk#partner_skill.skill_cd, {AddSkId, 0}),
%     ValueList = [
%                  {skill_replace, AddSkId, RepalceId},
%                  {com_skill_list, NewSkList, NewCdList},
%                  {attribute},
%                  {combat_power}
%                 ],
%     lib_partner_util:set_partner_value(Partner, ValueList).

% %% ---------------------伙伴 上阵 下阵--------------------------------

% partner_battle(PS, Id) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:partner_battle(PS, PartnerSt, Id) of
%         {true, Partner, Pos} ->
%             partner_battle_do(PS, PartnerSt, Partner, Pos);
%         {false, Res} -> {false, Res, PS}
%     end.

% partner_battle_do(PS, PartnerSt, Partner, Pos) ->
%     EmBattle = PartnerSt#partner_status.embattle,
%     NewPartner = Partner#partner{pos = Pos, state = ?STATE_BATTLE},
%     NewPartnerMap = maps:put(NewPartner#partner.id, NewPartner, PartnerSt#partner_status.partners),
%                                                 % 更新布阵
%     NewEmbattle = insert_ps_embattle(EmBattle, NewPartner, ?BATTLE_SIGN_PARTNER),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, embattle = NewEmbattle},
%     NewPartnerSt1 = sync_battle_embattle_pos(NewPartnerSt, 1),
%     lib_partner_do:update_partner_battle_sleep(NewPartner),
%     lib_partner_do:set_partner_status(NewPartnerSt1),
%     QualityList = lib_partner_util:get_battle_partner_quality_list(NewPartnerSt, 4),
%     %% {ok, PS1} = lib_player_event:dispatch(PS, ?EVENT_PARTNER_BATTLE, QualityList),
%     CountPS = update_ps_attr(PS, NewPartnerSt, ?STATE_BATTLE, 1),
%     {true, Pos, CountPS}.

% partner_sleep(PS, Id) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:partner_sleep(PS, PartnerSt, Id) of
%         {true, Partner, Pos} ->
%             partner_sleep_do(PS, PartnerSt, Partner, Pos);
%         {false, Res} -> {false, Res, PS}
%     end.

% partner_sleep_do(PS, PartnerSt, Partner, Pos) ->
%     EmBattle = PartnerSt#partner_status.embattle,
%     NewPartner = Partner#partner{pos = 0, state = ?STATE_SLEEP},
%     NewPartnerMap = maps:put(NewPartner#partner.id, NewPartner, PartnerSt#partner_status.partners),
%                                                 % 更新布阵
%     NewEmbattle = lists:keydelete({?BATTLE_SIGN_PARTNER, Partner#partner.id}, #rec_embattle.key, EmBattle),
%                                                 %%% ?PRINT("partner_sleep_do NewEmbattle ~p~n", [NewEmbattle]),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, embattle = NewEmbattle},
%                                                 % 更新玩家属性
%     lib_partner_do:update_partner_embattle(NewPartnerSt),
%     lib_partner_do:update_partner_battle_sleep(NewPartner),
%     lib_partner_do:set_partner_status(NewPartnerSt),
%     CountPS = update_ps_attr(PS, NewPartnerSt, ?STATE_BATTLE, 1),
%     {true, Pos, CountPS}.

% change_embattle(PS, [SrcPos, DesPos]) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:change_embattle(PartnerSt, SrcPos, DesPos) of
%         {true, Embattle, SrcEmbattle, DesEmbattle} ->
%             {ok, BinData} = pt_412:write(41219, [1]),
%             lib_server_send:send_to_sid(PS#player_status.sid, BinData),
%             change_embattle_do(PS, PartnerSt, Embattle, SrcEmbattle, DesEmbattle);
%         {false, Res} ->
%             {ok, BinData} = pt_412:write(41219, Res),
%             lib_server_send:send_to_sid(PS#player_status.sid, BinData),
%             {false, PS}
%     end.

% change_embattle_do(PS, PartnerSt, Embattle, SrcEmbattle, DesEmbattle) ->
%     #rec_embattle{pos=SrcPos, type=Type, id=Id, partner_id=SrcCfgId, lv=SrcLv} = SrcEmbattle,
%     NewEmbattle = case DesEmbattle of
%                       {none, DesPos} ->
%                           EmbattleTmp = lists:keydelete(SrcPos, #rec_embattle.pos, Embattle),
%                           lists:keystore(DesPos, #rec_embattle.pos, EmbattleTmp, #rec_embattle{key={Type,Id}, pos=DesPos, type=Type, id=Id, partner_id=SrcCfgId, lv=SrcLv});
%                       #rec_embattle{pos=DesPos, type=Type1, id=Id1, partner_id=DstCfgId, lv=DstLv} ->
%                           List1 = lists:keyreplace(DesPos, #rec_embattle.pos, Embattle, #rec_embattle{key={Type,Id}, pos=DesPos, type=Type, id=Id, partner_id=SrcCfgId, lv=SrcLv}),
%                           lists:keyreplace(SrcPos, #rec_embattle.pos, List1, #rec_embattle{key={Type1,Id1}, pos=SrcPos, type=Type1, id=Id1, partner_id=DstCfgId, lv=DstLv})
%                   end,
%     NewPartnerSt = PartnerSt#partner_status{embattle = NewEmbattle},
%     NewPartnerSt1 = sync_battle_embattle_pos(NewPartnerSt, 2),
%                                                 %%% ?PRINT("change_embattle_do ~p~n", [NewEmbattle]),
%                                                 %lib_partner_do:update_partner_embattle(NewPartnerSt),
%     lib_partner_do:set_partner_status(NewPartnerSt1),
%     {true, PS}.

%                                                 % 改变上阵位置
% change_battle_pos(PS, Src, Dst) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:change_battle_pos(PartnerSt, Src, Dst) of
%         {true, SrcPartner, DstPartner} ->
%             change_battle_pos_do(PS, PartnerSt, SrcPartner, DstPartner, Src, Dst);
%         {false, Res} ->
%             {false, Res, PS}
%     end.

% change_battle_pos_do(PS, PartnerSt, SrcPartner, DstPartner, Src, Dst) when is_record(DstPartner, partner) ->
%     NewSrcPartner = SrcPartner#partner{pos = Dst},
%     NewDstPartner = DstPartner#partner{pos = Src},
%     F = fun() ->
%                 Sql = io_lib:format(<<"update `partner` set pos=~p where id=~p ">>, [Dst, NewSrcPartner#partner.id]),
%                 db:execute(Sql),
%                 Sql1 = io_lib:format(<<"update `partner` set pos=~p where id=~p ">>, [Src, NewDstPartner#partner.id]),
%                 db:execute(Sql1),
%                 ok
%         end,
%     case lib_goods_util:transaction(F) of
%         ok ->
%             PartnerMap = PartnerSt#partner_status.partners,
%             NewPartnerMap1 = maps:put(NewSrcPartner#partner.id, NewSrcPartner, PartnerMap),
%             NewPartnerMap2 = maps:put(NewDstPartner#partner.id, NewDstPartner, NewPartnerMap1),
%             NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap2},
%             NewPartnerSt1 = sync_battle_embattle_pos(NewPartnerSt, 1),
%             lib_partner_do:set_partner_status(NewPartnerSt1),
%             BattlePos = [{NewSrcPartner#partner.id, NewSrcPartner#partner.pos}, {NewDstPartner#partner.id, NewDstPartner#partner.pos}],
%             {true, BattlePos, PS};
%         Err ->
%             ?ERR("change_battle_pos_do error:~p", [Err]),
%             {false, ?FAIL, PS}
%     end;
% change_battle_pos_do(PS, PartnerSt, SrcPartner, _DstPartner, Src, Dst) ->
%     NewSrcPartner = SrcPartner#partner{pos = Dst},
%     F = fun() ->
%                 Sql = io_lib:format(<<"update `partner` set pos=~p where id=~p ">>, [Dst, NewSrcPartner#partner.id]),
%                 db:execute(Sql),
%                 ok
%         end,
%     case lib_goods_util:transaction(F) of
%         ok ->
%             NewPartnerMap = maps:put(NewSrcPartner#partner.id, NewSrcPartner, PartnerSt#partner_status.partners),
%             NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap},
%             NewPartnerSt1 = sync_battle_embattle_pos(NewPartnerSt, 1),
%             lib_partner_do:set_partner_status(NewPartnerSt1),
%             BattlePos = [{NewSrcPartner#partner.id, NewSrcPartner#partner.pos}, {0, Src}],
%             {true, BattlePos, PS};
%         Err ->
%             ?ERR("change_battle_pos_do error:~p", [Err]),
%             {false, ?FAIL, PS}
%     end.

% sync_battle_embattle_pos(PartnerSt, 1) ->
%     #partner_status{pid = PlayerId, partners = PartnerMap, embattle = Embattle} = PartnerSt,
%     PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
%     PartnerList = maps:values(PartnerMap1),
%     SortPartnerList = lists:keysort(#partner.pos, PartnerList),
%     F = fun(RecEmbattle, PosList) ->
%                 case RecEmbattle#rec_embattle.type == ?BATTLE_SIGN_PARTNER of
%                     true -> [RecEmbattle#rec_embattle.pos|PosList];
%                     false -> PosList
%                 end
%         end,
%     EmPoslist = lists:foldl(F, [], Embattle),
%     SortEmPosList = lists:sort(EmPoslist),
%     case length(SortPartnerList) =/= length(SortEmPosList) of
%         true -> NewEmbattle = init_embattle(PlayerId, PartnerList);
%         false ->
%             F1 = fun(#partner{id = Id}, {IsOk, SortPosL, List}) ->
%                          case lists:keyfind({?BATTLE_SIGN_PARTNER, Id}, #rec_embattle.key, List) of
%                              #rec_embattle{} = RecEmbattle ->
%                                  [NewPos|LeftSortPosL] = SortPosL,
%                                  NewRecEmbattle = RecEmbattle#rec_embattle{pos = NewPos},
%                                  {IsOk, LeftSortPosL, lists:keystore({?BATTLE_SIGN_PARTNER, Id}, #rec_embattle.key, List, NewRecEmbattle)};
%                              _ ->
%                                  {fail, SortPosL, List}
%                          end
%                  end,
%             case lists:foldl(F1, {ok, SortEmPosList, Embattle}, SortPartnerList) of
%                 {ok, _, NewEmbattle} -> ok;
%                 _ -> NewEmbattle = init_embattle(PlayerId, PartnerList)
%             end
%     end,
%     NewPartnerSt = PartnerSt#partner_status{embattle = NewEmbattle},
%     lib_partner_do:update_partner_embattle(NewPartnerSt),
%     NewPartnerSt;
% sync_battle_embattle_pos(PartnerSt, 2) ->
%     #partner_status{pid = PlayerId, partners = PartnerMap, embattle = Embattle} = PartnerSt,
%     PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
%     PartnerList = maps:values(PartnerMap1),
%     SortEmbattle = lists:keysort(#rec_embattle.pos, Embattle),
%     case (length(PartnerList) + 1) == length(SortEmbattle) of
%         true ->
%             F = fun(#rec_embattle{id = Id, type = ?BATTLE_SIGN_PARTNER}, {IsOk, Acc, List}) ->
%                         case lists:keyfind(Id, #partner.id, List) of
%                             #partner{} = Partner ->
%                                 NewPartner = Partner#partner{pos = Acc},
%                                 {IsOk, Acc+1, lists:keystore(Id, #partner.id, List, NewPartner)};
%                             _ ->
%                                 {fail, Acc, List}
%                         end;
%                    (#rec_embattle{}, {IsOk, Acc, List}) -> {IsOk, Acc, List}
%                 end,
%             case lists:foldl(F, {ok, 1, PartnerList}, SortEmbattle) of
%                 {ok, _, NewPartnerList} ->
%                     NewEmbattle = Embattle, UpPartner = true;
%                 _ ->
%                     NewEmbattle = init_embattle(PlayerId, PartnerList),
%                     NewPartnerList = PartnerList, UpPartner = false
%             end;
%         false ->
%             NewEmbattle = init_embattle(PlayerId, PartnerList),
%             NewPartnerList = PartnerList, UpPartner = false
%     end,
%     if
%         UpPartner ->
%             F1 = fun(Partner, Map) -> maps:put(Partner#partner.id, Partner, Map) end,
%             NewPartnerMap = lists:foldl(F1, PartnerMap, NewPartnerList),
%             lib_partner_do:update_partners_pos(NewPartnerList),
%             NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, embattle = NewEmbattle},
%             lib_partner_do:update_partner_embattle(NewPartnerSt), NewPartnerSt;
%         true ->
%             NewPartnerSt = PartnerSt#partner_status{embattle = NewEmbattle},
%             lib_partner_do:update_partner_embattle(NewPartnerSt), NewPartnerSt
%     end;
% sync_battle_embattle_pos(PartnerSt, _) -> PartnerSt.

% init_embattle(PlayerId, PartnerList) ->
%     PEmbattle = #rec_embattle{key = {?BATTLE_SIGN_PLAYER, PlayerId}, pos=?PLAYER_EMBATTLE_POS,type=?BATTLE_SIGN_PLAYER,id=PlayerId},
%     SortPartnerList = lists:keysort(#partner.pos, PartnerList),
%     F = fun(#partner{id=Id, partner_id = PartnerId, lv = Lv, combat_power = CombatPower}, {Acc, List}) ->
%                 RecEmBattle = #rec_embattle{key = {?BATTLE_SIGN_PARTNER, Id}, id=Id, type = ?BATTLE_SIGN_PARTNER,
%                                             pos = Acc, partner_id = PartnerId, lv = Lv, combat_power = CombatPower},
%                 {Acc+1, [RecEmBattle|List]}
%         end,
%     {_, EmbattleList} = lists:foldl(F, {1, [PEmbattle]}, SortPartnerList),
%     EmbattleList.


% update_embattle(PlayerId, Embattle, #partner{id = Id, state = State, lv = Lv, combat_power = CombatPower}) when State == ?STATE_BATTLE ->
%     case lists:keyfind({?BATTLE_SIGN_PARTNER, Id}, #rec_embattle.key, Embattle) of
%         #rec_embattle{} = RecEmbattle ->
%             NewEmbattle = lists:keystore({?BATTLE_SIGN_PARTNER, Id}, #rec_embattle.key, Embattle, RecEmbattle#rec_embattle{lv=Lv, combat_power = CombatPower}),
%             EmbattleList = lib_partner_util:conver_to_embattle_list(NewEmbattle, []),
%             Embattle_B = util:term_to_bitstring(EmbattleList),
%             Sql = io_lib:format(<<"update `player_partner` set embattle='~s' where id=~p ">>, [Embattle_B, PlayerId]),
%             db:execute(Sql),
%             NewEmbattle;
%         _ -> Embattle
%     end;
% update_embattle(_PlayerId, Embattle, _Partner) -> Embattle.

% %% ------------------------------ 伙伴 专属 -----------------------

% use_partner_weapon(PS, GoodsInfo, _GoodsNum) ->
%     case partner_equip_weapon(PS, GoodsInfo) of
%         {true, _PartnerList, NewPS} ->
%             {ok, Bin} = pt_412:write(41228, [GoodsInfo#goods.goods_id]),
%             lib_server_send:send_to_sid(PS#player_status.sid, Bin),
%             {ok, NewPS, 1};
%         {false, Res, _NewPS} ->
%             ?ERR_MSG(41228, Res),
%             {fail, Res}
%     end.

% partner_equip_weapon(PS, GoodsInfo) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:equip_weapon(PS, PartnerSt, GoodsInfo) of
%         {true, WeaponCfg, PartnerList} when length(PartnerList) > 0 ->
%             equip_weapon_do(PS, PartnerSt, GoodsInfo, WeaponCfg, PartnerList);
%         {true, _GoodsInfo, _WeaponCfg, _PartnerList} ->
%             {true, [], PS};
%         {false, Res} -> {false, Res, PS}
%     end.

% equip_weapon_do(PS, PartnerSt, GoodsInfo, WeaponCfg, PartnerList) ->
%     {NewPartnerList, NewRecruitList} = equip_weapon_core(PartnerSt, WeaponCfg, PartnerList),
%     log_partner_equip(PS#player_status.id, NewPartnerList, [{?TYPE_GOODS, GoodsInfo#goods.goods_id, 1}]),
%     lib_partner_do:update_partner_weapon(PS#player_status.id, NewRecruitList, NewPartnerList),
%     equip_weapon_core1(PS, PartnerSt, NewPartnerList, NewRecruitList).

% equip_weapon_core(PartnerSt, WeaponCfg, PartnerList) ->
%     ValueList = [
%                  {equip_weapon, ?PARTNER_EQUIP_ACTIVE},
%                  {attribute},
%                  {combat_power}
%                 ],
%     NewPartnerList = set_partner_value(ValueList, PartnerList, []),
%                                                 % 更新招募列表
%     RecruitList = PartnerSt#partner_status.recruit_list,
%     NewRecruitList = case lists:keyfind(WeaponCfg#base_partner_weapon.partner_id, 1, RecruitList) of
%                          {PartnerId, 0} ->
%                              lists:keyreplace(PartnerId, 1, RecruitList, {PartnerId, 1});
%                          {_PartnerId, 1} -> RecruitList;
%                          false -> [{WeaponCfg#base_partner_weapon.partner_id, 1}|RecruitList]
%                      end,
%     {NewPartnerList, NewRecruitList}.

% equip_weapon_core1(PS, PartnerSt, PartnerList, RecruitList) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     F = fun(Partner, Map) ->
%                 maps:put(Partner#partner.id, Partner, Map)
%         end,
%     NewPartnerMap = lists:foldl(F, PartnerMap, PartnerList),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, recruit_list = RecruitList},
%     lib_partner_do:set_partner_status(NewPartnerSt),
%     CountPS = update_ps_attr(PS, NewPartnerSt, ?STATE_BATTLE, 1),
%     mod_scene_agent:update(CountPS, [{battle_attr, CountPS#player_status.battle_attr}]),
%     {true, PartnerList, CountPS}.

% set_partner_value(_ValueList, [], NewPartnerList) ->
%     NewPartnerList;
% set_partner_value(ValueList, [Partner|T], NewPartnerList) ->
%     NewPartner = lib_partner_util:set_partner_value(Partner, ValueList),
%     set_partner_value(ValueList, T, [NewPartner|NewPartnerList]).

% %% ------------------------------ 伙伴 遣散 -----------------------

% partner_disband(PS, IdList) ->
%     PartnerSt = lib_partner_do:get_partner_status(),
%     case lib_partner_check:partner_disband(PartnerSt, IdList) of
%         {true, PartnerList, AwardList, RewardMap} ->
%             partner_disband_do(PS, PartnerSt, PartnerList, AwardList, RewardMap);
%         {false, Res} ->
%             {false, Res, PS}
%     end.

% partner_disband_do(PS, PartnerSt, PartnerList, AwardList, RewardMap) ->
%     GS = lib_goods_do:get_goods_status(),
%     F = fun() ->
%                 ok = lib_goods_dict:start_dict(),
%                 lib_partner_do:delete_partners(PartnerList),
%                 {ok, NewStatus} = lib_goods_check:list_handle(fun lib_goods:give_goods/2, GS, AwardList),
%                 {D, UpGoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%                 NewGS1 = NewStatus#goods_status{dict = D},
%                 {ok, NewGS1, UpGoodsL}
%         end,
%     case db:transaction(F) of
%         {ok, NewGoodsStatus, UpdateGoodsL} ->
%             lib_goods_do:set_goods_status(NewGoodsStatus),
%             lib_goods_api:notify_client(PS, UpdateGoodsL),
%             log_partner_disband(PS#player_status.id, PartnerList, RewardMap),
%             partner_disband_core(PS, PartnerSt, PartnerList, AwardList);
%         {_Error, {error, {cell_num, not_enough}}} ->
%                                                 % 发邮件 赠送物品
%             send_reward_when_no_cell(disband, PS, {AwardList, PartnerList, PartnerSt});
%         Err ->
%             ?ERR("partner_disband error :~p", [Err]),
%             {false, ?FAIL, PS}
%     end.

% partner_disband_core(PS, PartnerSt, PartnerList, AwardList) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     F = fun(Partner, Map) ->
%                 maps:remove(Partner#partner.id, Map)
%         end,
%     NewPartnerMap = lists:foldl(F, PartnerMap, PartnerList),
%     NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap},
%     lib_partner_do:set_partner_status(NewPartnerSt),
%     {true, PS, AwardList}.

% %% -----------------------------------------------------
% use_summon_card(PS, GoodsInfo, GoodsNum) ->
%     case data_partner:get_summon_card(GoodsInfo#goods.goods_id) of
%         #base_summon_card{partner_id = PartnerId} ->
%             case use_summon_card_do(PS, PartnerId, GoodsInfo#goods.goods_id, GoodsNum) of
%                 {true, NewPS, AddNum} -> {ok, NewPS, AddNum};
%                 {false, NewErrCode, _NewPS} -> {fail, NewErrCode}
%             end;
%         _ ->
%             ?ERR_MSG(41229, ?ERRCODE(err412_cfg_not_exist)),
%             {fail, ?ERRCODE(err412_cfg_not_exist)}
%     end.

% use_summon_card_do(PS, PartnerId, GoodsId, GoodsNum) ->
%     #player_status{sid = Sid} = PS,
%     F = fun(_No, {TmpPS, IsOk, ErrCode, Num}) ->
%                 case lib_partner:give_partner(TmpPS, PartnerId, summon_card, GoodsId) of
%                     {true, Partner, NewTmpPS} ->
%                         log_partner_recruit(PS#player_status.id, [Partner], [], [{?TYPE_GOODS,GoodsId, 1}], 6),
%                         #partner{id=Id, partner_id=PartnerId, state=State, pos=Pos, lv=Lv, combat_power=CombatPower, prodigy=Prodigy, equip = #partner_equip{weapon_st = WeaponSt}} = Partner,
%                         {ok, BinData} = pt_412:write(41208, [1, Id, PartnerId, Lv, State, Pos, round(CombatPower), Prodigy, WeaponSt]),
%                         lib_server_send:send_to_sid(Sid, BinData),
%                         {NewTmpPS, IsOk, ErrCode, Num+1};
%                     {false, Res, NewTmpPS} ->
%                         ?ERR_MSG(41208, Res),
%                         {ok, BinData} = pt_412:write(41208, [Res, 0, 0, 0, 0, 0, 0, 0, 0]),
%                         lib_server_send:send_to_sid(Sid, BinData),
%                         {NewTmpPS, fail, Res, Num}
%                 end
%         end,
%     {NewPS, _Ok, NewErrCode, AddNum} = lists:foldl(F, {PS, ok, 1, 0}, lists:seq(1, GoodsNum)),
%     case AddNum > 0 of
%         true -> %% ?PRINT("use_summon_card_do Addnum ~p~n", [AddNum]),
%             {true, NewPS, AddNum};
%         false -> {false, NewErrCode, NewPS}
%     end.

% %% -----------------------------------------------------
% update_ps_attr(PS, PartnerSt, ?STATE_BATTLE, 1) ->
%     AssistList = lib_partner_util:get_battle_partner_assist(PartnerSt),
%     PlayerAttr = lib_partner_util:get_assist_skill_attr(AssistList),
%     CombatPower = lib_partner_util:get_battle_partner_power(PartnerSt),
%     StPartner = #status_partner{attr = PlayerAttr, combat_power = CombatPower},
%     NewPS = PS#player_status{partner = StPartner},
%     lib_common_rank_api:reflash_rank_by_partner(NewPS),
%     LastPS = lib_player:count_player_attribute(NewPS),
%     lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
%     LastPS;
% update_ps_attr(PS, _, _, _) ->
%     PS.

% insert_ps_embattle(EmBattle, Partner, InsertType) ->
%     #partner{id = InsertId, partner_id = CfgId, lv = Lv, combat_power = CombatPower} = Partner,
%     MaxList = lists:seq(1, ?MAX_EMBATTLE),
%     F = fun(Item, List) ->
%                 #rec_embattle{pos=Pos, type=Type, id=Id} = Item,
%                 case lists:member(Pos, List) of
%                     true when Id =/= InsertId orelse InsertType =/= Type -> lists:delete(Pos, List);
%                     true -> [];
%                     false -> List
%                 end
%         end,
%     case lists:foldl(F, MaxList, EmBattle) of
%         [] -> EmBattle;
%         UnusedList ->
%             UnusedPos = lists:nth(1, UnusedList),
%             [#rec_embattle{key={InsertType,InsertId}, pos=UnusedPos, type=InsertType, id=InsertId, partner_id=CfgId, lv=Lv, combat_power = CombatPower}|EmBattle]
%     end.

% send_promote_msg(#player_status{sid = Sid}, Partner, Type, AddList) ->
%     #partner{id=Id, total_attr = TotalAttr, combat_power = CombatPower} = Partner,
%     {_, CurVal, _} = lists:keyfind(Type, 1, TotalAttr),
%     Rsp = [1, Id, round(CombatPower), AddList, Type, round(CurVal)],
%     {ok, BinData} = pt_412:write(41221, Rsp),
%     lib_server_send:send_to_sid(Sid, BinData).

% send_upgrade_msg(Sid, Partner, NewPartner, Exp) ->
%     #partner{id = Id, lv = NewLv, exp = NewExp} = NewPartner,
%     #partner{lv = OldLv} = Partner,
%     {ok, BinData} = pt_412:write(41212, [1, Id, NewLv, NewExp, Exp]),
%     lib_server_send:send_to_sid(Sid, BinData),
%     case NewLv > OldLv of
%         true ->
%             Rsp = lib_partner_do:get_partner_base_info(NewPartner),
%             {ok, BinData1} = pt_412:write(41202, Rsp),
%             lib_server_send:send_to_sid(Sid, BinData1);
%         false -> skip
%     end.

% send_attr_list(Sid, Partner) ->
%     Attr = Partner#partner.battle_attr,
%     Attr_L = maps:to_list(Attr),
%     Rsp = [1, Partner#partner.id, Attr_L],
%     {ok, BinData} = pt_412:write(41203, Rsp),
%     lib_server_send:send_to_sid(Sid, BinData).


% send_goods_notice_msg(Sid, AwardList) when length(AwardList)>0 ->
%     {ok, BinData} = pt_110:write(11060, [2, AwardList]),
%     lib_server_send:send_to_sid(Sid, BinData);
% send_goods_notice_msg(_Sid, _AwardList) ->
%     skip.

% wash_skill_list(Partner, SkList) ->
%     #base_partner{attack_skill=AttackSk, assist_skill=AssistSk,talent_skill=TalentSk} = data_partner:get_partner_by_id(Partner#partner.partner_id),
%     OldSkList = [{AttackSk, 1, ?COM_ATTACK}, {AssistSk, 1, ?ASSIST}, {TalentSk, 1, ?TALENT}],
%     OldSkillCd = [{AttackSk, 0}, {AssistSk, 0}, {TalentSk, 0}],
%     F = fun({AddSkId, Lv, Pos}, {OldList, OldCdList}) ->
%                 NewList = lists:keystore(Pos, 3, OldList, {AddSkId, Lv, Pos}),
%                 NewCdList = lists:keystore(AddSkId, 1, OldCdList, {AddSkId, 0}),
%                 {NewList, NewCdList}
%         end,
%     lists:foldl(F, {OldSkList, OldSkillCd}, SkList).

% calc_partner_upgrade(PlayerLv, Lv, LeftExp) ->
%     case data_partner:get_lv_upgrade(Lv) of
%         #base_partner_upgrade{max_exp = MaxExp} ->
%             if
%                 LeftExp >= MaxExp andalso PlayerLv =< Lv ->
%                     {Lv, MaxExp};
%                 LeftExp >= MaxExp ->
%                     calc_partner_upgrade(PlayerLv, Lv+1, LeftExp-MaxExp);
%                 true -> {Lv, LeftExp}
%             end;
%         _ ->
%             #base_partner_upgrade{max_exp = MaxExp1} = data_partner:get_lv_upgrade(Lv-1),
%             {Lv-1, MaxExp1}
%     end.

% get_partner_apti([], ListApti) ->
%     ListApti;
% get_partner_apti([#partner{apti_take = Apti}|T], ListApti) ->
%     get_partner_apti(T, Apti ++ ListApti).

% get_diaband_exp_book([], TotalExp) ->
%     if
%         TotalExp < 20000 -> [];
%         TotalExp =< 1000000 -> [{212201, TotalExp div 20000}];
%         TotalExp =< 50000000 -> [{212202, TotalExp div 200000}];
%                                                 %TotalExp =< 3000000000 -> [{212203, TotalExp div 2000000}];
%         true -> [{212203, TotalExp div 2000000}]
%     end;
% get_diaband_exp_book([#partner{lv = PLv, exp = PExp}|T], TotalExp) ->
%     LvList = lists:seq(1, PLv),
%     F = fun(Lv, Sum) ->
%                 case data_partner:get_lv_upgrade(Lv) of
%                     #base_partner_upgrade{max_exp = MaxExp} -> Sum+MaxExp;
%                     _ -> Sum
%                 end
%         end,
%     TotalExp1 = lists:foldl(F, TotalExp+PExp, LvList),
%     get_diaband_exp_book(T, TotalExp1).

% get_discount_goods([], GoodsList) ->
%     GoodsList;
% get_discount_goods([DisbandCfg|T], GoodsList) ->
%     Award = DisbandCfg#base_partner_disband.award,
%     F = fun(Value, List) ->
%                 case Value of
%                     {?TYPE_GOODS, GoodsTypeId, Avg} ->
%                         CeilNum = ceil(Avg),	% 上取整
%                         FloorNum = floor(Avg), % 下取整
%                         Rand = urand:rand(1, 100),
%                         Num = case (CeilNum - Avg)*100 < Rand  of
%                                   true -> CeilNum;
%                                   false -> FloorNum
%                               end,
%                         ?IF(Num == 0, List, [{GoodsTypeId, Num}|List]);
%                     _ -> List
%                 end
%         end,
%     Goods = lists:foldl(F, [], Award),
%     get_discount_goods(T, Goods ++ GoodsList).

% send_reward_when_no_cell(recruit, PS, {CostL, RewardList, PartnerList, PartnerSt}) ->
%     GS = lib_goods_do:get_goods_status(),
%     F = fun() ->
%                 case lib_goods_util:cost_object_list(PS, CostL, recruit_partner, "", GS) of
%                     {true, NewGS, NewPS} ->
%                         lib_partner_do:update_partner_list(PartnerList),
%                         lib_partner_do:update_player_partner(PartnerSt),
%                         {true, NewGS, NewPS};
%                     {false, Res, NewGS, NewPS} -> {error, Res, NewGS, NewPS}
%                 end
%         end,
%     case lib_goods_util:transaction(F) of
%         {true, NewGoodsStatus, NewPlayerStatus} ->
%             lib_goods_do:set_goods_status(NewGoodsStatus),
%             lib_partner_do:set_partner_status(PartnerSt),
%             Attachment = lib_partner_check:change_to_obj_list(RewardList, []),
%             lib_mail_api:send_sys_mail([NewPlayerStatus#player_status.id], ?LAN_MSG(?REWARD_TITLE), ?LAN_MSG(?RECRUIT_CONTENT), Attachment),
%             {true, NewPlayerStatus, PartnerList, RewardList};
%         {error, Res, NewGoodsStatus, NewPlayerStatus} ->
%             lib_goods_do:set_goods_status(NewGoodsStatus),
%             {false, Res, NewPlayerStatus};
%         Err ->
%             ?ERR("send_reward_when_no_cell recruit Err ~p", [Err]),
%             {false, ?FAIL, PS}
%     end;
% send_reward_when_no_cell(wash_replace, PS, {AwardList, WashPartner, PartnerSt}) ->
%     F = fun() ->
%                 lib_partner_do:update_partner_list([WashPartner]), ok
%         end,
%     case lib_goods_util:transaction(F) of
%         ok ->
%             Attachment = lib_partner_check:change_to_obj_list(AwardList, []),
%             lib_mail_api:send_sys_mail([PS#player_status.id], ?LAN_MSG(?REWARD_TITLE), ?LAN_MSG(?REPLACE_CONTENT), Attachment),
%             NewPartnerMap = maps:put(WashPartner#partner.id, WashPartner, PartnerSt#partner_status.partners),
%             NewPartnerSt = PartnerSt#partner_status{partners = NewPartnerMap, wash_partner = undefined},
%             lib_partner_do:set_partner_status(NewPartnerSt),
%             {true, WashPartner, PS};
%         Err ->
%             ?ERR("send_reward_when_no_cell wash_replace Err ~p", [Err]),
%             {false, ?FAIL, PS}
%     end;
% send_reward_when_no_cell(disband, PS, {AwardList, PartnerList, PartnerSt}) ->
%     F = fun() ->
%                 lib_partner_do:delete_partners(PartnerList), ok
%         end,
%     case lib_goods_util:transaction(F) of
%         ok ->
%             Attachment = lib_partner_check:change_to_obj_list(AwardList, []),
%             lib_mail_api:send_sys_mail([PS#player_status.id], ?LAN_MSG(?REWARD_TITLE), ?LAN_MSG(?DISBAND_CONTENT), Attachment),
%             partner_disband_core(PS, PartnerSt, PartnerList, AwardList);
%         Err ->
%             ?ERR("send_reward_when_no_cell disband Err ~p", [Err]),
%             {false, ?FAIL, PS}
%     end.

% send_tv_recruit(PlayerName, PartnerList, Type, LeastQuality) ->
%     BroadCastId = case Type of
%                       recruit_type1 -> ?TV_RECRUIT_PARTNER_1;
%                       recruit_type2 -> ?TV_RECRUIT_PARTNER_2;
%                       summon_card -> ?TV_SUMMON_CARD_PARTNER;
%                       _ -> ?TV_RECRUIT_PARTNER_1
%                   end,
%     Broadcast = {all},
%     F = fun(Partner) ->
%                 #partner{partner_id = PartnerId, quality = Quality} = Partner,
%                 if
%                     Quality >= LeastQuality ->
%                         Quality_S = lib_partner_util:get_quality_string(Quality),
%                         QualityColor = lib_partner_util:get_quality_color(Quality),
%                         Msg = [PlayerName, QualityColor, Quality_S, PartnerId],
%                         send_tv(Broadcast, ?MOD_PARTNER, BroadCastId, Msg);
%                     true -> skip
%                 end
%         end,
%     lists:foreach(F, PartnerList).

% send_tv(BroadCast, ModuleId, Id, Msg) ->
%     lib_chat:send_TV(BroadCast, ModuleId, Id, Msg).

% %%---------------------------------------  伙伴日志 -----------------------------
% log_partner_break(RoleId, OldPartner, NewPartner) ->
%     Now = utime:unixtime(),
%     #partner{partner_id = PartnerId, attr_quality = OldAttrQuality, total_attr = OldTotalAttr} = OldPartner,
%     #partner{attr_quality = NewAttrQuality, total_attr = NewTotalAttr} = NewPartner,
%     OldAttrString = get_total_attr_string(OldAttrQuality, OldTotalAttr),
%     NewAttrString = get_total_attr_string(NewAttrQuality, NewTotalAttr),
%     lib_log_api:log_partner_break(RoleId, PartnerId, OldAttrString, NewAttrString, Now).

% log_partner_equip(PlayerId, NewPartnerList, ObjectList) ->
%     ObjectList_B = util:term_to_bitstring(ObjectList),
%     Now = utime:unixtime(),
%     F = fun(Partner) ->
%                 #partner{partner_id = PartnerId, quality = Quality, combat_power = Combat} = Partner,
%                 lib_log_api:log_partner_equip(PlayerId, PartnerId, Quality, ObjectList_B, round(Combat), Now)
%         end,
%     lists:foreach(F, NewPartnerList).

% log_partner_learn_sk(RoleId, Partner, GoodsInfo, SkillCfg) ->
%     #partner{partner_id = PartnerId, quality = Quality, combat_power = Combat} = Partner,
%     Cost_B = util:term_to_bitstring([{?TYPE_GOODS,GoodsInfo#goods.goods_id,1}]),
%     lib_log_api:log_partner_learn_sk(RoleId, PartnerId, Quality, SkillCfg#base_partner_sk.skill_id, Cost_B, round(Combat)).

% log_partner_promote(RoleId, Type, Partner, NewPartner, ObjectList) ->
%     #partner{attr_quality = _OldAttrQuality, total_attr = _OldTotalAttr} = Partner,
%     #partner{partner_id = PartnerId, quality = Quality, total_attr = _NewTotalAttr, combat_power = Combat} = NewPartner,
%     %% case lists:keyfind(Type, 1, OldAttrQuality) of
%     %%     {_, QualityAtt} -> QualityAttStr = lib_partner_util:get_quality_string(QualityAtt);
%     %%     _ -> QualityAttStr = lib_partner_util:get_quality_string(0)
%     %% end,
%     %% case lists:keyfind(Type, 1, OldTotalAttr) of
%     %%     {_, OldCur, OldTotal} -> OldCurInt = round(OldCur), OldTotalInt = round(OldTotal);
%     %%     _ -> OldCurInt=0,OldTotalInt=0
%     %% end,
%     %% case lists:keyfind(Type, 1, NewTotalAttr) of
%     %%     {_, NewCur, NewTotal} -> NewCurInt = round(NewCur), NewTotalInt = round(NewTotal);
%     %%     _ -> NewCurInt=0,NewTotalInt=0
%     %% end,
%     case Type of
%         %% ?PHYSIQUE ->
%         %%     OldAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_PH, [QualityAttStr, OldCurInt, OldTotalInt])),
%         %%     NewAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_PH, [QualityAttStr, NewCurInt, NewTotalInt]));
%         %% ?AGILE ->
%         %%     OldAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_AG, [QualityAttStr, OldCurInt, OldTotalInt])),
%         %%     NewAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_AG, [QualityAttStr, NewCurInt, NewTotalInt]));
%         %% ?FORZA ->
%         %%     OldAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_FO, [QualityAttStr, OldCurInt, OldTotalInt])),
%         %%     NewAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_FO, [QualityAttStr, NewCurInt, NewTotalInt]));
%         %% ?DEXTEROUS ->
%         %%     OldAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_DE, [QualityAttStr, OldCurInt, OldTotalInt])),
%         %%     NewAttrString = ulists:list_to_bin(utext:get(?LOG_PROMOTE_ATTR_DE, [QualityAttStr, NewCurInt, NewTotalInt]));
%         _ ->
%             OldAttrString = "", NewAttrString = ""
%     end,
%     ObjectList_B = util:term_to_bitstring(ObjectList),
%     lib_log_api:log_partner_promote(RoleId, PartnerId, Quality, ObjectList_B, OldAttrString, NewAttrString, round(Combat)).

% log_partner_disband(RoleId, PartnerList, RewardMap) ->
%     Now = utime:unixtime(),
%     F = fun(Partner, Acc) ->
%                 #partner{id = Id, partner_id = PartnerId, lv = Lv,  apti_take = AptiTake, skill_learn = SkIds, combat_power = Combat} = Partner,
%                 PReward = maps:get(Id, RewardMap, []),
%                 SkLearn = [{SkId, 1}|| SkId <- SkIds],
%                 SkLearn_B = util:term_to_bitstring(SkLearn),
%                 AptiTake_B = util:term_to_bitstring(AptiTake),
%                 PReward_B = util:term_to_bitstring(PReward),
%                 PartnerInfo = util:term_to_bitstring([{PartnerId, Lv, round(Combat)}]),
%                 lib_log_api:log_partner_disband(RoleId, PartnerInfo, AptiTake_B, SkLearn_B, PReward_B, Now),
%                 Acc
%         end,
%     lists:foldl(F, 0, PartnerList).

% log_partner_add_exp(RoleId, Partner, NewPartner, GoodsId, Num) ->
%     #partner{lv = OldLv} = Partner,
%     #partner{partner_id = PartnerId, quality = Quality, lv = NewLv} = NewPartner,
%     ObjectList_B = util:term_to_bitstring([{?TYPE_GOODS,GoodsId, Num}]),
%     lib_log_api:log_partner_add_exp(RoleId, PartnerId, Quality, ObjectList_B, OldLv, NewLv).

% log_partner_wash(RoleId, OldPartner, WashPartner, AwardList, Replace) ->
%     #base_partner_wash{goods = Cost} = data_partner:get_wash_cfg(WashPartner#partner.quality),
%     #partner{partner_id = PartnerId, quality = PaQuality, attr_quality = OldAttrQuality, total_attr = OldTotalAttr, lv = Lv, skill = #partner_skill{skill_list = OldSkList}, combat_power = OldPower, prodigy = OldProdigy} = OldPartner,
%     #partner{attr_quality = NewAttrQuality, total_attr = NewTotalAttr, skill = #partner_skill{skill_list = NewSkList}, combat_power = NewPower,prodigy = NewProdigy} = WashPartner,

%     OldAttrString = get_total_attr_string(OldAttrQuality, OldTotalAttr),
%     NewAttrString = get_total_attr_string(NewAttrQuality, NewTotalAttr),
%     BfSkIds = [SkId || {SkId, _SkLv, SkPos} <- OldSkList, SkPos =< 5 ],
%     AfSkIds = [SkId || {SkId, _SkLv, SkPos} <- NewSkList, SkPos =< 5 ],

%     CostObject = util:term_to_bitstring(Cost),
%     Reward = util:term_to_bitstring(AwardList),
%     PowerChange = util:term_to_bitstring([{bf,round(OldPower)},{af,round(NewPower)}]),
%     SkChange = util:term_to_bitstring([{bf,BfSkIds},{af,AfSkIds}]),
%     ProdigyChange = util:term_to_bitstring([{bf,OldProdigy},{af,NewProdigy}]),

%     lib_log_api:log_partner_wash(RoleId, PartnerId, PaQuality, Lv, CostObject, Reward, OldAttrString, NewAttrString, PowerChange, SkChange, ProdigyChange, Replace).

% log_partner_recruit(RoleId, PartnerList, Reward, Cost, LogRecruitType) ->
%     Time = utime:unixtime(),
%     RewardObject = util:term_to_bitstring(Reward),
%     FirstCostObject = util:term_to_bitstring(Cost),
%     OtherCostObject = util:term_to_bitstring([]),
%     F = fun(Partner, {I, List}) ->
%                 #partner{partner_id = PartnerId, quality = Quality, attr_quality = AttrQuality, total_attr = TotalAttr, skill = #partner_skill{skill_list = SkList}, combat_power = Power,prodigy = Prodigy} = Partner,
%                 AttrString = get_total_attr_string(AttrQuality, TotalAttr),
%                 SkIds = [SkId || {SkId, _SkLv, SkPos} <- SkList, SkPos =< 5 ],
%                 SkIdsStr = util:term_to_bitstring(SkIds),
%                 case I == 0 of
%                     true ->
%                         {I+1, [[RoleId, LogRecruitType, FirstCostObject, RewardObject, PartnerId, Quality, round(Power), AttrString, SkIdsStr, Prodigy, Time]|List]};
%                     false ->
%                         {I+1, [[RoleId, LogRecruitType, OtherCostObject, RewardObject, PartnerId, Quality, round(Power), AttrString, SkIdsStr, Prodigy, Time]|List]}
%                 end
%         end,
%     {LogNum, LogList} = lists:foldl(F, {0, []}, PartnerList),
%     NewLogList = case LogRecruitType == 3 orelse LogRecruitType == 4 of
%                      true ->
%                          F1 = fun(_No, List1) ->
%                                       SkIdsStr = util:term_to_bitstring([]),
%                                       [[RoleId, LogRecruitType, OtherCostObject, RewardObject, 0, 0, 0, "", SkIdsStr, 0, Time]|List1]
%                               end,
%                          lists:foldl(F1, LogList, lists:seq(1, 10-LogNum));
%                      false -> LogList
%                  end,
%     lib_log_api:log_partner_recruit(NewLogList).


% get_total_attr_string(AttrQuality, TotalAttr) ->
%     F = fun(Type, List) ->
%                 case lists:keyfind(Type, 1, AttrQuality) of
%                     {_, Quality} -> skip;
%                     _ -> Quality=0
%                 end,
%                 case lists:keyfind(Type, 1, TotalAttr) of
%                     {_, Cur, Total} -> CurInt = round(Cur), TotalInt = round(Total);
%                     _ -> CurInt=0,TotalInt=0
%                 end,
%                 QualityStr = lib_partner_util:get_quality_string(Quality),
%                 [TotalInt, CurInt, QualityStr|List]
%         end,
%     ValueList = lists:foldl(F, [], []),
%     ReValueList = lists:reverse(ValueList),
%     AttrString = utext:get(?LOG_BREAK_ATTR, ReValueList),
%     ulists:list_to_bin(AttrString).
