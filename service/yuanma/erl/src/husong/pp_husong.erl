%%%--------------------------------------
%%% @Module  : pp_husong
%%% @Author  : huyihao
%%% @Created : 2018.01.06
%%% @Description:  护送
%%%--------------------------------------
-module(pp_husong).
-export([handle/3]).
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("husong.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("activitycalen.hrl").
-include("daily.hrl").

%% 打开护送信息
handle(50000, Ps, []) ->
    #player_status{id = RoleId, figure = Figure} = Ps,
    #figure{lv = Lv} = Figure,
    LessTodayHuSongNum = lib_husong:get_husong_daily(RoleId),
    %% 限制次数
    TodayHuSongMax = mod_daily:get_limit_by_type(?MOD_HUSONG, ?HuSongDailyId),
    AngelIdList = data_husong:get_angel_id_list(), % 获取天使的列表
    %  获取首个开启中的活动
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL) of
        {ok, ActId} ->
            #base_ac{start_lv = OpenLv} = data_activitycalen:get_ac(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL, ActId),
            case Lv >= OpenLv of
                true ->
                    Code = ?SUCCESS,
                    IfDouble =
                        case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
                            {ok, _ActId1} -> 1;

                            _ -> 0
                        end,
                    NewPs = Ps;
                _ ->
                    Code = ?LEVEL_LIMIT,
                    NewPs = Ps,
                    IfDouble = 0
            end;
        _ ->
            Code = ?ERRCODE(err157_act_not_open),
            NewPs = Ps,
            IfDouble = 0
    end,
    RewardSendList =
        [begin
             AngelCon1 = data_husong:get_husong_angel_con(AngelId1),
             #husong_angel_con{
                 exp = Exp1,
                 coin = CoinNum1
             } = AngelCon1,
             ExpNum1 = ?HuSongExpFun(Lv, Exp1),
             case IfDouble of
                 0 ->
                     CoinNum2 = CoinNum1,
                     ExpNum2 = ExpNum1;
                 _ ->
                     CoinNum2 = CoinNum1 * 2,
                     ExpNum2 = ExpNum1 * 2
             end,
             {AngelId1, CoinNum2, ExpNum2}
         end || AngelId1 <- AngelIdList, AngelId1 =/= 0],
    {ok, Bin} = pt_500:write(50000, [Code, IfDouble, LessTodayHuSongNum, TodayHuSongMax, RewardSendList]),
    ?PRINT("50000  Code, IfDouble, LessTodayHuSongNum, TodayHuSongMax, RewardSendList:~w~n", [[Code, IfDouble, LessTodayHuSongNum, TodayHuSongMax, RewardSendList]]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};



%% 开始护送
handle(50002, Ps, [AngelId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        husong = HuSong
    } = Ps,
    #figure{lv = Lv} = Figure,
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL) of
        {ok, ActId} ->
            LeastTimes = lib_husong:get_husong_daily(RoleId),
            ?PRINT("HuSong :~p~n",[HuSong]),
            case checklist([{open_lv, Lv, ActId}, {least, LeastTimes}, {is_angel, AngelId}, {start_time, HuSong}]) of
                true ->
                    #husong_angel_con{cost = Cost} = data_husong:get_husong_angel_con(AngelId),
                    case Cost == [] of
                        true -> % 不需要消耗
                            Code = ?SUCCESS,
                            NewHuSong = HuSong#husong{
                                angel_id = AngelId,
                                start_time = utime:unixtime(),
                                stage = 1},
                            lib_husong:husong_sql(NewHuSong),
                            NewFigure = Figure#figure{husong_angel_id = AngelId},
                            NewPs = Ps#player_status{figure = NewFigure, husong = NewHuSong},
                            lib_husong_event:start_husong(NewPs);
                        false ->
                            case lib_goods_api:cost_objects_with_auto_buy(Ps, Cost, husong, "") of
                                {true, NewPlayerTmp, _} -> % 物品满足条件扣除
                                    Code = ?SUCCESS,
                                    NewHuSong = HuSong#husong{
                                        angel_id = AngelId,
                                        start_time = utime:unixtime(),
                                        stage = 1},
                                    lib_husong:husong_sql(NewHuSong),
                                    NewFigure = Figure#figure{husong_angel_id = AngelId},
                                    NewPs = NewPlayerTmp#player_status{figure = NewFigure, husong = NewHuSong},
                                    lib_husong_event:start_husong(NewPs);
                                {false, ErrorCode, NewPlayerTmp} ->
                                    Code = ErrorCode,
                                    NewPs = NewPlayerTmp
                            end
                    end;
                {false, ErrCode} ->
                    Code = ErrCode,
                    NewPs = Ps
            end;
        _ ->
            Code = ?ERRCODE(err157_act_not_open),
            NewPs = Ps
    end,
    {ok, Bin} = pt_500:write(50002, [Code, AngelId]),
    ?PRINT("50002  Code, AngleId:~w~n", [[Code, AngelId]]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};



