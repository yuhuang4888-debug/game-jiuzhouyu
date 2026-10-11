import { Role } from "./Role";
import { Vector2 } from "../../util/Vector2";
import { Scene } from "../Scene";
import { AttachNode, EffectResType, MOVE_TYPE, SceneBaseType } from "../SceneConfig";
import { PoseState } from "../../util/StateMachineManager";
import { CameraManager } from "../CameraManager";
import { GameMath } from "../../util/GameMath";
import { ObjectEventType, EventName, SceneEventType } from "../../common/EventName";
import { GlobalEventSystem, LogicRealRatio_X, LogicRealRatio_Y } from "../../util/DeclareGlobalVar";
import { SceneManager } from "../SceneManager";
import { OperateManager } from "../../operation/OperateManager";
import { SkillManager } from "../../skill/SkillManager";
import { Message } from "../../sysInfo/SysInfoController";
import { Status } from "../../util/Status";
import { SourceOperateMove } from "../../operation/SourceOperateMove";
import { Character } from "./Character";
import { AutoFightManager } from "../../autofight/AutoFightManager";
import { SceneObj } from "./SceneObj";
import { Set3DLocalPosition, Set3DPosition, CommonCrossFadeAnim, Util, GlobalTimerQuest, Set3DLocalRotationEuler, Set3DLocalScale, Set3DLocalRotation } from "../../util/Util";
import { Config } from "../../common/Config";
import { FightEvent } from "../fight/FightEvent";
import { BanquetAniManager } from "../../marriage2/BanquetAniManager";
import { SoundManager } from "../../common/SoundManager";
import { Runner } from "../../util/Runner";
import { LayerManager } from "../../common/LayerManager";
import { ViewManager } from "../../common/ViewManager";
import { GameResPath } from "../../util/GameResPath";
import { ResManager } from "../../common/ResManager";
import { SapManager } from "../SapManager";
// TypeScript file
let local_PoseState = PoseState
let local_SceneBaseType = SceneBaseType
let local_SceneObj = SceneObj
let local_EventName = EventName
let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Status = Status
let local_Vector2 = Vector2
let local_SceneEventType = SceneEventType
let local_Util = Util
let local_GlobalEventSystem = GlobalEventSystem
let local_MOVE_TYPE = MOVE_TYPE
let local_Laya = Laya
let local_Set3DLocalPosition = Set3DLocalPosition
let local_Set3DLocalScale = Set3DLocalScale
let local_Set3DLocalRotationEuler = Set3DLocalRotationEuler
let local_ViewManager
export class MainRole extends Role {
	move_tip_count = 0
	delay_fly_shoe_effect
	fly_shoe_effect:Laya.Sprite3D
	start_show_fly_effect
	is_shoe_flying
	fly
	dir_move_param
	fighting_state_time
	next_send_time
	last_send_pos_time
	disabled = true
	need_dead_after_fly_shoe
	delay_change_god_id
	
	start_to_fight_time
	delay_auto_fight_id
	last_fire_pos
	next_send_dist
	main_camera: CameraManager
	main_role_has_bind_event = false
	is_ios = false
	move_update_elipse_time
	public constructor(vo?) {
		super()
		local_ViewManager = ViewManager
		this.main_camera = CameraManager.GetInstance()
		this._type = local_SceneBaseType.MainRole
		// this.InitRoleVo(vo)
		this.jump_height = 0
		//this.vo.safe_area_state = 0 //1角色处于安全区域状态  2角色处于非安全区域状态  3角色切场景进入安全区域状态
		this.horse_up_action_start_time = false
		this.horse_up_action_last_time = false
		this.last_send_pos_time = false
		this.state_move_total_distance = false
		this.delay_change_god_id = false
		this.fighting_state_time = false
		this.start_to_fight_time = 0

		this.is_ios = Laya.Browser.onIOS
		
		this._state_machine_manager.RegisterState(local_PoseState.FLY_SHOE_EFFECT, "EnterStateFlyShoeEffect", "UpdateStateFlyShoeEffect", "QuitStateFlyShoeEffect", true);
		this.SetShadowVisible(false)
	}

	public InitRoleVo(vo?) {

		super.InitRoleVo(vo)
		this.next_send_dist = 0
		this.id = this.vo.role_id
		this.compress_id = Scene.GetInstance().CompressObjId(local_SceneBaseType.MainRole, this.id)
		//主角不可拣选
		this.SetPickInfo(false)
		this.last_fire_pos = new local_Vector2(0, 0)
	}

	public LoadInfoFromVo() {
		super.LoadInfoFromVo()
		//this:RoleClothChange()
	}

	public BindVoEvents() {
		if (this.main_role_has_bind_event) return
		super.BindVoEvents()
		this.main_role_has_bind_event = true
	}

