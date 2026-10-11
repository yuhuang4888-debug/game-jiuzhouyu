%% ---------------------------------------------------------------------------
%% @doc lib_temple_awaken

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/1
%% @deprecated  神殿觉醒 玩家 进程逻辑处理
%%       大概玩法逻辑：
%%              该模块是一个类似任务系统模块，拥有多个章节任务，每个章节任务有
%%          多个子章节（页），每个子章节有多个阶段任务。
%%      注意点：
%%              改功能有自己的套装外形，如：武器，翅膀，衣服等等，每次变化修改到
%%          Figure字段里面的，有的是修改时装身上的状态，有的则是修改坐骑幻型的状
%%          态。时装的穿脱，坐骑的幻型，当前的模块的穿戴需要注意模块间的相互触发
%%      （很多任务数值都可直接在玩家进程获取，有空可有优化下，部分任务进度不入库，根据进程取值）
%% ---------------------------------------------------------------------------
-module(lib_temple_awaken).

%% API
-export([
      get_figure_list/3                 %% 获取外形数据，用于选择角色时
    , login/1                           %% 登陆
    , offline_login/1                   %% 离线登陆
    , get_attr/1                        %% 获取属性
    , self_receive_stage_reward/2       %% 服务端自动领取章节奖励
    , finish_initial_task/1             %% 完成初始任务（开启觉醒之路）
    , pre_task_status/1                 %% 判断前置任务是否完成
    , send_all_temple_awaken/1          %% 发送所有神殿信息
    , send_chapter_temple_awaken/2      %% 发送指定神殿信息
    , receive_chapter_reward/2          %% 领取章节奖励
    , receive_stage_reward/4            %% 领取子章节阶段奖励
    , ware_model/3                      %% 穿戴指定章节的模型
    , trigger/2                         %% 触发子章节阶段任务状态
    , level_up_unlock/1                 %% 升级调用，判断能否解锁新的章节或子章节阶段任务
    , be_cancel_wear/3                  %% 玩家在其他模块更改自己模型，神殿这边被动脱掉处理(改改状态和数据库就好了，无需弄figure)
    , gm_complete_temple/2              %% GM完成指定章节的任务
    , gm_complete_subchapter/3          %% GM完成指定子章节所有
    , gm_complete_stage/4               %% 完成指定章节阶段任务
    , gm_clear/1                        %% GM清空状态
    , broadcast_info/3                  %% 广播指定指定类型指定Figure
    , get_temple_awaken_status/1        %% 暂时弃用函数（免得生成警告看着难受）
    , auto_check_task/1                     %% 登录后触发（预防数值修改，导致部分任务无法完成）
]).


