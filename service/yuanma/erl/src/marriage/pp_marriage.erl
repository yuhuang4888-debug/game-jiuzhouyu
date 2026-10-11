%%%--------------------------------------
%%% @Module  : pp_marriage
%%% @Author  : huyihao
%%% @Created : 2017.11.17
%%% @Description:  婚姻
%%%--------------------------------------

-module(pp_marriage).

-export([handle/3]).
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("marriage.hrl").
-include("relationship.hrl").
-include("def_module.hrl").
-include("language.hrl").
-include("chat.hrl").
-include("def_fun.hrl").
-include("role.hrl").
-include("rec_baby.hrl").
-include("vip.hrl").
-include("title.hrl").

handle(17200, Ps, [PageId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = Marriage
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    #marriage_status{
        ask_follow_time = AskFollowTime,
        ask_flower_time = AskFlowerTime
    } = Marriage,
    % PersonalsFreeTimes = mod_counter:get_count(RoleId, ?MOD_MARRIAGE, ?PersonalsFreeTimesId),
    % PersonalsFreeTimesMax = mod_counter:get_limit_by_type(?MOD_MARRIAGE, ?PersonalsFreeTimesId),
    % LessFreeTimes = max(0, (PersonalsFreeTimesMax-PersonalsFreeTimes)),
    LessFreeTimes = 0,
    case Lv >= ?PersonalOpenLv of
        true ->
            FriendList = lib_relationship:get_relas_by_types(RoleId, ?RELA_TYPE_FRIEND),
            FriendIntimacyList = [{OtherRid, Intimacy}||#rela{other_rid = OtherRid, intimacy = Intimacy} <- FriendList],
            mod_marriage:open_page_personals([RoleId, PageId, AskFollowTime, AskFlowerTime, LessFreeTimes, FriendIntimacyList]);
        false ->
            {ok, Bin} = pt_172:write(17200, [?LEVEL_LIMIT, PageId, 0, 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 关注/取消关注 玩家
handle(17201, Ps, [FollowRoleId, Type]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        vip = RoleVipStatus
    } = Ps,
    #figure{
        name = Name,
        sex = Sex,
        vip = Vip,
        vip_type = VipType,
        career = Career,
        turn = Turn,
        lv = Lv,
        picture = Picture,
        picture_ver = PictureVer,
        vip_hide = VipHide,
        is_supvip = IsSupvip
    } = Figure,
    case Lv >= ?PersonalOpenLv of
        true ->
            case FollowRoleId of
                RoleId ->
                    {ok, Bin} = pt_172:write(17201, [?ERRCODE(err172_personals_cant_follow_self), FollowRoleId, Type]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    VipExp = case RoleVipStatus of
                                 #role_vip{ vip_exp = Ve } -> Ve;
                                 _ -> 0
                             end,
                    Args = {Name, Lv, Sex, Career, Turn, Vip, VipType, Picture, PictureVer, VipExp, VipHide, IsSupvip},
                    lib_marriage:handle_msg_with_other(FollowRoleId, lib_marriage, follow_cancel_personals, [RoleId, Type, Args])
            end;
        false ->
            {ok, Bin} = pt_172:write(17201, [?LEVEL_LIMIT, FollowRoleId, Type]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 发布信息
handle(17202, Ps, [Msg, Type, TagList]) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus,
        figure = Figure,
        vip = RoleVipStatus
    } = Ps,
    % #marriage_status{
    %     lover_role_id = LoverRoleId
    % } = MarriageStatus,
    ?PRINT("Msg : ~p~n", [Msg]),
    #figure{
        name = Name,
        sex = Sex,
        vip = Vip,
        vip_type = VipType,
        career = Career,
        turn = Turn,
        lv = Lv,
        picture = Picture,
        picture_ver = PictureVer,
        vip_hide = VipHide,
        is_supvip = IsSupvip
    } = Figure,
    case Lv >= ?PersonalOpenLv of
        true ->
            % case LoverRoleId of
            %     0 ->
            % PersonalsFreeTimes = mod_counter:get_count(RoleId, ?MOD_MARRIAGE, ?PersonalsFreeTimesId),
            % PersonalsFreeTimesMax = mod_counter:get_limit_by_type(?MOD_MARRIAGE, ?PersonalsFreeTimesId),
            case lib_marriage:check_tag_list(TagList) of
                true ->
                    case mod_marriage:check_send_personals([RoleId]) of
                        {false, ErrorCode} -> NewPs = Ps;
                        _ ->
                            case Type =:= 0 of
                                true ->
                                    %mod_counter:increment(RoleId, ?MOD_MARRIAGE, ?PersonalsFreeTimesId),
                                    ErrorCode = 1,
                                    NewPs = Ps;
                                false ->
                                    case Type of
                                        0 ->
                                            CostList = ?PersonalsNormalCost;
                                        _ ->
                                            CostList = ?PersonalsSpecialCost
                                    end,
                                    case lib_goods_api:cost_object_list_with_check(Ps, CostList, personals_send, "") of
                                        {true, NewPs} ->
                                            ErrorCode = 1;
                                        {false, ErrorCode, NewPs} ->
                                            skip
                                    end
                            end
                    end;
                _ ->
                    ErrorCode = ?MISSING_CONFIG, NewPs = Ps
            end;
            %     _ ->
            %         ErrorCode = ?ERRCODE(err172_couple_self_not_single),
            %         NewPs = Ps
            % end;
        false ->
            ErrorCode = ?LEVEL_LIMIT,
            NewPs = Ps
    end,
    case ErrorCode of
        1 ->
            VipExp = case RoleVipStatus of
                         #role_vip{ vip_exp = Ve } -> Ve;
                         _ -> 0
                     end,
            Args = {Name, Lv, Sex, Career, Turn, Vip, VipType, Picture, PictureVer, VipExp, VipHide, IsSupvip},
            mod_marriage:send_personals([RoleId, Msg, Type, TagList, Args]),
            LastPs = NewPs#player_status{marriage = MarriageStatus#marriage_status{in_personals = true}};
        _ ->
            {ok, Bin} = pt_172:write(17202, [ErrorCode, Type]),
            lib_server_send:send_to_uid(RoleId, Bin),
            LastPs = NewPs
    end,
    {ok, LastPs};

%% 求关注/求送花
% handle(17203, Ps, [Type, Msg]) ->
%     #player_status{
%         id = RoleId,
%         figure = Figure,
%         marriage = Marriage
%     } = Ps,
%     #figure{
%         name = Name
%     } = Figure,
%     #marriage_status{
%         lover_role_id = LoverRoleId,
%         ask_follow_time = AskFollowTime,
%         ask_flower_time = AskFlowerTime
%     } = Marriage,
%     NowTime = utime:unixtime(),
%     case LoverRoleId of
%         0 ->
%             case Type of
%                 1 ->
%                     case AskFlowerTime =:= 0 orelse NowTime-AskFlowerTime >= ?PersonalsAskflowerTime of
%                         true ->
%                             Code = ?SUCCESS,
%                             NewMarriage = Marriage#marriage_status{
%                                 ask_flower_time = NowTime
%                             },
%                             NewPs = Ps#player_status{
%                                 marriage = NewMarriage
%                             },
%                             SendTime = NowTime,
%                             lib_chat:send_TV({all}, ?MOD_MARRIAGE, 3, [Name, RoleId, Msg, Name]),
%                             ReSql = io_lib:format(?ReplaceMarriageAskTimeSql, [RoleId, AskFollowTime, NowTime]),
%                             db:execute(ReSql);
%                         false ->
%                             Code = ?ERRCODE(err172_personals_send_cd),   %% cd中
%                             NewPs = Ps,
%                             SendTime = AskFlowerTime
%                     end;
%                 _ ->
%                     case AskFollowTime =:= 0 orelse NowTime-AskFollowTime >= ?PersonalsAskfollowTime of
%                         true ->
%                             Code = ?SUCCESS,
%                             NewMarriage = Marriage#marriage_status{
%                                 ask_follow_time = NowTime
%                             },
%                             NewPs = Ps#player_status{
%                                 marriage = NewMarriage
%                             },
%                             SendTime = NowTime,
%                             lib_chat:send_TV({all}, ?MOD_MARRIAGE, 4, [Name, RoleId, Msg, RoleId]),
%                             ReSql = io_lib:format(?ReplaceMarriageAskTimeSql, [RoleId, NowTime, AskFlowerTime]),
%                             db:execute(ReSql);
%                         false ->
%                             Code = ?ERRCODE(err172_personals_send_cd),   %% cd中
%                             NewPs = Ps,
%                             SendTime = AskFollowTime
%                     end
%             end;
%         _ ->
%             Code = ?ERRCODE(err172_couple_self_not_single),
%             NewPs = Ps,
%             SendTime = AskFollowTime
%     end,
%     {ok, Bin} = pt_172:write(17203, [Code, Type, SendTime]),
%     lib_server_send:send_to_uid(RoleId, Bin),
%     {ok, NewPs};

%% 修改交友信息
handle(17204, Ps, [Msg, TagList]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    case length(Msg) == 0 andalso length(Msg) == 0 of
        true -> {ok, Ps};
        _ ->
            case Figure#figure.lv >= ?PersonalOpenLv of
                true ->
                    case lib_marriage:check_tag_list(TagList) == true of
                        true ->
                            ErrorCode = 1;
                        _ ->
                            ErrorCode = ?MISSING_CONFIG
                    end;
                false ->
                    ErrorCode = ?LEVEL_LIMIT
            end,
            case ErrorCode of
                1 ->
                    mod_marriage:change_personal_msg([RoleId, Msg, TagList]);
                _ ->
                    {ok, Bin} = pt_172:write(17204, [ErrorCode, Msg, TagList]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end,
            {ok, Ps}
    end;

%% 获取玩家细节信息
handle(17205, Ps, [OtherRid]) ->
    #player_status{
        sid = Sid,
        figure = Figure
    } = Ps,
    case Figure#figure.lv >= ?PersonalOpenLv of
        true ->
            case lib_role:get_role_show(OtherRid) of
                #ets_role_show{figure = OtherFigure} ->
                    #figure{guild_id = OtherGuildId, guild_name = OtherGuildName} = OtherFigure,
                    lib_server_send:send_to_sid(Sid, pt_172, 17205, [OtherRid, OtherGuildId, OtherGuildName]);
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_172, 17205, [OtherRid, 0, ""])
            end;
        false ->
            ok
    end;

