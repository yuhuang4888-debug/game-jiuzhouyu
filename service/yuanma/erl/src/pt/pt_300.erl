-module(pt_300).
-include("task.hrl").
-export([read/2, write/2]).
-compile(export_all).

%% 任务列表
read(30000, _Data) ->
    {ok, []};

%% 完成任务某一内容
read(30001, _Data) ->
    {ok, []};

%% 可接任务
read(30002, _Data) ->
    {ok, []};

%% 接受任务
read(30003, <<TaskId:32>>) ->
    {ok, TaskId};

%% 完成任务
read(30004, <<TaskId:32>>) ->
    {ok, TaskId};

%% 最新完成主线任务id
read(30005, <<>>) ->
    {ok, []};

%% 消耗材料
read(30006, <<TaskId:32, GoodsTypeId:32, Num:32>>) ->
    {ok, [TaskId, GoodsTypeId, Num]};

%% 对话事件
read(30007, <<NpcId:32>>) ->
    {ok, NpcId};

%% 加入公会事件
read(30008, _) ->
    {ok, []};

%% 查看帮派周常和日常任务的当前进度
read(30010, <<TaskType:8>>)->
    {ok, TaskType};

%% 触发悬赏任务和公会周任务
read(30011, <<TaskType:8>>)->
    {ok, TaskType};

%% 特殊任务奖励显示
read(30012, <<TaskId:32>>) ->
    {ok, TaskId};

%% 扫荡悬赏任务和公会周任务
read(30013, <<TaskType:8>>)->
    {ok, TaskType};

read(_Cmd, _R) ->
    {error, no_match}.


%% 任务列表
write(30000,[ActiveList, TriggerList])->
    ABin = pack_task_list_trigger(ActiveList),
    TBin = pack_task_list_trigger(TriggerList),
    Data = <<ABin/binary, TBin/binary>>,
    {ok, pt:pack(30000, Data)};

%% 完成任务某环节
write(30001, [TaskId, Tip])->
    TipBin = pack_task_tip_list(Tip),
    Data = <<TaskId:32, TipBin/binary>>,
    {ok, pt:pack(30001, Data)};

%% 接受任务
write(30003,[Result, ErrCode])->
    {ok, pt:pack(30003, <<Result:32, ErrCode:16>>)};

%% 完成任务
write(30004,[Id, ErrCode, ObjL])->
    ObjLBin = pt:write_object_list(ObjL),
    {ok, pt:pack(30004, <<Id:32,ErrCode:32,ObjLBin/binary>>)};

%% 最新完成主线任务id
write(30005, [LastTaskId]) -> 
    {ok, pt:pack(30005, <<LastTaskId:32>>)};

%% 消耗
write(30006, [ErrCode, TaskId]) ->
    {ok, pt:pack(30006, <<ErrCode:32, TaskId:32>>)};

%% 日常任务刷新通知
write(30009, _) ->
    {ok, pt:pack(30009, <<>>)};

%% 查看当前进度
write(30010, [TaskType, FinishCount, Count])->
    {ok,  pt:pack(30010, <<TaskType:8, FinishCount:8, Count:8>>)};

%% 触发悬赏任务和公会周任务
write(30011, [Code, TaskType])->
    {ok, pt:pack(30011, <<Code:32, TaskType:8>>)};

%% 赏金任务和公会周任务奖励展示
write(30012, [TaskId, Rewards, ExtraRewards])->
    F = fun({Type, GId, Num}) -> <<Type:8, GId:32, Num:64>> end,
    RewardsBin = lists:map(F, Rewards),
    {RL, RB} = {length(RewardsBin), list_to_binary(RewardsBin)},
    ExRewardsBin = lists:map(F, ExtraRewards),
    {ERL, ERB} = {length(ExRewardsBin), list_to_binary(ExRewardsBin)},
    {ok,  pt:pack(30012, <<TaskId:32, RL:16, RB/binary, ERL:16, ERB/binary>>)};

%% 扫荡悬赏任务和公会周任务
write(30013, [Code, TaskType, Rewards, ExtraRewards])->
    F = fun({Type, GId, Num}) -> <<Type:8, GId:32, Num:64>> end,
    RewardsBin = lists:map(F, Rewards),
    {RL, RB} = {length(RewardsBin), list_to_binary(RewardsBin)},
    ExRewardsBin = lists:map(F, ExtraRewards),
    {ERL, ERB} = {length(ExRewardsBin), list_to_binary(ExRewardsBin)},
    {ok, pt:pack(30013, <<Code:32, TaskType:8, RL:16, RB/binary, ERL:16, ERB/binary>>)};

write(Cmd, Data) ->
    {ok, pt:error_pack(Cmd, Data)}.

%% 已接任务数据
pack_task_list_trigger([]) -> <<0:16>>;
pack_task_list_trigger(TriggerList)->
    Len = length(TriggerList),
    Bin = list_to_binary([pack_task_trigger(X) || X <- TriggerList]),
    <<Len:16, Bin/binary>>.

pack_task_trigger({Tid, Tip}) ->
    TipBin = pack_task_tip_list(Tip),
    <<Tid:32, TipBin/binary>>.

 %% 打包任务目标
pack_task_tip_list([]) -> <<0:16>>;
pack_task_tip_list(TipList) ->
    Len = length(TipList),
    Bin = list_to_binary([ pack_task_tip(X) || X <- TipList]),
    <<Len:16, Bin/binary>>.

pack_task_tip(#task_content{stage=_Stage, cid=_Cid, ctype=CType, id=Id, need_num=NeedNum, desc=Desc, display_num=DisPlayNum, fin=Fin, now_num=NowNum, scene_id=SceneId, x=X, y=Y, is_guide=IsGuide}) -> 
    DescBin = pt:write_string(Desc),
    <<CType:8, DescBin/binary, Fin:8, Id:32, NeedNum:32, NowNum:32, DisPlayNum:32, SceneId:32, X:16, Y:16, IsGuide:8>>.
