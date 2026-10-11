import { BaseClass } from "../common/BaseClass"
import { Vector2 } from "../util/Vector2"

export class JumpPointVo extends BaseClass {
	instance_id
	jump_list
	real_pos
	show

	public constructor() {
		super()

	}

	public CreateJumpPointInfo(id?, info?) {
		this.instance_id = id
		this.real_pos = new Vector2(info.x, info.y)
		this.jump_list = info.list
		this.show = info.show
	}

}

window["JumpPointVo"] = JumpPointVo