%% ---------------------------------------------------------------------------
%% @doc 个性装扮
%% @author yxf
%% @since  2017-10-31
%% @Description 个性装扮公共函数
%% ---------------------------------------------------------------------------
-module(lib_dress_up).
-export([
    login/1
    , active_dress_up/3
    , use_dress/3
    , unuse_dress/3
    , get_dress_list_from_db/1
    , gm_migration_picture/0
    , handle_event/2
    , count_one_dress_up_attr/3
]).
-include("server.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("rec_dress_up.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

%%登录初始化-------------------------------------------------------------------------
login(PS) -> 
    RoleId = PS#player_status.id,
    F = fun(PlayerId) ->
        TypeDressList = db:get_all(io_lib:format(?sql_dress_up_select, [PlayerId])),
        F2 = fun([DressId, DressLv, DressType, IsUsing, Time], L) ->
            OldDress = #dress{active_list = OldActiveList, use_id = OldUseId} = ulists:keyfind(DressType, #dress.type, L, #dress{type = DressType}),
            NUseId = ?IF(IsUsing == ?DRESS_ISUSING, DressId, OldUseId),
            NDress = OldDress#dress{active_list = [{DressId, DressLv, Time}|OldActiveList], use_id = NUseId},
            lists:keystore(DressType, #dress.type, L, NDress)
        end,
        lists:foldl(F2, [], TypeDressList)
    end,
    DressList = F(RoleId),
    UseDressList = [{DressType, UseId} || #dress{type = DressType, use_id = UseId} <- DressList, UseId > 0],
    Figure = PS#player_status.figure,
    NewDressStatus = #status_dress_up{dress_list = DressList},
    NewPS = PS#player_status{figure = Figure#figure{dress_list = UseDressList}, dress_up = NewDressStatus},
    %?PRINT("DressList ~p~n", [DressList]),
    count_dress_up_attribute(NewPS).

%% 登录事件分发
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{
        sid = Sid, id = Id, figure = Figure, dress_up = DressStatus, original_attr = OriginalAttr
    } = Player,
    #figure{lv = Lv, career = Career, dress_list = UseDressList} = Figure,
    CheckLv = data_dress_up:get_value(?TURN_PICTURE_KEY_2),
    #status_dress_up{dress_list = DressUp} = DressStatus,
    LastPlayer =
        case CheckLv == Lv of
            true ->
                %% 默认头像
                Picture = lib_career:get_picture(Career),
                IntPicture = binary_to_integer(Picture),
                OldDress = #dress{active_list = OldActiveList, use_id = OldUseId} = ulists:keyfind(?DRESS_UP_PICTURE, #dress.type, DressUp, #dress{type = ?DRESS_UP_PICTURE}),
                case lists:keyfind(IntPicture, 1, OldActiveList) of
                    false ->
                        {NUseId, IsUsing} = ?IF(OldUseId == 0, {IntPicture, ?DRESS_ISUSING}, {OldUseId, ?DRESS_UNUSING}),
                        PlayerDressSql = io_lib:format(?sql_dress_up_replace, [Id, IntPicture, 1, ?DRESS_UP_PICTURE, IsUsing, 0]),
                        db:execute(PlayerDressSql),
                        NewActiveList = [{IntPicture, 1, 0} | lists:delete(IntPicture, OldActiveList)],
                        NewDress = OldDress#dress{active_list = NewActiveList, use_id = NUseId},
                        NewDressUp = lists:keystore(?DRESS_UP_PICTURE, #dress.type, DressUp, NewDress),
                        NewUseDressList = [{?DRESS_UP_PICTURE, NUseId} | lists:delete(?DRESS_UP_PICTURE, UseDressList)],
                        NewDressStatus = #status_dress_up{dress_list = NewDressUp},
                        Fun = fun({DressId, Level, _Time}) ->
                            DressAttrL = count_one_dress_up_attr(?DRESS_UP_PICTURE, DressId, Level),
                            CurPower = lib_player:calc_partial_power(OriginalAttr, 0, DressAttrL),
                            NextDressAttrL = count_one_dress_up_attr(?DRESS_UP_PICTURE, DressId, Level + 1),
                            case NextDressAttrL of
                                [] -> NextPower = 0;
                                _ -> NextPower = lib_player:calc_expact_power(OriginalAttr, 0, NextDressAttrL)
                            end,
                            {DressId, Level, CurPower, NextPower}
                        end,    
                        ActiveList = lists:map(Fun, NewActiveList),
                        lib_server_send:send_to_sid(Sid, pt_112, 11200, [?DRESS_UP_PICTURE, NUseId, ActiveList]),
                        NewPs = Player#player_status{figure = Figure#figure{dress_list = NewUseDressList, picture = integer_to_binary(NUseId)}, dress_up = NewDressStatus},
                        count_dress_up_attribute(NewPs);
                    _ ->
                        Player
                end;
            _ -> Player
        end,
    {ok, LastPlayer};
handle_event(Player, #event_callback{}) -> {ok, Player}.

get_dress_list_from_db(RoleId) ->
    F = fun(PlayerId) ->
        TypeDressList = db:get_all(io_lib:format(?sql_dress_up_select, [PlayerId])),
        F2 = fun([DressId, DressLv, DressType, IsUsing, Time], L) ->
            OldDress = #dress{active_list = OldActiveList, use_id = OldUseId} = ulists:keyfind(DressType, #dress.type, L, #dress{type = DressType}),
            NUseId = ?IF(IsUsing == ?DRESS_ISUSING, DressId, OldUseId),
            NDress = OldDress#dress{active_list = [{DressId, DressLv, Time}|OldActiveList], use_id = NUseId},
            lists:keystore(DressType, #dress.type, L, NDress)
        end,
        lists:foldl(F2, [], TypeDressList)
    end,
    DressList = F(RoleId),
    UseDressList = [{DressType, UseId} || #dress{type = DressType, use_id = UseId} <- DressList, UseId > 0],
    UseDressList.

%%计算装扮属性加成
count_dress_up_attribute(PS) ->
    #player_status{dress_up = StatusDressUp} = PS,
    #status_dress_up{dress_list = DressList} = StatusDressUp,
    F = fun(#dress{type = DressType, active_list = ActiveList}, {AttrL1, SkillL1}) ->
        F2 = fun({DressId, Level, _Time}, {AttrL2, SkillL2}) ->
            case data_dress_up:get_dress_config(DressType, DressId, Level) of 
                #base_dress_up_cfg{attr = Attr} ->
                    Skill = get_dress_up_skill(DressType, DressId, Level),
                    {[Attr|AttrL2], Skill ++ SkillL2};
                _ -> {AttrL2, SkillL2}
            end
        end,
        lists:foldl(F2, {AttrL1, SkillL1}, ActiveList)
    end,
    {AttrList, SkillList} = lists:foldl(F, {[], []}, DressList),
    SkillAttr = lib_skill:get_passive_skill_attr(SkillList),
    NAttrList = lib_player_attr:add_attr(list, [SkillAttr|AttrList]),
    NStatusDressUp = StatusDressUp#status_dress_up{attr = NAttrList, skill = SkillList},
    PS#player_status{dress_up = NStatusDressUp}.

count_one_dress_up_attr(DressType, DressId, Level) ->
    case data_dress_up:get_dress_config(DressType, DressId, Level) of 
        #base_dress_up_cfg{attr = Attr} ->
            SkillList = get_dress_up_skill(DressType, DressId, Level),
            SkillAttr = lib_skill:get_passive_skill_attr(SkillList),
            SkillAttr ++ Attr;
        _ -> 
            []
    end.

get_dress_up_skill(DressType, DressId, Level) ->
    F = fun(Lv, L) ->
        case data_dress_up:get_dress_config(DressType, DressId, Lv) of 
            #base_dress_up_cfg{skill = SkillId} when SkillId > 0 -> [{SkillId, 1}|L];
            _ -> L
        end
    end,
    lists:foldl(F, [], lists:seq(1, Level)).


count_player_attribute(PS) ->
    CountPS = lib_player:count_player_attribute(PS),
    lib_player:send_attribute_change_notify(CountPS, ?NOTIFY_ATTR),
    SkillPassive = lib_skill:get_skill_passive(CountPS),
    mod_scene_agent:update(CountPS, [{battle_attr, CountPS#player_status.battle_attr}, {passive_skill, SkillPassive}]),
    CountPS.

active_dress_up(PS, DressType, DressId) ->
    #player_status{id = RoleId, dress_up = StatusDressUp, original_attr = OriginalAttr} = PS,
    #status_dress_up{dress_list = DressList} = StatusDressUp,
    OldDress = ulists:keyfind(DressType, #dress.type, DressList, #dress{type = DressType}),
    #dress{active_list = OldActiveList, use_id = _UseId} = OldDress,
    {_, OldLevel, _Time} = ulists:keyfind(DressId, 1, OldActiveList, {DressId, 0, 0}),
    NewLevel = OldLevel + 1,
    %% NewUseId = ?IF(OldLevel == 0, DressId, UseId),
    case data_dress_up:get_dress_config(DressType, DressId, NewLevel) of 
        #base_dress_up_cfg{cost = Cost, condition = Condition} ->
            case lib_goods_api:cost_object_list_with_check(PS, Cost, dress_up, "active") of
                {true, PSCost} ->
                    case check(Condition, PS) of
                        ture ->
                            lib_log_api:log_active_dress_up(RoleId, DressType, DressId, OldLevel, NewLevel, Cost),
                            %% db_replace_dress_up(RoleId, DressType, DressId, NewLevel, ?IF(NewUseId == UseId, ?DRESS_ISUSING, ?DRESS_UNUSING)), 按策划需求，激活时不再自动穿戴
                            db_replace_dress_up(RoleId, DressType, DressId, NewLevel, ?DRESS_UNUSING),
                            NewActiveList = lists:keystore(DressId, 1, OldActiveList, {DressId, NewLevel, 0}),
                            NewDress = OldDress#dress{active_list = NewActiveList},
                            NewDressList = lists:keystore(DressType, #dress.type, DressList, NewDress),
                            NewStatusDressUp = StatusDressUp#status_dress_up{dress_list = NewDressList},
                            NPS = PSCost#player_status{dress_up = NewStatusDressUp},
                            %% PSDressUse = ?IF(NewUseId =/= UseId, use_dress_core(NPS, DressType, NewUseId), NPS),
                            PSAttr = count_dress_up_attribute(NPS),
                            CountPS = count_player_attribute(PSAttr),
                            %% 计算当前战力与下一级战力
                            DressAttrL = count_one_dress_up_attr(DressType, DressId, NewLevel),
                            CurPower = lib_player:calc_partial_power(OriginalAttr, 0, DressAttrL),
                            NextDressAttrL = lib_dress_up:count_one_dress_up_attr(DressType, DressId, NewLevel + 1),
                            case NextDressAttrL of
                                [] -> NextPower = 0;
                                _ -> NextPower = lib_player:calc_expact_power(OriginalAttr, 0, NextDressAttrL)
                            end,
                            ?PRINT("active_dress_up ~p~n", [CountPS#player_status.dress_up]),
                            {true, CountPS, NewLevel, CurPower, NextPower};
                        {false, Err} ->
                            {false, ?ERRCODE(Err)}
                    end;
                {false, Res, _} ->
                    {false, Res}
            end;
        _ ->
            {false, ?ERRCODE(err112_dress_max_level)}
    end.

use_dress(PS, DressType, DressId) ->
    #player_status{dress_up = StatusDressUp} = PS,
    #status_dress_up{dress_list = DressList} = StatusDressUp,
    OldDress = ulists:keyfind(DressType, #dress.type, DressList, #dress{type = DressType}),
    #dress{active_list = ActiveList, use_id = UseId} = OldDress,
    IsActive = lists:keyfind(DressId, 1, ActiveList),
    if
        UseId == DressId -> {false, ?ERRCODE(err112_dress_id_used)};
        IsActive == false -> {false, ?ERRCODE(err112_dress_not_enabled)};
        true ->
            NPS = use_dress_core(PS, DressType, DressId),
            {true, NPS}
    end.

use_dress_core(PS, DressType, DressId) ->
    #player_status{id = RoleId, dress_up = StatusDressUp, figure = Figure} = PS,
    #status_dress_up{dress_list = DressList} = StatusDressUp,
    OldDress = ulists:keyfind(DressType, #dress.type, DressList, #dress{type = DressType}),
    #dress{use_id = OldUseId} = OldDress,
    NewDress = OldDress#dress{use_id = DressId},
    NewDressList = lists:keystore(DressType, #dress.type, DressList, NewDress),
    NewStatusDressUp = StatusDressUp#status_dress_up{dress_list = NewDressList},
    UseDressList = [{Type, UseId} || #dress{type = Type, use_id = UseId} <- NewDressList, UseId > 0],
    ?IF(OldUseId > 0, db_update_dress_use(RoleId, DressType, OldUseId, ?DRESS_UNUSING), ok),
    db_update_dress_use(RoleId, DressType, DressId, ?DRESS_ISUSING),
    NewPS = PS#player_status{figure = Figure#figure{dress_list = UseDressList}, dress_up = NewStatusDressUp},
    case DressType of
        ?DRESS_UP_PICTURE ->
            NewPictureVer = Figure#figure.picture_ver,
            {ok, NewPS2} = lib_player:update_player_picture_online(NewPS, integer_to_binary(DressId), NewPictureVer);
        _ ->
            NewPS2 = NewPS
    end,
    broadcast_role_dress_up(NewPS),
    mod_chat_cache:update_chat_cache_state(RoleId, UseDressList),
    NewPS2.

unuse_dress(PS, DressType, DressId) ->
    #player_status{dress_up = StatusDressUp} = PS,
    #status_dress_up{dress_list = DressList} = StatusDressUp,
    OldDress = ulists:keyfind(DressType, #dress.type, DressList, #dress{type = DressType}),
    #dress{active_list = ActiveList, use_id = UseId} = OldDress,
    IsActive = lists:keyfind(DressId, 1, ActiveList),
    if
        UseId =/= DressId -> {false, ?ERRCODE(err112_dress_id_used)};
        IsActive == false -> {false, ?ERRCODE(err112_dress_not_enabled)};
        true ->
            NPS = unuse_dress_core(PS, DressType, DressId),
            {true, NPS}
    end.

unuse_dress_core(PS, DressType, DressId) ->
    #player_status{id = RoleId, dress_up = StatusDressUp, figure = Figure} = PS,
    #status_dress_up{dress_list = DressList} = StatusDressUp,
    OldDress = ulists:keyfind(DressType, #dress.type, DressList, #dress{type = DressType}),
%%    case DressType of
%%        ?DRESS_UP_PICTURE ->
%%            NewUseId = binary_to_integer(lib_career:get_picture(0));
%%        _ ->
%%            NewUseId = 0
%%    end,
    NewDress = OldDress#dress{use_id = 0},
    NewDressList = lists:keystore(DressType, #dress.type, DressList, NewDress),
    NewStatusDressUp = StatusDressUp#status_dress_up{dress_list = NewDressList},
    UseDressList = [{Type, UseId} || #dress{type = Type, use_id = UseId} <- NewDressList, UseId > 0],
    db_update_dress_use(RoleId, DressType, DressId, ?DRESS_UNUSING),
    NewPS = PS#player_status{figure = Figure#figure{dress_list = UseDressList}, dress_up = NewStatusDressUp},
    broadcast_role_dress_up(NewPS),
    mod_chat_cache:update_chat_cache_state(RoleId, UseDressList),
%%    case DressType of
%%        ?DRESS_UP_PICTURE ->
%%            NewPictureVer = Figure#figure.picture_ver,
%%            {ok, NewPS2} = lib_player:update_player_picture_online(NewPS, integer_to_binary(DressId), NewPictureVer);
%%        _ ->
%%            NewPS2 = NewPS
%%    end,
    NewPS.

broadcast_role_dress_up(PS) ->
    #player_status{id = RoleId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y, figure = Figure} = PS,
    #figure{dress_list = DressList} = Figure,
    lib_role:update_role_show(RoleId, [{dress_list, DressList}]),
    {ok, Bin} = pt_112:write(11204, [RoleId, DressList]),
    lib_server_send:send_to_area_scene(Scene, PoolId, CopyId, X, Y, Bin),
    mod_scene_agent:update(PS, [{dress_list, DressList}]).

db_replace_dress_up(RoleId, DressType, DressId, Level, IsUse) ->
    Sql = io_lib:format(?sql_dress_up_replace, [RoleId, DressId, Level, DressType, IsUse, 0]),
    db:execute(Sql).

db_update_dress_use(RoleId, DressType, DressId, IsUse) ->
    Sql = io_lib:format(?sql_dress_up_update, [IsUse, RoleId, DressId, DressType]),
    db:execute(Sql).

% do_upgrade_illu_help(CurNum, CurLv, CurExp, ExpPlus, UpExp, UnitExp) ->
%     %?PRINT("~p,~p,~p,~p,~p,~p~n", [CurNum, CurLv, CurExp, ExpPlus, UpExp, UnitExp]),
%      case CurExp + ExpPlus >= UpExp of
%         true ->
%             NewNum = CurNum + util:ceil((UpExp - CurExp)/ UnitExp),
%             NextLv = CurLv + 1,
%             NextExp = CurExp + ExpPlus - UpExp,
%             case data_dress_up:get_illustration_cfg(NextLv) of
%                  #base_dress_illustration{illu_lvup_exp = NextUpExp} ->
%                     %% 能再升下一级的情况
%                     case NextExp >= NextUpExp of
%                         true -> do_upgrade_illu_help(NewNum, NextLv, 0, NextExp, NextUpExp, UnitExp);
%                         _ ->   {NewNum, NextLv, NextExp}
%                     end;
%                 _ -> {CurNum, CurLv, CurExp}
%             end;
%         false -> {ExpPlus div UnitExp, CurLv, CurExp + ExpPlus}
%     end.


check([], _) -> ture;
check([{turn, CheckNum} | N], Ps) ->
    #player_status{figure = #figure{turn = Turn}} = Ps,
    case Turn >= CheckNum of
        true ->
            check(N, Ps);
        _ ->
            {false, err161_not_turn}
    end;
check([_T | N], Ps) ->
    check(N, Ps).


%% 头像数据迁移
gm_migration_picture() ->
    %% 在这个列表里的id说明已经是修改过的
    FixIdList = [90,91,92,93,94,95,96,97],

    %% 将player_picture（头像表）的数据转存到role_dress_up（装扮表）中
    RoleIdList = db:get_all(io_lib:format(<<"select `id` from player_low where lv >= 50">>, [])),
    F = fun([RoleId]) ->
        PictureIdList = db:get_all(io_lib:format(<<"select `picture_id` from player_picture where `id` = ~p">>, [RoleId])),
        UsePictureId = db:get_one(io_lib:format(<<"select `picture`  from player_low where id = ~p">>, [RoleId])),
        F1 = fun([PictureId]) ->
            NewPictureId = get_new_picture_id(PictureId),
            case lists:member(PictureId, FixIdList) of
                true ->
                    skip;
                _ ->
                    IsUse = ?IF(binary_to_integer(UsePictureId) == PictureId, ?DRESS_ISUSING, ?DRESS_UNUSING),
                    db_replace_dress_up(RoleId, ?DRESS_UP_PICTURE, NewPictureId, 1, IsUse)
            end
             end,
        lists:foreach(F1, PictureIdList),
        IsUse = ?IF(binary_to_integer(UsePictureId) == 90, ?DRESS_ISUSING, ?DRESS_UNUSING),
        db_replace_dress_up(RoleId, ?DRESS_UP_PICTURE, 90, 1, IsUse)
        end,
    lists:foreach(F, RoleIdList),

    %% 修改当前穿戴的头像id
    TabList = [player_low],

    F2 = fun(TableName) ->
        PictureList =  db:get_all(io_lib:format(<<"select `picture` from ~p order by `picture`">>, [TableName])),
        F3 = fun([PictureId]) ->
            case catch binary_to_integer(PictureId) of
                IntId when is_integer(IntId) ->
                    case lists:member(IntId, FixIdList) of
                        ture ->
                            skip;
                        _ ->
                            NewPictureId = get_new_picture_id(IntId),
                            ReplaceSql = io_lib:format(<<"UPDATE ~p SET `picture` = '~s' where `picture` = '~s' ">>, [TableName, integer_to_binary(NewPictureId), PictureId]),
                            db:execute(ReplaceSql)
                    end;
                _ ->
                    ?ERR("TableName = ~w, PictureId = ~w~n",[TableName, PictureId])
            end end,
        lists:foreach(F3, PictureList)
        end,
    lists:foreach(F2, TabList),
    ok.



get_new_picture_id(PictureId) ->
    case PictureId of
        1 -> 90;
        2 -> 90;
        3 -> 90;
        4 -> 90;
        101	-> 91;
        102	-> 92;
        103	-> 93;
        104	-> 94;
        105	-> 95;
        106	-> 96;
        107	-> 97;
        201	-> 91;
        202	-> 92;
        203	-> 93;
        204	-> 94;
        205	-> 95;
        206	-> 96;
        207	-> 97;
        301	-> 91;
        302	-> 92;
        303	-> 93;
        304	-> 94;
        305	-> 95;
        306	-> 96;
        307	-> 97;
        401	-> 91;
        402	-> 92;
        403	-> 93;
        404	-> 94;
        405	-> 95;
        406	-> 96;
        407	-> 97;
        _ -> 90
    end.


