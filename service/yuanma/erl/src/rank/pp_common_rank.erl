%%%------------------------------------
%%% @Module  : pp_common_rank
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------

-module(pp_common_rank).

-compile(export_all).

-include("def_module.hrl").
-include("common_rank.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("flower.hrl").
-include("mount.hrl").
-include("pet.hrl").
-include("wing.hrl").
-include("fashion.hrl").
-include("talisman.hrl").
-include("godweapon.hrl").
-include("marriage.hrl").
-include("def_fun.hrl").
-include("holy_ghost.hrl").
-include("house.hrl").
-include("jjc.hrl").
-include("dungeon.hrl").
-include("goods.hrl").
-include("def_goods.hrl").

handle(22101, Player, [RankType, Start, Len]) ->
    %?PRINT(" 22101 RankType:~p Start:~p , Len:~p ~n", [RankType,Start, Len]),
    case RankType of
        ?RANK_TYPE_COMBAT -> % 战力榜
            SelValue = Player#player_status.combat_power,
            SelSecValue = 0;
        ?RANK_TYPE_LV ->     % 等级榜
            SelValue = Player#player_status.figure#figure.lv,
            SelSecValue = 0;  %?MOUNT_ID, ?MATE_ID, ?FLY_ID, ?ARTIFACT_ID, ?HOLYORGAN_ID, ?SPIRIT_ID, ?PET_ID
        ?RANK_TYPE_MOUNT ->  % 坐骑榜
            SelValue = lib_common_rank:get_combat_upgrade(?MOUNT_ID, Player),
            SelSecValue = lib_mount:get_status_stage(?MOUNT_ID, Player);
        ?RANK_TYPE_FLYPET ->    % 飞宠榜
            SelValue = lib_common_rank:get_combat_upgrade(?PET_ID, Player),
            SelSecValue = lib_mount:get_status_stage(?PET_ID, Player);
        ?RANK_TYPE_WING ->   % 翅膀榜
            SelValue = lib_common_rank:get_combat_upgrade(?FLY_ID, Player),
            SelSecValue = lib_mount:get_status_stage(?FLY_ID, Player);
        ?RANK_TYPE_MATE ->   % 伙伴榜
            SelValue = lib_common_rank:get_combat_upgrade(?MATE_ID, Player),
            SelSecValue = lib_mount:get_status_stage(?MATE_ID, Player);
        ?RANK_TYPE_AIRCRAFT ->% 神器榜
            SelValue = lib_common_rank:get_combat_upgrade(?ARTIFACT_ID, Player),
            SelSecValue = lib_mount:get_status_star(?ARTIFACT_ID, Player);
        ?RANK_TYPE_HOLYORGAN ->% 圣器榜
            SelValue = lib_common_rank:get_combat_upgrade(?HOLYORGAN_ID, Player),
            SelSecValue = lib_mount:get_status_star(?HOLYORGAN_ID, Player);
        ?RANK_TYPE_SPIRIT ->%精灵榜
            SelValue = 0,
            SelSecValue = 0;
        ?RANK_TYPE_JUEWEI -> % 爵位榜
            % SelValue = Player#player_status.figure#figure.achiv_stage,
            % AchivPointList = Player#player_status.status_achievement,
            SelSecValue = lib_goods_api:get_currency(Player, ?GOODS_ID_ACHIEVE),
            SelValue = Player#player_status.figure#figure.achiv_stage;
            % SelSecValue = lib_achievement_api:get_cur_stage_offline(AchivPointList);
        ?RANK_TYPE_TOWER_DUN ->
            SelValue = lib_dungeon_tower:get_dungeon_level(Player, ?DUNGEON_TYPE_TOWER),
            %?PRINT("SelValue:~p~n",[SelValue]),
            SelSecValue = 0;
        ?RANK_TYPE_JJC  ->
%%            #real_role{rank = Rank} = lib_jjc:get_db_real_role(Player#player_status.id),
            {ok, #real_role{rank = Rank}} = mod_jjc:role_rank(Player#player_status.id),
            SelValue = Rank,
            SelSecValue = 0;
        ?RANK_TYPE_EQUIPMENT ->
            SelValue = lib_equip:get_all_equip_rating(Player),
            SelSecValue = 0;
        ?RANK_TYPE_AFK ->
            SelValue = lib_afk_api:get_minus_afk_exp(Player),
            SelSecValue = 0;
        _ ->
            SelValue = Player#player_status.combat_power,
            SelSecValue = 0
    end,
    %?PRINT("id:~p,SelValue:~p, SelSecValue:~p~n",[Player#player_status.id,SelValue, SelSecValue]),
    mod_common_rank:send_rank_list(RankType, Start, Len, Player#player_status.id, SelValue, SelSecValue);


%%======================================================================================
%% 公会排行榜和膜拜被剥离出排行榜！！！
%%======================================================================================
% handle(22102, Player, [RankType, Start, Len]) when RankType == ?RANK_TYPE_GUILD ->
%     %?PRINT(" 22101 RankType:~p Start:~p , Len:~p ~n", [RankType,Start, Len]),
%     #player_status{id = RoleId, figure = Figure} = Player,
%     mod_common_rank:send_rank_list(RankType, Start, Len, RoleId, Figure#figure.guild_id, 0);

% handle(22103, Player, _Data) ->
%     #player_status{sid = Sid, id = RoleId} = Player,
%     Value = mod_daily:get_count(RoleId, ?MOD_RANK, 1),
%     %?PRINT("Value:~p~n",[Value]),
%     Num = max(?MAX_PRAISE_NUM - Value, 0),
%     %?PRINT("~p, ~p ~n", [Value, Num]),
%     {ok, BinData} = pt_221:write(22103, [?SUCCESS, Num]),
%     lib_server_send:send_to_sid(Sid, BinData);

% handle(22104, Player, [OtRoleId]) ->
% %PRINT(" 22101 RankType:~p Start:~p , Len:~p ~n", []),
%     #player_status{id = RoleId} = Player,
%     Value = mod_daily:get_count(RoleId, ?MOD_RANK, 1),
%     Num = max(?MAX_PRAISE_NUM - Value, 0),
%     if
%         Num =< 0 -> NewPlayerStatus = Player;
%         true ->
%             mod_daily:increment(RoleId, ?MOD_RANK, 1),
%              % ?PRINT("~p~n", [Num]),
%             mod_common_rank:rank_praise(RoleId, OtRoleId),
%             #worship_award_cfg{award = AwardL} = data_ranking:get_worship_cfg(200),
%             case lib_goods_api:can_give_goods(Player, AwardL) of
%                 true ->
%                     Produce = #produce{type = worship_reward, subtype = 0, reward = AwardL, remark = "", show_tips = 1},
%                     NewPlayerStatus = lib_goods_api:send_reward(Player, Produce);
%                 false ->
%                     NewPlayerStatus = Player
%             end
%     end,
%     {ok, NewPlayerStatus};

handle(22105, Player, _) ->
    #player_status{id = RoleId, combat_power = Combat, figure = Figure} = Player,
    mod_common_rank:to_be_strong_info(RoleId, Figure, Combat);   

handle(_Cmd, _Player, _Data) ->
    ?PRINT(" Data:~p ~n", [_Data]),
    {error, "pp_common_rank no match~n"}.

