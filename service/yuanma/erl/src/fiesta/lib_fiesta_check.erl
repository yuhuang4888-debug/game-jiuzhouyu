%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_fiesta_check.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-12-06
%%% @modified
%%% @description    祭典功能检查函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_fiesta_check).

-include("errcode.hrl").
-include("server.hrl").
-include("fiesta.hrl").

-export([receive_fiesta_reward/2, receive_task_reward/3, buy_premium_fiesta/2]).

-export([have_received_reward/2, is_task_reward_can_received/3, have_not_got_premium/1]).

% -compile(export_all).

%%% ====================================== exported functions ======================================

%% -----------------------------------------------
%% @doc 等级奖励领取检查
-spec
receive_fiesta_reward(Lv, PS) -> true | {false, ErrCode} when
    Lv :: integer(),
    PS :: #player_status{},
    ErrCode :: integer().
%% -----------------------------------------------
receive_fiesta_reward(Lv, PS) ->
    #player_status{fiesta = Fiesta} = PS,
    CheckList = [
        {fun is_fiesta_open/1, [Fiesta]}, {fun is_lv_legal/1, [Lv]},
        {fun is_lv_le/2, [Lv, Fiesta]}, {fun have_received_reward/2, [Lv, Fiesta]}
    ],
    check_list(CheckList).

%% -----------------------------------------------
%% @doc 任务奖励领取检查
-spec
receive_task_reward(TaskType, TaskId, PS) -> true | {false, ErrCode} when
    TaskType :: ?DAILY_TASK | ?WEEKLY_TASK | ?SEASON_TASK,
    TaskId :: integer(),
    PS :: #player_status{},
    ErrCode :: integer().
%% -----------------------------------------------
receive_task_reward(TaskType, TaskId, PS) ->
    #player_status{fiesta = Fiesta} = PS,
    CheckList = [
        {fun is_fiesta_open/1, [Fiesta]}, {fun is_task_reward_can_received/3, [TaskType, TaskId, Fiesta]}
    ],
    check_list(CheckList).

%% -----------------------------------------------
%% @doc 高级祭典购买检查
-spec
buy_premium_fiesta(Type, PS) -> true | {false, ErrCode} when
    Type :: ?PREMIUM_FIESTA | ?PREMIUM_FIESTA2,
    PS :: #player_status{},
    ErrCode :: integer().
%% -----------------------------------------------
buy_premium_fiesta(Type, PS) ->
    #player_status{fiesta = Fiesta} = PS,
    CheckList = [
        {fun is_fiesta_open/1, [Fiesta]}, {fun have_not_got_premium/1, [Fiesta]}, {fun is_type_legal/1, [Type]},
        {fun is_buy_way_legal/2, [Type, Fiesta]}, {fun is_enough_money/2, [Type, PS]}
    ],
    check_list(CheckList).

%%% ======================================== inner functions =======================================

%% 条件列表检查
%% @return skip | true | {false, ErrCode}
check_list([]) -> true;
check_list([H|T]) ->
    case check(H) of
        true         -> check_list(T);
        {false, Res} -> {false, Res};    % {false, ?FAIL}都是非正常错误
        _            -> {false, ?FAIL}
    end.

check({Fun, Args}) when is_function(Fun) -> % 尽量每个条件采用单独函数
    apply(Fun, Args);

check(_) ->
    {false, ?FAIL}.

%% 祭典是否已开启
is_fiesta_open(Fiesta) -> Fiesta /= undefined.

%% 祭典等级是否合法
is_lv_legal(Lv) ->
    Lv >= 0.

%% 祭典等级是否小于等于当前等级
is_lv_le(Lv, #fiesta{lv = CurLv}) ->
    Lv =< CurLv.

%% 是否有未接收的奖励
have_received_reward(0, _) -> true;
have_received_reward(Lv, Fiesta) ->
    #fiesta{type = Type, reward_m = RewardM} = Fiesta,
    IsPremium = Type > ?NORMAL_FIESTA,
    #fiesta_reward{status1 = Status1, status2 = Status2} = maps:get(Lv, RewardM),
    case IsPremium of
        false ->
            Status1 == ?NOT_RECEIVE;
        true ->
            Status1 == ?NOT_RECEIVE orelse Status2 == ?NOT_RECEIVE
    end.

%% 任务是否存在
is_task_reward_can_received(TaskType, TaskId, Fiesta) ->
    #fiesta{task_m = TaskM} = Fiesta,
    TaskL = maps:get(TaskType, TaskM, []),
    case lists:keyfind(TaskId, #fiesta_task.task_id, TaskL) of
        #fiesta_task{status = ?NOT_RECEIVE} -> true;
        _ -> false
    end.

%% 是否未买高级祭典
have_not_got_premium(#fiesta{type = Type}) -> Type == ?NORMAL_FIESTA.

%% 购买类型是否合法
is_type_legal(Type) -> Type == ?PREMIUM_FIESTA orelse Type == ?PREMIUM_FIESTA2.

%% 是否可以通过钻石购买
is_buy_way_legal(Type, Fiesta) ->
    #fiesta{fiesta_id = FiestaId} = Fiesta,
    lib_fiesta_data:get_premium_cost_gold(Type, FiestaId) /= [].

%% 是否够钱买
is_enough_money(Type, PS) ->
    CostList = lib_fiesta_data:get_premium_cost_gold(Type, lib_fiesta:get_fiesta_id(PS)),
    lib_goods_api:check_object_list(PS, CostList).