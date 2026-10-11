%%%------------------------------------
%%% @Module  : lib_race_act
%%% @Author  : zengzy
%%% @Created : 2017-12-21
%%% @Description: 活动函数
%%%------------------------------------
-module(lib_race_act).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("race_act.hrl").
-include("predefine.hrl").
-include("chat.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("goods.hrl").

-compile(export_all).


%%删除配置发错物品并补发邮件
send_reward_and_delete_goods()->
    Sql = io_lib:format("select `goods_high`.pid,`goods_high`.num from `goods_high`,`goods_low`,`goods` where `goods_high`.gid=`goods_low`.gid and `goods_high`.gid=`goods`.id and `goods_low`.gtype_id =~p",[710001]),
    List = db:get_all(Sql),
    Sql1 = io_lib:format("delete `goods_high`,`goods_low`,`goods` from `goods_high`,`goods_low`,`goods` where `goods_high`.gid=`goods_low`.gid and `goods_high`.gid=`goods`.id and `goods_low`.gtype_id = ~p",[710001]),
    db:execute(Sql1),
    send_reward(List).

send_reward([]) -> ok;
send_reward([[RoleId,Num]|T]) ->
    Title = utext:get(332),
    Content = utext:get(333,[Num]),
    Reward = [{0,810006,Num}],
    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
    send_reward(T).

%%转换为跨服记录
make_rank_role(PS,Score)->
    #player_status{
        id = RoleId,
        server_id = ServerId,
        platform = PForm,
        server_num = SNum,
        figure = Figure
    } = PS,
    #rank_role{
        id = RoleId,
        server_id = ServerId,
        platform = PForm,
        server_num = SNum,
        node = ServerId,
        score = Score,
        figure = Figure,
        last_time = utime:unixtime()
    }.

%%登录加载
login(PS) ->
    #player_status{id=RoleId} = PS,
    Exchange = lib_race_act_util:get_recharge_exchange(),
    case lib_race_act_util:db_race_act_role_select(RoleId) of
        []->
            NDataList = login_default(Exchange,RoleId,[]),
            RactAct = #race_act{data_list=NDataList};
        List->
            DataList = login_init(List,[]),
            NDataList = login_default(Exchange,RoleId,DataList),
            RactAct = #race_act{data_list=NDataList}
    end,
    PS#player_status{race_act=RactAct}.

login_init([],RaceAct)->RaceAct;
login_init([[RoleId,Type,SubType,Score,TodayScore,Times,RList,SList,Other,Time]|T],RaceAct) ->
    Now = utime:unixtime(),
    case check_clear_act(Type,SubType,Now,Time) of
        false->
            RewardList = util:bitstring_to_term(RList),
            ScoreReward = util:bitstring_to_term(SList),
            Others = util:bitstring_to_term(Other),
            RaceData = #race_act_data{
                id={Type,SubType},type=Type,subtype=SubType,
                score=Score,times=Times,reward_list=RewardList,
                score_reward=ScoreReward,today_score=TodayScore,last_time=Time,other=Others
            },
            {NRaceData,DbType} = check_clear(RaceData),
            case DbType > 0 of
                true-> lib_race_act_util:db_race_act_role_replace(RoleId,NRaceData);
                false-> ok
            end,
            login_init(T,[NRaceData|RaceAct]);
        true->
            lib_race_act_util:db_race_act_role_delete(RoleId,Type,SubType),
            login_init(T,RaceAct)
    end.

