%%% -------------------------------------------------------
%%% @author huangyongxing@yeah.net
%%% @doc
%%% 数数科技(thinkingdata)的数据上报agent（游戏服务端）
%%% 本模块以服务模式提供接口，管理事件的批量上报、出错重试等
%%% -------------------------------------------------------
%%% 关于模块命名：
%%% 数数科技的数据分析系统Thinking Analytics，缩写为TA
%%%
%%% 此模块的实现，基于数数科技接入文档v3.2中描述的数据模型，
%%% 采用Restful API接口上报数据。
%%% 文档地址：
%%% [https://docs.thinkingdata.cn/ta-manual/latest/installation/installation_menu/restful_api.html]
%%% -------------------------------------------------------
%%% 关于事件及属性配置：
%%% 相关事件属性等信息需要进行配置，目的是加强约束，避免随意滥用事件和属性，
%%% 使得上报事件、属性值类型等更为可控与正确，并可自动校正部分数据类型，
%%% 新增上报事件需要先在后台添加配置，再在代码中添加触发管理。
%%% -------------------------------------------------------
%%% 注意：
%%% 1. 此模块作为公共的服务接口，业务性的逻辑，尽量不要放到这里，方便移植到其他工程使用
%%% 对于部分需要进行一定程度封装的业务事件，可以统一放在ta_agent_fire模块。
%%% 2. 本系统引入一个特殊的系统临时字段'$time'
%%% $time为操作触发时间，在上报数据前将转换为TA系统的预置字段'#time'字符串
%%% @end
%%% @since 2021-05-18
%%% -------------------------------------------------------
-module(ta_agent).

-behaviour(gen_server).

%% TA上报相关API
-export([
        start_link/0
        ,track/3
        ,track/5
        ,track_raw/4
        ,track_raw/6
        ,track_raw/7
        ,user_set_once_raw/5
        ,user_set_once_raw/6
        ,user_set/2
        ,user_set/4
        ,user_set_once/2
        ,user_set_once/4
    ]).
%% TA数据设置API
-export([
        set_ta_base_with_key/3
        ,get_ta_spcl_data/2
    ]).

%% gen_server callbacks
-export([init/1,
        handle_call/3,
        handle_cast/2,
        handle_info/2,
        terminate/2,
        code_change/3
    ]).

%% for gm or debug
-export([
        gm_set_url/1
        ,gm_shutdown_test/0
        ,gm_get_app_id/0
    ]).

-compile({inline, [
            delay_key_list_add/2
            ,delay_key_list_store/2
            ,delay_key_list_del/2
            ,proc_put_delay_data/2
            ,proc_get_delay_data/1
            ,proc_erase_delay_data/1
        ]
    }).

-define(SERVER, ?MODULE).

-include("common.hrl").
-include("code_vsn.hrl").

-export_type([ ta_data/0, ta_val/0 ]).
-type(ta_val() :: binary()|atom()|integer()|boolean()|list()|ta_data()).
-type(ta_data() :: #{Key :: atom() => Data::ta_val()}).
-type(time_option() :: normal |
{at_time, Unixtime::non_neg_integer()} |
{delay, DelayMS :: non_neg_integer()} |
{delay_anew, DelayMS :: non_neg_integer()}).

%% 完整的上报数据结构示例：
%% （以erlang中的map描述，实际上报是个2层结构的json数据）
%% #{
%%      '#account_id' => RoleId,
%%      '#type' => track | user_set | ...,
%%      '#time' => <<"2021-05-22 18:08:00">>,
%%      '#ip' => <<"127.0.0.1">>,
%%      '#event_name' => '#type'为track时才有此字段,
%%      '#distinct_id' => 访客id，服务端通常略去，不上报此字段【仅创建和登录辅助做数据关联】
%%      '#uuid' => 数据唯一标识，暂时略去，不生成，不上报,
%%      properties => #{
%%          %% 公共属性在这里...
%%          arg1 => val1,
%%      }
%% }

%% -------------------------------------------------------------------
%% 代码分支关联设置 TA_APP_ID[本版本不支持 -if(Condition)，转化一下]

% -ifdef(CODE_BRANCH).

% -if(?CODE_BRANCH =:= stable2).
% %% 速游版
% -define(TA_APP_ID, 'undefined_appid').

% -elif(?CODE_BRANCH =:= stable_ly).
% %% 联运版
% -define(TA_APP_ID, 'undefined_appid').

% -else.
% %% 其他分支
% -define(TA_APP_ID, 'undefined_appid').
% -endif.

% -else.
% %% 未定义CODE_BRANCH
% -define(TA_APP_ID, 'undefined_appid').
% -endif.

%% 获取TA APP_ID
% -ifdef(CODE_BRANCH).             %% 是否开发环境
get_ta_app_id() ->
    if
        % 深海
        ?CODE_BRANCH == ?CODE_BRANCH_SHENHAI -> '5a4e187bdea6470381baff4d5e3d6cee';
        % 其他正式服分支
        ?CODE_BRANCH == ?CODE_BRANCH_OFFICIAL -> '5a4e187bdea6470381baff4d5e3d6cee';
        % 内网测试地址-体验服
        ?CODE_BRANCH == ?CODE_BRANCH_PRE_STABLE -> 'f60cf800d006441c9639f46e93b0c5d3';
        true -> 'f60cf800d006441c9639f46e93b0c5d3'
    end.
