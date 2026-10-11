
import { Config } from "../../common/Config";
import { GlobalEventSystem } from "../../util/DeclareGlobalVar";
import { GameMath } from "../../util/GameMath";
import { PoseState } from "../../util/StateMachineManager";
import { Status } from "../../util/Status";
import { TimeUtil } from "../../util/TimeUtil";
import { Util } from "../../util/Util";
import { Vector2 } from "../../util/Vector2";
import { FightEvent } from "../fight/FightEvent";
import { Scene } from "../Scene";
import { SceneBaseType } from "../SceneConfig";
import { Character } from "./Character";
import { SceneObj } from "./SceneObj";
import { SourceOperateMove } from "../../operation/SourceOperateMove";
let local_PoseState = PoseState
let local_SceneBaseType = SceneBaseType
let local_SceneObj = SceneObj
let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Status = Status
let local_Vector2 = Vector2
let local_GameMath = GameMath
let local_GlobalEventSystem = GlobalEventSystem
//小精灵
export class Sprite extends Character {
	/**
	 * 主角的移动时 跟随物的相对位置
	 */
	 static FollowOffset = { x: 150, y: -100 }
	 static FollowDir
	 static FollowDis
	 static OffsetAngle
 
	 static __Init__(){
		 this.FollowDir = new local_Vector2(this.FollowOffset.x, this.FollowOffset.y) 
		 this.FollowDis = this.FollowDir.normalise()
 
		 //正方向(单位向量)
		 var forward_dir = new local_Vector2(0, 1)
		 var dot = this.FollowDir.x * forward_dir.x + this.FollowDir.y * forward_dir.y
		 var angle = Math.acos(dot) * 180 / Math.PI
		 var z = this.FollowDir.x * forward_dir.y - this.FollowDir.y * forward_dir.x
 
		 this.OffsetAngle = z < 0 ? -angle : angle
	 }


	/**
	 * 待机时随机移动的范围
	 */
	public static MoveOffset = [
		new local_Vector2(120, 120),
		new local_Vector2(120, -120),
		new local_Vector2(-120, -120),
		new local_Vector2(-120, 120)
	]



	temp_dir = new local_Vector2()
	last_attack_time
	last_check_time
	is_dead
	random_move_interval
	curr_follow_tar_pos = { x: 0, y: 0 }
	next_frame_funcs
	sprite_renderer
	main_role_attack_time
	pos_index
	update_index
	// last_find_time
	defender_list
	stat_start_time
	// find_way_offset
	owner
	move_speed

	public constructor() {
		super()

		this._type = local_SceneBaseType.Sprite

		this.stat_start_time = local_Status.NowTime
		this.random_move_interval = this.getRandomMoveInterval()
		this.pos_index = 1
		this.update_index = 0
		this.main_role_attack_time = false
		this.last_check_time = false
		this.last_attack_time = false
		// this.last_find_time = 0
		// this.find_way_offset = 0.15
	}

	public SpriteTextureChange() {
		this.CreateClotheSprite(this.vo.GetSpriteClotheId())
	}

	public CanUpdate() {

		let can_update = super.CanUpdate()
		if (!can_update) {
			if (this.owner && (this.owner.IsInState(local_PoseState.MOVE) || this.owner.type == local_SceneBaseType.MainRole)) {
				return true
			} else if (this.owner && (this.owner.IsInState(local_PoseState.JUMP) || this.owner.IsInState(local_PoseState.TASK_JUMP)) && this.ignore_update_index > 8) {
				return true
			} else if (super.IsInState(local_PoseState.STAND) && this.all_rotate_off == null && this.ignore_update_index > 10) {
				return true
			}
		}
		return can_update
	}

	public CheckToUseSkill(now_time) {

		if (this.scene_mgr.IsSafePos(this.owner.real_pos.x, this.owner.real_pos.y)) {
			return
		}

		if (this.main_role_attack_time && now_time - this.main_role_attack_time <= 2.2) {
			if (local_GameMath.GetDistance(this.real_pos.x, this.real_pos.y, this.owner.real_pos.x, this.owner.real_pos.y, false) <= 450 * 450) {
				let nearest_defender_compress_id = null
				if (this.defender_list) {
					let nearest_dist = 100000000
					let curr_dist = 0
					for (let i in this.defender_list) {
						var defender = this.defender_list[i]
						curr_dist = local_GameMath.GetDistance(this.real_pos.x, this.real_pos.y, defender.real_pos.x, defender.real_pos.y, false)
						if (!defender.IsDead() && nearest_dist > curr_dist) {
							nearest_dist = curr_dist
							nearest_defender_compress_id = defender.compress_id
						}
					}
				}
				this.last_attack_time = now_time
				local_GlobalEventSystem.Fire(FightEvent.RELEASE_MAIN_SKILL, this, Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.sprite_skill_id, nearest_defender_compress_id)
			}
		}
	}

