import { HashEventDispatcher } from "../common/HashEventDispatcher";
import { SceneManager } from "./SceneManager";
import { SceneBaseType, MOVE_TYPE, MonsterType, EffectResType, AreaDataIndex } from "./SceneConfig";
import { MainRole } from "./sceneobj/MainRole";
import { Vector2 } from "../util/Vector2";
import { SceneObj } from "./sceneobj/SceneObj";
import { ObjPool, ObjMaxCache } from "./ObjPool";
import { GlobalEventSystem, LOAD_QUEUE, LogicRealRatio_X, LogicRealRatio_Y, LogicRealRatio_Z } from "../util/DeclareGlobalVar";
import { SceneEventType, EventName, ObjectEventType } from "../common/EventName";
import { SkillManager } from "../skill/SkillManager";
import { RoleManager } from "../commonModel/RoleManager";
import { MapManager } from "./MapManager";
import { ParticleManager } from "../particalEffect/ParticleManager";
import { CameraManager } from "./CameraManager";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { Config } from "../common/Config";
import { AutoFightManager } from "../autofight/AutoFightManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { PoseState } from "../util/StateMachineManager";
import { Role } from "./sceneobj/Role";
import { Monster } from "./sceneobj/Monster";
import { Partner } from "./sceneobj/Partner";
import { Demon } from "./sceneobj/Demon";
import { Shengqi } from "./sceneobj/Shengqi";
import { Sprite } from "./sceneobj/Sprite";
import { Drop } from "./sceneobj/Drop"
import { FightEvent } from "./fight/FightEvent";
import { GameMath } from "../util/GameMath";
import { OperateManager } from "../operation/OperateManager";
import { Status } from "../util/Status";
import { Util, DEVICE_OS, GlobalTimerQuest, ResetTransform, Set3DLocalPosition, Set3DLocalRotationEuler, Set3DLocalScale } from "../util/Util";
import { SoundManager } from "../common/SoundManager";
import { Message } from "../sysInfo/SysInfoController";
import { ResManager } from "../common/ResManager";
import { FightFontManager } from "./fight/FightFontManager";
import { SpriteVo } from "../sharedata/SpriteVo";
import { ShengqiVo } from "../sharedata/ShengqiVo";
import { PartnerVo } from "../sharedata/PartnerVo";
import { DemonVo } from "../sharedata/DemonVo";
import { Runner } from "../util/Runner";
import { FRAME_TYPE } from "../util/DeclareGlobalVar";
import { Character } from "./sceneobj/Character";
import { Npc } from "./sceneobj/Npc";
import { FindVo } from "./sceneobj/FindVo";
import { SettingModel } from "../commonModel/SettingModel";
import { PartnerModel } from "../commonModel/PartnerModel";
import { DropManager } from "./DropManager";
import { table } from "../common/table";
import { NoonPartyModel } from "../commonModel/NoonPartyModel";
import { BanquetModel } from "../commonModel/BanquetModel";// TypeScript file
import { SourceOperateMove } from "../operation/SourceOperateMove";
import { SapManager } from "./SapManager";
import { EarlyWarningManager } from "./fight/EarlyWarningManager";
import { GameResPath } from "../util/GameResPath";
import { ViewManager } from "../common/ViewManager";
import { JumpPoint } from "./sceneobj/JumpPoint";
import { Door } from "./sceneobj/Door";
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel";
import { BossSceneManager } from "../commonController/BossSceneManager";
import { Mathf } from "../util/Mathf";
import { ErlangParser } from "../util/ErlangParser";
import { enum_OutWardType, OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { SkillUIModel } from "../commonModel/SkillUIModel";
import { Grave } from "./sceneobj/Grave";
import { BossModel } from "../commonModel/BossModel";

let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Util = Util
let local_Status = Status
export class Scene extends HashEventDispatcher {
	static TestMode = false

	static FIND_TARGET_TYPE = {
		monster: 1,
		role: 2,
		partner: 3,
		all: 100,
		all_role_first: 101,
		all_monster_first: 101 //优先选怪
	};
	static ServerAreaIndex = {
		"0": AreaDataIndex.WalkType,
		"1": AreaDataIndex.BlockType,
		"5": AreaDataIndex.SafeType
	};
	static Instance: Scene;
	main_role: MainRole;
	scene_data_loaded: Boolean = false;
	preload_res_is_loaded;
	scene_res_loaded;
	is_clearing;
	last_clear_scene_time = 0;//上一次清理场景的时间
	is_first_clearing = true;
	_last_camera_pos: Vector2 = new Vector2(0, 0);
	private _goToPos: Vector2;
	goToFunc;
	is_hide_all_mon;
	change_scene_request_time;
	preload_sceneObjRes_is_loading;
	scene_change_start_time;
	curr_click_target: SceneObj;
	sceneObj_list_for_depth_sort: Array<any> = [];
	// particle_mgr =  ParticleManager.GetInstance()
	role_list = {}; //玩家列表 包括主角
	monster_list: { [key: string]: Monster } = {}; //怪物列表
	other_list = {}; //其他对象列表
	drop_list = {}; //掉落
	npc_list = {}; //Npc列表
	door_list = {}; //door列表
	sprite_list = {}; //小精灵列表
	demon_list = {}; //使魔列表
	shengqi_list = {}; //神器列表
	partner_list = {}; //伙伴列表
	grave_list: { [key: string]: Grave } = {};//墓碑列表
	moving_obj_list = []; //当前场景正在移动的对象
	monster_pool = new ObjPool(ObjMaxCache.Monster);
	other_pool = new ObjPool(ObjMaxCache.Other);
	drop_pool = new ObjPool(ObjMaxCache.Drop);
	role_pool = new ObjPool(ObjMaxCache.OtherRole);
	npc_pool = new ObjPool(ObjMaxCache.NPC);
	sprite_pool = new ObjPool(ObjMaxCache.Sprite);
	shengqi_pool = new ObjPool(ObjMaxCache.Shengqi);
	demon_pool = new ObjPool(ObjMaxCache.Demon);
	partner_pool = new ObjPool(ObjMaxCache.Partner);
	door_pool = new ObjPool(ObjMaxCache.Door);
	grave_pool = new ObjPool(ObjMaxCache.Grave);
	//延时处理的函数列表(用于处理延时删除等逻辑)
	delay_handle_funcs = [];
	//怪物尸体列表
	monster_dead_body_list = {};
	dead_body_count = 0;
	//场景是否正在执行update的方法
	is_in_update = false;
	force_update_in_next_frame = false;//下一帧是否强制更新
	//场景更新步频
	update_scene_times_index = 0;
	//场景更新消耗时间
	update_elapse_time = 0.0;
	last_dir_move_time = 0;
	last_attack_time = 0; //上次自动攻击的时间
	last_find_target_time = 0; //上次自动寻怪的时间
	auto_find_and_attack_interval = 0.4; //最小寻怪和攻击间隔
	// load_prefab_temp_target = {}
	touch_bengin_y = 0;
	//是否允许点击屏幕
	enable_click_screen = true;
	check_visible_role_num_time;
	update_role_name = false;
	update_monster_name = false;
	update_partner_name = false;
	find_vo_cache = false;
	mainrole_kill_count = 0;
	find_target_dir: Vector2;
	role_move_end_pos: Vector2;
	monster_move_end_pos: Vector2;
	other_move_end_pos: Vector2;
	npc_move_end_pos: Vector2;
	attack_target_start_real_pos: Vector2;
	attack_target_end_real_pos: Vector2;
	scene_effect_list: Array<any>;
	scene_effect_id_list = {};
	touch_count = 0;
	last_check_framerate_time;
	not_check_framerate = false;
	showing_frameraet_alert;
	repeat_times = 0;
	rush_to_start_real_pos: Vector2 = new Vector2();
	rush_to_end_real_pos: Vector2 = new Vector2();
	rush_to_end_real_pos_temp: Vector2 = new Vector2();
	rush_to_end_dir: Vector2 = new Vector2();
	/**传送门检测冷却时间*/
	door_cold_time;
	monster_deap_exp_effect_id_list = [];
	manual_target: SceneObj;
	click_target_effect: Laya.Sprite3D;		//选中目标特效对象
	has_task_target
	timer
	find_isAgain
	delay_timer_id
	user_manul_time = 0
	drop_pos_list = {}
	jump_point_dic = {}
	drag_to_move_start_time
	hold_touch_time
	/**掉落拾取索引列表 */
	drop_index_list
	/** */
	can_check_index_list = false
	AddMonsterDeadExpEffect;
	ShowMonsterDeadExpEffect;
	HasMonsterDeadExp;
	PointQuery;
	SetClickTarget;
	GetClickTarget;
	CancelClickTarget;
	CreateClickTargetEffect
	InitEvents;
	GetMainRole;
	DeleteMainRole;
	CreateMainRole;
	ResetMainRoleInfo;
	/**
	 * 角色移动
	 * @param end_pos 结束位置
	 * @param range 范围
	 * @param end_function 移动结束回调
	 * @param is_fire_evt 移动结束后是否发出事件
	 */
	MainRoleMove: (end_pos: { x: number, y: number }, range?: number, end_function?: () => any, is_fire_evt?: boolean, force_move?: boolean, save_end_pos?: boolean, update_function?: () => any) => void;
	clearGoToData;
	AddMovingObj;
	RemoveMovingObj;
	Update;
	UpdateRole;
	UpdateMonster;
	UpdateAutoFight;
	MainRoleAttackTarget;
	MainRoleRushToMonster;
	MainRoleAttackMonster;
	MainRoleAttackRole;
	IsSceneLoaded;
	IsSceneProloadFinish;
	SceneResLoadCompleted;
	SceneDataLoadCompleted;
	PreLoadSceneObjResCompleted;
	CheckToPreLoad;
	PreLoadSceneObjRes;
	ClearSceneEffect;
	LoadSceneEffect;
	ChangeScene;
	DetectFirstUnblockPoint;
	FindWay;
	IsStraightLine;
	DetectLastUnblockPoint;
	GetMapResID;
	SetMainRole;
	CompressObjId;
	DecompressObjId;
	ClearScene;
	GetObjByCompressedId;
	GetDoor;
	GetDrop;
	GetNpc;
	GetMonster;
	GetMonsterByTypeId;
	GetSprite;
	GetDemon;
	GetShengqi;
	GetPartner;
	GetOther;
	GetSceneObj;
	GetMonsterList;
	GetRole;
	RoleMove;
	MonsterMove;
	OtherMove;
	NpcMove;
	CreateRole;
	CreateNpc;
	CreateMonster;
	CreateOther;
	CreateDrop;
	CreateSprite;
	DeleteSprite;
	CreateShengqi;
	DeleteShengqi;
	CreatePartner;
	DeletePartner;
	CreateDemon;
	DeleteDemon;
	DeleteRole;
	GetMonsterDeadBody;
	DeleteMonster;
	DeleteOther;
	DeleteDrop;
	DeleteDeadBody;
	DeleteDoor;
	DeleteJumpPoint;
	DeleteNpc;
	CreateDoor;
	CreateJumpPoint;
	UpdateAllMonsterVisible;
	GetExitByPoint;
	RoleWalkCompleteHandler;
	UpdateRoleVisibleState;
	FindTargetDir;
	FindTargets;
	FindMonsters;
	FindRoles;
	ShouldShowFrameRateAlert;
	RoleOtherProChange;
	FindNearestMonsters;
	UpdateSceneEffect;
	GetNearestMonsterByTypeId
	ClearLastAttack
	last_ranAttackObj
	GetSceneSize;
	SetDynamicArea;
	lastMonsterMoveInsId;
	lastMonsterMoveX;
	lastMonsterMoveY;
	MainRoleToNpc
	MainRoleMoveAndCancel
	ChcekCanMove
	FindElement
	CancelWaitQuest
	ClearFindNextScene
	CanSelectMonster
	FindContinue
	UpdateAutoClickTarget
	SetEnterSceneFlag
	PartnerUpdateFight

	RefreshDropList
	IsPicking
	OnPick
	FindDropItem
	AutoPick
	CheckPick
	GetRandomMonsterByTypeId
	FindNearestTarget
	CheckJumpPoint
	CheckDoorInSameScene
	GetZoneHeight
	MainRoleDoCollect
	MainRoleQuitCollect
	InitSAPFunction
	CheckCanCreateDoor
	ClearMainRoleFindWayState
	SetDropIndexList
	DelDropIndexList

	need_change_move_speed
	pick_drop_distance = 500
	now_drop_obj
	last_drop_obj
	CheckSeahegeScene
	talk_time_spc //= 8
	talk_time_id


	public static GetInstance() {
		if (!Scene.Instance) {
			Scene.Instance = new Scene();
			Scene.Instance.main_role = new MainRole();
		}
		return Scene.Instance;
	}
	public constructor() {
		super();
		Partner.__Init__()
		Demon.__Init__()
		Sprite.__Init__()
		Shengqi.__Init__()
		this.InitSceneFunction()
	}
	public set goToPos(pos) {
		this._goToPos = pos;
		GlobalEventSystem.Fire(SceneEventType.CHANGE_FIND_WAY_STATE, pos);
	}
	public get goToPos() {
		return this._goToPos;
	}
	public InitSceneFunction = () => {
		let scene_mgr = SceneManager.GetInstance(),
			skill_mgr = SkillManager.GetInstance(),
			role_mgr = RoleManager.GetInstance(),
			mainrole_vo = role_mgr.mainRoleInfo,
			mapView = MapManager.GetInstance(),
			particle_mgr = ParticleManager.GetInstance(),
			main_camera = CameraManager.GetInstance(),
			layer_mgr = LayerManager.GetInstance(),
			auto_fight_mgr = AutoFightManager.GetInstance(),
			local_Vector2 = Vector2,
			Global_Event_System = GlobalEventSystem,

			Event_Name = EventName,
			local_Math = Math,
			auto_mgr = AutoFightManager.GetInstance(),
			user_mgr = UserMsgAdapter.GetInstance(),
			local_PoseState = PoseState,
			attack_type_role = Scene.FIND_TARGET_TYPE.role,
			attack_type_all = Scene.FIND_TARGET_TYPE.all,
			attack_type_monster = Scene.FIND_TARGET_TYPE.monster,
			local_ViewManager = ViewManager,
			local_SceneObj = SceneObj,
			local_Role = Role,
			local_Monster = Monster,
			local_Partner = Partner,
			local_Sprite = Sprite,
			local_Drop = Drop,
			local_FightEvent = FightEvent,
			local_GameMath = GameMath,
			oper_mgr = OperateManager.GetInstance(),
			scene_base_type = SceneBaseType,
			local_SceneEventType = SceneEventType,
			local_ObjectEventType = ObjectEventType,
			load_progress_finished = false, //是否加载进度条加载完成
			target_auto_fight_cfg,
			is_pick_handled,
			last_multi_jump_time,
			check_jump_point_time,
			has_same_scene_door,
			local_MonsterType = MonsterType,
			local_Laya = Laya,
			local_SapManager = SapManager

		this.InitEvents = () => {
			// let is_pause = false
			let touch_layer: Laya.Sprite = layer_mgr.GetUILayer(Enum_UILayer.UIRoot);
			// top_layer["touchThrough"] = true
			let touch_move_flag = false //点击移动一定距离生效
			let canMove = function () {
				if (role_mgr.GetMainRoleDepositState()) {
					Message.show("自动战斗中")
					return false
				}
				if (scene_mgr.IsArenaFightScene()) return false
				if (this.main_role.IsInState(local_PoseState.RUSH)) {
					return false
				}
				return true
			}
			let sceneTouchBeginEvent = (e: Laya.Event) => {
				// console.log("SceneTouch", e.stageX, e.stageY, e.target ,touch_layer, this.IsSceneLoaded(),scene_mgr.IsArenaFightScene())

				if (e.target != touch_layer) {
					//Global_Event_System.Fire(Event_Name.SHOW_EFFECT, Enum_UILayer.ClickEffect, "ui_click_1", { x: e.stageX, y: e.stageY }, 1.1, 10)
					Global_Event_System.Fire(Event_Name.CLICK_EFFECT, e);
					return;
				}
				if (!this.IsSceneLoaded()) return

				if (!canMove.call(this)) return
				scene_mgr.curr_click_start_pos.x = e.stageX;
				scene_mgr.curr_click_start_pos.y = e.stageY;
				oper_mgr.StopMove();
				this.clearGoToData();
				touch_move_flag = false
				if (local_Util.TableSize(touch_move_list) <= 0) {
					// console.log("sceneTouchMoveEvent1111")
					let x = main_camera.WorldToViewPortX(this.main_role.real_pos.x);
					let y = main_camera.WorldToViewPortY(this.main_role.real_pos.y) - this.main_role.GetBodyHeight() * 0.5;
					// console.log("WorldToViewPortX ", e.stageX, e.stageY, x, y + this.main_role.GetBodyHeight() * 0.5)
					if (!scene_mgr.curr_joystick_dir) {
						scene_mgr.curr_joystick_dir = new local_Vector2();
					}
					scene_mgr.curr_joystick_dir.x = scene_mgr.curr_click_start_pos.x - x;
					scene_mgr.curr_joystick_dir.y = scene_mgr.curr_click_start_pos.y - y;
					scene_mgr.curr_joystick_dir.normalise();
					scene_mgr.curr_click_move_dist = 0;
					sceneTouchMoveEvent(e, true);
				}
				touch_layer.on(local_Laya.Event.MOUSE_MOVE, this, sceneTouchMoveEvent);
				touch_layer.on(local_Laya.Event.MOUSE_UP, this, sceneTouchEndEvent);
			};
			touch_layer.on(local_Laya.Event.MOUSE_DOWN, this, sceneTouchBeginEvent);
			let touch_move_list = {};
			let curr_control_id;
			let last_move_time = 0;
			let sceneTouchMoveEvent = (e: Laya.Event, not_reset_dir = false) => {
				// Message.show("TOUCH_MOVE "+e.touchId)
				// console.log("sceneTouchMoveEvent2222222222222",scene_mgr.curr_click_start_pos,not_reset_dir)
				e.stopPropagation();

				if (scene_mgr.curr_click_start_pos.x == 0 && scene_mgr.curr_click_start_pos.y == 0)
					return;

				let x = e.stageX;
				let y = e.stageY;
				if (GameMath.GetDistance(scene_mgr.curr_click_start_pos.x, scene_mgr.curr_click_start_pos.y, x, y) > 0) {
					touch_move_flag = true
				}
				let curr_touch_id = e.touchId;
				if (curr_control_id != curr_touch_id && touch_move_list[curr_touch_id]) //旧手指重复move 无效
				{
					touch_move_list[curr_touch_id][0] = x;
					touch_move_list[curr_touch_id][1] = y;
					return;
				}
				if (!scene_mgr.curr_joystick_dir) {
					scene_mgr.curr_joystick_dir = new local_Vector2();
				}
				let curr_time = local_Laya.timer.currTimer;
				if (!not_reset_dir) {
					if (curr_time - last_move_time < 30)
						return;
					scene_mgr.curr_joystick_dir.x = x - scene_mgr.curr_click_start_pos.x;
					scene_mgr.curr_joystick_dir.y = y - scene_mgr.curr_click_start_pos.y;
					scene_mgr.curr_click_move_dist = scene_mgr.curr_joystick_dir.normalise();
				}
				if (!this.hold_touch_time) {
					this.hold_touch_time = curr_time * 0.001
				}
				last_move_time = curr_time;
				if (!touch_move_list[curr_touch_id]) {
					if (local_Util.TableSize(touch_move_list) > 0) {
						scene_mgr.curr_click_start_pos.x = x;
						scene_mgr.curr_click_start_pos.y = y;
						scene_mgr.curr_click_move_dist = 0;
					}
					touch_move_list[curr_touch_id] = [x, y];
					curr_control_id = curr_touch_id;
				}
				scene_mgr.ChangeVar("curr_joystick_dir", scene_mgr.curr_joystick_dir, null, true);
				if (scene_mgr.curr_click_move_pos.x != x || scene_mgr.curr_click_move_pos.y != y) {
					scene_mgr.curr_click_move_pos.x = x;
					scene_mgr.curr_click_move_pos.y = y;
					scene_mgr.ChangeVar("curr_click_move_pos", scene_mgr.curr_click_move_pos, null, true);
				}
				// console.log("sceneTouchMoveEvent1111222555555555", scene_mgr.curr_joystick_dir)
				this.main_role.DoDirectionMove(scene_mgr.curr_joystick_dir, false, true);

				if (!auto_fight_mgr.GetTempMode() && this.drag_to_move_start_time && local_Status.NowTime - this.drag_to_move_start_time > 1.5) {
					auto_fight_mgr.SetTempMode(true)
				}

			};
			let sceneTouchEndEvent = (e: Laya.Event) => {
				// Message.show("TOUCH_END "+e.touchId)
				// console.log("sceneTouchEndEvent")
				let obj = touch_move_list[e.touchId];
				if (obj) {
					delete touch_move_list[e.touchId];
					let len = local_Util.TableSize(touch_move_list);
					if (len > 0) {
						if (curr_control_id == e.touchId) {
							for (let id in touch_move_list) {
								curr_control_id = id;
								obj = touch_move_list[curr_control_id];
								scene_mgr.curr_click_start_pos.x = obj[0];
								scene_mgr.curr_click_start_pos.y = obj[1];
								scene_mgr.curr_click_move_dist = 0;
								e.type = local_Laya.Event.DRAG_MOVE
								e.touchId = curr_control_id
								sceneTouchMoveEvent(e, true);
								break;
							}
						}
					}
					else {
						is_pick_handled = true
						if (!touch_move_flag) {
							if (!canMove.call(this)) return
							scene_mgr.curr_click_start_pos.x = e.stageX;
							scene_mgr.curr_click_start_pos.y = e.stageY;
							let x = main_camera.ViewPortXToWorld(e.stageX);
							let y = main_camera.ViewPortYToWorld(e.stageY);
							// console.log("ViewPortXToWorld ", e.stageX, e.stageY, x, y)
							oper_mgr.StopMove();
							this.clearGoToData();
							Global_Event_System.Fire(local_SceneEventType.CLICK_SCENE_STOP_MOVE);

							let query_list = this.PointQuery(x, y, scene_base_type.All);
							let clickTarget = query_list[0];
							if (clickTarget) {
								if (clickTarget.GetType() == scene_base_type.Monster) {
									if (
										clickTarget.GetVo().type == local_MonsterType.COLLECT
										|| clickTarget.GetVo().type == local_MonsterType.TASK_COLLECT
										|| clickTarget.GetVo().type == local_MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT
										|| clickTarget.GetVo().type == local_MonsterType.NOT_DEAD_COLLECT
										|| clickTarget.GetVo().type == local_MonsterType.PICK
									) {

										if (this.main_role.vo.brick_id > 0) {
											return;
										}

										if (scene_mgr.IsHolyBattleFightScene())
											return

										is_pick_handled = false
										this.MainRoleAttackMonster(clickTarget)
									} else if (!this.CanSelectMonster(true)) {
										return
									} else {
										is_pick_handled = false
									}
									this.manual_target = clickTarget
									Global_Event_System.Fire(Event_Name.ATTACK_CLICK_MON, clickTarget)
								} else if (clickTarget.GetType() == scene_base_type.Role) {
									is_pick_handled = false
								} else if (clickTarget.GetType() == scene_base_type.Npc) {
									this.MainRoleToNpc(clickTarget.id, false)
									this.manual_target = clickTarget
									is_pick_handled = false;
								}

								this.SetClickTarget(clickTarget)

								if (clickTarget.GetType() == scene_base_type.Monster && clickTarget.GetVo().type == local_MonsterType.NORMAL && scene_mgr.IsCanAttackByMainRole(clickTarget.GetVo(), true)) {
									Global_Event_System.Fire(Event_Name.STARTAUTOFIGHT, false, true)
								}
								this.user_manul_time = 0
							}
						}
						touch_move_flag = false
						if (this.main_role.RideHorseCond()) {
							if (!OutWardBaseModel.GetInstance().auto_horse && this.hold_touch_time && local_Status.NowTime - this.hold_touch_time < 0.3) {
								if (scene_mgr.curr_click_move_pos.y < scene_mgr.curr_click_start_pos.y && !this.main_role.IsOnHorse()) {
									OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.CHANGE_HORSE_STATE, enum_OutWardType.Horse, 1)
								}
								else if (scene_mgr.curr_click_move_pos.y > scene_mgr.curr_click_start_pos.y && this.main_role.IsOnHorse()) {
									OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.CHANGE_HORSE_STATE, enum_OutWardType.Horse, 0)
								}
							}
						}
						if (is_pick_handled) {
							this.manual_target = null
							this.SetClickTarget(null)
							is_pick_handled = false
						}

						touch_layer.off(local_Laya.Event.MOUSE_MOVE, this, sceneTouchMoveEvent);
						touch_layer.off(local_Laya.Event.MOUSE_UP, this, sceneTouchEndEvent);
						// touch_layer.off(local_Laya.Event.TOUCH_RELEASE_OUTSIDE, sceneTouchEndEvent, this);
						// touch_layer.off(local_Laya.Event.TOUCH_CANCEL, sceneTouchEndEvent, this);
						curr_control_id = null;
						scene_mgr.curr_click_start_pos.x = scene_mgr.curr_click_start_pos.y = 0;
						scene_mgr.curr_click_move_pos.x = scene_mgr.curr_click_move_pos.y = 0;
						scene_mgr.ChangeVar("curr_joystick_dir", null, null, true);
						if (this.main_role.IsInState(local_PoseState.MOVE)) {
							this.main_role.DoStand();
						}
						this.drag_to_move_start_time = false
						this.hold_touch_time = false
					}
				}
			};

			//创建掉落列表
			let onRefreshDropList = (vo) => {
				let sid = scene_mgr.GetSceneId()
				if (vo && vo.map_id == sid) {
					//egret.log("_________________onRefreshDropList", String(vo))
					let drop_list = vo.drop_list
					if (drop_list) {
						let len = drop_list.length
						if (len > 0) {
							let vo
							for (let i = 0; i < len; i++) {
								scene_mgr.AddDropVo(drop_list[i], true)
								// vo = drop_list[i]
								// Global_Event_System.Fire(local_SceneEventType.DROP_VO_ADD, vo.drop_id, vo)
							}
						}
					}
				}
			}
			Global_Event_System.Bind(local_SceneEventType.BROADCAST_SCENE_DROP_LIST, onRefreshDropList)

			let roleAdd = (role_id, role_vo) => {
				this.CreateRole(role_vo);
			};
			let roleDel = (role_id) => {
				this.DeleteRole(role_id);
			};
			let monsterAdd = (ins_id, monster_vo) => {
				this.CreateMonster(monster_vo);
			};
			let monsterDel = (ins_id) => {
				this.DeleteMonster(ins_id);
			};
			let otherAdd = (ins_id, other_vo) => {
				this.CreateOther(other_vo);
			};
			let dropAdd = (ins_id, drop_vo) => {
				this.CreateDrop(drop_vo);
			};
			let otherDel = (ins_id) => {
				this.DeleteOther(ins_id);
			};
			let dropDel = (ins_id) => {
				this.DeleteDrop(ins_id);
			};
			let door_add = (door_id, vo) => {
				this.CreateDoor(vo);
			};
			let npc_add = (ins_id, vo) => {
				this.CreateNpc(vo);
			};
			let delete_npc = (id) => {
				this.DeleteNpc(id);
			};
			let delete_door = (id) => {
				this.DeleteDoor(id);
			};
			let grave_add = (grave_vo) => {
				this.CreateGrave(grave_vo)
			}
			let grave_del = (ins_id) => {
				this.DeleteGrave(ins_id)
			}
			let sceneLoad = (hide_load_progress) => {
				this.CancelWaitQuest() //切场景前关掉定时器
				//没有进度条暂时屏蔽
				// this.OpenSceneLoadView(hide_load_progress)
			}

			let jumppoint_add = (vo) => {
				this.CreateJumpPoint(vo)
			}

			let delete_jumppoint = (id) => {
				this.DeleteJumpPoint(id)
			}

			let reset_fun = (logic_x, logic_y, is_dir_move) => {
				if (AutoFightManager.GetInstance().go_to_pos && AutoFightManager.GetInstance().GetAutoFightState()) {
					AutoFightManager.GetInstance().CacheGoToPos()
				}

				// if (!this.CheckJumpPoint(null, logic_x, logic_y)) {
				// 	if (is_dir_move) {
				// 		OperateManager.GetInstance().StopMove()
				// 	}
				// }
			}


			//delay_jump_type 1 攻击后传送  2 攻击后跳跃
			let main_role_jump = (delay_jump_type) => {
				// MainCamera.Instance.ChangeSmoothState(MainCamera.SmoothState.Jump)
				let main_role = Scene.Instance.GetMainRole()
				if (main_role.is_shoe_flying) { return }
				let distance = null
				let jump_type = null
				if (main_role.IsFighting()) {   //如果在战斗过程中，就切换成闪避跳跃
					jump_type = Role.MULTI_JUMP_TYPE.Jump_3
				} else {
					jump_type = main_role.curr_multi_jump_type || 1
				}
				distance = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_move_distance[jump_type]
				let dir = skill_mgr.joy_stick_dir || main_role.direction
				let dist = distance
				let end_pos = new local_Vector2(main_role.real_pos.x + dir.x * dist, main_role.real_pos.y + dir.y * dist)


				/*
				1.根据配置，通过跳跃距离和方向，计算出一个初始跳跃点 point_1
				2.检测这个跳跃是否是障碍点，如果不行，找到里这个点最近的跳跃点 point_2
				3.根据检测后的 point_2 读取配置参数，计算起跳上升时间和下降时间，求和得出总时间。用垂直总时间矫正水平移动的时间，再次计算水平移动的距离，计算出，3D模式下的最终落点point_3
				4.检测point_3是否是障碍点，如果是，矫正位置后传入DoJump()
				5.用得出的参数进行跳跃动画计算
				6.如果跳跃结束点高度过高，大于跳跃中最高的高度，就不让他跳过去

				需要做多次障碍的原因是障碍区的高度值为0，会影响到跳跃动画的计算
				*/

				//要先计算一次目标点是否可以跳过去
				if (scene_mgr.CannotJumpCrossBlockScene()) {
					let [x, y] = SourceOperateMove.FindNearestPos(new local_Vector2(main_role.real_pos.x, main_role.real_pos.y), end_pos, false)
					end_pos = new local_Vector2(x, y)
				} else if (scene_mgr.IsBlockXY(end_pos.x / local_SceneObj.GetLogicRealRatio().x, end_pos.y / local_SceneObj.GetLogicRealRatio().y)) {
					let [x, y] = SourceOperateMove.FindNearestPos(new local_Vector2(main_role.real_pos.x, main_role.real_pos.y), end_pos, false)
					end_pos = new local_Vector2(x, y)
				}

				if (jump_type == Role.MULTI_JUMP_TYPE.Jump_1) {
					end_pos = main_role.GetJumpEndPos(end_pos, jump_type)
				}
				let lx = end_pos.x / local_SceneObj.GetLogicRealRatio().x
				let ly = end_pos.y / local_SceneObj.GetLogicRealRatio().y
				if (jump_type == Role.MULTI_JUMP_TYPE.Jump_3) { // 如果是战斗翻滚，就要找到和落点间最近的一个可行走区域，因为他不能越过去
					let [x, y] = SourceOperateMove.FindNearestPos(new local_Vector2(main_role.real_pos.x, main_role.real_pos.y), end_pos, false)
					end_pos = new local_Vector2(x, y)
				} else {
					if (scene_mgr.CannotJumpCrossBlockScene()) {
						let [x, y] = SourceOperateMove.FindNearestPos(new local_Vector2(main_role.real_pos.x, main_role.real_pos.y), end_pos, false)
						end_pos = new local_Vector2(x, y)
					} else {
						if (scene_mgr.IsBlockXY(lx, ly)) {
							let data = SourceOperateMove.FindFastestPos(new local_Vector2(main_role.real_pos.x, main_role.real_pos.y), end_pos)
							let fastPos = new local_Vector2(data.x, data.y)

							if (scene_mgr.IsBlockXY(fastPos.x / local_SceneObj.GetLogicRealRatio().x, fastPos.y / local_SceneObj.GetLogicRealRatio().y)) {
								end_pos = SourceOperateMove.FindNoBlockPos(main_role.logic_pos)  //如果跳跃的位置是不可行走区域，就找到最近的一个可行走点，跳过去
								end_pos.x = end_pos.x * local_SceneObj.GetLogicRealRatio().x
								end_pos.y = end_pos.y * local_SceneObj.GetLogicRealRatio().y
							} else {
								end_pos = fastPos
							}
						}
					}
				}
				main_role.DoJump(end_pos, null, null, null, null, jump_type, false, false, false, false, false, false, delay_jump_type)
				skill_mgr.joy_stick_dir = null
			}

			let main_role_jump_end = (force_check, logic_x, logic_y) => {
				this.CheckJumpPoint(force_check, logic_x, logic_y)
			}

			let main_role_jump_end_imm = (vo) => {
				if (AutoFightManager.GetInstance().GetAutoFightState()) {
					this.UpdateAutoFight(true)
				}
			}

			let main_role_move_end = (vo) => {
				if (!check_jump_point_time) {
					this.CheckJumpPoint()
					check_jump_point_time = local_Status.NowTime
				} else {
					if (local_Status.NowTime - check_jump_point_time > Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.check_jump_point_space) {
						this.CheckJumpPoint()
						check_jump_point_time = local_Status.NowTime

						// if (scene_mgr.IsSeaHegemonyScene()) {
						// 	this.CheckDoorInSameScene(true, 4)
						// }
					}
				}
			}

			let main_role_move = () => {
				if (!check_jump_point_time) {
					this.CheckJumpPoint()
					check_jump_point_time = local_Status.NowTime
				} else {
					if (local_Status.NowTime - check_jump_point_time > Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.check_jump_point_space) {
						this.CheckJumpPoint()
						check_jump_point_time = local_Status.NowTime

						// if (!scene_mgr.IsSeaHegemonyScene()) {
						// 	this.CheckDoorInSameScene(true, 4)
						// }
					}
				}
				this.MainRoleQuitCollect()
			}

			let main_role_task_jump = (task_jump_type, end_pos, call_back, move_vspeed, role) => {

				role = role || this.main_role
				if (role == null) { return }
				if (role.is_shoe_flying) { return }
				if (role.IsInState(local_PoseState.TASK_JUMP)) { return }
				let distance = local_GameMath.GetDistance(role.real_pos.x, role.real_pos.y, end_pos.x, end_pos.y, true)
				let dir = new local_Vector2(end_pos.x - role.real_pos.x, end_pos.y - role.real_pos.y)
				dir.normalise()
				let target_list

				if (task_jump_type == Role.MULTI_JUMP_TYPE.Jump_4) {
					target_list = [
						new local_Vector2(role.real_pos.x + dir.x * distance / 2, role.real_pos.y + dir.y * distance / 2),
						new local_Vector2(end_pos.x, end_pos.y),
					]
				} else if (task_jump_type == Role.MULTI_JUMP_TYPE.Jump_5) {
					target_list = [
						new local_Vector2(role.real_pos.x + dir.x * distance / 3, role.real_pos.y + dir.y * distance / 3),
						new local_Vector2(role.real_pos.x + dir.x * distance / 3 * 2, role.real_pos.y + dir.y * distance / 3 * 2),
						new local_Vector2(end_pos.x, end_pos.y),
					]
				} else {
					target_list = []
				}
				Global_Event_System.Fire(Event_Name.CANCEL_SPEED_BUFF)
				// Global_Event_System.Fire(FightEvent.FINISH_CURRENT_FIGHT_INFO)
				role.DoTaskJump(task_jump_type, target_list, call_back, move_vspeed)
			}

			Global_Event_System.Bind(local_SceneEventType.DOOR_VO_ADD, door_add);
			Global_Event_System.Bind(local_SceneEventType.NPC_VO_ADD, npc_add);
			Global_Event_System.Bind(local_SceneEventType.ROLE_VO_ADD, roleAdd);
			Global_Event_System.Bind(local_SceneEventType.ROLE_VO_REMOVE, roleDel);
			Global_Event_System.Bind(local_SceneEventType.MONSTER_VO_ADD, monsterAdd);
			Global_Event_System.Bind(local_SceneEventType.MONSTER_VO_REMOVE, monsterDel);
			Global_Event_System.Bind(local_SceneEventType.OTHER_VO_ADD, otherAdd);
			Global_Event_System.Bind(local_SceneEventType.DROP_VO_ADD, dropAdd);
			Global_Event_System.Bind(local_SceneEventType.OTHER_VO_REMOVE, otherDel);
			Global_Event_System.Bind(local_SceneEventType.DROP_VO_REMOVE, dropDel);
			Global_Event_System.Bind(local_SceneEventType.NPC_VO_REMOVE, delete_npc);
			Global_Event_System.Bind(local_SceneEventType.DOOR_VO_REMOVE, delete_door);
			Global_Event_System.Bind(local_SceneEventType.OPEN_SCENE_LOAD_VIEW, sceneLoad)


			Global_Event_System.Bind(local_SceneEventType.JUMPPOINT_VO_ADD, jumppoint_add)
			Global_Event_System.Bind(local_SceneEventType.JUMPPOINT_VO_REMOVE, delete_jumppoint)

			Global_Event_System.Bind(local_SceneEventType.MAIN_ROLE_MOVE_TO_BLOCK, reset_fun)
			Global_Event_System.Bind(local_SceneEventType.MAIN_ROLE_JUMP, main_role_jump)
			Global_Event_System.Bind(local_SceneEventType.MAIN_ROLE_JUMP_END, main_role_jump_end)
			Global_Event_System.Bind(local_SceneEventType.MAIN_ROLE_JUMP_END_IMM, main_role_jump_end_imm)
			Global_Event_System.Bind(local_SceneEventType.MAIN_ROLE_MOVE_END, main_role_move_end)
			Global_Event_System.Bind(local_ObjectEventType.MAINROLE_MOVE_EVENT_IMME, main_role_move)
			Global_Event_System.Bind(local_SceneEventType.TASK_MUL_JUMP, main_role_task_jump)

			Global_Event_System.Bind(local_SceneEventType.GRAVE_VO_ADD, grave_add)
			Global_Event_System.Bind(local_SceneEventType.GRAVE_VO_REMOVE, grave_del)
			let hide_all_mon = () => {
				this.is_hide_all_mon = true;
				this.UpdateAllMonsterVisible();
			};
			let show_all_mon = () => {
				this.is_hide_all_mon = null;
				this.UpdateAllMonsterVisible();
			};
			Global_Event_System.Bind(local_SceneEventType.HIDE_ALL_MONSTER, hide_all_mon);
			Global_Event_System.Bind(local_SceneEventType.SHOW_ALL_MONSTER, show_all_mon);
			let onMonsterDeadHandler = (id) => {
				scene_mgr.DeleteMonsterVo(id);
			};
			Global_Event_System.Bind(local_ObjectEventType.OBJ_DEAD, onMonsterDeadHandler);
			//尸体渐隐结束的回调
			let deadbody_fade_end_func = (deadbody_id) => {
				this.DeleteDeadBody(deadbody_id);
			};
			Global_Event_System.Bind(local_ObjectEventType.OBJ_DEADBODY_FADE_END, deadbody_fade_end_func);
			let talk_board_out = (instance_id) => {
				let auto_mgr = AutoFightManager.GetInstance();
				// auto_mgr.talk_count = (--auto_mgr.talk_count <= 0) ? 0 : --auto_mgr.talk_count;
				let monster;
				for (let id in this.monster_dead_body_list) {
					monster = this.monster_dead_body_list[id];
					if (monster.id == instance_id) {
						deadbody_fade_end_func(id);
						break;
					}
				}
			};
			Global_Event_System.Bind(local_ObjectEventType.TALK_BOARD_TIME_OUT, talk_board_out);
			let roleWalkCompleteHandler = () => {
				this.RoleWalkCompleteHandler(true);
			};
			Global_Event_System.Bind(local_SceneEventType.MAIN_ROLE_MOVE_END, roleWalkCompleteHandler);
			let onUpdateRoleLimitHandler = () => {
				this.UpdateRoleVisibleState(true);
			};
			Global_Event_System.Bind(local_SceneEventType.UPDATE_ROLE_LIMIT, onUpdateRoleLimitHandler);
			let loadViewCompl = () => {
				this.scene_change_start_time = false; //重置一下
				let id = SceneManager.GetInstance().GetSceneId()
				if (Config_PRELOAD_CLIENT_CONFIG.ConfigDoorInSameScene[id]) {
					has_same_scene_door = true
				} else {
					has_same_scene_door = false
				}

				let playerLv = role_mgr.GetMainRoleVo().level
				if (playerLv > 85 && !Laya.Browser.onIOS)
					DropManager.GetInstance().CreateDropEffectToPool()
			};
			Global_Event_System.Bind(Event_Name.SCENE_LOAD_VIEW_COMPLETE, loadViewCompl);
			let setting_change = (subtype, is_open) => {
				let cfg = Config_PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType//Config_PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType;
				if (subtype == cfg["partner"]) { //伙伴
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangePartner) {
							role.ChangePartner();
						}
					}
				}
				else if (subtype == cfg["wing"]) { //翅膀
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangeWing) {
							let mask_scene = scene_mgr.CanMaskScene();
							role.ChangeWing(mask_scene);
						}
					}
				}
				else if (subtype == cfg["back"]) { //背饰
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangeBackOrnament) {
							let mask_scene = scene_mgr.CanMaskScene();
							role.ChangeBackOrnament(mask_scene);
						}
					}
				}
				else if (subtype == cfg["demon"]) { //使魔
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangeDemon) {
							role.ChangeDemon();
						}
					}
				}
				else if (subtype == cfg["shengqi"]) { //圣器
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangeShengqi) {
							role.ChangeShengqi();
						}
					}
				}
				else if (subtype == cfg["sprite"]) { //精灵 //sprite
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangeSprite) {
							role.ChangeSprite();
						}
					}
				}
				else if (subtype == cfg["liveness"]) { //活跃度形象
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangeLiveness) {
							let mask_scene = scene_mgr.CanMaskScene();
							role.ChangeLiveness(mask_scene);
						}
					}
				}
				else if (subtype == cfg["sound_open"]) { //音效
					// if (is_open == 1) {
					// 	SoundManager.GetInstance().ResoveSceneSound();
					// }
					// else {
					// 	SoundManager.GetInstance().PauseSceneSound();
					// }
				}
				else if (subtype == cfg["same_screen_role_num"]) { //同屏人数
					Global_Event_System.Fire(local_SceneEventType.UPDATE_ROLE_LIMIT);
				}
				else if (subtype == cfg["weapon"]) { //神兵
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.CreateWeaponSprite) {
							role.CreateWeaponSprite();
						}
					}
				}
				else if (subtype == cfg["simple_mode"]) { //极简模式
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.LoadInfoFromVo) {
							role.LoadInfoFromVo();
						}
					}
					let curr_factor = window["canvasScaleFactor"];
					if (curr_factor) {
						if (is_open) {
							if (Laya.Browser.onPC) {
								local_Util.SetRenderResolution(1);
							}
							else {
								// local_Util.SetRenderResolution(curr_factor * 0.8)
							}
						}
						else {
							if (Laya.Browser.onPC) {
								local_Util.SetRenderResolution(curr_factor);
							}
							else {
								// local_Util.SetRenderResolution(curr_factor)
							}
						}
					}
				}
				else if (subtype == cfg["magic"]) { //魔法阵
					let role;
					for (let id in this.role_list) {
						role = this.role_list[id];
						if (role.ChangeFazhen) {
							role.ChangeFazhen();
						}
					}
				}
				else if (subtype == cfg["selfsprite"]) {
					this.main_role.ChangeSprite();
				}
				// else if (subtype == cfg["selfshengqi"]) {
				//	 if (this.main_role)
				//		 this.main_role.ChangeShengqi();
				// }
				// else if (subtype == cfg["selfliveness"]) {
				//	 if (this.main_role)
				//		 this.main_role.LoadLivenessEffect();
				// }
				else if (subtype == cfg["selffeiqi"]) {
					if (this.main_role.partner)
						this.main_role.partner.PartnerTextureChange();
				}
				else if (subtype == cfg["sound_effect_open"]) {
					if (is_open == 0) {
						SoundManager.GetInstance().ClearAllSoundEffect();
					}
				}
			};
			SettingModel.GetInstance().Bind(SettingModel.BLOCK_SETTING_CHANGE, setting_change)
			let check_fun = () => {
				this.ShouldShowFrameRateAlert();
			};
			Global_Event_System.Bind(Event_Name.CHECK_ALERT_FRAMERATE, check_fun);
			let onMainRoleRushEndHandler = () => {
				this.MainRoleAttackTarget(true, true);
				// this.MainRoleAttackClickTarget()
			};
			Global_Event_System.Bind(local_ObjectEventType.MAINROLE_RUSH_END, onMainRoleRushEndHandler);
			let action_target_missing = () => {
				this.clearGoToData();
			};
			Global_Event_System.Bind(local_SceneEventType.ACTION_TARGET_MISSING, action_target_missing);
			let onCameraMove = (x, y) => {
				// NameBoardManager.GetInstance().UpdateAllNameBoard()
				if (this.IsSceneLoaded()) {
					local_SapManager.GetInstance().Update(x, y)
				}
			};
			Global_Event_System.Bind(local_SceneEventType.CAMERA_MOVE, onCameraMove);
			let onMainRoleMove = (x, y) => {
				let door_list = this.door_list;
				if (!local_Util.IsTableEmpty(door_list)) {
					//当前的起始坐标和终点坐标，必须用RealPos计算才能准确
					let x1 = this.main_role.real_pos.x, y1 = this.main_role.real_pos.y;
					for (let key in door_list) {
						let door = door_list[key];
						let x2 = door.x, y2 = door.y, distance = local_GameMath.GetDistance(x1, y1, x2, y2, false);
						if (distance < 5000) {
							if (scene_mgr.IsSeaHegemonyScene()) {
								let doorVo = door.GetVo();
								if (doorVo) {
									Global_Event_System.Fire(SceneEventType.MOVEREQUEST, doorVo.t_scene_x, doorVo.t_scene_y, MOVE_TYPE.DOOR_JUMP, doorVo.t_scene_x, doorVo.t_scene_y);
									this.main_role.SetRealPos(doorVo.t_scene_x, doorVo.t_scene_y);
									this.main_role.DoStand();
									break;
								}
							}
						}
					}
				}
			};
			Global_Event_System.Bind(local_ObjectEventType.MAINROLE_MOVE, onMainRoleMove);
			GlobalTimerQuest.AddPeriodQuest(this.UpdateRoleVisibleState, 7);

			let has_create_click_target_effect = false
			let onSceneStart = () => {
				if (!has_create_click_target_effect) {
					has_create_click_target_effect = true
					this.CreateClickTargetEffect()
				}
			}
			Global_Event_System.Bind(SceneManager.START, onSceneStart)


			Global_Event_System.Bind(Event_Name.CANCEL_TO_COLLECT, () => {
				this.MainRoleQuitCollect()
			})
		};
		this.AddMonsterDeadExpEffect = (x, y) => {
			this.monster_deap_exp_effect_id_list.push(particle_mgr.AddPosEffect("ui_experience_particle2", new local_Vector2(x, y), true, null, null, false, null, null, 1, true));
		};
		this.ShowMonsterDeadExpEffect = () => {
			if (this.monster_deap_exp_effect_id_list.length > 0) // ==Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.client_autofight_every_wave_monster_count)
			{
				let len = 0;
				for (let id of this.monster_deap_exp_effect_id_list) {
					++len;
					Global_Event_System.Fire(Event_Name.SHOW_MONSTER_DEAP_EXP_FLY_TO_BOTTOM, id, len == this.monster_deap_exp_effect_id_list.length);
				}
				this.monster_deap_exp_effect_id_list.length = 0;
			}
		};
		this.HasMonsterDeadExp = () => {
			return scene_mgr.IsFieldScene() && this.monster_deap_exp_effect_id_list.length > 0;
		};
		//根据世界坐标选择被选中的模型
		this.PointQuery = (world_pt_x, world_pt_y, obj_type?) => {
			let world_pt = new local_Vector2(world_pt_x, world_pt_y)
			let selected_list = [];
			let npc_obj_list = null;
			obj_type = obj_type || scene_base_type.All; //全部
			let obj;
			if (obj_type == scene_base_type.Monster || obj_type == scene_base_type.All) {
				for (let id in this.monster_list) {
					obj = this.monster_list[id];
					if (obj.CheckInBound(world_pt)) {
						selected_list.push(obj);
					}
				}
			}
			if (obj_type == scene_base_type.Role || obj_type == scene_base_type.All) {
				for (let id in this.role_list) {
					obj = this.role_list[id];
					if (obj.CheckInBound(world_pt) && !obj.vo.is_virtual_role) {
						selected_list.push(obj);
					}
				}
			}
			if (obj_type == scene_base_type.Npc || obj_type == scene_base_type.All) {
				for (let id in this.npc_list) {
					obj = this.npc_list[id];
					if (obj.CheckInBound(world_pt)) {
						npc_obj_list = npc_obj_list || [];
						npc_obj_list.push(obj);
						selected_list.push(obj);
					}
				}
			}
			// if (obj_type == scene_base_type.Other || obj_type == scene_base_type.All) {
			//	 for (let id in this.other_list) {
			//		 obj = this.other_list[id]
			//		 if (obj.CheckInBound(world_pt)) {
			//			 selected_list.push(obj)
			//		 }
			//	 }
			// }
			if (obj_type == scene_base_type.Door || obj_type == scene_base_type.All) {
				for (let id in this.door_list) {
					obj = this.door_list[id];
					if (obj.CheckInBound(world_pt)) {
						selected_list.push(obj);
					}
				}
			}
			// if (obj_type == scene_base_type.Drop || obj_type == scene_base_type.All) {
			// 	for (let id in this.drop_list) {
			// 		obj = this.drop_list[id];
			// 		if (obj.CheckInBound(world_pt)) {
			// 			selected_list.push(obj);
			// 		}
			// 	}
			// }
			// if (npc_obj_list) {
			//	 if (npc_obj_list.length > 1) {
			//		 let compareFunc = (v1, v2) => {
			//			 if (v1.real_pos.y < v2.real_pos.y)
			//				 return 1
			//			 else if (v1.real_pos.y == v2.real_pos.y)
			//				 return 0
			//			 else
			//				 return -1
			//		 }
			//		 npc_obj_list.sort(compareFunc)
			//	 }
			//	 return npc_obj_list
			// }
			if (selected_list.length > 1) {
				let compareFunc = (v1, v2) => {
					if (v1.real_pos.y < v2.real_pos.y)
						return 1;
					else if (v1.real_pos.y == v2.real_pos.y)
						return 0;
					else
						return -1;
				};
				selected_list.sort(compareFunc);
			}
			return selected_list;
		};
		this.SetClickTarget = (target: Character, force?) => {
			if (this.curr_click_target == target && !force) return
			this.CancelClickTarget()
			this.curr_click_target = target;
			if (!this.click_target_effect) {
				return
			}
			if (local_Util.IsNull(this.click_target_effect)) {
				this.click_target_effect.destroy()
				this.click_target_effect = null
				this.CreateClickTargetEffect(true)
				return
			}
			if (target && target.GetType) {
				Global_Event_System.Fire(Event_Name.MAIN_ROLE_CHANGE_ATTACK_TARGRT, target)
				if (ViewManager.is_lock_screen) {
					if (this.click_target_effect.active) {
						this.click_target_effect.active = false
					}
				} else {
					this.click_target_effect.active = true
					target.root_transform.owner.addChild(this.click_target_effect)
					Set3DLocalPosition(this.click_target_effect.transform, 0, 0, 0)
					Set3DLocalRotationEuler(this.click_target_effect.transform, -local_SceneObj.StartRotate.x, 0, 0)
					Set3DLocalScale(this.click_target_effect.transform, 0.7, 0.7, 0.7)
				}
			};

		}
		this.GetClickTarget = () => {
			if (this.curr_click_target && this.curr_click_target.IsDead()) {
				this.curr_click_target = null;
			}
			return this.curr_click_target;
		};

		this.CancelClickTarget = (force_select_new_target?) => {
			if (this.curr_click_target && this.curr_click_target.GetType) {
				if (!force_select_new_target && this.manual_target && !this.manual_target.IsDead() && this.manual_target == this.curr_click_target &&
					!scene_mgr.IsBossScene()) { //不取消手选的目标
					let vo = this.curr_click_target.GetVo()
					let not_collect = vo && vo.type != local_MonsterType.COLLECT && vo.type != local_MonsterType.TASK_COLLECT && vo.type != local_MonsterType.PICK
					if (not_collect) {
						return
					}
				}
				if (local_Util.IsNull(this.click_target_effect)) {
					this.click_target_effect = null
					this.CreateClickTargetEffect()
					return
				} else {
					this.click_target_effect.active = false
				}
				//挂机选择目标那里会找不到怪物
				if (this.manual_target == this.curr_click_target) {
					this.manual_target = undefined
				}
				this.curr_click_target = undefined
				this.has_task_target = undefined
				Global_Event_System.Fire(local_SceneEventType.CANCEL_CLICK_TARGET)
				if (force_select_new_target) {
					this.UpdateAutoClickTarget()
				}
			}
		}

		this.CreateClickTargetEffect = (need_select?) => {
			let effect_name = "function_selection"
			var load_call_back = (obj) => {
				if (obj) {
					this.click_target_effect = obj
					this.click_target_effect.active = false
					if (need_select) {
						this.SetClickTarget(this.curr_click_target, true)
					}
				}
			}
			let full_url = GameResPath.GetEffectPath(EffectResType.Other, effect_name)
			ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back, LOAD_QUEUE.LOW)
		}

		this.GetMainRole = () => {
			return this.main_role;
		};
		this.DeleteMainRole = () => {
			if (this.main_role) {
				// _sceneObj_layer.removeChild(this.main_role)
				this.main_role.DeleteMe();
				this.main_role = null;
			}
		};
		this.CreateMainRole = () => {
			this.main_role.disabled = false
			this.main_role.InitRoleVo(mainrole_vo);
			this.main_role.LoadInfoFromVo();
		};
		this.ResetMainRoleInfo = () => {
			this.main_role.model_res = null
		}
		this.MainRoleMove = (end_pos, range?, end_function?, is_fire_evt?, force_move?, save_end_pos = true, update_function?) => {
			this.clearGoToData();
			this.CancelWaitQuest()

			if (force_move != false) {
				if (!this.main_role.CanMove()) {
					let timer_func = () => {
						if (this.main_role.CanMove()) {
							this.MainRoleMove(end_pos, range, end_function, is_fire_evt, force_move, save_end_pos, update_function)
							return
						}
					}
					this.timer = GlobalTimerQuest.AddPeriodQuest(timer_func, 0.1)
					return
				}
			}


			range = range ? range : 0;
			if (range > 0) {
				let path_info = mapView.FindWay(this.main_role.logic_pos.x, this.main_role.logic_pos.y, end_pos.x, end_pos.y, range);
				if (path_info) {
					path_info.reverse();
					let total_point = path_info.length;
					let game_end_pos = path_info[total_point - 1];
					if (total_point >= 1 && !scene_mgr.IsBlockXY(game_end_pos.x, game_end_pos.y)) {
						end_pos.x = game_end_pos.x;
						end_pos.y = game_end_pos.y;
					}
				}
			}
			if (save_end_pos) {
				this.goToPos = end_pos as any;
				this.goToFunc = end_function;
			}

			is_fire_evt = is_fire_evt == null ? true : is_fire_evt
			let end_func = () => {
				this.clearGoToData();
				if (is_fire_evt) {
					Global_Event_System.Fire(Event_Name.FINDWAY_ENDED)
				}
				if (end_function != null) {
					end_function();
				}
				this.Fire(SceneEventType.SCENE_MOVE_END);
			};
			let update_func = () => {
				if (update_function != null) {
					update_function();
				}
			};

			let _logic = this.main_role.GetLogicPos();
			let start_pos_x = _logic.x
			let start_pos_y = _logic.y
			if (end_pos.x == start_pos_x && end_pos.y == start_pos_y) {
				end_func();
			}
			else {
				oper_mgr.StartMoveAction(end_pos, end_func, update_func);
			}
		};

		//force_move 强制移动  如果当前不能移动 则定时判断直到可以走
		this.MainRoleToNpc = (npc_id?, force_move?, save_end_pos = true) => {
			let npc_info = scene_mgr.GetNpcVo(npc_id)
			if (npc_info == null) {
				return
			}
			let npcpos = new local_Vector2(npc_info.logic_x, npc_info.logic_y)
			let x = this.main_role.GetLogicPos().x
			let y = this.main_role.GetLogicPos().y
			let rolepos = new local_Vector2(x, y)
			let dist = 2.5
			let check_distance = 420
			this.clearGoToData()
			let action_func = () => {
				Global_Event_System.Fire(Event_Name.STOPAUTOFIGHT)
				// 转向
				this.clearGoToData()
				if (this.main_role.IsInState(local_PoseState.MOVE)) {
					this.main_role.DoStand()
				}

				let dir2 = npcpos.getDir(rolepos)
				this.main_role.SetDirection(dir2)
				let is_fire_evt = OperateManager.Instance.StopMove()
				let npc = this.GetNpc(npc_id)
				if (npc != null) {
					this.SetClickTarget(npc)
					if (npc.vo) {
						//if (npc.vo && ! Config.ConfigGuildWar.KeepDirectNpc[npc.vo.type_id] ) {
						let dir = new local_Vector2(this.main_role.real_pos.x - npc.real_pos.x, this.main_role.real_pos.y - npc.real_pos.y)
						npc.SetDirection(dir)
					}
					// if (local_GameMath.GetDistance(this.main_role.real_pos.x, this.main_role.real_pos.y, npc.real_pos.x, npc.real_pos.y, true) < check_distance) {
					if (scene_mgr.IsSeaAsserScene()) {
						SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.MOVE_TO_NPC, npc_info.instance_id)
					} else {
						Global_Event_System.Fire(SceneEventType.SHOW_TASK, npc_info.instance_id)
					}
					// }
				}
				// if (! is_fire_evt ) {
				Global_Event_System.Fire(Event_Name.FINDWAY_ENDED)
				// }
			}

			let npc = this.GetNpc(npc_id)
			if (npc != null) {
				this.SetClickTarget(npc)
			}

			// 如果已经在范围内了
			if (local_GameMath.GetDistance(npcpos.x, npcpos.y, rolepos.x, rolepos.y, true) <= dist + 1) {
				action_func()
			} else {
				this.MainRoleMoveAndCancel(new local_Vector2(npc_info.logic_x, npc_info.logic_y), dist, action_func, false, force_move)
			}
		}

		/*
		* 移动并取消攻击对象等
		* @param point 目标点
		*force_move 强制移动  如果当前不能移动 则定时判断直到可以走
		*/
		this.MainRoleMoveAndCancel = (point?, range?, end_function?, is_fire_evt?, force_move?) => {
			if (this.ChcekCanMove() == false) {
				return
			}
			range = range || 0
			//定点移动
			this.MainRoleMove(point, range, end_function, is_fire_evt, force_move)

			if (skill_mgr.getCurrentSkillId() != 0) {
				skill_mgr.setCurrentSkillId()
			}
		}

		this.ChcekCanMove = () => {
			if (mainrole_vo.chaosTime > 0) {
				Message.show("你处于混乱状态，暂时不能自由移动！")
				return false
			}
			return true
		}

		this.clearGoToData = () => {
			this.goToPos = null;
			this.goToFunc = null;
		};
		this.AddMovingObj = (obj) => {
			if (obj != this.main_role && this.moving_obj_list.indexOf(obj) < 0) {
				this.moving_obj_list.push(obj);
			}
		};
		this.RemoveMovingObj = (obj) => {
			let index = this.moving_obj_list.indexOf(obj);
			if (index >= 0) {
				this.moving_obj_list.splice(index, 1);
			}
		};
		let cache_elapse_time = 0
		this.Update = (now_time, elapse_time) => {
			this.update_scene_times_index++;
			let update_index = this.update_scene_times_index;
			// let bool_playing = !BanquetAniManager.GetInstance().bool_playing;//非婚宴动画仪式下执行，否则导致动画移动不同步
			// if (bool_playing) {
			// 	main_camera.AddAverageTime(elapse_time);
			// }
			this.main_role.Update(now_time, elapse_time);
			main_camera.Update(now_time, elapse_time);
			cache_elapse_time += elapse_time
			if (update_index % local_ViewManager.OPENBIGVIEWFRAME != 0) {
				return
			}
			let v;
			for (let id in this.sprite_list) {
				v = this.sprite_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			for (let id in this.demon_list) {
				v = this.demon_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			for (let id in this.shengqi_list) {
				v = this.shengqi_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			for (let id in this.partner_list) {
				v = this.partner_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}

			if (!this.force_update_in_next_frame && !layer_mgr.CheckFrameTimeValid()) {
				this.force_update_in_next_frame = true
				return
			}

			for (let obj of this.moving_obj_list) {
				if (obj && !obj.use_delete_method && !obj.is_in_cache_pool) {
					obj.Update(now_time, cache_elapse_time);
				}
			}
			this.is_in_update = true;

			// if (update_index % 2 == 0) {
			for (let id in this.monster_list) {
				v = this.monster_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			for (let id in this.monster_dead_body_list) {
				v = this.monster_dead_body_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			// }
			// if (update_index % 1 == 0) {
			for (let id in this.role_list) {
				v = this.role_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			// }
			// if (update_index % 1 == 0) {
			let drop_obj
			for (let drop_id in this.drop_list) {
				drop_obj = this.drop_list[drop_id]
				if (drop_obj.IsFinishState()) {
					this.DeleteDrop(drop_obj.GetDropId())
				}
				else {
					drop_obj.Update(now_time, cache_elapse_time)
				}
			}
			// }
			// if (update_index % 1 == 0) {

			for (let id in this.npc_list) {
				v = this.npc_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			for (let id in this.other_list) {
				v = this.other_list[id];
				if (v.CanUpdate())
					v.Update(now_time, cache_elapse_time);
				else
					v.AddIgnoreUpdateIndex();
			}
			for (let id in this.drop_list) {
				v = this.drop_list[id]
				v.Update(now_time, cache_elapse_time)
			}
			for (let id in this.grave_list) {
				v = this.grave_list[id]
				v.Update(now_time, cache_elapse_time)
			}
			//调用延时函数(避免回调过程出错对应列表始终不清空)
			if (this.delay_handle_funcs.length > 0) {
				for (let v of this.delay_handle_funcs) {
					if (v)
						v();
				}
				this.delay_handle_funcs.length = 0;
			}
			// }
			this.is_in_update = false;
			if (update_index % 6 == 0) {
				this.UpdateAutoFight();
			}
			if (this.update_role_name && update_index % 20 == 0) {
				this.UpdateRole();
			}
			if (this.update_monster_name) {
				this.UpdateMonster();
			}
			cache_elapse_time = 0
			if (this.force_update_in_next_frame) {
				this.force_update_in_next_frame = false
			}
			// if (update_index % 299 == 0) {
			//	 this.UpdateRoleVisibleState(undefined)
			// }
			// if (update_index % 19 == 0) {
			//	 this.ShouldShowFrameRateAlert()
			// }
		};
		this.UpdateRole = () => {
			if (this.update_role_name) {
				for (let id in this.role_list) {
					let role = this.role_list[id];
					if (this.update_role_name)
						role.UpdateName();
				}
				this.main_role.UpdateName();
				this.update_role_name = false;
			}
		};
		this.UpdateMonster = () => {
			if (this.update_monster_name) {
				let mon;
				for (let id in this.monster_list) {
					mon = this.monster_list[id];
					mon.UpdateName();
				}
				this.update_monster_name = false;
			}
		};
		this.UpdateAutoFight = () => {
			scene_mgr.auto_fight_state_code = 1;
			if (!scene_mgr.IsSceneStart() || !this.IsSceneLoaded()) {
				// console.log("------Can't UpdateAutoFight!!! code = 1------");
				scene_mgr.auto_fight_state_code = 2;
				return;
			}

			if (!auto_fight_mgr.GetAutoFightState()) {
				// console.log("------Can't UpdateAutoFight!!! code = 2------");
				scene_mgr.auto_fight_state_code = 3;
				return
			}

			if (!load_progress_finished) {
				return
			}

			if (!user_mgr.IsGameConnected()) {
				console.log("------Can't UpdateAutoFight!!! code = 2------");
				scene_mgr.auto_fight_state_code = 3;
				return;
			}

			if (this.main_role.IsDead() || mainrole_vo.hp <= 0 || mainrole_vo.ghost_mode == 1) {
				console.log("------Can't UpdateAutoFight!!! code = 4------");
				scene_mgr.auto_fight_state_code = 5;
				return;
			}

			// if (scene_mgr.collecting) {
			// 	console.log("------Can't UpdateAutoFight!!! code = 5------");
			// 	scene_mgr.auto_fight_state_code = 6;
			// 	return;
			// }

			if (this.main_role.play_change_god_action) {
				console.log("------Can't UpdateAutoFight!!! code = 7------");
				scene_mgr.auto_fight_state_code = 8;
				return;
			}

			if (scene_mgr.curr_joystick_dir) {
				console.log("------Can't UpdateAutoFight!!! code = 8------");
				scene_mgr.auto_fight_state_code = 9;
				return;
			}

			if (this.main_role.IsInState(local_PoseState.RUSH)) {
				console.log("------Can't UpdateAutoFight!!! code = 9------");
				return;
			}

			this.AutoPick()

			if (this.goToPos && !scene_mgr.AlwaysFindNearestTargetScene()) {
				console.log("------Can't UpdateAutoFight!!! code = 3------");
				scene_mgr.auto_fight_state_code = 4;
				return;
			}

			if (local_Status.NowTime - this.last_find_target_time < this.auto_find_and_attack_interval) //local_Status.NowTime - this.last_attack_time < this.auto_find_and_attack_interval ||
				return

			if (local_Status.NowTime - this.user_manul_time < 0.5)
				return

			if (this.CheckPick()) {
				console.log("------Can't UpdateAutoFight!!! code = 11------");
				return
			}

			if (role_mgr.GetMainRoleDepositState()) {
				console.log("------Can't UpdateAutoFight!!! code = 13------");
				return
			}

			if (skill_mgr.IsInRigidity()) {
				return
			} else {
				let cached_id = skill_mgr.PopCachedSkill()
				if (cached_id != null) {
					let skillVo = skill_mgr.getSkill(cached_id)
					if (skillVo && skillVo.CoolDown()) {
						Global_Event_System.Fire(FightEvent.SKILL_SHORTCUT_CLICK, cached_id)
					}
					return
				}
			}


			if (!skill_mgr.PrepareAutoFightSkill(true)) {
				scene_mgr.auto_fight_state_code = 12;
				console.log("------Can't UpdateAutoFight!!! code = 12------");
				return;
			}

			//临时手动状态
			if (auto_fight_mgr.GetTempMode()) {
				if (local_Status.NowTime - this.user_manul_time < AutoFightManager.TempModeTime) {
					return
				}
				auto_fight_mgr.SetTempMode(false)
			}

			if (scene_mgr.IsNoonPartyScene()) {
				let mon = NoonPartyModel.GetInstance().FindNearestCollect()
				if (mon) {
					this.SetClickTarget(mon)
				} else if (this.curr_click_target && this.curr_click_target.GetVo() && this.curr_click_target.GetVo().type == local_MonsterType.COLLECT) {
					this.SetClickTarget(undefined)
				}
			} else if (scene_mgr.IsFeastBossScene()) {
				let mon = BossModel.GetInstance().FindNearestCollect()
				if (mon) {
					this.SetClickTarget(mon)
				} else if (this.curr_click_target && this.curr_click_target.GetVo() && this.curr_click_target.GetVo().type == local_MonsterType.COLLECT) {
					this.SetClickTarget(undefined)
				}
			}

			if (scene_mgr.AlwaysFindNearestTargetScene() && this.curr_click_target) {
				this.UpdateAutoClickTarget()
			}

			if (this.curr_click_target && this.curr_click_target.IsDead() == false) {
				if (this.curr_click_target.GetType() == scene_base_type.Role) {
					if (!scene_mgr.IsCanAttackByMainRole(this.curr_click_target.vo)) { //如果当前选中的是不能被打的 就取消掉
						this.CancelClickTarget()
						return
					}
					this.MainRoleAttackRole(this.curr_click_target)
				} else if (this.curr_click_target.GetType() == scene_base_type.Monster) {
					if (SceneManager.GetInstance().IsSeaAsserScene()) {
						let isSea: boolean = SeaHegemonyModel.GetInstance().seaHegemonyData?.camp == SeaHegemonyModel.GetInstance().assertSceneData?.sea_id;
						if (this.main_role.vo.brick_id > 0) {
							this.CancelClickTarget(this.curr_click_target)
							auto_mgr.StopAutoFight(false)
							return Message.show('搬砖状态下无法攻击海域怪物');
						}
						if (isSea) {
							this.CancelClickTarget(this.curr_click_target);
							auto_mgr.StopAutoFight(false);
							return Message.show('无法攻击己方海域怪物');
						}
					}
					this.MainRoleAttackMonster(this.curr_click_target)
				}
			} else {
				this.UpdateAutoClickTarget()
			}
		};
		this.MainRoleAttackTarget = (not_rush = false, force_attack = false) => {
			let ranAttackObj: Character = this.GetClickTarget();
			// if (!ranAttackObj || scene_mgr.AlwaysFindNearestTargetScene()) {
			// 	let [monster_list, role_list] = this.FindTargets(attack_type_all, 1, null, 10000, null, null, null);
			// 	if (monster_list && monster_list.length > 0) {
			// 		ranAttackObj = monster_list[0];
			// 	}
			// 	if (!ranAttackObj && role_list && role_list.length > 0) {
			// 		ranAttackObj = role_list[0];
			// 	}
			// 	if (ranAttackObj) {
			// 		this.SetClickTarget(ranAttackObj);
			// 	}
			// }
			// scene_mgr.curr_attack_target = ranAttackObj;
			if (ranAttackObj) {
				if (ranAttackObj._type == scene_base_type.Role) {
					this.MainRoleAttackRole(ranAttackObj);
				}
				else if (ranAttackObj._type == scene_base_type.Monster) {
					this.MainRoleAttackMonster(ranAttackObj, not_rush, force_attack);
				}
				else {
					this.CancelClickTarget()
					this.UpdateAutoClickTarget()
					Global_Event_System.Fire(FightEvent.RELEASE_MAIN_SKILL)
				}
			}
			else {
				Global_Event_System.Fire(FightEvent.RELEASE_MAIN_SKILL)
			}
		};
		// this.MainRoleAttackClickTarget =(=>)
		// {
		//	 if (this.curr_click_target)
		//	 {
		//		 if (this.curr_click_target.GetType() == scene_base_type.Monster)
		//		 {
		//			 this.MainRoleAttackMonster(this.curr_click_target, true, true)
		//			 this.SetClickTarget(null) 
		//		 }
		//	 }
		// }
		this.MainRoleRushToMonster = (monster, ignore_skill_range = false, is_task = false) => {
			let skill_id = skill_mgr.PrepareAutoFightSkill(true);
			if (skill_id && skill_mgr.CanAttack(skill_id) && monster) {
				let mon_vo_type = monster.GetVo().type;
				if (monster && !monster.IsDead() && mainrole_vo.ghost_mode != 1
					&& mon_vo_type != local_MonsterType.COLLECT && mon_vo_type != local_MonsterType.TASK_COLLECT
					&& mon_vo_type != local_MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT && mon_vo_type != local_MonsterType.INFINITE_COLLECT && mon_vo_type != local_MonsterType.NOT_DEAD_COLLECT
					&& mon_vo_type != local_MonsterType.TOWER
					&& scene_mgr.IsCanAttackByMainRole(monster.GetVo(), true)
				) // && this.main_role.GetHorseRes()) //&& not skill_mgr.IsInRigidity()
				{

					let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo;

					let rush_min_dist, rush_max_dist, rush_to_target_dist
					if (is_task) {
						rush_min_dist = cfg.task_rush_to_monster_min_dist
						rush_max_dist = cfg.task_rush_to_monster_max_dist
						rush_to_target_dist = cfg.task_rush_to_monster_dist_with_monster
					}
					else {
						rush_min_dist = cfg.rush_to_monster_min_dist
						rush_max_dist = cfg.rush_to_monster_max_dist
						rush_to_target_dist = cfg.rush_to_monster_dist_with_monster
					}
					let attack_range = skill_mgr.GetCurrentAttackRange();
					this.rush_to_start_real_pos.x = this.main_role.real_pos.x;
					this.rush_to_start_real_pos.y = this.main_role.real_pos.y;
					this.rush_to_end_real_pos.x = monster.real_pos.x;
					this.rush_to_end_real_pos.y = monster.real_pos.y;
					this.rush_to_end_dir.x = this.rush_to_end_real_pos.x - this.rush_to_start_real_pos.x;
					this.rush_to_end_dir.y = this.rush_to_end_real_pos.y - this.rush_to_start_real_pos.y;
					let distance = this.rush_to_end_dir.normalise(); //GameMath_GetDistance(this.rush_to_start_real_pos.x, this.rush_to_start_real_pos.y, this.rush_to_end_real_pos.x, this.rush_to_end_real_pos.y, true)

					let end_func = () => {
						// oper_mgr.StopMove()
						if (!monster.IsDead()) {
							this.rush_to_start_real_pos.x = this.main_role.real_pos.x;
							this.rush_to_start_real_pos.y = this.main_role.real_pos.y;
							this.rush_to_end_real_pos.x = monster.real_pos.x;
							this.rush_to_end_real_pos.y = monster.real_pos.y;
							this.rush_to_end_dir.x = this.rush_to_end_real_pos.x - this.rush_to_start_real_pos.x;
							this.rush_to_end_dir.y = this.rush_to_end_real_pos.y - this.rush_to_start_real_pos.y;
							let distance = this.rush_to_end_dir.normalise();
							// let distance = local_GameMath.GetDistance(this.main_role.real_pos.x, this.main_role.real_pos.y, monster.real_pos.x, monster.real_pos.y, true)
							if (distance <= attack_range && !ignore_skill_range) {
								this.MainRoleAttackMonster(monster, true);
							}
							else if ((distance <= rush_max_dist && distance >= rush_min_dist) || local_Math.abs(distance - rush_max_dist) < 100 || local_Math.abs(distance - rush_min_dist) < 70) {
								// if (local_Math.abs(distance - rush_max_dist) <= rush_max_dist)
								this.rush_to_end_real_pos_temp.x = this.rush_to_end_real_pos.x - this.rush_to_end_dir.x * rush_to_target_dist;
								this.rush_to_end_real_pos_temp.y = this.rush_to_end_real_pos.y - this.rush_to_end_dir.y * rush_to_target_dist;
								if (scene_mgr.IsBlockXY(this.rush_to_end_real_pos_temp.x / LogicRealRatio_X, this.rush_to_end_real_pos_temp.y / LogicRealRatio_Y)) {
									this.rush_to_end_real_pos_temp.x = monster.real_pos.x;
									this.rush_to_end_real_pos_temp.y = monster.real_pos.y;
								}
								// this.SetClickTarget(monster)  		//冲刺前可能this.curr_click_target已经取消了，所以这里重新设置一下curr_click_target
								this.main_role.DoRush(this.rush_to_end_real_pos_temp, Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.rush_to_monster_speed);
							}
							else {
								this.rush_to_end_real_pos_temp.x = monster.real_pos.x / LogicRealRatio_X;
								this.rush_to_end_real_pos_temp.y = monster.real_pos.y / LogicRealRatio_Y;
								this.MainRoleMove(this.rush_to_end_real_pos_temp, 0, end_func, false);
							}
						}
					};
					if (distance > rush_max_dist) {
						let dist_off = local_Math.max(0, distance - rush_max_dist - 80);
						this.rush_to_end_real_pos_temp.x = (this.rush_to_start_real_pos.x + this.rush_to_end_dir.x * dist_off) / LogicRealRatio_X;
						this.rush_to_end_real_pos_temp.y = (this.rush_to_start_real_pos.y + this.rush_to_end_dir.y * dist_off) / LogicRealRatio_Y;
						if (scene_mgr.IsBlockXY(this.rush_to_end_real_pos_temp.x, this.rush_to_end_real_pos_temp.y)) {
							this.rush_to_end_real_pos_temp.x = monster.real_pos.x / LogicRealRatio_X;
							this.rush_to_end_real_pos_temp.y = monster.real_pos.y / LogicRealRatio_Y;
						}
						this.MainRoleMove(this.rush_to_end_real_pos_temp, 0, end_func, false);
					}
					else if (distance > rush_min_dist) {
						end_func();
					}
					else {
						// if (distance <= attack_range)
						// {
						this.MainRoleAttackMonster(monster, true);
						// }
						// this.last_attack_time = local_Status.NowTime
						// Global_Event_System.Fire(local_FightEvent.RELEASE_MAIN_SKILL, null, null, monster.compress_id)
					}
					return true;
				}
			}
			return false;
		};
		this.MainRoleAttackMonster = (monster, not_rush = false, force_attack = false, rush_ignore_skill_range = false, is_task = false) => {
			if (monster == null || monster.IsDead())
				return;
			if (!skill_mgr.getCurrentSkill() && !skill_mgr.PrepareAutoFightSkill(true)) {
				return;
			}
			if (scene_mgr.CanRushScene()) {
				if (!not_rush && this.MainRoleRushToMonster(monster, rush_ignore_skill_range, is_task)) {
					return;
				}
			}
			//婚宴，餐桌和糖果有采集限制
			let monster_type_id = monster.GetVo().type_id
			let monster_ins_id = monster.GetVo().instance_id
			if (scene_mgr.IsWeddingScene() && BanquetModel.GetInstance().IsTable(monster_type_id) && !BanquetModel.GetInstance().CanEat(monster_type_id, monster_ins_id)) {
				return
			}
			if (scene_mgr.IsWeddingScene() && BanquetModel.GetInstance().IsCandy(monster_type_id) && !BanquetModel.GetInstance().CanSuger(monster_type_id, monster_ins_id)) {
				return
			}

			//海王争夺 海域
			if (scene_mgr.IsSeaHegemonyScene() && monster) {
				let sea_vo = monster.GetVo()
				if (sea_vo && !SeaHegemonyModel.GetInstance().CanAttackMonster(sea_vo)) {
					this.SetClickTarget(null)
					return
				}
			}

			let action_func = () => {
				this.clearGoToData();
				oper_mgr.ClearSrcOper()
				let mon_type = monster.GetVo() && monster.GetVo().type;
				if (mainrole_vo.ghost_mode == 1 && mon_type
					&& (mon_type == local_MonsterType.COLLECT
						|| mon_type == local_MonsterType.INFINITE_COLLECT
						|| mon_type == local_MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT
						|| mon_type == local_MonsterType.NOT_DEAD_COLLECT)) {
					Message.show("您处于幽灵模式，不能进行采集！");
					return;
				}
				let skill_id = skill_mgr.getCurrentSkillId();
				if (monster.IsDead()) {
					this.SetClickTarget(null);
					return;
				}
				if (mon_type == local_MonsterType.COLLECT
					|| mon_type == local_MonsterType.TASK_COLLECT
					|| mon_type == local_MonsterType.INFINITE_COLLECT
					|| mon_type == local_MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT
					|| mon_type == local_MonsterType.NOT_DEAD_COLLECT) { //普通采集
					if (monster.CanCollect()) {
						Global_Event_System.Fire(Event_Name.OPEN_COLLECT_VIEW, monster.id, monster.GetVo().type_id, monster.GetVo().pick_time, null, null)
					}
					return;
				}
				if (!skill_mgr.CanAttack(skill_id))
					return;
				if (!skill_mgr.IsInRigidity()) {
					// this.last_attack_time = local_Status.NowTime
					Global_Event_System.Fire(local_FightEvent.RELEASE_MAIN_SKILL, null, null, monster.compress_id, force_attack);
				}
			};
			let target_obj = monster;
			if (this.attack_target_start_real_pos == null)
				this.attack_target_start_real_pos = new local_Vector2(this.main_role.real_pos.x, this.main_role.real_pos.y);
			else {
				this.attack_target_start_real_pos.x = this.main_role.real_pos.x;
				this.attack_target_start_real_pos.y = this.main_role.real_pos.y;
			}
			if (this.attack_target_end_real_pos == null)
				this.attack_target_end_real_pos = new local_Vector2(target_obj.x, target_obj.y);
			else {
				this.attack_target_end_real_pos.x = target_obj.real_pos.x;
				this.attack_target_end_real_pos.y = target_obj.real_pos.y;
			}
			let attack_range;
			let mon_type = monster.GetVo().type;
			if (mon_type == local_MonsterType.COLLECT || mon_type == local_MonsterType.TASK_COLLECT || mon_type == local_MonsterType.INFINITE_COLLECT || mon_type == local_MonsterType.NOT_DEAD_COLLECT || mon_type == local_MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT) { //普通采集
				attack_range = 90
			}
			else {
				attack_range = skill_mgr.GetCurrentAttackRange();
			}
			let distance = local_GameMath.GetDistance(this.attack_target_start_real_pos.x, this.attack_target_start_real_pos.y, this.attack_target_end_real_pos.x, this.attack_target_end_real_pos.y, false);
			if (force_attack || distance <= attack_range * attack_range) {
				if (this.main_role.IsInState(local_PoseState.MOVE)) {
					this.main_role.SetDirection(this.attack_target_start_real_pos, this.attack_target_end_real_pos, true, true);
					this.main_role.DoStand();
				}
				action_func();
			}
			else if (this.main_role.CanMove()) {
				this.last_find_target_time = local_Status.NowTime;
				oper_mgr.StartTargetAction(monster.compress_id, attack_range, action_func);
			}
		};
		this.MainRoleAttackRole = (role) => {
			if (role == null || role.IsDead() || role == this.main_role)
				return;
			if (!skill_mgr.getCurrentSkill() && !skill_mgr.PrepareAutoFightSkill(true)) {
				return;
			}
			let action_func = () => {

				if (scene_mgr.IsSeaHegemonyScene()) {
					let sea_vo = role.GetVo()
					if (sea_vo && !SeaHegemonyModel.GetInstance().CanAttackRole(sea_vo, true)) {
						this.SetClickTarget(null)
						return
					}
				}

				if (mainrole_vo.ghost_mode == 1)
					// Message.show("您处于幽灵模式，不能进行采集！")
					return;
				let skill_id = skill_mgr.getCurrentSkillId();
				if (role.IsDead() || !skill_mgr.CanAttack(skill_id))
					return;
				if (!skill_mgr.IsInRigidity()) {
					// this.last_attack_time = local_Status.NowTime
					Global_Event_System.Fire(local_FightEvent.RELEASE_MAIN_SKILL, null, null, role.compress_id);
				}
			};
			let target_obj = role;
			if (this.attack_target_start_real_pos == null)
				this.attack_target_start_real_pos = new local_Vector2(this.main_role.real_pos.x, this.main_role.real_pos.y);
			else {
				this.attack_target_start_real_pos.x = this.main_role.real_pos.x;
				this.attack_target_start_real_pos.y = this.main_role.real_pos.y;
			}
			if (this.attack_target_end_real_pos == null)
				this.attack_target_end_real_pos = new local_Vector2(target_obj.x, target_obj.y);
			else {
				this.attack_target_end_real_pos.x = target_obj.real_pos.x;
				this.attack_target_end_real_pos.y = target_obj.real_pos.y;
			}
			let attack_range = skill_mgr.GetCurrentAttackRange();
			let distance = local_GameMath.GetDistance(this.attack_target_start_real_pos.x, this.attack_target_start_real_pos.y, this.attack_target_end_real_pos.x, this.attack_target_end_real_pos.y, false);
			if (distance <= attack_range * attack_range) {
				if (this.main_role.IsInState(local_PoseState.MOVE)) {
					this.main_role.SetDirection(this.attack_target_start_real_pos, this.attack_target_end_real_pos, true, true);
					this.main_role.DoStand();
				}
				action_func();
			}
			else if (this.main_role.CanMove()) {
				this.last_find_target_time = local_Status.NowTime;
				oper_mgr.StartTargetAction(role.compress_id, attack_range, action_func);
			}
		};
		this.IsSceneLoaded = () => {
			return this.scene_data_loaded;
		};
		//是否场景加载完毕
		this.IsSceneProloadFinish = () => {
			if (!this.scene_data_loaded || !this.preload_res_is_loaded) {
				return false;
			}
			return true;
		};
		//加载完场景格子资源
		this.SceneResLoadCompleted = () => {
			this.scene_res_loaded = true;
		};
		//加载完场景数据
		this.SceneDataLoadCompleted = (force) => {
			// if (force || !this.scene_data_loaded) {
			this.scene_data_loaded = true;
			this.SetEnterSceneFlag()

			main_camera.ResetSceneSize();
			let vo = mainrole_vo;
			let pos = this.main_role.GetRealPos()
			let dist = local_GameMath.GetDistance(vo.pos_x, vo.pos_y, pos.x, pos.y, true)
			if (!mapView.is_same_res_id || dist > 100) {
				this.main_role.SetRealPos(vo.pos_x, vo.pos_y, true);
				CameraManager.GetInstance().SetBaseScale(CameraManager.GetInstance().new_base_scale)
			}
			this.main_role.CreateFlower()
			vo.collect_state = 0
			this.main_role.SetFirstState()
			this.main_role.UpdateFlowerPos()

			//每次进场景重新设置一下技能
			// skill_mgr.Fire(SkillManager.UPDATE_SKILL_LIST)
			Global_Event_System.Fire(Event_Name.LOADMAP_COMPLETE, scene_mgr.GetSceneId());
			Global_Event_System.Fire(SceneEventType.REQUEST_SCENE_INFO);
		};
		//预加载成功
		this.PreLoadSceneObjResCompleted = () => {
			if (this.preload_sceneObjRes_is_loading) {
				this.preload_sceneObjRes_is_loading = null;
				// Global_Event_System.Fire(SceneEventType.REQUEST_SCENE_INFO)
				this.preload_res_is_loaded = true;
				load_progress_finished = true
			}
		};
		this.CheckToPreLoad = () => {
			this.scene_change_start_time = local_Status.NowTime;
			let scene_info = scene_mgr.GetSceneInfo();
			this.PreLoadSceneObjRes(scene_info);
			if (scene_info) {
				Global_Event_System.Fire(Event_Name.HIDE_RIGHT_TOP_ICON, scene_info.is_have_minimap != 1);
			}
		};
		this.PreLoadSceneObjRes = (scene_info) => {
			this.preload_sceneObjRes_is_loading = true;
			//场景需要预加载的技能
			this.PreLoadSceneObjResCompleted();
		};
		this.ClearSceneEffect = () => {
			for (let key in this.scene_effect_id_list) {
				if (this.scene_effect_id_list[key]) {
					particle_mgr.DelEffect(this.scene_effect_id_list[key]);
					delete this.scene_effect_id_list[key];
				}
			}
			this.scene_effect_id_list = {};
			if (this.scene_effect_list) {
				this.scene_effect_list.length = 0;
			}
		};
		let res_mgr = ResManager.GetInstance();
		this.ChangeScene = (sceneId) => {
			this.is_clearing = false;
			this.preload_res_is_loaded = false;
			this.scene_data_loaded = false;
			this.scene_res_loaded = false;
			this.manual_target = undefined
			load_progress_finished = false
			oper_mgr.ClearSrcOper();
			let load_tile_finish = (load_count, all_count) => {
				//console.log("load_count =" , load_count, all_count )
				if (load_count >= all_count) {
					this.SceneResLoadCompleted();
				}
				// this.LoadSceneEffect();
			};
			let load_map_default_res = () => {
			};
			let is_same_scene = scene_mgr.GetSceneId() == scene_mgr.last_scene_id
			let load_map_func = () => {
				// if(!is_same_scene){
				// 	scene_mgr.npc_doors_loaded = false
				// }
				let _scene_layer: Laya.Box = layer_mgr.GetUILayer(Enum_UILayer.Scene)
				_scene_layer.width = mapView.GetSceneWidth()
				_scene_layer.height = mapView.GetSceneHeight()
				scene_mgr.ClearAllVo(!is_same_scene);
				this.ClearScene();
				this.SceneDataLoadCompleted(is_same_scene);
			};
			mapView.UnRegiestEffectList(scene_mgr.last_scene_id)
			mapView.Load(sceneId, load_map_func, load_map_default_res, load_tile_finish);
			this.CheckToPreLoad()
		};
		this.DetectFirstUnblockPoint = (pos, dir, max_dist) => {
			return mapView.DetectFirstUnblockPoint(pos, dir, max_dist);
		};
		this.FindWay = (pos1_x, pos1_y, pos2_x, pos2_y, range) => {
			return mapView.FindWay(pos1_x, pos1_y, pos2_x, pos2_y, range);
		};
		this.IsStraightLine = (pos1, pos2) => {
			return mapView.IsStraightLine(pos1, pos2);
		};
		this.DetectLastUnblockPoint = (pos, dir, dist) => {
			return mapView.DetectLastUnblockPoint(pos, dir, dist);
		};
		// this.GetSceneCenterPos =(=>)
		// {
		// return mapView.GetSceneCenterPos()
		// }
		this.GetMapResID = (is_minimap) => {
			return mapView.GetResID(is_minimap);
		};
		// this.GetMapIDByScene =(scene_id,func=>)
		// {
		//	 mapView.GetResIDByScene(scene_id,func)
		// }
		this.SetDynamicArea = (area_id, area_type) => {
			mapView.SetDynamicArea(area_id, area_type);
		};
		this.SetMainRole = (main_role) => {
			this.main_role = main_role;
		};
		this.CompressObjId = (obj_type, obj_id) => {
			return obj_type + "_" + obj_id;
		};
		this.DecompressObjId = (val: string) => {
			let list = val.split("_");
			return list;
		};
		this.ClearScene = () => {
			this.is_clearing = true
			this._last_camera_pos.x = 0
			this._last_camera_pos.y = 0
			this.ClearSceneEffect()
			//清除所有粒子特效
			particle_mgr.DelAllEffects()

			if (res_mgr.preload_complete) {
				FightFontManager.GetInstance().ClearFontCache()
				FightFontManager.GetInstance().ClearNowShowFontDic()
			}
			this.SetClickTarget(null)
			EarlyWarningManager.GetInstance().DeleteAllWarning()
			this.drop_index_list = undefined
			//先清空所有对象列表 再执行DeleteMe 避免执行DeleteMe操作的过程中调用列表 导致vo为null
			let role_delete_list_proxy = this.role_list
			this.role_list = {}
			this.moving_obj_list.length = 0
			// scene_mgr.collecting = false
			let monster_delete_list_proxy = this.monster_list
			this.monster_list = {}

			let dead_body_delete_list_proxy = this.monster_dead_body_list
			this.monster_dead_body_list = {}

			for (let id in dead_body_delete_list_proxy)
				this.monster_pool.ReleaseObj(dead_body_delete_list_proxy[id])

			for (let id in role_delete_list_proxy) {
				this.role_pool.ReleaseObj(role_delete_list_proxy[id])
			}
			for (let id in monster_delete_list_proxy)
				this.monster_pool.ReleaseObj(monster_delete_list_proxy[id])

			let last_mainrole_id = RoleManager.GetInstance().mainRoleInfo.last_role_id
			let sprite_delete_list_proxy = this.sprite_list
			this.sprite_list = {}
			let main_sprite = this.main_role && this.main_role.sprite
			if (main_sprite) {
				delete sprite_delete_list_proxy[last_mainrole_id]
				delete sprite_delete_list_proxy[this.main_role.id]
				this.sprite_list[this.main_role.id] = main_sprite
			}

			let shengqi_delete_list_proxy = this.shengqi_list
			this.shengqi_list = {}
			let main_shengqi = this.main_role && this.main_role.shengqi
			if (main_shengqi) {
				delete shengqi_delete_list_proxy[last_mainrole_id]
				delete shengqi_delete_list_proxy[this.main_role.id]
				this.shengqi_list[this.main_role.id] = main_shengqi
			}

			let partner_delete_list_proxy = this.partner_list
			this.partner_list = {}
			let main_partner = this.main_role && this.main_role.partner
			if (main_partner) {
				delete partner_delete_list_proxy[last_mainrole_id]
				delete partner_delete_list_proxy[this.main_role.id]
				this.partner_list[this.main_role.id] = main_partner
			}

			let demon_delete_list_proxy = this.demon_list
			this.demon_list = {}
			let main_demon = this.main_role && this.main_role.demon
			if (main_demon) {
				delete demon_delete_list_proxy[last_mainrole_id]
				delete demon_delete_list_proxy[this.main_role.id]
				this.demon_list[this.main_role.id] = main_demon
			}

			let obj
			for (let id in sprite_delete_list_proxy) {
				this.sprite_pool.ReleaseObj(sprite_delete_list_proxy[id])
			}

			for (let id in demon_delete_list_proxy) {
				this.demon_pool.ReleaseObj(demon_delete_list_proxy[id])
			}

			for (let id in shengqi_delete_list_proxy) {
				this.shengqi_pool.ReleaseObj(shengqi_delete_list_proxy[id])
			}

			for (let id in partner_delete_list_proxy) {
				this.partner_pool.ReleaseObj(partner_delete_list_proxy[id])
			}

			let npc_delete_list_proxy = this.npc_list
			this.npc_list = {}
			let drop_delete_list_proxy = this.drop_list
			this.drop_list = {}
			let other_delete_list_proxy = this.other_list
			this.other_list = {}
			let door_delete_list_proxy = this.door_list
			this.door_list = {}
			let grave_delete_list_proxy = this.grave_list
			this.grave_list = {}

			for (let id in drop_delete_list_proxy)
				this.drop_pool.ReleaseObj(drop_delete_list_proxy[id])

			for (let id in npc_delete_list_proxy)
				this.npc_pool.ReleaseObj(npc_delete_list_proxy[id])

			for (let id in other_delete_list_proxy)
				this.other_pool.ReleaseObj(other_delete_list_proxy[id])

			for (let id in door_delete_list_proxy) {
				this.door_pool.ReleaseObj(door_delete_list_proxy[id])
			}
			for (let id in grave_delete_list_proxy) {
				this.grave_pool.ReleaseObj(grave_delete_list_proxy[id])
			}

			this.ClearMainRoleFindWayState()

			// if (this.is_first_clearing) {
			// 	res_mgr.GCRES(true)
			// 	this.is_first_clearing = false;
			// } else {
			// 	if (res_mgr.changeSceneClearRes) {
			// 		res_mgr.GCRES(true)
			// 	} else {
			if (!mapView.is_same_res_id) {
				res_mgr.ClearAllSprite3DPool()
				if (res_mgr.changeSceneClearRes)// || local_Status.NowTime - this.last_clear_scene_time > 1800)
				{
					// this.last_clear_scene_time = local_Status.NowTime
					res_mgr.GCRES(true)
				}
			}
			// res_mgr.DestoryResOnFrame(1)
			// 	}
			// }

			if (ResManager.SOURCE_TEXTGC && Laya.TextRender.textRenderInst) {
				ResManager.SOURCE_TEXTGC.call(Laya.TextRender.textRenderInst)
			}
			// res_mgr.DestroyUnusedResources()
			this.enable_click_screen = true;
		};

		this.GetObjByCompressedId = (compressed_id: string, can_get_dead_monster?) => {
			if (compressed_id == null)
				return null;
			// let [obj_types, obj_ids] = this.DecompressObjId(compressed_id)
			let index = compressed_id.indexOf("_");
			let obj_type = +compressed_id.substr(0, index);
			let obj_id = +compressed_id.substring(index + 1);
			// let [obj_types, obj_ids] = this.DecompressObjId(compressed_id)
			let obj = null;
			// let obj_type = Number(obj_types)
			// let obj_id = Number(obj_ids)
			// //怪
			switch (obj_type) {
				case scene_base_type.Monster:
					obj = this.GetMonster(obj_id);
					if (obj == null && can_get_dead_monster)
						obj = this.GetMonsterDeadBody(obj_id);
					break;
				case scene_base_type.Role:
				case scene_base_type.Fake_Role:
					obj = this.GetRole(obj_id);
					break;
				case scene_base_type.MainRole:
					obj = this.main_role;
					break;
				case scene_base_type.Demon:
					obj = this.GetDemon(obj_id);
					break;
				case scene_base_type.Sprite:
					obj = this.GetSprite(obj_id);
					break;
				case scene_base_type.Partner:
					obj = this.GetPartner(obj_id);
					break;
				case scene_base_type.Other:
					obj = this.GetOther(obj_id);
					break;
				case scene_base_type.Door:
					obj = this.GetDoor(obj_id);
					break;
				case scene_base_type.Drop:
					obj = this.GetDrop(obj_id);
					break;
				default:
					break;
			}
			return obj;
		};
		this.GetDoor = (id) => {
			return this.door_list[id];
		};
		this.GetNpc = (ins_id) => {
			return this.npc_list[ins_id];
		};
		this.GetMonster = (ins_id) => {
			return this.monster_list[ins_id];
		};
		this.GetMonsterByTypeId = (type_id) => {
			let monster_vo = scene_mgr.GetMonsterVoByTypeId(type_id);
			if (monster_vo)
				return this.GetMonster(monster_vo.instance_id);
		};
		this.GetSprite = (ins_id) => {
			return this.sprite_list[ins_id];
		};
		this.GetDemon = (ins_id) => {
			return this.demon_list[ins_id];
		};
		this.GetShengqi = (ins_id) => {
			return this.shengqi_list[ins_id];
		};
		this.GetPartner = (ins_id) => {
			return this.partner_list[ins_id];
		};
		this.GetOther = (ins_id) => {
			return this.other_list[ins_id];
		};
		this.GetDrop = (ins_id) => {
			return this.drop_list[ins_id];
		};
		this.GetSceneObj = (instance_id) => {
			let obj = this.GetMonster(instance_id) || this.GetRole(instance_id) || this.GetOther(instance_id);
			return obj;
		};
		this.GetMonsterList = () => {
			return this.monster_list;
		};
		this.GetRole = (role_id) => {
			if (role_id == role_mgr.GetMainRoleId())
				return this.GetMainRole();
			return this.role_list[role_id];
		};
		let local_MOVE_TYPE = MOVE_TYPE;
		this.RoleMove = (role_id, x, y, flag?, start_fly_x?, start_fly_y?) => {
			// //婚宴仪式动画中，人物不移动
			// if (SceneManager.GetInstance().IsWeddingScene()
			// 	&& (role_id == BanquetModel.GetInstance().GetGroomId() || role_id == BanquetModel.GetInstance().GetBrideId())) {
			// 	return
			// }
			flag = flag ? flag : 0;
			let role: Role = this.GetRole(role_id);
			if (role) {
				role.move_flag = flag;
				if (this.role_move_end_pos == null)
					this.role_move_end_pos = new local_Vector2(x, y);
				else {
					this.role_move_end_pos.x = x;
					this.role_move_end_pos.y = y;
				}
				// if (role.IsModelHiden()) {//} || role.CheckInScreen(false)) {
				if (flag == local_MOVE_TYPE.NORMOL_MOVE) //正常移动
					role.DoMove(this.role_move_end_pos);
				else if (flag == local_MOVE_TYPE.RUSH) //冲刺
					role.DoRush(this.role_move_end_pos);
				else if (flag == local_MOVE_TYPE.BLINK || flag == local_MOVE_TYPE.DOOR_JUMP) { //瞬移，
					role.SetRealPos(x, y);
					role.DoStand();
				}
				// }
				// else {
				// 	role.SetRealPos(x, y);
				// 	role.DoStand();
				// }
				// else
				// role:DoJump(this.role_move_end_pos)
				// end
				// role.GetVo().pos_x = this.role_move_end_pos.x
				// role.GetVo().pos_y = this.role_move_end_pos.y
			}
			else {
				let role_vo = scene_mgr.GetRoleVo(role_id);
				if (role_vo) {
					role_vo.pos_x = x;
					role_vo.pos_y = y;
				}
				else
					console.log("warning! can not find a role to handle move response!");
			}
		};
		this.MonsterMove = (instance_id, pos_x, pos_y, speedFlag?, endDirState?) => {
			speedFlag = speedFlag ? speedFlag : 0;
			let monster: Character = this.GetMonster(instance_id);
			if (monster != null) {
				if (this.monster_move_end_pos == null)
					this.monster_move_end_pos = new local_Vector2(pos_x, pos_y);
				else {
					this.monster_move_end_pos.x = pos_x;
					this.monster_move_end_pos.y = pos_y;
				}
				// if speedFlag == 1 then
				// 	monster:DoMoveBack(end_pos)
				// elseif speedFlag == 2 then
				// 	monster:DoSpeedMove(end_pos)
				// else
				// if (monster.visible || monster.CheckInScreen(false)) {
				monster.DoMove(this.monster_move_end_pos);
				// } else {
				//	 monster.SetRealPos(pos_x, pos_y)
				//	 monster.DoStand()
				// }
				// end
				//更新Vo数据
			}
			else {
				let monster_vo = scene_mgr.GetMonsterVo(instance_id);
				if (monster_vo) {
					monster_vo.pos_x = pos_x;
					monster_vo.pos_y = pos_y;
				}
			}
			this.lastMonsterMoveInsId = instance_id;
			this.lastMonsterMoveX = pos_x;
			this.lastMonsterMoveY = pos_y;
		};
		this.OtherMove = (instance_id, pos_x, pos_y, speedFlag?, endDirState?) => {
			speedFlag = speedFlag ? speedFlag : 0;
			let other = this.GetOther(instance_id);
			if (other != null) {
				if (this.other_move_end_pos == null)
					this.other_move_end_pos = new local_Vector2(pos_x, pos_y);
				else {
					this.other_move_end_pos.x = pos_x;
					this.other_move_end_pos.y = pos_y;
				}
				// let end_pos = new local_Vector2(pos_x, pos_y)
				other.DoMove(this.other_move_end_pos);
			}
		};
		this.NpcMove = (instance_id, pos_x, pos_y, dir?, dist?, speedFlag?, endDirState?) => {
			// speedFlag = speedFlag ? speedFlag : 0
			// let npc = this.GetNpc(instance_id)
			// if (npc != null)
			// {
			//	 let real_x = npc.x
			//	 let real_y = npc.y
			//	 if (local_GameMath.GetDistance(real_x, real_y, pos_x, pos_y, false) > dist * dist )
			//	 {
			//		 co.NormaliseXYTable(dir)
			//		 if (this.npc_move_end_pos == null)
			//			 this.npc_move_end_pos = new local_Vector2(pos_x + dir.x * (dist - 10), pos_y + dir.y * (dist - 10)
			//		 else
			//		 {
			//			 this.npc_move_end_pos.x = pos_x + dir.x * (dist - 10)
			//			 this.npc_move_end_pos.y = pos_y + dir.y * (dist - 10)
			//		 }
			//		 npc.DoMove(this.npc_move_end_pos)
			//	 }
			// }
		};
		this.CreateRole = (role_vo) => {
			let role_id = role_vo.role_id;
			if (role_id == role_mgr.GetMainRoleId()) {
				mainrole_vo.ChangeFromVo(role_vo);
				return;
			}
			let exist_role = this.role_list[role_id];
			if (exist_role) {
				Global_Event_System.Fire(Event_Name.EXECUTE_DELEY_FIGHT_INFO);
				this.DeleteRole(role_id);
			}
			let role: Role = this.role_pool.GetObjFreeList();
			if (role == null)
				role = new local_Role();
			// if (local_Util.TableSize(this.role_list) >= setting_mgr.GetBlockProperty(local_SettingType.SysSetting, "same_screen_role_num")) {
			// role.SetModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit, true)
			// }
			let curr_role_count = local_Util.TableSize(this.role_list)
			if (curr_role_count >= SettingModel.GetInstance().other_role_number) {
				role.SetModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit, true)
			}
			role.InitRoleVo(role_vo);
			role.LoadInfoFromVo();
			this.role_list[role_id] = role;
			return role;
		};
		this.CreateNpc = (npc_vo) => {
			let npc_exist = this.npc_list[Number(npc_vo.instance_id)]
			if (npc_exist == null) {
				let obj =
				{
					id: npc_vo.instance_id,
					type: local_SapManager.ObjType.NPC,
					pos: new local_Vector2(npc_vo.pos_x, npc_vo.pos_y),
					size: new local_Vector2(100, 160),
					data: npc_vo,
				}
				local_SapManager.GetInstance().RegisterObj(obj)
			} else {
				npc_exist.vo = npc_vo
				// npc_exist.SetCfgActionAndAngle()
				npc_exist.BindVoEvents()
				npc_exist.SetRealPos(npc_vo.pos_x, npc_vo.pos_y)

				// npc_exist.vo = npc_vo
				// npc_exist.SetCfgActionAndAngle()
				// npc_exist.BindVoEvents()
				// npc_exist.DoMove(new local_Vector2(npc_vo.pos_x, npc_vo.pos_y))
				// npc_exist.move_flag = MOVE_TYPE.NORMOL_MOVE
			}
		};
		this.CreateMonster = async (monster_vo) => {
			let monster = this.monster_list[monster_vo.instance_id];
			if (monster != null) {
				this.monster_pool.ReleaseObj(monster);
				delete this.monster_list[monster_vo.instance_id];
			}
			monster = this.monster_pool.GetObjFreeList();
			if (monster == null)
				monster = new local_Monster();
			monster.InitMonsterVo(monster_vo);
			this.monster_list[monster_vo.instance_id] = monster;
			monster.LoadInfoFromVo();
			if (this.is_hide_all_mon)
				monster.SetModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit, true);
			return monster;
		};
		this.CreateOther = (other_vo) => {
			// let other = this.other_list[other_vo.instance_id];
			// if (other != null) {
			//	 this.other_pool.ReleaseObj(other);
			//	 delete this.other_list[other_vo.instance_id];
			// }
			// other = this.other_pool.GetObjFreeList();
			// if (other == null)
			//	 other = new local_Other();
			// other.InitOtherVo(other_vo);
			// // other.LoadInfoFromVo()
			// this.other_list[other_vo.instance_id] = other;
			// return other;
		};
		this.CreateDrop = (drop_vo) => {
			// let drop: Drop = this.drop_list[drop_vo.drop_id];
			// if (drop != null) {
			// 	this.drop_pool.ReleaseObj(drop);
			// 	delete this.drop_list[drop_vo.drop_id];
			// }
			// drop = this.drop_pool.GetObjFreeList();
			// if (drop == null)
			// 	drop = new local_Drop();
			// drop.InitDropVo(drop_vo);
			// // drop.LoadInfoFromVo()
			// this.drop_list[drop_vo.drop_id] = drop;
			// // return drop;

			let obj =
			{
				id: drop_vo.drop_id,
				type: local_SapManager.ObjType.Drop,
				pos: new local_Vector2(drop_vo.pos_x, drop_vo.pos_y),
				size: new local_Vector2(100, 100),
				data: drop_vo,
			}
			local_SapManager.GetInstance().RegisterObj(obj)
			local_SapManager.GetInstance().RefreshView()
		};
		this.CreateSprite = (owner: Character) => {
			let sprite: Sprite = this.sprite_list[owner.id];
			if (sprite != null) {
				this.sprite_pool.ReleaseObj(sprite);
				delete this.sprite_list[owner.id];
			}
			sprite = this.sprite_pool.GetObjFreeList();
			if (sprite == null)
				sprite = new local_Sprite();
			let sprite_vo = new SpriteVo();
			sprite_vo.SetVo(owner.GetVo());
			if (owner.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit))
				sprite.SetModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole, true)
			sprite.InitSpriteVo(owner, sprite_vo);
			sprite.LoadInfoFromVo();
			this.sprite_list[owner.id] = sprite;
			return sprite;
		};
		this.DeleteSprite = (instance_id) => {
			let sprite = this.sprite_list[instance_id];
			if (sprite != null) {
				delete this.sprite_list[instance_id];
				this.sprite_pool.ReleaseObj(sprite);
			}
		};
		this.CreateShengqi = (owner) => {
			let shengqi: Shengqi = this.shengqi_list[owner.id];
			if (shengqi != null) {
				this.shengqi_pool.ReleaseObj(shengqi);
				delete this.shengqi_list[owner.id];
			}
			shengqi = this.shengqi_pool.GetObjFreeList();
			if (shengqi == null)
				shengqi = new Shengqi();
			let shengqi_vo = new ShengqiVo();
			shengqi_vo.SetVo(owner.GetVo());
			if (owner.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit))
				shengqi.SetModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole, true)
			shengqi.InitShengqiVo(owner, shengqi_vo);
			shengqi.LoadInfoFromVo();
			this.shengqi_list[owner.id] = shengqi;
			return shengqi;
		};
		this.DeleteShengqi = (instance_id) => {
			let shengqi = this.shengqi_list[instance_id];
			if (shengqi != null) {
				delete this.shengqi_list[instance_id];
				this.shengqi_pool.ReleaseObj(shengqi);
			}
		};
		this.CreatePartner = (owner) => {
			let partner: Partner = this.partner_list[owner.id];
			if (partner != null) {
				this.partner_pool.ReleaseObj(partner);
				delete this.partner_list[owner.id];
			}
			partner = this.partner_pool.GetObjFreeList();
			if (partner == null)
				partner = new local_Partner();
			let partner_vo = new PartnerVo();
			partner_vo.SetVo(owner.GetVo());
			if (owner.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit))
				partner.SetModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole, true)
			partner.InitPartnerVo(owner, partner_vo);
			partner.LoadInfoFromVo();
			this.partner_list[owner.id] = partner;
			return partner;
		};
		this.DeletePartner = (instance_id) => {
			let partner = this.partner_list[instance_id];
			if (partner != null) {
				delete this.partner_list[instance_id];
				this.partner_pool.ReleaseObj(partner);
			}
		};
		this.CreateDemon = (owner) => {
			let demon: Demon = this.demon_list[owner.id];
			if (demon != null) {
				this.demon_pool.ReleaseObj(demon);
				delete this.demon_list[owner.id];
			}
			demon = this.demon_pool.GetObjFreeList();
			if (demon == null)
				demon = new Demon();
			let demon_vo: DemonVo = new DemonVo();
			demon_vo.SetVo(owner.GetVo());
			if (owner.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit))
				demon.SetModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole, true)
			demon.InitDemonVo(owner, demon_vo);
			demon.LoadInfoFromVo();
			this.demon_list[owner.id] = demon;
			return demon;
		};
		this.DeleteDemon = (instance_id) => {
			let demon = this.demon_list[instance_id];
			if (demon != null) {
				delete this.demon_list[instance_id];
				this.demon_pool.ReleaseObj(demon);
			}
		};
		this.DeleteRole = (role_id) => {
			let obj = this.role_list[role_id];
			if (obj != null) {
				if (obj == this.main_role)
					return;
				//删除该对象的闭包函数
				let del_role_func = () => {
					delete this.role_list[role_id];
					this.role_pool.ReleaseObj(obj);
					if (obj == this.curr_click_target) {
						this.CancelClickTarget()
					}
				};
				if (this.is_in_update)
					//更新过程中延时删除
					this.delay_handle_funcs.push(del_role_func);
				else
					//直接删除对象
					del_role_func();
			}
		};
		this.GetMonsterDeadBody = (instance_id) => {
			let monster;
			for (let id in this.monster_dead_body_list) {
				monster = this.monster_dead_body_list[id];
				if (monster.id == instance_id)
					return monster;
			}
			return null;
		};
		this.DeleteMonster = (instance_id) => {
			let monster = this.monster_list[instance_id];
			if (monster != null) {
				delete this.monster_list[instance_id];
				//把怪物尸体放到另一个队列里
				this.dead_body_count = this.dead_body_count + 1;
				this.monster_dead_body_list[this.dead_body_count] = monster;
				monster.SetDeadBodyID(this.dead_body_count);
				//如果不是死亡时的删除，要让怪物Fade渐隐
				if (!monster.IsDead()) {
					let dead_body_id = this.dead_body_count;
					this.DeleteDeadBody(dead_body_id);
				}
				if (monster == this.curr_click_target) {
					this.CancelClickTarget()
				}
			}
		};
		this.DeleteOther = (instance_id) => {
			let other = this.other_list[instance_id];
			if (other != null) {
				delete this.other_list[instance_id];
				this.other_pool.ReleaseObj(other);
			}
		};
		this.DeleteDrop = (instance_id) => {
			local_SapManager.GetInstance().UnRegisterObj(local_SapManager.ObjType.Drop, instance_id)
			local_SapManager.GetInstance().RefreshView()
		};
		//删除怪物尸体
		this.DeleteDeadBody = (dead_body_id) => {
			let obj = this.monster_dead_body_list[dead_body_id];
			if (obj) {
				this.monster_pool.ReleaseObj(obj);
				delete this.monster_dead_body_list[dead_body_id];
			}
		};
		this.DeleteDoor = (id) => {
			local_SapManager.GetInstance().UnRegisterObj(local_SapManager.ObjType.Door, id)
		};
		this.DeleteJumpPoint = (id) => {
			local_SapManager.GetInstance().UnRegisterObj(local_SapManager.ObjType.JumpPoint, id)
		};
		this.DeleteNpc = (npc_id) => {
			local_SapManager.GetInstance().UnRegisterObj(local_SapManager.ObjType.NPC, npc_id)
		};
		this.CreateDoor = (door_vo) => {

			// let id = `${door_vo.enter_scene_id}-${door_vo.id}`
			// let id = door_vo.enter_scene_id
			// if (door_vo.is_same_scene) {
			// 	id = `${door_vo.enter_scene_id}-${door_vo.index}`

			// }
			let obj =
			{
				id: door_vo.id,
				type: local_SapManager.ObjType.Door,
				pos: new local_Vector2(door_vo.pixel_x, door_vo.pixel_y),
				size: new local_Vector2(100, 100),
				data: door_vo,
			}
			local_SapManager.GetInstance().RegisterObj(obj)
		};
		this.CreateJumpPoint = (jumppoint_vo) => {
			let obj =
			{
				id: jumppoint_vo.instance_id,
				type: local_SapManager.ObjType.JumpPoint,
				pos: new local_Vector2(jumppoint_vo.real_pos.x, jumppoint_vo.real_pos.y),
				size: new local_Vector2(100, 100),
				data: jumppoint_vo,
			}
			local_SapManager.GetInstance().RegisterObj(obj)
		};
		this.UpdateAllMonsterVisible = () => {
			let mon;
			for (let id in this.monster_list) {
				mon = this.monster_list[id];
				if (this.is_hide_all_mon) {
					if (!mon.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit))
						mon.SetModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit, true);
				}
				else {
					if (mon.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit))
						mon.SetModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit, false);
				}
			}
		};
		this.GetExitByPoint = (pos: Vector2) => {
			let door
			for (let i in this.door_list) {
				let door_pos = door.GetLogicPos()
				if (local_GameMath.IsPointNear(pos.x, pos.y, door_pos.x, door_pos.y, 2))
					return door
			}
			return null;
		};
		this.RoleWalkCompleteHandler = (not_fire_move_end) => {
			if (this.is_clearing) //正在清理场景或者主角被锁定动作状态不能处理走完动作
				return;
			this.clearGoToData()
			if (!not_fire_move_end) {
				Global_Event_System.Fire(SceneEventType.MAIN_ROLE_MOVE_END)
			}

			// //传送点
			// let now_oper = oper_mgr.GetNowSrcOper();
			// if (!now_oper || (!now_oper.now_use_pair && !now_oper.total_pair)
			// 	|| (now_oper.now_use_pair && now_oper.total_pair && now_oper.now_use_pair > now_oper.total_pair)) {
			// 	if (!this.goToFunc) {
			// 		this.clearGoToData();
			// 	}
			// 	let door = this.GetExitByPoint(this.main_role.GetLogicPos());
			// 	if (door) {
			// 		let scene_door_callback = () => {
			// 			Global_Event_System.Fire(local_SceneEventType.REQUEST_CHANGE_SCENE, door.GetVo().enter_scene_id);
			// 			this.change_scene_request_time = local_Status.NowTime;
			// 		};
			// 		if (this.change_scene_request_time == null)
			// 			scene_door_callback();
			// 		else if (local_Status.NowTime - this.change_scene_request_time > 1.5)
			// 			scene_door_callback();
			// 	}
			// }
		};
		this.UpdateRoleVisibleState = (force_to_check) => {
			let now_time = local_Status.NowTime;
			if (!this.check_visible_role_num_time || now_time - this.check_visible_role_num_time > 4 || force_to_check) {
				this.check_visible_role_num_time = now_time;
				//设置的同屏玩家数量
				let player_limit_setting_count = SettingModel.GetInstance().other_role_number,
					//当前已经显示的玩家数量
					curr_show_player_count = 0,
					//其他玩家的显示数量
					other_player_show_count = player_limit_setting_count, mainRole_defender_list;
				if (other_player_show_count > 0) {
					let vo;
					for (let id in scene_mgr.mainRole_defender_list) {
						vo = scene_mgr.mainRole_defender_list[id];
						if (now_time - vo.start_time < 5 && this.GetRole(id)) {
							mainRole_defender_list = mainRole_defender_list || {};
							mainRole_defender_list[id] = true;
							other_player_show_count = other_player_show_count - 1;
						}
					}
				}
				let mainRole_attacker_list;
				// let mainRole_attacker_count = other_player_show_count;
				if (other_player_show_count > 0) {
					let vo;
					for (let id in scene_mgr.mainRole_attacker_list) {
						vo = scene_mgr.mainRole_attacker_list[id];
						if (now_time - vo.start_time < 5 && this.GetRole(id) && (!mainRole_defender_list || !mainRole_defender_list[id])) {
							mainRole_attacker_list = mainRole_attacker_list || {};
							mainRole_attacker_list[id] = true;
							other_player_show_count = other_player_show_count - 1;
						}
					}
				}
				let invisible_list;
				let _role;
				for (let id in this.role_list) {
					_role = this.role_list[id];
					if (_role != this.main_role && (!_role.HasModelHideFlag() || _role.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit))) { //除了人数限制的隐藏 其他情况的隐藏不受控制
						let x1 = _role.x
						let y1 = _role.y
						let x2 = this.main_role.real_pos.x
						let y2 = this.main_role.real_pos.y
						let power_dist = local_GameMath.GetDistance(x1, y1, x2, y2, false);
						_role.dist_to_main_role = power_dist;
						invisible_list = invisible_list || [];
						invisible_list.push(_role);
					}
				}
				if (invisible_list) {
					let sort_func = (a, b) => {
						return a.dist_to_main_role < b.dist_to_main_role;
					};
					invisible_list.sort(sort_func);
					let need_show = false;
					for (let i = 0; i < invisible_list.length; i++) {
						let role = invisible_list[i];
						if (player_limit_setting_count > curr_show_player_count) {
							if (mainRole_defender_list && mainRole_defender_list[role.id]) {
								need_show = true;
							}
							else if (mainRole_attacker_list && mainRole_attacker_list[role.id]) {
								need_show = true;
							}
							else if (other_player_show_count > 0) {
								other_player_show_count = other_player_show_count - 1;
								need_show = true;
							}
							else {
								need_show = false;
							}
						}
						else {
							need_show = false;
						}
						if (need_show) {
							//需要渲染的人放进渲染列表
							if (role.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit)) {
								role.SetModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit, false);
							}
							curr_show_player_count = curr_show_player_count + 1;
						}
						else {
							if (!role.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit)) {
								role.SetModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit, true);
							}
						}
					}
				}
			}
		};

		this.FindTargetDir = (range, attacker?, select_type?, hiter_pos_type?) => {
			attacker = attacker ? attacker : this.main_role
			let range_pow = range ? (range * range) : null,
				mon_min_dist_tar = null,
				mon_min_dist_pow = 100000000,
				role_min_dist_tar = null,
				role_min_dist_pow = 100000000,
				x1 = attacker.x,
				y1 = attacker.y,
				war_group1 = attacker.GetVo().warGroup,
				at = attacker.GetType()


			let checkMonster = () => {
				let mon_vo = null
				let mon
				for (let id in this.monster_list) {
					mon = this.monster_list[id]
					//第一遍不包含特殊怪物时，特殊怪物就存到另外的表里
					mon_vo = mon.GetVo()
					if (mon_vo) {
						let war_group2 = mon_vo.warGroup,
							diff_group = (war_group1 == 0 || war_group2 == 0 || war_group2 != war_group1),
							hp_ok = (mon.vo && mon.vo.hp > 0),
							x2 = mon.x,
							y2 = mon.y,
							local_MonsterType = MonsterType
						if (
							!mon.IsDead()
							&& hp_ok
							&& diff_group
							&& mon_vo.can_attack == 1
							&& mon_vo.guaji_flag == 0
							&& mon_vo.type != local_MonsterType.COLLECT
							&& mon_vo.type != local_MonsterType.TASK_COLLECT && mon_vo.type != local_MonsterType.PICK
							&& mon_vo.type != local_MonsterType.INFINITE_COLLECT
							&& !mon.HasModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide)) {
							let dist_pow = local_GameMath.GetDistance(x1, y1, x2, y2, false)
							if (range_pow == null || range_pow >= dist_pow) {
								if (dist_pow < mon_min_dist_pow) {
									mon_min_dist_pow = dist_pow
									mon_min_dist_tar = mon
								}
							}
						}
					}
				}
				return [mon_min_dist_tar, mon_min_dist_pow]
			}
			let checkRole = () => {
				if (scene_mgr.IsPKScene()) {
					let role
					let attacker_vo = null
					for (let id in this.role_list) {
						role = this.role_list[id]
						let vo = role.GetVo()
						if (vo) {
							let war_group2 = vo.warGroup
							let same_group = war_group2 == war_group1 && war_group1 > 0
							let canpkByPkStatus = true
							if (select_type == 3) {//最近队友 辅助技能给自己队友加属性
								if (attacker_vo.team_id == vo.team_id && attacker_vo.team_id > 0)
									same_group = false
								else
									same_group = true
							}
							else if (war_group1 == 0 && war_group2 == 0) {
								canpkByPkStatus = scene_mgr.CanPKByPKStatus(attacker.vo, vo)
							}
							let x2, y2 = role.GetRealPos()
							if (hiter_pos_type == 1) // 腰部
								y2 = y2 + role.GetBodyHeight() * 0.5
							else if (hiter_pos_type == 2)
								y2 = y2 + role.GetBodyHeight()

							if (
								role != attacker
								&& canpkByPkStatus
								&& !same_group
								&& !role.IsDead()
								&& !role.buff_manager.hasUnbeatableBuff() && role.id != attacker.id
								&& !scene_mgr.IsSafeArea(null, x2, y2) && !role.HasModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide)) {
								// let dist_pow = local_GameMath.GetEllipseDistance(x1, y1, x2, y2, false)
								// if(range_pow == null || range_pow >= dist_pow){
								// 	if(dist_pow < role_min_dist_pow){
								// 		role_min_dist_pow = dist_pow
								// 		role_min_dist_tar = role
								// 	}
								// }
							}
						}
					}
					return [role_min_dist_tar, role_min_dist_pow]
				}
			}
		}

		//总的选择目标方法
		this.FindTargets = (find_type, find_number, distance, area, find_dir, find_radian, center_pos, attacker?, movie_cfg?, select_type?, is_auto_select?, contain_collect_type?) => {
			if (attack_type_monster == find_type) {
				let ret = this.FindMonsters(find_number, distance, area, find_dir, find_radian, center_pos, attacker, movie_cfg, select_type, null, is_auto_select, contain_collect_type);
				return ret;
			}
			else if (attack_type_role == find_type) {
				let ret = this.FindRoles(find_number, distance, area, find_dir, find_radian, center_pos, attacker, movie_cfg, select_type, null, is_auto_select);
				return ret;
			}
			else if (attack_type_all == find_type) {
				// let [monster_list, left_num] = this.FindMonsters(find_number, distance, area, find_dir, find_radian, center_pos, attacker, movie_cfg, select_type)
				// if (left_num > 0) {
				//	 let [role_list, number] = this.FindRoles(left_num, distance, area, find_dir, find_radian, center_pos, attacker, movie_cfg, select_type)
				//	 return [monster_list, role_list]
				// }
				// return [monster_list, null]
				let final_monster_list: Array<any> = []
				let final_role_list: Array<any> = []
				let monster_list = this.FindMonsters(find_number, distance, area, find_dir, find_radian, center_pos, attacker, movie_cfg, select_type, true, is_auto_select, contain_collect_type);
				let role_list = this.FindRoles(find_number, distance, area, find_dir, find_radian, center_pos, attacker, movie_cfg, select_type, true, is_auto_select);
				let curr_monster_index = 0;
				let curr_role_index = 0;
				let curr_mon;
				let curr_role;
				for (let i = 0; i < find_number; i++) {
					curr_mon = monster_list[curr_monster_index];
					curr_role = role_list[curr_role_index];
					if (curr_mon && curr_role) {
						if (curr_mon[1] < curr_role[1]) {
							final_monster_list = final_monster_list || [];
							final_monster_list.push(curr_mon[0]);
							curr_monster_index++;
						}
						else {
							final_role_list = final_role_list || [];
							final_role_list.push(curr_role[0]);
							curr_role_index++;
						}
					}
					else if (curr_mon) {
						final_monster_list = final_monster_list || [];
						final_monster_list.push(curr_mon[0]);
						curr_monster_index++;
					}
					else if (curr_role) {
						final_role_list = final_role_list || [];
						final_role_list.push(curr_role[0]);
						curr_role_index++;
					}
					else {
						break;
					}
				}
				return [final_monster_list, final_role_list];
			}
		};


		//根据条件检索出符合条件的怪物列表
		//@n. 			怪物数量，默认为1
		//@distance. 		检索距离 用于直线表示直线的长度
		//@area. 		检索范围半径，默认为无限，即全图范围
		//@find_dir. 	检索方向
		//@find_radian. 	检索角度 用于扇形
		//@center_pos. 	检索范围的中心坐标点，默认为主角坐标
		//@include_dist. 	返回的参数 是否包含距离
		//@is_auto_select 是否是自动挂机选中
		//@contain_collect_type 判断是否包含采集类型

		this.FindMonsters = (n, distance, area, find_dir, find_radian, center_pos, attacker1?, movie_cfg?, select_type?, include_dist?, is_auto_select?, contain_collect_type?) => {
			if (scene_mgr.IsSafeScene()) {
				if (include_dist) {
					return [];
				}
				else {
					return [[], n];
				}
			}
			if (n == 0) {
				if (include_dist) {
					return [];
				}
				else {
					return [[], n];
				}
			}
			let attacker: Character = attacker1 || this.main_role;
			if (!attacker || !attacker.GetVo()) {
				return [[], n];
			}

			let area_pw = area ? (area * area) : null,
				war_group1 = attacker.GetVo().warGroup,
				dot_min = find_radian ? local_Math.cos(find_radian / 2) : null, //左右各一半角度的cos值(dot值)
				scene_base_type = SceneBaseType,
				at = attacker.GetType(),
				guild_id1 = attacker.GetVo().guild_id

			if (attacker.GetType() == scene_base_type.Partner && attacker["owner"]) {
				attacker = attacker["owner"]
				war_group1 = attacker.GetVo().warGroup
			}

			let x1 = attacker.real_pos.x
			let y1 = attacker.real_pos.y
			let my_dir: Vector2 = find_dir ? find_dir : attacker.GetDirection()
			let ret = []
			//把所有在距离内的、角度范围内的怪物找出来
			let monster
			let vo
			let local_GameMath = GameMath;
			if (center_pos != null) {
				x1 = center_pos.x;
				y1 = center_pos.y;
			}
			if (my_dir)
				my_dir.normalise();

			let can_select
			for (let id in this.monster_list) {
				monster = this.monster_list[id];
				vo = monster.GetVo();
				if (vo) {


					let war_group2 = vo.warGroup,
						same_group = (at == scene_base_type.Role || at == scene_base_type.MainRole) && war_group2 == war_group1 && war_group1 > 0,
						x2 = monster.x, y2 = monster.y,
						guild_id2 = vo.guild_id,
						same_guild = (at == scene_base_type.Role || at == scene_base_type.MainRole) && guild_id2 == guild_id1 && guild_id1 > 0;

					if (monster != attacker
						&& scene_mgr.MonsterIsCanBeAttack(vo, same_group, same_guild, null, contain_collect_type)
						&& (!is_auto_select || !monster.HasModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide))
					) {
						can_select = true

						if (can_select) {
							let dist_pw = local_GameMath.GetDistance(x1, y1, x2, y2, false);

							//直线和扇形如果距离在100像素之内，就忽略距离判断和角度判断
							if (dist_pw <= 10000) {
								ret.push([monster, dist_pw]);
							}
							//进行角度范围判定  攻击距离为半径，攻击范围为角度的扇形
							else if (dot_min != null) {
								if (this.find_target_dir == null)
									this.find_target_dir = new local_Vector2(x2 - x1, y2 - y1);
								else {
									this.find_target_dir.x = x2 - x1;
									this.find_target_dir.y = y2 - y1;
								}
								this.find_target_dir.normalise();
								let dot = my_dir.dotProduct(this.find_target_dir); //a·b=|a||b|·cosθ
								if (dot >= dot_min)
									if (dist_pw <= distance * distance)
										ret.push([monster, dist_pw]);
							}
							//进行直线范围判定(要算dot值判断是否在前方)  攻击距离为长，攻击范围为宽的长方形
							else if (distance && area) {
								if (dist_pw <= (distance * distance)) {
									if (this.find_target_dir == null)
										this.find_target_dir = new local_Vector2(x2 - x1, y2 - y1);
									else {
										this.find_target_dir.x = x2 - x1;
										this.find_target_dir.y = y2 - y1;
									}
									this.find_target_dir.normalise();
									let dot = my_dir.dotProduct(this.find_target_dir);
									if (dot > 0) //在前方再详细算距离
									{
										let relate_pos = { x: x2 - x1, y: y2 - y1 };
										let d = local_GameMath.DistancePointToLine(my_dir, relate_pos, false);
										let curr_area = area * 0.5;
										if (d <= curr_area * curr_area)
											ret.push([monster, dist_pw]);
									}
								}
							}
							//进行圆形范围判定
							else if (area_pw == null || dist_pw <= area_pw) {
								ret.push([monster, dist_pw]);
							}
						}
					}
				}
			}

			//对所有范围内的怪物按距离排序
			let sort_func = (t1, t2) => {
				if (t1[1] > t2[1])
					return 1;
				else if (t1[1] == t2[1])
					return 0;
				else
					return -1;
			}
			ret.sort(sort_func);

			if (include_dist) {
				return ret;
			}
			else {
				let res = [];
				let left_num = n;
				for (let i = 0; i < n; i++) {
					let t = ret[i];
					if (t == null)
						break;
					else {
						res.push(t[0]);
						left_num = left_num - 1;
					}
				}
				return [res, left_num];
			}
		}


		//根据条件检索出符合条件的玩家列表
		//@n. 			玩家数量，默认为1
		//@distance. 		检索距离 用于直线表示直线的长度
		//@area. 		检索范围半径，默认为无限，即全图范围
		//@find_dir. 	检索方向
		//@find_radian. 	检索角度 用于扇形
		//@center_pos. 	检索范围的中心坐标点，默认为主角坐标
		//@movie_cfg   客户端技能配置
		//@select_type   目标选取类型 3最近队友
		//@include_dist. 	返回的参数 是否包含距离
		//@is_auto_select 是否是自动挂机的选中
		this.FindRoles = (n, distance, area, find_dir, find_radian, center_pos, attacker1?, movie_cfg?, select_type?, include_dist?, is_auto_select?) => {

			if (!scene_mgr.IsPKScene()) {
				if (include_dist) {
					return [];
				}
				else {
					return [[], n];
				}
			}

			if (n == 0) {
				if (include_dist) {
					return [];
				}
				else {
					return [null, 0];
				}
			}

			let attacker: Character = attacker1 || this.main_role;
			if (!attacker || !attacker.GetVo()) {
				return [[], n];
			}
			let attacker_vo = attacker.GetVo(),
				area_pw = area ? (area * area) : null,
				war_group1 = attacker_vo.warGroup,
				dot_min = find_radian ? local_Math.cos(find_radian / 2) : null, //左右各一半角度的cos值(dot值)
				scene_base_type = SceneBaseType,
				at = attacker.GetType(),
				x1 = attacker.real_pos.x,
				y1 = attacker.real_pos.y,
				my_dir: Vector2 = find_dir ? find_dir : attacker.GetDirection(),
				ret = [],
				//把所有在距离内的、角度范围内的怪物找出来
				role,
				vo,
				local_GameMath = GameMath,
				can_select

			if (attacker.GetType() == scene_base_type.Partner && attacker["owner"]) {
				attacker = attacker["owner"]
				war_group1 = attacker.GetVo().warGroup
			}

			if (center_pos != null) {
				x1 = center_pos.x;
				y1 = center_pos.y;
			}

			if (my_dir)
				my_dir.normalise();

			for (let role_id in this.role_list) {
				role = this.role_list[role_id]
				vo = role.GetVo()
				if (vo) {
					let war_group2 = vo.warGroup,
						same_group = war_group2 == war_group1 && war_group1 > 0,
						canpkByPkStatus = true,
						x2 = role.x,
						y2 = role.y

					if (select_type == 3) //最近队友 辅助技能给自己队友加属性
					{
						if (attacker_vo.team_id == vo.team_id && attacker_vo.team_id > 0) {
							same_group = false
						}
						else {
							same_group = true
						}
					}
					else if (war_group1 == 0 && war_group2 == 0) {
						canpkByPkStatus = scene_mgr.CanPKByPKStatus(attacker.vo, vo)
					}


					if (
						(
							!same_group
							&& canpkByPkStatus
							&& !role.IsDead()
							&& !scene_mgr.IsSafeArea(null, x2, y2)
							&& !vo.is_virtual_role
							&& (!is_auto_select || !role.HasModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide))
							&& !scene_mgr.IsSeaHegemonyScene()
						) || (
							same_group
							&& scene_mgr.IsSeaHegemonyScene()
							&& !role.IsDead()
							&& !scene_mgr.IsSafeArea(null, x2, y2)
						)
					) {

						can_select = true
						if (can_select) {
							//计算距离(因为结果要按距离排序，所以必须要算)
							let dist_pw = local_GameMath.GetDistance(x1, y1, x2, y2, false);
							//直线和扇形如果距离在100像素之内，就忽略距离判断和角度判断
							if (dist_pw <= 10000) {
								ret.push([role, dist_pw]);
							}
							//进行角度范围判定  攻击距离为半径，攻击范围为角度的扇形
							else if (dot_min != null) {
								if (this.find_target_dir == null)
									this.find_target_dir = new local_Vector2(x2 - x1, y2 - y1);
								else {
									this.find_target_dir.x = x2 - x1;
									this.find_target_dir.y = y2 - y1;
								}
								this.find_target_dir.normalise();
								let dot = my_dir.dotProduct(this.find_target_dir); //a·b=|a||b|·cosθ
								if (dot >= dot_min)
									if (dist_pw <= distance * distance)
										ret.push([role, dist_pw]);
							}
							//进行直线范围判定(要算dot值判断是否在前方)  攻击距离为长，攻击范围为宽的长方形
							else if (distance && area) {
								if (dist_pw <= (distance * distance)) {
									if (this.find_target_dir == null)
										this.find_target_dir = new local_Vector2(x2 - x1, y2 - y1);
									else {
										this.find_target_dir.x = x2 - x1;
										this.find_target_dir.y = y2 - y1;
									}
									this.find_target_dir.normalise();
									let dot = my_dir.dotProduct(this.find_target_dir);
									if (dot > 0) //在前方再详细算距离
									{
										let relate_pos = { x: x2 - x1, y: y2 - y1 };
										let d = local_GameMath.DistancePointToLine(my_dir, relate_pos, false);
										let curr_area = area * 0.5;
										if (d <= curr_area * curr_area)
											ret.push([role, dist_pw]);
									}
								}
							}
							//进行圆形范围判定
							else if (area_pw == null || dist_pw <= area_pw) {
								ret.push([role, dist_pw]);
							}
						}

					}
				}
			}
			//对所有范围内的怪物按距离排序
			let sort_func = (t1, t2) => {
				if (t1[1] > t2[1])
					return 1;
				else if (t1[1] == t2[1])
					return 0;
				else
					return -1;
			};
			ret.sort(sort_func);
			if (include_dist) {
				return ret;
			}
			else {
				let res = [];
				let left_num = n;
				for (let i = 0; i < n; i++) {
					let t = ret[i];
					if (t == null)
						break;
					else {
						res.push(t[0]);
						left_num = left_num - 1;
					}
				}
				return [res, left_num];
			}
		};
		//检测帧频，是否弹出极简模式弹窗
		this.ShouldShowFrameRateAlert = () => {
			// if ((!this.last_check_framerate_time || local_Status.NowTime - this.last_check_framerate_time > 10) && !this.not_check_framerate
			if (!this.not_check_framerate
				&& !this.showing_frameraet_alert) {
				let rate = Runner.GetInstance().frmaerate;
				let is_simple_mode = 0;
				if (is_simple_mode == 0 && rate < 20) {
					++this.repeat_times;
					if (this.repeat_times >= 2) {
						this.repeat_times = 0;
						this.showing_frameraet_alert = true;
						let ok_func = () => {
							// this.last_check_framerate_time = local_Status.NowTime
							this.showing_frameraet_alert = false;
							let cfg = Config_PRELOAD_CLIENT_CONFIG.ClientBlockConfig;
							if (!cfg)
								return;
							let value;
							for (let key in cfg.SimpleMode) {
								value = cfg.SimpleMode[key];
								// setting_mgr.Fire(SettingEvent.SETTING_REQUEST_PROTO, 10203, "ccc", local_SettingType.SysSetting, cfg.BlockSubType[key], value)
							}
						};
						let cancle_fun = () => {
							this.showing_frameraet_alert = false;
							// this.last_check_framerate_time = local_Status.NowTime
						};
						this.not_check_framerate = true
						// let check_func = (bool) => {
						// 	this.not_check_framerate = bool;
						// };
						// let str = `检测到您当前的帧数较低，建议您采用<font color='#639c12'>极简模式</font>`;
						// let content = str
						// Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, cancle_fun, "确定", "取消", undefined, false, check_func, "本次登录不再提示");
					}
					else {
						// this.last_check_framerate_time = local_Status.NowTime
					}
				}
				else {
					// this.last_check_framerate_time = local_Status.NowTime
					this.showing_frameraet_alert = false;
					this.repeat_times = 0;
				}
			}
		};
		this.RoleOtherProChange = (role_id, list) => {
			let roleVo = scene_mgr.GetRoleVo(role_id);
			if (roleVo) {
				for (let vo of list) {
					if (vo.style == 6) {
						roleVo.ChangeVar("god_id", vo.value);
					} else if (vo.style == 7) {
						roleVo.ChangeVar("revelation_suit", vo.value);
					} else if (vo.style == 8) {
						roleVo.ChangeVar("demon_id", vo.value);
					} else if (vo.style == 9) {
						roleVo.ChangeVar("medal_id", vo.value);
					} else if (vo.style == 10) {
						roleVo.ChangeVar("supreme_vip", vo.value);
					} else if (vo.style == 11) {
						roleVo.ChangeVar("invincible_end_time", vo.value);
					} else if (vo.style == 12) {
						roleVo.ChangeVar("title_id", vo.value);
					} else if (vo.style == 13) {
						roleVo.ChangeVar("mask_id", vo.value);
					} else if (vo.style == 14) {
						roleVo.ChangeVar("brick_id", vo.value);
					} else if (vo.style == 15) {
						roleVo.ChangeVar("suit_fashion_id", vo.value);
					} else if (vo.style == 16) {
						roleVo.ChangeVar("collect_state", vo.value);
					}
				}
			}
		};
		this.FindNearestMonsters = (mon_id, find_can_attack?, pos_x?, pos_y?, check_block?) => {
			let ret = [];
			let monster;
			let real_x;
			let real_y;
			if (pos_x && pos_y) {
				real_x = pos_x * LogicRealRatio_X;
				real_y = pos_y * LogicRealRatio_Y;
			}
			//把所有在距离内的、角度范围内的怪物找出来
			let x1;
			let y1;
			for (let id in this.monster_list) {
				monster = this.monster_list[id];
				if (monster.vo && monster.vo.type_id == mon_id && !monster.IsDead() && (!find_can_attack || scene_mgr.IsCanAttackByMainRole(monster.GetVo(), true))) {
					let real_pos = monster.GetRealPos();
					x1 = real_pos.x;
					y1 = real_pos.y;
					if (!check_block || !scene_mgr.IsBlockXY(x1 / LogicRealRatio_X, y1 / LogicRealRatio_Y)) {
						let real_pos2 = this.main_role.GetRealPos();
						if (real_x || real_y) {
							x1 = real_x;
							y1 = real_y;
						}
						let dist_pw = local_GameMath.GetDistance(x1, y1, real_pos2.x, real_pos2.y, false);
						ret.push([monster, dist_pw]);
					}
				}
			}
			//对所有范围内的怪物按距离排序
			if (ret.length > 0) {
				let sort_func = (t1, t2) => {
					return t1[1] - t2[1];
				};
				ret.sort(sort_func);
				monster = ret[0][0];
			}
			return monster;
		};
		this.UpdateSceneEffect = () => {
			if (this.scene_effect_list && this.scene_effect_list.length > 0) {
				for (let vo of this.scene_effect_list) {
					let key = `${vo.effect_res_name}@${vo.center_pos_x}@${vo.center_pos_y}`;
					let show = main_camera.CheckInScreen(vo.center_pos_x, vo.center_pos_y, vo.width * vo.scale_x / 2, vo.height * vo.scale_y / 2);
					//local_Util.RectIntersection({x:,y:,width:,height:},{})
					if (show && !this.scene_effect_id_list[key]) {
						let depth = vo.depth == undefined || layer_mgr.GetUILayer(vo.depth);
						this.scene_effect_id_list[key] = particle_mgr.AddPosEffect(vo.effect_res_name, new local_Vector2(vo.center_pos_x + vo.x_off, vo.center_pos_y + vo.y_off), true, null, null, false, null, null, 1, depth, (go) => {
							go.scaleX = vo.scale_x;
							go.scaleY = vo.scale_y;
						});
					}
					else if (!show && this.scene_effect_id_list[key]) {
						particle_mgr.DelEffect(this.scene_effect_id_list[key]);
						delete this.scene_effect_id_list[key];
					}
				}
			}
		};
		this.GetNearestMonsterByTypeId = (type_id?) => {
			let monster_vo = scene_mgr.GetNearestMonsterVoByTypeId(type_id)
			if (monster_vo) {
				return this.GetMonster(monster_vo.instance_id)
			}
		}

		this.ClearLastAttack = () => {
			if (this.last_ranAttackObj) {
				this.last_ranAttackObj = null
			}
		}

		this.FindElement = (findVo?, isAgain?) => {
			if (!this.scene_data_loaded) {
				return
			}

			isAgain = isAgain || false
			if (findVo == null || findVo.type == null || findVo.sceneId == null || findVo.id == null) {
				return
			}
			this.clearGoToData()
			Global_Event_System.Fire(Event_Name.FINDWAY_STARTED)

			// 寻路NPC要重新计算距离
			if (findVo.type == FindVo.NPC) {
				let npc = scene_mgr.GetNpcVo(findVo.id)
				if (npc) {
					findVo.x = npc.logic_x
					findVo.y = npc.logic_y
				}
			}

			//跳完后 继续寻路
			// OperateManager.Instance.jump_end_not_continue = false

			this.CancelWaitQuest()
			if (!this.main_role.CanMove()) {
				let timer_func = () => {
					if (this.main_role.CanMove()) {
						this.FindElement(findVo)
						return
					}
				}
				this.timer = GlobalTimerQuest.AddPeriodQuest(timer_func, 0.1)
				return
			}

			this.find_vo_cache = findVo
			let myx = mainrole_vo.pos_x / local_SceneObj.GetLogicRealRatio().x
			let myy = mainrole_vo.pos_y / local_SceneObj.GetLogicRealRatio().y
			if (SceneManager.Instance.showHorseScene()) {
				if (findVo.sceneId == scene_mgr.GetSceneId()) {
					if (((myx - findVo.x) * (myx - findVo.x) + (myy - findVo.y) * (myy - findVo.y)) > 400) {
						Global_Event_System.Fire(Event_Name.CHANGE_FIGHTING_STATE, false)		////寻路自动上坐骑
					}
				} else {
					if (!findVo.force_change_scene) {
						Global_Event_System.Fire(Event_Name.CHANGE_FIGHTING_STATE, false)		////寻路自动上坐骑
					}
				}
			}
			if (findVo.sceneId != scene_mgr.GetSceneId()) {  //跨场景
				// let scene_path = SceneConnectMap.Instance.FindPath(this.scene_mgr.GetSceneId(), findVo.sceneId)
				// if (findVo.force_change_scene || List.Empty(scene_path) ) {
				// 	findVo.force_change_scene = false
				// 	this.scene_mgr.find_nextvo = findVo
				// 	this.find_isAgain = isAgain
				// Global_Event_System.Fire(SceneEventType.REQUEST_CHANGE_SCENE, findVo.sceneId, findVo.call_type)
				Global_Event_System.Fire(SceneEventType.REQUEST_CHANGE_SCENE, findVo.sceneId, null, null, null, findVo.call_back)
				// }else{
				// 	var change_scene_callback = () => {
				// 		this.clearGoToData()
				// 		if (scene_mgr.GetSceneId() == findVo.sceneId) {
				// 			OperateManager.Instance.ClearSrcOper()  //停止继续寻路
				// 			this.FindElement(findVo)
				// 			return true
				// 		}
				// 	}
				// 	OperateManager.Instance.StartCrossSceneAction(findVo.sceneId, { "x": findVo.x, "y": findVo.y }, change_scene_callback, undefined)
				// }
				return
			}
			if (findVo.type == FindVo.SCENE) {
				this.ClearFindNextScene()
				Global_Event_System.Fire(Event_Name.FINDWAY_ENDED)
				return
			} else if (findVo.type == FindVo.NPC) {
				this.MainRoleToNpc(findVo.id)
			} else if (findVo.type == FindVo.MONSTER) {
				let logic_pos = this.main_role.GetLogicPos()
				if ((findVo.x > 0 || findVo.y > 0) && local_GameMath.GetDistance(logic_pos.x, logic_pos.y, findVo.x, findVo.y) > 20) {
					if (isAgain == false) {
						var findAgain = () => {
							if (this.CanSelectMonster(true)) {
								let mon = this.FindNearestMonsters(findVo.id)
								if (mon) {
									this.MainRoleAttackMonster(mon)
								}
							}
						}
						this.MainRoleMoveAndCancel(new local_Vector2(findVo.x, findVo.y), findVo.range || 0, findAgain)
						if (findVo.call_back) {
							findVo.call_back()
						}
					}
				} else if (scene_mgr.GetMonsterVoByTypeId(findVo.id) != null) {
					if (isAgain == false) {
						if (this.CanSelectMonster(true)) {
							let mon = this.FindNearestMonsters(findVo.id)
							if (mon) {
								this.MainRoleAttackMonster(mon)
								Global_Event_System.Fire(Event_Name.FINDWAY_ENDED)
							}
							if (findVo.call_back) {
								findVo.call_back()
							}
						}
					}
				} else {
					Global_Event_System.Fire(Event_Name.FINDWAY_ENDED)
				}
			} else if (findVo.type == FindVo.PLAYER) {
				let player = this.GetRole(findVo.id)
				Global_Event_System.Fire(Event_Name.FINDWAY_ENDED)
				if (player != null) {
					this.MainRoleAttackRole(player)
				}
			} else if (findVo.type == FindVo.POINT) {
				let logic_pos = this.main_role.GetLogicPos()
				if (local_GameMath.GetDistance(logic_pos.x, logic_pos.y, findVo.x, findVo.y) <= 1) {
					this.main_role.DoStand()
					let onDelay = () => {
						if (this.delay_timer_id) {
							GlobalTimerQuest.CancelQuest(this.delay_timer_id)
							this.delay_timer_id = null
						}
						Global_Event_System.Fire(Event_Name.FINDWAY_ENDED)
					}
					this.delay_timer_id = GlobalTimerQuest.AddDelayQuest(onDelay, 0.5)
					if (findVo.call_back) {
						findVo.call_back()
					}
				} else {
					this.MainRoleMoveAndCancel(new local_Vector2(findVo.x, findVo.y), 0, findVo.call_back)
				}
			}
		}

		this.CancelWaitQuest = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
			}
		}

		this.ClearFindNextScene = () => {
			scene_mgr.find_nextvo = null
			this.find_isAgain = null
			scene_mgr.next_scene_id = 0
		}

		this.CanSelectMonster = (show?) => {
			let bool = true
			if (scene_mgr.IsBossScene()) {
				// bool = BossSceneManager.GetInstance().JudgeTired(show)
			}
			// if (scene_mgr.IsHolyTerritory() && HolyTerritoryModel.GetInstance().IsSelfHT() ) {
			// 	bool = false
			// }
			return bool
		}

		// 跨场景，继续寻路
		this.FindContinue = () => {
			if (scene_mgr.find_nextvo) {
				this.FindElement(scene_mgr.find_nextvo, this.find_isAgain)
				scene_mgr.find_nextvo = null
				this.find_isAgain = null
			}
		}

		this.UpdateAutoClickTarget = () => {
			if (!scene_mgr.IsSceneStart()) {
				return
			}

			if (!UserMsgAdapter.GetInstance().IsGameConnected()) {
				return
			}

			if (scene_mgr.IsSafeScene()) {
				return
			}

			// if (this.main_role == null || this.main_role.IsDead() || this.mainrole_vo.hp <= 0 || this.mainrole_vo.ghost_mode == 1 ) {
			// 	return
			// }

			if (this.main_role.IsInState(local_PoseState.FLY_SHOE_EFFECT) || this.main_role.IsInState(local_PoseState.TASK_JUMP)) {
				return
			}

			if (!this.main_role.CanMove(true)) {
				return
			}

			if (local_Util.TableSize(this.monster_list) == 0 && local_Util.TableSize(this.role_list) == 0 && local_Util.TableSize(this.partner_list) == 0) {
				return
			}

			if (auto_fight_mgr.CompareAutoFightAndAutoFindWay() < 0) { //寻路过程中不选择目标
				return
			}

			//做任务的时候，随机寻怪时已经选好一只怪物了，就不要自动选其他最近的怪物了
			if ((this.main_role.IsFighting() || this.has_task_target) && this.curr_click_target && this.curr_click_target.IsDead && this.curr_click_target.IsDead() == false) {
				return
			}

			let attack_list = null
			let role_list = null

			let first_attack = Scene.FIND_TARGET_TYPE.all//this.auto_fight_mgr.GetTargetFirstAttack() //获取优先攻击类型
			if (scene_mgr.IsCSPvP() || scene_mgr.IsDiamondFightScene() || scene_mgr.IsTopPkScene()) {
				first_attack = Scene.FIND_TARGET_TYPE.role
			}

			if (first_attack == Scene.FIND_TARGET_TYPE.all) {
				[attack_list, role_list] = this.FindTargets(Scene.FIND_TARGET_TYPE.all, 1, null, target_auto_fight_cfg.distance, null, null, null, null, null, null, true, target_auto_fight_cfg.contain_collect_type)
				if (role_list) {
					for (let i = 0; i < role_list.length; i++) {
						var role = role_list[i]
						if (scene_mgr.IsSeaHegemonyScene() && !this.CheckSeahegeScene(role)) continue
						attack_list.push(role)
					}
				}
			} else if (first_attack == Scene.FIND_TARGET_TYPE.monster) {
				attack_list = this.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, target_auto_fight_cfg.distance, null, null, null, null, null, null, true, target_auto_fight_cfg.contain_collect_type)[0]
				if (attack_list == null || attack_list.length < 1) {
					[attack_list, role_list] = this.FindTargets(Scene.FIND_TARGET_TYPE.all, 1, null, target_auto_fight_cfg.distance, null, null, null, null, null, null, true, target_auto_fight_cfg.contain_collect_type)
					if (role_list) {
						for (let i = 0; i < role_list.length; i++) {
							var role = role_list[i]
							if (scene_mgr.IsSeaHegemonyScene() && !this.CheckSeahegeScene(role)) continue
							attack_list.push(role)
						}
					}
				}
			} else if (first_attack == Scene.FIND_TARGET_TYPE.role) {
				attack_list = this.FindTargets(Scene.FIND_TARGET_TYPE.role, 1, null, target_auto_fight_cfg.distance, null, null, null, null, null, null, true, target_auto_fight_cfg.contain_collect_type)[0]
				if (attack_list == null || attack_list.length < 1) {
					[attack_list, role_list] = this.FindTargets(Scene.FIND_TARGET_TYPE.all, 1, null, target_auto_fight_cfg.distance, null, null, null, null, null, null, true, target_auto_fight_cfg.contain_collect_type)
					if (role_list) {
						for (let i = 0; i < role_list.length; i++) {
							var role = role_list[i]
							if (scene_mgr.IsSeaHegemonyScene() && !this.CheckSeahegeScene(role)) continue
							attack_list.push(role)
						}
					}
				}
			}
			// }

			if (attack_list && attack_list[0] && this.curr_click_target != attack_list[0]) {
				if (scene_mgr.IsSeaHegemonyScene() && !this.CheckSeahegeScene(attack_list[0])) {
					this.SetClickTarget(null)
					return
				}
				this.SetClickTarget(attack_list[0])
			}
		}

		//海域特殊处理
		this.CheckSeahegeScene = (target) => {

			if (target.GetType() == scene_base_type.Role) {
				//同伴不攻击
				if (!SeaHegemonyModel.GetInstance().CanAttackRole(target.vo)) return false
			}


			if (SeaHegemonyModel.GetInstance().fightType == 0) {
				if (target.GetType() == scene_base_type.Monster && target.vo.type != local_MonsterType.COLLECT) {
					return false//防守方不攻击塔
				}

			} else {
				//进攻方不攻击已经被毁坏的塔
				if (target.GetType() == scene_base_type.Monster) {
					if (target.vo.type == local_MonsterType.COLLECT) {
						return false//防守方不攻击塔
					} else {
						if (!SeaHegemonyModel.GetInstance().CanAttackMonster(target.vo)) return false
					}

				}
			}

			if (this.curr_click_target) {
				return false
			}

			return true
		}


		//伙伴自动挂机逻辑 skill_id不为空表示手动点击释放技能 target_defender 目标受击单位
		this.PartnerUpdateFight = (skill_id?, target_defender?) => {
			//托管不主动放技能
			if (RoleManager.GetInstance().GetMainRoleDepositState()) {
				return
			}
			if (this.main_role && !SceneManager.Instance.DisabledPartnerSkillScene()) {
				if (!skill_mgr.PartnerIsInRigidity()) {
					let is_manul_release = skill_id != null
					if (!skill_id) {  ////////- 自动释放 ////////-
						let [_, id] = PartnerModel.GetInstance().GetSkill() // 技能
						let skill_vo = skill_mgr.getSkill(id)
						if (skill_vo && skill_vo.CoolDown() && PartnerModel.GetInstance().GetAutoStatus()) { // 伙伴自动挂机方可自动释放技能
							skill_id = id
						}
						if (!skill_id) { // 释放普攻
							id = PartnerModel.GetInstance().GetAttackSkill()  // 普攻
							let skill_vo = skill_mgr.getSkill(id)
							if (skill_vo && skill_vo.CoolDown()) {
								skill_id = id
							}
						}
					} else { //////// 手动释放 ////////
						let [_, id] = PartnerModel.GetInstance().GetSkill()
						skill_id = id
					}
					if (skill_id) {
						let skill_vo = skill_mgr.getSkill(skill_id)
						if (skill_vo && skill_vo.CoolDown()) {
							let select_type = skill_vo.GetSelectType()
							let target_compress_id
							if (skill_vo.GetSelectType() == 7) {
								target_compress_id = this.main_role.compress_id
							} else {
								target_defender = target_defender || this.curr_click_target
								if (target_defender && target_defender.IsDead && !target_defender.IsDead()) {
									target_compress_id = target_defender.compress_id
								}
							}
							if (is_manul_release || target_compress_id) {
								let attacker = this.main_role.GetPartner()
								Global_Event_System.Fire(FightEvent.RELEASE_MAIN_SKILL, attacker, skill_id, target_compress_id)
							}
						}
					}
				}
			}
		}


		this.SetEnterSceneFlag = () => {
			if (scene_mgr.IsMainCityAndFieldScene()) {
				target_auto_fight_cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["MainCityAndFieldScene"]
				// if (scene_mgr.IsPkBattleScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["PkBattleScene"]
				// } else if (scene_mgr.IsGuildWarScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["GuildWarScene"]
				// } else if (scene_mgr.IsGuildGuardDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["GuildGuardDungeon"]
				// } else if (scene_mgr.IsOnButterflyScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["ButterflyScene"]
				// } else if (scene_mgr.IsEquipScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["DungeonEquipScene"]
				// } else if (scene_mgr.IsRefineDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["DungeonRefineScene"]
				// } else if (scene_mgr.IsRebuildDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["DungeonRebuildScene"]
				// } else if (scene_mgr.IsStarDungeonScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["StarDungeonScene"]
				// } else if (scene_mgr.IsKFGuildWarFightScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["KFGuildWarFightScene"]
				// } else if (scene_mgr.IsDiamondFightScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["DiamonFightScene"]
				// } else if (scene_mgr.IsLoveDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["DungeonLoveScene"]
				// } else if (scene_mgr.IsOvnFightingScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["CSOnevNScene"]
				// } else if (scene_mgr.IsCSPvP() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["Cross3v3"]
				// } else if (scene_mgr.IsSoulDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["IsSoulDungeon"]
				// } else if (scene_mgr.IsHolyTerritory() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["IsHolyTerritory"]
				// } else if (scene_mgr.IsSuitBossScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["SuitBoss"]
				// } else if (scene_mgr.IsFieldBossScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["FieldBoss"]
				// } else if (scene_mgr.IsHolyBattleFightScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["HolyBattleScene"]
				// } else if (scene_mgr.IsRuneDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["DungeonRune"]
				// } else if (scene_mgr.IsKfHolyAreaScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["kfHolyAreaScene"]
				// } else if (scene_mgr.IsHolyBossScene() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["HolyBossScene"]
				// } else if (scene_mgr.IsBossSnatchTreasure() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["SnatchTreasureScene"]
				// } else if (scene_mgr.IsDragonDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["DragonDungeonScene"]
			} else if (scene_mgr.IsNineSkyFightScene()) {
				target_auto_fight_cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["NineSkyScene"]
				// } else if (scene_mgr.IsMountDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["IsMountDungeon"]
				// } else if (scene_mgr.IsPolarDungeon() && scene_mgr.IsKFPolarDungeon() ) {
				// 	target_auto_fight_cfg =  Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["IsPolarDungeon"]
			} else if (scene_mgr.IsWeddingScene()) {
				target_auto_fight_cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["WeddingScene"]
			} else if (scene_mgr.IsSeaAsserScene()) {
				target_auto_fight_cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["IsSeaAsserScene"]
			} else {
				target_auto_fight_cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["Default"]
			}


			if (scene_mgr.IsDropAllRange()) {
				this.pick_drop_distance = 3000
			}
			else if (scene_mgr.IsHolyTerritory()) {
				this.pick_drop_distance = 1000
			}
			else if (scene_mgr.IsSuitBossScene()) {
				this.pick_drop_distance = 600
			}
			else if (scene_mgr.IsEquipDungeon()) {
				this.pick_drop_distance = 1000
			}
			else if (scene_mgr.IsEternityScene()) {
				this.pick_drop_distance = 2000
			}
			else {
				this.pick_drop_distance = 600
			}

			// this.find_monster_distance = self.target_auto_fight_cfg.find_monster_distance or 1000
		}

		this.OnPick = () => {
			//走过去一个个捡
			let vo = this.FindDropItem(this.pick_drop_distance)
			if (vo && vo[0]) {
				let drop = vo[0]
				if (this.need_change_move_speed) {
					this.main_role.move_flag = MOVE_TYPE.PICK_DROP
				}
				this.now_drop_obj = drop
				this.last_drop_obj = drop
				return true
			}

			if (this.last_drop_obj != null) {
				//当前有正在出生状态的掉落,等待
				if (vo) {
					console.warn("OnPick@has born return------------")
					return true
				}
				Global_Event_System.Fire(SceneEventType.PICK_UP_END)
				this.drop_pos_list = {}
			}
			this.last_drop_obj = null
			this.now_drop_obj = null
		}


		this.IsPicking = () => {
			if (this.now_drop_obj && this.now_drop_obj.IsPicking()) {
				return true
			}
		}

		this.FindDropItem = (dis) => {
			if (local_Util.TableSize(this.drop_list) == 0) return
			let ret = []
			let born_list = []
			let main_role_pos = this.main_role.GetRealPos()
			let drop_obj
			if (this.drop_index_list && this.drop_index_list.length > 0 && this.can_check_index_list) {
				// if(!this.can_check_index_list) return
				let delete_list, drop_id
				for (let i = 0; i < this.drop_index_list.length; i++) {
					drop_id = this.drop_index_list[i].drop_id
					drop_obj = this.GetDrop(drop_id)
					if (drop_obj) {
						let drop_real_pos = drop_obj.GetRealPos()
						if (drop_obj.IsCanPickUp()) {
							let dist_pw = local_GameMath.GetDistance(main_role_pos.x, main_role_pos.y, drop_real_pos.x, drop_real_pos.y, false)
							if (dis) {
								if (dist_pw < dis * dis) {
									console.log("----------------FindDropItem@pick drop_index_list", drop_id)
									table.insert(ret, [drop_obj, dist_pw])
								} else {
									return
								}
							}
							else {
								table.insert(ret, [drop_obj, dist_pw])
							}
						} else if (drop_obj.GetState() == Drop.DropType.Born) {
							table.insert(born_list, drop_id)
						}
						else {
							if (!delete_list) {
								delete_list = []
							}
							delete_list.push(i)
						}
					}
					else {
						if (scene_mgr.GetDropVo(drop_id)) {
							table.insert(born_list, drop_id)
						} else {
							if (!delete_list) {
								delete_list = []
							}
							delete_list.push(i)
						}
					}
				}

				if (delete_list) {
					for (let i = delete_list.length - 1; i >= 0; i--) {
						var index = delete_list[i]
						console.log("----------------FindDropItem@del drop_index_list", this.drop_index_list[index].drop_id)
						this.drop_index_list.splice(index, 1);
					}
				}
			}
			else {

				for (let drop_id in this.drop_list) {
					drop_obj = this.drop_list[drop_id]
					let drop_real_pos = drop_obj.GetRealPos()
					if (drop_obj.IsCanPickUp()) {
						let dist_pw = local_GameMath.GetDistance(main_role_pos.x, main_role_pos.y, drop_real_pos.x, drop_real_pos.y, false)
						if (dis) {
							if (dist_pw < dis * dis) {
								console.log("----------------FindDropItem@pick drop_list", drop_id)
								table.insert(ret, [drop_obj, dist_pw])
							}
						}
						else {
							table.insert(ret, [drop_obj, dist_pw])
						}

					}
					else if (drop_obj.GetState() == Drop.DropType.Born) {
						table.insert(born_list, drop_id)
					}
				}
			}

			if (ret.length > 0) {
				table.sort(ret, (a, b) => {
					return a[1] < b[1]
				})
			}

			if (ret[0]) {
				return ret[0]
			}
			else {
				return born_list.length > 0
			}

			// return [ret[0], born_list.length > 0]
		}

		this.SetDropIndexList = (list) => {
			this.can_check_index_list = false
			this.drop_index_list = list
		}

		this.DelDropIndexList = (drop_id) => {
			if (this.drop_index_list) {
				for (let i in this.drop_index_list) {
					if (this.drop_index_list[i].drop_id == drop_id) {
						console.log("----------------FindDropItem@del drop_index_list", drop_id)
						this.drop_index_list.splice(i, 1);
						break
					}
				}
			}
		}

		this.AutoPick = () => {
			if (this.now_drop_obj) {
				let drop = this.now_drop_obj

				let drop_real_pos = drop.GetRealPos()
				let main_role_pos = this.main_role.GetRealPos()

				let dist_pw = local_GameMath.GetDistance(drop_real_pos.x, drop_real_pos.y, main_role_pos.x, main_role_pos.y, false)
				if (dist_pw > this.pick_drop_distance * this.pick_drop_distance) {
					this.now_drop_obj = null
					return
				}

				if (!this.now_drop_obj.IsCanPickUp()) {
					return
				}

				let pick_dis
				if (drop.IsNeedPickTime())
					pick_dis = 30
				else
					pick_dis = 100

				if (dist_pw < pick_dis * pick_dis) {
					drop.PickUp()
					this.clearGoToData()
				}
				else
					this.MainRoleMove(new local_Vector2(drop_real_pos.x / local_SceneObj.GetLogicRealRatio().x, drop_real_pos.y / local_SceneObj.GetLogicRealRatio().y), 0)
			}
		}

		this.CheckPick = () => {
			if (this.IsPicking()) return true
			return this.OnPick()
		}

		this.GetRandomMonsterByTypeId = (type_id, not_instance_id) => {
			let monster_vo = scene_mgr.GetRandomMonsterVoByTypeId(type_id, not_instance_id)
			if (monster_vo)
				return this.GetMonster(monster_vo.instance_id)

		}

		this.FindNearestTarget = (range, attacker, select_type, hiter_pos_type, target_type) => {
			target_type = target_type || Scene.FIND_TARGET_TYPE.all
			return this.FindTargets(target_type, 1, 0, range, null, null, null, attacker, null, select_type, null, null, hiter_pos_type)
		}


		this.CheckJumpPoint = (force_check?, role_id?) => {

			let main_role = role_id && this.GetRole(role_id) || this.main_role
			last_multi_jump_time = last_multi_jump_time || 0
			if (!force_check && local_Status.NowTime - last_multi_jump_time < 0.3) {
				return true
			}
			//MainCamera.Instance.ChangePosFllowMainrole(main_role.real_pos.x,main_role.real_pos.y,main_role.jump_height || 0)
			let scene_info = Config_PRELOAD_CLIENT_CONFIG.MultiJumpPos[scene_mgr.GetSceneId()]
			if (scene_info) {
				for (let j = 0; j < scene_info.length; j++) {
					var pvo = scene_info[j]
					var j_index = j + 1
					for (let i = 0; i < pvo.length; i++) {
						var vo = pvo[i]
						var i_index = i + 1
						let main_role_pos = main_role.GetRealPos()
						let x = main_role_pos.x, y = main_role_pos.y

						let range = vo.range * vo.range

						let ss = local_GameMath.GetDistance(x, y, vo.start_pos.x, vo.start_pos.y, false)
						// console.log("------CheckJumpPoint------", main_role.jump_curr_trigger_index, x, y, vo.start_pos.x, vo.start_pos.y, vo.range, ss)
						if (
							(
								!main_role.jump_curr_trigger_index ||
								(
									(
										!main_role.jump_curr_trigger_index_child || main_role.jump_curr_trigger_index_child != i_index
									)
									&&
									main_role.jump_curr_trigger_index == j_index
								)
							)
							&& ss <= range) {
							main_role.jump_curr_trigger_index = j_index
							main_role.jump_curr_trigger_index_child = i_index
							vo.trigger_time = local_Status.NowTime
							let dir = new local_Vector2(vo.middle_pos.x - vo.start_pos.x, vo.middle_pos.y - vo.start_pos.y)
							let dist = dir.normalise()
							let init_end_pos = new local_Vector2(vo.start_pos.x + dir.x * dist, vo.start_pos.y + dir.y * dist)
							let end_pos = new local_Vector2(vo.start_pos.x + dir.x * (dist / vo.middle_pos_ratio), vo.start_pos.y + dir.y * (dist / vo.middle_pos_ratio))

							end_pos = vo.middle_pos
							if (!role_id) {
								last_multi_jump_time = local_Status.NowTime
								// MainCamera.Instance.ChangeSmoothState(MainCamera.SmoothState.Jump_Point)
							}

							console.log("role_jump1", end_pos.x, end_pos.y, vo.move_hspeed, vo.move_vspeed)
							let is_last = false
							if (!pvo[i + 1]) {
								is_last = true
							}
							if (main_role.is_fight_jump) {
								main_role.DoStand()
							}
							main_role.DoJump(end_pos, true, null, vo.move_hspeed, vo.move_vspeed, vo.jump_type, null, null, vo.show_effect, init_end_pos, null, vo.middle_pos_ratio, null, true, is_last)
							return true
							// }
						}
					}
				}
			}

			let logic_pos = main_role.GetLogicPos()
			//如果是跳点区域 或者
			let is_jump = false //this.scene_mgr.IsAreaType(logic_x || lx, logic_y || ly, AreaDataIndex.JumpType)
			//上一个区域跳跃结束点是障碍点
			let next_jump_is_block = force_check && scene_mgr.IsBlockXY(logic_pos.x, logic_pos.y) && main_role.IsInState(local_PoseState.JUMP) && main_role.is_scene_trigger
			if (is_jump || next_jump_is_block) {
				if (force_check || !main_role.IsInState(local_PoseState.JUMP)) {
					let end_pos = null
					let multi_jump = false
					if (is_jump) {
						let distance = null
						distance = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_move_distance[(main_role.curr_multi_jump_type || 1)]
						let dir = main_role.direction
						let dist = distance || 800
						end_pos = new local_Vector2(main_role.real_pos.x + dir.x * dist, main_role.real_pos.y + dir.y * dist)
						let lx = end_pos.x / local_SceneObj.GetLogicRealRatio().x
						let ly = end_pos.y / local_SceneObj.GetLogicRealRatio().y
						if (scene_mgr.IsBlockXY(lx, ly)) {
							let data = SourceOperateMove.FindFastestPos(new local_Vector2(main_role.real_pos.x, main_role.real_pos.y), end_pos)
							let ex = data.x, ey = data.y, result = data.result
							if (result) {
								end_pos = new local_Vector2(ex, ey)
								// } else if (this.scene_mgr.IsAreaType(lx, ly, AreaDataIndex.JumpType) ) {
							} else {
								multi_jump = true
							}
						}
					} else if (next_jump_is_block) {
						let unblock_pos = SourceOperateMove.FindNoBlockPos(main_role.logic_pos)
						if (unblock_pos) {
							end_pos = new local_Vector2(unblock_pos.x * local_SceneObj.GetLogicRealRatio().x, unblock_pos.y * local_SceneObj.GetLogicRealRatio().y)
							multi_jump = false
						} else {
							return false
						}
					} else {
						return false
					}
					last_multi_jump_time = local_Status.NowTime
					main_role.DoJump(end_pos, true)
					if (multi_jump) {
						if (main_role.jump_info) {
							main_role.jump_area_mutil_jump_end_time = local_Status.NowTime + main_role.jump_info.move_time * 0.85
						}
					} else {
						main_role.jump_area_mutil_jump_end_time = null
					}
				}
				return true
			}
			return false
		}


		//传送点在同一个场景里的传送门
		this.CheckDoorInSameScene = (fire_evt?, dist?) => {
			if (!has_same_scene_door) { return }
			let main_role = Scene.Instance.GetMainRole()
			dist = dist || 2
			let near_door = null
			let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigDoorInSameScene[scene_mgr.GetSceneId()]
			if (cfg) {
				let logic_pos = this.main_role.GetLogicPos()
				let door_posX = 0
				let door_posY = 0
				for (let i in cfg) {
					var door = cfg[i]
					door_posX = door.x / local_SceneObj.GetLogicRealRatio().x
					door_posY = door.y / local_SceneObj.GetLogicRealRatio().y
					if (local_GameMath.IsPointNear(logic_pos.x, logic_pos.y, door_posX, door_posY, dist)) {
						near_door = door
						break
					}
				}
				if (near_door) {
					if (fire_evt) {
						this.RoleWalkCompleteHandler(true)
					} else {
						OperateManager.Instance.StopMove()
					}
				}
			}
		}

		this.GetZoneHeight = (x, y) => {
			return 0
		}

		this.MainRoleDoCollect = () => {
			let main_role = this.GetMainRole()
			main_role.DoCollect()
		}

		this.MainRoleQuitCollect = () => {
			let main_role = this.GetMainRole()
			if (main_role.IsInState(local_PoseState.COLLECT)) {
				main_role.QuitCollect()
			}
		}

		this.CheckCanCreateDoor = () => {
			if (scene_mgr.IsSeaHegemonyScene()) {
				return SeaHegemonyModel.GetInstance().CheckCanCreateDoor()
			}
			return true
		}

		this.ClearMainRoleFindWayState = () => {
			OperateManager.GetInstance().StopMove()
			this.clearGoToData()
			if (this.GetMainRole()) {
				this.GetMainRole().DoStand()
			}
		}

		this.InitSAPFunction = () => {
			let func = (operate?, obj_type?, obj_data?) => {
				if (operate == local_SapManager.OperateType.CreateOBJ) {
					switch (obj_type) {
						case local_SapManager.ObjType.JumpPoint:
							let jumppoint_vo = obj_data
							let jumppoint = new JumpPoint(jumppoint_vo)
							this.jump_point_dic[jumppoint.id] = jumppoint
							break;
						case local_SapManager.ObjType.Door:
							if (this.CheckCanCreateDoor()) {
								let door = new Door(obj_data)
								// if (obj_data.is_same_scene) {
								// 	this.door_list[`${obj_data.enter_scene_id}-${obj_data.index}`] = door
								// } else if (scene_mgr.IsSeaHegemonyScene()) {
								// 	this.door_list[`${obj_data.enter_scene_id}-${obj_data.id}`] = door
								// } else {
								this.door_list[obj_data.id] = door
							}
							// }
							break;
						case local_SapManager.ObjType.NPC:
							if (!this.npc_list[Number(obj_data.instance_id)]) {
								let npc_obj = this.npc_pool.GetObjFreeList()
								if (!npc_obj) {
									npc_obj = new Npc()
								}
								npc_obj.InitNpc(obj_data)
								this.npc_list[Number(obj_data.instance_id)] = npc_obj
							}
							break;
						case local_SapManager.ObjType.Effect:
							mapView.CreateEffect(obj_data);
							break;
						case local_SapManager.ObjType.Drop:
							if (!this.drop_list[Number(obj_data.instance_id)]) {
								let drop = this.drop_pool.GetObjFreeList();
								if (drop == null)
									drop = new local_Drop();
								drop.InitDropVo(obj_data);
								this.drop_list[obj_data.drop_id] = drop;
							}
							break;
						default:
							return;
					}
				} else if (operate == local_SapManager.OperateType.DestoryOBJ) {
					switch (obj_type) {
						case local_SapManager.ObjType.JumpPoint:
							let jumopoint = this.jump_point_dic[obj_data]
							if (jumopoint != null) {
								jumopoint.DeleteMe()
								delete this.jump_point_dic[obj_data]
							}
							break;
						case local_SapManager.ObjType.Door:
							let door = this.door_list[obj_data.id]
							if (door != null) {
								door.DeleteMe()
								delete this.door_list[obj_data.id]
							}
							break;
						case local_SapManager.ObjType.NPC:
							let npc = this.npc_list[obj_data.instance_id]
							if (npc != null) {
								this.npc_pool.ReleaseObj(npc)
								delete this.npc_list[obj_data.instance_id]
							}
							break;
						case local_SapManager.ObjType.Effect:
							mapView.DeleteEffect(obj_data)
							break;
						case local_SapManager.ObjType.Drop:
							this.DelDropIndexList(obj_data.drop_id)
							let drop = this.drop_list[obj_data.drop_id];
							if (drop != null) {
								delete this.drop_list[obj_data.drop_id];
								this.drop_pool.ReleaseObj(drop);
							}
							break;
						default:
							return;
					}
				}
			}
			local_SapManager.GetInstance().RegisterCallbackFunc(func)
		}

		this.GetSceneSize = () => {
			return {
				x: mapView.GetSceneWidth(),
				y: mapView.GetSceneHeight()
			}
		}
		this.InitEvents();
		this.InitSAPFunction();
		Runner.GetInstance().AddRunObj(this, 1, FRAME_TYPE.total);
	};

	public StartTalk() {
		if (!this.talk_time_spc) {
			let talk_kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_scene_chat_bubble_kv
			if (talk_kv_cfg && talk_kv_cfg.regular_trigger_time && talk_kv_cfg.regular_trigger_time.bubble_value) {
				this.talk_time_spc = Number(talk_kv_cfg.regular_trigger_time.bubble_value)
			}
		}
		if (this.talk_time_id) {
			GlobalTimerQuest.CancelQuest(this.talk_time_id)
		}
		this.talk_time_id = GlobalTimerQuest.AddPeriodQuest(() => {
			this.SceneTalk()
		}, this.talk_time_spc)
	}

	public SceneTalk() {
		let obj_list = []
		for (let i in this.npc_list) {
			let vo = this.npc_list[i]
			if (this.JudgeObjCanTalk(vo.id) && this.JudgeObjInView(vo)) {
				obj_list.push(vo)
			}
		}
		for (let i in this.partner_list) {
			let vo = this.partner_list[i]
			if (this.JudgeObjCanTalk(vo.model_res) && this.JudgeObjInView(vo) && this.JudgeOwnerIsMine(vo)) {
				obj_list.push(vo)
			}
		}
		for (let i in this.sprite_list) {
			let vo = this.sprite_list[i]
			if (this.JudgeObjCanTalk(vo.model_res) && this.JudgeObjInView(vo) && this.JudgeOwnerIsMine(vo)) {
				obj_list.push(vo)
			}
		}

		let max = obj_list.length
		let index = local_Util.RandomRange(1, max) - 1
		if (obj_list[index]) {
			let obj = obj_list[index]
			let id = obj.id
			let type
			if (obj._type == SceneBaseType.Sprite) {
				type = 1
				id = obj.model_res
			} else if (obj._type == SceneBaseType.Partner) {
				type = 2
				id = obj.model_res
			} else if (obj._type == SceneBaseType.Npc) {
				type = 3
			} else if (obj._type == SceneBaseType.Monster) {
				type = 4
				id = obj.vo.type_id
			}
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_scene_chat_bubble
			let bubble_lsit = []
			let lv = RoleManager.GetInstance().GetMainRoleLevel()
			for (let i in cfg) {
				let vo = cfg[i]
				if (vo.object_id == id && vo.object_type == type && vo.bubble_type == 1) {
					let show = true
					if ((vo.min_lv && lv < vo.min_lv) || (vo.max_lv && lv > vo.max_lv)) {
						show = false
					}
					if (show) {
						bubble_lsit.push(vo)
					}
				}
			}
			let str_max = bubble_lsit.length
			let str_vo
			if (str_max > 0) {
				let str_index = local_Util.RandomRange(1, str_max) - 1
				str_vo = bubble_lsit[str_index]
				obj_list[index].CreateTalkBoard(str_vo.bubble_content, null, null, 5, () => {
					if (str_vo.number && str_vo.number != "") {
						let con = ErlangParser.GetInstance().Parse(str_vo.number)[0]
						if (con) {
							this.StartNextTalk(con[0], con[1])
						}
					}
				})
			}
		}
	}

	public StartTaskTalk(task_id) {
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_scene_chat_bubble
		if (!cfg) {
			return
		}

		let cfg_vo
		for (let i in cfg) {
			let vo = cfg[i]
			if (vo.condition && vo.condition != "") {
				let con = ErlangParser.GetInstance().Parse(vo.condition)[0]
				if (con && con[0] == "task_id" && Number(con[1]) == task_id) {
					cfg_vo = vo
					break
				}
			}
		}
		if (!cfg_vo) {
			return
		}
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		if ((cfg_vo.min_lv && lv < cfg_vo.min_lv) || (cfg_vo.max_lv && lv > cfg_vo.max_lv)) {
			return
		}

		let obj_list
		if (cfg_vo.object_type == 1) {
			obj_list = this.sprite_list
		} else if (cfg_vo.object_type == 2) {
			obj_list = this.partner_list
		} else if (cfg_vo.object_type == 3) {
			obj_list = this.npc_list
		} else if (cfg_vo.object_type == 4) {
			obj_list = this.monster_list
		} else {
			return
		}
		let obj
		for (let i in obj_list) {
			let vo = obj_list[i]
			let id = vo.id
			if (vo._type == SceneBaseType.Monster) {
				id = vo.vo.type_id
			} else if (vo._type == SceneBaseType.Sprite) {
				id = vo.model_res
			} else if (vo._type == SceneBaseType.Partner) {
				id = vo.model_res
			}
			if (id == cfg_vo.object_id) {
				obj = vo
				break
			}
		}
		if (!obj) {
			return
		}
		if (this.JudgeObjInView(obj)) {
			if (this.talk_time_id) {
				GlobalTimerQuest.CancelQuest(this.talk_time_id)
			}
			obj.CreateTalkBoard(cfg_vo.bubble_content, null, null, 5, () => {
				if (cfg_vo.number && cfg_vo.number != "") {
					let con = ErlangParser.GetInstance().Parse(cfg_vo.number)[0]
					if (con) {
						this.StartNextTalk(con[0], con[1])
					}
				} else {
					this.StartTalk()
				}
			})
		}
	}

	public StartNextTalk(talk_id, time) {
		if (!talk_id || !time) {
			return
		}
		let cfg_vo = Config.PRELOAD_SERVER_CONFIG.config_scene_chat_bubble[talk_id]
		if (!cfg_vo) {
			return
		}
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		if ((cfg_vo.min_lv && lv < cfg_vo.min_lv) || (cfg_vo.max_lv && lv > cfg_vo.max_lv)) {
			return
		}

		let obj_list
		if (cfg_vo.object_type == 1) {
			obj_list = this.sprite_list
		} else if (cfg_vo.object_type == 2) {
			obj_list = this.partner_list
		} else if (cfg_vo.object_type == 3) {
			obj_list = this.npc_list
		} else if (cfg_vo.object_type == 4) {
			obj_list = this.monster_list
		} else {
			return
		}
		let obj
		for (let i in obj_list) {
			let vo = obj_list[i]
			let id = vo.id
			if (vo._type == SceneBaseType.Monster) {
				id = vo.vo.type_id
			} else if (vo._type == SceneBaseType.Sprite) {
				id = vo.model_res
			} else if (vo._type == SceneBaseType.Partner) {
				id = vo.model_res
			}
			if (id == cfg_vo.object_id) {
				obj = vo
				break
			}
		}
		if (!obj) {
			return
		}
		if (this.JudgeObjInView(obj)) {
			GlobalTimerQuest.AddDelayQuest(() => {
				if (this.talk_time_id) {
					GlobalTimerQuest.CancelQuest(this.talk_time_id)
				}
				obj.CreateTalkBoard(cfg_vo.bubble_content, null, null, 5, () => {
					if (cfg_vo.number && cfg_vo.number != "") {
						let con = ErlangParser.GetInstance().Parse(cfg_vo.number)[0]
						if (con) {
							this.StartNextTalk(con[0], con[1])
						}
					} else {
						this.StartTalk()
					}
				})
			}, time)
		}
	}

	public StartObjTalk(obj, talk_id) {
		if (!this.JudgeObjInView(obj)) {
			return false
		}
		if (this.talk_time_id) {
			GlobalTimerQuest.CancelQuest(this.talk_time_id)
		}
		let cfg_vo = Config.PRELOAD_SERVER_CONFIG.config_scene_chat_bubble[talk_id]
		if (!cfg_vo) {
			return false
		}
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		if ((cfg_vo.min_lv && lv < cfg_vo.min_lv) || (cfg_vo.max_lv && lv > cfg_vo.max_lv)) {
			return
		}

		obj.CreateTalkBoard(cfg_vo.bubble_content, null, null, 5, () => {
			if (cfg_vo.number && cfg_vo.number != "") {
				let con = ErlangParser.GetInstance().Parse(cfg_vo.number)[0]
				if (con) {
					this.StartNextTalk(con[0], con[1])
				}
			} else {
				this.StartTalk()
			}
		})
		return true
	}

	public JudgeObjCanTalk(obj_id) {
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_scene_chat_bubble
		if (!cfg) {
			return false
		}
		for (let i in cfg) {
			let vo = cfg[i]
			if (obj_id == vo.object_id && vo.bubble_type == 1) {
				return true
			}
		}
		return false
	}

	public JudgeObjInView(obj) {
		if (!obj) {
			return false
		}
		let dis_x = Laya.stage.width / 2
		let dis_y = Laya.stage.height / 2
		let x = this.main_role.x
		let y = this.main_role.y
		if (Mathf.Abs(x - obj.x) < dis_x && Mathf.Abs(y - obj.y)) {
			return true
		}
		return false
	}

	public JudgeOwnerIsMine(obj) {
		if (!obj) {
			return false
		}
		if (obj.owner.id == this.main_role.id) {
			return true
		}
		return false
	}
	//boss 墓碑
	public CreateGrave(boss_vo?) {
		let grave = this.grave_list[boss_vo.boss_id]
		if (grave != null) {
			this.grave_pool.ReleaseObj(grave)
			this.grave_list[boss_vo.boss_id] = null
		}
		grave = this.grave_pool.GetObjFreeList()
		if (grave == null) {
			grave = new Grave()
		}
		this.grave_list[boss_vo.boss_id] = grave
		grave.InitGraveVo(boss_vo)

		grave.LoadInfoFromVo()
		return grave
	}
	public DeleteGrave(boss_id?) {
		let grave = this.grave_list[boss_id]
		if (grave != null) {
			this.grave_pool.ReleaseObj(grave)
			delete this.grave_list[boss_id]
		}
	}
	public GetGraveItem(id?) {
		return this.grave_list[id]
	}

	/**
	 * 重新播放当前动作
	 */
	public ReplayAllAction(){

		let main_role = this.main_role
		if (main_role.IsOnHorse() || main_role.IsInState(PoseState.MOVE))
			main_role.ReplayAction();

		let role_list = this.role_list
		let v
		for (let id in role_list) {
			v = role_list[id];
			if (v.IsOnHorse() || v.IsInState(PoseState.MOVE))
				v.ReplayAction();
		}

		let monster_list = this.monster_list; //怪物列表
		for (let id in monster_list) {
			v = monster_list[id];
			if (v.IsInState(PoseState.MOVE))
				v.ReplayAction();
		}

		let sprite_list = this.sprite_list;
		for (let id in sprite_list) {
			v = sprite_list[id];
			if (v.IsInState(PoseState.MOVE))
				v.ReplayAction();
		}

		let demon_list = this.demon_list;
		for (let id in demon_list) {
			v = demon_list[id];
			if (v.IsInState(PoseState.MOVE))
				v.ReplayAction();
		}

		let shengqi_list = this.shengqi_list;
		for (let id in shengqi_list) {
			v = shengqi_list[id];
			if (v.IsInState(PoseState.MOVE))
				v.ReplayAction();
		}

		let partner_list = this.partner_list;
		for (let id in partner_list) {
			v = partner_list[id];
			if (v.IsInState(PoseState.MOVE))
				v.ReplayAction();
		}
	}
}

window["Scene"] = Scene