%% ---------------------------------------------------------------------------
%% @doc    php交互
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module (lib_php_api).

%% php模块功能的处理=>调用php
-export([request/3, request_register/3]).

%% php模块功能的处理=>php回调
-export([]).

%% 游戏服务器提供给php后台调用的API
-export ([
        nofity_pay/1                      %% 通知充值入账游戏服务器
        , reload_custom_act_cfg/0          %% 额外定制活动热更之后后台调用接口
        , modify_guild_name/2              %% 修改公会名字
        , modify_announce/2                %% 修改公会公告
        , disband_guild/1                  %% 解散公会
        , realese_upload_player_picture/1  %%
        , forbid_upload_player_picture/1   %%
        , delete_player_picture/1          %%
        , clear_gwar_confirm_info/0        %% 清理公会争霸确认期的信息
        , set_goods_expired_time/3         %% 设置物品有效期
        , gm_repair_role_lv/3              %% 设置玩家的等级
        , gm_del_task/2                    %% 删除玩家已接任务
        , gm_send_equip_dun_reward/0       %% 补偿装备副本奖励
        , reload_diamond_league/0          %% 重新加载星钻联赛
        , diamond_league_cancel_mail/2     %% 补偿取消星钻联赛报名
        , recheck_stage/0                  %% 重新检测服战阶段 处于休战期且在跨服中心使用才有效
        , cluster_server_combine/0         %% 跨服节点合并执行活动秘籍(针对合跨服前的一些特殊活动结算处理)
        , game_server_combine/0            %% 游戏节点器合并执行活动秘籍(针对合跨服前的一些特殊活动结算处理)
        , diamond_league_time_sync/0       %% 星钻联赛状态广播
        , gm_consume_rank/0                %% 修复消费排行
        , reload_guess/0                   %% 重新加载竞猜
        , reload_guess_only_data/0         %% 重新加载竞猜,只加载数据不发奖
        , gm_consume_rank_reward/0         %% 补发消费排行安慰奖,
        , repair_encourage_buff/0          %% 修复鼓舞buff效果
        , repair_encourage_buff/1          %% 修复鼓舞buff效果
        , repair_consume_act_rewards/0     %% 修复消费奖励
        , clear_dun_enter_count/2          %% 清理副本进入次数
        , gm_setup_vip/3                   %% 设置vip经验时间
        , repair_dungeon/3                 %% 副本修复
        , repair_dungeon/4                 %% 副本修复
        , repair_3v3/0                     %% 跨服3v3修复
        , delete_temple_scene_user/0       %% 删除遗忘神庙玩家旧数据
        , gm_remove_saint_dsgt/0           %% 删除圣者殿称号
        , gm_create_local_boss/1           %% gm手动创建boss
        , gm_confirm_kfgwar_join_guild/0   %% gm手动确认跨服公会战本服的参赛公会
        , gm_restore_old_player_wedding_times/0  %% 补回旧号的婚宴次数
        , gm_restore_sell_equip_info/0  %% 市场增加男女装备的区分，修复数据
        , reload_server_name/0             %% 重新加载服务器名字 
        , reload_c_server_msg/0            %% 重新加载客户端显示的服信息
        , reload_server_type/0             %% 重新加载服务端类型
        , update_c_server_msg/1            %% 更新客户端显示的服信息
        , gm_change_role_name/2            %% 修改玩家名字
        , gm_add_eudemons_exp_all/0        %% 补偿圣兽领经验
        , reload_mail/1                    %% 重新加载邮件
        , reload_goods/1                   %% 重新加载物品
        , gm_log_attr/1
        , recalc_zones/0                   %% 重新划分小跨服
        , fix_jjc_battle_status/1          %% 修复竞技场
        , fix_jjc_battle_status_all/0          %% 修复竞技场
        , force_fix_jjc_battle_status/1
        , manual_send_festival_investment_reward_all/2
        , notify_handle/1
        , hi_point_reload/1                %% 嗨点重载
        , gm_add_hi_af_sweep_bounty_task/2 %% 修复扫荡赏金任务嗨点
        , contract_challenge_soul/1        %% 契约挑战聚魂扫荡修复
        , cancel_lenged_contract/2         %% 取消置顶用户的传说契约
        , add_contract_point/3             %% 添加契约挑战点
        , load_contract_buff/0             %% 加载契约Buff
        , send_mail_reward/6
        , gm_clear_rune_dun_enter_count/2
        , fix_exploit/1                    %% 修复功勋
        , restart_process/1
        , start_child_process/1
        , cls_notify_filter_words_update/1
        , notify_filter_words_update/2
        , get_role_passive_skill/1
        , output_ets_user/1
        , output_ets_user_help/1
        , set_ets_user/2
        , set_ets_user_help/2
        , fix_supreme_vip_goods_skill/2
        ,notify_ads/2
        , repair_cumulation_data/0         %% 修复每日累充旧数据
        , check_is_open/0                  %% 服务器是否启动
        , get_online_num/0
        , update_player_state_power/1
        , info_player_passive_skill/1
        , gm_mon_statistics/0
        , gm_fix_dungeon_times/2
        , gm_fix_dungeon_times_info/1
    ]).

-export([
    gm_update_consume_rank/3
]).

