// TypeScript file
import { EventDispatcher } from "../util/EventDispatcher";
import { SceneObj } from "./sceneobj/SceneObj";
import { Vector2 } from "../util/Vector2";
import { Config } from "../common/Config";
import { MapManager } from "./MapManager";
import { Scene } from "./Scene";
import { SceneBaseType, MonsterType, AreaDataIndex } from "./SceneConfig";
import { SceneEventType, EventName } from "../common/EventName";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalEventSystem, LOAD_QUEUE, LogicRealRatio_X, LogicRealRatio_Y } from "../util/DeclareGlobalVar";
import { GlobalTimerQuest, Util, IsInTable } from "../util/Util";
import { MonsterVo } from "../sharedata/MonsterVo";
import { RoleVo, ModelPartPos } from "../sharedata/RoleVo";
import { PoseState } from "../util/StateMachineManager";
import { DoorVo } from "../sharedata/DoorVo";
import { NpcVo } from "../sharedata/NpcVo";
import { SceneController } from "./SceneController";
import { Message } from "../sysInfo/SysInfoController";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { Status } from "../util/Status";
import { GameMath } from "../util/GameMath";
import { ResManager } from "../common/ResManager";
import { TaskModel } from "../commonModel/TaskModel";
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel";
import { table } from "../common/table";
import { JumpPointVo } from "../sharedata/JumpPointVo";
import { BanquetAniManager } from "../marriage2/BanquetAniManager";
import { BanquetModel } from "../commonModel/BanquetModel";
import { GodBefallModel } from "../commonModel/GodBefallModel";
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel";
import { Kf1vnModel } from "../commonModel/Kf1vnModel";
import { FightManager } from "./fight/FightManager";

