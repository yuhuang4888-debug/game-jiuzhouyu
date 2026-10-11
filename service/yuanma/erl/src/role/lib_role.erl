%% ---------------------------------------------------------------------------
%% @deprecated 角色辅助信息
%% ---------------------------------------------------------------------------
-module(lib_role).
-export([]).

-compile(export_all).

-include("figure.hrl").
-include("role.hrl").
-include("title.hrl").
-include("predefine.hrl").
-include("partner.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("vip.hrl").
-include("common.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("team.hrl").

%% ----------------------------------------------------
%% #ets_role_show{}
%% ----------------------------------------------------

%% 登录##保证ets_role_show存在
login(#player_status{id = RoleId, combat_power = CombatPower, team = #status_team{team_id = _TeamId}, figure = Figure}) ->
    RoleShow = create_role_show(RoleId, Figure),
    ets:insert(?ETS_ROLE_SHOW, RoleShow),
    % 登录同步战力
    update_role_show(RoleId, [{combat_power, CombatPower}]),
    ok.

%% 当天首次登录记录战力
update_role_first_combat(#player_status{id = RoleId, combat_power = CombatPower, last_logout_time = LastLogoutTime}) ->
    NowTime = utime:unixtime(),
    case utime:is_same_day(NowTime, LastLogoutTime) of
        true -> get_role_first_combat(RoleId) == 0 andalso update_role_show(RoleId, [{f_combat_power, CombatPower}]); % 没相应值的时候也设置
        false -> update_role_show(RoleId, [{f_combat_power, CombatPower}])
    end,
    ok.

%% 获得玩家的展示
get_role_show(0) -> [];
get_role_show(Id) ->
    case ets:lookup(?ETS_ROLE_SHOW, Id) of
        [] ->
            SerId = config:get_server_id(),
            case mod_player_create:get_real_serid_by_id(Id) of
                SerId -> %% 非本服的玩家直接跳过
                    case get_figure_on_db(Id) of
                        [] -> [];
                        Figure ->
                            RoleShow = create_role_show(Id, Figure),
                            ets:insert(?ETS_ROLE_SHOW, RoleShow),
                            RoleShow
                    end;
                _ ->
                    []
            end;
        [RoleShow] ->
            RoleShow
    end.

create_role_show(RoleId, Figure) ->
    [OnlineFlag, LastLoginTime, LastLogoutTime, _LastLogoutCombatPower, HCombatPower] = get_role_show_other_info(RoleId),
    RealOnlineFlag = ?IF(OnlineFlag == ?ONLINE_ON, ?ONLINE_ON, ?ONLINE_OFF),
    DunDailyMap = get_dun_daily_map(RoleId),
    #ets_role_show{
        id = RoleId
        , figure = Figure
        , online_flag = RealOnlineFlag
        , last_login_time = LastLoginTime
        , last_logout_time = LastLogoutTime
        , combat_power = HCombatPower
        , h_combat_power = HCombatPower
        , dun_daily_map = DunDailyMap
    }.

%% 只从Ets表拿
get_role_show_ets(0) -> [];
get_role_show_ets(Id) ->
    case ets:lookup(?ETS_ROLE_SHOW, Id) of
        [] -> [];
        [RoleShow] ->
            RoleShow
    end.

get_role_name(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{figure = Figure} ->
            Figure#figure.name;
        _ -> <<>>
    end.

get_role_vip(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{figure = Figure} ->
            {Figure#figure.vip_type, Figure#figure.vip};
        _ -> {0, 0}
    end.

get_role_combat_power(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{combat_power = CombatPower, h_combat_power = HCombatPower} ->
            case CombatPower > 0 of
                true -> CombatPower;
                false -> HCombatPower
            end;
        _ -> 0
    end.

get_role_hcombat_power(RoleId) ->
    case get_role_show_ets(RoleId) of
        #ets_role_show{combat_power = CombatPower, h_combat_power = HCombatPower} ->
            case HCombatPower > 0 of
                true -> HCombatPower;
                false -> CombatPower
            end;
        _ ->
            Sql = io_lib:format(<<"select hightest_combat_power from player_high where id = ~p">>, [RoleId]),
            case db:get_row(Sql) of
                [HCombatPower] -> HCombatPower;
                _ -> 0
            end
    end.

get_role_figure(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{figure = Figure} -> Figure;
        _ -> #figure{}
    end.

%% 获取玩家离线时间戳
get_role_offline_timestamp(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{last_logout_time = LastLogoutTime} -> skip;
        _ -> LastLogoutTime = 0
    end,
    LastLogoutTime.

%% 获取玩家离线时间
get_role_offline_time(RoleId) ->
    NowTime = utime:unixtime(),
    LastLogoutTime = get_role_offline_timestamp(RoleId),
    NowTime - LastLogoutTime.

%% 获取玩家在线状态
get_role_online_flag(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{online_flag = OnlineFlag} -> OnlineFlag;
        _ -> []
    end.

%% 获取玩家当天首次登录战力
get_role_first_combat(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{f_combat_power = FCombatPower} -> FCombatPower;
        _ -> 0
    end.

%% 判断玩家是否真实在线
is_role_real_online(RoleId) ->
    case get_role_show(RoleId) of
        #ets_role_show{online_flag = OnlineFlag} -> OnlineFlag == ?ONLINE_ON;
        _ -> false
    end.

%% 更新玩家展示Ets
update_role_show(Id, KeyList) ->
    mod_role_show:update(Id, KeyList).

%% 在进程中处理
update_role_show_help(Id, KeyList) ->
    case ets:lookup(?ETS_ROLE_SHOW, Id) of
        [] -> skip;
        [RoleShow] ->
            NewRoleShow = do_update_role_show(KeyList, RoleShow),
            ets:insert(?ETS_ROLE_SHOW, NewRoleShow)
    end.

do_update_role_show([], RoleShow) -> RoleShow;
do_update_role_show([T | L], RoleShow) ->
    #ets_role_show{figure = Figure, dun_daily_map = DunDailyMap} = RoleShow,
    case T of
        {figure, NewFigure} -> NewRoleShow = RoleShow#ets_role_show{figure = NewFigure};
        {guild_id, GuildId} -> NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{guild_id = GuildId}};
        {guild_name, GuildName} -> NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{guild_name = GuildName}};
        {position, Position} -> NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{position = Position}};
        {position_name, PositionName} ->
            NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{position_name = PositionName}};
        {combat_power, CombatPower} ->
            NewRoleShow = RoleShow#ets_role_show{combat_power = CombatPower};
        {f_combat_power, FCombatPower} ->
            NewRoleShow = RoleShow#ets_role_show{f_combat_power = FCombatPower};
        {h_combat_power, HCombatPower} ->
            NewRoleShow = RoleShow#ets_role_show{h_combat_power = HCombatPower};
        {last_logout_time, LastLogoutTime} ->
            NewRoleShow = RoleShow#ets_role_show{last_logout_time = LastLogoutTime};
        {last_login_time, LastLoginTime} ->
            NewRoleShow = RoleShow#ets_role_show{last_login_time = LastLoginTime};
        {online_flag, OnlineFlag} ->
            NewRoleShow = RoleShow#ets_role_show{online_flag = OnlineFlag};
        {lb_pet_figure, FigureId} ->
            NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{lb_pet_figure = FigureId}};
        {lb_mount_figure, FigureId} ->
            NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{lb_mount_figure = FigureId}};
        {house, HomeId, HouseLv} ->
            NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{home_id = HomeId, house_lv = HouseLv}};
        {mount_figure, MountFigure} ->
            NewRoleShow = RoleShow#ets_role_show{figure = Figure#figure{mount_figure = MountFigure}};
        {clear_marriage, _} ->
            NewFigure = Figure#figure{marriage_type = 0, lover_role_id = 0, lover_name = ""},
            NewRoleShow = RoleShow#ets_role_show{figure = NewFigure};
        {dress_list, DressList} ->
            NewFigure = Figure#figure{dress_list = DressList},
            NewRoleShow = RoleShow#ets_role_show{figure = NewFigure};
        {daily_dun, Key, Value} ->
            % ?MYLOG("hjhetsroleshow", "do_update_role_show RoleId:~p Key:~p Value:~p",
            %     [RoleShow#ets_role_show.id, Key, Value]),
            NewDunDailyMap = maps:put(Key, Value, DunDailyMap),
            NewRoleShow = RoleShow#ets_role_show{dun_daily_map = NewDunDailyMap};
        {team_flag, {_OrderTeamId, _TeamPosition, TeamId}} ->
            % ?MYLOG("hjhetsroleshowteam", "do_update_role_show team_flag RoleId:~pTeamId:~p",
            %     [RoleShow#ets_role_show.id, TeamId]),
            NewRoleShow = RoleShow#ets_role_show{team_id = TeamId};
        {team_id, TeamId} ->
            % ?MYLOG("hjhetsroleshowteam", "do_update_role_show RoleId:~pTeamId:~p",
            %     [RoleShow#ets_role_show.id, TeamId]),
            NewRoleShow = RoleShow#ets_role_show{team_id = TeamId};
        {team_3v3_id, TeamId} ->
            ?MYLOG("hjhetsroleshowteam", "do_update_role_show RoleId:~pTeamId:~p",
                 [RoleShow#ets_role_show.id, TeamId]),
            NewRoleShow = RoleShow#ets_role_show{team_3v3_id = TeamId};
        {login_team_id, TeamId} ->
            NewRoleShow = RoleShow#ets_role_show{team_id = TeamId};
        {demons_id, DemonsId} ->
            NewFigure = Figure#figure{demons_id = DemonsId},
            NewRoleShow = RoleShow#ets_role_show{figure = NewFigure};
        {mask_id, MaskId} ->
            NewFigure = Figure#figure{mask_id = MaskId},
            NewRoleShow = RoleShow#ets_role_show{figure = NewFigure};
        {camp, Camp} ->
            NewFigure = Figure#figure{camp = Camp},
            NewRoleShow = RoleShow#ets_role_show{figure = NewFigure};
        _ -> NewRoleShow = RoleShow
    end,
    do_update_role_show(L, NewRoleShow).

%% 获得figure
get_figure_on_db(Id) ->
    % TODO:优化sql
    case lib_player:get_player_login_data(Id) of
        [GM | _] ->
            [NickName, Sex, Lv, Career, Realm, Picture, _PictureLim, PictureVer | _] = lib_player:get_player_low_data(Id),
            #reincarnation{turn = Turn, turn_stage = TurnStage} = lib_reincarnation:login(Id, Career, Sex),
            LvModel = lib_goods_util:get_lv_model(Id, Career, Sex, Turn, Lv),
            NewFashionModel = lib_fashion:get_equip_fashion_list(Id, Career, Sex),
            StatusGuild = lib_guild:load_status_guild(Id),
            RoleVip = lib_vip:login(Id),
            DsgtId = lib_designation:get_designation(Id),
            JueWeiLv = lib_juewei:get_juewei_id_db(Id),
            WingFigureId = lib_wing:get_db_wing_figure(Id),
            TalismanFigureId = lib_talisman:get_db_talisman_figure(Id),
            GodEquipModel = lib_godweapon:get_db_god_equip_model(Id),
            LivenessModel = lib_dragon_ball_data:get_dragon_figure_id_db(Id),
            LBPetFigureId = lib_pet:get_stage_figure_id_from_db(Id),
%%            LBMountFigureId = lib_mount:get_stage_figure_id_from_db(Id,1),
            {BlockId, HouseId, _ServerId, HouseLv} = lib_house:get_player_house_info_db(Id),
            {MarriageType, LoverRoleId, LoverName} = lib_marriage:get_lover_info_db(Id),
            DressList = lib_dress_up:get_dress_list_from_db(Id),
            DemonsId = lib_demons:get_battle_demons_id(Id),
            IsSupvip = lib_supreme_vip_api:is_supvip_from_db(Id),
            RevelationSuit = lib_revelation_equip:get_figure(Id, Sex),
            MountFigureTmp = lib_mount:get_figure_list(Id, Career),
            BackDecoraFigure = lib_back_decoration:get_figure(Id),
            CompanionFigure = lib_companion:load_mount_figure(Id),
            MountFigure = lib_temple_awaken:get_figure_list(Id, Career, MountFigureTmp ++ BackDecoraFigure ++ CompanionFigure),
            {_, EquipTitle, _} =lib_title:get_title_info_on_db(Id),
            MaskId = lib_mask_role:get_mask_on_db(Id),
            MagicCircleId = lib_magic_circle:get_figure_on_db(Id),
            #figure{name = NickName, sex = Sex, lv = Lv,
                career = Career, realm = Realm, gm = GM, vip = RoleVip#role_vip.vip_lv, vip_type = RoleVip#role_vip.vip_type,
                lv_model = LvModel, fashion_model = NewFashionModel, vip_hide =  RoleVip#role_vip.vip_hide,
                picture = Picture, picture_ver = PictureVer,
                guild_id = StatusGuild#status_guild.id,
                guild_name = StatusGuild#status_guild.name,
                position = StatusGuild#status_guild.position,
                position_name = StatusGuild#status_guild.position_name,
                designation = DsgtId,
                juewei_lv = JueWeiLv,
                turn = Turn,
                turn_stage = TurnStage,
                wing_figure = WingFigureId,
                liveness = LivenessModel,
                fairy_figure = TalismanFigureId,
                god_equip_model = GodEquipModel,
                lb_pet_figure = LBPetFigureId,
%%                    lb_mount_figure = LBMountFigureId,
                home_id = {BlockId, HouseId},
                house_lv = HouseLv,
                marriage_type = MarriageType,
                lover_role_id = LoverRoleId,
                lover_name = LoverName,
                achiv_stage = lib_achievement_api:get_cur_stage_on_db(Id),
                mount_figure = MountFigure,
                medal_id = lib_medal:get_medal_offline(Id),
                dress_list = DressList,
                demons_id = DemonsId,
                is_supvip = IsSupvip,
                revelation_suit = RevelationSuit,
                title_id = EquipTitle,
                mask_id = MaskId,
                magic_circle_figure = MagicCircleId,
                camp = StatusGuild#status_guild.realm
            };
        [] ->
            []
    end.

%% 获得基础的base(只有头像基础信息,去掉多余的sql)
get_base_figure_on_db(Id) ->
    case lib_player:get_player_login_data(Id) of
        [GM | _] ->
            [NickName, Sex, Lv, Career, Realm, Picture, _PictureLim, PictureVer | _] = lib_player:get_player_low_data(Id),
            RoleVip = lib_vip:login(Id),
            #figure{name = NickName, sex = Sex, lv = Lv, career = Career, realm = Realm, gm = GM,
                vip = RoleVip#role_vip.vip_lv, vip_type = RoleVip#role_vip.vip_type,
                picture = Picture, picture_ver = PictureVer};
        [] ->
            []
    end.

%% 获取展示的其他信息
%% @param [OnlineFlag, LastLoginTime, HCombatPower]
get_role_show_other_info(RoleId) ->
    Sql = io_lib:format(?sql_role_show_other_info, [RoleId]),
    db:get_row(Sql).

%% 获取最后退出游戏时候玩家战力
get_role_last_logout_power(RoleId) ->
    Sql = io_lib:format(?sql_role_last_logout_power, [RoleId]),
    db:get_row(Sql).

%% 获得副本日常
get_dun_daily_map(RoleId) ->
    EquipCountType = lib_dungeon_api:get_daily_count_type(?DUNGEON_TYPE_EQUIP, 0),
    {EquipCount, _Other} = lib_daily:get_count_and_other_from_db(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, EquipCountType),
    #{EquipCountType=>EquipCount}.

%% 数据库组装显示数据
trans_figure_to_list(_Figure, _TransType) ->
    [].

%% 从FigureList转到#figure
%% @param FigureList [{Key, Value}]
trans_figure_from_list(FigureList, Figure, _TransType) ->
    update_figure(FigureList, Figure).

update_figure([], Figure) -> Figure;
update_figure([H|T], Figure) ->
    case H of
        {career, Career} -> NewFigure = Figure#figure{career = Career};
        {sex, Sex} -> NewFigure = Figure#figure{sex = Sex};
        {vip, VipLv} -> NewFigure = Figure#figure{vip = VipLv};
        {vip_type, VipType} -> NewFigure = Figure#figure{vip_type = VipType};
        {lv, Lv} -> NewFigure = Figure#figure{lv = Lv};
        _ -> NewFigure = Figure
    end,
    update_figure(T, NewFigure).

%% 秘籍：重新加载所有ets_role_show的指定项（含离线）
gm_update_role_show(Type) ->
    RoleShowList = ets:tab2list(?ETS_ROLE_SHOW),
    RoleIdList = [RoleId || #ets_role_show{id = RoleId} <- RoleShowList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_role, update_single_role_show, [list_to_atom(Type)]) || RoleId <- RoleIdList].

%% 重新加载单个玩家ets_role_show的指定项
update_single_role_show(PS, Type) ->
    RoleId = PS#player_status.id,
    Target =
        case Type of
            figure ->
                PS#player_status.figure;
            _ ->
                skip
        end,
    ?IF(Target =:= skip, skip, update_role_show(RoleId, [{Type, Target}])).
