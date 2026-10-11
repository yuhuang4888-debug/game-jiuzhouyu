%%%-----------------------------------
%%% @Module  : lib_kf_1vN
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN 通用库函数
%%%-----------------------------------
-module(lib_kf_1vN).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("kf_1vN.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("goods.hrl").
-include("def_module.hrl").

-export([
        login/1,
        player_die/1,
        trans_enter_info/1,
        logout/1,
        check_def_shop/2,
        check_challenger_shop/1,
        update_player_1vn/3,
        set_player_1vn/3,
        clean_1vn/0,
        db_save_sign/1,
        db_clean_sign/0,
        get_last_sign_list/0,
        db_save_last_sign/1,
        db_clean_last_sign/0,
        get_bet_map/0,
        db_save_bet/1,
        db_clean_bet/0,
        clear_exchange_counter/0,
        get_sign_list/0,
        handle_event/2,
        auction_lose/3,
        return_auction_cost/2,
        auction_success/3,
        gm_clear_user/0,
        gm_open_lock/0,
        gm_fake_join_1vn/1
    ]).
-export([
        dummy_die/5,
        trans_to_pk_role/2,
        trans_to_pk_role/1,
        trans_to_pk_robot/2,
        trans_to_bet/7,
        send_all_enter/2,
        pre_scene_xy/0,
        create_robot_pk/6,
        quit_to_main_scene/2,
        db_get_def_rank/0,
        db_save_def_rank/2,
        clean_def_rank/0,
        db_get_kf_1vn_score_rank/0,
        db_save_kf_1vn_score_rank/2,
        clean_kf_1vn_score_rank/0,
        get_sign_list_center/0,
        db_save_sign_center/8,
        db_clean_sign_center/0
    ]).


login(Id) ->
    case db:get_row(io_lib:format(<<"select def_type, turn from player_1vn where id=~w limit 1">>, [Id])) of
        [DefType, Turn] -> #status_kf1vn{def_type=DefType, turn=Turn};
        _ -> #status_kf1vn{}
    end.

%% 本服调用
gm_clear_user() ->
    mod_clusters_node:apply_cast(mod_kf_1vN, gm_clear_user, []).

%% 本服调用
gm_open_lock() ->
    mod_clusters_node:apply_cast(mod_kf_1vN, gm_open_lock, []).

trans_enter_info(PS) ->
    #player_status{
        id=Id, server_id=ServerId, platform=Platform, server_num=ServerNum, figure=Figure,
        battle_attr=#battle_attr{attr=Attr}, hightest_combat_power = HCombatPower, combat_power = CombatPower, server_name = ServerName
        } = PS,
    #kf_1vN_role{
        id=Id, server_id=ServerId, platform=Platform, server_num=ServerNum, figure=Figure, attr=Attr,
        combat_power=HCombatPower, n_combat_power = CombatPower, server_name = ServerName
        }.

