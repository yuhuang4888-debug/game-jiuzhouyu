%%% ----------------------------------------------------
%%% @Module:        lib_3v3_rank
%%% @Author:        zhl
%%% @Description:   跨服3v3排行榜
%%% @Created:       2017/07/11
%%% ----------------------------------------------------

-module(lib_3v3_rank).

%% API
-compile(export_all).
-export([
        load_3v3_rank/0,                    %% 加载3v3排行榜数据
        replace_3v3_rank/0,                 %% 更新3v3排行榜数据
        replace_3v3_rank/1,
        empty_3v3_rank/0,                   %% 每周日清空排行榜数据
        refresh_3v3_rank/1,                 %% 刷新排行榜
        refresh_3v3_rank/2,                 %% 刷新排行榜
        get_page_rank/1,                    %% 获取荣誉排行榜 - 每页最多5个排名
        get_score_rank/0,                   %% 获取天梯排行榜 - 活动结束推送20强

        % merge_test/0,
        % after_merge_fix/1,                  %% 合服校正

        send_rank_rewards/1                 %% 发放周榜奖励
    ]).

% -include("server_revise.hrl").
-include("3v3.hrl").
-include("common.hrl").

%% 加载3v3排行榜数据
load_3v3_rank() ->
    Info = db:get_all(?SQL_SELECT_3V3_RANK_TEAM),
    make_record(Info, []).

make_record([], RankData) ->
    sort_rank(RankData);
    % if
    %     RankCount > ?KF_3V3_RANK_LIMIT ->
    %         DeleteList = lists:sublist(
    %             NRankData, ?KF_3V3_RANK_LIMIT, RankCount - ?KF_3V3_RANK_LIMIT),
    %         delete_over(DeleteList);
    %     true -> skip
    % end,
    % lists:sublist(NRankData, ?KF_3V3_RANK_LIMIT);
make_record([ [TeamId, TeamName, ServerName, ServerId, ServerNum, LeaderId,
        LeaderName, Power, Tier, Star, Time] | Rest], RankData) ->
    RoleRank = #kf_3v3_team_rank_data{
        server_name = binary_to_list(ServerName),
        server_num = ServerNum, server_id = ServerId, team_id = TeamId, team_name = TeamName,
        power = Power,leader_id = LeaderId, leader_name = LeaderName,
        tier = Tier, star = Star, time = Time
    },
    make_record(Rest, [RoleRank | RankData]).

% %% 合服处理 - 多余的需要从数据库里删除
% delete_over(DeleteList) ->
%   F = fun(#kf_3v3_rank_data{role_id = RoleID}, List) ->
%         [io_lib:format(?SQL_DELETE_3V3_RANK_VALUES, [RoleID]) | List]
%   end,
%   case lists:foldl(F, [], DeleteList) of
%         [] -> skip;
%         SubSQL ->
%             SQL = string:join(SubSQL, " or "),
%             db:execute(io_lib:format(?SQL_DELETE_3V3_RANK_ONE, [SQL]))
%   end,
%   ok.

%% 每周日清空排行榜数据
%% @desc : 注意，这个方法只允许mod_3v3_rank进程使用
empty_3v3_rank() ->
    RankData = ets:tab2list(?ETS_RANK_DATA),
%%    send_rank_rewards(RankData),  没有了排位奖励
    db:execute("TRUNCATE TABLE kf_team_3v3_rank").

%% 更新3v3排行榜数据
%% @desc : 注意，这个方法只允许mod_3v3_rank进程使用
replace_3v3_rank() ->
    replace_3v3_rank(ets:tab2list(?ETS_RANK_DATA)).

replace_3v3_rank(RankData) ->
    SubSQL = splice_sql(RankData, 0, []),
    case SubSQL of
        [] -> skip;
        _ ->
            SQL = string:join(SubSQL, ", "),
            NSQL = io_lib:format(?SQL_REPLACE_3V3_RANK_ONE, [SQL]),
%%            ?MYLOG("rank", "~p~n", [NSQL]),
            db:execute(NSQL)
    end,
    ok.

%% 拼接mysql语句，以用于mysql批量提交
splice_sql([], _, UpdateSQL) -> 
    UpdateSQL;
splice_sql([#kf_3v3_team_rank_data{server_name = ServerName, server_num = ServerNum,team_name = TeamName,
    server_id = ServerId, team_id = TeamId, power = Power, tier = Tier,
    star = Star, time = Time, leader_name = LeaderName, leader_id = LeaderId}
    | Rest], RankID, UpdateSQL) ->
    SQL = io_lib:format(?SQL_REPLACE_3V3_RANK_VALUES, [
        TeamId, util:fix_sql_str(TeamName), util:fix_sql_str(ServerName), ServerId, ServerNum, LeaderId,
        util:fix_sql_str(LeaderName), Power, Tier, Star, Time]),
    splice_sql(Rest, RankID + 1, [SQL | UpdateSQL]).

