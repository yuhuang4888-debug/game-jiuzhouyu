import { Character } from "./Character";
import { Vector2 } from "../../util/Vector2";
import { PoseState } from "../../util/StateMachineManager";
import { RoleManager } from "../../commonModel/RoleManager";
import { Scene } from "../Scene";
import { AreaDataIndex, AttachNode, EffectResType, FashionPartPos, MOVE_TYPE, SceneBaseType, WeaponCountInfo, WeaponProvideType } from "../SceneConfig";
import { FigureProtoVo } from "../../common/FigureProtoVo";
import { SceneManager } from "../SceneManager";
import { ParticleManager } from "../../particalEffect/ParticleManager";
import { GlobalEventSystem, LOAD_QUEUE } from "../../util/DeclareGlobalVar";
import { EventName, ObjectEventType, SceneEventType } from "../../common/EventName";
import { MonsterVo } from "../../sharedata/MonsterVo";
import { GameMath } from "../../util/GameMath";
import { Util, CommonPlayAnim, SetMaterialTexture, GetMaterialTexture, GlobalTimerQuest, GetSkinnedMeshSprite3D, Set3DLocalPosition, SetLocalPosition, ResetTransform, GetMeshSprite3D, GetMaterial, Set3DLocalRotation, Set3DLocalRotationEuler, GetParams, Set3DLocalScale, CommonCrossFadeAnim } from "../../util/Util";
import { SkillManager } from "../../skill/SkillManager";
import { FightEvent } from "../fight/FightEvent";
import { CameraManager } from "../CameraManager";
import { RoleVo } from "../../sharedata/RoleVo";
import { SceneObj } from "./SceneObj";
import { TimeUtil } from "../../util/TimeUtil";
import { Status } from "../../util/Status";
import { GameResPath } from "../../util/GameResPath";
import { ResManager } from "../../common/ResManager";
import { Config } from "../../common/Config";
import { ModelPartName } from "../SceneConfig";
import { SoundManager } from "../../common/SoundManager";
import { AutoFightManager } from "../../autofight/AutoFightManager";
import { table } from "../../common/table";
import { Vector3 } from "../../util/Vector3";
import { OperateManager } from "../../operation/OperateManager";
import { Clothe } from "./Clothe";
import { MaskModel } from "../../commonModel/MaskModel";
import { MarriageModel } from "../../commonModel/MarriageModel";
import { DropManager } from "../DropManager";
import { SeaHegemonyModel } from "../../commonModel/SeaHegemonyModel";
import { SapManager } from "../SapManager";
import { BanquetModel } from "../../commonModel/BanquetModel";
import { BanquetAniManager } from "../../marriage2/BanquetAniManager";
import { GameSettingManager } from "../../common/GameSettingManager";
import { LayerManager } from "../../common/LayerManager";

let local_PoseState = PoseState
let local_SceneBaseType = SceneBaseType
let local_FigureProtoVo = FigureProtoVo
let local_SceneObj = SceneObj
let local_EventName = EventName
let local_Character = Character
let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Status = Status
let local_Vector2 = Vector2
let local_SceneEventType = SceneEventType
let local_Util = Util
let local_GlobalEventSystem = GlobalEventSystem
let local_MOVE_TYPE = MOVE_TYPE
let local_Laya = Laya
let local_GameSettingManager = GameSettingManager
let local_Set3DLocalPosition = Set3DLocalPosition
let local_Set3DLocalScale = Set3DLocalScale
let local_Set3DLocalRotationEuler = Set3DLocalRotationEuler
let local_ResetTransform = ResetTransform
let local_GetSkinnedMeshSprite3D = GetSkinnedMeshSprite3D
let local_ResManager
export class Role extends Character {
	task_callback
	is_task_jump
	is_jupm_point
	jump_height
	jump_info
	is_fight_jump
	task_jump_info
	set_repeat_action
	jump_curr_height
	role_mgr
	is_normal_jumping
	partner
	pet
	demon
	jump_curr_trigger_index
	mainrole_vo
	is_scene_trigger
	last_jump_time
	task_cur_jump_count
	jump_curr_time
	task_target_list
	is_shoe_jump
	vo_ext_bind_handlers: Array<any>
	next_frame_funcs
	cur_jump_count
	shengqi
	jump_area_mutil_jump_end_time
	curr_multi_jump_type
	task_jump_type
	show_horse_after_jump
	jump_real_height
	fashion_chartlet_id
	is_last_jump_point
	speed_effect_id
	vo_bind_handlers: Array<any>
	play_change_god_action
	offline_partical_id
	jump_curr_trigger_index_child
	is_dead
	s_hited_info
	jump_start_height
	sprite
	task_move_vspeed
	task_gravity_speed

	brick_res_name
	brick_res_url
	loading_brick
	brick_clothe
	brick_sprite3d
	brick_mesh_renderer
	brick_transform
	last_brick_id
	brick_clothe_default_texture

	head_wear
	head_wear_res_url
	head_wear_res_loaded_and_show
	head_wear_skin_mesh_renderer
	default_head_go
	headWear_default_mainTexture
	headWear_transform
	headWear_gameObject
	last_head_wear_id
	head_wear_res_height
	last_head_clothe_id
	head_clothe
	headWear_animator

	waitStand_init_time
	horse_up_action_last_time
	last_anim_speed
	rush_speed
	last_wing_id
	alpha_flag
	alpha_flag_value_list
	rush_add_speed
	main_role_move_start_time
	last_horse_id

	last_back_id


	change_scene_id
	/**
 * 时装资源
 */
	clothe
	/**
* 时装资源名
*/
	fashion_res


	horse_down_action_last_time
	horse_res_loaded_and_show
	horse_res_size
	horse_move_effect_list
	horse_res_url
	horse_effect_dic
	horse_down_action_direction
	horse_up_action_start_time
	horse_down_action_start_time
	horse_gameObject: Laya.Sprite3D
	horse_transform: Laya.Transform3D
	horse_skin_mesh_renderer: Laya.SkinnedMeshSprite3D
	horse_animator: Laya.Animator

	wing_gameObject: Laya.Sprite3D
	wing_transform: Laya.Transform3D
	wing_animator: Laya.Animator
	wing_skin_mesh_renderer: Laya.SkinnedMeshSprite3D
	wing_res_url
	wing_effect_dic
	wing_res_loaded_and_show

	weapon_id
	weapon_clothe_id
	weapon_sprite_dic = {}
	weapon_hide_flag_list
	weapon_clothe_dic
	weapon_effect_dic

	//模型在坐骑上的高度
	model_height_in_horse = 0

	back_gameObject: Laya.Sprite3D
	back_transform: Laya.Transform3D
	back_animator: Laya.Animator
	back_skin_mesh_renderer: Laya.SkinnedMeshSprite3D
	back_res_url
	back_effect_dic
	back_res_loaded_and_show


	liveness_gameObject: Laya.Sprite3D
	liveness_transform: Laya.Transform3D
	liveness_res_url
	liveness_res_loaded_and_show
	last_liveness_id


	public static WeaponHideFlag = {
		Horse: 0x004, 	//上坐骑隐藏武器
		Collect: 0x080, //采集隐藏武器
		AllWeaponHideFlag: 0
	}

	public static AlphaFlag = {
		ModelHide: 0x002, 	//友方通过改变透明度来替换隐藏身体
		Ghost: 0x010, 	//幽灵模式半透明
		HorseUp: 0x020, 	//上坐骑
		HorseDown: 0x040, 	//下坐骑
		All: 0
	}


	public static MULTI_JUMP_TYPE = {
		Jump_1: 1, //仿重力跳跃
		Jump_2: 2, //斜向上跳出去 再慢慢落地
		Jump_3: 3, //战斗翻滚,只能跳一下
		Jump_4: 4, //任务两段跳跃
		Jump_5: 5, //任务三段跳跃
	}

	public constructor() {
		super()
		local_ResManager = ResManager
		this._type = local_SceneBaseType.Role

		if (!local_Role.WeaponHideFlag.AllWeaponHideFlag)
			local_Role.WeaponHideFlag.AllWeaponHideFlag = local_Role.WeaponHideFlag.Horse + local_Role.WeaponHideFlag.Collect
		if (!local_Role.AlphaFlag.All) {
			local_Role.AlphaFlag.All = local_Role.AlphaFlag.ModelHide + local_Role.AlphaFlag.Ghost + local_Role.AlphaFlag.HorseUp
				+ local_Role.AlphaFlag.HorseDown
		}


		//武器时装贴图资源
		this.weapon_clothe_id = false
		//每个武器对应的显示标记
		this.weapon_hide_flag_list = false
		this.last_jump_time = false

		this.show_horse_after_jump = false //坐骑id, 跳跃前需要先下坐骑

		this.headWear_gameObject = false
		this.headWear_transform = false
		this.headWear_animator = false
		this.last_head_wear_id = false
		this.last_head_clothe_id = false
		this.head_wear_skin_mesh_renderer = false
		this.head_wear_res_loaded_and_show = false
		this.jump_real_height = 0
		this.jump_start_height = 0

		this.role_mgr = RoleManager.GetInstance()
		this.mainrole_vo = this.role_mgr.mainRoleInfo



		this.alpha_flag = 0
		this.alpha_flag_value_list = false

		//武器时装贴图资源
		this.weapon_clothe_id = false
		//每个武器对应的显示标记
		this.weapon_hide_flag_list = false
		this.wing_animator = undefined
		this.wing_gameObject = undefined
		this.wing_transform = undefined
		this.wing_skin_mesh_renderer = undefined
		this.last_wing_id = false
		this.wing_res_loaded_and_show = false

		this.back_animator = undefined
		this.back_gameObject = undefined
		this.back_transform = undefined
		this.back_skin_mesh_renderer = undefined
		this.last_back_id = false
		this.back_res_loaded_and_show = false


		//坐骑动作控制器
		this.horse_animator = undefined
		//坐骑游戏对象
		this.horse_gameObject = undefined
		//坐骑变换
		this.horse_transform = null
		this.last_horse_id = false
		//坐骑资源大小 也就是衣服
		this.horse_res_size = new Vector2(90, 160)
		//坐骑资源是否加载完成并且显示出来
		this.horse_res_loaded_and_show = false
		// 坐骑需要在播放run时显示的特效
		this.horse_move_effect_list = []

		this._state_machine_manager.RegisterState(local_PoseState.JUMP, "EnterStateJump", "UpdateStateJump", "QuitStateJump", true);
		this._state_machine_manager.RegisterState(local_PoseState.TASK_JUMP, "EnterTaskStateJump", "UpdateTaskStateJump", "QuitTaskStateJump", true);
		this._state_machine_manager.RegisterState(local_PoseState.COLLECT, "EnterStateCollect", "UpdateStateCollect", "QuitStateCollect", true);


		this._state_machine_manager.RegisterState(local_PoseState.RUSH, "EnterStateRush", "UpdateStateRush", "QuitStateRush", true)
		this._state_machine_manager.RegisterState(local_PoseState.WAITSTAND, "EnterStateWaitStand", "UpdateStateWaitStand", "QuitStateWaitStand", true)
	}

	public Update(now_time?, elapse_time?) {

		if (!this.vo) {
			this.next_frame_funcs = null
			return
		}
		if (!local_Util.IsTableEmpty(this.next_frame_funcs)) {
			for (let i in this.next_frame_funcs) {
				var f = this.next_frame_funcs[i]
				if (f != null) {
					f()
				}
				this.next_frame_funcs[i] = null
			}
		}
		super.Update(now_time, elapse_time)
	}

	public Revived() {

		super.Revived()
		this.CreateFlower()
		this.ChangePartner()
		this.ChangeSprite()
	}

	public UnBindVo() {

		if (this.vo) {
			this.vo.ResetData()
			if (this.vo_bind_handlers) {
				let len = this.vo_bind_handlers.length
				for (var i = 0; i < len; i++) {
					var handler = this.vo_bind_handlers.pop()
					this.vo.UnBind(handler)
				}
				this.vo_bind_handlers = []
			}
			if (this.vo_ext_bind_handlers) {
				let len = this.vo_ext_bind_handlers.length
				for (var i = 0; i < len; i++) {
					var handler = this.vo_ext_bind_handlers.pop()
					this.vo.UnBind(handler)
				}
				this.vo_ext_bind_handlers = []
			}
			if (this.GetType() != local_SceneBaseType.MainRole) {
				this.vo.UnBindAll()
			}
			if (this.change_scene_id) {
				local_GlobalEventSystem.UnBind(this.change_scene_id)
			}
		}
	}

	public RemoveGameObject() {
		super.RemoveGameObject()

		if (this.clothe) {
			this.clothe.DeleteMe()
			this.clothe = null
		}
	}

	public ClearRole() {
		this.DeleteSprite()
		this.DeletePartner()
		this.DeleteDemon()
		this.DeleteShengqi()
		this.RemoveAllParticle()
		this.UnBindVo()
		this.fashion_res = null
		this.SetFashionModelRes(null)

		this.ShowAllWeapon(local_Role.WeaponHideFlag.AllWeaponHideFlag)

		this.alpha_flag = 0
		this.alpha_flag_value_list = null

		this.weapon_hide_flag_list = false
		this.weapon_id = null

		if (this.rush_info) {
			this.rush_info.rush_pos = null
		}

		if (this.GetType() != local_SceneBaseType.MainRole && this.vo) {
			this.scene_mgr.AddRoleVoPool(this.vo)
		}
		this.vo = false
		this.next_frame_funcs = null
	}

	public RemoveAllParticle() {

		if (this.speed_effect_id) {
			this.particle_mgr.DelEffect(this.speed_effect_id)
			this.speed_effect_id = false
		}
		if (this.offline_partical_id) {
			this.particle_mgr.DelEffect(this.offline_partical_id)
			this.offline_partical_id = false
		}
		super.RemoveAllParticle()
	}

	public DeleteMe() {
		this.ReleaseObj()
		super.DeleteMe()
	}

	public ReleaseObj() {
		this.DoStand()
		this.RemoveBrick()
		this.RemoveHeadWear()
		this.RemoveAttackAllWeapon()
		this.RemoveWing()
		this.RemoveHorse()
		this.RemoveBackOrnament()
		this.RemoveLiveness()
		this.ReleaseCharacter()
		this.ClearRole()
		this.is_dead = true
		this.is_to_dead = true
	}

	public ResetObj() {

		this.ResetCharacter()
	}

	public InitRoleVo(vo?) {

		this.vo = vo
		this.id = vo.role_id
		this.name = this.vo.name
		if (this.vo.is_fake_role) {
			this.compress_id = this.scene.CompressObjId(local_SceneBaseType.Fake_Role, this.id)
		} else {
			this.compress_id = this.scene.CompressObjId(local_SceneBaseType.Role, this.id)
		}
		if (this.vo.is_virtual_friend) {
			this.SetHideNameBord(true)
		} else {
			this.SetHideNameBord(false)
		}
		if (this.name_board) {
			this.name_board.SetHp(this.vo.hp, this.vo.maxHp)
		}
		this.UpdateName()
		this.ChangeModeHide()
		this.ChangeGhostMode()
		this.UpdateMarriage()
		this.UpdateGuildInfo()
		this.UpdateDsgt()
		this.UpdateWarGroup()
		this.BindVoEvents()
		this.UpdateVip()
		this.UpdateSuperVip()
		this.UpdateHideVip()
		// this.UpdateServerName()
		this.UpdateBossFlag()
		this.UpdateMedal()
		this.ChangeBrickId();

		let weapon_type = WeaponCountInfo.role[this.vo.career]
		let weapon_attach_list = []
		if (weapon_type == WeaponProvideType.SingleRightHand) {
			weapon_attach_list.push(AttachNode.RHand)
		}

		if (!this.weapon_hide_flag_list) {
			this.weapon_hide_flag_list = {}
		}

		for (let bone_name of weapon_attach_list) {
			this.weapon_hide_flag_list[bone_name] = 0
		}
	}

	//创建跟屁虫
	public CreateFlower() {
		this.ChangeGodId()
		this.ChangeDemon()
		this.ChangeShengqi()
		if (this.GetType() != local_SceneBaseType.MainRole) {
			this.ChangePartner()
			this.ChangeSprite()
		}
	}

