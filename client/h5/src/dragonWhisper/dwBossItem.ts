import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { ResManager } from "../common/ResManager"
import { GlobalTimerQuest } from "../util/Util"
import { DrWsEvent, DragonWhisperModel } from "../commonModel/DragonWhisperModel"

export class dwBossItem extends BaseItem1 {
	_data
	_timer
	_type

	public constructor(parent?, type?) {
		super(parent)
		this.base_file = "dragonWhisper"
		this.layout_file = "dwBossItem"

		this.load_callback = () => {
			if (type == null) {
				type = 1
			}
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public SetType(type?) {
		this._type = type
	}

	public InitEvent() {
		Util.AddClickEvent(this._Group4, () => {
			DragonWhisperModel.GetInstance().Fire(DrWsEvent.SELECT_BOSS_ITEM, this._data)
		}, this, true)

		this.BindEvent(DragonWhisperModel.GetInstance(), DrWsEvent.SELECT_BOSS_ITEM, (data?) => {
			this.SetSelect(this._data == data)
		})

		this.BindEvent(DragonWhisperModel.GetInstance(), DrWsEvent.UPDATE_BOSS_ALIVE, (vo?) => {
			if (this._data.mon_id == vo.mon_id) {
				this._data.reborn_time = vo.reborn_time
				this.TimerStart(vo.reborn_time)
			}
		})
	}

	public LoadSuccess() {
		// if (this._type == 1) {
		// 	ResManager.GetInstance().SetImageSprite(this, this._img_icon, "dragonWhisper", "uilyboss_003")
		// } else {
		// 	ResManager.GetInstance().SetImageSprite(this, this._img_icon, "dragonWhisper", "uilyboss_001")
		// }
	}

	public SetData(data?) {
		this._data = data
		let dead = data.reborn_time && true || false
		let url = "client/assets/icon/monsterHead/" + data.icon + ".png"
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mon, url)
		Util.SetImageGray(this._img_icon, dead)
		if (data.reborn_time) {
			this.TimerStart(data.reborn_time)
		} else {
			this._lb_time.text = ""
		}
		let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
		let md = mon_cfg[data.mon_id]
		this._lb_lv.text = md && md.mon_stage + "阶" || ""
	}

	public SetSelect(bool?) {
		this._img_select.visible = bool
		this._gp_mon.visible = bool
	}

	public TimerStart(refresh_time?) {
		this.ClearTimer()
		this._timer = GlobalTimerQuest.AddPeriodQuest(this.UpdateTimer, 1)
		this._lb_time.color = ColorUtil.TryParseHtmlString("#ff4f50")
		this.UpdateTimer()
	}

	public UpdateTimer() {
		let left_time = this._data.reborn_time - TimeUtil.getServerTime()
		if (left_time < 0) {
			this._lb_time.text = "已复活"
			this._lb_time.color = ColorUtil.TryParseHtmlString("#b3ff48")
			Util.SetImageGray(this._img_icon, false)
			this.ClearTimer()
		} else {
			let time = TimeUtil.convertTime(left_time)
			this._lb_time.text = time
		}
	}

	public ClearTimer() {
		if (this._timer) {
			this._timer = GlobalTimerQuest.CancelQuest(this._timer)
			this._timer = null
		}
	}
	public DeleteMe() {
		this.ClearTimer()
		super.DeleteMe()
	}

	_Group4: Laya.Box
	_Group3: Laya.Box
	_gp_icon: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_img_select: Laya.Image
	_Group2: Laya.VBox
	_img_lv: Laya.Image
	_lb_lv: Laya.Label
	_lb_time: Laya.Label
	_gp_mon: Laya.Box
	_Image2: Laya.Image
	_img_mon: Laya.Image
	public GetComponents() {
		[
			this._Group4,
			this._Group3,
			this._gp_icon,
			this._img_bg,
			this._img_icon,
			this._img_select,
			this._Group2,
			this._img_lv,
			this._lb_lv,
			this._lb_time,
			this._gp_mon,
			this._Image2,
			this._img_mon,
		]
			= this.GetChildrenByNames([

				"_Group4",
				"_Group3",
				"_gp_icon",
				"_img_bg",
				"_img_icon",
				"_img_select",
				"_Group2",
				"_img_lv",
				"_lb_lv",
				"_lb_time",
				"_gp_mon",
				"_Image2",
				"_img_mon",
			])
	}
}
window["dwBossItem"] = dwBossItem