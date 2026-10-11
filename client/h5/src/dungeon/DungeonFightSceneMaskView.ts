import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPosition, SetAnchoredPositionY, SetSizeDelta, SetSizeDeltaY } from "../util/Util"

export class DungeonFightSceneMaskView extends BaseView1 {
	_img_mask_top: Laya.Image
	_img_mask_down: Laya.Image
	_gp_born_effect: Laya.Box
	AddEffect
	AddMaskTweenInto
	AddMaskTweenOut
	LoadSuccess
	Remove
	SetAutoFight
	SetMaskWH
	close_callback
	destroy_imm
	mask_height
	mask_width
	open_callback
	touchChildren
	touchEnabled
	tween_list

	public constructor() {
		super()


		let layer_mgr = LayerManager.GetInstance()

		let local_laya = Laya
		let base_model = BaseDungeonModel.GetInstance()
		let playEffectTime_ = null
		let setFightTime_ = null
		let normal_height_ = 1280
		let normal_width_ = 720
		let top_mask_top_ = null
		let down_mask_bottom_ = null
		let close_time_id
		this.base_file = "dungeonCommon"
		this.layout_file = "DungeonFightSceneMaskView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.touchEnabled = false
		this.touchChildren = false
		this.load_callback = () => {
			LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Main, "DungeonFightSceneMaskView", false)
			LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Activity, "DungeonFightSceneMaskView", false)
			this.LoadSuccess()
		}

		this.open_callback = () => {
			SetAnchoredPositionY(this._img_mask_top, -this.mask_height)
			SetAnchoredPositionY(this._img_mask_down, Laya.stage.height)
			this.AddMaskTweenInto()
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			// this.form.anchorMin = Vector2(0, 0)
			// this.form.anchorMax = Vector2(1, 1)
			// this.form.sizeDelta = Vector2(0,0)



			this.SetMaskWH()


		}

		this.AddEffect = () => {

			let call_back_func = () => {

				this.AddMaskTweenOut()
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)

				//last_time = 1.5
			}
			close_time_id = setTimeout(() => {
				call_back_func()
			}, 3000)
			this.AddUIEffect("effect_ui_dayaolaixi", this._gp_born_effect, null, null, null, 1.5, call_back_func)
		}

		this.SetAutoFight = () => {
			AutoFightManager.GetInstance().SetAutoFight(true)
		}

		this.AddMaskTweenInto = () => {
			if (!this.tween_list) {
				this.tween_list = []
			}

			table.insert(this.tween_list, SYTweenLite.to(this, this._img_mask_top, SYTweenLite.UiAnimationType.ANCHORED_POSY, 0, 0.15))

			table.insert(this.tween_list, SYTweenLite.to(this, this._img_mask_down, SYTweenLite.UiAnimationType.ANCHORED_POSY, Laya.stage.height - this._img_mask_down.height, 0.15, () => {
				this.AddEffect()
			}))

		}

		this.AddMaskTweenOut = () => {
			if (!this.tween_list) {
				this.tween_list = []
			}
			table.insert(this.tween_list, SYTweenLite.to(this, this._img_mask_top, SYTweenLite.UiAnimationType.ANCHORED_POSY, -this.mask_height, 0.15))
			table.insert(this.tween_list, SYTweenLite.to(this, this._img_mask_down, SYTweenLite.UiAnimationType.ANCHORED_POSY, Laya.stage.height, 0.15, () => {
				LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Main, "DungeonFightSceneMaskView", true)
				LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Activity, "DungeonFightSceneMaskView", true)
				this.Close()
			}))
		}

		this.SetMaskWH = () => {
			let stage_height = Laya.stage.height
			let stage_width = Laya.stage.width
			this.mask_height = stage_height * 0.5 + 30
			this.mask_width = stage_width + 150
			SetSizeDelta(this._img_mask_top, this.mask_width, this.mask_height)
			SetSizeDelta(this._img_mask_down, this.mask_width, this.mask_height)
		}

		this.Remove = () => {
			// if (this.time_event_id_ ) {
			// 	GlobalTimerQuest.CancelQuest(this.time_event_id_)
			// }
			if (close_time_id) {
				clearTimeout(close_time_id)
				close_time_id = null
			}

			if (this.tween_list) {
				for (let k in this.tween_list) {
					var id = this.tween_list[k]
					SYTweenLite.Stop(id)
				}
				this.tween_list = false
			}
		}
	}



	public GetComponents() {
		[
			this._img_mask_top,
			this._img_mask_down,
			this._gp_born_effect,
		]
			= this.GetChildrenByNames([

				"_img_mask_top",
				"_img_mask_down",
				"_gp_born_effect",
			])
	}
}
window["DungeonFightSceneMaskView"] = DungeonFightSceneMaskView