	public UpdateFlowerPos() {
		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.GetFigureId(local_FigureProtoVo.FigureType.Partner) != 0 && !this.HasBlockSetting("partner")) {
			if (this.partner) {
				this.partner.SetShowPosition()
			}
		}

		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.GetFigureId(local_FigureProtoVo.FigureType.Sprite) != 0 && !this.HasBlockSetting("sprite")) {
			if (this.sprite) {
				this.sprite.SetShowPosition()
			}
		}


		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.demon_id != 0 && !this.HasBlockSetting("demon")) {
			if (this.demon) {
				this.demon.SetShowPosition()
			}
		}


		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.GetFigureId(local_FigureProtoVo.FigureType.Shengqi) != 0 && (this.IsMainRole() || !this.HasBlockSetting("shengqi"))) {
			if (this.shengqi) {
				this.shengqi.SetShowPosition()
			}
		}
	}

	public DeleteFlower() {

		this.DeleteSprite()
		this.DeletePartner()
		this.DeleteDemon()
		this.DeleteShengqi()
	}

	public LoadInfoFromVo() {

		this.SetMoveSpeed(this.vo.move_speed)
		let is_main_role
		if (this.GetType() == local_SceneBaseType.MainRole) {
			this.SetRealPos(this.vo.pos_x, this.vo.pos_y, true)
			is_main_role = true
		} else {
			is_main_role = false
			this.SetRealPos(this.vo.pos_x, this.vo.pos_y, true)
		}

		//主角的通过MainRoleVo:ChangeFromVo强制改变降神接口触发去调用
		if (this.GetType() != local_SceneBaseType.MainRole) {
			this.CreateFlower()
		}

		if (this.name_board) {
			this.name_board.SetHp(this.vo.hp, this.vo.maxHp)
		}

		this.ProtectChange()

		this.UpdateMedal()

		this.SetFirstState()

		if (!is_main_role) {
			local_GlobalEventSystem.Fire(local_EventName.UPDATE_OTHER_ROLE_HEAD, this.vo)
		}
	}

	public SetFirstState() {
		if (this.vo.hp == 0) {
			this.EnterStateDead() //直接播死亡动作，dodead不行
		} else if (this.GetCurState() == local_PoseState.MOVE) {
			this.EnterStateMove()
		} else if (this.IsInState(local_PoseState.JUMP)) {
			if (this.transform) {
				local_Set3DLocalPosition(this.transform, -this.logic_pos.x, -this.logic_pos.y, this.jump_start_height)
			}
		} else if (this.vo.collect_state) {
			this.DoCollect()
		} else {
			this.DoStand()
		}
	}

	public BindVoEvents() {

		super.BindVoEvents()
		this.next_frame_funcs = this.next_frame_funcs || {}

		//纯刷新名字
		let name_func = (oldVar1?, value?) => {
			if (this.next_frame_funcs && !this.next_frame_funcs["name_func"]) {
				let f = () => {
					this.UpdateName()
				}
				this.next_frame_funcs["name_func"] = f
			}
		}

		let vip_flag_func = () => {
			this.UpdateVip()
		}

		let is_hide_vip_func = () => {
			this.UpdateHideVip()
		}

		let check_supreme_vip = () => {
			this.UpdateSuperVip()
		}

		let hp_change_func = (oldVar1?, value?) => {
			if (this.name_board) {
				this.name_board.SetHp(value, this.vo.maxHp)
			}
			if (this.GetType() == local_SceneBaseType.Role) {
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_OTHER_ROLE_HEAD, this.vo)
			}
		}

		let maxhp_change_func = (oldVar1?, value?) => {
			if (this.name_board) {
				this.name_board.SetHp(this.vo.hp, value)
			}
			if (this.GetType() == local_SceneBaseType.Role) {
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_OTHER_ROLE_HEAD, this.vo)
			}
		}

		var move_speed_func = (oldVar1, value) => {
			this.SetMoveSpeed(value)
		}

		var war_group_func = (oldVar1, value) => {
			this.UpdateWarGroup()
		}

		var title_func = () => {
			this.UpdateMedal()
		}
		var guild_func = () => {
			this.UpdateGuildInfo()
		}

		var hide_flag_func = (oldVar1, value) => {
			this.ChangeModeHide()
		}

		var ghost_mode_func = (oldVar1, value) => {
			this.ChangeGhostMode()
		}

		var pk_status_func = () => {
			if (this.vo.role_id == this.role_mgr.GetMainRoleId()) {
				this.scene.update_role_name = true
			} else {
				name_func()
			}
		}

		var team_id_func = (oldVar1, value) => {
			if (this.vo.role_id == this.role_mgr.GetMainRoleId()) {
				this.scene.update_role_name = true
				// this.scene.update_role_mode = true
			} else {
				this.ChangeModeHide()
				name_func()
			}
		}

		var guild_id_func = (oldVar1, value) => {
			if (this.vo.role_id == this.role_mgr.GetMainRoleId()) {
				this.scene.update_role_name = true
				// this.scene.update_role_mode = true
			} else {
				this.ChangeModeHide()
				name_func()
			}
		}

		var fashion_func = () => {
			this.TryRoleClothChange()
		}
		var equip_func = (oldVar1, value) => {
			this.CreateWeaponSprite()
		}

		var update_dsgt_func = () => {
			this.UpdateDsgt()
		}

		var safe_area_state_func = () => {
			this.OnSafeAreaStateChange()
		}

		var marriage_change_func = () => {
			this.UpdateMarriage()
		}

		var boss_flag_change_func = () => {
			this.UpdateBossFlag()
		}

		var on_protect_change = () => {
			this.ProtectChange()
		}

		var god_id_change_func = (oldVar1, value, old_value) => {
			this.ChangeGodId(oldVar1, value, old_value)
		}


		let medal_func = (oldVar1?, value?) => {
			this.UpdateMedal(value)
		}

		let revelation_suit_func = () => {
			this.TryRoleClothChange()
		}

		let suit_fashion_func = () => {
			this.TryRoleClothChange()
			this.CreateWeaponSprite()
		}

		let onFigureChangeFunc = (figure_type?, figure_id?) => {
			if (figure_type == local_FigureProtoVo.FigureType.Horse) {
				this.HorseChange()
			} else if (figure_type == local_FigureProtoVo.FigureType.Wing) {
				this.ChangeWing()
			} else if (figure_type == local_FigureProtoVo.FigureType.BackOrnament) {
			} else if (figure_type == local_FigureProtoVo.FigureType.Weapon) {
				this.CreateWeaponSprite()
			} else if (figure_type == local_FigureProtoVo.FigureType.Partner) {
				this.ChangePartner()
			} else if (figure_type == local_FigureProtoVo.FigureType.Sprite) {
				this.ChangeSprite()
			} else if (figure_type == local_FigureProtoVo.FigureType.Shengqi) {
				this.ChangeShengqi()
			} else if (figure_type == 11) {
				fashion_func()
			} else if (figure_type == local_FigureProtoVo.FigureType.NewBackOrnament) {
				this.ChangeBackOrnament()
			}
		}

		let figure_list_func = (_, value) => {
			for (let v of value) {
				onFigureChangeFunc(v.figure_type, v.figure_id)
			}
			this.TryRoleClothChange()
		}

		let demon_func = () => {
			this.ChangeDemon()
		}

		let change_brick_id = (oldVar1?, value?, old_value?) => {
			this.ChangeBrickId(oldVar1, value, old_value)
		}

		let change_liveness_id = () =>{
			this.ChangeLiveness()
		}

		let change_collect_state = () => {
			this.ChangeCollectState()
		}

		let mask_func = () => {
			this.TryRoleClothChange()
			this.UpdateNameBoard()
			this.ChangeDemon()
			this.ChangePartner()
		}

		this.vo_bind_handlers = []
		this.vo_bind_handlers.push(this.vo.BindOne("maxHp", maxhp_change_func))
		this.vo_bind_handlers.push(this.vo.BindOne("hp", hp_change_func))
		this.vo_bind_handlers.push(this.vo.BindOne("name", name_func))
		this.vo_bind_handlers.push(this.vo.BindOne("vip_flag", vip_flag_func))
		this.vo_bind_handlers.push(this.vo.BindOne("is_hide_vip", is_hide_vip_func))
		this.vo_bind_handlers.push(this.vo.BindOne("supreme_vip", check_supreme_vip))
		this.vo_bind_handlers.push(this.vo.BindOne("move_speed", move_speed_func))
		this.vo_bind_handlers.push(this.vo.BindOne("warGroup", war_group_func))

		this.vo_ext_bind_handlers = []
		this.vo_ext_bind_handlers.push(this.vo.BindOne("title_id", title_func))
		this.vo_ext_bind_handlers.push(this.vo.BindOne("guild_name", guild_func))
		this.vo_ext_bind_handlers.push(this.vo.BindOne("guild_id", guild_id_func))
		this.vo_ext_bind_handlers.push(this.vo.BindOne("position", guild_func))
		this.vo_ext_bind_handlers.push(this.vo.BindOne("position_name", guild_func))
		this.vo_ext_bind_handlers.push(this.vo.BindOne("dsgt_id", update_dsgt_func))

		// this.vo_bind_handlers.push(this.vo.BindOne("show_base_info_only", base_info_show_func))
		this.vo_bind_handlers.push(this.vo.BindOne("hide_flag", hide_flag_func))
		this.vo_bind_handlers.push(this.vo.BindOne("ghost_mode", ghost_mode_func))
		this.vo_bind_handlers.push(this.vo.BindOne("pk_status", pk_status_func))
		this.vo_bind_handlers.push(this.vo.BindOne("team_id", team_id_func))
		this.vo_bind_handlers.push(this.vo.BindOne("fashion_model_list", fashion_func))
		this.vo_bind_handlers.push(this.vo.BindOne("level_model_list", equip_func))
		this.vo_bind_handlers.push(this.vo.BindOne("safe_area_state", safe_area_state_func))
		this.vo_bind_handlers.push(this.vo.BindOne("is_marriage", marriage_change_func))
		this.vo_bind_handlers.push(this.vo.BindOne("marriage_name", marriage_change_func))
		this.vo_bind_handlers.push(this.vo.BindOne("boss_flag", boss_flag_change_func))
		this.vo_bind_handlers.push(this.vo.BindOne("protect_time", on_protect_change))
		this.vo_bind_handlers.push(this.vo.BindOne("god_id", god_id_change_func))
		this.vo_bind_handlers.push(this.vo.BindOne("figure_list", figure_list_func))
		this.vo_bind_handlers.push(this.vo.BindOne("medal_id", medal_func))
		this.vo_bind_handlers.push(this.vo.BindOne("revelation_suit", revelation_suit_func))
		this.vo_bind_handlers.push(this.vo.BindOne("suit_fashion_id", suit_fashion_func))
		this.vo_bind_handlers.push(this.vo.BindOne("demon_id", demon_func))
		this.vo_bind_handlers.push(this.vo.BindOne("mask_id", mask_func))
		this.vo_bind_handlers.push(this.vo.BindOne("brick_id", change_brick_id))
		this.vo_bind_handlers.push(this.vo.BindOne("collect_state", change_collect_state))
		this.vo_bind_handlers.push(this.vo.BindOne("liveness_id", change_liveness_id))
		this.vo_bind_handlers.push(this.vo.Bind(RoleVo.FIGURE_CHANGE, onFigureChangeFunc))

		pk_status_func()
		this.change_scene_id = local_GlobalEventSystem.Bind(SceneManager.START, () => {
			this.UpdateNameBoard()
		})
	}

	public OnSafeAreaStateChange() {
		if (this.vo.role_id != this.mainrole_vo.role_id) {
			this.UpdateName()
		}
	}

	public ChangeModeHide() {

		if (this.scene_mgr.IsFriendlyRole(this.vo)) {
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, false)
			if (this.vo.hide_flag == 0) {
				this.SetAlphaFlag(local_Role.AlphaFlag.ModelHide, 1)
			} else {
				this.SetAlphaFlag(local_Role.AlphaFlag.ModelHide, 0.5)
			}
			// } else if (this.vo && this.vo.wedding_state_flags == Config.ConfigMarriage.WedingActivityFlag.VISITOR ) {
			//	 this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, true)
		} else {
			this.SetAlphaFlag(local_Role.AlphaFlag.ModelHide, 1)
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, (this.vo.hide_flag == 1))
			let state = !(this.vo.hide_flag == 1)
			this.SetFollowObjShowState(state, local_SceneObj.ModelHideFlag.ServerHide)
		}
	}

	public ChangeGhostMode() {

		if (this.scene_mgr.IsFriendlyRole(this.vo)) {
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, false)
			if (this.vo.ghost_mode == 0) {
				this.SetAlphaFlag(local_Role.AlphaFlag.Ghost, 1)
			} else {
				this.SetAlphaFlag(local_Role.AlphaFlag.Ghost, 0.5)
			}
		} else {
			this.SetAlphaFlag(local_Role.AlphaFlag.Ghost, 1)
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, (this.vo.ghost_mode == 1))
			let state = !(this.vo.ghost_mode == 1)
			this.SetFollowObjShowState(state, local_SceneObj.ModelHideFlag.ServerHide)
		}
	}

	public UpdateName() {

		if (this.vo && this.name_board) {
			let mainRole_info = this.mainrole_vo
			let color = "#ffef67"
			let show_name = ""
			color = this.vo.hatred > 0 && "#de4141" || "#ffef67"

			let is_arena_scene = this.scene_mgr.IsArenaFightScene()	//竞技场血条颜色由自身控制

			if (this.vo.role_id != mainRole_info.role_id) {

				if (!is_arena_scene) {
					if (this.scene_mgr.IsCanAttackByMainRole(this.vo, null, null, true)) {
						this.name_board.SetRedBar()
					} else {
						this.name_board.SetGreenBar()
					}
				}
			} else {
				this.name_board.SetGreenBar()
			}

			if (this.InMaskState()) {
				show_name = "蒙面人"
			} else {
				show_name = this.vo.name
			}

			if (this.scene_mgr.InServerScene() && !this.InMaskState() && this.vo.server_id) {
				show_name = "S" + this.vo.server_id + "." + show_name
				// if (this.IsMainRole()) {
				// 	show_name = "S" + this.vo.server_id + "." + show_name
				// } else {
				// 	show_name = "S" + this.vo.server_num + "." + show_name
				// }
			}

			this.name_board.SetName(show_name, color)
			this.name_board.SetHpVisible(true)
		}
	}

	public UpdateWarGroup() {

		if (this.name_board) {
			if (this.scene_mgr.IsHolyBattleFightScene()) {
				let group_url = ""
				if (this.vo.warGroup == 1) {
					group_url = "uifh_005"
				} else if (this.vo.warGroup == 2) {
					group_url = "uifh_006"
				} else if (this.vo.warGroup == 3) {
					group_url = "uifh_004"
				}
				if (group_url != "") {
					this.name_board.SetGroupIcon("mainUI_asset", group_url)
				}
			} else {
				this.name_board.ClearGroupIcon()
				this.UpdateName()
			}
		}
	}

	public UpdateDsgt() {

		if (this.vo && this.name_board) {
			if (!(this.scene_mgr.IsPolarDungeon() || this.scene_mgr.IsKFPolarDungeon()) && this.vo.dsgt_id != 0 && !this.InMaskState()) {
				let data = Config.PRELOAD_SERVER_CONFIG.config_dsgt[this.vo.dsgt_id]
				if (data) {
					if (data.type == 1) {
						this.name_board.SetDsgtEffect(data.id)
					} else {
						this.name_board.SetDsgtImg(data.id, data.main_type, this.vo.marriage_name)
					}
				}
				this.ChangeDsgt()
			} else {
				if (this.name_board) {
					this.name_board.ClearDsgt()
				}
			}
		}
	}


	public UpdateVip() {

		if (this.vo && this.name_board) {
			if (this.InMaskState()) {
				this.name_board.SetVipLevel(0)
			} else {
				this.name_board.SetVipLevel(this.vo.vip_flag, this.vo.is_hide_vip)
			}
		}
	}

	public UpdateSuperVip() {

		if (this.vo && this.name_board) {
			if (this.InMaskState()) {
				this.name_board.SetSuperVipLevel(0)
			} else {
				this.name_board.SetSuperVipLevel(this.vo.supreme_vip, this.vo.vip_flag, this.vo.is_hide_vip)
			}
		}
	}

	public UpdateHideVip() {
		if (this.vo && this.name_board) {
			if (this.InMaskState()) {
				this.name_board.SetVipShowOrHide(0)
			} else {
				this.name_board.SetVipShowOrHide(this.vo.supreme_vip, this.vo.is_hide_vip, this.vo.vip_flag)
			}
		}
	}


	public ChangeBrickId(oldVar1?, value?, old_value?) {

		value = value || this.vo.brick_id
		if (this.GetType() == local_SceneBaseType.MainRole) {
			SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.ASSERT_BRICK_ID_CHANGE)
		}

		if (this.IsDead()) {
			return
		}

		if (value > 0) {
			this.HideAllWeapon()
			this.HideWing()

			this.ShowHeadWear(true)
			this.ShowBackOrnament(true)
			this.ShowLiveness(true)
			// if ((!this.brick_sprite3d || value != this.last_brick_id) && !this.loading_brick) {
			// 	this.LoadBrickRes()
			// }

			if (this.IsOnHorse()) {
				this.DownHorse()
			}
			if (this.name_board) {
				this.name_board.SetBrickVisible(true, value)
			}

			SkillManager.Instance.setCurrentSkillId()
			this.TryRoleClothChange()

			//下马可能之前存在标志，导致模型透明
			if (this.alpha_flag_value_list) {
				delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseUp]
				delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseDown]
			}
		} else {
			this.RemoveBrick()
			this.ShowAllWeapon()
			this.ShowWing()
			this.ShowBackOrnament()
			this.ShowLiveness()

			if (old_value && old_value > 0) {
				local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, false)
			}
			if (this.name_board) {
				this.name_board.SetBrickVisible(false)
			}
		}
	}

	public ChangeGodId(oldVar1?, value?, old_value?) {
		if (!this.vo) {
			return
		}
		value = value || this.vo.god_id
		if (value > 0 && old_value && old_value <= 0 && this.GetType() == local_SceneBaseType.MainRole) {
			this.play_change_god_action = true
		} else {
			this.play_change_god_action = false
		}
		let god_model_scale = this.vo.GetGodModelScale() || 1
		if (this.GetType() == local_SceneBaseType.MainRole) {
			if (value > 0) {
				if (this.GetHorseId() > 0) {
					local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, true)
				}
				if (this.scene.GetMainRole()) {
					this.scene.GetMainRole().EnterFightingState(6)
				}
			}
			//可能之前在打怪,用的不是降神技能，所以需要重新选择技能
			SkillManager.Instance.setCurrentSkillId()
			SkillManager.Instance.ClearCachedSkill()
			this.scene.UpdateAutoFight()
		}

		//下马可能之前存在标志，导致模型透明
		if (this.alpha_flag_value_list) {
			delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseUp]
			delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseDown]
		}

		this.SetScale(god_model_scale)
		this.TryRoleClothChange()
	}

	//保护时间变化
	public ProtectChange() {

		this.ShowOfflineEffect(this.vo.protect_time && this.vo.protect_time - TimeUtil.getServerTime() > 0)
	}

	//是否在保护时间内
	public IsInProtectTime() {

		return this.vo.protect_time && this.vo.protect_time - TimeUtil.getServerTime() > 0
	}


	//更新婚姻状态
	public UpdateMarriage() {
		this.UpdateDsgt() // 更新伴侣动态称号
	}

	//boss归属
	public UpdateBossFlag() {

		if (this.vo && this.name_board) {

			let res
			let bool = false
			if (this.vo.boss_flag == 1) {
				res = "ui_drop_flag"
				bool = true
			} else if (this.vo.boss_flag == 100) {
				res = "uiboss_064"
				bool = true
			}
			this.name_board.SetBossFlag(bool, res)
		}
	}

	public UpdateGuildInfo() {

		let guild_text = ""
		if (this.vo && this.name_board) {
			let position = this.vo.position
			let position_name = this.vo.position_name
			let guild_id = this.vo.guild_id

			if (position == null || position_name == null || guild_id == null) {
				return
			}

			//没有结社
			if (guild_id == 0 || this.InMaskState()) {
				this.name_board.SetGuildText(guild_text)
				return
			}

			//星灵副本不显示结社
			if (this.vo.role_id == this.mainrole_vo.role_id) {
				if (this.scene_mgr.IsStarDungeonScene()) {
					this.name_board.SetGuildText(guild_text)
					return
				}
			}

			let guild_name = this.vo.guild_name || ""

			if (position_name != "") {
				guild_text = guild_name + "." + position_name
			} else {
				guild_text = guild_name
			}
			this.name_board.SetGuildText(guild_text)
		}
	}

	public EnterStateAttack(state_name?) {

		super.EnterStateAttack(state_name)

		if (this.IsOnHorse()) {
			this.DownHorse()
		}

		let cfg = this.movie_cfg
		let t = this.s_attack_state
		let anim_name = ""
		if (cfg == null || cfg.anim == null) {
			return
		}
		anim_name = cfg.anim
		this.PlayAction(anim_name)

	}
	public QuitStateAttack(state_name?) {

		if (!this.vo) {
			return
		}
		super.QuitStateAttack(state_name)
	}

	public DoBeAttacked(dir?, pos?, force_hited?, movie_cfg?, attacker?, skill_id?) {

		let can_be_attacked = super.DoBeAttacked(dir, pos, force_hited, movie_cfg, attacker, skill_id)
		if (can_be_attacked && pos != null) {
			if (this.ChangeState(local_PoseState.HITED)) {
				let t = {
					start_time: local_Status.NowTime,
					total_time: null,
					stop_time: null,
					start_pos: null,
					end_pos: null,
				}

				t.total_time = this.normal_hited_totalTime
				t.stop_time = local_Status.NowTime + t.total_time
				t.start_pos = new local_Vector2(this.real_pos.x, this.real_pos.y)
				t.end_pos = pos
				this.s_hited_info = t
			}
		} else {
			if (this.GetType() == local_SceneBaseType.MainRole) {
				if (this.scene_mgr.IsCSPvP()) { //3v3打断采集
					local_GlobalEventSystem.Fire(local_EventName.CANCEL_TO_COLLECT)
				}
			}
		}
		return can_be_attacked
	}


	//获得每个职业每个跳跃动作的校正值
	public GetJumpMoveSpeedOff(jump_name?, is_task?) {
		let value = this.vo.god_id > 0 && this.vo.god_id || (this.vo.career + "@" + this.vo.sex)
		let config_vo
		if (is_task) {
			config_vo = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.task_jump_move_movie_speed_off[value]
		} else {
			config_vo = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_move_movie_speed_off[value]
		}
		if (config_vo) {
			return config_vo[jump_name] || 0.25
		}
		return 0.25
	}

	public CanJump(is_scene_trigger?, is_shoe_jump?, is_task_jump?) {

		return true
	}

	//end_pos:像素坐标
	public DoJump(end_pos?, is_scene_trigger?, start_pos?, move_hspeed?, move_vspeed?, jump_type?, is_shoe_jump?, call_back?, show_effect?, init_end_pos?, is_fight_jump?, next_jump_ratio?, attack_delay_jump?, is_jupm_point?, is_last?) {

		if (!this.CanJump(is_scene_trigger, is_shoe_jump, false)) {
			return false
		}
		if (jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3) {
			if (this.is_normal_jumping) {
				console.log("还在正常跳跃，无法战斗翻滚")
				return
			}
		}
		this.is_shoe_jump = is_shoe_jump
		this.is_fight_jump = jump_type && (jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3)
		this.curr_multi_jump_type = jump_type || local_Role.MULTI_JUMP_TYPE.Jump_1

		if (!is_scene_trigger && !is_shoe_jump && this.cur_jump_count && this.cur_jump_count >= 3) {
			return false
		}

		start_pos = start_pos || new local_Vector2(this.real_pos.x, this.real_pos.y)
		let move_dir = new local_Vector2(end_pos.x - start_pos.x, end_pos.y - start_pos.y)

		let distance = move_dir.normalise()

		this.cur_jump_count = this.cur_jump_count || 0
		this.cur_jump_count = this.cur_jump_count + 1

		move_hspeed = this.GetMoveSpeed(move_dir, move_hspeed || Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_hspeed[this.curr_multi_jump_type])
		this.is_scene_trigger = is_scene_trigger
		move_vspeed = move_vspeed || Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_vspeed[this.curr_multi_jump_type] //* 1 / this.cur_jump_count

		let move_time = distance / move_hspeed
		let init_move_time = move_time
		if (init_end_pos && init_end_pos != end_pos) {
			let init_move_dir = new local_Vector2(init_end_pos.x - start_pos.x, init_end_pos.y - start_pos.y)
			let init_distance = init_move_dir.normalise()
			init_move_time = init_distance / move_hspeed
		}
		if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_2) {
			move_time = distance / (move_hspeed * 0.5)
		}
		let hspeed_stop_time = move_time//水平速度什么时候减速到零

		let curr_dist = new local_Vector2(this.real_pos.x - start_pos.x, this.real_pos.y - start_pos.y).normalise()
		let curr_time = curr_dist / move_hspeed

		this.jump_height = this.jump_height || 0
		this.jump_curr_height = this.jump_curr_height || 0
		this.jump_curr_time = this.jump_curr_time || 0
		let jump_action_list = []
		if (this.cur_jump_count % 3 == 1) {
			let config_vo = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_name_list[this.mainrole_vo.career + "@" + this.mainrole_vo.sex]
			if (config_vo) {
				jump_action_list = local_Util.DeepCopy(config_vo)
			}
		} else if (this.jump_info) {
			jump_action_list = this.jump_info.jump_action_list
		}

		if (jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3) { //翻滚的移动时间改为固定值
			let temp = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_move_distance[3]
			move_time = temp / move_hspeed
		}

		let start_height = this.scene.GetZoneHeight(start_pos.x / local_SceneObj.GetLogicRealRatio().x, start_pos.y / local_SceneObj.GetLogicRealRatio().y) //起跳点的高度
		if (this.jump_start_height != 0) {
			start_height = this.jump_start_height
		} else {
			this.jump_start_height = start_height
		}

		let end_height = this.scene.GetZoneHeight(end_pos.x / local_SceneObj.GetLogicRealRatio().x, end_pos.y / local_SceneObj.GetLogicRealRatio().y) //落地点的高度
		let gravity_speed = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_gravity_speed[this.curr_multi_jump_type]

		// move_vspeed = move_vspeed * 10 //测试
		let upTime = move_vspeed / gravity_speed || 0 // 上升时间
		let max_height = 0.5 * gravity_speed * upTime * upTime + this.jump_height //最大跳跃高度 1/2 at2
		let downDis = start_height * 100 + max_height - end_height * 100
		downDis = Math.abs(downDis)
		let downTime = Math.sqrt(2 * downDis / gravity_speed)//下降的总时间
		let total_time = upTime + downTime //总体运动时间
		// console.warn("------Role@doJump------", upTime, downTime, total_time, downDis, max_height)

		let cur_height = 0
		if (this.jump_height == 0) {
		} else {
			cur_height = this.jump_real_height //起跳点的高度
		}
		next_jump_ratio = next_jump_ratio || 1

		if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3) { //翻滚跳跃的总时间
			total_time = move_time
		} else {
			this.is_normal_jumping = true //正在正常跳跃，设定：正常跳跃过程中，不能战斗翻滚，要等普通跳跃结束后才能战斗翻滚
			//纠正水平移动和竖直移动的时间
			// if(hspeed_stop_time > total_time){
			hspeed_stop_time = total_time - 0.02
			move_hspeed = distance / hspeed_stop_time
			// }
		}

		this.jump_info = {
			start_time: local_Status.NowTime,
			max_height: max_height,
			pre_jump_time: curr_time > 0 && 0 || 0.1,
			move_time: total_time, //总的运动过程的时间
			init_move_time: init_move_time,
			middle_time: upTime, //达到最高点的时间
			curr_time: 0, //当前位置经过的时间
			fall_stay_time: total_time + (Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_fall_stay_time[this.curr_multi_jump_type + "@" + this.vo.career] || 0.1), //当前位置经过的时间
			end_pos: end_pos,
			start_pos: start_pos,
			pass_distance: 0,
			move_hspeed: move_hspeed,
			move_vspeed: move_vspeed,
			hspeed_stop_time: hspeed_stop_time,
			move_dir: move_dir,
			jump_action_list: jump_action_list,
			distance: distance,
			is_shoe_jump: is_shoe_jump,
			callback: call_back,
			show_effect: show_effect,
			init_end_pos: init_end_pos,
			downTime: downTime,
			cur_pass_distance: 0,
			a: gravity_speed,
			start_height: this.jump_height || 0, //起跳时候的高度差地面起跳为 0 空中起跳则是有值
			next_jump_ratio: next_jump_ratio * total_time //下一次起跳的时间间隔 用于跳跃点的连续跳跃
		}

		if (!is_scene_trigger) {
			this.last_jump_time = local_Status.NowTime
		}

		this.SetDirection(move_dir, null, null, true)
		if (this.ChangeState(local_PoseState.JUMP) == false) {
			return false
		}
		this.is_jupm_point = is_jupm_point
		this.is_last_jump_point = is_last
		if (this.GetType() == local_SceneBaseType.MainRole && this.jump_info) {
			AutoFightManager.GetInstance().CacheGoToPos()
			if (this.is_fight_jump) {
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.FIGHT_START_JUMP, this.jump_info.start_pos.x, this.jump_info.start_pos.y)
			} else if (this.is_jupm_point) {
				if (!is_last) {
					local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.real_pos.x, this.real_pos.y, local_MOVE_TYPE.JUMP_POINT, this.real_pos.x, this.real_pos.x)
				} else {
					// local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.JUMP_POINT_END, this.jump_info.start_pos.x, this.jump_info.start_pos.y)
				}
			} else {
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.START_JUMP, this.jump_info.start_pos.x, this.jump_info.start_pos.y)
			}
		}
		return true
	}

	public GetJumpEndPos(end_pos?, jump_type?) {
		let start_pos = new local_Vector2(this.real_pos.x, this.real_pos.y)
		let start_height = this.scene.GetZoneHeight(start_pos.x / local_SceneObj.GetLogicRealRatio().x, start_pos.y / local_SceneObj.GetLogicRealRatio().y) //起跳点的高度
		let end_height = this.scene.GetZoneHeight(end_pos.x / local_SceneObj.GetLogicRealRatio().x, end_pos.y / local_SceneObj.GetLogicRealRatio().y) //落地点的高度
		jump_type = jump_type || local_Role.MULTI_JUMP_TYPE.Jump_1
		let a = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_gravity_speed[jump_type]
		let upTime = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_vspeed[jump_type] / a || 0 // 上升时间
		let max_height = 0.5 * a * upTime * upTime + this.jump_height//最大跳跃高度 1/2 at2
		let downDis = start_height * 100 + max_height - end_height * 100
		let downTime = Math.sqrt(2 * downDis / a)//下降的总时间
		let total_time = upTime + downTime //总体运动时间
		let dir = new local_Vector2(end_pos.x - start_pos.x, end_pos.y - start_pos.y)
		dir.normalise()
		dir.x *= total_time * Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_hspeed[jump_type]
		dir.y *= total_time * Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_hspeed[jump_type]
		end_pos.x = start_pos.x + dir.x
		end_pos.y = start_pos.y + dir.y
		return new local_Vector2(end_pos.x, end_pos.y)
	}

	public EnterStateJump(state_name?) {

		this.BeforeJumpHandler()
		let jump_name = "jump"
		//降神跳跃用固定动画
		if (this.vo && this.vo.god_id <= 0) {
			if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_1) {
				if (this.jump_info && this.jump_info.jump_action_list) {
					let jump_action_list = this.jump_info.jump_action_list
					if (jump_action_list) {
						//Math.randomseed(os.time())
						let index = local_Util.RandomRange(0, jump_action_list.length - 1)
						jump_name = jump_action_list[index]
						if (jump_action_list.length > 1) {
							table.remove(jump_action_list, index)
						}
					}
				}
			} else if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_2) {
				this.SetPlaySpeed(0.5)
				jump_name = "jump10"
			} else if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3) {
				jump_name = "jump"
			}
		}
		if (this.vo.CheckIsGod && this.vo.CheckIsGod()) {
			jump_name = "idle"
		}
		this.PlayAction(jump_name)
		let movie_speed_off = this.GetJumpMoveSpeedOff(jump_name)
		// console.warn("------EnterStateJump------", movie_speed_off)
		let pos = new Vector3(this.real_pos.x, this.real_pos.y, this.jump_start_height * 100 + this.jump_height)
		if (this.GetType() == local_SceneBaseType.MainRole) {
			SoundManager.GetInstance().PlaySoundEffect("jump", true, null, "role")
			if (this.jump_info && this.jump_info.show_effect) {
				//显示凤凰特效
				this.particle_mgr.AddPosEffect("char_jumpfx_02", pos, null, null, this.GetDirection(), null, this.compress_id, null, null, this.vo.particle_priority, null, null, null, null, null, EffectResType.Other)

			}
			if (this.cur_jump_count && this.cur_jump_count > 1) {
				//中间借力条
				this.particle_mgr.AddPosEffect("char_jumpfx_01", pos, null, null, this.GetDirection(), null, this.compress_id, null, null, this.vo.particle_priority, null, null, null, null, null, EffectResType.Other)
			} else {
				//起跳特效
				this.particle_mgr.AddPosEffect("effect_jump_qitiaoyan", pos, null, null, this.GetDirection(), null, this.compress_id, null, null, this.vo.particle_priority, null, null, null, null, null, EffectResType.Other)
			}
		}
		if (this.jump_info) {
			this.SetPlaySpeed((1 + movie_speed_off) / (this.jump_info.fall_stay_time + this.jump_info.pre_jump_time - this.jump_info.curr_time))
		}

	}

	public UpdateStateJump(state_name?, elapse_time?) {

		let jump = this.jump_info
		if (jump == null) {
			return
		}

		//经过的总时间
		let past_total_time = local_Status.NowTime - jump.start_time
		//移动过程经过的总时间
		let past_move_time = past_total_time - jump.pre_jump_time + jump.curr_time

		// console.warn("------UpdateStateJump------", past_total_time, past_move_time)
		//起跳动作时长
		if (past_total_time < jump.pre_jump_time) {
			// console.warn("------UpdateStateJump1------", past_total_time, jump.pre_jump_time)
			if (this.GetType() == local_SceneBaseType.MainRole && jump.pass_distance == 0) {
				jump.pass_distance = 0.01
				if (this.is_jupm_point) {
					// local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.JUMP_POINT, jump.start_pos.x, jump.start_pos.y)
				} else {
					local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.JUMP, jump.start_pos.x, jump.start_pos.y)
				}
			}
			//运动过程
		} else if (past_move_time < jump.move_time) {
			// console.warn("------UpdateStateJump2------", past_move_time, jump.move_time)
			if (this.GetType() == local_SceneBaseType.MainRole && past_move_time >= jump.next_jump_ratio) {
				this.scene.CheckJumpPoint(true)
			}

			let p = past_move_time / jump.move_time //经过的时间和总时间百分比 从0 逐渐到 1
			if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_1) { //or this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3  //翻滚就不需要高度了
				this.jump_curr_time = past_move_time
				if (past_move_time <= jump.middle_time) {

					p = past_move_time / jump.middle_time
					let curr_vspeed = (1 - p) * jump.move_vspeed

					let h = jump.start_height + jump.move_vspeed * past_move_time - 0.5 * jump.a * past_move_time * past_move_time
					this.jump_height = h

					this.SetBodyXY(0, this.jump_height)
					this.jump_curr_height = this.jump_height
					this.jump_real_height = this.jump_curr_height + jump.start_height * 100
					// console.warn("------UpdateStateJump211------", past_move_time, jump.middle_time, h)

				} else { //下降过程

					p = (past_move_time - jump.middle_time) / jump.downTime
					let curr_vspeed = jump.move_vspeed * p
					let downTime = past_move_time - jump.middle_time
					let h = this.jump_curr_height - (0.5 * jump.a * downTime * downTime)
					this.jump_height = h
					this.jump_real_height = h + jump.start_height * 100
					// console.warn("------UpdateStateJump212------", h)
					this.SetBodyXY(0, h)
				}
			} else if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_2) {
				let move_vspeed = jump.move_vspeed * past_move_time
				if (move_vspeed >= 0) {
					this.jump_height = this.jump_height + move_vspeed * elapse_time
					if (this.jump_height < 0) {
						this.jump_height = 0
					}

					this.SetBodyXY(0, this.jump_height)
					this.jump_curr_height = this.jump_height
					jump.middle_time = past_move_time
				} else {
					if (!jump.has_play_jump11) {
						this.PlayAction("jump11", null, 0.2)
						let movie_speed_off = this.GetJumpMoveSpeedOff("jump11")
						let total_dist = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_move_distance[this.curr_multi_jump_type] || 800
						this.SetPlaySpeed(total_dist / this.jump_info.distance * (1 + movie_speed_off))
						jump.has_play_jump11 = true
					}
					let h = (1 - Math.pow((past_move_time - jump.middle_time) / (jump.move_time - jump.middle_time), 1.3)) * this.jump_curr_height
					this.SetBodyXY(0, h)
				}
			}
			if (past_move_time < jump.hspeed_stop_time) { //水平移动
				// console.warn("------UpdateStateJump221------", past_move_time, jump.hspeed_stop_time)
				let move_hspeed = jump.move_hspeed
				if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_2) {
					move_hspeed = jump.move_hspeed * (1 - p)
				}
				let main_role_pos = this.GetRealPos()
				let x = main_role_pos.x, y = main_role_pos.y
				let dist = move_hspeed * elapse_time
				//这里要判断一下移动的距离是否会超过最大距离，会出现最后一帧速度 x 时间 超过最大距离的情况，这种情况有可能会陷入到不可行走区域
				let max = jump.distance - jump.cur_pass_distance
				if (max < dist) {
					dist = max
				}
				jump.cur_pass_distance = jump.cur_pass_distance + dist
				x = x + jump.move_dir.x * dist
				y = y + jump.move_dir.y * dist
				if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3) { //战斗翻滚还是需要加上当时地面高度的
					this.SetRealPos(x, y, false, false)
				} else {
					this.SetRealPos(x, y, false, true)
				}
				if (this.GetType() == local_SceneBaseType.MainRole) {
					jump.pass_distance = jump.pass_distance + dist
					if (jump.pass_distance >= 120) {
						if (this.is_jupm_point) {
							// local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.JUMP_POINT, jump.start_pos.x, jump.start_pos.y)
						} else {
							local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.JUMP, jump.start_pos.x, jump.start_pos.y)
						}
						// local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.JUMP, jump.start_pos.x, jump.start_pos.y)
						jump.pass_distance = 0
					}
				}
			} else {
				// console.warn("------UpdateStateJump222------", past_move_time)
				let main_role_pos = this.GetRealPos()
				let x = main_role_pos.x, y = main_role_pos.y
				if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3) {
					this.SetRealPos(x, y, false, false)
				} else {
					this.SetRealPos(x, y, false, true)
				}
			}

		} else if (past_move_time <= jump.fall_stay_time) {
			// console.warn("------UpdateStateJump3------", past_move_time, jump.fall_stay_time)
			this.jump_curr_height = 0
			this.jump_curr_time = 0
			this.jump_real_height = 0
			this.jump_start_height = 0
			this.SetBodyXY(0, 0)
			this.jump_height = 0
			this.SetRealPos(jump.end_pos.x, jump.end_pos.y, false, false)
		} else {
			if (this.GetType() != local_SceneBaseType.MainRole || !this.scene.CheckJumpPoint()) {
				// console.warn("跳跃结束 整个跳跃经过时间 ", past_move_time)
				this.is_normal_jumping = false
				this.DoStand()
			}
		}
	}

	public QuitStateJump(state_name?) {

		if (this.is_last_jump_point) {
			this.is_last_jump_point = false
			this.jump_curr_trigger_index = null
			this.jump_curr_trigger_index_child = null
			// console.warn("------QuitStateJump------")
			local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.JUMP_POINT_END, this.jump_info.start_pos.x, this.jump_info.start_pos.y)
		}
		if (this.GetCurState() != local_PoseState.JUMP) {
			this.cur_jump_count = 0
			this.SetBodyXY(0, 0)
			this.jump_height = 0
			this.SetPlaySpeed(1)
			if (this.GetType() == local_SceneBaseType.MainRole) {

				if (this.is_shoe_jump) { //飞鞋暂时强制用瞬移
					local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.BLINK)
				} else {
					if (this.jump_info) {
						if (this.is_jupm_point) {
							// local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.JUMP_POINT, this.jump_info.start_pos.x, this.jump_info.start_pos.y)
						} else {
							local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.JUMP, this.jump_info.start_pos.x, this.jump_info.start_pos.y)
						}
						// local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.jump_info.end_pos.x, this.jump_info.end_pos.y, local_MOVE_TYPE.JUMP, this.jump_info.start_pos.x, this.jump_info.start_pos.y)
					}
				}

				this.jump_area_mutil_jump_end_time = null
				local_Laya.timer.frameOnce(1, this, () => {
					local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_JUMP_END, true) //避免被stand状态切掉
				})
				local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_JUMP_END_IMM)
				this.is_scene_trigger = null
				this.is_shoe_jump = null
				OperateManager.GetInstance().JumpEndHandler()
			}
			if (this.jump_info && this.jump_info.callback) {
				this.jump_info.callback()
			}

			//如果是战斗跳跃 则清除
			if (this.curr_multi_jump_type == local_Role.MULTI_JUMP_TYPE.Jump_3) {
				this.curr_multi_jump_type = null
			}
			this.jump_info = null

			this.is_fight_jump = null
			this.AfterJumpHandler()
			this.is_last_jump_point = false
			this.jump_curr_trigger_index = null
			this.jump_curr_trigger_index_child = null
		}

	}

	public DoTaskJump(task_jump_type, target_list, call_back, move_vspeed, gravity_speed, is_task_jump) {


		if (!this.CanJump(false, false, is_task_jump)) {
			return false
		}

		this.task_jump_type = task_jump_type || this.task_jump_type
		this.task_target_list = target_list || this.task_target_list
		this.task_callback = call_back || this.task_callback
		this.task_move_vspeed = move_vspeed || this.task_move_vspeed
		this.task_gravity_speed = gravity_speed || this.task_gravity_speed

		this.is_task_jump = true

		this.task_cur_jump_count = this.task_cur_jump_count || 0
		this.task_cur_jump_count = this.task_cur_jump_count + 1

		if (!this.task_target_list || this.task_target_list.length == 0) {
			return
		}

		let last_end_pos = this.task_target_list[this.task_target_list.length - 1]

		let start_pos = new local_Vector2(this.real_pos.x, this.real_pos.y)
		let end_pos = this.task_target_list.shift()

		let move_dir = new local_Vector2(end_pos.x - start_pos.x, end_pos.y - start_pos.y)

		let distance = move_dir.normalise()

		move_vspeed = end_pos.speed || this.task_move_vspeed || Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_vspeed[this.task_jump_type]

		this.jump_height = this.jump_height || 0
		this.jump_curr_height = this.jump_curr_height || 0

		let jump_action_list = []
		if (this.task_cur_jump_count == 1) {
			let config_vo = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_name_list[this.mainrole_vo.career + "@" + this.mainrole_vo.sex]
			if (config_vo) {
				jump_action_list = local_Util.DeepCopy(config_vo)
			}
		} else if (this.task_jump_info) {
			jump_action_list = this.task_jump_info.jump_action_list
		}


		let start_height = this.scene.GetZoneHeight(start_pos.x / local_SceneObj.GetLogicRealRatio().x, start_pos.y / local_SceneObj.GetLogicRealRatio().y) //起跳点的高度
		if (this.jump_start_height != 0) {
			start_height = this.jump_start_height
		} else {
			this.jump_start_height = start_height
		}

		let end_height = this.scene.GetZoneHeight(end_pos.x / local_SceneObj.GetLogicRealRatio().x, end_pos.y / local_SceneObj.GetLogicRealRatio().y) //落地点的高度

		if (SceneManager.GetInstance().IsBlockXY(end_pos.x / local_SceneObj.GetLogicRealRatio().x, end_pos.y / local_SceneObj.GetLogicRealRatio().y)) {
			end_height = start_height
		}
		let a = end_pos.gravity_speed || this.task_gravity_speed || Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_gravity_speed[this.task_jump_type]
		console.warn("------DoTaskJump------", move_vspeed, a, end_pos)
		let upTime = move_vspeed / a || 0 // 上升时间
		let max_height = 0.5 * a * upTime * upTime + this.jump_height //最大跳跃高度 1/2 at2
		let downDis = start_height * 100 + max_height - end_height * 100
		//兼容一些地形高度差，防止跳不上去
		// if (downDis < 50) {
		// 	downDis = 250
		// }
		let downTime = Math.sqrt(2 * downDis / a)//下降的总时间
		let total_time = upTime + downTime //总体运动时间

		let move_hspeed = distance / total_time
		let hspeed_stop_time = total_time //水平速度什么时候减速到零

		let next_jump_time = this.task_target_list.length > 0 && (total_time - 0.1) || 0

		this.task_jump_info = {
			start_time: local_Status.NowTime,
			max_height: max_height,
			pre_jump_time: 0,
			move_time: total_time, //总的运动过程的时间
			middle_time: upTime, //达到最高点的时间
			curr_time: 0, //当前位置经过的时间
			fall_stay_time: total_time + (Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.jump_fall_stay_time[this.task_jump_type + "@" + this.vo.career] || 0.1), //当前位置经过的时间
			end_pos: end_pos,
			start_pos: start_pos,
			pass_distance: 0,
			move_hspeed: move_hspeed,
			move_vspeed: move_vspeed,
			hspeed_stop_time: hspeed_stop_time,
			move_dir: move_dir,
			jump_action_list: jump_action_list,
			distance: distance,
			callback: this.task_callback,
			downTime: downTime,
			cur_pass_distance: 0,
			a: a,
			start_height: this.jump_height || 0, //起跳时候的高度差地面起跳为 0 空中起跳则是有值
			next_jump_time: next_jump_time,
			show_effect: false,
		}

		this.SetDirection(move_dir, null, null, true)
		if (this.ChangeState(local_PoseState.TASK_JUMP) == false) {
			return false
		}
		if (this.GetType() == local_SceneBaseType.MainRole && this.task_jump_info && this.task_cur_jump_count == 1) {
			local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, last_end_pos.x, last_end_pos.y, local_MOVE_TYPE.TASK_JUMP, this.task_jump_info.start_pos.x, this.task_jump_info.start_pos.y)
		}

		return true
	}

	public EnterTaskStateJump(state_name?) {

		this.BeforeJumpHandler()

		let jump_name = "jump"

		//降神跳跃用固定动画
		if (this.vo && this.vo.god_id <= 0) {
			if (this.task_jump_info && this.task_jump_info.jump_action_list) {
				let jump_action_list = this.task_jump_info.jump_action_list
				if (jump_action_list) {

					let index = local_Util.RandomRange(0, jump_action_list.length - 1)
					jump_name = jump_action_list[index]
					if (jump_action_list.length > 1) {
						table.remove(jump_action_list, index)
					}
				}
			}
		}

		this.PlayAction(jump_name)
		let movie_speed_off = this.GetJumpMoveSpeedOff(jump_name, true)
		let pos = new Vector3(this.real_pos.x, this.real_pos.y)
		pos.z = this.jump_start_height * 100 + this.jump_height
		if (this.GetType() == local_SceneBaseType.MainRole) {
			SoundManager.GetInstance().PlaySoundEffect("jump", true, null, "role")//待修改
			if (this.task_jump_info && this.task_jump_info.show_effect) {
				//显示凤凰特效
				this.particle_mgr.AddPosEffect("char_jumpfx_02", pos, null, null, this.GetDirection(), null, this.compress_id, null, null, this.vo.particle_priority, null, null, null, null, null, EffectResType.Other)

			}
			if (this.task_cur_jump_count && this.task_cur_jump_count > 1) {
				//中间借力条
				this.particle_mgr.AddPosEffect("char_jumpfx_01", pos, null, null, this.GetDirection(), null, this.compress_id, null, null, this.vo.particle_priority, null, null, null, null, null, EffectResType.Other)
			} else {
				//起跳特效
				this.particle_mgr.AddPosEffect("effect_jump_qitiaoyan", pos, null, null, this.GetDirection(), null, this.compress_id, null, null, this.vo.particle_priority, null, null, null, null, null, EffectResType.Other)
			}
		}

		if (this.task_jump_info) {
			this.SetPlaySpeed((1 + movie_speed_off) / (this.task_jump_info.fall_stay_time + this.task_jump_info.pre_jump_time))
		}
	}

	public UpdateTaskStateJump(state_name?, elapse_time?) {

		let jump = this.task_jump_info
		if (jump == null) {
			return
		}
		//经过的总时间
		let past_total_time = local_Status.NowTime - jump.start_time
		//移动过程经过的总时间
		let past_move_time = past_total_time - jump.pre_jump_time + jump.curr_time

		// console.warn("------UpdateStateJump------", past_total_time, past_move_time)

		//起跳动作时长
		if (past_total_time < jump.pre_jump_time) {
			// console.warn("------UpdateStateJump1------", past_total_time, jump.pre_jump_time)
			if (this.GetType() == local_SceneBaseType.MainRole && jump.pass_distance == 0) {
				jump.pass_distance = 0.01
				//  local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.JUMP, jump.start_pos.x, jump.start_pos.y)
			}
		} else if (jump.next_jump_time > 0 && past_move_time >= jump.next_jump_time) {
			this.DoTaskJump(false, false, false, false, false, true)
		} else if (past_move_time < jump.move_time) {
			let p = past_move_time / jump.move_time //经过的时间和总时间百分比 从0 逐渐到 1

			if (past_move_time <= jump.middle_time) {
				p = past_move_time / jump.middle_time
				let curr_vspeed = (1 - p) * jump.move_vspeed

				let h = jump.start_height + jump.move_vspeed * past_move_time - 0.5 * jump.a * past_move_time * past_move_time
				this.jump_height = h

				this.SetBodyXY(0, this.jump_height)
				this.jump_curr_height = this.jump_height

			} else { //下降过程
				p = (past_move_time - jump.middle_time) / jump.downTime
				let curr_vspeed = jump.move_vspeed * p
				let downTime = past_move_time - jump.middle_time
				let h = this.jump_curr_height - (0.5 * jump.a * downTime * downTime)
				this.jump_height = h

				this.SetBodyXY(0, h)
			}

			if (past_move_time < jump.hspeed_stop_time) { //水平移动
				let move_hspeed = jump.move_hspeed
				let main_role_pos = this.GetRealPos()
				let x = main_role_pos.x, y = main_role_pos.y
				let dist = move_hspeed * elapse_time
				//这里要判断一下移动的距离是否会超过最大距离，会出现最后一帧速度 x 时间 超过最大距离的情况，这种情况有可能会陷入到不可行走区域
				let max = jump.distance - jump.cur_pass_distance
				if (max < dist) {
					dist = max
				}
				jump.cur_pass_distance = jump.cur_pass_distance + dist
				x = x + jump.move_dir.x * dist
				y = y + jump.move_dir.y * dist

				this.SetRealPos(x, y, false, true)

				if (this.GetType() == local_SceneBaseType.MainRole) {
					jump.pass_distance = jump.pass_distance + dist
					if (jump.pass_distance >= 300) {
						local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.TASK_JUMP_UPDATE_POS, jump.start_pos.x, jump.start_pos.y)
						jump.pass_distance = 0
					}
				}
			} else {
				let main_role_pos = this.GetRealPos()
				let x = main_role_pos.x, y = main_role_pos.y
				this.SetRealPos(x, y, false, true)
			}

		} else if (past_move_time <= jump.fall_stay_time) {
			this.jump_curr_height = 0
			this.jump_start_height = 0
			this.SetBodyXY(0, 0)
			this.jump_height = 0
			this.SetRealPos(jump.end_pos.x, jump.end_pos.y, false, false)
		} else {
			if (this.GetType() == local_SceneBaseType.MainRole) {
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, jump.end_pos.x, jump.end_pos.y, local_MOVE_TYPE.TASK_JUMP_UPDATE_POS, jump.start_pos.x, jump.start_pos.y)
			}
			this.SetPlaySpeed(1)
			this.DoStand()
		}
	}

	public QuitTaskStateJump(state_name?) {

		if (this.GetCurState() != local_PoseState.TASK_JUMP) {
			this.task_cur_jump_count = 0

			this.SetBodyXY(0, 0)
			this.jump_height = 0
			this.SetPlaySpeed(1)

			this.task_jump_type = false
			this.task_target_list = false
			this.task_callback = false
			this.task_move_vspeed = false
			this.task_gravity_speed = false
			if (this.GetType() == local_SceneBaseType.MainRole) {
				// if (this.task_jump_info ) {
				//   //  local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.task_jump_info.end_pos.x, this.task_jump_info.end_pos.y, local_MOVE_TYPE.NORMOL_MOVE, this.task_jump_info.start_pos.x, this.task_jump_info.start_pos.y)
				// }

				//  MainCamera.Instance.ChangeSmoothState(MainCamera.SmoothState.Normal)
			}
			if (this.task_jump_info && this.task_jump_info.callback) {
				this.task_jump_info.callback()
			}

			this.task_jump_info = null
			this.AfterJumpHandler()
			this.is_task_jump = false
		}
	}

	//获取动作名字[现在只支持run和idle]
	public GetActionName(kind?) {
		let action_name = kind
		if (this.IsMoveBrickState()) {
			if (kind == "idle") {
				action_name = "carry"
			} else if (kind == "run") {
				action_name = "carry2"
			}
		}
		return action_name
	}

	public EnterStateStand(state_name?) {
		let action_name
		if (this.IsMoveBrickState()) {
			action_name = "carry"
		} else {
			action_name = "idle"
		}
		super.EnterStateStand(state_name, action_name)
	}

	public EnterStateDead(state_name?) {

		if (this.IsOnHorse()) {
			this.DownHorse(true)
		}
		super.EnterStateDead(state_name)
		this.DeleteSprite()
		this.DeletePartner()
		this.DeleteDemon()
		this.DeleteShengqi()
		this.RemoveBrick()
		if (this.name_board) {
			this.name_board.SetBrickVisible(false)
		}

		if (this == this.scene.GetClickTarget()) {
			this.scene.CancelClickTarget(true)
		}
	}

	public EnterStateMove(state_name?) {
		let action_name
		if (this.scene_mgr.IsWeddingScene() && BanquetAniManager.GetInstance().bool_playing) {
			action_name = 'walk'
		} else {
			action_name = this.GetActionName("run")
		}
		super.EnterStateMove(state_name, action_name)
	}



	public QuitStateMove(state_name?) {
		super.QuitStateMove(state_name)
		if ((this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.Fake_Role)) {
			this.SetPlaySpeed(1)
		}
	}


	//采集
	public DoCollect(state_name?) {

		if (this.IsInState(local_PoseState.COLLECT)) {
			return
		}
		if (this.IsOnHorse()) {
			this.DownHorse()
		}
		this.ChangeState(local_PoseState.COLLECT)
	}

	public QuitCollect(state_name?) {
		this.DoStand()
	}

	public EnterStateCollect(state_name?) {
		this.set_repeat_action = false
		this.PlayAction("collect", null, null, false)
		this.HideAllWeapon(local_Role.WeaponHideFlag.Collect)
	}

	public UpdateStateCollect(state_name?, elapse_time?) {

		if (this.IsInState(local_PoseState.COLLECT) && !this.set_repeat_action) {
			let next_frame = () => {
				if (!this.animator) {
					return
				}
				let layer = this.animator.getControllerLayer()
				if (!layer) {
					return
				}
				let cur_state: Laya.AnimatorState = layer.getAnimatorState("collect")
				if (cur_state) {
					let action_time = cur_state.clip.duration()
					let idle_func = () => {
						this.set_repeat_action = false
						if (this.IsInState(local_PoseState.COLLECT)) {
							this.PlayAction("collect", null, null, false)
						}
					}
					setTimeout(idle_func, action_time * 1000)
				}
			}
			this.set_repeat_action = true
			setTimeout(next_frame, 100)
		}
	}

	public QuitStateCollect(state_name?) {
		this.ShowAllWeapon(local_Role.WeaponHideFlag.Collect)
		//this:DoStand()
	}



	public EnterStateWaitStand(state_name?) {

		this.waitStand_init_time = local_Status.NowTime
	}

	public UpdateStateWaitStand(state_name?, elapse_time?) {

		if (this.vo.date_role_id && this.vo.date_role_id != 0) { return }
		let now_time = local_Status.NowTime
		if (now_time - this.waitStand_init_time > 0.050) {
			if (!this.IsDead()) {
				this.DoStand()
			}
		}
	}

	public QuitStateWaitStand(state_name?) {


	}

	public SetFollowObjPosition() {
		if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Sprite) != 0 && this.sprite) {
			this.sprite.SetShowPosition(local_SceneObj.ModelHideFlag.IndependentHide)
		}
	}

	public SetFollowObjShowState(state?, flag?) {
		if (!this.vo) {
			return
		}
		if (state) {

			if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Sprite) != 0 && this.sprite) {
				this.ShowSprite(flag)
			}

			if (this.vo.demon_id != 0 && this.demon) {
				this.ShowDemon(flag)
			}

			if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Partner) != 0 && this.partner) {
				this.ShowPartner(flag)
			}

			if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Shengqi) != 0 && this.shengqi) {
				this.ShowShengqi(flag)
			}

		} else {
			if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Sprite) != 0 && this.sprite) {
				this.HideSprite(flag)
			}

			if (this.partner) {
				this.HidePartner(flag)
			}

			if (this.demon) {
				this.HideDemon(flag)
			}

			if (this.shengqi) {
				this.HideShengqi(flag)
			}
		}
	}

	public BeforeJumpHandler() {

		if (this.IsOnHorse()) {
			this.show_horse_after_jump = true
			local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, true)
			this.DownHorse()
		}

	}

	public AfterJumpHandler() {
		if (!this.IsOnHorse() && this.show_horse_after_jump && (OperateManager.Instance.jump_point_obj == null || OperateManager.Instance.jump_point_obj.JumpFinish())) {
			this.show_horse_after_jump = false
			if (this.IsMainRole() && AutoFightManager.Instance.is_flying_shoe == false) {
				// 如果已经请求过，则直接上马，否则请求协议上马
				if (this.vo.GetFigureRideState(local_FigureProtoVo.FigureType.Horse) == 1 && this.GetHorseId() > 0) {
					this.RideHorse(true)
					if (this.GetType() == local_SceneBaseType.MainRole) {
						local_GlobalEventSystem.Fire(local_EventName.RIDE_HORSE_SUCCESS)
					}
				} else {
					local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, false)
				}
			} else {
				if (!this.IsMainRole()) {
					if (this.vo.GetFigureRideState(local_FigureProtoVo.FigureType.Horse) == 1 && this.GetHorseId() > 0) {
						this.RideHorse(true)
					}
				}
				AutoFightManager.Instance.is_flying_shoe = false
			}
		}
	}

	role_cloth_change_time_id
	public TryRoleClothChange() {
		// console.warn("@@@@------TryRoleClothChange------")
		if (this.role_cloth_change_time_id) {
			return
		}
		this.role_cloth_change_time_id = setTimeout(() => {
			this.role_cloth_change_time_id = 0
			if (this.use_delete_method) return
			this.RoleClothChange()
		}, 500);
	}

	//时装改变
	public RoleClothChange() {
		if (!this.vo) {
			return
		}

		if (this.scene_mgr.IsSeaHegemonyScene()) {
			let warGroup = this.vo.warGroup
			if (warGroup && warGroup != 0) {
				let power_id = SeaHegemonyModel.GetInstance().actType == 1 ? this.vo.guild_id : this.vo.camp
				let [swing_model, texture_id] = SeaHegemonyModel.GetInstance().GetShipModel(warGroup, power_id)
				this.SetFashionModelRes(texture_id)
				this.CreateClotheSprite(swing_model, false, local_SceneBaseType.Monster)
				return
			}
		}
		else if (this.InMaskState()) {
			this.SetFashionModelRes(null)
			this.CreateClotheSprite(MaskModel.GetRoleClothePosId(this.vo, FashionPartPos.Clothe))
			this.ShowHeadWear()
			return
		}

		if (this.vo.CheckIsMoveBrick()) {
			// 搬砖用原始模型
			this.SetFashionModelRes(null)
			this.HideModelEffect();
			this.CreateClotheSprite(this.vo.GetRoleClotheId(true))
			return
		}

		// if (this.IsJoinWedding() && this.vo && MarriageModel.GetInstance().CheckIsMarriedCouple(this.vo.role_id)) {
		// 	this.vo.fashion_model_list = MarriageModel.GetInstance().GetMarriageFashionByCareer(this.vo.career)
		// }

		let fashion_model_id = null
		let fashion_chartlet_id = null
		if (!this.HasBlockSetting("fashion")) {
			[fashion_model_id, fashion_chartlet_id] = this.vo.GetRoleClotheTextureId(true)
		}
		this.fashion_chartlet_id = fashion_chartlet_id
		let reload_clothe_model = null //是否需要加载衣服等级模型 如果需要重新加载 加载回调函数会自动处理武器换贴图
		if (fashion_model_id && fashion_chartlet_id) {
			let res = ModelPartName[1] + fashion_model_id + "_" + fashion_chartlet_id
			if (Number(fashion_chartlet_id) == 0) { //贴图为0 ，使用本身模型
				this.SetFashionModelRes(null)
			} else {
				this.SetFashionModelRes(res) //设置时装数据, 等模型加载好后就设置这个贴图数据
			}
			reload_clothe_model = this.CreateClotheSprite(fashion_model_id)
			if (this._type == local_SceneBaseType.MainRole) {
				local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_FASHION_RES_CHANGE, this._type, fashion_model_id, fashion_chartlet_id)
			}
		} else {
			this.SetFashionModelRes(null)
			let force_load_type = null
			if (this.vo.CheckIsGod()) {
				force_load_type = local_SceneBaseType.God
			}
			reload_clothe_model = this.CreateClotheSprite(fashion_model_id || this.vo.GetRoleClotheId(true), null, force_load_type)
			if (this._type == local_SceneBaseType.MainRole) {
				local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_CLOTH_RES_CHANGE, this._type, this.vo.GetRoleClotheId())
			}
		}
		//不需要重新加载模型
		if (!reload_clothe_model) {
			let weapon_model_id, weapon_chartlet_id = this.GetWeaponId()
			//模型已经加载完 武器也加载完 并且武器模型一致
			if (this.gameObject && !local_Util.IsTableEmpty(this.weapon_sprite_dic) && this.weapon_id && this.weapon_id == weapon_model_id) {
				if ((weapon_chartlet_id == null || weapon_chartlet_id == 0) && this.weapon_clothe_id && this.weapon_clothe_id > 0) { //恢复默认贴图
					this.SetWeaponClotheRes(null)
					for (let bone_name in this.weapon_sprite_dic) {
						var vo = this.weapon_sprite_dic[bone_name]
						if (vo) {
							let mesh = vo.mesh
							if (mesh && mesh.material && vo.default_mainTexture) {
								SetMaterialTexture(mesh.material, vo.default_mainTexture)
							}
						}
					}
				} else if (weapon_chartlet_id && weapon_chartlet_id > 0 && this.weapon_clothe_id != weapon_chartlet_id) { //更新贴图
					this.SetWeaponClotheRes(null)
					this.SetWeaponClotheRes(weapon_chartlet_id)
					// for (let bone_name in this.weapon_sprite_dic) {
					// 	var vo = this.weapon_sprite_dic[bone_name]
					// 	if (vo) {
					// 		let mesh = vo.mesh
					// 		if (!local_Util.IsNull(mesh) && mesh.material) {
					// 			let res_path = weapon_model_id + "_" + weapon_chartlet_id
					// 			// 暂时屏蔽
					// 			//this.AddWeaponClothe(bone_name, new Weapon(mesh.material, res_path, load_call))
					// 		}
					// 	}
					// }
				}
			} else {
				this.CreateWeaponSprite() //需要重新加载武器模型
			}
		}

		//不需要重新加载模型
		if (!reload_clothe_model) {
			if (this.gameObject) {
				let [head_wear_id, head_clothe_id] = this.vo.GetRoleHeadId(this.HasBlockSetting("fashion"))
				if (!this.last_head_wear_id || this.last_head_wear_id != head_wear_id) {
					this.ChangeHeadWear()
				} else if (!this.last_head_clothe_id || this.last_head_clothe_id != head_clothe_id) {
					this.ChangeHeadClotheRes()
				}
			}

		}
		this.ClearBodyEffect()
		this.LoadModeParticle()
	}

	// //////////////////坐骑相关//////////////////
	// function local_Role.ChangeHorse(  )
	// 	if (this.HasBlockSetting("horse") ) {
	// 		this.DownHorse()
	// 	}else{
	// 		this.RideHorse(true)
	// 	}
	// }

	//坐骑改变
	public HorseChange() {
		// if (this.scene_mgr.HideOnlyRoleScene()) {
		// 	return
		// }

		if (this.IsDead()) {
			return
		}
		if (this.vo && this.vo.brick_id > 0) {
			return
		}

		if (!this.IsRide() || !this.RideHorseCond()) {
			this.DownHorse()
			if (this.GetType() == local_SceneBaseType.MainRole) {
				local_GlobalEventSystem.Fire(local_EventName.HIDE_HORSE_SUCCESS, true)
			}
		} else {
			// 如果当前在跳跃状态，则不能马上上马，跳跃完再上马
			if (this.IsInState(local_PoseState.JUMP) || this.IsInState(local_PoseState.TASK_JUMP)) {
				this.show_horse_after_jump = true
			} else {
				if (this.GetType() == local_SceneBaseType.MainRole) {
					//可能先变身 然后马上收到上马协议
					if (this.vo.CheckIsGod && this.vo.CheckIsGod()) {
						local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, true)
						return
					}

					//冲刺状态不上马(冲刺后会立即放技能 所以不用处理冲刺后的下马逻辑)
					if (this.IsInState(local_PoseState.RUSH)) {
						return
					}
				}
				this.RideHorse()
				if (this.GetType() == local_SceneBaseType.MainRole) {
					local_GlobalEventSystem.Fire(local_EventName.RIDE_HORSE_SUCCESS)
				}
			}

		}
		this.ChangeSpeedBuffEffect()
	}


	//离线挂机无敌特效
	public ShowOfflineEffect(show?) {

		if (!this.vo.protect_time) {
			return
		}


		let end_time = this.vo.protect_time - TimeUtil.getServerTime()

		if (end_time > 0) {
			if (!this.offline_partical_id) {
				this.offline_partical_id = this.particle_mgr.AddTargetEffect("buffparticle_106_1", this.compress_id, true, null, null, 7, null, null, null, true)
			}

		} else {
			if (this.offline_partical_id) {
				this.particle_mgr.DelEffect(this.offline_partical_id)
				this.offline_partical_id = false
			}
		}
	}

	//长距离任务寻路加速buff
	public AddSpeedBuffEffect() {

		if (!this.vo) { return }
		this.move_flag = local_MOVE_TYPE.ACCELERATE
		if (!this.speed_effect_id && this.GetType() == local_SceneBaseType.MainRole) {
			let attach_type = 7
			if (this.IsOnHorse()) {
				attach_type = 16
			}
			this.speed_effect_id = this.particle_mgr.AddTargetEffect("char_acceleratebuff01", this.compress_id, true, null, null, attach_type, null, null, null, null, null, null, null, null, EffectResType.Other)
		}
	}

	//长距离任务寻路加速buff
	public ChangeSpeedBuffEffect() {
		if (this.speed_effect_id) {
			this.CancleSpeedBuffEffect()
			this.AddSpeedBuffEffect()
		}
	}



	//取消长距离任务寻路加速buff，恢复玩家加速前的速度
	public CancleSpeedBuffEffect() {

		if (this.speed_effect_id) {
			this.particle_mgr.DelEffect(this.speed_effect_id)
			this.speed_effect_id = null
		}
		if (this.move_flag && this.move_flag == local_MOVE_TYPE.ACCELERATE) {
			this.move_flag = local_MOVE_TYPE.NORMOL_MOVE
		}
	}


	public ShowBaseInfoOnly() {

		if (this.vo && this.vo.show_base_info_only && this.name_board) {
			for (let _ in this.vo_ext_bind_handlers) {
				var v = this.vo_ext_bind_handlers[_]
				this.vo.UnBind(v)
			}
			this.vo_ext_bind_handlers = []
			// this.name_board.ShowBase()
		}
	}

	public ChangeWing() {

		if (this.GetWingId() && this.GetWingId() > 0 && !this.HasBlockSetting("wing")) {
			this.ShowWing(true)
		} else {
			this.HideWing()
		}
	}

	public ChangeBackOrnament() {
		if (this.GetBackId() && this.GetBackId() > 0 && !this.HasBlockSetting("back")) {
			this.ShowBackOrnament(true)
		} else {
			this.HideBackOrnament()
		}
	}


	public ChangeDsgt() {
		if (this.name_board) {
			if (this.vo.dsgt_id && this.vo.dsgt_id > 0 && !this.HasBlockSetting("title") && this.scene_mgr.showDsgtScene()) {
				this.name_board.ShowDsgt(true)
			} else {
				this.name_board.ShowDsgt(false)
			}
		}
	}

	public ExcuteCreateClotheSpriteFinished() {
		if (this.IsMoveBrickState()) {
			if (!this.loading_brick) {
				this.LoadBrickRes()
			}
		}
	}

	//加载完模型资源回调
	public LoadClotheResComplete() {
		if (this.fashion_res) {
			this.ChangeClothe(this.fashion_res)
		}
		if (this.IsRide() && this.RideHorseCond()) {
			this.RideHorse(true)
		}
		else {
			this.DownHorse(true)
		}
		super.LoadClotheResComplete()
		if (this.IsMoveBrickState()) {
			this.LoadHeadWearRes()
			if (!this.loading_brick) {
				this.LoadBrickRes()
			}
			return
		}

		if (this.scene_mgr.IsSeaHegemonyScene()) {
			return
		}

		let horse_id = this.GetHorseId()
		if (!horse_id || horse_id == 0 || !this.IsRide()) {
			this.SetFirstState()
		}

		this.CreateWeaponSprite() //武器
		this.LoadWingRes() //翅膀
		this.ShowHeadWear()//头发
		this.LoadBackOrnamentRes()//背饰
		this.LoadLiveness()//活跃度
	}

	public ShowWing(force_change?) {
		if (this.wing_res_loaded_and_show == false || force_change) {
			if (this.wing_gameObject && this.last_wing_id == this.vo.wing_id && !force_change) {
				this.wing_res_loaded_and_show = true
				this.wing_gameObject.active = true
			} else {
				if (force_change) {
					this.RemoveWing()
				}
				this.LoadWingRes()
			}
		}
	}

	public ShowBackOrnament(force_change?) {
		if (this.back_res_loaded_and_show == false || force_change) {
			if (this.back_gameObject && this.last_back_id == this.vo.back_id && !force_change) {
				this.back_res_loaded_and_show = true
				this.back_gameObject.active = true
			} else {
				if (force_change) {
					this.RemoveBackOrnament()
				}
				this.LoadBackOrnamentRes()
			}
		}
	}

	public HideHeadWear() {

		if (this.head_wear_res_loaded_and_show) {
			this.head_wear_res_loaded_and_show = false
			this.headWear_gameObject.active = false
			this.ResetResSize()
		}
	}

	public ChangeHeadWear() {

		let [head_wear_id, head_clothe_id] = this.vo.GetRoleHeadId(this.HasBlockSetting("fashion"))

		if (head_wear_id && head_wear_id > 0) { //只有时装有特殊的头饰
			this.ShowHeadWear(true)
		} else {
			this.HideHeadWear()
		}
	}

	public ChangeHeadClotheRes() {

		let [head_wear_id, head_clothe_id] = this.vo.GetRoleHeadId(this.HasBlockSetting("fashion"))
		this.last_head_clothe_id = head_clothe_id

		if (!local_Util.IsNull(this.head_wear_skin_mesh_renderer) && this.head_wear_skin_mesh_renderer.skinnedMeshRenderer && this.head_wear_skin_mesh_renderer.skinnedMeshRenderer.material) {
			let unlit_material: Laya.UnlitMaterial = this.head_wear_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
			if (head_clothe_id && Number(head_clothe_id) != 0 && !this.InMaskState()) {
				let texture_res = ModelPartName[6] + head_wear_id + "_" + head_clothe_id
				if (!this.head_clothe)
					this.head_clothe = new Clothe(unlit_material, texture_res)
				else
					this.head_clothe.LoadTexture(unlit_material, texture_res)
			} else if ((!head_clothe_id || Number(head_clothe_id) == 0 || this.InMaskState()) && this.headWear_default_mainTexture) {
				SetMaterialTexture(unlit_material, this.headWear_default_mainTexture)
			}
		}
	}

	/**
	 * 加载搬砖资源
	 */
	public LoadBrickRes() {
		if (!this.vo || this.vo.brick_id <= 0) {
			return
		}
		let local_brick_res_name = 'model_clothe_15010042';
		let load_call_back = (obj: Laya.Sprite3D) => {
			if (local_Util.IsNull(obj)) {
				console.warn("LoadBrickRes cannot find headWear res = ")
				return
			}
			if (this.use_delete_method || this.is_in_cache_pool || !local_brick_res_name || !this.transform) {
				obj.destroy()
				return
			}

			if (this.brick_sprite3d) {
				let tem_ignore_pool = this.ignore_pool
				if (local_brick_res_name == this.brick_res_name) { //最后加载的模型是最新的
					this.ignore_pool = true
					this.RemoveBrick()
					this.ignore_pool = tem_ignore_pool
				} else {
					obj.destroy();
					return
				}
			}

			this.loading_brick = false;
			this.last_brick_id = this.vo.brick_id;
			this.brick_sprite3d = obj;
			this.brick_sprite3d.visible = true;
			this.brick_transform = this.brick_sprite3d.transform;
			this.brick_mesh_renderer = local_GetSkinnedMeshSprite3D(obj);
			if (!this.brick_mesh_renderer) {
				this.brick_mesh_renderer = GetMeshSprite3D(obj);
			}

			let bone = local_Util.FindBone(this.transform.owner, AttachNode.RHand)
			if (bone == null) {
				return
			}
			bone.addChild(this.brick_sprite3d)
			local_ResetTransform(this.brick_transform)

			//大于1才需要换贴图
			if (this.vo.brick_id > 1) {
				let res_path = local_brick_res_name
				//由于贴图名字对不上，这里-1
				res_path = res_path + "_" + (this.vo.brick_id - 1)
				if (!this.brick_clothe || this.brick_clothe.res_path != res_path) {
					if (!local_Util.IsNull(this.brick_mesh_renderer)) {
						let material = GetMaterial(this.brick_mesh_renderer)
						if (material) {
							this.brick_clothe_default_texture = material.albedoTexture
							if (!this.brick_clothe)
								this.brick_clothe = new Clothe(material, res_path)
							else
								this.brick_clothe.LoadTexture(material, res_path)
						}
					}
				}
			}
		}

		this.brick_res_name = local_brick_res_name
		let load_level = LOAD_QUEUE.LOW;
		if (this._type == local_SceneBaseType.MainRole) {
			load_level = LOAD_QUEUE.HIGHT
		}
		this.loading_brick = true
		let full_url = GameResPath.GetTypePath(local_SceneBaseType.Monster, this.brick_res_name)
		this.brick_res_url = full_url
		local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back, load_level)
	}

	public RemoveBrick() {

		this.loading_brick = false
		if (this.brick_clothe) {
			this.brick_clothe.DeleteMe()
			this.brick_clothe = null
		}
		if (this.brick_sprite3d && this.brick_res_url) {
			if (this.brick_clothe_default_texture) {
				let material = GetMaterial(this.brick_mesh_renderer)
				if (material) {
					SetMaterialTexture(material, this.brick_clothe_default_texture)
				}
			}
			local_ResManager.GetInstance().AddSprite3DToPool(this, this.brick_res_url, this.brick_sprite3d)
			this.brick_sprite3d = null
			this.brick_transform = null
			this.brick_res_name = null
			this.brick_mesh_renderer = null
			this.brick_clothe_default_texture = null
		}
	}

	//创建头饰
	public LoadHeadWearRes() {

		if (this.vo.god_id > 0) { return }
		let head_wear_id = this.GetHeadWearId()

		if (head_wear_id && head_wear_id > 0 && this.gameObject && !this.head_wear_res_loaded_and_show) {//and ! this.HasBlockSetting("hat")

			let head_wear_res_name = GameResPath.GetHeadRes(this._type, head_wear_id)

			if (this.vo.career) {
				this.default_head_go = local_ResManager.GetInstance().default_head_objs[this.vo.career]
				if (this.default_head_go) {
					let bone = local_Util.FindBone(this.transform.owner, AttachNode.Head)
					if (bone == null) {
						return
					}
					bone.addChild(this.default_head_go)
					local_ResetTransform(this.default_head_go.transform)
				}
			}

			this.last_head_wear_id = head_wear_id
			let head_wear_res_url = GameResPath.GetObjectPath("head", head_wear_res_name);
			let load_level = LOAD_QUEUE.LOW
			if (this._type == local_SceneBaseType.MainRole) {
				load_level = LOAD_QUEUE.HIGHT
			}
			let params = {
				module: "head",
				name: "Scene",
				id: this.scene_mgr.GetSceneId(),
			}
			head_wear_res_url += GetParams(params)
			this.head_wear_res_url = head_wear_res_url

			var load_call_back = (obj: Laya.Sprite3D) => {
				if (local_Util.IsNull(obj)) {
					console.warn("LoadHeadWearRes cannot find headWear res = " + head_wear_id)
					return
				}
				if (this.use_delete_method || this.is_in_cache_pool || !this.head_wear_res_url || !this.transform) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}
				let new_go = obj
				if (this.headWear_gameObject) {
					// let tem_ignore_pool = this.ignore_pool
					if (head_wear_res_url == this.head_wear_res_url) { //最后加载的模型是最新的
						// this.ignore_pool = true
						this.RemoveHeadWear()
						// this.ignore_pool = tem_ignore_pool
					} else {
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
						return
					}
				}

				this.last_head_wear_id = head_wear_id
				this.headWear_gameObject = new_go
				this.headWear_gameObject.active = true
				this.headWear_transform = this.headWear_gameObject.transform

				this.headWear_animator = new_go.getComponent(local_Laya.Animator)

				let head_wear_skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_GetSkinnedMeshSprite3D(new_go)
				if (head_wear_skin_mesh_renderer) {
					this.head_wear_skin_mesh_renderer = head_wear_skin_mesh_renderer
					let unlit_material: Laya.UnlitMaterial = this.head_wear_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
					this.headWear_default_mainTexture = GetMaterialTexture(unlit_material)
				}

				let bone: Laya.Sprite3D = local_Util.FindBone(this.transform.owner, AttachNode.Head)
				if (bone == null) {
					return
				}
				if (this.default_head_go) {
					this.default_head_go.removeSelf()
					this.default_head_go = null
				}
				this.head_wear_res_loaded_and_show = true
				bone.addChild(this.headWear_gameObject)
				local_ResetTransform(this.headWear_transform)
				this.LoadHeadWearResComplete() //加载头饰资源完成 回调
				this.ChangeHeadClotheRes() //更换贴图
			}
			if (this.head_wear_res_url) {
				local_ResManager.GetInstance().CreatePrefab(this.hashCode, this.head_wear_res_url, load_call_back, load_level)
			}
		}
	}

	public GetHeadWearId() {

		if (this.InMaskState()) {
			return MaskModel.GetRoleClothePosId(this.vo, FashionPartPos.Head)
		}

		let head_data = this.vo.GetRoleHeadId(this.HasBlockSetting("fashion") || this.vo.brick_id > 0)
		return head_data[0]

	}

	public RemoveHeadWear() {
		if (this.default_head_go) {
			this.default_head_go.removeSelf()
			this.default_head_go = null
		}
		if (!local_Util.IsNull(this.headWear_gameObject)) {

			if (!this.ignore_pool) {
				local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, this.headWear_gameObject.url, this.headWear_gameObject)
				// lua_resM.AddObjToPool(this, this.head_wear_res_name, this.headWear_resName, this.headWear_gameObject)
				if (this.headWear_default_mainTexture && this.head_wear_skin_mesh_renderer && this.head_wear_skin_mesh_renderer.skinnedMeshRenderer && this.head_wear_skin_mesh_renderer.skinnedMeshRenderer._sharedMaterials) {
					let unlit_material: Laya.UnlitMaterial = this.head_wear_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
					SetMaterialTexture(unlit_material, this.headWear_default_mainTexture)
				}
			} else {
				this.headWear_gameObject.destroy()
			}


			if (this.head_clothe) {
				this.head_clothe.DeleteMe()
				this.head_clothe = null
			}

			this.head_wear_res_url = undefined
			this.headWear_gameObject = undefined
			this.headWear_transform = undefined
			this.headWear_animator = undefined
			this.last_head_wear_id = undefined
			this.last_head_clothe_id = undefined
			this.head_wear_skin_mesh_renderer = undefined
			this.headWear_default_mainTexture = undefined
			this.head_wear_res_loaded_and_show = false
		}

	}

	public ShowHeadWear(force_change?) {

		if (this.head_wear_res_loaded_and_show == false || force_change) {
			let [head_wear_id, head_clothe_id] = this.vo.GetRoleHeadId(this.HasBlockSetting("fashion") || this.vo.brick_id > 0)
			if (this.headWear_gameObject && this.last_head_wear_id == head_wear_id && !force_change) {
				this.head_wear_res_loaded_and_show = true
				this.headWear_gameObject.active = true
				this.ResetResSize()
			} else {
				this.head_wear_res_loaded_and_show = false
				this.LoadHeadWearRes()
			}
		}
	}

	//////////////////伙伴//////////////-
	public ChangePartner() {
		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.GetFigureId(local_FigureProtoVo.FigureType.Partner) != 0 && !this.HasBlockSetting("partner")) {
			if (!this.partner) {
				this.CreatePartner()
			} else {
				let id = MaskModel.GetInstance().GetMaskFlowerId(this.vo, local_FigureProtoVo.FigureType.Partner)
				this.partner.compress_id = this.scene.CompressObjId(local_SceneBaseType.Partner, this.id)
				this.partner.UpdateModel(id)
			}

		} else {
			if (this.partner != null) {
				this.DeletePartner()
			}
		}
	}

	public CreatePartner() {
		if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Partner) != 0 && !this.partner && !this.vo.is_virtual_friend && this.scene_mgr.showPartnerScene()) {
			this.partner = this.scene.CreatePartner(this)
		}
	}

	public DeletePartner() {

		if (this.partner) {
			this.scene.DeletePartner(this.id)
			this.partner = null
		}
	}

	public ShowPartner(flag?) {

		if (this.partner) {
			this.partner.SetModelHideFlag(flag, false)
			this.partner.SetShowPosition(flag)
		}
	}

	public HidePartner(flag?) {

		if (this.partner) {
			this.partner.SetModelHideFlag(flag, true)
		}
	}

	public GetPartner() {

		return this.partner
	}
	//////////////////伙伴//////////////-

	//////////////////使魔//////////////-
	public ChangeDemon() {
		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.demon_id != 0 && !this.HasBlockSetting("demon")) {
			if (!this.demon) {
				this.CreateDemon()
			} else {
				this.demon.compress_id = this.scene.CompressObjId(local_SceneBaseType.Demon, this.id)
				this.demon.UpdateDemon(this.vo.demon_id)
			}
		} else {
			if (this.demon != null) {
				this.DeleteDemon()
			}
		}
	}

	public CreateDemon() {

		if (this.vo.demon_id != 0 && !this.demon && !this.vo.is_virtual_friend) {
			this.demon = this.scene.CreateDemon(this, this.vo)
		}

	}

	public DeleteDemon() {

		if (this.demon) {
			this.scene.DeleteDemon(this.id)
			this.demon = null
		}
	}

	public ShowDemon(flag?) {

		if (this.demon) {
			this.demon.SetModelHideFlag(flag, false)
			this.demon.SetShowPosition(flag)
		}
	}

	public HideDemon(flag?) {

		if (this.demon) {
			this.demon.SetModelHideFlag(flag, true)
		}
	}

	public GetDemon() {

		return this.demon
	}
	//////////////////伙伴//////////////-


	//小精灵
	public ChangeSprite() {

		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.GetFigureId(local_FigureProtoVo.FigureType.Sprite) != 0 && !this.HasBlockSetting("sprite")) {
			if (!this.sprite) {
				this.CreateSprite()
			} else {
				let id = MaskModel.GetInstance().GetMaskFlowerId(this.vo, local_FigureProtoVo.FigureType.Sprite)
				this.sprite.compress_id = this.scene.CompressObjId(local_SceneBaseType.Sprite, this.id)
				this.sprite.UpdateModel(id)
			}
		} else {
			if (this.sprite != null) {
				this.DeleteSprite()
			}
		}
	}

	//小精灵
	public CreateSprite() {
		if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Sprite) != 0 && !this.sprite && !this.vo.is_virtual_friend && this.scene_mgr.showSpriteScene()) {
			this.sprite = this.scene.CreateSprite(this, this.vo)
		}
	}

	public DeleteSprite() {

		if (this.sprite) {
			this.scene.DeleteSprite(this.id)
			this.sprite = null
		}
	}

	public ShowSprite(flag?) {

		if (this.sprite) {
			this.sprite.SetModelHideFlag(flag, false)
			this.sprite.SetShowPosition(flag)
		}
	}

	public HideSprite(flag?) {

		if (this.sprite) {
			this.sprite.SetModelHideFlag(flag, true)
		}
	}



	public IsMainRole() {

		return this.vo.role_id == this.role_mgr.GetMainRoleId()
	}

	//////////////////婚姻相关//////////////////
	public HandleWeddingStateFlag() {

		let flag = this.vo.wedding_state_flags
		//MarriageModel:GetInstance():HandleWeddingState(flag, this.vo)

		// 处理自身和伙伴隐藏
		//this:SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, (flag == Config.ConfigMarriage.WedingActivityFlag.VISITOR))
		if (this.scene_mgr.IsWeddingScene() && BanquetAniManager.GetInstance().bool_playing) {

			this.SetFollowObjShowState(false, local_SceneObj.ModelHideFlag.IndependentHide)
			this.SetShadowVisible(false)
			this.HideAllWeapon()
			this.HideWing()
			this.HideBackOrnament()
			this.HideLiveness()
			this.ShowModel(false)
			AutoFightManager.GetInstance().SetAutoFight(false)
			this.DoStand()

		} else {
			this.SetFollowObjShowState(true, local_SceneObj.ModelHideFlag.IndependentHide)
			this.SetShadowVisible(true)
			this.ShowAllWeapon()
			this.ShowWing()
			this.ShowBackOrnament()
			this.ShowLiveness()
			this.ShowModel(true)
			AutoFightManager.GetInstance().SetAutoFight(true)
		}
	}


	public IsGodState() {

		return this.vo && this.vo.god_id > 0
	}

	public GetHeadWearHeight() {
		return 0
	}

	////////////////////////-圣器//////////////////////-

	public ChangeShengqi() {
		if (!this.scene_mgr.HideOnlyRoleScene() && this.vo.GetFigureId(local_FigureProtoVo.FigureType.Shengqi) != 0 && (this.IsMainRole() || !this.HasBlockSetting("shengqi"))) {
			if (!this.shengqi) {
				this.CreateShengqi()
			} else {
				let id = MaskModel.GetInstance().GetMaskFlowerId(this.vo, local_FigureProtoVo.FigureType.Shengqi)
				this.shengqi.compress_id = this.scene.CompressObjId(local_SceneBaseType.Shengqi, this.id)
				this.shengqi.UpdateModel(id)
			}

		} else {
			if (this.shengqi) {
				this.DeleteShengqi()
			}
		}
	}

	public HideShengqi(flag?) {
		if (this.shengqi) {
			this.shengqi.SetModelHideFlag(flag, true)
		}
	}

	public ShowShengqi(flag?) {
		if (this.shengqi) {
			this.shengqi.SetModelHideFlag(flag, false)
			//this.shengqi.SetShowPosition(flag)
		}
	}

	public CreateShengqi() {
		if (this.vo.GetFigureId(local_FigureProtoVo.FigureType.Shengqi) != 0) {
			this.shengqi = this.scene.CreateShengqi(this)
		}
	}

	public DeleteShengqi() {
		if (this.shengqi) {
			this.scene.DeleteShengqi(this.id)
			this.shengqi = null
		}
	}

	public UpdateMedal(medal_id?) {
		//优先显示天境头衔，无，则显示勋章
		if (this.vo && this.name_board) {
			if (this.InMaskState()) {
				this.name_board.ShowMedal(0)
				this.name_board.SetTouxian(0)
			} else {
				if (this.vo.title_id && this.vo.title_id != 0) {
					this.name_board.SetTouxian(this.vo.title_id)
					this.name_board.ShowMedal(0)
				} else {
					medal_id = !medal_id && this.vo.medal_id || medal_id
					if (this.vo && this.name_board) {
						this.name_board.SetTouxian(0)
						this.name_board.ShowMedal(medal_id)
					}
				}
			}
		}
	}

	public UpdateNameBoard() {
		this.UpdateName()
		this.UpdateDsgt()
		this.UpdateVip()
		this.UpdateSuperVip()
		this.UpdateHideVip()
		// this.UpdateServerName()
		this.UpdateMedal()
		this.UpdateGuildInfo()
	}

	public InMaskState() {
		return this.vo.mask_id > 0 && SceneManager.GetInstance().CanMaskScene()
	}

	public LoadHeadWearResComplete() {
		this.ResetResSize()
	}

	//武器光效
	public ChangeWeaponEffect() {
		//场景中不用模型特效
		if (!this.HasBlockSetting("weapon")) {
			//加载武器配置特效
			if (!local_Util.IsTableEmpty(this.weapon_sprite_dic) && this.weapon_id && this.weapon_id > 0 && this.weapon_effect_dic == null) {
				let weapon_pvo = Config_PRELOAD_CLIENT_CONFIG.SceneObjectParticle.Weapon[this.weapon_id]
				if (weapon_pvo && weapon_pvo.always) {
					this.weapon_effect_dic = {}
					for (let bone_name in weapon_pvo.always) {
						let effect_vo = weapon_pvo.always[bone_name]
						for (let weapon_bone_name in this.weapon_sprite_dic) {
							let vo = this.weapon_sprite_dic[weapon_bone_name]
							if (vo && vo.go) {
								let bone = local_Util.FindBone(vo.go, bone_name)
								if (bone) {
									if (this.weapon_effect_dic[weapon_bone_name] == null) {
										this.weapon_effect_dic[weapon_bone_name] = {}
									}

									if (this.weapon_effect_dic[weapon_bone_name][bone_name] == null) {
										let load_call_back = (obj: Laya.Sprite3D) => {
											if (local_Util.IsNull(obj)) {
												console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load weapon Particle" + effect_vo.name)
												return
											}
											if (this.use_delete_method || this.is_push_to_cache
												|| this.weapon_effect_dic == null
												|| this.weapon_effect_dic[weapon_bone_name] == null
												|| this.weapon_effect_dic[weapon_bone_name][bone_name] == null) {
												local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
												return
											}
											if (local_Util.IsNull(bone)) {
												local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
												return
											}
											if (this.weapon_effect_dic[weapon_bone_name]
												&& this.weapon_effect_dic[weapon_bone_name][bone_name]
												&& this.weapon_effect_dic[weapon_bone_name][bone_name].effect_sprite) {
												local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
												return
											}
											obj.active = true

											let new_go = obj
											bone.addChild(new_go)

											local_ResetTransform(new_go.transform)
											this.weapon_effect_dic[weapon_bone_name][bone_name].effect_sprite = new_go
										}
										let full_url = GameResPath.GetEffectPath(EffectResType.Weapon, effect_vo.name)
										this.weapon_effect_dic[weapon_bone_name][bone_name] = { res_url: full_url, effect_name: effect_vo.name, effect_sprite: null }
										local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back)
									}
								}
							}
						}
					}
				}
			}
		} else {
			this.RemoveAllWeaponEffect()
		}
	}

	public GetWeaponId() {

		if ((this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.MainRole) && this.InMaskState()) {
			return MaskModel.GetRoleClothePosId(this.vo, FashionPartPos.Weapon)
		}

		//结婚过程隐藏
		if (this.vo && this.scene_mgr.IsWeddingScene()
			&& BanquetAniManager.GetInstance().bool_playing
			&& BanquetModel.GetInstance().CheckIsMarriedCouple(this.vo.role_id)) {
			return 0
		}


		//降神不需要武器
		if (this.vo.CheckIsGod && this.vo.CheckIsGod()) {
			return 0
		}


		if (this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Fake_Role) {
			let block = this.HasBlockSetting("fashion") && 1 || this.HasBlockSetting("weapon") && 2 || false
			return this.vo && this.vo.GetWeaponClotheId(true, block)
		} else {
			return this.vo && this.vo.weapon_id
		}

	}

	//创建武器
	public CreateWeaponSprite() {
		if (!this.scene_mgr.showWeaponScene() || this.IsMoveBrickState()) {
			return
		}
		let weapon_id = this.GetWeaponId()
		let weapon_career = this.vo.career

		if (weapon_id) {
			this.weapon_id = weapon_id
			let [weapon_attach_list, weapon_res_list] = GameResPath.GetWeaponRes(this._type, weapon_id, weapon_career)
			let weapon_res_url_list = []
			let load_call_back = (objs) => {
				if (!this.transform || this.use_delete_method || this.is_in_cache_pool || !this.weapon_id) {
					if (objs) {
						for (let i = 0; i < objs.length; i++) {
							let obj = objs[i]
							obj.destroy()
						}
					}
					return
				}
				let first_check_old_weapon = true
				if (weapon_attach_list && objs) {
					let bone_go = null
					this.SetWeaponClotheRes(null)

					let bone_name, go: Laya.Sprite3D
					for (let k = 0; k < weapon_attach_list.length; k++) {
						bone_name = weapon_attach_list[k]
						bone_go = local_Util.FindBone(this.transform.owner, bone_name)
						if (bone_go) {
							if (!objs[k]) {
								console.warn("!!!!!!!!!!!!can ! load weapon resName = ", weapon_res_list[k])
								return
							}
							go = objs[k]
							let states_hide_flag = this.weapon_hide_flag_list[bone_name]
							if (states_hide_flag == null) {
								states_hide_flag = 0
							}
							if (first_check_old_weapon) {
								if (!local_Util.IsTableEmpty(this.weapon_sprite_dic)) {
									if (go.name.search(this.weapon_id) != -1) { //最后加载的模型是最新的
										this.RemoveAttackAllWeapon()
									} else {
										go.destroy() //最后加载的模型不是最新的 就删掉该模型
										return
									}
								}
								first_check_old_weapon = false
							}
							bone_go.addChild(go)
							local_ResetTransform(go.transform)

							this.weapon_sprite_dic[bone_name] = {
								go: go,
								bone_name: bone_name,
								res_url: weapon_res_url_list[k],
								res_name: weapon_res_list[k],
								index: k,
								mesh: null
							}

							if (!this.weapon_hide_flag_list) {
								this.weapon_hide_flag_list = {}
							}

							this.weapon_hide_flag_list[bone_name] = states_hide_flag
							go.active = states_hide_flag == 0

							let skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_GetSkinnedMeshSprite3D(go)
							if (skin_mesh_renderer) {
								let mat = skin_mesh_renderer.skinnedMeshRenderer.material
								if (mat) {
									this.weapon_sprite_dic[bone_name].mesh = skin_mesh_renderer
								}
							}
						}
					}
					this.LoadWeaponResComplete()
				}
			}
			if (this.transform && weapon_res_list) {
				let objs = []
				let length = weapon_res_list.length
				let call_back = (obj) => {
					objs.push(obj)
					if (length == objs.length) {
						load_call_back(objs)
					}
				}
				let load_level = LOAD_QUEUE.LOW
				if (this._type == local_SceneBaseType.MainRole) {
					load_level = LOAD_QUEUE.HIGHT
				}
				let params = {
					module: "weapon",
					name: "Scene",
					id: this.scene_mgr.GetSceneId(),
				}
				for (let i in weapon_res_list) {
					let full_url = GameResPath.GetObjectPath("weapon", weapon_res_list[i])
					full_url += GetParams(params)
					weapon_res_url_list.push(full_url)
					local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, call_back, load_level)
				}

			}
			// if (this._type == local_SceneBaseType.MainRole ) {
			// GlobalEventSystem.Fire(SceneEventType.MAIN_ROLE_WEAPON_RES_CHANGE, this._type, this.vo.GetWeaponClotheId(), this.vo.career,clothe_id)
			// }
		}
	}

	public LoadWeaponResComplete() {
		this.LoadModeParticle()
	}

	//加载Mode特效
	public LoadModeParticle() {

		// super.LoadModeParticle()
		if (this.GetType() != local_SceneBaseType.MainRole)//目前只有主角开启武器特效
		{
			return
		}
		this.ChangeWeaponEffect()
		//加载坐骑配置特效
		if (this.IsOnHorse() && this.horse_transform && this.horse_effect_dic == null) {
			let horse_pvo = Config_PRELOAD_CLIENT_CONFIG.SceneObjectParticle.Horse[this.GetHorseId()]
			this.horse_effect_dic = {}
			let horse_particle_index = 0

			//坐骑常驻特效
			if (horse_pvo && horse_pvo.always) {
				for (let bone_name in horse_pvo.always) {
					let particle_vos = horse_pvo.always[bone_name]
					let particle_vo_list
					if(particle_vos.length == null){
						particle_vo_list = [particle_vos]
					}
					else{
						particle_vo_list = particle_vos
					}

					for(let effect_vo of particle_vo_list){
						let local_index = horse_particle_index
						if (this.horse_effect_dic[local_index] == null) {
							let bone
							bone = local_Util.FindBone(this.horse_gameObject, bone_name)
							if (bone) {
								let load_call_back = (obj: Laya.Sprite3D) => {
									if (local_Util.IsNull(obj)) {
										console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load horse Particle" + effect_vo.name)
										return
									}
									if (!this.horse_transform || this.use_delete_method || this.is_push_to_cache || this.horse_effect_dic == null || this.horse_effect_dic[local_index] == null) {
										local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
										return
									}
									if (local_Util.IsNull(bone)) {
										local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
										return
									}
									if (this.horse_effect_dic[local_index] && this.horse_effect_dic[local_index].effect_sprite) {
										local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
										return
									}
									let new_go = obj
									let transform = new_go.transform
									bone.addChild(new_go)
									local_ResetTransform(new_go.transform)

									let x = (effect_vo && effect_vo.rotate && effect_vo.rotate.x) && effect_vo.rotate.x || 0
									let y = (effect_vo && effect_vo.rotate && effect_vo.rotate.y) && effect_vo.rotate.y || 0
									let z = (effect_vo && effect_vo.rotate && effect_vo.rotate.z) && effect_vo.rotate.z || 0
									// transform.localRotationEuler = new Laya.Vector3(x, y, z)
									local_Set3DLocalRotationEuler(transform, x, y, z)
									this.horse_effect_dic[local_index].effect_sprite = new_go
								}
								let full_url = GameResPath.GetEffectPath(EffectResType.Horse, effect_vo.name)
								this.horse_effect_dic[local_index] = { res_url: full_url, bone_name: bone_name, effect_name: effect_vo.name, effect_sprite: null }
								local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back)
							}
						}
						++horse_particle_index
					}
				}
			}

			//坐骑跑步特效
			if(horse_pvo.action && horse_pvo.action.run){
				this.horse_move_effect_list.length = 0
				for (let bone_name in horse_pvo.action.run) {
					let particle_vos = horse_pvo.action.run[bone_name]
					let particle_vo_list
					if(particle_vos.length == null){
						particle_vo_list = [particle_vos]
					}
					else{
						particle_vo_list = particle_vos
					}

					for(let effect_vo of particle_vo_list){
						let local_index = horse_particle_index
						if (this.horse_effect_dic[local_index] == null) {
							let bone
							bone = local_Util.FindBone(this.horse_gameObject, bone_name)
							if (bone) {
								let load_call_back = (obj: Laya.Sprite3D) => {
									if (local_Util.IsNull(obj)) {
										console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load horse Particle" + effect_vo.name)
										return
									}
									if (!this.horse_transform || this.use_delete_method || this.is_push_to_cache || this.horse_effect_dic == null || this.horse_effect_dic[local_index] == null) {
										local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
										return
									}
									if (local_Util.IsNull(bone)) {
										local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
										return
									}
									if (this.horse_effect_dic[local_index] && this.horse_effect_dic[local_index].effect_sprite) {
										local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
										return
									}
									let new_go = obj
									let transform = new_go.transform
									bone.addChild(new_go)
									local_ResetTransform(new_go.transform)

									let x = (effect_vo && effect_vo.rotate && effect_vo.rotate.x) && effect_vo.rotate.x || 0
									let y = (effect_vo && effect_vo.rotate && effect_vo.rotate.y) && effect_vo.rotate.y || 0
									let z = (effect_vo && effect_vo.rotate && effect_vo.rotate.z) && effect_vo.rotate.z || 0
									// transform.localRotationEuler = new Laya.Vector3(x, y, z)
									local_Set3DLocalRotationEuler(transform, x, y, z)
									new_go.active = false
									this.horse_effect_dic[local_index].effect_sprite = new_go
									this.horse_move_effect_list.push(new_go)
								}
								let full_url = GameResPath.GetEffectPath(EffectResType.Horse, effect_vo.name)
								this.horse_effect_dic[local_index] = { res_url: full_url, bone_name: bone_name, effect_name: effect_vo.name, effect_sprite: null }
								local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back)
							}
						}
						++horse_particle_index
					}
				}
			}
		}

		if (this.GetWingId() && this.GetWingId() > 0 && this.wing_transform && this.wing_res_loaded_and_show && !this.wing_effect_dic) {
			let wing_pvo = Config_PRELOAD_CLIENT_CONFIG.SceneObjectParticle.Wing[this.GetWingId()]
			if (wing_pvo && wing_pvo.always) {
				this.wing_effect_dic = {}
				for (let bone_name in wing_pvo.always) {
					let effect_vo = wing_pvo.always[bone_name]
					if (this.wing_effect_dic[bone_name] == null) {
						let bone = local_Util.FindBone(this.wing_gameObject, bone_name)
						if (bone) {
							let load_call_back = (obj: Laya.Sprite3D) => {
								if (local_Util.IsNull(obj)) {
									console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load wing Particle" + effect_vo.name)
									return
								}

								if (!this.wing_transform || this.use_delete_method || this.is_push_to_cache || !this.wing_effect_dic || this.wing_effect_dic[bone_name] == null) {
									local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
									return
								}
								//这里必须要重新获取一次,可能有多次加载这个bone 上面的bone可能是之前删除的,但是引用还在
								let bone = local_Util.FindBone(this.wing_gameObject, bone_name)
								if (local_Util.IsNull(bone)) {
									local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
									return
								}
								if (this.wing_effect_dic[bone_name] && this.wing_effect_dic[bone_name].effect_sprite) {
									local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
									return
								}

								obj.active = true

								let new_go = obj
								bone.addChild(new_go)
								local_ResetTransform(new_go.transform)
								this.wing_effect_dic[bone_name].effect_sprite = new_go
							}
							let full_url = GameResPath.GetEffectPath(EffectResType.Wing, effect_vo.name)
							this.wing_effect_dic[bone_name] = { res_url: full_url, effect_name: effect_vo.name, effect_sprite: null }
							local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back)
						}
					}
				}
			}
		}

		if (this.GetBackId() && this.GetBackId() > 0 && this.back_transform && this.back_res_loaded_and_show && !this.back_effect_dic) {
			let back_pvo = Config_PRELOAD_CLIENT_CONFIG.SceneObjectParticle.BackOrnament[this.GetBackId()]
			if (back_pvo && back_pvo.always) {
				this.back_effect_dic = {}
				for (let bone_name in back_pvo.always) {
					let effect_vo = back_pvo.always[bone_name]
					if (this.back_effect_dic[bone_name] == null) {
						let bone = local_Util.FindBone(this.back_gameObject, bone_name)
						if (bone) {
							let load_call_back = (obj: Laya.Sprite3D) => {
								if (local_Util.IsNull(obj)) {
									console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load back Particle" + effect_vo.name)
									return
								}

								if (!this.back_transform || this.use_delete_method || this.is_push_to_cache || !this.back_effect_dic || this.back_effect_dic[bone_name] == null) {
									local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
									return
								}
								//这里必须要重新获取一次,可能有多次加载这个bone 上面的bone可能是之前删除的,但是引用还在
								let bone = local_Util.FindBone(this.back_gameObject, bone_name)
								if (local_Util.IsNull(bone)) {
									local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
									return
								}
								if (this.back_effect_dic[bone_name] && this.back_effect_dic[bone_name].effect_sprite) {
									local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
									return
								}

								obj.active = true

								let new_go = obj
								bone.addChild(new_go)
								local_ResetTransform(new_go.transform)
								this.back_effect_dic[bone_name].effect_sprite = new_go
							}
							let full_url = GameResPath.GetEffectPath(EffectResType.BackOrnament, effect_vo.name)
							this.back_effect_dic[bone_name] = { res_url: full_url, effect_name: effect_vo.name, effect_sprite: null }
							local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back)
						}
					}
				}
			}
		}
	}

	//隐藏坐骑,翅膀，武器特效
	public HideModelEffect() {

		if (this.horse_effect_dic) {
			for (let index in this.horse_effect_dic) {
				let vo = this.horse_effect_dic[index]
				if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite)) {
					vo.effect_sprite.active = false
				}
			}
		}
		if (this.weapon_effect_dic) {
			for (let weapon_bone_name in this.weapon_effect_dic) {
				let weapon_vo = this.weapon_effect_dic[weapon_bone_name]
				for (let bone_name in weapon_vo) {
					let vo = weapon_vo[bone_name]
					if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite)) {
						vo.effect_sprite.active = false
					}
				}
			}
		}
		if (this.wing_effect_dic) {
			for (let bone_name in this.wing_effect_dic) {
				let vo = this.wing_effect_dic[bone_name]
				if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite)) {
					vo.effect_sprite.active = false
				}
			}
		}

		if (this.back_effect_dic) {
			for (let bone_name in this.back_effect_dic) {
				let vo = this.back_effect_dic[bone_name]
				if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite)) {
					vo.effect_sprite.active = false
				}
			}
		}
	}

	//显示坐骑,翅膀，武器特效
	public ShowModelEffect() {
		if (this.horse_effect_dic) {
			for (let index in this.horse_effect_dic) {
				let vo = this.horse_effect_dic[index]
				if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite) && this.horse_move_effect_list.indexOf(vo.effect_sprite) == -1) {
					vo.effect_sprite.visible = true
				}
			}
		}
		if (this.weapon_effect_dic) {
			for (let weapon_bone_name in this.weapon_effect_dic) {
				let weapon_vo = this.weapon_effect_dic[weapon_bone_name]
				for (let bone_name in weapon_vo) {
					let vo = weapon_vo[bone_name]
					if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite)) {
						vo.effect_sprite.visible = true
					}
				}
			}
		}
		if (this.wing_effect_dic) {
			for (let bone_name in this.wing_effect_dic) {
				let vo = this.wing_effect_dic[bone_name]
				if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite)) {
					vo.effect_sprite.visible = true
				}
			}
		}
		if (this.back_effect_dic) {
			for (let bone_name in this.back_effect_dic) {
				let vo = this.back_effect_dic[bone_name]
				if (vo.effect_name && !local_Util.IsNull(vo.effect_sprite)) {
					vo.effect_sprite.visible = true
				}
			}
		}
	}

	public GetWingId() {


		//降神状态不需要翅膀
		if (this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Fake_Role) {
			if (this.vo.CheckIsGod && this.vo.CheckIsGod()) {
				return 0
			}
		}

		if ((this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.MainRole) && this.InMaskState()) {
			return MaskModel.GetInstance().GetMaskFlowerId(this.vo, FigureProtoVo.FigureType.Wing)
		}

		// return this.vo.GetFigureId && this.vo.GetFigureId(FigureProtoVo.FigureType.Wing) || 0
		// }
		// return 0

		return local_Util.GetWingClotheId(this.vo);
	}

	public GetBackId() {
		//降神状态不需要背饰
		if (this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Fake_Role) {
			if (this.vo.CheckIsGod && this.vo.CheckIsGod()) {
				return 0
			}
		}
		if ((this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.MainRole) && this.InMaskState()) {
			return MaskModel.GetInstance().GetMaskFlowerId(this.vo, FigureProtoVo.FigureType.BackOrnament)
		}
		return local_Util.GetBackOrnamentId(this.vo);
	}

	/**
	 * 获取活跃度ID
	 * @returns 
	 */
	public GetLivenessId() {
		if ((this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.MainRole) && this.InMaskState()) {
			return 0
		}
		return local_Util.GetLivenessId(this.vo);
	}

	public LoadWingRes() {

		let wing_id = this.GetWingId()
		if (wing_id && wing_id > 0 && this.gameObject && !this.wing_res_loaded_and_show && !this.HasBlockSetting("wing") && this.scene_mgr.showWingScene()) {

			let wing_res_name = `${ModelPartName[7]}${wing_id}`
			let load_level = LOAD_QUEUE.LOW
			if (this._type == local_SceneBaseType.MainRole) {
				load_level = LOAD_QUEUE.HIGHT
			}

			let wing_res_url = GameResPath.GetObjectPath("wing", wing_res_name)
			let params = {
				module: "wing",
				name: "Scene",
				id: this.scene_mgr.GetSceneId(),
			}
			wing_res_url += GetParams(params)
			this.wing_res_url = wing_res_url

			let load_call_back = (obj) => {
				if (local_Util.IsNull(obj)) {
					console.warn("cannot find wing res = " + wing_id)
					return
				}
				if (this.use_delete_method || this.is_in_cache_pool || !this.wing_res_url || !this.transform) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}
				if (!this.GetWingId() || this.GetWingId() == 0) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}

				if (this.wing_gameObject) {
					// let tem_ignore_pool = this.ignore_pool
					if (wing_res_url == this.wing_res_url) { //最后加载的模型是最新的
						// this.ignore_pool = true
						this.RemoveWing()
						// this.ignore_pool = tem_ignore_pool
					} else {
						// new_go.destroy() //最后加载的模型不是最新的 就删掉该模型
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
						return
					}
				}

				this.wing_gameObject = obj
				this.wing_gameObject.active = true
				this.wing_transform = this.wing_gameObject.transform
				this.wing_animator = this.wing_gameObject.getComponent(Laya.Animator)

				let skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_GetSkinnedMeshSprite3D(obj)
				if (skin_mesh_renderer) {
					this.wing_skin_mesh_renderer = skin_mesh_renderer
				}
				let bone = local_Util.FindBone(this.transform.owner, AttachNode.Wing)
				if (bone == null) {
					return
				}
				this.wing_res_loaded_and_show = true
				bone.addChild(this.wing_gameObject)
				local_ResetTransform(this.wing_transform)

				this.LoadWingResComplete() //加载坐骑资源完成 回调
			}
			this.last_wing_id = wing_id

			if (this.wing_res_url) {

				local_ResManager.GetInstance().CreatePrefab(this.hashCode, this.wing_res_url, load_call_back, load_level)
			}
		}
	}

	public LoadBackOrnamentRes() {
		let back_id = this.GetBackId()
		if (back_id && back_id > 0 && this.gameObject && !this.back_res_loaded_and_show && !this.HasBlockSetting("back") && this.scene_mgr.showBackScene()) {

			let back_res_name = `${ModelPartName[20]}${back_id}`
			let load_level = LOAD_QUEUE.LOW
			if (this._type == local_SceneBaseType.MainRole) {
				load_level = LOAD_QUEUE.HIGHT
			}

			let back_res_url = GameResPath.GetObjectPath("back", back_res_name)
			let params = {
				module: "back",
				name: "Scene",
				id: this.scene_mgr.GetSceneId(),
			}
			back_res_url += GetParams(params)
			this.back_res_url = back_res_url

			let load_call_back = (obj) => {
				if (local_Util.IsNull(obj)) {
					console.warn("cannot find back res = " + back_id)
					return
				}
				if (this.use_delete_method || this.is_in_cache_pool || !this.back_res_url || !this.transform) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}
				if (!this.GetBackId() || this.GetBackId() == 0) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}

				if (this.back_gameObject) {
					if (back_res_url == this.back_res_url) { //最后加载的模型是最新的
						this.RemoveBackOrnament()
					} else {
						// new_go.destroy() //最后加载的模型不是最新的 就删掉该模型
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
						return
					}
				}

				this.back_gameObject = obj
				this.back_gameObject.active = true
				this.back_transform = this.back_gameObject.transform
				this.back_animator = this.back_gameObject.getComponent(Laya.Animator)
				let skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_GetSkinnedMeshSprite3D(obj)
				if (skin_mesh_renderer) {
					this.back_skin_mesh_renderer = skin_mesh_renderer
				}
				let bone = local_Util.FindBone(this.transform.owner, AttachNode.BackOrnament)
				if (bone == null) {
					return
				}
				this.back_res_loaded_and_show = true
				bone.addChild(this.back_gameObject)
				local_ResetTransform(this.back_transform)

				this.LoadBackResComplete() //加载坐骑资源完成 回调
			}
			this.last_back_id = back_id
			if (this.back_res_url) {
				local_ResManager.GetInstance().CreatePrefab(this.hashCode, this.back_res_url, load_call_back, load_level)
			}
		}
	}

	public LoadLiveness(){
		let liveness_id = this.GetLivenessId()
		if (liveness_id && liveness_id > 0 && this.gameObject && !this.liveness_res_loaded_and_show && !this.HasBlockSetting("liveness") && this.scene_mgr.showLivenessScene()) {
			let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
			if(!config_dragon_ball_figure) return
			let cfg
			for(let key in config_dragon_ball_figure){
				var v = config_dragon_ball_figure[key]
				if(v.id == liveness_id){
					cfg = v
					break
				}
			}
			if(!cfg) return
			let liveness_res_name = cfg.model_id
			let load_level = LOAD_QUEUE.LOW
			if (this._type == local_SceneBaseType.MainRole) {
				load_level = LOAD_QUEUE.HIGHT
			}

			let liveness_res_url = GameResPath.GetEffectPath(EffectResType.XingHe, liveness_res_name)

			this.liveness_res_url = liveness_res_url
			let load_call_back = (obj) => {
				if (local_Util.IsNull(obj)) {
					console.warn("cannot find liveness res = " + liveness_id)
					return
				}
				if (this.use_delete_method || this.is_in_cache_pool || !this.liveness_res_url || !this.transform) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}
				if (!this.GetLivenessId() || this.GetLivenessId() == 0) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}

				if (this.liveness_gameObject) {
					if (liveness_res_url == this.liveness_res_url) { //最后加载的模型是最新的
						this.RemoveLiveness()
					} else {
						// new_go.destroy() //最后加载的模型不是最新的 就删掉该模型
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
						return
					}
				}

				this.liveness_gameObject = obj
				this.liveness_gameObject.active = true
				this.liveness_transform = this.liveness_gameObject.transform
				let bone = this.root_transform.owner
				if (bone == null) {
					return
				}
				
				this.liveness_res_loaded_and_show = true
				bone.addChild(this.liveness_gameObject)
				local_ResetTransform(this.liveness_transform)
				this.liveness_transform.localRotation = local_Laya.Quaternion.DEFAULT
				local_Util.tempVector3.setValue(0, local_SceneObj.StartRotate.y, 0)
				this.liveness_transform.rotate(local_Util.tempVector3, true, false)
				local_Util.tempVector3.setValue(15, 0, 0)
				this.liveness_transform.rotate(local_Util.tempVector3, true, false)

				this.LoadLivenessResComplete() //加载坐骑资源完成 回调
			}
			this.last_liveness_id = liveness_id
			if (this.liveness_res_url) {
				local_ResManager.GetInstance().CreatePrefab(this.hashCode, this.liveness_res_url, load_call_back, load_level)
			}
		}
	}

	public ChangeLiveness() {
		if (this.GetLivenessId() && this.GetLivenessId() > 0 && !this.HasBlockSetting("liveness")) {
			this.ShowLiveness(true)
		} else {
			this.HideLiveness()
		}
	}

	public ShowLiveness(force_change?) {
		if (this.liveness_res_loaded_and_show == false || force_change) {
			let liveness_id = this.GetLivenessId()
			if (this.liveness_gameObject && this.last_liveness_id == liveness_id && !force_change) {
				this.liveness_res_loaded_and_show = true
				this.liveness_gameObject.active = true
			} else {
				if (force_change) {
					this.RemoveLiveness()
				}
				this.LoadLiveness()
			}
		}
	}

	public RemoveLiveness() {
		if (this.liveness_gameObject) {
			if (!this.ignore_pool) {
				local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, this.liveness_gameObject.url, this.liveness_gameObject)
			} else {
				this.liveness_gameObject.destroy()
			}
			this.liveness_gameObject = undefined
			this.liveness_transform = undefined
			this.liveness_res_loaded_and_show = false
		}
		this.liveness_res_url = null
	}

	public HideLiveness(){
		if (this.liveness_res_loaded_and_show) {
			this.liveness_res_loaded_and_show = false
			this.liveness_gameObject.active = false
		}
	}

	public HideWing() {
		if (this.wing_res_loaded_and_show) {
			this.wing_res_loaded_and_show = false
			this.wing_gameObject.active = false
		}
	}

	public HideBackOrnament() {
		if (this.back_res_loaded_and_show) {
			this.back_res_loaded_and_show = false
			this.back_gameObject.active = false
		}
	}

	public LoadWingResComplete() {
		this.LoadModeParticle()
		// 加载中改变状态
		if (this.IsMoveBrickState()) {
			this.HideWing()
		}
	}

	public LoadBackResComplete() {
		this.LoadModeParticle()
		if (this.IsMoveBrickState()) {
			this.HideBackOrnament()
		}
	}

	public LoadLivenessResComplete() {
		if (this.IsMoveBrickState() || this.IsRide()) {
			this.HideLiveness()
		}
	}

	public RemoveWing() {

		if (this.wing_effect_dic) {
			for (let bone_name in this.wing_effect_dic) {
				let vo = this.wing_effect_dic[bone_name]
				if (vo.effect_name && vo.effect_sprite) {
					if (this.ignore_pool) {
						vo.effect_sprite.destroy()
					} else {
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, vo.res_url, vo.effect_sprite)
					}
				}
			}
			this.wing_effect_dic = null
		}

		if (this.wing_gameObject) {
			if (!this.ignore_pool) {
				local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, this.wing_gameObject.url, this.wing_gameObject)
			} else {
				this.wing_gameObject.destroy()
			}
			this.wing_gameObject = undefined
			this.wing_transform = undefined
			this.wing_animator = undefined
			this.wing_skin_mesh_renderer = undefined
			this.wing_res_loaded_and_show = false
		}
		this.wing_res_url = null
	}

	public RemoveBackOrnament() {
		if (this.back_effect_dic) {
			for (let bone_name in this.back_effect_dic) {
				let vo = this.back_effect_dic[bone_name]
				if (vo.effect_name && vo.effect_sprite) {
					if (this.ignore_pool) {
						vo.effect_sprite.destroy()
					} else {
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, vo.res_url, vo.effect_sprite)
					}
				}
			}
			this.back_effect_dic = null
		}

		if (this.back_gameObject) {
			if (!this.ignore_pool) {
				local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, this.back_gameObject.url, this.back_gameObject)
			} else {
				this.back_gameObject.destroy()
			}
			this.back_gameObject = undefined
			this.back_transform = undefined
			this.back_animator = undefined
			this.back_skin_mesh_renderer = undefined
			this.back_res_loaded_and_show = false
		}
		this.back_res_url = null
	}

	public RemoveWeapon(bone_name?) {
		if (this.weapon_sprite_dic) {
			let weapon_info = this.weapon_sprite_dic[bone_name]
			if (weapon_info) {
				delete this.weapon_sprite_dic[bone_name]
				weapon_info.bone_name = bone_name
				weapon_info.go.active = true
				return weapon_info
			}
		}
	}

	public AddWeapon(weapon_info?) {
		if (this.weapon_sprite_dic && weapon_info && weapon_info.bone_name) {
			let bone_go = local_Util.FindBone(this.transform.owner, weapon_info.bone_name)
			if (bone_go) {
				bone_go.addChild(weapon_info.go)
				this.weapon_sprite_dic[weapon_info.bone_name] = weapon_info
				if (this.weapon_hide_flag_list[weapon_info.bone_name] && this.weapon_hide_flag_list[weapon_info.bone_name] > 0) {
					weapon_info.go.active = false
				} else {
					weapon_info.go.active = true
				}
				this.LoadModeParticle()
			}
		}
	}

	public GetWeapon(bone_name?) {
		if (this.weapon_sprite_dic && this.weapon_sprite_dic[bone_name]) {
			return this.weapon_sprite_dic[bone_name].go
		}
	}

	public HideAllWeapon(flag?) {
		if (!this.weapon_hide_flag_list) { return }
		for (let bone_name in this.weapon_hide_flag_list) {
			let _ = this.weapon_hide_flag_list[bone_name]
			this.SetWeaponHideFlag(bone_name, flag || local_Role.WeaponHideFlag.AllWeaponHideFlag, true)
		}
	}

	public ShowAllWeapon(flag?) {
		if (!this.weapon_hide_flag_list) { return }
		for (let bone_name in this.weapon_hide_flag_list) {
			let _ = this.weapon_hide_flag_list[bone_name]
			this.SetWeaponHideFlag(bone_name, flag || local_Role.WeaponHideFlag.AllWeaponHideFlag, false)
		}
	}


	public SetWeaponHideFlag(bone_name?, flag?, hide?) {

		if (!this.weapon_hide_flag_list) {
			this.weapon_hide_flag_list = {}
		}
		if (this.weapon_sprite_dic) {
			let weapon_hide_flag = this.weapon_hide_flag_list[bone_name] || 0
			let now_flag = 0
			if (hide) {
				now_flag = weapon_hide_flag | flag
			} else {
				now_flag = weapon_hide_flag & ~flag
			}
			if (now_flag == weapon_hide_flag) {
				return
			}
			weapon_hide_flag = now_flag
			if (weapon_hide_flag > 0) {
				if (this.weapon_sprite_dic[bone_name]) {
					this.weapon_sprite_dic[bone_name].go.active = false
				}
			} else {
				if (this.weapon_sprite_dic[bone_name]) {
					this.weapon_sprite_dic[bone_name].go.active = true
				}
			}
			this.weapon_hide_flag_list[bone_name] = weapon_hide_flag
		}
	}

	//是否包含指定flag
	public HasWeaponHideFlag(bone_name?, flag?) {
		if (!this.weapon_hide_flag_list) { return }
		flag = flag || local_Role.WeaponHideFlag.AllWeaponHideFlag
		return this.weapon_hide_flag_list[bone_name] && (this.weapon_hide_flag_list[bone_name] & flag) != 0
	}

	//移除所有武器光效
	public RemoveAllWeaponEffect() {

		if (this.weapon_effect_dic) {
			for (let weapon_bone_name in this.weapon_effect_dic) {
				let weapon_vo = this.weapon_effect_dic[weapon_bone_name]
				for (let bone_name in weapon_vo) {
					let vo = weapon_vo[bone_name]
					if (vo.res_url && !local_Util.IsNull(vo.effect_sprite)) {
						if (this.ignore_pool) {
							vo.effect_sprite.destroy()
						} else {
							local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, vo.res_url, vo.effect_sprite)
						}
					}
				}
			}
			this.weapon_effect_dic = null
		}
	}

	public RemoveAttackAllWeapon() {
		if (!local_Util.IsTableEmpty(this.weapon_sprite_dic)) {
			this.SetAlpha(1)
			this.RemoveAllWeaponEffect()
			for (let bone_name in this.weapon_sprite_dic) {
				let vo = this.weapon_sprite_dic[bone_name]
				if (vo) {
					if (!local_Util.IsNull(vo.go)) {
						if (!this.ignore_pool && vo.res_url) {
							local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, vo.res_url, vo.go)
						}
						else {
							vo.go.destroy()
						}
					}
				}
			}
			this.weapon_sprite_dic = {}
			this.SetWeaponClotheRes(null)
		}
	}

	//是否有改变透明度
	public HasAlpha(flag?) {

		if (flag == null) {
			return !local_Util.IsTableEmpty(this.alpha_flag_value_list)
		} else {
			return this.alpha_flag_value_list && this.alpha_flag_value_list[flag]
		}
	}

	//获取当前可以设置的alpha
	public GetCurrFlagAlpha() {

		let nearest_flag = null
		let nearest_time = 0
		if (!this.alpha_flag_value_list) { return [null, null] }
		for (let flag in this.alpha_flag_value_list) {
			let vo = this.alpha_flag_value_list[flag]
			if (vo.time > nearest_time) {
				nearest_time = vo.time
				nearest_flag = flag
			}
		}
		if (nearest_flag) {
			let vo = this.alpha_flag_value_list[nearest_flag]
			if (vo) {
				return [nearest_flag, vo.a]
			}
		}
		return [null, null]
	}

	//设置模型透明值 对外调用的接口
	public SetAlphaFlag(flag?, alpha?) {
		let now_flag = 0
		if (!this.alpha_flag_value_list) {
			this.alpha_flag_value_list = {}
		}
		if (alpha < 1) {
			now_flag = this.alpha_flag | flag
			this.alpha_flag_value_list[flag] = { a: alpha, time: local_Status.NowTime }
			this.SetAlpha(alpha)
		} else {
			now_flag = this.alpha_flag & ~flag
			delete this.alpha_flag_value_list[flag]
			if (now_flag == 0) {
				this.SetAlpha(1)
			} else {
				let [_, a] = this.GetCurrFlagAlpha()
				if (a) {
					this.SetAlpha(a)
				}
			}
		}
		this.alpha_flag = now_flag
	}

	//设置模型透明度
	public SetAlpha(alpha?) {


		if (this.alpha == alpha) { return }
		if (!this.HasAlpha(local_Role.AlphaFlag.HorseDown) && !this.HasAlpha(local_Role.AlphaFlag.HorseUp)) {
			if (this.head_wear_skin_mesh_renderer && !local_Util.IsNull(this.head_wear_skin_mesh_renderer)) {
				let unlit_material: Laya.UnlitMaterial = this.head_wear_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
				if (unlit_material) {

					if (alpha < 1) {
						if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT)
							unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT
						unlit_material.albedoColorA = alpha
					} else {
						if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_OPAQUE)
							unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_OPAQUE
						unlit_material.albedoColorA = 1
					}
				}
			}
		}
		if (this.horse_skin_mesh_renderer && !local_Util.IsNull(this.horse_skin_mesh_renderer)) {
			let unlit_material: Laya.UnlitMaterial = this.horse_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
			if (unlit_material) {
				if (alpha < 1) {
					if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT)
						unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT
					unlit_material.albedoColorA = alpha
				} else {
					if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_OPAQUE)
						unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_OPAQUE
					unlit_material.albedoColorA = 1
				}

			}
			if (this.HasAlpha(local_Role.AlphaFlag.HorseDown) || this.HasAlpha(local_Role.AlphaFlag.HorseUp)) {
				this.alpha = alpha
				return
			}
		}

		if (this.wing_skin_mesh_renderer && !local_Util.IsNull(this.wing_skin_mesh_renderer)) {
			let unlit_material: Laya.UnlitMaterial = this.wing_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
			if (unlit_material) {
				if (alpha < 1) {
					if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT)
						unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT
					unlit_material.albedoColorA = alpha
				} else {
					if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_OPAQUE)
						unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_OPAQUE
					unlit_material.albedoColorA = 1
				}

			}
		}

		if (this.back_skin_mesh_renderer && !local_Util.IsNull(this.back_skin_mesh_renderer)) {
			let unlit_material: Laya.UnlitMaterial = this.back_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
			if (unlit_material) {
				if (alpha < 1) {
					if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT)
						unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT
					unlit_material.albedoColorA = alpha
				} else {
					if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_OPAQUE)
						unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_OPAQUE
					unlit_material.albedoColorA = 1
				}

			}
		}

		let has_weapon = !local_Util.IsTableEmpty(this.weapon_sprite_dic)
		if (has_weapon) {
			for (let name in this.weapon_sprite_dic) {
				let vo = this.weapon_sprite_dic[name]
				if (vo && vo.go && vo.mesh && !local_Util.IsNull(vo.mesh)) {
					let unlit_material: Laya.UnlitMaterial = vo.mesh.skinnedMeshRenderer.material as Laya.UnlitMaterial
					if (unlit_material) {
						if (alpha < 1) {
							if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT)
								unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_TRANSPARENT
							unlit_material.albedoColorA = alpha
						} else {
							if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_OPAQUE)
								unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_OPAQUE
							unlit_material.albedoColorA = 1
						}
					}
				}
			}
		}

		super.SetAlpha(alpha)
	}


	//武器贴图资源
	public SetWeaponClotheRes(weapon_clothe_res?) {

		this.weapon_clothe_id = weapon_clothe_res
		if (!this.weapon_clothe_id) {
			if (this.weapon_clothe_dic) {
				for (let abName in this.weapon_clothe_dic) {
					let clothe = this.weapon_clothe_dic[abName]
					clothe.DeleteMe()
				}
				this.weapon_clothe_dic = false
			}
		}
	}

	//添加单个武器贴图
	public AddWeaponClothe(boneName?, clothe?) {

		if (!this.weapon_clothe_dic) {
			this.weapon_clothe_dic = {}
		}
		this.weapon_clothe_dic[boneName] = clothe
	}

	public WaitForNextMove() {

		if (!this.CanMove()) {
			return
		}
		this.ChangeState(local_PoseState.WAITSTAND)
	}

	public DoRush(rush_end_pos?, rush_add_speed?) {

		this.rush_add_speed = rush_add_speed

		this.rush_speed = 800

		this.SetDirection(this.real_pos, rush_end_pos, true, true)

		//计算移动基本信息
		this.state_move_dir.x = rush_end_pos.x - this.real_pos.x
		this.state_move_dir.y = rush_end_pos.y - this.real_pos.y
		let distance = this.state_move_dir.normalise()

		this.state_move_start_pos.x = this.real_pos.x
		this.state_move_start_pos.y = this.real_pos.y

		this.state_move_end_pos.x = rush_end_pos.x
		this.state_move_end_pos.y = rush_end_pos.y
		this.state_move_total_distance = distance
		this.state_move_pass_distance = 0.0
		this.state_move_start_time = local_Status.NowTime
		this.ChangeState(local_PoseState.RUSH)
	}

	public UpdateStateRush(state_name?, elapse_time?) {

		if (this.state_move_total_distance != null) {
			this.rush_speed = this.rush_speed + this.rush_add_speed * elapse_time
			this.rush_speed = Math.min(this.rush_speed, 1500)
			this.state_move_pass_distance = this.state_move_pass_distance + this.GetMoveSpeed(this.state_move_dir, this.rush_speed) * elapse_time
			if (this.state_move_pass_distance >= this.state_move_total_distance) {
				this.SetRealPos(this.state_move_end_pos.x, this.state_move_end_pos.y)
				this.state_move_total_distance = null
				this.DoStand()
			} else {
				let x = this.state_move_start_pos.x + this.state_move_dir.x * this.state_move_pass_distance
				let y = this.state_move_start_pos.y + this.state_move_dir.y * this.state_move_pass_distance
				this.SetRealPos(x, y)
			}
		}
	}

	public EnterStateRush(state_name?) {

		if (this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.Fake_Role) {
			let rush_vo = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.RushAction[this.vo.career + "@" + this.vo.sex]
			if (rush_vo && this.vo && this.vo.god_id <= 0) {
				//Math.randomseed(os.time())
				let index = local_Util.RandomRange(0, rush_vo.length - 1)
				this.PlayAction(rush_vo[index])
			} else {
				this.PlayAction("jump")
			}
		} else {
			let action_name = this.GetActionName("run")
			this.PlayAction(action_name)
		}
	}

	public QuitStateRush(state_name?) {
		this.rush_speed = null
	}


	public ChangeStateEnter(state: number) {
		// if (state != local_PoseState.HITED && state != local_PoseState.JUMP && state != local_PoseState.TASK_JUMP) {
		// 	this.SetLandInfo()
		// }
		super.ChangeStateEnter(state)
	}



	public ChangeCollectState() {
		let collect_state = this.vo.collect_state
		if (collect_state) {
			this.DoCollect()
		}
		else {
			if (this.IsInState(local_PoseState.COLLECT)) {
				this.DoStand()
			}
		}
	}

	public ChangeClothe(res_path?, loadback?) {

		if (res_path) {
			if (!local_Util.IsNull(this.skin_mesh_renderer) && this.skin_mesh_renderer.skinnedMeshRenderer.material) {
				let unlit_material: Laya.UnlitMaterial = this.skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
				if (!this.clothe)
					this.clothe = new Clothe(unlit_material, res_path, loadback)
				else
					this.clothe.LoadTexture(unlit_material, res_path, loadback)
			}
		}
	}

	//时装贴图资源
	public SetFashionModelRes(fashion_res?) {

		this.fashion_res = fashion_res
		if (this.fashion_res == null) {
			if (this.clothe) {
				this.clothe.DeleteMe()
				this.clothe = null
			}
		}
	}
	public CreateClotheSprite(role_res, ignore_pool?, force_load_clothe_type?) {
		if (this.HasModelHideFlag(local_SceneObj.ModelHideFlag.RoleNumLimit) || this.HasModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole)) {
			this.cache_model_res = role_res
			this.cache_ignore_pool = ignore_pool
			this.cache_force_load_clothe_type = force_load_clothe_type
			return
		}
		let load_level = LOAD_QUEUE.LOW
		if (this._type == local_SceneBaseType.MainRole) {
			load_level = LOAD_QUEUE.HIGHT
		}

		super.CreateClotheSprite(role_res, ignore_pool, force_load_clothe_type, load_level)
	}


	public RemoveHorse() {
		this.horse_move_effect_list.length = 0
		if (this.horse_effect_dic) {
			for (let index in this.horse_effect_dic) {
				let vo = this.horse_effect_dic[index]
				if (vo.res_url && !local_Util.IsNull(vo.effect_sprite)) {
					if (this.ignore_pool) {
						vo.effect_sprite.destroy()
					} else {
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, vo.res_url, vo.effect_sprite)
					}
				}
			}
			this.horse_effect_dic = undefined
		}

		if (!local_Util.IsNull(this.horse_gameObject)) {
			if (this.transform && this.modelObj_transform && !local_Util.IsNull(this.transform.owner) && !local_Util.IsNull(this.modelObj_transform.owner)) { //銷毀前角色先從座騎裏移出來
				this.modelObj_transform.owner.addChild(this.gameObject)
			}
			if (!this.ignore_pool) {
				CommonPlayAnim(this.horse_animator, "idle")
				local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, this.horse_gameObject.url, this.horse_gameObject)
			} else {
				this.horse_gameObject.destroy()
			}
			this.SetShadowVisible(true)
			this.horse_transform = undefined
			this.horse_gameObject = undefined
			this.horse_animator = undefined
			this.horse_skin_mesh_renderer = undefined
			this.horse_move_effect_list = []

			this.horse_res_loaded_and_show = false

			this.horse_up_action_last_time = false
			this.horse_up_action_start_time = false
			this.horse_down_action_start_time = false
			this.horse_down_action_last_time = false
			this.horse_down_action_direction = null
			this.horse_res_url = null
		}


		//下马可能之前存在标志，导致模型透明
		if (this.alpha_flag_value_list) {
			delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseUp]
			delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseDown]
		}
	}

	// is_get_rise_cross 是否获得是的上坐骑的过渡动作
	public GetRideHorseActionName(is_get_rise_cross?) {
		if (is_get_rise_cross) return "rideup"
		let horse_id = this.GetHorseId()
		let action
		let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigHorse.FigureToRideAction
		if (cfg) {
			action = cfg[horse_id]
		}
		return action || "ride"
	}


	public PlayAction(action_name?, dir?, force_action_cross_time?, not_change_same_action = false) {
		if (!action_name) return null
		if (dir) {
			this.SetDirection(dir)
		}
		this.last_action_name = action_name
		this.curr_body_action_name = action_name

		let cross_time
		if (this.ActionNotCross()) {
			cross_time = 0
		} else {
			if (force_action_cross_time == null) {
				cross_time = (action_name == "idle") && Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.cross_animation_time || 0
			} else {
				cross_time = force_action_cross_time
			}
		}

		//坐骑动作切换
		if (action_name == "idle" || action_name == "run") {
			if (this.horse_animator && this.IsOnHorse())
			{
				if (action_name == "run") {
					this.PlayHorseEffect(true)
				} else {
					this.PlayHorseEffect(false)
				}
				CommonCrossFadeAnim(this.horse_animator, action_name, cross_time, not_change_same_action)
			}
		}

		if (this.IsOnHorse()) {
			this.curr_body_action_name = this.GetRideHorseActionName()
			not_change_same_action = true
		}
		if (this.scene_mgr.IsWeddingScene() && this.curr_body_action_name == "walk") {
			this.SetPlaySpeed(2)
		}
		if (!this.horse_up_action_start_time) {
			CommonCrossFadeAnim(this.animator, this.curr_body_action_name, cross_time, not_change_same_action)
		}
	}
	public PlayHorseEffect(bool?) {
		if (this.horse_move_effect_list.length > 0){
			for(let obj of this.horse_move_effect_list){
				obj.active = bool
			}
		}
	}

	//是否有设置制定的屏蔽设置
	public HasBlockSetting(key?) {
		if (key) {
			return local_GameSettingManager.GetInstance().ExistBlockSet(key)
		}
		return false
	}


	public LoadHorseRes(not_cross?) {
		if (!this.RideHorseCond()) {
			return
		}
		let horse_id = this.GetHorseId()
		if (horse_id && horse_id > 0 && this.gameObject && (!this.horse_res_loaded_and_show || (this.last_horse_id > 0 && this.last_horse_id != horse_id))) {
			this.last_horse_id = horse_id
			let horse_res_name = GameResPath.GetModelClotheRes(local_SceneBaseType.Horse, this.last_horse_id)

			let horse_res_url = GameResPath.GetTypePath(local_SceneBaseType.Horse, horse_res_name)
			let load_level = LOAD_QUEUE.LOW
			if (this._type == local_SceneBaseType.MainRole) {
				load_level = LOAD_QUEUE.HIGHT
			}
			let params = {
				module: "mount",
				name: "Scene",
				id: this.scene_mgr.GetSceneId(),
			}
			horse_res_url += GetParams(params)
			this.horse_res_url = horse_res_url
			let load_call_back = (obj: Laya.Sprite3D) => {
				if (local_Util.IsNull(obj)) {
					console.warn("cannot find horse res = " + this.GetHorseId())
					return
				}
				if (this.use_delete_method || this.is_in_cache_pool || !this.horse_res_url || !this.transform) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}
				if (!this.GetHorseId() || this.GetHorseId() == 0) {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}
				if (this.horse_gameObject) {
					// let tem_ignore_pool = this.ignore_pool
					if (horse_res_url == this.horse_res_url) { //最后加载的模型是最新的
						// this.ignore_pool = true
						this.RemoveHorse()
						// this.ignore_pool = tem_ignore_pool
					} else {
						// obj.destroy()  //最后加载的模型不是最新的 就删掉该模型
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
						return
					}
				}


				let skin_mesh_renderers = local_Util.GetComponents(obj, Laya.SkinnedMeshSprite3D)
				let skin_mesh_renderer: Laya.SkinnedMeshSprite3D
				for (let i = 0; i < skin_mesh_renderers.length; i++) {
					skin_mesh_renderer = skin_mesh_renderers[i]
					if (skin_mesh_renderer) {
						let unlit_material: Laya.UnlitMaterial = skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
						if (unlit_material) {
							if (unlit_material.renderMode != local_Laya.UnlitMaterial.RENDERMODE_OPAQUE)
								unlit_material.renderMode = local_Laya.UnlitMaterial.RENDERMODE_OPAQUE
							unlit_material.albedoColor = new local_Laya.Vector4(1, 1, 1, 1)
						}
					}
				}

				this.horse_gameObject = obj
				this.horse_transform = this.horse_gameObject.transform
				this.horse_animator = obj.getComponent(Laya.Animator)
				// if (this._type == local_SceneBaseType.MainRole) {
				// 	this.horse_animator["main_role"] = true
				// }
				// else{
				// 	this.horse_animator["main_role"] = null
				// }

				let horse_skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_GetSkinnedMeshSprite3D(obj)
				if (horse_skin_mesh_renderer) {
					this.horse_skin_mesh_renderer = horse_skin_mesh_renderer
				}
				this.horse_res_loaded_and_show = true
				this.modelObj_transform.owner.addChild(obj)

				local_Set3DLocalPosition(this.horse_transform, 0, 0, 0)
				local_Set3DLocalRotationEuler(this.horse_transform, 0, 0, 0)
				local_Set3DLocalScale(this.horse_transform, 1, 1, 1)

				if (this.horse_skin_mesh_renderer) {
					let horse_size = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.horse_res_bound && Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.horse_res_bound[this.last_horse_id]
					if (horse_size) {
						this.horse_res_size.x = horse_size.x
						this.horse_res_size.y = horse_size.y * (this.default_model_scale + 0.1)
					} else {
						let mesh_size_y = this.horse_skin_mesh_renderer.skinnedMeshRenderer.localBounds.getExtent().x * 2 * 0.79 //cos38 模型倾斜角度
						this.horse_res_size.x = 200
						this.horse_res_size.y = mesh_size_y * 100 * this.default_model_scale
						let bone: Laya.Sprite3D = local_Util.FindBone(this.horse_transform.owner, AttachNode.Ride)
						if (bone) {
							this.model_height_in_horse = this.model_res_size.y + (bone.transform.position.y - this.horse_transform.position.y) * 100
						}
					}
				}

				//下马可能之前存在标志，导致模型透明
				if (this.alpha_flag_value_list) {//上坐骑的过程中
					delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseUp]
					delete this.alpha_flag_value_list[local_Role.AlphaFlag.HorseDown]
				}

				this.ResetResSize()
				this.SetShadowVisible(true)
				this.LoadHorseResComplete(not_cross)	//加载坐骑资源完成 回调
			}
			if (this.horse_res_url) {
				local_ResManager.GetInstance().CreatePrefab(this.hashCode, this.horse_res_url, load_call_back, load_level)
			}
		}
	}

	public ResetResSize() {

		if (this.horse_res_loaded_and_show) {
			this.res_size.x = Math.max(this.horse_res_size.x, this.model_res_size.x)
			this.res_size.y = Math.max(this.horse_res_size.y, this.model_height_in_horse, this.model_res_size.y) //* Math.cos(SceneObj.StartRotate.x / 180 * Math.PI)
		} else {
			this.res_size.x = this.model_res_size.x
			this.res_size.y = this.model_res_size.y //* Math.cos(SceneObj.StartRotate.x / 180 * Math.PI)
		}

		this.SetScale(this.scale)
	}

	// 在坐骑（骑乘状态）上
	public IsOnHorse() {
		return this.GetHorseId() > 0 && this.horse_res_loaded_and_show && this.vo.GetFigureRideState && this.vo.GetFigureRideState(FigureProtoVo.FigureType.Horse) == 1
	}

	// 判断当前人物骑乘状态
	public IsRide() {
		return this.vo && this.vo.GetFigureRideState && this.vo.GetFigureRideState(FigureProtoVo.FigureType.Horse) == 1
	}

	public RideHorseCond() {
		if (this.IsDead()) {
			return false
		}

		//
		let horse_id = this.GetHorseId()
		if (horse_id == 0) {
			return false
		}

		if (this.HasBlockSetting("horse")) {
			return false
		}


		//海域板砖
		if (this.IsMoveBrickState()) {
			return false
		}

		//
		if (!this.scene_mgr.showHorseScene()) {
			return false
		}

		//
		if (this.scene_mgr.HideOnlyRoleScene()) {
			return false
		}

		//
		if (this.vo && this.vo.CheckIsGod && this.vo.CheckIsGod()) {
			return false
		}

		return true
	}

	//上马
	public RideHorse(not_cross = false) {
		if (this.IsRide() && this.RideHorseCond()) {
			// if (this.horse_res_loaded_and_show == false) {
			let horse_id = this.GetHorseId()
			if (this.horse_gameObject && horse_id > 0 && this.last_horse_id == horse_id) {
				if (this.last_horse_id == horse_id && this.IsOnHorse()) {
					return
				}
				this.horse_res_loaded_and_show = true
				if (!local_Util.IsNull(this.horse_gameObject)) {
					this.horse_gameObject.active = true
					if (this.horse_down_action_start_time) {
						this.horse_down_action_start_time = null
						this.horse_down_action_last_time = null

						this.modelObj_transform.owner.addChild(this.horse_transform.owner)
						local_Set3DLocalPosition(this.horse_transform, 0, 0, 0)
					}
				}
				this.UpHorseCross(not_cross)
				this.ResetResSize()
			} else {
				this.LoadHorseRes(not_cross)
			}
			this.HideAllWeapon(local_Role.WeaponHideFlag.Horse)
			this.HideLiveness()
			this.SetShadowVisible(true)
			// }
		}
	}

	public DownHorse(force_down?) {
		if (!this.horse_animator || local_Util.IsNull(this.horse_animator.owner as Laya.Sprite) || local_Util.IsNull(this.transform.owner)) {
			return
		}
		if (this.GetType() == local_SceneBaseType.MainRole)
			CameraManager.GetInstance().SetBaseScale(1)
		if (this.horse_res_loaded_and_show == true) {
			if (this.horse_res_loaded_and_show) {
				this.horse_res_loaded_and_show = false
			}

			this.horse_up_action_start_time = null
			this.horse_up_action_last_time = null

			let copy_pos = this.transform.position.clone()
			this.modelObj_transform.owner.addChild(this.transform.owner)
			this.transform.position = copy_pos

			if (this.GetType() == local_SceneBaseType.MainRole && !force_down) {
				// console.warn("@@@@------DownHorse------4")
				this.SetAlphaFlag(local_Role.AlphaFlag.HorseUp, 1)
				this.SetAlphaFlag(local_Role.AlphaFlag.HorseDown, 1)

				this.horse_down_action_start_time = local_Status.NowTime
				this.horse_down_action_last_time = 0.4
				this.horse_animator.speed = 2
				LayerManager.GetInstance().Scene3D.addChild(this.horse_transform.owner)

				CommonCrossFadeAnim(this.horse_animator, "run", 0)
				// let rotationEuler: Laya.Vector3 = this.modelObj_transform.rotationEuler.clone()
				this.horse_transform.position = this.modelObj_transform.position
				this.horse_transform.rotationEuler = this.modelObj_transform.rotationEuler
				if (!this.horse_down_action_direction) {
					this.horse_down_action_direction = new Laya.Vector3()
				}

				this.modelObj_transform.getForward(this.horse_down_action_direction)
				this.horse_down_action_direction.setValue(-this.horse_down_action_direction.x, -this.horse_down_action_direction.y, -this.horse_down_action_direction.z)
				// console.warn("@@@@@@@@@@@@", this.horse_down_action_direction)
				// this.horse_transform.setParent(window["Application"].instance.sceneManager.activeScene.root, true)
				this.curr_body_action_name = null
				if (this.IsInState(local_PoseState.MOVE)) {
					this.curr_body_action_name = "run"
					if (this.IsMoveBrickState()) {
						this.curr_body_action_name = "carry2"
					}
				} else if (!this.IsInState(local_PoseState.ATTACK)) {
					this.curr_body_action_name = "idle"
					if (this.IsMoveBrickState()) {
						this.curr_body_action_name = "carry"
					}
				}
				if (this.curr_body_action_name) {
					CommonCrossFadeAnim(this.animator, this.curr_body_action_name, this.horse_down_action_last_time * 0.5)
				}

				if (this.IsInState(local_PoseState.MOVE)) {
					this.main_role_move_start_time = local_Status.NowTime
				} else {
					this.main_role_move_start_time = null
				}
			} else {
				local_Set3DLocalPosition(this.transform, 0, 0, 0)
				this.horse_gameObject.active = false
				this.modelObj_transform.owner.addChild(this.horse_gameObject)
				if (this.IsInState(local_PoseState.MOVE)) {
					let action_name = this.GetActionName("run")
					this.PlayAction(action_name, null, 0)
				} else {
					let action_name = this.GetActionName("idle")
					this.PlayAction(action_name, null, 0)
				}
			}

			this.SetShadowVisible(true)
			this.ResetResSize()
			this.ShowAllWeapon(local_Role.WeaponHideFlag.Horse)
			this.ShowLiveness()
		}
	}

	public LoadHorseResComplete(not_cross = false) {

		if (this.vo && this.vo.hp == 0) {
			this.DoDead()
		}
		this.LoadModeParticle()
		if (this.IsRide() && this.RideHorseCond()) {
			this.UpHorseCross(not_cross)
		}
		else {
			this.DownHorse(not_cross)
		}
		this.ChangeSpeedBuffEffect()
	}

	public UpdateRideAction() {
		if (this.IsInState(local_PoseState.MOVE) || this.IsInState(local_PoseState.WAITSTAND)) {
			this.PlayAction(this.GetActionName("run"), null, 0)
		} else {
			this.PlayAction(this.GetActionName("idle"), null, null, true)
		}
	}

	//上坐骑渐变过程
	public UpHorseCross(force = false) {
		// console.warn("@@@@------UpHorseCross------1")
		if (this.GetType() == local_SceneBaseType.MainRole)
			CameraManager.GetInstance().SetBaseScale(CameraManager.HORSE_OR_GOD_SCALE)
		if (!force && this.GetType() == local_SceneBaseType.MainRole) {
			// console.warn("@@@@------UpHorseCross------2")
			if (local_Util.IsNull(this.modelObj_transform.owner) || local_Util.IsNull(this.horse_transform.owner)) {
				return
			}
			this.horse_down_action_start_time = null
			this.horse_down_action_last_time = null
			this.horse_down_action_direction = null
			if (this.animator) {

				this.curr_body_action_name = this.GetRideHorseActionName(true)
				this.modelObj_transform.owner.addChild(this.horse_transform.owner)
				// this.horse_transform.localPosition = new Laya.Vector3(0, 0, 0)
				local_Set3DLocalPosition(this.horse_transform, 0, 0, 0)
				// this.horse_transform.localRotationEuler = new Laya.Vector3(0, 0, 0)
				local_Set3DLocalRotationEuler(this.horse_transform, 0, 0, 0)
				// this.horse_transform.localScale = new Laya.Vector3(1, 1, 1)
				local_Set3DLocalScale(this.horse_transform, 1, 1, 1)


				let total_time = 0
				let ani_layer: Laya.AnimatorControllerLayer = this.animator.getControllerLayer()
				if (ani_layer) {
					let ani_state: Laya.AnimatorState = ani_layer.getAnimatorState(this.curr_body_action_name)
					if (ani_state) {
						total_time = ani_state.clip.duration()
					}
				}

				if (total_time) {
					this.horse_up_action_start_time = local_Status.NowTime
					this.horse_up_action_last_time = total_time + 0.2
				} else {
					this.horse_up_action_last_time = 0
				}

				let bone: Laya.Sprite3D = local_Util.FindBone(this.horse_transform.owner, AttachNode.Ride)
				if (bone == null) {
					this.horse_up_action_last_time = null
					this.horse_up_action_start_time = null
					return
				}
				if (this.horse_up_action_last_time <= 0) {
					this.horse_up_action_last_time = null
					this.horse_up_action_start_time = null
					bone.addChild(this.transform.owner)
					this.UpdateRideAction()
					this.SetAlphaFlag(local_Role.AlphaFlag.HorseUp, 1)
					this.SetAlphaFlag(local_Role.AlphaFlag.HorseDown, 1)
				} else {
					let cache_pos: Laya.Vector3 = this.transform.position.clone()
					bone.addChild(this.transform.owner)
					this.transform.position = cache_pos
					this.SetAlphaFlag(local_Role.AlphaFlag.HorseUp, 0)
					this.SetAlphaFlag(local_Role.AlphaFlag.HorseDown, 1)
				}
				this.horse_animator.speed = 1
				if (total_time) {
					CommonCrossFadeAnim(this.animator, this.curr_body_action_name, 0)
				}
			}
		} else {
			// console.warn("@@@@------UpHorseCross------3")
			if (this.horse_res_loaded_and_show && !local_Util.IsNull(this.horse_transform.owner)) {
				let bone: Laya.Sprite3D = local_Util.FindBone(this.horse_transform.owner, AttachNode.Ride)
				if (local_Util.IsNull(bone) || local_Util.IsNull(this.transform.owner)) {
					return
				}
				bone.addChild(this.transform.owner)
				// this.transform.localPosition = new Laya.Vector3(0, 0, 0)
				local_Set3DLocalPosition(this.transform, 0, 0, 0)
				// this.transform.localRotationEuler = new Laya.Vector3(0, 0, 0)
				local_Set3DLocalRotationEuler(this.transform, 0, 0, 0)
				// console.warn("@@@@------UpHorseCross------4")
			}
		}
		this.UpdateRideAction()
	}

	public GetHorseId() {
		if (this.vo && this.vo.GetFigureId) {
			return MaskModel.GetInstance().GetMaskFlowerId(this.vo, FigureProtoVo.FigureType.Horse)
		}
		return 0
	}

	public SetHorseId(value?) {

		if (value == 0) {
			if (this.vo && this.vo.GetFigureId) {
				this.vo.SetFigureId(FigureProtoVo.FigureType.Horse, value, true)
				this.vo.SetFigureRideState(FigureProtoVo.FigureType.Horse, value)
			}
		}
	}


	//设置模型和特效的播放速度
	public SetPlaySpeed(speed?, ignore_effect?) {
		if (speed == this.last_anim_speed) {
			return
		}
		this.last_anim_speed = speed
		super.SetPlaySpeed(speed, ignore_effect)
		if (!local_Util.IsNull(this.horse_animator)) {
			this.horse_animator.speed = speed
		}
		if (!local_Util.IsNull(this.wing_animator)) {
			this.wing_animator.speed = speed
		}
		if (!local_Util.IsNull(this.back_animator)) {
			this.back_animator.speed = speed
		}
	}

	public IsMoveBrickState() {
		if (this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Role) {
			return this.vo && this.vo.brick_id > 0 && this.scene_mgr.IsSeaAsserScene()
		}
		return false
	}



	public GetAlphaModelGodID() {
		let god_id = this.vo.god_id
		return god_id
	}

	public GetHorseBone(bone_name?) {
		return local_Util.FindBone(this.horse_gameObject, bone_name)
	}

	protected LoadSameResCallback() {
		this.RemoveAttackAllWeapon()
		this.RemoveWing()
		this.RemoveBackOrnament()
		this.RemoveLiveness()
		this.RemoveHeadWear()
		this.RemoveAllParticle()
		this.RemoveGameObject()
		this.RemoveHorse()
	}
	public EnterStateDizzy(state_name?) {

		let action_name = this.GetActionName("idle")
		super.EnterStateDizzy(state_name, action_name)
	}

}
var local_Role = Role
window["Role"] = Role