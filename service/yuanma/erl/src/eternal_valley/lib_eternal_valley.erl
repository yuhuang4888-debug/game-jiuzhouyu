%%-----------------------------------------------------------------------------
%% @Module  :       lib_eternal_valley
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-12
%% @Description:    永恒碑谷
%%-----------------------------------------------------------------------------
-module(lib_eternal_valley).

-include("eternal_valley.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("seal.hrl").
-export([
    login/1
    , logout/2
    , gm_complete_chapter/2
    , gm_reset/1
    , send_chapter_list/2
    , send_chapter_info/3
    , trigger/4
    , receive_stage_reward/3
    , check_chapter_is_finish/2
    , get_finish_count/1
]).

login(RoleId) ->
    ChapterList = db:get_all(io_lib:format(?select_eternal_valley_chapter, [RoleId])),
    StateList = db:get_all(io_lib:format(?select_eternal_valley_stage, [RoleId])),
    Map = init_eternal_valley_chapter(ChapterList, #{}),
    InitStage = init_eternal_valley_stage(StateList, Map),
    InitStage.

logout(RoleId, RoleEternalValley) ->
    F = fun(T, Acc) ->
        case T of
            #stage_status{
                chapter = Chapter,
                stage = Stage,
                progress = Progress,
                extra = Extra,
                status = ?UNFINISH,
                wstatus = ?WSTATUS_WAIT
            } ->
                db:execute(io_lib:format(?update_eternal_valley_stage,
                    [Progress, ?UNFINISH, util:term_to_string(Extra), RoleId, Chapter, Stage])),
                case Acc rem 20 of
                    0 -> timer:sleep(100);
                    _ -> skip
                end,
                Acc + 1;
            _ -> Acc
        end
        end,
    F1 = fun(ChapterStatus, Acc) ->
        #chapter_status{stage_list = StageList, status = Status} = ChapterStatus,
        case Status of
            ?UNFINISH ->
                lists:foldl(F, Acc, StageList);
            _ -> Acc
        end
         end,
    lists:foldl(F1, 1, maps:values(RoleEternalValley)),
    ok.

gm_complete_chapter(Ps, ChapterId) ->
%%    ?PRINT("start ============Chapter:~p~n",[ChapterId]),
    StageIds = data_eternal_valley:get_all_stage(ChapterId),
    #player_status{id = RoleId, eternal_valley = Valley} = Ps,
    ChapterStatus = maps:get(ChapterId, Valley, #chapter_status{}),
    Fun = fun(Stage,TmpChapterStatus) ->
        #chapter_status{stage_list = StageList} = TmpChapterStatus,
        NewStageList = lists:keystore(Stage, #stage_status.stage,StageList,#stage_status{chapter = ChapterId,stage = Stage,status = ?FINISH}),
%%        ?PRINT("NewStageList :~p~n",[NewStageList]),
        db:execute(io_lib:format(?replace_eternal_valley_stage, [RoleId, ChapterId, Stage, 1, ?FINISH, util:term_to_string([])])),
        ?PRINT("'~s' ~n", [io_lib:format(?replace_eternal_valley_stage, [RoleId, ChapterId, Stage, 1, ?FINISH, util:term_to_string([])])]),
        NewChapterStatus = TmpChapterStatus#chapter_status{status = ?FINISH, stage_list = NewStageList},
        NewChapterStatus
          end,
    NChapterStatus= lists:foldl(Fun, ChapterStatus,StageIds),
%%    ?PRINT("end ============StageIds:~p~n",[StageIds]),
    NewValley = maps:put(ChapterId, NChapterStatus, Valley),
    db:execute(io_lib:format(?update_eternal_valley_chapter, [RoleId, ChapterId, ?FINISH])),
%%    ?PRINT("end ============NewValley:~p~n",[NewValley]),
    NewPs = Ps#player_status{eternal_valley =  NewValley},
    pp_eternal_valley:handle(42401,NewPs,[]),
    NewPs.

gm_reset(Ps) ->
    db:execute(io_lib:format("delete from eternal_valley_chapter where role_id = ~p", [Ps#player_status.id])),
    db:execute(io_lib:format("delete from eternal_valley_stage where role_id = ~p", [Ps#player_status.id])),
    NewPs = Ps#player_status{eternal_valley = #{}},
    pp_eternal_valley:handle(42401, NewPs, []),
    NewPs.

init_eternal_valley_chapter([], Map) -> Map;
init_eternal_valley_chapter([[Chapter, Status] | L], Map) ->
    ChapterStatus = maps:get(Chapter, Map, #chapter_status{chapter = Chapter}),
    NewChapterStatus = ChapterStatus#chapter_status{status = Status},
    NewMap = maps:put(Chapter, NewChapterStatus, Map),
    init_eternal_valley_chapter(L, NewMap);
init_eternal_valley_chapter([_ | L], Map) ->
    init_eternal_valley_chapter(L, Map).

init_eternal_valley_stage([], Map) -> Map;
init_eternal_valley_stage([[Chapter, Stage, Progress, Status, ExtraStr] | L], Map) ->
    ChapterStatus = maps:get(Chapter, Map, #chapter_status{chapter = Chapter}),
    #chapter_status{stage_list = StageList} = ChapterStatus,
    T = #stage_status{
        chapter = Chapter,
        stage = Stage,
        progress = Progress,
        status = Status,
        extra = util:bitstring_to_term(ExtraStr)
    },
    NewStageList = lists:keystore(Stage, #stage_status.stage, StageList, T),
    NewChapterStatus = ChapterStatus#chapter_status{stage_list = NewStageList},
    NewMap = maps:put(Chapter, NewChapterStatus, Map),
    init_eternal_valley_stage(L, NewMap);

init_eternal_valley_stage([_ | L], Map) ->
    init_eternal_valley_stage(L, Map).

trigger(RoleId, RoleLv, RoleEternalValley, Args) ->
    put(eternal_broadcast_info, []),
    put(eternal_finish_stage_list, []),
    ChapterIds = data_eternal_valley:get_all_chapter(),
    NewRoleEternalValley = do_trigger(ChapterIds, RoleId, RoleEternalValley, Args),
    UpdateChapterIds = erase(eternal_broadcast_info),
    FinStageList = erase(eternal_finish_stage_list),
    %% 完成章节阶段日志
    F1 = fun({TChapter, TStageCfg}) ->
        case TStageCfg of
            #stage_cfg{stage = TStage, condition = TCondition} ->
                lib_log_api:log_eternal_valley_stage(RoleId, TChapter, TStage, TCondition);
            _ -> skip
        end
         end,
    lists:foreach(F1, FinStageList),
    OpenLv = lib_module:get_open_lv(?MOD_ETERNAL_VALLEY, 1),
    case RoleLv >= OpenLv of
        true ->
            RealUChapterIds = UpdateChapterIds,
            case RealUChapterIds =/= [] of
                true ->
                    %% 通知客户端更新数据
                    {ok, BinData} = pt_424:write(42403, [RealUChapterIds]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                false -> skip
            end;
        _ -> skip
    end,
    NewRoleEternalValley.

do_trigger([], _RoleId, RoleEternalValley, _Args) -> RoleEternalValley;
do_trigger([Chapter | L], RoleId, RoleEternalValley, Args) ->
    ChapterStatus = maps:get(Chapter, RoleEternalValley, #chapter_status{chapter = Chapter}),
    #chapter_status{stage_list = StageList, status = Status} = ChapterStatus,
    %% 已经完成不需要重复触发
    case Status == ?UNFINISH of
        true ->
            StageIds = data_eternal_valley:get_all_stage(Chapter),
            {NewStageList, UpdateSign} = do_trigger_stage(StageIds, Chapter, RoleId, StageList, Args, 0),
            case UpdateSign == 1 of
                true ->
                    broadcast_info_add(Chapter);
                _ -> skip
            end,
%%            ?PRINT("NewStageList ~p ~n", [NewStageList]),
            NewChapterStatus = ChapterStatus#chapter_status{stage_list = NewStageList},
            NewRoleEternalValley = maps:put(Chapter, NewChapterStatus, RoleEternalValley);
        false ->
            NewRoleEternalValley = RoleEternalValley
    end,
    do_trigger(L, RoleId, NewRoleEternalValley, Args).

do_trigger_stage([], _Chapter, _RoleId, StageList, _Args, UpdateSign) -> {StageList, UpdateSign};
do_trigger_stage([Stage | L], Chapter, RoleId, StageList, Args, UpdateSign) ->
    {NeedInsert, OldStageStatus} =
        case lists:keyfind(Stage, #stage_status.stage, StageList) of
            false ->
                NdInsert = true,
                OStageStatus = #stage_status{chapter = Chapter, stage = Stage},
                {NdInsert, OStageStatus};
            OStageStatus ->
                NdInsert = false,
                {NdInsert, OStageStatus}
        end,
    #stage_status{status = Status} = OldStageStatus,
    %% 已经完成不需要重复触发
    case Status == ?UNFINISH of
        true ->
            case data_eternal_valley:get_stage_cfg(Chapter, Stage) of
                #stage_cfg{condition = Condition} = StageCfg ->
                    {NewStageStatus, NewUpdateSign} = do_trigger_core(Args, Condition, OldStageStatus, UpdateSign),
                    #stage_status{
                        progress = NewProgress,
                        status = NewStatus,
                        extra = NewExtra,
                        wtime = LastWtime
                    } = NewStageStatus,
                    case NewProgress =/= OldStageStatus#stage_status.progress of
                        true ->
                            case NewStatus of
                                ?FINISH ->
                                    finish_stage_add(Chapter, StageCfg);
                                _ -> skip
                            end,
                            NowTime = utime:unixtime(),
                            SaveDBCD = case Args of
                                           [{attr, _}] -> 1800;
                                           _ -> ?SAVE_DB_CD
                                       end,
                            case NewStatus == ?FINISH orelse LastWtime == 0 orelse NowTime - LastWtime >= SaveDBCD of
                                true ->
                                    case NeedInsert of
                                        true ->
                                            db:execute(io_lib:format(?insert_eternal_valley_stage,
                                                [RoleId, Chapter, Stage, NewProgress, NewStatus, util:term_to_string(NewExtra)]));
                                        false ->
                                            db:execute(io_lib:format(?update_eternal_valley_stage,
                                                [NewProgress, NewStatus, util:term_to_string(NewExtra), RoleId, Chapter, Stage]))
                                    end,
                                    LastStageStatus = NewStageStatus#stage_status{wtime = NowTime, wstatus = ?WSTATUS_SUCCESS};
                                _ ->
                                    LastStageStatus = NewStageStatus#stage_status{wstatus = ?WSTATUS_WAIT}
                            end,
                            lib_server_send:send_to_uid(RoleId, pt_424, 42406, [Chapter, Stage, NewProgress, NewStatus]),
                            NewStageList = lists:keystore(Stage, #stage_status.stage, StageList, LastStageStatus);
                        false ->
                            NewStageList = StageList
                    end;
                _ ->
                    NewUpdateSign = UpdateSign,
                    NewStageList = StageList
            end;
        _ ->
            NewUpdateSign = UpdateSign,
            NewStageList = StageList
    end,
    do_trigger_stage(L, Chapter, RoleId, NewStageList, Args, NewUpdateSign).

do_trigger_core([], _, StageStatus, UpdateSign) -> {StageStatus, UpdateSign};
%% 装备A阶W色S星L件(NeedStage, NeedColor, NeedStar, NeedNum)
do_trigger_core([{wear_equip_status, EquipList}|L], [{wear_equip_status, NeedStage, NeedColor, NeedStar, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    F = fun(GoodsInfo, GrandNum) ->
        #goods{goods_id = GoodsTypeId, color = Color} = GoodsInfo,
        EquipStage = lib_equip:get_equip_stage(GoodsTypeId),
        EquipStar = lib_equip:get_equip_star(GoodsTypeId),
        %% 判断是否符合
        Flag = Color >= NeedColor andalso EquipStage >= NeedStage andalso EquipStar >=NeedStar,
        ?IF(Flag, GrandNum + 1, GrandNum)
        end,
    RealNum = lists:foldl(F, 0, EquipList),
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(RealNum, NeedNum, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);
%% 装备N件M阶圣印
do_trigger_core([{seal_status, SealList}|L], [{seal_status, NeedStage, NeedColor, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    F = fun(GoodsInfo, GrandNum) ->
        case GoodsInfo of
            #goods{goods_id = SealId} ->
                case data_seal:get_seal_equip_info(SealId) of
                    #base_seal_equip{stage = Stage, color = Color} when Stage >= NeedStage andalso Color >= NeedColor ->
                        GrandNum + 1;
                    _ -> GrandNum
                end;
            _ -> GrandNum
        end
        end,
    RealNum = lists:foldl(F, 0, SealList),
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(RealNum, NeedNum, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);
%% 符文副本通关N层
do_trigger_core([{rune_dun, Layer}|L], [{rune_dun, NeedLayer}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(Layer, NeedLayer, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);
%% 装备洗练：N阶M件
do_trigger_core([{wash_equip_status, WashStatus}|L], [{wash_equip_status, NeedStage, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    F = fun(_Key, #equip_wash{duan = Duan}, GrandNum) when Duan >= NeedStage -> GrandNum + 1;
        (_Key, _Val, GrandNum) -> GrandNum
        end,
    RealNum = maps:fold(F, 0, WashStatus),
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(RealNum, NeedNum, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);
%% 套装状态
do_trigger_core([{active_suit, SuitNumList}|L], [{active_suit, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    case lists:reverse(lists:keysort(2, SuitNumList)) of
        [{_, RealNum}|_] ->
            {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(RealNum, NeedNum, StageStatus, UpdateSign);
        _ -> NewStageStatus = StageStatus, NewUpdateSign = UpdateSign
    end,
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);
%% 通关指定的龙纹副本
do_trigger_core([{dun_dragon, DunId}|L], [{dun_dragon, DunId}] = Condition, StageStatus, _UpdateSign) ->
    NewUpdateSign = 1,
    NewStatus = ?FINISH,
    NewProgress = 1,
    NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus},
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);
%% 达到多少战力
do_trigger_core([{combat, CurrentCombat}|L], [{combat, NeedCombat}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(CurrentCombat, NeedCombat, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);
%% 月卡投资
do_trigger_core([{month_card} | L], [{month_card, []}] = Condition, StageStatus, _UpdateSign) ->
    NewProgress = 1,
    NewStatus = ?FINISH,
    NewUpdateSign = 1,
    NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus},
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% vip等级
do_trigger_core([{vip, VipLv} | L], [{vip, NeedVipLv}] = Condition, StageStatus, UpdateSign) ->
    case VipLv >= NeedVipLv of
        true ->
            NewProgress = 1,
            NewStatus = ?FINISH,
            NewUpdateSign = 1,
            NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus};
        false ->
            NewUpdateSign = UpdateSign,
            NewStageStatus = StageStatus
    end,
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 钻石投资
do_trigger_core([{diamond_investment} | L], [{diamond_investment, []}] = Condition, StageStatus, _UpdateSign) ->
    NewProgress = 1,
    NewStatus = ?FINISH,
    NewUpdateSign = 1,
    NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus},
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 参与等级投资
do_trigger_core([{stage_invest} | L], [{stage_invest, []}] = Condition, StageStatus, _UpdateSign) ->
    NewProgress = 1,
    NewStatus = ?FINISH,
    NewUpdateSign = 1,
    NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus},
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 首冲
do_trigger_core([{first_recharge} | L], [{first_recharge, []}] = Condition, StageStatus, _UpdateSign) ->
    NewProgress = 1,
    NewStatus = ?FINISH,
    NewUpdateSign = 1,
    NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus},
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 激活魔法阵
do_trigger_core([{active_magic} | L], [{active_magic, []}] = Condition, StageStatus, _UpdateSign) ->
    NewProgress = 1,
    NewStatus = ?FINISH,
    NewUpdateSign = 1,
    NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus},
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 人物战力达到多少以上
do_trigger_core([{battle_power, Power} | L], [{battle_power, NeedPower}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(Power, NeedPower, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 等级达到多少
do_trigger_core([{lv, Lv} | L], [{lv, NeedLv}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(Lv, NeedLv, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 通关xx副本 n 次
do_trigger_core([{dun, DunType, Num} | L], [{dun, DunType, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_add_up(Num, NeedNum, StageStatus, UpdateSign),
    ?PRINT("NewStageStatus ~p ~n", [NewStageStatus]),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 击杀xx boss n 次
do_trigger_core([{boss, BossType, Num} | L], [{boss, BossType, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_add_up(Num, NeedNum, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 加入工会
do_trigger_core([{guild_join} | L], [{guild_join, []}] = Condition, StageStatus, _UpdateSign) ->
    NewProgress = 1,
    NewStatus = ?FINISH,
    NewUpdateSign = 1,
    NewStageStatus = StageStatus#stage_status{progress = NewProgress, status = NewStatus},
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 护送 n 次
do_trigger_core([{husong, Num} | L], [{husong, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_add_up(Num, NeedNum, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 合成装备n 次
do_trigger_core([{compose, Num} | L], [{compose, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_add_up(Num, NeedNum, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 参加竞技场n次
do_trigger_core([{jjc, Num} | L], [{jjc, NeedNum}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_add_up(Num, NeedNum, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

%% 达到指定n转(生)
do_trigger_core([{turn, Turn} | L], [{turn, NeedTurn}] = Condition, StageStatus, UpdateSign) ->
    {NewStageStatus, NewUpdateSign} = do_trigger_core_compare_num(Turn, NeedTurn, StageStatus, UpdateSign),
    do_trigger_core(L, Condition, NewStageStatus, NewUpdateSign);

do_trigger_core([_ | L], Condition, StageStatus, UpdateSign) ->
    do_trigger_core(L, Condition, StageStatus, UpdateSign).

%% 总值对比,比如等级，等级，转生达到多少
do_trigger_core_compare_num(Num, NeedNum, OldStageStatus, OldUpdateSign) ->
    case Num >= NeedNum of
        true ->
            NewUpdateSign = 1,
            NewStatus = ?FINISH,
            NewProgress = NeedNum,
            NewStageStatus = OldStageStatus#stage_status{progress = NewProgress, status = NewStatus};
        false ->
            NewProgress = Num,
            NewUpdateSign = OldUpdateSign,
            NewStageStatus = OldStageStatus#stage_status{progress = NewProgress}
    end,
    {NewStageStatus, NewUpdateSign}.

%% 累计次数对比，比如击杀boss N次， xxx完成多次
do_trigger_core_add_up(AddNum, NeedNum, OldStageStatus, OldUpdateSign) ->
    OldProgress = OldStageStatus#stage_status.progress,
    CurrentProgress = OldProgress + AddNum,
    case CurrentProgress >= NeedNum of
        true ->
            NewUpdateSign = 1,
            NewStatus = ?FINISH,
            NewProgress = NeedNum,
            NewStageStatus = OldStageStatus#stage_status{progress = NewProgress, status = NewStatus};
        false ->
            NewProgress = CurrentProgress,
            NewUpdateSign = OldUpdateSign,
            NewStageStatus = OldStageStatus#stage_status{progress = NewProgress}
    end,
    {NewStageStatus, NewUpdateSign}.

broadcast_info_add(Chapter) ->
    case get(eternal_broadcast_info) of
        Val when is_list(Val) ->
            case lists:member(Chapter, Val) of
                false ->
                    put(eternal_broadcast_info, [Chapter | Val]);
                _ -> skip
            end;
        _ -> skip
    end.

finish_stage_add(Chapter, StageCfg) ->
    case get(eternal_finish_stage_list) of
        Val when is_list(Val) ->
            put(eternal_finish_stage_list, [{Chapter, StageCfg} | Val]);
        _ -> skip
    end.

send_chapter_list(RoleId, RoleEternalValley) ->
    ChapterIds = data_eternal_valley:get_all_chapter(),
    PackList = pack_chapter_list(ChapterIds, RoleEternalValley, []),
%%    ?PRINT("ChapterIds ~p ~n PackList ~p ~n", [ChapterIds, PackList]),
    {ok, BinData} = pt_424:write(42401, [PackList]),
    lib_server_send:send_to_uid(RoleId, BinData).

send_chapter_info(RoleId, RoleEternalValley, Chapter) ->
    ChapterStatus = maps:get(Chapter, RoleEternalValley, #chapter_status{}),
    #chapter_status{status = Status, stage_list = StageList} = ChapterStatus,
    PackStageList = pack_stage_list(StageList, []),
    {ok, BinData} = pt_424:write(42402, [Chapter, Status, PackStageList]),
    lib_server_send:send_to_uid(RoleId, BinData).

receive_stage_reward(Player, Chapter, Stage) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, eternal_valley = RoleEternalValley} = Player,
    case check_chapter_is_unlock(Chapter, RoleEternalValley) of
        true ->
            ChapterStatus = maps:get(Chapter, RoleEternalValley, #chapter_status{}),
            #chapter_status{stage_list = StageList} = ChapterStatus,
            case lists:keyfind(Stage, #stage_status.stage, StageList) of
                #stage_status{status = ?FINISH} ->
                    case data_eternal_valley:get_stage_cfg(Chapter, Stage) of
                        #stage_cfg{reward = Reward} when Reward =/= [] ->
                            case lib_goods_api:can_give_goods(Player, Reward) of
                                true ->
                                    F = fun() ->
                                        {ok, IsFinChapter, NewPlayer} = do_receive_stage_reward(Player, Chapter, Stage),
                                        {ok, IsFinChapter, NewPlayer}
                                        end,
                                    case catch db:transaction(F) of
                                        {ok, IsFinChapter, NewPlayer} ->
                                            %% 永恒碑谷奖励领取日志
                                            lib_log_api:log_eternal_valley_reward(RoleId, Chapter, Stage, Reward),
                                            LastPlayer = lib_goods_api:send_reward(NewPlayer, Reward, eternal_valley_stage_reward, 0, 1),

                                            {ok, BinData} = pt_424:write(42404, [?SUCCESS, Chapter, Stage]),
                                            lib_server_send:send_to_sid(Sid, BinData),

                                            lib_task_api:award_eternal_valley(Player, 1),

                                            case IsFinChapter of
                                                true ->
                                                    case get_unlock_chapter(Chapter) of
                                                        UnlockChapterIds when UnlockChapterIds =/= [] ->
                                                            {ok, BinData1} = pt_424:write(42403, [UnlockChapterIds]),
                                                            lib_server_send:send_to_sid(Sid, BinData1);
                                                        _ -> skip
                                                    end,
                                                    {ok, BinData2} = pt_424:write(42405, [Chapter]),
                                                    lib_server_send:send_to_sid(Sid, BinData2),
                                                    %% 传闻
                                                    lib_chat:send_TV({all}, ?MOD_ETERNAL_VALLEY, Chapter, [Figure#figure.name]),
                                                    %% 章节完成了自动学习解锁的技能
                                                    {ok, LastPlayer1} = lib_skill:auto_learn_skill(LastPlayer, {eternal_valley, Chapter}),
                                                    lib_player:send_attribute_change_notify(LastPlayer1, ?NOTIFY_ATTR),
                                                    lib_supreme_vip_api:eternal_valley_event(RoleId),
                                                    {ok, battle_attr, LastPlayer1};
                                                _ ->
                                                    {ok, LastPlayer}
                                            end;
                                        Err ->
                                            ?ERR("receive_stage_reward err:~p", [Err]),
                                            send_error_code(Sid, ?FAIL)
                                    end;
                                {false, ErrorCode} ->
                                    send_error_code(Sid, ErrorCode)
                            end;
                        _ ->
                            send_error_code(Sid, ?ERRCODE(missing_config))
                    end;
                #stage_status{status = ?HAS_RECEIVE} ->
                    send_error_code(Sid, ?ERRCODE(err424_has_receive_reward));
                _ ->
                    send_error_code(Sid, ?ERRCODE(err424_progress_not_finish))
            end;
        _ -> send_error_code(Sid, ?ERRCODE(err424_chapter_lock))
    end.

do_receive_stage_reward(Player, Chapter, Stage) ->
    #player_status{id = RoldId, eternal_valley = RoleEternalValley} = Player,
    ChapterStatus = maps:get(Chapter, RoleEternalValley, #chapter_status{}),
    #chapter_status{stage_list = StageList} = ChapterStatus,
    StageStatus = lists:keyfind(Stage, #stage_status.stage, StageList),
    %% 更新阶段奖励状态为已领取
    db:execute(io_lib:format(?update_eternal_valley_stage_status, [?HAS_RECEIVE, RoldId, Chapter, Stage])),
    NewStageStatus = StageStatus#stage_status{status = ?HAS_RECEIVE},
    NewStageList = lists:keystore(Stage, #stage_status.stage, StageList, NewStageStatus),
    ChapterIsFin = check_chapter_is_finish(Chapter, NewStageList),
    case ChapterIsFin of
        true -> %% 当前章节的所有阶段奖励都已经领奖了则自动领取章节奖励
            db:execute(io_lib:format(?update_eternal_valley_chapter, [RoldId, Chapter, ?HAS_RECEIVE])),
            NewChapterStatus = ChapterStatus#chapter_status{status = ?HAS_RECEIVE, stage_list = NewStageList},
            NewRoleEternalValley = maps:put(Chapter, NewChapterStatus, RoleEternalValley),
            NewPlayer = Player#player_status{eternal_valley = NewRoleEternalValley},
            {ok, true, NewPlayer};
        false ->
            NewChapterStatus = ChapterStatus#chapter_status{stage_list = NewStageList},
            NewRoleEternalValley = maps:put(Chapter, NewChapterStatus, RoleEternalValley),
            NewPlayer = Player#player_status{eternal_valley = NewRoleEternalValley},
            {ok, false, NewPlayer}
    end.

%% 检查章节是否完成
check_chapter_is_finish(Chapter, StageList) when is_integer(Chapter) ->
    StageIds = data_eternal_valley:get_all_stage(Chapter),
    F = fun(TStage) ->
        case lists:keyfind(TStage, #stage_status.stage, StageList) of
            #stage_status{status = ?HAS_RECEIVE} -> true;
            _ -> false
        end
        end,
    lists:all(F, StageIds);
check_chapter_is_finish(RoleEternalValley, Chapter) when is_map(RoleEternalValley) ->
    ChapterStatus = maps:get(Chapter, RoleEternalValley, #chapter_status{}),
    #chapter_status{status = Status, stage_list = StageList} = ChapterStatus,
    case Status == ?UNFINISH of
        true ->
            StageIds = data_eternal_valley:get_all_stage(Chapter),
            F = fun(TStage) ->
                case lists:keyfind(TStage, #stage_status.stage, StageList) of
                    #stage_status{status = ?HAS_RECEIVE} -> true;
                    _ -> false
                end
                end,
            lists:all(F, StageIds);
        _ -> true
    end;
check_chapter_is_finish(_, _) -> false.

check_chapter_is_unlock(Chapter, RoleEternalValley) ->
    case data_eternal_valley:get_chapter_cfg(Chapter) of
        #chapter_cfg{
            condition = Condition
        } ->
            F = fun(T) ->
                case maps:get(T, RoleEternalValley, false) of
                    #chapter_status{
                        status = ?HAS_RECEIVE
                    } -> true;
                    _ -> false
                end
                end,
            IsTure = lists:all(F, Condition),
            IsTure;
        _ ->
            false
    end.

get_unlock_chapter(FinChapter) ->
    AllChapterIds = data_eternal_valley:get_all_chapter(),
    F = fun(Chapter, Acc) ->
        case data_eternal_valley:get_chapter_cfg(Chapter) of
            #chapter_cfg{condition = Condition} when is_list(Condition) ->
                case lists:member(FinChapter, Condition) of
                    true -> [Chapter | Acc];
                    false -> Acc
                end;
            _ -> Acc
        end
        end,
    lists:foldl(F, [], AllChapterIds).

%% 选出开放的章节内容
pack_chapter_list([], _, Acc) -> Acc;
pack_chapter_list([Chapter | L], RoleEternalValley, Acc) ->
    case check_chapter_is_unlock(Chapter, RoleEternalValley) of
        true ->
            ChapterStatus = maps:get(Chapter, RoleEternalValley, #chapter_status{chapter = Chapter}),
            #chapter_status{status = Status, stage_list = StageList} = ChapterStatus,
            PackStageList = pack_stage_list(StageList, []),
            pack_chapter_list(L, RoleEternalValley, [{Chapter, Status, PackStageList} | Acc]);
        false ->
            pack_chapter_list(L, RoleEternalValley, Acc)
    end.

pack_stage_list([], Acc) -> Acc;
pack_stage_list([T | L], Acc) ->
    #stage_status{
        stage = Stage,
        progress = Progress,
        status = Status,
        extra = Extra
    } = T,
    pack_stage_list(L, [{Stage, Progress, Status, util:term_to_string(Extra)} | Acc]).

%% 获取完成对数量
get_finish_count(Player) ->
    #player_status{eternal_valley = RoleEternalValley} = Player,
    F = fun(Chapter, _, Acc) ->
        case check_chapter_is_finish(RoleEternalValley, Chapter) of
            true -> Acc + 1;
            false -> Acc
        end
    end,
    maps:fold(F, 0, RoleEternalValley).

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    {ok, BinData} = pt_424:write(42400, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).




