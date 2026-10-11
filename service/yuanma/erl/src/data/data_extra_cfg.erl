%%-----------------------------------------------------------------------------
%% @Module  :       data_extra_cfg
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-06
%% @Description:    额外配置
%%-----------------------------------------------------------------------------
-module(data_extra_cfg).

-include("extra.hrl").
-include("custom_act.hrl").
-include("guess.hrl").
-include("common.hrl").

-compile([export_all]).

%% 备注:
%% 由于动态编译的文件不能包含头文件,所以record里面字段的顺序要跟数据库的顺序一致

get_extra_cfg(?EXTRA_CFG_CUSTOM_ACT) ->
    #{
        module => "data_extra_custom_act",                  %% 配置名字
        % hrl => ["custom_act.hrl"],                        %% 外服没有头文件, 所以生成的动态配置文件里面的record要转成tuple
        function => [
            #{
                table => "base_custom_act",                 %% 数据库表名
                func_type => ?EXTRA_CFG_FUNC_TYPE_1,        %% 函数接口类型
                record => "custom_act_cfg",                 %% Record
                name => "get_act_info",                     %% 函数名字
                input => [type, subtype],                   %% 输入的字段
                time_form => [start_time, end_time]         %% 需要转换为时间戳的字段
            },
            #{
                table => "base_custom_act",
                func_type => ?EXTRA_CFG_FUNC_TYPE_2,
                name => "get_act_list",
                out_put => [type, subtype]                  %% 输出的字段
            }
        ]
    };
get_extra_cfg(?EXTRA_CFG_GUESS) ->
    #{
        module => "data_extra_guess",
        function => [
            #{
                table => "extra_base_guess_info_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_1,
                record => "guess_info_config",
                name => "get_guess_info",
                input => [game_type],
                time_form => [start_time, end_time, clear_time]
            },
            #{
                table => "extra_base_guess_info_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_2,
                name => "get_guess_game_type_list",
                out_put => [game_type]
            },
            #{
                table => "extra_base_guess_single_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_1,
                record => "guess_single_config",
                name => "get_guess_single",
                input => [game_type, subtype, id],
                time_form => [game_start_time, guess_end_time]
            },
            #{
                table => "extra_base_guess_single_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_3,
                name => "get_guess_single_id_list",
                input => [game_type, subtype],
                out_put => [id]
            },
            #{
                table => "extra_base_guess_single_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_3,
                name => "get_guess_subtype_list",
                input => [game_type],
                out_put => [game_type, subtype]
            },
            #{
                table => "extra_base_guess_group_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_1,
                record => "guess_group_config",
                name => "get_guess_group",
                input => [game_type, id],
                time_form => [guess_start_time, guess_end_time]
            },
            #{
                table => "extra_base_guess_group_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_3,
                name => "get_guess_group_id_list",
                input => [game_type],
                out_put => [id]
            },
            #{
                table => "extra_base_guess_group_config",
                func_type => ?EXTRA_CFG_FUNC_TYPE_3,
                name => "get_guess_group_id_list_by_group_type",
                input => [game_type, group_type],
                out_put => [id]
            }
        ]
    }.