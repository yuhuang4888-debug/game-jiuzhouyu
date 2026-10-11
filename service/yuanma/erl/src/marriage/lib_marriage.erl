%%%--------------------------------------
%%% @Module  : lib_marriage
%%% @Author  : huyihao
%%% @Created : 2017.11.17
%%% @Description:  婚姻
%%%--------------------------------------

-module (lib_marriage).

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("marriage.hrl").
-include("figure.hrl").
-include("relationship.hrl").
-include("language.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("role.hrl").
-include("dungeon.hrl").
-include("designation.hrl").
-include("vip.hrl").
-include("guild.hrl").

-export ([
    init_couples/0,
    init_personals/0,
    init_proposal/0,
    marriage_login/2,
    marriage_logout/2,
    marriage_status_login/1,
    ring_login/1,
    count_ring_attr_list/3,
    count_ring_attribute/1,
    sql_ring_player/1,
    check_ring_max/2,
    check_marriage_life_max/2,
    ring_upgrade/4,
    ring_upgrade_all/6,
    check_biaobai_self/3,
    get_lover_info/1,
    biaobai_check/5,
    divorce_check/2,
    marriage_behavior/7,
    answer_biaobai_all/3,
    answer_biaobai_one/3,
    answer_biaobai_one_result/8,
    sql_marriage_couple/1,
    sql_marriage_propose/1,
    biaobai_change/3,
    divorce_success_change/1,
    get_login_send/3,
    open_my_lover/9,
    get_marriage_life_attr/1,
    sql_marriage_life/1,
    get_couple_info/2,
    baby_knowledge_upgrade/3,
    check_baby_knowledge_max/2,
    sql_baby/3,
    baby_knowledge_upgrade_all/5,
    baby_login/1,
    baby_image_upgrade/4,
    baby_image_upgrade_all/5,
    baby_attr/1,
    count_baby_attribute/1,
    throw_dog_food/1,
    check_get_dog_food/6,
    follow_cancel_personals/4,
    open_biaobai/3,
    send_biaobai/4,
    cancel_marriage_designation/2,
    change_ps_personals/1,
    check_marriage_done/2,
    handle_event/2,
    lover_name_change/2,
    get_lover_info_db/1,
    handle_msg_with_other/4,
    get_divorce_cost/3,
    push_love_gift_info_to_couple/1,
    add_love_num/2,
    use_ring_goods/4,
    gm_restore_old_player_wedding_times/0,
    is_marriage/1,
    one_invite_role/1,
    do_one_invite_role/2,
    update_role_love_gift_info/2
]).

-compile(export_all).

init_couples() ->
    case db:get_all(?SelectMCoupleAllSql) of
        [] ->
            CoupleList = [];
        CoupleAllSqlList ->
            GiftCountMap = init_all_love_gift_count(),
            CoupleList = [begin
                [RoleIdM, RoleIdW, Type, NowWeddingState, MarriageTime, LoveNum, LoveNumMax, LoveGiftM, LoveGiftW, OthersB] = CoupleSql,
                LoveGiftCountM = maps:get(RoleIdM, GiftCountMap, []),
                LoveGiftCountW = maps:get(RoleIdW, GiftCountMap, []),
                %?PRINT("LoveGiftCountM ~p~n", [LoveGiftCountM]),
                #marriage_couple{
                    role_id_m = RoleIdM,
                    role_id_w = RoleIdW,
                    type = Type,
                    now_wedding_state = NowWeddingState,
                    marriage_time = MarriageTime,
                    love_num = LoveNum,
                    love_num_max = LoveNumMax,
                    love_gift_time_m = LoveGiftM,
                    love_gift_time_w = LoveGiftW,
                    love_gift_count_m = LoveGiftCountM,
                    love_gift_count_w = LoveGiftCountW,
                    others = util:bitstring_to_term(OthersB)
                }
            end||CoupleSql <- CoupleAllSqlList]
    end,
    CoupleList.

init_personals() ->
    case db:get_all(?SelectMPPlayerAllSql) of
        [] ->
            PersonalsList = [];
        PersonalsAllSqlList ->
            PersonalsFollowAllList = db:get_all(?SelectMPFollowAllSql),
            RoleLvList = db:get_all(io_lib:format(<<"select `id`, `lv` from `player_low` where `lv` >= ~p">>, [?PersonalOpenLv])),
            RoleLvMap = lists:foldl(fun([RoleId, RoleLv], Map) -> maps:put(RoleId, RoleLv, Map) end, #{}, RoleLvList),
            PersonalsList = [begin
                [RoleId, Name, Sex, Vip, Career, Turn, Msg, Picture, PictureVer, Type, TagListB, Time, VipExp, VipHide, IsSupvip] = PersonalsSql,
                FansList = get_fans_list_db(RoleId, PersonalsFollowAllList),
                TagList = util:bitstring_to_term(TagListB),
                RoleLv = maps:get(RoleId, RoleLvMap, 0),
                PersonalsInfo = #personals_player{
                    role_id = RoleId,
                    lv = RoleLv,
                    name = Name,
                    sex = Sex,
                    vip = Vip,
                    career = Career,
                    turn = Turn,
                    msg = Msg,
                    picture = Picture,
                    picture_ver = PictureVer,
                    fans_list = FansList,
                    type = Type,
                    tag_list = TagList,
                    time = Time,
                    vip_exp = VipExp,
                    vip_hide = VipHide,
                    is_supvip = IsSupvip
                },
                PersonalsInfo
            end||PersonalsSql <- PersonalsAllSqlList]
    end,
    PersonalsList.

init_proposal() ->
    case db:get_all(?SelectMProposeAllSql) of
        [] ->
            ProposalList = [];
        ProposalAllSqlList ->
            F = fun(ProposalSql, ProposalList1) ->
                [RoleId, ProposeRoleId, Type, ProposeType, Msg, SCostList, SOtherCostList, CostKey, Time] = ProposalSql,
                CostList = util:bitstring_to_term(SCostList),
                OtherCostList = util:bitstring_to_term(SOtherCostList),
                NewProposeInfo = #propose_info{
                    role_id = RoleId,
                    propose_role_id = ProposeRoleId,
                    type = Type,
                    propose_type = ProposeType,
                    msg = Msg,
                    cost_list = CostList,
                    other_cost_list = OtherCostList,
                    cost_key = CostKey,
                    time = Time
                },
                case lists:keyfind(RoleId, #proposal.role_id, ProposalList1) of
                    false ->
                        NewProposalPlayer = #proposal{
                            role_id = RoleId,
                            proposing_list = [NewProposeInfo]
                        };
                    ProposalPlayer ->
                        ProposingList = ProposalPlayer#proposal.proposing_list,
                        NewProposalPlayer = ProposalPlayer#proposal{
                            proposing_list = [NewProposeInfo|ProposingList]
                        }
                end,
                lists:keystore(RoleId, #proposal.role_id, ProposalList1, NewProposalPlayer)
            end,
            ProposalList = lists:foldl(F, [], ProposalAllSqlList)
    end,
    ProposalList.

init_all_love_gift_count() ->
    case db:get_all(?SelectMLoveGiftCountAll) of
        [] -> #{};
        List ->
            F = fun([RoleId, CountType, State, Time], M) ->
                OL = maps:get(RoleId, M, []),
                maps:put(RoleId, [{CountType, State, Time}|OL], M)
            end,
            lists:foldl(F, #{}, List)
    end.

%% 玩家登录
marriage_login(Ps, GoodsStatus) ->
    #player_status{
        id = RoleId,
        dsgt_status = #dsgt_status{dsgt_map = DsgtMap},
        figure = Figure
    } = Ps,
    #goods_status{
        ring = #ring{stage = Stage, star = Star}
    } = GoodsStatus,
    #figure{lv = RoleLv, name = Name} = Figure,
    case RoleLv >= ?MarriageOpenLv of
        true ->
            InPersonals = is_in_personals(RoleId),
            mod_marriage:marriage_login_logout([RoleId, Name, 1]), %% 登录登出数据变化
            MarriageStatus = marriage_status_login(RoleId),
            NewFigure = Figure#figure{
                marriage_type = MarriageStatus#marriage_status.type,
                lover_role_id = MarriageStatus#marriage_status.lover_role_id,
                lover_name = MarriageStatus#marriage_status.lover_name
            },
            MarriageAttr = get_marriage_attr(Stage, Star, MarriageStatus#marriage_status.type == 2),

            if
                MarriageStatus#marriage_status.lover_role_id =/= 0 ->
                    case maps:get(?MARRIAGE_DSGT, DsgtMap, []) of
                        #designation{} -> skip;
                        _ ->
                            lib_designation_api:active_dsgt_common(RoleId, ?MARRIAGE_DSGT)
                    end;
                true ->
                    skip
            end,

            NewMarriageStatus = MarriageStatus#marriage_status{marriage_attr = MarriageAttr, in_personals = InPersonals},
            NewPs = Ps#player_status{
                marriage = NewMarriageStatus,
                figure = NewFigure
            };
        _ ->
            case RoleLv>= ?PersonalOpenLv of
                true -> InPersonals = is_in_personals(RoleId);
                _ -> InPersonals = false
            end,
            MarriageLife = #marriage_life{role_id = RoleId, stage = 1, heart = 0},
            MarriageStatus = #marriage_status{role_id = RoleId, marriage_life = MarriageLife, in_personals = InPersonals},
            NewFigure = Figure#figure{
                marriage_type = MarriageStatus#marriage_status.type,
                lover_role_id = MarriageStatus#marriage_status.lover_role_id,
                lover_name = MarriageStatus#marriage_status.lover_name
            },
            NewPs = Ps#player_status{
                marriage = MarriageStatus,
                figure = NewFigure
            }
    end,
    lib_player_event:add_listener(?EVENT_DISCONNECT, ?MODULE, marriage_logout, []),
    NewPs.

marriage_login_offline(Ps, GoodsStatus) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv} = Figure} = Ps,
    case RoleLv >= ?MarriageOpenLv of
        true ->
            #goods_status{
                ring = #ring{stage = Stage, star = Star}
            } = GoodsStatus,
            MarriageStatus = marriage_status_login(RoleId),
            MarriageAttr = get_marriage_attr(Stage, Star, MarriageStatus#marriage_status.type == 2),
            NewMarriageStatus = MarriageStatus#marriage_status{marriage_attr = MarriageAttr};
        _ ->
            MarriageLife = #marriage_life{role_id = RoleId, stage = 1, heart = 0},
            NewMarriageStatus = #marriage_status{role_id = RoleId, marriage_life = MarriageLife}
    end,
    NewFigure = Figure#figure{
        marriage_type = NewMarriageStatus#marriage_status.type,
        lover_role_id = NewMarriageStatus#marriage_status.lover_role_id,
        lover_name = NewMarriageStatus#marriage_status.lover_name
    },
    Ps#player_status{marriage = NewMarriageStatus, figure = NewFigure}.

marriage_logout(Ps, _) ->
    #player_status{
        id = RoleId,
        figure = #figure{name = Name, lv = RoleLv},
        marriage = #marriage_status{in_matching = _InMatchDun}
    } = Ps,
    RoleLv >= ?MarriageOpenLv andalso mod_marriage:marriage_login_logout([RoleId, Name, 0]),
    %InMatchDun > 0 andalso mod_marriage_match:cancel_match(RoleId),
    {ok, Ps}.

