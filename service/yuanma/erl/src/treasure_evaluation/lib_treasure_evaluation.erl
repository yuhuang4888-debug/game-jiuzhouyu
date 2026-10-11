%%-----------------------------------------------------------------------------
%% @Module  :       lib_treasure_evaluation.erl
%% @Author  :       hyh
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-06-11
%% @Description:    幸运鉴宝
%%-----------------------------------------------------------------------------

-module(lib_treasure_evaluation).

-include("treasure_evaluation.hrl").
-include("custom_act.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("language.hrl").
-include("common.hrl").

-export ([
    login_te/1,
    get_te_lucky_num/2,
    set_lucky_num/3,
    player_daily_check/1,
    all_daily_check/0,
    gm_te_lucky_num/3
    ]).

login_te(Ps) ->
    #player_status{
        id = RoleId
    } = Ps,
    ReSql = io_lib:format(?SelectTreasureEvaluationInfoSql, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            TEStatus = #te_status{};
        SqlList ->
            TEList = [begin
                [_RoleId, SubType, LuckyNum] = SqlInfo,
                #te_info{
                    sub_type = SubType,
                    lucky_num = LuckyNum
                }
            end||SqlInfo <- SqlList],
            TEStatus = #te_status{
                te_list = TEList
            }
    end,
    Ps#player_status{
        te_status = TEStatus
    }.

get_te_lucky_num(SubType, TEStatus) ->
    #te_status{
        te_list = TEList
    } = TEStatus,
    case lists:keyfind(SubType, #te_info.sub_type, TEList) of
        false ->
            LuckyNum = 0;
        TEInfo ->
            #te_info{
                lucky_num = LuckyNum
            } = TEInfo,
            LuckyNum
    end,
    LuckyNum.

sql_treasure_evaluation(RoleId, TEInfo) ->
    #te_info{
        sub_type = SubType,
        lucky_num = LuckyNum
    } = TEInfo,
    ReSql = io_lib:format(?ReplaceTreasureEvaluationInfoAllSql, [RoleId, SubType, LuckyNum]),
    db:execute(ReSql).

set_lucky_num(Ps, LuckyNum, SubType) ->
    #player_status{
        id = RoleId,
        te_status = TEStatus
    } = Ps,
    #te_status{
        te_list = TEList
    } = TEStatus,
    case lists:keyfind(SubType, #te_info.sub_type, TEList) of
        false ->
            NewTEInfo = #te_info{
                sub_type = SubType,
                lucky_num = LuckyNum
            };
        TEInfo ->
            NewTEInfo = TEInfo#te_info{
                lucky_num = LuckyNum
            }
    end,
    sql_treasure_evaluation(RoleId, NewTEInfo),
    NewTEList = lists:keystore(SubType, #te_info.sub_type, TEList, NewTEInfo),
    NewTEStatus = TEStatus#te_status{
        te_list = NewTEList
    },
    NewPs = Ps#player_status{
        te_status = NewTEStatus
    },
    NewPs.

player_daily_check(Ps) ->
    #player_status{
        id = RoleId,
        te_status = TEStatus
    } = Ps,
    #te_status{
        te_list = TEList
    } = TEStatus,
    F = fun(TEInfo, {SqlStrList1, NewTEList1}) ->
        #te_info{
            sub_type = SubType
        } = TEInfo,
        case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_TREASURE_EVALUATION, SubType) of
            [] ->
                IfDelete = 1;
            #custom_act_cfg{clear_type = ClearType} ->
                case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_TREASURE_EVALUATION, SubType) of
                    false ->
                        IfDelete = 1;
                    true ->
                        case ClearType of
                            1 ->
                                 IfDelete = 0;
                            _ ->
                                IfDelete = 1
                        end
                end
        end,
        case IfDelete of
            1 ->
                SqlStr = io_lib:format("(`role_id` = ~p and `sub_type` = ~p)", [RoleId, SubType]),
                {[SqlStr|SqlStrList1], NewTEList1};
            _ ->
                {SqlStrList1, [TEInfo|NewTEList1]}
        end
    end,
    {SqlStrList, NewTEList} = lists:foldl(F, {[], []}, TEList),
    case SqlStrList of
        [] ->
            skip;
        _ ->
            SqlList = ulists:list_to_string(SqlStrList, "or"),
            ReSql = io_lib:format(?DeleteTreasureEvalutionInfoAllSql, [SqlList]),
            db:execute(ReSql)
    end,
    NewTEStatus = TEStatus#te_status{
        te_list = NewTEList
    },
    NewPs = Ps#player_status{
        te_status = NewTEStatus
    },
    NewPs.

all_daily_check() ->
    case db:get_all(?SelectTreasureEvaluationInfoAllSql) of
        [] ->
            skip;
        SqlList ->
            F = fun(SqlInfo, SqlStrList1) ->
                [RoleId, SubType, _LuckyNum] = SqlInfo,
                case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_TREASURE_EVALUATION, SubType) of
                    [] ->
                        IfDelete = 1;
                    #custom_act_cfg{clear_type = ClearType} ->
                        case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_TREASURE_EVALUATION, SubType) of
                            false ->
                                IfDelete = 1;
                            true ->
                                case ClearType of
                                    1 ->
                                        IfDelete = 0;
                                    _ ->
                                        IfDelete = 1
                                end
                        end
                end,
                case IfDelete of
                    1 ->
                        SqlStr = io_lib:format("(`role_id` = ~p and `sub_type` = ~p)", [RoleId, SubType]),
                        [SqlStr|SqlStrList1];
                    _ ->
                        SqlStrList1
                end
            end,
            SqlStrList = lists:foldl(F, [], SqlList),
            case SqlStrList of
                [] ->
                    skip;
                _ ->
                    SqlList1 = ulists:list_to_string(SqlStrList, "or"),
                    ReSql = io_lib:format(?DeleteTreasureEvalutionInfoAllSql, [SqlList1]),
                    db:execute(ReSql)
            end
    end.

gm_te_lucky_num(RoleId, LuckyNum, SubType) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_treasure_evaluation, set_lucky_num, [LuckyNum, SubType]).
    