%% 打开戒指界面
handle(17210, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case Lv >= ?MarriageOpenLv of
        true ->
            Code = ?SUCCESS,
            GS = lib_goods_do:get_goods_status(),
            #goods_status{
                ring = Ring
            } = GS,
            #ring{
                stage = Stage,
                star = Star,
                pray_num = PrayNum,
                attr_list = AttrList,
                polish_list = PolishList
            } = Ring,
            RingAttr = lib_player_attr:add_attr(record, [AttrList]),
            RingCombatPower = lib_player:calc_all_power(RingAttr);
        false ->
            Code = ?LEVEL_LIMIT,
            Stage = 0,
            Star = 0,
            PrayNum = 0,
            RingCombatPower = 0,
            PolishList = [],
            AttrList = []
    end,
    ?PRINT("17210 ~p~n", [{Stage, Star, PrayNum, RingCombatPower}]),
    {ok, Bin} = pt_172:write(17210, [Code, Stage, Star, PrayNum, RingCombatPower, PolishList, AttrList]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 打磨戒指
% handle(17211, Ps, [GoodsTypeId]) ->
%     #player_status{
%         id = RoleId,
%         figure = Figure,
%         goods = StatusGoods
%     } = Ps,
%     #figure{
%         lv = Lv
%     } = Figure,
%     case Lv >= ?MarriageOpenLv of
%         false ->
%             Code = ?LEVEL_LIMIT,   %% 等级不足
%             NewPolishList = [],
%             NewPs = Ps;
%         true ->
%             case data_ring:get_ring_polish_con(GoodsTypeId) of
%                 false ->
%                     Code = ?ERRCODE(err172_ring_not_polish),   %% 不是打磨的物品
%                     NewPolishList = [],
%                     NewPs = Ps;
%                 RingPolishCon ->
%                     GS = lib_goods_do:get_goods_status(),
%                     #goods_status{
%                         ring = Ring
%                     } = GS,
%                     #ring{
%                         stage = Stage,
%                         star = Star,
%                         polish_list = PolishList
%                     } = Ring,
%                     #ring_polish_con{
%                         use_max = UseMax
%                     } = RingPolishCon,
%                     case lists:keyfind(GoodsTypeId, 1, PolishList) of
%                         false ->
%                             Code1 = 1,
%                             NewGoodsKeyNum = {GoodsTypeId, 1};
%                         {_GoodsTypeId, UseNum} ->
%                             case UseNum+1 =< UseMax of
%                                 true ->
%                                     Code1 = 1,
%                                     NewGoodsKeyNum = {GoodsTypeId, UseNum+1};
%                                 false ->
%                                     Code1 = 2,
%                                     NewGoodsKeyNum = {GoodsTypeId, UseNum}
%                             end
%                     end,
%                     case Code1 of
%                         1 ->
%                             case lib_goods_api:check_object_list(Ps, [{?TYPE_GOODS, GoodsTypeId, 1}]) of
%                                 {false, Code} ->
%                                     NewPolishList = [],
%                                     NewPs = Ps;
%                                 true ->
%                                     F = fun() ->
%                                         ok = lib_goods_dict:start_dict(),
%                                         case lib_goods_util:cost_object_list(Ps, [{?TYPE_GOODS, GoodsTypeId, 1}], ring_polish, "", GS) of
%                                             {true, NewGS1, NewPs1} ->
%                                                 Code2 = ?SUCCESS,
%                                                 NewPolishList1 = lists:keystore(GoodsTypeId, 1, PolishList, NewGoodsKeyNum),
%                                                 NewAttrList = lib_marriage:count_ring_attr_list(Stage, Star, NewPolishList1),
%                                                 NewRing = Ring#ring{
%                                                     attr_list = NewAttrList,
%                                                     polish_list = NewPolishList1
%                                                 },
%                                                 lib_marriage:sql_ring_player(NewRing),
%                                                 NewGS2 = NewGS1#goods_status{
%                                                     ring = NewRing
%                                                 },
%                                                 {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS2#goods_status.dict),
%                                                 lib_goods_api:notify_client_num(RoleId, GoodsL),
%                                                 NewGS3 = NewGS2#goods_status{dict = Dict},
%                                                 NewStatusGoods = StatusGoods#status_goods{
%                                                     ring_attr = NewAttrList
%                                                 },
%                                                 NewPs2 = NewPs1#player_status{
%                                                     goods = NewStatusGoods
%                                                 },
%                                                 NewPs3 = lib_player:count_player_attribute(NewPs2),
%                                                 lib_player:send_attribute_change_notify(NewPs3, ?NOTIFY_ATTR),
%                                                 {true, Code2, NewPolishList1, NewGS3, NewPs3};
%                                             {false, Code2, NewGS3, NewPs3} ->
%                                                 {false, Code2, [], NewGS3, NewPs3}
%                                         end
%                                     end,
%                                     {_, Code, NewPolishList, NewGS, NewPs} = lib_goods_util:transaction(F),
%                                     lib_goods_do:set_goods_status(NewGS),
%                                     case Code =:= ?SUCCESS of
%                                         true ->
%                                             lib_log_api:log_marriage_ring_polish(RoleId, PolishList, NewPolishList, [{?TYPE_GOODS, GoodsTypeId, 1}]);
%                                         false ->
%                                             skip
%                                     end
%                             end;
%                         _ ->
%                             Code = ?ERRCODE(err172_marriage_max), %% 已达上限
%                             NewPolishList = [],
%                             NewPs = Ps
%                     end
%             end
%     end,
%     {ok, Bin} = pt_172:write(17211, [Code, GoodsTypeId, NewPolishList]),
%     lib_server_send:send_to_uid(RoleId, Bin),
%     {ok, NewPs};

%% 解锁
handle(17211, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus,
        goods = StatusGoods
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    #marriage_status{
        type = MarriageType
    } = MarriageStatus,
    case Lv >= ?MarriageOpenLv of
        false ->
            Code = ?LEVEL_LIMIT,   %% 等级不足
            NewStage = 0,
            NewStar = 0,
            NewPrayNum = 0,
            NewPs = Ps;
        true ->
            GS = lib_goods_do:get_goods_status(),
            #goods_status{
                ring = Ring
            } = GS,
            #ring{
                star = Star,
                polish_list = PolishList
            } = Ring,
            case Star == 0 of
                false ->
                    Code = ?ERRCODE(err172_ring_unlock),   %% 已解锁
                    NewStage = 0,
                    NewStar = 0,
                    NewPrayNum = 0,
                    NewPs= Ps;
                true ->
                    GoodsTypeId = ?RingUnLockGoods,
                    case lib_goods_api:check_object_list(Ps, [{?TYPE_GOODS, GoodsTypeId, 1}]) of
                        {false, Code} ->
                            NewStage = 0,
                            NewStar = 0,
                            NewPrayNum = 0,
                            NewPs = Ps;
                        true ->
                            F = fun() ->
                                ok = lib_goods_dict:start_dict(),
                                case lib_goods_util:cost_object_list(Ps, [{?TYPE_GOODS, GoodsTypeId, 1}], ring_unlock, "", GS) of
                                    {true, NewGS1, NewPs1} ->
                                        Code2 = ?SUCCESS,
                                        {NewStage, NewStar, NewPrayNum} = {1, 1, 0},
                                        NewAttrList = lib_marriage:count_ring_attr_list(NewStage, NewStar, PolishList),
                                        NewRing = Ring#ring{
                                            stage = NewStage,
                                            star = NewStar,
                                            pray_num = NewPrayNum,
                                            attr_list = NewAttrList
                                        },
                                        lib_marriage:sql_ring_player(NewRing),
                                        NewGS2 = NewGS1#goods_status{
                                            ring = NewRing
                                        },
                                        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS2#goods_status.dict),
                                        lib_goods_api:notify_client_num(RoleId, GoodsL),
                                        NewGS3 = NewGS2#goods_status{dict = Dict},
                                        NewStatusGoods = StatusGoods#status_goods{
                                            ring_attr = NewAttrList
                                        },
                                        NewMarriageStatus = MarriageStatus#marriage_status{
                                            marriage_attr = lib_marriage:get_marriage_attr(NewStage, NewStar, MarriageType==2)
                                        },
                                        NewPs2 = NewPs1#player_status{
                                            goods = NewStatusGoods,
                                            marriage = NewMarriageStatus
                                        },
                                        NewPs3 = lib_player:count_player_attribute(NewPs2),
                                        lib_player:send_attribute_change_notify(NewPs3, ?NOTIFY_ATTR),
                                        {true, Code2, NewStage, NewStar, NewPrayNum, NewGS3, NewPs3};
                                    {false, Code2, NewGS1, NewPs1} ->
                                        {false, Code2, 0, 0, 0, NewGS1, NewPs1}
                                end
                            end,
                            {_, Code, NewStage, NewStar, NewPrayNum, NewGS, NewPs} = lib_goods_util:transaction(F),
                            lib_goods_do:set_goods_status(NewGS)
                    end
            end
    end,
    ?PRINT("17211 Code ~p~n", [Code]),
    {ok, Bin} = pt_172:write(17211, [Code, NewStage, NewStar, NewPrayNum]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, battle_attr, NewPs};

