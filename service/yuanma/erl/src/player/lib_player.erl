%% ---------------------------------------------------------------------------
%% @doc lib_player
%% @author ming_up@foxmail.com
%% @since  2016-08-03
%% @deprecated  角色库函数
%% ---------------------------------------------------------------------------
-module(lib_player).

-include("common.hrl").
-include("sql_player.hrl").
-include("server.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("title.hrl").
-include("designation.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("battle.hrl").
-include("career.hrl").
-include("skill.hrl").
-include("goods.hrl").
-include("relationship.hrl").
-include("mount.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("partner.hrl").
-include("flower.hrl").
-include("artifact.hrl").
-include("chat.hrl").
-include("dungeon.hrl").
-include("rec_dress_up.hrl").
-include("medal.hrl").
-include("wing.hrl").
-include("talisman.hrl").
-include("godweapon.hrl").
-include("activitycalen.hrl").
-include("awakening.hrl").
-include("guild.hrl").
-include("pet.hrl").
-include("team.hrl").
-include("juewei.hrl").
-include("reincarnation.hrl").
-include("def_module.hrl").
-include("vip.hrl").
-include("eudemons.hrl").
-include("marriage.hrl").
-include("star_map.hrl").
-include("husong.hrl").
-include("house.hrl").
-include("holy_ghost.hrl").
-include("mon_pic.hrl").
-include("anima_equip.hrl").
-include("decoration.hrl").
-include("fairy.hrl").
-include("arbitrament.hrl").
-include("rec_onhook.hrl").
-include("dragon.hrl").
-include("demons.hrl").
-include("supreme_vip.hrl").
-include ("back_decoration.hrl").
-include("arcana.hrl").
-include("god_court.hrl").
-include("seacraft.hrl").
-include("seacraft_daily.hrl").
-include("enchantment_guard.hrl").
-include("companion.hrl").
-include("equip_suit.hrl").
-include("game.hrl").
-include("role.hrl").
-include("def_goods.hrl").
-include("cluster_sanctuary.hrl").

-compile(export_all).

%% ----------------------------------------------------------------
%% 后台接口
%% ----------------------------------------------------------------

%% 封号
limit_login(Ids) when is_list(Ids) ->
    case util:string_to_term(Ids) of
        undefined -> skip;
        L ->
            [limit_login(Id, false) || Id <- L]
            %% 封号不用删除玩家聊天缓存
            %% lib_chat:del_all_msg(L)
    end,
    ok;
limit_login(Id) ->
    limit_login(Id, true),
    ok.

limit_login(Id, NeedDelCache) ->
    RolePid = misc:get_player_process(Id),
    case is_pid(RolePid) andalso misc:is_process_alive(RolePid) of
        true ->
            %% 在玩家进程设置封号标识
            RolePid ! {'limit_login', Id, ?LOGOUT_LOG_FORBIDDEN};
        false ->
            lib_server_send:send_to_uid(Id, close)
    end,
    case NeedDelCache of
        true  -> lib_chat:del_all_msg([Id]);
        false -> ignore
    end,
    ok.

%% 更新玩家是否能上传头像
%% @param IdList [Id, Id|...] 玩家列表
%% @param PictureLim 0:允许上传头像,1:禁止上传头像
update_player_picture_lim(IdList, PictureLim) ->
    F = fun(RoleId)->
                %% 检查目标玩家是否在线
                lib_player:update_player_info(RoleId, [{picture_lim, PictureLim}]),
                timer:sleep(100), % 防止过多插入导致其他功能连接不了数据库
                db_update_player_picture_lim(RoleId, PictureLim)
        end,
    lists:foreach(F, IdList),
    1.

%% 更新玩家是否能上传头像
db_update_player_picture_lim(RoleId, PictureLim) ->
    SQL = io_lib:format(?sql_update_picture_lim, [PictureLim, RoleId]),
    db:execute(SQL).

%% 删除玩家上传的头像
delete_player_picture(IdList) ->
    F = fun(RoleId) ->
        case db_get_player_picture_by_role_id(RoleId) of
            [] -> 0;
            [_OldPicture, OldPictureVer] ->
                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, delete_player_picture_help, [OldPictureVer])
        end
    end,
    lists:foreach(F, IdList),
    1.

delete_player_picture_help(Ps, OldPictureVer) ->
    #player_status{id = RoleId, figure = #figure{career = Career}} = Ps,
    Picture = lib_career:get_picture(Career),
    PictureVer = OldPictureVer+1,
    %% 检查目标玩家是否在线
    case mod_chat_agent:lookup(RoleId) of
        [] ->
            db_update_player_picture(RoleId, Picture, PictureVer),
            lib_log_api:log_picture(RoleId, Picture, PictureVer),
            NewPlayer = Ps;
        [_Player] ->
            {ok, NewPlayer} = update_player_picture_online(Ps, Picture, PictureVer)
    end,
    notify_picture_change(RoleId, Picture, PictureVer),
    {ok, BinData} = pt_130:write(13085, [RoleId, Picture, PictureVer]),
    lib_server_send:send_to_all(BinData),
    {ok, NewPlayer}.

%% 根据PictureId更新头像信息
db_update_player_picture(RoleId, Picture, PictureVer) ->
    SQL = io_lib:format(?sql_update_picture_info, [Picture, PictureVer, RoleId]),
    db:execute(SQL).

%% 根据PictureId查找玩家id
db_get_player_picture_by_role_id(RoleId) ->
    SQL = io_lib:format(?sql_player_picture_by_role_id, [RoleId]),
    db:get_row(SQL).

%% 激活头像
active_player_picture(Player) ->
    #player_status{figure = #figure{turn = Turn}} = Player,
    TurnPictureList = data_dress_up:get_value(?TURN_PICTURE_KEY_1),
    NewPlayer =
        case lists:keyfind(Turn, 1, TurnPictureList) of
            {Turn, TurnPictureId} ->
                case pp_dress_up:handle(11201, Player, [?DRESS_UP_PICTURE, TurnPictureId]) of
                    {ok, NPs} -> NPs;
                    _ ->
                        Player
                end;
             _ ->  Player
        end,
    NewPlayer.

%% 注意:在线不在线都需要处理头像的话,通过 notify_picture_change/3 函数处理
%% 更新玩家身上picture
update_player_picture_online(Player, Picture, PictureVer) ->
    #player_status{id = RoleId, sid = Sid, figure = Figure} = Player,
    NewFigure = Figure#figure{picture = Picture, picture_ver = PictureVer},
    NewPlayer = Player#player_status{figure = NewFigure},
    db_update_player_picture(RoleId, Picture, PictureVer),
    lib_log_api:log_picture(RoleId, Picture, PictureVer),
    EventData = #callback_picture{role_id = RoleId, picture = Picture, picture_ver = PictureVer},
    {ok, NewPlayer2} = lib_player_event:dispatch(NewPlayer, ?EVENT_PICTURE_CHANGE, EventData),
    {ok, BinData} = pt_130:write(13083, [?SUCCESS, PictureVer, Picture]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer2}.

%% 触发头像更改(在线不在线都需要处理)
notify_picture_change(RoleId, Picture, PictureVer) ->
    EventData = #callback_picture{role_id = RoleId, picture = Picture, picture_ver = PictureVer},
    lib_event:dispatch(?EVENT_PICTURE_CHANGE, EventData),
    mod_guild:update_guild_member_attr(RoleId, [{picture, Picture}, {picture_ver, PictureVer}]),
    % lib_relationship:update_rela_role_info(RoleId, [{picture, Picture}, {picture_ver, PictureVer}]),
    ok.

%% ----------------------------------------------------------------
%% player处理
%% ----------------------------------------------------------------

%% 根据账户名称查找最近创建的角色Id
get_role_last_id(AccId, AccName) ->
    db:get_all(io_lib:format(?SQL_ROLE_LAST_ID, [AccId, AccName])).

%% 获取player_login登陆所需数据
get_player_login_data(Id) ->
    db:get_row(io_lib:format(?sql_player_login_data, [Id])).

%% 获取player_high登陆所需数据
get_player_high_data(Id) ->
    db:get_row(io_lib:format(?sql_player_high_data, [Id])).

%% 获取player_low登陆所需数据
get_player_low_data(Id) ->
    db:get_row(io_lib:format(?sql_player_low_data, [Id])).

%% 获取player_state登陆所需数据
get_player_state_data(Id) ->
    db:get_row(io_lib:format(?sql_player_state_data, [Id])).

%% 获取player_attr登陆所需数据
get_player_attr_data(Id) ->
    db:get_row(io_lib:format(?sql_player_attr_data, [Id])).

%% 根据玩家名字获得对应玩家id
get_role_id_by_name(Name) ->
    db:get_one(io_lib:format(?sql_role_id_by_name, [Name])).

%% 获取玩家货币
get_player_money_data(Id) ->
    db:get_row(io_lib:format(?sql_player_money_data, [Id])).

%% 根据玩家名字获得对应玩家id
get_role_name_by_id(Id) ->
    db:get_one(io_lib:format(?sql_role_name_by_id, [Id])).

%% ---------------------------------------------------------------------------
%% @doc 回写货币数据
-spec update_player_money(OldPlayer, NewPlayer) -> ok when
      OldPlayer   :: #player_status{},    %% 货币变化前的角色数据
      NewPlayer   :: #player_status{}.    %% 货币变化后的角色数据
%% ---------------------------------------------------------------------------
update_player_money(OldPlayer, NewPlayer) ->
    #player_status{gold = Gold, bgold = BGold, coin = Coin, gcoin = GCoin ,id = PlayerId} = OldPlayer,
    #player_status{gold = NewGold, bgold = NewBGold, coin = NewCoin, gcoin = NewGCoin} = NewPlayer,
    %% 1> 更新元宝,绑定元宝和铜钱
    case {NewGold, NewBGold, NewCoin, NewGCoin} of
        {Gold, BGold, Coin, GCoin} -> ok; %% 元宝,绑定元宝和铜钱没有变化，不用更新
        _ -> update_player_money(PlayerId, NewGold, NewBGold, NewCoin, NewGCoin)
    end,
    ok.

%% 更新玩家货币
update_player_money(PlayerId, NewGold, NewBGold, NewCoin, NewGCoin) ->
    Args2 = [NewGold, NewBGold, NewCoin, NewGCoin, PlayerId],
    Sql = io_lib:format(?sql_update_player_money, Args2),
    db:execute(Sql).

%% 保存state数据
update_player_state(Status) ->
    #player_status{id=Id, scene=Scene, x=X, y=Y, battle_attr=BA, quickbar=Quickbar,
                   combat_power=CombatPower, last_be_kill=LastBeKill, last_task_id=LastTaskId} = Status,
    #battle_attr{hp=Hp, pk=Pk} = BA,
    StrQuickbar = util:term_to_string(Quickbar),
    StrLastBeKill = ?IF(Hp > 0, util:term_to_string([]), util:term_to_string(LastBeKill)),
    #pk{pk_value = PkValue, pk_status = PkStatus, pk_change_time = PkChangeTime, pk_value_change_time = PkValueChangeTime} = Pk,
    db:execute(io_lib:format(?sql_update_player_state, [Scene, X, Y, Hp, StrQuickbar, PkValue, PkStatus,
                                                        PkChangeTime, PkValueChangeTime, CombatPower, StrLastBeKill, LastTaskId, Id])).

%%回写经验值
update_player_exp(Status) ->
    db:execute(io_lib:format(?sql_update_player_exp, [Status#player_status.exp, Status#player_status.id])).

%% 回写login表数据
update_player_login_offline(Status, Now) ->
    db:execute(io_lib:format(?sql_update_login_offline, [Now, Status#player_status.id])).

db_update_player_coin(Status) ->
    db:execute(io_lib:format(?sql_update_coin_offline, [Status#player_status.coin, Status#player_status.id])).

%% 回写历史最高战力
update_hightest_combat_power(Status, CombatPower) ->
    db:execute(io_lib:format(?sql_update_hightest_combat_power, [CombatPower, Status#player_status.id])).

update_player_state_combat(Status, CombatPower) ->
    db:execute(io_lib:format(<<"update player_state set last_combat_power = ~p where id = ~p">>, [CombatPower, Status#player_status.id])).

%% 将在线状态变成离线挂机状态,记录离线挂机时间点
update_online_flag_to_onhook(RoleId, NowTime) ->
    Fun = fun() ->
        db:execute(io_lib:format(?sql_update_line_flag, [?ONLINE_OFF_ONHOOK, RoleId])),
        db:execute(io_lib:format(?SQL_ROLE_ONHOOK_UPDATE_START_TIME, [NowTime, RoleId])),
        ok
    end,
    db:transaction(Fun).

%% 更新在线标识
update_online_flag(RoleId, Flag) ->
    db:execute(io_lib:format(?sql_update_line_flag, [Flag, RoleId])).

%% 更新用户信息_分类(不分线) #player_status
%% @param Id 玩家ID
%% @param AttrKeyValueList 属性列表 [{Key,Value},{Key,Value},...] Key为原子类型，Value为所需参数数据
update_player_info(Id, AttrKeyValueList) when is_list(AttrKeyValueList) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) -> gen_server:cast(Pid, {'set_data', AttrKeyValueList});
        _ ->
            update_player_info_help(AttrKeyValueList, Id),
            false
    end.

%% 不在线也要更新处理
update_player_info_help([], _Id) -> skip;
update_player_info_help([H|T], Id) ->
    case H of
        {team_flag, Value} -> lib_role:update_role_show(Id, [{team_flag, Value}]);
        _ -> skip
    end,
    update_player_info_help(T, Id).

%% 更新玩家场景里面的信息
%% @param Id 玩家ID
%% @param AttrKeyValueList 属性列表 [{Key,Value},{Key,Value},...] Key为原子类型，Value为所需参数数据
update_player_scene_info(Id, AttrKeyValueList) when is_list(AttrKeyValueList) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) -> gen_server:cast(Pid, {'update_player_scene_info', AttrKeyValueList});
        _ -> false
    end.

%% 更新玩家战舰属性(跨服公会战)
update_player_ship_info(Id, ShipId) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) -> gen_server:cast(Pid, {'update_player_ship_info', ShipId});
        _ -> false
    end.

%% %% 获取玩家职业(通过数据库读取)
%% get_role_career(RoleId) ->
%%     case get_player_low_data(RoleId) of
%%         [_, _, _, Career|_] ->
%%             Career;
%%         _ ->
%%             0
%%     end.

%% -----------------------------------------------------------
%% @doc 按格式(ResultForm)返回#player_status{}中的字段值集合
-spec get_player_info(Id, ResultForm) -> Result when
      Id          :: integer(),                %% 玩家id
      ResultForm  :: integer() | list() | all, %% #player_status.xx | [#player_status.xx, ...] | all
      Result      :: term().                   %% 对应上面的参数的返回值：记录中某个字段的值|记录中某些字段组成的列表|全记录
%% @end
%% -----------------------------------------------------------
get_player_info(Id, ResultForm) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            case catch gen_server:call(Pid, {'get_form_data', ResultForm}) of
                {'EXIT', _} -> false;
                Res -> Res
            end;
        _ -> false
    end.

%% 取得在线角色的角色状态(只能用在本节点)
get_online_info(Id) ->
    case ets:lookup(?ETS_ONLINE, Id) of
        []  -> [];
        [R] ->
            case erlang:is_process_alive(R#ets_online.pid) of
                true  -> R;
                false -> []
            end
    end.

is_exists(Name) ->
    case db:get_one(io_lib:format(?sql_role_id_by_name, [Name])) of
        null   -> false;
        _Other -> true
    end.

%% 检查角色ID是否存在
is_id_exists(RoleId) ->
    case db:get_one(io_lib:format(?sql_role_id_exist, [RoleId])) of
        null -> false;
        _Other -> true
    end.

is_online_global(Id) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) -> misc:is_process_alive(Pid);
        _ -> false
    end.

get_alive_pid(Id) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true -> Pid;
                false -> false
            end;
        _ -> false
    end.

%% 玩家添加经验
add_mon_dynamic_exp(Status, Mid, Exp) ->
    #player_status{scene = _SceneId, figure = #figure{lv = Lv}} = Status,
    % case data_scene:get(SceneId) of
    %     #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN -> ExpType = ?ADD_EXP_DUN;
    %     _ -> ExpType = ?ADD_EXP_MON
    % end,
    case data_mon_dynamic:get(Mid, Lv) of
        #mon_dynamic{exp = DExp} when DExp > 0 -> add_exp(Status, DExp, ?ADD_EXP_MON, []);
        _ -> add_exp(Status, Exp, ?ADD_EXP_MON, [])
    end.

%% 玩家添加经验
share_mon_dynamic_exp(#player_status{scene = SceneId} = Status, Mid, Exp, SceneId) ->
    add_mon_dynamic_exp(Status, Mid, Exp);
share_mon_dynamic_exp(Status, _Mid, _Exp, _SceneId) ->
    Status.

%% 增加人物经验
share_mon_exp(#player_status{scene = SceneId} = Status, Exp, ExpType, KeyValueList, SceneId) ->
    add_exp(Status, Exp, ExpType, KeyValueList);
share_mon_exp(Status, _, _, _, _) ->
    Status.

%% 增加人物经验
add_exp(Status, Exp) ->
    add_exp(Status, Exp, 0, ?ADD_EXP_NO, []).

add_exp(Status, Exp, ExpType, KeyValueList) ->
    add_exp(Status, Exp, 0, ExpType, KeyValueList).

%% 增加人物经验
%% @param  OldStatus    增加经验前的#player_status{}
%% @param  AddExp       增加的经验
%% @param  State        0的时候收益正常,1为受防沉迷收益
%% @param  ExpType      0无类型 1gm类型 2任务 3杀怪 4副本 5队伍杀怪 6使用经验丹 7离线经验找回
%% @param  KeyValueList 经验KeyValue参数列表 [{Key, Value}|...]
%%         Key :: 亲密度intimacy | 副本id:dun_id
%% @return #player_status{}
add_exp(OldStatus, AddExp, _State, ExpType, KeyValueList) ->
    #player_status{id = RoleId, pid = RolePid, figure = Figure} = OldStatus,
    #figure{lv = OldLv} = Figure,
    %% 计算经验加成 和 经验加成比例
    {ExpAdd, ExpAddRatio} = calc_exp_add_and_ratio(OldStatus, ExpType, AddExp),
    %%cast 回去公会晚宴进程， 统计累积经验
    case ExpType of
        ?ADD_EXP_GUILD_FEAST ->
            mod_guild_feast_mgr:send_exp_by_cast(RoleId, ExpAdd);
        ?ADD_EXP_HOLY_SPIRIT_BATTLEFIELD ->
            lib_holy_spirit_battlefield:send_exp_by_cast(RoleId, ExpAdd);
        ?ADD_EXP_MIDDAY_PARTY ->
            mod_midday_party:count_exp(RoleId, ExpAdd);
        _ ->
            skip
    end,
    %% 副本处理经验
    DunStatus = lib_dungeon:add_exp(OldStatus, ExpType, ExpAdd, AddExp),
    StatusAfOnhook = lib_onhook:add_exp(DunStatus, AddExp),
    %% 托管期间不增加经验，保留起来统一邮件发送
    case lib_fake_client:in_fake_client(StatusAfOnhook) of
        true ->
            NewStatus = lib_fake_client_goods:record_exp_when_onhook(StatusAfOnhook, ExpAdd);
        _ ->
            %% 飘字增加经验
            lib_server_send:send_to_uid(RoleId, pt_130, 13036, [ExpType, ExpAdd, ExpAddRatio]),
            %% 添加经验
            NewStatus = add_exp_helper(StatusAfOnhook, ExpAdd, ExpType, KeyValueList)
    end,
    %% 判断是不是离线挂机期间
    if
        NewStatus#player_status.online =/= ?ONLINE_OFF_ONHOOK ->
            NewStatus;
        true ->
            #player_status{onhook = Onhook, figure = #figure{lv = NewLv}} = NewStatus,
            ?IF(NewLv =< OldLv, skip, RolePid ! {'find_new_onhook_place'}), %% 升级重新寻找挂机点
            #status_onhook{exp = OnhookExp} = Onhook,
            NewStatus#player_status{onhook = Onhook#status_onhook{exp = OnhookExp+ExpAdd}}
    end.

add_exp_helper(Status, Exp, ExpType, Args) ->
    #player_status{id = Id, figure = Figure, exp = OldExp, skill = Skill, scene = SceneId} = Status,
    #figure{lv = OldLv, turn = Turn, career = Career, sex = Sex} = Figure,
    LvMaxExp = data_exp:get(OldLv),
    case data_exp:get_all_lv() of
        [MaxLv|_] -> skip;
        _ -> MaxLv = 0
    end,
    ExpSum = Exp + OldExp,
    CanLv = lib_reincarnation:is_can_lv(Career, Sex, Turn, OldLv),
    % ?PRINT("Career:~p Sex:~p Turn:~p OldLv:~p CanLv:~p ~n", [Career, Sex, Turn, OldLv, CanLv]),
    if
        %% ---------- 未升级 ----------
        %% ---------- (1)未达升级经验值
        (OldLv >= MaxLv orelse ExpSum < LvMaxExp) orelse
                %% ---------- (2)转生判断不能升级
                CanLv == false ->
            {ok, BinData} = pt_130:write(13002, [ExpSum]),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData),
            %% 缓存经验累加次数
            case get("lib_player_add_exp") of
                undefined ->
                    LimitTimes = urand:rand(100, 150),
                    put("lib_player_add_exp", {1, LimitTimes});
                {Times, LimitTimes} when Times < LimitTimes -> put("lib_player_add_exp", {Times+1, LimitTimes});
                _ ->
                    db:execute(io_lib:format(<<"update `player_high` set `exp`=~w where `id`=~w ">>, [ExpSum, Id])),
                    erase("lib_player_add_exp")
            end,
            Status#player_status{exp = ExpSum};

        %% ---------- 已升级 ----------
        true ->
            LeftExp = ExpSum - LvMaxExp,
            Lv = OldLv + 1,
            %% 技能点
            SkillPoint = ?IF(Turn < ?DEF_TURN_4, Skill#status_skill.point, Skill#status_skill.point+1),
            %% 等级升级处理
            ExpLimit = data_exp:get(Lv),
            Status1 = Status#player_status{exp = LeftExp, exp_lim = ExpLimit, figure = Figure#figure{lv=Lv}},
            {ok, BinData} = pt_130:write(13003, [Lv, LeftExp, ExpLimit]),
            lib_server_send:send_to_sid(Status1#player_status.sid, BinData),

            %% 技能点处理
            Fun = fun() ->
                          ?IF(Turn < ?DEF_TURN_4, skip,
                          db:execute(io_lib:format(<<"update `player_state` set skill_extra_point = ~w where id=~w ">>, [SkillPoint, Id]))),
                          db:execute(io_lib:format(<<"update `player_high` set exp=~w where id=~w ">>, [LeftExp, Id])),
                          db:execute(io_lib:format(<<"update `player_low` set lv = ~w where id=~w ">>, [Lv, Id]))
                  end,
            db:transaction(Fun),

            %% 人物属性计算
            NewStatus = count_player_attribute(Status1),
            NewStatus1 = NewStatus#player_status{skill = Skill#status_skill{point = SkillPoint}},
            send_attribute_change_notify(NewStatus1, ?NOTIFY_ATTR),
            %% 派发升级事件
            {ok, NewStatus2} = lib_player_event:dispatch(NewStatus1, ?EVENT_LV_UP),
            {ok, NewStatus3} = lib_achievement_api:lv_up_event(NewStatus2, []),
            %% 等级礼包判断
            NewStatus4 = lib_rush_giftbag:rush_giftbag_lv_up(NewStatus3),
            send_world_exp_add_to_client(NewStatus4),
            %% 写入日志
            lib_log_api:log_uplv(Id, Lv, ExpType, ExpSum, NewStatus4#player_status.combat_power, SceneId),
            % TA上报
            ta_agent_fire:log_uplv(NewStatus4, Lv, ExpType, Exp, SceneId),
            %% 连升多级
            NextLvMaxExp = data_exp:get(Lv),
            case NextLvMaxExp > LeftExp of
                true  -> NewStatus4;
                false -> add_exp_helper(NewStatus4#player_status{exp=0}, LeftExp, ExpType, Args)
            end
            %% 请不要在后面加代码，这里是尾递归
    end.

%% 扣除玩家经验
deduct_exp(Status, Exp) ->
    NewExp = max(0, Status#player_status.exp - Exp),
    {ok, BinData} = pt_130:write(13002, [NewExp]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    Status1 = Status#player_status{exp = NewExp},
    update_player_exp(Status1),
    Status1.

%% 发送世界等级经验加成给客户端
send_world_exp_add_to_client(PS) ->
    #player_status{sid = Sid} = PS,
    WorldLv = util:get_world_lv(),
    ServerLvExpAdd = calc_satisfy_world_exp_add(PS, WorldLv),
    {ok, BinData} = pt_130:write(13011, [ServerLvExpAdd, WorldLv]),
    lib_server_send:send_to_sid(Sid, BinData).

%% 弯沉大哥主线任务ID 大于等于 101160 才享有世界等级经验加成
calc_satisfy_world_exp_add(PS, WorldLv) ->
    #player_status{last_task_id = LastTaskId, figure = #figure{lv = Lv}} = PS,
    case LastTaskId >= 101160 of
        true ->
            data_exp_add:get_add(WorldLv, Lv);
        _ -> 0
    end.


%% 计算属性百分比
calc_attr_ratio(Attr) ->
    #attr{att = Att, hp = Hp, wreck = Wreck, def = Def, hit = Hit, dodge = Dodge,
          crit = Crit, ten = Ten, elem_att = ElemAtt, elem_def = ElemDef,
          %% 基础属性增加系数千分比(即:放大了10000倍,计算的时候要除以10000)
          att_add_ratio = AttAddR, hp_add_ratio = HpAddR, wreck_add_ratio  = WreckAddR,
          def_add_ratio = DefAddR, hit_add_ratio = HitAddR, dodge_add_ratio = DodgeAddR,
          crit_add_ratio = CritAddR, ten_add_ratio = TenAddR, elem_att_add_ratio = ElemAttAddR,
          elem_def_add_ratio = ElemDefAddR
    } = Attr,
    NewAtt   = round(Att   * (1+AttAddR/?RATIO_COEFFICIENT)),
    NewHp    = round(Hp    * (1+HpAddR/?RATIO_COEFFICIENT)),
    NewWreck = round(Wreck * (1+WreckAddR/?RATIO_COEFFICIENT)),
    NewDef   = round(Def   * (1+DefAddR/?RATIO_COEFFICIENT)),
    NewHit   = round(Hit   * (1+HitAddR/?RATIO_COEFFICIENT)),
    NewDodge = round(Dodge * (1+DodgeAddR/?RATIO_COEFFICIENT)),
    NewCrit  = round(Crit  * (1+CritAddR/?RATIO_COEFFICIENT)),
    NewTen   = round(Ten   * (1+TenAddR/?RATIO_COEFFICIENT)),
    NewElemAtt = round(ElemAtt * (1+ElemAttAddR/?RATIO_COEFFICIENT)),
    NewElemDef = round(ElemDef * (1+ElemDefAddR/?RATIO_COEFFICIENT)),

    Attr#attr{att = NewAtt, hp = NewHp, wreck = NewWreck, def = NewDef, hit = NewHit, dodge = NewDodge,
        crit = NewCrit, ten = NewTen, elem_att = NewElemAtt, elem_def = NewElemDef}.

%% 人物属性计算(此函数为高频调用函数。各部分属性保存时，应当使用列表[{K,V}]存储在ps中，匹配出属性后根据公式汇总)
%% 各个功能属性不缺定,都用AttrList保存,将所有的列表属性相加,在转成attr记
count_player_attribute(PS) ->
    #player_status{scene = SceneId, dungeon = StatusDungeon, battle_attr = #battle_attr{group = Group}, sea_craft_daily = SeaCraftDaily} = PS,
    case StatusDungeon of
        #status_dungeon{dun_type = DunType} ->
            IsOnDungeon = lib_scene:is_dungeon_scene(SceneId) andalso lib_dungeon:is_on_dungeon(PS);
        _ -> DunType = 0, IsOnDungeon = false
    end,
    case SeaCraftDaily of
        #role_sea_craft_daily{status = CarryStatus} ->
            ok;
        _ ->
            CarryStatus = ?common
    end,
    IsInSeaCraftScene = lib_seacraft_daily:is_scene(SceneId),
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} -> ok;
        _ -> SceneType = 0
    end,
    if
        SceneType == ?SCENE_TYPE_SEACRAFT andalso Group == ?SHIP_TYPE_CONSTRUCTION ->
            PS;
        DunType == ?DUNGEON_TYPE_WEEK_DUNGEON andalso IsOnDungeon ->
            lib_week_dungeon:count_attr_in_week_dungeon(PS);
        CarryStatus == ?carrying  andalso IsInSeaCraftScene == true ->
            lib_seacraft_daily:count_attr(PS);
        true ->
            count_player_attribute(PS, normal)
    end.
count_player_attribute(PlayerStatus, Type) ->
    #player_status{figure = Figure, battle_attr = BA, combat_power = OldCombatPower,
        buff_attr = GoodsBuffAttrs, hightest_combat_power = HightCombatPower, status_mount = StatusMount} = PlayerStatus,
    #figure{lv = RoleLv} = Figure,
    #battle_attr{hp = OldHp, hp_lim = OldHpLim} = BA,

    %% 其他功能应该保存map以节省内存
    %% example: #{?ATT:=AttX, ?HP:=HpX} = PS#player_status.pet_attr,
    %% ================================= 汇总 =================================
    %% 称号属性
    #dsgt_status{attr = DsgtAttr, skill_power = DsgtSkPower} = PlayerStatus#player_status.dsgt_status,
    %% 培养/装备属性
    #status_goods{equip_attribute = EquipAttr, equip_skill_power = EquipSkillPower, fashion_attr = FashionAttr,
                  rune_attr = RuneAttr, soul_attr = SoulAttr, ring_attr = RingAttr, equip_suit_attr = EquipSuitAttr,
                  bag_fusion_attr = BagFusionAttr, equip_refinement_attr = EquipRefinementAttr} = PlayerStatus#player_status.goods,
    %% 帮派技能属性
    #status_guild_skill{attr = GuildSkillAttr} = PlayerStatus#player_status.guild_skill,
    %% 速度属性
    SpeedAttr = [{?SPEED, ?SPEED_VALUE}],
    %% 主线副本增加属性
    MainDungeonAddAttr = lib_enchantment_guard:get_attr(PlayerStatus),
    %% 等级基础属性
    LvAttr = base_lv_attr(RoleLv),
    %% 任务被动技能和天赋被动技能属性
    #status_skill{skill_attr = SkillAttr, skill_power = SkillPower, skill_talent_attr = SkillTalentAttr, skill_talent_sec_attr = SkillTalentSecAttrMap, stren_power = StrenPower} = PlayerStatus#player_status.skill,
    %% 等级基础属性
    LvAddAttr = lib_player_attr:count_lv_attr(LvAttr, [RuneAttr, SoulAttr, GuildSkillAttr, SkillAttr]),
    %% 转生属性
    ReincarnationAttr = lib_reincarnation:get_reincarnation_attr(PlayerStatus#player_status.reincarnation),
    %% 天命觉醒属性
    #awakening{attr = AwakeningAttr} = PlayerStatus#player_status.awakening,
    %% 坐骑属性
    {MountAttr, MountPower} = lib_mount:get_mount_all_attr(PlayerStatus),
    %% 宠物属性
%%    #status_pet{attr = PetAttr, figure_attr = PetFigureAttr, special_attr = _PetSpecialAttrMap, pet_aircraft = #pet_aircraft{aircraft_attr = AircraftAttr},
%%        pet_wing = #pet_wing{wing_attr = PetWingAttr}, pet_equip = #pet_equip{pet_equip_attr = PetEquipAttr}} = PlayerStatus#player_status.status_pet,
    %% 翅膀属性
    #status_wing{attr = WingAttr, figure_attr = WingFigureAttr, special_attr = _WingSpecAttrMap} = PlayerStatus#player_status.status_wing,
    %% 法宝属性
    #status_talisman{attr = TalismanAttr, figure_attr = TalismanFigureAttr, special_attr = _TaliSpecAttrMap} = PlayerStatus#player_status.status_talisman,
    %% 神兵属性
    #status_godweapon{attr = GodweaponAttr, figure_attr = GodweaponFigureAttr, special_attr = _GodWpSpecAttrMap} = PlayerStatus#player_status.status_godweapon,
    %% 神器属性
    #status_artifact{attr = ArtifactAttr} = PlayerStatus#player_status.status_artifact,
    %% 活跃度属性
    #st_liveness{attr = LivenessAttr} = PlayerStatus#player_status.st_liveness,
    %% 鲜花属性
    #flower{attr = FlowerAttr} = PlayerStatus#player_status.flower,
    %% 爵位属性
    AddJueWeiAttr = lib_juewei:get_juewei_attr(PlayerStatus),
    %% vip属性
%%    #vip_status{attr = VipAttr} = PlayerStatus#player_status.vip_status,
    %% 星图属性
    #star_map_status{attr = StarMapAttr} = PlayerStatus#player_status.star_map_status,
    %% 宝宝属性
    %#baby_status{attr = BabyAttr} = PlayerStatus#player_status.baby,
    %% 幻兽属性
    #eudemons_status{total_attr = EudemonsTotalAttr} = PlayerStatus#player_status.eudemons,
    %% 情缘属性
    MarriageLifeAttr = lib_marriage:get_marriage_life_attr(PlayerStatus),
    %% 坐骑装备属性
    #mount_equip{total_attr = MountEquipAttr, skill_combat = MountSkillCombat} = PlayerStatus#player_status.mount_equip,
    %% 家园
    #house_status{furniture_attr = FurnitureAttrList, house_attr = HouseAttrList} = PlayerStatus#player_status.house,
    %% 圣灵
    #status_holy_ghost{attr = HGhostAttr} = PlayerStatus#player_status.holy_ghost,
    %% 跨服公会战战舰属性
    %KfGwarShipAttr = lib_kf_guild_war_api:count_ship_attr(PlayerStatus#player_status.status_kf_guild_war, PlayerStatus#player_status.scene),
    %% 公会战战斗属性
    GuildBattleAttr = lib_guild_battle_api:count_guild_battle_attr(PlayerStatus),
    %% 公会领地战斗属性
    TerriwarAttr = lib_territory_war:count_terri_war_attr(PlayerStatus),
    %%勋章属性
    MedalAttr = lib_medal:get_attr(PlayerStatus),
    %%魔法阵属性
    MagicCircleAttr   = lib_magic_circle:get_attr(PlayerStatus),
    %%属性药剂属性
    AttrMedicamentAttr   = lib_attr_medicament:get_attr(PlayerStatus),
    %% 怪物图鉴
    #status_mon_pic{attr= MonPicAttr} = PlayerStatus#player_status.mon_pic,
    %% 灵器
    #anima_status{attr= AnimaEquipAttr} = PlayerStatus#player_status.anima_status,
    %% 幻饰
    #decoration{attr = DecorAttr} = PlayerStatus#player_status.decoration,
    %% 头衔
    #title{total_attr = TitleAttr} = PlayerStatus#player_status.title,
    %% 精灵
    #fairy{attr = FairyAttr, power = FairyPower} = PlayerStatus#player_status.fairy,
    %% 任务
    TaskAttr = PlayerStatus#player_status.task_attr,
    %% 成就阶段奖励
    AchievmentAttr = lib_achievement_api:get_all_attr(PlayerStatus#player_status.status_achievement),
    %% 圣裁
    #arbitrament_status{attr_list = ArbitramentAttr} = PlayerStatus#player_status.arbitrament_status,
    %% 圣印
    SealAttr =lib_seal:get_total_attr(PlayerStatus),
    %% 龙语
    DraconicAttr = lib_draconic:get_total_attr(PlayerStatus),
    %% 龙纹
    #status_dragon{sk_power = DragonSkPower, attr = DragonAttr} = PlayerStatus#player_status.dragon,
    %% 降神
    GodAttr = lib_god_util:get_total_attr(PlayerStatus),
    %% 装扮
    #status_dress_up{attr = DressupAttrList} = PlayerStatus#player_status.dress_up,
    %% 宝宝
    BabyAttr = lib_baby:get_baby_attr(PlayerStatus),
    BabySkillPower = lib_baby:get_baby_skill_power(PlayerStatus),
    {RevelationEquipAllAttr, RevelationEquipPower}= lib_revelation_equip:get_total_attr_and_power(PlayerStatus),
    %% 副本学习技能
    #status_dungeon_skill{skill_attr = DunSkillAttr, skill_power = DunSkillPower} = PlayerStatus#player_status.dungeon_skill,
    %% 使魔属性
    #status_demons{total_attr = DemonsAttr, skill_power = DemonsSkillPower, slot_skill_power = DemonsSlotPower} = PlayerStatus#player_status.status_demons,
    %% 至尊vip属性
    #status_supvip{total_attr = SupvipAttr, skill_power = SupvipSkillPower} = PlayerStatus#player_status.supvip,

    %% 背饰属性
    #back_decoration_status{attr = BackDecorationAttr, skill_combat = BackDecorationASkillCombat} = PlayerStatus#player_status.back_decoration_status,
    %% 远古奥术
    #status_arcana{total_attr = ArcanaAttr, sec_attr = ArcanaSecAttr, skill_power = ArcanaSkillPower} = PlayerStatus#player_status.arcana,
    %% 星宿
    ConstellationAttr = lib_constellation_equip:get_total_attr(PlayerStatus),
    ContractChallengeAttr = lib_contract_challenge:get_legend_attr(PlayerStatus),
    %% 公会神像
    GuildGodAttr = lib_guild_god:get_attr(PlayerStatus),
%%    %% 神庭
    #god_court_status{sum_attr = GodCourtAttr} = PlayerStatus#player_status.god_court_status,
    %% 海域功勋属性
    SeaExploitAttr = lib_seacraft_extra:get_exploit_attr(PlayerStatus),
    %% 海战日常
    SeaCraftAttr = lib_seacraft_daily:get_exp_attr_right(PlayerStatus),
    %% 伙伴（新属性
    {CompanionAttr, CompanionSkillPower} = lib_companion_util:get_power_info(PlayerStatus#player_status.status_companion),
    %% 套装收集
    #suit_collect{attr = SuitCollectAttr, skill_power = SuitSkillPower} = PlayerStatus#player_status.suit_collect,
    %% 神殿觉醒属性
    TempleAwakenAttr = lib_temple_awaken:get_attr(PlayerStatus),
    %% 龙珠技能战力
    {DragonBallAttr, DragonBallPower} = lib_dragon_ball:get_skill_and_attr(PlayerStatus),
    %% 符文技能属性
    RunSkillAttr = lib_rune:get_skill_attr(PlayerStatus),
    %% 战甲
    AmourAttr = lib_armour:get_attr(PlayerStatus),
    %% 时装套装属性
    FashionSuitAttr = lib_fashion_suit:get_fashion_suit_attr(PlayerStatus),
    %% ================================= 汇总所有的列表的总属性 =================================
    %% 五个放一行，方便排查的时候数
    AllOAttrList = [
        MainDungeonAddAttr, AttrMedicamentAttr, MonPicAttr, MedalAttr, MagicCircleAttr,
        SpeedAttr, LvAddAttr, DsgtAttr, EquipAttr, FashionAttr,
        RuneAttr, SoulAttr, RingAttr, EquipSuitAttr, BagFusionAttr,
        SkillAttr, SkillTalentAttr, ReincarnationAttr, AwakeningAttr, GuildSkillAttr,
        MountAttr, WingAttr, WingFigureAttr, TalismanAttr, TalismanFigureAttr,
        GodweaponAttr, GodweaponFigureAttr, ArtifactAttr, LivenessAttr, FlowerAttr,
        AddJueWeiAttr, StarMapAttr, BabyAttr, EudemonsTotalAttr, MarriageLifeAttr,
        DragonAttr, FurnitureAttrList, HouseAttrList, HGhostAttr, MountEquipAttr,
        AnimaEquipAttr, AchievmentAttr, DecorAttr, FairyAttr, TaskAttr,
        ArbitramentAttr, SealAttr, DressupAttrList, DunSkillAttr, GodAttr,
        RevelationEquipAllAttr, DemonsAttr, SupvipAttr, BackDecorationAttr, TitleAttr,
        DraconicAttr, ArcanaAttr, ConstellationAttr, ContractChallengeAttr, GuildGodAttr,
        EquipRefinementAttr, SeaExploitAttr, SeaCraftAttr, CompanionAttr, SuitCollectAttr,
        TempleAwakenAttr, GodCourtAttr, DragonBallAttr, AmourAttr, RunSkillAttr,
        FashionSuitAttr
    ],
    OAttrList = lib_player_attr:add_attr(list, AllOAttrList),
    OTotalAttr = lib_player_attr:to_attr_record(OAttrList),
    % 存储的第二属性
    StoreSecAttrMap = lib_sec_player_attr:to_attr_map([SkillTalentSecAttrMap, ArcanaSecAttr]),
    % 汇总所有的第二属性
    OSecAttrMap = lib_sec_player_attr:to_attr_map(OAttrList),
    % 增加人物对所有怪物伤害,pvp减免自身伤害,伙伴对怪物的伤害
    [MonHurtAdd, PVPHurtDelRatio, MateMonHurtAdd, AchivPvpHurtAdd] = lib_sec_player_attr:get_value_to_int(OSecAttrMap,
        [?MON_HURT_ADD, ?PVP_HURT_DEL_RATIO, ?MATE_MON_HURT_ADD, ?ACHIV_PVP_HURT_ADD]),

    %% =================================  总的属性计算 =================================
    %% 少数其他属性属性值计算
    %% 人物技能被动+:速度增加,血量恢复,boss伤害加成,pvp|e伤害减免,怪物技能伤害加深,
    [SpeedR, HpResumeAdd, BossHurtR, PVPEDelR, PVESkillHurtR|_] = get_other_attr(OAttrList, ?SP_ATTR_LIST, []),

    %% 天赋技能被动+:提高暴击几率(只对人物生效),怒火回音/破冰信语减少技能CD,单位是毫秒, 怒火回音/破冰信语增加护盾值,单位万分比, 不灭希望减少技能CD,单位是毫秒
    TalentSkillOtherAttrList = [?PVP_CRIT_ADD_RATIO, ?FIRE_ICE_MINUS_CD, ?FIRE_ICE_ADD_SHIELD, ?HOPE_MINUS_CD],
    [TSPvpCritR, TSFireIceMCd, TSFireIceShield, TSHopeMCd|_] = get_other_attr(OAttrList, TalentSkillOtherAttrList, []),
    % ?PRINT("BossHurtR:~p, PVESkillHurtR:~p, MonHurtAdd:~p, PVPHurtDel:~p, MateMonHurtAdd:~p ~n", [BossHurtR, PVESkillHurtR, MonHurtAdd, PVPHurtDel, MateMonHurtAdd]),

    %% 速度属性百分比计算
    NewSpeed = round(OTotalAttr#attr.speed * (1+SpeedR/?RATIO_COEFFICIENT)),
    % ?PRINT("Speed:~p SpeedR:~p NewSpeed:~p ~n", [Speed, SpeedR, NewSpeed]),

    CalcRatioAttr = calc_attr_ratio(OTotalAttr), %% 计算总属性(计算战力部分)
    TotalAttr = CalcRatioAttr#attr{speed = NewSpeed},
%%    #attr{
%%        att = NewAtt, hp = NewHp, wreck = NewWreck,
%%        def = NewDef, hit = NewHit, dodge = NewDodge,
%%        crit = NewCrit, ten = NewTen
%%    } = TotalAttr,
    %%降神技能战力
    GodSkillPower = lib_god_util:get_skill_power(PlayerStatus),
    %%符文技能战力
    RuneSkillPower = lib_rune:get_skill_power(PlayerStatus),
    CombatPower = calc_all_power(TotalAttr)+SkillPower+StrenPower+EquipSkillPower+MountSkillCombat+FairyPower+DsgtSkPower+
        MountPower+DragonSkPower+DunSkillPower + GodSkillPower + BabySkillPower + RevelationEquipPower + DemonsSkillPower + DemonsSlotPower +
        SupvipSkillPower + RuneSkillPower + BackDecorationASkillCombat + ArcanaSkillPower + CompanionSkillPower + DragonBallPower +SuitSkillPower,
    % ?PRINT("lib_player   FairyPower + MountPower, :~w~n",[[FairyPower , MountPower]]),

    %% 包含所有属性（计算战力部分的战力+不计算战力部分的战力）
    HolyBattleBuffAttr = lib_holy_spirit_battlefield:get_holy_spirit_battlefield_buff(PlayerStatus),
%%    ?MYLOG("holy", "HolyBattleBuffAttr ~p~n", [HolyBattleBuffAttr]),
    AllAttr = calc_attr_ratio(lib_player_attr:add_attr(record, [OTotalAttr, GoodsBuffAttrs, GuildBattleAttr, TerriwarAttr, HolyBattleBuffAttr])),
    #attr{hp = NewHp2, speed = NewSpeed2} = AllAttr,

    %% 血量上限百分比
    HpLimRatio = get_player_hp_lim_ratio(PlayerStatus),
    HpLimAfRatio = round(NewHp2 * (1 + HpLimRatio)),

    %% 血量修正
    GapHp = HpLimAfRatio - OldHpLim,
    RealHp = if
        OldHp == 0 -> 0;
        GapHp >= 0 -> min(OldHp+GapHp, HpLimAfRatio);
        true -> min(max(1, OldHp+GapHp), HpLimAfRatio)
    end,
    % 扣除速度
    case lists:keyfind(?MOUNT_ID, #status_mount.type_id, StatusMount) of
        false -> DelSpeed = 0;
        #status_mount{ride_attr = RideAttr} ->
            case lists:keyfind(?SPEED, 1, RideAttr) of
                {_, DelSpeed} -> 0;
                _ -> DelSpeed = 0
            end
    end,
    % NewDelSpeed = DelSpeed + 70,
    NewDelSpeed = DelSpeed,
    BattleSpeed = max(0, NewSpeed2 - round(NewDelSpeed*(1+SpeedR/?RATIO_COEFFICIENT)) ),
    NewBA = BA#battle_attr{hp = RealHp, hp_lim = HpLimAfRatio, speed = NewSpeed2, battle_speed = BattleSpeed,
       attr = AllAttr, sec_attr = StoreSecAttrMap, combat_power = CombatPower,
       hp_resume_time = 10, hp_resume_add = HpResumeAdd, boss_hurt_add = BossHurtR,
       pvpe_hurt_del = PVPEDelR, pve_skill_hurt_add = PVESkillHurtR, mon_hurt_add = MonHurtAdd, pvp_hurt_del_ratio = PVPHurtDelRatio,
       mate_mon_hurt_add = MateMonHurtAdd, achiv_pvp_hurt_add = AchivPvpHurtAdd,
       pvp_crit_add_ratio = TSPvpCritR,fire_ice_minus_cd = TSFireIceMCd, fire_ice_add_shield = TSFireIceShield,
       hope_minus_cd = TSHopeMCd, total_sec_attr = StoreSecAttrMap},
    NewPS = PlayerStatus#player_status{combat_power = CombatPower, battle_attr = NewBA, original_attr=OTotalAttr},

    % 输出
    if
        Type == logout_log_server_stop ->
            F = fun(E0, {TmpNum, TmpList}) ->
                case E0 of
                    [{_, _}|_] -> E = lists:keysort(1, util:combine_list(E0));
                    _ -> E = E0
                end,
                case TmpList == [] of
                    true -> {TmpNum+1, lists:concat([integer_to_list(TmpNum), ":", util:term_to_string(E)])};
                    false -> {TmpNum+1, lists:concat([TmpList, "\n", integer_to_list(TmpNum), ":", util:term_to_string(E)])}
                end
            end,
            {_, LogAttrList} = lists:foldl(F, {1, []}, AllOAttrList),
            % ?INFO("Id:~p LogAttrList:~p ~n", [Id, LogAttrList]),
            lib_log_api:log_attr(PlayerStatus#player_status.id, PlayerStatus#player_status.combat_power, CombatPower, LogAttrList);
        true ->
            skip
            % % 记录:只有固定时间和玩家才能输出
            % % 外服玩家id: 最紧要开心、十元、世界boss
            % IsLog = lists:member(PlayerStatus#player_status.id, [4337916968999, 4346506903767, 4337916968963]),
            % case IsLog orelse ?DEV_SERVER == true of
            %     true ->
            %         NowTime = utime:unixtime(),
            %         % 7.9号五点半(1562621400) 到 7.9号八点(1562630400)
            %         case (NowTime >= 1562621400 andalso NowTime =< 1562630400) orelse ?DEV_SERVER == true of
            %             true ->
            %                 F = fun(E0, {TmpNum, TmpList}) ->
            %                     case E0 of
            %                         [{_, _}|_] -> E = lists:keysort(1, util:combine_list(E0));
            %                         _ -> E = E0
            %                     end,
            %                     case TmpList == [] of
            %                         true -> {TmpNum+1, lists:concat([integer_to_list(TmpNum), ":", util:term_to_string(E)])};
            %                         false -> {TmpNum+1, lists:concat([TmpList, "\n", integer_to_list(TmpNum), ":", util:term_to_string(E)])}
            %                     end
            %                 end,
            %                 {_, LogAttrList} = lists:foldl(F, {1, []}, AllOAttrList),
            %                 % ?INFO("Id:~p LogAttrList:~p ~n", [Id, LogAttrList]),
            %                 lib_log_api:log_attr(PlayerStatus#player_status.id, PlayerStatus#player_status.combat_power, CombatPower, LogAttrList);
            %             false ->
            %                 skip
            %         end,
            %         ok;
            %     false ->
            %         skip
            % end
    end,
    %% 判断玩家是否在线
    case misc:is_process_alive(NewPS#player_status.pid) of
        false -> NewPS;
        true when Type == not_dispatch -> NewPS;
        true ->
            %% 通知速度改变
            case BA#battle_attr.speed /= NewBA#battle_attr.speed of
                false -> skip;
                true ->
                    lib_scene:change_speed(NewPS#player_status.id, NewPS#player_status.scene, NewPS#player_status.scene_pool_id,
                                           NewPS#player_status.copy_id, NewPS#player_status.x, NewPS#player_status.y, NewBA#battle_attr.speed, ?BATTLE_SIGN_PLAYER)
            end,
%%            %% 永恒碑谷
%%            Map = #{?ATT => NewAtt, ?HP => NewHp, ?WRECK => NewWreck, ?DEF => NewDef, ?HIT => NewHit, ?DODGE => NewDodge, ?CRIT => NewCrit, ?TEN => NewTen},
%%            {ok, NewPS1} = lib_eternal_valley_api:trigger(NewPS, {attr, Map}),
            %% 派发战力改变事件
            case CombatPower =:= OldCombatPower of
                true  -> NewPS;
                _ ->
                    {ok, LastPS} = lib_player_event:dispatch(NewPS, ?EVENT_COMBAT_POWER,
                        #callback_combat_power_data{type = Type, old_combat_power = OldCombatPower,
                        combat_power = CombatPower, hightest_combat_pwer = HightCombatPower}),
                    mod_scene_agent:update(LastPS, [{combat_power, CombatPower}]),
                    lib_task_api:combat_power(LastPS, CombatPower),
                    LastPS
            end
    end.

%% 计算学到的技能堆其他功能的属性影响
count_func_attribute(SkillId, SkillLv, Ps)->
    case data_skill:get(SkillId,  SkillLv) of
        #skill{lv_data = LvData} when is_record(LvData, skill_lv)->
            #skill_lv{base_attr = BaseAttr} = LvData,
            count_func_attribute(BaseAttr, Ps);
        _ -> Ps
    end.

count_func_attribute([], Ps)-> Ps;
count_func_attribute([{FuncId, _, _ }|BaseAttr], Ps)->
    NewPs = case FuncId of
        ?MOD_EQUIP ->
            {ok, Ps1} = lib_goods_util:count_role_equip_attribute(Ps),
            Ps1;
        ?MOD_MOUNT ->
            lib_mount:count_mount_attr(Ps);
        % ?MOD_WING ->
        %     lib_wing:count_wing_attr(Ps);
        % ?MOD_PET ->
        %     lib_pet:count_pet_attr(Ps);
        % ?MOD_TALISMAN ->
        %     lib_talisman:count_talisman_attr(Ps);
        % ?MOD_GODWEAPON ->
        %     lib_godweapon:count_godweapon_attr(Ps);
        {?MOD_MOUNT, ?MOD_MOUNT_SUB_MOUNT} ->
            lib_mount:count_mount_attr(Ps);
        {?MOD_MOUNT, ?MOD_MOUNT_SUB_MATE} ->
            lib_mount:count_mount_attr(Ps);
        {?MOD_MOUNT, ?MOD_MOUNT_SUB_ARTIFACT} ->
            lib_mount:count_mount_attr(Ps);
        {?MOD_MOUNT, ?MOD_MOUNT_SUB_HOLYORGAN} ->
            lib_mount:count_mount_attr(Ps);
        {?MOD_MOUNT, ?MOD_MOUNT_SUB_FLY} ->
            lib_mount:count_mount_attr(Ps);
        _ ->
            Ps
    end,
    count_func_attribute(BaseAttr, NewPs).

%% 玩家等级属性
base_lv_attr(RoleLv)->
    data_lv_attr:get(RoleLv).

%% 获取其他的属性值
get_other_attr(_AttrList, [], ReturnList) -> lists:reverse(ReturnList);
get_other_attr(AttrList, [AttrId|T], ReturnList) ->
    case lists:keyfind(AttrId, 1, AttrList) of
        false -> Value = 0;
        {_, Value} -> skip
    end,
    get_other_attr(AttrList, T, [Value|ReturnList]).

%% 部分属性的真实战力(改属性必须在玩家身上才能使用)
%% SumOAttr: #player_status.original_attr 玩家原始属性（没算百分比）
%% PartialPower 局部固定战力
%% PartialOAttr 局部原始属性
calc_partial_power(SumOAttr, PartialPower, PartialOAttr) ->
    SumAttr = calc_attr_ratio(SumOAttr),
    TemSumAttr = lib_player_attr:minus_attr(record, [SumOAttr, PartialOAttr]),
    ParitalAttr = calc_attr_ratio(TemSumAttr),
    max(0, calc_all_power(SumAttr) - calc_all_power(ParitalAttr) + PartialPower).

%% 与 calc_partial_power/3 作用相同
%% 算上基础等级属性的百分比（69 ~ 76属性ID， 有相关才调用）
calc_partial_power(RoleLv, SumOAttr, PartialPower, PartialOAttr) when is_integer(RoleLv)->
    LvAttr = base_lv_attr(RoleLv),
    CalcAttr =  lib_player_attr:minus_attr(record, [lib_player_attr:count_lv_attr(LvAttr, [PartialOAttr]), LvAttr]),
    calc_partial_power(SumOAttr, PartialPower, lib_player_attr:add_attr(record, [CalcAttr, PartialOAttr]));
%% 算上基础等级属性的百分比（221 ~ 226属性ID， 有相关才调用）
calc_partial_power(Player, SumOAttr, PartialPower, PartialOAttr) ->
    ChangeAttr = calc_other_equip_awake_attr(Player, PartialOAttr),
    #player_status{ figure = #figure{ lv = RoleLv } } = Player,
    calc_partial_power(RoleLv, SumOAttr, PartialPower, ChangeAttr).


%% 部分属性的期望战力（该属性没有实际加到玩家身上，比如战力预览）
%% SumOAttr: #player_status.original_attr 玩家原始属性（没算百分比）
%% PartialPower 局部固定战力
%% PartialOAttr 局部原始属性
calc_expact_power(SumOAttr, PartialPower, PartialOAttr) ->
    SumAttr = calc_attr_ratio(SumOAttr),
    TemSumAttr = lib_player_attr:add_attr(record, [SumOAttr, PartialOAttr]),
    AddSumAttr = calc_attr_ratio(TemSumAttr),
    max(0, calc_all_power(AddSumAttr) - calc_all_power(SumAttr) + PartialPower).

%% 与 calc_expact_power/3 作用相同
%% 算上基础等级属性的百分比（69 ~ 76属性ID， 有相关才调用）
calc_expact_power(RoleLv, SumOAttr, PartialPower, PartialOAttr) when is_integer(RoleLv)->
    LvAttr = base_lv_attr(RoleLv),
    CalcAttr =  lib_player_attr:minus_attr(record, [lib_player_attr:count_lv_attr(LvAttr, [PartialOAttr]), LvAttr]),
    calc_expact_power(SumOAttr, PartialPower, lib_player_attr:add_attr(record, [CalcAttr, PartialOAttr]));
%% 算上基础等级属性的百分比（221 ~ 226属性ID， 有相关才调用）
calc_expact_power(Player, SumOAttr, PartialPower, PartialOAttr) ->
    ChangeAttr = calc_other_equip_awake_attr(Player, PartialOAttr),
    #player_status{ figure = #figure{ lv = RoleLv } } = Player,
    calc_expact_power(RoleLv, SumOAttr, PartialPower, ChangeAttr).

%% 部分属性的期望战力
%% SumOAttr: #player_status.original_attr 玩家原始属性
%% PartialPower 局部固定战力
%% PartialOAttr 局部原始属性
calc_expect_power_detail(RoleId, Lv, SumOAttr, PartialPower, PartialOAttr) ->
    F = fun({AttId, AttVal}, {AccL1, AccL2, AccL3}) ->
        case lists:member(AttId, ?LV_ADD_RATIO_TYPE) of
            true -> {AccL1, AccL2, [{AttId, AttVal}|AccL3]};
            false ->
                case lists:member(AttId,?EQUIP_ADD_RATIO_TYPE) of
                    true -> {AccL1, [{AttId, AttVal}|AccL2], AccL3};
                    _ -> {[{AttId, AttVal}|AccL1], AccL2, AccL3}
                end
        end
    end,
    {NormalAttr, SpecialAttr, LvAttr} = lists:foldl(F, {[], [], []}, PartialOAttr),
    Power = round(lists:sum([data_attr:get_attr_base_rating_help(A, Lv, V)||{A, V}<-LvAttr])),
    case lib_goods_do:get_goods_status() of
       #goods_status{dict = Dict} when SpecialAttr =/= [] ->
           EquipList = lib_goods_util:get_equip_list(RoleId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, Dict),
           #{?EQUIP_TYPE_WEAPON := WeaponL, ?EQUIP_TYPE_ARMOR := ArmorL, ?EQUIP_TYPE_ORNAMENT := OrnamentL}
               = data_goods:classify_euqip(EquipList),
           WeaponAttr = data_goods:count_goods_attribute(WeaponL),
           ArmorAttr = data_goods:count_goods_attribute(ArmorL),
           OrnamentAttr = data_goods:count_goods_attribute(OrnamentL),
           WeaponOtherAttr = data_goods:count_equip_base_other_attribute(WeaponL),
           ArmorOtherAttr = data_goods:count_equip_base_other_attribute(ArmorL),
           OrnamentOtherAttr = data_goods:count_equip_base_other_attribute(OrnamentL),
           NewWeaponAttr = ulists:kv_list_plus_extra([WeaponAttr, WeaponOtherAttr, SpecialAttr]),
           NewArmorAttr = ulists:kv_list_plus_extra([ArmorAttr, ArmorOtherAttr, SpecialAttr]),
           NewOrnamentAttr = ulists:kv_list_plus_extra([OrnamentAttr, OrnamentOtherAttr, SpecialAttr]),
           LastWeaponAttr = data_goods:count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, NewWeaponAttr),
           LastArmorAttr = data_goods:count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, NewArmorAttr),
           LastOrnamentAttr = data_goods:count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, NewOrnamentAttr),
           SpeAttr1 = ulists:kv_list_minus_extra([LastWeaponAttr, NewWeaponAttr]),
           SpeAttr2 = ulists:kv_list_minus_extra([LastArmorAttr, NewArmorAttr]),
           SpeAttr3 = ulists:kv_list_minus_extra([LastOrnamentAttr, NewOrnamentAttr]),
           SpeAttr = ulists:kv_list_plus_extra([SpeAttr1, SpeAttr2, SpeAttr3]),
           calc_expact_power(SumOAttr, PartialPower + Power, SpeAttr ++ NormalAttr);
        _ -> calc_expact_power(SumOAttr, PartialPower+Power, PartialOAttr)
    end.

%% 计算模块属性战力
calc_module_power(PS, Mod) ->
    #player_status{original_attr = SumOAttr} = PS,
    {PartialPower, PartialOAttr} =
    case Mod of
    ?MOD_MEDAL ->
        MedalAttr = lib_medal:get_attr(PS),
        {0, MedalAttr};
    ?MOD_COMPANION ->
        {CompanionAttr, CompanionSkillPower} = lib_companion_util:get_power_info(PS#player_status.status_companion),
        {CompanionSkillPower, CompanionAttr};
    ?MOD_EQUIP ->
        #status_goods{equip_attribute = EquipAttr, equip_skill_power = EquipSkillPower} = PS#player_status.goods,
        {EquipSkillPower, EquipAttr};
    ?MOD_MOUNT ->
        {MountAttr, MountPower} = lib_mount:get_mount_all_attr(PS),
        {MountPower, MountAttr};
    ?MOD_RUNE ->
        #status_goods{rune_attr = RuneAttr} = PS#player_status.goods,
        {0, RuneAttr};
    ?MOD_DRAGON ->
        #status_dragon{sk_power = DragonSkPower, attr = DragonAttr} = PS#player_status.dragon,
        {DragonSkPower, DragonAttr};
    ?MOD_MON_PIC ->
        #status_mon_pic{attr= MonPicAttr} = PS#player_status.mon_pic,
        {0, MonPicAttr};
    ?MOD_SEAL ->
        SealAttr =lib_seal:get_total_attr(PS),
        {0, SealAttr};
    _ ->
        {0, []}
    end,
    calc_partial_power(SumOAttr, PartialPower, PartialOAttr).

%% 获取模块战力列表
get_module_power(PS, ModuleL) -> get_module_power(PS, ModuleL, []).

get_module_power(_, [], PowerL) -> PowerL;
get_module_power(PS, [Mod | ModuleL], Acc) -> get_module_power(PS, ModuleL, [{Mod, calc_module_power(PS, Mod)} | Acc]).

%% 进入战斗
enter_battle(OldPs) ->
    {_IsChange, Ps} = change_ride_status_slient(OldPs, ?MOUNT_ID, ?NOT_RIDE_STATUS),
    #player_status{battle_attr = BA, status_mount = StatusMount, dungeon_skill = StatusDunSkill} = Ps,
    IsCarryBrick = lib_seacraft_daily:is_carry(Ps),
    if
        IsCarryBrick == true ->
            OldPs;
        true ->
            % 总速度
            SpeedAttr = [{?SPEED, ?SPEED_VALUE}],
            {MountAttr, _MountPower} = lib_mount:get_mount_all_attr(Ps),
            %% 培养/装备属性
            #status_goods{equip_attribute = EquipAttr} = Ps#player_status.goods,
            #attr{speed = BaseSpeed} = lib_player_attr:add_attr(record, [SpeedAttr, MountAttr, EquipAttr]),
            % 扣除速度
            case lists:keyfind(?MOUNT_ID, #status_mount.type_id, StatusMount) of
                false -> DelSpeed = 0;
                #status_mount{ride_attr = RideAttr} ->
                    case lists:keyfind(?SPEED, 1, RideAttr) of
                        {_, DelSpeed} -> 0;
                        _ -> DelSpeed = 0
                    end
            end,
            % SpeedAfDel = BaseSpeed-DelSpeed-70,
            SpeedAfDel = BaseSpeed-DelSpeed,
            % 速度加成
            #status_dungeon_skill{skill_attr = DunSkillAttr} = StatusDunSkill,
            AllAttrList = [DunSkillAttr],
            AttrList = lib_player_attr:add_attr(list, AllAttrList),
            [SpeedR] = get_other_attr(AttrList, [?SPEED_ADD_RATIO], []),
            SpeedAfAdd = round(SpeedAfDel * (1+SpeedR/?RATIO_COEFFICIENT)),
            % buff影响速度
            #battle_attr{other_buff_list = OtherBuffList} = BA,
            [Float, Int] = lib_skill_buff:calc_speed_helper(OtherBuffList, utime:longunixtime(), [1.0, 0]),
            NewSpeed = max(0, round(SpeedAfAdd* Float+Int)),
            % ?PRINT("Id:~p Speed:~p SpeedAfAdd:~p NewSpeed:~p [Float, Int]:~w NowTime:~p ~n",
            %     [Ps#player_status.id, BaseSpeed, SpeedAfAdd, NewSpeed, [Float, Int], utime:unixtime()]),
            % ?PRINT("OtherBuffList:~p~n", [OtherBuffList]),
            NewBA = BA#battle_attr{speed=NewSpeed},
            NewPs = Ps#player_status{battle_attr = NewBA, is_battle=?IS_BATTLE_YES},
            broadcast_change_ride_status(?MOUNT_ID, NewPs),
            NewPs
            %% 客户端那边状态有问题,帮客户端容错,暂时屏蔽
            % % 通知速度改变
            % if
            %     IsChange ->
            %         % tool:back_trace_to_file(),
            %         ?PRINT("enter_battle RoleId:~p, Scene:~p BaseSpeed:~p, DelSpeed:~p SpeedAfDel:~p, BA#battle_attr.speed:~p NewSpeed:~p ~n",
            %             [Ps#player_status.id, Ps#player_status.scene, BaseSpeed, DelSpeed, SpeedAfDel, BA#battle_attr.speed, NewSpeed]),
            %         broadcast_change_ride_status(?MOUNT_ID, Ps),
            %         Ps#player_status{battle_attr = NewBA, is_battle=?IS_BATTLE_YES};
            %     BA#battle_attr.speed /= NewSpeed  ->
            %         ?PRINT("Id:~p Speed:~p NewSpeed:~p~n", [Ps#player_status.id, BA#battle_attr.speed, NewSpeed]),
            %         lib_scene:change_speed(Ps#player_status.id, Ps#player_status.scene, Ps#player_status.scene_pool_id,
            %             Ps#player_status.copy_id, Ps#player_status.x, Ps#player_status.y, NewSpeed, ?BATTLE_SIGN_PLAYER),
            %         Ps#player_status{battle_attr = NewBA, is_battle=?IS_BATTLE_YES};
            %     true ->
            %         Ps#player_status{is_battle=?IS_BATTLE_YES}
            % end
    end.

%% 广播
broadcast_change_ride_status(TypeId, Player) ->
    #player_status{
        id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y, battle_attr = BattleAttr,
        status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{figure_id = FigureId, is_ride = IsRide} = StatusType,
            % NewFigureId =
            %     case IsRide of
            %         ?RIDE_STATUS -> FigureId;
            %         _ -> 0
            %     end,
            NewFigureId = lib_temple_awaken_api:broadcast_change_ride_status(FigureId, TypeId, Player),
            mod_scene_agent:update(Player, [{mount_figure_ride, {TypeId, IsRide}}]),
            {ok, BinData} = pt_160:write(16001, [TypeId, RoleId, IsRide, NewFigureId, BattleAttr#battle_attr.speed]),
            lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
            Player;
        false ->
            Player
    end.

%% 静默地改变属性
change_ride_status_slient(#player_status{status_mount = StatusMount, sea_craft_daily = SeaDaily} = Player, TypeId, Type) ->
    #role_sea_craft_daily{status = CarryStatus} = SeaDaily,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount), % 是否有外观配置
    if
        CarryStatus == ?carrying ->
%%            ?PRINT("off_battle ++++++++++++ ~n", []),
            {false, Player};
        true ->
            case StatusType =/= false of
                true -> change_ride_status_slient(TypeId, Player, Type, StatusType);
                false -> {false, Player}
            end
    end.

change_ride_status_slient(TypeId, Player, Type, StatusType) ->
    #player_status{id = _RoleId, setting = #status_setting{setting_map=SettingM}, scene = Scene, figure = Figure = #figure{career = Career, mount_figure_ride = MountFigureRide}, status_mount = StatusMount} = Player,
    #status_mount{
        stage = Stage,
        illusion_type = IllusionType,
        illusion_id = IllusionId,
        attr = Attr,
        ride_attr = OldRideAttr,
        figure_id = OldFigureId,
        is_ride = _IsRide} = StatusType,
    IsCanRideMount = lib_mount:check_ride_mount_in_scene(Scene), % 检测场景ets的 is_ride 的状态
    #setting{is_open = IsAutoRide} = maps:get({?SYS_SETTING, ?AUTO_RIDE_SETTING}, SettingM, #setting{}),
    IsCantSlientRide = IsAutoRide == 0 andalso Type == ?RIDE_STATUS,
    %% 还要检测负面状态
    if
        IsCantSlientRide ->
            NewPlayer = Player, ErrorCode = skip;
        Type =/= ?NOT_RIDE_STATUS andalso Type =/= ?RIDE_STATUS ->
            NewPlayer = Player, ErrorCode = skip;
        IllusionType == 0 orelse IllusionId == 0 -> % 外形未激活
            NewPlayer = Player, ErrorCode = ?ERRCODE(err160_3_figure_inactive);
        Stage < ?MIN_STAGE -> % 外形未激活
            NewPlayer = Player, ErrorCode = ?ERRCODE(err160_3_figure_inactive);
        IsCanRideMount == false andalso Type == ?RIDE_STATUS -> % 该场景不可骑乘坐骑
            NewPlayer = Player, ErrorCode = ?ERRCODE(err160_8_mount_scene_limit);
        true ->
            FigureId = ?IF(Type == ?RIDE_STATUS, lib_mount:get_figure_id(TypeId, IllusionType, IllusionId, Career), OldFigureId),
            case Type == 0 of
                true -> %% 下坐骑
                    NewRideStatus = ?NOT_RIDE_STATUS,
                    RideAttr = [];
                _ -> %% 上坐骑
                    NewRideStatus = ?RIDE_STATUS,
                    RideAttr =
                        case data_mount:get_stage_cfg(TypeId, Stage, Career) of
                            #mount_stage_cfg{ride_attr = Ride_Attr} -> Ride_Attr;
                            _ -> []
                        end
            end,
            % 替换速度
            case lists:keyfind(?SPEED, 1, Attr) of
                {?SPEED, OldMountSpeed} ->
                    case lists:keyfind(?SPEED, 1, OldRideAttr) of
                        {?SPEED, OldRideSpeed} -> Diff = OldMountSpeed - OldRideSpeed;
                        _ -> Diff = 0
                    end;
                _ ->
                    Diff = 0
            end,
            case Diff > 0 of
                true -> NewAttr = lists:keyreplace(?SPEED, 1, Attr, {?SPEED, Diff});
                false -> NewAttr = lists:keydelete(?SPEED, 1, Attr)
            end,
            AttrAfUpDown = util:combine_list(NewAttr ++ RideAttr),
            NewStatusType = StatusType#status_mount{attr = AttrAfUpDown, figure_id = FigureId, ride_attr = RideAttr, is_ride = NewRideStatus},
            NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
            NewMountFigureRide = lists:keystore(TypeId, 1, MountFigureRide, {TypeId, NewRideStatus}),
            NewFigure = Figure#figure{mount_figure_ride = NewMountFigureRide},
            PsAfMount = Player#player_status{figure = NewFigure, status_mount = NewStatusMount},
            NewPlayer = recount_player_speed(PsAfMount),
            ErrorCode = ?SUCCESS
    end,
    case ErrorCode == ?SUCCESS of
        true -> {true, NewPlayer};
        false -> {false, NewPlayer}
    end.

%% 静默自动切换坐骑
auto_change_ride_mount_status_slient(Player) ->
    {_IsChange, NewPlayer} = auto_change_ride_mount_status_help(Player),
    NewPlayer.

%% 自动切换坐骑
auto_change_ride_mount_status(Player) ->
    {IsChange, NewPlayer} = auto_change_ride_mount_status_help(Player),
    if
        IsChange -> broadcast_change_ride_status(?MOUNT_ID, NewPlayer);
        true -> skip
    end,
    NewPlayer.

auto_change_ride_mount_status_help(#player_status{scene = Scene, online = Online} = Player) ->
    CanSceneRideMount = lib_mount:check_ride_mount_in_scene(Scene),
    IsOnline = Online == ?ONLINE_ON,
    #ets_scene{type = SceneType} = data_scene:get(Scene),
    IsKeepMountStatus = lists:member(SceneType, ?SCENE_TYPE_KEEP_MOUNT_STATUS),

    {IsChange, NewPlayer} =
    case {CanSceneRideMount, IsOnline, IsKeepMountStatus} of
        {false, _, _} -> change_ride_status_slient(Player, ?MOUNT_ID, ?NOT_RIDE_STATUS);
        {true, false, _} -> change_ride_status_slient(Player, ?MOUNT_ID, ?NOT_RIDE_STATUS);
        {true, true, false} -> change_ride_status_slient(Player, ?MOUNT_ID, ?RIDE_STATUS);
        _ -> {false, Player}
    end,

    {IsChange, NewPlayer}.

%% 重新计算玩家速度
recount_player_speed(#player_status{battle_attr = BA, dungeon_skill = StatusDunSkill, sea_craft_daily = SeaCraftDaily} = Ps) ->
    #role_sea_craft_daily{status = CarryStatus} = SeaCraftDaily,
    if
        CarryStatus == ?carrying ->
            Ps;
        true ->
            % 总速度
            SpeedAttr = [{?SPEED, ?SPEED_VALUE}],
            {MountAttr, _MountPower} = lib_mount:get_mount_all_attr(Ps),

            %% 培养/装备属性
            #status_goods{equip_attribute = EquipAttr} = Ps#player_status.goods,

            #attr{speed = BaseSpeed} = lib_player_attr:add_attr(record, [SpeedAttr, MountAttr, EquipAttr]),

            % 速度加成
            #status_dungeon_skill{skill_attr = DunSkillAttr} = StatusDunSkill,
            AllAttrList = [DunSkillAttr],
            AttrList = lib_player_attr:add_attr(list, AllAttrList),
            [SpeedR] = get_other_attr(AttrList, [?SPEED_ADD_RATIO], []),
            NewSpeed = round(BaseSpeed * (1+SpeedR/?RATIO_COEFFICIENT)),
            % 速度
            NewBA = BA#battle_attr{speed=NewSpeed},
            Ps#player_status{battle_attr = NewBA}
    end.

%% 脱离战斗
off_battle(#player_status{battle_attr = _BA} = OldPs) ->
    {_IsChange, Ps} = change_ride_status_slient(OldPs, ?MOUNT_ID, ?RIDE_STATUS),
    NewPs = recount_player_speed(Ps),
    % ?PRINT("Id:~p Speed:~p NewSpeed:~p NowTime:~p ~n", [Ps#player_status.id, BA#battle_attr.speed, NewSpeed, utime:unixtime()]),
    broadcast_change_ride_status(?MOUNT_ID, NewPs),
    NewPs#player_status{is_battle=?IS_BATTLE_NO}.
    %% 客户端那边状态有问题,帮客户端容错,暂时屏蔽
    % % 通知速度改变
    % #player_status{battle_attr = #battle_attr{speed = NewSpeed}} = NewPs,
    % if
    %     IsChange ->
    %         ?PRINT("off_battle BA#battle_attr.speed:~p NewSpeed:~p ~n",
    %             [ BA#battle_attr.speed, NewSpeed]),
    %         broadcast_change_ride_status(?MOUNT_ID, NewPs),
    %         NewPs#player_status{is_battle=?IS_BATTLE_NO};
    %     BA#battle_attr.speed /= NewSpeed ->
    %         % ?PRINT("Id:~p Speed:~p NewSpeed:~p ~n", [Ps#player_status.id, BA#battle_attr.speed, Speed]),
    %         lib_scene:change_speed(NewPs#player_status.id, NewPs#player_status.scene, NewPs#player_status.scene_pool_id,
    %             NewPs#player_status.copy_id, NewPs#player_status.x, Ps#player_status.y, NewSpeed, ?BATTLE_SIGN_PLAYER),
    %         NewPs#player_status{is_battle=?IS_BATTLE_NO};
    %     true ->
    %         NewPs#player_status{is_battle=?IS_BATTLE_NO}
    % end.

%% 计算玩家速度
count_player_speed(PlayerStatus)->
    #player_status{battle_attr=BA} = PlayerStatus,
    PlayerStatus#player_status{battle_attr = BA#battle_attr{speed=BA#battle_attr.attr#attr.speed}}.

speed_check(Ps)->
    {ok, BinData} = pt_130:write(13037, [Ps#player_status.battle_attr#battle_attr.speed]),
    lib_server_send:send_to_sid(Ps#player_status.sid, BinData).

%% 计算玩家历史最高战斗力
count_hightest_combat_power(PS) ->
    UpdateCd = 2*60,
    UpdateLv = 15,
    NowTime = utime:unixtime(),
    #player_status{combat_power = CombatPower, hightest_combat_power = HightCombatPower,
                   figure = #figure{lv = Lv}, hightest_combat_power_cd = HightCombatPowerCd} = PS,
    if
        Lv>=UpdateLv andalso CombatPower > HightCombatPower ->
            NewHighCombatPowerCd = NowTime + UpdateCd,
            case NowTime >= HightCombatPowerCd of
                true ->
                    NewPS = PS#player_status{hightest_combat_power = CombatPower, hightest_combat_power_cd = NewHighCombatPowerCd},
                    update_hightest_combat_power(NewPS, CombatPower),
                    NewPS;
                _ ->
                    PS#player_status{hightest_combat_power = CombatPower}
            end;
        true -> PS
    end.

%% 处理回调事件
handle_event(PS, #event_callback{type_id = ?EVENT_COMBAT_POWER}) ->
    NewPS = count_hightest_combat_power(PS),
    {ok, NewPS};

handle_event(PS, #event_callback{type_id = ?EVENT_PREPARE_CHANGE_SCENE}) ->
    NewPS = make_scene_train_obj_map(PS),
    {ok, NewPS#player_status{is_battle=?IS_BATTLE_NO}};

handle_event(PS, #event_callback{type_id = ?EVENT_TURN_UP}) ->
    NewPS = active_player_picture(PS),
    {ok, NewPS};
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) ->
    mod_daily:increment(Player#player_status.id, ?MOD_BASE, 1),
    {ok, Player};
%% 进入/扫荡 副本
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_ENTER, data = #callback_dungeon_enter{dun_type = SubType, count = Add}}) when is_record(PS, player_status) ->
    #player_status{id = RoleId} = PS,
    case SubType == ?DUNGEON_TYPE_EXP_SINGLE of
        true ->
            Count = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 3),
            mod_counter:set_count(RoleId, ?MOD_DUNGEON, 3, Count+Add),
            lib_server_send:send_to_uid(RoleId, pt_130, 13086, [[{1, Count+Add}]]);
        _ -> skip
    end,
    {ok, PS};
handle_event(PS, _EC) ->
    ?ERR("unkown event_callback:~p", [_EC]),
    {ok, PS}.

%%----------------------------------------------------------------------------------
%% @doc 发送相关玩家值给客户端更新
-spec send_attribute_change_notify(Status, ChangeReason) -> ok when
      Status :: #player_status{},         %% 玩家进程状态
      ChangeReason :: integer()|list().   %% 更新原因
%%----------------------------------------------------------------------------------
send_attribute_change_notify(Status, ?NOTIFY_ATTR) ->
    #player_status{
       sid = Sid,
       combat_power = CombatPower,
       battle_attr  = BattleAttr
      } = Status,
    lib_server_send:send_to_sid(Sid, pt_130, 13033, [CombatPower, BattleAttr]);

send_attribute_change_notify(Status, ?NOTIFY_PK) ->
    #player_status{
       sid = Sid,
       battle_attr = #battle_attr{pk = #pk{pk_value=PkValue, pk_value_change_time = PkValueChangeTime}}
      } = Status,
    lib_server_send:send_to_sid(Sid, pt_130, 13034, [PkValue, PkValueChangeTime]);

%% 货币改变
send_attribute_change_notify(Status, ?NOTIFY_MONEY) ->
    #player_status{sid  = Sid, gold = Gold, bgold = BGold, coin = Coin, gcoin = GCoin} = Status,
    {ok, BinData} = pt_130:write(13006, [Coin, Gold, BGold, GCoin]),
    lib_server_send:send_to_sid(Sid, BinData);

send_attribute_change_notify(Status, ReasonList) when is_list(ReasonList) ->
    [send_attribute_change_notify(Status, Reason) || Reason <- ReasonList],
    ok.

%% ---------------------------------------------------------------------------
%% @doc 角色进程cast方式执行MFA 跨节点
-spec apply_cast(Node, PlayerPid, CastType, HandleOffline, Moudle, Method, Args) -> Res when
      Node        :: atom(),
      PlayerPid   :: integer() | pid(),   %% 玩家Id或者玩家进程pid
      CastType    :: integer(),           %% Cast类型：?APPLY_CAST|?APPLY_CAST_STATUS|?APPLY_CAST_SAVE
      %% ?APPLY_CAST       ::1 进程cast方式执行MFA
      %% ?APPLY_CAST_STATUS::2 进程cast方式执行MFA，默认添加#player_status{}作为A的第一个参数
      %% ?APPLY_CAST_SAVE  ::3 进程cast方式执行MFA，默认添加#player_status{}作为A的第一个参数，且保存新的#status{}
      HandleOffline::integer(),           %% 是否处理离线情况
      Moudle      :: atom(),              %% 模块名
      Method      :: atom(),              %% 方法名
      Args        :: term(),              %% 方法实参
      Res         :: ok | skip.           %% 结果码
%% ---------------------------------------------------------------------------
apply_cast(Node, PlayerPid, CastType, HandleOffline, Moudle, Method, Args) ->
    if
        Node =:= node() orelse Node =:= undefined orelse Node =:= none ->
            apply_cast(PlayerPid, CastType, HandleOffline, Moudle, Method, Args);
        true ->
            rpc:cast(Node, ?MODULE, apply_cast, [PlayerPid, CastType, HandleOffline, Moudle, Method, Args])
    end.

%% ---------------------------------------------------------------------------
%% @doc 角色进程cast方式执行MFA
-spec apply_cast(PlayerPid, CastType, Moudle, Method, Args) -> Res when
      PlayerPid   :: integer() | pid(),   %% 玩家Id或者玩家进程pid
      CastType    :: integer(),           %% Cast类型：?APPLY_CAST|?APPLY_CAST_STATUS|?APPLY_CAST_SAVE
      %% ?APPLY_CAST       ::1 进程cast方式执行MFA
      %% ?APPLY_CAST_STATUS::2 进程cast方式执行MFA，默认添加#player_status{}作为A的第一个参数
      %% ?APPLY_CAST_SAVE  ::3 进程cast方式执行MFA，默认添加#player_status{}作为A的第一个参数，且保存新的#status{}
      Moudle      :: atom(),              %% 模块名
      Method      :: atom(),              %% 方法名
      Args        :: term(),              %% 方法实参
      Res         :: ok | skip.           %% 结果码
%% ---------------------------------------------------------------------------
apply_cast(PlayerPid, CastType, Moudle, Method, Args) ->
    apply_cast(PlayerPid, CastType, ?NOT_HAND_OFFLINE, Moudle, Method, Args).

%% ---------------------------------------------------------------------------
%% @doc 角色进程cast方式执行MFA
-spec apply_cast(PlayerPid, CastType, HandleOffline, Moudle, Method, Args) -> Res when
      PlayerPid   :: integer() | pid(),   %% 玩家Id或者玩家进程pid
      CastType    :: integer(),           %% Cast类型：?APPLY_CAST|?APPLY_CAST_STATUS|?APPLY_CAST_SAVE
      %% ?APPLY_CAST       ::1 进程cast方式执行MFA
      %% ?APPLY_CAST_STATUS::2 进程cast方式执行MFA，默认添加#player_status{}作为A的第一个参数
      %% ?APPLY_CAST_SAVE  ::3 进程cast方式执行MFA，默认添加#player_status{}作为A的第一个参数，且保存新的#status{}
      HandleOffline::integer(),           %% 是否处理离线情况
      %% ?NOT_HAND_OFFLINE ::0 不处理离线情况
      %% ?HAND_OFFLINE     ::1 处理离线情况
      Moudle      :: atom(),              %% 模块名
      Method      :: atom(),              %% 方法名
      Args        :: term(),              %% 方法实参
      Res         :: ok | skip.           %% 结果码
%% ---------------------------------------------------------------------------
apply_cast(PlayerPid, CastType, HandleOffline, Moudle, Method, Args) when is_integer(PlayerPid) ->
    Pid = misc:get_player_process(PlayerPid),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, {apply_cast, CastType, Moudle, Method, Args});
        _  when HandleOffline == ?HAND_OFFLINE ->
            lib_offline_api:apply_cast(PlayerPid, Moudle, Method, Args);
        _ ->
            skip
    end;
apply_cast(PlayerPid, CastType, _HandleOffline, Moudle, Method, Args) ->
    case misc:is_process_alive(PlayerPid) of
        true ->
            gen_server:cast(PlayerPid, {apply_cast, CastType, Moudle, Method, Args});
        %% false when HandleOffline == ?HAND_OFFLINE ->
        %%     lib_offline_api:apply_cast(PlayerPid, Moudle, Method, Args);
        false ->
            skip
    end.

%% 在线角色进程cast方式执行MFA
cast_online_role_apply(CastType, Moudle, Method, Args) ->
    F = fun(#ets_online{id=PlayerId}, _Acc) ->
        apply_cast(PlayerId, CastType, Moudle, Method, Args),
        ok
    end,
    % ets:tab2list
    ets:foldl(F, ok, ?ETS_ONLINE).

%% ---------------------------------------------------------------------------
%% @doc 角色进程cast方式执行MFA
-spec apply_call(PlayerPid, CastType, Moudle, Method, Args) -> Res when
      PlayerPid   :: integer() | pid(),   %% 玩家Id或者玩家进程pid
      CastType    :: integer(),           %% Call类型：?APPLY_CALL|?APPLY_CALL_STATUS|?APPLY_CALL_SAVE
      %% ?APPLY_CALL       ::1 进程call方式执行MFA
      %% ?APPLY_CALL_STATUS::2 进程call方式执行MFA，默认添加#player_status{}作为A的第一个参数
      %% ?APPLY_CALL_SAVE  ::3 进程call方式执行MFA，默认添加#player_status{}作为A的第一个参数，且保存新的#status{}
      Moudle      :: atom(),              %% 模块名
      Method      :: atom(),              %% 方法名
      Args        :: term(),              %% 方法实参
      Res         :: skip | term().       %% 返回值
%% ---------------------------------------------------------------------------
apply_call(PlayerPid, CallType, Moudle, Method, Args) ->
    apply_call(PlayerPid, CallType, Moudle, Method, Args, sys_timeout).

apply_call(PlayerPid, CallType, Moudle, Method, Args, Timeout) when is_pid(PlayerPid) ->
    case misc:is_process_alive(PlayerPid) of
        true ->
            case is_integer(Timeout) of
                true -> gen_server:call(PlayerPid, {apply_call, CallType, Moudle, Method, Args}, Timeout);
                false -> gen_server:call(PlayerPid, {apply_call, CallType, Moudle, Method, Args})
            end;
        _ ->
            skip
    end;
apply_call(PlayerId, CallType, Moudle, Method, Args, Timeout) ->
    PlayerPid = misc:get_player_process(PlayerId),
    case misc:is_process_alive(PlayerPid) of
        true ->
            case is_integer(Timeout) of
                true -> gen_server:call(PlayerPid, {apply_call, CallType, Moudle, Method, Args}, Timeout);
                false -> gen_server:call(PlayerPid, {apply_call, CallType, Moudle, Method, Args})
            end;
        _ ->
            skip
    end.

%% cast 在线玩家
apply_cast_all_online(CastType, Module, Method, Args) ->
    [apply_cast(Pid, CastType, Module, Method, Args)||#ets_online{pid = Pid}<-ets:tab2list(?ETS_ONLINE)].

%% 获取主角默认模型列表
get_model_list(Career, Sex, Turn, Lv) ->
    PartList = [?MODEL_PART_HEAD, ?MODEL_PART_CLOTH, ?MODEL_PART_WEAPON],
    [{Part, get_model_id(?LV_MODEL, Part, Career, Sex, Turn, Lv, 0)} || Part <- PartList].
%% 等级模型：
% 头发资源规则: 10+职业(1位)+1000
% 衣服资源规则: 10+职业(1位)+0000
% 武器资源规则: 15+职业(1位)+0000
get_model_id(Model, Part, Career, _Sex, _Turn, _Lv, _No) ->
    % NewLv = 1,
    % 1*100000000+_Part*1000000+Career*10000+NewLv*100+_No;
    % Career*1000+Sex*100+Turn;
    % lib_reincarnation:get_turn_model_id(_Career, _Sex, _Turn);
    lib_career:get_model_id(Model, Part, Career).

be_hurted(Status, BattleReturn, Atter, AtterSign, _Hurt) ->
    %% @retrun
    lib_role_drum:player_be_hurt(Status, BattleReturn, Atter, AtterSign),
    Status.

%% 玩家死亡处理
%% Status :当前自己的进程状态
%% AtterSign :杀人者类型 1怪, 2人
%% Atter     :杀人者信息 #battle_return_atter{}
%% HitList   :助攻列表 [#hit{}|...]
player_die(OldStatus, AtterSign, Atter, _HitList) ->
    #battle_return_atter{id = AttId, real_name = AttName, lv = AttLv, mask_id = MaskId} = Atter,
    #player_status{id = RoleId, scene = Scene, scene_pool_id = ScenePId, copy_id = CopyId,
                   x = X, y = Y, battle_attr=BA, figure = Figure, guild = _StatusGuild} = OldStatus,
    #battle_attr{speed = Speed, pk=Pk} = BA,
    ShowAttrName = get_killer_show_name([AttName, MaskId], Scene),
    %% 伤害其他人
    %% Maps = #{attersign => AtterSign, atter => Atter, hit => HitList},
    %% {ok, Status} = lib_player_event:dispatch(OldStatus, ?EVENT_PLAYER_DIE, Maps),
    %% 修正速度
    lib_scene:change_speed(RoleId, Scene, ScenePId, CopyId, X, Y, Speed, 2),
    %% 对于主城和野外挂机死亡
    NewStatus
        = case data_scene:get(OldStatus#player_status.scene) of
              #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_NORMAL orelse
                                                SceneType == ?SCENE_TYPE_OUTSIDE ->
                  %% 红名玩家死亡掉落绑钻
                  {Status1, CostBGold}
                      = if
                            Pk#pk.pk_value =< 0 orelse OldStatus#player_status.bgold =< 0 -> {OldStatus, 0};
                            true ->
                                BGold = min(OldStatus#player_status.bgold, 20),
                                Status2 = lib_goods_util:cost_money(OldStatus, BGold, bgold, red_name_be_kill, ""),
                                {Status2, BGold}
                        end,

                  %% 通知被杀
                  {ok, DieBinData} = pt_200:write(20013, [AtterSign, ShowAttrName, Pk#pk.pk_value, CostBGold, AttLv, Figure#figure.turn, AttId]),
                  lib_server_send:send_to_sid(OldStatus#player_status.sid, DieBinData),

                  %% 添加到仇人列表
                  ?IF(AtterSign == ?BATTLE_SIGN_PLAYER andalso Pk#pk.pk_value == 0 andalso
                      Pk#pk.pk_status == ?PK_PEACE , lib_relationship:add_enemy(RoleId, AttId), skip),

                  %% 触发击杀者成就
                  lib_achievement_api:async_event(AttId, lib_achievement_api, kill_player_event, 1),
                  Status1;
              _ ->
                  %% 通知被杀
                  {ok, DieBinData} = pt_200:write(20013, [AtterSign, ShowAttrName, Pk#pk.pk_value, 0, AttLv, Figure#figure.turn, AttId]),
                  lib_server_send:send_to_sid(OldStatus#player_status.sid, DieBinData),
                  %% BOSS场景杀公会高层传闻
                  InBoss = lib_boss:is_in_boss(Scene),
                  if
                      AtterSign /= ?BATTLE_SIGN_MON andalso InBoss andalso
                      Figure#figure.guild_id /= 0 andalso Figure#figure.position < 2 ->
                          SceneName = lib_scene:get_scene_name(Scene),
                          #figure{name = Name, guild_name = GName, position_name = PName, mask_id = MaskId2} = Figure,
                          WrapName = get_wrap_role_name(Name, [MaskId2]),
                          Args = [ShowAttrName, AttId, SceneName, GName, PName, WrapName, RoleId],
                          lib_chat:send_TV({all}, ?MOD_BOSS, 3, Args);
                      true ->
                          skip
                  end,
                  %% 蛮荒禁地判断是怒气
                  mod_boss:forbidden_boss_bekill_add_anger(Scene, RoleId),
                  ?IF(lib_void_fam:is_in_void_fam(Scene),
                      mod_void_fam_local:kill_player(AttId, ShowAttrName, RoleId, Figure#figure.name, Scene), skip),
                  %% 公会争霸
                  % lib_guild_battle_api:kill_player(OldStatus, Atter),
                  OldStatus
          end,
    %% Return
    LastBeKill = [{sign, AtterSign}, {id, AttId}, {name, ShowAttrName}, {lv, AttLv}, {mask_id, MaskId}],
    NewStatus#player_status{last_be_kill = LastBeKill}.

%% 玩家在跨服场景死亡
%% Status   :当前自己的进程状态
%% AttSign  :杀人者类型 1怪, 2人, 3宠物
%% Atter    :杀人者信息 #battle_return_atter{}
%% HitList  :助攻列表
clusters_player_die(Status, AttSign, Atter, HitList) ->
    #battle_return_atter{id = AttId, real_name = AttName, lv = AttLv, mask_id = MaskId, server_id = AtterServerId} = Atter,
    #player_status{
       id          = DieId,
       server_id   = ServerId,
       scene_pool_id = ScenePId,
       copy_id     = CopyId,
       scene       = Scene,
       figure      = Figure,
       battle_attr = BA
      } = Status,
    %% BOSS场景杀公会高层传闻
    % InEudemonsBoss = lib_eudemons_land:is_in_eudemons_boss(Scene),
    % if
    %     AttSign /= ?BATTLE_SIGN_MON andalso InEudemonsBoss andalso
    %     Figure#figure.guild_id /= 0 andalso Figure#figure.position < 2 ->
    %         SceneName = lib_scene:get_scene_name(Scene),
    %         #figure{name = Name, guild_name = GName, position_name = PName} = Figure,
    %         AttServerId = mod_player_create:get_serid_by_id(AttId),
    %         Args = [AttName, AttId, AttServerId, SceneName, GName, PName, Name, DieId, ServerId],
    %         lib_chat:send_TV({all_exclude, DieId}, ?MOD_EUDEMONS_BOSS, 3, Args),
    %         lib_chat:send_TV({scene, Scene, ScenePId, CopyId}, ?MOD_EUDEMONS_BOSS, 3, Args);
    %     true ->
    %         skip
    % end,
    ShowAttrName = get_killer_show_name([AttName, MaskId], Scene),
    ?IF(lib_void_fam:is_in_void_fam(Scene),
        mod_void_fam_local:kill_player(AttId, ShowAttrName, DieId, Figure#figure.name, Scene), skip),
    %% 跨服1vn
    lib_kf_1vN:player_die(Status),
    %% 跨服公会战
    lib_kf_guild_war_api:kill_player(Scene, CopyId, DieId, Figure#figure.name, Atter, HitList),
    %% 跨服圣域
    AttSign =:= ?BATTLE_SIGN_PLAYER andalso ServerId =/= AtterServerId andalso lib_sanctuary_cluster_api:kill_player(Scene, ScenePId, AtterServerId, Atter, 0, 0),
    %% 怒海争霸
    AttSign =:= ?BATTLE_SIGN_PLAYER andalso lib_seacraft:kill_player(Scene, ScenePId, DieId, Figure#figure.name, Atter, HitList),
    %% 钻石大战
    lib_role_drum:player_die(Atter,Status),
    %% 幻兽之域
    lib_eudemons_land:player_die(Atter,Status),
    %% 跨服秘境大妖
    lib_great_demon_local:player_die(Atter, Status),
    %% 通知被杀
    {ok, DieBinData} = pt_200:write(20013, [AttSign, ShowAttrName, BA#battle_attr.pk#pk.pk_value, 0, AttLv, Figure#figure.turn, AttId]),
    lib_server_send:send_to_sid(Status#player_status.sid, DieBinData),
    %% @retrun
    LastBeKill = [{sign, AttSign}, {id, AttId}, {name, ShowAttrName}, {lv, AttLv}],
    Status#player_status{last_be_kill = LastBeKill}.


%% 更改pk值
%% 更改角色PK状态
%% @param PS #player_status
%% @param Type  ?PK_PEACE | ?PK_ALL | ?PK_FORCE | ?PK_SERVER | ?PK_CAMP
%% return->{ok, #player_status} | false
-define(PK_CHANGE_CD, 0).
change_pkstatus(PS, Type) -> change_pkstatus(PS, Type, false).
change_pkstatus(PS, Type, IsForce) ->
    #player_status{
        id = RoleId, copy_id = CopyId, scene = SceneId, scene_pool_id=ScenePoolId,
        x = X, y = Y, change_scene_sign = ChangeSceneSign, battle_attr=BA, sid=Sid, figure=Figure,
        husong = HuSong
        } = PS,
    #pk{pk_status = OldPkState, pk_change_time=PkChangeTime} = PkStatus = BA#battle_attr.pk,
    NowTime = utime:unixtime(),
    LeftCdTime = 0,
    %% 能切换pk状态的场景
    IsCanChangeScene = case data_scene:get(SceneId) of
        #ets_scene{subtype=?SCENE_SUBTYPE_NORMAL} -> lists:member(Type, ?PK_NORMAL_L);
        #ets_scene{subtype=?SCENE_SUBTYPE_SELECT} -> true;
        _ -> false
    end,
    IsCanChange = case data_scene:get(SceneId) of
        #ets_scene{subtype=?SCENE_SUBTYPE_SELECT, requirement=Requirement} ->
            case lists:keyfind(pkstate_list, 1, Requirement) of
                {_, PkStatusL} -> lists:member(Type, PkStatusL);
                _ -> false
            end;
        _ -> true
    end,
    %% 幻兽之域
    %InEudemons = lib_eudemons_land:is_in_eudemons_boss(SceneId),
    InHuSong = lib_husong:is_husong(HuSong),
    Result = if
        IsForce -> %% 强制切换，服务端操作
            NewPkStatus = PkStatus#pk{pk_status = Type},
            NewPS = PS#player_status{battle_attr = BA#battle_attr{pk=NewPkStatus}},
            {true, LeftCdTime, NewPS};
        % Type =:= ?PK_PEACE_ULTIMATE -> {?ERRCODE(err130_no_peace_ultimate), LeftCdTime}; %% 不能切换为终极和平pk状态

        %InEudemons andalso Type == ?PK_PEACE -> {?ERRCODE(err130_no_peace), LeftCdTime}; %% 不能切换为和平pk状态

        InHuSong -> {?ERRCODE(err130_not_change), LeftCdTime}; %% 不能切换pk状态

        Figure#figure.lv < 2 -> {?ERRCODE(err130_change_pk_lv_lim), LeftCdTime}; %% 新手不能切换pk状态

        ChangeSceneSign == 1 -> {?ERRCODE(err130_change_pk_change_line), LeftCdTime}; %% 换线中不能切换场景

        IsCanChangeScene == false ->  {?ERRCODE(err130_user_cant_change_pk), LeftCdTime}; %% 本场景不能手动切换场景
        IsCanChange == false -> {?ERRCODE(err130_user_cant_change_this_pk), LeftCdTime}; %% 此场景不能切换该战斗模式

        OldPkState == ?PK_PEACE andalso Type /= ?PK_PEACE -> %% 和平切换为其他状态
            NewPkStatus = PkStatus#pk{pk_status = Type, pk_change_time=NowTime},
            NewPS = PS#player_status{battle_attr = BA#battle_attr{pk=NewPkStatus}},
            {true, ?PK_CHANGE_CD, NewPS};

        Type /= ?PK_PEACE orelse NowTime >= PkChangeTime+?PK_CHANGE_CD -> %% 切换为和平状态或者切换其他状态
            NewPkStatus = PkStatus#pk{pk_status = Type},
            NewPS = PS#player_status{battle_attr = BA#battle_attr{pk=NewPkStatus}},
            {true, LeftCdTime, NewPS};

        true ->
            {?ERRCODE(err130_change_pk_cd), LeftCdTime}
    end,
    case Result of
        {true, CD, ChangePkPS} ->
            mod_scene_agent:update(ChangePkPS, [{pk, ChangePkPS#player_status.battle_attr#battle_attr.pk}]),
            %% 通知场景的玩家
            {ok, BinData} = pt_120:write(12074, [?BATTLE_SIGN_PLAYER, RoleId, Type]),
            lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, X, Y, BinData),
            {ok, BinData1} = pt_130:write(13012, [?SUCCESS, Type, CD]),
            lib_server_send:send_to_sid(Sid, BinData1),
            {ok, ChangePkPS};
        {ErrCode, CD} ->
            {ok, BinData} = pt_130:write(13012, [ErrCode, Type, CD]),
            lib_server_send:send_to_sid(Sid, BinData),
            false
    end.

get_pk_cd_time(PS) ->
    #player_status{battle_attr=#battle_attr{pk=#pk{pk_change_time=Time}}} = PS,
    Now = utime:unixtime(),
    max(0, Time+?PK_CHANGE_CD-Now).

%% 发送玩家信息界面
send_player_info_view(PS, Id) when is_integer(Id) ->
    case PS#player_status.id =:= Id of
        true ->
            List = make_player_info_view(PS),
            {ok, BinData} = pt_130:write(13004, List),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        false ->
            ToPid = misc:get_player_process(Id),
            case is_pid(ToPid) andalso misc:is_process_alive(ToPid) of
                true ->
                    apply_cast(ToPid, ?APPLY_CAST_STATUS, lib_player, send_player_info_view, [PS#player_status.sid]);
                false ->
                    {ok, BinData} = pt_130:write(13004, []),
                    lib_server_send:send_to_sid(PS#player_status.sid, BinData)
            end
    end,
    ok;
send_player_info_view(PS, Sid) ->
    List = make_player_info_view(PS),
    {ok, BinData} = pt_130:write(13004, List),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 获得角色信息面板
make_player_info_view(PS) when is_record(PS, player_status) ->
    [PS#player_status.id, PS#player_status.figure, PS#player_status.battle_attr, PS#player_status.combat_power];
make_player_info_view(_PS) ->
    [].

%% 总战力计算
calc_all_power(TotalAttr) when is_record(TotalAttr, attr) ->
    #attr{
        att = Att, hp = Hp, wreck = Wreck, def = Def,
        hit = Hit, dodge = Dodge, crit = Crit, ten = Ten,
        elem_att = ElemAtt, elem_def = ElemDef,
        hurt_add_ratio = HurtAddR, hurt_del_ratio = HurtDelR,
        hit_ratio = HitR, dodge_ratio = DodgeR, crit_ratio = CritR,
        uncrit_ratio = UnCritR, heart_ratio = HeartR,
        %% 新算战力
        skill_hurt_add_ratio = SkillHurtAddRatio,
        skill_hurt_del_ratio = SkillHurtDelRatio,
        crit_hurt_add_ratio = CritHurtAddRatio,
        crit_hurt_del_ratio = CritHurtDelRatio,
        parry_ratio = ParryRatio,
        heart_hurt_add_ratio = HeartHurtAddRatio, heart_hurt_del_ratio = HeartHurtDelRatio,
        heart_down_ratio = HeartDownRatio, abs_att = AbsAtt, abs_def = AbsDef,
        rebound_ratio = ReboundRatio,
        exc_ratio = ExcRatio, unexc_ratio = UnExcRatio, exc_hurt_add_ratio = ExcHurtAddRatio,
        exc_hurt_del_ratio = ExcHurtDelRatio, armor = Armor,
        pvp_hurt_add = PvpHurtAdd, pvp_hurt_del = PvpHurtDel
        }= TotalAttr,
    % 公式常用战力
    HpPower = Hp*0.5,
    AWCHPower = (Att+Wreck+Crit+Hit)*10,
    HDTDPower = HpPower+(Def+Ten+Dodge)*10,
    % 元素战力
    ElemPower = (ElemAtt+ElemDef)*10,
    % 伤害加深和伤害减免战力
    HurtAddRPower = AWCHPower * (HurtAddR/?RATIO_COEFFICIENT),
    HurtDelRPower = HDTDPower * (HurtDelR/?RATIO_COEFFICIENT),
    % 命中率和闪避率战力
    HitRPower = AWCHPower * (HitR/?RATIO_COEFFICIENT),
    DodgeRPower = HDTDPower * (DodgeR/?RATIO_COEFFICIENT),
    % 暴击几率和暴击抵抗战力
    CritRPower = AWCHPower * (CritR/?RATIO_COEFFICIENT),
    UnCritRPower = HDTDPower * (UnCritR/?RATIO_COEFFICIENT),
    % 会心战力
    HeartPower = AWCHPower * 0.3 * HeartR/?RATIO_COEFFICIENT,
    % 技能伤害加深和减免战力
    SHAddPower = AWCHPower * 0.35 * (SkillHurtAddRatio/?RATIO_COEFFICIENT),
    SHDelPower = HDTDPower * 0.35 * (SkillHurtDelRatio/?RATIO_COEFFICIENT),
    % 暴伤加深和暴伤减免战力
    CHAddPower = AWCHPower * 0.25 * (CritHurtAddRatio/?RATIO_COEFFICIENT),
    CHDelPower = HDTDPower * 0.25 * (CritHurtDelRatio/?RATIO_COEFFICIENT),
    % 格挡几率战力
    ParryRPower = HDTDPower * 0.5 * (ParryRatio/?RATIO_COEFFICIENT),
    % 会心伤害和会心免伤战力
    HeartHurtAddRPower = AWCHPower * 0.3 * (HeartHurtAddRatio/?RATIO_COEFFICIENT),
    HeartHurtDelRPower = HDTDPower * 0.3 * (HeartHurtDelRatio/?RATIO_COEFFICIENT),
    % 抗会心几率战力
    HeartDownPower = HDTDPower * 0.3 * (HeartDownRatio/?RATIO_COEFFICIENT),
    %% 绝对属性战力
    AbsPower = (AbsAtt+AbsDef)*20,
    % 反弹战力
    ReboundPower = HDTDPower * 1 * (ReboundRatio/?RATIO_COEFFICIENT),
    % 卓越一击几率战力
    ExcRPower = AWCHPower * 0.5 * (ExcRatio/?RATIO_COEFFICIENT),
    UnExcRPower = HDTDPower * 0.5 * (UnExcRatio/?RATIO_COEFFICIENT),
    % 卓越一击伤害、减免战力
    ExcHurtAddPower = AWCHPower * 0.2 * (ExcHurtAddRatio/?RATIO_COEFFICIENT),
    ExcHurtDelPower = HDTDPower * 0.2 * (ExcHurtDelRatio/?RATIO_COEFFICIENT),
    % 护甲
    ArmorPower = HDTDPower * 0.3 * Armor/100,
    % pvp伤害、减免战力
    PvpHurtPower = (PvpHurtAdd+PvpHurtDel)*20,

    % 总战力
    round(AWCHPower + HDTDPower + ElemPower + HurtAddRPower + HurtDelRPower + HitRPower + DodgeRPower + CritRPower + UnCritRPower
    + HeartPower + SHAddPower + SHDelPower + CHAddPower + CHDelPower + ParryRPower + HeartHurtAddRPower + HeartHurtDelRPower
    + HeartDownPower + AbsPower + ReboundPower + ExcRPower + UnExcRPower + ExcHurtAddPower + ExcHurtDelPower + ArmorPower + PvpHurtPower);
calc_all_power(TotalAttr) ->
    Attr = lib_player_attr:to_attr_record(TotalAttr),
    lib_player:calc_all_power(Attr).

send_quickbar_info(Status) ->
    {ok, BinData} = pt_130:write(13007, Status#player_status.quickbar),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    ok.

%% 更新快捷栏(保存数据库)
db_save_quickbar(Status) ->
    db_save_quickbar(Status#player_status.id, Status#player_status.quickbar).
db_save_quickbar(RoleId, Quickbar) ->
    SQL = io_lib:format(?sql_update_player_quickbar, [util:term_to_bitstring(Quickbar), RoleId]),
    db:execute(SQL).

%% 删除指定位置的快捷栏
save_quickbar([Local, Type, Id, AutoTag], Q) ->
    Q1 = case lists:keyfind(Local, 1, Q) of
        false -> Q;
        _ -> lists:keydelete(Local, 1, Q)
    end,
    %% 筛选,保证每个类型下只有一个相同Id
    Q2 = [{OneLocal, OneType, OneId, OneAutoTag}||{OneLocal, OneType, OneId, OneAutoTag} <- Q1, OneType == Type andalso OneId /= Id],
    [{Local, Type, Id, AutoTag}|Q2].

%% 删除指定位置的快捷栏
delete_quickbar(Local, Q) ->
    case lists:keyfind(Local, 1, Q) of
        false -> Q;
        _ -> lists:keydelete(Local, 1, Q)
    end.

%% 替换快捷栏
replace_quickbar(Local1, Local2,  Q) ->
    Local1Data = lists:keyfind(Local1, 1, Q),
    Local2Data = lists:keyfind(Local2, 1, Q),
    if
        Local1Data =/= false andalso Local2Data =/= false ->
            {Local1, Type1, Id1, AutoTag1} = Local1Data,
            {Local2, Type2, Id2, AutoTag2} = Local2Data,
            Q1 = lists:keystore(Local1, 1, Q, {Local1, Type2, Id2, AutoTag2}),
            lists:keystore(Local2, 1, Q1, {Local2, Type1, Id1, AutoTag1});
        Local1Data =/= false ->
            Q1 = lists:keydelete(Local1, 1, Q),
            {Local1, Type1, Id1, AutoTag1} = Local1Data,
            lists:keystore(Local2, 1, Q1, {Local2, Type1, Id1, AutoTag1});
        Local2Data =/= false ->
            Q1 = lists:keydelete(Local2, 1, Q),
            {Local2, Type2, Id2, AutoTag2} = Local2Data,
            lists:keystore(Local2, 1, Q1, {Local1, Type2, Id2, AutoTag2});
        true -> Q
    end.

%% 根据类型清理快捷栏
clear_quickbar_by_type(Type, Q, PlayerId) ->
    NewQuickbar = clear_quickbar_by_type_helper(Type, Q, []),
    {ok, BinData} = pt_130:write(13007, NewQuickbar),
    lib_server_send:send_to_uid(PlayerId, BinData),
    NewQuickbar.

clear_quickbar_by_type_helper(_Type, [], Result) -> Result;
clear_quickbar_by_type_helper(Type, [{_Local, Type, _Id}|Q], Result) ->
    clear_quickbar_by_type_helper(Type, Q, Result);
clear_quickbar_by_type_helper(Type, [H|Q], Result) ->
    clear_quickbar_by_type_helper(Type, Q, Result++[H]).

%% 计算经验和加成
%% @return {ExpAdd, ExpAddRatio}
%%  ExpAdd 增加的经验(整数)
%%  ExpAddRatio 增加的经验倍率(整数，百分比)
calc_exp_add_and_ratio(OldStatus, ExpType, AddExp) ->
    %% 计算总的经验##无类型不要加成
    ExpAddTypeL = [
        ?ADD_EXP_MON, ?ADD_EXP_ONHOOK, ?ADD_EXP_GUILD_FEAST, ?ADD_EXP_MIDDAY_PARTY, ?ADD_EXP_DUN_ADD,
        ?ADD_EXP_HOLY_SPIRIT_BATTLEFIELD, ?ADD_EXP_SEA_DAILY
        ],
    IsAddRatio = lists:member(ExpType, ExpAddTypeL),
    {ExpAdd, ExpAddRatio} = if
        ExpType == ?ADD_EXP_GUILD_FEAST -> %% 公会晚宴
%%            ExpRatioTemp = lib_player:get_exp_add_ratio(OldStatus, ExpType),
            ExpRatio = lib_guild_feast:get_food_exp_ratio(OldStatus),
%%            ?PRINT("ExpRatio ~p~n", [ExpRatio]),
%%            ?PRINT("ExpRatioTemp ~p~n", [ExpRatioTemp]),
            {round(AddExp * ExpRatio), round(ExpRatio*100)};
        IsAddRatio -> %% 杀怪
            ExpRatio = lib_player:get_exp_add_ratio(OldStatus, ExpType),
            {round(AddExp * ExpRatio), round(ExpRatio*100)};
        % 仅仅是显示经验加成倍率,功能内部已经加成了
        ExpType == ?ADD_EXP_AFK ->
            ExpRatio = lib_player:get_exp_add_ratio(OldStatus, ExpType),
            {round(AddExp), round(ExpRatio*100)};
        %% 其他类型
        true ->
            {round(AddExp), 0}
    end,
    {ExpAdd, ExpAddRatio}.

%% 计算所有的经验加成值
get_exp_add_ratio(Ps) ->
    get_exp_add_ratio(Ps, ?ADD_EXP_NO).

get_exp_add_ratio(Ps, ExpType) ->
    get_exp_add_ratio(Ps, ExpType, 0).

%% AddRatio 额外比例万分比
get_exp_add_ratio(Ps, ExpType, AddRatio) ->
    #player_status{
        id = _RoleId, figure = Figure, skill = SkillStatus, vip = VipStatus,
        goods = _StatusGoods, goods_buff_exp_ratio = BuffExpRatio, team = _StatusTeam,
        magic_circle = MagicCircle, battle_attr = #battle_attr{attr = #attr{exp_add_ratio = ExpAddRatio}}} = Ps,
    %   rune_attr = RuneAttr,             %% 符文属性
    %   soul_attr = SoulAttr              %% 聚魂属性
    %  } = StatusGoods,
    %#goods_status{equip_special_attr = _EquipSpecialAttr} = lib_goods_do:get_goods_status(),
    %% 培养功能经验加成
    % case lists:keyfind(?EXP_ADD, 1, RuneAttr) of
    %     false -> RuneExpPlusRatio = 0;
    %     {_, RuneExpPlusRatio} -> skip
    % end,
    % case lists:keyfind(?EXP_ADD, 1, SoulAttr) of
    %     false -> SoulExpPlusRatio = 0;
    %     {_, SoulExpPlusRatio} -> skip
    % end,
    % TrainExpPlusRatio = RuneExpPlusRatio + SoulExpPlusRatio,
    %% 装备经验加成
    % EquipExpPlusRatio = maps:get(?EXP_ADD, EquipSpecialAttr, 0),
    %% 世界等级加成
    ServerLv = util:get_world_lv(),
    ServerLvExpRatio = calc_satisfy_world_exp_add(Ps, ServerLv),
    %% 被动技能加成
    #status_skill{skill_attr = SkillAttr} = SkillStatus,
    case lists:keyfind(?EXP_ADD, 1, SkillAttr) of
        false -> SkillExpRatio = 0;
        {_, SkillExpRatio} -> skip
    end,
    % ?MYLOG("hjh", "EXP_ADD:~p ~n", [?EXP_ADD]),
    %% 队伍加成 放在物品buff里面了
    %case StatusTeam of
    %    #status_team{exp_scale = TeamExpRatio, team_id = TeamId} when TeamId > 0 -> ok;
    %    _ -> TeamExpRatio = 0
    %end,
    VipExp = lib_vip_api:get_vip_privilege(?MOD_BASE, ?MOD_BASE_EXP, VipStatus#role_vip.vip_type, VipStatus#role_vip.vip_lv),
    % CollectExpRatio = lib_collect:get_collect_exp_ratio(Ps),
    % ?PRINT("add_exp Args:~w~n", [[SkillExpRatio, ServerLvExpRatio, VipExp, BuffExpRatio]]),
    % 1+(TrainExpPlusRatio+SkillExpRatio+EquipExpPlusRatio+TeamExpRatio+VipExp)/?RATIO_COEFFICIENT + ServerLvExpRatio/100 + BuffExpRatio + CollectExpRatio.
    MagicCircleExpRatio = lib_magic_circle:get_exp_ratio(MagicCircle), %%魔法阵经验加成
    RuneExpRatio        = lib_rune:get_exp_ratio(Ps), %%符文经验加成
    GodExpRatio         = lib_god_util:get_exp_ratio(Ps),
    MainDungeonExpRation= lib_enchantment_guard:get_exp_attr_ratio(Ps, ExpType), %%主线副本经验加成
    SupremeExpRatio = lib_supreme_vip:get_exp_ratio(Ps), %% 至尊vip加成
    ModuleBuffExpRatio = lib_module_buff:get_module_buff_exp_add(Ps), %% 生活技能加成
    CompanionExpRatio = lib_companion_util:get_exp_ratio(Ps), %% 伙伴经验加成
    MountExpRatio = lib_mount:get_exp_ratio(Ps), %%
    ContractExpRatio = lib_contract_challenge:get_legend_exp_ratio(Ps), %%
    % ?PRINT("ExpAddRatio:~p ~n", [ExpAddRatio]),
    DunCountRatio = lib_dungeon:get_exp_count_ratio(Ps, ExpType),
    SumExpRatio = (1+(ContractExpRatio + MountExpRatio + SkillExpRatio + MagicCircleExpRatio + RuneExpRatio + MainDungeonExpRation + SupremeExpRatio + ModuleBuffExpRatio + CompanionExpRatio + AddRatio + GodExpRatio + ExpAddRatio)/?RATIO_COEFFICIENT +
        (ServerLvExpRatio+VipExp)/100 + BuffExpRatio)*DunCountRatio,
    if
        % 离线状态且是击杀怪物,经验值加两倍
        Ps#player_status.online == ?ONLINE_OFF_ONHOOK andalso ExpType == ?ADD_EXP_MON -> SumExpRatioAfOnhook = SumExpRatio*2;
        true -> SumExpRatioAfOnhook = SumExpRatio
    end,
    SumExpRatioAfOnhook.

%% 获取玩家的掉落概率加成
get_goods_drop_add_ratio(Ps) ->
    #goods_status{
       equip_special_attr = EquipSpecialAttr
      } = lib_goods_do:get_goods_status(),
    %% 装备经验加成
    EquipDropRatio = maps:get(?RARE_GOODS_DROP_UP, EquipSpecialAttr, 0),
    %% 物品buff掉落加成
    BuffDropRatio = lib_goods_buff:get_goods_drop_buff(Ps),
    %% 活动掉落概率加成
    EquipDropRatio/?RATIO_COEFFICIENT + BuffDropRatio.

get_player_hp_lim_ratio(PlayerStatus) ->
    ModbuffHpLimR = lib_module_buff:get_module_buff_hp_lim_add(PlayerStatus), %% 生活技能加成
    ModbuffHpLimR.

%% 有些活动在玩家进程不能完全确定能不能进行，在本进程检查通过后因为未上锁，别的活动也认为当前没上锁而通过
%% 最后两边发生冲突
%% 加上一个软锁，在玩家进程就可以锁上，如此别的活动在5秒内都不能通过
%% 即使加锁的活动有什么出错，5秒后别的活动便能继续，不至于一直不能进行
soft_action_lock(#player_status{action_lock = ActionLock} = Player, LockInfo) ->
    NowTime = utime:unixtime(),
    case ActionLock of
        free ->
            Player#player_status{action_lock = {NowTime + ?ACTION_SOFT_LOCK_TIME, LockInfo}};
        {OldTime, _} when NowTime >= OldTime ->
            Player#player_status{action_lock = {NowTime + ?ACTION_SOFT_LOCK_TIME, LockInfo}};
        _ ->
            ?ERR("~p your ~p lock try to replace ~p~n", [Player#player_status.id, LockInfo, ActionLock]),
            Player
    end.

soft_action_lock(#player_status{action_lock = ActionLock} = Player, LockInfo, LockTime) ->
    NowTime = utime:unixtime(),
    case ActionLock of
        free ->
            Player#player_status{action_lock = {NowTime + LockTime, LockInfo}};
        {OldTime, _} when NowTime >= OldTime ->
            Player#player_status{action_lock = {NowTime + LockTime, LockInfo}};
        _ ->
            ?ERR("~p your ~p lock try to replace ~p~n", [Player#player_status.id, LockInfo, ActionLock]),
            Player
    end.

setup_action_lock(#player_status{action_lock = free} = Player, LockInfo) ->
    case LockInfo of
        Code when is_integer(Code) ->
            Player#player_status{action_lock = LockInfo};
        _ ->
            Player
    end;

setup_action_lock(#player_status{action_lock = ActionLock} = Player, LockInfo) ->
    case ActionLock of
        {_, LockInfo} ->
            Player#player_status{action_lock = LockInfo};
        LockInfo ->
            Player;
        {SoftLockTime, _Other} ->
            NowTime = utime:unixtime(),
            if
                NowTime >= SoftLockTime ->
                    Player#player_status{action_lock = LockInfo};
                true ->
                    ?ERR("~p your ~p lock try to replace ~p~n", [Player#player_status.id, LockInfo, ActionLock]),
                    Player
            end;
        _ ->
            ?ERR("~p your ~p lock try to replace ~p~n", [Player#player_status.id, LockInfo, ActionLock]),
            Player
    end.

% break_action_lock(Player) ->
%     Player#player_status{action_lock = free}.

break_action_lock(Player, Lock) ->
    case Player#player_status.action_lock of
        Lock ->
            Player#player_status{action_lock = free};
        {_, Lock} ->
            Player#player_status{action_lock = free};
        free ->
            Player;
        AnotherLock ->
            ?ERR("you try to break a exist lock ~p with ~p~n", [AnotherLock, Lock]),
            Player
    end.

send_figure_to_uid(Player, ServerId, ModId, ToId) ->
    #player_status{id = Id, figure = Figure, combat_power = Power, server_name = ServerName, server_num = ServerNum} = Player,
    {ok, BinData} = pt_130:write(13013, [ServerId, ServerNum, Id, ModId, Power, Figure, ServerName]),
    lib_server_send:send_to_uid(ToId, BinData).

send_figure_to_uid(Player, ServerId, ModId, Node, ToId) ->
    #player_status{id = Id, figure = Figure, combat_power = Power, server_name = ServerName, server_num = ServerNum} = Player,
    {ok, BinData} = pt_130:write(13013, [ServerId, ServerNum, Id, ModId, Power, Figure, ServerName]),
    mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, ToId, BinData]).

get_figure_from_other_server(ServerId, RoleId, ModId, Node, ToId) ->
    mod_clusters_center:apply_cast(ServerId, ?MODULE, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, send_figure_to_uid, [ServerId, ModId, Node, ToId]]).

update_all_player(KeyValueList) ->
    Ids = lib_online:get_online_ids(),
    [mod_server_cast:set_data(KeyValueList, Id) || Id <- Ids],
    ok.

%% 系统转化成为 train_obj Map
make_scene_train_obj_map(PlayerStatus) ->
    SceneTrainObjMap = make_scene_train_obj_map_help(PlayerStatus),
    PlayerStatus#player_status{train_object = SceneTrainObjMap}.

make_scene_train_obj_map_help(PlayerStatus) ->
    TrainTypeList = [?MATE_ID],
    SceneObjM = make_scene_train_obj_map_help(PlayerStatus, TrainTypeList),
    SceneObjMAfFairy = make_scene_train_obj_map_help(PlayerStatus, SceneObjM, ?BATTLE_SIGN_FAIRY),
    SceneObjMAfDemons = make_scene_train_obj_map_help(PlayerStatus, SceneObjMAfFairy, ?BATTLE_SIGN_DEMONS),
    SceneObjCompanion = make_scene_train_obj_map_help(PlayerStatus, SceneObjMAfDemons, ?BATTLE_SIGN_COMPANION),
    SceneObjCompanion.

%% 培养系统
make_scene_train_obj_map_help(#player_status{status_mount = StatusMountL} = Player, TrainTypeList) ->
    F = fun(TrainType, Acc) ->
        case lists:keyfind(TrainType, #status_mount.type_id, StatusMountL) of
            false -> Acc;
            Mount ->
                case lib_mount:train_type_to_att_type(TrainType) of
                    0 -> Acc;
                    AttSign -> Acc#{AttSign => make_scene_train_obj(Player, Mount)}
                end
        end
    end,
    lists:foldl(F, #{}, TrainTypeList).

%% 其他系统
make_scene_train_obj_map_help(#player_status{fairy=#fairy{battle_id=BattleId, fairy_list=FairyList}} = _Player, SceneObjM, AttSign=?BATTLE_SIGN_FAIRY) ->
    case lists:keyfind(BattleId, #fairy_sub.fairy_id, FairyList) of
        false -> SceneObjM;
        #fairy_sub{attr_list = Attr} ->
            SceneObj = #scene_train_object{
                att_sign = AttSign
                , battle_attr = #battle_attr{attr = lib_player_attr:to_attr_record(Attr)}
            },
            SceneObjM#{AttSign => SceneObj}
    end;
%% 使魔
make_scene_train_obj_map_help(Player, SceneObjM, AttSign=?BATTLE_SIGN_DEMONS) ->
    case lib_demons:get_demons_battle_info(Player) of
        {ok, Attr, DemonsPassiveSkills} ->
            SceneObj = #scene_train_object{
                att_sign = AttSign
                , battle_attr = #battle_attr{attr = lib_player_attr:to_attr_record(Attr)}
                , passive_skill = DemonsPassiveSkills
            },
            SceneObjM#{AttSign => SceneObj};
        _ ->
            SceneObjM
    end;
make_scene_train_obj_map_help(Player, SceneObjM, ?BATTLE_SIGN_COMPANION) ->
    #player_status{status_companion = #status_companion{fight_id = CompanionId}} = Player,
    lib_companion:load_train_obj(SceneObjM, CompanionId);
make_scene_train_obj_map_help(_Player, SceneObjM, _AttSign) ->
    SceneObjM.

make_scene_train_obj(_Player, #status_mount{type_id = TrainType, attr = Attr}) ->
    AttSign = lib_mount:train_type_to_att_type(TrainType),
    #scene_train_object{
        att_sign = AttSign
        , battle_attr = #battle_attr{attr = lib_player_attr:to_attr_record(Attr)}
    }.

%% 更新
update_scene_train_obj([], Player) -> Player;
update_scene_train_obj([H|T], #player_status{train_object = SceneTrainObjMap}=Player) ->
    case H of
        {scene_train_attr, {Sign, Attr}} ->
            case maps:get(Sign, SceneTrainObjMap, []) of
                [] -> NewPlayer = Player;
                #scene_train_object{battle_attr = BA} = SceneTrainObj ->
                    NewSceneTrainObj = SceneTrainObj#scene_train_object{battle_attr = BA#battle_attr{attr = Attr}},
                    NewSceneTrainObjMap = maps:put(Sign, NewSceneTrainObj, SceneTrainObjMap),
                    NewPlayer = Player#player_status{train_object = NewSceneTrainObjMap}
            end;
        {scene_train_object, #scene_train_object{att_sign = Sign} = SceneTrainObj} ->
            NewSceneTrainObjMap = maps:put(Sign, SceneTrainObj, SceneTrainObjMap),
            NewPlayer = Player#player_status{train_object = NewSceneTrainObjMap}
    end,
    update_scene_train_obj(T, NewPlayer).

%% 计算属性:数据不存在则初始化
calc_scene_train_obj_kvlist(#player_status{train_object = SceneTrainObjMap} = Player, Sign, StatusMount, KeyValueList) ->
    case maps:get(Sign, SceneTrainObjMap, []) of
        [] -> [{scene_train_object, make_scene_train_obj(Player, StatusMount)}];
        _SceneTrainObj -> KeyValueList
    end.

%% 计算属性:数据不存在则初始化
calc_scene_obj_kvlist(Player, Sign=?BATTLE_SIGN_FAIRY, KeyValueList) ->
    #player_status{train_object = SceneTrainObjMap, fairy=#fairy{battle_id=BattleId, fairy_list=FairyList}} = Player,
    case lists:keyfind(BattleId, #fairy_sub.fairy_id, FairyList) of
        false -> KeyValueList;
        #fairy_sub{attr_list = Attr} ->
            case maps:get(Sign, SceneTrainObjMap, []) of
                [] ->
                    SceneObj = #scene_train_object{
                        att_sign = Sign
                        , battle_attr = #battle_attr{attr = lib_player_attr:to_attr_record(Attr)}
                    },
                    [{scene_train_object, SceneObj}];
                _SceneTrainObj ->
                    KeyValueList
            end
    end;
calc_scene_obj_kvlist(_Player, _Sign, KeyValueList) ->
    KeyValueList.

%% 使用头像激活道具
use_picture_goods(PS, _GS, GoodsInfo, Num) ->
    #player_status{id = RoleId, sid = Sid, figure = #figure{sex = Sex, career = Career, turn = Turn}, picture_list = PictureList} = PS,
    #goods{goods_id = GoodsTypeId} = GoodsInfo,
    PictureAll = data_picture:get_picture_ids(),
    case filter_picture_goods(PictureAll, {Sex, Career, Turn, GoodsTypeId, Num}, {false, ?ERRCODE(err150_not_picture_goods)}) of
        {ok, Id, CostNum} ->
            ?PRINT("use_picture_goods ~p~n", [Id]),
            case lists:member(Id, PictureList) of
                false ->
                    Sql = usql:replace(player_picture, [id, picture_id], [[RoleId, Id]]),
                    db:execute(Sql),
                    NewPictureList = [Id|PictureList],
                    NewStatus = PS#player_status{picture_list = NewPictureList},
                    {ok, Bin} = pt_130:write(13081, [1, Id]),
                    lib_server_send:send_to_sid(Sid, Bin),
                    {ok, NewStatus, CostNum};
                _ ->
                    {fail, ?ERRCODE(err130_picture_active)}
            end;
        {false, Res} -> ?PRINT("use_picture_goods ~p~n", [Res]), {fail, Res}
    end.

filter_picture_goods([], _, Result) -> Result;
filter_picture_goods([Id|L], {Sex, Career, Turn, GoodsTypeId, GoodsNum}, Result) ->
    case data_picture:get_picture_info_by_id(Id) of
        [{CareerLim, CostList}] ->
            CareerEnough = case CareerLim == 0 of true -> true; _ -> CareerLim == Career end,
            {_, GoodsCost} = ulists:keyfind(goods, 1, CostList, {goods, []}),
            if
                CareerEnough =/= true ->
                    filter_picture_goods(L, {Sex, Career, Turn, GoodsTypeId, GoodsNum}, Result);
                GoodsCost == [] ->
                    filter_picture_goods(L, {Sex, Career, Turn, GoodsTypeId, GoodsNum}, Result);
                true ->
                    FFind = fun({Type, GId, _Num}) -> Type == ?TYPE_GOODS andalso GId == GoodsTypeId end,
                    case ulists:find(FFind, GoodsCost) of
                        {ok, {_Type, _GoodsTypeId, NeedNum}} when GoodsNum>=NeedNum ->
                            {ok, Id, NeedNum};
                        {ok, _} ->
                            {false, ?GOODS_NOT_ENOUGH};
                        _ ->
                            filter_picture_goods(L, {Sex, Career, Turn, GoodsTypeId, GoodsNum}, Result)
                    end
            end;
        _ -> filter_picture_goods(L, {Sex, Career, Turn, GoodsTypeId, GoodsNum}, Result)
    end.

get_role_picture_list(Id, Career) ->
    Sql = usql:select(player_picture, [picture_id], [{id, Id}]),
    PictureList = case db:get_all(Sql) of
        [] -> [];
        List -> lists:flatten(List)
    end,
    % DefaultPictureId = ?IF(Career == ?KNIGHT, binary_to_integer(?KNIGHT_PICTURE), binary_to_integer(?ARCHER_PICTURE)),
    DefaultPictureIdBin = lib_career:get_picture(Career),
    DefaultPictureId = binary_to_integer(DefaultPictureIdBin),
    [DefaultPictureId|PictureList].

%% 增加临时技能
%% [{6000001, 1},{6000002, 1},{6000001, 3},{6000004, 1},{6000005, 1},{6000006, 1}]
gm_test_tmp_skill() ->
    RoleId = 4294967297,
    SkillList = [{6000001, 1},{6000002, 1},{6000001, 3},{6000004, 1},{6000005, 1},{6000006, 1}],
    lib_skill_api:add_tmp_skill_list(RoleId, SkillList),
    ok.

%% 战斗
battle(Player) ->
    pp_battle:handle(20001, Player, [[], [], 6000001, 0, 0, 0]).

%% mysql 最多只保存3个字节大小的单个字符，超过范围的字符需要过滤，emoji是4字节的数据
% “汉”字的Unicode编码是0x6C49。0x6C49在0x0800-0xFFFF之间，使用3字节模板：1110xxxx 10xxxxxx 10xxxxxx。
% 将0x6C49写成二进制是：0110 1100 0100 1001， 用这个比特流依次代替模板中的x，得到：11100110 10110001 10001001，即E6 B1 89。
judge_char_len([]) -> true;
judge_char_len([H|T]) ->
    IsIdVsn = lib_vsn:is_id(),
    if
        H > 65535 ->  %% 65535是unicode编码的3字节最大范围（0x0800-0xFFFF）
            {false, 4};
        H == 16#00A0 orelse H == 16#0020 orelse H == 16#3000 -> %% 屏蔽3种空格字符#会对客户端部分显示功能照成影响
            {false, 4};
        IsIdVsn andalso H >= 16#A980 andalso H =< 16#A9DF -> % 印尼需求:屏蔽爪哇语命名,部分手机设备显示会有问题
            {false, 4};
        true ->
            judge_char_len(T)
    end.

%% 角色名合法性检测
validate_name(Name) ->
    validate_name(len, Name).

%% 角色名合法性检测:长度
validate_name(len, Name) ->
    case unicode:characters_to_list(list_to_binary(Name)) of
        CharList when is_list(CharList) ->
            case judge_char_len(CharList) of
                true ->
                    Len = util:string_width(CharList),
                    LenLimit = lib_vsn:name_len(),
                    case Len =< LenLimit andalso Len > 2 of
                        true ->
                            validate_name(keyword, Name);
                        false ->
                            {false, 5}
                    end;
                _ ->
                    {false, 4}
            end;
        _ ->
            %%非法字符
            {false, 4}
    end;

%%判断角色名是否已经存在
%%Name:角色名
validate_name(existed, Name) ->
    case lib_player:is_exists(Name) of
        true ->
            %%角色名称已经被使用
            {false, 3};
        false ->
            case lists:member(ulists:list_to_bin(Name), data_robot_chat:get_occupy_name_list()) of
                true -> {false, 3};
                false -> true
            end
    end;

%%判断角色名是有敏感词
%%Name:角色名
validate_name(keyword, Name) ->
    case lib_word:check_keyword_name(Name) of
        false -> validate_name(existed, Name);
        _ -> {false, 7}
    end;

validate_name(_, _Name) ->
    {false, 2}.

%% 获取包装后玩家名
get_wrap_role_name(PS) ->
    lib_mask_role:get_mask_name(PS).

%% 获取包装后玩家名
get_wrap_role_name(DefaultName, [MaskId]) ->
    case MaskId > 0 of
        true ->
            lib_mask_role:get_mask_name(MaskId);
        _ ->
            DefaultName
    end.

%% 获取击杀者展示名
get_killer_show_name([AttName, MaskId], Scene) ->
    if
        MaskId == 0 -> AttName;
        true ->
            case is_need_wrap_name_scene(Scene) of
                true ->
                    get_wrap_role_name(AttName, [MaskId]);
                _ -> AttName
            end
    end.

is_need_wrap_name_scene(SceneId) ->
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    WrapSceneTypeList = [
        ?SCENE_TYPE_NEW_OUTSIDE_BOSS, ?SCENE_TYPE_ABYSS_BOSS, ?SCENE_TYPE_FORBIDDEB_BOSS, ?SCENE_TYPE_KF_GREAT_DEMON,
        ?SCENE_TYPE_EUDEMONS_BOSS, ?SCENE_TYPE_KF_SANCTUARY, ?SCENE_TYPE_DOMAIN_BOSS, ?SCENE_TYPE_DECORATION_BOSS
    ],
    lists:member(SceneType, WrapSceneTypeList).

%% 修复血量
repair_hp(#player_status{scene = Scene, battle_attr = #battle_attr{hp = Hp} = BA} = Player) ->
    case lib_scene:is_outside_scene(Scene) of
        true ->
            NewHp = max(1, Hp),
            NewBA = BA#battle_attr{hp = NewHp},
            Player#player_status{battle_attr = NewBA};
        false ->
            Player
    end.


update_player_vip_boss_count(AtterId, MonSys) ->
    case MonSys == ?MON_SYS_BOSS_TYPE_VIP_PERSONAL of
        true ->
            Count = mod_counter:get_count(AtterId, ?MOD_BOSS, 10),
            mod_counter:set_count(AtterId, ?MOD_BOSS, 10, Count+1),
            lib_server_send:send_to_uid(AtterId, pt_130, 13086, [[{2, Count+1}]]);
        _ -> skip
    end.

update_enchantment_dun_count(Player) ->
    #player_status{sid = Sid, enchantment_guard = #enchantment_guard{gate = Gate}} = Player,
    lib_server_send:send_to_sid(Sid, pt_130, 13086, [[{3, Gate}]]).

gm_reset_hidetype() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [gm_reset_hidetype(E#ets_online.id)|| E <- OnlineRoles],
    ok.

gm_reset_hidetype(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_player, gm_reset_hidetype, []);
gm_reset_hidetype(Status) ->
    #player_status{scene_hide_type = HideType, dungeon = #status_dungeon{dun_id = DunId}} = Status,
    case data_dungeon:get(DunId) of
        #dungeon{type = ?DUNGEON_TYPE_PET2} -> IsOnDemonsDun = true;
        _ -> IsOnDemonsDun = false
    end,
    case IsOnDemonsDun == false andalso HideType == ?HIDE_TYPE_VISITOR of
        true ->
            {ok, Status#player_status{scene_hide_type = 0}};
        _ ->
            {ok, Status}
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 离线事件处理
db_select_offline_event_data(PlayerId) ->
    db:get_all(io_lib:format(?sql_offline_event_select, [PlayerId])).

db_replace_offline_event_data(PlayerId, ModuleId, EventId, Data, Time) ->
    db:execute(io_lib:format(?sql_offline_event_replace, [PlayerId, ModuleId, EventId, util:term_to_bitstring(Data), Time])).

db_delete_offline_event_data(PlayerId) ->
    db:execute(io_lib:format(?sql_offline_event_delete, [PlayerId])).

handle_offline_data(PS) ->
    #player_status{id = RoleId, pid = Pid} = PS,
    case db_select_offline_event_data(RoleId) of
        [] -> ok;
        DbList ->
            db_delete_offline_event_data(RoleId),
            F = fun([ModuleId, EventId, DataBin, _Time]) ->
                if
                    ModuleId == ?MOD_DEMONS andalso EventId == 1 ->
                        DataList = util:bitstring_to_term(DataBin),
                        lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, lib_demons_api, upgrade_demons_skill_process, DataList);
                    true ->
                        ok
                end
            end,
            lists:foreach(F, DbList)
    end.

% 跨服执行
send_role_figure_cls(ToNode, ToId, RoleId, ServerId, ModId) ->
    mod_clusters_center:apply_cast(ServerId, ?MODULE, send_role_figure, [ToNode, ToId, RoleId, ServerId, ModId]).

send_role_figure(ToNode, ToId, RoleId, ServerId, ModId) ->
    case lib_role:get_role_show(RoleId) of
        #ets_role_show{figure = Figure} ->
            {ok, BinData} = pt_130:write(13015, [ServerId, ModId, RoleId, Figure]),
            mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [ToNode, ToId, BinData]);
        _ ->
            skip
    end.

%% 获取角色的模块战力 依次为：
%% 第一个版本：装备->影装->坐骑->侍魂->神纹->御魂
%% 第二版本：共鸣 御魂 羽翼 神兵 御守 蜃妖 降神
ta_get_module_power(Player) ->
    #player_status{
        status_mount = MountStatus, goods = Goods,  original_attr = OriginalAttr,
        figure = #figure{ lv = RoleLv }, eudemons = Eudemons,
        god = GodStatus, mon_pic = MonPic
    } = Player,
    ModuleL = [?MOD_EQUIP, ?MOD_SEAL, ?MOD_RUNE],
    ModulePowerList = get_module_power(Player, ModuleL),
    %% 坐骑、侍魂战力
    MountTypePowerL = [{MountType, TypePower} || #status_mount{ type_id = MountType, combat = TypePower } <- MountStatus],
    List = [{mount_power, MountTypePowerL}|ModulePowerList],
    %% 神纹战力
    DivineRunePower = lib_dragon:loo_over_calc_dragon_real_power(Player, [], lib_goods_do:get_goods_status()),
    %% 共鸣战力
    EquipSuitAttr = Goods#status_goods.equip_suit_attr,
    [EquipSuitPower|_] = pp_goods:get_count_attrlist_power([EquipSuitAttr], RoleLv),
    %% 蜃妖战力(这里自取总积分)
    Fun = fun( #eudemons_item{ state = State, score = OneScore}, SumMirage) ->
        case State == ?EUDEMONS_STATE_SLEEP orelse State == ?EUDEMONS_STATE_ACTIVE of
            true -> SumMirage;
            _ -> SumMirage + OneScore
        end
    end,
    MiragePower = lists:foldl(Fun, 0, Eudemons#eudemons_status.eudemons_list),
    %% 降神战力
    SeancePower = lib_god:get_all_god_power(GodStatus, OriginalAttr),
    %% 怪物图鉴战力
    MonPicAttr = MonPic#status_mon_pic.attr,
    MonPicPower= calc_partial_power(OriginalAttr, 0, MonPicAttr),
    [{?MOD_DRAGON, DivineRunePower}] ++ [{?MOD_RESONANCE_POWER, EquipSuitPower}] ++ [{?MOD_EUDEMONS, MiragePower}] ++
    [{?MOD_GOD, SeancePower}] ++ [{?MOD_MON_PIC, MonPicPower}] ++ List.


%% 计算觉醒部分的防具等战力实际的加成
calc_other_equip_awake_attr(Player, AwakeAttrL) ->
    #player_status{id = PlayerId} = Player,
    Fun = fun({AttrId, Value}, {AccSpecialL, AccNormalL}) ->
        case lists:member(AttrId, ?EQUIP_ADD_RATIO_TYPE) of
            true ->
                {[{AttrId, Value}|AccSpecialL], AccNormalL};
            false ->
                {AccSpecialL, [{AttrId, Value}|AccNormalL]}
        end
    end,
    {SpecialAttrL, NormalAttrL} = lists:foldl(Fun, {[], []}, AwakeAttrL),
    case SpecialAttrL of
        [] ->
            NormalAttrL;
        _ ->
            GS = lib_goods_do:get_goods_status(),
            #goods_status{dict = GoodsDict} = GS,
            EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
            #{?EQUIP_TYPE_WEAPON := WeaponL, ?EQUIP_TYPE_ARMOR := ArmorL, ?EQUIP_TYPE_ORNAMENT := OrnamentL} = data_goods:classify_euqip(EquipList),
            WeaponAttr = data_goods:count_goods_attribute(WeaponL),
            ArmorAttr = data_goods:count_goods_attribute(ArmorL),
            OrnamentAttr = data_goods:count_goods_attribute(OrnamentL),
            NewWeaponAttr = ulists:kv_list_plus_extra([SpecialAttrL, WeaponAttr]),
            NewArmorAttr = ulists:kv_list_plus_extra([SpecialAttrL, ArmorAttr]),
            NewOrnamentAttr = ulists:kv_list_plus_extra([SpecialAttrL, OrnamentAttr]),
            LastWeaponAttr = lib_rune:count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, NewWeaponAttr),
            LastArmorAttr = lib_rune:count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, NewArmorAttr),
            LastOrnamentAttr = lib_rune:count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, NewOrnamentAttr),
            util:combine_list(LastWeaponAttr ++ LastArmorAttr ++ LastOrnamentAttr ++ NormalAttrL)
    end.