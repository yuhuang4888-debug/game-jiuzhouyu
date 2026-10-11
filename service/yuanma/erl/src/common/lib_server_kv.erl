%% ---------------------------------------------------------------------------
%% @doc MYSQL server_kv表
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_server_kv).
-include("common.hrl").
-include("record.hrl").
-include("common_rank.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("counter_global.hrl").
-include("server.hrl").

-export([
    get_open_time/0
    , get_merge_time/0
    , get_merge_count/0
    , get_merge_wlv/0
    , get_server_name/0
    , get_cur_open_time/0
    , get_reg_server_id/0
    , get_filter_word_channel/0
    , get_filter_word/0
    , get_filter_load_word/0
    , get_utc_zone/0
    , get_c_server_msg/0
    , get_server_type/0
    , get_server_active/0
    , set_merge_time/1
    , set_merge_wlv/0
]).


-export([
    load/0
    , update_open_time/1
    , reset_world_lv/2
    , update_server_kv/1
    , update_server_kv_to_ets/3
    , timer_update_world_lv/0
    , timer_update_active/0
    , get_server_kv/1
]).

%% 定时刷新世界等级的开服天数|弃用
-define(TIMER_WORLD_LV_OPEN_DAY, 1).

%% 开服的开始时间
get_open_time() -> get_server_kv(?SKV_OPEN_DATE_TIME).
get_merge_time() -> get_server_kv(?SKV_MERGE_TIME).
get_merge_count() -> get_server_kv(?SKV_MERGE_COUNT).
get_merge_wlv() -> get_server_kv(?SKV_MERGE_WLV).
get_server_name() -> get_server_kv(?SKV_SERVER_NAME).
get_cur_open_time() -> get_server_kv(?SKV_OPEN_CUR_TIME).
get_reg_server_id() -> get_server_kv(?SKV_REG_SERVER_ID).
get_filter_word_channel() -> get_server_kv(?SKV_FILTER_WORD_CHANNEL).
get_filter_word() -> get_server_kv(?SKV_FILTER_LOAD_WORD_NUM).
get_filter_load_word() -> get_server_kv(?SKV_FILTER_LOAD_WORD_NUM).
get_utc_zone() -> get_server_kv(?SKV_UTC_ZONE).
get_c_server_msg() -> get_server_kv(?SKV_C_SERVER_MSG).
get_server_type() -> get_server_kv(?SKV_SERVER_TYPE).
get_server_active() -> get_server_kv(?SKV_SERVER_ACTIVE_TYPE).

%% 合服完毕的时候执行的,必须在游戏线执行[2022年7月5日 php不会自动调用本函数了，在里面加方法不会自动触发的]
set_merge_time(UnixTime) ->
    update_server_kv(?SKV_MERGE_TIME, UnixTime, utime:unixtime()),
    update_server_kv(?SKV_MERGE_WLV, util:get_world_lv(), utime:unixtime()).

%% 设置合服世界等级(为当前世界等级)
set_merge_wlv() ->
    update_server_kv(?SKV_MERGE_WLV, util:get_world_lv(), utime:unixtime()).

%% 重设世界等级
reset_world_lv(RankMaps, LoginTimeMap) ->
    case catch mod_global_counter:get_count(?MOD_0, ?GLOBAL_0_GM_WORLD_LV_OPEN) of
        WorldLv when is_integer(WorldLv) andalso WorldLv > 0 ->
            update_world_lv_help(WorldLv, utime:unixtime());
        _R ->
            update_world_lv(RankMaps, LoginTimeMap, utime:unixtime())
            % case ets:lookup(?ETS_SERVER_KV, ?SKV_WORLD_LV) of
            %     [] ->
            %         update_world_lv(RankMaps, utime:unixtime());
            %     [_Kv] ->
            %         % NowTime = utime:unixtime(),
            %         % 世界等级会动态变化:第一天只更新一次,第二天开始直接修改|不判断开服天数
            %         %case util:get_open_day() =< ?TIMER_WORLD_LV_OPEN_DAY of
            %         %    true ->
            %         %        case utime:is_same_date(Kv#server_kv.time+10, NowTime) of
            %         %            true -> ok;
            %         %            false -> update_world_lv(RankMaps, NowTime)
            %         %        end;
            %         %    false ->
            %         %        update_world_lv(RankMaps, NowTime)
            %         %end
            % end
    end.

update_world_lv(RankMaps, LoginTimeMap, NowTime) ->
    case maps:get(?RANK_TYPE_LV, RankMaps, []) of
        [] -> WorldLv = 1;
        LvRanks ->
            % 登出2天内
            F_filter = fun(#common_rank_role{role_id = RoleId, rank = Rank}) ->
                LastLoginTime = maps:get({?RANK_TYPE_LV, RoleId}, LoginTimeMap, 0),
                case Rank =< ?WORLD_LV_LEN of
                    true ->
                        LastLoginTime > NowTime - 2 * ?ONE_DAY_SECONDS orelse misc:is_process_alive(misc:get_player_process(RoleId));
                    _ ->
                        false
                end
            end,
            FilterLvRanks = lists:filter(F_filter, LvRanks),
            RankList = lists:sublist(lists:keysort(#common_rank_role.rank, FilterLvRanks), ?WORLD_LV_LEN),
            case [Value || #common_rank_role{value = Value} <- RankList] of
                [] ->  WorldLv = get_history_world_lv();
                List -> WorldLv = max(get_history_world_lv(), round(lists:sum(List) / length(List)))
            end
    end,
    update_world_lv_help(WorldLv, NowTime).

update_world_lv_help(WorldLv, NowTime) ->
    KvR = #server_kv{key = ?SKV_WORLD_LV, value = WorldLv, time = NowTime},
    update_server_kv(KvR),
    %% 世界等级更新
    mod_clusters_node:apply_cast(lib_clusters_center_api, update, [config:get_server_id(), [{world_lv, WorldLv}]]),
    %% 更新到场景 ets_scene_user.world_lv
    util:cast_event_to_players({'set_data', [{world_lv, WorldLv}]}),
    ets:insert(?ETS_SERVER_KV, KvR),
    set_history_world_lv(WorldLv),
    % ?MYLOG("hjhworldlv", "update_world_lv RankMaps:~p OpenDay:~p WorldLv:~p ~n", [RankMaps, util:get_open_day(), util:get_world_lv()]),
    ok.

get_history_world_lv() ->
    case catch mod_global_counter:get_count(?MOD_0, ?GLOBAL_HISTORY_WORLD_LV) of
        0 -> 1;
        WorldLv when is_integer(WorldLv) -> WorldLv;
        _ -> 1
    end.

set_history_world_lv(WorldLv)->
    mod_global_counter:set_count(?MOD_0, ?GLOBAL_HISTORY_WORLD_LV, WorldLv).

%% 定时刷新世界等级
% 开服第一天：不结算世界等级
% 开服第二天：0点起每1小时结算一次世界等级
timer_update_world_lv() ->
    % ?MYLOG("hjhworldlv", "timer_update_world_lv OpenDay:~p WorldLv:~p ~n", [util:get_open_day(), util:get_world_lv()]),
    %case util:get_open_day() =< ?TIMER_WORLD_LV_OPEN_DAY of
    %    true -> skip;
    %    false -> mod_common_rank:refresh_average_lv_20()
    %end,
    mod_common_rank:refresh_average_lv_20(),
    ok.

%% 每天凌晨3点获取玩家登录情况，判断服务器是否为活跃服务器
%% 连续两天没有玩家登录判断为不活跃服务器
timer_update_active() ->
    NowTime = utime:unixtime(),
    update_server_active(NowTime),
    ServerActive = lib_server_kv:get_server_active(),
    mod_clusters_node:apply_cast(lib_clusters_center_api, update, [config:get_server_id(), [{server_active, ServerActive}]]),
    ok.

%% 更新kv
update_server_kv(KvR) ->
    #server_kv{key = Key, value = Value, time = Time} =  KvR,
    update_server_kv(Key, Value, Time).
update_server_kv(Key, Value, Time) ->
    ValueStr = util:term_to_string(Value),
    db:execute(io_lib:format(<<"replace into server_kv set `key` = ~p, `value` = '~s', `time` = ~w">>, [Key, ValueStr, Time])),
    % ets:insert(?ETS_SERVER_KV, #server_kv{key = Key, value = Value, time = Time}).
    update_server_kv_to_ets(#server_kv{key = Key, value = Value, time = Time}).

%% 仅更新到ets
update_server_kv_to_ets(KvR) ->
    #server_kv{key = Key, value = Value, time = Time} =  KvR,
    update_server_kv_to_ets(Key, Value, Time).
update_server_kv_to_ets(Key, Value, Time) ->
    ets:insert(?ETS_SERVER_KV, #server_kv{key = Key, value = Value, time = Time}).

%% 获取value
get_server_kv(Key) ->
    case ets:lookup(?ETS_SERVER_KV, Key) of
        [#server_kv{value=V}|_] -> V;
        _ -> false
    end.

%% 加载服务器key-value配置
load() ->
    % 加载数据库
    case db:get_all("select `key`, `value`, `time` from server_kv") of
        KVs when is_list(KVs) ->
            load_to_ets(KVs);
        _Error ->
            ?ERR("serer_kv load fail, Reason:~p~n", _Error)
    end,
    % 加载其他特殊的kv
    update_other_kv(),
    ok.

load_to_ets([[Key, ValueStr, Time]|T]) ->
    Value = util:bitstring_to_term(ValueStr),
    KVR = #server_kv{key = Key, value = Value, time = Time},
    ets:insert(?ETS_SERVER_KV, KVR),
    load_to_ets(T);
load_to_ets(_) ->
    check_op_time(),
    ok.

%% 检查开服时间是否有问题
check_op_time() ->
    RoleRegOpTime = case db:get_row(<<"select `reg_time` from `player_login` where 1 order by `id` limit 1 ">>) of
        [RegTime] when is_number(RegTime) -> RegTime;
        _  -> utime:unixtime()
    end,
    case ets:lookup(?ETS_SERVER_KV, ?SKV_OPEN_CUR_TIME) of
        [#server_kv{value=OldOpenTime}] when OldOpenTime >= RoleRegOpTime -> false; %% 秘籍其他原因修改了开服时间，不修正
        _ -> update_open_time(RoleRegOpTime)
    end.

%% 更新开服时间
update_open_time(OpTime) ->
    NowTime = utime:unixtime(),
    update_server_kv(?SKV_OPEN_CUR_TIME, OpTime, NowTime),
    OpenDateTime = utime:standard_unixdate(OpTime),
    update_server_kv(?SKV_OPEN_DATE_TIME, OpenDateTime, NowTime),
    ok.

%% 更新其他的kv值
update_other_kv() ->
    NowTime = utime:unixtime(),
    update_server_name(NowTime),
    update_reg_id(NowTime),
    update_channel_world(NowTime),
    update_ignore_word(NowTime),
    update_time_zone(NowTime),
    update_c_server_msg(NowTime),
    update_server_type(NowTime),
    update_reg_player_num(NowTime),
    update_server_active(NowTime),
    ok.

% 服务器名字
update_server_name(NowTime) ->
    %% 游戏服名字
    ServerName = case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'game_title'">>) of
        [_ServerName] -> _ServerName;
        _ -> <<"1服"/utf8>>
    end,
    update_server_kv_to_ets(?SKV_SERVER_NAME, ServerName, NowTime).

% 注册系统服Id
update_reg_id(NowTime) ->
    RegServerId = case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'r_server_id'">>) of
        [<<>>] -> 0;
        [RServerId] -> binary_to_integer(RServerId);
        _ -> 0
    end,
    update_server_kv_to_ets(?SKV_REG_SERVER_ID, RegServerId, NowTime).

% 屏蔽词来源
update_channel_world(NowTime) ->
    FLTWordChannel = case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'filter_word_channel'">>) of
        [FilterWordChannel] -> FilterWordChannel;
        _ -> 0
    end,
    update_server_kv_to_ets(?SKV_FILTER_WORD_CHANNEL, FLTWordChannel, NowTime).

%% 可忽略词语正则式
update_ignore_word(NowTime) ->
    {ok, SceneMP} = re:compile("^<color@2><a@scene3@\\d+@\\d+@\\d+@[\\d_]*>.+\\[\\d+,\\d+\\]</a></color>$"), % 场景坐标信息
    {ok, GoodsMP} = re:compile("^\\[\\d+,\\d+\\]|\\[\\d+\\]|@\\d+@$"), % 物品信息
    {ok, EmojiMP} = re:compile("^(<f_\\d+>)+$"), % 表情信息
    MPList = [SceneMP, GoodsMP, EmojiMP],
    update_server_kv_to_ets(?SKV_IGNORE_WORD_MP, MPList, NowTime).

% 时区
update_time_zone(NowTime) ->
    update_server_kv_to_ets(?SKV_UTC_ZONE, utime:native_utc_zone(), NowTime).

% 服信息
update_c_server_msg(NowTime) ->
    %% 客户端展示的服信息
    CServerMsg = case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'c_server_msg'">>) of
        [CServerMsg0] -> CServerMsg0;
        _ -> <<>>
    end,
    update_server_kv_to_ets(?SKV_C_SERVER_MSG, CServerMsg, NowTime).

% 服类型
update_server_type(NowTime) ->
    %% 服类型
    ServerType = case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'server_type'">>) of
        [<<>>] -> 0;
        [ServerType0] ->
            case catch binary_to_integer(ServerType0) of
                ServerType1 when is_integer(ServerType1) -> ServerType1;
                _ -> 0
            end;
        _ -> 0
    end,
    update_server_kv_to_ets(?SKV_SERVER_TYPE, ServerType, NowTime).

% 全服已注册玩家数
update_reg_player_num(NowTime) ->
    RegPlayerNum = case db:get_row(<<"select count(distinct accname) from player_login">>) of
        [N] -> N;
        _ -> 0
    end,
    update_server_kv_to_ets(?SKV_REG_PLAYER_NUM, RegPlayerNum, NowTime).

% 服务器活跃状态
update_server_active(NowTime) ->
    LimitNum = 2,   % 限制人数
    BeginTime = NowTime - ?ONE_DAY_SECONDS * 2,
    Sql = io_lib:format(<<"SELECT count(id) FROM player_login WHERE last_login_time BETWEEN ~p AND ~p">>, [BeginTime, NowTime]),
    OpenDay = util:get_open_day(NowTime),
    OnlineNum = length(ets:tab2list(?ETS_ONLINE)),
    case catch db:get_one(Sql) of
        _ when OnlineNum =/= 0 -> ActiveType = 1;
        _ when OpenDay < 3 -> ActiveType = 1;
        LoginNum when is_integer(LoginNum), LoginNum > LimitNum -> ActiveType = 1;
        _ -> ActiveType = 0
    end,
    update_server_kv(?SKV_SERVER_ACTIVE_TYPE, ActiveType, NowTime).