-include("common.hrl").
-include("server.hrl").
-include("temple_awaken.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("equip_suit.hrl").
-include("attr.hrl").
-include("mount.hrl").
-include("battle.hrl").
-include("seal.hrl").
-include("activitycalen.hrl").
-include("medal.hrl").
-include("rec_baby.hrl").
-include("eudemons.hrl").
-include("god.hrl").

get_figure_list(RoleId, Career, MountFigure) ->
    Sql = io_lib:format(?sql_select_temple_awaken, [RoleId]),
    ChapterListDB = db:get_all(Sql),
    F = fun
            ([ChapterId, _Status, ?IS_WARE], GrandFigure) ->
                case data_temple_awaken:get_career_suit(ChapterId, Career) of
                    #base_temple_awaken_suit{figure_id = FigureId} ->
                        #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(ChapterId),
                        lists:keystore(TypeId, 1, GrandFigure, {TypeId, FigureId})
                end;
            ([_ChapterId, _Status, _IsWare], GrandFigure) -> GrandFigure
        end,
    ResFigure = lists:foldl(F, MountFigure, ChapterListDB),
    ResFigure.

login(Ps) ->
    #player_status{id = RoleId, figure = Figure} = Ps,
    Sql1 = io_lib:format(?sql_select_temple_awaken, [RoleId]),
    ChapterListDB = db:get_all(Sql1),
    case ChapterListDB of
        [] ->
            %% 没数据也初始化吧，该模块涉及一些主线的任务流程
            {ok, NewPs} = init_temple_awaken(Ps),
            NewPs;
        _ ->
            Sql2 = io_lib:format(?sql_select_temple_awaken_sub, [RoleId]),
            SubChapterListDB = db:get_all(Sql2),
            Sql3 = io_lib:format(?sql_select_temple_awaken_stage, [RoleId]),
            StageSubChapterListDB = db:get_all(Sql3),
            SubChapterList = pack_record(SubChapterListDB, StageSubChapterListDB, []),
            F = fun([ChapterId, Status, IsWare], {GrandList, GrandAttr, GrandWearType}) ->
                {ChapterId, SubChapters} = ulists:keyfind(ChapterId, 1, SubChapterList, {ChapterId, []}),
                ChapterInfo = #chapter_status{chapter_id = ChapterId, status = Status, sub_chapters = SubChapters, is_ware = IsWare},
                NewGrandList = [{ChapterId, ChapterInfo}|GrandList],
                #base_temple_awaken{attr = Attr, pos_type = PosType} = data_temple_awaken:get_temple_awaken(ChapterId),
                NewGrandAttr = ?IF(Status == ?TEMPLE_GOT, lib_player_attr:add_attr(list, [GrandAttr, Attr]), GrandAttr),
                NewGrandWearType = ?IF(IsWare == ?IS_WARE, [{ChapterId, PosType}|GrandWearType], GrandWearType),
                {NewGrandList, NewGrandAttr, NewGrandWearType}
                end,
            {TempleAwakenMapList, SumAttr, WearChapterTypes} = lists:foldl(F, {[], [], []}, ChapterListDB),
            TempleAwakenMap = maps:from_list(TempleAwakenMapList),
%%            TempleAllStatus = get_temple_awaken_status(TempleAwakenMapList),
            NewFigure = fix_figure_model(Figure, WearChapterTypes),
            TempleAll = #status_temple_awaken{temple_awaken_map = TempleAwakenMap, sum_attr = SumAttr},
            Ps#player_status{temple_awaken = TempleAll, figure = NewFigure}
    end.

offline_login(Ps) ->
    #player_status{id = RoleId} = Ps,
    Sql1 = io_lib:format(?sql_select_temple_awaken, [RoleId]),
    ChapterListDB = db:get_all(Sql1),
    case ChapterListDB of
        [] -> TempleAwaken = #status_temple_awaken{};
        _ ->
            Sql2 = io_lib:format(?sql_select_temple_awaken_sub, [RoleId]),
            SubChapterListDB = db:get_all(Sql2),
            Sql3 = io_lib:format(?sql_select_temple_awaken_stage, [RoleId]),
            StageSubChapterListDB = db:get_all(Sql3),
            SubChapterList = pack_record(SubChapterListDB, StageSubChapterListDB, []),
            F = fun([ChapterId, Status, IsWare], {GrandList, GrandAttr}) ->
                {ChapterId, SubChapters} = ulists:keyfind(ChapterId, 1, SubChapterList, {ChapterId, []}),
                ChapterInfo = #chapter_status{chapter_id = ChapterId, status = Status, sub_chapters = SubChapters, is_ware = IsWare},
                NewGrandList = [{ChapterId, ChapterInfo}|GrandList],
                #base_temple_awaken{attr = Attr} = data_temple_awaken:get_temple_awaken(ChapterId),
                NewGrandAttr = ?IF(Status == ?TEMPLE_GOT, lib_player_attr:add_attr(list, [GrandAttr, Attr]), GrandAttr),
                {NewGrandList, NewGrandAttr}
                end,
            {TempleAwakenMapList, SumAttr} = lists:foldl(F, {[], []}, ChapterListDB),
            TempleAwakenMap = maps:from_list(TempleAwakenMapList),
            TempleAwaken = #status_temple_awaken{temple_awaken_map = TempleAwakenMap, sum_attr = SumAttr}
    end,
    Ps#player_status{temple_awaken = TempleAwaken}.

%% 自动检查任务是否完成
%% 完整登录后执行，防止策划修改奇怪的数值导致任务无法完成
%% 解锁新的章节后异步执行下
auto_check_task(Ps) ->
    #player_status{temple_awaken = StatusTempleAwaken} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = StatusTempleAwaken,
    Fun = fun(_ChapterId, ChapterInfo) ->
        case ChapterInfo of
            #chapter_status{status = ?TEMPLE_PROCESS, chapter_id = ChapterId} ->
                Fun_1 = fun
                    (#sub_chapter_status{status = ?SUBTEMPLE_PROCESS, sub_chapter = SubChapter}=SubChapterInfo)->
                        NewStageList = auto_check_stage(Ps, ChapterId, SubChapter, SubChapterInfo#sub_chapter_status.stage_lists),
                        SubChapterInfo#sub_chapter_status{stage_lists = NewStageList};
                    (SubChapterInfo) -> SubChapterInfo
                end,
                NewSubChapterInfos = lists:map(Fun_1, ChapterInfo#chapter_status.sub_chapters),
                ChapterInfo#chapter_status{sub_chapters = NewSubChapterInfos};
            _ -> ChapterInfo
        end
        end,
    NewTempleAwakenMap = maps:map(Fun, TempleAwakenMap),
    NewPs = Ps#player_status{temple_awaken = StatusTempleAwaken#status_temple_awaken{temple_awaken_map = NewTempleAwakenMap}},
    {ok, NewPs}.

get_attr(Ps) ->
    Ps#player_status.temple_awaken#status_temple_awaken.sum_attr.

%% 自动触发任务
auto_check_stage(Ps, ChapterId, SubChapter, StageList) ->
    #player_status{id = RoleId} = Ps,
    {IsChange, ChangeStageList} = do_trigger(Ps, ChapterId, SubChapter, StageList, [trigger], [], false),
    if
        not IsChange -> StageList;
        true ->
            ChangeStageListKv =
                [begin
                     lib_server_send:send_to_uid(RoleId, pt_429, 42905, [ChapterId, SubChapter, VStage, VProcess, VStatus]),
                     [RoleId, ChapterId, SubChapter, VStage, VProcess, VStatus]
                 end
                    ||#stage_chapter_status{stage = VStage, process = VProcess, status = VStatus}<-ChangeStageList],
            F_replace = fun(#stage_chapter_status{stage = Stage} = Item, GrandList) -> lists:keystore(Stage, #stage_chapter_status.stage, GrandList, Item) end,
            %% 日志记录下，直接循环记录即可，日志进程有做缓存不必担心执行多条sql
            [log_temple_awaken_chapter_stage(RoleId, ChapterId, KSubChapter, KStage, KProcess, KStatus)||[_, _, KSubChapter, KStage, KProcess, KStatus]<-ChangeStageListKv],
            Sql = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], ChangeStageListKv),
            ?IF(Sql =/= [], db:execute(Sql), skip),
            %?MYLOG("lzhtemple", "auto_check_stage ChangeStageListKv ~p ~n", [ChangeStageListKv]),
            NewStageList = lists:foldl(F_replace, StageList, ChangeStageList),
            lib_popup:fin_temple_chapter(Ps, NewStageList, {ChapterId, SubChapter}), % 弹窗
            NewStageList
    end.

%% Figure处理
%% 根据章节类型修改Figure中的 mount_figure 或 fashion_model值
fix_figure_model(Figure, []) -> Figure;
fix_figure_model(Figure, [ChapterId|T]) when is_integer(ChapterId) ->
    #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(ChapterId),
    fix_figure_model(Figure, [{ChapterId, TypeId}|T]);
fix_figure_model(Figure, [{ChapterId, TypeId}|T]) ->
    #figure{career = Career, mount_figure_ride = MFigureRide, mount_figure = MFigure} = Figure,
    #base_temple_awaken_suit{figure_id = FigureId} = data_temple_awaken:get_career_suit(ChapterId, Career),
    %% 走坐骑唤醒Figure
    NewMFigure = lists:keystore(TypeId, 1, MFigure, {TypeId, FigureId}),
    NewMFigureRide = lists:keystore(TypeId, 1, MFigureRide, {TypeId, 1}),
    NewFigure = Figure#figure{mount_figure = NewMFigure, mount_figure_ride = NewMFigureRide},
    fix_figure_model(NewFigure, T).

%% 打包成sub record
%% @return [{ChapterId, [#sub_chapter_status{}|_]}]
pack_record([], _StageSubChapterList, GrandSubList) -> GrandSubList;
pack_record([SubTemple|T], StageSubChapterList, GrandSubList) ->
    [ChapterId, SubChapter, Status] = SubTemple,
    StageList = [#stage_chapter_status{
        stage = SStage,
        process = SProcess,
        status = SStatus
    }||[SChapterId, SSubChapter, SStage, SProcess, SStatus]<-StageSubChapterList, SChapterId == ChapterId andalso SSubChapter == SubChapter],
    SubChapterInfo = #sub_chapter_status{sub_chapter = SubChapter, status = Status, stage_lists = StageList},
    {_, SubChapterInfoList} = ulists:keyfind(ChapterId, 1, GrandSubList, {ChapterId, []}),
    NewSubChapterInfoList = [SubChapterInfo|SubChapterInfoList],
    NewGrandSubList = lists:keystore(ChapterId, 1, GrandSubList, {ChapterId, NewSubChapterInfoList}),
    pack_record(T, StageSubChapterList, NewGrandSubList).

%%====================================================Export Methods Begin=============================================================================

%% 自动领取服务端章节奖励
%% 需求更改了，原本是客户端手动发，改成了服务端自动领取
%% 用apply_cast来触发方便，不改那么多了，第3次改版顶不住
self_receive_stage_reward(Ps, ChapterId) ->
    {ok, NewPs} = pp_temple_awaken:handle(42906, Ps, [ChapterId]),
    mod_scene_agent:update(NewPs, [{battle_attr, NewPs#player_status.battle_attr}]),
    {ok, NewPs}.

%% 开启觉醒之路
finish_initial_task(Ps) ->
    #player_status{id = RoleId, tid = TId} = Ps,
    {PreTaskId, _CurrentTaskId} = ?AWAKEN_TASK_INFO,
    IsFinish = mod_counter:get_count(RoleId, ?MOD_TEMPLE_AWAKEN, 1) >= 1,
    if
        IsFinish -> {false, ?ERRCODE(err300_fin)};
        true ->
            case mod_task:is_finish_task_id(TId, PreTaskId) of
                false -> {false, ?ERRCODE(err164_not_trigger_task)};
                true ->
                    lib_task_api:open_temple_awaken(Ps),
                    mod_counter:increment(RoleId, ?MOD_TEMPLE_AWAKEN, 1),
%%                    init_temple_awaken(Ps)
                    {ok, NewPs} = lib_temple_awaken_event:finish_main_task(Ps),
                    {ok, NewPs}
            end
    end.

pre_task_status(Ps) ->
    #player_status{sid = Sid, tid = TId} = Ps,
    {PreTaskId, _CurrentTaskId} = ?AWAKEN_TASK_INFO,
    case mod_task:is_finish_task_id(TId, PreTaskId) of
        false ->
            lib_server_send:send_to_sid(Sid, pt_429, 42909, [0]);
        true ->
            lib_server_send:send_to_sid(Sid, pt_429, 42909, [1])
    end.


%% 发送所有神殿觉醒信息
send_all_temple_awaken(Ps) ->
    #player_status{id = RoleId, sid = Sid, temple_awaken = #status_temple_awaken{temple_awaken_map = TempleAwakenMap}} = Ps,
    F = fun(ChapterId, ChapterInfo, GrandList) ->
        #chapter_status{status = ChapterStatus, sub_chapters = SubChapters, is_ware = IsWare} = ChapterInfo,
        case ChapterStatus of
            ?TEMPLE_LOCK -> GrandList;
            _ ->
                SendSubList = [begin
                                   SendStageList = [{Stage, StageStatus, Process}||#stage_chapter_status{status = StageStatus, process = Process, stage = Stage}<-StageList],
                                   {SubChapter, SubStatus, SendStageList}
                               end||#sub_chapter_status{sub_chapter = SubChapter, status = SubStatus, stage_lists = StageList}<-SubChapters],
                GrandItem = {ChapterId, ChapterStatus, IsWare, SendSubList},
                [GrandItem|GrandList]
        end
        end,
    SendList = maps:fold(F, [], TempleAwakenMap),
    %% 前置任务是否开启
    IsComplete = mod_counter:get_count(RoleId, ?MOD_TEMPLE_AWAKEN, 1),
%%    ?MYLOG("zhtemple", "RoleId ~p, TempleAwakenMap ~p SendList ~p ~n", [RoleId, TempleAwakenMap, SendList]),
%%    ?PRINT( "RoleId ~p, SendList ~p ~n", [RoleId, SendList]),
    lib_server_send:send_to_sid(Sid, pt_429, 42901, [IsComplete, SendList]),
    ok.

%% 发送神殿觉醒章节信息
send_chapter_temple_awaken(Ps, ChapterId) ->
    #player_status{sid = Sid, temple_awaken = #status_temple_awaken{temple_awaken_map = TempleAwakenMap}} = Ps,
    case maps:get(ChapterId, TempleAwakenMap, false) of
        false -> skip;
        #chapter_status{status = ?TEMPLE_LOCK} -> skip;
        #chapter_status{status = ChapterStatus, sub_chapters = SubChapters} ->
            SendSubList = [begin
                               SendStageList = [{Stage, StageStatus, Process}||#stage_chapter_status{status = StageStatus, process = Process, stage = Stage}<-StageList],
                               {SubChapter, SubStatus, SendStageList}
                           end||#sub_chapter_status{sub_chapter = SubChapter, status = SubStatus, stage_lists = StageList}<-SubChapters],
%%    ?MYLOG("zhtemple", "RoleId ~p TempleAwakenMap ~p Info ~p ~n", [Ps#player_status.id, TempleAwakenMap, [ChapterId, ChapterStatus, SendSubList]]),
            lib_server_send:send_to_sid(Sid, pt_429, 42902, [ChapterId, ChapterStatus, SendSubList])
    end,
    ok.

%% 领取章节奖励
%% 领取奖励后判断能否解锁下一章节
%% 若能解锁则一并解锁新的章节
%% 同时激活对应幻型并穿戴
receive_chapter_reward(Ps, ChapterId) ->
    #player_status{id = RoleId, temple_awaken = TempleAwaken, figure = #figure{career = Career}} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    case maps:get(ChapterId, TempleAwakenMap, false) of
        false ->
            {false, ?ERRCODE(err429_lock_temple)};
        #chapter_status{status = ?TEMPLE_LOCK} ->
            {false, ?ERRCODE(err429_lock_temple)};
        #chapter_status{status = ?TEMPLE_PROCESS} ->
            {false, ?ERRCODE(err429_no_complete)};
        #chapter_status{status = ?TEMPLE_GOT} ->
            {false, ?ERRCODE(err429_had_got)};
        ChapterInfo ->
            %% 判断能否解锁下一个章节
            case check_unlock_next_chapter(Ps, ChapterId) of
                {true, NextChapterId} ->
                    F = fun() ->
                        NewChapterInfo = ChapterInfo#chapter_status{status = ?TEMPLE_GOT, is_ware = ?NOT_WARE},
                        TempleAwakenMapTmp = maps:put(ChapterId, NewChapterInfo, TempleAwakenMap),
                        db:execute(io_lib:format(?sql_replace_temple_awaken, [RoleId, ChapterId, ?TEMPLE_GOT, ?NOT_WARE])),
                        AllStages = data_temple_awaken:list_sub_chapter_stage(NextChapterId, ?MIN_SUB_CHAPTER),
                        {UnLockStageInfos, NextChapterInfoTmp} = check_unlock_stage(Ps, NextChapterId, ?MIN_SUB_CHAPTER, AllStages),
                        NextChapterInfo = unlock_chapter(RoleId, NextChapterId, ?MIN_SUB_CHAPTER, UnLockStageInfos, NextChapterInfoTmp),
                        %% 成功解锁并通知下客户端
                        NewTempleAwakenMap = maps:put(NextChapterId, NextChapterInfo, TempleAwakenMapTmp),
                        %% 触发下新的任务
                        lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?MODULE, auto_check_task, []),
                        %%lib_temple_awaken_event:handle_stage_chapter_unlock(Ps#player_status.id, NextChapterId, ?MIN_SUB_CHAPTER, UnLockStageInfos),
                        {true, NewTempleAwakenMap}
                        end;
                _ ->
                    F = fun() ->
                        NewChapterInfo = ChapterInfo#chapter_status{status = ?TEMPLE_GOT, is_ware = ?NOT_WARE},
                        NewTempleAwakenMap = maps:put(ChapterId, NewChapterInfo, TempleAwakenMap),
                        db:execute(io_lib:format(?sql_replace_temple_awaken, [RoleId, ChapterId, ?TEMPLE_GOT, ?NOT_WARE])),
                        {true, NewTempleAwakenMap}
                        end
            end,
            case lib_goods_util:transaction(F) of
                {true, LastTempleAwakenMap} ->
                    #base_temple_awaken_suit{reward = Reward} = data_temple_awaken:get_career_suit(ChapterId, Career),
                    Produce = #produce{type = temple_awake_chapter,reward = Reward, show_tips = ?SHOW_TIPS_1},
                    %% 日志记录下
                    lib_log_api:log_temple_awaken_chapter(RoleId, ChapterId, ?TEMPLE_GOT),
                    %% 搞个传闻？
                    %%TempleAllStatus = get_temple_awaken_status(LastTempleAwakenMap),
                    %% 属性计算
                    #base_temple_awaken{attr = Attr} = data_temple_awaken:get_temple_awaken(ChapterId),
                    NewSumAttr = lib_player_attr:add_attr(list, [Attr, TempleAwaken#status_temple_awaken.sum_attr]),
                    NewTempleAwaken = TempleAwaken#status_temple_awaken{temple_awaken_map = LastTempleAwakenMap, sum_attr = NewSumAttr},
                    NewPs = lib_player:count_player_attribute(Ps#player_status{temple_awaken = NewTempleAwaken}),
                    %% 广播下穿戴状态
                    %% NewFigure = fix_figure_model(Ps#player_status.figure, [ChapterId]),
                    %% SceneUpdArgs = [
                    %%    {back_decora_figure, NewFigure#figure.mount_figure},
                    %%    {back_decora_figure_ride, NewFigure#figure.mount_figure_ride}
                    %% ],
                    %% NewPs = LastPsTmp#player_status{figure = NewFigure},
                    %% 处理与当前figure字段冲突的内容（卸下有冲突的部位）
                    %% #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(ChapterId),
                    %% case TypeId of
                    %%     % 神殿时装
                    %%     11 ->
                    %%         {ok, TakeOffPS} = lib_fashion_api:take_off_other(temple, NewPs);
                    %%     % 神殿神兵
                    %%     5 ->
                    %%         {ok, TakeOffPS} = lib_fashion_api:take_off_other(holyorgan, NewPs);
                    %%     _ ->
                    %%         TakeOffPS = NewPs
                    %% end,
                    %% lib_role:update_role_show(RoleId, [{figure, TakeOffPS#player_status.figure}]),
                    %% broadcast_info(TakeOffPS, ChapterId),
                    %% mod_scene_agent:update(TakeOffPS, SceneUpdArgs),

                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                    LastPs = lib_goods_api:send_reward(NewPs, Produce),
                    {ok, LastPs};
                _Err ->
                    ?ERR("receive_chapter_reward error : ~p ~n", [_Err]),
                    {false, ?FAIL}
            end
    end.

%% 领取阶段奖励
receive_stage_reward(Ps, ChapterId, SubChapter, Stage) ->
    %% 先检查这个章节解锁没，改过版,临时改的有点丑
    case data_temple_awaken:get_temple_awaken_stage(ChapterId, SubChapter, Stage) of
        #base_temple_awaken_stage{open_con = OpenCon} ->
            case check_condition(Ps, OpenCon) of
                true ->
                    do_receive_stage_reward(Ps, ChapterId, SubChapter, Stage);
                _ -> {false, ?LEVEL_LIMIT}
            end;
        _ -> {false, ?MISSING_CONFIG}
    end.

do_receive_stage_reward(Ps, ChapterId,  SubChapter, Stage) ->
    #player_status{id = RoleId, temple_awaken = TempleAwaken} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    case check_receive_stage_reward(TempleAwakenMap, ChapterId, SubChapter, Stage) of
        {false, Errcode} ->
            {false, Errcode};
        {true, ChapterInfo, NewSubChapterInfoTmp} ->
            #chapter_status{sub_chapters = SubChapterList} = ChapterInfo,
            case check_unlock_next_sub_chapter(Ps, ChapterId, NewSubChapterInfoTmp, SubChapterList) of
                nofinish ->
                    %% 领取当前的阶段任务，但未领取所有的阶段任务（当前子章节没完成）
                    %% 子章节状态没改变
                    F = fun() ->
                        db:execute(io_lib:format(?sql_update_temple_awaken_stage1, [?STAGE_GOT, RoleId, ChapterId, SubChapter, Stage])),
                        NewSubChapterStatus = NewSubChapterInfoTmp,
                        NewSubChapterList = lists:keystore(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, NewSubChapterStatus),
                        NewChapterInfo = ChapterInfo#chapter_status{sub_chapters = NewSubChapterList},
                        {true, NewChapterInfo}
                        end;
                {finish, NewSubChapterInfo, NextSubChapterInfo} ->
                    %% 当前子章节的任务都领取完毕，并且解锁了下一个子章节
                    F = fun() ->
                        db:execute(io_lib:format(?sql_update_temple_awaken_stage1, [?STAGE_GOT, RoleId, ChapterId, SubChapter, Stage])),
                        db:execute(io_lib:format(?sql_replace_temple_awaken_sub, [RoleId, ChapterId, SubChapter, ?SUBTEMPLE_COMPLETE])),
                        lib_server_send:send_to_uid(RoleId, pt_429, 42904, [ChapterId, SubChapter, ?SUBTEMPLE_COMPLETE]),
                        #sub_chapter_status{sub_chapter = NextSubChapter, stage_lists = NextStageInfos} = NextSubChapterInfo,
%%                        lib_temple_awaken_event:handle_stage_chapter_unlock(Ps#player_status.id, ChapterId, NextSubChapter, NextStageInfos),
                        db:execute(io_lib:format(?sql_replace_temple_awaken_sub, [RoleId, ChapterId, NextSubChapter, ?SUBTEMPLE_PROCESS])),
                        StageValuesList = [begin
                                               lib_server_send:send_to_uid(RoleId, pt_429, 42905, [ChapterId, SubChapter, VStage, VProcess, VStatus]),
                                               [RoleId, ChapterId, NextSubChapter, VStage, VProcess, VStatus]
                                           end||#stage_chapter_status{stage = VStage, process = VProcess, status = VStatus}<-NextStageInfos],
                        Sql = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], StageValuesList),
                        ?IF(Sql =/= [], db:execute(Sql), skip),
                        %% 通知下客户端新的子章节开了
                        lib_server_send:send_to_uid(RoleId, pt_429, 42904, [ChapterId, NextSubChapter, ?SUBTEMPLE_PROCESS]),
                        %% 触发下新的任务
                        lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?MODULE, auto_check_task, []),
                        %% 异步触发下新的任务
                        NewSubChapterListTmp = lists:keystore(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, NewSubChapterInfo),
                        NewSubChapterList = lists:keystore(NextSubChapter, #sub_chapter_status.sub_chapter, NewSubChapterListTmp, NextSubChapterInfo),
                        NewChapterInfo = ChapterInfo#chapter_status{sub_chapters = NewSubChapterList},
                        %% 日志记录下，放着不太规范，但是方便。有空优化优化
                        lib_log_api:log_temple_awaken_chapter_sub(RoleId, ChapterId, SubChapter, ?SUBTEMPLE_COMPLETE),
                        lib_log_api:log_temple_awaken_chapter_sub(RoleId, ChapterId, NextSubChapter, ?SUBTEMPLE_PROCESS),
                        {true, NewChapterInfo}
                        end;
                {finish, NewSubChapterInfo} ->
                    %% 当前子章节的任务都领取完毕,当前章节的子章节都已全部完成了
                    F = fun() ->
                        db:execute(io_lib:format(?sql_update_temple_awaken_stage1, [?STAGE_GOT, RoleId, ChapterId, SubChapter, Stage])),
                        db:execute(io_lib:format(?sql_replace_temple_awaken_sub, [RoleId, ChapterId, SubChapter, ?SUBTEMPLE_COMPLETE])),
                        lib_server_send:send_to_uid(RoleId, pt_429, 42904, [ChapterId, SubChapter, ?SUBTEMPLE_COMPLETE]),
                        NewSubChapterList = lists:keystore(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, NewSubChapterInfo),
                        db:execute(io_lib:format(?sql_replace_temple_awaken, [RoleId, ChapterId, ?TEMPLE_COMPLETE, ChapterInfo#chapter_status.is_ware])),
                        NewChapterInfo = ChapterInfo#chapter_status{sub_chapters = NewSubChapterList, status = ?TEMPLE_COMPLETE},
                        lib_log_api:log_temple_awaken_chapter_sub(RoleId, ChapterId, SubChapter, ?SUBTEMPLE_COMPLETE),
                        lib_log_api:log_temple_awaken_chapter(RoleId, ChapterId, ?TEMPLE_COMPLETE),
                        lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, lib_temple_awaken, self_receive_stage_reward, [ChapterId]),
                        {true, NewChapterInfo}
                        end
            end,
            case lib_goods_util:transaction(F) of
                {true, NewChapterInfo} ->
                    NewTempleAwakenMap = maps:put(ChapterId, NewChapterInfo, TempleAwakenMap),
                    #base_temple_awaken_stage{reward = Reward} = data_temple_awaken:get_temple_awaken_stage(ChapterId, SubChapter, Stage),
                    Produce = #produce{type = temple_awake_chapter_stage,reward = Reward, show_tips = ?SHOW_TIPS_0},
                    %% 日志记录下
%%                    lib_server_send:send_to_sid(Sid, pt_429, 42907, [?SUCCESS, ChapterId, SubChapter, Stage]),
                    lib_log_api:log_temple_awaken_chapter_stage(RoleId, ChapterId, SubChapter, Stage, 0, ?STAGE_GOT),
                    LastPs = lib_goods_api:send_reward(
                        Ps#player_status{temple_awaken = TempleAwaken#status_temple_awaken{temple_awaken_map = NewTempleAwakenMap}}, Produce),
                    {ok, LastPs};
                _Err ->
                    ?ERR("receive_chapter_stage_reward error : ~p ~n", [_Err]),
                    {false, ?FAIL}
            end
    end.

%% 穿戴章节对应的模型
%% 当前章节任务完成了才能穿戴
ware_model(Ps, Chapter, IsWare) ->
    #player_status{temple_awaken = TempleAwaken} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    case maps:get(Chapter, TempleAwakenMap, false) of
        #chapter_status{status = ?TEMPLE_GOT} = ChapterInfo ->
            do_ware_model(Ps, ChapterInfo, IsWare);
        _ ->
            {false, ?ERRCODE(err429_no_finish)}
    end.

do_ware_model(_Ps, #chapter_status{is_ware = ?IS_WARE}, ?IS_WARE) ->
    {false, ?ERRCODE(err429_had_ware)};
do_ware_model(_Ps, #chapter_status{is_ware = ?NOT_WARE}, ?NOT_WARE) ->
    {false, ?ERRCODE(err429_had_unware)};
do_ware_model(BasePs, ChapterInfo, IsWare) ->
    #player_status{id = RoleId, temple_awaken = TempleAwaken} = BasePs,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    #chapter_status{chapter_id = ChapterId, status = Status} = ChapterInfo,
    NewChapterInfo = ChapterInfo#chapter_status{is_ware = IsWare},
    db:execute(io_lib:format(?sql_replace_temple_awaken, [RoleId, ChapterId, Status, IsWare])),
    NewTempleAwakenMap = maps:put(ChapterId, NewChapterInfo, TempleAwakenMap),
    NewTempleAwaken = TempleAwaken#status_temple_awaken{temple_awaken_map = NewTempleAwakenMap},
    {ok, Ps} = tack_off_mount_type(BasePs, ChapterId, IsWare),
    NewPs = Ps#player_status{temple_awaken = NewTempleAwaken},
%%    LastPs = lib_temple_awaken_event:ware_model_event(NewPs, ChapterInfo, IsWare),
    %% 更新Figure
    NewFigure = ?IF(IsWare == ?IS_WARE, fix_figure_model(NewPs#player_status.figure, [ChapterId]), lib_temple_awaken_event:restore_mount_status(NewPs, ChapterId)),
    SceneUpdArgs = [
        {back_decora_figure, NewFigure#figure.mount_figure},
        {back_decora_figure_ride, NewFigure#figure.mount_figure_ride}
    ],
%%    ?MYLOG("zhtemple", "back_decora_figure ~p ~n back_decora_figure_ride ~p ~n ", [NewFigure#figure.mount_figure, NewFigure#figure.mount_figure_ride]),
    LastPs = NewPs#player_status{figure = NewFigure},
    % 处理与当前figure字段有冲突的内容（卸下有冲突的部位）
    #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(ChapterId),
    if
        IsWare =/= ?IS_WARE -> TakeOffPS = LastPs;
        TypeId =:= 11 -> {ok, TakeOffPS} = lib_fashion_api:take_off_other(temple, LastPs);      % 衣服和发型
        TypeId =:= 5 -> {ok, TakeOffPS} = lib_fashion_api:take_off_other(holyorgan, LastPs);    % 武器
        true -> TakeOffPS = LastPs
    end,
    lib_role:update_role_show(RoleId, [{figure, TakeOffPS#player_status.figure}]),
    lib_team_api:update_team_mb(TakeOffPS, [{figure, TakeOffPS#player_status.figure}]),
    broadcast_info(TakeOffPS, ChapterId),
    mod_scene_agent:update(TakeOffPS, SceneUpdArgs),
    {ok, TakeOffPS}.

init_stage_chapter_list(ChapterId, SubChapterId) ->
    [#stage_chapter_status{stage = Stage}||Stage<-data_temple_awaken:list_sub_chapter_stage(ChapterId, SubChapterId)].

%% 触发任务进度
%% 每次任务只会对当前未完成的子章节进程任务进度更改
trigger(Ps, Args) ->
    #player_status{temple_awaken = TempleAwaken, id = RoleId} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    F_replace = fun(#stage_chapter_status{stage = Stage} = Item, GrandList) -> lists:keystore(Stage, #stage_chapter_status.stage, GrandList, Item) end,
    F = fun(ChapterId, ChapterInfo) ->
        case ChapterInfo of
            #chapter_status{status = ?TEMPLE_PROCESS, sub_chapters = SubChapterList} ->
                F_Sub = fun(SubChapterInfo, {GrandList, GrandChanges}) ->
                    case SubChapterInfo of
                        #sub_chapter_status{status = ?SUBTEMPLE_PROCESS, stage_lists = StageList, sub_chapter = SubChapterId} ->
                            InitList = init_stage_chapter_list(ChapterId, SubChapterId),
                            DealList = lists:foldl(F_replace, InitList, StageList),
                            {IsChange, ChangeStageListTmp} = do_trigger(Ps, ChapterId, SubChapterId, DealList, Args, [], false),
                            if
                                not IsChange -> {[SubChapterInfo|GrandList], GrandChanges};
                                true ->
                                    ChangeStageList =
                                        [begin
                                             lib_server_send:send_to_uid(RoleId, pt_429, 42905, [ChapterId, SubChapterId, VStage, VProcess, VStatus]),
                                             {RoleId, ChapterId, SubChapterId, VStage, VProcess, VStatus}
                                         end
                                            ||#stage_chapter_status{stage = VStage, process = VProcess, status = VStatus}<-ChangeStageListTmp],
                                    NewStageList = lists:foldl(F_replace, StageList, ChangeStageListTmp),
                                    lib_popup:fin_temple_chapter(Ps, NewStageList, {ChapterId, SubChapterId}), % 弹窗
                                    {[SubChapterInfo#sub_chapter_status{stage_lists = NewStageList}|GrandList], [ChangeStageList|GrandChanges]}
                            end;
                        _ ->
                            {[SubChapterInfo|GrandList], GrandChanges}
                    end
                end,
                {NewSubChapterList, NewChangeListTmp} = lists:foldl(F_Sub, {[], []}, SubChapterList),
                NewChangeListKV = lists:map(fun(Tuple) -> tuple_to_list(Tuple) end, lists:flatten(NewChangeListTmp)),
                %% 日志记录下，直接循环记录即可，日志进程有做缓存不必担心执行多条sql
                [log_temple_awaken_chapter_stage(RoleId, ChapterId, KSubChapter, KStage, KProcess, KStatus)||[_, _, KSubChapter, KStage, KProcess, KStatus]<-NewChangeListKV],
                Sql = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], NewChangeListKV),
%%                ?MYLOG("zhtemple", "NewSubChapterList ~p ~n NewChangeListTmp ~p ~n Sql ~s ~n", [NewSubChapterList,NewChangeListTmp,Sql]),
                ?IF(Sql =/= [], db:execute(Sql), skip),
                ChapterInfo#chapter_status{sub_chapters = NewSubChapterList};
            _ ->
                ChapterInfo
        end
    end,
    NewTempleAwaken = TempleAwaken#status_temple_awaken{temple_awaken_map = maps:map(F, TempleAwakenMap)},
    {ok, Ps#player_status{temple_awaken = NewTempleAwaken}}.
%%    ChapterInfoList = [ChapterInfo||{_, ChapterInfo}<-maps:to_list(TempleAwakenMap)],
%%    %% 获取当前进行中的章节
%%    case lists:keyfind(?TEMPLE_PROCESS, #chapter_status.status, ChapterInfoList) of
%%        false -> {ok, Ps};
%%        ChapterInfo ->
%%            #chapter_status{sub_chapters = SubChapterList, chapter_id = ChapterId} = ChapterInfo,
%%            %% 获取当前进行中的子章节
%%            case lists:keyfind(?SUBTEMPLE_PROCESS, #sub_chapter_status.status, SubChapterList) of
%%                false -> {ok, Ps};
%%                SubChapterInfo ->
%%                    #sub_chapter_status{stage_lists = StageList, sub_chapter = SubChapter} = SubChapterInfo,
%%                    {IsChange, ChangeStageList} = do_trigger(ChapterId, SubChapter, StageList, Args, [], false),
%%                    if
%%                        not IsChange -> {ok, Ps};
%%                        true ->
%%                            %% sql保存下 ChangeStageList 且协议通知下客户端
%%                            F = fun(StageInfoItem, {GrandStageList, GrandValue}) ->
%%                                #stage_chapter_status{stage = VStage, process = VProcess, status = VStatus} = StageInfoItem,
%%                                NewGrandStageList = lists:keystore(StageInfoItem#stage_chapter_status.stage, #stage_chapter_status.stage, GrandStageList, StageInfoItem),
%%                                lib_server_send:send_to_uid(RoleId, pt_429, 42905, [ChapterId, SubChapter, VStage, VProcess, VStatus]),
%%                                NewGrandValue = [[RoleId, ChapterId, SubChapter, VStage, VProcess, VStatus]|GrandValue],
%%                                {NewGrandStageList, NewGrandValue}
%%                                end,
%%                            ?MYLOG("zhtemple", "ChangeStageList ~p ~n", [ChangeStageList]),
%%                            {NewStageList, StageValuesList} = lists:foldl(F, {StageList, []}, ChangeStageList),
%%                            Sql = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], StageValuesList),
%%                            ?IF(Sql =/= [], db:execute(Sql), skip),
%%                            NewSubChapterInfo = SubChapterInfo#sub_chapter_status{stage_lists = NewStageList},
%%                            NewSubChapterList = lists:keystore(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, NewSubChapterInfo),
%%                            NewChapterInfo = ChapterInfo#chapter_status{sub_chapters = NewSubChapterList},
%%                            NewTempleAwakenMap = maps:put(ChapterId, NewChapterInfo, TempleAwakenMap),
%%                            {ok, Ps#player_status{temple_awaken = TempleAwaken#status_temple_awaken{temple_awaken_map = NewTempleAwakenMap}}}
%%                    end
%%            end
%%    end.

%% 每次升级都调用
%% 判断自身能否解锁新的章节或者新的子章节阶段任务
level_up_unlock(Ps) ->
    #player_status{temple_awaken = TempleAwaken} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    %% Step: 判断所有解锁了的章节是否都已完成， 都完成了判断能否解锁新的
    %%  Step-1: 将当前的章节状态根据状态分类
    F = fun(_, FChapterInfo, {GrandLock, GrandProcess, GrandComplete, GrandGot}) ->
        #chapter_status{status = Status} = FChapterInfo,
        case Status of
            ?TEMPLE_PROCESS -> {GrandLock, [FChapterInfo|GrandProcess], GrandComplete, GrandGot};
            ?TEMPLE_COMPLETE -> {GrandLock, GrandProcess, [FChapterInfo|GrandComplete], GrandGot};
            ?TEMPLE_GOT -> {GrandLock, GrandProcess, GrandComplete, [FChapterInfo|GrandGot]};
            ?TEMPLE_LOCK -> {[FChapterInfo|GrandLock], GrandProcess, GrandComplete, GrandGot}
        end
        end,
    {LockProcessInfos, ProcessChapterInfos, CompleteChapterInfos, _GotChapterInfos} = maps:fold(F, {[], [], [], []}, TempleAwakenMap),
    case ProcessChapterInfos of
        [ProcessChapterInfoItem|_] ->
            {ok, NewPs} = level_up_unlock_stage(Ps, ProcessChapterInfoItem);
        _ -> NewPs = Ps
    end,
    if
        LockProcessInfos == [] -> {ok, NewPs};      %% 解锁完了
        ProcessChapterInfos =/= [] -> {ok, NewPs};  %% 有没做完的
        CompleteChapterInfos =/= [] -> {ok, NewPs}; %% 有没领取完的
        true ->
            %% 解锁大张姐
            %% 需要解锁的章节
            [NextChapterInfo|_] = lists:keysort(#chapter_status.chapter_id, LockProcessInfos),
            level_up_unlock_chapter(NewPs, NextChapterInfo)
    end.

%% 玩家在其他模块更改自己模型
%% 神殿这边被动脱掉处理
be_cancel_wear(Ps, Chapter, _TypeId) ->
    #player_status{temple_awaken = TemplateAwaken, id = RoleId} = Ps,
    #status_temple_awaken{temple_awaken_map = TemplateAwakenMap} = TemplateAwaken,
    case maps:get(Chapter, TemplateAwakenMap, false) of
        #chapter_status{is_ware = ?IS_WARE, status = Status} = ChapterInfo ->
            NewChapterInfo = ChapterInfo#chapter_status{is_ware = ?NOT_WARE},
            db:execute(io_lib:format(?sql_replace_temple_awaken, [RoleId, Chapter, Status, ?NOT_WARE])),
            NewTemplateAwakenMap = maps:put(Chapter, NewChapterInfo, TemplateAwakenMap),
            NewTemplateAwaken = TemplateAwaken#status_temple_awaken{temple_awaken_map = NewTemplateAwakenMap},
            NewPs = Ps#player_status{temple_awaken = NewTemplateAwaken},
            pp_temple_awaken:handle(42901, NewPs, []),
            {ok, wear, NewPs};
        _ -> {ok, Ps}
    end .

%% gm完成章节所有任务
gm_complete_temple(Ps, Chapter) ->
    #player_status{temple_awaken = TempleAwaken, id = RoleId} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    PreId = get_pre_chapter_id(Chapter),
    [FirstId|_] = data_temple_awaken:list_chapter_id(),
    IsSatisfy =  PreId =/= [] orelse FirstId == Chapter,
    case IsSatisfy of
        false ->
            Ps;
        _ ->
            PreChapter = maps:get(PreId, TempleAwakenMap, #chapter_status{}),
            IsSatisfy2 = PreChapter#chapter_status.status == ?TEMPLE_GOT orelse FirstId == Chapter,
            case IsSatisfy2 of
                true ->
                    SubChapters = data_temple_awaken:list_sub_chapter(Chapter),
                    Sql1 = usql:replace(role_temple_awaken, [role_id, chapter_id, status, is_ware], [[RoleId, Chapter, ?TEMPLE_GOT, ?NOT_WARE]]),
                    F = fun(SubChapter, {Kv1, Kv2}) ->
                        StageList = data_temple_awaken:list_sub_chapter_stage(Chapter, SubChapter),
                        StageKV = [[RoleId, Chapter, SubChapter, Stage, 1, ?STAGE_GOT]||Stage<-StageList],
                        SubKv = [RoleId, Chapter, SubChapter, ?SUBTEMPLE_COMPLETE],
                        {StageKV ++ Kv1 , [SubKv|Kv2]}
                        end,
                    {Kvv1, Kvv2} =lists:foldl(F, {[], []}, SubChapters),
                    Sql2 = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], Kvv1),
                    Sql3 = usql:replace(role_temple_awaken_sub, [role_id, chapter_id, sub_chapter, status], Kvv2),
                    ?IF(Sql1 =/= [], db:execute(Sql1), skip),
                    ?IF(Sql2 =/= [], db:execute(Sql2), skip),
                    ?IF(Sql3 =/= [], db:execute(Sql3), skip),
%%                    ?PRINT("{Kvv1, Kvv2} ~p ~n", [{Kvv1, Kvv2}]),
                    case get_next_chapter_id(Chapter) of
                        [] -> skip;
                        NextChapterId ->
                            db:execute(io_lib:format(?sql_replace_temple_awaken, [RoleId, NextChapterId, ?TEMPLE_PROCESS, ?NOT_WARE])),
                            db:execute(io_lib:format(?sql_replace_temple_awaken_sub, [RoleId, NextChapterId, ?MIN_SUB_CHAPTER, ?SUBTEMPLE_PROCESS])),
                            NKvv = [[RoleId, NextChapterId, ?MIN_SUB_CHAPTER, Stage, 0, ?STAGE_PROCESS]||Stage<-data_temple_awaken:list_sub_chapter_stage(NextChapterId, ?MIN_SUB_CHAPTER)],
                            SQQl = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], NKvv),
                            ?IF(SQQl =/= [], db:execute(SQQl), skip)
                    end,
                    NewPs = login(Ps),
                    pp_temple_awaken:handle(42901, NewPs, []),
                    NewPs;
                _ ->
                    Ps
            end
    end.

gm_complete_subchapter(Ps, Chapter, SubChapter) ->
    db:execute(io_lib:format(?sql_replace_temple_awaken_sub, [Ps#player_status.id, Chapter, SubChapter, ?SUBTEMPLE_PROCESS])),
    NKvv = [[Ps#player_status.id, Chapter, SubChapter, Stage, 0, ?STAGE_COMPLETE]||Stage<-data_temple_awaken:list_sub_chapter_stage(Chapter, SubChapter)],
    SQl = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], NKvv),
    ?IF(SQl =/= [], db:execute(SQl), skip),
    NewPs = login(Ps),
    pp_temple_awaken:handle(42901, NewPs, []),
    NewPs.

gm_complete_stage(Ps, Chapter, SubChapter, Stage) ->
    db:execute(io_lib:format(?sql_replace_temple_awaken_stage, [Ps#player_status.id, Chapter, SubChapter, Stage, 1, ?STAGE_COMPLETE])),
    NewPs = login(Ps),
    pp_temple_awaken:handle(42901, NewPs, []),
    NewPs.

%% gm清空神殿
gm_clear(Ps) ->
    #player_status{id = RoleId} = Ps,
    mod_counter:set_count(RoleId, ?MOD_TEMPLE_AWAKEN, 1, 0),
    Sql1 = io_lib:format(<<"delete from role_temple_awaken where role_id = ~p">>, [RoleId]),
    Sql2 = io_lib:format(<<"delete from role_temple_awaken_sub where role_id = ~p">>, [RoleId]),
    Sql3 = io_lib:format(<<"delete from role_temple_awaken_stage where role_id = ~p">>, [RoleId]),
    db:execute(Sql1),
    db:execute(Sql2),
    db:execute(Sql3),
    {ok, NewPs} = init_temple_awaken(Ps),
    pp_temple_awaken:handle(42901, NewPs, []),
    NewPs.


%%====================================================Trigger Methods Begin============================================================================

%% 初始化神殿信息
init_temple_awaken(Ps) ->
    #player_status{id = RoleId} = Ps,
    F1 = fun(ChapterId, {GrandChapter, GrandKv, GrandSubKv}) ->
        SubChapters = data_temple_awaken:list_sub_chapter(ChapterId),
        F2 = fun(SubChapterId, {GrandSub, GrandKv2}) ->
            SubChapterInfo = #sub_chapter_status{status = ?SUBTEMPLE_LOCK, sub_chapter = SubChapterId},
            {[SubChapterInfo|GrandSub], [{RoleId, ChapterId, SubChapterId, ?SUBTEMPLE_LOCK}|GrandKv2]}
             end,
        {SubChapterList, SubChapterKv} = lists:foldl(F2, {[], []}, SubChapters),
        ChapterInfo = #chapter_status{chapter_id = ChapterId, status = ?TEMPLE_LOCK, sub_chapters = SubChapterList},
        {[{ChapterId, ChapterInfo}|GrandChapter],[[RoleId, ChapterId, ?NOT_WARE, ?TEMPLE_LOCK]|GrandKv], [SubChapterKv|GrandSubKv]}
         end,
    ChapterIds = data_temple_awaken:list_chapter_id(),
    {TempleAwakenMapList, ChaptersKv, SubChapterKvsTmp} = lists:foldl(F1, {[], [], []}, ChapterIds),
    SubChapterKvs = lists:map(fun(Tuple) -> tuple_to_list(Tuple) end, lists:flatten(SubChapterKvsTmp)),
    TempleAwakenMap = maps:from_list(TempleAwakenMapList),
    Sql1 = usql:replace(role_temple_awaken, [role_id, chapter_id, is_ware, status], ChaptersKv),
    ?IF(Sql1 =/= [], db:execute(Sql1), skip),
    Sql2 = usql:replace(role_temple_awaken_sub, [role_id, chapter_id, sub_chapter, status], SubChapterKvs),
    ?IF(Sql2 =/= [], db:execute(Sql2), skip),
    NewPs = Ps#player_status{temple_awaken = #status_temple_awaken{temple_awaken_map = TempleAwakenMap}},
    level_up_unlock(NewPs).
%%    {ok, NewPs}.

%% 升级解锁新的章节
level_up_unlock_chapter(Ps, NextChapterInfoTmp) ->
    #player_status{id = RoleId, temple_awaken = TempleAwaken} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    #chapter_status{chapter_id = NextChapterId} = NextChapterInfoTmp,
    #base_temple_awaken{condition = Condition} = data_temple_awaken:get_temple_awaken(NextChapterId),
    IsUnLock = check_condition(Ps, Condition),
    if
        IsUnLock ->
            SubChapter = ?MIN_SUB_CHAPTER,
            AllStages = data_temple_awaken:list_sub_chapter_stage(NextChapterId, SubChapter),
            {UnLockStageInfos, NextChapterInfoTmp} = check_unlock_stage(Ps, NextChapterId, SubChapter, AllStages),
            F = fun() ->
                NextChapterInfo = unlock_chapter(RoleId, NextChapterId, SubChapter, UnLockStageInfos, NextChapterInfoTmp),
%%                lib_temple_awaken_event:handle_stage_chapter_unlock(RoleId, NextChapterId, SubChapter, UnLockStageInfos),
                {true, NextChapterInfo}
                end,
            case lib_goods_util:transaction(F) of
                {true, NextChapterInfo} ->
                    %% 成功解锁并通知下客户端
                    lib_server_send:send_to_uid(RoleId, pt_429, 42903, [NextChapterId, ?TEMPLE_PROCESS]),
                    NewTempleAwakenMap = maps:put(NextChapterId, NextChapterInfo, TempleAwakenMap),
%%                    TempleStatus = get_temple_awaken_status(NewTempleAwakenMap),
                    NewPs = Ps#player_status{temple_awaken = TempleAwaken#status_temple_awaken{temple_awaken_map = NewTempleAwakenMap}},
                    {ok, NewPs};
                _Err ->
                    ?ERR("level_up unlock chapter error ~p ~n", _Err),
                    {ok, Ps}
            end;
        true ->
            {ok, Ps}
    end.

%% 升级解锁新的子章节阶段任务
level_up_unlock_stage(Ps, ChapterInfo) ->
    #player_status{id = RoleId, temple_awaken = TempleAwaken} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    #chapter_status{sub_chapters = SubChapterList, chapter_id = ChapterId} = ChapterInfo,
    case lists:keyfind(?SUBTEMPLE_PROCESS, #sub_chapter_status.status, SubChapterList) of
        false -> {ok, Ps};  %% 没有进行中的子章节， Pass(比如全部完成了，但是没有领取)
        SubChapterInfo ->
            #sub_chapter_status{stage_lists = StageList, sub_chapter = SubChapter} = SubChapterInfo,
            %%  Step-2-2-1: 获取没有进度的阶段任务
            AllStages = data_temple_awaken:list_sub_chapter_stage(ChapterId, SubChapter),
            case check_unlock_stage(Ps, ChapterId, SubChapter, AllStages) of
                {[], _} -> {ok, Ps};
                {NeedUnlockStageInfos, _NextChapterInfoTmp} ->
                    StageValuesList = [begin
                                           lib_log_api:log_temple_awaken_chapter_stage(RoleId, ChapterId, SubChapter, VStage, VProcess, VStatus),
                                           lib_server_send:send_to_uid(RoleId, pt_429, 42905, [ChapterId, SubChapter, VStage, VProcess, VStatus]),
                                           [RoleId, ChapterId, SubChapter, VStage, VProcess, VStatus]
                                       end||#stage_chapter_status{stage = VStage, process = VProcess, status = VStatus}<-NeedUnlockStageInfos],
                    Sql = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], StageValuesList),
                    ?IF(Sql =/= [], db:execute(Sql), skip),
%%                    lib_temple_awaken_event:handle_stage_chapter_unlock(Ps#player_status.id, ChapterId, SubChapter, NeedUnlockStageInfos),
                    NewNeedUnlockStageInfos = auto_check_stage(Ps, ChapterId, SubChapter, NeedUnlockStageInfos),
                    NewStageList = StageList ++ NewNeedUnlockStageInfos,
                    NewSubChapterInfo = SubChapterInfo#sub_chapter_status{stage_lists = NewStageList},
                    NewSubChapterList = lists:keystore(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, NewSubChapterInfo),
                    NewProcessChapterInfoItem = ChapterInfo#chapter_status{sub_chapters = NewSubChapterList},
                    NewTempleAwakenMap = maps:put(ChapterId, NewProcessChapterInfoItem, TempleAwakenMap),
                    NewTempleAwaken = TempleAwaken#status_temple_awaken{temple_awaken_map = NewTempleAwakenMap},
                    NewPs = Ps#player_status{temple_awaken = NewTempleAwaken},
                    {ok, NewPs}
            end
    end.


%% 子章节阶段任务触发
%% @return {是否改变任务进度, 任务进度改变的StageList}
do_trigger(_Ps, _ChapterId, _SubChapter, [], _Args, ChangeList, IsChange) ->
    {IsChange, ChangeList};
do_trigger(Ps, ChapterId, SubChapter, [#stage_chapter_status{status = Status, stage = Stage} = StageItem|T], Args, ChangeList, IsChange)
    when Status == ?STAGE_PROCESS ->
%%    ?PRINT("ChapterId, SubChapter Stage ~p ~n", [[ChapterId, SubChapter, Stage]]),
    case data_temple_awaken:get_temple_awaken_stage(ChapterId, SubChapter, Stage) of
        #base_temple_awaken_stage{complete_con = CompleteCondition} ->
            case do_trigger_core(Ps, StageItem, CompleteCondition, Args, false) of
                {true, NewStageItem} ->
                    NewIsChange = true, NewChangeList = [NewStageItem|ChangeList];
                {false, _StageItem} ->
                    NewIsChange = IsChange, NewChangeList = ChangeList
            end;
        _ ->
            %?MYLOG("zhtemple", "config error ~p ~n", [{ChapterId, SubChapter, Stage}]),
            NewIsChange = IsChange, NewChangeList = ChangeList
    end,
    do_trigger(Ps, ChapterId, SubChapter, T, Args, NewChangeList, NewIsChange);
do_trigger(Ps, ChapterId, SubChapter, [#stage_chapter_status{status = Status}|T], Args, ChangeList, IsChange)
    when Status == ?STAGE_COMPLETE orelse Status == ?STAGE_GOT->
    do_trigger(Ps, ChapterId, SubChapter, T, Args, ChangeList, IsChange).


do_trigger_core(_Ps, StageItem, _Condition, [], IsProcess) ->
%%    ?MYLOG("zhtemple", "{IsProcess, StageItem} ~p ~n", [{IsProcess, StageItem}]),
    {IsProcess, StageItem};
%% 达到多少等级，并且开服天数达到N天
do_trigger_core(Ps, StageItem, [{lv_day, _NeedOpenDay, _NeedLv}] = C, [trigger|L], IsProcess) ->
    Lv = Ps#player_status.figure#figure.lv,
    do_trigger_core(Ps, StageItem, C, [{lv_day, Lv}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{lv_day, NeedOpenDay, NeedLv}] = C, [{lv_day, Lv}|L], IsProcess) ->
    OpenDay = util:get_open_day(),
    if
        OpenDay < NeedOpenDay -> do_trigger_core(Ps, StageItem, C, L, IsProcess);
        true ->
            case Lv >= NeedLv of
                true ->
                    NewIsProcess = true,
                    NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
                    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
                _ ->
                    do_trigger_core(Ps, StageItem, C, L, IsProcess)
            end
    end;

%% 达到xxx战力
do_trigger_core(Ps, StageItem, [{combat, _NeedCombat}] = C, [trigger|L], IsProcess) ->
    Combat = Ps#player_status.combat_power,
    do_trigger_core(Ps, StageItem, C, [{combat, Combat}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{combat, NeedCombat}] = C, [{combat, Combat}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Combat, NeedCombat, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 达到等级
do_trigger_core(Ps, StageItem, [{lv, _NeedLv}] = C, [trigger|L], IsProcess) ->
    RoleLv = Ps#player_status.figure#figure.lv,
    do_trigger_core(Ps, StageItem, C, [{lv, RoleLv}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{lv, NeedLv}] = C, [{lv, RoleLv}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(RoleLv, NeedLv, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% xx功能开启
do_trigger_core(Ps, StageItem, [{finish_task, TaskId}] = C, [trigger|L], IsProcess) ->
    case mod_task:is_finish_task_id(Ps#player_status.tid, TaskId) of
        true ->
            NewIsProcess = true,
            NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
            do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
        _ -> do_trigger_core(Ps, StageItem, C, L, IsProcess)
    end;
do_trigger_core(Ps, StageItem, [{finish_task, TaskId}] = C, [{finish_task, TaskId}|L], _IsProcess) ->
    NewIsProcess = true,
    NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 坐骑模块提升到N阶M星
do_trigger_core(Ps, StageItem, [{mount, TypeId, _NeedStage, _NeedStar}] = C, [trigger|L], IsProcess) ->
    #player_status{status_mount = StatusMount} = Ps,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of
        #status_mount{stage = Stage, star = Star} -> ok;
        _ -> Stage = 0, Star = 0
    end,
    do_trigger_core(Ps, StageItem, C, [{mount, TypeId, Stage, Star}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{mount, TypeId, NeedStage, NeedStar}] = C, [{mount, TypeId, Stage, Star}|L], IsProcess) ->
    Num = deal_stage_condition(Stage, Star),
    NeedNum = deal_stage_condition(NeedStage, NeedStar),
    {NewIsProcess, NewStageItem} = calc_value_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 通关副本类型
%%do_trigger_core(Ps, StageItem, [{dun, DunType, NeedNum}] = C, [{dun, DunType, Num}|L], IsProcess) ->
do_trigger_core(Ps, StageItem, [{dun, DunType, NeedNum}] = C, [{dun, DunType, Num}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_accumulate_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
% 只能打一次的副本
do_trigger_core(Ps, StageItem, [{dun_id, DunId, 1}] = C, [trigger|L], IsProcess) ->
    case lib_dungeon_api:check_ever_finish(Ps, DunId) of
        true ->
            NewIsProcess = true,
            NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
            do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
        _ -> do_trigger_core(Ps, StageItem, C, L, IsProcess)
    end;
%% 通关指定的副本N次
do_trigger_core(Ps, StageItem, [{dun_id, DunId, NeedNum}] = C, [{dun_id, DunId, Num}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_accumulate_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
%% 进入指定副本
do_trigger_core(Ps, StageItem, [{enter_dun, DunId, NeedNum}] = C, [{enter_dun, DunId, Num}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_accumulate_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 符文本达到N层
do_trigger_core(Ps, StageItem, [{rune_dun, _NeedLayer}] = C, [trigger|L], IsProcess) ->
    Layer = lib_dungeon_rune:get_dungeon_level(Ps),
    do_trigger_core(Ps, StageItem, C, [{rune_dun, Layer}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{rune_dun, NeedLayer}] = C, [{rune_dun, Layer}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Layer, NeedLayer, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
%% 击杀大于XX等级的xx类型Boss N个
do_trigger_core(Ps, StageItem, [{boss_lv, BossType, NeedBossLv, NeedNum}] = C, [{boss_lv, BossType, BossLv, Num}|L], IsProcess) when BossLv >= NeedBossLv ->
    {NewIsProcess, NewStageItem} = calc_accumulate_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
%% 击杀指定类型Boss N个
do_trigger_core(Ps, StageItem, [{boss_type, BossType, NeedNum}] = C, [{boss_type, BossType, Num}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_accumulate_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 完成N转
do_trigger_core(Ps, StageItem, [{turn, _NeedTurn}] = C, [trigger|L], IsProcess) ->
    #player_status{figure = #figure{turn = Turn}} = Ps,
    do_trigger_core(Ps, StageItem, C, [{turn, Turn}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{turn, NeedTurn}] = C, [{turn, Turn}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Turn, NeedTurn, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 活跃等级达到N级
do_trigger_core(Ps, StageItem, [{active_lv, _NeedLv}] = C, [trigger|L], IsProcess) ->
    #player_status{st_liveness = #st_liveness{lv = Lv}} = Ps,
    do_trigger_core(Ps, StageItem, C, [{active_lv, Lv}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{active_lv, NeedLv}] = C, [{active_lv, Lv}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Lv, NeedLv, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 装备强化总等级到N
do_trigger_core(Ps, StageItem, [{strength_sum_lv, _NeedLv}] = C, [trigger|L], IsProcess) ->
    #goods_status{stren_award_list = EqStrenList} = lib_goods_do:get_goods_status(),
    do_trigger_core(Ps, StageItem, C, [{strength_sum_lv, EqStrenList}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{strength_sum_lv, NeedLv}] = C, [{strength_sum_lv, EqStrenList}|L], IsProcess) ->
    F = fun({StrNum, N}, GrandLv) -> StrNum * N + GrandLv end,
    SumLv = lists:foldl(F, 0, EqStrenList),
    {NewIsProcess, NewStageItem} = calc_value_task(SumLv, NeedLv, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 圣印情况
do_trigger_core(Ps, StageItem, [{seal_status, _NeedColor, _NeedStage, _NeedNum}] = C, [trigger|L], IsProcess) ->
    SealEquipList = Ps#player_status.seal_status#seal_status.equip_list,
    GoodsStatus = lib_goods_do:get_goods_status(),
    SealList = [lib_goods_api:get_goods_info(EqSealId, GoodsStatus)||{_, EqSealId, _}<-SealEquipList],
    do_trigger_core(Ps, StageItem, C, [{seal_status, SealList}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{seal_status, NeedColor, NeedStage, NeedNum}] = C, [{seal_status, SealList}|L], IsProcess) ->
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
    {NewIsProcess, NewStageItem} = calc_value_task(RealNum, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 装备穿戴情况
do_trigger_core(Ps, StageItem, [{equip_status, _NeedStage, _NeedColor, _NeedStar, _NeedNum}] = C, [trigger|L], IsProcess) ->
    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
    EquipList = lib_goods_util:get_equip_list(Ps#player_status.id, Dict),
    do_trigger_core(Ps, StageItem, C, [{equip_status, EquipList}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{equip_status, NeedStage, NeedColor, NeedStar, NeedNum}] = C, [{equip_status, EquipList}|L], IsProcess) ->
    F = fun(GoodsInfo, GrandNum) ->
        #goods{goods_id = GoodsTypeId, color = Color} = GoodsInfo,
        EquipStage = lib_equip:get_equip_stage(GoodsTypeId),
        EquipStar = lib_equip:get_equip_star(GoodsTypeId),
        %% 判断是否符合
        Flag = Color >= NeedColor andalso EquipStage >= NeedStage andalso EquipStar >=NeedStar,
        ?IF(Flag, GrandNum + 1, GrandNum)
        end,
    RealNum = lists:foldl(F, 0, EquipList),
    {NewIsProcess, NewStageItem} = calc_value_task(RealNum, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 勋章达到N级
do_trigger_core(Ps, StageItem, [{medal_lv, _NeedLv}] = C, [trigger|L], IsProcess) ->
    #medal{id = OldMedal} = Ps#player_status.medal,
    do_trigger_core(Ps, StageItem, C, [{medal_lv, OldMedal - 1}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{medal_lv, NeedLv}] = C, [{medal_lv, Lv}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Lv, NeedLv, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 进入蛮荒之地N次
do_trigger_core(Ps, StageItem, [{enter_mh, NeedNum}] = C, [{enter_mh, Num}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_accumulate_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 装备合成，合成A件W阶S颜色L星数的装备
do_trigger_core(Ps, StageItem, [{compose_equip, NeedStage, NeedColor, NeedStar, NeedNum}] = C, [{compose_equip, GoodsInfoList}|L], IsProcess) ->
    F = fun(GoodsInfo, GrandNum) ->
        #goods{color = Color, goods_id = GoodsTypeId} = GoodsInfo,
        EquipStage = lib_equip:get_equip_stage(GoodsTypeId),
        EquipStar = lib_equip:get_equip_star(GoodsTypeId),
        IsSatisfy = Color >= NeedColor andalso EquipStage >= NeedStage andalso EquipStar >= NeedStar,
        ?IF(IsSatisfy, GrandNum + 1, GrandNum)
        end,
    Num = lists:foldl(F, 0, GoodsInfoList),
    {NewIsProcess, NewStageItem} = calc_accumulate_task(Num, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 套装激活状态:激活了X类型套装的N阶M件套
do_trigger_core(Ps, StageItem, [{suit, _SuitType, _NeedStage, _NeedNum}] = C, [trigger|L], IsProcess) ->
    #goods_status{equip_suit_state = EquipSuitState} = lib_goods_do:get_goods_status(),
    do_trigger_core(Ps, StageItem, C, [{suit, EquipSuitState}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{suit, SuitType, NeedStage, NeedNum}] = C, [{suit, EquipSuitState}|L], IsProcess) ->
    SuitList = lib_equip:get_equipment_suit_info(EquipSuitState),
    F = fun({SType, SStage, SNum}, AccNumList) ->
        case lists:keyfind(SType, 1, AccNumList) of
            false -> AccNumList;
            {_, AccNum} ->
                IsSatisfy = SuitType =< SType andalso NeedStage =< SStage,
                case IsSatisfy of
                    false -> AccNumList;
                    true -> lists:keystore(SType, 1, AccNumList, {SType, max(AccNum, SNum)})
                end
        end
        end,
    RealNumList = lists:foldl(F, [{?EQUIP_SUIT_LV_EQUIP, 0}, {?EQUIP_SUIT_LV_ORNAMENT, 0}, {?EQUIP_SUIT_LV_PERFECT, 0}], SuitList),
    RealNum = min(6, lists:sum([Num||{_, Num}<-RealNumList])),
    %?PRINT("RealNumList ~p ~n, SuitList ~p ~n RealNum ~p ~n ~p ~n", [RealNumList, SuitList, RealNum, {suit, SuitType, NeedStage, NeedNum}]),
    case RealNum >= NeedNum of
        true ->
            NewIsProcess = true,
            NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
            do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
        _ ->
            do_trigger_core(Ps, StageItem, C, L, IsProcess)
    end;

%% 宝宝养育等级
do_trigger_core(Ps, StageItem, [{baby_lv, _NeedLv}] = C, [trigger|L], IsProcess) ->
    #player_status{status_baby = #status_baby{raise_lv = RaiseLv}} = Ps,
    do_trigger_core(Ps, StageItem,  C, [{baby_lv, RaiseLv}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{baby_lv, NeedLv}] = C, [{baby_lv, BabyLv}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(BabyLv, NeedLv, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 洗练状态：N件装备洗练到了M阶段
do_trigger_core(Ps, StageItem, [{wash_status, _NeedStage, _NeedNum}] = C, [trigger|L], IsProcess) ->
    #goods_status{equip_wash_map = WashStatus} = lib_goods_do:get_goods_status(),
    do_trigger_core(Ps, StageItem, C, [{wash_status, WashStatus}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{wash_status, NeedStage, NeedNum}] = C, [{wash_status, WashStatus}|L], IsProcess) ->
    F = fun(_Key, #equip_wash{duan = Duan}, GrandNum) ->
        NewGrandNum = case Duan >= NeedStage of
            true -> GrandNum + 1;
            _ -> GrandNum
        end,
        NewGrandNum;
        (_Key, _Val, GrandNum) -> GrandNum
        end,
    RealNum = maps:fold(F, 0, WashStatus),
    {NewIsProcess, NewStageItem} = calc_value_task(RealNum, NeedNum, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

do_trigger_core(Ps, StageItem, [{wash_sum_lv, _NeedDuan}] = C, [trigger|L], IsProcess) ->
    #goods_status{equip_wash_map = WashStatus} = lib_goods_do:get_goods_status(),
    WashList = maps:to_list(WashStatus),
    Fun = fun
              ({_Key, #equip_wash{duan = Duan}}, AccDuan) -> AccDuan + Duan;
              (_, AccDuan) -> AccDuan
          end,
    SumDuan = lists:foldl(Fun, 0, WashList),
    do_trigger_core(Ps, StageItem, C, [{wash_sum_lv, SumDuan}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{wash_sum_lv, NeedDuan}] = C, [{wash_sum_lv, Duan}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Duan, NeedDuan, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 激活指定伙伴
do_trigger_core(Ps, StageItem, [{active_companion, CompanionId}] = C, [trigger|L], IsProcess) ->
    case lib_companion_util:is_active(Ps, CompanionId) of
        true -> do_trigger_core(Ps, StageItem, C, [{active_companion, CompanionId}|L], IsProcess);
        _ -> do_trigger_core(Ps, StageItem, C, L, IsProcess)
    end;
do_trigger_core(Ps, StageItem, [{active_companion, CompanionId}] = C, [{active_companion, CompanionId}|L], _IsProcess) ->
    NewIsProcess = true,
    NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 激活指定幻兽
do_trigger_core(Ps, StageItem, [{active_eudemon, EudemonId}] = C, [trigger|L], IsProcess) ->
    #player_status{eudemons = EudemonsStatus} = Ps,
    #eudemons_status{eudemons_list = Items} = EudemonsStatus,
    case lists:keyfind(EudemonId, #eudemons_item.id, Items) of
        #eudemons_item{state = ?EUDEMONS_STATE_FIGHT} -> do_trigger_core(Ps, StageItem, C, [{active_eudemon, EudemonId}|L], IsProcess);
        #eudemons_item{state = ?EUDEMONS_STATE_ACTIVE} -> do_trigger_core(Ps, StageItem, C, [{active_eudemon, EudemonId}|L], IsProcess);
        _ -> do_trigger_core(Ps, StageItem, C, L, IsProcess)
    end;
do_trigger_core(Ps, StageItem, [{active_eudemon, EudemonId}] = C, [{active_eudemon, EudemonId}|L], _IsProcess) ->
    NewIsProcess = true,
    NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 激活指定降神
do_trigger_core(Ps, StageItem, [{active_god, GodId}] = C, [trigger|L], IsProcess) ->
    #player_status{god = #status_god{god_list = GodList}} = Ps,
    case lists:keyfind(GodId, #god.id, GodList) of
        #god{} -> do_trigger_core(Ps, StageItem, C, [{active_god, GodId}|L], IsProcess);
        _ -> do_trigger_core(Ps, StageItem, C, L, IsProcess)
    end;
do_trigger_core(Ps, StageItem, [{active_god, GodId}] = C, [{active_god, GodId}|L], _IsProcess) ->
    NewIsProcess = true,
    NewStageItem = StageItem#stage_chapter_status{process = 1, status = ?STAGE_COMPLETE},
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 幻饰评分达到xxx
do_trigger_core(Ps, StageItem, [{decoration_rate, _NeedRate}] = C, [trigger|L], IsProcess) ->
    Rate = lib_decoration:get_overall_rating(Ps),
    do_trigger_core(Ps, StageItem, C, [{decoration_rate, Rate}|L], IsProcess);
do_trigger_core(Ps, StageItem, [{decoration_rate, NeedRate}] = C, [{decoration_rate, Rate}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Rate, NeedRate, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);

%% 指定降神达到X星
do_trigger_core(Ps, StageItem, [{god_status, GodId, _NeedStar}] = C, [trigger|L], IsProcess) ->
    #player_status{god = #status_god{god_list = GodList}} = Ps,
    case lists:keyfind(GodId, #god.id, GodList) of
        #god{star = Star} -> do_trigger_core(Ps, StageItem, C, [{god_status, GodId, Star}|L], IsProcess);
        _ -> do_trigger_core(Ps, StageItem, C, L, IsProcess)
    end;
do_trigger_core(Ps, StageItem, [{god_status, GodId, NeedStar}] = C, [{god_status, GodId, Star}|L], IsProcess) ->
    {NewIsProcess, NewStageItem} = calc_value_task(Star, NeedStar, StageItem, IsProcess),
    do_trigger_core(Ps, NewStageItem, C, L, NewIsProcess);
do_trigger_core(Ps, StageItem, C, [_|L], IsProcess) ->
    do_trigger_core(Ps, StageItem, C, L, IsProcess).

%% 计算累计任务状态，比如完成xx xx n次这种需要次数进度的任务
calc_accumulate_task(Num, NeedNum, StageItem, _IsProcess) ->
    case Num >= NeedNum of
        true ->
            NewProcess = NeedNum,
            NewStatus = ?STAGE_COMPLETE,
            NewIsProcess = true;
        false ->
            NewProcess = StageItem#stage_chapter_status.process + Num,
            NewStatus = ?STAGE_PROCESS,
%%            NewIsProcess = IsProcess,
            NewIsProcess = true
    end,
    NewStageItem = StageItem#stage_chapter_status{process = NewProcess, status = NewStatus},
    {NewIsProcess, NewStageItem}.
%% 计算值任务状态，比如战力达到多少，某个属性值达到多少
%% 这些状态值一直存在玩家身上且有可能减少的
calc_value_task(Num, NeedNum, StageItem, _IsProcess) ->
    case Num >= NeedNum of
        true ->
            NewProcess = NeedNum,
            NewStatus = ?STAGE_COMPLETE,
            NewIsProcess = true;
        false ->
            NewProcess = Num,
            NewStatus = ?STAGE_PROCESS,
%%            NewIsProcess = IsProcess,
            NewIsProcess = true
    end,
    NewStageItem = StageItem#stage_chapter_status{process = NewProcess, status = NewStatus},
    {NewIsProcess, NewStageItem}.

%%====================================================Trigger Methods End==============================================================================


%%====================================================Inner Methods Begin====================================================================================
%% 解锁新章节
%% sql 比较多，执行最好通过下事务
unlock_chapter(RoleId, NewChapterId, SubChapter, StageInfos, NextChapterInfoTmp) ->
    StageList = StageInfos,
    StageValuesList = [begin
                           lib_log_api:log_temple_awaken_chapter_stage(RoleId, NewChapterId, SubChapter, VStage, VProcess, VStatus),
                           [RoleId, NewChapterId, SubChapter, VStage, VProcess, VStatus]
                       end||#stage_chapter_status{stage = VStage, process = VProcess, status = VStatus}<-StageList],
    Sql = usql:replace(role_temple_awaken_stage, [role_id, chapter_id, sub_chapter, stage, process, status], StageValuesList),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    #chapter_status{sub_chapters = SubChapterList} = NextChapterInfoTmp,
    SubChapterInfo = #sub_chapter_status{stage_lists = OldStageList} = ulists:keyfind(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, #sub_chapter_status{}),
    NewSubChapterInfo = SubChapterInfo#sub_chapter_status{status = ?SUBTEMPLE_PROCESS, stage_lists = OldStageList ++ StageList},
    NewSubChapterList = lists:keystore(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, NewSubChapterInfo),
    db:execute(io_lib:format(?sql_replace_temple_awaken_sub, [RoleId, NewChapterId, SubChapter, ?SUBTEMPLE_PROCESS])),
    db:execute(io_lib:format(?sql_replace_temple_awaken, [RoleId, NewChapterId, ?TEMPLE_PROCESS, ?NOT_WARE])),
    %% 日志，放这边好处理，但是不够规范，有空处理下
    lib_log_api:log_temple_awaken_chapter(RoleId, NewChapterId, ?TEMPLE_PROCESS),
    lib_log_api:log_temple_awaken_chapter_sub(RoleId, NewChapterId, SubChapter, ?SUBTEMPLE_PROCESS),
    NextChapterInfoTmp#chapter_status{sub_chapters = NewSubChapterList, status = ?TEMPLE_PROCESS}.


%% 判断能否领取章节阶段奖励
%% @param TempleAwakenMap 章节信息map
%% @param ChapterId 章节ID
%% @param SubChapter 子章节
%% @param Stage 阶段
%% @return {true, ChapterInfo(未改变的觉醒状态), NewSubChapterInfo(仅仅更改了里面的阶段任务状态,整体状态需后面的函数处理)}
check_receive_stage_reward(TempleAwakenMap, ChapterId, SubChapter, Stage) ->
    case maps:get(ChapterId, TempleAwakenMap, false) of
        false -> {false, ?ERRCODE(err429_lock_temple)};
        #chapter_status{status = ?TEMPLE_COMPLETE} ->
            {false, ?ERRCODE(err429_had_complete)};
        #chapter_status{status = ?TEMPLE_GOT} ->
            {false, ?ERRCODE(err429_had_got)};
        ChapterInfo ->
            #chapter_status{sub_chapters = SubChapterList} = ChapterInfo,
            case lists:keyfind(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList) of
                false ->
                    {false, ?ERRCODE(err429_lock_sub_chapter)};
                #sub_chapter_status{status = ?SUBTEMPLE_COMPLETE} ->
                    {false, ?ERRCODE(err429_had_complete)};
                SubChapterInfo ->
                    #sub_chapter_status{stage_lists = StageList} = SubChapterInfo,
                    case lists:keyfind(Stage, #stage_chapter_status.stage, StageList) of
                        false ->
                            {false, ?ERRCODE(err429_no_complete)};
                        #stage_chapter_status{status = ?STAGE_PROCESS} ->
                            {false, ?ERRCODE(err429_no_complete)};
                        #stage_chapter_status{status = ?STAGE_GOT} ->
                            {false, ?ERRCODE(err429_had_got)};
                        StageChapterInfo ->
                            NewStageChapterInfo = StageChapterInfo#stage_chapter_status{status = ?STAGE_GOT},
                            NewSubChapterInfo = SubChapterInfo#sub_chapter_status{
                                stage_lists = lists:keystore(Stage, #stage_chapter_status.stage, StageList, NewStageChapterInfo)
                            },
                            {true, ChapterInfo, NewSubChapterInfo}
                    end
            end
    end.


%% 检查能否解锁下一个章节
%% 完成一个章节后， 或者升级后调用
%% 解锁条件根据配置的等级或者战力
%% @param ChapterId 当前已完成的且领取的章节ID
%% @return {是否解锁, 新的章节Id}
check_unlock_next_chapter(Ps, ChapterId) ->
    case get_next_chapter_id(ChapterId) of
        [] ->
            {false, 0};
        NextChapterId ->
            #base_temple_awaken{condition = Condition} = data_temple_awaken:get_temple_awaken(NextChapterId),
            IsUnLockNext = check_condition(Ps, Condition),
            ?PRINT("IsUnLockNext ~p Condition ~p ~n", [IsUnLockNext, Condition]),
            {IsUnLockNext, NextChapterId}
    end.

%% 检查能否解锁新的子章节
%% 解锁条件，当前子章节所有的任务都必须完成
%% 解锁了新的子章节，之前的子章节status也需要改变
check_unlock_next_sub_chapter(Ps, ChapterId, NewSubChapterInfoTmp, SubChapterList) ->
    #sub_chapter_status{sub_chapter = SubChapter, stage_lists = StageList} = NewSubChapterInfoTmp,
    StageIdList = data_temple_awaken:list_sub_chapter_stage(ChapterId, SubChapter),
    F = fun(StageId, Flag) ->
        case lists:keyfind(StageId, #stage_chapter_status.stage, StageList) of
            #stage_chapter_status{status = ?STAGE_GOT} ->
                Flag andalso true;
            _ -> false
        end
        end,
    case lists:foldl(F, true, StageIdList) of
        true ->
            %% 当前子章节所有任务都完成， 更新子章节状态，并且检查能否解锁下一子章节
            NewSubChapterInfo = NewSubChapterInfoTmp#sub_chapter_status{status = ?SUBTEMPLE_COMPLETE},
            case get_next_sub_chapter_id(ChapterId, SubChapter) of
                [] ->
                    {finish, NewSubChapterInfo};
                NextSubChapterId ->
                    %% 子章节的阶段任务也解锁下
                    AllStages = data_temple_awaken:list_sub_chapter_stage(ChapterId, NextSubChapterId),
                    {UnLockStageInfos, _NewUnLockChapterInfo} = check_unlock_stage(Ps, ChapterId, NextSubChapterId, AllStages),
                    NextSubChapterInfoTmp = #sub_chapter_status{stage_lists = OldStageList} = ulists:keyfind(NextSubChapterId, #sub_chapter_status.sub_chapter, SubChapterList, #sub_chapter_status{}),
                    NextSubChapterInfo = NextSubChapterInfoTmp#sub_chapter_status{stage_lists = UnLockStageInfos ++ OldStageList, status = ?SUBTEMPLE_PROCESS},
                    {finish, NewSubChapterInfo, NextSubChapterInfo}
            end;
        false ->
            %% 当前子章节的任务没有完全完成，不用改变状态
            nofinish
    end.


%% 检查下面的指定章节子章节的阶段任务能否解锁
%% 已经有任务进度的任务无需解锁了
check_unlock_stage(Ps, ChapterId, SubChapter, LockStages) ->
    #player_status{temple_awaken = TempleAwaken} = Ps,
    #status_temple_awaken{temple_awaken_map = TempleAwakenMap} = TempleAwaken,
    UnLockChapterInfo = #chapter_status{sub_chapters = SubChapterList} = maps:get(ChapterId, TempleAwakenMap, #chapter_status{}),
    #sub_chapter_status{stage_lists = OldStageList} = ulists:keyfind(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, #sub_chapter_status{}),
    F = fun(Stage, NeedUnlockList) ->
        #base_temple_awaken_stage{open_con = Condition} = data_temple_awaken:get_temple_awaken_stage(ChapterId, SubChapter, Stage),
        case check_condition(Ps, Condition) of
            true ->
                case lists:keymember(Stage, #stage_chapter_status.stage, OldStageList) of
                    true -> NeedUnlockList;
                    _ -> [#stage_chapter_status{stage = Stage}|NeedUnlockList]
                end;
            _ -> NeedUnlockList
        end
        end,
    NewNeedUnlockList = lists:foldl(F, [], LockStages),
    %NewSubChapterInfo = SubChapterInfo#sub_chapter_status{stage_lists = OldStageList ++ NewNeedUnlockList},
    %NewUnLockChapterInfo = UnLockChapterInfo#chapter_status{sub_chapters = lists:keystore(SubChapter, #sub_chapter_status.sub_chapter, SubChapterList, NewSubChapterInfo)},
    {NewNeedUnlockList, UnLockChapterInfo}.


%% 获取神殿觉醒总体状态值
get_temple_awaken_status(TempleAwakenMap) when is_map(TempleAwakenMap) ->
    ChapterInfoList = maps:to_list(TempleAwakenMap),
    get_temple_awaken_status(ChapterInfoList);
get_temple_awaken_status(ChapterInfoList) when is_list(ChapterInfoList) ->
    AllChapterIds = data_temple_awaken:list_chapter_id(),
    case check_all_chapter_unlock(AllChapterIds, ChapterInfoList) of
        false -> ?NOT_ALL_UNLOCK;
        true ->
            F = fun
                ({_, ChapterInfo}, IsFinish) ->
                    #chapter_status{status = Status} = ChapterInfo,
                    case Status of
                        ?TEMPLE_PROCESS -> false;
                        _ -> true andalso IsFinish
                    end;
                (ChapterInfo, IsFinish) ->
                    #chapter_status{status = Status} = ChapterInfo,
                    case Status of
                        ?TEMPLE_PROCESS -> false;
                        _ -> true andalso IsFinish
                    end
                end,
            ?IF(lists:foldl(F, true, ChapterInfoList), ?ALL_COMPLETE, ?ALL_UNLOCK)
    end.

%% 判断是否已经解锁了所有章节
check_all_chapter_unlock(AllChapterIds, ChapterInfoList) when is_list(ChapterInfoList) ->
    AllChapterIds = data_temple_awaken:list_chapter_id(),
    length(AllChapterIds) == length(ChapterInfoList);
check_all_chapter_unlock(AllChapterIds, TempleAwakenMap) when is_map(TempleAwakenMap) ->
    ChapterInfoList = maps:to_list(TempleAwakenMap),
    AllChapterIds = data_temple_awaken:list_chapter_id(),
    length(AllChapterIds) == length(ChapterInfoList);
check_all_chapter_unlock(_, _) -> false.

%% 检查玩家是否满足指定条件
check_condition(_Ps, []) -> true;
check_condition(Ps, [H|T]) ->
    case do_check_condition(Ps, H) of
        true ->
           check_condition(Ps, T);
        false -> false
    end.
do_check_condition(Ps, {combat, NeedCombat}) ->
    #player_status{combat_power = RoleCombat} = Ps,
    RoleCombat >= NeedCombat;
do_check_condition(Ps, {lv, NeedLv}) ->
    #player_status{figure = #figure{lv = RoleLv}} = Ps,
    RoleLv >= NeedLv;
do_check_condition(_, _) ->
    true.


%% 获取上一章节ID
get_pre_chapter_id(NowChapterId) ->
    AllChapterIds = data_temple_awaken:list_chapter_id(),
    get_list_next_item(NowChapterId, lists:reverse(AllChapterIds)).

%% 获取下一章节的章节ID
get_next_chapter_id(NowChapterId) ->
    AllChapterIds = data_temple_awaken:list_chapter_id(),
    get_list_next_item(NowChapterId, AllChapterIds).

%% 获取下一子章节ID
get_next_sub_chapter_id(ChapterId, NowSubChapter) ->
    SubChapterIds = data_temple_awaken:list_sub_chapter(ChapterId),
    get_list_next_item(NowSubChapter, SubChapterIds).


%% 获取列表下一个元素
%% 比如 NowChapterId=3， 列表为[1,2,3,4,5,6] 返回4
%% @param NowChapterId 当前元素
%% @param List
%% @return 当前元素在该列表的下一个元素，无则返回 []
get_list_next_item(_NowChapterId, []) -> [];
get_list_next_item(NowChapterId, [H|T]) ->
    case NowChapterId == H of
        false ->
            get_list_next_item(NowChapterId, T);
        true ->
            case T of
                [NextChapterId|_] -> NextChapterId;
                _ -> []
            end
    end.

%% 关于坐骑模块的进度值处理，将{N阶M星} 的进度转成数字
deal_stage_condition(Stage, Star) ->
    Stage * 100 + Star.

%% 广播切换模型的信息
broadcast_info(Ps, ChapterId) ->
    #player_status{ figure = Figure } = Ps,
    #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(ChapterId),
    case ulists:keyfind(TypeId, 1, Figure#figure.mount_figure, {TypeId, 0}) of
        {_, FigureId} -> skip;
        {_, FigureId, _} -> skip
    end ,
    broadcast_info(Ps, ChapterId, FigureId),
    ok.
broadcast_info(Ps, ChapterId, FigureId) ->
    #player_status{
        id = RoleId,
        scene = SceneId, scene_pool_id = SPId,
        copy_id = CopyId, x = X, y = Y,
        battle_attr = BattleAttr, is_battle = IsBattle
    } = Ps,
    #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(ChapterId),
    IsCanRideMount = lib_mount:check_ride_mount_in_scene(SceneId),
    IsSatisfy = (FigureId == 0 orelse IsCanRideMount==false orelse IsBattle == ?IS_BATTLE_YES) andalso TypeId == ?MOUNT_ID,
    NewIsRide = ?IF(IsSatisfy, ?NOT_RIDE_STATUS, ?RIDE_STATUS),
    % 客户端要求type=:=11时推 41311
    case TypeId =:= 11 of
        true ->
            {ok, BinData1} = pt_413:write(41311, [RoleId, [{1, FigureId, 0}]]),
            lib_server_send:send_to_area_scene(SceneId, SPId, CopyId,  X, Y, BinData1);
        _ -> skip
    end,
    {ok, BinData} = pt_160:write(16001, [TypeId, RoleId, NewIsRide, FigureId, BattleAttr#battle_attr.speed]),
    lib_server_send:send_to_area_scene(SceneId, SPId, CopyId,  X, Y, BinData),
    ok.

%% 记录进度
%% 指定阶段不记录（产生的数据太多）
log_temple_awaken_chapter_stage(RoleId, ChapterId, KSubChapter, KStage, KProcess, KStatus) ->
    case lists:member({ChapterId, KSubChapter, KStage}, ?NO_LOG_ITEM_LIST) of
        false -> lib_log_api:log_temple_awaken_chapter_stage(RoleId, ChapterId, KSubChapter, KStage, KProcess, KStatus);
        _ -> ok
    end.

%%====================================================Inner Methods End=====================================================================================

%% 脱下生效中幻化形象（针对坐骑类）
tack_off_mount_type(Player, ChapterId, IsWare) ->
    #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(ChapterId),
    case lists:member(TypeId, [1,2,3,4,5])  of
        true when IsWare == ?IS_WARE ->
            #player_status{ status_mount = StatusMount } = Player,
            case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of
                #status_mount{ illusion_type = IllusionType, illusion_id = IllTypeId} ->
                    case IllusionType of
                        ?BASE_MOUNT_FIGURE ->
                            pp_mount:handle(16003, Player, [TypeId, IllusionType, 1, 0]);
                        _ ->
                            pp_mount:handle(16003, Player, [TypeId, IllusionType, IllTypeId, 0])
                    end;
                _ ->
                    {ok, Player}
            end;
        true when IsWare == ?NOT_WARE ->
            pp_mount:handle(16003, Player, [TypeId, 1, 1, 0]);
        _ ->
            {ok, Player}
    end.
