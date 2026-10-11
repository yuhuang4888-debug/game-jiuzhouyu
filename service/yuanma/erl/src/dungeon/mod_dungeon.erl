%% ---------------------------------------------------------------------------
%% @doc mod_dungeon.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本进程
%% ---------------------------------------------------------------------------
-module(mod_dungeon).
-export([]).

-compile(export_all).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("dungeon.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("chat.hrl").

%% ====================
%% 副本普通流程接口
%% ====================

%% 开启副本
start(TeamId, From, DunId, RoleList, Args) ->
    {ok, Pid} = gen_server:start(?MODULE, [DunId, TeamId, RoleList, Args], []),
    [unode:apply(Role#dungeon_role.node, lib_player, update_player_info, [Role#dungeon_role.id, [{copy_id, Pid}]]) || Role <- RoleList, Role#dungeon_role.pid =/= From],
    Pid.

%% 登录
login(DunPid, RoleId, AttrList) ->
    gen_server:cast(DunPid, {'login', RoleId, AttrList}).

%% 重新登录
% relogin(DunPid, RoleId) ->
%     gen_server:cast(DunPid, {'relogin',RoleId}).

%% 延迟登出
delay_logout(DunPid, RoleId, Hp, HpLim, OffMap) ->
    gen_server:cast(DunPid, {'delay_logout', RoleId, Hp, HpLim, OffMap}).

%% 登出
logout(DunPid, RoleId, Hp, HpLim, OffMap) ->
    gen_server:cast(DunPid, {'logout', RoleId, Hp, HpLim, OffMap}).

%% 被动强制退出
passive_force_quit(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'passive_force_quit', RoleId}).

%% 被动流程退出
passive_flow_quit(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'passive_flow_quit', RoleId}).

%% 主动退出副本
active_quit(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'active_quit', RoleId}).

%% 关闭副本
close_dungeon(DunPid) ->
    gen_server:cast(DunPid, {'close_dungeon'}).

handle_enter_fail(DunPid, RoleId, Why) ->
    gen_server:cast(DunPid, {handle_enter_fail, RoleId, Why}).

ask_for_enter(DunPid, DungeonRole) ->
    gen_server:cast(DunPid, {ask_for_enter, DungeonRole}).

%% 判断是否能再次进入副本
again_enter_dungeon(DunPid, RoleId, Node, DunId, DunType) ->
    gen_server:cast(DunPid, {'again_enter_dungeon', RoleId, Node, DunId, DunType}).

set_reward(DunPid, RoleId, SourceReward, IsPushSettlement) ->
    gen_server:cast(DunPid, {'set_reward', RoleId, SourceReward, IsPushSettlement}).

%% ====================
%% 玩家请求数据
%% ====================

%% 副本信息
send_dungeon_info(DunPid, Sid) ->
    gen_server:cast(DunPid, {'send_dungeon_info', Sid}).

%% 伙伴列表
send_partner_list(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'send_partner_list', RoleId}).

%% 伙伴出战
choose_partner_group(DunPid, RoleId, PartnerGroup, X, Y) ->
    gen_server:cast(DunPid, {'choose_partner_group', RoleId, PartnerGroup, X, Y}).

%% 推送结算
push_settlement(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'push_settlement', RoleId}).

%% 剧情播放通知
send_story_list(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'send_story_list', RoleId}).

%% 更新剧情
update_story(DunPid, StoryId, SubStoryId, IsEnd) ->
    gen_server:cast(DunPid, {'update_story', StoryId, SubStoryId, IsEnd}).

%% 跳过副本
skip_dungeon(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'skip_dungeon', RoleId}).

%% 退出副本时间
send_flow_quit_time(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'send_flow_quit_time', RoleId}).

%% 发送坐标事件的触发情况
send_xy_list(DunPid, RoleId, SceneId) ->
    gen_server:cast(DunPid, {'send_xy_list', RoleId, SceneId}).

%% 请求时间评分状态
get_time_score_step(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'get_time_score_step', RoleId}).

%% 鼓舞
encourage(DunPid, RoleId, CostType) ->
    gen_server:cast(DunPid, {'encourage', RoleId, CostType}).

