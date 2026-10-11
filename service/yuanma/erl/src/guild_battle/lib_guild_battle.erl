%%%--------------------------------------
%%% @Module  : lib_guild_battle
%%% @Author  : zengzy 
%%% @Created : 2017-10-03
%%% @Description:  公会战（大乱斗）
%%%--------------------------------------
-module(lib_guild_battle).

-include("server.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("guild_battle.hrl").
-include("goods.hrl").
-include("language.hrl").
-include("activitycalen.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("buff.hrl").

-compile(export_all).

%%玩家登陆
login(PS) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId, position = Position}} = PS,
    case GuildId > 0 of 
        true ->
            case db_winner_select_with_key(GuildId) of
                [] -> GuildBattle = #guild_battle_status{};
                [GuildId, _LastWinner, WinNum] ->
                    case Position == ?POS_CHIEF of 
                        true ->
                            mod_guild_battle:role_login(RoleId, GuildId);
                        _ -> ok
                    end,
                    GuildBattle = #guild_battle_status{winner = GuildId, win_num = WinNum}
            end,
            PS#player_status{guild_battle = GuildBattle};
        _ ->
            PS#player_status{guild_battle = #guild_battle_status{}}
    end.

%%断线重连
re_login(PS,?NORMAL_LOGIN) ->
    case check_in_war(PS) of
        true-> 
            #player_status{x = X, y = Y} = PS,
            Role = make_record(role,PS),
            mod_guild_battle:login(Role, X, Y),
            {ok, PS};           
        {false, _Res} -> {next, PS}
    end;
re_login(PS,?RE_LOGIN) ->
    case check_in_war(PS) of
        true->
            #player_status{id = RoleId, guild = #status_guild{id=_GuildId}, copy_id = CopyId,x = X, y = Y} = PS,
            case misc:is_process_alive(CopyId) of
                true->
                    Role = make_record(role,PS),
                    mod_guild_battle:login(Role, X, Y);
                false->
                    lib_scene:player_change_default_scene(RoleId, []);
                {false,_Res} ->
                    lib_scene:player_change_default_scene(RoleId, []) 
            end,
            {ok, PS}; 
        {false, _Res} -> {next, PS}
    end;
re_login(PS,_) ->  {next, PS}.

%%活动主界面
send_guild_battle_show(PS) ->
    #player_status{id = RoleId, sid = Sid, guild= #status_guild{id = GuildId, create_time = CreateTime}} = PS,
    mod_guild_battle:send_guild_battle_show(GuildId,CreateTime,RoleId,Sid).

send_guild_battle_red_hot(PS) ->
    #player_status{
        id = RoleId, sid = Sid, guild= #status_guild{id = GuildId, position = Position, create_time = CreateTime}
    } = PS,
    case GuildId > 0 of 
        true -> 
            mod_guild_battle:send_guild_battle_red_hot(GuildId, RoleId, Sid, Position, CreateTime);
        _ -> ok
    end.

%领取每日奖励
get_daily_reward(PS) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId, create_time = CreateTime}} = PS,
    Now = utime:unixtime(),
    NeedTime = ?DAILYREWARD_NEEDTIME,
    case catch mod_guild_battle:is_winner(GuildId) of
        true when Now - CreateTime >= NeedTime ->
            case mod_daily:get_count(RoleId, ?MOD_GUILD_BATTLE, 1) of 
                0 ->
                    mod_daily:increment(RoleId, ?MOD_GUILD_BATTLE, 1),
                    Errcode = ?SUCCESS,
                    %% 每日福利奖励
                    [_, DailyReward] = get_battle_reward(),
                    %%加日志 
                    lib_guild_battle_fight:add_rank_log([RoleId],GuildId,DailyReward,Now),
                    %%发送奖励
                    Produce = #produce{type=guild_battle,reward=DailyReward,show_tips=3},
                    {_, NewPS} = lib_goods_api:send_reward_with_mail(PS, Produce);
                _ ->
                    Errcode = ?ERRCODE(err505_reward_is_got), NewPS = PS
            end;
        true ->
            Errcode = ?ERRCODE(err505_join_in_guild_not_enough_time_can_not_receive), NewPS = PS;
        _ -> 
            Errcode = ?ERRCODE(err505_not_winner), NewPS = PS
    end,
    {ok, BinData} = pt_505:write(50502, [Errcode]),
    lib_server_send:send_to_sid(Sid, BinData),
    NewPS.
    
enter(PS) ->
    case check_enter(PS) of
        true-> do_enter(PS);
        {false, Res} -> {false, Res}
    end.

%%进入活动
do_enter(PS)->
    Role = make_record(role,PS),
    enter_scene(PS,Role),
    {true,PS}.

