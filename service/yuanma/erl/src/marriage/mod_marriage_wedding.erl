%%%--------------------------------------
%%% @Module  : mod_marriage_wedding
%%% @Author  : huyihao
%%% @Created : 2017.12.5
%%% @Description:  婚姻婚礼进程
%%%--------------------------------------
-module(mod_marriage_wedding).
-behaviour(gen_server).

-include("common.hrl").
-include("boss.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("marriage.hrl").
-include("language.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("figure.hrl").

-export([start_link/1, stop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).
-export([]).

start_link(Args) ->
    gen_server:start_link(?MODULE, [Args], []).

stop(Pid) ->
    gen_server:cast(Pid, {'stop'}).

init([Args]) ->
    [RoleIdM, RoleIdW, TimeId, WeddingType, BeginTime] = Args,
    NowTime = utime:unixtime(),
    WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
    #wedding_time_con{
        begin_time = {BeginHour, BeginMinute},
        end_time = {EndHour, EndMinute}
    } = WeddingTimeCon,
    EndTime = EndHour*60*60+EndMinute*60-BeginHour*60*60-BeginMinute*60,
    ReadyStartTime = max(BeginTime - NowTime, 0),
    ReadyStartMin = ReadyStartTime div 60,
    ?PRINT("ReadyStartTime ~p~n", [ReadyStartTime]),
    util:send_after([], max(ReadyStartTime*1000, 100), self(), {welcome_start}),
    SqlRef = erlang:send_after(?WeddingSqlTime*1000, self(), {sql_wedding}),
    [FashionModelM, FashionModelW] = ?WeddingFashion,
    #figure{name = NameM, sex = SexM, fashion_model = FashionModelListM} = FigureM = lib_role:get_role_figure(RoleIdM),
    #figure{name = NameW, sex = SexW, fashion_model = FashionModelListW} = FigureW = lib_role:get_role_figure(RoleIdW),
    #wedding_info_con{wedding_name = WeddingName} = data_wedding:get_wedding_info_con(WeddingType),
    lib_chat:send_TV({all}, ?MOD_MARRIAGE, 7, [NameM, NameW, util:make_sure_binary(WeddingName), ReadyStartMin, RoleIdM]),
    RealFashionModelM = ?IF(SexM == ?MALE, FashionModelM, FashionModelW),
    RealFashionModelW = ?IF(SexW == ?MALE, FashionModelM, FashionModelW),
    State = #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM#figure{fashion_model = [{PosId, RealFashionModelM, 0} || {PosId, _ModId, _ColorId} <- FashionModelListM]},
        role_id_w = RoleIdW,
        figure_w = FigureW#figure{fashion_model = [{PosId, RealFashionModelW, 0} || {PosId, _ModId, _ColorId} <- FashionModelListM]},
        wedding_type = WeddingType,
        wedding_begin_time = BeginTime,
        wedding_end_time = BeginTime + EndTime,
        sql_timer = SqlRef
    },
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {reply, ok, State};
        Result ->
            Result
    end.

do_handle_call({check_wedding_fires, RoleId, FiresType}, _From, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        enter_member_list = EnterMemberList,
        aura= Aura,
        if_sql = IfSql
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            Return = {false, ?ERRCODE(err172_wedding_not_scene)},
            NewState = State;
        #wedding_enter_member_info{if_enter = 0} ->
            Return = {false, ?ERRCODE(err172_wedding_not_scene)},
            NewState = State;
        EnterMemberInfo ->
            #wedding_enter_member_info{
                free_fires = FreeFiresList
            } = EnterMemberInfo,
            FiresCon = data_wedding:get_wedding_fires_con(FiresType),
            #wedding_fires_con{
                cost_list = CostList,
                free_times = FreeTimes,
                aura = AddAura
            } = FiresCon,
            case FreeTimes > 0 of
                false ->
                    Return = {cost, CostList},
                    NewFreeFiresList = FreeFiresList,
                    NewAura = Aura,
                    NewIfSql = IfSql;
                true ->
                    case lists:keyfind(FiresType, 1, FreeFiresList) of
                        false ->
                            Return = free,
                            NewFreeFiresList = [{FiresType, 1}|FreeFiresList],
                            NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
                            NewIfSql = 1,
                            lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 3, Aura, NewAura);
                        {_FiresType, FreeNum} ->
                            case FreeNum >= FreeTimes of
                                false ->
                                    Return = free,
                                    NewFreeFiresList = lists:keyreplace(FiresType, 1, FreeFiresList, {FiresType, FreeNum+1}),
                                    NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
                                    NewIfSql = 1,
                                    lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 3, Aura, NewAura);
                                true ->
                                    Return = {cost, CostList},
                                    NewFreeFiresList = FreeFiresList,
                                    NewAura = Aura,
                                    NewIfSql = IfSql
                            end
                    end
            end,
            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                free_fires = NewFreeFiresList
            },
            NewEnterMemberList = lists:keyreplace(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
            NewState = State#wedding_state{
                enter_member_list = NewEnterMemberList,
                aura = NewAura,
                if_sql = NewIfSql
            },
            lib_marriage_wedding:push_wedding_info_aura(NewState)
    end,
    {reply, Return, NewState};