%% 获取MarriageStatus数据
marriage_status_login(RoleId) ->
    case catch mod_marriage:marriage_status_login(RoleId) of
        [RoleId2, Type, NowWeddingState, WeddingPid, LoveGiftS, LoveGiftO] ->
            %[RoleId2, Type, NowWeddingState, WeddingPid, LoveGiftS, LoveGiftO] = Other,
            case lib_player:get_player_low_data(RoleId2) of
                [] ->
                    LoverName = "";
                [LoverName|_] ->
                    skip
            end,
            MarriageStatus1 = #marriage_status{
                role_id = RoleId,
                lover_role_id = RoleId2,
                lover_name = LoverName,
                type = Type,
                now_wedding_state = NowWeddingState,
                wedding_pid = WeddingPid,
                love_gift_time_s = LoveGiftS,
                love_gift_time_o = LoveGiftO
            };
        _ ->
            MarriageStatus1 = #marriage_status{
                role_id = RoleId
            }
    end,
    % ReSql1 = io_lib:format(?SelectMLifeSql, [RoleId]),
    % case db:get_all(ReSql1) of
    %     [] ->
    %         NewMarriageLife = #marriage_life{
    %             role_id = RoleId,
    %             stage = 1,
    %             heart = 0
    %         };
    %     [[_RoleId, Stage, Heart]|_] ->
    %         NewMarriageLife = #marriage_life{
    %             role_id = RoleId,
    %             stage = Stage,
    %             heart = Heart
    %         }
    % end,
    NewMarriageLife = #marriage_life{role_id = RoleId, stage = 1, heart = 0},
    ReSql2 = io_lib:format(?SelectMarriageAskTimeSql, [RoleId]),
    case db:get_all(ReSql2) of
        [] ->
            AskFollowTime = 0,
            AskFlowerTime = 0;
        [[_RoleId1, AskFollowTime, AskFlowerTime]|_] ->
            skip
    end,
    MarriageStatus = MarriageStatus1#marriage_status{
        marriage_life = NewMarriageLife,
        ask_follow_time = AskFollowTime,
        ask_flower_time = AskFlowerTime
    },
    MarriageStatus.

get_marriage_life_attr(Ps) ->
    #player_status{
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        type = MarriageType,
        marriage_life = _MarriageLife,
        marriage_attr = MarriageAttr
    } = MarriageStatus,
    case MarriageType of
        2 ->
            AttrList = MarriageAttr;
        _ ->
            AttrList = []
    end,
    AttrList.

is_single(PS) ->
    #player_status{marriage = MarriageStatus} = PS,
    #marriage_status{lover_role_id = LoverRoleId} = MarriageStatus,
    LoverRoleId == 0.

%% ======================================== 征友大厅 ================================

pack_personals_send_info(PersonalsInfo, RoleId, FriendIntimacyList, CoupleList) when is_record(PersonalsInfo, personals_player) ->
    #personals_player{
        role_id = RoleId1,
        lv = Lv,
        name = Name,
        sex = Sex,
        vip = Vip,
        career = Career,
        turn = Turn,
        msg = Msg,
        picture = Picture,
        picture_ver = PictureVer,
        fans_list = FansList,
        if_online = IfOnline,
        type = Type,
        tag_list = TagList,
        time = Time,
        vip_exp = VipExp,
        vip_hide = VipHide,
        is_supvip = IsSupvip
    } = PersonalsInfo,
    Popularity = length(FansList),
    case lists:member(RoleId, FansList) of
        false ->
            IfFollow = 0;
        true ->
            IfFollow = 1
    end,
    case lists:keyfind(RoleId1, 1, FriendIntimacyList) of
        false ->
            IfFriend = 0,
            Intimacy = 0;
        {_RoleId1, Intimacy} ->
            IfFriend = 1
    end,
    IfMarriage = if_marriage(RoleId1, CoupleList),
    {RoleId1, Name, Lv, Sex, Vip, Career, Turn, IfMarriage, Picture, PictureVer, IfOnline, Popularity, Msg, Type, Time, IfFollow, IfFriend, Intimacy, TagList, VipExp, VipHide, IsSupvip};

pack_personals_send_info(RoleId1, _RoleId, _FriendIntimacyList, _CoupleList) ->
    {RoleId1, "", 0, 1, 0, 1, 0, 0, "1", 0, 0, 0, "", 0, 0, 0, 0, 0, [], 0, 0, 0}.

%% 0单身 1结婚 2有情侣
if_marriage(RoleId, CoupleList) ->
    CoupleInfo1 = lists:keyfind(RoleId, #marriage_couple.role_id_m, CoupleList),
    CoupleInfo2 = lists:keyfind(RoleId, #marriage_couple.role_id_w, CoupleList),
    case CoupleInfo1 of
        false ->
            case CoupleInfo2 of
                false ->
                    0;
                _ ->
                    #marriage_couple{
                        type = Type
                    } = CoupleInfo2,
                    case Type of
                        1 ->
                            1;
                        _ ->
                            2
                    end
            end;
        _ ->
            #marriage_couple{
                type = Type
            } = CoupleInfo1,
            case Type of
                1 ->
                    1;
                _ ->
                    2
            end
    end.

get_fans_list_db(RoleId, PersonalsFansAllList) ->
    F = fun(SqlStrInfo, FansList1) ->
        case SqlStrInfo of
            [FansRoleId, RoleId, Time] ->
                [{FansRoleId, Time}|FansList1];
            _ ->
                FansList1
        end
    end,
    FansList = lists:foldl(F, [], PersonalsFansAllList),
    lists:reverse(lists:keysort(2, FansList)).

sql_personals_follow(RoleId, FollowRoleId, NowTime) ->
    ReSql = io_lib:format(?ReplaceMPFollowSql, [RoleId, FollowRoleId, NowTime]),
    db:execute(ReSql).

sql_personals_follow_cancel(RoleId, FollowRoleId) ->
    ReSql = io_lib:format(?DeleteMPFollowSql, [RoleId, FollowRoleId]),
    db:execute(ReSql).

sql_personals_player(PersonalsInfo) ->
    #personals_player{
        role_id = RoleId,
        name = Name,
        sex = Sex,
        vip = Vip,
        career = Career,
        turn = Turn,
        msg = Msg,
        picture = Picture,
        picture_ver = PictureVer,
        type = Type,
        tag_list = TagList,
        time = Time,
        vip_exp = VipExp,
        vip_hide = VipHide,
        is_supvip = IsSupvip
    } = PersonalsInfo,
    TagListB = util:term_to_bitstring(TagList),
    ReSql = io_lib:format(?ReplaceMPPlayerSql, [RoleId, Name, Sex, Vip, Career, Turn, Msg, Picture, PictureVer, Type, TagListB, Time, VipExp, VipHide, IsSupvip]),
    db:execute(ReSql).

sql_update_personals_player(PersonalsInfo) ->
    #personals_player{
        role_id = RoleId,
        msg = Msg,
        tag_list = TagList
    } = PersonalsInfo,
    TagListB = util:term_to_bitstring(TagList),
    ReSql = io_lib:format(?UpdateMPPlayerSql, [Msg, TagListB, RoleId]),
    db:execute(ReSql).

replace_love_gift_count(RoleId, CountType, State, Time) ->
    ReSql = io_lib:format(?ReplaceMBabyImageInfoSql, [RoleId, CountType, State, Time]),
    db:execute(ReSql).

%% ======================================== 戒指 ================================

% ring_login(_RoleId) ->
%     #ring{}.

ring_login(RoleId) ->
    ReSql = io_lib:format(?SelectMRingSql, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            AttrList = count_ring_attr_list(1, 0, []),
            NewRing = #ring{
                role_id = RoleId,
                stage = 1,
                star = 0,
                attr_list = AttrList
            };
        [[_RoleId, Stage, Star, PrayNum, SPolishList]|_] ->
            PolishList = util:bitstring_to_term(SPolishList),
            AttrList = count_ring_attr_list(Stage, Star, PolishList),
            NewRing = #ring{
                role_id = RoleId,
                stage = Stage,
                star = Star,
                pray_num = PrayNum,
                attr_list = AttrList,
                polish_list = PolishList
            }
    end,
    NewRing.

count_ring_attr_list(Stage, Star, PolishList) ->
    case data_ring:get_ring_star_con(Stage, Star) of
        #ring_star_con{
            attr_list = AttrList
        } ->
            F = fun({GoodsTypeId, PolishNum}, NewAttrList1) ->
                case data_ring:get_ring_polish_con(GoodsTypeId) of
                    #ring_polish_con{
                        attr_list = AttrList1
                    } ->
                        AttrList2 = [{AttrType, AttrNum*PolishNum}||{AttrType, AttrNum} <- AttrList1],
                        [AttrList2|NewAttrList1];
                    _ ->
                        NewAttrList1
                end
            end,
            NewAttrList = lists:foldl(F, [AttrList], PolishList),
            lib_player_attr:add_attr(list, NewAttrList);
        _ ->
            []
    end.

count_ring_attribute(Ring) ->
    #ring{
        attr_list = AttrList
    } = Ring,
    AttrList.

sql_ring_player(Ring) ->
    #ring{
        role_id = RoleId,
        stage = Stage,
        star = Star,
        pray_num = PrayNum,
        polish_list = PolishList
    } = Ring,
    SPolishList = util:term_to_string(PolishList),
    ReSql = io_lib:format(?ReplaceMRingSql, [RoleId, Stage, Star, PrayNum, SPolishList]),
    db:execute(ReSql).

check_ring_max(Stage, Star) ->
    case data_ring:get_ring_star_con(Stage, Star+1) of
        [] ->
            case data_ring:get_ring_star_con(Stage+1, 1) of
                [] ->
                    false;
                _ ->
                    true
            end;
        _ ->
            true
    end.

check_baby_knowledge_max(Stage, Star) ->
    case data_baby:get_baby_knowledge_star_con(Stage, Star+1) of
        [] ->
            case data_baby:get_baby_knowledge_star_con(Stage+1, 1) of
                [] ->
                    false;
                _ ->
                    true
            end;
        _ ->
            true
    end.

check_marriage_life_max(Stage, Heart) ->
    case data_marriage:get_marriage_life_heart_con(Stage, Heart+1) of
        [] ->
            case data_marriage:get_marriage_life_heart_con(Stage+1, 0) of
                [] ->
                    false;
                _ ->
                    {true, Stage+1, 0}
            end;
        _ ->
            {true, Stage, Heart+1}
    end.

ring_upgrade(Stage, Star, PrayNum, AddPrayNum) ->
    RingStarCon = case data_ring:get_ring_star_con(Stage, Star+1) of
        [] ->
            data_ring:get_ring_star_con(Stage+1, 1);
        RingStarCon1 ->
            RingStarCon1
    end,
    case RingStarCon of
        #ring_star_con{
            stage = ConStage, star = ConStar, upgrade_pray_num = NeedPrayNum
        } ->
            case PrayNum+AddPrayNum >= NeedPrayNum of
                true ->
                    NewStage = ConStage,
                    NewStar = ConStar,
                    NewPrayNum = PrayNum + AddPrayNum - NeedPrayNum,
                    ring_upgrade(NewStage, NewStar, NewPrayNum, 0);
                false ->
                    NewStage = Stage,
                    NewStar = Star,
                    NewPrayNum = PrayNum + AddPrayNum,
                    {NewStage, NewStar, NewPrayNum}
            end;
        _ ->
            {Stage, Star, PrayNum + AddPrayNum}
    end.

