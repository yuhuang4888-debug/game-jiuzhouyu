%%%--------------------------------------
%%% @Module  : mod_house
%%% @Author  : huyihao
%%% @Created : 2018.05.17
%%% @Description:  家园
%%%--------------------------------------
-module(mod_house).

-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("custom_act.hrl").
-include("predefine.hrl").
-include("house.hrl").
-include("language.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_id_create.hrl").
-include("scene.hrl").
-include("relationship.hrl").

-behaviour (gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
    add_furniture/4,
    open_block_list/1,
    get_home_id_lv/1,
    open_house_list/2,
    into_house/3,
    init_furniture_success/3,
    open_upgrade/3,
    buy_house/1,
    buy_house_aa/1,
    check_buy_house/3,
    check_answer_house_aa/2,
    answer_buy_house_aa/3,
    take_answer_info/1,
    check_upgrade_house/3,
    upgrade_house/1,
    upgrade_house_aa/1,
    answer_upgrade_house_aa/3,
    put_furniture_inside/2,
    get_inside_list/3,
    marriage_house/5,
    divorce_house/2,
    login_check/1,
    open_choose_house/3,
    choose_house/5,
    change_text/4,
    get_house_furnitureList/5,
    house_reconnect/3,
    get_recommend_house_list/1,
    update_name/4,
    check_send_gift/2,
    send_gift/5,
    get_gift_log/3,
    gm_reflesh_inside_sql/0
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_furniture(RoleId, BlockId, HouseId, WearFurnitureList) ->
    gen_server:cast(?MODULE, {add_furniture, RoleId, BlockId, HouseId, WearFurnitureList}).

open_block_list(RoleId) ->
    gen_server:cast(?MODULE, {open_block_list, RoleId}).

open_house_list(RoleId, BlockId) ->
    gen_server:cast(?MODULE, {open_house_list, RoleId, BlockId}).

into_house(RoleId, BlockId, HouseId) ->
    gen_server:cast(?MODULE, {into_house, RoleId, BlockId, HouseId}).

init_furniture_success(RoleId, Args1, Type) ->
    gen_server:cast(?MODULE, {init_furniture_success, RoleId, Args1, Type}).

open_upgrade(RoleId, BlockId, HouseId) ->
    gen_server:cast(?MODULE, {open_upgrade, RoleId, BlockId, HouseId}).

buy_house(Args) ->
    gen_server:cast(?MODULE, {buy_house, Args}).

buy_house_aa(Args) ->
    gen_server:cast(?MODULE, {buy_house_aa, Args}).

answer_buy_house_aa(AnswerRoleId, AnswerCostKey, AnswerCostList) ->
    gen_server:cast(?MODULE, {answer_buy_house_aa, AnswerRoleId, AnswerCostKey, AnswerCostList}).

take_answer_info(RoleId) ->
    gen_server:cast(?MODULE, {take_answer_info, RoleId}).

upgrade_house(Args) ->
    gen_server:cast(?MODULE, {upgrade_house, Args}).

upgrade_house_aa(Args) ->
    gen_server:cast(?MODULE, {upgrade_house_aa, Args}).

answer_upgrade_house_aa(AnswerRoleId, AnswerCostKey, AnswerCostList) ->
    gen_server:cast(?MODULE, {answer_upgrade_house_aa, AnswerRoleId, AnswerCostKey, AnswerCostList}).

put_furniture_inside(RoleId, Args) ->
    gen_server:cast(?MODULE, {put_furniture_inside, RoleId, Args}).

get_inside_list(RoleId, BlockId, HouseId) ->
    gen_server:cast(?MODULE, {get_inside_list, RoleId, BlockId, HouseId}).

marriage_house(RoleIdM, NameM, RoleIdW, NameW, ProposeRoleId) ->
    gen_server:cast(?MODULE, {marriage_house, RoleIdM, NameM, RoleIdW, NameW, ProposeRoleId}).

divorce_house(RoleIdM, RoleIdW) ->
    gen_server:cast(?MODULE, {divorce_house, RoleIdM, RoleIdW}).

login_check(RoleId) ->
    gen_server:cast(?MODULE, {login_check, RoleId}).

open_choose_house(RoleId, BlockId, HouseId) ->
    gen_server:cast(?MODULE, {open_choose_house, RoleId, BlockId, HouseId}).

choose_house(RoleId, BlockId, HouseId, ChooseBlockId, ChooseHouseId) ->
    gen_server:cast(?MODULE, {choose_house, RoleId, BlockId, HouseId, ChooseBlockId, ChooseHouseId}).

change_text(RoleId, BlockId, HouseId, Text) ->
    gen_server:cast(?MODULE, {change_text, RoleId, BlockId, HouseId, Text}).

get_house_furnitureList(RoleId, BlockId, HouseId, ThemeId, FurnitureType) ->
    gen_server:cast(?MODULE, {get_house_furnitureList, RoleId, BlockId, HouseId, ThemeId, FurnitureType}).

house_reconnect(RoleId, Lv, CopyId) ->
    gen_server:cast(?MODULE, {house_reconnect, RoleId, Lv, CopyId}).

get_recommend_house_list(RoleId) ->
    gen_server:cast(?MODULE, {get_recommend_house_list, RoleId}).

update_name(RoleId, Name, BlockId, HouseId) ->
    gen_server:cast(?MODULE, {update_name, RoleId, Name, BlockId, HouseId}).

send_gift(BlockId, HouseId, GiftId, WishWord, Args) ->
    gen_server:cast(?MODULE, {send_gift, BlockId, HouseId, GiftId, WishWord, Args}).

get_gift_log(RoleId, BlockId, HouseId) ->
    gen_server:cast(?MODULE, {get_gift_log, RoleId, BlockId, HouseId}).

gm_reflesh_inside_sql() ->
    gen_server:cast(?MODULE, {gm_reflesh_inside_sql}).

get_home_id_lv(RoleId) ->
    gen_server:call(?MODULE, {get_home_id_lv, RoleId}).

check_buy_house(RoleId, BlockId, HouseId) ->
    gen_server:call(?MODULE, {check_buy_house, RoleId, BlockId, HouseId}).

check_answer_house_aa(AnswerRoleId, AnswerType) ->
    gen_server:call(?MODULE, {check_answer_house_aa, AnswerRoleId, AnswerType}).

check_upgrade_house(RoleId, BlockId, HouseId) ->
    gen_server:call(?MODULE, {check_upgrade_house, RoleId, BlockId, HouseId}).

check_send_gift(BlockId, HouseId) ->
    gen_server:call(?MODULE, {check_send_gift, BlockId, HouseId}).

init([]) ->
    lib_house:change_sql_add_server_id(),
    AllHouseInfoSqlList = db:get_all(?SelectHouseInfoAllSql),
    %% 合服返还
    Title1 = ?LAN_MSG(?LAN_TITLE_HOUSE_MERGE_RETURN),
    Content1 = ?LAN_MSG(?LAN_CONTENT_HOUSE_MERGE_RETURN),
    F1 = fun(HouseInfoSql, {HouseList11, MergeDeleteList1, MergeSqlList1}) ->
        [BlockId, HouseId, ServerId, RoleId1, RoleId2, Lv, Lock, MarriageStartLv, ChooseBlockId, ChooseHouseId, SCostLog, Text, BuyTime, Popularity] = HouseInfoSql,
        CostLogList = util:bitstring_to_term(SCostLog),
        case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList11) of
            false ->
                HouseInfo = #house_info{
                    home_id = {BlockId, HouseId},
                    server_id = ServerId,
                    role_id_1 = RoleId1,
                    role_id_2 = RoleId2,
                    lv = Lv,
                    lock = Lock,
                    marriage_start_lv = MarriageStartLv,
                    choose_house = {ChooseBlockId, ChooseHouseId},
                    cost_log = CostLogList,
                    text = Text,
                    buy_time = BuyTime,
                    popularity = Popularity
                },
                {[HouseInfo|HouseList11], MergeDeleteList1, MergeSqlList1};
            HouseInfo1 ->
                #house_info{
                    home_id = {BlockId1, HouseId1},
                    server_id = ServerId1,
                    role_id_1 = RoleId11,
                    role_id_2 = RoleId21,
                    marriage_start_lv = MarriageStartLv1,
                    cost_log = CostLogList1
                } = HouseInfo1,
                {RoleId1ReturnList1, RoleId2ReturnList1} = lib_house:get_return_list_merge(CostLogList1, RoleId11, MarriageStartLv1),
                lib_mail_api:send_sys_mail([RoleId11], Title1, Content1, RoleId1ReturnList1),
                lib_mail_api:send_sys_mail([RoleId21], Title1, Content1, RoleId2ReturnList1),
                {RoleId1ReturnList, RoleId2ReturnList} = lib_house:get_return_list_merge(CostLogList, RoleId1, MarriageStartLv),
                lib_mail_api:send_sys_mail([RoleId1], Title1, Content1, RoleId1ReturnList),
                lib_mail_api:send_sys_mail([RoleId2], Title1, Content1, RoleId2ReturnList),
                Str = "(block_id = ~p and house_id = ~p and server_id = ~p)",
                SqlStr = io_lib:format(Str, [BlockId, HouseId, ServerId]),
                SqlStr1 = io_lib:format(Str, [BlockId1, HouseId1, ServerId1]),
                MergeSqlList12 = MergeSqlList1 ++ [SqlStr, SqlStr1],
                HouseList111 = lists:delete(HouseInfo1, HouseList11),
                SRoleId1ReturnList = util:term_to_string(RoleId1ReturnList),
                SRoleId2ReturnList = util:term_to_string(RoleId2ReturnList),
                SRoleId1ReturnList1 = util:term_to_string(RoleId1ReturnList1),
                SRoleId2ReturnList1 = util:term_to_string(RoleId2ReturnList1),
                lib_log_api:log_house_merge(BlockId, HouseId, ServerId, ServerId1, RoleId1, RoleId2, RoleId11, RoleId21, SRoleId1ReturnList, SRoleId2ReturnList, SRoleId1ReturnList1, SRoleId2ReturnList1),
                {HouseList111, [{BlockId, HouseId}|MergeDeleteList1], MergeSqlList12}
        end
    end,
    {HouseList22, MergeDeleteList, MergeSqlList} = lists:foldl(F1, {[], [], []}, AllHouseInfoSqlList),
    case MergeSqlList of
        [] ->
            skip;
        _ ->
            SqlList = ulists:list_to_string(MergeSqlList, "or"),
            ReSql1 = io_lib:format(?DeleteHouseInfoAllSql, [SqlList]),
            db:execute(ReSql1)
    end,
    %% 将合服后所有夫妻只有一个房子的房子解锁并作为主房（合服后可能出现主房被返还的情况）
    F11 = fun(HouseInfoL, {HouseListL1, UpdateSqlList1}) ->
        #house_info{
            home_id = {BlockId, HouseId},
            server_id = ServerId,
            role_id_1 = RoleId1,
            role_id_2 = RoleId2,
            lv = HouseLv,
            lock = Lock,
            marriage_start_lv = MarriageStartLv,
            choose_house = {ChooseBlockId, ChooseHouseId},
            cost_log = CostLog,
            text = Text,
            buy_time = BuyTime,
            popularity = Popularity
        } = HouseInfoL,
        case RoleId2 of
            0 ->
                {[HouseInfoL|HouseListL1], UpdateSqlList1};
            _ ->
                case lists:keyfind(RoleId2, #house_info.role_id_1, HouseList22) of
                    false ->
                        case ChooseBlockId =:= 0 andalso ChooseHouseId =:= 0 andalso Lock =:= 0 of
                            true ->
                                {[HouseInfoL|HouseListL1], UpdateSqlList1};
                            false ->
                                NewHouseInfoL = HouseInfoL#house_info{
                                    choose_house = {0, 0},
                                    lock = 0
                                },
                                SCostLog = util:term_to_string(CostLog),
                                SText = util:make_sure_binary(Text),
                                SqlStr = io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s', ~p, ~p)",
                                    [BlockId, HouseId, ServerId, RoleId1, RoleId2, HouseLv, 0, MarriageStartLv, 0, 0, SCostLog, SText, BuyTime, Popularity]),
                                case Lock of
                                    0 ->
                                        skip;
                                    _ ->
                                        TitleL = ?LAN_MSG(?LAN_TITLE_HOUSE_MERGE_LOCK_TURN),
                                        ContentL = ?LAN_MSG(?LAN_CONTENT_HOUSE_MERGE_LOCK_TURN),
                                        lib_mail_api:send_sys_mail([RoleId1, RoleId2], TitleL, ContentL, [])
                                end,
                                {[NewHouseInfoL|HouseListL1], [SqlStr|UpdateSqlList1]}
                        end;
                    _ ->
                        {[HouseInfoL|HouseListL1], UpdateSqlList1}
                end
        end
    end,
    {HouseList2, UpdateSqlList} = lists:foldl(F11, {[], []}, HouseList22),
    case UpdateSqlList of
        [] ->
            skip;
        _ ->
            SqlListUpdate = ulists:list_to_string(UpdateSqlList, ","),
            ReSqlUpdate = io_lib:format(?ReplaceHouseInfoAllSql, [SqlListUpdate]),
            db:execute(ReSqlUpdate)
    end,
    AllHouseFurnitureLocSqlList = db:get_all(?SelectHouseFurnitureLocAllSql),
    F2 = fun(FurnitureLocSql, {HouseList3, LocDeleteSqllist1}) ->
        [LocId, BlockId, HouseId, GoodsId, GoodsTypeId, X, Y, Face, MapId] = FurnitureLocSql,
        case lists:member({BlockId, HouseId}, MergeDeleteList) of
            true ->
                {HouseList3, [LocId|LocDeleteSqllist1]};
            false ->
                case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList3) of
                    false ->
                        {HouseList3, [LocId|LocDeleteSqllist1]};
                    HouseInfo1 ->
                        InsideInfo = #furniture_inside_info{
                            loc_id = LocId,
                            goods_id = GoodsId,
                            goods_type_id = GoodsTypeId,
                            x = X,
                            y = Y,
                            face = Face,
                            map_id = MapId
                        },
                        #house_info{
                            inside_list = InsideList
                        } = HouseInfo1,
                        NewHouseInfo1 = HouseInfo1#house_info{
                            inside_list = [InsideInfo|InsideList]
                        },
                        HouseList31 = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, HouseList3, NewHouseInfo1),
                        {HouseList31, LocDeleteSqllist1}
                end
        end
    end,
    {HouseList1, LocDeleteSqllist} = lists:foldl(F2, {HouseList2, []}, AllHouseFurnitureLocSqlList),
    case LocDeleteSqllist of
        [] ->
            skip;
        _ ->
            ReSql2 = io_lib:format(?DeleteHouseFurnitureLocAllSql, [ulists:list_to_string(LocDeleteSqllist, ",")]),
            db:execute(ReSql2)
    end,
    AllHouseAAInfoSqlList = db:get_all(?SelectHouseHouseAAInfoAllSql),
    NowTime = utime:unixtime(),
    %% 合服AA返还
    Title2 = ?LAN_MSG(?LAN_TITLE_HOUSE_MERGE_AA_RETURN),
    Content2 = ?LAN_MSG(?LAN_CONTENT_HOUSE_MERGE_AA_RETURN),
    F3 = fun(AAInfoSql, {AAInfoList1, DeleteSqlStrList1, NewHouseList1}) ->
        [BlockId, HouseId, ServerId, HouseLv, AskRoleId, AnswerRoleId, AskTime, Type, CostKey, SAskCostList, SAnswerCostList] = AAInfoSql,
        AskCostList = util:bitstring_to_term(SAskCostList),
        case lists:member({BlockId, HouseId}, MergeDeleteList) of
            false ->
                case NowTime - AskTime >= ?AALimitTime of
                    false ->
                        AnswerCostList = util:bitstring_to_term(SAnswerCostList),
                        AAInfo = #aa_ask_info{
                            home_id = {BlockId, HouseId},
                            server_id = ServerId,
                            house_lv = HouseLv,
                            ask_role_id = AskRoleId,
                            answer_role_id = AnswerRoleId,
                            ask_time = AskTime,
                            type = Type,
                            cost_key = CostKey,
                            ask_cost_list = AskCostList,
                            answer_cost_list = AnswerCostList
                        },
                        {[AAInfo|AAInfoList1], DeleteSqlStrList1, NewHouseList1};
                    true ->
                        case Type of
                            1 ->
                                NewHouseList2 = NewHouseList1,
                                lib_house:house_fail_return(AskRoleId, CostKey, AskCostList, 4);
                            2 ->
                                NewHouseList2 = NewHouseList1,
                                lib_house:house_fail_return(AskRoleId, CostKey, AskCostList, 8);
                            _ ->
                                case lists:keyfind({BlockId, HouseId}, #house_info.home_id, NewHouseList1) of
                                    false ->
                                        NewHouseList2 = NewHouseList1;
                                    HouseInfo1 ->
                                        Title = ?LAN_MSG(?LAN_TITLE_HOUSE_CHOOSE_TIMEOUT),
                                        Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_CHOOSE_TIMEOUT),
                                        lib_mail_api:send_sys_mail([AnswerRoleId], Title, Content, []),
                                        NewHouseInfo1 = HouseInfo1#house_info{
                                            choose_house = {0, 0}
                                        },
                                        lib_house:sql_house_info(NewHouseInfo1),
                                        NewHouseList2 = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, NewHouseList1, NewHouseInfo1),
                                        #house_info{
                                            role_id_1 = RoleId1,
                                            role_id_2 = RoleId2,
                                            home_id = {BlockId1, HouseId1},
                                            lv = HouseLv1
                                        } = NewHouseInfo1,
                                        lib_hosue:update_house_info(RoleId1, BlockId1, HouseId1, HouseLv1, {0, 0}),
                                        lib_hosue:update_house_info(RoleId2, BlockId1, HouseId1, HouseLv1, {0, 0})
                                end
                        end,
                        SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
                        {AAInfoList1, [SqlStr|DeleteSqlStrList1], NewHouseList2}
                end;
            true ->
                case Type of
                    3 ->
                        skip;
                    _ ->
                        lib_consume_data:advance_payment_fail(AskRoleId, CostKey, [])
                end,
                lib_mail_api:send_sys_mail([AskRoleId], Title2, Content2, AskCostList)
        end
    end,
    {AAInfoList, DeleteSqlStrList, NewHouseList} = lists:foldl(F3, {[], [], HouseList1}, AllHouseAAInfoSqlList),
    case DeleteSqlStrList of
        [] ->
            skip;
        _ ->
            SqlList3 = ulists:list_to_string(DeleteSqlStrList, "or"),
            ReSql3 = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlList3]),
            db:execute(ReSql3)
    end,
    AACheckTimer = erlang:send_after(?CheckAATime*1000, self(), {aa_check_time_out}),
    State = #house_state{
        aa_list = AAInfoList,
        house_list = NewHouseList,
        check_aa_timer = AACheckTimer
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

