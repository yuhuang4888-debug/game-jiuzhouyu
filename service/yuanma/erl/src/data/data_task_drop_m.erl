%% ---------------------------------------------------------------------------
%% @doc data_task_drop_m.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-02-14
%% @deprecated 任务掉落手动配置
%% ---------------------------------------------------------------------------
-module(data_task_drop_m).

-compile(export_all).

%% 配置
get_config(T) ->
    case T of
        % 任务功能的挂机时间
        task_func_onhook_time -> 600 
    end.