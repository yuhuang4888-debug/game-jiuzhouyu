import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { ResManager } from "../common/ResManager"
import { DragonWhisperModel } from "../commonModel/DragonWhisperModel"

export class dwTimeTipsView extends BaseView1 {
	LoadSuccess
	StartTimer
	UpdateTimer

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwTimeTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true

		let _model = DragonWhisperModel.GetInstance()
		let local_DrWsTimer = DragonWhisperModel.DrWsTimer
		let local_TimeUtil = TimeUtil
		let _end_time_ = null

		this.load_callback = () => {
			this.display_obj.left = this.display_obj.right = this.display_obj.bottom = 0
			this.display_obj.top = Util.GetLiuhaiHeight()
			// this.form.anchorMin = Vector2(0, 0)
			// this.form.anchorMax = Vector2(1, 1)
			// let liu_hai_height = GetLiuhaiHeight()
			// if (liu_hai_height) {
			// 	this.form.anchoredPosition = Vector2(0, -liu_hai_height / 2)
			// 	this.form.sizeDelta = Vector2(0, -liu_hai_height)
			// } else {
			// 	this.form.anchoredPosition = Vector2(0, 0)
			// 	this.form.sizeDelta = Vector2(0, 0)
			// }
			ResManager.GetInstance().LoadFont(this, "scene_damage_mainrole", this._lb_time, 20)
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			_model.ClearTimer(local_DrWsTimer.OUT.key)
		}

		this.LoadSuccess = () => {
			_end_time_ = 10 + local_TimeUtil.getServerTime()
			this.StartTimer()
		}

		this.StartTimer = () => {
			_model.StartTimer(local_DrWsTimer.OUT.key, 1, () => {
				this.UpdateTimer()
			})
			this.UpdateTimer()
		}

		this.UpdateTimer = () => {
			let rtime = _end_time_ - local_TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_time.text = String(rtime)
			} else {
				_model.ClearTimer(local_DrWsTimer.OUT.key)
				this.Close()
			}
		}
	}

	_Group2: Laya.Box
	_Image2: Laya.Image
	_Group1: Laya.Box
	_lb_time: Laya.Label
	_Image3: Laya.Image
	public GetComponents() {
		[
			this._Group2,
			this._Image2,
			this._Group1,
			this._lb_time,
			this._Image3,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"_Image2",
				"_Group1",
				"_lb_time",
				"_Image3",
			])
	}
}
window["dwTimeTipsView"] = dwTimeTipsView