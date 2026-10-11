%%-----------------------------------------------------------------------------
%% @Module  :       lib_transfer
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-04-12
%% @Description:    转职
%%-----------------------------------------------------------------------------
-module(lib_transfer).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("skill.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("designation.hrl").
-include("def_module.hrl").
-include("equip_suit.hrl").
-include("team.hrl").
-include("career.hrl").

-define(TRANSFER_COST,      data_transfer:get_transfer_kv(1)).        %% 转职消耗
-define(TRANSFER_CD,        data_transfer:get_transfer_kv(2)).                      %% 转职CD
-define(TRANSFER_NEED_LV,   data_transfer:get_transfer_kv(3)).                       %% 转职需要等级

-export([
    login/1
    , send_transfer_info/1
    , transfer/3
    ]).

login(RoleId) ->
    case db:get_row(io_lib:format(<<"select last_time from player_transfer where role_id = ~p">>, [RoleId])) of
        [LastTransferTime] ->
            LastTransferTime;
        _ -> 0
    end.

send_transfer_info(Player) ->
    #player_status{sid = Sid, last_transfer_time = LastTransferTime} = Player,
    {ok, BinData} = pt_130:write(13046, [LastTransferTime + ?TRANSFER_CD]),
    lib_server_send:send_to_sid(Sid, BinData).

check_transfer(Player, NewCareer, NewSex) ->
    #player_status{figure = Figure, team = #status_team{team_id = TeamId}, last_transfer_time = LastTransferTime} = Player,
    #figure{lv = Lv, career = Career, sex = Sex, marriage_type = _MarriageType} = Figure,
    AllCareerL = data_career:get_all_career(),
    case Lv >= ?TRANSFER_NEED_LV of
        true ->
            case lists:member({NewCareer, NewSex}, AllCareerL) of
                true ->
                    case NewCareer =/= Career orelse NewSex =/= Sex of
                        true ->
                            NowTime = utime:unixtime(),
                            case NowTime - LastTransferTime >= ?TRANSFER_CD of
                                true ->
                                    case TeamId == 0 of 
                                        true ->
                                            case lib_scene:is_transferable(Player) of 
                                                {true, _} -> ok;
                                                _ ->
                                                    {false, ?ERRCODE(err130_cannot_recareer_inactivity)}
                                            end;
                                        _ ->
                                            {false, ?ERRCODE(err130_cannot_recareer_inteam)}
                                    end;
                                false ->
                                    {false, ?ERRCODE(err130_transfer_cd_limit)}
                            end;
                        false ->
                            {false, ?ERRCODE(err130_transfer_career_same_limit)}
                    end;
                false ->
                    {false, ?ERRCODE(err130_transfer_career_err)}
            end;
        false ->
            {false, {?ERRCODE(err130_transfer_lv_limit), [?TRANSFER_NEED_LV]}}
    end.

transfer(Player, NewCareer, NewSex) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{career = OldCareer, sex = OldSex, name = Name} = Figure,
    case check_transfer(Player, NewCareer, NewSex) of
        ok ->
            [{_, GoodsTypeId, _}|_] = ?TRANSFER_COST,
            case lib_goods_api:cost_object_list_with_check(Player, ?TRANSFER_COST, transfer, "") of
                {true, NewPlayer} ->
                    GoodsStatus = lib_goods_do:get_goods_status(),
                    NowTime = utime:unixtime(),
                    F = fun() ->
                        {TmpLastPlayer, TmpNewGoodsStatus, UpdateGoodsL, OldEquips, NewEquips, TmpReplaceDsgtL} 
                            = do_transfer(NewPlayer, GoodsStatus, NewCareer, NewSex, NowTime),
                        {ok, TmpLastPlayer, TmpNewGoodsStatus, UpdateGoodsL, OldEquips, NewEquips, TmpReplaceDsgtL}
                    end,
                    case catch lib_goods_util:transaction(F) of
                        {ok, LastPlayer, NewGoodsStatus, UpdateGoodsList, OldLogEquips, NewLogEquips, ReplaceDsgtL} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            %% 日志
                            lib_log_api:log_transfer(RoleId, OldCareer, OldSex, NewCareer, NewSex, OldLogEquips, NewLogEquips),
                            lib_goods_api:notify_client_num(NewGoodsStatus#goods_status.player_id, UpdateGoodsList),
                            %% 发送称号替换邮件
                            ReplaceDsgtL =/= [] andalso spawn(fun() -> send_dsgt_replace_mail(ReplaceDsgtL, RoleId) end),
                            %% 通知客户端更新身上装备的信息
                            EquipList = lib_goods_util:get_equip_list(RoleId, NewGoodsStatus#goods_status.dict),
                            lib_goods_api:update_client_goods_info(EquipList),
                            {ok, LastPlayer1} = lib_goods_util:count_role_equip_attribute(LastPlayer),
                            LastPlayer2 = do_af_transfer(LastPlayer1, Player),
                            %% 传闻
                            #career{career_name = CareerName} = data_career:get(NewCareer, NewSex),
                            lib_chat:send_TV({all}, ?MOD_PLAYER, 3, [util:make_sure_binary(Name), GoodsTypeId, util:make_sure_binary(CareerName)]),
                            ?PRINT("transfer ok ############# ~n", []),
                            {ok, LastPlayer2};
                        Err ->
                            ?ERR("transfer err:~p", [Err]),
                            {false, ?ERRCODE(system_busy)}
                    end;
                {false, ErrorCode, NewPlayer} ->
                    {false, ErrorCode, NewPlayer}
            end;
        {false, ErrorCode} ->
            {false, ErrorCode}
    end.

%% 处理转职逻辑
%% 注:转职之后玩家进程需要严谨同步的数据都放到事务里面来操作
do_transfer(Player, GoodsStatus, NewCareer, NewSex, NowTime) ->
    #player_status{figure = #figure{career = OldCareer, sex = OldSex}} = Player,
    {ok, PlayerAfCareer} = handle_transfer_change_career(Player, NewCareer, NewSex, NowTime),
    {ok, NewPlayer} = handle_transfer_change_skill(PlayerAfCareer, OldCareer, OldSex, NowTime),
    {NewGoodsStatus, UpdateGoodsList, OldEquips, NewEquips} = handle_transfer_change_equip(NewPlayer, GoodsStatus, NewCareer, NewSex),
    {ok, ReplaceDsgtL, LastPlayer} = handle_transfer_change_dsgt(NewPlayer, OldCareer, OldSex, NewCareer, NewSex),
    {LastPlayer, NewGoodsStatus, UpdateGoodsList, OldEquips, NewEquips, ReplaceDsgtL}.

%% 更新职业信息
handle_transfer_change_career(Player, NewCareer, NewSex, NowTime) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{career = _OldCareer} = Figure,
    %% 更新最后转职时间
    db:execute(io_lib:format(<<"replace into player_transfer(role_id, last_time) values(~p, ~p)">>, [RoleId, NowTime])),
    %% 更改玩家的职业和性别
    db:execute(io_lib:format(<<"update player_low set career = ~p, sex = ~p where id = ~p">>, [NewCareer, NewSex, RoleId])),
    %% 先删除所有头像
    % db:execute(io_lib:format(<<"delete from player_picture where id = ~p">>, [RoleId])),
    % PictureIds = data_picture:get_picture_ids(),
    %% 有自定义头像则不进行替代
    % IsUploadPic = not lists:member(OldPicture, PictureIds) andalso OldPictureId == RoleId,
    % LastPicture = ?IF(IsUploadPic, OldPicture, NewPicture),
    NewPlayer = Player#player_status{
        figure = Figure#figure{career = NewCareer, sex = NewSex},
        last_transfer_time = NowTime
    },
    {ok, NewPlayer}.

%% 处理转职后的技能更新逻辑
handle_transfer_change_skill(Player, OldCareer, OldSex, NowTime) ->
    #player_status{
        id = RoleId, figure = Figure, skill = SkillStatus, quickbar = QuickBar
    } = Player,
    #figure{career = NewCareer, sex = NewSex, turn = Turn} = Figure,
    OldSkillCfgL = lib_skill_api:get_career_skill_ids(OldCareer, OldSex),
    OldSkillIds = [TSkillId || {TSkillId, _MaxLv} <- OldSkillCfgL],
    %% 删除玩家的旧技能
    db:execute(io_lib:format(<<"delete from skill where id = ~p and skill_id in (~s)">>, [RoleId, util:link_list(OldSkillIds)])),
    NewSkillL = [{TmpSkillId, TmpSkillLv} || {TmpSkillId, TmpSkillLv} <- SkillStatus#status_skill.skill_list, lists:member(TmpSkillId, OldSkillIds) == false],
    %% 把快捷栏的旧技能移除
    NewQuickBar = [{TmpQLocal, TmpQType, TmpNQSId, TmpQSAutoTag} || {TmpQLocal, TmpQType, TmpNQSId, TmpQSAutoTag} <- QuickBar, TmpQType =/= ?QUICKBAR_TYPE_SKILL],
    %% 计算当前转生需要替换的技能
    F = fun(TmpTurn, {TmpReSkillL, TmpUpSkillL}) ->
        {   
            data_reincarnation:get_reincarnation_reskill(NewCareer, NewSex, TmpTurn) ++ TmpReSkillL,
            lib_reincarnation:get_turn_skill_list(NewCareer, NewSex, TmpTurn) ++ TmpUpSkillL
        }
    end,
    {ReSkillL, UpSkillL} = lists:foldl(F, {[], []}, lists:seq(1, Turn)),
    %% 重新学习技能
    TmpNewPlayer = Player#player_status{
        figure = Figure#figure{career = NewCareer, sex = NewSex},
        quickbar = NewQuickBar,
        skill = SkillStatus#status_skill{skill_list = NewSkillL, skill_cd = []},
        last_transfer_time = NowTime
    },
    {ok, NewPlayer} = lib_skill:auto_learn_skill(TmpNewPlayer, {transfer, lists:reverse(ReSkillL)}),
    %% 更新技能等级
    F2 = fun({SkillId, SkillLv}, TmpPlayer) ->
        #player_status{skill = #status_skill{skill_list = SkillL}} = TmpPlayer,
        % 小于本等级才触发自动升级
        case lists:keyfind(SkillId, 1, SkillL) of
            {SkillId, NowSkillLv} when NowSkillLv >= SkillLv -> TmpPlayer;
            _ ->
                lib_skill:replace_skill_level(TmpPlayer, SkillId, SkillLv)
        end
    end,
    NewPlayer2 = lists:foldl(F2, NewPlayer, UpSkillL),
    %% 远古奥术 -- 没有了，屏蔽
%%    NewPlayer3 = lib_arcana:change_arcana_with_transfer(NewPlayer2, OldCareer),
    %% 重新计算快捷栏
    QuickbarPS = lib_skill:recalc_quickbar(NewPlayer2),
    %% 重置天赋技能
%%    LastPlayer = QuickbarPS, %lib_skill:reset_talent_skill(QuickbarPS),
	
	Player3 = lib_skill:transfer_talent_skill(QuickbarPS),
    %% 副本技能变更
    LastPlayer = lib_skill:transfer_dungeon_skill(Player3),
    {ok, LastPlayer}.

%% 处理转职后的装备更新逻辑
handle_transfer_change_equip(Player, GoodsStatus, NewCareer, NewSex) ->
    #player_status{id = RoleId} = Player,
    ok = lib_goods_dict:start_dict(),
    EquipList = lib_goods_util:get_equip_list(RoleId, GoodsStatus#goods_status.dict),
    F = fun(EquipInfo, {NewGoodsStatusTmp, OldList, NewList}) ->
        case EquipInfo of
            #goods{id = GoodsId, goods_id = GTypeId, equip_type = EquipType, color = Color, other = GoodsOther} ->
                case data_equip:get_equip_attr_cfg(GTypeId) of
                    #equip_attr_cfg{stage = Stage, star = Star, class_type = ClassType} ->
                        case data_goods_type:get(GTypeId) of
                            #ets_goods_type{career = OldCareerLim, sex = OldSexLim} ->
                                %% 如果之前穿的装备是不限职业限性别的装备，则换成对应不限职业新性别的装备
                                %% 如果之前穿的装备是限职业不限性别的装备，则换成对应新职业不限性别的装备
                                %% 如果之前穿的装备是限职业限性别的装备，则换成对应新职业新性别的装备
                                %% 如果之前穿的装备是不限职业不限性别的装备，则不需要更换装备
%%	                            ?MYLOG("equip", "GTypeId ~p~n", [GTypeId]),
%%                                ?IF(ClassType == 1, ?MYLOG("equip", "GTypeId ~p~n", [GTypeId]), skip),
                                NewCareerLim = ?IF(OldCareerLim == 0, 0, NewCareer),
                                NewSexLim = ?IF(OldSexLim == 0, 0, NewSex),
                                case NewCareerLim =/= 0 orelse NewSexLim =/= 0 of
                                    true ->
                                        EquipGTypeIds = data_equip_other:get_equip_by_stage_and_star(Stage, Star),
%%	                                    ?IF(ClassType == 1, ?MYLOG("equip", "EquipGTypeIds ~p~n", [EquipGTypeIds]), skip),
                                        case count_new_equip_id(EquipGTypeIds, NewCareerLim, NewSexLim, Color, EquipType, ClassType) of
                                            NewGTypeId when NewGTypeId > 0 ->
%%                                                ?IF(ClassType == 1, ?MYLOG("equip", "NewGTypeId ~p~n", [NewGTypeId]), skip),
                                                #ets_goods_type{level = NewLv, addition = NewAddition} = NewGoodsTypeInfo = data_goods_type:get(NewGTypeId),
                                                {NewPriceType, NewPrice} = data_goods:get_goods_buy_price(NewGTypeId),
                                                Sql = io_lib:format(<<"update goods set price_type = ~p, price = ~p where id = ~p">>,
                                                    [NewPriceType, NewPrice, GoodsId]),
                                                db:execute(Sql),
                                                Sql1 = io_lib:format(<<"update goods_low set gtype_id = ~p, level = ~p, addition = '~s' where gid = ~p">>,
                                                    [NewGTypeId, NewLv, util:term_to_string(NewAddition), GoodsId]),
                                                db:execute(Sql1),
                                                Sql2 = io_lib:format(<<"update goods_high set goods_id = ~p where gid = ~p">>,
                                                    [NewGTypeId, GoodsId]),
                                                db:execute(Sql2),
                                                NewGoodsOther = GoodsOther#goods_other{
                                                    addition= NewAddition,
                                                    rating = lib_equip_api:cal_equip_rating(NewGoodsTypeInfo, GoodsOther#goods_other.extra_attr)
                                                },
                                                NewEquipInfo = EquipInfo#goods{
                                                    goods_id = NewGTypeId,
                                                    price_type = NewPriceType,
                                                    price = NewPrice,
                                                    level = NewLv,
                                                    other = NewGoodsOther
                                                },
                                                NewGoodsStatus = lib_goods:change_goods(NewEquipInfo, ?GOODS_LOC_EQUIP, NewGoodsStatusTmp),
                                                {NewGoodsStatus, [GTypeId|OldList], [NewGTypeId|NewList]};
                                            _ -> {NewGoodsStatusTmp, OldList, NewList}
                                        end;
                                    _ -> {NewGoodsStatusTmp, OldList, NewList}
                                end;
                            _ -> {NewGoodsStatusTmp, OldList, NewList}
                        end;
                    _ -> {NewGoodsStatusTmp, OldList, NewList}
                end;
            _ -> {NewGoodsStatusTmp, OldList, NewList}
        end
    end,
    {NewGoodsStatus, OldEquips, NewEquips} = lists:foldl(F, {GoodsStatus, [], []}, EquipList),
    #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    LastGoodsStatus = NewGoodsStatus#goods_status{dict = GoodsDict},
    {LastGoodsStatus, GoodsL, OldEquips, NewEquips}.

count_new_equip_id([], _, _, _, _, _) -> 0;
count_new_equip_id([Id|L], Career, Sex, Color, EquipType, ClassType) ->
    case data_goods_type:get(Id) of
        #ets_goods_type{career = Career, sex = Sex, color = Color, equip_type = EquipType} ->
	        case data_equip:get_equip_attr_cfg(Id) of
				#equip_attr_cfg{class_type = ClassType} ->
					Id;
				_ ->
					count_new_equip_id(L, Career, Sex, Color, EquipType, ClassType)
	        end;
        _ -> count_new_equip_id(L, Career, Sex, Color, EquipType, ClassType)
    end.

%% 处理转职后的称号更新逻辑
%% 目前只处理和性别变化有关的称号
handle_transfer_change_dsgt(Player, OldCareer, OldSex, NewCareer, NewSex) ->
    #player_status{dsgt_status = DsgtStatus} = Player,
    {List, _ExpireList} = lib_designation:get_player_dsgt(DsgtStatus),
    ReplaceL = count_dsgt_replace_list(OldCareer, OldSex, NewCareer, NewSex),
    case ReplaceL =/= [] of
        true ->
            F = fun({DsgtId, _, EndTime}, {TmpPlayer, Acc}) ->
                    case lists:keyfind(DsgtId, 1, ReplaceL) of
                        {DsgtId, NewDsgtId} ->
                            %% 如果要删掉的称号是全局唯一称号不处理
                            case data_designation:get_by_id(DsgtId) of
                                #base_designation{
                                    is_global = IsGlobal
                                } when IsGlobal == 0 ->
                                    {ok, NewTmpPlayer} = lib_designation:remove_dsgt(TmpPlayer, DsgtId),
                                    % {ok, NewTmpPlayer1} = lib_designation:active_dsgt(NewTmpPlayer, #active_para{id = NewDsgtId, expire_time = EndTime}),
                                    case lib_designation:active_dsgt(NewTmpPlayer, #active_para{id = NewDsgtId, expire_time = EndTime}) of
                                        {true, NewTmpPlayer1} ->
                                            skip;
                                        {_, NewTmpPlayer1, _} ->
                                            skip;
                                        _ ->
                                            NewTmpPlayer1 = NewTmpPlayer
                                    end,
                                    {NewTmpPlayer1, [{DsgtId, NewDsgtId}|Acc]};
                                _ -> {TmpPlayer, Acc}
                            end;
                        _ -> {TmpPlayer, Acc}
                    end
                end,
            {NewPlayer, RealReplaceL} = lists:foldl(F, {Player, []}, List);
        _ -> NewPlayer = Player, RealReplaceL = []
    end,
    {ok, RealReplaceL, NewPlayer}.

%% 目前没有称号要转换
count_dsgt_replace_list(_OldCareer, OldSex, _NewCareer, NewSex) ->
    if
        OldSex == ?MALE andalso NewSex == ?FEMALE ->
            [];
        OldSex == ?FEMALE andalso NewSex == ?MALE ->
            [];
        true -> []
    end.

%% 处理转职后的其他逻辑
%% 涉及到影响战力的，功能内部计算自己的属性战力即可，后面会统一调用一次计算玩家战力接口
do_af_transfer(Player, OldPlayer) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{career = Career, sex = Sex, turn = Turn, lv = Lv} = Figure,
    %% 更新角色Model
    NewLvModel = lib_player:get_model_list(Career, Sex, Turn, Lv),
    %% 时装
    NewFashionModelList = lib_fashion:get_equip_fashion_list_ps(Player),
    NewFigure = Figure#figure{lv_model = NewLvModel, fashion_model = NewFashionModelList},
    PlayerAfFashion = Player#player_status{figure = NewFigure},
    %% 坐骑
    PlayerAfMount = lib_mount:refresh_mount_figure_list(PlayerAfFashion),
    %% 天启套装形象
    PlayerAfRevelation = lib_revelation_equip:refresh_revelation_figure(PlayerAfMount),
    %% 派发转职成功事件
    {ok, PlayerAfEvent} = lib_player_event:dispatch(PlayerAfRevelation, ?EVENT_TRANSFER),

    #player_status{figure = LastFigure} = PlayerAfEvent,
    %% 其他模块的更新操作写在事件监听里面或者这下面
    %% 更新场景玩家的数据
    mod_scene_agent:update(PlayerAfEvent, [{figure, LastFigure}]),
    {ok, BinData} = pt_120:write(12078, [RoleId, LastFigure]),
    %% 先推送一条12078协议保证客户端先收到78协议，处理逻辑，
    %% 主要是为了配合客户端不然场景推送12078协议有可能和 13045 协议保证不了顺序
    lib_server_send:send_to_uid(RoleId, BinData),
    lib_scene:broadcast_player_figure(PlayerAfEvent),
    %% 更新离线玩家缓存
    lib_offline_api:update_offline_ps(RoleId, [{figure, LastFigure}]),
    %% 更新交友大厅
    lib_marriage:change_ps_personals(PlayerAfEvent),
    %% 套装石
    LastPlayer = trans_suit_consume_record(PlayerAfEvent, OldPlayer),
    %% 
    LastPlayer.

send_dsgt_replace_mail(List, RoleId) ->
    timer:sleep(300),
    do_send_dsgt_replace_mail(List, 1, RoleId).

do_send_dsgt_replace_mail([], _, _) -> skip;
do_send_dsgt_replace_mail([{OldDsgtId, NewDsgtId}|L], Acc, RoleId) ->
    case Acc rem 10 of
        0 ->
            timer:sleep(300);
        _ -> skip
    end,
    Title = utext:get(1300006),
    OldDsgtName = lib_designation_api:get_dsgt_name(OldDsgtId),
    NewDsgtName = lib_designation_api:get_dsgt_name(NewDsgtId),
    Content = utext:get(1300007, [OldDsgtName, NewDsgtName]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
    do_send_dsgt_replace_mail(L, Acc + 1, RoleId).

trans_suit_consume_record(Player, OldPlayer) ->
    #player_status{id = RoleId, figure = #figure{career = _Career, sex = Sex}} = Player,
    #figure{career = _OldCareer, sex = OldSex} = OldPlayer#player_status.figure,
    ConsumeRecordMap = lib_goods_consume_record:get_consume_record_map(RoleId),
    Key = {?MOD_EQUIP, ?MOD_EQUIP_SUIT},
    OldRecordList = maps:get(Key, ConsumeRecordMap, []),
    F = fun(ConsumeRecord, {List, ListDb}) ->
        #consume_record{                  
            mod_key = ModKey,                    
            consume_list = ConsumeList          
        } = ConsumeRecord,
        case ModKey of 
            {EquipPos, Lv, SLv} ->
                case data_equip_suit:get_make_cfg(EquipPos, Lv, SLv) of
                    #suit_make_cfg{cost = CostList} -> ok;
                    _ -> CostList = []
                end,
                {_, RestoreRewardCon1} = ulists:keyfind(Sex, 1, CostList, {Sex, []}),
                {_, OldRestoreRewardCon1} = ulists:keyfind(OldSex, 1, CostList, {OldSex, []}),
                %% 先去重
                RestoreRewardCon = [{Type, GId, GNum} ||{Type, GId, GNum} <- RestoreRewardCon1, lists:keymember(GId, 2, OldRestoreRewardCon1) == false],
                OldRestoreRewardCon = [{Type, GId, GNum} ||{Type, GId, GNum} <- OldRestoreRewardCon1, lists:keymember(GId, 2, RestoreRewardCon1) == false],
                %% 找出替换物品列表
                F2 = fun({_Type, GId, _}, {ReList, List2}) ->
                    case ReList of 
                        [{_, ReGId, _}|LeftReList] ->
                            {LeftReList, [{GId, ReGId}|List2]};
                        [] ->
                            {ReList, List2}
                    end
                end,
                {_, ReplaceList} = lists:foldl(F2, {lists:keysort(3, RestoreRewardCon), []}, lists:keysort(3, OldRestoreRewardCon)),
                F3 = fun(Item, {Update, List3}) ->
                    case Item of 
                        {Type, GId, Num} ->
                            case lists:keyfind(GId, 1, ReplaceList) of 
                                {_, ReGId} ->
                                    {true, [{Type, ReGId, Num}|List3]};
                                _ ->
                                    {Update, [Item|List3]}
                            end;
                        {Type, GId, Num, AttrList} ->
                            case lists:keyfind(GId, 1, ReplaceList) of 
                                {_, ReGId} ->
                                    {true, [{Type, ReGId, Num, AttrList}|List3]};
                                _ ->
                                    {Update, [Item|List3]}
                            end;
                        _ ->
                            {Update, [Item|List3]}
                    end
                end,
                {UpdateDb, NewConsumeList} = lists:foldl(F3, {false, []}, ConsumeList),
                NewConsumeRecord = ConsumeRecord#consume_record{consume_list = NewConsumeList},
                case UpdateDb of 
                    true -> 
                        NewListDb = [NewConsumeRecord|ListDb];
                    _ -> NewListDb = ListDb
                end,
                {[NewConsumeRecord|List], NewListDb};
            _ ->
                {[ConsumeRecord|List], ListDb}
        end
    end,
    {NewRecordList, ListDb} = lists:foldl(F, {[], []}, OldRecordList),
    spawn(fun() ->
        FDb = fun(ConsumeRecord) ->
            lib_goods_consume_record:db_update_consume_list(ConsumeRecord)
        end,
        lists:foreach(FDb, ListDb)
    end),
    NewConsumeRecordMap = maps:put(Key, NewRecordList, ConsumeRecordMap),
    lib_goods_consume_record:set_consume_record_map(NewConsumeRecordMap),
    Player.