baby_knowledge_upgrade(Stage, Star, AddPrayNum) ->
    BabyKnowledgeStarCon = case data_baby:get_baby_knowledge_star_con(Stage, Star+1) of
        [] ->
            data_baby:get_baby_knowledge_star_con(Stage+1, 1);
        BabyKnowledgeStarCon1 ->
            BabyKnowledgeStarCon1
    end,
    case BabyKnowledgeStarCon of
        [] ->
            {Stage, Star, AddPrayNum};
        _ ->
            #baby_knowledge_star_con{
                stage = ConStage,
                star = ConStar,
                upgrade_pray_num = NeedPrayNum
            } = BabyKnowledgeStarCon,
            case AddPrayNum >= NeedPrayNum of
                true ->
                    NewAddPray = AddPrayNum - NeedPrayNum,
                    baby_knowledge_upgrade(ConStage, ConStar, NewAddPray);
                false ->
                    {Stage, Star, AddPrayNum}
            end
    end.

ring_upgrade_all(Stage, Star, PrayNum, [], CostList, BaojiList) ->
    {Stage, Star, PrayNum, CostList, BaojiList};
ring_upgrade_all(Stage, Star, PrayNum, GoodsList, CostList, BaojiList) ->
    F = fun({GoodsTypeId, GoodsNum}, {TotalAddPrayNum, L}) ->
        {_GoodsTypeId, AddPrayNum, RatioList} = lists:keyfind(GoodsTypeId, 1, ?RingPrayNumList),
        Ratio = ?IF(RatioList == [], 1, urand:rand_with_weight(RatioList)),
        NAddPrayNum = round(AddPrayNum * Ratio),
        case GoodsNum > 0 of
            true -> {TotalAddPrayNum + NAddPrayNum*GoodsNum, [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|L]};
            _ -> {TotalAddPrayNum, L}
        end

    end,
    {AddPrayNum, CostList1} = lists:foldl(F, {0, []}, GoodsList),
    {NewStage, NewStar, NewPrayNum} = ring_upgrade(Stage, Star, PrayNum, AddPrayNum),
    {NewStage, NewStar, NewPrayNum, CostList++CostList1, BaojiList}.


% do_ring_upgrade_all(Stage, Star, PrayNum, _GoodsTypeId, 0, CostList, BaojiList) ->
%     {Stage, Star, PrayNum, CostList, BaojiList};
% do_ring_upgrade_all(Stage, Star, PrayNum, GoodsTypeId, GoodsNum, CostList, BaojiList) ->
%     {_GoodsTypeId, AddPrayNum, RatioList} = lists:keyfind(GoodsTypeId, 1, ?RingPrayNumList),
%     Ratio = ?IF(RatioList == [], 1, urand:rand_with_weight(RatioList)),
%     case lists:keyfind(GoodsTypeId, 2, CostList) of
%         false ->
%             NewCost = {?TYPE_GOODS, GoodsTypeId, 1};
%         {GoodsType, _GoodsTypeId, CostNum} ->
%             NewCost = {GoodsType, GoodsTypeId, CostNum+1}
%     end,
%     NewCostList = lists:keystore(GoodsTypeId, 2, CostList, NewCost),
%     NAddPrayNum = round(AddPrayNum * Ratio),
%     NewBaojiList = ?IF(Ratio > 1, [{Ratio, NAddPrayNum}|BaojiList], BaojiList),
%     case ring_upgrade(Stage, Star, PrayNum, NAddPrayNum) of
%         {Stage, Star, NewPrayNum} ->
%             do_ring_upgrade_all(Stage, Star, NewPrayNum, GoodsTypeId, GoodsNum-1, NewCostList, NewBaojiList);
%         {NewStage, NewStar, NewPrayNum} ->
%             {NewStage, NewStar, NewPrayNum, NewCostList, NewBaojiList};
%         _Other ->
%             ?ERR("ring_upgrade_all: ~p~n", [_Other]),
%             false
%     end.

baby_knowledge_upgrade_all(Stage, Star, PrayNum, [T|G], CostList) ->
    {GoodsTypeId, GoodsNum} = T,
    case GoodsNum > 0 of
        true ->
            case do_baby_knowledge_upgrade_all(Stage, Star, PrayNum, GoodsTypeId, GoodsNum, CostList) of
                {Stage, Star, NewPrayNum, NewCostList} ->
                    baby_knowledge_upgrade_all(Stage, Star, NewPrayNum, G, NewCostList);
                Return ->
                    Return
            end;
        false ->
            baby_knowledge_upgrade_all(Stage, Star, PrayNum, G, CostList)
    end;
baby_knowledge_upgrade_all(Stage, Star, PrayNum, [], CostList) ->
    {Stage, Star, PrayNum, CostList}.

do_baby_knowledge_upgrade_all(Stage, Star, PrayNum, _GoodsTypeId, 0, CostList) ->
    {Stage, Star, PrayNum, CostList};
do_baby_knowledge_upgrade_all(Stage, Star, PrayNum, GoodsTypeId, GoodsNum, CostList) ->
    {_GoodsTypeId, AddPrayNum} = lists:keyfind(GoodsTypeId, 1, ?BabyKnowledgePrayNumList),
    case lists:keyfind(GoodsTypeId, 2, CostList) of
        false ->
            NewCost = {?TYPE_GOODS, GoodsTypeId, 1};
        {GoodsType, _GoodsTypeId, CostNum} ->
            NewCost = {GoodsType, GoodsTypeId, CostNum+1}
    end,
    NewCostList = lists:keystore(GoodsTypeId, 2, CostList, NewCost),
    case baby_knowledge_upgrade(Stage, Star, PrayNum+AddPrayNum) of
        {Stage, Star, NewPrayNum} ->
            do_baby_knowledge_upgrade_all(Stage, Star, NewPrayNum, GoodsTypeId, GoodsNum-1, NewCostList);
        {NewStage, NewStar, NewPrayNum} ->
            {NewStage, NewStar, NewPrayNum, NewCostList};
        _Other ->
            ?ERR("baby_knowledge_upgrade_all: ~p~n", [_Other]),
            false
    end.

baby_image_upgrade_all(ImageId, Stage, PrayNum, [T|G], CostList) ->
    {GoodsTypeId, GoodsNum, AddPrayNum} = T,
    case GoodsNum > 0 of
        true ->
            case do_baby_image_upgrade_all(ImageId, Stage, PrayNum, GoodsTypeId, GoodsNum, AddPrayNum, CostList) of
                {Stage, NewPrayNum, NewCostList} ->
                    baby_image_upgrade_all(ImageId, Stage, NewPrayNum, G, NewCostList);
                Return ->
                    Return
            end;
        false ->
            baby_image_upgrade_all(ImageId, Stage, PrayNum, G, CostList)
    end;
baby_image_upgrade_all(_ImageId, Stage, PrayNum, [], CostList) ->
    {Stage, PrayNum, CostList}.

do_baby_image_upgrade_all(_ImageId, Stage, PrayNum, _GoodsTypeId, 0, _AddPrayNum, CostList) ->
    {Stage, PrayNum, CostList};
do_baby_image_upgrade_all(ImageId, Stage, PrayNum, GoodsTypeId, GoodsNum, AddPrayNum, CostList) ->
    case lists:keyfind(GoodsTypeId, 2, CostList) of
        false ->
            NewCost = {?TYPE_GOODS, GoodsTypeId, 1};
        {GoodsType, _GoodsTypeId, CostNum} ->
            NewCost = {GoodsType, GoodsTypeId, CostNum+1}
    end,
    NewCostList = lists:keystore(GoodsTypeId, 2, CostList, NewCost),
    case baby_image_upgrade(ImageId, Stage, PrayNum, AddPrayNum) of
        {Stage, NewPrayNum} ->
            do_baby_image_upgrade_all(ImageId, Stage, NewPrayNum, GoodsTypeId, GoodsNum-1, AddPrayNum, NewCostList);
        {NewStage, NewPrayNum} ->
            {NewStage, NewPrayNum, NewCostList};
        _Other ->
            ?ERR("baby_knowledge_upgrade_all: ~p~n", [_Other]),
            false
    end.

baby_image_upgrade(ImageId, Stage, PrayNum, AddPrayNum) ->
    BabyImageStageCon = data_baby:get_baby_image_stage_con(ImageId, Stage+1),
    #baby_image_stage_con{
        upgrade_pray_num = UpgradeprayNum
    } = BabyImageStageCon,
    case PrayNum + AddPrayNum >= UpgradeprayNum of
        false ->
            NewPrayNum = PrayNum + AddPrayNum,
            NewStage = Stage;
        true ->
            NewPrayNum = PrayNum + AddPrayNum - UpgradeprayNum,
            NewStage = Stage + 1
    end,
    {NewStage, NewPrayNum}.

%% 玩家进程初步检查是否可表白/求婚
check_biaobai_self(RoleId, OtherRid, Type) ->
    case lib_relationship:get_rela_with_other_on_dict(RoleId, OtherRid) of
        false ->
            {false, ?ERRCODE(err140_6_not_friend)};
        FriendInfo ->
            #rela{
                rela_type = RelaType,
                intimacy = Intimacy
            } = FriendInfo,
            case lists:member(RelaType, ?RELA_FRIEND_TYPES) of
                false ->
                    {false, ?ERRCODE(err140_6_not_friend)};
                true ->
                    case Type of
                        1 ->
                            NeedIntimacy = ?BiaoBaiNeedIntimacy;
                        _ ->
                            NeedIntimacy = ?ProposeNeedIntimacy
                    end,
                    case Intimacy >= NeedIntimacy of
                        false ->
                            {false, ?ERRCODE(err172_couple_intimacy_not_enough)};
                        true ->
                            true
                    end
            end
    end.

get_lover_info(Ps) ->
    #player_status{
        figure = Figure
    } = Ps,
    #figure{
        sex = Sex,
        lv = RoleLv
    } = Figure,
    [Sex, RoleLv].