do_handle_call({check_wedding_candies, RoleId, CandiesType}, _From, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        enter_member_list = EnterMemberList,
        aura= Aura,
        less_normal_candies = LessNormalCandies,
        less_special_candies = LessSpecialCandies
    } = State,
    case lists:member(RoleId, [RoleIdM,RoleIdW]) of
        false ->
            Return = {false, ?ERRCODE(err172_wedding_not_owner)},
            NewState = State;
        true ->
            case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
                false ->
                    Return = {false, ?ERRCODE(err172_wedding_not_scene)},
                    NewState = State;
                #wedding_enter_member_info{if_enter = 0} ->
                    Return = {false, ?ERRCODE(err172_wedding_not_scene)},
                    NewState = State;
                EnterMemberInfo ->
                    #wedding_enter_member_info{
                        free_candies = FreeCandiesList
                    } = EnterMemberInfo,
                    case CandiesType of
                        1 ->
                            CreatType = 2,
                            {_MonId, MonNum} = lib_marriage_wedding:get_mon_id_num(2),
                            NewLessNormalCandies = LessNormalCandies + MonNum,
                            NewLessSpecialCandies = LessSpecialCandies,
                            CandiesId = ?WeddingNormalCandies;
                        _ ->
                            CreatType = 3,
                            {_MonId, MonNum} = lib_marriage_wedding:get_mon_id_num(3),
                            NewLessNormalCandies = LessNormalCandies,
                            NewLessSpecialCandies = LessSpecialCandies + MonNum,
                            CandiesId = ?WeddingSpecialCandies
                    end,
                    CandiesCon = data_wedding:get_wedding_candies_con(CandiesId),
                    #wedding_candies_con{
                        cost_list = CostList,
                        free_times = FreeTimes,
                        aura = AddAura
                    } = CandiesCon,
                    case lists:keyfind(CandiesType, 1, FreeCandiesList) of
                        false ->
                            Return = free,
                            NewFreeCandiesList = [{CandiesType, 1}|FreeCandiesList],
                            NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
                            lib_marriage_wedding:creat_mon(CreatType, RoleIdM),
                            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                                free_candies = NewFreeCandiesList
                            },
                            NewEnterMemberList = lists:keyreplace(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
                            NewState = State#wedding_state{
                                enter_member_list = NewEnterMemberList,
                                aura = NewAura,
                                if_sql = 1,
                                less_normal_candies = NewLessNormalCandies,
                                less_special_candies = NewLessSpecialCandies
                            },
                            lib_marriage_wedding:push_wedding_info_aura(NewState),
                            lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 2, Aura, NewAura);
                        {_CandiesType, FreeNum} ->
                            case FreeNum >= FreeTimes of
                                false ->
                                    Return = free,
                                    NewFreeCandiesList = lists:keyreplace(CandiesType, 1, FreeCandiesList, {CandiesType, FreeNum+1}),
                                    NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
                                    lib_marriage_wedding:creat_mon(CreatType, RoleIdM),
                                    NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                                        free_candies = NewFreeCandiesList
                                    },
                                    NewEnterMemberList = lists:keyreplace(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
                                    NewState = State#wedding_state{
                                        enter_member_list = NewEnterMemberList,
                                        aura = NewAura,
                                        if_sql = 1,
                                        less_normal_candies = NewLessNormalCandies,
                                        less_special_candies = NewLessSpecialCandies
                                    },
                                    lib_marriage_wedding:push_wedding_info_aura(NewState),
                                    lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 2, Aura, NewAura);
                                true ->
                                    Return = {cost, CostList},
                                    NewState = State
                            end
                    end
            end
    end,
    {reply, Return, NewState};

do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(Info, State) ->
    case catch do_handle_cast(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_cast({wedding_fires, RoleId, Name, FiresType}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        enter_member_list = EnterMemberList,
        aura = Aura
    } = State,
    FiresCon = data_wedding:get_wedding_fires_con(FiresType),
    #wedding_fires_con{
        fires_name = FiresName,
        aura = AddAura,
        reward_list = RewardList
    } = FiresCon,
    NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
    NewState = State#wedding_state{
        aura = NewAura,
        if_sql = 1
    },
    [{_GoodsType, GoodsTypeId, _GoodsNum}|_] = RewardList,
    _GoodsName = data_goods:get_goods_name(GoodsTypeId),
    {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_fires_success), [util:make_sure_binary(FiresName)]}),
    {ok, Bin} = pt_172:write(17267, [CodeInt, CodeArgs, FiresType, RoleId]),
    %lib_server_send:send_to_uid(RoleId, Bin),
    lib_server_send:send_to_scene(?WeddingScene, 0, RoleIdM, Bin),
    lib_marriage_wedding:push_wedding_info_aura(NewState),
    lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 3, Aura, NewAura),
    %DanMuMsg = utext:get(1720015, [Name, util:make_sure_binary(FiresName), AddAura]),
    %lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, wedding_danmu, [binary_to_list(util:make_sure_binary(DanMuMsg)), 0]),
    lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 9, [Name, util:make_sure_binary(FiresName), AddAura]),
    {noreply, NewState};

do_handle_cast({wedding_candies, RoleId, Name, CandiesType}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        enter_member_list = EnterMemberList,
        aura = Aura,
        less_normal_candies = LessNormalCandies,
        less_special_candies = LessSpecialCandies
    } = State,
    case CandiesType of
        1 ->
            CreatType = 2,
            {_MonId, MonNum} = lib_marriage_wedding:get_mon_id_num(2),
            NewLessNormalCandies = LessNormalCandies + MonNum,
            NewLessSpecialCandies = LessSpecialCandies,
            CandiesId = ?WeddingNormalCandies;
        _ ->
            CreatType = 3,
            {_MonId, MonNum} = lib_marriage_wedding:get_mon_id_num(3),
            NewLessNormalCandies = LessNormalCandies,
            NewLessSpecialCandies = LessSpecialCandies + MonNum,
            CandiesId = ?WeddingSpecialCandies
    end,
    CandiesCon = data_wedding:get_wedding_candies_con(CandiesId),
    #wedding_candies_con{
        candies_name = CandiesName,
        aura = AddAura
    } = CandiesCon,
    lib_marriage_wedding:creat_mon(CreatType, RoleIdM),
    NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
    NewState = State#wedding_state{
        aura = NewAura,
        if_sql = 1,
        less_normal_candies = NewLessNormalCandies,
        less_special_candies = NewLessSpecialCandies
    },
    {ok, Bin} = pt_172:write(17266, [?SUCCESS]),
    lib_server_send:send_to_uid(RoleId, Bin),
    lib_marriage_wedding:push_wedding_info_aura(NewState),
    lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 2, Aura, NewAura),
    %% 喜糖传闻
    % case RoleId of
    %     RoleIdM ->
    %         RoleName = FigureM#figure.name;
    %     _ ->
    %         RoleName = FigureW#figure.name
    % end,
    lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 8, [Name, util:make_sure_binary(CandiesName), AddAura]),
    {noreply, NewState};