% -else.
% % 不存在
% get_ta_app_id() -> '5a4e187bdea6470381baff4d5e3d6cee'.
% -endif.

%% 代码分支关联设置 TA_APP_ID
-define(TA_APP_ID, get_ta_app_id()).

%% -------------------------------------------------------------------

%% -------------------------------------------------------------------
%% 正式服使用的数据上报地址
%% -------------------------------------------------------------------
%% form-data方式上传数据的地址
-define(TA_URL_SYNC_DATA, <<"https://ta.sydevlop.cn/sync_data">>).
% %% raw方式上传数据的地址
% -define(TA_URL_SYNC_JSON, "http://127.0.0.1/sync_json").
%% -------------------------------------------------------------------
% curl test:
% curl -k "http://ta.sydesvlop.cn/sync_data" --data "debug=1&appid=debug-appid&data=%7b%22%23account_id%22%3a%22testing%22%2c%22%23time%22%3a%222019-01-01+10%3a00%3a00.000%22%2c%22%23type%22%3a%22track%22%2c%22%23event_name%22%3a%22testing%22%2c%22properties%22%3a%7b%22test%22%3a%22test%22%7d%7d"
%% -------------------------------------------------------------------

%% -------------------------------------------------------------------
%% 开发版服务器默认不上报，
%% 测试时可以通过gm_set_url/1设置上报地址进行模拟测试，
%% 实际上只是将数据上报存储，以供查证，并不是真的上报到TA系统
%% -------------------------------------------------------------------
%% 内网测试页面，纯读取http请求中上传的requestBody，写入到文件供核实
-define(TA_URL_SYNC_DEBUG_INTERNAL, <<"http://192.168.66.213:8090/ta_agent_receiver.php">>).
%% 本机测试页面（稳定服部署了本机测试页面）
-define(TA_URL_SYNC_DEBUG_LOCAL, <<"http://127.0.0.1:8090/ta_agent_receiver.php">>).
%% -------------------------------------------------------------------

%% db缓存表中单行数据最多存储的待上报数量
%% 【db相关字段为text，最多存储64KB数据，预估存储10条数据足够富余】
-define(DB_PER_ROW_DATA_MAX, 10).
%% db单条语句批量插入的数量
-define(DB_PER_SAVE_MAX, 20).
%% db缓存表相关操作SQL
-define(SQL_TRUNC_WAIT_UPLOAD, <<"TRUNCATE TABLE `ta_agent_wait_upload`">>).
-define(SQL_SEL_WAIT_UPLOAD, <<"SELECT `type`,`data` FROM `ta_agent_wait_upload`">>).
-define(SQL_INSERT_WAIT_UPLOAD_PREFIX, <<"INSERT INTO `ta_agent_wait_upload` (`type`,`data`)">>).

-record(ta_state, {
        state_timer = undefined             % 定时器[公共定时器]
        ,upload_time = 0                    % 下一次上报时间[毫秒级时间戳]
        ,handle_response = 0                % 下一次检查响应结果的时间[毫秒级时间戳]
        ,cache_normal_queue = queue:new()   % 常规缓存池，以FIFO方式读写
        ,delay_key_list = []                % 延迟上报 Time-DataKey 的有序列表 [{Time, Key}]
        ,sync_url = <<>>                    % 上报地址，初始启动/手动设置
        ,branch = undefined                 % 分支名称
        ,testing = false                    % 是否测试【测试需上报branch参数】
    }).

%% 可更新缓存冲数据存储于进程字典中，停服时如果还未到上报时间则存储到db缓存表中
%% 其数据的key计算规则如下【$()表示取该属性值】
%% 1. 用户属性设置类
%%    Key = {user, $('#account_id'), ArgsMd5}
%%    args为所有非公共的属性key值sort后以“,”分隔拼接而成的binary值的md5值
%% 2. 事件类
%%    Key = {event, $('#account_id'), $('#event_name')}

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% 事件上报
%% 对应于TA系统的track
%% 何时使用：所有非用户属性设置
-spec track(PS, EventName, TrackData) -> ok | error when
    PS :: lib_player:player(),
    EventName :: atom(),
    TrackData :: ta_agent:ta_data().
track(PS, EventName, TrackData) ->
    track(PS, EventName, TrackData, normal, 0).

-spec track(PS, EventName, TrackData, PreOption, NowTime) -> ok | error when
    PS :: lib_player:player(),
    EventName :: atom(),
    TrackData :: ta_agent:ta_data(),
    PreOption :: time_option(),
    NowTime :: non_neg_integer().
track(PS, EventName, TrackData, PreOption, NowTime) when is_map(TrackData) ->
    TAType = 'track',
    sync_data(PS, TAType, EventName, TrackData, PreOption, NowTime).

%% 事件上报（原始数据接口）
%% 对应于TA系统的track
%% 与track接口的区别：
%% track接口，需要提供角色进程数据PS，自动提取事件的base_data和common_properties
%% track_raw接口则由调用者自行提供原始的数据，用于不方便提供角色完整数据的情况
%% 注意：
%% 能用track接口的情况下，直接用track接口，此接口仅供特殊情况使用。
%% 此接口不对数据是否完整做强校验约束，需要调用者保证，否则上报数据会缺失部分属性
%% Properties注意事项参考raw_to_agent接口的说明
track_raw(RoleId, EventName, Ip, Properties)  ->
    track_raw(RoleId, EventName, Ip, Properties, normal, 0).

