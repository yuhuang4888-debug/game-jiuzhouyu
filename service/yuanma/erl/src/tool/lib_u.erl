%% ---------------------------------------------------------------------------
%% @doc lib_u.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-06-30
%% @deprecated 热更新辅助文件
%% ---------------------------------------------------------------------------
-module(lib_u).

-compile(export_all).

%% load后事件
after_load_event(data_crontab) ->
    mod_crontab:reload_file();
after_load_event(data_crontab_cls) ->
    mod_crontab:reload_file();
after_load_event(data_push_gift) ->
    lib_push_gift_api:reload_file();
after_load_event(_) -> ok.