-include("common.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("custom_act.hrl").
-include("php.hrl").
-include("record.hrl").
-include ("dungeon.hrl").
-include ("def_module.hrl").
-include ("figure.hrl").
-include ("scene.hrl").

%% -----------------------------------------------------------------
%% php模块功能的处理=>调用php
%% -----------------------------------------------------------------

%% 请求
%% @param PhpMethod php方法
%% @param PhpRequest #php_request{}
request(PhpMethod, PostData, PhpRequest) ->
    [GUrl, Appkey, Game, Version] = [lib_vsn:get_url(), ?APPKEY, ?GAME, ?VERSION],
    NowTime = utime:unixtime(),
    AuthStr = util:md5(lists:concat([Appkey, NowTime, PhpMethod])),
    Url = lists:concat([GUrl, "time=", NowTime, "&method=", PhpMethod, "&sign=", AuthStr]),
    NewPostData = [{game, Game}, {version, Version}|PostData],
    StrBody = mochiweb_util:urlencode(NewPostData),
    mod_php:request(Url, StrBody, PhpRequest),
    ok.

% 请求注册系统
request_register(PhpMethod, PostData, PhpRequest) ->
    [GUrl, Appkey, Game, Version] = [lib_vsn:get_register_url(), ?APPKEY, ?GAME, ?VERSION],
    NowTime = utime:unixtime(),
    AuthStr = util:md5(lists:concat([Appkey, NowTime, PhpMethod])),
    Url = lists:concat([GUrl, "time=", NowTime, "&method=", PhpMethod, "&sign=", AuthStr]),
    NewPostData = [{game, Game}, {version, Version}|PostData],
    StrBody = mochiweb_util:urlencode(NewPostData),
    mod_php:request(Url, StrBody, PhpRequest),
    ok.

%% -----------------------------------------------------------------
%% php模块功能的处理=>php回调
%% -----------------------------------------------------------------


%% -----------------------------------------------------------------
%% 游戏服务器提供给php后台调用的API
%% -----------------------------------------------------------------

%% 通知充值入账游戏服务器
nofity_pay(PlayerId) ->
    lib_recharge_api:nofity_pay(PlayerId),
    ok.

%% 额外定制活动热更之后后台调用接口
reload_custom_act_cfg() ->
    lib_custom_act_api:reload_custom_act_cfg(),
    ok.

%% 后台修改公会名字
modify_guild_name(GuildId, GuildName) ->
    lib_guild_api:modify_guild_name_by_gm(GuildId, GuildName).

%% 后台修改公会公告
modify_announce(GuildId, Announce) ->
    lib_guild_api:modify_announce_by_gm(GuildId, Announce).


%% 广告通知奖励
notify_ads(RoleId, AdvertisementId) ->
    lib_advertisement:notify_ads(RoleId, AdvertisementId).
%%    lib_guild_api:modify_announce_by_gm(RoleId, AdvertisementId).

%% 后台强制解散公会
%% 需满足公会的解散条件
disband_guild(GuildId) ->
    lib_guild_api:disband_guild_by_gm(GuildId).

%% 允许玩家上传头像
%% @param IdList [Id, Id|...] 玩家列表
realese_upload_player_picture(IdList) ->
    %% IdList = util:string_to_term(IdListStr),
    lib_player:update_player_picture_lim(IdList, 0).

%% 禁止玩家上传头像
%% @param IdList [Id, Id|...] 玩家列表
forbid_upload_player_picture(IdList) ->
    %% IdList = util:string_to_term(IdListStr),
    lib_player:update_player_picture_lim(IdList, 1).

%% 删除玩家的头像
delete_player_picture(IdList)->
    %% IdList = util:string_to_term(IdListStr),
    lib_player:delete_player_picture(IdList).

%% 清理公会争霸确认期的信息
clear_gwar_confirm_info() ->
    lib_guild_war_api:clear_gwar_confirm_info().

%%--------------------------------------------------
%% 设置物品有效期
%% @param  RoleIds     玩家ids []表示对所有玩家都执行刷新操作
%% @param  GTypeIds    物品类型id列表
%% @param  ExpiredTime 新的过期时间
%% @return             description
%%--------------------------------------------------
set_goods_expired_time(RoleIdsStr, GTypeIdsStr, ExpiredTime) ->
    RoleIds = util:string_to_term(RoleIdsStr),
    GTypeIds = util:string_to_term(GTypeIdsStr),
    case GTypeIds =/= [] of
        true ->
            lib_goods_api:set_goods_expired_time(RoleIds, GTypeIds, ExpiredTime);
        _ -> skip
    end.

%% Gm修改玩家等级(只能离线)
gm_repair_role_lv(RoleId, Lv, Exp)->
    RolePid = misc:get_player_process(RoleId),
    case is_pid(RolePid) andalso misc:is_process_alive(RolePid) of
        true ->
            %% gen_server:cast(RolePid, {'set_role_lv', Lv, Exp});
            role_online_skip;
        false ->
            %% 经验
            ExpSQL = <<"update `player_high` set exp=~w where id=~w">>,
            %% 等级
            LvSQL = <<"update `player_low` set lv = ~w where id=~w">>,
            if
                Lv =< 370 ->
                    Fun = fun() ->
                                  db:execute(io_lib:format(ExpSQL, [Exp, RoleId])),
                                  db:execute(io_lib:format(LvSQL, [Lv, RoleId]))
                          end,
                    db:transaction(Fun);
                true ->
                    %% 技能点
                    SkSQL = <<"update `player_state` set skill_extra_point = ~w where id=~w">>,
                    %% 天赋技能
                    TSkSQL = <<"delete from talent_skill where role_id = ~w">>,
                    %% 计算技能点
                    SkillPoint = Lv - 370 + 5,
                    Fun = fun() ->
                                  db:execute(io_lib:format(SkSQL,  [SkillPoint, RoleId])),
                                  db:execute(io_lib:format(TSkSQL, [RoleId])),
                                  db:execute(io_lib:format(ExpSQL, [Exp, RoleId])),
                                  db:execute(io_lib:format(LvSQL,  [Lv, RoleId]))
                          end,
                    db:transaction(Fun)
            end
    end.

%% 后台删除玩家任务秘籍
gm_del_task(RoleId, TaskId) ->
    RolePid = misc:get_player_process(RoleId),
    case is_pid(RolePid) andalso misc:is_process_alive(RolePid) of
        true ->
            gen_server:cast(RolePid, {'gm_del_task', RoleId, TaskId});
        false ->
            F = fun() ->
                        %% 删除任务
                        SQL1 = <<"delete from task_bag WHERE role_id=~p and task_id=~p">>,
                        db:execute(io_lib:format(SQL1, [RoleId, TaskId])),
                        %% 删除任务日志
                        SQL2 = <<"delete from task_log WHERE role_id=~p and task_id=~p">>,
                        db:execute(io_lib:format(SQL2, [RoleId, TaskId])),
                        %% 删除和任务日志
                        SQL3 = <<"delete from task_log_clear WHERE role_id=~p and task_id=~p">>,
                        db:execute(io_lib:format(SQL3, [RoleId, TaskId]))
                end,
            db:transaction(F)
    end.

%% 补偿装备副本奖励
gm_send_equip_dun_reward()->
    SQL = <<"select id, role_id, dun_id from  log_multi_dungeon where dun_type = 5 and result_type = 1 and log_type = 1 and time >= 1526543940 and time < 1526565540;">>,
    case db:get_all(SQL) of
        [] ->
            skip;
        AllList ->
            F =fun([_Id, RoleId, DunId], Index)->
                       Reward = get_dun_reward(DunId, 1),
                       C = utext:get(6100010),
                       T = utext:get(6100011),
                       lib_mail_api:send_sys_mail([RoleId], C, T, Reward),
                       if
                           Index == 20 -> timer:sleep(100), 0;
                           true -> Index+1
                       end
               end,
            lists:foldl(F, 0, AllList)
    end.

get_dun_reward(DunId, Count) ->
    case DunId of
        3101 -> [{?TYPE_GOODS, 32060014, 10*Count}];
        3102 -> [{?TYPE_GOODS, 32060015, 10*Count}];
        3103 -> [{?TYPE_GOODS, 32060016, 10*Count}];
        3104 -> [{?TYPE_GOODS, 32060017, 10*Count}, {?TYPE_GOODS, 32010013, 3*Count}];
        3105 -> [{?TYPE_GOODS, 32060018, 10*Count}, {?TYPE_GOODS, 32010013, 3*Count}];
        3106 ->
            [{?TYPE_GOODS, 32060019, 10*Count}, {?TYPE_GOODS, 32010013, 3*Count}, {?TYPE_GOODS, 32010012, 5*Count}];
        3107 ->
            [{?TYPE_GOODS, 32060020, 10*Count}, {?TYPE_GOODS, 32010013, 3*Count}, {?TYPE_GOODS, 32010012, 5*Count}];
        3108 ->
            [{?TYPE_GOODS, 32060021, 10*Count}, {?TYPE_GOODS, 32010013, 3*Count}, {?TYPE_GOODS, 32010012, 5*Count}];
        3109 ->
            [{?TYPE_GOODS, 32060022, 10*Count}, {?TYPE_GOODS, 32010013, 3*Count}, {?TYPE_GOODS, 32010012, 5*Count}];
        _ ->
            [{?TYPE_GOODS, 32060014, 10*Count}]
    end.

reload_diamond_league() ->
    case util:is_cls() of
        true ->
            mod_diamond_league_ctrl:reload_time_ctrl();
        _ ->
            skip
    end.

diamond_league_cancel_mail(StartTimeStr, EndTimeStr) ->
    case util:is_cls() of
        true ->
            StartTime = if is_list(StartTimeStr) -> list_to_integer(StartTimeStr); true -> StartTimeStr end,
            EndTime = if is_list(EndTimeStr) -> list_to_integer(EndTimeStr); true -> EndTimeStr end,
            lib_diamond_league_apply:diamond_league_cancel_mail(StartTime, EndTime);
        _ ->
            skip
    end.

recheck_stage() ->
    ok.

%% 跨服合并前的一些特殊活动处理
cluster_server_combine() ->
    case config:get_cls_type() of
        ?NODE_CENTER ->
            ?ERR("cluster_server_combine_start:~p~n", [utime:unixtime()]),
            %% 特殊处理的活动:需要在合并跨服之前调用,结算活动
            %% 幸运之星
            mod_cloud_buy_mgr:gm_award(?NODE_CENTER),
            %% 圣者殿移除称号
            mod_saint:remove_dsgt(),
            ?ERR("cluster_server_combine_finish:~p~n", [utime:unixtime()]),
            ok;
        _ ->
            skip
    end.

%% 游戏服合并前的一些特殊活动处理
game_server_combine() ->
    case config:get_cls_type() of
        ?NODE_CENTER ->
            ?ERR("game_server_combine_start:~p~n", [utime:unixtime()]),
            %% 特殊处理的活动:需要在合并跨服之前调用,结算活动
            %% 幸运之星
            mod_cloud_buy_mgr:gm_award(?NODE_GAME),
            ?ERR("game_server_combine_finish:~p~n", [utime:unixtime()]),
            ok;
        _ ->
            skip
    end.

diamond_league_time_sync() ->
    case util:is_cls() of
        true ->
            mod_diamond_league_ctrl:sync_act_status();
        _ ->
            skip
    end.

%% 修复消费排行
gm_consume_rank() ->
    SQL = <<"select player_id from consume_rank_act">>,
    IdList = lists:flatten(db:get_all(SQL)),
    StartTime = 1528387200,
    EndTime = 1528646400,
    F = fun
            (RoleId) ->
                lib_player:apply_cast(RoleId, 1, lib_consume_data, clear_cache, [RoleId]),
                timer:sleep(30000 + urand:rand(0, 30000)),
                Pid = misc:get_player_process(RoleId),
                case is_pid(Pid) andalso misc:is_process_alive(Pid) of
                    true ->
                        lib_player:apply_cast(RoleId, 1, ?MODULE, gm_update_consume_rank, [RoleId, StartTime, EndTime]);
                    _ ->
                        SQL2 = io_lib:format("SELECT SUM(`cost_gold`) FROM `log_consume_gold` WHERE `player_id`=~p AND `time` >= ~p AND `time` < ~p AND `consume_type` NOT IN (88, 141, 144, 157)", [RoleId, StartTime, EndTime]),
                        case db:get_one(SQL2) of
                            NewNum when is_integer(NewNum) ->
                                lib_consume_rank_act:refresh_common_rank(382, 1, RoleId, NewNum);
                            _ ->
                                ok
                        end
                end
        end,
    [ spawn(fun () -> F(RoleId) end) || RoleId <- IdList ],
    ok.

gm_update_consume_rank(RoleId, StartTime, EndTime) ->
    NewNum = lib_consume_data:get_consume_gold_between(RoleId, StartTime, EndTime),
    lib_consume_rank_act:refresh_common_rank(382, 1, RoleId, NewNum).

reload_guess() ->
    case util:is_cls() of
        false ->
            spawn(fun() ->
                util:multiserver_delay(0),
                case catch mod_guess:auto_send_reward_bf_reload() of
                    ok ->
                        lib_dynamic_compile_api:compile_extra_guess_cfg(),
                        lib_guess:broadcast(),
                        ok;
                    _Err ->
                        ?ERR("reload_guess err:~p", [_Err]),
                        error
                end
            end),
            ok;
        _ -> ok
    end.

reload_guess_only_data() ->
    case util:is_cls() of
        false ->
            spawn(fun() ->
                util:multiserver_delay(0),
                mod_guess:reload()
            end),
            ok;
        _ -> ok
    end.

%% 补发消费排行安慰奖
gm_consume_rank_reward() ->
    case util:get_open_day() >= 5 of
        true ->
            StartTime = 1528387200,
            EndTime = 1528646400,
            SQL1 = io_lib:format("SELECT `player_id`, `cost_gold` FROM `log_consume_gold` WHERE `time` >= ~p AND `time` < ~p AND `consume_type` NOT IN (88, 141, 144, 157)", [StartTime, EndTime]),
            F0 = fun([RoleId, OneCost], Acc) ->
                case lists:keyfind(RoleId, 1, Acc) of
                    {RoleId, Cost} ->
                        lists:keystore(RoleId, 1, Acc, {RoleId, Cost + OneCost});
                    _ ->
                        [{RoleId, OneCost}|Acc]
                end
                 end,
            SumList = lists:foldl(F0, [], db:get_all(SQL1)),
            IdList1 = [ RoleId ||{RoleId, Cost}  <- SumList, Cost >= 300 ],
            SQL2 = <<"select role_id from log_consume_rank_act">>,
            IdList2 = lists:flatten(db:get_all(SQL2)),
            LastIdList = [RoleId  ||RoleId  <- IdList1, not lists:member(RoleId, IdList2) ],
            F = fun
                    (RoleId, Acc) ->
                        Reward = [{100,38060027,1},{100,18060002,5}],
                        C = utext:get(3310075),
                        T = utext:get(3310076),
                        lib_mail_api:send_sys_mail([RoleId], C, T, Reward),
                        if
                            Acc == 20 -> timer:sleep(100), 0;
                            true -> Acc + 1
                        end
                end,
            spawn(fun()->
                timer:sleep(30000 + urand:rand(0, 30000)),
                lists:foldl(F, 0, LastIdList)
                  end),
            ok;
        _ ->
            ok
    end.

repair_encourage_buff() ->
    Ids = lib_online:get_online_ids(),
    [lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?MODULE, repair_encourage_buff, []) || Id <- Ids],
    ok.

