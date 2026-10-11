%%%-----------------------------------
%%% @Module      : lib_guild_feast_chect
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 九月 2018 11:08
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_guild_feast_chect).

-include("common.hrl").
-include("guild_feast.hrl").
-include("errcode.hrl").
-author("chenyiming").

%% API
-compile(export_all).

%%点击火苗之前的检查
collect_fire(#status_gfeast{gfeast_guild = GuildList, stage = Stage} = _State, RoleId, FireId, GuildId) ->
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		#gfeast_guild{} = Guild ->
			CheckList = [
				{check_stage, Stage, ?GUILD_FEAST_STAGE_FIRE},   %%是否篝火阶段
				{check_guild, RoleId, Guild},  %%玩家是否存在于公会中
				{check_have_get, RoleId, Guild}, %%玩家本轮是否已经点击了火苗
				{check_exist_fire, FireId, Guild}%%  是否存在这个火苗id
			],
			check_list(CheckList);
		false ->
			?DEBUG("Fail ~n", []),
			{false, ?FAIL}
	end.
%% -----------------------------------------------------------------
%% @desc     功能描述    这里主要是检查第三阶段的时候，龙魂不足不能够进入场景
%% @param    参数        GuildId::integer() 公会id,
%%                       State::#status_gfeast{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
enter_scene(GuildId,  #status_gfeast{stage =  ?GUILD_FEAST_STAGE_DRAGON, gfeast_guild = GuildList } = _State) ->
	case lists:keyfind(GuildId,  #gfeast_guild.guild_id,  GuildList) of
		#gfeast_guild{dragon_point =  _Point} ->
			CheckList = [
%%				{check_dragon_spirit,  Point}   %% 不用检查龙魂了
			],
			check_list(CheckList);
		false ->
			?DEBUG("Fail ~n", []),
			{false, ?FAIL}
	end;

enter_scene(_GuildId, #status_gfeast{gfeast_guild = _GuildList} = _State) ->
	true.


%%进入远古巨龙
enter_dragon(_GuildId, _Status) ->
	true.
%%	#status_gfeast{gfeast_guild =  GuildList} = Status,
%%	case lists:keyfind(GuildId,  #gfeast_guild.guild_id, GuildList) of
%%		#gfeast_guild{dragon_point = _Dragon} ->
%%			CheckList = [
%%%%				{check_dragon_spirit,  Dragon}   %%龙魂够不够 不用龙魂也能进入了
%%			],
%%			check_list(CheckList);
%%		false ->
%%			?DEBUG("Fail ~n", []),
%%			{false, ?FAIL}
%%	end.

%% 小游戏分数反馈
game_feedback({State, PlayerInfo, _GameType, _Score, _InfoList}) ->
    CheckList = [{is_game_finish, State, PlayerInfo}],
    case check_list(CheckList) of
        true -> true;
        {false, ErrCode} -> {false, ErrCode}
    end.

check_sensitive_quiz_answer() ->
    F = fun(QId, Acc) ->
        #gfeast_question_cfg{right_answer = RA} = data_guild_feast:get_question_cfg(QId),
        case mod_word:word_is_sensitive(RA) of
            true -> [QId | Acc];
            false -> Acc
        end
    end,
    lists:foldl(F, [], data_guild_feast:get_question_ids_by_type(2)).

check_list([]) ->
	true;
check_list([H | CheckList]) ->
	case check(H) of
		true ->
			check_list(CheckList);
		{false, Res} ->
			{false, Res}
	end.

%%公会玩家列表里是否有这个玩家
check({check_guild, RoleId, Guild}) ->
	#gfeast_guild{role_list = RoleList} = Guild,
	case lists:member(RoleId, RoleList) of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err402_no_in_act_scene)}
	end;
%%火苗列表是否存在这个id
check({check_exist_fire, FireId, Guild}) ->
	#gfeast_guild{fire_list = FireList} = Guild,
	case lists:keyfind(FireId, 1, FireList) of
		{FireId, _} ->
			true;
		false ->
			{false, ?ERRCODE(err402_no_exist_fire)}
	end;

%%玩家本轮是否已经获取了火苗
check({check_have_get, RoleId, Guild}) ->
	#gfeast_guild{get_fire_list = GetFireList} = Guild,
	case lists:member(RoleId, GetFireList) of
		false ->
			true;
		true ->
			{false, ?ERRCODE(err402_hava_fire)}  %%已经获得火苗
	end;

check({check_dragon_spirit,  Dragon}) ->
	DragonSpirit =  data_guild_feast:get_cfg(dragon_spirit),
	if
		Dragon >= DragonSpirit ->
			true;
		true ->
			{false, ?ERRCODE(err402_not_enough_dragon)}
	end;

%%阶段是否正确
check({check_stage, Stage,  Stage1}) ->
	if
		Stage == Stage1 ->
			true;
		true ->
			{false, ?ERRCODE(err402_error_stage)}
	end;

%% 小游戏是否结束
check({is_game_finish, State, PlayerInfo}) ->
    #status_gfeast{mini_game_rank = RankList} = State,
    #gfeast_player{id = RoleId} = PlayerInfo,
    #gfeast_rank_role{other_infos = InfoMap} = ulists:keyfind(RoleId, #gfeast_rank_role.role_id, RankList, #gfeast_rank_role{}),
    case maps:get('game_finished', InfoMap, false) of
        true ->
            {false, ?FAIL};
        false ->
            true
    end;

check(_H) ->
	true.