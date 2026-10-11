%%%--------------------------------------
%%% @Module  : lib_login
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.14
%%% @Description:注册登录
%%%--------------------------------------
-module(lib_login).
-export([
         handle_event/2,
         certain_role_first_state/2,
         get_role_list/2,
         get_roles_attr/2,               %% 得到帐号全部角色的属性
         create_role/9,
         delete_role/2,
         get_player_login_by_id/1,
         update_login_data/3,
         log_offline/3,
         log_all_online/2,
         judge_name_in_db/1,
         check_game_maintain/0,
         check_server_login_limit/0
        ]).
-include("sql_player.hrl").
-include("sql_goods.hrl").
-include("scene.hrl").
-include("def_goods.hrl").
-include("rec_dress_up.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("career.hrl").
-include("activitycalen.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("php.hrl").
-include("record.hrl").
-include("kv.hrl").

% 判断在改账号下是否首个角色
handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    #player_status{first_state = FirstState, id = RoleId, accname = AccName, accid = AccId} = PS,
    case FirstState of
        ?ACC_FIRST_ROLE_UNCERT ->
            PostData = [{accid, AccId}, {accname, AccName}, {role_id, RoleId}],
            PhpRequest = #php_request{role_id = RoleId, mfa = {?MODULE, certain_role_first_state, []}},
            ?MYLOG("lzh_acc", "certain_role_first_state PostData is ~p ~n", [PostData]),
            lib_php_api:request_register(get_first_user, PostData, PhpRequest);
        _ -> skip
    end,
    {ok, PS};
handle_event(PS, _CallBack) ->
    {ok, PS}.

certain_role_first_state(PS, IsFirst) when is_record(PS, player_status) ->
    FirstState = case IsFirst of true -> ?ACC_FIRST_ROLE_TRUE; _ -> ?ACC_FIRST_ROLE_FALSE end,
    db:execute(io_lib:format(<<"update player_login set first_state = ~p where id = ~p">>, [FirstState, PS#player_status.id])),
    lib_player_event:dispatch(PS#player_status{first_state = FirstState}, ?EVENT_ENSURE_ACC_FIRST);
certain_role_first_state(_PhpRequest, <<>>) -> ?INFO("certain_role_first_state JSON is <<>> ~n", []),skip;
certain_role_first_state(PhpRequest, JsonData) ->
    #php_request{role_id = RoleId} = PhpRequest,
    IsFirst = util:bitstring_to_term(JsonData),
    %?MYLOG("lzh_acc", "certain_role_first_state JSON is ~p ~n", [JsonData]),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, ?FUNCTION_NAME, [IsFirst]).


%% 取得指定帐号的角色列表
get_role_list(Accid, AccName) ->
    %% 得到帐号全部角色的属性
    RoleList = get_roles_attr(Accid, AccName),
    F = fun([Id, Status, NickName, Sex, Lv, Career, Realm, Turn, Picture, PictureVer]) ->
        LvModel = lib_goods_util:get_lv_model(Id, Career, Sex, Turn, Lv),
        FashionModel = lib_fashion:get_equip_fashion_list(Id, Career, Sex),
        LivenessModel = lib_dragon_ball_data:get_dragon_figure_id_db(Id),
        Turn = lib_reincarnation:get_turn_from_db(Id),
        MountFigureTmp = lib_mount:get_figure_list(Id, Career),
        RevelationFigure = lib_revelation_equip:get_figure(Id, Sex),
        BackDecoraFigure = lib_back_decoration:get_figure_list(Id),
        MountFigure = lib_temple_awaken:get_figure_list(Id, Career, MountFigureTmp ++ BackDecoraFigure),
        SuitCltFigure = lib_suit_collect:get_figure(Id),
        Figure = #figure{
            name=NickName, sex=Sex, lv=Lv, career=Career, realm=Realm,
            picture = Picture, picture_ver = PictureVer,
            lv_model = LvModel, fashion_model = FashionModel,
            liveness = LivenessModel, revelation_suit = RevelationFigure,
            turn = Turn, mount_figure = MountFigure, suit_clt_figure = SuitCltFigure},
        TodayLoginRewardId = lib_login_reward:get_today_login_reward_id(Id),
        [Id, Status, Figure, TodayLoginRewardId]
    end,
    %% 返回角色列表.
    case RoleList of
        List when is_list(List) ->
            [F(Elem)||Elem<-List];
        _ ->
            []
    end.

%% 根据帐号查找所有角色信息
get_roles_attr(Accid, AccName) ->
    db:get_all(io_lib:format(?sql_role_list, [Accid, AccName])).

%% 根据id查找账户名称
get_player_login_by_id(Id) ->
    db:get_row(io_lib:format(?sql_player_login_by_id, [Id])).

%% 更新登陆需要的记录
update_login_data(Id, Ip, Time) ->
    db:execute(io_lib:format(?sql_update_login_data, [Time, tool:ip2bin(Ip), Id])).

%% 创建角色
create_role(AccId, AccName, AccNameSdk, Name, _Realm, _Career, _Sex, IP, Source) ->
    %% 职业
    Career = lib_career:create_career(_Career),

    %% 性别
    Sex = case data_career:get(Career, _Sex) of
        #career{sex = Sex0} -> Sex0;
        _ ->
            case data_career:get_sex_list(Career) of
                [Sex0|_] -> Sex0;
                _ -> ?MALE
            end
    end,

    %% 阵营
    Realm = case _Realm of
        ?REALM_KUNLUN  -> ?REALM_KUNLUN;
        ?REALM_XUANDU  -> ?REALM_XUANDU;
        ?REALM_PENGLAI -> ?REALM_PENGLAI;
        _ -> 0
    end,

    %% 默认头像
    Picture = lib_career:get_picture(Career),

    %% 默认参数
    SceneId = ?BORN_SCENE,
    {X, Y} = ?BORN_SCENE_COORD,
    Lv = 1,
    Hp = 9000,
    Mp = 9000,
    CellNum = 0,
    StorageNum = 0,

    SourceLenValid = util:check_length(Source, 50),
    Source2 = case SourceLenValid of
        false -> "";
        true  -> Source
    end,

    Time = utime:unixtime(),
    SerId = config:get_server_id(),
    case catch mod_player_create:get_new_id() of
        Id when is_integer(Id) ->
            PlayerLoginSql  = io_lib:format(?sql_insert_player_login_one,
                [Id, AccId, AccName, AccNameSdk, Time, tool:ip2bin(IP), Source2, SerId]),
            PlayerHighSql   = io_lib:format(?sql_insert_player_high_one, [Id]),
            PlayerLowSql    = io_lib:format(?sql_insert_player_low_one, [Id, Name, Sex, Lv, Career, Realm, Picture]),
            PlayerStateSql  = io_lib:format(?sql_insert_player_state_one, [Id, SceneId, X, Y, Hp, Mp]),
            PlayerAttrSql   = io_lib:format(?sql_insert_player_attr_one, [Id, CellNum, StorageNum]),
            %% 玩家帐号共享信息
            PlayerSlAccSql  = io_lib:format(?sql_select_acc_share_data, [AccId, AccName]),
            PlayerInAccSql  = io_lib:format(?sql_insert_acc_share_data, [AccId, AccName]),
            PlayerRoleSql   = io_lib:format(?sql_role_count, [AccId, AccName]),
            F = fun() ->
                    db:execute(PlayerLoginSql),
                    db:execute(PlayerHighSql),
                    db:execute(PlayerLowSql),
                    db:execute(PlayerStateSql),
                    db:execute(PlayerAttrSql),
                    case db:get_all(PlayerSlAccSql) of
                        [] -> db:execute(PlayerInAccSql);
                        [[_Gold]|_] -> skip
                    end,
                    case db:get_row(PlayerRoleSql) of
                        [1] -> % 账号首次创角，更新游戏服注册账号数(仅更新ets表，不入库)
                            ServerRegPlayerNum = lib_server_kv:get_server_kv(?SKV_REG_PLAYER_NUM),
                            lib_server_kv:update_server_kv_to_ets(?SKV_REG_PLAYER_NUM, ServerRegPlayerNum+1, Time);
                        _ ->
                            skip
                    end,
                    true
            end,
            case db:transaction(F) of
                true  ->
                    case judge_name_in_db(Id) of
                        false -> ?INFO("role_name_can_not_save_in_db:~p~n",[Name]), skip;
                        _ -> skip
                    end,
                    Id; %% sql执行成功
                Error ->
                    ?ERR("~p ~p Error:~p~n", [?MODULE, ?LINE, Error]),
                    ?WEBERR("create role:accid:~w, accname:~s, err:~p~n", [AccId, AccName, Error], 0),
                    0
            end;
        Error ->
            ?ERR("~p ~p Error:~p~n", [?MODULE, ?LINE, Error]),
            ?WEBERR("create role:accid:~w, accname:~s, err:~p~n", [AccId, AccName, Error], 0),
            0
    end.

%% 删除角色 - 暂时无用
delete_role(Pid, Accname) ->
    Sql = lists:concat(["select id from player_login where id=",Pid ," and accname='",Accname,"'"]),
    case db:get_one(Sql) of
        null -> false;
        Id ->
            db:execute(lists:concat(["delete from `player_login` where id = ", Id])),
            db:execute(lists:concat(["delete from `player_high` where id = ", Id])),
            db:execute(lists:concat(["delete from `player_low` where id = ", Id])),
            true
    end.

%% 记录下线日志
log_offline(Ps, LogoutTime, LogNorlOrErr) ->
    #player_status{id = RoleId, scene = SceneId, x = X, y = Y, combat_power = Power} = Ps,
    lib_role_api:add_role_daily_online_time(Ps), % 因为TA系统的关系,不能把这一步放在log_all_online/2(要先于ta_logout/3)
    ta_logout(Ps, LogoutTime, LogNorlOrErr),
    ModulePowerL = lib_player:get_module_power(Ps, ?LOG_POWER_MODULES),
    lib_log_api:log_offline(RoleId, LogNorlOrErr, Power, util:term_to_bitstring(ModulePowerL), SceneId, X, Y, LogoutTime).

%% TA系统登出处理
ta_logout(Ps, _LogoutTime, _LogNorlOrErr) ->
    ta_agent_fire:role_daily_attr(Ps),
    ta_agent_fire:role_daily_active(Ps).

%% 记录在线时长，大于1分钟的写入数据库中
%% 1)调用位置：登出时调用、延迟登出时调用
%% 2)不是在线状态不记录
log_all_online(Ps, LogoutTime) ->
    %% 下线时间减去上一次登录时间
    #player_status{id = RoleId, last_login_time = LastLoginTime, online = Online} = Ps,
    OnlineTime = LogoutTime - LastLoginTime,
    if
        Online =/= ?ONLINE_ON -> skip;
        OnlineTime < 60 -> skip;
        true ->
            SQL = <<"insert into `log_all_online`(player_id, online_time, logout_time, last_login_time) values (~p, ~p, ~p, ~p)">>,
            db:execute(io_lib:format(SQL, [RoleId, OnlineTime, LogoutTime, LastLoginTime]))
    end.

judge_name_in_db(Id) ->
    Sql = io_lib:format(<<"select `nickname` from `player_low` where id=~w  limit 1">>, [Id]),
    [Name] = db:get_row(Sql),
    if
        Name == <<>> ->
            false;
        true ->
            true
    end.

%% 检查服务器是否维护中
check_game_maintain() ->
    case lib_vsn:is_check_game_maintain() of
        true ->
            case db:get_one(<<"select `cf_value` from `base_game` where `cf_name` = 'game_maintain'">>) of
                null -> false;
                BitGameMaintain ->
                    case catch util:bitstring_to_term(BitGameMaintain) of
                        % 1 维护中
                        [1, UpTime] ->
                            NowTime = utime:unixtime(),
                            if
                                NowTime - UpTime > 3600 * 2 -> false;
                                true -> true
                            end;
                        _ -> false
                    end
            end;
        false -> false
    end.

%% 检测服务器是否限制登录中
%% @return boolean()
check_server_login_limit() ->
    NowTime = utime:unixtime(),
    case {lib_vsn:is_sy_internal_devp(), data_key_value:get(?KEY_SERVER_LOGIN_LIMIT_TIME)} of
        {false, {StartTime, EndTime}} ->
            StartTime =< NowTime andalso NowTime =< EndTime;
        _ ->
            false
    end.