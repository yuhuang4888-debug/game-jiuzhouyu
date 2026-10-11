%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_feast_mgr
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-02
%% @Description:    公会宴会管理器
%%-----------------------------------------------------------------------------
-module(mod_guild_feast_mgr).

-include("guild_feast.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("guild.hrl").
-include("goods.hrl").
-include("drop.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

-compile(export_all).

%% 定时器启动
start_link() ->
	gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

callback_mode() ->
	handle_event_function.

init([]) ->
%%	NowTime = utime:unixtime(),
%%	{StateName, ActStatus, CountDownTime, Etime} = lib_guild_feast:get_next_time(NowTime),
%%	%% 进程启动时候处于开启状态跳过这次活动，后面可以通过time_out来启动活动，这次活动就不开启了，
%%	case ActStatus == ?ACT_STATUS_OPEN of
%%		true ->
%%%%			?DEBUG("ACT_STATUS_OPEN~n", []),
%%			LastStateName = close,
%%			StageStatus = ?ACT_STATUS_CLOSE,
%%			LastActStatus = ?ACT_STATUS_CLOSE;
%%		false ->
%%			LastStateName = StateName,
%%			StageStatus =
%%				case ActStatus of
%%					?ACT_STATUS_CLOSE ->
%%						?ACT_STATUS_CLOSE;
%%					?ACT_STATUS_OPEN ->
%%						erlang:send_after(30 * 1000, self(), 'reflush_fire'),
%%						?GUILD_FEAST_STAGE_FIRE;    %%  默认是公会篝火
%%					_ ->
%%						?ACT_STATUS_CLOSE           %%  其他都是关闭阶段
%%				end,
%%			LastActStatus = ActStatus
%%	end,
%%	Ref = erlang:send_after(CountDownTime * 1000, self(), 'time_out'),  %%下一个阶段,
	GuildList = lib_guild_feast:get_init_guild(),
%%	?DEBUG("GuildList ~p~n", [GuildList]),
	StatusGFeast = #status_gfeast{
		stage = ?ACT_STATUS_CLOSE,
		status = 0,
		gfeast_guild = GuildList,  %%初始化所有的公会
		etime = 0,
		ref = []},
	{ok, close, StatusGFeast}.

handle_event(Type, Msg, StateName, State) ->
%%	put("mod_guild_feast_mgr", {Type, Msg}),
	case catch do_handle_event(Type, Msg, StateName, State) of
		{'EXIT', _R} ->
			?ERR("handle_exit_error:~p~n", [[Type, Msg, StateName, _R]]),
			{keep_state, State};
		Reply ->
			Reply
	end.

%%==================================================外部调用方法=====================================================
%%公会晚宴信息
send_act_info(RoleId) ->
	gen_statem:cast(?MODULE, {'send_act_info', RoleId}).

%%判断是否开启晚会
is_act_open() ->
	case catch gen_statem:call(?MODULE, 'act_status') of
		ActStatus when is_integer(ActStatus) ->
			ActStatus == ?ACT_STATUS_OPEN;
		_Err ->
			?ERR("get_act_status err:~p", [_Err]),
			false
	end.
%%进入场景
enter_scene(RoleId, RoleLv, GuildId, GuildName) ->
	gen_statem:cast(?MODULE, {'enter_scene', RoleId, RoleLv, GuildId, GuildName}).

%%退出场景
exit_scene(RoleId, GuildId) ->
%%	?DEBUG("exit_scene RoleId ~p  GuildId ~p~n", [RoleId, GuildId]),
	gen_statem:cast(?MODULE, {'exit_scene', RoleId, GuildId}).

%%个人奖励，现在基本不用
send_role_reward_info(RoleId) ->
	gen_statem:cast(?MODULE, {'send_role_reward_info', RoleId}).

%%right_answer(RoleId, RoleName, GuildId, ScorePlus) ->
%%	gen_statem:cast(?MODULE, {'right_answer', RoleId, RoleName, GuildId, ScorePlus}).

right_answer(RoleId, GuildName, GuildId, ScorePlus, PackRoleListLast) ->
	gen_statem:cast(?MODULE, {'right_answer', RoleId, GuildName, GuildId, ScorePlus, PackRoleListLast}).

%%send_quiz_rank(RoleId) ->  弃用
%%	gen_statem:cast(?MODULE, {'send_quiz_rank', RoleId}).

send_quiz_rank(RoleId, GuildId) ->
	gen_statem:cast(?MODULE, {'send_quiz_rank', RoleId, GuildId}).

send_role_score_rank(RoleId, GuildId) ->
    gen_statem:cast(?MODULE, {'send_role_score_rank', RoleId, GuildId}).

check_receive_reward(RoleId) ->
	gen_statem:cast(?MODULE, {'check_receive_reward', RoleId}).

receive_reward(RoleId) ->
	gen_statem:cast(?MODULE, {'receive_reward', RoleId}).

update_acc_reward(RoleId, RoleLv, Type) ->
	gen_statem:cast(?MODULE, {'update_acc_reward', RoleId, RoleLv, Type}).

%%发送经验或者贡献
send_reward(RoleId, RoleLv, Type) ->
	gen_statem:cast(?MODULE, {'send_reward', RoleId, RoleLv, Type}).

send_quiz_info(RoleId, GuildId) ->
	gen_statem:cast(?MODULE, {'send_quiz_info', RoleId, GuildId}).

collect_checker(ModId, ModCfgId, A) ->
%%	?DEBUG("log1 ~n", []),
	gen_statem:call(?MODULE, {'collect_checker', ModId, ModCfgId, A}).

send_quiz_TV_by_guild(GuildId, State) ->
	gen_statem:cast(?MODULE, {'send_quiz_TV_by_guild', GuildId, State}).
%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数     AnswerType::integer() 答题类型 1: 选择题 2:简答题
%%                    RoleId::integer() 玩家id，
%%                    RoleName::string() 玩家名字
%%                    GuildId::integer()   公会Id
%%                    Answer:: integer()|string()   答案
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
quiz_answer(RoleId, RoleName, Figure, GuildId, GuildName, Answer, AnswerType) ->
	gen_statem:call(?MODULE, {'quiz_answer', RoleId, RoleName, Figure, GuildId, GuildName, Answer, AnswerType}).

refresh_quiz_rank(TopicNo, RightAnswer) ->
    gen_statem:cast(?MODULE, {'refresh_quiz_rank', TopicNo, RightAnswer}).

%% 是否可以购买高级菜肴
%% return  false | true
is_can_buy_food(GuildId) ->
	gen_statem:call(?MODULE, {'is_can_buy_food', GuildId}).

%%点击火苗
collect_fire(RoleId, FireId, GuildId) ->
	gen_statem:cast(?MODULE, {'collect_fire', RoleId, FireId, GuildId}).

%%发送排行榜奖励给排行榜里的人
send_point_reward(GuildId) ->
	gen_statem:cast(?MODULE, {'send_point_reward', GuildId}).


%%增加龙魂 Num:龙魂数量
add_dragon_spirit(GuildId, Num) ->
	gen_statem:cast(?MODULE, {'add_dragon_spirit', GuildId, Num}).

%%预备进入巨龙模式
pre_enter_dragon(GuildId) ->
	gen_statem:cast(?MODULE, {'pre_enter_dragon', GuildId}).

%% -----------------------------------------------------------------
%% @desc     功能描述  远古巨龙被杀死
%% @param    参数      Minfo::#scene_object{}
%% @return   返回值    无
%% @history  修改历史
%% -----------------------------------------------------------------
kill_boss(AtterId, MonArgs, ModArgs) ->
%%	?DEBUG("kill boss~n", []),
	#mon_args{scene = Scene} = MonArgs,
	case lib_guild_feast:is_gfeast_scene(Scene) of
		true ->
			gen_statem:cast(?MODULE, {'kill_boss', AtterId, MonArgs, ModArgs});
		_ ->
			ok
	end.
%%获得火苗列表
get_fire_exp_by_role_id(RoleId) ->
	gen_statem:cast(?MODULE, {'get_fire_exp_by_role_id', RoleId}).
%%发送龙魂信息
send_dragon_point_by_guild(GuildId) ->
	gen_statem:cast(?MODULE, {'send_dragon_point_by_guild', GuildId}).

%% 秘籍 内服测试用
gm_close() ->
	gen_statem:cast(?MODULE, {'gm_close'}).


%% 秘籍  外服用
gm_close_without_kf() ->
	gen_statem:cast(?MODULE, {'gm_close_without_kf'}).



%%开启活动
gm_open() ->
	erlang:send(?MODULE, 'gm_open').

%% 设置轮换游戏
gm_set_game_type(Id) ->
    gen_statem:cast(?MODULE, {'gm_set_game_type', Id}).

%%活动日历开启活动
activity_calendar_start() ->
	erlang:send(?MODULE, 'time_out').

send_fire_to_user(RoleId, GuildId) ->
	gen_statem:cast(?MODULE, {'send_fire_to_user', RoleId, GuildId}).

send_dragon_point(RoleId, GuildId) ->
	gen_statem:cast(?MODULE, {'send_dragon_point', RoleId, GuildId}).

send_quiz_rank_by_guild(GuildId) ->
	gen_statem:cast(?MODULE, {'send_quiz_rank_by_guild', GuildId}).

send_exp_by_cast(RoleId, ExpAdd) ->
%%	?DEBUG("+++++++++++++++  RoleId ~p , ExpAdd ~p ~n", [RoleId, ExpAdd]),
	gen_statem:cast(?MODULE, {'send_exp', RoleId, ExpAdd}).


%%召唤巨龙
summon_dragon(RoleId, GuildId, Cost, Type) ->
	gen_statem:cast(?MODULE, {'summon_dragon', RoleId, GuildId, Cost, Type}).

add_guild_exp_ratio(GuildId, Ratio, Type) ->
	gen_statem:cast(?MODULE, {'add_guild_exp_ratio', GuildId, Ratio, Type}).

%% 发送菜肴状态
send_food_status(RoleId, GuildId, PackList) ->
	gen_statem:cast(?MODULE, {'send_food_status', RoleId, GuildId, PackList}).

%% 小游戏初始化辅助
init_mini_game(GfeastPlayer, {GameType}) ->
    gen_statem:cast(?MODULE, {'init_mini_game', {GfeastPlayer, GameType}}).

%% 小游戏分数反馈
game_feedback(PlayerInfo, {GameType, Score, InfoList}) ->
    gen_statem:cast(?MODULE, {'game_feedback', {PlayerInfo, GameType, Score, InfoList}}).

%% 获取小游戏排行榜
send_game_rank_list(PlayerInfo, GameType) ->
    gen_statem:cast(?MODULE, {'send_game_rank_list', {PlayerInfo, GameType}}).

%% 小游戏结束
game_time_out(PlayerInfo, {GameType, InfoList}) ->
    gen_statem:cast(?MODULE, {'game_time_out', {PlayerInfo, GameType, InfoList}}).

%% 小游戏是否完成
send_mini_game_status(RoleId, GuildId) ->
    gen_statem:cast(?MODULE, {'mini_game_status', RoleId, GuildId}).

send_game_type(RoleId) ->
    gen_statem:cast(?MODULE, {'send_game_type', RoleId}).

%%==================================================外部调用方法=====================================================end



set_topic(TopicList) ->
%%	?MYLOG("cym", "TopicList ~p~n", [TopicList]),
	gen_statem:cast(?MODULE, {'set_topic', TopicList}).


set_topic_time() ->
	gen_statem:cast(?MODULE, {'set_topic_time'}).

%% 公会晚宴信息
do_handle_event(cast, {'send_act_info', RoleId}, _, State) ->
	#status_gfeast{status = Status, etime = Etime, stage = Stage} = State,
	ActEndTime = lib_guild_feast:get_end_time(Status),
	{ok, BinData} = pt_402:write(40211, [Status, ActEndTime, Etime, Stage]),
%%	?MYLOG("cym", "Status ~p,  etime ~p, Stage:~p ActEndTime ~p ~n", [Status, Etime - utime:unixtime(), Stage, ActEndTime]),
	lib_server_send:send_to_uid(RoleId, BinData),
	{keep_state, State};

%% 进入晚宴场景
do_handle_event(cast, {'enter_scene', RoleId, RoleLv, GuildId, GuildName}, open, State) ->
%%	?DEBUG("enter~n", []),
	case lib_guild_feast_chect:enter_scene(GuildId, State) of
		true ->
			#status_gfeast{gfeast_guild = GFeastGuilds, quiz_stime = QuizActStime, fire_map = FireMap, quiz_pid = QuizPid, stage = Stage} = State,
%%			?DEBUG("enter~n", []),
			SceneId = data_guild_feast:get_cfg(scene_id),
			NowTime = utime:unixtime(),
%%			?DEBUG("GFeastGuilds ~p~n", [GFeastGuilds]),
			NewGFeastGuilds = case lists:keyfind(GuildId, #gfeast_guild.guild_id, GFeastGuilds) of
				false ->  %%新的公会, 现在这种做法，基本不会有新的公会，初始化的时候，将全部公会放入内存中去, ---实际上会有的，后面创建的公会
					case QuizActStime > 0 andalso NowTime >= QuizActStime of
						true ->  %%答题时间到了
%%							{ok, QuizPid} = mod_guild_feast_quiz:start(GuildId),  %%一个公会开启一个答题进程
							RoleList = [RoleId], %%玩家列表
%%							?DEBUG("RoleList ~p quiz_pid ~p, guildId ~p~n", [RoleList, QuizPid, GuildId]),
							NewFireMap = FireMap,
							TmpR = #gfeast_guild{role_list = RoleList, guild_id = GuildId, guild_name = GuildName};
						false ->
							RoleList = [RoleId],
							% FireList = lib_guild_feast:get_fire_list_by_role_num(1, GuildId),    %%第一个进来，人数只有一个
							% TmepTime = NowTime + data_guild_feast:get_cfg(fire_reflush_time),
							% lib_server_send:send_to_uid(RoleId, pt_402, 40256, [1, TmepTime]),  %%发送告知客户端
							% TmpR = #gfeast_guild{role_list = RoleList, guild_id = GuildId, guild_name = GuildName, fire_list = FireList},
							TmpR = #gfeast_guild{role_list = RoleList, guild_id = GuildId, guild_name = GuildName},
							FireId = lib_guild_feast:create_fire_by_guild(TmpR),
							NewFireMap = maps:put(GuildId, FireId, FireMap),
							TmpR
					end,
					[TmpR | GFeastGuilds];
				TempGuild ->
					NewFireMap = FireMap,
					%%更新公会的玩家列表
					#gfeast_guild{role_list = RoleList, add_exp_ratio = ExpRatio} = TempGuild,
					NewRoleList =
						case lists:member(RoleId, RoleList) of
							true ->
								RoleList;
							false ->
								[RoleId | RoleList]
						end,
					%%如果是答题阶段，则要发送排行榜给玩家
					case  QuizPid  of
						undefine ->
							skip;
						_ ->
							mod_guild_feast_quiz:enter_scene(QuizPid,  RoleId,  GuildId)
					end,
					TempGuild2 = TempGuild#gfeast_guild{role_list = NewRoleList},
					NewTempGuilds = lists:keystore(GuildId, #gfeast_guild.guild_id, GFeastGuilds, TempGuild2),
					%% 同步玩家的经验加成
					mod_daily:set_count(RoleId, ?MOD_GUILD_ACT, 4, ExpRatio),
					%% 通知客户端显示
					{ok, Bin} = pt_402:write(40267, [ExpRatio]),
					lib_server_send:send_to_uid(RoleId, Bin),
					NewTempGuilds
			end,
			%% 切换场景
			KeyValueList = [{group, 0}, {change_scene_hp_lim, 100}, {action_lock, ?ERRCODE(err402_can_not_change_scene_in_gfeast)}, {collect_checker, {lib_guild_feast, collect_checker, {RoleId, GuildId}}}],  %% 玩家分组重置为0
			lib_scene:player_change_scene(RoleId, SceneId, ?DEF_SCENE_PID, GuildId, true, KeyValueList),
			{ok, Bin1} = pt_402:write(40212, [?SUCCESS]),
			lib_server_send:send_to_uid(RoleId, Bin1),
			mod_guild_boss:enter_guild_boss(GuildId, RoleId),
			JoinNum = mod_daily:get_count(RoleId, ?MOD_GUILD_ACT, 2),
			if
				JoinNum < 1 ->
					mod_daily:set_count(RoleId, ?MOD_GUILD_ACT, 2, 1),
					case lib_guild_god_util:is_open(RoleLv) of
						true -> mod_guild_prestige:add_prestige([RoleId, task, ?GOODS_ID_GUILD_PRESTIGE, 100, 0]);
						_ -> skip
					end,
                    CallbackData1 = #callback_join_act{type = ?MOD_GUILD_ACT, subtype = guild_feast},
                    lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData1),
                    case Stage of
                        Stage when Stage == ?GUILD_BOSS_WAIT; Stage == ?GUILD_BOSS_SUMMON ->
                            CallbackData2 = #callback_join_act{type = ?MOD_GUILD_ACT, subtype = guild_feast_fire},
                            lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData2),
                            lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_dinner_event, 1);
                        _ -> skip
                    end;
				true ->
					skip
			end,
			NewState = State#status_gfeast{
				gfeast_guild = NewGFeastGuilds,
				fire_map = NewFireMap
			},
			%%通知活动日历 ，参与公会晚宴
			lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_GUILD_ACT,  ?MOD_GUILD_ACT_PARTY),
			{keep_state, NewState};
		{false, Err} ->
			{ok, Bin} = pt_402:write(40212, [Err]),
			lib_server_send:send_to_uid(RoleId, Bin),
			{keep_state, State}
	end;