do_handle_cast({get_wedding_info, RoleId}, State) ->
    lib_marriage_wedding:send_wedding_info(State, RoleId),
    {noreply, State};

do_handle_cast({enter_wedding, RoleId, Sid, IfOut}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        man_in = ManIn,
        woman_in = WomanIn,
        pos_count = PosCount,
        enter_member_list = EnterMemberList
    } = State,
    case RoleId of
        RoleIdM ->
            NewManIn = 1,
            FashionArgs = [{fashion_replace, FigureM#figure.fashion_model}],
            NewWomanIn = WomanIn;
        RoleIdW ->
            NewManIn = ManIn,
            FashionArgs = [{fashion_replace, FigureW#figure.fashion_model}],
            NewWomanIn = 1;
        _ ->
            NewManIn = ManIn,
            FashionArgs = [],
            NewWomanIn = WomanIn
    end,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            NewPosCount = PosCount + 1,
            GetNCNum = 0,
            GetSCNum = 0,
            NewEnterMemberInfo = #wedding_enter_member_info{
                pos_id = NewPosCount,
                role_id = RoleId,
                sid = Sid,
                enter_time = utime:unixtime(),
                if_enter = 1
            };
        EnterMemberInfo ->
            NewPosCount = PosCount,
            #wedding_enter_member_info{
                get_normal_candies_num = GetNCNum,
                get_special_candies_num = GetSCNum
            } = EnterMemberInfo,
            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                sid = Sid,
                enter_time = utime:unixtime(),
                if_enter = 1
            }
    end,
    %% 切场景
    case data_wedding:get_wedding_guest_position_con(NewPosCount) of 
        #wedding_guest_position_con{x = X, y = Y} -> ok;
        _ -> X = 1500, Y = 1500
    end,
    CollectChecker = {lib_marriage_wedding, check_collect_mon_candies, {GetNCNum, GetSCNum}},
    lib_scene:player_change_scene(RoleId, ?WeddingScene, 0, RoleIdM, X, Y, IfOut, [{action_lock, ?ERRCODE(err172_in_wedding_scene)}, {collect_checker, CollectChecker}|FashionArgs]),
    NewEnterMemberList = lists:keystore(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
    NewState = State#wedding_state{
        man_in = NewManIn,
        woman_in = NewWomanIn,
        pos_count = NewPosCount,
        enter_member_list = NewEnterMemberList,
        if_sql = 1
    },
    GuestSendList = lib_marriage_wedding:get_guest_send_list(RoleIdM, RoleIdW, NewEnterMemberList),
    lib_marriage_wedding:get_anime_info(0, RoleIdM, FigureM, RoleIdW, FigureW, GuestSendList),
    lib_marriage_wedding:send_wedding_info(NewState),
    ?PRINT("enter wedding succ ============= ~n", []),
    {noreply, NewState};

do_handle_cast({quit_wedding, RoleId}, State) ->
    #wedding_state{
        enter_member_list = EnterMemberList
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false -> NewState = State;
        EnterMemberInfo ->
            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                if_enter = 0
            },
            NewEnterMemberList = lists:keystore(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
            NewState = State#wedding_state{
                enter_member_list = NewEnterMemberList
            }
    end,
    lib_marriage_wedding:send_wedding_info(NewState),
    ?PRINT("quit_wedding succ ============= ~n", []),
    {noreply, NewState};

