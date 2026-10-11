%%-----------------------------------------------------------------------------
%% @Module  :       lib_sea_treasure
%% @Author  :       xlh
%% @Email   :
%% @Created :       2020-06-28
%% @Description:    璀璨之海（挖矿）函数库
%%-----------------------------------------------------------------------------
-module(lib_sea_treasure).

-include("sea_treasure.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("reincarnation.hrl").
-include("mount.hrl").
-include("skill.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("attr.hrl").
-include("guild.hrl").
-include("def_vip.hrl").
-include("def_id_create.hrl").
-include("rec_assist.hrl").

-compile(export_all).

%% 跨服计算巡航模式
get_server_treasure_type_before(Optime) ->
    OpenDay = lib_c_sanctuary_mod:get_open_day(Optime),
    % OneServerMod =
    %     case data_sea_treasure:get_sea_treasure_value(one_server_mod) of
    %         One when is_integer(One) -> One;
    %         _ -> 1
    %     end,
    case data_sea_treasure:get_mod_id(OpenDay) of %% 本服模式不会在跨服中心处理因为开服第一天跨服中心分区数据不存在
        Type when is_integer(Type) -> {Type, OpenDay};
        _ -> null
    end.

%% 本服计算巡航模式
get_server_treasure_type() ->
    OpenDay = util:get_open_day(),
    OneServerMod =
        case data_sea_treasure:get_sea_treasure_value(one_server_mod) of
            One when is_integer(One) -> One;
            _ -> 1
        end,
    case data_sea_treasure:get_mod_id(OpenDay) of
        Type when is_integer(Type) andalso Type == OneServerMod -> {Type, true};
        _ -> false
    end.

%% 被掠夺后计算可获得奖励
calc_get_reward(Reward, []) -> Reward;
calc_get_reward(Reward, [{Type, 0, Num}|T]) when Type =/= 0 ->
    case lists:keyfind(Type, 1, Reward) of
        {Type, GoodsType, Total} when Total>Num ->
            NewReward = lists:keystore(Type, 1, Reward, {Type, GoodsType, Total-Num}),
            calc_get_reward(NewReward, T);
        {Type, _, _} ->
            NewReward = lists:keydelete(Type, 1, Reward),
            calc_get_reward(NewReward, T);
        _ ->
            calc_get_reward(Reward, T)
    end;
calc_get_reward(Reward, [{0, GoodsType, Num}|T]) when GoodsType =/= 0 ->
    case lists:keyfind(GoodsType, 2, Reward) of
        {Type, GoodsType, Total} when Total>Num ->
            NewReward = lists:keystore(GoodsType, 2, Reward, {Type, GoodsType, Total-Num}),
            calc_get_reward(NewReward, T);
        {_, GoodsType, _} ->
            NewReward = lists:keydelete(GoodsType, 2, Reward),
            calc_get_reward(NewReward, T);
        _ ->
            calc_get_reward(Reward, T)
    end;
calc_get_reward(Reward, [_|T]) -> calc_get_reward(Reward, T).

get_auto_id(ServerId, OldAutoId) ->
    <<SerId:16, _:32>> = <<OldAutoId:48>>,
    if
        SerId == ServerId ->
            OldAutoId;
        true ->
            mod_id_create:get_new_id(?SHIPPING_ID_CREATE)
    end.

change_list(List) ->
    Now = utime:unixtime(),
    ServerId = config:get_server_id(),
    %% 判断是否需要修改记录中的auto_id，非本服的auto_id都要改掉
    %% 防止合服数据冲突
    case data_sea_treasure:get_sea_treasure_value(log_data_repaire) of
        {Min, Max} when Now >= Min andalso Now =< Max ->
            [begin
                NewAutoId = get_auto_id(ServerId, AutoId),
                Val = [NewAutoId, Id, RoleId, RoberSerId, RoberSernum, RoberGuildId, RoberGuildNameBin, RoberId,
                    RoberNameBin, RoberPower, RoberHp, Type, RewardBin, BackRewardBin, RecvRewardBin, BackTimes, Time],
                NewAutoId =/= AutoId andalso db:execute(io_lib:format(<<"update sea_treasure_log set
                    auto_id = ~p where auto_id = ~p">>, [NewAutoId, AutoId])),
                NewAutoId =/= AutoId andalso db:execute(io_lib:format(?sql_delete_treasure_log, [AutoId])),
                Val
            end || [AutoId, Id, RoleId, RoberSerId, RoberSernum, RoberGuildId, RoberGuildNameBin, RoberId,
            RoberNameBin, RoberPower, RoberHp, Type, RewardBin, BackRewardBin, RecvRewardBin, BackTimes, Time]
            <- List];
        _ ->
            List
    end.

change_list_gm(List) ->
    ServerId = config:get_server_id(),
    change_list_gm_helper(ServerId, List, [], []).

change_list_gm_helper(_, [], Acc, OutList) -> {Acc, OutList};
change_list_gm_helper(ServerId, [[AutoId, Id, RoleId, RoberSerId, RoberSernum, RoberGuildId, RoberGuildNameBin, RoberId, RoberNameBin,
    RoberPower, RoberHp, Type, RewardBin, BackRewardBin, RecvRewardBin, BackTimes, Time]|T], DeleteAuidAcc, OutList) ->
    NewAutoId = get_auto_id(ServerId, AutoId),
    Val = [NewAutoId, Id, RoleId, RoberSerId, RoberSernum, RoberGuildId, RoberGuildNameBin, RoberId,
    RoberNameBin, RoberPower, RoberHp, Type, RewardBin, BackRewardBin, RecvRewardBin, BackTimes, Time],
    NewAcc1 =
    if
        NewAutoId =/= AutoId ->
            db:execute(io_lib:format(<<"update sea_treasure_log set auto_id = ~p where auto_id = ~p">>, [NewAutoId, AutoId])),
            db:execute(io_lib:format(?sql_delete_treasure_log, [AutoId])),
            case lists:keyfind(RoberSerId, 1, DeleteAuidAcc) of
                {_, DeleteAuidList} ->
                    lists:keystore(RoberSerId, 1, DeleteAuidAcc, {RoberSerId, [AutoId|DeleteAuidList]});
                _ ->
                    lists:keystore(RoberSerId, 1, DeleteAuidAcc, {RoberSerId, [AutoId]})
            end;
        true ->
            DeleteAuidAcc
    end,
    change_list_gm_helper(ServerId, T, NewAcc1, [Val|OutList]);
change_list_gm_helper(ServerId, [_|T], Acc1, OutList) ->
    ?ERR("error data num handle ~n",[]),
    change_list_gm_helper(ServerId, T, Acc1, OutList).


%% 数据库数据转换
db_data_make_record(log, [AutoId, Id, RoleId, RoberSerId, RoberSernum, RoberGuildId, RoberGuildNameBin, RoberId,
RoberNameBin, RoberPower, RoberHp, Type, RewardBin, BackRewardBin, RecvRewardBin, BackTimes, Time]) ->
    #treasure_log{
        id = Id
        ,role_id = RoleId
        ,auto_id = AutoId
        ,type = Type
        ,rober_serid = RoberSerId
        ,rober_sernum = RoberSernum
        ,rober_gid = RoberGuildId
        ,rober_gname = util:bitstring_to_term(RoberGuildNameBin)
        ,rober_id = RoberId
        ,rober_name = util:bitstring_to_term(RoberNameBin)
        ,reward = util:bitstring_to_term(RewardBin)
        ,rober_power = RoberPower
        ,rober_hp = RoberHp
        ,back_reward = util:bitstring_to_term(BackRewardBin)
        ,recieve_reward = util:bitstring_to_term(RecvRewardBin)
        ,back_times = BackTimes
        ,time = Time
    };
db_data_make_record(ship, [AutoId, Id, RoleId, RoleNameBin, GuildId, GuildNameBin, Rolelv, Power, Career, Sex, Turn, Pic, PicVer, Robtimes, HasRev, Endtime, Wlv]) ->
    #shipping_info{
        id = Id
        ,auto_id = AutoId
        ,ser_id = config:get_server_id()
        ,ser_num = config:get_server_num()
        ,guild_id = GuildId
        ,guild_name = util:bitstring_to_term(GuildNameBin)
        ,role_id = RoleId
        ,role_name = util:bitstring_to_term(RoleNameBin)
        ,role_lv = Rolelv
        ,power = Power
        ,career = Career
        ,sex = Sex
        ,turn = Turn
        ,pic = util:bitstring_to_term(Pic)
        ,pic_ver = PicVer
        ,has_recieve = HasRev
        ,end_time = Endtime
        ,rob_times = Robtimes
        ,end_ref = undefined
        ,wlv = Wlv
    };
db_data_make_record(_, _) -> skip.

make_record(shipping_info, [ShippingType, AutoId, ServerId, ServerNum, GuildId, GuildName, RoleId, RoleName,
RoleLv, Power, Career, Sex, Turn, Pic, PicVer, EndTime, EndRef, Wlv]) ->
    #shipping_info{
        id = ShippingType
        ,auto_id = AutoId
        ,ser_id = ServerId
        ,ser_num = ServerNum
        ,guild_id = GuildId
        ,guild_name = GuildName
        ,role_id = RoleId
        ,role_name = RoleName
        ,role_lv = RoleLv
        ,power = Power
        ,career = Career
        ,sex = Sex
        ,turn = Turn
        ,pic = Pic
        ,pic_ver = PicVer
        ,has_recieve = 0
        ,end_time = EndTime
        ,rob_times = 0
        ,end_ref = EndRef
        ,wlv = Wlv
    };
make_record(treasure_log, [ShippingType, RoleId, AutoId, Type, RoberSerId, RoberSernum, GuildId, GuildName, RoberId, RoberName,
RoberPower, Reward, RoberHp, BackReward, RecvReward, BackTimes, Time]) ->
    #treasure_log{
        id = ShippingType
        ,role_id = RoleId
        ,auto_id = AutoId
        ,type = Type
        ,rober_serid = RoberSerId
        ,rober_sernum = RoberSernum
        ,rober_gid = GuildId
        ,rober_gname = GuildName
        ,rober_id = RoberId
        ,rober_name = RoberName
        ,rober_power = RoberPower
        ,reward = Reward
        ,rober_hp = RoberHp
        ,back_reward = BackReward
        ,recieve_reward = RecvReward
        ,back_times = BackTimes
        ,time = Time
    };