track_raw(RoleId, EventName, Ip, Properties, PreOption, NowTime) ->
    track_raw(RoleId, EventName, Ip, Properties, undefined, PreOption, NowTime).

track_raw(RoleId, EventName, Ip, Properties, TaSpclData, PreOption, NowTime) ->
    TAType = 'track',
    Data = ta_agent_properties:raw_to_agent(RoleId, TAType, EventName, Ip, Properties, TaSpclData, NowTime),
    send_to_agent(Data, PreOption).

%% 本方法在其他事件之前就调用，会导致入库一条没有绑定账号和访客id的数据，所以必须调用 user_set_once_raw/6 来绑定
user_set_once_raw(RoleId, EventName, Ip, Properties, NowTime) ->
    TAType = 'user_setOnce',
    PreOption = normal,
    Data = ta_agent_properties:raw_to_agent(RoleId, TAType, EventName, Ip, Properties, undefined, NowTime),
    send_to_agent(Data, PreOption).

%% TaSpclData :: {TaSpclBase, TaSpclCommon}.
user_set_once_raw(RoleId, EventName, Ip, Properties, TaSpclData, NowTime) ->
    TAType = 'user_setOnce',
    PreOption = normal,
    Data = ta_agent_properties:raw_to_agent(RoleId, TAType, EventName, Ip, Properties, TaSpclData, NowTime),
    send_to_agent(Data, PreOption).

%% 设置用户属性
%% 对应于TA系统中的user_set
%% 何时使用：希望对用户属性进行设置，已经存在会覆盖，不存在则创建
%% 注意：这里用户属性的概念非指游戏中的用户属性，而是指TA系统中定义的用户属性，
%%      可以是游戏中用户的属性，也可以是用户的某些状态、某些固定信息等
-spec user_set(PS, SetData) -> ok | error when
    PS :: lib_player:player(),
    SetData :: ta_agent:ta_data().
user_set(PS, SetData) ->
    user_set(PS, SetData, normal, 0).

-spec user_set(PS, SetData, PreOption, NowTime) -> ok | error when
    PS :: lib_player:player(),
    SetData :: ta_agent:ta_data(),
    PreOption :: time_option(),
    NowTime :: non_neg_integer().
user_set(PS, SetData, PreOption, NowTime) when is_map(SetData) ->
    TAType = 'user_set',
    EventName = undefined,
    sync_data(PS, TAType, EventName, SetData, PreOption, NowTime).

%% 设置用户属性
%% 对应于TA系统中的user_setOnce
%% 何时使用：希望对用户属性进行初始化操作，如果TA中已经设置过则忽略（不覆盖）
%%     适用于只需要进行一次性初始化生成的数据类型
-spec user_set_once(PS, SetOnceData) -> ok | error when
    PS :: lib_player:player(),
    SetOnceData :: ta_agent:ta_data().
user_set_once(PS, SetOnceData) ->
    user_set_once(PS, SetOnceData, normal, 0).

-spec user_set_once(PS, SetOnceData, PreOption, NowTime) -> ok | error when
    PS :: lib_player:player(),
    SetOnceData :: ta_agent:ta_data(),
    PreOption :: time_option(),
    NowTime :: non_neg_integer().
user_set_once(PS, SetOnceData, PreOption, NowTime) when is_map(SetOnceData) ->
    TAType = 'user_setOnce',
    EventName = undefined,
    sync_data(PS, TAType, EventName, SetOnceData, PreOption, NowTime).

%% Ta的非必须基础属性和全局公共属性
%% -> TaSpclData :: {TaSpclBase, TaSpclCommon}.
get_ta_spcl_data(TaGuestId, TaDeviceId) ->
    ta_agent_properties:ta_spcl_data(TaGuestId, TaDeviceId).

%% 更新TA基础数据信息
set_ta_base_with_key(TaBaseOld, TaBaseKey, TaBaseVal) ->
    case ta_agent_properties:valid_ta_base_key(TaBaseKey) of
        true  ->
            TaBaseOld#{TaBaseKey => TaBaseVal};
        false ->
            TaBaseOld
    end.

%% 测试GM命令，用于手工调整上报地址，用于临时模拟测试
%% SetOption:
%%  internal : 使用内网地址上报（开发机部署的接收器）
%%  local    : 使用本机地址上报（本机部署的接收器）
%%  official : 使用正式地址上报（需要测试正式上报到TA系统时使用）
%%  revert   : 还原，将根据代码逻辑，还原原来的是否上报等状态
%%  直接设置上报地址，例如 <<"http://testhost/testreceiver">>等
gm_set_url(SetOption) ->
    NewSetOption =
    case SetOption of
        [$h,$t,$t,$p,$s,$:,$/,$/|_] -> unicode:characters_to_binary(SetOption);
        [$h,$t,$t,$p,$:,$/,$/|_]    -> unicode:characters_to_binary(SetOption);
        _ -> SetOption
    end,
    gen_server:cast(?SERVER, {gm_set_url, NewSetOption}).