	public Update(now_time?, elapse_time?) {
		if (this.disabled) { return }
		super.Update(now_time, elapse_time)

		if (this.horse_up_action_start_time && this.horse_up_action_last_time) {
			let past_time = now_time - this.horse_up_action_start_time
			if (local_Util.IsNull(this.horse_transform.owner)) {
				return
			}
			let bone = local_Util.FindBone(this.horse_transform.owner, AttachNode.Ride)
			if (bone == null || local_Util.IsNull(bone)) {
				return
			}
			if (past_time > this.horse_up_action_last_time) {
				this.SetAlphaFlag(Role.AlphaFlag.HorseUp, 1)
				if (!local_Util.IsNull(this.transform.owner)) {
					// this.transform.localPosition = new Laya.Vector3(0, 0, 0)
					local_Set3DLocalPosition(this.transform)
					// this.transform.localRotationEuler = new Laya.Vector3(0, 0, 0)
					local_Set3DLocalRotationEuler(this.transform)
					// this.transform.localScale = new Laya.Vector3(1, 1, 1)
					local_Set3DLocalScale(this.transform)
				}

				this.horse_up_action_last_time = false
				this.horse_up_action_start_time = false
				this.UpdateRideAction()
			} else {
				let pec = Math.min(1, past_time / this.horse_up_action_last_time)
				this.SetAlphaFlag(Role.AlphaFlag.HorseUp, pec)

				if (!local_Util.IsNull(this.transform.owner)) {
					let x = bone.transform.position.x - (bone.transform.position.x - this.transform.position.x) * (1 - pec)
					let y = bone.transform.position.y - (bone.transform.position.y - this.transform.position.y) * (1 - pec)
					let z = bone.transform.position.z - (bone.transform.position.z - this.transform.position.z) * (1 - pec)
					// this.transform.position = new Laya.Vector3(x, y, z)
					Set3DPosition(this.transform, -x, -y, z)
				}
			}
		} else if (this.horse_down_action_start_time && this.horse_down_action_last_time && this.horse_down_action_direction && !local_Util.IsNull(this.horse_gameObject) && !local_Util.IsNull(this.horse_transform.owner)) {
			let past_time = now_time - this.horse_down_action_start_time
			if (past_time >= this.horse_down_action_last_time) {
				this.SetAlphaFlag(Role.AlphaFlag.HorseDown, 1)
				local_Set3DLocalPosition(this.transform)

				this.horse_down_action_last_time = null
				this.horse_down_action_start_time = null
				this.horse_down_action_direction = null

				local_Set3DLocalPosition(this.horse_transform)
				local_Set3DLocalRotationEuler(this.horse_transform)
				local_Set3DLocalScale(this.horse_transform)
				this.horse_gameObject.active = false

				this.modelObj_transform.owner.addChild(this.horse_gameObject)

				this.horse_animator.speed = 1
			} else {
				let alpha = 1 - past_time / this.horse_down_action_last_time
				this.SetAlphaFlag(Role.AlphaFlag.HorseDown, alpha)
				let x, y, z

				x = this.transform.position.x + (this.modelObj_transform.position.x - this.transform.position.x) * past_time / this.horse_down_action_last_time
				y = this.transform.position.y + (this.modelObj_transform.position.y - this.transform.position.y) * past_time / this.horse_down_action_last_time
				z = this.transform.position.z + (this.modelObj_transform.position.z - this.transform.position.z) * past_time / this.horse_down_action_last_time
				Set3DPosition(this.transform, -x, -y, z)

				x = this.horse_transform.position.x + this.horse_down_action_direction.x * elapse_time * 10
				y = this.horse_transform.position.y + this.horse_down_action_direction.y * elapse_time * 10
				z = this.horse_transform.position.z + this.horse_down_action_direction.z * elapse_time * 10
				Set3DPosition(this.horse_transform, -x, -y, z)

			}
		}

		if (this.jump_area_mutil_jump_end_time && now_time - this.jump_area_mutil_jump_end_time >= 0) {
			this.jump_area_mutil_jump_end_time = null
			local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_JUMP_END, true)
		}