	public MainRoleAttack(defender_list?) {

		if (!Util.IsTableEmpty(defender_list)) {
			this.defender_list = defender_list
			this.main_role_attack_time = local_Status.NowTime
		}
	}

	public UpdateStateMove(state_name?, elapse_time?) {

		if (this.owner) {
			super.UpdateStateMove(state_name, this.owner.move_update_elipse_time || elapse_time)
		} else {
			super.UpdateStateMove(state_name, elapse_time)
		}
	}

	public Update(now_time?, elapse_time?) {
		if (this.vo == null || this.owner == null || this.owner.vo == null) {
			this.next_frame_funcs = null
			return
		}
		if (!Util.IsTableEmpty(this.next_frame_funcs)) {
			for (let i in this.next_frame_funcs) {
				var f = this.next_frame_funcs[i]
				if (f != null) {
					f()
				}
				this.next_frame_funcs[i] = null
			}
		}
		if (!this.last_check_time || now_time - this.last_check_time >= 2) {
			this.last_check_time = now_time
			//this:CheckToUseSkill()
		}
		if (this.last_attack_time && now_time - this.last_attack_time < 0.7) {
			if (this.IsInState(local_PoseState.MOVE)) {
				this.DoStand()
			}
			return
		}  //放技能1.5秒内不能移动

		this.update_index = this.update_index + 1
		if (this.update_index % 7 == 0) {
			let dist = local_GameMath.GetDistance(this.real_pos.x, this.real_pos.y, this.owner.real_pos.x, this.owner.real_pos.y, true)
			if (dist >= local_Sprite.FollowDis) {
				// if (local_Status.NowTime - this.last_find_time > this.find_way_offset) {
					// this.last_find_time = local_Status.NowTime
					let end_pos = this.GetFollowPos()
					this.move_speed = this.owner.GetMoveSpeed(this.owner.direction) * (1 + (dist - 300) / 600)
					this.DoMove(end_pos)
					this.update_index = 0
				// }
			} else if (local_Status.NowTime - this.stat_start_time >= this.random_move_interval && this.IsInState(local_PoseState.STAND)) {
				let end_pos = this.GetPosBesideOwner()
				this.move_speed = this.owner.GetMoveSpeed(this.owner.direction) * 0.8
				this.DoMove(end_pos)
				// this.FindPathAndMove(end_pos)
				this.random_move_interval = this.getRandomMoveInterval()
				this.update_index = 0
			}
		} else if (this.update_index % 3 == 0) {
			if (this.owner.HasModelHideFlag() && !this.HasModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole)) {
				this.SetModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole, true)
			} else if (!this.owner.HasModelHideFlag() && this.HasModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole)) {
				this.SetModelHideFlag(local_SceneObj.ModelHideFlag.IndependenRole, false)
			}
		}
		super.Update(now_time, elapse_time)
	}


	public getRandomMoveInterval() {

		return Util.RandomRange(3, 8)
	}


	public GetPosBesideOwner() {

		let owner_pos = this.owner.real_pos
		let t = Math.floor(TimeUtil.getClientTimeMs() % 4)
		if (t == this.pos_index) {
			t = Math.floor((this.pos_index + 1) % 4)
		}

		this.pos_index = t
		let off_pos = local_Sprite.MoveOffset[t]

		this.curr_follow_tar_pos.x = owner_pos.x + off_pos.x
		this.curr_follow_tar_pos.y = owner_pos.y + off_pos.y
		return this.curr_follow_tar_pos
	}

	public Revived() {
		super.Revived()
	}

	public DeleteMe() {
		this.ReleaseObj()
		super.DeleteMe()
	}
	public ClearSprite() {

		if (this.vo) {
			this.vo.UnBindAll()
			this.vo.DeleteMe()
			this.vo = null
		}
		this.next_frame_funcs = null
		// if (this.sprite_renderer ) {	
		// 	this.sprite_renderer.material.shader = SceneManager.GetInstance().GetTextureShader()
		// 	this.sprite_renderer = null
		// }
	}

	public ReleaseObj() {

		this.ReleaseCharacter()
		this.ClearSprite()
		this.owner = null
		this.defender_list = null
		this.main_role_attack_time = false
		this.is_dead = true
		this.is_to_dead = true
	}

	public ResetObj() {

		this.ResetCharacter()
	}

	public InitSpriteVo(owner?, vo?) {

		this.owner = owner
		this.vo = vo
		this.id = vo.sprite_id

		this.name = this.vo.name
		this.compress_id = this.scene.CompressObjId(local_SceneBaseType.Sprite, this.id)


		this.SetHideNameBord(true)

		this.BindVoEvents()
	}

	public EnterStateAttack(state_name?) {

		super.EnterStateAttack(state_name)

		let cfg = this.movie_cfg
		let t = this.s_attack_state
		let anim_name = ""
		let anim_time = t.last_time
		if (cfg == null || cfg.anim == null) {
			return
		}
		anim_name = cfg.anim
		this.PlayAction(anim_name)
	}

	public LoadInfoFromVo() {

		this.SetMoveSpeed(this.vo.move_speed)
		this.SetShowPosition()
		this.SpriteTextureChange()

		if (this.vo.hp == 0) {
			this.DoDead()
		} else {
			this.DoStand()
		}
	}


	public GetFollowPos() {

		let owner_pos = this.owner.real_pos
		let owner_dir = this.owner.direction

		if(local_Sprite.OffsetAngle == 0){
			this.temp_dir.x = owner_dir.x
			this.temp_dir.y = owner_dir.y
		}
		else {
			var radian  = local_Sprite.OffsetAngle / 180 * Math.PI
			this.temp_dir.x = owner_dir.x * Math.cos(radian) - owner_dir.y * Math.sin(radian)
			this.temp_dir.y = owner_dir.x * Math.sin(radian) + owner_dir.y * Math.cos(radian)
		}

		this.curr_follow_tar_pos.x = owner_pos.x + this.temp_dir.x * local_Sprite.FollowDis
		this.curr_follow_tar_pos.y = owner_pos.y + this.temp_dir.y * local_Sprite.FollowDis
	
		let grid_x = this.curr_follow_tar_pos.x / local_SceneObj.GetLogicRealRatio().x,
			grid_y = this.curr_follow_tar_pos.y / local_SceneObj.GetLogicRealRatio().y

		if (this.scene_mgr.IsBlockXY(grid_x, grid_y)) {
			let [x, y] = SourceOperateMove.FindNearestPos(new local_Vector2(owner_pos.x, owner_pos.y), new local_Vector2(this.curr_follow_tar_pos.x, this.curr_follow_tar_pos.y))
			this.curr_follow_tar_pos.x = x - 100
			this.curr_follow_tar_pos.y = y
		}
		return this.curr_follow_tar_pos
	}



	public BindVoEvents() {

		this.next_frame_funcs = this.next_frame_funcs || {}

		let hp_change_func = (oldVar1?, value?) => {
			if (this.name_board) {
				this.name_board.SetHp(value, this.vo.maxHp)
			}
		}

		var move_speed_func = (oldVar1, value) => {
			this.SetMoveSpeed(value)
		}

		var hide_flag_func = (oldVar1, value) => {
			// this.SetModelHideFlag(local_SceneObj.ServerHide, (value == 1))
		}

		var birth_angle_func = (oldVar1, value) => {
			this.BirthAngleChange()
		}

		this.vo.BindOne("hp", hp_change_func)
		this.vo.BindOne("move_speed", move_speed_func)
		this.vo.BindOne("hide_flag", hide_flag_func)
		this.vo.BindOne("birth_angle", birth_angle_func)
	}

	public UpdateModel(sprite_id?) {

		if (this.vo) {
			this.vo.ChangeVar("sprite_id", sprite_id)
			this.SpriteTextureChange()
		}
	}


	public EnterStateStand(state_name?) {

		super.EnterStateStand(state_name)
		this.stat_start_time = local_Status.NowTime
	}

	public SetHide() {

		this.modelObj_transform.owner.active = false
	}

	public SetShowPosition(flag?) {

		if (!this.vo || !this.owner) { return }
		if (!this.scene.IsSceneLoaded()) { return }
		let end_pos = this.GetFollowPos()
		let grid_x = end_pos.x / local_SceneObj.GetLogicRealRatio().x, grid_y = end_pos.y / local_SceneObj.GetLogicRealRatio().y
		if (this.scene_mgr.IsBlockXY(grid_x, grid_y)) {
			end_pos = SourceOperateMove.FindNoBlockPos(new local_Vector2(grid_x, grid_y))
			if (end_pos != null) {
				end_pos.x = end_pos.x * local_SceneObj.GetLogicRealRatio().x
				end_pos.y = end_pos.y * local_SceneObj.GetLogicRealRatio().y
			} else {
				end_pos = this.GetFollowPos()
				end_pos.x = end_pos.x + 0.5
				end_pos.y = end_pos.y + 0.5
			}
		}
		this.SetRealPos(end_pos.x, end_pos.y, true)
		this.SetDirection(this.owner.direction, null, null, true)
		this.DoStand()
	}
}
var local_Sprite = Sprite
window["Sprite"] = Sprite