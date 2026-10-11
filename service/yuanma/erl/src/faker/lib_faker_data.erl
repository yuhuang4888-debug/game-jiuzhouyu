%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_faker_data.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-09-29
%%% @description    假人生成数据处理
%%% ------------------------------------------------------------------------------------------------
-module(lib_faker_data).

-include("common.hrl").
-include("def_module.hrl").
-include("faker.hrl").
-include("jjc.hrl").
-include("team.hrl").
-include("figure.hrl").
-include("reincarnation.hrl").

-export([]).

-compile(export_all).

%% -----------------------------------------------
%% @doc 获取构造假人所需的参数
-spec
get_faker_args(Mod, Data) -> #make_faker_args{} when
    Mod  :: integer(),
    Data :: term().
%% -----------------------------------------------
get_faker_args(?MOD_JJC, Rank) ->
    lib_jjc_data:get_faker_args(Rank);
get_faker_args(?MOD_DRUMWAR, DrumRole) ->
    lib_role_drum_data:get_faker_args(DrumRole);
get_faker_args(?MOD_TEAM, Mb) ->
    #mb{figure = #figure{lv = MbLv} = _MbFigure, server_num = SerNum, server_id = SerId} = Mb,
    case data_jjc:get_jjc_value(?JJC_MAX_RANK) of
        [] -> Rank = 0;
        [MaxRank] -> Rank = urand:rand(1, MaxRank)
    end,
    % figure
    case data_jjc:get_jjc_robot(Rank) of  %%
        [] -> Robot = #base_jjc_robot{};
        Robot -> ok
    end,
    #base_jjc_robot{
        power_range = PowerRange,
        rmount = RMount, rholyorgan = RHolyorgan
    } = Robot,
    LvRange = [MbLv, MbLv + 30],
    TurnRange = [0, ?MAX_TURN],
    #make_faker_args{
        server_id = SerId, server_num = SerNum, power_range = PowerRange, lv_range = LvRange,
        turn_range = TurnRange, mount_list = RMount, holyorgan_list = RHolyorgan
    };

get_faker_args(_Mod, _Data) ->
    ?ERR("err faker args:~p~n", [{_Mod, _Data}]).

%% -----------------------------------------------
%% @doc 获取假人路径
-spec
get_faker_path(Mod) -> term() when
    Mod :: integer().
%% -----------------------------------------------
get_faker_path(?MOD_JJC) ->
    case data_jjc:get_jjc_value(?JJC_BORN_POS) of
        [PosList] when is_list(PosList) ->
            [{X1, Y1}, {X2, Y2} | _] = PosList;
        _ -> X1 = Y1 = X2 = Y2 = 0
    end,
    K     = (Y2 - Y1) / (X2 - X1),
    B     = Y1 - K * X1,
    EndX1 = (X1 + X2) div 2 - 50,
    EndX2 = (X1 + X2) div 2 + 50,
    EndY1 = round(K * EndX1 + B),
    EndY2 = round(K * EndX2 + B),
    {
        [{X1, Y1}, {EndX1, EndY1}],
        [{X2, Y2}, {EndX2, EndY2}]
    }.