%%进入场景
enter_scene(PS,Role)->
    #player_status{scene = SceneId} = PS,
    case SceneId =/= ?GUILD_BATTLE_ID of
        true ->
            case data_scene:get(?GUILD_BATTLE_ID) of 
                #ets_scene{} ->
                    mod_guild_battle:enter(Role);
                _ -> 
                    ?ERR("not find guild war match scene ", []),
                    {ok, PS}
            end;            
        false ->
            ?PRINT("enter_scene 111 ~p~n", [111]),
            {ok, PS}
    end. 

%%退出活动
quit(PS) ->
    case check_in_war(PS) of
        true->
            case lib_scene:is_transferable_out(PS) of 
                {true, _} ->
                    Role = make_record(role,PS), 
                    mod_guild_battle:quit(Role),
                    {true,PS};
                {false, Res} ->
                    {false, Res}
            end;
        {false, Res} -> {false, Res}
    end.

%% 切场景
change_scene(PS, Birth, Own, CopyId, X, Y, Group, BuffId, Enter) ->
    case Enter == true of 
        true ->
            KeyValueList = [{action_lock, ?ERRCODE(err505_in_guild_battle)}, {group, Group},{pk, {?PK_FORCE, false}}, {change_scene_hp_lim, 0}],
            NeedOut = true;
        _ ->
            KeyValueList = [{action_lock, ?ERRCODE(err505_in_guild_battle)}, {group, Group},{pk, {?PK_FORCE, false}}],
            NeedOut = false
    end,
    NewPS = lib_scene:change_scene(PS, ?GUILD_BATTLE_ID, 0, CopyId, X, Y, NeedOut, KeyValueList),
    {ok, NewPS1} = change_ps_revive(NewPS, Birth, Own),
    #player_status{guild_battle = GuildBattle} = NewPS1,
    LastPS = NewPS#player_status{guild_battle = GuildBattle#guild_battle_status{buff_id = BuffId}},
    CountPS = lib_player:count_player_attribute(LastPS),
    {ok, CountPS}.

%% 切换到主城
change_to_main(RoleList) ->
    F = fun(Id)->
        lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, lib_guild_battle, leave_scene, [])
        %lib_skill_api:del_tmp_skill_list(Id,?SKILL_ID)
    end,
    lists:map(F,RoleList).

leave_scene(PS) ->
    SceneId = 0,  
    ScenePoolId = 0,  
    CopyId = 0,     
    NeedOut = true,                                                
    {X, Y} = lib_scene:get_main_city_x_y(),
    KeyValueList = [{group,0},{action_free, ?ERRCODE(err505_in_guild_battle)},{pk,{?PK_PEACE,true}},{change_scene_hp_lim, 0}],
    NewPS = lib_scene:change_scene(PS, SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList),
    #player_status{guild_battle = GuildBattle} = NewPS,
    LastPS = NewPS#player_status{guild_battle = GuildBattle#guild_battle_status{buff_id = 0, revive_state = 0}},
    CountPS = lib_player:count_player_attribute(LastPS),
    ?PRINT("leave_scene : ~p~n", [succ]),
    {ok, CountPS}.