do_handle_event(cast, {'enter_scene', RoleId, _RoleLv, GuildId, _GuildName}, _, State) ->
%%	?PRINT("enter~n", []),
	case mod_guild_boss:get_gboss_open_status() of
		true ->
			KeyValueList = [{group, 0}, {change_scene_hp_lim, 100}, {action_lock, ?ERRCODE(err402_can_not_change_scene_in_gfeast)}, {collect_checker, {lib_guild_feast, collect_checker, {RoleId, GuildId}}}],  %% 玩家分组重置为0
			SceneId = data_guild_feast:get_cfg(scene_id),
			mod_guild_boss:enter_guild_boss(GuildId, RoleId),
			{ok, BinData} = pt_402:write(40212, [?SUCCESS]),
			lib_server_send:send_to_uid(RoleId, BinData),
			?MYLOG("guild", " SceneId, ?DEF_SCENE_PID, GuildId ~p~n", [{SceneId, ?DEF_SCENE_PID, GuildId}]),
			lib_scene:player_change_scene(RoleId, SceneId, ?DEF_SCENE_PID, GuildId, true, KeyValueList);
		_ ->
			case lib_guild_feast:is_today_open() of
				true ->
					{ok, BinData} = pt_402:write(40212, [?ERRCODE(err402_act_close)]),
					lib_server_send:send_to_uid(RoleId, BinData);
				_ ->
					{ok, BinData} = pt_402:write(40212, [?ERRCODE(err402_guild_boss_close)]),
					lib_server_send:send_to_uid(RoleId, BinData)
			end
	end,
	{keep_state, State};