%% 设置鼓舞次数
setup_encourage_count(DunPid, RoleId, CostType, Count) ->
    gen_server:cast(DunPid, {'setup_encourage_count', RoleId, CostType, Count}).

%% 获取鼓舞次数
get_encourage_count(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'get_encourage_count', RoleId}).

%% 获取下波怪物到来时间
get_next_wave_time(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'get_next_wave_time', RoleId}).

%% 获取当前副本的所有杀怪数
get_die_mon_count(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'get_die_mon_count', RoleId}).

%% 伤害排行榜
get_hurt_rank(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'get_hurt_rank', RoleId}).

%% 特定怪物血量
get_hp_list(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'get_hp_list', RoleId}).

%% 发送面板信息
send_panel_info(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'send_panel_info', RoleId}).

%% 触发经验增加
trigger_add_exp(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'trigger_add_exp', RoleId}).

%% 发送波数面板信息
send_wave_panel_info(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'send_wave_panel_info', RoleId}).

%% 发送跳关信息
send_jump_wave_info(DunPid, RoleId, WaveNum) ->
    gen_server:cast(DunPid, {'send_jump_wave_info', RoleId, WaveNum}).

%% 副本复位
reset_xy(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'reset_xy', RoleId}).

%% 复活
async_revive(DunPid, RoleId, Node) ->
    gen_server:cast(DunPid, {'async_revive', RoleId, Node}).

%% 副本特殊信息
send_dungeon_special_info(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'send_dungeon_special_info', RoleId}).

%% ====================
%% 进程处理
%% ====================

%% 切换到副本场景
change_to_dungeon_scene(DunPid, RoleId, X, Y) ->
    gen_server:cast(DunPid, {'change_to_dungeon_scene', RoleId, X, Y}).

%% 完成切入到副本场景
fin_change_scene(DunPid, RoleId, X, Y) ->
    gen_server:cast(DunPid, {'fin_change_scene', RoleId, X, Y}).

%% 派发副本事件
dispatch_dungeon_event(DunPid, EventTypeId, EventData) ->
    gen_server:cast(DunPid, {'dispatch_dungeon_event', EventTypeId, EventData}).

%% 击杀怪物
kill_mon(DunPid, AutoId, Mid, DieSign, CreateKey, OwnId, DieDatas) ->
    gen_server:cast(DunPid, {'kill_mon', AutoId, Mid, DieSign, CreateKey, OwnId, DieDatas}).

%% 停止怪物
stop_mon(DunPid, AutoId, Mid, DieSign, CreateKey, OwnId, Hp, HpLim) ->
    gen_server:cast(DunPid, {'stop_mon', AutoId, Mid, DieSign, CreateKey, OwnId, Hp, HpLim}).

%% 对象死亡
object_die(DunPid, AutoId, OwnId) ->
    gen_server:cast(DunPid, {'object_die', AutoId, OwnId}).

%% 对象停止
object_stop(DunPid, AutoId, OwnId, Hp, HpLim) ->
    gen_server:cast(DunPid, {'object_stop', AutoId, OwnId, Hp, HpLim}).

%% 玩家死亡
player_die(DunPid, RoleId, HpLim, AttrList) ->
    gen_server:cast(DunPid, {'player_die', RoleId, HpLim, AttrList}).

%% 玩家复活
player_revive(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'player_revive', RoleId}).

%% 更新玩家数据
update_dungeon_role(DunPid, RoleId, AttrList) ->
    gen_server:cast(DunPid, {'update_dungeon_role', RoleId, AttrList}).

% 更新玩家的关系数据
% @param OriginRelaList []
update_rela_list(DunPid, RoleId, OriginRelaList) ->
    gen_server:cast(DunPid, {'update_rela_list', RoleId, OriginRelaList}).

% 添加好友请求
ask_add_friend(DunPid, RoleId, IdList) ->
    gen_server:cast(DunPid, {'ask_add_friend', RoleId, IdList}).

% 公会邀请
send_guild_invite(DunPid, RoleId, InviteeId) ->
    gen_server:cast(DunPid, {'send_guild_invite', RoleId, InviteeId}).

%% 掉落处理
drop_choose(DunPid, RoleId, Object) ->
    gen_server:cast(DunPid, {'drop_choose', RoleId, Object}).

