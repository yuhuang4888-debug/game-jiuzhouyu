import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DailyModel } from "../commonModel/DailyModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { DailyCalendarItem } from "./DailyCalendarItem"


export class DailyCalendarView extends BaseView1 {
	FormatList
	HasActivity
	InitEvent
	IsEmptyDay
	LoadSuccess
	OpenCallback
	SetCalendar
	SetTodayBg
	public constructor() {
		super()
		let model = DailyModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let _item_list = []
		let _toady_bg_pos_x = null
		let _config_week_calendar = null
		this.base_file = "daily"
		this.layout_file = "DailyCalendarView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_week_calendar": false,
		}
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			for (let _tmpi in _item_list) {
				var item = _item_list[_tmpi]
				item.DeleteMe()
			}
			_item_list = []
			_config_week_calendar = null
		}

		this.LoadSuccess = () => {
			this.scroll.hScrollBar.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("daily", "uirw_02122"))
			_config_week_calendar = ResManager.GetInstance().GetGameConfigFromCache(this, "config_week_calendar", false)
			if (!_toady_bg_pos_x) {
				_toady_bg_pos_x = this.today_bg.x
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.click_bg, () => {
				this.Close()
			}, this, false)
		}

		this.OpenCallback = () => {
			let calendar_list = this.FormatList()
			this.SetCalendar(calendar_list)
			this.SetTodayBg(calendar_list.length)
		}

		this.FormatList = () => {
			let calendar_list = []
			if (_config_week_calendar) {
				let empty_activity_in_hour = false
				let curTime = TimeUtil.GetZoneTime()
				let date = new Date(curTime * 1000)
				let weekday = date.getDay()
				//let weekday = Number(os.date("%w",local_TimeUtil.getServerTime()))
				if (weekday == 0) {
					weekday = 7
				}
				for (let key in _config_week_calendar) {
					let cfg = Util.DeepCopy(_config_week_calendar[key])
					empty_activity_in_hour = this.IsEmptyDay(cfg, Number(weekday))
					if (!empty_activity_in_hour) {
						table.insert(calendar_list, cfg)
					}
				}
			}
			let sort_fun = (a?, b?) => {
				return a.cfg_if < b.cfg_if
			}
			table.sort(calendar_list, sort_fun)
			return calendar_list
		}

		this.SetCalendar = (list?) => {
			if (list) {
				let item = null
				let i = 0
				do {
					item = _item_list[i]
					if (!item) {
						item = new DailyCalendarItem(this.Content)
						item.Load()
						_item_list[i] = item
					}
					item.SetData(list[i])
					i = i + 1
				} while ((i < list.length))
				let y = Math.abs(this.scroll.y)
				let height_y = (list.length + 1) * 66 + y + 46
				if (list.length < 6) {
					height_y = 6 * 66 + y + 46
				}
				this.bg.height = height_y
				this.scroll.height = list.length * 66
				this.close_tip.y = height_y + 50
				this.display_obj.height = height_y + 56
				this.display_obj.centerX = this.display_obj.centerY = 0
			}
		}

		this.IsEmptyDay = (cfg?, weekday?) => {
			let is_empty = false
			if (cfg) {
				if (this.HasActivity(cfg.day_1, 1, weekday)) {
					return false
				}
				if (this.HasActivity(cfg.day_2, 2, weekday)) {
					return false
				}
				if (this.HasActivity(cfg.day_3, 3, weekday)) {
					return false
				}
				if (this.HasActivity(cfg.day_4, 4, weekday)) {
					return false
				}
				if (this.HasActivity(cfg.day_5, 5, weekday)) {
					return false
				}
				if (this.HasActivity(cfg.day_6, 6, weekday)) {
					return false
				}
				if (this.HasActivity(cfg.day_7, 7, weekday)) {
					return false
				}
			}
			return true
		}

		this.HasActivity = (activity_str?, no?, weekday?) => {
			let has_activity = false
			if (activity_str && activity_str != "") {
				let list = JSON.parse(activity_str)
				let count = 0
				if (list && list.length > 0) {
					let open_server_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					let real_open_server_day = open_server_day
					if (weekday <= no) {
						real_open_server_day = open_server_day + no - weekday
					} else {
						real_open_server_day = open_server_day - weekday - no
						if (real_open_server_day <= 0) {
							real_open_server_day = 1
						}
					}
					let vo = null
					let cfg = null
					let i = 0
					do {
						vo = list[i]
						if (real_open_server_day >= Number(vo[3]) && real_open_server_day <= Number(vo[4])) {
							cfg = model.GetAcCfg(vo[0], vo[1], vo[2])
							if (cfg) {
								has_activity = true
								break
							}
						}
						i = i + 1
					} while ((i < list.length))
				}
			}
			return has_activity
		}

		this.SetTodayBg = (len?) => {
			let curTime = TimeUtil.GetZoneTime()
			let date = new Date(curTime * 1000)
			// let weekday = Number(os.date("%w", curTime))
			//let weekday = Number(os.date("%w",local_TimeUtil.getServerTime()))
			let weekday = date.getDay()
			if (weekday == 0) {  //代表是星期日
				weekday = 7
			}
			let x = _toady_bg_pos_x + (weekday - 1) * 87
			this.today_bg.x = x
			if (weekday == 7) {
				this.today_bg.height = 45 + len * 66
			} else {
				this.today_bg.height = 45 + len * 66
			}
		}
	}

	click_bg: Laya.Box
	bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	today_bg: Laya.Image
	scroll: Laya.Panel
	Content: Laya.VBox
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	_Label6: Laya.Label
	_Label7: Laya.Label
	_Label8: Laya.Label
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	close_tip: Laya.Label
	public GetComponents() {
		[
			this.click_bg,
			this.bg,
			this._Image1,
			this._Image2,
			this.today_bg,
			this.scroll,
			this.Content,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._Label5,
			this._Label6,
			this._Label7,
			this._Label8,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this.close_tip,
		]
			= this.GetChildrenByNames([

				"click_bg",
				"bg",
				"_Image1",
				"_Image2",
				"today_bg",
				"scroll",
				"Content",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_Label5",
				"_Label6",
				"_Label7",
				"_Label8",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"close_tip",
			])
	}
}
window["DailyCalendarView"] = DailyCalendarView