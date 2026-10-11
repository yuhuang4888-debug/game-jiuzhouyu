%% ---------------------------------------------------------------------------
%% @doc pp_supreme_vip.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-07-23
%% @deprecated 至尊vip
%% ---------------------------------------------------------------------------
-module(pp_supreme_vip).
-export([handle/3]).

%% 查看至尊vip信息
handle(45101, Player, []) ->
    lib_supreme_vip:send_info(Player);

%% 查看技能任务
handle(45102, Player, []) ->
    lib_supreme_vip:send_skill_task_info(Player);

%% 提交技能任务
handle(45103, Player, [TaskId]) ->
    lib_supreme_vip:commit_skill_task(Player, TaskId);

%% 查看至尊币任务
handle(45104, Player, []) ->
    lib_supreme_vip:send_currency_task_info(Player);

%% 提交至尊币任务
handle(45105, Player, [TaskId]) ->
    lib_supreme_vip:commit_currency_task(Player, TaskId);

%% 购买至尊vip体验
handle(45106, Player, []) ->
    lib_supreme_vip:buy_ex(Player);

%% 购买至尊vip永久
handle(45107, Player, []) ->
    lib_supreme_vip:buy_forever(Player);

%% 领取特权
handle(45108, Player, [RightType]) ->
    lib_supreme_vip:handle_get_right_reward(Player, RightType);

%% 免战保护信息
handle(45112, Player, []) ->
    lib_supreme_vip:send_free_use_pk_safe(Player);

%% 英文需求
handle(45120, Player, []) ->
    lib_english_super_vip:send_open_act_info(Player);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.