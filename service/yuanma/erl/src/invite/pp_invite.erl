%% ---------------------------------------------------------------------------
%% @doc pp_invite.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-11-01
%% @deprecated 邀请
%% ---------------------------------------------------------------------------
-module(pp_invite).
-export([handle/3]).

-include("server.hrl").

%% 好友求助信息
handle(34001, Player, []) ->
    lib_invite:send_info(Player);

%% 触发邀请
handle(34002, Player, []) ->
    lib_invite:touch_invite(Player);

%% 宝箱奖励领取
handle(34003, Player, []) ->
    lib_invite:receive_box_reward(Player);

%% 奖励领取
handle(34004, Player, [Type, RewardId]) ->
    lib_invite:receive_reward(Player, Type, RewardId);

%% 帮助信息界面
handle(34005, Player, []) ->
    mod_invite:send_help_info(Player#player_status.id);

%% 升级信息界面
handle(34006, Player, []) ->
    mod_invite:send_lv_info(Player#player_status.id);

%% 等级奖励位置领取
handle(34007, Player, [Lv, Pos]) ->
    mod_invite:receive_lv_reward_pos(Player#player_status.id, Lv, Pos);

%% 等级奖励一次性领取信息
handle(34008, Player, [Lv]) ->
    mod_invite:send_lv_reward_once_info(Player#player_status.id, Lv);

%% 等级奖励一次性领取
handle(34009, Player, [Lv]) ->
    mod_invite:receive_lv_reward_once(Player#player_status.id, Lv);

% %% 红包领取信息
% handle(34010, Player, []) ->
%     mod_invite:send_red_packet_list(Player#player_status.id);

% %% 红包领取
% handle(34011, Player, [InviteeId]) ->
%     mod_invite:receive_red_packet(Player#player_status.id, InviteeId);

%% 邀请奖励信息
handle(34012, Player, [Type]) ->
    lib_invite:send_reward_info(Player, Type);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.