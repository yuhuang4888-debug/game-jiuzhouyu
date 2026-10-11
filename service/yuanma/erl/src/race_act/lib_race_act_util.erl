%%%------------------------------------
%%% @Module  : lib_race_act_util
%%% @Author  : zengzy
%%% @Created : 2017-12-21
%%% @Description: 活动辅助函数
%%%------------------------------------
-module(lib_race_act_util).

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
%%获取开启的活动
get_opening_act()->
    KeyList = data_race_act:get_all_key_list(),
    AllInfo = [data_race_act:get_act_info(Type,SubType)||{Type,SubType}<-KeyList],
    get_opening_act(AllInfo,[],[]).

get_opening_act([],List,ShowList)->{List,ShowList};
get_opening_act([ActInfo|T],List,ShowList)->
    case is_record(ActInfo,base_race_act_info) of
        false-> get_opening_act(T,List,ShowList);
        true->
            #base_race_act_info{type=Type,sub_type=SubType} = ActInfo,
            case is_open(Type,SubType) of
                ?OPEN-> get_opening_act(T,[ActInfo|List],ShowList);
                ?CLOSE ->
                    case check_act_show(ActInfo) of
                        true-> get_opening_act(T,List,[ActInfo|ShowList]);
                        false-> get_opening_act(T,List,ShowList)
                    end;
                _-> get_opening_act(T,List,ShowList)
            end
    end.

cluster_get_opening_act([],List,ShowList)->{List,ShowList};
cluster_get_opening_act([ActInfo|T],List,ShowList)->
    case is_record(ActInfo,base_race_act_info) of
        false-> cluster_get_opening_act(T,List,ShowList);
        true->
            #base_race_act_info{type=Type,sub_type=SubType} = ActInfo,
            case is_cluster_open(Type,SubType) of
                ?OPEN-> cluster_get_opening_act(T,[ActInfo|List],ShowList);
                ?CLOSE ->
                    case cluster_check_act_show(ActInfo) of
                        true-> cluster_get_opening_act(T,List,[ActInfo|ShowList]);
                        false-> cluster_get_opening_act(T,List,ShowList)
                    end;
                _-> cluster_get_opening_act(T,List,ShowList)
            end
    end.

%%判断是否开启
is_open(Type,SubType) ->
    Result = get_act_time_range(Type,SubType),
    if
        Result == false -> ?CLOSE;
        is_list(Result)==true -> ?OPEN;
        true -> ?CLOSE
    end.

%%判断跨服是否开启 
is_cluster_open(Type,SubType)->
    #base_race_act_info{
        start_time=StartTime,
        end_time=EndTime
    } = data_race_act:get_act_info(Type,SubType),
    case check_condition({act_time,StartTime,EndTime}) of
        true->?OPEN;
        false->?CLOSE
    end.

check_condition_list([]) -> true;
check_condition_list([T|Condition]) ->
    case check_condition(T) of
        true -> check_condition_list(Condition);
        false -> false
    end.

%%检测是否已开了活动或不存在
check_condition({has_open,Type,SubType,OpenDay,OpenOver}) ->
    case mod_race_act_local:get_act(Type) of
        false -> check_condition({open_day,OpenDay,OpenOver});
        Info when is_record(Info,ets_race_act) ->
            #ets_race_act{type=TypeB,subtype=SubTypeB} = Info,
            IsSame = Type==TypeB andalso SubType==SubTypeB,
            ?IF(IsSame, true, false);
        _ -> check_condition({open_day,OpenDay,OpenOver})
    end;
%%检查开启时候是否是第一天
%先判断ets是否已开,没开再判断是否开启第一天
check_condition({start_first_day,Type,SubType,OpenDay,StartTime}) ->
    case mod_race_act_local:get_act(Type) of
        Info when is_record(Info,ets_race_act) ->
            #ets_race_act{type=TypeB,subtype=SubTypeB} = Info,
            IsSame = Type==TypeB andalso SubType==SubTypeB,
            ?IF(IsSame,
                check_condition({start_first_day_help,OpenDay,StartTime}),
                false);
        _ ->
            check_condition({start_first_day_help,OpenDay,StartTime})
    end;
check_condition({start_first_day_help,OpenDay,StartTime}) ->
    OpenTime = util:get_open_time(),
    NeedTime = OpenTime + (OpenDay-1) * 86400,
    NeedTime >= StartTime;
check_condition({open_day,OpenDay,OpenOver})->
    SOpenDay = util:get_open_day(),
    SOpenDay>=OpenDay andalso SOpenDay=<OpenOver;
check_condition({act_time,StartTime,EndTime})->
    Now = utime:unixtime(),
    Now >= StartTime andalso Now=<EndTime;
