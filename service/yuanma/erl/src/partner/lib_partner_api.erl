%%%-----------------------------------------------------------------------------
%%%	@Module  : lib_partner_api
%%% @Author  : liuxl
%%% @Email   : liuxingli@suyougame.com
%%% @Created : 2016-12-13
%%% @Description : 伙伴
%%%-----------------------------------------------------------------------------
-module(lib_partner_api).

-include("server.hrl").
-include("partner.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("team.hrl").

-export([
	create_partner/2,
	give_partner/3,
	add_partner_exp/2,
	get_battle_partners/1,
    get_partner_embattle/0,			%% 获取玩家伙伴布阵
    get_partner_embattle_2/0,
    get_partner_embattle_2_core/2
	]).

create_partner(Status, [PartnerId]) ->
	#player_status{scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y} = Status,
	case lib_partner:give_partner(Status, PartnerId, gm, 0) of 
		{true, Partner, NewPS} ->
            %Args = [ {skill_owner, #skill_owner{id=Status#player_status.id, pid=Status#player_status.pid, sign=?BATTLE_SIGN_PLAYER} }],
            Args = [],
			lib_scene_object:sync_create_a_partner(SceneId, PoolId, X+100, Y, 0, CopyId, 1, Partner, Args),
			NewPS;
		{false, _Res, NewPS} -> NewPS
	end.

give_partner(PlayerId, PartnerId, GiveType) ->
	case misc:get_player_process(PlayerId) of
        Pid when is_pid(Pid) ->        
            case misc:is_process_alive(Pid) of 
                true -> 
                    gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST_SAVE, lib_partner, give_partner, [PartnerId, GiveType, 0]});
                false -> 
                    ?ERR("give_partner not found player process, RoleId:~p~n",[PlayerId])
            end;        
         _ ->
            false
    end.

add_partner_exp(PS, Exp) ->
	PartnerSt = lib_partner_do:get_partner_status(),
	PartnerMap = PartnerSt#partner_status.partners,
	PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
	PartnerList = maps:to_list(PartnerMap1),
	Fun = fun({_Id, Partner}, {PlayerStatus, OldPartnerSt}) ->
		case data_partner:get_lv_upgrade(Partner#partner.lv) of 
			#base_partner_upgrade{percentage = Percentage} ->
				AddExp = Exp * Percentage div 100,
				case lib_partner:add_exp(PlayerStatus, OldPartnerSt, Partner, AddExp) of 
					{true, NewPS, NewPartnerSt, _NewPartner} -> {NewPS, NewPartnerSt};
					{false, _Res, NewPS} -> {NewPS, OldPartnerSt}
				end;
			_ ->
				PlayerStatus
		end
	end,
	{_NewPlayerStatus, NewPartnerStatus} = lists:foldl(Fun, {PS, PartnerSt}, PartnerList),
	lib_partner_do:set_partner_status(NewPartnerStatus),
	ok.

% 获取玩家上阵的伙伴
get_battle_partners(_PS) ->
	PartnerSt = lib_partner_do:get_partner_status(),
	PartnerMap = PartnerSt#partner_status.partners,
	PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
	maps:values(PartnerMap1).

% 获取伙伴布阵 
get_partner_embattle() ->
	PartnerSt = lib_partner_do:get_partner_status(),
	PartnerSt#partner_status.embattle.

% 获取伙伴布阵 
get_partner_embattle_2() ->
	PartnerSt = lib_partner_do:get_partner_status(),
	PlayerId = PartnerSt#partner_status.pid,
	EmbattleList = PartnerSt#partner_status.embattle,
	get_partner_embattle_2_core(PlayerId, EmbattleList).

get_partner_embattle_2_core(PlayerId, EmbattleList) ->
	F = fun(#rec_embattle{type = Type, pos = Pos}, {Find, List}) when Find == false ->
		case Type of 
			?BATTLE_SIGN_PARTNER -> {Find, lists:delete(Pos, List)};
			?BATTLE_SIGN_PLAYER -> {ok, List}
		end;
		(_ , {Find, List}) -> {Find, List}
	end,
	case lists:foldl(F, {false, [1,2,3,4,5,6]}, EmbattleList) of 
		{false, [InsertPos|_List]} ->
			lists:keystore({?BATTLE_SIGN_PLAYER,PlayerId}, #rec_embattle.key, EmbattleList, 
					#rec_embattle{key={?BATTLE_SIGN_PLAYER,PlayerId}, pos = InsertPos,type = ?BATTLE_SIGN_PLAYER, id = PlayerId});
		{_, _} -> EmbattleList
	end.