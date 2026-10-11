%%%--------------------------------------
%%% @Module  : lib_flower
%%% @Author  : zengzy
%%% @Created : 2017-06-30
%%% @Description:  花语和鲜花
%%%--------------------------------------
-module(lib_flower_api).

-include("server.hrl").
-include("flower.hrl").
-include("predefine.hrl").

-export([
    add_fame/3
    ,add_charm/3
    ]).

%%增加名誉
add_fame(Player, Num, Extra) ->
    #player_status{id = RoleId, flower = RoleFlowerData} = Player,
    #flower{fame = Fame} = RoleFlowerData,
    NewFame = Fame + Num,
    db:execute(io_lib:format(?sql_update_fame, [NewFame, RoleId])),
    PreFameLv = lib_flower:get_fame_lv(Fame),
    NewFameLv = lib_flower:get_fame_lv(NewFame),
    case PreFameLv =/= NewFameLv of
        true ->
            #fame_lv_cfg{attr = NewFameAttr} = data_flower:get_fame_lv_cfg(NewFameLv),
            NewPlayerTmp = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame, attr = NewFameAttr}},
            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame}}
    end,
    %% 日志
    lib_log_api:log_fame(RoleId, Fame, NewFame, Extra),
    %% 触发成就
    {ok, LastPlayer} = lib_achievement_api:flower_send_event(NewPlayer, NewFameLv),
    LastPlayer.

%%增加魅力值
add_charm(Player, Num, Extra) ->
    #player_status{id = RoleId, flower = RoleFlowerData} = Player,
    #flower{charm = Charm} = RoleFlowerData,
    NewCharm = Charm + Num,
    db:execute(io_lib:format(?sql_update_charm, [NewCharm, RoleId])),
    NewPlayer = Player#player_status{flower = RoleFlowerData#flower{charm = NewCharm}},
    %% 日志
    lib_log_api:log_charm(RoleId, Charm, NewCharm, Extra),
    %% 触发成就
    {ok, LastPlayer} = lib_achievement_api:flower_get_event(NewPlayer, NewCharm),
    LastPlayer.