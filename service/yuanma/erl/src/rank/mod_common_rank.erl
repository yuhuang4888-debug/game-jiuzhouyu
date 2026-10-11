%%%------------------------------------
%%% @Module  : mod_common_rank
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------
-module(mod_common_rank).

-include("common_rank.hrl").
-include("common.hrl").
-include("predefine.hrl").

-export([
         refresh_common_rank_by_list/1
        , refresh_common_rank/2
        , send_rank_list/6
        , timer_common_rank/1
        , gm_refresh_rank/2
        ]).

%% -export([
%%         reload/0
%%         , get_state/0
%%     ]).

-export([start_link/0]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-compile(export_all).

%% @param [{RankType, CommonRankRole}]
refresh_common_rank_by_list(List) ->
    gen_server:cast({global, ?MODULE}, {'refresh_common_rank_by_list', List}).

%% 根据类型刷新榜单
refresh_common_rank(RankType, CommonRankRole) ->
    gen_server:cast({global, ?MODULE}, {'refresh_common_rank', RankType, CommonRankRole}).

%% 秘籍刷新榜单
gm_refresh_rank(RankType, CommonRankRole) ->
    gen_server:cast({global, ?MODULE}, {'gm_refresh_rank', RankType, CommonRankRole}).

%% 发送榜单的数据
send_rank_list(RankType, Start, Len, RoleId, SelValue, SelSecValue) ->
    gen_server:cast({global, ?MODULE}, {'send_rank_list', RankType, Start, Len, RoleId, SelValue, SelSecValue}).

%% 定时刷新排行榜
timer_common_rank(RankType) ->
    gen_server:cast({global, ?MODULE}, {'timer_common_rank', RankType}).

%% 定制活动定时发奖励
ac_custom_timer_reward(ModuleSub, AcSub) ->
    gen_server:cast({global, ?MODULE}, {'ac_custom_timer_reward', ModuleSub, AcSub}).

%% 解散公会
disband_guild(GuildId, RankTypeList) ->
    gen_server:cast({global, ?MODULE}, {'disband_guild', GuildId, RankTypeList}).

%% 同步公会榜单
sync_guild_rank() ->
    gen_server:cast({global, ?MODULE}, 'sync_guild_rank').

%% 点赞别人
rank_praise(RoleId, OtRoleId) ->
    gen_server:cast({global, ?MODULE}, {'rank_praise', RoleId, OtRoleId}).

%% 刷新世界等级##每小时也可能刷新
refresh_average_lv_20() ->
    gen_server:cast({global, ?MODULE}, 'refresh_average_lv_20').

%% 刷新服战力
refresh_server_combat_power_10() ->
    gen_server:cast({global, ?MODULE}, 'refresh_server_combat_power_10').

apply_cast(M, F, A) ->
    gen_server:cast({global, ?MODULE}, {'apply_cast', M, F, A}).

%% 每天结算
day_clear(DelaySec) ->
    RandTime = urand:rand(1, 1000),
    spawn(fun() -> timer:sleep(RandTime), gen_server:cast({global, ?MODULE}, {'day_clear', DelaySec}) end).

%% 玩家登陆
player_login(RoleId) ->
    gen_server:cast({global, ?MODULE}, {'player_login', RoleId}).

%%  根据榜单类型转移榜单里玩家位置
change_rank_by_type(RoleId, OldType, RankType) ->
    gen_server:cast({global, ?MODULE}, {'change_rank_by_type', RoleId, OldType, RankType}).

% 更新登录时间
update_login_time(RoleId) ->
    gen_server:cast({global, ?MODULE}, {'update_login_time', RoleId}).

%% 我要变强返回信息(战力榜最后一名信息)
to_be_strong_info(RoleId, SelFigure, SelCombat) ->
    gen_server:cast({global, ?MODULE}, {'to_be_strong_info', RoleId, SelFigure, SelCombat}).

%% 获取榜单数据
get_ranklist(RankType, Start, Len) ->
    gen_server:call({global, ?MODULE}, {'get_all_combat', RankType, Start, Len}).


send_guild_rank_list_for_sanctuary(RoleId, GuildId) ->
    gen_server:cast({global, ?MODULE}, {'send_guild_rank_list_for_sanctuary', RoleId, GuildId}).

sanctuary_do_result() ->
    gen_server:cast({global, ?MODULE}, {'sanctuary_do_result'}).


merge_sanctuary_do_result() ->
    gen_server:cast({global, ?MODULE}, {'merge_sanctuary_do_result'}).

common_rank_snapshot() ->
    gen_server:cast({global, ?MODULE}, {'common_rank_snapshot'}).


%%增加争夺值
add_scramble_value(RoleId, RoleName, CastleId, AddValue, AllValue, TodayValue, Mod, SubMod, Count, NewCount) ->
    gen_server:cast({global, ?MODULE}, {'add_scramble_value', RoleId, RoleName, CastleId, AddValue, AllValue, TodayValue, Mod, SubMod, Count, NewCount}).

gm_correct_common_rank_formal(List) ->
    gen_server:cast({global, ?MODULE}, {'gm_correct_common_rank_formal', List}).
%%----家园周榜-----------%%
% remove_rank_home(HomeId) ->
%     gen_server:cast({global, ?MODULE}, {'remove_rank_home', HomeId}).

% delete_home(HomeId) ->
%     gen_server:cast({global, ?MODULE}, {'delete_home', HomeId}).

% home_role_change(HomeId, RoleId1, RoleId2) ->
%     gen_server:cast({global, ?MODULE}, {'home_role_change', HomeId, RoleId1, RoleId2}).

% home_rerank(HomeId) ->
%     gen_server:cast({global, ?MODULE}, {'home_rerank', HomeId}).

%% ---------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
init([]) ->
    State = lib_common_rank_mod:init(),
    {ok, State}.

%% ---------------------------------------------------------------------------
%% handle_call({'reload'}, _From, _State) ->
%%     State = lib_common_rank_mod:init(),
%%     {reply, ok, State};
%% handle_call({'state'}, _From, State) ->
%%     % ?ERR1("~p state:~p~n", [?MODULE, State]),
%%     {reply, State, State};
handle_call({'get_all_combat', RankType, Start, Len}, _From, State) ->
    Reply = lib_common_rank_mod:get_all_combat(State, RankType, Start, Len),
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    %% ?ERR1("Handle unkown request[~w]~n", [_Request]),
    Reply = ok,
    {reply, Reply, State}.

%% ---------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            %% util:errlog("~p ~p Msg:~p Cast_Error:~p ~n", [?MODULE, ?LINE, Msg, Err]),
            ?ERR("Msg:~p Cast_Error:~p~n", [Msg, Err]),
            {noreply, State}
    end.


do_handle_cast({'add_scramble_value', RoleId, RoleName, CastleId, AddValue, AllValue, TodayValue, Mod, SubMod, Count, NewCount}, State) ->
    lib_common_rank_mod:add_scramble_value(State, RoleId, RoleName, CastleId, AddValue, AllValue, TodayValue, Mod, SubMod, Count, NewCount),
    {ok, State};
do_handle_cast({'refresh_common_rank_by_list', List}, State) ->
    lib_common_rank_mod:refresh_common_rank_by_list(State, List);
do_handle_cast({'refresh_common_rank', RankType, CommonRankRole}, State) ->
    lib_common_rank_mod:refresh_common_rank(State, RankType, CommonRankRole);
do_handle_cast({'send_rank_list', RankType, Start, Len, RoleId, SelValue, SelSecValue}, State) ->
    lib_common_rank_mod:send_rank_list(State, RankType, Start, Len, RoleId, SelValue, SelSecValue),
    %%?PRINT("RankType:~p, Start:~p, Len:~p, RoleId:~p, SelValue:~p, SelSecValue:~p~n",
            %[RankType, Start, Len, RoleId, SelValue, SelSecValue]),
    {ok, State};
do_handle_cast({'timer_common_rank', RankType}, State) ->
    lib_common_rank_mod:timer_common_rank(RankType, State);

do_handle_cast({'ac_custom_timer_reward', ModuleSub, AcSub}, State) ->
    lib_common_rank_mod:ac_custom_timer_reward(State, ModuleSub, AcSub);

do_handle_cast({'disband_guild', GuildId, RankTypeList}, State) ->
    lib_common_rank_mod:disband_guild(State, GuildId, RankTypeList);

do_handle_cast({'rank_praise', RoleId, OtRoleId}, State) ->
    lib_common_rank_mod:rank_praise(State, RoleId, OtRoleId);

do_handle_cast('sync_guild_rank', State) ->
    lib_common_rank_mod:sync_guild_rank(State);

do_handle_cast('refresh_average_lv_20', State) ->
    lib_common_rank_mod:refresh_average_lv_20(State);

do_handle_cast('refresh_server_combat_power_10', State) ->
    lib_common_rank_mod:refresh_server_combat_power_10(State);

do_handle_cast({'apply_cast', M, F, A}, State) ->
    lib_common_rank_mod:apply_cast(State, M, F, A);

do_handle_cast({'day_clear', DelaySec}, State) ->
    #common_rank_state{role_maps = RoleMap} = State,
    F = fun(RankType, Grand) ->
        case maps:get(RankType, RoleMap, []) of
            [] -> Grand;
            [BestRole|_] ->
                [{RankType, BestRole}|Grand]
        end
        end,
    DealPowerGiftList = lists:foldl(F, [], ?RANK_POWER_GIFT_LIST),
    NewState = lib_common_rank_gift:zero_timer(State, DealPowerGiftList),
    lib_common_rank_mod:day_clear(DelaySec, NewState);

do_handle_cast({'player_login', RoleId}, State) ->
    #common_rank_state{first_rank_list = FirstRankList} = State,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_common_rank_gift, player_login, [FirstRankList]),
    {ok, State};

do_handle_cast({'change_rank_by_type', RoleId, OldType, RankType}, State) ->
    lib_common_rank_mod:change_rank_by_type(State, RoleId, OldType, RankType);

do_handle_cast({'update_login_time', RoleId}, State) ->
    #common_rank_state{last_login_time_map = LoginTimeMap} = State,
    F = fun(RankType, AccMap) ->
        case maps:get({RankType, RoleId}, AccMap, false) of
            false -> AccMap;
            _ -> AccMap#{{RankType, RoleId} => utime:unixtime()}
        end
    end,
    NewLoginTimeMap = lists:foldl(F, LoginTimeMap, ?LOGIN_TIME_RANK_TYPE_LIST),
    {ok, State#common_rank_state{last_login_time_map = NewLoginTimeMap}};

do_handle_cast({'to_be_strong_info', RoleId, SelFigure, SelCombat}, State) ->
    lib_common_rank_mod:to_be_strong_info(State, RoleId, SelFigure, SelCombat);

do_handle_cast({'remove_rank_home', HomeId}, State) ->
    lib_common_rank_mod:remove_rank_home(State, HomeId);

do_handle_cast({'delete_home', HomeId}, State) ->
    lib_common_rank_mod:delete_home(State, HomeId);

do_handle_cast({'home_role_change', HomeId, RoleId1, RoleId2}, State) ->
    lib_common_rank_mod:home_role_change(State,  HomeId, RoleId1, RoleId2);

do_handle_cast({'home_rerank', HomeId}, State) ->
    lib_common_rank_mod:home_rerank(State, HomeId);

do_handle_cast({'send_guild_rank_list_for_sanctuary', RoleId, GuildId}, State) ->
    lib_common_rank_mod:send_guild_rank_list_for_sanctuary(RoleId, GuildId, State),
    {ok, State};




do_handle_cast({'sanctuary_do_result'}, State) ->
    lib_common_rank_mod:sanctuary_do_result(State),
    {ok, State};

do_handle_cast({'merge_sanctuary_do_result'}, State) ->
    lib_common_rank_mod:merge_sanctuary_do_result(State),
    {ok, State};

do_handle_cast({'gm_refresh_rank', RankType, CommonRankRole}, State) ->
    lib_common_rank_mod:gm_refresh_rank(State, RankType, CommonRankRole);

do_handle_cast({'gm_correct_common_rank_formal', List}, State) ->
    lib_common_rank_mod:gm_correct_common_rank_formal(State, List);

do_handle_cast({'common_rank_snapshot'}, State) ->
    lib_common_rank_mod:common_rank_snapshot(State),
    {ok, State};

do_handle_cast(_Msg, State) ->
    %% ?ERR1("Handle unkown msg[~w]~n", [_Msg]),
    {ok, State}.

%% ---------------------------------------------------------------------------
handle_info(_Info, State) ->
    ?ERR("Handle unkown info[~w]~n", [_Info]),
    {noreply, State}.


%% ---------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

%% ---------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
