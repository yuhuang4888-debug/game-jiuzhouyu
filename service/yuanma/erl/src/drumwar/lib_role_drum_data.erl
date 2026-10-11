%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_role_drum_data.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-10-14
%%% @description    钻石大战数据相关
%%% ------------------------------------------------------------------------------------------------
-module(lib_role_drum_data).

-include("attr.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("drumwar.hrl").
-include("errcode.hrl").
-include("faker.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("server.hrl").

% -export([]).

-compile(export_all).

%%% =========================================== make/load ==========================================

make_record(Type, Args) ->
    throw({'EXIT', {"make record error", {Type, Args}}}).

%%% ========================================= get/set/calc =========================================

%% -----------------------------------------------
%% @doc 获取构造假人所需参数
-spec
get_faker_args(#drum_role{}) -> #make_faker_args{}.
%% -----------------------------------------------
get_faker_args(DrumRole) ->
    #drum_role{
        group = Group
        ,figure = #figure{lv=Lv, mount_figure = MountFigure}
        ,role_attr = Attr
        ,power = Power
    } = DrumRole,

    NewPower = umath:ceil((Power * (100 - 15) / 100)),
    Other = #{
        group => Group,
        role_attr => Attr,
        mount_figure => MountFigure
    },
    #make_faker_args{
        power_range = NewPower, lv_range = Lv,
        other = Other
    }.

%% -----------------------------------------------
%% @doc 计算假人战斗属性
-spec
get_faker_battle_attr(RoleAttr) -> FakerBAttr when
    RoleAttr :: #attr{},
    FakerBAttr :: #battle_attr{}.
%% -----------------------------------------------
get_faker_battle_attr(RoleAttr) ->
    FakerAttr = lib_role_drum:get_mon_attr(RoleAttr),
    #battle_attr{hp = FakerAttr#attr.hp, hp_lim = FakerAttr#attr.hp, speed = ?SPEED_VALUE, attr = FakerAttr}.

%%% ============================================== sql =============================================

sql(Func, Expr, Args) ->
    Sql = io_lib:format(Expr, Args),
    db:Func(Sql).
