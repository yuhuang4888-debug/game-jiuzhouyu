%%%-----------------------------------
%%% @Module  : config
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.12
%%% @Description: 获取 .config里的配置信息
%%%-----------------------------------
-module(config).
-include("predefine.hrl").
-export([
    get_log_level/0,
    get_log_path/0,
    get_ticket/0,
    get_mysql/0,
    get_mysql/1,
    get_card/0,
    get_phone_gift/0,
    get_cls_type/0,
    get_cls_info/0,
    get_cls_node/0,
    get_cls_cookie/0,
    get_platform/0,
    get_server_num/0,
    get_server_id/0,
    get_merge_server_ids/0,
    get_is_shenhe/0,
    get_sy_internal_devp/0,
    get_branch/0,
    get_server_version/0,
    get_gm_password/0,
    get_server_type/0
]).

%% 日志系统配置文件
get_log_level() ->
    case application:get_env(gsrv, log_level) of
        {ok, LogLevel} -> LogLevel;
        _ -> 3
    end.

get_log_path() ->
    case application:get_env(gsrv, log_path) of
        {ok, LogPath} -> LogPath;
        _ -> "../logs"
    end.

%% 私钥
get_ticket() ->
    case application:get_env(gsrv, ticket) of
        {ok, Ticket} -> Ticket;
        _ -> "ticket"
    end.

%% 获取新手卡
get_card() ->
    Key = case application:get_env(gsrv, card_key) of
              {ok, _Key} -> _Key;
              _ -> "key"
          end,

    Ser = case application:get_env(gsrv, card_server) of
              {ok, _Ser} -> _Ser;
              _ -> []
          end,
    {Key, Ser}.

%% 手机钱包开关(0关，1开)
get_phone_gift() ->
    case application:get_env(gsrv, phone_gift) of
        {ok, Gift} -> Gift;
        _ -> 0
    end.


%% 获取mysql参数
get_mysql() ->
    Host1 = case application:get_env(gsrv, db_host) of
                {ok, Host} -> Host;
                _ -> "localhost"
            end,
    Port1 = case application:get_env(gsrv, db_port) of
                {ok, Port} -> Port;
                _ -> 3306
            end,
    User1 = case application:get_env(gsrv, db_user) of
                {ok, User} -> User;
                _ -> "root"
            end,
    Pass1 = case application:get_env(gsrv, db_pass) of
                {ok, Pass} -> Pass;
                _ -> "root"
            end,
    Name1 = case application:get_env(gsrv, db_name) of
                {ok, Name} -> Name;
                _ -> "test"
            end,
    Encode1 = case application:get_env(gsrv, db_encode) of
                  {ok, Encode} -> Encode;
                  _ -> utf8
              end,
    Conns1 = case application:get_env(gsrv, db_connections) of
                 {ok, Conns} -> Conns;
                 _ -> 15
             end,
    [Host1, Port1, User1, Pass1, Name1, Encode1, Conns1].

%% DBKey = db_host|db_port|db_user|db_pass|db_name|db_encode|db_connections
get_mysql(DBKey) ->
    case application:get_env(gsrv, DBKey) of
        {ok, Value} -> Value;
        _ -> false
    end.

%% 跨服类型
get_cls_type() ->
    case application:get_env(gsrv, cls_type) of
        {ok, Type} -> Type;
        _ -> 0
    end.

%% 跨服节点信息
get_cls_info() ->
    Node = get_cls_node(),
    Cookie = get_cls_cookie(),
    Ip = get_cls_ip(),
    Port = get_cls_port(),
    {Node, Cookie, Ip, Port}.

%% 跨服节点
get_cls_node() ->
    case application:get_env(gsrv, cls_node) of
        {ok, Node} -> Node;
        _ -> 'cls@127.0.0.1'
    end.

%% 跨服节点
get_cls_cookie() ->
    case application:get_env(gsrv, cls_cookie) of
        {ok, Cookie} -> Cookie;
        _ -> erlang:get_cookie()
    end.

%% 获取跨服节点ip
get_cls_ip() ->
    case application:get_env(gsrv, cls_node) of
        {ok, Node} ->
            [_T, Ip] = string:tokens(atom_to_list(Node), "@"),
            Ip;
        _ -> '127.0.0.1'
    end.

%% 获取跨服节点端口
get_cls_port() ->
    case application:get_env(gsrv, cls_port) of
        {ok, Port} -> Port;
        _ -> 0
    end.

%% 获取平台名
get_platform() ->
    case application:get_env(gsrv, platform) of
        {ok, Platform} -> Platform;
        _ -> ""
    end.

%% 获取当前所在的服名
get_server_num() ->
    case application:get_env(gsrv, server_num) of
        {ok, ServerNum} -> ServerNum;
        _ -> 0
    end.

%% 获取本服id
get_server_id() ->
    case application:get_env(gsrv, server_id) of
        {ok, Id} -> Id;
        _ -> 0
    end.

%% 获取合服后所有的服id
get_merge_server_ids() ->
    case application:get_env(gsrv, merge_server_ids) of
        {ok, Ids} -> Ids;
        _ -> []
    end.

%% 获取是否审核服
get_is_shenhe() -> 
    case application:get_env(gsrv, shenhe) of
        {ok, 1} -> true;
        _ -> false
    end.

%% 开发版本标志，方便判断开发版本和正式版本功能
get_sy_internal_devp() ->
    case application:get_env(gsrv, sy_internal_devp) of
        {ok, SyDepKf} -> SyDepKf;
        _ -> 0
    end.

%% 分支
get_branch() ->
    case application:get_env(gsrv, branch) of
        {ok, Branch} -> Branch;
        _ -> undefined
    end.

%% 获取秘籍的密码
get_gm_password() ->
    case application:get_env(gsrv, gm_password) of
        {ok, GmPassword} -> GmPassword;
        _ -> ""
    end.

%% 服务端版本    
get_server_version() ->
    1.
%% 获取服类型
get_server_type() ->
    util:get_server_type().