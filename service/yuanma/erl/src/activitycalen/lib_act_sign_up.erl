%%%-----------------------------------
%%% @Module      : lib_act_sign_up
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 十二月 2019 16:44
%%% @Description : 活动报名
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_act_sign_up).
-author("carlos").
-include("activitycalen.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("goods.hrl").

%% API
-export([]).


login(PS) ->
    #player_status{id = RoleId, pid = Pid} = PS,
    Sql = io_lib:format(?sql_select_sign_up, [RoleId]),
    List = db:get_all(Sql),
    F = fun([ModId, SubModId, ActId, StartTime, _EndTime, Status, IsFinish], AccList) ->
        Ref = send_ref(ModId, SubModId, ActId, Status, StartTime),
        Msg = #sign_up_msg{key = {ModId, SubModId, ActId}, mod_id = ModId, start_time = StartTime, ref = Ref, is_finish = IsFinish,
            sub_mod_id = SubModId, act_id = ActId, status = Status, arg = []},
        [Msg | AccList]
        end,
    SignUpList = lists:foldl(F, [], List),
    ActSignUp = #act_sign_up{sign_up_list = SignUpList},
    PS1 = PS#player_status{act_sign_up = ActSignUp},
    case is_pid(Pid) of
        true ->
            check_guild_war(PS1);
        _ ->
            PS1
    end.

send_ref(_ModId, _SubModId, _ActId, ?not_sign_up, _StartTime) ->
    ok;
send_ref(ModId, SubModId, ActId, _Status, StartTime) ->
    Now = utime:unixtime(),
    if
        StartTime > Now ->
            erlang:send_after((StartTime - Now) * 1000, self(), {'mod', lib_act_sign_up, enter_act, [ModId, SubModId, ActId]});
        true ->
            []
    end.

daily_refresh() ->
    % 清空报名表
    Sql = io_lib:format(?truncate_sign_up, []),
    db:execute(Sql),
    % 在线玩家数据清空
    [lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, ?MODULE, daily_refresh, []) || Id <- lib_online:get_online_ids()],
    ok.

daily_refresh(PS) ->
    #player_status{act_sign_up = ActSignUp} = PS,
    NewActSignUp = ActSignUp#act_sign_up{sign_up_list = []},
    NewPS = PS#player_status{act_sign_up = NewActSignUp},
    get_sign_up_msg(NewPS), % 客户端更新
    NewPS.

