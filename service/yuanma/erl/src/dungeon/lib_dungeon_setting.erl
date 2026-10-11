%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_setting.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-09-04
%% @deprecated 副本设置
%% ---------------------------------------------------------------------------
-module(lib_dungeon_setting).
-compile(export_all).

-include("server.hrl").
-include("dungeon.hrl").
-include("sql_dungeon.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("supreme_vip.hrl").
-include("goods.hrl").

-export([check_enter_setting/2, make_setting_data_info/3]).

%% 注意：副本设置进入要自己去检查对应的数据
%% 次数扣除这些

make_record(db_dungeon_setting, [DunKey, Type, SelectType, IsOpen, Count, OtherDataBin]) ->
    case util:bitstring_to_term(OtherDataBin) of
        undefined -> OtherData = [];
        OtherData -> ok
    end,
    #dungeon_setting{dun_key = DunKey, type = Type, select_type = SelectType, is_open = IsOpen, count = Count, other_data = OtherData};
make_record(dungeon_setting, [DunKey, Type, SelectType, IsOpen, Count, OtherData]) ->
    #dungeon_setting{dun_key = DunKey, type = Type, select_type = SelectType, is_open = IsOpen, count = Count, other_data = OtherData}.

%% 获取设置
get_setting_map_from_db(RoleId) ->
    List = db_role_dungeon_setting_select(RoleId),
    F = fun(T, TmpMap) ->
        #dungeon_setting{dun_key = DunKey} = Setting = make_record(db_dungeon_setting, T),
        SettingL = maps:get(DunKey, TmpMap, []),
        maps:put(DunKey, [Setting|SettingL], TmpMap)
    end,
    lists:foldl(F, #{}, List).

%% 发送消息
send_info(Player, DunId) ->
    #player_status{sid = Sid, dungeon = #status_dungeon{setting_map = SettingMap} } = Player,
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    DunKey = lib_dungeon_api:get_setting_dun_key(DunType, DunId),
    List = maps:get(DunKey, SettingMap, []),
    F = fun(#dungeon_setting{type = Type, select_type = SelectType, is_open = IsOpen, count = Count}) ->
        {Type, SelectType, IsOpen, Count}
    end,
    ClientList = lists:map(F, List),
    {ok, BinData} = pt_610:write(61062, [DunId, ClientList]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 开关设置
setting(Player, DunId, Type, SelectType, IsOpen, Count) ->
    % #player_status{id = RoleId, sid = Sid, dungeon = #status_dungeon{setting_map = SettingMap} = StatusDungeon } = Player,
    % DunType = lib_dungeon_api:get_dungeon_type(DunId),
    % DunKey = lib_dungeon_api:get_setting_dun_key(DunType, DunId),
    % case check_setting(Player, DunId, Type, SelectType, IsOpen, Count, DunType, DunKey) of
    %     {false, ErrCode} -> NewPlayer = Player;
    %     true ->
    %         ErrCode = ?SUCCESS,
    %         case maps:get(DunKey, SettingMap, []) of
    %             [] ->
    %                 Setting = make_record(dungeon_setting, [DunKey, Type, SelectType, IsOpen, Count, []]),
    %                 SettingL = [Setting];
    %             OldSettingL ->
    %                 case lists:keyfind(Type, #dungeon_setting.type, OldSettingL) of
    %                     false -> Setting = make_record(dungeon_setting, [DunKey, Type, SelectType, IsOpen, Count, []]);
    %                     OldSetting -> Setting = OldSetting#dungeon_setting{select_type = SelectType, is_open = IsOpen, count = Count}
    %                 end,
    %                 SettingL = lists:keystore(Type, #dungeon_setting.type, OldSettingL, Setting)
    %         end,
    %         db_role_dungeon_setting_replace(RoleId, Setting),
    %         NewSettingMap = maps:put(DunKey, SettingL, SettingMap),
    %         NewPlayer = Player#player_status{dungeon = StatusDungeon#status_dungeon{setting_map = NewSettingMap}}
    % end,
    % % ?MYLOG("hjhhigh", "[ErrCode, DunId, Type, SelectType, IsOpen, Count]:~p ~n",
    % %     [[ErrCode, DunId, Type, SelectType, IsOpen, Count]]),
    % {ok, BinData} = pt_610:write(61063, [ErrCode, DunId, Type, SelectType, IsOpen, Count]),
    % lib_server_send:send_to_sid(Sid, BinData),
    % {ok, NewPlayer}.
    #player_status{id = RoleId, sid = Sid} = Player,
    case slient_setting_with_no_db_help(Player, DunId, Type, SelectType, IsOpen, Count) of
        {false, ErrCode, NewPlayer} -> skip;
        {ok, NewPlayer, Setting} ->
            ErrCode = ?SUCCESS,
            db_role_dungeon_setting_replace(RoleId, Setting)
    end,
    % ?MYLOG("hjhhigh", "[ErrCode, DunId, Type, SelectType, IsOpen, Count]:~p ~n",
    %     [[ErrCode, DunId, Type, SelectType, IsOpen, Count]]),
    {ok, BinData} = pt_610:write(61063, [ErrCode, DunId, Type, SelectType, IsOpen, Count]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

%% 静态设置##有些是根据开关来重新计算数量的,所以不需要存储数据库
slient_setting_with_no_db(Player, DunId, Type, SelectType, IsOpen, Count) ->
    case slient_setting_with_no_db_help(Player, DunId, Type, SelectType, IsOpen, Count) of
        {false, _ErrCode, NewPlayer} -> NewPlayer;
        {ok, NewPlayer, _Setting} -> NewPlayer
    end.

slient_setting_with_no_db_help(Player, DunId, Type, SelectType, IsOpen, Count) ->
    #player_status{dungeon = #status_dungeon{setting_map = SettingMap} = StatusDungeon } = Player,
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    DunKey = lib_dungeon_api:get_setting_dun_key(DunType, DunId),
    case check_setting(Player, DunId, Type, SelectType, IsOpen, Count, DunType, DunKey) of
        {false, ErrCode} -> {false, ErrCode, Player};
        true ->
            case maps:get(DunKey, SettingMap, []) of
                [] ->
                    Setting = make_record(dungeon_setting, [DunKey, Type, SelectType, IsOpen, Count, []]),
                    SettingL = [Setting];
                OldSettingL ->
                    case lists:keyfind(Type, #dungeon_setting.type, OldSettingL) of
                        false -> Setting = make_record(dungeon_setting, [DunKey, Type, SelectType, IsOpen, Count, []]);
                        OldSetting -> Setting = OldSetting#dungeon_setting{select_type = SelectType, is_open = IsOpen, count = Count}
                    end,
                    SettingL = lists:keystore(Type, #dungeon_setting.type, OldSettingL, Setting)
            end,
            NewSettingMap = maps:put(DunKey, SettingL, SettingMap),
            NewPlayer = Player#player_status{dungeon = StatusDungeon#status_dungeon{setting_map = NewSettingMap}},
            {ok, NewPlayer, Setting}
    end.

%% 如果需要特殊处理,可以根据副本类型处理
% 默认检查
check_setting(_Player, _DunId, Type, SelectType, IsOpen, Count, _DunType, DunKey) ->
    BaseSetting = data_dungeon_setting:get_setting(DunKey, Type, SelectType),
    % IsOnDungeon = lib_dungeon:is_on_dungeon(Player),
    if
        IsOpen =/= 0 andalso IsOpen =/= 1 -> {false, ?ERRCODE(err610_setting_open_error)};
        is_record(BaseSetting, base_dungeon_setting) == false -> {false, ?MISSING_CONFIG};
        % 防止过大
        Count >= 999 -> {false, ?ERRCODE(err610_setting_count_error)};
        % 在副本中无法设置(副本中可以设置,只要进入副本,就不能根据玩家身上的设置来取数据,要以副本中的数据)
        % IsOnDungeon -> {false, ?ERRCODE(err610_is_on_dungeon_not_to_setting)};
        true -> true
    end.

%% 检查进入副本的参数
check_enter_setting(Player, #dungeon{id = DunId} = Dun) ->
    SettingL = lib_dungeon_setting:get_setting_list(Player, DunId),
    % ?MYLOG("hjhhigh", "SettingL:~p ~n", [SettingL]),
    do_check_enter_setting(SettingL, Player, Dun, #{}).

%% 这个后面看看优化成通用的
do_check_enter_setting([], Player, #dungeon{type = DunType} = _Dun, BackMap) ->
    Count = maps:get(count, BackMap, 1),
    GoldCost = maps:get(encourage_gold_cost, BackMap, []),
    CoinCost = maps:get(encourage_coin_cost, BackMap, []),
    ExpGoodsCost = maps:get(exp_goods_cost, BackMap, []),
    if
        % 单人经验本不需要根据经验本次数加倍扣除
        DunType == ?DUNGEON_TYPE_EXP_SINGLE -> MoneyCost = GoldCost++CoinCost;
        true -> MoneyCost = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-GoldCost++CoinCost]
    end,
    % ?MYLOG("hjhhigh", "BackMap:~p MoneyCost:~p ExpGoodsCost:~p ~n", [BackMap, MoneyCost, ExpGoodsCost]),
    lib_goods_api:check_object_list(Player, MoneyCost ++ ExpGoodsCost);
do_check_enter_setting([#dungeon_setting{is_open = 0}|T], Player, Dun, BackMap) -> do_check_enter_setting(T, Player, Dun, BackMap);
do_check_enter_setting([#dungeon_setting{type = ?DUNGEON_SETTING_TYPE_MERGE, count = Count}|T], Player, Dun, BackMap) ->
    case Count == 0 of
        true -> {false, ?ERRCODE(err610_merge_count_error)};
        false ->
            case lib_dungeon_check:check_dungeon_count(Dun#dungeon.count_cond, Dun, Count, Player) of
                {false, ErrCode} -> {false, ErrCode};
                true -> do_check_enter_setting(T, Player, Dun, BackMap#{count=>Count})
            end
    end;
do_check_enter_setting([#dungeon_setting{type = ?DUNGEON_SETTING_TYPE_ENCOURAGE_GOLD, count = Count}|T], Player, Dun, BackMap) ->
    #dungeon{id = DunId, type = DunType} = Dun,
    DunKey = lib_dungeon_api:get_setting_encourage_data_dun_key(DunType, DunId),
    case data_dungeon_special:get(DunKey, encourage_data) of
        {_SkillId,GoldCountLimit,_CoinCountLimit,GoldCost,_CoinCost} when Count > 0 ->
            case Count > GoldCountLimit of
                true -> {false, ?ERRCODE(err610_encourage_gold_count_limit)};
                false ->
                    MoneyCost = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-[GoldCost]],
                    do_check_enter_setting(T, Player, Dun, BackMap#{gold_count=>Count, encourage_gold_cost=>MoneyCost})
            end;
        _ ->
            % 不用检查
            do_check_enter_setting(T, Player, Dun, BackMap)
    end;
do_check_enter_setting([#dungeon_setting{dun_key = DunKey, type = Type = ?DUNGEON_SETTING_TYPE_EXP_GOODS, select_type = SelectType}|T], Player, Dun, BackMap) ->
    case data_dungeon_setting:get_setting(DunKey, Type, SelectType) of
        #base_dungeon_setting{cost = Cost} -> do_check_enter_setting(T, Player, Dun, BackMap#{exp_goods_cost=>Cost});
        _ -> do_check_enter_setting(T, Player, Dun, BackMap)
    end;
do_check_enter_setting([#dungeon_setting{type = ?DUNGEON_SETTING_TYPE_ENCOURAGE_COIN, count = Count}|T], Player, Dun, BackMap) ->
    #dungeon{id = DunId, type = DunType} = Dun,
    DunKey = lib_dungeon_api:get_setting_encourage_data_dun_key(DunType, DunId),
    case data_dungeon_special:get(DunKey, encourage_data) of
        {_SkillId,GoldCountLimit,_CoinCountLimit,_GoldCost,CoinCost} when Count > 0 ->
            case Count > GoldCountLimit of
                true -> {false, ?ERRCODE(err610_encourage_coin_count_limit)};
                false ->
                    MoneyCost = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-[CoinCost]],
                    do_check_enter_setting(T, Player, Dun, BackMap#{coin_count=>Count, encourage_coin_cost=>MoneyCost})
            end;
        _ ->
            % 不用检查
            do_check_enter_setting(T, Player, Dun, BackMap)
    end;
do_check_enter_setting([_H|T], Player, Dun, BackMap) ->
    do_check_enter_setting(T, Player, Dun, BackMap).

%% 构造设置数据信息(总的数据)
make_setting_data_info([], #dungeon{type = DunType} = _Dun, BackMap) ->
    % 次数最小为1次
    Count = maps:get(count, BackMap, 1),
    GoldCount = maps:get(gold_count, BackMap, 0),
    GoldCost = maps:get(encourage_gold_cost, BackMap, []),
    CoinCount = maps:get(coin_count, BackMap, 0),
    CoinCost = maps:get(encourage_coin_cost, BackMap, []),
    ExpGoodsCost = maps:get(exp_goods_cost, BackMap, []),
    if
        % 单人经验本不需要根据经验本次数加倍扣除
        DunType == ?DUNGEON_TYPE_EXP_SINGLE -> MoneyCost = GoldCost++CoinCost;
        true -> MoneyCost = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-GoldCost++CoinCost]
    end,
    Cost = lib_goods_api:make_reward_unique(MoneyCost++ExpGoodsCost),
    #{count => Count, gold_count => GoldCount, coin_count => CoinCount, cost => Cost};
make_setting_data_info([#dungeon_setting{is_open = 0}|T], Dun, BackMap) -> make_setting_data_info(T, Dun, BackMap);
make_setting_data_info([#dungeon_setting{type = ?DUNGEON_SETTING_TYPE_MERGE, count = Count}|T], Dun, BackMap) ->
    make_setting_data_info(T, Dun, BackMap#{count=>Count});
make_setting_data_info([#dungeon_setting{type = ?DUNGEON_SETTING_TYPE_ENCOURAGE_GOLD, count = Count}|T], Dun, BackMap) ->
    #dungeon{id = DunId, type = DunType} = Dun,
    DunKey = lib_dungeon_api:get_setting_encourage_data_dun_key(DunType, DunId),
    case data_dungeon_special:get(DunKey, encourage_data) of
        {_SkillId,_GoldCountLimit,_CoinCountLimit,GoldCost,_CoinCost} when Count > 0 ->
            MoneyCost = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-[GoldCost]],
            make_setting_data_info(T, Dun, BackMap#{gold_count=>Count, encourage_gold_cost=>MoneyCost});
        _ ->
            % 不用检查
            make_setting_data_info(T, Dun, BackMap)
    end;
make_setting_data_info([#dungeon_setting{dun_key = DunKey, type = Type = ?DUNGEON_SETTING_TYPE_EXP_GOODS, select_type = SelectType}|T], Dun, BackMap) ->
    case data_dungeon_setting:get_setting(DunKey, Type, SelectType) of
        #base_dungeon_setting{cost = Cost} -> make_setting_data_info(T, Dun, BackMap#{exp_goods_cost=>Cost});
        _ -> make_setting_data_info(T, Dun, BackMap)
    end;
make_setting_data_info([#dungeon_setting{type = ?DUNGEON_SETTING_TYPE_ENCOURAGE_COIN, count = Count}|T], Dun, BackMap) ->
    #dungeon{id = DunId, type = DunType} = Dun,
    DunKey = lib_dungeon_api:get_setting_encourage_data_dun_key(DunType, DunId),
    case data_dungeon_special:get(DunKey, encourage_data) of
        {_SkillId,_GoldCountLimit,_CoinCountLimit,_GoldCost,CoinCost} when Count > 0 ->
            MoneyCost = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-[CoinCost]],
            make_setting_data_info(T, Dun, BackMap#{coin_count=>Count, encourage_coin_cost=>MoneyCost});
        _ ->
            % 不用检查
            make_setting_data_info(T, Dun, BackMap)
    end;
make_setting_data_info([_H|T], Dun, BackMap) ->
    make_setting_data_info(T, Dun, BackMap).

%% 是否开启
is_open(Player, DunId, Type) ->
    #player_status{dungeon = #status_dungeon{setting_map = SettingMap}} = Player,
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    DunKey = lib_dungeon_api:get_setting_dun_key(DunType, DunId),
    SettingL = maps:get(DunKey, SettingMap, []),
    case lists:keyfind(Type, #dungeon_setting.type, SettingL) of
        #dungeon_setting{is_open = 1} -> true;
        _ -> false
    end.

%% 根据副本设置(进入副本初始化)
init_setting_list_for_enter(Player, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = ?DUNGEON_TYPE_EXP_SINGLE} = Dun -> init_setting_list(Player, Dun);
        #dungeon{type = ?DUNGEON_TYPE_HIGH_EXP} = Dun -> init_setting_list(Player, Dun);
        _ -> Player
    end.


init_setting_list(Player, DunId) when is_integer(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{} = Dun -> init_setting_list(Player, Dun);
        _ -> Player
    end;

init_setting_list(Player, #dungeon{type = ?DUNGEON_TYPE_EXP_SINGLE} = Dun) ->
    PlayerAfMerge = init_megre_count(Player, Dun),
    MergeCount = get_megre_count(PlayerAfMerge, Dun),
    Cost = lib_dungeon:calc_real_cost_multi(PlayerAfMerge, Dun, MergeCount),
    #player_status{gold = Gold, bgold = BGold, coin = Coin} = Player,
    StaticBag = #static_bag{gold = Gold, bgold = BGold, coin = Coin},
    #static_bag{gold = LeftGold, bgold = LeftBGold, coin = LeftCoin} = lib_goods_api:calc_static_bag(StaticBag, Cost),
    PlayerAfGold = init_encourage_gold_count(PlayerAfMerge, Dun, LeftGold+LeftBGold),
    PlayerAfCoin = init_encourage_coin_count(PlayerAfGold, Dun, LeftCoin),
    PlayerAfCoin;
init_setting_list(Player, #dungeon{type = ?DUNGEON_TYPE_HIGH_EXP} = Dun) ->
    PlayerAfMerge = init_megre_count(Player, Dun),
    MergeCount = get_megre_count(PlayerAfMerge, Dun),
    Cost = lib_dungeon:calc_real_cost_multi(PlayerAfMerge, Dun, MergeCount),
    #player_status{gold = Gold, bgold = BGold, coin = Coin} = Player,
    StaticBag = #static_bag{gold = Gold, bgold = BGold, coin = Coin},
    #static_bag{gold = LeftGold, bgold = LeftBGold, coin = LeftCoin} = lib_goods_api:calc_static_bag(StaticBag, Cost),
    PlayerAfGold = init_encourage_gold_count(PlayerAfMerge, Dun, LeftGold+LeftBGold),
    PlayerAfCoin = init_encourage_coin_count(PlayerAfGold, Dun, LeftCoin),
    PlayerAfCoin;
init_setting_list(Player, #dungeon{type = ?DUNGEON_TYPE_EQUIP} = Dun) ->
    PlayerAfMerge = init_megre_count(Player, Dun),
    PlayerAfMerge;
init_setting_list(Player, _Dun) ->
    Player.

%% 获得合并次数
get_megre_count(Player, #dungeon{id = DunId}) ->
    Type = ?DUNGEON_SETTING_TYPE_MERGE,
    #player_status{dungeon = #status_dungeon{setting_map = SettingMap}} = Player,
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    DunKey = lib_dungeon_api:get_setting_dun_key(DunType, DunId),
    SettingL = maps:get(DunKey, SettingMap, []),
    case lists:keyfind(Type, #dungeon_setting.type, SettingL) of
        #dungeon_setting{is_open = 1, count = Count} -> Count;
        _ -> 1
    end.

%% 初始化合并次数
init_megre_count(Player, #dungeon{id = DunId} = Dun) ->
    Type = ?DUNGEON_SETTING_TYPE_MERGE, SelectType = 0, IsOpen = 1,
    case is_open(Player, DunId, Type) of
        true ->
            Count = get_max_megre_count(Player, Dun),
            slient_setting_with_no_db(Player, DunId, Type, SelectType, IsOpen, Count);
        false ->
            Player
    end.

%% 初始化鼓舞次数
init_encourage_gold_count(Player, #dungeon{id = DunId, type = DunType}, LeftGold) ->
    Type = ?DUNGEON_SETTING_TYPE_ENCOURAGE_GOLD, SelectType = 0, IsOpen = 1,
    case is_open(Player, DunId, Type) of
        true ->
            DunKey = lib_dungeon_api:get_setting_encourage_data_dun_key(DunType, DunId),
            case data_dungeon_special:get(DunKey, encourage_data) of
                {_SkillId,GoldCountLimit,_CoinCountLimit,{?TYPE_BGOLD, 0, NeedBGold},_CoinCost} when LeftGold > 0 ->
                    Count = LeftGold div NeedBGold,
                    MaxCount = min(Count, GoldCountLimit),
                    slient_setting_with_no_db(Player, DunId, Type, SelectType, IsOpen, MaxCount);
                _ ->
                    slient_setting_with_no_db(Player, DunId, Type, SelectType, 1, 0)
            end;
        false ->
            Player
    end.

%% 初始化鼓舞次数
init_encourage_coin_count(Player, #dungeon{id = DunId, type = DunType}, LeftCoin) ->
    Type = ?DUNGEON_SETTING_TYPE_ENCOURAGE_COIN, SelectType = 0, IsOpen = 1,
    case is_open(Player, DunId, Type) of
        true ->
            DunKey = lib_dungeon_api:get_setting_encourage_data_dun_key(DunType, DunId),
            case data_dungeon_special:get(DunKey, encourage_data) of
                {_SkillId,_GoldCountLimit,CoinCountLimit,_GoldCost,{?TYPE_COIN, 0, NeedCoin}} when LeftCoin > 0 ->
                    Count = LeftCoin div NeedCoin,
                    MaxCount = min(Count, CoinCountLimit),
                    % ?MYLOG("hjhexp", "LeftCoin:~p NeedCoin:~p Count:~p MaxCount:~p ~n", [LeftCoin, NeedCoin, Count, MaxCount]),
                    slient_setting_with_no_db(Player, DunId, Type, SelectType, IsOpen, MaxCount);
                _ ->
                    % ?MYLOG("hjhexp", "LeftCoin:~p Count:~p ~n", [LeftCoin, 0]),
                    slient_setting_with_no_db(Player, DunId, Type, SelectType, 1, 0)
            end;
        false ->
            % ?MYLOG("hjhexp", "LeftCoin:~p Count:~p ~n", [LeftCoin, 0]),
            Player
    end.

get_max_megre_count(Player, Dun) ->
    lib_dungeon:get_daily_left_count(Player, Dun).


%% 获得设置列表
get_setting_list(Player, DunId) ->
    #player_status{dungeon = #status_dungeon{setting_map = SettingMap}} = Player,
    DunType = lib_dungeon_api:get_dungeon_type(DunId),
    DunKey = lib_dungeon_api:get_setting_dun_key(DunType, DunId),
    maps:get(DunKey, SettingMap, []).

db_role_dungeon_setting_select(RoleId) ->
    Sql = io_lib:format(?sql_role_dungeon_setting_select, [RoleId]),
    db:get_all(Sql).

db_role_dungeon_setting_replace(RoleId, Setting) ->
    #dungeon_setting{dun_key = DunKey, type = Type, select_type = SelectType, is_open = IsOpen, count = Count, other_data = OtherData} = Setting,
    Sql = io_lib:format(?sql_role_dungeon_setting_replace, [RoleId, DunKey, Type, SelectType, IsOpen, Count, util:term_to_bitstring(OtherData)]),
    db:execute(Sql).
