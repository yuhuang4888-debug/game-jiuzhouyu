%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_jjc_data.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-10-14
%%% @description    竞技场数据相关
%%% ------------------------------------------------------------------------------------------------
-module(lib_jjc_data).

-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("faker.hrl").
-include("jjc.hrl").
-include("predefine.hrl").
-include("reincarnation.hrl").
-include("server.hrl").

% -export([]).

-compile(export_all).

%%% =========================================== make/load ==========================================

make_record(Type, Args) ->
    throw({'EXIT', {"make record error", {Type, Args}}}).

%%% ========================================= get/set/calc =========================================

%% -----------------------------------------------
%% @doc 获取构造假人所需的参数
-spec
get_faker_args(Data) -> #make_faker_args{} when
    Data :: term().
%% -----------------------------------------------
get_faker_args(Rank) ->
    #base_jjc_robot{
        power_range = PowerRange, lv_range = LvRange,
        rmount = RMount, rmate = RMate, rfly = RFly, rholyorgan = RHolyorgan
    } = data_jjc:get_jjc_robot(Rank),

    #make_faker_args{
        power_range = PowerRange, lv_range = LvRange, turn_range = [0, ?MAX_TURN]
        , mount_list = RMount, wing_list = RFly, holyorgan_list = RHolyorgan
        , companion_list = RMate
        , attr_coe = data_jjc:get_power_attr()
    }.

%%% ============================================== sql =============================================

sql(Func, Expr, Args) ->
    Sql = io_lib:format(Expr, Args),
    db:Func(Sql).
