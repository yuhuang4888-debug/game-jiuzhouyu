import { ParticleManager } from "../../particalEffect/ParticleManager"
import { Vector2 } from "../../util/Vector2"
import { Scene } from "../Scene"
import { EffectResType, SceneBaseType } from "../SceneConfig"
import { SceneManager } from "../SceneManager"
import { SceneObj } from "./SceneObj"

export class Door extends SceneObj {
	effect_id
	scene_name

	public static ParticleResName ="sence_effect_chuansongmen_1"

	public constructor(vo) {
		super()

		this._type = SceneBaseType.Door
		this.id = vo.id
		this.vo = vo
		this.compress_id = this.scene.CompressObjId(SceneBaseType.Door, this.id)
		this.scene_name = vo.enter_scene_name

		//传送门特效
		this.effect_id = ParticleManager.GetInstance().AddPosEffect(Door.ParticleResName, new Vector2(this.vo.pixel_x, this.vo.pixel_y), true,
		 null, null, false, null, null, null, 1, true, null, null, null, null,EffectResType.Other)

		if (this.name_board) {
			// if (this.vo.is_same_scene) {
			// 	this.name_board.SetName("<font color='#73ac44'>" + this.vo.enter_scene_name + "</font>")
			// 	this.name_board.SetHpVisible(false)
			// } else {
				this.name_board.SetName("<font color='#73ac44'>" + this.vo.enter_scene_name + "</font>")
				this.name_board.SetHpVisible(false)
			// }

		}
		this.SetRealPos(this.vo.pixel_x, this.vo.pixel_y, true)
		this.root_transform.owner.active = false

		if(SceneManager.GetInstance().IsSeaHegemonyScene()){
			this.SetShadowVisible(false)
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