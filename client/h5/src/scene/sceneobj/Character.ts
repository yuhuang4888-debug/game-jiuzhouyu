import { SceneObj } from "./SceneObj";
import { MOVE_TYPE, SceneBaseType, SceneModelScale, AttachNode, NoMainroleWingRemoveParticle, EffectResType, PrintParticleInfo, NoMainroleRemoveWeaponParticle, ModelPartName, NoMainroleRemoveParticle, FashionPartPos } from "../SceneConfig";
import { Scene } from "../Scene";
import { Status } from "../../util/Status";
import { FRAME_TYPE, GlobalEventSystem } from "../../util/DeclareGlobalVar";
import { PoseState, StateMachineManager } from "../../util/StateMachineManager";
import { Vector2 } from "../../util/Vector2";
import { CommonCrossFadeAnim, Util, GetMaterialTexture, GlobalTimerQuest, Split, ResetTransform, GetSkinnedMeshSprite3D, CommonPlayAnim, Set3DLocalRotationEuler, Set3DLocalPosition, Set3DLocalScale, GetParams } from "../../util/Util";
import { Vector3 } from "../../util/Vector3";
import { BuffManager } from "../fight/BuffManager";
import { EventName, ObjectEventType, SceneEventType } from "../../common/EventName";
import { OperateManager, PathPoint } from "../../operation/OperateManager";
import { GameMath } from "../../util/GameMath";
import { SourceOperateMove } from "../../operation/SourceOperateMove";
import { Config } from "../../common/Config";
// TypeScript file
let local_PoseState = PoseState
let local_SceneBaseType = SceneBaseType
let local_Status = Status
let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Vector2 = Vector2
export class Character extends SceneObj {
	move_speed
	attack_start_time
	is_to_dead
	state_move_dir
	last_state
	movie_cfg
	
	state_move_total_distance
	state_move_pass_distance
	s_attack_state
	state_move_start_time
	state_move_start_pos
	state_move_end_dir
	last_action_name
	curr_body_action_name
	delay_change_state_queue: Array<any>
	rush_info
	hited_cfg

	ignore_update_index
	state_signals
	move_flag
	rigidity_time
	custom_path
	change_state_flag
	buff_manager: BuffManager
	state_move_end_pos
	custom_path_seg
	is_dead
	s_hited_info
	normal_hited_totalTime



	public static ColliderCenter = new Vector3(0, 1, 0)
	is_push_to_cache: boolean | Boolean;

	public constructor() {
		super()

		this.move_speed = 250
		this.move_flag = MOVE_TYPE.NORMOL_MOVE  		//走路类型
		this.normal_hited_totalTime = 0.2
		this.is_dead = false
		this.is_to_dead = false //本次受击完成才执行死亡

		this.buff_manager = new BuffManager(this)

		//Move状态相关变量
		this.state_move_start_pos = new local_Vector2(0, 0)
		this.state_move_end_pos = new local_Vector2(0, 0)
		this.state_move_dir = new local_Vector2(1, 1)
		this.state_move_total_distance = 0.0
		this.state_move_pass_distance = 0.0
		this.state_move_end_dir = 2


		this.ignore_update_index = 1

		this.state_signals = {}
		this.delay_change_state_queue = []

		let state_machine_manager: StateMachineManager = this._state_machine_manager
		state_machine_manager.RegisterState(local_PoseState.STAND, "EnterStateStand", "UpdateStateStand", "QuitStateStand", true)
		state_machine_manager.RegisterState(local_PoseState.MOVE, "EnterStateMove", "UpdateStateMove", "QuitStateMove", true)
		state_machine_manager.RegisterState(local_PoseState.ATTACK, "EnterStateAttack", "UpdateStateAttack", "QuitStateAttack", true)
		state_machine_manager.RegisterState(local_PoseState.DEAD, "EnterStateDead", "UpdateStateDead", "QuitStateDead", false)
		state_machine_manager.RegisterState(local_PoseState.HITED, "EnterStateHited", "UpdateStateHited", "QuitStateHited", true)
		state_machine_manager.RegisterState(local_PoseState.DIZZY, "EnterStateDizzy", "UpdateStateDizzy", "QuitStateDizzy", true)

		this.DoStand()
	}


