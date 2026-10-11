% %%%===================================================================
% %%% @author zmh
% %%% @doc 擂台赛  元宝擂台(钻石争霸战)
% %%% @end
% %%% @update by zzy 2017-11-08
% %%%===================================================================
-module(lib_role_drum).
-include("server.hrl").
-include("predefine.hrl").
-include("drumwar.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("skill.hrl").
-include("career.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("attr.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("def_cache.hrl").
-include("def_module.hrl").
-compile(export_all).

%%复活
revive(PS) ->
    #player_status{x=X,y=Y, role_drum = #role_drum{pos = Pos}} = PS,
    case is_in_drumwar(PS) of
        true->
            % 策划要求改成按复活点复活
            case Pos of 
                1 -> right_pos();
                _ -> left_pos()
            end;
            % {XA,YA} = urand:list_rand(?DRUM_REVIVE_LOCATION),
            % {XA,YA};
        false-> {X,Y}
    end.

%% 检查复活
check_revive(PS, Type) ->
    case Type == ?REVIVE_DRUMWAR of
        true ->
            case is_in_drumwar(PS) of
                true -> true;
                false -> {false, 10}
            end;
        false ->
            true
    end.

%%断线重连
re_login(PS) ->
    #player_status{id = RoleId, scene = Scene} = PS,
    AllScene = [?READY_SCENE, ?WAR_SCENE],
    case lists:member(Scene,AllScene) of
        true->
            role_change(PS,0),
            lib_scene:player_change_default_scene(RoleId, [{pk,{?PK_PEACE,true}}, {action_free, ?ERRCODE(err137_in_drum_war)}]),
            {ok, PS};
        false-> {next, PS}
    end.

%%上线
login(RoleID)->
    case db:get_row(io_lib:format(?SQL_DRUM_GET,[RoleID])) of
        [DrumID,One,Zid,Act]->
            RoleDrum = #role_drum{drumid=DrumID,one=One,zone=Zid,action=Act};
        _ ->
            RoleDrum = #role_drum{}
    end,
    case db:get_all(io_lib:format(?SQL_DRUM_GUESS_GET,[RoleID]))of
        [] -> Choice = [];
        L ->
            Choice = [
                #role_choice{
                    key = {Zid, Act, SuprId}, zone = Zid, action = Act, suprid = SuprId, type = Type, reward_st = RewardSt, winner = Winner,
                    arid = ARid, asid = ASid, asnum = ASnum, aname = AName, alv = ALv, asex = ASex, acareer = ACareer, apic = APic, apicver = APicVer, apower = APower,
                    brid = BRid, bsid = BSid, bsnum = BSnum, bname = BName, blv = BLv, bsex = BSex, bcareer = BCareer, bpic = BPic, bpicver = BPicVer, bpower = BPower
                }
                ||[Zid, Act, SuprId, Type, RewardSt, Winner, ARid, ASid, ASnum, AName, ALv, ASex, ACareer, APic, APicVer, APower, BRid, BSid, BSnum, BName, BLv, BSex, BCareer, BPic, BPicVer, BPower] <- L
            ]
    end,
    RoleDrum#role_drum{choice = Choice}.

%%计算当前期ID
get_id()->
    {{Y,M,D}, _} = calendar:local_time(),
    Y*10000+M*100+D.

%% 活动开启，做一些清理
drum_start() ->
    case is_drumwar_open() of
        true ->
            lib_activitycalen_api:success_start_activity(?MOD_DRUMWAR),
            lib_chat:send_TV({all_lv, ?DRUMLV, 99999}, 137, 9, []),
            clear_guess(),
            spawn(fun() ->
                DrumId = get_id(),
                case db:get_all(io_lib:format(<<"select id, lv from `player_low` where lv >= ~p ">>, [?DRUMLV])) of
                    [] -> ok;
                    PlayerList ->
                        db:execute("truncate table role_drum"),
                        SqlArgs = [[RoleId, DrumId, mod_drumwar_mgr:trans_zone(RoleLv)] || [RoleId, RoleLv] <- PlayerList],
                        Sql = usql:replace(role_drum, [rid, drumid, zone], SqlArgs),
                        db:execute(Sql)
                end,
                OnlineRoles = ets:tab2list(?ETS_ONLINE),
                lists:foldl(fun(E, Acc) ->
                    lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, reset_drum_zone, [DrumId]),
                    Acc rem 20 == 0 andalso timer:sleep(1000),
                    Acc + 1
                end, 1, OnlineRoles)
            end),
            %% 重置竞猜记录
            spawn(fun() ->
                DbList = db:get_all(io_lib:format(<<"select rid, suprid, type, winner from `role_drum_guess` where reward_st = ~p ">>, [0])),
                db:execute(<<"truncate table `role_drum_guess`">>),
                case DbList of
                    [] ->
                        ok;
                    PlayerList ->
                        F = fun([RoleId, Suprid, Type, Winner], Acc) ->
                            case Suprid == Winner of
                                true ->
                                    [_, Reward] = mod_drumwar_mgr:get_award(Type),
                                    Title = utext:get(1370005), Content = utext:get(1370007),
                                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                                    Acc rem 20 == 0 andalso timer:sleep(1000),
                                    Acc + 1;
                                _ -> Acc
                            end
                        end,
                        lists:foldl(F, 1, PlayerList)
                end
            end),
            ok;
        _ -> ok
    end.

drum_enter(SingRoleList) ->
    case is_drumwar_open() of
        true ->
            mod_activity_onhook:act_enter(?MOD_DRUMWAR, 0, SingRoleList);
        _ -> ok
    end.

reset_drum_zone(Status, DrumID) ->
    #player_status{id = RoleId, sid=Sid, figure = #figure{lv = Lv}}=Status,
    case Lv >= ?DRUMLV of
        true ->
            ZoneId = mod_drumwar_mgr:trans_zone(Lv),
            RoleDrum = #role_drum{drumid = DrumID, zone = ZoneId},
            %?PRINT("reset_drum_zone RoleDrum ~p~n", [RoleDrum]),
            lib_server_send:send_to_sid(Sid, pt_137, 13716, [ZoneId]),
            Sql = usql:replace(role_drum, [rid, drumid, zone], [[RoleId, DrumID, ZoneId]]),
            db:execute(Sql),
            {ok, Status#player_status{role_drum = RoleDrum}};
        _ ->
            {ok, Status}
    end.

rectify_zone(Status) ->
    #player_status{id = RoleId, sid=Sid, figure = #figure{lv = Lv}, role_drum = RoleDrum}=Status,
    case RoleDrum#role_drum.zone > 0 of
        true -> Status;
        _ ->
            DrumId = get_id(),
            ZoneId = mod_drumwar_mgr:trans_zone(Lv),
            Sql = usql:replace(role_drum, [rid, drumid, zone], [[RoleId, DrumId, ZoneId]]),
            db:execute(Sql),
            lib_server_send:send_to_sid(Sid, pt_137, 13716, [ZoneId]),
            Status#player_status{role_drum = RoleDrum#role_drum{drumid = DrumId, zone = ZoneId}}
    end.

%% -------------------------------- 每日12点刷新 ---------------------------------
daily_clear(_) ->
    spawn(fun()-> daily_clear_help() end).

daily_clear_help() ->
    %% 清楚缓存竞猜数据
    clear_guess().
    % Day = utime:day_of_week(),
    % [OpenT] = data_drumwar:get_open(),
    % case lists:keyfind(Day,1,OpenT) of
    %     false-> ok;
    %     _ ->
    %         OnlineList = ets:tab2list(?ETS_ONLINE),
    %         [
    %             lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, ?MODULE, zero_time, [])
    %             ||#ets_online{id = PlayerId}<-OnlineList
    %         ]
    % end.

