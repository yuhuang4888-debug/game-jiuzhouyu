%% ---------------------------------------------------------------------------
%% @doc pp_role_view.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-26
%% @deprecated 角色辅助信息
%% ---------------------------------------------------------------------------
-module(pp_role_view).
-export([handle/3]).

% handle(28202, Player, [RoleId]) ->
%     lib_role:send_partner_view(Player, RoleId);

% handle(28203, Player, [RoleId, PartnerAutoId]) ->
%     lib_role:send_partner_base_info_view(Player, RoleId, PartnerAutoId);

% handle(28204, Player, [RoleId, PartnerAutoId]) ->
%     lib_role:send_partner_sec_info_view(Player, RoleId, PartnerAutoId);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.