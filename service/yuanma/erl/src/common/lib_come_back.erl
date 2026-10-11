%% %% ----------------------------------------------------
%% %% @author
%% %% @doc
%% %% 删档充值玩家回归奖励
%% %% created
%% %% @end
%% %% ----------------------------------------------------
-module(lib_come_back).

-export([
         come_back_login/2,
         export_sql/0,
         change_case/2,
         cross_check_rebate/1,
         check_rebate_callback/6,
         do_give_awards/4,
         handle_event/2,
         festival_gift_mail/0
        ]).
-include("server.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("sql_player.hrl").

%% 测试服测试时的数据，用特定接口导出后，导入到正式服库表使用
%% 使用时，根据测试数据生成 #come_back_history{}
-record(come_back_history, {
          role_level = 0,     %% 玩家等级
          charge_gold = 0,    %% 充值钻石数量
          vip_exp = 0         %% vip经验
         }).

%% 模式
-define(REBATE_MODE, ?MODE_SERVER).             % 返利模式选择
-define(MODE_SERVER, 0).                        % 游戏服返利（数据配置在各游戏服）
-define(MODE_CROSS,  1).                        % 跨服返利（数据配置在跨服，共享一份返利数据）

%% 是否处理过回归数据的状态
-define(COME_BACK_STATE_UNDO, 0).               % 未处理过
-define(COME_BACK_STATE_GOT, 1).                % 本角色已经取得
-define(COME_BACK_STATE_OTHER_GOT, 2).          % 其他角色取得
-define(COME_BACK_STATE_NOT_BACK, 3).           % 非回归角色
-define(COME_BACK_STATE_PENDING, 4).            % 本角色应取得，但跨服处理时不在线，等待下次处理

%% 数据是否已使用过
-define(DATA_STATE_UNUSE, 0).                   % 数据未使用
-define(DATA_STATE_USED,  1).                   % 数据已使用

%% 新版判断
-define(URL,     "http://admin.userpic.suyougame.com/api/api_admin.php").
-define(APP_KEY, "414de19367d6eea5ee1014fa75917aa4").

%% 玩家登录之后判断玩家返利状况
%% handle_event(Ps, #event_callback{type_id = ?EVENT_LOGIN_CAST})->
%%     #player_status{id = RoleId, platform = Pform,
%%                    server_num = SNum, server_id = SId,
%%                    accid = AccId, accname = AccName,
%%                    figure = #figure{name = Name}} = Ps,
%%     NowTime = utime:unixtime(),
%%     if 
%%         %% 漫灵联运|漫灵硬核 + 时间大于2018年6月21日9点30分
%%         (Pform == "mlly" orelse Pform == "mlyh") andalso NowTime < 1529544600 ->
%%             %% 玩家帐号共享状态
%%             case get({acc_share_data, RoleId}) of 
%%                 undefined ->
%%                     SQL = io_lib:format(?sql_select_acc_share_data, [AccId, AccName]),
%%                     case db:get_one(SQL) of
%%                         ComeBackState when is_integer(ComeBackState) ->
%%                             put({acc_share_data, RoleId}, ComeBackState);
%%                         _ ->
%%                             ComeBackState = ?COME_BACK_STATE_UNDO
%%                     end;
%%                 ComeBackState -> skip
%%             end,
%%             if 
%%                 ComeBackState =/= ?COME_BACK_STATE_UNDO -> skip;
%%                 true ->
%%                     AuthBin = util:md5(lists:concat([?APP_KEY, NowTime, "come_back"])),
%%                     NewRoleInfo = util:term_to_string([{RoleId, Name, Pform, SNum, SId}]),
%%                     PostData = [{accname, AccName}, {method, come_back}, {game, bfqs},
%%                                 {time, NowTime}, {sign, AuthBin}, {now_role, NewRoleInfo}],
%%                     EncodeParams = mochiweb_util:urlencode(PostData),
%%                     case catch httpc:request(post, {?URL, [], 
%%                                                     "application/x-www-form-urlencoded",
%%                                                     EncodeParams}, [{timeout, 3000}], []) of
%%                         {ok, {_, _, Res}}->
%%                             do_handle_res(AccId, AccName, RoleId, Res);
%%                         _Error ->
%%                             ?ERR("trigger card err:~p~n", [_Error])
%%                     end
%%             end;
%%         true ->
%%             skip
%%     end,
%%     {ok, Ps};
handle_event(Ps, _) ->
    {ok, Ps}.

%% do_handle_res(AccId, AccName, RoleId, Res)->
%%     case catch mochijson2:decode(Res) of
%%         {'EXIT', _R} ->
%%             ?ERR("trigger card err:~p~n", [Res]),
%%             skip;
%%         JsonTuple ->
%%             case catch lib_gift_card:extract_mochijson2([<<"ret">>], JsonTuple) of
%%                 [0] -> %% 成功
%%                     case lib_gift_card:extract_mochijson2([<<"data">>, <<"gold">>], JsonTuple) of
%%                         [Gold] when is_integer(Gold)->
%%                             case update_come_back_state_acc(AccId, AccName, ?COME_BACK_STATE_GOT) of
%%                                 true -> %% 现在暂定是100%钻石+100%绑定钻石
%%                                     put({acc_share_data, RoleId}, ?COME_BACK_STATE_GOT),
%%                                     T = data_language:get(1020001),
%%                                     C = utext:get(1020002, [Gold, 100, 100]),
%%                                     Reward = [{?TYPE_GOLD, ?GOODS_ID_GOLD, Gold}, {?TYPE_BGOLD, ?GOODS_ID_GOLD, Gold}],
%%                                     lib_mail_api:send_sys_mail([RoleId], T, C, Reward);
%%                                 _ ->
%%                                     ?ERR("~p ~p update come back error:~p~n", [?MODULE, ?LINE, [AccId, AccName]]),
%%                                     skip
%%                             end;
%%                         _R ->
%%                             ?ERR("~p ~p Gold_R:~p~n", [?MODULE, ?LINE, _R]),
%%                             skip
%%                     end;
%%                 [1] ->
%%                     put({acc_share_data, RoleId}, ?COME_BACK_STATE_GOT),
%%                     update_come_back_state_acc(AccId, AccName, ?COME_BACK_STATE_GOT);
%%                 [2] -> %% 没有返还记录
%%                     put({acc_share_data, RoleId}, ?COME_BACK_STATE_NOT_BACK),
%%                     update_come_back_state_acc(AccId, AccName, ?COME_BACK_STATE_NOT_BACK);
%%                 Other ->
%%                     ?ERR("~p ~p Other:~p~n", [?MODULE, ?LINE, Other])
%%             end
%%     end.

%% update_come_back_state_acc(AccId, AccName, ComeBackState)->
%%     SQL = io_lib:format(?sql_select_acc_share_data, [AccId, AccName]),
%%     case db:get_one(SQL) of
%%         [_|_] ->
%%             UpSQL = io_lib:format(?sql_update_come_back_acc_share_data,
%%                                   [ComeBackState, AccId, AccName]),
%%             db:execute(UpSQL) >= 1;
%%         _ ->
%%             RpSQL = io_lib:format(?sql_replace_acc_share_data, [AccId, AccName, ComeBackState]),
%%             db:execute(RpSQL) >= 1
%%     end.


%% ================================= 旧版返利 =================================
%% 玩家登录检查玩家的回归状态
come_back_login(_Ps, State) when State == ?COME_BACK_STATE_GOT;
                                State == ?COME_BACK_STATE_OTHER_GOT;
                                State == ?COME_BACK_STATE_NOT_BACK ->
    skip;
come_back_login(Ps, ComeBackState) ->
    #player_status{id = RoleId, figure = #figure{name = Name},
                   accname = AccName,  source = Source, platform = Platform,
                   server_num = ServerNum, server_id = ServerId} = Ps,
    if
        ComeBackState == ?COME_BACK_STATE_PENDING andalso ?REBATE_MODE == ?MODE_CROSS ->
            Args = [{Platform, ServerNum, ServerId, RoleId, Name, AccName, Source, retry}],
            mod_clusters_node:apply_cast(?MODULE, cross_check_rebate, Args);

        ComeBackState == ?COME_BACK_STATE_UNDO andalso ?REBATE_MODE == ?MODE_CROSS ->
            Args = [{Platform, ServerNum, ServerId, RoleId, Name, AccName, Source, normal}],
            mod_clusters_node:apply_cast(?MODULE, cross_check_rebate, Args);

        ComeBackState == ?COME_BACK_STATE_UNDO andalso ?REBATE_MODE == ?MODE_SERVER ->
            case get_come_back_from_db(AccName, Source, RoleId) of
                [] -> %% 没数据
                    update_come_back_state(RoleId, ?COME_BACK_STATE_NOT_BACK);
                {?DATA_STATE_USED, []} -> %% 已被其他角色捷足先登
                    update_come_back_state(RoleId, ?COME_BACK_STATE_OTHER_GOT);
                {?DATA_STATE_USED, _UsedList} -> %% 已由自己获得
                    update_come_back_state(RoleId, ComeBackState);
                {?DATA_STATE_UNUSE, UnUsedL} -> %% 数据未被使用过
                    {AIds, ComeBackHis} = get_history_data_by_list(UnUsedL),
                    case ComeBackHis of
                        #come_back_history{} ->
                            do_give_awards(Ps, AIds, ComeBackState, ComeBackHis);
                        _ -> %% 忽略，下次触发时会再尝试处理
                            skip
                    end;
                _ -> %% 查找数据出错
                    ?ERR("find come back data error, role id [~w], accname [~ts]", [RoleId, AccName]),    
                    skip
            end;
        true ->
            skip
    end.

%% 玩家登录请求跨服中心触发检查玩家回归数据
cross_check_rebate({Pform, SNum, SId, RoleId, Name, AccName, Source, Type}) ->
    CallbackArgs =
        case get_come_back_from_db(AccName, Source, RoleId) of
            {?DATA_STATE_UNUSE, UnusedList} ->
                {AIds, ComeBackHis} = get_history_data_by_list(UnusedList),
                case ComeBackHis of
                    #come_back_history{} ->
                        NewRoleInfo = [{RoleId, Name, Pform, SNum, SId}],
                        F = fun() -> set_come_back_data_used(AIds, NewRoleInfo) end,
                        case db:transaction(F) of
                            true ->
                                [RoleId, ?DATA_STATE_UNUSE, AIds, ?COME_BACK_STATE_GOT, ComeBackHis, Type];
                            _Error ->
                                skip
                        end;
                    _ -> %% 忽略，下次触发时会再尝试处理
                        skip
                end;
            {?DATA_STATE_USED, []} -> %% 已被其他角色捷足先登
                [RoleId, ?DATA_STATE_USED, [], ?COME_BACK_STATE_OTHER_GOT, undefined, Type];
            {?DATA_STATE_USED, MatchUsedList} -> %% 已由自己获得
                {AIds, ComeBackHis} = get_history_data_by_list(MatchUsedList),
                case ComeBackHis of
                    #come_back_history{} ->
                        %% 避免游戏服未保存成功，只要有请求，就重新从已触发的返利数据中，获取账号相同，
                        %% 并且是标示为已发送给自己的项目中取得奖励数据，通知游戏服发放奖励
                        %% 游戏服通过更新指定状态的数据，来避免重复发送奖励，保证只能发一次
                        [RoleId, ?DATA_STATE_USED, AIds, ?COME_BACK_STATE_GOT, ComeBackHis, Type];
                    false ->
                        skip
                end;
            [] -> %% 没有历史数据的角色
                [RoleId, undefined, [], ?COME_BACK_STATE_NOT_BACK, undefined, Type];
            _ ->
                %% 查找数据出错
                ?ERR("find come back data error:platform:~ts,server_num:~w,id:~w,account:~ts,source:~ts",
                     [Pform, SNum, RoleId, AccName, Source]),
                skip
        end,
    if 
        CallbackArgs == skip -> skip;
        true -> mod_clusters_center:apply_cast(SId, ?MODULE, check_rebate_callback, CallbackArgs)
    end.


%% 跨服模式游戏服回调处理回归状态与奖励
%% DataState    : ?DATA_STATE_USED | ?DATA_STATE_UNUSE | undefined
%% ComeBackState: ?COME_BACK_STATE_GOT | ...
%% ComeBackHis  : #come_back_history{} | undefined
check_rebate_callback(RoleId, DataState, AIds, ComeBackState, ComeBackHis, Type) ->
    case {DataState, ComeBackState} of
        {undefined, _} -> %% 找不到充值数据的
            update_come_back_state(RoleId, ComeBackState);

        {?DATA_STATE_USED, ?COME_BACK_STATE_GOT} -> %%
            case Type of
                retry   -> OldComeBackState = ?COME_BACK_STATE_PENDING;
                _Normal -> OldComeBackState = ?COME_BACK_STATE_UNDO
            end,
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, do_give_awards,
                                  [AIds, OldComeBackState, ComeBackHis]);

        {?DATA_STATE_USED, _} -> %% 保存修改状态
            update_come_back_state(RoleId, ComeBackState);

        {?DATA_STATE_UNUSE, ?COME_BACK_STATE_GOT} -> %% 由本人获得
            case lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, do_give_awards,
                                       [AIds, ?COME_BACK_STATE_UNDO, ComeBackHis]) of
                skip -> %% 当前不在线，应记录状态等待下次上线处理
                    update_come_back_state(RoleId, ?COME_BACK_STATE_PENDING, ?COME_BACK_STATE_UNDO);
                _ ->
                    ok
            end;
        {?DATA_STATE_UNUSE, _} ->
            update_come_back_state(RoleId, ComeBackState);
        _ ->
            skip
    end.