make_record(_, _) -> skip.

calc_new_shipping_map(ServerId, ShippingMap, SendList) ->
    OldList = maps:get(ServerId, ShippingMap, []),
    Fun = fun
        (#shipping_info{auto_id = AutoId} = Ship, Acc) ->
            lists:keystore(AutoId, #shipping_info.auto_id, Acc, Ship);
        ({AutoId, TemVal}, Acc) ->
            case lists:keyfind(AutoId, #shipping_info.auto_id, Acc) of
                #shipping_info{} = Ship ->
                    case TemVal of
                        {Key, Val} ->
                            if
                                Key == #shipping_info.has_recieve ->
                                    lists:keydelete(AutoId, #shipping_info.auto_id, Acc);
                                true ->
                                    NewShip = erlang:setelement(Key, Ship, Val),
                                    lists:keystore(AutoId, #shipping_info.auto_id, Acc, NewShip)
                            end;
                        List when is_list(List) ->
                            case lists:keyfind(#shipping_info.has_recieve, 1, List) of
                                {_, _} -> lists:keydelete(AutoId, #shipping_info.auto_id, Acc);
                                _ ->
                                    NewShip = lists:foldl(
                                        fun({Key, Val}, Tem) -> erlang:setelement(Key, Tem, Val) end,
                                    Ship, List),
                                    lists:keystore(AutoId, #shipping_info.auto_id, Acc, NewShip)
                            end;
                        _ ->
                            Acc
                    end;
                _ ->
                    Acc
            end;
        (_, Acc) -> Acc
    end,
    NewList = lists:foldl(Fun, OldList, SendList),
    maps:put(ServerId, NewList, ShippingMap).

save_ship_to_db(Ship) when is_record(Ship, shipping_info) ->
    #shipping_info{
        id = ShippingType
        ,auto_id = AutoId
        ,guild_id = GuildId
        ,guild_name = GuildName
        ,role_id = RoleId
        ,role_name = RoleName
        ,role_lv = RoleLv
        ,power = Power
        ,career = Career
        ,sex = Sex
        ,turn = Turn
        ,pic = Pic
        ,pic_ver = PicVer
        ,has_recieve = HasRev
        ,end_time = Endtime
        ,rob_times = Robtimes
        ,wlv = Wlv
    } = Ship,
    DbInsertArgs = [
        AutoId, ShippingType, RoleId, util:term_to_bitstring(RoleName), GuildId, util:term_to_bitstring(GuildName),
        RoleLv, Power, Career, Sex, Turn, util:term_to_bitstring(Pic), PicVer, Robtimes, HasRev, Endtime, Wlv
    ],
    save_ship_to_db(DbInsertArgs);
save_ship_to_db(DbArgs) when is_list(DbArgs) ->
    Sql = io_lib:format(?sql_insert_treasure_shipping, DbArgs),
    db:execute(Sql);
save_ship_to_db(_E) -> ?ERR("error arg to save_db, _E:~p~n",[_E]), ok.

save_more_ship_to_db(LogList) ->
    DBList =
    [   [
        AutoId, ShippingType, RoleId, util:term_to_bitstring(RoleName), GuildId, util:term_to_bitstring(GuildName),
        RoleLv, Power, Career, Sex, Turn, util:term_to_bitstring(Pic), PicVer, Robtimes, HasRev, Endtime, Wlv
        ]
    ||#shipping_info{
        id = ShippingType
        ,auto_id = AutoId
        ,guild_id = GuildId
        ,guild_name = GuildName
        ,role_id = RoleId
        ,role_name = RoleName
        ,role_lv = RoleLv
        ,power = Power
        ,career = Career
        ,sex = Sex
        ,turn = Turn
        ,pic = Pic
        ,pic_ver = PicVer
        ,has_recieve = HasRev
        ,end_time = Endtime
        ,rob_times = Robtimes
        ,wlv = Wlv
        } <- LogList
    ],
    ClumnList = [
        auto_id, id, role_id, role_name, guild_id, guild_name, role_lv, power,
        career, sex, turn, pic, pic_ver, rob_times, has_recieve, end_time, wlv
    ],
    if
        DBList =/= [] ->
            Sql = usql:replace(sea_treasure_shipping, ClumnList, DBList),
            db:execute(Sql);
        true ->
            skip
    end.


save_log_to_db(Log) when is_record(Log, treasure_log) ->
    #treasure_log{
        id = ShippingType
        ,role_id = RoleId
        ,auto_id = AutoId
        ,type = Type
        ,rober_serid = RoberSerId
        ,rober_sernum = RoberSernum
        ,rober_gid = RoberGuildId
        ,rober_gname = RoberGuildName
        ,rober_id = RoberId
        ,rober_name = RoberName
        ,rober_power = RoberPower
        ,reward = Reward
        ,rober_hp = RoberHp
        ,back_reward = BackReward
        ,recieve_reward = RecvReward
        ,back_times = BackTimes
        ,time = Time
    } = Log,
    DbInsertArgs = [
        AutoId, ShippingType, RoleId, RoberSerId, RoberSernum, RoberGuildId,
        util:term_to_bitstring(RoberGuildName), RoberId, util:term_to_bitstring(RoberName),
        RoberPower, RoberHp, Type, util:term_to_bitstring(Reward), util:term_to_bitstring(BackReward),
        util:term_to_bitstring(RecvReward), BackTimes, Time
    ],
    save_log_to_db(DbInsertArgs);
save_log_to_db([_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _] = DbArgs) ->
    Sql = io_lib:format(?sql_insert_treasure_log, DbArgs),
    db:execute(Sql);
save_log_to_db(_E) -> ?ERR("error arg to save_db, _E:~p~n",[_E]), ok.

save_more_log_to_db(LogList) ->
    DBList =
    [   [
        AutoId, ShippingType, RoleId, RoberSerId, RoberSernum, RoberGuildId,
        util:term_to_bitstring(RoberGuildName), RoberId, util:term_to_bitstring(RoberName),
        RoberPower, RoberHp, Type, util:term_to_bitstring(Reward), util:term_to_bitstring(BackReward),
        util:term_to_bitstring(RecvReward), BackTimes, Time
        ]
    ||#treasure_log{
        id = ShippingType
        ,role_id = RoleId
        ,auto_id = AutoId
        ,type = Type
        ,rober_serid = RoberSerId
        ,rober_sernum = RoberSernum
        ,rober_gid = RoberGuildId
        ,rober_gname = RoberGuildName
        ,rober_id = RoberId
        ,rober_name = RoberName
        ,rober_power = RoberPower
        ,reward = Reward
        ,rober_hp = RoberHp
        ,back_reward = BackReward
        ,recieve_reward = RecvReward
        ,back_times = BackTimes
        ,time = Time
        } <- LogList
    ],
    ClumnList = [
        auto_id, id, role_id, ser_id, ser_num, rober_gid, rober_gname, rober_id,
        rober_name, rober_power, rober_hp, type, reward, back_reward, recieve_reward, back_times, time
    ],
    if
        DBList =/= [] ->
            Sql = usql:replace(sea_treasure_log, ClumnList, DBList),
            db:execute(Sql);
        true ->
            skip
    end.

add_lock_to_player(Player) ->
    NewPlayer = lib_player:soft_action_lock(Player, ?ERRCODE(err189_on_sea_treasure_scene)),
    NewPlayer.
%% 通用检测
check([]) -> true;
check([H|T]) ->
    case do_check(H) of
        true -> check(T);
        {false, Code} -> {false, Code}
    end.

do_check({scene_type, Scene}) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SEA_TREASURE} -> {false, ?ERRCODE(err418_has_in_scene)};
        _ -> true
    end;
do_check({role_do_ship, RoleId, ShippingList}) ->
    case lists:keyfind(RoleId, #shipping_info.role_id, ShippingList) of
        #shipping_info{} -> {false, ?ERRCODE(err189_get_before_reward_first)};
        _ -> true
    end;
do_check({open_lv, RoleLv}) ->
    case data_sea_treasure:get_sea_treasure_value(open_lv) of
        LimitLv when is_integer(LimitLv) andalso RoleLv >= LimitLv ->
            true;
        _ ->
            {false, ?ERRCODE(lv_limit)}
    end;
do_check({open_day, OpenDay}) ->
    case data_sea_treasure:get_sea_treasure_value(open_day) of
        OpenDayLimit when is_integer(OpenDayLimit) andalso OpenDay >= OpenDayLimit ->
            true;
        _ ->
            {false, ?ERRCODE(err137_open_day_limit)}
    end;
do_check({shipping_cfg, ShippingType}) ->
    case data_sea_treasure:get_reward_info(ShippingType) of
        #base_sea_treasure_reward{} -> true;
        _ -> {false, ?MISSING_CONFIG}
    end;
do_check({battle_type, BatType}) ->
    case BatType == ?BATTLE_TYPE_ROBER orelse BatType == ?BATTLE_TYPE_RBACK of
        true -> true;
        _ -> {false, ?ERRCODE(data_error)}
    end;
do_check({day_times, Times, DayMaxTimes}) ->
    case Times < DayMaxTimes of
        true -> true;
        _ -> {false, ?ERRCODE(err189_day_times_max)}
    end;
do_check(_) -> {false, ?ERRCODE(err189_do_not_have_check)}.


player_apply_cast_from_center(_SeaTreasureMod, SerId, RoleId, Mod, Fun, Args) ->
    case util:is_cls() of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, Mod, Fun, Args);
        _ ->
            mod_clusters_center:apply_cast(SerId, lib_player, apply_cast,
                [RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, Mod, Fun, Args])
    end.


get_skill_list(Player) ->
    #player_status{skill = Skill} = Player,
    #status_skill{skill_list = SkillList} = Skill,
    SkillList.

calc_battle_attr(BattleAttr, BackTimes) ->
    List = ?revenge_rober_attr,
    #battle_attr{hp = _Hp, hp_lim = HpLimit, attr = Attr} = BattleAttr,
    AttrL = lib_player_attr:to_kv_list(Attr),
    SortList = lists:reverse(lists:keysort(1, List)),
    F = fun({BackTimesCfg, _}) ->
        BackTimes >= BackTimesCfg
    end,
    case ulists:find(F, SortList) of
        {ok, {_, Value}} ->
            NewAttrL = [{K, erlang:round(V*Value)} ||{K, V} <- AttrL],
            NewAttr = lib_player_attr:to_attr_record(NewAttrL),
            BattleAttr#battle_attr{hp = erlang:round(HpLimit*Value), hp_lim = erlang:round(HpLimit*Value), attr = NewAttr};
        _ -> BattleAttr#battle_attr{hp = HpLimit, hp_lim = HpLimit}
    end.


convert_figure(Figure) ->
    #figure{
        name= Name,
        sex = Sex,
        career = Career,
        lv = Lv,
        vip = Vip,
        vip_hide = VipHide,
        lv_model = LvModel,
        fashion_model = FashionFigure,
        picture = Picture,
        picture_ver = PictureVer,
        guild_id = GuildId,
        guild_name = GuildName,
        position = Position,
        position_name = PositionName,
        designation = DsigtId,
        mount_figure = MountFigure
    } = Figure,
    #figure{
        name= Name, sex = Sex, career = Career, lv = Lv, vip = Vip, vip_hide = VipHide, picture = Picture,
        picture_ver = PictureVer, lv_model = LvModel, fashion_model = FashionFigure,
        guild_id = GuildId, guild_name = GuildName, position = Position,
        position_name = PositionName, designation = DsigtId, mount_figure = MountFigure
    }.

get_fake_base_info(Wlv) ->
    RandLv = urand:rand(max(?robort_min_lv, Wlv - ?robort_min_lv), Wlv),
    Lv  = max(200, RandLv), %% 策划要求写死机器人等级不小于200级
    #base_sea_treasure_robot{power_range = PowerRange} = data_sea_treasure:get_robot_info(Wlv),
    Name = case data_jjc:get_robot_name_list() of
        [] ->
            utext:get(182); %%"守卫";
        NameList ->
            urand:list_rand(NameList)
    end,
    Power = case PowerRange of
        [Val1, Val2|_] ->
            if
                Val2 > Val1 -> urand:rand(Val1, Val2);
                Val2 == Val1 -> Val1;
                true -> urand:rand(Val2, Val1)
            end;
        _ -> urand:rand(1000000, 2000000)
    end,
    {Career, Sex} = lib_career:rand_career_and_sex(),
    Turn = urand:list_rand(lists:seq(0, ?MAX_TURN)),                %%随机转生
    {Lv, Name, Power, Career, Sex, Turn}.

get_fake_man_figure(Wlv, Power, Lv, Name, Career, Sex, Turn) ->
    LvModel = lib_player:get_model_list(Career, Sex, Turn, Lv),     %%等级模型

    #base_sea_treasure_robot{power_range = _PowerRange, rmount = FMount, attr_value = AttrCfg,
        skill = Skill, rfly = RFly, rweapon = RWeapon, rfashion = Rfashion} = data_sea_treasure:get_robot_info(Wlv),
    MountFigure = get_fake_mount_figure(FMount, RFly, RWeapon, Career),
    %%时装
    FashionFigure = get_fake_fashion_figure(Career, Rfashion),
    %%属性
    BattleAttr = get_fake_battle_attr(Power, AttrCfg),
    % ?PRINT("Wlv:~p, Power:~p, AttrCfg:~p~n",[Wlv, Power, AttrCfg]),
    %% 技能
    case lists:keyfind(Career, 1, Skill) of
        {_, SkillList} when SkillList =/= [] ->
            SkillList;
        _ ->
            ?ERR("MISSING SKILL CONFIG WHEN CAREER IS ~p, CONFIG:~p~n",[Career, Skill]),
            SkillList = []
    end,
    Figure = #figure{
        name = Name, sex = Sex, career = Career, lv = Lv, lv_model = LvModel,
        fashion_model = FashionFigure, mount_figure = MountFigure
    },
    {Figure, SkillList, BattleAttr}.

