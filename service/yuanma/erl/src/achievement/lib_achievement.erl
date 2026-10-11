%%-----------------------------------------------------------------------------
%% @Module  :       lib_achievement
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-23
%% @Description:    成就逻辑模块
%%-----------------------------------------------------------------------------
-module(lib_achievement).

-include("rec_achievement.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").

-export([
    login/1
    , logout/1
    , outline_trigger/3
    , trigger/4
    , send_tips_info/1
    , send_achievement_list/1
    , receive_reward/2
    , receive_star_reward/2
    , send_achievement_summary/1
    , count_star/1
    , get_fin_num/1
    , get_fin_ids/1
    , send_current_star/1
    , get_achievement_dict/1
    , login_offline/1
    , get_real_stage/2
    , init_star_reward_list/2
    , get_attr_reward_list/1
    , send_achievement_type_state/1
    , send_achievement_all/2
    ]).

-export([
    gm_reset/1
    , gm_complete_achv/2
    , gm_recalc_achievement_sell_sell/0
    , gm_recalc_achievement_sell_sell_local/1
    , gm_refresh_achievement_data/1
    ]).

get_achievement_dict(RoleId) ->
    Pid = misc:get_player_process(RoleId),
    case Pid =:= self() of
        true ->
            case get(?P_ACHIEVEMENT) of
                undefined ->
                    {StatusAchievement,_,_} = login(RoleId),
                    save_achievement_dict(StatusAchievement),
                    {ok, StatusAchievement};
                Val -> {ok, Val}
            end;
        false -> skip
    end.

save_achievement_dict(StatusAchievement) ->
    put(?P_ACHIEVEMENT, StatusAchievement).