%% 功能进程里检查可否表白 Type:1表白 2求婚 3aa制
biaobai_check(CoupleList, Args1, Args2, Type, ProposalList) ->
    [RoleId1, Lv1, Sex1] = Args1,
    [RoleId2, Lv2, Sex2] = Args2,
    %% 检查对方有没有向你表白或者求婚
    IfCanBiaoBai = case lists:keyfind(RoleId1, #proposal.role_id, ProposalList) of
        false ->
            true;
        #proposal{proposing_list = ProposingList} ->
            case lists:keyfind(RoleId2, #propose_info.propose_role_id, ProposingList) of
                false ->
                    true;
                #propose_info{type = MarriageType} ->
                    case MarriageType of
                        1 ->
                            {false, ?ERRCODE(err172_couple_other_biaobai)};
                        _ ->
                            {false, ?ERRCODE(err172_couple_other_propose)}
                    end
            end
    end,
    case IfCanBiaoBai of
        true ->
            case Type of
                1 ->
                    do_biaobai_check(CoupleList, RoleId1, Lv1, Sex1, RoleId2, Lv2, Sex2);
                _ ->
                    do_propose_check(CoupleList, RoleId1, Sex1, RoleId2, Sex2, Type)
            end;
        Other ->
            Other
    end.

divorce_check(CoupleList, RoleId1) ->
    case get_couple_info(RoleId1, CoupleList) of
        {CoupleInfo, _} -> {true, CoupleInfo};
        _ ->
            {false, ?ERRCODE(err172_couple_single)}
    end.

get_divorce_cost(MarriageType, DivorceType, IsFree) ->
    case MarriageType of
        1 ->
            CostList = ?CoupleBreakCost;
        _ when DivorceType == 2 -> %% 强制离婚
            CostList = ?IF(IsFree, [], ?CoupleDivorceCost);
        _ ->
            CostList = []
    end,
    CostList.

%% 求婚/再次aa预约婚礼判断
do_propose_check(CoupleList, RoleId1, Sex1, RoleId2, Sex2, _Type) ->
    CoupleInfo1 = lists:keyfind(RoleId1, #marriage_couple.role_id_m, CoupleList),
    CoupleInfo2 = lists:keyfind(RoleId1, #marriage_couple.role_id_w, CoupleList),
    CoupleInfo = case CoupleInfo1 of
        false ->
            CoupleInfo2;
        _ ->
            CoupleInfo1
    end,
    case CoupleInfo of
        false -> %% 求婚者是单身，判断一下被求婚者的结婚状态
            case get_couple_info(RoleId2, CoupleList) of
                {_CoupleInfoOther, _} -> %% 求婚者已经结婚，不能求婚
                    {false, ?ERRCODE(err172_couple_other_not_single)};
                _ -> %% 被求婚者也是单身，可以进行求婚
                    %% 不是再次结婚的话，要不同性别
                    is_sex_can_couple(Sex1, Sex2)
            end;
        #marriage_couple{
            role_id_m = RoleId1,
            role_id_w = RoleId2,
            type = _MarriageType
        } ->
            true;  %% 可以再次求婚(不管是同性还是异性)
            % if
            %     MarriageType =:= 2 andalso Type =:= 3 ->
            %         true;
            %     MarriageType =:= 1 ->
            %         true;
            %     true ->
            %         {false, ?ERRCODE(err172_please_order_wedding)}
            % end;
        #marriage_couple{
            role_id_m = RoleId2,
            role_id_w = RoleId1,
            type = _MarriageType
        } ->
            true;
            % if
            %     MarriageType =:= 2 andalso Type =:= 3 ->
            %         true;
            %     MarriageType =:= 1 ->
            %         true;
            %     true ->
            %         {false, ?ERRCODE(err172_please_order_wedding)}
            % end;
        _ ->
             {false, ?ERRCODE(err172_couple_not_lover)}
    end.

do_biaobai_check(CoupleList, RoleId1, Lv1, Sex1, RoleId2, Lv2, Sex2) ->
    IfRole1MarriageM = lists:keyfind(RoleId1, #marriage_couple.role_id_m, CoupleList),
    IfRole1MarriageW = lists:keyfind(RoleId1, #marriage_couple.role_id_w, CoupleList),
    IfRole2MarriageM = lists:keyfind(RoleId2, #marriage_couple.role_id_m, CoupleList),
    IfRole2MarriageW = lists:keyfind(RoleId2, #marriage_couple.role_id_w, CoupleList),
    MarriageOpenLv = ?MarriageOpenLv,
    if
        RoleId1 =:= RoleId2 ->
            {false, ?ERRCODE(err172_couple_not_self)};
        Lv1 < MarriageOpenLv ->
            {false, ?LEVEL_LIMIT};
        Lv2 < MarriageOpenLv ->
            {false, ?ERRCODE(err172_marriage_partner_lv_limit)};
        Sex1 =:= Sex2 ->
            is_sex_can_couple(Sex1, Sex2);
        IfRole1MarriageM =/= false ->
            {false, ?ERRCODE(err172_couple_self_not_single)};
        IfRole1MarriageW =/= false ->
            {false, ?ERRCODE(err172_couple_self_not_single)};
        IfRole2MarriageM =/= false ->
            {false, ?ERRCODE(err172_couple_other_not_single)};
        IfRole2MarriageW =/= false ->
            {false, ?ERRCODE(err172_couple_other_not_single)};
        true ->
            true
    end.

%% 表白 Type：1打开表白 2发送表白 3回应表白/求婚 4打开求婚 5发送求婚
%% 表白的玩家Args1 被表白的玩家Args2
marriage_behavior(Ps, SelfArgs, Msg, AnswerType, WeddingType, Type, ProposeArgs) ->
    #player_status{
        id = OtherRid,
        combat_power = CombatPower,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv,
        name = Name,
        sex = Sex,
        vip = Vip,
        career = Career,
        turn = Turn
    } = Figure,
    case Type of
        3 ->
            Args1 = [OtherRid, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
            Args2 = SelfArgs;
        _ ->
            Args1 = SelfArgs,
            Args2 = [OtherRid, Name, CombatPower, Lv, Sex, Vip, Career, Turn]
    end,
    case Type of
        1 ->
            mod_marriage:open_biaobai([Args1, Args2]);
        2 ->
            mod_marriage:send_biaobai([Args1, Args2, Msg, 1, 0, [0, "", [], []]]);
        3 ->
            mod_marriage:answer_biaobai([Args1, Args2, AnswerType, ProposeArgs]);
        4 ->
            mod_marriage:open_propose([Args1, Args2]);
        _ ->
            %[MarriageType, _CostKey, _OtherCostList, _CostList] = ProposeArgs,
            mod_marriage:send_biaobai([Args1, Args2, Msg, 2, WeddingType, ProposeArgs])
            % case MarriageType of
            %     1 ->
            %         mod_marriage:send_biaobai([Args1, Args2, Msg, 2, WeddingType, ProposeArgs]);
            %     _ ->
            %         mod_marriage:send_biaobai([Args1, Args2, Msg, 3, WeddingType, ProposeArgs])
            % end
    end.

open_biaobai(Ps, Args, CheckResult) ->
    #player_status{
        id = OtherRid,
        figure = Figure
    } = Ps,
    #figure{
        sex = Sex2
    } = Figure,
    [RoleId, _Name, _CombatPower, _Lv, Sex1, _Vip, _Career, _Turn] = Args,
    case is_sex_can_couple(Sex1, Sex2) of
        {false, _} ->
            {ok, Bin} = pt_172:write(17220, [?ERRCODE(err172_couple_not_same_sex), OtherRid, "", 0, 0, 0, 0, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        _ ->
            case CheckResult of
                {false, Code} ->
                    {ok, Bin} = pt_172:write(17220, [Code, OtherRid, "", 0, 0, 0, 0, 0, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    marriage_behavior(Ps, Args, "", 0, 0, 1, [])
            end
    end.

send_biaobai(Ps, Args, Msg, CheckResult) ->
    #player_status{
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv2,
        sex = Sex2
    } = Figure,
    [RoleId, _Name, _CombatPower, _Lv, Sex1, _Vip, _Career, _Turn] = Args,
    MarriageOpenLv = ?MarriageOpenLv,
    SexCheck = is_sex_can_couple(Sex1, Sex2),
    if
        Lv2 < MarriageOpenLv ->
            {ok, Bin} = pt_172:write(17221, [?ERRCODE(err172_marriage_partner_lv_limit)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        SexCheck =/= true ->
            {ok, Bin} = pt_172:write(17221, [?ERRCODE(err172_couple_not_same_sex)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case CheckResult of
                {false, Code} ->
                    {ok, Bin} = pt_172:write(17221, [Code]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    marriage_behavior(Ps, Args, Msg, 0, 0, 2, [])
            end
    end.

answer_biaobai_all([T|G], ProposalList, AnswerType) ->
    NewProposalList = answer_biaobai_one(T, ProposalList, AnswerType),
    answer_biaobai_all(G, NewProposalList, AnswerType);
answer_biaobai_all([], ProposalList, _NewAnswerInfo) ->
    ProposalList.


%% AnswerType : 1 答应表白/求婚 2拒绝 3超时 4其他情况
answer_biaobai_one(ProposeInfo, ProposalList, AnswerType) ->
    #propose_info{
        role_id = RoleId,
        propose_role_id = ProposeRoleId,
        type = MarriageType,
        propose_type = ProposeType,
        cost_list = CostList,
        cost_key = _CostKey,
        other_cost_key = _OtherCostKey
    } = ProposeInfo,
    case MarriageType of
        3 -> %% AA值特殊转换
            UseType = 5;
        _ ->
            UseType = MarriageType
    end,
    case AnswerType of
        1 ->
            HadMarriaged = mod_counter:get_count_offline(RoleId, ?MOD_MARRIAGE, 1),
            HadMarriaged2 = mod_counter:get_count_offline(ProposeRoleId, ?MOD_MARRIAGE, 1),
            case data_marriage:get_propose_info(ProposeType) of
                #base_propose_cfg{reward = Reward} ->
                    ?IF(HadMarriaged == 0, mod_counter:increment_offline(RoleId, ?MOD_MARRIAGE, 1), ok),
                    ?IF(HadMarriaged2 == 0, mod_counter:increment_offline(ProposeRoleId, ?MOD_MARRIAGE, 1), ok),
                    RewardS = ?IF(HadMarriaged > 0, lists:keydelete(?RingUnLockGoods, 2, Reward), Reward),
                    RewardO = ?IF(HadMarriaged2 > 0, lists:keydelete(?RingUnLockGoods, 2, Reward), Reward);
                _ -> RewardS = [], RewardO = []
            end,
            ReturnCost = [];
        _ ->
            RewardS = [], RewardO = [], ReturnCost = []
    end,
    lib_log_api:log_marriage_answer(RoleId, ProposeRoleId, AnswerType, MarriageType, ProposeType, RewardS, RewardO, ReturnCost),
    %% 回答信息先屏蔽，不用回答信息
    % NewAnswerInfo = #answer_info{
    %     role_id = RoleId,
    %     type = UseType,
    %     answer_type = AnswerType,
    %     time = utime:unixtime()
    % },
    % case lists:keyfind(ProposeRoleId, #proposal.role_id, ProposalList) of
    %     false ->
    %         NewProposalPlayer = #proposal{
    %             role_id = ProposeRoleId,
    %             answer_list = [NewAnswerInfo]
    %         };
    %     ProposalPlayer ->
    %         #proposal{
    %             answer_list = AnswerList
    %         } = ProposalPlayer,
    %         case UseType >= 2 andalso AnswerType =:= 1 of
    %             true ->
    %                 NewAnswerList = [NewAnswerInfo];
    %             false ->
    %                 NewAnswerList = lists:keystore(RoleId, #answer_info.role_id, AnswerList, NewAnswerInfo)
    %         end,
    %         NewProposalPlayer = ProposalPlayer#proposal{
    %             answer_list = NewAnswerList
    %         }
    % end,
    %% 把消耗算进消费活动(没哟进行预消耗)
    % case CostKey of
    %     "" ->
    %         skip;
    %     _ ->
    %         case AnswerType of
    %             1 ->
    %                 lib_consume_data:advance_payment_done(ProposeRoleId, CostKey),
    %                 OtherCostKey =/= "" andalso lib_consume_data:advance_payment_done(RoleId, OtherCostKey);
    %             _ ->
    %                 lib_consume_data:advance_payment_fail(ProposeRoleId, CostKey, []),
    %                 OtherCostKey =/= "" andalso lib_consume_data:advance_payment_fail(RoleId, OtherCostKey, [])
    %         end
    % end,
    %lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, answer_biaobai_one_result, [ProposeRoleId, ProposeType, UseType, AnswerType, CostList]),
    handle_msg_with_other(RoleId, ?MODULE, answer_biaobai_one_result, [ProposeRoleId, ProposeType, UseType, AnswerType, CostList, RewardS, RewardO]),
    %lists:keystore(ProposeRoleId, #proposal.role_id, ProposalList, NewProposalPlayer).
    ProposalList.

answer_biaobai_one_result(Ps, ProposeRoleId, ProposeType, UseType, AnswerType, _CostList, RewardS, RewardO) ->
    #player_status{
        id = RoleId,
        combat_power = _CombatPower,
        figure = Figure
    } = Ps,
    #figure{
        lv = _Lv,
        name = Name,
        sex = _Sex,
        vip = _Vip,
        career = _Career,
        turn = _Turn
    } = Figure,
    ?PRINT("answer_biaobai_one_result start ========== ~n", []),
    %% 结婚或 再次aa的返还
    case lists:member(UseType, [2, 5]) of
        true ->
            case AnswerType of
                1 ->
                    case data_marriage:get_propose_info(ProposeType) of
                        [] ->
                            skip;
                        ProposeInfo ->
                            #base_propose_cfg{
                                dsgt = DsgtId
                            } = ProposeInfo,
                            ProduceS = #produce{
                                type = propose, reward = RewardS,
                                title = ?LAN_MSG(1720007), content = ?LAN_MSG(1720008),
                                off_title = ?LAN_MSG(1720007), off_content = ?LAN_MSG(1720008)
                            },
                            ProduceO = ProduceS#produce{reward = RewardO},
                            lib_designation_api:active_dsgt_common(RoleId, DsgtId),
                            lib_designation_api:active_dsgt_common(ProposeRoleId, DsgtId),
                            lib_goods_api:send_reward_with_mail(RoleId, ProduceS),
                            lib_goods_api:send_reward_with_mail(ProposeRoleId, ProduceO)
                    end;
                _ ->
                    case AnswerType of
                        2 ->
                            Title = ?LAN_MSG(?LAN_TITLE_PROPOSE_REFUSE),
                            Content = ?LAN_MSG(?LAN_CONTENT_PROPOSE_REFUSE);
                        3 ->
                            Title = ?LAN_MSG(?LAN_TITLE_PROPOSE_TIME_OUT),
                            Content = ?LAN_MSG(?LAN_CONTENT_PROPOSE_TIME_OUT);
                        _ ->
                            Title = ?LAN_MSG(?LAN_TITLE_PROPOSE_FAIL_OTHER),
                            Content = ?LAN_MSG(?LAN_CONTENT_PROPOSE_FAIL_OTHER)
                    end,
                    case data_marriage:get_propose_info(ProposeType) of
                        [] ->
                            skip;
                        _ProposeInfo ->
                            lib_mail_api:send_sys_mail([ProposeRoleId], Title, Content, [])
                    end
            end;
        false ->
            skip
    end,
    case UseType of
        2 ->
            LanId = ?IF(AnswerType == 1, 2, 3),
            lib_chat:send_TV({player, ProposeRoleId}, ?MOD_MARRIAGE, LanId, [Name]);
        _ ->
            skip
    end,
    case AnswerType of
        4 ->
            skip;
        _ ->
            {ok, Bin} = pt_172:write(17224, [RoleId, UseType, AnswerType]),
            lib_server_send:send_to_uid(ProposeRoleId, Bin),
            {ok, Bin1} = pt_172:write(17224, [ProposeRoleId, UseType, AnswerType]),
            lib_server_send:send_to_uid(RoleId, Bin1)
    end.

sql_marriage_couple(NewCouple) ->
    #marriage_couple{
        role_id_m = RoleIdM,
        role_id_w = RoleIdW,
        type = Type,
        now_wedding_state = NowWeddingState,
        marriage_time = MarriageTime,
        love_num = LoveNum,
        love_num_max = LoveNumMax,
        love_gift_time_m = LoveGiftM,
        love_gift_time_w = LoveGiftW,
        others = Others
    } = NewCouple,
    ReSql = io_lib:format(?ReplaceMCoupleSql, [RoleIdM, RoleIdW, Type, NowWeddingState, MarriageTime, LoveNum, LoveNumMax, LoveGiftM, LoveGiftW, util:term_to_bitstring(Others)]),
    db:execute(ReSql).

sql_marriage_couple_love_num(NewCouple) ->
    #marriage_couple{
        role_id_m = RoleIdM,
        love_num = LoveNum,
        love_num_max = LoveNumMax
    } = NewCouple,
    ReSql = io_lib:format(?UpdateMCoupleLoveNumSql, [LoveNum, LoveNumMax, RoleIdM, RoleIdM]),
    db:execute(ReSql).

sql_marriage_couple_love_gift(NewCouple) ->
    #marriage_couple{
        role_id_m = RoleIdM,
        love_gift_time_m = LoveGiftM,
        love_gift_time_w = LoveGiftW
    } = NewCouple,
    ReSql = io_lib:format(?UpdateMCoupleLoveGiftSql, [LoveGiftM, LoveGiftW, RoleIdM, RoleIdM]),
    db:execute(ReSql).

sql_marriage_couple_update(Columns, Condition) ->
    Sql = usql:update(marriage_couple_info, Columns, Condition),
    db:execute(Sql).

sql_marriage_propose(NewProposeInfo) ->
    #propose_info{
        role_id = RoleId2,
        propose_role_id = RoleId1,
        type = Type,
        propose_type = ProposeType,
        msg = Msg,
        cost_list = CostList,
        other_cost_list = OtherCostList,
        cost_key = CostKey,
        time = Time
    } = NewProposeInfo,
    SCostList = util:term_to_string(CostList),
    SOtherCostList = util:term_to_string(OtherCostList),
    ReSql = io_lib:format(?ReplaceMPProposeSql, [RoleId2, RoleId1, Type, ProposeType, Msg, SCostList, SOtherCostList, CostKey, Time]),
    db:execute(ReSql).

%% 表白/求婚成功改动Ps
biaobai_change(Ps, Args2, Type) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus
    } = Ps,
    [RoleId2, Name2, _CombatPower2, _Lv2, _Sex2, _Vip2, _Career2, _Turn2] = Args2,
    case Type of
        2 ->
            case lib_goods_do:get_goods_status() of
                #goods_status{ring = #ring{stage = Stage, star = Star}} ->
                    MarriageAttr = get_marriage_attr(Stage, Star, true);
                _ -> MarriageAttr = []
            end;
        _ ->
            MarriageAttr = []
    end,
    NewMarriageStatus = MarriageStatus#marriage_status{
        role_id = RoleId,
        lover_role_id = RoleId2,
        type = Type,    %% 1情侣 2夫妻
        marriage_attr = MarriageAttr
    },
    NewFigure = Figure#figure{
        marriage_type = Type,
        lover_role_id = RoleId2,
        lover_name = Name2
    },
    NewPs = Ps#player_status{
        figure = NewFigure,
        marriage = NewMarriageStatus
    },
    %% 更新玩家展示Ets，好友单身信息更新
    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
    mod_scene_agent:update(NewPs, [{marriage, {Type, RoleId2}}]),
    mod_scene_agent:update(NewPs, [{figure, NewFigure}]),
    {ok, Bin} = pt_120:write(12003, NewPs),
    #player_status{
        scene = PlayerSceneId,
        scene_pool_id = ScenePoolId,
        copy_id = CopyId
    } = NewPs,
    lib_server_send:send_to_scene(PlayerSceneId, ScenePoolId, CopyId, Bin),
    BabyPs = lib_baby:update_baby_attr_after_marriage(NewPs),
    LastPs = lib_player:count_player_attribute(BabyPs),
    lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
    %% 完成寻找一名伴侣完成结婚的成长任务
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_grow_welfare_api, trigger_marriage, []),
    % TA数据上报
    ta_agent_fire:marriage_state(LastPs, RoleId2, ?TA_MARRIAGE_BUILD),
    LastPs.