get_fake_battle_attr(Power, AttrCfg) ->
    AttrL = [{K, erlang:round(V*Power)}||{K, V}<-AttrCfg],
    NewAttr = lib_player_attr:to_attr_record(AttrL),
    case lists:keyfind(?HP, 1, AttrL) of
        {_, Val} -> skip;
        _ -> Val = 1
    end,
    #battle_attr{hp = Val, hp_lim = Val, attr = NewAttr}.

%%坐骑外形
get_fake_mount_figure(RMount, RFly, RWeapon, Career) ->
    MountKv = ?IF(RMount == [], [], [{?MOUNT_ID, urand:list_rand(RMount), 0}]),
    FlyKv = ?IF(RFly == [], [], [{?FLY_ID, urand:list_rand(RFly), 0}]),
    HolyorganKv = case lists:keyfind(Career, 1, RWeapon) of
        {_, HolyorganL} when HolyorganL =/= [] ->
            [{?HOLYORGAN_ID, urand:list_rand(HolyorganL), 0}];
        _ ->
            []
    end,
    MountKv ++ FlyKv ++ HolyorganKv.

%% 时装
get_fake_fashion_figure(Career, Rfashion) ->
    case lists:keyfind(Career, 1, Rfashion) of
        {_, RFashionList} when RFashionList =/= [] ->
            FashionId = urand:list_rand(RFashionList),
            [{1, FashionId, 0}];  %%1是衣服， 只是给衣服；颜色置0
        _ ->
            []
    end.

