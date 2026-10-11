%%-----------------------------------------------------------------------------
%% @Module  :       lib_achievement_api
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-23
%% @Description:    成就API
%%-----------------------------------------------------------------------------
-module(lib_achievement_api).

-include("rec_achievement.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("boss.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("mount.hrl").%% ?MOUNT_ID, ?MATE_ID, ?FLY_ID, ?ARTIFACT_ID, ?HOLYORGAN_ID, ?SPIRIT_ID, ?PET_ID 
-include("rec_event.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("attr.hrl").
-include("equip_suit.hrl").
-include("def_module.hrl").
-include("treasure_hunt.hrl").
-include("arbitrament.hrl").
-include("dungeon.hrl").
-include("def_recharge.hrl").
-include("rec_recharge.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("vip.hrl").
-include("mon_pic.hrl").
-compile(export_all).

gm_clear_achiv() ->
   Sql = io_lib:format(<<"UPDATE `player_special_currency` SET `num`=~p WHERE `currency_id` = ~p">>, [0, ?GOODS_ID_ACHIEVE]),%成就点 40
   db:execute(Sql),
   db:execute("TRUNCATE TABLE `achievement`"),
   db:execute("TRUNCATE TABLE `achievement_star_reward`").

gm_repaire_mon_pic(RoleId) when RoleId =/= 0 ->
    Pid = misc:get_player_process(RoleId),
    case is_pid(Pid) andalso misc:is_process_alive(Pid) of
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_achievement_api, gm_repaire_mon_pic_1, []);
        _ ->
            skip
    end;
gm_repaire_mon_pic(_) ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    Fun = fun(RoleId) ->
        Pid = misc:get_player_process(RoleId),
        case is_pid(Pid) andalso misc:is_process_alive(Pid) of
            true ->
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_achievement_api, gm_repaire_mon_pic_1, []);
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, IdList).

gm_repaire_mon_pic_1(PS) ->
    #player_status{id=RoleId,mon_pic=StatusPic} = PS,
    #status_mon_pic{pic_list=PicList} = StatusPic,
    Fun = fun(#mon_pic{pic_id = TemPicId, lv = TemLv}, {Acc, Sum}) ->
        #base_pic{quality = TemQuality} = data_mon_pic:get_pic(TemPicId),
        case lists:keyfind(TemQuality, 1, Acc) of
            {_, Num} -> {lists:keystore(TemQuality, 1, Acc, {TemQuality, Num + 1}), Sum + TemLv};
            _ -> {lists:keystore(TemQuality, 1, Acc, {TemQuality, 1}), Sum + TemLv}
        end
    end,
    {AchivList, TotalLv} = lists:foldl(Fun, {[], 0}, PicList),
    lib_achievement_api:async_event(RoleId, lib_achievement_api, mon_pic_event, {AchivList, TotalLv}),
    {ok, PS}.

gm_complete_recharge_achv(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_achievement_api, gm_complete_recharge_achv, []);
gm_complete_recharge_achv(Player) when is_record(Player, player_status) ->
    #player_status{figure = #figure{lv = RoleLv}} = Player,
    lib_achievement:trigger(Player, RoleLv, recharge_first, [{recharge_first, 1}]);
gm_complete_recharge_achv(_) -> error_arg.

gm_complete_recharge_achv_1(RoleId, KeyStr, ArgsStr) when is_integer(RoleId) ->
    Key = util:string_to_term(KeyStr),
    Args = util:string_to_term(ArgsStr),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_achievement_api, gm_complete_recharge_achv_1, [Key, Args]);
gm_complete_recharge_achv_1(Player, Key, Args) when is_record(Player, player_status) ->
    #player_status{figure = #figure{lv = RoleLv}} = Player,
    lib_achievement:trigger(Player, RoleLv, Key, Args);
gm_complete_recharge_achv_1(_, _, _) -> error_arg.

%% 功能开启时发协议告诉客户端（等级达到成就开启等级）
% handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP})

get_all_attr(StarRewardL) ->
    % NStarRewardL = lists:reverse(lists:keysort(StarRewardL))
    Stage = get_cur_stage_offline(StarRewardL),
    CurRewardL = lib_achievement:get_attr_reward_list(Stage),
    CurRewardL.

%%！！！！成就等级可以在figure里面读取
%%StarRewardL: [{Star, ?HAS_RECEIVE}|_] 成就阶段
get_cur_stage_offline(StarRewardL) ->
    Fun = fun({_Star, Status}, TemStage) -> 
        case Status == ?HAS_RECEIVE of
            true ->
                TemStage + 1;
            false ->
                TemStage
        end
    end,
    Stage = lists:foldl(Fun, 1, StarRewardL),
    Stage.