%% 分手/离婚成功改动Ps
divorce_success_change(Ps) ->
    #player_status{
        id = _RoleId,
        figure = Figure,
        marriage = MarriageStatus
    } = Ps,
    NewMarriageStatus = MarriageStatus#marriage_status{
        lover_role_id = 0,
        lover_name = "",
        type = 0,
        now_wedding_state = 0,
        wedding_pid = 0,
        marriage_attr = []
    },
    NewFigure = Figure#figure{
        marriage_type = 0,
        lover_role_id = 0,
        lover_name = ""
    },
    NewPs = Ps#player_status{
        figure = NewFigure,
        marriage = NewMarriageStatus
    },
    %% 更新玩家展示Ets，好友单身信息更新
    %lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
    mod_scene_agent:update(NewPs, [{marriage, {0, 0}}]),
    {ok, Bin} = pt_120:write(12003, NewPs),
    #player_status{
        scene = PlayerSceneId,
        scene_pool_id = ScenePoolId,
        copy_id = CopyId
    } = NewPs,
    lib_server_send:send_to_scene(PlayerSceneId, ScenePoolId, CopyId, Bin),
    BabyPs = lib_baby:update_baby_attr_after_divorse(NewPs),
    LastPs = lib_player:count_player_attribute(BabyPs),
    lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
    LastPs.

get_login_send(RoleId, ProposingList, _AnswerList) ->
    F1 = fun(ProposeInfo, ProposeSendList1) ->
        #propose_info{
            propose_role_id = ProposeRoleId,
            type = Type,
            propose_type = ProposeType,
            msg = Msg,
            cost_key = CostKey,
            other_cost_list = OtherCostList
        } = ProposeInfo,
        case lib_role:get_role_show(ProposeRoleId) of
            #ets_role_show{
                figure = Figure, combat_power = CombatPower
            } ->
                #figure{
                    name = Name,
                    lv = Lv,
                    sex = Sex,
                    vip = Vip,
                    career = Career,
                    turn = Turn
                } = Figure,
                case CostKey of
                    "" ->
                        IfAA = 0;
                    _ ->
                        IfAA = 1
                end,
                SendInfo1 = {ProposeRoleId, Name, Lv, CombatPower, Sex, Vip, Career, Turn, Type, ProposeType, Msg, IfAA, OtherCostList},
                [SendInfo1|ProposeSendList1];
            _ ->
                ?ERR("get_login_send player not_exist:~p~n", [ProposeRoleId]),
                ProposeSendList1
        end
    end,
    ProposeSendList = lists:foldl(F1, [], ProposingList),
    % F2 = fun(AnswerInfo, AnswerSendList1) ->
    %     #answer_info{
    %         role_id = AnswerRoleId,
    %         type = Type,
    %         answer_type = AnswerType
    %     } = AnswerInfo,
    %     case lib_role:get_role_show(AnswerRoleId) of
    %         #ets_role_show{
    %             figure = Figure, combat_power = CombatPower
    %         } ->
    %             #figure{
    %                 name = Name,
    %                 lv = Lv,
    %                 sex = Sex,
    %                 vip = Vip,
    %                 career = Career,
    %                 turn = Turn
    %             } = Figure,
    %             SendInfo1 = {AnswerRoleId, Name, Lv, CombatPower, Sex, Vip, Career, Turn, Type, AnswerType},
    %             [SendInfo1|AnswerSendList1];
    %         _ ->
    %             ?ERR("get_login_send player not_exist:~p~n", [AnswerRoleId]),
    %             AnswerSendList1
    %     end
    % end,
    % AnswerSendList = lists:foldl(F2, [], AnswerList),
    AnswerSendList = [],
    ?PRINT("get_login_send ProposeSendList ~p~n", [ProposeSendList]),
    {ok, Bin} = pt_172:write(17226, [ProposeSendList, AnswerSendList]),
    lib_server_send:send_to_uid(RoleId, Bin).

open_my_lover(LoverPs, RoleId, Type, NowWeddingState, MarriageTime, LoveNum, _LoveGiftS, _LoveGiftO, HadMarriaged) ->
    #player_status{
        id = LoverRoleId,
        combat_power = CombatPower,
        figure = Figure
    } = LoverPs,
    {ok, Bin} = pt_172:write(17232, [?SUCCESS, LoverRoleId, CombatPower, Figure, Type, NowWeddingState, MarriageTime, LoveNum, HadMarriaged]),
    ?PRINT("open_my_lover ~p~n", [{LoverRoleId, Type, NowWeddingState, MarriageTime, LoveNum}]),
    lib_server_send:send_to_uid(RoleId, Bin).

