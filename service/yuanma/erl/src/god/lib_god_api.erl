%%%--------------------------------------
%%% @Module  : lib_god_api
%%% @Author  : zengzy 
%%% @Created : 2018-03-02
%%% @Description:  变身系统
%%%--------------------------------------
-module(lib_god_api).
-compile(export_all).
-export([

    ]).

-include("server.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("god.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").

%%获取玩家转生
get_role_trans(PS) when is_record(PS,player_status) ->
	#player_status{god=StatusGod} = PS,
	#status_god{trans=Trans,battle=Battle} = StatusGod,
	{Trans,get_battle_num(Battle)};
get_role_trans(Id)->
	Sql = io_lib:format("select trans,battle from god_role where role_id=~p",[Id]),
	case db:get_row(Sql) of
		[] -> {0,0};
		[Trans,Battle] -> 
			TermBattle = util:bitstring_to_term(Battle),
			{Trans,get_battle_num(TermBattle)}
	end.

%%获取上阵元神数量
get_battle_num(Battle)->
    F = fun({_Pos,GodId},Sum)->
        case GodId> 0 of
            true-> Sum + 1;
            false-> Sum
        end
    end,
    lists:foldl(F,0,Battle).

%%任务判断是否可接
task_is_filter(_Lv,Trans,Num,TaskId) ->
	Cfg = data_god:get_trans(Trans+1),
	if
%%		Lv < ?GOD_OPEN_LV -> false;
		Num =< 0 -> false;
		is_record(Cfg,base_trans) == false -> false;
		true->
			#base_trans{condition=Condition} = Cfg,
			case lists:keyfind(task,1,Condition) of
				false -> false;
				{task,TaskIds,_} ->
					lists:member(TaskId,TaskIds)
			end
	end.

%%获取上阵元神所有技能 [{SkillId,SkillLv}]
get_god_skill(PS)->
	#player_status{god=StatusGod} = PS,
	#status_god{trans=Trans,battle=Battle,god_list=GodList} = StatusGod,
	CanBattle = [{Pos, GodId}||{Pos, GodId} <-Battle, Pos>=1, Pos=<3],
	F = fun({_Pos,GodId},TmpGods)->
		case lists:keyfind(GodId,#god.id,GodList) of
			false-> TmpGods;
			#god{}=God-> [God|TmpGods];
			_ -> TmpGods
		end
	end,
	Gods = lists:foldl(F,[],CanBattle),
	TransSkill = get_trans_common_skills(Trans, []),
	%%转成{SkillId,SkillLv}
	CommonSkill = get_all_skills(TransSkill,[]),
	GodsSkill = get_skills(Gods,Trans,[]),
	CommonSkill ++ GodsSkill.

%%更新上阵元神场景对应技能 
get_god_scene_skill(StatusGod)->
	#status_god{trans=Trans,battle=Battle,god_list=GodList} = StatusGod,
	CanBattle = [{Pos, GodId}||{Pos, GodId} <-Battle, Pos>=1, Pos=<3],
	F = fun({_Pos,GodId},TmpMap)->
		case lists:keyfind(GodId,#god.id,GodList) of
			false-> TmpMap;
			#god{} = God-> 
				SkillList = get_skills([God],Trans,[]),
				maps:put(GodId,SkillList,TmpMap);
			_ -> TmpMap
		end
	end,
	SceneSkill = lists:foldl(F,#{},CanBattle),
	TransSkill = get_trans_common_skills(Trans, []),
	%%转成{SkillId,SkillLv}
	CommonSkill = get_all_skills(TransSkill,[]),
	StatusGod#status_god{trans_skill=CommonSkill, skill_list=SceneSkill}.

%%获取出战元神列表
get_enter_battle(StatusGod) when is_record(StatusGod, status_god) ->
	#status_god{battle = Battle} = StatusGod,
	get_enter_battle(Battle);	
get_enter_battle(BattleList) ->
	[{Pos, GodId}||{Pos, GodId} <-BattleList, GodId>0].

get_skills([],_Trans,SkillList)->SkillList;
get_skills([#god{id=GodId,skill=Skill}|T],Trans,SkillList) ->	
	#god_skill{self_skill=SelfSkill,talent_skill=TalentSkill} = Skill,
	RelateSkill = get_relate_skills(GodId,Trans,[]),
	AllSkill = RelateSkill ++ TalentSkill ++ SelfSkill,
	NSkillList = get_all_skills(AllSkill,SkillList),
	get_skills(T,Trans,NSkillList).

get_all_skills([],SkillList)-> SkillList;
get_all_skills([{SkillId,SkillLv,_Exp}|T],SkillList) ->
	get_all_skills(T, [{SkillId,SkillLv}|SkillList]).


%%转生关联技能
get_relate_skills(_GodId,0,SkillList) -> SkillList;
get_relate_skills(GodId,Trans,SkillList) ->
	case data_god:get_relate_skill_id(GodId,Trans) of
		[]-> get_relate_skills(GodId,Trans-1,SkillList);
		List when is_list(List)->
			NSkillList = get_relate_skills_list(List,SkillList),
			get_relate_skills(GodId,Trans-1,NSkillList);
		_ -> get_relate_skills(GodId,Trans-1,SkillList)
	end.

%%关联技能组合等级
get_relate_skills_list([],SkillList) -> SkillList;
get_relate_skills_list([SkillId|T],SkillList) ->
	get_relate_skills_list(T,[{SkillId,1,0}|SkillList]).

%%转生公共技能
get_trans_common_skills(0, SkillList) -> SkillList;
get_trans_common_skills(Trans, SkillList) ->
	case data_god:get_trans(Trans) of
		[]-> get_trans_common_skills(Trans-1, SkillList);
		#base_trans{skill=TransSkill}->
			NSkillList = get_relate_skills_list(TransSkill,SkillList),
			get_trans_common_skills(Trans-1,NSkillList);
		_ -> get_trans_common_skills(Trans-1, SkillList)
	end.	

%%增加天赋技能中的辅助技能
add_assist_skill(GodId,PS) when GodId>0 ->
	#player_status{id=RoleId, god = StatusGod, scene=Scene, scene_pool_id=ScenePoolId} = PS,
	#status_god{trans=Trans, god_list=GodList} = StatusGod,
	case lists:keyfind(GodId,#god.id,GodList) of
		false-> ok;
		#god{skill=Skill}->
			#god_skill{talent_skill=TSkill} = Skill,
			Args = {RoleId,Scene,ScenePoolId},
			%%转生公共技能的辅助技能释放
			TransSkill = get_trans_common_skills(Trans, []),
			add_assist_skill_help(TransSkill++TSkill,Args)
	end;
add_assist_skill(_GodId,_PS) -> ok.

add_assist_skill_help([],_Args) -> ok;
add_assist_skill_help([{SkillId,SkillLv,_Exp}|T], Args) ->
	case data_skill:get(SkillId, SkillLv) of
		#skill{type = Type} when Type == ?SKILL_TYPE_ASSIST ->
			{RoleId,Scene,ScenePoolId} = Args,
			lib_battle_api:assist_anything(Scene, ScenePoolId, ?BATTLE_SIGN_PLAYER, RoleId, ?BATTLE_SIGN_PLAYER, RoleId, SkillId, SkillLv),
			add_assist_skill_help(T,Args);
		_-> 
			add_assist_skill_help(T,Args)
	end.	

%% 获取降神数量
get_god_count(Player) ->
	#player_status{god = StatusGod} = Player,
	#status_god{god_list = GodList} = StatusGod,
	length(GodList).