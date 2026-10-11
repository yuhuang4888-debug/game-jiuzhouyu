%% ---------------------------------------------------------------------------
%% @doc pp_hi_point

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/10/12
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(pp_hi_point).

%% API
-compile([export_all]).
-include("common.hrl").
-include("server.hrl").
-include("custom_act.hrl").
-include("hi_point.hrl").
-include("figure.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("dragon.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("soul.hrl").
-include("def_fun.hrl").
-include("rec_baby.hrl").
-include("errcode.hrl").

%% 嗨点信息
handle(33300, PlayerStatus, []) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PlayerStatus,
    mod_hi_point:all_info(RoleId, Lv),
    {ok, PlayerStatus};

%% 嗨点详情
handle(33302, PlayerStatus, [?CUSTOM_ACT_TYPE_HI_POINT, SubType]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PlayerStatus,
    mod_hi_point:act_info(SubType, RoleId, Lv),
    {ok, PlayerStatus};

%% 获取奖励领取状态
handle(33303, PlayerStatus, [?CUSTOM_ACT_TYPE_HI_POINT, SubType]) ->
    #player_status{id = RoleId} = PlayerStatus,
    mod_hi_point:send_reward_status(RoleId, SubType),
    {ok, PlayerStatus};

%% 领取活动奖励
handle(33304, Player, [?CUSTOM_ACT_TYPE_HI_POINT, SubType, Grade]) when SubType == ?PERSON_SUBTYPE ->
    #player_status{id = RoleId} = Player,
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_HI_POINT, SubType, Grade) of
        #custom_act_reward_cfg{} = RewardCfg ->
            %% 走了定制活动配置
            Reward = RewardCfg#custom_act_reward_cfg.reward,
            case lib_goods_api:can_give_goods(Player, Reward) of
                true ->
                    mod_hi_point:receive_reward(Player#player_status.id, SubType, Grade, Reward);
                {false, ErrorCode} ->
                    lib_hi_point:send_error_code(RoleId, ErrorCode)
            end;
        _ ->
            lib_hi_point:send_error_code(RoleId, ?FAIL)
    end,
    {ok, Player};
handle(33304, Player, [?CUSTOM_ACT_TYPE_HI_POINT, SubType, Grade]) ->
    #player_status{id = RoleId} = Player,
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_HI_POINT, SubType, Grade) of
        #custom_act_reward_cfg{} = RewardCfg ->
            case lists:keyfind({?CUSTOM_ACT_TYPE_HI_POINT, SubType}, #act_info.key, lib_custom_act_util:get_custom_act_open_list()) of
                false ->
                    lib_hi_point:send_error_code(RoleId, ?ERRCODE(err331_act_closed));
                ActInfo ->
                    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    case lib_goods_api:can_give_goods(Player, Reward) of
                        true ->
                            mod_hi_point:receive_reward(Player#player_status.id, SubType, Grade, Reward);
                        {false, ErrorCode} ->
                            lib_hi_point:send_error_code(RoleId, ErrorCode)
                    end
            end;
        _ ->
            lib_hi_point:send_error_code(RoleId, ?ERRCODE(err_config))
    end;


handle(_Cmd, Player, _) -> {ok, Player}.

