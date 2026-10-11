%% ---------------------------------------------------------------------------
%% @doc lib_invite_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-11-14
%% @deprecated 邀请
%% ---------------------------------------------------------------------------
-module(lib_invite_mod).
-compile([export_all]).

-include("invite.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("goods.hrl").

%% 初始化
init() ->
    DbInviteList = db_invite_select(),
    F = fun([RoleId, LvListBin, IsInvitee]) ->
        LvList = util:bitstring_to_term(LvListBin),
        #invite{role_id = RoleId, lv_list = LvList, is_invitee = IsInvitee}
    end,
    InviteList = lists:map(F, DbInviteList),
    DbRoleList = db_invitee_role_select(),
    F2 = fun([RoleId, InviteeId, Pos, Name, Lv, Career, Sex, Time]) ->
        #invitee_role{
            role_id = RoleId, invitee_id = InviteeId, pos = Pos, name = Name, lv = Lv,
            career = Career, sex = Sex, time = Time
            }
    end,
    RoleList = lists:map(F2, DbRoleList),
    DbRechargeList = db_invitee_recharge_select(),
    F3 = fun([RoleId, InviteeId, Name, Gold, GetGold, LastGetGold, Time]) ->
        #invitee_recharge{
            role_id = RoleId, invitee_id = InviteeId, name = Name, gold = Gold, 
            get_gold = GetGold, last_get_gold = LastGetGold, time = Time
        }
    end,
    RechargeList = lists:map(F3, DbRechargeList),
    InviteListAfRole = pack_role_to_invite(RoleList, InviteList), 
    InviteListAfRecharge = pack_recharge_to_invite(RechargeList, InviteListAfRole),
    InviteMap = maps:from_list([{RoleId, Invite}||#invite{role_id = RoleId}=Invite<-InviteListAfRecharge]),
    #invite_state{invite_map = InviteMap}.

%% 打包玩家
pack_role_to_invite([], InviteList) ->
    [Invite#invite{role_list = sort_role_list(RoleList)}||#invite{role_list = RoleList}=Invite<-InviteList];
pack_role_to_invite([#invitee_role{role_id = RoleId} = Role|T], InviteList) ->
    case lists:keyfind(RoleId, #invite.role_id, InviteList) of
        false -> Invite = #invite{role_id = RoleId, role_list = [Role]};
        #invite{role_list = RoleList} = OldInvite -> Invite = OldInvite#invite{role_list = [Role|RoleList]}
    end,
    NewInviteList = lists:keystore(RoleId, #invite.role_id, InviteList, Invite),
    pack_role_to_invite(T, NewInviteList).

%% 打包充值
pack_recharge_to_invite([], InviteList) -> 
    [Invite#invite{recharge_list = sort_recharge_list(RechargeList)}||#invite{recharge_list = RechargeList}=Invite<-InviteList];
pack_recharge_to_invite([#invitee_recharge{role_id = RoleId} = Recharge|T], InviteList) ->
    case lists:keyfind(RoleId, #invite.role_id, InviteList) of
        false -> Invite = #invite{role_id = RoleId, recharge_list = [Recharge]};
        #invite{recharge_list = RechargeList} = OldInvite -> Invite = OldInvite#invite{recharge_list = [Recharge|RechargeList]}
    end,
    NewInviteList = lists:keystore(RoleId, #invite.role_id, InviteList, Invite),
    pack_recharge_to_invite(T, NewInviteList).

% make_invite_map([], InviteList) ->
%     F = fun(#invite{role_id = RoleId, role_list = RoleList} = Invite) ->
%         SortRoleList = sort_role_list(RoleList),
%         {RoleId, Invite#invite{role_list = SortRoleList}}
%     end,
%     maps:from_list(lists:map(F, InviteList));
% make_invite_map([#invitee_role{role_id = RoleId} = Role|T], InviteList) ->
%     case lists:keyfind(RoleId, #invite.role_id, InviteList) of
%         false -> Invite = #invite{role_id = RoleId, lv_list = [], is_invitee = 0, role_list = [Role]};
%         #invite{role_list = RoleList} = OldInvite -> Invite = OldInvite#invite{role_list = [Role|RoleList]}
%     end,
%     NewInviteList = lists:keystore(RoleId, #invite.role_id, InviteList, Invite),
%     make_invite_map(T, NewInviteList).

sort_role_list(RoleList) ->
    lists:keysort(#invitee_role.pos, RoleList).

%% 排序充值列表
sort_recharge_list(RechargeList) -> 
    F = fun(#invitee_recharge{gold = Gold, get_gold = GetGold}) -> GetGold < Gold end,
    {Satisfying, NotSatisfying} = lists:partition(F, RechargeList),
    SortSatisfying = lists:keysort(#invitee_recharge.time, Satisfying),
    SortNotSatisfying = lists:keysort(#invitee_recharge.time, NotSatisfying),
    SortSatisfying++SortNotSatisfying.

%% -----------------------------------------------------------------
%% 进程间处理
%% -----------------------------------------------------------------

%% 设置成被邀请者,需要上传数据
set_new_inivtee(State, InviteeId) ->
    #invite_state{invite_map = InviteMap} = State,
    case maps:find(InviteeId, InviteMap) of
        error -> Invite = #invite{role_id = InviteeId, is_invitee = 1};
        {ok, OldInvite} -> Invite = OldInvite#invite{is_invitee = 1}
    end,
    NewInviteMap = maps:put(InviteeId, Invite, InviteMap),
    NewState = State#invite_state{invite_map = NewInviteMap},
    {noreply, NewState}.

%% 上传被邀请者信息到php
upload_inivtee_info(State, InviteeId, Args) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{is_invitee = IsInvitee} = maps:get(InviteeId, InviteMap, #invite{}),
    case IsInvitee == 1 of
        true -> erlang:apply(lib_php_api, request, Args);
        false -> skip
    end,
    ok.

%% 上传被邀请者充值到php,只更新数据,没有就不处理
upload_inivtee_recharge(State, InviteeId, Args) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{is_invitee = IsInvitee} = maps:get(InviteeId, InviteMap, #invite{}),
    case IsInvitee == 1 of
        true -> erlang:apply(lib_php_api, request, Args);
        false -> skip
    end,
    ok.

%% 更新邀请状态
update_invite_state(State, RoleId, LvList, IsInvitee, PhpRoleList, PhpRechargeList) ->
    % role_list
    F = fun({InviteeId, Pos, Name, Lv, Career, Sex, Time}) ->
        #invitee_role{
            role_id = RoleId, invitee_id = InviteeId, pos = Pos, name = Name, lv = Lv,
            career = Career, sex = Sex, time = Time
            }
    end,
    RoleList = lists:map(F, PhpRoleList),
    db_invitee_role_delete(RoleId),
    db_invitee_role_batch(RoleList),
    % ?PRINT("update_invite_state LvList:~p, IsInvitee:~p, PhpRoleList:~p ~#invitee_recharge.invitee_id", [LvList, IsInvitee, PhpRoleList]),
    #invite_state{invite_map = InviteMap} = State,
    #invite{recharge_list = RechargeList} = Invite = maps:get(RoleId, InviteMap, #invite{role_id = RoleId}),
    % recharge_list
    NowTime = utime:unixtime(),
    F2 = fun({InviteeId, Name, Gold}, {TmpRechargeList, ToDbList}) ->
        case lists:keyfind(InviteeId, #invitee_recharge.invitee_id, TmpRechargeList) of
            false -> 
                Recharge = #invitee_recharge{role_id = RoleId, invitee_id = InviteeId, name = Name, gold = Gold, time = NowTime},
                {[Recharge|TmpRechargeList], [Recharge|ToDbList]};
            #invitee_recharge{name = OldName, gold = OldGold} = OldRecharge ->
                case Name == OldName andalso Gold == OldGold of
                    true -> {TmpRechargeList, ToDbList};
                    false ->
                        Recharge = OldRecharge#invitee_recharge{name = Name, gold = Gold},
                        NewToDbList = ?IF(Recharge==OldRecharge, ToDbList, [Recharge|ToDbList]),
                        {lists:keystore(InviteeId, 1, TmpRechargeList, Recharge), NewToDbList}
                end
        end
    end,
    {NewRechargeList, ToDbList} = lists:foldl(F2, {RechargeList, []}, PhpRechargeList),
    db_invitee_recharge_batch(ToDbList),
    SortRechargeList = sort_recharge_list(NewRechargeList),
    NewInvite = Invite#invite{lv_list = LvList, is_invitee = IsInvitee, role_list = RoleList, recharge_list = SortRechargeList},
    db_invite_replace_with_check(NewInvite, Invite),
    NewInviteMap = maps:put(RoleId, NewInvite, InviteMap),
    NewState = State#invite_state{invite_map = NewInviteMap},
    {noreply, NewState}.

%% -----------------------------------------------------------------
%% 玩家请求
%% -----------------------------------------------------------------

%% 奖励领取
receive_reward(State, RoleId, Type, RewardId) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{lv_list = LvList} = maps:get(RoleId, InviteMap, #invite{}),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_invite, receive_reward, [Type, RewardId, LvList]),
    ok.

%% 帮助信息界面
send_help_info(State, RoleId) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{lv_list = LvList, role_list = RoleList} = maps:get(RoleId, InviteMap, #invite{}),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_invite, send_help_info, [LvList, RoleList]),
    ok.

%% 升级信息界面
send_lv_info(State, RoleId) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{role_list = RoleList} = maps:get(RoleId, InviteMap, #invite{}),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_invite, send_lv_info, [RoleList]),
    ok.   

%% 等级奖励位置领取
receive_lv_reward_pos(State, RoleId, Lv, Pos) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{role_list = RoleList} = maps:get(RoleId, InviteMap, #invite{}),
    case lists:keyfind(Pos, #invitee_role.pos, RoleList) of
        false -> CheckRoleList = [];
        Role -> CheckRoleList = [Role]
    end,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_invite, receive_lv_reward_pos, [Lv, Pos, CheckRoleList]),
    ok.

%% 等级奖励一次性领取信息
send_lv_reward_once_info(State, RoleId, Lv) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{lv_list = LvList} = maps:get(RoleId, InviteMap, #invite{}),
    case lists:keyfind(Lv, 1, LvList) of
        false -> TotalCount = 0;
        {Lv, TotalCount} -> ok
    end,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_invite, send_lv_reward_once_info, [Lv, TotalCount]),
    ok.

%% 等级奖励一次性领取
receive_lv_reward_once(State, RoleId, Lv) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{lv_list = LvList} = maps:get(RoleId, InviteMap, #invite{}),
    case lists:keyfind(Lv, 1, LvList) of
        false -> TotalCount = 0;
        {Lv, TotalCount} -> ok
    end,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_invite, receive_lv_reward_once, [Lv, TotalCount]),
    ok.

%% 红包领取信息
send_red_packet_list(State, RoleId) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{recharge_list = RechargeList} = maps:get(RoleId, InviteMap, #invite{}),
    F = fun(#invitee_recharge{gold = Gold, get_gold = GetGold}) -> GetGold < Gold end,
    {Satisfying, _NotSatisfying} = lists:partition(F, RechargeList),
    RedPacketLen = ?INVITE_KV_RED_PACKET_LEN,
    case length(Satisfying) >= RedPacketLen of
        true -> SubList = Satisfying;
        false -> SubList = lists:sublist(RechargeList, RedPacketLen)
    end,
    F2 = fun(#invitee_recharge{invitee_id = InviteeId, name = Name, gold = Gold, get_gold = GetGold, last_get_gold = LastGetGold}) ->
        LeftGold = max(Gold-GetGold, 0),
        {InviteeId, Name, LeftGold, LastGetGold}
    end,
    ClientL = lists:map(F2, SubList),
    % ?PRINT("send_red_packet_list RechargeList:~p ClientL:~p ~n", [RechargeList, ClientL]),
    {ok, BinData} = pt_340:write(34010, [ClientL]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 红包领取
receive_red_packet(State, RoleId, InviteeId) ->
    case check_receive_red_packet(State, RoleId, InviteeId) of
        {false, ErrCode} -> lib_invite:send_error_code(RoleId, 34011, ErrCode);
        {true, Recharge, Gold, DiffGold, Reward} ->
            #invite_state{invite_map = InviteMap} = State,
            #invite{recharge_list = RechargeList} = Invite = maps:get(RoleId, InviteMap),
            NewRecharge = Recharge#invitee_recharge{get_gold = Gold, last_get_gold = DiffGold, time = utime:unixtime()},
            db_invitee_recharge_batch([NewRecharge]),
            NewRechargeList = lists:keyreplace(InviteeId, #invitee_recharge.invitee_id, RechargeList, NewRecharge),
            SortRechargeList = sort_recharge_list(NewRechargeList),
            NewInvite = Invite#invite{recharge_list = SortRechargeList},
            NewInviteMap = maps:put(RoleId, NewInvite, InviteMap),
            NewState = State#invite_state{invite_map = NewInviteMap},
            Remark = lists:concat(["InviteeId:", "InviteeId", ",Gold:", Gold, ",DiffGold:", DiffGold]),
            Produce = #produce{type = invite_red_packet, subtype = InviteeId, reward = Reward, remark = Remark, show_tips = ?SHOW_TIPS_3},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            {ok, BinData} = pt_340:write(34011, [InviteeId, Reward]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, NewState}
    end.

check_receive_red_packet(_State, RoleId, RoleId) -> {false, ?FAIL};
check_receive_red_packet(State, RoleId, InviteeId) ->
    #invite_state{invite_map = InviteMap} = State,
    #invite{recharge_list = RechargeList} = maps:get(RoleId, InviteMap, #invite{}),
    case lists:keyfind(InviteeId, #invitee_recharge.invitee_id, RechargeList) of
        false -> {false, ?ERRCODE(err340_invitee_not_recharge)};
        #invitee_recharge{gold = Gold, get_gold = GetGold} when GetGold >= Gold -> {false, ?ERRCODE(err340_invitee_recharge_had_receive)};
        #invitee_recharge{gold = Gold, get_gold = GetGold} = Recharge ->
            DiffGold = Gold - GetGold,
            F = fun
                ({Type, GoodsTypeId, Ratio}) -> {Type, GoodsTypeId, round(Ratio*DiffGold)};
                (T) -> T
            end,
            Reward = lists:map(F, ?INVITE_KV_RED_PACKET_REWARD),
            {true, Recharge, Gold, DiffGold, Reward}
    end.

%% -----------------------------------------------------------------
%% 数据库
%% -----------------------------------------------------------------

%% 获取邀请
db_invite_select() ->
    Sql = io_lib:format(?sql_invite_select, []),
    db:get_all(Sql).

%% 保存邀请(减少存储)
db_invite_replace_with_check(Invite, OldInvite) ->
    #invite{lv_list = LvList, is_invitee = IsInvitee} = Invite,
    #invite{lv_list = OldLvList, is_invitee = OldIsInvitee} = OldInvite,
    case LvList == OldLvList andalso IsInvitee == OldIsInvitee of
        true -> skip;
        false -> db_invite_replace(Invite)
    end.

%% 保存邀请
db_invite_replace(Invite) ->
    #invite{role_id = RoleId, lv_list = LvList, is_invitee = IsInvitee} = Invite,
    LvListBin = util:term_to_bitstring(LvList),
    Sql = io_lib:format(?sql_invite_replace, [RoleId, LvListBin, IsInvitee]),
    db:execute(Sql).

%% 获得被邀请玩家信息
db_invitee_role_select() ->
    Sql = io_lib:format(?sql_invitee_role_select, []),
    db:get_all(Sql).

%% 保存被邀请玩家信息(批量存储)
db_invitee_role_batch(Ranks) ->
    SubSQL = splice_invitee_role_sql(Ranks, []),
    case SubSQL == [] of
        true -> skip;
        false ->
            SQL = string:join(SubSQL, ", "),
            NSQL = io_lib:format(?sql_invitee_role_batch, [SQL]),
            db:execute(NSQL)
    end,
    ok.

splice_invitee_role_sql([], UpdateSQL) -> UpdateSQL;
splice_invitee_role_sql([Rank | Rest], UpdateSQL) ->
    #invitee_role{
        role_id = RoleId,
        invitee_id = InviteeId,
        pos = Pos,
        name = Name,
        lv = Lv,
        career = Career,
        sex = Sex,
        time = Time
    } = Rank,
    NameBin = util:fix_sql_str(Name),
    SQL = io_lib:format(?sql_invitee_role_values, [RoleId, InviteeId, Pos, NameBin, Lv, Career, Sex, Time]),
    splice_invitee_role_sql(Rest, [SQL | UpdateSQL]).

%% 删除指定邀请者的所有信息
db_invitee_role_delete(RoleId) ->
    Sql = io_lib:format(?sql_invitee_role_delete, [RoleId]),
    db:execute(Sql).

%% 获得被邀请玩家充值信息
db_invitee_recharge_select() ->
    Sql = io_lib:format(?sql_invitee_recharge_select, []),
    db:get_all(Sql).

%% 保存被邀请玩家充值信息(批量存储)
db_invitee_recharge_batch(Ranks) ->
    SubSQL = splice_invitee_recharge_sql(Ranks, []),
    case SubSQL == [] of
        true -> skip;
        false ->
            SQL = string:join(SubSQL, ", "),
            NSQL = io_lib:format(?sql_invitee_recharge_batch, [SQL]),
            db:execute(NSQL)
    end,
    ok.

splice_invitee_recharge_sql([], UpdateSQL) -> UpdateSQL;
splice_invitee_recharge_sql([Rank | Rest], UpdateSQL) ->
    #invitee_recharge{
        role_id = RoleId,
        invitee_id = InviteeId,
        name = Name,
        gold = Gold,
        get_gold = GetGold,
        last_get_gold = LastGetGold,
        time = Time
    } = Rank,
    NameBin = util:fix_sql_str(Name),
    SQL = io_lib:format(?sql_invitee_recharge_values, [RoleId, InviteeId, NameBin, Gold, GetGold, LastGetGold, Time]),
    splice_invitee_recharge_sql(Rest, [SQL | UpdateSQL]).