repair_encourage_buff(#player_status{scene = SceneId} = Player) ->
    if
        SceneId == 3000 orelse SceneId == 2401 ->
            ok;
        true ->
            P1 = lib_goods_buff:remove_skill_buff(Player, 21000001),
            P2 = lib_goods_buff:remove_skill_buff(P1, 240100101),
            P2
    end.

%% 只能修复领取一次的活动奖励
repair_consume_act_rewards() ->
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_CONSUME, 1) of
        #act_info{stime = StartTime,etime = _EndTime} ->
            SQL = io_lib:format("SELECT `role_id`, `grade` FROM `custom_act_receive_reward` WHERE `utime` >= ~p AND `utime` < ~p AND  `receive_times` = 1", [StartTime, utime:unixtime() - 60]),
            All = db:get_all(SQL),
            InfoByRoles = lists:foldl(fun ([RoleId, Grade], Acc) ->
                                        case lists:keyfind(RoleId, 1, Acc) of
                                            false ->
                                                [{RoleId, [Grade]}|Acc];
                                            {RoleId, List} ->
                                                lists:keystore(RoleId, 1, Acc, {RoleId, [Grade|List]})
                                        end
                                      end, [], All),
            spawn(fun () ->
                [
                    begin
                        try_repair_consume_act_rewards(Item, StartTime, utime:unixtime() - 60),
                        timer:sleep(1000)
                    end || Item <- InfoByRoles
                ]
                  end),
            ok
    end.