do_handle_call({get_home_id_lv, RoleId}, _From, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lib_house:check_own_house(HouseList, RoleId, false) of
        false ->
            Return = false;
        #house_info{home_id = HomeId, lv = HouseLv, choose_house = ChooseHouse} ->
            Return = {HomeId, HouseLv, ChooseHouse}
    end,
    {reply, Return, State};

do_handle_call({check_buy_house, RoleId, BlockId, HouseId}, _From, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList
    } = State,
    Return = lib_house:check_buy_house(RoleId, BlockId, HouseId, HouseList, AAList),
    {reply, Return, State};

do_handle_call({check_answer_house_aa, AnswerRoleId, AnswerType}, _From, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList,
        answer_list = AnswerList
    } = State,
    case lists:keyfind(AnswerRoleId, #aa_ask_info.answer_role_id, AAList) of
        false ->
            Return = {false, ?ERRCODE(err177_house_not_ask), 0},
            NewState = State;
        AAInfo ->
            #aa_ask_info{
                home_id = {BlockId, HouseId},
                server_id = ServerId,
                house_lv = HouseLv,
                ask_role_id = AskRoleId,
                cost_key = AskCostKey,
                type = Type,
                ask_cost_list = AskCostList,
                answer_cost_list = AnswerCostList
            } = AAInfo,
            case Type of
                1 -> %% 买房
                    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
                        false ->
                            case AnswerType of
                                1 ->
                                    Return = {buy_house, AnswerCostList, Type},
                                    NewState = State;
                                _ ->
                                    Return = {false, ?SUCCESS, Type},
                                    lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 3),
                                    SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
                                    ReSql = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlStr]),
                                    db:execute(ReSql),
                                    NewAAList = lists:delete(AAInfo, AAList),
                                    NewAnswerInfo = #house_answer_info{
                                        ask_role_id = AskRoleId,
                                        answer_role_id = AnswerRoleId,
                                        type = Type,
                                        answer_type = AnswerType,
                                        home_id = {BlockId, HouseId},
                                        house_lv = HouseLv
                                    },
                                    NewAnswerList = lists:keyreplace(AskRoleId, #house_answer_info.ask_role_id, AnswerList, NewAnswerInfo),
                                    NewState = State#house_state{
                                        aa_list = NewAAList,
                                        answer_list = NewAnswerList
                                    },
                                    {ok, Bin} = pt_177:write(17711, [BlockId, HouseId, HouseLv, Type, AnswerType]),
                                    lib_server_send:send_to_uid(AskRoleId, Bin)
                            end;
                        _ ->
                            Return = {false, ?ERRCODE(err177_house_house_exist), Type},
                            lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 2),
                            SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
                            ReSql = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlStr]),
                            db:execute(ReSql),
                            NewAAList = lists:delete(AAInfo, AAList),
                            NewState = State#house_state{
                                aa_list = NewAAList
                            },
                            NewState = State
                    end;
                2 -> %% 升级
                    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
                        false ->
                            Return = {false, ?ERRCODE(err177_house_house_exist), Type},
                            lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 6),
                            SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
                            ReSql = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlStr]),
                            db:execute(ReSql),
                            NewAAList = lists:delete(AAInfo, AAList),
                            NewState = State#house_state{
                                aa_list = NewAAList
                            },
                            NewState = State;
                        _ ->
                            case AnswerType of
                                1 ->
                                    Return = {upgrade_house, AnswerCostList, Type},
                                    NewState = State;
                                _ ->
                                    Return = {false, ?SUCCESS, Type},
                                    lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 7),
                                    SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
                                    ReSql = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlStr]),
                                    db:execute(ReSql),
                                    NewAAList = lists:delete(AAInfo, AAList),
                                    NewAnswerInfo = #house_answer_info{
                                        ask_role_id = AskRoleId,
                                        answer_role_id = AnswerRoleId,
                                        type = Type,
                                        answer_type = AnswerType,
                                        home_id = {BlockId, HouseId},
                                        house_lv = HouseLv
                                    },
                                    NewAnswerList = lists:keystore(AskRoleId, #house_answer_info.ask_role_id, AnswerList, NewAnswerInfo),
                                    NewState = State#house_state{
                                        aa_list = NewAAList,
                                        answer_list = NewAnswerList
                                    },
                                    {ok, Bin} = pt_177:write(17711, [BlockId, HouseId, HouseLv, Type, AnswerType]),
                                    lib_server_send:send_to_uid(AskRoleId, Bin)
                            end
                    end;
                _ -> %% 选择房子
                    SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
                    ReSql = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlStr]),
                    db:execute(ReSql),
                    NewAAList = lists:delete(AAInfo, AAList),
                    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
                        false ->
                            Return = {false, ?ERRCODE(err177_house_house_exist), Type},
                            NewHouseList = HouseList,
                            NewAnswerList = AnswerList;
                        HouseInfo ->
                            #house_info{
                                choose_house = {OtherBlockId, OtherHouseId},
                                lock = OldLock
                            } = HouseInfo,
                            Return = {choose_house, ?SUCCESS, Type},
                            case AnswerType of
                                1 ->
                                    NewHouseInfo = HouseInfo#house_info{
                                        choose_house = {0, 0},
                                        lock = 0
                                    },
                                    lib_house:sql_house_info(NewHouseInfo),
                                    case lists:keyfind({OtherBlockId, OtherHouseId}, #house_info.home_id, HouseList) of
                                        false ->
                                            NewHouseList1 = HouseList;
                                        OtherHouseInfo ->
                                            NewOtherHouseInfo = OtherHouseInfo#house_info{
                                                choose_house = {0, 0},
                                                lock = 1,
                                                furniture_list_1 = [],
                                                furniture_list_2 = []
                                            },
                                            lib_house:sql_house_info(NewOtherHouseInfo),
                                            NewHouseList1 = lists:keyreplace({OtherBlockId, OtherHouseId}, #house_info.home_id, HouseList, NewOtherHouseInfo)
                                    end,
                                    NewHouseList = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, NewHouseList1, NewHouseInfo),
                                    case OldLock of
                                        0 ->
                                            skip;
                                        _ ->
                                            lib_common_rank_api:home_rerank({BlockId, HouseId}),
                                            lib_common_rank_api:remove_rank_home({OtherBlockId, OtherHouseId})
                                    end,
                                    #house_info{
                                        role_id_1 = RoleId1,
                                        role_id_2 = RoleId2,
                                        home_id = {BlockId1, HouseId1},
                                        lv = HouseLv1
                                    } = NewHouseInfo,
                                    lib_house:update_house_info(RoleId1, BlockId1, HouseId1, HouseLv1, {0, 0}),
                                    lib_house:update_house_info(RoleId2, BlockId1, HouseId1, HouseLv1, {0, 0});
                                _ ->
                                    NewHouseList = HouseList
                            end,
                            NewAnswerInfo = #house_answer_info{
                                ask_role_id = AskRoleId,
                                answer_role_id = AnswerRoleId,
                                type = Type,
                                answer_type = AnswerType,
                                home_id = {BlockId, HouseId},
                                house_lv = HouseLv
                            },
                            NewAnswerList = lists:keystore(AskRoleId, #house_answer_info.ask_role_id, AnswerList, NewAnswerInfo),
                            {ok, Bin} = pt_177:write(17711, [BlockId, HouseId, HouseLv, Type, AnswerType]),
                            lib_server_send:send_to_uid(AskRoleId, Bin),
                            #house_info{
                                role_id_1 = LogRoleId1,
                                role_id_2 = LogRoleId2,
                                home_id = {LogBlockId1, LogHouseId1},
                                lv = LogHouseLv1
                            } = HouseInfo,
                            lib_log_api:log_house_choose(LogRoleId1, LogRoleId2, LogBlockId1, LogHouseId1, LogHouseLv1, 2, AnswerType)
                    end,
                    NewState = State#house_state{
                        house_list = NewHouseList,
                        aa_list = NewAAList,
                        answer_list = NewAnswerList
                    }
            end
    end,
    {reply, Return, NewState};