export class SceneManager extends EventDispatcher {
	static DELETE_MONSTER_DEAD = "DELETE_MONSTER_DEAD";
	static START: string = "SceneManager.START";
	static DISPOSE: string = "SceneManager.DISPOSE";
	static CLIENT_AUTO_FIGHT_CHANGE_CURR_WAVE: string = "CLIENT_AUTO_FIGHT_CHANGE_CURR_WAVE";
	static Instance: SceneManager;
	client_role_num = 0; // 当前客户端显示的角色数量
	server_role_num = 0; // 当前服务器显示的角色数量
	role_limit_num = 0;
	scene_Info = null; //当前场景数据
	last_scene_id = 0; //上一个场景ID
	curr_scene_id = 0; //当前场景ID
	next_scene_id = 0; //下一个场景ID
	last_dun_id = 0; //上一个副本id
	curr_dun_id = 0; //副本，0代表不是副本场景
	npc_doors_loaded = false;
	jumppoint_loaded = false;
	isStart = false; //场景是否加载完成
	role_vo_list = {}; //其他玩家 Vo列表
	monster_vo_list = {}; //怪物 Vo列表(怪物的instance_id作为key)
	npc_vo_list = {}; //Npc Vo列表(Npc的instance_id作为key)
	sceneNpcList = {}; //当前场景的NPC，12100协议列表数据
	door_vo_list = {}; //门点 Vo列表(enter_scene_id作为key)
	jump_vo_list = {}; //跳点对象列表
	other_vo_list = {}; //除了以上以外的一般场景对象
	drop_vo_list = {}; //掉落
	monster_vo_pool = [];
	role_vo_pool = [];
	delay_role_vo_list = []; // 延迟创建角色
	delay_monster_list = []; //延迟加载的怪物列表
	delay_drop_list = []; //延迟加载的掉落列表
	//被主角攻击过的玩家id
	mainRole_attacker_list = {};
	mainRole_attacker_count = 0;
	//攻击过主角的玩家id
	mainRole_defender_list = {};
	mainRole_defender_count = 0;
	//主角释放技能成功 服务端返回后的技能列表 记录每个主角技能等服务端返回后的时间
	main_role_server_back_skill_list = {};
	killerName = ""; //凶手名字
	killerGuildName = ""; //凶手帮派名字
	killerId = 0; //凶手帮派名字
	killerType = 0; //凶手的类型  1怪  2人
	KillerServerNum = 0; //凶手的服务器数量
	KillerMaskId = 0; //凶手的蒙面人id
	can_relive = 1; //是否能复活
	next_relive_time = 0; //下次能复活的时间戳
	has_dead_times = 1; // 当前已经死亡的次数
	last_attack_mainrole_id = 0; //最近一次攻击主角的场景对象id
	last_attack_mainrole_type = 0; //最近一次攻击主角的场景对象类型
	main_role_last_enter_stand_time; //主角上次待机时间
	find_nextvo = false;
	is_first_scene_start = true; //是否第一次scenestart
	//场景对象是否有位置更新 如果有的话 需要进行深度排序
	sceneObj_change_pos = false;
	//场景对象是否有位置更新 如果有的话 需要进行深度排序
	ui_sceneObj_change_pos = false;
	//被主角杀死的怪物数量，当前只用于经验副本
	mainRole_kill_monster_count = 0;
	//墓碑
	grave_vo_list = {}
	//正在采集
	// collecting;
	//当前正在打的目标
	private _curr_attack_target: SceneObj;
	private _other_fight_cfg;
	private _scene_door_cfg;
	public curr_click_start_pos = new Vector2();
	public curr_click_move_pos = new Vector2();
	public curr_click_move_dist = 0;
	public curr_joystick_dir;
	public can_receive_scene_protocal = false;
	public last_fight_msg = {} //上一次给服务端发送的20001对象，副技能用
	IsBlockXY;
	GetSceneDoorInfo;
	IsAreaType;
	SetLastAttackerInfo;
	SetKillerInfo;
	GameStartClearCache;
	SetCurrDunId;
	GetCurrDunId;
	SetCurrentSceneId;
	GetLastSceneId;
	GetLastDunId;
	GetSceneName;
	GetSceneType;
	GetSceneBirthPos;
	GetSceneDoors;
	ClearAllVo;
	LoadNpcsAndDoors;
	SceneStart;
	TryFireStartEvent;
	IsSceneStart;
	AddDoorVo;
	GetTheDoorVo;
	GetDoorVo;
	GetDoorVoList;
	ClearAllDoorVo;
	GetNpcList;
	SetNpcList;
	AddNpcVo;
	DynamicAddNpc;
	DynamicDelNpc;
	GetNpcVo;
	ClearAllNpcVo;
	DeleteNpcVo;
	AddMonsterVo;
	GetMonsterVo;
	DeleteMonstersByType;
	GetMonsterVoByTypeId;
	GetDelayMonsterVo;
	GetDelayMonsterNum;
	AddDelaydMonsterVo;
	DeleteMonsterVo;
	GetAllMonsterVo;
	GetOneRoleVo;
	ClearAllMonsterVo;
	AddMonsterVoPool;
	CreateMonsterVo;
	AddRoleVoPool;
	CreateRoleVo;
	AddOtherVo;
	GetOtherVo;
	DeleteOtherVo;
	GetAllOtherVo;
	ClearAllOtherVo;
	AddDropVo;
	GetDropVo;
	DeleteDropVo;
	GetDelayDropNum;
	AddDelaydDropVo;
	GetAllDropVo;
	ClearAllDropVo;
	getMonsterList;
	ResetCachedRoleList;
	AddRoleVo;
	GetRoleVo;
	GetAllRoleVos;
	DeleteRoleVo;
	ClearAllRoleVo;
	AddDelayRoleTable;
	AddDelayRoleVo;
	ImmeAddRoleVo;
	GetDelayRoleVo;
	DeleteDelayRoleVo;
	GetDelayRoleNum;
	ClearDelayAllRoleVo;
	GetSceneObjVo;
	CanRushScene;
	CanPKByPKStatus;
	IsCanAttackByMainRole;
	AddMainRoleKillCount;
	ResetMainRoleKillMonsterCount;
	AddMainRoleDefender;
	ClearMainRoleDefender;
	AddMainRoleAttacker;
	ClearMainRoleAttacker;
	ResetMainRoleAttackerAttackCount;
	IsSafePos;
	GetColorTextureShader;
	GetNearestMonsterVoByTypeId
	color_texture_shader;
	is_first_init = true;
	IsNotChangeScene
	public InitSceneManeger = () => {
		if (!this.is_first_init)
			return;
		this.is_first_init = false;
		this._other_fight_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo;
		this._scene_door_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientDoor;
		this.role_limit_num = this._other_fight_cfg.scene_max_role_count; // 最大显示人数
	};
	public constructor() {
		super();
		let local_Math = Math,
			local_Config = Config,
			map_mgr = MapManager.GetInstance(),
			local_SceneBaseType = SceneBaseType,
			local_SceneEventType = SceneEventType,
			_mainrole_vo = RoleManager.GetInstance().GetMainRoleVo(),
			local_GlobalEventSystem = GlobalEventSystem,
			local_Util = Util,
			local_LogicRealRatio_X = LogicRealRatio_X,
			local_LogicRealRatio_Y = LogicRealRatio_Y,
			local_MonsterVo = MonsterVo,
			local_RoleVo = RoleVo,
			local_AreaDataIndex = AreaDataIndex,
			local_MonsterType = MonsterType;
		this.IsBlockXY = (x, y) => {
			let state = map_mgr.IsBlockXY(x, y);
			return state;
		};
		this.GetSceneDoorInfo = (id, sceneId?) => {
			sceneId = sceneId ? sceneId : this.GetSceneId();
			let sceneInfo = this.GetSceneInfo(sceneId);
			if (sceneInfo == null || sceneInfo.Doors == null) {
				return null;
			}
			return sceneInfo.Doors[id];
		};
		this.IsAreaType = (x, y, area_type) => {
			let state = map_mgr.IsAreaType(x, y, area_type);
			return state;
		};
		this.SetLastAttackerInfo = (type, attacker_id) => {
			if ((Scene.GetInstance().main_role.GetCurState() != PoseState.MOVE)) {
				if (type != local_SceneBaseType.Partner && type != local_SceneBaseType.Sprite) {
					this.last_attack_mainrole_type = type;
					this.last_attack_mainrole_id = attacker_id;
				}
			}
			else {
				this.last_attack_mainrole_type = 0;
				this.last_attack_mainrole_id = 0;
			}
		};
		this.SetKillerInfo = (type, killerId?) => {
			this.killerType = type;
			if (this.killerType == local_SceneBaseType.Role) {
				let roleInfo = this.GetRoleVo(killerId);
				if (roleInfo == null) {
					this.killerName = "";
					this.killerGuildName = "";
					this.killerId = 0;
					this.KillerServerNum = 0;
					this.KillerMaskId = 0;
				}
				else {
					this.killerName = roleInfo.name;
					this.killerGuildName = roleInfo.guild_name;
					this.killerId = killerId;
					this.KillerServerNum = roleInfo.server_id;
					this.KillerMaskId = roleInfo.mask_id;
				}
			}
			else if (this.killerType == local_SceneBaseType.Monster) {
				let mon_Info = this.GetMonsterVo(killerId);
				if (mon_Info == null) {
					this.killerName = "";
					this.killerGuildName = "";
					this.killerId = 0;
					this.KillerServerNum = 0;
					this.KillerMaskId = 0;
				}
				else {
					this.killerName = mon_Info.name;
					this.killerGuildName = "";
					this.killerId = killerId;
					this.KillerServerNum = 0;
					this.KillerMaskId = 0;
				}
			}
			else {
				this.killerName = "";
				this.killerId = 0;
				this.killerGuildName = "";
				this.KillerServerNum = 0;
				this.KillerMaskId = 0;
			}
			if (this.killerType != 0) {
				local_GlobalEventSystem.Fire(local_SceneEventType.UPDATE_KILLER);
			}
		};
		//返回登录，清空一下数据
		this.GameStartClearCache = () => {
			this.last_scene_id = 0;
			this.curr_scene_id = 0;
			this.last_dun_id = 0;
			this.curr_dun_id = 0;
		};
		//设置当前的副本id
		this.SetCurrDunId = (dun_id) => {
			this.last_dun_id = this.curr_dun_id;
			this.curr_dun_id = dun_id;
			// BaseDungeonModel.GetInstance().InitDungeonInfo(this.curr_dun_id)
			if (!(this.last_dun_id == this.curr_dun_id && this.last_dun_id > 0)) //不是同一个副本的切场景情况就要重置怒气
			{
				if (_mainrole_vo) {
					_mainrole_vo.ChangeVar("anger", 0, null, true);
				}
			}
		};
		//设置当前的副本id
		this.GetCurrDunId = () => {
			return this.curr_dun_id ? this.curr_dun_id : 0;
		};
		this.SetCurrentSceneId = (sceneId) => {
			this.last_scene_id = this.curr_scene_id;
			this.curr_scene_id = sceneId;
			this.scene_Info = this.GetSceneInfo(sceneId);
		};
		this.GetLastSceneId = () => {
			return this.last_scene_id;
		};
		this.GetLastDunId = () => {
			return this.last_dun_id
		};
		this.GetSceneName = () => {
			// print("getSceneName")
			if (this.scene_Info == null)
				return "";
			return this.scene_Info.name;
		};
		this.GetSceneType = (sceneId) => {
			let scene_Info = this.GetSceneInfo(sceneId);
			return scene_Info ? scene_Info.type : 0;
		};
		//获取场景出生点坐标
		this.GetSceneBirthPos = (sceneId) => {
			let scene_Info = this.GetSceneInfo(sceneId);
			if (scene_Info)
				return { x: scene_Info.x, y: scene_Info.y };
		};
		this.GetSceneDoors = () => {
			// if (this.scene_Info == null || this.scene_Info.Doors == null)
			//	 return {}
			return this._scene_door_cfg[this.curr_scene_id];
		};
		this.ClearAllVo = (force_clear_npc = false) => {
			this.isStart = false;
			this.ClearMainRoleDefender();
			this.ClearMainRoleAttacker();
			this.ClearAllRoleVo();
			this.ClearAllMonsterVo();
			this.ClearAllOtherVo();
			this.ClearAllDropVo();
			if (this.GetSceneId() != this.last_scene_id || this.IsSeaAsserScene() || force_clear_npc) {
				this.ClearAllNpcVo();
				this.ClearAllDoorVo();
				this.ClearAllJumpPointVo();
				this.npc_doors_loaded = false;
				this.jumppoint_loaded = false
			}
			local_GlobalEventSystem.Fire(SceneManager.DISPOSE);
		};
		this.LoadNpcsAndDoors = () => {
			if (this.npc_doors_loaded) {
				return;
			}
			let doors = this.GetSceneDoors();
			if (doors) {
				for (let key in doors) {
					let info = doors[key];
					let door_vo = new DoorVo();
					door_vo.CreateDoorInfo(info);
					this.AddDoorVo(door_vo);
				}
			}
			let npcs = this.GetNpcList();
			if (Util.TableSize(npcs) == 0) {
				console.warn("------LoadNpcsAndDoors npcs 0------")
			}
			for (let key in npcs) {
				let info = npcs[key];
				let npc_id = info.instance_id || info.npc_id;
				if (info.is_show == 0) {
					this.DeleteNpcVo(npc_id);
				}
				else {
					let npc_info = new NpcVo();
					npc_info.CreateNpcInfo(info);
					this.AddNpcVo(npc_info);
				}
			}
			this.npc_doors_loaded = true;
		};
		this.SceneStart = () => {
			this.isStart = true;
			this.TryFireStartEvent();
		};
		this.TryFireStartEvent = () => {
			if (!this.isStart)
				return;
			local_GlobalEventSystem.Fire(SceneManager.START);
			if (SceneController.GetInstance().change_scene_call_back) {
				SceneController.GetInstance().change_scene_call_back();
				SceneController.GetInstance().change_scene_call_back = null;
			}
			if (this.is_first_scene_start) {
				this.is_first_scene_start = false;
			}
		};
		this.IsSceneStart = () => {
			return this.isStart;
		};
		this.AddDoorVo = (door_vo) => {
			let door_id = door_vo.id;
			this.door_vo_list[door_id] = door_vo;
			local_GlobalEventSystem.Fire(local_SceneEventType.DOOR_VO_ADD, door_id, door_vo);
		};
		this.GetTheDoorVo = () => {
			for (let k in this.door_vo_list)
				return this.door_vo_list[k];
		};
		this.GetDoorVo = (id) => {
			return this.door_vo_list[id];
		};
		this.GetDoorVoList = () => {
			return this.door_vo_list;
		};
		this.ClearAllDoorVo = () => {
			if (!local_Util.IsTableEmpty(this.door_vo_list)) {
				for (let k in this.door_vo_list)
					local_GlobalEventSystem.Fire(local_SceneEventType.DOOR_VO_REMOVE, k, this.door_vo_list[k]);
				this.door_vo_list = {};
			}
		};
		this.GetNpcList = () => {
			return this.sceneNpcList;
		};
		this.SetNpcList = (list) => {
			this.sceneNpcList = list;
		};
		this.AddNpcVo = (npc_vo) => {
			this.npc_vo_list[npc_vo.npc_id] = npc_vo;
			this.sceneNpcList[npc_vo.npc_id] = npc_vo;
			local_GlobalEventSystem.Fire(local_SceneEventType.NPC_VO_ADD, npc_vo.npc_id, npc_vo);
		};
		this.DynamicAddNpc = (npc_id, npc_x, npc_y, args) => {
			// let info = this.GetSceneNpcInfo(npc_id)
			// if info then
			if (npc_id && npc_x && npc_y) {
				let npc_info = new NpcVo();
				let info = { npc_id: npc_id, pos_x: npc_x, pos_y: npc_y, args: args };
				npc_info.CreateNpcInfo(info);
				npc_info.pos_x = npc_x; //X坐标(int16)
				npc_info.pos_y = npc_y; //Y坐标(int16)
				npc_info.logic_x = npc_info.pos_x / local_LogicRealRatio_X;
				npc_info.logic_y = npc_info.pos_y / local_LogicRealRatio_Y;
				this.AddNpcVo(npc_info);
			}
		};
		this.DynamicDelNpc = (npc_id) => {
			// let info = this.getSceneNpcInfo(npc_id)
			// if info then
			// if this.npc_vo_list[info.npc_id] then
			// 	this.DeleteNpcVo(info.npc_id)
			// end
			// end
			if (this.npc_vo_list[npc_id])
				this.DeleteNpcVo(npc_id);
		};
		this.GetNpcVo = (npc_id) => {
			return this.npc_vo_list[npc_id];
		};
		this.ClearAllNpcVo = () => {
			if (!local_Util.IsTableEmpty(this.npc_vo_list)) {
				for (let k in this.npc_vo_list)
					local_GlobalEventSystem.Fire(local_SceneEventType.NPC_VO_REMOVE, k);
				this.npc_vo_list = {};
			}
		};
		this.DeleteNpcVo = (id) => {
			if (this.npc_vo_list[id] != null)
				local_GlobalEventSystem.Fire(local_SceneEventType.NPC_VO_REMOVE, id);
			delete this.sceneNpcList[id];
			delete this.npc_vo_list[id];
		};
		this.AddMonsterVo = (monster_vo, isdelay = false) => {
			// print("AddMonsterVo monster_vo.instance_id=",monster_vo.instance_id,isdelay)
			if (isdelay == true && monster_vo.load_immediately != 1) //延迟加载
				this.delay_monster_list.push(monster_vo);
			else {
				this.monster_vo_list[monster_vo.instance_id] = monster_vo;
				local_GlobalEventSystem.Fire(local_SceneEventType.MONSTER_VO_ADD, monster_vo.instance_id, monster_vo);
				if (monster_vo.boss_type == 8) //使魔
					local_GlobalEventSystem.Fire(local_SceneEventType.PET_MONSTER_VO_ADD, monster_vo.instance_id, monster_vo);
			}
		};
		this.GetMonsterVo = (ins_id) => {
			let vo = this.monster_vo_list[ins_id];
			if (!vo) {
				vo = this.GetDelayMonsterVo(ins_id);
			}
			return vo;
		};
		//删除指定类型的怪物
		this.DeleteMonstersByType = (type_id) => {
			let v;
			for (let i in this.monster_vo_list) {
				v = this.monster_vo_list[i];
				if (v.type_id == type_id && !v.is_client_monster)
					this.DeleteMonsterVo(v.instance_id);
			}
		};
		this.GetMonsterVoByTypeId = (type_id) => {
			let v;
			for (let i in this.monster_vo_list) {
				v = this.monster_vo_list[i];
				if (v.type_id == type_id)
					return v;
			}
			let size = this.delay_monster_list.length;
			if (size > 0)
				for (let i = 0; i < size; i++) {
					let monster_vo = this.delay_monster_list[i];
					if (monster_vo.type_id == type_id)
						return monster_vo;
				}
			return null;
		};
		this.GetDelayMonsterVo = (ins_id) => {
			let size = this.delay_monster_list.length;
			if (size > 0)
				for (let i = 0; i < size; i++) {
					let monster_vo = this.delay_monster_list[i];
					if (monster_vo && ins_id == monster_vo.instance_id)
						return monster_vo;
				}
		};
		this.GetDelayMonsterNum = () => {
			return this.delay_monster_list.length;
		};
		//从延迟加载列表中取一个vo并创建
		this.AddDelaydMonsterVo = () => {
			let size = this.delay_monster_list.length;
			if (size > 0) {
				let monster_vo = null;
				if (size <= 10) {
					monster_vo = this.delay_monster_list.shift();
					this.AddMonsterVo(monster_vo);
				}
				else {
					size = local_Math.ceil(size * 0.1);
					for (let i = 0; i < size; i++) {
						monster_vo = this.delay_monster_list.shift();
						this.AddMonsterVo(monster_vo);
					}
				}
			}
		};
		this.DeleteMonsterVo = (ins_id) => {
			let size = this.delay_monster_list.length;
			let vo = this.monster_vo_list[ins_id];
			let type_id = vo ? vo.type_id : 0;
			if (vo == null) {
				if (size > 0) {
					for (let index = 0; index < size; index++) {
						let info = this.delay_monster_list[index];
						if (info && ins_id == info.instance_id) {
							type_id = info.type_id;
							this.delay_monster_list.splice(index, 1);
							break;
						}
					}
				}
			}
			else {
				delete this.monster_vo_list[ins_id];
			}
			if (vo) {
				local_GlobalEventSystem.Fire(local_SceneEventType.MONSTER_VO_REMOVE, ins_id, type_id, vo);
			}
			return vo;
		};
		//获取所有的怪物Vo
		this.GetAllMonsterVo = () => {
			return this.monster_vo_list;
		};
		//获取当前场景的一个角色vo
		this.GetOneRoleVo = () => {
			let vo;
			for (let k in this.role_vo_list) {
				vo = this.role_vo_list[k];
				if (vo) {
					return vo;
				}
			}
		};
		this.ClearAllMonsterVo = () => {
			let vo;
			for (let k in this.monster_vo_list) {
				vo = this.monster_vo_list[k];
				local_GlobalEventSystem.Fire(local_SceneEventType.MONSTER_VO_REMOVE, vo.instance_id, vo.type_id, vo);
			}
			this.delay_monster_list.length = 0; //延迟加载的怪物列表
			this.monster_vo_list = {};
		};
		this.AddMonsterVoPool = (vo) => {
			if (this.monster_vo_pool.length < 40) {
				vo.ResetData();
				this.monster_vo_pool.push(vo);
			}
		};
		this.CreateMonsterVo = () => {
			if (this.monster_vo_pool.length > 0)
				return this.monster_vo_pool.shift();
			return new local_MonsterVo();
		};
		this.AddRoleVoPool = (vo) => {
			if (this.role_vo_pool.length < 40) {
				vo.ResetData();
				this.role_vo_pool.push(vo);
			}
		};
		this.CreateRoleVo = () => {
			if (this.role_vo_pool.length > 0)
				return this.role_vo_pool.shift();
			return new local_RoleVo();
		};
		this.AddOtherVo = (other_vo) => {
			this.other_vo_list[other_vo.instance_id] = other_vo;
			local_GlobalEventSystem.Fire(local_SceneEventType.OTHER_VO_ADD, other_vo.instance_id, other_vo);
		};
		this.GetOtherVo = (ins_id) => {
			return this.other_vo_list[ins_id];
		};
		this.DeleteOtherVo = (ins_id) => {
			let vo = this.GetOtherVo(ins_id);
			if (vo) {
				delete this.other_vo_list[ins_id];
				local_GlobalEventSystem.Fire(local_SceneEventType.OTHER_VO_REMOVE, ins_id, vo);
				return vo;
			}
		};
		this.GetAllOtherVo = () => {
			return this.other_vo_list;
		};
		this.ClearAllOtherVo = () => {
			if (!local_Util.IsTableEmpty(this.other_vo_list)) {
				let vo;
				for (let k in this.other_vo_list) {
					vo = this.other_vo_list[k];
					local_GlobalEventSystem.Fire(local_SceneEventType.OTHER_VO_REMOVE, vo.instance_id, vo);
				}
				this.other_vo_list = {};
			}
		};
		this.AddDropVo = (drop_vo, is_delay = false) => {
			if (drop_vo) {
				if (is_delay) {
					this.delay_drop_list.push(drop_vo);
				}
				else {
					this.drop_vo_list[drop_vo.drop_id] = drop_vo;
					local_GlobalEventSystem.Fire(local_SceneEventType.DROP_VO_ADD, drop_vo.drop_id, drop_vo);
				}
			}
		};
		this.GetDropVo = (ins_id) => {
			return this.drop_vo_list[ins_id];
		};
		this.DeleteDropVo = (ins_id) => {
			let vo = this.GetDropVo(ins_id);
			if (vo) {
				delete this.drop_vo_list[ins_id];
				local_GlobalEventSystem.Fire(local_SceneEventType.DROP_VO_REMOVE, ins_id, vo);
				return vo;
			}
			else {
				let size = this.delay_drop_list.length;
				if (size > 0)
					for (let i = 0; i < size; i++) {
						let drop_vo = this.delay_drop_list[i];
						if (drop_vo && ins_id == drop_vo.instance_id)
							this.delay_drop_list.splice(i, 1);
					}
			}
		};
		this.GetDelayDropNum = () => {
			return this.delay_drop_list.length;
		};
		//从延迟加载列表中取一个vo并创建
		this.AddDelaydDropVo = () => {
			let size = this.delay_drop_list.length;
			if (size > 0) {
				let drop_vo = null;
				if (size <= 10) {
					drop_vo = this.delay_drop_list.shift();
					this.AddDropVo(drop_vo, false);
				}
				else {
					size = local_Math.ceil(size * 0.1);
					for (let i = 0; i < size; i++) {
						drop_vo = this.delay_drop_list.shift();
						this.AddDropVo(drop_vo, false);
					}
				}
			}
		};
		this.GetAllDropVo = () => {
			return this.drop_vo_list;
		};
		this.ClearAllDropVo = () => {
			if (!local_Util.IsTableEmpty(this.drop_vo_list)) {
				let vo;
				for (let k in this.drop_vo_list) {
					vo = this.drop_vo_list[k];
					local_GlobalEventSystem.Fire(local_SceneEventType.DROP_VO_REMOVE, vo.drop_id, vo);
				}
				this.drop_vo_list = {};
				this.delay_drop_list.length = 0;
			}
		};
		this.getMonsterList = () => {
			let ret = [];
			for (let id in this.monster_vo_list)
				ret.push(this.monster_vo_list[id]);
			let size = this.delay_monster_list.length;
			if (size > 0)
				for (let index = 0; index < size; index++) {
					let vo = this.delay_monster_list[index];
					ret.push(vo);
				}
			return ret;
		};
		//重置缓存角色vo的队列
		this.ResetCachedRoleList = () => {
			this.ClearDelayAllRoleVo(); // 清空 延迟加载的玩家数据
		};
		this.AddRoleVo = (role_vo, is_from_server = false) => {
			let role_id = role_vo.role_id;

			
			// if (this.IsWeddingScene()) { // 婚宴动画中，如果已经创建新人，则不再创建
			// 	let banAni = BanquetAniManager.GetInstance()
			// 	if (banAni.bool_playing && this.GetRoleVo(role_id)) {
			// 		if (role_id == BanquetModel.GetInstance().GetGroomId()) {
			// 			// banAni.man_feaker_id = null
			// 				return

			// 		}

			// 		//新娘
			// 		// if (role_id == BanquetModel.GetInstance().GetBrideId()&&banAni.woman_feaker_id!=null) {
			// 		// 	// banAni.woman_feaker_id = null
			// 		// 	console.warn("测试@创建了新娘假人，回滚")
			// 		// 	return
			// 		// }
			// 	}
			// }

			if (role_id == _mainrole_vo.role_id) {
				// for(let i = 0; i< role_vo.figure_ride_list.length ;i++){
				// 	console.warn("@@@@------figure_ride_list------", JSON.stringify(role_vo.figure_ride_list[i]))
				// }
				// console.warn("@@@@------figure_ride_list1------")
				_mainrole_vo.ChangeFromVo(role_vo);
				this.server_role_num = this.server_role_num + 1;
				this.AddRoleVoPool(role_vo)
				return;
			}
			//如果是从服务端发来的角色信息，就把角色vo缓存起来，不跨场景就不清空
			if (is_from_server) {
				if (this.role_vo_list[role_id] == null) //新增的情况数量加一
				{
					this.server_role_num = this.server_role_num + 1;
					this.AddDelayRoleTable(role_vo);
					return;
				}
			}
			if (this.role_vo_list[role_id] == null) //新增的情况数量加一
				this.client_role_num = this.client_role_num + 1;
			this.role_vo_list[role_id] = role_vo;
			local_GlobalEventSystem.Fire(local_SceneEventType.ROLE_VO_ADD, role_id, role_vo);
			role_vo.particle_priority = 2;
		};
		this.GetRoleVo = (role_id) => {
			if (role_id == _mainrole_vo.role_id)
				return _mainrole_vo;
			else {
				let vo = this.role_vo_list[role_id];
				if (!vo) {
					vo = this.GetDelayRoleVo(role_id);
				}
				return vo;
			}
		};
		this.GetAllRoleVos = () => {
			return this.role_vo_list;
		};
		this.DeleteRoleVo = (role_id) => {
			if (!this.can_receive_scene_protocal)
				return;
			if (role_id == _mainrole_vo.role_id)
				return;

			// if (this.IsWeddingScene()) { // 婚宴场景，婚宴仪式中不删除新人
			// 	let banAni = BanquetAniManager.GetInstance()
			// 	if (banAni.bool_playing && this.GetRoleVo(role_id)) {
			// 		if (role_id == BanquetModel.GetInstance().GetGroomId()) {
			// 			// banAni.man_feaker_id = null
			// 			return
			// 		} else if (role_id == BanquetModel.GetInstance().GetBrideId()) {
			// 			// banAni.man_feaker_id = null
			// 			return
			// 		}
			// 	}
			// }

			//删除延迟加载列表
			this.DeleteDelayRoleVo(role_id);
			if (this.role_vo_list[role_id] != null) {
				this.server_role_num = this.server_role_num - 1;
				this.client_role_num = this.client_role_num - 1;
				delete this.role_vo_list[role_id];
				local_GlobalEventSystem.Fire(local_SceneEventType.ROLE_VO_REMOVE, role_id);
			}
		};
		this.ClearAllRoleVo = () => {
			for (let k in this.role_vo_list)
				local_GlobalEventSystem.Fire(local_SceneEventType.ROLE_VO_REMOVE, k);
			this.role_vo_list = {};
			this.delay_role_vo_list.length = 0;
			this.client_role_num = 0;
			this.server_role_num = 0;
		};
		// 分帧加载玩家
		this.AddDelayRoleTable = (role) => {
			this.delay_role_vo_list.push(role);
		};
		this.AddDelayRoleVo = () => {
			if (this.client_role_num >= this.role_limit_num)
				return;
			let size = this.delay_role_vo_list.length;
			if (size > 0) {
				let role_vo = null;
				if (size <= 5) {
					role_vo = this.delay_role_vo_list[0];
					this.delay_role_vo_list.splice(0, 1);
					this.AddRoleVo(role_vo);
				}
				else {
					size = local_Math.ceil(size * 0.2);
					for (let i = 0; i < size; i++) {
						role_vo = this.delay_role_vo_list[0];
						this.delay_role_vo_list.splice(0, 1);
						this.AddRoleVo(role_vo);
					}
				}
			}
		};
		//立马加载角色
		this.ImmeAddRoleVo = (role_id) => {
			let delay_role_len = this.delay_role_vo_list.length;
			let vo = null;
			for (let i = 0; i < delay_role_len; i++) {
				vo = this.delay_role_vo_list[i];
				if (vo.role_id == role_id) {
					this.delay_role_vo_list.splice(i, 1);
					this.AddRoleVo(vo);
					return;
				}
			}
		};
		this.GetDelayRoleVo = (role_id) => {
			let delay_role_len = this.delay_role_vo_list.length;
			if (delay_role_len > 0) {
				let vo = null;
				for (let i = 0; i < delay_role_len; i++) {
					vo = this.delay_role_vo_list[i];
					if (vo.role_id == role_id) {
						return vo;
					}
				}
			}
		};
		//删除延迟加载列表
		this.DeleteDelayRoleVo = (role_id) => {
			let delay_role_len = this.delay_role_vo_list.length;
			let vo = null;
			for (let i = 0; i < delay_role_len; i++) {
				vo = this.delay_role_vo_list[i];
				if (vo.role_id == role_id) {
					this.delay_role_vo_list.splice(i, 1);
					break;
				}
			}
		};
		this.GetDelayRoleNum = () => {
			return this.delay_role_vo_list.length;
		};
		this.ClearDelayAllRoleVo = () => {
			this.delay_role_vo_list.length = 0;
		};
		//获取除了主角以外的场景对象
		this.GetSceneObjVo = (instance_id) => {
			let vo = this.GetMonsterVo(instance_id) || this.GetRoleVo(instance_id) || this.GetOtherVo(instance_id);
			return vo;
		};
		//可以冲刺的场景
		this.CanRushScene = (scene_id?) => {
			return !this.IsPKScene(scene_id);
		};
		//attacker_vo是否能通过pkstatus的验证 攻击defender_vo
		this.CanPKByPKStatus = (attacker_vo?, defender_vo?, show_tip = false) => {
			if (attacker_vo && defender_vo) {
				if (attacker_vo == defender_vo)
					return false;
				if (attacker_vo.pk_status == local_RoleVo.PK_STATUS.Peace) {
					if (show_tip) {
						Message.show(`和平模式下无法攻击任何玩家`);
					}
					return false;
				}
				let status = true;
				if (attacker_vo.pk_status != local_RoleVo.PK_STATUS.Free) {
					if (attacker_vo.pk_status == local_RoleVo.PK_STATUS.Guild_Team || attacker_vo.pk_status == local_RoleVo.PK_STATUS.Guild) {
						if (attacker_vo.guild_id == defender_vo.guild_id && attacker_vo.guild_id > 0) {
							if (show_tip) {
								if (attacker_vo.pk_status == local_RoleVo.PK_STATUS.Guild_Team) {
									Message.show(`强制模式下无法攻击同结社玩家`);
								}
								else {
									Message.show(`结社模式下无法攻击同结社玩家`);
								}
							}
							status = false;
						}
						else if (attacker_vo.pk_status == local_RoleVo.PK_STATUS.Guild_Team) {
							if (attacker_vo.team_id == defender_vo.team_id && attacker_vo.team_id > 0) {
								if (show_tip) {
									Message.show(`强制模式下无法攻击同队伍玩家`);
								}
								status = false;
							}
						}
					}
					else if (attacker_vo.pk_status == local_RoleVo.PK_STATUS.Local && attacker_vo.server_unique_id == defender_vo.server_unique_id) {
						if (show_tip) {
							Message.show(`跨服模式下无法攻击同服务器成员`);
						}
						status = false;
					}
					else if (attacker_vo.pk_status == local_RoleVo.PK_STATUS.CAMP && attacker_vo.camp == defender_vo.camp) {
						if (show_tip) {
							Message.show(`阵营模式下无法攻击同阵营成员`);
						}
						status = false;
					}
				}
				return status;
			}
			return true;
		};
		//主角是否能攻击defender_vo	  
		//safe_area_state 1角色处于安全区域状态  2角色处于非安全区域状态  3角色切场景进入安全区域状态
		//not_check_safe_area   不考虑安全区域

		//check_died 检查自己是否在死亡状态
		this.IsCanAttackByMainRole = (defender_vo?, not_check_safe_area?, show_tip = false, check_died = true) => {

			let attacker_vo = _mainrole_vo;
			if ((attacker_vo == null || attacker_vo.hp == 0) && check_died) {
				// if(show_tip)
				// {
				//	 Message.show("您当前处于死亡状态，不能发起攻击")
				// }
				return false;
			}


			if (defender_vo == null || defender_vo.hp == 0) {
				if (show_tip) {
					Message.show("目标已死亡，不能发起攻击");
				}
				return false;
			}


			if (!not_check_safe_area && defender_vo.vo_type != local_SceneBaseType.Monster) {
				if (this.IsSafeScene()) {
					if (show_tip) {
						Message.show("安全场景不能战斗");
					}
					return false;
				}
				else if (attacker_vo.safe_area_state == 1 || attacker_vo.safe_area_state == 3 || (attacker_vo.safe_area_state != 2 && this.IsSafeArea(null, attacker_vo.pos_x, attacker_vo.pos_y))) {
					if (show_tip) {
						Message.show("您处于安全区内，不能发起战斗");
					}
					return false;
				}
				else if (defender_vo.safe_area_state == 1 || defender_vo.safe_area_state == 3 || (defender_vo.safe_area_state != 2 && this.IsSafeArea(null, defender_vo.pos_x, defender_vo.pos_y))) {
					if (show_tip) {
						Message.show("目标处于安全区内，不能发起攻击");
					}
					return false;
				}
			}


			let war_group1 = attacker_vo.warGroup
			let war_group2 = defender_vo.warGroup
			let same_group = war_group2 == war_group1 && war_group1 > 0;

			//同结社车队，非结社成员看见的血是红色
			if (defender_vo.vo_type == local_SceneBaseType.Monster) {

				if (SceneManager.GetInstance().IsSeaHegemonyScene()) {
					return SeaHegemonyModel.GetInstance().fightType == 1
				}


				if (defender_vo.guild_id && defender_vo.guild_id > 0 && defender_vo.guild_id == attacker_vo.guild_id) {
					//  if(show_tip)
					// {
					//	 Message.show("同工会车队，不能发起攻击")
					// }
					return false;
				}
				else if (defender_vo.camp && defender_vo.camp > 0 && defender_vo.camp == attacker_vo.camp) {
					return false;
				}
				else if (defender_vo.guild_id && defender_vo.guild_id > 0 && defender_vo.guild_id != attacker_vo.guild_id)
					return true;
				else if (defender_vo.guaji_flag == 1 || defender_vo.can_attack == 0
					|| defender_vo.type == local_MonsterType.COLLECT || defender_vo.type == local_MonsterType.TASK_COLLECT
					|| defender_vo.type == local_MonsterType.PICK || defender_vo.type == local_MonsterType.INFINITE_COLLECT)
					return false;


				if (same_group)
					return false;
			}



			if (SceneManager.GetInstance().IsSeaHegemonyScene() && defender_vo.vo_type == local_SceneBaseType.Role) {
				return SeaHegemonyModel.GetInstance().CanAttackRole(defender_vo)
			}


			if (defender_vo.vo_type == local_SceneBaseType.MainRole) {
				if (show_tip) {
					Message.show("不能攻击自己");
				}
				return false;
			}


			if (defender_vo.vo_type != local_SceneBaseType.Role) {
				return !same_group;
			}



			if (!this.IsPKScene()) {
				if (show_tip) {
					Message.show("非pk场景，不能发起战斗");
				}
				return false;
			}


			let canpkByPkStatus = true;
			if (war_group1 == 0 && war_group2 == 0)
				canpkByPkStatus = this.CanPKByPKStatus(attacker_vo, defender_vo, show_tip);

			return canpkByPkStatus && !same_group;
		};
		//被主角击杀的obj数量，用于经验副本和虚空秘境
		this.AddMainRoleKillCount = (obj_type) => {
			if (obj_type == local_SceneBaseType.Monster) {
				this.mainRole_kill_monster_count = this.mainRole_kill_monster_count + 1;
				local_GlobalEventSystem.Fire(EventName.UPDATE_KILL_OBJECT_NUM, this.mainRole_kill_monster_count);
			}
		};
		this.ResetMainRoleKillMonsterCount = () => {
			this.mainRole_kill_monster_count = 0;
		};
		
		this.AddMainRoleDefender = (role_id) => {
			let defender_info = this.mainRole_defender_list[role_id];
			if (!defender_info) {
				defender_info = { "start_time": Status.NowTime };
				this.mainRole_defender_list[role_id] = defender_info;
				this.mainRole_defender_count = this.mainRole_defender_count + 1;
				let max_count = this._other_fight_cfg.mainRole_defender_max_count;
				if (this.mainRole_defender_count > max_count) {
					let min_start_time = 99999, min_role_id, vo;
					for (let id in this.mainRole_defender_list) {
						vo = this.mainRole_defender_list[id];
						if (min_start_time > vo.start_time) {
							min_start_time = vo.start_time;
							min_role_id = id;
						}
					}
					if (min_role_id) {
						delete this.mainRole_defender_list[min_role_id];
					}
					this.mainRole_defender_count = this.mainRole_defender_count - 1;
				}
				if (_mainrole_vo.pk_status == local_RoleVo.PK_STATUS.Peace) {
					let role_vo = this.GetRoleVo(role_id);
					if (role_vo) {
						role_vo.ChangeVar("pk_status", role_vo.pk_status, undefined, true);
					}
				}
			}
			else {
				defender_info.start_time = Status.NowTime;
			}
		};
		this.ClearMainRoleDefender = () => {
			if (this.mainRole_defender_count > 0) {
				this.mainRole_defender_list = {};
			}
			this.mainRole_defender_count = 0;
		};
		this.AddMainRoleAttacker = (role_id, skill_id) => {
			let attacker_info = this.mainRole_attacker_list[role_id];
			if (!attacker_info) {
				attacker_info = { "start_time": Status.NowTime, "skill_id": skill_id, "attack_count": 1 };
				this.mainRole_attacker_list[role_id] = attacker_info;
				this.mainRole_attacker_count = this.mainRole_attacker_count + 1;
				let max_count = this._other_fight_cfg.mainRole_attacker_max_count;
				if (this.mainRole_attacker_count > max_count) {
					let min_start_time = 99999, min_role_id, vo;
					for (let id in this.mainRole_attacker_list) {
						vo = this.mainRole_attacker_list[id];
						if (min_start_time > vo.start_time) {
							min_start_time = vo.start_time;
							min_role_id = id;
						}
					}
					if (min_role_id) {
						delete this.mainRole_attacker_list[min_role_id];
					}
					this.mainRole_attacker_count = this.mainRole_attacker_count - 1;
				}
			}
			else {
				attacker_info.start_time = Status.NowTime;
				if (attacker_info.skill_id == skill_id) {
					attacker_info.attack_count = attacker_info.attack_count + 1;
				}
				else {
					attacker_info.skill_id = skill_id;
					attacker_info.attack_count = 1;
				}
			}
		};
		this.ClearMainRoleAttacker = () => {
			if (this.mainRole_attacker_count > 0) {
				this.mainRole_attacker_list = {};
			}
			this.mainRole_attacker_count = 0;
		};
		this.ResetMainRoleAttackerAttackCount = () => {
			let vo;
			for (let id in this.mainRole_attacker_list) {
				vo = this.mainRole_attacker_list;
				vo.attack_count = 0;
			}
		};
		//是否处于安全区坐标，野外场景也会有安全区的
		this.IsSafePos = (pos_x?, pos_y?) => {
			if (!pos_x || !pos_y) {
				return false;
			}
			let is_safe_area = this.IsAreaType(pos_x / local_LogicRealRatio_X, pos_y / local_LogicRealRatio_Y, local_AreaDataIndex.SafeType);
			return is_safe_area;
		};

		//得到Alphatextureshader  有alpha透明通道 已经可以更改颜色
		this.GetColorTextureShader = () => {
			// if (this.color_texture_shader == null) {
			// 	this.color_texture_shader
			// }
			return this.color_texture_shader
		}

		this.GetNearestMonsterVoByTypeId = (type_id?) => {
			let list = this.getMonsterList()
			let nearestVo = null
			let dis
			let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
			for (let k in list) {
				var v = list[k]
				if (v.type_id == type_id) {
					let tempDis = GameMath.GetDistance(mainRoleVo.pos_x, mainRoleVo.pos_y, v.pos_x, v.pos_y, false)
					if (!dis || tempDis < dis) {
						nearestVo = v
						dis = tempDis
					}
				}
			}
			return nearestVo
		}


		/***副本和蛮荒大妖不能跳转到其他场景 */
		this.IsNotChangeScene = () => {
			return this.IsDungeonScene() || this.IsSuitBossScene()
		}
	}
	public static GetInstance() {
		if (!SceneManager.Instance) {
			SceneManager.Instance = new SceneManager();
		}
		return SceneManager.Instance;
	}
	public set curr_attack_target(target: SceneObj) {
		this._curr_attack_target = target;
	}
	public get curr_attack_target() {
		return this._curr_attack_target;
	}