try_repair_consume_act_rewards({RoleId, GradeIds}, StartTime, EndTime) ->
    Rewards = lists:foldl(
        fun (Id, Rewards) ->
            case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_CONSUME, 1, Id) of
                #custom_act_reward_cfg{reward = [{_, Ls}|_]} ->
                    [Ls ++ Rewards];
                _ ->
                    Rewards
            end
        end
    , [], GradeIds),
    MergedRewards = lib_goods_api:make_reward_unique(Rewards),
    SQL = io_lib:format("SELECT `goods_id`, `goods_num` FROM `log_goods` WHERE `player_id` = ~p AND `time` >= ~p AND `time` < ~p AND `type` = 92 AND `subtype`=30", [RoleId, StartTime, EndTime]),
    All = db:get_all(SQL),
    {ErrGoods, _}
    = lists:foldl(fun ([GoodsId, GoodsNum], [Err, GotList]) ->
        case calc_minus_goods(GotList, GoodsId, GoodsNum, []) of
            {ok, LeftList} ->
                {Err, LeftList};
            {error, Num, LeftList} ->
                {[[GoodsId, Num]|Err], LeftList}
        end
    end, {[], MergedRewards}, All),
    case [{0, GoodsId, GoodsNum} || [GoodsId, GoodsNum] <- ErrGoods] of
        [] ->
            ok;
        GoodsList ->
            Title = utext:get(3310077),
            Content = utext:get(3310078),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, GoodsList)
    end.