get_fake_info_for_client(SerId, SerNum, Figure, RoleId, Power, Picture) ->
    #figure{name= Name, sex = Sex, career = Career, picture_ver = PictureVer, turn = Turn} = Figure,
    FakeInfo = #{
        role_id => RoleId, role_name => Name, server_id => SerId, power => Power,
        career => Career, sex => Sex, pic => Picture,
        server_num => SerNum, pic_ver => PictureVer, turn => Turn
    },
    FakeInfo.

calc_wlv(SendBatList, SendServerInfo) ->
    Fun = fun(SerId, {AccSum, AccNum}) ->
        case lists:keyfind(SerId, 1, SendServerInfo) of
            {_, _, WorldLv, _, _} -> {AccSum+WorldLv, AccNum+1};
            _ -> {AccSum, AccNum}
        end
    end,
    {Sum, Num} = lists:foldl(Fun, {0,0}, SendBatList),
    erlang:round(Sum div max(Num, 1)).

apply_cast(SerId, M, F, A) ->
    case util:is_cls() of
        true ->
            mod_clusters_center:apply_cast(SerId, M, F, A);
        _ ->
            erlang:apply(M, F, A)
    end.

send_stage_time(RoleId, BattleState, BattleStartTime) ->
    send_stage_time(RoleId, BattleState, BattleStartTime, 0).