%% 完成护送 Type 1阶段一 2阶段二
handle(50003, Ps, []) ->
    #player_status{id = RoleId, husong = HuSong, figure = Figure} = Ps,
    #figure{lv = Lv} = Figure,
    NowTime = utime:unixtime(),
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL) of
        {ok, ActId} ->
            #base_ac{start_lv = OpenLv} = data_activitycalen:get_ac(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL, ActId),
            case Lv >= OpenLv of
                true ->
                    #husong{angel_id = AngelId, stage = Stage, start_time = StartTime} = HuSong,
                    if
                        StartTime =:= 0 -> % 没有开始护送
                            Code = ?ERRCODE(err500_husong_not_start),
                            IfDouble = 0,
                            NewPs = Ps;
                        true ->
                            case NowTime >= StartTime + ?HuSongTime of
                                false -> % 护送时间不足
                                    Code = ?ERRCODE(err500_husong_time),
                                    IfDouble = 0,
                                    NewPs = Ps;
                                true ->
                                    case Stage =:= 1 of
                                        true ->
                                            Code = ?SUCCESS,
                                            % 护送奖励
                                            {NewPs1, RewardList} = lib_husong:husong_send_reward(Ps, AngelId, 1, 1),
                                            NewHuSong = HuSong#husong{
                                                angel_id = 0,
                                                stage = 0,
                                                reward_stage = 0,
                                                start_time = 0,
                                                end_timer = 0,
                                                invincible_skill = 0,
                                                ask_help_time = 0
                                            },
                                            lib_husong:husong_sql(NewHuSong),
                                            NewFigure1 = NewPs1#player_status.figure,
                                            NewFigure = NewFigure1#figure{
                                                husong_angel_id = 0
                                            },
                                            NewPs = NewPs1#player_status{
                                                husong = NewHuSong,
                                                figure = NewFigure
                                            },
                                            IfDouble =
                                                case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
                                                    {ok, _ActId1} -> 1;
                                                    _ -> 0
                                                end,
                                            lib_log_api:log_husong_end(RoleId, AngelId, StartTime, 1, 1, IfDouble, RewardList);
                                        false ->
                                            Code = ?ERRCODE(err500_husong_stage_wrong),
                                            IfDouble = 0,
                                            NewPs = Ps
                                    end
                            end
                    end;
                _ -> % 等级限制
                    Code = ?LEVEL_LIMIT,
                    IfDouble = 0,
                    AngelId = 0,
                    NewPs = Ps
            end;
        _ -> % 没有开启活动
            Code = ?ERRCODE(err157_act_not_open),
            IfDouble = 0,
            AngelId = 0,
            NewPs = Ps
    end,
    TodayHuSongNum = mod_daily:get_count(RoleId, ?MOD_HUSONG, ?HuSongDailyId),
    TodayHuSongMax = mod_daily:get_limit_by_type(?MOD_HUSONG, ?HuSongDailyId),
    LessTodayHuSongNum = max(0, (TodayHuSongMax - TodayHuSongNum)),
    {ok, Bin} = pt_500:write(50003, [Code, AngelId, IfDouble, LessTodayHuSongNum]),
    ?PRINT("50003  Code, AngelId, IfDouble, LessTodayHuSongNum:~w~n", [[Code, AngelId, IfDouble, LessTodayHuSongNum]]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 庇护
handle(50004, Ps, []) ->
    #player_status{
        id = RoleId,
        husong = HuSong,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL) of
        {ok, ActId} ->
            #base_ac{start_lv = OpenLv} = data_activitycalen:get_ac(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL, ActId),
            case Lv >= OpenLv of
                true ->
                    #husong{
                        start_time = StartTime,
                        invincible_skill = InvincibleSkill
                    } = HuSong,
                    if
                        StartTime =:= 0 ->
                            Code = ?ERRCODE(err500_husong_not_start),
                            NewPs = Ps;
                        InvincibleSkill >= ?HuSongInvincibleSkillNum ->
                            Code = ?ERRCODE(err500_husong_invincible_max),
                            NewPs = Ps;
                        true ->
                            case lib_skill_buff:add_buff(Ps, ?HuSongInvincibleSkillId, 1) of
                                {ok, NewPs1} ->
                                    Code = ?SUCCESS,
                                    NewHuSong = HuSong#husong{
                                        invincible_skill = InvincibleSkill + 1
                                    },
                                    lib_husong:husong_sql(NewHuSong),
                                    NewPs = NewPs1#player_status{
                                        husong = NewHuSong
                                    };
                                _ ->
                                    Code = ?FAIL,
                                    NewPs = Ps
                            end
                    end;
                _ ->
                    Code = ?LEVEL_LIMIT,
                    NewPs = Ps
            end;
        _ ->
            Code = ?ERRCODE(err157_act_not_open),
            NewPs = Ps
    end,
    {ok, Bin} = pt_500:write(50004, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 求助
handle(50005, Ps, []) ->
    #player_status{
        id = RoleId,
        husong = HuSong,
        guild = Guild,
        figure = Figure
    } = Ps,
    #figure{
        name = Name,
        lv = Lv
    } = Figure,
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL) of
        {ok, ActId} ->
            #base_ac{start_lv = OpenLv} = data_activitycalen:get_ac(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL, ActId),
            case Lv >= OpenLv of
                true ->
                    #husong{
                        angel_id = AngelId,
                        start_time = StartTime,
                        ask_help_time = AskhelpTime
                    } = HuSong,
                    NowTime = utime:unixtime(),
                    if
                        StartTime =:= 0 ->
                            Code = ?ERRCODE(err500_husong_not_start),
                            NewPs = Ps;
                        NowTime < AskhelpTime + ?HuSongAskHelpCD ->
                            Code = ?ERRCODE(err500_husong_ask_cd),
                            NewPs = Ps;
                        true ->
                            Code = ?SUCCESS,
                            NewHuSong = HuSong#husong{
                                ask_help_time = NowTime
                            },
                            lib_husong:husong_sql(NewHuSong),
                            NewPs = Ps#player_status{
                                husong = NewHuSong
                            },
                            #status_guild{
                                id = GuildId
                            } = Guild,
                            AngelCon = data_husong:get_husong_angel_con(AngelId),
                            #husong_angel_con{
                                name = AngelName
                            } = AngelCon,
                            % 公会广播
                            lib_chat:send_TV({guild, GuildId}, ?MOD_HUSONG, 2, [Name, RoleId, AngelId, AngelName, RoleId])
                    end;
                _ ->
                    Code = ?LEVEL_LIMIT,
                    NewPs = Ps
            end;
        _ ->
            Code = ?ERRCODE(err157_act_not_open),
            NewPs = Ps
    end,
    {ok, Bin} = pt_500:write(50005, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 玩家点击求助超链接
handle(50007, Ps, [AskHelpRoleId]) ->
    #player_status{
        id = RoleId,
        scene = SceneId
    } = Ps,
    case lib_player_check:check_all(Ps) of
        true ->
            AskHelpPid = misc:get_player_process(AskHelpRoleId),
            case misc:is_process_alive(AskHelpPid) of
                false ->
                    {ok, Bin} = pt_500:write(50007, [?ERRCODE(err500_husong_help_offline), 0, 0, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    lib_player:apply_cast(AskHelpPid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_husong, husogn_help, [RoleId, SceneId])
            end;
        {false, Code} ->
            {ok, Bin} = pt_500:write(50007, [Code, 0, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 登录请求护送信息
handle(50009, Ps, []) ->
    #player_status{
        id = RoleId,
        husong = HuSong,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    #husong{
        angel_id = AngelId,
        start_time = StartTime,
        stage = Stage,
        reward_stage = RewardStage,
        ask_help_time = AskhelpTime,
        invincible_skill = InvincibleSkill
    } = HuSong,
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
        {ok, ActId1} ->
            IfDouble = lib_husong:get_double_end_time(ActId1);
        _ ->
            IfDouble = 0
    end,
    case InvincibleSkill >= ?HuSongInvincibleSkillNum of
        true ->
            IfInvincibleSkill = 0;
        false ->
            IfInvincibleSkill = 1
    end,
    TodayHuSongTakeNumMax = mod_daily:get_limit_by_type(?MOD_HUSONG, ?HuSongTakeDailyId),
    TodayHuSongTakeNum = mod_daily:get_count(RoleId, ?MOD_HUSONG, ?HuSongTakeDailyId),
    TodayHuSongTakeExpNum = mod_daily:get_count(RoleId, ?MOD_HUSONG, ?HuSongTakeExpDailyId),
    TodayHuSongTakeCoinNum = mod_daily:get_count(RoleId, ?MOD_HUSONG, ?HuSongTakeCoinDailyId),
    LessTakeNum = max(0, (TodayHuSongTakeNumMax - TodayHuSongTakeNum)),
    EndTime = StartTime + ?HuSongTime,
    RewardListFirst = lib_husong:get_husong_reward(AngelId, 1, 1, Lv),
    RewardListSecond = lib_husong:get_husong_reward(AngelId, 2, 1, Lv),
    {ok, Bin} = pt_500:write(50009, [IfDouble, Stage, RewardStage, EndTime, AskhelpTime, IfInvincibleSkill, LessTakeNum, TodayHuSongTakeExpNum, TodayHuSongTakeCoinNum, RewardListFirst, RewardListSecond]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 护送完切到接任务npc坐标
handle(50010, Ps, []) ->
    #player_status{id = RoleId, husong = HuSong} = Ps,
    #husong{start_time = StartTime} = HuSong,
    case lib_player_check:check(Ps, in_husong) of
        {false, Code} ->
            NewPs = Ps;
        true ->
            TodayHuSongNum = mod_daily:get_count(RoleId, ?MOD_HUSONG, ?HuSongDailyId),
            TodayHuSongNumMax = mod_daily:get_limit_by_type(?MOD_HUSONG, ?HuSongDailyId),
            case StartTime of
                0 ->
                    case TodayHuSongNum < TodayHuSongNumMax of
                        true ->
                            Code = ?SUCCESS,
                            %%              change_scene(PS, 目标场景ID，0,房间号id,坐标X,坐标Y,是否需要特殊处理，List)
                            NewPs = lib_scene:change_scene(Ps, 1003, 0, 0, 5997, 4696, true, []);
                        false ->
                            Code = ?ERRCODE(err500_husong_end),
                            NewPs = Ps
                    end;
                _ ->
                    Code = ?ERRCODE(err500_husong_start),
                    NewPs = Ps
            end
    end,
    {ok, Bin} = pt_500:write(50010, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

handle(_Code, Ps, []) ->
    ?PRINT("ERR : ~p~n", [[?MODULE, _Code]]),
    {ok, Ps}.


%%-----------------------------------------------


check({open_lv, Lv, ActId}) ->
    #base_ac{start_lv = OpenLv} = data_activitycalen:get_ac(?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL, ActId),
    case Lv >= OpenLv of
        true -> true;
        false -> {false, ?LEVEL_LIMIT}
    end;


check({least, Times}) ->
    case Times > 0 of
        true -> true;
        false -> {false, ?ERRCODE(err500_times_not_enough)}
    end;

check({is_angel, AngelId}) ->
    AngelIdList = data_husong:get_angel_id_list(), % 获取天使的列表
    IsAngel = lists:member(AngelId, AngelIdList),
    case IsAngel == true of
        true -> true;
        false -> {false, ?ERRCODE(err500_not_angel_id)}
    end;

check({start_time, HuSong}) ->
    #husong{start_time = StartTime} = HuSong,
    ?PRINT("StartTime :~p~n",[StartTime]),
    case StartTime == 0 of
        true -> true;
        false -> {false ,?ERRCODE(err500_husong_start)}
    end;


check(_) -> {false, ?FAIL}.

checklist([]) -> true;
checklist([H | T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.

