%%该服开服天数刚好达到并且是展示天
check_condition({last_day,OpenDay})->
    SOpenDay = util:get_open_day(),
    SOpenDay > OpenDay;
%%该服合服第一天并且是展示天
check_condition({merge_first_day}) ->
    MergeDay = util:get_merge_day(),
    MergeDay =/= 1;
check_condition(_)->
    true.

%%获取活动的时间范围
get_act_time_range(Type,SubType) ->
    Data = data_race_act:get_act_info(Type,SubType),
    case is_record(Data,base_race_act_info) of
        false->false;
        true->
            #base_race_act_info{
                open_day=OpenDay,
                open_over = OpenOver,
                start_time=StartTime,
                end_time=EndTime
            } = Data,
            Condition = [
                % {open_day,OpenDay,OpenOver},
                {act_time,StartTime,EndTime},
                {has_open,Type,SubType,OpenDay,OpenOver}
                % {start_first_day,Type,SubType,OpenDay,StartTime}
            ],
            case check_condition_list(Condition) of
                true-> [{StartTime,EndTime}];
                false-> false
            end
    end.

%%检测是否展示
check_act_show(#base_race_act_info{type=Type,sub_type=SubType,open_day=OpenDay,open_over=OpenOver,start_time=StartTime,end_time=EndTime})->
    case lists:member(Type,?SHOW_LIST) of
        true->
            ShowEtTime = EndTime + 86400,
            Condition = [
                % {open_day,OpenDay,OpenOver},
                {act_time,StartTime,ShowEtTime},
                {last_day,OpenDay},
                {merge_first_day},
                {has_open,Type,SubType,OpenDay,OpenOver}
                % {start_first_day,Type,SubType,OpenDay,StartTime}
            ],
            case check_condition_list(Condition) of
                true-> true;
                false-> false
            end;
        false-> false
    end;
check_act_show(_)->
    false.

%%跨服中心检测是否展示
cluster_check_act_show(#base_race_act_info{type=Type,start_time=StartTime,end_time=EndTime})->
    case lists:member(Type,?SHOW_LIST) of
        true->
            Now = utime:unixtime(),
            ShowEtTime = EndTime + 86400,
            case Now < ShowEtTime andalso Now> StartTime of
                true-> true;
                false-> false
            end;
        false-> false
    end;
cluster_check_act_show(_)->
    false.

%%组合发送开启的活动
combine_opening_act_list([],[],List)->List;
combine_opening_act_list([ActInfo|T],[],List)->
    #base_race_act_info{type=Type,sub_type=SubType,show_id=ShowId,start_time=STime,end_time=ETime, buy_end_time=BuyEndTime} = ActInfo,
    combine_opening_act_list(T,[],[{Type,SubType,ShowId,STime,ETime,BuyEndTime}|List]);
combine_opening_act_list([],[ShowInfo|T],List)->
    #base_race_act_info{type=Type,sub_type=SubType,show_id=ShowId,start_time=STime} = ShowInfo,
    combine_opening_act_list([],T,[{Type,SubType,ShowId,STime,0,0}|List]);
combine_opening_act_list([ActInfo|T],[ShowInfo|T1],List)->
    #base_race_act_info{type=Type,sub_type=SubType,show_id=ShowId,start_time=STime,end_time=ETime,buy_end_time=BuyEndTime} = ActInfo,
    #base_race_act_info{type=Type1,sub_type=SubType1,show_id=ShowId1,start_time=STime1} = ShowInfo,
    combine_opening_act_list(T,T1,[{Type,SubType,ShowId,STime,ETime,BuyEndTime},{Type1,SubType1,ShowId1,STime1,0,0}|List]).

%%获取充值兑换的活动
get_recharge_exchange()->
    KeyList = data_race_act:get_all_key_list(),
    F = fun({Type,SubType},TmpList)->
        case lists:member(Type,?RECHARGE_EXCHANGE) of
            true-> [{Type,SubType}|TmpList];
            false-> TmpList
        end
        end,
    lists:foldl(F,[],KeyList).

%% 获取活动的排名奖励
get_rank_reward(Type,SubType,Rank) ->
    RewardId = data_race_act:get_rank_reward_id(Type,SubType,Rank),
    case data_race_act:get_rank_reward(Type,SubType,RewardId) of
        []-> [];
        #base_race_act_rank_reward{reward=Reward} ->
            Reward
    end.

%% 判断是否能购买#不判断活动是否开启
is_can_buy(Type, SubType) ->
    NowTime = utime:unixtime(),
    case data_race_act:get_act_info(Type,SubType) of
        #base_race_act_info{buy_end_time = BuyEndTime} when NowTime =< BuyEndTime -> true;
        _ -> false
    end.

%% ---------------------------------- db函数 -----------------------------------
db_race_act_role_select(RoleId)->
    Sql = io_lib:format(?sql_race_act_role_select,[RoleId]),
    db:get_all(Sql).

db_race_act_role_replace(RoleId,Data) ->
    #race_act_data{
        type=Type, subtype=SubType,
        score=Score,times=Times,today_score=TodayScore,
        reward_list = RList, score_reward=SList,
        other = Other,
        last_time = Time
    } = Data,
    ReList = util:term_to_bitstring(RList),
    ScList = util:term_to_bitstring(SList),
    Others = util:term_to_bitstring(Other),
    Sql = io_lib:format(?sql_race_act_role_replace,[RoleId,Type,SubType,Score,TodayScore,Times,ReList,ScList,Others,Time]),
    db:execute(Sql).

%%删除指定玩家所有类型记录
db_race_act_role_all_delete(RoleId)->
    Sql = io_lib:format(<<"delete from race_act_role where role_id=~p ">>,[RoleId]),
    db:execute(Sql).

%%删除玩家指定类型记录
db_race_act_role_delete(RoleId,Type,SubType)->
    Sql = io_lib:format(<<"delete from race_act_role where role_id=~p and type=~p and subtype=~p">>,[RoleId,Type,SubType]),
    db:execute(Sql).

%%删除玩家表类型记录
db_race_act_delete(Type,SubType)->
    Sql = io_lib:format(<<"delete from race_act_role where type=~p and subtype=~p">>,[Type,SubType]),
    db:execute(Sql).

%%榜单玩家表更新
db_rank_replace(Type,SubType,RankRole)->
    #rank_role{
        id = RoleId
        ,server_id = ServerId
        ,platform = Platform
        ,server_num = SerNum
        ,score = Score
        ,figure = #figure{name=Name, mask_id=MaskId}
        ,last_time = Time
    } = RankRole,
    NameF = util:fix_sql_str(Name),
    Sql = io_lib:format(?sql_race_act_rank_replace,[RoleId,Type,SubType,ServerId,Platform,SerNum,NameF,MaskId,Score,Time]),
    db:execute(Sql).

