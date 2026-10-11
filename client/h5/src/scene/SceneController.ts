import { BaseController } from "../common/BaseController";
import { SceneManager } from "./SceneManager";
import { Scene } from "./Scene";
import { SceneBaseType, MOVE_TYPE, MonsterType } from "./SceneConfig";
import { BaseClass } from "../common/BaseClass";
import { Runner } from "../util/Runner";
import { FRAME_TYPE } from "../util/DeclareGlobalVar";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SceneEventType, EventName } from "../common/EventName";
import { RoleManager } from "../commonModel/RoleManager";
import { RoleVo, ModelPartPos } from "../sharedata/RoleVo";
import { AutoFightManager } from "../autofight/AutoFightManager";
import { GameError } from "../util/GameError";
import { GlobalTimerQuest, Util } from "../util/Util";
import { MonsterVo } from "../sharedata/MonsterVo";
import { Vector2 } from "../util/Vector2";
import { Monster } from "./sceneobj/Monster";
import { SkillBuffType } from "./fight/BuffManager";
import { FightDamageFlag } from "./fight/FightDamageManager";
import { SceneObj } from "./sceneobj/SceneObj";
import { OtherVo } from "../sharedata/OtherVo";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { Config } from "../common/Config";
import { SkillManager } from "../skill/SkillManager";
// import { LoginModel } from "../login/LoginModel";
import { ParticleManager } from "../particalEffect/ParticleManager";
import { Character } from "./sceneobj/Character";
import { table } from "../common/table";
import { SourceOperateMove } from "../operation/SourceOperateMove";
import { BossModel } from "../commonModel/BossModel";
import { EffectResType } from "../scene/SceneConfig";
import { SoundManager } from "../common/SoundManager";
import { ResManager } from "../common/ResManager";
import { SapManager } from "./SapManager";
import { OperateManager } from "../operation/OperateManager";
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel";
import { TaskModel, TaskTipType } from "../commonModel/TaskModel";
import { GameMath } from "../util/GameMath";
import { LayerManager } from "../common/LayerManager";
// TypeScript file
export class SceneController extends BaseController {
	static Instance: SceneController;
	scene_mgr = SceneManager.GetInstance();
	scene = Scene.GetInstance();
	//private
	private is_first_handler12002 = false; //是否首次处理12002 是的话第一次不用清理场景对象 因为第一次本来就没有
	private temp_instance_id;
	request_12005_id;
	private change_scene_event_id;
	private frame_index = 0;
	private _request_12089_last_time;
	private _create_feild_boss_role_id;
	public change_scene_call_back;
	force_update_in_next_frame
	lastDeleteMonster;
	lastDeleteMonsterType;
	private _hash_target: BaseClass = new BaseClass();
	Update;
	DealWithDropListVo
	lvup_effect_num = 0
	lvup_effect_max = 2

	collect_effect
	collect_target_effect
	last_target