login_offline(PS) ->
    List1 = db:get_all(io_lib:format(?select_achievement_star_reward, [PS#player_status.id])),  
    StarRewardL = init_star_reward_list(List1, []),
    Figure = PS#player_status.figure,
    Fun = fun({_Star, Status}, TemStage) -> 
        case Status == ?HAS_RECEIVE of
            true ->
                TemStage + 1;
            false ->
                TemStage
        end
    end,
    Stage = lists:foldl(Fun, 1, StarRewardL),
    Stage = erlang:length(StarRewardL) + 1,  %%策划说将成就点改为货币类型。。。
    NewPS = PS#player_status{status_achievement = StarRewardL, figure = Figure#figure{achiv_stage = Stage}},
    NewPS.

login(RoleId) ->
    List = db:get_all(io_lib:format(?select_achievement, [RoleId])),
    List1 = db:get_all(io_lib:format(?select_achievement_star_reward, [RoleId])),
    {TotalCategoryStarL, _TotalStar} = get_total_achieve_point(),
    {StarMap, AchievementL, FinishL, TypeList} = init_achievement_list(List, TotalCategoryStarL, #{}, [], [], []),
    Fun0 = fun({TemType, Temt}, Acc) ->
        case lists:keyfind(TemType, 1, Acc) of
            {TemType, Temt, _} ->
                Acc;
            _ ->
                lists:keystore(TemType, 1, Acc, {TemType, Temt, 0})
        end
    end,
    RealTypeList = lists:foldl(Fun0, TypeList, TotalCategoryStarL),
    StarRewardL = init_star_reward_list(List1, []),
    Fun = fun({_Stage, Status}, TemStage) ->
        case Status == ?HAS_RECEIVE of
            true ->
                TemStage + 1;
            false ->
                TemStage
        end
    end,
    Stage = lists:foldl(Fun, 1, StarRewardL),
    StatusAchievement = #status_achievement{
        star_map = StarMap,
        star_reward_list = StarRewardL,
        finish_list = FinishL,
        achievement_list = AchievementL,
        stage = Stage,
        type_list = RealTypeList,
        type_star_list = TotalCategoryStarL
    },
    save_achievement_dict(StatusAchievement),
    {StatusAchievement,StarRewardL,Stage}.

init_achievement_list([], _, StarMap, AchievementL, FinishL, TypeList) ->
    {StarMap, AchievementL, FinishL, TypeList};
init_achievement_list([T|L], TotalCategoryStarL, StarMap, AchievementL, FinishL, TypeList) ->
    case T of
        [Id, Progress, Status] ->
            case data_achievement:get(Id) of
                #achievement_cfg{
                    category = Category  ,star = Star
                } ->
                    Type = get_category_achiv_type(Category),
                    case Status == ?HAS_RECEIVE of%%策划说领取奖励后成就点才累加
                        true ->
                            case lists:keyfind(Type, 1, TypeList) of
                                {Type, Total, Now} ->
                                    NewTypeList = lists:keystore(Type, 1, TypeList, {Type, Total, Now + Star});
                                _ ->
                                    case lists:keyfind(Type, 1, TotalCategoryStarL) of
                                        {Type, Total} ->
                                            NewTypeList = lists:keystore(Type, 1, TypeList, {Type, Total, Star});
                                        _ ->
                                            ?ERR("missing_config Type:~p, TotalCategoryStarL:~p~n",[Type,TotalCategoryStarL]),
                                            NewTypeList = TypeList
                                    end
                            end,
                            CurStar = maps:get(Category, StarMap, 0),     %%StarMap = #{category => star}            
                            NewStarMap = maps:put(Category, CurStar + Star, StarMap);    %%%成就点
                        false ->
                            NewTypeList = TypeList,
                            NewStarMap = StarMap
                    end,
                    AchievementInfo = #achievement{id = Id, progress = Progress, status = Status},
                    case Status =/= ?HAS_RECEIVE of
                        true ->
                            NewFinishL = FinishL,
                            NewAchievementL = [AchievementInfo|AchievementL];
                        false ->
                            NewFinishL = [AchievementInfo|FinishL],
                            NewAchievementL = AchievementL
                    end,
                    init_achievement_list(L, TotalCategoryStarL, NewStarMap, NewAchievementL, NewFinishL, NewTypeList);
                _ -> init_achievement_list(L, TotalCategoryStarL, StarMap, AchievementL, FinishL, TypeList)
            end;
        _ -> init_achievement_list(L, TotalCategoryStarL, StarMap, AchievementL, FinishL, TypeList)
    end.

init_star_reward_list([], StarRewardL) -> StarRewardL;
init_star_reward_list([T|L], StarRewardL) ->
    case T of
        [Stage, Status] ->
            init_star_reward_list(L, [{Stage, Status}|StarRewardL]);
        _ -> init_star_reward_list(L, StarRewardL)
    end.

logout(RoleId) ->
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{
                achievement_list = AchievementL     % 有进度的成就列表
            } = StatusAchievement,
            NowTime = utime:unixtime(),
            F = fun(T, Acc) ->
                case Acc rem 20 of
                    0 -> timer:sleep(100);
                    _ -> skip
                end,
                case T of
                    #achievement{
                        id = Id,
                        progress = Progress,
                        status = ?UNFINISH,
                        wstatus = ?WSTATUS_WAIT
                    } ->
                        db:execute(io_lib:format(?update_achievement_progress, [Progress, ?UNFINISH, NowTime, RoleId, Id])),
                        Acc + 1;
                    _ -> Acc
                end
            end,
            lists:foldl(F, 1, AchievementL);
        _ -> skip
    end.        
outline_trigger(RoleId, Key, [{Key, Data}]) ->
    NowTime = utime:unixtime(),
    AllIds = data_achievement:get_all_achievement_ids(),
    CfgL = filter_achievement_cfg_by_key(AllIds, Key, []),  % [{...5001...},{...5002...}] 按成就id有序排列
    case CfgL of
        [H|_] ->
            #achievement_cfg{id=Id} = H,
            F = fun(Cfg,Acc) ->
                #achievement_cfg{id = AId} = Cfg,
                List = db:get_row(io_lib:format(?SELECT_ACHV_BYID, [RoleId, AId])),
                case List of
                    [Progress,Status] ->
                        [{AId,Progress,Status}|Acc];
                    _ -> Acc
                end
            end,
            AchvList = lists:foldl(F, [], CfgL),    % [{5005,P,S},{5004,P1,S1}...],判断列表第一个成就状态即可，
            {AchvId, AchvProgress, AchvStatus} =  case AchvList =/= [] of
                true ->                             % 存入achievement的同一系列成就，不可能有之前的成就没完成的情况
                    [{AchvId1, AchvProgress1, AchvStatus1}|_] = AchvList,
                    {AchvId1, AchvProgress1, AchvStatus1};
                false ->
                    {Id, 0, ?UNFINISH}
            end,
            case AchvStatus == ?UNFINISH of                                     
                true -> 
                    case Key of
                        join_guild -> 
                            judge_condition(RoleId, AchvId, NowTime);
                        guild_battle_break ->
                            judge_condition(RoleId, AchvId, NowTime);
                        number_designation ->
                            judge_condition(CfgL, RoleId, AchvId, AchvProgress, 1, NowTime);
                        guild_battle_win ->
                            judge_condition(CfgL, RoleId, AchvId, AchvProgress, 1, NowTime);
                        vip_lv ->
                            judge_condition(CfgL, RoleId, AchvId, AchvProgress, 1, NowTime);
                        sell_sell ->
                            judge_condition(CfgL, RoleId, AchvId, AchvProgress, Data, NowTime);
                        sell_cost ->
                            judge_condition(CfgL, RoleId, AchvId, AchvProgress, Data, NowTime);
                        _ ->
                            skip
                    end;
                false ->
                    skip
            end;    
        _ ->
            % ?ERR("No such cfg, Key = ~p",[Key]),
            skip  
    end.
judge_condition(RoleId, AchvId, NowTime) ->
    db:execute(io_lib:format(?insert_achievement,[RoleId, AchvId, 1, ?FINISH, NowTime])).
%% 成就配置列表应是按成就id有序排列
judge_condition([#achievement_cfg{id = AId, condition = Condition}|T], RoleId, AchvId, AchvProgress, Data, NowTime) when AId >= AchvId ->
    case Condition of
        [{_, NeedNum}] ->   % 单条件成就
            if
                AchvProgress + Data >= NeedNum ->
                    db:execute(io_lib:format(?insert_achievement,
                        [RoleId, AId, NeedNum, ?FINISH, NowTime])),
                    % 此处尾递归,进度超前有可能触发后续系列成就
                    judge_condition(T, RoleId, AchvId, AchvProgress, Data, NowTime);
                true ->
                    db:execute(io_lib:format(?insert_achievement,
                        [RoleId, AId, AchvProgress + Data, ?UNFINISH, NowTime]))
            end;
        _ ->
            skip
    end;
judge_condition([_|T], RoleId, AchivId, AchvProgress, Data, NowTime) -> % 过滤掉已完成成就
    judge_condition(T, RoleId, AchivId, AchvProgress, Data, NowTime);

judge_condition([], _, _, _, _, _) -> skip.
                                       

trigger(#player_status{id = RoleId} = Player, RoleLv, Key, Args) ->
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            trigger(Player, RoleLv, StatusAchievement, Key, Args);
        _ -> skip
    end.

trigger(#player_status{id = RoleId} = Player, RoleLv, StatusAchievement, Key, Args) ->
    NowTime = utime:unixtime(),
    AllIds = data_achievement:get_all_achievement_ids(),
    CfgL = filter_achievement_cfg_by_key(AllIds, Key, []),   %%获得完成成就条件与key有关的所有配置
    F = fun() ->
        put(broadcast_info, []),
        Surplus = 0,
        {NewStatusAchievement, UCategoryL} = do_trigger(CfgL, RoleId, StatusAchievement, Args, NowTime, [], Surplus),
        UpdateList = erase(broadcast_info),                       %%获得并清除键对应的值
        {ok, UpdateList, UCategoryL, NewStatusAchievement}
    end,
    case catch db:transaction(F) of
        {ok, UpdateList, UCategoryL, NewStatusAchievement} ->
            save_achievement_dict(NewStatusAchievement),
            %lists:foreach(F1, UpdateList),
            OpenLv = lib_module:get_open_lv(?MOD_ACHIEVEMENT, 1),
            case RoleLv >= OpenLv of
                true ->
                    case UCategoryL =/= [] of
                        true -> %% 成就的状态发生改变通知客户端
                            notify_to_client(?NOTIFY_TYPE_STAR_NUM, Player, UCategoryL),
                            {ok, BinData} = pt_409:write(40904, [UpdateList]),
                            lib_server_send:send_to_uid(RoleId, BinData);
                        false -> 
                            if
                                Key == achv_stage_reward ->
                                    {ok, BinData} = pt_409:write(40904, [UpdateList]),
                                    lib_server_send:send_to_uid(RoleId, BinData);
                                true ->
                                    skip
                            end
                    end;
                    
                false -> skip
            end;
        Error ->
            ?ERR("role_id:~p trigger achievement args:~p err:~p~n", [RoleId, Args, Error])
    end.

do_trigger([], _RoleId, StatusAchievement, _Args, _NowTime, UCategoryL, _Surplus) ->%%UCategoryL,记录哪个类型的成就有完成的情况
    {StatusAchievement, lists:usort(UCategoryL)};
do_trigger([#achievement_cfg{category = Category, id = Id} = Cfg|L], RoleId, StatusAchievement, Args, NowTime, UCategoryL, Surplus) ->
    #status_achievement{
        % star_map = StarMap,
        finish_list = FinishL,
        achievement_list = AchievementL
    } = StatusAchievement,
    case lists:keyfind(Id, #achievement.id, FinishL) of
        false ->
            #achievement_cfg{condition = Condition,
                next_id = NextId, is_inherit = IsInherit, show_progress = Show} = Cfg,
            FrontId = get_front_id(Category, Id),
            %% 判断前置成就是否完成,没有完成不更新当前成就的进度
            IsFrontFin = case FrontId > 0 of
                true ->
                    case lists:keyfind(FrontId, #achievement.id, FinishL) of
                        false ->
                            case lists:keyfind(FrontId, #achievement.id, AchievementL) of
                                #achievement{status = ?FINISH} -> true;
                                _ -> false
                            end;
                        _ -> true
                    end;
                false -> true
            end,
            %% 更新还是插入数据库
            case lists:keyfind(Id, #achievement.id, AchievementL) of
                false ->
                    NeedInsert = true,
                    OldAchievementInfo = #achievement{id = Id};
                OldAchievementInfo ->
                    NeedInsert = false
            end,
            #achievement{
                progress = OldProgress,
                status = Status,
                wtime = LastWtime
            } = OldAchievementInfo,
            case Status == ?UNFINISH andalso IsFrontFin of
                true ->
                    %% NewSurplus1 扣除当前进度剩余的数量，放入下次成就计算， Show：是否展示进度
                    {NewAchievementInfo, NewSurplus1} = lib_achievement_trigger:trigger(Args, Condition, 
                            OldAchievementInfo, Surplus, Show),
                    #achievement{progress = NewProgress, status = NewStatus} = NewAchievementInfo,
                    case IsInherit == 1 of
                        true  -> %% 继承前置成就进度
                            NewSurplus = NewProgress+NewSurplus1;
                        false -> % 不继承
                            NewSurplus = NewSurplus1
                    end,
                    case NewProgress =/= OldProgress orelse Status =/= NewStatus of
                        true ->
                            %% 杀怪的成就触发太频繁,只有第一次以及完成的时候才实时写入数据库,其他情况根据实际情况调整写入数据库的CD时间
                            SaveDBCD = case Args of
                                [{kill_mon, _}] -> 1800; %% category = 105
                                [{coin_get,_}] -> 300;   %% category = 108
                                _ -> ?SAVE_DB_CD
                            end,
                            case NewStatus == ?FINISH orelse LastWtime == 0 orelse NowTime - LastWtime >= SaveDBCD of
                                true ->
                                    case NeedInsert of
                                        true ->
                                            db:execute(io_lib:format(?insert_achievement,
                                                [RoleId, Id, NewProgress, NewStatus, NowTime]));
                                        false ->
                                            db:execute(io_lib:format(?update_achievement_progress,
                                                [NewProgress, NewStatus, NowTime, RoleId, Id]))
                                    end,
                                    NewAchievementLTmp = AchievementL,
                                    LastAchievementInfo = NewAchievementInfo#achievement{wtime = NowTime, wstatus = ?WSTATUS_SUCCESS};
                                _ ->    
                                    NewAchievementLTmp = AchievementL,
                                    LastAchievementInfo = NewAchievementInfo#achievement{wstatus = ?WSTATUS_WAIT}
                            end,
                            broadcast_info_add(Id, NewStatus, NewProgress),  %%%成就点
                            case NewStatus == ?FINISH of
                                true ->
                                    NewUCategoryL = [Category|UCategoryL];
                                false ->
                                    NewUCategoryL = UCategoryL
                            end,
                            NewAchievementL = lists:keystore(Id, #achievement.id, NewAchievementLTmp, LastAchievementInfo);
                        false ->
                            NewUCategoryL = UCategoryL,
                            NewAchievementL = AchievementL
                    end,
                    NewStatusAchievement = StatusAchievement#status_achievement{
                        achievement_list = NewAchievementL
                    },
                    if
                        NextId > 0 ->
                            do_trigger(L, RoleId, NewStatusAchievement, Args, NowTime, NewUCategoryL, NewSurplus);
                        true ->
                            do_trigger(remove_same_category(Category, L), RoleId, NewStatusAchievement, Args, NowTime, NewUCategoryL, NewSurplus)
                    end;
                    
                _ ->
                    do_trigger(L, RoleId, StatusAchievement, Args, NowTime, UCategoryL, Surplus)
            end;
        _ ->
            do_trigger(L, RoleId, StatusAchievement, Args, NowTime, UCategoryL, Surplus)
    end.

%% 计算当前标签所有成就的总星数
%count_total_star(Category) ->
    %TypeL = data_achievement:get_category_list(Category),
    % F = fun(TmpCategory, Sum) ->
    %     L = data_achievement:get_ids(TmpCategory),
    %     Sum + count_list_star(L)                 
    % end,
    % lists:foldl(F, 0, TypeL).
    % L = data_achievement:get_ids(Category),
    % count_list_star(L, 0).

remove_same_category(Category, CfgL) ->
    Fun = fun(#achievement_cfg{category = TemCategory} = H, Acc) ->
        if
            TemCategory == Category ->
                Acc;
            true ->
                [H|Acc]
        end
    end,
    lists:foldl(Fun, [], lists:reverse(CfgL)).
%=====私有方法===
%计算一个成就列表的总的成就点（星数）
% count_list_star([], Sum) -> Sum;
% count_list_star([H|T], Sum) ->
%     AchieCfg = data_achievement:get(H),
%     S = case AchieCfg of
%         #achievement_cfg{star = Star} ->
%             Sum + Star;
%         _ -> Sum
%     end,
    % % S = if
    % %     is_record(AchieCfg, achievement_cfg) == true ->
    % %         #achievement_cfg{star = Star} = AchieCfg,
    % %         Sum + Star;
    % %     false -> Sum
    % % end,
    % count_list_star(T, S).

%% 计算已达成的成就的总星数
count_star(RoleId) ->
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{star_map = StarMap} = StatusAchievement,
            count_star_by_star_map(StarMap);
        _ -> 0
    end.

count_star_by_star_map(StarMap) ->
    F = fun(_, Star, Sum) -> Sum + Star end,
    maps:fold(F, 0, StarMap).

%% 获取成就的前置成就id
get_front_id(1, _) ->0;
get_front_id(Category,Id) ->
    L = data_achievement:get_ids(Category),
    do_get_fron_id(L, Id).

do_get_fron_id([], _) -> 0;
do_get_fron_id([_], _) -> 0;
do_get_fron_id([FrontId, Id|_L], Id) -> FrontId;
do_get_fron_id([_FrontId, _Id|L], Id) ->
    do_get_fron_id([_Id|L], Id).

%% 刚开启成就时需要发

%% 发送成就小红点信息
send_tips_info(RoleId) ->
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{achievement_list = AchievementL} = StatusAchievement,
            F = fun(T, Acc) ->
                case T of
                    #achievement{id = Id, status = ?FINISH} ->
                        [Id|Acc];
                    _ -> Acc
                end
            end,
            PackL = lists:foldl(F, [], AchievementL),
            {ok, BinData} = pt_409:write(40900, [PackL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end.

send_achievement_summary(#player_status{id = RoleId} = Player) ->
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{star_map = _StarMap, star_reward_list = StarRewardL, stage = Stage} = StatusAchievement,
            % AchvPoint = count_star_by_star_map(StarMap),
            AchvPoint = lib_goods_api:get_currency(Player, ?GOODS_ID_ACHIEVE),
            AllStarL = data_achievement:get_reward_all_stage(),
            % CStar = get_need_star(Stage,0),
            PackStarRewardL = get_star_reward_state(AchvPoint, StarRewardL, AllStarL, []),
            {ok, BinData} = pt_409:write(40901, [Stage, PackStarRewardL, Stage]),
            % ?PRINT("PackStarRewardL:~p,StarRewardL:~p~n",[PackStarRewardL,StarRewardL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end.

get_star_reward_state(_AchvPoint, _StarRewardL, [], Acc) -> Acc;
get_star_reward_state(AchvPoint, StarRewardL, [Stage|T], Acc) ->
    if
        Stage == 1 ->
            get_star_reward_state(AchvPoint, StarRewardL, T, Acc);
        true ->
            case lists:keyfind(Stage, 1, StarRewardL) of
                false ->
                    case data_achievement:get_star_by_stage(Stage) of
                        [Star] -> skip;
                        _ ->
                            ?ERR("no_achieve_stage_cfg: stage:~p~n",[Stage]), 
                            Star = 999999
                    end,
                    case AchvPoint >= Star of
                        true -> get_star_reward_state(AchvPoint - Star, StarRewardL, T, [{Stage, ?FINISH}|Acc]);
                        false -> get_star_reward_state(AchvPoint, StarRewardL, T, Acc)
                    end;
                _ -> 
                    % get_star_reward_state(AchvPoint, StarRewardL, T, [{Stage, ?HAS_RECEIVE}|Acc])
                    get_star_reward_state(AchvPoint, StarRewardL, T, Acc)
            end
    end.
    

% get_need_star(1, Sum) ->Sum;
% get_need_star(Stage, Sum) ->
%     case data_achievement:get_star_by_stage(Stage) of
%         [Star] -> New = Sum + Star;
%         _ -> New = Sum
%     end,
%     get_need_star(Stage - 1, New).

get_real_stage(CStar, Stage)  ->
    case data_achievement:get_star_by_stage(Stage+1) of
        [Star] when CStar >= Star-> 
            get_real_stage(CStar - Star, Stage + 1);
        _ -> 
            Stage
    end.
% send_reward_help(NewStage, NewStage, StarRewardL, _PlayerStatus, _NowTime) -> StarRewardL;
% send_reward_help(NewStage, Stage, StarRewardL, PlayerStatus, NowTime) ->
%     if
%         NewStage > Stage ->
%             case data_achievement:get_star_by_stage(Stage + 1) of
%                 [TotalStar] -> skip;
%                 _ -> TotalStar = 0
%             end,
%             db:execute(io_lib:format(?insert_achievement_star_reward, [PlayerStatus#player_status.id, TotalStar, ?HAS_RECEIVE, NowTime])),
%             NewStarRewardL = [{TotalStar, ?HAS_RECEIVE}|StarRewardL];
%         true ->
%             NewStarRewardL = StarRewardL
%     end,
%     send_reward_help(NewStage, Stage + 1, NewStarRewardL, PlayerStatus, NowTime).

send_achievement_list(RoleId) ->        %将要显示的成就列表发过去
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{finish_list = FinishL, achievement_list = AchievementL} = StatusAchievement,
            CategoryL = data_achievement:get_category_list(),
            F = fun(TmpCategory, Acc) ->
                L = data_achievement:get_ids(TmpCategory),
              
                case get_cur_achievement(L, AchievementL, FinishL) of
                    #achievement{id = Id, progress = Progress, status = Status} ->
                        case data_achievement:get(Id) of
                            #achievement_cfg{star = _Star} ->
                                [{TmpCategory, Id, Progress, Status}|Acc];
                            _ -> Acc
                        end;
                    _ -> Acc
                end
            end,
            PackL = lists:foldl(F, [], CategoryL),
            {ok, BinData} = pt_409:write(40903, [PackL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end.

send_achievement_all(RoleId, Category) ->
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{finish_list = FinishL, achievement_list = AchievementL} = StatusAchievement,
            L = data_achievement:get_ids(Category),
            Fun = fun(Id, Acc) ->
                case lists:keyfind(Id, #achievement.id, AchievementL) of
                    #achievement{id = Id, progress = Progress, status = Status} -> 
                        [{Id, Progress, Status}|Acc];
                    false ->
                        case lists:keyfind(Id, #achievement.id, FinishL) of
                            #achievement{id = Id, progress = Progress, status = Status} ->
                                [{Id, Progress, Status}|Acc];
                            false -> 
                                [{Id, 0, ?UNFINISH}|Acc]
                        end
                end
            end,
            PackL = lists:foldl(Fun, [], L),
            {ok, BinData} = pt_409:write(40909, [Category, PackL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end.

%% 玩家进程执行
check_before_recieve_reward(PlayerStatus, Id) ->
    RoleId = PlayerStatus#player_status.id,
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{finish_list = FinishL, achievement_list = AchievementL} = StatusAchievement,
            FinishRes = lists:keyfind(Id, #achievement.id, FinishL),
            Achiv = lists:keyfind(Id, #achievement.id, AchievementL),
            AchivCfg = data_achievement:get(Id),
            if
                FinishRes =/= false -> {false, ?ERRCODE(err409_has_received)};
                is_record(Achiv, achievement) == false -> {false, ?ERRCODE(err409_not_finish)};
                is_record(AchivCfg, achievement_cfg) == false -> {false, ?ERRCODE(missing_config)};
                true ->
                    #achievement{status = Status} = Achiv,
                    #achievement_cfg{reward = RewardL} = AchivCfg,
                    Res = lib_goods_api:can_give_goods(PlayerStatus, RewardL),
                    if
                        Status =/= ?FINISH -> {false, ?ERRCODE(err409_not_finish)};
                        Res =/= true -> Res;
                        true ->
                            {ok, StatusAchievement, AchivCfg, Achiv}
                    end
            end;
        _ -> 
            {false, ?ERRCODE(err409_not_finish)}
    end.


%% 领取成就达成奖励
receive_reward(PlayerStatus, Id) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure} = PlayerStatus,
    #figure{lv = RoleLv} = Figure,
    case check_before_recieve_reward(PlayerStatus, Id) of
        {_, Code} -> send_errorcode_05(Sid, Code);
        {ok, StatusAchievement, AchivCfg, Achiv} ->
            #status_achievement{  
                finish_list = FinishL, 
                achievement_list = AchievementL, 
                star_map = StarMap,
                type_list = TypeList,
                type_star_list = TotalCategoryStarL
            } = StatusAchievement,
            #achievement_cfg{
                reward = RewardL,
                category = Category,
                star = Star
            } = AchivCfg,
            NowTime = utime:unixtime(),
            db:execute(io_lib:format(?update_achievement_status, [?HAS_RECEIVE, NowTime, RoleId, Id])),
            NewAchievementL = lists:keydelete(Id, #achievement.id, AchievementL),
            NewFinishL = [Achiv#achievement{status = ?HAS_RECEIVE}|FinishL],
            PreStar = maps:get(Category, StarMap, 0),
            NewStarMap = maps:put(Category, PreStar + Star, StarMap),
            
            LastPlayer = lib_goods_api:send_reward(PlayerStatus, [{?TYPE_CURRENCY, ?GOODS_ID_ACHIEVE, Star}], achievement_reward, 0),   
            AchvPoint = lib_goods_api:get_currency(LastPlayer, ?GOODS_ID_ACHIEVE),
            Type = get_category_achiv_type(Category),
            case lists:keyfind(Type, 1, TypeList) of
                {Type, Total, Now} ->
                    NewTypeList = lists:keystore(Type, 1, TypeList, {Type, Total, Now + Star});
                _ ->
                    case lists:keyfind(Type, 1, TotalCategoryStarL) of
                        {Type, Total} ->
                            NewTypeList = lists:keystore(Type, 1, TypeList, {Type, Total, Star});
                        _ ->
                            ?ERR("missing_config Type:~p, TotalCategoryStarL:~p~n",[Type,TotalCategoryStarL]),
                            NewTypeList = TypeList
                    end
            end,
            NowCompleteAchivPoint = get_achiev_point_complete(NewTypeList),
            {ok, Bin} = pt_409:write(40908, [NewTypeList]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewStatusAchievement = StatusAchievement#status_achievement{
                    star_map = NewStarMap,
                    finish_list = NewFinishL,
                    achievement_list = NewAchievementL,
                    type_list = NewTypeList
            },
            save_achievement_dict(NewStatusAchievement),
            Produce = #produce{type = achievement_reward, subtype = 0, reward = RewardL, remark = "", show_tips = 1},
            NewPlayerStatus = lib_goods_api:send_reward(LastPlayer, Produce),
            send_current_star(NewPlayerStatus),
            {ok, BinData} = pt_409:write(40905, [?SUCCESS,1]),
            % ?PRINT("40905, SUCCESS:~p~n", [?SUCCESS]),
            lib_server_send:send_to_sid(Sid, BinData),
            send_achievement_list(RoleId),
            lib_log_api:log_achv(RoleId, RoleLv, Id, AchvPoint),%%领取成就就写入日志
            %% TA 系统
            ta_agent_fire:log_achv(PlayerStatus, [Id, AchvPoint]),
            % lib_task_api:achv_award(NewPlayerStatus, Id),
            lib_achievement_api:get_achv_reward(NewPlayerStatus, Id),
            lib_achievement_api:achv_stage_reward_event(LastPlayer, NowCompleteAchivPoint),
            {ok, NewPlayerStatus};
        _ -> skip
    end.

%% 获取当前类型成就需要显示的成就信息
get_cur_achievement([], _AchievementL, _FinishL) -> [];
get_cur_achievement([Id|L], AchievementL, FinishL) ->
    case lists:keyfind(Id, #achievement.id, AchievementL) of
        false ->
            case lists:keyfind(Id, #achievement.id, FinishL) of
                AchievementInfo when is_record(AchievementInfo, achievement) ->
                    case L =/= [] of
                        true ->
                            get_cur_achievement(L, AchievementL, FinishL);
                        false ->
                            AchievementInfo
                    end;
                false -> #achievement{id = Id, status = ?UNFINISH}
            end;
        AchievementInfo -> AchievementInfo
    end.

%% 
check_before_stage_up(PlayerStatus, Stage1) ->
    #player_status{id = RoleId} = PlayerStatus,
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{star_reward_list = StarRewardL, stage = Stage} = StatusAchievement,
            List = data_achievement:get_star_by_stage(Stage1),
            StarRewardCfg = data_achievement:get_star_reward(Stage1),
            if
                List == [] -> {false, ?ERRCODE(missing_config)};
                is_record(StarRewardCfg, star_reward_cfg) == false -> {false, ?ERRCODE(missing_config)};
                Stage1 < 2 orelse Stage1 =/= Stage+1 -> {false, ?ERRCODE(err409_error_data)};
                true ->
                    case lists:keyfind(Stage1, 1, StarRewardL) of
                        {Stage1, _S} when _S == ?HAS_RECEIVE -> {false, ?ERRCODE(err409_has_received)};
                        _ -> 
                            [Star|_] = List,
                            Cost = [{?TYPE_CURRENCY, ?GOODS_ID_ACHIEVE, Star}],
                            {ok, StatusAchievement, Cost}
                    end
            end;
        _ -> skip
    end.
%% 领取成就总览星级奖励
receive_star_reward(PlayerStatus, Stage1) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure} = PlayerStatus,
    case check_before_stage_up(PlayerStatus, Stage1) of
        {ok, StatusAchievement, Cost} ->
            #status_achievement{star_reward_list = StarRewardL, stage = Stage} = StatusAchievement,
            NowTime = utime:unixtime(),
            case lib_goods_api:cost_object_list_with_check(PlayerStatus, Cost,  achv_up_stage, "") of
                {false, _Code, _NewPs} ->
                    send_errorcode_02(Sid, Stage1, ?ERRCODE(err409_has_received));
                {true, NewPs} ->
                    db:execute(io_lib:format(?insert_achievement_star_reward, [RoleId, Stage1, ?HAS_RECEIVE, NowTime])),
                    NewStage = Stage + 1,
                    NewStarRewardL = [{Stage1, ?HAS_RECEIVE}|StarRewardL],
                    NewStatusAchievement = StatusAchievement#status_achievement{star_reward_list = NewStarRewardL, stage = NewStage},
                    save_achievement_dict(NewStatusAchievement),
                    NewFigure = Figure#figure{achiv_stage = NewStage},
                    NewP = NewPs#player_status{status_achievement = NewStarRewardL, 
                        figure = NewFigure},
                    NewPlayerStatus = lib_player:count_player_attribute(NewP),
                    % ?PRINT("OldCombat:~p,NewComBat:~p~n",[NewP#player_status.combat_power,NewPlayerStatus#player_status.combat_power]),
                    lib_player:send_attribute_change_notify(NewPlayerStatus, ?NOTIFY_ATTR),
                    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
                    PSAfterStageUp = lib_achievement_api:achv_stage_up_event(NewPlayerStatus, NewStage),
                    mod_scene_agent:update(NewPlayerStatus, [{achiv_stage, NewStage}]),
                    {ok, BinData} = pt_409:write(40902, [NewStage, ?SUCCESS, 1, NewStage]),
                    %?PRINT("40902, SUCCESS:~p~n", [?SUCCESS]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, BinData1} = pt_409:write(40907, [[{Stage1, ?HAS_RECEIVE}],NewStage, NewStage]),
                    lib_server_send:send_to_sid(Sid, BinData1),
                    
                    {ok, PSAfterStageUp}
            end;
        {_, Code} ->
            send_errorcode_02(Sid, Stage1, Code)
    end.

broadcast_info_add(Id, Status, Progress) ->
    case get(broadcast_info) of
        Val when is_list(Val) ->
            case lists:member({Id, Status, Progress}, Val) of     %%这里添加了TotalStar
                false ->
                    put(broadcast_info, [{Id, Status, Progress}|Val]);
                _ -> skip
            end;
        _ -> skip
    end.

notify_to_client(?NOTIFY_TYPE_STAR_NUM, #player_status{id = RoleId} = Player, UCategoryL) ->
    %?PRINT("40906~p~n", [1]),
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{star_map = StarMap, star_reward_list = _StarRewardL, stage = Stage} = StatusAchievement,
            F = fun(Category, TmpUStarL) ->
                Star = maps:get(Category, StarMap, 0),
                NewUStarL = [{Category, Star}|TmpUStarL],
                NewUStarL
            end,
            UStarL = lists:foldl(F, [], UCategoryL),
            case UStarL =/= [] of
                true ->
                    TotalStar = lib_goods_api:get_currency(Player, ?GOODS_ID_ACHIEVE), 
                    case data_achievement:get_star_by_stage(Stage + 1) of
                        [StarCfg] ->
                            if
                                StarCfg =< TotalStar ->
                                    URewardL = [{Stage + 1, ?FINISH}];
                                true ->
                                    URewardL = []
                            end;
                        _ ->
                            URewardL = []
                    end,
                    %% 星数改变了刷新排行榜
                    %catch lib_common_rank_api:reflash_rank_by_achieve(RoleId),
                    %暂时不管成就排行榜
                    {ok, BinData} = pt_409:write(40906, [TotalStar]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                false -> URewardL = []
            end,
            case URewardL =/= [] of
                true ->
                    {ok, BinData1} = pt_409:write(40907, [URewardL,Stage,Stage]),
                    lib_server_send:send_to_uid(RoleId, BinData1);
                false -> skip
            end;
        _ -> skip
    end.

send_current_star(PlayerStatus) ->
    #player_status{id = RoleId} = PlayerStatus,
    TotalStar = lib_goods_api:get_currency(PlayerStatus, ?GOODS_ID_ACHIEVE), 
    {ok, BinData} = pt_409:write(40906, [TotalStar]),
    lib_server_send:send_to_uid(RoleId, BinData).


%% 通过Key筛选出符合的成就配置
filter_achievement_cfg_by_key([], _, ResultL) ->
    lists:sort(ResultL);
filter_achievement_cfg_by_key([Id|L], Key, ResultL) ->
    case data_achievement:get(Id) of
        #achievement_cfg{condition = Condition} = Cfg ->
            case lists:keyfind(Key, 1, Condition) of
                false ->
                    filter_achievement_cfg_by_key(L, Key, ResultL);
                _ ->
                    filter_achievement_cfg_by_key(L, Key, [Cfg|ResultL])
            end;
        _ ->
            filter_achievement_cfg_by_key(L, Key, ResultL)
    end.

%% 获取完成成就的数量
get_fin_num(RoleId) -> 
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{finish_list = FinishL} = StatusAchievement,
            length(FinishL);
        _ -> 0
    end.

%% 获取完成成就完成id列表
get_fin_ids(RoleId) -> 
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{finish_list = FinishL} = StatusAchievement,
            [E#achievement.id || E <- FinishL];
        _ -> []
    end.

%% 发送错误码
% send_error_code(Sid, ErrorCode) ->
%     {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
%     {ok, BinData} = pt_102:write(10205, [ErrorCodeInt, ErrorCodeArgs]),
%     lib_server_send:send_to_sid(Sid, BinData).
send_errorcode_02(Sid, Stage1, ErrorCode) -> %40902协议
    {ok, BinData} = pt_409:write(40902, [Stage1, 0, ErrorCode, Stage1]),
    lib_server_send:send_to_sid(Sid, BinData).
send_errorcode_05(Sid, ErrorCode) ->
    {ok, BinData} = pt_409:write(40905, [0, ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).

get_attr_reward_list(Star) ->
    case data_achievement:get_star_reward(Star) of
        #star_reward_cfg{reward = RewardL} ->skip;
        _ ->RewardL = []
    end,
    RewardL.

send_achievement_type_state(PlayerStatus) ->
    #player_status{id = RoleId} = PlayerStatus,
    case get_achievement_dict(RoleId) of
        {ok, StatusAchievement} ->
            #status_achievement{type_list = TypeList} = StatusAchievement,
            {ok, BinData} = pt_409:write(40908, [TypeList]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end,
    {ok, PlayerStatus}.

get_category_achiv_type(Category) ->
    AchieveTypeList = data_achievement:get_all_achv_type(),
    case data_achievement:get_category_type(Category) of
        TypeC when is_integer(TypeC) andalso TypeC > 0 ->
            IsMember = lists:member(TypeC, AchieveTypeList),
            if
                IsMember ->
                    Type = TypeC;
                true ->
                    Type = 1
            end;
        _ -> Type = 1
    end,
    Type.

get_total_achieve_point() ->
    CategoryList = data_achievement:get_category_list(),
    Fun = fun(Category, {Acc, AllStar}) ->
        AchvIdList = data_achievement:get_ids(Category),
        F1 = fun(AchvId, Sum) ->
            #achievement_cfg{star = Star} = data_achievement:get(AchvId),
            Sum+Star
        end,
        CategoryStar = lists:foldl(F1, 0, AchvIdList),
        Type = get_category_achiv_type(Category),
        case lists:keyfind(Type, 1, Acc) of
            {Type, Num} ->
                NewAcc = lists:keystore(Type, 1, Acc, {Type, Num + CategoryStar});
            _ -> 
                NewAcc = lists:keystore(Type, 1, Acc, {Type, CategoryStar})
        end,
        {NewAcc, AllStar+CategoryStar}
    end,
    lists:foldl(Fun, {[], 0}, CategoryList).

get_achiev_point_complete(TypeList) ->
    Fun = fun({_, _, NowStar}, Sum) ->
        Sum+NowStar
    end,
    lists:foldl(Fun, 0, TypeList).

%% 获取Key相关的系列成就当前进度
%% @return Progress :: integer()
get_progress(PlayerId, Key) ->
    AllIds = data_achievement:get_all_achievement_ids(),
    CfgL = filter_achievement_cfg_by_key(AllIds, Key, []),
    AIds = [AId || #achievement_cfg{id = AId} <- CfgL],
    F = fun(AId, MaxProgress) ->
        case db:get_row(io_lib:format(?SELECT_ACHV_BYID, [PlayerId, AId])) of
            [Progress, _] when Progress > MaxProgress ->
                Progress;
            _ ->
                MaxProgress
        end
    end,
    lists:foldl(F, 0, AIds).

%%% ================================ 秘籍 ================================

gm_reset(#player_status{id = RoleId, figure = Figure} = Player) ->
    F = fun() ->
        db:execute(io_lib:format(<<"delete from achievement where role_id = ~p">>, [RoleId])),
        db:execute(io_lib:format(<<"delete from achievement_star_reward where role_id = ~p">>, [RoleId]))
    end,
    db:transaction(F),
    login(RoleId),
    lib_achievement:send_tips_info(RoleId),
    lib_achievement:send_achievement_summary(Player),
    NewPlayer = Player#player_status{figure = Figure#figure{achiv_stage = 1}, status_achievement = []},
    NewPlayer.

gm_complete_achv(PlayerStatus, Category) ->
    #player_status{figure = Figure} = PlayerStatus,
    #figure{lv = RoleLv} = Figure,
    AchvL = data_achievement:get_ids(Category),
    ?PRINT("AchvL:~p~n",[AchvL]),
    F = fun(AchvId) ->
        case data_achievement:get(AchvId) of
            #achievement_cfg{condition = [{Key, Data}]} ->
                trigger(PlayerStatus, RoleLv, Key, [{Key, Data}]);
            _ ->
                skip
        end
    end,
    lists:foreach(F, AchvL).

%% 统计跨服市场的数据,后传递给本服进程汇总计算
gm_recalc_achievement_sell_sell() ->
    % 跨服市场交易日志查询
    Sql = io_lib:format(
        "select unit_price, tax, seller_id, seller_server_id
        from log_sell_pay_kf
        where seller_id > 0", []),
    LogList = db:get_all(Sql),
    % 分服统计
    F1 = fun([Price, Tax, SellerId, SerId], AccM) ->
        SellerM = maps:get(SerId, AccM, #{}),
        ONum = maps:get(SellerId, SellerM, 0),
        NSellerM = maps:put(SellerId, ONum+Price-Tax, SellerM),
        maps:put(SerId, NSellerM, AccM)
    end,
    SerMap = lists:foldl(F1, #{}, LogList),
    % 分发到各服执行
    F2 = fun({SerId, SellerM}) ->
        mod_clusters_center:apply_cast(SerId, ?MODULE, gm_recalc_achievement_sell_sell_local, [SellerM])
    end,
    lists:foreach(F2, maps:to_list(SerMap)),
    ok.

%% 因之前未计算离线所达成的成就,要重新计算玩家在市场获得钻石的系列成就(AId = 10900X)
%% @param Map0 :: #{SellerId => KfData}
gm_recalc_achievement_sell_sell_local(Map0) ->
    % 本服市场交易日志查询
    Sql = io_lib:format(
        "select unit_price, tax, seller_id
        from log_sell_pay
        where seller_id > 0", []),  % 不取系统出售
    % 汇总各玩家在市场获得的总钻石数
    LogList = db:get_all(Sql),
    F1 = fun([Price, Tax, SellerId], AccM) ->
        ONum = maps:get(SellerId, AccM, 0),
        maps:put(SellerId, ONum+Price-Tax, AccM)
    end,
    Map1 = lists:foldl(F1, Map0, LogList),
    % 获取实际进度与当前进度的差值
    Key = 'sell_sell',
    F2 = fun(SellerId, RealProgress, AccM) ->
        CurProgress = get_progress(SellerId, Key),
        case RealProgress > CurProgress of
            true ->
                Diff = RealProgress-CurProgress,
                maps:put(SellerId, Diff, AccM);
            false ->
                maps:remove(SellerId, AccM)
        end
    end,
    Map2 = maps:fold(F2, #{}, Map1),
    % 补回成就进度差值
    F3 = fun({SellerId, Diff}) ->
        outline_trigger(SellerId, Key, [{Key, Diff}])
    end,
    lists:foreach(F3, maps:to_list(Map2)),
    % 更新在线玩家数据
    [lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, ?MODULE, gm_refresh_achievement_data, []) || Id <- lib_online:get_online_ids()],
    ok.

gm_refresh_achievement_data(PS) ->
    #player_status{id = PlayerId, figure = Figure} = PS,
    {_, StarRewardL, AchvStage} = lib_achievement:login(PlayerId),
    NewPS = PS#player_status{status_achievement = StarRewardL, figure = Figure#figure{achiv_stage = AchvStage}},
    CmdList = [40900, 40901, 40903, 40906, 40908],  % 需要刷新的协议列表
    [pp_achievement:handle(Cmd, NewPS, []) || Cmd <- CmdList],
    {ok, NewPS}.