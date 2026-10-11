%%% ---------------------------------------------------------------------------
%%% @doc            lib_guild_feast_mod.hrl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-06-20
%%% @description    公会晚宴进程库函数
%%% ---------------------------------------------------------------------------
-module(lib_guild_feast_mod).

-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("mini_game.hrl").
-include("guild_feast.hrl").

-export([
    get_quiz/0
    ,game_feedback/5        % 小游戏分数反馈
    ,send_game_rank_list/3  % 发送小游戏排行榜
    ,game_time_out/5        % 小游戏结算
]).

-export([
    update_rank_list/2
    ,sort/1
    ,pack_role_rank_info/5
]).

%% 随机获取问答题内容
%% @return [问答题id...]
get_quiz() ->
    % 选择题
	ChooseNum = data_guild_feast:get_cfg(choose_question_num),
    AIds = data_guild_feast:get_question_ids_by_type(1),
	ShuffleList = ulists:list_shuffle(AIds),
	Alist = lists:sublist(ShuffleList, ChooseNum),
    % 简答题
	ShortAnswerNum = data_guild_feast:get_cfg(short_answer_question_num),
	BIds = data_guild_feast:get_question_ids_by_type(2),
	ShuffleList1 = ulists:list_shuffle(BIds),
	Blist = lists:sublist(ShuffleList1, ShortAnswerNum),
    Alist ++ Blist.

%% 小游戏分数反馈
%% @return NewState :: #status_gfeast{}
game_feedback(State, PlayerInfo, GameType, Score, _InfoList) ->
    #gfeast_player{id = RoleId} = PlayerInfo,
    case lib_guild_feast_chect:game_feedback({State, PlayerInfo, GameType, Score, _InfoList}) of
        true ->
            NewState = do_game_feedback(State, PlayerInfo, GameType, Score, _InfoList);
        {false, ErrCode} ->
            pp_mini_game:send_error_code(RoleId, ErrCode),
            NewState = State
    end,
    NewState.