sql_marriage_life(MarriageLife) ->
    #marriage_life{
        role_id = RoleId,
        stage = Stage,
        heart = Heart
    } = MarriageLife,
    ReSql = io_lib:format(?ReplaceMLifeSql, [RoleId, Stage, Heart]),
    db:execute(ReSql).

get_couple_info(RoleId, CoupleList) ->
    CoupleM = lists:keyfind(RoleId, #marriage_couple.role_id_m, CoupleList),
    CoupleW = lists:keyfind(RoleId, #marriage_couple.role_id_w, CoupleList),
    case CoupleM of
        false ->
            case CoupleW of
                false ->
                    false;
                #marriage_couple{role_id_m = OtherRid} ->
                    {CoupleW, OtherRid}
            end;
        #marriage_couple{role_id_w = OtherRid} ->
            {CoupleM, OtherRid}
    end.

sql_baby(NewBabyStatus, BabyId, BabyIfShow) ->
    #baby_status{
        role_id = RoleId,
        baby_knowledge = BabyKnowledge,
        baby_aptitude = BabyAptitude,
        baby_image = BabyImageList
    } = NewBabyStatus,
    #baby_knowledge{
        stage = Stage,
        star = Star,
        pray_num = PrayNum
    } = BabyKnowledge,
    #baby_aptitude{
        aptitude_lv = AptitudeLv
    } = BabyAptitude,
    SqlList = [begin
        #baby_image_info{
            image_id = ImageId,
            stage = ImageStage,
            pray_num = ImagePrayNum
        } = ImageInfo,
        io_lib:format("(~p, ~p, ~p, ~p)", [RoleId, ImageId, ImageStage, ImagePrayNum])
    end||ImageInfo <- BabyImageList],
    case SqlList of
        [] ->
            skip;
        _ ->
            SqlListStr = ulists:list_to_string(SqlList, ","),
            ReSql1 = io_lib:format(?ReplaceMBabyImageInfoAllSql, [SqlListStr]),
            db:execute(ReSql1)
    end,
    ReSql2 = io_lib:format(?ReplaceMBabyInfoAllSql, [RoleId, Stage, Star, PrayNum, AptitudeLv, BabyId, BabyIfShow]),
    db:execute(ReSql2).

baby_login(Ps) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    % ReSql1 = io_lib:format(?SelectMBabyInfoAllSql, [RoleId]),
    % case db:get_all(ReSql1) of
    %     [] ->
    %         NewBabyStatus = #baby_status{
    %             role_id = RoleId,
    %             if_active = 0,
    %             baby_knowledge = #baby_knowledge{
    %                 stage = 1,
    %                 star = 1
    %             },
    %             baby_aptitude = #baby_aptitude{},
    %             battle_attr = #battle_attr{attr = #attr{}}
    %         },
    %         NewFigure = Figure;
    %     [BabyInfo|_] ->
    %         [_RoleId, Stage, Star, PrayNum, AptitudeLv, BabyId, BabyIfShow] = BabyInfo,
    %         BabyKnowledge = #baby_knowledge{
    %             stage = Stage,
    %             star = Star,
    %             pray_num = PrayNum
    %         },
    %         BabyAptitude = #baby_aptitude{
    %             aptitude_lv = AptitudeLv
    %         },
    %         ReSql2 = io_lib:format(?SelectMBabyImageInfoAllSql, [RoleId]),
    %         case db:get_all(ReSql2) of
    %             [] ->
    %                 BabyImageList = [];
    %             SqlImageList ->
    %                 BabyImageList = [begin
    %                     [_RoleId, ImageId, ImageStage, ImagePrayNum] = SqlInfo,
    %                     #baby_image_info{
    %                         image_id = ImageId,
    %                         stage = ImageStage,
    %                         pray_num = ImagePrayNum
    %                     }
    %                 end||SqlInfo <- SqlImageList]
    %         end,
    %         SkillId = get_skill_id_by_resource_id(BabyId),
    %         NewBabyStatus1 = #baby_status{
    %             role_id = RoleId,
    %             if_active = 1,
    %             baby_knowledge = BabyKnowledge,
    %             baby_aptitude = BabyAptitude,
    %             baby_image = BabyImageList,
    %             skills = [SkillId]
    %         },
    %         NewBabyStatus = count_baby_attribute(NewBabyStatus1),
    %         NewFigure = Figure#figure{
    %             baby_id = BabyId,
    %             baby_if_show = BabyIfShow
    %         }
    % end,
    NewBabyStatus = #baby_status{
        role_id = RoleId,
        if_active = 0,
        baby_knowledge = #baby_knowledge{
            stage = 1,
            star = 1
        },
        baby_aptitude = #baby_aptitude{},
        battle_attr = #battle_attr{attr = #attr{}}
    },
    NewFigure = Figure,
    NewPs = Ps#player_status{
        baby = NewBabyStatus,
        figure = NewFigure
    },
    NewPs.

get_skill_id_by_resource_id(BabyId) ->
    AllImageIdList = data_baby:get_baby_image_id_list(),
    get_skill_id_by_resource_id_1(AllImageIdList, BabyId).

get_skill_id_by_resource_id_1([T|G], BabyId) ->
    BabyActiveCon = data_baby:get_baby_active_con(T),
    #baby_active_con{
        resource_id = ResourceId,
        skill_id = SkillId
    } = BabyActiveCon,
    case BabyId of
        ResourceId ->
            SkillId;
        _ ->
            get_skill_id_by_resource_id_1(G, BabyId)
    end;
get_skill_id_by_resource_id_1([], _BabyId) ->
    ?BabySkillId.

count_baby_attribute(BabyStatus) ->
    AttrList = baby_attr(BabyStatus),
    AttrR1 = lib_player_attr:to_attr_record(AttrList),
    case is_record(AttrR1, attr) of
        false ->
            AttrR = #attr{};
        true ->
            AttrR = AttrR1
    end,
    NewBabyStatus = BabyStatus#baby_status{
        attr = AttrList,
        battle_attr = #battle_attr{attr = AttrR}
    },
    NewBabyStatus.

baby_attr(BabyStatus) ->
    #baby_status{
        if_active = IfActive,
        baby_knowledge = BabyKnowledge,
        baby_aptitude = BabyAptitude,
        baby_image = BabyImageList
    } = BabyStatus,
    case IfActive of
        0 ->
            AttrList = [];
        _ ->
            #baby_knowledge{
                stage = Stage,
                star = Star
            } = BabyKnowledge,
            BabyKnowledgeCon = data_baby:get_baby_knowledge_star_con(Stage, Star),
            #baby_knowledge_star_con{
                attr_list = BabyKnowledgeAttrList
            } = BabyKnowledgeCon,
            #baby_aptitude{
                aptitude_lv = AptitudeLv
            } = BabyAptitude,
            AptitudeLvCon = data_baby:get_baby_aptitude_lv_con(AptitudeLv),
            #baby_aptitude_lv_con{
                attr_list = AptitudeAttrList
            } = AptitudeLvCon,
            F = fun(ImageInfo, ImageAttrList1) ->
                #baby_image_info{
                    image_id = ImageId,
                    stage = ImageStage
                } = ImageInfo,
                ImageStageCon = data_baby:get_baby_image_stage_con(ImageId, ImageStage),
                #baby_image_stage_con{
                    attr_list = ImageInfoAttrList1
                } = ImageStageCon,
                [ImageInfoAttrList1|ImageAttrList1]
            end,
            ImageAttrList = lists:foldl(F, [], BabyImageList),
            AttrList1 = [BabyKnowledgeAttrList, AptitudeAttrList] ++ ImageAttrList,
            AttrList2 = lib_player_attr:add_attr(list, AttrList1),
            AttrList = lib_player_attr:partial_attr_convert(AttrList2)
    end,
    AttrList.

throw_dog_food(Args) ->
    [RoleId, RoleIdM, RoleIdW, DogFoodId, TypeId] = Args,
    PsM = lib_offline_api:get_player_info(RoleIdM, all),
    PsW = lib_offline_api:get_player_info(RoleIdW, all),
    #player_status{
        figure = FigureM
    } = PsM,
    #player_status{
        figure = FigureW
    } = PsW,
    #figure{
        name = NameM
    } = FigureM,
    #figure{
        name = NameW
    } = FigureW,
    case TypeId of
        1 ->
            LanguageId = 7;
        2 ->
            LanguageId = 8;
        _ ->
            LanguageId = 9
    end,
    case RoleId of
        RoleIdM ->
            RoleId1 = RoleIdM,
            Name1 = NameM,
            RoleId2 = RoleIdW,
            Name2 = NameW;
        _ ->
            RoleId1 = RoleIdW,
            Name1 = NameW,
            RoleId2 = RoleIdM,
            Name2 = NameM
    end,
    {ok, Bin} = pt_172:write(17244, [1, RoleIdM, RoleIdW, DogFoodId, NameM, NameW, utime:unixtime()]),
    lib_server_send:send_to_all(Bin),
    lib_chat:send_TV({all}, ?MOD_MARRIAGE, LanguageId, [Name1, RoleId1, Name2, RoleId2, RoleId1, RoleId2, DogFoodId, utime:unixtime()]).

check_get_dog_food([T|G], DogFoodList, RoleId, RoleIdM, RoleIdW, DogFoodId) ->
    #dog_food_info{
        role_id_m = RoleIdM1,
        role_id_w = RoleIdW1,
        type_id = TypeId,
        dog_food_id = UseDogFoodId,
        player_list = PlayerList
    } = T,
    DogFoodCon = data_marriage:get_marriage_show_love_con(TypeId),
    #marriage_show_love_con{
        dog_food = RewardList,
        dog_food_num = DogFoodNum
    } = DogFoodCon,
    if
        length(PlayerList) >= DogFoodNum ->
            {false, ?ERRCODE(err172_df_max)};
        RoleIdM =/= RoleIdM1 ->
            check_get_dog_food(G, DogFoodList, RoleId, RoleIdM, RoleIdW, DogFoodId);
        RoleIdW =/= RoleIdW1 ->
            check_get_dog_food(G, DogFoodList, RoleId, RoleIdM, RoleIdW, DogFoodId);
        DogFoodId =/= UseDogFoodId ->
            check_get_dog_food(G, DogFoodList, RoleId, RoleIdM, RoleIdW, DogFoodId);
        true ->
            case lists:keyfind(RoleId, #dog_food_player.role_id, PlayerList) of
                false ->
                    DogFoodPlayer = #dog_food_player{
                        role_id = RoleId,
                        get_time = utime:unixtime()
                    },
                    [{GoodsType, GoodsId, [MinNum, MaxNum]}|_] = RewardList,
                    RewardNum = urand:rand(MinNum, MaxNum),
                    RewardList1 = [{GoodsType, GoodsId, RewardNum}],
                    NewPlayerList = [DogFoodPlayer|PlayerList],
                    case length(NewPlayerList) >= DogFoodNum of
                        true ->
                            NewDogFoodList = lists:delete(T, DogFoodList),
                            {delete, NewDogFoodList, RewardList1};
                        false ->
                            NewT = T#dog_food_info{
                                player_list = NewPlayerList
                            },
                            NewDogFoodList1 = lists:delete(T, DogFoodList),
                            NewDogFoodList = [NewT|NewDogFoodList1],
                            {true, NewDogFoodList, RewardList1}
                    end;
                _ ->
                    {false, ?ERRCODE(err_df_have_get)}
            end
    end;
