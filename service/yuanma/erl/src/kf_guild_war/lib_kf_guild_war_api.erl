%%-----------------------------------------------------------------------------
%% @Module  :       lib_kf_guild_war_api
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战API
%%-----------------------------------------------------------------------------
-module(lib_kf_guild_war_api).

-include("kf_guild_war.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("daily.hrl").
-include("attr.hrl").
-include("def_module.hrl").
-include("guild.hrl").
-include("figure.hrl").

-export([
    login/3
    , send_daily_reward/2
    , send_season_reward/3
    , return_bid_gfunds/3
    , day_trigger/1
    , attack_mon/2
    , kill_mon/2
    , kill_player/6
    , get_kf_guild_war_scene/0
    , is_kf_guild_war_scene/1
    , is_kf_guild_war_scene/2
    , exit_scene/4
    , send_personal_score_info/3
    , exchange_ship/3
    , connect_center/0
    , get_ship_model_id/1
    , get_ship_skill/1
    , get_reborn_point/1
    , count_ship_attr/2
    , check_attack_code_building/3
    , use_skill/5
    , is_kf_guild_war_skill/1
    , send_mail_to_chief/3
    , send_tips/2
    ]).

login(GuildId, RoleId, RoleLv) ->
    OpenLv = lib_kf_guild_war:get_open_lv(),
    case GuildId > 0 andalso RoleLv >= OpenLv of
        true ->
            mod_kf_guild_war_local:role_login(GuildId, RoleId);
        _ -> skip
    end,
    #status_kf_guild_war{}.

count_ship_attr(StatusKfGWar, SceneId) ->
    case is_kf_guild_war_scene(SceneId) of
        true ->
            case StatusKfGWar of
                #status_kf_guild_war{
                    in_sea = 1,
                    ship_id = ShipId
                } ->
                    case data_kf_guild_war:get_ship_cfg(ShipId) of
                        #kf_gwar_ship_cfg{
                            attr = AttrL
                        } -> AttrL;
                        _ -> []
                    end;
                _ -> []
            end;
        _ -> []
    end.

send_daily_reward(RoleId, RewardList) ->
    mod_daily:increment(RoleId, ?MOD_KF_GUILD_WAR, ?DAILY_REWARD_COUNTER_ID),
    case ulists:object_list_plus(RewardList) of
        RealRewardList when RealRewardList =/= [] ->
            Produce = lib_goods_api:make_produce(kf_gwar_daily_reward, 0, utext:get(203), utext:get(204), RealRewardList, 1),
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            {ok, BinData} = pt_437:write(43705, [?SUCCESS]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_no_daily_reward))
    end.

return_bid_gfunds(GuildId, ReturnGfunds, ProduceType) ->
    case ProduceType of
        kf_gwar_return_gfunds_in_confirm ->
            {ChiefId, _ChiefName} = mod_guild:get_guild_chief_info_by_id(GuildId),
            lib_mail_api:send_sys_mail([ChiefId], utext:get(4370005), utext:get(4370006), []);
        _ -> skip
    end,
    mod_kf_guild_war_local:add_funds(GuildId, ReturnGfunds).

%% 发送赛季奖励(已经在公会进程)
send_season_reward(GuildId, _Ranking, Reward) ->
    AllMemberIds = lib_guild_data:get_all_role_in_guild(GuildId),
    spawn(fun() ->
        do_send_season_reward(AllMemberIds, Reward, 1)
    end).

do_send_season_reward([], _Reward, _Acc) -> ok;
do_send_season_reward([RoleId|L], Reward, Acc) ->
    case Acc rem 20 of
        0 ->
            timer:sleep(100);
        _ -> skip
    end,
    lib_mail_api:send_sys_mail([RoleId], utext:get(4370007), utext:get(4370008), Reward),
    do_send_season_reward(L, Reward, Acc + 1).


%% 每天0点执行
day_trigger(?TWELVE) ->
    spawn(fun() ->
        %% 延迟一段时间
        timer:sleep(60 * 1000),
        {{_NowYear, _NowMon, NowDay}, _} = calendar:local_time(),
        case NowDay == 1 of
            true -> %% 每月1号0点重置赛季
                mod_kf_guild_war:reset_season();
            _ -> skip
        end
    end);