get_sign_up_msg(Player) ->
    #player_status{act_sign_up = ActMsg, id = RoleId, guild = Guild} = Player,
    #act_sign_up{sign_up_list = List, guild_war = Status} = ActMsg,
    TodayAct = lib_activitycalen_api:get_today_sign_act(),
    IsHave = is_have_guild(Guild),
    F = fun({Mod, SubModId, ActId}, AccList) ->
        if
            Mod == ?MOD_TERRITORY_WAR andalso Status == 0 ->
                AccList;
            Mod == ?MOD_GUILD_ACT andalso IsHave == false ->
                AccList;
            true ->
                case lists:keyfind({Mod, SubModId, ActId}, #sign_up_msg.key, List) of
                    #sign_up_msg{status = Status1, is_finish = IsFinish} ->
                        [{Mod, SubModId, ActId, Status1, IsFinish} | AccList];
                    _ ->
                        [{Mod, SubModId, ActId, ?not_sign_up, ?not_finish} | AccList]
                end
        end
        end,
    PackList = lists:foldl(F, [], TodayAct),
    {ok, Bin} = pt_157:write(15718, [PackList]),
    lib_server_send:send_to_uid(RoleId, Bin).

%% -----------------------------------------------------------------
%% @desc     功能描述    报名
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
sign_up(Player, Mod, SubMod, ActId) ->
    #player_status{act_sign_up = SignUpAct, id = RoleId, figure = Figure, guild = Guild} = Player,
    IsHaveGuild = is_have_guild(Guild),
    #act_sign_up{guild_war = GuildWarStatus} = SignUpAct,
    IsOpen = lib_activitycalen_api:is_enabled(Mod, SubMod, ActId),
    if
        IsOpen == true ->
            {ok, Bin} = pt_157:write(15700, [?ERRCODE(err157_act_open)]),
            lib_server_send:send_to_uid(RoleId, Bin),
            Player;
        GuildWarStatus == 0 andalso Mod == ?MOD_TERRITORY_WAR ->  %% 没有资格报名公会战
            {ok, Bin} = pt_157:write(15700, [?ERRCODE(err157_error_act)]),
            lib_server_send:send_to_uid(RoleId, Bin),
            Player;
        Mod == ?MOD_GUILD_ACT  andalso IsHaveGuild == false ->
            {ok, Bin} = pt_157:write(15700, [?ERRCODE(err400_not_join_guild)]),
            lib_server_send:send_to_uid(RoleId, Bin),
            Player;
        true ->
            case lib_activitycalen_api:is_today_open(Mod, SubMod, ActId) of
                true ->
                    case data_activitycalen:get_ac(Mod, SubMod, ActId) of
                        #base_ac{ac_type = 2, sign_up_reward = Reward, time_region = TimeList, start_lv = StartLv}
                            when Reward =/= []  andalso Figure#figure.lv >= StartLv ->  %%限时活动  err157_error_act
                            NewPS = do_sign_up(Player, Mod, SubMod, ActId, TimeList),
                            NewPS;
                        _ ->
                            {ok, Bin} = pt_157:write(15700, [?ERRCODE(err157_error_act)]),
                            lib_server_send:send_to_uid(RoleId, Bin),
                            Player
                    end;
                _ ->
                    {ok, Bin} = pt_157:write(15700, [?ERRCODE(err157_act_not_open)]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    Player
            end
    end.


do_sign_up(Player, Mod, SubMod, ActId, TimeList) ->
    #player_status{act_sign_up = SignUpAct, id = RoleId} = Player,
    #act_sign_up{sign_up_list = List} = SignUpAct,
    case lists:keyfind({Mod, SubMod, ActId}, #sign_up_msg.key, List) of
        #sign_up_msg{status = ?have_sign_up} ->  %% 已经报名了
            {ok, Bin} = pt_157:write(15700, [?ERRCODE(err157_have_sign_up)]),
            lib_server_send:send_to_uid(RoleId, Bin),
            Player;
        _ -> %% 开始报名了~~~
            {{StartH, StartM}, {EndH, EndM}} = hd(TimeList),
            StartTime = utime:unixdate() + StartH * 60 * 60 + StartM * 60 + 5,  %% （5秒延迟）
            EndTime = utime:unixdate() + EndH * 60 * 60 + EndM * 60,  %%
            Ref = send_ref(Mod, SubMod, ActId, ?have_sign_up, StartTime),
            Msg = #sign_up_msg{status = ?have_sign_up, key = {Mod, SubMod, ActId}, end_time = EndTime,
                mod_id = Mod, sub_mod_id = SubMod, act_id = ActId, ref = Ref, start_time = StartTime},
            %%发送协议
            {ok, Bin} = pt_157:write(15719, [?SUCCESS, Mod, SubMod, ActId, ?have_sign_up, ?not_finish]),
            lib_server_send:send_to_uid(RoleId, Bin),
            %% log
            lib_log_api:log_sign_up_msg(RoleId, Mod, SubMod, ActId, 1),
            %%保存数据库
            save_to_one_msg_to_db(RoleId, Msg),
            NewList = lists:keystore({Mod, SubMod, ActId}, #sign_up_msg.key, List, Msg),
            NewSignUpAct = SignUpAct#act_sign_up{sign_up_list = NewList},
            Player#player_status{act_sign_up = NewSignUpAct}
    end.

%% 领取活动报名奖励
%% @return #player_status{}
receive_sign_up_reward(PS, Mod, SubMod, ActId) ->
    #player_status{id = RoleId, sid = SId, act_sign_up = SignUpAct} = PS,
    case lib_activitycalen_api:is_today_open(Mod, SubMod, ActId) of
        false ->
            lib_server_send:send_to_sid(SId, pt_157, 15720, [?ERRCODE(err157_act_not_open), Mod, SubMod, ActId]),
            PS;
        true ->
            % 报名数据和活动完成数据
            #act_sign_up{sign_up_list = List} = SignUpAct,
            #sign_up_msg{status = Status, is_finish = IsFinish} = Msg = lists:keyfind({Mod, SubMod, ActId}, #sign_up_msg.key, List),
            % 活动时间数据
            BaseAc = data_activitycalen:get_ac(Mod, SubMod, ActId),
            IsActEnd = not lib_activitycalen_util:do_check_ac_sub(BaseAc, [time_region]),
            case {Status, IsFinish, IsActEnd} of
                {?have_sign_up, ?have_finish, true} -> % 已报名;有参与活动;活动当天已结束
                    % 发奖励
                    send_reward(RoleId, Mod, SubMod, ActId),
                    lib_server_send:send_to_sid(SId, pt_157, 15720, [?SUCCESS, Mod, SubMod, ActId]),
                    lib_server_send:send_to_sid(SId, pt_157, 15719, [?SUCCESS, Mod, SubMod, ActId, ?receive_sign_up, IsFinish]),
                    % 数据更新
                    NewMsg = Msg#sign_up_msg{status = ?receive_sign_up},
                    save_to_one_msg_to_db(RoleId, NewMsg),
                    NewList = lists:keystore({Mod, SubMod, ActId}, #sign_up_msg.key, List, NewMsg),
                    NewSignUpAct = SignUpAct#act_sign_up{sign_up_list = NewList},
                    PS#player_status{act_sign_up = NewSignUpAct};
                _ ->
                    lib_server_send:send_to_sid(SId, pt_157, 15720, [?FAIL, Mod, SubMod, ActId]),
                    PS
            end
    end.

%% 报名信息入库
save_to_one_msg_to_db(RoleId, Msg) ->
    #sign_up_msg{mod_id = ModId, status = Status, sub_mod_id = SubId, end_time = EndTime,
        start_time = StartTime, is_finish = IsFinish, act_id = ActId} = Msg,
    Sql = io_lib:format(?sql_save_sign_up, [RoleId, ModId, SubId, ActId, StartTime, EndTime, Status, IsFinish]),
    db:execute(Sql).

enter_act(PS, ModId, SubId, _ActId) ->
    #player_status{scene = Scene, online = Online} = PS,
    IsOutSide = lib_scene:is_outside_scene(Scene),
    if
        IsOutSide == true andalso  Online == ?ONLINE_ON->
            Res =
                case ModId of
                    ?MOD_NINE ->
                        pp_nine:handle(13502, PS, []);
                    ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
                        pp_holy_spirit_battlefield:handle(21802, PS, []);
                    ?MOD_MIDDAY_PARTY ->
                        pp_midday_party:handle(28501, PS, []);
                    ?MOD_GUILD_ACT when SubId == 2 -> %% 公会篝火
                        pp_guild_act:handle(40212, PS, []);
                    ?MOD_GUILD_ACT when SubId == 3 -> %% 守卫公会
                        pp_guild_act:handle(40230, PS, []);
                    ?MOD_TERRITORY -> %
                        pp_territory_treasure:handle(65202, PS, []);
                    _ ->
                        ?FAIL
                end,
            case Res of
                #player_status{} = NewPS ->
                    NewPS;
                {ok, NewPS} when is_record(NewPS, player_status) ->
                    NewPS;
                _ ->
                    PS
            end;
        true ->
            PS
    end.





%% 发送活动奖励
send_reward(RoleId, ModId, SubId, ActId) ->
    case data_activitycalen:get_ac(ModId, SubId, ActId) of
        #base_ac{sign_up_reward = Reward, sign_up_mail = MailList, ac_name = Name} when Reward =/= [] ->
            case lists:keyfind(sign_up, 1, MailList) of
                {_, TitleId, ContentId} ->
                    Title = utext:get(TitleId),
                    Content = utext:get(ContentId, [Name]),
                    Produce = #produce{type = activitycalen, title = Title, content = Content, reward = Reward},
                    lib_goods_api:send_reward_by_id(Produce, RoleId);
                    % lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
                _ ->
                    ok
            end;
        _ ->
            skip
    end.



send_end_ref(_ModId, _SubModId, _ActId, ?have_finish, _EndTime) ->
    [].
%%send_end_ref(ModId, SubModId, ActId, _, EndTime) ->
%%	Now = utime:unixtime(),
%%	if
%%		EndTime > Now ->
%%			?MYLOG("sign", "~p~n", [{ModId, SubModId, ActId}]),
%%			erlang:send_after((EndTime - Now) * 1000, self(), {'mod', lib_act_sign_up, act_end, [ModId, SubModId, ActId]});
%%		true ->
%%			[]
%%	end.




%% -----------------------------------------------------------------
%% @desc     功能描述     完成某项活动
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
%%

role_success_end_activity(Player, Module, ModuleSub, Count) when Count >= 1 ->
    Ids = data_activitycalen:get_ac_sub(Module, ModuleSub),
    role_success_end_activity_help(Player, Module, ModuleSub, Ids);


%%role_success_end_activity(Player, Module, ModuleSub, Count) when  Count >= 1 ->
%%
%%	case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
%%		{ok, ActId} ->
%%			#player_status{act_sign_up = ActSignUp, id = RoleId} = Player,
%%			#act_sign_up{sign_up_list = List} = ActSignUp,
%%			case lists:keyfind({Module, ModuleSub, ActId}, #sign_up_msg.key, List) of
%%				#sign_up_msg{end_time = EndRef, status = ?have_sign_up, is_finish = ?not_finish} = Msg ->  %% 只有已经报名了，且未完成的才会触发奖励
%%					util:cancel_timer(EndRef),
%%					send_reward(RoleId, Module, ModuleSub, ActId),
%%					%% log
%%					lib_log_api:log_sign_up_msg(RoleId, Module, ModuleSub, ActId, 2),
%%					NewMsg = Msg#sign_up_msg{end_time = 0, end_ref = [], is_finish = ?have_finish},
%%					save_to_one_msg_to_db(RoleId, NewMsg),
%%					NewList = lists:keystore({Module, ModuleSub, ActId}, #sign_up_msg.key, List, NewMsg),
%%					NewActSignUp = ActSignUp#act_sign_up{sign_up_list = NewList},
%%					Player#player_status{act_sign_up = NewActSignUp};
%%				_ ->
%%					Player
%%			end;
%%		_ ->
%%			Player
%%	end;
role_success_end_activity(Player, _Module, _ModuleSub, _Count) ->
    Player.






role_success_end_activity_help(Player, _Module, _ModuleSub, []) ->
    Player;
role_success_end_activity_help(Player, Module, ModuleSub, [ActId | Ids]) ->
    #player_status{act_sign_up = ActSignUp, id = RoleId} = Player,
    #act_sign_up{sign_up_list = List} = ActSignUp,
    NewPs =
        case lists:keyfind({Module, ModuleSub, ActId}, #sign_up_msg.key, List) of
            #sign_up_msg{status = ?have_sign_up, is_finish = ?not_finish} = Msg ->  %% 只有已经报名了，且未完成的才会触发奖励
                lib_log_api:log_sign_up_msg(RoleId, Module, ModuleSub, ActId, 2),
                NewMsg = Msg#sign_up_msg{is_finish = ?have_finish},
                save_to_one_msg_to_db(RoleId, NewMsg),
                NewList = lists:keystore({Module, ModuleSub, ActId}, #sign_up_msg.key, List, NewMsg),
                NewActSignUp = ActSignUp#act_sign_up{sign_up_list = NewList},
                Player#player_status{act_sign_up = NewActSignUp};
            _ ->
                Player
        end,
    role_success_end_activity_help(NewPs, Module, ModuleSub, Ids).


day_trigger() ->
    Sql = io_lib:format("truncate   sign_up_msg", []),
    db:execute(Sql),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_act_sign_up, day_trigger, []) || RoleId <- IdList].

day_trigger(PS) ->
    #player_status{act_sign_up = ActSignUp} = PS,
    cancel_ref(ActSignUp),
    NewPs = PS#player_status{act_sign_up = #act_sign_up{}},
    update_status(NewPs),
    NewPs.




act_end(ModId, SubMod) ->
    Sql = io_lib:format(<<"select  DISTINCT  role_id from  sign_up_msg">>, []),
    IdList = [PlayerId || [PlayerId] <- db:get_all(Sql)],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_act_sign_up, act_end, [ModId, SubMod]) || RoleId <- IdList].


act_end(PS, ModId, SubMod) ->
    update_status(PS),
    case lib_activitycalen_api:get_today_act(ModId, SubMod) of
        false ->
            PS;
        ActId ->
            act_end(PS, ModId, SubMod, ActId)
    end.

act_end(PS, ModId, SubModId, ActId) ->
    #player_status{act_sign_up = ActSignUp, id = RoleId} = PS,
    #act_sign_up{sign_up_list = List} = ActSignUp,
    case lists:keyfind({ModId, SubModId, ActId}, #sign_up_msg.key, List) of
        #sign_up_msg{is_finish = ?not_finish} ->  % 没参与活动
            case data_activitycalen:get_ac(ModId, SubModId, ActId) of
                #base_ac{sign_up_mail = MailList, ac_name = Name} ->
                    case lists:keyfind(fail, 1, MailList) of
                        {fail, TitleId, ContentId} ->
                            Title = utext:get(TitleId),
                            Content = utext:get(ContentId, [Name]),
                            lib_mail_api:send_sys_mail([RoleId], Title, Content, []);
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end,
            Sql = io_lib:format(?del_save_sign_up, [RoleId, ModId, SubModId, ActId]),
            db:execute(Sql),
            NewList = lists:keydelete({ModId, SubModId, ActId}, #sign_up_msg.key, List),
            NewActSignUp = ActSignUp#act_sign_up{sign_up_list = NewList},
            PS#player_status{act_sign_up = NewActSignUp};
        #sign_up_msg{is_finish = ?have_finish} ->  % 有参与活动,报名状态不变,由客户端结合活动状态和报名状态来显示奖励状态
            % send_reward(RoleId, ModId, SubModId, ActId);
            PS;
        _ -> % 没报名
            PS
    end.

check_guild_war(PS) ->
    #player_status{id = RoleId, sid = Sid, server_id = _ServerId, guild = #status_guild{id = GuildId}, act_sign_up = ActSignUp} = PS,
    case GuildId > 0 of
        true ->
            Node = mod_disperse:get_clusters_node(),
            Msg = [RoleId, Sid, GuildId, config:get_server_id(), Node],
            mod_territory_war:guild_qualification(Msg),
            PS;
        _ ->
            NewActSignUp = ActSignUp#act_sign_up{guild_war = 0},
            PS#player_status{act_sign_up = NewActSignUp}
    end.



update_guild_war(PS, Status) ->
    #player_status{act_sign_up = ActSignUp} = PS,
    PS#player_status{act_sign_up = ActSignUp#act_sign_up{guild_war = Status}}.



is_have_guild(#status_guild{id = Id})  when Id > 0->
    true;
is_have_guild(_)->
    false.




cancel_ref(ActSignUp) ->
    #act_sign_up{sign_up_list = List} = ActSignUp,
    cancel_ref2(List).



cancel_ref2([]) ->
    skip;
cancel_ref2([#sign_up_msg{ref = Ref, end_ref = EndRef} | List]) ->
%%	?MYLOG("sign", " ~p , ~p~n", [Ref, EndRef]),
    util:cancel_timer(Ref),
    util:cancel_timer(EndRef),
    cancel_ref2(List).



update_status() ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_act_sign_up, update_status, []) || RoleId <- IdList].


update_status(PS) ->
    pp_activitycalen:handle(15718, PS, []).