%% 戒指提升
handle(17212, Ps, [GoodsTypeId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus,
        goods = StatusGoods
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    #marriage_status{
        type = MarriageType
    } = MarriageStatus,
    case Lv >= ?MarriageOpenLv of
        false ->
            Code = ?LEVEL_LIMIT,   %% 等级不足
            NewStage = 0,
            NewStar = 0,
            NewPrayNum = 0,
            NewPs = Ps;
        true ->
            case lists:keyfind(GoodsTypeId, 1, ?RingPrayNumList) of
                false ->
                    Code = ?ERRCODE(err172_marriage_not_pray),   %% 不是祝福消耗品
                    NewStage = 0,
                    NewStar = 0,
                    NewPrayNum = 0,
                    NewPs = Ps;
                {_GoodsTypeId, AddPrayNum, RatioList} ->
                    GS = lib_goods_do:get_goods_status(),
                    #goods_status{
                        ring = Ring
                    } = GS,
                    #ring{
                        stage = Stage,
                        star = Star,
                        pray_num = PrayNum,
                        polish_list = PolishList
                    } = Ring,
                    case lib_marriage:check_ring_max(Stage, Star) of
                        false ->
                            Code = ?ERRCODE(err172_marriage_max),   %% 已达上限
                            NewStage = 0,
                            NewStar = 0,
                            NewPrayNum = 0,
                            NewPs= Ps;
                        true ->
                            NAddPrayNum = ?IF(RatioList == [], AddPrayNum, round(urand:rand_with_weight(RatioList) * AddPrayNum)),
                            case lib_goods_api:check_object_list(Ps, [{?TYPE_GOODS, GoodsTypeId, 1}]) of
                                {false, Code} ->
                                    NewStage = 0,
                                    NewStar = 0,
                                    NewPrayNum = 0,
                                    NewPs = Ps;
                                true ->
                                    F = fun() ->
                                        ok = lib_goods_dict:start_dict(),
                                        case lib_goods_util:cost_object_list(Ps, [{?TYPE_GOODS, GoodsTypeId, 1}], ring_pray, "", GS) of
                                            {true, NewGS1, NewPs1} ->
                                                Code2 = ?SUCCESS,
                                                {NewStage, NewStar, NewPrayNum} = lib_marriage:ring_upgrade(Stage, Star, PrayNum, NAddPrayNum),
                                                NewAttrList = lib_marriage:count_ring_attr_list(NewStage, NewStar, PolishList),
                                                NewRing = Ring#ring{
                                                    stage = NewStage,
                                                    star = NewStar,
                                                    pray_num = NewPrayNum,
                                                    attr_list = NewAttrList
                                                },
                                                lib_marriage:sql_ring_player(NewRing),
                                                NewGS2 = NewGS1#goods_status{
                                                    ring = NewRing
                                                },
                                                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS2#goods_status.dict),
                                                lib_goods_api:notify_client_num(RoleId, GoodsL),
                                                NewGS3 = NewGS2#goods_status{dict = Dict},
                                                NewStatusGoods = StatusGoods#status_goods{
                                                    ring_attr = NewAttrList
                                                },
                                                NewMarriageStatus = MarriageStatus#marriage_status{
                                                    marriage_attr = lib_marriage:get_marriage_attr(NewStage, NewStar, MarriageType==2)
                                                },
                                                NewPs2 = NewPs1#player_status{
                                                    goods = NewStatusGoods,
                                                    marriage = NewMarriageStatus
                                                },
                                                NewPs3 = lib_player:count_player_attribute(NewPs2),
                                                lib_player:send_attribute_change_notify(NewPs3, ?NOTIFY_ATTR),
                                                {true, Code2, NewStage, NewStar, NewPrayNum, NewGS3, NewPs3};
                                            {false, Code2, NewGS1, NewPs1} ->
                                                {false, Code2, 0, 0, 0, NewGS1, NewPs1}
                                        end
                                    end,
                                    {_, Code, NewStage, NewStar, NewPrayNum, NewGS, NewPs} = lib_goods_util:transaction(F),
                                    lib_goods_do:set_goods_status(NewGS),
                                    case Code =:= ?SUCCESS of
                                        true ->
                                            lib_log_api:log_marriage_ring_upgrade(RoleId, Stage, Star, PrayNum, NewStage, NewStar, NewPrayNum, [{?TYPE_GOODS, GoodsTypeId, 1}]);
                                        false ->
                                            skip
                                    end
                            end
                    end
            end
    end,
    ?PRINT("17212 Code ~p~n", [Code]),
    {ok, Bin} = pt_172:write(17212, [Code, GoodsTypeId, NewStage, NewStar, NewPrayNum]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, battle_attr, NewPs};

%% 戒指一键提升
handle(17213, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus,
        goods = StatusGoods
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    #marriage_status{
        type = MarriageType
    } = MarriageStatus,
    case Lv >= ?MarriageOpenLv of
        false ->
            Code = ?LEVEL_LIMIT,   %% 等级不足
            NewStage = 0,
            NewStar = 0,
            NewPrayNum = 0,
            NewPs = Ps;
        true ->
            GS = lib_goods_do:get_goods_status(),
            #goods_status{
                dict = Dict,
                ring = Ring
            } = GS,
            #ring{
                stage = Stage,
                star = Star,
                pray_num = PrayNum,
                polish_list = PolishList
            } = Ring,
            case lib_marriage:check_ring_max(Stage, Star) of
                false ->
                    Code = ?ERRCODE(err172_marriage_max),   %% 已达上限
                    NewStage = 0,
                    NewStar = 0,
                    NewPrayNum = 0,
                    NewPs= Ps;
                true ->
                    GoodsIdNumList = [begin
                        case data_goods_type:get(GoodsTypeId) of
                            #ets_goods_type{bag_location = BagLocation} ->
                                GoodsList = lib_goods_util:get_type_goods_list(RoleId, GoodsTypeId, BagLocation, Dict),
                                TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
                                {GoodsTypeId, TotalNum};
                            _ ->
                                ?ERR("goods_num err: goods_type_id = ~p err_config", [GoodsTypeId]),
                                {GoodsTypeId, 0}
                        end
                    end||{GoodsTypeId, _AddPrayNum, _} <- ?RingPrayNumList],
                    case lib_marriage:ring_upgrade_all(Stage, Star, PrayNum, GoodsIdNumList, [], []) of
                        {_NewStage1, _NewStar1, _NewPrayNum1, [], _BaojiList} ->
                            Code = ?GOODS_NOT_ENOUGH,   %% 物品不足
                            NewStage = 0,
                            NewStar = 0,
                            NewPrayNum = 0,
                            NewPs = Ps;
                        {NewStage1, NewStar1, NewPrayNum1, CostList, _BaojiList} ->
                            case lib_goods_api:check_object_list(Ps, CostList) of
                                {false, Code} ->
                                    NewStage = 0,
                                    NewStar = 0,
                                    NewPrayNum = 0,
                                    NewPs = Ps;
                                true ->
                                    F = fun() ->
                                        ok = lib_goods_dict:start_dict(),
                                        case lib_goods_util:cost_object_list(Ps, CostList, ring_pray, "", GS) of
                                            {true, NewGS1, NewPs1} ->
                                                Code2 = ?SUCCESS,
                                                NewAttrList = lib_marriage:count_ring_attr_list(NewStage1, NewStar1, PolishList),
                                                NewRing = Ring#ring{
                                                    stage = NewStage1,
                                                    star = NewStar1,
                                                    pray_num = NewPrayNum1,
                                                    attr_list = NewAttrList
                                                },
                                                lib_marriage:sql_ring_player(NewRing),
                                                NewGS2 = NewGS1#goods_status{
                                                    ring = NewRing
                                                },
                                                {NewDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS2#goods_status.dict),
                                                lib_goods_api:notify_client_num(RoleId, GoodsL),
                                                NewGS3 = NewGS2#goods_status{dict = NewDict},
                                                NewStatusGoods = StatusGoods#status_goods{
                                                    ring_attr = NewAttrList
                                                },
                                                NewMarriageStatus = MarriageStatus#marriage_status{
                                                    marriage_attr = lib_marriage:get_marriage_attr(NewStage1, NewStar1, MarriageType==2)
                                                },
                                                NewPs2 = NewPs1#player_status{
                                                    goods = NewStatusGoods,
                                                    marriage = NewMarriageStatus
                                                },
                                                NewPs3 = lib_player:count_player_attribute(NewPs2),
                                                lib_player:send_attribute_change_notify(NewPs3, ?NOTIFY_ATTR),
                                                {true, Code2, NewStage1, NewStar1, NewPrayNum1, NewGS3, NewPs3};
                                            {false, Code2, NewGS3, NewPs3} ->
                                                {false, Code2, 0, 0, 0, NewGS3, NewPs3}
                                        end
                                    end,
                                    {_, Code, NewStage, NewStar, NewPrayNum, NewGS, NewPs} = lib_goods_util:transaction(F),
                                    lib_goods_do:set_goods_status(NewGS),
                                    case Code =:= ?SUCCESS of
                                        true ->
                                            lib_log_api:log_marriage_ring_upgrade(RoleId, Stage, Star, PrayNum, NewStage, NewStar, NewPrayNum, CostList);
                                        false ->
                                            skip
                                    end
                            end;
                        _ ->
                            Code = ?FAIL,   %% 失败
                            NewStage = 0,
                            NewStar = 0,
                            NewPrayNum = 0,
                            NewPs = Ps
                    end
            end
    end,
    ?PRINT("17213 Code ~p~n", [Code]),
    {ok, Bin} = pt_172:write(17213, [Code, NewStage, NewStar, NewPrayNum]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, battle_attr, NewPs};

%% 打开表白界面
% handle(17220, Ps, [OtherRid]) ->
%     #player_status{
%         id = RoleId,
%         combat_power = CombatPower,
%         figure = Figure
%     } = Ps,
%     #figure{
%         lv = Lv,
%         name = Name,
%         sex = Sex,
%         vip = Vip,
%         career = Career,
%         turn = Turn
%     } = Figure,
%     case Lv >= ?MarriageOpenLv of
%         false ->
%             {ok, Bin} = pt_172:write(17220, [?LEVEL_LIMIT, OtherRid, "", 0, 0, 0, 0, 0, 0]),
%             lib_server_send:send_to_uid(RoleId, Bin);
%         true ->
%             CheckResult = lib_marriage:check_biaobai_self(RoleId, OtherRid, 1),
%             Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
%             lib_marriage:handle_msg_with_other(OtherRid, lib_marriage, open_biaobai, [Args, CheckResult])
%             lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, open_biaobai, [Args, CheckResult])
%     end;

%% 发送表白
% handle(17221, Ps, [OtherRid, Msg]) ->
%     #player_status{
%         id = RoleId,
%         combat_power = CombatPower,
%         figure = Figure
%     } = Ps,
%     #figure{
%         lv = Lv,
%         name = Name,
%         sex = Sex,
%         vip = Vip,
%         career = Career,
%         turn = Turn
%     } = Figure,
%     case Lv >= ?MarriageOpenLv of
%         false ->
%             {ok, Bin} = pt_172:write(17221, [?LEVEL_LIMIT]),
%             lib_server_send:send_to_uid(RoleId, Bin);
%         true ->
%             CheckResult = lib_marriage:check_biaobai_self(RoleId, OtherRid, 1),
%             Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
%             lib_marriage:handle_msg_with_other(OtherRid, lib_marriage, send_biaobai, [Args, Msg, CheckResult])
%             lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, send_biaobai, [Args, Msg, CheckResult])
%     end;

