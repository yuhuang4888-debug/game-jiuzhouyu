%%%--------------------------------------
%%% @Module  : pp_login
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.04.29
%%% @Description:  注册登录系统
%%%--------------------------------------
-module(pp_login).
-export([handle/3, check_heart_time/2]).
-include("server.hrl").
-include("unite.hrl").
-include("record.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("login.hrl").

-ifdef(DEV_SERVER).
-define(GET_BETA_RECHARGE_EVER, true).
-else.
-define(GET_BETA_RECHARGE_EVER, false).
-endif.

%%记录用户初始数据
-record(player, {
        socket = none,      % socket
        pid = none,         % 玩家进程
        login  = 0,         % 是否登录
        enter = 0,          % 是否进入角色
        accid  = 0,         % 账户id
        accname = none,     % 账户名
        timeout = 0,        % 超时次数
        req_count = 0,      % 请求次数
        req_list = [],      % 请求列表
        ids = [],           % 记录帐号id列表
        req_time = 0,       % 请求时间
        trans_mod = undefined, % 网络模块
        proto_mod = undefined  % 协议解析模块
    }).


%% 帐号登陆验证
handle(10000, Player, [Accid, AccName, Tstamp, TK]) when is_record(Player, player) ->
    case is_bad_pass(Accid, AccName, Tstamp, TK) of
        true ->
            % ?INFO("{Accid, AccName, Tstamp, TK}:~p ~n", [{Accid, AccName, Tstamp, TK}]),
            %% 取选择最小人数的职业来返回
            Career = 1,
            RoleList = lib_login:get_role_list(Accid, AccName),
            Now = utime:longunixtime(),
            OpenTime = util:get_open_time(),
            RegPlayerNum = lib_server_kv:get_server_kv(?SKV_REG_PLAYER_NUM),
            {ok, BinData} = pt_100:write(10000, [Career, Now, OpenTime, RegPlayerNum, RoleList]),
            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
            Ids = [Id||[Id |_ ] <- RoleList],
            {ok, Player#player{login = 1, accid = Accid, accname = AccName, ids = Ids}};
        false ->
            {ok, Player}
    end;

%% 帐号登陆验证容错
handle(10000, Player, _) when is_record(Player, player_status) ->
    ok;

%%% 创建角色
handle(10003, Player, [Realm, Career, Sex, Name, Source, InviteId, AccNameSdk, TaGuestId, SimulatorFlag, TaDeviceId, IschangeCareer, IsChangeName]) when is_record(Player, player)->
    #player{accid=Accid, accname=AccName, login=Login, socket=Socket, ids=Ids} = Player,
    % ?INFO("{TaGuestId, SimulatorFlag, TaDeviceId, IschangeCareer, IsChangeName}:~p ~n", [{TaGuestId, SimulatorFlag, TaDeviceId, IschangeCareer, IsChangeName}]),
    IsAccName = is_list(AccName),
    IsName = is_list(Name),
    if
        Login =/= 1 -> %% 登录状态不行
            ?ERR("~p ~p Login:~p~n", [?MODULE, ?LINE, [Login]]),
            {ok, BinData} = pt_100:write(10003, [9, 0]),
            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData);
        IsAccName == false ->
            ?ERR("~p ~p IsAccName:~p~n", [?MODULE, ?LINE, [IsAccName, AccName]]),
            {ok, BinData} = pt_100:write(10003, [10, 0]),
            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData);
        IsName == false ->
            ?ERR("~p ~p IsName:~p~n", [?MODULE, ?LINE, [IsName, Name]]),
            {ok, BinData} = pt_100:write(10003, [11, 0]),
            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData);
        true ->
            IP = tool:get_ip(Player#player.trans_mod, Socket),
            case check_ip_limit(IP) of
                true ->
                    case lib_player:validate_name(Name) of  %% 角色名合法性检测
                        {false, Msg} ->
                            {ok, BinData} = pt_100:write(10003, [Msg, 0]),
                            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData);
                        true ->
                            case catch lib_login:create_role(Accid, AccName, AccNameSdk, Name, Realm, Career, Sex, IP, Source) of
                                0 ->
                                    %%角色创建失败
                                    {ok, BinData} = pt_100:write(10003, [0, 0]),
                                    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData);
                                Id when is_integer(Id) ->
                                    lib_invite_api:upload_new_inivtee(Ids, InviteId, Id, Name, Accid, AccName, 1, Career, Sex),
                                    %%创建角色成功
                                    {ok, BinData} = pt_100:write(10003, [1, Id]),
                                    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                                    %% 回归登录活动
                                    lib_create_role_act:send_reward(Id),
                                    lib_custom_create_gift:send_reward_email(Id),
                                    IsChooseCareer = ?IF(IschangeCareer == 0, 0, 1),
                                    %% 创角事件上报
                                    ta_agent_fire:create_role([Id, IP, AccName, Name, SimulatorFlag,
                                        IsChooseCareer, IsChangeName, Source, Career,
                                        TaGuestId, TaDeviceId
                                    ]),
                                    {ok, Player#player{ids=[Id | Ids ]}};
                                Error ->
                                    %%角色创建失败
                                    {ok, BinData} = pt_100:write(10003, [0, 0]),
                                    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                                    ?ERR("pp_login 10003 create_role error accid(~w), accname(~s), ~p",
                                         [Accid, AccName, Error])
                            end
                    end;
                false ->
                    {ok, BinData} = pt_100:write(10003, [2, 0]),
                    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData)
            end
    end;