%% 从数据库中查询角色回归历史数据
get_come_back_from_db(AccName, _Source, RoleId) ->
    %% 最新规则,只要账号一致就返,不管渠道是否一致
    %% 如此一来需要合并多条数据进行返利(而非一条)逻辑需调整
    SQL = <<"select `id`,`state`,`source`,`data`,`now_role` from come_back where accname='~s'">>,
    case db:get_all(io_lib:format(SQL, [AccName])) of
        [] -> [];
        List when is_list(List) ->
            case do_come_back_match(List, [], [], [], RoleId) of
                {UsedL, _UnUsedL} when UsedL =/= []->
                    {?DATA_STATE_USED, UsedL};
                {_UsedL, UnUsedL} when UnUsedL =/= []->
                    {?DATA_STATE_UNUSE, UnUsedL};
                _ -> %% 其他情况默认:被使用了
                    {?DATA_STATE_USED, []}
            end;
        _ -> false
    end.

do_come_back_match([], UsedL, _UnKnowUsedL, UnUsedL, _RoleId) ->
    {UsedL, UnUsedL};
do_come_back_match([H|List], UsedL, UnKnowUsedL, UnUsedL, RoleId)->
    case H of
        [_AId, State, _Source, _BData, BRoleInfos] ->
            RoleInfos = case util:bitstring_to_term(BRoleInfos) of
                          undefined -> [];
                          _BRoleInfos -> _BRoleInfos
                      end,
            IsUsed = lists:keyfind(RoleId, 1, RoleInfos),
            if
                IsUsed =/= false andalso State == ?DATA_STATE_USED ->
                    do_come_back_match(List, [H|UsedL], UnKnowUsedL, UnUsedL, RoleId);
                State == ?DATA_STATE_USED ->
                    do_come_back_match(List, UsedL, [H|UnKnowUsedL], UnUsedL, RoleId);
                true ->
                    do_come_back_match(List, UsedL, UnKnowUsedL, [H|UnUsedL], RoleId)
            end;
        _ ->
            do_come_back_match(List, UsedL, UnKnowUsedL, UnUsedL, RoleId)
    end.

