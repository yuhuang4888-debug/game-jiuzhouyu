%% ---------------------------------------------------------------------------
%% @doc 'pp_companion'

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/4/28
%% @deprecated  （新）伙伴 路由
%% ---------------------------------------------------------------------------
-module(pp_companion).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("companion.hrl").
-include("skill.hrl").
-include("errcode.hrl").

handle(Cmd, Ps, Args) ->
    do_handle(Cmd, Ps, Args).
%%    #player_status{figure = #figure{lv = RoleLv}} = Ps,
%%    OpenDay = util:get_open_day(),
%%    case ?LIMIT_LV =< RoleLv andalso OpenDay >= ?LIMIT_DAY of
%%        true -> do_handle(Cmd, Ps, Args);
%%        _ -> skip
%%    end.

%% 单个伙伴信息（一般主动推送）
do_handle(14201, Ps, [CompanionId]) ->
    #player_status{status_companion = StatusCompanion, original_attr = OriginAttr, id = RoleId} = Ps,
    #status_companion{sum_attr = SumAttr, companion_list = CompanionList, fight_id = FightId} = StatusCompanion,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        #companion_item{
            stage = Stage, star = Star, skill = SkillList,
            blessing = Blessing, train_num = TrainNum,
            stage_attr = StageAttr, train_attr = TrainAttr
        } ->
            ItemAttr = lib_player_attr:add_attr(list, [StageAttr, TrainAttr]),
            SkillPower = lib_companion_util:get_skill_power(SkillList),
            Combat = lib_player:calc_partial_power(OriginAttr, SkillPower, ItemAttr),
            {ok, BinData} = pt_142:write(14201, [SumAttr, CompanionId, Stage, Star, ?C_ACTIVE, Blessing, TrainNum, ItemAttr, Combat, FightId]),
%%            ?PRINT("[SumAttr, CompanionId, Stage, Star, ?C_ACTIVE, Blessing, TrainNum, ItemAttr, Combat] ~p ~m",
%%                [[SumAttr, CompanionId, Stage, Star, ?C_ACTIVE, Blessing, TrainNum, ItemAttr, Combat]]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end;

%% 伙伴信息列表
do_handle(14202, Ps, _) ->
    #player_status{status_companion = StatusCompanion, id = RoleId} = Ps,
    #status_companion{sum_attr = SumAttr, companion_list = CompanionList, fight_id = FightId} = StatusCompanion,
    CompanionIds = data_companion:list_companion_id(),
    F = fun(CompanionItem, {GrandList, GrandIds}) ->
        #companion_item{
            companion_id = CompanionId, is_fight = IsFight,
            stage = Stage, star = Star,
            biography = BiogList,
            blessing = Blessing, train_num = TrainNum,
            stage_attr = StageAttr, train_attr = TrainAttr
        } = CompanionItem,
        ItemAttr = lib_player_attr:add_attr(list, [StageAttr, TrainAttr]),
        FigureId = lib_companion_util:get_figure_id(CompanionId),
        Combat = lib_companion_util:get_companion_real_power(CompanionItem, ItemAttr, Ps),
        Item = {CompanionId, Stage, Star, BiogList, ?C_ACTIVE, IsFight, FigureId, Blessing, TrainNum, ItemAttr, Combat},
        {[Item|GrandList], GrandIds -- [CompanionId]}
        end,
    {SendList1, DisActiveIds} = lists:foldl(F, {[], CompanionIds}, CompanionList),
    F1 = fun(Id, GrandList) ->
        #companion_item{
            companion_id = CompanionId, stage_attr = StageAttr,
            biography = BiogList
        } = lib_companion_util:logic_init_companion(Id),
        FigureId = lib_companion_util:get_figure_id(CompanionId),
        Combat = lib_companion_util:get_companion_expect_power(CompanionId, Ps),
        Item = {CompanionId, ?MIN_STAGE_, ?MIN_STAR_, BiogList, ?DIS_C_ACTIVE, ?NOT_FIGHT, FigureId, 0, 0, StageAttr, Combat},
        [Item|GrandList]
        end,
    SendList = lists:foldl(F1, SendList1, DisActiveIds),
%%    ?PRINT("[FightId, SumAttr, SendList] ~p ~n", [[FightId, SumAttr, SendList]]),
    {ok, BinData} = pt_142:write(14202, [FightId, SumAttr, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData);

%% 出战
do_handle(14203, Ps, [CompanionId]) ->
    #player_status{id = RoleId} = Ps,
    case lib_companion:fight_companion(Ps, CompanionId) of
        {false, ErrCode} ->
            {ok, BinData} = pt_142:write(14203, [ErrCode, 0, 0]),
            lib_server_send:send_to_uid(RoleId, BinData);
        {true, NewPs} ->
            pp_skill:handle(21002, NewPs, []),
            {ok, battle_attr, NewPs}
    end;

%% 激活
do_handle(14204, Ps, [CompanionId]) ->
    #player_status{id = RoleId} = Ps,
    case lib_companion:active_companion(Ps, CompanionId) of
        {false, ErrCode} ->
            {ok, BinData} = pt_142:write(14204, [ErrCode, 0, 0]),
            lib_server_send:send_to_uid(RoleId, BinData);
        {true, NewPs} ->
            pp_skill:handle(21002, NewPs, []),
            {ok, battle_attr, NewPs}
    end;

%% 升阶（多次调用）
do_handle(14205, Ps, [CompanionId]) ->
    #player_status{id = RoleId} = Ps,
    case lib_companion:upgrade_star(Ps, CompanionId) of
        {false, ErrCode} ->
            {ok, BinData} = pt_142:write(14205, [ErrCode, 0, 0, 0, 0]),
            lib_server_send:send_to_uid(RoleId, BinData);
        {true, NewPs} ->
            {ok, NewPs}
    end;

%% 培养，吃经验丹
do_handle(14206, Ps, [CompanionId]) ->
    #player_status{id = RoleId} = Ps,
    case lib_companion:train_companion(Ps, CompanionId) of
        {false, ErrCode} ->
            {ok, BinData} = pt_142:write(14206, [ErrCode, 0]),
            lib_server_send:send_to_uid(RoleId, BinData);
        {true, NewPs} ->
            {ok, battle_attr, NewPs}
    end;

%% 解锁传记
do_handle(14207, Ps, [CompanionId, BiogLv]) ->
    #player_status{sid = SId} = Ps,
    case lib_companion:unlock_biog(Ps, CompanionId, BiogLv) of
        {true, NewPs} ->
            do_handle(14202, NewPs, []), % 刷新客户端数据
            lib_server_send:send_to_sid(SId, pt_142, 14207, [?SUCCESS, CompanionId, BiogLv]);
        {false, ErrCode} ->
            NewPs = Ps,
            lib_server_send:send_to_sid(SId, pt_142, 14207, [ErrCode, CompanionId, BiogLv])
    end,
    {ok, NewPs};

do_handle(_Cmd, _Ps, _) ->
    skip.