%% 批量请求，关服测试
%% 【注意：操作后将关闭服务器，用于测试关服时会否批量上报及存储delay缓存池数据】
%% 【由于使用了虚假数据，不应往正式地址上报，只能在使用测试上报地址时进行调用测试】
%% 测试流程：
%% 1. 启动本地web receiver服务
%% cd server/src/thinkingdata
%% php -S 0.0.0.0:8090
%% 2. 设置使用local，并调用停服，观察数据库数据存在与否、是否正确
%% ta_agent:gm_set_url(local).
%% ta_agent:gm_shutdown_test().
%% 3. 在合适的时间内，重新启动后快速执行以下动作，观察数据正确与否，可适当开启日志打印
%%   【并在之后检查db数据是否已清空】
%% ta_agent:gm_set_url(local).
%% f(S), S = sys:get_state(whereis(ta_agent)).
%% f(D), {_, D} = erlang:process_info(whereis(ta_agent), dictionary).
gm_shutdown_test() ->
    %% 虚报在线数
    [ta_agent_fire:online_track(Seq, max(500-Seq, 0)) || Seq <- lists:seq(1, 25)],
    % 伪造delay缓存池数据，需要超过db单条保存数据的量，才能测试保存和加载多条db数据是否正常
    NowTime = utime:unixtime(),
    BaseDataPart = #{'#account_id' => 1, '#ip' => '127.0.0.1'},
    lists:foldl(fun(Seq, Acc) ->
                VPropKey = list_to_atom(lists:concat([v, Seq])),
                PreData = BaseDataPart#{'$time' => NowTime+Seq,
                    '#type' => user_set, properties => #{VPropKey => Seq}
                },
                send_to_agent(PreData, {delay,  15000 + Seq * 10000}),
                Acc
        end, [], lists:seq(1, ?DB_PER_ROW_DATA_MAX+1)),
    init:stop().

%% 查询TA_APP_ID的值
gm_get_app_id() ->
    ?TA_APP_ID.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    process_flag(trap_exit, true),
    Branch = config:get_branch(),
    {Testing, SyncUrl} = get_sync_url(Branch),
    NowTimeMS = utime:longunixtime(), % utime:unixtime(ms),
    {CacheNormalQueue, DelayKeyList} = load_ta_data(NowTimeMS),
    % ?INFO("load ta data:~p~n~p", [DelayKeyList, CacheNormalQueue]),
    NextUploadTime = next_upload_time(CacheNormalQueue, NowTimeMS),
    StateInit = #ta_state{
        sync_url = SyncUrl
        ,testing = Testing
        ,branch = Branch
        ,cache_normal_queue = CacheNormalQueue
        ,delay_key_list = DelayKeyList
        ,upload_time = NextUploadTime
        ,handle_response = 0
    },
    NewState = calc_state_timer(StateInit, NowTimeMS),
    truncate_ta_data(),
    {ok, NewState}.