do_handle_cast({kill_trouble_maker_solve, RoleId, SolveId, MonOnlyId}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        enter_member_list = EnterMemberList
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_scene), ""]),
            lib_server_send:send_to_uid(RoleId, Bin);
        #wedding_enter_member_info{if_enter = 0} ->
            {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_scene), ""]),
            lib_server_send:send_to_uid(RoleId, Bin);
        EnterMemberInfo ->
            #wedding_enter_member_info{
                get_trouble_maker_num = GetTMNum
            } = EnterMemberInfo,
            WeddingTMLimitNum = ?WeddingTMLimitNum,
            if
                GetTMNum >= WeddingTMLimitNum ->
                    {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_tm_limit), []}),
                    {ok, Bin} = pt_172:write(17269, [CodeInt, CodeArgs]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                SolveId =:= 0 ->
                    {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_not_have_solve), []}),
                    {ok, Bin} = pt_172:write(17269, [CodeInt, CodeArgs]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    Args = [RoleIdM, 1, MonOnlyId, self(), SolveId, RoleId],
                    mod_scene_agent:apply_cast(?WeddingScene, 0, lib_marriage_wedding, kill_trouble_maker_solve, [Args])
            end
    end,
    {noreply, State};

do_handle_cast({kill_trouble_maker_solve_success, RoleId, ConId}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        enter_member_list = EnterMemberList,
        aura = Aura,
        trouble_maker_reflesh_times = TMRefleshTimes,
        trouble_maker_num = TroubleMakerNum
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            NewState = State;
        EnterMemberInfo ->
            #wedding_enter_member_info{
                get_trouble_maker_num = GetTMNum
            } = EnterMemberInfo,
            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                get_trouble_maker_num = GetTMNum + 1
            },
            NewEnterMemberList = lists:keyreplace(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
            TroubleMakerCon = data_wedding:get_wedding_trouble_maker_con(ConId),
            #wedding_trouble_maker_con{
                aura = AddAura,
                reward_list = RewardList,
                trouble_maker_name = TMName
            } = TroubleMakerCon,
            NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
            NewTroubleMakerNum = max(0, (TroubleMakerNum-1)),
            case NewTroubleMakerNum =:= 0 andalso TMRefleshTimes >= ?WeddingTroubleMakerRefleshTimes of
                true ->
                    {CollectMonId, _Position} = ?WeddingTroubleMakerCollect,
                    lib_mon:clear_scene_mon_by_mids(?WeddingScene, 0, RoleIdM, 1, [CollectMonId]),
                    lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 16, []),
                    {ok, Bin2} = pt_172:write(17274, [0]),
                    lib_server_send:send_to_scene(?WeddingScene, 0, RoleIdM, Bin2);
                false ->
                    skip
            end,
            NewState = State#wedding_state{
                enter_member_list = NewEnterMemberList,
                aura = NewAura,
                trouble_maker_num = NewTroubleMakerNum,
                if_sql = 1
            },
            lib_goods_api:send_reward_by_id(RewardList, wedding_kill_trouble, RoleId),
            [{_GoodsType, GoodsTypeId, _GoodsNum}|_] = RewardList,
            GoodsName = data_goods:get_goods_name(GoodsTypeId),
            {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_tm_solve_success), [util:make_sure_binary(TMName), GoodsName]}),
            {ok, Bin} = pt_172:write(17269, [CodeInt, CodeArgs]),
            lib_server_send:send_to_uid(RoleId, Bin),
            lib_marriage_wedding:send_wedding_info(NewState),
            lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 1, Aura, NewAura)
    end,
    {noreply, NewState};

do_handle_cast({collect_mon_table, RoleId, Args}, State) ->
    #wedding_state{
        enter_member_list = EnterMemberList
    } = State,
    [MonOnlyId, _Mid, _AddAura, Type, _WeddingPid] = Args,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            {ok, Bin} = pt_172:write(17271, [?ERRCODE(err172_wedding_not_scene), "", Type]),
            lib_server_send:send_to_uid(RoleId, Bin);
        EnterMemberInfo ->
            #wedding_enter_member_info{
                table_list = TableList
            } = EnterMemberInfo,
            case lists:member(MonOnlyId, TableList) of
                true ->
                    {ok, Bin} = pt_172:write(17271, [?ERRCODE(err172_wedding_already_eat), "", Type]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                false ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, collect_mon_player, [Args])
            end
    end,
    {noreply, State};

