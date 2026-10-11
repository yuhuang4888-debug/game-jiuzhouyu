import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { DailyModel, ServerTimeType, TodayType, ActivityState } from "../commonModel/DailyModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SettingModel } from "../commonModel/SettingModel"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetAnchoredPositionY, TransformLevel } from "../util/Util"
import { DailyEvent } from "./DailyEvent"


export class DailyLimitActivityItem extends BaseItemRenderer {
	public WIDTH = 344
	public HEIGT = 120
	btn_pre_str
	model
	public constructor() {
		super()
		this.base_file = "daily"
		this.layout_file = "DailyLimitActivityItem"
		this.btn_pre_str = "预约"
		this.model = DailyModel.GetInstance()
		this.Load()
	}


	public load_callback() {
		this.time.leading = 4
		Util.SetImageGray(this.endBtn, true)
		this.InitEvents()
	}

	public InitEvents() {


		let btn_fun = () => {
			if (this.data) {
				// let is_double_escort = EscortModel.GetInstance().IsDoubleEscort(this.data.module, this.data.module_sub, this.data.ac_sub)
				// if (is_double_escort) {
				// 	let escmodel = EscortModel.GetInstance()
				// 	let escort = this.model.GetDailyTaskVo(escmodel.EscortModule, escmodel.EscortSubModule, escmodel.EscortFunId)
				// 	if ((escort && escort.liveness_cfg) && escort.liveness_cfg.max <= escort.num) {
				// 		Message.show("今日护送次数已满")
				// 		return
				// 	}
				// }
				if (this.data.res) {
					this.model.Fire(DailyEvent.DAILY_CLOSE_VIEW, "DailyView")
					OpenFun.OpenFunHandler(this.data.ac_cfg.jump_id)
				} else {
					this.model.Fire(DailyEvent.DAILY_REQUEST_PROTO, 15719, "iii", this.data.module, this.data.module_sub, this.data.ac_sub)

					//拉起微信订阅权限 
					let s_model = SettingModel.GetInstance()
					if (s_model.CheckSubsOpen()) {
						let cfg = s_model.GetWxCfgByDesc(this.title.text)
						if (cfg&&!s_model.WxCheckAntiKey(cfg.temp_id)) {
							let is_subscription = s_model.CheckWxSubsState(cfg.id)
							if (!is_subscription) {
								// Message.show("更新订阅")
								PlatformManager.GetInstance().WeChatSubscriptionSH(cfg.id)
							}
						}
					}
					//1vn预约的时候顺手帮报名
					if(this.data.ac_cfg&&this.data.ac_cfg.module==621){
						let kf_model = Kf1vnModel.GetInstance()
						if (kf_model.stage_info&&kf_model.stage_info.stage == 1) {
							if (!kf_model.page_info || kf_model.page_info.is_sign == 0) {
								kf_model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62102)
							}
						}
					}

				}
			}
		}
		Util.AddClickEvent(this.goBtn, btn_fun, this, true)

		let click_bg_fun = () => {
			if (this.data) {
				this.model.Fire(DailyEvent.OPEN_VIEW, "DailyLimitActivityTipsView", this.data)
			}
		}
		Util.AddClickEvent(this.click_bg, click_bg_fun, this, true)

		let endBtn_fun = () => {
			Message.show("未开启")
		}
		Util.AddClickEvent(this.endBtn, endBtn_fun, this, true)


		Util.AddClickEvent(this.gotBtn, () => {
			//领取预约奖励

			//拉起微信订阅权限 
			let s_model = SettingModel.GetInstance()
			if (s_model.CheckSubsOpen()) {
				let cfg = s_model.GetWxCfgByDesc(this.title.text)
				if (cfg) {
					if(!s_model.WxCheckAntiKey(cfg.temp_id)){
						let is_subscription = s_model.CheckWxSubsState(cfg.id)
						if (!is_subscription) {
							// Message.show("更新订阅")
							PlatformManager.GetInstance().WeChatSubscriptionSH(cfg.id,true,this.data.module, this.data.module_sub, this.data.ac_sub)
							return
						}
					}
				}
			}

			this.model.Fire(DailyEvent.DAILY_REQUEST_PROTO, 15720, "iii", this.data.module, this.data.module_sub, this.data.ac_sub)
			
		}, this, true)