calc_minus_goods([], _, Num, LeftList) when Num > 0 -> {error, Num, LeftList};

calc_minus_goods([{?TYPE_GOODS, GoodsId, Num}|T], GoodsId, Num, L) ->
    {ok, L ++ T};
calc_minus_goods([{?TYPE_GOODS, GoodsId, N}|T], GoodsId, Num, L) when N > Num->
    {ok, L ++ [{?TYPE_GOODS, GoodsId, N - Num}|T]};
calc_minus_goods([{?TYPE_GOODS, GoodsId, N}|T], GoodsId, Num, L) when N < Num->
    calc_minus_goods(T, GoodsId, Num - N, L);
calc_minus_goods([X|T], GoodsId, Num, L) ->
    calc_minus_goods(T, GoodsId, Num, [X|L]).


clear_dun_enter_count(PlayerId, DunId) ->
    lib_dungeon:clear_dun_enter_count(PlayerId, DunId).

gm_setup_vip(RoleId, VipExp, EndTime) ->
    lib_vip:gm_setup_vip(RoleId, VipExp, EndTime).

repair_dungeon(ListStr, IsLocal, MailContentStr) ->
    List = util:string_to_term(ListStr),
    MailContent = unicode:characters_to_list(list_to_binary(MailContentStr), unicode),
    case util:is_cls() of
        true ->
            spawn( fun() ->
                [begin
                     SerId = mod_player_create:get_serid_by_id(RoleId),
                     mod_clusters_center:apply_cast(SerId, ?MODULE, repair_dungeon, [RoleId, DunId, Count, MailContent]),
                     timer:sleep(100)
                 end || {RoleId, DunId, Count} <- List]
                end),
            ok;
        false when IsLocal == 1 ->
            spawn( fun() ->
                    [begin
                         repair_dungeon(RoleId, DunId, Count, MailContent),
                         timer:sleep(100)
                     end || {RoleId, DunId, Count} <- List]
                   end),
            ok;
        _ ->
            skip
    end.

repair_dungeon(RoleId, DunId, Count, MailContent) ->
    case lib_player:is_id_exists(RoleId) of
        true ->
            lib_dungeon:repair_dungeon(RoleId, DunId, Count, MailContent);
        _ ->
            skip
    end.

repair_3v3() ->
    lib_3v3_local:fix_bug().

%% 删除玩家遗留在神庙的旧数据d
delete_temple_scene_user()->
    [D#ets_online.pid ! {'delete_temple_scene_user', 1351} || D <- ets:tab2list(?ETS_ONLINE)],
    ok.

%% 移除圣者殿称号
gm_remove_saint_dsgt() ->
    SQL = io_lib:format("SELECT `player_id`, `id` FROM `designation` WHERE `id` IN (400024, 400025, 400026, 400027)", []),
    L = [{RoleId, DsgtId}  || [RoleId, DsgtId] <- db:get_all(SQL) ],
    ServerId = config:get_server_id(),
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_saint, apply_cast, [mod_saint, gm_remove_saint_dsgt, [ServerId, Node, L]]),
    ok.

%% 世界boss生成怪物秘籍
gm_create_local_boss(BossId)->
    lib_boss:gm_create_local_boss(BossId).

gm_confirm_kfgwar_join_guild() ->
    mod_kf_guild_war_local:gm_confirm_kfgwar_join_guild().

%% 补回婚宴次数给旧的玩家
gm_restore_old_player_wedding_times() ->
    lib_marriage:gm_restore_old_player_wedding_times(),
    ok.

gm_restore_sell_equip_info() ->
    lib_sell:gm_restore_sell_equip_info(),
    ok.