do_handle_cast({collect_mon_success, RoleId, AddAura, Type, MonOnlyId, Mid}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        aura = Aura,
        less_normal_candies = LessNormalCandies,
        less_special_candies = LessSpecialCandies,
        enter_member_list = EnterMemberList
    } = State,
    EnterMemberInfo = lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList),
    #wedding_enter_member_info{
        table_list = TableList,
        get_normal_candies_num = GetNCNum,
        get_special_candies_num = GetSCNum
    } = EnterMemberInfo,
    case Type of
        1 ->            
            NewTableList = [MonOnlyId|TableList],
            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                table_list = NewTableList
            },
            NewLessNormalCandies = LessNormalCandies,
            NewLessSpecialCandies = LessSpecialCandies,
            case data_wedding:get_wedding_table_con(Mid) of 
                #wedding_table_con{table_name = TableName} -> ok;
                _ -> TableName = "???"
            end,
            {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_feast_success), [util:make_sure_binary(TableName)]}),
            {ok, Bin} = pt_172:write(17271, [CodeInt, CodeArgs, Type]),
            lib_server_send:send_to_uid(RoleId, Bin);
        _ ->
            lib_mon:clear_scene_mon_by_ids(?WeddingScene, 0, 1, [MonOnlyId]),
            case Type of
                2 ->
                    NewGetNCNum = GetNCNum + 1,
                    NewGetSCNum = GetSCNum,
                    NewLessNormalCandies = max(0, (LessNormalCandies-1)),
                    NewLessSpecialCandies = LessSpecialCandies;
                _ ->
                    NewGetNCNum = GetNCNum,
                    NewGetSCNum = GetSCNum + 1,
                    NewLessNormalCandies = LessNormalCandies,
                    NewLessSpecialCandies = max(0, (LessSpecialCandies-1))
            end,
            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                get_normal_candies_num = NewGetNCNum,
                get_special_candies_num = NewGetSCNum
            },
            CollectChecker = {lib_marriage_wedding, check_collect_mon_candies, {NewGetNCNum, NewGetSCNum}},
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, update_wedding_collect_checker, [CollectChecker]),
            case data_wedding:get_wedding_candies_con(Mid) of 
                #wedding_candies_con{candies_name = CandiesName, reward_list = _RewardList, limit_num = LimitNum} -> ok;
                _ ->
                    CandiesName = "???", LimitNum = 10
            end,
            %[{_GoodsType, GoodsTypeId, _GoodsNum}|_] = RewardList,
            %GoodsName = data_goods:get_goods_name(GoodsTypeId),
            NewGetNum = ?IF(Type == 2, NewGetNCNum, NewGetSCNum),
            {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_candies_success), [util:make_sure_binary(CandiesName), NewGetNum, LimitNum]}),
            {ok, Bin} = pt_172:write(17271, [CodeInt, CodeArgs, Type]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    NewEnterMemberList = lists:keyreplace(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
    NewAura = lib_marriage_wedding:add_aura(Aura, AddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
    NewState = State#wedding_state{
        aura = NewAura,
        if_sql = 1,
        less_normal_candies = NewLessNormalCandies,
        less_special_candies = NewLessSpecialCandies,
        enter_member_list = NewEnterMemberList
    },
    lib_marriage_wedding:send_wedding_info(NewState, RoleId),
    AddAura > 0 andalso lib_marriage_wedding:push_wedding_info_aura(NewState),
    lib_log_api:log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, 4, Aura, NewAura),
    {noreply, NewState};

do_handle_cast({get_wedding_guest_info, RoleId}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        enter_member_list = EnterMemberList
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            {ok, Bin} = pt_172:write(17272, [?ERRCODE(err172_wedding_not_scene), 0, 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        EnterMemberInfo ->
            #wedding_enter_member_info{
                free_candies = FreeCandies,
                free_fires = FreeFires,
                table_list = TableList
            } = EnterMemberInfo,
            case lists:member(RoleId, [RoleIdM, RoleIdW]) of
                true ->
                    IfMaster = 1,
                    CandiesCon = data_wedding:get_wedding_candies_con(?WeddingNormalCandies),
                    CandiesFreeTimesMax = CandiesCon#wedding_candies_con.free_times,
                    case lists:keyfind(1, 1, FreeCandies) of
                        false ->
                            FreeCandiesNum = 0;
                        {_Id, FreeCandiesNum} ->
                            skip
                    end,
                    LessFreeCandies = max(0, (CandiesFreeTimesMax - FreeCandiesNum));
                false ->
                    IfMaster = 0,
                    LessFreeCandies = 0
            end,
            FiresCon = data_wedding:get_wedding_fires_con(1),
            case lists:keyfind(1, 1, FreeFires) of
                false ->
                    FreeFiresNum = 0;
                {_Id1, FreeFiresNum} ->
                    skip
            end,
            LessFreeFires = max(0, (FiresCon#wedding_fires_con.free_times - FreeFiresNum)),
            {ok, Bin} = pt_172:write(17272, [?SUCCESS, IfMaster, LessFreeCandies, LessFreeFires, TableList]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    {noreply, State};

do_handle_cast({get_wedding_tm_info, RoleId}, State) ->
    #wedding_state{
        enter_member_list = EnterMemberList,
        trouble_maker_num = TroubleMakerNum
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            Type = 0;
        _ ->
            case TroubleMakerNum =< 0 of
                true ->
                    Type = 0;
                false ->
                    Type = 1
            end
    end,
    {ok, Bin} = pt_172:write(17274, [Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({get_wedding_exp_info, RoleId}, State) ->
    #wedding_state{
        enter_member_list = EnterMemberList
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            skip;
        #wedding_enter_member_info{all_exp = AllExp} ->
            {ok, Bin} = pt_172:write(17275, [AllExp]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    {noreply, State};

do_handle_cast({wedding_danmu, RoleId, Msg, TkTime}, State) ->
    #wedding_state{
        enter_member_list = EnterMemberList
    } = State,
    #wedding_state{
        enter_member_list = EnterMemberList
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            Code = ?ERRCODE(err172_wedding_not_scene);
        #wedding_enter_member_info{if_enter = 0} ->
            Code = ?ERRCODE(err172_wedding_not_scene);
        _ ->
            Code = ?SUCCESS,
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, wedding_danmu, [Msg, TkTime])
    end,
    case Code == ?SUCCESS of 
        true -> skip;
        _ ->
            {ok, Bin} = pt_172:write(17270, [Code]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    {noreply, State};

do_handle_cast({get_anime_info, RoleId}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        enter_member_list = EnterMemberList
    } = State,
    GuestSendList = lib_marriage_wedding:get_guest_send_list(RoleIdM, RoleIdW, EnterMemberList),
    lib_marriage_wedding:get_anime_info(RoleId, RoleIdM, FigureM, RoleIdW, FigureW, GuestSendList),
    {noreply, State};

do_handle_cast({wedding_exp_success, RoleId, ExpNum}, State) ->
    #wedding_state{
        enter_member_list = EnterMemberList
    } = State,
    case lists:keyfind(RoleId, #wedding_enter_member_info.role_id, EnterMemberList) of
        false ->
            NewState = State;
        EnterMemberInfo ->
            #wedding_enter_member_info{
                all_exp = AllExp
            } = EnterMemberInfo,
            NewAllExp = AllExp + ExpNum,
            NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                all_exp = NewAllExp
            },
            {ok, Bin} = pt_172:write(17275, [NewAllExp]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewEnterMemberList = lists:keyreplace(RoleId, #wedding_enter_member_info.role_id, EnterMemberList, NewEnterMemberInfo),
            NewState = State#wedding_state{
                enter_member_list = NewEnterMemberList
            }
    end,
    {noreply, NewState};

do_handle_cast({gm_wedding_feast, _RoleIdM}, State) ->
    #wedding_state{
        stage_timer = StageTimer,
        trouble_maker_timer = TroubleMakerTimer,
        stage_send_tv_timer = StageSendTVTimer,
        enter_member_list = _EnterMemberList
    } = State,
    util:cancel_timer(StageTimer),
    util:cancel_timer(TroubleMakerTimer),
    util:cancel_timer(StageSendTVTimer),
    NowTime = utime:unixtime(),
    NewStageTimer = erlang:send_after(100, self(), {dinner_start}),
    ?PRINT("gm_wedding_feast ~p~n", [start]),
    NewState = State#wedding_state{
        stage_id = 2,
        stage_timer = NewStageTimer,
        stage_begin_time = NowTime,
        stage_end_time = NowTime,
        trouble_maker_timer = 0
    },
    {noreply, NewState};

do_handle_cast({gm_wedding_anime, _RoleIdM}, State) ->
    #wedding_state{
        stage_timer = StageTimer,
        trouble_maker_timer = TroubleMakerTimer,
        stage_send_tv_timer = StageSendTVTimer,
        enter_member_list = _EnterMemberList
    } = State,
    util:cancel_timer(StageTimer),
    util:cancel_timer(TroubleMakerTimer),
    util:cancel_timer(StageSendTVTimer),
    NowTime = utime:unixtime(),
    NewStageTimer = erlang:send_after(100, self(), {anime_start}),
    ?PRINT("gm_wedding_anime ~p~n", [start]),
    NewState = State#wedding_state{
        stage_id = 1,
        stage_timer = NewStageTimer,
        stage_begin_time = NowTime,
        stage_end_time = NowTime,
        trouble_maker_timer = 0
    },
    {noreply, NewState};

do_handle_cast({'stop'}, State) ->
    {stop, normal, State};

do_handle_cast(_Info, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_info({sql_wedding}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        man_in = ManIn,
        woman_in = WomanIn,
        if_sql = IfSql,
        enter_member_list = EnterMemberList,
        aura = Aura
    } = State,
    SqlRef = erlang:send_after(?WeddingSqlTime*1000, self(), {sql_wedding}),
    case IfSql of
        0 ->
            skip;
        _ ->
            MemberIdList = [MemBerRoleId||#wedding_enter_member_info{role_id = MemBerRoleId} <- EnterMemberList],
            SMemberIdList = util:term_to_string(MemberIdList),
            ReSql = io_lib:format(?ReplaceMWeddingRestartSql, [RoleIdM, RoleIdW, ManIn, WomanIn, Aura, SMemberIdList]),
            db:execute(ReSql)
    end,
    NewState = State#wedding_state{
        sql_timer = SqlRef,
        if_sql = 0
    },
    {noreply, NewState};

do_handle_info({welcome_start}, State) ->
    #wedding_state{
        wedding_type = WeddingType,
        stage_timer = StageTimer,
        stage_send_tv_timer = StageSendTVTimer
    } = State,
    util:cancel_timer(StageTimer),
    util:cancel_timer(StageSendTVTimer),
    NowTime = utime:unixtime(),
    WeddingStageCon = data_wedding:get_wedding_time_stage_con(1),
    #wedding_time_stage_con{
        continue_time = ContinueTime
    } = WeddingStageCon,
    WeddingConInfo = data_wedding:get_wedding_info_con(WeddingType),
    #wedding_info_con{
        exp_time = ExpTime
    } = WeddingConInfo,
    CandiesGap = ?SysCandyTimeGap,
    NewStageTimer = erlang:send_after(ContinueTime*1000, self(), {anime_start}),
    ExpTimer = erlang:send_after(ExpTime*1000, self(), {wedding_exp}),
    CandiesTimer = erlang:send_after(CandiesGap*1000, self(), {sys_refresh_candies}),
    AddAuraTime = ?WeddingAddAuraTime,
    AuraTimer = erlang:send_after(AddAuraTime*1000, self(), {add_aura_time}),
    NewStageSendTVTimer = erlang:send_after(max(0, (ContinueTime-15))*1000, self(), {stage_send_tv, 2}),
    %TroubleMakerTimer = erlang:send_after(?WeddingTroubleMakerAppearTime*1000, self(), {trouble_maker_reflesh}),
    NewState = State#wedding_state{
        stage_id = 1,
        stage_timer = NewStageTimer,
        stage_begin_time = NowTime,
        stage_end_time = NowTime + ContinueTime,
        %trouble_maker_timer = TroubleMakerTimer,
        exp_timer = ExpTimer,
        aura_timer = AuraTimer,
        stage_send_tv_timer = NewStageSendTVTimer,
        candies_timer = CandiesTimer
    },
    {noreply, NewState};