	public BindVoEvents() {

	}


	public AddIgnoreUpdateIndex() {

		this.ignore_update_index = this.ignore_update_index + 1
	}


	//每种状态都设置自己的更新频率 还有更新条件
	public CanUpdate() {
		if(this.IsInState(local_PoseState.STAND))
		{
			if(!this.all_rotate_off && this.ignore_update_index < 45)
			{
				return false
			}
		}else if(this.IsInState(local_PoseState.ATTACK))
		{
			if(this.ignore_update_index < 3)
			{
				return false
			}
		}
		else if(this.IsInState(local_PoseState.HITED))
		{
			if(this.ignore_update_index < 4)
			{
				return false
			}
		}
		return true
	}

	public ChangeState(value?) {

		//为了防止状态切换嵌套。上一个状态没执行完，则缓存在队列中
		if (this.change_state_flag) {

			this.delay_change_state_queue.push(value)
			return
		}

		this.change_state_flag = true
		this.last_state = this.GetCurState()
		super.ChangeState(value)
		this.change_state_flag = false

		//上一状态切换完成。执行缓存的状态队列
		while (this.delay_change_state_queue.length > 0) {
			let temp_value = this.delay_change_state_queue.pop()
			this.ChangeState(temp_value)
		}
		return true
	}


	

	//眩晕
	public DoDizzy() {

		this.ChangeState(local_PoseState.DIZZY)
	}

	public EnterStateDizzy(state_name?, action_name?) {
		this.PlayAction(action_name || 'idle') //目前没有晕眩动作，暂时用idle
	}

	public UpdateStateDizzy(state_name?, elapse_time?) {

	}

	public QuitStateDizzy(state_name?) {

	}

	public EnterStateStand(state_name?, action_name?) {
		this.PlayAction(action_name || "idle")
	}

	public UpdateStateStand(state_name?, elapse_time?) {

	}

	public QuitStateStand(state_name?) {

	}

	public DoAttack(dir_vec?, movie_cfg?, rush_cfg?, attack_skill_id?) {

		if (this.IsDead()) {
			return false
		}
		this.attack_start_time = local_Status.NowTime
		this.rigidity_time = (movie_cfg.pre_swing || 0) + (movie_cfg.spell_time || 0) + (movie_cfg.back_swing || 0) //僵直时长
		this.movie_cfg = movie_cfg
		this.SetLandInfo()//处理强制使用技能的情况 比如悬空中强制释放技能
		if (this.IsDead()) {
			return false
		}
		if (this.rigidity_time == 0) {
			return false
		}
		if (this.IsInState(local_PoseState.DIZZY)) {
			return false
		}
		this.ChangeState(local_PoseState.ATTACK)
		return true
	}

	public EnterStateAttack(state_name?) {

		let now_time = local_Status.NowTime
		let t = { start_time: now_time, last_time: 0.8 }

		t.last_time = this.rigidity_time
		this.s_attack_state = t
	}


	public UpdateStateAttack(state_name?, elapse_time?) {

		if (this.s_attack_state.last_time == null) {
			this.DoStand()
			return
		}
		if (local_Status.NowTime - this.s_attack_state.start_time > this.s_attack_state.last_time) {
			this.DoStand()
		}
	}

	public QuitStateAttack(state_name?) {
		this.SetLandInfo()
	}

	public DoBeAttacked(dir?, pos?, force_hited?, movie_cfg?, attacker?, skill_id?) {

		if (this.IsDead() || this.vo == null) {
			return false
		}
		if (this.buff_manager.hasNoEffectBuff()) {
			return false
		}
		if (this.IsInState(local_PoseState.JUMP) || this.IsInState(local_PoseState.TASK_JUMP)) {
			return false
		}
		this.hited_cfg = movie_cfg
		return true
	}

