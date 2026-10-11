%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_gm

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/5/7 0007
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_fake_client_gm).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("login.hrl").
-compile(export_all).

apply_cast_all_fake(M, F, A) ->
    Onlines = ets:tab2list(?ETS_ONLINE),
    [Pid ! {fake_client, M, F, A}||#ets_online{pid = Pid} <- Onlines],
    ok.

%%============================================== GM ==========================================================
%% ---------------------------gm创建账号---------------------------------
%% 制定数量指定等级
gm_create_robot_account(Num, Lv) ->
    Sql = "select accid from player_login where accname like 'robot%' order by accid desc limit 1",
    AccIdL = case db:get_row(Sql) of
                 [MaxAccId] when MaxAccId > Num -> [];
                 [MaxAccId] ->
                     lists:seq(MaxAccId + 1, Num);
                 _ ->
                     lists:seq(1, Num)
             end,
    CareerList = [{?SOLDIER, 1}, {?SWORDGIRL, 2}, {?KNIGHT, 1}, {?ARCHER, 2}],
    F = fun(AccId) ->
        timer:sleep(1000),
        {Career, Sex} = urand:list_rand(CareerList),
        AccName = lists:concat(["robot", AccId]),
        create_robot_account_do(AccId, AccName, AccName, Career, Sex, Lv)
        end,
    lists:foreach(F, AccIdL).

create_robot_account_do(AccId, AccName, RoleName, Career, Sex, Lv) ->
    case lib_login:create_role(AccId, AccName, "", RoleName, 0, Career, Sex, "", "fake_client") of
        0 -> skip;
        RoleId ->
            db:execute(io_lib:format(<<"update `player_low` set lv = ~w where id=~w ">>, [Lv, RoleId])),
            after_create_account_do(RoleId)
    end.
%% 创建账号后续操作
after_create_account_do(RoleId) ->
    gm_start_fake_client_id(RoleId),
    Pid = misc:get_player_process(RoleId),
    % 1.升一级
    Pid ! {mod, ?MODULE, robot_level_up, [1]},
    % 2.完成主线任务
    Pid ! {mod, ?MODULE, robot_complete_task, []},
    % 下线
    Pid ! {mod, ?MODULE, close_fake_client2, []},
    ok.

robot_level_up(PS, AddLv) ->
    F = fun(_, TmpStatus) ->
        Exp = max(0, data_exp:get(TmpStatus#player_status.figure#figure.lv) - TmpStatus#player_status.exp),
        UpExpStatus = lib_player:add_exp(TmpStatus, Exp, ?ADD_EXP_GM, []),
        {ok, UpExpStatus}
        end,
    {ok, UpLvPS} = util:for(PS#player_status.figure#figure.lv, min(999999,PS#player_status.figure#figure.lv+AddLv-1), F, PS),
    UpLvPS.
robot_complete_task(PS) ->
    TaskArgs = lib_task_api:ps2task_args(PS),
    spawn(fun() ->
        case mod_task:finish_lv_task(PS#player_status.tid, TaskArgs, 0, 9999999) of
            LastTaskId when is_integer(LastTaskId) ->
                lib_player:update_player_info(PS#player_status.id, [{last_task_id, LastTaskId}]);
            _ -> ok
        end
    end).


%% ---------------------------gm登录fake_client---------------------------------
%% @params RoleNum 登录人数
%% @params Lv 等级筛选
gm_start_fake_client(RoleNum, Lv) ->
    RoleInL = [RoleId||#ets_online{id = RoleId} <- ets:tab2list(?ETS_ONLINE)],
    %% 数量不太真实 accid accname 相同时会顶号
    case RoleInL of
        [] ->
            Condition =  "WHERE" ++ io_lib:format(" player_low.lv > ~p and player_login.accname like 'robot%'", [Lv]) ++ usql:limit(RoleNum);
        _ ->
            Condition =  "WHERE player_login.id NOT IN (" ++ usql:v_column_list(RoleInL) ++ ")" ++ io_lib:format(" and player_low.lv > ~p and player_login.accname like 'robot%'", [Lv]) ++ usql:limit(RoleNum)
    end,
    Sql = io_lib:format("select player_login.id, player_login.accid, player_login.accname, player_login.last_login_ip from player_login inner join player_low on player_low.id = player_login.id ~s", [Condition]),
    List = db:get_all(Sql),
    gm_start_fake_client_do(List).

%% ---------------------------gm登录fake_client---------------------------------
%% @params RoleNum 登录人数
%% @params Lv 等级筛选
gm_start_fake_client(RoleNum, Lv, Career, Sex) ->
    RoleInL = [RoleId||#ets_online{id = RoleId} <- ets:tab2list(?ETS_ONLINE)],
    %% 数量不太真实 accid accname 相同时会顶号
    case RoleInL of
        [] ->
            Condition =  "WHERE" ++ io_lib:format(" player_low.lv > ~p and player_login.accname like 'robot%'", [Lv]) ++ usql:limit(RoleNum);
        _ ->
            Condition =  "WHERE player_login.id NOT IN (" ++ usql:v_column_list(RoleInL) ++ ")" ++ io_lib:format(" and player_low.lv > ~p and player_login.accname like 'robot%'", [Lv]) ++ usql:limit(RoleNum)
    end,
    Sql = io_lib:format("select player_login.id, player_login.accid, player_login.accname, player_login.last_login_ip from player_login inner join player_low on player_low.id = player_login.id and player_low.career = ~p and player_low.sex = ~p ~s", [Career, Sex, Condition]),
    List = db:get_all(Sql),
    gm_start_fake_client_do(List).

%% ---------------------------gm登录fake_client---------------------------------
%% 根据角色ID进行登录
gm_start_fake_client_id(RoleId) ->
    Sql = io_lib:format(<<"select id, accid, accname, accname_sdk, last_login_ip from player_login where id = ~p">>, [RoleId]),
    case db:get_row(Sql) of
        [RoleId, AccId, AccName, AccSDK, IP] ->
            gm_start_fake_client_do([[RoleId, AccId, AccName, AccSDK, IP]]);
        _E -> ?PRINT("_E ~p ~n", [_E]),error
    end .

gm_start_fake_client_do([]) -> ok;
gm_start_fake_client_do([[RoleId, AccId, AccName, AccSDK, IP]|T]) ->
    timer:sleep(200),
    OPid = misc:get_player_process(RoleId),
    if
        is_pid(OPid) -> gm_start_fake_client_do(T);
        true ->
            ?PRINT("RoleId ~p ~n", [RoleId]),
            % case catch mod_server:start([RoleId, IP, fake_client, AccId, AccName, AccSDK, util:get_server_name(), [RoleId], 1, none, gsrv_tcp, reader_ws, ?ONHOOK_AGENT_LOGIN]) of
            LoginParams = #login_params{
                id = RoleId, ip = IP, socket = fake_client, accid = AccId, accname = AccName, accname_sdk = AccSDK, server_name = util:get_server_name(), ids = [RoleId], reg_server_id = 1, 
                c_source = none, trans_mod = gsrv_tcp, proto_mod = reader_ws
            },
            case catch mod_server:start([LoginParams, ?ONHOOK_AGENT_LOGIN]) of
                {ok, Pid} ->
                    %% 走完正的流程
                    erlang:unlink(Pid),
                    Pid ! gm_start_fake_client;
                _R ->
                    ?ERR("start_fake_client login:~p~n", [_R])
            end,
            gm_start_fake_client_do(T)
    end.

%% ---------------------------关闭所有托管佬---------------------------------
gm_close_all_fake() ->
    apply_cast_all_fake(?MODULE, close_fake_client2, []).

close_fake_client2(#player_status{} = PS) ->
    lib_fake_client:close_fake_client(PS);
close_fake_client2(_) -> skip.

%% ---------------------------设置pv状态---------------------------------
%% 设置pv状态
%% -define(PK_PEACE,      0).   %% 和平:不能攻击任何人
%% -define(PK_ALL,        1).   %% 全体:所有人
%% -define(PK_FORCE,      2).   %% 强制:攻击非同帮和非同队伍的其他玩家
%% -define(PK_SERVER,     3).   %% 同服(跨服)
%% -define(PK_GUILD,      4).   %% 公会:攻击非同帮的其他玩家##同队伍不同帮派也会攻击
%% -define(PK_CAMP,       5).   %% 阵营
gm_set_kv_state(PKState) ->
    apply_cast_all_fake(?MODULE, change_pkstatus, [PKState]).
change_pkstatus(#player_status{online = ?ONLINE_FAKE_ON} = PS, PKState) ->
    case lib_player:change_pkstatus(PS, PKState) of
        false -> PS;
        {ok, NPS} -> NPS
    end;
change_pkstatus(_, _) -> skip.

%% ---------------------------切换场景---------------------------------
gm_change_scene(SceneId) ->
    [X, Y] = lib_scene:get_born_xy(SceneId),
    apply_cast_all_fake(?MODULE, change_scene, [[SceneId, 0, 0, X, Y, true, []]]).
change_scene(#player_status{online = ?ONLINE_FAKE_ON, id = RoleId}, Args) ->
    apply(lib_scene, player_change_scene, [RoleId|Args]);
change_scene(_, _) -> skip.

%% ---------------------------执行协议---------------------------------
gm_proto(Cmd, Data) ->
    apply_cast_all_fake(?MODULE, proto, [Cmd, Data]).

proto(PS, Cmd, Data) ->
    case catch mod_server:routing(Cmd, PS, Data) of
        {ok, Status1} when is_record(Status1, player_status) ->
            Status1;
        {ok, V, Status1} when is_record(Status1, player_status) ->
            mod_server:do_return_value(V, Status1),
            Status1;
        {error, OtherReason} ->
            ?ERR("mod_server error Cmd:~p Data:~p~n Reason== ~p", [Cmd, Data, OtherReason]),
            PS;
        {'EXIT', R} when is_record(PS, player_status)->
            ?ERR("mod_server 'EXIT' Cmd:~p Data:~p~n Reason== ~p", [Cmd, Data, R]),
            PS;
        _R ->
            PS
    end.


