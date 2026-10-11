%% ---------------------------------------------------------------------------
%% @doc pp_temple_awaken

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/1
%% @deprecated  神殿觉醒路由
%% ---------------------------------------------------------------------------
-module(pp_temple_awaken).

%% API
-compile([export_all]).

-include("common.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("temple_awaken.hrl").


%% 完成觉醒之路任务
handle(42900, Ps, []) ->
    case lib_temple_awaken:finish_initial_task(Ps) of
        {false, Errcode} ->
            NewPs = Ps,
            Arg = [Errcode];
        {ok, NewPs} ->
            Arg = [?SUCCESS]
    end,
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_429, 42900, Arg),
    {ok, NewPs};

%% 发送神殿信息
handle(42901, Ps, []) ->
    lib_temple_awaken:send_all_temple_awaken(Ps),
    {ok, Ps};

%% 发送神殿章节信息
handle(42902, Ps, [ChapterId]) ->
    lib_temple_awaken:send_chapter_temple_awaken(Ps, ChapterId),
    {ok, Ps};

%% 领取章节奖励
handle(42906, Ps, [ChapterId]) ->
    case lib_temple_awaken:receive_chapter_reward(Ps, ChapterId) of
        {false, Errcode} ->
            Arg = [Errcode, ChapterId],
            NewPs = Ps;
        {ok, NewPs} ->
            Arg = [?SUCCESS, ChapterId]
    end,
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_429, 42906, Arg),
    {ok, NewPs};

%% 领取子章节阶段奖励
handle(42907, Ps, [ChapterId, SubChapter, Stage]) ->
    case lib_temple_awaken:receive_stage_reward(Ps, ChapterId, SubChapter, Stage) of
        {false, Errcode} ->
            Arg = [Errcode, ChapterId, SubChapter, Stage],
            NewPs = Ps;
        {ok, NewPs} ->
            Arg = [?SUCCESS, ChapterId, SubChapter, Stage]
    end,
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_429, 42907, Arg),
    {ok, NewPs};

%% 穿戴/脱下 章节时装
handle(42908, Ps, [Chapter, IsWare]) ->
    case lib_temple_awaken:ware_model(Ps, Chapter, IsWare) of
        {false, Errcode} ->
            Arg= [Errcode, Chapter, IsWare],
            NewPs = Ps;
        {ok, NewPs} ->
            Arg= [?SUCCESS, Chapter, IsWare]
    end,
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_429, 42908, Arg),
    {ok, NewPs};

handle(42909, Ps, []) ->
    lib_temple_awaken:pre_task_status(Ps),
    {ok, Ps};

%% 进入/退出 神殿觉醒场景
handle(42910, Ps, [IsEnter, _SceneId, _X, _Y]) ->
    #player_status{id = RoleId, scene = OldSceneId} = Ps,
    SceneId = ?TEMPLE_AWAKEN_SID,
    case IsEnter of
        1 ->
            case OldSceneId of
                SceneId -> skip;
                _ -> lib_scene:player_change_scene(RoleId, SceneId, 0, RoleId, true, [{group, 0}])
            end;
        _ ->
            case OldSceneId of
                SceneId ->
                    lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{group, 0}]);
                _ -> skip
            end
end;

handle(_Cmd, Ps, _Args) ->
    ?ERR("temple_awaken router error, Cmd:~p Args ~p ~n", [_Cmd, _Args]),
    {ok, Ps}.