day_trigger(?FOUR) ->
    spawn(fun() ->
        %% 延迟一段时间
        util:multiserver_delay(1),
        mod_kf_guild_war_local:day_trigger(?FOUR)
    end);
day_trigger(_) -> skip.

is_kf_guild_war_scene(Scene) when is_integer(Scene) ->
    Scene =:= data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID);
is_kf_guild_war_scene(_) -> false.

is_kf_guild_war_scene(SceneId, CopyId) ->
    case is_kf_guild_war_scene(SceneId) of
        true ->
            case misc:is_process_alive(CopyId) of
                true -> true;
                _ -> pid_no_alive
            end;
        _ -> false
    end.

get_kf_guild_war_scene() ->
    data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID).

get_ship_model_id(ShipId) ->
    case data_kf_guild_war:get_ship_cfg(ShipId) of
        #kf_gwar_ship_cfg{
            model_id = ModelId
        } -> ModelId;
        _ -> 0
    end.

get_ship_skill(ShipId) ->
    case data_kf_guild_war:get_ship_cfg(ShipId) of
        #kf_gwar_ship_cfg{
            skill = SkillList
        } ->
            [{SkillId, 1} || SkillId <- SkillList];
        _ -> []
    end.

get_reborn_point(GroupId) ->
    case erase("kf_guild_war_reborn_point") of
        {X, Y} ->
            [{x, X}, {y, Y}];
        _ ->
            DefenderPoint = data_kf_guild_war:get_cfg(?CFG_ID_DEFENDER_BORN_POINTS),
            AttackerPointsL = data_kf_guild_war:get_cfg(?CFG_ID_ATTACKER_BORN_POINTS),
            {X, Y} = lists:nth(GroupId, [DefenderPoint|AttackerPointsL]),
            [{x, X}, {y, Y}]
    end.

attack_mon(AttackerId, Object) ->
    #scene_object{sign = Sign, copy_id = CopyId, aid = Aid, mon = MonInfo, battle_attr = #battle_attr{hp = Hp}} = Object,
    case Sign == ?BATTLE_SIGN_MON of
        true ->
            #scene_mon{create_key = CreateKey} = MonInfo,
            case CreateKey of
                {Key, _CreateKeyId} when Key =:= kf_gwar_building ->
                    case misc:is_process_alive(CopyId) of
                        true ->
                            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, attack_mon, [CopyId, {'attack_mon', AttackerId, Aid, MonInfo, Hp}]);
                        _ -> skip
                    end;
                _ -> skip
            end;
        false -> skip
    end.

kill_mon(AttackerId, Object) ->
    #scene_object{sign = Sign, copy_id = CopyId, mon = MonInfo} = Object,
    case Sign == ?BATTLE_SIGN_MON of
        true ->
            #scene_mon{create_key = CreateKey} = MonInfo,
            case CreateKey of
                {Key, _CreateKeyId} when Key =:= kf_gwar_building orelse Key =:= kf_gwar_normal_mon ->
                    case misc:is_process_alive(CopyId) of
                        true ->
                            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, kill_mon, [CopyId, {'kill_mon', AttackerId, Object}]);
                        _ -> skip
                    end;
                _ -> skip
            end;
        false -> skip
    end.

kill_player(SceneId, CopyId, RoleId, RoleName, Attacker, HitList) ->
    #battle_return_atter{sign = AttackerSign, id = AttackerId, real_name = AttackerName} = Attacker,
    IsKfGWarScene = is_kf_guild_war_scene(SceneId),
    case AttackerSign == ?BATTLE_SIGN_PLAYER andalso IsKfGWarScene of
        true ->
            case misc:is_process_alive(CopyId) of
                true ->
                    mod_clusters_node:apply_cast(mod_kf_guild_war_battle, kill_player, [CopyId, {'kill_player', RoleId, RoleName, AttackerId, AttackerName, [HitId||#hit{id=HitId}<- HitList]}]);
                _ -> skip
            end;
        false -> skip
    end.

exit_scene(GuildId, RoleId, CurSceneId, CopyId) ->
    case is_kf_guild_war_scene(CurSceneId) of
        true ->
            Node = mod_disperse:get_clusters_node(),
            case misc:is_process_alive(CopyId) of
                true ->
                    mod_clusters_node:apply_cast(mod_kf_guild_war_battle, exit_scene, [CopyId, Node, GuildId, RoleId]);
                _ -> %% 容错 房间关闭了但是玩家没有被踢出来的情况
                    KeyValueList = [
                        {group, 0},
                        {forbid_pk_etime, 0},
                        {change_scene_hp_lim, 1},
                        {action_free, ?ERRCODE(err437_cant_change_scene_in_kf_gwar)}
                    ],
                    Args = [RoleId, 0, 0, 0, 0, 0, true, KeyValueList],
                    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue, Args)
            end;
        _ ->
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_no_in_act_scene))
    end.

send_personal_score_info(RoleId, SceneId, CopyId) ->
    case is_kf_guild_war_scene(SceneId) of
        true ->
            case misc:is_process_alive(CopyId) of
                true ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_kf_guild_war_battle, send_personal_score_info, [CopyId, Node, RoleId]);
                _ -> skip
            end;
        _ ->
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err601_not_in_act_scene))
    end.