	//是否是野外场景
	public IsFieldScene = (scene_id?) => {
		let sceneInfo = this.GetSceneInfo(scene_id);
		return (sceneInfo && sceneInfo.type == 1);
	};



	public GetSceneId = () => {
		return this.curr_scene_id;
	};
	public GetSceneInfo = (sceneId?) => {
		sceneId = sceneId == undefined ? this.GetSceneId() : sceneId;
		if (this.scene_Info && this.scene_Info.id == sceneId) {
			return this.scene_Info;
		}
		return Config.PRELOAD_SERVER_CONFIG.config_scene && Config.PRELOAD_SERVER_CONFIG.config_scene[sceneId];
	};

	public GetSceneObjDepth(y?) {
		return 900 - y * 0.02 //Math.tan(30 * Math.PI / 180)
	}

	public has_send_12002 = false;
	public has_recevie_12002 = false;
	public has_bytes_map_load = false;
	public has_min_map_load = false;
	public send_load_map = false;
	public has_recevie_10006 = false;
	public auto_fight_state_code = 1;

	/*
	功能：是否在主城或者野外或结社场景
	*/
	public IsMainCityorYieldScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return sceneInfo && (sceneInfo.type == 0 || sceneInfo.type == 1 || sceneInfo.type == 4)
	}

	/*
	功能：判断当前场景是否为安全场景 不能释放一切技能
	*/
	public IsSafeScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return (sceneInfo && sceneInfo.subtype == 1)
	}

	//是否安全区域 (包括安全场景和安全位置坐标)
	public IsSafeArea(scene_id?, pos_x?, pos_y?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return this.IsSafeScene(scene_id) || (this.IsSafePos(pos_x, pos_y))
	}

	//pk场景 强制切换pk状态
	public IsPKScene(scene_id?) {

		return !this.IsOnlyAttackMonsterScene(scene_id)
	}

	public IsCSPvP(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 6000
	}


	//不能攻击其他玩家 只能打怪的场景
	public IsOnlyAttackMonsterScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return (sceneInfo && (sceneInfo.subtype == 0))
	}

	public IsOvnFightingScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		if (scene_id == 7110) {
			return 1
		} else if (scene_id == 7111) {
			return 2
		} else {
			return false
		}
	}


	//显示pk模式ui的场景
	public ShowPKStatusUI(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return (sceneInfo && (sceneInfo.subtype == 0)
			&& RoleManager.Instance.mainRoleInfo.warGroup == 0)
	}



	//不能跳跃障碍点的场景
	public CannotJumpCrossBlockScene() {

		return true
	}

	//任务可以加速的场景
	public TaskCanAddSpeedBuffScene() {

		return this.IsMainCityorYieldScene()
	}

	//是否可以使用飞鞋的场景（主城，野外场景中的子类型为0和1的场景）
	public IsCanUseFlyShoeScene() {

		return this.IsMainCityAndFieldScene() || this.IsCSPvP() ||  this.IsSeaHegemonyScene()
	}

	//是否野外场景
	public IsOutdoorScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return (sceneInfo && sceneInfo.type == 1)
	}

	public IsTopPkScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id >= 7001 && scene_id <= 7002
	}
	public IsSentientActScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 41001 || scene_id == 41002
	}

	public IsGhostWalkScene(scene_id?) {
		let sceneInfo = this.GetSceneInfo(scene_id)
		if (sceneInfo) {
			return sceneInfo.type == DUN_TYPE.GHOST_WALK
		} else {
			return false
		}
	}

	public IsStarDungeonScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 5502
	}

	//是否副本场景
	public IsDungeonScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		if (sceneInfo) {
			return sceneInfo.type == 2 || this.IsMainLineDungeonScene(scene_id)
		} else {
			return false
		}
	}

	//是否是在跨服场景 .加入会自动添加 区服 攻击模式、在名字前加服务器标识
	public InServerScene(scene_id?) {
		scene_id = scene_id || this.GetSceneId()
		let sceneInfo = this.GetSceneInfo(scene_id)
		if (sceneInfo) {
			return sceneInfo.cls_type == 1
		} else {
			return false
		}
	}


	//是否钻石大战战斗
	public IsDiamondFightScene(scene_id?) {

		scene_id = scene_id == null && this.GetSceneId() || scene_id
		return scene_id == 24006
	}

	//是否钻石大战等待
	public IsDiamondFightWaitingScene(scene_id?) {

		scene_id = scene_id == null && this.GetSceneId() || scene_id
		return scene_id == 24005
	}


	public IsExpScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 2002
	}

	//显示所有伤害飘字的场景
	public ShowAllDamageScene() {

		return this.IsTopPkScene()
	}

	//每个场景的复活类型
	public GetReliveType(scene_id?) {

		if (this.IsDungeonScene(scene_id)) {
			return 9
		} else if (this.IsCSPvP(scene_id)) {
			return 10
		} else {
			return 1
		}
	}

	

	//判断两个角色是否友方
	public IsFriendlyRole(vo1?, vo2?) {

		vo2 = vo2 || RoleManager.Instance.mainRoleInfo
		let is_friendly = false
		if (vo1.role_id == vo2.role_id) {
			is_friendly = true
		} else if (vo1.warGroup == vo2.warGroup && vo1.warGroup > 0) {
			is_friendly = true
		} else if (vo1.warGroup == vo2.warGroup && vo1.warGroup == 0) {
			if (vo1.team_id == vo2.team_id && vo1.team_id > 0) {
				is_friendly = true
			} else if (vo1.guild_id == vo2.guild_id && vo1.guild_id > 0) {
				is_friendly = true
			}
		}
		return is_friendly
	}


	/**
	 * 怪物是否可以被攻击
	 * @param defender_vo 被击目标vo
	 * @param same_group 是否同组
	 * @param same_guild 是否同工会
	 * @param guaji_flag 挂机标识
	 * @param contain_collect_type 判断是否包含采集类型 
	 * @returns 
	 */
	public MonsterIsCanBeAttack(defender_vo?, same_group?, same_guild?, guaji_flag?, contain_collect_type?) {

		if (defender_vo && defender_vo.hp != 0) {
			guaji_flag = guaji_flag == null && true || guaji_flag
			contain_collect_type = contain_collect_type == null && true || contain_collect_type
			if (same_group || same_guild) {
				return false
			} else {
				let ignore_can_attack = false
				if (this.IsEveningScene() && defender_vo.type == MonsterType.COLLECT) {
					ignore_can_attack = true
				} else if (this.IsSeaHegemonyScene() && defender_vo.type == MonsterType.NORMAL) {
					ignore_can_attack = true
				} else if (
					this.IsFieldScene()
					&& (
						defender_vo.type == MonsterType.COLLECT
						|| defender_vo.type == MonsterType.TASK_COLLECT
						|| defender_vo.type == MonsterType.PICK
						|| defender_vo.type == MonsterType.NOT_DEAD_COLLECT
						|| defender_vo.type == MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT
					)
				) {
					if (!TaskModel.GetInstance().HaveCollectTask(defender_vo.type_id)) {
						contain_collect_type = false
					}
				}

				if (
					(guaji_flag == true || defender_vo.guaji_flag == guaji_flag)
					&& (defender_vo.can_attack == 1 || ignore_can_attack)
					&& (
						(defender_vo.type != MonsterType.COLLECT
							&& defender_vo.type != MonsterType.TASK_COLLECT
							&& defender_vo.type != MonsterType.PICK
							&& defender_vo.type != MonsterType.NOT_DEAD_COLLECT
							&& defender_vo.type != MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT
						) || contain_collect_type)) {
					return true
				}
			}
		}
		return null
	}

	//是否在boss场景
	public IsBossScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return this.IsFieldBossScene(scene_id)
			|| this.IsFieldSpecialBossScene(scene_id)
			|| this.IsFieldInfiniteBossScene(scene_id)
			|| this.IsAbyssBossScene(scene_id)
			|| this.IsSuitBossScene(scene_id)
			|| this.IsHolyBossScene(scene_id)
			|| this.IsKfHolyAreaScene(scene_id)
			|| this.IsFeastBossScene(scene_id)
			|| this.IsHolyTerritory(scene_id)
			|| this.IsMysteryBossScene(scene_id)
			|| this.IsBossDoMainScene(scene_id)
			|| this.IsCrossWuxianBossScene(scene_id)
	}


	//需要显示|屏蔽玩家坐骑的场景
	public showHorseScene() {
		let sceneInfo = this.GetSceneInfo()
		return sceneInfo && sceneInfo.mount == 1 && !(this.IsMainLineDungeonScene())
	}


	//需要显示|屏蔽玩家称号的场景
	public showDsgtScene() {

		return !(this.IsStarDungeonScene())
	}

	//需要显示|屏蔽玩家小精灵的场景
	public showSpriteScene() {
		return !(
			this.IsDiamondFightScene()
			|| this.IsTopPkScene()
		
		
			|| this.IsCSPvP()
			|| this.IsOvnFightingScene()
			|| this.IsStarDungeonScene()
		)//or this.IsEscortScene()
	}

	//需要显示|屏蔽玩家伙伴的场景
	public showPartnerScene() {

		return !this.IsWeddingScene()
	}


	//需要显示|屏蔽玩家翅膀的场景
	public showWingScene() {

		return !(this.IsStarDungeonScene())
	}

	//需要显示|屏蔽玩家背饰的场景
	public showBackScene() {
		return !(this.IsStarDungeonScene())
	}

	//需要显示|屏蔽玩家活跃度的场景
	public showLivenessScene() {
		return !(this.IsStarDungeonScene())
	}

	//需要显示|屏蔽玩家武器的场景[人物动作会根据这个改动]
	public showWeaponScene() {

		return !(this.IsStarDungeonScene())// || this.IsBeachScene())//暂时先屏蔽这个沙滩场景
	}


	public CanAutoFightScene(scene_id?) {
		return !this.IsCSPvP() && !this.IsDiamondFightWaitingScene()
	}

	//显示结婚预告图标的场景
	public IsShowMarriageScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return (sceneInfo && (sceneInfo.type == 0 || sceneInfo.type == 1))
	}

	public CheckSceneFightSoundAvaliable(scene_id?) {

		return this.IsArenaFightScene()
	}

	//显示墓碑的场景
	public IsShowGraveScene() {

		return this.IsFieldBossScene()
			|| this.IsFieldInfiniteBossScene()
			|| this.IsFieldSpecialBossScene()
	}

	public AddGraveVo(boss_vo?) {
		if (!boss_vo) return
		this.grave_vo_list[boss_vo.boss_id] = boss_vo
		GlobalEventSystem.Fire(SceneEventType.GRAVE_VO_ADD, boss_vo)
	}

	public GetGraveVo(ins_id?) {

		return this.grave_vo_list[ins_id]
	}

	public DeleteGraveVo(ins_id?) {

		let vo = this.GetGraveVo(ins_id)
		if (vo) {
			delete this.grave_vo_list[ins_id]
			GlobalEventSystem.Fire(SceneEventType.GRAVE_VO_REMOVE, ins_id, vo)
			return vo
		}
	}

	public ClearAllGraveVo() {

		if (!(this.IsShowGraveScene())) {
			for (let k in this.grave_vo_list) {
				var vo = this.grave_vo_list[k]
				GlobalEventSystem.Fire(SceneEventType.GRAVE_VO_REMOVE, vo.instance_id, vo)
			}
			this.grave_vo_list = []
		}
	}

	//主城和野外场景
	public IsMainCityAndFieldScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return (sceneInfo && (sceneInfo.type == 0 || sceneInfo.type == 1))
	}

	//是否全场景，1为全场景 0为九宫格
	public IsBroadCastScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return (sceneInfo && sceneInfo.broadcast && sceneInfo.broadcast == 1)
	}


	public IsFieldBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 34
	}

	/**蜃气楼 无限层 */
	public IsCrossWuxianBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 54
	}

	public IsFieldSpecialBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 35
	}

	public IsFieldInfiniteBossScene(sceneId?) {
		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 56
	}


	public IsAbyssBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 22
	}

	public IsHolyBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 12
	}

	public IsMysteryBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		//本地 43  跨服 58
		return sceneInfo && sceneInfo.type == 58
	}

	public IsFeastBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 32
	}

	public IsMainLineDungeonScene(scene_id?) {
		let sceneInfo = this.GetSceneInfo(scene_id)
		return sceneInfo && sceneInfo.type == 40
	}


	public IsEternityScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 44
	}

	public IsForbidGodScene(scene_id?) {
		scene_id = scene_id || this.GetSceneId()
		let list = GodBefallModel.GetInstance()._scene_list
		if (!list) {
			return true
		}
		return IsInTable(String(scene_id), list) || this.IsSeaHegemonyScene() || this.IsKf1vnWaitingScene() || this.IsKf1vnFightScene()
		//return false
	}

	public AlwaysFindNearestTargetScene() {

		return this.IsDragonDungeon()
	}

	public IsGuildFightScene(scene_id?) {
		let sceneInfo
		if (scene_id) {
			sceneInfo = this.GetSceneInfo(scene_id)

		} else {
			sceneInfo = this.GetSceneInfo(this.GetSceneId())
		}

		return sceneInfo && sceneInfo.type == 8

		//return this.GetSceneId()==8001
	}

	public IsSuitBossScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 16
	}

	public IsSentientActDungeon(dun_id?) {

		dun_id = dun_id || this.GetCurrDunId()
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.SentientAct
		}
		return false
	}

	public IsExpDungeon(dun_id?) {
		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.Exp
		}
		return false
	}

	//限时爬塔
	public IsLimitTowerDungeon(dun_id?) {
		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.TOWER_LIMIT
		}
		return false
	}

	public IsDragonDungeon(dun_id?) {

		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.Dragon
		}
		return false
	}


	public IsHeartDungeon(dun_id?) {

		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.Heart
		}
		return false
	}

	public IsVipPersonalBossDungeon(dun_id?) {
		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.Vip_Rerson_Boss
		}
		return false
	}

	public IsReincarnationDungeon(dun_id?) {

		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.ReincarnationDun
		}
		// return false
	}

	public IsFullEffectScene(sceneId?, dun_id?) {

		return this.IsPolarDungeon(dun_id) || this.IsKFPolarDungeon(sceneId) || this.IsKFPolarDungeon(dun_id) || this.IsArenaFightScene(sceneId)
	}

	//竞技场
	public IsArenaFightScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 24001
	}

	/*
		璀璨之海
	*/
	public IsBrightSeaScene(scene_id?) {

		scene_id = scene_id == null && this.GetSceneId() || scene_id
		return scene_id == 51001 || scene_id == 51002
	}

	public IsSeaHegemonyScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id >= 49001 && scene_id <= 49005
	}

	public IsSeaAsserScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return sceneInfo && sceneInfo.type == 50
		//scene_id = scene_id == null && this.GetSceneId() || scene_id
		//return scene_id == 50001
	}

	public IsKfHolyAreaScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return sceneInfo && sceneInfo.type == 38
	}

	public IsHolyBattleWaitScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 47003 || scene_id == 47004
	}

	public IsHolyBattleFightScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 47001 || scene_id == 47002
	}

	public IsWeddingScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 8003
	}

	public IsEveningScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 2007
	}

	public IsGuildExploreScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 29001
	}

	/***最强王者  等待 */
	public IsKf1vnWaitingScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 24103
	}

	//最强王者 
	public IsKf1vnFightScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 24102 || scene_id == 24104
	}


	//最强王者 观战模式
	public IsKf1vnFightVistorScene() {
		return this.IsKf1vnFightScene() && Kf1vnModel.GetInstance().is_vistor
	}

	public IsPrivatePkScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 24001
	}

	public IsHolyTerritory(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return (scene_id == 36001 || scene_id == 36002) || scene_id == 36003
	}

	public IsMarriageDunScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 2028
	}

	public IsNoonPartyScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 2029
	}

	//伙伴副本
	public IsDungeonPartner(dun_id?) {

		dun_id = (dun_id != null && (dun_id) || (this.GetCurrDunId()))
		return dun_id >= 37001 && dun_id < 38000
	}

	public IsPolarDungeon(dun_id?) {

		dun_id = (dun_id != null && (dun_id) || (this.GetCurrDunId()))
		return dun_id >= 36001 && dun_id < 36101
	}

	public IsKFPolarDungeon(dun_id?) {

		dun_id = (dun_id != null && (dun_id) || (this.GetCurrDunId()))
		return dun_id >= 36101 && dun_id < 37000
	}

	public IsKfSingleRankScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id == 20010
	}

	public IsDWScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return sceneInfo && sceneInfo.type == 46
	}

	public IsBossDoMainScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 45
	}

	public IsConvoyScene(sceneId?) {

		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 48
	}

	public IsPickUpDropScene() {

		return this.IsPickUpDrop() || this.IsPickUpDropDun()
	}

	public IsPickUpDrop(scene_id?) {

		return this.IsFieldBossScene(scene_id)
			|| this.IsFieldSpecialBossScene(scene_id)
			|| this.IsFieldInfiniteBossScene(scene_id)
			|| this.IsBossSnatchTreasure(scene_id)
			|| this.IsHolyTerritory(scene_id)
			|| this.IsKfHolyAreaScene(scene_id)
			|| this.IsAbyssBossScene(scene_id)
			|| this.IsMysteryBossScene(scene_id)
			|| this.IsEternityScene(scene_id)
			|| this.IsBossDoMainScene(scene_id)
			|| this.IsDWScene(scene_id)
			|| this.IsSeaAsserScene(scene_id)
	}

	public IsPickUpDropDun(dun_id?) {

		return this.IsEquipDungeon(dun_id) || this.IsDragonDungeon(dun_id) || this.IsVipPersonalBossDungeon(dun_id)
	}

	public IsDropAllRange() {
		//全范围拾取
		return this.IsVipPersonalBossDungeon() || this.IsNoonPartyScene() || this.IsMainLineDungeonScene()
	}

	public IsPrivateScene(scene_id?) {

		return this.IsDungeonScene(scene_id) || this.IsMainLineDungeonScene(scene_id) || this.IsTopPkScene(scene_id) || this.IsPrivatePkScene(scene_id)
			|| this.IsKf1vnWaitingScene(scene_id) || this.IsKf1vnFightScene(scene_id) || this.IsDiamondFightWaitingScene(scene_id)
			|| this.IsDiamondFightScene(scene_id) || this.IsFieldSpecialBossScene(scene_id)
	}

	public IsNoTransferScene(scene_id?) {

		return this.IsPrivatePkScene(scene_id) || this.IsBossDoMainScene(scene_id)
	}

	public ShowTeamScene() {

		return this.IsFieldScene() || this.IsFieldBossScene() || this.IsFieldInfiniteBossScene() || this.IsAbyssBossScene() || this.IsEquipDungeon() || this.IsDragonDungeon()
			|| this.IsDWScene() || this.IsSentientActScene() || this.IsGhostWalkScene()
	}

	public HideTeamIconScene() {

		return this.IsArenaFightScene() || this.IsDiamondFightScene() || this.IsDiamondFightWaitingScene() || this.IsTopPkScene() || this.IsKf1vnFightScene()
			 || this.IsSeaHegemonyScene()
	}

	public DisabledPartnerSkillScene() {

		return this.IsPolarDungeon() || this.IsKFPolarDungeon() || this.IsSeaHegemonyScene()
	}

	public HideOnlyRoleScene() {

		return this.IsPolarDungeon()
			|| this.IsKFPolarDungeon()
			|| this.IsSeaHegemonyScene()
			|| this.IsArenaFightScene()
			|| this.IsKf1vnFightVistorScene()
			|| this.IsWeddingScene()
			|| this.IsPolarDungeon()
			|| this.IsKFPolarDungeon()
	}

	public CanMaskScene(sceneId?) {

		return this.IsFieldBossScene(sceneId)
			|| this.IsFieldSpecialBossScene(sceneId)
			|| this.IsFieldInfiniteBossScene(sceneId)
			|| this.IsAbyssBossScene(sceneId)
			|| this.IsSuitBossScene(sceneId)
			|| this.IsHolyBossScene(sceneId)
			|| this.IsFeastBossScene(sceneId)
			|| this.IsHolyTerritory(sceneId)
			|| this.IsMysteryBossScene(sceneId)
			|| this.IsBossDoMainScene(sceneId)
			|| this.IsKfHolyAreaScene(sceneId)
	}

	public NotShowHelpScene(sceneId?) {

		return this.IsSeaHegemonyScene(sceneId) || this.IsNoonPartyScene(sceneId) || this.IsSeaAsserScene(sceneId) || this.IsHolyBattleFightScene(sceneId)
			|| this.IsHolyBattleWaitScene(sceneId) || this.IsPolarDungeon(sceneId) || this.IsKFPolarDungeon(sceneId)
	}

	public NotShowNotificationScene(sceneId?) {

		return this.IsPolarDungeon(sceneId) || this.IsKFPolarDungeon(sceneId)
	}



	public IsForceBlockScene(sceneId?, dun_id?) {

		return !(this.IsFieldScene(sceneId) || this.IsDungeonScene(sceneId) && (this.IsEquipDungeon(dun_id) || this.IsDragonDungeon(dun_id)) || this.IsTopPkScene(sceneId))
	}

	public IsBossSnatchTreasure(sceneId?) {
		let sceneInfo = this.GetSceneInfo(sceneId)
		return sceneInfo && sceneInfo.type == 37
	}

	public IsNineSkyFightScene(scene_id?) {

		let sceneInfo = this.GetSceneInfo(scene_id)
		return sceneInfo && sceneInfo.type == 27
	}

	public IsKfNineSkyFightScene(scene_id?) {

		scene_id = scene_id || this.GetSceneId()
		return scene_id > 27010 && scene_id < 27020
	}

	//是否是寻装觅刃
	public IsEquipDungeon(dun_id?) {
		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.Equip
		}

		return false
	}

	//是否是日常副本
	public IsDailyDungeon(dun_id?) {

		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.Daily
		}
		// return false
	}//是否是新主线副本
	public IsNewMainLineDungeon(dun_id?) {

		if (dun_id == null) {
			dun_id = this.GetCurrDunId()
		}
		let dun_type = this.GetDunType(dun_id)
		if (dun_type) {
			return dun_type == DUN_TYPE.New_Main_Line
		}
		// return false
	}


	public GetAngle(pos1?, pos2?, real_pos?) {

		let x = 0
		let y = 0
		if (real_pos) {
			x = pos2.x - pos1.x
			y = pos2.y - pos1.y
		} else {
			x = pos1
			y = pos2
		}
		let radian = Math.atan2(y, x)
		// let angle = 180 / (Math.pi / radian)
		let angle = 57.295779 * radian
		return Math.floor(angle + 0.5)
	}

	public GetRandomMonsterVoByTypeId(type_id, not_instance_id) {
		let tb = []
		let monster_vo
		for (let id in this.monster_vo_list) {
			monster_vo = this.monster_vo_list[id]
			if (monster_vo.type_id == type_id) {
				table.insert(tb, monster_vo)
			}
		}

		if (tb.length > 1) {
			let times = 0
			while (times < 1000) {
				times = times + 1
				let rand = Util.RandomRange(0, tb.length)
				if (tb[rand] && tb[rand].instance_id != not_instance_id) {
					return tb[rand]
				}
			}
		}
		else if (tb.length == 1 && tb[0].instance_id != not_instance_id) { //只有一只怪物
			return tb[1]
		}
	}

	public GetDunType(dun_id) {
		return Config.PRELOAD_SERVER_CONFIG.config_dungeon_type && Config.PRELOAD_SERVER_CONFIG.config_dungeon_type[dun_id] && Config.PRELOAD_SERVER_CONFIG.config_dungeon_type[dun_id].type

	}


	public AddJumpPointVo(jump_vo?) {

		this.jump_vo_list[jump_vo.instance_id] = jump_vo
		GlobalEventSystem.Fire(SceneEventType.JUMPPOINT_VO_ADD, jump_vo)
	}

	public ClearAllJumpPointVo() {
		for (let k in this.jump_vo_list) {
			var _ = this.jump_vo_list[k]
			GlobalEventSystem.Fire(SceneEventType.JUMPPOINT_VO_REMOVE, k)
		}
		this.jump_vo_list = {}
	}


	public SetLastFightMsg(type, msg) {
		let old_msg = this.last_fight_msg[type]
		if(old_msg){
			FightManager.GetInstance().pushFightInfoList(old_msg)
		}
		this.last_fight_msg[type] = msg
	}

	public GetLastFightMsg(type) {
		return this.last_fight_msg[type]
	}
}
window["SceneManager"] = SceneManager