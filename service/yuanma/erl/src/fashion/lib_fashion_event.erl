%%%--------------------------------------
%%% @Module  : lib_fashion
%%% @Author  : chenxiaodong
%%% @Created : 2020.08.03
%%% @Description:  时装事件触发
%%%--------------------------------------

-module(lib_fashion_event).

-include("server.hrl").
-include("common.hrl").
-include("mount.hrl").
-include("figure.hrl").

-export([event/2]).

%% 基础触发
event(base, [PS, NewFashionModelList]) ->
	#player_status{id = RoleId, scene = SceneId, scene_pool_id = SPId, copy_id = CopyId, x = X, y = Y} = PS,
	%% 更新场景玩家时装
    mod_scene_agent:update(PS, [{fashion_model, NewFashionModelList}]),
    {ok, BinData} = pt_413:write(41311, [RoleId, NewFashionModelList]),
    lib_server_send:send_to_area_scene(SceneId, SPId, CopyId,  X, Y, BinData),
	lib_team_api:update_team_mb(PS, [{figure, PS#player_status.figure}]),
    lib_role:update_role_show(RoleId, [{figure, PS#player_status.figure}]);

%% 染色或时装激活
event(activate, [PS, PosId]) ->
	event(put_on, [PS, PosId]);

%% 穿戴
event(put_on, [PS, PosId]) ->
	Figure = PS#player_status.figure,
	NewFashionModelList = lib_fashion:get_equip_fashion_list_ps(PS),
    NewFigure = Figure#figure{fashion_model = NewFashionModelList},
    FigurePS = PS#player_status{figure = NewFigure},
	event(base, [FigurePS, NewFashionModelList]),
	case PosId == 2 of 
	    true ->
	        MountPS = lib_mount:clear_figure_id_api(FigurePS, ?HOLYORGAN_ID);
	    _ ->
	        MountPS = FigurePS
	end,
    {ok, LastPS} = lib_fashion_api:take_off_other(fashion, MountPS),    % 脱掉其它时装（神殿、套装、天启）
	case LastPS#player_status.figure#figure.guild_id > 0 of
        true -> mod_guild:update_guild_member_attr(LastPS#player_status.id, [{figure, LastPS#player_status.figure}]);
        false -> skip
    end,
    {ok, LastPS};

%% 脱下
event(put_off, [PS, NewFashionModelList, PosId]) ->
	event(base, [PS, NewFashionModelList]),
	case PosId == 2 of 
	    true ->
	        MountPS = lib_mount:clear_figure_id_api(PS, ?HOLYORGAN_ID);
	    _ ->
	        MountPS = PS
	end,
	case MountPS#player_status.figure#figure.guild_id > 0 of
        true -> mod_guild:update_guild_member_attr(MountPS#player_status.id, [{figure, MountPS#player_status.figure}]);
        false -> skip
    end,
    {ok, MountPS};

event(_, _) ->
	skip.