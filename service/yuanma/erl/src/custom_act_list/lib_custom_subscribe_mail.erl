%% ---------------------------------------------------------------------------
%% @doc lib_custom_subscribe_mail

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/4/15
%% @desc    预约邮件奖励（指定渠道登录的就获得奖励）
%% ---------------------------------------------------------------------------
-module(lib_custom_subscribe_mail).

%% API
-export([
    login/1,
    init_data_lv_up/1
]).

-include("common.hrl").
-include("server.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").

login(PS) -> calc_reward_send(PS).

calc_reward_send(PS) ->
    Type = ?CUSTOM_ACT_TYPE_SUBSCRIBE_MAIL,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) ->
        IsLegal = is_legal_source(AccPS, Type, SubType),
        if
            IsLegal ->
                RewardCfgL = get_satisfy_grade_reward_cfg(AccPS, Type, SubType),
                send_reward(AccPS, Type, SubType, RewardCfgL);
            true -> AccPS
        end
        end,
    lists:foldl(F, PS, OpenSubTypeL).

send_reward(PS, _Type, _SubType, []) -> PS;
send_reward(PS, Type, SubType, [RewardCfg|T]) ->
    #custom_act_reward_cfg{condition = Condition, reward = Reward, grade = GradeId} = RewardCfg,
    {_, {TitleId, ContentId}} = ulists:keyfind(mail_id, 1, Condition, {mail_id, {<<>>, <<>>}}),
    Title = utext:get(TitleId),
    Content = utext:get(ContentId),
    lib_mail_api:send_sys_mail([PS#player_status.id], Title, Content, Reward),
    #custom_act_data{data = DataL} = ActData = get_act_data(PS, Type, SubType),
    NewActData = ActData#custom_act_data{data = [GradeId|lists:delete(GradeId, DataL)]},
    NewPS = lib_custom_act:save_act_data_to_player(PS, NewActData),
    send_reward(NewPS, Type, SubType, T).

init_data_lv_up(PS) -> calc_reward_send(PS).

%% 获取满足领取条件的奖励配置
get_satisfy_grade_reward_cfg(PS, Type, SubType) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    GradeIdL = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, AccL) ->
        IsReceived = is_receive_reward(PS, Type, SubType, GradeId),
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{condition = Condition} = Cfg when not IsReceived ->
                {_, NeedLv} = ulists:keyfind(role_lv, 1, Condition, 0),
                case RoleLv >= NeedLv of
                    true -> [Cfg|AccL];
                    _ -> AccL
                end;
            _ -> AccL
        end
    end,
    lists:foldl(F, [], GradeIdL).

%% 是否满足渠道条件
is_legal_source(PS, Type, SubType) ->
    #player_status{source = Source} = PS,
    case lib_custom_act_check:check_act_condition(Type, SubType, [source]) of
        [SourceList] ->
            lists:member(list_to_atom(util:make_sure_list(Source)), SourceList);
        _ -> false
    end.

%% 是否领取了奖励
is_receive_reward(PS, Type, SubType, GradeId) ->
    #custom_act_data{data = Data} = get_act_data(PS, Type, SubType),
    lists:member(GradeId, Data).

%% 获取数据
get_act_data(PS, Type, SubType) ->
    case lib_custom_act:act_data(PS, Type, SubType) of
        #custom_act_data{} = Data -> Data;
        _ -> #custom_act_data{id= {Type, SubType}, type = Type, subtype = SubType, data = []}
    end.