do_handle_call({check_upgrade_house, RoleId, BlockId, HouseId}, _From, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList
    } = State,
    Return = lib_house:check_upgrade_house(RoleId, BlockId, HouseId, HouseList, AAList),
    {reply, Return, State};

do_handle_call({check_send_gift, BlockId, HouseId}, _From, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    Return = case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            {false, ?ERRCODE(err177_house_not_exist)};
        #house_info{lock = Lock} ->
            case Lock of
                0 ->
                    true;
                _ ->
                    {false, ?ERRCODE(err177_house_lock)}
            end
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

do_handle_cast({add_furniture, RoleId, BlockId, HouseId, WearFurnitureList}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code = ?ERRCODE(err177_house_none),
            NewState = State;
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                inside_list = InsideList,
                furniture_list_1 = FurnitureList1,
                furniture_list_2 = FurnitureList2
            } = HouseInfo,
            case RoleId of
                RoleId1 ->
                    Type = 1,
                    FurnitureList = FurnitureList1;
                RoleId2 ->
                    Type = 2,
                    FurnitureList = FurnitureList2;
                _ ->
                    Type = 0,
                    FurnitureList = []
            end,
            case Type of
                0 ->
                    Code = ?ERRCODE(err177_house_none),
                    NewState = State;
                _ ->
                    Code = ?SUCCESS,
                    F = fun(PutInfo, NewFurnitureList1) ->
                        {GoodsId1, GoodsTypeId1, GoodsNum1} = PutInfo,
                        case lists:keyfind(GoodsId1, #furniture_info.goods_id, FurnitureList) of
                            false ->
                                NewFurnitureInfo = #furniture_info{
                                    role_id = RoleId,
                                    goods_id = GoodsId1,
                                    goods_type_id = GoodsTypeId1,
                                    goods_num = GoodsNum1
                                };
                            FurnitureInfo ->
                                NewFurnitureInfo = FurnitureInfo#furniture_info{
                                    goods_type_id = GoodsTypeId1,
                                    goods_num = GoodsNum1
                                }
                        end,
                        [NewFurnitureInfo|NewFurnitureList1]
                        end,
                    NewFurnitureList = lists:foldl(F, [], WearFurnitureList),
                    case Type of
                        1 ->
                            %% 默认给一个地板
                            {DefaultFloor, NewInsideList} = lib_house:init_default_floor(RoleId, InsideList),
                            NewHouseInfo = HouseInfo#house_info{
                                furniture_list_1 = lists:keystore(?DefaultFloorGoodsTypeId, #furniture_info.goods_type_id, NewFurnitureList, DefaultFloor),
                                inside_list = NewInsideList,
                                if_sql = 1
                            },
                            NewHouseList = lists:keyreplace(RoleId, #house_info.role_id_1, HouseList, NewHouseInfo);
                        _ ->
                            NewHouseInfo = HouseInfo#house_info{
                                furniture_list_2 = NewFurnitureList
                            },
                            NewHouseList = lists:keyreplace(RoleId, #house_info.role_id_2, HouseList, NewHouseInfo)
                    end,
                    NewState = State#house_state{
                        house_list = NewHouseList
                    }
            end
    end,
    {ok, Bin} = pt_177:write(17701, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({open_block_list, RoleId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    HouseNumList = lib_house:check_open_block(HouseList),
    {ok, Bin} = pt_177:write(17702, [?SUCCESS, 0, 0, HouseNumList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({open_house_list, RoleId, BlockId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    F = fun(HouseInfo, SendInfoList1) ->
        #house_info{
            home_id = {BlockId1, HouseId},
            role_id_1 = RoleId1,
            role_id_2 = RoleId2,
            lv = HouseLv,
            lock = Lock,
            text = Text,
            buy_time = BuyTime,
            choose_house = {ChooseBlockId, _ChooseHouseId}
        } = HouseInfo,
        case BlockId1 of
            BlockId ->
                case ChooseBlockId of
                    0 ->
                        IfChoose = 0;
                    _ ->
                        IfChoose = 1
                end,
                SendInfo = {BlockId, HouseId, RoleId1, RoleId2, HouseLv, Lock, BuyTime, Text, IfChoose},
                [SendInfo|SendInfoList1];
            _ ->
                SendInfoList1
        end
    end,
    SendInfoList = lists:foldl(F, [], HouseList),
    lib_offline_api:apply_cast(lib_house, open_house_list, [RoleId, BlockId, SendInfoList]),
    {noreply, State};

do_handle_cast({into_house, RoleId, BlockId, HouseId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            {ok, Bin} = pt_177:write(17704, [?ERRCODE(err177_house_none), BlockId, HouseId, 0, "", 0, ""]),
            lib_server_send:send_to_uid(RoleId, Bin);
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                name_1 = Name1,
                role_id_2 = RoleId2,
                name_2 = Name2,
                lv = HouseLv,
                lock = Lock,
                if_init_furniture = IfInitFurniture
            } = HouseInfo,
            case Lock of
                0 ->
                    case IfInitFurniture of
                        3 ->
                            #house_lv_con{
                                scene_id = SceneId
                            } = data_house:get_house_lv_con(HouseLv),
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_house, into_house, [RoleId1, Name1, RoleId2, Name2, SceneId, BlockId, HouseId]);
                        _ ->
                            lib_player:apply_cast(RoleId1, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_house, init_furniture, [RoleId, BlockId, HouseId, 1]),
                            lib_player:apply_cast(RoleId2, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_house, init_furniture, [RoleId, BlockId, HouseId, 1])
                    end;
                _ ->
                    {ok, Bin} = pt_177:write(17704, [?ERRCODE(err177_house_lock), BlockId, HouseId, RoleId1, Name1, RoleId2, Name2]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end,
    {noreply, State};

%% 房子重登
do_handle_cast({house_reconnect, RoleId, Lv, RoleId1}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind(RoleId1, #house_info.role_id_1, HouseList) of
        false ->
            [SceneId, X, Y] = lib_scene:get_outside_scene_by_lv(Lv),
            lib_scene:player_change_scene(RoleId, SceneId, 0, 0, X, Y, false, []),
            {noreply, State};
        HouseInfo ->
            #house_info{
                home_id = {BlockId, HouseId}
            } = HouseInfo,
            do_handle_cast({into_house, RoleId, BlockId, HouseId}, State)
    end;

%% 初始化家具列表成功
do_handle_cast({init_furniture_success, RoleId, Args, Type}, State) ->
    [BlockId, HouseId, InitRoleId, WearFurnitureList, Name] = Args,
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code = ?ERRCODE(err177_house_none),
            RoleId1 = 0,
            NewName1 = "",
            RoleId2 = 0,
            NewName2 = "",
            HouseLv = 0,
            HousePoint = 0,
            NewState = State;
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                name_1 = Name1,
                role_id_2 = RoleId2,
                name_2 = Name2,
                lv = HouseLv,
                lock = Lock,
                inside_list = InsideList,
                if_init_furniture = IfInitFurniture,
                furniture_list_1 = FurnitureList1,
                furniture_list_2 = FurnitureList2,
                if_sql = IfSql
            } = HouseInfo,
            case Lock of
                0 ->
                    case lists:member(InitRoleId, [RoleId1, RoleId2]) of
                        false ->
                            Code = ?ERRCODE(err177_house_lock),
                            NewName1 = Name1,
                            NewName2 = Name2,
                            HousePoint = 0,
                            NewState = State;
                        true ->
                            case InitRoleId of
                                RoleId1 ->
                                    WearFurnitureList1 = WearFurnitureList,
                                    WearFurnitureList2 = FurnitureList2,
                                    NewName1 = Name,
                                    NewName2 = Name2,
                                    case RoleId2 of
                                        0 ->
                                            NewIfInitFurniture = 3;
                                        _ ->
                                            case IfInitFurniture of
                                                2 ->
                                                    NewIfInitFurniture = 3;
                                                3 ->
                                                    NewIfInitFurniture = 3;
                                                _ ->
                                                    NewIfInitFurniture = 1
                                            end
                                    end;
                                RoleId2 ->
                                    WearFurnitureList1 = FurnitureList1,
                                    WearFurnitureList2 = WearFurnitureList,
                                    NewName1 = Name1,
                                    NewName2 = Name,
                                    case IfInitFurniture of
                                        1 ->
                                            NewIfInitFurniture = 3;
                                        3 ->
                                            NewIfInitFurniture = 3;
                                        _ ->
                                            NewIfInitFurniture = 2
                                    end
                            end,
                            case NewIfInitFurniture of
                                3 ->
                                    Code = ?SUCCESS,
                                    {WearFurnitureList11, NewFurnitureList2} = lib_house:get_both_final_furniture_list(InsideList, WearFurnitureList1, WearFurnitureList2, BlockId, HouseId),
                                    {DefaultFloor, NewInsideList} = lib_house:init_default_floor(RoleId1, InsideList),
                                    NewFurnitureList1 = lists:keystore(?DefaultFloorGoodsTypeId, #furniture_info.goods_type_id, WearFurnitureList11, DefaultFloor),
                                    NewIfSql = 1;
                                _ ->
                                    Code = ?FAIL,
                                    NewFurnitureList1 = WearFurnitureList1,
                                    NewFurnitureList2 = WearFurnitureList2,
                                    NewInsideList = InsideList,
                                    NewIfSql = IfSql
                            end,
                            NewHouseInfo = HouseInfo#house_info{
                                name_1 = NewName1,
                                name_2 = NewName2,
                                inside_list = NewInsideList,
                                furniture_list_1 = NewFurnitureList1,
                                furniture_list_2 = NewFurnitureList2,
                                if_init_furniture = NewIfInitFurniture,
                                if_sql = NewIfSql
                            },
                            HousePoint = lib_house:get_house_point(NewHouseInfo),
                            NewHouseList = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, HouseList, NewHouseInfo),
                            NewState = State#house_state{
                                house_list = NewHouseList
                            }
                    end;
                _ ->
                    Code = ?ERRCODE(err177_house_lock),
                    NewName1 = Name1,
                    NewName2 = Name2,
                    HousePoint = 0,
                    NewState = State
            end
    end,
    case Code =:= ?FAIL of
        true ->
            skip;
        false ->
            case Type of
                1 ->
                    #house_lv_con{
                        scene_id = SceneId
                    } = data_house:get_house_lv_con(HouseLv),
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_house, into_house, [RoleId1, NewName1, RoleId2, NewName2, SceneId, BlockId, HouseId]);
                _ ->
                    {ok, Bin} = pt_177:write(17706, [Code, BlockId, HouseId, HouseLv, HousePoint]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end,
    {noreply, NewState};

%% 打开升级界面
do_handle_cast({open_upgrade, RoleId, BlockId, HouseId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            NewState = State,
            {ok, Bin} = pt_177:write(17706, [?ERRCODE(err177_house_none), BlockId, HouseId, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                lv = HouseLv,
                if_init_furniture = IfInitFurniture,
                lock = Lock
            } = HouseInfo,
            IfOwn = lists:member(RoleId, [RoleId1, RoleId2]),
            if
                IfOwn =:= false ->
                    NewState = State,
                    {ok, Bin} = pt_177:write(17706, [?ERRCODE(err177_house_not_own), BlockId, HouseId, HouseLv, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                Lock =/= 0 ->
                    NewState = State,
                    {ok, Bin} = pt_177:write(17706, [?ERRCODE(err177_house_lock), BlockId, HouseId, HouseLv, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    case IfInitFurniture of
                        0 ->
                            NewState = State,
                            lib_player:apply_cast(RoleId1, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_house, init_furniture, [RoleId, BlockId, HouseId, 2]),
                            lib_player:apply_cast(RoleId2, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_house, init_furniture, [RoleId, BlockId, HouseId, 2]);
                        _ ->
                            NewState = State,
                            HousePoint = lib_house:get_house_point(HouseInfo),
                            {ok, Bin} = pt_177:write(17706, [?SUCCESS, BlockId, HouseId, HouseLv, HousePoint]),
                            lib_server_send:send_to_uid(RoleId, Bin)
                    end
            end
    end,
    {noreply, NewState};

%% 自己升级
do_handle_cast({upgrade_house, Args}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList
    } = State,
    {RoleId, LoverRoleId, CostList, BlockId, HouseId, Type, CostKey} = Args,
    case lib_house:check_upgrade_house(RoleId, BlockId, HouseId, HouseList, AAList) of
        true ->
            Code = ?SUCCESS,
            HouseInfo = lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList),
            #house_info{
                lv = HouseLv,
                furniture_list_1 = FurnitureList1,
                furniture_list_2 = FurnitureList2,
                inside_list = InsideList,
                marriage_start_lv = OldMarriageStartLv,
                cost_log = CostLogList,
                choose_house = ChooseHouse
            } = HouseInfo,
            NewHouseLv = HouseLv + 1,
            case LoverRoleId of
                0 ->
                    MarriageStartLv = NewHouseLv,
                    NewCostLogList = CostLogList;
                _ ->
                    MarriageStartLv = OldMarriageStartLv,
                    NewCostLogList = [{NewHouseLv, [RoleId]}|CostLogList]
            end,
            {NewFurnitureList1, NewFurnitureList2, NewInsideList} = lib_house:upgrade_inside_change(FurnitureList1, FurnitureList2, InsideList),
            NewHouseInfo = HouseInfo#house_info{
                lv = NewHouseLv,
                marriage_start_lv = MarriageStartLv,
                furniture_list_1 = NewFurnitureList1,
                furniture_list_2 = NewFurnitureList2,
                inside_list = NewInsideList,
                cost_log = NewCostLogList
            },
            lib_house:sql_house_info(NewHouseInfo),
            NewHouseList = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, HouseList, NewHouseInfo),
            NewState = State#house_state{
                house_list = NewHouseList
            },
            lib_consume_data:advance_payment_done(RoleId, CostKey),
            lib_house:update_house_info(RoleId, BlockId, HouseId, NewHouseLv, ChooseHouse),
            lib_house:update_house_info(LoverRoleId, BlockId, HouseId, NewHouseLv, ChooseHouse),
            #house_lv_con{
                scene_id = SceneId
            } = data_house:get_house_lv_con(HouseLv),
            {ok, Bin1} = pt_177:write(17721, [?SUCCESS, BlockId, HouseId, 1]),
            lib_server_send:send_to_scene(SceneId, 0, NewHouseInfo#house_info.role_id_1, Bin1),
            OldHousePoint = lib_house:get_house_point(HouseInfo),
            NewHousePoint = lib_house:get_house_point(NewHouseInfo),
            lib_log_api:log_house_buy_upgrade(RoleId, LoverRoleId, NewHouseInfo#house_info.role_id_1, NewHouseInfo#house_info.role_id_2, HouseLv, NewHouseLv, CostList, [], OldHousePoint, NewHousePoint),
            case LoverRoleId of
                0 ->
                    Args1 = [[RoleId], NewHouseLv],
                    lib_offline_api:apply_cast(lib_house, house_send_tv, [3, Args1]);
                _ ->
                    Args1 = [[RoleId, LoverRoleId], NewHouseLv],
                    lib_offline_api:apply_cast(lib_house, house_send_tv, [4, Args1])
            end;
        {false, Code} ->
            lib_house:house_fail_return(RoleId, CostKey, CostList, 5),
            NewState = State
    end,
    {ok, Bin} = pt_177:write(17707, [Code, BlockId, HouseId, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

%% AA提升房子
do_handle_cast({upgrade_house_aa, Args}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList
    } = State,
    {RoleId, LoverRoleId, AACostList, BlockId, HouseId, HouseLv, Type, CostKey} = Args,
    case lib_house:check_upgrade_house(RoleId, BlockId, HouseId, HouseList, AAList) of
        true ->
            Code = ?SUCCESS,
            ServerId = config:get_server_id(),
            NewAAInfo = #aa_ask_info{
                home_id = {BlockId, HouseId},
                server_id = ServerId,
                house_lv = HouseLv,
                ask_role_id = RoleId,
                answer_role_id = LoverRoleId,
                ask_time = utime:unixtime(),
                type = 2,
                cost_key = CostKey,
                ask_cost_list = AACostList,
                answer_cost_list = AACostList
            },
            lib_house:sql_aa_info(NewAAInfo),
            NewAAList = [NewAAInfo|AAList],
            NewState = State#house_state{
                aa_list = NewAAList
            },
            {ok, Bin1} = pt_177:write(17709, [BlockId, HouseId, HouseLv, RoleId, 2, AACostList, []]),
            lib_server_send:send_to_uid(LoverRoleId, Bin1);
        {false, Code} ->
            lib_house:house_fail_return(RoleId, CostKey, AACostList, 5),
            NewState = State
    end,
    {ok, Bin} = pt_177:write(17707, [Code, BlockId, HouseId, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

%% 回复aa升级
do_handle_cast({answer_upgrade_house_aa, AnswerRoleId, AnswerCostKey, AnswerCostList}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList,
        answer_list = AnswerList
    } = State,
    case lists:keyfind(AnswerRoleId, #aa_ask_info.answer_role_id, AAList) of
        false ->
            Code = ?ERRCODE(err177_house_not_ask),
            Type = 0,
            lib_house:house_fail_return(AnswerRoleId, AnswerCostKey, AnswerCostList, 6),
            NewState = State;
        AAInfo ->
            #aa_ask_info{
                home_id = {BlockId, HouseId},
                server_id = ServerId,
                house_lv = HouseLv,
                ask_role_id = AskRoleId,
                cost_key = AskCostKey,
                type = Type,
                ask_cost_list = AskCostList
            } = AAInfo,
            NewAAList = lists:delete(AAInfo, AAList),
            SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
            ReSql = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlStr]),
            db:execute(ReSql),
            case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
                false ->
                    Code = ?ERRCODE(err177_house_house_exist),
                    lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 6),
                    lib_house:house_fail_return(AnswerRoleId, AnswerCostKey, AnswerCostList, 6),
                    NewState = State#house_state{
                        aa_list = NewAAList
                    },
                    NewState = State;
                HouseInfo ->
                    Code = ?SUCCESS,
                    #house_info{
                        furniture_list_1 = FurnitureList1,
                        furniture_list_2 = FurnitureList2,
                        inside_list = InsideList,
                        lv = HouseLv,
                        cost_log = CostLogList,
                        choose_house = ChooseHouse
                    } = HouseInfo,
                    NewHouseLv = HouseLv + 1,
                    NewCostLogList = [{NewHouseLv, [AskRoleId, AnswerRoleId]}|CostLogList],
                    {NewFurnitureList1, NewFurnitureList2, NewInsideList} = lib_house:upgrade_inside_change(FurnitureList1, FurnitureList2, InsideList),
                    NewHouseInfo = HouseInfo#house_info{
                        lv = NewHouseLv,
                        furniture_list_1 = NewFurnitureList1,
                        furniture_list_2 = NewFurnitureList2,
                        inside_list = NewInsideList,
                        cost_log = NewCostLogList
                    },
                    lib_house:sql_house_info(NewHouseInfo),
                    NewHouseList = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, HouseList, NewHouseInfo),
                    NewAnswerInfo = #house_answer_info{
                        ask_role_id = AskRoleId,
                        answer_role_id = AnswerRoleId,
                        answer_type = 1,
                        home_id = {BlockId, HouseId},
                        house_lv = NewHouseLv
                    },
                    NewAnswerList = lists:keystore(AskRoleId, #house_answer_info.ask_role_id, AnswerList, NewAnswerInfo),
                    {ok, Bin1} = pt_177:write(17711, [BlockId, HouseId, HouseLv, Type, 1]),
                    lib_server_send:send_to_uid(AskRoleId, Bin1),
                    NewState = State#house_state{
                        house_list = NewHouseList,
                        aa_list = NewAAList,
                        answer_list = NewAnswerList
                    },
                    lib_consume_data:advance_payment_done(AskRoleId, AskCostKey),
                    lib_consume_data:advance_payment_done(AnswerRoleId, AnswerCostKey),
                    lib_house:update_house_info(AskRoleId, BlockId, HouseId, NewHouseLv, ChooseHouse),
                    lib_house:update_house_info(AnswerRoleId, BlockId, HouseId, NewHouseLv, ChooseHouse),
                    #house_lv_con{
                        scene_id = SceneId
                    } = data_house:get_house_lv_con(HouseLv),
                    {ok, Bin2} = pt_177:write(17721, [?SUCCESS, BlockId, HouseId, 1]),
                    lib_server_send:send_to_scene(SceneId, 0, NewHouseInfo#house_info.role_id_1, Bin2),
                    OldHousePoint = lib_house:get_house_point(HouseInfo),
                    NewHousePoint = lib_house:get_house_point(NewHouseInfo),
                    lib_log_api:log_house_buy_upgrade(AskRoleId, AnswerRoleId, NewHouseInfo#house_info.role_id_1, NewHouseInfo#house_info.role_id_2, HouseLv, NewHouseLv, AskCostList, AnswerCostList, OldHousePoint, NewHousePoint),
                    Args1 = [[AskRoleId, AnswerRoleId], NewHouseLv],
                    lib_offline_api:apply_cast(lib_house, house_send_tv, [4, Args1])
            end
    end,
    {ok, Bin} = pt_177:write(17710, [Code, Type]),
    lib_server_send:send_to_uid(AnswerRoleId, Bin),
    {noreply, NewState};

%% 自己购买房子
do_handle_cast({buy_house, Args}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList
    } = State,
    {RoleId, LoverRoleId, CostList, BlockId, HouseId, Type, CostKey} = Args,
    case lib_house:check_buy_house(RoleId, BlockId, HouseId, HouseList, AAList) of
        true ->
            Code = ?SUCCESS,
            case LoverRoleId of
                0 ->
                    MarriageStartLv = 1,
                    CostLogList = [];
                _ ->
                    MarriageStartLv = 0,
                    CostLogList = [{1, [RoleId]}]
            end,
            ServerId = config:get_server_id(),
            NewHouseInfo = #house_info{
                home_id = {BlockId, HouseId},
                server_id = ServerId,
                role_id_1 = RoleId,
                role_id_2 = LoverRoleId,
                lv = 1,
                marriage_start_lv = MarriageStartLv,
                cost_log = CostLogList,
                text = utext:get(?HouseFirstTextId),
                buy_time = utime:unixtime()
            },
            lib_house:sql_house_info(NewHouseInfo),
            NewHouseList = [NewHouseInfo|HouseList],
            NewState = State#house_state{
                house_list = NewHouseList
            },
            lib_consume_data:advance_payment_done(RoleId, CostKey),
            lib_house:update_house_info(RoleId, BlockId, HouseId, 1, {0, 0}),
            lib_house:update_house_info(LoverRoleId, BlockId, HouseId, 1, {0, 0}),
            NewHousePoint = lib_house:get_house_point(NewHouseInfo),
            lib_log_api:log_house_buy_upgrade(RoleId, LoverRoleId, NewHouseInfo#house_info.role_id_1, NewHouseInfo#house_info.role_id_2, 0, 1, CostList, [], 0, NewHousePoint),
            case LoverRoleId of
                0 ->
                    Args1 = [[RoleId], BlockId],
                    lib_offline_api:apply_cast(lib_house, house_send_tv, [1, Args1]);
                _ ->
                    Args1 = [[RoleId, LoverRoleId], BlockId],
                    lib_offline_api:apply_cast(lib_house, house_send_tv, [2, Args1])
            end;
        {false, Code} ->
            lib_house:house_fail_return(RoleId, CostKey, CostList, 1),
            NewState = State
    end,
    {ok, Bin} = pt_177:write(17708, [Code, BlockId, HouseId, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

%% AA购买房子
do_handle_cast({buy_house_aa, Args}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList
    } = State,
    {RoleId, LoverRoleId, AACostList, BlockId, HouseId, Type, CostKey} = Args,
    case lib_house:check_buy_house(RoleId, BlockId, HouseId, HouseList, AAList) of
        true ->
            Code = ?SUCCESS,
            ServerId = config:get_server_id(),
            NewAAInfo = #aa_ask_info{
                home_id = {BlockId, HouseId},
                server_id = ServerId,
                house_lv = 1,
                ask_role_id = RoleId,
                answer_role_id = LoverRoleId,
                ask_time = utime:unixtime(),
                type = 1,
                cost_key = CostKey,
                ask_cost_list = AACostList,
                answer_cost_list = AACostList
            },
            lib_house:sql_aa_info(NewAAInfo),
            NewAAList = [NewAAInfo|AAList],
            NewState = State#house_state{
                aa_list = NewAAList
            },
            {ok, Bin1} = pt_177:write(17709, [BlockId, HouseId, 1, RoleId, 1, AACostList, []]),
            lib_server_send:send_to_uid(LoverRoleId, Bin1);
        {false, Code} ->
            lib_house:house_fail_return(RoleId, CostKey, AACostList, 1),
            NewState = State
    end,
    {ok, Bin} = pt_177:write(17708, [Code, BlockId, HouseId, Type]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

%% 回复aa买房子答应
do_handle_cast({answer_buy_house_aa, AnswerRoleId, AnswerCostKey, AnswerCostList}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList,
        answer_list = AnswerList
    } = State,
    case lists:keyfind(AnswerRoleId, #aa_ask_info.answer_role_id, AAList) of
        false ->
            Code = ?ERRCODE(err177_house_not_ask),
            Type = 0,
            lib_house:house_fail_return(AnswerRoleId, AnswerCostKey, AnswerCostList, 2),
            NewState = State;
        AAInfo ->
            #aa_ask_info{
                home_id = {BlockId, HouseId},
                server_id = ServerId1,
                house_lv = HouseLv,
                ask_role_id = AskRoleId,
                cost_key = AskCostKey,
                type = Type,
                ask_cost_list = AskCostList
            } = AAInfo,
            NewAAList = lists:delete(AAInfo, AAList),
            SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId1]),
            ReSql = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlStr]),
            db:execute(ReSql),
            case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
                false ->
                    Code = ?SUCCESS,
                    CostLogList = [{1, [AskRoleId, AnswerRoleId]}],
                    ServerId = config:get_server_id(),
                    NewHouseInfo = #house_info{
                        home_id = {BlockId, HouseId},
                        server_id = ServerId,
                        role_id_1 = AskRoleId,
                        role_id_2 = AnswerRoleId,
                        lv = 1,
                        marriage_start_lv = 0,
                        cost_log = CostLogList,
                        buy_time = utime:unixtime()
                    },
                    lib_house:sql_house_info(NewHouseInfo),
                    NewHouseList = [NewHouseInfo|HouseList],
                    NewAnswerInfo = #house_answer_info{
                        ask_role_id = AskRoleId,
                        answer_role_id = AnswerRoleId,
                        answer_type = 1,
                        home_id = {BlockId, HouseId},
                        house_lv = HouseLv
                    },
                    NewAnswerList = lists:keystore(AskRoleId, #house_answer_info.ask_role_id, AnswerList, NewAnswerInfo),
                    {ok, Bin1} = pt_177:write(17711, [BlockId, HouseId, HouseLv, Type, 1]),
                    lib_server_send:send_to_uid(AskRoleId, Bin1),
                    NewState = State#house_state{
                        house_list = NewHouseList,
                        aa_list = NewAAList,
                        answer_list = NewAnswerList
                    },
                    lib_consume_data:advance_payment_done(AskRoleId, AskCostKey),
                    lib_consume_data:advance_payment_done(AnswerRoleId, AnswerCostKey),
                    lib_house:update_house_info(AskRoleId, BlockId, HouseId, 1, {0, 0}),
                    lib_house:update_house_info(AnswerRoleId, BlockId, HouseId, 1, {0, 0}),
                    NewHousePoint = lib_house:get_house_point(NewHouseInfo),
                    lib_log_api:log_house_buy_upgrade(AskRoleId, AnswerRoleId, NewHouseInfo#house_info.role_id_1, NewHouseInfo#house_info.role_id_2, 0, 1, AskCostList, AnswerCostList, 0, NewHousePoint),
                    Args1 = [[AskRoleId, AnswerRoleId], BlockId],
                    lib_offline_api:apply_cast(lib_house, house_send_tv, [2, Args1]);
                _ ->
                    Code = ?ERRCODE(err177_house_house_exist),
                    lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 2),
                    lib_house:house_fail_return(AnswerRoleId, AnswerCostKey, AnswerCostList, 2),
                    NewState = State#house_state{
                        aa_list = NewAAList
                    },
                    NewState = State
            end
    end,
    {ok, Bin} = pt_177:write(17710, [Code, Type]),
    lib_server_send:send_to_uid(AnswerRoleId, Bin),
    {noreply, NewState};

