%%%--------------------------------------
%%% @Module  : pp_baby
%%% @Author  : lxl
%%% @Created : 2017.11.17
%%% @Description:  婚姻
%%%--------------------------------------

-module(pp_baby).

-export([handle/3]).
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("rec_baby.hrl").
-include("figure.hrl").

%% 宝宝当前形象使用信息
handle(Cmd = 18201, PS, []) ->
    #player_status{id = RoleId, sid = Sid, status_baby = StatusBaby} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            #status_baby{active_time = ActiveTime, baby_id = BabyId, baby_name = BabyName} = StatusBaby,
            IsChangename = ?IF(mod_counter:get_count(RoleId, ?MOD_MARRIAGE, 2) > 0, 1, 0),
            ?PRINT("18201 ##  : ~p~n", [{ActiveTime, BabyId, BabyName, IsChangename}]),
            lib_server_send:send_to_sid(Sid, pt_182, Cmd, [ActiveTime, BabyId, BabyName, IsChangename]);
        false ->
            lib_server_send:send_to_sid(Sid, pt_182, Cmd, [0, 0, "", 0])
    end;

%% 获取玩家宝宝基本信息
handle(_Cmd = 18202, PS, [RoleId]) ->
    lib_baby:send_role_baby_basic(PS, RoleId);

