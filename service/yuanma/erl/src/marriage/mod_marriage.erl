%%%--------------------------------------
%%% @Module  : mod_marriage
%%% @Author  : huyihao
%%% @Created : 2017.11.17
%%% @Description:  婚姻
%%%--------------------------------------
-module(mod_marriage).
-behaviour(gen_server).

-include("common.hrl").
-include("boss.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("marriage.hrl").
-include("language.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("goods.hrl").
-include("designation.hrl").

-export([start_link/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).
-export([
    open_page_personals/1,  %% 获取大厅信息
    follow_cancel_personals/1,  %% 关注/取消关注
    send_personals/1,           %% 发布信息
    change_ps_personals/1,
    marriage_login_logout/1,
    open_biaobai/1, send_biaobai/1, answer_biaobai/1, marriage_status_login/1,
    sure_answer/1, get_login_send/1,
    open_propose/1,
    check_marriage/1, check_divorce/1,
    do_divorse/1,
    do_divorse_answer/1,
    open_wedding_order/1, open_my_lover/1,
    wedding_order/6, wedding_order_success/3, wedding_start/2, wedding_end/1, change_now_wedding_state/1,
    throw_dog_food/2, get_dog_food/4, check_answer_biaobai/1, check_wedding_order/1,
    get_love_dsgt/1,
    change_personal_msg/1,
    buy_love_gift/1,
    send_love_gift_info/1,
    get_love_gift_reward/1,
    add_love_num/1,
    check_send_personals/1,
    rename/1,
    change_pic/1,
    delete_propose/1,
    lv_up/1,
    gm_add_wedding_times/2,
    gm_wedding_feast/1,
    gm_wedding_anime/1,
    gm_restore_old_player_wedding_times/1,
    gm_update_wedding_day/2,
    gm_clear_hall_information/0,
    gm_change_gift_time/1]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?MODULE, {'stop'}).

rename(Args) ->
    gen_server:cast(?MODULE, {rename, Args}).

change_pic(Args) ->
    gen_server:cast(?MODULE, {change_pic, Args}).

lv_up(Args) ->
    gen_server:cast(?MODULE, {lv_up, Args}).

marriage_login_logout(Args) ->
    gen_server:cast(?MODULE, {marriage_login_logout, Args}).

open_page_personals(Args) ->
    gen_server:cast(?MODULE, {open_page_personals, Args}).

follow_cancel_personals(Args) ->
    gen_server:cast(?MODULE, {follow_cancel_personals, Args}).

send_personals(Args) ->
    gen_server:cast(?MODULE, {send_personals, Args}).

change_ps_personals(Args) ->
    gen_server:cast(?MODULE, {change_ps_personals, Args}).

open_biaobai(Args) ->
    gen_server:cast(?MODULE, {open_biaobai, Args}).

send_biaobai(Args) ->
    gen_server:cast(?MODULE, {send_biaobai, Args}).

answer_biaobai(Args) ->
    gen_server:cast(?MODULE, {answer_biaobai, Args}).

delete_propose(Args) ->
    gen_server:cast(?MODULE, {delete_propose, Args}).

sure_answer(Args) ->
    gen_server:cast(?MODULE, {sure_answer, Args}).

get_login_send(RoleId) ->
    gen_server:cast(?MODULE, {get_login_send, RoleId}).

open_propose(Args) ->
    gen_server:cast(?MODULE, {open_propose, Args}).

do_divorse(Args) ->
    gen_server:cast(?MODULE, {do_divorse, Args}).

do_divorse_answer(Args) ->
    gen_server:cast(?MODULE, {do_divorse_answer, Args}).

get_love_dsgt(Args) ->
    gen_server:cast(?MODULE, {get_love_dsgt, Args}).

add_love_num(Args) ->
    gen_server:cast(?MODULE, {add_love_num, Args}).

open_wedding_order(RoleId) ->
    gen_server:cast(?MODULE, {open_wedding_order, RoleId}).

wedding_order(RoleId, DayId, TimeId, GoodsTypeId, NowWeddingState, IfReward) ->
    gen_server:cast(?MODULE, {wedding_order, RoleId, DayId, TimeId, GoodsTypeId, NowWeddingState, IfReward}).

wedding_order_success(RoleId, WeddingTime, WeddingType) ->
    gen_server:cast(?MODULE, {wedding_order_success, RoleId, WeddingTime, WeddingType}).

wedding_start(RoleIdM, WeddingPid) ->
    gen_server:cast(?MODULE, {wedding_start, RoleIdM, WeddingPid}).

wedding_end(RoleIdM) ->
    gen_server:cast(?MODULE, {wedding_end, RoleIdM}).

open_my_lover(Args) ->
    gen_server:cast(?MODULE, {open_my_lover, Args}).

buy_love_gift(Args) ->
    gen_server:cast(?MODULE, {buy_love_gift, Args}).

send_love_gift_info(Args) ->
    gen_server:cast(?MODULE, {send_love_gift_info, Args}).

get_love_gift_reward(Args) ->
    gen_server:cast(?MODULE, {get_love_gift_reward, Args}).

change_now_wedding_state(DeleteRoleIdMList) ->
    gen_server:cast(?MODULE, {change_now_wedding_state, DeleteRoleIdMList}).

throw_dog_food(RoleId, TypeId) ->
    gen_server:cast(?MODULE, {throw_dog_food, RoleId, TypeId}).

get_dog_food(RoleId, RoleIdM, RoleIdW, DogFoodId) ->
    gen_server:cast(?MODULE, {get_dog_food, RoleId, RoleIdM, RoleIdW, DogFoodId}).

marriage_status_login(RoleId) ->
    gen_server:call(?MODULE, {marriage_status_login, RoleId}).

check_marriage(Args) ->
    gen_server:call(?MODULE, {check_marriage, Args}).

check_divorce(Args) ->
    gen_server:call(?MODULE, {check_divorce, Args}).

check_answer_biaobai(Args) ->
    gen_server:call(?MODULE, {check_answer_biaobai, Args}).

check_wedding_order(Args) ->
    gen_server:call(?MODULE, {check_wedding_order, Args}).

check_send_personals(Args) ->
    gen_server:call(?MODULE, {check_send_personals, Args}).

change_personal_msg(Args) ->
    gen_server:cast(?MODULE, {change_personal_msg, Args}).

gm_add_wedding_times(Args, WeddingType) ->
    gen_server:cast(?MODULE, {gm_add_wedding_times, Args, WeddingType}).

gm_wedding_feast(RoleId) ->
    gen_server:cast(?MODULE, {gm_wedding_feast, RoleId}).

gm_wedding_anime(RoleId) ->
    gen_server:cast(?MODULE, {gm_wedding_anime, RoleId}).

gm_restore_old_player_wedding_times(List) ->
    gen_server:cast(?MODULE, {gm_restore_old_player_wedding_times, List}).

gm_update_wedding_day(RoleId, LoveDay) ->
    gen_server:cast(?MODULE, {gm_update_wedding_day, RoleId, LoveDay}).

gm_clear_hall_information() ->
    gen_server:cast(?MODULE, {gm_clear_hall_information}).

gm_change_gift_time(RoleId) ->
    gen_server:cast(?MODULE, {gm_change_gift_time, RoleId}).

init([]) ->
    CoupleList = lib_marriage:init_couples(),
    PersonalsList = lib_marriage:init_personals(),
    ProposalList = lib_marriage:init_proposal(),
    State = #marriage_state{
        marriage_couple = CoupleList,
        personals = PersonalsList,
        proposal = ProposalList
    },
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {reply, ok, State};
        Result ->
            Result
    end.

do_handle_call({marriage_status_login, RoleId}, _From, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    RoleMarriageM = lists:keyfind(RoleId, #marriage_couple.role_id_m, CoupleList),
    RoleMarriageW = lists:keyfind(RoleId, #marriage_couple.role_id_w, CoupleList),
    case RoleMarriageM of
        false ->
            case RoleMarriageW of
                false ->
                    Return = false;
                _ ->
                    #marriage_couple{
                        role_id_m = LoverRoleId,
                        type = Type,
                        now_wedding_state = NowWeddingState,
                        wedding_pid = WeddingPid,
                        love_gift_time_m = LoveGiftM,
                        love_gift_time_w = LoveGiftW
                    } = RoleMarriageW,
                    Return = [LoverRoleId, Type, NowWeddingState, WeddingPid, LoveGiftW, LoveGiftM]
            end;
        _ ->
            #marriage_couple{
                role_id_w = LoverRoleId,
                type = Type,
                now_wedding_state = NowWeddingState,
                wedding_pid = WeddingPid,
                love_gift_time_m = LoveGiftM,
                love_gift_time_w = LoveGiftW
            } = RoleMarriageM,
            Return = [LoverRoleId, Type, NowWeddingState, WeddingPid, LoveGiftM, LoveGiftW]
    end,
    {reply, Return, State};

do_handle_call({check_marriage, [RoleId1, Sex1, RoleId2, Sex2, _MarriageType]}, _From, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = ProposalList
    } = State,
    Args11 = [RoleId1, 0, Sex1], %% 求婚判断不需要等级，默认填零
    Args22 = [RoleId2, 0, Sex2],
    % case MarriageType of
    %     2 ->
    %         AskMarriageType = 3;
    %     _ ->
    %         AskMarriageType = 2
    % end,
    AskMarriageType = 2,
    Return = case lib_marriage:biaobai_check(CoupleList, Args11, Args22, AskMarriageType, ProposalList) of
        {false, Code} ->
            {false, Code};
        true ->
            case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
                false ->
                    true;
                #proposal{proposing_list = ProposingList1} ->
                    case lists:keyfind(RoleId1, #propose_info.propose_role_id, ProposingList1) of
                        false ->
                            true;
                        _ ->
                            {false, ?ERRCODE(err172_couple_not_propose_twice)}
                            % case lib_marriage:check_marriage_done(RoleId1, CoupleList) of
                            %     true ->
                            %         {false, ?ERRCODE(err172_please_order_wedding)};
                            %     false ->
                            %         {false, ?ERRCODE(err172_couple_not_propose_twice)}
                            % end
                    end
            end
    end,
    {reply, Return, State};

do_handle_call({check_divorce, [RoleId, DivorceType]}, _From, State) ->
    #marriage_state{
        proposal = ProposalList,
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, Code} ->
            Return = {false, Code};
        {true, CoupleInfo} ->
            #marriage_couple{
                role_id_m = RoleIdM, role_id_w = RoleIdW,
                type = MarriageType
            } = CoupleInfo,
            case DivorceType == 1 of
                true ->
                    OtherRid = ?IF(RoleId == RoleIdM, RoleIdW, RoleIdM),
                    case lists:keyfind(OtherRid, #proposal.role_id, ProposalList) of
                        #proposal{divorce_info = [1]} ->
                            Return = {false, ?ERRCODE(err172_ask_for_divorce)};
                        _ ->
                            Return = {true, MarriageType}
                    end;
                _ ->
                    Return = {true, MarriageType}
            end
    end,
    {reply, Return, State};

do_handle_call({check_answer_biaobai, [RoleId2, RoleId1]}, _From, State) ->
    #marriage_state{
        proposal = ProposalList,
        marriage_couple = CoupleList
    } = State,
    Return = case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
        false ->
            {false, ?ERRCODE(err172_fouple_have_not_biaobai)};
        #proposal{proposing_list = ProposingList1} ->
            case lists:keyfind(RoleId1, #propose_info.propose_role_id, ProposingList1) of
                false ->
                    {false, ?ERRCODE(err172_fouple_have_not_biaobai)};
                #propose_info{
                    propose_type = ProposeType,
                    other_cost_list = OtherCostList,
                    cost_key = CostKey
                } ->
                    case lib_marriage:get_couple_info(RoleId1, CoupleList) of
                        {_CoupleInfo, OtherRid} when OtherRid =/= RoleId2 ->
                            {false, ?ERRCODE(err172_couple_other_not_single)};
                        _ ->
                            {true, ProposeType, OtherCostList, CostKey}
                    end
                    % case CostKey of
                    %     "" ->
                    %         true;
                    %     _ ->
                    %         {cost, OtherCostList, CostKey}
                    % end
            end
    end,
    {reply, Return, State};

do_handle_call({check_wedding_order, [RoleId, WeddingType]}, _From, State) ->
     #marriage_state{
        marriage_couple = CoupleList,
        proposal = _ProposalList
    } = State,
    Return = case lib_marriage:get_couple_info(RoleId, CoupleList) of
        false ->
            {false, ?ERRCODE(err172_couple_single)};
        {CoupleInfo, _OtherRid} ->
            #marriage_couple{
                role_id_m = _RoleIdM,
                role_id_w = _RoleIdW,
                type = MarriageType,
                now_wedding_state = NowWeddingState,
                others = Others
            } = CoupleInfo,
            %ProposalM = lists:keyfind(RoleIdM, #proposal.role_id, ProposalList),
            %ProposalW = lists:keyfind(RoleIdW, #proposal.role_id, ProposalList),
            HadOrderTimes = lib_marriage_wedding:check_wedding_order_times(Others, WeddingType),
            if
                % is_record(ProposalM, proposal) andalso ProposalM#proposal.proposing_list =/= [] ->
                %     {false, ?ERRCODE(err172_cant_wedding_twice)};
                % is_record(ProposalW, proposal) andalso ProposalW#proposal.proposing_list =/= []  ->
                %     {false, ?ERRCODE(err172_cant_wedding_twice)};
                MarriageType =:= 1 ->
                    {false, ?ERRCODE(err172_marriage_life_not_marry)};
                NowWeddingState =:= 2 ->
                    {false, ?ERRCODE(err172_wedding_have_order)};
                HadOrderTimes == false ->
                    {false, ?ERRCODE(err172_wedding_order_times_err)};
                true ->
                    true
            end
    end,
    {reply, Return, State};

do_handle_call({check_send_personals, [RoleId]}, _From, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    #personals_player{time = Time} = ulists:keyfind(RoleId, #personals_player.role_id, PersonalsList, #personals_player{role_id = RoleId}),
    case utime:unixtime() - Time >= ?SendPersonalGap of
        true -> Return = true;
        _ -> Return = {false, ?ERRCODE(err172_personals_send_cd)}
    end,
    {reply, Return, State};

do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(Info, State) ->
    case catch do_handle_cast(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_cast({rename, [RoleId, Name]}, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    case lists:keyfind(RoleId, #personals_player.role_id, PersonalsList) of
        false ->
            NewPersonalsList = PersonalsList;
        PersonalsInfo ->
            NewPersonalsInfo = PersonalsInfo#personals_player{
                name = Name
            },
            Sql = usql:update(marriage_personals_player, [{name, Name}], [{role_id, RoleId}]),
            db:execute(Sql),
            NewPersonalsList = lists:keyreplace(RoleId, #personals_player.role_id, PersonalsList, NewPersonalsInfo)
    end,
    NewState = State#marriage_state{
        personals = NewPersonalsList
    },
    {noreply, NewState};

do_handle_cast({change_pic, [RoleId, Picture, PictureVer]}, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    case lists:keyfind(RoleId, #personals_player.role_id, PersonalsList) of
        false ->
            NewPersonalsList = PersonalsList;
        PersonalsInfo ->
            NewPersonalsInfo = PersonalsInfo#personals_player{
                picture = Picture, picture_ver = PictureVer
            },
            Sql = usql:update(marriage_personals_player, [{picture, Picture}, {picture_ver, PictureVer}], [{role_id, RoleId}]),
            db:execute(Sql),
            NewPersonalsList = lists:keyreplace(RoleId, #personals_player.role_id, PersonalsList, NewPersonalsInfo)
    end,
    NewState = State#marriage_state{
        personals = NewPersonalsList
    },
    {noreply, NewState};

do_handle_cast({lv_up, [RoleId, Lv]}, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    case lists:keyfind(RoleId, #personals_player.role_id, PersonalsList) of
        false ->
            NewPersonalsList = PersonalsList;
        PersonalsInfo ->
            NewPersonalsInfo = PersonalsInfo#personals_player{
                lv = Lv
            },
            NewPersonalsList = lists:keyreplace(RoleId, #personals_player.role_id, PersonalsList, NewPersonalsInfo)
    end,
    NewState = State#marriage_state{
        personals = NewPersonalsList
    },
    {noreply, NewState};

do_handle_cast({marriage_login_logout, [RoleId, Name, Type]}, State) ->
    #marriage_state{
        personals = PersonalsList,
        proposal = ProposalList,
        marriage_couple = CoupleList
    } = State,
    NowTime = utime:unixtime(),
    case lists:keyfind(RoleId, #proposal.role_id, ProposalList) of
        false ->
            NewProposalList2 = ProposalList;
        ProposalPlayer ->
            #proposal{
                proposing_list = ProposingList,
                divorce_info = DivorceInfo
            } = ProposalPlayer,
            %% 玩家下线/上线：直接拒绝所有求婚者
            F = fun(ProposeInfo, {OutProposeList1, ProposeRoleIdList1, ProposingList1}) ->
                #propose_info{
                    propose_role_id = ProposeRoleId1,
                    type = MarriageType,
                    time = _Time
                } = ProposeInfo,
                case MarriageType == 2 of
                    true ->
                        {[ProposeInfo|OutProposeList1], [ProposeRoleId1|ProposeRoleIdList1], ProposingList1};
                    false ->
                        {OutProposeList1, ProposeRoleIdList1, [ProposeInfo|ProposingList1]}
                end
            end,
            {OutProposeList, NewProposeRoleIdList, NewProposingList} = lists:foldl(F, {[], [], []}, ProposingList),
            case NewProposeRoleIdList of
                [] ->
                    skip;
                _ ->
                    ReSql1 = io_lib:format(?DelectMProposeRoleIdAllSql, [RoleId, ulists:list_to_string(NewProposeRoleIdList, ",")]),
                    db:execute(ReSql1)
            end,
            NewProposalPlayer = ProposalPlayer#proposal{
                proposing_list = NewProposingList,
                divorce_info = []
            },
            case DivorceInfo of
                [1] ->
                    case lib_marriage:get_couple_info(RoleId, CoupleList) of
                        {_CoupleInfo, OtherRid} ->
                            lib_mail_api:send_sys_mail([OtherRid], utext:get(1720013), utext:get(1720014, [Name]), []);
                        _ -> ok
                    end;
                _ -> ok
            end,
            NewProposalList1 = lists:keyreplace(RoleId, #proposal.role_id, ProposalList, NewProposalPlayer),
            NewProposalList2 = lib_marriage:answer_biaobai_all(OutProposeList, NewProposalList1, 3)
    end,
    F1 = fun(ProposalPlayer1, {OutProposeList2, ProposeRoleIdList2, NewProposalList3}) ->
        #proposal{
            role_id = RoleId1,
            proposing_list = ProposingList1
        } = ProposalPlayer1,
        case lists:keyfind(RoleId, #propose_info.propose_role_id, ProposingList1) of
            false ->
                {OutProposeList2, ProposeRoleIdList2, [ProposalPlayer1|NewProposalList3]};
            ProposeInfo1 ->
                #propose_info{
                    time = Time1
                } = ProposeInfo1,
                case (NowTime - Time1) >= ?MarriageProposeOverTime of
                    true ->
                        NewProposingList1 = lists:keydelete(RoleId, #propose_info.propose_role_id, ProposingList1),
                        NewProposalPlayer1 = ProposalPlayer1#proposal{
                            proposing_list = NewProposingList1
                        },
                        {[ProposeInfo1|OutProposeList2], [RoleId1|ProposeRoleIdList2], [NewProposalPlayer1|NewProposalList3]};
                    false ->
                        {OutProposeList2, ProposeRoleIdList2, [ProposalPlayer1|NewProposalList3]}
                end
        end
    end,
    {OutProposeList3, NewProposeRoleIdList1, NewProposalList4} = lists:foldl(F1, {[], [], []}, NewProposalList2),
    case NewProposeRoleIdList1 of
        [] ->
            skip;
        _ ->
            ReSql2 = io_lib:format(?DelectMProposeProRoleIdAllSql, [RoleId, ulists:list_to_string(NewProposeRoleIdList1, ",")]),
            db:execute(ReSql2)
    end,
    NewProposalList = lib_marriage:answer_biaobai_all(OutProposeList3, NewProposalList4, 3),
    case lists:keyfind(RoleId, #personals_player.role_id, PersonalsList) of
        false ->
            NewPersonalsList = PersonalsList;
        PersonalsInfo ->
            NewPersonalsInfo = PersonalsInfo#personals_player{
                if_online = Type
            },
            NewPersonalsList = lists:keyreplace(RoleId, #personals_player.role_id, PersonalsList, NewPersonalsInfo)
    end,
    NewState = State#marriage_state{
        personals = NewPersonalsList,
        proposal = NewProposalList
    },
    {noreply, NewState};

do_handle_cast({open_page_personals, [RoleId, PageId, AskFollowTime, AskFlowerTime, LessFreeTimes, FriendIntimacyList]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        personals = PersonalsList
    } = State,
    RolePersonalsInfo = lists:keyfind(RoleId, #personals_player.role_id, PersonalsList),
    case RolePersonalsInfo of
        false ->
            Popularity = 0;
        _ ->
            Popularity = length(RolePersonalsInfo#personals_player.fans_list)
    end,
    case PageId of
        1 -> %% 大厅
            NowTime = utime:unixtime(),
            F1 = fun(PersonalsInfo, SendList1) ->
                case NowTime-PersonalsInfo#personals_player.time < ?PersonalsContinueTime of
                    true ->
                        SendInfo = lib_marriage:pack_personals_send_info(PersonalsInfo, RoleId, FriendIntimacyList, CoupleList),
                        [SendInfo|SendList1];
                    false ->
                        SendList1
                end
            end,
            SendList = lists:foldl(F1, [], PersonalsList);
        _ ->
            case RolePersonalsInfo == false of
                true -> %% 没发布过信息，没有关注/粉丝列表
                    SendList = [];
                _ ->
                    case PageId of
                        2 -> %% 我的关注
                            F2 = fun(PersonalsInfo, SendList1) ->
                                case lists:keyfind(RoleId, 1, PersonalsInfo#personals_player.fans_list) of
                                    {RoleId, Time} ->
                                        SendInfo = lib_marriage:pack_personals_send_info(PersonalsInfo, RoleId, FriendIntimacyList, CoupleList),
                                        [{SendInfo, Time}|SendList1];
                                    _ ->
                                        SendList1
                                end
                            end,
                            SendListWithTime = lists:foldl(F2, [], PersonalsList),
                            case length(SendListWithTime) > ?FANS_LENGTH of
                                true ->
                                    SendListWithTimeNew = lists:sublist(lists:reverse(lists:keysort(2, SendListWithTime)), ?FANS_LENGTH);
                                _ ->
                                    SendListWithTimeNew = SendListWithTime
                            end,
                            SendList = [SendInfo ||{SendInfo, _} <- SendListWithTimeNew];
                        3 -> %% 我的粉丝
                            FansList = RolePersonalsInfo#personals_player.fans_list,
                            F3 = fun({FansRoleId, _Time}, SendList1) ->
                                FansInfo = ulists:keyfind(FansRoleId, #personals_player.role_id, PersonalsList, FansRoleId),
                                SendInfo = lib_marriage:pack_personals_send_info(FansInfo, RoleId, FriendIntimacyList, CoupleList),
                                [SendInfo|SendList1]
                            end,
                            SendList = lists:foldl(F3, [], FansList);
                        _ ->
                            SendList = []
                    end
            end
    end,
    ?PRINT("SendList ~p~n", [SendList]),
    {ok, Bin} = pt_172:write(17200, [?SUCCESS, PageId, Popularity, AskFollowTime, AskFlowerTime, LessFreeTimes, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({follow_cancel_personals, [RoleId, FollowRoleId, Type, RoleArgs, _FollowArgs]}, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    FollowPersonalsInfo =  lists:keyfind(FollowRoleId, #personals_player.role_id, PersonalsList),
    case Type of
        1 ->
            case FollowPersonalsInfo of
                false ->
                    Code = ?ERRCODE(err172_personals_not_player), %% 没这个玩家，不关注
                    % {FName, FSex, FCareer, FTurn, FVip, FVipType, FPicture, FPictureVer} = FollowArgs,
                    % FollowPersonalsInfo1 = #personals_player{
                    %     role_id = FollowRoleId,
                    %     name = FName,
                    %     sex = FSex,
                    %     vip = FVip,
                    %     career = FCareer,
                    %     turn = FTurn,
                    %     picture = FPicture,
                    %     picture_ver = FPictureVer,
                    %     if_online = 1
                    % },
                    FollowPersonalsInfo1 = #personals_player{},
                    FansList = [];
                    %lib_marriage:sql_personals_player(FollowPersonalsInfo1);
                _ ->
                    #personals_player{
                        fans_list = FansList
                    } = FollowPersonalsInfo,
                    Code = ?SUCCESS,
                    FollowPersonalsInfo1 = FollowPersonalsInfo
                    % case lists:keymember(RoleId, FansList) of
                    %     true ->
                    %         Code = ?ERRCODE(err172_personals_is_fans),   %% 已经是粉丝
                    %         FollowPersonalsInfo1 = FollowPersonalsInfo;
                    %     false ->
                    %         Code = ?SUCCESS,
                    %         FollowPersonalsInfo1 = FollowPersonalsInfo
                    % end
            end,
            case Code =:= ?SUCCESS of
                false ->
                    NewState = State;
                true ->
                    NowTime = utime:unixtime(),
                    FansList1 = [{RoleId, NowTime}|lists:keydelete(RoleId, 1, FansList)],
                    case length(FansList1) > ?FANS_LENGTH of
                        true -> NewFansList = lists:sublist(FansList1, ?FANS_LENGTH); _ -> NewFansList = FansList1
                    end,
                    NewFollowPersonalsInfo = FollowPersonalsInfo1#personals_player{
                        fans_list = NewFansList
                    },
                    NewPersonalsList1 = lists:keystore(FollowRoleId, #personals_player.role_id, PersonalsList, NewFollowPersonalsInfo),
                    lib_marriage:sql_personals_follow(RoleId, FollowRoleId, NowTime),
                    case lists:keyfind(RoleId, #personals_player.role_id, PersonalsList) of
                        false ->
                            {Name, Lv, Sex, Career, Turn, Vip, _VipType, Picture, PictureVer, VipExp, VipHide, IsSupvip} = RoleArgs,
                            NewPersonalsInfo = #personals_player{
                                role_id = RoleId,
                                name = Name,
                                lv = Lv,
                                sex = Sex,
                                vip = Vip,
                                career = Career,
                                turn = Turn,
                                picture = Picture,
                                picture_ver = PictureVer,
                                if_online = 1,
                                time = 0,
                                vip_exp = VipExp,
                                vip_hide = VipHide,
                                is_supvip = IsSupvip
                            },
                            lib_marriage:sql_personals_player(NewPersonalsInfo),
                            NewPersonalsList = [NewPersonalsInfo|NewPersonalsList1];
                        _ ->
                            NewPersonalsList = NewPersonalsList1
                    end,
                    ?PRINT("follow succ ~p~n", [NewFollowPersonalsInfo]),
                    NewState = State#marriage_state{
                        personals = NewPersonalsList
                    }
            end;
        _ ->
            case FollowPersonalsInfo of
                false ->
                    Code = ?ERRCODE(err172_personals_not_player),   %% 没有这个玩家
                    NewState = State;
                _ ->
                    #personals_player{
                        fans_list = FansList
                    } = FollowPersonalsInfo,
                    case lists:keymember(RoleId, 1, FansList) of
                        false ->
                            Code = ?ERRCODE(err172_personals_not_following),   %% 没有关注该玩家
                            NewState = State;
                        true ->
                            Code = ?SUCCESS,
                            NewFansList = lists:keydelete(RoleId, 1, FansList),
                            NewNewFollowPersonalsInfo = FollowPersonalsInfo#personals_player{
                                fans_list = NewFansList
                            },
                            ?PRINT("follow succ ~p~n", [NewNewFollowPersonalsInfo]),
                            lib_marriage:sql_personals_follow_cancel(RoleId, FollowRoleId),
                            NewPersonalsList = lists:keyreplace(FollowRoleId, #personals_player.role_id, PersonalsList, NewNewFollowPersonalsInfo),
                            NewState = State#marriage_state{
                                personals = NewPersonalsList
                            }
                    end
            end
    end,
    ?PRINT("follow_cancel_personals Code ~p~n", [Code]),
    {ok, Bin} = pt_172:write(17201, [Code, FollowRoleId, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

%% 发布征友大厅信息
do_handle_cast({send_personals, [RoleId, Msg, Type, TagList, Args]}, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    {Name, Lv, Sex, Career, Turn, Vip, _VipType, Picture, PictureVer, VipExp, VipHide, IsSupvip} = Args,
    NowTime = utime:unixtime(),
    PersonalsInfo = ulists:keyfind(RoleId, #personals_player.role_id, PersonalsList, #personals_player{role_id = RoleId}),
    NewPersonalsInfo = PersonalsInfo#personals_player{
        name = Name,
        lv = Lv,
        sex = Sex,
        vip = Vip,
        career = Career,
        turn = Turn,
        picture = Picture,
        picture_ver = PictureVer,
        msg = util:fix_sql_str(util:make_sure_binary(Msg)),
        if_online = 1,
        type = Type,
        tag_list = TagList,
        time = NowTime,
        vip_exp = VipExp,
        vip_hide = VipHide,
        is_supvip = IsSupvip
    },
    lib_marriage:sql_personals_player(NewPersonalsInfo),
    NewPersonalsList = lists:keystore(RoleId, #personals_player.role_id, PersonalsList, NewPersonalsInfo),
    NewState = State#marriage_state{
        personals = NewPersonalsList
    },
    %?PRINT("send_personals ~p~n", [NewPersonalsInfo]),
    {ok, Bin} = pt_172:write(17202, [?SUCCESS, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_grow_welfare_api, release_dating, []),
    lib_chat:send_TV({all_lv, ?MarriageOpenLv, 99999}, ?MOD_MARRIAGE, 1, [Name, RoleId]),
    {noreply, NewState};

do_handle_cast({change_personal_msg, [RoleId, Msg, TagList]}, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    case lists:keyfind(RoleId, #personals_player.role_id, PersonalsList) of
        #personals_player{msg = OldMsg, tag_list = OldTag} = PersonalsInfo ->
            NewMsg = ?IF(length(Msg) == 0, OldMsg, util:fix_sql_str(util:make_sure_binary(Msg))),
            NewTagList = ?IF(length(TagList) == 0, OldTag, TagList),
            NewPersonalsInfo = PersonalsInfo#personals_player{
                msg = NewMsg,
                tag_list = NewTagList
            },
            lib_marriage:sql_update_personals_player(NewPersonalsInfo),
            NewPersonalsList = lists:keystore(RoleId, #personals_player.role_id, PersonalsList, NewPersonalsInfo),
            NewState = State#marriage_state{
                personals = NewPersonalsList
            },
            {ok, Bin} = pt_172:write(17204, [1, NewMsg, NewTagList]),
            lib_server_send:send_to_uid(RoleId, Bin),
            ?PRINT("change_personal_msg ~p~n", [NewPersonalsInfo]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({change_ps_personals, [RoleId, Args]}, State) ->
    #marriage_state{
        personals = PersonalsList
    } = State,
    case lists:keyfind(RoleId, #personals_player.role_id, PersonalsList) of
        false ->
            NewState = State;
        PersonalsInfo ->
            [Sex, Career] = Args,
            NewPersonalsInfo = PersonalsInfo#personals_player{
                sex = Sex,
                career = Career
            },
            lib_marriage:sql_personals_player(NewPersonalsInfo),
            NewPersonalsList = lists:keystore(RoleId, #personals_player.role_id, PersonalsList, NewPersonalsInfo),
            NewState = State#marriage_state{
                personals = NewPersonalsList
            }
    end,
    {noreply, NewState};

%% 打开表白
do_handle_cast({open_biaobai, [Args1, Args2]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = ProposalList
    } = State,
    [RoleId1, _Name1, _CombatPower1, Lv1, Sex1, _Vip1, _Career1, _Turn1] = Args1,
    [RoleId2, Name2, CombatPower2, Lv2, Sex2, Vip2, Career2, Turn2] = Args2,
    Args11 = [RoleId1, Lv1, Sex1], %% 用于判断
    Args22 = [RoleId2, Lv2, Sex2],
    case lib_marriage:biaobai_check(CoupleList, Args11, Args22, 1, ProposalList) of
        {false, Code} ->
            skip;
        true ->
            case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
                false ->
                    Code = ?SUCCESS;
                #proposal{proposing_list = ProposingList1} ->
                    case lists:keyfind(RoleId1, #propose_info.propose_role_id, ProposingList1) of
                        false ->
                            Code = ?SUCCESS;
                        _ ->
                            Code = ?ERRCODE(err172_couple_not_biaobai_twice)
                    end
            end
    end,
    {ok, Bin} = pt_172:write(17220, [Code, RoleId2, Name2, Lv2, CombatPower2, Sex2, Vip2, Career2, Turn2]),
    lib_server_send:send_to_uid(RoleId1, Bin),
    {noreply, State};

%% 发送表白/求婚
do_handle_cast({send_biaobai, [Args1, Args2, Msg, AskMarriageType, WeddingType, ProposeArgs]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = ProposalList
    } = State,
    [RoleId1, Name1, CombatPower1, Lv1, Sex1, Vip1, Career1, Turn1] = Args1,
    [RoleId2, _Name2, _CombatPower2, Lv2, Sex2, _Vip2, _Career2, _Turn2] = Args2,
    Args11 = [RoleId1, Lv1, Sex1], %% 用于判断
    Args22 = [RoleId2, Lv2, Sex2],
    ?PRINT("send_biaobai start ========= ~n", []),
    case lib_marriage:biaobai_check(CoupleList, Args11, Args22, AskMarriageType, ProposalList) of
        {false, Code} ->
            skip;
        true ->
            %% 检查是否已经向对方表白或者求婚
            case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
                false ->
                    Code = ?SUCCESS;
                #proposal{proposing_list = ProposingList1} ->
                    Code = case lists:keyfind(RoleId1, #propose_info.propose_role_id, ProposingList1) of
                        false ->
                            ?SUCCESS;
                        _ ->
                            case AskMarriageType of
                                1 ->
                                    ?ERRCODE(err172_couple_not_biaobai_twice);
                                _ ->
                                    ?ERRCODE(err172_couple_not_propose_twice)
                                    % case lib_marriage:check_marriage_done(RoleId1, CoupleList) of
                                    %     true ->
                                    %         ?ERRCODE(err172_please_order_wedding);
                                    %     false ->
                                    %         ?ERRCODE(err172_couple_not_propose_twice)
                                    % end
                            end
                    end
            end
    end,
    ?PRINT("send_biaobai Code ~p~n", [Code]),
    [_, CostKey, OtherCostList, CostList] = ProposeArgs,
    case Code =:= ?SUCCESS of
        false ->
            NewState = State;
        true ->
            NewProposeInfo = #propose_info{
                role_id = RoleId2,
                propose_role_id = RoleId1,
                type = AskMarriageType,
                propose_type = WeddingType,
                msg = Msg,
                cost_list = CostList,
                other_cost_list = OtherCostList,
                cost_key = CostKey,
                time = utime:unixtime()
            },
            lib_marriage:sql_marriage_propose(NewProposeInfo),
            case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
                false ->
                    NewProposalPlayer = #proposal{
                        role_id = RoleId2,
                        proposing_list = [NewProposeInfo]
                    };
                ProposalPlayer ->
                    ProposingList = ProposalPlayer#proposal.proposing_list,
                    NewProposingList = [NewProposeInfo|ProposingList],
                    NewProposalPlayer = ProposalPlayer#proposal{
                        proposing_list = NewProposingList
                    }
            end,
            NewProposalList = lists:keystore(RoleId2, #proposal.role_id, ProposalList, NewProposalPlayer),
            %?PRINT("send_biaobai NewProposalPlayer ~p~n", [NewProposalPlayer]),
            NewState = State#marriage_state{
                proposal = NewProposalList
            },
            case CostKey of
                "" ->
                    IfAA = 0;
                _ ->
                    IfAA = 1
            end,
            #figure{picture = Picture1, picture_ver = PictureVer1} = lib_role:get_role_figure(RoleId1),
            {ok, Bin2} = pt_172:write(17222, [RoleId1, Name1, Lv1, CombatPower1, Sex1, Vip1, Career1, Turn1, Picture1, PictureVer1, AskMarriageType, WeddingType, Msg, IfAA, OtherCostList]),
            lib_server_send:send_to_uid(RoleId2, Bin2),
            % TA数据上报
            AskMarriageType == 2 andalso lib_player:apply_cast(RoleId1, ?APPLY_CAST_STATUS, ta_agent_fire, marriage_state, [RoleId2, ?TA_MARRIAGE_APPLY])

    end,
    case AskMarriageType of
        1 ->
            {ok, Bin1} = pt_172:write(17221, [Code]),
            lib_server_send:send_to_uid(RoleId1, Bin1);
        _ ->
            {ok, Bin1} = pt_172:write(17231, [Code, RoleId2]),
            lib_server_send:send_to_uid(RoleId1, Bin1)
    end,
    lib_log_api:log_marriage_propose(RoleId1, CostList, RoleId2, OtherCostList, AskMarriageType, WeddingType),
    {noreply, NewState};

%% 删除表白
do_handle_cast({delete_propose, [RoleId1, RoleId2]}, State) ->
    #marriage_state{
        proposal = ProposalList
    } = State,
    case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
        false ->
            NewState = State;
        #proposal{proposing_list = ProposingList1} = ProposalPlayer ->
            case lists:keyfind(RoleId1, #propose_info.propose_role_id, ProposingList1) of
                false ->
                    NewState = State;
                #propose_info{} ->
                    ReSql = io_lib:format(?DelectMProposeRoleIdAllSql, [RoleId2, ulists:list_to_string([RoleId1], ",")]),
                    db:execute(ReSql),
                    NewProposingList = lists:keydelete(RoleId1, #propose_info.propose_role_id, ProposingList1),
                    NewProposalPlayer = ProposalPlayer#proposal{proposing_list = NewProposingList},
                    NewProposalList = lists:keyreplace(RoleId2, #proposal.role_id, ProposalList, NewProposalPlayer),
                    NewState = State#marriage_state{proposal = NewProposalList}
            end
    end,
    {noreply, NewState};

%% 回应表白/求婚
do_handle_cast({answer_biaobai, [Args1, Args2, AnswerType, ProposeArgs]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = ProposalList
    } = State,
    [RoleId1, Name1, _CombatPower1, Lv1, Sex1, _Vip1, _Career1, _Turn1] = Args1,
    [RoleId2, Name2, _CombatPower2, Lv2, Sex2, _Vip2, _Career2, _Turn2] = Args2,
    ?PRINT("answer_biaobai start ==============~n", []),
    case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
        false ->
            Code = ?ERRCODE(err172_fouple_have_not_biaobai);
        #proposal{proposing_list = ProposingList1} ->
            case lists:keyfind(RoleId1, #propose_info.propose_role_id, ProposingList1) of
                false ->
                    Code = ?ERRCODE(err172_fouple_have_not_biaobai);
                #propose_info{type = MarriageType} ->
                    Args11 = [RoleId1, Lv1, Sex1], %% 用于判断
                    Args22 = [RoleId2, Lv2, Sex2],
                    case lib_marriage:biaobai_check(CoupleList, Args11, Args22, MarriageType, ProposalList) of
                        {false, Code} ->
                            skip;
                        true ->
                            Code = ?SUCCESS
                    end
            end
    end,
    [OtherCostKey, ProposeCost|_] = ProposeArgs,
    ProposalPlayer2 = lists:keyfind(RoleId2, #proposal.role_id, ProposalList),
    ?PRINT("answer_biaobai Code ~p~n", [Code]),
    case Code =:= ?SUCCESS of
        false ->
            case ProposalPlayer2 of
                false ->
                    NewState = State;
                #proposal{proposing_list = OldProposingList2} ->
                    case lists:keyfind(RoleId1, #propose_info.propose_role_id, OldProposingList2) of
                        #propose_info{
                            cost_key = _CostKey, other_cost_list = _OtherCostList
                        } = ProposeInfo1 ->
                            NewProposingList = lists:keydelete(RoleId1, #propose_info.propose_role_id, OldProposingList2),
                            case AnswerType =:= 1 andalso length(ProposeCost) > 0 of
                                true ->
                                    Title = ?LAN_MSG(?LAN_TITLE_WEDDING_AA_FAIL),
                                    Content = ?LAN_MSG(?LAN_CONTENT_WEDDING_AA_FAIL),
                                    lib_mail_api:send_sys_mail([RoleId1], Title, Content, ProposeCost);
                                false ->
                                    skip
                            end,
                            NewProposalList1 = lib_marriage:answer_biaobai_one(ProposeInfo1#propose_info{other_cost_key = OtherCostKey}, ProposalList, 6),
                            ReSql = io_lib:format(?DelectMProposeRoleIdAllSql, [RoleId2, ulists:list_to_string([RoleId1], ",")]),
                            db:execute(ReSql),
                            NewProposalPlayer2 = ProposalPlayer2#proposal{
                                proposing_list = NewProposingList
                            },
                            NewProposalList = lists:keyreplace(RoleId2, #proposal.role_id, NewProposalList1, NewProposalPlayer2),
                            NewState = State#marriage_state{
                                proposal = NewProposalList
                            };
                        _ ->
                            NewState = State
                    end
            end;
        true ->
            #proposal{
                proposing_list = OldProposingList2,
                answer_list = OldAnswerList2
            } = ProposalPlayer2,
            ProposeInfo1 = lists:keyfind(RoleId1, #propose_info.propose_role_id, OldProposingList2),
            NewProposalList1 = lib_marriage:answer_biaobai_one(ProposeInfo1#propose_info{other_cost_key = OtherCostKey}, ProposalList, AnswerType),
            #propose_info{
                type = MarriageType1,
                propose_type = WeddingType
            } = ProposeInfo1,
            case AnswerType of
                1 ->
                    ?PRINT("answer_biaobai middle succ ~n", []),
                    case MarriageType1 of
                        1 ->
                            {RoleIdM, RoleIdW} = ?IF(Sex1 == 1, {RoleId1, RoleId2}, {RoleId2, RoleId1}),
                            NewCouple = #marriage_couple{
                                        role_id_m = RoleIdM,
                                        role_id_w = RoleIdW,
                                        type = 1,
                                        marriage_time = utime:unixtime()
                            },
                            NewCoupleList = [NewCouple|CoupleList],
                            %lib_chat:send_TV({all}, ?MOD_MARRIAGE, 5, [Name1, RoleId1, Name2, RoleId2]),
                            lib_player:apply_cast(RoleId1, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage, biaobai_change, [Args2, MarriageType1]),
                            lib_player:apply_cast(RoleId2, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage, biaobai_change, [Args1, MarriageType1]);
                        _ ->
                            CoupleInfo1 = lists:keyfind(RoleId1, #marriage_couple.role_id_m, CoupleList),
                            CoupleInfo2 = lists:keyfind(RoleId1, #marriage_couple.role_id_w, CoupleList),
                            case MarriageType1 of
                                3 ->
                                    case CoupleInfo1 of
                                        false ->
                                            CoupleInfo21 = update_wedding_type(CoupleInfo2, WeddingType),
                                            CoupleInfo22 = update_wedding_times(CoupleInfo21, WeddingType),
                                            NewCouple = CoupleInfo22#marriage_couple{
                                                now_wedding_state = 0
                                            },
                                            NewCoupleList = lists:keyreplace(RoleId1, #marriage_couple.role_id_w, CoupleList, NewCouple);
                                        _ ->
                                            CoupleInfo11 = update_wedding_type(CoupleInfo1, WeddingType),
                                            CoupleInfo12 = update_wedding_times(CoupleInfo11, WeddingType),
                                            NewCouple = CoupleInfo12#marriage_couple{
                                                now_wedding_state = 0
                                            },
                                            NewCoupleList = lists:keyreplace(RoleId1, #marriage_couple.role_id_m, CoupleList, NewCouple)

                                    end,
                                    #marriage_couple{
                                        role_id_m = RoleIdM,
                                        wedding_pid = WeddingPid,
                                        marriage_time = MarriageTime,
                                        love_num = LoveNum, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW
                                    } = NewCouple,
                                    {LoveGiftTime1, LoveGiftTime2} = ?IF(RoleId1 == RoleIdM, {LoveGiftM, LoveGiftW}, {LoveGiftW, LoveGiftM}),
                                    lib_player:apply_cast(RoleId2, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleId1, WeddingPid, 0, MarriageTime, LoveNum, LoveGiftTime2, LoveGiftTime1]),
                                    lib_player:apply_cast(RoleId1, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleId2, WeddingPid, 0, MarriageTime, LoveNum, LoveGiftTime1, LoveGiftTime2]);
                                _ ->
                                    if
                                        is_record(CoupleInfo1, marriage_couple) ->
                                            CoupleInfo11 = update_wedding_type(CoupleInfo1, WeddingType),
                                            CoupleInfo12 = update_wedding_times(CoupleInfo11, WeddingType),
                                            NewCouple = CoupleInfo12#marriage_couple{type = 2},
                                            NewCoupleList = lists:keyreplace(RoleId1, #marriage_couple.role_id_m, CoupleList, NewCouple);
                                        is_record(CoupleInfo2, marriage_couple) ->
                                            CoupleInfo21 = update_wedding_type(CoupleInfo2, WeddingType),
                                            CoupleInfo22 = update_wedding_times(CoupleInfo21, WeddingType),
                                            NewCouple = CoupleInfo22#marriage_couple{type = 2},
                                            NewCoupleList = lists:keyreplace(RoleId1, #marriage_couple.role_id_w, CoupleList, NewCouple);
                                        true ->
                                            {RoleIdM, RoleIdW} = ?IF(Sex1 == 1, {RoleId1, RoleId2}, {RoleId2, RoleId1}),
                                            CoupleInfo = #marriage_couple{
                                                        role_id_m = RoleIdM,
                                                        role_id_w = RoleIdW,
                                                        type = 2,
                                                        marriage_time = utime:unixtime()
                                            },
                                            CoupleInfo11 = update_wedding_type(CoupleInfo, WeddingType),
                                            NewCouple = update_wedding_times(CoupleInfo11, WeddingType),
                                            NewCoupleList = [NewCouple|CoupleList]
                                    end,
                                    lib_chat:send_TV({all_lv, ?MarriageOpenLv, 99999}, ?MOD_MARRIAGE, 6, [Name1, RoleId1, Name2, RoleId2]),
                                    lib_achievement_api:async_event(RoleId1, lib_achievement_api, get_marry_event, []),
                                    lib_achievement_api:async_event(RoleId2, lib_achievement_api, get_marry_event, []),
                                    lib_player:apply_cast(RoleId1, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage, biaobai_change, [Args2, MarriageType1]),
                                    lib_player:apply_cast(RoleId2, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage, biaobai_change, [Args1, MarriageType1]),
                                    lib_designation_api:active_dsgt_common(RoleId1, ?MARRIAGE_DSGT),
                                    lib_designation_api:active_dsgt_common(RoleId2, ?MARRIAGE_DSGT),
                                    %% 房子相关处理
                                    #marriage_couple{
                                        role_id_m = RoleIdMan,
                                        role_id_w = RoleIdWon
                                    } = NewCouple,
                                    %% 完美恋人活动
                                    mod_perfect_lover:add_wedding_times(RoleIdMan, RoleIdWon, WeddingType),
                                    case RoleId1 of
                                        RoleIdMan ->
                                            NameM = Name1,
                                            NameW = Name2;
                                        _ ->
                                            NameM = Name2,
                                            NameW = Name1
                                    end,
                                    mod_house:marriage_house(RoleIdMan, NameM, RoleIdWon, NameW, RoleId1)
                            end
                            %mod_marriage_wedding_mgr:propose_success(NewCouple#marriage_couple.role_id_m, NewCouple#marriage_couple.role_id_w, WeddingType, RoleId1)
                    end,
                    ?PRINT("answer_biaobai NewCouple ~p~n", [NewCouple]),
                    lib_marriage:sql_marriage_couple(NewCouple),
                    %% 系统主动拒绝除玩家1以外向玩家2表白的玩家
                    %% 删除sql表白/求婚数据
                    ProposeRoleIdList2 = [ProposeRoleId2||#propose_info{propose_role_id = ProposeRoleId2} <- OldProposingList2],
                    ReSql2 = io_lib:format(?DelectMProposeRoleIdAllSql, [RoleId2, ulists:list_to_string(ProposeRoleIdList2, ",")]),
                    db:execute(ReSql2),
                    OldProposingList22 = lists:keydelete(RoleId1, #propose_info.propose_role_id, OldProposingList2),
                    NewProposalList2 = lib_marriage:answer_biaobai_all(OldProposingList22, NewProposalList1, 4),
                    ProposalPlayer1 = ulists:keyfind(RoleId1, #proposal.role_id, NewProposalList2, #proposal{role_id = RoleId1}),
                    #proposal{
                        proposing_list = OldProposingList1
                    } = ProposalPlayer1,
                    %% 删除sql求婚数据
                    case OldProposingList1 of
                        [] ->
                            NewProposalList3 = NewProposalList2;
                        _ ->
                            %% 删除sql表白/求婚数据
                            ProposeRoleIdList1 = [ProposeRoleId1||#propose_info{propose_role_id = ProposeRoleId1} <- OldProposingList1],
                            ReSql1 = io_lib:format(?DelectMProposeRoleIdAllSql, [RoleId1, ulists:list_to_string(ProposeRoleIdList1, ",")]),
                            db:execute(ReSql1),
                            %% 系统主动拒绝除玩家2以外向玩家1求婚的玩家
                            OldProposingList11 = lists:keydelete(RoleId2, #propose_info.propose_role_id, OldProposingList1),
                            NewProposalList3 = lib_marriage:answer_biaobai_all(OldProposingList11, NewProposalList2, 4)
                    end,
                    case MarriageType1 >= 2 of
                        true ->
                            NewAnswerList2 = [];
                        false ->
                            NewAnswerList2 = OldAnswerList2
                    end,
                    NewProposalPlayer1 = ProposalPlayer1#proposal{
                        proposing_list = []
                    },
                    NewProposalPlayer2 = ProposalPlayer2#proposal{
                        proposing_list = [],
                        answer_list = NewAnswerList2
                    },
                    NewProposalList4 = lists:keyreplace(RoleId1, #proposal.role_id, NewProposalList3, NewProposalPlayer1),
                    NewProposalList5 = lists:keyreplace(RoleId2, #proposal.role_id, NewProposalList4, NewProposalPlayer2);
                _ ->
                    %% 删除sql求婚数据
                    ReSql1 = io_lib:format(?DelectMProposeRoleIdAllSql, [RoleId2, ulists:list_to_string([RoleId1], ",")]),
                    db:execute(ReSql1),
                    NewProposingList2 = lists:keydelete(RoleId1, #propose_info.propose_role_id, OldProposingList2),
                    NewProposalPlayer2 = ProposalPlayer2#proposal{
                        proposing_list = NewProposingList2
                    },
                    NewProposalList5 = lists:keyreplace(RoleId2, #proposal.role_id, NewProposalList1, NewProposalPlayer2),
                    NewCoupleList = CoupleList
            end,
            NewState = State#marriage_state{
                marriage_couple = NewCoupleList,
                proposal = NewProposalList5
            }
    end,
    {ok, Bin} = pt_172:write(17223, [Code, RoleId1, AnswerType]),
    lib_server_send:send_to_uid(RoleId2, Bin),
    {noreply, NewState};

do_handle_cast({sure_answer, [RoleId, OtherRid]}, State) ->
    #marriage_state{
        proposal = ProposalList
    } = State,
    case lists:keyfind(RoleId, #proposal.role_id, ProposalList) of
        false ->
            NewState = State;
        ProposalPlayer ->
            #proposal{
                answer_list = AnswerList
            } = ProposalPlayer,
            NewAnswerList = lists:keydelete(OtherRid, #answer_info.role_id, AnswerList),
            NewProposalPlayer = ProposalPlayer#proposal{
                answer_list = NewAnswerList
            },
            NewProposalList = lists:keyreplace(RoleId, #proposal.role_id, ProposalList, NewProposalPlayer),
            NewState = State#marriage_state{
                proposal = NewProposalList
            }
    end,
    {ok, Bin} = pt_172:write(17225, [?SUCCESS]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({get_login_send, RoleId}, State) ->
    #marriage_state{
        marriage_couple = _CoupleList,
        proposal = ProposalList
    } = State,
    case lists:keyfind(RoleId, #proposal.role_id, ProposalList) of
        false ->
            skip;
        ProposalPlayer ->
            #proposal{
                proposing_list = ProposingList,
                answer_list = AnswerList
            } = ProposalPlayer,
            case ProposingList =/= [] of
                true ->
                    spawn(fun() -> lib_marriage:get_login_send(RoleId, ProposingList, AnswerList) end),
                    ok;
                false ->
                    ?PRINT("get_login_send ProposingList [] ~n", []),
                    skip
            end
    end,
    {noreply, State};

do_handle_cast({open_propose, [Args1, Args2]}, State) ->
    #marriage_state{
        proposal = ProposalList,
        marriage_couple = CoupleList
    } = State,
    [RoleId1, _Name1, _CombatPower1, Lv1, Sex1, _Vip1, _Career1, _Turn1] = Args1,
    [RoleId2, Name2, CombatPower2, Lv2, Sex2, Vip2, Career2, Turn2] = Args2,
    Args11 = [RoleId1, Lv1, Sex1], %% 用于判断
    Args22 = [RoleId2, Lv2, Sex2],
    case lib_marriage:biaobai_check(CoupleList, Args11, Args22, 2, ProposalList) of
        {false, Code} ->
            skip;
        true ->
            case lists:keyfind(RoleId2, #proposal.role_id, ProposalList) of
                false ->
                    Code = ?SUCCESS;
                #proposal{proposing_list = ProposingList1} ->
                    case lists:keyfind(RoleId1, #propose_info.role_id, ProposingList1) of
                        false ->
                            Code = ?SUCCESS;
                        _ ->
                            Code = ?ERRCODE(err172_couple_not_propose_twice)
                    end
            end
    end,
    {ok, Bin} = pt_172:write(17230, [Code, RoleId2, Name2, Lv2, CombatPower2, Sex2, Vip2, Career2, Turn2]),
    lib_server_send:send_to_uid(RoleId1, Bin),
    {noreply, State};

do_handle_cast({do_divorse, [RoleId, MarriageType1, DivorceType, Args, IsFree]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = ProposalList
    } = State,
    ?PRINT("do_divorse start =====================~n", []),
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, Code} ->
            CostReturnList = lib_marriage:get_divorce_cost(MarriageType1, DivorceType, IsFree),
            Title   = ?LAN_MSG(?LAN_TITLE_DIVORCE_FAIL),
            Content = ?LAN_MSG(?LAN_CONTENT_DIVORCE_FAIL),
            CostReturnList =/= [] andalso lib_mail_api:send_sys_mail([RoleId], Title, Content, CostReturnList),
            {ok, Bin} = pt_172:write(17234, [Code]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewState = State;
        {true, CoupleInfo} ->
            %% 协商离婚, 将提出的协商离婚消息放到对方的answer_list里面
            if
                MarriageType1 == 2 andalso DivorceType == 1 ->
                    #marriage_couple{
                        role_id_m = RoleIdM,
                        role_id_w = RoleIdW
                    } = CoupleInfo,
                    case RoleIdM of
                        RoleId ->
                            OtherRid = RoleIdW;
                        _ ->
                            OtherRid = RoleIdM
                    end,
                    case lists:keyfind(OtherRid, #proposal.role_id, ProposalList) of
                        false ->
                            NewProposalPlayer1 = #proposal{
                                role_id = OtherRid,
                                divorce_info = [DivorceType]
                            };
                        ProposalPlayer1 ->
                            NewProposalPlayer1 = ProposalPlayer1#proposal{
                                divorce_info = [DivorceType]
                            }
                    end,
                    ?PRINT("do_divorse 2 ~p~n", [NewProposalPlayer1]),
                    NewProposalList = lists:keystore(OtherRid, #proposal.role_id, ProposalList, NewProposalPlayer1),
                    [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn] = Args,
                    #figure{picture = Picture, picture_ver = PictureVer} = lib_role:get_role_figure(RoleId),
                    {ok, Bin} = pt_172:write(17222, [RoleId, Name, Lv, CombatPower, Sex, Vip, Career, Turn, Picture, PictureVer, 4, 0, "", 0, []]),
                    lib_server_send:send_to_uid(OtherRid, Bin),
                    {ok, Bin2} = pt_172:write(17234, [?SUCCESS]),
                    lib_server_send:send_to_uid(RoleId, Bin2),
                    NewState = State#marriage_state{
                        proposal = NewProposalList
                    };
                MarriageType1 == 2 -> %% 强制离婚
                    {ok, Bin2} = pt_172:write(17234, [?SUCCESS]),
                    lib_server_send:send_to_uid(RoleId, Bin2),
                    NewState = do_divorse_core(State, CoupleInfo, RoleId, DivorceType, 1, Args, IsFree);
                true ->
                    NewState = State
            end
    end,
    {noreply, NewState};

do_handle_cast({do_divorse_answer, [RoleId, AnswerType, Args]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = ProposalList
    } = State,
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, Code} ->
            {ok, Bin} = pt_172:write(17235, [Code, AnswerType]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewState = State;
        {true, CoupleInfo} ->
            case lists:keyfind(RoleId, #proposal.role_id, ProposalList) of
                #proposal{divorce_info = [DivorceType]} = ProposalPlayer1 when DivorceType == 1 ->
                    NewProposalPlayer1 = ProposalPlayer1#proposal{
                        divorce_info = []
                    },
                    OtherRid = ?IF(CoupleInfo#marriage_couple.role_id_m == RoleId, CoupleInfo#marriage_couple.role_id_w, CoupleInfo#marriage_couple.role_id_m),
                    ProposalList1 = lists:keystore(RoleId, #proposal.role_id, ProposalList, NewProposalPlayer1),
                    State1 = State#marriage_state{proposal = ProposalList1},
                    {ok, Bin1} = pt_172:write(17235, [1, AnswerType]),
                    lib_server_send:send_to_uid(RoleId, Bin1),
                    case AnswerType of
                        1 ->
                            NewState = do_divorse_core(State1, CoupleInfo, RoleId, DivorceType, AnswerType, Args, false);
                        _ ->
                            [_RoleId, Name, _CombatPower, _Lv, _Sex, _Vip, _Career, _Turn] = Args,
                            {ok, Bin2} = pt_172:write(17224, [RoleId, 3, AnswerType]),
                            lib_server_send:send_to_uid(OtherRid, Bin2),
                            {ok, Bin3} = pt_172:write(17224, [OtherRid, 3, AnswerType]),
                            lib_server_send:send_to_uid(RoleId, Bin3),
                            lib_mail_api:send_sys_mail([OtherRid], utext:get(1720013), utext:get(1720014, [Name]), []),
                            NewState = State1
                    end;
                _ ->
                    NewState = State
            end
    end,
    {noreply, NewState};

do_handle_cast({get_love_dsgt, [RoleId, LoveDsgtCfg, _Args]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    #base_love_dsgt_cfg{id = Id, dsgt = DsgtId, love_num = LoveNumNeed} = LoveDsgtCfg,
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, _Code} ->
            ok;
        {true, CoupleInfo} ->
            #marriage_couple{love_num = LoveNum} = CoupleInfo,
            case LoveNumNeed =< LoveNum of
                true ->
                    {ok, Bin} = pt_172:write(17236, [1, Id]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    lib_designation_api:active_dsgt_common(RoleId, DsgtId);
                _ ->
                    ok
            end
    end,
    {noreply, State};

do_handle_cast({open_my_lover, [RoleId, HadMarriaged]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:get_couple_info(RoleId, CoupleList) of
        false ->
            {ok, Bin} = pt_172:write(17232, [?ERRCODE(err172_couple_single), 0, 0, #figure{}, 0, 0, 0, 0, HadMarriaged]),
            lib_server_send:send_to_uid(RoleId, Bin);
        {CoupleInfo, OtherRid} ->
            #marriage_couple{
                role_id_m = RoleIdM,
                type = Type,
                now_wedding_state = NowWeddingState,
                marriage_time = MarriageTime,
                love_num = LoveNum, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW
            } = CoupleInfo,
            {LoveGiftS, LoveGiftO} = ?IF(RoleId == RoleIdM, {LoveGiftM, LoveGiftW}, {LoveGiftW, LoveGiftM}),
            lib_marriage:handle_msg_with_other(OtherRid, lib_marriage, open_my_lover, [RoleId, Type, NowWeddingState, MarriageTime, LoveNum, LoveGiftS, LoveGiftO, HadMarriaged])
    end,
    {noreply, State};

do_handle_cast({add_love_num, [RoleId, AddNum]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:get_couple_info(RoleId, CoupleList) of
        false ->
            NewState = State;
        {CoupleInfo, OtherRid} ->
            #marriage_couple{
                role_id_m = RoleIdM, love_num = LoveNum, love_num_max = LoveNumMax
            } = CoupleInfo,
            NewLoveNum = LoveNum + AddNum,
            NewCoupleInfo = CoupleInfo#marriage_couple{
                love_num = NewLoveNum, love_num_max = LoveNumMax + AddNum
            },
            ?PRINT("add_love_num succ ~n", []),
            lib_marriage:sql_marriage_couple_love_num(NewCoupleInfo),
            DsgtList = data_marriage:get_dsgt_by_love(),
            case [DsgtId || {DsgtId, NeedLoveNum} <- DsgtList, NewLoveNum>=NeedLoveNum, NeedLoveNum>LoveNum] of
                [ActiveDsgtId|_] ->
                    lib_designation_api:active_dsgt_common(RoleId, ActiveDsgtId),
                    lib_designation_api:active_dsgt_common(OtherRid, ActiveDsgtId);
                _ -> ok
            end,
            {ok, Bin} = pt_172:write(17229, [[{1, LoveNum + AddNum}]]),
            lib_server_send:send_to_uid(RoleId, Bin),
            lib_server_send:send_to_uid(OtherRid, Bin),
            NewCoupleList = lists:keystore(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
            NewState = State#marriage_state{marriage_couple = NewCoupleList}
    end,
    {noreply, NewState};


do_handle_cast({buy_love_gift, [RoleId]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, Code} ->
            {ok, Bin} = pt_172:write(17237, [Code]),
            lib_server_send:send_to_uid(RoleId, Bin),
            Produce = #produce{
                type = love_gift, reward = ?LoveGiftBuyCost,
                title = ?LAN_MSG(1720011), content = ?LAN_MSG(1720012),
                off_title = ?LAN_MSG(1720011), off_content = ?LAN_MSG(1720012)
            },
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            NewState = State;
        {true, CoupleInfo} ->
            #marriage_couple{
                role_id_m = RoleIdM, role_id_w = RoleIdW, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW,
                love_gift_count_m = LoveGiftCountM, love_gift_count_w = LoveGiftCountW
            } = CoupleInfo,
            NowSec = utime:unixtime(),
            ExpireTime = ?IF( RoleId == RoleIdM, LoveGiftM, LoveGiftW),
            case NowSec >= ExpireTime of
                true ->
                    case RoleId == RoleIdM of
                        true ->
                            {NewLoveGiftM, NewLoveGiftCountM} = buy_love_gift_do(RoleId, LoveGiftM, LoveGiftCountM),
                            lib_log_api:log_buy_love_gift(RoleId, RoleIdW, 0, ?LoveGiftBuyCost, NewLoveGiftM, LoveGiftW, []),
                            ChangeGiftTime = NewLoveGiftM,
                            NewLoveGiftW = LoveGiftW, NewLoveGiftCountW = LoveGiftCountW;
                        _ ->
                            {NewLoveGiftW, NewLoveGiftCountW} = buy_love_gift_do(RoleId, LoveGiftW, LoveGiftCountW),
                            lib_log_api:log_buy_love_gift(RoleId, RoleIdM, 0, ?LoveGiftBuyCost, NewLoveGiftW, LoveGiftM, []),
                            ChangeGiftTime = NewLoveGiftW,
                            NewLoveGiftM = LoveGiftM, NewLoveGiftCountM = LoveGiftCountM
                    end,
                    NewCoupleInfo = CoupleInfo#marriage_couple{
                        love_gift_time_m = NewLoveGiftM, love_gift_time_w = NewLoveGiftW,
                        love_gift_count_m = NewLoveGiftCountM, love_gift_count_w = NewLoveGiftCountW
                    },
                    ?PRINT("buy_love_gift ~p~n", [NewCoupleInfo]),
                    lib_marriage:sql_marriage_couple_love_gift(NewCoupleInfo),
                    lib_marriage:push_love_gift_info_to_couple(NewCoupleInfo),
                    lib_server_send:send_to_uid(RoleId, pt_172, 17237, [1]),
                    lib_marriage:update_role_love_gift_info(RoleId, ChangeGiftTime),
                    NewCoupleList = lists:keystore(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
                    NewState = State#marriage_state{marriage_couple = NewCoupleList};
                _ ->
                    {ok, Bin} = pt_172:write(17237, [?ERRCODE(err172_gift_no_expire)]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    Produce = #produce{
                        type = love_gift, reward = ?LoveGiftBuyCost,
                        title = ?LAN_MSG(1720011), content = ?LAN_MSG(1720012),
                        off_title = ?LAN_MSG(1720011), off_content = ?LAN_MSG(1720012)
                    },
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                    NewState = State
            end
    end,
    {noreply, NewState};

do_handle_cast({send_love_gift_info, [RoleId]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, _Code} -> skip;
        {true, CoupleInfo} ->
            #marriage_couple{
                role_id_m = RoleIdM, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW,
                love_gift_count_m = LoveGiftCountM, love_gift_count_w = LoveGiftCountW
            } = CoupleInfo,
            case RoleId == RoleIdM of
                true ->
                    ?PRINT("send_love_gift_info m ~p~n", [{LoveGiftM, LoveGiftW, LoveGiftCountM}]),
                    lib_server_send:send_to_uid(RoleId, pt_172, 17238, [LoveGiftM, LoveGiftW, LoveGiftCountM]);
                _ ->
                    ?PRINT("send_love_gift_info w ~p~n", [{LoveGiftW, LoveGiftM, LoveGiftCountW}]),
                    lib_server_send:send_to_uid(RoleId, pt_172, 17238, [LoveGiftW, LoveGiftM, LoveGiftCountW])
            end
    end,
    {noreply, State};

do_handle_cast({get_love_gift_reward, [RoleId, CountType]}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, Code} ->
            {ok, Bin} = pt_172:write(17239, [Code, CountType, []]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewState = State;
        {true, CoupleInfo} ->
            #marriage_couple{
                role_id_m = RoleIdM, role_id_w = RoleIdW, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW,
                love_gift_count_m = LoveGiftCountM, love_gift_count_w = LoveGiftCountW
            } = CoupleInfo,
            case RoleId == RoleIdM of
                true ->
                    {Code1, NewLoveGiftCountM} = get_love_gift_reward_do(RoleId, CountType, LoveGiftM, LoveGiftW, LoveGiftCountM),
                    Code1 == 1 andalso lib_server_send:send_to_uid(RoleId, pt_172, 17238, [LoveGiftM, LoveGiftW, NewLoveGiftCountM]),
                    Code1 == 1 andalso lib_log_api:log_buy_love_gift(RoleId, RoleIdW, CountType, [], LoveGiftM, LoveGiftW, ?IF(CountType == ?LOVE_GIFT_COUNT_TYPE_1, ?LoveGiftBuyReward, ?LoveGiftLoginReward)),
                    NewLoveGiftCountW = LoveGiftCountW;
                _ ->
                    {Code1, NewLoveGiftCountW} = get_love_gift_reward_do(RoleId, CountType, LoveGiftW, LoveGiftM, LoveGiftCountW),
                    Code1 == 1 andalso lib_server_send:send_to_uid(RoleId, pt_172, 17238, [LoveGiftW, LoveGiftM, NewLoveGiftCountW]),
                    Code1 == 1 andalso lib_log_api:log_buy_love_gift(RoleId, RoleIdM, CountType, [], LoveGiftW, LoveGiftM, ?IF(CountType == ?LOVE_GIFT_COUNT_TYPE_1, ?LoveGiftBuyReward, ?LoveGiftLoginReward)),
                    NewLoveGiftCountM = LoveGiftCountM
            end,
            ?PRINT("Code1 ~p~n", [Code1]),
            ?PRINT("NewLoveGiftCountM ~p~n", [NewLoveGiftCountM]),
            ?PRINT("LoveGiftCountW ~p~n", [NewLoveGiftCountW]),
            {ok, Bin} = pt_172:write(17239, [Code1, CountType, ?IF(CountType == ?LOVE_GIFT_COUNT_TYPE_1, ?LoveGiftBuyReward, ?LoveGiftLoginReward)]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewCoupleInfo = CoupleInfo#marriage_couple{
                love_gift_count_m = NewLoveGiftCountM, love_gift_count_w = NewLoveGiftCountW
            },
            NewCoupleList = lists:keystore(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
            NewState = State#marriage_state{marriage_couple = NewCoupleList}
    end,
    {noreply, NewState};


do_handle_cast({open_wedding_order, RoleId}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:get_couple_info(RoleId, CoupleList) of
        false ->
            {ok, Bin} = pt_172:write(17250, [?ERRCODE(err172_couple_single), 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        {CoupleInfo, _OtherRid} ->
            #marriage_couple{
                type = MarriageType,
                now_wedding_state = NowWeddingState,
                others = Others
            } = CoupleInfo,
            if
                MarriageType =:= 1 ->
                    {ok, Bin} = pt_172:write(17250, [?ERRCODE(err172_marriage_life_not_marry), 0, [], []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                % NowWeddingState =:= 3 ->
                %     {ok, Bin} = pt_172:write(17250, [?ERRCODE(err172_wedding_have_order), 0, [], []]),
                %     lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    WeddingOrderTimes = get_wedding_order_times(Others),
                    F = fun({WeddingType, Times1, Times2}, L) ->
                        case WeddingType == 3 of
                            false -> [{WeddingType, Times1, Times2, 0}|L];
                            _ ->
                                [{WeddingType, Times1, Times2, mod_daily:get_count(RoleId, ?MOD_MARRIAGE, 7, utime:unixdate())}|L]
                        end
                    end,
                    NewWeddingOrderTimes = lists:foldl(F, [], WeddingOrderTimes),
                    mod_marriage_wedding_mgr:open_wedding_order([NowWeddingState, RoleId, NewWeddingOrderTimes])
            end
    end,
    {noreply, State};

do_handle_cast({wedding_order, RoleId, DayId, TimeId, WeddingType, NowWeddingState, IfReward}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = _ProposalList
    } = State,
    case lib_marriage:get_couple_info(RoleId, CoupleList) of
        false ->
            %lib_marriage_wedding:return_wedding_order_cost(RoleId, GoodsTypeId, NowWeddingState),
            {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_couple_single), 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        {CoupleInfo, _OtherRid} ->
            #marriage_couple{
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                type = MarriageType,
                now_wedding_state = NowWeddingState
            } = CoupleInfo,
            %ProposalM = lists:keyfind(RoleIdM, #proposal.role_id, ProposalList),
            %ProposalW = lists:keyfind(RoleIdW, #proposal.role_id, ProposalList),
            if
                % is_record(ProposalM, proposal) andalso ProposalM#proposal.proposing_list =/= [] ->
                %     %lib_marriage_wedding:return_wedding_order_cost(RoleId, GoodsTypeId, NowWeddingState),
                %     {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_cant_wedding_twice), 0, 0, [], []]),
                %     lib_server_send:send_to_uid(RoleId, Bin);
                % is_record(ProposalW, proposal) andalso ProposalW#proposal.proposing_list =/= []  ->
                %     %lib_marriage_wedding:return_wedding_order_cost(RoleId, GoodsTypeId, NowWeddingState),
                %     {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_cant_wedding_twice), 0, 0, [], []]),
                %     lib_server_send:send_to_uid(RoleId, Bin);
                MarriageType =:= 1 ->
                    %lib_marriage_wedding:return_wedding_order_cost(RoleId, GoodsTypeId, NowWeddingState),
                    {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_marriage_life_not_marry), 0, 0, [], []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                NowWeddingState =:= 2 ->
                    %lib_marriage_wedding:return_wedding_order_cost(RoleId, GoodsTypeId, NowWeddingState),
                    {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_wedding_have_order), 0, 0, [], []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    Args = [RoleIdM, RoleIdW, DayId, TimeId, WeddingType, NowWeddingState, IfReward],
                    mod_marriage_wedding_mgr:wedding_order(RoleId, Args)
            end
    end,
    {noreply, State};

do_handle_cast({wedding_order_success, RoleId, WeddingTime, WeddingType}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    {CoupleInfo, OtherRid} = lib_marriage:get_couple_info(RoleId, CoupleList),
    #marriage_couple{
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        now_wedding_state = NowWeddingState,
        marriage_time = MarriageTime,
        love_num = LoveNum,
        love_gift_time_m = LoveGiftM,
        love_gift_time_w = LoveGiftW,
        others = Others
    } = CoupleInfo,
    case NowWeddingState of
        2 ->
            NewNowWeddingState = 2;
        _ ->
            NewNowWeddingState = 2
    end,
    NewOthers = increase_wedding_order_times(Others, WeddingType),
    NewCoupleInfo = CoupleInfo#marriage_couple{
        now_wedding_state = NewNowWeddingState,
        others = NewOthers
    },
    %lib_marriage:sql_marriage_couple(NewCoupleInfo),
    lib_marriage:sql_marriage_couple_update([{now_wedding_state, NewNowWeddingState}, {others, util:term_to_bitstring(NewOthers)}], [{role_id_m, RoleIdM}]),
    NewCoupleList = lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
    NewState = State#marriage_state{
        marriage_couple = NewCoupleList
    },
    ?PRINT("wedding_order_success ~n", []),
    lib_player:apply_cast(RoleIdM, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleIdW, 0, NewNowWeddingState, MarriageTime, LoveNum, LoveGiftW, LoveGiftM]),
    lib_player:apply_cast(RoleIdW, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleIdM, 0, NewNowWeddingState, MarriageTime, LoveNum, LoveGiftM, LoveGiftW]),
    %lib_offline_api:apply_cast(lib_marriage_wedding, wedding_order_success, [RoleId, OtherRid, WeddingTime, WeddingType]),
    spawn(fun() -> lib_marriage_wedding:wedding_order_success(RoleId, OtherRid, WeddingTime, WeddingType) end),
    {noreply, NewState};

do_handle_cast({wedding_start, RoleIdM, WeddingPid}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    CoupleInfo = lists:keyfind(RoleIdM, #marriage_couple.role_id_m, CoupleList),
    #marriage_couple{
        role_id_w = RoleIdW,
        now_wedding_state = NowWeddingState,
        marriage_time = MarriageTime,
        love_num = LoveNum, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW
    } = CoupleInfo,
    NewCoupleInfo = CoupleInfo#marriage_couple{
        wedding_pid = WeddingPid
    },
    NewCoupleList = lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
    NewState = State#marriage_state{
        marriage_couple = NewCoupleList
    },
    lib_player:apply_cast(RoleIdM, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleIdW, WeddingPid, NowWeddingState, MarriageTime, LoveNum, LoveGiftM, LoveGiftW]),
    lib_player:apply_cast(RoleIdW, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleIdM, WeddingPid, NowWeddingState, MarriageTime, LoveNum, LoveGiftW, LoveGiftM]),
    {noreply, NewState};

do_handle_cast({wedding_end, RoleIdM}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    CoupleInfo = lists:keyfind(RoleIdM, #marriage_couple.role_id_m, CoupleList),
    #marriage_couple{
        role_id_w = RoleIdW,
        marriage_time = MarriageTime,
        love_num = LoveNum, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW
    } = CoupleInfo,
    NewCoupleInfo = CoupleInfo#marriage_couple{
        wedding_pid = 0,
        now_wedding_state = 0
    },
    lib_marriage:sql_marriage_couple(NewCoupleInfo),
    NewCoupleList = lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
    NewState = State#marriage_state{
        marriage_couple = NewCoupleList
    },
    lib_player:apply_cast(RoleIdM, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleIdW, 0, 0, MarriageTime, LoveNum, LoveGiftM, LoveGiftW]),
    lib_player:apply_cast(RoleIdW, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage_wedding, set_wedding_pid_and_state, [RoleIdM, 0, 0, MarriageTime, LoveNum, LoveGiftW, LoveGiftM]),
    {noreply, NewState};

do_handle_cast({change_now_wedding_state, DeleteRoleIdMList}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    F = fun(RoleIdM, {SqlStrList1, NewCoupleList1}) ->
        case lists:keyfind(RoleIdM, #marriage_couple.role_id_m, NewCoupleList1) of
            false ->
                {SqlStrList1, NewCoupleList1};
            CoupleInfo ->
                #marriage_couple{
                    role_id_w = RoleIdW,
                    type = Type,
                    marriage_time = MarriageTime,
                    love_num = LoveNum,
                    love_num_max = LoveNumMax,
                    love_gift_time_m = LoveGiftM,
                    love_gift_time_w = LoveGiftW,
                    others = Others
                } = CoupleInfo,
                NewCoupleInfo = CoupleInfo#marriage_couple{
                    wedding_pid = 0,
                    now_wedding_state = 0
                },
                SqlStr = io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s')", [RoleIdM, RoleIdW, Type, 0, MarriageTime, LoveNum, LoveNumMax, LoveGiftM, LoveGiftW, util:term_to_bitstring(Others)]),
                NewCoupleList2 = lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, NewCoupleList1, NewCoupleInfo),
                {[SqlStr|SqlStrList1], NewCoupleList2}
        end
    end,
    {SqlStrList, NewCoupleList} = lists:foldl(F, {[], CoupleList}, DeleteRoleIdMList),
    case SqlStrList of
        [] ->
            skip;
        _ ->
            SqlStrListStr = ulists:list_to_string(SqlStrList, ","),
            ReSql = io_lib:format(?ReplaceMCoupleAllSql, [SqlStrListStr]),
            db:execute(ReSql)
    end,
    NewState = State#marriage_state{
        marriage_couple = NewCoupleList
    },
    {noreply, NewState};

do_handle_cast({throw_dog_food, RoleId, TypeId}, State) ->
    #marriage_state{
        marriage_couple = CoupleList,
        dog_food_list = DogFoodList
    } = State,
    CoupleM = lists:keyfind(RoleId, #marriage_couple.role_id_m, CoupleList),
    CoupleW = lists:keyfind(RoleId, #marriage_couple.role_id_w, CoupleList),
    CoupleInfo = case CoupleM of
        false ->
            CoupleW;
        _ ->
            CoupleM
    end,
    case CoupleInfo of
        false ->
            NewState = State;
        _ ->
            #marriage_couple{
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                dog_food_id_max = DogFoodIdMax
            } = CoupleInfo,
            NewDogFoodIdMax = DogFoodIdMax + 1,
            NewCoupleInfo = CoupleInfo#marriage_couple{
                dog_food_id_max = NewDogFoodIdMax
            },
            NewCoupleList = lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
            NewDogFood = #dog_food_info{
                role_id_m = RoleIdM,
                role_id_w = RoleIdW,
                type_id = TypeId,
                dog_food_id = NewDogFoodIdMax
            },
            NewDogFoodList = [NewDogFood|DogFoodList],
            NewState = State#marriage_state{
                marriage_couple = NewCoupleList,
                dog_food_list = NewDogFoodList
            },
            Args = [RoleId, RoleIdM, RoleIdW, NewDogFoodIdMax, TypeId],
            lib_offline_api:apply_cast(lib_marriage, throw_dog_food, [Args])
    end,
    {noreply, NewState};

do_handle_cast({get_dog_food, RoleId, RoleIdM, RoleIdW, DogFoodId}, State) ->
    #marriage_state{
        dog_food_list = DogFoodList
    } = State,
    case lib_marriage:check_get_dog_food(DogFoodList, DogFoodList, RoleId, RoleIdM, RoleIdW, DogFoodId) of
        {false, Code} ->
            NewState = State,
            GoodsNum = 0;
        {true, NewDogFoodList, RewardList} ->
            Code = ?ERRCODE(err172_df_get_success),
            [{_GoodsType, _GoodsTypeId, GoodsNum}|_] = RewardList,
            NewState = State#marriage_state{
                dog_food_list = NewDogFoodList
            },
            lib_goods_api:send_reward_by_id(RewardList, dog_food, RoleId);
        {delete, NewDogFoodList, RewardList} ->
            Code = ?ERRCODE(err172_df_get_success),
            [{_GoodsType, _GoodsTypeId, GoodsNum}|_] = RewardList,
            NewState = State#marriage_state{
                dog_food_list = NewDogFoodList
            },
            lib_goods_api:send_reward_by_id(RewardList, dog_food, RoleId),
            {ok, Bin1} = pt_172:write(17244, [2, RoleIdM, RoleIdW, DogFoodId, "", "", 0]),
            lib_server_send:send_to_all(Bin1)
    end,
    {ok, Bin} = pt_172:write(17243, [Code, RoleIdM, RoleIdW, DogFoodId, GoodsNum]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

%% -----------------------------------------------------------------
%% @desc  增加婚礼类型次数
%% @param RoleId  角色id
%% @param WeddingType 婚礼类型 1:精致婚礼 2：豪门婚礼 3：简约婚礼
%% @return  {noreply, NewState}
%% -----------------------------------------------------------------
do_handle_cast({gm_add_wedding_times, RoleId, WeddingType}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:get_couple_info(RoleId, CoupleList) of
        {CoupleInfo, _OtherRid} ->
            ProposeType = ?IF(is_integer(WeddingType), get_wedding_type(WeddingType), get_wedding_type(CoupleInfo#marriage_couple.others)),
            NewCoupleInfo = update_wedding_times(CoupleInfo, ProposeType),
            #marriage_couple{
                role_id_m = RoleIdM,
                others = NewOthers
            } = NewCoupleInfo,
            lib_marriage:sql_marriage_couple_update([{others, util:term_to_bitstring(NewOthers)}], [{role_id_m, RoleIdM}]),
            NewCoupleList = lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
            NewState = State#marriage_state{
                marriage_couple = NewCoupleList
            },
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({gm_wedding_feast, RoleId}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:get_couple_info(RoleId, CoupleList) of
        {CoupleInfo, _OtherRid} ->
            #marriage_couple{
                role_id_m = RoleIdM,
                wedding_pid = WeddingPid
            } = CoupleInfo,
            case misc:is_process_alive(WeddingPid) of
                true -> gen_server:cast(WeddingPid, {gm_wedding_feast, RoleIdM});
                _ -> skip
            end,
            {noreply, State};
        _ ->
            {noreply, State}
    end;

do_handle_cast({gm_wedding_anime, RoleId}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:get_couple_info(RoleId, CoupleList) of
        {CoupleInfo, _OtherRid} ->
            #marriage_couple{
                role_id_m = RoleIdM,
                wedding_pid = WeddingPid
            } = CoupleInfo,
            case misc:is_process_alive(WeddingPid) of
                true -> gen_server:cast(WeddingPid, {gm_wedding_anime, RoleIdM});
                _ -> skip
            end,
            {noreply, State};
        _ ->
            {noreply, State}
    end;

do_handle_cast({gm_restore_old_player_wedding_times, List}, State) ->
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    F = fun({RoleId, OtherId, WeddingType}, TmpCoupleList) ->
        case lib_marriage:get_couple_info(RoleId, TmpCoupleList) of
            {CoupleInfo, OtherId} ->
                #marriage_couple{
                    role_id_m = RoleIdM
                } = CoupleInfo,
                NewCoupleInfo = update_wedding_times(CoupleInfo, WeddingType),
                #marriage_couple{others = NewOthers} = NewCoupleInfo,
                lib_marriage:sql_marriage_couple_update([{others, util:term_to_bitstring(NewOthers)}], [{role_id_m, RoleIdM}]),
                NewTmpCoupleList = lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, TmpCoupleList, NewCoupleInfo),
                NewTmpCoupleList;
            _ ->
                TmpCoupleList
        end
    end,
    NewCoupleList = lists:foldl(F, CoupleList, List),
    {noreply, State#marriage_state{marriage_couple = NewCoupleList}};

do_handle_cast({gm_update_wedding_day, RoleId, LoveDay}, State) when is_integer(LoveDay)->
    #marriage_state{marriage_couple = CoupleList} = State,
    NewCoupleList =
        case lib_marriage:get_couple_info(RoleId, CoupleList) of
            {CoupleInfo, _OtherId} ->
                #marriage_couple{role_id_m = RoleIdM} = CoupleInfo,
                %% 更新恋爱天数
                NowTime = utime:unixtime(),
                NewLoveTime = NowTime - ?ONE_DAY_SECONDS * LoveDay,
                NewCoupleInfo = CoupleInfo#marriage_couple{marriage_time = NewLoveTime},
                lib_marriage:sql_marriage_couple(NewCoupleInfo),
                lists:keyreplace(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo);
        _ -> CoupleList
    end,
    {noreply, State#marriage_state{marriage_couple = NewCoupleList}};

do_handle_cast({gm_clear_hall_information}, State) ->
    db:execute(io_lib:format(?DeleteMPPlayerSql, [])),
    {noreply, State#marriage_state{personals = []}};

do_handle_cast({gm_change_gift_time, RoleId}, State) ->
    CountType = 1,
    #marriage_state{
        marriage_couple = CoupleList
    } = State,
    case lib_marriage:divorce_check(CoupleList, RoleId) of
        {false, Code} ->
            NewState = State;
        {true, CoupleInfo} ->
            #marriage_couple{
                role_id_m = RoleIdM, role_id_w = RoleIdW, love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW,
                love_gift_count_m = LoveGiftCountM, love_gift_count_w = LoveGiftCountW
            } = CoupleInfo,
            case RoleId == RoleIdM of
                true ->
                    {Code1, NewLoveGiftCountM} = change_time(RoleId, LoveGiftCountM),
                    Code1 == 1 andalso lib_log_api:log_buy_love_gift(RoleId, RoleIdW, CountType, [], LoveGiftM, LoveGiftW, ?IF(CountType == ?LOVE_GIFT_COUNT_TYPE_1, ?LoveGiftBuyReward, ?LoveGiftLoginReward)),
                    NewLoveGiftCountW = LoveGiftCountW, NewLoveGiftW = LoveGiftW, NewLoveGiftM = utime:unixtime();
                _ ->
                    {Code1, NewLoveGiftCountW} = change_time(RoleId, LoveGiftCountW),
                    Code1 == 1 andalso lib_server_send:send_to_uid(RoleId, pt_172, 17238, [LoveGiftW, LoveGiftM, NewLoveGiftCountW]),
                    Code1 == 1 andalso lib_log_api:log_buy_love_gift(RoleId, RoleIdM, CountType, [], LoveGiftW, LoveGiftM, ?IF(CountType == ?LOVE_GIFT_COUNT_TYPE_1, ?LoveGiftBuyReward, ?LoveGiftLoginReward)),
                    NewLoveGiftCountM = LoveGiftCountM, NewLoveGiftM = LoveGiftM, NewLoveGiftW = utime:unixtime()
            end,
            NewCoupleInfo = CoupleInfo#marriage_couple{
                love_gift_count_m = NewLoveGiftCountM, love_gift_count_w = NewLoveGiftCountW, love_gift_time_m = NewLoveGiftM, love_gift_time_w = NewLoveGiftW
            },
            NewCoupleList = lists:keystore(RoleIdM, #marriage_couple.role_id_m, CoupleList, NewCoupleInfo),
            NewState = State#marriage_state{marriage_couple = NewCoupleList}
    end,
    {noreply, NewState};

do_handle_cast({'stop'}, State) ->
    {stop, normal, State};

do_handle_cast(_Info, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_info({'stop'}, State)->
    gen_server:cast(self(), {'stop'}),
    {noreply, State};

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


do_divorse_core(State, CoupleInfo, RoleId, DivorceType, AnswerType, _Args, IsFree) ->
    #marriage_state{
        marriage_couple = CoupleList,
        proposal = ProposalList
    } = State,
    #marriage_couple{
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        type = MarriageType,
        now_wedding_state = NowWeddingState,
        love_num = LoveNum
    } = CoupleInfo,
    case RoleIdM of
        RoleId ->
            OtherRid = RoleIdW;
        _ ->
            OtherRid = RoleIdM
    end,
    CostList = lib_marriage:get_divorce_cost(MarriageType, DivorceType, IsFree),
    %% 处理离婚时，如果已经再次向对方求婚，但求婚信息没回应的情况
    {ProposalList1, AnswerList1} = handle_after_divorse(OtherRid, ProposalList),
    {ProposalList2, AnswerList2} = handle_after_divorse(RoleId, ProposalList1),
    %% 删除数据
    ReSql = io_lib:format(?DeleteMCoupleMSql, [RoleIdM]),
    DelSql1 = io_lib:format(?DeleteMLoveGiftCountSql, [RoleIdM]),
    DelSql2 = io_lib:format(?DeleteMLoveGiftCountSql, [RoleIdW]),
    db:execute(ReSql),
    db:execute(DelSql1),
    db:execute(DelSql2),
    NewCoupleList = lists:delete(CoupleInfo, CoupleList),
    mod_marriage_wedding_mgr:divorce_success(RoleIdM, RoleIdW, NowWeddingState),
    lib_player:apply_cast(RoleIdM, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage, divorce_success_change, []),
    lib_role:update_role_show(RoleIdM, [{clear_marriage, 1}]),
    lib_player:apply_cast(RoleIdW, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_marriage, divorce_success_change, []),
    lib_role:update_role_show(RoleIdW, [{clear_marriage, 1}]),
    lib_marriage:cancel_marriage_designation(RoleIdM, RoleIdW),
    %% 通知客户端离婚
    {ok, Bin2} = pt_172:write(17224, [RoleId, 3, AnswerType]),
    lib_server_send:send_to_uid(OtherRid, Bin2),
    {ok, Bin3} = pt_172:write(17224, [OtherRid, 3, AnswerType]),
    lib_server_send:send_to_uid(RoleId, Bin3),
    %% 移除结婚称号
    lib_designation_api:remove_dsgt(RoleIdM, ?MARRIAGE_DSGT),
    lib_designation_api:remove_dsgt(RoleIdW, ?MARRIAGE_DSGT),
    %% 清空亲密度
    lib_relationship:clear_intimacy_each_one(RoleId, OtherRid, [divorce]),
    %% 离婚房子处理
    mod_house:divorce_house(RoleIdM, RoleIdW),
    %% 日志
    lib_log_api:log_marriage_divorse(RoleIdM, RoleIdW, RoleId, MarriageType, CostList),
    %% 离婚时候根据恩爱值返还相应的道具
    Div = util:floor(LoveNum / 2),
    case Div > 0 of
        true ->
            ReturnRewards = [{0, ?DISCOVER_RETURN_ITEM, Div}],
            Title = utext:get(1720025),
            Content = utext:get(1720026),
            lib_mail_api:send_sys_mail([RoleIdM, RoleIdW], Title, Content, ReturnRewards);
        _ ->
            skip
    end,
    %% 最后处理回应信息
    ProposalList3 = lib_marriage:answer_biaobai_all(AnswerList1, ProposalList2, 5),
    NewProposalList = lib_marriage:answer_biaobai_all(AnswerList2, ProposalList3, 5),
    % TA数据上报
    TAType = ?IF(DivorceType == 1, ?TA_MARRIAGE_DIVORCE_PROTO, ?TA_MARRIAGE_DIVORCE_FORCE),
    lib_player:apply_cast(RoleIdM, ?APPLY_CAST_STATUS, ta_agent_fire, marriage_state, [RoleIdW, TAType]),
    lib_player:apply_cast(RoleIdW, ?APPLY_CAST_STATUS, ta_agent_fire, marriage_state, [RoleIdM, TAType]),
    State#marriage_state{
        proposal = NewProposalList,
        marriage_couple = NewCoupleList
    }.

handle_after_divorse(RoleId, ProposalList) ->
    case lists:keyfind(RoleId, #proposal.role_id, ProposalList) of
        false ->
            {ProposalList, []};
        ProposalPlayer1 ->
            #proposal{
                proposing_list = ProposingList1,
                answer_list = _AnswerList
            } = ProposalPlayer1,
            case ProposingList1 of
                [] -> L1 = [];
                L1 ->
                    ProposeIdList1 = [PR1 || #propose_info{propose_role_id = PR1} <- L1],
                    ?PRINT("handle_after_divorse ProposeIdList1 ~p~n", [ProposeIdList1]),
                    ReSql1 = io_lib:format(?DelectMProposeRoleIdAllSql, [RoleId, ulists:list_to_string(ProposeIdList1, ",")]),
                    db:execute(ReSql1)
            end,
            NewProposalPlayer1 = ProposalPlayer1#proposal{
                proposing_list = [],
                divorce_info = []
            },
            NewProposalList = lists:keystore(RoleId, #proposal.role_id, ProposalList, NewProposalPlayer1),
            {NewProposalList, L1}
    end.

buy_love_gift_do(RoleId, LoveGift, LoveGiftCount) ->
    ExpireTime = ?LoveGiftExpireDay * ?ONE_DAY_SECONDS,
    NewLoveGift = ?IF(LoveGift < utime:unixtime(), utime:unixtime() + ExpireTime, LoveGift + ExpireTime),
    case lists:keyfind(?LOVE_GIFT_COUNT_TYPE_1, 1, LoveGiftCount) of
        {_, State, _Time} when State == 0 ->
            % Produce = #produce{
            %     type = love_gift, reward = ?LoveGiftBuyReward,
            %     title = ?LAN_MSG(1720009), content = ?LAN_MSG(1720010),
            %     off_title = ?LAN_MSG(1720009), off_content = ?LAN_MSG(1720010)
            % },
            Title = ?LAN_MSG(1720009),
            Content = ?LAN_MSG(1720010),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, ?LoveGiftBuyReward); %% 之前买了，还没领取，发邮件
        _ -> ok
    end,
    CanGetTime = utime:get_logic_day_start_time() + ?WAIT_DAY * ?ONE_DAY_SECONDS,
    NewLoveGiftCount = lists:keystore(?LOVE_GIFT_COUNT_TYPE_1, 1, LoveGiftCount, {?LOVE_GIFT_COUNT_TYPE_1, 0, CanGetTime}),
    lib_marriage:replace_love_gift_count(RoleId, ?LOVE_GIFT_COUNT_TYPE_1, 0, CanGetTime),
    {NewLoveGift, NewLoveGiftCount}.

get_love_gift_reward_do(RoleId, CountType, LoveGiftS, LoveGiftO, LoveGiftCountS) ->
    case CountType of
        ?LOVE_GIFT_COUNT_TYPE_1 -> %% 购买返还奖励
            NowTime = utime:unixtime(),
            case lists:keyfind(?LOVE_GIFT_COUNT_TYPE_1, 1, LoveGiftCountS) of
                {_, 0, RewardTime} when NowTime >= RewardTime ->
                    NewLoveGiftCountS = lists:keystore(?LOVE_GIFT_COUNT_TYPE_1, 1, LoveGiftCountS, {?LOVE_GIFT_COUNT_TYPE_1, 1, NowTime}),
                    lib_marriage:replace_love_gift_count(RoleId, ?LOVE_GIFT_COUNT_TYPE_1, 1, NowTime),
                    Produce = #produce{
                        type = love_gift, reward = ?LoveGiftBuyReward,
                        title = ?LAN_MSG(1720009), content = ?LAN_MSG(1720010),
                        off_title = ?LAN_MSG(1720009), off_content = ?LAN_MSG(1720010)
                    },
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                    {1, NewLoveGiftCountS};
                {_, 0, _} -> {?ERRCODE(err172_gift_no_in_get_time), LoveGiftCountS};
                {_, 1, _} -> {?ERRCODE(err172_love_gift_get), LoveGiftCountS};
                _ -> {?ERRCODE(err172_love_gift_not_buy), LoveGiftCountS}
            end;
        ?LOVE_GIFT_COUNT_TYPE_2 ->
            NowTime = utime:unixtime(),
            NowDateTime = utime_logic:get_logic_day_start_time() + ?ONE_DAY_SECONDS - 1,
            case lists:keyfind(?LOVE_GIFT_COUNT_TYPE_2, 1, LoveGiftCountS) of
                {_, State, Time} -> ok;
                _ -> State = 0, Time = 0
            end,
            %IsSameDay=  utime:is_same_day(NowDateTime, Time),
            IsSameDay = utime_logic:is_logic_same_day(Time),
            if
                NowTime > LoveGiftO -> {?ERRCODE(err172_love_gift_expire), LoveGiftCountS};
                State == 1 andalso IsSameDay == true -> {?ERRCODE(err172_love_gift_get), LoveGiftCountS};
                true ->
                    NewLoveGiftCountS = lists:keystore(?LOVE_GIFT_COUNT_TYPE_2, 1, LoveGiftCountS, {?LOVE_GIFT_COUNT_TYPE_2, 1, NowDateTime}),
                    lib_marriage:replace_love_gift_count(RoleId, ?LOVE_GIFT_COUNT_TYPE_2, 1, NowDateTime),
                    Produce = #produce{
                        type = love_gift, reward = ?LoveGiftLoginReward,
                        title = ?LAN_MSG(1720009), content = ?LAN_MSG(1720010),
                        off_title = ?LAN_MSG(1720009), off_content = ?LAN_MSG(1720010)
                    },
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                    {1, NewLoveGiftCountS}
            end;
        _ -> {?ERRCODE(err172_love_gift_type_err), LoveGiftCountS}
    end.

%% 只记录最后一次结婚的类型
update_wedding_type(CoupleInfo, WeddingType) ->
    #marriage_couple{others = OldOthers} = CoupleInfo,
    NewOthers = lists:keystore(?COUPLE_OTHER_KEY_2, 1, OldOthers, {?COUPLE_OTHER_KEY_2, [WeddingType]}),
    CoupleInfo#marriage_couple{others = NewOthers}.

%% 根据婚礼类型获取求婚类型
get_wedding_type(WeddingType) ->
    ProposeIdList = data_marriage:get_wedding_type_list(),
    F = fun(PType) ->
        #base_propose_cfg{
            wedding_times = [{WType, _}]
        } = data_marriage:get_propose_info(PType),
        WType == WeddingType
        end,
    {ok, ProposeType} = ulists:find(F, ProposeIdList),
    ProposeType.

update_wedding_times(CoupleInfo, ProposeType) ->
    #marriage_couple{others = Others} = CoupleInfo,
    case data_marriage:get_propose_info(ProposeType) of
        #base_propose_cfg{wedding_times = WeddingTimes} ->
            F = fun({Type, Times}, OldOthers) ->
                {_, WeddingOrderTimes} = ulists:keyfind(?COUPLE_OTHER_KEY_1, 1, OldOthers, {?COUPLE_OTHER_KEY_1, []}),
                {_, OrderTimes, FreeTimes} = ulists:keyfind(Type, 1, WeddingOrderTimes, {Type, 0, 0}),
                NewWeddingOrderTimes = lists:keystore(Type, 1, WeddingOrderTimes, {Type, OrderTimes, FreeTimes+Times}),
                lists:keystore(?COUPLE_OTHER_KEY_1, 1, OldOthers, {?COUPLE_OTHER_KEY_1, NewWeddingOrderTimes})
            end,
            NewOthers = lists:foldl(F, Others, WeddingTimes),
            CoupleInfo#marriage_couple{others = NewOthers};
        _ ->
            CoupleInfo
    end.

get_wedding_order_times(Others) ->
    {_, WeddingOrderTimes} = ulists:keyfind(?COUPLE_OTHER_KEY_1, 1, Others, {?COUPLE_OTHER_KEY_1, []}),
    WeddingOrderTimes.

increase_wedding_order_times(Others, WeddingType) ->
    {_, WeddingOrderTimes} = ulists:keyfind(?COUPLE_OTHER_KEY_1, 1, Others, {?COUPLE_OTHER_KEY_1, []}),
    {_, OrderTimes, FreeTimes} = ulists:keyfind(WeddingType, 1, WeddingOrderTimes, {WeddingType, 0, 0}),
    NewWeddingOrderTimes = lists:keystore(WeddingType, 1, WeddingOrderTimes, {WeddingType, OrderTimes+1, FreeTimes}),
    lists:keystore(?COUPLE_OTHER_KEY_1, 1, Others, {?COUPLE_OTHER_KEY_1, NewWeddingOrderTimes}).

change_time(RoleId,  LoveGiftCountS) ->
    NowTime = utime:unixtime(),
    case lists:keyfind(?LOVE_GIFT_COUNT_TYPE_1, 1, LoveGiftCountS) of
        {_, 0, _} ->
            NewLoveGiftCountS = lists:keystore(?LOVE_GIFT_COUNT_TYPE_1, 1, LoveGiftCountS, {?LOVE_GIFT_COUNT_TYPE_1, 0, NowTime}),
            lib_marriage:replace_love_gift_count(RoleId, ?LOVE_GIFT_COUNT_TYPE_1, 0, NowTime),
            {1, NewLoveGiftCountS};
        {_, 1, _} ->
            {?ERRCODE(err172_love_gift_get), LoveGiftCountS};
        _ ->
            {?ERRCODE(err172_love_gift_not_buy), LoveGiftCountS}
    end.