%% 重新加载服务器名字
%% 重新加载服务器名字
reload_server_name()->
    %% 游戏服名字
    case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'game_title'">>) of
        [ServerName] ->
            ServerId = config:get_server_id(),
            lib_server_kv:update_server_kv_to_ets(?SKV_SERVER_NAME, ServerName, utime:unixtime()),
            mod_zone_mgr:server_name_change(ServerId, ServerName),
            mod_clusters_node:server_name_change(),
            Data = ets:tab2list(?ETS_ONLINE),
            [gen_server:cast(D#ets_online.pid, {'refresh_ser_name', ServerName}) || D <- Data],
            mod_clusters_node:apply_cast(mod_kf_chrono_rift, change_server_name, [config:get_server_id(), ServerName]),
            mod_clusters_node:apply_cast(mod_zone_mgr, calc_zone_mod, []),
            %mod_clusters_node:apply_cast(mod_nine_center, partition_group, []),
            mod_clusters_node:apply_cast(mod_territory_war, timer_check, []),
            mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, re_alloc_group, []),
            ok;
        _ ->
            reload_err
    end.

%% 重新加载客户端展示的服信息
reload_c_server_msg() ->
    %% 游戏服名字
    case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'c_server_msg'">>) of
        [CServerMsg] ->
            lib_server_kv:update_server_kv_to_ets(?SKV_C_SERVER_MSG, CServerMsg, utime:unixtime()),
            % 更新玩家服信息
            Data = ets:tab2list(?ETS_ONLINE),
            [gen_server:cast(D#ets_online.pid, {'reload_c_server_msg', CServerMsg}) || D <- Data],
            ok;
        _ ->
            reload_err
    end.

%% 重新加载服类型
reload_server_type() ->
    %% 游戏服名字
    case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'server_type'">>) of
        [<<>>] -> reload_err;
        [ServerType0] ->
            case catch binary_to_integer(ServerType0) of
                ServerType when is_integer(ServerType) -> 
                    lib_server_kv:update_server_kv_to_ets(?SKV_SERVER_TYPE, ServerType, utime:unixtime()),
                    Data = ets:tab2list(?ETS_ONLINE),
                    [gen_server:cast(D#ets_online.pid, {'reload_server_type', ServerType}) || D <- Data],
                    ok;
                _ -> 
                    0
            end;
        _ ->
            reload_err
    end.

%% 更新客户端展示的服信息
update_c_server_msg(CServerMsg) ->
    CServerMsgBin = util:make_sure_binary(CServerMsg),
    % 不存在才插入，防止 base_game 增加字段导致覆盖
    case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'c_server_msg'">>) of
        [_OldCServerMsg] -> db:execute(io_lib:format(<<"update base_game set `cf_value`='~s' where `cf_name` = 'c_server_msg'">>, [CServerMsgBin]));
        _ -> db:execute(io_lib:format(<<"replace into `base_game`(`cf_name`, `cf_value`) values('c_server_msg', '~s')">>, [CServerMsgBin]))
    end,
    reload_c_server_msg().

gm_change_role_name(RoleId, Name) when is_integer(RoleId) ->
    ?INFO("RoleId:~p Name:~p ~n", [RoleId, Name]),
    PlayerPid = misc:get_player_process(RoleId),
    case misc:is_process_alive(PlayerPid) of
        true ->
            case lib_player:apply_call(PlayerPid, ?APPLY_CALL_SAVE, lib_rename, gm_change_role_name, [Name]) of
                ok -> ok;
                {error, _Code} ->
                    ?INFO("RoleId:~p _Code:~p ~n", [RoleId, _Code]),
                    {error, _Code};
                _Err -> 
                    ?INFO("RoleId:~p _Err:~p ~n", [RoleId, _Err]),
                    {error, _Err}
            end;
        _ ->
            case pp_rename:validate_name(Name) of  %% 角色名合法性检测
                {false, _Msg} ->
                    ?INFO("RoleId:~p _Msg:~p ~n", [RoleId, _Msg]),
                    {error, _Msg};
                true -> 
                    case lib_rename:change_name(RoleId, Name, 1) of
                        1 -> ok;
                        _R -> 
                            ?INFO("RoleId:~p _R:~p ~n", [RoleId, _R]),
                            {error, _R}
                    end
            end
    end;
gm_change_role_name(_, _) -> {error, 0}.


gm_add_eudemons_exp_all() ->
    spawn(fun() -> lib_eudemons_land:gm_add_eudemons_exp_all() end),
    ok.

%% 重新加载邮件
%% @param RoleIdL [RoleId,...]
reload_mail(RoleIdL) ->
    OnlineRoleIdL = [RoleId||#ets_online{id = RoleId}<-ets:tab2list(?ETS_ONLINE), lists:member(RoleId, RoleIdL)],
    spawn(fun() ->
        F = fun(RoleId) ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_mail, reload_mail, []),
            timer:sleep(500)
        end,
        lists:foreach(F, OnlineRoleIdL)
    end),
    ?INFO("reload_mail RoleIdL:~w ~n", [RoleIdL]),
    ok.

%% 重新加载物品
%% @param RoleIdL [RoleId,...]
reload_goods(RoleIdL) ->
    OnlineRoleIdL = [RoleId||#ets_online{id = RoleId}<-ets:tab2list(?ETS_ONLINE), lists:member(RoleId, RoleIdL)],
    spawn(fun() ->
        F = fun(RoleId) ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_goods, reload_goods, []),
            timer:sleep(500)
        end,
        lists:foreach(F, OnlineRoleIdL)
    end),
    ?INFO("reload_goods RoleIdL:~w ~n", [RoleIdL]),
    ok.

%% 输出战力属性
gm_log_attr(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_php_api, gm_log_attr, []);
gm_log_attr(Player) ->
    CounPlayer = lib_player:count_player_attribute(Player, logout_log_server_stop),
    {ok, CounPlayer}.

%% 重新划分小跨服
recalc_zones() -> 
    case config:get_cls_type() of
        ?NODE_CENTER -> mod_zone_mgr:recalc_all();
        _   -> not_center
    end.

%% 修复竞技场pk状态
fix_jjc_battle_status(RoleId) ->
    mod_jjc:cast_to_jjc(fix_jjc_battle_status, [RoleId]).

fix_jjc_battle_status_all() ->
    mod_jjc:cast_to_jjc(fix_jjc_battle_status, []).

force_fix_jjc_battle_status(RoleId) ->
    mod_jjc:cast_to_jjc(force_fix_jjc_battle_status, [RoleId]).

manual_send_festival_investment_reward_all(Type, SubType) ->
    spawn(fun() ->
        lib_festival_investment:act_clear_manual(Type, SubType)
    end),
    ok.

%% 通知处理
%% 1:重新请求公告cdn的版本号对比是否下载
notify_handle(Type) ->
    {ok, BinData} = pt_102:write(10207, [Type]),
    lib_server_send:send_to_all(BinData),
    ok.

%% 嗨点重载
hi_point_reload(SubType) ->
    mod_hi_point:reload(SubType).

%% 修复扫荡赏金任务嗨点数据
gm_add_hi_af_sweep_bounty_task(StartTime, EndTime) ->
    %% 查询出所有需要处理的玩家
    Sql = io_lib:format(<<"select role_id, count from `log_sweep_bounty_task` where time >= ~w and time <= ~w">>, [
      StartTime, EndTime]),
    FinishList = db:get_all(Sql),
    FinishList2 = [{Rid, Count} || [Rid, Count] <- FinishList],
    %% 获取在线的玩家列表，逐个处理
    OnlineList = ets:tab2list(?ETS_ONLINE),
    RoleIdList = [RoleId || #ets_online{id = RoleId} <- OnlineList],
    spawn(fun() -> gm_add_hi_af_sweep_bounty_task_helper(FinishList2, RoleIdList) end),
    ok.
  
gm_add_hi_af_sweep_bounty_task_helper(FinishList2, RoleIdList) ->
    %% 休眠0.5秒
    timer:sleep(500),
    F = fun(Id) ->
        case lists:keyfind(Id, 1, FinishList2) of
          false -> skip;
          {_, Count} ->
            %% 更新
            lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_hi_point_api, hi_point_task_daliy, [Count])
        end
    end,
    lists:foreach(F, RoleIdList).

contract_challenge_soul(SubType) ->
    mod_contract_challenge:fix_soul_dungeon(SubType).

cancel_lenged_contract(SubType, RoleId) ->
    mod_contract_challenge:cancel_lenged_contract(SubType, RoleId).

add_contract_point(SubType, Point, RoleId) ->
    mod_contract_challenge:add_point(SubType, Point, RoleId).

send_mail_reward(Title, Content, Type, CurrencyId, Num, RoleId) ->
    lib_mail:send_sys_mail([RoleId], Title, Content, [{Type, CurrencyId, Num}]).

load_contract_buff() ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_contract_challenge, login, []) || #ets_online{id = RoleId} <- OnlineList].


%% 根据副本id重置符文宝塔
gm_clear_rune_dun_enter_count(RoleId, DunId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon_rune, gm_clear_rune_dun_enter_count_help, [DunId]),
    ok.

%% 修复海域功勋异常
fix_exploit(0) ->
    Onlines = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_extra_api, gm_fix_exploit, [])||#ets_online{id = RoleId}<-Onlines];
fix_exploit(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_extra_api, gm_fix_exploit, []).

%% 重启进程
restart_process(Mod) ->
    ?INFO("restart_process Mod:~p Mod:~p ~n", [Mod, util:string_to_term(Mod)]),
    Terminate = supervisor:terminate_child(gsrv_sup, util:string_to_term(Mod)),
    Restart = supervisor:restart_child(gsrv_sup, util:string_to_term(Mod)),
    {Terminate, Restart}.

start_child_process(MFAStr) ->
    ?INFO("start_child_process MFAStr:~p MFAStr:~p ~n", [MFAStr, util:string_to_term(MFAStr)]),
    {Mod, _Fun, _Args} = H = util:string_to_term(MFAStr),
    {ok, _} = supervisor:start_child(gsrv_sup, {H, H, permanent, 10000, worker, [Mod]}),
    ok.

%% 跨服通知所有的游戏更新屏蔽词
%% OpType:操作类型(1:全部 2:添加 3:删除)
cls_notify_filter_words_update(OpType) ->
    case util:is_cls() of
        false -> skip;
        true ->
            FilterWordChannel =
                case db:get_row(<<"select `cf_value` from base_game where `cf_name` = 'filter_word_channel'">>) of
                    [FWC] -> FWC;
                    _ -> 0
                end,
            ?PRINT("FilterWordChannel:~p~n", [FilterWordChannel]),
            mod_clusters_center:apply_to_all_node(lib_php_api,
                notify_filter_words_update, [FilterWordChannel, OpType], 5000), 
            ok
    end.

%% 单服更新屏蔽词
%% OpType:操作类型(1:全部 2:添加 3:删除)
notify_filter_words_update(0, OpType) -> 
    ?ERR("notify_filter_words_update_ok~n", []),
    mod_word:php_notify_update_words(OpType);
notify_filter_words_update(ClsWordChannel, OpType) ->
    ?PRINT("ClsWordChannel:~p~n", [ClsWordChannel]),
    case lib_word:check_use_where_filter_word() of
        ClsWordChannel -> skip;
        GameWordChannel ->
            ?ERR("GameWordChannel, ClsWordChannel:~p~n", [[GameWordChannel, ClsWordChannel]]),
            ?PRINT("GameWordChannel, ClsWordChannel:~p~n", [[GameWordChannel, ClsWordChannel]]),
            SQL = io_lib:format(<<"update base_game set `cf_value` = '~s' where `cf_name` = 'filter_word_channel'">>, [ClsWordChannel]),
            % ets:insert(?SERVER_STATUS, #server_status{name = filter_word_channel, value = ClsWordChannel}),
            lib_server_kv:update_server_kv_to_ets(?SKV_FILTER_WORD_CHANNEL, ClsWordChannel, utime:unixtime()),
            db:execute(SQL)
    end,
    lib_word:request_remote_filter_words(ClsWordChannel, OpType),
    ?ERR("notify_filter_words_update_ok ClsWordChannel:~p ~n", [ClsWordChannel]),
    ok.

%% 获取玩家所有被动技能列表
get_role_passive_skill(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, get_role_passive_skill, []);
get_role_passive_skill(Player) when is_record(Player, player_status) ->
    SkillList = lib_skill:get_skill_passive(Player),
    ?INFO("SkillList:~p~n",[SkillList]),
    ok;
get_role_passive_skill(_) -> error.

%% 打印玩家的战力属性battle_attr
output_ets_user(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_php_api, output_ets_user_help, []).

output_ets_user_help(Ps) ->
    #player_status{id = RoleId, scene = SceneId, scene_pool_id = PoolId} = Ps,
    EtsUser = mod_scene_agent:apply_call(SceneId, PoolId, lib_scene_agent, get_user, [RoleId]),
    lib_log_api:log_game_error(RoleId, 3, EtsUser),
    ok.


%% 设置玩家战斗属性
set_ets_user(RoleId, EtsUserStrOld) ->
    EtsUserStr = re:replace(EtsUserStrOld, "\\<\\d+.\\d+.\\d+\\>,", "0,", [global, {return, list}]),
    EtsUser = util:string_to_term(EtsUserStr),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_php_api, set_ets_user_help, [EtsUser]).

set_ets_user_help(Ps, EtsUser) ->
    #player_status{
        id = RoleId
        , sid = Sid
        , pid = Pid
        , scene = SceneId
        , scene_pool_id = PoolId
    } = Ps,
    %% 修正ets_user记录个别数据
    NewEtsUser = EtsUser#ets_scene_user{
        id = RoleId
        , sid = Sid
        , pid = Pid  
    },
    mod_scene_agent:update(SceneId, PoolId, RoleId, [{ets_scene_user, NewEtsUser}]),
    NewPs = Ps#player_status{battle_attr = NewEtsUser#ets_scene_user.battle_attr},
    pp_player:handle(13001, NewPs, []),
    {ok, NewPs}.

fix_supreme_vip_goods_skill(PlayerId, Num) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, collect_demons_goods, [{add, Num}]).


