%%%--------------------------------------
%%% @Module  : lib_custom_act_dynamic_compile
%%% @Author  : xiaoxiang
%%% @Created : 2017-05-12
%%% @Description: 动态生成编译额外定制活动配置文件
%%%--------------------------------------
-module(lib_custom_act_dynamic_compile).

-export([
    dynamic_compile_cfg/0                %% 开服加载本地数据库，并加载到内存
    , dynamic_compile_data_act_extra1/0  %% % 生成erlang文件再编译生成beam文件  路径为logs
    , dynamic_compile_data_act_extra2/0  %% % 动态编译生成binary，再将binary转成list写入beam文件 路径为logs
    ]).

-include("custom_act.hrl").
-include("common.hrl").

-compile(export_all).

dynamic_compile_cfg() ->
    ok = dynamic_compile_data_act(),
    ok.

product_debug_ac_custom_info() ->
    Str = get_data_ac_str(),
    ?INFO("product_debug_custom_act_info:~n", []),
    ?INFO("############################~n", []),
    ?INFO("~s ~n", [Str]),
    ?INFO("############################~n", []).

%% 动态编译成data_custom_act_extra, 并加载到内存
dynamic_compile_data_act() ->
    Str = get_data_ac_str(),
    {Mod, Code} = dynamic_compile:from_string(Str),
    code:load_binary(Mod, "data_custom_act_extra.erl", Code),
    ok.

  %% % 生成erlang文件再编译生成beam文件
dynamic_compile_data_act_extra1() ->
    Str = get_data_ac_str(),
    create_file1(Str),
    c:c("../logs/data_custom_act_extra.erl"),
    ok.

%% 动态编译生成binary，再将binary转成list写入beam文件
dynamic_compile_data_act_extra2() ->
    Str = get_data_ac_str(),
    {_Mod, Code} = dynamic_compile:from_string(Str),
    create_file2(Code),
    ok.

%% data_custom_act_extra
get_data_ac_str() ->
    Module = "-module(data_custom_act_extra).\n",
    Export = "-compile(export_all).\n\n",
    ActCfgStr = make_ac_cfg_str(),
    Module ++ Export ++ ActCfgStr.

make_ac_cfg_str() ->
    ActCfg = db:get_all(io_lib:format(?select_extra_custom_act, [])),
    CfgAcCustomStr = make_record_str(custom_act_cfg, ActCfg),
    RewardCfg = db:get_all(io_lib:format(<<"select `type`, `subtype`, `grade`, `name`, `desc`, `condition`, `format`, `reward` from `extra_custom_act_reward` ">>, [])),
    CfgAcCustomRewardStr = make_record_str(cuscom_act_reward, RewardCfg),
    SwitchCfg = db:get_all(io_lib:format(<<"select `id`, `is_open`  from `extra_custom_act_switch`">>, [])),
    CfgAcCustomSwitchStr = make_record_str(custom_act_switch_cfg, SwitchCfg),
    CfgAcCustomStr ++ CfgAcCustomRewardStr ++ CfgAcCustomSwitchStr.

