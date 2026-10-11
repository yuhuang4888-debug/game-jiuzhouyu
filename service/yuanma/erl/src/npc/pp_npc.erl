%%%-----------------------------------
%%% @Module  : pp_npc
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.12.29
%%% @Description: npc
%%%-----------------------------------
-module(pp_npc).
-export([handle/3]).
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").

%% 动态npc信息
handle(12100, Ps, [Scene]) ->
    lib_npc:send_scene_npc(Ps, Scene),
    ok;

%% 获取npc默认对话和关联任务
handle(12101, Ps, [NpcId]) ->
    TaskList = mod_task:get_npc_task_list(Ps#player_status.tid, NpcId, lib_task_api:ps2task_args(Ps)),
    {ok, BinData} = pt_121:write(12101, [NpcId, TaskList]),
    lib_server_send:send_to_sid(Ps#player_status.sid, BinData);

%% 任务对话
handle(12102, Ps, [NpcId, TaskId])->
    {_Type, TalkId} = mod_task:get_npc_task_talk_id(Ps#player_status.tid, TaskId, NpcId, lib_task_api:ps2task_args(Ps)),
    {ok, BinData} = pt_121:write(12102, [NpcId, TaskId, TalkId]),
    lib_server_send:send_to_sid(Ps#player_status.sid, BinData);

handle(_Cmd, _PlayerStatus, _Data) ->
    {error, bad_request}.