do_game_feedback(State, PlayerInfo, _GameType, Score, _InfoList) ->
    % 数据获取
    #status_gfeast{mini_game_rank = RankList} = State,
    #gfeast_player{id = RId, name = RName, gid = _GId} = PlayerInfo,
    RankRole = lists:keyfind(RId, #gfeast_rank_role.role_id, RankList),
    NowTime = utime:unixtime(),
    % 本服数据更新
    case RankRole of
        false ->
            {SerId, SerNum} = {config:get_server_id(), config:get_server_num()},
            NRankRole = #gfeast_rank_role{role_id = RId, role_name = RName, server_id = SerId, server_num = SerNum, score = Score, time = NowTime};
        _ ->
            NRankRole = RankRole#gfeast_rank_role{score = Score, time = NowTime}
    end,
    NRankList = update_rank_list(RankList, NRankRole),
    NewState = State#status_gfeast{mini_game_rank = NRankList},
    % 跨服数据更新
    case lib_guild_feast:is_kf() of
        true ->
            mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, update_rank_role, [NRankRole]);
        false ->
            % 上榜玩家更新
            [
                begin
                    #gfeast_rank_role{role_id = RoleId1, score = Score1, rank = Rank1} = Role,
                    lib_server_send:send_to_uid(RoleId1, pt_402, 40220, [Rank1, Score1])
                end
             || Role <- NRankList--RankList
            ],
            % 落榜玩家更新(排名更新为0)
            [
                begin
                    #gfeast_rank_role{role_id = RoleId1, score = Score1} = Role,
                    not lists:keymember(RoleId1, #gfeast_rank_role.role_id, NRankList) andalso lib_server_send:send_to_uid(RoleId1, pt_402, 40220, [0, Score1])
                end
             || Role <- RankList--NRankList
            ]
    end,
    NewState.

%% 更新小游戏排名列表
update_rank_list(RankList, RankRole) ->
    #gfeast_rank_role{score = Score} = RankRole,
    MaxRank = data_guild_feast:get_max_rank(),
    case length(RankList) >= MaxRank of
        false -> % 当前榜单长度不足上限,直接插入数据排序
            RankList1 = lists:keystore(RankRole#gfeast_rank_role.role_id, #gfeast_rank_role.role_id, RankList, RankRole),
            sort(RankList1);
        true ->
            #gfeast_rank_role{score = LastScore} = lists:keyfind(MaxRank, #gfeast_rank_role.rank, RankList),
            case Score > LastScore of
                false -> % 玩家比榜单最后一名低分,不参与排序
                    RankList;
                true ->
                    RankList1 = lists:keystore(RankRole#gfeast_rank_role.role_id, #gfeast_rank_role.role_id, RankList, RankRole),
                    lists:sublist(sort(RankList1), MaxRank)
            end
    end.

%% 对小游戏分数排序,赋值
%% @return RankList :: [#gfeast_rank_role{}...]
sort(RoleList) ->
    F = fun(Role1, Role2) ->
        #gfeast_rank_role{score = Score1, time = T1} = Role1,
        #gfeast_rank_role{score = Score2, time = T2} = Role2,
        (Score1 >= Score2) orelse (Score1 == Score2 andalso T1 < T2)
    end,
    SortList = lists:sort(F, RoleList),
    set_rank(SortList).

%% 对有序列表进行排名赋值
set_rank(SortList) ->
    set_rank(SortList, 1, []).

set_rank([], _, RankList) ->
    lists:reverse(RankList);
set_rank([RankRole|T], Rank, AccList) ->
    NRankRole = RankRole#gfeast_rank_role{rank = Rank},
    set_rank(T, Rank+1, [NRankRole|AccList]).

%% 发送小游戏排行榜
send_game_rank_list(State, PlayerInfo, GameType) ->
    #status_gfeast{mini_game_rank = RankList} = State,
    #gfeast_player{id = RId, gid = GId} = PlayerInfo,
    case lib_guild_feast:is_kf() of
        false ->
            BinData = pack_role_rank_info(GameType, ?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY, RankList, 3),
            lib_server_send:send_to_uid(RId, BinData);
        true ->
            SerId = config:get_server_id(),
            mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, send_game_rank_list, [SerId, GameType, RId, GId])
    end.

%% 打包39904格式
pack_role_rank_info(GameType, ModId, SubId, RankList, N) ->
    F = fun(RankRole, SendL) ->
        #gfeast_rank_role{
            server_id = SerId, server_num = SerNum, role_id = RankRId, role_name = RName,
            score = Score, rank = Rank
        } = RankRole,
        {ServerId, ServerNum} = ?IF(util:is_cls(), {SerId, SerNum}, {0, 0}),
        [{ServerId, ServerNum, Rank, RankRId, RName, Score}|SendL]
    end,
    PackRoleList = [Role || #gfeast_rank_role{rank = Rank} = Role <- RankList, Rank =< N],
    PackRoleList1 = lists:foldl(F, [], PackRoleList),
    {ok, BinData} = pt_399:write(39904, [GameType, ModId, SubId, PackRoleList1]),
    BinData.

%% 小游戏结算
%% @return NewState :: #status_gfeast{}
game_time_out(State, _GameType, _InfoList, _GId, RId) ->
    #status_gfeast{mini_game_rank = RankList} = State,
    #gfeast_rank_role{
        other_infos = InfoMap
    } = RankRole = ulists:keyfind(RId, #gfeast_rank_role.role_id, RankList, #gfeast_rank_role{role_id = RId}),
    RankRole1 = RankRole#gfeast_rank_role{other_infos = InfoMap#{'game_finished' => true}},
    RankList1 = lists:keystore(RId, #gfeast_rank_role.role_id, RankList, RankRole1),
    State#status_gfeast{mini_game_rank = RankList1}.