do_handle_info({anime_start}, State) ->
    #wedding_state{
        role_id_m = _RoleIdM,
        role_id_w = _RoleIdW,
        man_in = _ManIn,
        woman_in = _WomanIn,
        stage_timer = StageTimer,
        trouble_maker_timer = TroubleMakerTimer,
        stage_send_tv_timer = StageSendTVTimer,
        enter_member_list = _EnterMemberList
    } = State,
    util:cancel_timer(StageTimer),
    util:cancel_timer(TroubleMakerTimer),
    util:cancel_timer(StageSendTVTimer),
    % case ManIn =:= 1 andalso WomanIn =:= 1 of
    %     false ->
    %         % MemberIdList = [MemBerRoleId||#wedding_enter_member_info{role_id = MemBerRoleId} <- EnterMemberList],
    %         % lib_offline_api:apply_cast(lib_marriage_wedding, wedding_break_off, [RoleIdM, RoleIdW, MemberIdList]),
    %         % do_handle_info({wedding_end}, State);
    %         NowTime = utime:unixtime(),
    %         NewStageTimer = erlang:send_after(100, self(), {dinner_start}),
    %         NewState = State#wedding_state{
    %             stage_id = 2,
    %             stage_timer = NewStageTimer,
    %             stage_begin_time = NowTime,
    %             stage_end_time = NowTime,
    %             trouble_maker_timer = 0,
    %             less_normal_candies = 0,
    %             less_special_candies = 0
    %         },
    %         {noreply, NewState};
    %     true ->
            %MonIdList = data_wedding:get_trouble_maker_list(),
            %CandiesList = data_wedding:get_wedding_candies_list(),
            %MonIdList1 = CandiesList,
            %lib_mon:clear_scene_mon_by_mids(?WeddingScene, 0, RoleIdM, 1, MonIdList1),
    NowTime = utime:unixtime(),
    WeddingStageCon = data_wedding:get_wedding_time_stage_con(2),
    #wedding_time_stage_con{
        continue_time = ContinueTime
    } = WeddingStageCon,
    NewStageTimer = erlang:send_after(ContinueTime*1000, self(), {dinner_start}),
    NewStageSendTVTimer = erlang:send_after(max(0, (ContinueTime-15))*1000, self(), {stage_send_tv, 3}),
    NewState = State#wedding_state{
        stage_id = 2,
        stage_timer = NewStageTimer,
        stage_begin_time = NowTime,
        stage_end_time = NowTime + ContinueTime,
        % trouble_maker_timer = 0,
        % less_normal_candies = 0,
        % less_special_candies = 0,
        stage_send_tv_timer = NewStageSendTVTimer
    },
    %{ok, Bin2} = pt_172:write(17274, [0]),
    %lib_server_send:send_to_scene(?WeddingScene, 0, RoleIdM, Bin2),
    lib_marriage_wedding:send_wedding_info(NewState),
    {noreply, NewState};
    % end;

