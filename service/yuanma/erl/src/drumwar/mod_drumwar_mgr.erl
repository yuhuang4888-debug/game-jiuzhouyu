% %%%===================================================================
% %%% @author zmh
% %%% @doc 跨服 擂台赛 (钻石争霸战)
% %%% 跨服中心管理进程
% %%% @end
% %%% @update by zzy 2017-11-08
% %%%===================================================================
-module(mod_drumwar_mgr).
-behavior(gen_server).
-compile(export_all).
-include("drumwar.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("chat.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("skill.hrl").
-include("def_cache.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

-export([
	start_link/0
	,init/1
	,handle_call/3
	,handle_cast/2
	,handle_info/2
	,terminate/2
	,code_change/3
]).

-export([
	call_mgr/1
	,cast_mgr/1
    ,cast_center/1
    ,call_center/1
]).

%%本地->跨服中心 Msg = [{start,args}]
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

gm_reset() ->
    cast_center([{gm_reset}]).

init([]) ->
	process_flag(trap_exit, true),
    {Msg,S,TimeOut} = calc_state(),
    {Ref,Snow,Etime} = case S of
        ?IDLE-> {erlang:send_after(TimeOut*1000,self(),sign),S,utime:unixtime()+TimeOut}; %%闲
        ?SIGN-> {erlang:send_after(TimeOut*1000,self(),Msg),S,utime:unixtime()+TimeOut}; %%报名期
        ?CLOSE-> {erlang:send_after(TimeOut*1000,self(),Msg),S,utime:unixtime()+TimeOut}; %%已结束
        _->
            {_NMsg,NS,NtimeOut} = next_calc_state(),
            {erlang:send_after(NtimeOut*1000,self(),sign),NS,utime:unixtime()+TimeOut}
    end,
    History = load_history(),
    Signs   = case Snow of
        ?SIGN -> %%启动时在报名期才需要加载数据
            load_signs(get_id());
        _->%%其他时候清表
            db:execute("TRUNCATE TABLE `drumwar_sign`"),
            []
    end,
    Choose = load_choose(),
	{ok, #drumwar_mgr{state=Snow,ref=Ref,etime=Etime,signs=Signs,history=History,choose=Choose}}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} -> {noreply, NewState};
        Reason ->
            ?ERR("handle info exception~n"
                 "info:~p~n"
                 "error:~p~n"
                 , [Msg,Reason]),
            {noreply, State}
    end.

%%Gm开启 进入报名期 Time之后进入预备期
do_handle_cast({gm_start,Time},State)->
    erase(), %% 清除进程字典
    #drumwar_mgr{ref=ORef,signs=Signs}=State,
    util:cancel_timer(get(summon_enter_ref)),
    util:cancel_timer(ORef),
    Ref = erlang:send_after(Time*1000,self(),ready),
    RefSign = erlang:send_after(?DRUM_SIGN_GAP*60*1000, self(), sign_broadcast),
    Etime = utime:unixtime()+Time,
    mod_clusters_center:apply_to_all_node(lib_role_drum, drum_start, []),
    brocast_msg(13700,[?SIGN,Etime]),
    clear_all_mons(?WAR_SCENE),
    %?PRINT("sign~p~n",[Signs]),
    %clear_all_role(),
    clear_all_role(Signs),
    db:execute("TRUNCATE TABLE `drumwar_sign`"),
    db:execute("TRUNCATE TABLE `drumwar_result`"),
    {noreply, State#drumwar_mgr{state=?SIGN,substate=0,signs=[],action=1,choose=[],choice=[],ref=Ref,ref_sign=RefSign,etime=Etime}};

do_handle_cast({gm_startrank},State)->
    #drumwar_mgr{ref=OldRef,signs=Signs}=State,
    util:cancel_timer(OldRef),
    Now = utime:unixtime(),
    [RelaxT] = data_drumwar:get_rank_ready(),
    [RankPre] = data_drumwar:get_rank_prepare(),
    [RankWar] = data_drumwar:get_rank_war(),
    RankAll = RelaxT+4*(RankPre+RankWar)+10,
    NEtime = Now+RankAll,
    spawn(fun()->brocast_act_msg(9,Signs,13703,[?TYPE_RANK_START,Now+RelaxT]) end),
    brocast_msg(13700,[?RANKWAR,NEtime]),  %%排位赛26min
    Ref = erlang:send_after(RelaxT*1000,self(),rank_war),
    {noreply, State#drumwar_mgr{action=9,state=?RANKWAR,signs=gm_change_act(Signs,[]),ref=Ref,etime=NEtime}};

%%模拟分析
do_handle_cast({analyse,Num,Time},State)->
    #drumwar_mgr{ref=ORef,signs=Signs}=State,
    util:cancel_timer(get(summon_enter_ref)),
    util:cancel_timer(ORef),
    Signs = make_signs(Num,[]),
    ?PRINT("~p~n",[{sign,util:now_to_date()}]),
    Ref = erlang:send_after(Time*1000,self(),ready),
    Etime = utime:unixtime()+Time,
    brocast_msg(13700,[?SIGN,Etime]),
    clear_all_mons(?WAR_SCENE),
    %clear_all_role(),
    clear_all_role(Signs),
    db:execute("TRUNCATE TABLE `drumwar_sign`"),
    db:execute("TRUNCATE TABLE `drumwar_result`"),
    {noreply, State#drumwar_mgr{state=?SIGN,action=1,signs=Signs,ref=Ref,etime=Etime}};

%% 重置
do_handle_cast({gm_reset},State)->
    #drumwar_mgr{ref = ORef} = State,
    {_Msg,S,TimeOut} = calc_state(),
    Ref = util:send_after(ORef, TimeOut*1000, self(), sign),
    ?PRINT("gm reset ~p~n", [{S, _Msg, utime:unixtime()+TimeOut}]),
    {noreply, State#drumwar_mgr{state=S,etime=utime:unixtime()+TimeOut,ref=Ref}};

%%打印当前数据
do_handle_cast(print, State) ->
    #drumwar_mgr{choose=_Choose}=State,
    {noreply, State};

%%假人AI部分 激活假人 已不用
% do_handle_cast({active_mon,Uid}, State) ->
%     #drumwar_mgr{signs=Signs,mons=Mons} = State,
%     case lists:keyfind(Uid,#drum_role.rid,Signs) of
%         #drum_role{group=Group}->
%             case lists:keyfind(Group,1,Mons) of
%                 {_,MonAi} when is_pid(MonAi)->
%                     erlang:send_after(10, MonAi, {'change_attr', [{find_target, 0}]});
%                 _->
%                     %%居然找不到怪物AI
%                     ignore
%             end;
%         _->
%             %%居然找不到人
%             ignore
%     end,
%     {noreply, State};

%%系统激活假人ai
do_handle_cast({system_active_mon,Uid}, State) ->
    #drumwar_mgr{signs=Signs,mons=Mons} = State,
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{group=Group}->
            case lists:keyfind(Group,1,Mons) of
                {Group, MonId, _, _, _, _} ->
                    case lib_scene_object_agent:get_object(MonId) of
                        #scene_object{aid=Aid} ->
                            erlang:send_after(9000, Aid, {'change_attr', [{find_target, 0}]});
                        _ ->
                            ignore
                    end;
                _->
                    ignore
            end;
        _->
            ignore
    end,
    {noreply, State};

%% 血量更新
do_handle_cast({hp_update, Args}, State) ->
    #drumwar_mgr{signs=Signs} = State,
    [ARoleId, AHpLim, AHp, BRoleId, BHpLim, BHp] = Args,
    ARole = lists:keyfind(ARoleId, #drum_role.rid, Signs),
    BRole = lists:keyfind(BRoleId, #drum_role.rid, Signs),
    ?PRINT("hp_update ~p~n", [Args]),
    if
        ARole =/= false andalso BRole =/= false ->
            NARole = ARole#drum_role{hp_lim = AHpLim, hp = AHp},
            NBRole = BRole#drum_role{hp_lim = BHpLim, hp = BHp},
            Signs1 = lists:keystore(ARoleId, #drum_role.rid, Signs, NARole),
            NSigns = lists:keystore(BRoleId, #drum_role.rid, Signs1, NBRole),
            NewState = State#drumwar_mgr{signs = NSigns};
        true ->
            NewState = State
    end,
    {noreply, NewState};

%%战斗结果
%%被假人击杀 惨 没有命数的时候离场
do_handle_cast({war_result,lose,Uid},State)->
    #drumwar_mgr{action=Act,signs=Signs} = State,
    NSigns =  case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{
            live = Life,
            node = Node,
            rid  = RoleID,
            zid  = Zone,
            lose = L,
            calc_type = OCalcType
        } = DrumRole when OCalcType == 0 ->
            Nlife = max(Life-1,0),
            Nlose = L+1,
            NDrumRole = DrumRole#drum_role{live=Nlife,lose=Nlose},
            {ok,Bin} = pt_137:write(13708,[is_over(Nlife),2,Act]),
            lib_role_drum:send_to_role(Node,RoleID,Bin),
            case Nlife =< 0 of
                true->
                    {ok,Bin1} = pack_13705(NDrumRole),
                    lib_role_drum:send_to_role(Node,RoleID,Bin1),
                    [{_,Award}] = data_drumwar:get_war(Zone,Act),
                    lib_role_drum:war_award(Node,RoleID,Award),
                    lib_role_drum:update_role_drum(Node,RoleID,Zone,Act,Nlife),
                    ResultTime = ?IF(is_integer(get(result_time)),get(result_time),utime:unixtime()),
                    spawn(fun()->
                        SleepTime = ResultTime - utime:unixtime(),
                        if
                            SleepTime > 5 ->
                                timer:sleep(5000),
                                mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID]);
                            SleepTime > 1 ->
                                timer:sleep((SleepTime-1)*1000),
                                mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID]);
                            true ->
                                mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID])
                        end
                    end),
                    LNDrumRole = NDrumRole#drum_role{calc_type=1};
                false->
                    LNDrumRole = NDrumRole
            end,
            %%日志
            log_drum_war(2,NDrumRole),
            lists:keyreplace(Uid,#drum_role.rid,Signs,LNDrumRole);
        #drum_role{} ->
            %?INFO("war result lose is settlement ~p~n", [Uid]),
            Signs;
        _->
            Signs
    end,
    brocast_live(none,Uid,NSigns),
    {noreply,State#drumwar_mgr{signs=NSigns}};
%%击杀假人 不武 离场
do_handle_cast({war_result,win,Uid},State)->
    #drumwar_mgr{action=Act,signs=Signs} = State,
    NSigns =  case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{
            rid  = RoleID,
            node = Node,
            zid  = Zone,
            win  = W,
            live = Live,
            calc_type = OCalcType
        }=DrumRole when OCalcType == 0 ->
            Nwin = W+1,
            NDrumRole = DrumRole#drum_role{action=Act+1,win=Nwin,calc_type=1},
            {ok,Bin} = pt_137:write(13708,[1,1,Act]),
            {ok, Bin1} = pack_13705(NDrumRole#drum_role{action=Act}),
            ResultTime = ?IF(is_integer(get(result_time)),get(result_time),utime:unixtime()),
            {ok,Bin2} = pt_137:write(13703,[Act,?TYPE_SUCCESS,ResultTime]),
            {ok, Bin3} = pt_137:write(13710, [Live, 0]),
            lib_role_drum:send_to_role(Node,RoleID,<<Bin/binary, Bin1/binary, Bin2/binary, Bin3/binary>>),
            [{Award,_}] = data_drumwar:get_war(Zone,Act),
            lib_role_drum:war_award(Node,RoleID,Award),
            lib_role_drum:update_role_drum(Node,RoleID,Zone,Act,NDrumRole#drum_role.live),
            spawn(fun()->
                SleepTime = ResultTime - utime:unixtime(),
                if
                    SleepTime > 5 ->
                        timer:sleep(5000),
                        mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID]);
                    SleepTime > 1 ->
                        timer:sleep((SleepTime-1)*1000),
                        mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID]);
                    true ->
                        mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID])
                end
            end),
            %%日志
            log_drum_war(1,NDrumRole#drum_role{action=Act}),
            lists:keyreplace(Uid,#drum_role.rid,Signs,NDrumRole);
        #drum_role{} ->
            %?INFO("war result win mon is settlement ~p~n", [Uid]),
            Signs;
        _->
            Signs
    end,
    {noreply,State#drumwar_mgr{signs=NSigns}};
%%真人击杀 先处理失败一方  才知道要不要清场  排位赛只走这里
do_handle_cast({war_result,WUid,LUid},State)->
    #drumwar_mgr{action=Act,signs=Signs,choice=Choice,choose=Choose} = State,
    ResultTime = ?IF(is_integer(get(result_time)),get(result_time),utime:unixtime()),
    {IsLeave,NSigns0,LoseDrumRole} =  case lists:keyfind(LUid,#drum_role.rid,Signs) of
        #drum_role{
            live = Life,
            rid  = LRoleID,
            node = LNode,
            zid  = LZone,
            lose = L,
            calc_type = OCalcTypeL
        }=LDrum when OCalcTypeL == 0 ->
            Nlife = max(Life-1,0),
            Nlose = L+1,
            NLDrum = LDrum#drum_role{live=Nlife,lose=Nlose},
            {ok,LBin} = pt_137:write(13708,[is_over(Nlife),2,Act]),
            lib_role_drum:send_to_role(LNode,LRoleID,LBin),
            case Nlife =< 0 of
                true->
                    {ok,LBin1} = pack_13705(NLDrum),
                    lib_role_drum:send_to_role(LNode,LRoleID,LBin1),
                    [{_,LAward}] = data_drumwar:get_war(LZone,Act),
                    lib_role_drum:war_award(LNode,LRoleID,LAward),
                    lib_role_drum:update_role_drum(LNode,LRoleID,LZone,Act,Nlife),
                    spawn(fun()->
                        SleepTime = ResultTime - utime:unixtime(),
                        if
                            SleepTime > 5 ->
                                timer:sleep(5000),
                                mod_clusters_center:apply_cast(LNode,?MODULE,enter_ready_local,[LRoleID]);
                            SleepTime > 1 ->
                                timer:sleep((SleepTime-1)*1000),
                                mod_clusters_center:apply_cast(LNode,?MODULE,enter_ready_local,[LRoleID]);
                            true ->
                                mod_clusters_center:apply_cast(LNode,?MODULE,enter_ready_local,[LRoleID])
                        end
                    end),
                    LNLDrum = NLDrum#drum_role{calc_type=1};
                false->
                    LNLDrum = NLDrum
            end,
            {Nlife,lists:keyreplace(LUid,#drum_role.rid,Signs,LNLDrum),LNLDrum};
        #drum_role{} = LDrum ->
            %?INFO("war result lose is settlement ~p~n", [LUid]),
            {0,Signs,LDrum};
        _->
            {0,Signs,#drum_role{rid=LUid,figure=#figure{}}}
    end,
    {NSigns,Zone,WinDrumRole} =  case lists:keyfind(WUid,#drum_role.rid,NSigns0) of
        #drum_role{
            rid  = WRoleID,
            node = WNode,
            zid  = WZone,
            win  = W,
            live = WLive,
            calc_type = OCalcTypeW
        }=WDrum when OCalcTypeW == 0 ->
            Nwin = W+1,
            NWDrum = case IsLeave=<0 of
                true->
                    WDrum#drum_role{action=Act+1,win=Nwin,calc_type=1};
                _->
                    WDrum#drum_role{win=W}
            end,
            {ok,WBin} = pt_137:write(13708,[is_over(IsLeave),1,Act]),
            lib_role_drum:send_to_role(WNode,WRoleID,WBin),
            IsLeave=<0 andalso begin
                {ok,WBin1} = pack_13705(NWDrum#drum_role{action=Act}),
                {ok,WBin2} = pt_137:write(13703,[Act,?TYPE_SUCCESS,ResultTime]),
                lib_role_drum:send_to_role(WNode, WRoleID, <<WBin1/binary, WBin2/binary>>),
                %lib_role_drum:send_to_role(WNode,WRoleID,WBin2),
                [{WAward,_}] = data_drumwar:get_war(WZone,Act),
                lib_role_drum:war_award(WNode,WRoleID,WAward),
                lib_role_drum:update_role_drum(WNode,WRoleID,WZone,Act,WLive),
                spawn(fun()->
                    SleepTime = ResultTime - utime:unixtime(),
                    if
                        SleepTime > 5 ->
                            timer:sleep(5000),
                            mod_clusters_center:apply_cast(WNode,?MODULE,enter_ready_local,[WRoleID]);
                        SleepTime > 1 ->
                            timer:sleep((SleepTime-1)*1000),
                            mod_clusters_center:apply_cast(WNode,?MODULE,enter_ready_local,[WRoleID]);
                        true ->
                            mod_clusters_center:apply_cast(WNode,?MODULE,enter_ready_local,[WRoleID])
                    end
                end)
            end,
            {lists:keyreplace(WUid,#drum_role.rid,NSigns0,NWDrum),WZone,NWDrum};
        #drum_role{}=WDrum ->
            %?INFO("war result win is settlement ~p~n", [WUid]),
            {NSigns0,1,WDrum};
        _->
            {NSigns0,1,#drum_role{rid=WUid,figure=#figure{}}}
    end,
    Act >= 12 andalso IsLeave=<0 andalso begin
        {TypeId, TvArgs} = lib_role_drum:get_zone(Zone),
        WName = WinDrumRole#drum_role.figure#figure.name,
        WSerNum = WinDrumRole#drum_role.server_num,
        mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,TypeId,TvArgs++[WSerNum, WName]], 600),
        {ok,Bin} = pt_137:write(13712,[Zone,WName]),
        spawn(fun()->show_champion(Bin,Zone,NSigns) end) %%广播给同战区的玩家
    end,
    %%第九场之后的真人对决有效
    Choose1 = case Act >= 9 andalso IsLeave=< 0 of
        true ->
            spawn(fun()->account_guess_result(Zone,Act,WinDrumRole,LoseDrumRole,Choice) end), %%海选赛后计算竞猜结果
            broadcast_guess_winner(Zone, Act, WUid),
            update_guess_winner(Choose, Zone, Act, WUid);
        _ ->
            Choose
    end,
    NChoose = case  Act >= 12 andalso IsLeave=<0 of
        true->%%决胜局 追加冠军
            Choose0 = add_results([WUid],NSigns,Choose1),
            brocast_guess_msg(0,Choose0),
            Choose0;
        _->
            Choose1
    end,
    %%命数广播一次
    brocast_live(WUid,LUid,NSigns),
    %%日志
    IsLeave=<0 andalso log_drum_war(WUid,LUid,Signs),
    {noreply,State#drumwar_mgr{signs=NSigns,choose=NChoose}};


%%通用回调
do_handle_cast({mod,Module,Method,Args},State)->
    NState = Module:Method(Args,State),
    {noreply, NState};

do_handle_cast(_Msg, State) ->
    % util:errlog("M:~p, Msg:~p~n", [?MODULE, Msg]),
	{noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} -> {noreply, NewState};
        Reason ->
            ?ERR("handle info exception~n"
                 "info:~p~n"
                 "error:~p~n"
                 , [Info,Reason]),
            {noreply, State}
    end.

%%idle结束 进入报名
do_handle_info(sign,State)->
    erase(), %% 清除进程字典
    [SignT] = data_drumwar:get_sign(),
    %%预告
    erlang:send_after((SignT-300)*1000,self(),tip),
    Ref = erlang:send_after(SignT*1000,self(),ready),
    RefSign = erlang:send_after(?DRUM_SIGN_GAP*60*1000, self(), sign_broadcast),
    Etime = utime:unixtime()+SignT,
    mod_clusters_center:apply_to_all_node(lib_role_drum, drum_start, []),
    brocast_msg(13700,[?SIGN,Etime]),
    {noreply, State#drumwar_mgr{state=?SIGN,substate=0,signs=[],choose=[],choice=[],ref=Ref,ref_sign=RefSign,etime=Etime}};

%%报名结束 进入准备期 謝絕2048之後的玩家 玩家入场
do_handle_info(ready,State)->
    db:execute("TRUNCATE TABLE `drumwar_sign`"),
    db:execute("TRUNCATE TABLE `drumwar_result`"),
    % io:format("~p~n",[{ready,util:now_to_date()}]),
    #drumwar_mgr{signs=Signs,ref_sign=RefSign}=State,
    {Signs1,_ZoneNum} = calc_zones(Signs),
    util:cancel_timer(RefSign),
    case length(Signs1)>0 of
        false->
            mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,8,[]], 300),
            {_Msg,_S,TimeOut} = cancel_next_calc_state(),
            Ref = erlang:send_after(TimeOut*1000,self(),sign),
            Etime = utime:unixtime() + TimeOut,
            mod_clusters_center:apply_to_all_node(lib_activitycalen_api, success_end_activity, [?MOD_DRUMWAR], 100),
            brocast_msg(13700,[?IDLE,Etime]),
            {noreply, State#drumwar_mgr{state=?IDLE,signs=[],ref=Ref,etime=Etime}};
        true->
            {NSigns,ReadyOut} = ready_check(Signs1),
            [ReadyT] = data_drumwar:get_sea_ready(),
            Ref = erlang:send_after(ReadyT*1000,self(),sea_war),
            Etime = utime:unixtime()+ReadyT,
            brocast_msg(13700,[?READY,Etime]),
            mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,1,[]], 300),
            drum_enter(Signs1),
            %print_signs(NSigns),
            {noreply, State#drumwar_mgr{state=?READY,action=1,signs=NSigns,cstate=0,choose=[],ref=Ref,etime=Etime,ready_out=ReadyOut}}
    end;

%%准备结束  进入海选 60s召唤人之前分划擂台
%%两两随机  单人补机器人  种子选手不相遇
%%循环这个阶段 直到剩余人数符合16强  进入16强争夺
do_handle_info(sea_war,State)->
    #drumwar_mgr{action=Act,signs=Signs,etime=OEtime}=State,
    Now = utime:unixtime(),
    [SeaPreT] = data_drumwar:get_sea_prepare(),
    [SeaWarT] = data_drumwar:get_sea_war(),
    Etime = case Act == 1 of
        true-> %%首场
            AllT = (SeaWarT+SeaPreT)*8,
            EndTime = Now+AllT,
            brocast_msg(13700,[?SEAWAR,EndTime]),  %%海选32min
            EndTime;
        _->
            OEtime
    end,
    %print_signs(Signs),
    if
        Act =< 8 -> %%海选8场
            %%10后拉人入场 所有人进入10s倒计时
            spawn(fun()->brocast_act_msg(Act,Signs,13703,[?TYPE_FIGHT_START,Now+SeaPreT]) end),
            SRef = erlang:send_after(SeaPreT*1000,self(),summon_enter),
            put(summon_enter_ref,SRef),
            put(result_time,Now+SeaPreT+SeaWarT),
            put(match_sub_state, {?TYPE_FIGHT_START,Now+SeaPreT}),
            %%强制结算 战斗100s
            Ref = erlang:send_after((SeaPreT+SeaWarT)*1000,self(),sea_war_result),
            {NSigns, SeaCandidate} = calc_group(Signs,Act),
            %print_signs_more(NSigns),
            {noreply, State#drumwar_mgr{state=?SEAWAR,ref=Ref,cstate=1,signs=NSigns,sea_candidate=SeaCandidate,etime=Etime,ready_out=[]}};
        true->%%120s间隙 之后进入16强赛
            [RelaxT] = data_drumwar:get_rank_ready(),
            [RankPre] = data_drumwar:get_rank_prepare(),
            [RankWar] = data_drumwar:get_rank_war(),
            RankAll = RelaxT+4*(RankPre+RankWar)+10,
            NEtime = Now+RankAll,
            %% 结束海选赛，在缓冲期间隔内，13703协议的场次信息发送第8轮，客户端好处理
            spawn(fun()->brocast_act_msg(8,Signs,13703,[?TYPE_RANK_START,Now+RelaxT]) end),
            %?PRINT("TYPE_RANK_START ~p~n", [1111111]),
            put(match_sub_state, {?TYPE_RANK_START,Now+RelaxT}),
            Ref = erlang:send_after(RelaxT*1000,self(),rank_war),
            {noreply, State#drumwar_mgr{state=?RANKWAR,substate=1,ref=Ref,etime=NEtime}}
    end;

%%海选召唤玩家入场 有机器人
do_handle_info(summon_enter,State)->
    #drumwar_mgr{action=Act,signs=Signs, sea_candidate = SeaCandidate, server_map = ServerMap}=State,
    NowTime = utime:unixtime(),
    [SeaWarT] = data_drumwar:get_sea_war(),
    spawn(fun()->brocast_act_msg(Act,Signs,13703,[?TYPE_FIGHT_END,NowTime+SeaWarT]) end),
    put(match_sub_state, {?TYPE_FIGHT_END,NowTime+SeaWarT}),
    Mons = summon_role_enter(Act,SeaCandidate,Signs,[], NowTime+SeaWarT,ServerMap),
    {noreply, State#drumwar_mgr{cstate=0,mons=Mons}};

%%排位赛召唤玩家入场  有轮空
do_handle_info(summon_rank_enter,State)->
    #drumwar_mgr{action=Act,signs=Signs,choose=Choose}=State,
    NowTime = utime:unixtime(),
    [RankWar] = data_drumwar:get_rank_war(),
    spawn(fun()->brocast_act_msg(Act,Signs,13703,[?TYPE_FIGHT_END,NowTime+RankWar]) end),
    put(match_sub_state, {?TYPE_FIGHT_END,NowTime+RankWar}),
    {NSigns,Wins} = summon_rank_enter(Act,Signs,[],[],NowTime+RankWar),
    NChoose = add_results(Wins,NSigns,Choose),
    ?PRINT("summon_rank_enter Wins ~p~n", [Wins]),
    %print_signs_more(NSigns),
    {noreply, State#drumwar_mgr{cstate=0,signs=NSigns,choose=NChoose}};

%%中场结算(强制结算还在场内战斗的) 把人踢回准备场景 进入下一场
do_handle_info(sea_war_result,State)->
    ?PRINT("sea_war_result ~n",[]),
    #drumwar_mgr{action=Act,signs=Signs}=State,
    {NSigns,_} = account_war(Act,Signs,[?WAR_SCENE],[],[]),
    %print_signs_more(NSigns),
    %%推送各战区传闻
    spawn(fun()-> lib_role_drum:send_tv(Act,Signs) end),
    clear_all_mons(?WAR_SCENE),
    self() ! sea_war,
    {noreply, State#drumwar_mgr{signs=NSigns, sea_candidate=[], mons=[],action=Act+1}};

%% 海选赛间隙完毕 进入排位赛 循环
%% 小于等于1时 不进入下一场 有轮空情况
do_handle_info(rank_war,State)->
    #drumwar_mgr{action=Act,signs=Signs,choose=Guess,etime=Etime}=State,
    %%给16强排序 只剩一人的组 直接冠军
    Now = utime:unixtime(),
    %%刚进入排位赛推送
    case Act == 9 of
        true->
            brocast_msg(13700,[?RANKWAR,Etime]);  %%排位赛26min
        false-> ok
    end,
    case Act=<12 of  %%继续排名赛
        true->
            %%15s后拉人入场
            [RankPre] = data_drumwar:get_rank_prepare(),
            spawn(fun()->brocast_act_msg(Act,Signs,13703,[?TYPE_FIGHT_START,Now+RankPre]) end),
            %?PRINT("TYPE_FIGHT_START ~p~n", [111111]),
            SRef = erlang:send_after(RankPre*1000,self(),summon_rank_enter),
            put(summon_enter_ref,SRef),
            put(match_sub_state, {?TYPE_FIGHT_START,Now+RankPre}),
            {NSigns,NGuess} = calc_rank_group(Signs,Act,Guess),
            CTime = Now+RankPre,
            %%冠军直接提示
            {LNsigns,LNGuess} = calc_champion(NSigns,NGuess,[]),
            brocast_guess_msg(CTime,LNGuess),
            %%5min+15s后强制结算
            ?PRINT("rank_war start : ~p~n",[{Act, length(LNsigns)}]),
            [RankWar] = data_drumwar:get_rank_war(),
            put(result_time,Now+RankPre+RankWar),
            Ref = erlang:send_after((RankPre+RankWar)*1000,self(),{rank_war_result,Act}),
            %print_signs_more(LNsigns),
            %print_guess(calc_af, LNGuess),
            {noreply, State#drumwar_mgr{state=?RANKWAR,substate=0,cstate=1,choose=LNGuess,signs=LNsigns,ref=Ref,ctime=CTime}};
        _->%%进入结束
            Ref = erlang:send_after(1000,self(),close),
            {noreply, State#drumwar_mgr{state=?CLOSE,ref=Ref}}
    end;

%%排名赛 超时 结算
do_handle_info({rank_war_result,CurAct},State)->
    #drumwar_mgr{action=Act,signs=Signs,choice=Choice,choose=Choose}=State,
    case CurAct=<Act of
        true->
            %%排位赛 人少 取8组人时的场景
            {NSigns,Wins} = account_war(Act,Signs,[?WAR_SCENE],Choice,[]),
            Choose1 = case CurAct >= 9 andalso length(Wins) > 0 of
                true ->
                    F = fun(WinId, ChooseTmp) ->
                        case lists:keyfind(WinId, #drum_role.rid, NSigns) of
                            #drum_role{zid = ZoneId} -> update_guess_winner(ChooseTmp, ZoneId, Act, WinId);
                            _ -> ChooseTmp
                        end
                    end,
                    lists:foldl(F, Choose, Wins);
                _ ->
                    Choose
            end,
            NChoose = case CurAct>= 12 of
                true->
                    Choose0 = add_results(Wins,NSigns,Choose1),
                    ?IF(Wins == [], ok, brocast_guess_msg(0,Choose0)),
                    Choose0;
                _->
                    Choose1
            end,
            self() ! rank_war,
            ?PRINT("rank_war_result~n",[]),
            %print_signs_more(NSigns),
            {noreply, State#drumwar_mgr{action=Act+1,choice=[],choose=NChoose,signs=NSigns}};
        _->
            Ref = erlang:send_after(1000,self(),close),
            %%提前结算掉了
            {noreply, State#drumwar_mgr{ref=Ref}}
    end;

%%活动结束 做最终各区16强排序 先分区
%%在各区有上至下排序  冠军有标记  无标记的 正常排
%%按照排名发奖励
do_handle_info(close,State)->
    % io:format("~p~n",[{close,util:now_to_date()}]),
    #drumwar_mgr{signs=Signs,history=History}=State,
    brocast_msg(13700,[?CLOSE,0]),
    NSigns = final_account(Signs,4),
    Ref = erlang:send_after(10000,self(),kict_role),
    DrumID = get_id(),
    SignsR = [begin
        #drum_role{
            zid = Zone,
            rid = Rid,
            figure = #figure{name=Name,guild_name=GName,vip=Vip,career=Career},
            platform = PForm,
            server_id = ServerId,
            server_num = Snum,
            rank = Rank,
            power = Pow
        }=Sign,
        #rank_role{
            drum = DrumID,
            zone = Zone,
            rid  = Rid,
            name = Name,
            gname = GName,
            server_id = ServerId,
            platform = PForm,
            servernum = Snum,
            rank = Rank,
            vip = Vip,
            power = Pow,
            career = Career
        }
    end ||Sign<-NSigns,Sign#drum_role.action>=9],
    NHistory = delete_overdue(DrumID,SignsR,History),
    {noreply, State#drumwar_mgr{state=?CLOSE,signs=NSigns,ref=Ref,history=NHistory}};

%%踢人
do_handle_info(kict_role,State)->
    #drumwar_mgr{choose=Choose,signs=Signs}=State,
    clear_all_role(Signs),
    mod_clusters_center:apply_to_all_node(lib_activitycalen_api, success_end_activity, [?MOD_DRUMWAR], 100),
    {_Msg,S,TimeOut} = calc_state(),
    brocast_msg(13700,[?IDLE,utime:unixtime()+TimeOut]),
    Ref = erlang:send_after(TimeOut*1000,self(),sign),
    save_choose(Choose),
    {noreply, State#drumwar_mgr{state=S,etime=utime:unixtime()+TimeOut,ref=Ref}};
%%闲置循环
do_handle_info(idle,State)->
    % io:format("~p~n",[{idle,util:now_to_date()}]),
    {Msg,S,TimeOut} = calc_state(),
    case Msg == sign of
        true-> Ref = erlang:send_after(TimeOut*1000,self(),sign);
        false-> Ref = erlang:send_after(TimeOut*1000,self(),Msg)
    end,
    {noreply, State#drumwar_mgr{state=S,signs=[],etime=utime:unixtime()+TimeOut,ref=Ref}};
%%闲置预告
do_handle_info(tip,State)->
    %%5分钟预告
    mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,4,[]], 600),
    {noreply, State};

do_handle_info(sign_broadcast,State)->
    #drumwar_mgr{state = S, ref_sign = RefSign} = State,
    case S =/= ?SIGN of
        true ->
            util:cancel_timer(RefSign),
            NRefSign = none;
        _ ->
            NRefSign = util:send_after(RefSign, ?DRUM_SIGN_GAP*60*1000, self(), sign_broadcast),
            mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137, 9, []], 100)
    end,
    {noreply, State#drumwar_mgr{ref_sign = NRefSign}};



%%判断是否直接进入下一场 排位赛只有一个场景  16*4人用不上太多
% do_handle_info({enter_next_rank_war,NAct},State)->
%     #drumwar_mgr{action=Act}=State,
%     case NAct > Act of
%         true->
%             Scene = lib_role_drum:get_war(8),
%             case catch mod_scene_agent:apply_call(Scene,0,lib_scene_agent,get_scene_user,[]) of
%                 []-> %%战斗场无人  直接进入下一轮
%                     self() ! rank_war,
%                     {noreply,State#drumwar_mgr{action=Act+1}};
%                 _->
%                     {noreply,State}
%             end;
%         _->
%             {noreply,State}
%     end;

do_handle_info(_Msg, State) ->
	% util:errlog("M:~p, Msg:~p~n", [?MODULE, Msg]),
	{noreply, State}.

%% ---------------------------------------------------------------------------

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {reply,Result,NewState} -> {reply,Result,NewState};
        Reason ->
            ?ERR("handle_call exception~n"
                 "Msg:~p~n"
                 "error:~p~n"
                 , [Msg,Reason]),
            {reply, error, State}
    end.

%%通用回调
do_handle_call({mod,Module,Method,Args},_From,State)->
    Result = Module:Method(Args,State),
    {reply,Result,State};
do_handle_call(_Msg, _From, State) ->
	% util:errlog("M:~p, Msg:~p~n", [?MODULE, Msg]),
	{reply,ok,State}.

terminate(_Reason, _State) ->
	_Reason /= normal andalso ?ERR("terminate Request: ~p, Reason=~p~n", [over, _Reason]),
    ok.
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%%战区划分
calc_zones(Signs)->
    calc_zones(Signs,[],[]).

calc_zones([],Signs,ZoneNum)->
    ZoneNotOpen = [ZoneId || {ZoneId, Num} <- ZoneNum, Num < ?WAR_LIMIT],
    case ZoneNotOpen == [] of
        true -> {Signs, ZoneNum};
        _ ->
            F = fun(DrumRole, {L1, L2}) ->
                case lists:member(DrumRole#drum_role.zid, ZoneNotOpen) of
                    true -> {L1, [DrumRole|L2]};
                    _ -> {[DrumRole|L1], L2}
                end
            end,
            {NewSigns, ReturnSigns} = lists:foldl(F, {[], []}, Signs),
            spawn(fun() -> cancel_zone(ReturnSigns) end),
            {NewSigns, ZoneNum}
    end;
calc_zones([DrumRole|OSigns],Signs,ZoneNum)->
    %#drum_role{figure = #figure{lv=Lv}}=DrumRole,
    ZoneID = DrumRole#drum_role.zid,
    %NDrumRole = DrumRole#drum_role{zid=ZoneID},
    %NSigns = [NDrumRole|Signs],
    %%计算战区人数
    NZoneNum = case lists:keyfind(ZoneID,1,ZoneNum) of
        false->[{ZoneID,1}|ZoneNum];
        {_,ONum}-> lists:keyreplace(ZoneID,1,ZoneNum,{ZoneID,ONum+1})
    end,
    calc_zones(OSigns,[DrumRole|Signs],NZoneNum).

%%海选分组 要先分战区
calc_group(Signs,Act)->
    calc_group(Signs,4,[],[],1,Act).

calc_group(L,Z,Signs,SeaCandidate,_,_) when Z=<0->
    {Signs ++ L,SeaCandidate};
calc_group(OSigns,Zone,Signs,SeaCandidate,Group,Act)->
    %Total = [D||D<-OSigns,D#drum_role.action==Act,D#drum_role.zid==Zone,D#drum_role.online>0],
    {Total, Left} = lists:partition(fun(D) -> D#drum_role.action==Act andalso D#drum_role.zid==Zone andalso D#drum_role.online>0 end, OSigns),
    All = length(Total),
    {NGroup,NSubSigns,NSeaCandidate} = case All =< ideal_value(Act) of
        true->%%人数不足  大家打AI
            match_ai(Total,Group,[],[]);
        _->
            case All>2*ideal_value(Act) of
                true->%%异常 人数超标 互相PK  多余的人 不管了
                    %%有足够的玩家 执行真人对决
                    Num = 2*ideal_value(Act),
                    {SignsPk,_R} = lists:split(Num,compare_data(Total)), %%多的人放弃了
                    % util:errlog("err role num M:~p,L:~p,Msg:~p~n", [?MODULE, ?LINE,{All,Act,_R}]),
                    calc_sub_group(ulists:list_shuffle(SignsPk),[],Group,[],[]);
                _->
                    %%有足够的玩家 部分人真人PK淘汰
                    Num = All-2*(All-ideal_value(Act)),  %%这部分人打AI
                    {SignAi,SignsPk} = lists:split(Num,Total),
                    {Group0,NSignsAi,NSeaCandidateAi} = match_ai(SignAi,Group,[],[]),
                    %%筛选种子选手
                    {SeedSigns,SubSigns,_} = calc_seed(SignsPk),%%把排名前16筛选出来SeedSigns，剩下的Subsigns

                    calc_sub_group(ulists:list_shuffle(SubSigns),SeedSigns,Group0,NSignsAi,NSeaCandidateAi)
            end
    end,
    calc_group(Left,Zone-1,NSubSigns++Signs,NSeaCandidate++SeaCandidate,NGroup,Act).

%%战区分组 种子选手不遇 210人一个场景 即105组 10*210
calc_sub_group([],[],Group,Signs,SeaCandidate)->
    {Group,Signs,SeaCandidate};
%%低阶玩家被匹配玩 你们只能自己打
calc_sub_group([],SeedSigns,Group,Signs,SeaCandidate)->
    case SeedSigns of
        [A0,B0|T]->
            A = A0#drum_role{group=Group,ai=0,pos=1,ruid=B0#drum_role.rid,calc_type=0},
            B = B0#drum_role{group=Group,ai=0,pos=0,ruid=A0#drum_role.rid,calc_type=0},
            calc_sub_group([],T,Group+1,[A,B|Signs],[{A,B}|SeaCandidate]);
        [A0]->
            A = A0#drum_role{group=Group,ai=1,pos=1,calc_type=0},
            calc_sub_group([],[],Group+1,[A|Signs],[{A}|SeaCandidate]);
        _->
            calc_sub_group([],[],Group,Signs,SeaCandidate)
    end;
%%没有种子选手  低阶玩家自己打
calc_sub_group(OSigns,[],Group,Signs,SeaCandidate)->
    case OSigns of
        [A0,B0|T]->
            A = A0#drum_role{group=Group,ai=0,pos=1,ruid=B0#drum_role.rid,calc_type=0},
            B = B0#drum_role{group=Group,ai=0,pos=0,ruid=A0#drum_role.rid,calc_type=0},
            calc_sub_group(T,[],Group+1,[A,B|Signs],[{A,B}|SeaCandidate]);
        [A0]->
            A = A0#drum_role{group=Group,ai=1,pos=1,calc_type=0},
            calc_sub_group([],[],Group+1,[A|Signs],[{A}|SeaCandidate]);
        _->
            calc_sub_group([],[],Group,Signs,SeaCandidate)
    end;
%%优先给种子匹配低阶对手
calc_sub_group(OSigns,[Seed|SeedSigns],Group,Signs,SeaCandidate)->
    case OSigns of
        [B0|T]->
            Nseed = Seed#drum_role{group=Group,ai=0,pos=1,ruid=B0#drum_role.rid,calc_type=0},
            B = B0#drum_role{group=Group,ai=0,pos=0,ruid=Seed#drum_role.rid,calc_type=0},
            calc_sub_group(T,SeedSigns,Group+1,[Nseed,B|Signs],[{Nseed,B}|SeaCandidate]);
        _->
            Nseed = Seed#drum_role{group=Group,ai=1,pos=1,calc_type=0},
            calc_sub_group(OSigns,SeedSigns,Group+1,[Nseed|Signs],[{Nseed}|SeaCandidate])
    end.

%%计算种子选手
calc_seed(SubSigns)->
    case length(SubSigns) =< 16 of
        true->
            {SubSigns,[],SubSigns};
        _->
            NSubSigns = compare_data(SubSigns),
            {SeedSigns,Signs}=lists:split(16,NSubSigns),
            {SeedSigns,Signs,NSubSigns}
    end.

%%排位赛分组 先获取晋级玩家 再划分分区  再配对(这里要对group重新赋值)
calc_rank_group(Signs,Act,Guess)->
    %Signs0 = [DrumR||DrumR<-Signs,DrumR#drum_role.action == Act],
    %SignsL = [DrumR||DrumR<-Signs,DrumR#drum_role.action /= Act],
    {Signs0, SignsL} = lists:partition(fun(DrumR) -> DrumR#drum_role.action==Act end, Signs),
    case Act == 9 of
        true-> NSign0 = ulists:list_shuffle(Signs0);
        false-> NSign0 = Signs0
    end,
    {NSigns,NGuess} = calc_sub_rank_group(NSign0,Guess),
    {NSigns++SignsL,NGuess}.

calc_sub_rank_group(Signs,Guess)->
    calc_sub_rank_group(Signs,4,1,[],Guess).

calc_sub_rank_group(_,0,_,NSigns,Guess)->
    {NSigns,Guess};
calc_sub_rank_group(Signs,Zone,Group,NSigns,Guess)->
    Signs0 = [DrumR||DrumR<-Signs,DrumR#drum_role.zid==Zone],
    [NGroup,Signs1,NGuess] = case Signs0 of
        [] -> %%该区无人
            [Group,Signs0,Guess];
        [Win]->%%只剩冠军 不予分组 标识冠军
            Nwin = Win#drum_role{one=1,group=0,calc_type=0},
            #drum_role{rid = Rid, action=Act}=Nwin,
            NewGuess = empty_add_guess(Zone,Act,{Nwin, Rid},Guess),
            [Group,[Nwin],NewGuess];
        _R->
            match_group(Signs0,Group,[],Guess)
    end,
    calc_sub_rank_group(Signs,Zone-1,NGroup,Signs1++NSigns,NGuess).

%%轮空竞猜填补
empty_add_guess(_Zone,13,_Value,Guess) -> Guess;
empty_add_guess(Zone,Act,Value,Guess) ->
    NGuess = add_guess(Zone,Act,Value,Guess),
    empty_add_guess(Zone,Act+1,Value,NGuess).

%%打完直接算冠军
calc_champion([],Guess,NSigns)->{lists:reverse(NSigns),Guess};
calc_champion([#drum_role{one=1,group=0}=DrumRole|T] = OSigns,Guess,NSigns)->
    #drum_role{node=Node,rid=RoleID,zid=Zid,figure=Figure,action=Act,live=Live,server_num=WSerNum} = DrumRole,
    Name = Figure#figure.name,
    {ok,Bin1} = pt_137:write(13708,[1,5,Act]),
    {ok,Bin2}=pack_13705(DrumRole#drum_role{action=Act}),
    {ok,Bin0} = pt_137:write(13712,[Zid,Name]),
    lib_role_drum:send_to_role(Node, RoleID, <<Bin0/binary, Bin1/binary, Bin2/binary>>),
    %lib_role_drum:send_to_role(Node,RoleID,Bin1),
    %lib_role_drum:send_to_role(Node,RoleID,Bin2),
    lib_role_drum:update_role_drum(Node,RoleID,Zid,Act,Live),
    {TypeId, TvArgs} = lib_role_drum:get_zone(Zid),
    mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,TypeId,TvArgs++[WSerNum, Name]], 600),
    spawn(fun()->show_champion(Bin0,Zid,NSigns++OSigns) end),
    [{Award,_}] = data_drumwar:get_war(Zid,Act),
    lib_role_drum:war_award(Node,RoleID,Award),
    NewDrumRole = DrumRole#drum_role{action=13,one=0},
    LNsigns = [NewDrumRole|NSigns],
    NGuess = add_results([RoleID],LNsigns,Guess),
    calc_champion(T,NGuess,LNsigns);
calc_champion([DrumRole|T],Guess,NSigns)->
    calc_champion(T,Guess,[DrumRole|NSigns]).

%%对手匹配
match_group([],Group,NSigns,NGuess)->
    [Group,NSigns,NGuess];
match_group(Signs,Group,NSigns,Guess)->
    case Signs of
        [A,B|T]->
            Na = A#drum_role{group=Group,ai=0,pos=1,ruid=B#drum_role.rid,calc_type=0},
            Nb = B#drum_role{group=Group,ai=0,pos=0,ruid=A#drum_role.rid,calc_type=0},
            #drum_role{zid=Zid,action=Act}=Na,
            NGuess = add_guess(Zid,Act,{Na,Nb,0},Guess),
            match_group(T,Group+1,[Na,Nb|NSigns],NGuess);
        [C]->%%一个人
            Nc = C#drum_role{group=Group,ai=1,pos=1,calc_type=0},
            #drum_role{rid=Rid,zid=Zid,action=Act}=Nc,
            match_group([],Group+1,[Nc|NSigns],add_guess(Zid,Act,{Nc,Rid},Guess))
    end.


%%等级转战区
trans_zone(Lv) -> data_drumwar:lv_to_zone(Lv).


%%Gm开启 10s后
gm_start(Time)->
    cast_center([{gm_start,Time}]).

%%模拟 10s后
analyse(Num,Time)->
    cast_center([{analyse,Num,Time}]).

%%gm开启排位赛
gm_startrank() ->
    cast_center([{gm_startrank}]).

gm_change_act([],Result)->Result;
gm_change_act([Role|T],Result) ->
    gm_change_act(T,[Role#drum_role{action=9}|Result]).


%%输出当前人员
print()->
    cast_center([print]).

%%计算开放 0未开放 1报名期间 2准备期间 3海选期间 4至强 5已结算 3 4其实都算比赛期间
calc_state()->
    {Date, _} = calendar:local_time(),
    Day = utime:day_of_week(),
    [OpenT] = data_drumwar:get_open(),
    [C] = data_drumwar:get_sign(),
    case lists:keyfind(Day,1,OpenT) of
        {_,H,M,S}->
            StartTime = {H,M,S},
            Start = utime:unixtime({Date, StartTime}),
            Now   = utime:unixtime(),
            End   = Start+C,
            if
                Now=<Start->
                    {sign,0,max(Start-Now,1)};   %%处于闲置状态  即将进入报名状态
                Now=<End ->
                    {ready,1,max(End-Now,1)}; %%处于报名状态  即将进入准备阶段
                true->
                    next_calc_state()
                     %活动期间 准备结束 已结束 准备下次
            end;
        _->
            next_calc_state()
    end.

%%下次开启时间
next_calc_state() ->
    [[OpenT]] = data_drumwar:get_open(),
    Day = utime:day_of_week(),
    {OpenW,OpenH,OpenM,OpenS} = OpenT,
    OpenTime = OpenH*3600 + OpenM*60 + OpenS,
    if
        OpenW == Day ->
            Reamain = 7*86400 + OpenTime - utime:get_seconds_from_midnight();
        OpenW > Day ->
            LeftDay = OpenW - Day,
            Reamain = LeftDay * 86400 + OpenTime - utime:get_seconds_from_midnight();
        true ->
            LeftDay = 7-(Day-OpenW),
            Reamain = LeftDay * 86400 + OpenTime - utime:get_seconds_from_midnight()
    end,
    LastRemain = max(Reamain,10),
    {sign,0,LastRemain}.

%%取消开启，获取下次开启时间
cancel_next_calc_state()->
    {Date, _} = calendar:local_time(),
    Day = utime:day_of_week(),
    [OpenT] = data_drumwar:get_open(),
    case lists:keyfind(Day,1,OpenT) of
        {_,H,M,S}->
            StartTime = {H,M,S},
            Start = utime:unixtime({Date, StartTime}) + 7*86400,
            % TipTime = Start - 5*60,
            Now   = utime:unixtime(),
            {sign,0,Start - Now};
        _->
            next_calc_state() %%木有活动 常规检测倒计时
    end.

%%构造报名玩家  分析用
make_signs(Num,Signs) when Num=<0->
    Signs;
make_signs(Num,Signs)->
    S = #drum_role{
        rid = Num
        ,figure = #figure{lv = urand:rand(1,100)}
        ,live = 1 %%命数 默认1
        ,online = 0
        ,action = 1  %%默认正在参与第一场
        ,power =urand:rand(1000,10000000)
    },
    make_signs(Num-1,[S|Signs]).

%%排序 战力
compare_data(SubSigns)->
    lists:sort(fun(A1, A2) ->
            compare_data(A1, A2)
    end, SubSigns).

compare_data(V1, V2) ->
    Figure1 = V1#drum_role.figure,
    Figure2 = V2#drum_role.figure,
    case V1#drum_role.power == V2#drum_role.power of
        true ->
            Figure1#figure.lv >= Figure2#figure.lv;
        false ->
            case V1#drum_role.power > V2#drum_role.power of
                true->
                    true;
                _->
                    false
            end
    end.

%%广播状态数据
brocast_msg(13700,[State,Time])->
    {ok,Bin} = pt_137:write(13700,[State,Time]),
    mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all_opened, [?DRUM_OPEN_DAY, Bin]).

%%广播竞猜数据
brocast_guess_msg(CTime,Guess)->
    mod_clusters_center:apply_to_all_node(?MODULE, brocast_guess_msg_local, [CTime,Guess], 100).

%%广播竞猜数据的胜者
broadcast_guess_winner(Zone, Act, WinnerId) ->
    mod_clusters_center:apply_to_all_node(?MODULE, broadcast_guess_winner_local, [Zone, Act, WinnerId], 100).

brocast_guess_msg_local(CTime, Guess) ->
    case lib_role_drum:is_drumwar_open() of
        true ->
            mod_cache:put(?CACHE_DRUMWAR_GUESS, {CTime, Guess}),
            {ok, Bin} = pt_137:write(13718, [CTime, 1]),
            lib_server_send:send_to_all(Bin);
        _ ->
            ok
    end.

broadcast_guess_winner_local(Zone, Act, WinnerId) ->
    case lib_role_drum:is_drumwar_open() of
        true ->
            case mod_cache:get(?CACHE_DRUMWAR_GUESS) of
                {CTime, Guess} ->
                    {ok, Bin} = pt_137:write(13724, [Zone, Act, WinnerId]),
                    lib_server_send:send_to_all(Bin),
                    NGuess = update_guess_winner(Guess, Zone, Act, WinnerId),
                    mod_cache:put(?CACHE_DRUMWAR_GUESS, {CTime, NGuess});
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

update_guess_winner(Guess, ZoneId, Act, WinnerId) ->
   case lists:keyfind(ZoneId, 1, Guess) of
        {_ZoneId, ZoneList} ->
            case lists:keyfind(Act, 1, ZoneList) of
                {_, GroupList} ->
                    F = fun(Item, L) ->
                        case Item of
                            {#drum_role{rid=ARid}=A, #drum_role{rid=BRid}=B, _WId} ->
                                ?IF(lists:member(WinnerId, [ARid, BRid]), [{A, B, WinnerId}|L], [Item|L]);
                            {A, WId} -> [{A, WId}|L];
                            _ -> L
                        end
                    end,
                    NGroupList = lists:foldl(F, [], GroupList),
                    NZoneList = lists:keystore(Act, 1, ZoneList, {Act, lists:reverse(NGroupList)}),
                    NGuess = lists:keystore(ZoneId, 1, Guess, {ZoneId, NZoneList}),
                    NGuess;
                _ -> Guess
            end;
        _ ->
            Guess
    end.

brocast_act_msg(_Act,[],13703,[_Type,_RankPre])->
    ignore;
brocast_act_msg(Act,_Signs,13703,[Type,Time])->
    {ok, Bin} = pt_137:write(13703,[Act,Type,Time]),
    mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all_opened, [?DRUM_OPEN_DAY, Bin]).
    % SignsMap = divide_role_by_node(Signs),
    % F = fun(Node, RoleList, Acc) ->
    %     RoleIds = [Rid || #drum_role{rid=Rid,action=RAct,online=Online} <- RoleList, RAct=<12 andalso Online == 1],
    %     lib_role_drum:send_to_role(Node, RoleIds, Bin),
    %     Acc
    % end,
    % maps:fold(F, 0, SignsMap).

%%拖人入擂台  拖人的时候人不在线 则通知对方直接获胜
summon_role_enter(_,[],_Signs,Mons,_,_)->
    Mons;
summon_role_enter(Act,[Value|SeaCandidate],Signs1,Mons,PkEndTime,ServerMap)->
    case Value of
        {DrumRoleA, DrumRoleB} ->
            #drum_role{
                node = NodeA, rid = RoleIDA, live = LifeA, action = DActA, group = GroupA, ruid = RUidA, pos = PosA
            }=DrumRoleA,
            #drum_role{
                node = NodeB, rid = RoleIDB, live = LifeB, action = DActB, group = GroupB, ruid = RUidB, pos = PosB
            }=DrumRoleB,
            Act == DActA andalso GroupA > 0 andalso
                mod_clusters_center:apply_cast(NodeA,lib_role_drum,enter_war_local,[RoleIDA,RUidA,GroupA,PosA,Act,PkEndTime]),
            Act == DActB andalso GroupB > 0 andalso
                mod_clusters_center:apply_cast(NodeB,lib_role_drum,enter_war_local,[RoleIDB,RUidB,GroupB,PosB,Act,PkEndTime]),
            {ok,BinA}=pt_137:write(13710,[LifeA,LifeB]),
            lib_role_drum:send_to_role(NodeA,RoleIDA,BinA),
            {ok,BinB}=pt_137:write(13710,[LifeB, LifeA]),
            lib_role_drum:send_to_role(NodeB,RoleIDB,BinB),
            NMons = Mons;
        {DrumRoleA} ->
            #drum_role{
                node = NodeA, rid = RoleIDA, live = LifeA, action = DActA, group = GroupA, ruid = RUidA, pos = PosA
            }=DrumRoleA,
            ?PRINT("HERE TO CREATE MON~n", []),
            {MonId, MonNewPower, MonSerId, MonSerNum, MonSerName} = lib_role_drum:create_mon(DrumRoleA, ServerMap),
            Act == DActA andalso GroupA > 0 andalso
                mod_clusters_center:apply_cast(NodeA,lib_role_drum,enter_war_local,[RoleIDA,RUidA,GroupA,PosA,Act,PkEndTime]),
            {ok, BinMon} = pt_137:write(13714, [MonNewPower, MonSerId, MonSerNum, MonSerName]),
            {ok,BinA}=pt_137:write(13710,[LifeA,1]),
            lib_role_drum:send_to_role(NodeA, RoleIDA, <<BinMon/binary, BinA/binary>>),
            NMons = [{GroupA, MonId, MonNewPower, MonSerId, MonSerNum, MonSerName}|Mons]
    end,
    summon_role_enter(Act,SeaCandidate,Signs1,NMons,PkEndTime,ServerMap).

%%排位赛入场
summon_rank_enter(_,[],NSigns,Wins,_)->
    {NSigns,Wins};
summon_rank_enter(Act,[DrumRole|Signs],NSigns,Wins,PkEndTime)->
    #drum_role{
        node = Node,
        rid  = RoleID,
        zid  = Zid,
        live = Alife,
        action = DAct,
        group = Group,
        server_num = WSerNum,
        figure = #figure{name=Name},
        one  = One,
        ruid = RUid,
        ai   = Ai,
        win = W,
        pos = Pos
    }=DrumRole,
    Uid = RoleID,
    [NDrumRole,NWins] = case Act == DAct of
        true when Group>0 andalso Ai=<0 -> %%正常进入比赛
            Blife = case lists:keyfind(RUid,#drum_role.rid,Signs++NSigns) of
                #drum_role{live=B}->
                    B;
                _->
                    1
            end,
            {ok,Bin}=pt_137:write(13710,[Alife,Blife]),
            lib_role_drum:send_to_role(Node,RoleID,Bin),
            mod_clusters_center:apply_cast(Node,lib_role_drum,enter_war_local,[RoleID,RUid,Group,Pos,Act,PkEndTime]),
            [DrumRole,Wins];
        true when Group>0 andalso Ai>0-> %%轮空 获胜 直接进入下一轮
            {ok,Bin}=pt_137:write(13708,[1,4,Act]),
            {ok,Bin1}=pack_13705(DrumRole#drum_role{action=Act}),
            ResultTime = ?IF(is_integer(get(result_time)),get(result_time),utime:unixtime()),
            {ok,Bin2} = pt_137:write(13703,[Act,?TYPE_SUCCESS,ResultTime]),
            lib_role_drum:send_to_role(Node,RoleID,Bin),
            lib_role_drum:send_to_role(Node,RoleID,Bin1),
            lib_role_drum:send_to_role(Node,RoleID,Bin2),
            [{Award,_}] = data_drumwar:get_war(Zid,Act),
            lib_role_drum:war_award(Node,RoleID,Award),
            log_drum_war(3,DrumRole),
            [DrumRole#drum_role{action=Act+1,win=W+1},Wins];
        true when Group=<0 andalso One>0 -> %%截止 冠军已出
            {ok,Bin1} = pt_137:write(13708,[1,5,Act]),
            {ok,Bin2}=pack_13705(DrumRole#drum_role{action=DAct}),
            {ok,Bin0} = pt_137:write(13712,[Zid,Name]),
            lib_role_drum:send_to_role(Node,RoleID,Bin0),
            lib_role_drum:send_to_role(Node,RoleID,Bin1),
            lib_role_drum:send_to_role(Node,RoleID,Bin2),
            lib_role_drum:update_role_drum(Node,RoleID,Zid,Act,Alife),
            {TypeId, TvArgs} = lib_role_drum:get_zone(Zid),
            mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,TypeId,TvArgs++[WSerNum, Name]], 600),
            spawn(fun()->show_champion(Bin0,Zid,Signs++NSigns) end),
            [{Award,_}] = data_drumwar:get_war(Zid,Act),
            lib_role_drum:war_award(Node,RoleID,Award),
            %%log_drum_war(3,DrumRole),
            [DrumRole#drum_role{action=13,one=0},[Uid|Wins]];
        _->%%未参与本场次玩家
            [DrumRole,Wins]
    end,
    summon_rank_enter(Act,Signs,[NDrumRole|NSigns],NWins,PkEndTime).


%%场内超时结算 先组 分组
account_war(_,Signs,[],_,Wins)->
    {Signs,Wins};
account_war(Act,Signs,[Scene|Scenes],Choice,Wins)->
    PlayerList = [D||D<-Signs,D#drum_role.scene==Scene,D#drum_role.calc_type<1],
    %?PRINT("account_war : ~p~n",[PlayerList]),
    ResGroups = calc_double(PlayerList,[]),
    {NSigns,SubWins} = account_group_war(Act,ResGroups,Signs,Choice,[]),
    account_war(Act,NSigns,Scenes,Choice,Wins++SubWins).

account_group_war(_,[],Signs,_,Wins)->
    {Signs,Wins};
account_group_war(Act,[{Win}|ResGroups],Signs,Choice,Wins)->
    #drum_role{
        figure = #figure{name=Name},
        node = Node,
        rid=RoleID,
        group = GroupA,
        ai = Ai
    }=Win,
    case Ai == 1 andalso get_alive(RoleID,Signs) == 1 of
        true ->
            {Scene, PoolId, CopyId} = lib_role_drum:get_war(GroupA),
            case catch mod_scene_agent:apply_call(Scene, PoolId, ?MODULE, get_users_hp, [[{?BATTLE_SIGN_PLAYER, RoleID}, {?BATTLE_SIGN_DUMMY, CopyId}]]) of
                [{_, AHp, AHpLim}, {_, BHp, BHpLim}] -> ok;
                _ -> AHp=0, AHpLim=1, BHp=0, BHpLim = 1
            end,
            AHpRatio = AHp / (AHpLim+1),
            BHpRatio = BHp / (BHpLim+1),
            ?PRINT("AHpRatio:~p, BHpRatio:~p ~n", [AHpRatio, BHpRatio]),
            IsW = ?IF(AHpRatio >= BHpRatio, true, ?IF(AHpRatio == BHpRatio, true, false));
        _ ->
            IsW = check_win(Act,RoleID,Signs)
    end,
    NSigns = case IsW of
        true  ->
            % log_drum_war(4,RoleID,0,Signs),
            change_score(Act,RoleID,1,1,0,Signs,Choice,Name);
        _->
            change_score(Act,RoleID,0,0,1,Signs,Choice,Name)
    end,
    %%踢人回准备区
    mod_clusters_center:apply_cast(Node,?MODULE,enter_ready_local,[RoleID]),
    log_drum_war(4,RoleID,0,Signs),
    account_group_war(Act,ResGroups,NSigns,Choice,[RoleID|Wins]);
account_group_war(Act,[{A,B}|ResGroups],Signs,Choice,Wins)->
        #drum_role{
            figure = #figure{name=AName},
            node = ANode,
            % hp_lim = AHpLim,
            % hp = AHp,
            power = ValueA,
            group = GroupA,
            rid = ARoleID
        }=A,
        AUid = ARoleID,
        #drum_role{
            node = BNode,
            % hp_lim = BHpLim,
            % hp = BHp,
            figure = #figure{name=BName},
            power = ValueB,
            rid = BRoleID
        }=B,
        BUid = BRoleID,
        LiveA = get_alive(AUid,Signs),
        LiveB = get_alive(BUid,Signs),
        {WUid,NSigns} = case LiveA>LiveB of
            true->%%A胜 B负
                %%踢人回准备区
                mod_clusters_center:apply_cast(ANode,?MODULE,enter_ready_local,[ARoleID]),
                mod_clusters_center:apply_cast(BNode,?MODULE,enter_ready_local,[BRoleID]),
                %%同步 胜
                log_drum_war(4,AUid,BUid,Signs),
                NSigns0 = change_score(Act,AUid,1,1,0,Signs,Choice,BName),
                {AUid,change_score(Act,BUid,0,0,1,NSigns0,Choice,AName)};
            _->
                {Scene, PoolId, _CopyId} = lib_role_drum:get_war(GroupA),
                case catch mod_scene_agent:apply_call(Scene, PoolId, ?MODULE, get_users_hp, [[{?BATTLE_SIGN_PLAYER, ARoleID}, {?BATTLE_SIGN_PLAYER, BRoleID}]]) of
                    [{_, AHp, AHpLim}, {_, BHp, BHpLim}] -> ok;
                    _ -> AHp=0, AHpLim=1, BHp=0, BHpLim = 1
                end,
                AHpRatio = AHp / (AHpLim+1),
                BHpRatio = BHp / (BHpLim+1),
                IsAWin = ?IF(AHpRatio > BHpRatio, true, ?IF(AHpRatio == BHpRatio, ValueA>=ValueB, false)),
                case LiveA == LiveB of
                    true when IsAWin == true ->
                        %%踢人回准备区
                        mod_clusters_center:apply_cast(ANode,?MODULE,enter_ready_local,[ARoleID]),
                        mod_clusters_center:apply_cast(BNode,?MODULE,enter_ready_local,[BRoleID]),
                        %%同步 胜
                        log_drum_war(4,AUid,BUid,Signs),
                        NSigns0 = change_score(Act,AUid,1,1,0,Signs,Choice,BName),
                        {AUid,change_score(Act,BUid,0,0,1,NSigns0,Choice,AName)};
                    _->
                        %%A负B胜
                        %%踢人回准备区
                        mod_clusters_center:apply_cast(ANode,?MODULE,enter_ready_local,[ARoleID]),
                        mod_clusters_center:apply_cast(BNode,?MODULE,enter_ready_local,[BRoleID]),
                        log_drum_war(4,BUid,AUid,Signs),
                        NSigns0 = change_score(Act,BUid,1,1,0,Signs,Choice,AName),
                        {BUid,change_score(Act,AUid,0,0,1,NSigns0,Choice,BName)}
                end
        end,
        account_group_war(Act,ResGroups,NSigns,Choice,[WUid|Wins]).

get_users_hp(RoleIds) ->
    F = fun({BASign, RoleId}, Acc) ->
        case BASign of
            ?BATTLE_SIGN_PLAYER ->
                case lib_scene_agent:get_user(RoleId) of
                    #ets_scene_user{battle_attr=#battle_attr{hp=Hp, hp_lim=HpLim}} -> ok;
                    _ -> Hp = 0, HpLim = 1
                end;
            _ ->
                case lib_scene_object_agent:get_scene_object(RoleId) of
                    [#scene_object{battle_attr=#battle_attr{hp=Hp, hp_lim=HpLim}}] -> ok;
                    _ -> Hp = 0, HpLim = 1
                end
        end,
        Acc ++ [{RoleId, Hp, HpLim}]
    end,
    lists:foldl(F, [], RoleIds).

enter_ready_local(RoleID)->
    lib_player:apply_cast(RoleID,?APPLY_CAST_STATUS, ?MODULE, enter_ready_role,[]).
enter_ready_role(Status)->
    #player_status{id=RoleId}=Status,
    {Scene, PoolId, CopyId} = lib_role_drum:get_ready_scene(Status#player_status.server_id),
    {RandX,RandY,Circle} = urand:list_rand(?READY_LOCATION),
    {X,Y}=umath:rand_point_in_circle(RandX,RandY,Circle,1),
    case lib_role_drum:is_in_drumready(Status) of
        true->
            Status;
        _->
            case lib_role_drum:is_in_drumwar(Status) of
                true ->
                    mod_drumwar_mgr:cast_center([{mod, lib_role_drum, change_scene, [RoleId,Scene,PoolId]}]),
                    SkillList = [{SkillId, 1} || SkillId <- lib_role_drum:get_drum_skill()],
                    {_, NStatus1} = lib_skill:del_tmp_skill_list(Status, SkillList),
                    % 事件触发
                    CallbackData = #callback_join_act{type = ?MOD_DRUMWAR},
                    {ok, NStatus2} = lib_player_event:dispatch(NStatus1, ?EVENT_JOIN_ACT, CallbackData),
                    lib_achievement_api:async_event(RoleId, lib_achievement_api, drumwar_join_event, []),
                    lib_scene:change_scene(NStatus2, Scene, PoolId, CopyId, X, Y, false, [{change_scene_hp_lim,1},{group,0}]);
                _ ->
                    Status
            end
    end.

calc_double([],ResGroups)->
    ResGroups;
calc_double([A|OPlayerList],ResGroups)->
    #drum_role{group=Group}=A,
    case lists:keytake(Group,#drum_role.group,OPlayerList) of
        {value,B,PlayerList}->
            calc_double(PlayerList,[{A,B}|ResGroups]);
        _->
            calc_double(OPlayerList,[{A}|ResGroups])
    end.

change_score(CurAct,Uid,IsA,W,L,Signs,Choice,_LName)->
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{node=Node,server_num=WSerNum,figure=#figure{name=Name},live=Live,rid=RoleID,action=Act,zid=Zone,win=Win,lose=Lose,ruid=LUid}=DRole->
            case Act>CurAct of
                true->%%说明结算过了 比如提前战斗完毕 滞留场内
                    Signs;
                _ when Live=<0-> %%说明战败 不予结算
                    Signs;
                _->
                    NDRole = DRole#drum_role{action=Act+IsA,win=Win+W,lose=Lose+L, calc_type=1},
                    Res = case IsA >= 1 of
                        true->
                            [{Award,_}] = data_drumwar:get_war(Zone,Act),
                            lib_role_drum:war_award(Node,RoleID,Award),
                            3;%%得胜
                        _->
                            [{_,Award}] = data_drumwar:get_war(Zone,Act),
                            lib_role_drum:war_award(Node,RoleID,Award),
                            6 %%负
                    end,
                    {ok,Bin}=pt_137:write(13708,[1,Res,Act]),
                    case Res == 6 of
                        true-> {ok,Bin1}=pack_13705(NDRole#drum_role{action=Act,live=0});
                        false-> {ok,Bin1}=pack_13705(NDRole#drum_role{action=Act})
                    end,
                    lib_role_drum:send_to_role(Node, RoleID, <<Bin/binary, Bin1/binary>>),
                    %lib_role_drum:send_to_role(Node,RoleID,Bin1),
                    lib_role_drum:update_role_drum(Node,RoleID,Zone,Act,NDRole#drum_role.live),
                    CurAct>=12 andalso IsA>0 andalso begin
                        {TypeId, TvArgs} = lib_role_drum:get_zone(Zone),
                        mod_clusters_center:apply_to_all_node(lib_role_drum, send_tv, [137,TypeId,TvArgs++[WSerNum, Name]], 600),
                        {ok,Bin0} = pt_137:write(13712,[Zone,Name]),
                        spawn(fun()->show_champion(Bin0,Zone,Signs) end)
                    end,
                    %%第九场之后的超时结算有效
                    CurAct>=9 andalso IsA>0 andalso begin
                        LoseDrumRole = lists:keyfind(LUid, #drum_role.rid, Signs),
                        spawn(fun()->account_guess_result(Zone,CurAct,NDRole,LoseDrumRole,Choice) end)
                    end,
                    lists:keyreplace(Uid,#drum_role.rid,Signs,NDRole)
            end;
        _-> %%找不到这个玩家
            Signs
    end.

%%获得命数
get_alive(Uid,Signs)->
    case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{live=L}->
            L;
        _->
            0
    end.

%%清理擂台的假人
clear_all_mons(Scene)->
    PoolIdList = lists:seq(0, ?WAR_POOL_MAX-1),
    F = fun(PoolId) ->  lib_scene:clear_scene(Scene, PoolId) end,
    lists:foreach(F, PoolIdList).

%%清理所有玩家 准备区 和 擂台区
clear_all_role()->
    clear_all_role(?READY_SCENE, ?WAR_SCENE).
clear_all_role(ReadyScene, WarScene)->
    ReadyPools = lists:seq(0, ?READY_POOL_MAX-1),
    WarPools = lists:seq(0, ?WAR_POOL_MAX-1),
    SceneList = [{ReadyScene, PoolId} || PoolId <- ReadyPools] ++ [{WarScene, PoolId} || PoolId <- WarPools],
    spawn(fun()->
        F = fun({Scene, Pool}) ->
            case catch mod_scene_agent:apply_call(Scene, Pool,lib_scene_agent,get_scene_user,[]) of
                PlayerList when is_list(PlayerList)->
                    %?PRINT("~p~n",[length(PlayerList)]),
                    role_back(PlayerList);
                _R->
                    ignore
            end,
            timer:sleep(300)
        end,
        lists:foreach(F, SceneList)
    end),
    ok.

clear_all_role(Signs) ->
    spawn(fun() ->
        F = fun(#drum_role{rid = Rid, node = Node, scene = Scene}, Acc) ->
            case Scene == ?READY_SCENE orelse Scene == ?WAR_SCENE of
                true ->
                    mod_clusters_center:apply_cast(Node, ?MODULE, role_back_local, [Rid]),
                    Acc rem 30 == 0 andalso timer:sleep(200),
                    Acc + 1;
                _ -> Acc
            end
        end,
        lists:foldl(F, 1, Signs)
    end),
    ok.

role_back([])->
    ignore;
role_back([Role|PlayerList])->
    #ets_scene_user{
        node = Node,
        id = RoleID
    }=Role,
    mod_clusters_center:apply_cast(Node,?MODULE,role_back_local,[RoleID]),
    role_back(PlayerList).

role_back_local(RoleID)->
    lib_player:apply_cast(RoleID,?APPLY_CAST_STATUS,?MODULE,role_back_role,[]).

%%回到旧场景
role_back_role(Status)->
    case lib_role_drum:is_drum(Status#player_status.scene) of
        true->
            lib_scene:change_scene(Status, 0, 0, 0, 0, 0, true, [{action_free, ?ERRCODE(err137_in_drum_war)},{group,0},{pk,{?PK_PEACE,false}},{change_scene_hp_lim, 1}]);
        _->
            Status
    end.

%%是否结算面板
is_over(L) when L>0->0;
is_over(_)->1.

%%最终排序结算
final_account(Signs,0)->
    Signs;
final_account(Signs,Zone)->
    [SignsZ,SignsL] = lists:foldl(fun(S,Args)->
        [A,B]=Args,
        case S of
            #drum_role{zid=Zone}->
                [[S|A],B];
            _->
                [A,[S|B]]
        end
    end,[[],[]],Signs),
    NSignsZ = final_zone_account(SignsZ),
    final_account(NSignsZ++SignsL,Zone-1).

%%子战区内结算
final_zone_account(Signs)->
    [SignsZ,SignsL] = lists:foldl(fun(S,Args)->
        [A,B]=Args,
        case S#drum_role.action >=9 of
            true->
                [[S|A],B];
            _->
                [A,[S|B]]
        end
    end,[[],[]],Signs),
    NSignsZ = final_zone_account(SignsZ,1,[13,12,11,10,9]),
    NSignsZ++SignsL.

final_zone_account(Signs,_,[])->
    Signs;
final_zone_account(Signs,Rank,[Act|T])->
    [SignsZ,SignsL] = lists:foldl(fun(S,Args)->
        [A,B]=Args,
        case S#drum_role.action == Act  of
            true->
                [[S|A],B];
            _->
                [A,[S|B]]
        end
    end,[[],[]],Signs),
    SignsZ0 = compare_data(SignsZ),
    [NRank,NSignsZ] = compare_rank(SignsZ0,Rank,[]),
    final_zone_account(NSignsZ++SignsL,NRank,T).

%%排名赋值
compare_rank([],Rank,NSigns)->
    [Rank,NSigns];
compare_rank([DRole|OSigns],Rank,NSigns)->
    #drum_role{
        node = _Node,
        zid  = Zone,
        rid  = _RoleID
    }=DRole,
    _Award = data_drumwar:get_rank(Zone,Rank),
    compare_rank(OSigns,Rank+1,[DRole#drum_role{rank=Rank}|NSigns]).

%%谢绝多余的人
ready_check(Signs)->
    Signs0 = compare_data(Signs),
    F = fun(DrumR, {Num1, Num2, Num3, Num4, L1, L2}) ->
        case DrumR#drum_role.zid of
            1 ->
                {NewNum, NewL1, NewL2} = ?IF(Num1>=?WAR_MAX, {Num1, L1, [DrumR|L2]}, {Num1+1, [DrumR|L1], L2}),
                {NewNum, Num2, Num3, Num4, NewL1, NewL2};
            2 ->
                {NewNum, NewL1, NewL2} = ?IF(Num2>=?WAR_MAX, {Num2, L1, [DrumR|L2]}, {Num2+1, [DrumR|L1], L2}),
                {Num1, NewNum, Num3, Num4, NewL1, NewL2};
            3 ->
                {NewNum, NewL1, NewL2} = ?IF(Num3>=?WAR_MAX, {Num3, L1, [DrumR|L2]}, {Num3+1, [DrumR|L1], L2}),
                {Num1, Num2, NewNum, Num4, NewL1, NewL2};
            4 ->
                {NewNum, NewL1, NewL2} = ?IF(Num4>=?WAR_MAX, {Num4, L1, [DrumR|L2]}, {Num4+1, [DrumR|L1], L2}),
                {Num1, Num2, Num3, NewNum, NewL1, NewL2};
            _ ->
                {Num1, Num2, Num3, Num4, L1, L2}
        end
    end,
    {_, _, _, _, Signs1, SignsR} = lists:foldl(F, {0, 0, 0, 0, [], []}, Signs0),
    spawn(fun()-> refuse_mail(SignsR,0) end),
    ReadyOut = [RoleId || #drum_role{rid=RoleId} <- SignsR],
    {Signs1, ReadyOut}.

%%谢绝人id
ready_out([],Ids)->Ids;
ready_out([#drum_role{rid=RoleId}|T],Ids)->
    ready_out(T,[RoleId|Ids]).

%%拒绝邮件
refuse_mail([],_N)->
    ignore;
refuse_mail(Signs, _N)->
    NowTime = utime:unixtime(),
    SignsMap = divide_role_by_node(Signs),
    FM = fun(Node, RoleList, Acc) ->
        LogList = [[Node, RoleID, Sid, Power, NowTime] ||#drum_role{rid  = RoleID, server_id = Sid, power = Power} <- RoleList],
        MailList = [RoleID ||#drum_role{rid  = RoleID} <- RoleList],
        lib_log_api:log_drum_refuce(LogList),
        mod_clusters_center:apply_cast(Node,?MODULE,refuse_mail_local,[MailList]),
        timer:sleep(200),
        Acc
    end,
    maps:fold(FM, 0, SignsMap).

refuse_mail_local(MailList)->
    NowTime = utime:unixtime(),
    LogList = [[RoleID, NowTime] ||RoleID <- MailList],
    lib_log_api:log_drum_refuce_mail(LogList),
    Title = utext:get(1370001),%%
    Content = utext:get(1370002),%%
    BackList = [{0,?DRUMITEM,1}],
    lib_mail_api:send_sys_mail(MailList, Title, Content, BackList).

%%计算当前期ID
get_id()->
    {{Y,M,D}, _} = calendar:local_time(),
    Y*10000+M*100+D.

%%往届战报集合
load_history()->
    WarRanks = case db:get_all(?SQL_DRUMRANK_GET) of
        [] ->
            [];
        Ranks when is_list(Ranks)  ->
            make_rank(Ranks,[]);
        _ ->
            []
    end,
    WarRanks.

make_rank([],WarRanks)->
    WarRanks;
make_rank([[Drumid,Zone,Rid,Name,Gname,ServerId,PForm,SNum,Rank,Vip,Power,Career]|Ranks],WarRanks)->
    RankRole = #rank_role{
        drum = Drumid,
        zone = Zone,
        rid  = Rid,
        name = Name,
        gname = Gname,
        server_id = ServerId,
        platform = binary_to_list(PForm),
        servernum = SNum,
        rank = Rank,
        vip = Vip,
        power = Power,
        career = Career
    },
    NWarRanks = case lists:keyfind(Drumid,1,WarRanks) of
        {_,DRanks}->
            NDranks = [RankRole|DRanks],
            lists:keyreplace(Drumid,1,WarRanks,{Drumid,NDranks});
        _->
            [{Drumid,[RankRole]}|WarRanks]
    end,
    make_rank(Ranks,NWarRanks).

%%加载报名数据
load_signs(DrumId)->
    NSigns = case db:get_all(?SQL_DRUMSIGN_GET) of
        [] ->
            [];
        Signs when is_list(Signs)  ->
            make_signs(Signs,DrumId,[]);
        _ ->
            []
    end,
    NSigns.
%% liuxl todo : figure增加picture字段
make_signs([],_,Signs)->
    Signs;
make_signs([[RoleId,ServerId,PForm,ServerNum,DrumID,Zid,Name,Picture,PicV,Lv,Career,Pow]|Signs],Did,NSigns)->
    case DrumID == Did of
        true->
            DRole = #drum_role{
                rid = RoleId,
                server_id = ServerId,
                node = ServerId,
                zid = Zid,
                platform = binary_to_list(PForm),
                server_num = ServerNum,
                figure  = #figure{name=Name, picture=Picture, picture_ver=PicV, lv=Lv, career = Career},
                power = Pow
            },
            make_signs(Signs,Did,[DRole|NSigns]);
        _->
            make_signs(Signs,Did,NSigns)
    end.

%%加载上届对战表
load_choose()->
    NChoose = case db:get_all(?SQL_DRUMRANK_RESULT_GET) of
        [] ->
            [];
        Choose when is_list(Choose)  ->
            make_choose(Choose,[]);
        _ ->
            []
    end,
    R = calc_choose(NChoose,4,[]),
    % util:errlog("M:~p L:~p Error:~p", [?MODULE, ?LINE, R]),
    R.

make_choose([],Choose)->
    Choose;
make_choose([[Zone,Act,Group,ServerId,PForm,ServerNum,Rid,Name,Picture,PicV,Lv,Career,Pow]|Choose],NChoose)->
    DRole = #drum_role{
        rid = Rid,
        zid = Zone,
        server_id = ServerId,
        platform = PForm,
        server_num = ServerNum,
        action = Act,
        group = Group,
        figure = #figure{name=Name, picture=Picture, picture_ver=PicV, lv=Lv, career=Career},
        power = Pow
    },
    make_choose(Choose,[DRole|NChoose]).

%%进行分区分场分组 [{zone, act_choose}]
calc_choose(_,0,Choose)->
    Choose;
calc_choose(Choose,Zone,NChoose)->
    ZChoose = [D||D<-Choose,D#drum_role.zid==Zone],
    NZChoose = calc_act_choose(ZChoose,[13,12,11,10,9],[],#{}),
    calc_choose(Choose,Zone-1,[{Zone,NZChoose}|NChoose]).

%%分轮次 act_choose : [{act, [{A,B},{A,B}]}]
calc_act_choose(_,[],AChoose,_)->
    AChoose;
calc_act_choose(ZChoose,[Act|Acts],NAChoose,WinMap)->
    AChoose = [D||D<-ZChoose,D#drum_role.action==Act],
    {ActGroup, NewWinMap} = cut_group(Act, AChoose, WinMap),
    calc_act_choose(ZChoose,Acts,[{Act, ActGroup}|NAChoose], NewWinMap).

%%分组
cut_group(_, [], WinMap)->
    {[], WinMap};
cut_group(Act, Choose, WinMap)->
    NextWinnerList = maps:get(Act+1, WinMap, []),
    GChoose = lists:foldl(fun(D,Args)->
        #drum_role{group=G}=D,
        case lists:keyfind(G,1,Args) of
            {_,Groups}->
                NGroups = case Groups of
                    {B}->
                        {B,D};
                    _->%%满员
                        Groups
                end,
                lists:keyreplace(G,1,Args,{G,NGroups});
            _->
                [{G,{D}}|Args]
        end
    end,[],Choose),
    ActGroup = [SubGroup||{_,SubGroup}<-GChoose],
    {NActGroup, WinnerList} = lists:foldl(fun(Item, {L, L2}) ->
        case Item of
            {#drum_role{rid = AId} = A} -> {[{A, AId}|L], [AId|L2]};
            {#drum_role{rid = AId} = A, #drum_role{rid = BId} = B} ->
                Winner = ?IF(lists:member(AId, NextWinnerList) == true, AId, BId),
                {[{A, B, Winner}|L], [AId, BId|L2]};
            _ -> {L, L2}
        end
    end, {[], []}, ActGroup),
    {NActGroup, maps:put(Act, WinnerList, WinMap)}.

% test()->
%     L=[#drum_role{power=100,lv=10},#drum_role{power=150,lv=10},#drum_role{power=100,lv=11},#drum_role{power=100,lv=9},#drum_role{power=90,lv=10}],
%     M = compare_data(L),
%     N = compare_rank(M,1,[]),
%     util:errlog("M:~p L:~p Error:~p", [?MODULE, ?LINE, {L,M,N}]).


% save_signs([])->
%     ignore;
% save_signs(Signs)->
%     Did = get_id(),
%     DataStrList = [format_bin_string(Did,Sign) || Sign <- Signs],
%     DataStrAll  = string:join(DataStrList, ", "),
%     SqlReplace  = io_lib:format(?SQL_DRUMWAR_SIGN_BATCH, [DataStrAll]),
%     db:execute(SqlReplace).

% format_bin_string(Did,Sign)->
%     #drum_role{
%         rid   = Uid,
%         figure = #figure{lv= Lv},
%         power = Pow
%     } = Sign,
%     io_lib:format(<<"('~s',~p,~w,~w)">>, [Uid,Did,Lv,Pow]).

%%只保存十期 旧的要把最早的一期删掉 写入最新一期
delete_overdue(DrumID,SignsR,History)->
    case length(History) >= 8 of
        true->
            History0 = lists:sort(fun(A,B)->{Ai,_}=A,{Bi,_}=B,Ai>=Bi end,History),
            {HistoryL,HistoryR} = lists:split(7,History0),
            delete_rank(HistoryR),
            insert_rank(SignsR),
            lists:keystore(DrumID,1,HistoryL,{DrumID,SignsR});
        _->
            insert_rank(SignsR),
            lists:keystore(DrumID,1,History,{DrumID,SignsR})
    end.

delete_rank([])->
    ignore;
delete_rank([{DrumID,_}|HistoryR])->
    db:execute(io_lib:format(?SQL_DRUMRANK_DEL,[DrumID])),
    delete_rank(HistoryR).

insert_rank([])->
    ignore;
insert_rank(SignsR)->
    DataStrList = [format_rank_bin_string(Sign) || Sign <- SignsR],
    DataStrAll  = string:join(DataStrList, ", "),
    SqlReplace  = io_lib:format(?SQL_DRUMWAR_RANK_BATCH, [DataStrAll]),
    db:execute(SqlReplace).

format_rank_bin_string(Sign)->
    #rank_role{
        drum = DrumID,
        zone = Zone,
        rid = RoleID,
        name = Name,
        gname = Gname,
        server_id = Sid,
        platform = PForm,
        servernum = Snum,
        rank = Rank,
        vip  = Vip,
        power = Pow,
        career = Career
    } = Sign,
    io_lib:format(<<"(~p,~p,~p,'~s','~s',~p,'~s',~p,~p,~p,~p,~p)">>, [DrumID,Zone,RoleID,Name,Gname,Sid,PForm,Snum,Rank,Vip,Pow,Career]).

%%匹配AI对手
match_ai([],Group,Signs,SeaCandidate)->
    {Group,Signs,SeaCandidate};
match_ai([Sign|OSigns],Group,NSigns,SeaCandidate)->
    NSign = Sign#drum_role{group=Group,ai=1,pos=1,calc_type=0},
    match_ai(OSigns,Group+1,[NSign|NSigns],[{NSign}|SeaCandidate]).

show_champion(_Bin,_Zid,[])->
    ignore;
show_champion(Bin,Zid,[Sign|Signs])->
    case Sign of
        #drum_role{node=Node,rid=RoleID,zid=Zid}->
            lib_role_drum:send_to_role(Node,RoleID,Bin);
        _->
            ignore
    end,
    show_champion(Bin,Zid,Signs).

%%海选赛理想值
ideal_value(1)->2048;
ideal_value(2)->1024;
ideal_value(3)->512;
ideal_value(4)->256;
ideal_value(5)->128;
ideal_value(6)->64;
ideal_value(7)->32;
ideal_value(8)->16.


add_guess(Zone,Act,Value,Guess)->
    NGuess = case lists:keyfind(Zone,1,Guess) of
        {_,ActGuess}->
            case lists:keyfind(Act,1,ActGuess) of
                {_,Groups}->
                    NGroups = [Value|Groups],
                    NActGuess = lists:keystore(Act,1,ActGuess,{Act,NGroups}),
                    lists:keystore(Zone,1,Guess,{Zone,NActGuess});
                _->
                    NGroups = [Value],
                    NActGuess = lists:keystore(Act,1,ActGuess,{Act,NGroups}),
                    lists:keystore(Zone,1,Guess,{Zone,NActGuess})
            end;
        _->
            NGroups = [Value],
            NActGuess = [{Act,NGroups}],
            lists:keystore(Zone,1,Guess,{Zone,NActGuess})
    end,
    NGuess.

%%竞猜结算
account_guess_result(Zone,Act,WDrumRole,LDrumRole,Choice)->
    spawn(fun() ->
        case lists:keyfind(WDrumRole#drum_role.rid, 1, Choice) of
            {Wid,GuessRoles}->
                handle_account_guess(GuessRoles, Zone, Act, Wid, WDrumRole, LDrumRole);
            _->
                ignore
        end
    end),
    spawn(fun() ->
        case lists:keyfind(LDrumRole#drum_role.rid, 1, Choice) of
            {Lid,LGuessRoles}->
                handle_account_guess(LGuessRoles, Zone, Act, Lid, WDrumRole, LDrumRole);
            _->ignore
        end
    end),
    ok.

%%竞猜失败
handle_account_guess(Roles, ZoneId, Act, SuprId, WinDrumRole, _LoseDrumRole)->
    % Title = utext:get(1370005),
    % Content = utext:get(1370006),
    F = fun({Node, RoleList}, Acc) ->
        RoleIdList = [ RoleId || {RoleId, _Type} <- RoleList],
        mod_clusters_center:apply_cast(Node, lib_role_drum, account_choice_result,[ZoneId, Act, SuprId, WinDrumRole#drum_role.rid, RoleIdList]),
        timer:sleep(100),
        Acc
    end,
    lists:foldl(F, 0, Roles).

% account_guess_fail_roles(_,_,[])-> ignore;
% account_guess_fail_roles(Title,Content,[{_Uid,Node,RoleID,_Type}|GuessRoles]) ->
%     mod_clusters_center:apply_cast(Node,?MODULE,account_guess_fail_local,[RoleID,Title,Content]),
%     account_guess_fail_roles(Title,Content,GuessRoles).

% account_guess_fail_local(RoleID,Title,Content)->
%     lib_mail_api:send_sys_mail([RoleID], Title, Content, []).

% account_guess_succ(Roles)->
%     F = fun(Node, RoleList, Acc) ->
%         mod_clusters_center:apply_cast(Node, ?MODULE, account_guess_succ_local,[RoleList]),
%         timer:sleep(100),
%         Acc
%     end,
%     maps:fold(F, 0, Roles).

% account_guess_succ_local(RoleList) ->
%     %Title = utext:get(1370005),
%     %Content = utext:get(1370007),
%     spawn(fun() ->
%         F = fun({_Uid, RoleId, Type}, Acc) ->
%             [_,Award] = get_award(Type),
%             lib_mail_api:send_sys_mail([RoleId], Title, Content, Award),
%             case Acc > 20 of
%                 true -> timer:sleep(200), 0;
%                 _ -> Acc + 1
%             end
%         end,
%         lists:foldl(F, 0, RoleList)
%     end),
%     ok.

get_award(Type)->
    case data_drumwar:get_choose(Type) of
        [{Cost,Reward}] -> [Cost,Reward];
        _ -> [[],[]]
    end.

%%回写对战结果
save_choose([])->
    ignore;
save_choose([{_Zid,AChoose}|Choose])->
    save_act_choose(AChoose),
    save_choose(Choose).

save_act_choose([])->
    ignore;
save_act_choose([{Act,GChoose}|AChoose])->
    save_group_choose(Act, GChoose),
    save_act_choose(AChoose).

save_group_choose(_Act, [])->
    ignore;
save_group_choose(Act, [Value|GChoose])->
    case Value of
        {DRole, _}->
            db_save_result(DRole#drum_role{action = Act});
        {DRoleA,DRoleB,_}->
            db_save_result(DRoleA#drum_role{action = Act}),
            db_save_result(DRoleB#drum_role{action = Act});
        _->
            ignore
    end,
    save_group_choose(Act, GChoose).

db_save_result(DRole)->
    #drum_role{
        rid = Uid,
        server_id = ServerId,
        platform = Pfrom,
        server_num = ServerNum,
        zid = Zone,
        figure = #figure{name=Name,picture=Pic,picture_ver=PicV,lv=Lv,career=Career},
        action = Act,
        group = Group,
        power = Pow
    } = DRole,
    %?PRINT("~p~n",[DRole]),
    Sql  = io_lib:format(?SQL_DRUMWAR_RESULT_INTERT, [Zone,Act,Group,ServerId,Pfrom,ServerNum,Uid,util:fix_sql_str(Name),Pic,PicV,Lv,Career,Pow]),
    db:execute(Sql).


%%决胜局 追加冠军
add_results([],_Signs,Choose)->
    Choose;
add_results([Uid|Wins],Signs,Choose)->
    NChoose = case lists:keyfind(Uid,#drum_role.rid,Signs) of
        DRole when is_record(DRole,drum_role) ->
            #drum_role{zid=Zone}=DRole,
            NDRole = DRole#drum_role{action=13,group=1},
            case lists:keyfind(Zone,1,Choose) of
                {_,AChoose}->
                    NAChoose = lists:keystore(13,1,AChoose,{13,[{NDRole, Uid}]}),
                    lists:keyreplace(Zone,1,Choose,{Zone,NAChoose});
                _->
                    NAChoose = [{13,[{NDRole, Uid}]}],
                    lists:keystore(Zone,1,Choose,{Zone,NAChoose})
            end;
        _->
            Choose
    end,
    add_results(Wins,Signs,NChoose).

%%命数广播 败给机器人
brocast_live(none,LUid,Signs)->
    case lists:keyfind(LUid,#drum_role.rid,Signs) of
        #drum_role{live=Fl,node=LNode,rid=LRid}->
            ignore;
        _->Fl=0,LNode=none,LRid=0
    end,
    {ok,FBin} = pt_137:write(13710,[Fl,1]),
    LRid /= 0 andalso lib_role_drum:send_to_role(LNode,LRid,FBin);
brocast_live(WUid,LUid,Signs)->
    case lists:keyfind(WUid,#drum_role.rid,Signs) of
        #drum_role{live=Wl,node=WNode,rid=WRid}->
            ignore;
        _->Wl=0,WNode=none,WRid=0
    end,
    case lists:keyfind(LUid,#drum_role.rid,Signs) of
        #drum_role{live=Fl,node=LNode,rid=LRid}->
            ignore;
        _->Fl=0,LNode=none,LRid=0
    end,
    {ok,WBin} = pt_137:write(13710,[Wl,Fl]),
    {ok,FBin} = pt_137:write(13710,[Fl,Wl]),
    WRid /= 0 andalso lib_role_drum:send_to_role(WNode,WRid,WBin),
    LRid /= 0 andalso lib_role_drum:send_to_role(LNode,LRid,FBin).

%'胜负类型1胜2负3轮空4超时'
log_drum_war(Type,DrumRole)->
    DrumID = get_id(),
    log_drum_war_local(Type,DrumID,DrumRole).
log_drum_war(WUid,LUid,Signs)->
    log_drum_war(1,WUid,LUid,Signs).
log_drum_war(Type,WUid,LUid,Signs)->
    DrumID = get_id(),
    {WDrum,_WNode}  = case lists:keyfind(WUid,#drum_role.rid,Signs) of
        false->{#drum_role{rid=0,figure=#figure{}},none};
        WR->{WR,WR#drum_role.node}
    end,
    {LDrum,_LNode}  = case lists:keyfind(LUid,#drum_role.rid,Signs) of
        false->{#drum_role{rid=0,figure=#figure{}},none};
        LR->{LR,LR#drum_role.node}
    end,
    log_drum_war_local(Type,DrumID,WDrum,LDrum).

log_drum_war_local(Type,DrumID,DrumRole)->
    #drum_role{
        rid = RoleID,
        zid  = Zone,
        action = War,
        figure = #figure{name=Name},
        server_id = ServerId,
        platform = Plat,
        server_num = Snum,
        power = Power,
        live = Live
    } = DrumRole,
    NameFix = util:fix_sql_str(Name),
    PlatFix = util:fix_sql_str(Plat),
    lib_log_api:log_drum_war(DrumID,Zone,War,RoleID,NameFix,ServerId,PlatFix,Snum,Live,Power,0,"",0,"",0,0,0,Type).
log_drum_war_local(Type,DrumID,WDrum,LDrum)->
    #drum_role{
        rid = WRoleID,
        zid  = WZone,
        action = WWar,
        figure = #figure{name=WName},
        server_id = WSId,
        platform = WPlat,
        server_num = WSnum,
        power = WPower,
        live = WLive
    }=WDrum,
    #drum_role{
        rid = LRoleID,
        figure = #figure{name=LName},
        server_id = LSId,
        platform = LPlat,
        server_num = LSnum,
        power = LPower,
        live = LLive
    }=LDrum,
    WNameFix = util:fix_sql_str(WName), WPlatFix = util:fix_sql_str(WPlat),
    LNameFix = util:fix_sql_str(LName), LPlatFix = util:fix_sql_str(LPlat),
    lib_log_api:log_drum_war(DrumID,WZone,WWar,WRoleID,WNameFix,WSId,WPlatFix,WSnum,WLive,WPower,LRoleID,LNameFix,LSId,LPlatFix,LSnum,LLive,LPower,Type).

test_sign(N,Act)->
    Signs = make_s(N,Act,[]),
    Total = compare_data(Signs),
    All = length(Total),
    Num = All-2*(All-ideal_value(Act)),  %%这部分人打AI
    {SignAi,SignsPk} = lists:split(Num,Total),
    util:errlog("M:~p, Msg:~p~n,MM:~p~n", [?MODULE, SignAi,SignsPk]).

make_s(0,_,Signs)->
    Signs;
make_s(N,Act,Signs)->
    D=#drum_role{rid=N,action=Act,power=util:rand(1000,9000),platform="4399",server_num=2,figure=#figure{lv=urand:rand(76,85)},online=1},
    make_s(N-1,Act,[D|Signs]).

%%模拟匹配
test_match(N,Act)->
    db:execute("TRUNCATE TABLE `log_drum_match`"),
    Signs = make_s(N,Act,[]),
    {Signs0,_} = calc_zones(Signs),
    L1 = length([D||D<-Signs0,D#drum_role.zid==1]),
    L2 = length([D||D<-Signs0,D#drum_role.zid==2]),
    L3 = length([D||D<-Signs0,D#drum_role.zid==3]),
    L4 = length([D||D<-Signs0,D#drum_role.zid==4]),
    io:format("~p~n",[{L1,L2,L3,L4}]),
    Signs1 = compare_data(Signs0),
    {NSigns,_} = calc_group(Signs1,Act),
    util:errlog("M:~p, Msg:~p~n,MM:~p~n", [?MODULE, Signs1, NSigns]).
    %%log_drum_match(NSigns).

%%战斗结算在前 所以拿对手玩家看看是不是晋级来判断剩余玩家是不是晋级
check_win(Act,Uid,Signs)->
     case lists:keyfind(Uid,#drum_role.rid,Signs) of
        #drum_role{ruid=Ruid}->
            case lists:keyfind(Ruid,#drum_role.rid,Signs) of
                #drum_role{action=CurAct} when CurAct>Act->
                    false; %%对手已晋级
                _->
                    true
            end;
        _->
            true
    end.

%%取消战区大战
cancel_zone([])->ok;
cancel_zone(Signs) ->
    SignsMap = divide_role_by_node(Signs),
    F = fun(Node, RoleList, Acc) ->
        RoleIds = [RoleId || #drum_role{rid = RoleId} <- RoleList],
        mod_clusters_center:apply_cast(Node,?MODULE,cancel_mail_local,[RoleIds]),
        Acc
    end,
    maps:fold(F, 0, SignsMap).

cancel_mail_local(RoleIds)->
    Title = utext:get(1370003),%%
    Content = utext:get(1370004),%%
    BackList = [{0,?DRUMITEM,1}],
    lib_mail_api:send_sys_mail(RoleIds, Title, Content, BackList).

divide_role_by_node(Signs) ->
    F = fun(DrumR, M) ->
        L = maps:get(DrumR#drum_role.node, M, []),
        maps:put(DrumR#drum_role.node, [DrumR|L], M)
    end,
    lists:foldl(F, #{}, Signs).

%% 协议打包
pack_13705(DrumRole) ->
    #drum_role{
        action = Act0, win = W, zid = ZoneId, lose = L, live = Live
    } = DrumRole,
    IsOut = ?IF(Live > 0, 0, 1),
    Act = ?IF(W > 0 orelse L > 0, Act0, 0),
    pt_137:write(13705, [IsOut, ZoneId, Act, W, L, Live]).

pack_13719(RoleDrum, CTime, Guess) ->
    #role_drum{zone = ZoneId, choice = Choice} = RoleDrum,
    %print_guess(13719, Guess),
    case lists:keyfind(ZoneId, 1, Guess) of
        {ZoneId, ZoneList} ->
            ?PRINT("pack_13719 ok ~n", []),
            F2 = fun({Act,Groups}, L2) ->
                F3 = fun(Value, L3) ->
                    case Value of
                        {DRole, Wid}->
                            #drum_role{
                                rid = Uid0, server_id=SerId0, server_num=SerNum0,
                                figure = #figure{name=Name0,lv=Lv0,picture=Pic0,picture_ver=PVer0,career=Career0},
                                power = Pow0
                            }=DRole,
                            [{0, Uid0, SerId0, SerNum0, Name0, Pic0, PVer0, Lv0, Career0, Pow0, 0, 0, 0, "", "", 0, 0, 0, 0, Wid}|L3];
                        {DRoleA,DRoleB,Wid}->
                            #drum_role{
                                rid = Uid0, server_id=SerId0, server_num=SerNum0,
                                figure = #figure{name=Name0,lv=Lv0,picture=Pic0,picture_ver=PVer0,career=Career0},
                                power = Pow0
                            }=DRoleA,
                            #drum_role{
                                rid = Uid1, server_id=SerId1, server_num=SerNum1,
                                figure = #figure{name=Name1,lv=Lv1,picture=Pic1,picture_ver=PVer1,career=Career1},
                                power = Pow1
                            }=DRoleB,
                            case [Suprid || #role_choice{zone = ZoneId1, action = Act1, suprid = Suprid} <- Choice, ZoneId1 == ZoneId andalso Act1 == Act andalso(Suprid==Uid0 orelse  Suprid==Uid1)] of
                                [SuprId|_] -> ok;
                                [] -> SuprId = 0
                            end,
                            [{SuprId, Uid0, SerId0, SerNum0, Name0, Pic0, PVer0, Lv0, Career0, Pow0, Uid1, SerId1, SerNum1, Name1, Pic1, PVer1, Lv1, Career1, Pow1, Wid}|L3];
                        _ ->
                            L3
                    end
                end,
                GroupListPt = lists:foldl(F3, [], Groups),
                [{Act, GroupListPt}|L2]
            end,
            InfoList = lists:foldl(F2, [], ZoneList);
        _ ->
            InfoList = []
    end,
    pt_137:write(13719, [CTime, InfoList]).

pack_13721(RoleChoiceList) ->
    F = fun(RoleChoice, L) ->
        #role_choice{
            zone = Zid, action = Act, suprid = SuprId, type = Type, reward_st = RewardSt, winner = Winner,
            arid = ARid, asid = AServerId, asnum = AServerNum, aname = AName, alv = ALv, asex = ASex, acareer = ACareer, apic = APic, apicver = APicVer, apower = APower,
            brid = BRid, bsid = BServerId, bsnum = BServerNum, bname = BName, blv = BLv, bsex = BSex, bcareer = BCareer, bpic = BPic, bpicver = BPicVer, bpower = BPower
        } = RoleChoice,
        PtInfo = {
            Zid, Act, SuprId, Type, RewardSt, Winner,
            ARid, AServerId, AServerNum, AName, ALv, ASex, ACareer, APic, APicVer, APower,
            BRid, BServerId, BServerNum, BName, BLv, BSex, BCareer,  BPic, BPicVer, BPower
        },
        [PtInfo|L]
    end,
    InfoList = lists:foldl(F, [], RoleChoiceList),
    pt_137:write(13721, [InfoList]).

pack_13722(RoleChoice) ->
    #role_choice{
        zone = Zid, action = Act, suprid = SuprId, type = Type, reward_st = RewardSt, winner = Winner,
        arid = ARid, asid = AServerId, asnum = AServerNum, aname = AName, alv = ALv, asex = ASex, acareer = ACareer, apic = APic, apicver = APicVer, apower = APower,
        brid = BRid, bsid = BServerId, bsnum = BServerNum, bname = BName, blv = BLv, bsex = BSex, bcareer = BCareer, bpic = BPic, bpicver = BPicVer, bpower = BPower
    } = RoleChoice,
    PtInfo = [
        Zid, Act, SuprId, Type, RewardSt, Winner,
        ARid, AServerId, AServerNum, AName, ALv, ASex, ACareer, APic, APicVer, APower,
        BRid, BServerId, BServerNum, BName, BLv, BSex, BCareer,  BPic, BPicVer, BPower
    ],
    pt_137:write(13722, PtInfo).

drum_enter(Signs) ->
    F = fun(#drum_role{server_id = ServerId, rid = RoleId}, List) ->
        case lib_clusters_center:get_node(ServerId) of
            undefined -> List;
            Node ->
                {_, L} = ulists:keyfind(Node, 1, List, {Node, []}),
                lists:keystore(Node, 1, List, {Node, [RoleId|L]})
        end
    end,
    ServerList = lists:foldl(F, [], Signs),
    lists:foreach(fun({Node, SingRoleList}) ->
        mod_clusters_center:apply_cast(Node, lib_role_drum, drum_enter, [SingRoleList])
    end, ServerList).


% print_signs(NSigns) ->
%     F = fun(#drum_role{rid=RoleId, zid=ZoneId, action=Action, online = Online}) ->
%         ?PRINT("sign role_id=~p, zone=~p, action=~p, online=~p ~n", [RoleId, ZoneId, Action, Online])
%     end,
%     lists:foreach(F, NSigns).

% print_signs_more(NSigns) ->
%     F = fun(#drum_role{rid=RoleId, zid = Zid, action=Action, group=Group, win = Win, lose = Lose, live = Live, ruid=RUid, online = Online}) ->
%         ?PRINT("sign role_id=~p, zid=~p, action=~p, group=~p, win=~p, lose=~p, live=~p, ruid=~p, online=~p ~n", [RoleId, Zid, Action, Group, Win, Lose, Live, RUid, Online])
%     end,
%     lists:foreach(F, NSigns).

% print_guess(Source, Guess) ->
%     ?PRINT("Source ================================== : ~p~n", [Source]),
%     print_guess(Guess).

% print_guess(Guess) ->
%     F = fun({Zone, ZoneList}) ->
%         ?PRINT("Zone ========= : ~p~n", [Zone]),
%         F1 = fun({Act, ValueList}) ->
%             ?PRINT("    Act ========= : ~p~n", [Act]),
%             F2 = fun(Value) ->
%                 case Value of
%                     {DRole, WinId}->
%                         #drum_role{
%                             rid = Uid0
%                         }=DRole,
%                         ?PRINT("    info ========= : ~p~n", [{Uid0, 0, WinId}]);
%                     {DRoleA,DRoleB, WinId}->
%                         #drum_role{
%                             rid = Uid0
%                         }=DRoleA,
%                         #drum_role{
%                             rid = Uid1
%                         }=DRoleB,
%                         ?PRINT("    info ========= : ~p~n", [{Uid0, Uid1, WinId}]);
%                     _ ->
%                         ok
%                 end
%             end,
%             lists:foreach(F2, ValueList)
%         end,
%         lists:foreach(F1, ZoneList)
%     end,
%     lists:foreach(F, Guess).
