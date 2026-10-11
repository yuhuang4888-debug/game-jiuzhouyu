import { GameMath } from "../../util/GameMath";
import { Status } from "../../util/Status";
import { Character } from "./Character";
import { SceneBaseType } from "../SceneConfig";
import { PoseState } from "../../util/StateMachineManager";
import { Vector2 } from "../../util/Vector2";
import { SceneObj } from "./SceneObj";
import { Scene } from "../Scene";
import { SceneManager } from "../SceneManager";
import { SourceOperateMove } from "../../operation/SourceOperateMove";
import { Config } from "../../common/Config";
import { DemonModel } from "../../commonModel/DemonModel";

let local_PoseState = PoseState
let local_SceneBaseType = SceneBaseType
let local_SceneObj = SceneObj
let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Status = Status
let local_Vector2 = Vector2
let local_GameMath = GameMath
export class Demon extends Character {
	/**
	 * 主角的移动时 跟随物的相对位置
	 */
	 static FollowOffset = { x: 150, y: 100 }
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

	temp_dir = new local_Vector2()
	update_index
	owner_name_id
	// find_way_offset
	// last_find_time
	is_dead
	curr_follow_tar_pos = { x: 0, y: 0 }
	owner
	move_speed

	public constructor() {
		super()
		this._type = local_SceneBaseType.Demon
		this.update_index = 0
		// this.last_find_time = 0
		// this.find_way_offset = 0
	}

	public DemonTextureChange() {

		this.CreateClotheSprite(this.vo.GetTextureId())
	}

	public CanUpdate() {

		let can_update = super.CanUpdate()
		if (!can_update) {
			if (this.owner && this.owner.IsInState(local_PoseState.MOVE)) {
				return true
			} else if (this.owner && (this.owner.IsInState(local_PoseState.JUMP) || this.owner.IsInState(local_PoseState.TASK_JUMP)) && this.ignore_update_index > 8) {
				return true
			} else if (this.IsInState(local_PoseState.STAND) && !this.all_rotate_off && this.ignore_update_index > 10) {
				return true
			}
		}
		return can_update
	}

	public Update(now_time?, elapse_time?) {

		if (this.vo == null || this.owner == null) {
			return
		}
		this.update_index = this.update_index + 1
		if (this.update_index % 7 == 0) {
			let dist = local_GameMath.GetDistance(this.real_pos.x, this.real_pos.y, this.owner.real_pos.x, this.owner.real_pos.y, true)
			if (dist >= local_Demon.FollowDis) {
				// if (local_Status.NowTime - this.last_find_time > this.find_way_offset) {
				// 	this.last_find_time = local_Status.NowTime
					let end_pos = this.GetFollowPos()
					this.move_speed = this.owner.GetMoveSpeed(this.owner.direction) * (1 + (dist - 350) / 600)
					this.DoMove(end_pos)
					this.update_index = 0
					// let is_straight_line = this.FindPathAndMove(end_pos)
					// if (is_straight_line) {
					// 	this.find_way_offset = 0
					// } else {
					// 	this.find_way_offset = 0.15
					// }
					// this.update_index = 0
				// }
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

	public UpdateStateMove(state_name?, elapse_time?) {

		if (this.owner) {
			super.UpdateStateMove(state_name, this.owner.move_update_elipse_time || elapse_time)
		} else {
			super.UpdateStateMove(state_name, elapse_time)
		}
	}



	public Revived() {

		super.Revived()
	}

	public DeleteMe() {
		this.ReleaseObj()
		super.DeleteMe()
	}
	public ClearDemon() {

		if (this.vo) {
			this.vo.UnBindAll()
			this.vo.DeleteMe()
			this.vo = null
		}

		if (this.owner && this.owner.GetVo() && this.owner_name_id) {
			this.owner.GetVo().UnBind(this.owner_name_id)
		}
		this.owner = null
		this.owner_name_id = null
	}
	public ReleaseObj() {

		this.ReleaseCharacter()
		this.ClearDemon()

		this.is_dead = true
		this.is_to_dead = true
	}

	public ResetObj() {

		this.ResetCharacter()
	}

	public InitDemonVo(owner?, demon_vo?) {

		this.vo = demon_vo
		this.id = demon_vo.demon_id
		this.owner = owner
		this.name = this.vo.name
		this.compress_id = this.scene.CompressObjId(local_SceneBaseType.Demon, owner.id)
		if (this.name_board) {
			this.name_board.SetHp(this.vo.hp, this.vo.maxHp)
		}
		if (this.vo.hide_flag == 1) {
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, true)
		}
		this.SetHideNameBord(false)
		this.UpdateName()
		this.BindVoEvents()

	}

	public LoadInfoFromVo() {

		this.SetMoveSpeed(this.vo.move_speed)
		this.DemonTextureChange()
		this.SetShowPosition()
	}

	public BindVoEvents() {

		//刷新名字
		let name_func = (oldVar1, value) => {
			this.vo.name = value + "的妖灵"
			this.UpdateName()
		}
		this.owner_name_id = this.owner.GetVo().BindOne("name", name_func)
	}

	public UpdateName() {
		if (this.vo && this.name_board) {
			this.name_board.SetHpVisible(false)
			let color = "#5be2ff"
			let name = this.owner.InMaskState() && "蒙面人的妖灵" || this.vo.name
			this.name_board.SetName(name, color)
		}
	}

	public UpdateDemon(demon_id?) {

		if (this.vo) {
			this.vo.demon_id = demon_id
			this.vo.model_id = DemonModel.GetInstance().GetResource(demon_id)
			this.id = demon_id
			this.DemonTextureChange()
			this.UpdateName()
		}
	}

	public GetFollowPos() {

		let owner_pos = this.owner.real_pos
		let owner_dir = this.owner.direction

		if(local_Demon.OffsetAngle == 0){
			this.temp_dir.x = owner_dir.x
			this.temp_dir.y = owner_dir.y
		}
		else {
			var radian  = local_Demon.OffsetAngle / 180 * Math.PI
			this.temp_dir.x = owner_dir.x * Math.cos(radian) - owner_dir.y * Math.sin(radian)
			this.temp_dir.y = owner_dir.x * Math.sin(radian) + owner_dir.y * Math.cos(radian)
		}

		this.curr_follow_tar_pos.x = owner_pos.x + this.temp_dir.x * local_Demon.FollowDis
		this.curr_follow_tar_pos.y = owner_pos.y + this.temp_dir.y * local_Demon.FollowDis
	
		let grid_x = this.curr_follow_tar_pos.x / local_SceneObj.GetLogicRealRatio().x,
			grid_y = this.curr_follow_tar_pos.y / local_SceneObj.GetLogicRealRatio().y

		if (this.scene_mgr.IsBlockXY(grid_x, grid_y)) {
			let [x, y] = SourceOperateMove.FindNearestPos(new local_Vector2(owner_pos.x, owner_pos.y), new local_Vector2(this.curr_follow_tar_pos.x, this.curr_follow_tar_pos.y))
			this.curr_follow_tar_pos.x = x - 100
			this.curr_follow_tar_pos.y = y
		}
		return this.curr_follow_tar_pos
	}


	public SetShowPosition(flag?) {
		if (!this.vo || !this.owner) { return }
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

	public LoadClotheResComplete() {
		let cfg = Config_PRELOAD_CLIENT_CONFIG.ClientSceneModeCfg
		let scale = cfg && cfg[this.id] && cfg[this.id].size || 1
		this.SetScale(scale)
		super.LoadClotheResComplete()

	}
}
var local_Demon = Demon
window["Demon"] = Demon