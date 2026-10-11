%%-----------------------------------------------------------------------------
%% @Module  :       pp_pet
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-10-12
%% @Description:
%%-----------------------------------------------------------------------------
-module(pp_pet).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("pet.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("sql_goods.hrl").

handle(Cmd, Player, Data) ->
    #player_status{figure = Figure} = Player,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 1),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, Player, Data);
        false -> skip
    end.

%% 宠物信息
do_handle(Cmd = 16502, Player, _Data) ->
    #player_status{sid = Sid, status_pet = StatusPet} = Player,
    #status_pet{
        stage = Stage, star = Star, lv = Lv, exp = Exp, blessing = Blessing,
        illusion_type = IllusionType, illusion_id = IllusionId,
        attr = Attr, skills = Skills, combat = Combat, display_status = DisplayStatus
    } = StatusPet,
    FigureStage = ?IF(IllusionType == ?BASE_PET_FIGURE, IllusionId, 0),
    Args = [Stage, Star, Lv, Blessing, Exp, FigureStage, Combat, DisplayStatus, Attr, Skills],
    {ok, BinData} = pt_165:write(Cmd, Args),
    lib_server_send:send_to_sid(Sid, BinData);

%% 幻化宠物
do_handle(Cmd = 16503, Player, [Type, Args])
    when is_integer(Args) andalso Type >= 1 andalso Type =< 2 ->
    #player_status{sid = Sid, id = RoleId, status_pet = StatusPet} = Player,
    #status_pet{illusion_type = IllusionType, illusion_id = IllusionId} = StatusPet,
    if
        IllusionType == Type andalso IllusionId == Args -> NewPlayer = Player;
        Type =/= ?BASE_PET_FIGURE andalso Type =/= ?ILLUSION_PET_FIGURE ->
            NewPlayer = Player;
        true ->
            case lib_pet:illusion_figure(Type, RoleId, StatusPet, Args) of
                {ok, NewStatusPet} ->
                    NewPlayer = Player#player_status{status_pet = NewStatusPet},
                    %% 通知场景玩家
                    lib_pet:broadcast_to_scene(NewPlayer),
                    {ok, BinData} = pt_165:write(Cmd, [?SUCCESS, Type, Args]),
                    lib_server_send:send_to_sid(Sid, BinData);
                {fail, ErrorCode} ->
                    {ok, BinData} = pt_165:write(16500, [ErrorCode]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    NewPlayer = Player
            end
    end,
    {ok, NewPlayer};

%% 隐藏/显示宠物
%% Type: 0: 隐藏 1: 显示宠物
do_handle(16504, Player, [Type]) ->
    lib_pet:change_display_status(Player, Type);

%% 一键升星
do_handle(16505, Player, [Type]) when Type == 1 orelse Type == 2 ->
    lib_pet:upgrade_star(Player, Type);

%% 升级
do_handle(16506, Player, [SpecifyGoods]) ->
    lib_pet:upgrade_lv(Player, SpecifyGoods);

%% 幻形界面信息
do_handle(Cmd = 16507, Player, _Data) ->
    #player_status{sid = Sid, status_pet = StatusPet} = Player,
    #status_pet{
        illusion_type = IllusionType,
        illusion_id = IllusionId,
        figure_list = FigureList
    } = StatusPet,
    SelFigureId = ?IF(IllusionType == ?BASE_PET_FIGURE, 0, IllusionId),
    List = [{Id, Stage} || #pet_figure{id = Id, stage = Stage} <- FigureList],
    {ok, BinData} = pt_165:write(Cmd, [?SUCCESS, SelFigureId, List]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 幻形形象详细信息
do_handle(Cmd = 16508, Player, [Id]) ->
    #player_status{sid = Sid, status_pet = StatusPet} = Player,
    #status_pet{figure_list = FigureList} = StatusPet,
    case lists:keyfind(Id, #pet_figure.id, FigureList) of
        #pet_figure{stage = Stage, blessing = Blessing, attr = Attr, combat = Combat} ->
            Ids = data_pet:get_skill_by_type(?PET_ILLUSION_SKILL, Id),
            UnlockList = lists:filter(fun(TmpId) ->
                case data_pet:get_skill_cfg(TmpId) of
                    #pet_skill_cfg{stage = NeedStage} when Stage >= NeedStage -> true;
                    _ -> false
                end
            end, Ids),
            {ok, BinData} = pt_165:write(Cmd, [?SUCCESS, Id, Stage, Blessing, Combat, Attr, UnlockList]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip %% 未激活不处理
    end;

%% 激活形象
do_handle(_Cmd = 16509, Player, [Id]) ->
    lib_pet:active_figure(Player, Id);

%% 幻形升星
do_handle(_Cmd = 16510, Player, [Id, Type]) when Type >= 1 andalso Type =< 3 ->
    lib_pet:figure_upgrade_stage(Player, Id, Type);

%% 使用灵丹
do_handle(Cmd = 16511, Player, [GTypeId]) ->
    case lib_pet:use_goods(Player, GTypeId) of
        {ok, ErrorCode, NewPlayer} -> skip;
        {fail, ErrorCode, NewPlayer} -> skip
    end,
    {ok, BinData} = pt_165:write(Cmd, [ErrorCode, GTypeId]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, battle_attr, NewPlayer};

%% 灵丹使用次数
do_handle(Cmd = 16512, Player, _) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    GTypeIds = data_pet:get_goods_ids(),
    CounterList = mod_counter:get_count(RoleId, ?MOD_GOODS, GTypeIds),
    F = fun(GTypeId) ->
        case lists:keyfind(GTypeId, 1, CounterList) of
            {GTypeId, Times} -> skip;
            _ -> Times = 0
        end,
        case data_pet:get_goods_cfg(GTypeId) of
            #pet_goods_cfg{max_times = MaxTimesL} ->
                MaxTimes = lib_pet:get_goods_max_times(MaxTimesL, RoleLv);
            _ ->
                MaxTimes = 0
        end,
        {GTypeId, Times, MaxTimes}
    end,
    TimesL = lists:map(F, GTypeIds),
    {ok, BinData} = pt_165:write(Cmd, [TimesL]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 打开精灵飞行器
do_handle(16520, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 2),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            ShowId = 0,
            IfShow = 0,
            SendList = [];
        true ->
            Code = ?SUCCESS,
            #status_pet{
                pet_aircraft = PetAircraft
            } = StatusPet,
            #pet_aircraft{
                aircraft_list = AircraftList,
                show_id = ShowId,
                if_show = IfShow
            } = PetAircraft,
            SendList = [begin
                #aircraft_info{
                    aircraft_id = AircraftId,
                    stage = Stage
                } = AircraftInfo,
                {AircraftId, Stage}
            end||AircraftInfo <- AircraftList]
    end,
    {ok, BinData} = pt_165:write(16520, [Code, ShowId, IfShow, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData);

%% 精灵飞行器激活/升阶
do_handle(16521, Ps, [AircraftId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        name = Name,
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 2),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        true ->
            #status_pet{
                pet_aircraft = PetAircraft
            } = StatusPet,
            #pet_aircraft{
                aircraft_list = AircraftList
            } = PetAircraft,
            case lists:keyfind(AircraftId, #aircraft_info.aircraft_id, AircraftList) of
                false ->
                    case data_pet_aircraft:get_pet_aircraft_info_con(AircraftId) of
                        [] ->
                            Code = ?MISSING_CONFIG,
                            NewPs = Ps;
                        AircraftInfoCon ->
                            #pet_aircraft_info_con{
                                aircraft_name = AircraftName,
                                active_cost = CostList,
                                active_condition = ConditionList
                            } = AircraftInfoCon,
                            case ConditionList of
                                [] ->
                                    IfPass = true;
                                _ ->
                                    F = fun({AircraftId1, NeedStage}) ->
                                        case lists:keyfind(AircraftId1, #aircraft_info.aircraft_id, AircraftList) of
                                            false ->
                                                false;
                                            AircraftInfo1 ->
                                                #aircraft_info{
                                                    stage = Stage1
                                                } = AircraftInfo1,
                                                Stage1 >= NeedStage
                                        end
                                    end,
                                    IfPass = lists:all(F, ConditionList)
                            end,
                            case IfPass of
                                false ->
                                    Code = ?ERRCODE(err165_pet_aircraft_not_pass),
                                    NewPs = Ps;
                                true ->
                                    case lib_goods_api:cost_object_list_with_check(Ps, CostList, aircraft_active, "") of
                                        {true, NewPs1} ->
                                            Code = ?SUCCESS,
                                            NewAircraftInfo = #aircraft_info{
                                                aircraft_id = AircraftId,
                                                stage = 1
                                            },
                                            NewPs = lib_pet:update_aircraft_ps(NewAircraftInfo, NewPs1),
                                            lib_pet:broadcast_to_scene(NewPs),
                                            #pet_aircraft_stage_con{
                                                if_send_tv = IfSendTV
                                            } = data_pet_aircraft:get_pet_aircraft_stage_con(AircraftId, 1),
                                            case IfSendTV of
                                                0 ->
                                                    skip;
                                                _ ->
                                                    lib_chat:send_TV({all}, ?MOD_PET, 4, [Name, AircraftName])
                                            end,
                                            SCostList = util:term_to_string(CostList),
                                            lib_log_api:log_pet_aircraft_stage(RoleId, AircraftId, 0, 1, SCostList);
                                        {false, Code, NewPs} ->
                                            skip
                                    end
                            end
                    end;
                AircraftInfo ->
                    #aircraft_info{
                        stage = Stage
                    } = AircraftInfo,
                    case data_pet_aircraft:get_pet_aircraft_stage_con(AircraftId, Stage+1) of
                        [] ->
                            Code = ?ERRCODE(err165_figure_max_stage),
                            NewPs = Ps;
                        AircraftStageCon ->
                            #pet_aircraft_stage_con{
                                cost_list = CostList,
                                if_send_tv = IfSendTV
                            } = AircraftStageCon,
                            case lib_goods_api:cost_object_list_with_check(Ps, CostList, aircraft_stage, "") of
                                {true, NewPs1} ->
                                    Code = ?SUCCESS,
                                    NewAircraftInfo = AircraftInfo#aircraft_info{
                                        aircraft_id = AircraftId,
                                        stage = Stage + 1
                                    },
                                    NewPs = lib_pet:update_aircraft_ps(NewAircraftInfo, NewPs1),
                                    #pet_aircraft_info_con{
                                        aircraft_name = AircraftName
                                    } = data_pet_aircraft:get_pet_aircraft_info_con(AircraftId),
                                    case IfSendTV of
                                        0 ->
                                            skip;
                                        _ ->
                                            lib_chat:send_TV({all}, ?MOD_PET, 3, [Name, AircraftName, Stage+1])
                                    end,
                                    SCostList = util:term_to_string(CostList),
                                    lib_log_api:log_pet_aircraft_stage(RoleId, AircraftId, Stage, Stage+1, SCostList);
                                {false, Code, NewPs} ->
                                    skip
                            end
                    end
            end
    end,
    {ok, BinData} = pt_165:write(16521, [Code, AircraftId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 使用精灵飞行器
do_handle(16522, Ps, [AircraftId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 2),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        true ->
            #status_pet{
                pet_aircraft = PetAircraft
            } = StatusPet,
            #pet_aircraft{
                aircraft_list = AircraftList,
                show_id = ShowId,
                if_show = IfShow
            } = PetAircraft,
            case lists:keyfind(AircraftId, #aircraft_info.aircraft_id, AircraftList) of
                false ->
                    Code = ?ERRCODE(err165_pet_aircraft_not_active),
                    NewPs = Ps;
                _AircraftInfo ->
                    case ShowId of
                        AircraftId ->
                            Code = ?ERRCODE(err165_pet_aircraft_play),
                            NewPs = Ps;
                        _ ->
                            Code = ?SUCCESS,
                            PerfromId = lib_pet:get_aircraft_perform_id(AircraftId, IfShow),
                            NewPetAircraft = PetAircraft#pet_aircraft{
                                show_id = AircraftId,
                                perform_id = PerfromId
                            },
                            NewStatusPet = StatusPet#status_pet{
                                pet_aircraft = NewPetAircraft
                            },
                            NewPs = Ps#player_status{
                                status_pet = NewStatusPet
                            },
                            lib_pet:broadcast_to_scene(NewPs)
                    end
            end
    end,
    {ok, BinData} = pt_165:write(16522, [Code, AircraftId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 显示/隐藏精灵飞行器
do_handle(16523, Ps, []) ->
    #player_status{
        id = RoleId,
        status_pet = StatusPet
    } = Ps,
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 2),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        true ->
            Code = ?SUCCESS,
            #status_pet{
                pet_aircraft = PetAircraft
            } = StatusPet,
            #pet_aircraft{
                show_id = AircraftId,
                if_show = IfShow
            } = PetAircraft,
            case IfShow of
                0 ->
                    NewIfShow = 1;
                _ ->
                    NewIfShow = 0
            end,
            PerfromId = lib_pet:get_aircraft_perform_id(AircraftId, NewIfShow),
            NewPetAircraft = PetAircraft#pet_aircraft{
                if_show = NewIfShow,
                perform_id = PerfromId
            },
            NewStatusPet = StatusPet#status_pet{
                pet_aircraft = NewPetAircraft
            },
            NewPs = Ps#player_status{
                status_pet = NewStatusPet
            },
            lib_pet:broadcast_to_scene(NewPs)
    end,
    {ok, BinData} = pt_165:write(16523, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 打开精灵翅膀
do_handle(16530, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 3),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            ShowId = 0,
            IfShow = 0,
            SendList = [];
        true ->
            Code = ?SUCCESS,
            #status_pet{
                pet_wing = PetWing
            } = StatusPet,
            #pet_wing{
                wing_list = WingList,
                show_id = ShowId,
                if_show = IfShow
            } = PetWing,
            SendList =[begin
                #wing_info{
                    wing_id = WingId,
                    stage = Stage,
                    end_time = EndTime
                } = WingInfo,
                {WingId, Stage, EndTime}
            end||WingInfo <- WingList]
    end,
    {ok, BinData} = pt_165:write(16530, [Code, ShowId, IfShow, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData);

%% 精灵翅膀激活/升阶/延时
do_handle(16531, Ps, [WingId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        name = Name,
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 3),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewEndTime = 0,
            NewPs = Ps;
        true ->
            #status_pet{
                pet_wing = PetWing
            } = StatusPet,
            #pet_wing{
                wing_list = WingList
            } = PetWing,
            StartTime = utime:unixtime(),
            case lists:keyfind(WingId, #wing_info.wing_id, WingList) of
                false ->
                    case data_pet_wing:get_pet_wing_info_con(WingId) of
                        [] ->
                            Code = ?MISSING_CONFIG,
                            NewEndTime = 0,
                            NewPs = Ps;
                        WingInfoCon ->
                            #pet_wing_info_con{
                                wing_name = WingName,
                                active_cost = CostList,
                                active_condition = ConditionList,
                                time_limit = TimeLimit
                            } = WingInfoCon,
                            case ConditionList of
                                [] ->
                                    IfPass = true;
                                _ ->
                                    F = fun({WingId1, NeedStage}) ->
                                        case lists:keyfind(WingId1, #wing_info.wing_id, WingList) of
                                            false ->
                                                false;
                                            WingInfo1 ->
                                                #wing_info{
                                                    stage = Stage1
                                                } = WingInfo1,
                                                Stage1 >= NeedStage
                                        end
                                    end,
                                    IfPass = lists:all(F, ConditionList)
                            end,
                            case IfPass of
                                false ->
                                    Code = ?ERRCODE(err165_pet_wing_not_pass),
                                    NewEndTime = 0,
                                    NewPs = Ps;
                                true ->
                                    case lib_goods_api:cost_object_list_with_check(Ps, CostList, pet_wing_active, "") of
                                        {true, NewPs1} ->
                                            Code = ?SUCCESS,
                                            case TimeLimit of
                                                0 ->
                                                    NewEndTime = 0;
                                                _ ->
                                                    NewEndTime = StartTime + TimeLimit
                                            end,
                                            NewWingInfo = #wing_info{
                                                wing_id = WingId,
                                                stage = 1,
                                                end_time = NewEndTime
                                            },
                                            NewPs = lib_pet:update_wing_ps(NewWingInfo, NewPs1),
                                            lib_pet:broadcast_to_scene(NewPs),
                                            #pet_wing_stage_con{
                                                if_send_tv = IfSendTV
                                            } = data_pet_wing:get_pet_wing_stage_con(WingId, 1),
                                            case IfSendTV of
                                                0 ->
                                                    skip;
                                                _ ->
                                                    lib_chat:send_TV({all}, ?MOD_PET, 4, [Name, WingName])
                                            end,
                                            SCostList = util:term_to_string(CostList),
                                            lib_log_api:log_pet_wing_stage(RoleId, WingId, 0, 1, SCostList);
                                        {false, Code, NewPs} ->
                                            NewEndTime = 0
                                    end
                            end
                    end;
                WingInfo ->
                    #wing_info{
                        stage = Stage,
                        end_time = EndTime
                    } = WingInfo,
                    #pet_wing_info_con{
                        active_cost = ActiveCost,
                        wing_name = WingName,
                        time_limit = TimeLimit
                    } = data_pet_wing:get_pet_wing_info_con(WingId),
                    case TimeLimit of
                        0 ->
                            case data_pet_wing:get_pet_wing_stage_con(WingId, Stage+1) of
                                [] ->
                                    Code = ?ERRCODE(err165_figure_max_stage),
                                    NewEndTime = 0,
                                    NewPs = Ps;
                                WingStageCon ->
                                    #pet_wing_stage_con{
                                        cost_list = CostList,
                                        if_send_tv = IfSendTV
                                    } = WingStageCon,
                                    case lib_goods_api:cost_object_list_with_check(Ps, CostList, pet_wing_stage, "") of
                                        {true, NewPs1} ->
                                            Code = ?SUCCESS,
                                            NewEndTime = EndTime,
                                            NewWingInfo = WingInfo#wing_info{
                                                wing_id = WingId,
                                                stage = Stage + 1
                                            },
                                            NewPs = lib_pet:update_wing_ps(NewWingInfo, NewPs1),
                                            case IfSendTV of
                                                0 ->
                                                    skip;
                                                _ ->
                                                    lib_chat:send_TV({all}, ?MOD_PET, 3, [Name, WingName, Stage+1])
                                            end,
                                            SCostList = util:term_to_string(CostList),
                                            lib_log_api:log_pet_wing_stage(RoleId, WingId, Stage, Stage+1, SCostList);
                                        {false, Code, NewPs} ->
                                            NewEndTime = 0
                                    end
                            end;
                        _ ->
                            case lib_goods_api:cost_object_list_with_check(Ps, ActiveCost, pet_wing_add_time, "") of
                                {true, NewPs1} ->
                                    Code = ?SUCCESS,
                                    NewEndTime = EndTime + TimeLimit,
                                    NewWingInfo = WingInfo#wing_info{
                                        wing_id = WingId,
                                        end_time =  NewEndTime
                                    },
                                    NewPs = lib_pet:update_wing_ps(NewWingInfo, NewPs1),
                                    SCostList = util:term_to_string(ActiveCost),
                                    lib_log_api:log_pet_wing_add_time(RoleId, WingId, EndTime, NewEndTime, SCostList);
                                {false, Code, NewPs} ->
                                    NewEndTime = 0
                            end
                    end
            end
    end,
    {ok, BinData} = pt_165:write(16531, [Code, WingId, NewEndTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 使用精灵翅膀
do_handle(16532, Ps, [WingId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 3),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        true ->
            #status_pet{
                pet_wing = PetWing
            } = StatusPet,
            #pet_wing{
                wing_list = WingList,
                show_id = ShowId,
                if_show = IfShow
            } = PetWing,
            case lists:keyfind(WingId, #wing_info.wing_id, WingList) of
                false ->
                    Code = ?ERRCODE(err165_pet_wing_not_active),
                    NewPs = Ps;
                _WingInfo ->
                    case ShowId of
                        WingId ->
                            Code = ?ERRCODE(err165_pet_wing_play),
                            NewPs = Ps;
                        _ ->
                            Code = ?SUCCESS,
                            PerfromId = lib_pet:get_wing_perform_id(WingId, IfShow),
                            NewPetWing = PetWing#pet_wing{
                                show_id = WingId,
                                perform_id = PerfromId
                            },
                            NewStatusPet = StatusPet#status_pet{
                                pet_wing = NewPetWing
                            },
                            NewPs = Ps#player_status{
                                status_pet = NewStatusPet
                            },
                            lib_pet:broadcast_to_scene(NewPs),
                            lib_common_rank_api:refresh_rank_by_pet_wing(NewPs)
                    end
            end
    end,
    {ok, BinData} = pt_165:write(16532, [Code, WingId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 显示/隐藏精灵翅膀
do_handle(16533, Ps, []) ->
    #player_status{
        id = RoleId,
        status_pet = StatusPet
    } = Ps,
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = StatusPet
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 3),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        true ->
            Code = ?SUCCESS,
            #status_pet{
                pet_wing = PetWing
            } = StatusPet,
            #pet_wing{
                show_id = WingId,
                if_show = IfShow
            } = PetWing,
            case IfShow of
                0 ->
                    NewIfShow = 1;
                _ ->
                    NewIfShow = 0
            end,
            PerfromId = lib_pet:get_wing_perform_id(WingId, NewIfShow),
            NewPetWing = PetWing#pet_wing{
                if_show = NewIfShow,
                perform_id = PerfromId
            },
            NewStatusPet = StatusPet#status_pet{
                pet_wing = NewPetWing
            },
            NewPs = Ps#player_status{
                status_pet = NewStatusPet
            },
            lib_pet:broadcast_to_scene(NewPs)
    end,
    {ok, BinData} = pt_165:write(16533, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 打开精灵装备
do_handle(16540, Ps, []) ->
    #player_status{
        id = RoleId,
        status_pet = StatusPet,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 4),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            CombatPower = 0,
            SendList = [];
        true ->
            Code = ?SUCCESS,
            GoodsStatus = lib_goods_do:get_goods_status(),
            #goods_status{
                pet_equip_pos_list = PetEquipPosList
            } = GoodsStatus,
            #status_pet{
                pet_equip = PetEquip
            } = StatusPet,
            #pet_equip{
                pet_equip_attr = PetEquipAttrList
            } = PetEquip,
            GS = lib_goods_do:get_goods_status(),
            #goods_status{
                dict = Dict
            } = GS,
            PetEquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_PET_EQUIP, Dict),
            PetEquipAttr = lib_player_attr:to_attr_record(PetEquipAttrList),
            CombatPower = lib_player:calc_all_power(PetEquipAttr),
            PosList = data_pet_equip:get_pet_equip_pos_list(),
            F = fun(Pos, SendList1) ->
                case lists:keyfind(Pos, #goods.cell, PetEquipWearList) of
                    false ->
                        SendList1;
                    GoodsInfo ->
                        #goods{
                            id = GoodsId,
                            goods_id = GoodsTypeId,
                            other = #goods_other{
                                optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, _PEStar]
                            }
                        } = GoodsInfo,
                        case lists:keyfind(Pos, #pet_equip_pos.pos, PetEquipPosList) of
                            false ->
                                PosLv = 0,
                                PosPoint = 0;
                            #pet_equip_pos{pet_equip_point = AllPosPoint} ->
                                {PosLv, PosPoint, _IfMax} = lib_pet:get_pet_equip_pos_lv(AllPosPoint, Pos, PEStage)
                        end,
                        [{Pos, PosLv, PosPoint, GoodsId, GoodsTypeId}|SendList1]
                end
            end,
            SendList = lists:foldl(F, [], PosList)
    end,
    {ok, BinData} = pt_165:write(16540, [Code, CombatPower, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData);

%% 精灵装备镶嵌
do_handle(16541, Ps, [Pos, GoodsId]) ->
    #player_status{
        id = RoleId,
        status_pet = StatusPet,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 4),
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        dict = Dict
    } = GS,
    PetEquipBagList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_BAG, Dict),
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, PetEquipBagList),
    PosList = data_pet_equip:get_pet_equip_pos_list(),
    IfPos = lists:member(Pos, PosList),
    if
        Lv < OpenLv ->
            Code = ?LEVEL_LIMIT,
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo =:= false ->
            Code =?ERRCODE(err165_pet_equip_not),
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        IfPos =:= false ->
            Code = ?ERRCODE(err165_pet_equip_not_pos),   %% 没有该部位
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        true ->
            #goods{
                goods_id = GoodsTypeId,
                subtype = SubType,
                location = OriginalLocation,
                cell = OriginalCell
            } = GoodsInfo,
            PEGoodsTypeIdList = data_pet_equip:get_pet_equip_goods_list(),
            IfPetEquip = lists:member(GoodsTypeId, PEGoodsTypeIdList),
            if
                IfPetEquip =:= false ->
                    Code = ?ERRCODE(err165_pet_equip_not),
                    NewGoodsId = 0,
                    OldGoodsId = 0,
                    NewGoodsTypeId = 0,
                    NewPs = Ps;
                SubType =/= Pos ->
                    Code = ?ERRCODE(err165_pet_equip_not_right_pos),
                    NewGoodsId = 0,
                    OldGoodsId = 0,
                    NewGoodsTypeId = 0,
                    NewPs = Ps;
                true ->
                    case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
                        [] ->
                            Code = ?MISSING_CONFIG,
                            NewGoodsId = 0,
                            OldGoodsId = 0,
                            NewGoodsTypeId = 0,
                            NewPs = Ps;
                        PetEquipGoodsCon ->
                            #status_pet{
                                stage = PetStage
                            } = StatusPet,
                            #pet_equip_goods_con{
                                player_lv_limit = PlayerLvLimit,
                                pet_stage_limit = PetStagelimit
                            } = PetEquipGoodsCon,
                            case Lv >= PlayerLvLimit andalso PetStage >= PetStagelimit of
                                false ->
                                    Code = ?ERRCODE(err165_pet_equip_not_already_wear),
                                    NewGoodsId = 0,
                                    OldGoodsId = 0,
                                    NewGoodsTypeId = 0,
                                    NewPs = Ps;
                                true ->
                                    F = fun() ->
                                        ok = lib_goods_dict:start_dict(),
                                        OldGoodsInfo = lib_goods_util:get_goods_by_cell(RoleId, ?GOODS_LOC_PET_EQUIP, Pos, Dict),
                                        case is_record(OldGoodsInfo, goods) of
                                            true ->
                                                [NewOldGoodsInfo, GS1] = lib_goods:change_goods_cell_and_use(OldGoodsInfo, OriginalLocation, OriginalCell, GS),
                                                [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_PET_EQUIP, Pos, GS1),
                                                OldGoodsId = NewOldGoodsInfo#goods.id;
                                            false ->
                                                OldGoodsId = 0,
                                                [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_PET_EQUIP, Pos, GS)
                                        end,
                                        #goods_status{
                                            dict = OldGoodsDict
                                        } = NewGS1,
                                        {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                        NewGS = NewGS1#goods_status{
                                            dict = NewGoodsDict
                                        },
                                        {NewGS, NewGoodsInfo, OldGoodsId, GoodsL}
                                        end,
                                    case lib_goods_util:transaction(F) of
                                        {NewGS, NewGoodsInfo, OldGoodsId, GoodsL} ->
                                            Code = ?SUCCESS,
                                            #goods{
                                                id = NewGoodsId,
                                                goods_id = NewGoodsTypeId
                                            } = NewGoodsInfo,
                                            lib_goods_do:set_goods_status(NewGS),
                                            NewPs1 = lib_pet:get_pet_equip(Ps, NewGS),
                                            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
                                            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
                                            %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                            lib_goods_api:notify_client_num(NewGS#goods_status.player_id, [GoodsInfo#goods{num=0}]);
                                        Error ->
                                            ?ERR("pet_equip error:~p", [Error]),
                                            Code = ?FAIL,
                                            NewGoodsId = 0,
                                            OldGoodsId = 0,
                                            NewGoodsTypeId = 0,
                                            NewPs = Ps
                                    end
                            end
                    end
            end
    end,
    {ok, BinData} = pt_165:write(16541, [Code, Pos, NewGoodsId, OldGoodsId, NewGoodsTypeId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 精灵装备强化
do_handle(16542, Ps, [GoodsId, CostList]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 4),
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        dict = Dict,
        pet_equip_pos_list = PetEquipPosList
    } = GS,
    PetEquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_PET_EQUIP, Dict),
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, PetEquipWearList),
    if
        Lv < OpenLv ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        GoodsInfo =:= false ->
            Code =?ERRCODE(err165_pet_equip_not),
            NewPs = Ps;
        true ->
            #goods{
                goods_id = GoodsTypeId,
                cell = Pos,
                other = #goods_other{
                    optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, _PEStar]
                }
            } = GoodsInfo,
            case lists:keyfind(Pos, #pet_equip_pos.pos, PetEquipPosList) of
                false ->
                    AllPoint = 0;
                #pet_equip_pos{pet_equip_point = AllPoint} ->
                    skip
            end,
            {OldPosLv, _PosPoint, IfMax} = lib_pet:get_pet_equip_pos_lv(AllPoint, Pos, PEStage),
            #pet_equip_stage_con{
                limit_pos_lv = LimitPosLv
            } = data_pet_equip:get_pet_equip_stage_con(Pos, PEStage),
            NowLimitPoint = lib_pet:get_now_point(0, LimitPosLv, Pos, 0),
            case IfMax of
                0 ->
                    PetEquipBagList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_BAG, Dict),
                    PEGoodsTypeIdList = data_pet_equip:get_pet_equip_goods_list(),
                    {CostGoodsList, AddPoint} = lib_pet:get_pos_lv_upgrade_cost_list(CostList, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, [], 0),
                    case CostGoodsList of
                        [] ->
                            Code = ?ERRCODE(err165_pet_equip_not_right_cost),
                            NewPs = Ps;
                        _ ->
                            GS = lib_goods_do:get_goods_status(),
                            F = fun() ->
                                ok = lib_goods_dict:start_dict(),
                                {ok, NewGS1} = lib_goods:delete_goods_list(GS, CostGoodsList),
                                #goods_status{
                                    dict = OldGoodsDict
                                } = NewGS1,
                                {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                NewAllPoint = AllPoint + AddPoint,
                                NewPetEquipPosInfo = #pet_equip_pos{
                                    pos = Pos,
                                    pet_equip_point = NewAllPoint
                                },
                                ReSql = io_lib:format(?sql_pet_equip_pos_replace, [RoleId, Pos, NewAllPoint]),
                                db:execute(ReSql),
                                NewPetEquipPosList = lists:keystore(Pos, #pet_equip_pos.pos, PetEquipPosList, NewPetEquipPosInfo),
                                NewGS = NewGS1#goods_status{
                                    dict = NewGoodsDict,
                                    pet_equip_pos_list = NewPetEquipPosList
                                },
                                {ok, NewGS, GoodsL, NewAllPoint}
                            end,
                            case lib_goods_util:transaction(F) of
                                {ok, NewGS, GoodsL, NewAllPoint} ->
                                    Code = ?SUCCESS,
                                    lib_goods_do:set_goods_status(NewGS),
                                    NewPs2 = lib_pet:get_pet_equip(Ps, NewGS),
                                    {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs2),
                                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                    lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
                                    {NewPosLv, _NewPosPoint, _NewIfMax} = lib_pet:get_pet_equip_pos_lv(NewAllPoint, Pos, PEStage),
                                    CostLogList = [begin
                                        #goods{
                                            type = GoodsTypeLog,
                                            goods_id = GoodsTypeIdLog
                                        } = GoodsInfoLog,
                                        {GoodsTypeLog, GoodsTypeIdLog, GoodsNumLog}
                                    end||{GoodsInfoLog, GoodsNumLog} <- CostGoodsList],
                                    SCostLogList = util:term_to_string(CostLogList),
                                    lib_log_api:log_pet_equip_pos_upgrade(RoleId, Pos, GoodsTypeId, OldPosLv, AllPoint, NewPosLv, NewAllPoint, SCostLogList);
                                Error ->
                                    ?ERR("pet_equip error:~p", [Error]),
                                    Code = ?FAIL,
                                    NewPs = Ps
                            end
                    end;
                _ ->
                    Code = ?ERRCODE(err165_pet_equip_lv_max),
                    NewPs = Ps
            end
    end,
    {ok, BinData} = pt_165:write(16542, [Code, GoodsId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 精灵装备打磨
do_handle(16543, Ps, [GoodsId, CostGoodsId]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 4),
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        dict = Dict,
        pet_equip_pos_list = PetEquipPosList
    } = GS,
    PetEquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_PET_EQUIP, Dict),
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, PetEquipWearList),
    PetEquipBagList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_BAG, Dict),
    CostGoodsInfo = lists:keyfind(CostGoodsId, #goods.id, PetEquipBagList),
    if
        Lv < OpenLv ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        GoodsInfo =:= false ->
            Code = ?ERRCODE(err165_pet_equip_not),
            NewPs = Ps;
        CostGoodsInfo =:= false ->
            Code = ?ERRCODE(err165_pet_equip_cost_not),
            NewPs = Ps;
        true ->
            #goods{
                goods_id = GoodsTypeId,
                cell = Pos,
                other = GoodsOther
            } = GoodsInfo,
            #goods_other{
                optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, PEStar]
            } = GoodsOther,
            #goods{
                goods_id = CostGoodsTypeId,
                other = CostOther,
                num = CostGoodsNum
            } = CostGoodsInfo,
            case lists:keyfind(Pos, #pet_equip_pos.pos, PetEquipPosList) of
                false ->
                    AllPoint = 0;
                #pet_equip_pos{pet_equip_point = AllPoint} ->
                    skip
            end,
            {OldPosLv, _PosPoint, _IfMax} = lib_pet:get_pet_equip_pos_lv(AllPoint, Pos, PEStage),
            PEGoodsTypeIdList = data_pet_equip:get_pet_equip_goods_list(),
            case lists:member(CostGoodsTypeId, PEGoodsTypeIdList) of
                false -> %% 升阶 升星
                    #pet_equip_stage_con{
                        cost_list = [{_GoodsType, StageGoodsTypeId, _GoodsNum}|_]
                    } = data_pet_equip:get_pet_equip_stage_con(Pos, 1),
                    case CostGoodsTypeId of
                        StageGoodsTypeId ->
                            Code1 = 1;
                        _ ->
                            #pet_equip_star_con{
                                cost_list = [{_GoodsType, StarGoodsTypeId, _GoodsNum}|_]
                            } = data_pet_equip:get_pet_equip_star_con(Pos, 1),
                            case CostGoodsTypeId of
                                StarGoodsTypeId ->
                                    Code1 = 2;
                                _ ->
                                    Code1 = 0
                            end
                    end,
                    PEStageConList = data_pet_equip:get_pet_equip_stage_list(Pos),
                    PEStageMax = lists:max(PEStageConList),
                    PEStarConList = data_pet_equip:get_pet_equip_star_list(Pos),
                    PEStarMax = lists:max(PEStarConList),
                    if
                        Code1 =:= 0 ->
                            Code = ?MISSING_CONFIG,
                            NewPs = Ps;
                        PEStage >= PEStageMax andalso Code1 =:= 1 ->
                            Code = ?ERRCODE(err165_pet_equip_stage_max),
                            NewPs = Ps;
                        PEStar >= PEStarMax andalso Code1 =:= 2 ->
                            Code = ?ERRCODE(err165_pet_equip_star_max),
                            NewPs = Ps;
                        true ->
                            case Code1 of
                                1 ->
                                    CostNum = lib_pet:get_cost_num_stage_star(PEStage, PEStageMax, Pos, CostGoodsNum, 1, 0);
                                _ ->
                                    CostNum = lib_pet:get_cost_num_stage_star(PEStar, PEStarMax, Pos, CostGoodsNum, 2, 0)
                            end,
                            F1 = fun() ->
                                ok = lib_goods_dict:start_dict(),
                                {ok, NewGS1, _NewNum} = lib_goods:delete_one(GS, CostGoodsInfo, CostNum),
                                case Code1 of
                                    1 ->
                                        NewPEStage = PEStage + CostNum,
                                        NewPEStar = PEStar;
                                    _ ->
                                        NewPEStage = PEStage,
                                        NewPEStar = PEStar + CostNum
                                end,
                                #pet_equip_stage_con{
                                    color = NewColor
                                } = data_pet_equip:get_pet_equip_stage_con(Pos, NewPEStage),
                                NewRating = lib_pet:cal_equip_rating(Pos, [?GOODS_OTHER_KEY_PET_EQUIP, NewPEStage, NewPEStar]),
                                NewGoodsInfo = GoodsInfo#goods{
                                    color = NewColor,
                                    other = GoodsOther#goods_other{
                                        rating = NewRating,
                                        optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, NewPEStage, NewPEStar]
                                    }
                                },
                                ReSqlC = io_lib:format(?SQL_GOODS_UPDATE_GOODS2, [GoodsTypeId, NewColor, GoodsId]),
                                db:execute(ReSqlC),
                                lib_pet:change_goods_other(NewGoodsInfo),
                                Dict1 = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, NewGS1#goods_status.dict),
                                {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(Dict1),
                                NewGS = NewGS1#goods_status{
                                    dict = NewGoodsDict
                                },
                                {ok, NewGS, GoodsL, NewPEStage, NewPEStar}
                            end,
                            case lib_goods_util:transaction(F1) of
                                {ok, NewGS, GoodsL, NewPEStage, NewPEStar} ->
                                    Code = ?SUCCESS,
                                    lib_goods_do:set_goods_status(NewGS),
                                    NewPs1 = lib_pet:get_pet_equip(Ps, NewGS),
                                    {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
                                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                    lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
%%                                    lib_goods_api:notify_client_num(RoleId, [CostGoodsInfo#goods{num = max(0, (CostGoodsNum-CostNum))}]),
                                    {NewPosLv, _NewPosPoint, _NewIfMax} = lib_pet:get_pet_equip_pos_lv(AllPoint, Pos, NewPEStage),
                                    lib_log_api:log_pet_equip_goods_upgrade(RoleId, Pos, GoodsTypeId, CostGoodsTypeId, PEStage, PEStar, OldPosLv, AllPoint, NewPEStage, NewPEStar, NewPosLv, AllPoint);
                                Error ->
                                    ?ERR("pet_equip error:~p", [Error]),
                                    Code = ?FAIL,
                                    NewPs = Ps
                            end
                    end;
                true -> %% 吞噬
                    #goods_other{
                        optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, CostPEStage, CostPEStar]
                    } = CostOther,
                    F2 = fun() ->
                        {ok, NewGS1, _NewNum} = lib_goods:delete_one(GS, CostGoodsInfo, CostGoodsInfo#goods.num),
                        case PEStage >= CostPEStage of
                            true ->
                                NewPEStage = PEStage,
                                AddPEStage = CostPEStage;
                            false ->
                                NewPEStage = CostPEStage,
                                AddPEStage = PEStage
                        end,
                        case PEStar >= CostPEStar of
                            true ->
                                NewPEStar = PEStar,
                                AddPEStar = CostPEStar;
                            false ->
                                NewPEStar = CostPEStar,
                                AddPEStar = PEStar
                        end,
                        #pet_equip_stage_con{
                            exp = AddExpStage
                        } = data_pet_equip:get_pet_equip_stage_con(Pos, AddPEStage),
                        #pet_equip_star_con{
                            exp = AddExpStar
                        } = data_pet_equip:get_pet_equip_star_con(Pos, AddPEStar),
                        AddPoint = AddExpStage + AddExpStar,
                        #pet_equip_stage_con{
                            color = NewColor
                        } = data_pet_equip:get_pet_equip_stage_con(Pos, NewPEStage),
                        ReSqlC = io_lib:format(?SQL_GOODS_UPDATE_GOODS2, [GoodsTypeId, NewColor, GoodsId]),
                        db:execute(ReSqlC),
                        NewRating = lib_pet:cal_equip_rating(Pos, [?GOODS_OTHER_KEY_PET_EQUIP, NewPEStage, NewPEStar]),
                        NewGoodsInfo = GoodsInfo#goods{
                            color = NewColor,
                            other = GoodsOther#goods_other{
                                rating = NewRating,
                                optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, NewPEStage, NewPEStar]
                            }
                        },
                        lib_pet:change_goods_other(NewGoodsInfo),
                        Dict1 = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, NewGS1#goods_status.dict),
                        {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(Dict1),
                        NewAllPoint = AllPoint + AddPoint,
                        NewPetEquipPosInfo = #pet_equip_pos{
                            pos = Pos,
                            pet_equip_point = NewAllPoint
                        },
                        ReSql = io_lib:format(?sql_pet_equip_pos_replace, [RoleId, Pos, NewAllPoint]),
                        db:execute(ReSql),
                        NewPetEquipPosList = lists:keystore(Pos, #pet_equip_pos.pos, PetEquipPosList, NewPetEquipPosInfo),
                        NewGS = NewGS1#goods_status{
                            dict = NewGoodsDict,
                            pet_equip_pos_list = NewPetEquipPosList
                        },
                        {ok, NewGS, GoodsL, NewPEStage, NewPEStar, NewAllPoint}
                    end,
                    case lib_goods_util:transaction(F2) of
                        {ok, NewGS, GoodsL, NewPEStage, NewPEStar, NewAllPoint} ->
                            Code = ?SUCCESS,
                            lib_goods_do:set_goods_status(NewGS),
                            NewPs2 = lib_pet:get_pet_equip(Ps, NewGS),
                            NewPs3 = lib_pet:get_pet_equip(NewPs2, NewGS),
                            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs3),
                            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
                            lib_goods_api:notify_client_num(RoleId, [CostGoodsInfo#goods{num = 0}]),
                            {NewPosLv, _NewPosPoint, _NewIfMax} = lib_pet:get_pet_equip_pos_lv(NewAllPoint, Pos, NewPEStage),
                            lib_log_api:log_pet_equip_goods_upgrade(RoleId, Pos, GoodsTypeId, CostGoodsTypeId, PEStage, PEStar, OldPosLv, AllPoint, NewPEStage, NewPEStar, NewPosLv, NewAllPoint);
                        Error ->
                            ?ERR("pet_equip error:~p", [Error]),
                            Code = ?FAIL,
                            NewPs = Ps
                    end
            end
    end,
    {ok, BinData} = pt_165:write(16543, [Code, GoodsId, CostGoodsId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

do_handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.