repair_cumulation_data() ->
    % 小于2021.10.12日之前的数据，1代表已经领取，进行更改
    SQL = io_lib:format("update recharge_cumulation_reward set state = 2 where state = 1 and time < 1634054400", []),
    db:execute(SQL), 
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [
        lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_recharge_cumulation, update_daily, [])
        || #ets_online{id = PlayerId} <- OnlineList
    ].

%% 查看服务器有没有成功启动
check_is_open() ->
    Platform = config:get_platform(),
    ServerNum = config:get_server_num(),
    {{is_open, true}, {platform, list_to_atom(Platform)}, {server, ServerNum}}.

%% 返回真是在线玩家和离线挂机玩家人数 {OnlineNum, OnhookNum}
get_online_num() ->
    mod_chat_agent:get_online_num().

%% 更新玩家战力##只处理战力等于0的
update_player_state_power(CombatPower) ->
    Sql = io_lib:format(<<"update player_state set last_combat_power = ~p where last_combat_power = 0">>, [CombatPower]),
    db:execute(Sql).

%% 输出玩家被动列表
info_player_passive_skill(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, info_player_passive_skill, []);
info_player_passive_skill(Player) ->
    #player_status{id = RoleId} = Player,
    PassiveSkillL = lib_skill:get_skill_passive(Player),
    ?INFO("RoleId ~p PassiveSkillL ~p ~n", [RoleId, PassiveSkillL]).


