%% ---------------------------------------------------------------------------
%% @doc lib_fake_client.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_fake_client).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("guild.hrl").
-include("figure.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-include("login.hrl").
-compile(export_all).


start_fake_client(RoleId, OnhoonModule) ->
	case lib_player:get_alive_pid(RoleId) of 
		false -> start_fake_client_do(RoleId, OnhoonModule);
		Pid -> 
			Pid ! {start_fake_client, OnhoonModule}
	end.

start_fake_client_do(RoleId, OnhoonModule) when is_integer(RoleId) ->
	%% 登陆
	Sql = io_lib:format("select accid, accname, accname_sdk, last_login_ip from player_login where id=~p ", [RoleId]),
	case db:get_row(Sql) of 
		[AccId, AccName, AccNameSdk, Ip] ->
			% case catch mod_server:start([RoleId, Ip, fake_client, AccId, AccName, AccNameSdk, util:get_server_name(), [RoleId], 1, none, gsrv_tcp, reader_ws, ?ONHOOK_AGENT_LOGIN]) of
            LoginParams = #login_params{
                id = RoleId, ip = Ip, socket = fake_client, accid = AccId, accname = AccName, accname_sdk = AccNameSdk, server_name = util:get_server_name(), ids = [RoleId], reg_server_id = 1, 
                c_source = none, trans_mod = gsrv_tcp, proto_mod = reader_ws
            },
            case catch mod_server:start([LoginParams, ?ONHOOK_AGENT_LOGIN]) of
		        {ok, Pid} ->
		            %% 走完正的流程
		            erlang:unlink(Pid),
		            Pid ! {start_fake_client2, OnhoonModule};
		        _R ->
		            ?ERR("start_fake_client login:~p~n", [_R])
		    end;
		_R ->
			?ERR("start_fake_client login:~p~n", [_R])
	end;
% start_fake_client_do(PS, OnhoonModule) when PS#player_status.id == 4294967413 ->
% 	PS#player_status.pid ! {start_fake_client2, OnhoonModule},
% 	{noreply, PS};
start_fake_client_do(PS, OnhoonModule) ->
	#player_status{id = RoleId, online = OnlineFlag} = PS,
	case OnlineFlag of 
		?ONLINE_ON ->  %% 玩家在线，不做处理
			%% 通知托管进程，不需要托管
			#onhook_module{module_id = ModuleId, sub_module = SubMod} = OnhoonModule,
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, 0),
			{noreply, PS};
		_ -> %% 离线挂机等其他情况
			%% 先登出，再托管
			spawn(fun() -> timer:sleep(1500), start_fake_client_do(RoleId, OnhoonModule) end),
			case catch mod_login:logout(PS, ?LOGOUT_LOG_NORMAL) of
                {'EXIT', _Reason} ->
                    catch ?ERR("start_fake_client_do:logout ERROR== Reason=~p~n", [_Reason]);
                _R -> skip
            end,
            {stop, normal, PS}
	end.

