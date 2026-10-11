%% ---------------------------------------------------------------------------
%% @doc timer_4_clock
%% @author ming_up@foxmail.com
%% @since  2016-09-18
%% @deprecated 03:00:01执行的定时器
%% ---------------------------------------------------------------------------
-module(timer_4_clock).

-include("common.hrl").
-include("daily.hrl").
-include("def_cache.hrl").
-include("watchdog.hrl").

-export([start_link/0,  handle/0]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).

handle() ->
    NowTime = utime:unixtime(),
    ClsType = config:get_cls_type(),
    do_handle(ClsType),
    lib_log_api:log_server_daily_clear(?FOUR, NowTime, utime:unixtime()),
    lib_watchdog_api:add_monitor(?WATCHDOG_FOUR_CLEAR, utime:unixtime()),  
    ok.

%% 游戏服handle
do_handle(?NODE_GAME) ->
    %%% **************************************************
    %%% M:F(DelaySec) -> Res when
    %%%     DelaySec  :: integer(), DelaySec叠服延时(秒)
    %%%     Res       :: term().
    %%% Note:
    %%% 1.执行接口需要显式添加"DelaySec"叠服延时实参
    %%% 2.各执行接口添加的DelaySec，从上往下依次顺序递增
    %%% Usage:
    %%% 1.rank:award(0)
    %%% 发放排行榜奖励：即时清理榜单，延时发放奖励
    %%% 2.mod_sell:restat_average(30)
    %%% 统计交易平均价格：即时更新内存数据，延时下架过期商品
    %%% **************************************************

    %% 日常清理
    OpenDay = util:get_open_day(),
    if
        OpenDay =< 1 -> %% 开服第一天就不清理日常(针对0点到4点之间开的服)
            skip;
        true ->
            %% 周几触发
            Week = utime:day_of_week(),
            week_handle(?NODE_GAME, Week),
            mod_daily:daily_clear(?FOUR, 0),
            lib_task:daily_clear(?FOUR, 0),
            mod_cache:refresh(?CACHE_REFRESH_FOUR, 0),
            %% 拍卖
            mod_auction:daily_clear(0),
            %% 每日充值礼包
            % mod_recharge_act:clear_daily_gift(30),
            %% 帮派四点清理
            %mod_guild:day_clear(?FOUR, 0),
            %% 资源找回
            lib_resource_back:refresh(0),
            %% 邮件推送
            %% mod_pushmail:marge_day(0),
            %% mod_pushmail:open_day(0),
            %% 定制活动
            mod_custom_act:day_trigger(?FOUR, 0),
            %% 红包
            %%mod_red_envelopes:daily_timer(0),
            %% 帮派boss
            mod_guild_boss:daily_timer(0),
            %% vip刷新
%%            lib_vip:refresh(),
            %% 属性药剂每次使用次数清0
            ?TRY_CATCH(lib_attr_medicament:timer_0_clock()),
            %% boss疲劳值
            ?TRY_CATCH(lib_boss:daily_clear()),
            %% 清理过期的送花记录
            lib_flower:daily_timer(10),
            %% 市场销售记录清理
            mod_sell:daily_timer(0),
            %% 周一大奖
            lib_bonus_monday:daily_timer(?FOUR),
            %% 等级抢购活动
            lib_level_act:day_clear(),
            %% 圣兽领击杀记录清理
            mod_eudemons_land_local:clean_eudemons_boss_log(0),
            mod_role_show:daily_clear(?FOUR),
            %% 在线奖励
            lib_online_reward:refresh(0),
            lib_activation_draw:four_clear(),
            %% 宝宝点赞榜
            mod_baby_mgr:daily_clear(),
            %% 公会宝箱
            lib_guild_daily:day_clear(),
            lib_dun_demon:zero_update(),
            %% 嗨点处理
            % mod_hi_point:clear_flag(0)
            %% 秘境领域发送奖励
            mod_boss:domain_mail_reward(),
            %% 至尊vip
            lib_supreme_vip:daily_timer(?FOUR),
            %% 公会领地战
            mod_territory_war:timer_check(),
            %% 个人排行本
            mod_kf_rank_dungeon_local:midnight_reset(),
            %% 玩法通知
            ?TRY_CATCH(lib_advance_fun:inform_by_mail()),
            %% boss转盘
            lib_boss_rotary:daily_clear(),
            %% 神之所
            lib_god_court:daily_clear(),
            %% 时空圣痕
            ?TRY_CATCH(lib_local_chrono_rift_act:day_trigger()),
            %% 怒海争霸
            mod_seacraft_local:day_trigger(),
            %% 国战日常
            ?TRY_CATCH(lib_seacraft_daily:day_trigger()),
            %% 协助
            mod_guild_assist:day_trigger(),
            %% 工会声望职位同步
            mod_guild:sync_position_prestige(),
            %% 璀璨之海
            mod_sea_treasure_local:four_clock(),
            %% 系统出售
            mod_sys_sell:daily_timer(),
            %% 广告
            lib_advertisement:four_do(),
            %% 周卡
            lib_weekly_card_api:daily_refresh(),
            %% 跨服秘境大妖
            mod_great_demon_local:daily_clear_demon_kill()
    end,
    ok;

