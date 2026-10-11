-module(pp_rename).

-export([handle/3, validate_name/1]).

-include("server.hrl").
-include("rename.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("relationship.hrl").
-include("language.hrl").


%%改角色名
handle(42601, PlayerStatus, [Name,Type]) when is_list(Name) ->
    #player_status{id=RoleId, sid = Sid, figure=Figure, scene = SceneId, scene_pool_id=PoolId,copy_id = CopyId,x = X,y = Y} = PlayerStatus,
    IsBanRename = lib_game:is_ban_rename(),
    case validate_name(Name) of  %% 角色名合法性检测
        _ when IsBanRename ->
            {ok, BinData} = pt_426:write(42601, [?ERRCODE(err426_update_rename_system), Name]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, PlayerStatus};
        {false, Msg} ->
            {ok, BinData} = pt_426:write(42601, [Msg, Name]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, PlayerStatus};
        true ->
        case lib_rename:judge_goods(PlayerStatus,Type) of
            {false,Msg}->
                {ok, BinData} = pt_426:write(42601, [Msg, Name]),
                lib_server_send:send_to_sid(Sid, BinData),
                {ok, PlayerStatus};
            GList->
                Count = mod_daily:get_count(RoleId, ?MOD_RENAME, 1),
                case lib_rename:change_name(RoleId, Name, Figure) of
                    1 when Count == 0 ->
                        NameBin = util:make_sure_binary(Name),
                        %%消耗物品
                        TempPs = lib_rename:use_good(PlayerStatus, GList),
                        %%增加曾用名并通知玩家关系
                        % NewPS = lib_rename:add_old_name(TempPs, Name),
                        OldName = Figure#figure.name,
                        % Now = utime:unixtime(),
                        % ReNameList = get_old_name(RoleId),
                        % NewNameList = [{OldName,Now}|ReNameList],
                        % SortList = lists:keysort(2,NewNameList),
                        % set_old_name(sort_reverse(SortList,?MAX_NAME)),
                        %%修改ps的figure的name
                        NewPS = lib_rename:change_ps(TempPs,NameBin),
                        %%通知场景
                        mod_scene_agent:update(SceneId,PoolId,RoleId,[{name,NameBin}]),
                        %%给场景九宫格发送
                        {ok, BinData} = pt_120:write(12086, [RoleId,NameBin]),
                        lib_server_send:send_to_area_scene(SceneId, PoolId, CopyId, X, Y, BinData),
                        %%派发事件
                        lib_player_event:dispatch(NewPS, ?EVENT_RENAME, NameBin),
                        %%通知好友
                        Friends = lib_relationship:get_relas_by_types(RoleId,?RELA_TYPE_FRIEND),
                        lib_rename:send_email(Friends, ?LAN_TITLE_RENAME, ?LAN_CONTENT_FRIEND_RENAME, ulists:list_to_bin(Name), ulists:list_to_bin(OldName)),
                        %%通知仇人
                        % Enemy =  lib_relationship:get_relas_by_types(RoleId,?RELA_TYPE_ENEMY),
                        % lib_rename:send_email(Enemy, ?LAN_TITLE_RENAME, ?LAN_CONTENT_ENEMY_RENAME, ulists:list_to_bin(Name), ulists:list_to_bin(OldName)),
                        {ok, BinData1} = pt_426:write(42601, [1, Name]),
                        lib_server_send:send_to_sid(Sid, BinData1),
                        %lib_chat:send_TV({all}, ?MOD_PLAYER, 1, [Figure#figure.name, NameBin, RoleId]),
                        %%加日志
                        lib_log_api:log_rename(RoleId,Figure#figure.name,NameBin,Figure#figure.lv,GList),
                        {ok, NewPS};
                    1 ->
                        {ok, BinData} = pt_426:write(42601, [?ERRCODE(err426_rename_today), Name]),
                        lib_server_send:send_to_sid(Sid, BinData),
                        {ok, PlayerStatus};
                    _Err ->
                        {ok, BinData} = pt_426:write(42601, [0, Name]),
                        lib_server_send:send_to_sid(Sid, BinData),
                        {ok, PlayerStatus}
                end
        end
    end;

%%是否免费改名
handle(42602, PlayerStatus, [])->
    #player_status{sid = Sid, c_rename = CName} = PlayerStatus,
    if
        CName =:= 0 ->
            {ok, BinData} = pt_426:write(42602, [?FREE]);
        true ->
            {ok, BinData} = pt_426:write(42602, [?NOT_FREE])
    end,
    lib_server_send:send_to_sid(Sid, BinData);

%% 判断是否满足改名条件
handle(42604, PlayerStatus, [Name,Type]) when is_list(Name) ->
    #player_status{id=RoleId, sid = Sid} = PlayerStatus,
    case validate_name(Name) of  %% 角色名合法性检测
        {false, Msg} -> ok;
        true ->
            case lib_rename:judge_goods(PlayerStatus,Type) of
                {false,Msg}-> ok;
                _ ->
                    Count = mod_daily:get_count(RoleId, ?MOD_RENAME, 1),
                    case Count > 0 of 
                        true -> Msg = ?ERRCODE(err426_rename_today);
                        _ -> Msg = 1
                    end
            end
    end,
    {ok, BinData} = pt_426:write(42604, [Msg, Name]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, PlayerStatus};

%%查看曾用名
% handle(42603, PlayerStatus, [Type,Id])->
%     ?PRINT("42603 is ~p ~p~n",[Type,Id]),
%     #player_status{sid = Sid} = PlayerStatus,
%     case Type of
%         %%查看自身
%         1 ->
%             ReNameList = lib_rename:get_old_name(Id),
%             ?PRINT("~p~n",[ReNameList]),
%             {ok, BinData} = pt_426:write(42603, [ReNameList]),
%             lib_server_send:send_to_sid(Sid, BinData);
%         %%查看别的玩家
%         2 ->
%             case lib_player:is_online_global(Id) of
%                 true -> ReNameList = lib_player:apply_call(Id, ?APPLY_CALL, lib_rename, get_old_name, [Id], 3000);
%                 false -> ReNameList = case lib_offline_api:get_player_info(Id, #player_status.rename) of
%                                             not_exist->
%                                                 [];
%                                             List->
%                                                 List
%                                       end
%             end,
%             ?PRINT("~p~n",[ReNameList]),
%             {ok, BinData} = pt_426:write(42603, [ReNameList]),
%             lib_server_send:send_to_sid(Sid, BinData)
%     end,
%     {ok, PlayerStatus}.

handle(_Cmd, _, _Args) ->
    ?ERR("pp_rename nomatch ~p ~p~n", [_Cmd, _Args]).

%%% ------------ 私有函数 --------------
%% 角色名合法性检测
validate_name(Name) ->
    case lib_player:validate_name(Name) of 
        {false, 7} -> {false, ?ERRCODE(err145_2_word_is_sensitive)};
        {false, 5} -> {false, ?ERRCODE(not_enough_length)};
        {false, 4} -> {false, ?ERRCODE(illegal_character)};
        {false, 3} -> {false,?ERRCODE(name_exist)};
        true -> true;
        _ -> {false, 0}
    end.
