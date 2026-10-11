import { table } from "../../common/table"
import { ParticleManager } from "../../particalEffect/ParticleManager"
import { Scene } from "../Scene"
import { EffectResType, SceneBaseType } from "../SceneConfig"
import { SceneObj } from "./SceneObj"

export class JumpPoint extends SceneObj {
	effect_id
	jump_index
	point_list

	public constructor(vo?) {
		super()

		this._type = SceneBaseType.JumpPoint
		this.vo = vo
		this.id = vo.instance_id
		if (vo.show == 1) {
			this.effect_id = ParticleManager.GetInstance().AddPosEffect("UI_1124", this.vo.real_pos, true, null, null, false, null, null, null, null, null, null, null, null, null, EffectResType.UI)
		}
		this.SetRealPos(this.vo.real_pos.x, this.vo.real_pos.y, true)
		this.can_pick = false
		this.root_transform.owner.active = false
		this.SetHideNameBord(true)

		this.point_list = []
		this.InitJumpList(vo.jump_list)
		this.jump_index = 0

		// if (this.effect_id) {
		// 	let scale = 0.66
		// 	ParticleManager.Instance.SetEffectScale(this.effect_id, scale)
		// }
	}

	public InitJumpList(point_str?) {

		let point_list = point_str.split(",")
		for (let k = 0; k < point_list.length; k++) {
			var v = point_list[k]
			if (k > 1) {
				let point = v.split(":")
				table.insert(this.point_list, { x : Number(point[0]), y : Number(point[1]) })
			}
		}
	}

	public JumpFinish() {

		if (this.jump_index == 0) {
			return true
		}

		if (this.jump_index >= this.point_list.length) {
			this.jump_index = 0
			return true
		}

		return false
	}

	public DoJump() {
		if (this.jump_index < this.point_list.length) {
			this.jump_index = this.jump_index + 1
			Scene.Instance.GetMainRole().DoJump(this.point_list[this.jump_index], true)
		}
	}

	public DeleteMe() {
		if (this.effect_id) {
			ParticleManager.GetInstance().DelEffect(this.effect_id)
			this.effect_id = null
		}
		super.DeleteMe()
	}

	public GetVo() {
		return this.vo
	}
}
