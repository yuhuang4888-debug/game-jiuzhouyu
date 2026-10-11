%%-----------------------------------------------------------------------------
%% @Module  :       lib_awakening
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-08
%% @Description:    天命觉醒
%%-----------------------------------------------------------------------------
-module(lib_awakening).

-include("awakening.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").

-export([
    login/1
    , check_active_cell/5
    , active_cell/2
    , calc_cell_num/2
    ]).

login(RoleId) ->
    case db:get_all(io_lib:format(?sql_select_role_awakening, [RoleId])) of
        [] -> #awakening{role_id = RoleId};
        List ->
            F = fun(T, {TmpActiveIds, TmpAttrL}) ->
                case T of
                    [TmpId] ->
                        case data_awakening:get_awakening_cell_cfg(TmpId) of
                            #awakening_cell_cfg{attr = TmpAttr} ->
                                {[TmpId|TmpActiveIds], [TmpAttr|TmpAttrL]};
                            _ -> {TmpActiveIds, TmpAttrL}
                        end;
                    _ -> {TmpActiveIds, TmpAttrL}
                end
            end,
            {ActiveIds, ActiveAttr} = lists:foldl(F, {[], []}, List),
            #awakening{
                role_id = RoleId,
                active_ids = lists:reverse(ActiveIds),
                max_active_id = ?IF(ActiveIds =/= [], lists:max(ActiveIds), 0),
                attr = ulists:kv_list_plus_extra(ActiveAttr)
            }
    end.

%% 检测激活命格
check_active_cell(RoleData, Tid, Turn, _RoleLv, CellId) ->
    #awakening{
        active_ids = ActiveIds
    } = RoleData,
    case Turn >= ?DEF_TURN_3 of
        true ->
            case lists:member(CellId, ActiveIds) of
                false ->
                    case data_awakening:get_awakening_cell_cfg(CellId) of
                        #awakening_cell_cfg{
                            task_id = TaskId,
                            pre_id = PreId
                        } = Cfg ->
                            case PreId == 0 orelse lists:member(PreId, ActiveIds) of
                                true ->
                                    case catch mod_task:is_trigger_task_id(Tid, TaskId) of
                                        true ->
                                            {ok, Cfg};
                                        false -> %% 未接取转生任务
                                            {false, ?ERRCODE(err164_not_trigger_task)};
                                        Err ->
                                            ?ERR("active_cell err:~p", [Err]),
                                            {false, ?ERRCODE(system_busy)}
                                    end;
                                false -> %% 前置星格未觉醒
                                    {false, ?ERRCODE(err164_pre_not_active)}
                            end;
                        _ -> %% 无效星格
                            {false, ?ERRCODE(err_config)}
                    end;
                true -> %% 已经激活过了
                    {false, ?ERRCODE(err164_cant_active_repeat)}
            end;
        false ->
            {false, ?ERRCODE(lv_limit)}
    end.

%% 激活命格
active_cell(RoleData, CellId) ->
    #awakening{
        active_ids = ActiveIds,
        attr = PreAttr
    } = RoleData,
    #awakening_cell_cfg{attr = AttrPlus} = data_awakening:get_awakening_cell_cfg(CellId),
    NewAttr = util:combine_list(PreAttr ++ AttrPlus),
    NewActiveIds = [CellId|ActiveIds],
    RoleData#awakening{active_ids = lists:reverse(NewActiveIds), max_active_id = lists:max(NewActiveIds), attr = NewAttr}.

%% 计算命格
%% @tests lib_awakening:calc_cell_num(301400, [1,2,3,4,5,6,7,8,9,10]).
calc_cell_num(_TaskId, []) -> 0;
calc_cell_num(TaskId, ActiveIds) ->
    MaxCell = lists:max(ActiveIds),
    case data_awakening:get_awakening_cell_id_list(TaskId) of
        [] -> 0;
        CellIdL -> 
            MinCell = lists:min(CellIdL),
            max(MaxCell - MinCell+1, 0)
    end.