send_stage_time(RoleId, BattleState, BattleStartTime, Power) ->
    {ok, Bin} = pt_189:write(18906, [BattleState, BattleStartTime, Power]),
    lib_server_send:send_to_uid(RoleId, Bin).

do_after_terminate(RoleId, FakeSerId, AutoId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_sea_treasure, do_after_terminate, [FakeSerId, AutoId]);

do_after_terminate(Player, FakeSerId, AutoId) ->
    #player_status{
        id                    = RoleId,
        figure                = #figure{name = RName},
        server_id             = SerId
    } = Player,
    case FakeSerId =/= SerId of
        true -> %%
            mod_sea_treasure_kf:do_after_terminate(FakeSerId, AutoId, RoleId, RName);
        _ ->
            mod_sea_treasure_local:do_after_terminate(FakeSerId, AutoId, RoleId, RName)
    end.

calc_battle_result(RoleId, BGoldNum, Res, Args) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_sea_treasure, calc_battle_result, [BGoldNum, Res, Args]);

calc_battle_result(Player, BGoldNum, Res, BattleArgs) ->
    #player_status{
        id                    = RoleId,
        figure                = #figure{sex = _Sex, picture = Pic, picture_ver = PictureVer, name = RName},
        guild = #status_guild{id = GuildId, name = GuildName},
        combat_power          = Power,
        server_id             = SerId,
        server_num            = SerNum
    } = Player,
    #battle_field_args{
        be_help_id = BeHelperId, shipping_type = ShippingType,
        auto_id = AutoId, battle_type = BatType, role_hp_per = RHpPer,
        fake_guild = {FakeGuildId, FakeGuildName},
        quit_time = QuitTime, fake_info = Fake
    } = BattleArgs,
    #fake_info{
        ser_id = EnemySerId, hp_per = EnemyHpPer
    } = Fake,
    SeefGuild = {GuildId, GuildName},
    EnemyGuild = {FakeGuildId, FakeGuildName},
    RoleInfo = #role_info{
        ser_id = SerId, ser_num = SerNum, role_id = RoleId,
        role_name = RName, power = Power, pic = Pic, pic_ver = PictureVer, hp_per = RHpPer
    },
    send_stage_time(RoleId, 3, QuitTime),
    Arg = [Res, BGoldNum, BatType, ShippingType, AutoId, RHpPer, EnemyHpPer, RoleInfo, SeefGuild, Fake, EnemyGuild],
    case SerId =/= EnemySerId of
        true -> %%
            mod_sea_treasure_kf:do_after_battle(Arg, EnemySerId, SerId, RoleId, BeHelperId);
        _ ->
            mod_sea_treasure_local:do_after_battle(Arg, RoleId, BeHelperId)
    end.

get_rober_reward(ShippingType) ->
    case data_sea_treasure:get_reward_info(ShippingType) of
        #base_sea_treasure_reward{rob_reward = Reward} -> Reward;
        _ -> ?ERR("error miss cfg ShippingType:~p~n",[ShippingType]),[]
    end.

save_to_map(List, Map) ->
    Fun = fun
        ({Key, Log}, Acc) when is_record(Log, treasure_log) ->
            OldList = maps:get(Key, Acc, []),
            #treasure_log{auto_id = AutoId} = Log,
            NewList = lists:keystore(AutoId, #treasure_log.auto_id, OldList, Log),
            maps:put(Key, NewList, Acc);
        ({Key, Ship}, Acc) when is_record(Ship, shipping_info) ->
            OldList = maps:get(Key, Acc, []),
            #shipping_info{auto_id = AutoId} = Ship,
            NewList = lists:keystore(AutoId, #shipping_info.auto_id, OldList, Ship),
            maps:put(Key, NewList, Acc);
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, Map, List).

add_to_map(List, Map) ->
    Fun = fun
        ({Key, Log}, Acc) when is_record(Log, treasure_log) ->
            OldList = maps:get(Key, Acc, []),
            NewList = [Log|OldList],
            maps:put(Key, NewList, Acc);
        ({Key, Ship}, Acc) when is_record(Ship, shipping_info) ->
            OldList = maps:get(Key, Acc, []),
            NewList = [Ship|OldList],
            maps:put(Key, NewList, Acc);
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, Map, List).


%% 组装数据发送客户端
construct_list_data_to_client(List) ->
    construct_list_data_to_client(List, null, []).

construct_list_data_to_client(List, RId) ->
    construct_list_data_to_client(List, RId, []).

construct_list_data_to_client(List, RId, ReturnList) ->
    NowTime = utime:unixtime(),
    Fun = fun
        (Log, Acc) when is_record(Log, treasure_log) ->
            construct_list_data_core(Log, Acc);
        (Ship, Acc) when is_record(Ship, shipping_info) ->
            construct_list_data_core(Ship, RId, NowTime, Acc);
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, ReturnList, List).

construct_list_data_core(Log, Acc) ->
    #treasure_log{
        id = ShippingType, auto_id = AutoId, type = Type, time = Time,rober_serid = RoberSerId,
        rober_sernum = RoberSernum, rober_gid = RoberGuildId, rober_gname = RoberGuildName, rober_id = RoberId
        ,rober_name = RoberName, rober_power = RoberPower, reward = Reward, back_reward = BackReward,
        recieve_reward = RecvReward
    } = Log,
    [{AutoId, Type, RoberSerId, RoberSernum, RoberGuildId, RoberGuildName, RoberId,
        RoberName, RoberPower, ShippingType, Reward, BackReward, RecvReward, Time}|Acc].