%% 游戏服模式发放回归奖励
do_give_awards(Ps, AIds, OldComeBackState, ComeBackR ) ->
    #player_status{id = RoleId, figure = #figure{name = Name},
                   platform = Pform, server_num = SNum, server_id = SId} = Ps,
    #come_back_history{charge_gold = ChargeGold} = ComeBackR,
    case ?REBATE_MODE of
        ?MODE_CROSS ->
            Res = update_come_back_state(RoleId, ?COME_BACK_STATE_GOT, OldComeBackState);
        ?MODE_SERVER ->
            NewRoleInfo = [{RoleId, Name, Pform, SNum, SId}],
            F = fun() ->
                        set_come_back_data_used(AIds, NewRoleInfo) andalso
                        update_come_back_state(RoleId, ?COME_BACK_STATE_GOT, OldComeBackState)
                end,
            Res = db:transaction(F)
    end,
    if
        Res == true andalso ChargeGold > 0 ->
            T = data_language:get(1020001),
            C = utext:get(1020002, [ChargeGold]),
            lib_mail_api:send_sys_mail([RoleId], T, C, [{?TYPE_GOLD, ?GOODS_ID_GOLD, util:floor(ChargeGold*2)}]);
        true ->
            skip
    end.

%% 设置状态为已使用(影响行数等于列表长度才表明全部操作成功，放事务中运行以保证非全部成功时自动回滚)
set_come_back_data_used(AIds, RoleInfo) when is_list(AIds) ->
    case AIds of
        [AId] ->
            set_come_back_data_used(AId, RoleInfo);
        _ ->
            Len = length(AIds),
            NAIds = lists:flatten(AIds),
            StrAIds = util:link_list(NAIds),
            StrRoleInfo = util:term_to_string(RoleInfo),
            SQL = <<"UPDATE come_back SET `state`=~w, now_role='~ts' WHERE `id` IN (~ts) AND `state`=~w">>,
            UpSQL = io_lib:format(SQL, [?DATA_STATE_USED, StrRoleInfo, StrAIds, ?DATA_STATE_UNUSE]),
            %% 实际上Len不会也不能太大，否则Len与mysql库返回的affect_rows数值可能不一致
            db:execute(UpSQL) =:= Len
    end;

