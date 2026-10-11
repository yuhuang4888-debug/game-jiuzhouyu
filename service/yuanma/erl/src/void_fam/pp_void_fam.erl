%%-----------------------------------------------------------------------------
%% @Module  :       pp_void_fam
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-14
%% @Description:
%%-----------------------------------------------------------------------------
-module(pp_void_fam).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("attr.hrl").

-export([
    handle/3
    , send_error_code/2
    ]).

%% 获取活动信息
handle(60001, Status, _) ->
    #player_status{id = RoleId} = Status,
    mod_void_fam_local:send_act_info(RoleId);

%% 进入场景
handle(60002, Status, _) ->
    #player_status{sid = Sid, id = RoleId, scene = Scene, figure = #figure{lv = Lv}, battle_attr = BattleAttr} = Status,
    #battle_attr{hp_lim = HpLim} = BattleAttr,
    NeedLv = data_void_fam:get_cfg(need_role_lv),
    IsOpen = mod_void_fam_local:is_act_open(),
    IsInVoidFam = lib_void_fam:is_in_void_fam(Scene),
    if
        IsInVoidFam -> send_error_code(Sid, ?ERRCODE(err120_already_in_scene));
        Lv < NeedLv -> send_error_code(Sid, ?ERRCODE(err402_no_enough_lv_join));
        IsOpen == false -> send_error_code(Sid, ?ERRCODE(err402_act_close));
        true ->
            case lib_player_check:check_list(Status, [action_free, is_transferable]) of
                true ->
                    mod_void_fam_local:enter_scene(RoleId, HpLim);
                {false, ErrCode} ->
                    send_error_code(Sid, ErrCode)
            end
    end;

%% 退出场景
handle(60003, Status, _) ->
    #player_status{sid = Sid, id = RoleId, scene = Scene, battle_attr = BattleAttr} = Status,
    #battle_attr{hp_lim = HpLim} = BattleAttr,
    IsInVoidFam = lib_void_fam:is_in_void_fam(Scene),
    if
        IsInVoidFam == false -> send_error_code(Sid, ?ERRCODE(err402_no_in_act_scene));
        true ->
            mod_void_fam_local:exit_scene(RoleId, HpLim)
    end;

%% 楼层信息
handle(60004, Status, _) ->
    #player_status{id = RoleId} = Status,
    mod_void_fam_local:send_floor_info(RoleId);

handle(_Cmd, _Status, _Data) ->
    {error, "pp_void_fam no match"}.

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    {ok, BinData} = pt_600:write(60000, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).