player_die(Status) ->
    case is_pid(Status#player_status.copy_id) andalso is_in_1vN_pk(Status#player_status.scene) of
        true ->
            mod_clusters_node:apply_cast(erlang, send, [Status#player_status.copy_id, {player_die, Status#player_status.id}]);
        false -> skip
    end.

is_in_1vN_pk(SceneId) ->
    PkScenes = data_kf_1vN_m:get_config(pk_scenes),
    lists:member(SceneId, PkScenes).

is_in_1vN(SceneId) ->
    PkScenes = data_kf_1vN_m:get_config(scenes),
    lists:member(SceneId, PkScenes).

logout(PS) ->
    case is_in_1vN(PS#player_status.scene) of
        true  -> mod_kf_1vN_local:quit(PS#player_status.id, PS#player_status.copy_id, 0, PS#player_status.battle_attr#battle_attr.hp, PS#player_status.battle_attr#battle_attr.hp_lim);
        false -> skip
    end.

check_def_shop(Status, BuyTurn) ->
    #player_status{kf_1vn=#status_kf1vn{def_type=DefType, turn=Turn}} = Status,
    if
        DefType /= 1 -> false;
        BuyTurn > Turn -> false;
        true -> true
    end.

check_challenger_shop(Status) ->
    #player_status{kf_1vn=#status_kf1vn{def_type=DefType}} = Status,
    if
        DefType == 1 orelse DefType == 2 -> true;
        true -> false
    end.

update_player_1vn(Id, DefType, Turn) ->
    db:execute(io_lib:format(<<"replace into player_1vn set id=~w, def_type=~w, turn=~w">>, [Id, DefType, Turn])),
%%    ?PRINT("1VN ~w~n", [{Id, DefType, Turn}]),
    lib_player:update_player_info(Id, [{kf_1vn, {DefType, Turn}}]),
    ok.

set_player_1vn(Status, DefType, Turn) ->
    Status#player_status{kf_1vn=#status_kf1vn{def_type=DefType, turn=Turn}}.

clean_1vn() ->
    db:execute("truncate player_1vn"),
    lib_player:update_all_player([{kf_1vn, {0, 0}}]),
    ok.

get_sign_list() ->
    L = db:get_all(<<"select id from kf_1vn_sign ">>),
    F = fun([Id]) ->
            {Id, 0}
    end,
    lists:map(F, L).

db_save_sign(Id) ->
    db:execute(io_lib:format(<<"replace into kf_1vn_sign set id=~w, time=~w">>, [Id, utime:unixtime()])).

db_clean_sign() ->
    db:execute(<<"truncate kf_1vn_sign">>).

get_last_sign_list() ->
    L = db:get_all(<<"select id from kf_1vn_last_sign ">>),
    F = fun([Id]) ->
            {Id, 0}
    end,
    lists:map(F, L).

db_save_last_sign([]) -> ok;
db_save_last_sign(SignList) ->
    ValueSql = db_save_last_sign_sql(SignList, utime:unixtime(), "", 1),
    Sql = "replace into kf_1vn_last_sign (id, area, time) values " ++ ValueSql,
    db:execute(Sql),
    ok.

db_save_last_sign_sql([], _Time, TmpSql, _Index) -> TmpSql;
db_save_last_sign_sql([{Id, Area}|T], Time, TmpSql, Index) ->
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, ~w) ", [Id, Area, Time]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, ~w), ", [Id, Area, Time]) ++ TmpSql
    end,
    db_save_last_sign_sql(T, Area, TmpSql1, Index+1).

db_clean_last_sign() ->
    db:execute(<<"truncate kf_1vn_last_sign">>).

get_bet_map() ->
    L = db:get_all(<<"SELECT battle_id, bet_time, role_id, race_2_turn, platform, server_num, name, battle_result, bet_cost_type, bet_opt_no, bet_result, status FROM kf_1vn_bet">>),
    F = fun([BattleId, BetTime, RoleId, Turn, Platform, ServerNum, Name, BattleResult, BetCostType, BetOptNo, BetResult, Status], BetM) ->
        <<Key:48>> = <<BattleId:16, BetTime:32>>,
        Bet = #kf_1vN_bet{key=Key, battle_id=BattleId, bet_time=BetTime, role_id=RoleId, race_2_turn=Turn, platform=Platform, server_num=ServerNum, name=Name, battle_result=BattleResult,
            bet_cost_type=BetCostType, bet_opt_no=BetOptNo, bet_result=BetResult, status=Status},
        BetL = maps:get(RoleId, BetM, []),
        maps:put(RoleId, [Bet|BetL], BetM)
    end,
    BetM = lists:foldl(F, #{}, L),
    BetLen = data_kf_1vN_m:get_config(bet_len),
    F2 = fun(RoleId, BetL) ->
        {SortNoList, SortHadGetL, SortNotGetL} = sort_bet_list(BetL),
        case length(SortNotGetL) > BetLen of
            true ->
                DelKeyL = [Key||#kf_1vN_bet{key=Key}<-SortHadGetL],
                db_delete_bet(RoleId, DelKeyL),
                SortNotGetL++SortNoList;
            false ->
                List = SortNotGetL++SortHadGetL,
                case length(List) =< BetLen of
                    true -> SortNotGetL++SortHadGetL++SortNoList;
                    false ->
                        NewList = lists:sublist(List, BetLen),
                        DelKeyL = [Key||#kf_1vN_bet{key=Key}<-lists:nthtail(BetLen, List)],
                        db_delete_bet(RoleId, DelKeyL),
                        NewList++SortNoList
                end
        end
    end,
    maps:map(F2, BetM).

sort_bet_list(BetL) ->
    F = fun(#kf_1vN_bet{status = Status}=T, {NoList, HadGetL, NotGetL}) ->
        if
            Status==?KF_1VN_BET_STATUS_NO -> {[T|NoList], HadGetL, NotGetL};
            Status==?KF_1VN_BET_STATUS_HAD_GET -> {NoList, [T|HadGetL], NotGetL};
            true -> {NoList, HadGetL, [T|NotGetL]}
        end
    end,
    {NoList, HadGetL, NotGetL} = lists:foldl(F, {[], [], []}, BetL),
    F2 = fun(#kf_1vN_bet{bet_time=BetTimeA, race_2_turn=TurnA}, #kf_1vN_bet{bet_time=BetTimeB, race_2_turn=TurnB}) ->
        if
            BetTimeA == BetTimeB -> TurnA > TurnB;
            true -> BetTimeA > BetTimeB
        end
    end,
    SortNoList = lists:sort(F2, NoList),
    SortHadGetL = lists:sort(F2, HadGetL),
    SortNotGetL = lists:sort(F2, NotGetL),
    {SortNoList, SortHadGetL, SortNotGetL}.

db_delete_bet(_RoleId, []) -> ok;
db_delete_bet(RoleId, DelKeyL) ->
    F = fun(Key, String) ->
        case String of
            "" -> io_lib:format("~w", [Key]);
            _ -> io_lib:format("~ts, ~w", [String, Key])
        end
    end,
    DelStr = lists:foldl(F, "", DelKeyL),
    SQL = io_lib:format(<<"DELETE FROM kf_1vn_bet WHERE role_id=~w and key in (~ts)">>, [RoleId, DelStr]),
    db:execute(SQL).

db_save_bet(Bet) ->
    #kf_1vN_bet{
        battle_id=BattleId, bet_time=BetTime, role_id=RoleId, race_2_turn=Turn, platform=Platform, server_num=ServerNum, name=Name,
        battle_result=BattleResult, bet_cost_type=BetCostType, bet_opt_no=BetOptNo, bet_result=BetResult, status=Status
        } = Bet,
    db:execute(io_lib:format(<<"replace into kf_1vn_bet(battle_id, bet_time, role_id, race_2_turn, platform, server_num, name, battle_result, bet_cost_type, bet_opt_no, bet_result, status) VALUES(~w, ~w, ~w, ~w, '~s', ~w, '~s', ~w, ~w, ~w, ~w, ~w)">>,
        [BattleId, BetTime, RoleId, Turn, Platform, ServerNum, Name, BattleResult, BetCostType, BetOptNo, BetResult, Status])).

db_clean_bet() ->
    db:execute(<<"truncate kf_1vn_bet">>).

%% 清理兑换日常
clear_exchange_counter() ->
    Ids = data_exchange:get_ids(?EXCHANGE_TYPE_KF_1VN),
    lib_counter:db_clear(?MOD_GOODS, ?MOD_GOODS_EXCHANGE, Ids),
    util:cast_event_to_players({'clear_exchange_counter'}),
    ok.


%% ==================== 跨服中心调用 =====================================================

%% 加人死亡 (Object1, [], Atter, AtterSign, Args)
dummy_die(#scene_object{scene = SceneId, id = Id, copy_id = CopyId}, _, _, _, _) ->
%%    ?PRINT("dummy_die ~p~n", [Id]),
    case is_pid(CopyId) andalso is_in_1vN_pk(SceneId) of
        true ->
            CopyId ! {dummy_die, Id};
%%            mod_clusters_node:apply_cast(erlang, send, [CopyId, {dummy_die, Id}]);
        false -> skip
    end.

%% 发送给参赛者
send_all_enter([#kf_1vN_role{server_id=SerId, id=Id, enter=1}|T], BinData) ->
    mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]),
    send_all_enter(T, BinData);
send_all_enter([_|T], BinData) ->  send_all_enter(T, BinData);
send_all_enter(_, _) -> skip.

create_robot_pk(Hard, Attr, Area, RobotId, DefRole, SerInfoList) ->
    % Career = ?KNIGHT, %% urand:rand(?SWORDSMAN, ?KNIGHT),
    {Career, Sex} = lib_career:rand_career_and_sex(),
    #kf_1vN_role{platform=Platform0, server_num=ServerNum0, server_name=ServerName0} = DefRole,
    case lists:delete({Platform0, ServerNum0, ServerName0}, SerInfoList) of
        [] -> Platform = Platform0, ServerNum = urand:rand(1, max(ServerNum0-1, 1)), ServerName = ServerName0;
        NSerInfoList -> {Platform, ServerNum, ServerName} = urand:list_rand(NSerInfoList)
    end,
    % RobotSerNum = urand:rand(1, ServerNum),
    FirstName = urand:list_rand(data_role_name:first_name_list(Sex)),
    LastName = urand:list_rand(data_role_name:last_name_list(Sex)),
    Name = util:make_sure_binary(FirstName ++ LastName),
    #kf_1vN_group{robot_args=RobotArgs} = data_kf_1vN:get_group(Hard),
    RobotRatio = RobotArgs/100,
    #attr{hp=Hp, att=Att, def=Def, hit=Hit, dodge=Dodge, crit=Crit, ten=Ten, wreck=Wreck %% resist=Resist,
        %% crit_add_num=CirtAddNum, crit_del_num=CritDelNum,
        %% hurt_add_num=HurtAddNum, hurt_del_num=HurtDelNum, demon_suck_blood = DemonSuckBlood
        } = Attr,
    RobotAttr = #attr{hp=round(Hp*RobotRatio), att=round(Att*RobotRatio), def=round(Def*RobotRatio), hit=round(Hit*RobotRatio),
        dodge=round(Dodge*RobotRatio), crit=round(Crit*RobotRatio), ten=round(Ten*RobotRatio), wreck=round(Wreck*RobotRatio)
        %% resist=round(Resist*RobotRatio),
        %% crit_add_num=round(CirtAddNum*RobotRatio), crit_del_num=round(CritDelNum*RobotRatio),
        %% hurt_add_num=round(HurtAddNum*RobotRatio), hurt_del_num=round(HurtDelNum*RobotRatio),
        %% demon_suck_blood =round(DemonSuckBlood*RobotRatio)
    },

    RobotCombatPower = round(lib_player:calc_all_power(RobotAttr)*(1+urand:rand(-20, 20)/1000)),
    % Sex = urand:rand(?MALE, ?FEMALE),
    Turn = 3,
    #kf_1vN_role_pk{
        type=?KF_1VN_C_TYPE_ROBOT, id=RobotId, platform=Platform, server_num=ServerNum, server_name=ServerName, area=Area, name=Name, hard=Hard, career=Career,
        attr=RobotAttr, combat_power=RobotCombatPower, n_combat_power=RobotCombatPower,sex = Sex, turn = Turn
        }.

trans_to_pk_role(#kf_1vN_role_pk{type=?KF_1VN_C_TYPE_ROBOT}=H, _Area) ->
    H;
trans_to_pk_role(
        #kf_1vN_role{id=Id, server_id=ServerId, platform=Platform, server_num=ServerNum, score=Score,
            figure=#figure{name=Name, career=Career, sex=Sex, turn=Turn, lv=Lv, picture=Picture, picture_ver=PictureVer},
            win=Win, win_streak=WinStreak, lose_streak=LoseStreak, race_1_times=Race1Times, combat_power=CombatPower, n_combat_power = NCP, server_name = ServerName, scene_pool_id = PoolId}, Area) ->
    #kf_1vN_role_pk{type=?KF_1VN_C_TYPE_PLAYER, id=Id, server_id=ServerId, platform=Platform, server_num=ServerNum, career=Career, name=Name, area=Area, score=Score,
        win=Win, win_streak=WinStreak, lose_streak=LoseStreak, race_1_times=Race1Times, combat_power=CombatPower, n_combat_power = NCP, server_name = ServerName, sex = Sex, turn = Turn, lv=Lv, scene_pool_id = PoolId,
        picture=Picture, picture_ver=PictureVer}.

trans_to_pk_role(#kf_1vN_role{area = Area} = Player) ->
trans_to_pk_role(Player, Area);
trans_to_pk_role(Player) when is_record(Player, kf_1vN_role_pk) -> Player.

trans_to_pk_robot(#kf_1vN_role{id=Id, platform=Platform0, server_num=ServerNum0, server_name=ServerName0, combat_power=CombatPower, attr = Attr, area = Area, win_streak=WinStreak, lose_streak=LoseStreak}, SerInfoList) ->
    case lists:delete({Platform0, ServerNum0, ServerName0}, SerInfoList) of
        [] -> Platform = Platform0, ServerNum = urand:rand(1, max(ServerNum0-1, 1)), ServerName = ServerName0;
        NSerInfoList -> {Platform, ServerNum, ServerName} = urand:list_rand(NSerInfoList)
    end,
    RobotId = Id band 16#FFFFFFFF,
    {Career, Sex} = lib_career:rand_career_and_sex(),
    #attr{hp=Hp,  att=Att, def=Def, hit=Hit, dodge=Dodge, crit=Crit, ten=Ten, wreck=Wreck %% resist=Resist,
        %% crit_add_num=CirtAddNum, crit_del_num=CritDelNum,
        %% hurt_add_num=HurtAddNum, hurt_del_num=HurtDelNum, demon_suck_blood = DemonSuckBlood
    } = Attr,
    RobotRatio = 0.92,
    RobotCombatPower = round(CombatPower*RobotRatio),%round(CombatPower*(1+urand:rand(5, 20)/1000)),
    RobotAttr = #attr{hp=round(Hp*RobotRatio), att=round(Att*RobotRatio), def=round(Def*RobotRatio), hit=round(Hit*RobotRatio),
        dodge=round(Dodge*RobotRatio), crit=round(Crit*RobotRatio), ten=round(Ten*RobotRatio), wreck=round(Wreck*RobotRatio)
        %% resist=round(Resist*RobotRatio),
        %% crit_add_num=round(CirtAddNum*RobotRatio), crit_del_num=round(CritDelNum*RobotRatio),
        %% hurt_add_num=round(HurtAddNum*RobotRatio), hurt_del_num=round(HurtDelNum*RobotRatio),
        %% demon_suck_blood =round(DemonSuckBlood*RobotRatio)
    },
    FirstName = urand:list_rand(data_role_name:first_name_list(Sex)),
    LastName = urand:list_rand(data_role_name:last_name_list(Sex)),
    Name = util:make_sure_binary(FirstName ++ LastName),
    % Sex = urand:rand(?MALE, ?FEMALE),
    Turn = 3,
    #kf_1vN_role_pk{type=?KF_1VN_C_TYPE_ROBOT, id=RobotId, platform=Platform, server_num=ServerNum, server_name=ServerName, area=Area, name=Name, hard=1, career=Career, attr=RobotAttr,
        combat_power=RobotCombatPower, n_combat_power=RobotCombatPower, score=0, win=0, win_streak=WinStreak, lose_streak=LoseStreak, race_1_times=1, sex = Sex, turn = Turn}.

trans_to_bet(
    #kf_1vN_role{platform=Platform, server_num=ServerNum, figure=#figure{name=Name}}
        , RoleId, BattleId, BetTime, Turn, BetCostType, OptNo) ->
    <<Key:48>> = <<BattleId:16, BetTime:32>>,
    #kf_1vN_bet{key=Key, battle_id=BattleId, bet_time=BetTime, role_id=RoleId, race_2_turn=Turn, platform=Platform, server_num=ServerNum,
        name=Name, bet_cost_type=BetCostType, bet_opt_no=OptNo}.

pre_scene_xy() ->
    case data_kf_1vN:get_value(?KF_1VN_CFG_PER_SCENE_XY) of
        false -> {0, 0};
        List ->
            [H|_] = ulists:list_shuffle(List),
            H
    end.

quit_to_main_scene(SerIdOrNode, Id) ->
    mod_clusters_center:apply_cast(SerIdOrNode, lib_scene, player_change_scene, [Id, 0, 0, 0, true, [{group, 0}, {ghost, 0}, {action_free, ?ERRCODE(err621_in_kf_1vn)}]]).

auction_lose(RoleId, GoodsStr, Refs) ->
    Callback = {?MODULE, return_auction_cost, [RoleId, GoodsStr]},
    [lib_consume_data:advance_payment_fail(RoleId, Ref, Callback) || Ref <- Refs].
%%    lib_consume_data:advance_payment_all_fail(RoleId, kf_1vn_auction, {?MODULE, return_auction_cost, [RoleId, GoodsStr]}).

return_auction_cost(CostList, [RoleId, GoodsStr]) ->
    Title = utext:get(329),
    Content = utext:get(330, [GoodsStr]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, CostList).

auction_success(RoleId, Goods, Refs) ->
%%    lib_consume_data:advance_payment_all_done(RoleId, kf_1vn_auction),
    [lib_consume_data:advance_payment_done(RoleId, Ref) || Ref <- Refs],
    Title = utext:get(331),
    GoodsStr = util:make_goods_str(Goods),
    Content = utext:get(332, [GoodsStr]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, Goods).

get_sign_list_center() ->
    L = db:get_all(<<"select id, server_id, lv, combat_power, `name`, `platform`, `server_num`, `server_name` from kf_1vn_sign_center ">>),
    F = fun([Id, ServerId, Lv, CombatPower, Name, Platform, ServerNum, ServerName]) ->
            #kf_1vN_role_sign{id=Id, server_id=ServerId, lv=Lv, combat_power=CombatPower, name = Name, platform=Platform, server_num=ServerNum, server_name = ServerName}
    end,
    lists:map(F, L).

db_save_sign_center(ServerId, Id, Lv, CombatPower, Name, Platform, ServerNum, ServerName) ->
    db:execute(io_lib:format(<<"replace into kf_1vn_sign_center set id=~w, server_id=~w, lv=~w, combat_power=~w, `name`='~s', `platform`='~s', server_num=~w, `server_name`='~s', time=~w">>, [Id, ServerId, Lv, CombatPower, Name, Platform, ServerNum, ServerName, utime:unixtime()])).

db_clean_sign_center() ->
    db:execute(<<"truncate kf_1vn_sign_center">>).

db_get_def_rank() ->
    L = db:get_all(<<"select area, rank, server_id, platform, server_num, server_name, player_id, name, gname, vip, score, turn, combat_power, n_combat_power, career, survival_time, lose, lv, hp, hp_lim from kf_1vn_def_rank">>),
    F = fun([Area, Rank, SerId, Platform, SerNum, SerName, Id, Name, GuildName, Vip, Score, Turn, CP, NCP, Career, SurvivalTime, Lose, Lv, Hp, HpLim], TmpRace2M) ->
            #kf_1vN_race_2{def_rank=DefRank} = Race2 = maps:get(Area, TmpRace2M, #kf_1vN_race_2{}),
            TmpRace2M#{Area=>Race2#kf_1vN_race_2{def_rank=
                    [#kf_1vN_def_rank{rank=Rank, server_id=SerId, id=Id, platform=Platform, server_num=SerNum, name=Name, guild_name=GuildName, vip=Vip, score=Score, race_2_turn=Turn, combat_power=CP, n_combat_power = NCP, career=Career, race_2_time=SurvivalTime,
                        race_2_lose=Lose, server_name = SerName, lv=Lv, hp=Hp, hp_lim=HpLim} | DefRank]
                }}
    end,
    lists:foldl(F, #{}, L).

db_save_def_rank([], _Area) -> ok;
db_save_def_rank(DefRank, Area) ->
    ValueSql = db_save_def_rank_sql(DefRank, Area, "", 1),
    Sql = "insert into kf_1vn_def_rank (area, rank, server_id, platform, server_num, server_name, player_id, name, gname, vip, score, turn, combat_power, n_combat_power, career, survival_time, lose, lv, hp, hp_lim) values " ++ ValueSql,
    db:execute(Sql),
    ok.

db_save_def_rank_sql([], _Area, TmpSql, _Index) -> TmpSql;
db_save_def_rank_sql([
        #kf_1vN_def_rank{rank=Rank, server_id=SerId, id=Id, platform=Platform, server_num=SerNum, name=Name, guild_name=GuildName,
            vip=Vip, score=Score, race_2_turn=Turn, combat_power=CP, n_combat_power = NCP, career=Career, race_2_time=Race2Time, race_2_lose=Race2Lose,
            server_name = SerName, lv =Lv, hp=Hp, hp_lim=HpLim}|T], Area, TmpSql, Index) ->
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, ~w, '~s', ~w, '~s', ~w, '~s', '~s', ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w) ", [Area, Rank, SerId, Platform, SerNum, SerName, Id, Name, GuildName, Vip, Score, Turn, CP, NCP, Career, Race2Time, Race2Lose, Lv, Hp, HpLim]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, ~w, '~s', ~w, '~s', ~w, '~s', '~s', ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w), ", [Area, Rank, SerId, Platform, SerNum, SerName, Id, Name, GuildName, Vip, Score, Turn, CP, NCP, Career, Race2Time, Race2Lose, Lv, Hp, HpLim]) ++ TmpSql
    end,
    db_save_def_rank_sql(T, Area, TmpSql1, Index+1).