start_fake_client2(PS, OnhookModule) ->
	#player_status{
		id = RoleId, sid = Sid, scene = SceneId, 
		guild = #status_guild{id = GuildId}
	} = PS,
	#onhook_module{module_id = ModuleId, sub_module = SubMod} = OnhookModule,
	%?MYLOG("lxl_activity", "start_fake_client2 ~n", []),
	% 离线状态
    PSAfOnline = PS#player_status{online = ?ONLINE_FAKE_ON},
    mod_chat_agent:update(RoleId, [{online_flag, ?ONLINE_OFF_ONHOOK}]),
    lib_role:update_role_show(RoleId, [{online_flag, ?ONLINE_OFF}]),
    case GuildId > 0 of
        false -> skip;
        true -> mod_guild:update_guild_member_attr(RoleId, [{online_flag, ?ONLINE_OFF}])
    end,
    %% 
    Sid ! {add_regis, data_fake_client_m:get_regis_proto(ModuleId, SubMod)},
    %% 设置fake_client数据
    PSAfModule = lib_fake_client_api:init_fake_client(PSAfOnline, OnhookModule),
    %% 如果不是野外场景，先切到野外场景
    IsOuside = lib_scene:is_outside_scene(SceneId),
    case IsOuside of 
    	true -> PSAfScene = PSAfModule;
    	_ -> %% 直接更改场景id
    		[TSceneId, TX, TY] = lib_scene:get_outside_scene_by_lv(PS#player_status.figure#figure.lv),
    		PSAfScene = PSAfModule#player_status{scene = TSceneId, scene_pool_id = 0, copy_id = 0, x = TX, y = TY}
    end,
    %% 开始进入活动
    PSAfActivity = lib_fake_client_api:enter_activity(PSAfScene),
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			LastPS = lib_player_behavior:start_in_fake_client(PSAfActivity);
		_ ->
			LastPS = PSAfActivity
	end,
	%% 记录托管币的消耗情况
	FakerClient = PSAfActivity#player_status.fake_client,
	HookCoin = mod_daily:get_count(RoleId, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_CONSUME),
	NewFakerClient = FakerClient#fake_client{begin_hook_coin = HookCoin},
    {noreply, LastPS#player_status{fake_client = NewFakerClient}}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55 关闭客户端
%% 清除状态,清除定时器
close_fake_client(Role) ->
	close_fake_client(Role, undefined).

close_fake_client(RoleId, Msg) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of 
		false -> ok;
		Pid -> Pid ! {close_fake_client, Msg}
	end;
close_fake_client(PS, Msg) ->
	#player_status{pid = Pid} = PS,
	Pid ! {close_fake_client, Msg} .

close_fake_client2(PS, Msg) ->
	#player_status{sid = Sid} = PS,
	PS1 = lib_fake_client_event:close_fake_client(PS, Msg),
	case Msg of 
		relogin -> %% 玩家重登
			%?MYLOG("lxl_activity", "relogin : ~p~n", [Msg]),
			NewPS = PS1;
		_ -> %%  其他情况退出登录
			NewPS = mod_server:do_delay_stop(PS1, PS1#player_status.socket)
	end,
	OldFakeClient = NewPS#player_status.fake_client,
	Sid ! {del_regis, data_fake_client_m:get_regis_proto(OldFakeClient#fake_client.in_module, OldFakeClient#fake_client.in_sub_module)},
	NewPS#player_status{fake_client = OldFakeClient#fake_client{start_client = 0, in_module = 0, in_sub_module = 0}}.

%% 重登
relogin(PS) ->
	#player_status{id = RoleId, fake_client = #fake_client{start_client = StartClient, in_module = ModuleId, in_sub_module = SubMod}} = PS,
	case StartClient > 0 of 
		true ->
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?SUCCESS),
			close_fake_client(PS, relogin);
		_ ->
			ok
	end.

%% 登出
logout(PS) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{start_client = StartClient, in_module = ModuleId, in_sub_module = SubMod} = FakeClient,
	case StartClient > 0 of 
		true ->
			PS1 = lib_fake_client_event:close_fake_client(PS, undefined),
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?ERRCODE(err192_logout)),
			PS1;
		_ ->
			PS
	end.

%% 根据功能，来处理复活
player_die(PS) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			lib_player_behavior:player_die(PS);
		_ -> lib_fake_client_battle:player_die(PS)
	end.
	
player_revive(PS) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			lib_player_behavior:player_revive(PS);
		_ -> lib_fake_client_battle:player_revive(PS)
	end.


in_fake_client(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	case FakeClient of
		#fake_client{start_client = StartClient, in_module = Module} -> StartClient > 0 andalso Module > 0;
		_ -> false
	end.

%% 获取挂机类型
%% 需要临时改动改好可热更（要在非活动时间）
get_onhook_type() ->
	?ON_HOOK_BEHAVIOR.
	%?ON_HOOK_STATE_M.
