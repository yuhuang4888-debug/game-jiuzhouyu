%% ---------------------------------------------------------------------------
%% @doc lib_mail.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-01-13
%% @deprecated 邮件
%% ---------------------------------------------------------------------------
-module(lib_mail).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("unite.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_id_create.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("mail.hrl").
-include("guild.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("language.hrl").

make_record(mail_from_db, [MailId, Type, State, Locked, SId, RId, Title, CmAttachmentBin, Timestamp, EffectSt]) ->
    Time = utime:micro_to_s(Timestamp),
    case util:bitstring_to_term(CmAttachmentBin) of
        CmAttachment when is_list(CmAttachment) -> ok;
        _ -> CmAttachment = []
    end,
    #mail{
        id = MailId
        , type = Type
        , state = State
        , locked = Locked
        , sid = SId
        , rid = RId
        , title = Title
        , content = undefined
        , cm_attachment = CmAttachment
        , timestamp = Timestamp
        , time = Time
        , effect_st = EffectSt
        , effect_et = get_effect_et(CmAttachment, State, EffectSt)
    }.

%% 配置
get_config(T) ->
    case T of
        % 有附件的邮件有效时间 20天
        attachment_effect_time -> 1728000;
        % 未读取且无附件的邮件有效时间 10天
        % not_read_and_no_attachment_effect_time -> 864000;
        % 未读取且无附件的邮件有效时间 3天
        not_read_and_no_attachment_effect_time -> 259200;
        % 读取后且没有附件的邮件有效时间 3天
        read_and_no_attachment_effect_time -> 259200;
        % 最大发放的邮件数量(防止客户端过多)
        max_send_mail_len -> 1000
    end.

%% ----------------------------------------------------
%% 内存邮件数据操作(主要是玩家进程操作)
%% ----------------------------------------------------

%% 初始话邮件的Dict到玩家进程中(玩家进程执行)
%% 注意:本函数要初始化完
init_mail_dict(RoleId) ->
    Sql = io_lib:format(?sql_mail_attr_select, [RoleId]),
    List = db:get_all(Sql),
    MailList = [make_record(mail_from_db, T)||T<-List],
    save_mail_dict(RoleId, MailList),
    NewMailList = auto_delete_mails(RoleId, MailList),
    NewMailList.

%% 重新加载邮件
reload_mail(#player_status{id = RoleId, online = Online} = Player) ->
    % ?PRINT("RoleId:~p Online:~p ~n", [RoleId, Online]),
    init_mail_dict(RoleId),
    case Online == ?ONLINE_ON of
        true -> pp_mail:handle(19001, Player, []);
        false -> skip
    end,
    {ok, Player}.

%% 保存MailList到玩家进程字典中
save_mail_dict(RoleId, MailList) ->
    case put(?P_MAIL_KEY(RoleId), MailList) of
        undefined -> MailList;
        _ -> MailList
    end.

%% 获取进程字典内容
get_mail_list_on_dict(RoleId) ->
    case get(?P_MAIL_KEY(RoleId)) of
        undefined -> init_mail_dict(RoleId);
        MailList -> MailList
    end.

%% 插入到进程字典中
add_mail_on_dict(RoleId, Mail) ->
    MailList = get_mail_list_on_dict(RoleId),
    case lists:keymember(Mail#mail.id, #mail.id, MailList) of
        true -> MailList;
        false -> save_mail_dict(RoleId, [Mail|MailList])
    end.

%% 更新邮件到进程字典中
update_mail_on_dict(RoleId, Mail) ->
    MailList = get_mail_list_on_dict(RoleId),
    NewMailList = lists:keyreplace(Mail#mail.id, #mail.id, MailList, Mail),
    save_mail_dict(RoleId, NewMailList).

%% 根据邮件id获取邮件
%% @return false | #mail{}
get_mail_by_mail_id_on_dict(RoleId, MailId) ->
    MailList = get_mail_list_on_dict(RoleId),
    lists:keyfind(MailId, #mail.id, MailList).

%% 根据邮件ids获取邮件
%% @return false | #mail{}
get_mails_by_ids_on_dict(RoleId, MailIds) ->
    MailList = get_mail_list_on_dict(RoleId),
    lists:filter(fun(OneMail) ->
        lists:member(OneMail#mail.id, MailIds)
    end, MailList).

%% 初始化时邮件数量超过阈值则自动删除
%% @return NewMailList :: [#mail{}...]
auto_delete_mails(RoleId, MailList) ->
    MaxMailLen = get_config(max_send_mail_len),
    MailLen = length(MailList),
    case MailLen < MaxMailLen of
        true -> MailList;
        false ->
            MailIds = [Id || #mail{id = Id} <- MailList],
            SortIds = lists:usort(MailIds),
            {_, RealDelIds} = delete_mail_by_mail_ids(RoleId, SortIds),
            NewMailList = [Mail || #mail{id = Id} = Mail <- MailList, lists:member(Id, RealDelIds) == false],
            NewMailList
    end.

%% 根据邮件id删除邮件
delete_mail_by_mail_id_on_dict(RoleId, MailId) ->
    MailList = get_mail_list_on_dict(RoleId),
    NewMailList = lists:keydelete(MailId, #mail.id, MailList),
    save_mail_dict(RoleId, NewMailList).

%% 根据邮件ids批量删除邮件
delete_by_mail_ids_on_dict(RoleId, DelMailIds) ->
    MailList = get_mail_list_on_dict(RoleId),
    NewMailList = do_delete_by_mail_ids_on_dict(MailList, DelMailIds, []),
    save_mail_dict(RoleId, NewMailList).

do_delete_by_mail_ids_on_dict([], _DelMailIds, Result) -> Result;
do_delete_by_mail_ids_on_dict([Mail|MailList], DelMailIds, Result) ->
    case lists:member(Mail#mail.id, DelMailIds) of
        false ->
            do_delete_by_mail_ids_on_dict(MailList, DelMailIds, Result ++ [Mail]);
        true ->
            do_delete_by_mail_ids_on_dict(MailList, DelMailIds, Result)
    end.

%% ----------------------------------------------------
%% player
%% ----------------------------------------------------

add_mail(#player_status{id = RoleId, sid = Sid}, AddMailList) ->
    F = fun(Mail) -> add_mail_on_dict(RoleId, Mail) end,
    lists:foreach(F, AddMailList),
    F2 = fun(Mail) ->
        #mail{id = MailId, type = Type, state = State, title = Title, time = Time, effect_et = EffectEt} = Mail,
        IsAttach = is_attach(Mail),
        {MailId, Type, State, Title, IsAttach, Time, EffectEt}
    end,
    List = [F2(T)||T<-AddMailList],
    {ok, BinData} = pt_190:write(19004, [List]),
    lib_server_send:send_to_sid(Sid, BinData),
    % 邮件通知
    {ok, BinData2} = pt_190:write(19008, [?SUCCESS]),
    lib_server_send:send_to_sid(Sid, BinData2),
    ok.

%% 是否有附件
is_attach(#mail{cm_attachment = []}) -> 0;
is_attach(#mail{state = ?MAIL_STATE_HAS_RECEIVE}) -> 0;
is_attach(_) -> 1.

%% 获取信件
get_mail(RoleId, MailId) ->
    Mail = get_mail_by_mail_id_on_dict(RoleId, MailId),
    case Mail of
        false -> {false, ?ERRCODE(err190_no_mail)};
        % 信件内容尚未加载
        #mail{type = MailType, sid = Sid, sname = CurSName, content = undefined} ->
            case db:get_row(io_lib:format(?sql_mail_content_select, [MailId])) of
                [] -> {false, ?ERRCODE(err190_read_mail_content_fail)};
                [Content] ->
                    SName = case CurSName == undefined of
                        true ->
                            case MailType of
                                ?MAIL_TYPE_PRIV ->
                                    lib_role:get_role_name(Sid);
                                ?MAIL_TYPE_GUILD -> utext:get(4000004);
                                _ -> utext:get(?SYSTEM)
                            end;
                        false -> CurSName
                    end,
                    NewMail = Mail#mail{sname = SName, content = Content},
                    {ok, NewMail2} = change_mail_read_state(RoleId, NewMail),
                    {ok, NewMail2}
            end;
        % 信件内容已经加载
        Mail ->
            {ok, NewMail} = change_mail_read_state(RoleId, Mail),
            {ok, NewMail}
    end.

%% 改变邮件的阅读状态
change_mail_read_state(RoleId, #mail{id = MailId, state = OldState, cm_attachment = CmAttachment, effect_st = OldEffectSt, effect_et = OldEffectEt} = Mail) ->
    if
        % % 查看带附件的邮件不改变信件状态
        % CmAttachment =/= [] -> State = OldState;
        % 更新未读信件状态为已读
        OldState == ?MAIL_STATE_NO_READ ->
            State = ?MAIL_STATE_READ,
            case CmAttachment == [] of
                true -> %% 查看没有附件的邮件要把有效期变为1天
                    EffectSt = utime:unixtime(),
                    EffectEt = get_effect_et(CmAttachment, State, EffectSt);
                false -> %% 查看附件的邮件不更新有效时间
                    EffectSt = OldEffectSt,
                    EffectEt = OldEffectEt
            end,
            db:execute(io_lib:format(?sql_mail_attr_update_state_and_effect_st, [State, EffectSt, MailId]));
        true ->
            State = OldState,
            EffectSt = OldEffectSt,
            EffectEt = OldEffectEt
    end,
    NewMail = Mail#mail{state = State, effect_st = EffectSt, effect_et = EffectEt},
    update_mail_on_dict(RoleId, NewMail),
    {ok, NewMail}.

%% 获得截断的有效邮件列表
get_sub_effect_mail_list(RoleId) ->
    MailList = get_effect_mail_list(RoleId),
    MaxLen = get_config(max_send_mail_len),
    lists:sublist(MailList, MaxLen).

%% 获得有效的邮件列表
get_effect_mail_list(RoleId) ->
    MailList = get_mail_list_on_dict(RoleId),
    NowTime = utime:unixtime(),
    F = fun(#mail{effect_et = EffectEt}) -> NowTime =< EffectEt end,
    lists:filter(F, MailList).

%% 批量删除邮件检测函数
%% 检测邮件是否有附件
check_delete_mails(RoleId, DelMailIds) ->
    NowTime = utime:unixtime(),
    MailList = get_mail_list_on_dict(RoleId),
    do_check_delete_mails(MailList, DelMailIds, NowTime, []).

%% 检测要批量删除的邮件是否有效
do_check_delete_mails([], _, _, Result) -> {ok, Result};
do_check_delete_mails([OneMail|Mails], DelMailIds, NowTime, Result) ->
    case lists:member(OneMail#mail.id, DelMailIds) of
        true ->
            IsAttach = ?IF(OneMail#mail.cm_attachment =/= [] andalso OneMail#mail.state =/= ?MAIL_STATE_HAS_RECEIVE, true, false),
            IsToday = utime:is_today(OneMail#mail.time),
            IsNotRead = OneMail#mail.state == ?MAIL_STATE_NO_READ,
            % IsNotVaild = ?IF(OneMail#mail.effect_et < NowTime, true, false),
            if
                % 有未领取附件或当日未读
                IsAttach orelse (IsToday andalso IsNotRead) ->
                    do_check_delete_mails(Mails, DelMailIds, NowTime, Result);
                    % {false, ?ERRCODE(err190_have_attachment_not_to_delete)};
                % 过期邮件可以删除
                % IsNotVaild -> {false, ?ERRCODE(err190_mail_timeout_to_delete)};
                true ->
                    do_check_delete_mails(Mails, DelMailIds, NowTime, [OneMail#mail.id|Result])
            end;
        false ->
            do_check_delete_mails(Mails, DelMailIds, NowTime, Result)
    end.

%% 根据邮件id批量删除邮件
delete_mail_by_mail_ids(RoleId, DelMailIds) ->
    case check_delete_mails(RoleId, DelMailIds) of
        {ok, RealDelIds} when RealDelIds =/= [] ->
            DelArgs = util:link_list(RealDelIds),
            F = fun() ->
                Sql = io_lib:format(?sql_mail_attr_delete_more, [DelArgs]),
                db:execute(Sql),
                Sql2 = io_lib:format(?sql_mail_content_delete_more, [DelArgs]),
                db:execute(Sql2),
                ok
            end,
            case catch db:transaction(F) of
                ok ->
                    delete_by_mail_ids_on_dict(RoleId, RealDelIds),
                    {?SUCCESS, RealDelIds};
                Err ->
                    ?ERR("Del Mails Fail:~p~n", [Err]),
                    {?FAIL, []}
            end;
        {false, Code} -> {Code, []};
        _ -> {?SUCCESS, []}
    end.

%% 删除邮件
delete_mail_by_mail_id(RoleId, MailId) ->
    case get_mail_by_mail_id_on_dict(RoleId, MailId) of
        false -> ErrorCode = ?ERRCODE(err190_no_mail_to_delete);
        Mail ->
            case delete_mail(RoleId, Mail) of
                {ok, ErrorCode} -> ok;
                {false, ErrorCode} -> ok
            end
    end,
    {ok, BinData} = pt_190:write(19003, [ErrorCode, MailId]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 删除邮件
delete_mail(RoleId, #mail{id = MailId, effect_et = EffectEt} = Mail) ->
    IsAttach = is_attach(Mail),
    NowTime = utime:unixtime(),
    if
        IsAttach == 1 -> {false, ?ERRCODE(err190_have_attachment_not_to_delete)};
        NowTime > EffectEt -> {false, ?ERRCODE(err190_mail_timeout_to_delete)};
        true ->
            F = fun() ->
                Sql = io_lib:format(?sql_mail_attr_delete, [MailId]),
                db:execute(Sql),
                Sql2 = io_lib:format(?sql_mail_content_delete, [MailId]),
                db:execute(Sql2),
                ok
            end,
            case catch db:transaction(F) of
                ok ->
                    delete_mail_by_mail_id_on_dict(RoleId, MailId),
                    {ok, ?SUCCESS};
                _ ->
                    {false, ?FAIL}
            end
    end.

%% 批量提取附件
extract_attachment_by_mail_ids(Player, MailIds) ->
    {ErrorCode, NewPlayer, HasExtractIds, RewardList} = do_extract_attachment_by_mail_ids(MailIds, Player, [], []),
    F = fun
        ({ObjectType, Id, Num}) -> {ObjectType, Id, Num};
        ({?TYPE_ATTR_GOODS, Id, Num, _ExtraAttr}) -> {?TYPE_GOODS, Id, Num};
        (T) -> T
    end,
    UqRewardList = lib_goods_api:make_reward_unique(lists:map(F, RewardList)),
    % ?PRINT("ErrorCode:~p MailIds:~p HasExtractIds:~p RewardList:~p UqRewardList:~p ~n",
    %     [ErrorCode, MailIds, HasExtractIds, RewardList, UqRewardList]),
    {ok, BinData} = pt_190:write(19005, [ErrorCode, HasExtractIds, UqRewardList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer}.

%% 批量提取附件
do_extract_attachment_by_mail_ids([], Player, [], _SumRewardList) -> {?ERRCODE(err190_no_mail_attachment), Player, [], []};
do_extract_attachment_by_mail_ids([], Player, HasExtractIds, SumRewardList) -> {?SUCCESS, Player, HasExtractIds, SumRewardList};
do_extract_attachment_by_mail_ids([MailId|MailIds], Player, HasExtractIds, SumRewardList) ->
    case extract_attachment_by_mail_id(Player, MailId) of
        {1, RewardList, NewPlayer} ->
            do_extract_attachment_by_mail_ids(MailIds, NewPlayer, [MailId|HasExtractIds], RewardList++SumRewardList);
        {ErrorCode, _RewardList, NewPlayer} -> {ErrorCode, NewPlayer, HasExtractIds, SumRewardList}
    end.

%% 提取附件
%% 分三部分取邮件 1:金钱 2:通用 3:物品
extract_attachment_by_mail_id(Player, MailId) ->
    case check_extract_attachment_by_mail_id(Player, MailId) of
        {false, ErrorCode} -> NewPlayer = Player, RewardList = [];
        {ok, Mail} ->
            case extract_attachment(Player, Mail) of
                {false, ErrorCode, NewPlayer, NewMail} ->
                    #mail{cm_attachment = CmAttachment} = Mail,
                    #mail{cm_attachment = NewCmAttachment} = NewMail,
                    RewardList = CmAttachment -- NewCmAttachment;
                {ok, NewPlayer, #mail{cm_attachment = RewardList}} ->
                    ErrorCode = ?SUCCESS
            end,
            case RewardList =/= [] of
                true ->
                    %% 获得物品提示
                    {ok, BinData2} = pt_110:write(11061, [RewardList]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData2);
                false ->
                    skip
            end
    end,
    {ErrorCode, RewardList, NewPlayer}.

check_extract_attachment_by_mail_id(Player, MailId) ->
    #player_status{id = RoleId} = Player,
    case get_mail_by_mail_id_on_dict(RoleId, MailId) of
        false -> {false, ?ERRCODE(err190_no_mail)};
        #mail{cm_attachment = []} -> {false, ?ERRCODE(err190_no_mail_attachment)};
        #mail{state = ?MAIL_STATE_HAS_RECEIVE} -> {false, ?ERRCODE(err190_have_receive_attachment)};
        #mail{effect_et = EffectEt, cm_attachment = CmAttachment} = Mail ->
            NowTime = utime:unixtime(),
            case NowTime > EffectEt of
                true ->
                    {false, ?ERRCODE(err190_mail_timeout_to_extract_attachment)};
                false ->
                    {_FusionList, RealReward} = temp_split_fusion_equip(CmAttachment),
                    case lib_goods_api:can_give_goods(Player, RealReward) of
                        true ->
                            {ok, Mail};
                        {false, ErrorCode} ->
                            {false, ErrorCode}
                    end
            end
    end.

% 临时处理
temp_split_fusion_equip(RewardList) ->
    case length(RewardList) =< 2 of
        true -> {[], RewardList};
        _ ->
            F_split = fun({GoodsType, GoodsTypeId, _Num}) ->
                if
                    GoodsType =/= ?TYPE_GOODS -> false;
                    true ->
                        case data_goods_type:get(GoodsTypeId) of
                            #ets_goods_type{type = ?GOODS_TYPE_EQUIP, color = Color} when Color =< ?PURPLE ->
                                lib_goods_check:get_fusion_exp_by_goods_type_id(GoodsTypeId)> 0;
                            _ -> false
                        end
                end
                      end,
            {FusionList, RealReward} = lists:partition(F_split, RewardList),
            {FusionList, RealReward}
    end.

auto_fusion_equip(PS, []) -> PS;
auto_fusion_equip(PS, EquipList) ->
    NewPS = lib_goods_do:goods_fusion_no_cost(PS, [{GTypeId, GNum}||{_, GTypeId, GNum}<-EquipList]),
    {Title, Content} = {utext:get(1500015), utext:get(1500016)},
    lib_mail_api:send_sys_mail([PS#player_status.id], Title, Content, []),
    NewPS.

extract_attachment(Player, Mail) ->
    #mail{id = MailId, cm_attachment = CmAttachment} = Mail,
    UqCmAttachment = make_cm_attachment_unique(CmAttachment),
    Map = spilt_attachment(UqCmAttachment),
    #{money_list := MoneyList, common_list := CommonList, goods_list := GoodsList} = Map,
    List = [{money_list, MoneyList}, {common_list, CommonList}, {goods_list, GoodsList}],
    case extract_attachment_help(List, Player, Mail) of
        {false, ErrorCode, NewPlayer, NewMail2} -> {false, ErrorCode, NewPlayer, NewMail2};
        {ok, NewPlayer, NewMail} ->
            % 领取附件后重新计算有效结束时间
            % 领取后附件不清空,设置状态为已领取状态 by czc 2018/1/25
            NowTime = utime:unixtime(),
            NewState = ?MAIL_STATE_HAS_RECEIVE,
            Sql = io_lib:format(?sql_mail_attr_update_receive_state, [NewState, util:term_to_bitstring(CmAttachment), NowTime, MailId]),
            db:execute(Sql),
            EffectEt = get_effect_et(CmAttachment, NewState, NowTime),
            NewMail2 = NewMail#mail{state = NewState, cm_attachment = CmAttachment, effect_st = NowTime, effect_et = EffectEt},
            update_mail_on_dict(Player#player_status.id, NewMail2),
            {ok, NewPlayer, NewMail2}
    end.

extract_attachment_help([], Player, Mail) -> {ok, Player, Mail};

extract_attachment_help([{money_list, MoneyList}|L], Player, Mail) ->
    case recv_money_list(Player, Mail, MoneyList) of
        {false, ErrorCode} -> {false, ErrorCode, Player, Mail};
        {ok, NewPlayer, NewMail} -> extract_attachment_help(L, NewPlayer, NewMail)
    end;
extract_attachment_help([{common_list, CommonList}|L], Player, Mail) ->
    {ok, NewPlayer, NewMail} = recv_common_list(Player, Mail, CommonList),
    extract_attachment_help(L, NewPlayer, NewMail);

extract_attachment_help([{goods_list, []}|L], Player, Mail) ->
    extract_attachment_help(L, Player, Mail);

extract_attachment_help([{goods_list, GoodsList}|L], Player, Mail) ->
    #player_status{id = RoleId} = Player,
    {FusionList, RealReward} = temp_split_fusion_equip(GoodsList),
    case lib_goods_api:can_give_goods(Player, RealReward) of
        true ->
            % 邮件处理
            #mail{id = MailId, cm_attachment = CmAttachment} = Mail,
            NewCmAttachment = CmAttachment -- GoodsList,
            db_mail_attr_update_cm_attachment(MailId, NewCmAttachment),
            log(log_mail_get, [Mail, GoodsList]),
            NewMail = Mail#mail{cm_attachment = NewCmAttachment},
            update_mail_on_dict(RoleId, NewMail),
            % Produce
            % F = fun
            %     ({?TYPE_GOODS, GoodsTypeId, GoodsNum}) ->
            %         #ets_goods_type{bind = BindCfg} = data_goods_type:get(GoodsTypeId),
            %         {goods, GoodsTypeId, GoodsNum, BindCfg};
            %     ({?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}) ->
            %         {goods, GoodsTypeId, GoodsNum, ?BIND};
            %     ({?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, Attr}) ->
            %         {goods_attr, GoodsTypeId, GoodsNum, Attr}
            % end,
            % GiveGoodsList = lists:map(F, GoodsList),
            % % ?INFO("extract_attachment_help GoodsList:~w GiveGoodsList:~w ~n", [GoodsList, GiveGoodsList]),
            % Produce = #produce{type = mail, remark = lists:concat(["MailId:", MailId])},
            % case catch lib_goods_api:give_goods_by_pile(Player, GiveGoodsList, Produce) of
            %     {1, _} -> lib_goods_api:send_tv_tip(RoleId, GoodsList);
            %     Error -> ?ERR("RoleId:~p Mail:~w GoodsList:~w Error:~p", [Player#player_status.id, Mail, GoodsList, Error])
            % end,
            Produce = #produce{type = mail, reward = RealReward, remark = lists:concat(["MailId:", MailId])},
            PlayerTmp = auto_fusion_equip(Player, FusionList),
            NPlayer = ?IF(RealReward == [], PlayerTmp, lib_goods_api:send_reward(PlayerTmp, Produce)),
            extract_attachment_help(L, NPlayer, NewMail);
        {false, ErrorCode} ->
            {false, ErrorCode, Player, Mail}
    end.

%% 唯一处理(不要修改格式)
%% CmAttachment :: [{Type, GoodsId, Num}]
make_cm_attachment_unique(CmAttachment) ->
    List = make_cm_attachment_unique(CmAttachment, []),
    F = fun(T, Acc) ->
        case T of
            {{Type, GoodsTypeId}, GoodsNum} ->
                [{Type, GoodsTypeId, GoodsNum}|Acc];
            {?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, Attr} ->
                [{?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, Attr}|Acc];
            _ -> Acc
        end
    end,
    lists:foldl(F, [], List).

make_cm_attachment_unique([], ObjectList) -> ObjectList;
make_cm_attachment_unique([H|T], ObjectList) ->
    case H of
        {Type, GoodsTypeId, GoodsNum} when is_integer(Type) ->
            NewObjectList = case lists:keyfind({Type, GoodsTypeId}, 1, ObjectList) of
                {_, Num} -> [{ {Type, GoodsTypeId}, GoodsNum+Num}| lists:keydelete({Type, GoodsTypeId}, 1, ObjectList)];
                false    -> [{ {Type, GoodsTypeId}, GoodsNum} | ObjectList]
            end,
            make_cm_attachment_unique(T, NewObjectList);
        {?TYPE_ATTR_GOODS, _GoodsTypeId, _GoodsNum, _Attr} ->
            make_cm_attachment_unique(T, [H|ObjectList]);
        _ ->
            make_cm_attachment_unique(T, ObjectList)
    end.

%% 分离附件(不要修改格式)
%% @return #{money_list = MoneyList, goods_list = GoodsList, common_list = CommonList}
%%  MoneyList 金钱列表 [{?TYPE_GOLD|?TYPE_BGOLD|?TYPE_COIN|?TYPE_GCOIN, GoodsTypeId, Num}|...]
%%  GoodsList 物品列表 [{?TYPE_GOODS|?TYPE_BIND_GOODS, GoodsTypeId, Num}|...]
%%  CommonList 通用列表
spilt_attachment(CmAttachment) ->
    Map = #{money_list => [], goods_list => [], common_list => []},
    spilt_attachment(CmAttachment, Map).

spilt_attachment([], Map) -> Map;
spilt_attachment([{Type, _GoodsTypeId, _GoodsNum}=T|L], Map) when
        Type == ?TYPE_GOLD;
        Type == ?TYPE_BGOLD;
        Type == ?TYPE_COIN ->
    MoneyList = maps:get(money_list, Map, []),
    NewMap = maps:put(money_list, [T|MoneyList], Map),
    spilt_attachment(L, NewMap);
spilt_attachment([{Type, _GoodsTypeId, _GoodsNum}=T|L], Map) when
        Type == ?TYPE_GOODS orelse Type == ?TYPE_BIND_GOODS ->
    GoodsList = maps:get(goods_list, Map, []),
    NewMap = maps:put(goods_list, [T|GoodsList], Map),
    spilt_attachment(L, NewMap);
spilt_attachment([{Type, _GoodsTypeId, _GoodsNum}=T|L], Map) when
        Type == ?TYPE_EXP;
        Type == ?TYPE_CHARM;
        Type == ?TYPE_FAME;
        Type == ?TYPE_GFUNDS;
        Type == ?TYPE_GDONATE;
        Type == ?TYPE_GUILD_PRESTIGE;
        Type == ?TYPE_FASHION_NUM;
        Type == ?TYPE_RUNE;
        Type == ?TYPE_SOUL;
        Type == ?TYPE_RUNE_CHIP;
        Type == ?TYPE_CURRENCY;
        Type == ?TYPE_GUILD_GROWTH;
        Type == ?TYPE_SEA_EXPLOIT;
        Type == ?TYPE_HONOUR ->
    CommonList = maps:get(common_list, Map, []),
    NewMap = maps:put(common_list, [T|CommonList], Map),
    spilt_attachment(L, NewMap);
spilt_attachment([{?TYPE_ATTR_GOODS, _GoodsTypeId, _GoodsNum, _Attr}=T|L], Map) ->
    GoodsList = maps:get(goods_list, Map, []),
    NewMap = maps:put(goods_list, [T|GoodsList], Map),
    spilt_attachment(L, NewMap);
spilt_attachment([_|L], Map) ->
    spilt_attachment(L, Map).

%% 收取金钱
recv_money_list(Player, Mail, []) -> {ok, Player, Mail};
recv_money_list(#player_status{id = RoleId} = Player, Mail, MoneyList) ->
    F = fun() ->
        % 金钱增加
        Map = #{?TYPE_COIN => 0, ?TYPE_BGOLD => 0, ?TYPE_GOLD => 0},
        F2 = fun({Type, _GoodsTypeId, GoodsNum}, TmpMap) -> maps:put(Type, GoodsNum, TmpMap) end,
        NewMap = lists:foldl(F2, Map, MoneyList),
        #{?TYPE_COIN := AddCoin, ?TYPE_BGOLD := AddBgold, ?TYPE_GOLD := AddGold} = NewMap,
        #player_status{coin = Coin, bgold = Bgold, gold = Gold} = Player,
        NewPlayer = Player#player_status{coin = Coin+AddCoin, bgold = Bgold+AddBgold, gold = Gold+AddGold},
        lib_player:update_player_money(Player, NewPlayer),
        % 邮件附件处理
        #mail{id = MailId, cm_attachment = CmAttachment} = Mail,
        NewCmAttachment = CmAttachment -- MoneyList,
        db_mail_attr_update_cm_attachment(MailId, NewCmAttachment),
        NewMail = Mail#mail{cm_attachment = NewCmAttachment},
        log(log_mail_get, [Mail, MoneyList]),
        {ok, NewPlayer, NewMail}
    end,
    case catch db:transaction(F) of
        {ok, NewPlayer, NewMail} ->
            update_mail_on_dict(RoleId, NewMail),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_MONEY),
            log_money_produce(MoneyList, Player, NewPlayer, mail, lists:concat(["MailId:", NewMail#mail.id])),
            lib_goods_api:send_tv_tip(RoleId, MoneyList),
            {ok, NewPlayer, NewMail};
        Error ->
            ?ERR("Error:~p RoleId:~p Mail:~w", [Error, RoleId, Mail]),
            {false, ?FAIL}
    end.

log_money_produce([], _Player, _NewPlayer, _ProduceType, _About) -> skip;
log_money_produce([{Type, _GoodsTypeId, _GoodsNum}|L], Player, NewPlayer, ProduceType, About) ->
    MoneyType = case Type of
        ?TYPE_GOLD -> ?GOLD;
        ?TYPE_BGOLD -> ?BGOLD;
        ?TYPE_COIN -> ?COIN;
        _ -> none
    end,
    if
        MoneyType=/=none -> lib_log_api:log_produce(ProduceType, MoneyType, Player, NewPlayer, About);
        true -> skip
    end,
    log_money_produce(L, Player, NewPlayer, ProduceType, About).

%% 收取普通物品
recv_common_list(Player, Mail, []) -> {ok, Player, Mail};
recv_common_list(Player, Mail, CommonList) ->
    #player_status{id = RoleId} = Player,
    #mail{id = MailId, title = MailTitle, cm_attachment = CmAttachment} = Mail,
    NewCmAttachment = CmAttachment -- CommonList,
    db_mail_attr_update_cm_attachment(MailId, NewCmAttachment),
    NewMail = Mail#mail{cm_attachment = NewCmAttachment},
    update_mail_on_dict(RoleId, NewMail),
    log(log_mail_get, [Mail, CommonList]),
    NewPlayer = do_recv_common_list(CommonList, MailTitle, Player),
    lib_goods_api:send_tv_tip(RoleId, CommonList),
    {ok, NewPlayer, NewMail}.

do_recv_common_list([], _MailTitle, Player) -> Player;
do_recv_common_list([T|L], MailTitle, Player) ->
    case T of
        {?TYPE_EXP, _, Exp} ->
            NewPlayer = lib_player:add_exp(Player, Exp),
            do_recv_common_list(L, MailTitle, NewPlayer);
        % 增加名誉
        {?TYPE_FAME, _, Num} ->
            NewPlayer = lib_flower_api:add_fame(Player, Num, [{mail, MailTitle}]),
            do_recv_common_list(L, MailTitle, NewPlayer);
        % 增加魅力值
        {?TYPE_CHARM, _, Num} ->
            NewPlayer = lib_flower_api:add_charm(Player, Num, [{mail, MailTitle}]),
            do_recv_common_list(L, MailTitle, NewPlayer);
        %% 公会资金
        {?TYPE_GFUNDS, _, Gfunds} ->
            case Player#player_status.guild#status_guild.id > 0 of
                true ->
                    mod_guild:add_gfunds(Player#player_status.id, Player#player_status.guild#status_guild.id, Gfunds, mail);
                false -> skip
            end,
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_GDONATE, _, Donate} ->
            mod_guild:add_donate(Player#player_status.id, Donate, mail, MailTitle),
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_SEA_EXPLOIT, _, Exploit} ->
            NewPs = lib_seacraft_extra_api:add_exploit(Player, Exploit, {produce, mail}),
            do_recv_common_list(L, MailTitle, NewPs);
        {?TYPE_GUILD_PRESTIGE, _, Num} ->
            mod_guild_prestige:add_prestige([Player#player_status.id, mail, ?GOODS_ID_GUILD_PRESTIGE, Num, 0]),
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_FASHION_NUM, PosId, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_fashion:fashion_add_upgrade_num(PosId, Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_RUNE, _, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_rune:add_rune_point(Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_SOUL, _, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_soul:add_soul_point(Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_RUNE_CHIP, _, Num} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            NewGoodsStatus = lib_rune:add_rune_chip(Num, GoodsStatus),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_GUILD_GROWTH, _, Val} ->
            #player_status{id = RoleId} = Player,
            case Player#player_status.guild#status_guild.id > 0 of
                true ->
                    mod_guild:add_growth(RoleId, Player#player_status.guild#status_guild.id, Val, mail, []);
                false -> skip
            end,
            do_recv_common_list(L, MailTitle, Player);
        {?TYPE_HONOUR, _, Num} ->
            NewPlayer = lib_jjc:add_honour(Player, Num),
            do_recv_common_list(L, MailTitle, NewPlayer);
        {?TYPE_CURRENCY, CurrencyId, Val} ->
            NewPlayer = lib_goods_util:add_currency(Player, CurrencyId, Val),
            do_recv_common_list(L, MailTitle, NewPlayer);
        _ ->
            do_recv_common_list(L, MailTitle, Player)
    end.

%% 发送公会邮件
send_guild_mail_on_server(Player, Title, Content) ->
    case check_send_guild_mail_on_server(Player, Title, Content) of
        {false, ErrorCode} -> {false, ErrorCode};
        true ->
            mod_daily:increment(Player#player_status.id, ?MOD_MAIL, ?DAILY_SEND_GUILD_MAIL),
            mod_guild:send_guild_mail_by_role_id(Player#player_status.id, Title, Content, [], [Player#player_status.id]),
            {ok, Player}
    end.

%% 检查
check_send_guild_mail_on_server(_Player, _Title, _Content) ->
    {false, ?ERRCODE(not_open)}.
    % CheckTitleLen = util:check_length(Title, 50),
    % CheckTitleKeyWord = check_illegal_word(Title),
    % CheckContentLen = util:check_length(Content, 100),
    % CheckContentKeyWord = check_illegal_word(Content),
    % #player_status{id = RoleId, guild = StatusGuild} = Player,
    % IsLessthanLimit = mod_daily:lessthan_limit(RoleId, ?MOD_MAIL, ?DAILY_SEND_GUILD_MAIL),
    % if
    %     CheckTitleLen == false -> {false, ?ERRCODE(err190_mail_title_len)};
    %     CheckTitleKeyWord -> {false, ?ERRCODE(err190_mail_title_sensitive)};
    %     CheckContentLen == false -> {false, ?ERRCODE(err190_mail_content_len)};
    %     CheckContentKeyWord -> {false, ?ERRCODE(err190_mail_content_sensitive)};
    %     IsLessthanLimit == false -> {false, ?ERRCODE(err190_send_guild_mail_count_not_enough)};
    %     StatusGuild#status_guild.id =< 0 -> {false, ?ERRCODE(err190_must_on_guild_to_send_guild_mail)};
    %     true ->
    %         case mod_guild:is_have_permission(RoleId, ?PERMISSION_SEND_GUILD_MAIL) of
    %             true -> true;
    %             false -> {false, ?ERRCODE(err190_not_permisssion_to_send_guild_mail)}
    %         end
    % end.

%% 邮件通知
send_mail_notice(RoleId) ->
    MailList = get_mail_list_on_dict(RoleId),
    NowTime = utime:unixtime(),
    F = fun(#mail{effect_et = EffectEt, state = State} = Mail) ->
        case NowTime =< EffectEt of
            true ->
                case State of
                    ?MAIL_STATE_NO_READ -> true;
                    ?MAIL_STATE_HAS_RECEIVE -> false;
                    _ -> is_attach(Mail) == 1
                end;
            false ->
                false
        end
    end,
    MailListFilter = lists:filter(F, MailList),
    case MailListFilter == [] of
        true -> ErrorCode = ?FAIL;
        false -> ErrorCode = ?SUCCESS
    end,
    {ok, BinData} = pt_190:write(19008, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 邮件的错误码
send_error_code(Sid, ErrorCode) ->
    {ok, BinData} = pt_190:write(19000, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).

%% ----------------------------------------------------
%% 接口/其他
%% ----------------------------------------------------

%% 发送系统邮件
send_sys_mail(PlayerInfoList, Title, Content, CmAttachment) ->
    send_mail(PlayerInfoList, Title, Content, CmAttachment, ?MAIL_TYPE_SYS, ?SEND_LOG_TYPE_NO).

send_sys_mail(PlayerInfoList, Title, Content, CmAttachment, SendLogType) ->
    send_mail(PlayerInfoList, Title, Content, CmAttachment, ?MAIL_TYPE_SYS, SendLogType).

%% 发送公会邮件
send_guild_mail(PlayerInfoList, Title, Content) ->
    send_guild_mail(PlayerInfoList, Title, Content, []).

%% 发送公会邮件
send_guild_mail(PlayerInfoList, Title, Content, CmAttachment) ->
    send_mail(PlayerInfoList, Title, Content, CmAttachment, ?MAIL_TYPE_GUILD, ?SEND_LOG_TYPE_NO).

%% 发送系统邮件
%% @param PlayerInfoList : 名字(string() | binary())列表、 角色Id列表
%%      后台使用:包含角色名字或Id的二进制字符串如：<<"[12,34]">>、<<"[\"80\",\"测试\"]">>、<<"[12, \"测试\"]">>
%% @param UknTitle、UknContent: string() | binary()
%% @param CmAttachment: list()
%% @param Type 1:系统邮件;2:私人邮件;3:公会邮件
%% @param SendLogType 是否需要记录邮件的发送日志
send_mail(UknPlayerInfoList, UknTitle, UknContent, UnkCmAttachment, Type, SendLogType) ->
    Title = util:make_sure_binary(UknTitle),
    Content = util:make_sure_binary(UknContent),
    PlayerInfoList = util:to_term(UknPlayerInfoList),
    RoleIdList = lists:map(fun get_role_id/1, PlayerInfoList),
    CmAttachment0 = util:make_sure_list(UnkCmAttachment),
    % CmAttachment0 奖励列表太大，超过200个长度时强制合并物品，防止结构太大发不出邮件导致问题
    case length(CmAttachment0) > 200 of
        true -> CmAttachment = lib_goods_api:make_reward_unique(CmAttachment0);
        _ -> CmAttachment = CmAttachment0
    end,
    F = fun
        (0) -> skip;
        (RId) ->
            % mod_id_create:get_new_id 要在事物之前,否则数据库抢夺资源导致 timeout
            case catch mod_id_create:get_new_id(?MAIL_ID_CREATE) of
                AutoId when is_integer(AutoId) ->
                    F2 = fun() ->
                        {ok, Mail} = insert_mail_to_db_no_transaction(AutoId, Type, 0, RId, Title, Content, CmAttachment),
                        log_mail_send(SendLogType, Mail),
                        {ok, Mail}
                    end,
                    case catch db:transaction(F2) of
                        {ok, Mail} ->
                            lib_player:apply_cast(RId, ?APPLY_CAST_STATUS, lib_mail, add_mail, [[Mail]]),
                            ok;
                        Error ->
                            ?ERR("Error:~p Args:~w", [Error, [AutoId, RId, Title, Content, CmAttachment]]),
                            error
                    end;
                Error ->
                    ?ERR("Error:~p Args:~w", [Error, [RId, Title, Content, CmAttachment]]),
                    error
            end
    end,
    case length(RoleIdList) > 10 of
        true ->
            F3 = fun(RId, Counter) ->
                F(RId),
                case Counter < 20 of
                    true -> Counter + 1;
                    false -> timer:sleep(200), 1
                end
            end,
            spawn(fun() -> lists:foldl(F3, 1, RoleIdList) end);
        false ->
            lists:foreach(fun(Rid) -> F(Rid) end, RoleIdList)
    end,
    ok.

%% 输入角色Id或角色名，获得角色Id
get_role_id(PlayerInfo) when is_integer(PlayerInfo) ->
    PlayerInfo;
get_role_id(PlayerInfo) when is_list(PlayerInfo) ->
    case mod_chat_agent:match(match_name, [util:make_sure_list(PlayerInfo)]) of
        [] ->
            case lib_player:get_role_id_by_name(PlayerInfo) of
                null -> 0;
                PlayerId -> PlayerId
            end;
        [Player] ->
            Player#ets_unite.id
    end;
get_role_id(PlayerInfo) when is_binary(PlayerInfo) ->
    Name = binary_to_list(PlayerInfo),
    get_role_id(Name);
get_role_id(_) ->
    0.

%% 插入邮件
%% @return {ok, #mail{} }
insert_mail_to_db_no_transaction(Id, Type, SId, RId, UknTitle, UknContent, CmAttachment) ->
    Title = util:make_sure_binary(UknTitle),
    Content = util:make_sure_binary(UknContent),
    % 数据库插入处理单引号
    TitleTrans = util:fix_sql_str(Title),
    ContentTrans = util:fix_sql_str(Content),
    CmAttachmentBin = util:term_to_bitstring(CmAttachment),
    State = ?MAIL_STATE_NO_READ, Locked = ?MAIL_LOCKED_NO,
    Timestamp = utime:microunixtime(),
    Time = utime:micro_to_s(Timestamp),
    Sql1 = io_lib:format(?sql_mail_attr_insert, [Id, Type, State, Locked, SId, RId, TitleTrans, CmAttachmentBin, Timestamp, Time]),
    db:execute(Sql1),
    Sql2 = io_lib:format(?sql_mail_content_insert, [Id, RId, ContentTrans]),
    db:execute(Sql2),
    Mail = #mail{
        id = Id
        , type = Type
        , state = State
        , locked = Locked
        , sid = SId
        , rid = RId
        , title = ulists:list_to_bin(Title)
        , content = undefined
        , cm_attachment = CmAttachment
        , timestamp = Timestamp
        , time = Time
        , effect_st = Time
        , effect_et = get_effect_et(CmAttachment, State, Time)
    },
    {ok, Mail}.

get_effect_et(_, ?MAIL_STATE_HAS_RECEIVE, EffectSt) ->
    EffectTime = get_config(read_and_no_attachment_effect_time),
    EffectSt + EffectTime;
get_effect_et([], ?MAIL_STATE_READ, EffectSt) ->
    EffectTime = get_config(read_and_no_attachment_effect_time),
    EffectSt + EffectTime;
get_effect_et([], ?MAIL_STATE_NO_READ, EffectSt) ->
    EffectTime = get_config(not_read_and_no_attachment_effect_time),
    EffectSt + EffectTime;
get_effect_et(_, _, EffectSt) ->
    EffectTime = get_config(attachment_effect_time),
    EffectSt + EffectTime.

%% 是否记录邮件发送记录
log_mail_send(?SEND_LOG_TYPE_YES, Mail) -> log(log_mail_send, Mail);
log_mail_send(_, _Mail) -> skip.

%% 日志
log(log_mail_get, [Mail, CmAttachment]) ->
    #mail{id = Id, sid = Sid, rid = RId, title = Title, timestamp = Timestamp} = Mail,
    TitleTrans = util:fix_sql_str(Title),
    mod_log:add_log(log_mail_get, [Id, Sid, RId, TitleTrans, util:term_to_string(CmAttachment), Timestamp, utime:unixtime()]);
log(log_mail_send, Mail) ->
    #mail{id = Id, sid = SId, rid = RId, title = Title, cm_attachment = CmAttachment} = Mail,
    TitleTrans = util:fix_sql_str(Title),
    mod_log:add_log(log_mail_send, [Id, SId, RId, TitleTrans, util:term_to_string(CmAttachment), utime:unixtime()]).

%% 清理邮件的规则(由PHP处理)
clean_mail() ->
    NowTime = utime:unixtime(),
    NoEffectTime = get_config(read_and_no_attachment_effect_time), %% 没有附件且已读的邮件或者已领取附件的邮件
    Sql = io_lib:format(<<"SELECT id, rid, title, cm_attachment, state, effect_st FROM mail_attr WHERE effect_st <= ~p and (state = 3 or (state = 1 and cm_attachment = '[]'))">>, [NowTime-NoEffectTime]),
    List = db:get_all(Sql),
    NoEffectTime1 = get_config(not_read_and_no_attachment_effect_time), %% 没有附件也没有读取的过期邮件
    Sql1 = io_lib:format(<<"SELECT id, rid, title, cm_attachment, state, effect_st FROM mail_attr WHERE state = 2 and effect_st <= ~p and cm_attachment = '[]'">>, [NowTime-NoEffectTime1]),
    List1 = db:get_all(Sql1),
    EffectTime = get_config(attachment_effect_time), %% 过期的未领取附件的邮件
    Sql2 = io_lib:format(<<"SELECT id, rid, title, cm_attachment, state, effect_st FROM mail_attr WHERE state <> 3 and effect_st <= ~p and cm_attachment <> '[]'">>, [NowTime-EffectTime]),
    List2 = db:get_all(Sql2),
    TotalList = List ++ List1 ++ List2,
    DelMailIds = [MailId || [MailId, _RoleId, _Title, _CmAttachment, _State, _EffectSt] <- TotalList],
    case DelMailIds =/= [] of
        true ->
            DelMailIdsStr = util:link_list(DelMailIds),
            F1 = fun() ->
                db:execute(io_lib:format(<<"DELETE FROM mail_attr WHERE id in (~s)">>, [DelMailIdsStr])),
                db:execute(io_lib:format(<<"DELETE FROM mail_content WHERE id in (~s)">>, [DelMailIdsStr]))
            end,
            db:transaction(F1),
            F2 = fun(T) ->
                case T of
                    [_MailId, RoleId, Title, CmAttachment, State, EffectSt] ->
                        lib_log_api:log_mail_clear(RoleId, Title, CmAttachment, State, EffectSt);
                    _ -> skip
                end
            end,
            lists:foreach(F2, TotalList);
        false -> skip
    end,
    ok.

%% ----------------------------------------------------
%% util
%% ----------------------------------------------------

%% 检查非法字符
check_illegal_word(Text) ->
    check_illegal_word(Text, ?ESC_ILLEGAL_SQL_CHARS).

%% 检查关键字，存在非法字符返回true，否则false
%% @spec check_illegal_word(Text, Words) -> false | true
%% @param Text : 需要检查的字符串（或字符串的二进制形式）
%% @param Words: 非法字符列表
check_illegal_word(_, []) -> false;
check_illegal_word(Text, [Word | Words]) ->
    case re:run(Text, Word, [{capture, none}]) of
        match -> true;
        nomatch -> check_illegal_word(Text, Words)
    end.

%% 替换非法字符
replace_illegal_word(Text) ->
    List = util:link_list(?ESC_ILLEGAL_SQL_CHARS, "|"),
    re:replace(Text, List, "*", [global, {return, list}]).

%% ----------------------------------------------------
%% 数据库
%% ----------------------------------------------------

%% 更新邮件附件
db_mail_attr_update_cm_attachment(MailId, CmAttachment) ->
    Sql = io_lib:format(?sql_mail_attr_update_cm_attachment, [util:term_to_bitstring(CmAttachment), MailId]),
    db:execute(Sql).

%% 错误码
%% err190_no_mail:
%% err190_read_mail_content_fail:
%% err190_no_mail_attachment:
%% err190_no_mail_to_delete:
%% err190_have_attachment_not_to_delete:
%% err190_bag_full
%% err190_mail_timeout_to_delete
%% err190_mail_timeout_to_extract_attachment
