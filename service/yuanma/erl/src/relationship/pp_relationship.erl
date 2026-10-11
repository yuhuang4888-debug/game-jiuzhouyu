%%%--------------------------------------
%%% @Module  : pp_relationship
%%% @Author  : zhenghehe
%%% @Created : 2011.12.23
%%% @Description:  管理玩家间的关系
%%%--------------------------------------
-module(pp_relationship).
-export([handle/3]).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("relationship.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("role.hrl").
-include("def_module.hrl").
-include("marriage.hrl").
-include("def_fun.hrl").

handle(Cmd = 14000, PS, [3] = Data) ->
    do_handle(Cmd, PS, Data);
handle(Cmd = 14010, PS, Data) ->
    do_handle(Cmd, PS, Data);
handle(Cmd = 14007, PS, [Type, _BeCtrlId] = Data) when Type == 2 orelse Type == 3 ->
    do_handle(Cmd, PS, Data);
handle(Cmd, PS, Data) ->
    #player_status{figure = Figure} = PS,
    OpenLv = lib_module:get_open_lv(?MOD_RELA, 1),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PS, Data);
        false -> skip
    end.

%% 获取关系列表
do_handle(Cmd = 14000, Player, [Type]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    RelaList = lib_relationship:get_rela_list(RoleId, Type),
    {ok, BinData} = pt_140:write(Cmd, [Type, RelaList]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 获取好友推荐
do_handle(Cmd = 14001, Player, [Type]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    {Code, RecommendedList} = lib_relationship:get_recommended_list(RoleId, Type),
    {ok, BinData} = pt_140:write(Cmd, [Code, RecommendedList]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 通过玩家昵称查找玩家
do_handle(Cmd = 14002, Player, [TargetRoleName]) ->
    #player_status{sid = Sid} = Player,
    NameB = util:fix_sql_str(TargetRoleName),
    Data = case lib_player:get_role_id_by_name(NameB) of
        null ->
            [?ERRCODE(err140_3_role_no_exist), 0, "", 0, 0, 0, 0, 0, 0, "", 0, 0, 0];
        TargetRoleId ->
            case lib_relationship:get_one_recommended_role_info(TargetRoleId) of
                false -> [?ERRCODE(err140_3_role_no_exist), 0, "", 0, 0, 0, 0, 0, 0,  "", 0, 0, 0];
                RoleInfo ->
                    {TRoleId, TRoleName, TRoleCareer, TRoleSex, TRoleTurn, TRoleLv, TRoleVip, TRoleVipHide, TRolePic, TRolePicVer, TCombatPower, TOnlineFlag, _SupVipFlag} = RoleInfo,
                    Code = ?IF(TOnlineFlag =:= 0, err140_14_not_online, success),
                    [?ERRCODE(Code), TRoleId, TRoleName, TRoleCareer, TRoleSex, TRoleTurn, TRoleLv, TRoleVip, TRoleVipHide, TRolePic, TRolePicVer, TCombatPower, TOnlineFlag]
            end
    end,
    {ok, BinData} = pt_140:write(Cmd, Data),
    lib_server_send:send_to_sid(Sid, BinData);

%% 发送好友申请
do_handle(_Cmd = 14003, #player_status{id = RoleId}, [0]) ->
    % 在没有在线玩家下，也能完成好友任务
    lib_task_api:add_friend(RoleId),
    {ok, BinData} = pt_140:write(14003, [?SUCCESS]),
    lib_server_send:send_to_uid(RoleId, BinData);
do_handle(_Cmd = 14003, Player, [BeAskId]) ->
    #player_status{sid = Sid, id = RoleId} = Player,
    lib_task_api:add_friend(RoleId),
    lib_relationship:ask_add_friend(Sid, RoleId, BeAskId);
    % {ok, NewPlayer} = lib_player_event:dispatch(Player, ?EVENT_ASK_ADD_FRIEND, IdList),
    % {ok, NewPlayer};

%% 回应添加好友请求(批量)
do_handle(Cmd = 14004, Player, [ResponseType]) ->
    lib_relationship:reply_add_friend_ask(Player, ResponseType),
    %% 触发成就
    FriendList = lib_relationship:get_friend_on_dict(Player#player_status.id),
    {ok, NewPlayer} = lib_achievement_api:add_friend_event(Player, length(FriendList)),
    {ok, BinData} = pt_140:write(Cmd, [?SUCCESS]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

%% 回应添加好友请求(单个玩家)
do_handle(Cmd = 14005, Player, [AskId, ResponseType]) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,
    Code = lib_relationship:reply_one_add_friend_ask(AskId, RoleId, RoleName, ResponseType),
    %% 触发成就
    FriendList = lib_relationship:get_friend_on_dict(RoleId),
    {ok, NewPlayer} = lib_achievement_api:add_friend_event(Player, length(FriendList)),
    {ok, BinData} = pt_140:write(Cmd, [Code]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer};

%% 获取好友请求列表
do_handle(Cmd = 14006, Player, []) ->
    #player_status{sid = Sid, id = RoleId} = Player,
    FriendAskList = lib_relationship:get_friend_ask_list(RoleId),
    {ok, BinData} = pt_140:write(Cmd, [FriendAskList]),
    lib_server_send:send_to_sid(Sid, BinData);
    % {ok, NewPlayer} = lib_player_event:dispatch(Player, ?EVENT_ASK_ADD_FRIEND, IdList),
    % {ok, NewPlayer};

%% 好友操作
do_handle(Cmd = 14007, Player, [Type, BeCtrlId]) when Player#player_status.id =/= BeCtrlId ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, marriage = MarriageStatus} = Player,
    #figure{name = RoleName} = Figure,
    Code = case (Type == 1 orelse Type == 2) andalso MarriageStatus#marriage_status.lover_role_id == BeCtrlId of 
        true -> 
            ?IF(Type == 1, ?ERRCODE(err140_cannot_del_lover), ?ERRCODE(err140_cannot_pull_black_lover));
        _ ->
            case Type of
                1 ->
                    lib_relationship:del_friend(RoleId, BeCtrlId);
                2 ->
                    lib_relationship:pull_black(RoleId, RoleName, BeCtrlId);
                3 ->
                    lib_relationship:del_from_black_list(RoleId, BeCtrlId);
                4 ->
                    lib_relationship:del_from_enemies(RoleId, BeCtrlId);
                _ -> ?FAIL
            end
    end,
    {ok, BinData} = pt_140:write(Cmd, [Type, Code]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 获取玩家交互菜单信息
do_handle(Cmd = 14010, Player, [OtherRid]) when Player#player_status.id =/= OtherRid ->
    #player_status{sid = Sid, id = RoleId} = Player,
    case lib_role:get_role_show(OtherRid) of
        #ets_role_show{figure = Figure} ->
            case lib_relationship:get_rela_with_other_on_dict(RoleId, OtherRid) of
                #rela{rela_type = RelaType} -> skip;
                _ -> RelaType = 0
            end,
            %% 需要拿对方的队伍id 要cast过去
            OtherPid = misc:get_player_process(OtherRid),
            case misc:is_process_alive(OtherPid) of
                true ->
                    lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, lib_relationship_api, send_rela_view_info, [RoleId, RelaType]);
                false ->
                    {ok, BinData} = pt_140:write(Cmd, [?SUCCESS, OtherRid, Figure, RelaType, 0]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        _ ->
            {ok, BinData} = pt_140:write(Cmd, [?ERRCODE(err140_29_not_same_server_player), OtherRid, #figure{}, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 获取玩家对应的社交关系
do_handle(Cmd = 14011, Player, [OtherRid]) when Player#player_status.id =/= OtherRid ->
    #player_status{sid = Sid, id = RoleId} = Player,
    case lib_relationship:get_rela_with_other_on_dict(RoleId, OtherRid) of
        #rela{rela_type = RelaType} -> skip;
        _ -> RelaType = 0
    end,
    {ok, BinData} = pt_140:write(Cmd, [OtherRid, RelaType]),
    lib_server_send:send_to_sid(Sid, BinData);

do_handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

%% 发送错误码
send_error(RoleId, Error) ->
    {ok, Bin} = pt_140:write(14099, [Error]),
    lib_server_send:send_to_uid(RoleId, Bin).