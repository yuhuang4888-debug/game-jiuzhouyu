%% ---------------------------------------------------------------------------
%%% @Module  : lib_juewei
%%% @Author  : huyihao
%%% @Created : 2017.10.24
%%% @Description:  爵位
%% ---------------------------------------------------------------------------
-module(lib_juewei).

-include("server.hrl").
-include("common.hrl").
-include("juewei.hrl").
-include("figure.hrl").

-export([
        get_juewei_attr/1,
        juewei_login/1,
        sql_juewei/1,
        get_juewei_id_db/1
    ]).

get_juewei_attr(Ps) ->
    #player_status{figure = Figure} = Ps,
    #figure{juewei_lv = JueWeiLv} = Figure,
    case data_juewei:get_juewei_con(JueWeiLv) of
        [] -> [];
        #juewei_con{attr_list = JueWeiAttr} -> JueWeiAttr
    end.

juewei_login(Ps) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    JueWeiLv = get_juewei_id_db(RoleId),
    NewFigure = Figure#figure{
        juewei_lv = JueWeiLv
    },
    Ps#player_status{
        figure = NewFigure
    }.

get_juewei_id_db(RoleId) ->
    ReSql = io_lib:format(?SelectJueWeiSql, [RoleId]),
    case db:get_one(ReSql) of
        null ->
            0;
        JueWeiLv ->
            JueWeiLv
    end.

sql_juewei(Ps) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        juewei_lv = JueWeiLv
    } = Figure,
    ReSql = io_lib:format(?ReplaceJueWeiSql, [RoleId, JueWeiLv]),
    db:execute(ReSql).