	public EnterStateHited(state_name?) {

	}

	public UpdateStateHited(state_name?, elapse_time?) {

		let info = this.s_hited_info
		if (info) {
			let past_time = local_Status.NowTime - info.start_time
			let p = null
			let move_time = 0.1 //需要浮空的时候用浮空的总时间 或者就是默认的0.1
			if (past_time <= (move_time + elapse_time) && info.end_pos != null) {
				p = past_time / move_time
				p = p > 1 && 1 || p
			}

			if (p != null) {
				let x = info.start_pos.x * (1 - p) + info.end_pos.x * p
				let y = info.start_pos.y * (1 - p) + info.end_pos.y * p
				if (!this.scene_mgr.IsBlockXY(Math.floor(x / SceneObj.GetLogicRealRatio().x), Math.floor(y / SceneObj.GetLogicRealRatio().y))) {
					this.SetRealPos(x, y)
				}
			}

			//受击时间结束
			if (local_Status.NowTime >= info.stop_time) {
				if (info.end_pos) {
					let x = info.end_pos.x
					let y = info.end_pos.y
					if (!this.scene_mgr.IsBlockXY(Math.floor(x / SceneObj.GetLogicRealRatio().x), Math.floor(y / SceneObj.GetLogicRealRatio().y))) {
						this.SetRealPos(x, y)
					}
				}
				this.s_hited_info = null
			}
			if (this.s_hited_info && this.s_hited_info.hit_animation_time && past_time > this.s_hited_info.hit_animation_time) { //回复待机动作
				let action_name = "idle"
				this.PlayAction(action_name)
				this.s_hited_info.hit_animation_time = null
			}
		}

		if (this.s_hited_info == null) {
			this.SetLandInfo()
			//因为受击状态会和晕眩、睡眠、恐惧等特殊状态冲突，所以在受击结束后检查这些状态
			if (!this.buff_manager.CheckBuffControl(true)) {
				this.DoStand()
			}
		}

	}

	public QuitStateHited(state_name?) {

		this.s_hited_info = null
	}