goods_drop(DunPid, RoleId, ObjectList) ->
    gen_server:cast(DunPid, {'goods_drop', RoleId, ObjectList}).

%% 更新怪物血量
update_mon_hp(DunPid, Id, Mid, Hp, HpLim) ->
    gen_server:cast(DunPid, {update_mon_hp, Id, Mid, Hp, HpLim}).

update_role_lv(DunPid, RoleId, Lv) ->
    gen_server:cast(DunPid, {update_role_lv, RoleId, Lv}).

handle_special(DunPid, Sid, Cmd, Args) ->
    gen_server:cast(DunPid, {handle_special, Sid, Cmd, Args}).

apply(DunPid, Mod, Fun, Args) ->
    gen_server:cast(DunPid, {apply, Mod, Fun, Args}).

get_skip_mon_num(DunPid, Sid) ->
    gen_server:cast(DunPid, {get_skip_mon_num, Sid}).

%% 增加经验
add_exp(DunPid, RoleId, AddExp) ->
    gen_server:cast(DunPid, {'add_exp', RoleId, AddExp}).

add_exp(DunPid, RoleId, AddExp, BaseExp, GoodsExpRatio) ->
    gen_server:cast(DunPid, {'add_exp', RoleId, AddExp, BaseExp, GoodsExpRatio}).

%% 使用物品buff
add_goods_buff(DunPid, RoleId, GoodsExpRatio) ->
    gen_server:cast(DunPid, {'add_goods_buff', RoleId, GoodsExpRatio}).

%% 玩家升级
role_lv_up(CopyId, RoleId, Lv) ->
    gen_server:cast(CopyId, {'role_lv_up', RoleId, Lv}).

answer_dun_question(DunPid, RoleId, Answer) ->
    gen_server:cast(DunPid, {'answer_dun_question', RoleId, Answer}).

set_dungeon_start_wave_num(DunPid, StartWaveNum) ->
    gen_server:cast(DunPid, {'set_dungeon_start_wave_num', StartWaveNum}).

get_exp_got(DunPid, Args) ->
    gen_server:cast(DunPid, {'get_exp_got', Args}).


%% 快速出怪
quick_create_mon(DunPid, RoleId, ServerId) ->
    gen_server:cast(DunPid, {'quick_create_mon', RoleId, ServerId}).

%% 快速出怪信息
send_quick_create_mon_info(DunPid, RoleId, ServerId) ->
    gen_server:cast(DunPid, {'send_quick_create_mon_info', RoleId, ServerId}).

%% 拾取怪
pick_mon(DunPid, Mid, Coord, Skill, CollectorId) ->
    gen_server:cast(DunPid, {'pick_mon', Mid, Coord, Skill, CollectorId}).

%% 技能信息
send_skill_info(DunPid, RoleId) ->
    gen_server:cast(DunPid, {'send_skill_info', RoleId}).

%% 释放buff技能
casting_skill(DunPid, RoleId, SkillId) ->
    gen_server:cast(DunPid, {'casting_skill', RoleId, SkillId}).

%% ====================
%% 秘籍
%% ====================

%% 秘籍结束副本
gm_close_dungeon(DunPid, RoleId, ResultType) ->
    gen_server:cast(DunPid, {'gm_close_dungeon', RoleId, ResultType}).

%% 秘籍结束副本关卡
gm_close_dungeon_level(DunPid, RoleId, ResultType) ->
    gen_server:cast(DunPid, {'gm_close_dungeon_level', RoleId, ResultType}).

%% 秘籍:事件触发
gm_common_event(DunPid, BelongTypeList, CommonEventId) ->
    gen_server:cast(DunPid, {'gm_common_event', BelongTypeList, CommonEventId}).

%% 获得副本数据
get_state(DunPid) ->
    gen_server:cast(DunPid, {'get_state'}).

%% 使魔副本 使魔被击杀
demon_die(DunPid, DemonId) ->
    gen_server:cast(DunPid, {'demon_die', DemonId}).

%% 修改副本进程设置记录
set_dun_role_setting(DunPid, RoleId, SettingMap) ->
    gen_server:cast(DunPid, {'set_dun_role_setting', RoleId, SettingMap}).