construct_list_data_core(Ship, RId, NowTime, Acc) ->
    #shipping_info{
        id = ShippingType, auto_id = AutoId, ser_id = ServerId, ser_num = ServerNum
        ,guild_id = GuildId, guild_name = GuildName, role_id = RoleId, role_name = RoleName
        ,role_lv = RoleLv, power = Power, career = Career, sex = Sex, turn = Turn
        ,pic = Pic, pic_ver = PicVer, end_time = EndTime, rob_times = Robtimes
    } = Ship,
    LimitTime = ?cant_rob_before_end,
    if
        EndTime > (NowTime + LimitTime) orelse RId == RoleId ->
            [{AutoId, ShippingType, ServerId, ServerNum, GuildId, GuildName, RoleId, RoleName,
                RoleLv, Power, Career, Sex, Turn, Pic, PicVer, EndTime, Robtimes}
            |Acc];
        true ->
            Acc
    end.

%% 发送奖励
sea_treasure_reward(Player, ProduceType, Reward, NewBGoldNum) when Reward =/= [] ->
    Produce = #produce{type = ProduceType, reward = Reward, show_tips = ?SHOW_TIPS_0},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    case ProduceType == sea_treasure_reward of
        true ->
            {ok, LastPlayer} = lib_grow_welfare_api:receive_ship_reward(NewPlayer, 1);
        _ ->
            LastPlayer = NewPlayer
    end,
    %% 每日获取绑钻数量更新
    mod_daily:set_count_offline(Player#player_status.id, ?MOD_SEA_TREASURE, ?DAILY_BGOLD_NUM, NewBGoldNum),
    {ok, LastPlayer};
sea_treasure_reward(Player, _, _, _) -> {ok, Player}.

sea_treasure_reward(Player, ProduceType, Reward) when Reward =/= [] ->
    #player_status{id = RoleId, figure = #figure{vip = VipLv, vip_type = VipType}} = Player,
    Produce = #produce{type = ProduceType, reward = Reward, show_tips = ?SHOW_TIPS_0},
    if
        ProduceType == sea_rob_reward -> %% 掠夺计数器处理
            %% 掠夺日常
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_SEA_TREASURE, 2),
            mod_daily:increment(Player#player_status.id, ?MOD_SEA_TREASURE, ?DAILY_ROB_TIMES),
            RoberTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_ROB_TIMES),
            DayRobTimes = ?day_rob_reward_times,
            VipAddRobCount = lib_vip_api:get_vip_privilege(?MOD_SEA_TREASURE, ?VIP_SEA_TREASURE_ROB, VipType, VipLv),
            StrongPs = lib_to_be_strong:update_data_sea_treasure_gold(Player, DayRobTimes+VipAddRobCount - RoberTimes);
        true ->
            {ok, StrongPs} = lib_grow_welfare_api:receive_ship_reward(Player, 1)
    end,
    NewPlayer = lib_goods_api:send_reward(StrongPs, Produce),
    {ok, NewPlayer};
sea_treasure_reward(Player, _, _) -> {ok, Player}.

%% 依据前后扣除玩家血量百分比、当日获取绑钻数量计算奖励
calc_back_reward_by_hp(HpPer, OldHpPer, Reward, BGoldNum) ->
    List = ?back_reward_with_hp,
    SortList = lists:reverse(lists:keysort(1, List)),
    F = fun({TemHpPer, _}) ->
        HpPer >= TemHpPer
    end,
    case ulists:find(F, SortList) of
        {ok, {CfgHpPer, Value}} ->
            case lists:keyfind(OldHpPer, 1, List) of
                {OldHpPer, OldValue} -> skip;
                _ -> OldHpPer = 0, OldValue = 0
            end,
            if
                Value - OldValue =< 0->
                    {[], 0, [], 0};
                true ->
                    MaxBGoldNum = ?back_reward_max_bgold_num,
                    CanGetNum = MaxBGoldNum - BGoldNum,
                    GetReward = [{T, G, erlang:round(N*(Value-OldValue))} || {T, G, N} <- Reward],
                    Fun = fun
                        ({0, 35, N}, {Acc, TemBgNum}) ->
                            if
                                CanGetNum == 0 -> {Acc, TemBgNum};
                                N >= CanGetNum -> {[{0, 35, CanGetNum}|Acc], TemBgNum+CanGetNum};
                                true -> {[{0, 35, N}|Acc], TemBgNum+N}
                            end;
                        ({2, 0, N}, {Acc, TemBgNum}) ->
                            if
                                CanGetNum == 0 -> {Acc, TemBgNum};
                                N >= CanGetNum -> {[{0, 35, CanGetNum}|Acc], TemBgNum+CanGetNum};
                                true -> {[{0, 35, N}|Acc], TemBgNum+N}
                            end;
                        (Tem, {Acc, TemBgNum}) -> {[Tem|Acc], TemBgNum}
                    end,
                    {HelperGetReward, NewBGoldNum} = lists:foldl(Fun, {[], BGoldNum}, GetReward),
                    {GetReward, CfgHpPer, HelperGetReward, NewBGoldNum}
            end;
        _ -> {[], 0, [], 0}
    end.

%% 删除相应的战场进程id
notfied_delete_pid(BeHelperId, BatType, HelperId) when BatType == ?BATTLE_TYPE_RBACK ->
    case util:is_cls() of
        false ->
            mod_sea_treasure_local:delete_helper_pid(BeHelperId, HelperId);
        _ ->
            mod_sea_treasure_kf:delete_helper_pid(BeHelperId, HelperId)
    end;
notfied_delete_pid(_, _, _) -> ok.

%% 掠夺前检测
check_before_rober(Ship, RoberId) when is_record(Ship, shipping_info) ->
    #shipping_info{
        role_id = EnemyRoleId, rob_times = RobTimes,
        id = ShippingType, end_time = Endtime
    } = Ship,
    NowTime = utime:unixtime(),
    LimitTime = ?cant_rob_before_end,
    Cfg = data_sea_treasure:get_reward_info(ShippingType),
    if
        is_record(Cfg, base_sea_treasure_reward) == false ->
            {false, ?ERRCODE(err189_cfg_delete)};
        EnemyRoleId == RoberId ->
            {false, ?ERRCODE(err189_cant_rob_self)};
        RobTimes =/= 0 ->
            {false, ?ERRCODE(err189_has_be_robered)};
        NowTime + LimitTime >= Endtime ->
            {false, ?ERRCODE(err189_end_time_limit)};
        true ->
            true
    end;