check_get_dog_food([], _DogFoodList, _RoleId, _RoleIdM, _RoleIdW, _DogFoodId) ->
    {false, ?ERRCODE(err172_df_max)}.

follow_cancel_personals(Ps, RoleId1, Type, Args1) ->
    #player_status{
        id = FollowRoleId,
        figure = Figure,
        vip = VipStatus
    } = Ps,
    #figure{
        name = Name,
        sex = Sex,
        vip = Vip,
        vip_type = VipType,
        career = Career,
        turn = Turn,
        picture = Picture,
        picture_ver = PictureVer,
        vip_hide = VipHide,
        is_supvip = IsSupvip
    } = Figure,
    VipExp = case VipStatus of
                 #role_vip{ vip_exp = Ve } -> Ve;
                 _ -> 0
             end,
    FollowArgs = {Name, Sex, Career, Turn, Vip, VipType, Picture, PictureVer, VipExp, VipHide, IsSupvip},
    mod_marriage:follow_cancel_personals([RoleId1, FollowRoleId, Type, Args1, FollowArgs]).

cancel_marriage_designation(RoleIdM, RoleIdW) ->
    DesignationIdList = data_wedding:get_wedding_designation_id_list(),
    [begin
        lib_designation_api:cancel_dsgt(RoleIdM, DesignationId),
        lib_designation_api:cancel_dsgt(RoleIdW, DesignationId)
    end||DesignationId <- DesignationIdList].

change_ps_personals(Ps) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        sex = Sex,
        career = Career
    } = Figure,
    Args = [Sex, Career],
    mod_marriage:change_ps_personals([RoleId, Args]).

%% 检查是否结婚
check_marriage_done(RoleId, CoupleList) ->
    CoupleInfo1 = lists:keyfind(RoleId, #marriage_couple.role_id_m, CoupleList),
    CoupleInfo2 = lists:keyfind(RoleId, #marriage_couple.role_id_w, CoupleList),
    CoupleInfo = case CoupleInfo1 of
        false ->
            CoupleInfo2;
        _ ->
            CoupleInfo1
    end,
    case CoupleInfo of
        false ->
            false;
        #marriage_couple{type = Type} ->
            case Type of
                2 ->
                    true;
                _ ->
                    false
            end
    end.

handle_event(Ps, #event_callback{type_id = ?EVENT_RENAME}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus
    } = Ps,
    #figure{
        name = Name,
        lv = Lv
    } = Figure,
    case Lv >= ?MarriageOpenLv of
        true ->
            mod_marriage:rename([RoleId, Name]);
        _ ->
            skip
    end,
    case MarriageStatus#marriage_status.lover_role_id of
        0 ->
            skip;
        LoverRoleId ->
            lib_player:apply_cast(LoverRoleId, ?APPLY_CAST_SAVE, lib_marriage, lover_name_change, [Name])
    end,
    {ok, Ps};

handle_event(Ps, #event_callback{type_id = ?EVENT_PICTURE_CHANGE}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        picture = Picture,
        picture_ver = PictureVer,
        lv = Lv
    } = Figure,
    case Lv >= ?MarriageOpenLv of
        true ->
            mod_marriage:change_pic([RoleId, Picture, PictureVer]);
        _ ->
            skip
    end,
    {ok, Ps};

handle_event(Ps, #event_callback{type_id = ?EVENT_SEND_FLOWER, data = Data}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #callback_flower{to_id=ReceiverId, intimacy=IntimacyPlus, sender=IsSender} = Data,
    case MarriageStatus#marriage_status.lover_role_id == ReceiverId andalso IsSender == true of
        true ->
            add_love_num(RoleId, IntimacyPlus);
        _ ->
            skip
    end,
    {ok, Ps};

handle_event(Ps, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case Lv >= ?PersonalOpenLv andalso MarriageStatus#marriage_status.in_personals == true of
        true ->
            mod_marriage:lv_up([RoleId, Lv]);
        _ ->
            skip
    end,
    {ok, Ps};

handle_event(Ps, _) ->
    {ok, Ps}.

lover_name_change(Ps, NewName) ->
    #player_status{
        figure = Figure,
        marriage = MarriageStatus
    } = Ps,
    case MarriageStatus#marriage_status.lover_role_id of
        0 ->
            NewPs = Ps;
        _ ->
            NewMarriageStatus = MarriageStatus#marriage_status{
                lover_name = NewName
            },
            NewFigure = Figure#figure{
                lover_name = NewName
            },
            NewPs = Ps#player_status{
                figure = NewFigure,
                marriage = NewMarriageStatus
            },
            lib_scene:broadcast_player_figure(NewPs)
    end,
    NewPs.

get_lover_info_db(RoleId) ->
    ReSql = io_lib:format(?SelectMCoupleSql, [RoleId, RoleId]),
    case db:get_all(ReSql) of
        [] ->
            {0, 0, ""};
        [[RoleIdM, RoleIdW, MarriageType]|_] ->
            case RoleId of
                RoleIdM ->
                    LoverRoleId = RoleIdW;
                _ ->
                    LoverRoleId = RoleIdM
            end,
            case lib_player:get_player_low_data(LoverRoleId) of
                [] ->
                    LoverName = "";
                [LoverName|_] ->
                    skip
            end,
            {MarriageType, LoverRoleId, LoverName}
    end.

%% 需要对方玩家信息来进行消息处理：(只用figure信息，如果要用到整个ps的信息，不能使用这个函数)
%% 如果对方在线：cast到对方玩家进程
%% 如果对方不在线：lib_role获取玩家figure的信息
handle_msg_with_other(FollowRoleId, Mod, Fun, Args) ->
    Pid = misc:get_player_process(FollowRoleId),
    case misc:is_process_alive(Pid) of
        true ->
            lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, Mod, Fun, Args);
        _ -> %% 不在线
            case lib_role:get_role_show(FollowRoleId) of
                #ets_role_show{
                    figure = Figure, combat_power = HCombatPower
                } ->
                    LittlePs = #player_status{id = FollowRoleId, figure = Figure, combat_power = HCombatPower},
                    apply(Mod, Fun, [LittlePs|Args]);
                _ ->
                    ?ERR("handle_msg_with_other err, otherid:~p, fun:~p~n", [FollowRoleId, Fun])
            end
    end.

check_tag_list(TagList) ->
    F = fun({TagId, TagSubId}) ->
        case data_marriage:get_tag_info(TagId, TagSubId) of
            [] -> false;
            _ -> true
        end
    end,
    lists:all(F, TagList).

push_love_gift_info_to_couple(CoupleInfo) ->
    #marriage_couple{
        role_id_m = RoleIdM, role_id_w = RoleIdW,
        love_gift_time_m = LoveGiftM, love_gift_time_w = LoveGiftW,
        love_gift_count_m = LoveGiftCountM, love_gift_count_w = LoveGiftCountW
    } = CoupleInfo,
    {ok, Bin} = pt_172:write(17238, [LoveGiftM, LoveGiftW, LoveGiftCountM]),
    lib_server_send:send_to_uid(RoleIdM, Bin),
    {ok, Bin1} = pt_172:write(17238, [LoveGiftW, LoveGiftM, LoveGiftCountW]),
    lib_server_send:send_to_uid(RoleIdW, Bin1).

%% 购买完真爱礼包通知玩家进程修改真爱礼包时间
update_role_love_gift_info(RoleId, ChangeGiftTime) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, update_role_love_gift_info2, [ChangeGiftTime]),
    ok.
update_role_love_gift_info2(Ps, ChangeGiftTime) ->
    #player_status{marriage = MarriageStatus} = Ps,
    NewMarriageStatus = MarriageStatus#marriage_status{
        love_gift_time_s = ChangeGiftTime
    },
    NewPs = Ps#player_status{marriage = NewMarriageStatus},
    {ok, NewPs}.

%% 加恩爱值接口
add_love_num(PS, AddNum)when is_record(PS, player_status) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus
    } = PS,
    #figure{
        lv = Lv
    } = Figure,
    case Lv >= ?MarriageOpenLv of
        false ->
            PS;
        true ->
            #marriage_status{
                lover_role_id = LoverRoleId
            } = MarriageStatus,
            case LoverRoleId of
                0 ->
                    PS;
                _ ->
                    mod_marriage:add_love_num([RoleId, AddNum]),
                    PS
            end
    end;
add_love_num(RoleId, AddNum) when is_integer(RoleId) ->
    mod_marriage:add_love_num([RoleId, AddNum]);
add_love_num(_, _AddNum) ->
    ok.

get_marriage_attr(Stage, Star, true) ->
    case data_ring:get_ring_star_con(Stage, Star) of
        #ring_star_con{marriage_attr = MarriageAttr} -> MarriageAttr;
        _ -> []
    end;
get_marriage_attr(_Stage, _Star, _) ->
    [].

marriage_dun_match(Ps, Type, DunId) ->
    #player_status{id = RoleId, sid = Sid, marriage = MarriageStatus, figure = Figure, combat_power = Power} = Ps,
    case Type of
        0 ->
            MatchDunId = MarriageStatus#marriage_status.in_matching,
            lib_server_send:send_to_sid(Sid, pt_172, 17245, [1, Type, MatchDunId]);
        1 ->
            case data_dungeon:get(DunId) of
                #dungeon{type = ?DUNGEON_TYPE_COUPLE} = Dun ->
                    case lib_dungeon_check:enter_dungeon(Ps, Dun, ?DUN_CREATE) of
                        {false, Code} -> lib_server_send:send_to_sid(Sid, pt_172, 17245, [Code, Type, DunId]);
                        true ->
                            Ps1 = Ps#player_status{marriage = MarriageStatus#marriage_status{in_matching = DunId}},
                            NewPs = lib_player:setup_action_lock(Ps1, ?ERRCODE(err172_in_marriaage_dun_match)),
                            lib_server_send:send_to_sid(Sid, pt_172, 17245, [1, Type, DunId]),
                            mod_marriage_match:enter_match(RoleId, DunId, Figure, Power),
                            {ok, NewPs}
                    end;
                _ -> ok
            end;
        2 ->
            MatchDunId = MarriageStatus#marriage_status.in_matching,
            case MatchDunId of
                DunId ->
                    mod_marriage_match:cancel_match(RoleId),
                    lib_server_send:send_to_sid(Sid, pt_172, 17245, [1, Type, 0]),
                    Ps1 = Ps#player_status{marriage = MarriageStatus#marriage_status{in_matching = 0}},
                    NewPs = lib_player:break_action_lock(Ps1, ?ERRCODE(err172_in_marriaage_dun_match)),
                    {ok, NewPs};
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_172, 17245, [0, Type, DunId]),
                    {ok, Ps}
            end;
        _ -> ok
    end.