		if (this.vo.is_fighting_state && this.fighting_state_time && now_time - this.fighting_state_time > 0
			&& this.vo.god_id <= 0 && !this.IsDead() && !this.buff_manager.hasSpeedBuff()) {
			this.fighting_state_time = false
			local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, false)
		}
		if (this.vo.is_start_to_fight && now_time - this.start_to_fight_time > 5) {
			this.vo.is_start_to_fight = false
		}
	}

	public EnterFightingState(time?) {
		this.fighting_state_time = local_Status.NowTime + time
		if (!this.vo.is_fighting_state) {
			local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, true)
		}
	}

	// 状态复写
	public DoDead() {

		if (this.IsInState(local_PoseState.FLY_SHOE_EFFECT)) {
			this.need_dead_after_fly_shoe = true
			return
		}
		super.DoDead()
	}


	// 状态复写
	public EnterStateDead(state_name?) {

		if (this.IsOnHorse()) {
			local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, true)
		}
		if (AutoFightManager.GetInstance().GetAutoFindWayState()) {
			local_GlobalEventSystem.Fire(local_EventName.FINDWAY_ENDED)
		}

		AutoFightManager.GetInstance().CacheGoToPos()
		Scene.Instance.CancelClickTarget()
		super.EnterStateDead(state_name)
		OperateManager.Instance.ClearSrcOper()
		Scene.GetInstance().clearGoToData()
		// //GlobalEventSystem:Fire(local_EventName.SHOWRELIVEWINDOW,0)//0打开复活界面 1关闭复活界面
		local_GlobalEventSystem.Fire(local_EventName.STOPAUTOFIGHT, false, true)
		local_GlobalEventSystem.Fire(local_EventName.CANCEL_TO_COLLECT)
	}

	public WaitForNextMove() {

		if (!this.CanMove()) {
			return
		}
		if (this.IsInState(local_PoseState.COLLECT)) {
			return
		}
		this.ChangeState(local_PoseState.WAITSTAND)
	}

	public SetBodyXY(x?, y?, change_camera_size?) {

		if (change_camera_size) {
			this.jump_height = y
		}
		CameraManager.GetInstance().SetBaseScaleByHeight(this.jump_height)
		super.SetBodyXY(x, y)
	}

	// ignore_floor  忽略物体本身的高度，也就是本次高度不更新
	// ignore_camera 相机不跟随移动
	public SetRealPos(posx?, posy?, is_born?, ignore_floor?, ignore_camera?) {
		if (!this.scene.IsSceneLoaded()) { return }
		super.SetRealPos(posx, posy, is_born, ignore_floor)

		this.main_camera.SetCameraPos(posx, posy, is_born);
		if (!ignore_camera) {
			//	 MainCamera.Instance.ChangePosFllowMainrole(this.real_pos.x,this.real_pos.y,this.jump_height, is_born)
			local_GlobalEventSystem.Fire(ObjectEventType.MAINROLE_MOVE_EVENT_IMME, posx, posy)  //慎用 对即时性要求比较高的时候监听  一般监听下面的事件就好了
			let length = GameMath.GetDistance(this.last_fire_pos.x, this.last_fire_pos.y, this.real_pos.x, this.real_pos.y)
			if (length > 3600) {
				local_GlobalEventSystem.DelayFire(ObjectEventType.MAINROLE_MOVE_EVENT, posx, posy)
				if (!is_born || this.scene.IsSceneLoaded()) {
					this.last_fire_pos.x = posx
					this.last_fire_pos.y = posy
					// this.CheckWaterArea(posx, posy)
					this.CheckIsCrossSafeArea()
				} else {
					this.last_fire_pos.x = 0
					this.last_fire_pos.y = 0
				}
			}
		}
	}


	//检测主角是否从非安全区域进入安全区域 或者从安全区域进入非安全区域
	public CheckIsCrossSafeArea() {

		if (!this.scene.IsSceneLoaded()) {// || ! this.scene_mgr.IsSceneStart() ) {
			return
		}
		if (!this.scene_mgr.IsSafeScene()) {
			if (this.scene_mgr.IsSafePos(this.real_pos.x, this.real_pos.y)) {
				if (this.vo.safe_area_state != 1) {
					this.vo.safe_area_state = 1
					local_GlobalEventSystem.Fire(local_SceneEventType.SAFE_AREA_CHANGE, this.vo.safe_area_state)
					local_GlobalEventSystem.Fire(ObjectEventType.MAIN_ROLE_ENTER_SAFE_AREA)
					Scene.Instance.update_role_name = true
					Scene.Instance.update_monster_name = true
					Scene.Instance.update_partner_name = true
					Message.show("进入安全区")
				}
			} else {
				if (this.vo.safe_area_state != 2) {
					this.vo.safe_area_state = 2
					local_GlobalEventSystem.Fire(local_SceneEventType.SAFE_AREA_CHANGE, this.vo.safe_area_state)
					local_GlobalEventSystem.Fire(ObjectEventType.MAIN_ROLE_ENTER_NOTSAFE_AREA)
					Scene.Instance.update_role_name = true
					Scene.Instance.update_monster_name = true
					Scene.Instance.update_partner_name = true
					Message.show("走出安全区")
				}
			}
		} else {
			if (this.vo.safe_area_state != 3) {
				this.vo.safe_area_state = 3
				local_GlobalEventSystem.Fire(local_SceneEventType.SAFE_AREA_CHANGE, this.vo.safe_area_state)
				local_GlobalEventSystem.Fire(ObjectEventType.MAIN_ROLE_ENTER_SAFE_AREA)
				Scene.Instance.update_role_name = true
				Scene.Instance.update_monster_name = true
				Scene.Instance.update_partner_name = true
			}
		}
	}


	public DoBeAttacked(dir?, pos?, force_hited?, movie_cfg?, attacker?, skill_id?) {

		if (super.DoBeAttacked(dir, pos, force_hited, movie_cfg, attacker, skill_id) && attacker && attacker.GetType() != local_SceneBaseType.Monster) {
			this.EnterFightingState(6)
			return true
		}
	}

	public DoAttack(dir_vec?, movie_cfg?, rush_cfg?, attack_skill_id?, is_mainRole_defender?, defender_list?) {

		if (this.IsInState(local_PoseState.FLY_SHOE_EFFECT)) {
			return
		}
		if (this.IsDead()) {
			return
		}
		OperateManager.Instance.ClearSrcOper()
		Scene.GetInstance().clearGoToData()
		if (AutoFightManager.GetInstance().GetAutoFindWayState()) {
			local_GlobalEventSystem.Fire(local_EventName.FINDWAY_ENDED)
		}

		if (super.DoAttack(dir_vec, movie_cfg, rush_cfg, attack_skill_id)) {
			if (this.sprite) {
				this.sprite.MainRoleAttack(defender_list)
			}
			return true
		}
		return false
	}


	//是否在战斗状态
	public IsFighting() {

		return this.vo.is_fighting_state
	}


	public CanJump(is_scene_trigger?, is_shoe_jump?, is_task_jump?) {

		if (this.is_shoe_jump && !is_shoe_jump) {
			return false
		}

		if (this.is_fight_jump) {
			return false
		}
		if (is_shoe_jump) {

			return true
		}
		if (this.is_scene_trigger && !is_scene_trigger) {
			return false
		}
		if (is_scene_trigger) {
			return true
		}


		if (this.is_task_jump && !is_task_jump) {
			return false
		}

		if (is_task_jump) {

			return true
		}


		let can_jump = true
		if (this.buff_manager.hasDingshenBuff()) {
			can_jump = false
		} else {
			can_jump = !this.IsInState(local_PoseState.DIZZY)
				&& !this.IsInState(local_PoseState.DEAD)
			//and ! SkillManager.Instance.IsInRigidity() //战斗的后摇没结束的时候之前是不让起跳的，现在注释，可以在这里添加闪避
		}
		if (can_jump && (!this.last_jump_time || local_Status.NowTime - this.last_jump_time > 0.3)) {
			return true
		}
	}

	public DoJump(end_pos?, is_scene_trigger?, start_pos?, move_hspeed?, move_vspeed?, jump_type?, is_shoe_jump?, call_back?, show_effect?, init_end_pos?, is_fight_jump?, next_jump_ratio?, attack_delay_jump?, is_jupm_point?, is_last?) {

		if (attack_delay_jump && this.IsInState(local_PoseState.ATTACK)) {

			if (attack_delay_jump == 1) {
				Message.show("释放技能结束后传送")
			} else if (attack_delay_jump == 2) {
				//Message.show("释放技能结束后跳跃")
			}
			return false
		}

		super.DoJump(end_pos, is_scene_trigger, start_pos, move_hspeed, move_vspeed, jump_type, is_shoe_jump, call_back, show_effect, init_end_pos, is_fight_jump, next_jump_ratio, attack_delay_jump, is_jupm_point, is_last)
	}

	public CanMove(ignore_buff?, ignore_attack?) {

		let can_move = true
		if (! super.CanMove()) {
			can_move = false
		} else if (!ignore_buff && this.buff_manager.hasDingshenBuff()) {
			can_move = false
		} else {
			can_move = (ignore_attack || !this.IsInState(local_PoseState.ATTACK) )
				&& !this.IsInState(local_PoseState.HITED)
				&& !this.IsInState(local_PoseState.RUSH)
				&& !this.IsInState(local_PoseState.DIZZY)
				&& !this.IsInState(local_PoseState.JUMP)
				&& !this.IsInState(local_PoseState.TASK_JUMP)
				&& !this.IsInState(local_PoseState.FLY_SHOE_EFFECT)
		}
		return can_move
	}

	public CanOperateHorse() {

		let can_move = !this.IsDead()
			&& !this.IsInState(local_PoseState.ATTACK)
			// && ! this.IsInState(local_PoseState.RANDMOVE)
			&& !this.IsInState(local_PoseState.HITED)
			&& !this.IsInState(local_PoseState.DIZZY)
			&& !this.IsInState(local_PoseState.JUMP)
			&& !this.IsInState(local_PoseState.TASK_JUMP)
			&& !this.IsInState(local_PoseState.DEAD)
		// && ! SceneManager.GetInstance().IsOnButterflyScene()
		return can_move
	}

	public DoMove(pos?) {

		if (!this.CanMove()) {
			return
		}
		if (! super.DoMove(pos)) {
			local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_MOVE_END, this.move_tip_count)
			return
		}
		//开始移动时就要发送预测坐标给服务器，所以把发送计时重置
		this.next_send_dist = 0
		this.state_move_pass_distance = 0
		this.TrySendPos()
		return true
	}

	public ReleaseObj() {
		this.main_role_has_bind_event = false
		super.ReleaseObj()
	}

	public ChangeGodId(oldVar1?, value?, old_value?) {
		if (this.delay_change_god_id) {
			GlobalTimerQuest.CancelQuest(this.delay_change_god_id)
			this.delay_change_god_id = false
		}

		SkillManager.Instance.ResetThreeAttackIndex(true)
		if (SkillManager.GetInstance().IsInRigidity()) {
			let left_time = SkillManager.GetInstance().GetRigidityLeftTime()
			var onDelay = () => {
				super.ChangeGodId(oldVar1, value, old_value)
				SkillManager.Instance.Fire(SkillManager.UPDATE_SKILL_LIST)
				if (this.delay_change_god_id) {
					GlobalTimerQuest.CancelQuest(this.delay_change_god_id)
					this.delay_change_god_id = false
				}
				if (this.vo.god_id <= 0) {
					CameraManager.GetInstance().SetBaseScale(1)
				}else
				{
					CameraManager.GetInstance().SetBaseScale(CameraManager.HORSE_OR_GOD_SCALE)
				}
			}
			this.delay_change_god_id = GlobalTimerQuest.AddDelayQuest(onDelay, left_time - 0.1)
			return
		}
		super.ChangeGodId(oldVar1, value, old_value)
		SkillManager.Instance.Fire(SkillManager.UPDATE_SKILL_LIST)
		if (this.vo.god_id <= 0) {
			CameraManager.GetInstance().SetBaseScale(1)
		}else
		{
			CameraManager.GetInstance().SetBaseScale(CameraManager.HORSE_OR_GOD_SCALE)
		}
	}

	public TrySendPos() {
		
		//没达到发送条件，就返回
		if(this.role_mgr.GetMainRoleDepositState()) return true
		
		if (this.next_send_dist != 0 && this.state_move_pass_distance < this.next_send_dist) {
			return
		}
		let max_dist = 120
		if (!this.dir_move_param && this.state_move_total_distance && this.state_move_pass_distance) {
			let left_dist = this.state_move_total_distance - this.state_move_pass_distance
			let move_dist = (left_dist >= max_dist) && max_dist || left_dist
			let delta = this.state_move_dir
			let sx = this.real_pos.x
			let sy = this.real_pos.y

			if (move_dist > 0) {
				sx = sx + delta.x * move_dist
				sy = sy + delta.y * move_dist

				this.next_send_dist = this.next_send_dist + move_dist
				if (this.move_flag == local_MOVE_TYPE.ACCELERATE) {
					local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, sx, sy, local_MOVE_TYPE.ACCELERATE)
				} else {
					//console.log("广播服务器 ",sx,sy,sx / local_SceneObj.GetLogicRealRatio().x,sy/ local_SceneObj.GetLogicRealRatio().y)
					local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, sx, sy, local_MOVE_TYPE.NORMOL_MOVE)
				}
			}
		} else if (this.dir_move_param) {
			let delta_time = 0.5
			if (this.last_send_pos_time && local_Status.NowTime - this.last_send_pos_time < delta_time) {
				return
			}

			this.last_send_pos_time = local_Status.NowTime
			let logic_ratio_x = local_SceneObj.GetLogicRealRatio().x
			let logic_ratio_y = local_SceneObj.GetLogicRealRatio().y

			let sx = this.real_pos.x
			let sy = this.real_pos.y
			let move_dist = 0

			let r = this.scene.DetectLastUnblockPoint(new local_Vector2(this.logic_pos.x, this.logic_pos.y), new local_Vector2(this.dir_move_param.direction.x, this.dir_move_param.direction.y), max_dist / 60, true)
			if (r) {
				if (r.z == 1) {
					let gv2 = r
					let newx = gv2.x * logic_ratio_x
					let newy = gv2.y * logic_ratio_y
					move_dist = GameMath.GetDistance(sx, sy, newx, newy, true)
					sx = newx
					sy = newy
				}

				let cur_is_block = this.scene_mgr.IsBlockXY(this.logic_pos.x, this.logic_pos.y)
				if (cur_is_block) {
					if (r.x && r.y) {
						let end_is_block = this.scene_mgr.IsBlockXY(r.x, r.y)
						if (end_is_block) {
							let unblock_pos = SourceOperateMove.FindNoBlockPos(this.logic_pos)
							if (unblock_pos) {
								sx = unblock_pos.x * logic_ratio_x
								sy = unblock_pos.y * logic_ratio_y
								this.SetRealPos(sx, sy)
							}
						}
					}
				}
			}

			//如果有移动距离，就在移动到目标点后发包，否则就在一小段距离后发包（因为贴墙时会慢慢滑动，也是要同步的）
			if (move_dist > 0) {
				this.next_send_dist = this.next_send_dist + move_dist
			} else {
				this.next_send_dist = this.next_send_dist + 30
			}
			if (this.move_flag == local_MOVE_TYPE.ACCELERATE) {
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, sx, sy, local_MOVE_TYPE.ACCELERATE)
			} else {
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, sx, sy, local_MOVE_TYPE.NORMOL_MOVE)
			}
		}
	}

	//技能移动结束
	public DoSkillMoveEnd(dir?, elapse_time?) {

		this.dir_move_param = null
	}

	//进行方向型的移动
	public DoDirectionMove(dir, ignore_buff?, ignore_attack?) {
		// 如果在经验副本不能拖动
		if (SceneManager.GetInstance().IsExpScene()) {
			return Message.show('副本正在进行中，无法移动')
		}

		// console.log("DoDirectionMove1")
		if (this.IsDead() || !dir) {
			return
		}
		// console.log("DoDirectionMove12")
		if (!this.CanMove(ignore_buff, ignore_attack)) {
			return
		}

		// console.log("DoDirectionMove13")
		if (!Scene.GetInstance().drag_to_move_start_time && SceneManager && SceneManager.GetInstance().curr_joystick_dir) {
			Scene.GetInstance().drag_to_move_start_time = local_Status.NowTime
		}

		// OperateManager.GetInstance().StopMove()

		dir.normalise()
		this.dir_move_param = this.dir_move_param || {}
		this.dir_move_param.direction = dir

		this.SetDirection(dir)

		//开始移动时就要发送预测坐标给服务器，所以把发送计时重置
		this.next_send_dist = 0
		this.state_move_pass_distance = 0

		//由于使用摇杆时DoDirectionMove几乎每帧都会触发，所以要限制发包频率
		let now_time = local_Status.NowTime
		let delta_time = 0.5
		if (this.last_send_pos_time && now_time - this.last_send_pos_time <= delta_time) {
			if (!this.next_send_time) {
				this.next_send_time = now_time + delta_time
			}
		} else {
			this.TrySendPos()
		}

		//如果当前不在移动状态则切换至移动状态
		// console.log("DoDirectionMove1344")
		if (!this.IsInState(local_PoseState.MOVE)) {
			OperateManager.GetInstance().StopMove()
			// console.log("DoDirectionMove135")
			this.ChangeState(local_PoseState.MOVE)
		}
		this.state_move_pass_distance = 0
	}

	public EnterStateMove(state_name?) {

		// MainCamera.Instance.ChangeSmoothState(MainCamera.SmoothState.Normal)
		this.main_camera.StartMove();
		if (this.is_ios)
			Laya.stage.frameRate = Laya.Stage.FRAME_FAST
		super.EnterStateMove(state_name)
	}



	public QuitStateMove(state_name?) {
		this.main_camera.StopMove();
		if (this.GetCurState() != local_PoseState.JUMP && this.GetCurState() != local_PoseState.TASK_JUMP) {
			local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_MOVE_END, true)
		}

		this.next_send_time = null
		this.dir_move_param = false
		if (!this.IsInState(local_PoseState.HITED) && !this.IsInState(local_PoseState.ATTACK)) {
			if (this.move_flag == local_MOVE_TYPE.ACCELERATE) {
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.real_pos.x, this.real_pos.y, local_MOVE_TYPE.ACCELERATE)
			} else {
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.real_pos.x, this.real_pos.y, local_MOVE_TYPE.NORMOL_MOVE)
			}
		}

		super.QuitStateMove(state_name)
		if (this.is_ios)
			Laya.stage.frameRate = Laya.Stage.FRAME_SLOW
	}

	public DoRush(rush_end_pos?, rush_add_speed?) {
		let skill_id = SkillManager.GetInstance().getCurrentSkillId()
		if (skill_id && typeof (skill_id) == "number" && SkillManager.GetInstance().CanAttack(skill_id) && rush_end_pos) {
			super.DoRush(rush_end_pos, rush_add_speed)
			//开始移动时就要发送预测坐标给服务器，所以把发送计时重置
			this.next_send_dist = 0
			this.state_move_pass_distance = 0
			this.TrySendPos()
		}
	}

	public EnterStateRush(state_name?) {
		if (this.is_ios)
			Laya.stage.frameRate = local_Laya.Stage.FRAME_FAST
		let horse_id = this.GetHorseId()
		if (horse_id != 0 && this.IsOnHorse()) {
			this.show_horse_after_jump = horse_id
			local_GlobalEventSystem.Fire(local_EventName.CHANGE_FIGHTING_STATE, true)
			this.DownHorse()
		}
		super.EnterStateRush(state_name)
	}


	public UpdateStateRush(state_name?, elapse_time?) {

		if (this.state_move_total_distance) {
			this.rush_speed = this.rush_speed + this.rush_add_speed * elapse_time
			this.rush_speed = Math.min(this.rush_speed, 1500)
			this.state_move_pass_distance = this.state_move_pass_distance + this.GetMoveSpeed(this.state_move_dir, this.rush_speed) * elapse_time
			if (this.state_move_pass_distance >= this.state_move_total_distance) {
				this.state_move_total_distance = false
				this.SetRealPos(this.state_move_end_pos.x, this.state_move_end_pos.y)
				this.TrySendPos()
				this.DoStand()

				local_GlobalEventSystem.Fire(ObjectEventType.MAINROLE_RUSH_END)
			} else {
				let x = this.state_move_start_pos.x + this.state_move_dir.x * this.state_move_pass_distance
				let y = this.state_move_start_pos.y + this.state_move_dir.y * this.state_move_pass_distance
				this.SetRealPos(x, y)
				this.TrySendPos()
			}
		}
	}

	public QuitStateRush(state_name?) {
		if (this.is_ios)
			local_Laya.stage.frameRate = local_Laya.Stage.FRAME_SLOW
	}

	public UpdateStateMove(state_name?, elapse_time?) {
		// //普通移动方式刷新
		//let max_value = Runner.GetInstance().mainrole_update_elapse_time
		if (elapse_time > 0.04 && local_ViewManager.OPENBIGVIEWFRAME != 4) {
			elapse_time = 0.04;
		}
		this.move_update_elipse_time = elapse_time
		let move_dist = this.GetMoveSpeed() * elapse_time
		if (!this.dir_move_param) {
			//移动状态更新
			this.state_move_pass_distance = this.state_move_pass_distance + move_dist

			let state_move_pass_distance = this.state_move_pass_distance
			if (!this.state_move_total_distance) {
				this.state_move_total_distance = 0
			}
			if (state_move_pass_distance >= this.state_move_total_distance) {
				this.state_move_pass_distance = this.state_move_total_distance

				this.SetRealPos(this.state_move_end_pos.x, this.state_move_end_pos.y)
				this.ChangeState(local_PoseState.WAITSTAND)
			} else {
				let new_x = this.state_move_start_pos.x + this.state_move_dir.x * state_move_pass_distance
				let new_y = this.state_move_start_pos.y + this.state_move_dir.y * state_move_pass_distance
				//异常情况下如果将要从非障碍区走进障碍区，就停止移动
				// if (! this.IsFlying() && ! this.ignore_block ) {
				// 	let lx = new_x / local_SceneObj.GetLogicRealRatio().x
				// 	let ly = new_y / local_SceneObj.GetLogicRealRatio().y
				// 	if (! SceneManager.GetInstance().IsBlockXY(this.logic_pos.x, this.logic_pos.y) && SceneManager.GetInstance().IsBlockXY(lx, ly) ) {
				// 		console.log("//-障碍区//-", this.logic_pos.x, this.logic_pos.y, lx, ly)
				// 		OperateManager.Instance.StopMove()
				// 		local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_MOVE_TO_BLOCK)
				// 		return
				// 	}
				// }
				//////////////////////////////////////////////-
				this.SetRealPos(new_x, new_y)
			}

			//方向型移动方式刷新
		} else {
			// move_dist = this.GetMoveSpeed(this.dir_move_param.direction) * elapse_time
			let direction = this.dir_move_param.direction
			let mx = direction.x * move_dist
			let my = direction.y * move_dist
			let rx = this.real_pos.x + mx
			let ry = this.real_pos.y + my
			let lx = rx / local_SceneObj.GetLogicRealRatio().x
			let ly = ry / local_SceneObj.GetLogicRealRatio().y

			//新坐标不是障碍，直接走过去
			if (!SceneManager.GetInstance().IsBlockXY(lx, ly)) {
				this.SetRealPos(rx, ry)
				this.state_move_pass_distance = this.state_move_pass_distance + move_dist

				//如果是障碍，就尝试沿一个方向进行平移
			} else {
				local_GlobalEventSystem.Fire(local_SceneEventType.MAIN_ROLE_MOVE_TO_BLOCK, lx, ly, true)
				rx = this.real_pos.x + mx
				ry = this.real_pos.y
				lx = rx / local_SceneObj.GetLogicRealRatio().x,
					ly = ry / local_SceneObj.GetLogicRealRatio().y
				if (!SceneManager.GetInstance().IsBlockXY(lx, ly)) {
					this.SetRealPos(rx, ry)
					this.state_move_pass_distance = this.state_move_pass_distance + Math.abs(mx)
				} else {
					rx = this.real_pos.x
					ry = this.real_pos.y + my
					lx = rx / local_SceneObj.GetLogicRealRatio().x
					ly = ry / local_SceneObj.GetLogicRealRatio().y
					if (!SceneManager.GetInstance().IsBlockXY(lx, ly)) {
						this.SetRealPos(rx, ry)
						this.state_move_pass_distance = this.state_move_pass_distance + Math.abs(my)
					}
				}
			}
		}

		this.TrySendPos()
	}

	public ForceSendPos() {

		local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.real_pos.x, this.real_pos.y, local_MOVE_TYPE.NORMOL_MOVE)
	}


	public DeleteMe() {
		if (this.delay_auto_fight_id) {
			clearTimeout(this.delay_auto_fight_id)
			this.delay_auto_fight_id = null
		}
		super.DeleteMe()
	}

	public Revived() {
		let delay_time = 0
		if (this.scene_mgr.CanAutoFightScene()) {
			delay_time = 0.1
		}

		if (this.delay_auto_fight_id) {
			clearTimeout(this.delay_auto_fight_id)
			this.delay_auto_fight_id = null
		}
		if (delay_time > 0) {
			let onTimer = () => {
				this.delay_auto_fight_id = null
				local_GlobalEventSystem.Fire(local_EventName.STARTAUTOFIGHT)
			}
			this.delay_auto_fight_id = setTimeout(onTimer, delay_time * 1000);
		}
		//this:CreateFlower()
		super.Revived()
	}

	public EnterStateAttack(state_name?) {

		super.EnterStateAttack(state_name)
		this.start_to_fight_time = local_Status.NowTime
		if (!this.vo.is_start_to_fight) {
			this.vo.is_start_to_fight = true
			local_GlobalEventSystem.Fire(local_EventName.START_TO_FIGHT)
		}
		GlobalEventSystem.Fire(local_EventName.MAIN_ROLE_FIGHT)
	}
	
	public DoFlyShoeEffect(end_pos?, type?, callback?) {

		if (this.IsInState(local_PoseState.ATTACK) ) {
			 this.delay_fly_shoe_effect =
			 {
				 ps : end_pos,
				 tp : type,
				 cb : callback,
			 }
			 //Message.show("施放技能结束后传送")
			 return
		}
		if (this.GetCurState() == local_PoseState.ATTACK ) {
			 if (type != 1  ) {
				 this.delay_fly_shoe_effect =
				 {
					 ps : end_pos,
					 tp : type,
					 cb : callback,
				 }
				 //Message.show("施放技能结束后传送")
			 }
			 return
		}

		OperateManager.Instance.ClearSrcOper()
		Scene.GetInstance().clearGoToData()
		local_GlobalEventSystem.Fire(local_EventName.FINDWAY_ENDED)
		this.ChangeState(local_PoseState.STAND)
		this.is_shoe_flying = true
		let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.FlyShoeEffect

		this.fly = []
		this.fly.callback = callback
		this.fly.total_time = type == 1 && cfg.down_fly_time || cfg.up_fly_time
		this.fly.end_pos = end_pos
		this.fly.pass_time = 0
		this.fly.type = type
		this.fly.down_height = 0
		this.ChangeState(local_PoseState.FLY_SHOE_EFFECT)

		return true
	}

	public EnterStateFlyShoeEffect(state_name?) {

		let effect_name, effect_res_type
		if (this.fly.type == 1 ) {  //向下
			effect_name = "function_partneroutof"
			effect_res_type = EffectResType.Other
		} else if (this.fly.type == 2 ) {  //向上
			effect_name = "function_partneroutof"
			effect_res_type = EffectResType.Other
		}

		var load_call_back = (obj:Laya.Sprite3D) => {
			if (obj && !local_Util.IsNull(this.modelObj_transform.owner) && this.start_show_fly_effect ) {
				this.fly_shoe_effect = obj
				if (this.fly.type == 1 ) {
					this.modelObj_transform.owner.addChild(obj)
					Set3DLocalRotation(obj.transform, 0, 0, 180)
					local_Set3DLocalPosition(obj.transform, 0, -6, 0)
				}else{
					this.modelObj_transform.owner.addChild(obj)
					Set3DLocalRotation(obj.transform, 0, 0, 0)
					local_Set3DLocalPosition(obj.transform, 0, 0, 0)
				}
				this.fly_shoe_effect.active = true 
			}
		}
		//处理特效加载完之前 就退出了状态
		this.start_show_fly_effect = true
		//暂时屏蔽飞鞋特效显示
		if (effect_name&&0) {
			 //如果有隐藏标志就不显示
			 if (!this.HasModelHideFlag() ) {
				let full_url = GameResPath.GetEffectPath(effect_res_type, effect_name)
				ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back)
			 }
		}
		this.SetHideNameBord(true)
		if (this.fly.type == 2 ) {

		}else{
			this.SetAlphaFlag(Role.AlphaFlag.ModelHide, 0)
		}
	}

	public UpdateStateFlyShoeEffect(state_name?, elapse_time?) {

		this.fly.pass_time = this.fly.pass_time + elapse_time

		this.is_shoe_flying = false
		this.ChangeState(local_PoseState.STAND)
	}

	public QuitStateFlyShoeEffect(state_name?) {

		if (this.fly.end_pos) {
			this.SetRealPos(this.fly.end_pos.x, this.fly.end_pos.y, true)
			if (this.vo.role_id == this.role_mgr.GetMainRoleId() ) {
				if (this.scene.IsSceneLoaded()) {
					SapManager.GetInstance().Update(this.fly.end_pos.x, this.fly.end_pos.y, true)
				}
				local_GlobalEventSystem.Fire(local_SceneEventType.MOVEREQUEST, this.fly.end_pos.x, this.fly.end_pos.y, local_MOVE_TYPE.BLINK)
			}
		}

		if (this.fly.type == 2 ) {
			 this.SetAlphaFlag(Role.AlphaFlag.ModelHide, 0)
		}else{
			 this.SetAlphaFlag(Role.AlphaFlag.ModelHide, 1)
		}
		this.SetHideNameBord(false)

		if (this.fly_shoe_effect ) {
			this.fly_shoe_effect.destroy()
			this.fly_shoe_effect = null
		}
		this.start_show_fly_effect = false
		this.is_shoe_flying = false
		if (this.fly.callback ) {
			this.fly.callback()
		}
	}

	public QuitStateAttack(state_name?) {


		if (this.delay_fly_shoe_effect) {
			this.DoFlyShoeEffect(this.delay_fly_shoe_effect.ps,this.delay_fly_shoe_effect.tp,this.delay_fly_shoe_effect.cb)
			this.delay_fly_shoe_effect = null
		}

		if (this.rush_info) {
			this.rush_info.rush_pos = null
		}

		super.QuitStateAttack()
		// local_GlobalEventSystem.Fire(ObjectEventType.MAIN_ROLE_QUIT_ATTACK)
	}


	public LoadClotheResComplete() {

		super.LoadClotheResComplete()

		// let playerLv = RoleManager.GetInstance().GetMainRoleVo().level

		// if (! MainCamera.Instance.init_camera_around ) {
		//	 MainCamera.Instance.init_camera_around = true
		//	 MainCamera.Instance.RotateAround(this.transform.position,Vector3.up,SceneXZRotate)
		// }
		local_GlobalEventSystem.Fire(ObjectEventType.MAINROLE_MOVE_RES_LOAD_COMPLETE)

	}

	//至尊VIP免伤BUFF生效中
	public InImmuneBuff() {

		let bool = false
		if (SceneManager.GetInstance().IsBossScene()) {
			//bool = bool || BestVipGuideManager.GetInstance().CheckInVipSkill()
		}
		return bool
	}

	//采集进入战斗状态
	public EnterStateCollect() {
		super.EnterStateCollect()
		this.EnterFightingState(60)
	}

	public QuitStateCollect() {
		super.QuitStateCollect()
		this.EnterFightingState(6)
	}

	public ChangeCollectState() {

	}

	//是否有设置制定的屏蔽设置
	public HasBlockSetting(key?) {
		return false
	}

	
	public ChangeState(value?) {

		if (this.change_state_flag) {
			this.delay_change_state_queue.push(value)
			return
		}
		if (value != local_PoseState.STAND && value != local_PoseState.WAITSTAND && value != local_PoseState.COLLECT) {
			local_GlobalEventSystem.Fire(local_EventName.CANCEL_TO_COLLECT, value)
		}
		if (this.main_role_move_start_time && value != local_PoseState.MOVE) {
			this.main_role_move_start_time = false
		}
		return super.ChangeState(value)
	}
}

window["MainRole"] = MainRole