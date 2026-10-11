%%-----------------------------------------------------------------------------
%% @Module  :       mod_diamond_league_schedule.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-23
%% @Description:    星钻联盟赛程
%%-----------------------------------------------------------------------------

-module (mod_diamond_league_schedule).
-include ("common.hrl").
-include ("diamond_league.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,init_state/4
    ,update_state/4
    ,get_league_info/2
    ,player_enter/3
    ,player_quit/2
    ,player_logout/1
    ,handle_battle_result/2
    ,get_battle_info/2
    ,get_competition_list/2
    ,buy_life/3
    ,buy_life_done/3
    ,get_history/2
    ,get_round_win_roles/2
    ,get_competitors_for_guess/1
    ,visit_battle/4
    ,gm_next/0
    ,get_60415_msg/2
]).

-define (SERVER, ?MODULE).

-record (history_item, {
        role_id,
        role_name,
        sex,
        career,
        turn,
        pic,
        picvsn,
        guild_name,
        server_name,
        lv_model,
        fashion_model,
        god_weapon_model,
        wing,
        round,
        power
    }).

%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init_state(CycleIndex, StateId, StartTime, EndTime) ->
    gen_server:cast(?SERVER, {init_state, CycleIndex, StateId, StartTime, EndTime}).

update_state(CycleIndex, StateId, StartTime, EndTime) ->
    gen_server:cast(?SERVER, {update_state, CycleIndex, StateId, StartTime, EndTime}).

get_league_info(Node, RoleId) ->
    gen_server:cast(?SERVER, {get_league_info, Node, RoleId}).

player_enter(Node, RoleId, Args) ->
    gen_server:cast(?SERVER, {player_enter, Node, RoleId, Args}).

player_quit(Node, RoleId) ->
    gen_server:cast(?SERVER, {player_quit, Node, RoleId}).

player_logout(RoleId) ->
    gen_server:cast(?SERVER, {player_logout, RoleId}).

get_battle_info(Node, RoleId) ->
    gen_server:cast(?SERVER, {get_battle_info, Node, RoleId}).

get_competition_list(Node, RoleId) ->
    gen_server:cast(?SERVER, {get_competition_list, Node, RoleId}).

buy_life(Node, RoleId, Num) ->
    gen_server:cast(?SERVER, {buy_life, Node, RoleId, Num}).

buy_life_done(Node, RoleId, Res) ->
    gen_server:cast(?SERVER, {buy_life_done, Node, RoleId, Res}).

gm_next() ->
    gen_server:cast(?SERVER, gm_next).

handle_battle_result(CurRound, Infos) ->
    gen_server:cast(?SERVER, {handle_battle_result, CurRound, Infos}).

get_history(Node, CycleIndex) ->
    gen_server:cast(?SERVER, {get_history, Node, CycleIndex}).

get_round_win_roles(Node, RoleId) ->
    gen_server:cast(?SERVER, {get_round_win_roles, Node, RoleId}).

get_competitors_for_guess(Node) ->
    gen_server:cast(?SERVER, {get_competitors_for_guess, Node}).

visit_battle(Node, RoleId, BattleRoleId, Args) ->
    gen_server:cast(?SERVER, {visit_battle, Node, RoleId, BattleRoleId, Args}).

get_60415_msg(Node, RoleId) ->
    gen_server:cast(?SERVER, {get_60415_msg, Node, RoleId}).

%% private
init([]) ->
    {ok, []}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({init_state, CycleIndex, StateId, StartTime, EndTime}, State) ->
    case State of
        #schedule_state{start_time = StartTime, end_time = EndTime} ->
            {noreply, State};
        _ ->
            Mod = lib_diamond_league:get_mod_by_state(StateId),
            NewState = Mod:init_state(CycleIndex, StateId, StartTime, EndTime),
            {noreply, NewState}
    end;

do_handle_cast({update_state, CycleIndex, StateId, StartTime, EndTime}, State) ->
    case State of
        #schedule_state{start_time = StartTime, end_time = EndTime} ->
            {noreply, State};
        _ ->
            Mod = lib_diamond_league:get_mod_by_state(StateId),
            NewState = Mod:update_state(State, CycleIndex, StateId, StartTime, EndTime),
            brocast_state(NewState),
            {noreply, NewState}
    end;

