%%% -------------------------------------------------------------------
%%% @doc        lib_rush_treasure_helper                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-25 11:22               
%%% @deprecated 函数辅助层
%%% -------------------------------------------------------------------

-module(lib_rush_treasure_helper).

-include("custom_act.hrl").
-include("rush_treasure.hrl").
-include("server.hrl").

%% API
-export([get_zone/3, check_enter_rank/4, get_limit_score/2, get_server_limit_score/2, get_role_race_info/3, update_role_race_info/4, make_rank_role/2, delete_role_race_info/3]).

%% -----------------------------------------------------------------
%% @desc 返回区域id
%% @param  Type 主类型
%% @param  SubType 次类型
%% @param  ServerId 服务器Id
%% @return ZoneId 区Id
%% -----------------------------------------------------------------
get_zone(Type, SubType, ServerId) ->
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {is_zone, IsZone} = ulists:keyfind(is_zone, 1, Condition, {is_zone, false}),
    if
        IsZone =:= ?CUSTOM_ACT_IS_ZONE_YES ->
            case lib_clusters_center_api:get_zone(ServerId) of
                0 -> false;
                ZoneId -> ZoneId
            end;
        true -> ?CUSTOM_ACT_IS_ZONE_NO
    end.

%% -----------------------------------------------------------------
%% @desc 检测分数是否能进榜
%% @param Score   分数
%% @param Type    主类型
%% @param SubType 子类型
%% @param Flag    榜单类型
%% @return {RankMin, RankMax}
%% -----------------------------------------------------------------
check_enter_rank(Score, Type, SubType, Flag) ->
    case data_rush_treasure:get_enter_rank_list_id(Type,SubType, Flag, Score) of
        [] -> false;
        Id ->
            #base_rush_treasure_rank_reward{
                rank_min = RankMin,
                rank_max = RankMax
            } = data_rush_treasure:get_rank_reward(Type,SubType, Flag, Id),
            {RankMin, RankMax}
    end.

%% -----------------------------------------------------------------
%% @desc 获取上限内个人榜单和最低分数
%% @param List 榜单角色列表
%% @param Max 上榜个数
%% @return
%% -----------------------------------------------------------------
get_limit_score(RankList, Max)->
    Length = length(RankList),
    case Length >= Max of
        true->
            SortList = lists:keysort(#rank_role.rank, RankList),
            {NRankList, _DelList} = lists:split(Max, SortList),
            LastRole = lists:last(NRankList),
            LastScore = LastRole#rank_role.score,
            {NRankList,LastScore};
        false-> {RankList, 0}
    end.

%% -----------------------------------------------------------------
%% @desc 获取上限内区服榜单和最低分数
%% @param List 榜单角色列表
%% @param Max 上榜个数
%% @return
%% -----------------------------------------------------------------
get_server_limit_score(ServerRankList, Max)->
    Length = length(ServerRankList),
    case Length >= Max of
        true->
            SortList = lists:keysort(#rank_server.rank, ServerRankList),
            {NRankList,_DelList} = lists:split(Max,SortList),
            LastRole = lists:last(NRankList),
            LastScore = LastRole#rank_server.score,
            {NRankList,LastScore};
        false-> {ServerRankList, 0}
    end.

%% -----------------------------------------------------------------
%% @desc  获取玩家指定类型
%% @param Type     主类型
%% @param SubType  子类型
%% @param PS       玩家记录
%% @return #rush_treasure_data{}
%% -----------------------------------------------------------------
get_role_race_info(Type, SubType, PS) ->
    #player_status{status_custom_act = StatusCustomAct} = PS,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    RushTreasure = maps:get(Type, DataMap, #rush_treasure{}),
    #rush_treasure{data_list = DataList} = RushTreasure,
    Key = {Type,SubType},
    case lists:keyfind(Key, #rush_treasure_data.id, DataList) of
        false-> #rush_treasure_data{id = Key, type = Type, subtype = SubType};
        #rush_treasure_data{} = Data -> Data
    end.

%% -----------------------------------------------------------------
%% @desc  更新玩家指定类型
%% @param Type     主类型
%% @param SubType  子类型
%% @param PS       玩家记录
%% @param Data     玩家活动记录
%% @return NewPs
%% -----------------------------------------------------------------
update_role_race_info(Type, SubType, PS, Data) ->
    #player_status{status_custom_act = StatusCustomAct} = PS,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    RushTreasure = maps:get(Type, DataMap, #rush_treasure{}),
    #rush_treasure{data_list = DataList} = RushTreasure,
    NDataList = lists:keystore({Type, SubType}, #rush_treasure_data.id, DataList, Data),
    NewRushTreasure = RushTreasure#rush_treasure{data_list = NDataList},
    NewDataMap = maps:put(Type, NewRushTreasure, DataMap),
    PS#player_status{status_custom_act = StatusCustomAct#status_custom_act{data_map = NewDataMap}}.

%% -----------------------------------------------------------------
%% @desc  删除玩家指定类型
%% @param Type     主类型
%% @param SubType  子类型
%% @param PS       玩家记录
%% @return NewPs
%% -----------------------------------------------------------------
delete_role_race_info(Type, SubType, PS) ->
    #player_status{status_custom_act = StatusCustomAct} = PS,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    RushTreasure = maps:get(Type, DataMap, #rush_treasure{}),
    #rush_treasure{data_list = DataList} = RushTreasure,
    NewDataList = lists:keydelete({Type, SubType}, #rush_treasure_data.id, DataList),
    NewRushTreasure = RushTreasure#rush_treasure{data_list = NewDataList},
    NewDataMap = maps:put(Type, NewRushTreasure, DataMap),
    PS#player_status{status_custom_act = StatusCustomAct#status_custom_act{data_map = NewDataMap}}.

%% -----------------------------------------------------------------
%% @desc  转换为跨服记录
%% @param PS      玩家记录
%% @param Score   分数
%% @return #rank_role{}
%% -----------------------------------------------------------------
make_rank_role(PS, Score)->
    #player_status{
        id = RoleId,
        server_id = ServerId,
        platform = PForm,
        server_num = SNum,
        figure = Figure,
        server_name = ServerName
    } = PS,
    #rank_role{
        id = RoleId,
        server_id = ServerId,
        platform = PForm,
        server_num = SNum,
        node = ServerId,
        score = Score,
        figure = Figure,
        last_time = utime:unixtime(),
        server_name  = ServerName
    }.