%% 退出晚宴场景
do_handle_event(cast, {'exit_scene', RoleId, GuildId}, _, State) ->
	#status_gfeast{gfeast_guild = GuildList} = State,
	NewState = State,
	%%处理玩家列表
	NewGuildList =
		case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
			#gfeast_guild{} = Guild -> %%去掉这个玩家|
				#gfeast_guild{role_list = RoleList} = Guild,
				NewRoleList = lists:delete(RoleId, RoleList),
				%%变为 List
				GuildList1 = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, Guild#gfeast_guild{role_list = NewRoleList}),
				GuildList1;
			false ->
				GuildList
		end,
	LastState = NewState#status_gfeast{gfeast_guild = NewGuildList},
	mod_guild_boss:leave_guild_boss(GuildId, RoleId),
	{keep_state, LastState};

%% 个人奖励信息
do_handle_event(cast, {'send_role_reward_info', RoleId}, open, State) ->
	#status_gfeast{gfeast_reward = GFeastRewardMap} = State,
	#gfeast_role_reward{
		exp = Exp,
		gdonate = GDonate
	} = maps:get(RoleId, GFeastRewardMap, #gfeast_role_reward{}),
	{ok, BinData} = pt_402:write(40213, [Exp, GDonate]),
	lib_server_send:send_to_uid(RoleId, BinData),
	{keep_state, State};

%% 积分排行榜
do_handle_event(cast, {'send_quiz_rank', RoleId, GuildId}, open, State) ->
	lib_guild_feast:send_quiz_rank(RoleId, GuildId, State),
	{keep_state, State};

%% 个人积分排名
do_handle_event(cast, {'send_role_score_rank', RoleId, GuildId}, open, State) ->
    lib_guild_feast:send_role_score_rank(RoleId, GuildId, State),
    {keep_state, State};

%% 检测领取晚宴奖励
do_handle_event(cast, {'check_receive_reward', RoleId}, open, State) ->
	#status_gfeast{gfeast_reward = GFeastRewardMap} = State,
	#gfeast_role_reward{
		receive_times = ReceiveTimes
	} = maps:get(RoleId, GFeastRewardMap, #gfeast_role_reward{}),
	TimesLimit = data_guild_feast:get_cfg(receive_times_limit),
	case ReceiveTimes < TimesLimit of
		true ->
			ErrCode = ?SUCCESS;
		false ->
			ErrCode = ?ERRCODE(err402_receive_times_limit)
	end,
	{ok, BinData} = pt_402:write(40219, [ErrCode]),
	lib_server_send:send_to_uid(RoleId, BinData),
	{keep_state, State};


%% -----------------------------------------------------------------
%% @desc     功能描述    发送经验累积奖励   检查是否处于篝火阶段(场景就不用检查了，之前检查过了) ->
%%                                    获取奖励 ->发送奖励 ->不需告知客户端(没有错误码就是对的)->返回
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event(cast, {'send_reward', RoleId, _RoleLv, Type}, open, #status_gfeast{stage = Stage} = State) ->
	case Stage of
		?GUILD_FEAST_STAGE_FIRE -> %%篝火阶段才能发送奖励
			%%获取奖励
			RewardList = lib_guild_feast:get_reward_by_type(Type),
			case RewardList of
				[] ->
					ok;
				_ ->
					lib_goods_api:send_reward_by_id(RewardList, guild_feast, RoleId)
			end;
		_ ->
			ok
	end,
	{keep_state, State};

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数     AnswerType::integer() 答题类型 1: 选择题 2:简答题
%%                    RoleId::integer() 玩家id，
%%                    RoleName::string() 玩家名字
%%                    GuildId::integer()   公会Id
%%                    Answer:: integer()|string()   答案
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event({call, From}, {'quiz_answer', RoleId, RoleName, Figure, GuildId, GuildName, Answer, AnswerType}, open, State) ->
	#status_gfeast{gfeast_guild = GFeastGuilds, quiz_stime = QuizActStime, stage = Stage, guild_role_map = _RoleMap, role_list = RList} = State,
	NowTime = utime:unixtime(),
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GFeastGuilds) of
		#gfeast_guild{quiz_pid = QuizPid} ->
			case QuizActStime > 0 andalso NowTime >= QuizActStime andalso Stage == ?GUILD_FEAST_STAGE_QUESTION of %%开始答题了
				true ->
                    case Answer of
                        {RawAnswer, FilterAnswer} -> skip; % 问答题
                        _ -> RawAnswer = FilterAnswer = Answer % 选择题
                    end,
					%%  广播一下  前往答题
					IsAnswer = mod_guild_feast_quiz:answer(QuizPid, RoleId, RoleName, RawAnswer, AnswerType, GuildId, GuildName),
                    case lib_game:is_ban_chat() of
                        true -> skip;
                        false ->
                            case IsAnswer of
                                {1, _} -> AnswerSend = RawAnswer;
                                {0, true} -> AnswerSend = RawAnswer;
                                _ -> AnswerSend = FilterAnswer
                            end,
					        AnswerType == 2 andalso lib_chat:send_TV({guild, GuildId}, RoleId, Figure, ?MOD_GUILD_ACT, 33, [AnswerSend])
                    end;
				false ->
					IsAnswer = {0, false}
			end;
		_ ->
			IsAnswer = {0, false}
	end,

    AnsInfo0 = lists:keyfind(RoleId, #gfeast_rank_role.role_id, RList),
    case {lib_guild_feast:is_kf(), IsAnswer, AnsInfo0} of
        {false, {1, AnsInfo}, false} -> % 本服本题第一次答题正确
            Rank = length(RList) + 1,
            Point = data_guild_feast:get_question_point(Rank),
            lib_chat:send_TV({player, RoleId}, ?MOD_GUILD_ACT, 34, [Rank, Point]),
            State1 = State#status_gfeast{role_list = [AnsInfo#gfeast_rank_role{score = Point, rank = Rank} | RList]};
        _ ->
            State1 = State
    end,


	{keep_state, State1, [{reply, From, IsAnswer}]};
do_handle_event({call, From}, {'quiz_answer', _RoleId, _RoleName, _Figure, _GuildId, _Answer, _AnswerType}, _StateName, State) ->
	{keep_state, State, [{reply, From, 0}]};


do_handle_event({call, From}, {'is_can_buy_food', GuildId}, _StateName, State) ->
	#status_gfeast{gfeast_guild = GuildList} = State,
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		#gfeast_guild{is_buy_food = 0} -> %%  没有买，可以买高级菜肴
			Res = true;
		_ ->
			Res = false
	end,
	{keep_state, State, [{reply, From, Res}]};

%% 每题答题结束后刷新玩家积分排名
do_handle_event(cast, {'refresh_quiz_rank', TopicNo, RightAnswer}, open, State) ->
    #status_gfeast{quiz_map = QuizMap, guild_role_map = RoleMap, role_list = RList} = State,
    F = fun(AnsInfo, RMap) ->
        #gfeast_rank_role{role_id = RoleId, role_name = RoleName, guild_id = GuildId, score = Point} = AnsInfo,
        NewRMap = mod_guild_feast_quiz:add_role_point(RoleId, RoleName, GuildId, Point, RMap),
        NewRMap
    end,
    RoleMap1 = lists:foldl(F, RoleMap, RList),
    QuizMap1 = QuizMap#{TopicNo => true},
    State1 = State#status_gfeast{quiz_map = QuizMap1, guild_role_map = RoleMap1, role_list = []},

    IsQuizFinish = maps:get(TopicNo, QuizMap, false), % 同一题结算会有多个公会消息传来，只处理第一个消息
    case {RList, IsQuizFinish} of
        {[], false} -> % 没人答对本题
            TotalNum = data_guild_feast:get_cfg(choose_question_num) + data_guild_feast:get_cfg(short_answer_question_num),
            CurNum = maps:keys(QuizMap1),
            LanId = ?IF(length(CurNum) == TotalNum, ?no_one_right_answer_last, ?no_one_right_answer),
            lib_chat:send_TV({all_guild}, ?MOD_GUILD_ACT, LanId, [RightAnswer]);
        {[], true} -> % 本题结算过
            skip;
        _ -> % 找出第一个答对的人
            #gfeast_rank_role{role_name = RName} = lists:keyfind(1, #gfeast_rank_role.rank, RList),
            lib_chat:send_TV({all_guild}, ?MOD_GUILD_ACT, ?first_right_answer, [RightAnswer, RName])
    end,

    SceneId = data_guild_feast:get_cfg(scene_id),
    RoleRankInfo0 = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
    RoleRankInfo = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap1))),

    F1 = fun({RoleId, _, _, _, _}) ->
        Bin40220 = lib_guild_feast:pack_role_score_rank(RoleId, RoleRankInfo),
        lib_server_send:send_to_uid(RoleId, Bin40220)
    end,
    lists:foreach(F1, RoleRankInfo -- RoleRankInfo0),

    Bin40214 = lib_guild_feast:pack_role_rank_info(RoleRankInfo, 3),
    lib_server_send:send_to_scene(SceneId, ?DEF_SCENE_PID, Bin40214),

    {keep_state, State1};