clean_def_rank() ->
    db:execute(<<"truncate kf_1vn_def_rank">>).
% clean_def_rank(Area) ->
%     db:execute(<<"DELETE FROM kf_1vn_def_rank WHERE area=~p", [Area]>>).

%% 资格赛积分排名
db_get_kf_1vn_score_rank() ->
    L = db:get_all(<<"select area, rank, server_id, platform, server_num, server_name, player_id, name, gname, vip, score, win, lose, combat_power, n_combat_power, career, lv FROM kf_1vn_score_rank">>),
    F = fun([Area, Rank, SerId, Platform, SerNum, SerName, Id, Name, GuildName, Vip, Score, Win, Lose, CP, NCP, Career, Lv], TmpRace1RankM) ->
        ScoreRank = maps:get(Area, TmpRace1RankM, []),
        TmpRace1RankM#{Area=>[#kf_1vN_score_rank{rank=Rank, server_id=SerId, platform=Platform, server_num=SerNum, server_name=SerName, id=Id,
            name = Name, guild_name=GuildName, vip=Vip, score=Score, win=Win, lose=Lose, combat_power=CP, n_combat_power = NCP, career=Career, lv=Lv}|ScoreRank]}
    end,
    lists:foldl(F, #{}, L).

db_save_kf_1vn_score_rank([], _Area) -> ok;
db_save_kf_1vn_score_rank(DefRank, Area) ->
    ValueSql = db_save_kf_1vn_score_rank_sql(DefRank, Area, "", 1),
    Sql = "insert into kf_1vn_score_rank (area, rank, server_id, platform, server_num, server_name, player_id, name, gname, vip, score, win, lose, combat_power, n_combat_power, career, lv) values " ++ ValueSql,
    db:execute(Sql),
    ok.

db_save_kf_1vn_score_rank_sql([], _Area, TmpSql, _Index) -> TmpSql;
db_save_kf_1vn_score_rank_sql([#kf_1vN_score_rank{rank=Rank, server_id=SerId, platform=Platform, server_num=SerNum, server_name=SerName, id=Id,
            name = Name, guild_name=GuildName, vip=Vip, score=Score, win=Win, lose=Lose, combat_power=CP, n_combat_power = NCP, career=Career, lv=Lv}|T], Area, TmpSql, Index) ->
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, ~w, '~s', ~w, '~s', ~w, '~s', '~s', ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w) ", [Area, Rank, SerId, Platform, SerNum, SerName, Id, Name, GuildName, Vip, Score, Win, Lose, CP, NCP, Career, Lv]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, ~w, '~s', ~w, '~s', ~w, '~s', '~s', ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w), ", [Area, Rank, SerId, Platform, SerNum, SerName, Id, Name, GuildName, Vip, Score, Win, Lose, CP, NCP, Career, Lv]) ++ TmpSql
    end,
    db_save_kf_1vn_score_rank_sql(T, Area, TmpSql1, Index+1).

