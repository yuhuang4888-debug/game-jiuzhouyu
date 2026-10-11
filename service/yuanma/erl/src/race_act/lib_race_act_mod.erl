%%%------------------------------------
%%% @Module  : lib_race_act_mod
%%% @Author  : zengzy
%%% @Created : 2017-12-21
%%% @Description: 竞榜辅助函数
%%%------------------------------------
-module(lib_race_act_mod).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("race_act.hrl").
-include("predefine.hrl").
-include("chat.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("relationship.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("clusters.hrl").

-compile(export_all).
%% ---------------------------------- 初始化 -----------------------------------

make_record(race_act_zone, [ZoneId, Type, SubType, WorldLv]) ->
    #race_act_zone{key = {ZoneId, Type, SubType}, zone_id = ZoneId, type = Type, subtype = SubType, world_lv = WorldLv}.

%%进程初始化
init()->
    State1 = init_rank(),
    State2 = init_act(State1),
    StateAfZone = init_zone_list(State2),
    State3 = set_timer_to_close_act(StateAfZone),
    State4 = set_timer_to_start_act(State3),
    State5 = set_timer_to_show_act(State4),
    set_timer_to_zero_check(),
    State5.

%%初始活动
init_act(State)->
    KeyList = data_race_act:get_all_key_list(),
    AllInfo = [data_race_act:get_act_info(Type,SubType)||{Type,SubType}<-KeyList],
    {OpenAct,ShowAct} = lib_race_act_util:cluster_get_opening_act(AllInfo,[],[]),
    State#rank_status{all_act=AllInfo, opening_act=OpenAct, show_act=ShowAct}.

%% 初始区域
init_zone_list(#rank_status{opening_act=OpenAct, show_act=ShowAct} = State) ->
    Sql = io_lib:format(?sql_race_act_zone_selete, []),
    List = db:get_all(Sql),
    ZoneList = [make_record(race_act_zone, T)||T<-List],
    LoadAct = OpenAct++ShowAct,
    KeyList = [{Type, SubType}||#base_race_act_info{type = Type, sub_type = SubType}<-LoadAct],
    F = fun(#race_act_zone{type = Type, subtype = SubType}) -> lists:member({Type, SubType}, KeyList) end,
    {Satisfying, NotSatisfying} = lists:partition(F, ZoneList),
    EtsList = ets:tab2list(lib_zone:ets_main_zone_name(?ZONE_TYPE_1)),
    F2 = fun(#base_race_act_info{type = Type, sub_type = SubType}, {SumList, AddList}) ->
        F3 = fun(#ets_main_zone{zone_id = ZoneId, world_lv = WorldLv}, {SumListA, AddListA}) ->
            case lists:keymember({ZoneId, Type, SubType}, #race_act_zone.key, SumListA) of
                true -> {SumListA, AddListA};
                false ->
                    RaceActZone = make_record(race_act_zone, [ZoneId, Type, SubType, WorldLv]),
                    {[RaceActZone|SumListA], [RaceActZone|AddListA]}
            end
             end,
        lists:foldl(F3, {SumList, AddList}, EtsList)
         end,
    {NewZoneList, AddZoneList} = lists:foldl(F2, {Satisfying, []}, LoadAct),
    % 写数据库
    replace_race_act_zone(AddZoneList),
    log_race_act_zone(AddZoneList),
    % 清理数据
    NotKeyList = lists:usort([{Type, SubType}||#race_act_zone{type = Type, subtype = SubType}<-NotSatisfying]),
    spawn(fun() -> [db_delete_race_act_zone(Type, SubType)||{Type, SubType}<-NotKeyList] end),
    % ?MYLOG("hjh", "NewZoneList:~p ~n",  [NewZoneList]),
    % 同步数据到本服
    LocalList = packet_zone_list_to_local(NewZoneList, []),
    [mod_zone_mgr:apply_cast_to_zone2(?ZONE_TYPE_1, ZoneId, mod_race_act_local, sync_update, [TmpList])||
        {ZoneId, TmpList}<-LocalList, TmpList=/= []],
    State#rank_status{zone_list = NewZoneList}.

%% 增加开启的活动
add_open_act_for_zone(#rank_status{zone_list = ZoneList} = State, OpenList) ->
    EtsList = ets:tab2list(lib_zone:ets_main_zone_name(?ZONE_TYPE_1)),
    F2 = fun(#base_race_act_info{type = Type, sub_type = SubType}, {SumList, AddList}) ->
        F3 = fun(#ets_main_zone{zone_id = ZoneId, world_lv = WorldLv}, {SumListA, AddListA}) ->
            case lists:keymember({ZoneId, Type, SubType}, #race_act_zone.key, SumListA) of
                true -> {SumListA, AddListA};
                false ->
                    RaceActZone = make_record(race_act_zone, [ZoneId, Type, SubType, WorldLv]),
                    {[RaceActZone|SumListA], [RaceActZone|AddListA]}
            end
             end,
        lists:foldl(F3, {SumList, AddList}, EtsList)
         end,
    {NewZoneList, AddZoneList} = lists:foldl(F2, {ZoneList, []}, OpenList),
    % 写数据库
    replace_race_act_zone(AddZoneList),
    LocalList = packet_zone_list_to_local(AddZoneList, []),
    [mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, mod_race_act_local, sync_update, [TmpList])||
        {ZoneId, TmpList}<-LocalList, TmpList=/= []],
    State#rank_status{zone_list = NewZoneList}.

packet_zone_list_to_local([], List) -> List;
packet_zone_list_to_local([#race_act_zone{zone_id = ZoneId, type = Type, subtype = SubType, world_lv = WorldLv}|ZoneList], List) ->
    case lists:keyfind(ZoneId, 1, List) of
        false -> packet_zone_list_to_local(ZoneList, [{ZoneId, [{{Type, SubType}, WorldLv}]}|List]);
        {ZoneId, OldList} -> packet_zone_list_to_local(ZoneList, [{ZoneId, [{{Type, SubType}, WorldLv}|OldList]}|List])
    end.

%% 增加开启的活动
del_act_for_zone(State, [], _ShowAct) -> State;
del_act_for_zone(#rank_status{zone_list = ZoneList} = State, DelAct, ShowAct) ->
    DelKeyList = [{Type, SubType}||#base_race_act_info{type = Type, sub_type = SubType} = ActInfo <-DelAct, lists:member(ActInfo, ShowAct) == false],
    spawn(fun() -> [db_delete_race_act_zone(Type, SubType)||{Type, SubType}<-DelKeyList] end),
    NewZoneList = [Zone||#race_act_zone{type = Type, subtype = SubType}=Zone<-ZoneList, lists:member({Type,SubType}, DelKeyList)],
    State#rank_status{zone_list = NewZoneList}.

%%初始榜单
init_rank()->
    Sql = io_lib:format(?sql_race_act_rank_select,[]),
    State1 = case db:get_all(Sql) of
                 []-> #rank_status{};
                 List->
                     RankList = make_mod_rank(List,[]),
                     NRankList = sort_all_type_rank(RankList,[]),
                     #rank_status{rank_list=NRankList}
             end,
    State1.

%%组合进程榜单
make_mod_rank([],List)->List;
make_mod_rank([RoleInfo|T],List) ->
    [RoleId,Type,SubType,ServerId,Form,ServerNum,Name,MaskId,Score,Time] = RoleInfo,
    PForm = binary_to_list(Form),
    RankRole = #rank_role{
        node=ServerId,id=RoleId,server_id=ServerId,
        platform=PForm,server_num=ServerNum,
        score=Score,figure=#figure{name=Name, mask_id=MaskId},last_time=Time
    },
    NList = make_data_rank(Type,SubType,List,RankRole),
    make_mod_rank(T,NList).

%%组合类型榜单
make_data_rank(Type,SubType,List,RankRole)->
    TypeKey = {Type,SubType},
    #rank_role{server_id=ServerId} = RankRole,
    Zone = get_zone(Type,SubType,ServerId),
    RankType = lists:keyfind(TypeKey,#rank_type.id,List),
    if
        Zone == false -> List;
        RankType == false ->
            RankList = [RankRole],
            RankData = [#rank_data{id=Zone,rank_list=RankList}],
            NRankType = #rank_type{id=TypeKey,type=Type,subtype=SubType,rank_data=RankData},
            lists:keystore(TypeKey,#rank_type.id,List,NRankType);
        true->
            #rank_type{rank_data=DataList} = RankType,
            ZoneKey = Zone,
            case lists:keyfind(ZoneKey,#rank_data.id,DataList) of
                false->
                    RankList = [RankRole],
                    RankData = #rank_data{id=ZoneKey,rank_list=RankList},
                    NDataList = lists:keystore(ZoneKey,#rank_data.id,DataList,RankData);
                #rank_data{rank_list=RankList} = RankData ->
                    NRankList = [RankRole|RankList],
                    NRankData = RankData#rank_data{rank_list=NRankList},
                    NDataList = lists:keystore(ZoneKey,#rank_data.id,DataList,NRankData)
            end,
            NRankType = RankType#rank_type{rank_data=NDataList},
            lists:keystore(TypeKey,#rank_type.id,List,NRankType)
    end.

%%所有排行重新排
sort_all_type_rank([],List)->List;
sort_all_type_rank([RankType|T],List) ->
    #rank_type{type=Type,subtype=SubType,rank_data=RankData} = RankType,
    IsClear = is_clear(Type,SubType),
    case IsClear == false of
        true->
            NRankData = sort_type_rank(RankData,Type,SubType,[]),
            NRankType = RankType#rank_type{rank_data=NRankData},
            sort_all_type_rank(T,[NRankType|List]);
        false->
            ?INFO("delete ~p:~p~n",[Type,SubType]),
            Sql = io_lib:format(<<"delete from `race_act_rank` where type=~p and subtype=~p">>,[Type,SubType]),
            db:execute(Sql),
            % %%通知本地删除对应类型db
            % mod_clusters_center:apply_to_all_node(?MODULE, act_close_broadcast, [Type,SubType], 100),
            sort_all_type_rank(T,List)
    end.

%%各活动类型内排
sort_type_rank([],_Type,_SubType,RankData)->RankData;
sort_type_rank([#rank_data{rank_list=RankList}=Data|T],Type,SubType,RankData) ->
    NRankList = sort_rank_role(RankList),
    LRankList = set_rank(NRankList,Type,SubType,1,[]),
    Max = get_rank_max(Type,SubType),
    {LastRankList,LastScore} = get_limit_score(Type,SubType,LRankList,Max),
    NData = Data#rank_data{rank_list = LastRankList,score_limit=LastScore},
    sort_type_rank(T,Type,SubType,[NData|RankData]).

% %%组合区
% make_mod_zone([],ServerMap,ZoneList)->{ServerMap,ZoneList};
% make_mod_zone([[ServerId,Zone]|T],ServerMap,ZoneList)->
%   NServerMap = maps:put(ServerId,Zone,ServerMap),
%   NZoneList = case lists:keyfind(Zone,1,ZoneList) of
%       false ->[{Zone,[ServerId]}|ZoneList];
%       {Zone,OList}->
%           case lists:member(ServerId,OList) of
%               true-> ZoneList;
%               false-> lists:keystore(Zone,1,ZoneList,{Zone,[ServerId|OList]})
%           end
%   end,
%   make_mod_zone(T,NServerMap,NZoneList).

%% ---------------------------------- 初始化end -----------------------------------

%% ---------------------------------- 活动开启关闭相关 -----------------------------------

%%关闭活动定时器
set_timer_to_close_act(State) ->
    #rank_status{opening_act=OpenAct, end_timer=ORef} = State,
    util:cancel_timer(ORef),
    Now = utime:unixtime(),
    F = fun(ActInfo,EList)->
        #base_race_act_info{end_time=EndTime} = ActInfo,
        case Now < EndTime of
            true-> [EndTime|EList];
            false-> EList
        end
        end,
    EndList = lists:foldl(F,[],OpenAct),
    ?PRINT("~p~n",[EndList]),
    %%开启关闭活动定时器
    case EndList == [] of
        true-> State;
        false->
            SortList = lists:sort(EndList),
            ETime = hd(SortList),
            RefTime = max(ETime-Now+5,10),
            Ref = erlang:send_after(RefTime*1000, self(), {close_act}),
            State#rank_status{end_timer=Ref}
    end.

%%开启活动定时器
set_timer_to_start_act(State)->
    #rank_status{opening_act=OpenAct, all_act=AllAct, start_timer=ORef} = State,
    util:cancel_timer(ORef),
    Now = utime:unixtime(),
    F = fun(ActInfo,SList)->
        #base_race_act_info{start_time=StartTime} = ActInfo,
        IsOpen = lists:member(ActInfo, OpenAct),
        case Now < StartTime andalso IsOpen == false of
            true-> [StartTime|SList];
            false-> SList
        end
        end,
    StartList = lists:foldl(F,[],AllAct),
    ?PRINT("~p~n",[StartList]),
    %%开启关闭活动定时器
    case StartList == [] of
        true-> State;
        false->
            SortList = lists:sort(StartList),
            STime = hd(SortList),
            RefTime = max(STime-Now+6,10),
            Ref = erlang:send_after(RefTime*1000, self(), {open_act}),
            State#rank_status{start_timer=Ref}
    end.

%%展示活动关闭定时器
set_timer_to_show_act(State)->
    #rank_status{show_act=ShowAct, show_timer=ORef} = State,
    util:cancel_timer(ORef),
    Now = utime:unixtime(),
    F = fun(ActInfo,EList)->
        #base_race_act_info{end_time=EndTime} = ActInfo,
        [EndTime+86400|EList]
    % case lib_race_act_util:cluster_check_act_show(ActInfo) of
    %   true-> [EndTime+86400|EList];
    %   false-> EList
    % end
        end,
    EndList = lists:foldl(F,[],ShowAct),
    ?PRINT("~p~n",[EndList]),
    case EndList == [] of
        true-> State;
        false->
            SortList = lists:sort(EndList),
            ETime = hd(SortList),
            RefTime = max(ETime-Now+4,10),
            Ref = erlang:send_after(RefTime*1000, self(), {close_show_act}),
            State#rank_status{show_timer=Ref}
    end.

%%定时关闭活动
close_act(State)->
    #rank_status{opening_act=OpenAct,rank_list=RankList,show_act=ShowAct,zone_list=ZoneList} = State,
    Now = utime:unixtime(),
    {DelAct, NewOpeningAct, AddShow, NewShowAct} = do_close_act(OpenAct, Now, [], OpenAct, [], ShowAct),
    case DelAct == [] of
        true-> ok;
        false->
            %%通知活动（跨服量多）
            % lib_race_act:broadcast_act_list(NewOpeningAct),
            spawn(fun() ->
                db_delete_act(DelAct,AddShow,0),
                % broadcast_act_list(),
                handle_close_act(DelAct,RankList,ZoneList)
                  end)
    end,
    ?PRINT("~p:~p:~p~n",[DelAct,NewOpeningAct,AddShow]),
    NRankList = delete_act_rank(RankList,DelAct,AddShow),
    StateTemp = State#rank_status{opening_act = NewOpeningAct, show_act = NewShowAct, rank_list=NRankList},
    NewState = set_timer_to_close_act(StateTemp),
    case AddShow == [] of
        true-> LastState = NewState;
        false-> LastState = set_timer_to_show_act(NewState)
    end,
    StateAfZone = del_act_for_zone(LastState, DelAct, AddShow),
    {noreply,StateAfZone}.

do_close_act([],_Now,DelAct,OpenAct,AddShow,ShowAct)->{DelAct,OpenAct,AddShow,ShowAct};
do_close_act([ActInfo|T],Now,DelAct,OpenAct,AddShow,ShowAct)->
    #base_race_act_info{type = Type, sub_type = SubType} = ActInfo,
    %% 判断是否需要关闭活动
    case lib_race_act_util:is_cluster_open(Type, SubType) of
        ?OPEN ->
            %%没结束
            do_close_act(T, Now, DelAct, OpenAct, AddShow, ShowAct);
        ?CLOSE ->
            %%结束
            NOpenAct = lists:delete(ActInfo, OpenAct),
            case lib_race_act_util:cluster_check_act_show(ActInfo) of
                true-> do_close_act(T, Now, [ActInfo | DelAct], NOpenAct, [ActInfo|AddShow], [ActInfo|lists:delete(ActInfo,ShowAct)]);
                false-> do_close_act(T, Now, [ActInfo | DelAct], NOpenAct, AddShow, ShowAct)
            end
    end.

%%活动结束结算
handle_close_act([],_,_)->ok;
handle_close_act([ActInfo|T],RankList,ZoneList)->
    #base_race_act_info{type = Type, sub_type = SubType} = ActInfo,
    Key = {Type,SubType},
    case lists:keyfind(Key,#rank_type.id,RankList) of
        false-> handle_close_act(T,RankList,ZoneList);
        #rank_type{rank_data=DataList} ->
            %%执行奖励
            spawn(fun()-> act_zone_rank_reward(DataList,Type,SubType,ZoneList) end),
            handle_close_act(T,lists:keydelete(Key,#rank_type.id,RankList),ZoneList)
    end.

%%发放区排名奖励
act_zone_rank_reward([],_Type,_SubType,_ZoneList) -> ok;
act_zone_rank_reward([#rank_data{rank_list=RankList}|T],Type,SubType, ZoneList) ->
    timer:sleep(100),
    NRankList = sort_rank_role(RankList),
    NRankList1 = set_rank(NRankList,Type,SubType,1,[]),
    Max = get_rank_max(Type,SubType),
    NRankList2 = lists:sublist(NRankList1,Max),
    {NRankList3,_} = get_limit_score(Type,SubType,NRankList2,Max),
    act_rank_reward(NRankList3,Type,SubType,ZoneList),
    act_zone_rank_reward(T,Type,SubType,ZoneList).

%%发放排名奖励
act_rank_reward([],_Type,_SubType,_ZoneList)-> ok;
% act_rank_reward(RoleList,Type,SubType) when Type == ?RACE_ACT_DONATION ->
%     F = fun(#rank_role{rank=Rank,id=RoleId,node=Node}, Map) ->
%         OList = maps:get(Node, Map, []),
%         maps:put(Node, [{RoleId, Rank}|OList], Map)
%     end,
%     NodeMap = lists:foldl(F, #{}, RoleList),
%     FMap = fun(Node, RoleRankList, Acc) ->
%         mod_clusters_center:apply_cast(Node,lib_donation,rank_reward,[{Type, SubType, RoleRankList}]), Acc
%     end,
%     maps:fold(FMap, 0, NodeMap);
act_rank_reward([#rank_role{rank=Rank,id=RoleId,node=Node,server_id=ServerId,figure=#figure{name=Name},score=Score}|T],Type,SubType,ZoneList)->
    %%发送邮件
    RewardId = data_race_act:get_rank_reward_id(Type,SubType,Rank),
    case data_race_act:get_rank_reward(Type,SubType,RewardId) of
        []-> act_rank_reward(T,Type,SubType,ZoneList);
        #base_race_act_rank_reward{} = BaseReward ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            case lists:keyfind({ZoneId,Type,SubType}, #race_act_zone.key, ZoneList) of
                false ->
                    ?ERR("act_rank_reward ServerId:~p ZoneId:~p Type:~p SubType:~p ~n", [ServerId, ZoneId, Type, SubType]),
                    WorldLv = 0;
                #race_act_zone{world_lv = WorldLv} ->
                    ok
            end,
            Reward = lib_race_act:count_act_reward(#race_act_reward_param{world_lv = WorldLv}, BaseReward),
            lib_log_api:log_race_act_rank_reward(RoleId, Name, ZoneId, ServerId, Type, SubType, Score, Rank, Reward, WorldLv),
            timer:sleep(500),
            mod_clusters_center:apply_cast(Node,?MODULE,rank_reward,[Type,SubType,RoleId,Score,Rank,Reward]),
            act_rank_reward(T,Type,SubType,ZoneList)
    end.

%%邮件奖励
%% TODO:hjh
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_TCRANE ->
%     Title = utext:get(330),
%     Content = utext:get(331,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_WISH ->
%     Title = utext:get(334),
%     Content = utext:get(335,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_HERO ->
%     Title = utext:get(344),
%     Content = utext:get(345,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_FASHION ->
%     Title = utext:get(352),
%     Content = utext:get(353,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_DRAGON ->
%     Title = utext:get(354),
%     Content = utext:get(355,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_THORSE ->
%     Title = utext:get(367),
%     Content = utext:get(368,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_TWEAPON ->
%     Title = utext:get(391),
%     Content = utext:get(392,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(Type,RoleId,Rank,Reward) when Type == ?RACE_ACT_GOD ->
%     Title = utext:get(404),
%     Content = utext:get(405,[Rank]),
%   lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
% rank_reward(,_,_,_) ->
%     ok.

%% 发送榜单奖励
rank_reward(Type, SubType, RoleId, Score, Rank, Reward) ->
    case data_race_act:get_act_info(Type, SubType) of
        [] -> skip;
        #base_race_act_info{name = Name, others = Others} ->
            case lists:keyfind(rank_mail, 1, Others) of
                {rank_mail, {TitleId, ContentId}} ->
                    Title = utext:get(TitleId, [Name]),
                    Content = utext:get(ContentId, [Name, Rank]);
                _ ->
                    Title = utext:get(3380001, [Name]),
                    Content = utext:get(3380002, [Name, Rank])
            end,
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
            %% 使魔信息更新
            lib_demons_api:race_act_end(RoleId, Type, SubType, Score, Rank, Reward)
    end,
    ok.

%%定时开启活动
open_act(State)->
    #rank_status{all_act=AllAct,opening_act=OpenAct} = State,
    Now = utime:unixtime(),
    {AddAct, NewOpeningAct} = do_open_act(AllAct,OpenAct, Now, []),
    case AddAct == [] of
        true-> ok;
        false-> ok
        %%通知活动（跨服量多）
        % spawn(fun()-> broadcast_act_list(NewOpeningAct) end)
        % lib_race_act:broadcast_act_list(NewOpeningAct)
    end,
    StateTemp = State#rank_status{opening_act = NewOpeningAct},
    NewState0 = set_timer_to_start_act(StateTemp),

    NewState = sure_act_end(NewState0),

    case AddAct == [] of
        true-> LastState = NewState;
        false -> LastState = set_timer_to_close_act(NewState)
    end,
    case AddAct == [] of
        true -> StateAfZone = LastState;
        false -> StateAfZone = add_open_act_for_zone(LastState, AddAct)
    end,
    {noreply,StateAfZone}.

do_open_act([], OpenAct, _Now, AddAct) -> {AddAct, OpenAct};
do_open_act([ActInfo | T], OpenAct, Now, AddAct) ->
    #base_race_act_info{type = Type, sub_type = SubType} = ActInfo,
    case is_member(ActInfo, OpenAct) of
        true ->
            %% 已经在开启中了
            do_open_act(T, OpenAct, Now, AddAct);
        false ->
            case lib_race_act_util:is_cluster_open(Type, SubType) of
                ?OPEN ->
                    NewOpeningAct = [ActInfo | OpenAct],
                    do_open_act(T, NewOpeningAct, Now, [ActInfo | AddAct]);
                _ ->
                    do_open_act(T, OpenAct, Now, AddAct)
            end
    end.

%% 确保结算定时器执行前结算活动## yy3d_tw 出过一次未结算问题添加#时间戳问题导致
%% 开启活动定时器先执行，取消了结算定时器#极低概率
sure_act_end(#rank_status{end_timer=EndRef} = State) when is_reference(EndRef) ->
    case catch erlang:read_timer(EndRef) of
        {'EXIT', _} -> State;
        false -> State;
        Integer when is_integer(Integer) andalso Integer < 20 ->
            {_, NewState} = close_act(State),
            NewState#rank_status{end_timer=util:cancel_timer(EndRef)};
        _ -> State
    end;
sure_act_end(State) -> State.

%%定时关闭展示活动
close_show_act(State)->
    #rank_status{show_act=ShowAct,rank_list=RankList} = State,
    Now = utime:unixtime(),
    {DelAct, NewShowAct} = do_close_show_act(ShowAct, Now, [], ShowAct),
    case DelAct == [] of
        true-> ok;
        false->
            %%通知活动（跨服量多）
            spawn(fun()->
                db_delete_act(DelAct,[],0)
                  end)
    end,
    ?PRINT("~p:~p~n",[DelAct,NewShowAct]),
    NRankList = delete_act_rank(RankList,DelAct,[]),
    StateTemp = State#rank_status{show_act = NewShowAct, rank_list=NRankList},
    NewState = set_timer_to_show_act(StateTemp),
    StateAfZone = del_act_for_zone(NewState, DelAct, []),
    {noreply,StateAfZone}.

do_close_show_act([], _Now, DelAct, ShowAct) -> {DelAct, ShowAct};
do_close_show_act([ShowInfo | T], Now, DelAct, ShowAct) ->
    #base_race_act_info{end_time=EndTime} = ShowInfo,
    case EndTime+86400>Now of
        true-> do_close_show_act(T,Now,DelAct,ShowAct);
        false-> do_close_show_act(T,Now,[ShowInfo|DelAct],lists:delete(ShowInfo,ShowAct))
    end.

%%活动结束删除排行榜
delete_act_rank(RankList,[],_)->RankList;
delete_act_rank(RankList,[ActInfo|T],ShowAct)->
    case lists:member(ActInfo,ShowAct) of
        true-> delete_act_rank(RankList,T,ShowAct);
        false->
            #base_race_act_info{type=Type,sub_type=SubType} = ActInfo,
            NRankList = lists:keydelete({Type,SubType},#rank_type.id,RankList),
            delete_act_rank(NRankList,T,ShowAct)
    end.

%%删除db数据
db_delete_act([],_,_)->ok;
db_delete_act([ActInfo|T],ShowAct,N)->
    case lists:member(ActInfo,ShowAct) of
        true-> db_delete_act(T,ShowAct,N);
        false->
            case N>=5 of
                true-> timer:sleep(100),NewN=0;
                false-> NewN = N+1
            end,
            #base_race_act_info{type=Type,sub_type=SubType} = ActInfo,
            Sql = io_lib:format(<<"delete from `race_act_rank` where type=~p and subtype=~p">>,[Type,SubType]),
            db:execute(Sql),
            %%通知本地删除对应类型db
            mod_clusters_center:apply_to_all_node(?MODULE, act_close_broadcast, [Type,SubType], 100),
            db_delete_act(T,ShowAct,NewN)
    end.

%%开启零点检测定时器
set_timer_to_zero_check()->
    ORef = get({?MODULE,zero_check}),
    util:cancel_timer(ORef),
    {_, {H,Min,S}} = calendar:local_time(),
    PassTime = H*3600 + Min*60 + S,
    %%零点过后5分钟检测
    RefTime = ?ONE_DAY_SECONDS+10 - PassTime,
    Ref = erlang:send_after(RefTime*1000, self(), {zero_check}),
    put({?MODULE,zero_check},Ref).

%%零点检测数据
zero_check(State) ->
    set_timer_to_zero_check(),
    #rank_status{rank_list=RankList} = State,
    {NRankList,DelAct} = zero_check_help(RankList,[],[]),
    % ?PRINT("~p:~p:~p~n",[NRankList,RankList,DelAct]),
    db_delete_act(DelAct,[],0),
    NewState = State#rank_status{rank_list=NRankList},
    KeyList = data_race_act:get_all_key_list(),
    AllInfo = [data_race_act:get_act_info(Type,SubType)||{Type,SubType}<-KeyList],
    NewState1 = NewState#rank_status{all_act=AllInfo},
    StateAfZone = del_act_for_zone(NewState1, DelAct, []),
    open_act(StateAfZone).
% {noreply,NewState}.

zero_check_help([],List,DelList) -> {List,DelList};
zero_check_help([RankType|T],List,DelList) ->
    #rank_type{type=Type,subtype=SubType} = RankType,
    IsClear = is_clear(Type,SubType),
    case IsClear == false of
        true-> zero_check_help(T,[RankType|List],DelList);
        false->
            ?INFO("zero_check_help~p:~p~n",[Type,SubType]),
            ActInfo = data_race_act:get_act_info(Type,SubType),
            zero_check_help(T,List,[ActInfo|DelList])
    end.

%%true删除 false不删除
is_clear(Type,SubType)->
    ActInfo = data_race_act:get_act_info(Type,SubType),
    case ActInfo == [] of
        true-> true;
        false->
            Open = lib_race_act_util:is_cluster_open(Type,SubType),
            IsShow = lib_race_act_util:cluster_check_act_show(ActInfo),
            IsOpen = Open == ?OPEN,
            %%判断IsOpen没开并且IsShow没展示
            IsOpen =/= true andalso IsShow =/= true
    end.

is_member(_ActInfo, []) -> false;
is_member(#base_race_act_info{type=Type, sub_type=SubType}, [#base_race_act_info{type=Type, sub_type=SubType}|_T]) -> true;
is_member(ActInfo, [_H|T]) -> is_member(ActInfo, T).

%% ---------------------------------- 活动开启关闭相关end -----------------------------------

%% ---------------------------------- 进榜 -----------------------------------

%%进榜检测
enter_rank([Type,SubType,RankRole],State)->
    #rank_status{rank_list=RankList} = State,
    #rank_role{id=RoleId,server_id=ServerId,score=Score,figure=#figure{name=Name}} = RankRole,
    case check_enter_rank(Score,Type,SubType) of
        false-> NState = State;
        {RankMin,RankMax}->
            Key = {Type,SubType},
            ZoneId = get_zone(Type,SubType,ServerId),
            RankType = lists:keyfind(Key,#rank_type.id,RankList),
            if
                ZoneId == false -> NState = State;
                RankType == false->
                    RList = [RankRole#rank_role{rank=RankMin}],
                    RankData = [#rank_data{id=ZoneId,rank_list=RList}],
                    NRankType = #rank_type{id={Type,SubType},type=Type,subtype=SubType,rank_data=RankData},
                    NRankList = lists:keystore(Key,#rank_type.id,RankList,NRankType),
                    lib_race_act_util:db_rank_replace(Type,SubType,RankRole),
                    lib_race_act_util:log_rank(RoleId,Name,Type,SubType,Score,RankMin,ZoneId,ServerId),
                    NState = State#rank_status{rank_list=NRankList};
                true->
                    NRankType = act_enter_rank(Type,SubType,ZoneId,RankRole,RankMin,RankMax,RankType),
                    NRankList = lists:keystore(Key,#rank_type.id,RankList,NRankType),
                    NState = State#rank_status{rank_list=NRankList}
            end
    end,
    NState.

%%检测分数是否能进榜
check_enter_rank(Score,Type,SubType)->
    Id = data_race_act:get_enter_rank_list_id(Type,SubType,Score),
    case Id == [] of
        true->false;
        false->
            #base_race_act_rank_reward{rank_min=RankMin,rank_max=RankMax} = data_race_act:get_rank_reward(Type,SubType,Id),
            {RankMin,RankMax}
        % RankList = [data_race_act:get_rank_reward(Type,SubType,Id)||Id<-List],
        % List1 = [{RankMin,RankMax}||#base_race_act_rank_reward{rank_min=RankMin,rank_max=RankMax}<-RankList],
        % SortList = lists:keysort(1,List1),
        % hd(SortList)
    end.

%%执行进榜
act_enter_rank(Type,SubType,ZoneId,RankRole,RankMin,_RankMax,RankType)->
    #rank_type{rank_data=DataList} = RankType,
    #rank_role{id=RoleId,score=Score,server_id=ServerId,figure=#figure{name=Name}} = RankRole,
    Key = ZoneId,
    Data = get_type_rank_list(Key,DataList),
    Max = get_rank_max(Type,SubType),
    if
        Data == [] -> %%无人上榜，直接RankMin
            NRankList = [RankRole#rank_role{rank=RankMin}],
            NData = #rank_data{id=Key,rank_list=NRankList},
            lib_race_act_util:db_rank_replace(Type,SubType,RankRole),
            lib_race_act_util:log_rank(RoleId,Name,Type,SubType,Score,RankMin,ZoneId,ServerId),
            NDataList = lists:keystore(Key,#rank_data.id,DataList,NData);
        length(Data#rank_data.rank_list)>=Max andalso Score=<Data#rank_data.score_limit -> %%榜满人并且比最后一名还低分不计算
            NDataList = DataList;
        true -> %%上榜
            #rank_data{rank_list=RankList1} = Data,
            RankList = lists:keydelete(RoleId,#rank_role.id,RankList1),
            % case lists:keyfind(RankMin,#rank_role.rank,RankList) of
            %   false-> %%上榜直接RankMin
            %       lib_race_act_util:db_rank_replace(Type,SubType,RankRole),
            %       NRankList = [RankRole#rank_role{rank=RankMin}|RankList],
            %       lib_race_act_util:log_rank(RoleId,Name,Type,SubType,Score,RankMin,ZoneId,ServerId),
            %       NData = Data#rank_data{rank_list=NRankList};
            %   _-> %%RankMin有人，重新排
            TmpRankList = sort_rank_role([RankRole|RankList]),
            NRankList1 = set_rank(TmpRankList,Type,SubType,1,[]),
            case length(NRankList1)>=Max of
                true->
                    {NRankList,LastScore} = get_limit_score(Type,SubType,NRankList1,Max),
                    %%判断是否入库
                    case lists:keyfind(RoleId,#rank_role.id,NRankList) of
                        false-> ok;
                        #rank_role{rank=Rank}->
                            lib_race_act_util:log_rank(RoleId,Name,Type,SubType,Score,Rank,ZoneId,ServerId),
                            lib_race_act_util:db_rank_replace(Type,SubType,RankRole)
                    end,
                    NData = Data#rank_data{rank_list=NRankList,score_limit=LastScore};
                false->
                    case lists:keyfind(RoleId,#rank_role.id,NRankList1) of
                        false-> ok;
                        #rank_role{rank=Rank}->
                            lib_race_act_util:log_rank(RoleId,Name,Type,SubType,Score,Rank,ZoneId,ServerId)
                    end,
                    lib_race_act_util:db_rank_replace(Type,SubType,RankRole),
                    NData = Data#rank_data{rank_list=NRankList1}
            end,
            % end,
            NDataList = lists:keystore(Key,#rank_data.id,DataList,NData)
    end,
    RankType#rank_type{rank_data=NDataList}.

%%设置排名
set_rank([],_Type,_SubType,_InitRank,List)->lists:reverse(List);
set_rank([RankRole|T],Type,SubType,InitRank,List)->
    #rank_role{score=Score} = RankRole,
    case check_enter_rank(Score,Type,SubType) of
        false-> set_rank(T,Type,SubType,InitRank,List);
        {RankMin,_RankMax}->
            case InitRank>=RankMin of
                true-> set_rank(T,Type,SubType,InitRank+1,[RankRole#rank_role{rank=InitRank}|List]);
                false-> set_rank(T,Type,SubType,RankMin+1,[RankRole#rank_role{rank=RankMin}|List])
            end
    end.

%%向后排名(暂时不用)
set_rank_back(RankMin,_RankMax,List,RankRole)->
    case lists:keyfind(RankMin,#rank_role.rank,List) of
        false->RankRole#rank_role{rank=RankMin};
        _-> set_rank_back(RankMin+1,_RankMax,List,RankRole)
    end.


%%按积分排序，积分相同按时间
sort_rank_role(RankList)->
    F = fun(RoleA,RoleB)->
        if
            RoleA#rank_role.score > RoleB#rank_role.score -> true;
            RoleA#rank_role.score < RoleB#rank_role.score -> false;
            RoleA#rank_role.last_time < RoleB#rank_role.last_time -> true;
            true ->
                false
        end
        end,
    lists:sort(F,RankList).

%%区改变
zone_change(ServerId, OldZone, NewZone, State) ->
    #rank_status{rank_list=RankList} = State,
    NRankList = zone_type_change(RankList,ServerId, OldZone, NewZone, []),
    NewState = State#rank_status{rank_list=NRankList},
    {noreply,NewState}.

%%根据区找
zone_type_change([], _ServerId, _OldZone, _NewZone, RankList)->RankList;
zone_type_change([RankType|T], ServerId, OldZone, NewZone, RankList)->
    #rank_type{type=Type,subtype=SubType,rank_data=DataList} = RankType,
    case is_zone_act(Type,SubType) of
        true ->
            case lists:keyfind(OldZone,#rank_data.id,DataList) of
                false-> zone_type_change(T, ServerId, OldZone, NewZone, [RankType|RankList]);
                #rank_data{rank_list=OZoneList} = OZoneData->
                    {OZoneList1,ChangeRole} = zone_data_change(OZoneList,ServerId,[],[]),
                    case ChangeRole == [] of
                        true-> zone_type_change(T, ServerId, OldZone, NewZone, [RankType|RankList]);
                        false->
                            Max = get_rank_max(Type,SubType),
                            case OZoneList1 == [] of
                                true-> NDataList1 = lists:keydelete(OldZone,#rank_data.id,DataList);
                                false->
                                    OZoneList2 = sort_rank_role(OZoneList1),
                                    OZoneList3 = set_rank(OZoneList2,Type,SubType,1,[]),
                                    {OZoneList4,OZoneLimit} = get_limit_score(Type,SubType,OZoneList3,Max),
                                    NOZoneData = OZoneData#rank_data{rank_list=OZoneList4,score_limit=OZoneLimit},
                                    NDataList1 = lists:keystore(OldZone,#rank_data.id,DataList,NOZoneData)
                            end,
                            case lists:keyfind(NewZone,#rank_data.id,DataList) of
                                false-> NZoneList1 = ChangeRole;
                                #rank_data{rank_list=NZoneList}->
                                    NZoneList1 = NZoneList++ChangeRole
                            end,
                            NZoneList2 = sort_rank_role(NZoneList1),
                            NZoneList3 = set_rank(NZoneList2,Type,SubType,1,[]),
                            {NZoneList4,NZoneLimit} = get_limit_score(Type,SubType,NZoneList3,Max),
                            NNZoneData = #rank_data{id=NewZone,rank_list=NZoneList4,score_limit=NZoneLimit},
                            NDataList2 = lists:keystore(NewZone,#rank_data.id,NDataList1,NNZoneData),
                            NRankType = RankType#rank_type{rank_data=NDataList2},
                            zone_type_change(T,ServerId,OldZone,NewZone,[NRankType|RankList])

                    end
            end;
        false ->
            zone_type_change(T, ServerId, OldZone, NewZone, [RankType|RankList])
    end.

%%根据服务器id找
zone_data_change([],_ServerId,RList,ChangeRole)->{RList,ChangeRole};
zone_data_change([#rank_role{server_id=ServerId}=RankRole|T],ServerId,RList,ChangeRole)->
    zone_data_change(T,ServerId,RList,[RankRole|ChangeRole]);
zone_data_change([RankRole|T],ServerId,RList,ChangeRole)->
    zone_data_change(T,ServerId,[RankRole|RList],ChangeRole).

%%玩家改名
change_name([RoleId,ServerId,Name,MaskId],State) ->
    #rank_status{opening_act=OpenAct,show_act=ShowAct} = State,
    AllAct = OpenAct ++ ShowAct,
    % Zone = get_zone(ServerId),
    case AllAct =/= [] of % andalso Zone>0 of
        true-> change_rank_list_name(AllAct,{RoleId,ServerId,Name,MaskId},State);
        false-> State
    end.

change_rank_list_name(AllAct,Value,State) ->
    #rank_status{rank_list=RankList} = State,
    {NRankList,N} = change_rank_type_name(AllAct,Value,RankList,0),
    case N > 0 of
        true->
            {RoleId,_,Name,MaskId} = Value,
            Sql = io_lib:format(<<"update `race_act_rank` SET name='~s', mask_id=~p WHERE role_id =~p">>,[Name,RoleId,MaskId]),
            db:execute(Sql);
        false-> ok
    end,
    State#rank_status{rank_list=NRankList}.

change_rank_type_name([],_Value,RankList,N) -> {RankList,N};
change_rank_type_name([#base_race_act_info{type=Type,sub_type=SubType}|T],Value,RankList,N) ->
    Key = {Type,SubType},
    {RoleId,ServerId,Name,MaskId} = Value,
    Zone = get_zone(Type,SubType,ServerId),
    if
        Zone == false -> change_rank_type_name(T,Value,RankList,N);
        true ->
            case lists:keyfind(Key,#rank_type.id,RankList) of
                false-> change_rank_type_name(T,Value,RankList,N);
                #rank_type{rank_data=RankData} = RankType->
                    case lists:keyfind(Zone,#rank_data.id,RankData) of
                        false-> change_rank_type_name(T,Value,RankList,N);
                        #rank_data{rank_list=RoleList} = Data->
                            case lists:keyfind(RoleId,#rank_role.id,RoleList) of
                                false-> change_rank_type_name(T,Value,RankList,N);
                                #rank_role{} = RankRole->
                                    NRankRole = change_role_name(RankRole,Name,MaskId),
                                    NRoleList = lists:keystore(RoleId,#rank_role.id,RoleList,NRankRole),
                                    NData = Data#rank_data{rank_list=NRoleList},
                                    NRankData = lists:keystore(Zone,#rank_data.id,RankData,NData),
                                    NRankType = RankType#rank_type{rank_data=NRankData},
                                    NRankList = lists:keystore(Key,#rank_type.id,RankList,NRankType),
                                    change_rank_type_name(T,Value,NRankList,N+1)
                            end
                    end
            end
    end.

change_role_name(RankRole,Name,MaskId) ->
    OFigure = RankRole#rank_role.figure,
    NFigure = OFigure#figure{name=Name,mask_id=MaskId},
    RankRole#rank_role{figure=NFigure}.

%% ---------------------------------- 进榜end -----------------------------------


send_info(ServerId,RoleId,Type,SubType,State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> {noreply, State};
        ZoneId ->
            #rank_status{zone_list = ZoneList} = State,
            case lists:keymember({ZoneId,Type,SubType}, #race_act_zone.key, ZoneList) of
                true -> NewState = State;
                false -> NewState = recalc_and_sync_update(State)
            end,
            #rank_status{zone_list = NewZoneList} = NewState,
            case lists:keyfind({ZoneId,Type,SubType}, #race_act_zone.key, NewZoneList) of
                false -> {noreply, NewState};
                #race_act_zone{world_lv = WorldLv} ->
                    Args = [RoleId, ?APPLY_CAST_SAVE, lib_race_act, send_info, [Type, SubType, WorldLv]],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                    {noreply, NewState}
            end
    end.

treasure_draw(ServerId,RoleId,Type,SubType,Times,State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> {noreply, State};
        ZoneId ->
            #rank_status{zone_list = ZoneList} = State,
            case lists:keymember({ZoneId,Type,SubType}, #race_act_zone.key, ZoneList) of
                true -> NewState = State;
                false -> NewState = recalc_and_sync_update(State)
            end,
            #rank_status{zone_list = NewZoneList} = NewState,
            case lists:keyfind({ZoneId,Type,SubType}, #race_act_zone.key, NewZoneList) of
                false -> {noreply, NewState};
                #race_act_zone{world_lv = WorldLv} ->
                    Args = [RoleId, ?APPLY_CAST_SAVE, lib_race_act, treasure_draw, [Type,SubType,Times, WorldLv]],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                    {noreply, NewState}
            end
    end.

get_stage_reward(ServerId,RoleId,Type,SubType,RewardId,State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> {noreply, State};
        ZoneId ->
            #rank_status{zone_list = ZoneList} = State,
            case lists:keymember({ZoneId,Type,SubType}, #race_act_zone.key, ZoneList) of
                true -> NewState = State;
                false -> NewState = recalc_and_sync_update(State)
            end,
            #rank_status{zone_list = NewZoneList} = NewState,
            case lists:keyfind({ZoneId,Type,SubType}, #race_act_zone.key, NewZoneList) of
                false -> {noreply, NewState};
                #race_act_zone{world_lv = WorldLv} ->
                    Args = [RoleId, ?APPLY_CAST_SAVE, lib_race_act, get_stage_reward, [Type,SubType,RewardId, WorldLv]],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                    {noreply, NewState}
            end
    end.

%%获取榜单
get_type_rank(Type,SubType,RankRole,State) ->
    #rank_status{rank_list=RankList} = State,
    #rank_role{id=RoleId,node=Node,server_id=ServerId,score=Score} = RankRole,
    ZoneId = get_zone(Type,SubType,ServerId),
    Key = {Type,SubType},
    if
        ZoneId == false -> SendList = [], Rank = 0;
        true ->
            case lists:keyfind(Key,#rank_type.id,RankList) of
                false-> SendList = [], Rank = 0;
                #rank_type{rank_data=DataList}->
                    case get_type_rank_list(ZoneId,DataList) of
                        []-> SendList = [], Rank = 0;
                        #rank_data{rank_list=List}->
                            SendList = get_type_rank_help(List,[]),
                            case lists:keyfind(RoleId, #rank_role.id, List) of
                                #rank_role{rank = Rank} -> ok;
                                _ -> Rank = 0
                            end
                    end
            end
    end,
    % ?PRINT("~p:~p~n",[Score,SendList]),
    {ok, Bin} = pt_338:write(33802, [Type, SubType, Score, Rank, SendList]),
    send_to_role(Node,RoleId,Bin),
    {noreply,State}.

get_type_rank_help([],List)->List;
get_type_rank_help([RankRole|T],List)->
    #rank_role{id=RoleId,server_num=ServerId,rank=Rank,figure=#figure{name=Name,mask_id=MaskId},score=Score} = RankRole,
    WrapName = lib_player:get_wrap_role_name(Name, [MaskId]),
    get_type_rank_help(T,[{Rank,ServerId,RoleId,WrapName,Score}|List]).

%%获取对应榜单
get_type_rank_list(Key,DataList)->
    case lists:keyfind(Key,#rank_data.id,DataList) of
        false->
            [];
        #rank_data{}=Data->
            Data
    end.

%%获取上限内榜单和最低分数
get_limit_score(Type,SubType,List,Max)->
    Length = length(List),
    case Length>=Max of
        true->
            SortList = lists:keysort(#rank_role.rank,List),
            {NRankList,DelList} = lists:split(Max,SortList),
            LastRole = lists:last(NRankList),
            LastScore = LastRole#rank_role.score,
            lib_race_act_util:db_delete_rank_role(Type,SubType,DelList),
            {NRankList,LastScore};
        false-> {List,0}
    end.

%%获取榜单长度
get_rank_max(Type,SubType)->
    List = data_race_act:get_rank_reward_all_id(Type,SubType),
    case List == [] of
        true-> 0;
        false-> lists:max(List)
    end.

%%取玩家名字(本服)
get_name(RoleId)->
    case lib_relationship:get_rela_role_info(RoleId) of
        false -> <<>>;
        RoleInfo ->
            RoleInfo#ets_rela_role_info.figure#figure.name
    end.

%%活动结束通知
act_close_broadcast(Type,SubType)->
    ?PRINT("act_clost_broadcast~n",[]),
    lib_race_act_util:db_race_act_delete(Type,SubType),
    {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
    SendList = lib_race_act_util:combine_opening_act_list(OpenList,ShowList,[]),
    {ok, Bin} = pt_338:write(33800, [SendList]),
    lib_server_send:send_to_all(Bin).

%%广播全世界活动状态
broadcast_act_list()->
    {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
    SendList = lib_race_act_util:combine_opening_act_list(OpenList,ShowList,[]),
    {ok, Bin} = pt_338:write(33800, [SendList]),
    lib_server_send:send_to_all(Bin).

%%回调本地发消息给玩家
send_to_role(Node,Rid,Bin) when is_integer(Rid)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Rid,Bin]);
send_to_role(Node,Sid,Bin)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_sid, [Sid,Bin]).

%% 返回区域id
%% @return false | 0 | ZoneId
get_zone(Type, SubType, ServerId)->
    case is_zone_act(Type, SubType) of
        true ->
            case lib_clusters_center_api:get_zone(ServerId) of
                0 -> false;
                ZoneId -> ZoneId
            end;
        false ->
            0
    end.

is_zone_act(Type, SubType) ->
    case data_race_act:get_act_info(Type, SubType) of
        #base_race_act_info{is_zone = ?RACE_ACT_IS_ZONE_YES} -> true;
        _ -> false
    end.

%% 请求跨服的数据
sync_server_data(ServerId, #rank_status{zone_list = ZoneList} = State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> skip;
        ZoneId ->
            LocalList = packet_zone_list_to_local(ZoneList, []),
            case lists:keyfind(ZoneId, 1, LocalList) of
                false -> skip;
                {ZoneId, List} ->
                    mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, mod_race_act_local, sync_update, [List])
            end
    end,
    {noreply, State}.

%%　每天零点分配
midnight_recalc(State) ->
    % ?MYLOG("hjhrace", "midnight_recalc ~n", []),
    NewState = recalc_and_sync_update(State),
    {noreply, NewState}.

recalc_and_sync_update(#rank_status{zone_list = ZoneList, opening_act = OpenList0, show_act = ShowAct} = State) ->
    OpenList = OpenList0++ShowAct,
    EtsList = ets:tab2list(lib_zone:ets_main_zone_name(?ZONE_TYPE_1)),
    F2 = fun(#base_race_act_info{type = Type, sub_type = SubType}, {SumList, AddList}) ->
        F3 = fun(#ets_main_zone{zone_id = ZoneId, world_lv = WorldLv}, {SumListA, AddListA}) ->
            case lists:keymember({ZoneId, Type, SubType}, #race_act_zone.key, SumListA) of
                true -> {SumListA, AddListA};
                false ->
                    RaceActZone = make_record(race_act_zone, [ZoneId, Type, SubType, WorldLv]),
                    {[RaceActZone|SumListA], [RaceActZone|AddListA]}
            end
             end,
        lists:foldl(F3, {SumList, AddList}, EtsList)
         end,
    {NewZoneList, AddZoneList} = lists:foldl(F2, {ZoneList, []}, OpenList),
    % 写数据库
    replace_race_act_zone(AddZoneList),
    log_race_act_zone(AddZoneList),
    LocalList = packet_zone_list_to_local(NewZoneList, []),
    [mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, mod_race_act_local, sync_update, [TmpList])||
        {ZoneId, TmpList}<-LocalList, TmpList=/= []],
    State#rank_status{zone_list = NewZoneList}.

%% 区域分配结束
reset_end(State) ->
    % ?MYLOG("hjhrace", "reset_end ~n", []),
    db_truncate_race_act_zone(),
    NewState = recalc_and_sync_update(State#rank_status{zone_list = []}),
    {noreply, NewState}.

replace_race_act_zone(ZoneList) ->
    SubSQL = replace_race_act_zone_sql(ZoneList, []),
    case SubSQL of
        [] -> skip;
        _ ->
            SQL = string:join(SubSQL, ", "),
            NSQL = io_lib:format(?sql_race_act_zone_replace_one, [SQL]),
            db:execute(NSQL)
    end,
    ok.

%% 拼接mysql语句，以用于mysql批量提交
replace_race_act_zone_sql([], UpdateSQL) ->
    UpdateSQL;
replace_race_act_zone_sql(
    [#race_act_zone{zone_id = ZoneId, type = Type, subtype = SubType, world_lv = WorldLv}| Rest], UpdateSQL) ->
    SQL = io_lib:format(?sql_race_act_zone_replace_values, [ZoneId, Type, SubType, WorldLv]),
    replace_race_act_zone_sql(Rest, [SQL | UpdateSQL]).

log_race_act_zone([]) -> skip;
log_race_act_zone([#race_act_zone{zone_id = ZoneId, type = Type, subtype = SubType, world_lv = WorldLv}|ZoneList]) ->
    lib_log_api:log_race_act_zone(ZoneId, Type, SubType, WorldLv),
    log_race_act_zone(ZoneList).

db_delete_race_act_zone(Type, SubType) ->
    Sql = io_lib:format(?sql_race_act_zone_delete, [Type, SubType]),
    db:execute(Sql).

db_truncate_race_act_zone() ->
    Sql = io_lib:format(?sql_race_act_zone_truncate, []),
    db:execute(Sql).

% get_zone(ServerId) -> 
%     lib_clusters_center_api:get_zone(ServerId).

gm_refresh(State)->
    #rank_status{rank_list=RankList} = init_rank(),
    ?PRINT("~p~n",[RankList]),
    NState = State#rank_status{rank_list=RankList},
    {noreply,NState}.

%%刷新所有定时器秘籍（运营修改正在开启活动的配置时间相关时用）
gm_refresh_ref(State1)->
    State2 = init_act(State1),
    State3 = set_timer_to_close_act(State2),
    State4 = set_timer_to_start_act(State3),
    State5 = set_timer_to_show_act(State4),
    {noreply, State5}.