%% 判断是否更新成功
set_come_back_data_used(AId, RoleInfo) ->
    SQL = <<"UPDATE come_back SET `state`=~w, now_role='~ts' WHERE `id`=~w AND `state`=~w">>,
    StrRoleInfo = util:term_to_string(RoleInfo),
    UpSQL = io_lib:format(SQL, [?DATA_STATE_USED, StrRoleInfo, AId, ?DATA_STATE_UNUSE]),
    db:execute(UpSQL) > 0.

%% 更新玩家的回归状态
update_come_back_state(RoleId, ComeBackState) ->
    SQL = <<"UPDATE player_login SET come_back_state=~w WHERE id=~w">>,
    UpSQL = io_lib:format(SQL, [ComeBackState, RoleId]),
    db:execute(UpSQL).

%% 判断是否更新成功
update_come_back_state(RoleId, NComeBackState, OComeBackState) ->
    SQL = <<"UPDATE player_login SET come_back_state=~w WHERE id=~w AND come_back_state=~w">>,
    UpSQL = io_lib:format(SQL, [NComeBackState, RoleId, OComeBackState]),
    db:execute(UpSQL) > 0.

%% 获取该帐号下的所有角色id的历史旧数据
get_history_data_by_list(DataList) ->
    F = fun([AId, _, _, BinData|_], {AIds, ComeBackR}) ->
                case get_come_back_history(BinData) of
                    #come_back_history{role_level = RoleLv,
                                       charge_gold = ChargeGold}->
                        #come_back_history{role_level = RoleLv1,
                                           charge_gold = ChargeGold1} = ComeBackR,
                        E = #come_back_history{
                               role_level = max(RoleLv, RoleLv1),
                               charge_gold = ChargeGold + ChargeGold1
                              },
                        {[AId|AIds], E};
                    _ ->
                        {AIds, ComeBackR}
                end
        end,
    lists:foldl(F, {[], #come_back_history{}}, DataList).

%% 记录生成
get_come_back_history(BinData) ->
    case util:bitstring_to_term(BinData) of
        Data when is_list(Data) ->
            setelement_list(#come_back_history{}, record_info(fields, come_back_history), Data);
        _Undefined ->
            false
    end.

%% 根据标签设置Record的相应字段值
setelement_list(Record, Fields, [{K, V}|T]) ->
    case util:index_of_record(K, Fields) of
        0 ->
            setelement_list(Record, Fields, T);
        Index ->
            NewTuple = erlang:setelement(Index + 1, Record, V),
            setelement_list(NewTuple, Fields, T)
    end;
setelement_list(Record, _Fields, []) ->
    Record.

%% --------------------------------
%% 从历史服导出数据，用于新服回归活动
%% --------------------------------
export_sql() ->
    %% 数据库进程
    MysqlPid = whereis(mysql_pools_sup),
    case is_pid(MysqlPid) andalso is_process_alive(MysqlPid) of
        true -> skip;
        _ ->
            ok = application:load(gsrv),
            [DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, _DBConns] = config:get_mysql(),
            db:start(DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, 10)
    end,
    {{Y, M, D}, _} = erlang:localtime(),
    ExportFile = iolist_to_binary(io_lib:format("../logs/come_back_~w~2..0w~2..0w.sql", [Y, M, D])),
    case file:open(ExportFile, [write, {encoding, utf8}]) of
        {ok, File} ->
            erlang:put(sql_file, File),
            try
                CreateTableSql = get_create_table_sql(),
                io:format(File, "~ts~n~ts~n", [CreateTableSql, "LOCK TABLES `come_back` WRITE;"]),
                %% accname为mxxxchat*，source为zxy的账号是聊天监控软件登录创建，直接过滤这种非玩家号
                SQL = <<"SELECT accname, source, id FROM player_login WHERE accname NOT LIKE 'mxxxchat%' ORDER BY accname,source">>,
                RoleList = db:get_all(SQL),
                %% 处理角色信息
                handle_role_list(RoleList, []),
                io:format(File, "~ts~n", ["UNLOCK TABLES;"]),
                ?INFO("succeed to export account charge info [file: ~ts]", [ExportFile])
            catch _ExType:_ExPattern ->
                    ?ERR("failed to get account list:~w", [{_ExType, _ExPattern, erlang:get_stacktrace()}])
            after
                file:close(File)
            end;
        {error, _Err} ->
            ?ERR("failed to open file:~w", [_Err])
    end.

%% 处理所有的账号数据:group by
%% 传入的参数中，已经保证了同一账号的角色放在相邻位置，这个方法依赖于这个关系，才能取得正确信息
handle_role_list([[_AccName, _Source, _RoleId] = H|RestList], []) ->
    handle_role_list(RestList, [H]);
%% 与当前处理列表中的角色数据属于同一个账号，并且同一个渠道包，加入列表中
handle_role_list([[AccName, Source, _RoleId]=H| RestList], [[AccName, Source, _]|_]=Roles) ->
    handle_role_list(RestList, [H|Roles]);
handle_role_list([[AccNameB, SourceB, _]=H|RestList], [[AccNameA, SourceA, _]|_]=Roles) ->
    %% 特殊情况，如果AccountB与AccountA只是大小写的差异（甚至两边有空格的差异:-(）应计为一个账号
    LAccNameB = strip(change_case(lower, AccNameB)),
    LAccNameA = strip(change_case(lower, AccNameA)),
    LSourceB  = strip(change_case(lower, SourceB)),
    LSourceA  = strip(change_case(lower, SourceA)),
    case LAccNameA =:= LAccNameB  andalso LSourceA =:= LSourceB of
        true  ->
            handle_role_list(RestList, [H|Roles]);
        false ->
            %% 不是同一个账号，需要开始处理这个人的数据
            LRoles = [[strip(change_case(lower, AccName)),
                       strip(change_case(lower,  Source)), RoleId] || [AccName, Source, RoleId] <- Roles],
            handle_accname_info(LRoles),
            handle_role_list(RestList, [H])
    end;
handle_role_list([], AccNameRoles) ->
    ?IF(AccNameRoles == [], skip, handle_accname_info(AccNameRoles)),
    ok.

%% 处理帐号信息
handle_accname_info([[AccName, Source, _]|_] = RoleList) ->
    %% 统计该帐号的充值元宝数
    SQL = <<"SELECT COALESCE(SUM(c.gold), 0) FROM charge c LEFT JOIN player_login p ON c.player_id=p.id WHERE p.accname = '~ts' AND p.source = '~ts' AND c.gold > 0">>,
    ChargeGold = db:get_one(io_lib:format(SQL, [AccName, Source])),
    if
        ChargeGold == 0 -> skip;
        true ->
            %% 获取玩家帐号下的角色信息
            {RoleInfos, MaxLv} = get_account_role_diff_infos(RoleList, [], 0),
            Data = [{role_level, MaxLv}, {charge_gold, ChargeGold}],
            StrRoleInfos = util:term_to_bitstring(RoleInfos),
            StrData = util:term_to_bitstring(Data),
            SQL1 = <<"INSERT INTO `come_back` (`accname`,`source`,`state`,`data`,`old_role`,`now_role`) VALUES ('~ts','~ts','~w','~ts','~ts','~ts');"/utf8>>,
            Args = [AccName, Source, 0, StrData, StrRoleInfos, "[]"],
            File = erlang:get(sql_file),
            io:format(File, "~ts~n", [io_lib:format(SQL1, Args)])
    end.

get_account_role_diff_infos([[AccName, _Source, RoleId]|T], RoleInfos, MaxLv) ->
    SQL = <<"SELECT pl.nickname,COALESCE(pl.lv, 0),COALESCE(SUM(c.gold), 0),v.vip_lv,v.vip_exp FROM player_low pl LEFT JOIN charge c ON pl.id=c.player_id LEFT JOIN vip_role_record v ON pl.id=v.role_id WHERE pl.id=~w">>,
    case db:get_row(io_lib:format(SQL, [RoleId])) of
        [Name, Lv, Charge, Vip, VipExp] ->
            NewRoleInfos = [{RoleId, Name, Lv, Charge, Vip, VipExp}|RoleInfos],
            NewMaxLv = max(Lv, MaxLv),
            get_account_role_diff_infos(T, NewRoleInfos, NewMaxLv);
        [] ->
            ?ERR("fetch role error : [account:~ts, ~w]", [AccName, RoleId]),
            throw(io_lib:format("fetch role error : [account:~ts, ~w]", [AccName, RoleId]))
    end;
get_account_role_diff_infos([], RoleInfos, MaxLv) ->
    {RoleInfos, MaxLv}.

get_create_table_sql() ->
    <<"CREATE TABLE IF NOT EXISTS `come_back` (
      `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
      `accname` varchar(64) NOT NULL COMMENT '账号',
      `source` varchar(50) NOT NULL DEFAULT '' COMMENT '渠道来源',
      `state` tinyint(3) NOT NULL COMMENT '状态0未返1已返',
      `data` text NOT NULL COMMENT '历史数据',
      `old_role` text COMMENT '旧号信息',
      `now_role` text COMMENT '新号信息',
      PRIMARY KEY (`id`),
      KEY `accname` (`accname`),
      KEY `state` (`state`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='封测玩家回归数据';"/utf8>>.

%% 大小写转换(多字节安全)，返回binary
change_case(CaseType, CharactersData) ->
    ChangeFun =
    case CaseType of
        lower -> fun string:to_lower/1;
        _Upper -> fun string:to_upper/1
    end,
    unicode:characters_to_binary(ChangeFun(unicode:characters_to_list(CharactersData))).

strip(CharactersData) ->
    unicode:characters_to_binary(string:strip(unicode:characters_to_list(CharactersData))).

%% 节日邮件礼包(玩家充值大于5000块发)
%% player_recharge
festival_gift_mail()->
    SQL = <<"SELECT DISTINCT(id) FROM player_recharge WHERE total >= 50000">>,
    case db:get_all(SQL) of 
        List when is_list(List) ->
            C = utext:get(1020003),
            T = utext:get(1020004),
            Gift = [{?TYPE_GOODS, 38060034, 1}, {?TYPE_BGOLD, ?GOODS_ID_GOLD, 288}],
            spawn(fun() ->
                          timer:sleep(urand:rand(500, 10000)),
                          send_festival_gift_mail(List, C, T, Gift, 1)
                  end),
            ok;
        _R ->
            ?ERR("festival_gift_mail_error:~p~n", [[_R]])
    end.

send_festival_gift_mail([], _C, _T, _Gift, Count) ->
    ?ERR("more than 5000 rmb pepole:~p~n", [Count-1]);
send_festival_gift_mail([[RoleId]|List], C, T, Gift, Count)->
    case Count div 20 of 
        0 -> timer:sleep(urand:rand(50, 300));
        _ -> skip
    end,
    lib_mail_api:send_sys_mail([RoleId], C, T, Gift),
    send_festival_gift_mail(List, C, T, Gift, Count+1).