handle_call(Request, From, State) ->
    try
        do_handle_call(Request, From, State)
    catch
        _ErrorClass:_Error ->
            ?ERR("handle_call Request:~w, _ErrorClass:~p Error:~w stacktrace:~p", [Request, _ErrorClass, _Error, erlang:get_stacktrace()]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    try
        do_handle_cast(Msg, State)
    catch
        _ErrorClass:_Error ->
            ?ERR("handle_call Msg:~w, _ErrorClass:~p Error:~w stacktrace:~p", [Msg, _ErrorClass, _Error, erlang:get_stacktrace()]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    try
        do_handle_info(Info, State)
    catch
        _ErrorClass:_Error ->
            ?ERR("handle_call Info:~w, _ErrorClass:~p Error:~w stacktrace:~p", [Info, _ErrorClass, _Error, erlang:get_stacktrace()]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    %% 关服快速上报数据（暂不考虑存储到db等待下次启动再上报）
    %% 【在监控树中，关服时应在踢玩家下线及关键数据存储进程关闭之后，
    %% 避免占用游戏数据存储时间，被运维强杀进程】
    #ta_state{
        cache_normal_queue = CacheNormalQueue
        ,sync_url = SyncUrl
        ,branch = Branch
        ,testing = Testing
        ,delay_key_list = DelayKeyList
    } = _State,
    %% 存储延迟上报的数据，等待下次启动服务器再上报
    db_save_all_delay(DelayKeyList),
    %% 上报所有cache_normal_queue中的数据
    ta_agent_upload:upload_all(CacheNormalQueue, SyncUrl, Branch, Testing, ?TA_APP_ID),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% handle_xxxx Internal functions
%%%===================================================================

do_handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% agent接收需要上报的数据，存储到缓存池中
%% 如果sync_url不符合条件【http地址】，则直接丢弃数据
do_handle_cast({data, PreData, PreOption}, State = #ta_state{sync_url = <<"http", _/binary>>}) ->
    % ?MYLOG("ta", "PreData:~p, PreOption:~p State:~p ~n", [PreData, PreOption, State]),
    case ta_agent_properties:verify_pre_data(PreData) of
        true  ->
            NowTimeMS = utime:longunixtime(), % utime:unixtime(ms),
            StateAddCache = add_cache(State, PreData, NowTimeMS, PreOption),
            NewState = calc_state_timer(StateAddCache, NowTimeMS),
            {noreply, NewState};
        false ->
            {noreply, State}
    end;

do_handle_cast({gm_set_url, SetOption}, State) ->
    #ta_state{branch = Branch} = State,
    {NewTesting, SetUrl} =
    case SetOption of
        internal -> {true, ?TA_URL_SYNC_DEBUG_INTERNAL};
        local    -> {true, ?TA_URL_SYNC_DEBUG_LOCAL};
        official -> {false, ?TA_URL_SYNC_DATA};
        revert   -> get_sync_url(Branch);
        <<"https://", _Rest/binary>> -> {true, SetOption};
        <<"http://", _Rest/binary>> -> {true, SetOption};
        _ -> {false, <<>>}
    end,
    ?INFO("gm_set_url,SetOption:[~p], SetUrl:[~p]", [SetOption, SetUrl]),
    NewState = State#ta_state{
        sync_url = unicode:characters_to_binary(SetUrl)
        ,testing = NewTesting
    },
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% 非外部伪造消息的情况下，
%% {state_timeout, OverTime}意味着已经达到或超过了OverTime，
%% 可以直接处理该时间之前的数据
do_handle_info({state_timeout, OverTime}, State = #ta_state{state_timer = Timer}) ->
    util:cancel_timer(Timer),
    NowTimeMS = utime:longunixtime(), % utime:unixtime(ms),
    StateTakeoutDelay = take_out_delay(State, NowTimeMS, OverTime),
    StateDoUpload = upload_pre_data(StateTakeoutDelay, NowTimeMS, OverTime),
    StateHandleResponse = check_response(StateDoUpload, NowTimeMS, OverTime),
    NewState = calc_state_timer(StateHandleResponse, NowTimeMS),
    {noreply, NewState};

do_handle_info({http, ReplyInfo}, State) ->
    % ?MYLOG("ta", "do ReplyInfo:~p", [ReplyInfo]),
    ta_agent_upload:http_reply(ReplyInfo),
    {noreply, State};

do_handle_info(_Info, State) ->
    {noreply, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% -------------------------------------------------------------------
%% 封装和上报数据到ta_agent的相关接口
%% -------------------------------------------------------------------

%% 将准备好的数据发送到agent中等待上报
%% PreOption:
%% {at_time, UploadTimeSeconds}     时间戳是个秒级时间戳
%% {delay, DelayMilliseconds}       延迟时间是毫秒级的
%% {delay_anew, DelayMilliseconds}  延迟时间是毫秒级的
sync_data(PS, TAType, EventName, Data, PreOption, NowTime) when is_map(Data) ->
    NewData = ta_agent_properties:pack_to_agent(PS, TAType, EventName, Data, NowTime),
    send_to_agent(NewData, PreOption).

%% 将数据发送给ta_agent服务
send_to_agent(Data, PreOption) when is_map(Data) ->
    gen_server:cast(?SERVER, {data, Data, PreOption});
send_to_agent(Error, _) ->
    Error.

%% -------------------------------------------------------------------
%% ta_agent中，缓存池数据新增、更新管理
%% -------------------------------------------------------------------

%% 将数据转换存储到对应缓存池
%% -> NewState
add_cache(State, PreData, NowTimeMS, normal) ->
    #ta_state{
        cache_normal_queue = CacheNormalQueue
        ,upload_time = UploadTime
    } = State,
    NewQueue = queue:in(PreData, CacheNormalQueue),
    %% 上报缓存池新增数据，外部需要触发upload的定时检查
    NewUploadTime =
    case UploadTime > 0 of
        true  -> UploadTime;
        false -> NowTimeMS + 3000
    end,
    State#ta_state{
        cache_normal_queue = NewQueue
        ,upload_time = NewUploadTime
    };
add_cache(State, PreData, NowTimeMS, PreOption) ->
    #{'$time' := Time} = PreData,
    %% 基于运营需要，在上传时，
    %% 应修改delay类型数据的'$time'值，为UploadTime对应的秒级时间，
    %% 在此之前临时存储的数据中$time仍为原始的数据时间
    case PreOption of
        {at_time, UploadTimeSecs} ->
            DataKey = get_delay_data_key(PreData),
            %% 触发时，直接设置新的上报时间
            case UploadTimeSecs > Time of
                true  ->    % 未到时间
                    UploadTime = UploadTimeSecs * 1000,
                    delay_data_store(State, UploadTime, DataKey, PreData);
                false ->    % 已经到达或超过时间
                    %% 尝试删除旧数据
                    OldPreData = proc_erase_delay_data(DataKey),
                    NewState =
                    case OldPreData of
                        undefined ->
                            State;
                        _ ->    % 存在旧数据
                            #ta_state{delay_key_list = OldDelayKeyList} = State,
                            NewDelayKeyList = delay_key_list_del(DataKey, OldDelayKeyList),
                            State#ta_state{delay_key_list = NewDelayKeyList}
                    end,
                    %% 直接加入到常规上报池
                    FixPreData = PreData#{'$time' => UploadTimeSecs},
                    add_cache(NewState, FixPreData, NowTimeMS, normal)
            end;
        {delay, DelayTimeMS} ->
            DataKey = get_delay_data_key(PreData),
            UploadTime = Time * 1000 + DelayTimeMS,
            delay_data_store_update(State, UploadTime, DataKey, PreData);
        {delay_anew, DelayTimeMS} ->
            DataKey = get_delay_data_key(PreData),
            UploadTime = Time * 1000 + DelayTimeMS,
            delay_data_store(State, UploadTime, DataKey, PreData);
        _Others ->
            add_cache(State, PreData, NowTimeMS, normal)
    end.

%% 获取延迟上报数据的key值
get_delay_data_key(#{
        '#type' := track
        ,'#account_id' := AccName
        ,'#event_name' := EventName
    }) ->
    {event, AccName, EventName};
get_delay_data_key(#{
        '#account_id' := AccName
        ,properties := Properties
    }) ->
    ArgsMd5 = md5_properties_keys(Properties),
    {user, AccName, ArgsMd5}.

