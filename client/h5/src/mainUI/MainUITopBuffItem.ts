import { BaseItem1 } from "../common/BaseItem1"
import { MainUIModel } from "../commonModel/MainUIModel"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"

export class MainUITopBuffItem extends BaseItem1 {
	buff_data
	totle_time
	timer_id
	need_refresh_data
	mask: Laya.Sprite

	public constructor(parent?) {
		super(parent)
		this.base_file = "mainUI"
		this.layout_file = "MainUITopBuffItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public DeleteMe() {
		this.ClearnTimer()
		// this._img_mask.mask = null
		super.DeleteMe()
	}

	private LoadSuccess() {
		this.mask = new Laya.Sprite()
		this.mask.x = this._img_mask.width / 2
		this.mask.y = this._img_mask.height / 2
		this._img_mask.mask = this.mask

		if (this.need_refresh_data) {
			this.UpdateItem()
			this.need_refresh_data = undefined
		}
	}

	private UpdateItem() {
		this._img_bg.skin = GameResPath.GetIcon("bufficon", this.buff_data.cfg.icon)
		this.ClearnTimer()
		if (this.buff_data.time) {
			this.UpdateCD()
			if (!this.buff_data.end_time) {
				this.buff_data.end_time = TimeUtil.getServerTime() + this.buff_data.time
			}
			this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				if (this.buff_data.end_time && this.buff_data.end_time < TimeUtil.getServerTime()) {
					if (this.buff_data.skill_key) {
						MainUIModel.GetInstance().DelSkillBuff(this.buff_data.skill_key)
					}
					this.ClearnTimer()
					this._lb_time.text = ""
					this._img_mask.visible = false
				} else {
					this.UpdateCD()
				}
			}, 1)
		} else {
			this._lb_time.text = ""
			this._img_mask.visible = false
		}
	}

	private ClearnTimer() {
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}

	private UpdateCD() {
		if (this.use_delete_method) {
			return
		}
		let time = this.buff_data.end_time - TimeUtil.getServerTime()
		if (time <= 99) {
			this._lb_time.text = time.toString()
		} else {
			this._lb_time.text = ""
		}
		this.UpdateMask(time)
	}

	private UpdateMask(time) {
		if (!this.totle_time || time < 0) {
			this._lb_time.text = ""
			this._img_mask.visible = false
			return
		}
		this._img_mask.visible = true
		let angle = time / this.totle_time
		if (angle > 0 && angle < 1) {
			angle = 1 - angle
		}
		this.mask.graphics.clear()
		this.mask.graphics.drawPie(0, 0, 18, 360 - 90, 360 * angle - 90, 0x000000)
	}

	public SetData(buff_data) {
		this.buff_data = buff_data
		this.totle_time = buff_data.cfg.time || 0

		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	_img_bg: Laya.Image
	_img_mask: Laya.Image
	_lb_time: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_mask,
			this._lb_time,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_mask",
				"_lb_time",
			])
	}
}
window["MainUITopBuffItem"] = MainUITopBuffItem