%% 获取宝宝养育信息
handle(Cmd = 18203, #player_status{sid = Sid} = PS, []) ->
    case lib_baby:is_baby_active(PS) of
        true ->
            lib_baby:send_baby_raise_info(PS);
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;

%% 获取宝宝阶数信息
handle(Cmd = 18204, #player_status{sid = Sid} = PS, []) ->
    case lib_baby:is_baby_active(PS) of
        true ->
            lib_baby:send_baby_stage_info(PS);
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;

%% 获取宝宝特长信息
handle(Cmd = 18205, #player_status{sid = Sid} = PS, []) ->
    case lib_baby:is_baby_active(PS) of
        true ->
            lib_baby:send_baby_equip_info(PS);
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;
%% 获取宝宝幻化信息
handle(Cmd = 18206, #player_status{sid = Sid} = PS, []) ->
    case lib_baby:is_baby_active(PS) of
        true ->
            lib_baby:send_baby_active_list_info(PS);
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;
%% 获取宝宝家庭信息
handle(Cmd = 18207, #player_status{sid = Sid} = PS, []) ->
    case lib_baby:is_baby_active(PS) of
        true ->
            lib_baby:send_baby_family_info(PS);
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;
%% 获取宝宝点赞榜单信息
handle(_Cmd = 18208, PS, []) ->
    lib_baby:send_baby_praise_rank(PS);
%% 获取我的点赞记录
handle(_Cmd = 18209, PS, []) ->
    lib_baby:send_baby_praise_record(PS);

%% 激活宝宝
handle(_Cmd = 18210, PS, []) ->
    lib_baby:active_baby(PS);

%% 宝宝升阶
handle(Cmd = 18211, PS, []) ->
    #player_status{id = RoleId, sid = Sid, status_baby = StatusBaby} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            #status_baby{raise_lv = RaiseLv} = StatusBaby,
            case RaiseLv >= ?stage_open_lv of 
                true ->
                    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
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
                    end||{GoodsTypeId, _AddExp} <- ?stage_exp_goods],
                    NewGoodsIdNumList = [{GoodsTypeId, Num}||{GoodsTypeId, Num} <- GoodsIdNumList, Num > 0],
                    case NewGoodsIdNumList == [] of 
                        false ->
                            case lib_baby:upgrade_baby_stage(PS, NewGoodsIdNumList) of
                                {ok, NewPS} ->
                                    #player_status{status_baby = NewStatusBaby} = NewPS,
                                    #status_baby{stage = NewStage, stage_lv = NewStageLv, stage_exp = NewStageExp, attr_list = AttrList} = NewStatusBaby,
%%                                    lib_hi_point_api:hi_point_task_baby_stage(RoleId, NewPS#player_status.figure#figure.lv),
                                    StagePower = lib_baby:count_baby_power([?ATTR_TYPE_STAGE], AttrList),
                                    lib_server_send:send_to_sid(Sid, pt_182, 18211, [?SUCCESS, NewStage, NewStageLv, NewStageExp, StagePower]),
                                    {ok, NewPS};
                                {false, Res} ->
                                    lib_server_send:send_to_sid(Sid, pt_182, 18211, [Res, 0, 0, 0, 0])
                            end;
                        _ ->
                            lib_server_send:send_to_sid(Sid, pt_182, 18211, [?GOODS_NOT_ENOUGH, 0, 0, 0, 0])
                    end;
                _ ->
                    send_errcode(Sid, Cmd, ?ERRCODE(err182_raise_lv_not_enough))
            end;
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;
    
%% 激活宝宝/宝宝升星
handle(18213, PS, [BabyId]) ->
    #player_status{id = _RoleId, sid = Sid, original_attr = SumOAttr} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            case lib_baby:active_figure(PS, BabyId) of 
                {ok, NewPS} ->
                    #player_status{status_baby = NewStatusBaby} = NewPS,
                    #status_baby{active_list = ActiveList, attr_list = _AttrList} = NewStatusBaby,
                    #baby_figure{baby_star = BabyStar} = lists:keyfind(BabyId, #baby_figure.baby_id, ActiveList),
                    %FigurePower = lib_baby:count_baby_power([?ATTR_TYPE_FIGURE], AttrList),
                    FigurePower = lib_baby:get_baby_figure_power(BabyId, BabyStar, NewPS),
                    case data_baby_new:get_baby_figure_star(BabyId, BabyStar + 1) of
                        #base_baby_figure_star{base_attr = NextBabyStarAttr} ->
                            NextStarCombat = lib_player:calc_expact_power(SumOAttr, 0, NextBabyStarAttr);
                        _ ->
                            NextStarCombat = 0
                    end,
                    lib_server_send:send_to_sid(Sid, pt_182, 18213, [?SUCCESS, BabyId, BabyStar, FigurePower, NextStarCombat]),
                    {ok, SupVipPS} = lib_supreme_vip_api:baby_active_figure(NewPS, BabyId),
                    {ok, SupVipPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18213, [Res, BabyId, 0, 0, 0])
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_182, 18213, [?ERRCODE(err182_not_active), BabyId, 0, 0, 0])
    end;
%% 使用/取消形象
handle(18214, PS, [Type, BabyId]) ->
    #player_status{id = _RoleId, sid = Sid} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            case Type == 1 of 
                true ->
                    Return = lib_baby:use_figure(PS, BabyId);
                _ ->
                    Return = lib_baby:unuse_figure(PS, BabyId)
            end,
            case Return of 
                {ok, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18214, [?SUCCESS, Type, BabyId]),
                    {ok, NewPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18214, [Res, Type, BabyId])
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_182, 18214, [?ERRCODE(err182_not_active), Type, BabyId])
    end;
%% 改名
handle(18215, PS, [BabyName]) ->
    #player_status{id = _RoleId, sid = Sid} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            CheckLength = util:check_length_without_code(BabyName, 6),
            CheckKeyWord = lib_word:check_keyword_name(BabyName),
            if
                CheckLength == false -> Return = {false, ?ERRCODE(not_enough_length)};
                CheckKeyWord == true -> Return = {false, ?ERRCODE(err145_2_word_is_sensitive)};
                true ->
                    Return = lib_baby:change_baby_name(PS, BabyName)
            end,
            case Return of 
                {ok, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18215, [?SUCCESS, BabyName]),
                    {ok, NewPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18215, [Res, BabyName])
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_182, 18215, [?ERRCODE(err182_not_active), BabyName])
    end;
%% 展示宝宝
% handle(Cmd = 18216, PS, []) ->
%     #player_status{id = _RoleId, sid = Sid} = PS,
%     case lib_baby:is_baby_active(PS) of
%         true ->
%             lib_baby:display_baby(PS);
%         false ->
%             send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
%     end;
%% 点赞宝宝
% handle(18217, PS, [RoleId, Opr]) ->
% 	#player_status{sid = Sid} = PS,
%     case lib_baby:praise_player_baby(PS, RoleId, Opr) of 
%         {ok, NewPS, RewardList} ->
%             lib_server_send:send_to_sid(Sid, pt_182, 18217, [?SUCCESS, RoleId, Opr, RewardList]),
%             {ok, NewPS};
%         {false, Res} ->
%             lib_server_send:send_to_sid(Sid, pt_182, 18217, [Res, RoleId, Opr, []])
%     end;

%% 穿戴装备
handle(Cmd = 18218, PS, [PosId, GoodsId]) ->
    #player_status{id = _RoleId, sid = Sid} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            case lib_baby:equip(PS, PosId, GoodsId) of 
                {ok, NewPS} ->
                    #player_status{status_baby = NewStatusBaby} = NewPS,
                    #status_baby{equip_list = EquipList, attr_list = _AttrList} = NewStatusBaby,
                    #baby_equip{goods_id = GoodsTypeId, skill_id = SkillId} = lists:keyfind(PosId, #baby_equip.pos_id, EquipList),
                    EquipPower = lib_baby:count_equip_power(NewPS, NewStatusBaby),
                    lib_server_send:send_to_sid(Sid, pt_182, 18218, [?SUCCESS, PosId, GoodsId, GoodsTypeId, SkillId, EquipPower]),
                    {ok, NewPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18218, [Res, PosId, GoodsId, 0, 0, 0])
            end;
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;

%% 升阶装备
handle(Cmd = 18219, PS, [PosId]) ->
    #player_status{id = _RoleId, sid = Sid} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            case lib_baby:upgrade_equip_stage(PS, PosId) of 
                {ok, NewPS} ->
                    #player_status{status_baby = NewStatusBaby} = NewPS,
                    #status_baby{equip_list = EquipList, attr_list = _AttrList} = NewStatusBaby,
                    #baby_equip{
                    	id = GoodsId, goods_id = GoodsTypeId, stage = Stage, stage_lv = StageLv, stage_exp = StageExp
                    } = lists:keyfind(PosId, #baby_equip.pos_id, EquipList),
                    %Power = lib_baby:count_baby_power([?ATTR_TYPE_RAISE, ?ATTR_TYPE_STAGE, ?ATTR_TYPE_EQUIP, ?ATTR_TYPE_FIGURE], AttrList),
                    EquipPower = lib_baby:count_equip_power(NewPS, NewStatusBaby),
                    lib_server_send:send_to_sid(Sid, pt_182, 18219, [?SUCCESS, PosId, GoodsId, GoodsTypeId, Stage, StageLv, StageExp, EquipPower]),
                    {ok, NewPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18219, [Res, PosId, 0, 0, 0, 0, 0, 0])
            end;
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;

%% 装备铭刻
handle(Cmd = 18220, PS, [PosId, GoodsList]) ->
    #player_status{id = _RoleId, sid = Sid} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            case lib_baby:engrave_baby_equip(PS, PosId, GoodsList) of 
                {ok, NewPS} ->
                    #player_status{status_baby = NewStatusBaby} = NewPS,
                    #status_baby{equip_list = EquipList} = NewStatusBaby,
                    #baby_equip{
                    	id = GoodsId, goods_id = GoodsTypeId, skill_id = SkillId
                    } = lists:keyfind(PosId, #baby_equip.pos_id, EquipList),
                    EquipPower = lib_baby:count_equip_power(NewPS, NewStatusBaby),
                    lib_server_send:send_to_sid(Sid, pt_182, 18220, [?SUCCESS, PosId, GoodsId, GoodsTypeId, SkillId, EquipPower]),
                    {ok, NewPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18220, [Res, PosId, 0, 0, 0, 0])
            end;
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;

%% 领取任务奖励
handle(Cmd = 18222, PS, [TaskId]) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            case mod_baby_mgr:call({get_baby_task_reward, RoleId, TaskId}) of 
                {ok} ->
                    #base_baby_raise{raise_exp = AddRaiseExp} = data_baby_new:base_baby_raise(TaskId),
                    {ok, NewPS} = lib_baby:add_raise_exp(PS, AddRaiseExp, [TaskId]),
%%                    lib_hi_point_api:hi_point_task_baby_lv(NewPS),
                    {ok, NewPS};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_182, 18222, [Res, TaskId, 0, 0])
            end;
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;

%% 查看具体宝宝形象信息
handle(Cmd = 18223, PS, [BabyId]) ->
    #player_status{id = _RoleId, sid = Sid, original_attr = SumOAttr} = PS,
    case lib_baby:is_baby_active(PS) of
        true ->
            #player_status{status_baby = #status_baby{active_list = ActiveList}} = PS,
            case lists:keyfind(BabyId, #baby_figure.baby_id, ActiveList) of 
                #baby_figure{baby_star = BabyStar} ->
                    FigurePower = lib_baby:get_baby_figure_power(BabyId, BabyStar, PS),
                    case data_baby_new:get_baby_figure_star(BabyId, BabyStar + 1) of
                        #base_baby_figure_star{base_attr = NextBabyStarAttr} ->
                            NextStarCombat = lib_player:calc_expact_power(SumOAttr, 0, NextBabyStarAttr);
                        _ ->
                            NextStarCombat = 0
                    end,
                    lib_server_send:send_to_sid(Sid, pt_182, 18223, [BabyId, BabyStar, FigurePower, NextStarCombat]);
                _ -> %% 未激活，战力预览
                    case data_baby_new:get_baby_figure_star(BabyId, 1) of 
                        #base_baby_figure_star{base_attr = BabyStarAttr} -> ok;
                        _ -> BabyStarAttr = []
                    end,
                    FigurePower = lib_player:calc_expact_power(PS#player_status.original_attr, 0, BabyStarAttr),
                    lib_server_send:send_to_sid(Sid, pt_182, 18223, [BabyId, 1, FigurePower, 0])
            end;
        false ->
            send_errcode(Sid, Cmd, ?ERRCODE(err182_not_active))
    end;

handle(_Code, _Ps, _) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

send_errcode(Sid, Cmd, ErrCode) ->
    {CodeInt, CodeArgs} = util:parse_error_code(ErrCode),
    lib_server_send:send_to_sid(Sid, pt_182, 18200, [Cmd, CodeInt, CodeArgs]).