do_handle_info({dinner_start}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        stage_timer = StageTimer,
        wedding_type = WeddingType
    } = State,
    util:cancel_timer(StageTimer),
    case WeddingType of
        1 ->
            MonCreType = 4;
        2 ->
            MonCreType = 5;
        _ ->
            MonCreType = 6
    end,
    lib_marriage_wedding:creat_mon(MonCreType, RoleIdM),
    NowTime = utime:unixtime(),
    WeddingStageCon = data_wedding:get_wedding_time_stage_con(3),
    #wedding_time_stage_con{
        continue_time = ContinueTime
    } = WeddingStageCon,
    NewStageTimer = erlang:send_after(ContinueTime*1000, self(), {wedding_end}),
    NewState = State#wedding_state{
        stage_id = 3,
        stage_timer = NewStageTimer,
        stage_begin_time = NowTime,
        stage_end_time = NowTime + ContinueTime
    },
    lib_marriage_wedding:send_wedding_info(NewState),
    lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 11, []),
    {noreply, NewState};

%% 阶段前传闻
do_handle_info({stage_send_tv, Stage}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        stage_send_tv_timer = StageSendTVTimer
    } = State,
    util:cancel_timer(StageSendTVTimer),
    case Stage of
        2 ->
            lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 10, []);
        _ ->
            ok
            %lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 18, [])
    end,
    NewState = State#wedding_state{
        stage_send_tv_timer = 0
    },
    {noreply, NewState};

do_handle_info({trouble_maker_reflesh}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        trouble_maker_timer = TroubleMakerTimer,
        trouble_maker_reflesh_times = TMRefleshTimes,
        trouble_maker_num = TroubleMakerNum,
        if_trouble_maker_collect = IfTMCollect
    } = State,
    util:cancel_timer(TroubleMakerTimer),
    case IfTMCollect of
        0 ->
            NewIfTMCollect = 1,
            lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 11, []),
            {ok, Bin2} = pt_172:write(17274, [1]),
            lib_server_send:send_to_scene(?WeddingScene, 0, RoleIdM, Bin2);
        _ ->
            NewIfTMCollect = IfTMCollect
    end,
    lib_marriage_wedding:creat_mon(1, RoleIdM),
    NewTMRefleshTimes = TMRefleshTimes + 1,
    case NewTMRefleshTimes >= ?WeddingTroubleMakerRefleshTimes of
        true ->
            NewTroubleMakerTimer = 0;
        false ->
            NewTroubleMakerTimer = erlang:send_after(?WeddingTroubleMakerTime*1000, self(), {trouble_maker_reflesh})
    end,
    {_MonId, MonNum} = lib_marriage_wedding:get_mon_id_num(1),
    NewTroubleMakerNum = TroubleMakerNum + MonNum,
    NewState = State#wedding_state{
        trouble_maker_timer = NewTroubleMakerTimer,
        trouble_maker_reflesh_times = NewTMRefleshTimes,
        trouble_maker_num = NewTroubleMakerNum,
        if_trouble_maker_collect = NewIfTMCollect
    },
    {noreply, NewState};

do_handle_info({wedding_exp}, State) ->
    #wedding_state{
        wedding_type = WeddingType,
        enter_member_list = EnterMemberList,
        exp_timer = ExpTimer
    } = State,
    util:cancel_timer(ExpTimer),
    WeddingConInfo = data_wedding:get_wedding_info_con(WeddingType),
    EnterNum = get_enter_member_num(EnterMemberList),
    #wedding_info_con{
        exp_time = ExpTime
    } = WeddingConInfo,
    F = fun(EnterMemberInfo) ->
        #wedding_enter_member_info{
            role_id = MemBerRoleId,
            if_enter = IfEnter
        } = EnterMemberInfo,
        case IfEnter of
            0 ->
                skip;
            _ ->
                lib_player:apply_cast(MemBerRoleId, ?APPLY_CALL_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, add_exp, [self(), WeddingType, EnterNum])
        end
    end,
    lists:map(F, EnterMemberList),
    NewExpTimer = erlang:send_after(ExpTime*1000, self(), {wedding_exp}),
    NewState = State#wedding_state{
        exp_timer = NewExpTimer
    },
    {noreply, NewState};

