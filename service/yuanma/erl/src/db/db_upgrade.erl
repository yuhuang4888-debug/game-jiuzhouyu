%% ---------------------------------------------------------------------------
%% @doc 数据库脚本升级管理
%% @author hek
%% @since  2016-09-08
%% @deprecated 本模块自动升级开发环境数据库脚本
%% ---------------------------------------------------------------------------
-module(db_upgrade).
-compile(export_all).
-include("common.hrl").

-ifdef(DEV_SERVER).
execute() ->
    init_mysql(),
    do_execute(),
    init:stop(),
    ok.
-else.
execute() ->
    ok.
-endif.

%% mysql数据库连接初始化
init_mysql() ->	
	case init:get_argument(config) of
		{ok, [[Config|_]|_]} ->
			[DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DBConns] = get_mysql(Config ++ ".config"),
    		db:start(DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DBConns);
		% ["cls"|_] ->
		% 	[DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DBConns] = get_mysql("cls.config"),
  %   		db:start(DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DBConns);
    	_ ->
    		?ERR("======db_upgrade init_mysql:~p~n ======", [error])
	end,
    ok.

%% 获取mysql参数
get_mysql(File) ->
    case file:consult(File) of
        {error, enoent} = Error ->
            ?ERR("init_mysql file ~p not exist error ~p ~n", [File, Error]),
            Config = [];
        {error, R} = Error ->
            ?ERR("init_mysql file error: ~p error ~p ~n", [file:format_error(R),Error]),
            Config = [];
        {ok, [Config]} -> Config
    end,
    case lists:keyfind(gsrv, 1, Config) of
    	{gsrv, ConfigList} -> skip;
    	_ -> ConfigList = []
    end,
    Host1 = case lists:keyfind(db_host, 1, ConfigList) of
                {db_host, Host} -> Host;
                _ -> "localhost"
            end,
    Port1 = case lists:keyfind(db_port, 1, ConfigList) of
                {db_port, Port} -> Port;
                _ -> 3306
            end,
    User1 = case lists:keyfind(db_user, 1, ConfigList) of
                {db_user, User} -> User;
                _ -> "root"
            end,
    Pass1 = case lists:keyfind(db_pass, 1, ConfigList) of
                {db_pass, Pass} -> Pass;
                _ -> "root"
            end,
    Name1 = case lists:keyfind(db_name, 1, ConfigList) of
                {db_name, Name} -> Name;
                _ -> "test"
            end,
    Encode1 = case lists:keyfind(db_encode, 1, ConfigList) of
                  {db_encode, Encode} -> Encode;
                  _ -> utf8
              end,
    Conns1 = case lists:keyfind(db_connections, 1, ConfigList) of
                 {db_connections, Conns} -> Conns;
                 _ -> 15
             end,
    [Host1, Port1, User1, Pass1, Name1, Encode1, Conns1].

do_execute() ->	
	LocalVersion = get_local_version(),
	ExecuteList = get_execute_list(LocalVersion),
    do_execute(ExecuteList).

do_execute(ExecuteList) ->
	F = fun({Version, FileName}) ->	    
                catch ?PRINT("======version start====== ~p~n", [Version]),
                catch ?ERR("======version start====== ~p", [Version]),	               
                case catch execute_version(Version, FileName) of
                    ok -> 
                        catch ?PRINT("======version finish====== ~p~n", [Version]),
                        catch ?ERR("======version finish====== ~p", [Version]),
                        skip;
                    Error -> 
                        catch ?ERR("execute: error ~p", [Error]), 
                        throw(Error)
                end	            	
        end,
    lists:foreach(F, ExecuteList).

execute_version(Version, FileName) ->
	execute_sql("../sql/"++FileName++".sql"),
	update_sql_version(Version),
	ok.

update_sql_version(Version) ->
	Sql = io_lib:format(<<"update `sql_version` set `version` =~p where 1">>, [Version]),
	db:execute(Sql).

get_execute_list(LocalVersion) ->
	List = data_db_upgrade:version_list(),
	FilterList = lists:filter(fun({Ver, _Name}) -> Ver>LocalVersion end, List),
	lists:keysort(1, FilterList).

get_local_version() ->
	init_version(),
	get_version().

get_now_version() ->
	case lists:reverse(lists:keysort(1, data_db_upgrade:version_list())) of
		[] -> 0;
		[{NowVersion, _Name}|_] -> NowVersion
	end.

get_version() ->
	NowVersion = get_now_version(),
	Sql = io_lib:format(<<"select `version` from `sql_version` limit 1">>, []),
	case db:get_one(Sql) of
		null -> 
			db:execute(io_lib:format(<<"insert into `sql_version`(`version`) values(~p)">>, [NowVersion])),
			NowVersion;
		Version -> Version
	end.

init_version() ->
	Sql = io_lib:format(<<"show tables like '~p'">>, [sql_version]),
	case db:get_one(Sql) of
		<<"sql_version">> -> skip;
		_ -> 
			execute_sql("../sql/version_init.sql"),
			db:execute(io_lib:format(<<"insert into `sql_version`(`version`) values(~p)">>, [get_now_version()]))
	end.

%% @doc 执行一个sql文件指令
execute_sql(FileName) ->
    case file:open(FileName, read) of
		{ok, IoDevice} ->
			String = read_line(FileName, IoDevice, ""),
			SqlList = re:split(String, ";"),
			F = fun(Cmd) ->
                        Sql = util:replace(Cmd, [{"\n", ""}, {"\t", ""}]),	        
                        case util:replace(Sql, [{" ", ""}]) of
                            <<>> -> skip;
                            [] -> skip;
                            _ -> db:execute(Sql)
                        end
                end,
			lists:foreach(F, SqlList),
            file:close(IoDevice);
		Error ->
            catch ?ERR("execute_sql file:~p  error ~p", [FileName, Error]),
            throw(Error)
    end.

%% @doc 按行读取文件，忽略注释的行
read_line(FileName, Device, Res) ->
	case file:read_line(Device) of
		{ok, Sql} ->
			case re:run(Sql, "--") of
        		nomatch -> read_line(FileName, Device, [Sql|Res]);
        		_ -> read_line(FileName, Device, Res)
        	end;
		eof -> lists:reverse(Res);
		Error -> 
			catch ?ERR("execute_sql file read_line:~p  error ~p", [FileName, Error]),
			Res
	end.
