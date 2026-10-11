%% ---------------------------------------------------------------------------
%% @doc timer_midnight
%% @author ming_up@foxmail.com
%% @since  2016-09-18
%% @deprecated 00:00:01执行的定时器
%% ---------------------------------------------------------------------------
-module(timer_midnight).

-include ("common.hrl").
-include ("daily.hrl").
-include ("def_cache.hrl").
-include("watchdog.hrl").
-include("timer.hrl").

-export([start_link/0, handle/0]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4, do_handle/1]).

handle() ->
    NowTime = utime:unixtime(),
    ClsType = config:get_cls_type(),
    do_handle(ClsType),
    lib_log_api:log_server_daily_clear(?TWELVE, NowTime, utime:unixtime()),
    lib_watchdog_api:add_monitor(?WATCHDOG_MIDNIGHT_CLEAR, utime:unixtime()),
    ok.

%% 游戏服handle
do_handle(ClsType = ?NODE_GAME) ->
    %% **************************************************
    %% M:F(RewardDelaySec) -> Res when
    %%     DelaySec  :: integer(), DelaySec叠服延时(秒)
    %%     Res       :: term().
    %% Note:
    %% 1.执行接口需要显式添加“DelaySec”叠服延时实参
    %% 2.各执行接口添加的DelaySec，从上往下依次顺序递增
    %% Usage:
    %% 1.rank:award(0)
    %% 发放排行榜奖励：即时清理榜单，延时发放奖励
    %% 2.mod_sell:restat_average(30)
    %% 统计交易平均价格：即时更新内存数据，延时下架过期商品
    %% **************************************************

    %% **************************************************
    %% 2020年10月10日 补充
    %% 一、零点注意事项
    %% 1.邮件要睡眠发送
    %% 2.同表sql汇总起来,批量写入数据库。不要对同表循环写入。
    %% 3.如果可能报错的话要使用 ?TRY_CATCH 包裹，防止报错导致后续函数无法执行
    %% 4.功能自身定时器触发清理，
    %%
    %% 二、后续功能都要填写睡眠时间,方便管理。默认第一个参数填写毫秒
    %% 1.如果是有延迟指定秒数，需要填写秒数，功能内部要进行睡眠后再操作数据库
    %% XXX功能
    %% lib_XXX:XXX(10000),
    %% 2.需要立即执行，不执行睡眠，可以不需要填参数或者填0
    %% XXX功能
    %% lib_XXX:XXX(),
    %% 3.特殊处理需要加描述
    %% XXX功能:立刻通知玩家,但是每次会睡眠20毫秒
    %% lib_XXX:XXX()
    %%
    %% 三、[lib_timer:apply_delay_mfa_list]规范零点触发,避免零点功能集中操作数据库导致超时.本方法执行函数每次增加1.0~1.3秒,随机保证错开峰值
    %% 1.执行函数{M, F, A} 实际执行 {M, F, [#timer{}]++A},增加多一个参数
    %% 2.根据策划需求,不要求立刻处理的,睡眠越晚后越好,建议使用服延迟
    %% 3.如果就要零点立刻触发,就不要加在这里
    %% **************************************************

    %% 周几触发
    Week = utime:day_of_week(),
    week_handle(ClsType, Week),
    %% 玩家累积登陆
    lib_player_login_day:daily_timer(?TWELVE),

    %% 每天0点触发
    %% 世界等级刷新
    lib_common_rank_api:refresh_average_lv_20(0),
    lib_common_rank_api:refresh_server_combat_power_10(2000),
    mod_zone_mgr:sync_to_center_combat_power(0),
    %% 玩家签到数据刷新
    lib_checkin:refresh_midnight(0),
    %% 定制活动
    mod_custom_act:day_trigger(?TWELVE, 0),
    %% 日常次数刷新
    mod_daily:daily_clear(?TWELVE, 0),
    mod_daily_dict:daily_clear(0),
    mod_cache:refresh(?CACHE_REFRESH_TWELVE, 0),
    % 天命转盘
    lib_destiny_turntable:daily_refresh(),
    % 节日活动总览
    lib_week_overview:daily_refresh(),
    %% 每日充值礼包
    mod_recharge_act:clear_daily_gift(30),
    %% 帮派刷新
    mod_guild:day_clear(?TWELVE, 3),
    %% 日常刷新
    mod_act_join:daily_clear(0),
    %% 冲榜活动刷新
    mod_rush_rank:day_clear(30),
    %% 通用榜单结算
    mod_common_rank:day_clear(60),
    %% 特惠商城清理每日购买数量
    mod_limit_buy:day_clear(30),
    %% 收集活动清理每日全服总提交量
    mod_collect:day_clear(30),
    %% lib_flower:daily_clear(0),
    %% boss日志清理
    mod_boss:clean_boss_log(0),
    %mod_eudemons_land_local:clean_eudemons_boss_log(0),
    ?TRY_CATCH(lib_treasure_evaluation:all_daily_check()),
    mod_guess:daily_trigger(),
%%   神秘商店零点刷新
    lib_mystery_api:daily_clear(0),
    %% 公会副本信息
    %mod_guild_dun_mgr:daily_clear(),
    %% 圣兽领
    mod_eudemons_land_local:daily_check(),
    % 周一大奖
    lib_bonus_monday:daily_timer(?TWELVE),
    %% 等级抢购活动
    lib_level_act:day_clear(),
    %% 钻石大战
    lib_role_drum:daily_clear(0),
    %% 怒海争霸
    mod_seacraft_local:day_opration(120),
%%    %% 属性药剂每次使用次数清0
%%    lib_attr_medicament:timer_0_clock(),
    %% 市场交易
    %mod_sell:daily_timer(0),
    % %% 在线奖励
    % lib_online_reward:refresh(0),
%%    %% 资源找回 改为4点
%%    lib_resource_back:refresh(0),
    %% 抢购商城
    lib_rush_shop:daily_clear(0),
%%    %% boss疲劳值 改为4点
%%    lib_boss:daily_clear(),
    %% 巅峰竞技
    ?TRY_CATCH(lib_top_pk:update_yesterday_rank_lv()),
    %% 巅峰竞技本地进程
    mod_top_pk_rank:day_tiger(),
    %% 圣域
    ?TRY_CATCH(lib_sanctuary:day_clear()),
    %% pk记录
    lib_pk_log:day_clear(),
    %% 天天冒险
    ?TRY_CATCH(lib_adventure:update_sql_clear()),
    %% 开启功能提示
    lib_module_open:refresh_midnight(),
    mod_role_show:daily_clear(?TWELVE),
    lib_3v3_local:new_season_handle(),
    %% 竞榜
    lib_race_act:daily_clear(0),
    lib_festival_investment:refresh_midnight(),
    lib_recharge_first:daily_reset(),
    %% 使魔商店
    lib_demons:daily_reset(),
%%    mod_3v3_team:daily_reset(),
    %% 至尊vip
    lib_supreme_vip:daily_timer(?TWELVE),
    lib_activation_draw:zore_clear(),
    mod_hi_point:daily_push(),
    %% 日常预约
    ?TRY_CATCH(lib_act_sign_up:day_trigger()),
    %% 封测返还
    lib_beta_recharge_return:daily_timer(?TWELVE),
    mod_contract_challenge:flush_recharge_cost(),
    %% 星核直购刷新
    lib_dragon_ball:refresh(3000),
%%    %% 主角光环刷新
%%    lib_hero_halo:refresh(3000),
    %% 市场
    mod_sell:daily_timer2(),
    %% 时空圣痕
    lib_chrono_rift:act_end(),
    %% 璀璨之星
    mod_sea_treasure_local:midnight_do(),
    %% 神殿觉醒
    lib_temple_awaken_api:day_trigger(),
    %% 圣灵战场
    mod_holy_spirit_battlefield_local:day_trigger(),
    % 祭典
    lib_fiesta:daily_refresh(),
    % 嗨点0点触发登录
    lib_hi_point_api:midnight_trigger(),
    % 符文本零点更新每日奖励领取
    lib_dungeon_rune:daily_clear(),
    %% 众生之门
    lib_beings_gate_api:refresh_activity_value(),
    %% 限时爬塔时间更新
    lib_dungeon_limit_tower:daily_check(),
    %% 月卡登录天数更新
    lib_investment:daily_refresh(),
    %% 零点快照备份
    mod_common_rank:common_rank_snapshot(),
    % 玩家当天首次登录战力
    lib_role_api:update_role_first_combat(),

    %% 规范零点触发
    TimeMfaList = [
        % 要求先睡眠15s
        {15000, load_game_midnight_func(15000, ?DELAY_TYPE_NO)},
        % 要求先睡眠30+服延迟秒数,服延迟秒数最大是57秒
        {30000+lib_timer:get_ser_delay_time(), load_game_midnight_func(30000, ?DELAY_TYPE_SER)},
        % 要求先睡眠60+服延迟秒数,服延迟秒数最大是57秒
        {60000+lib_timer:get_ser_delay_time(), load_game_midnight_func(60000, ?DELAY_TYPE_SER)}
    ],
    ok = lib_timer:apply_delay_mfa_list(TimeMfaList),
    ok;

%% 跨服handle
do_handle(?NODE_CENTER) ->
    %% 要执行的代码写在下面
    lib_kf_guild_war_api:day_trigger(?TWELVE),
    mod_zone_mgr:midnight_recalc(),
    %%3v3排行榜
    mod_3v3_rank:season_end(),
    mod_3v3_team:daily_reset(),
    %%冠军赛
    mod_3v3_champion:day_trigger(),
    %%圣灵战场
    mod_holy_spirit_battlefield:day_trigger(),
    %%时空圣痕
    mod_kf_chrono_rift:day_trigger(),
	%%时空圣痕排行榜
	mod_kf_chrono_rift_scramble_rank:day_trigger(),
    %% 璀璨之星
    mod_sea_treasure_kf:midnight_do(),
    ok;

do_handle(ClsType) ->
    ?ERR("unkown cls_type:~p", [ClsType]),
    ok.

%% 加载游戏服零点执行，具体描述看 timer_midnight:do_handle(ClsType = ?NODE_GAME) 。
%%  NOTE:执行函数{M, F, A} 实际执行 {M, F, [#timer{}]++A},增加多一个参数
%% @param MilliSec 延迟的毫秒数
%% @param DeLayType 延迟类型(no_ser_delay:无服延迟;ser_delay:服延迟)
load_game_midnight_func(15000, ?DELAY_TYPE_NO) ->
    [
    ];
load_game_midnight_func(30000, ?DELAY_TYPE_SER) ->
    [
        % {lib_timer, test_timer, []},
        % {lib_timer, test_timer_with_args, [?TWELVE]}
    ];
load_game_midnight_func(60000, ?DELAY_TYPE_SER) ->
    [
        {lib_create_role_act, midnight_do, []}
        ,{lib_push_gift, midnight_do, []}
        ,{lib_advertisement, midnight_do, []}
    ];
load_game_midnight_func(_MilliSec, _DeLayType) ->
    [].

%% 游戏服星期一0点handle
week_handle(?NODE_GAME, 1)->
    %% 周次数清理
    mod_week:week_clear(0),
    %% 跨服圣域周一0清理玩家积分
    %lib_c_sanctuary:clear_role_score(),
    %% 公会任务清理
    lib_task:daily_clear(?TWELVE, 0),
    %% 活动托管值重置
    mod_activity_onhook:week_handle(),
    ok;

%% 跨服星期一0点handle
week_handle(_ClsType, _Day) ->
    ok.

%% 定时器启动
start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

callback_mode()->
    handle_event_function.

init([]) ->
    {Date, _} = calendar:local_time(),
    {_, _, Time} = get_next_time(Date),
    Ref = erlang:send_after(Time*1000, self(), 'do'),
    {ok, timeout, {Ref, Date}}.

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

get_next_time(LastExecDate) ->
    {Date, {H,Min,S}} = calendar:local_time(),
    PassTime = H*3600 + Min*60 + S,
    case LastExecDate of
        Date -> {false, Date, ?ONE_DAY_SECONDS+1 - PassTime};
        _    -> {true,  Date, ?ONE_DAY_SECONDS+1 - PassTime}
    end.

do_handle_event(info, 'do', timeout, {ORef, LastExecDate})->
    util:cancel_timer(ORef),
    ?ERR("midnight start", []),
    {IsExec, Date, Time} = get_next_time(LastExecDate),
    Ref = erlang:send_after(Time*1000, self(), 'do'),
    case IsExec of
        true ->
            case catch handle() of
                ok -> skip;
                Error ->  ?ERR("handle_error:~p", [Error])
            end;
        false -> skip
    end,
    ?ERR("midnight end is_exec =~p, last_date=~w, now_date=~w, next_time =~w ", [IsExec, LastExecDate, Date, Time]),
    {next_state, timeout, {Ref, Date}};

do_handle_event(_Type, _Msg, _StateName, State) ->
    ?PRINT("no match :~p~n", [[_Type, _Msg, _StateName]]),
    {keep_state, State}.