do_handle_cast({take_answer_info, RoleId}, State) ->
    #house_state{
        answer_list = AnswerList
    } = State,
    NewAnswerList = lists:keydelete(RoleId, #house_answer_info.ask_role_id, AnswerList),
    NewState = State#house_state{
        answer_list = NewAnswerList
    },
    {noreply, NewState};

%% 把家具放进家园场景里/移动家具
do_handle_cast({put_furniture_inside, RoleId, Args}, State) ->
    % #house_state{
    %     house_list = HouseList
    % } = State,
    % [LocId, GoodsTypeId, Type, X, Y, Face, MapId, InsId, CopyId] = Args,
    % HouseInfo = case lists:keyfind(RoleId, #house_info.role_id_1, HouseList) of
    %     false ->
    %         lists:keyfind(RoleId, #house_info.role_id_2, HouseList);
    %     HouseInfo1 ->
    %         case HouseInfo1#house_info.lock of
    %             0 ->
    %                 HouseInfo1;
    %             _ ->
    %                 lists:keyfind(RoleId, #house_info.role_id_2, HouseList)
    %         end
    % end,
    % case HouseInfo of
    %     false ->
    %         Code = ?ERRCODE(err177_house_none),
    %         NewLocId = 0,
    %         OwnRoleId = 0,
    %         NewState = State;
    %     _ ->
    %         #house_info{
    %             home_id = {BlockId, HouseId},
    %             role_id_1 = RoleId1,
    %             lv = HouseLv,
    %             furniture_list_1 = FurnitureList1,
    %             furniture_list_2 = FurnitureList2,
    %             inside_list = InsideList
    %         } = HouseInfo,
    %         FurnitureInfo = case Type of
    %             1 ->
    %                 case lists:keyfind(GoodsTypeId, #furniture_info.goods_type_id, FurnitureList1) of
    %                     false ->
    %                         FromSide = 2,
    %                         case lists:keyfind(GoodsTypeId, #furniture_info.goods_type_id, FurnitureList2) of
    %                             false ->
    %                                 false;
    %                             FurnitureInfo2 ->
    %                                 #furniture_info{
    %                                     put_num = PutNum2,
    %                                     goods_num = GoodsNum2
    %                                 } = FurnitureInfo2,
    %                                 case PutNum2 >= GoodsNum2 of
    %                                     true ->
    %                                         false;
    %                                     false ->
    %                                         FurnitureInfo2
    %                                 end
    %                         end;
    %                     FurnitureInfo1 ->
    %                         #furniture_info{
    %                             put_num = PutNum1,
    %                             goods_num = GoodsNum1
    %                         } = FurnitureInfo1,
    %                         case PutNum1 >= GoodsNum1 of
    %                             true ->
    %                                 FromSide = 2,
    %                                 case lists:keyfind(GoodsTypeId, #furniture_info.goods_type_id, FurnitureList2) of
    %                                     false ->
    %                                         false;
    %                                     FurnitureInfo2 ->
    %                                         #furniture_info{
    %                                             put_num = PutNum2,
    %                                             goods_num = GoodsNum2
    %                                         } = FurnitureInfo2,
    %                                         case PutNum2 >= GoodsNum2 of
    %                                             true ->
    %                                                 false;
    %                                             false ->
    %                                                 FurnitureInfo2
    %                                         end
    %                                 end;
    %                             false ->
    %                                 FromSide = 1,
    %                                 FurnitureInfo1
    %                         end
    %                 end;
    %             _ ->
    %                 case lists:keyfind(LocId, #furniture_inside_info.loc_id, InsideList) of
    %                     false ->
    %                         FromSide = 1,
    %                         false;
    %                     #furniture_inside_info{goods_id = GoodsId1} ->
    %                         case lists:keyfind(GoodsId1, #furniture_info.goods_id, FurnitureList1) of
    %                             false ->
    %                                 FromSide = 2,
    %                                 lists:keyfind(GoodsId1, #furniture_info.goods_id, FurnitureList2);
    %                             FurnitureInfo1 ->
    %                                 FromSide = 1,
    %                                 FurnitureInfo1
    %                         end
    %                 end
    %         end,
    %         if
    %             CopyId =/= RoleId1 ->
    %                 Code = ?ERRCODE(err177_house_not_own),
    %                 NewLocId = 0,
    %                 OwnRoleId = 0,
    %                 NewState = State;
    %             FurnitureInfo =:= false ->
    %                 Code = ?ERRCODE(err177_house_not_furniture),
    %                 NewLocId = 0,
    %                 OwnRoleId = 0,
    %                 NewState = State;
    %             true ->
    %                 #furniture_info{
    %                     goods_id = GoodsId,
    %                     role_id = OwnRoleId,
    %                     put_num = PutNum
    %                 } = FurnitureInfo,
    %                 #house_lv_con{
    %                     scene_id = SceneId
    %                 } = data_house:get_house_lv_con(HouseLv),
    %                 case Type of
    %                     1 -> %% 把家具放进家园场景
    %                         #house_furniture_con{
    %                             max_num = MaxNum
    %                         } = data_house:get_house_furniture_con(GoodsTypeId),
    %                         case PutNum >= MaxNum of
    %                             true ->
    %                                 Code = ?ERRCODE(err177_house_furniture_put_max),
    %                                 NewLocId = 0,
    %                                 NewState = State;
    %                             false ->
    %                                 Code = ?SUCCESS,
    %                                 #ets_goods_type{subtype = SubType} = data_goods_type:get(GoodsTypeId),
    %                                 case SubType =:= ?GOODS_FURNITURE_STYPE_FLOOR of
    %                                     false ->
    %                                         InsideList1 = InsideList;
    %                                     true -> %% 把旧的地板卸下
    %                                         InsideList1 = [InsideInfo||InsideInfo <- InsideList, begin
    %                                             #furniture_info{
    %                                                 goods_type_id = GoodsTypeId1
    %                                             } = InsideInfo,
    %                                             #ets_goods_type{subtype = SubType1} = data_goods_type:get(GoodsTypeId1),
    %                                             SubType1 =/= ?GOODS_FURNITURE_STYPE_FLOOR
    %                                         end]
    %                                 end,
    %                                 NewPutNum = PutNum + 1,
    %                                 NewLocId = mod_id_create:get_new_id(?LOC_ID_CREATE),
    %                                 FurnitureInsideInfo = #furniture_inside_info{
    %                                     loc_id = NewLocId,
    %                                     goods_id = GoodsId,
    %                                     goods_type_id = GoodsTypeId,
    %                                     x = X,
    %                                     y = Y,
    %                                     face = Face,
    %                                     map_id = MapId
    %                                 },
    %                                 NewFurnitureInfo = FurnitureInfo#furniture_info{
    %                                     put_num = NewPutNum
    %                                 },
    %                                 case FromSide of
    %                                     1 ->
    %                                         NewFurnitureList1 = lists:keyreplace(GoodsTypeId, #furniture_info.goods_type_id, FurnitureList1, NewFurnitureInfo),
    %                                         NewFurnitureList2 = FurnitureList2;
    %                                     _ ->
    %                                         NewFurnitureList1 = FurnitureList1,
    %                                         NewFurnitureList2 = lists:keyreplace(GoodsTypeId, #furniture_info.goods_type_id, FurnitureList2, NewFurnitureInfo)
    %                                 end,
    %                                 NewInsideList = [FurnitureInsideInfo|InsideList1],
    %                                 NewHouseInfo = HouseInfo#house_info{
    %                                     furniture_list_1 = NewFurnitureList1,
    %                                     furniture_list_2 = NewFurnitureList2,
    %                                     inside_list = NewInsideList,
    %                                     if_sql = 1
    %                                 },
    %                                 NewHouseList = lists:keyreplace(RoleId1, #house_info.role_id_1, HouseList, NewHouseInfo),
    %                                 NewState = State#house_state{
    %                                     house_list = NewHouseList
    %                                 },
    %                                 {ok, Bin1} = pt_177:write(17721, [?SUCCESS, BlockId, HouseId, 2]),
    %                                 lib_server_send:send_to_scene(SceneId, 0, RoleId1, Bin1)
    %                         end;
    %                     2 -> %% 移除
    %                         NewLocId = 0,
    %                         case lists:keyfind(LocId, #furniture_inside_info.loc_id, InsideList) of
    %                             false ->
    %                                 Code = ?ERRCODE(err177_house_not_inside),
    %                                 NewState = State;
    %                             FurnitureInsideInfo ->
    %                                 #ets_goods_type{subtype = SubType} = data_goods_type:get(GoodsTypeId),
    %                                 case SubType =:= ?GOODS_FURNITURE_STYPE_FLOOR of
    %                                     true ->
    %                                         Code = ?ERRCODE(err177_house_floor_not_back),
    %                                         NewState = State;
    %                                     false ->
    %                                         Code = ?SUCCESS,
    %                                         NewFurnitureInfo = FurnitureInfo#furniture_info{
    %                                             put_num = max(0, PutNum-1)
    %                                         },
    %                                         case FromSide of
    %                                             1 ->
    %                                                 NewFurnitureList1 = lists:keyreplace(GoodsTypeId, #furniture_info.goods_type_id, FurnitureList1, NewFurnitureInfo),
    %                                                 NewFurnitureList2 = FurnitureList2;
    %                                             _ ->
    %                                                 NewFurnitureList1 = FurnitureList1,
    %                                                 NewFurnitureList2 = lists:keyreplace(GoodsTypeId, #furniture_info.goods_type_id, FurnitureList2, NewFurnitureInfo)
    %                                         end,
    %                                         NewInsideList = lists:delete(FurnitureInsideInfo, InsideList),
    %                                         ReSql = io_lib:format(?DeleteHouseFurnitureLocSql, [LocId]),
    %                                         db:execute(ReSql),
    %                                         NewHouseInfo = HouseInfo#house_info{
    %                                             furniture_list_1 = NewFurnitureList1,
    %                                             furniture_list_2 = NewFurnitureList2,
    %                                             inside_list = NewInsideList
    %                                         },
    %                                         NewHouseList = lists:keyreplace(RoleId1, #house_info.role_id_1, HouseList, NewHouseInfo),
    %                                         NewState = State#house_state{
    %                                             house_list = NewHouseList
    %                                         },
    %                                         {ok, Bin1} = pt_177:write(17721, [?SUCCESS, BlockId, HouseId, 2]),
    %                                         lib_server_send:send_to_scene(SceneId, 0, RoleId1, Bin1)
    %                                 end
    %                         end;
    %                     _ -> %% 移动家具
    %                         NewLocId = LocId,
    %                         case lists:keyfind(LocId, #furniture_inside_info.loc_id, InsideList) of
    %                             false ->
    %                                 Code = ?ERRCODE(err177_house_not_inside),
    %                                 NewState = State;
    %                             FurnitureInsideInfo ->
    %                                 #furniture_inside_info{
    %                                     x = OldX,
    %                                     y = OldY,
    %                                     face = OldFace,
    %                                     map_id = OldMapId
    %                                 } = FurnitureInsideInfo,
    %                                 case X =:= OldX andalso Y =:= OldY andalso Face =:= OldFace andalso MapId =:= OldMapId of
    %                                     true ->
    %                                         Code = ?SUCCESS,
    %                                         NewState = State;
    %                                     false ->
    %                                         Code = ?SUCCESS,
    %                                         NewFurnitureInsideInfo = FurnitureInsideInfo#furniture_inside_info{
    %                                             x = X,
    %                                             y = Y,
    %                                             face = Face,
    %                                             map_id = MapId
    %                                         },
    %                                         NewInsideList = lists:keyreplace(LocId, #furniture_inside_info.loc_id, InsideList, NewFurnitureInsideInfo),
    %                                         NewHouseInfo = HouseInfo#house_info{
    %                                             inside_list = NewInsideList,
    %                                             if_sql = 1
    %                                         },
    %                                         NewHouseList = lists:keyreplace(RoleId1, #house_info.role_id_1, HouseList, NewHouseInfo),
    %                                         NewState = State#house_state{
    %                                             house_list = NewHouseList
    %                                         },
    %                                         {ok, Bin1} = pt_177:write(17721, [?SUCCESS, BlockId, HouseId, 2]),
    %                                         lib_server_send:send_to_scene(SceneId, 0, RoleId1, Bin1)
    %                                 end
    %                         end
    %                 end
    %         end
    % end,
    % {ok, Bin} = pt_177:write(17713, [Code, NewLocId, GoodsTypeId, Type, OwnRoleId, X, Y, Face, MapId, InsId]),
    % lib_server_send:send_to_uid(RoleId, Bin),
    % {noreply, NewState};
    {noreply, State};

do_handle_cast({get_inside_list, RoleId, BlockId, HouseId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code = ?ERRCODE(err177_house_none),
            SendList = [];
        HouseInfo ->
            Code = ?SUCCESS,
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                furniture_list_1 = FurnitureList1,
                inside_list = InsideList
            } = HouseInfo,
            SendList = [begin
                #furniture_inside_info{
                    loc_id = LocId,
                    goods_id = GoodsId,
                    goods_type_id = GoodsTypeId,
                    x = X,
                    y = Y,
                    face = Face,
                    map_id = MapId
                } = InsideInfo,
                OwnRoleId = case lists:keyfind(GoodsId, #furniture_info.goods_id, FurnitureList1) of
                    false ->
                        RoleId2;
                    _ ->
                        RoleId1
                end,
                {LocId, OwnRoleId, GoodsTypeId, X, Y, Face, MapId}
            end||InsideInfo <- InsideList]
    end,
    {ok, Bin} = pt_177:write(17714, [Code, BlockId, HouseId, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%% 结婚时房子操作
do_handle_cast({marriage_house, RoleIdM, NameM, RoleIdW, NameW, ProposeRoleId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    HouseInfoM = lists:keyfind(RoleIdM, #house_info.role_id_1, HouseList),
    HouseInfoW = lists:keyfind(RoleIdW, #house_info.role_id_1, HouseList),
    if
        HouseInfoM =:= false andalso HouseInfoW =:= false ->
            UseRoleId = 0,
            Type = 0,
            NewHouseList = HouseList,
            lib_log_api:log_house_choose(RoleIdM, RoleIdW, 0, 0, 0, 1, 0);
        HouseInfoM =/= false andalso HouseInfoW =:= false ->
            NewHouseInfo = HouseInfoM#house_info{
                name_1 = NameM,
                role_id_2 = RoleIdW,
                name_2 = NameW,
                marriage_start_lv = HouseInfoM#house_info.lv
            },
            lib_house:sql_house_info(NewHouseInfo),
            NewHouseList = lists:keyreplace(RoleIdM, #house_info.role_id_1, HouseList, NewHouseInfo),
            #house_info{
                role_id_1 = UseRoleId,
                home_id = {BlockId, HouseId},
                lv = HouseLv,
                choose_house = ChooseHouse
            } = NewHouseInfo,
            Type = 1,
            lib_house:update_house_info(RoleIdM, BlockId, HouseId, HouseLv, ChooseHouse),
            lib_house:update_house_info(RoleIdW, BlockId, HouseId, HouseLv, ChooseHouse),
            lib_common_rank_api:home_role_change({BlockId, HouseId}, RoleIdM, RoleIdW),
            lib_log_api:log_house_choose(RoleIdM, RoleIdW, BlockId, HouseId, HouseLv, 1, 0);
        HouseInfoM =:= false andalso HouseInfoW =/= false ->
            NewHouseInfo = HouseInfoW#house_info{
                name_1 = NameW,
                role_id_2 = RoleIdM,
                name_2 = NameM,
                marriage_start_lv = HouseInfoW#house_info.lv
            },
            lib_house:sql_house_info(NewHouseInfo),
            NewHouseList = lists:keyreplace(RoleIdW, #house_info.role_id_1, HouseList, NewHouseInfo),
            #house_info{
                role_id_1 = UseRoleId,
                home_id = {BlockId, HouseId},
                lv = HouseLv,
                choose_house = ChooseHouse
            } = NewHouseInfo,
            Type = 1,
            lib_house:update_house_info(RoleIdM, BlockId, HouseId, HouseLv, ChooseHouse),
            lib_house:update_house_info(RoleIdW, BlockId, HouseId, HouseLv, ChooseHouse),
            lib_common_rank_api:home_role_change({BlockId, HouseId}, RoleIdW, RoleIdM),
            lib_log_api:log_house_choose(RoleIdW, RoleIdM, BlockId, HouseId, HouseLv, 1, 0);
        true ->
            #house_info{
                lv = HouseLvM
            } = HouseInfoM,
            #house_info{
                lv = HouseLvW
            } = HouseInfoW,
            Type = 2,
            if
                HouseLvM > HouseLvW ->
                    UseRoleId = HouseInfoM#house_info.role_id_1,
                    NewHouseList = lib_house:marriage_house(HouseInfoM, HouseInfoW, HouseList);
                HouseLvM < HouseLvW ->
                    UseRoleId = HouseInfoW#house_info.role_id_1,
                    NewHouseList = lib_house:marriage_house(HouseInfoW, HouseInfoM, HouseList);
                true ->
                    case ProposeRoleId of
                        RoleIdM ->
                            UseRoleId = HouseInfoM#house_info.role_id_1,
                            NewHouseList = lib_house:marriage_house(HouseInfoM, HouseInfoW, HouseList);
                        _ ->
                            UseRoleId = HouseInfoW#house_info.role_id_1,
                            NewHouseList = lib_house:marriage_house(HouseInfoW, HouseInfoM, HouseList)
                    end
            end
    end,
    case UseRoleId of
        0 ->
            skip;
        _ ->
            lib_offline_api:apply_cast(UseRoleId, lib_house, marriage_house_success, [RoleIdM, RoleIdW, Type])
    end,
    NewState = State#house_state{
        house_list = NewHouseList
    },
    {noreply, NewState};

do_handle_cast({divorce_house, RoleIdM, RoleIdW}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList,
        answer_list = AnswerList
    } = State,
    HouseInfoM = lists:keyfind(RoleIdM, #house_info.role_id_1, HouseList),
    HouseInfoW = lists:keyfind(RoleIdW, #house_info.role_id_1, HouseList),
    if
        HouseInfoM =:= false andalso HouseInfoW =:= false ->
            SceneId = 0,
            CopyId = 0,
            NewHouseList = HouseList,
            lib_log_api:log_house_divorce(RoleIdM, RoleIdW, 0, 0, 0, 0, 0, 0),
            lib_log_api:log_house_divorce(RoleIdW, RoleIdM, 0, 0, 0, 0, 0, 0);
        HouseInfoM =/= false andalso HouseInfoW =:= false ->
            #house_info{
                role_id_1 = CopyId,
                lv = UseHouseLv
            } = HouseInfoM,
            #house_lv_con{
                scene_id = SceneId
            } = data_house:get_house_lv_con(UseHouseLv),
            {{BlockIdM, HouseIdM, HouseLvM}, RoleId1ReturnList, RoleId2ReturnList, NewHouseList, _NewHouseInfo} = lib_house:divorce_house(HouseInfoM, HouseList),
            case BlockIdM of
                0 ->
                    Title = ?LAN_MSG(?LAN_TITLE_HOUSE_DIVORCE_AFTER_BUY),
                    Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_DIVORCE_AFTER_BUY),
                    lib_mail_api:send_sys_mail([RoleIdM], Title, Content, RoleId1ReturnList),
                    lib_mail_api:send_sys_mail([RoleIdW], Title, Content, RoleId2ReturnList);
                _ ->
                    lib_offline_api:apply_cast(RoleIdM, lib_house, divorce_house_side, [RoleIdM, RoleIdW, RoleId1ReturnList, RoleId2ReturnList])
            end,
            lib_house:update_house_info(RoleIdM, BlockIdM, HouseIdM, HouseLvM, {0, 0}),
            lib_house:update_house_info(RoleIdW, 0, 0, 0, {0, 0}),
            #house_info{
                home_id = {BeforeBlockId, BeforeHouseId},
                lv = BeforeHouseLv
            } = HouseInfoM,
            lib_log_api:log_house_divorce(RoleIdM, RoleIdW, BeforeBlockId, BeforeHouseId, BeforeHouseLv, BlockIdM, HouseIdM, HouseLvM),
            lib_log_api:log_house_divorce(RoleIdW, RoleIdM, BeforeBlockId, BeforeHouseId, BeforeHouseLv, 0, 0, 0);
        HouseInfoM =:= false andalso HouseInfoW =/= false ->
            #house_info{
                role_id_1 = CopyId,
                lv = UseHouseLv
            } = HouseInfoW,
            #house_lv_con{
                scene_id = SceneId
            } = data_house:get_house_lv_con(UseHouseLv),
            {{BlockIdW, HouseIdW, HouseLvW}, RoleId1ReturnList, RoleId2ReturnList, NewHouseList, _NewHouseInfo} = lib_house:divorce_house(HouseInfoW, HouseList),
            case BlockIdW of
                0 ->
                    Title = ?LAN_MSG(?LAN_TITLE_HOUSE_DIVORCE_AFTER_BUY),
                    Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_DIVORCE_AFTER_BUY),
                    lib_mail_api:send_sys_mail([RoleIdW], Title, Content, RoleId1ReturnList),
                    lib_mail_api:send_sys_mail([RoleIdM], Title, Content, RoleId2ReturnList);
                _ ->
                    lib_offline_api:apply_cast(RoleIdW, lib_house, divorce_house_side, [RoleIdW, RoleIdM, RoleId1ReturnList, RoleId2ReturnList])
            end,
            lib_house:update_house_info(RoleIdM, 0, 0, 0, {0, 0}),
            lib_house:update_house_info(RoleIdW, BlockIdW, HouseIdW, HouseLvW, {0, 0}),
            #house_info{
                home_id = {BeforeBlockId, BeforeHouseId},
                lv = BeforeHouseLv
            } = HouseInfoW,
            lib_log_api:log_house_divorce(RoleIdM, RoleIdW, BeforeBlockId, BeforeHouseId, BeforeHouseLv, 0, 0, 0),
            lib_log_api:log_house_divorce(RoleIdW, RoleIdM, BeforeBlockId, BeforeHouseId, BeforeHouseLv, BlockIdW, HouseIdW, HouseLvW);
        true ->
            {{BlockIdM, HouseIdM, HouseLvM}, RoleId1ReturnList1, RoleId2ReturnList1, NewHouseList1, NewHouseInfoM1} = lib_house:divorce_house(HouseInfoM, HouseList),
            {{BlockIdW, HouseIdW, HouseLvW}, RoleId1ReturnList2, RoleId2ReturnList2, NewHouseList2, NewHouseInfoW1} = lib_house:divorce_house(HouseInfoW, NewHouseList1),
            #house_info{
                name_1 = Name1M,
                name_2 = Name2M,
                lock = OldLockM,
                furniture_list_1 = OldFurnitureList1M,
                furniture_list_2 = OldFurnitureList2M
            } = HouseInfoM,
            #house_info{
                name_1 = Name1W,
                name_2 = Name2W,
                furniture_list_1 = OldFurnitureList1W,
                furniture_list_2 = OldFurnitureList2W
            } = HouseInfoW,
            F1 = fun(FurnitureInfo1, FurnitureList1) ->
                NewFurnitureInfo1 = FurnitureInfo1#furniture_info{
                    put_num = 0
                },
                [NewFurnitureInfo1|FurnitureList1]
            end,
            NewFurnitureList1M = lists:foldl(F1, [], OldFurnitureList1M),
            NewFurnitureList2M = lists:foldl(F1, [], OldFurnitureList2M),
            NewFurnitureList1W = lists:foldl(F1, [], OldFurnitureList1W),
            NewFurnitureList2W = lists:foldl(F1, [], OldFurnitureList2W),
            case OldLockM of
                0 ->
                    NewHouseInfoM = NewHouseInfoM1#house_info{
                        name_1 = Name1M,
                        name_2 = "",
                        furniture_list_1 = NewFurnitureList1M,
                        furniture_list_2 = []
                    },
                    NewHouseInfoW = NewHouseInfoW1#house_info{
                        name_1 = Name2M,
                        name_2 = "",
                        furniture_list_1 = NewFurnitureList2M,
                        furniture_list_2 = []
                    };
                _ ->
                    NewHouseInfoM = NewHouseInfoM1#house_info{
                        name_1 = Name2W,
                        name_2 = "",
                        furniture_list_1 = NewFurnitureList2W,
                        furniture_list_2 = []
                    },
                    NewHouseInfoW = NewHouseInfoW1#house_info{
                        name_1 = Name1W,
                        name_2 = "",
                        furniture_list_1 = NewFurnitureList1W,
                        furniture_list_2 = []
                    }
            end,
            NewHouseList3 = lists:keyreplace(RoleIdM, #house_info.role_id_1, NewHouseList2, NewHouseInfoM),
            NewHouseList = lists:keyreplace(RoleIdW, #house_info.role_id_1, NewHouseList3, NewHouseInfoW),
            RoleId1ReturnList = RoleId1ReturnList1 ++ RoleId2ReturnList2,
            RoleId2ReturnList = RoleId1ReturnList2 ++ RoleId2ReturnList1,
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_DIVORCE_BOTH_HAVE),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_DIVORCE_BOTH_HAVE),
            lib_mail_api:send_sys_mail([RoleIdM], Title, Content, RoleId1ReturnList),
            lib_mail_api:send_sys_mail([RoleIdW], Title, Content, RoleId2ReturnList),
            lib_house:update_house_info(RoleIdM, BlockIdM, HouseIdM, HouseLvM, {0, 0}),
            lib_house:update_house_info(RoleIdW, BlockIdW, HouseIdW, HouseLvW, {0, 0}),
            BeforeHouseInfo = case HouseInfoM#house_info.lock of
                0 ->
                    HouseInfoM;
                _ ->
                    HouseInfoW
            end,
            #house_info{
                home_id = {BeforeBlockId, BeforeHouseId},
                role_id_1 = CopyId,
                lv = BeforeHouseLv
            } = BeforeHouseInfo,
            #house_lv_con{
                scene_id = SceneId
            } = data_house:get_house_lv_con(BeforeHouseLv),
            lib_log_api:log_house_divorce(RoleIdM, RoleIdW, BeforeBlockId, BeforeHouseId, BeforeHouseLv, BlockIdM, HouseIdM, HouseLvM),
            lib_log_api:log_house_divorce(RoleIdW, RoleIdM, BeforeBlockId, BeforeHouseId, BeforeHouseLv, BlockIdW, HouseIdW, HouseLvW)
    end,
    case lists:keyfind(RoleIdM, #aa_ask_info.ask_role_id, AAList) of
        false ->
            case lists:keyfind(RoleIdW, #aa_ask_info.ask_role_id, AAList) of
                false ->
                    AAInfo = false;
                AAInfo ->
                    AAInfo
            end;
        AAInfo ->
            AAInfo
    end,
    case AAInfo of
        false ->
            NewAAList = AAList,
            NewAnswerList = AnswerList;
        _ ->
            #aa_ask_info{
                home_id = {BlockId, HouseId},
                ask_role_id = AskRoleId,
                answer_role_id = AnswerRoleId,
                house_lv = HouseLv,
                cost_key = CostKey,
                ask_cost_list = AskCostList,
                type = Type
            } = AAInfo,
            case Type of
                1 ->
                    lib_house:house_fail_return(AskRoleId, CostKey, AskCostList, 3);
                2 ->
                    lib_house:house_fail_return(AskRoleId, CostKey, AskCostList, 7);
                _ ->
                    skip
            end,
            NewAAList = lists:delete(AAInfo, AAList),
            NewAnswerInfo = #house_answer_info{
                ask_role_id = AskRoleId,
                answer_role_id = AnswerRoleId,
                type = Type,           %% 类型：1买房子 2升级 3选择发你
                answer_type = 2,    %% 类型：1答应 2拒绝
                home_id = {BlockId, HouseId},
                house_lv = HouseLv
            },
            NewAnswerList = lists:keystore(AskRoleId, #house_answer_info.ask_role_id, AnswerList, NewAnswerInfo),
            {ok, Bin1} = pt_177:write(17711, [BlockId, HouseId, HouseLv, Type, 2]),
            lib_server_send:send_to_uid(AskRoleId, Bin1)
    end,
    %% 将房间内所有玩家踢出房间
    case CopyId of
        0 ->
            skip;
        _ ->
            case mod_scene_agent:apply_call(SceneId, 0, lib_scene_agent, get_scene_user, [CopyId]) of
                false ->
                    skip;
                UserList ->
                    FQ = fun(User) ->
                        #ets_scene_user{
                            id = UserRoleId
                        } = User,
                        lib_player:apply_cast(UserRoleId, ?APPLY_CALL_SAVE, ?NOT_HAND_OFFLINE, lib_house, divorce_quit, [])
                    end,
                    lists:map(FQ, UserList)
            end
    end,
    NewState = State#house_state{
        house_list = NewHouseList,
        aa_list = NewAAList,
        answer_list = NewAnswerList
    },
    {noreply, NewState};