%% 刷新排行榜
%% @desc : 注意，这个方法只允许mod_3v3_rank进程使用
refresh_3v3_rank([], KeyValueList) ->
    {ok, KeyValueList};
refresh_3v3_rank([#kf_3v3_team_rank_data{} = RoleRank | Rest], KeyValueList) ->
    {ok, KeyVal} = refresh_3v3_rank(RoleRank),
    refresh_3v3_rank(Rest, KeyVal ++ KeyValueList).

%%refresh_3v3_rank([_Platform, _ServerNum, _RoleID, _Nickname,
%%    _Career, _Sex, _Lv, _VipLv, _Power, _Tier, _Star, _Score] = Args) ->
%%    RoleRank = to_kf_3v3_rank_data(Args),
%%    refresh_3v3_rank(RoleRank);
refresh_3v3_rank(#kf_3v3_team_rank_data{team_id = TeamId, tier = Tier} = TeamRank) ->
    RankData = ets:tab2list(?ETS_RANK_DATA),
    Result = lists:keyfind(TeamId, #kf_3v3_team_rank_data.team_id, RankData),
    if
        Result /= false ->
            KeyValueList = [{update, ?ETS_RANK_DATA, TeamRank}];
        Tier > 0 ->
            KeyValueList = [{update, ?ETS_RANK_DATA, TeamRank}];
        true ->
            KeyValueList = []
    end,
    {ok, KeyValueList}.

%% 排序 - 升序
%% 排序规则：段位 > 星数 > 时间
sort_rank(RankData) ->
    F = fun(#kf_3v3_team_rank_data{star = StarA, time = TimeA},
        #kf_3v3_team_rank_data{star = StarB, time = TimeB}) ->
        if
            StarA > StarB -> true;
            StarA < StarB -> false;
            true -> TimeA < TimeB
        end
    end,
    lists:sort(F, RankData).

%%%% 转换成#kf_3v3_rank_data{}
%%to_kf_3v3_rank_data([ServerName, ServerNum, RoleID, Nickname,
%%    Career, Sex, Lv, VipLv, Power, Tier, Star, Score]) ->
%%    #kf_3v3_rank_data{
%%        server_name = ServerName, server_num = ServerNum, role_id = RoleID, nickname = Nickname, career = Career,
%%        lv = Lv, sex = Sex, vip_lv = VipLv,
%%        power = Power, tier = Tier, star = Star, score = Score, time = utime:unixtime()
%%    }.

-define(ONE_PAGE_NUM, 100).
%% 获取荣誉排行榜 - 每页最多5个排名
%% @desc : 注意，这个方法只允许mod_3v3_rank进程使用
get_page_rank([Page, RoleID]) ->
    Start = (Page - 1) * ?ONE_PAGE_NUM  + 1,
    RankData = ets:tab2list(?ETS_RANK_DATA),
    RankCount = length(RankData),
    NRankData = sort_rank(RankData),
    RankID = get_rank_id(NRankData, 1, RoleID),
    if 
        Start >= ?KF_3V3_RANK_LIMIT orelse Start > RankCount ->
            NewPage = umath:ceil(RankCount / ?ONE_PAGE_NUM),
            NewStart = max((NewPage - 1) * ?ONE_PAGE_NUM + 1, 1),
            RankList = lists:sublist(NRankData, NewStart, ?ONE_PAGE_NUM),
            {NewPage, RankID, RankList};
        true ->
            RankList = lists:sublist(NRankData, Start, ?ONE_PAGE_NUM),
            {Page, RankID, RankList}
    end.

get_rank_id(_, _, false) ->
    0;
get_rank_id([], _, _) ->
    0;
get_rank_id([#kf_3v3_rank_data{role_id = RoleID1} | _], RankID, RoleID) 
        when RoleID1 == RoleID ->
    RankID;
get_rank_id([#kf_3v3_rank_data{} | Rest], RankID, RoleID) ->
    get_rank_id(Rest, RankID + 1, RoleID).

%% 获取天梯排行榜 - 活动结束推送20强
%% @desc : 注意，这个方法只允许mod_3v3_rank进程使用
get_score_rank() ->
    RankData = sort_rank(ets:tab2list(?ETS_RANK_DATA)),
    ?MYLOG("3v3", "RankData ~p~n", [RankData]),
    NRankData = lists:sublist(RankData, ?team_rank_length),
    F1 = fun(#kf_3v3_team_rank_data{server_name = ServerName, server_num = ServerNum, power = Power,
        team_id = TeamId, leader_id = LeaderId, leader_name = LeaderName,
        team_name = TeamName, star = Star, tier = _Tier}, {PreRank, List}) ->
        {PreRank + 1, [{TeamId, PreRank + 1, LeaderId, LeaderName, ServerNum, ServerName, TeamName, Power, Star} | List]}
    end,
    {_, ResList} = lists:foldl(F1, {0, []}, NRankData),
    ResList.

% %%合服校正测试
% merge_test()->
%     SrvRevise0 = #srv_revise_info{
%         src_srv_id = 27
%         ,src_platform = <<"sy">>
%         ,dst_srv_id = 1
%         ,dst_platform = <<"4399">>
%         ,role_offset = 10
%     },
%     SrvRevise1 = #srv_revise_info{
%         src_srv_id = 50
%         ,src_platform = <<"sy">>
%         ,dst_srv_id = 1
%         ,dst_platform = <<"4399">>
%         ,role_offset = 20
%     },
%     after_merge_fix([SrvRevise0, SrvRevise1]).

% %% 合服校正
% after_merge_fix(SrvReviseList) ->
%     RankData = ets:tab2list(?ETS_RANK_DATA),
%     do_merge_fix(SrvReviseList, RankData).

% do_merge_fix([], RankData) ->
%     RankData;
% do_merge_fix([SrvRevise | Rest], RankData) ->
%     #srv_revise_info{
%         src_srv_id = SNum               % 源服务器id
%         ,src_platform = SPform          % 源服务器platform
%         ,dst_srv_id = DNum              % 目标服务器id
%         ,dst_platform = DPform          % 目标服务器platform
%         ,role_offset = Add              % 角色id偏移量
%         ,revised_time = IsRe
%     } = SrvRevise,
%     if
%         IsRe > 0 ->
%             do_merge_fix(Rest, RankData);
%         true ->
%             F = fun(#kf_3v3_rank_data{platform = P, server_num = S, role_id = RoleID} = RoleData, List) ->
%                 case {P, S} of
%                     {SPform, SNum} ->
%                         NRoleData = RoleData#kf_3v3_rank_data{platform = DPform, 
%                             server_num = DNum, role_id = RoleID + Add},
%                         [NRoleData | List];
%                     _ ->
%                         [RoleData | List]
%                 end
%             end,
%             NRankData = lists:foldl(F, [], RankData),
%             do_merge_fix(Rest, NRankData)
%     end.

%% 发放赛季奖励奖励
send_rank_rewards(_RankData) ->
	ok.
%%    if
%%        RankData == [] ->
%%            skip;
%%        true ->
%%            NRankData = sort_rank(RankData),
%%            F = fun(
%%                    #kf_3v3_team_rank_data{
%%                        server_id = ServerId, tier = Tier, star = Star
%%                        }
%%                    , RankID) ->
%%                case data_3v3:get_rank_rewards(RankID) of
%%                    0 ->
%%                        %% 发送段位奖励
%%                        case data_3v3:get_tier_info(Tier) of
%%                            #tier_info{season_reward = Reward} ->
%%                                lib_log_api:log_3v3_rank_reward(RankID, RoleID, Nickname, Tier, Star, Reward),
%%                                mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_rank_rewards, [[RoleID, RankID, Reward]]);
%%                            _ ->
%%                                ok
%%                        end;
%%                    [] -> skip;
%%                    Reward ->
%%                        lib_log_api:log_3v3_rank_reward(RankID, RoleID, Nickname, Tier, Star, Reward),
%%                        mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_rank_rewards, [[RoleID, RankID]])
%%                end,
%%                RankID + 1
%%            end,
%%            lists:foldl(F, 1, NRankData)
%%    end.

%%get_right_star(Tier, Star) ->
%%    case data_3v3:get_tier_info(Tier) of
%%        #tier_info{star = NeedStar} ->
%%            max(Star - NeedStar, 0);
%%        _ ->
%%            0
%%    end.