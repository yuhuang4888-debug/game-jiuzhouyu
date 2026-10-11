%%%------------------------------------
%%% @Module  : lib_race_act_api
%%% @Author  : zengzy
%%% @Created : 2017-01-03
%%% @Description: api函数
%%%------------------------------------
-module(lib_race_act_api).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("race_act.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

-compile(export_all).

handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE,data = #callback_recharge_data{gold = Gold}}) ->
    #player_status{figure=#figure{lv=_Lv}} = PS,
    % case Lv>= 60 of
    %   true-> 
    Exchange = lib_race_act_util:get_recharge_exchange(),
    NPS = recharge_exchange(Exchange,Gold,PS),
    %   false-> NPS = PS
    % end,
    {ok, NPS};
handle_event(PS, #event_callback{type_id = ?EVENT_RENAME}) ->
    #player_status{id=RoleId,server_id=ServerId,figure=#figure{lv=Lv,name=Name,mask_id=MaskId},race_act=RaceAct} = PS,
    #race_act{data_list=DataList} = RaceAct,
    if
        Lv < 60 -> ok;
        DataList == [] -> ok;
        true->
            {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
            case OpenList=/=[] orelse ShowList =/= [] of
                true->
                    mod_race_act:cast_center([{mod,lib_race_act_mod,change_name,[RoleId,ServerId,Name,MaskId]}]);
                false-> ok
            end
    end,
    {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_EQUIP_MASK}) ->
    #player_status{id=RoleId,server_id=ServerId,figure=#figure{lv=Lv,name=Name,mask_id=MaskId},race_act=RaceAct} = PS,
    #race_act{data_list=DataList} = RaceAct,
    if
        Lv < 60 -> ok;
        DataList == [] -> ok;
        true->
            {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
            case OpenList=/=[] orelse ShowList =/= [] of
                true->
                    mod_race_act:cast_center([{mod,lib_race_act_mod,change_name,[RoleId,ServerId,Name,MaskId]}]);
                false-> ok
            end
    end,
    {ok, PS};
handle_event(PS, _EC) ->
    {ok, PS}.

%%重置兑换
recharge_exchange([],_Gold,PS)->PS;
recharge_exchange([{Type,SubType}|T],Gold,PS) ->
    case lib_race_act_util:is_open(Type,SubType) of
        ?OPEN->
            NPS = recharge_exchange_type(Type,SubType,PS,Gold),
            recharge_exchange(T,Gold,NPS);
        ?CLOSE->
            recharge_exchange(T,Gold,PS)
    end.

% %%神兵宝箱兑换
% recharge_exchange_type(Type,SubType,PS,Gold) when Type == ?RACE_ACT_WISH ->
%   #player_status{id=RoleId,figure=#figure{lv=Lv}} = PS,
%   Data = lib_race_act:get_role_race_info(Type,SubType,PS),
%   #race_act_data{other=Other} = Data,
%   case is_record(Other,race_wish) of
%       true->
%           {NOther,AddN} = exchange_num(Type,SubType,Other,Gold);
%       false->
%           {NOther,AddN} = exchange_num(Type,SubType,#race_wish{},Gold)
%   end,
%   NData = Data#race_act_data{other=NOther},
%   ?PRINT("recharge~p~n",[NData]),
%   lib_race_act_util:db_race_act_role_replace(PS#player_status.id,NData),
%   NPS = lib_race_act:update_role_race_info(Type,SubType,PS,NData),
%   case AddN>0 of
%       false-> ok;
%       true-> lib_race_act_util:log_score_cost(RoleId,Lv,Type,SubType,AddN,NData,1)
%   end,
%   NPS;
recharge_exchange_type(_Type,_SubType,PS,_Gold)->
    PS.


% %%兑换
% exchange_num(Type,SubType,Wish,Gold) when Type == ?RACE_ACT_WISH->
%   #race_wish{left_pay=LeftGold} = Wish,
%   AllGold = LeftGold + Gold,
%   wish_exchange_key_num(SubType,Wish#race_wish{left_pay=AllGold},0,true);
% exchange_num(_Type,_SubType,Wish,_Gold)-> Wish.

% %%神兵宝箱兑换秘钥
% wish_exchange_key_num(_SubType,Wish,AddN,false) -> {Wish,AddN};
% wish_exchange_key_num(SubType,Wish,AddN,true)->
%   #race_wish{e_times=ETimes,key=Keys,left_pay=AllGold} = Wish,
%   NeedGold = data_race_act:get_recharge_gold(?RACE_ACT_WISH,SubType,ETimes+1),
%   case AllGold >= NeedGold of
%       true->
%           LeftGold = AllGold - NeedGold,
%           wish_exchange_key_num(SubType,Wish#race_wish{e_times=ETimes+1,key=Keys+1,left_pay=LeftGold},AddN+1,true);
%       false-> wish_exchange_key_num(SubType,Wish,AddN,false)
%   end.

%%邮件处理增加秘钥
% add_race_key(PS, Num) ->
%     List = lib_race_act_util:get_recharge_exchange(),
%     F = fun({Type,SubType},TmpList)->
%         OpenType = lib_race_act_util:is_open(Type,SubType),
%         case Type == ?RACE_ACT_WISH andalso OpenType == ?OPEN of
%             true-> [{Type,SubType}|TmpList];
%             false-> TmpList
%         end
%     end,
%     OpenList = lists:foldl(F,[],List),
%     case OpenList =/= [] of
%         true->
%             [{Type,SubType}|_T] = OpenList,
%             add_role_race_key(PS,Type,SubType,Num);
%         _-> PS
%     end.

% add_role_race_key(PS,Type,SubType,Num) ->
%     #player_status{id=RoleId} = PS,
%     Data = lib_race_act:get_role_race_info(Type,SubType,PS),
%     #race_act_data{other=Wish} = Data,
%     case is_record(Wish,race_wish) of
%         true->
%             ONum = Wish#race_wish.key,
%             OTimes = Wish#race_wish.e_times,
%             NWish = Wish#race_wish{e_times=OTimes+Num , key=ONum+Num};
%         false-> NWish = #race_wish{e_times=Num, key=Num}
%     end,
%     NData = Data#race_act_data{other=NWish},
%     lib_race_act_util:db_race_act_role_replace(RoleId, NData),
%     lib_race_act:update_role_race_info(Type,SubType,PS,NData).

% gm_add_race_key(St,Et) ->
%   Sql = io_lib:format("select `player_id`,sum(`gold`) from charge where ctime>=~p and ctime<=~p and status=1 group by `player_id` ",[St,Et]),
%   List = db:get_all(Sql),
%   ?INFO("~p~n",[List]),
%   gm_add_race_key(List).

% gm_add_race_key([]) -> ok;
% gm_add_race_key([[RoleId,Gold]|T]) ->
%   timer:sleep(10),
%   Num = calc_key_num(Gold,1,true),
%   case Num > 1 of
%       true->
%           lib_mail_api:send_sys_mail([RoleId], "秘钥补发邮件", "由于更新前充值秘钥兑换问题,现给与对应的补发", [{18,0,Num-1}]),
%           gm_add_race_key(T);
%       false-> gm_add_race_key(T)
%   end.

% calc_key_num(_Gold,N,false)-> N;
% calc_key_num(Gold,N,true)->
%   NeedGold = data_race_act:get_recharge_gold(?RACE_ACT_WISH,1,N+1),
%   case Gold>= NeedGold of
%       true-> calc_key_num(max(Gold-NeedGold,0),N+1,true);
%       false-> calc_key_num(Gold,N,false)
%   end.

% 跨服中心执行
% 补发竞榜奖励，一般跨服竞榜结算有问题执行
gm_send_rank_reward(Type, SubType, STime, ETime, WorldLv) ->
    Sql = io_lib:format("select id, role_id, name, rank, server_id, score from log_race_act_rank
     where type = ~p and subtype = ~p and time between ~p and ~p", [Type, SubType, STime, ETime]),
    AllLogs = db:get_all(Sql),
    % 获取玩家最后一条上榜日志
    F =
        fun([LogId, RoleId, Name, Rank, ServerId, Score], AccMap) ->
            case maps:get(RoleId, AccMap, false) of
                {OLogId, _, _, _, _, _} when LogId < OLogId ->
                    AccMap;
                _ ->
                    AccMap#{RoleId => {LogId, RoleId, Name, Rank, ServerId, Score}}
            end
        end,
    LastRankLog = maps:values(lists:foldl(F, #{}, AllLogs)),
    % 获取 #{Rank => InfoL} 记录上可能同一个排名有多个玩家，这个时候需要时间判断
    F2 =
        fun({LogId, RoleId, Name, Rank, ServerId, Score}, AccRankMap) ->
            InfoL = maps:get(Rank, AccRankMap, []),
            AccRankMap#{Rank => [{LogId, RoleId, Name, Rank, ServerId, Score}|InfoL]}
        end,
    RankMap = lists:foldl(F2, #{}, LastRankLog),
    % 将RankMap 转成 RankList, 且根据Rank排好序， 里面的InfoL根据LogId大到小排序
    F3 = fun({Rank, InfoL}) -> {Rank, lists:reverse(lists:keysort(1, InfoL))} end,
    SortRankL = lists:map(F3, lists:keysort(1, maps:to_list(RankMap))),
    % 重新组成排名
    F4 =
        fun({Rank, InfoL}, {AccRank, AccList}) ->
            BeginRank = max(Rank, AccRank),
            {NewAccRank, List} = lists:foldl(
                fun({_LogId, RoleId, Name, _Rank, ServerId, Score}, {ARank, Acc}) ->
                    {ARank + 1, [{RoleId, Name, ARank, ServerId, Score}|Acc]}
                end, {BeginRank, []}, InfoL),
            {NewAccRank, List ++ AccList}
        end,
    {_, RealRankList} = lists:foldl(F4, {1, []}, SortRankL),
    F_fin =
        fun({RoleId, Name, Rank, ServerId, Score}) ->
            RewardId = data_race_act:get_rank_reward_id(Type, SubType, Rank),
            case data_race_act:get_rank_reward(Type,SubType,RewardId) of
                #base_race_act_rank_reward{} = BaseReward ->
                    ZoneId = lib_clusters_center_api:get_zone(ServerId),
                    Reward = lib_race_act:count_act_reward(#race_act_reward_param{world_lv = WorldLv}, BaseReward),
                    lib_log_api:log_race_act_rank_reward(RoleId, Name, ZoneId, ServerId, Type, SubType, Score, Rank, Reward, WorldLv),
                    timer:sleep(500),
                    mod_clusters_center:apply_cast(ServerId,lib_race_act_mod,rank_reward,[Type,SubType,RoleId,Score,Rank,Reward]);
                _ -> skip
            end
        end,
    lists:foreach(F_fin, RealRankList),
    ok.
