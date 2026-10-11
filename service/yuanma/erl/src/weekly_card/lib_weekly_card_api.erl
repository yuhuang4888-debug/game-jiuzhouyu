%%% -------------------------------------------------------------------
%%% @doc        lib_weekly_card_api
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-21 11:01
%%% @deprecated 周卡外部调用API
%%% -------------------------------------------------------------------

-module(lib_weekly_card_api).

-include("server.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").
-include("weekly_card.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("boss.hrl").
-include("dungeon.hrl").
-include("eudemons_land.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("hi_point.hrl").
-include("mount.hrl").
-include("common_rank.hrl").

%% API
-export([
    handle_event/2
    , daily_refresh/0
    , gm_compensation_dungeon_times/1
    , cale_activity_reward/2
    , gm_delay_next_day_four_clock/0
    , gm_delay_next_day_four_clock_by_role_id/1
    , gm_correct_mount/1
    , gm_correct_mount_formal/1
    , correct_mount_formal_event/1]).

%% -----------------------------------------------------------------
%% @desc 充值激活
%% @param
%% @return
%% -----------------------------------------------------------------
handle_event(#player_status{weekly_card_status = undefined} = PS, _) -> {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product} = Data}) ->
    #base_recharge_product{product_id = ProductId} = Product,
    %?MYLOG("lwccard","{ProductId}:~p~n",[{ProductId}]),
    ?IF(ProductId =:= ?WEEKLY_CARD_PRODUCT_ID, lib_weekly_card:activity_weekly_card(PS, Data), {ok, PS});

%% -----------------------------------------------------------------
%% @desc Boss死亡
%% @param
%% @return
%% -----------------------------------------------------------------
handle_event(PS, #event_callback{type_id = ?EVENT_BOSS_KILL, data = CallBackData}) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    #callback_boss_kill{boss_id = BossId, boss_type = BossType} = CallBackData,
    %?MYLOG("lwccard","{BossType}:~p~n",[{BossType}]),
    if
        BossType =:= ?BOSS_TYPE_FORBIDDEN orelse BossType =:= ?BOSS_TYPE_ABYSS
            orelse BossType =:= ?BOSS_TYPE_DOMAIN orelse BossType =:= ?BOSS_TYPE_NEW_OUTSIDE
            orelse BossType =:= ?BOSS_TYPE_WORLD_PER orelse BossType == ?BOSS_TYPE_KF_GREAT_DEMON->
            #boss_cfg{drop_lv = DropLv} = data_boss:get_boss_cfg(BossId),
            MonLv = lib_mon:get_lv_by_mon_id(BossId),
            DisLv = RoleLv - MonLv,
            NewPS = ?IF(DropLv =:= 0 orelse DisLv < DropLv, lib_weekly_card:add_gift_bag_num(PS), PS),
            {ok, NewPS};
        BossType =:= ?BOSS_TYPE_PHANTOM orelse BossType =:= ?BOSS_TYPE_DECORATION_BOSS
            orelse BossType =:= ?BOSS_TYPE_PHANTOM_PER ->
            {ok, lib_weekly_card:add_gift_bag_num(PS)};
        true -> {ok, PS}
    end;

%% -----------------------------------------------------------------
%% @desc 副本通关
%% @param
%% @return
%% -----------------------------------------------------------------
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
    #callback_dungeon_succ{dun_type = DunType, dun_id = DunId, count = Times} = Data,
    #player_status{weekly_card_status = WeeklyCardStatus, dungeon_record = DungeonRecord} = PS,
    #weekly_card_status{is_activity = IsActivity} = WeeklyCardStatus,
    IsAddDunType = lib_dungeon_resource:is_resource_dungeon_type(DunType),
    if
        DunType =:= ?DUNGEON_TYPE_VIP_PER_BOSS -> {ok, lib_weekly_card:add_gift_bag_num(PS)};
        IsAddDunType andalso IsActivity =:= ?ACTIVATION_CLOSE ->
            case maps:find(DunId, DungeonRecord) of
                {ok, RecordData} -> Score = lib_dungeon:calc_record_score(DunId, DunType, RecordData);
                _ -> Score = 0
            end,
            WeeklyCardRewards = lib_dungeon_sweep:calc_weekly_card_reward(#dungeon{id = DunId, type = DunType}, Score, Times),
            %?MYLOG("lwccard","WeeklyCardRewards:~p~n",[{WeeklyCardRewards}]),
            NewWeeklyCardRewards = lib_weekly_card:get_weekly_card_merge_reward_list(WeeklyCardRewards),
            %?MYLOG("lwccard","WeeklyCardRewards, NewWeeklyCardRewards:~p~n",[{WeeklyCardRewards, NewWeeklyCardRewards}]),
            lib_weekly_card:store_reward_list(PS, ?WEEKLY_CARD_DUNGEON, DunType, NewWeeklyCardRewards);
        true -> {ok, PS}
    end;

handle_event(PS, _) -> {ok, PS}.

%% -----------------------------------------------------------------
%% @desc 计算周卡活跃度额外奖励
%% @param
%% @return
%% -----------------------------------------------------------------
cale_activity_reward(Player, Reward) ->
    #player_status{weekly_card_status = WeeklyCardStatus}= Player,
    #weekly_card_status{is_activity = IsActivity} = WeeklyCardStatus,
    [{Type, GoodsId, Num}] = Reward,
    case IsActivity =:= ?ACTIVATION_OPEN of
        true ->
            NewReward = [{Type, GoodsId, Num * ?WEEKLY_CARD_DAILY_ACTIVITY}],
            NewPS = Player;
        false ->
            NewReward = Reward,
            {ok, NewPS} = lib_weekly_card:store_reward_list(Player, ?WEEKLY_CARD_ACTIVITY, 1, NewReward)
    end,
    {NewReward, NewPS}.

%% -----------------------------------------------------------------
%% @desc 凌晨4点刷新周卡
%% @param
%% @return
%% -----------------------------------------------------------------
daily_refresh() ->
    spawn(fun()->
        OnlineRoleIds = lib_online:get_online_ids(),
        [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_weekly_card, refresh_weekly_card, []) || RoleId <- OnlineRoleIds]
          end).

%% -----------------------------------------------------------------
%% @desc 修复嗨点副本次数秘籍（后台）
%% @param
%% @return
%% -----------------------------------------------------------------
gm_compensation_dungeon_times(SubType) ->
    List = [{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, ?DUNGEON_TYPE_SPRITE_MATERIAL}, {?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, ?DUNGEON_TYPE_COIN}],
    FA = fun({ModuleA, SubModuleA, TypeA}) ->
        DBList = lib_weekly_card_sql:db_select_reissue_role(ModuleA, SubModuleA, TypeA, utime:unixdate(), utime:unixdate() + ?ONE_DAY_SECONDS),
        FB = fun(DB) ->
            [RoleId, Module, _SubModule, Type, Count, _Other, _RefreshTime] = DB,
            lib_hi_point:save_hi_point_status(RoleId, SubType, Module, Type, ?SINGLE, Count)
        end,
        lists:foreach(FB, DBList)
    end,
    lists:foreach(FA, List),
    gen_server:cast(mod_hi_point, {'gm_compensation_dungeon_times'}).

%% -----------------------------------------------------------------
%% @desc 过期时间统一调到第二天凌晨4点（后台）
%% @param
%% @return
%% -----------------------------------------------------------------
gm_delay_next_day_four_clock() ->
    DBWeeklyCardList = lib_weekly_card_sql:db_select_unexpired_weekly_card(),
    F = fun(DBWeeklyCard, ResultList) ->
        [RoleId, Lv, Exp, _IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime, _RewardList] = DBWeeklyCard,
        TemRewardList = util:bitstring_to_term(_RewardList),
        NewExpiredTime = utime:get_next_unixdate_four(ExpiredTime),
        lib_log_api:log_weekly_card_open(RoleId, 0, NewExpiredTime),
        RewardList = [{Type, lib_goods_api:make_reward_unique(List)} || {Type, List} <- TemRewardList],
        [[RoleId, Lv, Exp, ?ACTIVATION_OPEN, GiftBagNum, CanReceiveGift, NewExpiredTime, util:term_to_string(RewardList)] | ResultList]
    end,
    NewResultList = lists:foldl(F, [], DBWeeklyCardList),
    length(NewResultList) =/= 0 andalso lib_weekly_card_sql:db_batch_replace_weekly_card_info(NewResultList).

%% -----------------------------------------------------------------
%% @desc 过期时间统一调到第二天凌晨4点（根据角色）
%% @param
%% @return
%% -----------------------------------------------------------------
gm_delay_next_day_four_clock_by_role_id(_RoleList) ->
    RoleList = util:string_to_term(_RoleList),
    F = fun(RoleId, ResultList) ->
        DBWeeklyCardList = lib_weekly_card_sql:db_get_weekly_card_info(RoleId),
        [Lv, Exp, _IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime, _RewardList] = hd(DBWeeklyCardList),
        TemRewardList = util:bitstring_to_term(_RewardList),
        NewExpiredTime = utime:get_next_unixdate_four(ExpiredTime),
        lib_log_api:log_weekly_card_open(RoleId, 0, NewExpiredTime),
        RewardList = [{Type, lib_goods_api:make_reward_unique(List)} || {Type, List} <- TemRewardList],
        [[RoleId, Lv, Exp, ?ACTIVATION_OPEN, GiftBagNum, CanReceiveGift, NewExpiredTime, util:term_to_string(RewardList)] | ResultList]
    end,
    NewResultList = lists:foldl(F, [], RoleList),
    lib_weekly_card_sql:db_batch_replace_weekly_card_info(NewResultList).

%% -----------------------------------------------------------------
%% @desc 周卡回退培养线输出版(后台)
%% @param
%% @return
%% -----------------------------------------------------------------
gm_correct_mount(_CorrectList) ->
    CorrectList = util:string_to_term(_CorrectList),
    F = fun(Correct, TempResultMap) ->
        {RoleId, MountGoods, SpiritGoods, FlyGoods, HolyorganGoods, ArtifactGoods} = Correct,
        SumList = [MountGoods, SpiritGoods, FlyGoods, HolyorganGoods, ArtifactGoods],
        CorrectResultList = get_correct_list(RoleId, SumList),
        maps:put(RoleId, CorrectResultList, TempResultMap)
    end,
    lists:foldl(F, #{}, CorrectList).

%% -----------------------------------------------------------------
%% @desc
%% @param
%% @return
%% -----------------------------------------------------------------
get_correct_list(RoleId, SumList) ->
    F = fun(Goods, TempResultLst) ->
        {TypeId, Num} = Goods,
        DBPlayerMount = lib_weekly_card_sql:db_select_player_mount(RoleId, TypeId),
        DBPlayerLow = lib_weekly_card_sql:db_select_player_low(RoleId),
        [RoleId, TypeId, Stage, Star, Blessing, _BaseAttr, _IllusionType, _IllusionId, _IllusionColor, _IsRide, _FigureId, _AutoBuy, _ETime] = DBPlayerMount,
        [RoleId, _NickName, _Sex, _Lv, Career] = DBPlayerLow,
        case Num * 10 > Blessing of
            true ->
                CorrectBlessing = Num * 10 - Blessing,
                {NewStage, NewStar, NewBlessing} = correct_stage_star_blessing(TypeId, Stage, Star, 0, CorrectBlessing, Career);
            false ->
                NewStage = Stage,
                NewStar = Star,
                NewBlessing = Blessing - Num * 10
        end,
        [{TypeId, {Stage, NewStage}, {Star, NewStar}, {Blessing, NewBlessing}} | TempResultLst]
    end,
    lists:foldl(F, [], SumList).

%% -----------------------------------------------------------------
%% @desc
%% @param
%% @return
%% -----------------------------------------------------------------
correct_stage_star_blessing(_TypeId, Stage, Star, Blessing, 0, _Career) -> {max(?MIN_STAGE, Stage), max(?MIN_STAR, Star), Blessing};
correct_stage_star_blessing(TypeId, Stage, Star, _Blessing, CorrectBlessing, Career) ->
    case Star =:= ?MIN_STAR of
        true ->
            NewStage = Stage - 1,
            #mount_stage_cfg{max_star = MaxStar} = data_mount:get_stage_cfg(TypeId, NewStage, Career),
            NewStar = MaxStar;
        false ->
            NewStage = Stage,
            NewStar = Star - 1
    end,
    #mount_star_cfg{max_blessing = MaxBlessing} = data_mount:get_star_cfg(TypeId, NewStage, NewStar),
    case CorrectBlessing >= MaxBlessing of
        true ->
            NewCorrectBlessing = CorrectBlessing - MaxBlessing,
            correct_stage_star_blessing(TypeId, NewStage, NewStar, 0, NewCorrectBlessing, Career);
        false ->
            NewBlessing = MaxBlessing - CorrectBlessing,
            correct_stage_star_blessing(TypeId, NewStage , NewStar, NewBlessing, 0, Career)
    end.

%% -----------------------------------------------------------------
%% @desc 周卡回退培养线正式版(后台)
%% @param
%% @return
%% -----------------------------------------------------------------
gm_correct_mount_formal(_CorrectList) ->
    CorrectList = util:string_to_term(_CorrectList),
    F = fun(Correct) ->
        {RoleId, MountGoods, SpiritGoods, FlyGoods, HolyorganGoods, ArtifactGoods} = Correct,
        case lib_player:is_online_global(RoleId) of
            false -> skip;
            _ ->
        SumList = [MountGoods, SpiritGoods, FlyGoods, HolyorganGoods, ArtifactGoods],
        timer:sleep(50),
        lib_offline_player:clear_player_info(RoleId),
        CorrectResultList = get_correct_list_formal(RoleId, SumList),
        lib_weekly_card_sql:db_batch_replace_player_mount(CorrectResultList),
        lib_mail_api:send_sys_mail([RoleId], utext:get(4520003), utext:get(4520004), []),
                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_weekly_card_api, correct_mount_formal_event, [])
        end
    end,
   lists:foreach(F, CorrectList).

%% -----------------------------------------------------------------
%% @desc
%% @param
%% @return
%% -----------------------------------------------------------------
get_correct_list_formal(RoleId, SumList) ->
    F = fun(Goods, TempResultLst) ->
        {TypeId, Num} = Goods,
        DBPlayerMount = lib_weekly_card_sql:db_select_player_mount(RoleId, TypeId),
        DBPlayerLow = lib_weekly_card_sql:db_select_player_low(RoleId),
        [RoleId, TypeId, Stage, Star, Blessing, _BaseAttr, IllusionType, IllusionId, _IllusionColor, _IsRide, FigureId, _AutoBuy, _ETime] = DBPlayerMount,
        [RoleId, _NickName, _Sex, _Lv, Career] = DBPlayerLow,
        case Num * 10 > Blessing of
            true ->
                CorrectBlessing = Num * 10 - Blessing,
                {NewStage, NewStar, NewBlessing} = correct_stage_star_blessing(TypeId, Stage, Star, 0, CorrectBlessing, Career);
            false ->
                NewStage = Stage,
                NewStar = Star,
                NewBlessing = Blessing - Num * 10
        end,
        case IllusionType =:= ?BASE_MOUNT_FIGURE of
            true ->
                NewIllusionId = NewStage,
                #mount_stage_cfg{figure = CfgFigureId} = data_mount:get_stage_cfg(TypeId, NewIllusionId, Career),
                NewFigureId =CfgFigureId;
            false ->
                NewIllusionId = IllusionId,
                NewFigureId = FigureId
        end,
        %% 日志
        lib_log_api:log_mount_upgrade_star(RoleId, TypeId, Stage, Star, Blessing, Num * 10, NewStage, NewStar, NewBlessing, [], utime:unixtime()),
        [[RoleId, TypeId, NewStage, NewStar, NewBlessing, _BaseAttr, IllusionType, NewIllusionId, _IllusionColor, _IsRide, NewFigureId, _AutoBuy, _ETime] | TempResultLst]
    end,
    lists:foldl(F, [], SumList).

%% -----------------------------------------------------------------
%% @desc
%% @param
%% @return
%% -----------------------------------------------------------------
correct_mount_formal_event(Player) ->
    List = [?MOUNT_ID, ?MATE_ID, ?FLY_ID, ?ARTIFACT_ID, ?HOLYORGAN_ID],
    F = fun(TypeId) ->
        case TypeId of
            ?MOUNT_ID ->
                refresh_common_rank(Player,?RANK_TYPE_MOUNT),
                lib_rush_rank_api:gm_refresh_rush_rank(Player);
            ?MATE_ID ->
                refresh_common_rank(Player,?RANK_TYPE_MATE),
                lib_rush_rank_api:gm_refresh_rush_rank(Player);
            ?HOLYORGAN_ID -> refresh_common_rank(Player,?RANK_TYPE_HOLYORGAN);
            ?ARTIFACT_ID -> refresh_common_rank(Player,?RANK_TYPE_AIRCRAFT);
            ?FLY_ID ->
                refresh_common_rank(Player,?RANK_TYPE_WING),
                lib_rush_rank_api:gm_refresh_rush_rank(Player);
            _ -> skip
        end
    end,
    lists:foreach(F, List),
    {ok, Player}.

%% -----------------------------------------------------------------
%% @desc 周卡培养现回退修正排行榜
%% @param
%% @return
%% -----------------------------------------------------------------
refresh_common_rank(Player, RankType) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    case Lv >= lib_module:get_open_lv(?MOD_RANK, 1) of
        true ->
            lib_common_rank:refresh_common_rank(RankType, Player),
            case is_list(RankType) of
                true -> RankTypeList = RankType;
                false -> RankTypeList = [RankType]
            end,
            F = fun(RankTypeA) -> lib_common_rank:get_refresh_list_by_rank_type(RankTypeA, Player) end,
            DeepList = lists:map(F, RankTypeList),
            List = lists:flatten(DeepList),
            case List == [] of
                true -> skip;
                false -> mod_common_rank:gm_correct_common_rank_formal(List)
            end;
        _ -> skip
    end.