	public Update(now_time?, elapse_time?) {
		super.Update(now_time, elapse_time)
		this.buff_manager.Update(now_time, elapse_time)
		this.ignore_update_index = 1
	}
	public UpdateStateMove(state_name?, elapse_time?) {

		//带路径的移动方式
		if (this.custom_path != null) {
			//处理当前段
			if (this.custom_path_seg < this.custom_path.length) {
				let seg = this.custom_path[this.custom_path_seg]
				let p1 = this.real_pos
				let p2 = seg.end_point

				//如果当前段已经走完，就跳下一段
				if (GameMath.GetDistance(p1.x, p1.y, p2.x, p2.y, false) <= 10) {
					this.custom_path_seg = this.custom_path_seg + 1
				} else {
					//第一次处理当前段的时候，要调整角色的方向
					if (!seg.entered) {
						this.SetDirection(seg.dir)

						if (this['IsMoveBrickState'] && this['IsMoveBrickState']()) {
							this.PlayAction("carry2")
						} else {
							this.PlayAction("run")
						}
						seg.entered = true
					}

					//向当前段的终点移动
					seg.moved = seg.moved + this.GetMoveSpeed(seg.dir) * elapse_time
					if (seg.moved >= seg.length) {
						seg.moved = seg.length
					}
					let x = seg.start_point.x + seg.dir.x * seg.moved
					let y = seg.start_point.y + seg.dir.y * seg.moved
					this.SetRealPos(x, y)
				}
				//如果路径都走完了就跳出移动状态
			} else {
				this.custom_path = null
				this.DoStand()
			}

			//普通移动方式
		} else {
			if (this.state_move_total_distance != null) {
				this.state_move_pass_distance = this.state_move_pass_distance + this.GetMoveSpeed() * elapse_time
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
	}

	public EnterStateMove(state_name?, action_name?) {
		this.PlayAction(action_name || "run")
	}

	public QuitStateMove(state_name?) {
		//GlobalEventSystem:Fire(ObjectEventType.OBJ_MOVE_END, this.GetType())
	}

	public DoStand(force_to_change?) {

		if (!force_to_change && this.IsDead()) {
			return
		}

		this.ChangeState(local_PoseState.STAND)
		if (force_to_change) {
			this._state_machine_manager.Update(local_Status.NowTime, 0.01)
		}
	}
	temp_path_list: Array<PathPoint> = []
	public FindPathAndMove(tar_pos?, range?) {

		range = range || 0
		let r1 = this.real_pos
		let r2 = tar_pos
		let l1 = this.logic_pos
		let l2 = new local_Vector2(Math.floor(tar_pos.x / SceneObj.GetLogicRealRatio().x), Math.floor(tar_pos.y / SceneObj.GetLogicRealRatio().y))

		let reverse_dir = new local_Vector2(r1.x - r2.x, r1.y - r2.y)
		let dist = reverse_dir.normalise()

		if (dist <= (range + 10)) {
			return
		}
		let is_straight_line
		let rlt = Scene.Instance.IsStraightLine(new local_Vector2(l1.x, l1.y), new local_Vector2(l2.x, l2.y))
		if (rlt) {
			is_straight_line = true
			r2.x = r2.x + reverse_dir.x * range
			r2.y = r2.y + reverse_dir.y * range //往回走range距离，就是新目标点
			this.DoMove(r2)
		} else {
			let info = SourceOperateMove.FindPathList(l1, l2, range / 60, this.temp_path_list, this._type == local_SceneBaseType.MainRole) //this._type,
			let is_path_valid = info.result, path_list = info.path_list
			if (is_path_valid) {
				//把逻辑坐标的路线段落转成像素坐标
				is_straight_line = false
				for (let _ in path_list) {
					let seg = path_list[_]
					seg.start_point = Vector2.MulXYTable(seg.start_point, SceneObj.GetLogicRealRatio())
					seg.end_point = Vector2.MulXYTable(seg.end_point, SceneObj.GetLogicRealRatio())

					let dir = new local_Vector2(seg.end_point.x - seg.start_point.x, seg.end_point.y - seg.start_point.y)
					seg.length = dir.normalise()
					seg.dir = new local_Vector2(dir.x, dir.y)
					seg.moved = 0
					seg.entered = false
				}
				this.DoPathMove(path_list)
			} else {
				is_straight_line = true
				r2.x = r2.x + reverse_dir.x * range
				r2.y = r2.y + reverse_dir.y * range //往回走range距离，就是新目标点
				this.DoMove(r2)
			}
		}

		return is_straight_line
	}

	public DoPathMove(path?) {

		if (this.IsDead()) {
			return
		}
		if (path == null || path.length == 0) {
			return
		}

		this.custom_path = path
		this.custom_path_seg = 0

		if (!this.IsInState(local_PoseState.MOVE)) {
			this.ChangeState(local_PoseState.MOVE)
		}

		return true
	}

	public CanMove() {

		let can_move = !this.IsDead()
		return can_move
	}

	public DoMove(end_pos?) {

		//死亡状态不进行移动处理
		if (this.IsDead()) {
			return
		}
		if (!this.CanMove()) {
			return
		}

		//如果当前位置和终点位置接近，就不移动了
		if (GameMath.IsPointNear(this.real_pos.x, this.real_pos.y, end_pos.x, end_pos.y, 10)) {
			return false
		}

		this.SetDirection(this.real_pos, end_pos, true)

		//DoMove和DoPathMove不能并存
		this.custom_path = null

		//计算移动基本信息
		this.state_move_dir.x = end_pos.x - this.real_pos.x
		this.state_move_dir.y = end_pos.y - this.real_pos.y
		let distance = this.state_move_dir.normalise()

		this.state_move_start_pos.x = this.real_pos.x
		this.state_move_start_pos.y = this.real_pos.y

		this.state_move_end_pos.x = end_pos.x
		this.state_move_end_pos.y = end_pos.y
		this.state_move_total_distance = distance
		this.state_move_pass_distance = 0.0
		this.state_move_start_time = local_Status.NowTime

		//如果当前不在移动状态则切换至移动状态
		if (!this.IsInState(local_PoseState.MOVE)) {
			this.ChangeState(local_PoseState.MOVE)
		}
		return true
	}

	//派发副本监听的怪物死亡处理
	public DispatchReallyDeadEvent() {

	}

	public ForceDoDead(dir?) {
		//强制死亡 不用等受击结束
		if (this.IsVoValid()) {
			this.vo.hp = 0
		}
		this.DispatchReallyDeadEvent()
		this.SetLandInfo(dir)
	}

	//设置着地信息  着地后进行死亡操作
	public SetLandInfo(dir?) {

		this.SetBodyXY(0, 0)
		if (!this.IsVoValid() || this.vo.hp == 0) {
			this.DoDead()
		}
	}

	public Revived() {
		this.is_to_dead = false
		this.is_dead = false
		this.DoStand()

		if (this.name_board) {
			this.name_board.SetHp(this.vo.hp, this.vo.maxHp)
		}
	}


	public IsDead() {

		return this.is_dead || this.is_to_dead || this.vo == null
	}

	public DoDead() {

		if (this.is_dead) {
			return
		}
		this.is_to_dead = true

		this.is_dead = true
		GlobalEventSystem.Fire(SceneEventType.CHARACTER_DEAD, this)

		this.ChangeState(local_PoseState.DEAD)
		this.buff_manager.removeAllSkillBuff()
	}
	public EnterStateDead(state_name?) {

		this.PlayAction("death")
	}

	public UpdateStateDead(state_name?, elapse_time?) {

	}

	public QuitStateDead(state_name?) {

	}


	public DeleteMe() {

		this.is_dead = true
		this.is_to_dead = true
		this.ReleaseCharacter()
		super.DeleteMe()
	}
	public ResetCharacter() {

		this.ResetSceneObj()
		this.normal_hited_totalTime = 0.2
		this.is_dead = false
		this.is_to_dead = false
		this.s_hited_info = null
	}
	public ReleaseCharacter() {

		this.last_action_name = null
		this.curr_body_action_name = null

		this.SetAlpha(1)
		
		this.buff_manager.removeAllSkillBuff()
		this.SetPlaySpeed(1)
		this.RemoveAllParticle()
		this.ReleaseSceneObj()
	}

	public ActionNotCross() {
		let vo = this.GetVo()
		return vo && (vo.prePoseState == local_PoseState.STAND || vo.prePoseState == local_PoseState.DEAD)
	}

	public ReplayAction() {

		this.PlayAction(this.last_action_name)
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
		}else
		{
			if(force_action_cross_time == null)
			{
				cross_time = (action_name == "idle") && Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.cross_animation_time || 0
			}else
			{
				cross_time = force_action_cross_time
			}
		}
		CommonCrossFadeAnim(this.animator, this.curr_body_action_name, cross_time, not_change_same_action)
		return cross_time
	}

	public GetMoveSpeed(dir?, speed?) {

		speed = speed || this.move_speed
		return speed
	}

	public GetLogicPos() {
		return this.logic_pos
	}

	public GetRealPos() {
		return this.real_pos
	}

	public SetMoveSpeed(move_speed?) {

		this.move_speed = move_speed
	}
	public GetVo() {

		return this.vo
	}

	public IsVoValid() {

		return this.vo
	}

	public SetBuffList(list?, breaked_skill_id?) {

		if (this.IsDead()) {
			this.buff_manager.removeAllSkillBuff()
			return
		}
		this.buff_manager.addRoleBuffList(list, breaked_skill_id)
	}

}

var local_Character = Character
window["Character"] = Character