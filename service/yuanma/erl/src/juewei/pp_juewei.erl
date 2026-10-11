%%%--------------------------------------
%%% @Module  : pp_juewei
%%% @Author  : huyihao
%%% @Created : 2017.10.24
%%% @Description:  爵位
%%%--------------------------------------

-module(pp_juewei).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("juewei.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").

handle(16600, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv,
        juewei_lv = JueWeiLv
    } = Figure,
    case Lv < ?OpenLv of
        true ->
            Code = ?ERRCODE(lv_limit);
        false ->
            Code = ?ERRCODE(success)
    end,
    {ok, Bin} = pt_166:write(16600, [Code, JueWeiLv]),
    lib_server_send:send_to_uid(RoleId, Bin);

handle(16601, Ps, []) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        scene_pool_id = SPId,
        copy_id = CopyId,
        x = X,
        y = Y,
        figure = Figure,
        combat_power = CombatPower
    } = Ps,
    #figure{
        name = Name,
        lv = Lv,
        juewei_lv = JueWeiLv
    } = Figure,
    case Lv < ?OpenLv of
        true ->
            Code = ?ERRCODE(lv_limit),
            NewJueWeiLv = 0,
            NewPs = Ps;
        false ->
            case data_juewei:get_juewei_con(JueWeiLv + 1) of
                [] ->
                    Code = ?ERRCODE(err166_juewei_max),
                    NewJueWeiLv = JueWeiLv,
                    NewPs = Ps;
                JueWeiCon ->
                    #juewei_con{
                        juewei_name = JuewWeiName,
                        need_power = NeedPower,
                        goods_list = GoodsList,
                        color = ColorId
                    } = JueWeiCon,
                    case CombatPower < NeedPower of
                        true ->
                            Code = ?ERRCODE(err166_juewei_power_max),
                            NewJueWeiLv = JueWeiLv,
                            NewPs = Ps;
                        false ->
                            case lib_goods_api:cost_object_list_with_check(Ps, GoodsList, juewei, "") of
                                {true, NewPs2} ->
                                    Code = ?ERRCODE(success),
                                    NewJueWeiLv = JueWeiLv + 1,
                                    NewFigure = Figure#figure{
                                        juewei_lv = NewJueWeiLv
                                    },
                                    NewPs1 = NewPs2#player_status{
                                        figure = NewFigure
                                    },
                                    NewPs = lib_player:count_player_attribute(NewPs1),
                                    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
                                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                    lib_juewei:sql_juewei(NewPs),
                                    {ok, BinData} = pt_166:write(16602, [RoleId, NewJueWeiLv]),
                                    lib_server_send:send_to_area_scene(SceneId, SPId, CopyId,  X, Y, BinData),
                                    lib_log_api:log_juewei_level_up(RoleId, JueWeiLv, JueWeiLv+1),
                                    lib_achievement_api:juewei_lv_up(NewPs, JueWeiLv+1),
                                    lib_chat:send_TV({all}, ?MOD_JUEWEI, 1, [Name, ColorId, JuewWeiName]);
                                {false, Code, NewPs} ->
                                    NewJueWeiLv = JueWeiLv
                            end
                    end
            end
    end,
    {ok, Bin} = pt_166:write(16601, [Code, NewJueWeiLv]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

handle(_, PlayerStatus, _) ->
  {ok, PlayerStatus}.