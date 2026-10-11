%%%-----------------------------------------------------------------------------
%%%	@Module  : lib_designation
%%% @Author  : liuxl
%%% @Email   : liuxingli@suyougame.com
%%% @Created : 2016-11-21
%%% @Description : 称号系统
%%%-----------------------------------------------------------------------------
-module(lib_designation).
-compile(export_all).
-include("server.hrl").
-include("designation.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_id_create.hrl").
-include("language.hrl").
-include("attr.hrl").

-export([
         get_player_dsgt/1,			%% 获取已获得的称号列表
         change_dsgt/3,				%% 佩戴称号
         hide_dsgt/2,               %% 卸下称号
         use_dsgt_goods/3,			%% 使用称号道具
         get_designation/1,         %% 获取玩家当前佩戴的称号名和id
         active_dsgt/2,             %% 玩家进程调用激活称号
         active_dsgt/3,				%%
         active_dsgt_not_online/2,	%% 玩家不在线时激活称号
         cancel_dsgt/2,				%% 删除称号
         remove_dsgt/2,
         cancel_dsgt_by_id/2,		%%
         update_dsgt_attr/1         %% 统计玩家称号属性
         ,get_dsgt_passive_skill/1  %% 获取玩家称号被动技能
        ]).


%% 获取玩家当前已经激活的称号列表
get_player_dsgt(DsgtStatus) ->
    case maps:to_list(DsgtStatus#dsgt_status.dsgt_map) of
        [] -> {[], []};
        List ->
            NowTime = utime:unixtime(),
            change_to_client_format(List, NowTime, [], [])
    end.

%% 佩戴称号
change_dsgt(DsgtId, UseDsgtId, DsgtStatus) ->
    Now = utime:unixtime(),
    #dsgt_status{player_id = PlayerId, dsgt_map = DsgtMap} = DsgtStatus,
    if
        UseDsgtId == 0 -> NewDsgtMap = DsgtMap;
        true ->
            case maps:find(UseDsgtId, DsgtMap) of
                {ok, SrcDesignation} ->
                    OldDesignation = SrcDesignation#designation{status = ?STATUS_UNUSED, time = Now},
                    lib_designation_util:update_dsgt_state(PlayerId, UseDsgtId, ?STATUS_UNUSED),
                    NewDsgtMap = maps:put(UseDsgtId, OldDesignation, DsgtMap);
                error ->
                    lib_designation_util:delete_dsgt(PlayerId, UseDsgtId),
                    NewDsgtMap = DsgtMap
            end
    end,
    %% 佩戴称号
    {ok, DstDesignation} = maps:find(DsgtId, DsgtMap),
    NewCurDesignation = DstDesignation#designation{status = ?STATUS_USED,  time = Now},
    lib_designation_util:update_dsgt_state(PlayerId, DsgtId, ?STATUS_USED),
    %% 更新玩家称号状态
    NDsgtMap = maps:put(DsgtId, NewCurDesignation, NewDsgtMap),
    DsgtStatus#dsgt_status{dsgt_map = NDsgtMap}.

%% 卸下称号
hide_dsgt(DsgtId, DsgtStatus) ->
    Now = utime:unixtime(),
    #dsgt_status{player_id = PlayerId, dsgt_map = DsgtMap} = DsgtStatus,
    {ok, CurDesignation} = maps:find(DsgtId, DsgtMap),
    NewDesignation = CurDesignation#designation{status = ?STATUS_UNUSED, time = Now},
    lib_designation_util:update_dsgt_state(PlayerId, DsgtId, ?STATUS_UNUSED),
    NewDsgtMap = maps:put(DsgtId, NewDesignation, DsgtMap),
    NewDsgtStatus = DsgtStatus#dsgt_status{dsgt_map = NewDsgtMap},
    NewDsgtStatus.

%% 获取玩家当前佩戴的称号名和id
get_designation(Id) ->
    Sql = io_lib:format(?SQL_DSGT_SEL_USED_ID, [Id]),
    case db:get_row(Sql) of
        [] -> 0;
        [DsgtId] -> DsgtId
    end.

%% 使用称号道具
use_dsgt_goods(Ps, GoodsInfo, _GoodsNum) ->
    Cost = [{GoodsInfo#goods.type, GoodsInfo#goods.goods_id, 1}],
    case data_designation:get_designation_id(Cost) of
        [{_,Id,_}] when Id > 0 ->
            case data_designation:get_by_id(Id) of
                [] ->
                    {fail, ?MISSING_CONFIG, Ps};
                _ ->
                    case active_dsgt(Ps, Id) of
                        {ok, NewPS} ->
                            {ok, NewPS, 1};
                        {add_money, NewPs, SellPrice} ->
                            {use_designtion_good, NewPs, SellPrice, 1};
                        {fail, Err, _NewPS} ->
                            {fail, Err}
                    end
            end;
        _ ->
            {fail, ?MISSING_CONFIG}
    end.

%% ================================= 激活称号 =================================
%% 玩家进程激活称号
%% Id：待激活的称号id
active_dsgt(Ps, #active_para{id = Id} = ActivePara) when is_record(Ps, player_status) ->
    #player_status{sid = Sid} = Ps,
    case data_designation:get_by_id(Id) of
        #base_designation{} = DsgtCfgInfo ->
            case active_dsgt(Ps, DsgtCfgInfo, ActivePara) of
                {true, #designation{end_time = EndTime}, NewPS} ->
                    {ok, BinData} = pt_411:write(41104, [1, Id, EndTime]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewPS};
                {add_money, NewPs, _SellPrice} ->
                    {ok, NewPs};
                {fail, _Errno} ->
                    {ok, Ps}
            end;
        _ ->
            {ok, Ps}
    end;

%% 使用道具激活称号激活称号
active_dsgt(PS, DsgtId) ->
    #player_status{id = PlayerId, sid = Sid} = PS,
    case data_designation:get_by_id(DsgtId) of
        #base_designation{is_global = Global, expire_time = VaildTime} = DsgtCfgInfo->
            RealExpireTime = ?IF(VaildTime == 0, 0, utime:unixtime() + VaildTime),
            if
                Global > 0 ->
                    lib_designation_api:active_global_dsgt(DsgtId, [PlayerId], Global, RealExpireTime),
                    {ok, PS};
                Global == 0 ->
                    case active_dsgt(PS, DsgtCfgInfo, #active_para{id = DsgtId, expire_time=RealExpireTime}) of
                        {true, Designation, NewPS} ->
                            #designation{end_time = EndTime} = Designation,
                            %% 获得称号通知
                            {ok, BinData} = pt_411:write(41104, [1, DsgtId, EndTime]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            {ok, NewPS};
                        {add_money, NewPs, SellPrice} ->
                            {add_money, NewPs, SellPrice};
                        {fail, Errno} ->
                            {fail, Errno, PS}
                    end;
                true ->
                    {fail, ?FAIL, PS}
            end;
        _ ->
            {fail, ?MISSING_CONFIG, PS}
    end.

%% 激活称号
active_dsgt(PS, DsgtCfgInfo, ActivePara) ->
    if
        %% 激活的是有时间限制的称号
        ActivePara#active_para.expire_time > 0 ->
            active_timed_dsgt(PS, DsgtCfgInfo, ActivePara#active_para.expire_time);
        %% 激活的是永久称号
        true ->
            active_permanent_dsgt(PS, DsgtCfgInfo)
    end.

%% 激活有时间限制的称号
%% DsgtCfgInfo：需激活的称号信息#base_designation
active_timed_dsgt(PS, DsgtCfgInfo, ExpireTime) ->
    Now = utime:unixtime(),
    #player_status{id = RoleId, dsgt_status = DsgtStatus} = PS,
    #base_designation{id = Id, is_overlay = IsOverLay} = DsgtCfgInfo,
    DsgtMap = DsgtStatus#dsgt_status.dsgt_map,
    case maps:get(Id, DsgtMap, none) of
        none ->
            active_new_dsgt(PS, DsgtStatus, DsgtCfgInfo, ExpireTime);
        Designation ->
            NewEndTime = case IsOverLay =:= 1 of
                true ->
                    Designation#designation.end_time + DsgtCfgInfo#base_designation.expire_time;
                false ->
                    Now + DsgtCfgInfo#base_designation.expire_time
            end,
            %?PRINT("NewEndTime:~p~n", [NewEndTime]),
            NewDesignation = Designation#designation{active_time = Now, end_time = NewEndTime, time = Now},
            NewDsgtMap = maps:put(Id, NewDesignation, DsgtMap),
            NewDsgtStatus = DsgtStatus#dsgt_status{dsgt_map = NewDsgtMap},
            lib_designation_util:update_dsgt_status(RoleId, NewDesignation),
            log_active_dsgt(?OP_ACTIVE, RoleId, Id, Now, NewEndTime),
            lib_player_record:role_func_check_update(RoleId, designation, {Id, NewEndTime}),
            {true, NewDesignation, PS#player_status{dsgt_status = NewDsgtStatus}}
    end.

%% 激活永久称号
%% DsgtCfgInfo：需激活的称号信息#base_designation
active_permanent_dsgt(PS, DsgtCfgInfo) ->
    #player_status{dsgt_status = DsgtStatus} = PS,
    #base_designation{id = Id} = DsgtCfgInfo,
    DsgtMap = DsgtStatus#dsgt_status.dsgt_map,
    case maps:get(Id, DsgtMap, none) of
        none ->
            active_new_dsgt(PS, DsgtStatus, DsgtCfgInfo, 0);
        _ ->%%称号已经激活就将该称号激活物品出售
            DesignationConInfo = data_designation:get_by_id(Id),
            #base_designation{goods_consume = Cost} = DesignationConInfo,
            GId = case Cost of %%Cost 只有两种形式[{type, goodsid, num}]或者 0
                [{_,GoodsTypeId,_}] -> GoodsTypeId;
                _ -> 0
            end,
            case data_goods:get_goods_sell_price(GId) of
                {0, 0} ->
                    {fail, ?MISSING_CONFIG};
                {SellPriceType, SellPrice} ->
                    case data_goods:get_price_type_to_right(SellPriceType) of
                        none ->
                            {fail, ?MISSING_CONFIG};
                        MoneyType ->
                            NewPs = lib_goods_util:add_money(PS, SellPrice, MoneyType, use_designtion_good, ""),
                            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code({?ERRCODE(err150_user_use_dsgt), [SellPrice]}),
                            {ok, BinData} = pt_110:write(11017, [1, ErrorCodeInt, ErrorCodeArgs]),
                            lib_server_send:send_to_sid(PS#player_status.sid, BinData),
                            {add_money, NewPs, SellPrice}
                    end
            end
    end.

%% 激活新称号
active_new_dsgt(PS, DsgtStatus, DsgtCfgInfo, EndTime) ->
    Now = utime:unixtime(),
    #player_status{id = RoleId, scene = SceneId, x = X, y = Y, sid = Sid,
                   scene_pool_id = SPid, copy_id = CopyId, figure = Figure} = PS,
    {ok, NewPS} = remove_type_dsgt(PS, DsgtCfgInfo),
    #dsgt_status{dsgt_map = DsgtMap, skill_list = OldSkillList} = NewPS#player_status.dsgt_status,
    #base_designation{id = DsgtId} = DsgtCfgInfo,
    ?IF(EndTime =< 0, skip,
        lib_player_record:role_func_check_update(RoleId, designation, {DsgtId, EndTime})),
    
    % %%只有激活第一个才会佩戴！！或者没有佩戴才会将激活的称号佩戴
    % {NFigure, ShouldCast, NDsgt} = if
    %     Figure#figure.designation == 0 ->
    %         %?PRINT("when active UseDsgtId:~p~n",[Figure#figure.designation]),
    %         Dsgt = #designation{id = DsgtId, status = ?STATUS_USED,
    %                 active_time = Now, end_time = EndTime, time = Now, dsgt_order = 1},
    %         NewFigure =  Figure#figure{designation = DsgtId},
    %         {NewFigure, true, Dsgt};
    %     true ->
    %         case maps:get(Figure#figure.designation, DsgtMap, none) of
    %             none ->
    %                 %?PRINT("when active UseDsgtId:~p~n",[Figure#figure.designation]),
    %                 Dsgt = #designation{id = DsgtId, status = ?STATUS_USED,
    %                         active_time = Now, end_time = EndTime, time = Now, dsgt_order = 1},
    %                 NewFigure =  Figure#figure{designation = DsgtId},
    %                 {NewFigure, true, Dsgt};
    %             _OCDsgt ->
    %                 %?PRINT("when active UseDsgtId:~p~n",[Figure#figure.designation]),
    %                 Dsgt = #designation{id = DsgtId, status = ?STATUS_UNUSED,
    %                         active_time = Now, end_time = EndTime, time = Now, dsgt_order = 1},
    %                 {Figure, false, Dsgt}
    %         end
    % end,
    % lib_designation_util:update_dsgt_status(RoleId, NDsgt),
    % NDsgtMap = maps:put(DsgtId, NDsgt, DsgtMap),
    % AttrList = update_dsgt_attr(NDsgtMap),

    %% 激活称号就优先展示那个称号,更新数据库 20220615版本修改为激活时由用户自主选择
    %% NDsgt = #designation{id = DsgtId, status = ?STATUS_USED,
    %%                  active_time = Now, end_time = EndTime, time = Now, dsgt_order = 1},
    %% lib_designation_util:update_dsgt_status(RoleId, NDsgt),
    %% ShouldCast = true, %% 佩戴了就广播
    %% {ok, BinData1} = pt_411:write(41102, [?CODE_OK, DsgtId]),
    %% lib_server_send:send_to_sid(Sid, BinData1),
    %% %% 更新内存
    %% NewDsgtMap = maps:put(DsgtId, NDsgt, DsgtMap),
    %% {AttrList, SkPower, PassivSkill} = update_dsgt_attr(NewDsgtMap),
    %%  mod_scene_agent:update(PS, [{delete_passive_skill, OldSkillList}, {passive_skill, PassivSkill}]),
    %% %% 更新旧的佩戴情况
    %% if
    %%     Figure#figure.designation == 0 -> NDsgtMap = NewDsgtMap;
    %%     true ->
    %%         case maps:get(Figure#figure.designation, NewDsgtMap, none) of
    %%             none -> NDsgtMap = NewDsgtMap;  %%NewDsgtStatus = DsgtStatus#dsgt_status{dsgt_map = NewDsgtMap...
    %%             OCDsgt ->
    %%                 NewDsgt = OCDsgt#designation{status = ?STATUS_UNUSED},
    %%                 lib_designation_util:update_dsgt_state(RoleId, Figure#figure.designation, ?STATUS_UNUSED),
    %%                 NDsgtMap = maps:put(Figure#figure.designation, NewDsgt, NewDsgtMap)
    %%         end
    %% end,
    %% %% 更新属性
    %% NFigure =  Figure#figure{designation = DsgtId},

    %% 20220615版本修改为激活时由用户自主选择
    NDsgt = #designation{id = DsgtId, status = ?STATUS_UNUSED, active_time = Now, end_time = EndTime, time = Now, dsgt_order = 1},
    lib_designation_util:update_dsgt_status(RoleId, NDsgt),
    ShouldCast = false,
    NewDsgtMap = maps:put(DsgtId, NDsgt, DsgtMap),
    {AttrList, SkPower, PassivSkill} = update_dsgt_attr(NewDsgtMap),
    mod_scene_agent:update(PS, [{delete_passive_skill, OldSkillList}, {passive_skill, PassivSkill}]),
    NDsgtMap = NewDsgtMap,
    NFigure = Figure,

    NewDsgtStatus = DsgtStatus#dsgt_status{dsgt_map = NDsgtMap, attr = AttrList, skill_list = PassivSkill, skill_power = SkPower},
    NewPS1 = NewPS#player_status{figure = NFigure, dsgt_status = NewDsgtStatus},
    NewPSCount = lib_player:count_player_attribute(NewPS1),
    %% 更新场景属性
    mod_scene_agent:update(NewPSCount, [{battle_attr, NewPSCount#player_status.battle_attr}, {designation, DsgtId}]),
    %% 广播
    case ShouldCast of
        true ->
            {ok, BinData} = pt_411:write(41105, [RoleId, DsgtId]),
            lib_server_send:send_to_sid(Sid, BinData),
            lib_server_send:send_to_area_scene(SceneId, SPid, CopyId, X, Y, BinData);
        false ->
            skip   
    end,
    lib_player:send_attribute_change_notify(NewPSCount, ?NOTIFY_ATTR),
    %%成就
    DsgtList = maps:to_list(NDsgtMap),
    lib_achievement_api:designation_num(NewPSCount, erlang:length(DsgtList)),
    %% log
    log_active_dsgt(1, RoleId, DsgtId, Now, EndTime),
    {true, NDsgt, NewPSCount}.

%% 玩家不在线时触发的激活称号
%% PlayerId：玩家id;Id：称号Id
active_dsgt_not_online(PlayerId, ActivePara) when PlayerId > 0 ->
    Now = utime:unixtime(),
    #active_para{id = Id, expire_time = ExpireTime} = ActivePara,
    case data_designation:get_by_id(Id) of
        #base_designation{is_overlay = IsOverLay, expire_time = DefExpireTime,
                          name = Name, goods_consume =Cost} ->
            GoodsTypeId = case Cost of
                [{_,GId,_}] -> GId;
                _ -> 0
            end,
            case lib_designation_util:select_dsgt_by_id(PlayerId, Id) of
                [Status, EndTime] when EndTime =/= 0, IsOverLay =:= 0 ->	%% 不能叠加,直接更新
                    lib_achievement_api:outline_designation_num(PlayerId, []),
                    log_active_dsgt(?OP_ACTIVE, PlayerId, Id, Now, ExpireTime),
                    lib_designation_util:update_dsgt_status(PlayerId, Id, Status, Now, ExpireTime);
                [Status, EndTime] when EndTime =/= 0 -> %% 叠加时间
                    NewEndTime = EndTime + DefExpireTime,
                    lib_achievement_api:outline_designation_num(PlayerId, []),
                    log_active_dsgt(?OP_ACTIVE, PlayerId, Id, Now, NewEndTime),
                    lib_designation_util:update_dsgt_status(PlayerId, Id, Status, Now, NewEndTime);
                [] ->
                    % R = #designation{id = Id, status = ?STATUS_UNUSED,
                    remove_type_not_online(PlayerId, Id),
                    R = #designation{id = Id, status = ?STATUS_USED,
                                     active_time = Now, end_time = ExpireTime, time = Now, dsgt_order = 1},
                    lib_achievement_api:outline_designation_num(PlayerId, []),
                    log_active_dsgt(?OP_ACTIVE, PlayerId, Id, Now, ExpireTime),
                    lib_designation_util:update_dsgt_status(PlayerId, R);
                _ ->
                    case data_goods:get_goods_sell_price(GoodsTypeId) of
                        {0, 0} -> skip;
                        {SellPriceType, SellPrice} ->
                            case data_goods:get_price_type_to_goods_type_id(SellPriceType) of
                                none -> skip;
                                MoneyGoodsId ->
                                    Title   = ?LAN_MSG(?LAN_TITLE_ACTIVE_DESIGNATION_OFFLINE),
                                    Content = utext:get(?LAN_CONTENT_ACTIVE_DESIGNATION_OFFLINE, [Name, SellPrice]),
                                    RewardList = [{SellPriceType, MoneyGoodsId, SellPrice}],
                                    lib_mail_api:send_sys_mail([PlayerId], Title, Content, RewardList)
                            end
                    end
            end;
        _ ->
            skip
    end;
active_dsgt_not_online(_, _) -> skip.

%% ================================= 清理称号 =================================
%% 称号结束时效被调用
cancel_dsgt(PS, DsgtId) ->
    Now = utime:unixtime(),
    #player_status{id = PlayerId, dsgt_status = DsgtStatus} = PS,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    case maps:get(DsgtId, DsgtMap, none) of
        #designation{end_time = EndTime} = Designation when EndTime < Now+5 ->
            log_active_dsgt(?OP_REMOVE, PlayerId, DsgtId, Now, 0),
            cancel_dsgt_do(PS, Designation);
        _ ->
            {ok, PS}
    end.

%% 移除称号，不管称号有没有过期
remove_dsgt(PS, DsgtId) ->
    Now = utime:unixtime(),
    #player_status{id = PlayerId, dsgt_status = DsgtStatus} = PS,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    case maps:get(DsgtId, DsgtMap, none) of
        #designation{} = Designation ->
            log_active_dsgt(?OP_REMOVE, PlayerId, DsgtId, Now, 0),
            cancel_dsgt_do(PS, Designation);
        _ ->
            {ok, PS}
    end.

%% 移除称号，不管称号有没有过期
remove_dsgt_list(PS, DsgtIdList) ->
    #player_status{id = PlayerId, dsgt_status = DsgtStatus} = PS,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    Now = utime:unixtime(),
    Fun = fun
        (DsgtId, Acc) when DsgtId =/= 0 ->
            case maps:get(DsgtId, DsgtMap, none) of
                #designation{} = Designation ->
                    log_active_dsgt(?OP_REMOVE, PlayerId, DsgtId, Now, 0),
                    {ok, NewTemPs} = cancel_dsgt_do(Acc, Designation);
                _ ->
                    NewTemPs = Acc
            end,
            NewTemPs;
        (_, Acc) -> Acc
    end,
    NewPS = lists:foldl(Fun, PS, DsgtIdList),
    {ok, NewPS}.

%% 取消配置id的称号：
%% 1：其他玩家激活全局称号时，取消旧玩家的称号
%% 2：玩家激活称号时，先取消玩家身上相斥的称号，如 （战士第一，战士第二）属于相斥称号
cancel_dsgt_by_id(PS, #active_para{id=Id}) ->
    #player_status{id = PlayerId, dsgt_status = DsgtStatus} = PS,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    case maps:get(Id, DsgtMap, none) of
        none -> {ok, PS};
        #designation{end_time = EndTime} = Designation ->
            ?IF(EndTime =< 0, ok,
                lib_player_record:role_func_check_delete_sub_id(PlayerId, designation, Id)),
            lib_designation:log_active_dsgt(2, PlayerId, Id, utime:unixtime(), 0),
            cancel_dsgt_do(PS, Designation)
    end.

%% 移除某类型所有称号
%% DsgtCfgInfo:需要激活的称号配置
%% 类型8的称号，需要先清除所有称号，再激活新称号
remove_type_dsgt(PS, DsgtCfgInfo) ->
    Now = utime:unixtime(),
    #base_designation{id = DsgtId, main_type = MainType} = DsgtCfgInfo,
    if
        MainType == ?ONLYONE_DSGT ->
            List = data_designation:get_dsgt_id_list(MainType),
            Fun = fun(DsId, TemPs) ->
                #player_status{id = PlayerId, dsgt_status = DsgtStatus} = TemPs,
                #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
                case maps:get(DsId, DsgtMap, none) of
                    #designation{} = Designation ->
                        log_active_dsgt(?OP_REMOVE, PlayerId, DsId, Now, 0),
                        {ok, NewTemPs} = cancel_dsgt_do(TemPs, Designation),
                        NewTemPs;
                    _ ->
                        TemPs
                end
            end,
            NewPS = lists:foldl(Fun, PS, lists:delete(DsgtId, List)),
            {ok, NewPS};
        true ->
            {ok, PS}
    end.

remove_type_not_online(PlayerId, DsgtId) ->
    case data_designation:get_by_id(DsgtId) of
        #base_designation{main_type = MainType} ->
            if
                MainType == ?ONLYONE_DSGT ->
                    List = data_designation:get_dsgt_id_list(MainType),
                    Now = utime:unixtime(),
                    Fun = fun(DsId) ->
                        lib_designation_util:delete_dsgt(PlayerId, DsId),
                        lib_designation:log_active_dsgt(?OP_REMOVE, PlayerId, DsId, Now, 0)
                    end,
                    lists:foreach(Fun, lists:delete(DsgtId, List));
                true ->
                    skip
            end;
        _ ->
            skip
    end.

%% 删除称号
cancel_dsgt_do(PS, Designation) ->
    #player_status{id = PlayerId, sid = Sid, dsgt_status = DsgtStatus, figure = Figure,
                   scene = SceneId, scene_pool_id = SPId, copy_id = CopyId, x = X, y = Y} = PS,
    #designation{id = DsgtId} = Designation,
    #dsgt_status{dsgt_map = DsgtMap, skill_list = OldSkillList} = DsgtStatus,
    %% 移除数据库和map的数据
    lib_designation_util:delete_dsgt(PlayerId, DsgtId),
    NewDsgtMap = maps:remove(DsgtId, DsgtMap),
    %% 统计新属性
    {AttrList, SkPower, PassivSkill} = update_dsgt_attr(NewDsgtMap),
    mod_scene_agent:update(PS, [{delete_passive_skill, OldSkillList}, {passive_skill, PassivSkill}]),
    NewDsgtStatus = DsgtStatus#dsgt_status{dsgt_map = NewDsgtMap, attr = AttrList, skill_list = PassivSkill, skill_power = SkPower},
    {ok, BinData} = pt_411:write(41105, [PlayerId, 0]),
    case DsgtId == Figure#figure.designation of
        true -> %% 更新场景显示
            mod_scene_agent:update(PS, [{designation, 0}]),
            lib_server_send:send_to_area_scene(SceneId, SPId, CopyId,  X, Y, BinData),
            NewFigure =  Figure#figure{designation = 0},
            NewPS = PS#player_status{figure = NewFigure, dsgt_status = NewDsgtStatus};
        false ->
            %lib_server_send:send_to_sid(Sid, BinData),
            NewPS = PS#player_status{dsgt_status = NewDsgtStatus}
    end,
    %%通知称号被移除的玩家
    {ok, Data} = pt_411:write(41108, [DsgtId]),
    lib_server_send:send_to_sid(Sid, Data),
    %?PRINT("PlayerId:~p DsgtId:~p removed~n", [PlayerId, DsgtId]),
    %% 更新属性
    NewPSCount = lib_player:count_player_attribute(NewPS),
    mod_scene_agent:update(NewPSCount, [{battle_attr, NewPSCount#player_status.battle_attr}]),
    lib_player:send_attribute_change_notify(NewPSCount, ?NOTIFY_ATTR),
    {ok, NewPSCount}.


%% ================================= 日志 =================================
log_delete_designation_list(PlayerId, DeleteLog) ->
    F = fun({Id, Time}) ->
                log_active_dsgt(2, PlayerId, Id, Time, 0)
        end,
    lists:foreach(F, DeleteLog).

%% Op：1 激活，2 取消
%% OpNow：激活和取消的时间戳
%% EndTime：称号的结束时间戳，只有激活操作有值，取消操作值为0
log_active_dsgt(Op, PlayerId, Id, OpNow, EndTime) ->
    case data_designation:get_by_id(Id) of
        #base_designation{expire_time = ExpireTime, name = Name, main_type = Maintype} ->
            %MarriageDIdList = data_wedding:get_wedding_designation_id_list(),
            %IfDivorce = lists:member(Id, MarriageDIdList),
            %% 称号移除邮件
            if
                %Op =:= 2 andalso IfDivorce ->%不需要婚姻系统
                %    Title   = ?LAN_MSG(?LAN_TITLE_MARRIAGE_DIVORCE_DESIGNATION),
                %    Content = utext:get(?LAN_CONTENT_MARRIAGE_DIVORCE_DESIGNATION, [Name]),
                %    lib_mail_api:send_sys_mail([PlayerId], Title, Content, []);
                Op =:= 2 andalso Maintype =/= 6 ->  %% 圣域称号过期时不发邮件
                    lib_mail_api:send_sys_mail([PlayerId], utext:get(186), utext:get(187, [Name]), []);
                true ->
                    skip
            end,
            lib_log_api:log_active_dsgt(PlayerId, Id, Op, OpNow, ExpireTime, EndTime);
        _ -> skip
    end.



%% ================================= private fun =================================
%% 将获取到的称号列表装换为客户端需要的格式
change_to_client_format([], _NowTime, ReplyList, ExpireList) ->
    {ReplyList, ExpireList};
change_to_client_format([{DsgtId, DR}|T], NowTime, ReplyList, ExpireList) ->
    #designation{end_time = EndTime, dsgt_order = Order} = DR,
    if
        EndTime == 0 orelse EndTime > NowTime->
            change_to_client_format(T, NowTime, [{DsgtId, Order, EndTime}|ReplyList], ExpireList);
        true ->
            change_to_client_format(T, NowTime, ReplyList, [DsgtId|ExpireList])
    end.

%% 统计所有称号属性
%update_dsgt_attr(DstMap) ->
%    List = maps:to_list(DstMap),
%    Fun = fun({_KId, DR}, TAttrList) ->
%                  case data_designation:get_by_id(DR#designation.id) of
%                      #base_designation{attr_list = DefAttr} ->
%                          ulists:kv_list_plus_extra([DefAttr, TAttrList]);
%                      _ ->
%                          TAttrList
%                  end
%          end,
%    lists:foldl(Fun, [], List).

update_dsgt_attr(DstMap) ->
    List = maps:to_list(DstMap),
    Fun = fun({_KId, DR}, {TAttrList, TSkPower, TSkillList}) ->
        case data_designation:get_by_id(DR#designation.id) of
            #base_designation{attr_list = DefAttr1, main_type = MainType, skill_list = SkillList} ->
                DefAttr = case MainType =:= ?GROWUP_DSGT of %%3表示成长称号
                    true ->%%成长类型的称号
                        case data_designation:get_by_id_order(DR#designation.id, DR#designation.dsgt_order) of
                            #base_dsgt_order{attr_list = DefAttr2} -> DefAttr2;
                            _ -> []
                        end; 
                    false ->
                        DefAttr1
                end,
                SkillAttr = lib_skill_api:get_skill_attr2mod(0, SkillList),
                SkPower = lib_skill_api:get_skill_power(SkillList),
                PassivSkill = lib_skill_api:divide_passive_skill(SkillList),
                {ulists:kv_list_plus_extra([DefAttr, SkillAttr, TAttrList]), TSkPower+SkPower, PassivSkill++TSkillList};    
            _ -> {TAttrList, TSkPower, TSkillList}
        end
    end,
    lists:foldl(Fun, {[], 0, []}, List).

%% 获取所有被动技能
get_dsgt_passive_skill(Player) ->
    #player_status{dsgt_status = DsgtStatus} = Player,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    case DsgtStatus of
        #dsgt_status{dsgt_map = DsgtMap} ->
            List = maps:to_list(DsgtMap),
            Fun = fun({_KId, DR}, TSkillList) ->
                case data_designation:get_by_id(DR#designation.id) of
                    #base_designation{skill_list = SkillList} ->
                        PassivSkill = lib_skill_api:divide_passive_skill(SkillList),
                        PassivSkill++TSkillList;    
                    _ -> TSkillList
                end
            end,
            lists:foldl(Fun, [], List);
        _ ->
            []
    end.

%%================================================称号激活、升阶==============================================
check_up_designation_order(DsgtId, DsgtMap) ->
    case maps:get(DsgtId, DsgtMap, none) of
        none -> %%如果客户端使用协议41106发过来的称号id，先查看是否可激活，否则进阶
            DsgtList = data_designation:get_all_designation(),
            case lists:member(DsgtId, DsgtList) of
                true -> {not_active, DsgtId};         %%称号未激活
                false -> {fail, ?MISSING_CONFIG} %%称号不存在
            end;
        #designation{dsgt_order = Order} = Designation ->
            OrderCfg = data_designation:get_by_id_order(DsgtId, Order),
            NextOrderCfg = data_designation:get_by_id_order(DsgtId, Order + 1),
            if
                is_record(OrderCfg, base_dsgt_order) == false ->
                    {fail, ?MISSING_CONFIG};
                is_record(NextOrderCfg, base_dsgt_order) == false ->
                    {fail, ?ERRCODE(err411_dsgt_max_order)};%% 没有配置 ，已达满阶
                true -> {ok, OrderCfg, Designation}
            end
     end. 

up_dsgt(Player, DsgtId) ->
    #player_status{id = RoleId, sid = Sid, dsgt_status = DsgtStatus, combat_power = OldPower} = Player,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    {Code, NewPlayerS} = case check_up_designation_order(DsgtId, DsgtMap) of
        {not_active, DsgtId} ->
            % #base_designation{goods_consume = Cost} = data_designation:get_by_id(DsgtId),%%称号未激活  
            %     case Cost of
            %         [{_,_,_}] -> 
            %             case lib_goods_api:cost_object_list_with_check(Player, Cost, designation_active, "") of
            %                 {true, NewPlayer} ->
            %                     case active_dsgt(NewPlayer, DsgtId) of
            %                         {ok, NewPS} ->
            %                             {ok, NewPS};
            %                         {fail, Errno, NewPS} ->
            %                             {Errno, NewPS}
            %                     end; 
            %                 {false, ErrorCode, NewPlayer} ->
            %                     {ErrorCode, NewPlayer}
            %             end;
            %         _ -> {?MISSING_CONFIG, Player}
            %     end; 
            {?ERRCODE(err411_dsgt_not_active), Player}; 
        {ok, OrderCfg, Designation} ->
            #base_dsgt_order{consume = Cost, dsgt_order = Order} = OrderCfg,
            case lib_goods_api:cost_object_list_with_check(Player, Cost, designation_upgrade_order, "") of %%错误码，后台配置
                {true, NewPlayer} ->
                    do_up_dsgt(NewPlayer, RoleId, DsgtStatus, DsgtId, DsgtMap, Order, Designation, Cost);
                {false, ErrorCode, NewPlayer} -> {ErrorCode, NewPlayer}
            end;
        {fail, ErrorCode} -> {ErrorCode, Player}
    end,
    UsedDsgtId = get_designation(RoleId),
    case is_integer(Code) of
        true -> 
            {ok, BinData} = pt_411:write(41106, [Code, 0, 0, UsedDsgtId, DsgtId]),
            lib_server_send:send_to_sid(Sid, BinData);
        false ->
            skip
    end,
    
    {ok, OldPower, UsedDsgtId, NewPlayerS}.


do_up_dsgt(Player, RoleId, DsgtStatus, DsgtId, DsgtMap, Order, Designation, Cost) ->
    Now = utime:unixtime(),
    %#base_dsgt_order{attr_list = AttrList} = NextOrderCfg,
    NewDesignation =Designation#designation{time = Now, dsgt_order = Order + 1},
    lib_designation_util:update_dsgt_status(RoleId, NewDesignation),                    %%数据库更新
    NewDsgtMap = maps:update(DsgtId, NewDesignation, DsgtMap),                          %%内存更新 
    {NewAttrList, SkPower, PassivSkill} = update_dsgt_attr(NewDsgtMap), 
    NewDsgtStatus = DsgtStatus#dsgt_status{dsgt_map = NewDsgtMap, attr = NewAttrList, skill_power = SkPower, skill_list = PassivSkill},  %%属性更新
    mod_scene_agent:update(Player, [{delete_passive_skill, DsgtStatus#dsgt_status.skill_list}, {passive_skill, PassivSkill}]),
    NewPs = Player#player_status{dsgt_status = NewDsgtStatus},
    NewPSCount = lib_player:count_player_attribute(NewPs),                              %%玩家属性更新,战力也会被更新
    lib_player:send_attribute_change_notify(NewPSCount, ?NOTIFY_ATTR),                  %%通知战力改变
    StrCost = util:term_to_string(Cost),
    lib_log_api:log_dsgt_upgrade_order(RoleId, DsgtId, Order, Order+1, StrCost, Now),   %%更新日志
    
    {ok, NewPSCount}.

%%================================================获取每个称号的战力===================================
get_dsgt_power(PS, DsgtId) ->
    #player_status{sid = Sid, dsgt_status = DsgtStatus, original_attr = SumOAttr} = PS,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    {Errno, Power} = case maps:get(DsgtId, DsgtMap, none) of
        none ->
            do_get_power_dsgt(DsgtId, SumOAttr, false);
        #designation{dsgt_order = Order} ->
            %n阶称号假战力（称号评分）计算
            OrderCfg = data_designation:get_by_id_order(DsgtId, Order),
            if
                is_record(OrderCfg, base_dsgt_order) == false ->
                    do_get_power_dsgt(DsgtId, SumOAttr, true);
                true ->
                    case data_designation:get_by_id(DsgtId) of
                        #base_designation{main_type = MainType} when MainType == ?GROWUP_DSGT ->
                            #base_dsgt_order{attr_list = DsgtAttr} = OrderCfg,
                            NPower = do_get_power(DsgtAttr, SumOAttr, true),
                            {1, NPower};
                        _ ->
                            do_get_power_dsgt(DsgtId, SumOAttr, true)
                    end
            end
    end,
    {ok, BinData} = pt_411:write(41107, [Errno, Power]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, PS}.


do_get_power_dsgt(DsgtId, SumOAttr, IsActive) ->%获得激活1阶称号及未激活称号的假战力
    DsgtCfg = data_designation:get_by_id(DsgtId),
    if
    is_record(DsgtCfg, base_designation) == false ->
        {?MISSING_CONFIG, 0};
    true ->
        #base_designation{attr_list = DsgtAttr} = DsgtCfg,
        NPower = do_get_power(DsgtAttr, SumOAttr, IsActive),
        {1, NPower}
    end.

do_get_power(DsgtAttr, SumOAttr, IsActive) ->%%称号假战力计算 
    if
        IsActive == true ->
            lib_player:calc_partial_power(SumOAttr, 0, DsgtAttr);
        true ->
            lib_player:calc_expact_power(SumOAttr, 0, DsgtAttr)
    end. %%1阶称号假战力计算
    

%%================================================消耗物品激活========================================
active_dsgt_bygoods(Player, DsgtId) ->
    #player_status{id = RoleId, sid = Sid, dsgt_status = DsgtStatus, combat_power = OldPower} = Player,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    {Code, PlayerS} = case maps:get(DsgtId, DsgtMap, none) of
        none -> 
            DsgtList = data_designation:get_all_designation(),
            case lists:member(DsgtId, DsgtList) of
                true -> %%称号未激活
                    #base_designation{goods_consume = Cost} = data_designation:get_by_id(DsgtId),%%称号未激活  
                    case Cost of
                        [{_,_,_}] -> 
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, designation_active, "") of
                                {true, NewPlayer} ->
                                    case active_dsgt(NewPlayer, DsgtId) of
                                        {ok, NewPS} ->
                                            {ok, NewPS};
                                        {fail, Errno, NewPS} ->
                                            {Errno, NewPS}
                                    end; 
                                {false, ErrorCode, NewPlayer} ->
                                    {ErrorCode, NewPlayer}
                            end;
                        _ -> {?MISSING_CONFIG, Player}
                    end;
                false -> {fail, ?MISSING_CONFIG} %%称号不存在
            end;
        _Designation ->
            {?ERRCODE(err411_already_exist),Player}
    end,
    UsedDsgtId = get_designation(RoleId),
    case is_integer(Code) of
        true -> 
            {ok, BinData} = pt_411:write(41109, [Code, 0, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        false ->
            skip
    end, 
    {ok, OldPower, UsedDsgtId, PlayerS}.

         
%%================================================获取可激活、可进阶称号================================ 

% judge(_, [], List) -> List;
% judge(Player, [{_Type, GoodsTypeId, Num}|T], List) ->%%是否有足够的物品
%     [{_CostGTypeId, OwnNum}] = lib_goods_api:get_goods_num(Player, [GoodsTypeId]),
%     if
%         OwnNum >= Num ->
%             GoodsOwn = [{GoodsTypeId, OwnNum}|List],
%             judge(Player, T, GoodsOwn);
%         true ->
%             []
%     end.

%get_dsgt_active(PlayerS) ->%%获得可激活称号列表 
%    #player_status{dsgt_status = DsgtStatus} = PlayerS,
%    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
%    Dsgts = data_designation:get_all_designation(), %%获得所有称号的id 

%    Fun = fun(DsgtId, {ReplyList, CantActiveDsgts}) -> %ReplyList返回激活的称号列表 ,CantActiveDsgts不可激活列表
%        case maps:get(DsgtId, DsgtMap, none) of
%            none ->%%只可以添加未激活的称号
%                #base_designation{goods_consume = Cost, location = Location} = data_designation:get_by_id(DsgtId),
%                GoodsTypeId = case Cost of
%                    [{_,GId,_}] -> GId;
%                    _ -> 0
%                end,
%                [{_CostGTypeId, OwnNum}] = lib_goods_api:get_goods_num(PlayerS, [GoodsTypeId]),    
%                case OwnNum > 0 of
%                    true ->
%                        NewADsgt = [{DsgtId, Location}|ReplyList],
%                        {NewADsgt, CantActiveDsgts};
%                    false ->
%                        NActiveDsgts = [{DsgtId, Location}|CantActiveDsgts],
%                        {ReplyList, NActiveDsgts}
%                end;
%            _ ->%%已激活的称号不做处理
%                {ReplyList, CantActiveDsgts}
%        end    
%    end,
%    {ActiveDsgts, NotAcDsgts} = lists:foldl(Fun, {[], []}, Dsgts),
%    NewAD = lists:keysort(2, ActiveDsgts),%%可激活称号排序
%    NewNAD = lists:keysort(2, NotAcDsgts),%%不可激活称号排序
%    {NewAD, NewNAD}.

% get_dsgt_upgrade(PlayerS) ->%%获得可进阶称号列表
%     #player_status{dsgt_status = DsgtStatus} = PlayerS,
%     #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
%     ActivedDsgts = maps:keys(DsgtMap),%%获取所有已经激活的称号id
%     Fun = fun(DsgtId, ReplyList) ->
%         #base_designation{main_type = MainType, location = Location} = data_designation:get_by_id(DsgtId),
%         case MainType =:= 3 of%%称号分为4大类，3表示成长（可进阶）称号
%             true ->
%                 DsgtOrder = case maps:get(DsgtId, DsgtMap, none) of
%                     none ->
%                         0;
%                     Designation ->
%                         #designation{dsgt_order = Order} = Designation, 
%                         Order
%                 end, 
%                 NeedNum = case data_designation:get_by_id_order(DsgtId, DsgtOrder) of
%                     [] -> [];
%                     #base_dsgt_order{consume = Consume} -> Consume
%                 end,
%                 case judge(PlayerS, NeedNum, []) of
%                     [] -> ReplyList;
%                     _ -> [{DsgtId, Location}|ReplyList]
%                 end;
%             false ->
%                 ReplyList
%         end
%     end,
%     CanUpGradeDsgt = lists:foldl(Fun, [], ActivedDsgts),
%     lists:keysort(2, CanUpGradeDsgt).
    