get_cur_stage(RoleId) ->
    case lib_achievement:get_achievement_dict(RoleId) of
        {ok, #status_achievement{stage = Stage}} ->
            skip;
        _ ->
            Stage = 0
    end,
    Stage.

get_cur_stage_on_db(RoleId) ->
    List1 = db:get_all(io_lib:format(?select_achievement_star_reward, [RoleId])),  
    StarRewardL =lib_achievement:init_star_reward_list(List1, []),
    % lib_achievement_api:get_cur_stage_offline(StarRewardL).
    get_cur_stage_offline(StarRewardL).

%% 重置玩家成就
gm_reset(PS) ->
    lib_achievement:gm_reset(PS).

%% 异步触发
async_event(PlayerId, M, F, A) when is_integer(PlayerId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, M, F, [A]);
async_event(_PlayerId, _M, _F, _A) -> skip.

%% =================================
%% 成就相关事件
%% =================================

%% 领取成就奖励
get_achv_reward(Player, Id) ->
    lib_task_api:achv_award(Player, Id),
    Player.

%% 成就升阶
achv_stage_up_event(Player, NewStage) ->
    %% 成就
    lib_achievement_api:achv_stage_event(Player, NewStage),
    %% 爵位榜
    lib_common_rank_api:refresh_rank_by_juewei(Player),
    %% 任务
    lib_task_api:achv_lv(Player, NewStage),
    %% 至尊vip
    {ok, SupVipPS} = lib_supreme_vip_api:achv_lv(Player, NewStage),
    SupVipPS.


%%===================================================================
%% 触发成就api
%%===================================================================

%%--------------------------------------------------
%% vip升级
%% @param  PS   description
%% @param  Data 新的vip等级
%% @return      description
%%--------------------------------------------------
vip_lv_up_event(PS, Data) ->
    % ?PRINT("vipData:~p~n", [Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, vip_lv, [{vip_lv, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 玩家升级
%% @param  PS    description
%% @param  _Data 
%% @return       description
%%--------------------------------------------------
lv_up_event(PS, _Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, role_lv, [{role_lv, RoleLv}]),
    {ok, PS}.

%%--------------------------------------------------
%% 玩家转生
%% @param  PS   description
%% @param  Data 新的转生次数
%% @return      description
%%--------------------------------------------------
turn_event(PS, Data) ->
    %?PRINT("role_turn Data:~p~n",[Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, role_turn, [{role_turn, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 激活X个圣裁 圣裁等级达到X
%% @param  PS   description
%% @param  Data ArbitramentList
%% @return      description
%%--------------------------------------------------
upgrade_arbitrament_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    Fun = fun(#arbitrament{lv = Lv}, {Acc, Sum1}) ->
        {Lv+Acc, Sum1+1}
    end,
    {TotalLv, Sum} = lists:foldl(Fun, {0,0}, Data),
    lib_achievement:trigger(PS, RoleLv, upgrade_arbitrament, [{upgrade_arbitrament, TotalLv}]),
    lib_achievement:trigger(PS, RoleLv, active_arbitrament, [{active_arbitrament, Sum}]),
    {ok, PS}.

%%--------------------------------------------------
%% 公会守卫抵御x波
%% @param  PS   description
%% @param  Data ArbitramentList
%% @return      description
%%--------------------------------------------------
guild_guard_event(DunRoleList, Wave) ->
    if
        Wave -1 =< 0 ->
            skip;
        true ->
            Fun = fun(#dungeon_role{id = RoleId}) ->
                lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_guard_role_event, Wave-1)
            end,
            lists:foreach(Fun, DunRoleList)
    end.
    
guild_guard_role_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_guard, [{guild_guard, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 区分成就
%% @param  PS   description
%% @param  Data 新的等级
%% @param  TypeId 升级事件类型（翅膀、坐骑...）
%% @return      description
%%--------------------------------------------------
% ?MOUNT_ID, ?MATE_ID, ?FLY_ID, ?ARTIFACT_ID, ?HOLYORGAN_ID, ?SPIRIT_ID, ?PET_ID 
handle_achievement(TypeId, PS, NewStage, NewStar) ->%%翅膀升级，坐骑升级，宠物等使用同样的代码，这里做一个区分
    % ?PRINT("NewStage:~p,Star:~p~n",[NewStage, NewStar]),
    case TypeId of
        ?FLY_ID ->      wing_lv_up_event(PS, NewStage, NewStar);      %翅膀
        ?MOUNT_ID ->    mount_class_up_event(PS, NewStage, NewStar);  %坐骑
        ?ARTIFACT_ID -> artifact_lv_up_event(PS, NewStar);            %神器
        ?MATE_ID->      mate_class_up_event(PS, NewStage, NewStar);   %伙伴
        ?HOLYORGAN_ID-> holyorgan_lv_up_event(PS, NewStar);           %圣器
        ?SPIRIT_ID->    spirit_class_up_event(PS, NewStar);           %精灵
        % ?PET_ID->       pet_lv_up_event(PS, NewStar);                 %宠物/飞骑
        ?NEW_BACK_DECORATION -> new_back_decoration_lv_up_event(PS, NewStage, NewStar); % 新背饰系统
        _ -> {ok, PS}
    end.

handle_achievement_figure(PS, _) -> {ok, PS}.

handle_achievement_figure(PS, TypeId, Count) ->%%幻化形象成就
    #player_status{figure = Figure, status_mount = _OldStatusMount} = PS,
    #figure{lv = _RoleLv} = Figure,
    case TypeId of
        ?FLY_ID ->      wing_figure_event(PS,Count);      %翅膀
        ?MOUNT_ID ->    mount_figure_event(PS,Count);     %坐骑
        ?ARTIFACT_ID -> artifact_figure_event(PS,Count);  %神器
        ?MATE_ID->      mate_figure_event(PS,Count);      %伙伴
        ?HOLYORGAN_ID-> holyorgan_figure_event(PS,Count); %圣器
        % ?SPIRIT_ID->    spirit_figure_event(PS,FigureId);    %精灵
        ?PET_ID->       pet_figure_event(PS,Count);       %宠物/飞骑
        ?NEW_BACK_DECORATION -> new_back_decoration(PS, Count); %% 新背饰系统
        _ -> {ok, PS}
    end.
    % lib_achievement:trigger(PS, RoleLv, figure_active, [{figure_active, 0}]).
%%--------------------------------------------------
%% 翅膀升阶/幻化
%% @param  PS   description
%% @param  Data 阶数/形象名字
%% @return      description
%%--------------------------------------------------
wing_lv_up_event(PS, Stage, Star) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, wing_star, [{wing_star, Stage, Star}]),
    {ok, PS}.
wing_figure_event(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, wing_name, [{wing_name, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 新背饰系统升阶/幻化
%% @param  PS   description
%% @param  Data 阶数/形象名字
%% @return      description
%%--------------------------------------------------
new_back_decoration_lv_up_event(PS, Stage, Star) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, new_back_decoration_star, [{new_back_decoration_star, Stage, Star}]),
    {ok, PS}.
new_back_decoration(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, new_back_decoration_name, [{new_back_decoration_name, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 圣器强化/幻化
%% @param  PS   description
%% @param  Data 圣器强化总等级/形象名字
%% @return      description
%%--------------------------------------------------
holyorgan_lv_up_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, holyorgan_lv, [{holyorgan_lv, Data}]),
    {ok, PS}.
holyorgan_figure_event(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, holyorgan_name, [{holyorgan_name, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 神器强化/幻化
%% @param  PS   description
%% @param  Data 神器强化总等级/形象名字
%% @return      description
%%--------------------------------------------------
artifact_lv_up_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, artifact_lv, [{artifact_lv, Data}]),
    {ok, PS}.
artifact_figure_event(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, artifact_name, [{artifact_name, Data}]),
    {ok, PS}.
%%--------------------------------------------------
%% 坐骑升阶/幻化
%% @param  PS   description
%% @param  Data 新的阶数/形象名字
%% @return      description
%%--------------------------------------------------
mount_class_up_event(PS, Stage, Star) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, mount_stage, [{mount_stage, Stage, Star}]),
    {ok, PS}.
mount_figure_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, mount_name, [{mount_name, Data}]),
    {ok, PS}.
%%--------------------------------------------------
%% 伙伴升阶/幻化
%% @param  PS   description
%% @param  Data 新的阶数/形象名字
%% @return      description
%%--------------------------------------------------
mate_class_up_event(PS, Stage, Star) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, mate_stage, [{mate_stage, Stage, Star}]),
    {ok, PS}.
mate_figure_event(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, mate_name, [{mate_name, Data}]),
    {ok, PS}.
%%--------------------------------------------------
%% 精灵升级/幻化
%% @param  PS   description
%% @param  Data 新的等级/[{Stage, Num}]/形象名字
%% @return      description
%%--------------------------------------------------
spirit_class_up_event(PS, Data) ->
    %?PRINT("spirit Data:~p~n",[Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, spirit_stage, [{spirit_stage, Data}]),
    {ok, PS}.
spirit_stage_event(PS, Data) ->%%[{Stage, Num}]
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, spirit_stage_up, [{spirit_stage_up, Data}]),
    {ok, PS}.
spirit_figure_event(PS, Data) -> %% Num
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, spirit_figure, [{spirit_figure, Data}]),
    {ok, PS}.
% spirit_figure_event(PS,Data) ->
%     #player_status{figure = Figure} = PS,
%     #figure{lv = RoleLv} = Figure,
%     lib_achievement:trigger(PS, RoleLv, spirit_name, [{spirit_name, Data}]),
%     {ok, PS}.
%%--------------------------------------------------
%% 宠物升级/幻化
%% @param  PS   description
%% @param  Data 新的等级/形象名字
%% @return      description
%%--------------------------------------------------
pet_lv_up_event(PS, Data) -> %[#mount_figure{}]
    Fun = fun(#mount_figure{stage = Stage}, TSum) ->
        TSum + Stage
    end,
    Sum = lists:foldl(Fun, 0, Data),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, pet_lv, [{pet_lv, Sum}]),
    {ok, PS}.
pet_figure_event(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, pet_name, [{pet_name, Data}]),
    {ok, PS}.
%%--------------------------------------------------
%% 装备强化
%% @param  PS   description
%% @param  Data 装备全身强化总等级                    
%% @return      description
%%--------------------------------------------------
equip_stren_event(PS, Data) ->
    %?PRINT("StrenLv: ~p~n",[Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    %?PRINT("Total Stren Lv:~p~n",[Data]),
    lib_achievement:trigger(PS, RoleLv, equip_stren, [{equip_stren, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 装备精炼
%% @param  PS   description
%% @param  Data 装备全身精炼总等级                    
%% @return      description
%%--------------------------------------------------
equip_refine_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    %?PRINT("Total Refine Lv:~p~n",[Data]),
    lib_achievement:trigger(PS, RoleLv, equip_refine, [{equip_refine, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 装备镶嵌宝石
%% @param  PS   description
%% @param  Data 装备全身镶嵌宝石总等级                    
%% @return      description
%%--------------------------------------------------
equip_stone_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    %?PRINT("Total Stone Lv:~p~n",[Data]),
    lib_achievement:trigger(PS, RoleLv, equip_stone, [{equip_stone, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 镶嵌X个Y级宝石
%% @param  PS   description
%% @param  Data 装备全身镶嵌宝石总等级                    
%% @return      description
%%--------------------------------------------------
equip_stone_lv_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, stone_lv, [{stone_lv, Data}]),
    {ok, PS}.
%%--------------------------------------------------
%% 装备洗练
%% @param  PS   description
%% @param  Data [{Color, Num}]
%% @return      description
%%--------------------------------------------------
equip_wash_event(PS, Data) ->
    % ?PRINT("Data:~p~n",[Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    Fun = fun({Color, Num},{Green,Blue,Purple,Orange,Red}) ->
        if
            Color == 1 ->
                {Green+Num, Blue, Purple, Orange, Red};
            Color == 2 ->
                {Green+Num, Blue+Num, Purple, Orange, Red};
            Color == 3 ->
                {Green+Num, Blue+Num, Purple+Num, Orange, Red};
            Color == 4 ->
                {Green+Num, Blue+Num, Purple+Num, Orange+Num, Red};
            Color == 5 ->
                {Green+Num, Blue+Num, Purple+Num, Orange+Num, Red+Num};
            true ->
                {Green,Blue,Purple,Orange,Red}
        end
    end,
    {NewG, NewB, NewP, NewO, NewR} = lists:foldl(Fun, {0,0,0,0,0}, Data),
    % ?PRINT("{NewG, NewB, NewP, NewO, NewR}:~p~n",[{NewG, NewB, NewP, NewO, NewR}]),
    equip_wash_event_help(PS, RoleLv, attr_color_green,  NewG),
    equip_wash_event_help(PS, RoleLv, attr_color_blue,   NewB),
    equip_wash_event_help(PS, RoleLv, attr_color_purple, NewP),
    equip_wash_event_help(PS, RoleLv, attr_color_orange, NewO),
    equip_wash_event_help(PS, RoleLv, attr_color_red,    NewR),
    {ok, PS}.                               
equip_wash_event_help(PS, RoleLv, Key, Num) ->  
    if
        Num =/= 0 ->
            lib_achievement:trigger(PS, RoleLv, Key, [{Key, Num}]);
        true ->
            skip       
    end.
                                     
%%--------------------------------------------------
%% 勋章升级
%% @param  PS   description
%% @param  Data 新的勋章lv
%% @return      description
%%--------------------------------------------------
medal_lv_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, medal_lv, [{medal_lv, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 主线副本通关第几层
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
pass_enchantment_dun_event(PS, _Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    Level = lib_enchantment_guard:get_dungeon_level(PS),
    lib_achievement:trigger(PS, RoleLv, dungeon_enchantment_floor, [{dungeon_enchantment_floor, Level}]),
    {ok, PS}.

%%--------------------------------------------------
%% 加入公会
%% @param  PS   description
%% @param  Data 公会id，不需要使用
%% @return      description
%%--------------------------------------------------
handle_event(RoleId, #event_callback{type_id = ?EVENT_JOIN_GUILD, data = Data}) when is_integer(RoleId)->
    lib_achievement:outline_trigger(RoleId, join_guild, [{join_guild, Data}]);
handle_event(PS, #event_callback{type_id = ?EVENT_JOIN_GUILD, data = Data}) when is_record(PS, player_status)->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, join_guild, [{join_guild, Data}]),
    {ok, PS};
%%--------------------------------------------------
%% 战力提升
%% @param  PS   description
%% @param  Data 历史最高战力
%% @return      description 
%%--------------------------------------------------
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
    #player_status{figure = Figure,hightest_combat_power = HightestCombat} = Player,
     #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(Player, RoleLv, combat, [{combat, HightestCombat}]),
    {ok, Player};

%% 功能开启时发协议告诉客户端
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{id = RoleId, figure = Figure} = PS,
    OpenLv = lib_module:get_open_lv(?MOD_ACHIEVEMENT, 1),
    case Figure#figure.lv == OpenLv of
        true ->
            lib_achievement:send_achievement_list(RoleId);
        false ->
            skip
    end,
    {ok, PS};

%%--------------------------------------------------
%% 首充
%% @param  PS   description
%% @param  Data 1
%% @return      description
%%--------------------------------------------------
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = CallBackData}) ->
    #player_status{figure = Figure} = Player,
    #role_vip{vip_lv = VipLv} = Player#player_status.vip,
    #figure{lv = RoleLv} = Figure,
    case CallBackData of
        #callback_recharge_data{recharge_product = Product} ->
            case lib_recharge_api:is_trigger_recharge_act(Product) of
                true ->
                    lib_achievement:trigger(Player, RoleLv, recharge_first, [{recharge_first, 1}]),
                    lib_achievement:trigger(Player, RoleLv, vip_lv, [{vip_lv, VipLv}]);
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = #{attersign := AtterSign, atter := Atter}}) ->
    #battle_return_atter{id = AttId} = Atter,
    case AtterSign == ?BATTLE_SIGN_PLAYER of
        true ->
            lib_achievement_api:async_event(AttId, lib_achievement_api, kill_player_num_event, 1);
        _ ->
            skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    #player_status{id = RoleId, figure = #figure{turn = Turn}, status_mount = StatusMount} = Player,
    %% 1. 装备穿戴情况重新触发
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(RoleId, GoodsDict),
    [catch wear_equip_event(Player, GoodsTypeId, EquipType, Color)
        ||#goods{goods_id = GoodsTypeId, equip_type = EquipType, color = Color}<-EquipList],
    %% 2. 坐骑幻化重新触发
    [
        catch handle_achievement_figure(Player, TypeId, length(FigureList))
        ||#status_mount{figure_list = FigureList, type_id = TypeId}<- StatusMount
    ],
    %% 3.玩家转生次数重新触发
    catch turn_event(Player, Turn),
    %% TODO 后续有待补充
    {ok, Player};

handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.

%%--------------------------------------------------
%% 击败X名玩家
%% @param  PS   description
%% @param  Data 1
%% @return      description
%%--------------------------------------------------
kill_player_num_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, kill_player_num, [{kill_player_num, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 公会捐献
%% @param  PS   description
%% @param  Data 公会捐献次数,捐献分3类计数，所以这个数据没用
%% @return      description
%%--------------------------------------------------
guild_donate_event(PS, Data) ->
    % ?PRINT("Data guildDonate:~p~n", [Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_donate, [{guild_donate, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 公会答题答对次数
%% @param  PS   description
%% @param  Data 答对次数
%% @return      description
%%--------------------------------------------------
guild_quiz_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_quiz_correct, [{guild_quiz_correct, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计登陆
%% @param  PS   description
%% @param  Data 1
%% @return      description
%%--------------------------------------------------
login_count_event(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, login_days, [{login_days, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 竞技排名达到前多少名
%% @param  PS   description
%% @param  Data 当前排名
%% @return      description
%%--------------------------------------------------
participate_jjc_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, jjc_rank, [{jjc_rank, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 战力榜排名
%% @param  PS   description
%% @param  Data 排名
%% @return      description
%%--------------------------------------------------
participate_combat_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, combat_rank, [{combat_rank, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 爬塔副本
%% @param  PS   description
%% @param  Data  ?DUNGEON_TYPE_TOWER
%% @return      description
%%--------------------------------------------------
dungeon_tower_floor(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    Floor = lib_dungeon_tower:get_dungeon_level(PS, Data),
    lib_achievement:trigger(PS, RoleLv, tower_floor, [{tower_floor, Floor}]),
    {ok, PS}.
%%--------------------------------------------------
%% 情侣副本
%% @param  PS   description
%% @param  Data  _
%% @return      description
%%--------------------------------------------------
dungeon_cuple_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, cuple_pass, [{cuple_pass, Data}]),
    {ok, PS}.
%%--------------------------------------------------
%% 爵位
%% @param  PS   description
%% @param  Data  爵位lv
%% @return      description
%%--------------------------------------------------
juewei_lv_up(PS,Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, juewei_lv, [{juewei_lv, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 获得称号数量
%% @param  PS   description
%% @param  Data  []
%% @return      description
%%--------------------------------------------------
designation_num(PS, Data) when is_record(PS, player_status) -> %%在线版
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, number_designation, [{number_designation, Data}]),
    {ok, PS}.
outline_designation_num(RoleId, Data) when is_integer(RoleId) -> %%离线版
    lib_achievement:outline_trigger(RoleId, number_designation, [{number_designation, Data}]),
    skip.

%% ================================= 其他 =================================
%% 击杀boss成就触发
boss_achv_finish(PS, BossType, BossId)->
    BossLv = lib_boss_api:get_boss_lv(BossId),
    if
        % BossType == ?BOSS_TYPE_WORLD     -> world_boss_event(PS, BossLv);
        % BossType == ?BOSS_TYPE_HOME      -> boss_home_event(PS, BossLv);
        BossType == ?BOSS_TYPE_PHANTOM     -> boss_phantom_event(PS, BossLv); %10
        BossType == ?BOSS_TYPE_FORBIDDEN   -> boss_forbidden_event(PS, BossLv); %4
        % BossType == ?BOSS_TYPE_SPECIAL     -> boss_outside_event(PS, BossLv);   %13
        BossType == ?BOSS_TYPE_NEW_OUTSIDE -> boss_outside_event(PS, BossLv);   %12
        BossType == ?BOSS_TYPE_ABYSS       -> boss_abyss_event(PS, BossLv);     %7
        BossType == ?BOSS_TYPE_FAIRYLAND   -> boss_fairy_event(PS, BossLv);                                   
        true -> {ok, PS}
    end.
%%--------------------------------------------------
%% 击杀世界boss
%% @param  PS   description
%% @param  Data BossLv
%% @return      description
%%--------------------------------------------------
world_boss_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, world_boss, [{kill_world_boss, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀boss之家中boss
%% @param  PS   description
%% @param  Data BossLv
%% @return      description
%%--------------------------------------------------
boss_home_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, boss_home, [{kill_boss_home, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀幻兽之域boss
%% @param  PS   description
%% @param  Data BossLv
%% @return      description
%%--------------------------------------------------
eudemons_boss_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, ai_boss, [{kill_eudemons_boss, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀秘境boss
%% @param  PS   description
%% @param  Data BossLv
%% @return      description
%%--------------------------------------------------
boss_fairy_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, fairyland_num, [{fairyland_num, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀深渊boss
%% @param  PS   description
%% @param  Data BossLv
%% @return      description
%%--------------------------------------------------
boss_abyss_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, abyss_boss, [{abyss_boss, Data}]),
    lib_achievement:trigger(PS, RoleLv, abyss_num, [{abyss_num, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀蛮荒禁地boss
%% @param  PS   description
%% @param  Data BossLv
%% @return      description
%%--------------------------------------------------
boss_forbidden_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, forbidden_boss, [{forbidden_boss, Data}]),
    lib_achievement:trigger(PS, RoleLv, forbidden_num, [{forbidden_num, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀野外boss
%% @param  PS   description
%% @param  Data BossLv
%% @return      description
%%--------------------------------------------------
boss_outside_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, outside_boss, [{outside_boss, Data}]),
    lib_achievement:trigger(PS, RoleLv, outside_num, [{outside_num, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀幻饰boss
%% @param  PS   description
%% @param  Data BossId
%% @return      {ok, PS}DECORATION
%%--------------------------------------------------
boss_decoration_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, decoration_num, [{decoration_num, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀个人boss
%% @param  PS   description
%% @param  Data DunId
%% @return      description
%%--------------------------------------------------
boss_personal_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, personal_boss, [{personal_boss, Data}]),
    lib_achievement:trigger(PS, RoleLv, personal_num, [{personal_num, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀圣兽岭boss
%% @param  PS   description
%% @param  Data DunId
%% @return      description
%%--------------------------------------------------
boss_phantom_event(PS, BossLv) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, phantom_boss, [{phantom_boss, BossLv}]),
    lib_achievement:trigger(PS, RoleLv, phantom_num, [{phantom_num, BossLv}]),
    {ok, PS}.
%%--------------------------------------------------
%% 激活怪物图鉴
%% @param  PS   description
%% @param  Data Quality
%% @return      description
%%--------------------------------------------------
active_mon_pic(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    case Data of
        3 -> %%紫色
            lib_achievement:trigger(PS, RoleLv, purple_pic, [{purple_pic, Data}]);
        4 -> %%橙色
            lib_achievement:trigger(PS, RoleLv, orange_pic, [{orange_pic, Data}]);
        5 -> %%红色
            lib_achievement:trigger(PS, RoleLv, red_pic, [{red_pic, Data}]);
        _ ->
            skip
    end,
    % lib_achievement:trigger(PS, RoleLv, mon_pic, [{mon_pic, Quality},{number, 0}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计激活X个Y品质图鉴
%% @param  PS   description
%% @param  Data {AchivList, TotalLv}  AchivList = [{Quality,Num}...]
%% @return      description
%%--------------------------------------------------
mon_pic_event(PS, {AchivList, TotalLv}) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, mon_pic, [{mon_pic, AchivList}]),
    lib_achievement:trigger(PS, RoleLv, mon_pic_lv, [{mon_pic_lv, TotalLv}]),
    {ok, PS}.
%%--------------------------------------------------
%% 穿戴装备
%% @param  PS   description
%% @param  GoodsTypeId  EquipType Color
%% @return      description
%%--------------------------------------------------
wear_equip_event(PS, GoodsTypeId, EquipType, Color) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    case EquipType of
        ?EQUIP_RING ->
            lib_achievement:trigger(PS, RoleLv, wear_ring, [{wear_ring, 1}]);
        ?EQUIP_BRACELET ->
            lib_achievement:trigger(PS, RoleLv, wear_bracelet, [{wear_bracelet, 1}]);
        ?EQUIP_NECKLACE ->
            lib_achievement:trigger(PS, RoleLv, wear_necklace, [{wear_necklace, 1}]);
        ?EQUIP_AMULET ->
            lib_achievement:trigger(PS, RoleLv, wear_amulet, [{wear_amulet, 1}]);
        _ ->
            skip
    end,
    if
        Color == 4 -> %% 橙色
            Star = lib_equip_api:get_equip_star(GoodsTypeId),
            lib_achievement:trigger(PS, RoleLv, wear_orange_equip, [{wear_orange_equip, Star}]);
        true ->
            skip
    end,
    {ok, PS}.

%%--------------------------------------------------
%% 合成一件红装
%% @param  PS   description
%% @param  Data 0
%% @return      description
%%--------------------------------------------------
compose_red_equip(PS, GoodsInfoList) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    Fun = fun(GoodsInfo, Bool) ->
        #goods{color = Color} = GoodsInfo,
        if
            Color == 5 ->
                true;
            true ->
                Bool
        end
    end,
    Needtrigger = lists:foldl(Fun, 0, GoodsInfoList),
    compose_equip_event(PS, GoodsInfoList),
    if
        Needtrigger == true ->
            lib_achievement:trigger(PS, RoleLv, compose_red_equip, [{compose_red_equip, 1}]);
        true ->
            skip 
    end,
    {ok, PS}.

%%--------------------------------------------------
%% 合成套装
%% @param  PS   description
%% @param  Data 套装信息列表[{1,num},{2,num1}] 1是诛仙，2是诛神
%% @return      description
%%--------------------------------------------------
make_equip_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    case Data of
        [{1, Num1}, {2, Num2}] ->
            lib_achievement:trigger(PS, RoleLv, immortal_equip, [{immortal_equip, Num1}]),
            lib_achievement:trigger(PS, RoleLv, god_equip, [{god_equip, Num2}]);
        _ ->
            skip
    end.

suit_info_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    Fun = fun(#suit_state{key = {Type, SuitType, Lv}, count = Num}, Acc) ->
        case lists:keyfind({Type, SuitType}, 1, Acc) of
            {{Type, SuitType}, List} ->
                lists:keystore({Type, SuitType}, 1, Acc, {{Type, SuitType}, [{Lv, Num}|List]});
            _ ->
                lists:keystore({Type, SuitType}, 1, Acc, {{Type, SuitType}, [{Lv, Num}]})
        end;
        (_, Acc) -> Acc
    end,
    NewData = lists:foldl(Fun, [], Data),
    Fun1 = fun({{Type, SuitType}, List}) ->
        if
            Type == 1 andalso SuitType == ?EQUIP_SUIT_LV_EQUIP ->
                lib_achievement:trigger(PS, RoleLv, immortal_equip_suit, [{immortal_equip_suit, List}]);
            Type == 1 andalso SuitType == ?EQUIP_SUIT_LV_ORNAMENT ->
                lib_achievement:trigger(PS, RoleLv, immortal_ornament_suit, [{immortal_ornament_suit, List}]);
            Type == 2 andalso SuitType == ?EQUIP_SUIT_LV_EQUIP ->
                lib_achievement:trigger(PS, RoleLv, god_equip_suit, [{god_equip_suit, List}]);
            Type == 2 andalso SuitType == ?EQUIP_SUIT_LV_ORNAMENT ->
                lib_achievement:trigger(PS, RoleLv, god_ornament_suit, [{god_ornament_suit, List}]);
            true ->
                skip
        end
    end,
    lists:foreach(Fun1, NewData),
    {ok, PS}.

%%--------------------------------------------------
%% 通关经验副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_exp_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_exp, [{dungeon_exp_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 经验副本鼓舞
%% @param  PS   description
%% @param  Data 鼓舞类型
%% @return      description
%%--------------------------------------------------
dungeon_exp_encourage_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, exp_encourage, [{dungeon_exp_encourage, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关符文副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_rune_event(PS, _) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    Level = lib_dungeon_rune:get_dungeon_level(PS),
    lib_achievement:trigger(PS, RoleLv, dungeon_rune, [{dungeon_rune_pass, Level}]),
    {ok, PS}.

%%--------------------------------------------------
%% 穿戴8个X级符文
%% @param  PS   description
%% @param  Data [{lv, num}] ,[{Cloor, Num}]
%% @return      description
%%--------------------------------------------------
rune_equip_event(PS, {Data, Data1}) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, rune_equip, [{rune_equip, Data}]),
    lib_achievement:trigger(PS, RoleLv, rune_equip_color, [{rune_equip_color, Data1}]),
    {ok, PS}.

%%--------------------------------------------------
%% 合成X个符文
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
compose_rune_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, compose_rune, [{compose_rune, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 合成X个源力
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
compose_soul_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, compose_soul, [{compose_soul, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 公会争霸累计胜利次数
%% @param  PS   description
%% @param  data 1
%% @return      description
%%--------------------------------------------------
guild_battle_win_event(PS, _Data) when is_record(PS, player_status) ->
    % #player_status{figure = Figure} = PS,
    % #figure{lv = RoleLv} = Figure,
    % lib_achievement:trigger(PS, RoleLv, guild_battle_win, [{guild_battle_win, Data}]),
    {ok, PS};
% guild_battle_win_event(RoleId, Data) when is_integer(RoleId) ->
%     lib_achievement:outline_trigger(RoleId, guild_battle_win, [{guild_battle_win, Data}]);
guild_battle_win_event(_RoleId, _Data) -> skip.

%%--------------------------------------------------
%% 公会争霸终结一次其他公会连胜
%% @param  PS   description
%% @param  data 1
%% @return      description
%%--------------------------------------------------
guild_battle_break_event(PS, _Data) when is_record(PS, player_status) ->
    % #player_status{figure = Figure} = PS,
    % #figure{lv = RoleLv} = Figure,
    % lib_achievement:trigger(PS, RoleLv, guild_battle_break, [{guild_battle_break, Data}]),
    {ok, PS};
% guild_battle_break_event(RoleId, Data) when is_integer(RoleId) ->
%     lib_achievement:outline_trigger(RoleId, guild_battle_break, [{guild_battle_break, Data}]);
guild_battle_break_event(_RoleId, _Data) -> skip.


guild_battle_win_achievement(GuildMemberList) ->
    % GuildMemberList = mod_guild:get_guild_member_id_list(GuildId),
    spawn(fun() -> send_achievement_info(GuildMemberList, guild_battle_win_event) end).

guild_battle_break_win(GuildMemberList) ->
    spawn(fun() -> send_achievement_info(GuildMemberList, guild_battle_break_event) end).

send_achievement_info(RoleIdList, F) ->
    Fun = fun(RoleId,Count) ->
        Pid = misc:get_player_process(RoleId),
        IsAlive = case is_pid(Pid) andalso misc:is_process_alive(Pid) of
            true ->
                true;
            false ->
                false
        end, 
        if
            IsAlive == true ->
                lib_achievement_api:async_event(RoleId, lib_achievement_api, F, 1);
            F == guild_battle_win_event ->
                lib_achievement_api:guild_battle_win_event(RoleId, 1);
            true ->
                lib_achievement_api:guild_battle_break_event(RoleId, 1)
        end,
        if
            Count+1 >= 20 ->
                timer:sleep(1000),
                Count = 0;
            true ->
                Count
        end
    end,
    lists:foldl(Fun, 0, RoleIdList).

%%--------------------------------------------------
%% 同时穿戴X件Y阶以上装备
%% @param  PS   description
%% @param  Data 身上穿戴装备的列表
%% @return      description 
%%--------------------------------------------------
wear_equip_stage(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    wear_equip_attr_att(PS, Data),
    wear_equip_attr_def(PS, Data),
    lib_achievement:trigger(PS, RoleLv, equip_stage, [{wear_equip_stage, Data}]),
    lib_achievement:trigger(PS, RoleLv, equip_stage2, [{wear_equip_star, Data}]),
    lib_achievement:trigger(PS, RoleLv, equip_stage3, [{wear_equip_star2, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 穿戴的装备攻击达到XX点
%% @param  PS   description
%% @param  Data 身上穿戴装备的列表(GoodsInfo)
%% @return      description
%%--------------------------------------------------
wear_equip_attr_att(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    F = fun(GoodsInfo, TemAtt) ->
        #goods{goods_id = GoodsId, other = #goods_other{addition = _BaseAttr, extra_attr = ExtraAttr}} = GoodsInfo,
        case data_goods_type:get(GoodsId) of
            #ets_goods_type{base_attrlist = BaseAttr} -> 
                case lists:keyfind(?ATT, 1, BaseAttr) of
                    {?ATT, BaseAtt} ->skip;
                    _ -> BaseAtt = 0
                end;
            _ -> BaseAtt = 0
        end,
        case lists:keyfind(?ATT_ADD_RATIO, 2, ExtraAttr) of
            {_, ?ATT_ADD_RATIO, Value1} ->skip;
            _ ->Value1 = 0
        end,
        Value2 = case lists:keyfind(?LV_ATT, 2, ExtraAttr) of
            {_, ?LV_ATT, Value3, Distance, AddValue} ->
                Value3 + erlang:round(RoleLv/Distance*AddValue);
            _ -> 0
        end,
        erlang:round(TemAtt + (Value2 + BaseAtt)*(Value1 + 1000)/1000)
    end,
    Att = lists:foldl(F, 0, Data),
    % ?PRINT("Att:~p~n",[Att]),
    lib_achievement:trigger(PS, RoleLv, wear_equip_attr_att, [{wear_equip_attr_att, Att}]).

%%--------------------------------------------------
%% 穿戴的装备防御达到XX点
%% @param  PS   description
%% @param  Data 身上穿戴装备的列表(GoodsInfo)
%% @return      description
%%--------------------------------------------------
wear_equip_attr_def(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    F = fun(GoodsInfo, TemAtt) ->
        #goods{goods_id = GoodsId, other = #goods_other{addition = _BaseAttr, extra_attr = ExtraAttr}} = GoodsInfo,
        case data_goods_type:get(GoodsId) of
            #ets_goods_type{base_attrlist = BaseAttr} -> 
                case lists:keyfind(?DEF, 1, BaseAttr) of
                    {?DEF, BaseAtt} ->skip;
                    _ -> BaseAtt = 0
                end;
            _ -> BaseAtt = 0
        end,
        case lists:keyfind(?DEF_ADD_RATIO, 2, ExtraAttr) of
            {_, ?DEF_ADD_RATIO, Value1} ->skip;
            _ ->Value1 = 0
        end,
        Value2 = case lists:keyfind(?LV_DEF, 2, ExtraAttr) of
            {_, ?LV_DEF, Value3, Distance, AddValue} ->
                Value3 + erlang:round(RoleLv/Distance*AddValue);
            _ -> 0
        end,
        erlang:round(TemAtt + (Value2 + BaseAtt)*(Value1 + 1000)/1000)
    end,
    Def = lists:foldl(F, 0, Data),
    % ?PRINT("Def:~p~n",[Def]),
    lib_achievement:trigger(PS, RoleLv, wear_equip_attr_def, [{wear_equip_attr_def, Def}]).
%%--------------------------------------------------
%% 成就等级达到XXX级
%% @param  PS   description
%% @param  Data 成就等级
%% @return      description
%%--------------------------------------------------
achv_stage_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, achv_stage, [{achv_stage, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 首充
%% @param  PS   description
%% @param  Data 1
%% @return      description
%%--------------------------------------------------
% recharge_first_event(PS, Data) ->
%     #player_status{figure = Figure} = PS,
%     #figure{lv = RoleLv} = Figure,
%     lib_achievement:trigger(PS, RoleLv, recharge_first, [{recharge_first, Data}]),
%     {ok, PS}.

%%--------------------------------------------------
%% 成就阶段奖励 achv_stage_reward
%% @param  PS   description
%% @param  Data 成就总星数
%% @return      description
%%--------------------------------------------------
achv_stage_reward_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, achv_stage_reward, [{achv_stage_reward, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 打造X件Y阶装备
%% @param  PS   description
%% @param  Data GoodsInfoList
%% @return      description
%%--------------------------------------------------
compose_equip_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, compose_equip, [{compose_equip, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 将装备洗炼至Y段位
%% @param  PS   description
%% @param  Data [{Stage, Num}]
%% @return      description
%%--------------------------------------------------
equip_wash_division(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, equip_wash, [{equip_wash, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计护送女神X次
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
husong_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, husong, [{husong, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计参加X次午间派对
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
mid_party_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, mid_party, [{mid_party, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计参加X次钻石大战
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
drumwar_join_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, drumwar, [{drumwar, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计参加X次跨服3v3
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
cluster_3v3_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, cluster_3v3, [{cluster_3v3, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计参加X次跨服1VN
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
cluster_1vn_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, cluster_1vn, [{cluster_1vn, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 收集X件时装
%% @param  PS   description
%% @param  Data 时装总数
%% @return      description
%%--------------------------------------------------
fasion_active_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, fasion_active, [{fasion_active, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% Y件时装升到X星
%% @param  PS   description
%% @param  Data [{Star, Num}...]
%% @return      description
%%--------------------------------------------------
fasion_star_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, fasion_star, [{fasion_star, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计金币许愿X次
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
exp_pray_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, exp_pray, [{exp_pray, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计金币许愿X次
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
coin_pray_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, coin_pray, [{coin_pray, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计击杀X只圣域boss
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
sanctuary_boss_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, sanctuary_boss, [{sanctuary_boss, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计获得X圣域积分
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
sanctuary_score_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, sanctuary_score, [{sanctuary_score, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 圣印总等级强化至X
%% @param  PS   description
%% @param  Data [{Pos, NewStren}]
%% @return      description
%%--------------------------------------------------
seal_stren_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, seal_stren, [{seal_stren, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 穿戴X件Y阶橙色以上圣印
%% @param  PS   description
%% @param  Data [{Color, Stage}]
%% @return      description
%%--------------------------------------------------
seal_equip_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, seal_equip, [{seal_equip, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 法宝升级
%% @param  PS   description
%% @param  Data 新的等级
%% @return      description
%%--------------------------------------------------
talisman_lv_up_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, talisman_lv, [{talisman_lv, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 法宝幻化激活
%% @param  PS   description
%% @param  Data 激活的id
%% @return      description
%%--------------------------------------------------
talisman_acti_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, talisman_acti, [{talisman_active, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 神兵升级
%% @param  PS   description
%% @param  Data 新的等级
%% @return      description
%%--------------------------------------------------
godweapon_lv_up_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, godweapon_lv, [{godweapon_lv, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 神兵幻化激活
%% @param  PS   description
%% @param  Data 激活的id
%% @return      description
%%--------------------------------------------------
godweapon_acti_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, godweapon_acti, [{godweapon_active, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 宠物进阶
%% @param  PS   description
%% @param  Data 新的阶数
%% @return      description
%%--------------------------------------------------
pet_class_up_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, pet_class, [{pet_upgrade_stage, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 宠物激活幻化
%% @param  PS   description
%% @param  Data 激活的id
%% @return      description
%%--------------------------------------------------
pet_acti_figure_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, pet_figure, [{pet_figure_active, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 坐骑激活幻化
%% @param  PS   description
%% @param  Data 激活的id
%% @return      description
%%--------------------------------------------------
mount_acti_figure_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, mount_figure, [{mount_figure_active, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 幻兽装备强化
%% @param  PS   description
%% @param  Data 强化等级
%% @return      description
%%--------------------------------------------------
eudemons_equip_stren_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, eudemons_stren, [{eudemons_stren, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 幻兽数量扩展
%% @param  PS   description
%% @param  Data 扩展数量
%% @return      description
%%--------------------------------------------------
eudemons_extend_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, eudemons_extend, [{eudemons_extend, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 幻兽装备合成
%% @param  PS   description
%% @param  Data 当次合成物品 [{{Star, Color}, Num}]
%% @return      description
%%--------------------------------------------------
eudemons_compose_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    [{{Star, Color},_}|_] = Data,
    case Color of
        4 ->
            lib_achievement:trigger(PS, RoleLv, compose_eudemons4, [{compose_eudemons4, Data}]);
        5 ->
            if
                Star == 3 ->
                    lib_achievement:trigger(PS, RoleLv, compose_eudemons5_3, [{compose_eudemons5_3, Data}]);
                true ->
                    lib_achievement:trigger(PS, RoleLv, compose_eudemons5, [{compose_eudemons5, Data}])
            end;
        6 ->
            lib_achievement:trigger(PS, RoleLv, compose_eudemons6, [{compose_eudemons6, Data}]);
        _ -> skip
    end,
    {ok, PS}.

%%--------------------------------------------------
%% 合成套装
%% @param  PS   description
%% @param  Data [Type, NewLv, NewSLv, Count]
%% @return      description
%%--------------------------------------------------
equip_suit_synthesis_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, suit_type, [{equip_suit, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 神器激活
%% @param  PS   description
%% @param  Data 神器激活id
%% @return      description
%%--------------------------------------------------
artifact_acti_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, artifact_acti, [{artifact_active, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 神器附灵
%% @param  PS   description
%% @param  Data 神器激活附灵属性数量
%% @return      description
%%--------------------------------------------------
artifact_enchant_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, artifact_enchant, [{artifact_enchant, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 每日签到
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
check_in_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, checkin, [{checkin, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 怪物死亡,备注:修改这里的参数要记得同时匹配lib_achievement do_trigger接口内的SaveDBCD
%% @param  PS    description
%% @param  MonLv 怪物的等级,和玩家等级相差100级以内才算
%% @return       description
%%--------------------------------------------------
mon_die_event(PS, MonLv) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    case RoleLv - MonLv < 100 of
        true ->
            lib_achievement:trigger(PS, RoleLv, kill_mon, [{kill_mon, []}]);
        false -> skip
    end,
    {ok, PS}.

%%--------------------------------------------------
%% 完成赏金任务
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
bounty_fin_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, bounty, [{bounty, Data}]),
    {ok, PS}.

%% 完成扫荡赏金任务
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
sweep_bounty_fin_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, bounty, [{sweep_bounty, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 虚空秘境中击杀玩家
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
void_fam_kill_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, void_kill, [{void_fam_kill, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 九魂圣殿中击杀玩家或假人
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
nine_kill_object(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, nine_kill, [{nine_kill, Data}]),
    {ok, PS}.
    
%%--------------------------------------------------
%% 巅峰竞技中达到指定段位
%% @param  PS   description
%% @param  Data 段位
%% @return      description
%%--------------------------------------------------
top_pk_win_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, top_pk, [{top_pk, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 中午答题答对多少题
%% @param  PS   description
%% @param  Data 答对题目数量
%% @return      description
%%--------------------------------------------------
quiz_correct_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, quiz_correct, [{quiz_correct, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 参加魅力海滩
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
beach_join_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, join_beach, [{join_beach, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 幻兽之域采集达到多少次
%% @param  PS   description
%% @param  Data 采集怪id
%% @return      description
%%--------------------------------------------------
eudemons_boss_collect_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, ai_collect_id, [{eudemons_boss_collect, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 使用幻兽之域装备宝箱
%% @param  PS   description
%% @param  Data 物品类型id
%% @return      description
%%--------------------------------------------------
eudemons_land_equipbox_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, ai_equipbox_id, [{eudemons_land_equipbox, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 完成公会任务
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
guild_task_fin_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_task, [{guild_task, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 完成扫荡公会任务
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
sweep_guild_task_fin_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_task, [{sweep_guild_task, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 参加公会篝火
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
guild_dinner_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, join_guild_fire, [{join_guild_fire, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 参加公会战
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
guild_war_join_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_war, [{guild_war, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计发出公会红包多少个
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
guild_red_packet_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_red_packet, [{guild_red_packet, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计召唤公会巨龙多少个
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
guild_summon_dragon_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, guild_dragon, [{guild_dragon, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 好友增加
%% @param  PS   description
%% @param  Data 当前好友数量
%% @return      description
%%--------------------------------------------------
add_friend_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, add_friend, [{add_friend, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 私聊
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
chat_private_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, chat_private, [{chat_private, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 结婚
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
get_marry_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, get_marry, [{marry, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 宝宝升阶
%% @param  PS   description
%% @param  Data 阶数
%% @return      description
%%--------------------------------------------------
baby_class_up_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, baby_class, [{baby_class_up, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 宝宝形象激活
%% @param  PS   description
%% @param  Data 当前激活id
%% @return      description
%%--------------------------------------------------
baby_get_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, baby_get, [{baby_get, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 洗红名
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
red_name_wash_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, red_name_wash, [{red_name_wash, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 野外场景击杀玩家
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
kill_player_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, kill_player, [{kill_player, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 击杀红名玩家
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
kill_red_name_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, kill_redname, [{kill_red_name, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 玩家死亡
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
player_die_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, player_die, [{player_die, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 玩家名誉值达到多少
%% @param  PS   description
%% @param  Data 玩家当前名誉等级
%% @return      description
%%--------------------------------------------------
flower_send_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, flower_send, [{role_fame, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 玩家魅力值达到多少
%% @param  PS   description
%% @param  Data 玩家当前魅力值
%% @return      description
%%--------------------------------------------------
flower_get_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, flower_get, [{role_charm, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 世界聊天
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
chat_world_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, world_chat, [{world_chat, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 聊天
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
chat_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, chat, [{chat, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计获得多少金币
%% @param  PS   description
%% @param  Data 本次获得的金币数量
%% @return      description
%%--------------------------------------------------
coin_get_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, coin_get, [{coin_get, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 市场出售累计获得X钻石
%% @param  PS   description
%% @param  Data 本次获得的钻石
%% @return      description
%%--------------------------------------------------
sell_sell_event(0, _, _) -> skip;   % 系统出售
sell_sell_event(RoleId, SellerSerId, Data) ->
    SerId = config:get_server_id(),
    case SerId == SellerSerId of
        true ->     % 买家和卖家同服
            sell_sell_event(RoleId, Data);
        false ->    % 买家和卖家不同服
            mod_clusters_node:apply_cast(?MODULE, sell_sell_event_center, [RoleId, SellerSerId, Data])
    end.

sell_sell_event(0, _) -> skip;      % 系统出售
sell_sell_event(RoleId, Data) when is_integer(RoleId) ->
    case lib_player:is_online_global(RoleId) of
        true ->
            async_event(RoleId, ?MODULE, sell_sell_event_online, Data);
        false ->
            spawn(?MODULE, sell_sell_event_offline, [RoleId, Data])
    end.

%% 跨服中心执行
sell_sell_event_center(RoleId, SerId, Data) ->
    % SerId = mod_id_create:get_serid_by_id(RoleId),
    mod_clusters_center:apply_cast(SerId, ?MODULE, sell_sell_event, [RoleId, Data]).

sell_sell_event_online(PS, Data) ->
    % ?PRINT("@@@@@@@ sealsell: ~p~n",[Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, sell_sell, [{sell_sell, Data}]),
    {ok, PS}.

sell_sell_event_offline(RoleId, Data) when is_integer(RoleId) ->    % 卖家离线
    lib_achievement:outline_trigger(RoleId, sell_sell, [{sell_sell, Data}]).

%%--------------------------------------------------
%% 市场购买累计消耗X钻石
%% @param  PS   description
%% @param  Data 本次消耗的钻石
%% @return      description
%%--------------------------------------------------
sell_cost_event(RoleId, BuyerSerId, Data) ->
    SerId = config:get_server_id(),
    case SerId == BuyerSerId of
        true ->     % 买家和卖家同服
            sell_cost_event(RoleId, Data);
        false ->    % 买家和卖家不同服
            mod_clusters_node:apply_cast(?MODULE, sell_cost_event_center, [RoleId, BuyerSerId, Data])
    end.

sell_cost_event(RoleId, Data) when is_integer(RoleId) ->
    case lib_player:is_online_global(RoleId) of
        true ->
            async_event(RoleId, ?MODULE, sell_cost_event_online, Data);
        false ->
            spawn(?MODULE, sell_cost_event_offline, [RoleId, Data])
    end.

%% 跨服中心执行
sell_cost_event_center(RoleId, SerId, Data) ->
    % SerId = mod_id_create:get_serid_by_id(RoleId),
    mod_clusters_center:apply_cast(SerId, ?MODULE, sell_cost_event, [RoleId, Data]).

sell_cost_event_online(PS, Data) ->
    % ?PRINT("@@@@@@@ sealsell: ~p~n",[Data]),
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, sell_cost, [{sell_cost, Data}]),
    {ok, PS}.

sell_cost_event_offline(RoleId, Data) when is_integer(RoleId) ->    % 求购玩家离线
    lib_achievement:outline_trigger(RoleId, sell_cost, [{sell_cost, Data}]).

%%--------------------------------------------------
%% 通关聚魂副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_soul_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_soul, [{dungeon_soul_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 镶嵌X个N品质的源力
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
soul_wear_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    F = fun(Soul, Acc) ->
        #goods{color = Color} = Soul,
        case lists:keyfind(Color, 1, Acc) of
            {Color, Num} -> lists:keystore(Color, 1, Acc, {Color, Num+1});
            _ -> lists:keystore(Color, 1, Acc, {Color, 1})
        end
    end,
    Total = lists:foldl(F, [], Data),
    lib_achievement:trigger(PS, RoleLv, soul_wear, [{soul_wear, Total}]),
    {ok, PS}.

%%--------------------------------------------------
%% 源力总等级达到X
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
soul_level_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    F = fun(Soul, Acc) ->
        #goods{level = Level} = Soul,
        case lists:keyfind(Level, 1, Acc) of
            {Level, Num} -> lists:keystore(Level, 1, Acc, {Level, Num+1});
            _ -> lists:keystore(Level, 1, Acc, {Level, 1})
        end
    end,
    Total = lists:foldl(F, [], Data),
    lib_achievement:trigger(PS, RoleLv, soul_level, [{soul_level, Total}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关单人经验副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_exp_single_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_exp_single, [{dungeon_exp_single_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关金币副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_coin_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_coin_pass, [{dungeon_coin_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关装备副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_equip_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_equip, [{dungeon_equip_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关坐骑副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_mount_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_mount_pass, [{dungeon_mount_pass, Data}]),
    {ok, PS}.
%%--------------------------------------------------
%% 通关伙伴副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_partner_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_partner_pass, [{dungeon_partner_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关专属boss副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_vip_perboss_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_vip_perboss, [{dungeon_vip_perboss, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 一件装备洗炼达到N段位
%% @param  PS   description
%% @param  Data 当前洗炼段位
%% @return      description
%%--------------------------------------------------
wash_division(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, wash_division, [{wash_division, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 中午答题累计答对N题
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
grand_total_quiz_correct(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, grand_total_quiz_correct, [{grand_total_quiz_correct, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 累计X次寻宝
%% @param  PS   description
%% @param  Data Times
%% @return      description
%%--------------------------------------------------
treasure_hunt_event(PS, {Htype, Data}) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    if
        Htype == ?TREASURE_HUNT_TYPE_EUQIP ->
            lib_achievement:trigger(PS, RoleLv, equip_hunt, [{equip_hunt, Data}]);
        Htype == ?TREASURE_HUNT_TYPE_PEAK ->
            lib_achievement:trigger(PS, RoleLv, peak_hunt, [{peak_hunt, Data}]);
        Htype == ?TREASURE_HUNT_TYPE_RUNE ->
            lib_achievement:trigger(PS, RoleLv, rune_hunt, [{rune_hunt, Data}]);
        true ->
            skip
    end,
    {ok, PS}.

%%--------------------------------------------------
%% 聚魂副本通关第几层
%% @param  PS   description
%% @param  Data 通关第几层
%% @return      description
%%--------------------------------------------------
pass_soul_dun_floor(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, soul_dun_floor, [{soul_dun_floor, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 符文副本通关第几层
%% @param  PS   description
%% @param  Data 通关第几层
%% @return      description
%%--------------------------------------------------
pass_rune_dun_floor(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, rune_dun_floor, [{rune_dun_floor, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关精灵副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_sprite_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_partner_pass, [{dungeon_partner_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关羽翼副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_wing_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_partner_pass, [{dungeon_partner_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关御守副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_amulet_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_partner_pass, [{dungeon_partner_pass, Data}]),
    {ok, PS}.

%%--------------------------------------------------
%% 通关神兵副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_weapon_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_partner_pass, [{dungeon_partner_pass, Data}]),
    {ok, PS}.


%%--------------------------------------------------
%% 通关背饰副本
%% @param  PS   description
%% @param  Data []
%% @return      description
%%--------------------------------------------------
dungeon_back_event(PS, Data) ->
    #player_status{figure = Figure} = PS,
    #figure{lv = RoleLv} = Figure,
    lib_achievement:trigger(PS, RoleLv, dungeon_partner_pass, [{dungeon_partner_pass, Data}]),
    {ok, PS}.
