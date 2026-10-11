%% ---------------------------------------------------------------------------
%% @doc 服务器版本号管理
%% @author hek
%% @since  2018-4-28
%% @deprecated 本模块自动生成的，请不要手动修改
%% ---------------------------------------------------------------------------
-module(data_version).
-export([
    server_version/0
    ,server_version_time/0
]).

%% 当前服务器版本号
server_version() -> "0.01".

%% 当前服务器版本时间
server_version_time() ->
    Version = server_version(),
    ServerVersionList = server_version_list(),    
    case lists:keyfind(Version, 1, ServerVersionList) of
        {Version, VersionTime} -> VersionTime;
        _ -> "2018.01.01"
    end.

%% 服务器版本号列表
%% @return {版本号, 版本时间}
server_version_list() ->
    [
        {"0.01", "2018.5.26"}
        , {"0.00", "2018.5.1"}
    ].