check_before_rober(_, _) -> {false, ?ERRCODE(data_error)}.

check_before_rober(Log, FightId, RbackList) when is_record(Log, treasure_log) ->
    #treasure_log{
        id = ShippingType, type = Type, rober_id = RoberId,
        rober_hp = RoberHp, role_id = RoleId, rback_status = RBackStatus
    } = Log,
    Cfg = data_sea_treasure:get_reward_info(ShippingType),
    case lists:keyfind(FightId, 1, RbackList) of
        {_, HpPer} -> skip;
        _ -> HpPer = 0
    end,
    if
        is_record(Cfg, base_sea_treasure_reward) == false ->
            {false, ?ERRCODE(err189_cfg_delete)};
        Type =/= 1 ->
            {false, ?ERRCODE(err189_cant_rback_not_be_robed)};
        FightId =/= RoleId andalso HpPer > 0 ->
            {false, ?ERRCODE(err189_rback_get_reward)};
        % FightId == RoleId ->
        %     {false, ?ERRCODE(err189_cant_rob_self)};
        FightId == RoberId ->
            {false, ?ERRCODE(err189_cant_rback_self)};
        RoberHp == 100 ->
            {false, ?ERRCODE(err189_be_rob_back)};
        RBackStatus == ?RBACK_BATTLE ->
            {false, ?ERRCODE(err189_cant_rback_simo)};
        true ->
            true
    end;
check_before_rober(_, _, _) -> {false, ?ERRCODE(data_error)}.

%% 计算下次假人刷新时间
calc_robot_refresh_time(NowTime) ->
    TimeList = ?robot_refresh,
    {_D, {NH, NM, _}} = utime:unixtime_to_localtime(NowTime),
    case get_next_time(NH, NM, TimeList) of %%获取开启时间段中第一个boss刷新时间大于nowtime的时间
        {ok, {SH, SM}} ->
            TemStartT = standard_unixtime(NowTime, SH, SM),
            {true, TemStartT};
        _ -> %% 当天无可刷新时间 0点过后重新开启再次计算
            false
    end.

%% 计算某时间点的时间戳(夏令时)
standard_unixtime(Unixtime, Hour, Minute) ->
    UnixDate = utime:standard_unixdate(Unixtime),
    UnixDate + (Hour * 60 + Minute) * 60.%% 计算某点的时间

get_next_time(NH, NM, OpenList) ->
    Fun = fun({SH, SM}) ->
        (SH * 60 + SM) > (NH * 60 + NM)
    end,
    ulists:find(Fun, OpenList).

%% 计算假人刷新数量
calc_robot_num(TreasureMod) ->
    NumList = ?robot_num,
    case lists:keyfind(TreasureMod, 1, NumList) of
        {_, Num} -> Num;
        _ -> 0
    end.

%% 计算假人刷新数量
calc_robot_shipping_id() ->
    ShippingIdL = ?robot_shipping_id,
    case ShippingIdL of
        [{_, _}|_] -> urand:rand_with_weight(ShippingIdL);
        _ -> urand:list_rand(ShippingIdL)
    end.

do_handle_counter_start_ship(Player) ->
    #player_status{id = RoleId} = Player,
    mod_daily:increment_offline(RoleId, ?MOD_SEA_TREASURE, ?DAILY_TREASURE_TIMES),
    TreasureTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_TREASURE_TIMES),
    DayRewardTimes = ?day_reward_times,
    StrongPs = lib_to_be_strong:update_data_sea_treasure_exp(Player, DayRewardTimes - TreasureTimes),
    %% 巡航日常
    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_SEA_TREASURE, 1),
    {ok, SupremePs} = lib_supreme_vip_api:sea_treasure(StrongPs),
    mod_daily:set_count_offline(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE, 0),
    mod_daily:set_count_offline(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL, 1),
    {ok, SupremePs}.

send_msg_to_all(Bin) ->
    case data_sea_treasure:get_sea_treasure_value(open_lv) of
        LimitLv when is_integer(LimitLv) -> skip;
        _ -> LimitLv = 10
    end,
    lib_server_send:send_to_all(all_lv, {LimitLv, 9999}, Bin).

change_role_battle_pid(Player, Pid) ->
    mod_battle_field:stop(Player#player_status.sea_treasure_pid),
    {ok, Player#player_status{sea_treasure_pid = Pid}}.

rob_shipping_kf(Player, Pid, ProtocolArg) ->
    pp_sea_treasure:send_error(Player#player_status.id, ProtocolArg, 18905),
    {ok, Player#player_status{sea_treasure_pid = Pid}}.

rob_shipping_kf(Player, ProtocolArg) ->
    pp_sea_treasure:send_error(Player#player_status.id, ProtocolArg, 18905),
    NewPS = lib_guild_assist:cancel_sea_assist(Player),
    pp_sea_treasure:handle(18901, NewPS, []),
    pp_guild_assist:handle(40405, NewPS, []),
    NewPlayer = lib_player:break_action_lock(NewPS, ?ERRCODE(err189_on_sea_treasure_scene)),
    {ok, NewPlayer}.

usql_handle_delete(_, _, []) -> skip;
usql_handle_delete(Table, Con, DbList) when DbList =/= [] ->
    Sql1 = usql:delete(Table, {Con, in, DbList}),
    db:execute(Sql1).


construct_data_for_18907(Res, BatType, ShippingType, AutoId, RoberInfo, Enemy, BeHelperId, RoberReward) ->
    #fake_info{
        ser_id = EnemySerId, ser_num = EnemySerNum,
        role_id = EnemyId, role_name = EnemyName, turn = Turn,
        power = EnemyPower, sex = EnemySex, hp_per = EnemyHpPer,
        career = EnemyCareer, pic = EnemyPic, pic_ver = EnemyPicVer
    } = Enemy,
    #role_info{
        ser_id = SerId, ser_num = SerNum, role_id = RoleId,
        role_name = RName, power = Power, pic = Pic, pic_ver = PictureVer, hp_per = RHpPer
    } = RoberInfo,
    SelfInfo = [{SerNum, SerId, Pic, PictureVer, RoleId, RName, RHpPer, Power}],
    SendEnemy = [{EnemySerNum, EnemySerId, EnemySex, EnemyCareer, EnemyPic, EnemyPicVer, Turn, EnemyId, EnemyName, EnemyHpPer, EnemyPower}],
    [Res, BatType, ShippingType, AutoId, SelfInfo, SendEnemy, BeHelperId, RoberReward].


gm_clear_user() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_sea_treasure, gm_clear_user, []) || E <- OnlineRoles].

gm_clear_user(Player) ->
    #player_status{
        scene = Scene
    } = Player,
    NewPs = case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEA_TREASURE ->
            lib_scene:change_default_scene(Player,
                [{collect_checker, undefined},{change_scene_hp_lim, 100},{pk, {?PK_PEACE, true}}]);
        _ ->
            Player
    end,
    {ok, NewPs}.

