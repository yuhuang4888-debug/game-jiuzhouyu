%%-----------------------------------------------------------------------------
%% @Module  :       lib_achievement_trigger
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-23
%% @Description:    成就触发逻辑模块
%%-----------------------------------------------------------------------------
-module(lib_achievement_trigger).

-include("rec_achievement.hrl").
-include("common.hrl").
-include("goods.hrl").
-export([trigger/5]).

calc_progress(Data, CfgLimit, Show, State) ->
    if
        Show == 1 andalso State == ?FINISH->
            NewProgress = CfgLimit;
        Show == 1 ->
            NewProgress = Data;
        true ->
            NewProgress = 1
    end,
    NewProgress.



trigger([], _, AchievementInfo, Surplus, _) -> {AchievementInfo, Surplus};
trigger([{vip_lv, Lv}|L], [{vip_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{role_lv, Lv}|L], [{role_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{role_turn, RoleTurn}|L], [{role_turn, NeedRoleTurn}] = Condition, AchievementInfo, Surplus, Show) when is_integer(RoleTurn) ->
    case RoleTurn >= NeedRoleTurn of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(RoleTurn, NeedRoleTurn, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(RoleTurn, NeedRoleTurn, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wing_star, _Stage, Star}|L], [{wing_star,NeedStar}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Star) ->
    case Star >= NeedStar of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Star, NeedStar, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Star, NeedStar, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{holyorgan_lv, Lv}|L], [{holyorgan_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv  >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{artifact_lv, Lv}|L], [{artifact_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mount_stage, Stage, Star}|L], [{mount_star, NeedStar},{mount_stage, NeedStage}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Stage) ->
    case Stage  > NeedStage of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Stage, NeedStage, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            if
                Stage == NeedStage andalso Star >= NeedStar  ->
                    NewStatus = ?FINISH,
                    NewProgress = calc_progress(Stage, NeedStage, Show, NewStatus),
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                true ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Stage, NeedStage, Show, ?UNFINISH)}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mate_stage, Stage, Star}|L], [{mate_star, NeedStar},{mate_stage, NeedStage}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Stage) ->
    case Stage  > NeedStage of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Stage, NeedStage, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            if
                Stage == NeedStage andalso Star >= NeedStar  ->
                    NewStatus = ?FINISH,
                    NewProgress = calc_progress(Stage, NeedStage, Show, NewStatus),
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                true ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Stage, NeedStage, Show, ?UNFINISH)}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{spirit_stage, Lv}|L], [{spirit_stage, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    %io:format("spirit_lv:~p~n",[Lv]),
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{pet_lv, Lv}|L], [{pet_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) -> 
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{figure_active, _}|L], [{figure_active, NeedNum}] = Condition, AchievementInfo, Surplus, _Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, _Show);

