%%%--------------------------------------
%%% @Module  : lib_saint
%%% @Author  : fwx
%%% @Created : 2018.6.13
%%% @Description:  圣者殿
%%%--------------------------------------

-module(lib_saint).
-compile(export_all).

-include("server.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("saint.hrl").
-include("common.hrl").
-include("attr.hrl").

%% 登录初始化
login(Ps) ->
    #player_status{
        id          = RoleId,
        server_name = SName,
        platform    = Pfrom,
        server_id   = SerId,
        server_num  = SNum
    } = Ps,
    Ps#player_status{
        role_saint = #role_saint{
            role_id     = RoleId,
            server_id   = SerId,
            server_name = SName,
            plat_form   = Pfrom,
            server_num  = SNum
        }}.

%% 是否在圣者大厅
is_in_saint(Scene) ->
    Scene =:= ?READY_SCENE.

%% 随机出转盘属性
get_turntable_id() ->
    F = fun
            (Id) ->
                case data_saint:get_turntable(Id) of
                    #base_saint_turntable{prob = Weight} ->
                        {Weight, Id};
                    _ ->
                        ?ERR("err config:~p ~n", [Id]),
                        {0, Id}
                end
            end,
    WeightList = [ F(Id) || Id <- data_saint:get_turntable_ids() ],
    urand:rand_with_weight(WeightList).

battle_field_create_done(Player, BattleNode, BattlePid, RoleId, _StoneId) ->
    #player_status{
        sid = _Sid,
        scene = OSceneId,
        scene_pool_id = OPoolId,
        copy_id = OCopyId,
        x = X,
        y = Y,
        battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}
    } = Player,
    %Lock = ?ERRCODE(err281_on_battle_state),
    Args = [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim],
    apply_cast(BattleNode, mod_battle_field, player_enter, [BattlePid, RoleId, Args]),
    %NewPlayer = lib_player:setup_action_lock(Player#player_status{top_pk = PKStatus#top_pk_status{pk_state = {battle, BattleNode, BattlePid}}}, Lock),
    {ok, Player}.

battle_field_close(Player, Resaon) ->
    #player_status{sid = Sid} = Player,
    case Resaon of
        init_error ->
            lib_server_send:send_to_sid(Sid, pt_607, 60700, [?FAIL]),
            TmpPlayer = Player;
        _ ->
            TmpPlayer = Player
    end,
    %{ok, lib_player:break_action_lock(TmpPlayer, ?ERRCODE(err281_on_matching_state))}.
    {ok, TmpPlayer}.

apply_cast(Node, Mod, Fun, Args) ->
    if
        Node =:= node() ->
            erlang:apply(Mod, Fun, Args);
        true ->
            rpc:cast(Node, Mod, Fun, Args)
    end.

check_by_saint_lv(ZoneSaintMap, RoleId, RivalSaintId) ->
    SaintL = maps:to_list(ZoneSaintMap),
    case get_valid_saint_id(SaintL, RoleId) of
        0 ->
            true;
        SaintId  ->
            #base_saint_stone{dsgt_id = RoleDsgtId} = data_saint:get_stone(SaintId),
            #base_saint_stone{dsgt_id = RivalDsgtId} = data_saint:get_stone(RivalSaintId),
            case RoleDsgtId =:= RivalDsgtId of
                true ->
                    true;
                false ->
                    SaintId > RivalSaintId
            end
    end.

get_valid_saint_id([], _RoleId) -> 0;
get_valid_saint_id([{SaintId, #saint{role_id = RoleId}} |_], RoleId) ->
    SaintId;
get_valid_saint_id([_ |T], RoleId) ->
    get_valid_saint_id(T, RoleId).

daily_reset(Ps) ->
    #player_status{sid = Sid} = Ps,
    MaxCount = mod_daily:get_limit_by_type(?MOD_SAINT, 1),
    lib_server_send:send_to_sid(Sid, pt_607, 60703, [MaxCount, MaxCount]).

remove_inspire_times(#player_status{role_saint = RoleSaint} = Player) ->
    Player#player_status{role_saint = RoleSaint#role_saint{inspire_times = []}}.