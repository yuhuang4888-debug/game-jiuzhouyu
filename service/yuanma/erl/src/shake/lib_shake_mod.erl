%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 22. 四月 2019 20:07
%%%-------------------------------------------------------------------
-module(lib_shake_mod).
-author("whao").


-include("shake.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("counter.hrl").
%% API
-export([
    init/0,
    make_record/2,
    init_shake_record/2,
    shake_add_log/4,
    record_to_list/1
]).


make_record(shake_record, [RoleId, RoleName, GtypeId, GoodsNum, Time]) ->
    #shake_reward_record{
        role_id = RoleId,
        role_name = RoleName,
        gtype_id = GtypeId,
        goods_num = GoodsNum,
        time = Time
    }.


init() ->
    RecordList = db:get_all(io_lib:format(?sql_select_shake_reward_record, [])),
    RecordList1 = init_shake_record(RecordList, []),
    #shake_state{
        record_list = RecordList1
    }.

init_shake_record([], List) -> List;
init_shake_record([T | L], List) ->
    ShakeReward = make_record(shake_record, T),
    init_shake_record(L, [ShakeReward | List]).


%% 记录新的日志
shake_add_log(RoleId, RoleName, RewardList, OldRecordList) ->
    RecordList = add_log_helper(RoleId, RoleName, RewardList, OldRecordList),
    NewRecordList = lists:sublist(RecordList, ?Shake_Record_Len),
    db:execute(io_lib:format(?sql_truncate_shake_reward_record, [])),  % 删除旧数据
    splice_sql(NewRecordList), % 更新数据库
    NewRecordList.



add_log_helper(_RoleId, _RoleName, [], RecordList) ->
    RecordList;
add_log_helper(RoleId, RoleName, [{_, GtypeId, GoodsNum} | L], RecordList) ->
    Time = utime:unixtime(),
    ShakeRecord = make_record(shake_record, [RoleId, RoleName, GtypeId, GoodsNum, Time]),
    add_log_helper(RoleId, RoleName, L, [ShakeRecord | RecordList]).



record_to_list(RecordList) ->
    [{RoleIdTmp, RoleName, GtypeId, GoodsNum, Time} ||
        #shake_reward_record{role_id = RoleIdTmp, role_name = RoleName, gtype_id = GtypeId, goods_num = GoodsNum, time = Time} <- RecordList].


%% 更新数据库
splice_sql([]) -> skip;
splice_sql([RewardRec | Rest]) ->
    #shake_reward_record{role_id = RoleIdTmp, role_name = RoleName, gtype_id = GtypeId, goods_num = GoodsNum, time = Time} = RewardRec,
    ServerNameBin = util:fix_sql_str(RoleName),
    ?PRINT("RoleIdTmp, ServerNameBin, GtypeId, GoodsNum, Time :~w~n",[[RoleIdTmp, ServerNameBin, GtypeId, GoodsNum, Time]]),
    SQL = io_lib:format(?sql_insert_shake_reward_record, [RoleIdTmp, ServerNameBin, GtypeId, GoodsNum, Time]),
    db:execute(SQL),
    splice_sql(Rest).