%% 更新宴会答题积分  针对同一个公会的排行榜
do_handle_event(cast, {'right_answer', _RoleId, GuildName, GuildId, ScorePlus, PackRoleListLast}, open, State) ->
	#status_gfeast{
		gfeast_guild_rank = GFeastRank} = State,
	NowTime = utime:unixtime(),
	case lists:keyfind(GuildId, #gfeast_guild_rank_info.guild_id, GFeastRank) of
		#gfeast_guild_rank_info{score = OldScore} = TempR ->
			NewScore = OldScore + ScorePlus,
			NewRank = TempR#gfeast_guild_rank_info{score = NewScore, utime = NowTime, rank_list = PackRoleListLast},
			GFeastRank1 = lists:keystore(GuildId, #gfeast_guild_rank_info.guild_id,  GFeastRank, NewRank),
			%%重新排序一下
			NewGFeastRank = lib_guild_feast:refresh_rank(GFeastRank1);  %%重新排序
		false -> %%第一次答对题目
			NewRank = #gfeast_guild_rank_info{score = ScorePlus, utime = NowTime, guild_id = GuildId, guild_name = GuildName,
				rank_list = PackRoleListLast},
			Ranklist1 = lists:keystore(GuildId,  #gfeast_guild_rank_info.guild_id, GFeastRank, NewRank),
			%%重新排序一下
			NewGFeastRank = lib_guild_feast:refresh_rank(Ranklist1)
	end,
    % 在 mod_guild_feast_quiz 进程发送排名更新
	% PackGuildList = [{GuildId1, config:get_server_num(), Name1, Point1, Rank1} ||
	% 	#gfeast_guild_rank_info{guild_id = GuildId1, guild_name = Name1, score = Point1, rank_no = Rank1} <- NewGFeastRank],
	% SceneId = data_guild_feast:get_cfg(scene_id),  %%场景id
	% IsKf =
	% 	case lib_guild_feast:is_kf() of
	% 		true ->
	% 			1;
	% 		_ ->
	% 			0
	% 	end,
	% {ok, BinData} = pt_402:write(40214, [IsKf, PackGuildList, PackRoleListLast]),
	% lib_server_send:send_to_scene(SceneId, ?DEF_SCENE_PID, BinData), %%给场景的所有玩家发送信息
	NewState = State#status_gfeast{
		gfeast_guild_rank = NewGFeastRank},
	{keep_state, NewState};

%%%% 发送排行榜奖励  公会内的排行榜
%%do_handle_event(cast, {'send_point_reward', GuildId}, open, State) ->
%%	#status_gfeast{gfeast_rank = RankInfoList} = State,
%%	case lists:keyfind(GuildId, #gfeast_rank_info.guild_id, RankInfoList) of
%%		#gfeast_rank_info{rank_list = RankList} ->
%%			[lib_guild_feast:send_point_reward(X) || X <- RankList];
%%		_ ->
%%			skip
%%	end,
%%	{keep_state, State};

%% 发送排行榜奖励
do_handle_event(cast, {'send_point_reward', _GuildId}, open, State) ->
	#status_gfeast{gfeast_rank = RankInfoList} = State,
    GameType = lib_guild_feast:get_game_type(),
	[lib_guild_feast:send_point_reward(GameType, X) ||
		#gfeast_rank_info{get_reward_status =  GetRewardStatus} = X <- RankInfoList, GetRewardStatus == 0],
	NewRankInfoList  = [   Y#gfeast_rank_info{get_reward_status =  1}   || Y <- RankInfoList],
	{keep_state, State#status_gfeast{gfeast_rank =  NewRankInfoList}}; %%防止其他公会也用这个接口，


%% 宴会答题信息
do_handle_event(cast, {'send_quiz_info', RoleId, GuildId}, open, State) ->
	#status_gfeast{gfeast_guild = GFeastGuilds, quiz_stime = QuizActStime} = State,
	NowTime = utime:unixtime(),
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GFeastGuilds) of
		#gfeast_guild{quiz_pid = QuizPid} ->
			NewGFeastGuilds = case QuizActStime > 0 andalso NowTime >= QuizActStime of
				                  true ->
					                  mod_guild_feast_quiz:send_quiz_info(QuizPid, RoleId),
					                  GFeastGuilds;
				                  false ->
					                  Args = [?ACT_STATUS_CLOSE, QuizActStime, 0, 0],
					                  {ok, BinData} = pt_402:write(40217, Args),
					                  lib_server_send:send_to_uid(RoleId, BinData),
					                  GFeastGuilds
			                  end,
			NewState = State#status_gfeast{gfeast_guild = NewGFeastGuilds},
			{keep_state, NewState};
		_ ->
			{keep_state, State}
	end;



%% 宴会答题信息
do_handle_event(cast, {'set_topic_time'}, open, State) ->
	#status_gfeast{quiz_pid = QuizPid} = State,
	mod_guild_feast_quiz:set_topic_time(QuizPid),
	{keep_state, State};





%% -----------------------------------------------------------------
%% @desc     功能描述    点击火苗      检查 -> 更新获得火苗列表, 火苗列表->发送奖励->通知所有在公会的玩家->返回
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event(cast, {'collect_fire', RoleId, FireId, GuildId}, open, #status_gfeast{gfeast_guild = GuildList} = State) ->
	case lib_guild_feast_chect:collect_fire(State, RoleId, FireId, GuildId) of
		true ->
			%%更新火苗列表  就是删除火苗，获得火苗列表
			Guild = lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList),  %%必然有，上面已经检查了
			#gfeast_guild{fire_list = FireList, get_fire_list = GetFireList} = Guild,   %% [{fire_id, color}]
			NewFireList = lists:keydelete(FireId, 1, FireList),
			%%获得火苗列表
			NewGetFrieList = [RoleId | GetFireList],   %%肯定是没有的，检查过了
			NewGuild = Guild#gfeast_guild{fire_list = NewFireList, get_fire_list = NewGetFrieList},
			NewGuildList = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, NewGuild),
			%% 发送奖励, 生成奖励 -》发送奖励
			OpenDay = util:get_open_day(),
			{_, Color} = lists:keyfind(FireId, 1, FireList),   %%获得品质，且必然有，检查过了
			RewardList = data_guild_feast:get_fire_reward(Color, OpenDay),
			case RewardList of
				[] ->
					?ERR("err_fire_cfg ~n", []),
					ok;
				_ ->
					?DEBUG("Reward ~pn", [RewardList]),
					Produce = #produce{reward = RewardList, type = guild_feast_fire},
					lib_goods_api:send_reward_with_mail(RoleId, Produce)
			end,
			%% 通知所有玩家，火苗列表的刷新
			?DEBUG("?NewGuild ~p~n", [NewGuild]),
			lib_guild_feast:send_to_all_fire_by_guild(NewFireList, NewGuild),
			%%通知奖励列表
			{ok, Bin1} = pt_402:write(40257, [RewardList]),
			lib_server_send:send_to_uid(RoleId, Bin1),
			%%增加龙魂
			DragonPoint = data_guild_feast:get_cfg(collect_fire_dragon_spirit),
			add_dragon_spirit(GuildId, DragonPoint),
			NewState = State#status_gfeast{gfeast_guild = NewGuildList};
		{false, Err} ->
			?DEBUG("Err ~p~n", [Err]),
			NewState = State,
			lib_server_send:send_to_uid(RoleId, pt_402, 40200, [Err])
	end,
	{keep_state, NewState};





%% -----------------------------------------------------------------
%% @desc     功能描述  预备远古巨龙    检查龙魂够不够 ->开启15秒后开启巨龙模式， 15后，还是不够，则直接离开
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event(cast, {'pre_enter_dragon', GuildId}, open, #status_gfeast{gfeast_guild = GuildS, send_act_end = Flag} = State) ->
	IsKf = lib_guild_feast:is_kf(),
    GameType = lib_guild_feast:get_game_type(),
	if
		IsKf == true andalso Flag == 0 ->
			mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, end_act, [GameType]),
			NewFlag = 1;
		true ->
%%			?MYLOG("feast", "IsKf ~p    Flag  ~p  ~n", [IsKf, Flag]),
			NewFlag = Flag
	end,
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildS) of
		false ->  %%不存在这个公会
			{keep_state, State};
		Guild ->
%%			?DEBUG("pre_enter_dragon model~n", []),
			EnterPreTime = data_guild_feast:get_cfg(dragon_pre_time),
			if
				EnterPreTime == 0 ->
					Ref = erlang:send(self(), {'enter_dragon', GuildId}),  %%立即进入
					NewGuildList = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildS, Guild#gfeast_guild{enter_dragon_ref = Ref}),
					NewState = State#status_gfeast{stage = ?GUILD_FEAST_STAGE_DRAGON_WAIT,
						etime = EnterPreTime + utime:unixtime(), gfeast_guild = NewGuildList, send_act_end = NewFlag, gfeast_guild_rank = []},
					{keep_state, NewState};
				true ->
					{ok, Bin} = pt_402:write(40211, [1, lib_guild_feast:get_end_time(1), EnterPreTime + utime:unixtime(), ?GUILD_FEAST_STAGE_DRAGON_WAIT]),
					[lib_server_send:send_to_uid(X, Bin) || X <- Guild#gfeast_guild.role_list],
					{ok, Bin1} = pt_402:write(40260, [Guild#gfeast_guild.dragon_point]),  %%推送龙魂
					[lib_server_send:send_to_uid(Y, Bin1) || Y <- Guild#gfeast_guild.role_list],
					Ref = erlang:send_after(EnterPreTime * 1000, self(), {'enter_dragon', GuildId}),  %%15秒后开启巨龙模式
					NewGuildList = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildS, Guild#gfeast_guild{enter_dragon_ref = Ref}),
					NewState = State#status_gfeast{stage = ?GUILD_FEAST_STAGE_DRAGON_WAIT,
						etime = EnterPreTime + utime:unixtime(), gfeast_guild = NewGuildList, send_act_end = NewFlag, gfeast_guild_rank = []},
					{keep_state, NewState}
			end
	end;


%% -----------------------------------------------------------------
%% @desc     功能描述  预备远古巨龙    检查龙魂够不够 ->开启15秒后开启巨龙模式， 15后，还是不够，则直接离开
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event(info, {'pre_enter_dragon', GuildId}, open, #status_gfeast{gfeast_guild = GuildS, send_act_end = Flag, gfeast_guild_rank = _GuildPointList} = State) ->
	IsKf = lib_guild_feast:is_kf(),
    GameType = lib_guild_feast:get_game_type(),
	if
		IsKf == true andalso Flag == 0 ->
			mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, end_act, [GameType]),
			NewFlag = 1;
		true ->
            GameType = lib_guild_feast:get_game_type(),
	        lib_guild_feast:quest_calc_reward(GameType, State),
			NewFlag = Flag
	end,
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildS) of
		false ->  %%不存在这个公会
			{keep_state, State};
		Guild ->
			EnterPreTime = data_guild_feast:get_cfg(dragon_pre_time),
			{ok, Bin} = pt_402:write(40211, [1, lib_guild_feast:get_end_time(1), EnterPreTime + utime:unixtime(), ?GUILD_FEAST_STAGE_DRAGON_WAIT]),
			[lib_server_send:send_to_uid(X, Bin) || X <- Guild#gfeast_guild.role_list],
			{ok, Bin1} = pt_402:write(40260, [Guild#gfeast_guild.dragon_point]),  %%推送龙魂
			[lib_server_send:send_to_uid(Y, Bin1) || Y <- Guild#gfeast_guild.role_list],
			erlang:send_after(EnterPreTime * 1000, self(), {'enter_dragon', GuildId}),  %%15秒后开启巨龙模式
			NewState = State#status_gfeast{stage = ?GUILD_FEAST_STAGE_DRAGON_WAIT,
				etime = EnterPreTime + utime:unixtime(), send_act_end = NewFlag, gfeast_guild_rank = []},
			{keep_state, NewState}
	end;
%%	case lib_guild_feast_chect:enter_dragon(GuildId, State) of
%%		true ->
%%
%%		{false, _Err} ->
%%			#status_gfeast{gfeast_guild = GuildS} = State,
%%			case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildS) of
%%				false ->  %%不存在这个公会
%%					{keep_state, State};
%%				Guild ->  %%龙魂不够
%%%%					?DEBUG("15 秒后进入巨龙模式，如果还是不够，则直接离开~n", []),
%%					%%告诉客户端龙魂数量
%%					{ok, Bin} = pt_402:write(40260, [Guild#gfeast_guild.dragon_point]),
%%					[lib_server_send:send_to_uid(X, Bin) || X <- Guild#gfeast_guild.role_list],
%%					%%告诉客户端进入离开倒计时
%%					{ok, Bin1} = pt_402:write(40258, [4, ExitTime]),    %%4是离开
%%					[lib_server_send:send_to_uid(M, Bin1) || M <- Guild#gfeast_guild.role_list],
%%					NewGuild = Guild#gfeast_guild{ref = ExitRef}, %%保存离场定时器
%%					NewGuildList = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildS, NewGuild),
%%					NewState = State#status_gfeast{gfeast_guild = NewGuildList}, %%修正State
%%					{keep_state, NewState}
%%			end
%%	end;

%%增加龙魂
do_handle_event(cast, {'add_dragon_spirit', GuildId, Num}, open, State) ->
	#status_gfeast{gfeast_guild = GuildList} = State,
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		false -> %%没有这个公会
			{keep_state, State};
		Guild ->
			#gfeast_guild{dragon_point = OldPoint} = Guild,
			NewPoint = OldPoint + Num,
			%%发送龙魂信息
			NewGuild = Guild#gfeast_guild{dragon_point = NewPoint},
			{ok, Bin1} = pt_402:write(40260, [NewPoint]),
			[lib_server_send:send_to_uid(Role, Bin1) || Role <- Guild#gfeast_guild.role_list],
			%%修正数据
			NewGuildList = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, NewGuild),
			NewState = State#status_gfeast{gfeast_guild = NewGuildList},
			{keep_state, NewState}
	end;
%% -----------------------------------------------------------------
%% @desc     功能描述  远古巨龙被杀死, 也可能是  发送奖励 ->清理相关数据->离场
%% @param    参数     Minfo:::#scene_object{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event(cast, {'kill_boss', AtterId, MonArgs, ModArgs}, open, State) ->
	#mon_args{id = MonId} = MonArgs,
%%	#status_gfeast{mon_map = MonMap, gfeast_guild = GuildList} = State,
%%	?DEBUG("map:~p~n ", [MonMap]),
	NewState = lib_guild_feast:collect_fire(MonId, AtterId, State),
	NewState1 = lib_guild_feast:handle_dragon_be_kill(MonArgs, AtterId, NewState, ModArgs),
	{keep_state, NewState1};


%%发送积分排行榜
do_handle_event(cast, {'send_quiz_rank_by_guild', _GuildId}, open, State) ->
	lib_guild_feast:send_quiz_rank_by_guild(_GuildId, State),
	{keep_state, State};

%%正式开启巨龙模式   生成怪物 ->保存到map中 ->设置超时定时器-> 改变状态阶段
do_handle_event(info, {'enter_dragon', GuildId}, open, #status_gfeast{mon_map = _MonMap, gfeast_guild = GuildList,
	can_summon_ref = OldSummonRef} = State) ->
	case lib_guild_feast_chect:enter_dragon(GuildId, State) of
		true ->
			LimitTime = data_guild_feast:get_cfg(dragon_time),
			SummonTimeLimit = data_guild_feast:get_cfg(summon_time_limit),
			SummonTimeLimitRef = util:send_after(OldSummonRef, SummonTimeLimit * 1000, self(), 'summon_time_limit'),
			NewGuildList =
				case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
					false ->
						_LimitRef  = [],
						GuildList;
					#gfeast_guild{role_list = RoleList} = Guild ->
						%%宴会阶段变更推送客户端
						LimitRef = erlang:send_after(LimitTime * 1000, self(), {'dragon_time_out', GuildId}),
						{ok, BinData} = pt_402:write(40211, [1, lib_guild_feast:get_end_time(1), utime:unixtime() + LimitTime, ?GUILD_FEAST_STAGE_DRAGON]),
						[lib_server_send:send_to_uid(RoleId, BinData) || RoleId <- RoleList],
						lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, Guild#gfeast_guild{dragon_time_out_ref = LimitRef})
				end,
%%			NewMonMap = maps:put(MonId, {GuildId, LimitRef}, MonMap),  %%保存到map中
			NewState = State#status_gfeast{stage = ?GUILD_FEAST_STAGE_DRAGON, mon_map = #{}, etime = utime:unixtime() + LimitTime, gfeast_guild = NewGuildList,
				can_summon_ref = SummonTimeLimitRef, can_summon_dragon = ?can_summon_dragon},
			{keep_state, NewState};
		{false, Err} ->
			%%强制离开场景，发送错误码
			?DEBUG("dragon not enough ~n", []),
			LimitTime = data_guild_feast:get_cfg(dragon_time),
			NewGuildList = case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
				false ->
					GuildList;
				#gfeast_guild{role_list = RoleList} = Guild ->
					{ok, Bin} = pt_402:write(40200, [Err]), %%错误码
%%					{ok, Bin1} = pt_402:write(40262, [3, []]),
					[begin lib_server_send:send_to_uid(RoleId, Bin), %%发送错误码
%%					lib_server_send:send_to_uid(RoleId, Bin1),  %%发送挑战结果
					exit_scene(RoleId, GuildId)         %%退出场景
					end || RoleId <- RoleList],
					LimitRef = erlang:send_after(LimitTime * 1000, self(), {'dragon_time_out', GuildId}),
					lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, Guild#gfeast_guild{dragon_time_out_ref = LimitRef})
			end,
			NewState = State#status_gfeast{stage = ?GUILD_FEAST_STAGE_DRAGON, etime = utime:unixtime() + LimitTime, gfeast_guild = NewGuildList},
			{keep_state, NewState}
	end;


%%整个公会离场
do_handle_event(info, {'exit_scene', _GuildId}, open, State) ->
%%	#status_gfeast{gfeast_guild = GuildList} = State,
%%	RoleList =
%%		case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
%%			[] ->
%%				[];
%%			Guild ->
%%				Guild#gfeast_guild.role_list
%%		end,
%%	[exit_scene(Role, GuildId) || Role <- RoleList],  %%退出场景
	{keep_state, State};

%%远古巨龙超时  清理相关数据->离场
do_handle_event(info, {'dragon_time_out', _GuildId}, open, State) ->
%%	?DEBUG("dragon_time_out   ~n", []),
%%	#status_gfeast{gfeast_guild = GuildList} = State,
	%%全部人离场
%%	RoleList =
%%		case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
%%			false ->
%%				[];
%%			Guild ->
%%				Guild#gfeast_guild.role_list
%%		end,
%%	{ok, Bin} = pt_402:write(40262, [2, []]),  %%失败
%%	[exit_scene(Role, GuildId) || Role <- RoleList],  %%退出场景
%%	[lib_server_send:send_to_uid(X, Bin) || X <- RoleList],
	{keep_state, State};


%% 秘籍结算关闭活动
do_handle_event(cast, {'gm_close'}, open, State) ->
	#status_gfeast{ref = ORef, gfeast_guild = GfeastGuildList} = State,
	lib_activitycalen_api:success_end_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY),
	spawn(fun() ->
		[gen_statem:stop(Pid) || #gfeast_guild{quiz_pid = Pid} <- GfeastGuildList]
	      end),
	util:cancel_timer(ORef),
	NRef = erlang:send_after(1, self(), 'time_out'),
	NewState = State#status_gfeast{ref = NRef},
    GameType = lib_guild_feast:get_game_type(),
	mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, end_act, [GameType]),
	{keep_state, NewState};

%% 秘籍结算关闭活动 不影响跨服的结算，用于外服的特殊情况
do_handle_event(cast, {'gm_close_without_kf'}, open, State) ->
	#status_gfeast{ref = ORef, gfeast_guild = GfeastGuildList} = State,
	[gen_statem:stop(Pid) || #gfeast_guild{quiz_pid = Pid} <- GfeastGuildList],
	util:cancel_timer(ORef),

	NRef = erlang:send_after(1, self(), 'time_out'),
	NewState = State#status_gfeast{ref = NRef},
%%	mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, end_act, []),
	{keep_state, NewState};

%% 活动开始
do_handle_event(info, 'time_out', close, _State) ->
	start_act(_State);



%% 秘籍开启活动
do_handle_event(info, 'gm_open', close, _State) ->
	#status_gfeast{ref = ORef} = _State,
	GuildList = lib_guild_feast:get_init_guild(),
	State = _State#status_gfeast{gfeast_guild = GuildList},
	util:cancel_timer(ORef),
	NowTime = utime:unixtime(),
%%	{_StateName, _, CountDownTime, _Etime} = lib_guild_feast:get_next_time(NowTime),     %%  Etime 整个宴会的
	lib_activitycalen_api:success_start_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY),
	QuizActCountDown = data_guild_feast:get_cfg(fire_exist_time),  %%篝火持续时间
	EnterQuestionWaitTime = data_guild_feast:get_cfg(enter_question_wait_time),  %%进入答题等待时间
	GuildBossWaitTime = data_guild_feast:get_cfg(guild_boss_wait_time),  %%公会boss等待时间
	QuizActStime = NowTime + QuizActCountDown + EnterQuestionWaitTime,  %%答题开始时间
	QuizActRef = erlang:send_after((QuizActCountDown + EnterQuestionWaitTime) * 1000, self(), 'start_quiz_act'),  %%答题定时器
	StateRef = erlang:send_after(GuildBossWaitTime * 1000, self(), {next_stage, ?GUILD_BOSS_SUMMON, QuizActCountDown - GuildBossWaitTime}),
    % 传闻
    GameName = lib_guild_feast:get_game_name(lib_guild_feast:get_game_type()),
	lib_chat:send_TV({all_guild}, ?MOD_GUILD_ACT, 5, [GameName, QuizActCountDown]),
	{ok, BinData} = pt_402:write(40211, [?ACT_STATUS_OPEN, lib_guild_feast:get_end_time(?ACT_STATUS_OPEN), utime:unixtime() + GuildBossWaitTime, ?GUILD_BOSS_SUMMON]),  %%宴会开始推送客户端
    {ok, BinData1} = pt_402:write(40222, [lib_guild_feast:get_game_id()]),
	%%发送经验定时器
	ExpTiem = data_guild_feast:get_cfg(exp_plus_interval),
	erlang:send_after(ExpTiem * 1000, self(), 'send_exp'),
	_SceneId = data_guild_feast:get_cfg(scene_id),
	%%生成篝火
	NewState = lib_guild_feast:creat_fire(State),
	lib_server_send:send_to_all_guild(BinData),
	lib_server_send:send_to_all_guild(BinData1),
	Duration = data_guild_feast:get_cfg(duration),  %%宴会持续时间
	Ref = erlang:send_after((Duration + 1) * 1000, self(), 'time_out'), %活动结束定时器  CountDownTime  %%先直接改为 现在 + 持续时间
	StageStatus = ?GUILD_BOSS_WAIT,
	% mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, start_topic, []),
    % 跨服答题进程(当前仅作积分统计用)启动
    ?IF(lib_guild_feast:is_kf(),
        mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, start_topic, [config:get_server_id()]),
        mod_guild_feast_mgr:set_topic(lib_guild_feast_mod:get_quiz())
    ),
	NewGuildList = [X#gfeast_guild{} || X <- GuildList],
	StatusGFeast = NewState#status_gfeast{
		status = ?ACT_STATUS_OPEN,
		stage = StageStatus,  %% 和初始化同理
		etime = utime:unixtime() + GuildBossWaitTime,   %%第一阶段结束时间戳
		ref = Ref,
		gfeast_guild = NewGuildList,
		quiz_ref = QuizActRef,
		stage_ref = StateRef,
		quiz_stime = QuizActStime,
		is_kf = lib_guild_feast:is_kf(),
		send_act_end = 0
		,fire_exp_map = #{}
	},
	{next_state, open, StatusGFeast};

%% -----------------------------------------------------------------
%% @desc     功能描述   刷新篝火   判断是否还是处于篝火状态 -> 根据篝火晚宴场景人数刷新篝火 ->
%%                                遍历每个公会，发送篝火列表给每个玩家->下个30秒再刷新
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event(info, 'reflush_fire', open, #status_gfeast{stage = StageStatus, gfeast_guild = _Guilds} = State) when StageStatus == ?GUILD_FEAST_STAGE_FIRE ->
%%	NewGuilds = [lib_guild_feast:reflush_fire_by_guild(X) || X <- Guilds],
%%	NewState = State#status_gfeast{gfeast_guild = NewGuilds},
%%	ReflushTime = data_guild_feast:get_cfg(fire_reflush_time), %%火苗刷新时间
%%	FireDisappear = data_guild_feast:get_cfg(fire_disappear),  %%火苗消失时间
%%	erlang:send_after(ReflushTime * 1000, self(), 'reflush_fire'),  %%30秒后再度刷新
%%	erlang:send_after(FireDisappear * 1000, self(), 'disappear_fire'),  %消失
	{keep_state, State};


%% 活动结束
do_handle_event(info, 'time_out', open, State) ->
	#status_gfeast{ref = ORef, send_act_end = Flag, gfeast_guild_rank = _GuildPointList} = State,
	IsKf = lib_guild_feast:is_kf(),
    GameType = lib_guild_feast:get_game_type(),
	if
		IsKf == true andalso Flag == 0 ->
			mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, end_act, [GameType]);
		true ->
			lib_guild_feast:quest_calc_reward(GameType, State),
			skip
	end,
	lib_activitycalen_api:success_end_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY),
	util:cancel_timer(ORef),
	%% 保证进程正常关闭
	spawn(fun()->
		lib_guild_feast:act_close(State)
	end),
	{ok, Bin1} = pt_402:write(40211, [0, 0, 0, 0]),
	lib_server_send:send_to_all_guild(Bin1),
	StatusGFeast = #status_gfeast{
		status = 0,  %%未开启，活动结束
		etime = 0,
		stage = 0,
		ref = [],
		gfeast_guild = [],
		gfeast_rank = [],
		fire_exp_map = #{},
		quiz_stime = 0,
		gfeast_guild_rank = [],
        topic_list = []
	},
	{next_state, close, StatusGFeast};

%% 答题开始(新版融合了每周轮换的小游戏)
do_handle_event(info, 'start_quiz_act', open, State) ->
	#status_gfeast{gfeast_guild = GFeastGuilds, topic_list = QuizIds, quiz_ref = OQuizActRef, status = ActStatus} = State,
	util:cancel_timer(OQuizActRef),
    case lib_guild_feast:get_game_type() of
        quiz ->
            NewGFeastGuilds = lists:map(fun(T) ->
                {ok, QuizPid} = mod_guild_feast_quiz:start(T#gfeast_guild.guild_id, QuizIds),
                T#gfeast_guild{quiz_pid = QuizPid} end, GFeastGuilds);
        _ ->
            NewGFeastGuilds = GFeastGuilds
    end,
	QuestionExistTime = data_guild_feast:get_cfg(question_exist_time),
	NewEtime = QuestionExistTime + utime:unixtime(),
	%%推送给客户端
	{ok, BinData} = pt_402:write(40211, [ActStatus, lib_guild_feast:get_end_time(ActStatus), NewEtime, ?GUILD_FEAST_STAGE_QUESTION]),  %%宴会开始推送客户端
	SceneId = data_guild_feast:get_cfg(scene_id),
	lib_server_send:send_to_scene(SceneId, ?DEF_SCENE_PID, BinData),
	TempState = lib_guild_feast:clear_fire(State),
	NewState = TempState#status_gfeast{gfeast_guild = NewGFeastGuilds, quiz_ref = [],
		stage = ?GUILD_FEAST_STAGE_QUESTION, etime = NewEtime}, %%答题阶段
	{keep_state, NewState};

%% 提前推送客户端 Time::倒数秒数
do_handle_event(info, {next_stage, Stage, Time}, open, #status_gfeast{status = Status} = State) ->
	{ok, BinData} = pt_402:write(40211, [Status, lib_guild_feast:get_end_time(Status), utime:unixtime() + Time, Stage]),  %%宴会开始推送客户端 time 多少秒后进入Stage阶段
	SceneId = data_guild_feast:get_cfg(scene_id),
	lib_server_send:send_to_scene(SceneId, ?DEF_SCENE_PID, BinData),
	_LastState = State#status_gfeast{etime = utime:unixtime() + Time, stage = Stage},
	if
		Stage == ?GUILD_BOSS_SUMMON ->
            QuizActCountDown = data_guild_feast:get_cfg(fire_exist_time),  %%篝火持续时间(第一部分 + 第二部分总时间)
            GuildBossWaitTime = data_guild_feast:get_cfg(guild_boss_wait_time),  %%篝火持续时间(第一部分 + 第二部分总时间)
            EnterQuestionWaitTime = data_guild_feast:get_cfg(enter_question_wait_time),  %%进入答题等待时间
			StageRef = erlang:send_after((QuizActCountDown - GuildBossWaitTime) * 1000, self(),
				{next_stage, ?GUILD_FEAST_STAGE_QUESTION_WAIT, EnterQuestionWaitTime}),
			LastState = _LastState#status_gfeast{stage_ref = StageRef};
		true ->
			LastState = _LastState
	end,
	{keep_state, LastState};


%% 发送经验定时器 %%要篝火阶段才能发送
do_handle_event(info, 'send_exp', open, #status_gfeast{gfeast_guild = GuildList, stage = Stage} = State) ->
	[[
		lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild_feast, send_fire_reward, [])
		|| RoleId <- RoleList] ||
		#gfeast_guild{role_list = RoleList} <- GuildList],
	if
		Stage == ?GUILD_BOSS_WAIT orelse  Stage == ?GUILD_BOSS_SUMMON orelse
			Stage == ?GUILD_FEAST_STAGE_QUESTION_WAIT orelse Stage == ?GUILD_FEAST_STAGE_QUESTION->
			ExpTime = data_guild_feast:get_cfg(exp_plus_interval),
			erlang:send_after(ExpTime * 1000, self(), 'send_exp');
		true ->
			skip
	end,
	{keep_state, State};

%%  不能再召唤
do_handle_event(info, 'summon_time_limit', open, State) ->
%%	?MYLOG("cymfeast", "summon_time_limit", []),
	{keep_state, State#status_gfeast{can_summon_dragon = ?can_not_summon_dragon}};

do_handle_event(cast, {'send_exp', RoleId, ExpAdd}, open, #status_gfeast{stage = Stage, fire_exp_map = ExpMap} = State)
	when Stage == ?GUILD_BOSS_WAIT orelse Stage == ?GUILD_BOSS_SUMMON orelse Stage == ?GUILD_FEAST_STAGE_QUESTION_WAIT
	orelse Stage == ?GUILD_FEAST_STAGE_QUESTION->
%%	?DEBUG("send_exp  RoleId  ~p exp ~p~n",  [RoleId, ExpAdd]),
	NewExp = maps:get(RoleId, ExpMap, 0) + ExpAdd,   %%累积经验
	NewMap = maps:put(RoleId, NewExp, ExpMap),
	{ok, Bin} = pt_402:write(40255, [1, NewExp]),     %%通知客户端。
	lib_server_send:send_to_uid(RoleId, Bin),         %%通知客户端
	{keep_state, State#status_gfeast{fire_exp_map = NewMap}};


do_handle_event(info, 'disappear_fire', open, #status_gfeast{stage = ?GUILD_FEAST_STAGE_FIRE, gfeast_guild = GuildList} = State) ->
	NewGuildList = [lib_guild_feast:disappear(X) || X <- GuildList],
	NewState = State#status_gfeast{gfeast_guild = NewGuildList},
	{keep_state, NewState};

%% 秘籍设置轮换游戏
do_handle_event(cast, {'gm_set_game_type', Id}, _, State) ->
    GameType =
    case Id of
        0 -> 'quiz';
        1 -> 'note_crash';
        _ -> undefined
    end,
    put('game_type', GameType),
    {keep_state, State};

%%发送篝火经验
do_handle_event(cast, {'get_fire_exp_by_role_id', RoleId}, open, #status_gfeast{fire_exp_map = Map} = _State) ->
	Exp = maps:get(RoleId, Map, 0),
	{ok, Bin} = pt_402:write(40255, [0, Exp]),
	lib_server_send:send_to_uid(RoleId, Bin),
	{keep_state, _State};

%%向同一个公会的人发送龙魂信息
do_handle_event(cast, {'send_dragon_point_by_guild', GuildId}, open, #status_gfeast{gfeast_guild = GuildList} = _State) ->
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		false ->
			skip;
		#gfeast_guild{dragon_point = Point, role_list = RoleList} ->
			{ok, Bin} = pt_402:write(40260, [Point]),
			[lib_server_send:send_to_uid(RoleId, Bin) || RoleId <- RoleList]
	end,
	{keep_state, _State};

%% 向用户发送火苗信息  处于篝火阶段
do_handle_event(cast, {'send_fire_to_user', RoleId, GuildId}, open, #status_gfeast{gfeast_guild = GuildList, stage = ?GUILD_FEAST_STAGE_FIRE} = _State) ->
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		false ->
			skip;
		#gfeast_guild{fire_wave = Wave, fire_list = _FireList, next_fire_time = Time} ->
			lib_server_send:send_to_uid(RoleId, pt_402, 40256, [Wave, Time])
	end,
	{keep_state, _State};

%% 向用户发送火苗信息  ---不是处于篝火阶段
do_handle_event(cast, {'send_fire_to_user', RoleId, _GuildId}, open, #status_gfeast{gfeast_guild = _GuildList} = _State) ->
	lib_server_send:send_to_uid(RoleId, pt_402, 40256, [0, 0]),
	{keep_state, _State};


%%向一个用户请求龙魂信息
do_handle_event(cast, {'send_dragon_point', RoleId, GuildId}, open, #status_gfeast{gfeast_guild = GuildList} = _State) ->
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		false ->
			skip;
		#gfeast_guild{dragon_point = Point} ->
			{ok, Bin} = pt_402:write(40260, [Point]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end,
	{keep_state, _State};


%%发送传闻
do_handle_event(cast, {'send_quiz_TV_by_guild', GuildId, QuizState}, open, #status_gfeast{gfeast_guild = GuildList} = _State) ->
%%	?DEBUG("send tv~n", []),
	lib_guild_feast:send_quiz_TV_by_guild(GuildId, QuizState, GuildList),
	{keep_state, _State};

%%召唤巨龙
do_handle_event(cast, {'summon_dragon', RoleId, GuildId, Cost, Type}, open,
	#status_gfeast{gfeast_guild = GuildList, stage = ?GUILD_FEAST_STAGE_DRAGON, can_summon_dragon = CanSummonDragon} = State) ->
	if
		CanSummonDragon == ?can_not_summon_dragon ->
			NewGuildList = GuildList,
			send_error_code(RoleId, ?ERRCODE(err402_summon_time_limit));
		true ->
			NewGuildList = lib_guild_feast:summon_dragon(RoleId, GuildId, Cost, Type, GuildList)
	end,
	{keep_state, State#status_gfeast{gfeast_guild = NewGuildList}};

%%增加经验
do_handle_event(cast, {'add_guild_exp_ratio', GuildId, AddExpRatio, Type}, open,
	#status_gfeast{gfeast_guild = GuildList} = State) ->
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		#gfeast_guild{add_exp_ratio = OldRatio, role_list = RoleIdList, is_buy_food = IsBuy} = Guild ->
			LastRatio = min(data_guild_feast:get_cfg(guild_feast_max_exp_ratio), OldRatio + AddExpRatio),
%%			?PRINT("LastRatio ~p~n", [LastRatio]),
			if
				Type == 3 -> %%  3是高级菜肴
					IsBuyNew = 1;
				true ->
					IsBuyNew = IsBuy
			end,
			GuildNew = Guild#gfeast_guild{add_exp_ratio = LastRatio, is_buy_food = IsBuyNew},
			{ok, Bin} = pt_402:write(40267, [LastRatio]),
			[begin
				 lib_server_send:send_to_uid(RoleId, Bin),
				 mod_daily:set_count(RoleId, ?MOD_GUILD_ACT, 4, LastRatio)
			 end ||RoleId <- RoleIdList],
			spawn(fun()->
				lib_guild_feast:broadcast_food_status(RoleIdList, IsBuyNew)
			end),
			NewGuildList = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, GuildNew);
		_ ->
			NewGuildList = GuildList
	end,
	{keep_state, State#status_gfeast{gfeast_guild = NewGuildList}};

%%发送菜肴状态
do_handle_event(cast, {'send_food_status', RoleId, GuildId, PackList}, open,
	#status_gfeast{gfeast_guild = GuildList} = State) ->
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		#gfeast_guild{is_buy_food = IsBuy}  ->
			PackListNew = lists:keystore(3, 1, PackList, {3, IsBuy}),
			{ok, Bin} = pt_402:write(40265, [PackListNew]),
            lib_server_send:send_to_uid(RoleId, Bin),
			ok;
		_ ->
			skip
	end,
	{keep_state, State};

%% 小游戏初始化辅助
do_handle_event(cast, {'init_mini_game', {GfeastPlayer, GameType}}, PState, #status_gfeast{stage = StageStatus, etime = StageETime} = State) ->
    #gfeast_player{id = RoleId} = GfeastPlayer,
    NowTime = utime:unixtime(),
    Duration = lib_mini_game:get_game_duration(GameType),
    MaxStartTime = StageETime - Duration,
    case {MaxStartTime > NowTime, PState, StageStatus} of
        {true, open, ?GUILD_FEAST_STAGE_QUESTION} ->
            EndTime = NowTime + Duration,
            lib_mini_game:game_start2([GameType, RoleId, EndTime]);
        _ ->
            lib_mini_game:game_start_fail([GameType, RoleId])
    end,
    {keep_state, State};

%% 小游戏分数反馈
do_handle_event(cast, {'game_feedback', {PlayerInfo, GameType, Score, InfoList}}, open, State) ->
    NewState = lib_guild_feast_mod:game_feedback(State, PlayerInfo, GameType, Score, InfoList),
    {keep_state, NewState};

%% 小游戏分数反馈
do_handle_event(cast, {'send_game_rank_list', {PlayerInfo, GameType}}, open, State) ->
    lib_guild_feast_mod:send_game_rank_list(State, PlayerInfo, GameType),
    {keep_state, State};

%% 小游戏结束
do_handle_event(cast, {'game_time_out', {PlayerInfo, GameType, InfoList}}, open, State) ->
    #gfeast_player{id = RId, gid = GId} = PlayerInfo,
    NewState = lib_guild_feast_mod:game_time_out(State, GameType, InfoList, GId, RId),
    {keep_state, NewState};

%% 小游戏是否完成
do_handle_event(cast, {'mini_game_status', RoleId, _GuildId}, open, State) ->
    #status_gfeast{mini_game_rank = RankList} = State,
    #gfeast_rank_role{other_infos = InfoMap} = ulists:keyfind(RoleId, #gfeast_rank_role.role_id, RankList, #gfeast_rank_role{}),
    GameIsFinished = maps:get('game_finished', InfoMap, false),
    GameStatus = ?IF(GameIsFinished, ?MINI_GAME_HAS_FINISHED, ?MINI_GAME_NOT_FINISHED),
    lib_server_send:send_to_uid(RoleId, pt_402, 40221, [GameStatus]),
    {keep_state, State};

%% 当天轮换游戏类型
do_handle_event(cast, {'send_game_type', RoleId}, _, State) ->
    GameType = lib_guild_feast:get_game_id(),
    lib_server_send:send_to_uid(RoleId, pt_402, 40222, [GameType]),
    {keep_state, State};

%% 设置题目
%%TopicList
do_handle_event(cast, {'set_topic', TopicList}, open, State) ->
	{keep_state, State#status_gfeast{topic_list = TopicList}};



do_handle_event({call, From}, 'act_status', _StateName, State) ->
	#status_gfeast{status = ActStatus} = State,
	{keep_state, State, [{reply, From, ActStatus}]};


do_handle_event({call, From}, {'collect_checker', ModId, ModCfgId, {RoleId, GuildId}}, _StateName, State) ->
	{keep_state, State, [{reply, From, lib_guild_feast:collect_checker(ModId, ModCfgId, State, {RoleId, GuildId})}]};


do_handle_event(_Type, _Msg, StateName, State) ->
%%	?DEBUG("no match :~p~n", [[_Type, _Msg, StateName]]),
	{next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
	{ok, StateName, Status}.


send_error_code(Uid, ErrorCode) ->
	?DEBUG("ErrorCode ~p~n", [ErrorCode]),
	{ok, BinData} = pt_402:write(40200, [ErrorCode]),
	lib_server_send:send_to_uid(Uid, BinData).


start_act(_State)->
	#status_gfeast{ref = ORef} = _State,
	GuildList = lib_guild_feast:get_init_guild(),
	State = _State#status_gfeast{gfeast_guild = GuildList},
	util:cancel_timer(ORef),
	NowTime = utime:unixtime(),
	TimeL = data_guild_feast:get_cfg(open_time),  %% 开放时间段
	Duration = data_guild_feast:get_cfg(duration),  %%宴会持续时间
	ExitTime = data_guild_feast:get_cfg(exit_time),  %%退出倒计时
	Unixdate = utime:unixdate(NowTime),     %%当天0点时间戳
	{StateName, ActStatus, CountDownTime}
		= lib_guild_feast:do_get_next_time(lib_guild_feast:format_time(TimeL), Duration, ExitTime, NowTime - Unixdate),
	GuildBossWaitTime = data_guild_feast:get_cfg(guild_boss_wait_time),  %%公会boss等待时间
	if
		ActStatus == ?ACT_STATUS_OPEN -> %% 晚宴开启
			%% 通知活动日历
			lib_activitycalen_api:success_start_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY),
			QuizActCountDown = data_guild_feast:get_cfg(fire_exist_time),  %%篝火持续时间(第一部分 + 第二部分总时间)
			EnterQuestionWaitTime = data_guild_feast:get_cfg(enter_question_wait_time),  %%进入答题等待时间
			QuizActStime = NowTime + QuizActCountDown + EnterQuestionWaitTime,  %%答题开始时间
			QuizActRef = erlang:send_after((QuizActCountDown + EnterQuestionWaitTime) * 1000, self(), 'start_quiz_act'),  %%答题定时器
			StateRef = erlang:send_after(GuildBossWaitTime * 1000, self(), {next_stage, ?GUILD_BOSS_SUMMON, QuizActCountDown - GuildBossWaitTime}),
			{ok, BinData} = pt_402:write(40211, [ActStatus, lib_guild_feast:get_end_time(ActStatus), utime:unixtime() + GuildBossWaitTime, ?GUILD_BOSS_SUMMON]),  %%宴会开始推送客户端
            {ok, BinData1} = pt_402:write(40222, [lib_guild_feast:get_game_id()]),
            % 传闻
            GameName = lib_guild_feast:get_game_name(lib_guild_feast:get_game_type()),
	        lib_chat:send_TV({all_guild}, ?MOD_GUILD_ACT, 5, [GameName, QuizActCountDown]),
			%%发送经验定时器
			ExpTiem = data_guild_feast:get_cfg(exp_plus_interval),
			erlang:send_after(ExpTiem * 1000, self(), 'send_exp'),
			%%生成篝火
			NewState = lib_guild_feast:creat_fire(State),
			%% 跨服答题进程(当前仅作积分统计用)启动
            ?IF(lib_guild_feast:is_kf(),
                mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, start_topic, [config:get_server_id()]),
                mod_guild_feast_mgr:set_topic(lib_guild_feast_mod:get_quiz())
            ),
			lib_server_send:send_to_all_guild(BinData),
			lib_server_send:send_to_all_guild(BinData1);
		true ->
			NewState = State,
			StateRef = [],
			QuizActRef = [], QuizActStime = 0
	end,
	Ref = erlang:send_after((CountDownTime) * 1000, self(), 'time_out'), %活动结束定时器  CountDownTime  %%先直接改为 现在 + 持续时间
	NewGuildList = GuildList,
	StageStatus =    %%公会晚宴阶段
	case ActStatus of
		?ACT_STATUS_OPEN ->
			?GUILD_BOSS_WAIT;    %%  活动开始就是公会boss等待阶段
		_ ->
			?ACT_STATUS_CLOSE           %%  其他都是关闭阶段
	end,
	StatusGFeast = NewState#status_gfeast{
		status = ActStatus,
		stage = StageStatus,  %% 和初始化同理
		etime = utime:unixtime() + GuildBossWaitTime,
		ref = Ref,
		stage_ref = StateRef,
		gfeast_guild = NewGuildList,
		quiz_ref = QuizActRef,
		quiz_stime = QuizActStime
		,is_kf = lib_guild_feast:is_kf()
		,send_act_end = 0
		,fire_exp_map = #{}
	},
	{next_state, StateName, StatusGFeast}.