%% 将属性排除公共属性之后，排序并以“,”拼接后计算md5值，以便于唯一标识一条相同的数据
md5_properties_keys(Properties) ->
    Keys = maps:keys(Properties),
    CommonList = data_ta_properties:get(common_properties),
    OtherList = Keys -- CommonList,
    SortedList = lists:sort(OtherList),
    BinKeyList = trans_keys(SortedList),
    erlang:md5(list_to_binary(BinKeyList)).

trans_keys([Key | List]) ->
    [atom_to_binary(Key, utf8), <<",">> | trans_keys(List)];
trans_keys([]) ->
    [].

%% 新增delay缓存数据
delay_data_add(State, UploadTime, DataKey, PreData) ->
    #ta_state{
        delay_key_list = DelayKeyList
    } = State,
    NewDelayKeyList = delay_key_list_add({UploadTime, DataKey}, DelayKeyList),
    proc_put_delay_data(DataKey, PreData),
    State#ta_state{
        delay_key_list = NewDelayKeyList
    }.

%% 检查delay缓存中有无旧值，无则存储，有则更新数据
delay_data_store(State, UploadTime, DataKey, PreData) ->
    #ta_state{
        delay_key_list = DelayKeyList
    } = State,
    case proc_get_delay_data(DataKey) of
        _OldPreData when is_map(_OldPreData) ->
            NewDelayKeyList = delay_key_list_store({UploadTime, DataKey}, DelayKeyList),
            proc_put_delay_data(DataKey, PreData),
            State#ta_state{
                delay_key_list = NewDelayKeyList
            };
        _Undefined ->
            delay_data_add(State, UploadTime, DataKey, PreData)
    end.

%% 检查delay缓存中有无旧值，无则存储，有则更新数据但是保留旧的上报时间
delay_data_store_update(State, UploadTime, DataKey, PreData) ->
    case proc_get_delay_data(DataKey) of
        _OldPreData when is_map(_OldPreData) ->
            proc_put_delay_data(DataKey, PreData),
            State;
        _Undefined ->
            delay_data_add(State, UploadTime, DataKey, PreData)
    end.

delay_key_list_add(AddTimeKey = {_UploadTime, _DataKey}, DelayKeyList) ->
    lists:sort([AddTimeKey | DelayKeyList]).

delay_key_list_store(AddTimeKey = {_UploadTime, DataKey}, DelayKeyList) ->
    lists:sort([AddTimeKey | delay_key_list_del(DataKey, DelayKeyList)]).

delay_key_list_del(DataKey, DelayKeyList) ->
    lists:keydelete(DataKey, 2, DelayKeyList).

%% -> OldValue | undefined.
proc_put_delay_data(DataKey, PreData) ->
    erlang:put(DataKey, PreData).

%% -> Value | undefined.
proc_get_delay_data(DataKey) ->
    erlang:get(DataKey).

%% -> Value | undefined.
proc_erase_delay_data(DataKey) ->
    erlang:erase(DataKey).

%% -------------------------------------------------------------------
%% ta_agent中，缓存池数据的移动、消费管理
%% -------------------------------------------------------------------

%% 根据时间，消费delay缓存池的数据
take_out_delay(State, NowTimeMS, OverTime) ->
    #ta_state{
        delay_key_list = DelayKeyList
    } = State,
    case DelayKeyList of
        [{TimeMS, _DataKey} | _] when TimeMS =< OverTime ->
            %% 有需要处理的数据
            {NewDelayKeyList, OverList} =
            take_out_delay_data(DelayKeyList, OverTime, []),
            %% 添加数据到cache_normal_queue
            StateTmp = lists:foldl(fun(PreData, StateAcc) ->
                        add_cache(StateAcc, PreData, NowTimeMS, normal)
                end, State, OverList),
            StateTmp#ta_state{
                delay_key_list = NewDelayKeyList
            };
        _ ->    %% 无需要处理的数据，或未到时间
            State
    end.

take_out_delay_data([{TimeMS, DataKey} | DelayKeyList],
    OverTime, OverList) when TimeMS =< OverTime ->
    PreData = proc_erase_delay_data(DataKey),
    NewOverList =
    case PreData of
        undefined ->
            OverList;
        _ ->
            %% 根据运营需要，delay类型的，替换$time为UploadTime
            FixPreData = PreData#{'$time' => TimeMS div 1000},
            [FixPreData | OverList]
    end,
    take_out_delay_data(DelayKeyList, OverTime, NewOverList);
take_out_delay_data(DelayKeyList, _OverTime, OverList) ->
    {DelayKeyList, OverList}.

%% 上报缓存数据【消费cache_normal_queue数据】
upload_pre_data(State, NowTimeMS, OverTime) ->
    #ta_state{
        cache_normal_queue = CacheNormalQueue
        ,handle_response = HandleResponse
        ,sync_url = SyncUrl
        ,branch = Branch
        ,testing = Testing
        ,upload_time = UploadTime
    } = State,
    if
        UploadTime > OverTime ->    %% 未到上传时间
            State;
        UploadTime =:= 0 ->         %% 无上传需求
            State;
        true ->
            NewCacheNormalQueue = ta_agent_upload:do_upload(CacheNormalQueue, SyncUrl, Branch, Testing, ?TA_APP_ID),
            NextUploadTime = next_upload_time(NewCacheNormalQueue, NowTimeMS),
            %% 可能发生了上报请求，触发handle_response的定时检查
            NewHandleResponse =
            case HandleResponse > 0 of
                true  -> HandleResponse;
                false -> NowTimeMS + 3000
            end,
            State#ta_state{
                upload_time = NextUploadTime
                ,cache_normal_queue = NewCacheNormalQueue
                ,handle_response = NewHandleResponse
            }
    end.