	public constructor() {
		super();
		// this.scene.InitSceneFunction();
		Runner.GetInstance().AddRunObjByHashCode(this._hash_target.hashCode, this, 1, FRAME_TYPE.odd);
		this.InitInfo();
	}
	public static GetInstance() {
		if (!SceneController.Instance) {
			SceneController.Instance = new SceneController();
		}
		return SceneController.Instance;
	}
	public InitInfo = () => {
		let g_event = GlobalEventSystem, Scene_Event_Type = SceneEventType, local_SceneBaseType = SceneBaseType, Event_Name = EventName, role_mgr = RoleManager.GetInstance(), mainrole_vo = RoleManager.GetInstance().GetMainRoleVo(), SendFmtToGame = this.SendFmtToGame, scene_mgr = this.scene_mgr, local_MOVE_TYPE = MOVE_TYPE, scene = this.scene;
		let local_ViewManager = window["ViewManager"]
		let layer_mgr = LayerManager.GetInstance()
		this.Update = (now_time, elapse_time) => {
			if (!this.force_update_in_next_frame && !layer_mgr.CheckFrameTimeValid()) {
				this.force_update_in_next_frame = true
				return
			} else {
				this.force_update_in_next_frame = false
			}
			this.frame_index = this.frame_index + 1;
			if (this.frame_index % local_ViewManager.OPENBIGVIEWFRAME != 0) return
			scene_mgr.AddDelaydDropVo();
			if (this.frame_index % 13 == 0)
				scene_mgr.AddDelayRoleVo();
			else if (this.frame_index % 3 == 0)
				scene_mgr.AddDelaydMonsterVo();
		};
		let On12001 = () => {
			let [x, y, role_id, fly_flag] = //是否轻功
				this.ReadFmt("hhlc");
			let start_fly_x, start_fly_y = 0;
			if (fly_flag != local_MOVE_TYPE.NORMOL_MOVE) //非正常走路
			{
				start_fly_x = this.ReadFmt("h");
				start_fly_y = this.ReadFmt("h");
				// console.log("//-handler12001//",x,y,role_id,fly_flag,role_id,start_fly_x,start_fly_y)

				if (fly_flag == local_MOVE_TYPE.DOOR_JUMP) {
					SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.MOVE_THOURHGT_DOOR)
				}
			}

			if (role_mgr.GetMainRoleDepositState() || role_id != mainrole_vo.role_id) {
				if (!scene_mgr.can_receive_scene_protocal)
					return;
				scene.RoleMove(role_id, x, y, fly_flag, start_fly_x, start_fly_y);
			}
			else {
			}
		};
		let On12002 = () => {
			console.warn("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 收到12002", scene_mgr.isStart);
			scene_mgr.has_recevie_12002 = true;
			if (scene_mgr.IsSceneStart()) {
				return;
			}
			if (!this.is_first_handler12002)
				scene_mgr.ClearAllVo();
			this.is_first_handler12002 = false;
			//处理传送阵和NPC，里面会判断是否需要重新加载
			scene_mgr.LoadNpcsAndDoors();
			//处理场景内的跳点
			//scene_mgr.LoadJumpPoints()
			// //进入主城安全场景
			// EventSystem.Fire(g_event,StateEvent.CHANGE_SCENE_RECOVER_HP)
			//处理玩家
			scene_mgr.ResetCachedRoleList(); //重置缓存队列
			let add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12003();
			// console.log("++++++++++++玩家数量==：", add_num)
			//处理怪物
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12007();

			//处理伙伴
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12013();
			// end
			//处理其他场景对象
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12014();
			//假人
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12015();
			//动态区域
			On12030();

			//请求上线时要显示的掉落
			this.SendFmtToGame(12018)

			let main_role_vo = role_mgr.GetMainRoleVo()
			if (this.scene.IsSceneLoaded()) {
				SapManager.GetInstance().Update(main_role_vo.pos_x, main_role_vo.pos_y, true)
			}


			OnSceneStartProtocal();
		};
		let OnSceneStartProtocal = () => {
			scene_mgr.SceneStart();
		};
		let On12003 = () => {
			let role_vo: RoleVo = scene_mgr.CreateRoleVo();
			role_vo.ReadFromProtocal();
			// console.warn("12003------------玩家进入---------：", role_vo.name);
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			scene_mgr.AddRoleVo(role_vo, true);
		};
		let On12004 = () => {
			let role_id = this.ReadFmt("l");
			// console.warn("12004-------玩家离开-------：", role_id);
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			scene_mgr.DeleteRoleVo(role_id);
		};
		let On12005 = () => {
			let [instance_id, //场景实例ID(int32)
				pos_x, //进入场景的X坐标(int16)
				pos_y, //进入场景的Y坐标(int16)
				error_code, //错误信息(int32)
				dun_id,
				call_back_type,
				send_type
			] = this.ReadFmt("ihhiicc");
			// console.log("12005//-:", send_type)
			console.warn("//handler12005//-", call_back_type, instance_id, scene_mgr.GetSceneId(), scene_mgr.last_scene_id, dun_id, pos_x, pos_y, send_type, error_code);
			if (this.request_12005_id && this.request_12005_id != instance_id) {
				console.log(`---------------------------------------测试！请求的场景id是${this.request_12005_id},返回的id是${instance_id}`);
				this.request_12005_id = null;
			}
			this.temp_instance_id = instance_id;
			if (instance_id != 0) {
				if (mainrole_vo) {
					mainrole_vo.lastSceneId = instance_id;
					mainrole_vo.dun_id = dun_id;
				}
				// if(this.change_scene_event_id)
				// {
				//	 clearTimeout(this.change_scene_event_id)
				//	 this.change_scene_event_id = null 
				// }
				//初始化坐标之前初始化主角状态
				scene.ClearMainRoleFindWayState()
				scene_mgr.SetCurrentSceneId(instance_id);
				scene_mgr.SetCurrDunId(dun_id);
				mainrole_vo.pos_x = pos_x;
				mainrole_vo.pos_y = pos_y;
				// if (scene_mgr.last_scene_id != instance_id) {
				// scene_mgr.ClearAllVo()
				// let delay_fun = () =>
				// {
				// this.change_scene_event_id = null
				// scene.ClearScene()
				//加载场景信息
				scene.ChangeScene(instance_id);
				// scene.CreateMainRole()
				//申请12002切换场景
				g_event.Fire(Scene_Event_Type.SCENE_CHANGED, instance_id);
				// }
				// this.change_scene_event_id = setTimeout(delay_fun, 0.1)
				// }
			}
			else {
				Util.ErrorCodeShow(error_code);
				this.change_scene_call_back = null;
			}
		};
		let On12006 = () => {
			let instance_id = this.ReadFmt("i");
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			let vo = scene_mgr.DeleteMonsterVo(instance_id);
			if (vo == null) {
				vo = scene_mgr.DeleteOtherVo(instance_id);
				if (vo == null)
					vo = scene_mgr.DeleteRoleVo(instance_id);
			}
			else {
				this.lastDeleteMonster = instance_id;
				this.lastDeleteMonsterType = vo.type_id;
			}
		};
		let On12007 = () => {
			let monster_vo: MonsterVo = scene_mgr.CreateMonsterVo();
			monster_vo.ReadFromProtocal();
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			if (monster_vo.attributive_id && monster_vo.attributive_id != mainrole_vo.role_id) {
				return;
			}
			scene_mgr.AddMonsterVo(monster_vo, true);
		};
		let On12008 = () => {
			let [pos_x, //X坐标(int16)
				pos_y, //Y坐标(int16)
				instance_id] = //实例ID(int32)
				this.ReadFmt("hhi");
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			let vo = scene_mgr.GetSceneObjVo(instance_id);
			if (vo) {
				if (vo.vo_type == local_SceneBaseType.Monster)
					scene.MonsterMove(instance_id, pos_x, pos_y);
				else if (vo.vo_type == local_SceneBaseType.Role)
					scene.RoleMove(instance_id, pos_x, pos_y);
				else if (vo.vo_type == local_SceneBaseType.Other)
					scene.OtherMove(instance_id, pos_x, pos_y);
			}
			else {
				let delay_mon_vo = scene_mgr.GetDelayMonsterVo(instance_id);
				if (delay_mon_vo) {
					delay_mon_vo.pos_x = pos_x;
					delay_mon_vo.pos_y = pos_y;
				}
			}
		};
		let On12009 = () => {
			let [obj_id, //ID(int32)
				hp, //当前血量(int32)
				maxHp] = //最大血量(int32)
				this.ReadFmt("lll");
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			let objVo = scene_mgr.GetSceneObjVo(obj_id);
			if (objVo) {
				g_event.Fire(Event_Name.EXECUTE_DELEY_FIGHT_INFO);
				let delta = hp - objVo.hp;
				let obj = scene.GetSceneObj(obj_id);
				if (obj)
					g_event.Fire(Event_Name.HP_CHANGE_FROM_SCENE, obj, delta);
				objVo.ChangeVar("hp", hp);
				objVo.ChangeVar("maxHp", maxHp);
				if (hp == 0) {
					if (obj)
						obj.DoDead();
				}
			}
			else
				console.log("warning! can not find a obj to handle move response!");
		};
		let On12010 = () => {
			let role_id = this.ReadFmt("l");
			let len = this.ReadFmt("h");
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			let list = [];
			for (let i = 0; i < len; i++) {
				list.push({
					style: this.ReadFmt("c"),
					value: this.ReadFmt("i")
				});
			}
			scene.RoleOtherProChange(role_id, list);
		};
		let On12011 = () => {
			let add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12003();
			let remove_num = this.ReadFmt("h");
			for (let i = 0; i < remove_num; i++) {
				let role_id = this.ReadFmt("l");
				scene_mgr.DeleteRoleVo(role_id);
			}
		};
		let On12012 = () => {
			let add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12007();
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12013();
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12014();
			//假人
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++)
				On12015();
			let remove_num = this.ReadFmt("h");
			for (let i = 0; i < remove_num; i++)
				On12006();
			// g_event.Fire(Scene_Event_Type.UPDATE_ROLE_LIMIT)
		};
		let On12017 = () => {
			let vo = {
				mon_id: 0,
				display_time: 0,
				map_id: 0,
				drop_list: []
			}, len, vo2

			[vo.mon_id, vo.display_time, vo.map_id, len] = this.ReadFmt("ihih");

			for (let i = 0; i < len; i++) {
				vo2 = {
					drop_id: this.ReadFmt("l"),
					drop_type: this.ReadFmt("c"),
					type_id: this.ReadFmt("i"),
					drop_num: this.ReadFmt("i"),
					role_id: this.ReadFmt("l"),
					server_id: this.ReadFmt("h"),
					team_id: this.ReadFmt("l"),
					camp: this.ReadFmt("h"),
					guild_id: this.ReadFmt("l"),
					pos_x: this.ReadFmt("h"),
					pos_y: this.ReadFmt("h"),
					put_str: this.ReadFmt("s"),
					put_icon: this.ReadFmt("s"),
					pick_up_time: this.ReadFmt("i") / 1000,
					over_time: this.ReadFmt("i"),
					show_type: this.ReadFmt("c"),// 0 普通需要拾取的掉落 1 直接进背包 2也只直接进背包 但是会走客户端模拟的掉落流程
					assign_type: this.ReadFmt("c"),//分配类型 主要是服务端用来  客户端只判断等于7的情况
					display_time: vo.display_time,
					mon_id: vo.mon_id
				};

				vo.drop_list.push(vo2);
			}

			let [mon_pos_x, mon_pos_y, boss_type] = this.ReadFmt("hhc")

			for (let v of vo.drop_list) {
				v.mon_pos_x = mon_pos_x
				v.mon_pos_y = mon_pos_y
				v.boss_type = boss_type
			}

			if (len > 0) {
				g_event.Fire(Scene_Event_Type.DEAL_WITH_SCENE_DROP_LIST_VO, vo)
			}

			if (scene_mgr.IsDWScene()) {
				BossModel.GetInstance().SetDropDic(vo.drop_list)
			}
		};
		let On12018 = () => {
			let vo = {
				drop_list: [],
				map_id: 0
			}, vo2

			let len = this.ReadFmt("h");
			for (let i = 0; i < len; i++) {
				vo2 = {
					drop_id: this.ReadFmt("l"),
					drop_type: this.ReadFmt("c"),
					type_id: this.ReadFmt("i"),
					drop_num: this.ReadFmt("i"),
					role_id: this.ReadFmt("l"),
					server_id: this.ReadFmt("h"),
					team_id: this.ReadFmt("l"),
					camp: this.ReadFmt("h"),
					guild_id: this.ReadFmt("l"),
					pos_x: this.ReadFmt("h"),
					pos_y: this.ReadFmt("h"),
					drop_effect: this.ReadFmt("s"),
					put_icon: this.ReadFmt("s"),
					pick_up_time: this.ReadFmt("i") / 1000,
					pick_up_role_id: this.ReadFmt("l"),
					pick_up_end_time: this.ReadFmt("l") / 1000,
					over_time: this.ReadFmt("i"),
					show_type: this.ReadFmt("c"),// 1 直接掉落拾取 2直接进背包 3模拟掉落自动进背包
					mon_id: this.ReadFmt("i"),
					mon_pos_x: this.ReadFmt("h"),
					mon_pos_y: this.ReadFmt("h"),
					assign_type: this.ReadFmt("c"),//分配类型 主要是服务端用来  客户端只判断等于7的情况
					no_anim: true

				};
				vo.drop_list.push(vo2);
			}
			vo.map_id = scene_mgr.GetSceneId()
			if (len > 0) {
				g_event.Fire(Scene_Event_Type.BROADCAST_SCENE_DROP_LIST, vo);
			}

		};
		let On12019 = () => {
			let len = this.ReadFmt("h");
			for (let i = 0; i < len; i++) {
				let drop_id = this.ReadFmt("l");
				g_event.Fire(Scene_Event_Type.DISMISS_SCENE_DROP, drop_id)

				SapManager.GetInstance().UnRegisterObj(SapManager.ObjType.Drop, drop_id)
				SapManager.GetInstance().RefreshView()
			}
		};
		let On12020 = () => {
			let npc_num = this.ReadFmt("h")
			for (let i = 1; i <= npc_num; i++) {
				let npc_ins_id, task_flag = this.ReadFmt("ic")
				let npcvo = SceneManager.Instance.GetNpcVo(npc_ins_id)
				if (npcvo) {
					npcvo.ChangeVar("task_icon", Number(task_flag))
				}
			}
		};
		let On12022 = () => {
			let role_id = this.ReadFmt("l");
			let boss_owner = this.ReadFmt("c");
			let vo = SceneManager.GetInstance().GetRoleVo(role_id);
			if (vo) {
				vo.ChangeVar("boss_flag", boss_owner, null, true);
			}
			g_event.Fire(Event_Name.BOSS_OWNER_SHIP_CHANGE, role_id, boss_owner);
		};

		let On12023 = () => {
			let monster_id = this.ReadFmt("i");
			let talk_content = this.ReadFmt("s");
			let mon: Monster = Scene.GetInstance().GetMonster(monster_id);
			if (mon) {
				mon.CreateTalkBoard(talk_content, 3, null, true);
			}
		};

		let On12024 = () => {
			let drop_id = this.ReadFmt("l");
			let role_id = this.ReadFmt("l");
			let pick_up_end_time = this.ReadFmt("l");
		};

		let On12025 = () => {
			let monster_id = this.ReadFmt("i");
			let monster_type_id = this.ReadFmt("i");
			let len = this.ReadFmt("h");
			let list = [];
			for (let i = 0; i < len; i++) {
				let obj = {
					player_id: this.ReadFmt("l"),
					player_name: this.ReadFmt("s"),
					server_id: this.ReadFmt("h"),
					server_num: this.ReadFmt("h"),
					server_name: this.ReadFmt("s"),
					team_id: this.ReadFmt("l"),
					team_position: this.ReadFmt("c"),
					damage: this.ReadFmt("l"),
					assist_id: this.ReadFmt("l"),
				};
				list.push(obj);
			}
			g_event.Fire(Event_Name.UPDATE_BOSS_DAMAGE_DATA, monster_id, list, monster_type_id);
		};

		let On12026 = () => {
			let scmd = {
				monster_id: this.ReadFmt("i"),
				monster_type_id: this.ReadFmt("i"),
				player_id: this.ReadFmt("l"),
				player_name: this.ReadFmt("s"),
				server_id: this.ReadFmt("h"),
				server_num: this.ReadFmt("h"),
				server_name: this.ReadFmt("s"),
				team_id: this.ReadFmt('l'),
				team_position: this.ReadFmt('c'),
				damage: this.ReadFmt("l"),
				assist_id: this.ReadFmt("l"),
			};
			g_event.Fire(Event_Name.ADD_BOSS_DAMAGE_DATA, scmd);
		};

		let On12027 = () => {
			let monster_id = this.ReadFmt("i");
			let monster_type_id = this.ReadFmt("i");
			let len = this.ReadFmt("h");
			let list = [];
			for (let i = 0; i < len; i++) {
				let obj = {
					player_id: this.ReadFmt("l"),
				};
				list.push(obj);
			}
			g_event.Fire(Event_Name.REMOVE_BOSS_DAMAGE_DATA, monster_id, list, monster_type_id);
		};

		let On12036 = () => {
			let [
				obj_type,
				obj_id,
				hp, //当前血量(int32)
				maxHp,
				symbol, //符号，0代表正数，1代表负数
				change_value,
				buff_type,
				attacker_type,
				attacker_id
			] = this.ReadFmt("clllclhcl");

			if (!scene_mgr.can_receive_scene_protocal)
				return;
			let objVo;
			let obj;
			if (obj_type == local_SceneBaseType.Monster) {
				objVo = scene_mgr.GetMonsterVo(obj_id);
				obj = scene.GetMonster(obj_id);
			}
			else if (obj_type == local_SceneBaseType.Role || obj_type == local_SceneBaseType.Fake_Role) {
				objVo = scene_mgr.GetRoleVo(obj_id);
				obj = scene.GetRole(obj_id);
			}
			if (objVo) {
				g_event.Fire(Event_Name.EXECUTE_DELEY_FIGHT_INFO);
				let delta = change_value;
				if (symbol) {
					delta = -change_value;
				}
				objVo.ChangeVar("hp", hp);
				objVo.ChangeVar("maxHp", maxHp);
				if (hp == 0) {
					if (obj) {
						obj.DoDead();
					}
				}

				if (obj) {
					let attacker_obj;
					if (attacker_type == local_SceneBaseType.Monster) {
						attacker_obj = scene.GetMonster(attacker_id);
					}
					else if (attacker_type == local_SceneBaseType.Role || attacker_type == local_SceneBaseType.Fake_Role) {
						attacker_obj = scene.GetRole(attacker_id);
					}

					if (attacker_obj) {
						let damage_flag = 0;
						if (buff_type == SkillBuffType.SUCK_BLOOD) {
							damage_flag = FightDamageFlag.XiXue;
						} else if (buff_type == SkillBuffType.REVERT_DAMAGE) {
							damage_flag = FightDamageFlag.FanTan;
						} else if (buff_type == SkillBuffType.BLEEDING || buff_type == SkillBuffType.TIANFU_BLOOD) {
							damage_flag = FightDamageFlag.LiuXue;
						}
						g_event.Fire(Event_Name.HP_CHANGE_FROM_SCENE, obj, delta, damage_flag, attacker_obj);
					}
				}
			}
			else
				console.log("warning! can not find a obj to handle move response!");
		};

		let On12080 = () => {
			let instance_id = this.ReadFmt("i");
			let vo = scene_mgr.GetSceneObjVo(instance_id);
			if (vo) {
				let len = this.ReadFmt("h");
				let type, value;
				for (let i = 0; i < len; i++) {
					let [type, value] = this.ReadFmt("ci");
					switch (type) {
						case 3:
							vo.ChangeVar("can_attack", value);
							break;
					}
				}
			}
		};
		let On12082 = () => {
			let [type, instance_id, move_speed] = this.ReadFmt("clh");
			if (type == local_SceneBaseType.Monster) {
				let vo = scene_mgr.GetMonsterVo(instance_id);
				if (vo) {
					vo.ChangeVar("move_speed", move_speed)
				}
			}
			else if (type == local_SceneBaseType.Role) {
				let vo = scene_mgr.GetRoleVo(instance_id);
				if (vo) {
					vo.ChangeVar("move_speed", move_speed)
				}
			}
			else if (type == local_SceneBaseType.Other) {
				let vo = scene_mgr.GetOtherVo(instance_id);
				if (vo) {
					vo.ChangeVar("move_speed", move_speed)
				}
			}
		};
		let On12083 = () => {
			let [rType, rsid, rx, ry, rsname, rhp, ryb, ybyb, yptime] = this.ReadFmt("cihhsliih");
			mainrole_vo.ChangeVar("pos_x", rx);
			mainrole_vo.ChangeVar("pos_y", ry);
			mainrole_vo.ChangeVar("hp", rhp);
			mainrole_vo.ChangeVar("jin", ryb);
			mainrole_vo.ChangeVar("jinLock", ybyb);
			console.warn("handler12083 rType, rx, ry, rsid, osid = ", rType, rx, ry, rsid, scene_mgr.GetSceneId());
			if (rType == 1) {
				if (scene.GetMainRole()) {
					scene.GetMainRole().Revived();
				}
			}
			else if (rType == 2) {
				ReIntoScene(rsid, rsname, rx, ry);
			}
			//SkillManager.GetInstance().ClearAllSkillCD()
			g_event.Fire(Event_Name.RELIVE_COMPLETE, rType);
			g_event.Fire(Event_Name.REQUEST_RELIVE_TIMES);
			if (role_mgr.GetMainRoleVo().is_fighting_state) {
				this.Fire(Event_Name.CHANGE_FIGHTING_STATE, false);
			}
		};
		let On12085 = () => {
			let [role_id, safe_area_state] = this.ReadFmt("lc");
			let role_vo = scene_mgr.GetRoleVo(role_id);
			if (role_vo) {
				role_vo.ChangeVar("safe_area_state", safe_area_state, null, true);
			}
		};
		let On12013 = () => {
			// let partner_vo = new PartnerVo()
			// partner_vo.ReadFromProtocal()
			// scene_mgr.AddPartnerVo(partner_vo)
		};
		let On12014 = () => {
			let other_vo = new OtherVo();
			other_vo.ReadFromProtocal();
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			scene_mgr.AddOtherVo(other_vo);
		};
		let On12015 = () => {
			let role_vo = new RoleVo();
			role_vo.ReadFakeProtacal();
			console.warn("12015------------假人进入---------：", role_vo.name);
			if (!scene_mgr.can_receive_scene_protocal)
				return;
			scene_mgr.AddRoleVo(role_vo); //延迟加载
		};
		let On12030 = () => {
			let len = this.ReadFmt("h");
			for (let i = 0; i < len; i++) {
				let [area_id, area_type] = this.ReadFmt("cc");
				if (area_id && area_type) {
					let client_index = Scene.ServerAreaIndex[area_type];
					if (client_index)
						Scene.Instance.SetDynamicArea(area_id, client_index);
				}
			}
		};
		let On12072 = () => {
			let [target_type, id, warGroup] = this.ReadFmt("cll");
			let vo = null;
			if (target_type == local_SceneBaseType.Monster) {
				vo = scene_mgr.GetMonsterVo(id);
			}
			else if (target_type == local_SceneBaseType.Role || target_type == local_SceneBaseType.Fake_Role) {
				vo = scene_mgr.GetRoleVo(id);
			}
			if (vo) {
				vo.ChangeVar("warGroup", warGroup);
			}
		};
		let On12078 = () => {
			let id = this.ReadFmt("l");
			let vo = scene_mgr.GetRoleVo(id);
			if (vo) {
				let newVo: RoleVo = new RoleVo();
				(new FigureProtoVo()).ReadFmt(newVo);
				vo.ChangeVar("marriage_name", newVo.marriage_name);
				if (id == mainrole_vo.role_id && newVo.career != mainrole_vo.career)
					mainrole_vo.changeCareer(newVo);
			}
		};
		let On12100 = () => {
			let scene_id = this.ReadFmt("i");
			let len0 = this.ReadFmt("h");
			let npc_dic = {};
			let vo0 = null;
			for (let i = 0; i < len0; i++) {
				vo0 = {
					npc_id: this.ReadFmt("i"),
					is_show: this.ReadFmt("c"),
					scene_id: this.ReadFmt("i"),
					x: this.ReadFmt("h"),
					y: this.ReadFmt("h"),
					args: this.ReadFmt("s")
				};
				// npc_list.push(vo0)
				npc_dic[vo0.npc_id] = vo0;
			}
			if (scene_id != scene_mgr.GetSceneId()) {
				return
			}
			// if(scene_mgr.IsFieldScene() && len0 == 0){
			// 	GameError.Instance.SendErrorToPHP("On12100 npc count is 0 , scene_id = " + scene_id)
			// }
			console.warn("npc---12100----------:", scene_id, len0)
			scene_mgr.SetNpcList(npc_dic);
			SendFmtToGame.call(this, 12002, "");
		};

		let On12103 = () => {
			let scmd = UserMsgAdapter.GetInstance().GetSCMD(12103)
			if (scmd.npc_list) {
				for (let i = 0; i < scmd.npc_list.length; i++) {
					var v = scmd.npc_list[i]
					if (v.scene_id == SceneManager.GetInstance().GetSceneId()) {
						if (v.is_show == 0) {
							SceneManager.Instance.DynamicDelNpc(v.npc_id)
						} else {
							SceneManager.Instance.DynamicAddNpc(v.npc_id, v.x, v.y, v.args)
						}
					}
				}
			}
		};

		let On13200 = () => {
			let scmd = UserMsgAdapter.GetInstance().GetSCMD(13200);
		};
		let On13205 = () => {
		};
		let ReIntoScene = (rsid, rsname, pos_x, pos_y) => {
			let old_scene = scene_mgr.GetSceneId();
			scene_mgr.SetCurrentSceneId(rsid);
			scene_mgr.ClearAllVo();
			if (rsid != old_scene) {
				g_event.Fire(Scene_Event_Type.OPEN_SCENE_LOAD_VIEW);
				// scene.ClearScene()
				scene.ChangeScene(rsid);
				// scene.CreateMainRole()
				g_event.Fire(Scene_Event_Type.SCENE_CHANGED, rsid);
			}
			else {
				if (scene.GetMainRole()) {
					scene.GetMainRole().Revived();
					scene.GetMainRole().LoadInfoFromVo();
				}
				LoadSceneInfoRequest(rsid);
			}
		};
		let LoadSceneInfoRequest = (scene_id?) => {
			scene_id = scene_id || scene_mgr.GetSceneId()
			console.warn("------LoadSceneInfoRequest------", scene_id)
			SendFmtToGame.call(this, 12100, "i", scene_id);
			scene_mgr.has_send_12002 = true;
		};
		let On12087 = () => {
			let scene_id = this.ReadFmt("h");
			let player_num = this.ReadFmt("h");
			BossModel.GetInstance().Fire(BossModel.UPDATE_PLAYER_NUM, scene_id, player_num)
		};
		let On12089 = () => {
			let add_num = this.ReadFmt("h");
			let role_vo: RoleVo;
			for (let i = 0; i < add_num; i++) {
				role_vo = scene_mgr.CreateRoleVo();
				role_vo.ReadFromProtocal();
				if (!scene_mgr.GetRoleVo(role_vo.role_id)) {
					scene_mgr.AddRoleVo(role_vo, true);
				}
			}
			add_num = this.ReadFmt("h");
			for (let i = 0; i < add_num; i++) {
				role_vo = scene_mgr.CreateRoleVo();
				role_vo.plat_name = this.ReadFmt("s"); //平台名(string)
				role_vo.server_unique_id = this.ReadFmt("h");
				role_vo.role_id = this.ReadFmt("l");
				role_vo.sex = this.ReadFmt("c");
				role_vo.career = this.ReadFmt("c");
				role_vo.level = this.ReadFmt("h");
				role_vo.name = this.ReadFmt("s");
				role_vo.vip_flag = this.ReadFmt("c");
				role_vo.guild_id = this.ReadFmt("l");
				role_vo.guild_name = this.ReadFmt("s");
				role_vo.position = this.ReadFmt("c");
				role_vo.position_name = this.ReadFmt("s");
				role_vo.maxHp = this.ReadFmt("l");
				role_vo.hp = role_vo.maxHp;
				role_vo.move_speed = this.ReadFmt("h");
				if (!scene_mgr.GetRoleVo(role_vo.role_id)) {
					role_vo.fashion_model_list = null;
					let role_res_id = Config.PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo[`career${role_vo.career}_default_roleResId`];
					let weapon_id = Config.PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo[`career${role_vo.career}_default_weaponId`];
					if (role_res_id && weapon_id) {
						let level_model_list = [{ part_pos: ModelPartPos.Clothe, level_model_id: role_res_id }, { part_pos: ModelPartPos.Weapon, level_model_id: weapon_id }];
						role_vo.level_model_list = level_model_list;
					}
					role_vo.figure_list = [];
					scene_mgr.AddRoleVo(role_vo, true);
				}
			}
			// g_event.Fire(Scene_Event_Type.UPDATE_ROLE_LIMIT)
		};
		let On12090 = () => {
			let target_type, id, guild_id = this.ReadFmt("cll");
			let vo = null;
			if (target_type == local_SceneBaseType.Monster) {
				vo = scene_mgr.GetMonsterVo(id);
			}
			else if (target_type == local_SceneBaseType.Role || target_type == local_SceneBaseType.Fake_Role) {
				vo = scene_mgr.GetRoleVo(id);
			}
			if (vo) {
				vo.ChangeVar("guild_id", guild_id);
			}
		};
		//boss进入狂暴倒计时
		let On12091 = () => {
			let target_type = this.ReadFmt("c");
			let id = this.ReadFmt("l");
			let kuangbao_left_time = this.ReadFmt("i");
		};
		let On12092 = () => {
			let len1 = this.ReadFmt("h");
			for (let i = 0; i < len1; i++) {
				let ins_id = this.ReadFmt("l");
				let len = this.ReadFmt("h");
				let list = {};
				for (let i = 0; i < len; i++) {
					let vo = {
						iconType: this.ReadFmt("h"),
						buff_effect_id: this.ReadFmt("h"),
						id: this.ReadFmt("i"),
						level: this.ReadFmt("c"),
						diejia: this.ReadFmt("c"),
						integer: this.ReadFmt("I"),
						decimals: this.ReadFmt("I"),
						period: this.ReadFmt("l")
					};
					if (!list[vo.iconType]) {
						list[vo.iconType] = {};
					}
					list[vo.iconType][vo.id] = vo;
				}
				let monster = scene.GetMonster(ins_id);
				if (monster && !Util.IsTableEmpty(list)) {
					monster.SetBuffList(list);
				}
			}
		};
		//所有求助人的信息
		let On12043 = () => {
			let instance_id = this.ReadFmt("i");
			let type_id = this.ReadFmt("i");
			let len = this.ReadFmt("h");
			let list = [];
			for (let i = 0; i < len; i++) {
				let vo = {
					assist_id: this.ReadFmt("l"),
					player_id: this.ReadFmt("l"),
					player_name: this.ReadFmt("s"),
					server_id: this.ReadFmt("h"),
					server_num: this.ReadFmt("h"),
					server_name: this.ReadFmt("s")
				};
				list.push(vo);
			}
			g_event.Fire(Event_Name.UPDATE_ASSIST_DATA, instance_id, list, type_id);
		};
		let On12044 = () => {
			let vo = {
				instance_id: this.ReadFmt("i"),
				type_id: this.ReadFmt("i"),
				assist_id: this.ReadFmt("l"),
				player_id: this.ReadFmt("l"),
				player_name: this.ReadFmt("s"),
				server_id: this.ReadFmt("h"),
				server_num: this.ReadFmt("h"),
				server_name: this.ReadFmt("s")
			};
			g_event.Fire(Event_Name.ADD_ASSIST_DATA, vo);
		};
		let On12045 = () => {
			let vo = {
				instance_id: this.ReadFmt("i"),
				type_id: this.ReadFmt("i"),
				assist_id: this.ReadFmt("l"),
			};
			g_event.Fire(Event_Name.REMOVE_ASSIST_DATA, vo);
		};
		let On12028 = () => {
			let instance_id = this.ReadFmt("i");
			let type_id = this.ReadFmt("i");
			let len = this.ReadFmt("h");
			let list = [];
			for (let i = 0; i < len; i++) {
				let vo = {
					player_id: this.ReadFmt("l"),
					assist_id: this.ReadFmt("l"),
				};
				list.push(vo);
			}
			g_event.Fire(Event_Name.UPDATE_FLAG_DATA, instance_id, list, type_id);
		};
		this.RegisterProtocal(12001, On12001);
		this.RegisterProtocal(12002, On12002);
		this.RegisterProtocal(12003, On12003);
		this.RegisterProtocal(12004, On12004);
		this.RegisterProtocal(12005, On12005);
		this.RegisterProtocal(12006, On12006);
		this.RegisterProtocal(12007, On12007);
		this.RegisterProtocal(12008, On12008);
		this.RegisterProtocal(12009, On12009);
		this.RegisterProtocal(12010, On12010);
		this.RegisterProtocal(12011, On12011);
		this.RegisterProtocal(12012, On12012);
		this.RegisterProtocal(12015, On12015);
		this.RegisterProtocal(12017, On12017);
		this.RegisterProtocal(12018, On12018);
		this.RegisterProtocal(12019, On12019);
		this.RegisterProtocal(12020, On12020);
		this.RegisterProtocal(12022, On12022);
		this.RegisterProtocal(12023, On12023);
		this.RegisterProtocal(12024, On12024);
		this.RegisterProtocal(12025, On12025);
		this.RegisterProtocal(12026, On12026);
		this.RegisterProtocal(12027, On12027);
		this.RegisterProtocal(12028, On12028);
		this.RegisterProtocal(12030, On12030);
		this.RegisterProtocal(12036, On12036);
		this.RegisterProtocal(12043, On12043);
		this.RegisterProtocal(12044, On12044);
		this.RegisterProtocal(12045, On12045);
		this.RegisterProtocal(12072, On12072);
		this.RegisterProtocal(12078, On12078);
		this.RegisterProtocal(12080, On12080); //场景对象非常用属性更改
		this.RegisterProtocal(12082, On12082);
		this.RegisterProtocal(12083, On12083);
		this.RegisterProtocal(12085, On12085);
		this.RegisterProtocal(12087, On12087);
		this.RegisterProtocal(12090, On12090);
		this.RegisterProtocal(12091, On12091);
		this.RegisterProtocal(12092, On12092);
		// this.RegisterProtocal(12089, On12089)
		this.RegisterProtocal(12100, On12100);
		this.RegisterProtocal(12103, On12103);
		this.RegisterProtocal(13200, On13200);
		this.RegisterProtocal(13205, On13205);
		let onRequestClientAutoFightDrop = (type) => {
			SendFmtToGame.call(this, 13205, "c", type);
		};
		this.Bind(Event_Name.REQUEST_CLIENTAUTOFIGHT_DROP_LIST, onRequestClientAutoFightDrop);
		let onRequestSceneInfo = () => {
			LoadSceneInfoRequest();
			// SendFmtToGame.call(this, 12100, "i", scene_mgr.GetSceneId())
		};
		g_event.Bind(Scene_Event_Type.REQUEST_SCENE_INFO, onRequestSceneInfo);
		let moveRequestHandler = (x, y, flag, start_fly_x, start_fly_y) => {
			if (scene.GetMainRole() == null)
				return;
			let rx = scene.GetMainRole().x;
			let ry = scene.GetMainRole().y;
			let math_floor = Math.floor;
			x = x < 0 ? 0 : math_floor(x);
			y = y < 0 ? 0 : math_floor(y);
			rx = rx < 0 ? 0 : math_floor(rx);
			ry = ry < 0 ? 0 : math_floor(ry);
			if (start_fly_x)
				start_fly_x = start_fly_x < 0 ? 0 : math_floor(start_fly_x);
			else
				start_fly_x = 0;
			if (start_fly_y)
				start_fly_y = start_fly_y < 0 ? 0 : math_floor(start_fly_y);
			else
				start_fly_y = 0;
			if (flag)
				flag = flag < 0 ? 0 : math_floor(flag);
			else
				flag = 0;
			let scene_id = scene_mgr.GetSceneId();
			if (scene_id)
				scene_id = scene_id < 0 ? 0 : math_floor(scene_id);
			else
				scene_id = 0;
			SendFmtToGame.call(this, 12001, "ihhchhhh", scene_id, rx, ry, flag, x, y, start_fly_x, start_fly_y);
		};
		g_event.Bind(Scene_Event_Type.MOVEREQUEST, moveRequestHandler);
		let gameStartHandler = () => {
			let vo = mainrole_vo;
			scene_mgr.GameStartClearCache();
			scene.CreateMainRole()
			SkillManager.GetInstance().InitConfig();
			// LoginModel.GetInstance().reconnect_on_game = false;
			this.is_first_handler12002 = true;
			this.request_12005_id = vo.lastSceneId;
			console.warn("============================" + 12005, "iicchh", vo.dun_id, vo.lastSceneId, 0, 0, 0, 0);
			SendFmtToGame.call(this, 12005, "iicchh", vo.dun_id, vo.lastSceneId, 0, 0, 0, 0);
			console.warn("gameStartHandler", vo.role_id, vo.lastSceneId, vo.create_role_time)
			// SendFmtToGame.call(this, 12005, "iicchh", vo.dun_id, 10001, 0, 0, 0, 0);
		};
		g_event.Bind(Event_Name.GAME_START, gameStartHandler);
		let onRequestChangeScene = (scene_id, pos_x, pos_y, send_type, change_scene_call_back?) => {
			pos_x = pos_x || 0;
			pos_y = pos_y || 0;
			send_type = send_type || 0;
			pos_x = pos_x < 0 ? 0 : Math.floor(pos_x);
			pos_y = pos_y < 0 ? 0 : Math.floor(pos_y);
			this.change_scene_call_back = change_scene_call_back;
			SendFmtToGame.call(this, 12005, "iicchh", 0, scene_id, 0, send_type, pos_x, pos_y);
		};
		g_event.Bind(Scene_Event_Type.REQUEST_CHANGE_SCENE, onRequestChangeScene);

		mainrole_vo.Bind(Event_Name.CHANGE_LEVEL, () => {
			if (scene.main_role) {
				if (this.lvup_effect_num >= this.lvup_effect_max) {
					return
				}

				let effect_str = "effect_xemlvup"
				this.lvup_effect_num = this.lvup_effect_num + 1
				ParticleManager.GetInstance().AddTargetEffect(effect_str, Scene.GetInstance().main_role.compress_id, false, null, null, 15, null, false, 1, false, () => {
					SoundManager.GetInstance().PlaySoundEffect("upgrade")
					GlobalTimerQuest.AddDelayQuest(() => {
						this.lvup_effect_num = this.lvup_effect_num - 1
						if (this.lvup_effect_num < 0) {
							this.lvup_effect_num = 0
						}
					}, 1)
				}, null, null, null, EffectResType.Other)
			}
		})

		g_event.Bind(EventName.REQUEST_TO_COLLECT, (monster_ins_id, type_id, flag) => {
			if (flag == 2) {
				if (this.collect_effect) {
					ParticleManager.GetInstance().DelEffect(this.collect_effect)
					this.collect_effect = false
				}
				this.collect_effect = ParticleManager.GetInstance().AddTargetEffect("other_effect_caiji_02", Scene.GetInstance().main_role.compress_id, false, null, null, 15, null, false, 1, false, null, null, null, null, EffectResType.Other)
			}
		})
		let clear_effect = () => {
			if (this.collect_target_effect) {
				ParticleManager.GetInstance().DelEffect(this.collect_target_effect)
				this.collect_target_effect = false
			}
			this.last_target = null
		}
		let collect_effect_func = () => {
			let mainRoleVo = role_mgr.GetMainRoleVo()
			let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
			if (task_vo && task_vo.task_tips_type == TaskTipType.Collect) {
				let target = scene.GetMonsterByTypeId(task_vo.id)
				if (target) {
					// let tempDis = GameMath.GetDistance(mainRoleVo.pos_x, mainRoleVo.pos_y, target.real_pos.x, target.real_pos.y, false)
					// if (tempDis > 250 * 250)
					// 	clear_effect()
					// else {
					let monsterVo = SceneManager.Instance.GetMonsterVo(target.id)
					if (monsterVo && monsterVo.type == MonsterType.TASK_COLLECT && this.last_target != monsterVo.instance_id) {
						clear_effect()
						this.last_target = monsterVo.instance_id
						let compress_id = Scene.GetInstance().CompressObjId(SceneBaseType.Monster, monsterVo.instance_id)
						this.collect_target_effect = ParticleManager.GetInstance().AddTargetEffect("effect_mon_caiji", compress_id, true, null, null, 15, null, false, 1, false, null, null, null, null, EffectResType.Other)
						ParticleManager.GetInstance().SetEffectScale(this.collect_target_effect, 1.3)
					}

				}
			}
			else
				clear_effect()

		}
		SceneManager.GetInstance().BindOne("curr_joystick_dir", collect_effect_func)
		TaskModel.GetInstance().Bind(TaskModel.FIRE_COLLECT_EFFECT, collect_effect_func)
		GlobalEventSystem.Bind(SceneEventType.MONSTER_VO_REMOVE, (ins_id) => {
			if (this.last_target && this.last_target == ins_id) {
				clear_effect()
			}
		})
		// TaskModel.GetInstance().Bind(TaskModel.UPDATE_ALL_TASK_FROM_30000, collect_effect_func)

		let scene_changed_func = () => {
			ChangeStart();
		};
		g_event.Bind(SceneManager.START, scene_changed_func);
		g_event.Bind(Scene_Event_Type.REQUEST_PICK_UP_DROP_LIST, () => {
			SendFmtToGame.call(this, 12018);
		});
		g_event.Bind(Scene_Event_Type.SCENE_PALYER_COUNT, (scene_id) => {
			SendFmtToGame.call(this, 12087, "h", scene_id);
		});
		// local function onSafeAreaChange(state)
		// 	self:SendFmtToGame(12085, "c", state)
		// end
		g_event.Bind(Scene_Event_Type.SAFE_AREA_CHANGE, (state) => {
			SendFmtToGame.call(this, 12085, "c", state);
		});
		g_event.Bind(Scene_Event_Type.REQUEST_MONSTER_BUFF, (ins_id) => {
			if (ins_id) {
				this.WriteBegin(12092);
				this.WriteFMT("h", 1);
				this.WriteFMT("l", ins_id);
				this.SendToGame();
			}
		});
		let ChangeStart = () => {
			let main_role = scene.GetMainRole();
			if (main_role && scene_mgr.curr_joystick_dir) {
				main_role.DoDirectionMove(scene_mgr.curr_joystick_dir);
			}
			if (role_mgr.GetMainRoleVo().is_fighting_state) {
				this.Fire(Event_Name.CHANGE_FIGHTING_STATE, false);
			}
			// 切换场景寻路
			this.scene.FindContinue()
			this.SendFmtToGame(12020)
			if (mainrole_vo.is_start_fight) {
				mainrole_vo.is_start_fight = false;
			}
		};

		//场景寻路
		g_event.Bind(Event_Name.FIND, (findVo?) => {
			//寻路要先切换掉自动挂机状态
			g_event.Fire(Event_Name.STOPAUTOFIGHT, false, true)
			scene.FindElement(findVo)
		})

		let deal_with_drop_list_vo = (vo) => {
			this.DealWithDropListVo(vo)
		}
		GlobalEventSystem.Bind(SceneEventType.DEAL_WITH_SCENE_DROP_LIST_VO, deal_with_drop_list_vo)

		g_event.Bind(SceneEventType.SCENE_CHANGED, (scene_id) => {
			setTimeout(() => {
				scene.StartTalk()
			}, 1.5)
		})

		this.DealWithDropListVo = (vo) => {
			//处理掉在障碍区的坐标
			let logic_x
			let logic_y
			let pos
			let check_do_drop_effect = false
			let monster_pos
			for (let k in vo.drop_list) {
				var v = vo.drop_list[k]
				if (!v.is_fake) {
					logic_x = v.pos_x / SceneObj.GetLogicRealRatio().x
					logic_y = v.pos_y / SceneObj.GetLogicRealRatio().y
					if (SceneManager.GetInstance().IsBlockXY(logic_x, logic_y)) {
						pos = SourceOperateMove.FindNoBlockPos(new Vector2(logic_x, logic_y))
						v.pos_x = pos.x * SceneObj.GetLogicRealRatio().x
						v.pos_y = pos.y * SceneObj.GetLogicRealRatio().y
					}
				}
				// 宝箱
				if (v.show_type == 0) {
					check_do_drop_effect = true
					monster_pos = new Vector2(v.mon_pos_x, v.mon_pos_y)
				}
			}

			if (check_do_drop_effect) {
				GlobalEventSystem.Fire(SceneEventType.DO_SCENE_DROP_EFFECT, monster_pos)
			}

			let copy_vo = {
				map_id: vo.map_id,
				drop_list: []
			}

			let len = vo.drop_list.length
			let role_id = role_mgr.GetMainRoleId()
			let index = 0

			let time_obj = {}

			let delay_fun = () => {
				onUpdate()
			}


			let onUpdate = () => {
				if (index < len) {
					let tb = Util.DeepCopy(copy_vo)
					let drop_vo = vo.drop_list[index]

					//掉落筛选
					let bool = true

					//掉落类型是 1 不掉落流程
					if (drop_vo.show_type == 1) {
						bool = false
					}

					if (bool) {
						if (drop_vo.show_type == 2 && drop_vo.role_id != role_id) {
							bool = false
						}
					}

					if (bool) {

						//和服务端约定 分配类型等于7的情况下 role_id 一定是有值的 如果不想等则不显示
						if (drop_vo.assign_type == 7 && drop_vo.role_id != role_id) {
							bool = false
						}
					}

					if (bool) {
						table.insert(tb.drop_list, vo.drop_list[index])
						GlobalEventSystem.Fire(SceneEventType.BROADCAST_SCENE_DROP_LIST, tb)
					}
					index++
				}
				else {
					scene.can_check_index_list = true
					Laya.timer.clear(time_obj, delay_fun)
				}
			}
			Laya.timer.frameLoop(5, time_obj, delay_fun)
			// GlobalTimerQuest.AddPeriodQuest(delay_fun, 0.01, len)
		}
	};
}

window["SceneController"] = SceneController