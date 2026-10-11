import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { DailyModel, ServerTimeType, TodayType } from "../commonModel/DailyModel"
import { DepositModel, DepositSetting } from "../commonModel/DepositModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDeltaX, Util } from "../util/Util"

export class DepositItem extends BaseItemRenderer {
	public WIDTH = 694
	public HEIGT = 120

	model: DepositModel
	daily_model: DailyModel
	isOn
	deposit_data
	public constructor() {
		super()
		this.base_file = "deposit"
		this.layout_file = "DepositItem"
		this.model = DepositModel.GetInstance()
		this.daily_model = DailyModel.GetInstance()
		this.isOn = false
		this.Load()
	}

	public load_callback() {
		ResManager.GetInstance().SetImageSpriteTrans(this, this.bg, GameResPath.GetIcon("deposit", "uirw_003"))
		this.InitEvent()
	}

	public InitEvent() {

		let ClickFun = (target) => {
			// if (target == this.txt_setting) {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, DepositSetting[this.data.module_id + "@" + this.data.sub_module],
				{ "module_id": this.data.module_id, "sub_module": this.data.sub_module })
			// }
		}
		Util.AddClickEvent(this.txt_setting, ClickFun, this, true)
		// AddUnderLine(this, this.txt_setting)
		// this["_add_under_line"][this.txt_setting].raycastTarget = false

		// AddUnderLineAndClick(this, this.txt_setting, ClickFun)