next_upload_time(CacheNormalQueue, NowTimeMS) ->
    CacheNormalLen = queue:len(CacheNormalQueue),
    Timeout =
    if
        CacheNormalLen >= 1000  -> 0;
        CacheNormalLen >= 500   -> 100;
        CacheNormalLen >= 200   -> 500;
        CacheNormalLen > 0      -> 3000;
        %% 上报队列为空
        true -> false
    end,
    case Timeout of
        false ->
            %% 当上报队列处理完，置0以确保配合计算逻辑可以中止定时器
            0;
        _ ->
            NowTimeMS + Timeout
    end.

%% 检查回应数据
check_response(State, NowTimeMS, OverTime) ->
    #ta_state{
        handle_response = HandleResponse
        ,sync_url = SyncUrl
    } = State,
    if
        HandleResponse > OverTime ->    %% 未到时间
            State;
        HandleResponse =:= 0 ->         %% 无重试需求
            State;
        true ->
            RemainList = ta_agent_upload:handle_response(SyncUrl),
            %% 当所有请求回应都处理完，置0以确保定时器可以中止
            NewHandleResponse = case RemainList of
                [_|_] -> NowTimeMS + 3000;
                _ -> 0
            end,
            State#ta_state{
                handle_response = NewHandleResponse
            }
    end.

%% -------------------------------------------------------------------
%% 定时器管理
%% -------------------------------------------------------------------
%% 定时器触发超时事件时，会依次检查三类业务是否需要执行：
%% 1. upload_time时间是否已经达到，达到则需要执行批量上报cache_normal_queue中的部分数据
%% 2. handle_response时间是否已经达到，达到则需要执行对request_list结果的检查，有失败的需要重试
%% 3. delay cache中的数据是否有需要移动到normal cache【查看delay_key_list中的首个时间】
%% -------------------------------------------------------------------

%% 定时器计算
%% 为防止因消息阻塞及执行延时导致的时间过期，
%% 当使用完毕时，如果不存在新的时间，upload_time、handle_response应重新置0，
%% 方便判断是否要进行后续的上报、重试之类操作，在不需要时可以中止定时器
calc_state_timer(State, NowTimeMS) ->
    #ta_state{
        state_timer = OldStateTimer
        ,upload_time = NextUploadTime
        ,handle_response = NextHandleResponse
        ,delay_key_list = DelayKeyList
    } = State,
    util:cancel_timer(OldStateTimer),
    NextDelayCheck =
    case DelayKeyList of
        [{Time, _DataKey} | _] -> Time;
        _ -> 0
    end,
    FutureTime = find_next_check([NextUploadTime, NextHandleResponse, NextDelayCheck], NowTimeMS),
    if
        FutureTime =:= 0 ->
            State#ta_state{state_timer = undefined};
        FutureTime > NowTimeMS ->
            Timeout = FutureTime - NowTimeMS,
            Msg = {state_timeout, FutureTime},
            Timer = erlang:send_after(Timeout, ?SERVER, Msg),
            State#ta_state{state_timer = Timer};
        true ->
            Msg = {state_timeout, NowTimeMS},
            erlang:send(?SERVER, Msg),
            State#ta_state{state_timer = undefined}
    end.

%% 计算下一个未来时间
%% 如果等于NowTimeMS，立即触发相关数据上报等业务逻辑操作
%% 如果为0，则说明缓存池已经空，可以中止定时器
%% 如果是未来时间，则产生定时器
find_next_check(CheckTimeList, NowTimeMS) ->
    find_next_check_2(CheckTimeList, NowTimeMS, 0).
find_next_check_2([], _NowTime, MinFutureTime) ->
    MinFutureTime;
find_next_check_2([TimeX | TimeList], NowTimeMS, MinFutureTime) ->
    if
        TimeX =:= 0 ->
            find_next_check_2(TimeList, NowTimeMS, MinFutureTime);
        TimeX =< NowTimeMS ->
            NowTimeMS;
        MinFutureTime =:= 0 ->
            find_next_check_2(TimeList, NowTimeMS, TimeX);
        TimeX < MinFutureTime ->
            find_next_check_2(TimeList, NowTimeMS, TimeX);
        true ->
            find_next_check_2(TimeList, NowTimeMS, MinFutureTime)
    end.

%% -------------------------------------------------------------------
%% 其他杂项基础接口
%% -------------------------------------------------------------------

%% 初始化sync_url
%% -> {Testing, SyncUrl}
get_sync_url(Branch) ->
    % IsDebug = config:get_server_debug(),
    %% 2022-07-25 12:00:00 开放上传测试 @启杰
    % case utime:unixtime() =< 1658678400 of
    %     true -> IsDevp = false;
    %     false -> IsDevp = lib_vsn:is_sy_internal_devp()
    % end,
    IsDevp = lib_vsn:is_sy_internal_devp(),
    IsCN = lib_vsn:is_cn(),
    case {IsDevp, IsCN} of
        {false, true}  -> {false, ?TA_URL_SYNC_DATA};
        {false, false} -> {false, <<>>};
        %% 以下为非正式服版本
        _ ->
            %% 开发服、体验服分支，需要模拟上报，
            %% 其他开发/稳定的版本，不需要上报
            case lists:member(Branch, [develop]) of
                true  -> {true, ?TA_URL_SYNC_DEBUG_INTERNAL};
                false ->
                    case lists:member(Branch, [pre_stable]) of
                        true -> {true, ?TA_URL_SYNC_DEBUG_LOCAL};
                        false -> {false, <<>>}
                    end
            end
    end.

