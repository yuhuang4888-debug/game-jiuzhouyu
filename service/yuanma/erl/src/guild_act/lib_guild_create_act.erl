%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_create_act.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-15
%% @Description:    勇者盟约活动
%%-----------------------------------------------------------------------------

-module (lib_guild_create_act).
-include ("custom_act.hrl").
-include ("guild_create_act.hrl").
-include ("guild.hrl").
-include ("server.hrl").
-include ("errcode.hrl").
-include ("common.hrl").

-export ([
    calc_reward_status/2
    ,calc_receive_times/2
    ,send_reward_status/2
    ,get_guild_info_for_reward_status/2
    ,receive_reward/3
    ,get_guild_info_for_reward/5
    ,check_reward_conditions/3
    ,reward_has_got/4
    ,update_act_reward_status/1
    ]).

%% 获取公会的领取奖励信息
send_reward_status(Player, _ActInfo) ->
    #player_status{guild = #status_guild{id = GuildId}, id = RoleId} = Player,
    if
        GuildId =:= 0 ->
            %% [RoleId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv]
            Args = [RoleId, 0, 0, 0, 0, 0],
            mod_guild_create_act:get_reward_status(Args);
        true ->
            mod_guild:apply_cast(?MODULE, get_guild_info_for_reward_status, [RoleId, GuildId])
    end.

%% 获取奖励
receive_reward(#player_status{id = RoleId} = Player, SubType, GradeId) ->
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_GUILD_CREAT, SubType) of
        #act_info{stime = _STime} = ActInfo ->
            case Player of
                #player_status{guild = #status_guild{id = GuildId, position = ?POS_CHIEF}} ->
                    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_GUILD_CREAT, SubType, GradeId) of
                        RewardCfg when is_record(RewardCfg, custom_act_reward_cfg) ->
                            case lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg) of
                                [_|_] = RewardList ->
                                    case lib_goods_api:can_give_goods(Player, RewardList) of
                                        true ->
                                            mod_guild:apply_cast(?MODULE, get_guild_info_for_reward, [RoleId, GuildId, SubType, GradeId, RewardList]);
                                        {false, ErrorCode} ->
                                            lib_custom_act:send_error_code(RoleId, ErrorCode)
                                    end;
                                _ ->
                                    lib_custom_act:send_error_code(RoleId, ?FAIL)
                            end;
                        _ ->
                            lib_custom_act:send_error_code(RoleId, ?FAIL)
                    end;
                _ ->
                    lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_only_president_reward))
            end;
        _ ->
            lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end.
%% ------------------------   lib_mod  -------------------------

%%  获取奖励状态
calc_reward_status(#custom_act_reward_cfg{grade = Id, condition = Conditions}, 
    #reward_check_param{role_id = RoleId, president_id = RoleId, global_info = GlobalInfo, guild_id = GuildId} = Param) ->
    case reward_has_got(GlobalInfo, RoleId, GuildId, Id) of
        true ->
            ?ACT_REWARD_HAS_GET;
        _ ->
            case check_reward_conditions(Id, Conditions, Param) of
                true ->
                    ?ACT_REWARD_CAN_GET;
                _ ->
                    ?ACT_REWARD_CAN_NOT_GET
            end
    end;

calc_reward_status(_, _) -> ?ACT_REWARD_CAN_NOT_GET.

%% 判断奖励是否已获取
reward_has_got(RewardInfos, RoleId, GuildId, GradeId) ->
    case lists:keyfind(GradeId, 1, RewardInfos) of
        {GradeId, List} ->
            lists:keyfind(RoleId, 2, List) =/= false orelse lists:keyfind(GuildId, 1, List) =/= false;
        _ ->
            false
    end.

%% 检查奖励的条件
%%  创建公会
check_reward_conditions(Id, [{create_guild,_Value}|T], #reward_check_param{role_id = RoleId, president_id = PresidentId} = Param) ->
    if
        RoleId == PresidentId ->
            check_reward_conditions(Id, T, Param);
        true ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

%% 检查副会长的数量
check_reward_conditions(Id, [{vice_count,Value}|T], #reward_check_param{vice_president_count = Count} = Param) ->
    if
        Count >= Value ->
            check_reward_conditions(Id, T, Param);
        true ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

%% 检查全服限制
check_reward_conditions(Id, [{count,Value}|T], #reward_check_param{global_info = List} = Param) ->
    TakedCount = calc_receive_times(Id, List),
    if
        TakedCount < Value ->
            check_reward_conditions(Id, T, Param);
        true ->
            {false, ?ERRCODE(err331_count_limit)}
    end;

%% 检查公会达多少人
check_reward_conditions(Id, [{member, N}|T], #reward_check_param{member_count = Count} = Param) ->
    if
        Count >= N ->
            check_reward_conditions(Id, T, Param);
        true ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

%% 检查公会等级
check_reward_conditions(Id, [{guild_lv,N}|T], #reward_check_param{guild_lv = Lv} = Param) ->
    if
        Lv >= N ->
            check_reward_conditions(Id, T, Param);
        true ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

check_reward_conditions(_, [], _) -> true. 

%% 计算收到的次数
calc_receive_times(#custom_act_reward_cfg{grade = Id}, RewardInfos) ->
    calc_receive_times(Id, RewardInfos);
calc_receive_times(Id, RewardInfos) ->
    case lists:keyfind(Id, 1, RewardInfos) of
        {Id, L} ->
            length(L);
        _ ->
            0
    end.

%% 获取进程里的奖励状态
get_guild_info_for_reward_status(RoleId, GuildId) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        #guild{chief_id = PresidentId, member_num = MemCount, lv = GuildLv} ->
            case lib_guild_data:get_guild_member_by_role_id(RoleId) of
                #guild_member{guild_id = GuildId} ->
                    Map = lib_guild_data:match_guild_member({position, GuildId, ?POS_DUPTY_CHIEF}),
                    VicePresidentCount = maps:size(Map),
                    Args = [RoleId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv],
                    mod_guild_create_act:get_reward_status(Args);
                _ ->
                    mod_guild_create_act:get_reward_status([RoleId, 0, 0, 0, 0, 0])
            end;
        _ ->
            mod_guild_create_act:get_reward_status([RoleId, 0, 0, 0, 0, 0])
    end.
            % [RoleId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv]

%% 跟新进程的奖励状态
update_act_reward_status(Guild) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_GUILD_CREAT) of
        true ->
            #guild{chief_id = PresidentId, member_num = MemCount, lv = GuildLv, id = GuildId} = Guild,
            Map = lib_guild_data:match_guild_member({position, GuildId, ?POS_DUPTY_CHIEF}),
            VicePresidentCount = maps:size(Map),
            Args = [PresidentId, GuildId, PresidentId, MemCount, VicePresidentCount, GuildLv],
            mod_guild_create_act:get_reward_status(Args);
        _ ->
            ok
    end.

%% 获取奖励
get_guild_info_for_reward(RoleId, GuildId, SubType, GradeId, RewardList) ->
    case lib_guild_data:get_guild_by_id(GuildId) of  % 根据公会id 获取公会
        #guild{chief_id = RoleId, member_num = MemCount, lv = GuildLv} ->
            Map = lib_guild_data:match_guild_member({position, GuildId, ?POS_DUPTY_CHIEF}),
            VicePresidentCount = maps:size(Map),
            Args = [RoleId, GuildId, RoleId, MemCount, VicePresidentCount, GuildLv, RewardList],
            mod_guild_create_act:get_reward(SubType, GradeId, Args);
        _ ->
            lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_only_president_reward))
    end.