%%榜单去除冗余数据
db_delete_rank_role(_Type,_SubType,[])-> ok;
db_delete_rank_role(Type,SubType,[#rank_role{id=RoleId}|T]) ->
    Sql = io_lib:format(<<"delete from `race_act_rank` where type=~p and subtype=~p and role_id=~p">>,[Type,SubType,RoleId]),
    db:execute(Sql),
    db_delete_rank_role(Type,SubType,T).

%%获取已开启活动
db_race_act_open_select() ->
    Sql = io_lib:format(?sql_race_act_open_selete,[]),
    db:get_all(Sql).

%%更新已开启活动
db_race_act_open_replace(Type,SubType) ->
    Sql = io_lib:format(?sql_race_act_open_replace,[Type,SubType]),
    db:execute(Sql).

%%删除已开启活动
db_race_act_open_delete(Type,SubType) ->
    Sql = io_lib:format(<<"delete from `race_act` where type=~p and subtype=~p ">>,[Type,SubType]),
    db:execute(Sql).

%% ---------------------------------- 日志 -----------------------------------

log_cost(RoleId,Lv,Type,SubType,Cost) ->
    lib_log_api:log_race_act_cost(RoleId,Lv,Type,SubType,Cost).

%% PType 1:奖池 2:阶段
log_produce(RoleId,Type,SubType,Reward,PType,WorldLv) ->
    lib_log_api:log_race_act_produce(RoleId,Type,SubType,Reward,PType,WorldLv).

log_rank(RoleId,Name,Type,SubType,Score,Rank,ZoneId,ServerId) ->
    lib_log_api:log_race_act_rank(RoleId,Name,Type,SubType,Score,Rank,ZoneId,ServerId).

%% TODO:不要根据类型判断,可以加配置,目前没有用到,暂时注释掉
%% HandleType 1:扣 2:增加
% log_score_cost(RoleId,Lv,Type,SubType,Cost,Data,HandleType) when Type == ?RACE_ACT_WISH  ->
%   #race_act_data{other=Wish} = Data,
%   #race_wish{key=Key} = Wish,
%   case HandleType == 1 of
%       true-> lib_log_api:log_race_act_score_cost(RoleId,Lv,Type,SubType,HandleType,Key-Cost,Cost,Key);
%       false-> lib_log_api:log_race_act_score_cost(RoleId,Lv,Type,SubType,HandleType,Key+Cost,Cost,Key)
%   end;
log_score_cost(_RoleId,_Lv,_Type,_SubType,_Cost,_Data,_HandleType) ->
    ok.
