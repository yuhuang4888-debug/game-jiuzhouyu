-module(pp_mon_pic).

-export([handle/3]).

-include("server.hrl").
-include("mon_pic.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").


%%展示列表
handle(44201, PlayerStatus, [Type])->
    lib_mon_pic:mon_pic_list(PlayerStatus,Type);


%% 激活
handle(44202, PlayerStatus, [PicId]) ->
    #player_status{sid=Sid} = PlayerStatus,
    case lib_mon_pic:active(PlayerStatus, PicId) of
        {true,NewPlayerStatus, CurPower, NextPower} ->
            Errcode = ?SUCCESS;
        {false, Errcode} ->
            CurPower = 0,
            NextPower = 0,
            NewPlayerStatus = PlayerStatus
    end,
    {ok, BinData} = pt_442:write(44202, [Errcode, PicId, CurPower, NextPower]),
    lib_server_send:send_to_sid(Sid, BinData),
    lib_mon_pic:send_42201_by_pic(NewPlayerStatus, PicId),
    {ok, battle_attr, NewPlayerStatus};


%% 升级
handle(44203, PlayerStatus, [PicId]) ->
    #player_status{sid=Sid} = PlayerStatus,
    case lib_mon_pic:up_lv(PlayerStatus, PicId) of
        {true, NewPlayerStatus, NewLv, CurPower, NextPower} ->
            Errcode = ?SUCCESS;
        {false, Errcode} ->
            NewPlayerStatus = PlayerStatus,
            NewLv = 0,
            CurPower = 0,
            NextPower = 0
    end,
    {ok, BinData} = pt_442:write(44203, [Errcode, PicId, NewLv, CurPower, NextPower]),
    lib_server_send:send_to_sid(Sid, BinData),
    lib_up_power:refresh_mon_pic(NewPlayerStatus),
    lib_mon_pic:send_42201_by_pic(NewPlayerStatus, PicId),
    {ok, battle_attr, NewPlayerStatus};


%% 激活组合
handle(44204, PlayerStatus, [GroupId]) ->
    #player_status{sid=Sid} = PlayerStatus,
    case lib_mon_pic:active_group(PlayerStatus, GroupId) of
        {true,NewPlayerStatus,NewLv} -> Errcode = ?SUCCESS;
        {false, Errcode} ->
            NewPlayerStatus = PlayerStatus,
            NewLv = 0
    end,
    {ok, BinData} = pt_442:write(44204, [Errcode, GroupId, NewLv]),
    lib_server_send:send_to_sid(Sid, BinData),
    lib_up_power:refresh_mon_pic(NewPlayerStatus),
    lib_mon_pic:send_42201_by_group(NewPlayerStatus, GroupId),
    {ok, battle_attr, NewPlayerStatus};


%% 获取待分解图鉴列表(已激活的所有图鉴ID)
handle(44205, PlayerStatus, []) ->
    lib_mon_pic:mon_pic_actived_list(PlayerStatus);

%% 查看未激活的图谱战力加成
handle(44207, Player, [PicId]) ->
    #player_status{sid = Sid, original_attr = OriginalAttr} = Player,
    case data_mon_pic:get_pic_type(PicId) of
        Type when Type =/= 0 ->
            case data_mon_pic:get_lv_attr(PicId, 1) of
                CurAttrList when CurAttrList =/= [] ->
                    ActivePower = lib_player:calc_partial_power(Player, OriginalAttr, 0, CurAttrList);
                _ ->
                    ActivePower = 0
            end;
        _ ->
            ActivePower = 0
    end,
    ?PRINT("~n44207~p~n", [{PicId, ActivePower}]),
    lib_server_send:send_to_sid(Sid, pt_442, 44207, [PicId, ActivePower]);

handle(_Cmd, _Player, _Data) ->
    {error, "pp_mon_pic no match~n"}.