		let check_fun = (target, x, y) => {
			this.isOn = !this.isOn
			this.SetCheckState()
			this.model.SetDeposit(this.data.module_id, this.data.sub_module, this.isOn)
			if (this.daily_model.need_tuo_guan_guide) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._cb_auto)
				let step = { "direction": 6, "text": "关闭界面", "force_show_img": 1 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, null, null, step, true)
			}
		}
		Util.AddClickEvent(this._cb_auto, check_fun, this, false)

		//this.cb_deposit.onValueChanged.AddListener((value?) => {
		//if (value ) {
		//// this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19202, this.data.module_id, this.data.sub_module)
		//}else{
		//// this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19203, this.data.module_id, this.data.sub_module)
		//}
		//this.model.SetDeposit(this.data.module_id, this.data.sub_module, value)
		//})

		this.BindEvent(this.model, DepositModel.DEPOSIT_SELECT, (scmd19202?) => {
			if (scmd19202.module_id == this.data.module_id && scmd19202.sub_module == this.data.sub_module) {
				//this.cb_deposit.isOn = true
				this.isOn = true
				this.SetCheckState()
			}
		})

		this.BindEvent(this.model, DepositModel.DEPOSIT_UNSELECT, (scmd19203?) => {
			if (scmd19203.module_id == this.data.module_id && scmd19203.sub_module == this.data.sub_module) {
				//this.cb_deposit.isOn = false
				this.isOn = false
				this.SetCheckState()
			}
		})
	}

	public SetCheckState() {
		this.CheckMask.visible = this.isOn == true
		// let source = this.isOn == true && "uity_045c" || "uity_045d"
		// ResManager.GetInstance().SetImageSprite(this, this._Image1, "common_asset", source)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this.data.module = this.data.module_id
			this.data.module_sub = this.data.sub_module
			let cond = ErlangParser.GetInstance().parse(this.data.condition)
			if (cond.length > 0) {
				this.data.ac_sub = Number(cond[0][0])
			} else {
				this.data.ac_sub = 0
			}
			let ac_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_ac", false);
			this.data.ac_cfg = ac_cfg[this.data.module_id + "@" + this.data.sub_module + "@" + this.data.ac_sub]
			if (this.data && this.data.ac_cfg) {
				this.title.text = this.data.ac_cfg.ac_name
				ResManager.GetInstance().SetImageSpriteTrans(this, this.icon, GameResPath.GetDailyIconPath(this.data.ac_cfg.ac_icon))
				this.SetTimeInfo()
			}
			this.deposit_data = this.model.GetDepositData(this.data.module_id, this.data.sub_module)
			if (this.deposit_data && this.deposit_data.select_time > 0) {
				//this.cb_deposit.isOn = true
				this.isOn = true
			} else {
				//this.cb_deposit.isOn = false
				this.isOn = false
			}
			this.SetCheckState()
			this.txt_setting.visible = DepositSetting[this.data.module_id + "@" + this.data.sub_module] != null
			this.txt2.text = `托管消耗：${this.data.cost_min}点/分钟`

			if (this.daily_model.need_tuo_guan_guide) {
				let step = { "direction": 8, "text": "点击此处即可进行托管~", "force_show_img": 1 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._cb_auto, "UI", null, null, null, null, step, true)
			} else {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._cb_auto)
			}
		}
	}



	public SetTimeInfo() {
		if (!this.data.ac_cfg) {
			return
		}
		// let server_time = TimeUtil.GetZoneTime()
		let dateObj = new Date(TimeUtil.GetZoneTime() * 1000);
		let weekday = dateObj.getDay()
		// let dateObj = os.date("*t", server_time)
		// let weekday = Number(os.date("%w", server_time))
		let isToday = false
		let dateList = JSON.parse(this.data.ac_cfg.time)
		let monthList = JSON.parse(this.data.ac_cfg.month)
		let weekList = JSON.parse(this.data.ac_cfg.week)
		let openDayList = JSON.parse(this.data.ac_cfg.open_day)
		let mergeDayList = JSON.parse(this.data.ac_cfg.merge_day)
		let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
		let mergeDay = ServerTimeModel.GetInstance().GetMergeServerDay()
		if (dateList.length > 0) { //具体年月日
			let date = null
			let obj = null
			let i = 0
			do {
				obj = dateList[i]
				if (obj) {
					if (Number(obj[0]) == dateObj.getFullYear() && Number(obj[1]) == dateObj.getMonth() && Number(obj[2]) == dateObj.getDay()) {
						isToday = true
						break
					} else if (Number(obj[0]) > dateObj.getFullYear()
						|| (Number(obj[0]) == dateObj.getFullYear() && Number(obj[1]) > dateObj.getMonth())
						|| (Number(obj[0]) == dateObj.getFullYear() && Number(obj[1]) == dateObj.getMonth() && Number(obj[2]) > dateObj.getDay())) {
						date = obj
						break
					}
				}
				i = i + 1
			} while ((i < dateList.length))
			let [str_arr, state] = this.daily_model.GetTimeStr(this.data.ac_cfg.time_region)
			this.time.text = date[0] + "年" + date[1] + "月" + date[2] + "日 \n" + str_arr[0] + "~" + str_arr[1]
			// this.SetTodayBtnState(isToday)
			return
		}
		if (monthList && monthList.length != 0) {
			let isNextMonth = false
			let nextDay = 0
			let vo = null
			let i = 0
			do {
				vo = Number(monthList[i])
				if (dateObj.getDay() == vo) {
					isToday = true
					break
				} else if (dateObj.getDay() < vo) {
					isNextMonth = false
					nextDay = vo
					break
				} else if (dateObj.getDay() > Number(monthList[monthList.length - 1])) {
					isNextMonth = true
					break
				}
				i = i + 1
			} while ((i < monthList.length))
			if (isNextMonth) {
				let [str_arr, state] = this.daily_model.GetTimeStr(this.data.ac_cfg.time_region)
				this.time.text = dateObj.getMonth() + 1 + "月" + monthList[0] + "日 " + str_arr[0] + "~" + str_arr[1]
			} else {
				let [str_arr, state] = this.daily_model.GetTimeStr(this.data.ac_cfg.time_region)
				this.time.text = dateObj.getMonth() + "月" + nextDay + "日 " + str_arr[0] + "~" + str_arr[1]
			}
			// this.SetTodayBtnState(isToday)
			return
		}
		if (weekList && weekList.length != 0) {
			let vo = null
			let i = 0
			do {
				vo = Number(weekList[i])
				if (vo) {
					if ((vo == weekday) || (vo == 7 && weekday == 0)) {
						isToday = true
						break
					}
				}
				i = i + 1
			} while ((i < weekList.length))
			let [week_str, every_day] = this.GetWeekTimeStr()
			let [str_arr, state] = this.daily_model.GetTimeStr(this.data.ac_cfg.time_region)
			if (every_day) {
				this.time.text = week_str + " " + str_arr[0] + "~" + str_arr[1]
			} else {
				this.time.text = week_str + " \n" + str_arr[0] + "~" + str_arr[1]
			}
			if ((mergeDay > 0 && mergeDayList.length > 0 && mergeDay >= Number(mergeDayList[0][0]) && Number(mergeDayList[0][1]) >= mergeDay)
				|| (openDay > 0 && openDayList.length > 0 && openDay >= Number(openDayList[0][0]) && Number(openDayList[0][1]) >= openDay)) {
				if (mergeDay > 0 && mergeDayList.length > 0 && Number(mergeDayList[0][0]) > 0) {
					this.SetOpenOrMergeDayStr(mergeDayList, mergeDay, ServerTimeType.MergeDay)
				} else if (openDayList.length > 0) {
					this.SetOpenOrMergeDayStr(openDayList, openDay, ServerTimeType.OpenDay)
				}
			} else {
				// this.SetTodayBtnState(isToday)
			}
			return
		}
		if ((dateList.length == 0 && monthList.length == 0) && weekList.length == 0) {
			if (mergeDay > 0 && mergeDayList.length > 0) {
				this.SetOpenOrMergeDayStr(mergeDayList, mergeDay, ServerTimeType.MergeDay)
			} else if (openDayList.length > 0) {
				this.SetOpenOrMergeDayStr(openDayList, openDay, ServerTimeType.OpenDay)
			} else {
				let [str_arr, state] = this.daily_model.GetTimeStr(this.data.ac_cfg.time_region)
				let [week_str, every_day] = this.GetWeekTimeStr()
				if (every_day) {
					this.time.text = week_str + " " + str_arr[0] + "~" + str_arr[1]
				} else {
					this.time.text = week_str + " \n" + str_arr[0] + "~" + str_arr[1]
				}
				// this.SetTodayBtnState(true)
			}
		}
	}

	public SetOpenOrMergeDayStr(dayList?, day?, flag?) {

		let serverStr = flag == ServerTimeType.MergeDay && "合服" || "开服"
		let dayData = this.daily_model.GetOpenOrMergeDayByCfg(dayList, day)
		let [start_second, start_lv, state, end_second, now_second, isToday] = this.daily_model.GetActivityStartSecAndStartLv(this.data, TimeUtil.GetZoneTime())
		isToday = isToday == TodayType.Yes && true || false
		if (dayData) {
			let startDay = Number(dayData[0])
			let endDay = Number(dayData[1])
			let [str_arr, state] = this.daily_model.GetTimeStr(this.data.ac_cfg.time_region)
			let [week_str, every_day] = this.GetWeekTimeStr()
			this.time.text = serverStr + "第" + startDay + "天以上\n" + week_str + " " + str_arr[0] + "~" + str_arr[1]
			// this.SetTodayBtnState(isToday)
		} else {
			this.time.text = ""
			// this.SetTodayBtnState(false)
		}
	}

	public GetWeekTimeStr() {

		let weekList = JSON.parse(this.data.ac_cfg.week)
		let str = "周"
		let every_day = false
		if (weekList) {
			if (weekList.length == 7 || weekList.length == 0) {
				str = "每天"
				every_day = true
				return [str, every_day]
			}
			let i = 0
			do {
				if (weekList[i]) {
					if (Number(weekList[i]) == 7) {
						if (weekList.length == 1) {
							str = str + "日"
						} else {
							str = str + "、日"
						}
					} else if (i == 0) {
						str = str + WordManager.NumConvertStage(weekList[i])
					} else {
						str = str + "、" + WordManager.NumConvertStage(weekList[i])
					}
				}
				i = i + 1
			} while ((i < weekList.length))
		}
		return [str, every_day]
	}


	public DeleteMe() {

		super.DeleteMe()
	}

	bg: Laya.Image
	_Image11: Laya.Image
	title: Laya.Label
	_Image2: Laya.Image
	icon: Laya.Image
	time: Laya.Label
	condition: Laya.Label
	click_bg: Laya.Box
	_cb_auto: Laya.Box
	_Image1: Laya.Image
	CheckMask: Laya.Image
	labelDisplay: Laya.Label
	txt1: Laya.Label
	txt2: Laya.Label
	txt_setting: Laya.Label
	img1: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this._Image11,
			this.title,
			this._Image2,
			this.icon,
			this.time,
			this.condition,
			this.click_bg,
			this._cb_auto,
			this._Image1,
			this.CheckMask,
			this.labelDisplay,
			this.txt1,
			this.txt2,
			this.txt_setting,
			this.img1,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image11",
				"title",
				"_Image2",
				"icon",
				"time",
				"condition",
				"click_bg",
				"_cb_auto",
				"_Image1",
				"CheckMask",
				"labelDisplay",
				"txt1",
				"txt2",
				"txt_setting",
				"img1",
			])
	}
}
window["DepositItem"] = DepositItem