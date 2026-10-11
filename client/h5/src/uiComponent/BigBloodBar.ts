

import { UIEffect } from "../common/UIEffect"
import { ResManager } from "../common/ResManager";
import { GlobalTimerQuest } from "../util/Util";
import { SYTweenFunc } from "../util/SYTweenFunc";
import { BaseItem1 } from "../common/BaseItem1";

export class BigBloodBar extends BaseItem1 {

	_img_bg: Laya.Image
	_img_virtual: Laya.Image
	_img_realy: Laya.Image
	_Image1: Laya.Image
	ab_name

	curr_value
	front_img_name
	last_value
	max_value

	timer_id

	public constructor(parent?, max_value?, curr_value?) {
		super(parent);

		this.base_file = "uiComponent"
		this.layout_file = "BigBloodBar"
		this.is_load_res = false
		// this.skinName = "resource/game/uiComponent/exml/BigBloodBarExml.exml"
		this.load_callback = () => {
			this.InitData(max_value, curr_value)
			this.LoadSuccess()
		}
	}

	public InitData(max_value?, curr_value?) {

		this.ab_name = "uicomponent_asset"
		this.max_value = max_value || 100 //最大值
		this.curr_value = curr_value || 1 //当前值
		this.last_value = this.curr_value //上一次值
	}

	public LoadSuccess() {

		this.SetValue()
	}

	public SetValue(value?, max_value?) {

		this.curr_value = value || this.curr_value
		this.max_value = max_value || this.max_value
		this.curr_value = Math.min(this.curr_value, this.max_value)
		this.last_value = Math.min(this.last_value, this.max_value)
		this._img_realy.width = this.curr_value / this.max_value * 112
		this._img_realy.height = 8

		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
		let start_value = this.last_value
		let value_off = this.last_value - this.curr_value
		let use_time = 0
		let total_time = 0.2
		let delta_time = 0.02
		if (value_off > 0 && value_off / this.max_value >= 0.001) {
			var onTimer = () => {
				use_time = use_time + delta_time
				this.last_value = start_value - value_off * SYTweenFunc.easeIn(Math.min(use_time / total_time, 1))
				if (this.last_value <= this.curr_value) {
					this.last_value = this.curr_value
					if (this.timer_id) {
						GlobalTimerQuest.CancelQuest(this.timer_id)
						this.timer_id = null
					}
				}
				this._img_virtual.width = this.last_value / this.max_value * 112
				this._img_virtual.height = 8
			}
			onTimer()
			this.timer_id = GlobalTimerQuest.AddPeriodQuest(onTimer, delta_time, -1)
		} else {
			this.last_value = this.curr_value
			this._img_virtual.width = this.curr_value / this.max_value * 112
			this._img_virtual.height = 8
		}
	}

	public SetFrontImageStyle(front_img_name?) {

		if (this.front_img_name == front_img_name) { return }
		this.front_img_name = front_img_name
		ResManager.GetInstance().SetImageSprite(this, this._img_realy, this.ab_name, this.front_img_name)
	}


	public DeleteMe() {

		// if (this.timer_id ) {
		// 	GlobalTimerQuest.CancelQuest(this.timer_id)
		// 	this.timer_id = null
		// }
		super.DeleteMe()
	}
	public GetComponents() {
		[
			this._img_bg,
			this._img_virtual,
			this._img_realy,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_virtual",
				"_img_realy",
				"_Image1",
			])
	}
}
window["BigBloodBar"] = BigBloodBar