%% 数据初始化
init([DunId, TeamId, RoleList, Args]) ->
    {ok, State} = lib_dungeon_mod:init(DunId, TeamId, RoleList, Args),
    {ok, State}.

handle_call(Request, From, State) ->
    mod_dungeon_call:handle_call(Request, From, State).

handle_cast({'test', A}, State) ->
    timer:sleep(2000),
    case A == 2 of
        true -> ?PRINT("tests :~p ~n", [A]), {stop, normal, State};
        false -> ?PRINT("tests :~p ~n", [A]), {noreply, State}
    end;
handle_cast({'event_print'}, State) ->
    #dungeon_state{common_event_map = CommonEventMap, group_map = GroupMap} = State,
    ?ERR("CommonEventMap:~w, GroupMap:~w", [CommonEventMap, GroupMap]),
    {noreply, State};
handle_cast({'get_state'}, State) ->
    ?INFO("State:~w", [State]),
    {noreply, State};
handle_cast(Msg, State) ->
    mod_dungeon_cast:handle_cast(Msg, State).

handle_info(Info, State) ->
    mod_dungeon_info:handle_info(Info, State).

terminate(Reason, State) ->
    ?PRINT("_Reason :~p ~n", [Reason]),
    #dungeon_state{team_id = TeamId, role_list = RoleList,
        scene_list = SceneList, open_scene_list = OpenSceneList,
        dun_type = DunType,
        scene_pool_id = ScenePoolId, force_quit_ref = ForceQuitRef,
        flow_quit_ref = FlowQuitRef, level_close_ref = LevelCloseRef,
        level_change_ref = LevelChangeRef, wave_close_ref = WaveCloseRef
        } = State,
    ClearSceneList = util:ulist(OpenSceneList++SceneList),
    lib_dungeon_api:invoke(DunType, dunex_dungeon_destory, [State, Reason], skip),
    case Reason == normal of
        true -> skip;
        false ->
            % 通知队伍
            mod_team:cast_to_team(TeamId, {'dungeon_direct_end', self()}),
            % 玩家退出队伍
            F = fun(#dungeon_role{id = RoleId, is_end_out = IsEndOut, node = Node}) ->
                case IsEndOut == ?DUN_IS_END_OUT_NO of
                    true ->
                        {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(?ERRCODE(err610_dungeon_error)),
                        {ok, BinData} = pt_110:write(11017, [?FLOAT_TEXT_ONLY, ErrorCodeInt, ErrorCodeArgs]),
                        lib_server_send:send_to_uid(RoleId, BinData),
                        Score = lib_dungeon:calc_score(State, RoleId),
                        lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, close_dungeon,
                            [?DUN_RESULT_TYPE_NO, ClearSceneList, self(), Score]),
                        lib_dungeon_util:quit_team(DunType, Node, TeamId, RoleId);
                    false ->
                        skip
                end
            end,
            lists:foreach(F, RoleList)
    end,
    %%通知组队大厅退出副本
    if
        TeamId > 0 ->
            mod_team_enlist:cast_to_team_enlist({'change_dungeon_type', TeamId, out});
        true ->
            ok
    end,
    % 清理定时器
    lib_dungeon_mod:clear_ref(State),
    % 清理强制登出定时器
    util:cancel_timer(ForceQuitRef),
    % 清理流程登出定时器
    util:cancel_timer(FlowQuitRef),
    % 清理关卡结束定时器
    util:cancel_timer(LevelCloseRef),
    % 清理关卡切换定时器
    util:cancel_timer(LevelChangeRef),
    % 清理波数结束定时器
    util:cancel_timer(WaveCloseRef),
    % 清理副本记录
    [mod_dungeon_agent:remove_dungeon_record(Role#dungeon_role.id, self())||Role<-RoleList],
    % 清理场景数据(延迟15秒清理场景数据,防止怪物还在异步生成,导致没有清理)
    Pid = self(),
    spawn(fun() ->
        timer:sleep(15*1000),
        [lib_scene:clear_scene_room(SceneId, ScenePoolId, Pid)||SceneId<-ClearSceneList]
    end),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