do_handle_cast({login_check, RoleId}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList,
        answer_list = AnswerList
    } = State,
    case lists:keyfind(RoleId, #aa_ask_info.answer_role_id, AAList) of
        false ->
            skip;
        AAInfo ->
            #aa_ask_info{
                home_id = {BlockId1, HouseId1},
                house_lv = HouseLv,
                ask_role_id = AskRoleId1,
                type = Type1,
                answer_cost_list = AnswerCostList1
            } = AAInfo,
            case lists:keyfind({BlockId1, HouseId1}, #house_info.home_id, HouseList) of
                false ->
                    ChooseInsideList = [];
                ChooseHouseInfo ->
                    #house_info{
                        inside_list = ChooseInsideList
                    } = ChooseHouseInfo
            end,
            SendInsideList = [begin
                #furniture_inside_info{
                    goods_type_id = GoodsTypeId
                } = InsideInfo,
                GoodsTypeId
            end||InsideInfo <- lists:sublist(ChooseInsideList, 3)],
            {ok, Bin1} = pt_177:write(17709, [BlockId1, HouseId1, HouseLv, AskRoleId1, Type1, AnswerCostList1, SendInsideList]),
            lib_server_send:send_to_uid(RoleId, Bin1)
    end,
    case lists:keyfind(RoleId, #house_answer_info.ask_role_id, AnswerList) of
        false ->
            skip;
        AnswerInfo ->
            #house_answer_info{
                home_id = {BlockId2, HouseId2},
                house_lv = HouseLv2,
                type = Type2,
                answer_type = AnswerType2
            } = AnswerInfo,
            {ok, Bin2} = pt_177:write(17711, [BlockId2, HouseId2, HouseLv2, Type2, AnswerType2]),
            lib_server_send:send_to_uid(RoleId, Bin2)
    end,
    {noreply, State};