%% 跨服handle
do_handle(?NODE_CENTER) ->
    %% 要执行的代码写在下面
    mod_zone_mgr:calc_zone_mod(),
    %% 公会领地战
    mod_territory_war:timer_check(),
    %% 个人排行本
    mod_kf_rank_dungeon:midnight_reset(),
    %% 周本结算
    mod_week_dun_rank:midnight_reset(),
    %% 圣灵战场
    % mod_holy_spirit_battlefield:re_alloc_group(),
    %% 时空裂缝
    mod_kf_chrono_rift_goal:day_trigger(),
    %% 怒海争霸
    mod_kf_seacraft:four_clock(),
    %% 国战日常
    mod_kf_seacraft_daily:day_trigger(),
    %% 璀璨之海
    mod_sea_treasure_kf:four_clock(),
    %% 系统出售
    mod_sys_sell:daily_timer(),
    ok;

do_handle(ClsType) ->
    ?ERR("unkown cls_type:~p", [ClsType]),
    ok.

%% 游戏服星期一0点handle
week_handle(?NODE_GAME, 1)->
    %% 周一清理协助
    mod_guild_assist:clear_assist_monday(),
    ok;

%% 跨服星期一0点handle
week_handle(_ClsType, _Day) ->
    ok.

%% 定时器启动
start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

%%
callback_mode()->
    handle_event_function.


init([]) ->
    {_, Time} = get_next_time(),
    Ref = erlang:send_after(Time*1000, self(), 'do'),
    {ok, timeout, Ref}.

handle_event(Type, Msg, StateName, State)->
    case catch do_handle_event(Type, Msg, StateName, State) of
        {'EXIT', _R} ->
            ?ERR("handle_exit_error:~p~n", [[Type, Msg, StateName, _R]]),
            {keep_state, State};
        Reply ->
            Reply
    end.

terminate(_Reason, _StateName, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.


%% ======================================= privite function ===========================================

get_next_time() ->
    NowTime      = utime:unixtime(),
    MidnightTime = utime:unixdate(NowTime),
    ExcTime      = MidnightTime+(4*?ONE_HOUR_SECONDS)+1,
    if
        NowTime < ExcTime -> {false, ExcTime-NowTime};
        true -> {true, ExcTime + ?ONE_DAY_SECONDS - NowTime}
    end.

do_handle_event(info, 'do', timeout, ORef)->
    util:cancel_timer(ORef),
    ?ERR("4_clock start", []),
    {IsExec, Time} = get_next_time(),
    NRef = erlang:send_after(Time*1000, self(), 'do'),
    case IsExec of
        true ->
            case catch handle() of
                ok -> skip;
                Error ->  ?ERR("handle_error:~p", [Error])
            end;
        false -> skip
    end,
    ?ERR("4_clock end is_exec =~p, next_time =~w ", [IsExec, Time]),
    {next_state, timeout, NRef};

do_handle_event(_Type, _Msg, _StateName, State) ->
    ?PRINT("no match :~p~n", [[_Type, _Msg, _StateName]]),
    {keep_state, State}.