		this.BindEvent(this.model, DailyEvent.RESERVATION, (scmd?) => {
			if (this.data && this.data.module == scmd.module) {
				this.dataChanged()
			}
		})
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data && this.data.ac_cfg) {
				this.title.text = this.data.ac_cfg.ac_name
				ResManager.GetInstance().SetImageSpriteTrans(this, this.icon, GameResPath.GetDailyIconPath(this.data.ac_cfg.ac_icon))
				this.SetTimeInfo()
			}
		}
	}

	public SetLiveness(show?) {
		if (this.data && show) {
			if (this.data.liveness_cfg) {
				let data = this.data
				// let is_double_escort = EscortModel.GetInstance().IsDoubleEscort(this.data.module, this.data.module_sub, this.data.ac_sub)
				// if (is_double_escort) {
				// 	let escmodel = EscortModel.GetInstance()
				// 	let escort = this.model.GetDailyTaskVo(escmodel.EscortModule, escmodel.EscortSubModule, escmodel.EscortFunId)
				// 	if (escort) {
				// 		data = escort
				// 	}
				// }
				let show_live = data.live + data.can_get_live
				let str = ""
				let liveness = ""
				if (data.liveness_cfg.max == 0) {
					str = "次数:<font color='#0a953e'>" + data.num + "</font>/不限"
					liveness = "活跃:<font color='#0a953e'>" + show_live + "</font>/无限"
				} else if (data.num < data.liveness_cfg.max) {
					str = "次数:<font color='#0a953e'>" + data.num + "</font>/" + data.liveness_cfg.max
					liveness = "活跃:<font color='#0a953e'>" + show_live + "</font>/" + data.liveness_cfg.live * data.liveness_cfg.max
				} else {
					str = "次数:<font color='#0a953e'>" + data.num + "</font>/" + data.liveness_cfg.max
					liveness = "活跃:<font color='#0a953e'>" + show_live + "</font>/" + data.liveness_cfg.live * data.liveness_cfg.max
				}
				let desc = ""
				desc = (data.liveness_cfg.live > 0 && (str + " " + liveness) || str)
				this.huoyue.style.fontSize = 18
				this.huoyue.width = 220
				this.huoyue.style.color = "#5a1c20"
				this.huoyue.innerHTML = desc
			} else {
				this.huoyue.innerHTML = ""
			}
		} else {
			this.huoyue.innerHTML = ""
		}
	}

	public SetTimeInfo() {
		if (!this.data.ac_cfg) {
			return
		}
		// let server_time = TimeUtil.GetZoneTime()
		// let dateObj = os.date("*t", server_time)
		// let dateObj = os.date("*t", server_time)
		// let weekday = Number(os.date("%w", server_time))

		let dateObj = new Date(TimeUtil.GetZoneTime() * 1000);
		let weekday = dateObj.getDay()

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
			let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
			this.time.text = date[0] + "年" + date[1] + "月" + date[2] + "日 \n" + str_arr[0] + "~" + str_arr[1]
			this.SetTodayBtnState(isToday)
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
				let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
				this.time.text = dateObj.getMonth() + 1 + "月" + monthList[0] + "日 " + str_arr[0] + "~" + str_arr[1]
			} else {
				let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
				this.time.text = dateObj.getMonth() + "月" + nextDay + "日 " + str_arr[0] + "~" + str_arr[1]
			}
			this.SetTodayBtnState(isToday)
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
			let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
			if (every_day) {
				this.time.text = week_str + " " + str_arr[0] + "~" + str_arr[1]
			} else {
				this.time.text = week_str + " \n" + str_arr[0] + "~" + str_arr[1]
			}
			if ((mergeDay > 0 && mergeDayList.length > 0 && mergeDay < Number(mergeDayList[0][0])) //&& Number(mergeDayList[0][1]) >= mergeDay
				|| (openDay > 0 && openDayList.length > 0 && openDay < Number(openDayList[0][0]))) {//&& Number(openDayList[0][1]) >= openDay
				if (mergeDay > 0 && mergeDayList.length > 0 && Number(mergeDayList[0][0]) > 0) {
					this.SetOpenOrMergeDayStr(mergeDayList, mergeDay, ServerTimeType.MergeDay)
				} else if (openDayList.length > 0) {
					this.SetOpenOrMergeDayStr(openDayList, openDay, ServerTimeType.OpenDay)
				}
			} else {
				this.SetTodayBtnState(isToday)
			}
			return
		}
		if ((dateList.length == 0 && monthList.length == 0) && weekList.length == 0) {
			if (mergeDay > 0 && mergeDayList.length > 0) {
				this.SetOpenOrMergeDayStr(mergeDayList, mergeDay, ServerTimeType.MergeDay)
			} else if (openDayList.length > 0) {
				this.SetOpenOrMergeDayStr(openDayList, openDay, ServerTimeType.OpenDay)
			} else {
				let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
				let [week_str, every_day] = this.GetWeekTimeStr()
				if (every_day) {
					this.time.text = week_str + " " + str_arr[0] + "~" + str_arr[1]
				} else {
					this.time.text = week_str + " \n" + str_arr[0] + "~" + str_arr[1]
				}
				this.SetTodayBtnState(true)
			}
		}
	}

	public SetOpenOrMergeDayStr(dayList?, day?, flag?) {
		let serverStr = flag == ServerTimeType.MergeDay && "合服" || "开服"
		let dayData = this.model.GetOpenOrMergeDayByCfg(dayList, day)
		let [start_second, start_lv, state, end_second, now_second, isToday] = this.model.GetActivityStartSecAndStartLv(this.data, TimeUtil.GetZoneTime())
		isToday = isToday == TodayType.Yes && true || false
		//state = this.model.GetAcyivityRealState(this.data, state)
		if (dayData) {
			let startDay = Number(dayData[0])
			let endDay = Number(dayData[1])
			let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
			let [week_str, every_day] = this.GetWeekTimeStr()
			this.time.text = serverStr + "第" + startDay + "天以上\n" + week_str + " " + str_arr[0] + "~" + str_arr[1]
			//if (startDay - day > 0 && state != ActivityState.Closed ) {
			//this:SetTodayBtnState(false)
			//}else{
			this.SetTodayBtnState(isToday)
			//}
		} else {
			this.time.text = ""
			this.SetTodayBtnState(false)
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

	public SetTodayBtnState(isToday?) {
		this.resRed.visible = false
		this.goBtn.visible = false
		this.endBtn.visible = false
		this.end_tag.visible = false
		this.data.res = true
		this.SetLiveness(false)
		this.time.visible = false
		this.black_bg.visible = false
		this.resImg.visible = false
		this.destiny_img.visible = false
		this.gotBtn.visible = false
		if (this.data.state == ActivityState.Unopened) {  //等级限制
			this.black_bg.visible = true
			this.condition.visible = true
			let lv = Number(this.data.ac_cfg.start_lv)
			let level = lv > 370 && lv - 370 || lv
			this.condition.text = level + "级开启"
			let show_destiny = lv > 370
			this.destiny_img.visible = show_destiny
			this.condition.x = show_destiny ? 145 : 120
		} else {
			this.condition.visible = false
			if (isToday) {
				this.SetLiveness(true)
				let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
				let reservation = this.model.GetResStatus(this.data.module, this.data.module_sub, this.data.ac_sub)
				if (this.data.state == 1 && ((this.data.module != 137 && this.data != 621) || state == ActivityState.Opening)) {
					this.goBtn.visible = true
					this.goBtnLabel.text = "前往"
					if(state == ActivityState.Opening){
						this.resImg.visible = reservation&&reservation > 0
					}
				} else {
					
					if (state == ActivityState.Unopened) {
						this.goBtn.visible = true
						if(this.model.CheckActIsReachDay(this.data) && this.model.CheckActIsReachLevel(this.data)&&reservation != null){
							this.resImg.visible = reservation > 0
							this.goBtnLabel.text = reservation > 0 && str_arr[0] || this.btn_pre_str
							this.resRed.visible = reservation==0
							this.data.res = reservation > 0
						} else {
							this.goBtnLabel.text = str_arr[0]
						}
					} else if (state == ActivityState.Opening) {
						this.resImg.visible = reservation&&reservation > 0
						this.endBtn.visible = true
						this.endBtnLabel.text = "未开启"
						this.black_bg.visible = true
						this.SetLiveness(false)
						this.time.visible = true
					} else {
						//活动结束+已报名+有参与才能领取预约奖励
						if(this.model.CheckIsJoin(this.data.module, this.data.module_sub, this.data.ac_sub)){
							if (reservation==null||reservation == 2) {
								//已领取
								this.end_tag.visible = true
								this.black_bg.visible = true
							} else {
								//未领取
								this.resRed.visible = true
								this.gotBtn.visible = true
							}
						}else{
							//没有参与活动
							this.end_tag.visible = true
							this.black_bg.visible = true
						}
					

					}
				}
			} else {
				this.endBtn.visible = true
				this.endBtnLabel.text = "未开启"
				this.black_bg.visible = true
				this.time.visible = true
			}
		}
	}



	bg: Laya.Image
	title: Laya.Label
	huoyue: Laya.HTMLDivElement
	_Image2: Laya.Image
	icon: Laya.Image
	time: Laya.Label
	destiny_img: Laya.Image
	condition: Laya.Label
	click_bg: Laya.Box
	goBtn: Laya.Box
	goBtnImg: Laya.Image
	goBtnLabel: Laya.Label
	endBtn: Laya.Box
	endBtnImg: Laya.Image
	endBtnLabel: Laya.Label
	gotBtn: Laya.Box
	gotBtnImg: Laya.Image
	gotBtnLabel: Laya.Label
	end_tag: Laya.Image
	resImg: Laya.Image
	resRed: Laya.Image
	black_bg: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.title,
			this.huoyue,
			this._Image2,
			this.icon,
			this.time,
			this.destiny_img,
			this.condition,
			this.click_bg,
			this.goBtn,
			this.goBtnImg,
			this.goBtnLabel,
			this.endBtn,
			this.endBtnImg,
			this.endBtnLabel,
			this.gotBtn,
			this.gotBtnImg,
			this.gotBtnLabel,
			this.end_tag,
			this.resImg,
			this.resRed,
			this.black_bg,
		]
			= this.GetChildrenByNames([

				"bg",
				"title",
				"huoyue",
				"_Image2",
				"icon",
				"time",
				"destiny_img",
				"condition",
				"click_bg",
				"goBtn",
				"goBtnImg",
				"goBtnLabel",
				"endBtn",
				"endBtnImg",
				"endBtnLabel",
				"gotBtn",
				"gotBtnImg",
				"gotBtnLabel",
				"end_tag",
				"resImg",
				"resRed",
				"black_bg",
			])
	}
}
window["DailyLimitActivityItem"] = DailyLimitActivityItem