do_handle_info({sys_refresh_candies}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        less_normal_candies = LessNormalCandies,
        less_special_candies = _LessSpecialCandies,
        sys_candies_times = CandiesRefreshTimes,
        candies_timer = CandiesTimer
    } = State,
    util:cancel_timer(CandiesTimer),
    CandiesGap = ?SysCandyTimeGap,
    RefreshNum = ?SysCandyNumRefresh,
    CandiesLimit = ?SysCandyNumLimit,
    RefreshTimesLimit = ?SysCandyRefreshTimes,
    %% 普通喜糖
    case LessNormalCandies >= CandiesLimit orelse CandiesRefreshTimes >= RefreshTimesLimit of 
        false ->
            PosIdList = data_wedding:get_type_pos_id_list(2),
            MonId = ?WeddingNormalCandies,
            F = fun(_I) ->
                PosId = urand:list_rand(PosIdList),
                PosCon = data_wedding:get_wedding_position(PosId),
                case PosCon of
                    [] ->
                        MonX = 1000,
                        MonY = 1000;
                    _ ->
                        #wedding_position_con{
                            x = MonX,
                            y = MonY
                        } = PosCon
                end,
                lib_mon:async_create_mon(MonId, ?WeddingScene, 0, MonX, MonY, 0, RoleIdM, 1, [])
            end,
            lists:foreach(F, lists:seq(1, RefreshNum)),
            NewLessNormalCandies = LessNormalCandies + RefreshNum,
            NewCandiesRefreshTimes = CandiesRefreshTimes + 1,
            ?PRINT("sys_refresh_candies ========== ~n", []),
            lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 13, []);
        _ ->
            NewLessNormalCandies = LessNormalCandies,
            NewCandiesRefreshTimes = CandiesRefreshTimes
    end,
    NewCandiesTimer = erlang:send_after(CandiesGap*1000, self(), {sys_refresh_candies}),
    NewState = State#wedding_state{
        less_normal_candies = NewLessNormalCandies,
        sys_candies_times = NewCandiesRefreshTimes,
        candies_timer = NewCandiesTimer
    },
    {noreply, NewState};

do_handle_info({add_aura_time}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        figure_m = FigureM,
        role_id_w = RoleIdW,
        figure_w = FigureW,
        wedding_type = WeddingType,
        enter_member_list = EnterMemberList,
        aura = Aura,
        aura_timer = AuraTimer
    } = State,
    util:cancel_timer(AuraTimer),
    EnterNum = get_enter_member_num(EnterMemberList),
    AddAuraTime = ?WeddingAddAuraTime,
    [AddAuraNum, _] = data_wedding:get_wedding_aura_and_exp(WeddingType, EnterNum),
    % F = fun(EnterMemberInfo, AllAddAura1) ->
    %     #wedding_enter_member_info{
    %         if_enter = IfEnter
    %     } = EnterMemberInfo,
    %     case IfEnter of
    %         0 ->
    %             AllAddAura1;
    %         _ ->
    %             AllAddAura1 + AddAuraNum
    %     end
    % end,
    % AllAddAura = lists:foldl(F, 0, EnterMemberList),
    AllAddAura = AddAuraNum,
    NewAura = lib_marriage_wedding:add_aura(Aura, AllAddAura, RoleIdM, FigureM, RoleIdW, FigureW, EnterMemberList),
    NewAuraTimer = erlang:send_after(AddAuraTime*1000, self(), {add_aura_time}),
    NewState = State#wedding_state{
        aura = NewAura,
        aura_timer = NewAuraTimer
    },
    lib_marriage_wedding:push_wedding_info_aura(NewState),
    {noreply, NewState};

do_handle_info({wedding_end}, State) ->
    #wedding_state{
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        man_in = ManIn,
        woman_in = WomanIn,
        enter_member_list = EnterMemberList,
        stage_timer = StageTimer,
        trouble_maker_timer = TroubleMakerTimer,
        sql_timer = SqlTimer,
        exp_timer = ExpTimer,
        aura_timer = AuraTimer,
        stage_send_tv_timer = StageSendTVTimer,
        candies_timer = CandiesTimer
    } = State,
    util:cancel_timer(StageTimer),
    util:cancel_timer(TroubleMakerTimer),
    util:cancel_timer(SqlTimer),
    util:cancel_timer(ExpTimer),
    util:cancel_timer(AuraTimer),
    util:cancel_timer(StageSendTVTimer),
    util:cancel_timer(CandiesTimer),
    lib_scene:clear_scene_room(?WeddingScene, 0, RoleIdM),
    F = fun(EnterMemberInfo, NewEnterMemberList1) ->
        #wedding_enter_member_info{
            role_id = RoleId,
            if_enter = IfEnter
        } = EnterMemberInfo,
        case IfEnter of
            0 ->
                NewEnterMemberInfo = EnterMemberInfo;
            _ ->
                NewEnterMemberInfo = EnterMemberInfo#wedding_enter_member_info{
                    if_enter = 0
                },
                lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, wedding_end_quit, [])
        end,
        [NewEnterMemberInfo|NewEnterMemberList1]
    end,
    NewEnterMemberList = lists:foldl(F, [], EnterMemberList),
    NewState = State#wedding_state{
        enter_member_list = NewEnterMemberList
    },
    MemberIdList = [MemBerRoleId||#wedding_enter_member_info{role_id = MemBerRoleId} <- NewEnterMemberList],
    case ManIn =:= 1 andalso WomanIn =:= 1 of
        false ->
            EndType = 2;
        true ->
            EndType = 1
    end,
    DeleteRestartListStr = ulists:list_to_string([RoleIdM], ","),
    ReSql = io_lib:format(?DelectMWeddingRestartAllSql, [DeleteRestartListStr]),
    db:execute(ReSql),
    lib_log_api:log_marriage_wedding_end(RoleIdM, RoleIdW, ManIn, WomanIn, EndType, MemberIdList),
    mod_marriage_wedding_mgr:wedding_end(RoleIdM, RoleIdW),
    mod_marriage:wedding_end(RoleIdM),
    lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 12, []),
    do_handle_info({'stop'}, NewState);

do_handle_info({'stop'}, State)->
    gen_server:cast(self(), {'stop'}),
    {noreply, State};

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

get_enter_member_num(EnterMemberList) ->
    length([1 ||#wedding_enter_member_info{if_enter = 1} <- EnterMemberList]).