%% ========== 开启进程进行数据清理 ===========
%% 本服根据日志时间戳清理本服以及其他服的数据
clear_data(state, [LogMap, RBackMap, BelogMap]) ->
    spawn(fun() ->
        timer:sleep(600 * 1000), %% 先延后10分钟

        %% ========== 清理 LogMap 和 RBackMap ==========
        ClearTime = utime:unixtime() - 7 * ?ONE_DAY_SECONDS, %% 清理7天前的数据
        F = fun(RoleId, TreasureLogL, {FLogMap, FRBckMap, FRemoveAutoIdL, OtherRemoveAutoIdL}) ->
            timer:sleep(2000), %% 处理完一个角色的记录，休眠一次
            F2 = fun(TreasureLog, {F2TreasureLogL, F2RBckMap, F2RemoveAutoIdL, FOtherRemoveMap}) ->
                if
                    is_record(TreasureLog, treasure_log) ->
                        #treasure_log{auto_id = AutoId, time = Time, rober_serid = RSerId} = TreasureLog,
                        case Time =< ClearTime of
                            true -> %% 该条记录过期了
                                NewF2RBckMap = maps:remove(AutoId, F2RBckMap),
                                FOtherRemoveL = maps:get(RSerId, FOtherRemoveMap, []),
                                NewFOtherRemoveL = [AutoId | FOtherRemoveL],
                                NewFOtherRemoveMap = maps:put(RSerId, NewFOtherRemoveL, FOtherRemoveMap),
                                {F2TreasureLogL, NewF2RBckMap, [AutoId | F2RemoveAutoIdL], NewFOtherRemoveMap};
                            _ ->
                                {[TreasureLog | F2TreasureLogL], F2RBckMap, F2RemoveAutoIdL, FOtherRemoveMap}
                        end;
                    true ->
                        {F2TreasureLogL, F2RBckMap, F2RemoveAutoIdL, FOtherRemoveMap}
                end
            end,
            {NewFTreasureLogL, NewFRBckMap, NewFRemoveAutoIdL, NewOtherRemoveAutoIdL} = lists:foldl(F2, {[], FRBckMap, FRemoveAutoIdL, OtherRemoveAutoIdL}, TreasureLogL),
            NewFLogMap = case NewFTreasureLogL =/= [] of
                true -> maps:put(RoleId, NewFTreasureLogL, FLogMap);
                _ -> maps:remove(RoleId, FLogMap)
            end,
            {NewFLogMap, NewFRBckMap, NewFRemoveAutoIdL, NewOtherRemoveAutoIdL}
        end,
        %% @param NewLogMap => 清理后的LogMap
        %% @param NewRBackMap => 清理后的RBackMap
        %% @param RemoveAutoIdL => 清理的AutoId列表[AutoId | ...]
        %% @param OtherRemoveMap => 其他服需要清理的AutoId map，#{RSerId => [AutoId | ...]}
        {NewLogMap, NewRBackMap, RemoveAutoIdL, OtherRemoveMap} = maps:fold(F, {LogMap, RBackMap, [], #{}}, LogMap),
        % ?INFO("RemoveAutoIdL:~p", [RemoveAutoIdL]),

        %% ========== 再清理BelogMap ==========
        F3 = fun(OtherSerId, OtherAutoIdL, F3BeLogMap) ->
            F3BelogList = maps:get(OtherSerId, F3BeLogMap, []),
            F4 = fun(Belog, F4BelogList) ->
                case Belog of
                    {BelogAutoId, _, _, _} ->
                        case lists:member(BelogAutoId, OtherAutoIdL) of
                            true ->
                                F4BelogList;
                            _ ->
                                [Belog | F4BelogList]
                        end;
                    _ ->
                        F4BelogList
                end
            end,
            NewBelogList = lists:foldl(F4, [], F3BelogList),
            timer:sleep(2000), %% 处理完一个列表，休眠一次
            maps:put(OtherSerId, NewBelogList, F3BeLogMap)
        end,
        NewBelogMap = maps:fold(F3, BelogMap, OtherRemoveMap),

        %% ========== 更新本服以及其他服数据 ==========
        lib_sea_treasure:usql_handle_delete(sea_treasure_rback, auto_id, RemoveAutoIdL),
        lib_sea_treasure:usql_handle_delete(sea_treasure_log, auto_id, RemoveAutoIdL),
        mod_sea_treasure_local:update_state(af_clear_state, [NewLogMap, NewRBackMap, NewBelogMap]),
        if
            RemoveAutoIdL =/= [] -> %% 同步协助列表
                mod_guild_assist:del_assist_by_target_list(?ASSIST_TYPE_3, RemoveAutoIdL);
            true ->
                skip
        end,
        SendF = fun({SendSerId, SendIdList}) ->
            case SendSerId =/= config:get_server_id() of
                true ->
                    spawn(fun() -> %% 要同步的服都开启一个进程来同步
                        mod_clusters_node:apply_cast(mod_sea_treasure_local, send_clear_data_to_kf, [SendSerId, 1, SendIdList])
                    end);
                _ ->
                skip
            end
        end,
        lists:foreach(SendF, maps:to_list(OtherRemoveMap))
    end);
clear_data(belog_list, [BelogList, ClearAutoIdList]) -> %% 清理过期的BelogList
    spawn(fun() ->
        F = fun
            ({AutoId, _, _, _} = Belog, {FBelogList, Count}) ->
                case Count rem 500 == 0 of
                    true -> %% 遍历500次，休眠一次
                        timer:sleep(100),
                        {FBelogList, Count + 1};
                    false ->
                        case lists:member(AutoId, ClearAutoIdList) of
                            true -> %% 需要清理，不放入
                                {FBelogList, Count + 1};
                            _ ->
                                {[Belog | FBelogList], Count + 1}
                        end
                end;
            (_, {FBelogList, Count}) -> {FBelogList, Count + 1}
        end,
        {NewBelogList, _} = lists:foldl(F, {[], 1}, BelogList),
        ?INFO("length(BelogList):~p", [length(BelogList)]),
        ?INFO("length(NewBelogList):~p", [length(NewBelogList)]),
        mod_sea_treasure_local:update_state(belog_list, [NewBelogList])
    end);
clear_data(_, _) ->
    skip.