%% 回应表白/求婚
handle(17223, Ps, [OtherRid, AnswerType]) ->
    #player_status{
        id = RoleId,
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
    case AnswerType of
        1 ->
            case mod_marriage:check_answer_biaobai([RoleId, OtherRid]) of
                {false, Code1} ->
                    OtherCostKey = "",
                    ProposeCost = [],
                    NewPs = Ps;
                {true, ProposeType, _OtherCostList, _CostKey} ->
                    case data_marriage:get_propose_info(ProposeType) of
                        #base_propose_cfg{cost = Cost} ->
                            ProposeCost = Cost,
                            case lib_player:get_alive_pid(OtherRid) of
                                false ->
                                    Code1 = ?ERRCODE(err140_14_not_online),
                                    OtherCostKey = "",
                                    NewPs = Ps;
                                Pid ->
                                    case catch lib_player:apply_call(Pid, ?APPLY_CALL_SAVE, lib_goods_api, cost_object_list_with_check, [ProposeCost, propose, ""]) of
                                        true ->
                                            Code1 = 1,
                                            OtherCostKey = "",
                                            NewPs = Ps;
                                        ErrCode when is_integer(ErrCode) ->
                                            Code1 = ?ERRCODE(err172_other_money_not_enough),
                                            OtherCostKey = "",
                                            NewPs = Ps;
                                        _Err ->
                                            ?ERR("answer biaobai err ~p~n", [_Err]),
                                            Code1 = ?FAIL,
                                            OtherCostKey = "",
                                            NewPs = Ps
                                    end
                            end;
                        _ ->
                            Code1 = ?ERRCODE(err172_fouple_have_not_biaobai),
                            OtherCostKey = "",
                            ProposeCost = [],
                            NewPs = Ps
                    end
            end;
        _ ->
            Code1 = 1,
            OtherCostKey = "",
            ProposeCost = [],
            NewPs = Ps
    end,
    ?PRINT("Code1 ~p~n", [Code1]),
    case Code1 of
        1 ->
            Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
            lib_marriage:handle_msg_with_other(OtherRid, lib_marriage, marriage_behavior, [Args, "", AnswerType, 0, 3, [OtherCostKey, ProposeCost]]);
            %lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, marriage_behavior, [Args, "", AnswerType, 0, 3, [OtherCostKey]]);
        _ ->
            {ok, Bin} = pt_172:write(17223, [Code1, OtherRid, AnswerType]),
            lib_server_send:send_to_uid(RoleId, Bin),
            mod_marriage:delete_propose([OtherRid, RoleId])
    end,
    {ok, NewPs};

%% 确认表白/求婚结果
% handle(17225, Ps, [OtherRid]) ->
%     #player_status{
%         id = RoleId
%     } = Ps,
%     mod_marriage:sure_answer([RoleId, OtherRid]);

%% 登录表白/求婚信息
handle(17226, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case Lv >= ?MarriageOpenLv of
        false ->
            skip;
        true ->
            mod_marriage:get_login_send(RoleId)
    end;

%% 打开求婚界面
% handle(17230, Ps, [OtherRid]) ->
%     #player_status{
%         id = RoleId,
%         combat_power = CombatPower,
%         marriage = MarriageStatus,
%         figure = Figure
%     } = Ps,
%     #figure{
%         lv = Lv,
%         name = Name,
%         sex = Sex,
%         vip = Vip,
%         career = Career,
%         turn = Turn
%     } = Figure,
%     #marriage_status{
%         lover_role_id = LoverRoleId,
%         type = Type
%     } = MarriageStatus,
%     case Lv >= ?MarriageOpenLv of
%         false ->
%             skip;
%         true ->
%             if
%                 LoverRoleId =:= 0 ->
%                     {ok, Bin} = pt_172:write(17230, [?ERRCODE(err172_couple_single), OtherRid, "", 0, 0, 0, 0, 0, 0]),
%                     lib_server_send:send_to_uid(RoleId, Bin);
%                 LoverRoleId =/= OtherRid ->
%                     {ok, Bin} = pt_172:write(17230, [?ERRCODE(err172_couple_not_lover), OtherRid, "", 0, 0, 0, 0, 0, 0]),
%                     lib_server_send:send_to_uid(RoleId, Bin);
%                 Type =/= 1 ->
%                     {ok, Bin} = pt_172:write(17230, [?ERRCODE(err172_couple_have_marry), OtherRid, "", 0, 0, 0, 0, 0, 0]),
%                     lib_server_send:send_to_uid(RoleId, Bin);
%                 true ->
%                     case lib_marriage:check_biaobai_self(RoleId, OtherRid, 2) of
%                         {false, Code} ->
%                             {ok, Bin} = pt_172:write(17230, [Code, OtherRid, "", 0, 0, 0, 0, 0, 0]),
%                             lib_server_send:send_to_uid(RoleId, Bin);
%                         true ->
%                             Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
%                             lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, marriage_behavior, [Args, "", 0, 0, 4, []])
%                     end
%             end
%     end;