%% 在加载数据完成后，需要清空db缓存表中的数据
truncate_ta_data() ->
    Sql = ?SQL_TRUNC_WAIT_UPLOAD,
    db:execute(Sql).

%% -> {CacheNormalQueue, DelayKeyList}
%% CacheNormalQueue: 正常上报数据【含已超出上报时机的延迟事件】
%% DelayKeyList : 尚未过期，需要添加到可更新缓存池的事件Key【事件已经存储到进程字典】
load_ta_data(NowTimeMS) ->
    Sql = ?SQL_SEL_WAIT_UPLOAD,
    DataList = db:get_all(Sql),
    conv_to_cache(DataList, NowTimeMS).

conv_to_cache(DataList, NowTimeMS) ->
    conv_to_cache_2(DataList, queue:new(), [], NowTimeMS).

conv_to_cache_2([[Type, DataBin] | RemainList], CacheNormalQueue, DelayKeyList, NowTimeMS) ->
    case Type of
        1 ->    % normal事件
            NewCacheNormalQueue =
            case util:bitstring_to_term(DataBin) of
                [_|_] = DL ->
                    lists:foldl(fun(PreData, CacheAcc) ->
                                queue:in(PreData, CacheAcc)
                        end, CacheNormalQueue, DL);
                _ ->    % 无数据或数据损坏
                    CacheNormalQueue
            end,
            conv_to_cache_2(RemainList, NewCacheNormalQueue, DelayKeyList, NowTimeMS);
        2 ->    % delay事件
            {NewCacheNormalQueue, NewDelayKeyList} =
            case util:bitstring_to_term(DataBin) of
                [_|_] = DL ->
                    lists:foldl(fun({UploadTime, PreData}, {CacheAcc, KeyAcc}) ->
                                case UploadTime > NowTimeMS of
                                    true  ->    % 未到时间的，继续加入延迟事件
                                        DataKey = get_delay_data_key(PreData),
                                        proc_put_delay_data(DataKey, PreData),
                                        NewKeyAcc = [{UploadTime, DataKey} | KeyAcc],
                                        {CacheAcc, NewKeyAcc};
                                    false ->    % 已到时间的，加入常规事件，避免被更新替换
                                        NewCacheAcc = queue:in(PreData, CacheAcc),
                                        {NewCacheAcc, KeyAcc}
                                end;
                            (_, Acc) -> % 无效数据
                                Acc
                        end, {CacheNormalQueue, DelayKeyList}, DL);
                _ ->    % 无数据或数据损坏
                    {CacheNormalQueue, DelayKeyList}
            end,
            conv_to_cache_2(RemainList, NewCacheNormalQueue, NewDelayKeyList, NowTimeMS);
        _ ->    % 错误数据
            conv_to_cache_2(RemainList, CacheNormalQueue, DelayKeyList, NowTimeMS)
    end;
conv_to_cache_2([], CacheNormalQueue, DelayKeyList, _NowTimeMS) ->
    %% DelayKeyList按时间排序
    NewDelayKeyList = lists:sort(DelayKeyList),
    {CacheNormalQueue, NewDelayKeyList}.

%% 写入数据
db_save_all_delay(DelayKeyList) ->
    {_, DbRowDataAcc} =
    lists:foldl(fun({UploadTime, DataKey}, {DataOrder, Acc}) ->
                case proc_get_delay_data(DataKey) of
                    Data when is_map(Data) ->
                        NewDataOrder = DataOrder + 1,
                        NewAcc =
                        case DataOrder rem ?DB_PER_ROW_DATA_MAX =:= 1 of
                            true  ->    % 产生新的单条数据
                                DbRowData = [{UploadTime, Data}],
                                [DbRowData | Acc];
                            false ->    % 延续添加到上一条数据
                                [Old | Remain] = Acc,
                                DbRowData = [{UploadTime, Data} | Old],
                                [DbRowData | Remain]
                        end,
                        {NewDataOrder, NewAcc};
                    _Undefined ->
                        {DataOrder, Acc}
                end
        end, {1, []}, DelayKeyList),
    %% 这里存储的都是type为2的delay数据
    FmtFun = fun(DbRowData) ->
            DbRowDataStr = util:term_to_string(DbRowData),
            util:fmt_bin("(2,~ts)", [mysql:encode(DbRowDataStr)])
    end,
    % ?INFO("save data of DelayKeyList:~p", [DelayKeyList]),
    db_save_delay_batch(DbRowDataAcc, FmtFun).

db_save_delay_batch(DbRowDataList = [_|_], FmtFun) ->
    {PreList, TailList} = ulists:split(?DB_PER_SAVE_MAX, DbRowDataList),
    SqlPrefix = ?SQL_INSERT_WAIT_UPLOAD_PREFIX,
    % ?INFO("save_data_list:~p", [PreList]),
    udb:save_data_list(PreList, SqlPrefix, FmtFun),
    db_save_delay_batch(TailList, FmtFun);
db_save_delay_batch(_, _) ->
    ok.