%% data_custom_act_extra:get_act_info(Type, SubType) -> #custom_act_cfg{} | [].
%% data_custom_act_extra:get_act_subtype(Type) -> [SubType] | [].
%% data_custom_act_extra:get_act_list() -> [{Type, SubType}]|[].
make_record_str(custom_act_cfg, List) ->
    RecordList = [
    #custom_act_cfg{
        type = Type,
        subtype = SubType,
        act_type = ActType,
        show_id = ShowId,
        name = Name,
        desc = Desc,
        open_start_time = OpenStartTime,
        open_end_time = OpenEndTime,
        opday_lim = util:bitstring_to_term(OpdayLim),
        merday_lim = util:bitstring_to_term(MergeDayLim),
        optype = OpType,
        opday = util:bitstring_to_term(OpDay),
        optime = util:bitstring_to_term(OpTime),
        start_time = round(Stime),
        end_time = round(Etime),
        clear_type = ClearType,
        condition = util:bitstring_to_term(Condition)
    }||[Type, SubType, ActType, ShowId, Name, Desc, OpenStartTime, OpenEndTime, OpdayLim, MergeDayLim, OpType, OpDay, OpTime, Stime, Etime, ClearType, Condition]<-List],
    BaseAcList = make_record_str(RecordList, "get_act_info", [#custom_act_cfg.type, #custom_act_cfg.subtype], all),
    AcSubList = make_record_str_by_same_key(RecordList, "get_act_subtype", [#custom_act_cfg.type], #custom_act_cfg.subtype),
    AcList = make_record_str(RecordList, "get_act_list", {#custom_act_cfg.type, #custom_act_cfg.subtype}),
    BaseAcList++AcSubList++AcList;


% db:cuscom_act_reward
%% data_custom_act_extra:cuscom_act_reward(Type, SubType, Grade) -> #custom_act_reward_cfg{} | []
%% data_custom_act_extra:get_reward_id(Type, SubType) -> [Grade|...] | [].
make_record_str(cuscom_act_reward, List) ->
    RecordList = [
        #custom_act_reward_cfg{
            type = Type,
            subtype = SubType,
            grade = Grade,
            format = RewardForm,
            name = Name,
            desc = Desc,
            condition = is_vaild_list(util:bitstring_to_term(Condition)),
            reward = is_vaild_list(util:bitstring_to_term(Reward))
        } || [Type, SubType, Grade, Name, Desc, Condition, RewardForm, Reward] <- List],
    AcRewardList = make_record_str(RecordList, "get_reward_info", [#custom_act_reward_cfg.type, #custom_act_reward_cfg.subtype, #custom_act_reward_cfg.grade], all),
    RewardIdList = make_record_str_by_same_key(RecordList, "get_reward_grade_list", [#custom_act_reward_cfg.type, #custom_act_reward_cfg.subtype], #custom_act_reward_cfg.grade),
    AcRewardList ++ RewardIdList;

% db:custom_act_switch_cfg
%% data_custom_act_extra:get_switch(Id) -> Is_open | 0.
make_record_str(custom_act_switch_cfg, List) ->
    NewList = lists:concat([lists:concat(["get_switch", "(", Id, ") -> ", IsOpen, ";\n"]) || [Id, IsOpen] <- List]),
    RemainderStr = lists:concat(["get_switch", "(_) -> 1.\n\n"]),
    NewList ++ RemainderStr;

make_record_str(_, _) -> "".
%% 生成配置的字符串
%% @param Method string() 方法名
%% @param Input 只能接受列表格式 如 [#ets_mon.xx1, #ets_mon.xx2...] (格式是列表)
%% @param Output 如 [#ets_mon.xx1, #ets_mon.xx2...] | {#ets_mon.xx1, #ets_mon.xx2...} | all | #ets_mon.xx1
%% @return string()
make_record_str(RecordList, Method, Input, Output) ->
    make_record_str(RecordList, Method, Input, length(Input), Output).

is_vaild_list(List) when is_list(List) -> List;
is_vaild_list(_) -> [].

%% 生成配置的字符串
%% @param Method string() 方法名
%% @param Input 只能接受列表格式 如 [#ets_mon.xx1, #ets_mon.xx2...] | #ets_mon.xx1(格式是列表)
%% @param AnyParamLen 参数长度,即Input列表的长度
%% @param Output 如 [#ets_mon.xx1, #ets_mon.xx2...] | {#ets_mon.xx1, #ets_mon.xx2...} | all | #ets_mon.xx1
%% @return string()
make_record_str(RecordList, Method, Input, AnyParamLen, Output) ->
    F = fun(Record) ->
        NewInput = util:record_return_form(Record, Input),
        NewInput2 = make_string_list(NewInput),
        NewInput3 = string:join(NewInput2, ", "),
        NewOut = util:record_return_form(Record, Output),
        NewOut2 = util:term_to_string(NewOut),
        lists:concat([Method, "(", NewInput3, ") -> ", NewOut2, ";\n"])
    end,
    RecordListStr = lists:concat(lists:map(F, RecordList)),
    AnyParamStr = make_any_param_str(AnyParamLen),
    RemainderStr = lists:concat([Method, "(", AnyParamStr, ") -> [].\n\n"]),
    RecordListStr ++ RemainderStr.

make_record_str(RecordList, Method, Output) ->
    F = fun(Record) -> util:record_return_form(Record, Output) end,
    List = lists:map(F, RecordList),
    lists:concat([Method, "() -> ", util:term_to_string(List), ".\n\n"]).

%% 生成Input相同的配置字符串
make_record_str_by_same_key(RecordList, Method, Input, Output) ->
    F = fun(Record, List) ->
        NewInput = util:record_return_form(Record, Input),
        NewOutput = util:record_return_form(Record, Output),
        case lists:keyfind(NewInput, #ac_custom_cfg.id, List) of
            false -> Sub = #ac_custom_cfg{id = NewInput, value = [NewOutput]} ;
            #ac_custom_cfg{value = OldList}=OldSub -> Sub = OldSub#ac_custom_cfg{value = [NewOutput|OldList]}
        end,
       lists:keystore(NewInput, #ac_custom_cfg.id, List, Sub)
    end,
    RecordList2 = lists:foldr(F, [], RecordList),
    AnyParamLen = length(Input),
    make_record_str(RecordList2, Method, #ac_custom_cfg.id, AnyParamLen, #ac_custom_cfg.value).

%% 使列表的参数都变成字符串
make_string_list(List) when is_list(List) ->
    F = fun(T) -> util:term_to_string(T) end,
    lists:map(F, List);
make_string_list(T) ->
    [util:term_to_string(T)].

%% 生成任意参数的字符串
make_any_param_str(AnyParamLen) ->
    F = fun(_) -> "_" end,
    ListStr = lists:map(F, lists:seq(1, AnyParamLen)),
    string:join(ListStr, ", ").


create_file(Str) ->
    {ok, F} = file:open("../logs/create_file" ++ util:term_to_string(calendar:now_to_datetime(os:timestamp())), [write]),
    io:format(F, unicode:characters_to_list(Str), []).


create_file1(Str) ->
    {ok, F} = file:open("../logs/data_custom_act_extra.erl", [write]),
    io:format(F, unicode:characters_to_list(Str), []).

create_file2(Bin) ->
    List = binary_to_list(Bin),
    {ok, F} = file:open("../logs/data_custom_act_extra.beam", [write]),
    io:format(F, List, []).