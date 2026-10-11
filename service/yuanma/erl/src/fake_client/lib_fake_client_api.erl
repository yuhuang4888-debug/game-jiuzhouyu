%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_api.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_fake_client_api).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-compile(export_all).

%% 玩家死亡
handle_event(PS, #event_callback{type_id = ?EVENT_PLAYER_DIE}) ->
    case lib_fake_client:in_fake_client(PS) of
    	true ->
    		NewPS = lib_fake_client:player_die(PS);
    	_ -> NewPS = PS
    end,
    {ok, NewPS};
%% 复活完成
handle_event(PS, #event_callback{type_id = ?EVENT_REVIVE, data = _Data}) when is_record(PS, player_status) ->
	case lib_fake_client:in_fake_client(PS) of
    	true ->
    		NewPS = lib_fake_client:player_revive(PS);
    	_ -> NewPS = PS
    end,
    {ok, NewPS};
handle_event(PS, _) ->
    {ok, PS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动逻辑相关
%% 获取初始的行为和超时时间
get_init_behaviour(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{behaviour = _OldBehaviour, in_module = InModule} = FakeClient,
	if
		%% 有特殊的初始行为自己加，默认都是先睡眠5秒后训目标挂机
		InModule == ?MOD_DRUMWAR ->
			{?BEHAVIOUR_WAIT, 8000};
		InModule == ?MOD_TOPPK ->
			{?BEHAVIOUR_IDEL, 3000};
		InModule == ?MOD_TOPPK ->
			{?BEHAVIOUR_IDEL, 30000};
		InModule == ?MOD_KF_1VN ->
			{?BEHAVIOUR_WAIT, 4000};
		true ->
			{?BEHAVIOUR_IDEL, ?DEFAULT_IDLE_TIME}
	end.

%% 初始化fake_client数据
init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = InModule, sub_module = SubMod} = OnhookModule,
	if
		InModule == ?MOD_NINE ->
			lib_fake_client_nine:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_MIDDAY_PARTY ->
			lib_fake_client_midday_party:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_DRUMWAR ->
			lib_fake_client_drumwar:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_GUILD_ACT andalso SubMod == ?MOD_GUILD_ACT_PARTY ->
			lib_fake_client_gfeast:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_TOPPK ->
			lib_fake_client_toppk:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_TERRITORY ->
			lib_fake_client_territory_treasure:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_TERRITORY_WAR ->
			lib_fake_client_guild_war:init_fake_client(PS, OnhookModule);
		InModule == ?MOD_KF_1VN ->
			lib_fake_client_kf_1vN:init_fake_client(PS, OnhookModule);
		true ->
			PS#player_status{fake_client = #fake_client{start_client = 1, in_module = InModule, in_sub_module = SubMod}}
	end.

%% 进入活动
enter_activity(PS) ->
	#player_status{fake_client = #fake_client{in_module = InModule, in_sub_module = SubMod}} = PS,
	if
		InModule == ?MOD_NINE ->
			lib_fake_client_nine:enter_activity(PS);
		InModule == ?MOD_MIDDAY_PARTY ->
			lib_fake_client_midday_party:enter_activity(PS);
		InModule == ?MOD_DRUMWAR ->
			lib_fake_client_drumwar:enter_activity(PS);
		InModule == ?MOD_GUILD_ACT andalso SubMod == ?MOD_GUILD_ACT_PARTY ->
			lib_fake_client_gfeast:enter_activity(PS);
		InModule == ?MOD_TOPPK ->
			lib_fake_client_toppk:enter_activity(PS);
		InModule == ?MOD_TERRITORY ->
			lib_fake_client_territory_treasure:enter_activity(PS);
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:enter_activity(PS);
		InModule == ?MOD_TERRITORY_WAR ->
			lib_fake_client_guild_war:enter_activity(PS);
		InModule == ?MOD_KF_1VN ->
			lib_fake_client_kf_1vN:enter_activity(PS);
		true -> %% 没有活动参与, 取消fake_client
			lib_fake_client:close_fake_client(PS),
			PS
	end.

%% 关闭
close_fake_client(PS, Msg) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = InModule, in_sub_module = SubMod} = FakeClient,
	if
		InModule == ?MOD_NINE ->
			lib_fake_client_nine:close_fake_client(PS, Msg);
		InModule == ?MOD_MIDDAY_PARTY ->
			lib_fake_client_midday_party:close_fake_client(PS, Msg);
		InModule == ?MOD_DRUMWAR ->
			lib_fake_client_drumwar:close_fake_client(PS, Msg);
		InModule == ?MOD_GUILD_ACT andalso SubMod == ?MOD_GUILD_ACT_PARTY ->
			lib_fake_client_gfeast:close_fake_client(PS, Msg);
		InModule == ?MOD_TOPPK ->
			lib_fake_client_toppk:close_fake_client(PS, Msg);
		InModule == ?MOD_TERRITORY ->
			lib_fake_client_territory_treasure:close_fake_client(PS, Msg);
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:close_fake_client(PS, Msg);
		InModule == ?MOD_TERRITORY_WAR ->
			lib_fake_client_guild_war:close_fake_client(PS, Msg);
		InModule == ?MOD_KF_1VN ->
			lib_fake_client_kf_1vN:close_fake_client(PS, Msg);
		true -> 
			PS
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 加载场景成功
load_scene_success(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = InModule, in_sub_module = SubMod} = FakeClient,
	if
		InModule == ?MOD_DRUMWAR ->
			lib_fake_client_drumwar:load_scene_success(PS);
		InModule == ?MOD_GUILD_ACT andalso SubMod == ?MOD_GUILD_ACT_PARTY ->
			lib_fake_client_gfeast:load_scene_success(PS);
		InModule == ?MOD_TOPPK ->
			lib_fake_client_toppk:load_scene_success(PS);
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:load_scene_success(PS);
		InModule == ?MOD_TERRITORY_WAR ->
			lib_fake_client_guild_war:load_scene_success(PS);
		true -> 
			PS
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 寻找攻击目标
%% 目标寻找顺序
get_att_target_find_order(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = InModule, in_sub_module = SubMod} = FakeClient,
	if
		InModule == ?MOD_DRUMWAR ->
			[object, user];
		InModule == ?MOD_MIDDAY_PARTY -> 
			[clt_mon, object];
		InModule == ?MOD_GUILD_ACT andalso SubMod == ?MOD_GUILD_ACT_PARTY ->
			[clt_mon, object];
		InModule == ?MOD_TOPPK ->
			[object, user];
		InModule == ?MOD_TERRITORY ->
			[drop, object, module_object];
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			[object, module_object, user];
		InModule == ?MOD_TERRITORY_WAR ->
			[module_object, object, user];
		InModule == ?MOD_NINE ->
			[clt_mon, object, user];
		InModule == ?MOD_KF_1VN ->
			[object, user];
		true -> 
			[drop, clt_mon, object]
	end.
	
%% 从模块数据中选择攻击目标
%% return ：false | #att_target{}
%% Type:module_clt_mon | module_object | module_user
find_target_in_module(PS, Type) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = InModule} = FakeClient,
	if
		InModule == ?MOD_TERRITORY ->
			lib_fake_client_territory_treasure:find_target_in_module(PS, Type);
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:find_target_in_module(PS, Type);
		InModule == ?MOD_TERRITORY_WAR ->
			lib_fake_client_guild_war:find_target_in_module(PS, Type);
		true ->
			false
	end.

%% 从模块数据中检查目标
need_find_target(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = InModule} = FakeClient,
	if
		InModule == ?MOD_DRUMWAR ->
			lib_fake_client_drumwar:need_find_target(PS);
		InModule == ?MOD_TOPPK ->
			lib_fake_client_toppk:need_find_target(PS);
		InModule == ?MOD_TERRITORY ->
			lib_fake_client_territory_treasure:need_find_target(PS);
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:need_find_target(PS);
		InModule == ?MOD_TERRITORY_WAR ->
			lib_fake_client_guild_war:need_find_target(PS);
		InModule == ?MOD_KF_1VN ->
			lib_fake_client_kf_1vN:need_find_target(PS);
		%% 默认是要寻找攻击目标
		true ->
			true
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 复活
get_revive_type_and_time(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = InModule} = FakeClient,
	if
		InModule == ?MOD_NINE ->
			{?REVIVE_NINE, 8000};
		InModule == ?MOD_DRUMWAR ->
			lib_fake_client_drumwar:get_revive_type_and_time(PS);
		InModule == ?MOD_TOPPK -> %% 巅峰竞技死亡不复活，直接切回野外的
			false;
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			{?REVIVE_HOLY_SPIRIT_BATTLE, 10000};
		InModule == ?MOD_TERRITORY_WAR ->
			{?REVIVE_GUILD_BATTLE, 10000};
		InModule == ?MOD_KF_1VN ->
			lib_fake_client_kf_1vN:get_revive_type_and_time(PS);
		true ->
			{?REVIVE_INPLACE, 5000}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 技能
select_a_skill(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = InModule} = FakeClient,
	if
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:select_a_skill(PS);
		true ->
			false
	end.

use_skill_succ(PS0, SkillId) ->
	#player_status{fake_client = FakeClient} = PS = lib_battle_event:handle_af_battle_success(PS0, SkillId),
	#fake_client{in_module = InModule} = FakeClient,
	if
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:use_skill_succ(PS, SkillId);
		true ->
			PS
	end.

%%% 卡障碍点
get_loop_block_xy(FakeClient, SceneId, CopyId, Xnext, Ynext) ->
	#fake_client{in_module = InModule} = FakeClient,
	if
		InModule == ?MOD_NINE ->
			lib_fake_client_nine:get_loop_block_xy(FakeClient, SceneId, CopyId, Xnext, Ynext);
		InModule == ?MOD_TERRITORY ->
			lib_fake_client_territory_treasure:get_loop_block_xy(FakeClient, SceneId, CopyId, Xnext, Ynext);
		InModule == ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
			lib_fake_client_holy_spirit:get_loop_block_xy(FakeClient, SceneId, CopyId, Xnext, Ynext);
		InModule == ?MOD_TERRITORY_WAR ->
			lib_fake_client_guild_war:get_loop_block_xy(FakeClient, SceneId, CopyId, Xnext, Ynext);
		true ->
			{Xnext, Ynext}
	end.