do_handle_cast({open_choose_house, RoleId, BlockId, HouseId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code =?ERRCODE(err177_house_none),
            SendList = [];
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                choose_house = {ChooseBlockId, ChooseHouseId},
                lv = HouseLv,
                inside_list = InsideList
            } = HouseInfo,
            case lists:member(RoleId, [RoleId1, RoleId2]) of
                false ->
                    Code = ?ERRCODE(err177_house_not_own),
                    SendList = [];
                true ->
                    case ChooseBlockId of
                        0 ->
                            Code = ?ERRCODE(err177_house_not_choose),
                            SendList = [];
                        _ ->
                            Code = ?SUCCESS,
                            ChooseHouseInfo = lists:keyfind({ChooseBlockId, ChooseHouseId}, #house_info.home_id, HouseList),
                            #house_info{
                                lv = ChooseLv,
                                inside_list = ChooseInsideList
                            } = ChooseHouseInfo,
                            SendInsideList1 = [begin
                                #furniture_inside_info{
                                    goods_type_id = GoodsTypeId
                                } = InsideInfo,
                                GoodsTypeId
                            end||InsideInfo <- lists:sublist(InsideList, 3)],
                            SendInsideList2 = [begin
                                #furniture_inside_info{
                                    goods_type_id = GoodsTypeId
                                } = InsideInfo,
                                GoodsTypeId
                            end||InsideInfo <- lists:sublist(ChooseInsideList, 3)],
                            SendList = [
                                {BlockId, HouseId, HouseLv, SendInsideList1},
                                {ChooseBlockId, ChooseHouseId, ChooseLv, SendInsideList2}
                            ]
                    end
            end
    end,
    {ok, Bin} = pt_177:write(17716, [Code, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%% 选择房子
do_handle_cast({choose_house, RoleId, BlockId, HouseId, ChooseBlockId1, ChooseHouseId1}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code =?ERRCODE(err177_house_none),
            NewState = State;
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                choose_house = {ChooseBlockId, ChooseHouseId},
                lv = HouseLv
            } = HouseInfo,
            case lists:member(RoleId, [RoleId1, RoleId2]) of
                false ->
                    Code = ?ERRCODE(err177_house_not_own),
                    NewState = State;
                true ->
                    case ChooseBlockId of
                        0 ->
                            Code = ?ERRCODE(err177_house_not_choose),
                            NewState = State;
                        _ ->
                            case lists:member({ChooseBlockId1, ChooseHouseId1}, [{BlockId, HouseId}, {ChooseBlockId, ChooseHouseId}]) of
                                false ->
                                    Code = ?ERRCODE(err177_house_not_choose),
                                    NewState = State;
                                true ->
                                    AskRoleId = case lists:keyfind(RoleId1, #aa_ask_info.ask_role_id, AAList) of
                                        false ->
                                            case lists:keyfind(RoleId2, #aa_ask_info.ask_role_id, AAList) of
                                                false ->
                                                    false;
                                                _ ->
                                                    RoleId2
                                            end;
                                        _ ->
                                            RoleId1
                                    end,
                                    case AskRoleId of
                                        false ->
                                            Code = ?SUCCESS,
                                            case RoleId of
                                                RoleId1 ->
                                                    AnswerRoleId = RoleId2;
                                                _ ->
                                                    AnswerRoleId = RoleId1
                                            end,
                                            NewAAInfo = #aa_ask_info{
                                                home_id = {ChooseBlockId1, ChooseHouseId1},
                                                house_lv = HouseLv,
                                                ask_role_id = RoleId,
                                                answer_role_id = AnswerRoleId,
                                                ask_time = utime:unixtime(),
                                                type = 3
                                            },
                                            lib_house:sql_aa_info(NewAAInfo),
                                            NewAAList = [NewAAInfo|AAList],
                                            NewState = State#house_state{
                                                aa_list = NewAAList
                                            },
                                            case lists:keyfind({ChooseBlockId1, ChooseHouseId1}, #house_info.home_id, HouseList) of
                                                false ->
                                                    ChooseHouseLv = 0,
                                                    ChooseInsideList = [];
                                                ChooseHouseInfo ->
                                                    #house_info{
                                                        lv = ChooseHouseLv,
                                                        inside_list = ChooseInsideList
                                                    } = ChooseHouseInfo
                                            end,
                                            SendInsideList = [begin
                                                                  #furniture_inside_info{
                                                                      goods_type_id = GoodsTypeId
                                                                  } = InsideInfo,
                                                                  GoodsTypeId
                                                              end||InsideInfo <- lists:sublist(ChooseInsideList, 3)],
                                            {ok, Bin1} = pt_177:write(17709, [ChooseBlockId1, ChooseHouseId1, ChooseHouseLv, RoleId, 3, [], SendInsideList]),
                                            lib_server_send:send_to_uid(AnswerRoleId, Bin1);
                                        _ ->
                                            case AskRoleId of
                                                RoleId ->
                                                    Code = ?ERRCODE(err177_house_choose_waiting);
                                                _ ->
                                                    Code = ?ERRCODE(err177_house_answer)
                                            end,
                                            NewState = State
                                    end
                            end
                    end
            end
    end,
    {ok, Bin} = pt_177:write(17717, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({change_text, RoleId, BlockId, HouseId, Text}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code = ?ERRCODE(err177_house_none),
            NewState = State;
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                lock = Lock
            } = HouseInfo,
            case lists:member(RoleId, [RoleId1, RoleId2]) of
                false ->
                    Code = ?ERRCODE(err177_house_not_own),
                    NewState = State;
                true ->
                    case Lock of
                        0 ->
                            Code = ?SUCCESS,
                            NewHouseInfo = HouseInfo#house_info{
                                text = Text
                            },
                            lib_house:sql_house_info(NewHouseInfo),
                            NewHouseList = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, HouseList, NewHouseInfo),
                            NewState = State#house_state{
                                house_list = NewHouseList
                            };
                        _ ->
                            Code = ?ERRCODE(err177_house_lock),
                            NewState = State
                    end
            end
    end,
    {ok, Bin} = pt_177:write(17719, [Code, BlockId, HouseId, Text]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({get_house_furnitureList, RoleId, BlockId, HouseId, ThemeId, FurnitureType}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code = ?ERRCODE(err177_house_none),
            SendFurnitureList = [];
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                furniture_list_1 = FurnitureList1,
                furniture_list_2 = FurnitureList2,
                lock = Lock
            } = HouseInfo,
            case lists:member(RoleId, [RoleId1, RoleId2]) of
                false ->
                    Code = ?ERRCODE(err177_house_not_own),
                    SendFurnitureList = [];
                true ->
                    ThemeCon = data_house:get_house_theme(ThemeId),
                    case Lock of
                        0 ->
                            case ThemeCon of
                                [] ->
                                    Code = ?MISSING_CONFIG,
                                    SendFurnitureList = [];
                                _ ->
                                    Code = ?SUCCESS,
                                    FurnitureList = FurnitureList1 ++ FurnitureList2,
                                    ThemeGoodsTypeIdList = ThemeCon#house_theme_con.furniture_id_list,
                                    F = fun(FurnitureInfo, SendFurnitureList1) ->
                                        #furniture_info{
                                            goods_type_id = GoodsTypeId,
                                            goods_num = GoodsNum,
                                            put_num = PutNum
                                        } = FurnitureInfo,
                                        #house_furniture_con{
                                            furniture_type = FurnitureType1
                                        } = data_house:get_house_furniture_con(GoodsTypeId),
                                        IfRightTheme = lists:member(GoodsTypeId, ThemeGoodsTypeIdList),
                                        if
                                            IfRightTheme =:= false ->
                                                SendFurnitureList1;
                                            FurnitureType1 =/= FurnitureType ->
                                                SendFurnitureList1;
                                            true ->
                                                LessGoodsNum = max(0, (GoodsNum-PutNum)),
                                                case lists:keyfind(GoodsTypeId, 1, SendFurnitureList1) of
                                                    false ->
                                                        [{GoodsTypeId, LessGoodsNum}|SendFurnitureList1];
                                                    {_GoodsTypeId, LessGoodsNum1} ->
                                                        lists:keyreplace(GoodsTypeId, 1, SendFurnitureList1, {GoodsTypeId, LessGoodsNum1+LessGoodsNum})
                                                end
                                        end
                                    end,
                                    SendFurnitureList = lists:foldl(F, [], FurnitureList)
                            end;
                        _ ->
                            Code = ?ERRCODE(err177_house_lock),
                            SendFurnitureList = []
                    end
            end
    end,
    {ok, Bin} = pt_177:write(17720, [Code, BlockId, HouseId, ThemeId, FurnitureType, SendFurnitureList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({get_recommend_house_list, RoleId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    RecommendList = lib_house:get_recommend_house_list(HouseList, RoleId, []),
    lib_offline_api:apply_cast(lib_house, rhl_player_info, [RecommendList, RoleId]),
    {noreply, State};

do_handle_cast({update_name, RoleId, Name, BlockId, HouseId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            NewState = State;
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2
            } = HouseInfo,
            case RoleId of
                RoleId1 ->
                    NewHouseInfo = HouseInfo#house_info{
                        name_1 = Name
                    };
                RoleId2 ->
                    NewHouseInfo = HouseInfo#house_info{
                        name_2 = Name
                    };
                _ ->
                    NewHouseInfo = HouseInfo
            end,
            NewHouseList = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, HouseList, NewHouseInfo),
            NewState = State#house_state{
                house_list = NewHouseList
            }
    end,
    {noreply, NewState};

do_handle_cast({send_gift, BlockId, HouseId, GiftId, WishWord, Args}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    [RoleId, CostKey] = Args,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            Code = ?ERRCODE(err177_house_not_exist),
            NewState = State;
        HouseInfo ->
            #house_info{
                role_id_1 = RoleId1,
                role_id_2 = RoleId2,
                lock = Lock,
                popularity = Popularity,
                gift_log_list = GiftLogList
            } = HouseInfo,
            case Lock of
                0 ->
                    Code = ?SUCCESS,
                    #house_gift_con{
                        goods_list = GoodsList,
                        add_fame = AddFame,
                        add_intimacy = Addintimacy,
                        add_popularity = AddPopularity,
                        counter_id = CounterId,
                        if_send_tv = IfSendTV
                    } = data_house:get_house_gift_con(GiftId),
                    GiftLogInfo = #house_gift_log_info{
                        role_id = RoleId,
                        gift_id = GiftId,
                        wish_word = WishWord,
                        time = utime:unixtime()
                    },
                    {ok, Bin1} = pt_177:write(17725, [?SUCCESS]),
                    lib_server_send:send_to_uid(RoleId1, Bin1),
                    lib_server_send:send_to_uid(RoleId2, Bin1),
                    NewGiftLogList1 = [GiftLogInfo|GiftLogList],
                    NewGiftLogList = lists:sublist(NewGiftLogList1, ?GiftLogMax),
                    NewPopularity = Popularity + AddPopularity,
                    NewHouseInfo = HouseInfo#house_info{
                        popularity = NewPopularity,
                        gift_log_list = NewGiftLogList
                    },
                    lib_house:sql_house_info(NewHouseInfo),
                    NewHouseList = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, HouseList, NewHouseInfo),
                    NewState = State#house_state{
                        house_list = NewHouseList
                    },
                    lib_common_rank_api:reflash_rank_by_home({BlockId, HouseId}, RoleId1, RoleId2, AddPopularity),
                    lib_relationship:update_intimacy_each_one(RoleId, RoleId1, Addintimacy, ?INTIMACY_TYPE_HOUSE_GIFT, []),
                    case RoleId2 of
                        0 ->
                            skip;
                        _ ->
                            lib_relationship:update_intimacy_each_one(RoleId, RoleId2, Addintimacy, ?INTIMACY_TYPE_HOUSE_GIFT, [])
                    end,
                    mod_daily:increment(RoleId, ?MOD_HOUSE, CounterId),
                    lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?NOT_HAND_OFFLINE, lib_flower_api, add_fame, [AddFame, []]),
                    case IfSendTV of
                        0 ->
                            skip;
                        _ ->
                            case RoleId2 of
                                0 ->
                                    Args1 = [RoleId1, GoodsList];
                                _ ->
                                    Args1 = [RoleId1, RoleId2, GoodsList]
                            end,
                            lib_offline_api:apply_cast(lib_house, house_gift_send_tv, [RoleId, Args1])
                    end,
                    lib_log_api:log_house_gift(BlockId, HouseId, RoleId1, RoleId2, RoleId, GiftId, Popularity, NewPopularity);
                _ ->
                    Code = ?ERRCODE(err177_house_lock),
                    NewState = State
            end
    end,
    case Code =:= ?SUCCESS of
        true ->
            lib_consume_data:advance_payment_done(RoleId, CostKey);
        false ->
            lib_consume_data:advance_payment_fail(RoleId, CostKey, [lib_house, send_gift_fail, [RoleId]])
    end,
    {ok, Bin} = pt_177:write(17724, [Code, BlockId, HouseId, GiftId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({get_gift_log, RoleId, BlockId, HouseId}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            {ok, Bin} = pt_177:write(17726, [?ERRCODE(err177_house_not_exist), 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        #house_info{popularity = Popularity, gift_log_list = GiftLogList} ->
            SendList = [begin
                #house_gift_log_info{
                    role_id = RoleId1,
                    gift_id = GiftId,
                    wish_word = WishWord,
                    time = SendTime
                } = GiftLogInfo,
                {RoleId1, GiftId, WishWord, SendTime}
            end||GiftLogInfo <- GiftLogList],
            lib_offline_api:apply_cast(lib_house, get_gift_log, [RoleId, Popularity, SendList])
    end,
    {noreply, State};

do_handle_cast({gm_reflesh_inside_sql}, State) ->
    #house_state{
        house_list = HouseList
    } = State,
    F = fun(HouseInfo, ReplaceStrList1) ->
        #house_info{
            home_id = {BlockId, HouseId},
            inside_list = InsideList
        } = HouseInfo,
        SqlStrList = [begin
            #furniture_inside_info{
                loc_id = LocId,
                goods_id = GoodsId,
                goods_type_id = GoodsTypeId,
                x = X,
                y = Y,
                face = Face,
                map_id = MapId
            } = FurnitureInsideInfo,
            io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)", [LocId, BlockId, HouseId, GoodsId, GoodsTypeId, X, Y, Face, MapId])
        end||FurnitureInsideInfo <- InsideList],
        ReplaceStrList1 ++ SqlStrList
    end,
    ReplaceStrList = lists:foldl(F, [], HouseList),
    F1 = fun() ->
        db:execute(<<"DELETE FROM `house_furniture_location`">>),
        SqlList = ulists:list_to_string(ReplaceStrList, ","),
        ReSql = io_lib:format(?ReplaceHouseFurnitureLocAllSql, [SqlList]),
        db:execute(ReSql)
    end,
    db:transaction(F1),
    {noreply, State};

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