gm_mon_statistics() ->
  ProcessName = 'gm_mon_statistics_pid',
  OldPid = whereis(ProcessName),
  case misc:is_process_alive(OldPid) of
    true -> OldPid ! 'print';
    _ ->
      Pid = spawn( fun gm_mon_statistics_pid/0 ),
      erlang:register(ProcessName, Pid),
      AllProcess = erlang:processes(),
      F_send = fun(Process) ->
        case tool:get_proc_initial_call(Process) of
          {mod_mon_active, init, 1} ->  catch Process ! {'gm_statistics', Pid};
          _ -> skip
        end
      end,
      lists:foreach(F_send, AllProcess)
  end.

gm_mon_statistics_pid() ->
  gm_mon_statistics_pid_do(#{}, #{}, #{}, #{}).

gm_mon_statistics_pid_do(Map1, Map2, Map3, Map4) ->
  receive
    {'gm_statistics', ConfigId, SceneId, ScenePoolId, CopyId} ->
      Num1 = maps:get(ConfigId, Map1, 0),
      NewMap1 = Map1#{ConfigId => Num1 + 1},
      Num2 = maps:get({ConfigId, SceneId}, Map2, 0),
      NewMap2 = Map2#{{ConfigId, SceneId} => Num2 + 1},
      Num3 = maps:get({ConfigId, SceneId, ScenePoolId}, Map3, 0),
      NewMap3 = Map3#{{ConfigId, SceneId, ScenePoolId} => Num3 + 1},
      Num4 = maps:get({ConfigId, SceneId, ScenePoolId, CopyId}, Map4, 0),
      NewMap4 = Map4#{{ConfigId, SceneId, ScenePoolId, CopyId} => Num4 + 1},
      gm_mon_statistics_pid_do(NewMap1, NewMap2, NewMap3, NewMap4);
    'print' ->
      ?INFO("~p ~n", [Map1]),
      ?INFO("~p ~n", [Map2]),
      ?INFO("~p ~n", [Map3]),
      ?INFO("~p ~n", [Map4]),
      ok;
    _ ->
      gm_mon_statistics_pid_do(Map1, Map2, Map3, Map4)
  after 3600000 ->
    ok
  end.

gm_fix_dungeon_times(BeginTime, EndTime) ->
    Sql = io_lib:format("select pid, goods_num from log_throw where goods_id = 38030001 and time between ~p and ~p", [BeginTime, EndTime]),
    List = db:get_all(Sql),
    F_cal = fun([RoleId, GoodsNum], AccMap) ->
        Times = maps:get(RoleId, AccMap, 0),
        AccMap#{RoleId => GoodsNum + Times}
    end,
    Map = lists:foldl(F_cal, #{}, List),

    Title = <<"经验副本异常补偿"/utf8>>,
    Content = <<"尊敬的御灵师您好，系统检测到您在经验副本中获取经验异常，现为您补发经验副本异常的次数和对应补偿奖励，请查收"/utf8>>,

    F_reward = fun(RoleId, Times) ->
        VipBuyT = mod_daily:get_count_offline(RoleId, 610, 4, 20),
        EnterT = mod_daily:get_count_offline(RoleId, 610, 1, 20),

        NEnterT = max(EnterT - Times, 0),
        mod_daily:set_count_offline(RoleId, 610, 1, 20, NEnterT),
        case Times > 2 of
            true ->
                NewVipBuyT = max(VipBuyT - (Times - 2), 0),
                Reward = [{?TYPE_BGOLD, 0, 100 * (Times - 2)}, {?TYPE_GOODS, 38030001, Times}],
                mod_daily:set_count_offline(RoleId, 610, 4, 20, NewVipBuyT);
            _ ->
                Reward = [{?TYPE_GOODS, 38030001, Times}]
        end,
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_php_api, gm_fix_dungeon_times_info, []),
        mod_mail_queue:add(gm, [RoleId], Title, Content, Reward)
    end,
    maps:map(F_reward, Map).

gm_fix_dungeon_times_info(PS) -> pp_dungeon:handle(61020, PS, [20]).
