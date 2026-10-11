%%%--------------------------------------
%%% @Module  : pp_skill
%%% @Author  : zhenghehe
%%% @Created : 2010.07.27
%%% @Description:  技能管理
%%%--------------------------------------
-module(pp_skill).
-export([handle/3]).
-include("common.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("reincarnation.hrl").
-include("attr.hrl").

%% ================================= 职业技能 =================================
%% 学习技能
handle(21001, Status, [SkillId]) ->
    Status1 = lib_skill:upgrade_skill(Status, SkillId),
    lib_skill:get_my_skill_list(Status1),
    {ok, Status1};

%% 获取技能列表
handle(21002, Status, _) ->
    lib_skill:get_my_skill_list(Status);

% %% 技能强化信息
% handle(21003, Status, []) ->
%     lib_skill:send_skill_stren_info(Status);

% %% 技能强化
% handle(21004, Status, [SkillId]) ->
%     lib_skill:stren_skill(Status, SkillId);

% %% 技能一键强化
% handle(21005, Status, []) ->
%     lib_skill:onekey_stren_skill(Status);

%% ================================= 天赋技能 =================================
%% 天赋技能面板
handle(21010, Status, _) ->
    #player_status{sid = Sid, figure = #figure{turn = Turn, lv = Lv}, skill = SkillStatus} = Status,
    if
        Turn < ?DEF_TURN_4 -> skip;
        true ->
            #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
            %% 修正技能点
            NewAllPoint = max(0, Lv-?DEF_TURN_4_LV+?DEF_SKILL_POINT),
            {UsePoint, _Power, TypeSkillList} = lib_skill:get_talent_skill_type_info(SkillTalentList),
            {ok, Bin} = pt_210:write(21010, [max(0, NewAllPoint-UsePoint), TypeSkillList]),
            lib_server_send:send_to_sid(Sid, Bin),
            NewSkillStatus = SkillStatus#status_skill{point = NewAllPoint, use_point = UsePoint},
            {ok, Status#player_status{skill = NewSkillStatus}}
    end;

%% 学习天赋技能
handle(21011, Status, [SkillId]) ->
    #player_status{
        id = RoleId, sid = Sid, figure = #figure{career = Career, turn = Turn},
        battle_attr = BA, skill = SkillStatus} = Status,
    if
        Turn < ?DEF_TURN_4 ->  skip;
        true ->
            #status_skill{skill_talent_list = SkillTalentList, use_point = UsePoint, point = AllPoint} = SkillStatus,
            SkillLv = case lists:keyfind(SkillId, 1, SkillTalentList) of
                false -> 1;
                {_, OSkillLv} -> OSkillLv + 1
            end,
            case lib_skill:check_talent_skill_learn(SkillId, SkillLv, UsePoint, AllPoint, SkillTalentList, Career, Turn) of
                true ->
                    db:execute(io_lib:format(?sql_replace_talent_skill, [RoleId, SkillId, SkillLv])),
                    NewSkillTalentList = lists:keystore(SkillId, 1, SkillTalentList, {SkillId, SkillLv}),
                    %% {TalentAttrMap, TalentOtherMap} = lib_skill:get_passive_skill_attr(NewSkillTalentList),
                    TalentAttr = lib_skill:get_passive_skill_attr(NewSkillTalentList),
                    NewSkillTalentPassive = lib_skill:divide_passive_skill(NewSkillTalentList),
                    {NewUsePoint, Power, _TypeSkillList} = lib_skill:get_talent_skill_type_info(NewSkillTalentList),
                    NewSkillStatus = SkillStatus#status_skill{
                        skill_talent_list = NewSkillTalentList, skill_talent_passive = NewSkillTalentPassive,
                        skill_talent_attr = TalentAttr, use_point = NewUsePoint, skill_power = Power, 
                        skill_talent_sec_attr = lib_skill:get_passive_skill_sec_attr(SkillTalentList)},
                    %% 计算天赋技能对其它功能的属性影响
                    NewPs = Status#player_status{skill = NewSkillStatus},
                    NewPS = lib_player:count_func_attribute(SkillId, SkillLv, NewPs),
                    MountPs = lib_mount_api:talent_skill_update(NewPS, SkillId, SkillLv),
                    NewStatus = lib_player:count_player_attribute(MountPs),
                    #player_status{battle_attr = NBA} = NewStatus,
                    lib_log_api:log_talent_skill(RoleId, 1, SkillId, SkillLv, BA#battle_attr.combat_power,
                        NBA#battle_attr.combat_power, utime:unixtime()),
                    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR),
                    {ok, Bin} = pt_210:write(21011, [1, SkillId, SkillLv, max(0, AllPoint- NewUsePoint)]),
                    lib_server_send:send_to_sid(Sid, Bin),
                    mod_scene_agent:update(NewStatus, [{passive_skill, [{SkillId, SkillLv}]}]),
                    {ok, battle_attr, NewStatus};
                {fail, Code} ->
                    {ok, Bin} = pt_210:write(21011, [Code, 0, 0, 0]),
                    lib_server_send:send_to_sid(Sid, Bin)
            end
    end;

%% 天赋技能重置
handle(21012, Status, _) ->
    % ?PRINT("21012 ~n", []),
    #player_status{id = RoleId, sid = Sid, figure = #figure{turn = Turn}, battle_attr = BA, skill = SkillStatus} = Status,
    #status_skill{skill_talent_list = SkillTalentList, point = AllPoint} = SkillStatus,
    if
        Turn < ?DEF_TURN_4-> skip;
        SkillTalentList == [] ->
            {ok, BinData} = pt_210:write(21012, [?ERRCODE(err210_no_learn_talent_skill), 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            case lib_goods_api:cost_objects_with_auto_buy(Status, [{?TYPE_GOODS, ?TALENT_RESET_GOOD, 1}], talent_skill_reset, "") of
                {false, ErrorCode, NewStatus} ->
                    % ?PRINT("21012 ErrorCode:~p ~n", [ErrorCode]),
                    {ok, BinData} = pt_210:write(21012, [ErrorCode, AllPoint]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewStatus};
                {true, StatusAfCost, _NewObjectList} ->
                    db:execute(io_lib:format(?sql_reset_talent_skill, [RoleId])),
                    NewSkillStatus = SkillStatus#status_skill{
                        use_point = 0, skill_power = 0,
                        skill_talent_list = [], skill_talent_passive = [],
                        skill_talent_attr = #{}, skill_talent_attr_other = #{}, skill_talent_sec_attr = #{}},
                    Ps = StatusAfCost#player_status{skill = NewSkillStatus},
                    MountPs = lib_mount_api:reset_talent(Ps),
                    {ok, Ps1} = lib_goods_util:count_role_equip_attribute(MountPs),
                    PsAfMount = lib_mount:count_mount_attr(Ps1),
                    NewStatus = lib_player:count_player_attribute(PsAfMount),
                    %% 日志
                    #player_status{battle_attr = NBA} = NewStatus,
                    lib_log_api:log_talent_skill(RoleId, 2, 0, 0, BA#battle_attr.combat_power,
                        NBA#battle_attr.combat_power, utime:unixtime()),
                    lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR),
                    {ok, BinData} = pt_210:write(21012, [1, AllPoint]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    mod_scene_agent:update(NewStatus, [{delete_passive_skill, SkillTalentList}]),
                    handle(21010, NewStatus, []),
                    {ok, battle_attr, NewStatus}
            end
    end;

%% 没有匹配
handle(_Cmd, Status, _Data) ->
    ?ERR("no match _cmd:~p, _data:~p~n", [_Cmd, _Data]),
    {ok, Status}.