do_handle_info({aa_check_time_out}, State) ->
    #house_state{
        house_list = HouseList,
        aa_list = AAList,
        check_aa_timer = AACheckTimer
    } = State,
    util:cancel_timer(AACheckTimer),
    NowTime = utime:unixtime(),
    F1 = fun(AAInfo, {NewAAList1, DeleteSqlStrList1, NewHouseList1}) ->
        #aa_ask_info{
            home_id = {BlockId, HouseId},
            server_id = ServerId,
            ask_role_id = AskRoleId,
            answer_role_id = AnswerRoleId,
            cost_key = AskCostKey,
            type = Type,
            ask_cost_list = AskCostList,
            ask_time = AskTime
        } = AAInfo,
        case NowTime - AskTime >= ?AALimitTime of
            false ->
                {[AAInfo|NewAAList1], DeleteSqlStrList1, NewHouseList1};
            true ->
                case Type of
                    1 ->
                        NewHouseList2 = NewHouseList1,
                        lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 4);
                    2 ->
                        NewHouseList2 = NewHouseList1,
                        lib_house:house_fail_return(AskRoleId, AskCostKey, AskCostList, 8);
                    _ ->
                        case lists:keyfind({BlockId, HouseId}, #house_info.home_id, NewHouseList1) of
                            false ->
                                NewHouseList2 = NewHouseList1;
                            HouseInfo1 ->
                                Title = ?LAN_MSG(?LAN_TITLE_HOUSE_CHOOSE_TIMEOUT),
                                Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_CHOOSE_TIMEOUT),
                                lib_mail_api:send_sys_mail([AnswerRoleId], Title, Content, []),
                                NewHouseInfo1 = HouseInfo1#house_info{
                                    choose_house = {0, 0}
                                },
                                lib_house:sql_house_info(NewHouseInfo1),
                                NewHouseList2 = lists:keyreplace({BlockId, HouseId}, #house_info.home_id, NewHouseList1, NewHouseInfo1),
                                #house_info{
                                    role_id_1 = RoleId1,
                                    role_id_2 = RoleId2,
                                    home_id = {BlockId1, HouseId1},
                                    lv = HouseLv1
                                } = NewHouseInfo1,
                                lib_house:update_house_info(RoleId1, BlockId1, HouseId1, HouseLv1, {0, 0}),
                                lib_house:update_house_info(RoleId2, BlockId1, HouseId1, HouseLv1, {0, 0})
                        end
                end,
                SqlStr = io_lib:format("(`block_id` = ~p and `house_id` = ~p and `server_id` = ~p)", [BlockId, HouseId, ServerId]),
                {NewAAList1, [SqlStr|DeleteSqlStrList1], NewHouseList2}
        end
    end,
    {NewAAList, DeleteSqlStrList, NewHouseList11} = lists:foldl(F1, {[], [], HouseList}, AAList),
    F2 = fun(HouseInfo1, {HouseInfoSqlStrList1, InsideSqlStrList1, NewHouseList1}) ->
        #house_info{
            home_id = {BlockId, HouseId},
            server_id = ServerId,
            role_id_1 = RoleId1,
            role_id_2 = RoleId2,
            lv = HouseLv,
            lock = Lock,
            marriage_start_lv = MarriageStartLv,
            choose_house = {ChooseBlockId, ChooseHouseId},
            inside_list = InsideList,
            cost_log = CostLog,
            text = Text,
            buy_time = BuyTime,
            popularity = Popularity,
            if_sql = IfSql
        } = HouseInfo1,
        case IfSql of
            0 ->
                {HouseInfoSqlStrList1, InsideSqlStrList1, [HouseInfo1|NewHouseList1]};
            _ ->
                NewHouseInfo1 = HouseInfo1#house_info{
                    if_sql = 0
                },
                SCostLog = util:term_to_string(CostLog),
                SText = util:make_sure_binary(Text),
                SqlStr = io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s', ~p, ~p)",
                    [BlockId, HouseId, ServerId, RoleId1, RoleId2, HouseLv, Lock, MarriageStartLv, ChooseBlockId, ChooseHouseId, SCostLog, SText, BuyTime, Popularity]),
                SqlStrList = [begin
                                  #furniture_inside_info{
                                      loc_id = LocId,
                                      goods_id = GoodsId,
                                      goods_type_id = GoodsTypeId,
                                      x = X,
                                      y = Y,
                                      face = Face,
                                      map_id = MapId
                                  } = FurnitureInsideInfo,
                                  io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)", [LocId, BlockId, HouseId, GoodsId, GoodsTypeId, X, Y, Face, MapId])
                              end||FurnitureInsideInfo <- InsideList],
                case SqlStrList of
                    [] ->
                        NewInsideSqlStrList1 = InsideSqlStrList1;
                    _ ->
                        NewInsideSqlStrList1 = SqlStrList ++ InsideSqlStrList1
                end,
                {[SqlStr|HouseInfoSqlStrList1], NewInsideSqlStrList1, [NewHouseInfo1|NewHouseList1]}
        end
    end,
    {HouseInfoSqlStrList, NewInsideSqlStrList, NewHouseList} = lists:foldl(F2, {[], [], []}, NewHouseList11),
    case DeleteSqlStrList of
        [] ->
            skip;
        _ ->
            SqlList1 = ulists:list_to_string(DeleteSqlStrList, "or"),
            ReSql1 = io_lib:format(?DeleteHouseHouseAAInfoSql, [SqlList1]),
            db:execute(ReSql1)
    end,
    case HouseInfoSqlStrList of
        [] ->
            skip;
        _ ->
            SqlList2 = ulists:list_to_string(HouseInfoSqlStrList, ","),
            ReSql2 = io_lib:format(?ReplaceHouseInfoAllSql, [SqlList2]),
            db:execute(ReSql2)
    end,
    case NewInsideSqlStrList of
        [] ->
            skip;
        _ ->
            SqlList3 = ulists:list_to_string(NewInsideSqlStrList, ","),
            ReSql3 = io_lib:format(?ReplaceHouseFurnitureLocAllSql, [SqlList3]),
            db:execute(ReSql3)
    end,
    NewAACheckTimer = erlang:send_after(?CheckAATime*1000, self(), {aa_check_time_out}),
    NewState = State#house_state{
        house_list = NewHouseList,
        aa_list = NewAAList,
        check_aa_timer = NewAACheckTimer
    },
    {noreply, NewState};

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.