% zero_time(Status)->
%     db_replace_role_drum(Status#player_status.id,#role_drum{}),
%     Status#player_status{role_drum=#role_drum{}}.


%%获取活动状态
get_clock(Sid)->
    case is_drumwar_open() of
        true ->
            mod_drumwar_mgr:cast_center([{mod,?MODULE,get_clock_mgr,[node(),Sid]}]);
        _ ->
            ok
    end.

get_clock_mgr([Node,Sid],State)->
    #drumwar_mgr{state=S,etime=EndTime}=State,
    Now = utime:unixtime(),
    ReTime = max(EndTime,Now+1),
    ?PRINT("~p:~p~n",[S,ReTime]),
    {ok, Bin} = pt_137:write(13700,[S,ReTime]),
    send_to_role(Node,Sid,Bin),
    State.

%%获取报名情况
get_sign(Uid,_RoleDrum,Sid)->
    %#role_drum{zone=Z,action=Act,deal=Deal,one=One,choice=OChoice}=RoleDrum,
    % Choice = case utime:unixtime()>Deal of
    %     true->%%逾期
    %         [];
    %     _->
    %         OChoice
    % end,
    mod_drumwar_mgr:cast_center([{mod,?MODULE,get_sign_mgr,[node(),Uid,Sid]}]).

get_sign_mgr([Node,RoleId,Sid],State)->
    #drumwar_mgr{signs=Signs,history=_History}=State,
    Res= case lists:keyfind(RoleId,#drum_role.rid,Signs) of
        #drum_role{}->
            1;
        _->
            0
    end,
    % Drums = [D||{D,_}<-History],
    %  ?PRINT("~p:~p:~p:~p:~p~n",[Res,One,Z,Act,Choice]),
    {ok,Bin} = pt_137:write(13701,[Res]),
    send_to_role(Node,Sid,Bin),
    State.

get_match_sub_state(Status) ->
    #player_status{sid=Sid,figure = #figure{lv=Lv}}=Status,
    CKList = [
        {check_lv,Lv},
        {check_open_day}
    ],
    case checklist(CKList) of
        true->
            mod_drumwar_mgr:cast_center([{mod,?MODULE,get_match_sub_state_mgr,[node(),Sid]}]),
            ok;
        {false,_Err}->
            ok
    end.

get_match_sub_state_mgr([Node, Sid],State)->
    #drumwar_mgr{action = Action}=State,
    case Action >= 9 of
        true ->
            case get(match_sub_state) of
                {SubState, EndTime} ->
                    {ok,Bin} = pt_137:write(13703,[Action,SubState,EndTime]),
                    send_to_role(Node,Sid,Bin);
                _ ->
                    ok
            end;
        _ ->
            ok
    end,
    State.

%% ================================================== 报名 ====================================================
sign_up(Status)->
    #player_status{id=_Uid,figure = #figure{lv=Lv}}=Status,
    CKList = [
        {check_lv,Lv},
        {check_cost,Status},
        {check_open_day}
    ],
    case checklist(CKList) of
        true->
            case lib_goods_api:cost_object_list(Status, [{0,?DRUMITEM,1}], drumwar_sign, "drumwar_sign") of
                {true, Status1}->
                    NStatus = rectify_zone(Status1),
                    DrumRole = make_drum_role(NStatus),
                    mod_drumwar_mgr:cast_center([{mod,?MODULE,sign_up_mgr,[DrumRole]}]),
                    {ok,NStatus};
                _->
                    {false,?ERRCODE(err137_tool_not_enough)}
            end;
        {false,Err}->
            {false,Err}
    end.

%%模块回调  把逻辑放到这里
sign_up_mgr([DrumRole],State) when State#drumwar_mgr.state /= 1 ->
    #drum_role{rid = RoleId, sid=Sid, node=Node}=DrumRole,
    mod_clusters_center:apply_cast(Node, sign_up_back, [RoleId, Sid, ?ERRCODE(err137_not_sign_state)]),
    State;
sign_up_mgr([DrumRole],State)->
    #drum_role{rid=Uid,sid=Sid,node=Node, server_id = SerId, server_num = SerNum, server_name = SerName}=DrumRole,
    #drumwar_mgr{signs=Signs, server_map = ServerMap}=State,
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{}->
            mod_clusters_center:apply_cast(Node, ?MODULE, sign_up_back, [Uid, Sid, ?ERRCODE(err137_has_sign)]),
            State;
        _->
            mod_clusters_center:apply_cast(Node, ?MODULE, sign_up_back, [Uid, Sid, ?SUCCESS]),
            %%写进db
            db_replace_drum_sign(DrumRole),
            log_drum_sign(DrumRole),
            NSigns = lists:keystore(Uid,#drum_role.rid,Signs,DrumRole),
            % ?PRINT("sign_up_mgr~p~n",[DrumRole]),
            %% 更新服务器集合
            NewServerMap = maps:put(SerId, {SerId, SerNum, SerName}, ServerMap),
            State#drumwar_mgr{signs=NSigns, server_map = NewServerMap}
    end.

sign_up_back(RoleId, Sid, Res) ->
    {ok, Bin} = pt_137:write(13702,[Res]),
    lib_server_send:send_to_sid(Sid,Bin),
    case Res of
        1 -> ok;
        _ ->
            Produce = #produce{reward = [{0,?DRUMITEM,1}], type= drumwar_sign, remark = lists:concat(["drumwar_sign_back_", Res])},
            lib_goods_api:send_reward_by_id(Produce, RoleId)
    end.

%%=============================================== 进入准备区 =========================================
enter_ready(Status)->
    #player_status{scene=Scene,figure = #figure{lv=Lv}}=Status,
    CKList = [
        {check_lv,Lv},
        {check_scene,Scene},
        {check_state,Status},
        {check_open_day}
    ],
    case checklist(CKList) of
        true->
            DrumRole = make_drum_role(Status),
            mod_drumwar_mgr:cast_center([{mod,?MODULE,enter_ready_mgr,[DrumRole]}]),
            ok;
        {false,Err}->
            {false,Err}
    end.

enter_ready_mgr([DrumRole],State)->
    #drumwar_mgr{action=Act,state=S,substate=SubS,signs=Signs,etime=EndTime,ready_out=ReadyOut}=State,
    #drum_role{rid=RoleID,sid=Sid,node=Node,figure=Figure,role_attr=RoleAttr,power=Power}=DrumRole,
    ODrumRole = lists:keyfind(RoleID, #drum_role.rid, Signs),
    CKList = [
        {check_ready_out,RoleID,ReadyOut},
        {check_sign,ODrumRole},
        {check_enter_ready,S,EndTime}
    ],
    case checklist(CKList) of
        true->
            NDrumRole = ODrumRole#drum_role{sid=Sid, node=Node, figure=Figure,role_attr=RoleAttr, power=Power, online=1},
            NSigns = lists:keyreplace(RoleID,#drum_role.rid,Signs,NDrumRole),
            MatchSubState = get(match_sub_state),
            mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID,S,SubS,MatchSubState,Act,NDrumRole,EndTime]),
            State#drumwar_mgr{signs=NSigns};
        {false,Err}->
            {ok,Bin}=pt_137:write(13704,[Err]),
            send_to_role(Node,Sid,Bin),
            State
    end.

enter_ready_local(RoleID,S,SubS,MatchSubState,Act,DrumRole,EndTime)->
    lib_player:apply_cast(RoleID,?APPLY_CAST_STATUS,?MODULE,enter_ready_role,[S,SubS,MatchSubState,Act,DrumRole,EndTime]).
enter_ready_role(Status,S,SubS,MatchSubState,Act,DrumRole,EndTime)->
    #player_status{id=RoleId, sid=Sid, role_drum = RoleDrum}=Status,
    {Scene, PoolId, CopyId} = get_ready_scene(Status#player_status.server_id),
    {RandX,RandY,Circle} = urand:list_rand(?READY_LOCATION),
    {X,Y} = umath:rand_point_in_circle(RandX,RandY,Circle,1),
    case is_in_drumready(Status) of
        true->
            Status;
        _->
            RoleAct = DrumRole#drum_role.action,
            {ok,Bin0} = pt_137:write(13704,[?SUCCESS]),
            RealAct = ?IF(RoleAct > Act, Act, DrumRole#drum_role.action),
            RealLive = ?IF(
                RoleAct < Act orelse (RoleAct == Act andalso DrumRole#drum_role.calc_type == 1 andalso (S == ?SEAWAR orelse (S == ?RANKWAR andalso SubS==0))),  %% 已经淘汰，或者中途离开，在匹配前没重新进
                0, DrumRole#drum_role.live),
            {ok,Bin1} = mod_drumwar_mgr:pack_13705(DrumRole#drum_role{action = RealAct, live = RealLive}),
             ?PRINT("~p~n",[{Act, S, SubS}]),
             ?PRINT("~p~n",[{DrumRole#drum_role.calc_type, DrumRole#drum_role.action, RealLive}]),
            if
                S == ?READY -> {ok,Bin2} = pt_137:write(13703,[0, ?TYPE_SEA_START,EndTime]);
                true ->
                    case MatchSubState of
                        {SubState, SubEndTime} ->
                            {ok,Bin2} = pt_137:write(13703,[Act, SubState,SubEndTime]);
                        _ -> Bin2 = <<>>
                    end
            end,
            lib_server_send:send_to_sid(Sid,<<Bin0/binary, Bin1/binary, Bin2/binary>>),
            mod_drumwar_mgr:cast_center([{mod,?MODULE,change_scene,[RoleId, Scene, PoolId]}]),
            NewRoleDrum = RoleDrum#role_drum{live = DrumRole#drum_role.live},
            %% 加活跃
            Status1 = lib_activitycalen_api:role_success_end_activity(Status, ?MOD_DRUMWAR, 0),
            %% 我要变强
            StongPs = lib_to_be_strong:update_data_diamond(Status1),
            KeyValueList = [{action_lock, ?ERRCODE(err137_in_drum_war)}, {group, 0}, {change_scene_hp_lim, 0}],
            lib_scene:change_scene(StongPs#player_status{role_drum = NewRoleDrum}, Scene, PoolId, CopyId, X, Y, true, KeyValueList)
    end.

%%========================================== 主动请求命数信息
apply_live_info(Status)->
    #player_status{sid=_Sid,id=RoleID}=Status,
    Uid = RoleID,
    mod_drumwar_mgr:cast_center([{mod,?MODULE,apply_live_mgr,[node(),Uid,RoleID]}]).

%%主动请求命数
apply_live_mgr([Node,Uid,RoleID],State)->
    #drumwar_mgr{signs=Signs}=State,
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{live=ALive,ai=0,ruid=RUid}->
            BLive = mod_drumwar_mgr:get_alive(RUid,Signs);
        #drum_role{live=ALive,ai=1}->
            BLive = 1;
        _->
            ALive = 1, BLive=1
    end,
    {ok,Bin}=pt_137:write(13710,[ALive,BLive]),
    lib_role_drum:send_to_role(Node,RoleID,Bin),
    State.

%%=============================================== 进入擂台区
enter_war_local(RoleID,Uid,Group,Pos,Act,PkEndTime)->
    RolePid = misc:get_player_process(RoleID),
    case misc:is_process_alive(RolePid) of
        true->
            lib_player:apply_cast(RoleID,?APPLY_CAST_STATUS,?MODULE,enter_war_role,[Group,Uid,Pos,Act,PkEndTime]);
        _-> %%临阵不在 输 通知对方回准备区
            mod_drumwar_mgr:cast_center([{mod,?MODULE,role_away_mgr,[Uid]}])
    end.
enter_war_role(Status,Group,Uid,Pos,Act,PkEndTime)->
    #player_status{id=RoleId, sid=Sid, scene = OldScene, role_drum = RoleDrum}=Status,
    {Scene, PoolId, CopyId} = get_war(Group),
    {X,Y} = case Pos of
        1-> RoleGroup = 1,right_pos();
        _-> RoleGroup = 2,left_pos()
    end,
    NewRoleDrum = RoleDrum#role_drum{pos = Pos},
    NewStatus = Status#player_status{role_drum = NewRoleDrum},
    case is_in_drumready(Status) orelse is_in_drumwar(Status) of
        true->
            lib_log_api:log_drumwar_enter_scene(RoleId, Act, Group, OldScene, Scene),
            mod_drumwar_mgr:cast_center([{mod,?MODULE,change_scene,[RoleId, Scene, PoolId]}]),
            mod_drumwar_mgr:cast_center([{system_active_mon,RoleId}]),
            GapFight = data_drumwar:get_kv(16),
            {ok,Bin} = pt_137:write(13703,[Act,?TYPE_FIGHT,utime:unixtime()+GapFight]),
            lib_server_send:send_to_sid(Sid,Bin),
            SkillList = [{SkillId, 1} || SkillId <- get_drum_skill()],
            {ok, NStatus} = lib_skill:add_tmp_skill_list(NewStatus, SkillList),
            lib_scene:change_scene(NStatus, Scene, PoolId, CopyId, X, Y, false, [{change_scene_hp_lim,1},{group,RoleGroup},{pk,{?PK_ALL,false}},{pk_endtime, PkEndTime}]);
        _->
            case is_in_drumwar(Status) of
                true->
                    NewStatus;
                _-> %%此时人不在准备区和擂台区  则为弃权
                    mod_drumwar_mgr:cast_center([{mod,?MODULE,role_away_mgr,[Uid]}]),
                    NewStatus
            end
    end.

%%对手弃权
role_away_mgr([Uid],State)->
    #drumwar_mgr{action=Act,signs=Signs,choice=Choice,choose=Choose}=State,
    {NSigns,NChoose}=case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{node=Node,rid=RoleID,server_num=WSerNum,sid=Sid,action=Act,zid=Zid,win=W,online=1,figure=Figure,ruid=LUid}=D->%%得胜 回准备
            #figure{name=WName} = Figure,
            NdrumR=D#drum_role{action=Act+1,win=W+1,calc_type=1},
            {ok,Bin}=pt_137:write(13708,[1,4,Act]),
            {ok, Bin1} = mod_drumwar_mgr:pack_13705(NdrumR#drum_role{action=Act}),
            ResultTime = ?IF(is_integer(get(result_time)),get(result_time),utime:unixtime()),
            {ok,Bin2} = pt_137:write(13703,[Act,?TYPE_SUCCESS, ResultTime]),
            lib_role_drum:send_to_role(Node, Sid, <<Bin/binary, Bin1/binary, Bin2/binary>>),
            lib_role_drum:update_role_drum(Node,RoleID,Zid,Act,NdrumR#drum_role.live),
            case data_drumwar:get_war(Zid, Act) of
               [{WAward,_}] -> lib_role_drum:war_award(Node,RoleID,WAward);
                _-> ok
            end,
            spawn(fun()->
                timer:sleep(5000),
                mod_clusters_center:apply_cast(Node,mod_drumwar_mgr,enter_ready_local,[RoleID])
            end),
            mod_drumwar_mgr:log_drum_war(5,Uid,LUid,Signs),
            Signs1 = lists:keyreplace(Uid,#drum_role.rid,Signs,NdrumR),
            Act >= 12 andalso begin
                {TypeId, TvArgs} = lib_role_drum:get_zone(Zid),
                mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137, TypeId, TvArgs++[WSerNum, WName]], 600),
                {ok,Bin0} = pt_137:write(13712,[Zid,WName]),
                spawn(fun()->mod_drumwar_mgr:show_champion(Bin0,Zid,Signs1) end)
            end,
            %%第九场之后的要结算竞猜
            Choose1 = case Act>=9 of
                true ->
                    LDrumRole = lists:keyfind(LUid, #drum_role.rid, Signs),
                    spawn(fun()->mod_drumwar_mgr:account_guess_result(Zid,Act,NdrumR,LDrumRole,Choice) end),
                    mod_drumwar_mgr:broadcast_guess_winner(Zid, Act, Uid),
                    mod_drumwar_mgr:update_guess_winner(Choose, Zid, Act, Uid);
                _ ->
                   Choose
            end,
            Choose2 = case  Act >= 12  of
                true->%%决胜局 追加冠军
                    Choose0 = mod_drumwar_mgr:add_results([Uid],Signs1,Choose1),
                    mod_drumwar_mgr:brocast_guess_msg(0,Choose0),
                    Choose0;
                _->
                    Choose1
            end,
            {Signs1,Choose2};
        _->
            {Signs,Choose}
    end,
    State#drumwar_mgr{signs=NSigns,choose=NChoose}.

%%==================================================== 购买命数
buy_live(Num,Status)->
    #player_status{
        scene=Scene,gold=CurGold,
        id=Uid,figure = #figure{lv=Lv},
        role_drum = RoleDrum
    }=Status,
    ItemNum =  case lib_goods_api:get_goods_num(Status,[?DRUMITEM]) of
        [{_,N}|_] -> N;
        _ -> 0
    end,
    NewNum = case Num=<ItemNum of
        true->
            0;
        _->
            Num-ItemNum
    end,
    CKList = [
        {check_lv,Lv},
        {check_ready,Scene},
        {check_buy,Num},
        {check_live_num, Num, RoleDrum},
        {check_gold,NewNum*?BUYPRICE,CurGold}
    ], %%先做部分检测  避免多余的跨服请求
    case checklist(CKList) of
        true->
            Cost = case NewNum=<0 of
                true->
                    [{?TYPE_GOODS, ?DRUMITEM, Num}];
                _ when ItemNum=<0->
                    [{?TYPE_GOLD, 0, Num*?BUYPRICE}];
                _->
                    [{?TYPE_GOLD,0,(Num-ItemNum)*?BUYPRICE},{?TYPE_GOODS,?DRUMITEM,ItemNum}]
            end,
            % catch case mod_drumwar_mgr:call_center([{mod,?MODULE,get_drum_role,[Uid]}]) of
            %     #drum_role{live=L} when L =< 0 -> {false,?ERRCODE(err137_be_kill_not_buy)};
            %     #drum_role{live=L} when L+Num=<?BUYMAX->
                    case lib_goods_api:cost_object_list_with_check(Status, Cost, drumwar_live, "drumwar_live") of
                        {true, NStatus}->
                            OLive = RoleDrum#role_drum.live,
                            ?PRINT("buy_live ok~n",[]),
                            log_drum_cost(Uid,1,Cost),
                            mod_drumwar_mgr:cast_center([{mod,?MODULE,add_live_mgr,[Uid,Num,Cost]}]),
                            {ok,OLive + Num,NStatus#player_status{role_drum = RoleDrum#role_drum{live = OLive + Num}}};
                        _->
                            {false,?ERRCODE(err137_tool_not_enough)}
                    end;
                % _->
                %     {false,?ERRCODE(err137_be_kill_not_buy)}
            % end;
        {false,Err}->
            {false,Err}
    end.

get_drum_role([Uid],State)->
    #drumwar_mgr{signs=Signs}=State,
    lists:keyfind(Uid,#drum_role.rid,Signs).

add_live_mgr([Uid,Num,Cost],State)->
    #drumwar_mgr{action = Act, signs=Signs}=State,
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{node = Node, action = Action, live=L}=DrumRole ->
            case Action < Act orelse L == 0 of
                true ->
                    mod_clusters_center:apply_cast(Node, ?MODULE, add_live_mgr_back, [?ERRCODE(err137_be_kill_not_buy), Uid, L, Cost]),
                    State;
                _ ->
                    NDrumRole = DrumRole#drum_role{live=L+Num},
                    ?PRINT("add_live:~p~n",[L+Num]),
                    NSigns = lists:keyreplace(Uid,#drum_role.rid,Signs,NDrumRole),
                    mod_clusters_center:apply_cast(Node, ?MODULE, add_live_mgr_back, [1, Uid, L+Num, []]),
                    State#drumwar_mgr{signs=NSigns}
            end;
        _->
            State
    end.

add_live_mgr_back(1, RoleId, Live, _) ->
    {ok,Bin}=pt_137:write(13706,[1, Live]),
    lib_server_send:send_to_uid(RoleId, Bin);
add_live_mgr_back(Res, RoleId, Live, Cost) ->
    {ok,Bin}=pt_137:write(13706,[Res, Live]),
    lib_server_send:send_to_uid(RoleId, Bin),
    Produce = #produce{reward = Cost, type= drumwar_live, remark = lists:concat(["drumwar_live_back_", Res])},
    lib_goods_api:send_reward_by_id(Produce, RoleId).

%%================================================= 离开 区分离开准备还是擂台
leave_drum(Type,Status)->
    #player_status{
        id=Uid
    }=Status,
    case is_in_drumready(Status) of
        true when Type =<0 ->%%离开准备区
            %[X, Y] = lib_scene:get_born_xy(?MAIN_CITY_SCENE),
            KeyValueList = [{group,0},{change_scene_hp_lim, 1},{pk,{?PK_PEACE,true}}, {action_free, ?ERRCODE(err137_in_drum_war)}],
            NStatus=lib_scene:change_scene(Status, 0, 0, 0, 0, 0, true, KeyValueList),
            %NStatus = lib_scene:change_default_scene(Status, KeyValueList),
            mod_drumwar_mgr:cast_center([{mod,?MODULE,leave_war_mgr,[ready,Uid,0]}]),
            {ok,NStatus};
        _->
            case is_in_drumwar(Status) of
                true when Type>=1 ->%%离开擂台区 进入准备区 主动离开 表示认输
                    {RScene, PoolId, CopyId} = get_ready_scene(Status#player_status.server_id),
                    {RandX,RandY,Circle} = urand:list_rand(?READY_LOCATION),
                    {Rx,Ry}=umath:rand_point_in_circle(RandX,RandY,Circle,1),
                    NStatus=lib_scene:change_scene(Status, RScene, PoolId, CopyId, Rx, Ry, false, [{group,0},{pk,{?PK_PEACE,true}},{change_scene_hp_lim, 1}]),
                    mod_drumwar_mgr:cast_center([{mod,?MODULE,leave_war_mgr,[war,Uid,RScene]}]),
                    {ok,NStatus};
                _->
                    {false,?ERRCODE(err137_not_need_to_leave)}
            end
    end.

%%离开擂台
leave_war_mgr([Type,Uid,Scene],State)->
    #drumwar_mgr{action=CurAct,choice=Choice,choose=Choose,signs=Signs}=State,
    [NSigns,NChoose] = case Type of
        ready->%%离开准备区
            case lists:keyfind(Uid,#drum_role.rid,Signs) of
                DrumR when is_record(DrumR,drum_role)->
                    NDrumR = DrumR#drum_role{online=0,scene=Scene},
                    [lists:keyreplace(Uid,#drum_role.rid,Signs,NDrumR),Choose];
                _->
                    [Signs,Choose]
            end;
        _->%%离开擂台
            case lists:keyfind(Uid,#drum_role.rid,Signs) of
                #drum_role{action=Act}=DrumR when CurAct<Act -> %%已结算 直接退出
                    NDrumR = DrumR#drum_role{scene=Scene},
                    Signs1 = lists:keyreplace(Uid,#drum_role.rid,Signs,NDrumR),
                    [Signs1,Choose];
                #drum_role{live=Live,lose=L}=DrumR when Live=<0 andalso L>0 ->%%命数为0,战败退出 已结算
                    NDrumR = DrumR#drum_role{scene=Scene},
                    Signs1 = lists:keyreplace(Uid,#drum_role.rid,Signs,NDrumR),
                    [Signs1,Choose];
                #drum_role{calc_type=CalcType}=DrumR when CalcType==1 -> %%已结算 直接退出
                    NDrumR = DrumR#drum_role{scene=Scene, calc_type = 1},
                    Signs1 = lists:keyreplace(Uid,#drum_role.rid,Signs,NDrumR),
                    [Signs1,Choose];
                #drum_role{node=Node,zid=Lzone,rid=LRid,figure=#figure{name=_LName},action=Act,sid=Sid,lose=L,ruid=RUid}=DrumR->%%未结算玩家,算输
                    NDrumR = DrumR#drum_role{lose=L+1,scene=Scene},
                    {ok,Bin} = pt_137:write(13708,[1,2,Act]),
                    send_to_role(Node,Sid,Bin),
                    Signs0 = lists:keyreplace(Uid,#drum_role.rid,Signs,NDrumR),
                    [{_,LAward}] = data_drumwar:get_war(Lzone,Act),
                    lib_role_drum:war_award(Node,LRid,LAward),
                    case lists:keyfind(RUid,#drum_role.rid,Signs0) of
                        #drum_role{action=RAct} when CurAct<RAct -> %%已结算 不管
                            [Signs0,Choose];
                        #drum_role{node=N,zid=Z,rid=Rid,action=A,sid=S,win=W}=DrumR0->
                            NDrumR0 = DrumR0#drum_role{win=W+1,action=A+1},
                            {ok,Bin0} = pt_137:write(13708,[1,1,A]),
                            send_to_role(N,S,Bin0),
                            spawn(fun()->
                                timer:sleep(1000),
                                mod_clusters_center:apply_cast(N,mod_drumwar_mgr,enter_ready_local,[Rid])
                            end),
                            [{WAward,_}] = data_drumwar:get_war(Z,A),
                            lib_role_drum:war_award(N,Rid,WAward),
                            %%第九场之后的要结算竞猜
                            Choose1 = case CurAct>=9 of
                                true ->
                                    spawn(fun()->mod_drumwar_mgr:account_guess_result(Z,CurAct,NDrumR0,NDrumR,Choice) end),
                                    mod_drumwar_mgr:broadcast_guess_winner(Lzone, Act, RUid),
                                    mod_drumwar_mgr:update_guess_winner(Choose, Lzone, Act, RUid);
                                _ ->
                                    Choose
                            end,
                            Signs1 = lists:keyreplace(RUid,#drum_role.rid,Signs0,NDrumR0),
                            Choose2 = case  CurAct >= 12  of
                                true->%%决胜局 追加冠军
                                    Choose0 = mod_drumwar_mgr:add_results([RUid],Signs1,Choose1),
                                    mod_drumwar_mgr:brocast_guess_msg(0,Choose0),
                                    Choose0;
                                _->
                                    Choose1
                            end,
                            [Signs1,Choose2];
                        _->
                            [Signs0,Choose]
                    end;
                _->
                    [Signs,Choose]
            end
    end,
    State#drumwar_mgr{signs=NSigns,choose=NChoose}.

%%====================================================== 获取战报
war_report(DrumID,Status)->
    #player_status{sid=Sid}=Status,
    mod_drumwar_mgr:cast_center([{mod,?MODULE,war_report_mgr,[node(),DrumID,Sid]}]).

war_report_mgr([Node,DrumID,Sid],State)->
    #drumwar_mgr{history=History}=State,
    NRanks = case lists:keyfind(DrumID,1,History) of
        {_,Ranks}->
            war_report_mgr_help(Ranks,[]);
        _->
            []
    end,
    {ok,Bin}=pt_137:write(13711,[DrumID,NRanks]),
    lib_role_drum:send_to_role(Node,Sid,Bin),
    State.

war_report_mgr_help([],Result) -> lists:reverse(Result);
war_report_mgr_help([Role|T],Result) ->
    #rank_role{
        zone=Zone,rank=Rank,rid=RoleId,
        server_id=SId,platform=PForm,servernum=SNum,
        name=Name,gname=Gname,vip=Vip,power=Power,career=Career
    } = Role,
    Info = {Zone,Rank,RoleId,SId,PForm,SNum,Name,Gname,Vip,Power,Career},
    war_report_mgr_help(T,[Info|Result]).

%%激活假人(暂时没用)
active_mon(Status)->
    #player_status{id=Uid}=Status,
    case is_in_drumwar(Status) of
        true->
            mod_drumwar_mgr:cast_center([{active_mon,Uid}]);
        _->
            ignore
    end.

%%获取竞猜面板数据
fetch_guess(Status)->
    #player_status{id=RoleID,figure=#figure{lv=Lv},role_drum=RoleDrum}=Status,
    CKList = [
        {check_lv,Lv},
        {check_open_day}
    ],
    [ReTime,Guess] = case checklist(CKList) of
        true->
            NowTime = utime:unixtime(),
            case mod_cache:get(?CACHE_DRUMWAR_GUESS) of
                {CTime, _Guess} when CTime == 0 orelse (CTime /= 0 andalso NowTime < CTime) ->
                    [CTime, _Guess];
                _ ->
                    case catch mod_drumwar_mgr:call_center([{mod,?MODULE,get_drumwar_state,[choose]}]) of
                        [WState, CTime, G]->
                            case WState == ?IDLE orelse WState == ?CLOSE of
                                true ->
                                    mod_cache:put(?CACHE_DRUMWAR_GUESS, {0, G}),
                                    [0, G];
                                _ ->
                                    [CTime,G]
                            end;
                        _ -> [0,[]]
                    end
            end;
        {false,_Err}->
            [0,[]]
    end,
    {ok,Bin}=mod_drumwar_mgr:pack_13719(RoleDrum, ReTime, Guess),
    %?PRINT("fetch_guess Bin ~p~n", [Bin]),
    lib_server_send:send_to_uid(RoleID,Bin).

clear_guess() ->
    mod_cache:put(?CACHE_DRUMWAR_GUESS, undefined).

get_drumwar_state([Type],State)->
    #drumwar_mgr{state=WState,choose=Guess,choice=Choice,action=Act,cstate=CState,ctime=CTime,etime=Etime}=State,
    case Type of
        choose->
            [WState, CTime, Guess];
        choice->
            [Act,CState,Guess,Choice,Etime];
        _->
            State
    end.

%%============================================== 竞猜
choose_drum(Type,Uid,ActId,Status)->
    #player_status{
        id=RoleID,figure = #figure{lv=Lv}, gold=Gold, bgold=Bgold,
        role_drum = #role_drum{zone = Zid, choice = Choice}
    }=Status,
    CKList = [
        {check_choose_lv,Lv},
        {check_type,Type},
        {check_is_guess, Zid, ActId, Choice}
    ],
    case checklist(CKList) of
        true->
            [Cost,_] = mod_drumwar_mgr:get_award(Type),
            case combine_cost(Cost,Gold,Bgold) of
                {false,Err}-> {false,Err};
                NewCost ->
                    case lib_goods_api:cost_object_list(Status, NewCost, drumwar, "drumwar") of
                        {true,NStatus}->
                            Node = node(),
                            mod_drumwar_mgr:cast_center([{mod,?MODULE,choose_drum_mgr,[Zid,RoleID,Node,Uid,Type,NewCost]}]),
                            {ok,NStatus};
                        {false,_Err,_}->
                            {false,?GOLD_NOT_ENOUGH}
                    end
            end;
        {false,Err}->
            {false,Err}
    end.

choose_drum_mgr([Zid, RoleID, Node, Uid, Type, NewCost], State)->
    #drumwar_mgr{state = CState, action = Act, choose = Guess, choice = Choice} = State,
    case CState=<0 orelse Act=<8 of
        true ->
            mod_clusters_center:apply_cast(Node, ?MODULE, choose_drum_back, [?ERRCODE(err137_not_guess_state), Zid, RoleID, Uid, Type, Act, [], NewCost]),
            State;
        _ ->
            case check_choose(Node, RoleID, Zid, Act, Guess, Uid, Choice) of
                {false, Res} ->
                    mod_clusters_center:apply_cast(Node, ?MODULE, choose_drum_back, [Res, Zid, RoleID, Uid, Type, Act, [], NewCost]),
                    State;
                {true, ARole, BRole} ->
                    NChoice = choose_drum_mgr_helper(Choice, Zid, RoleID, Node, Uid, Type),
                    #drum_role{
                        rid = ARid, server_id = AServerId, server_num = AServerNum, power = APower,
                        figure = #figure{name = AName, lv = ALv, sex = ASex, career = ACareer, picture = APic, picture_ver = APicVer}
                    } = ARole,
                    #drum_role{
                        rid = BRid, server_id = BServerId, server_num = BServerNum, power = BPower,
                        figure = #figure{name = BName, lv = BLv, sex = BSex, career = BCareer, picture = BPic, picture_ver = BPicVer}
                    } = BRole,
                    ChoiceArgs = [
                        ARid, AServerId, AServerNum, AName, ALv, ASex, ACareer, APic, APicVer, APower,
                        BRid, BServerId, BServerNum, BName, BLv, BSex, BCareer, BPic, BPicVer, BPower
                    ],
                    mod_clusters_center:apply_cast(Node, ?MODULE, choose_drum_back, [1, Zid, RoleID, Uid, Type, Act, ChoiceArgs, []]),
                    State#drumwar_mgr{choice = NChoice}
            end
    end.

choose_drum_mgr_helper(Choice, _Zid, RoleID, Node, Uid, Type)->
    NChoice = case lists:keyfind(Uid,1,Choice) of
        {_,UChoice}->
            case lists:keyfind(Node, 1, UChoice) of
                {Node, RoleList} ->
                    NUChoice = lists:keystore(Node, 1, UChoice, {Node, [{RoleID, Type}|RoleList]}),
                    lists:keyreplace(Uid,1,Choice,{Uid,NUChoice});
                _ ->
                    NUChoice = [{Node, [{RoleID, Type}]}|UChoice],
                    lists:keyreplace(Uid,1,Choice,{Uid,NUChoice})
            end;
        _->
            NUChoice = [{Node, [{RoleID,Type}]}],
            lists:keystore(Uid,1,Choice,{Uid,NUChoice})
    end,
    NChoice.

choose_drum_back(1, Zid, RoleID, Uid, Type, Act, ChoiceArgs, _NewCost) ->
    [
        ARid, AServerId, AServerNum, AName, ALv, ASex, ACareer, APic, APicVer, APower,
        BRid, BServerId, BServerNum, BName, BLv, BSex, BCareer, BPic, BPicVer, BPower
    ] = ChoiceArgs,
    %?PRINT("choose_drum_back ChoiceArgs ~p~n", [ChoiceArgs]),
    ANameFix = util:fix_sql_str(AName), BNameFix = util:fix_sql_str(BName),
    Sql = usql:replace(
        role_drum_guess,
        [zone, rid, action, suprid, type, reward_st, winner, arid, asid, asnum, aname, alv, asex, acareer, apic, apicver, apower, brid, bsid, bsnum, bname, blv, bsex, bcareer, bpic, bpicver, bpower],
        [[Zid, RoleID, Act, Uid, Type, 0, 0, ARid, AServerId, AServerNum, ANameFix, ALv, ASex, ACareer, APic, APicVer, APower, BRid, BServerId, BServerNum, BNameFix, BLv, BSex, BCareer, BPic, BPicVer, BPower]]
    ),
    db:execute(Sql),
    lib_player:apply_cast(RoleID, ?APPLY_CAST_SAVE, ?MODULE, choose_drum_back_ps, [Zid, RoleID, Uid, Type, Act, ChoiceArgs]);
choose_drum_back(Res, _Zid, RoleID, Uid, _Type, Act, _ChoiceArgs, NewCost) ->
    %?PRINT("choose_drum_back Res ~p~n", [Res]),
    {ok, Bin} = pt_137:write(13720,[Res, Uid, Act]),
    lib_server_send:send_to_uid(RoleID, Bin),
    Produce = #produce{reward = NewCost, type= drumwar, remark = lists:concat(["choose_drum_back_", Res])},
    lib_goods_api:send_reward_by_id(Produce, RoleID),
    ok.

choose_drum_back_ps(Status, Zid, _RoleID, Uid, Type, Act, ChoiceArgs) ->
    #player_status{sid = Sid, role_drum = RoleDrum} = Status,
    #role_drum{choice = Choice} = RoleDrum,
    [
        ARid, AServerId, AServerNum, AName, ALv, ASex, ACareer, APic, APicVer, APower,
        BRid, BServerId, BServerNum, BName, BLv, BSex, BCareer, BPic, BPicVer, BPower
    ] = ChoiceArgs,
    RoleChoice = #role_choice{
        key = {Zid, Act, Uid}, zone = Zid, action = Act, suprid = Uid, type = Type,
        arid = ARid, asid = AServerId, asnum = AServerNum, aname = AName, alv = ALv, asex = ASex, acareer = ACareer, apic = APic, apicver = APicVer, apower = APower,
        brid = BRid, bsid = BServerId, bsnum = BServerNum, bname = BName, blv = BLv, bsex = BSex, bcareer = BCareer, bpic = BPic, bpicver = BPicVer, bpower = BPower
    },
    NChoice = lists:keystore({Zid, Act, Uid}, #role_choice.key, Choice, RoleChoice),
    NRoleDrum = RoleDrum#role_drum{choice = NChoice},
    %?PRINT("choose_drum_back_ps NChoice ~p~n", [NChoice]),
    {ok, Bin} = pt_137:write(13720,[1, Uid, Act]),
    lib_server_send:send_to_sid(Sid, Bin),
    {ok, Status#player_status{role_drum = NRoleDrum}}.

%% 竞猜结果处理
account_choice_result(ZoneId, Act, SuprId, Winner, RoleIdList) ->
    Sql = usql:update(role_drum_guess, [{winner, Winner}], [{zone, ZoneId}, {action, Act}, {suprid, SuprId}]),
    db:execute(Sql),
    spawn(
        fun() ->
            lists:foldl(fun(RoleId, Acc) ->
                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, account_choice_result_ps, [ZoneId, Act, SuprId, Winner]),
                Acc rem 30 == 0 andalso timer:sleep(500),
                Acc + 1
            end, 1, RoleIdList)
        end
    ),
    ok.

account_choice_result_ps(Status, ZoneId, Act, SuprId, Winner) ->
    #player_status{sid = Sid, role_drum = RoleDrum} = Status,
    #role_drum{choice = Choice} = RoleDrum,
    %?PRINT("account_choice_result_ps  ~p~n", [{ZoneId, Act, SuprId}]),
    case lists:keyfind({ZoneId, Act, SuprId}, #role_choice.key, Choice) of
        #role_choice{} = RoleChoice ->
            NRoleChoice = RoleChoice#role_choice{winner = Winner},
            ?PRINT("account_choice_result_ps Winner ~p~n", [Winner]),
            {ok, Bin} = mod_drumwar_mgr:pack_13722(NRoleChoice),
            lib_server_send:send_to_sid(Sid, Bin),
            NChoice = lists:keyreplace({ZoneId, Act, SuprId}, #role_choice.key, Choice, NRoleChoice),
            {ok, Status#player_status{role_drum = RoleDrum#role_drum{choice = NChoice}}};
        _ -> {ok, Status}
    end.

get_choice_reward(Status, Zid, Act, SuprId) ->
    #player_status{id = RoleId, role_drum = RoleDrum} = Status,
    #role_drum{choice = Choice} = RoleDrum,
    case lists:keyfind({Zid, Act, SuprId}, #role_choice.key, Choice) of
        #role_choice{type = Type, winner = Winner, reward_st = RewardSt} = RoleChoice ->
            ?PRINT("get_choice_reward  ~p~n", [{SuprId, Type, Winner, RewardSt}]),
            if
                RewardSt == 1 -> {false, ?ERRCODE(err137_guess_reward_get)};
                SuprId =/= Winner -> {false, ?ERRCODE(err137_guees_fail)};
                true ->
                    Sql = usql:update(role_drum_guess, [{reward_st, 1}], [{zone, Zid}, {rid, RoleId}, {action, Act}, {suprid, SuprId}]),
                    db:execute(Sql),
                    [_Cost,Reward] = mod_drumwar_mgr:get_award(Type),
                    NStatus = lib_goods_api:send_reward(Status, #produce{reward = Reward, type= drumwar, remark = lists:concat(["choose_drum_reward_", Type])}),
                    NRoleChoice = RoleChoice#role_choice{reward_st = 1},
                    NChoice = lists:keyreplace({Zid, Act, SuprId}, #role_choice.key, Choice, NRoleChoice),
                    {ok, Type, 1, NStatus#player_status{role_drum = RoleDrum#role_drum{choice = NChoice}}}
            end;
        _ ->
            {false, ?ERRCODE(err137_no_guess)}
    end.

%%绑钻不足，钻石来补
combine_cost(Cost,Gold,Bgold) ->
    [{_,_,Num}] = Cost,
    case Bgold>=Num of
        true-> Cost;
        false->
            LeftGold = Num - Bgold,
            case Gold>= LeftGold of
                true-> [{?TYPE_BGOLD,0,Bgold},{?TYPE_GOLD,0,LeftGold}];
                false -> {false,?GOLD_NOT_ENOUGH}
            end
    end.

%%验证候选人信息 是否候选人
check_choose(Node,Ruid,Zid,Act,Guess,Uid,Choice)->
    case lists:keyfind(Zid,1,Guess) of
        {_,ZGuess}->
            case lists:keyfind(Act,1,ZGuess) of
                {_,ActGuess}->
                    check_guess(Node,Ruid,Uid,ActGuess,Choice);
                _->
                    {false,?ERRCODE(err137_not_guess_zone_role)}
            end;
        _->
            {false,?ERRCODE(err137_not_guess_act_role)}
    end.

check_guess(_Node,_RUid,_Uid,[],_)->
    {false,?ERRCODE(err137_not_guess_act_role)};
check_guess(Node,RUid,Uid,[Value|ActGuess],Choice)->
    case Value of
        {#drum_role{rid=Uid}, _}->
            {false,?ERRCODE(err137_not_select_empty_role)};
        {#drum_role{rid=Uid,ruid=UidA}=ARole, BRole, _}->
            case check_choice(Node,RUid,UidA,Choice) of
                true->
                    {true, ARole, BRole};
                _->
                    {false,?ERRCODE(err137_not_select_same_plat)}
            end;
        {ARole,#drum_role{rid=Uid,ruid=UidA}=BRole, _}->
            case check_choice(Node,RUid,UidA,Choice) of
                true->
                    {true, ARole, BRole};
                _->
                    {false,?ERRCODE(err137_not_select_same_plat)}
            end;
        _->
            check_guess(Node,RUid,Uid,ActGuess,Choice)
    end.

%%验证竞选情况 是否选过
check_choice(Node,RUid,Uid,Choice)->
    case lists:keyfind(Uid,1,Choice) of
        {_,UChoice}->
            case lists:keyfind(Node,1,UChoice) of
                false->
                    true;
                {Node, RoleList} ->
                    case lists:keyfind(RUid, 1, RoleList) of
                        false -> true;
                        _ -> {false,?ERRCODE(err137_not_allow_select_same)}
                    end
            end;
        _->
            true
    end.

%%玩家升级 战力变更 60级以上 且连了跨服才通知变化
role_change(Status,OldLine)->
    #player_status{
        scene=Scene,
        id = RoleID,
        figure = #figure{lv=Lv},
        role_drum=RoleDrum
    }=Status,
    Uid = RoleID,
    case Lv >= ?DRUMLV of
        true->
            #role_drum{drumid=_Did,one=_One,zone=_Zid,action=_Act,deal=_Deal,choice=_Choice}=RoleDrum,
            case is_drum(Scene) of
                true->
                    mod_drumwar_mgr:cast_center([{mod,?MODULE,role_change_mgr,[is_in_drumwar(Status),Uid,OldLine]}]);
                _->
                    ignore
            end;
        _->
            ignore
    end.

role_change_mgr([IsWar,Uid,IsOn],State)->
    #drumwar_mgr{signs=Signs,action=DAct}=State,
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{node=Node,zid=Zone,action=Act,ruid=RUid,live=Live}=DRole->
            DRole1 = DRole#drum_role{online=IsOn,scene=0},
            case IsWar andalso DAct == Act of
                true ->
                    case data_drumwar:get_war(Zone,Act) of
                        [{_,Award}] ->
                            lib_role_drum:war_award(Node,Uid,Award);
                        _ ->
                            ?INFO("role_change_mgr,zone:~p,act:~p",[Zone,Act]),
                            ok
                    end,
                    lib_role_drum:update_role_drum(Node,Uid,Zone,Act,Live),
                    NDRole = DRole1#drum_role{calc_type = 1},
                    NSigns = lists:keyreplace(Uid,#drum_role.rid,Signs,NDRole),
                    State0 = State#drumwar_mgr{signs=NSigns},
                    role_away_mgr([RUid],State0);
                _ ->
                    NSigns = lists:keyreplace(Uid,#drum_role.rid,Signs,DRole1),
                    State#drumwar_mgr{signs=NSigns}
            end;
        _->
            State
    end.

%%切换场景
change_scene([RoleId, Scene, _PoolId], State) ->
    #drumwar_mgr{signs=Signs}=State,
    NewState = case lists:keyfind(RoleId,#drum_role.rid,Signs) of
        false->State;
        #drum_role{}=DrumRole->
            NDrumRole = DrumRole#drum_role{scene=Scene},
            NSigns = lists:keyreplace(RoleId,#drum_role.rid,Signs,NDrumRole),
            State#drumwar_mgr{signs=NSigns}
    end,
    NewState.

%%回调本地发消息给玩家
send_to_role(Node,Rid,Bin) when is_integer(Rid)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Rid,Bin]);
send_to_role(Node,RoleIds,Bin) when is_list(RoleIds)->
    mod_clusters_center:apply_cast(Node, ?MODULE, send_to_role_local, [RoleIds,Bin]);
send_to_role(Node,Sid,Bin)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_sid, [Sid,Bin]).

send_to_role_local(RoleIds, Bin) ->
    F = fun(RoleId) ->
        if
            is_integer(RoleId) -> lib_server_send:send_to_uid(RoleId, Bin);
            is_pid(RoleId) ->
                misc:is_process_alive(RoleId) andalso
                lib_server_send:send_to_uid(RoleId, Bin);
            true -> ok
        end
    end,
    lists:foreach(F, RoleIds).


%%所有战区推送传闻
send_tv(Act,_Signs) ->
    Length = mod_drumwar_mgr:ideal_value(Act),
    [{Reward,_}] = data_drumwar:get_war(1,Act),
    [{_,_,Num}] = Reward,
    mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,2,[Act,Length,Length*Num]], 600).


%%各战区推送传闻
% send_tv(Act,Signs) ->
%     List = calc_send_zone(Signs,Act,[]),
%     send_zone_tv(Act,List).

%%分战区人
calc_send_zone([],_Act,Result)->Result;
calc_send_zone([#drum_role{zid=Zone}=Role|T],Act,Result) ->
    case lists:keyfind(Zone,1,Result) of
        false-> NewResult = [{Zone,[Role]}|Result];
        {_,RoleList}->
            NewResult = lists:keyreplace(Zone,1,Result,{Zone,[Role|RoleList]})
    end,
    calc_send_zone(T,Act,NewResult).

%%战区传闻
send_zone_tv(_Act,[]) -> ok;
send_zone_tv(Act,[{Zone,Roles}|T]) ->
    % Length = length(Num),
    Length = mod_drumwar_mgr:ideal_value(Act),
    [{Reward,_}] = data_drumwar:get_war(Zone,Act),
    [{_,_,Num}] = Reward,
    BinData = lib_chat:make_tv(137, 2, [Act,Length,Length*Num]),
    send_tv_to_role(Roles,BinData),
    send_zone_tv(Act,T).

%%推送传闻
send_tv_to_role([],_BinData) -> ok;
send_tv_to_role([#drum_role{node=Node,rid=Rid,online=Online}|T],BinData) ->
    case Online == 1 of
        true-> send_to_role(Node,Rid,BinData);
        false-> skip
    end,
    send_tv_to_role(T,BinData).

%%战场奖励
war_award(_Node,_RoleID,[])->
    ignore;
war_award(Node,RoleID,Award)->
    mod_clusters_center:apply_cast(Node,?MODULE,war_award_local,[RoleID,Award]).
war_award_local(RoleID,Award)->
    lib_player:apply_cast(RoleID,?APPLY_CAST_STATUS,?MODULE,war_award_role,[Award]).
war_award_role(Status,Award)->
    Produce = #produce{reward = Award, type= drumwar,show_tips=3},
    NStatus = lib_goods_api:send_reward(Status,Produce),
    NStatus.

%%邮件结算
% mail_award(_Node,_RoleID,_Zone,_Rank,[])->
%     ignore;
% mail_award(Node,RoleID,Zone,Rank,Award)->
%     mod_clusters_center:apply_cast(Node,?MODULE,mail_award_local,[RoleID,Zone,Rank,Award]).
% mail_award_local(RoleID,Zone,Rank,Award)->
%     Mid = get_mail_zone(Zone),
%     Title = utext:get(1370008),
%     Content = utext:get(Mid,[Rank]),
%     lib_mail_api:send_sys_mail([RoleID], Title, Content, Award),
%     case Rank=<1 of
%         true->%%冠军数据更新
%             Sql = io_lib:format(?SQL_DRUM_UPDATE, [1,RoleID]),
%             db:execute(Sql),
%             lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, ?MODULE, update_drum, [1]);
%         _->
%             ignore
%     end.

get_mail_zone(1)->1370009;
get_mail_zone(2)->1370010;
get_mail_zone(3)->1370011;
get_mail_zone(4)->1370012;
get_mail_zone(_)->1370012.

get_zone(ZoneId) ->
    case data_drumwar:get_zone_lv_range(ZoneId) of
        [{MinLv, MaxLv}] ->
            case ZoneId == data_drumwar:get_max_zone() of
                true -> {7, [MinLv]};
                _ -> {6, [MinLv, MaxLv]}
            end;
        _ -> {7, [250]}
    end.

update_drum(Status,One)->
    #player_status{id = _RoleID,role_drum=RoleDrum}=Status,
    Status#player_status{role_drum=RoleDrum#role_drum{one=One}}.


%%更新玩家擂台赛信息
update_role_drum(Node,RoleID,Zone,Act,Live)->
    mod_clusters_center:apply_cast(Node,?MODULE,update_role_drum_local,[RoleID,Zone,Act,Live]).
update_role_drum_local(RoleID,Zone,Act,Live)->
    lib_player:apply_cast(RoleID,?APPLY_CAST_STATUS, ?MODULE,update_role_drum_role,[Zone,Act,Live]).
update_role_drum_role(Status,_Zone,Act,Live)->
    #player_status{role_drum = RoleDrum} = Status,
    %PayTime = RoleDrum#role_drum.pay_time,
    NRoleDrum = RoleDrum#role_drum{action = Act, live=Live},
    %%写进db
    %%db_replace_role_drum(Status#player_status.id, NRoleDrum),
    Status#player_status{role_drum = NRoleDrum}.

send_tv(ModuleId, Id, Msg) ->
    case is_drumwar_open() of
        true ->
            lib_chat:send_TV({all_lv, ?DRUMLV, 99999}, ModuleId, Id, Msg);
        _ -> ok
    end.

%%数据拼接
make_drum_role(Status)->
    Node = node(),
    #player_status{
        id = RoleID,
        sid = Sid,
        server_id = ServerId,
        platform = PForm,
        server_num = SNum,
        server_name = ServerName,
        figure = Figure,
        combat_power = Power,
        battle_attr = BA,
        role_drum = #role_drum{zone = ZoneId}
        %train_object = _TrainObj
    } = Status,
    AddLive = lib_module_buff:get_drum_war_live(Status),
    #drum_role{
        rid = RoleID,
        sid = Sid,
        server_id = ServerId,
        platform = PForm,
        server_num = SNum,
        server_name = ServerName,
        node = Node,
        zid = ZoneId,
        figure = Figure,
        role_attr = BA#battle_attr.attr,
        live = 1 + AddLive,
        action = 1,
        %train_object = TrainObj,
        power = Power,
        calc_type = 1
    }.

%%是否准备场景
is_in_drumready(Status)->
    lists:member(Status#player_status.scene, [?READY_SCENE]).

%%是否擂台战场
is_in_drumwar(Status)->
    lists:member(Status#player_status.scene, [?WAR_SCENE]).

is_drum(Scene)->
    AllScenes = [?READY_SCENE, ?WAR_SCENE],
    lists:member(Scene,AllScenes).

get_enter_state([Uid],State)->
    #drumwar_mgr{action=Act,state=Ds,cstate=Cs,signs=Signs}=State,
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{action=A} when A>=Act ->
            {Ds,Cs};
        _->
            {0,0}
    end.

%%使用技能
use_skill(SKillID,Status)->
    #player_status{scene=_Scene,id=_RoleId,copy_id=_Room,gold=Gold}=Status,
    case lib_role_drum:is_in_drumwar(Status) of
        true->
            SkillIdList = get_drum_skill(),
            ?PRINT("SkillIdList ~p~n", [SkillIdList]),
            case lists:member(SKillID, SkillIdList) of
                true->
                    NowSecs  = utime:unixtime(),
                    UsedSecs = get_skill_used_time(SKillID),
                    CD = ?SKILL_CD,
                    GoldCost = ?DRUM_SKILL_GOLD,
                    if
                        NowSecs =< UsedSecs + CD -> {?ERRCODE(err137_skill_cd),NowSecs+CD,Status};
                        Gold < GoldCost ->  {?GOLD_NOT_ENOUGH,NowSecs+CD,Status};
                        true->
                            case lib_goods_api:cost_object_list(Status, [{1,0,GoldCost}], drumwar, "drumwar") of
                                {true,Status0}->
                                    log_drum_cost(_RoleId,trans_skill_id_to_type(SKillID),[{1,0,GoldCost}]),
                                    set_skill_used_time(SKillID,NowSecs),
                                    {1,NowSecs+CD,Status0};
                                {false,Err,_}->
                                    {Err,0,Status}
                            end
                    end;
                _->
                    {?ERRCODE(err137_error_skill),0,Status}
            end;
        _->
            {?ERRCODE(err137_fight_allow_use),0,Status}
    end.

%%移除技能
remove_tmp_skill([],TmpSkill) -> TmpSkill;
remove_tmp_skill([Skill|T],TmpSkill) -> remove_tmp_skill(T,lists:keydelete(Skill,1,TmpSkill)).

get_skill_used_time(SKillID) ->
    case get({guild_drum_skill,SKillID}) of
        undefined -> 0;
        UsedTime  -> UsedTime
    end.

set_skill_used_time(SKillID,Secs) ->
    put({guild_drum_skill,SKillID}, Secs).

%%玩家死亡
player_die(Atter,Status) ->
    #battle_return_atter{
        id  = AUid,
        sign  = AtterSign
    } = Atter,
    #player_status{id=DeadUid}=Status,
    case is_in_drumwar(Status) of
        false ->
            ignore;
        true ->
            %%被玩家打死有效
            case AtterSign == 2 of
                true->
                    mod_drumwar_mgr:cast_center([{war_result,AUid,DeadUid}]);
                _->
                    mod_drumwar_mgr:cast_center([{war_result,lose,DeadUid}])
            end
    end.

dummy_die(SceneObject, _Klist, Atter, _AtterSign, []) ->
    #scene_object{scene = SceneId} = SceneObject,
    #battle_return_atter{id=AtterId} = Atter,
    case lists:member(SceneId,[?WAR_SCENE]) of
        true ->
            mod_drumwar_mgr:cast_mgr({war_result, win, AtterId});
        _ -> ok
    end.

player_be_hurt(_Status, _BattleReturn, _Atter, _AtterSign) -> ok.
    % case is_in_drumwar(Status) == true andalso AtterSign == ?BATTLE_SIGN_PLAYER of
    %     true ->
    %         case Status#player_status.pk_endtime > 0 andalso utime:unixtime() >= (Status#player_status.pk_endtime - 5) of %% 预留5秒
    %             true -> %% pk即将结束
    %                 ?PRINT("player_be_hurt hp_update:~p~n", [{Status#player_status.id, BattleReturn#battle_return.hp}]),
    %                 Args = [
    %                     Status#player_status.id, BattleReturn#battle_return.hp_lim, BattleReturn#battle_return.hp,
    %                     Atter#battle_return_atter.id, Atter#battle_return_atter.hp_lim, Atter#battle_return_atter.hp
    %                 ],
    %                 mod_drumwar_mgr:cast_center([{hp_update, Args}]);
    %             _ -> skip
    %         end;
    %     _ -> skip
    % end.

is_drumwar_open() ->
    OpenDay = util:get_open_day(),
    OpenDay >= ?DRUM_OPEN_DAY.

%%2 未连接跨服
%%3 未达到参赛等级
%%4 不需要重复报名
%%5 非报名阶段
%%6 未报名
%%7 非准备阶段
%%8 已在准备区
%%9 已达到购买上限
%%10 不在可购买阶段
%%11 命数虽好,不可贪多
%%12 非擂台赛场景,不需退出
%%13 道具不足
%%14 非竞猜时段
%%15 非可选战区候选人
%%16 非可选战场候选人
%%17 轮空玩家不可选
%%18 不可重复选中一人
%%19 不可同时选同台候选人
%%20 技能未冷却
%%21 技能擂台中可使用
%%22 非法技能
%%23 参数错误

checklist([]) -> true;
checklist([H|T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.

check({check_buy,Num})->
    case Num =< ?BUYMAX of
        true->
            true;
        _->
            {false,?ERRCODE(err137_buy_limit)}
    end;
check({check_live_num, Num, RoleDrum})->
    BuyMax = ?BUYMAX,
    if
        RoleDrum#role_drum.live =< 0 -> {false, ?ERRCODE(err137_be_kill_not_buy)};
        Num + RoleDrum#role_drum.live =< BuyMax -> true;
        true ->
            {false,?ERRCODE(err137_buy_limit)}
    end;
check({check_gold,Cost,Has})->
    case Cost=<Has of
        true->
            true;
        _->
            {false,?GOLD_NOT_ENOUGH}
    end;
check({check_sign,ODrumRole})->
    case is_record(ODrumRole, drum_role) of
        true ->
            true;
        _->
            {false,?ERRCODE(err137_not_sign)}
    end;
%%海选战前60秒不可进入
check({check_enter_ready,State,_EndTime})->
    %Now = utime:unixtime(),
    case State == ?READY orelse State == ?SEAWAR orelse State == ?RANKWAR of
        true ->
            true;
        _->
            {false,?ERRCODE(err137_not_prepare_state)}
    end;
check({check_state,Status})->
    case lib_player_check:check_list(Status, [action_free, is_transferable]) of
        true->
            true;
        {false, ErrCode} ->
            {false, ErrCode}
    end;
check({check_scene,Scene})->
    case lists:member(Scene,[?READY_SCENE]) of
        true->
            {false,?ERRCODE(err137_is_in_prepare)};
        _->
            true
    end;
check({check_ready,Scene})->
    case lists:member(Scene,[?READY_SCENE]) of
        true->
            true;
        _->
            {false,?ERRCODE(err137_not_in_prepare)}
    end;
check({check_repeat,Uid,Choice})->
    case lists:member(Uid,Choice) of
        true->
            {false,?ERRCODE(err137_not_allow_select_same)};
        _->
            true
    end;
check({check_type,Type})->
    case mod_drumwar_mgr:get_award(Type) of
        [[],[]]->
            {false,?ERRCODE(err137_cfg_error)};
        _->
            true
    end;
check({check_is_guess, Zid, ActId, Choice})->
    case [1 ||#role_choice{zone = Zone, action = Action} <- Choice, Zone == Zid, Action == ActId] of
        [] ->
            true;
        _ ->
            {false,?ERRCODE(err137_had_guess_act)}
    end;
check({check_choose_lv,Lv})->
    case Lv>=?CHOOSELV of
        true->
            true;
        _->
            {false,?ERRCODE(err137_lv_not_enough)}
    end;
check({check_cost, PS}) ->
    Result = lib_goods_util:check_object_list(PS,[{0,?DRUMITEM,1}]),
    case Result of
        true->
            true;
        {false,Res}->
            {false,Res};
        _Othre->
            true
    end;
check({check_ready_out,RoleId,ReadyOut})->
    case lists:member(RoleId,ReadyOut) of
        true->{false,?ERRCODE(err137_power_out)};
        false->true
    end;

check({check_lv,Lv})->
    case Lv>=?DRUMLV of
        true->
            true;
        _->
            {false,?ERRCODE(err137_lv_not_enough)}
    end;

check({check_open_day})->
    case is_drumwar_open() of
        true->
            true;
        _->
            {false,?ERRCODE(err137_open_day_limit)}
    end;

check(_)->true.

%%假人模拟创建测试
% test(RoleID)->
%     lib_player:apply_cast(RoleID,?APPLY_CAST_STATUS,?MODULE,test_mon,[]).
% test_mon(Status)->
%     #player_status{guild = RoleGuild} = Status,
%     #status_guild{id = GuildId} = RoleGuild,
%     DrumRole0 = make_drum_role(Status),
%     DrumRole  = DrumRole0#drum_role{group=GuildId},
%     create_mon(DrumRole),
%     Status.

%% 创建假人
create_mon(DrumRole, ServerMap) ->
    #drum_role{
        server_id = RoleSerId
    } = DrumRole,

    FakerInfo = lib_faker_api:create_faker(?MOD_DRUMWAR, DrumRole),
    {FakerId, CallbackData} = lib_faker_api:sync_create_object(?MOD_DRUMWAR, FakerInfo),

    #{power := NewPower} = CallbackData,
    {SerId, SerNum, SerName} = get_server_info_except(RoleSerId, ServerMap),

    {FakerId, NewPower, SerId, SerNum, SerName}.

get_server_info_except(SerId, ServerMap) ->
    SerList = maps:keys(ServerMap) -- [SerId],
    ServerName = ulists:list_to_bin(utext:get(183)),
    case SerList == [] of
        true -> {1, 1, ServerName};
        _ ->
            case lists:nth(urand:rand(1, length(SerList)), SerList) of
                NSerId when is_integer(NSerId) ->
                    maps:get(NSerId, ServerMap, {1, 1, ServerName});
                _ -> {1, 1, ServerName}
            end
    end.

%% 创建假人属性
get_mon_attr(Attr) when is_record(Attr, attr) ->
    %AttrL = [{1,0.001},{2,0.03},{3,0.01},{4,0.064},{5,0.006},{6,0.006},{7,0.006},{8,0.004}],
   AttrList = lib_player_attr:to_kv_list(Attr),
   NewAttrList = [{K, round(V*0.85)} || {K, V} <- AttrList],
   lib_player_attr:to_attr_record(NewAttrList);
get_mon_attr(_Attr) ->
    #attr{hp=100000, att=1000}.

%%获取假人AI
% get_mon_aid(Scene, MonId) ->
%     case lib_scene_object:lookup(Scene, 0, MonId) of
%         #scene_object{aid = MonAid} ->
%             MonAid;
%         _ -> ignore
%     end.


%%站位坐标
left_pos() ->
    case ?WAR_LOCATION of
        [{X,Y}, {_X2,_Y2}] -> {X,Y};
        _ -> {1968,1003}
    end.
right_pos() ->
    case ?WAR_LOCATION of
        [{_X,_Y}, {X2,Y2}] -> {X2,Y2};
        _ -> {1280,798}
    end.

%% ---------------------------------------------------------------------------
get_ready_scene(ServerId) ->
    Scene = ?READY_SCENE,
    PoolId = ServerId rem ?READY_POOL_MAX,
    {Scene, PoolId, 0}.

%%分组划分擂台场景
get_war(Group) ->
    {?WAR_SCENE, Group rem ?WAR_POOL_MAX, Group}.

get_drum_skill() ->
    case ?DRUM_SKILLS of
        [Tuple] -> tuple_to_list(Tuple);
        _ -> []
    end.

%% ----------------------------------db更新-----------------------------------------
db_replace_role_drum(RoleId,RoleDrum)->
    #role_drum{
        drumid = DrumId,
        one  = One,
        zone = Zone,
        action = Action,
        deal   = Deal,
        choice = Choise,
        pay_time = PayTime
    }
    = RoleDrum,
    LastChoice = util:term_to_bitstring(Choise),
    Sql = io_lib:format(?SQL_DRUM_INSERT, [RoleId,DrumId,One,Zone,Action,Deal,LastChoice,PayTime]),
    db:execute(Sql).

db_replace_drum_sign(DrumRole) ->
    DrumId = get_id(),
    #drum_role{
        rid = RoleId,
        server_id  = ServerId,
        platform = Platform,
        server_num = ServerNum,
        zid = Zid,
        figure = #figure{name=Name,lv=Lv,career=Career,picture=Picture,picture_ver=PictureV},
        power = Power
    }
    = DrumRole,
    NameAfFix = util:fix_sql_str(Name),
    Sql = io_lib:format(?SQL_DRUMWAR_SIGN_BATCH, [RoleId,ServerId,Platform,ServerNum,DrumId,Zid,NameAfFix,Picture,PictureV,Lv,Career,Power]),
    db:execute(Sql).

%% ----------------------------------事件处理-----------------------------------------
%% 客户端断开连接
handle_event(PS, #event_callback{type_id = ?EVENT_DISCONNECT}) when is_record(PS, player_status) ->
    role_change(PS,0),
    {ok, PS};
handle_event(PS, _) -> {ok, PS}.

%% ----------------------------------日志-----------------------------------------
log_drum_sign(DrumRole) ->
    #drum_role{
        rid = RoleId,
        figure = Figure
    }
    = DrumRole,
    NameFix = util:fix_sql_str(Figure#figure.name),
    lib_log_api:log_drum_sign(NameFix,RoleId,Figure#figure.lv).

log_drum_cost(RoleId,Type,Cost) ->
    lib_log_api:log_drum_cost(RoleId,Type,Cost).

trans_skill_id_to_type(1000001)->2;
trans_skill_id_to_type(1000002)->3;
trans_skill_id_to_type(1000003)->4;
trans_skill_id_to_type(_)->2.