%% 角色登录
handle(10004, Player, [Id, ServerName, Time, Ticket, RegSId, CSource0, AccNameSdk, IsWhite, TaGuestId, SimulatorFlag, TaDeviceId, WxScene]) when Player#player.login == 1 ->
    #player{socket = Socket, accname = AccName, accid = AccId, ids=Ids, trans_mod=TransMod, proto_mod=ProtoMod} = Player,
    %% ?PRINT("10004 ~p~n", [[Id, Time, Ticket]]),
    case lists:member(Id, Ids) of
        false ->
            {ok, BinData} = pt_590:write(59004, 9),
            ?ERR("59004_err:~p~n", [[AccName, AccId, Ids, Id, 59004, 9]]),
            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
            ok;
        true ->
            CheckEncrypt = util:check_char_encrypt(Id, Time, Ticket),
            % 跟渠道一致
            CSourceLenValid = util:check_length(CSource0, 100),
            CSource = case CSourceLenValid of
                true -> CSource0;
                false -> ""
            end,
            if
                CheckEncrypt == false ->
                    ?ERR("59004_err:~p~n", [[Id, 59004, 9]]),
                    {ok, BinData} = pt_590:write(59004, 9),
                    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                    {ok, Player};
                true ->
                    IsMaintain = lib_login:check_game_maintain(),
                    IsServerLimit = lib_login:check_server_login_limit(),
                    %% 获取IP
                    Ip = tool:get_ip(Player#player.trans_mod, Socket),
                    case mod_ban:check(Id, Ip) of
                        _ when (IsMaintain orelse IsServerLimit) andalso IsWhite == 0 ->
                            % 服务器维护中并且不是白名单
                            {ok, BinData} = pt_590:write(59004, 11),
                            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                            {ok, Player};
                        passed -> %% 通过验证
                            % case mod_login:login([Id, AccId, AccName, AccNameSdk, ServerName, Ip, Socket, Ids, RegSId, CSource, TransMod, ProtoMod, TaGuestId, SimulatorFlag > 0, TaDeviceId]) of
                            LoginParams = #login_params{
                                id = Id, accid = AccId, accname = AccName, accname_sdk = AccNameSdk, server_name = ServerName, ip = Ip, socket = Socket, ids = Ids, reg_server_id = RegSId,
                                c_source = CSource, trans_mod = TransMod, proto_mod = ProtoMod, ta_guest_id = TaGuestId, ta_device_id = TaDeviceId, is_simulator = (SimulatorFlag > 0),
                                wx_scene = WxScene
                            },
                            case mod_login:login(LoginParams) of
                                {error, MLR} ->
                                    ?ERR("59004_err:~p~n", [[Id, 59004, MLR]]),
                                    %%告诉玩家登陆失败
                                    {ok, BinData} = pt_590:write(59004, MLR),
                                    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                                    {ok, Player};
                                {ok, Pid} ->
                                    mod_onhook_agent:remove_out_onhook(Id),
                                    {ok, BinData} = pt_100:write(10004, 1),
                                    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                                    %% 进入逻辑处理
                                    {ok, enter, Player#player{pid = Pid}}
                            end;
                        login_more ->
                            {ok, BinData} = pt_590:write(59004, 2),
                            ?ERR("59004_err:~p~n", [[Id, 59004, 2]]),
                            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                            {ok, Player};
                        forbidall -> %% 所有账号登陆都被禁止
                            {ok, BinData} = pt_590:write(59004, 10),
                            ?ERR("59004_err:~p~n", [[Id, 59004, 10]]),
                            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                            {ok, Player};
                        forbidip ->  %% IP被封
                            ?ERR("59004_err:~p~n", [[Id, 59004, 3]]),
                            {ok, BinData} = pt_590:write(59004, 3),
                            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                            {ok, Player};
                        _R -> %% 未定义
                            ?ERR("59004_err:~p~n", [[Id, 59004, 9, _R]]),
                            {ok, BinData} = pt_590:write(59004, 9),
                            send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
                            {ok, Player}
                    end
            end
    end;

%% 容错
handle(10004, Player, _) when is_record(Player, player_status) ->
    {ok, BinData} = pt_100:write(10004, 1),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok;

%% 登录心跳包
handle(10006, Player, _R) when is_record(Player, player) ->
    {ok, BinData} = pt_100:write(10006, []),
    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData);