%%修改玩家ps的占据点
change_ps_revive(PS, Birth, Own) ->
    #player_status{guild_battle=GuildBattle} = PS,
    [KingId] = data_guild_battle:get_own_type(?KING_TYPE),
    LeftOwn = Own -- [KingId],
    NewGuildBattle = GuildBattle#guild_battle_status{own_revive = LeftOwn, birth_revive = Birth},
    % ?INFO("~p ps change~p~n",[PS#player_status.id,NewGuildBattle]),
    {ok, PS#player_status{guild_battle=NewGuildBattle}}.

%%进入走出据点
step_own_change(PS,MonId,Type) ->
    #player_status{id = RoleId, copy_id = CopyId} = PS,
    case check_in_war(PS) of
        true->
            IsAlive = misc:is_process_alive(CopyId),
            if
                IsAlive == true -> mod_guild_battle_fight:step_own_change(CopyId, RoleId, MonId, Type);
                true -> {false, ?ERRCODE(err505_is_not_open)}
            end;
        {false, Res} -> {false, Res}
    end.    

%%发送积分
% send_role_score(PS) ->
%     #player_status{id = RoleId, copy_id = CopyId} = PS,
%     case check_in_war(PS) of
%         true->
%             IsAlive = misc:is_process_alive(CopyId),
%             if
%                 IsAlive == true -> mod_guild_battle_fight:send_score(CopyId, RoleId);
%                 true -> mod_guild_battle:check_send_score(RoleId)
%             end;
%         {false, Res} -> {false, Res}
%     end.     

%%领取奖励
send_stage_reward(PS,StageId) ->
    #player_status{id = RoleId, sid = Sid, copy_id = CopyId} = PS,
    case check_in_war(PS) of
        true-> 
            IsExits = check({is_stage,StageId}),
            if
                IsExits == true -> 
                    Res =  misc:is_process_alive(CopyId),
                    ?IF(
                        Res == true,
                        mod_guild_battle_fight:send_stage_reward(CopyId, StageId, RoleId),
                        lib_guild_battle_fight:send_to_all(50509,#{RoleId => #role{role_id = RoleId, sid = Sid}}, [?ERRCODE(err505_is_not_open),StageId])
                    );
                true -> lib_guild_battle_fight:send_to_all(50509, #{RoleId => #role{role_id = RoleId, sid = Sid}}, [?ERRCODE(err505_cfg_error),StageId])
            end;
        {false, Res} -> 
            lib_guild_battle_fight:send_to_all(50509, #{RoleId => #role{role_id = RoleId, sid = Sid}}, [Res,StageId])        
    end.

%%使用战场技能
% use_battle_skill(PS) ->
%     #player_status{id = RoleId, copy_id = CopyId} = PS,
%     case check_in_war(PS) of
%         true-> 
%             IsAlive = misc:is_process_alive(CopyId),
%             if
%                 IsAlive == true -> mod_guild_battle_fight:use_battle_skill(CopyId,RoleId);
%                 true -> lib_guild_battle_fight:send_to_all(50510,[RoleId],[?ERRCODE(err505_is_not_open)]) 
%             end;
%         {false, Res} -> 
%             lib_guild_battle_fight:send_to_all(50510,[RoleId],[Res])        
%     end.    

%% 检查复活
check_revive(PS, Type) ->
    case Type == ?REVIVE_GUILD_BATTLE of
        true -> 
            case check_in_war(PS) of
                true -> true;
                _ -> {false, 10}
            end;
        false ->
            true
    end.

%%安全复活
revive(PS,?REVIVE_GUILD_BATTLE)->
    #player_status{guild_battle = GuildBattle, x = RoleX, y = RoleY} = PS,
    #guild_battle_status{own_revive = Own, birth_revive = Birth} = GuildBattle,
    ReviveRef = get({guild_battle_revive_ref}),
    util:cancel_timer(ReviveRef),
    if
        Own =/= [] ->
            F = fun(OwnerId, List) ->
                #base_guild_battle_own{location=Location} = data_guild_battle:get_own(OwnerId),
                {X,Y} = urand:list_rand(Location),
                Distance = umath:distance({RoleX, RoleY}, {X, Y}),
                [{Distance, X, Y}|List]
            end,
            DistanceList = lists:foldl(F, [], Own),
            [{_, X, Y}|_] = lists:keysort(1, DistanceList);
        Birth =/= 0 ->
            #base_guild_battle_birth{location=Location} = data_guild_battle:get_birth_and_mon(Birth),
            [{Xmin,Xmax},{Ymin,Ymax}] = Location,
            X = urand:rand(Xmin,Xmax),
            Y = urand:rand(Ymin,Ymax);
        true->
            case data_scene:get(?GUILD_BATTLE_ID) of 
                #ets_scene{x = X,y = Y} -> ok;
                _ -> 
                    ?ERR("guild battle revive~n ", []),
                    X = 0, 
                    Y = 0
            end         
    end,
    {X, Y}.

%% 霸主奖励和每日福利
get_battle_reward() ->
    WorldLv = util:get_world_lv(),
    data_guild_battle:get_battle_reward(WorldLv).

add_guild_chief_buff(GuildId) ->
    ChiefId = mod_guild:get_guild_chief(GuildId),
    add_chief_buff(ChiefId).

delete_guild_chief_buff(GuildId) ->
    ChiefId = mod_guild:get_guild_chief(GuildId),
    delete_chief_buff(ChiefId).

add_chief_buff(RoleId) ->
    lib_goods_buff:add_goods_buff(RoleId, ?SKILL_BUFF_ID, 1, []).
  
delete_chief_buff(RoleId) ->  
    lib_goods_buff:remove_goods_buff_by_type(RoleId, ?BUFF_GWAR_DOMINATOR, ?HAND_OFFLINE).

%% 检测参加条件
check_enter(PS)->
    #player_status{guild = #status_guild{id=GuildId},figure = #figure{lv = Lv}, scene = _SceneId, copy_id = _CopyId, x = _X, y = _Y} = PS,
    CheckList = [
        {check_lv, Lv},
        {check_guild, GuildId},
        {check_area, PS},                               %检测是否在可进去区域
        {check_activity_is_open} %检测活动是否开启
    ],
    case checklist(CheckList) of 
        true -> true;
        {false, Res} -> {false, Res}
    end.

%% 检测是否在活动
check_in_war(PS) ->
    #player_status{scene = SceneId,  copy_id = _CopyId} = PS,
    case SceneId == ?GUILD_BATTLE_ID of 
        true ->
            true;
        false -> 
            {false,?ERRCODE(err505_not_in_battle)}  %% 提示不在活动内
    end.

make_record(role,PS)->
    Now = utime:unixtime(),
    #player_status{
        id = RoleId, 
        sid = Sid,
        platform = Platform,
        server_num = ServerNum,
        guild = #status_guild{id=GuildId, name = GuildName},
        figure = Figure
    } = PS,
    #figure{name=Name, sex=Sex, realm=Realm, career=Career, lv=Lv, picture=Picture, picture_ver=PictureVer} = Figure,
    WarFigure = #war_figure{
        sex=Sex, realm=Realm, career=Career, lv=Lv, picture=Picture, picture_ver=PictureVer
    },
    #role{
        role_id = RoleId,
        sid = Sid,
        name = Name,
        guild_id = GuildId,
        guild_name = GuildName,
        platform = Platform,
        server_num = ServerNum,
        war_figure = WarFigure,
        enter_time = Now            
    }. 

%%获取场景id
get_scene_id()-> ?GUILD_BATTLE_ID.

revive_auto(PS) ->
    put({guild_battle_revive_ref}, none),
    {_Code, NewPS} = lib_revive:revive(PS, ?REVIVE_GUILD_BATTLE),
    NewPS.

%%--------------------------------------- 检测函数 -----------------------------
%% 检测
checklist([]) -> true;
checklist([H|T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.

check({check_lv, Lv}) ->
    case Lv >= ?open_lv of 
        true -> true;
        false -> {false, ?ERRCODE(err505_lv_not_enough)} 
    end;    
check({check_guild, GuildId}) ->
    case GuildId > 0 of 
        true -> true;
        false -> {false, ?ERRCODE(err505_no_guild)} 
    end;
check({check_activity_is_open}) ->
    case mod_guild_battle:check_open() of 
        true -> true;
        false -> {false, ?ERRCODE(err505_is_not_open)}   
    end;
check({check_area,PS}) ->
    case lib_player_check:check_list(PS, [action_free, is_transferable]) of
        true ->
            true;
        {false, ErrCode} ->
            {false, ErrCode}
    end;
check({is_stage,StageId}) ->
    List = data_guild_battle:get_all_role_reward(),
    case lists:member(StageId,List) of
        true-> true;
        false -> {false,?ERRCODE(err505_cfg_error)} 
    end;   
check(_Other) ->
    true.

%%--------------------------------------- db函数 -----------------------------


db_guild_rank_select() ->
    Sql = io_lib:format(?sql_guild_rank_select,[]),
    db:get_all(Sql).   

db_role_rank_select() ->
    Sql = io_lib:format(?sql_role_rank_select,[]),
    db:get_all(Sql).    

db_insert_guild_rank([]) -> ok;
db_insert_guild_rank(RankList) ->
    SqlArgs = [[GuildId, GuildRank, util:fix_sql_str(GuildName), ChiefId, GuildScore, PowerRank, util:term_to_bitstring(Own)] || {GuildId, GuildRank, GuildName, ChiefId, _ChiefName, GuildScore, PowerRank, Own} <- RankList],
    Sql = usql:replace(guild_battle_rank, [guild_id, rank, guild_name, chief_id, score, power_rank, own], SqlArgs),
    db:execute(Sql).

db_guild_rank_delete() ->
    Sql = io_lib:format(?sql_guild_rank_delete,[]),
    db:execute(Sql).  

db_role_rank_delete() ->
    Sql = io_lib:format(?sql_role_rank_delete,[]),
    db:execute(Sql). 

db_insert_role_rank([]) -> ok;
db_insert_role_rank(RankList) ->
    SqlArgs = [[RoleId, GuildId, Score, KillNum, Rank] || {RoleId, _RoleName, GuildId, _GuildName, Score, KillNum, Rank} <- RankList],
    Sql = usql:replace(guild_battle_role_rank, [role_id, guild_id, score, kill_num, rank], SqlArgs),
    db:execute(Sql).

db_winner_replace(State) ->
    #guild_battle_state{winner = Winner, last_winner = LastWinner, win_num = WinNum, reward_type = RewardType, reward_key = RewardKey, reward_owner = RewardOwner} = State,
    db_winner_delete(),
    Sql = io_lib:format(?sql_guild_battle_result_insert, [Winner, LastWinner, WinNum, RewardType, RewardKey, RewardOwner]),
    db:execute(Sql).

db_winner_delete() ->
    db:execute(io_lib:format(?sql_guild_battle_result_delete, [])).

db_winner_select() ->
    Sql = io_lib:format(?sql_guild_battle_result_select, []),
    db:get_row(Sql).

db_winner_select_with_key(Winner) ->
    Sql = io_lib:format(?sql_guild_battle_result_select_with_key, [Winner]),
    db:get_row(Sql).