%% 兑换战舰
exchange_ship(RoleId, SceneId, CopyId) ->
    case is_kf_guild_war_scene(SceneId) of
        true ->
            case misc:is_process_alive(CopyId) of
                true ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_kf_guild_war_battle, exchange_ship, [CopyId, Node, RoleId]);
                _ -> skip
            end;
        _ ->
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err601_not_in_act_scene))
    end.

%% 检查攻击核心建筑(场景进程)
check_attack_code_building(AttUser, Object, _Args) ->
    #ets_scene_user{battle_attr = #battle_attr{group = AttackerGroup}} = AttUser,
    #scene_object{id = Id, copy_id = CopyId} = Object,
    Mids = data_kf_guild_war:get_building_mids(),
    MonList = lib_scene_object_agent:get_scene_mon_by_mids(CopyId, Mids, all),
    F = fun(T) ->
        case T of
            #scene_object{id = OneId, battle_attr = BattleAttr} when OneId =/= Id ->
                case BattleAttr of
                    #battle_attr{group = AttackerGroup} -> true;
                    _ -> false
                end;
            _ -> false
        end
    end,
    lists:any(F, MonList).

use_skill(CopyId, GuildId, RoleId, SkillId, ArgsMap) ->
    case SkillId of
        28000005 -> %% 召集技能
            mod_kf_guild_war_battle:drum_up(CopyId, GuildId, RoleId, ArgsMap);
        _ -> skip
    end.

is_kf_guild_war_skill(SkillId) ->
    KfGuildWarSkillL = [28000000, 28000001, 28000002, 28000003, 28000004, 28000005, 28000006, 28000007, 28000008],
    lists:member(SkillId, KfGuildWarSkillL).

send_mail_to_chief(GuildId, Title, Content) ->
    case lib_guild_data:get_guild_chief_info_by_id(GuildId) of
        {ChiefId, _ChiefName} when ChiefId > 0 ->
            lib_mail_api:send_sys_mail([ChiefId], Title, Content, []);
        _ -> skip
    end.

send_tips(Type, QualificationIds) ->
    case lib_kf_guild_war:is_kf_guild_war_server() of
        true ->
            OpenLv = data_kf_guild_war:get_cfg(?CFG_ID_OPEN_LV),
            F1 = fun(GuildMember) ->
                case GuildMember of
                    #guild_member{
                        id = RoleId,
                        figure = Figure
                    } when Figure#figure.lv >= OpenLv ->
                        {ok, BinData} = pt_437:write(43735, [Type]),
                        lib_server_send:send_to_uid(RoleId, BinData);
                    _ -> skip
                end
            end,
            F = fun(T) ->
                case T of
                    {GuildId, _GuildName, _Ranking} ->
                        GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
                        lists:foreach(F1, maps:values(GuildMemberMap));
                    GuildId when is_integer(GuildId) ->
                        GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
                        lists:foreach(F1, maps:values(GuildMemberMap));
                    _ -> skip
                end
            end,
            lists:foreach(F, QualificationIds);
        _ -> skip
    end.

%% 连接到了跨服中心
connect_center() ->
    case lib_kf_guild_war:is_kf_guild_war_server() of
        true ->
            mod_kf_guild_war_local:connect_center();
        _ -> skip
    end.