do_handle_cast({get_league_info, Node, RoleId}, #schedule_state{state_id = StateId} = State) ->
    Mod = lib_diamond_league:get_mod_by_state(StateId),
    Mod:get_league_info(Node, RoleId, State),
    {noreply, State};

do_handle_cast({get_history, Node, CycleIndex}, #schedule_state{cycle_index = I, state_id = StateId} = State) ->
    if
        (StateId =:= ?STATE_CLOSED andalso CycleIndex =:= I) orelse CycleIndex < I ->
            case get({history, CycleIndex}) of
                undefined ->
                    BinData = load_and_format_history(CycleIndex),
                    put({history, CycleIndex}, BinData);
                BinData ->
                    ok
            end,
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, get_history_respond, [CycleIndex, BinData]);
        true ->
            skip
    end,
    {noreply, State};

do_handle_cast(Msg, #schedule_state{state_id = StateId} = State) ->
    Mod = lib_diamond_league:get_mod_by_state(StateId),
    Mod:handle_cast(Msg, State);

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(Msg, #schedule_state{state_id = StateId} = State) ->
    Mod = lib_diamond_league:get_mod_by_state(StateId),
    Mod:handle_info(Msg, State);
do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal

load_and_format_history(CycleIndex) ->
    RoleSQL = io_lib:format("(SELECT `role_id`, `round`, `power` FROM `diamond_league_history` WHERE `cycle_index` = ~p ORDER BY `round` DESC, `power` DESC) AS `role`", [CycleIndex]),
    SQLWithFigure = io_lib:format("SELECT  `role`.`role_id`, `name`, `sex`, `career`, `turn`, `pic`, `picvsn`, `guild_name`, `server_name`, `lv_model`, `fashion_model`, `god_weapon_model`, `wing`, `role`.`round`, `role`.`power` FROM `diamond_league_role_figure` RIGHT JOIN ~s ON `diamond_league_role_figure`.role_id = `role`.role_id", [RoleSQL]),
    All = db:get_all(SQLWithFigure),
    List = [init_history_info(Item) || Item <- All],
    case ulists:find(fun
        (#history_item{round = Round}) ->
            Round =:= ?MELEE_ROUND_NUM + ?KING_ROUND_NUM + 1
    end, List) of
        {ok, #history_item{
                role_id = WinnerRoleId,
                role_name = WinnerRoleName,
                sex = WinnerSex,
                career = WinnerCareer,
                turn = WinnerTurn,
                pic = WinnerPic,
                picvsn = WinnerPicVsn,
                server_name = WinnerServName,
                power = WinnerPower,
                lv_model = LvModel,
                fashion_model = FashionModel,
                god_weapon_model = GodWeaponModel,
                wing = Wing
            }} ->
% winner_id:int64
% winner_name:string
% winner_server_name:string
% winner_power:int32
% winner_career:int8
% winner_sex:int8
% winner_turn:int8
% winner_pic:string
% winner_pic_ver:int32
            ok;
        _ ->
            WinnerRoleId = 0,
            WinnerRoleName = <<"">>,
            WinnerSex = 0,
            WinnerCareer = 0,
            WinnerTurn = 0,
            WinnerPic = <<"">>,
            WinnerPicVsn = 0,
            WinnerServName = <<"">>,
            WinnerPower = 0,
            LvModel = [],
            FashionModel = [],
            GodWeaponModel = [],
            Wing = 0
    end,
    FormatList = [{RoleName, ServerName, GuildName} || #history_item{role_name = RoleName, server_name = ServerName, guild_name = GuildName} <- List],
    {ok, BinData} = pt_604:write(60417, [CycleIndex, WinnerRoleId, WinnerRoleName, WinnerServName, WinnerPower, WinnerCareer, WinnerSex, WinnerTurn, WinnerPic, WinnerPicVsn, LvModel, FashionModel, GodWeaponModel, Wing, FormatList]),
    BinData.

init_history_info([RoleId, RoleName, Sex, Career, Turn, Pic, PicVsn, GuildName, ServerName, LvModel, FashionModel, GodWeaponModel, Wing, Round, Power]) ->
    #history_item{
        role_id = RoleId,
        role_name = ?VALUE(RoleName, <<"">>),
        sex = ?VALUE(Sex, 0),
        career = ?VALUE(Career, 0),
        turn = ?VALUE(Turn, 0),
        pic = ?VALUE(Pic, <<"">>),
        picvsn = ?VALUE(PicVsn, 0),
        guild_name = ?VALUE(GuildName, <<"">>),
        server_name = ?VALUE(ServerName, <<"">>),
        lv_model = ?VALUE(util:bitstring_to_term(LvModel), []),
        fashion_model = ?VALUE(util:bitstring_to_term(FashionModel), []),
        god_weapon_model = ?VALUE(util:bitstring_to_term(GodWeaponModel), []),
        wing = ?VALUE(Wing, 0),
        round = Round,
        power = Power
    }.

brocast_state(#schedule_state{cycle_index = CycleIndex, state_id = StateId, start_time = StartTime, end_time = EndTime}) ->
    mod_clusters_center:apply_to_all_node(lib_diamond_league, local_update_state, [CycleIndex, StateId, StartTime, EndTime], 50).