%% TODO :策划说幻形成就放在一起！！
trigger([{wing_name, Total}|L], [{wing_name, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{holyorgan_name, Total}|L], [{holyorgan_name, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{artifact_name, Total}|L], [{artifact_name, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mount_name, Total}|L], [{mount_name, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mate_name, Total}|L], [{mate_name, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{spirit_name, Total}|L], [{spirit_name, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{pet_name, Total}|L], [{pet_name, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{equip_stren, Lv}|L], [{equip_stren, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv)-> 
     #achievement{progress = OldProgress} = AchievementInfo,
     case Lv >= NeedLv of
        true ->
            NewProgress = NeedLv,
            NewStatus = ?FINISH,
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            case Lv >= OldProgress of %%强化，精炼存在换低品质装备数值减小的情况，这里做特殊处理
                true ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = Lv};
                false ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = OldProgress}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{equip_refine, Lv}|L], [{equip_refine, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv)->
     #achievement{progress = OldProgress} = AchievementInfo,
     case Lv >= NeedLv of
        true ->
            NewProgress = NeedLv,
            NewStatus = ?FINISH,
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            case Lv >= OldProgress of %%强化，精炼存在换低品质装备数值减小的情况，这里做特殊处理
                true ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = Lv};
                false ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = OldProgress}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{equip_stone, Lv}|L], [{equip_stone, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv)->
     #achievement{progress = OldProgress} = AchievementInfo,
     case Lv >= NeedLv of
        true ->
            NewProgress = NeedLv,
            NewStatus = ?FINISH,
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            case Lv >= OldProgress of %%强化，精炼存在换低品质装备数值减小的情况，这里做特殊处理
                true ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = Lv};
                false ->
                    NewAchievementInfo = AchievementInfo#achievement{progress = OldProgress}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);    
trigger([{attr_color_green, Num}|L], [{attr_color_green, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{attr_color_blue, Num}|L], [{attr_color_blue, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{attr_color_purple, Num}|L], [{attr_color_purple, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{attr_color_orange, Num}|L], [{attr_color_orange, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{attr_color_red, Num}|L], [{attr_color_red, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{medal_lv, Lv}|L], [{medal_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv)->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{dungeon_enchantment_floor, Level}|L], [{dungeon_enchantment_floor, NeedGate}] = Condition, AchievementInfo, Surplus, Show) ->
    case Level >= NeedGate of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Level, NeedGate, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Level, NeedGate, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{cuple_pass, _}|L], [{cuple_pass, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{kill_player_num, _}|L], [{kill_player_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{join_guild, _Id}|L], [{join_guild, _NeedId}] = Condition, AchievementInfo, Surplus, _Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, _Show);
trigger([{guild_donate, _}|L], [{guild_donate, NeedNum}] = Condition, AchievementInfo, Surplus, _Show)->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, _Show);
trigger([{login_days, _}|L], [{login_days, NeedNum}] = Condition, AchievementInfo, Surplus, _Show)->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, _Show);
trigger([{jjc_rank, Ranking}|L], [{jjc_rank, NeedRanking}] = Condition, AchievementInfo, Surplus, _Show) when Ranking =< NeedRanking ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, _Show);
trigger([{combat, Combat}|L], [{combat,NeedCombat}] = Condition, AchievementInfo, Surplus, Show) ->
    case Combat >= NeedCombat of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Combat, NeedCombat, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Combat, NeedCombat, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{combat_rank, Rank}|L], [{combat_rank,NeedRank}] = Condition, AchievementInfo, Surplus, Show) ->
    case Rank >= NeedRank of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Rank, NeedRank, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Rank, NeedRank, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{tower_floor, Floor}|L], [{tower_floor,NeedFloor}] = Condition, AchievementInfo, Surplus, Show) ->
    case Floor >= NeedFloor of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Floor, NeedFloor, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Floor, NeedFloor, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{juewei_lv, Lv}|L], [{juewei_lv,NeedLv}] = Condition, AchievementInfo, Surplus, Show) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{number_designation, Num}|L], [{number_designation,NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{kill_world_boss, _}|L], [{world_boss, NeedNum}] = Condition, AchievementInfo, Surplus, _Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, _Show);
