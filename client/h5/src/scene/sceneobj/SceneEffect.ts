import { BaseClass } from "../../common/BaseClass"
import { GameSettingManager } from "../../common/GameSettingManager"
import { ResManager } from "../../common/ResManager"
import { ParticleManager } from "../../particalEffect/ParticleManager"
import { LOAD_QUEUE } from "../../util/DeclareGlobalVar"
import { GameResPath } from "../../util/GameResPath"
import { ResetTransform, Set3DLocalPosition, Set3DLocalRotationEuler, Set3DLocalScale, Util } from "../../util/Util"
import { EffectResType, PrintParticleInfo } from "../SceneConfig"
import { SceneManager } from "../SceneManager"
import { SceneObj } from "./SceneObj"

export class SceneEffect extends BaseClass {
	parent
	sprite: Laya.Sprite3D
	scene_id
	scene_mgr: SceneManager
	effect_name
	effect_data
	load_call_back
	effect_res_url

	public constructor(effect, parent, scene_id, load_call_back?) {
		super()
		this.scene_mgr = SceneManager.GetInstance()
		this.sprite = null
		this.parent = parent
		this.scene_id = scene_id
		this.effect_data = effect
		this.effect_name = effect.name
		this.load_call_back = load_call_back
		this.Init()
	}

	public Init() {
		let load_call_back = (sprite: Laya.Sprite3D) => {
			if (Util.IsNull(sprite) || Util.IsNull(this.parent)) {
				return
			}

			if (this.use_delete_method) {
				sprite.destroy()
				return
			}

			let cur_scene_id = this.scene_mgr.GetSceneId()
			if (this.scene_id != cur_scene_id) {
				sprite.destroy()
				return
			}

			this.parent.addChild(sprite)
			ResetTransform(sprite.transform)
			let effect_data = this.effect_data
			if (effect_data.effectScale_x && effect_data.effectScale_x != 0) {
				// sprite.transform.localScale = new Laya.Vector3(effect_data.effectScale_x, effect_data.effectScale_y, effect_data.effectScale_z)
				Set3DLocalScale(sprite.transform, effect_data.effectScale_x, effect_data.effectScale_y, effect_data.effectScale_z)
			} else {
				// sprite.transform.localScale = new Laya.Vector3(1, 1, 1)
				Set3DLocalScale(sprite.transform)
			}

			sprite.transform.localRotation = Laya.Quaternion.DEFAULT
			Util.tempVector3.setValue(0, SceneObj.StartRotate.y, 0)
			sprite.transform.rotate(Util.tempVector3, true, false)
			Util.tempVector3.setValue(SceneObj.StartRotate.x, 0, 0)
			sprite.transform.rotate(Util.tempVector3, true, false)

			if (effect_data.euler_y) {
				let rotate = effect_data.euler_y % 360
				let curRotate = - rotate + 90
				Util.tempVector3.setValue(0, curRotate, 0)
				sprite.transform.rotate(Util.tempVector3, true, false)
			}

			let z = this.scene_mgr.GetSceneObjDepth(effect_data.y)
			Set3DLocalPosition(sprite.transform, effect_data.x * 0.01, effect_data.y * 0.01, z)


			ParticleManager.SetSpeed(sprite, effect_data.speed)

			if (effect_data.level > GameSettingManager.GetInstance().GetEffectLevel() || GameSettingManager.GetInstance().GetBlockProperty("scenePtc")) {
				sprite.active = false
			}

			this.sprite = sprite
			// console.log("gameobjecty====" + this.sprite.name)

			if (this.load_call_back) {
				this.load_call_back(this.sprite.transform)
			}
		}
		let effect_res_type = this.effect_data.effect_res_type || EffectResType.Other
		let full_url = GameResPath.GetEffectPath(effect_res_type, this.effect_name)
		this.effect_res_url = full_url
		ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back, LOAD_QUEUE.LOW)
	}

	public SetActive(state?) {
		if (this.sprite) {
			this.sprite.active = state
		}
	}

	public DeleteMe() {
		if (this.sprite) {
			if (this.effect_res_url) {
				ResManager.GetInstance().AddSprite3DToPool(this.hashCode, this.effect_res_url, this.sprite)
			} else {
				this.sprite.destroy()
			}
			this.sprite = undefined
		}
		super.DeleteMe()
	}
}