%% 进行求婚
handle(17231, Ps, [OtherRid, WeddingType, Msg, _IfAA]) ->
    #player_status{
        id = RoleId,
        combat_power = CombatPower,
        marriage = MarriageStatus,
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
    #marriage_status{
        lover_role_id = _LoverRoleId,
        type = MarriageType,
        now_wedding_state = _NowWeddingState
    } = MarriageStatus,
    case Lv >= ?MarriageOpenLv of
        false ->
            NewPs = Ps;
        true ->
            case data_marriage:get_propose_info(WeddingType) of
                [] ->
                    NewPs = Ps,
                    {ok, Bin} = pt_172:write(17231, [?MISSING_CONFIG, OtherRid]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                ProposeInfo ->
                    IsOnlineOther = lib_player:is_online_global(OtherRid),
                    if
                        % LoverRoleId =:= 0 ->
                        %     NewPs = Ps,
                        %     {ok, Bin} = pt_172:write(17231, [?ERRCODE(err172_couple_single), OtherRid]),
                        %     lib_server_send:send_to_uid(RoleId, Bin);
                        % LoverRoleId =/= OtherRid ->
                        %     NewPs = Ps,
                        %     {ok, Bin} = pt_172:write(17231, [?ERRCODE(err172_couple_not_lover), OtherRid]),
                        %     lib_server_send:send_to_uid(RoleId, Bin);
                        % MarriageType =:= 2 andalso IfAA =:= 0 ->
                        %     NewPs = Ps,
                        %     {ok, Bin} = pt_172:write(17231, [?ERRCODE(err172_couple_have_marry), OtherRid]),
                        %     lib_server_send:send_to_uid(RoleId, Bin);
                        IsOnlineOther == false ->
                            NewPs = Ps,
                            {ok, Bin} = pt_172:write(17231, [?ERRCODE(err140_14_not_online), OtherRid]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        true ->
                            % case MarriageType of
                            %     1 ->
                            case lib_marriage:check_biaobai_self(RoleId, OtherRid, 2) of
                                {false, Code1} ->
                                    skip;
                                true ->
                                    Code1 = 1
                            end,
                            %     _ ->
                            %         case NowWeddingState of
                            %             1 ->
                            %                 Code1 = 1;
                            %             _ ->
                            %                 Code1 = ?ERRCODE(err172_please_order_wedding)
                            %         end
                            % end,
                            ?PRINT("Code1 ~p~n", [Code1]),
                            case Code1 of
                                1 ->
                                    OtherPid = misc:get_player_process(OtherRid),
                                    case misc:is_process_alive(OtherPid) of
                                        true ->
                                            case catch lib_player:apply_call(OtherRid, ?APPLY_CALL_STATUS, lib_marriage, get_lover_info, [], 2000) of
                                                LoverInfo when is_list(LoverInfo) ->
                                                    [LoverSex, LoverLv] = LoverInfo;
                                                _ ->
                                                    case lob_role:get_role_show(OtherRid) of
                                                        #ets_role_show{figure = LoverFigure} ->
                                                            #figure{sex = LoverSex, lv = LoverLv} = LoverFigure;
                                                        _ -> LoverSex = 0, LoverLv = 0
                                                    end
                                            end;
                                        false ->
                                            case lob_role:get_role_show(OtherRid) of
                                                #ets_role_show{figure = LoverFigure} ->
                                                    #figure{sex = LoverSex, lv = LoverLv} = LoverFigure;
                                                _ -> LoverSex = 0, LoverLv = 0
                                            end
                                    end,
                                    case LoverLv >= ?MarriageOpenLv of
                                        true ->
                                            case mod_marriage:check_marriage([RoleId, Sex, OtherRid, LoverSex, MarriageType]) of
                                                {false, Code} ->
                                                    ?PRINT("check_marriage ~p~n", [Code]),
                                                    NewPs = Ps,
                                                    {ok, Bin} = pt_172:write(17231, [Code, OtherRid]),
                                                    lib_server_send:send_to_uid(RoleId, Bin);
                                                true ->
                                                    #base_propose_cfg{
                                                        cost = CostList1
                                                    } = ProposeInfo,
                                                    [{GoldType, GoldTypeId, GoldNum}|_] = CostList1,
                                                    %Discount = lib_flower_act_api:get_wedding_discount(),
                                                    %NewGoldNum1 = round(GoldNum*Discount/100),
                                                    % case IfAA of
                                                    %     0 ->
                                                    %         CostList = [{GoldType, GoldTypeId, NewGoldNum1}],
                                                    %         OtherCostList = [];
                                                    %     _ ->
                                                    %         NewGoldNum = round(NewGoldNum1/2),
                                                    %         CostList = [{GoldType, GoldTypeId, NewGoldNum}],
                                                    %         OtherCostList = [{GoldType, GoldTypeId, NewGoldNum}]
                                                    % end,
                                                    CostList = [{GoldType, GoldTypeId, GoldNum}],
                                                    OtherCostList = [],
                                                    case lib_goods_api:check_object_list(Ps, CostList) of
                                                        true ->
                                                            NewPs = Ps,
                                                            Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
                                                            ProposeArgs = [MarriageType, "", OtherCostList, []],
                                                            lib_marriage:handle_msg_with_other(OtherRid, lib_marriage, marriage_behavior, [Args, Msg, 0, WeddingType, 5, ProposeArgs]);
                                                            %lib_player:apply_cast(OtherRid, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_marriage, marriage_behavior, [Args, Msg, 0, WeddingType, 5, ProposeArgs]);
                                                        {false, Code} ->
                                                            NewPs = Ps,
                                                            {ok, Bin} = pt_172:write(17231, [Code, OtherRid]),
                                                            lib_server_send:send_to_uid(RoleId, Bin)
                                                    end
                                            end;
                                        _ ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_172:write(17231, [?ERRCODE(err172_marriage_partner_lv_limit), OtherRid]),
                                            lib_server_send:send_to_uid(RoleId, Bin)
                                    end;
                                _ ->
                                    NewPs = Ps,
                                    {ok, Bin} = pt_172:write(17231, [Code1, OtherRid]),
                                    lib_server_send:send_to_uid(RoleId, Bin)
                            end
                    end
            end
    end,
    {ok, NewPs};


%% 打开我的伴侣
handle(17232, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case Lv >= ?MarriageOpenLv of
        false ->
            {ok, Bin} = pt_172:write(17232, [?LEVEL_LIMIT, 0, 0, #figure{}, 0, 0, 0, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            HadMarriaged = mod_counter:get_count(RoleId, ?MOD_MARRIAGE, 1),
            #marriage_status{
                lover_role_id = LoverRoleId
            } = MarriageStatus,
            case LoverRoleId of
                0 ->
                    {ok, Bin} = pt_172:write(17232, [?ERRCODE(err172_couple_single), 0, 0, #figure{}, 0, 0, 0, 0, HadMarriaged]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    mod_marriage:open_my_lover([RoleId, HadMarriaged])
            end
    end;

%% 打开分手/离婚
% handle(17233, Ps, []) ->
%     #player_status{
%         id = RoleId,
%         marriage = MarriageStatus
%     } = Ps,
%     #marriage_status{
%         lover_role_id = LoverRoleId,
%         type = MarriageType,
%         now_wedding_state = NowWeddingState,
%         wedding_pid = WeddingPid
%     } = MarriageStatus,
%     if
%         LoverRoleId =:= 0 ->
%             {ok, Bin} = pt_172:write(17233, [?ERRCODE(err172_couple_single), 0, 0, 0]),
%             lib_server_send:send_to_uid(RoleId, Bin);
%         NowWeddingState =:= 2 orelse NowWeddingState =:= 3 ->
%             {ok, Bin} = pt_172:write(17233, [?ERRCODE(err172_wedding_have_order), 0, 0, 0]),
%             lib_server_send:send_to_uid(RoleId, Bin);
%         WeddingPid =/= 0 ->
%             {ok, Bin} = pt_172:write(17233, [?ERRCODE(err172_wedding_start), 0, 0, 0]),
%             lib_server_send:send_to_uid(RoleId, Bin);
%         true ->
%             case MarriageType of
%                 1 ->
%                     [{CostType, _, CostNum}|_] = ?CoupleBreakCost;
%                 _ ->
%                     [{CostType, _, CostNum}|_] = ?CoupleDivorceCost
%             end,
%             {ok, Bin} = pt_172:write(17233, [?SUCCESS, MarriageType, CostType, CostNum]),
%             lib_server_send:send_to_uid(RoleId, Bin)
%     end;

%% 发送分手/离婚
handle(17234, Ps, [DivorceType]) ->
    #player_status{
        id = RoleId,
        combat_power = CombatPower,
        marriage = MarriageStatus,
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
    #marriage_status{
        lover_role_id = LoverRoleId,
        type = MarriageTypeRole,
        now_wedding_state = NowWeddingState,
        wedding_pid = WeddingPid
    } = MarriageStatus,
    if
        LoverRoleId =:= 0 ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17234, [?ERRCODE(err172_couple_single)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        NowWeddingState =:= 2 orelse NowWeddingState =:= 3 ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17234, [?ERRCODE(err172_wedding_have_order)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingPid =/= 0 ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17234, [?ERRCODE(err172_wedding_start)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case MarriageTypeRole == 2 andalso DivorceType == 1 andalso lib_player:is_online_global(LoverRoleId) == false of
                true -> %% 协商离婚，对方不在线
                    NewPs = Ps,
                    {ok, Bin} = pt_172:write(17234, [?ERRCODE(err172_divorce_lover_not_online)]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    case mod_marriage:check_divorce([RoleId, DivorceType]) of
                        {false, Code} ->
                            ?PRINT("check_divorce ~p~n", [Code]),
                            NewPs = Ps,
                            {ok, Bin} = pt_172:write(17234, [Code]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        {true, MarriageType} ->
                            IsFree = case misc:is_process_alive(misc:get_player_process(LoverRoleId)) of
                                            true ->
                                                false;
                                            _ ->
                                                OffLineTime = lib_role:get_role_offline_time(LoverRoleId),
                                                OffLineTime >= ?FREE_OFFLINE_TIMES
                                     end,
                            CostList = lib_marriage:get_divorce_cost(MarriageType, DivorceType, IsFree),
                            case lib_goods_api:cost_object_list_with_check(Ps, CostList, divorce, "") of
                                {true, NewPs} ->
                                    Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
                                    mod_marriage:do_divorse([RoleId, MarriageType, DivorceType, Args, IsFree]);
                                {false, Code, NewPs} ->
                                    {ok, Bin} = pt_172:write(17234, [Code]),
                                    lib_server_send:send_to_uid(RoleId, Bin)
                            end
                    end
            end
    end,
    {ok, NewPs};

%% 回应分手/离婚
handle(17235, Ps, [AnswerType]) ->
    #player_status{
        id = RoleId,
        combat_power = CombatPower,
        marriage = MarriageStatus,
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
    #marriage_status{
        lover_role_id = LoverRoleId,
        type = MarriageTypeRole
    } = MarriageStatus,
    if
        LoverRoleId =:= 0 orelse MarriageTypeRole =/= 2 ->
            {ok, Bin} = pt_172:write(17235, [?ERRCODE(err172_couple_single), AnswerType]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
            mod_marriage:do_divorse_answer([RoleId, AnswerType, Args])
    end,
    {ok, Ps};

%% 领取恩爱称号(服务端自己激活)
handle(17236, Ps, [Id]) ->
    #player_status{
        id = RoleId,
        combat_power = CombatPower,
        marriage = MarriageStatus,
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
    #marriage_status{
        lover_role_id = LoverRoleId,
        type = MarriageTypeRole
    } = MarriageStatus,
    LoveDsgtCfg = data_marriage:get_love_dsgt(Id),
    if
        LoverRoleId =:= 0 orelse MarriageTypeRole =/= 2 ->
            ok;
            % {ok, Bin} = pt_172:write(17236, [?ERRCODE(err172_couple_single), Id]),
            % lib_server_send:send_to_uid(RoleId, Bin);
        LoveDsgtCfg == [] ->
            ok;
            % {ok, Bin} = pt_172:write(17236, [?MISSING_CONFIG, Id]),
            % lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            #base_love_dsgt_cfg{dsgt = DsgtId} = LoveDsgtCfg,
            case lib_designation_api:is_dsgt_active(Ps, DsgtId) of
                true ->
                    ok;
                    % {ok, Bin} = pt_172:write(17236, [?ERRCODE(err172_love_dsgt_active), Id]),
                    % lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    Args = [RoleId, Name, CombatPower, Lv, Sex, Vip, Career, Turn],
                    mod_marriage:get_love_dsgt([RoleId, LoveDsgtCfg, Args])
            end
    end,
    {ok, Ps};

%% 购买真爱礼包
handle(17237, Ps, []) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        lover_role_id = LoverRoleId,
        type = MarriageTypeRole,
        love_gift_time_s = GiftTImeS
    } = MarriageStatus,
    Now = utime:unixtime(),
    if
        GiftTImeS >= Now ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17237, [?ERRCODE(err172_gift_no_expire)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        LoverRoleId =:= 0 orelse MarriageTypeRole =/= 2 ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17237, [?ERRCODE(err172_couple_single)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            CostList = ?LoveGiftBuyCost,
            case lib_goods_api:cost_object_list_with_check(Ps, CostList, love_gift, "") of
                {true, NewPs} ->
                    mod_marriage:buy_love_gift([RoleId]);
                {false, Code, NewPs} ->
                    {ok, Bin} = pt_172:write(17237, [Code]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end,
    {ok, NewPs};

%% 真爱礼包信息
handle(17238, Ps, []) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        lover_role_id = LoverRoleId,
        type = MarriageTypeRole
    } = MarriageStatus,
    if
        LoverRoleId =:= 0 orelse MarriageTypeRole =/= 2 ->
            skip;
        true ->
            mod_marriage:send_love_gift_info([RoleId])
    end,
    {ok, Ps};

%% 领取真爱礼包
handle(17239, Ps, [CountType]) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        lover_role_id = LoverRoleId,
        type = MarriageTypeRole
    } = MarriageStatus,
    if
        LoverRoleId =:= 0 orelse MarriageTypeRole =/= 2 ->
            {ok, Bin} = pt_172:write(17239, [?ERRCODE(err172_couple_single), CountType, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_marriage:get_love_gift_reward([RoleId, CountType])
    end,
    {ok, Ps};

%% 请求对方购买礼包
handle(17240, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus,
        combat_power = CombatPower
    } = Ps,
    #figure{
        name = Name, lv = Lv, career = Career, sex = Sex, vip = Vip, turn = Turn, picture = Picture, picture_ver = PictureVer
    } = Figure,
    #marriage_status{
        lover_role_id = LoverRoleId,
        type = MarriageTypeRole
    } = MarriageStatus,
    if
        LoverRoleId =:= 0 orelse MarriageTypeRole =/= 2 ->
            {ok, Bin} = pt_172:write(17240, [?ERRCODE(err172_couple_single)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case lib_player:is_online_global(LoverRoleId) of
                false ->
                    {ok, Bin} = pt_172:write(17240, [?ERRCODE(err240_other_offline)]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    {ok, Bin2} = pt_172:write(17222, [RoleId, Name, Lv, CombatPower, Sex, Vip, Career, Turn, Picture, PictureVer, 5, 0, "", 0, []]),
                    lib_server_send:send_to_uid(LoverRoleId, Bin2)
            end
    end,
    {ok, Ps};

%% 打开一生一世
% handle(17240, Ps, []) ->
%     #player_status{
%         id = RoleId,
%         marriage = MarriageStatus,
%         figure = Figure
%     } = Ps,
%     #figure{
%         lv = Lv
%     } = Figure,
%     LoveNum = lib_goods_api:get_currency(Ps, ?GOODS_ID_LOVE_NUM),
%     case Lv >= ?MarriageOpenLv of
%         true ->
%             Code = ?SUCCESS,
%             #marriage_status{
%                 marriage_life = MarriageLife
%             } = MarriageStatus,
%             #marriage_life{
%                 stage = Stage,
%                 heart = Heart
%             } = MarriageLife,
%             AttrList = lib_marriage:get_marriage_life_attr(Ps),
%             Attr = lib_player_attr:add_attr(record, [AttrList]),
%             CombatPower = lib_player:calc_all_power(Attr);
%         false ->
%             Code = ?LEVEL_LIMIT,
%             Stage = 0,
%             Heart = 0,
%             CombatPower = 0
%     end,
%     {ok, Bin} = pt_172:write(17240, [Code, Stage, Heart, LoveNum, CombatPower]),
%     lib_server_send:send_to_uid(RoleId, Bin);

%% 培养一生一世
handle(17241, Ps, []) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    LoveNum = lib_goods_api:get_currency(Ps, ?GOODS_ID_LOVE_NUM),
    case Lv >= ?MarriageOpenLv of
        false ->
            Code = ?LEVEL_LIMIT,   %% 等级不足
            NewStage = 0,
            NewHeart = 0,
            NewLoveNum = LoveNum,
            CombatPower = 0,
            NewPs = Ps;
        true ->
            #marriage_status{
                type = MarriageType,
                marriage_life = MarriageLife
            } = MarriageStatus,
            #marriage_life{
                stage = Stage,
                heart = Heart
            } = MarriageLife,
            case MarriageType of
                2 ->
                    case lib_marriage:check_marriage_life_max(Stage, Heart) of
                        false ->
                            Code = ?ERRCODE(err172_marriage_max),
                            NewStage = 0,
                            NewHeart = 0,
                            NewLoveNum = LoveNum,
                            CombatPower = 0,
                            NewPs = Ps;
                        {true, NewStage, NewHeart} ->
                            MarriageLifeHeartCon = data_marriage:get_marriage_life_heart_con(NewStage, NewHeart),
                            #marriage_life_heart_con{
                                upgrade_love_num = UpgradeLoveNum
                            } = MarriageLifeHeartCon,
                            CostList = [{?TYPE_CURRENCY, ?GOODS_ID_LOVE_NUM, UpgradeLoveNum}],
                            case lib_goods_api:cost_object_list_with_check(Ps, CostList, marriage_life_train, "") of
                                {false, Code, NewPs} ->
                                    NewLoveNum = LoveNum,
                                    CombatPower = 0;
                                {true, NewPs1} ->
                                    Code = ?SUCCESS,
                                    NewMarriageLife = MarriageLife#marriage_life{
                                        stage = NewStage,
                                        heart = NewHeart
                                    },
                                    lib_marriage:sql_marriage_life(NewMarriageLife),
                                    NewMarriageStatus = MarriageStatus#marriage_status{
                                        marriage_life = NewMarriageLife
                                    },
                                    NewPs2 = NewPs1#player_status{
                                        marriage = NewMarriageStatus
                                    },
                                    NewPs = lib_player:count_player_attribute(NewPs2),
                                    NewLoveNum = lib_goods_api:get_currency(NewPs, ?GOODS_ID_LOVE_NUM),
                                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                    lib_log_api:log_marriage_life_train(RoleId, Stage, Heart, LoveNum, NewStage, NewHeart, NewLoveNum),
                                    AttrList = lib_marriage:get_marriage_life_attr(NewPs),
                                    Attr = lib_player_attr:add_attr(record, [AttrList]),
                                    CombatPower = lib_player:calc_all_power(Attr)
                            end
                    end;
                _ ->
                    Code = ?ERRCODE(err172_marriage_life_not_marry),
                    NewStage = 0,
                    NewHeart = 0,
                    NewLoveNum = LoveNum,
                    CombatPower = 0,
                    NewPs = Ps
            end
    end,
    {ok, Bin} = pt_172:write(17241, [Code, NewStage, NewHeart, NewLoveNum, CombatPower]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 秀恩爱
handle(17242, Ps, [TypeId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    #marriage_status{
        type = MarriageType,
        lover_role_id = LoverRoleId
    } = MarriageStatus,
    case MarriageType =:= 0 orelse LoverRoleId =:= 0 of
        true ->
            Code = ?ERRCODE(err172_couple_single),
            NewPs = Ps;
        false ->
            case data_marriage:get_marriage_show_love_con(TypeId) of
                [] ->
                    Code =?MISSING_CONFIG,
                    NewPs = Ps;
                MarriageShowLoveCon ->
                    #marriage_show_love_con{
                        name = ShowLoveName,
                        cost_list = CostList,
                        add_intimacy = AddIntimacy,
                        self_goods_list = SelfGoodsList,
                        lover_goods_list = LoverGoodsList
                    } = MarriageShowLoveCon,
                    case lib_goods_api:can_give_goods(Ps, SelfGoodsList) of
                        {false, ErrorCode} ->
                            Code = ErrorCode,
                            NewPs = Ps;
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Ps, CostList, show_love, "") of
                                {true, NewPs1} ->
                                    Code = ?SUCCESS,
                                    lib_relationship:update_intimacy_each_one(RoleId, LoverRoleId, AddIntimacy, ?INTIMACY_TYPE_SHOW_LVE, []),
                                    NewPs = lib_goods_api:send_reward(NewPs1, SelfGoodsList, show_love, 0),
                                    Title = ?LAN_MSG(?LAN_TITLE_SHOW_LOVE),
                                    Content = utext:get(?LAN_CONTENT_SHOW_LOVE, [Name, ShowLoveName]),
                                    lib_mail_api:send_sys_mail([LoverRoleId], Title, Content, LoverGoodsList),
                                    mod_marriage:throw_dog_food(RoleId, TypeId);
                                {false, Code, NewPs} ->
                                    skip
                            end
                    end
            end
    end,
    {ok, Bin} = pt_172:write(17242, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 领取狗粮
handle(17243, Ps, [RoleIdM, RoleIdW, DogFoodId]) ->
    #player_status{
        id = RoleId
    } = Ps,
    case lists:member(RoleId, [RoleIdM, RoleIdW]) of
        true ->
            {ok, Bin} = pt_172:write(17243, [?ERRCODE(err172_df_cant_get), RoleIdM, RoleIdW, DogFoodId, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        false ->
            mod_marriage:get_dog_food(RoleId, RoleIdM, RoleIdW, DogFoodId)
    end;

%% 进入/退出匹配
% handle(17245, Ps, [Type, DunId]) ->
%     #player_status{
%         id = RoleId, figure = #figure{lv = Lv}
%     } = Ps,
%     case Lv >= ?MarriageOpenLv of
%         true ->
%             lib_marriage:marriage_dun_match(Ps, Type, DunId);
%         false ->
%             lib_server_send:send_to_uid(RoleId, pt_172, 17245, [?LEVEL_LIMIT, Type, 0])
%     end;

%% 打开婚礼预约界面
handle(17249, Ps, []) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        now_wedding_state = NowWeddingState
    } = MarriageStatus,
    case NowWeddingState =/= 2 of
        true ->
            {ok, Bin} = pt_172:write(17249, [NowWeddingState, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        _ ->
            mod_marriage_wedding_mgr:send_wedding_state_info(RoleId)
    end;


%% 打开婚礼预约界面
handle(17250, Ps, []) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        type = MarriageType,
        now_wedding_state = _NowWeddingState
    } = MarriageStatus,
    case MarriageType of
        1 ->
            {ok, Bin} = pt_172:write(17250, [?ERRCODE(err172_marriage_life_not_marry), 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        _ ->
            % case NowWeddingState of
            %     3 ->
            %         {ok, Bin} = pt_172:write(17250, [?ERRCODE(err172_wedding_have_order), 0, [], []]),
            %         lib_server_send:send_to_uid(RoleId, Bin);
            %     _ ->
            mod_marriage:open_wedding_order(RoleId)
            % end
    end;

%% 预约婚礼
handle(17251, Ps, [DayId, TimeId, WeddingType]) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        type = MarriageType,
        now_wedding_state = NowWeddingState,
        wedding_pid = WeddingPid
    } = MarriageStatus,
    %WeddingCardCon = data_wedding:get_wedding_card_con(GoodsTypeId),
    WeddingInfoCon = data_wedding:get_wedding_info_con(WeddingType),
    WeddingTimeCon = data_wedding:get_wedding_time_con(TimeId),
    OrderDayMax = ?WeddingOrderDay,
    if
        MarriageType =:= 1 ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_marriage_life_not_marry), 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingPid =/= 0 ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_wedding_start), 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        NowWeddingState =:= 3 ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_wedding_have_order), 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        DayId > OrderDayMax ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_wedding_over_day), 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingTimeCon =:= [] ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_wedding_not_time), 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        WeddingInfoCon =:= [] ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17251, [?MISSING_CONFIG, 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            #wedding_time_con{
                begin_time = {BeginHour, BeginMinute}
            } = WeddingTimeCon,
            TodayDateTime = utime:unixdate(),
            UseDateTime = TodayDateTime+(DayId-1)*24*60*60,
            case utime:unixtime() >= (UseDateTime+BeginHour*60*60+BeginMinute*60) of
                true ->
                    NewPs = Ps,
                    {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_wedding_order_time_pass), 0, 0, [], []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                false ->
                    case WeddingType == 3 andalso mod_daily:get_count(RoleId, ?MOD_MARRIAGE, 7, UseDateTime) > 0 of
                        true ->
                            NewPs = Ps,
                            {ok, Bin} = pt_172:write(17251, [?ERRCODE(err172_only_one_times_in_day), 0, 0, [], []]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        _ ->
                            case mod_marriage:check_wedding_order([RoleId, WeddingType]) of
                                {false, Code} ->
                                    {ok, Bin} = pt_172:write(17251, [Code, 0, 0, [], []]),
                                    lib_server_send:send_to_uid(RoleId, Bin),
                                    NewPs = Ps;
                                true ->
                                    case mod_marriage_wedding_mgr:check_wedding_order(RoleId, DayId, TimeId) of
                                        {false, Code} ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_172:write(17251, [Code, 0, 0, [], []]),
                                            lib_server_send:send_to_uid(RoleId, Bin);
                                        true ->
                                            case NowWeddingState of
                                                0 ->
                                                    Code1 = 1,
                                                    IfReward = 0,
                                                    NewPs = Ps;
                                                _ ->
                                                    Code1 = 1,
                                                    IfReward = 0,
                                                    NewPs = Ps
                                            end,
                                            case Code1 of
                                                1 ->
                                                    mod_marriage:wedding_order(RoleId, DayId, TimeId, WeddingType, NowWeddingState, IfReward);
                                                _ ->
                                                    {ok, Bin} = pt_172:write(17251, [Code1, 0, 0, [], []]),
                                                    lib_server_send:send_to_uid(RoleId, Bin)
                                            end
                                    end
                            end
                    end
            end
    end,
    {ok, NewPs};

%% 打开邀请宾客
handle(17252, Ps, []) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus,
        figure = Figure
    } = Ps,
    #marriage_status{
        now_wedding_state = NowWeddingState
    } = MarriageStatus,
    case NowWeddingState == 2 of
        true ->
            mod_marriage_wedding_mgr:open_invite_guest([RoleId, Figure, NowWeddingState]);
        _ ->
            {ok, Bin} = pt_172:write(17252, [?ERRCODE(err172_wedding_not_order), 0, "", "", 0, 0, "", "", 0, 0, 0, 0, 0, 0, [], []]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 邀请宾客
handle(17253, Ps, [InviteList]) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus,
        figure = #figure{name = RoleName}
    } = Ps,
    #marriage_status{
        lover_role_id = LoverRoleId,
        now_wedding_state = NowWeddingState
    } = MarriageStatus,
    InviteSelf = lists:member(RoleId, InviteList),
    InviteLover = lists:member(LoverRoleId, InviteList),
    if
        InviteSelf == true ->
            {ok, Bin} = pt_172:write(17253, [?ERRCODE(err172_wedding_not_invite_self), []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        InviteLover == true ->
            {ok, Bin} = pt_172:write(17253, [?ERRCODE(err172_wedding_not_invite_lover), []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case NowWeddingState == 2 of
                true ->
                    F = fun(InviteId, {List, Ok}) ->
                        #figure{name = InviteRoleName, lv = InviteRoleLv} = lib_role:get_role_figure(InviteId),
                        case InviteRoleLv >= 130 of
                            true -> {[{InviteId, InviteRoleName}|List], Ok};
                            _ -> {List, false}
                        end
                    end,
                    case lists:foldl(F, {[], true}, InviteList) of
                        {NewInviteList, true} ->
                            %?PRINT("17253 NewInviteList ~p~n", [NewInviteList]),
                            mod_marriage_wedding_mgr:do_invite_guest([RoleId, RoleName, NewInviteList]);
                        _ ->
                            {ok, Bin} = pt_172:write(17253, [?ERRCODE(err172_marriage_ask_lv_limit), []]),
                            lib_server_send:send_to_uid(RoleId, Bin)
                    end;
                _ ->
                    %?PRINT("17253 err =============== 11 ~n", []),
                    {ok, Bin} = pt_172:write(17253, [?ERRCODE(err172_wedding_not_order), []]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end;

%% 获取被邀请的列表
% handle(17254, Ps, []) ->
%     #player_status{
%         id = RoleId
%     } = Ps,
%     mod_marriage_wedding_mgr:invited_list([RoleId]);

%% 接受/拒绝邀请
% handle(17255, Ps, [RoleIdM, AnswerType]) ->
%     #player_status{
%         id = RoleId
%     } = Ps,
%     mod_marriage_wedding_mgr:invited_answer(RoleId, RoleIdM, AnswerType);

handle(17256, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = #figure{lv = Lv}
    } = Ps,
    case Lv >= 130 of
        true ->
            mod_marriage_wedding_mgr:check_wedding_start_login(RoleId);
        _ ->
            ok
    end;

%% 索要请柬
handle(17257, Ps, [RoleIdM]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv, name = Name
    } = Figure,
    AskInviteLv = 130,
    case Lv >= AskInviteLv of
        false ->
            {ok, Bin} = pt_172:write(17257, [?ERRCODE(err172_marriage_ask_lv_limit)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_marriage_wedding_mgr:ask_invite([RoleId, Name, RoleIdM])
    end;

handle(17258, Ps, [RoleIdM]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv, name = Name
    } = Figure,
    AskInviteLv = 130,
    case Lv >= AskInviteLv of
        false ->
            {ok, Bin} = pt_172:write(17258, [?ERRCODE(err172_marriage_ask_lv_limit), RoleIdM]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            CostList = ?WeddingGuestMaxNumPrice,
            case lib_goods_api:check_object_list(Ps, CostList) of
                {false, Code} ->
                    {ok, Bin} = pt_172:write(17258, [Code, RoleIdM]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    case catch mod_marriage_wedding_mgr:guest_buy_card([RoleId, Name, RoleIdM]) of
                        true ->
                            {ok, Bin} = pt_172:write(17258, [1, RoleIdM]),
                            lib_server_send:send_to_uid(RoleId, Bin),
                            {true, NewPs} = lib_goods_api:cost_object_list(Ps, CostList, wedding_buy_guest_max, ""),
                            {ok, NewPs};
                        {false, Code} ->
                            {ok, Bin} = pt_172:write(17258, [Code, RoleIdM]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        Err ->
                            ?ERR("guest_buy_card err : ~p~n", [Err]),
                            {ok, Bin} = pt_172:write(17258, [?FAIL, RoleIdM]),
                            lib_server_send:send_to_uid(RoleId, Bin)
                    end
            end
    end;

%% 购买上限
handle(17259, Ps, [BuyNum]) when BuyNum > 0 ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        now_wedding_state = NowWeddingState
    } = MarriageStatus,
    case NowWeddingState == 2 of
        false ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17259, [?ERRCODE(err172_wedding_not_order), 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        _ ->
            case mod_marriage_wedding_mgr:check_buy_max(RoleId, BuyNum) of
                {false, Code} ->
                    NewPs = Ps,
                    {ok, Bin} = pt_172:write(17259, [Code, 0, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    CostList = [{GT,GId,GNum*BuyNum} ||{GT,GId,GNum} <- ?WeddingGuestMaxNumPrice],
                    case lib_goods_api:cost_object_list_with_check(Ps, CostList, wedding_buy_guest_max, "") of
                        {true, NewPs} ->
                            mod_marriage_wedding_mgr:do_buy_max([RoleId, BuyNum, CostList]);
                        {false, Code, NewPs} ->
                            {ok, Bin} = pt_172:write(17259, [Code, 0, 0]),
                            lib_server_send:send_to_uid(RoleId, Bin)
                    end
            end
    end,
    {ok, NewPs};

handle(17260, Ps, [TypeList]) ->
    #player_status{
        id = RoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        wedding_pid = _WeddingPid,
        now_wedding_state = NowWeddingState
    } = MarriageStatus,
    case NowWeddingState == 2 of
        false ->
            {ok, Bin} = pt_172:write(17260, [?ERRCODE(err172_wedding_not_order), 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_marriage_wedding_mgr:open_ask_invite([RoleId, TypeList])
    end;

handle(17261, Ps, [AnswerAskList]) ->
    #player_status{
        id = RoleId,
        figure = #figure{name = RoleName},
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        wedding_pid = WeddingPid
    } = MarriageStatus,
    case misc:is_process_alive(WeddingPid) of
        false ->
            {ok, Bin} = pt_172:write(17261, [?ERRCODE(err172_wedding_not_start)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_marriage_wedding_mgr:answer_ask_invite(RoleId, RoleName, AnswerAskList)
    end;

%% 婚礼动画场景信息
handle(17262, Ps, []) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = RoleIdM
    } = Ps,
    case SceneId =:= ?WeddingScene of
        true ->
            WeddingPid = mod_marriage_wedding_mgr:get_wedding_pid(RoleIdM),
            case misc:is_process_alive(WeddingPid) of
                false ->
                    {ok, Bin} = pt_172:write(17262, [?ERRCODE(err172_wedding_not_start), [], [], []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    gen_server:cast(WeddingPid, {get_anime_info, RoleId})
            end;
        false ->
            {ok, Bin} = pt_172:write(17262, [?ERRCODE(err172_wedding_not_scene), [], [], []]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 进入婚礼场景
handle(17263, Ps, [RoleIdM]) ->
    #player_status{
        id = RoleId, sid = Sid
    } = Ps,
    case lib_player_check:check_all(Ps) of
        {false, Code} ->
            {ok, Bin} = pt_172:write(17263, [Code]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_marriage_wedding_mgr:enter_wedding([RoleId, Sid, RoleIdM])
    end;

%% 离开婚礼场景
handle(17264, Ps, []) ->
    #player_status{
        id = RoleId,
        scene = SceneId
    } = Ps,
    case SceneId =:= ?WeddingScene of
        true ->
            Code = ?SUCCESS,
            NewPs = lib_marriage_wedding:quit_wedding(Ps);
        false ->
            Code = ?ERRCODE(err172_wedding_not_scene),
            NewPs = Ps
    end,
    {ok, Bin} = pt_172:write(17264, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 婚礼信息
handle(17265, Ps, []) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = RoleIdM
    } = Ps,
    case SceneId =:= ?WeddingScene of
        true ->
            mod_marriage_wedding_mgr:get_wedding_info(RoleId, RoleIdM);
        false ->
            {ok, Bin} = pt_172:write(17265, [?ERRCODE(err172_wedding_not_scene), 0, 0, 0, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 撒喜糖
handle(17266, Ps, [CandiesType]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        scene = SceneId,
        copy_id = RoleIdM,
        marriage = MarriageStatus
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    #marriage_status{
        lover_role_id = LoverRoleId,
        wedding_pid = WeddingPid
    } = MarriageStatus,
    case SceneId =:= ?WeddingScene of
        true ->
            case misc:is_process_alive(WeddingPid) of
                false ->
                    NewPs = Ps,
                    {ok, Bin} = pt_172:write(17266, [?ERRCODE(err172_wedding_not_owner)]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    case CandiesType of
                        1 ->
                            CandiesId = ?WeddingNormalCandies;
                        _ ->
                            CandiesId = ?WeddingSpecialCandies
                    end,
                    CandiesCon = data_wedding:get_wedding_candies_con(CandiesId),
                    case CandiesCon of
                        [] ->
                            NewPs = Ps,
                            {ok, Bin} = pt_172:write(17266, [?MISSING_CONFIG]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        _ ->
                            #wedding_candies_con{
                                candies_name = CandiesName,
                                aura = AddAura
                            } = CandiesCon,
                            case lists:member(RoleIdM, [RoleId, LoverRoleId]) of
                                false ->
                                    NewPs = Ps,
                                    {ok, Bin} = pt_172:write(17266, [?ERRCODE(err172_wedding_not_owner)]),
                                    lib_server_send:send_to_uid(RoleId, Bin);
                                true ->
                                    case catch gen_server:call(WeddingPid, {check_wedding_candies, RoleId, CandiesType}) of
                                        {false, Code} ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_172:write(17266, [Code]),
                                            lib_server_send:send_to_uid(RoleId, Bin);
                                        free ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_172:write(17266, [?SUCCESS]),
                                            lib_server_send:send_to_scene(SceneId, 0, RoleIdM, Bin),
                                            %% 喜糖传闻
                                            % case RoleId of
                                            %     RoleIdM ->
                                            %         TitleStr = ?ManString;
                                            %     _ ->
                                            %         TitleStr = ?WomanString
                                            % end,
                                            % BTitleStr = util:make_sure_binary(TitleStr),
                                            lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 8, [Name, util:make_sure_binary(CandiesName), AddAura]);
                                        {cost, CostList} ->
                                            case lib_goods_api:cost_object_list_with_check(Ps, CostList, wedding_candies, "") of
                                                {true, NewPs} ->
                                                    gen_server:cast(WeddingPid, {wedding_candies, RoleId, Name, CandiesType});
                                                {false, Code, NewPs} ->
                                                    {ok, Bin} = pt_172:write(17266, [Code]),
                                                    lib_server_send:send_to_uid(RoleId, Bin)
                                            end;
                                        _ ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_172:write(17266, [?ERRCODE(err172_wedding_not_start)]),
                                            lib_server_send:send_to_uid(RoleId, Bin)
                                    end
                            end
                    end
            end;
        false ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17266, [?ERRCODE(err172_wedding_not_scene)]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    {ok, NewPs};

%% 放烟花
handle(17267, Ps, [FiresType]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        scene = SceneId,
        copy_id = RoleIdM
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    case SceneId =:= ?WeddingScene of
        true ->
            WeddingPid = mod_marriage_wedding_mgr:get_wedding_pid(RoleIdM),
            case misc:is_process_alive(WeddingPid) of
                false ->
                    NewPs = Ps,
                    {ok, Bin} = pt_172:write(17267, [?ERRCODE(err172_wedding_not_start), "", 0, RoleId]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    FiresCon = data_wedding:get_wedding_fires_con(FiresType),
                    case FiresCon of
                        [] ->
                            NewPs = Ps,
                            {ok, Bin} = pt_172:write(17267, [?MISSING_CONFIG, "", 0, RoleId]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        _ ->
                            #wedding_fires_con{
                                fires_name = FiresName,
                                aura = AddAura,
                                reward_list = RewardList
                            } = FiresCon,
                            case lib_goods_api:can_give_goods(Ps, RewardList) of
                                {false, ErrorCode} ->
                                    NewPs = Ps,
                                    {ok, Bin} = pt_172:write(17267, [ErrorCode, "", 0, RoleId]),
                                    lib_server_send:send_to_uid(RoleId, Bin);
                                true ->
                                    case catch gen_server:call(WeddingPid, {check_wedding_fires, RoleId, FiresType}) of
                                        {false, Code} ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_172:write(17267, [Code, "", 0, RoleId]),
                                            lib_server_send:send_to_uid(RoleId, Bin);
                                        free ->
                                            NewPs = lib_goods_api:send_reward(Ps, RewardList, wedding_fires, 0, 3),
                                            [{_GoodsType, GoodsTypeId, _GoodsNum}|_] = RewardList,
                                            _GoodsName = data_goods:get_goods_name(GoodsTypeId),
                                            {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err172_wedding_fires_success), [util:make_sure_binary(FiresName)]}),
                                            {ok, Bin} = pt_172:write(17267, [CodeInt, CodeArgs, FiresType, RoleId]),
                                            lib_server_send:send_to_uid(RoleId, Bin),
                                            %lib_server_send:send_to_scene(SceneId, 0, RoleIdM, Bin),
                                            %% 烟花传闻
                                            %DanMuMsg = utext:get(1720015, [Name, util:make_sure_binary(FiresName), AddAura]),
                                            %lib_marriage_wedding:wedding_danmu(Ps, binary_to_list(util:make_sure_binary(DanMuMsg)), 0),
                                            lib_chat:send_TV({scene, ?WeddingScene, 0, RoleIdM}, ?MOD_MARRIAGE, 9, [Name, util:make_sure_binary(FiresName), AddAura]);
                                        {cost, CostList} ->
                                            case lib_goods_api:cost_object_list_with_check(Ps, CostList, wedding_fires, "") of
                                                {true, NewPs1} ->
                                                    NewPs = lib_goods_api:send_reward(NewPs1, RewardList, wedding_fires, 0, 3),
                                                    gen_server:cast(WeddingPid, {wedding_fires, RoleId, Name, FiresType});
                                                {false, Code, NewPs} ->
                                                    {ok, Bin} = pt_172:write(17267, [Code, "", 0, RoleId]),
                                                    lib_server_send:send_to_uid(RoleId, Bin)
                                            end;
                                        _ ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_172:write(17267, [?ERRCODE(err172_wedding_not_start), "", 0, RoleId]),
                                            lib_server_send:send_to_uid(RoleId, Bin)
                                    end
                            end
                    end
            end;
        false ->
            NewPs = Ps,
            {ok, Bin} = pt_172:write(17267, [?ERRCODE(err172_wedding_not_scene), "", 0, RoleId]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    {ok, NewPs};

%% 解决捣蛋鬼
% handle(17269, Ps, [SolveId, MonOnlyId, MonId]) ->
%     #player_status{
%         id = RoleId,
%         scene = SceneId,
%         copy_id = RoleIdM
%     } = Ps,
%     case SceneId =:= ?WeddingScene of
%         true ->
%             TroubleMakerCon = data_wedding:get_wedding_trouble_maker_con(MonId),
%             #wedding_trouble_maker_con{
%                 reward_list = RewardList
%             } = TroubleMakerCon,
%             case lib_goods_api:can_give_goods(Ps, RewardList) of
%                 {false, ErrorCode} ->
%                     {ok, Bin} = pt_172:write(17269, [ErrorCode, ""]),
%                     lib_server_send:send_to_uid(RoleId, Bin);
%                 true ->
%                     mod_marriage_wedding_mgr:kill_trouble_maker_solve(RoleId, RoleIdM, SolveId, MonOnlyId)
%             end;
%         false ->
%             {ok, Bin} = pt_172:write(17269, [?ERRCODE(err172_wedding_not_scene), ""]),
%             lib_server_send:send_to_uid(RoleId, Bin)
%     end;

%% 发弹幕
handle(17270, Ps, [Msg, TkTime]) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = RoleIdM
    } = Ps,
    WeddingPid = mod_marriage_wedding_mgr:get_wedding_pid(RoleIdM),
    case SceneId =:= ?WeddingScene andalso misc:is_process_alive(WeddingPid) of
        true ->
            gen_server:cast(WeddingPid, {wedding_danmu, RoleId, Msg, TkTime});
        false ->
            {ok, Bin} = pt_172:write(17270, [?ERRCODE(err172_wedding_not_scene)]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    {ok, Ps};

%% 婚礼玩家个人信息
handle(17272, Ps, []) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = RoleIdM
    } = Ps,
    case SceneId =:= ?WeddingScene of
        true ->
            mod_marriage_wedding_mgr:get_wedding_guest_info(RoleId, RoleIdM);
        false ->
            {ok, Bin} = pt_172:write(17272, [?ERRCODE(err172_wedding_not_scene), 0, 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 通知捣蛋鬼出现/消失
% handle(17274, Ps, []) ->
%     #player_status{
%         id = RoleId,
%         scene = SceneId,
%         copy_id = RoleIdM
%     } = Ps,
%     case SceneId =:= ?WeddingScene of
%         true ->
%             mod_marriage_wedding_mgr:get_wedding_tm_info(RoleId, RoleIdM);
%         false ->
%             {ok, Bin} = pt_172:write(17274, [0]),
%             lib_server_send:send_to_uid(RoleId, Bin)
%     end;

%% 婚礼获得总经验
handle(17275, Ps, []) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = RoleIdM
    } = Ps,
    case SceneId =:= ?WeddingScene of
        true ->
            mod_marriage_wedding_mgr:get_wedding_exp_info(RoleId, RoleIdM);
        false ->
            skip
    end;

%% 邀请对方购买副本次数
handle(17295, Ps, [DunId]) ->
    #player_status{
        id = RoleId,
        figure = #figure{name = RoleName},
        marriage = Marriage
    } = Ps,
    #marriage_status{
        lover_role_id = LoverId
    } = Marriage,
    case LoverId > 0 of
        true ->
            case lib_player:get_alive_pid(LoverId) of
                false ->
                    lib_server_send:send_to_uid(RoleId, pt_172, 17295, [?ERRCODE(err240_other_offline)]);
                Pid ->
                    case lib_player:apply_call(Pid, ?APPLY_CALL_STATUS, lib_dungeon, check_buy_count, [DunId, 1]) of
                        {false, Res} ->
                            lib_server_send:send_to_uid(RoleId, pt_172, 17295, [Res]);
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_172, 17295, [?SUCCESS]),
                            lib_server_send:send_to_uid(LoverId, pt_172, 17296, [RoleId, RoleName, DunId])
                    end
            end;
        false ->
            lib_server_send:send_to_uid(RoleId, pt_172, 17295, [?ERRCODE(err172_marriage_life_not_marry)])
    end;

%% 同意/拒绝购买副本次数
handle(17297, Ps, [Agree, DunId]) ->
    #player_status{
        id = RoleId,
        figure = #figure{name = RoleName},
        marriage = Marriage
    } = Ps,
    #marriage_status{
        lover_role_id = LoverId
    } = Marriage,
    case LoverId > 0 of
        true ->
            lib_server_send:send_to_uid(LoverId, pt_172, 17297, [Agree, DunId, RoleId, RoleName]);
        false ->
            ok
    end;

handle(17298, Ps, []) ->
    lib_marriage:one_invite_role(Ps);

handle(_Code, _Ps, _) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.