%% 进入游戏后心跳包
handle(10006, Status, _) when is_record(Status, player_status) ->
    Time = utime:longunixtime(),
    {T, N} = case get("pp_base_heartbeat_last_time") of
                 undefined->
                     {0, 0};
                 _T ->
                     _T
             end,
    case Time - T < 4800 of
        true when N >= 9 -> %% 10次必踢
            erase("pp_base_heartbeat_last_time"),
            {ok, BinData} = pt_590:write(59004, 4),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData),
            %% 使用外挂直接断开关闭socket
            self() ! {'limit_login', Status#player_status.id, ?LOGOUT_LOG_WAIGUA},
            ok;
        true ->
            put("pp_base_heartbeat_last_time", {Time, N+1}),
            skip;
        false ->
            put("pp_base_heartbeat_last_time", {Time, 0}),
            skip
    end,
    %% 心跳包
    {ok, BinData2} = pt_100:write(10006, []),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData2),
    %% 速度修正包
    %% lib_player:speed_check(Status),
    ok;

%%% 随机姓名验证
%%% 客户端产生的随机姓名验证
handle(10007, Player, [Name]) when is_record(Player, player)->
    IsName = is_list(Name),
    if
        IsName == false -> Msg = 0;
        true ->
            case lib_player:validate_name(Name) of  %% 角色名合法性检测
                {false, Msg} -> skip;
                true -> Msg = 1
            end
    end,
    {ok, BinData} = pt_100:write(10007, [Msg]),
    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
    ok;
handle(10007, Player, _) when is_record(Player, player_status) ->
    ok;

%% 容错
handle(10008, Player, _) when is_record(Player, player_status) ->
    ok;
%%% 在选服后，进入游戏时，获取封测期间充值信息
handle(10008, Player, [Source]) when is_record(Player, player)->
    if
        Player#player.ids == [] orelse ?GET_BETA_RECHARGE_EVER ->
            {HadReturn, Gold, ReturnGold} = lib_beta_recharge_return:get_beta_recharge_info(Player#player.accid, Player#player.accname, Source),
            Msg = [HadReturn, Gold, ReturnGold];
        true ->
            Msg = [0, 0, 0]
    end,
    {ok, BinData} = pt_100:write(10008, Msg),
    send_one(Player#player.trans_mod, Player#player.proto_mod, Player#player.socket, BinData),
    ok;

handle(_Cmd, _Status, _Data) ->
    {error, "pp_login no match"}.

%%% ------------ 私有函数 --------------
%%%通行证验证
is_bad_pass(_Accid, _Accname, _Tstamp, _TK) -> true.
%% TICKET = config:get_ticket(),
%% Hex = util:md5(lists:concat([Accid, Accname, Tstamp, TICKET])),
%% E = utime:unixtime() - Tstamp,
%% E < 300 andalso Hex =:= TK. %%失效时间

%% 检查心跳包发送的频率
check_heart_time(NowTime, LimTime) ->
    case get("pp_base_heartbeat_last_time") of
        undefined->
            put("pp_base_heartbeat_last_time", {0, 0}),
            false;
        {T, _} ->
            NowTime - T > LimTime
    end.

%% 检查IP注册量限制数量50,需要添加请直接在代码里修改
%% return true 通过,false 不通过
check_ip_limit(Ip)->
    TICKET = config:get_ticket(),
    case TICKET =:= "SDFSDESF123DFSDF" of
        true  -> true;
        false ->
            case mod_ban:check_bai(Ip) of
                true -> true;
                _ ->
                    SQL  = io_lib:format("SELECT COUNT(*) FROM player_login WHERE reg_ip = '~s'", [tool:ip2bin(Ip)]),
                    case db:get_one(SQL) of
                        null ->
                            true;
                        Times ->
                            case Times >= 5000 of
                                true  -> false;
                                false -> true
                            end
                    end
            end
    end.

%% 对soket进行发送
send_one(TransMod, ProtoMod, Socket, Bin) ->
    SendB = ProtoMod:pack(Bin),
    TransMod:send(Socket, SendB).
