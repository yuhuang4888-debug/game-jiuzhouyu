import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { DragonWhisperModel, DrWsEvent } from "../commonModel/DragonWhisperModel"

export class dwMonItem extends BaseItemRenderer {
	WIDTH = 218
	HEIGT = 36
	_model
	_timer

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwMonItem"
		this._model = DragonWhisperModel.GetInstance()
		this.load_callback = () => {
			Util.AddClickEvent(this._gp_con, () => {
				this._model.Fire(DrWsEvent.SELECT_FIGHT_ITEM, this.index)
			}, this)
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		let data = this.data
		let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
		let b = this._model.CheckAttrByMonID(mon_cfg, Number(data.mon_id))
		this._lb_name.color = b ? "#663915" : "#ff4f50"
		this.data.can_fight = b
		let mdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.mon_id, false)
		this._lb_name.text = mdata && mdata.name || ""
		if (data.reborn_time == 0) {
			this._lb_time.text = "已复活"
			this.ClearTimer()
		} else if (this.data.reborn_time && this.data.reborn_time > 0) {
			this.StartTimer()
		} else {
			let stage = mon_cfg[Number(data.mon_id)].mon_stage
			this._lb_time.text = stage + "阶"
			this.ClearTimer()
		}
		this._img_select.visible = this.selected
	}

	public UpdateTimer() {
		let rtime = this.data.reborn_time - TimeUtil.getServerTime()
		if (rtime > 0) {
			this._lb_time.text = TimeUtil.timeConvert(rtime, "hh:MM:ss")
		} else {
			this._lb_time.text = "已复活"
			this.ClearTimer()
		}
	}

	public DeleteMe() {
		this.ClearTimer()
		super.DeleteMe()
	}

	public StartTimer() {
		if (!this._timer) {
			this.ClearTimer()
			this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.UpdateTimer()
			}, 1)
			this.UpdateTimer()
		}
	}

	public ClearTimer() {
		if (this._timer) {
			GlobalTimerQuest.CancelQuest(this._timer)
			this._timer = null
		}
	}

	_gp_con: Laya.Box
	_lb_name: Laya.Label
	_lb_time: Laya.Label
	_img_line: Laya.Image
	_img_select: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._lb_name,
			this._lb_time,
			this._img_line,
			this._img_select,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_lb_name",
				"_lb_time",
				"_img_line",
				"_img_select",
			])
	}
}
window["dwMonItem"] = dwMonItem