trigger([{kill_boss_home, _}|L], [{boss_home, NeedNum}] = Condition, AchievementInfo, Surplus, _Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, _Show);
trigger([{kill_eudemons_boss, _}|L], [{ai_boss, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{abyss_boss, BossLv}|L], [{abyss_boss, NeedLv}] = Condition, AchievementInfo, Surplus, Show) ->
    case BossLv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(BossLv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(BossLv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{forbidden_boss, BossLv}|L], [{forbidden_boss, NeedLv}] = Condition, AchievementInfo, Surplus, Show) ->
    case BossLv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(BossLv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(BossLv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{outside_boss, BossLv}|L], [{outside_boss, NeedLv}] = Condition, AchievementInfo, Surplus, Show) ->
    case BossLv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(BossLv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(BossLv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{phantom_boss, BossLv}|L], [{phantom_boss, NeedLv}] = Condition, AchievementInfo, Surplus, Show) ->
    case BossLv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(BossLv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(BossLv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{personal_boss, DunId}|L], [{personal_boss, NeedDunId}] = Condition, AchievementInfo, Surplus, Show) ->
    case DunId >= NeedDunId of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(DunId, NeedDunId, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(DunId, NeedDunId, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{fairyland_num, _}|L], [{fairyland_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{phantom_num, _}|L], [{phantom_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);   
trigger([{abyss_num, _}|L], [{abyss_num,NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{forbidden_num, _}|L], [{forbidden_num,NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{outside_num, _}|L], [{outside_num,NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{decoration_num, _}|L], [{decoration_num,NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{personal_num, _}|L], [{personal_num,NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{purple_pic, _}|L], [{purple_pic, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{orange_pic, _}|L], [{orange_pic, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{red_pic, _}|L], [{red_pic, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{wear_orange_equip, _}|L], [{wear_orange_equip, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_ring, _}|L], [{wear_ring, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_bracelet, _}|L], [{wear_bracelet, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_necklace, _}|L], [{wear_necklace, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_amulet, _}|L], [{wear_amulet, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{compose_red_equip, _}|L], [{compose_red_equip, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{immortal_equip, Num}|L], [{immortal_equip, NeedNum}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Num) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{immortal_equip_suit, List}|L], [{immortal_equip_suit, NeedNum, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_list(List) ->
    Fun = fun({TemLv, TemNum}, Sum) ->
        if
            TemLv >= NeedLv ->
                Sum + TemNum;
            true ->
                Sum  
        end
    end,
    Num = lists:foldl(Fun, 0, List),
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{immortal_ornament_suit, List}|L], [{immortal_ornament_suit, NeedNum, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_list(List) ->
    Fun = fun({TemLv, TemNum}, Sum) ->
        if
            TemLv >= NeedLv ->
                Sum + TemNum;
            true ->
                Sum  
        end
    end,
    Num = lists:foldl(Fun, 0, List),
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{god_equip_suit, List}|L], [{god_equip_suit, NeedNum, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_list(List) ->
    Fun = fun({TemLv, TemNum}, Sum) ->
        if
            TemLv >= NeedLv ->
                Sum + TemNum;
            true ->
                Sum  
        end
    end,
    Num = lists:foldl(Fun, 0, List),
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{god_ornament_suit, List}|L], [{god_ornament_suit, NeedNum, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_list(List) ->
    Fun = fun({TemLv, TemNum}, Sum) ->
        if
            TemLv >= NeedLv ->
                Sum + TemNum;
            true ->
                Sum  
        end
    end,
    Num = lists:foldl(Fun, 0, List),
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{god_equip, Num}|L], [{god_equip, NeedNum}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Num) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{dungeon_rune_pass, Level}|L], [{dungeon_rune, NeedTimes}] = Condition, AchievementInfo, Surplus, Show) ->
    case Level >= NeedTimes of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Level, NeedTimes, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Level, NeedTimes, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{dungeon_exp_pass, _}|L], [{dungeon_exp, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_exp_encourage, Type}|L], [{times, NeedNum}, {exp_encourage, Type}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    case Type == Type of
        true ->
            if
                Surplus =/= 0 ->
                    case Progress + Surplus >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + Surplus - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
                    end;
                true ->
                    case Progress + 1 >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + 1 - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
                    end
            end;
        _ ->
            NewSurplus = 0,
            NewAchievementInfo = AchievementInfo
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{guild_quiz_correct, _}|L], [{guild_quiz_correct, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{guild_battle_win, _}|L], [{guild_battle_win, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{guild_battle_break, _}|L], [{guild_battle_break, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_equip_stage, EquipList}|L], [{equip_stage, NeedStage},{equip_color, NeedColor},{equip_star, NeedStar},{equip_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    F = fun(GoodsInfo, Acc) when is_record(GoodsInfo, goods) ->
        #goods{color = Color} = GoodsInfo,
        EquipStage = lib_equip_api:get_equip_stage(GoodsInfo),
        EquipStar = lib_equip_api:get_equip_star(GoodsInfo),
        case EquipStage >= NeedStage andalso Color >= NeedColor andalso EquipStar >= NeedStar of
            true -> Acc + 1;
            false -> Acc
        end;
       (_, Acc) -> Acc
    end,
    Sum = lists:foldl(F, 0, EquipList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_equip_star, EquipList}|L], [{equip_stage2, NeedStage},{equip_num2, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    F = fun(GoodsInfo, Acc) when is_record(GoodsInfo, goods) ->
        #goods{color = Color} = GoodsInfo,
        EquipStage = lib_equip_api:get_equip_stage(GoodsInfo),
        EquipStar = lib_equip_api:get_equip_star(GoodsInfo),
        if
            EquipStar >= 2 ->
                case EquipStage >= NeedStage andalso Color >= 5 of
                    true -> Acc + 1;
                    false -> Acc
                end;
            true ->
                Acc
        end;
        (_, Acc) -> Acc
    end,
    Sum = lists:foldl(F, 0, EquipList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_equip_star2, EquipList}|L], [{equip_stage3, NeedStage},{equip_num3, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    F = fun(GoodsInfo, Acc) when is_record(GoodsInfo, goods) ->
        #goods{color = Color} = GoodsInfo,
        EquipStage = lib_equip_api:get_equip_stage(GoodsInfo),
        EquipStar = lib_equip_api:get_equip_star(GoodsInfo),
        if
            EquipStar >= 3 ->
                case EquipStage >= NeedStage andalso Color >= 5 of
                    true -> Acc + 1;
                    false -> Acc
                end;
            true ->
                Acc
        end;
        (_, Acc) -> Acc
    end,
    Sum = lists:foldl(F, 0, EquipList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{seal_stren, EquipList}|L], [{seal_stren, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    F = fun({_, Stren}, Acc) ->
        Stren + Acc
    end,
    Sum = lists:foldl(F, 0, EquipList),
    case Sum >= NeedNum of
        true ->
            NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH};
        false -> NewAchievementInfo = AchievementInfo
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{seal_equip, EquipList}|L], [{seal_stage, NeedStage},{seal_equip, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    F = fun({Color, Stage}, Acc) ->
        if
            Color >= 4 andalso Stage >= NeedStage ->
                Acc+1;
            true ->
                Acc
        end
    end,
    Sum = lists:foldl(F, 0, EquipList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_equip_attr_def, Def}|L], [{wear_equip_attr_def, NeedDef}] = Condition, AchievementInfo, Surplus, Show) ->
    case Def >= NeedDef of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Def, NeedDef, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Def, NeedDef, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{wear_equip_attr_att, Att}|L], [{wear_equip_attr_att, NeedAtt}] = Condition, AchievementInfo, Surplus, Show) ->
    case Att >= NeedAtt of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Att, NeedAtt, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Att, NeedAtt, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{achv_stage, Num}|L], [{achv_stage, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{recharge_first, _}|L], [{recharge_first, _}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{achv_stage_reward, TotalStar}|L], [{achv_stage_reward, NeedStar}] = Condition, AchievementInfo, Surplus, Show) ->
    case TotalStar >= NeedStar of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(TotalStar, NeedStar, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(TotalStar, NeedStar, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{compose_equip, GoodsInfoList}|L], [{compose_equip, NeedStage},{compose_equip_color, NeedColor},{compose_equip_star, NeedStar},{compose_equip_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    F = fun(GoodsInfo, Acc) when is_record(GoodsInfo, goods) ->
        #goods{color = Color} = GoodsInfo,
        EquipStage = lib_equip_api:get_equip_stage(GoodsInfo),
        EquipStar = lib_equip_api:get_equip_star(GoodsInfo),
        case EquipStage >= NeedStage andalso Color >= NeedColor andalso EquipStar >= NeedStar of
            true -> Acc + 1;
            false -> Acc
        end;
        (_, Acc) -> Acc
    end,
    Sum = lists:foldl(F, 0, GoodsInfoList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{equip_wash, WashList}|L], [{wash_stage, NeedStage},{equip_wash, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->         
    Fun = fun({Stage, Num}, TSum) ->
        if
            Stage >= NeedStage ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, WashList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{compose_eudemons4, ComposeList}|L], [{color, NeedColor},{star, NeedStar},{compose_eudemons4, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->         
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, _Num} ->
                    case Progress + Surplus >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + Surplus - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
                    end;
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end;
        true ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, Num} when Progress + Num >= NeedNum ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Num - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                {_, Num} ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Num};
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{compose_eudemons5, ComposeList}|L], [{color, NeedColor},{star, NeedStar},{compose_eudemons5, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->         
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, _Num} ->
                    case Progress + Surplus >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + Surplus - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
                    end;
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end;
        true ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, Num} when Progress + Num >= NeedNum ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Num - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                {_, Num} ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Num};
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{compose_eudemons5_3, ComposeList}|L], [{color, NeedColor},{star, NeedStar},{compose_eudemons5_3, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->         
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, _Num} ->
                    case Progress + Surplus >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + Surplus - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
                    end;
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end;
        true ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, Num} when Progress + Num >= NeedNum ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Num - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                {_, Num} ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Num};
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{compose_eudemons6, ComposeList}|L], [{color, NeedColor},{star, NeedStar},{compose_eudemons6, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->         
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, _Num} ->
                    case Progress + Surplus >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + Surplus - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
                    end;
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end;
        true ->
            case lists:keyfind({NeedStar, NeedColor}, 1, ComposeList) of
                {_, Num} when Progress + Num >= NeedNum ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Num - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                {_, Num} ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Num};
                _ ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{spirit_stage_up, WashList}|L], [{spirit_stage_up, NeedStage}, {spirit_stage_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->         
    Fun = fun({Stage, Num}, TSum) ->
        if
            Stage >= NeedStage ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, WashList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedStage, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedStage, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{stone_lv, StoneList}|L], [{stone_lv, NeedLv},{stone_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    Fun = fun({Stage, Num}, TSum) ->
        if
            Stage >= NeedLv ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, StoneList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{soul_wear, SoulList}|L], [{soul_color, NeedColor},{soul_wear, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    Fun = fun({Stage, Num}, TSum) ->
        if
            Stage >= NeedColor ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, SoulList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{soul_level, SoulList}|L], [{soul_level, NeedLv},{soul_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    Fun = fun({Stage, Num}, TSum) ->
        if
            Stage >= NeedLv ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, SoulList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mon_pic, PicList}|L], [{mon_pic_color, NeedColor},{mon_pic, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case lists:keyfind(NeedColor, 1, PicList) of
        {_, Num} ->skip;
        _ -> Num = 0
    end,
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mon_pic_lv, Lv}|L], [{mon_pic_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{fasion_star, SoulList}|L], [{fasion_star, NeedColor},{fasion_star_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    Fun = fun({Color, Num}, TSum) ->
        if
            Color >= NeedColor ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, SoulList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);  
trigger([{rune_equip, SoulList}|L], [{rune_lv, NeedLv},{rune_equip, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    Fun = fun({Lv, Num}, TSum) ->
        if
            Lv >= NeedLv ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, SoulList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{rune_equip_color, SoulList}|L], [{rune_color, NeedLv}, {rune_equip_color, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    Fun = fun({Lv, Num}, TSum) ->
        if
            Lv >= NeedLv ->
                TSum + Num;
            true ->
                TSum
        end
    end,
    Sum = lists:foldl(Fun, 0, SoulList),
    case Sum >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Sum, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Sum, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{talisman_lv, Lv}|L], [{talisman_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{talisman_active, NeedId}|L], [{talisman_acti, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{godweapon_lv, Lv}|L], [{godweapon_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{godweapon_active, NeedId}|L], [{godweapon_acti, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{pet_upgrade_stage, Stage}|L], [{pet_class, NeedStage}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Stage) ->
    case Stage >= NeedStage of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Stage, NeedStage, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Stage, NeedStage, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{pet_figure_active, NeedId}|L], [{pet_figure, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mount_upgrade_stage, Stage}|L], [{mount_class, NeedStage}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Stage) ->
    case Stage >= NeedStage of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Stage, NeedStage, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Stage, NeedStage, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{mount_figure_active, NeedId}|L], [{mount_figure, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{eudemons_stren, Lv}|L], [{eudemons_stren, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{eudemons_extend, Num}|L], [{eudemons_extend, NeedNum}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Num) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{equip_suit, [NeedType, NeedLv, SLv, Num]}|L], [{suit_type, NeedType}, {suit_lv, NeedLv}, {suit_class, NeedSLv}, {suit_num, NeedNum}] = Condition, AchievementInfo, Surplus, Show) when SLv >= NeedSLv ->
    #achievement{progress = _Progress} = AchievementInfo,
    case Num >= NeedNum of
        true ->
            NewProgress = NeedNum,
            NewStatus = ?FINISH,
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = Num}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{compose_rune, _}|L], [{compose_rune, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{compose_soul, _}|L], [{compose_soul, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{wear_equip, NeedId}|L], [{wear_equip, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{artifact_lv, Lv}|L], [{artifact_lv, NeedLv}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Lv) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{artifact_active, NeedId}|L], [{artifact_acti, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{artifact_enchant, Num}|L], [{artifact_enchant, NeedNum}] = Condition, AchievementInfo, Surplus, Show) when is_integer(Num) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{spirit_figure, Total}|L], [{spirit_figure, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{fasion_active, Total}|L], [{fasion_active, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{guild_guard, _}|L], [{guild_guard, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{upgrade_arbitrament, Total}|L], [{upgrade_arbitrament, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{active_arbitrament, Total}|L], [{active_arbitrament, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Total >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Total, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Total, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{acti_holyseal, NeedId}|L], [{acti_holyseal, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{checkin, _}|L], [{checkin, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{kill_mon, _}|L], [{kill_mon, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{bounty, _}|L], [{bounty, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{sweep_bounty, Data}|L], [{bounty, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{void_fam_kill, _}|L], [{void_kill, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{nine_kill, _}|L], [{nine_kill, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{sanctuary_boss, _}|L], [{sanctuary_boss, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{husong, _}|L], [{husong, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{mid_party, _}|L], [{mid_party, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{drumwar, _}|L], [{drumwar, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{cluster_3v3, _}|L], [{cluster_3v3, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{cluster_1vn, _}|L], [{cluster_1vn, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{exp_pray, _}|L], [{exp_pray, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{coin_pray, _}|L], [{coin_pray, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{sell_cost, _Data}|L], [{sell_cost, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + _Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + _Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + _Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{sanctuary_score, _Data}|L], [{sanctuary_score, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + _Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + _Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + _Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{sell_sell, _Data}|L], [{sell_sell, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + _Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + _Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + _Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{top_pk, GradeNum}|L], [{top_pk, NeedGradeNum}] = Condition, AchievementInfo, Surplus, Show) when GradeNum >= NeedGradeNum ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{quiz_correct, Times}|L], [{quiz_correct, NeedTimes}] = Condition, AchievementInfo, Surplus, Show) when Times >= NeedTimes ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{join_beach, _}|L], [{join_beach, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{eudemons_boss_collect, Mid}|L], [{ai_collect_id, Mids}, {ai_collect, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    case lists:member(Mid, Mids) of
        true ->
            if
                Surplus =/= 0 ->
                    case Progress + Surplus >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + Surplus - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
                    end;
                true ->
                    case Progress + 1 >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + 1 - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
                    end
            end;
        false ->NewSurplus = 0, NewAchievementInfo = AchievementInfo
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{eudemons_land_equipbox, GTypeId}|L], [{ai_equipbox_id, GTypeIds}, {ai_equipbox, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    case lists:member(GTypeId, GTypeIds) of
        true ->
            if
                Surplus =/= 0 ->
                    case Progress + Surplus >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + Surplus - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
                    end;
                true ->
                    case Progress + 1 >= NeedNum of
                        true ->
                            NewProgress = NeedNum,
                            NewStatus = ?FINISH,
                            NewSurplus = Progress + 1 - NeedNum,
                            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                        false ->
                            NewSurplus = 0,
                            NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
                    end
            end;
        false -> NewSurplus = 0, NewAchievementInfo = AchievementInfo
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{guild_task, _}|L], [{guild_task, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{sweep_guild_task, Data}|L], [{guild_task, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{join_guild_fire, _}|L], [{join_guild_fire, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{guild_war, _}|L], [{guild_war, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{guild_red_packet, _}|L], [{guild_red_packet, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{guild_dragon, _}|L], [{guild_dragon, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{add_friend, _Data}|L], [{add_friend, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case _Data >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(_Data, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        false ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(_Data, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{chat_private, _}|L], [{chat_private, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
   #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{marry, _}|L], [{get_marry, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{baby_class_up, Lv}|L], [{baby_class, NeedLv}] = Condition, AchievementInfo, Surplus, Show) ->
    case Lv >= NeedLv of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Lv, NeedLv, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Lv, NeedLv, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{baby_get, NeedId}|L], [{baby_get, NeedId}] = Condition, AchievementInfo, Surplus, Show) ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{red_name_wash, _}|L], [{red_name_wash, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{kill_player, _}|L], [{kill_player, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{kill_red_name, _}|L], [{kill_redname, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{player_die, _}|L], [{player_die, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{role_fame, Num}|L], [{flower_send, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{role_charm, Num}|L], [{flower_get, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    case Num >= NeedNum of
        true ->
            NewStatus = ?FINISH,
            NewProgress = calc_progress(Num, NeedNum, Show, NewStatus),
            NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
        _ ->
            NewAchievementInfo = AchievementInfo#achievement{progress = calc_progress(Num, NeedNum, Show, ?UNFINISH)}
    end,
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{world_chat, _}|L], [{world_chat, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{chat, _}|L], [{chat, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{coin_get, _Data}|L], [{coin_get, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + _Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + _Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + _Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_soul_pass, _}|L], [{dungeon_soul, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_exp_single_pass, _}|L], [{dungeon_exp_single, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_coin_pass, _}|L], [{dungeon_coin_pass, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_equip_pass, _}|L], [{dungeon_equip, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
   #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_mount_pass, _}|L], [{dungeon_mount_pass, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_partner_pass, _}|L], [{dungeon_partner_pass, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{dungeon_vip_perboss, _}|L], [{dungeon_vip_perboss, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{wash_division, Division}|L], [{wash_division, NeedDivision}] = Condition, AchievementInfo, Surplus, Show) when Division >= NeedDivision ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{grand_total_quiz_correct, _}|L], [{grand_total_quiz_correct, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + 1 >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + 1 - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + 1}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{rune_hunt, _Data}|L], [{rune_hunt, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + _Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + _Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + _Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{equip_hunt, _Data}|L], [{equip_hunt, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + _Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + _Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + _Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{peak_hunt, _Data}|L], [{peak_hunt, NeedNum}] = Condition, AchievementInfo, Surplus, Show) ->
    #achievement{progress = Progress} = AchievementInfo,
    if
        Surplus =/= 0 ->
            case Progress + Surplus >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + Surplus - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + Surplus}
            end;
        true ->
            case Progress + _Data >= NeedNum of
                true ->
                    NewProgress = NeedNum,
                    NewStatus = ?FINISH,
                    NewSurplus = Progress + _Data - NeedNum,
                    NewAchievementInfo = AchievementInfo#achievement{progress = NewProgress, status = NewStatus};
                false ->
                    NewSurplus = 0,
                    NewAchievementInfo = AchievementInfo#achievement{progress = Progress + _Data}
            end
    end,
    trigger(L, Condition, NewAchievementInfo, NewSurplus, Show);
trigger([{soul_dun_floor, DunId}|L], [{soul_dun_floor, NeedDunId}] = Condition, AchievementInfo, Surplus, Show) when DunId >= NeedDunId ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);
trigger([{rune_dun_floor, DunId}|L], [{rune_dun_floor, NeedDunId}] = Condition, AchievementInfo, Surplus, Show) when DunId >= NeedDunId ->
    NewAchievementInfo = AchievementInfo#achievement{progress = 1, status = ?FINISH},
    trigger(L, Condition, NewAchievementInfo, Surplus, Show);


trigger([_|L], Condition, AchievementInfo, Surplus, Show) ->
    trigger(L, Condition, AchievementInfo, Surplus, Show).