clear_marriage_match_state(Ps, OtherId, DunId, IsMale) ->
    #player_status{id = RoleId, sid = Sid, marriage = MarriageStatus} = Ps,
    MatchDunId = MarriageStatus#marriage_status.in_matching,
    case MatchDunId of
        DunId ->
            case IsMale of
                1 ->
                    {ok, Bin} = pt_172:write(17246, [2, [{1, OtherId, #figure{}, 0}, {2, RoleId, #figure{}, 0}], 0]);
                _ ->
                    {ok, Bin} = pt_172:write(17246, [2, [{1, RoleId, #figure{}, 0}, {2, OtherId, #figure{}, 0}], 0])
            end,
            lib_server_send:send_to_sid(Sid, Bin),
            %% 推送一下匹配状态：无匹配
            {ok, Bin1} = pt_172:write(17245, [1, 0, 0]),
            lib_server_send:send_to_sid(Sid, Bin1),
            Ps1 = Ps#player_status{marriage = MarriageStatus#marriage_status{in_matching = 0}},
            NewPs = lib_player:break_action_lock(Ps1, ?ERRCODE(err172_in_marriaage_dun_match)),
            {ok, NewPs};
        _ ->
            {ok, Ps}
    end.

push_role_into_dun(MaleId, FeMaleId, DunId) when is_integer(MaleId) ->
    lib_player:apply_cast(MaleId, ?APPLY_CAST_STATUS, ?MODULE, push_role_into_dun, [FeMaleId, DunId]);
push_role_into_dun(Player, FeMaleId, DunId) ->
    #player_status{id = _RoleId, marriage = MarriageStatus} = Player,
    MatchDunId = MarriageStatus#marriage_status.in_matching,
    Dun = data_dungeon:get(DunId),
    case MatchDunId of
        DunId -> Code = 1;
        _ -> Code = 2
    end,
    ?PRINT("push_role_into_dun Code ~p~n", [Code]),
    DungeonRole = lib_dungeon:trans_to_dungeon_role(Player, Dun),
    lib_player:apply_cast(FeMaleId, ?APPLY_CAST_STATUS, ?MODULE, push_role_into_dun, [DungeonRole, Code, DunId]),
    Player1 = Player#player_status{marriage = MarriageStatus#marriage_status{in_matching = 0}},
    Player2 = lib_player:break_action_lock(Player1, ?ERRCODE(err172_in_marriaage_dun_match)),
    NewPlayer = lib_player:soft_action_lock(Player2, ?ERRCODE(err610_had_on_dungeon), 5),
    {ok, NewPlayer}.

push_role_into_dun(Player, DungeonRole, Code, DunId) ->
    #player_status{id = RoleId, marriage = MarriageStatus} = Player,
    MatchDunId = MarriageStatus#marriage_status.in_matching,
    Dun = data_dungeon:get(DunId),
    case MatchDunId of
        DunId -> Code1 = 1;
        _ -> Code1 = 2
    end,
    ?PRINT("push_role_into_dun Code1 ~p~n", [Code1]),
    DungeonRole1 = lib_dungeon:trans_to_dungeon_role(Player, Dun),
    Player1 = Player#player_status{marriage = MarriageStatus#marriage_status{in_matching = 0}},
    Player2 = lib_player:break_action_lock(Player1, ?ERRCODE(err172_in_marriaage_dun_match)),
    NewPlayer = lib_player:soft_action_lock(Player2, ?ERRCODE(err610_had_on_dungeon), 5),
    if
        Code == 1 andalso Code1 == 1 ->
            AtartArgs = lib_dungeon:get_start_dun_args(Player, Dun),
            ?PRINT("push_role_into_dun AtartArgs ~p~n", [AtartArgs]),
            mod_dungeon:start(0, self(), DunId, [DungeonRole, DungeonRole1], AtartArgs),
            {ok, NewPlayer};
        true ->
            {ok, Bin} = pt_172:write(17246, [?FAIL, [{1, DungeonRole#dungeon_role.id, #figure{}, 0}, {2, RoleId, #figure{}, 0}], 0]),
            lib_server_send:send_to_uid(RoleId, Bin),
            lib_server_send:send_to_uid(DungeonRole#dungeon_role.id, Bin),
            {ok, NewPlayer}
    end.

is_in_personals(RoleId) ->
    Sql = io_lib:format(<<"SELECT `role_id` FROM `marriage_personals_player` where `role_id`=~p ">>, [RoleId]),
    case db:get_row(Sql) of
        [RoleId] -> true;
        _ -> false
    end.

gm_restore_old_player_wedding_times() ->
    case db:get_all(<<"select role_id_1, role_id_2, answer_type, type, propose_type from log_marriage_answer">>) of
        [] -> ok;
        List ->
            F = fun([RoleId1, RoleId2, AnswerType, MarriageType, WeddingType], List1) ->
                case AnswerType == 1 andalso MarriageType == 2 andalso WeddingType > 1 of
                    true -> [{RoleId1, RoleId2, WeddingType}|List1];
                    _ -> List1
                end
            end,
            NewList = lists:foldl(F, [], List),
            mod_marriage:gm_restore_old_player_wedding_times(NewList)
    end.

gm_clean_ring_info(PS) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus,
        goods = StatusGoods
    } = PS,
    #marriage_status{
        type = MarriageType
    } = MarriageStatus,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        ring = Ring
    } = GS,
    #ring{
        stage = Stage,
        star = Star,
        pray_num = PrayNum
    } = Ring,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        NewAttrList = lib_marriage:count_ring_attr_list(1, 1, []),
        NewRing = Ring#ring{
            stage = 1,
            star = 1,
            pray_num = 0,
            attr_list = NewAttrList
        },
        lib_marriage:sql_ring_player(NewRing),
        NewGS2 = GS#goods_status{
            ring = NewRing
        },
        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS2#goods_status.dict),
        lib_goods_api:notify_client_num(RoleId, GoodsL),
        NewGS3 = NewGS2#goods_status{dict = Dict},
        NewStatusGoods = StatusGoods#status_goods{
            ring_attr = NewAttrList
        },
        NewMarriageStatus = MarriageStatus#marriage_status{
            marriage_attr = lib_marriage:get_marriage_attr(1, 1, MarriageType==2)
        },
        NewPs2 = PS#player_status{
            goods = NewStatusGoods,
            marriage = NewMarriageStatus
        },
        NewPs3 = lib_player:count_player_attribute(NewPs2),
        lib_player:send_attribute_change_notify(NewPs3, ?NOTIFY_ATTR),
        {true, ?SUCCESS, 1, 1, 0, NewGS3, NewPs3}
        end,
    {_, Code, NewStage, NewStar, NewPrayNum, NewGS, NewPs} = lib_goods_util:transaction(F),
    lib_goods_do:set_goods_status(NewGS),
    case Code =:= ?SUCCESS of
        true ->
            lib_log_api:log_marriage_ring_upgrade(RoleId, Stage, Star, PrayNum, NewStage, NewStar, NewPrayNum, [{?TYPE_GOODS, 0, 0}]);
        false -> skip
    end,
    {ok, Bin} = pt_172:write(17212, [Code, 0, NewStage, NewStar, NewPrayNum]),
    lib_server_send:send_to_uid(RoleId, Bin),
    NewPs.

use_ring_goods(PS, GS, GoodsInfo, GoodsNum) ->
    #goods_status{ring = Ring} = GS,
    #ring{star = Star} = Ring,
    #goods{goods_id = GoodsTypeId} = GoodsInfo,
    case Star == 0 of
        true -> {false, ?ERRCODE(err172_ring_unlock)};
        _ ->
            [{GoodsTypeIdRing,_,_}|_] = ?RingPrayNumList,
            RewardList = [{?TYPE_GOODS, GoodsTypeIdRing, GoodsNum*30}],
            Name1 = data_goods_type:get_name(GoodsTypeId),
            Name2 = data_goods_type:get_name(GoodsTypeIdRing),
            Title = utext:get(1720018),
            Content = utext:get(1720019, [Name1, GoodsNum, Name2, GoodsNum*30]),
            lib_mail_api:send_sys_mail([PS#player_status.id], Title, Content, RewardList),
            {ok, PS}
    end.


%% 判断性别是否可以结婚
is_sex_can_couple(Sex1, Sex2) ->
    case ?GAME_VER of
        ?GAME_VER_JP ->
            true;
        ?GAME_VER_TW ->
            true;
        ?GAME_VER_EN ->
            true;
        ?GAME_VER_TH ->
            true;
        ?GAME_VER_RU ->
            true;
        _ ->
            case Sex1 =/= Sex2 of
                true -> true;
                _ ->
                    {false, ?ERRCODE(err172_couple_not_same_sex)}
            end
    end.

is_marriage(Ps) ->
    #player_status{ marriage = #marriage_status{ type = Type}} = Ps,
    Type == 2.

one_invite_role(Ps) ->
    #player_status{
        id = PlayerId, marriage = MarriageStatus, guild = #status_guild{ id = GuildId }
    } = Ps,
    #marriage_status{ lover_role_id = LoverRoleId, now_wedding_state = WeddingState } = MarriageStatus,
    if
        LoverRoleId == 0->
            {ok, Bin} = pt_172:write(17298, [?ERRCODE(err172_wedding_not_invite_lover)]),
            lib_server_send:send_to_uid(PlayerId, Bin);
        WeddingState =/= 2 ->
            {ok, Bin} = pt_172:write(17298, [?ERRCODE(err172_wedding_not_order)]),
            lib_server_send:send_to_uid(PlayerId, Bin);
        true ->
            case GuildId =/= 0 of
                true ->
                    Args = [PlayerId, GuildId, [PlayerId, LoverRoleId]],
                    mod_guild:get_guild_member_join_wedding(Args);
                _ ->
                    do_one_invite_role(Ps, [])
            end
    end.

%% 实际一键邀请的主要逻辑
do_one_invite_role(Ps, GuildMembers) ->
    #player_status{
        id = PlayerId, figure = #figure{ name = PlayerName },
        marriage = #marriage_status{ lover_role_id = LoverRoleId }
    } = Ps,
    FriendList = lib_relationship:get_rela_list(PlayerId, 1),
    Fun = fun(I, FixFriendsL) ->
        RoleId = element(1, I),
        RoleLv = element(6, I),
        case RoleId == LoverRoleId orelse RoleLv < 130 of
            true ->
                FixFriendsL;
            _ ->
                RoleName = element(2, I),
                RoleCombat = element(10, I),
                NewInfo = {RoleId, RoleName, RoleCombat},
                lists:keystore(RoleId, 1, FixFriendsL, NewInfo)
        end
    end,
    InviteList = lists:foldl(Fun, GuildMembers, FriendList),
    SortInviteList = lists:reverse(lists:keysort(3, InviteList)),
    Args = [PlayerId, PlayerName, SortInviteList],
    mod_marriage_wedding_mgr:one_invite_role(Args).

%% 求婚礼包升级补发奖励gm
gm_replace_marriage_gift(Time, Title, Content) ->
    ?ERR("Title = ~w, Content = ~w~n",[Title, Content]),
    spawn(fun() ->
            Sql = io_lib:format("select `role_id_1`, `role_id_2` from `log_marriage_answer` where `answer_type` = 1 and `type` = 2 and `propose_type` > 1 and `time` <= ~p", [Time]),
            RoleidList = db:get_all(Sql),
            ?ERR("RoleidList = ~w~n",[RoleidList]),
            F = fun([RoleId1, RoleId2], Acc) ->
                {RoleId1, OldNum} = ulists:keyfind(RoleId1, 1, Acc, {RoleId1, 0}),
                Acc1 = lists:keystore(RoleId1, 1, Acc, {RoleId1, OldNum + 1}),
                {RoleId2, OldNum1} = ulists:keyfind(RoleId2, 1, Acc1, {RoleId2, 0}),
                Acc2 = lists:keystore(RoleId2, 1, Acc1, {RoleId2, OldNum1 + 1}),
                Acc2
                end,
            SendRoleList = lists:foldl(F, [], RoleidList),
            ?ERR("SendRoleList = ~w~n",[SendRoleList]),

            F1 = fun({RoleId, Num}, Acc) ->
                Reward = [{0, 12020005,Num}],
                lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                case Acc rem 100 of
                    0 -> timer:sleep(100), Acc + 1;
                    _ -> Acc + 1
                end end,
        lists:foldl(F1, 0, SendRoleList)
          end).