%%补上有首次免费的活动类型
login_default([],_RoleId,DataList) -> DataList;
login_default([{Type,SubType}|T],RoleId,DataList)->
    Key = {Type,SubType},
    case lists:keyfind(Key,#race_act_data.id,DataList) of
        false ->
            NDataList = login_default_type(Type,SubType,RoleId,DataList),
            login_default(T,RoleId,NDataList);
        _ -> login_default(T,RoleId,DataList)
    end.

% login_default_type(Type,SubType,RoleId,DataList) when Type == ?RACE_ACT_WISH ->
%     case lib_race_act_util:is_open(Type,SubType) of
%         ?OPEN->
%             Other = #race_wish{e_times=1,key=1},
%             Data = #race_act_data{id={Type,SubType},type=Type,subtype=SubType,other=Other,last_time=utime:unixtime()},
%             lib_race_act_util:db_race_act_role_replace(RoleId, Data),
%             [Data|DataList];
%         _-> DataList
%     end;
login_default_type(_Type,_SubType,_RoleId,DataList) ->
    DataList.


%%检测是否清除(true是清，false是不清)
check_clear_act(Type,SubType,_Now,Time) ->
    case lib_race_act_util:is_open(Type,SubType) of
        ?CLOSE->
            Info = data_race_act:get_act_info(Type,SubType),
            %%判断是否展示
            case lib_race_act_util:check_act_show(Info) of
                true->false;
                false->true
            end;
        ?OPEN->
            #base_race_act_info{clear_type=ClearType} = data_race_act:get_act_info(Type,SubType),
            ?IF(ClearType==?ZERO_CLEAR,check_time_clear(Time),false)
    end.

%%检测重置内容
check_clear(RaceData) ->
    #race_act_data{type=Type,subtype=SubType} = RaceData,
    {N1RaceData,N1DbType} = check_clear_stage(Type,SubType,RaceData),
    {N2RaceData,N2DbType} = check_clear_times(Type,SubType,N1RaceData),
    {N2RaceData,N1DbType+N2DbType}.

%%检测是否零点清
check_time_clear(Time)->
    case utime:is_logic_same_day(Time) of
        true->false;
        false->true
    end.

%%检查是否清楚阶段奖励
check_clear_stage(Type,SubType,RaceData) ->
    #base_race_act_info{others=Others} = data_race_act:get_act_info(Type,SubType),
    ZeroType = stage_clear_zero,
    ActType = stage_clear_close,
    ZeroClear = lists:keyfind(ZeroType,1,Others),
    ActClear = lists:keyfind(ActType,1,Others),
    if
        ZeroClear =/= false ->
            case check_time_clear(RaceData#race_act_data.last_time) of
                true-> {RaceData#race_act_data{score_reward=[],today_score=0},1};
                false-> {RaceData,0}
            end;
        ActClear =/= false -> {RaceData,0};
        true -> {RaceData,0}
    end.

%%检测每日次数是否清除
% check_clear_times(Type,_SubType,RaceData) when Type == ?RACE_ACT_WISH->
%     case check_time_clear(RaceData#race_act_data.last_time) of
%         true->
%             NRaceData = RaceData#race_act_data{times=0,reward_list=[],other=#race_wish{e_times=1,key=1},last_time=utime:unixtime()},
%             {NRaceData,1};
%         false-> {RaceData,0}
%     end;
check_clear_times(_Type,_SubType,RaceData) ->
    {RaceData,0}.

%% 发送消息
send_info(Player, Type, SubType, WorldLv) ->
    % ?MYLOG("hjhrace", "Type:~p SubType:~p WorldLv:~p ~n", [Type, SubType, WorldLv]),
    case data_race_act:get_act_info(Type,SubType) of
        [] -> skip;
        ActInfo->
            #base_race_act_info{treasure=CostList} = ActInfo,
            IsOpen = lib_race_act_util:is_open(Type,SubType),
            Cost = case lists:keyfind(?ONE_TREASURE,1,CostList) of
                       false -> [];
                       {_,OneCost,_}->OneCost
                   end,
            TenCost = case lists:keyfind(?TEN_TREASURE,1,CostList) of
                          false -> [];
                          {_,TCost,_}->TCost
                      end,
            Data = lib_race_act:get_role_race_info(Type,SubType,Player),
            #race_act_data{score=Score,today_score=TodayScore} = Data,
            RewardList = data_race_act:get_act_reward_info_ids(Type,SubType,?GOLD_ACT),
            ScoreReward = lib_race_act:get_stage_list_type(Type,SubType,Data),
            % ?PRINT("~p:~p:~p:~p:~p:~p ~n",[IsOpen, Score, Cost, TenCost, RewardList, ScoreReward]),
            {ok, Bin} = pt_338:write(33801, [Type, SubType, IsOpen, Score, TodayScore, Cost, TenCost, RewardList, ScoreReward, WorldLv]),
            lib_server_send:send_to_uid(Player#player_status.id, Bin)
    end,
    {ok, Player}.

%%领取阶段奖励
get_stage_reward(Player, Type, SubType, RewardId, WorldLv) ->
    % ?PRINT("33804~n",[]),
    {ProData, LastPS} = case get_stage_reward_help(Player, Type, SubType, RewardId, WorldLv) of
                            {false, Reason} ->
                                ?PRINT("~p~n",[Reason]),
                                {[Type, SubType, RewardId, Reason], Player};
                            {ok, NewPS} ->
                                {[Type, SubType, RewardId, ?SUCCESS], NewPS}
                        end,
    {ok, BinData} = pt_338:write(33804, ProData),
    lib_server_send:send_to_uid(Player#player_status.id, BinData),
    {ok, LastPS}.

%%领取阶段奖励
get_stage_reward_help(PS, Type, SubType, RewardId, WorldLv) ->
    Data = get_role_race_info(Type, SubType, PS),
    #race_act_data{today_score=Score,score_reward=ScoreReward} = Data,
    IsOpen = lib_race_act_util:is_open(Type, SubType),
    IsGot = lists:member(RewardId,ScoreReward),
    if
        IsOpen =/= ?OPEN -> {false, ?ERRCODE(err338_act_not_open)};
        IsGot == true -> {false,?ERRCODE(err338_has_got)};%%加已领取提示
        true->
            case data_race_act:get_stage_reward(Type,SubType,RewardId) of
                []->{false,?FAIL};
                #base_race_act_stage_reward{need_val=NeedVal} = BaseReward ->
                    case Score>= NeedVal of
                        true->
                            Reward = count_act_reward(#race_act_reward_param{world_lv = WorldLv}, BaseReward),
                            NewPS = act_send_reward(PS,Reward,3),
                            NewData = Data#race_act_data{score_reward=[RewardId|ScoreReward]},
                            lib_race_act_util:db_race_act_role_replace(NewPS#player_status.id, NewData),
                            LastPS = update_role_race_info(Type,SubType,NewPS,NewData),
                            lib_race_act_util:log_produce(PS#player_status.id,Type,SubType,Reward,2,WorldLv),
                            {ok,LastPS};
                        false-> {false,?ERRCODE(err338_lack_of_score)}%%加积分不足提示
                    end
            end
    end.

%% ---------------------------------- 许愿 -----------------------------------
% wish_draw(PS, Type, SubType, CostType) ->
%     case lib_race_act_util:is_open(Type, SubType) of
%         ?CLOSE ->
%             {false, ?ERRCODE(err338_act_not_open)};
%         ?OPEN ->
%             case wish_draw_cost(PS, CostType, Type, SubType) of
%                 {false, Rea} ->
%                     {false, Rea};
%                 {NewPs, Cost} ->
%                     treasure_draw_do(NewPs, Type, SubType, 1, Cost, CostType)
%             end
%     end.

% %%许愿消耗
% wish_draw_cost(PS, CostType, Type, SubType) ->
%     #player_status{figure=#figure{lv=Lv}} = PS,
%     if
%         Lv <60 -> {false,?FAIL};
%         CostType == 1-> wish_draw_cost_gold(PS,Type,SubType);
%         IsCanBuy == false -> {false,?ERRCODE(err338_end_buy),PS};
%         true -> wish_draw_cost_key(PS, Type, SubType)
%     end.

% %%许愿钻石消耗
% wish_draw_cost_gold(PS, Type, SubType) ->
%     #race_act_data{times=Times} = get_role_race_info(Type,SubType,PS),
%     Cost = data_race_act:get_wish_cost_gold(Type,SubType,Times+1),
%     case Cost == 0 andalso Times =/= 0 of
%         true-> {false, ?FAIL};
%         false ->
%             case lib_goods_api:cost_money(
%                 PS, gold, Cost, race_act, [Type, SubType]
%                 ) of
%                 {1, NewPs} ->
%                     {NewPs, Cost};
%                 _ ->
%                     {false, ?GOLD_NOT_ENOUGH}
%             end
%     end.

% %%许愿秘钥消耗
% wish_draw_cost_key(PS, Type, SubType) ->
%     Data = get_role_race_info(Type, SubType, PS),
%     #race_act_data{other=Other} = Data,
%     case is_record(Other,race_wish) of
%         true->
%             #race_wish{key=Keys} = Other,
%             case Keys>= 1 of
%                 true->
%                     NOther = Other#race_wish{key=Keys-1},
%                     NData = Data#race_act_data{other=NOther},
%                     %%实时写入数据库，防异常
%                     lib_race_act_util:db_race_act_role_replace(PS#player_status.id, NData),
%                     NewPs = update_role_race_info(Type,SubType,PS,NData),
%                     {NewPs,1};
%                 false-> {false, ?ERRCODE(err338_key_not_enough)}
%             end;
%         false->
%             {false, ?ERRCODE(err338_key_not_enough)}
%     end.

%% ---------------------------------- 许愿end -----------------------------------

%% ---------------------------------- 抽奖 -----------------------------------

treasure_draw(Player, Type, SubType, Times, WorldLv) ->
    % ?PRINT("33803~n",[]),
    {ProData, LastPlayer} = case treasure_draw_help(Player, Type, SubType, Times, WorldLv) of
                                {false, Reason, NewPlayer} ->
                                    ?PRINT("~p~n",[Reason]),
                                    #race_act_data{today_score=TodayScore} = lib_race_act:get_role_race_info(Type,SubType,Player),
                                    {[Type, SubType, Times, TodayScore, Reason, []], NewPlayer};
                                {ok, NewPlayer, RewardIdList} ->
                                    F = fun(RewardId) ->
                                        case data_race_act:get_act_reward_info(Type, SubType, ?GOLD_ACT, RewardId) of
                                            #base_race_act_reward{} = BaseReward ->
                                                Reward = count_act_reward(#race_act_reward_param{world_lv = WorldLv}, BaseReward),
                                                {RewardId, Reward};
                                            _ -> {RewardId, []}
                                        end
                                        end,
                                    RewardInfoList = lists:map(F, RewardIdList),
                                    #race_act_data{today_score=TodayScore} = lib_race_act:get_role_race_info(Type,SubType,NewPlayer),
                                    {[Type, SubType, Times, TodayScore, ?SUCCESS, RewardInfoList], NewPlayer}
                            end,
    {ok, BinData} = pt_338:write(33803, ProData),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, LastPlayer}.

%%抽奖
treasure_draw_help(PS, Type, SubType, Times, WorldLv)->
    case lib_race_act_util:is_open(Type, SubType) of
        ?CLOSE ->
            {false, ?ERRCODE(err338_act_not_open), PS};
        ?OPEN ->
            case treasure_draw_cost(PS, Times, Type, SubType) of
                {false, ErrCode, NewPs} ->
                    {false, ErrCode, NewPs};
                {true, NewPS, Cost} ->
                    treasure_draw_do(NewPS, Type, SubType, Times, Cost, ?GOLD_ACT, WorldLv)
            end
    end.

%%抽奖消耗
treasure_draw_cost(PS, Times, Type, SubType) ->
    #player_status{figure=#figure{lv=Lv}} = PS,
    #base_race_act_info{treasure=Treasure} = data_race_act:get_act_info(Type,SubType),
    Result = lists:keyfind(Times,1,Treasure),
    IsCanBuy = lib_race_act_util:is_can_buy(Type, SubType),
    if
    % Type == ?RACE_ACT_HERO andalso Lv < 80 -> {false,?FAIL};
        Lv <150 -> {false,?LEVEL_LIMIT,PS};
        Result == false-> {false,?ERRCODE(err338_not_this_choice),PS};
        IsCanBuy == false -> {false,?ERRCODE(err338_end_buy),PS};
        true ->
            {Times,Cost,_} = Result,
            About = lists:concat(["Type:", Type, ",SubType:", SubType]),
            case lib_goods_api:cost_objects_with_auto_buy(PS, Cost, race_act, About) of
                {true, NewPs, NewCost} -> {true, NewPs, NewCost};
                {false, ErrCode, NewPs} -> {false, ErrCode, NewPs}
            end
    end.

%%执行抽奖
%% Cost
%%  OtherType=?GOLD_ACT [{Type, GoodsTypeId, Num},...]
%%  OtherType=?SCORE_ACT 整数
treasure_draw_do(PS, Type, SubType, Times, Cost, OtherType, WorldLv) ->
    #player_status{id=RoleId, server_id = ServerId, figure = #figure{name = _RealName,lv=Lv}} = PS,
    Name = lib_player:get_wrap_role_name(PS),
    Data = get_role_race_info(Type,SubType,PS),
    {NewData,RewardIdList, RewardList, TvList} = draw(Data,Times, Type, SubType, OtherType, WorldLv, [], [], []),
    %%整合奖品
    UqRewardList = lib_goods_api:make_reward_unique(RewardList),
    % ?PRINT("~p~n",[UqRewardList]),
    %%发送奖励
    NPS = send_draw_reward(PS,Type,UqRewardList),
    %%增加积分
    AddScore = get_draw_add_score(Type,SubType,Times,OtherType),
    OScore = NewData#race_act_data.score,
    NScore = OScore+AddScore,
    OTScore = NewData#race_act_data.today_score,
    NTScore = OTScore+AddScore,
    LastData = NewData#race_act_data{score=NScore,today_score=NTScore},
    % ?PRINT("~p:~p:~p~n",[NScore,OScore,AddScore]),
    %%通知榜单
    RankRole = make_rank_role(NPS,NScore),
    mod_race_act:cast_center([{mod,lib_race_act_mod,enter_rank,[Type,SubType,RankRole]}]),
    lib_race_act_util:db_race_act_role_replace(RoleId, LastData),
    lib_race_act_util:log_produce(RoleId,Type,SubType,UqRewardList,1,WorldLv),
    if
        OtherType==?GOLD_ACT -> lib_race_act_util:log_cost(RoleId,Lv,Type,SubType,Cost);
        true -> lib_race_act_util:log_score_cost(RoleId,Lv,Type,SubType,Cost,LastData,2)
    end,
    %%更新ps
    NewPS = update_role_race_info(Type,SubType,NPS,LastData),
    send_tv(Type, SubType, ServerId, RoleId, Name, TvList),
    {ok, NewPS, RewardIdList}.

%% 获得的奖励以及传闻列表
draw(Data, 0, _Type, _SubType, _OtherType, _WorldLv, RewardIdList, RewardList, TvList) ->
    NewData = Data#race_act_data{last_time=utime:unixtime()},
    {NewData, RewardIdList, lists:flatten(RewardList), TvList};
draw(Data, Times, Type, SubType, OtherType, WorldLv, RewardIdList, RewardList, TvList) ->
    % #race_act_data{times = OTimes, reward_list = GainList} = Data,
    {OTimes,GainList} = draw_get_info(Data,Type,OtherType),
    NewTimes = OTimes + 1,
    GoodsList = draw_goods_list(Type, SubType, OtherType, NewTimes, GainList),
    RewardId = urand:rand_with_weight(GoodsList),
    ?PRINT("rewardid:~p~n",[RewardId]),
    BaseReward = data_race_act:get_act_reward_info(Type, SubType, OtherType, RewardId),
    Reward = count_act_reward(#race_act_reward_param{world_lv = WorldLv}, BaseReward),
    Result = get_info_others_config(Type, SubType, tv_show),
    NTvList = case Result == false of
                  true->TvList;
                  false->
                      {_,GoodsTypeIds} = Result,
                      TList = member_goods(Reward,GoodsTypeIds,[]),
                      TList ++ TvList
              end,
    NewRewardList = [Reward | RewardList],
    % NewData = Data#race_act_data{
    %     times = NewTimes, reward_list = lists:usort([RewardId | GainList])
    % },
    NewData = draw_update_info(Data,Type,OtherType,NewTimes,lists:usort([RewardId | GainList])),
    NewRewardIdList = [RewardId | RewardIdList],
    draw(NewData,Times - 1, Type, SubType, OtherType, WorldLv, NewRewardIdList, NewRewardList, NTvList).

%%筛选入库的奖励
draw_goods_list(Type, SubType, OtherType, Times, GainList) ->
    RewardIds = data_race_act:get_act_reward_info_ids(Type, SubType, OtherType),
    F = fun(RewardId, {GoodsList,MustList}) ->
        case data_race_act:get_act_reward_info(Type, SubType, OtherType, RewardId) of
            #base_race_act_reward{
                condition = [NeedTimes, NullTimes, Weight, WeightT, MustTimes]
            } when Times >= NeedTimes ->
                RewardInfo = {RewardId, NeedTimes, NullTimes, Weight, WeightT, MustTimes},
                {NewGoodsList,NewMustList} = append_reward_list(RewardInfo, GainList, Times, GoodsList,MustList),
                {NewGoodsList,NewMustList};
            _ ->
                {GoodsList,MustList}
        end
        end,
    {GoodsList,MustList} = lists:foldl(F, {[],[]}, RewardIds),
    case MustList == [] of
        true-> GoodsList;
        false-> MustList
    end.

% RewardList：正常奖品权重列表；MustList：必中权重列表;当必中列表不为空时，直接用必中列表算奖励
% 规则1：中过了，且在第二和第三个参数的范围之间，不算进正常列表中
% 规则2: 没有中，且大于必中次数，算进必中列表
% 规则3：没有中，且不满足第二个参数，不算进正常列表中
% 规则4：没有中，且在第二和第三个参数的范围之间，加入附加权重，算进正常列表中
% 规则5：不加附加权重，算进正常列表中，
append_reward_list(RewardInfo, GainList, Times, RewardList, MustList) ->
    case RewardInfo of
        {RewardId, NeedTimes, NullTimes, Weight, WeightTemp, MustTimes} ->
            case lists:member(RewardId, GainList) of
                true when Times >= NeedTimes andalso Times =< NullTimes ->
                    {RewardList,MustList};
                false when Times>= MustTimes andalso MustTimes > 0->
                    {RewardList, [{Weight, RewardId}| MustList]};
                false when Times < NeedTimes ->
                    {RewardList,MustList};
                false when Times >= NeedTimes andalso Times =< NullTimes ->
                    {[{Weight + WeightTemp, RewardId} | RewardList],MustList};
                _ ->
                    {[{Weight, RewardId} | RewardList],MustList}
            end
    end.

%% 需要传闻的物品
member_goods([], _GoodsTypeIdList, GoodsList) ->
    GoodsList;
member_goods([{?TYPE_GOODS, GoodsTypeId, Num} | T], GoodsTypeIdList, GoodsList) ->
    case lists:keyfind(GoodsTypeId, 1, GoodsTypeIdList) of
        {GoodsTypeId,NeedNum} ->
            ?IF(
                Num>= NeedNum,
                member_goods(T, GoodsTypeIdList, [{GoodsTypeId, Num} | GoodsList]),
                member_goods(T, GoodsTypeIdList, GoodsList)
            );
        false ->
            member_goods(T, GoodsTypeIdList, GoodsList)
    end;
member_goods([_ | T], GoodsTypeIdList, GoodsList) ->
    member_goods(T, GoodsTypeIdList, GoodsList).

send_tv(_Type, _SubType, _ServerId, _RoleId, _Name, []) ->
    ok;
send_tv(Type, SubType, ServerId, RoleId, Name, [{GoodsTypeId, Num} | T]) ->
    case data_goods_type:get(GoodsTypeId) of
        [] -> GoodsName = "";
        #ets_goods_type{goods_name = GoodsName} -> ok
    end,
    Data = [Name, RoleId, ServerId, GoodsName, Num, Type, SubType],
    lib_chat:send_TV({all}, ?MOD_RACE_ACT, Type, Data),
    send_tv(Type, SubType, ServerId, RoleId, Name, T).

%% ---------------------------------- 抽奖end -----------------------------------

%%----------------------------------- 增加贡献，进入榜单
add_donation(PS, Type, SubType, AddDonation) ->
    #player_status{id=RoleId} = PS,
    Data = get_role_race_info(Type,SubType,PS),
    OScore = Data#race_act_data.score,
    OTScore = Data#race_act_data.today_score,
    NScore = OScore+AddDonation,
    NTScore = OTScore+AddDonation,
    LastData = Data#race_act_data{score=NScore,today_score=NTScore},
    ?PRINT("add_donation ~p:~p:~p~n",[NScore,OScore,AddDonation]),
    %%通知榜单
    RankRole = make_rank_role(PS,NScore),
    mod_race_act:cast_center([{mod,lib_race_act_mod,enter_rank,[Type,SubType,RankRole]}]),
    lib_race_act_util:db_race_act_role_replace(RoleId, LastData),
    %%更新ps
    NewPS = update_role_race_info(Type,SubType,PS,LastData),
    {ok, NewPS}.


%% ---------------------------------- 对应的抽奖次数和已获得奖品 -----------------------------------
%% 获取对应的次数和已获得奖品
draw_get_info(Data,Type,_OtherType) ->
    if
    % Type == ?RACE_ACT_TCRANE orelse Type == ?RACE_ACT_HERO
    % orelse Type == ?RACE_ACT_FASHION orelse Type == ?RACE_ACT_DRAGON
    % orelse Type == ?RACE_ACT_THORSE orelse Type == ?RACE_ACT_TWEAPON
    % orelse Type == ?RACE_ACT_GOD->
        Type == ?RACE_ACT_MOUNT orelse Type == ?RACE_ACT_MATE orelse Type == ?RACE_ACT_SUIT
            orelse Type == ?RACE_ACT_ARTIFACT orelse Type == ?RACE_ACT_FLY
            orelse Type == ?RACE_ACT_DRAGON orelse Type == ?RACE_ACT_HOLYORGAN
            orelse Type == ?RACE_ACT_HOLYJUDGE
            orelse Type == ?RACE_ACT_GOD orelse Type == ?RACE_ACT_BABY
            orelse Type == ?RACE_ACT_DEMONS orelse Type == ?RACE_ACT_BACK_DECROTEION ->
            draw_get_common_info(Data);
    % Type == ?RACE_ACT_WISH -> draw_get_wish_info(Data,OtherType);
        true-> {0,[]}
    end.

draw_get_common_info(Data) ->
    { Data#race_act_data.times, Data#race_act_data.reward_list }.

draw_get_wish_info(Data,OtherType) ->
    case OtherType == ?GOLD_ACT of
        true-> draw_get_common_info(Data);
        false->
            #race_act_data{ other=Other} = Data,
            case is_record(Other,race_wish) of
                true-> { Other#race_wish.times, Other#race_wish.reward_list };
                false-> {0,[]}
            end
    end.

%% 更新对应的次数和已获得奖品
draw_update_info(Data,Type,_OtherType,Times,GainList) ->
    if
    % Type == ?RACE_ACT_TCRANE orelse Type == ?RACE_ACT_HERO
    % orelse Type == ?RACE_ACT_FASHION orelse Type == ?RACE_ACT_DRAGON
    % orelse Type == ?RACE_ACT_THORSE orelse Type == ?RACE_ACT_TWEAPON
    % orelse Type == ?RACE_ACT_GOD->
        Type == ?RACE_ACT_MOUNT orelse Type == ?RACE_ACT_MATE orelse Type == ?RACE_ACT_SUIT
            orelse Type == ?RACE_ACT_ARTIFACT orelse Type == ?RACE_ACT_FLY
            orelse Type == ?RACE_ACT_DRAGON orelse Type == ?RACE_ACT_HOLYORGAN
            orelse Type == ?RACE_ACT_HOLYJUDGE
            orelse Type == ?RACE_ACT_GOD orelse Type == ?RACE_ACT_BABY
            orelse Type == ?RACE_ACT_DEMONS orelse Type == ?RACE_ACT_BACK_DECROTEION ->
            draw_update_common_info(Data,Times,GainList);
    % Type == ?RACE_ACT_WISH -> draw_update_wish_info(Data,OtherType,Times,GainList);
        true-> {0,[]}
    end.

draw_update_common_info(Data,Times,GainList) ->
    Data#race_act_data{
        times = Times, reward_list = GainList
    }.

draw_update_wish_info(Data, OtherType, Times, GainList)->
    case OtherType == ?GOLD_ACT of
        true-> draw_update_common_info(Data,Times,GainList);
        false->
            #race_act_data{ other=Wish} = Data,
            case is_record(Wish,race_wish) of
                true->
                    NWish = Wish#race_wish{times=Times,reward_list=GainList};
                false->
                    NWish = #race_wish{times=Times,reward_list=GainList}
            end,
            Data#race_act_data{other = NWish}
    end.

%% ---------------------------------- 对应的次数和已获得奖品end -----------------------------------


%% ---------------------------------- 获取对应抽奖次数积分 -----------------------------------
get_draw_add_score(Type,SubType,Times,_OtherType)->
    if
    % Type == ?RACE_ACT_TCRANE orelse Type == ?RACE_ACT_HERO
    % orelse Type == ?RACE_ACT_FASHION orelse Type == ?RACE_ACT_DRAGON
    % orelse Type == ?RACE_ACT_THORSE orelse Type == ?RACE_ACT_TWEAPON
    % orelse Type == ?RACE_ACT_GOD->
        Type == ?RACE_ACT_MOUNT orelse Type == ?RACE_ACT_MATE orelse Type == ?RACE_ACT_SUIT
            orelse Type == ?RACE_ACT_ARTIFACT orelse Type == ?RACE_ACT_FLY
            orelse Type == ?RACE_ACT_DRAGON orelse Type == ?RACE_ACT_HOLYORGAN
            orelse Type == ?RACE_ACT_HOLYJUDGE
            orelse Type == ?RACE_ACT_GOD orelse Type == ?RACE_ACT_BABY
            orelse Type == ?RACE_ACT_DEMONS orelse Type == ?RACE_ACT_BACK_DECROTEION ->
            get_score_tcrane(Type,SubType,Times);
    % Type == ?RACE_ACT_WISH -> get_score_wish(Type,SubType,OtherType);
        true-> 0
    end.

get_score_tcrane(Type,SubType,Times)->
    #base_race_act_info{treasure=Cost} = data_race_act:get_act_info(Type,SubType),
    case lists:keyfind(Times,1,Cost) of
        false->0;
        {Times,_,AddScore} -> AddScore
    end.

get_score_wish(Type,SubType,CostType) ->
    data_race_act:get_wish_add_socre(Type,SubType,CostType).

%% ---------------------------------- 获取对应抽奖次数积分end -----------------------------------


%%获取玩家指定类型#race_act_data
get_role_race_info(Type,SubType,PS)->
    #player_status{race_act=RaceAct} = PS,
    #race_act{data_list=DataList} = RaceAct,
    Key = {Type,SubType},
    case lists:keyfind(Key,#race_act_data.id,DataList) of
        false-> #race_act_data{id={Type,SubType},type=Type,subtype=SubType};
        #race_act_data{}=Data->
            Data
    end.

%%获取指定类型的others配置
get_info_others_config(Type,SubType,Atom)->
    Cfg = data_race_act:get_act_info(Type,SubType),
    case is_record(Cfg,base_race_act_info) of
        true->
            #base_race_act_info{others=Others} = Cfg,
            case lists:keyfind(Atom,1,Others) of
                false->false;
                Val -> Val
            end;
        false-> false
    end.

%%更新玩家指定类型#race_act_data
update_role_race_info(Type,SubType,PS,Data)->
    #player_status{race_act=RaceAct} = PS,
    #race_act{data_list=DataList} = RaceAct,
    Key = {Type,SubType},
    NDataList = lists:keystore(Key,#race_act_data.id,DataList,Data),
    NRaceAct = RaceAct#race_act{data_list=NDataList},
    PS#player_status{race_act=NRaceAct}.

%%抽奖发送奖励
send_draw_reward(PS,Type,UqRewardList) ->
    case lists:member(Type, ?NSHOW_TIPS_LIST) of
        true-> act_send_reward(PS,UqRewardList,0);
        false-> act_send_reward(PS,UqRewardList,2)
    end.

%%执行发送奖励
act_send_reward(PS, Reward, ShowTips) ->
    Produce = #produce{type=race_act,reward=Reward,show_tips=ShowTips},
    lib_goods_api:send_reward(PS,Produce).

%%获取阶段奖励状态
get_stage_list_type(Type,SubType,Data)->
    #race_act_data{today_score=Score,score_reward=RewardIds} = Data,
    Ids = data_race_act:get_stage_reward_ids(Type,SubType),
    F = fun(RewardId,List)->
        case lists:member(RewardId,RewardIds) of
            true-> [{RewardId,2}|List];
            false->
                #base_race_act_stage_reward{need_val=NeedVal} = data_race_act:get_stage_reward(Type,SubType,RewardId),
                ?IF(Score>=NeedVal, [{RewardId,1}|List], [{RewardId,3}|List])
        end
        end,
    lists:foldl(F,[],Ids).

%%获取指定类型的特殊物品数量
% get_wish_num(Type,SubType,PS)when Type == ?RACE_ACT_WISH->
%     Data = get_role_race_info(Type,SubType,PS),
%     #race_act_data{other=Other} = Data,
%     case is_record(Other,race_wish) of
%         true->
%             #race_wish{e_times=ETimes,key=Keys,left_pay=LeftPay} = Other,
%             NeedGold = data_race_act:get_recharge_gold(?RACE_ACT_WISH,SubType,ETimes+1),
%             {Keys,max(NeedGold-LeftPay,0),PS};
%         false-> %%异常，零点函数失效,再更新该活动数据
%             ?INFO("get_wish_num~p~n",[PS#player_status.id]),
%             NOther = #race_wish{e_times=1,key=1},
%             NData = Data#race_act_data{other=NOther},
%             lib_race_act_util:db_race_act_role_replace(PS#player_status.id,NData),
%             NewPS = update_role_race_info(Type,SubType,PS,NData),
%             NeedGold = data_race_act:get_recharge_gold(?RACE_ACT_WISH,SubType,1+1),
%             {1,NeedGold,NewPS}
%     end;
get_wish_num(_Type,_SubType,PS) ->
    {0,0,PS}.

%%零点清除
daily_clear(0) ->
    spawn(fun()-> daily_clear_help(),handle_over_act() end);
daily_clear(_Other) ->
    ok.

daily_clear_help() ->
    %%修改在线的祝福状态
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [
        lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, ?MODULE, refresh_daily_status, [])
        ||#ets_online{id = PlayerId}<-OnlineList
    ].

refresh_daily_status(PS)->
    #player_status{id=RoleId,race_act=RaceAct} = PS,
    #race_act{data_list=DataList} = RaceAct,
    {NDataList,_DelData,RefreshData} = refresh_race_act_data(DataList,[],[],[]),
    Exchange = lib_race_act_util:get_recharge_exchange(),
    N1DataList = login_default(Exchange,RoleId,NDataList),
    %delete_out_act(RoleId,DelData),
    refresh_db_act(RoleId,RefreshData),
    NRaceAct = RaceAct#race_act{data_list=N1DataList},
    NewPS = PS#player_status{race_act=NRaceAct},
    pp_race_act:handle(33800, NewPS, []),
    NewPS.

refresh_race_act_data([],DataList,DelData,RefreshData)->
    {DataList,DelData,RefreshData};
refresh_race_act_data([Data|T],DataList,DelData,RefreshData)->
    #race_act_data{type=Type,subtype=SubType,last_time=LastTime} = Data,
    case check_clear_act(Type,SubType,0,LastTime) of
        true-> refresh_race_act_data(T, DataList, [Data|DelData], RefreshData);
        false->
            {NData,DbType} = check_clear(Data),
            case DbType>0 of
                true-> refresh_race_act_data(T, [NData|DataList],  DelData, [NData|RefreshData]);
                false-> refresh_race_act_data(T, [Data|DataList],  DelData, RefreshData)
            end
    end.

%%刷新对应类型db
refresh_db_act(_RoleId,[]) -> ok;
refresh_db_act(RoleId,[Data|T]) ->
    lib_race_act_util:db_race_act_role_replace(RoleId,Data),
    refresh_db_act(RoleId,T).

%%删除过期数据(只筛选有数据的活动类型)
handle_over_act()->
    Sql = io_lib:format(<<"select `type`,`subtype` from race_act_role group by type,subtype">>,[]),
    List = db:get_all(Sql),
    delete_out_act(List).

%%删除对应类型db
delete_out_act([])->ok;
delete_out_act([[Type,SubType]|T])->
    case is_clear(Type,SubType) == false of
        true-> ok;
        false->
            lib_race_act_util:db_race_act_delete(Type,SubType)
    end,
    timer:sleep(1000),
    delete_out_act(T).

%%true删除 false不删除
is_clear(Type,SubType)->
    case lib_race_act_util:is_open(Type,SubType) of
        ?CLOSE->
            Info = data_race_act:get_act_info(Type,SubType),
            %%判断是否展示
            case lib_race_act_util:check_act_show(Info) of
                true->false;
                false->true
            end;
        ?OPEN->false
    end.

%%广播全世界当前活动（暂不用，跨服量多）
broadcast_act_list(OpeningAct) ->
    SendList = lib_race_act_util:combine_opening_act_list(OpeningAct,[]),
    {ok, Bin} = pt_338:write(33800, [SendList]),
    %% 通知全世界
    Args = [?APPLY_CAST_STATUS, ?MODULE, send_show_act_list, [Bin]],
    lib_player:cast_online_player_do(Args),
    ok.

%%推送当前活动
send_show_act_list(PS,Bin) ->
    lib_server_send:send_to_uid(PS#player_status.id, Bin),
    PS.


%% 刷新数据
refresh_wish(PS, Type, SubType) ->
    Data = get_role_race_info(Type,SubType,PS),
    Score = Data#race_act_data.score,
    case Score > 0 of
        true->
            RankRole = make_rank_role(PS,Score),
            mod_race_act:cast_center([{mod,lib_race_act_mod,enter_rank,[Type,SubType,RankRole]}]),
            ok;
        false->
            ok
    end.

%% 用参数计算的奖励
count_act_reward(_, #base_race_act_rank_reward{format = ?RACE_ACT_FORMAT_NORMAL} = RewardCfg) ->
    RewardCfg#base_race_act_rank_reward.reward;
count_act_reward(#race_act_reward_param{world_lv = WLv}, #base_race_act_rank_reward{format = ?RACE_ACT_FORMAT_WORLD_LV} = RewardCfg) ->
    #base_race_act_rank_reward{format = FormatType, reward = CandidateList} = RewardCfg,
    SortL = lists:keysort(1, CandidateList),
    filter_reward(FormatType, SortL, WLv, []);

count_act_reward(_, #base_race_act_stage_reward{format = ?RACE_ACT_FORMAT_NORMAL} = RewardCfg) ->
    RewardCfg#base_race_act_stage_reward.reward;
count_act_reward(#race_act_reward_param{world_lv = WLv}, #base_race_act_stage_reward{format = ?RACE_ACT_FORMAT_WORLD_LV} = RewardCfg) ->
    #base_race_act_stage_reward{format = FormatType, reward = CandidateList} = RewardCfg,
    SortL = lists:keysort(1, CandidateList),
    filter_reward(FormatType, SortL, WLv, []);

count_act_reward(_, #base_race_act_reward{format = ?RACE_ACT_FORMAT_NORMAL} = RewardCfg) ->
    RewardCfg#base_race_act_reward.reward;
count_act_reward(#race_act_reward_param{world_lv = WLv}, #base_race_act_reward{format = ?RACE_ACT_FORMAT_WORLD_LV} = RewardCfg) ->
    #base_race_act_reward{format = FormatType, reward = CandidateList} = RewardCfg,
    SortL = lists:keysort(1, CandidateList),
    filter_reward(FormatType, SortL, WLv, []);

count_act_reward(_, _) ->
    [].

filter_reward(_, [], _, CurReward) -> CurReward;
filter_reward(?RACE_ACT_FORMAT_WORLD_LV = Type, [{LimLv, T}|L], WLv, CurReward) ->
    case WLv >= LimLv of
        true ->
            filter_reward(Type, L, WLv, T);
        false -> CurReward
    end;
filter_reward(_, _, _, CurReward) -> CurReward.

%% ---------------------------------- 秘籍 -----------------------------------
%% 同步本服数据修复
%%秘籍（读取本服数据表，同步到跨服表）
db_sync_update(LoginTime,Type)->
    Info = mod_race_act_local:get_act(Type),
    case is_record(Info,ets_race_act) of
        true->
            #ets_race_act{subtype=SubType} = Info,
            spawn(fun()-> db_sync_update(1,LoginTime,Type,SubType) end);
        false->
            ?INFO("errtype,~p~n",[Type])
    end,
    ok.

db_sync_update(1,LoginTime,Type,SubType)->
    Sql = io_lib:format(
        "select `player_login`.id, `player_low`.nickname, `race_act_role`.score, `race_act_role`.last_time
        from `player_login`, `player_low`, `race_act_role`
        where `player_login`.id=`player_low`.id
        and `player_login`.id=`race_act_role`.role_id
        and `player_login`.last_login_time <=~p
        and `race_act_role`.type=~p
        and `race_act_role`.subtype=~p
        and `race_act_role`.score>0 ",[LoginTime,Type,SubType]),
    List = db:get_all(Sql),
    ?INFO("~p~n",[List]),
    ServerId = config:get_server_id(),
    SNum = config:get_server_num(),
    PForm = config:get_platform(),
    db_sync_update_act(List,ServerId,SNum,PForm,Type,SubType).

db_sync_update_act([],_ServerId,_SNum,_PFrom,_Type,_SubType) -> ok;
db_sync_update_act([[RoleId,Name,Score,LastTime]|T],ServerId,SNum,PForm,Type,SubType) ->
    case Score>0 of
        true->
            RankRole = #rank_role{
                id = RoleId,
                server_id = ServerId,
                platform = PForm,
                server_num = SNum,
                node = ServerId,
                score = Score,
                figure = #figure{name=Name},
                last_time = LastTime
            },
            mod_race_act:cast_center([{mod,lib_race_act_mod,enter_rank,[Type,SubType,RankRole]}]);
        false-> ok
    end,
    timer:sleep(urand:rand(20,100)),%%所有服操作,避开同时上传
    db_sync_update_act(T,ServerId,SNum,PForm,Type,SubType).

%%积分榜秘籍（从产出日志读取同步到本服数据表，再同步到跨服表）
db_log_sync_update(GoodId,St)->
    Info = mod_race_act_local:get_act(4),
    case is_record(Info,ets_race_act) of
        true->
            #ets_race_act{subtype=SubType} = Info,
            spawn(fun()-> db_log_sync_update(1,SubType,GoodId,St) end);
        false->
            ?INFO("errtype,~p~n",[4])
    end,
    ok.

db_log_sync_update(1,SubType,GoodId,St) ->
    Sql = io_lib:format("select `log_goods`.player_id, sum(`log_goods`.goods_num), `player_low`.nickname 
        from `log_goods` , `player_low`
        where  `log_goods`.player_id=`player_low`.id
        and `log_goods`.goods_id=~p
        and `log_goods`.time>=~p 
        and `log_goods`.time<=~p 
        group by `log_goods`.`player_id` ",[GoodId, St, utime:unixtime()]),
    List = db:get_all(Sql),
    ?INFO("~p~n",[List]),
    ServerId = config:get_server_id(),
    SNum = config:get_server_num(),
    PForm = config:get_platform(),
    db_log_sync_update_act(List,ServerId,SNum,PForm,SubType).

db_log_sync_update_act([],_ServerId,_SNum,_PFrom,_SubType) -> ok;
db_log_sync_update_act([[RoleId,Score,Name]|T],ServerId,SNum,PForm,SubType) ->
    case Score>0 of
        true->
            Data = #race_act_data{
                id = {4,SubType},
                type=4,
                subtype=SubType,
                score=Score,
                today_score=Score
            },
            lib_race_act_util:db_race_act_role_replace(RoleId, Data),
            RankRole = #rank_role{
                id = RoleId,
                server_id = ServerId,
                platform = PForm,
                server_num = SNum,
                node = ServerId,
                score = Score,
                figure = #figure{name=Name},
                last_time = utime:unixtime()
            },
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_log_sync_update_act, [4,SubType,Data]),
            mod_race_act:cast_center([{mod,lib_race_act_mod,enter_rank,[4,SubType,RankRole]}]);
        false-> ok
    end,
    timer:sleep(urand:rand(20,100)),%%所有服操作,避开同时上传
    db_log_sync_update_act(T,ServerId,SNum,PForm,SubType).

% lib_race_act:db_log_sync_role_update(1,1566230400).
% 同步本服数据修复方法1
% (修复除了神兵外的竞榜活动)
%秘籍（读取本服竞榜日志表，同步到玩家表，再同步跨服表）
db_log_sync_role_update(Type,St)->
    Info = mod_race_act_local:get_act(Type),
    case is_record(Info,ets_race_act) of
        true->
            #ets_race_act{subtype=SubType} = Info,
            spawn(fun()-> db_log_sync_role_update(1,Type,SubType,St) end);
        false->
            ?INFO("errtype,~p~n",[Type])
    end,
    ok.

db_log_sync_role_update(1,Type,SubType,St)->
    Sql = io_lib:format("select `log_race_act_cost`.role_id, `player_low`.nickname 
        from `log_race_act_cost` , `player_low`
        where  `log_race_act_cost`.role_id=`player_low`.id
        and `log_race_act_cost`.type=~p
        and `log_race_act_cost`.subtype=~p 
        and `log_race_act_cost`.time>=~p 
        and `log_race_act_cost`.time<=~p 
        group by `log_race_act_cost`.`role_id` ",[Type, SubType, St, utime:unixtime()]),
    List = db:get_all(Sql),
    ?INFO("~p~n",[List]),
    ServerId = config:get_server_id(),
    SNum = config:get_server_num(),
    PForm = config:get_platform(),
    Utime = utime:unixtime(),
    ZeroTime = utime:standard_unixdate(),
    db_log_sync_role_update_act(List, ServerId, SNum, PForm, Type, SubType, St, Utime, ZeroTime).

db_log_sync_role_update_act([], _ServerId, _SNum, _PFrom, _Type, _SubType, _St, _Utime, _ZeroTime) -> ok;
db_log_sync_role_update_act([[RoleId, Name]|T], ServerId, SNum, PForm, Type, SubType, St, Utime, ZeroTime) ->
    %%获取总积分
    Sql2 = io_lib:format("select type, subtype, cost from `log_race_act_cost` where 
        role_id=~p and type=~p and subtype=~p
        and time>=~p and time<=~p",
        [RoleId, Type, SubType, St, Utime]),
    List2 = db:get_all(Sql2),
    Score = db_log_sync_role_score(List2, 0),
    % ?INFO("List2:~p Score:~p~n",[List2, Score]),
    %%获取今日积分
    Sql3 = io_lib:format("select type, subtype, cost from `log_race_act_cost` where 
        role_id=~p and type=~p and subtype=~p
        and time>=~p and time<=~p",
        [RoleId, Type, SubType, ZeroTime, Utime]),
    List3 = db:get_all(Sql3),
    TodayScore = db_log_sync_role_score(List3, 0),
    %%获取今日阶段奖励
    Sql1 = io_lib:format("select reward from `log_race_act_produce` where 
        role_id=~p and type=~p and subtype=~p
        and time>=~p and time<=~p and ptype=2",
        [RoleId,Type, SubType, ZeroTime, Utime]),
    List = db:get_all(Sql1),
    %%获取今日已领取阶段奖励
    Ids = data_race_act:get_stage_reward_ids(Type,SubType),
    IdRewardList = [data_race_act:get_stage_reward(Type,SubType,Id)||Id<-Ids],
    RewardIds = db_log_sync_role_score_reward(List,IdRewardList,[]),
    case Score>0 of
        true->
            Data = #race_act_data{
                id = {Type,SubType},
                type=Type,
                subtype=SubType,
                score=Score,
                today_score=TodayScore,
                score_reward = RewardIds,
                last_time = Utime
            },
            lib_race_act_util:db_race_act_role_replace(RoleId, Data),
            RankRole = #rank_role{
                id = RoleId,
                server_id = ServerId,
                platform = PForm,
                server_num = SNum,
                node = ServerId,
                score = Score,
                figure = #figure{name=Name},
                last_time = Utime
            },
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_log_sync_update_act, [Type,SubType,Data]),
            mod_race_act:cast_center([{mod,lib_race_act_mod,enter_rank,[Type,SubType,RankRole]}]);
        false-> ok
    end,
    timer:sleep(urand:rand(50,100)),%%所有服操作,避开同时上传
    db_log_sync_role_update_act(T, ServerId, SNum, PForm, Type, SubType, St, Utime, ZeroTime).

%%获取积分
db_log_sync_role_score([], Score) -> Score;
db_log_sync_role_score([[Type, SubType, CostBin]|T], Score) ->
    case data_race_act:get_act_info(Type, SubType) of
        #base_race_act_info{treasure = [{_,[{GoodsType,GoodsTypeId,_}],_}|_] = Treasure} ->
            case util:bitstring_to_term(CostBin) of
                undefined -> Cost = [];
                Cost -> ok
            end,
            NewNum = lists:sum([Num||{_TmpType, _TmpGoodsTypeId, Num}<-Cost]),
            % ?PRINT("NewNum:~p ~n", [NewNum]),
            case lists:keyfind([{GoodsType,GoodsTypeId,NewNum}], 2, Treasure) of
                {_, _, AddScore} ->
                    db_log_sync_role_score(T, Score+AddScore);
                _ ->
                    db_log_sync_role_score(T, Score)
            end;
        _ ->
            db_log_sync_role_score(T, Score)
    end.

%%获取今日已领取阶段奖励
db_log_sync_role_score_reward([],_IdRewardList,GotIds) -> GotIds;
db_log_sync_role_score_reward([[Reward]|T],IdRewardList,GotIds) ->
    TermReward = util:bitstring_to_term(Reward),
    F = fun(Info, List)->
        #base_race_act_stage_reward{reward_id = RewardId, reward = RewardCfg} = Info,
        case TermReward == RewardCfg of
            true-> [RewardId|List];
            false-> List
        end
        end,
    NewGotIds = lists:foldl(F,GotIds,IdRewardList),
    db_log_sync_role_score_reward(T, IdRewardList, NewGotIds).

% 同步本服数据修复方法2 (修复神兵)
%%秘籍（读取本服竞榜日志表，同步到玩家表，再同步跨服表）
db_log_sync_role_update2(Type,St)->
    Info = mod_race_act_local:get_act(Type),
    case is_record(Info,ets_race_act) of
        true->
            #ets_race_act{subtype=SubType} = Info,
            spawn(fun()-> db_log_sync_role_update2(1,Type,SubType,St) end);
        false->
            ?INFO("errtype,~p~n",[Type])
    end,
    ok.

db_log_sync_role_update2(1,Type,SubType,St)->
    Sql = io_lib:format("select `log_race_act_cost`.role_id, `player_low`.nickname 
        from `log_race_act_cost` , `player_low`
        where  `log_race_act_cost`.role_id=`player_low`.id
        and `log_race_act_cost`.type=~p
        and `log_race_act_cost`.subtype>=~p 
        and `log_race_act_cost`.time>=~p 
        and `log_race_act_cost`.time<=~p 
        group by `log_goods`.`player_id` ",[Type, SubType, St, utime:unixtime()]),
    List = db:get_all(Sql),
    ?INFO("~p~n",[List]),
    ServerId = config:get_server_id(),
    SNum = config:get_server_num(),
    PForm = config:get_platform(),
    Utime = utime:unixtime(),
    db_log_sync_role_update_act2(List,ServerId,SNum,PForm,Type,SubType,St,Utime).

db_log_sync_role_update_act2([],_ServerId,_SNum,_PFrom,_Type,_SubType,_St,_Utime) -> ok;
db_log_sync_role_update_act2([[RoleId,Name]|T],ServerId,SNum,PForm,Type,SubType,St,Utime) ->
    Recharge = lib_recharge_api:get_today_pay_gold(RoleId),
    %%获取钻石积分
    Sql2 = io_lib:format("select count(*) from `log_race_act_cost` where 
        role_id=~p and type=~p and subtype=~p
        and time>=~p and time<=~p",
        [RoleId, Type, SubType, St, Utime]),
    List2 = db:get_row(Sql2),
    Score1 = case List2 == [] of
                 true-> 0;
                 false->
                     [Num] = List2,
                     Num *10
             end,
    %%获取秘钥积分
    Sql3 = io_lib:format("select handletype,nscore,time from `log_race_act_score_cost` where 
        role_id=~p and type=~p and subtype=~p
        and time>=~p and time<=~p order by time asc",
        [RoleId, Type, SubType, St, Utime]),
    List3 = db:get_all(Sql3),
    Wish = lib_race_act_api:exchange_num(Type,SubType,#race_wish{},Recharge),
    ZeroTime = utime:standard_unixdate(),
    F = fun([HandleType,NTimes,Time],{TScore, TTimes})->
        NTScore = case HandleType == 2 of
                      true-> TScore + 20;
                      false-> TScore
                  end,
        NTTimes = case Time>=ZeroTime andalso Time =<Utime of
                      true-> NTimes;
                      false-> TTimes
                  end,
        {NTScore, NTTimes}
        end,
    {Score2, LeftTimes} = lists:foldl(F,{0,0},List3),
    NewWish = Wish#race_wish{key=LeftTimes},
    Score = Score2 + Score1,
    case Score>0 of
        true->
            Data = #race_act_data{
                id = {Type,SubType},
                type=Type,
                subtype=SubType,
                score=Score,
                other = NewWish,
                last_time = Utime
            },
            lib_race_act_util:db_race_act_role_replace(RoleId, Data),
            RankRole = #rank_role{
                id = RoleId,
                server_id = ServerId,
                platform = PForm,
                server_num = SNum,
                node = ServerId,
                score = Score,
                figure = #figure{name=Name},
                last_time = Utime
            },
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_log_sync_update_act, [Type,SubType,Data]),
            mod_race_act:cast_center([{mod,lib_race_act_mod,enter_rank,[Type,SubType,RankRole]}]);
        false-> ok
    end,
    timer:sleep(urand:rand(20,100)),%%所有服操作,避开同时上传
    db_log_sync_role_update_act2(T,ServerId,SNum,PForm,Type,SubType,St,Utime).

%%同步在线玩家数据
gm_log_sync_update_act(PS, Type, SubType, Data) ->
    update_role_race_info(Type, SubType, PS, Data).   