clean_kf_1vn_score_rank() ->
    db:execute(<<"truncate kf_1vn_score_rank">>).

handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) ->
    case Player of
        #player_status{combat_power = Power, hightest_combat_power = Power, id = Id} ->
            mod_kf_1vN_local:update_sign_power(Id, Power);
        _ ->
            ok
    end,
    {ok, Player}.

%% 1vn挂机开启
gm_fake_join_1vn(JoinNum) -> gm_fake_join_1vn(JoinNum, 621, 0).
gm_fake_join_1vn(JoinNum, Module, SubModule) ->
    Sql_player = io_lib:format(<<"select a.id, c.lv, c.nickname, a.hightest_combat_power from player_high a left join player_low c on a.id = c.id where c.lv >= ~p limit ~p">>, [data_kf_1vN:get_value(?KF_1VN_CFG_ENTER_LV), JoinNum]),
    case db:get_all(Sql_player) of
        [] -> ok;
        Players ->
            %% 批量报名
            F = fun([RoleId, Lv, Name, CP]) ->
                mod_kf_1vN_local:sign(config:get_server_id(), RoleId, Lv, Name, CP, config:get_platform(), config:get_server_num(), util:get_server_name())
            end,
            lists:foreach(F, Players),
            Now = utime:unixtime(),
            OnHookParams = [[RoleId, Module, SubModule, Now] || [RoleId, _, _, _] <- Players],
            Sql_onHook = usql:replace(role_activity_onhook_modules, [role_id, module_id,sub_module, select_time], OnHookParams),
            CoinParams = [[RoleId, 100, 0, Now] || [RoleId, _, _, _] <- Players],
            Sql_coin = usql:replace(role_activity_onhook_coin, [role_id, onhook_coin, exchange_left, coin_utime], CoinParams),
            Sql_onHook =/= [] andalso Sql_coin =/= [] andalso begin db:execute(Sql_onHook), db:execute(Sql_coin) end,
            lib_php_api:restart_process("{mod_activity_onhook, start_link, []}")
    end.
